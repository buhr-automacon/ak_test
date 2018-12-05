﻿
Перем мСчет6004;

Перем РаспроведениеИзСвязанногоРейса Экспорт; // Тип Булево, устанавливается в Истина,
										 	  // логикой объекта Машрутный Лист, при 
											  // распроведении связанного с этим объектом Маршрутного листа

Перем ПроверятьУникальностьРейсаОтносительноЗаявки Экспорт;											  
											  
#Область ОбработчикиСобытий

Процедура ПриКопировании(ОбъектКопирования)
	
	ЭтотОбъект.Отгружено 	= Ложь;
	ЭтотОбъект.Автор 		= Неопределено;
	ЭтотОбъект.Оператор 	= Неопределено;
	
КонецПроцедуры

Процедура ОбработкаЗаполнения(ДанныеЗаполнения, СтандартнаяОбработка)
	
	Если ТипЗнч(ДанныеЗаполнения) = Тип("ДокументСсылка.АК_ЗаявкаНаПеревозку") Тогда
		//+++АК sole 2018.07.12 ИП-00018320.04	
		ЭтотОбъект.Организация 	= ДанныеЗаполнения.Организация;
		ЭтотОбъект.ВидПеревозки = ДанныеЗаполнения.ВидПеревозки;
		ЭтотОбъект.Перевозчик = ДанныеЗаполнения.Перевозчик; 
		ЭтотОбъект.СтавкаНДС = ДанныеЗаполнения.Перевозчик.СтавкаНДС;
		ЭтотОбъект.ДокументОснование = ДанныеЗаполнения;
		ЭтотОбъект.Заявка = ДанныеЗаполнения;
		
		Если ЭтотОбъект.СтавкаНДС = Перечисления.СтавкиНДС.БезНДС Тогда
			ЭтотОбъект.ВариантРасчетаНДС = Перечисления.ВариантыРасчетаНДС.БезНДС;
		Иначе
			ЭтотОбъект.ВариантРасчетаНДС = Перечисления.ВариантыРасчетаНДС.НДСвТомЧисле;	
		КонецЕсли;
		
		ЭтотОбъект.СтруктурноеПодразделение = ДанныеЗаполнения.СтруктурнаяЕдиница;
		ЭтотОбъект.Дата = ДанныеЗаполнения.ДатаПлановойДоставки;
		ЭтотОбъект.Сумма = ДанныеЗаполнения.Сумма;
		
		Для Каждого Стр Из ДанныеЗаполнения.РасходныеОрдера Цикл
			НСтр = ЭтотОбъект.РасходныеОрдера.Добавить();
			НСтр.Документ = Стр.РасходныйОрдер;
		КонецЦикла;
		//---АК sole 2018.07.12 ИП-00018320.04
	ИначеЕсли ТипЗнч(ДанныеЗаполнения) = Тип("ДокументСсылка.ЗаявкаНаУслугиМатериалы") Тогда
		
		//Если ДанныеЗаполнения.Маршруты.Количество() > 0 Тогда
		//	ЭтотОбъект.Маршрут 		= ДанныеЗаполнения.Маршруты[0].Маршрут;
		//	ЗаполнитьЗначенияСвойств(ЭтотОбъект, ЭтотОбъект.Маршрут, "СтруктурноеПодразделение, Перевозчик, Сумма, ВариантРасчетаНДС, СтавкаНДС, СуммаНДС");
		//КонецЕсли;
		ЭтотОбъект.Организация 		= ДанныеЗаполнения.Организация;
		ЭтотОбъект.Перевозчик		= ДанныеЗаполнения.Контрагент;
		ЭтотОбъект.ВариантРасчетаНДС = ДанныеЗаполнения.ВариантРасчетаНДС;
		ЭтотОбъект.ДокументОснование = ДанныеЗаполнения.Ссылка;
		ЭтотОбъект.ДатаДоставкиПлан = ДанныеЗаполнения.ДатаПоступления;	
		ЭтотОбъект.Сумма			= ДанныеЗаполнения.Услуги.Итог("Сумма");
		ЭтотОбъект.СуммаНДС			= ДанныеЗаполнения.Услуги.Итог("СуммаНДС");
		ЭтотОбъект.Автор			= ДанныеЗаполнения.Ответственный;
		Если ДанныеЗаполнения.Услуги.Количество() > 0 Тогда
			ЭтотОбъект.СтавкаНДС = ДанныеЗаполнения.Услуги[0].СтавкаНДС;
		КонецЕсли;
		//+++ АК pozm ИП-00016503
		ЭтотОбъект.Заявка				= ДанныеЗаполнения;
		//--- АК pozm ИП-00016503
	КонецЕсли;
	
КонецПроцедуры

Процедура ПередЗаписью(Отказ, РежимЗаписи, РежимПроведения)
	
	//+++АК sole 2018.05.29 ИП-00018724.02
	АК_ПроверитьРеквизитСвязанСМаршрутнымЛистом(Отказ);
	
	Если Отказ Тогда
		Возврат;
	КонецЕсли;
	//---АК sole 2018.05.29  ИП-00018724.02
	
	
	//+++АК KIRN 2018.05.25 ИП-00018663.000.00000002
	Если ОбщиеПроцедуры.ЭтоВнешняяОрганизация(ЭтотОбъект.Организация) Тогда
		Если ЗначениеЗаполнено(ЭтотОбъект.ДатаЗавершенияПогрузки) Тогда
			Если ЭтотОбъект.ДатаЗавершенияПогрузки <> ЭтотОбъект.Ссылка.ДатаЗавершенияПогрузки Тогда
				ОбщиеПроцедуры.ОбновитьРТУПоМаршрутномуЛисту(Ссылка);
			КонецЕСли;
		КонецЕСли;
	Конецесли;
	//---АК KIRN 
	
	//+++АК sole 2018.07.12 ИП-00018320.04
	Если ЭтотОбъект.ВидПеревозки = Справочники.АК_ВидыПеревозки.ВозвратПоставщику Тогда
		
		Если ПроверятьУникальностьРейсаОтносительноЗаявки Тогда
			
			Отказ = РейсОтносительноЗаявкиНеуникален();
			
			Если Отказ Тогда
				Возврат;
			КонецЕсли;
		КонецЕсли;
		
		РассчитатьСуммуНДС(ЭтотОбъект.Сумма);				
	КонецЕсли;
	//---АК sole 2018.07.12 ИП-00018320.04
	
	//+++АК sole 2018.06.26 ИП-00018321.05	
	Если ЭтотОбъект.ВидПеревозки = Справочники.АК_ВидыПеревозки.ДоставкаНаТТ Тогда
		
		Если ЭтотОбъект.ПричинаПеревозки.Пустая() Тогда
			ЭтотОбъект.ПричинаПеревозки = Перечисления.ПричиныПеревозки.ОсновнаяПоставка;
		КонецЕсли;
		
		//+++АК sole 2018.06.29 ИП-00018321.01				
		Если ЭтотОбъект.РасходныеОрдера.Количество() > 0 Тогда
			
			Если ЭтотОбъект.ПричинаПеревозки = Перечисления.ПричиныПеревозки.ОсновнаяПоставка Тогда
				Суммы = ПолучитьСуммуДокумента_ОсновнаяПоставка();	
			Иначе
				Суммы = ПолучитьСуммуДокумента_Допоставка();
			КонецЕсли;
			//---АК sole 2018.06.29 ИП-00018321.01
			
			//+++АК sole 2018.04.24 ИП-00018321
			
			мСуммаДокумента = Суммы.Сумма;
			мСуммаДопТарифа = Суммы.СуммаДопТарифа;
		
			Если ЭтотОбъект.Сумма <> мСуммаДокумента ИЛИ ЭтотОбъект.СуммаДопТарифа <> мСуммаДопТарифа Тогда
			
				ЭтотОбъект.Сумма = мСуммаДокумента;
				ЭтотОбъект.СуммаДопТарифа = мСуммаДопТарифа; 
			
				РассчитатьСуммуНДС(мСуммаДокумента + мСуммаДопТарифа);
			
			КонецЕсли;
			//---АК sole 2018.04.24 ИП-00018321   
		КонецЕсли;
		
		
	КонецЕсли;
	//---АК sole 2018.06.26 ИП-00018321.05		
	
	Если НЕ ЗначениеЗаполнено(ЭтотОбъект.Автор) Тогда
		ЭтотОбъект.Автор = ПараметрыСеанса.ТекущийПользователь;
	КонецЕсли;
	
	Если НЕ ЗначениеЗаполнено(ЭтотОбъект.Оператор) Тогда
		Запрос = Новый Запрос;
		Запрос.УстановитьПараметр("Пользователь", ПараметрыСеанса.ТекущийПользователь);
		Запрос.Текст =
		"ВЫБРАТЬ
		|	ГруппыПользователейПользователиГруппы.Ссылка
		|ИЗ
		|	Справочник.ГруппыПользователей.ПользователиГруппы КАК ГруппыПользователейПользователиГруппы
		|ГДЕ
		|	ГруппыПользователейПользователиГруппы.Ссылка.ЭтоГруппаДоступаКСкладам = ИСТИНА
		|	И ГруппыПользователейПользователиГруппы.Пользователь = &Пользователь";
					   
		Результат = Запрос.Выполнить();
		Если НЕ Результат.Пустой() Тогда
			ЭтотОбъект.Оператор = ПараметрыСеанса.ТекущийПользователь;
		КонецЕсли;	
	КонецЕсли;	
	
	//+++АК KIRN 2018.07.10  ИП-00019159
	Если Не ЗначениеЗаполнено(ЭтотОбъект.Автомобиль) и ЗначениеЗаполнено(ЭтотОбъект.Маршрут) Тогда
		//ЗаписьЖурналаРегистрации("МаршрутныйЛист_ПередЗаписью", УровеньЖурналаРегистрации.Ошибка,,ЭтотОбъект.Ссылка,"Не заполнен автомобиль для маршрурта с кодом "+ЭтотОбъект.Маршрут.Код);
		
		Запрос = Новый Запрос;
		Запрос.Текст = "ВЫБРАТЬ
		               |	ВодителиПоМаршрутуСрезПоследних.Автомобиль КАК Автомобиль
		               |ИЗ
		               |	РегистрСведений.ВодителиПоМаршруту.СрезПоследних(, Маршрут = &Маршрут) КАК ВодителиПоМаршрутуСрезПоследних";
		Запрос.УстановитьПараметр("Маршрут", ЭтотОбъект.Маршрут);
		Выборка = Запрос.Выполнить().Выбрать();
		Если Выборка.Следующий() Тогда
			ЭтотОбъект.Автомобиль = Выборка.Автомобиль;
		КонецЕСли;
		Если НЕ ЗначениеЗаполнено(ЭтотОбъект.Автомобиль) Тогда
			ОбщегоНазначения.СообщитьОбОшибке("Не заполнен автомобиль!");
		КонецЕСли;
	КонецЕСли;
	//---АК KIRN 
	
	//+++АК sole 2018.05.28 ИП-00018724.02
	Если ЭтотОбъект.ВидПеревозки = Справочники.АК_ВидыПеревозки.ДоставкаНаСклад Тогда
			
		Если ЭтотОбъект.Сумма = -1 Тогда
			// Сумма устанавливается равной "-1", в процедуре
			// "ПередЗаписьюНаСервере" в модуле формы, когда
		    // установлен реквизит формы "ПринудительныйПересчётСумм".

			АК_ЗаполнитьСуммыПоПриходникам(РежимЗаписи);		
		КонецЕсли;		
			
		//koro 10.10.17 16927 не верный НДС
		Если ЭтотОбъект.ПриходныеОрдера.Количество() > 0 Тогда	
		
			//+++АК SHEP 2018.03.14 ИП-00018096: добавил условие
			//РазрешеноРедактированиеНДС = ПолныеПрава.ПолучитьПравоПользователяУпр(ПланыВидовХарактеристик.ПраваПользователей.РазрешитьРедактироватьНДСВМаршрутномЛисте, Ложь);
			РазрешеноРедактированиеНДС = (ЭтотОбъект.Сумма = ЭтотОбъект.Ссылка.Сумма);
			Если НЕ РазрешеноРедактированиеНДС Тогда
				//---АК SHEP 2018.03.14
				РассчитатьСуммуНДС(ЭтотОбъект.Сумма);
			КонецЕсли; //---АК SHEP 2018.03.14
		
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

Процедура ПриЗаписи(Отказ)
	
	//+++АК sole 2018.06.28 ИП-00018321.01
	СоздатьЗаписиВРегистреЦенаДопоставкиНаТТ_ЕслиНеобходимо();
	//---АК sole 2018.06.28 ИП-00018321.01
	
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
	//	ВсеДокументыВНаличииЗаявка = ЗаявкаОбъект.ВсеДокументыВНаличии;
	//	СуммаОстатка = ЗаявкаОбъект.ВсеДокументыВНаличии(ЭтотОбъект.Ссылка);
	//	
	//	Если (СуммаОстатка - ЭтотОбъект.Сумма - ?(ЭтотОбъект.ВариантРасчетаНДС = Перечисления.ВариантыРасчетаНДС.НДСсверху, ЭтотОбъект.СуммаНДС, 0)) < 0 Тогда
	//	
	//		Сообщить("Сумма поступлений по заявке документа превышает сумму заявки!");
	//	ИначеЕсли СуммаОстатка=(ЭтотОбъект.Сумма + ?(ЭтотОбъект.ВариантРасчетаНДС = Перечисления.ВариантыРасчетаНДС.НДСсверху, ЭтотОбъект.СуммаНДС, 0)) Тогда
	//		ЗаявкаОбъект.ВсеДокументыВНаличии = Истина;
	//		
	//	КонецЕсли;	
	//	

	//	Если ЗаявкаОбъект.ВсеДокументыВНаличии <> ВсеДокументыВНаличииЗаявка Тогда
	//		ЗаявкаОбъект.Записать(РежимЗаписиДокумента.Запись);
	//	КонецЕсли;	
	//КонецЕсли;
	//
	//Если ЗначениеЗаполнено(Ссылка.ДокументОснование)
	//		И ТипЗнч(Ссылка.ДокументОснование) = Тип("ДокументСсылка.ЗаявкаНаУслугиМатериалы")
	//		И Ссылка.ДокументОснование <> ДокументОснование Тогда
	//	ЗаявкаОбъект = Ссылка.ДокументОснование.ПолучитьОбъект();
	//	ВсеДокументыВНаличииЗаявка = ЗаявкаОбъект.ВсеДокументыВНаличии;
	//	СуммаОстатка = ЗаявкаОбъект.ВсеДокументыВНаличии(ЭтотОбъект.Ссылка);
	//	#Если Клиент Тогда
	//	Если (СуммаОстатка - ЭтотОбъект.СуммаДокумента) < 0 Тогда
	//		//Отказ = истина;
	//		//Сообщить("Сумма поступлений по заявке документа превышает сумму заявки!");
	//		//Возврат;
	//	КонецЕсли;	
	//	#КонецЕсли
	//	Если ЗаявкаОбъект.ВсеДокументыВНаличии <> ВсеДокументыВНаличииЗаявка Тогда
	//		ЗаявкаОбъект.Записать(РежимЗаписиДокумента.Запись);
	//	КонецЕсли;	
	//КонецЕсли;
	#КонецОбласти 
	//---АК POZM 

КонецПроцедуры

//+++АК LATV 2018.06.14 ИП-00018971
Процедура ОбработкаПроведения(Отказ, РежимПроведения)

	Если ВидПеревозки = Справочники.АК_ВидыПеревозки.ДоставкаНаСклад
	   И ПриходныеОрдера.Количество() > 0 Тогда
		/////////////////////////////////////////////////////////////////////////
		// ЗатратыНаДоставкуПоПоставщикам - подготовка данных и запись в регистр
		
		//+++АК sole 2018.08.09 ИП-00019509
		Движения.ЗатратыНаДоставкуПоПоставщикам.Записывать = Истина;
		//---АК sole 2018.08.09 ИП-00019509
		
		ОтразитьДвиженияЗатратыНаДоставкуПоПоставщикам(Отказ);
	КонецЕсли;
	
	ОтразитьДвиженияПоРегиструБухгалтерии(Отказ);

КонецПроцедуры

Процедура ОбработкаУдаленияПроведения(Отказ)
	
	//+++АК sole 2018.05.22 ИП-00018724.01
	АК_НайтиИРаспровестиСвязанныеПоступленияДопРасходов(Отказ);
	
	Если 
			ЭтотОбъект.ВидПеревозки = Справочники.АК_ВидыПеревозки.ДоставкаНаСклад 
		И	НЕ ЭтотОбъект.РаспроведениеИзСвязанногоРейса	
	Тогда
		АК_НайтиИРаспровестиСвязанныйРейс(Отказ);	
	КонецЕсли; 
	//---АК sole 2018.05.22 ИП-00018724.01
	
КонецПроцедуры

//+++АК LATV 2018.06.14 ИП-00018971
Процедура ОбработкаПроверкиЗаполнения(Отказ, ПроверяемыеРеквизиты)

	АК_СнятьРеквизитСПроверки(ПроверяемыеРеквизиты, "Автомобиль");
	
	Если ВидПеревозки = Справочники.АК_ВидыПеревозки.ДоставкаНаСклад Тогда
		АК_СнятьРеквизитСПроверки(ПроверяемыеРеквизиты, "СтруктурноеПодразделение");
		
		Если ПриходныеОрдера.Количество() > 0 Тогда
			ДанныеДубля = НайтиПовторыПриходников();
			Если ДанныеДубля <> Неопределено Тогда
				ТекстСообщения = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
					НСтр("ru = 'Приходный ордер уже указан в другом документе доставки на склад! Документ - Рейс № %1 Перевозчик: %2'")
					, ДанныеДубля.Номер, ДанныеДубля.Перевозчик);
				ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения,,,, Отказ);
				Возврат;
			КонецЕсли;
			
			Если ВариантРасчетаНДС = Перечисления.ВариантыРасчетаНДС.НДСвТомЧисле
			 Или ВариантРасчетаНДС = Перечисления.ВариантыРасчетаНДС.БезНДС Тогда
				мСуммаВсего = Сумма;
			Иначе
				мСуммаВсего = Сумма + СуммаНДС;
			КонецЕсли;
			
			// Таблица сумм, распределенных по поставщикам пропорционально массам
			ТаблицаКПроведению = ПолучитьРаспределениеСуммыТранспортныхРасходов(мСуммаВсего);
			Если ТаблицаКПроведению.Количество() = 0 Тогда
				ТекстСообщения = НСтр("ru = 'Нет данных для распределения транспортных расходов!'");
				ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения,,,, Отказ);
				Возврат;
			КонецЕсли;
			
		КонецЕсли;
	КонецЕсли;

КонецПроцедуры

#КонецОбласти

#Область ПересчётСуммРейсовДоставкаНаСклад

//+++АК sole 2018.05.28 ИП-00018724.02
Процедура АК_ЗаполнитьСуммыПоПриходникам(РежимЗаписи) 
	
	// Суммы в документах с видом доставки "Доставка на склад",
	// могут рассчитывается не только этой процедурой,
	// но и обработкой "ФормированиеТранспортныхРасходовДоставкаНаСклад"
	
	Запрос = Новый Запрос();
	Запрос.МенеджерВременныхТаблиц = Новый МенеджерВременныхТаблиц();
	
	БПР = Новый Структура();
	БПР.Вставить("РежимЗаписи", РежимЗаписи);
	БПР.Вставить("Запрос", Запрос);
	
	АК_СформироватьСписокПриходников(БПР);
	АК_CФормироватьТаблицуМаршрутныеЛистыСВесами(БПР);
	
	ОбщийВес = БПР.тзМаршрутныеЛистыСВесами.Итог("Вес");
	БПР.Вставить("ОбщийВес", ОбщийВес);
	
	АК_ПодобратьТариф(БПР);
	
	Если БПР.Тариф = Неопределено Тогда
		Сообщить("Невозможно пересчитать суммы, так как в РС ""ТарифыНаДоставкуПоМаршруту"" не найден тариф для указанного маршрута!");
		Возврат;
	КонецЕсли;
	
	 АК_РассчитатьИЗаполнитьСуммыРейсов(БПР);
	
КонецПроцедуры

//+++АК sole 2018.05.28 ИП-00018724.02
Процедура АК_СформироватьСписокПриходников(БПР)
	
	Перем Запрос;
	
	Запрос = БПР.Запрос;
	Запрос.Текст =
"ВЫБРАТЬ
|	&ЭтотМаршрутныйЛист КАК МаршрутныйЛист,
|	т.ПриходныйОрдер,
|
|	ВЫБОР
|		КОГДА &ЭтотМаршрутныйЛист = ЗНАЧЕНИЕ(Документ.МаршрутныйЛист.ПустаяСсылка)
|			 ТОГДА 1
|      	ИНАЧЕ 0
|	КОНЕЦ КАК ДляСортировки
|
|		ПОМЕСТИТЬ вт
|
|ИЗ &Таблица КАК т
|;
|///////////////////////////////////////////////////////////
|
|	ВЫБРАТЬ
|		МаршрутныйЛистПриходныеОрдера.Ссылка КАК МаршрутныйЛист,
|		МаршрутныйЛистПриходныеОрдера.ПриходныйОрдер,
|		0 КАК ДляСортировки
|
|			ПОМЕСТИТЬ втСписокПриходников
|
|	ИЗ Документ.МаршрутныйЛист.ПриходныеОрдера КАК МаршрутныйЛистПриходныеОрдера
|	ГДЕ
|			НЕ МаршрутныйЛистПриходныеОрдера.Ссылка.ПометкаУдаления
|		И	МаршрутныйЛистПриходныеОрдера.Ссылка.Дата >= &ДатаС
|		И	МаршрутныйЛистПриходныеОрдера.Ссылка.Дата < &ДатаДо
|		И	(
|					МаршрутныйЛистПриходныеОрдера.Ссылка = &CвязанныйМаршрутныйЛист
|				ИЛИ	(
|							МаршрутныйЛистПриходныеОрдера.Ссылка.СвязанСМаршрутнымЛистом = &ЭтотМаршрутныйЛист
|						И   &ЭтотМаршрутныйЛист <> ЗНАЧЕНИЕ(Документ.МаршрутныйЛист.ПустаяСсылка)
|					)
|			)
|ОБЪЕДИНИТЬ ВСЕ
|
|	ВЫБРАТЬ
|   	вт.МаршрутныйЛист,
|   	вт.ПриходныйОрдер,
|       вт.ДляСортировки
|
|	ИЗ вт
|;
|///////////////////////////////////////////////////////////
|УНИЧТОЖИТЬ вт
|";
	Запрос.Параметры.Вставить("Таблица", ЭтотОбъект.ПриходныеОрдера);
	Запрос.Параметры.Вставить("ЭтотМаршрутныйЛист", ЭтотОбъект.Ссылка);
	Запрос.Параметры.Вставить("CвязанныйМаршрутныйЛист", ЭтотОбъект.СвязанСМаршрутнымЛистом);
	Запрос.Параметры.Вставить("ДатаС", ЭтотОбъект.Дата - 86400 );
	Запрос.Параметры.Вставить("ДатаДо", ЭтотОбъект.Дата + 86400 );
	Запрос.Выполнить();
	Запрос.Параметры.Очистить();
	
КонецПроцедуры

//+++АК sole 2018.05.28 ИП-00018724.02
Процедура АК_CФормироватьТаблицуМаршрутныеЛистыСВесами(БПР)
	
	Перем Запрос;
	
	Запрос = БПР.Запрос;
	Запрос.Текст =
"ВЫБРАТЬ
|	втСписокПриходников.МаршрутныйЛист,
|   втСписокПриходников.ДляСортировки,
|	втСписокПриходников.МаршрутныйЛист.Номер,
|   СУММА(ЕСТЬNULL(ПриходныйОрдерСкладТовары.ЕдиницаИзмерения.Вес, 0)* ЕСТЬNULL(ПриходныйОрдерСкладТовары.Количество,0)) КАК Вес
|
|ИЗ втСписокПриходников
|	ВНУТРЕННЕЕ СОЕДИНЕНИЕ Документ.ПриходныйОрдерСклад.Товары КАК ПриходныйОрдерСкладТовары ПО
|			ПриходныйОрдерСкладТовары.Ссылка = втСписокПриходников.ПриходныйОрдер
|
|СГРУППИРОВАТЬ ПО
|	втСписокПриходников.МаршрутныйЛист,
|   втСписокПриходников.ДляСортировки
|
|УПОРЯДОЧИТЬ ПО
|   втСписокПриходников.ДляСортировки,
|   втСписокПриходников.МаршрутныйЛист.Номер
|
|";
	
	тзМаршрутныеЛистыСВесами = Запрос.Выполнить().Выгрузить();
	БПР.Вставить("тзМаршрутныеЛистыСВесами", тзМаршрутныеЛистыСВесами);	
	
КонецПроцедуры

//+++АК sole 2018.05.28 ИП-00018724.02
Процедура АК_ПодобратьТариф(БПР)
	
	Перем Запрос;
	
	Запрос = БПР.Запрос;
	Запрос.Текст =
"ВЫБРАТЬ
|	МАКСИМУМ(ТарифыНаДоставкуПоМаршрутуСрезПоследних.Период) КАК Период
|ИЗ РегистрСведений.ТарифыНаДоставкуПоМаршруту.СрезПоследних(&Дата, Маршрут = &Маршрут ) КАК ТарифыНаДоставкуПоМаршрутуСрезПоследних
|";
	
	Запрос.Параметры.Вставить("Дата", ЭтотОбъект.Дата);
	Запрос.Параметры.Вставить("Маршрут", ЭтотОбъект.МаршрутТранспортныхКомпаний);
	
	Выборка = Запрос.Выполнить().Выбрать();
	
	Если Выборка.Следующий() Тогда
		Период = Выборка.Период;	
	Иначе
		Период = Дата(1,1,1);
	КонецЕсли;
	
	Запрос.Текст =
"ВЫБРАТЬ
|	ТарифыНаДоставкуПоМаршруту.ВесОт,
|	ТарифыНаДоставкуПоМаршруту.ЕдиныйТариф,
|	ТарифыНаДоставкуПоМаршруту.ЦенаЗаКг,
|	ТарифыНаДоставкуПоМаршруту.Сумма,
|	ТарифыНаДоставкуПоМаршруту.ВариантРасчетаНДС,
|	ТарифыНаДоставкуПоМаршруту.СтавкаНДС,
|	ТарифыНаДоставкуПоМаршруту.СуммаНДС
|
|ИЗ РегистрСведений.ТарифыНаДоставкуПоМаршруту КАК ТарифыНаДоставкуПоМаршруту
|ГДЕ
|		ТарифыНаДоставкуПоМаршруту.Период = &Период
|	И	ТарифыНаДоставкуПоМаршруту.Маршрут = &Маршрут
|
|УПОРЯДОЧИТЬ ПО ТарифыНаДоставкуПоМаршруту.ВесОт УБЫВ
|";
	Запрос.Параметры.Вставить("Период", Период);	
	
	тзТарифы = Запрос.Выполнить().Выгрузить();
	
	Тариф = Неопределено;
	
	Для Каждого Стр Из тзТарифы Цикл
		
		Если Стр["ЕдиныйТариф"] Тогда
			Тариф = Стр;
			Прервать;
		КонецЕсли;
		
		Если Стр["ВесОт"] <= БПР.ОбщийВес Тогда
			Тариф = Стр;
			Прервать;
		КонецЕсли; 
	КонецЦикла;
	
	БПР.Вставить("Тариф", Тариф);
	
КонецПроцедуры

//+++АК sole 2018.05.28 ИП-00018724.02
Процедура АК_РассчитатьИЗаполнитьСуммыРейсов(БПР)
	
	//+++АК sole 2018.07.24 ИП-00019199
	Если БПР.Тариф.ЦенаЗаКг Тогда
		АК_РассчитатьИЗаполнитьСуммыРейсовТарифПоВесу(БПР);
	Иначе
		АК_РассчитатьИЗаполнитьСуммыРейсовЕдиныйТариф(БПР);
	КонецЕсли;
	//---АК sole 2018.07.24 ИП-00019199
	
КонецПроцедуры

//+++АК sole 2018.05.28 ИП-00018724.02
Процедура АК_РассчитатьИЗаполнитьСуммыРейсовЕдиныйТариф(БПР)
	
	Тариф = БПР.Тариф;
	тзМаршрутныеЛистыСВесами = БПР.тзМаршрутныеЛистыСВесами;
	
	Если БПР.ОбщийВес <> 0 Тогда		
		СуммаРейса = Тариф.Сумма;
		СуммаНДСРейса = Тариф.СуммаНДС;
	Иначе	
		СуммаРейса = 0;
		СуммаНДСРейса = 0;
	КонецЕсли;
	
	ОстатокСумма = СуммаРейса;
	ОстатокНДС = СуммаНДСРейса;
	
	Инд = 0;
	
	Пока Инд < тзМаршрутныеЛистыСВесами.Количество() - 1 Цикл
		
		Стр = тзМаршрутныеЛистыСВесами[Инд];
			
		Если БПР.ОбщийВес <> 0   Тогда
			КПВ = Стр["Вес"] / БПР.ОбщийВес;
		Иначе
			КПВ = 0;
		КонецЕсли;
		
		Сумма = Окр(СуммаРейса * КПВ, 2);
		СуммаНДС = Окр(СуммаНДСРейса * КПВ, 2);
		ОстатокСумма = ОстатокСумма - Сумма;
		ОстатокНДС = ОстатокНДС - СуммаНДС;
		
		АК_ЗаписатьСуммыВМаршрут(Стр["МаршрутныйЛист"], Сумма, СуммаНДС, БПР.РежимЗаписи);	
		
		Инд = Инд + 1;
	КонецЦикла;
	
	Стр = тзМаршрутныеЛистыСВесами[Инд];
	АК_ЗаписатьСуммыВМаршрут(Стр["МаршрутныйЛист"], ОстатокСумма, ОстатокНДС, БПР.РежимЗаписи);

КонецПроцедуры

//+++АК sole 2018.05.28 ИП-00018724.02
Процедура АК_РассчитатьИЗаполнитьСуммыРейсовТарифПоВесу(БПР)
	
	Тариф = БПР.Тариф;
	
	Для Каждого Стр Из БПР.тзМаршрутныеЛистыСВесами Цикл
		Сумма =	Стр["Вес"] * Тариф.Сумма;
		СуммаНДС = Стр["Вес"] * Тариф.СуммаНДС;
		АК_ЗаписатьСуммыВМаршрут(Стр["МаршрутныйЛист"], Сумма, СуммаНДС, БПР.РежимЗаписи)
	КонецЦикла;
	
КонецПроцедуры

//+++АК sole 2018.05.28 ИП-00018724.02
Процедура АК_ЗаписатьСуммыВМаршрут(МаршрутныйЛист, Сумма, СуммаНДС, РежимЗаписи)
	Если МаршрутныйЛист = ЭтотОбъект.Ссылка Тогда
		ЭтотОбъект.Сумма = Сумма; 
		ЭтотОбъект.СуммаНДС = СуммаНДС; 
		Возврат;
	КонецЕсли;
	
	оМаршрутныйЛист = МаршрутныйЛист.ПолучитьОбъект();
	оМаршрутныйЛист.Сумма = Сумма;
	оМаршрутныйЛист.СуммаНДС = СуммаНДС; 
	оМаршрутныйЛист.Записать(РежимЗаписи);
	Сообщить("Изменён документ """ + оМаршрутныйЛист + """, который является связанным с текущим документом.");
	
КонецПроцедуры
#КонецОбласти

#Область СлужебныеПроцедурыИФункции

//+++АК LATV 2018.06.14 ИП-00018971
Процедура ОтразитьДвиженияЗатратыНаДоставкуПоПоставщикам(Отказ)

	мДвиженияЗатраты = Движения.ЗатратыНаДоставкуПоПоставщикам;
	
	Если ВариантРасчетаНДС = Перечисления.ВариантыРасчетаНДС.НДСвТомЧисле
	 Или ВариантРасчетаНДС = Перечисления.ВариантыРасчетаНДС.БезНДС Тогда
		мСуммаВсего = Сумма;
	Иначе
		мСуммаВсего = Сумма + СуммаНДС;
	КонецЕсли;
	
	ТаблицаКПроведениюКонтрагенты = ПолучитьРаспределениеСуммыТранспортныхРасходов(мСуммаВсего, Истина, Истина);
	
	мОкругленнаяСумма = 0;
	Для Каждого СтрокаТаблицы Из ТаблицаКПроведениюКонтрагенты Цикл
		мОкругленнаяСумма = мОкругленнаяСумма + Окр(СтрокаТаблицы.Сумма, 2);
	КонецЦикла;
	
	РазницаПриОкруглении = мСуммаВсего - мОкругленнаяСумма;
	Если РазницаПриОкруглении <> 0 Тогда // разница при округлении - в последнюю строку
		ПоследняяСтрока = ТаблицаКПроведениюКонтрагенты[ТаблицаКПроведениюКонтрагенты.Количество() - 1];
		ПоследняяСтрока.Сумма = ПоследняяСтрока.Сумма + РазницаПриОкруглении;
	КонецЕсли;
	
	Для Каждого СтрокаТаблицы Из ТаблицаКПроведениюКонтрагенты Цикл
		Движение = мДвиженияЗатраты.Добавить();
		ЗаполнитьЗначенияСвойств(Движение, СтрокаТаблицы);
		Движение.Период = Дата;
	КонецЦикла;

КонецПроцедуры

//+++АК LATV 2018.06.14 ИП-00018971
Процедура ОтразитьДвиженияПоРегиструБухгалтерии(Отказ)

	ВыполнитьДвиженияПоРегиструБухгалтерии = Ложь;
	ДополнительныеСвойства.Свойство("ОтложенноеПроведение", ВыполнитьДвиженияПоРегиструБухгалтерии); // Для совместимости
	Если ВыполнитьДвиженияПоРегиструБухгалтерии <> Истина Тогда
		ВыполнитьДвиженияПоРегиструБухгалтерии = ДопМодульСервер.ПолучитьЗначениеПраваПользователя("ФормированиеДвиженийВРБУНепосредственно", Ложь);
	КонецЕсли;
	
	Если ВыполнитьДвиженияПоРегиструБухгалтерии Тогда
		ДвиженияДокумента = Документы.МаршрутныйЛист.ДвиженияДокумента(Ссылка);
		Если ДвиженияДокумента.Финансовый = Неопределено Тогда
			Отказ = Истина;
		КонецЕсли;
		
		Движения.Финансовый.Записывать = Истина;
		Движения.Финансовый.Загрузить(ДвиженияДокумента.Финансовый);
	Иначе
		РегистрыСведений.ОтложенныеДвиженияДокументовПоБухРегистру.ДобавитьДокументВОчередь(Ссылка, Отказ);
	КонецЕсли;

КонецПроцедуры

Процедура РассчитатьСуммуНДС(СуммаДокумента)
	
	мСуммаВключаетНДС = (ЭтотОбъект.ВариантРасчетаНДС = Перечисления.ВариантыРасчетаНДС.НДСвТомЧисле);
	Если ЭтотОбъект.ВариантРасчетаНДС = Перечисления.ВариантыРасчетаНДС.БезНДС Тогда
		ЭтотОбъект.СтавкаНДС = Перечисления.СтавкиНДС.БезНДС;
	КонецЕсли;
	ЭтотОбъект.СуммаНДС = УчетНДС.РассчитатьСуммуНДС(СуммаДокумента,  Истина, мСуммаВключаетНДС,
													УчетНДС.ПолучитьСтавкуНДС(ЭтотОбъект.СтавкаНДС));
     
					   
КонецПроцедуры

//+++АК LATV 2018.06.14 ИП-00018971
Функция ПолучитьРаспределениеСуммыТранспортныхРасходов(мСуммаВсего, СПоставщиками = Ложь, СХарактеристиками = Ложь)

	Возврат Документы.МаршрутныйЛист.ПолучитьРаспределениеСуммыТранспортныхРасходов(
		Дата, ПриходныеОрдера.ВыгрузитьКолонку("ПриходныйОрдер"), мСуммаВсего, СПоставщиками, СХарактеристиками);

КонецФункции

//+++АК LATV 2018.06.14 ИП-00018971
Функция НайтиПовторыПриходников()

	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("ТекущийДокумент"		, Ссылка);
	Запрос.УстановитьПараметр("МассивПриходников"	, ПриходныеОрдера.ВыгрузитьКолонку("ПриходныйОрдер"));
	
	Запрос.Текст =
		"ВЫБРАТЬ РАЗРЕШЕННЫЕ ПЕРВЫЕ 1
		|	МаршрутныйЛистПриходныеОрдера.Ссылка КАК Ссылка,
		|	МаршрутныйЛистПриходныеОрдера.Ссылка.Номер КАК Номер,
		|	МаршрутныйЛистПриходныеОрдера.Ссылка.Перевозчик КАК Перевозчик
		|ИЗ
		|	Документ.МаршрутныйЛист.ПриходныеОрдера КАК МаршрутныйЛистПриходныеОрдера
		|ГДЕ
		|	МаршрутныйЛистПриходныеОрдера.Ссылка.Проведен
		|	И МаршрутныйЛистПриходныеОрдера.ПриходныйОрдер В(&МассивПриходников)
		|	И НЕ МаршрутныйЛистПриходныеОрдера.Ссылка = &ТекущийДокумент";
	
	РезультатЗапроса = Запрос.Выполнить();
	Если РезультатЗапроса.Пустой() Тогда
		Возврат Неопределено;
	КонецЕсли;
	
	Выборка = РезультатЗапроса.Выбрать();
	Выборка.Следующий();
	Возврат Выборка;

КонецФункции

//+++АК sole 2018.05.29 ИП-00018724.02
Процедура АК_СнятьРеквизитСПроверки(ПроверяемыеРеквизиты, ИмяРекивизита)
	
	Перем ПроверяемыйРеквизит;
	
	ПроверяемыйРеквизит = ПроверяемыеРеквизиты.Найти(ИмяРекивизита);
	
	Если ЗначениеЗаполнено(ПроверяемыйРеквизит) Тогда
		ПроверяемыеРеквизиты.Удалить(ПроверяемыйРеквизит);	
	КонецЕсли; 
	
КонецПроцедуры

//+++АК sole 2018.05.22 ИП-00018724.01
Процедура АК_НайтиИРаспровестиСвязанныеПоступленияДопРасходов(Отказ)
	
	Перем Стр;
	
	Запрос = Новый Запрос();
	
	Запрос.Текст =
"ВЫБРАТЬ
|	ПоступлениеДопРасходовТранспортныеДокументы.Ссылка КАК ПоступлениеДопРасходов
|
|ИЗ Документ.ПоступлениеДопРасходов.ТранспортныеДокументы КАК ПоступлениеДопРасходовТранспортныеДокументы
|ГДЕ 
|		ПоступлениеДопРасходовТранспортныеДокументы.Ссылка.Проведен = Истина
|	И	ПоступлениеДопРасходовТранспортныеДокументы.Ссылка.Дата >= &ДатаРейса
|	И	ПоступлениеДопРасходовТранспортныеДокументы.Ссылка.ТранспортныеУслуги = Истина
|	И	ТИПЗНАЧЕНИЯ(ПоступлениеДопРасходовТранспортныеДокументы.Документ) = ТИП(Документ.МаршрутныйЛист)
|	И	ПоступлениеДопРасходовТранспортныеДокументы.Документ = &МаршрутныйЛист
|";
	
	Запрос.Параметры.Вставить("МаршрутныйЛист", ЭтотОбъект.Ссылка);
	Запрос.Параметры.Вставить("ДатаРейса", ЭтотОбъект.Дата);
	тзСписокПДР = Запрос.Выполнить().Выгрузить();
	
	Попытка	
	
		Для Каждого Стр Из тзСписокПДР Цикл
			оПоступлениеДопРасходов = Стр["ПоступлениеДопРасходов"].ПолучитьОбъект();
			оПоступлениеДопРасходов.Записать(РежимЗаписиДокумента.ОтменаПроведения);
		КонецЦикла;
	Исключение
		ОбщегоНазначения.СообщитьОбОшибке
		(
			"При отмене проведения связанного с текущим документом """ +  Стр["ПоступлениеДопРасходов"] + """ возникли ошибки!",
			Отказ
		);
		
		Возврат;
	КонецПопытки;
	
	Для Каждого Стр Из тзСписокПДР Цикл
		Сообщить("Связанный с текущим документом """ + Стр["ПоступлениеДопРасходов"]+ """ распроведён.");
	КонецЦикла;
	
КонецПроцедуры

//+++АК sole 2018.05.29 ИП-00018724.02
Процедура АК_ПроверитьРеквизитСвязанСМаршрутнымЛистом(Отказ)
	
	Если 
			ЭтотОбъект.СвязанСМаршрутнымЛистом <> Документы.МаршрутныйЛист.ПустаяСсылка()
		И	ЭтотОбъект.СвязанСМаршрутнымЛистом = ЭтотОбъект.Ссылка
	Тогда
	
		ОбщегоНазначения.СообщитьОбОшибке
		(
		    "Поле документа ""Связан с маршрутным листом"" не может ссылаться на этот же документ! Пожалуйста, либо очистите это поле, либо укажите в нём документ отличный от текущего!",
			Отказ
		);
	КонецЕсли;
КонецПроцедуры

//+++АК sole 2018.05.29 ИП-00018724.02
Процедура АК_НайтиИРаспровестиСвязанныйРейс(Отказ)
	
	Перем Запрос;
	Перем СвязанныйРейс;
	
	Если ЭтотОбъект.СвязанСМаршрутнымЛистом = Документы.МаршрутныйЛист.ПустаяСсылка() Тогда
		Запрос = Новый Запрос();
		Запрос.Текст =
"ВЫБРАТЬ
|	МаршрутныйЛист.Ссылка КАК МаршрутныйЛист
|
|ИЗ Документ.МаршрутныйЛист КАК МаршрутныйЛист
|ГДЕ
|		НЕ МаршрутныйЛист.ПометкаУдаления
|	И	МаршрутныйЛист.Дата >= &ДатаС
|	И	МаршрутныйЛист.Дата < &ДатаДо
|	И	МаршрутныйЛист.СвязанСМаршрутнымЛистом = &ЭтотМаршрутныйЛист
|	И   &ЭтотМаршрутныйЛист <> ЗНАЧЕНИЕ(Документ.МаршрутныйЛист.ПустаяСсылка)
|";	
		Запрос.Параметры.Вставить("ДатаС", ЭтотОбъект.Дата - 86400 );
		Запрос.Параметры.Вставить("ДатаДо", ЭтотОбъект.Дата + 86400 );
		Запрос.Параметры.Вставить("ЭтотМаршрутныйЛист", ЭтотОбъект.Ссылка);
	
		Выборка = Запрос.Выполнить().Выбрать();
		
		Если Выборка.Следующий() Тогда
			СвязанныйРейс = Выборка.МаршрутныйЛист;
		КонецЕсли;
	
	Иначе
		СвязанныйРейс = ЭтотОбъект.СвязанСМаршрутнымЛистом;
	КонецЕсли;	
	
	Если СвязанныйРейс = Неопределено Тогда
		Возврат;
	КонецЕсли;	
	
	оМаршрутныйЛист = СвязанныйРейс.ПолучитьОбъект();
	оМаршрутныйЛист.РаспроведениеИзСвязанногоРейса = Истина;
	
	Если оМаршрутныйЛист.ПометкаУдаления Тогда
		Возврат;
	КонецЕсли;
	
	ТекстСообщения = "Связанный рейс """ + оМаршрутныйЛист + """ ";
	                                                              
	Если ЭтотОбъект.ПометкаУдаления Тогда
		оМаршрутныйЛист.УстановитьПометкуУдаления(Истина);
		ТекстСообщения = ТекстСообщения + "помечен на удаление."
	Иначе
		оМаршрутныйЛист.Записать(РежимЗаписиДокумента.ОтменаПроведения);
		ТекстСообщения = ТекстСообщения + "распроведён."
	КонецЕсли;
	Сообщить(ТекстСообщения);
КонецПроцедуры

//+++АК sole 2018.06.29 ИП-00018321.01
Функция ПолучитьСуммуДокумента_ОсновнаяПоставка()
	
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("Организация"			, ЭтотОбъект.Организация);
	Запрос.УстановитьПараметр("МассивРасходников"	, ЭтотОбъект.РасходныеОрдера.ВыгрузитьКолонку("Документ"));
	Запрос.УстановитьПараметр("ДатаСреза"			, КонецДня(ЭтотОбъект.Дата));
	
	//+++АК sole 2018.04.24 ИП-00018321
	Запрос.УстановитьПараметр("Маршрут"				, ЭтотОбъект.Маршрут);	
	
	//+++АК sole 2018.06.14 ИП-00018944
	Запрос.Текст =
"ВЫБРАТЬ РАЗРЕШЕННЫЕ
|	РасходныйОрдерСклад.Получатель КАК Получатель
|ПОМЕСТИТЬ вт1
|ИЗ
|	Документ.РасходныйОрдерСклад КАК РасходныйОрдерСклад
|ГДЕ
|	РасходныйОрдерСклад.Ссылка В(&МассивРасходников)
|
|СГРУППИРОВАТЬ ПО
|	РасходныйОрдерСклад.Получатель
|;
|
|////////////////////////////////////////////////////////////////////////////////
|ВЫБРАТЬ РАЗРЕШЕННЫЕ
|	СУММА(ЕСТЬNULL(СтоимостьУслугПоДоставкеТовараНаТТСрезПоследних.Ставка, 0)) КАК Сумма,
|	СУММА(ВЫБОР
|			КОГДА СтоимостьУслугПоДоставкеТовараНаТТСрезПоследних.НаличиеДопТарифа
|				ТОГДА ЕСТЬNULL(СтоимостьУслугПоДоставкеТовараНаТТСрезПоследних.СтавкаДопТарифа, 0)
|			ИНАЧЕ 0
|		КОНЕЦ) КАК СуммаДопТарифа
|ИЗ
|	вт1 КАК вт1
|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.СтоимостьУслугПоДоставкеТовараНаТТ.СрезПоследних(&ДатаСреза, ) КАК СтоимостьУслугПоДоставкеТовараНаТТСрезПоследних
|		ПО (СтоимостьУслугПоДоставкеТовараНаТТСрезПоследних.ТТ = вт1.Получатель)
|			И (СтоимостьУслугПоДоставкеТовараНаТТСрезПоследних.Маршрут = &Маршрут)";	
	//---АК sole 2018.06.14 ИП-00018944
	
	Выборка = Запрос.Выполнить().Выбрать();
	
	Если Выборка.Следующий() Тогда
		чСумма = ?(ЗначениеЗаполнено(Выборка.Сумма), Выборка.Сумма, 0);
		чСуммаДопТарифа = ?(ЗначениеЗаполнено(Выборка.СуммаДопТарифа), Выборка.СуммаДопТарифа, 0);
	Иначе	
		чСумма = 0;
		чСуммаДопТарифа = 0;
	КонецЕсли;
	
	Рез = Новый Структура();	
	Рез.Вставить("Сумма", чСумма);
	Рез.Вставить("СуммаДопТарифа", чСуммаДопТарифа);
	
	Возврат Рез;
	//---АК sole 2018.04.24 ИП-00018321
КонецФункции                                

//+++АК sole 2018.06.29 ИП-00018321.01
Функция ПолучитьСуммуДокумента_Допоставка()
	
	Запрос = Новый Запрос;
	
	Запрос.Текст =
"ВЫБРАТЬ РАЗРЕШЕННЫЕ
|	РасходныйОрдерСклад.Получатель КАК ТорговаяТочка
|
|		ПОМЕСТИТЬ вт1
|
|ИЗ Документ.РасходныйОрдерСклад КАК РасходныйОрдерСклад
|ГДЕ
|		РасходныйОрдерСклад.Ссылка В (&МассивРасходников)
|
|СГРУППИРОВАТЬ ПО РасходныйОрдерСклад.Получатель
|;
|
|////////////////////////////////////////////////////////////////////////////////
|ВЫБРАТЬ РАЗРЕШЕННЫЕ
|	СУММА(ЦенаДопоставкиНаТТ.Сумма) КАК Сумма
|ИЗ вт1
|	ВНУТРЕННЕЕ СОЕДИНЕНИЕ РегистрСведений.ЦенаДопоставкиНаТТ КАК ЦенаДопоставкиНаТТ ПО
|			ЦенаДопоставкиНаТТ.Дата = &Дата
|		И	ЦенаДопоставкиНаТТ.Маршрут = &Маршрут
|		И	ЦенаДопоставкиНаТТ.ПричинаПеревозки = &ПричинаПеревозки
|		И	ЦенаДопоставкиНаТТ.ТорговаяТочка = вт1.ТорговаяТочка
|
|СГРУППИРОВАТЬ ПО ЦенаДопоставкиНаТТ.Маршрут
|";
	Запрос.УстановитьПараметр("МассивРасходников"	, ЭтотОбъект.РасходныеОрдера.ВыгрузитьКолонку("Документ"));
	Запрос.УстановитьПараметр("Дата"				, НачалоДня(ЭтотОбъект.Дата));
	Запрос.УстановитьПараметр("Маршрут"				, ЭтотОбъект.Маршрут);	
	Запрос.УстановитьПараметр("ПричинаПеревозки"	, ЭтотОбъект.ПричинаПеревозки);	
	
	чСумма = АК_Инструменты.ПолучитьРезультатСкалярногоЗароса(Запрос, 0);
	
	Рез = Новый Структура();	
	Рез.Вставить("Сумма", чСумма);
	Рез.Вставить("СуммаДопТарифа", 0);
	
	Возврат Рез;
КонецФункции

//+++АК sole 2018.06.28 ИП-00018321.01
Процедура СоздатьЗаписиВРегистреЦенаДопоставкиНаТТ_ЕслиНеобходимо()
	
	Если 
			ЭтотОбъект.ВидПеревозки <> Справочники.АК_ВидыПеревозки.ДоставкаНаТТ  
		Или	ЭтотОбъект.ПричинаПеревозки = Перечисления.ПричиныПеревозки.ОсновнаяПоставка
		Или	ЭтотОбъект.ПричинаПеревозки = Перечисления.ПричиныПеревозки.ПустаяСсылка()
	Тогда
		Возврат;
	КонецЕсли;
	
	УстановитьПривилегированныйРежим(Истина);
	
	НаборЗаписей = РегистрыСведений.ЦенаДопоставкиНаТТ.СоздатьНаборЗаписей();
	НаборЗаписей.Отбор.Дата.Установить(ЭтотОбъект.Дата);
	НаборЗаписей.Отбор.Маршрут.Установить(ЭтотОбъект.Маршрут);
	НаборЗаписей.Отбор.ПричинаПеревозки.Установить(ЭтотОбъект.ПричинаПеревозки);
	НаборЗаписей.Прочитать();
	
	слТорговыеТочки = Новый Соответствие();
	
	Для Каждого Запись Из НаборЗаписей Цикл
		слТорговыеТочки.Вставить(Запись.ТорговаяТочка, Истина);
	КонецЦикла;
	
	ШаблонЗаписи = Новый Структура();
	ШаблонЗаписи.Вставить("Дата", НачалоДня(ЭтотОбъект.Дата));
	ШаблонЗаписи.Вставить("Маршрут", ЭтотОбъект.Маршрут);
	ШаблонЗаписи.Вставить("ПричинаПеревозки", ЭтотОбъект.ПричинаПеревозки);
	ШаблонЗаписи.Вставить("АвторИзменений", Справочники.Пользователи.ПустаяСсылка());
	
	ПревКоличество = НаборЗаписей.Количество();
	
	Для Каждого Стр Из ЭтотОбъект.ТорговыеТочки Цикл
			
		Если слТорговыеТочки.Количество() <> 0 Тогда
						
			Если слТорговыеТочки.Получить(Стр["СтруктурнаяЕдиница"]) <> Неопределено Тогда
				Продолжить;
			КонецЕсли;
		КонецЕсли;
		
		Запись = НаборЗаписей.Добавить();
		ЗаполнитьЗначенияСвойств(Запись, ШаблонЗаписи);
		Запись.ТорговаяТочка = Стр["СтруктурнаяЕдиница"];
	КонецЦикла;
	
	Если НаборЗаписей.Количество() <> ПревКоличество Тогда
		НаборЗаписей.ЗаписыватьАвтораИзменений = Ложь;
		НаборЗаписей.Записать();	
	КонецЕсли;
	
	УстановитьПривилегированныйРежим(Ложь);
	
КонецПроцедуры

//+++АК sole 2018.07.30 ИП-00018320.04
Функция РейсОтносительноЗаявкиНеуникален()
	
	Перем Запрос, Результат;
	
	Результат = Ложь;
	
	Запрос = Новый Запрос();
	Запрос.Текст =
"ВЫБРАТЬ
|	ПРЕДСТАВЛЕНИЕ(МаршрутныйЛист.Ссылка) КАК МаршрутныйЛист
|
|ИЗ Документ.МаршрутныйЛист КАК МаршрутныйЛист
|ГДЕ
|		Не МаршрутныйЛист.ПометкаУдаления
|   И	ТИПЗНАЧЕНИЯ(МаршрутныйЛист.ДокументОснование) = ТИП(Документ.АК_ЗаявкаНаПеревозку)
|	И	МаршрутныйЛист.ДокументОснование = &ДокументОснование
|";
	Запрос.УстановитьПараметр("ДокументОснование", ЭтотОбъект.ДокументОснование);
	Выборка = Запрос.Выполнить().Выбрать();
	
	Пока Выборка.Следующий() Цикл
		Результат = Истина;
		Сообщить("На основании указанной заявки на перевозку в базе данных уже есть документ """ + Выборка.МаршрутныйЛист + """.");
	КонецЦикла;
	
	Возврат Результат;
КонецФункции

#КонецОбласти

РаспроведениеИзСвязанногоРейса = Ложь;

ПроверятьУникальностьРейсаОтносительноЗаявки = Истина;