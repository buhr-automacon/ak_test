﻿

Процедура ОбработкаПроведения(Отказ, РежимПроведения)
	
	мПроводки = ЭтотОбъект.Движения.Финансовый;
	мПроводки.Записывать = Истина;
	мПроводки.Очистить();
	
	//// после 01.10.2016 проводки - в документах поступления товаров и услуг
	//Если НЕ ЭтотОбъект.Дата < Дата(2016, 10, 1) Тогда
	//	Возврат;
	//КонецЕсли;
	
	// проводка "Транспортные расходы по доставке на точку"
	
	//+++АК SHEP 2018.04.18 ИП-00018423
	// после 01.04.2018 проводки в документе "Поступление товаров и услуг" (по транспортным услугам)
	Если Дата >= Дата(2018, 4, 1) Тогда
		Возврат;
	КонецЕсли;
	
	// перенёс формирование движений в модуль менеджера
	Документы.ДоставкаНаТТ.ДвиженияФинансовыйЗаполнить(ЭтотОбъект, мПроводки, Отказ);
	//---АК SHEP 2018.04.18
	
	//+++АК POZM 2018.05.31 ИП-00018739 
	// 
	////+++АК pozm 20.04.2017
	//ВыполнитьДвиженияПоАвансамАкцептантов();
	////---АК pozm 20.04.2017
	//---АК POZM 
	

КонецПроцедуры

//
//
Процедура ПередЗаписью(Отказ, РежимЗаписи, РежимПроведения)
	
	//
	тзТорговыеТочки = ЭтотОбъект.Состав.Выгрузить();
	//+++АК SHEP 2018.04.26 ИП-00018321.02
	//тзТорговыеТочки.Свернуть("ТТ, Ставка", "Количество");
	тзТорговыеТочки.Свернуть("ТТ,Ставка,СтавкаДопТарифа", "Количество");
	//---АК SHEP 2018.04.26
	
	//
	ЭтотОбъект.СуммаДокумента = 0;
	ЭтотОбъект.СуммаДопТарифа = 0; //+++АК SHEP 2018.04.26 ИП-00018321.02
	Для Каждого СтрокаТЧ Из тзТорговыеТочки Цикл
		ЭтотОбъект.СуммаДокумента = ЭтотОбъект.СуммаДокумента + СтрокаТЧ.Ставка * СтрокаТЧ.Количество;
		ЭтотОбъект.СуммаДопТарифа = ЭтотОбъект.СуммаДопТарифа + СтрокаТЧ.СтавкаДопТарифа * СтрокаТЧ.Количество; //+++АК SHEP 2018.04.26 ИП-00018321.02
	КонецЦикла;	
		
КонецПроцедуры

Процедура ПриКопировании(ОбъектКопирования)
	
	ЭтотОбъект.Состав.Очистить();
	
КонецПроцедуры

Процедура ОбработкаЗаполнения(ДанныеЗаполнения, СтандартнаяОбработка)
	
	Если ТипЗнч(ДанныеЗаполнения) = Тип("ДокументСсылка.ЗаявкаНаУслугиМатериалы") Тогда
		
		ЭтотОбъект.Организация 			= ДанныеЗаполнения.Организация;
		ЭтотОбъект.Контрагент			= ДанныеЗаполнения.Контрагент;
		ЭтотОбъект.ДокументОснование 	= ДанныеЗаполнения.Ссылка;
		//+++ АК pozm ИП-00016503
		ЭтотОбъект.Заявка				= ДанныеЗаполнения;
		//--- АК pozm ИП-00016503
		
		ЭтотОбъект.СуммаДокумента		= ДанныеЗаполнения.Услуги.Итог("Сумма");
		ЭтотОбъект.Ответственный		= ДанныеЗаполнения.Ответственный;
		
	КонецЕсли;

КонецПроцедуры

Процедура ПриЗаписи(Отказ)
	//+++АК POZM 2018.05.31 ИП-00018739
	Если ЗначениеЗаполнено(ЭтотОбъект.Заявка)
			И ТипЗнч(ЭтотОбъект.Заявка) = Тип("ДокументСсылка.ЗаявкаНаУслугиМатериалы") Тогда
		ПолныеПрава.ЗарегистрироватьОтложенныйРасчетНаличияПоступленийПоЗаявке(ЭтотОбъект.Заявка);
	КонецЕсли;
	Если ЗначениеЗаполнено(Ссылка.Заявка) И ТипЗнч(Ссылка.Заявка)=Тип("ДокументСсылка.ЗаявкаНаУслугиМатериалы") И Ссылка.Заявка<>Заявка Тогда	
		ПолныеПрава.ЗарегистрироватьОтложенныйРасчетНаличияПоступленийПоЗаявке(Ссылка.Заявка);
	КонецЕсли;
	#Область АК_ОтключенныйКод 
	//Если ЗначениеЗаполнено(ЭтотОбъект.ДокументОснование)
	//		И ТипЗнч(ЭтотОбъект.ДокументОснование) = Тип("ДокументСсылка.ЗаявкаНаУслугиМатериалы") Тогда
	//		
	//	ЗаявкаОбъект = ЭтотОбъект.ДокументОснование.ПолучитьОбъект();
	//	ВсеДокументыВНаличииЗаявка 	= ЗаявкаОбъект.ВсеДокументыВНаличии;
	//	СуммаОстатка 				= ЗаявкаОбъект.ВсеДокументыВНаличии();
	//	
	//	Если (СуммаОстатка-ЭтотОбъект.СуммаДокумента)<0 Тогда
	//		//Отказ = истина;
	//		Сообщить("Сумма поступлений по заявке документа превышает сумму заявки!");
	//		//Возврат;
	//	ИначеЕсли СуммаОстатка=ЭтотОбъект.СуммаДокумента Тогда
	//		ЗаявкаОбъект.ВсеДокументыВНаличии = Истина;
	//	КонецЕсли;	

	//	Если ЗаявкаОбъект.ВсеДокументыВНаличии <> ВсеДокументыВНаличииЗаявка Тогда
	//		ЗаявкаОбъект.Записать(РежимЗаписиДокумента.Запись);
	//	КонецЕсли;
	//	
	//КонецЕсли;
	//Если ЗначениеЗаполнено(Ссылка.ДокументОснование) И ТипЗнч(Ссылка.ДокументОснование)=Тип("ДокументСсылка.ЗаявкаНаУслугиМатериалы") И Ссылка.ДокументОснование<>ДокументОснование Тогда
	//	ЗаявкаОбъект = Ссылка.ДокументОснование.ПолучитьОбъект();
	//	ВсеДокументыВНаличииЗаявка = ЗаявкаОбъект.ВсеДокументыВНаличии;
	//	СуммаОстатка = ЗаявкаОбъект.ВсеДокументыВНаличии(ЭтотОбъект.Ссылка);
	//	#Если Клиент Тогда
	//	Если (СуммаОстатка-ЭтотОбъект.СуммаДокумента)<0 Тогда
	//		//Отказ = истина;
	//		//Сообщить("Сумма поступлений по заявке документа превышает сумму заявки!");
	//		//Возврат;
	//	КонецЕсли;	
	//	#КонецЕсли
	//	Если ЗаявкаОбъект.ВсеДокументыВНаличии<>ВсеДокументыВНаличииЗаявка Тогда
	//		ЗаявкаОбъект.Записать(РежимЗаписиДокумента.Запись);
	//	КонецЕсли;	
	//КонецЕсли;
	#КонецОбласти 
	//---АК POZM 
КонецПроцедуры
//+++АК POZM 2018.05.31 ИП-00018739 
//Процедура ВыполнитьДвиженияПоАвансамАкцептантов()
//	Запись = РегистрыСведений.ОтложенныеДвиженияДокументов.СоздатьМенеджерЗаписи();
//	Запись.Документ = ЭтотОбъект.Ссылка;
//	Запись.ДатаДокумента = ЭтотОбъект.Дата;
//	Запись.Записать();
//КонецПроцедуры	


////+++АК pozm 20.04.2017
//	ВыполнитьДвиженияПоАвансамАкцептантов();
///---АК pozm 20.04.2017
//---АК POZM 