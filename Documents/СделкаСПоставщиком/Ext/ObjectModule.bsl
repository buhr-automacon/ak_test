﻿
Процедура ОбработкаПроведения(Отказ, Режим)
	//{{__КОНСТРУКТОР_ДВИЖЕНИЙ_РЕГИСТРОВ
	// Данный фрагмент построен конструктором.
	// При повторном использовании конструктора, внесенные вручную изменения будут утеряны!!!

	// регистр РасчетыПоСделкамСПоставщиками Приход
	Движения.РасчетыПоСделкамСПоставщиками.Записывать = Истина;
	Движения.РасчетыПоСделкамСПоставщиками.Очистить();
	Движения.ТоварыККомплектацииСделокСПоставщиками.Записывать = Истина;
	Движения.ТоварыККомплектацииСделокСПоставщиками.Очистить();
	//+++АК POZM 2018.06.07 ИП-00018682 
	Если ЭтотОбъект.Акцептовано Тогда
	//---АК POZM 
		Для Каждого ТекСтрокаГрафикОплат Из ГрафикОплат Цикл
			Если Не БезОплаты Тогда
				Движение = Движения.РасчетыПоСделкамСПоставщиками.Добавить();
				Движение.ВидДвижения = ВидДвиженияНакопления.Приход;
				Движение.Период = Дата;
				Движение.Сделка = Ссылка;
				Движение.УИН_Этапа = ТекСтрокаГрафикОплат.УИН_Строки;
				Движение.Сумма = ТекСтрокаГрафикОплат.СуммаОплаты;
				Движение.ДатаПлатежа=ТекСтрокаГрафикОплат.ДатаПлатежа;
				//Если ЭтотОбъект.Дата >= Дата(2017,8,14) Тогда
				//	Если ЗначениеЗаполнено(ТекСтрокаГрафикОплат.ДатаПлатежа) Тогда
				//		Движение.СуммаРегл=ТекСтрокаГрафикОплат.СуммаОплаты;
				//		//Движение.УИН_Этапа="";
				//	КонецЕсли;
				//КонецЕсли;
			КонецЕсли;	
			
			Если ТекСтрокаГрафикОплат.НомерСтрокиГрафика=1 Тогда
				Движение = Движения.ТоварыККомплектацииСделокСПоставщиками.Добавить();
				Движение.ВидДвижения = ВидДвиженияНакопления.Приход;
				Движение.Период = Дата;
				Движение.Сделка = Ссылка;
				Движение.УИН_Этапа = ТекСтрокаГрафикОплат.УИН_Строки;
				Движение.Номенклатура = ТекСтрокаГрафикОплат.Номенклатура;
				Движение.Количество = ТекСтрокаГрафикОплат.Количество;
			
			
				Если ЗначениеЗаполнено(ТекСтрокаГрафикОплат.СтруктурнаяЕдиница) И НЕ ТекСтрокаГрафикОплат.СтруктурнаяЕдиница.Код="ЦФО_100"  Тогда
					Движение = Движения.ТоварыККомплектацииСделокСПоставщиками.Добавить();
					Движение.ВидДвижения = ВидДвиженияНакопления.Расход;
					Движение.Период = Дата;
					Движение.Сделка = Ссылка;
					Движение.УИН_Этапа = ТекСтрокаГрафикОплат.УИН_Строки;
					Движение.Номенклатура = ТекСтрокаГрафикОплат.Номенклатура;
					Движение.Количество = ТекСтрокаГрафикОплат.Количество;
				КонецЕсли;	
	        КонецЕсли;
		КонецЦикла;
	КонецЕсли;	

	//}}__КОНСТРУКТОР_ДВИЖЕНИЙ_РЕГИСТРОВ
КонецПроцедуры

Процедура ПередЗаписью(Отказ, РежимЗаписи, РежимПроведения)
	Резерв=Справочники.СтруктурныеЕдиницы.НайтиПоКоду("ЦФО_100");
	Для Каждого ТекСтрокаГрафикОплат Из ГрафикОплат Цикл
		Если Не ЗначениеЗаполнено(ТекСтрокаГрафикОплат.СтруктурнаяЕдиница) Тогда
			ТекСтрокаГрафикОплат.СтруктурнаяЕдиница=Резерв;
		КонецЕсли;	
	КонецЦикла;	
	
	СуммаСделки=ГрафикОплат.Итог("СуммаОплаты");
	
КонецПроцедуры

Процедура ПриКопировании(ОбъектКопирования)
	ЭтотОбъект.Акцептовано = Ложь;
КонецПроцедуры
