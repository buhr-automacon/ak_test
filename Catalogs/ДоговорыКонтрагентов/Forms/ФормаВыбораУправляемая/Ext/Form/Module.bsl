﻿&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	//+++АК LAGP 2018.10.22 ИП-00018465 Отборы для тонкого клиента при вызове из Реализации товаров и услуг
	Если Параметры.Свойство("Отбор") Тогда
		Отбор = Список.Отбор.Элементы;	
		Для Каждого ЭлементСтруктуры Из Параметры.Отбор Цикл 						
			ИмяОтбора = ЭлементСтруктуры.Ключ;			
			НастройкаОтбора = ЭлементСтруктуры.Значение;
			
			ЭлементОтбора = Отбор.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));					
			ЭлементОтбора.ИдентификаторПользовательскойНастройки = ИмяОтбора;						
			ЭлементОтбора.Представление = ИмяОтбора;	
			ЭлементОтбора.ПредставлениеПользовательскойНастройки = ИмяОтбора;				
			ЭлементОтбора.Использование = Истина;		
			ЭлементОтбора.ВидСравнения = НастройкаОтбора.ВидСравнения;		
			ЭлементОтбора.ЛевоеЗначение = НастройкаОтбора.ЛевоеЗначение;		
			ЭлементОтбора.ПравоеЗначение = НастройкаОтбора.ПравоеЗначение;
			ЭлементОтбора.РежимОтображения = НастройкаОтбора.РежимОтображения;
		КонецЦикла;
	КонецЕсли;	
	//---АК LAGP
	
КонецПроцедуры
