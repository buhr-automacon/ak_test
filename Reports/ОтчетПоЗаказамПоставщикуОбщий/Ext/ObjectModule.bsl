﻿
Процедура ПриКомпоновкеРезультата(ДокументРезультат, ДанныеРасшифровки, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	мДатаРаспределения 	= Дата(1, 1, 1);
	мРасчетчик			= Справочники.Расчетчики.ПустаяСсылка();
	мСклад				= Справочники.СтруктурныеЕдиницы.ПустаяСсылка();
	Для Каждого ПользПоле Из ЭтотОбъект.КомпоновщикНастроек.ПользовательскиеНастройки.Элементы Цикл
		Если ТипЗнч(ПользПоле) = Тип("ЗначениеПараметраНастроекКомпоновкиДанных") Тогда
			Если Строка(ПользПоле.Параметр) = "ДатаПоказателей" Тогда
				мДатаРаспределения 	= ПользПоле.Значение.Дата;
			ИначеЕсли Строка(ПользПоле.Параметр) = "Расчетчик" Тогда
				мРасчетчик 			= ПользПоле.Значение;
			ИначеЕсли Строка(ПользПоле.Параметр) = "Склад" Тогда
				мСклад 				= ПользПоле.Значение;
			КонецЕсли;
		КонецЕсли;	
	КонецЦикла;
	
	Заголовок1 	= "Заказано на " + Формат(мДатаРаспределения			, "ДЛФ=Д");
	Заголовок2 	= "Заказано на " + Формат(мДатаРаспределения + 86400	, "ДЛФ=Д");
	Заголовок3 	= "Заказано на " + Формат(мДатаРаспределения + 2*86400	, "ДЛФ=Д");
	Заголовок4 	= "Заказано на " + Формат(мДатаРаспределения + 3*86400	, "ДЛФ=Д");
	Заголовок5 	= "Заказано на " + Формат(мДатаРаспределения + 4*86400	, "ДЛФ=Д");
	Заголовок6 	= "Заказано на " + Формат(мДатаРаспределения + 5*86400	, "ДЛФ=Д");
	
	ПолеКомпоновкиКолЗаказ1 = Новый ПолеКомпоновкиДанных("КоличествоЗаказ");
	ПолеКомпоновкиКолЗаказ2 = Новый ПолеКомпоновкиДанных("КоличествоЗаказ2");
	ПолеКомпоновкиКолЗаказ3 = Новый ПолеКомпоновкиДанных("КоличествоЗаказ3");
	ПолеКомпоновкиКолЗаказ4 = Новый ПолеКомпоновкиДанных("КоличествоЗаказ4");
	ПолеКомпоновкиКолЗаказ5 = Новый ПолеКомпоновкиДанных("КоличествоЗаказ5");
	ПолеКомпоновкиКолЗаказ6 = Новый ПолеКомпоновкиДанных("КоличествоЗаказ6");
	
	ЭлементыПолейВыбора = ЭтотОбъект.КомпоновщикНастроек.Настройки.Выбор.Элементы;
	Для Каждого ПолеВыбора Из ЭлементыПолейВыбора Цикл
		Если ПолеВыбора.Поле = ПолеКомпоновкиКолЗаказ1 Тогда
            ПолеВыбора.Заголовок = Заголовок1;
		ИначеЕсли ПолеВыбора.Поле = ПолеКомпоновкиКолЗаказ2 Тогда
            ПолеВыбора.Заголовок = Заголовок2;
		ИначеЕсли ПолеВыбора.Поле = ПолеКомпоновкиКолЗаказ3 Тогда
            ПолеВыбора.Заголовок = Заголовок3;
		ИначеЕсли ПолеВыбора.Поле = ПолеКомпоновкиКолЗаказ4 Тогда
            ПолеВыбора.Заголовок = Заголовок4;
		ИначеЕсли ПолеВыбора.Поле = ПолеКомпоновкиКолЗаказ5 Тогда
            ПолеВыбора.Заголовок = Заголовок5;
		ИначеЕсли ПолеВыбора.Поле = ПолеКомпоновкиКолЗаказ6 Тогда
            ПолеВыбора.Заголовок = Заголовок6;
		КонецЕсли;
	КонецЦикла;
	
	
	//
	//+++АК KIRN 2018.07.31  ИП-00012852.07
	ТаблицаДанных = Отчеты.ОтчетПоЗаказамПоставщикуОбщий.ПолучитьДанныеДляФормирования(мДатаРаспределения, мРасчетчик, мСклад,
						ЭтотОбъект.ДнейПродажВГруппировке, ЭтотОбъект.ГлубинаАнализа, ЭтотОбъект.ВыводитьТТМиниТТПусто, ЭтотОбъект.ВыводитьТолькоВВ,
						ЭтотОбъект.ВыводитьДополнительныеСтолбцы, ЭтотОбъект.ИспользоватьНормативныйКвантДляРасчетаПлановогоОстатка);
	//ТаблицаДанных = Отчеты.ОтчетПоЗаказамПоставщикуОбщий.ПолучитьДанныеДляФормирования(мДатаРаспределения, мРасчетчик, мСклад,
	//					ЭтотОбъект.ДнейПродажВГруппировке, ЭтотОбъект.ГлубинаАнализа, ЭтотОбъект.ВыводитьТТМиниТТПусто, ЭтотОбъект.ВыводитьТолькоВВ,
	//					ЭтотОбъект.ВыводитьДополнительныеСтолбцы);
	//---АК KIRN 
	
	//
	Настройки = ЭтотОбъект.КомпоновщикНастроек.ПолучитьНастройки();

	// Формируем макет, с помощью компоновщика макета
	КомпоновщикМакета = Новый КомпоновщикМакетаКомпоновкиДанных;

	// Передаем в макет компоновки схему, настройки и данные расшифровки
	мСхемаКомпоновки = ?(НЕ ЭтотОбъект.ВыводитьДополнительныеСтолбцы, ЭтотОбъект.ПолучитьМакет("Макет"), ЭтотОбъект.ПолучитьМакет("ДопМакет"));
	МакетКомпоновки = КомпоновщикМакета.Выполнить(мСхемаКомпоновки, Настройки, ДанныеРасшифровки);

	// Выполним компоновку с помощью процессора компоновки
	ВнешниеНаборыДанных = Новый Структура;
	ВнешниеНаборыДанных.Вставить("ДанныеДляФормирования", ТаблицаДанных);
	
	ПроцессорКомпоновкиДанных = Новый ПроцессорКомпоновкиДанных;
	ПроцессорКомпоновкиДанных.Инициализировать(МакетКомпоновки, ВнешниеНаборыДанных, ДанныеРасшифровки);

	// Выводим результат в табличный документ
	ПроцессорВывода = Новый ПроцессорВыводаРезультатаКомпоновкиДанныхВТабличныйДокумент;
	ПроцессорВывода.УстановитьДокумент(ДокументРезультат);
	ПроцессорВывода.Вывести(ПроцессорКомпоновкиДанных);	
	
КонецПроцедуры
