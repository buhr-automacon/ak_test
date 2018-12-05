﻿Перем ТабИзмененийВДвижениях;
Перем ТекДата;

#Область ОбработчикиСобытий

Процедура ПриКопировании(ОбъектКопирования)
	
	ЭтотОбъект.ЗаданияНаПеремещение.Очистить();
	ЭтотОбъект.ЗаданияНаФасовку.Очистить();
	ЭтотОбъект.Товары.Очистить();
	ЭтоСборкаВЗоныОтгрузки = Ложь;
	ВРаботе = Ложь;
	
	ДатаРаспределения = '00010101';
	
	СборкаБылаПрерванаНаМобУстройстве = Ложь;
	ДанныеСборкиНаМобильномУстройстве = Новый ХранилищеЗначения(Неопределено);
	СборкаТерминаломЗакончена = Ложь;
	
	СтатусДокумента = Перечисления.СтатусыПеремещенияСклад.НеОбработан;
	
КонецПроцедуры

Процедура ОбработкаЗаполнения(ДанныеЗаполнения, СтандартнаяОбработка)
	
	Если ТипЗнч(ДанныеЗаполнения) = Тип("ДокументСсылка.ЗаданиеНаФасовку") Тогда
		
		ЭтотОбъект.СкладОтправитель = ДанныеЗаполнения.СкладОтправитель;
		ЭтотОбъект.СкладПолучатель 	= ДанныеЗаполнения.СкладПолучатель;
		
		НоваяСтрока = ЭтотОбъект.ЗаданияНаФасовку.Добавить();
		НоваяСтрока.ЗаданиеНаФасовку = ДанныеЗаполнения;
		
	    //
		Запрос = Новый Запрос;
		Запрос.Текст = Документы.ПеремещениеСклад.ПолучитьТекстЗапросаПоТоварамЗаданийНаФасовку();				   
		Запрос.УстановитьПараметр("ДатаПроизводства", НачалоДня(ТекущаяДата()));
		Запрос.УстановитьПараметр("ЗаданияНаФасовку", ЭтотОбъект.ЗаданияНаФасовку.Выгрузить().ВыгрузитьКолонку("ЗаданиеНаФасовку"));
		
		ЭтотОбъект.Товары.Загрузить(Запрос.Выполнить().Выгрузить());
	
	ИначеЕсли ТипЗнч(ДанныеЗаполнения) = Тип("ДокументСсылка.ЗаданиеНаПеремещение") Тогда
		
		ЭтотОбъект.СкладОтправитель = ДанныеЗаполнения.СкладОтправитель;
		ЭтотОбъект.СкладПолучатель 	= ДанныеЗаполнения.СкладПолучатель;
		
		НоваяСтрока = ЭтотОбъект.ЗаданияНаПеремещение.Добавить();
		НоваяСтрока.ЗаданиеНаПеремещение = ДанныеЗаполнения;
		
	    //
		Запрос = Новый Запрос;
		Запрос.Текст = Документы.ПеремещениеСклад.ПолучитьТекстЗапросаПоТоварамЗаданийНаПеремещение();				   
		//Запрос.УстановитьПараметр("ДатаПроизводства"	, НачалоДня(ТекущаяДата()));
		Запрос.УстановитьПараметр("ЗаданияНаПеремещение", ЭтотОбъект.ЗаданияНаПеремещение.Выгрузить().ВыгрузитьКолонку("ЗаданиеНаПеремещение"));
		
		ЭтотОбъект.Товары.Загрузить(Запрос.Выполнить().Выгрузить());
		
	ИначеЕсли ТипЗнч(ДанныеЗаполнения) = Тип("ДокументСсылка.ПеремещениеСклад") Тогда
		
		ЭтотОбъект.СкладОтправитель = ДанныеЗаполнения.СкладОтправитель;
		ЭтотОбъект.СкладПолучатель 	= ДанныеЗаполнения.СкладПолучатель;
		
	//+++АК SHEP 20170123
	ИначеЕсли ТипЗнч(ДанныеЗаполнения) = Тип("ДокументСсылка.МП_ЗадачаТехнолога") И ЗначениеЗаполнено(ДанныеЗаполнения.СкладСклада)  Тогда
		
		УстановитьПривилегированныйРежим(Истина);
		Основание			= ДанныеЗаполнения;
		СкладОтправитель	= ДанныеЗаполнения.СкладСклада;
		СкладПолучатель		= РегистрыСведений.СоответствиеТиповЗаданийТехнологаМагазинамИСкладов.ВернутьСкладПеремещения(ДанныеЗаполнения.ТипЗадания);
		СтатусДокумента		= Перечисления.СтатусыПеремещенияСклад.Выполнен;
		ПровереноОператором	= Истина;
		Автор				= глЗначениеПеременной("глТекущийПользователь");
		Комментарий 		= "#создан автоматически к " + Строка(ДанныеЗаполнения);
		
		ЭтотОбъект.Товары.Очистить();
		ТабТовары = ДанныеЗаполнения.ПараметрыЗадачи;
		Для Каждого СтрокаТаб Из ТабТовары Цикл
			Если СтрокаТаб.Количество <> 0 Тогда
				СтрокаДоб = ЭтотОбъект.Товары.Добавить();
				СтрокаДоб.Номенклатура			= СтрокаТаб.Номенклатура;
				СтрокаДоб.Характеристика		= ?(СтрокаТаб.Номенклатура.НеВедетсяУчетПоХарактеристикам, Справочники.ХарактеристикиНоменклатуры.ПустаяСсылка(), СтрокаТаб.ХарактеристикаНоменклатуры);
				СтрокаДоб.ЕдиницаИзмерения		= СтрокаТаб.ЕдиницаИзмерения;
				СтрокаДоб.КоличествоОтправитель	= СтрокаТаб.Количество;
				СтрокаДоб.КоличествоПолучатель	= СтрокаТаб.Количество;
				СтрокаДоб.ДатаПроизводства		= СтрокаТаб.ДатаПроизводства;
			КонецЕсли;
		КонецЦикла;
		УстановитьПривилегированныйРежим(Ложь);
		
	//---АК SHEP 20170123
		
	КонецЕсли;
	
	СтатусДокумента = Перечисления.СтатусыПеремещенияСклад.НеОбработан;
	
КонецПроцедуры

//+++АК LATV 2018.07.23 ИП-00018525
Процедура ПередЗаписью(Отказ, РежимЗаписи, РежимПроведения)

	Если НЕ ЗначениеЗаполнено(ЭтотОбъект.СтатусДокумента) Тогда
		ЭтотОбъект.СтатусДокумента = Перечисления.СтатусыПеремещенияСклад.НеОбработан;
	КонецЕсли;
	
	Для Каждого СтрокаТовар Из ЭтотОбъект.Товары Цикл
		СтрокаТовар.КоличествоПолучатель = СтрокаТовар.КоличествоОтправитель;
		
		Если Не ЭтоВозвратПоставщику Тогда
			СтрокаТовар.ВидДефекта = Неопределено;
		КонецЕсли;
	КонецЦикла;
	
	ТабИзмененийВДвижениях = ПолучитьТаблицуИзмененийВДвижениях();
	ТекДата= ТекущаяДата();
	Если ТабИзмененийВДвижениях.Количество() > 0 Тогда
		СтрокаТаб = ИзмененияДвижений.Добавить();
		СтрокаТаб.ДатаИзменения = ТекДата;
		СтрокаТаб.Пользователь = ПараметрыСеанса.ТекущийПользователь;
	КонецЕсли;

КонецПроцедуры

Процедура ОбработкаПроведения(Отказ, РежимПроведения)
	
	Если НЕ ПроверитьОстатки() Тогда
		//Отказ = Истина;
		//Возврат;
	КонецЕсли;

	// ++ АК Зайцева А. 14582
	Если ЗначениеЗаполнено(ЭтотОбъект.СкладОтправитель) И ЭтотОбъект.СкладОтправитель.ЗаблокироватьДвижениеПоСкладу И ЭтотОбъект.СкладОтправитель.ДатаБлокировкиДвижений <= НачалоДня(ТекущаяДата()) Тогда
		Сообщить("Движения по складу " + ЭтотОбъект.СкладОтправитель.Наименование + " заблокированы! Проведение невозможно.");
		Отказ = Истина;
	ИначеЕсли ЗначениеЗаполнено(ЭтотОбъект.СкладПолучатель) И ЭтотОбъект.СкладПолучатель.ЗаблокироватьДвижениеПоСкладу И ЭтотОбъект.СкладПолучатель.ДатаБлокировкиДвижений <= НачалоДня(ТекущаяДата()) Тогда
		Сообщить("Движения по складу " + ЭтотОбъект.СкладПолучатель.Наименование + " заблокированы! Проведение невозможно.");
		Отказ = Истина;
	КонецЕсли;
	//--
	
	ДвиженияТоварыНаСкладах = ЭтотОбъект.Движения.ТоварыНаСкладах;
	ДвиженияТоварыНаСкладах.Записывать = Истина;
	ДвиженияТоварыНаСкладах.Очистить();
	
	ДвиженияЗаданияНаПеремещение = ЭтотОбъект.Движения.ЗаданияНаПеремещение;
	ДвиженияЗаданияНаПеремещение.Записывать = Истина;
	ДвиженияЗаданияНаПеремещение.Очистить();
	
	ДвиженияЗаданияНаФасовку = ЭтотОбъект.Движения.ЗаданияНаФасовку;
	ДвиженияЗаданияНаФасовку.Записывать = Истина;
	ДвиженияЗаданияНаФасовку.Очистить();
	
	ВыполнятьДвижения = Истина;
	Если ЭтоСборкаВЗоныОтгрузки
			И (СтатусДокумента = Перечисления.СтатусыПеремещенияСклад.НеОбработан
				ИЛИ СтатусДокумента = Перечисления.СтатусыПеремещенияСклад.ВРаботе
				ИЛИ СтатусДокумента = Перечисления.СтатусыПеремещенияСклад.Отменен) Тогда
		ВыполнятьДвижения = Ложь;
	КонецЕсли;
	
	Если ВыполнятьДвижения Тогда
		
		//+++АК SHEP 20170124: разрешаем сторнирующие движения для задачи технолога
		ЭтоЗадачаТехнолога = (ЗначениеЗаполнено(Основание) И ТипЗнч(Основание) = Тип("ДокументСсылка.МП_ЗадачаТехнолога"));
		//---АК SHEP 20170124
		
		ТекПользователь = ПараметрыСеанса.ТекущийПользователь;
		Для Каждого СтрокаТЧ Из ЭтотОбъект.Товары Цикл
			Если СтрокаТЧ.КоличествоОтправитель > 0 ИЛИ ЭтоЗадачаТехнолога Тогда
				
				////Если НЕ ЭтоСборкаВЗоныОтгрузки
				////	ИЛИ (ЭтоСборкаВЗоныОтгрузки И ВРаботе) Тогда
				//	Движение = ДвиженияТоварыНаСкладах.Добавить();
				//	Движение.ВидДвижения 		= ВидДвиженияНакопления.Расход;
				//	Движение.Период 			= ЭтотОбъект.Дата;
				//	Движение.Склад 				= ЭтотОбъект.СкладОтправитель;
				//	Движение.Номенклатура 		= СтрокаТЧ.Номенклатура;
				//	Движение.ЕдиницаИзмерения 	= СтрокаТЧ.ЕдиницаИзмерения;
				//	Движение.Характеристика 	= СтрокаТЧ.Характеристика;
				//	Движение.ДатаПроизводства 	= СтрокаТЧ.ДатаПроизводства;
				//	Движение.Количество 		= СтрокаТЧ.КоличествоОтправитель;
				//	Движение.АвторИзменений 	= ТекПользователь;
				////КонецЕсли;	
				
				Если НЕ СтрокаТЧ.ЗаданиеНаПеремещение.Пустая() Тогда
					Движение = ДвиженияЗаданияНаПеремещение.ДобавитьРасход();
					Движение.Период 			= ЭтотОбъект.Дата;
					Движение.Задание			= СтрокаТЧ.ЗаданиеНаПеремещение;
					Движение.Номенклатура 		= СтрокаТЧ.Номенклатура;
					Движение.Характеристика 	= СтрокаТЧ.Характеристика;
					Движение.ДатаПроизводства 	= СтрокаТЧ.ДатаПроизводства;
					Движение.Количество 		= СтрокаТЧ.КоличествоОтправитель;
					Движение.АвторИзменений		= ТекПользователь;
				КонецЕсли;
				Если НЕ СтрокаТЧ.ЗаданиеНаФасовку.Пустая() Тогда
					Движение = ДвиженияЗаданияНаФасовку.ДобавитьРасход();
					Движение.Период 			= ЭтотОбъект.Дата;
					Движение.Задание			= СтрокаТЧ.ЗаданиеНаФасовку;
					Движение.Номенклатура 		= СтрокаТЧ.Номенклатура;
					Движение.Характеристика 	= СтрокаТЧ.Характеристика;
					Движение.ДатаПроизводства 	= СтрокаТЧ.ДатаПроизводства;
					Движение.Количество 		= СтрокаТЧ.КоличествоОтправитель;
					Движение.АвторИзменений		= ТекПользователь;
				КонецЕсли;
			КонецЕсли;
			//Если СтрокаТЧ.КоличествоПолучатель > 0 ИЛИ ЭтоЗадачаТехнолога Тогда
			//	//Если НЕ ЭтоСборкаВЗоныОтгрузки
			//	//	ИЛИ (ЭтоСборкаВЗоныОтгрузки И ВРаботе) Тогда
			//		Движение = ДвиженияТоварыНаСкладах.Добавить();
			//		Движение.ВидДвижения 		= ВидДвиженияНакопления.Приход;
			//		Движение.Период 			= ЭтотОбъект.Дата;
			//		Движение.Склад 				= ЭтотОбъект.СкладПолучатель;
			//		Движение.Номенклатура 		= СтрокаТЧ.Номенклатура;
			//		Движение.ЕдиницаИзмерения 	= СтрокаТЧ.ЕдиницаИзмерения;
			//		Движение.Характеристика 	= СтрокаТЧ.Характеристика;
			//		Движение.ДатаПроизводства 	= СтрокаТЧ.ДатаПроизводства;
			//		Движение.Количество 		= СтрокаТЧ.КоличествоПолучатель;
			//		Движение.АвторИзменений 	= ТекПользователь;
			//	//КонецЕсли;	
			//КонецЕсли;
			
			
		КонецЦикла;
		//+++АК BELN 2018.02.05  ИП-00017827
		Движения.ТоварыНаСкладах.Прочитать();
		ТабДвижения = Движения.ТоварыНаСкладах.Выгрузить();
		Движения.ТоварыНаСкладах.Очистить();
		Движения.ТоварыНаСкладах.Записать();
		Движения.ТоварыНаСкладах.Загрузить(ТабДвижения);
		
		Для Каждого СтрокаДвижение Из ТабИзмененийВДвижениях Цикл
			
			//Движение.Период 			= ТекДата;
			//Движение.Склад 				= СтрокаДвижение.Склад;
			//Движение.Номенклатура 		= СтрокаДвижение.Номенклатура;
			//Движение.Характеристика 	= СтрокаДвижение.Характеристика;
			//Движение.ДатаПроизводства 	= СтрокаДвижение.ДатаПроизводства;
			//Движение.ЕдиницаИзмерения	= СтрокаДвижение.ЕдиницаИзмерения;
			//Движение.Количество 		= СтрокаДвижение.Количество;
			//Движение.АвторИзменений		= ПараметрыСеанса.ТекущийПользователь;
			Если СтрокаДвижение.КоличествоОтправитель <> 0 ИЛИ ЭтоЗадачаТехнолога Тогда
				
				Движение = ДвиженияТоварыНаСкладах.Добавить();
				Движение.ВидДвижения 		= ВидДвиженияНакопления.Расход;
				Движение.Период 			= ТекДата;
				Движение.Склад 				= ЭтотОбъект.СкладОтправитель;
				Движение.Номенклатура 		= СтрокаДвижение.Номенклатура;
				Движение.ЕдиницаИзмерения 	= СтрокаДвижение.ЕдиницаИзмерения;
				Движение.Характеристика 	= СтрокаДвижение.Характеристика;
				Движение.ДатаПроизводства 	= СтрокаДвижение.ДатаПроизводства;
				Движение.Количество 		= СтрокаДвижение.КоличествоОтправитель;
				Движение.АвторИзменений 	= ТекПользователь;
			КонецЕсли;
			Если СтрокаДвижение.КоличествоПолучатель <> 0 ИЛИ ЭтоЗадачаТехнолога Тогда
				//Если НЕ ЭтоСборкаВЗоныОтгрузки
				//	ИЛИ (ЭтоСборкаВЗоныОтгрузки И ВРаботе) Тогда
					Движение = ДвиженияТоварыНаСкладах.Добавить();
					Движение.ВидДвижения 		= ВидДвиженияНакопления.Приход;
					Движение.Период 			= ТекДата;
					Движение.Склад 				= ЭтотОбъект.СкладПолучатель;
					Движение.Номенклатура 		= СтрокаДвижение.Номенклатура;
					Движение.ЕдиницаИзмерения 	= СтрокаДвижение.ЕдиницаИзмерения;
					Движение.Характеристика 	= СтрокаДвижение.Характеристика;
					Движение.ДатаПроизводства 	= СтрокаДвижение.ДатаПроизводства;
					Движение.Количество 		= СтрокаДвижение.КоличествоПолучатель;
					Движение.АвторИзменений 	= ТекПользователь;
				//КонецЕсли;	
			КонецЕсли;
			
		КонецЦикла;
		
		//---АК BELN 2018.02.05 
		
		//
		ОтправитьПисьмаВозвратПоставщику();
		
	КонецЕсли;	
			
КонецПроцедуры

//+++АК LATV 2018.07.23 ИП-00018525
Процедура ОбработкаПроверкиЗаполнения(Отказ, ПроверяемыеРеквизиты)

	Если ЭтоВозвратПоставщику Тогда
		ПроверяемыеРеквизиты.Добавить("Товары.ВидДефекта");
	КонецЕсли;

КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Функция ПроверитьОстатки()
	
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("Дата"	, ЭтотОбъект.Дата);
	Запрос.УстановитьПараметр("Склад"	, ЭтотОбъект.СкладОтправитель);
	Запрос.УстановитьПараметр("Ссылка"	, ЭтотОбъект.Ссылка);
	Запрос.Текст =
	"ВЫБРАТЬ
	|	Требуется.Номенклатура,
	|	ЕСТЬNULL(Требуется.Количество, 0) КАК КоличествоТребуется,
	|	ЕСТЬNULL(Остатки.КоличествоОстаток, 0) КАК КоличествоОстаток
	|ИЗ
	|	(ВЫБРАТЬ
	|		ПеремещениеСкладНоменклатура.Номенклатура КАК Номенклатура,
	|		СУММА(ПеремещениеСкладНоменклатура.КоличествоОтправитель) КАК Количество
	|	ИЗ
	|		Документ.ПеремещениеСклад.Товары КАК ПеремещениеСкладНоменклатура
	|	ГДЕ
	|		ПеремещениеСкладНоменклатура.Ссылка = &Ссылка
	|	
	|	СГРУППИРОВАТЬ ПО
	|		ПеремещениеСкладНоменклатура.Номенклатура) КАК Требуется
	|		ЛЕВОЕ СОЕДИНЕНИЕ (ВЫБРАТЬ
	|			ТоварыНаСкладахОстатки.Номенклатура КАК Номенклатура,
	|			ТоварыНаСкладахОстатки.КоличествоОстаток КАК КоличествоОстаток
	|		ИЗ
	|			РегистрНакопления.ТоварыНаСкладах.Остатки(&Дата, Склад = &Склад) КАК ТоварыНаСкладахОстатки
	|		ГДЕ
	|			ТоварыНаСкладахОстатки.Номенклатура В
	|					(ВЫБРАТЬ
	|						ПеремещениеСкладНоменклатура.Номенклатура КАК Номенклатура
	|					ИЗ
	|						Документ.ПеремещениеСклад.Товары КАК ПеремещениеСкладНоменклатура
	|					ГДЕ
	|						ПеремещениеСкладНоменклатура.Ссылка = &Ссылка
	|					СГРУППИРОВАТЬ ПО
	|								ПеремещениеСкладНоменклатура.Номенклатура)) КАК Остатки
	|		ПО Требуется.Номенклатура = Остатки.Номенклатура
	|ГДЕ
	|	ЕСТЬNULL(Требуется.Количество, 0) > ЕСТЬNULL(Остатки.КоличествоОстаток, 0)";
	
	Выборка = Запрос.Выполнить().Выбрать();
	Если Выборка.Количество() = 0 Тогда
		Возврат Истина;
	КонецЕсли;

	Пока Выборка.Следующий() Цикл
		Сообщить("Недостаточно остатка по номенклатуре " + Выборка.Номенклатура +
					". Требуется: " + Выборка.КоличествоТребуется + ", имеется: " + Выборка.КоличествоОстаток);
	КонецЦикла;
	
	Возврат Ложь;
	
КонецФункции

Процедура ОтправитьПисьмаВозвратПоставщику()
	
	Если НЕ (ЭтотОбъект.СкладПолучатель = Справочники.Склады.НайтиПоКоду("000000294")
				ИЛИ ЭтотОбъект.СкладПолучатель = Справочники.Склады.НайтиПоКоду("000000333")) Тогда  // только для складов возврата поставщику
		Возврат;
	КонецЕсли;
	
	//
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("ТекущийДокумент"		, ЭтотОбъект.Ссылка);
	Запрос.УстановитьПараметр("СтруктурнаяЕдиница"	, ЭтотОбъект.СкладПолучатель.Владелец);
	
	Запрос.Текст =
	"ВЫБРАТЬ РАЗРЕШЕННЫЕ
	|	СпрРасчетчики.УчетнаяЗаписьЭлектроннойПочты.АдресЭлектроннойПочты КАК АдресЭлектроннойПочты,
	|	ТЧТовары.Номенклатура.Наименование КАК Товар,
	|	ТЧТовары.Характеристика.Наименование КАК Характеристика,
	|	ТЧТовары.ДатаПроизводства КАК ДатаПроизводства,
	|	ТЧТовары.КоличествоПолучатель КАК Количество
	|ИЗ
	|	Документ.ПеремещениеСклад.Товары КАК ТЧТовары
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ Справочник.Расчетчики.ГруппыНоменклатуры КАК РасчетчикиГруппыНоменклатуры
	|		ПО (РасчетчикиГруппыНоменклатуры.ГруппаНоменклатуры = ТЧТовары.Номенклатура)
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ Справочник.Расчетчики КАК СпрРасчетчики
	|		ПО (СпрРасчетчики.Ссылка = РасчетчикиГруппыНоменклатуры.Ссылка)
	|			И (СпрРасчетчики.Склад = &СтруктурнаяЕдиница)
	|ГДЕ
	|	ТЧТовары.Ссылка = &ТекущийДокумент
	|	И НЕ СпрРасчетчики.УчетнаяЗаписьЭлектроннойПочты.АдресЭлектроннойПочты = """"
	|
	|УПОРЯДОЧИТЬ ПО
	|	АдресЭлектроннойПочты,
	|	РасчетчикиГруппыНоменклатуры.ГруппаНоменклатуры.Наименование
	|ИТОГИ ПО
	|	АдресЭлектроннойПочты";
	
	РезультатЗапроса = Запрос.Выполнить();
	Если РезультатЗапроса.Пустой() Тогда
		Возврат;
	КонецЕсли;
	
	
	//
	мУчетнаяЗапись 	= ОбщиеПроцедуры.ПолучитьУчетнуюЗаписьДляРассылки();
	мПрофиль 		= УправлениеЭлектроннойПочтой.ПолучитьИнтернетПочтовыйПрофиль(мУчетнаяЗапись);
	
	ВыборкаПоАдресам = РезультатЗапроса.Выбрать(ОбходРезультатаЗапроса.ПоГруппировкам);
	Пока ВыборкаПоАдресам.Следующий() Цикл
		
		ТекстХТМЛ = "<table border='2'><tr align='center'><td>Номенклатура</td><td>Характеристика</td><td>Дата производства</td><td>Количество</td></tr>";
        Выборка = ВыборкаПоАдресам.Выбрать();
		Пока Выборка.Следующий() Цикл
			ТекстХТМЛ = ТекстХТМЛ + "<tr>" +
									"<td>" + СокрЛП(Выборка.Товар) + "</td>" +
									"<td>" + СокрЛП(Выборка.Характеристика) + "</td>" +
									"<td>" + Формат(Выборка.ДатаПроизводства, "ДЛФ=Д") + "</td>" +
									"<td>" + Формат(Выборка.Количество, "ЧГ=") + "</td>" +
									"</tr>";
		КонецЦикла;
		ТекстХТМЛ = ТекстХТМЛ + "</table>";
		
		//
		Письмо = Новый ИнтернетПочтовоеСообщение;
		Письмо.Тема 			= "Перемещение товара на склад возврата поставщику";
		Письмо.Отправитель 		= мУчетнаяЗапись.Логин;
		Письмо.ИмяОтправителя 	= мУчетнаяЗапись.Логин;
		
		//
		ТекАдрес = ВыборкаПоАдресам.АдресЭлектроннойПочты;	
		ПозРазделителя = Найти(ТекАдрес, ";");
		Пока ПозРазделителя > 0 Цикл
			Получатель = Письмо.Получатели.Добавить();
			Получатель.Адрес = СокрЛП(Лев(ТекАдрес, ПозРазделителя - 1));	
			ТекАдрес = Сред(ТекАдрес, ПозРазделителя + 1);
			ПозРазделителя = Найти(ТекАдрес, ";");
		КонецЦикла;
		Если НЕ ТекАдрес = "" Тогда
			Получатель = Письмо.Получатели.Добавить();
			Получатель.Адрес = СокрЛП(ТекАдрес);
		КонецЕсли;

		Письмо.Тексты.Добавить("На склад """ + СокрЛП(ЭтотОбъект.СкладПолучатель.Наименование) + """ перемещен товар:");
		
		ТекстПисьма = Письмо.Тексты.Добавить();
		ТекстПисьма.ТипТекста 	= ТипТекстаПочтовогоСообщения.HTML;
		ТекстПисьма.Текст 		= ТекстХТМЛ;
		
		Письмо.Тексты.Добавить(Символы.ПС + "Письмо автоматически сформировано при проведении документа """ + Строка(ЭтотОбъект.Ссылка) + """");
		
		Попытка
			Почта = Новый ИнтернетПочта;
			Почта.Подключиться(мПрофиль);	
			Почта.Послать(Письмо);
			Почта.Отключиться();
		Исключение
			ОбщегоНазначения.СообщитьОбОшибке(ОписаниеОшибки());
		КонецПопытки;
	КонецЦикла;
	
КонецПроцедуры

//+++АК BELN 2018.02.05 ИП-00017827
Функция ПолучитьТаблицуИзмененийВДвижениях()
	
	УстановитьПривилегированныйРежим(Истина);
	
	Запрос = Новый Запрос();
	Запрос.Текст = "ВЫБРАТЬ
	               |	ТоварыНаСкладах.Склад,
	               |	ТоварыНаСкладах.Номенклатура,
	               |	ТоварыНаСкладах.Характеристика,
	               |	ТоварыНаСкладах.ДатаПроизводства,
	               |	ТоварыНаСкладах.ЕдиницаИзмерения,
	               |	СУММА(ТоварыНаСкладах.Количество * ВЫБОР
	               |			КОГДА ТоварыНаСкладах.ВидДвижения = ЗНАЧЕНИЕ(ВидДвиженияНакопления.Расход)
	               |				ТОГДА 1
	               |			ИНАЧЕ 1
	               |		КОНЕЦ) КАК Количество,
	               |	ТоварыНаСкладах.ВидДвижения
	               |ПОМЕСТИТЬ ВТ_Движения
	               |ИЗ
	               |	РегистрНакопления.ТоварыНаСкладах КАК ТоварыНаСкладах
	               |ГДЕ
	               |	ТоварыНаСкладах.Регистратор = &Регистратор
				   //+++АК SHEP 2018.05.06 ИП-00018453
	               //|	И ТоварыНаСкладах.Склад.Владелец <> ЗНАЧЕНИЕ(Справочник.СтруктурныеЕдиницы.СторонняяПереработка)
				   |	И НЕ ТоварыНаСкладах.Склад.Владелец.СторонняяПереработка
				   //---АК SHEP 2018.05.06
	               |	И ТоварыНаСкладах.Активность = ИСТИНА
	               |	И (ТоварыНаСкладах.КорректировкаПоИнвентаризации = НЕОПРЕДЕЛЕНО
	               |			ИЛИ ТоварыНаСкладах.КорректировкаПоИнвентаризации = ЗНАЧЕНИЕ(Документ.ИнвентаризацияСклад.ПустаяСсылка))
	               |
	               |СГРУППИРОВАТЬ ПО
	               |	ТоварыНаСкладах.Склад,
	               |	ТоварыНаСкладах.Номенклатура,
	               |	ТоварыНаСкладах.Характеристика,
	               |	ТоварыНаСкладах.ДатаПроизводства,
	               |	ТоварыНаСкладах.ЕдиницаИзмерения,
	               |	ТоварыНаСкладах.ВидДвижения
	               |;
	               |
	               |////////////////////////////////////////////////////////////////////////////////
	               |ВЫБРАТЬ
	               |	&СкладПолучатель КАК СкладПолучатель,
	               |	&СкладОтправитель КАК СкладОтправитель,
	               |	РасходныйОрдерСкладТовары.Номенклатура,
	               |	РасходныйОрдерСкладТовары.Характеристика,
	               |	РасходныйОрдерСкладТовары.ДатаПроизводства,
	               |	РасходныйОрдерСкладТовары.ЕдиницаИзмерения,
	               |	РасходныйОрдерСкладТовары.КоличествоОтправитель КАК КоличествоОтправитель,
	               |	РасходныйОрдерСкладТовары.КоличествоПолучатель КАК КоличествоПолучатель,
	               |	Ложь КАК ЗаявкаНаСклад
	               |ПОМЕСТИТЬ ВТ_ТабТовары
	               |ИЗ
	               |	&Товары КАК РасходныйОрдерСкладТовары
	               |;
	               |
	               |////////////////////////////////////////////////////////////////////////////////
	               |ВЫБРАТЬ
	               |	ЕСТЬNULL(ВЗ_Товары.СкладПолучатель,ВТ_Движения.Склад ) КАК СкладПолучатель,
	               |	ЕСТЬNULL(ВЗ_Товары.СкладОтправитель,ВТ_Движения.Склад ) КАК СкладОтправитель,
	               |	ЕСТЬNULL(ВТ_Движения.Номенклатура, ВЗ_Товары.Номенклатура) КАК Номенклатура,
	               |	ЕСТЬNULL(ВТ_Движения.Характеристика, ВЗ_Товары.Характеристика) КАК Характеристика,
	               |	ЕСТЬNULL(ВТ_Движения.ДатаПроизводства, ВЗ_Товары.ДатаПроизводства) КАК ДатаПроизводства,
	               |	ЕСТЬNULL(ВТ_Движения.ЕдиницаИзмерения, ВЗ_Товары.ЕдиницаИзмерения) КАК ЕдиницаИзмерения,
	               |	ВЫБОР
	               |		КОГДА ВТ_Движения.ВидДвижения ЕСТЬ NULL
	               |			ТОГДА ЕСТЬNULL(ВЗ_Товары.КоличествоОтправитель, 0)
	               |		КОГДА ВТ_Движения.ВидДвижения = ЗНАЧЕНИЕ(ВидДвиженияНакопления.Расход)
	               |			ТОГДА ЕСТЬNULL(ВЗ_Товары.КоличествоОтправитель, 0) - ЕСТЬNULL(ВТ_Движения.Количество, 0)
	               |		ИНАЧЕ 0
	               |	КОНЕЦ КАК КоличествоОтправитель,
	               |	ВЫБОР
	               |		КОГДА ВТ_Движения.ВидДвижения ЕСТЬ NULL
	               |			ТОГДА ЕСТЬNULL(ВЗ_Товары.КоличествоПолучатель, 0)
	               |		КОГДА ВТ_Движения.ВидДвижения = ЗНАЧЕНИЕ(ВидДвиженияНакопления.Приход)
	               |			ТОГДА ЕСТЬNULL(ВЗ_Товары.КоличествоПолучатель, 0) - ЕСТЬNULL(ВТ_Движения.Количество, 0)
	               |		ИНАЧЕ 0
	               |	КОНЕЦ КАК КоличествоПолучатель,
	               |	ВЗ_Товары.ЗаявкаНаСклад,
	               |	ЛОЖЬ КАК ЭтоСкладПереработки
	               |ПОМЕСТИТЬ втИтог
	               |ИЗ
	               |	ВТ_Движения КАК ВТ_Движения
	               |		ПОЛНОЕ СОЕДИНЕНИЕ (ВЫБРАТЬ
	               |			ВТ_ТабТовары.СкладОтправитель КАК СкладОтправитель,
	               |			ВТ_ТабТовары.СкладПолучатель КАК СкладПолучатель,
	               |			ВТ_ТабТовары.Номенклатура КАК Номенклатура,
	               |			ВТ_ТабТовары.Характеристика КАК Характеристика,
	               |			ВТ_ТабТовары.ДатаПроизводства КАК ДатаПроизводства,
	               |			ВТ_ТабТовары.ЕдиницаИзмерения КАК ЕдиницаИзмерения,
	               |			СУММА(ВТ_ТабТовары.КоличествоПолучатель) КАК КоличествоПолучатель,
	               |			СУММА(ВТ_ТабТовары.КоличествоОтправитель) КАК КоличествоОтправитель,
	               |			ВТ_ТабТовары.ЗаявкаНаСклад КАК ЗаявкаНаСклад
	               |		ИЗ
	               |			ВТ_ТабТовары КАК ВТ_ТабТовары
	               |		
	               |		СГРУППИРОВАТЬ ПО
	               |			ВТ_ТабТовары.СкладОтправитель ,
	               |			ВТ_ТабТовары.СкладПолучатель ,
				   
	               |			ВТ_ТабТовары.Номенклатура,
	               |			ВТ_ТабТовары.Характеристика,
	               |			ВТ_ТабТовары.ДатаПроизводства,
	               |			ВТ_ТабТовары.ЕдиницаИзмерения,
	               |			ВТ_ТабТовары.ЗаявкаНаСклад) КАК ВЗ_Товары
	               |		ПО (ВТ_Движения.ВидДвижения = ЗНАЧЕНИЕ(ВидДвиженияНакопления.Приход) И ВЗ_Товары.СкладПолучатель=ВТ_Движения.Склад ИЛИ ВТ_Движения.ВидДвижения = ЗНАЧЕНИЕ(ВидДвиженияНакопления.Расход) И ВЗ_Товары.СкладОтправитель=ВТ_Движения.Склад)
	               |			И ВТ_Движения.Номенклатура = ВЗ_Товары.Номенклатура
	               |			И ВТ_Движения.Характеристика = ВЗ_Товары.Характеристика
	               |			И ВТ_Движения.ДатаПроизводства = ВЗ_Товары.ДатаПроизводства
	               |			И ВТ_Движения.ЕдиницаИзмерения = ВЗ_Товары.ЕдиницаИзмерения
	               |;
	               |
	               |////////////////////////////////////////////////////////////////////////////////
	               |УНИЧТОЖИТЬ ВТ_Движения
	               |;
	               |
	               |////////////////////////////////////////////////////////////////////////////////
	               |УНИЧТОЖИТЬ ВТ_ТабТовары
	               |;
	               |
	               |////////////////////////////////////////////////////////////////////////////////
	               |ВЫБРАТЬ
	               |	втИтог.СкладОтправитель,
	               |	втИтог.СкладПолучатель,
	               |	втИтог.Номенклатура,
	               |	втИтог.Характеристика,
	               |	втИтог.ДатаПроизводства,
	               |	втИтог.ЕдиницаИзмерения,
	               |	СУММА(втИтог.КоличествоОтправитель) КАК КоличествоОтправитель,
	               |	СУММА(втИтог.КоличествоПолучатель) КАК КоличествоПолучатель,
	               |	втИтог.ЗаявкаНаСклад,
	               |	втИтог.ЭтоСкладПереработки
	               |ИЗ
	               |	втИтог КАК втИтог
	               |
	               |СГРУППИРОВАТЬ ПО
	               |	втИтог.СкладОтправитель,
	               |	втИтог.СкладПолучатель,
	               |	втИтог.Номенклатура,
	               |	втИтог.Характеристика,
	               |	втИтог.ДатаПроизводства,
	               |	втИтог.ЕдиницаИзмерения,
	               |	втИтог.ЗаявкаНаСклад,
	               |	втИтог.ЭтоСкладПереработки";
				   
	Запрос.УстановитьПараметр("Регистратор", Ссылка);
	Запрос.УстановитьПараметр("Товары",  Товары.Выгрузить());
	Запрос.УстановитьПараметр("СкладОтправитель", СкладОтправитель);
	Запрос.УстановитьПараметр("СкладПолучатель", СкладПолучатель);
	ТаблицаДвижений = Запрос.Выполнить().Выгрузить();
	
	
	Возврат ТаблицаДвижений;
	
КонецФункции

#КонецОбласти