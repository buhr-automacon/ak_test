﻿////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ ФОРМЫ

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	УстановитьВидимостьСтраницНаСервере();
	//ДанныеФ = ДанныеФормыВЗначение(Параметры, Тип("Структура"));
	СтрукПараметры=Параметры.СтрукПараметры;
	
	Для каждого Эл Из СтрукПараметры Цикл
	    Попытка
		    ЭтаФорма[Эл.Ключ]=Эл.Значение;
		Исключение
		КонецПопытки;
	КонецЦикла; 
КонецПроцедуры

&НаСервере
Процедура УстановитьВидимостьСтраницНаСервере()
	
	// т.к. Расшифровка платежа теперь есть у многих видов операций,
	// сначала отработаем формы-исключения
	//МассивСтраниц = Новый Массив;
	//МассивСтраниц.Добавить(Элементы.ГруппаИнкассация);
	//МассивСтраниц.Добавить(Элементы.ГруппаПокупкаВалюты);
	//МассивСтраниц.Добавить(Элементы.ГруппаПродажаВалюты);
	//МассивСтраниц.Добавить(Элементы.ГруппаПлатежПрочие);
	//МассивСтраниц.Добавить(Элементы.ГруппаПлатежныеКарты);
	//МассивСтраниц.Добавить(Элементы.ГруппаРасчетыСКонтрагентами);
	//МассивСтраниц.Добавить(Элементы.ГруппаВозвратЗаймаРаботником);
	//
	//Если Объект.ВидОперации = Перечисления.ВидыОперацийПоступлениеДенежныхСредств.Инкассация Тогда
	//	Элементы.ГруппаСтраницы.ТекущаяСтраница = Элементы.ГруппаИнкассация;
	//ИначеЕсли Объект.ВидОперации = Перечисления.ВидыОперацийПоступлениеДенежныхСредств.ПриобретениеИностраннойВалюты Тогда
	//	Элементы.ГруппаСтраницы.ТекущаяСтраница = Элементы.ГруппаПокупкаВалюты;
	//ИначеЕсли Объект.ВидОперации = Перечисления.ВидыОперацийПоступлениеДенежныхСредств.ПоступленияОтПродажиИностраннойВалюты Тогда
	//	Элементы.ГруппаСтраницы.ТекущаяСтраница = Элементы.ГруппаПродажаВалюты;
	//ИначеЕсли Объект.ВидОперации = Перечисления.ВидыОперацийПоступлениеДенежныхСредств.ПрочееПоступление Тогда
		Элементы.ГруппаСтраницы.ТекущаяСтраница = Элементы.ГруппаПлатежПрочие;
	//ИначеЕсли Объект.ВидОперации = Перечисления.ВидыОперацийПоступлениеДенежныхСредств.ПоступленияОтПродажПоПлатежнымКартамИБанковскимКредитам Тогда
	//	Элементы.ГруппаСтраницы.ТекущаяСтраница = Элементы.ГруппаПлатежныеКарты;
	//ИначеЕсли Объект.ВидОперации = Перечисления.ВидыОперацийПоступлениеДенежныхСредств.ВозвратЗаймаРаботником Тогда
	//	Элементы.ГруппаСтраницы.ТекущаяСтраница = Элементы.ГруппаВозвратЗаймаРаботником;
	//
	//// а затем тех, кто использует основную форму Расшифровки платежа
	//ИначеЕсли ЕстьРасшифровкаПлатежа(Объект.ВидОперации) Тогда
	//	Элементы.ГруппаСтраницы.ТекущаяСтраница = Элементы.ГруппаРасчетыСКонтрагентами;
	//КонецЕсли;
	//
	//Для каждого ТекСтраница Из МассивСтраниц Цикл
	//	Если ТекСтраница <> Элементы.ГруппаСтраницы.ТекущаяСтраница Тогда
	//		Если ТекСтраница.Видимость Тогда
	//			ТекСтраница.Видимость = Ложь;
	//		КонецЕсли;
	//	Иначе
	//		Если НЕ ТекСтраница.Видимость Тогда
	//			ТекСтраница.Видимость = Истина;
	//		КонецЕсли;
	//	КонецЕсли;
	//КонецЦикла;
	
КонецПроцедуры
