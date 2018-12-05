﻿
&НаКлиенте
Процедура ТорговаяТочкаПриИзменении(Элемент)
	
	Запись.ПомощникУправляющего_ТТ 	= Неопределено;
	Запись.Терминал 				= Неопределено;
	Запись.НомерКассы 				= "Выберите кассу";
	Запись.ТелефонТТ 				= "";
	
	//+++АК mika 2018.07.04 ИП-00019068 Исправление ошибок определения Помощника ТУ
	//УстановитьУправляющегоИТелефонТТ();
	
	Запись.СтаршийПродавец = ПредопределенноеЗначение("Справочник.ФизическиеЛица.ПустаяСсылка");
	
	Если ЗначениеЗаполнено(Запись.ТорговаяТочка) Тогда
		ЗаполнитьДополнительныеСведенияПоСтруктурнойЕдинице();
	КонецЕсли;
	
	//---АК mika 
			
КонецПроцедуры

&НаСервере
Процедура УстановитьУправляющегоИТелефонТТ()
	
	//
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("СтруктурнаяЕдиница", Запись.ТорговаяТочка);
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	ПомощникиУправляющихВТорговыхТочках.ФизическоеЛицо
	|ИЗ
	|	РегистрСведений.ПомощникиУправляющихВТорговыхТочках КАК ПомощникиУправляющихВТорговыхТочках
	|ГДЕ
	|	ПомощникиУправляющихВТорговыхТочках.СтруктурнаяЕдиница = &СтруктурнаяЕдиница";
	Выборка = Запрос.Выполнить().Выбрать();

	Запись.ПомощникУправляющего_ТТ 		= Неопределено;
	Пока Выборка.Следующий() Цикл
		Запись.ПомощникУправляющего_ТТ 	= Выборка.ФизическоеЛицо;
	КонецЦикла;
	
	//
	Запись.ТелефонТТ = Запись.ТорговаяТочка.ТелефонныйНомер1;
	
КонецПроцедуры	

&НаСервере

// Заполнаяет записть даннными о помощнике управляющего, старшем продавце и телефоне //+++АК mika 2018.07.04 ИП-00019068
//
Процедура ЗаполнитьДополнительныеСведенияПоСтруктурнойЕдинице()
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
	"ВЫБРАТЬ РАЗРЕШЕННЫЕ
	|	МАКСИМУМ(Таб_Итоговая.ТелефонТТ) КАК ТелефонТТ,
	|	МАКСИМУМ(Таб_Итоговая.ПомощникУправляющего_ТТ) КАК ПомощникУправляющего_ТТ,
	|	МАКСИМУМ(Таб_Итоговая.СтаршийПродавец) КАК СтаршийПродавец,
	|	МАКСИМУМ(Таб_Итоговая.ТелефонПродавца) КАК ТелефонПродавца
	|ИЗ
	|	(ВЫБРАТЬ
	|		ВЫРАЗИТЬ(СоответствиеОбъектРольСрезПоследних.Объект КАК Справочник.СтруктурныеЕдиницы).ТелефонныйНомер1 КАК ТелефонТТ,
	|		РолиПользователейСоставРоли.Сотрудник КАК ПомощникУправляющего_ТТ,
	|		ЗНАЧЕНИЕ(Справочник.ФизическиеЛица.Пустаяссылка) КАК СтаршийПродавец,
	|		"""" КАК ТелефонПродавца
	|	ИЗ
	|		РегистрСведений.СоответствиеОбъектРоль.СрезПоследних(&ТекущаяДата, Объект = &СтруктурнаяЕдиница) КАК СоответствиеОбъектРольСрезПоследних
	|			ВНУТРЕННЕЕ СОЕДИНЕНИЕ Справочник.РолиПользователей.СоставРоли КАК РолиПользователейСоставРоли
	|			ПО СоответствиеОбъектРольСрезПоследних.РольПользователя = РолиПользователейСоставРоли.Ссылка
	|	ГДЕ
	|		СоответствиеОбъектРольСрезПоследних.ТипРоли = ЗНАЧЕНИЕ(ПланВидовХарактеристик.ТипыРолейПользователя.ПомощникТерриториальногоУправляющего)
	|	
	|	ОБЪЕДИНИТЬ
	|	
	|	ВЫБРАТЬ
	|		"""",
	|		ЗНАЧЕНИЕ(Справочник.ФизическиеЛица.Пустаяссылка),
	|		ТабельРаботыПродавцов.Сотрудник,
	|		ПОДСТРОКА(КонтактнаяИнформация.Представление, 1, 50)
	|	ИЗ
	|		РегистрСведений.ТабельРаботыПродавцов КАК ТабельРаботыПродавцов
	|			ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.КонтактнаяИнформация КАК КонтактнаяИнформация
	|			ПО ТабельРаботыПродавцов.Сотрудник = КонтактнаяИнформация.Объект
	|				И (КонтактнаяИнформация.Вид = ЗНАЧЕНИЕ(Справочник.ВидыКонтактнойИнформации.ТелефонСлужебный))
	|	ГДЕ
	|		ТабельРаботыПродавцов.Период = НАЧАЛОПЕРИОДА(&ТекущаяДата, ДЕНЬ)
	|		И ТабельРаботыПродавцов.ТорговаяТочка = &СтруктурнаяЕдиница
	|		И ТабельРаботыПродавцов.СвойствоПродавца = 2) КАК Таб_Итоговая";
	
	Запрос.УстановитьПараметр("СтруктурнаяЕдиница", Запись.ТорговаяТочка);
	Запрос.УстановитьПараметр("ТекущаяДата", ?(ЗначениеЗаполнено(Запись.Период), Запись.Период, ТекущаяДата()));
	
	РезультатЗапроса = Запрос.Выполнить();
	
	Если Не РезультатЗапроса.Пустой() Тогда
		
		Выборка = РезультатЗапроса.Выбрать();
		Выборка.Следующий();
		
		ЗаполнитьЗначенияСвойств(Запись, Выборка);
		
	КонецЕсли;

КонецПроцедуры // ЗаполнитьДополнительныеСведенияПоСтруктурнойЕдинице()

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если НЕ ЗначениеЗаполнено(Запись.GUID_Строки) Тогда
		Запись.GUID_Строки = Новый УникальныйИдентификатор;
	КонецЕсли;
	
	//Если Не ЗначениеЗаполнено(Запись.Терминал) Тогда 
	//	
	//	Если Запись.НомерКассы <> "Выберите кассу" Тогда
	//		Запись.НомерКассы = "Выберите кассу";
	//	КонецЕсли;
	//	
	//Иначе
	//	
	//	ЗаполнитьНомерКассы();
	//	
	//КонецЕсли;	
	Если НЕ ЗначениеЗаполнено(Запись.НомерКассы) Тогда
		Запись.НомерКассы = "Выберите кассу";
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура НомерКассыНажатие(Элемент, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	Если НЕ ЗначениеЗаполнено(Запись.ТорговаяТочка) Тогда
		Предупреждение("Сначала выберите тороговую точку!");
		Возврат;
	КонецЕсли;	
	
	ЗначениеОтбора = Новый Структура("СтруктурнаяЕдиница", Запись.ТорговаяТочка);
	СтруктураПараметров = Новый Структура("Отбор", ЗначениеОтбора);
	
	//Запись.Терминал = ОткрытьФормуМодально("Справочник.Терминалы.Форма.ФормаВыбораУправляемая", П);
	Место = ОткрытьФормуМодально("Справочник.РабочиеМеста.ФормаВыбора", СтруктураПараметров);
	 
	Если ЗначениеЗаполнено(Место) Тогда
		ЗаполнитьКассуТерминал(Место);	
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьКассуТерминал(Место)
	
	//Если СокрЛП(Запись.Терминал.ID_SQL) = "" Тогда
	//	Запись.НомерКассы = Запись.Терминал.ИД;
	//Иначе	
	//	Запись.НомерКассы = Запись.Терминал.ID_SQL;
	//КонецЕсли;
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("РабочееМесто", Место);
	Запрос.Текст =
	"ВЫБРАТЬ
	|	ПривязкиОборудованияКРабочимМестамСрезПоследних.Касса,
	|	ПривязкиОборудованияКРабочимМестамСрезПоследних.Касса.Наименование КАК НаименованиеКассы,
	|	ПривязкиОборудованияКРабочимМестамСрезПоследних.Терминал
	|ИЗ
	|	РегистрСведений.ПривязкиОборудованияКРабочимМестам.СрезПоследних КАК ПривязкиОборудованияКРабочимМестамСрезПоследних
	|ГДЕ
	|	ПривязкиОборудованияКРабочимМестамСрезПоследних.РабочееМесто = &РабочееМесто";
	Выборка = Запрос.Выполнить().Выбрать();
	
	//
	Если Выборка.Следующий() Тогда
		Запись.Терминал 	= Выборка.Терминал;
		//Если Найти(Выборка.Касса.Наименование,"ККМ")>0 Тогда
		//	Запись.НомерКассы=Выборка.Касса.Наименование;
		//ИначеЕсли 	СокрЛП(Запись.Терминал.ID_SQL) <> "" Тогда
		//	Запись.НомерКассы=Запись.Терминал.ID_SQL;
		//Иначе
			//Запись.НомерКассы=Выборка.Касса.Наименование;
		//КонецЕсли;	
		ЭтоИзбенка 	= (Место.СтруктурнаяЕдиница.ТипРозничнойТочки = Перечисления.ТипыРозничныхТочек.Избенка);
		Запись.НомерКассы 	= ?(ЭтоИзбенка, Выборка.НаименованиеКассы, Место.CashName);
	КонецЕсли;
	
КонецПроцедуры	

&НаКлиенте
Процедура ТипОбращенияПриИзменении(Элемент)
	
	УстановитьОтвет();
	
КонецПроцедуры

&НаСервере
Процедура УстановитьОтвет()
	
	
	Если ЗначениеЗаполнено(Запись.ТипОбращения) Тогда
		Запись.Ответ = Запись.ТипОбращения.Ответ;
	Иначе
		Если Запись.Ответ <> "" Тогда
			Запись.Ответ = "";
		КонецЕсли;
	КонецЕсли;	
	
КонецПроцедуры	
