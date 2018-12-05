﻿
&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	//Если ЗначениеЗаполнено(Параметры.ЗначениеКопирования) Тогда
	//	ОбщегоНазначенияКлиентСервер.СообщитьПользователю("Нельзя вводить документ копированием",,,, Отказ);
	//КонецЕсли;
	
	Если НЕ ЗначениеЗаполнено(Объект.Ссылка) Тогда
		Объект.Автор = ПараметрыСеанса.ТекущийПользователь;
		//+++АК GEYV 05.07.2015
		Если Объект.Поставщик.Пустая() Тогда
		
			Объект.Поставщик = Справочники.Контрагенты.НайтиПоКоду("Т00000329");
		
		КонецЕсли;
		//---АК
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ТоварыНоменклатураПриИзменении(Элемент)
	
	Элементы.Товары.ТекущиеДанные.ЕдиницаИзмерения = ПолучитьЕдиницуХраненияОстатковНоменклатуры(Элементы.Товары.ТекущиеДанные.Номенклатура);
	Элементы.Товары.ТекущиеДанные.Получатель = ПолучитьПолучателя(Элементы.Товары.ТекущиеДанные.Номенклатура);
КонецПроцедуры

Функция ПолучитьЕдиницуХраненияОстатковНоменклатуры(Номенклатура)

	Возврат Номенклатура.ЕдиницаХраненияОстатков;

КонецФункции


&НаКлиенте
Процедура ТоварыНоменклатураОчистка(Элемент, СтандартнаяОбработка)
	
	Элементы.Товары.ТекущиеДанные.ЕдиницаИзмерения = Неопределено;
	
КонецПроцедуры

&НаКлиенте
Процедура ТоварыКоличествоПриИзменении(Элемент)
	
	РассчитатьСумму(Элементы.Товары.ТекущиеДанные);
	
КонецПроцедуры

&НаКлиенте
Процедура ТоварыЦенаЗаЕдиницуПриИзменении(Элемент)
	
	РассчитатьСумму(Элементы.Товары.ТекущиеДанные);
	
КонецПроцедуры

&НаКлиенте
Процедура РассчитатьСумму(ТекДанные)

	Если ТекДанные <> Неопределено Тогда
		ТекДанные.Сумма = Окр(ТекДанные.Количество * ТекДанные.ЦенаЗаЕдиницу,2);
	КонецЕсли;

КонецПроцедуры
//+++АК GEYV 26.05.2015

&НаКлиенте
Процедура СоздатьЗаявкуНаСклад(Команда)
	
	Если Модифицированность Тогда
		
		Если Вопрос("Документ должен быть записан! Записать?", РежимДиалогаВопрос.ДаНет) = КодВозвратаДиалога.Нет Тогда
			Возврат
		КонецЕсли;
		
		Записать();
		
	КонецЕсли;
	
	Сообщение = ПроверитьОснование();
	
	Если Сообщение <> "" Тогда
	
		Если Вопрос("По документу имеются введеные ранее заявки на склад! Продолжить?"+Символы.ПС + Сообщение, РежимДиалогаВопрос.ДаНет) = КодВозвратаДиалога.Нет Тогда
		
			Возврат;	
		
		КонецЕсли;	
	
	КонецЕсли;
	
	СоздатьЗаякуНаСервере();
	
КонецПроцедуры

&НаСервере
Функция ПроверитьОснование()

	Сообщение = "";
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ
		|	ЗаявкаНаСклад.Представление
		|ИЗ
		|	Документ.ЗаявкаНаСклад КАК ЗаявкаНаСклад
		|ГДЕ
		|	ЗаявкаНаСклад.Основание = &Основание";

	Запрос.УстановитьПараметр("Основание", Объект.Ссылка);

	Результат = Запрос.Выполнить();

	ВыборкаДетальныеЗаписи = Результат.Выбрать();

	Пока ВыборкаДетальныеЗаписи.Следующий() Цикл
		
		Сообщение = Сообщение + ВыборкаДетальныеЗаписи.Представление + Символы.ПС; 
		
	КонецЦикла;
	
	Возврат Сообщение;



КонецФункции // ПроверитьОснование()

&НаСервере
Процедура СоздатьЗаякуНаСервере()
	
		//{{КОНСТРУКТОР_ЗАПРОСА_С_ОБРАБОТКОЙ_РЕЗУЛЬТАТА
	// Данный фрагмент построен конструктором.
	// При повторном использовании конструктора, внесенные вручную изменения будут утеряны!!!
	//}}КОНСТРУКТОР_ЗАПРОСА_С_ОБРАБОТКОЙ_РЕЗУЛЬТАТА

	
	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ
		|	ЗаявкаНаПоставкуУпаковкиТовары.Номенклатура,
		|	ЗаявкаНаПоставкуУпаковкиТовары.Количество,
		|	ЗаявкаНаПоставкуУпаковкиТовары.ЕдиницаИзмерения,
		|	ЗаявкаНаПоставкуУпаковкиТовары.Характеристика,
		|	ЗаявкаНаПоставкуУпаковкиТовары.Получатель КАК Получатель,
		|	ЗаявкаНаПоставкуУпаковкиТовары.Склад КАК Склад,
		|	ЗаявкаНаПоставкуУпаковкиТовары.НомерСтроки КАК НомерСтрокиУпаковка,
		|	ЗаявкаНаПоставкуУпаковкиТовары.Ссылка.Автор
		|ИЗ
		|	Документ.ЗаявкаНаПоставкуУпаковки.Товары КАК ЗаявкаНаПоставкуУпаковкиТовары
		|ГДЕ
		|	ЗаявкаНаПоставкуУпаковкиТовары.Ссылка = &Ссылка
		|ИТОГИ ПО
		|	Получатель,
		|	Склад";

	Запрос.УстановитьПараметр("Ссылка", Объект.Ссылка);

	Результат = Запрос.Выполнить();

	ВыборкаПолучатель = Результат.Выбрать(ОбходРезультатаЗапроса.ПоГруппировкам);

	Пока ВыборкаПолучатель.Следующий() Цикл

		ВыборкаСклад = ВыборкаПолучатель.Выбрать(ОбходРезультатаЗапроса.ПоГруппировкам);

		Пока ВыборкаСклад.Следующий() Цикл

			ВыборкаДетальныеЗаписи = ВыборкаСклад.Выбрать();

			ДокументОбъект = Документы.ЗаявкаНаСклад.СоздатьДокумент();
			ДокументОбъект.Дата = ТекущаяДата();
			ДокументОбъект.Подразделение = ВыборкаСклад.Склад.Владелец;
			ДокументОбъект.Склад = ВыборкаСклад.Склад;
			ДокументОбъект.ВидОперации = Перечисления.ВидыОперацийЗаявкиНаСклад.ОтгрузкаВПереработку;
			ДокументОбъект.Получатель = ВыборкаСклад.Получатель;
			
			ДокументОбъект.ДатаОтгрузки = Объект.ОжидаемаяДатаПоставки;
			
			ДокументОбъект.Основание =  Объект.Ссылка;
			
			Пока ВыборкаДетальныеЗаписи.Следующий() Цикл
				НовСтр = ДокументОбъект.Товары.Добавить();
				ЗаполнитьЗначенияСвойств(НовСтр, ВыборкаДетальныеЗаписи);    				
			КонецЦикла;
			
			Попытка
				
				ДокументОбъект.Записать(РежимЗаписиДокумента.Проведение);
				
			Исключение
				
				Попытка
				
					ДокументОбъект.Записать(РежимЗаписиДокумента.Запись);
				
				Исключение
					
					Сообщение = Новый СообщениеПользователю;
					Сообщение.Текст = ОписаниеОшибки();
					Сообщение.Сообщить();
				
				КонецПопытки;
				
				
			КонецПопытки;
			
		КонецЦикла;
	КонецЦикла;
                                 
КонецПроцедуры // СоздатьЗаякуНаСервере()

&НаСервере
Процедура ТоварыПередНачаломДобавленияНаСервере(НомерСтроки)
	ТекСтрока = Объект.Товары.Получить(НомерСтроки-1);
	Если ТекСтрока.Склад.Пустая() Тогда
	
		ТекСтрока.Склад = Справочники.Склады.НайтиПоКоду("000000302"); 
	
	КонецЕсли;
КонецПроцедуры // ()

&НаКлиенте
Процедура ТоварыНоменклатураНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	ТекСтрока = Элементы.Товары.ТекущиеДанные;
	
	Отбор = Новый Структура;
	
	Отбор.Вставить("ТипТовара",ПредопределенноеЗначение("Перечисление.ТипыТоваров.Упаковка"));
	
	П = Новый Структура("Отбор",Отбор);
	П.Вставить("ТекущаяСтрока",ТекСтрока.Номенклатура); 
	ФормаВыбора = ПолучитьФорму("Справочник.Номенклатура.ФормаВыбора",П,Элемент);
	 //ОткрытьФорму("Справочник.Номенклатура.ФормаВыбора",П,Элемент);
	//ФормаВыбора.Элементы.Список.ТекущаяСтрока  = ТекСтрока.Номенклатура;
	//ФормаВыбора.ТекущийЭлемент.ТекущаяСтрока  = ТекСтрока.Номенклатура;
	//ФормаВыбора.Отбор.ТипТовара.Использование = Истина;
	//ФормаВыбора.Отбор.ТипТовара.Значение = ПредопределенноеЗначение("Перечисление.ТипыТоваров.Упаковка");
	//
	//ФормаВыбора.Список.НайтиСтроки(Новый Структура("Ссылка",ТекСтрока.Номенклатура))
	//ЭлементОтбораДанных = ФормаВыбора.Список.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	//ЭлементОтбораДанных.ЛевоеЗначение        = Новый ПолеКомпоновкиДанных("Ссылка");
	//ЭлементОтбораДанных.Использование        = Истина;
	//ЭлементОтбораДанных.ВидСравнения        = ВидСравненияКомпоновкиДанных.Равно;            
	//ЭлементОтбораДанных.РежимОтображения     = РежимОтображенияЭлементаНастройкиКомпоновкиДанных.Обычный;
	//ЭлементОтбораДанных.ПравоеЗначение        = ТекСтрока.Номенклатура;
	ФормаВыбора.Открыть();
	
КонецПроцедуры

&НаКлиенте
Процедура ТоварыНоменклатураОкончаниеВводаТекста(Элемент, Текст, ДанныеВыбора, СтандартнаяОбработка)
	
	//СтандартнаяОбработка = Ложь;
	//ДанныеВыбора = ТоварыНоменклатураОкончаниеВводаТекстаНаСервере(Текст);
	
КонецПроцедуры

&НаСервере
Функция ТоварыНоменклатураОкончаниеВводаТекстаНаСервере(Текст)
	
	Список = Новый СписокЗначений;

	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ
		|	Номенклатура.Ссылка
		|ИЗ
		|	Справочник.Номенклатура КАК Номенклатура
		|ГДЕ
		|	(Номенклатура.Наименование ПОДОБНО &Наименование
		|	Или Номенклатура.Код ПОДОБНО &Наименование)
		|	И Номенклатура.ТипТовара = &ТипТовара";

	Запрос.УстановитьПараметр("Наименование", "%"+Текст+"%");
	Запрос.УстановитьПараметр("ТипТовара", Перечисления.ТипыТоваров.Упаковка);

	Результат = Запрос.Выполнить();

	ВыборкаДетальныеЗаписи = Результат.Выбрать();

	Пока ВыборкаДетальныеЗаписи.Следующий() Цикл
		Список.Добавить(ВыборкаДетальныеЗаписи.Ссылка);
	КонецЦикла;
	
	Возврат Список;

КонецФункции // ТоварыНоменклатураОкончаниеВводаТекста()

&НаКлиенте
Процедура ТоварыНоменклатураАвтоПодбор(Элемент, Текст, ДанныеВыбора, Ожидание, СтандартнаяОбработка)
	
	//СтандартнаяОбработка = Ложь;
	//ДанныеВыбора = ТоварыНоменклатураОкончаниеВводаТекстаНаСервере(Текст);
КонецПроцедуры


&НаКлиенте
Процедура ТоварыПриАктивизацииСтроки(Элемент)
	ТекСтрока = Элементы.Товары.ТекущиеДанные;
	Если не ТекСтрока = Неопределено Тогда
		НомерСтроки = ТекСтрока.НомерСтроки;
		ТекСтрока = Неопределено;
		ТоварыПередНачаломДобавленияНаСервере(НомерСтроки);
	КонецЕсли;
КонецПроцедуры

&НаСервере
Функция ПолучитьПолучателя(Номенклатура)

		//{{КОНСТРУКТОР_ЗАПРОСА_С_ОБРАБОТКОЙ_РЕЗУЛЬТАТА
	// Данный фрагмент построен конструктором.
	// При повторном использовании конструктора, внесенные вручную изменения будут утеряны!!!

	Запрос = Новый Запрос;
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	СпецификацииПоставщиковСрезПоследних.Поставщик
	|ИЗ
	|	РегистрСведений.СпецификацииПоставщиков.СрезПоследних(
	|			,
	|			Спецификация В
	|				(ВЫБРАТЬ
	|					СпецификацииСостав.Ссылка
	|				ИЗ
	|					Справочник.Спецификации.Состав КАК СпецификацииСостав
	|				ГДЕ
	|					СпецификацииСостав.Номенклатура = &Номенклатура)) КАК СпецификацииПоставщиковСрезПоследних
	|ГДЕ
	|	СпецификацииПоставщиковСрезПоследних.НоменклатураСырье = ЗНАЧЕНИЕ(Справочник.Номенклатура.ПустаяСсылка)
	|
	|ОБЪЕДИНИТЬ
	|
	|ВЫБРАТЬ
	|	ЦеныПоставщиков.Поставщик
	|ИЗ
	|	РегистрСведений.СпецификацииПоставщиков.СрезПоследних(, НоменклатураСырье = &Номенклатура) КАК СпецификацииПоставщиковСрезПоследних
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ (ВЫБРАТЬ
	|			ЦеныПоставщиковСрезПоследних.Номенклатура КАК Номенклатура,
	|			ЦеныПоставщиковСрезПоследних.Характеристика КАК Характеристика,
	|			ЦеныПоставщиковСрезПоследних.Поставщик КАК Поставщик
	|		ИЗ
	|			РегистрСведений.ЦеныПоставщиков.СрезПоследних(, ) КАК ЦеныПоставщиковСрезПоследних) КАК ЦеныПоставщиков
	|		ПО СпецификацииПоставщиковСрезПоследних.Номенклатура = ЦеныПоставщиков.Номенклатура
	|			И СпецификацииПоставщиковСрезПоследних.Характеристика = ЦеныПоставщиков.Характеристика
	//|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ (ВЫБРАТЬ
	//|			МАКСИМУМ(СпецификацииПоставщиковСрезПоследних.Период) КАК Период,
	//|			СпецификацииПоставщиковСрезПоследних.Номенклатура КАК Номенклатура,
	//|			СпецификацииПоставщиковСрезПоследних.Характеристика КАК Характеристика
	//|		ИЗ
	//|			РегистрСведений.СпецификацииПоставщиков.СрезПоследних(, НоменклатураСырье = &Номенклатура) КАК СпецификацииПоставщиковСрезПоследних
	//|		
	//|		СГРУППИРОВАТЬ ПО
	//|			СпецификацииПоставщиковСрезПоследних.Номенклатура,
	//|			СпецификацииПоставщиковСрезПоследних.Характеристика) КАК ВложенныйЗапрос
	//|		ПО СпецификацииПоставщиковСрезПоследних.Номенклатура = ВложенныйЗапрос.Номенклатура
	//|			И СпецификацииПоставщиковСрезПоследних.Характеристика = ВложенныйЗапрос.Характеристика
	//|			И СпецификацииПоставщиковСрезПоследних.Период = ВложенныйЗапрос.Период
	
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ (ВЫБРАТЬ
	|			МАКСИМУМ(СпецификацииПоставщиковСрезПоследних.Период) КАК Период,
	|			СпецификацииПоставщиковСрезПоследних.Номенклатура КАК Номенклатура,
	|			СпецификацииПоставщиковСрезПоследних.НоменклатураСырье КАК НоменклатураСырье,
	|			СпецификацииПоставщиковСрезПоследних.Характеристика КАК Характеристика
	|		ИЗ
	|			РегистрСведений.СпецификацииПоставщиков.СрезПоследних(, НоменклатураСырье = &Номенклатура) КАК СпецификацииПоставщиковСрезПоследних
	|							
	|		СГРУППИРОВАТЬ ПО
	|			СпецификацииПоставщиковСрезПоследних.Номенклатура,
	|			СпецификацииПоставщиковСрезПоследних.НоменклатураСырье,
	|			СпецификацииПоставщиковСрезПоследних.Характеристика) КАК ВложенныйЗапрос
	|		ПО СпецификацииПоставщиковСрезПоследних.Номенклатура = ВложенныйЗапрос.Номенклатура
	|			И СпецификацииПоставщиковСрезПоследних.НоменклатураСырье = ВложенныйЗапрос.НоменклатураСырье
	|			И СпецификацииПоставщиковСрезПоследних.Характеристика = ВложенныйЗапрос.Характеристика
	|			И СпецификацииПоставщиковСрезПоследних.Период = ВложенныйЗапрос.Период
	|ГДЕ
	|	СпецификацииПоставщиковСрезПоследних.НоменклатураСырье <> ЗНАЧЕНИЕ(Справочник.Номенклатура.ПустаяСсылка) И (СпецификацииПоставщиковСрезПоследних.ДатаКонца = ДАТАВРЕМЯ(1, 1, 1)
	|		ИЛИ СпецификацииПоставщиковСрезПоследних.ДатаКонца > &Период)";
	
	Запрос.УстановитьПараметр("Номенклатура",Номенклатура);
	Запрос.УстановитьПараметр("Период",КонецДня(ТекущаяДата()));
	Результат = Запрос.Выполнить();
	
	ВыборкаДетальныеЗаписи = Результат.Выбрать();
	
	Если ВыборкаДетальныеЗаписи.Следующий() Тогда
		Возврат ВыборкаДетальныеЗаписи.Поставщик;
	КонецЕсли;

	//}}КОНСТРУКТОР_ЗАПРОСА_С_ОБРАБОТКОЙ_РЕЗУЛЬТАТА
	

КонецФункции // ПолучитьПолучателя()

//---АК

&НаКлиенте
Процедура ЗаполнитьПоКонтрагенту(Команда)
	Контрагент=ОткрытьФормуМодально("Справочник.Контрагенты.Форма.ФормаВыбора");
	Если ЗначениеЗаполнено(Контрагент) Тогда
		ЗаполнитьПоКонтрагентуСервер();	
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура ПодборЗаявок(Команда)
	// Вставить содержимое обработчика.
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьПоКонтрагентуСервер()
	Запрос = Новый Запрос;
	Запрос.Текст = "ВЫБРАТЬ
	               |	ЗаявкаНаПечатьЭтикеткиЭтикетки.Ссылка КАК ЗаявкаНаПечатьЭтикетки,
	               |	ЗаявкаНаПечатьЭтикеткиЭтикетки.Этикетка КАК Номенклатура,
	               |	ЗаявкаНаПечатьЭтикеткиЭтикетки.КоличествоЗаказано КАК Количество,
	               |	ЗаявкаНаПечатьЭтикеткиЭтикетки.Этикетка.ЕдиницаХраненияОстатков КАК ЕдиницаИзмерения,
	               |	&Склад,
	               |	&Поставщик КАК Получатель
	               |ИЗ
	               |	Документ.ЗаявкаНаПечатьЭтикетки.Этикетки КАК ЗаявкаНаПечатьЭтикеткиЭтикетки
	               |ГДЕ
	               |	ЗаявкаНаПечатьЭтикеткиЭтикетки.Ссылка.Поставщик = &Поставщик
	               |	И ЗаявкаНаПечатьЭтикеткиЭтикетки.Ссылка.СтатусЗаявки = ЗНАЧЕНИЕ(Перечисление.АК_СтатусыЗаявокНаПечатьЭтикетки.Обработано)";
	Запрос.УстановитьПараметр("Поставщик",Контрагент);
	Запрос.УстановитьПараметр("Склад",Справочники.Склады.НайтиПоКоду("000000302"));
	Объект.Товары.Загрузить(Запрос.Выполнить().Выгрузить());
КонецПроцедуры


&НаСервере
Процедура ПередЗаписьюНаСервере(Отказ, ТекущийОбъект, ПараметрыЗаписи)
	
	//Запрос = Новый Запрос();
	//Запрос.УстановитьПараметр("ТекДата", КонецДня(Объект.Дата) + 14*86400);
	//Запрос.УстановитьПараметр("Товары", Объект.Товары.Выгрузить().ВыгрузитьКолонку("Номенклатура"));
	//Запрос.УстановитьПараметр("Поставщик", Объект.Поставщик);
	//Запрос.Текст = "ВЫБРАТЬ
	//			   |	НоменклатураСпр.Ссылка
	//			   |ИЗ
	//			   |	Справочник.Номенклатура КАК НоменклатураСпр
	//			   |		ЛЕВОЕ СОЕДИНЕНИЕ (ВЫБРАТЬ РАЗЛИЧНЫЕ
	//			   |			СпецификацииСостав.Номенклатура КАК Номенклатура
	//			   |		ИЗ
	//			   |			РегистрСведений.СпецификацииПоставщиков.СрезПоследних(&ТекДата, Поставщик = &Поставщик) КАК СпецификацииПоставщиковСрезПоследних
	//			   |				ЛЕВОЕ СОЕДИНЕНИЕ Справочник.Спецификации.Состав КАК СпецификацииСостав
	//			   |				ПО СпецификацииПоставщиковСрезПоследних.Спецификация = СпецификацииСостав.Ссылка) КАК ВЗ_Спецификации
	//			   |		ПО НоменклатураСпр.Ссылка = ВЗ_Спецификации.Номенклатура
	//			   |ГДЕ
	//			   |	НоменклатураСпр.Ссылка В(&Товары)
	//			   |	И ВЗ_Спецификации.Номенклатура ЕСТЬ NULL ";
	//			   
	//Выборка = Запрос.Выполнить().Выбрать();
	//Пока Выборка.Следующий() Цикл
	//	ОбщегоНазначенияКлиентСервер.СообщитьПользователю("Упаковка " + Выборка.Ссылка + " не включена ни в одну привязанную спецификацию к поставщикам",,,, Отказ);
	//КонецЦикла;	
	
КонецПроцедуры

