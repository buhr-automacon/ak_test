﻿
Процедура ПриЗаписи(Отказ, Замещение)
	
	Попытка 
		
		Запрос = Новый Запрос("ВЫБРАТЬ
		|	КОЛИЧЕСТВО(ОчередиСообщенийОбменаСМобильнымиКлиентами.НомерСообщения) КАК КоличествоСообщений
		|ИЗ
		|	РегистрСведений.ОчередиСообщенийОбменаСМобильнымиКлиентами КАК ОчередиСообщенийОбменаСМобильнымиКлиентами
		|ГДЕ
		|	ОчередиСообщенийОбменаСМобильнымиКлиентами.МобильныйКлиент = &МобильныйКлиент");
		
		Запрос.УстановитьПараметр("МобильныйКлиент", ЭтотОбъект.Отбор.МобильныйКлиент.Значение);
		
		Выборка = Запрос.Выполнить().Выбрать();

		КоличествоЗаписей = 0;	
		Если Выборка.Следующий() Тогда
			КоличествоЗаписей = Выборка.КоличествоСообщений;
		КонецЕсли;   

		ОбменМобильноеПриложениеПереопределяемый.ДобавитьЗаписьВЖурналОбмена(ЭтотОбъект.Отбор.МобильныйКлиент.Значение,  "Количество сообщений в очереди " + КоличествоЗаписей);	
	
	Исключение
	КонецПопытки; 


//	Попытка 

//		ВедетсяЛогПоУзлу = ЭтотОбъект.Отбор.МобильныйКлиент.Значение.ВестиЛогОбмена;

//		Если ВедетсяЛогПоУзлу Тогда

//			Для Каждого Запись Из ЭтотОбъект Цикл
//				МЗ = РегистрыСведений.МП_КопияОчередиСообщенийОбменаСМобильнымиКлиентами.СоздатьМенеджерЗаписи();

//				ЗаполнитьЗначенияСвойств(МЗ, Запись);

//				МЗ.Записать();
//			КонецЦикла;  

//		КонецЕсли; 
//		
//	Исключение
//	КонецПопытки; 

КонецПроцедуры
