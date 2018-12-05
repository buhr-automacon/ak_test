﻿
Перем ТекДата;


Функция ПолучитьТаблицуИзмененийВДвижениях()
	
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("Регистратор"	, ЭтотОбъект.Ссылка);
	Запрос.УстановитьПараметр("Товары"		, ЭтотОбъект.Товары.Выгрузить());
	
	Запрос.Текст =
	"ВЫБРАТЬ
	|	ЗаданияНаПеремещение.Номенклатура,
	|	ЗаданияНаПеремещение.Характеристика,
	|	ЗаданияНаПеремещение.ДатаПроизводства,
	|	СУММА(ЗаданияНаПеремещение.Количество * ВЫБОР
	|			КОГДА ЗаданияНаПеремещение.ВидДвижения = ЗНАЧЕНИЕ(ВидДвиженияНакопления.Приход)
	|				ТОГДА 1
	|			ИНАЧЕ -1
	|		КОНЕЦ) КАК Количество
	|ПОМЕСТИТЬ ВТ_Движения
	|ИЗ
	|	РегистрНакопления.ЗаданияНаПеремещение КАК ЗаданияНаПеремещение
	|ГДЕ
	|	ЗаданияНаПеремещение.Регистратор = &Регистратор
	|	И ЗаданияНаПеремещение.Активность = ИСТИНА
	|	И ЗаданияНаПеремещение.ВидДвижения = ЗНАЧЕНИЕ(ВидДвиженияНакопления.Приход)
	|
	|СГРУППИРОВАТЬ ПО
	|	ЗаданияНаПеремещение.Номенклатура,
	|	ЗаданияНаПеремещение.Характеристика,
	|	ЗаданияНаПеремещение.ДатаПроизводства
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ТЧТовары.Номенклатура,
	|	ТЧТовары.Характеристика,
	|	ТЧТовары.ДатаПроизводства,
	|	ТЧТовары.Количество КАК Количество
	|ПОМЕСТИТЬ ВТ_ТабТовары
	|ИЗ
	|	&Товары КАК ТЧТовары
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ЕСТЬNULL(ВТ_Движения.Номенклатура, ВЗ_Товары.Номенклатура) КАК Номенклатура,
	|	ЕСТЬNULL(ВТ_Движения.Характеристика, ВЗ_Товары.Характеристика) КАК Характеристика,
	|	ЕСТЬNULL(ВТ_Движения.ДатаПроизводства, ВЗ_Товары.ДатаПроизводства) КАК ДатаПроизводства,
	|	ЕСТЬNULL(ВЗ_Товары.Количество, 0) - ЕСТЬNULL(ВТ_Движения.Количество, 0) КАК Количество
	|ИЗ
	|	ВТ_Движения КАК ВТ_Движения
	|		ПОЛНОЕ СОЕДИНЕНИЕ (ВЫБРАТЬ
	|			ВТ_ТабТовары.Номенклатура КАК Номенклатура,
	|			ВТ_ТабТовары.Характеристика КАК Характеристика,
	|			ВТ_ТабТовары.ДатаПроизводства КАК ДатаПроизводства,
	|			СУММА(ВТ_ТабТовары.Количество) КАК Количество
	|		ИЗ
	|			ВТ_ТабТовары КАК ВТ_ТабТовары
	|		
	|		СГРУППИРОВАТЬ ПО
	|			ВТ_ТабТовары.Номенклатура,
	|			ВТ_ТабТовары.Характеристика,
	|			ВТ_ТабТовары.ДатаПроизводства) КАК ВЗ_Товары
	|		ПО ВТ_Движения.Номенклатура = ВЗ_Товары.Номенклатура
	|			И ВТ_Движения.Характеристика = ВЗ_Товары.Характеристика
	|			И ВТ_Движения.ДатаПроизводства = ВЗ_Товары.ДатаПроизводства
	|ГДЕ
	|	ЕСТЬNULL(ВЗ_Товары.Количество, 0) - ЕСТЬNULL(ВТ_Движения.Количество, 0) <> 0";
				   
	Возврат Запрос.Выполнить().Выгрузить();
	
КонецФункции


Процедура ПередЗаписью(Отказ, РежимЗаписи, РежимПроведения)
	
	Если Отказ Тогда
		Возврат;
	КонецЕсли;	
	
	Если РежимЗаписи = РежимЗаписиДокумента.Проведение Тогда
		
		ТекДата = ТекущаяДата(); //можно брать эту, т.к. код выполняется на сервере и дата будет серверная
		ТабИзмененийВДвижениях = ПолучитьТаблицуИзмененийВДвижениях();
		Если ТабИзмененийВДвижениях.Количество() > 0 Тогда
			СтрокаТаб = ЭтотОбъект.ИзмененияДвижений.Добавить();
			СтрокаТаб.ДатаИзменения = ТекДата;
			СтрокаТаб.Пользователь 	= ПараметрыСеанса.ТекущийПользователь;
		КонецЕсли;
					
	ИначеЕсли РежимЗаписи = РежимЗаписиДокумента.ОтменаПроведения Тогда
		
		ЭтотОбъект.ИзмененияДвижений.Очистить();
		
	КонецЕсли;
	
КонецПроцедуры

Процедура ОбработкаПроведения(Отказ, РежимПроведения)
	
	мДвижения = ЭтотОбъект.Движения.ЗаданияНаПеремещение;
	мДвижения.Записывать = Истина;
	мДвижения.Очистить();
	
	ТекПользователь = ПараметрыСеанса.ТекущийПользователь;
	Для Каждого СтрокаТЧ Из ЭтотОбъект.Товары Цикл
		Движение = мДвижения.ДобавитьПриход();
		Движение.Период 			= ТекДата;
		Движение.Задание			= ЭтотОбъект.Ссылка;
		Движение.Номенклатура 		= СтрокаТЧ.Номенклатура;
		Движение.Характеристика 	= СтрокаТЧ.Характеристика;
		Движение.ДатаПроизводства 	= СтрокаТЧ.ДатаПроизводства;
		Движение.Количество 		= СтрокаТЧ.Количество;
		Движение.АвторИзменений		= ТекПользователь;
	КонецЦикла;
	
	Если ЭтотОбъект.Закрыто Тогда //Надо остатки по заданию в регистре закрыть
		мДвижения.Записать();
		Запрос = Новый Запрос;
		Запрос.УстановитьПараметр("ТекущийДокумент", ЭтотОбъект.Ссылка);
		Запрос.Текст =
		"ВЫБРАТЬ
		|	ЗаданияНаПеремещениеОстатки.Задание,
		|	ЗаданияНаПеремещениеОстатки.Номенклатура,
		|	ЗаданияНаПеремещениеОстатки.Характеристика,
		|	ЗаданияНаПеремещениеОстатки.ДатаПроизводства,
		|	ЗаданияНаПеремещениеОстатки.КоличествоОстаток КАК Количество
		|ИЗ
		|	РегистрНакопления.ЗаданияНаПеремещение.Остатки(, Задание = &ТекущийДокумент) КАК ЗаданияНаПеремещениеОстатки";
		Выборка = Запрос.Выполнить().Выбрать();
		Пока Выборка.Следующий() Цикл
			Движение = мДвижения.ДобавитьРасход();
			Движение.Период 		= ТекДата;
			ЗаполнитьЗначенияСвойств(Движение, Выборка);
			Движение.АвторИзменений	= ТекПользователь;
		КонецЦикла;	
	КонецЕсли;
	
КонецПроцедуры

