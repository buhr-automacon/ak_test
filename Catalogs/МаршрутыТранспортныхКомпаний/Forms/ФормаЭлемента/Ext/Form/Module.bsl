﻿
&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	АК_ЗаполнитьСведенияОТарифе();
		
	// значения "по умолчанию"
	Если НЕ ЗначениеЗаполнено(Объект.Ссылка) Тогда
		
		Объект.ВариантРасчетаНДС = ПредопределенноеЗначение("Перечисление.ВариантыРасчетаНДС.НДСвТомЧисле");
		
	КонецЕсли;
	
	УстановитьДоступность();
	
	УстановитьОтборВодителиМаршрута();
	
КонецПроцедуры

Процедура УстановитьДоступность()
	
	#Область АК_ОтключенныйКод
	//мДоступность = (Объект.Ссылка.Пустая()
	//					ИЛИ НЕ ЗначениеЗаполнено(Объект.ДатаСоздания)
	//					ИЛИ НачалоДня(ТекущаяДата()) = НачалоДня(Объект.ДатаСоздания));
	//Элементы.Организация.Доступность 				= мДоступность;
	//Элементы.Поставщики.Доступность					= мДоступность;
	//Элементы.ДоставкаНаСклад.Доступность			= мДоступность;
	//Элементы.Товары.Доступность						= мДоступность;
	#КонецОбласти						
	
	//+++АК sole 2018.05.30 ИП-00018724.02
	Если 
		(
				Объект.ПометкаУдаления 
			ИЛИ Объект.Устаревший 
			ИЛИ РольДоступна("Перевозчик") 
		)
		И	НЕ РольДоступна("ПолныеПрава")	
	Тогда
		мДоступность = Ложь;
	Иначе
		мДоступность = Истина;
	КонецЕсли;
	

	ЭтаФорма.Элементы.ТарифыНаДоставкуПоМаршруту.ТолькоПросмотр = НЕ мДоступность;
	ЭтаФорма.Элементы.ТарифыНаДоставкуПоМаршруту.КоманднаяПанель.Доступность = мДоступность;
	ЭтаФорма.Элементы.ТарифыНаДоставкуПериод.Доступность = мДоступность;
	ЭтаФорма.Элементы.ВариантРасчетаНДС.Доступность = мДоступность;
	ЭтаФорма.Элементы.СтавкаНДС.Доступность = мДоступность;
	ЭтаФорма.Элементы.ЕдиныйТариф.Доступность = мДоступность;
	//+++АК sole 2018.05.30 ИП-00018724.02

КонецПроцедуры

&НаСервереБезКонтекста
Функция ПолучитьКлючЗаписиТарифыНаДоставку(СтруктураЗаписи)
	
    Возврат РегистрыСведений.ТарифыНаДоставкуПоМаршруту.СоздатьКлючЗаписи(СтруктураЗаписи);

КонецФункции

Процедура УстановитьОтборВодителиМаршрута()
	
	ПараметрыЗапроса = ЭтаФорма.ВодителиПоМаршруту.Параметры;
	ПараметрыЗапроса.УстановитьЗначениеПараметра("Маршрут", Объект.Ссылка);
	ПараметрыЗапроса.УстановитьЗначениеПараметра("ТекДата", ТекущаяДата());
	
КонецПроцедуры

&НаСервереБезКонтекста
Функция ПолучитьКлючЗаписиВодителиМаршрута(СтруктураЗаписи)
	
    Возврат РегистрыСведений.ВодителиПоМаршруту.СоздатьКлючЗаписи(СтруктураЗаписи);

КонецФункции

Процедура ПроверитьЗаполнитьНаименованиеСервер()
	
	Если Объект.Наименование = "" Тогда
		
		ТекНаименование = "";
		
		// поставщики
		н = 0;
		Для Каждого СтрокаТЧ Из Объект.Поставщики Цикл
			Если НЕ н = 0 Тогда
				ТекНаименование = ТекНаименование + "-";
			Иначе
				н = 1;
			КонецЕсли;
			
			ТекНаименование = ТекНаименование + СокрЛП(СтрокаТЧ.Поставщик.Наименование);
		КонецЦикла;
		
		Если (НЕ н = 0) // поставщики есть
				И Объект.ДоставкаНаСклад.Количество() > 0 Тогда 
			ТекНаименование = ТекНаименование + " ... ";
		КонецЕсли;
		
		// склады
		н = 0;
		Для Каждого СтрокаТЧ Из Объект.ДоставкаНаСклад Цикл
			Если НЕ н = 0 Тогда
				ТекНаименование = ТекНаименование + "-";
			Иначе
				н = 1;
			КонецЕсли;
			
			ТекНаименование = ТекНаименование + СокрЛП(СтрокаТЧ.Склад.Наименование);
		КонецЦикла;		
		
		Объект.Наименование = ТекНаименование;
		
	КонецЕсли;
	
КонецПроцедуры

Процедура ЗаписатьИзменениеРеквизита(ТекущийОбъект, СтрокаРеквизит, мПредставлениеРеквизита)
	
	Если НЕ ТекущийОбъект[СтрокаРеквизит] = ТекущийОбъект.Ссылка[СтрокаРеквизит] Тогда
		
		НаборЗаписей = РегистрыСведений.ИсторияИзмененияМаршрутов.СоздатьНаборЗаписей();
		НаборЗаписей.Отбор.Маршрут.Установить(ТекущийОбъект.Ссылка);
		НаборЗаписей.Отбор.Реквизит.Установить(мПредставлениеРеквизита);
		НаборЗаписей.Прочитать();
		Если НаборЗаписей.Количество() = 0 Тогда // в первый раз записывается изменение - пишется первоначальное значение, на дату документа
			НоваяЗапись = НаборЗаписей.Добавить();
			НоваяЗапись.Период 				= ?(ЗначениеЗаполнено(Объект.ДатаСоздания), Объект.ДатаСоздания, ТекущаяДата());
			НоваяЗапись.Маршрут 			= ТекущийОбъект.Ссылка;
			НоваяЗапись.Реквизит 			= мПредставлениеРеквизита;
			НоваяЗапись.ЗначениеРеквизита 	= ТекущийОбъект.Ссылка[СтрокаРеквизит];
			НоваяЗапись.Автор 				= Объект.Автор;
			Попытка
				НаборЗаписей.Записать();
			Исключение
				Сообщить(ОписаниеОшибки());
			КонецПопытки;
		КонецЕсли;
		НаборЗаписей = Неопределено; // забота о памяти приложения 1С
		
		// измененное зачение
		МенеджерЗаписи = РегистрыСведений.ИсторияИзмененияМаршрутов.СоздатьМенеджерЗаписи();
		МенеджерЗаписи.Период 				= ТекущаяДата();
		МенеджерЗаписи.Маршрут 				= ТекущийОбъект.Ссылка;
		МенеджерЗаписи.Реквизит 			= мПредставлениеРеквизита;
		МенеджерЗаписи.ЗначениеРеквизита 	= ТекущийОбъект[СтрокаРеквизит];
		МенеджерЗаписи.Автор 				= ПараметрыСеанса.ТекущийПользователь;
		Попытка
			МенеджерЗаписи.Записать();
		Исключение
			Сообщить(ОписаниеОшибки());
		КонецПопытки;
		
	КонецЕсли;
	
КонецПроцедуры

Процедура ОбновитьПеревозчика()
	
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("Маршрут", Объект.Ссылка);
	Запрос.Текст =
	"ВЫБРАТЬ
	|	ВодителиПоМаршрутуСрезПоследних.Автомобиль.Перевозчик КАК Перевозчик
	|ИЗ
	|	РегистрСведений.ВодителиПоМаршруту.СрезПоследних(, Маршрут = &Маршрут) КАК ВодителиПоМаршрутуСрезПоследних";
	Выборка = Запрос.Выполнить().Выбрать();
	Если Выборка.Следующий() Тогда
		Если ЗначениеЗаполнено(Выборка.Перевозчик)
				И НЕ Объект.Перевозчик = Выборка.Перевозчик Тогда
			Объект.Перевозчик = Выборка.Перевозчик;
		КонецЕсли;	
	КонецЕсли;
	
КонецПроцедуры


&НаКлиенте
Процедура ПередЗаписью(Отказ, ПараметрыЗаписи)
	
	ПроверитьЗаполнитьНаименованиеСервер();
	
	//+++АК sole 2018.05.30 ИП-00018724.02
	АК_ПроверитьДублиВесовВТарифе(Отказ)
	//---АК sole 2018.05.30 ИП-00018724.02
	
КонецПроцедуры

&НаСервере
Процедура ПередЗаписьюНаСервере(Отказ, ТекущийОбъект, ПараметрыЗаписи)
	
	Если ТекущийОбъект.Ссылка.Пустая()
			ИЛИ Отказ Тогда
		Возврат;
	КонецЕсли;
	
	//ЗаписатьИзменениеРеквизита(ТекущийОбъект, "Сумма"				, "Сумма");
	//ЗаписатьИзменениеРеквизита(ТекущийОбъект, "ВариантРасчетаНДС"	, "Вариант расчета НДС");
	//ЗаписатьИзменениеРеквизита(ТекущийОбъект, "СтавкаНДС"			, "Ставка НДС");
	//ЗаписатьИзменениеРеквизита(ТекущийОбъект, "СуммаНДС"			, "Сумма НДС");
	ЗаписатьИзменениеРеквизита(ТекущийОбъект, "Устаревший"			, "Устаревший");
	
КонецПроцедуры

//+++АК sole 2018.05.30 ИП-00018724.02
&НаСервере
Процедура ПриЗаписиНаСервере(Отказ, ТекущийОбъект, ПараметрыЗаписи)
	
	Перем ЭтотОбъект;
	
	СтруктураТарифа = Новый Структура();
	СтруктураТарифа.Вставить("Период", ЭтаФорма.ТарифыНаДоставкуПериод);
	СтруктураТарифа.Вставить("ЕдиныйТариф", ЭтаФорма.ЕдиныйТариф);
	СтруктураТарифа.Вставить("ВариантРасчетаНДС", ЭтаФорма.ВариантРасчетаНДС);
	СтруктураТарифа.Вставить("СтавкаНДС", ЭтаФорма.СтавкаНДС);
	СтруктураТарифа.Вставить("тзТарифы", ЭтаФорма.ТарифыНаДоставкуПоМаршруту.Выгрузить());
	
	ТекущийОбъект.АК_ОбновитьТарифыНаДоставкуПоМаршрутуЕслиНеобходимо(СтруктураТарифа);
	
КонецПроцедуры

&НаСервере
Процедура ПослеЗаписиНаСервере(ТекущийОбъект, ПараметрыЗаписи)
	
	УстановитьДоступность();
	УстановитьОтборВодителиМаршрута();
	АК_ЗаполнитьСведенияОТарифе();
	
КонецПроцедуры

//+++АК sole 2018.05.29 ИП-00018724.02
Процедура РассчитатьСуммуНДС()
	
	мСуммаВключаетНДС = (ЭтаФорма.ВариантРасчетаНДС = ПредопределенноеЗначение("Перечисление.ВариантыРасчетаНДС.НДСвТомЧисле"));
	
	Для Инд = 0 По ЭтаФорма.ТарифыНаДоставкуПоМаршруту.Количество() - 1 Цикл
		Стр = ЭтаФорма.ТарифыНаДоставкуПоМаршруту[Инд];	
		
		Стр.СуммаНДС = УчетНДС.РассчитатьСуммуНДС
			(
				Стр.Сумма,
				Истина,
				мСуммаВключаетНДС,
				УчетНДС.ПолучитьСтавкуНДС(ЭтаФорма.СтавкаНДС)
			);	
	КонецЦикла;

КонецПроцедуры

//+++АК sole 2018.05.29 ИП-00018724.02
&НаКлиенте
Процедура СуммаПриИзменении(Элемент)
	
	мСуммаВключаетНДС = (ЭтаФорма.ВариантРасчетаНДС = ПредопределенноеЗначение("Перечисление.ВариантыРасчетаНДС.НДСвТомЧисле"));
	
	Стр = ЭтаФорма.Элементы.ТарифыНаДоставкуПоМаршруту.ДанныеСтроки(Элемент.Родитель.ТекущаяСтрока);
		
	Стр.СуммаНДС = УчетНДС.РассчитатьСуммуНДС
		(
			Стр.Сумма,
			Истина,
			мСуммаВключаетНДС,
			УчетНДС.ПолучитьСтавкуНДС(ЭтаФорма.СтавкаНДС)
		);	
	
КонецПроцедуры

&НаКлиенте
Процедура ПоказатьИсториюИзменений(Команда)
	
	Если Объект.Ссылка.Пустая() Тогда
		Возврат;
	КонецЕсли;
	
	ФормаСписка = ПолучитьФорму("РегистрСведений.ИсторияИзмененияМаршрутов.ФормаСписка", , ЭтаФорма);
	
	мСписок = ФормаСписка.Список;
	ЭлементОтбора = мСписок.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
    ЭлементОтбора.ЛевоеЗначение  = Новый ПолеКомпоновкиДанных("Маршрут");   
    ЭлементОтбора.ВидСравнения   = ВидСравненияКомпоновкиДанных.Равно;
    ЭлементОтбора.Использование  = Истина;
    ЭлементОтбора.ПравоеЗначение = Объект.Ссылка;
    ЭлементОтбора.РежимОтображения = РежимОтображенияЭлементаНастройкиКомпоновкиДанных.Недоступный;
	
	ФормаСписка.ТолькоПросмотр = Истина;
	ФормаСписка.ОткрытьМодально();
	
КонецПроцедуры

&НаСервереБезКонтекста
Процедура УдалитьЗаписьРегистраТарифыНаДоставку(СтруктураЗначенийИзмерений)
	
	НаборЗаписей = РегистрыСведений.ТарифыНаДоставкуПоМаршруту.СоздатьНаборЗаписей();
	НаборЗаписей.Отбор.Период.Установить(СтруктураЗначенийИзмерений.Период);
	НаборЗаписей.Отбор.Маршрут.Установить(СтруктураЗначенийИзмерений.Маршрут);
	НаборЗаписей.Отбор.ВесОт.Установить(СтруктураЗначенийИзмерений.ВесОт);
	НаборЗаписей.Отбор.ЕдиныйТариф.Установить(СтруктураЗначенийИзмерений.ЕдиныйТариф);
	НаборЗаписей.Прочитать();
	
	НаборЗаписей.Очистить();
	Попытка
		НаборЗаписей.Записать();
	Исключение
		СообщениеПользователю = Новый СообщениеПользователю;
		СообщениеПользователю.Текст = "Не удалось удалить запись регистра ""Тарифы на доставку по маршруту""";
		СообщениеПользователю.Сообщить();
	КонецПопытки;
	
КонецПроцедуры

&НаКлиенте
Процедура ТарифыНаДоставкуИстория(Команда)
	
	Если Объект.Ссылка.Пустая() Тогда
		Возврат;
	КонецЕсли;
	
	ФормаСписка = ПолучитьФорму("РегистрСведений.ТарифыНаДоставкуПоМаршруту.Форма.ФормаСписка", , ЭтаФорма);
	
	мСписок = ФормаСписка.Список;
	ЭлементОтбора = мСписок.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
    ЭлементОтбора.ЛевоеЗначение  = Новый ПолеКомпоновкиДанных("Маршрут");   
    ЭлементОтбора.ВидСравнения   = ВидСравненияКомпоновкиДанных.Равно;
    ЭлементОтбора.Использование  = Истина;
    ЭлементОтбора.ПравоеЗначение = Объект.Ссылка;
    ЭлементОтбора.РежимОтображения = РежимОтображенияЭлементаНастройкиКомпоновкиДанных.Недоступный;
	
	ФормаСписка.ТолькоПросмотр = Истина;
	ФормаСписка.ОткрытьМодально();
	
КонецПроцедуры

&НаКлиенте
Процедура ВодителиПоМаршрутуДобавить(Команда)
	
	Если Объект.Ссылка.Пустая() Тогда
		Возврат;
	КонецЕсли;
	//
	
	ФормаНового = ПолучитьФорму("РегистрСведений.ВодителиПоМаршруту.Форма.ФормаЗаписи",, ЭтаФорма, ЭтаФорма.УникальныйИдентификатор);
	ФормаНового.Запись.Период 		= НачалоДня(ТекущаяДата());
	ФормаНового.Запись.Маршрут 		= Объект.Ссылка;
	ФормаНового.Запись.Контрагент 	= Объект.Перевозчик;
	ФормаНового.ОткрытьМодально();
	
	Элементы.ВодителиПоМаршруту.Обновить();
	ОбновитьПеревозчика();
	
КонецПроцедуры

&НаКлиенте
Процедура ВодителиПоМаршрутуСкопировать(Команда)
	
	Если Объект.Ссылка.Пустая() Тогда
		Возврат;
	КонецЕсли;
	
	ТекДанные = Элементы.ВодителиПоМаршруту.ТекущиеДанные;
	Если ТекДанные = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	//
	ФормаНового = ПолучитьФорму("РегистрСведений.ВодителиПоМаршруту.Форма.ФормаЗаписи",, ЭтаФорма, ЭтаФорма.УникальныйИдентификатор);
	ФормаНового.Запись.Период 		= НачалоДня(ТекущаяДата());
	ФормаНового.Запись.Маршрут 		= Объект.Ссылка;
	ФормаНового.Запись.Водитель 	= ТекДанные.Водитель;
	ФормаНового.Запись.Автомобиль 	= ТекДанные.Автомобиль;
	ФормаНового.Запись.Контрагент 	= Объект.Перевозчик;
	ФормаНового.ОткрытьМодально();
	
	Элементы.ВодителиПоМаршруту.Обновить();
	ОбновитьПеревозчика();
	
КонецПроцедуры

&НаКлиенте
Процедура ВодителиПоМаршрутуИзменить(Команда)
	
	Если Объект.Ссылка.Пустая() Тогда
		Возврат;
	КонецЕсли;
	
	ТекДанные = Элементы.ВодителиПоМаршруту.ТекущиеДанные;
	Если ТекДанные = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	//
	СтруктураЗаписи = Новый Структура;
	СтруктураЗаписи.Вставить("Период"	, ТекДанные.Период);
	СтруктураЗаписи.Вставить("Маршрут"	, Объект.Ссылка);
	
	Попытка
		мКлючЗаписи = ПолучитьКлючЗаписиВодителиМаршрута(СтруктураЗаписи);
		ОткрытьФормуМодально("РегистрСведений.ВодителиПоМаршруту.ФормаЗаписи", Новый Структура("Ключ", мКлючЗаписи));
		
		Элементы.ВодителиПоМаршруту.Обновить();
		ОбновитьПеревозчика();
	Исключение
        Сообщить(ОписаниеОшибки());
	КонецПопытки;
	
КонецПроцедуры

Процедура УдалитьЗаписьРегистраВодителиПоМаршруту(ТекПериод)
	
	НаборЗаписей = РегистрыСведений.ВодителиПоМаршруту.СоздатьНаборЗаписей();
	НаборЗаписей.Отбор.Период.Установить(ТекПериод);
	НаборЗаписей.Отбор.Маршрут.Установить(Объект.Ссылка);
	НаборЗаписей.Прочитать();
	
	НаборЗаписей.Очистить();
	Попытка
		НаборЗаписей.Записать();
	Исключение
		СообщениеПользователю = Новый СообщениеПользователю;
		СообщениеПользователю.Текст = "Не удалось удалить запись регистра ""Водители по маршруту""";
		СообщениеПользователю.Сообщить();
	КонецПопытки;
	
КонецПроцедуры

&НаКлиенте
Процедура ВодителиПоМаршрутуУдалить(Команда)
	
	ТекДанные = Элементы.ВодителиПоМаршруту.ТекущиеДанные;
	Если ТекДанные = Неопределено
			ИЛИ Вопрос("Запись будет удалена. Вы уверены?", РежимДиалогаВопрос.ДаНет) = КодВозвратаДиалога.Нет Тогда
		Возврат;
	КонецЕсли;
	
	УдалитьЗаписьРегистраВодителиПоМаршруту(ТекДанные.Период);
		
	Элементы.ВодителиПоМаршруту.Обновить();
	ОбновитьПеревозчика();
	
КонецПроцедуры

&НаКлиенте
Процедура ВодителиПоМаршрутуВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	
	ТекДанные = Элементы.ВодителиПоМаршруту.ТекущиеДанные;
	Если ТекДанные = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	//
	СтруктураЗаписи = Новый Структура;
	СтруктураЗаписи.Вставить("Период"	, ТекДанные.Период);
	СтруктураЗаписи.Вставить("Маршрут"	, Объект.Ссылка);
	
	Попытка
		мКлючЗаписи = ПолучитьКлючЗаписиВодителиМаршрута(СтруктураЗаписи);
		ОткрытьФормуМодально("РегистрСведений.ВодителиПоМаршруту.ФормаЗаписи", Новый Структура("Ключ", мКлючЗаписи));
		
		Элементы.ВодителиПоМаршруту.Обновить();
		ОбновитьПеревозчика();
	Исключение
        Сообщить(ОписаниеОшибки());
	КонецПопытки;
	
КонецПроцедуры

//+++АК sole 2018.05.29 ИП-00018724.02
&НаКлиенте
Процедура ТарифыНаДоставкуПоМаршрутуПередНачаломДобавления(Элемент, Отказ, Копирование, Родитель, Группа, Параметр)
	Если ЭтаФорма.ЕдиныйТариф И ЭтаФорма.ТарифыНаДоставкуПоМаршруту.Количество() >= 1 Тогда
		Отказ = Истина;	
		Возврат;
	КонецЕсли;
КонецПроцедуры

//+++АК sole 2018.05.29 ИП-00018724.02
&НаКлиенте
Процедура ЕдиныйТарифПриИзменении(Элемент)
	АК_УстановитьВидимостьКолонкиВесОт();
	ЭтаФорма.ТарифыНаДоставкуПоМаршруту.Очистить();
	ЭтаФорма.Модифицированность = Истина;
КонецПроцедуры

//+++АК sole 2018.05.29 ИП-00018724.02
&НаКлиенте
Процедура СтавкаНДСПриИзменении(Элемент)
	Если 
			ЭтаФорма.СтавкаНДС <> ПредопределенноеЗначение("Перечисление.СтавкиНДС.БезНДС") 	
		И	(
					ЭтаФорма.ВариантРасчетаНДС = ПредопределенноеЗначение("Перечисление.ВариантыРасчетаНДС.БезНДС") 
				ИЛИ НЕ ЗначениеЗаполнено(ЭтаФорма.ВариантРасчетаНДС)
			)
		Тогда
		
			ЭтаФорма.ВариантРасчетаНДС = ПредопределенноеЗначение("Перечисление.ВариантыРасчетаНДС.НДСсверху");
	КонецЕсли;
	
	РассчитатьСуммуНДС();
	
	ЭтаФорма.Модифицированность = Истина;
КонецПроцедуры

//+++АК sole 2018.05.29 ИП-00018724.02
&НаКлиенте
Процедура ВариантРасчетаНДСПриИзменении(Элемент)
	
	Если ЭтаФорма.ВариантРасчетаНДС = ПредопределенноеЗначение("Перечисление.ВариантыРасчетаНДС.БезНДС") Тогда
		ЭтаФорма.СтавкаНДС = ПредопределенноеЗначение("Перечисление.СтавкиНДС.БезНДС");
	КонецЕсли;
	РассчитатьСуммуНДС();
	
	ЭтаФорма.Модифицированность = Истина;
КонецПроцедуры

//+++АК sole 2018.05.29 ИП-00018724.02
&НаСервере
Процедура АК_ЗаполнитьСведенияОТарифе()
	
	Перем ЭтотОбъект;
	
	ЭтотОбъект = РеквизитФормыВЗначение("Объект");
	тзТариф = ЭтотОбъект.АК_ПолучитьТаблицуТарифовИзРегистра();
	
	Если тзТариф.Количество() = 0 Тогда
		ЭтаФорма.ВариантРасчетаНДС = ПредопределенноеЗначение("Перечисление.ВариантыРасчетаНДС.БезНДС");
		ЭтаФорма.СтавкаНДС = ПредопределенноеЗначение("Перечисление.СтавкиНДС.БезНДС");
		ЭтаФорма.ТарифыНаДоставкуПериод = НачалоДня(ТекущаяДата());
		Возврат;
	КонецЕсли;
	
	Стр = тзТариф[0];
	ЭтаФорма.ЕдиныйТариф = Стр["ЕдиныйТариф"];
	ЭтаФорма.СтавкаНДС = Стр["СтавкаНДС"];
	ЭтаФорма.ВариантРасчетаНДС = Стр["ВариантРасчетаНДС"];
	ЭтаФорма.ТарифыНаДоставкуПериод = Стр["Период"];
	
	ЭтаФорма.ТарифыНаДоставкуПоМаршруту.Очистить();
	
	Для Каждого Стр Из тзТариф Цикл
		НСтр = ЭтаФорма.ТарифыНаДоставкуПоМаршруту.Добавить();
		ЗаполнитьЗначенияСвойств(НСтр, Стр);
	КонецЦикла;
	
	АК_УстановитьВидимостьКолонкиВесОт();
КонецПроцедуры

//+++АК sole 2018.05.29 ИП-00018724.02
Процедура АК_УстановитьВидимостьКолонкиВесОт()
	
	Если ЭтаФорма.ЕдиныйТариф Тогда
		ЭтаФорма.Элементы.ТарифыНаДоставкуПоМаршруту.ПодчиненныеЭлементы.ТарифыНаДоставкуПоМаршрутуВесОт.Видимость = Ложь;
	Иначе
		ЭтаФорма.Элементы.ТарифыНаДоставкуПоМаршруту.ПодчиненныеЭлементы.ТарифыНаДоставкуПоМаршрутуВесОт.Видимость = Истина;
	КонецЕсли;
	
КонецПроцедуры

//+++АК sole 2018.05.30 ИП-00018724.02
&НаСервере
Процедура АК_ПроверитьДублиВесовВТарифе(Отказ)
	
	тзТариф = ЭтаФорма.ТарифыНаДоставкуПоМаршруту.Выгрузить();
	тзТариф.Колонки.Добавить("Кол",Новый ОписаниеТипов("Число"));
	
	Для Каждого Стр Из тзТариф Цикл
		Стр["Кол"] = 1;
	КонецЦикла;
	
	тзТариф.Свернуть("ВесОт", "Кол");
	
	Для Каждого Стр Из тзТариф  Цикл
		Если Стр["Кол"] = 1 Тогда
			Продолжить;
		КонецЕсли;
		
		ОбщегоНазначения.СообщитьОбОшибке
		(
			"В таблице ""Тарифы на доставку"", для веса """ + Стр["ВесОт"] + """ присутствует несколько строк. Пожалуйста, оставьте в таблице для этого веса только одну строку!",
			Отказ
		);
	КонецЦикла;
	
КонецПроцедуры

//+++АК sole 2018.05.30 ИП-00018724.02
&НаКлиенте
Процедура ТарифыНаДоставкуПоМаршрутуПриИзменении(Элемент)
	ЭтаФорма.Модифицированность = Истина;
КонецПроцедуры

//+++АК sole 2018.07.25 ИП-00019199
&НаКлиенте
Процедура ТарифыНаДоставкуПоМаршрутуПриНачалеРедактирования(Элемент, НоваяСтрока, Копирование)
	Если НоваяСтрока Тогда
		Элемент.ТекущиеДанные.ЦенаЗаКг = Истина;	
	КонецЕсли;
КонецПроцедуры

