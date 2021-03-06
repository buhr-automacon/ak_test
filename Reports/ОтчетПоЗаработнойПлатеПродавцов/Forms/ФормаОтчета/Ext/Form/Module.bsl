﻿/////////////////////////////////////////////////////////////////////////
// ПРОЦЕДУРЫ - ОБРАБОТЧИКИ СОБЫТИЙ

// Процедура - обработчик события "ПриОткрытии" формы.
//
&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	ОтчетОбъект = РеквизитФормыВЗначение("Отчет");
	АдресХранилищаСКД = ПоместитьВоВременноеХранилище(ОтчетОбъект.СхемаКомпоновкиДанных, Новый УникальныйИдентификатор);
	
КонецПроцедуры // ПриСозданииНаСервере()

///////////////////////////////////////////////////////////////////////////////
// ПРОЦЕДУРЫ - ОБРАБОТЧИКИ СОБЫТИЙ ТАБЛИЧНОГО ПОЛЯ

&НаКлиенте
Процедура РезультатОбработкаРасшифровки(Элемент, Расшифровка, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	//
	//Если Найти(ПредставлениеТекущегоВарианта, "Дата / Склад / Номенклатура") = 1 Тогда
	Попытка	
		ТабДок = РасшифроватьОтчет(Расшифровка);	
		//Иначе
		//	Сообщить("Необходимо выбрать вариант отчета!", СтатусСообщения.Важное);
		//	Возврат;
		//КонецЕсли;
		ТабДок.ТолькоПросмотр = Истина;
		ТабДок.Показать();
	Исключение
	КонецПопытки;

КонецПроцедуры // РезультатОбработкаРасшифровки()

 &НаСервере
Функция РасшифроватьОтчет(Расшифровка)
	
	Данные = ПолучитьИзВременногоХранилища(ДанныеРасшифровки);
	//СтатьяДР_Код = СокрЛП(ДанныеРасшифровки.Элементы[Расшифровка].ПолучитьРодителей()[0].ПолучитьПоля()[1].Значение);
	//СтатьяДР_Наименование = СокрЛП(ДанныеРасшифровки.Элементы[Расшифровка].ПолучитьРодителей()[0].ПолучитьПоля()[0].Значение);
	
	ПараметрПериод = Данные.Настройки.ПараметрыДанных.НайтиЗначениеПараметра(Новый ПараметрКомпоновкиДанных("ПериодОтчета"));
	
	НачалоПериода = ПараметрПериод.Значение.ДатаНачала;
	КонецПериода  = ПараметрПериод.Значение.ДатаОкончания;
	
	
	Продавец = Данные.Элементы[Расшифровка].ПолучитьРодителей()[0].ПолучитьПоля()[0].Значение;
	Если НЕ ТипЗнч(Продавец) = Тип("СправочникСсылка.ФизическиеЛица") Тогда
		Возврат Новый ТабличныйДокумент;	
	КонецЕсли;
	ПериодВывода = Данные.Элементы[Расшифровка].ПолучитьРодителей()[1].ПолучитьПоля()[0].Значение;
	Попытка
		ТТ = Данные.Элементы[Данные.Элементы[Расшифровка].ПолучитьРодителей()[0].ПолучитьРодителей()[0].Идентификатор].ПолучитьРодителей()[0].ПолучитьПоля()[0].Значение;
	Исключение
		ТТ = Справочники.СтруктурныеЕдиницы.ПустаяСсылка();
	КонецПопытки;
	//ДатаРасшифровки = Данные.Элементы[Данные.Элементы[Данные.Элементы[Расшифровка].ПолучитьРодителей()[0].ПолучитьРодителей()[0].Идентификатор].ПолучитьРодителей()[0].ПолучитьРодителей()[0].Идентификатор].ПолучитьРодителей()[0].ПолучитьПоля()[0].Значение;
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
		//"ВЫБРАТЬ
		//|	ЗарплатаПродавцов.ДатаНачисления КАК Дата,
		//|	ЗарплатаПродавцов.ФизЛицо КАК Продавец,
		//|	ЗарплатаПродавцов.ТорговаяТочка КАК ТТ,
		//|	СУММА(ЗарплатаПродавцов.Выручка) КАК Выручка,
		//|	СУММА(ЗарплатаПродавцов.Бонус) КАК Бонус,
		//|	СУММА(ЗарплатаПродавцов.БонусСНДФЛ) КАК БонусСНДФЛ
		//|ИЗ
		//|	РегистрСведений.ЗарплатаПродавцов КАК ЗарплатаПродавцов
		//|ГДЕ
		//|	ЗарплатаПродавцов.ДатаНачисления МЕЖДУ &НачалоПериода И &КонецПериода
		//|	И ЗарплатаПродавцов.ФизЛицо = &Продавец
		//|	И (&ТТ = ЗНАЧЕНИЕ(Справочник.СтруктурныеЕдиницы.ПустаяСсылка)
		//|			ИЛИ ЗарплатаПродавцов.ТорговаяТочка = &ТТ)
		//|
		//|СГРУППИРОВАТЬ ПО
		//|	ЗарплатаПродавцов.ДатаНачисления,
		//|	ЗарплатаПродавцов.ФизЛицо,
		//|	ЗарплатаПродавцов.ТорговаяТочка";
		
		"ВЫБРАТЬ
		|	ВТ.Дата,
		|	ВТ.Продавец,
		|	ВТ.ТТ,
		|	СУММА(ВТ.Выручка) КАК Выручка,
		|	СУММА(ВТ.Бонус) КАК Бонус,
		|	СУММА(ВТ.БонусСНДФЛ) КАК БонусСНДФЛ,
		|	СУММА(ВТ.Удержание) КАК Удержание,
		|	СУММА(ВТ.УдержаниеСНДФЛ) КАК УдержаниеСНДФЛ
		|ИЗ
		|	(ВЫБРАТЬ
		|		ЗарплатаПродавцов.ДатаНачисления КАК Дата,
		|		ЗарплатаПродавцов.ФизЛицо КАК Продавец,
		|		ЗарплатаПродавцов.ТорговаяТочка КАК ТТ,
		|		ЗарплатаПродавцов.Выручка КАК Выручка,
		|		ЗарплатаПродавцов.Бонус КАК Бонус,
		|		ЗарплатаПродавцов.БонусСНДФЛ КАК БонусСНДФЛ,
		|		0 КАК Удержание,
		|		0 КАК УдержаниеСНДФЛ
		|	ИЗ
		|		РегистрСведений.ЗарплатаПродавцов КАК ЗарплатаПродавцов
		|	ГДЕ
		|		ЗарплатаПродавцов.ДатаНачисления МЕЖДУ &НачалоПериода И &КонецПериода
		|		И ЗарплатаПродавцов.ФизЛицо = &Продавец
		|		И (&ТТ = ЗНАЧЕНИЕ(Справочник.СтруктурныеЕдиницы.ПустаяСсылка)
		|				ИЛИ ЗарплатаПродавцов.ТорговаяТочка = &ТТ)
		|	
		|	ОБЪЕДИНИТЬ ВСЕ
		|	
		|	ВЫБРАТЬ
		|		УдержанияСФизЛицОбороты.Период,
		|		УдержанияСФизЛицОбороты.ФизЛицо,
		|		ЗНАЧЕНИЕ(Справочник.СтруктурныеЕдиницы.ПустаяСсылка),
		|		0,
		|		0,
		|		0,
		|		-УдержанияСФизЛицОбороты.СуммаОборот,
		|		-УдержанияСФизЛицОбороты.СуммаСНДФЛОборот
		|	ИЗ
		|		РегистрНакопления.УдержанияСФизЛиц.Обороты(&НачалоПериода, &КонецПериода, Регистратор, ФизЛицо = &Продавец) КАК УдержанияСФизЛицОбороты
		|	
		|	ОБЪЕДИНИТЬ ВСЕ
		|	
		|	ВЫБРАТЬ
		|		ПриемииОбороты.Период,
		|		ПриемииОбороты.ФизЛицо,
		|		ЗНАЧЕНИЕ(Справочник.СтруктурныеЕдиницы.ПустаяСсылка),
		|		0,
		|		0,
		|		0,
		|		ПриемииОбороты.СуммаОборот,
		|		ПриемииОбороты.СуммаСНДФЛОборот
		|	ИЗ
		|		РегистрНакопления.Премии.Обороты(&НачалоПериода, &КонецПериода, Регистратор, ФизЛицо = &Продавец) КАК ПриемииОбороты) КАК ВТ
		|
		|СГРУППИРОВАТЬ ПО
		|	ВТ.Дата,
		|	ВТ.Продавец,
		|	ВТ.ТТ";
		
		
	Если НачалоМесяца(ПериодВывода) >= НачалоДня(НачалоПериода) Тогда
		Запрос.УстановитьПараметр("НачалоПериода", НачалоМесяца(ПериодВывода));	
	Иначе
		Запрос.УстановитьПараметр("НачалоПериода", НачалоДня(НачалоПериода));
	КонецЕсли;			   
	
	Если КонецМесяца(ПериодВывода) <= КонецДня(КонецПериода) Тогда
		Запрос.УстановитьПараметр("КонецПериода", КонецМесяца(ПериодВывода));
	Иначе
		Запрос.УстановитьПараметр("КонецПериода", КонецДня(КонецПериода));
	КонецЕсли;
	Запрос.УстановитьПараметр("ТТ", ТТ);
	Запрос.УстановитьПараметр("Продавец", Продавец);
	
	Выгрузка = Запрос.Выполнить().Выгрузить();       
	
	ТабДокумент = Новый ТабличныйДокумент;
	Макет = Отчеты.ОтчетПоЗаработнойПлатеПродавцов.ПолучитьМакет("Расшифровка");
	ОбластьШапка = Макет.ПолучитьОбласть("Шапка");
	//	ОбластьОрганизация = Макет.ПолучитьОбласть("СтрокаОрганизация");
	ОбластьСтрока = Макет.ПолучитьОбласть("Строка");
	ОбластьИтоги = Макет.ПолучитьОбласть("Итоги");
	//
	ОбластьШапка.Параметры.ТТ = ТТ;
	ОбластьШапка.Параметры.Продавец = Продавец;
	
	ТабДокумент.Вывести(ОбластьШапка);
	
	Для Каждого Строка Из Выгрузка Цикл
		ЗаполнитьЗначенияСвойств(ОбластьСтрока.Параметры, Строка);
		ОбластьСтрока.Параметры.Дата = Формат(Строка.Дата, "ДФ=dd.MM.yyyy");
		ТабДокумент.Вывести(ОбластьСтрока);
	КонецЦикла;
	
	ОбластьИтоги.Параметры.ИтогВыручка    = Выгрузка.Итог("Выручка");
	ОбластьИтоги.Параметры.ИтогБонус      = Выгрузка.Итог("Бонус");
	ОбластьИтоги.Параметры.ИтогБонусСНДФЛ = Выгрузка.Итог("БонусСНДФЛ");
	ОбластьИтоги.Параметры.ИтогУдержание  = Выгрузка.Итог("Удержание");
	ОбластьИтоги.Параметры.ИтогУдержаниеСНДФЛ = Выгрузка.Итог("УдержаниеСНДФЛ");
	ТабДокумент.Вывести(ОбластьИтоги);		
	
	Возврат ТабДокумент;
	
КонецФункции


&НаКлиенте
Процедура ПриОткрытии(Отказ)
	//ПараметрДанных = Отчет.КомпоновщикНастроек.Настройки.ПараметрыДанных.Элементы.Найти("ОтклонениеВПоступленииТоваров");
	//ПараметрДанных.Значение = ЗначениеПараметраСтатьяСервер();
	//ПараметрДанных.Использование = Истина;
	УправлениеПоРазвитию = УправлениеПоРазвитию();
	
	ИнфокомТиповыеОтчеты.УстановитьПараметр(Отчет.КомпоновщикНастроек, "УправлениеПоРазвитию", УправлениеПоРазвитию);
	
КонецПроцедуры

&НаСервере
Функция УправлениеПоРазвитию()
	Возврат Справочники.СтруктурныеЕдиницы.НайтиПоКоду("ЦФО_12");
КонецФункции

&НаСервереБезКонтекста
Функция ЗначениеПараметраСтатьяСервер()  
	
    Возврат Справочники.СтатьиТовародвижения.НайтиПоНаименованию("Отклонение в поступлении товаров");
			
КонецФункции