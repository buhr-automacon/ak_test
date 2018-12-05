﻿//+++АК LAGP 2018.06.27 ИП-00018465.04 Создание объекта. 
//Документ предназначен для "гашения" регистра накопления "Расчёты с контрагентами" по измерению "Сделка" со значениями документов ВозвратОтПокупателя, ПоступлениеВБанк, РеализацияТоваровИУслуг. 

Функция ПолучитьОстатокПлатёжногоДокумента(Документ, ДатаОстатка, РаспределениеПлатежей) Экспорт
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ
		|	РасчетыСКонтрагентамиОстатки.Сделка,
		|	РасчетыСКонтрагентамиОстатки.СуммаОстаток
		|ИЗ
		|	РегистрНакопления.РасчетыСКонтрагентами.Остатки(&ДатаОстатка, Сделка = &Сделка) КАК РасчетыСКонтрагентамиОстатки";
	
	Запрос.УстановитьПараметр("ДатаОстатка", ДатаОстатка.Значение.Дата + 3);
	Запрос.УстановитьПараметр("Сделка", Документ);
		
	РезультатЗапроса = Запрос.Выполнить();
	
	СуммаДвиженийТекущегоДокументаВРегистре = 0;
	Если РаспределениеПлатежей.Проведен Тогда
		ЗапросСуммыДвиженийТекущегоДокумента = Новый Запрос;
		ЗапросСуммыДвиженийТекущегоДокумента.Текст = 
			"ВЫБРАТЬ
			|	РасчетыСКонтрагентамиОбороты.СуммаОборот
			|ИЗ
			|	РегистрНакопления.РасчетыСКонтрагентами.Обороты(&НачалоПериода, &КонецПериода, Регистратор, Сделка = &Сделка) КАК РасчетыСКонтрагентамиОбороты
			|ГДЕ
			|	РасчетыСКонтрагентамиОбороты.Регистратор = &Регистратор";
		
		ЗапросСуммыДвиженийТекущегоДокумента.УстановитьПараметр("НачалоПериода", ДатаОстатка.Значение.Дата - 3);
		ЗапросСуммыДвиженийТекущегоДокумента.УстановитьПараметр("КонецПериода", ДатаОстатка.Значение.Дата);
		ЗапросСуммыДвиженийТекущегоДокумента.УстановитьПараметр("Сделка", Документ);
		ЗапросСуммыДвиженийТекущегоДокумента.УстановитьПараметр("Регистратор", РаспределениеПлатежей);
		
		РезультатЗапросаСуммыДвиженийТекущегоДокумента = ЗапросСуммыДвиженийТекущегоДокумента.Выполнить();
		Если НЕ РезультатЗапросаСуммыДвиженийТекущегоДокумента.Пустой() Тогда
			ВыборкаДетальныеЗаписиДвиженийТекущего = РезультатЗапросаСуммыДвиженийТекущегоДокумента.Выбрать();
			ВыборкаДетальныеЗаписиДвиженийТекущего.Следующий();
			СуммаДвиженийТекущегоДокументаВРегистре = ВыборкаДетальныеЗаписиДвиженийТекущего.СуммаОборот;	
		КонецЕсли;	
	КонецЕсли;	
	
	Если РезультатЗапроса.Пустой() Тогда
		Возврат СуммаДвиженийТекущегоДокументаВРегистре;
	Иначе
		ВыборкаДетальныеЗаписи = РезультатЗапроса.Выбрать();
		ВыборкаДетальныеЗаписи.Следующий();
		Возврат -ВыборкаДетальныеЗаписи.СуммаОстаток - СуммаДвиженийТекущегоДокументаВРегистре;
	КонецЕсли;	
		
КонецФункции	