﻿
Процедура ЗаполнитьПоГруппеТоваровСервер(ГруппаТоваров)
	
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("Группа", ГруппаТоваров);
	Запрос.Текст =
	"ВЫБРАТЬ РАЗРЕШЕННЫЕ
	|	Номенклатура.Ссылка КАК Номенклатура,
	|	ХарактеристикиНоменклатуры.Ссылка КАК Характеристика
	|ИЗ
	|	Справочник.Номенклатура КАК Номенклатура
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ Справочник.ХарактеристикиНоменклатуры КАК ХарактеристикиНоменклатуры
	|		ПО Номенклатура.Ссылка = ХарактеристикиНоменклатуры.Владелец
	|ГДЕ
	|	ХарактеристикиНоменклатуры.Неактивная = ЛОЖЬ
	|	И Номенклатура.Ссылка В ИЕРАРХИИ(&Группа)
	|
	|УПОРЯДОЧИТЬ ПО
	|	Номенклатура.Наименование";
	
	Выборка = Запрос.Выполнить().Выбрать();
	Пока Выборка.Следующий() Цикл
		СтрокаДоб = РасчетНаценки.Добавить();
		ЗаполнитьЗначенияСвойств(СтрокаДоб, Выборка);
	КонецЦикла;	
	
КонецПроцедуры	

&НаКлиенте
Процедура ЗаполнитьПоГруппеТоваров(Команда)
	
	Результат = ОткрытьФормуМодально("Справочник.Номенклатура.Форма.ФормаВыбораГруппыУпр", Новый Структура("РежимВыбора, ЗакрыватьПриВыборе", Истина, Истина));
	Если ЗначениеЗаполнено(Результат) Тогда
		ЗаполнитьПоГруппеТоваровСервер(Результат);
		ЗаполнитьПоВыбранномуРежиму();
		Для Каждого СтрокаТаб Из РасчетНаценки Цикл
			ПересчитатьПроцентНаценкиПоСтроке(СтрокаТаб);
		КонецЦикла;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура РасчетНаценкиНоменклатураПриИзменении(Элемент)
	
	Элементы.РасчетНаценки.ТекущиеДанные.Характеристика = Неопределено;
	ЗаполнитьПоВыбранномуРежиму(Элементы.РасчетНаценки.ТекущиеДанные.ПолучитьИдентификатор());
	ПересчитатьПроцентНаценкиПоСтроке(Элементы.РасчетНаценки.ТекущиеДанные);
	
КонецПроцедуры

Процедура ЗаполнитьПоПоставщикуСервер(Поставщик)
	
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("Значение", Поставщик);
	Запрос.Текст =
	"ВЫБРАТЬ РАЗРЕШЕННЫЕ
	|	ХарактеристикиНоменклатуры.Владелец КАК Номенклатура,
	|	ХарактеристикиНоменклатуры.Ссылка КАК Характеристика
	|ИЗ
	|	Справочник.ХарактеристикиНоменклатуры КАК ХарактеристикиНоменклатуры
	|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.ЗначенияСвойствОбъектов КАК ЗначенияСвойствОбъектов
	|		ПО ХарактеристикиНоменклатуры.Ссылка = ЗначенияСвойствОбъектов.Объект
	|			И (ЗначенияСвойствОбъектов.Свойство = ЗНАЧЕНИЕ(ПланВидовХарактеристик.СвойстваОбъектов.Производитель))
	|ГДЕ
	|	ХарактеристикиНоменклатуры.Неактивная = ЛОЖЬ
	|	И ЗначенияСвойствОбъектов.Значение = &Значение";
	
	Выборка = Запрос.Выполнить().Выбрать();
	Пока Выборка.Следующий() Цикл
		СтрокаДоб = РасчетНаценки.Добавить();
		ЗаполнитьЗначенияСвойств(СтрокаДоб, Выборка);
		ЗаполнитьПоВыбранномуРежиму();
	КонецЦикла;	
	
КонецПроцедуры

&НаКлиенте
Процедура ЗаполнитьПоПоставщику(Команда)
	
	Результат = ОткрытьФормуМодально("Справочник.Контрагенты.ФормаВыбора", Новый Структура("РежимВыбора, ЗакрыватьПриВыборе", Истина, Истина));
	Если ЗначениеЗаполнено(Результат) Тогда
		ЗаполнитьПоПоставщикуСервер(Результат);
		ЗаполнитьПоВыбранномуРежиму();
		Для Каждого СтрокаТаб Из РасчетНаценки Цикл
			ПересчитатьПроцентНаценкиПоСтроке(СтрокаТаб);
		КонецЦикла;
	КонецЕсли;
	
КонецПроцедуры

Процедура ЗаполнитьПоВыбранномуРежиму(НомерСтрокиКРасчету = 0)
	
	//
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("ТекДата"	, КонецДня(ДатаСебестоимостиЦеныЗакупки));
	Запрос.УстановитьПараметр("Товары"	, РасчетНаценки.Выгрузить().ВыгрузитьКолонку("Номенклатура"));
	Запрос.Текст =
	"ВЫБРАТЬ
	|	Номенклатура.Ссылка КАК Ссылка
	|ПОМЕСТИТЬ ВТ_Товары
	|ИЗ
	|	Справочник.Номенклатура КАК Номенклатура
	|ГДЕ
	|	Номенклатура.Ссылка В(&Товары)
	|
	|ИНДЕКСИРОВАТЬ ПО
	|	Ссылка
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	СебестоимостьТоваровСрезПоследних.Номенклатура,
	|	СебестоимостьТоваровСрезПоследних.Номенклатура.СтавкаНДС КАК СтавкаНДС,
	|	СебестоимостьТоваровСрезПоследних.Себестоимость
	|ИЗ
	|	РегистрСведений.СебестоимостьТоваров.СрезПоследних(
	|			&ТекДата,
	|			Номенклатура В
	|				(ВЫБРАТЬ
	|					ВТ_Товары.Ссылка
	|				ИЗ
	|					ВТ_Товары КАК ВТ_Товары)) КАК СебестоимостьТоваровСрезПоследних
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ЦеныНоменклатурыСрезПоследних.Номенклатура,
	|	ЦеныНоменклатурыСрезПоследних.Цена,
	|	ЦеныНоменклатурыСрезПоследних.Номенклатура.СтавкаНДС КАК СтавкаНДС
	|ИЗ
	|	РегистрСведений.ЦеныНоменклатуры.СрезПоследних(
	|			&ТекДата,
	|			ТорговаяТочка = ЗНАЧЕНИЕ(Справочник.СтруктурныеЕдиницы.ПустаяСсылка)
	|				И ТипЦен = ЗНАЧЕНИЕ(Справочник.ТипыЦен.ОсновнойТипЦенПродаж)
	|				И Номенклатура В
	|					(ВЫБРАТЬ
	|						ВТ_Товары.Ссылка
	|					ИЗ
	|						ВТ_Товары КАК ВТ_Товары)) КАК ЦеныНоменклатурыСрезПоследних
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ЦеныПоставщиковСрезПоследних.Номенклатура,
	|	ЦеныПоставщиковСрезПоследних.Характеристика,
	|	ЦеныПоставщиковСрезПоследних.Цена,
	|	ЦеныПоставщиковСрезПоследних.Поставщик.СтавкаНДС КАК СтавкаНДС
	|ИЗ
	|	РегистрСведений.ЦеныПоставщиков.СрезПоследних(
	|			&ТекДата,
	|			Номенклатура В
	|				(ВЫБРАТЬ
	|					ВТ_Товары.Ссылка
	|				ИЗ
	|					ВТ_Товары КАК ВТ_Товары)) КАК ЦеныПоставщиковСрезПоследних";
				   
	Результаты = Запрос.ВыполнитьПакет();
	ТабСебестоимость 	= Результаты[1].Выгрузить();
	ТабРозничные 		= Результаты[2].Выгрузить();
	ТабЗакупочные 		= Результаты[3].Выгрузить();
	
	//
	Если ВариантРасчета = 3 Тогда
		Запрос.УстановитьПараметр("ДатаНач", НачалоДня(ДатаСебестоимостиЦеныЗакупки - 86400 * КолвоДнейДляОценкиПотерь));
		Запрос.УстановитьПараметр("ДатаКон", КонецДня(ДатаСебестоимостиЦеныЗакупки));
		Запрос.Текст =
		"ВЫБРАТЬ
		|	ПоступлениеТоваровУслугТовары.Номенклатура,
		|	СУММА(ПоступлениеТоваровУслугТовары.Сумма) КАК Сумма,
		|	СУММА(ПоступлениеТоваровУслугТовары.Количество) КАК Количество,
		|	ПоступлениеТоваровУслугТовары.Ссылка,
		|	ЗначенияСвойствОбъектов.Объект КАК Характеристика
		|ИЗ
		|	Документ.ПоступлениеТоваровУслуг.Товары КАК ПоступлениеТоваровУслугТовары
		|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.ЗначенияСвойствОбъектов КАК ЗначенияСвойствОбъектов
		|		ПО (ВЫБОР
		|				КОГДА ПоступлениеТоваровУслугТовары.Ссылка.Контрагент.ГоловнойКонтрагент = ЗНАЧЕНИЕ(Справочник.Контрагенты.ПустаяСсылка)
		|					ТОГДА ПоступлениеТоваровУслугТовары.Ссылка.Контрагент
		|				ИНАЧЕ ПоступлениеТоваровУслугТовары.Ссылка.Контрагент.ГоловнойКонтрагент
		|			КОНЕЦ = ВЫБОР
		|				КОГДА ВЫРАЗИТЬ(ЗначенияСвойствОбъектов.Значение КАК Справочник.Контрагенты).ГоловнойКонтрагент = ЗНАЧЕНИЕ(Справочник.Контрагенты.ПустаяСсылка)
		|					ТОГДА ЗначенияСвойствОбъектов.Значение
		|				ИНАЧЕ ВЫРАЗИТЬ(ЗначенияСвойствОбъектов.Значение КАК Справочник.Контрагенты).ГоловнойКонтрагент
		|			КОНЕЦ)
		|			И (ЗначенияСвойствОбъектов.Свойство = ЗНАЧЕНИЕ(ПланВидовХарактеристик.СвойстваОбъектов.Производитель))
		|ГДЕ
		|	ПоступлениеТоваровУслугТовары.Ссылка.Дата МЕЖДУ &ДатаНач И &ДатаКон
		|	И ПоступлениеТоваровУслугТовары.Ссылка.Проведен = ИСТИНА
		|	И ПоступлениеТоваровУслугТовары.Номенклатура В(&Товары)
		|
		|СГРУППИРОВАТЬ ПО
		|	ПоступлениеТоваровУслугТовары.Номенклатура,
		|	ПоступлениеТоваровУслугТовары.Ссылка,
		|	ЗначенияСвойствОбъектов.Объект
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	ЗатратыНаДоставкуПоПоставщикамОбороты.Номенклатура,
		|	ЗатратыНаДоставкуПоПоставщикамОбороты.Характеристика,
		|	СУММА(ЗатратыНаДоставкуПоПоставщикамОбороты.СуммаОборот) КАК СуммаОборот
		|ИЗ
		|	РегистрНакопления.ЗатратыНаДоставкуПоПоставщикам.Обороты(&ДатаНач, &ДатаКон, , Номенклатура В (&Товары)) КАК ЗатратыНаДоставкуПоПоставщикамОбороты
		|
		|СГРУППИРОВАТЬ ПО
		|	ЗатратыНаДоставкуПоПоставщикамОбороты.Номенклатура,
		|	ЗатратыНаДоставкуПоПоставщикамОбороты.Характеристика
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	ФинансовыйОбороты.Регистратор,
		|	ФинансовыйОбороты.Субконто2 КАК Номенклатура,
		|	ФинансовыйОбороты.СуммаОборот
		|ИЗ
		|	РегистрБухгалтерии.Финансовый.Обороты(&ДатаНач, &ДатаКон, Регистратор, Счет = ЗНАЧЕНИЕ(ПланСчетов.Финансовый.Товары), , Субконто2 В (&Товары), КорСчет = ЗНАЧЕНИЕ(ПланСчетов.Финансовый.МатералыДляВыпуска), ) КАК ФинансовыйОбороты
		|ГДЕ
		|	ФинансовыйОбороты.Регистратор ССЫЛКА Документ.ПоступлениеТоваровУслуг";
					   
		Результаты = Запрос.ВыполнитьПакет();
		ТабПоступления 		= Результаты[0].Выгрузить();
		ТабЗатратыДоставка 	= Результаты[1].Выгрузить();
		ТабУпаковка 		= Результаты[2].Выгрузить();
	КонецЕсли;	
	
	Для Каждого СтрокаТаб Из РасчетНаценки Цикл
		Если ЗначениеЗаполнено(НомерСтрокиКРасчету)
			И НомерСтрокиКРасчету <> СтрокаТаб.ПолучитьИдентификатор() Тогда
			Продолжить;
		КонецЕсли;	
		СтрокаРознЦена = ТабРозничные.Найти(СтрокаТаб.Номенклатура, "Номенклатура");
		Если СтрокаРознЦена <> Неопределено Тогда
			СтрокаТаб.РозничнаяЦена = СтрокаРознЦена.Цена;
		Иначе	
			СтрокаТаб.РозничнаяЦена = 0;
		КонецЕсли;
		
		СтрокиРознЦена = ТабЗакупочные.НайтиСтроки(Новый Структура("Номенклатура, Характеристика", СтрокаТаб.Номенклатура, СтрокаТаб.Характеристика));
		Если СтрокиРознЦена.Количество() > 0 Тогда
			СтрокаТаб.СтараяЗакупочная = СтрокиРознЦена[0].Цена;
		Иначе	
			СтрокаТаб.СтараяЗакупочная = 0;
		КонецЕсли;
		
		СтрокаСебест = ТабСебестоимость.Найти(СтрокаТаб.Номенклатура, "Номенклатура");
		Если СтрокаСебест <> Неопределено Тогда
			НДС = УчетНДС.ПолучитьСтавкуНДС(СтрокаСебест.СтавкаНДС);
			СтрокаТаб.Себестоимость = СтрокаСебест.Себестоимость + СтрокаСебест.Себестоимость * НДС / 100;
		Иначе
			СтрокаТаб.Себестоимость = 0;
		КонецЕсли;
		
		Если ВариантРасчета = 0 Тогда
			//СтрокаСебест = ТабСебестоимость.Найти(СтрокаТаб.Номенклатура, "Номенклатура");
			//Если СтрокаСебест <> Неопределено Тогда
			//	СтрокаТаб.Себестоимость = СтрокаСебест.Себестоимость;
			//Иначе
			//	СтрокаТаб.Себестоимость = 0;
			//КонецЕсли;
		ИначеЕсли ВариантРасчета = 1 Тогда
			СтрокаТаб.ЗакупочнаяЦена = СтрокаТаб.СтараяЗакупочная;
		ИначеЕсли ВариантРасчета = 2 Тогда
			СтрокаТаб.ЗакупочнаяЦена = 0;
		ИначеЕсли ВариантРасчета = 3 Тогда
			СтрокаТаб.СуммаПоставок = 0;
			СтрокаТаб.СуммаДоставка = 0;
			СтрокаТаб.СуммаУпаковка = 0;
			СтрокаТаб.КоличествоВПоставках = 0;
			СтрокиПоступления = ТабПоступления.НайтиСтроки(Новый Структура("Номенклатура, Характеристика", СтрокаТаб.Номенклатура, СтрокаТаб.Характеристика));
			Для Каждого СтрокаПоступления Из СтрокиПоступления Цикл
				СтрокаТаб.СуммаПоставок = СтрокаТаб.СуммаПоставок + СтрокаПоступления.Сумма;
				СтрокаТаб.КоличествоВПоставках = СтрокаТаб.КоличествоВПоставках + СтрокаПоступления.Количество;
				СтрокиУпаковка = ТабУпаковка.НайтиСтроки(Новый Структура("Регистратор, Номенклатура", СтрокаПоступления.Ссылка, СтрокаТаб.Номенклатура));
				Для Каждого СтрокаУпаковка Из СтрокиУпаковка Цикл
					СтрокаТаб.СуммаУпаковка = СтрокаТаб.СуммаУпаковка + СтрокаУпаковка.СуммаОборот;
				КонецЦикла;	
			КонецЦикла;
			СтрокиДоставка = ТабЗатратыДоставка.НайтиСтроки(Новый Структура("Номенклатура, Характеристика", СтрокаТаб.Номенклатура, СтрокаТаб.Характеристика));
			Для Каждого СтрокаДоставка Из СтрокиДоставка Цикл
				СтрокаТаб.СуммаДоставка = СтрокаТаб.СуммаДоставка + СтрокаДоставка.СуммаОборот;
			КонецЦикла;
			Если СтрокаТаб.КоличествоВПоставках = 0 Тогда
				СтрокаТаб.Себестоимость = 0;
			Иначе
				СтрокаТаб.Себестоимость = (СтрокаТаб.СуммаПоставок + СтрокаТаб.СуммаДоставка + СтрокаТаб.СуммаУпаковка) / СтрокаТаб.КоличествоВПоставках;
			КонецЕсли;	
			СтрокаТаб.НоваяЗакупочная = СтрокаТаб.СтараяЗакупочная;
		КонецЕсли;	
	КонецЦикла;	
	
КонецПроцедуры	

&НаКлиенте
Процедура ПерезаполнитьДанныеПоВыбранномуВарианту(Команда)
	
	ЗаполнитьПоВыбранномуРежиму();
	Для Каждого СтрокаТаб Из РасчетНаценки Цикл
		ПересчитатьПроцентНаценкиПоСтроке(СтрокаТаб);
	КонецЦикла;
	
КонецПроцедуры

&НаКлиенте
Процедура ПересчитатьПроцентНаценкиПоСтроке(СтрокаТаб)
	
	Если ВариантРасчета = 0 Тогда
		Если СтрокаТаб.Себестоимость <> 0 Тогда
			СтрокаТаб.ПроцентНаценки = ((СтрокаТаб.РозничнаяЦена / СтрокаТаб.Себестоимость) - 1) * 100;
		Иначе
			СтрокаТаб.ПроцентНаценки = 0;
		КонецЕсли;
	ИначеЕсли ВариантРасчета = 1 Тогда
		Если СтрокаТаб.ЗакупочнаяЦена <> 0 Тогда
			СтрокаТаб.ПроцентНаценки = ((СтрокаТаб.РозничнаяЦена / СтрокаТаб.ЗакупочнаяЦена) - 1) * 100;
		Иначе
			СтрокаТаб.ПроцентНаценки = 0;
		КонецЕсли;
	ИначеЕсли ВариантРасчета = 2 Тогда
		Если СтрокаТаб.ЗакупочнаяЦена <> 0 Тогда
			СтрокаТаб.ПроцентНаценки = ((СтрокаТаб.РозничнаяЦена / СтрокаТаб.ЗакупочнаяЦена) - 1) * 100;
		Иначе
			СтрокаТаб.ПроцентНаценки = 0;
		КонецЕсли;	
	ИначеЕсли ВариантРасчета = 3 Тогда	
		СтрокаТаб.ЗакупочнаяЦена = СтрокаТаб.НоваяЗакупочная + СтрокаТаб.Себестоимость - СтрокаТаб.СтараяЗакупочная;
		Если СтрокаТаб.ЗакупочнаяЦена <> 0 Тогда
			СтрокаТаб.ПроцентНаценки = ((СтрокаТаб.РозничнаяЦена / СтрокаТаб.ЗакупочнаяЦена) - 1) * 100;
		Иначе
			СтрокаТаб.ПроцентНаценки = 0;
		КонецЕсли;
	КонецЕсли;	
	
КонецПроцедуры	

&НаКлиенте
Процедура РасчетНаценкиХарактеристикаПриИзменении(Элемент)
	
	ЗаполнитьПоВыбранномуРежиму(Элементы.РасчетНаценки.ТекущиеДанные.ПолучитьИдентификатор());
	ПересчитатьПроцентНаценкиПоСтроке(Элементы.РасчетНаценки.ТекущиеДанные);
	
КонецПроцедуры

&НаКлиенте
Процедура РасчетНаценкиРозничнаяЦенаБезНДСПриИзменении(Элемент)
	
	ПересчитатьПроцентНаценкиПоСтроке(Элементы.РасчетНаценки.ТекущиеДанные);
	
КонецПроцедуры

&НаКлиенте
Процедура РасчетНаценкиЗакупочнаяЦенаПриИзменении(Элемент)
	
	ПересчитатьПроцентНаценкиПоСтроке(Элементы.РасчетНаценки.ТекущиеДанные);
	
КонецПроцедуры

&НаКлиенте
Процедура ВариантРасчетаПриИзменении(Элемент)
	
	Если ВариантРасчета = 0 Тогда
		Элементы.РасчетНаценкиЗакупочнаяЦена.Видимость 	= Ложь;
		Элементы.РасчетНаценкиСтараяЗакупочная.Видимость = Ложь;
		Элементы.РасчетНаценкиСебестоимость.Видимость 	= Истина;
		Элементы.РасчетНаценкиНоваяЗакупочная.Видимость = Ложь;
		Элементы.ГруппаПараметрыСебестоимости.Видимость = Ложь;
	ИначеЕсли ВариантРасчета = 1 Тогда
		Элементы.РасчетНаценкиЗакупочнаяЦена.Видимость 	= Истина;
		Элементы.РасчетНаценкиСтараяЗакупочная.Видимость = Ложь;
		Элементы.РасчетНаценкиСебестоимость.Видимость 	= Ложь;
		Элементы.РасчетНаценкиНоваяЗакупочная.Видимость = Ложь;
		Элементы.ГруппаПараметрыСебестоимости.Видимость = Ложь;
	ИначеЕсли ВариантРасчета = 2 Тогда
		Элементы.РасчетНаценкиЗакупочнаяЦена.Видимость 	= Истина;
		Элементы.РасчетНаценкиСтараяЗакупочная.Видимость = Ложь;
		Элементы.РасчетНаценкиСебестоимость.Видимость 	= Ложь;	
		Элементы.РасчетНаценкиНоваяЗакупочная.Видимость = Ложь;
		Элементы.ГруппаПараметрыСебестоимости.Видимость = Ложь;
	ИначеЕсли ВариантРасчета = 3 Тогда
		Элементы.РасчетНаценкиЗакупочнаяЦена.Видимость 	= Истина;
		Элементы.РасчетНаценкиНоваяЗакупочная.Видимость = Истина;
		Элементы.РасчетНаценкиСтараяЗакупочная.Видимость = Истина;
		Элементы.РасчетНаценкиСебестоимость.Видимость 	= Истина;
		Элементы.ГруппаПараметрыСебестоимости.Видимость = Истина;
	КонецЕсли;
	
	ЗаполнитьПоВыбранномуРежиму();
	Для Каждого СтрокаТаб Из РасчетНаценки Цикл
		ПересчитатьПроцентНаценкиПоСтроке(СтрокаТаб);
	КонецЦикла;
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	ВариантРасчетаПриИзменении(Неопределено);
	
КонецПроцедуры

&НаКлиенте
Процедура РасчетНаценкиНоваяЗакупочнаяПриИзменении(Элемент)
	
	ПересчитатьПроцентНаценкиПоСтроке(Элементы.РасчетНаценки.ТекущиеДанные);
	
КонецПроцедуры

&НаКлиенте
Процедура РасчетНаценкиСтараяЗакупочнаяПриИзменении(Элемент)
	
	ПересчитатьПроцентНаценкиПоСтроке(Элементы.РасчетНаценки.ТекущиеДанные);
	
КонецПроцедуры

&НаКлиенте
Процедура РасчетНаценкиСебестоимостьПриИзменении(Элемент)
	
	ПересчитатьПроцентНаценкиПоСтроке(Элементы.РасчетНаценки.ТекущиеДанные);
	
КонецПроцедуры

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	ДатаСебестоимостиЦеныЗакупки = ТекущаяДата();
	КолвоДнейДляОценкиПотерь = 30;
	
КонецПроцедуры

Процедура ЗаполнитьПоРасчетуНаценкиНаСервере()
	
	Запрос = Новый Запрос();
	Запрос.УстановитьПараметр("ТекДата"	, КонецДня(ДатаСебестоимостиЦеныЗакупки));
	Запрос.УстановитьПараметр("Товары"	, РасчетНаценки.Выгрузить().ВыгрузитьКолонку("Номенклатура"));
	Запрос.УстановитьПараметр("Харки"	, РасчетНаценки.Выгрузить().ВыгрузитьКолонку("Характеристика"));
	Запрос.Текст =
	"ВЫБРАТЬ РАЗРЕШЕННЫЕ
	|	ЗначенияСвойствОбъектов.Объект,
	|	ВЫБОР
	|		КОГДА ВЫРАЗИТЬ(ЗначенияСвойствОбъектов.Значение КАК Справочник.Контрагенты).ГоловнойКонтрагент = ЗНАЧЕНИЕ(Справочник.Контрагенты.ПустаяСсылка)
	|			ТОГДА ЗначенияСвойствОбъектов.Значение
	|		ИНАЧЕ ВЫРАЗИТЬ(ЗначенияСвойствОбъектов.Значение КАК Справочник.Контрагенты).ГоловнойКонтрагент
	|	КОНЕЦ КАК Поставщик
	|ИЗ
	|	РегистрСведений.ЗначенияСвойствОбъектов КАК ЗначенияСвойствОбъектов
	|ГДЕ
	|	ЗначенияСвойствОбъектов.Объект В(&Харки)
	|	И ЗначенияСвойствОбъектов.Свойство = ЗНАЧЕНИЕ(ПланВидовХарактеристик.СвойстваОбъектов.Производитель)
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ЦеныПоставщиковСрезПоследних.Номенклатура,
	|	ЦеныПоставщиковСрезПоследних.Характеристика,
	|	ЦеныПоставщиковСрезПоследних.Цена,
	|	ЦеныПоставщиковСрезПоследних.Поставщик.СтавкаНДС КАК СтавкаНДС,
	|	ЦеныПоставщиковСрезПоследних.Период
	|ИЗ
	|	РегистрСведений.ЦеныПоставщиков.СрезПоследних(&ТекДата, Номенклатура В (&Товары)) КАК ЦеныПоставщиковСрезПоследних";
				   
	Результаты = Запрос.ВыполнитьПакет();
	ТабПоставщики = Результаты[0].Выгрузить();
	ТабЦеныПоставщиков = Результаты[1].Выгрузить();
	
	Для Каждого СтрокаТаб Из РасчетНаценки Цикл
		СтрокаДоб = РасчетПотерь.Добавить();
		СтрокаДоб.Номенклатура 		= СтрокаТаб.Номенклатура;
		СтрокаДоб.Характеристика 	= СтрокаТаб.Характеристика;
		СтрокаПоставщик = ТабПоставщики.Найти(СтрокаТаб.Характеристика, "Объект");
		Если СтрокаПоставщик <> Неопределено Тогда
			СтрокаДоб.Поставщик 	= СтрокаПоставщик.Поставщик;
		КонецЕсли;
		СтрокиЦена = ТабЦеныПоставщиков.НайтиСтроки(Новый Структура("Номенклатура, Характеристика", СтрокаТаб.Номенклатура, СтрокаТаб.Характеристика));
		Если СтрокиЦена.Количество() > 0 Тогда
			СтрокаДоб.ДатаЦеныЗакупки 	= СтрокиЦена[0].Период;
			СтрокаДоб.СтараяЦенаЗакупки = СтрокиЦена[0].Цена;
		КонецЕсли;
		Если ВариантРасчета = 0 Тогда
			СтрокаДоб.НоваяЦенаЗакупки = СтрокаТаб.Себестоимость;
		Иначе	
			СтрокаДоб.НоваяЦенаЗакупки = СтрокаТаб.ЗакупочнаяЦена;
		КонецЕсли;	
		СтрокаДоб.НоваяДатаЗакупки 	= ДатаСебестоимостиЦеныЗакупки;
		СтрокаДоб.Наценка 			= СтрокаТаб.ПроцентНаценки;
		СтрокаДоб.РозничнаяЦена 	= СтрокаТаб.РозничнаяЦена;
	КонецЦикла;	
	
КонецПроцедуры	

Процедура ЗаполнитьДанныеВРасчетеПотери()
	
	СтрокаОтборТовары = "9999999";
	Для Каждого СтрокаТаб Из РасчетПотерь Цикл
		СтрокаОтборТовары = СтрокаОтборТовары + ", " + Формат(СтрокаТаб.Номенклатура.id_tov, "ЧГ=0");
		СтрокаТаб.ПроцентРостаЗакупки 	= 0;
		СтрокаТаб.ПоставкаЗаNДней 		= 0;
		СтрокаТаб.ПотериПоПоставке 		= 0;
		СтрокаТаб.ПродажиЗаNДней 		= 0;
		СтрокаТаб.ПотериПоПродажам 		= 0;
		СтрокаТаб.МесяцевДоПереоценки 	= 0;
	КонецЦикла;
	
	//
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("ТекДата"		, КонецДня(ДатаСебестоимостиЦеныЗакупки));
	Запрос.УстановитьПараметр("Товары"		, РасчетНаценки.Выгрузить().ВыгрузитьКолонку("Номенклатура"));
	Запрос.УстановитьПараметр("КолвоДней"	, КолвоДнейДляОценкиПотерь);
	Запрос.Текст =
	"ВЫБРАТЬ РАЗРЕШЕННЫЕ
	|	ПриходныйОрдерСкладТовары.Номенклатура,
	|	ПриходныйОрдерСкладТовары.Характеристика,
	|	СУММА(ПриходныйОрдерСкладТовары.Количество) КАК Количество
	|ИЗ
	|	Документ.ПриходныйОрдерСклад.Товары КАК ПриходныйОрдерСкладТовары
	|ГДЕ
	|	ПриходныйОрдерСкладТовары.Ссылка.Дата МЕЖДУ ДОБАВИТЬКДАТЕ(НАЧАЛОПЕРИОДА(&ТекДата, ДЕНЬ), ДЕНЬ, &КолвоДней * (-1)) И &ТекДата
	|	И ПриходныйОрдерСкладТовары.Ссылка.Проведен = ИСТИНА
	|	И ПриходныйОрдерСкладТовары.Ссылка.ВидОперации = ЗНАЧЕНИЕ(Перечисление.ВидыОперацийПриходСкладскойУчет.ОтПоставщика)
	|	И ПриходныйОрдерСкладТовары.Номенклатура В(&Товары)
	|
	|СГРУППИРОВАТЬ ПО
	|	ПриходныйОрдерСкладТовары.Номенклатура,
	|	ПриходныйОрдерСкладТовары.Характеристика
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ТоварныйАссортиментТочекСрезПоследних.Номенклатура,
	|	ТоварныйАссортиментТочекСрезПоследних.Номенклатура.id_tov КАК id_tov,
	|	ТоварныйАссортиментТочекСрезПоследних.Характеристика,
	|	ТоварныйАссортиментТочекСрезПоследних.ТорговаяТочка.id_TT КАК id_TT
	|ИЗ
	|	РегистрСведений.ТоварныйАссортиментТочек.СрезПоследних(&ТекДата, Номенклатура В (&Товары)) КАК ТоварныйАссортиментТочекСрезПоследних
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ХарактеристикиНоменклатуры.Владелец КАК Номенклатура,
	|	ХарактеристикиНоменклатуры.id_kontr,
	|	ХарактеристикиНоменклатуры.Владелец.id_tov КАК id_tov,
	|	ХарактеристикиНоменклатуры.Ссылка КАК Характеристика
	|ИЗ
	|	Справочник.ХарактеристикиНоменклатуры КАК ХарактеристикиНоменклатуры
	|ГДЕ
	|	ХарактеристикиНоменклатуры.Владелец В(&Товары)";
				   
	Результаты = Запрос.ВыполнитьПакет();
	ТабПоставки 		= Результаты[0].Выгрузить();
	ТабКешАссортимент 	= Результаты[1].Выгрузить();
	ТабКешХарки 		= Результаты[2].Выгрузить();
	
	ADOСоединение = ВнешниеДанные.ПолучитьADOСоединение();
	
	ТекстЗапроса =
	"SELECT
	|	SUM(VZ_Full.Quantity) as Qnt,
	|	SUM(VZ_Full.Summ) as Summ,
	|	VZ_Full.id_tov,
	|	VZ_Full.id_kontr,
	|	VZ_Full.id_tt
	|FROM (
	|	SELECT
	|		Ch.Quantity as Quantity,
	|		Ch.id_kontr as id_kontr
	|	 	,Ch.id_tov_cl as id_tov
	|	 	,Ch.id_tt_cl as id_tt
	|		,Ch.BaseSum as Summ
	|
	| FROM [SMS_UNION].[dbo].[CheckLine] (nolock) as Ch
	| where Ch.date_ch >= " + ВнешниеДанные.ФорматПоля(ДатаСебестоимостиЦеныЗакупки - КолвоДнейДляОценкиПотерь * 86400, Истина) + " and Ch.date_ch <= " + ВнешниеДанные.ФорматПоля(ДатаСебестоимостиЦеныЗакупки, Истина) + " and Ch.OperationType_cl IN (1, 3)
	|		and Ch.id_tov_cl IN (" + СтрокаОтборТовары + ")
	|
	| UNION ALL
	| 
	| --архив по вкусвилл
	| SELECT
	|	Ch.Quantity as Quantity,
	|	Ch.id_kontr as id_kontr
	|	 ,Ch.id_tov_cl as id_tov
	|	 ,Ch.id_tt_cl
	|	,Ch.BaseSum as Summ
	|
	| FROM [SMS_IZBENKA_ARC].[dbo].[su_Checkline] (nolock) as Ch
	| where Ch.date_ch >= " + ВнешниеДанные.ФорматПоля(ДатаСебестоимостиЦеныЗакупки - КолвоДнейДляОценкиПотерь * 86400, Истина) + " and Ch.date_ch <= " + ВнешниеДанные.ФорматПоля(ДатаСебестоимостиЦеныЗакупки, Истина) + " and Ch.OperationType_cl IN (1, 3)
	|		and Ch.id_tov_cl IN (" + СтрокаОтборТовары + ")
	|
	| UNION ALL
	| --избенка
	| SELECT
	|	Ch.Quantity as Quantity,
	|	Ch.ManufacturerID as id_kontr
	|	 ,Ch.id_tov_cl as id_tov
	|	 ,Ch.id_tt_cl
	|	,Ch.BaseSum as Summ
	|
	| FROM [SMS_IZBENKA].[dbo].[CheckLine] (nolock) as Ch
	| where Ch.date_ch >= " + ВнешниеДанные.ФорматПоля(ДатаСебестоимостиЦеныЗакупки - КолвоДнейДляОценкиПотерь * 86400, Истина) + " and Ch.date_ch <= " + ВнешниеДанные.ФорматПоля(ДатаСебестоимостиЦеныЗакупки, Истина) + " and Ch.OperationType_cl IN (1, 3)
	|		and Ch.id_tov_cl IN (" + СтрокаОтборТовары + ")
	|
	| UNION ALL
	| --архив избенка
	| SELECT Ch.Quantity as Quantity, Ch.ManufacturerID as id_kontr
	|	 ,Ch.id_tov_cl as id_tov
	|	 ,Ch.id_tt_cl
	|	,Ch.BaseSum as Summ
	|
	| FROM [SMS_IZBENKA_ARC].[dbo].[CheckLine] (nolock) as Ch
	| where Ch.date_ch >= " + ВнешниеДанные.ФорматПоля(ДатаСебестоимостиЦеныЗакупки - КолвоДнейДляОценкиПотерь * 86400, Истина) + " and Ch.date_ch <= " + ВнешниеДанные.ФорматПоля(ДатаСебестоимостиЦеныЗакупки, Истина) + " and Ch.OperationType_cl IN (1, 3)
	|		and Ch.id_tov_cl IN (" + СтрокаОтборТовары + ")
	|
	|   
	|   ) as VZ_Full
	|GROUP BY
	|	VZ_Full.id_tov,
	|	VZ_Full.id_kontr,
	|	VZ_Full.id_tt";
		
	rs = ADOСоединение.Execute(ТекстЗапроса);
	Пока rs <> Неопределено
			И rs.Fields.Count <= 0 Цикл
		rs = rs.NextRecordSet();
	КонецЦикла;
	
	Попытка
		rs.MoveFirst();
		
		Пока НЕ rs.EOF() Цикл
			id_kontr 	= Rs.Fields("id_kontr").Value;
			id_tov 		= Rs.Fields("id_tov").Value;
			id_tt 		= Rs.Fields("id_tt").Value;
			
			Если id_kontr = 0 Тогда
				СтрокиКеш = ТабКешАссортимент.НайтиСтроки(Новый Структура("id_tov, id_tt", id_tov, id_tt));
				Если СтрокиКеш.Количество() > 0 Тогда
					СтрокиПотерь = РасчетПотерь.НайтиСтроки(Новый Структура("Номенклатура, Характеристика", СтрокиКеш[0].Номенклатура, СтрокиКеш[0].Характеристика));
					Если СтрокиПотерь.Количество() > 0 Тогда
						СтрокиПотерь[0].ПродажиЗаNДней = СтрокиПотерь[0].ПродажиЗаNДней + Rs.Fields("Qnt").Value;
						СтрокиПотерь[0].СуммаПродаж = СтрокиПотерь[0].СуммаПродаж + Rs.Fields("Summ").Value;
					КонецЕсли;	
				КонецЕсли;
			Иначе
				СтрокиКеш = ТабКешХарки.НайтиСтроки(Новый Структура("id_tov, id_kontr", id_tov, id_kontr));
				Если СтрокиКеш.Количество() > 0 Тогда
					СтрокиПотерь = РасчетПотерь.НайтиСтроки(Новый Структура("Номенклатура, Характеристика", СтрокиКеш[0].Номенклатура, СтрокиКеш[0].Характеристика));
					Если СтрокиПотерь.Количество() > 0 Тогда
						СтрокиПотерь[0].ПродажиЗаNДней = СтрокиПотерь[0].ПродажиЗаNДней + Rs.Fields("Qnt").Value;
						СтрокиПотерь[0].СуммаПродаж = СтрокиПотерь[0].СуммаПродаж + Rs.Fields("Summ").Value;
					КонецЕсли;	
				КонецЕсли;
			КонецЕсли;	
			
			rs.MoveNext();
		КонецЦикла;
	Исключение
	КонецПопытки;
	
	ТекстЗапроса =
	"SELECT
	|	ls.id_tt_ls as id_tt
	|	,ls.id_tov_ls as id_tov
	|	,ls.id_kontr_ls as id_kontr
	|	,SUM(ls.lost1) as Qnt
	|	,SUM(ls.lost1 * isnull(ls.Price_ls, 0)) as Summ
	|	
	|FROM [M2].[dbo].[lost_sales] as ls
	|WHERE
	|	ls.date_ls >= " + ВнешниеДанные.ФорматПоля(ДатаСебестоимостиЦеныЗакупки - КолвоДнейДляОценкиПотерь * 86400, Истина) + "
	|	and ls.date_ls <= " + ВнешниеДанные.ФорматПоля(ДатаСебестоимостиЦеныЗакупки, Истина) + "
	|
	|GROUP BY
	|	ls.id_tt_ls
	|	,ls.id_tov_ls
	|	,ls.id_kontr_ls
	|	
	| HAVING SUM(ls.lost1) > 0";
				  
	rs = ADOСоединение.Execute(ТекстЗапроса);
	Пока rs <> Неопределено
			И rs.Fields.Count <= 0 Цикл
		rs = rs.NextRecordSet();
	КонецЦикла;
	
	Попытка
		rs.MoveFirst();
		
		Пока НЕ rs.EOF() Цикл
			id_kontr 	= Rs.Fields("id_kontr").Value;
			id_tov 		= Rs.Fields("id_tov").Value;
			id_tt 		= Rs.Fields("id_tt").Value;
			
			Если id_kontr = 0 Тогда
				СтрокиКеш = ТабКешАссортимент.НайтиСтроки(Новый Структура("id_tov, id_tt", id_tov, id_tt));
				Если СтрокиКеш.Количество() > 0 Тогда
					СтрокиПотерь = РасчетПотерь.НайтиСтроки(Новый Структура("Номенклатура, Характеристика", СтрокиКеш[0].Номенклатура, СтрокиКеш[0].Характеристика));
					Если СтрокиПотерь.Количество() > 0 Тогда
						СтрокиПотерь[0].ПродажиЗаNДней = СтрокиПотерь[0].ПродажиЗаNДней + Rs.Fields("Qnt").Value;
						СтрокиПотерь[0].СуммаПродаж = СтрокиПотерь[0].СуммаПродаж + Rs.Fields("Summ").Value;
					КонецЕсли;	
				КонецЕсли;
			Иначе
				СтрокиКеш = ТабКешХарки.НайтиСтроки(Новый Структура("id_tov, id_kontr", id_tov, id_kontr));
				Если СтрокиКеш.Количество() > 0 Тогда
					СтрокиПотерь = РасчетПотерь.НайтиСтроки(Новый Структура("Номенклатура, Характеристика", СтрокиКеш[0].Номенклатура, СтрокиКеш[0].Характеристика));
					Если СтрокиПотерь.Количество() > 0 Тогда
						СтрокиПотерь[0].ПродажиЗаNДней = СтрокиПотерь[0].ПродажиЗаNДней + Rs.Fields("Qnt").Value;
						СтрокиПотерь[0].СуммаПродаж = СтрокиПотерь[0].СуммаПродаж + Rs.Fields("Summ").Value;
					КонецЕсли;	
				КонецЕсли;
			КонецЕсли;	
			
			rs.MoveNext();
		КонецЦикла;
	Исключение
	КонецПопытки;
		
	Для Каждого СтрокаТаб Из РасчетПотерь Цикл
		СтрокаТаб.ПроцентРостаЗакупки = ?(СтрокаТаб.СтараяЦенаЗакупки = 0, 0, (СтрокаТаб.НоваяЦенаЗакупки / СтрокаТаб.СтараяЦенаЗакупки - 1) * 100);
		СтрокиПоставки = ТабПоставки.НайтиСтроки(Новый Структура("Номенклатура, Характеристика", СтрокаТаб.Номенклатура, СтрокаТаб.Характеристика));
		Если СтрокиПоставки.Количество() > 0 Тогда
			СтрокаТаб.ПоставкаЗаNДней = СтрокиПоставки[0].Количество;
		КонецЕсли;
		СтрокаТаб.ПотериПоПоставке 		= СтрокаТаб.ПоставкаЗаNДней * (СтрокаТаб.НоваяЦенаЗакупки - СтрокаТаб.СтараяЦенаЗакупки);
		СтрокаТаб.ПотериПоПродажам 		= СтрокаТаб.ПродажиЗаNДней 	* (СтрокаТаб.НоваяЦенаЗакупки - СтрокаТаб.СтараяЦенаЗакупки);
		СтрокаТаб.МесяцевДоПереоценки 	= (СтрокаТаб.НоваяДатаЗакупки - СтрокаТаб.ДатаЦеныЗакупки) / (86400*30);
	КонецЦикла;	
	
КонецПроцедуры	

&НаКлиенте
Процедура ЗаполнитьПоРасчетуНаценки(Команда)
	
	РасчетПотерь.Очистить();
	ЗаполнитьПоРасчетуНаценкиНаСервере();
	
КонецПроцедуры

&НаКлиенте
Процедура ПересчитатьПотери(Команда)
	
	ЗаполнитьДанныеВРасчетеПотери();
	
КонецПроцедуры

&НаСервереБезКонтекста
Функция ПолучитьПоставщика(Характеристика)
	
	Возврат Справочники.Контрагенты.НайтиПоРеквизиту("ИД", Характеристика.id_kontr);
	
КонецФункции	

&НаКлиенте
Процедура ОткрытьФормуОтчета()
	
	ФормаОтчета = ПолучитьФорму("Отчет.СебестоимостьПоПартиям.Форма.ФормаОтчета");
	
	Для Каждого ПользПоле Из ФормаОтчета.Отчет.КомпоновщикНастроек.ПользовательскиеНастройки.Элементы Цикл
		Если ТипЗнч(ПользПоле) = Тип("ЗначениеПараметраНастроекКомпоновкиДанных")
			И Строка(ПользПоле.Параметр) = "Период" Тогда
			ПользПоле.Значение = Новый СтандартныйПериод(ДатаСебестоимостиЦеныЗакупки - 86400*КолвоДнейДляОценкиПотерь, ДатаСебестоимостиЦеныЗакупки);
		КонецЕсли;
	КонецЦикла;
	
	Для Каждого ЭлементОтбора Из ФормаОтчета.Отчет.КомпоновщикНастроек.Настройки.Отбор.Элементы Цикл
		Если ЭлементОтбора.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("Товар") Тогда
			ЭлементОтбораПН = ФормаОтчета.Отчет.КомпоновщикНастроек.ПользовательскиеНастройки.Элементы.Найти(ЭлементОтбора.ИдентификаторПользовательскойНастройки);
			ЭлементОтбораПН.ПравоеЗначение = Элементы.РасчетНаценки.ТекущиеДанные.Номенклатура;
			ЭлементОтбораПН.Использование = Истина;
		КонецЕсли;
		Если ЭлементОтбора.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("Поставщик") Тогда
			ЭлементОтбораПН = ФормаОтчета.Отчет.КомпоновщикНастроек.ПользовательскиеНастройки.Элементы.Найти(ЭлементОтбора.ИдентификаторПользовательскойНастройки);
			ЭлементОтбораПН.ПравоеЗначение = ПолучитьПоставщика(Элементы.РасчетНаценки.ТекущиеДанные.Характеристика);
			ЭлементОтбораПН.Использование = Истина;
		КонецЕсли;
	КонецЦикла;
	
	ФормаОтчета.Открыть();
	//ФормаОтчета.Отчет.СкомпоноватьРезультат(ФормаОтчета.Элементы.Результат);
	
КонецПроцедуры	

&НаКлиенте
Процедура РасчетНаценкиСуммаПоставокОткрытие(Элемент, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	ОткрытьФормуОтчета();
	
КонецПроцедуры

&НаКлиенте
Процедура РасчетНаценкиСуммаДоставкаОткрытие(Элемент, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	ОткрытьФормуОтчета();
	
КонецПроцедуры

&НаКлиенте
Процедура РасчетНаценкиСуммаУпаковкаОткрытие(Элемент, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	ОткрытьФормуОтчета();
	
КонецПроцедуры

&НаКлиенте
Процедура РасчетНаценкиКоличествоВПоставкахОткрытие(Элемент, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	ОткрытьФормуОтчета();
	
КонецПроцедуры
