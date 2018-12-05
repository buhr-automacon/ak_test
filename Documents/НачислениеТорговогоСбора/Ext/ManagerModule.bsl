﻿
Процедура ВыгрузитьВБухгалтерию(Ссылка) Экспорт
	
	//ИмяСервераИнформационнойБазыДляПодключения 	= "10.0.0.15";
	//ИмяИнформационнойБазыНаСервереДляПодключения 	= "BP_CORP";
	//ПользовательИнформационнойБазыДляПодключения 	= "Обмен";
	//ПарольИнформационнойБазыДляПодключения			= "123321";
	СтруктураПодключения = ПолныеПрава.ПолучитьСтрокуПодключенияСтруктурой_Бух();
	ИмяСервераИнформационнойБазыДляПодключения 				= СтруктураПодключения.ИмяСервера;
	ИмяИнформационнойБазыНаСервереДляПодключения 			= СтруктураПодключения.ИмяБазы;
	АутентификацияWindowsИнформационнойБазыДляПодключения 	= Ложь;
	ПользовательИнформационнойБазыДляПодключения 			= СтруктураПодключения.Пользователь;
	ПарольИнформационнойБазыДляПодключения 					= СтруктураПодключения.Пароль;
	
	
	Попытка
		
		Коннектор = Новый COMObject(ПолныеПрава.ПолучитьВерсиюКомОбъекта_Бух() + ".COMConnector");
		// создается объект COM-соединение
		
		Строка = "Srvr="""+СокрЛП(ИмяСервераИнформационнойБазыДляПодключения)+""";Ref="""+СокрЛП(ИмяИнформационнойБазыНаСервереДляПодключения)+""";Usr="""+СокрЛП(ПользовательИнформационнойБазыДляПодключения)+""";Pwd="+ПарольИнформационнойБазыДляПодключения+";";
		СоединениеСБазой = Коннектор.Connect(Строка);
	Исключение
		СоединениеСБазой = Неопределено;
		Сообщить("Подключится к базе невозможно! " + Символы.ПС+Строка(ОписаниеОшибки()));
		Возврат;
	КонецПопытки;
	
	СвойствоУин = СоединениеСБазой.ПланыВидовХарактеристик.СвойстваОбъектов.НайтиПоНаименованию("УИН начисления торгового сбора");
	УинВТекущейБазе = Строка(Ссылка.УникальныйИдентификатор());
	
	Запрос = СоединениеСБазой.NewObject("Запрос");
	Запрос.УстановитьПараметр("Свойство", СвойствоУин);
	Запрос.УстановитьПараметр("Значение", УинВТекущейБазе);
	Запрос.Текст = "ВЫБРАТЬ
					|	ЗначенияСвойствОбъектов.Объект
					|ИЗ
					|	РегистрСведений.ЗначенияСвойствОбъектов КАК ЗначенияСвойствОбъектов
					|ГДЕ
					|	ЗначенияСвойствОбъектов.Свойство = &Свойство
					|	И ЗначенияСвойствОбъектов.Значение = &Значение";
					
	Выборка = Запрос.Выполнить().Выбрать();
	ДокВБухии = Неопределено;
	Если Выборка.Следующий() Тогда
		ДокВБухии = Выборка.Объект;
	КонецЕсли;
	
	Если ДокВБухии = Неопределено Тогда
		ДокВБухииОбъект = СоединениеСБазой.Документы.ОперацияБух.СоздатьДокумент();
		ДокВБухииОбъект.ЗаполнениеДвижений.Добавить();
	Иначе
		ДокВБухииОбъект = ДокВБухии.ПолучитьОбъект();
	КонецЕсли;
	
	ДокВБухииОбъект.Дата = Ссылка.Дата;
	ДокВБухииОбъект.Организация = СоединениеСБазой.Справочники.Организации.НайтиПоРеквизиту("ИНН", Ссылка.Организация.ИНН);
	ДокВБухииОбъект.Комментарий = "Торговый сбор за " + Формат(Ссылка.КварталОбработки, "ДФ='к ""квартал"" yyyy'");
	ДокВБухииОбъект.Содержание = ДокВБухииОбъект.Комментарий;
	
	ДокВБухииОбъект.Движения.Хозрасчетный.Очистить();
	
	Если Ссылка.Проведен Тогда
		СуммаОперации = Ссылка.ТорговыеТочки.Выгрузить().Итог("Сумма");
		Движение = ДокВБухииОбъект.Движения.Хозрасчетный.Добавить();
		Движение.Период = ДокВБухииОбъект.Дата;
		Движение.Организация = ДокВБухииОбъект.Организация;
		//Движение.СчетДт = СоединениеСБазой.ПланыСчетов.Хозрасчетный.НайтиПоКоду("68.04.1");
		//СоединениеСБазой.БухгалтерскийУчет.УстановитьСубконто(Движение.СчетДт, Движение.СубконтоДт, 1, СоединениеСБазой.Перечисления.ВидыПлатежейВГосБюджет.Налог);
		//СоединениеСБазой.БухгалтерскийУчет.УстановитьСубконто(Движение.СчетДт, Движение.СубконтоДт, 2, СоединениеСБазой.Перечисления.УровниБюджетов.РегиональныйБюджет); 
		//Если Ссылка.Организация.ИНН = "7734675810" Тогда
		//	СоединениеСБазой.БухгалтерскийУчет.УстановитьСубконто(Движение.СчетДт, Движение.СубконтоДт, 3, СоединениеСБазой.Справочники.РегистрацияВИФНС.НайтиПоКоду("7734",,, ДокВБухииОбъект.Организация));
		//Иначе
		//	СоединениеСБазой.БухгалтерскийУчет.УстановитьСубконто(Движение.СчетДт, Движение.СубконтоДт, 3, СоединениеСБазой.Справочники.РегистрацияВИФНС.НайтиПоНаименованию("ИФНС России №26 по г.Москве(основная)",,, ДокВБухииОбъект.Организация));
		//КонецЕсли;
		//
		//Движение.СчетКт = СоединениеСБазой.ПланыСчетов.Хозрасчетный.НайтиПоКоду("68.13");
		//СоединениеСБазой.БухгалтерскийУчет.УстановитьСубконто(Движение.СчетКт, Движение.СубконтоКт, 1, СоединениеСБазой.Перечисления.ВидыПлатежейВГосБюджет.Налог);
		
		Движение.СчетДт = СоединениеСБазой.ПланыСчетов.Хозрасчетный.НайтиПоКоду("99.09");
		Движение.СчетКт = СоединениеСБазой.ПланыСчетов.Хозрасчетный.НайтиПоКоду("68.13");
		СоединениеСБазой.БухгалтерскийУчет.УстановитьСубконто(Движение.СчетКт, Движение.СубконтоКт, 1, СоединениеСБазой.Перечисления.ВидыПлатежейВГосБюджет.Налог);
		Движение.Сумма = СуммаОперации;
		
		Движение = ДокВБухииОбъект.Движения.Хозрасчетный.Добавить();
		Движение.Период = ДокВБухииОбъект.Дата;
		Движение.Организация = ДокВБухииОбъект.Организация;
		Движение.СчетДт = СоединениеСБазой.ПланыСчетов.Хозрасчетный.НайтиПоКоду("68.04.2");
		Движение.СчетКт = СоединениеСБазой.ПланыСчетов.Хозрасчетный.НайтиПоКоду("99.02.1");
		
		Движение.Сумма = СуммаОперации;
	КонецЕсли;	
	
	ДокВБухииОбъект.СуммаОперации = 0;

	Для каждого Проводка Из ДокВБухииОбъект.Движения.Хозрасчетный Цикл
		ДокВБухииОбъект.СуммаОперации = ДокВБухииОбъект.СуммаОперации + Проводка.Сумма;
	КонецЦикла;
	
	ДокВБухииОбъект.Записать();
	
	Запись = СоединениеСБазой.РегистрыСведений.ЗначенияСвойствОбъектов.СоздатьМенеджерЗаписи();
	Запись.Объект = ДокВБухииОбъект.Ссылка;
	Запись.Свойство = СвойствоУин;
	Запись.Значение = УинВТекущейБазе;
	Запись.Записать();
	
	Если НЕ Ссылка.ВыгруженВБухгалтерию
		ИЛИ Ссылка.ПослеВыгрузкиВносилисьИзменения Тогда
		ДокОб = Ссылка.ПолучитьОбъект();
		ДокОб.ВыгруженВБухгалтерию = Истина;
		ДокОб.ПослеВыгрузкиВносилисьИзменения = Ложь;
		ДокОб.Записать(РежимЗаписиДокумента.Запись);
	КонецЕсли;	
	
КонецПроцедуры	