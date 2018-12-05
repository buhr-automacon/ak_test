﻿
Процедура УстановитьВидимостьЭлементов()
	
	Счет41 = (Запись.Счет = ПланыСчетов.Финансовый.Товары
				ИЛИ Запись.Счет = ПланыСчетов.Финансовый.МатералыДляВыпуска);
		
	Элементы.СтатьяДоходовРасходов.Видимость 	= НЕ Счет41;
	Элементы.ЦФО.Видимость 						= НЕ Счет41;
	Элементы.СтруктурнаяЕдиница.Видимость 		= НЕ Счет41;
	Элементы.СтатьяДвиженияТоваров41.Видимость 	= Счет41;
	
КонецПроцедуры

Процедура ПроверитьДоступностьПериода(мПериод, мОрганизация, Отказ)
	
	НаборЗаписей = РегистрыСведений.НастройкаОтраженияОперацийВУчете.СоздатьНаборЗаписей();
	НаборЗаписей.Отбор.Период.Установить(мПериод, Истина);
	//+++АК Susk (Суслин К.В.) 2018.12.04 ИП-00020497	 
	НаборЗаписей.Отбор.Организация.Установить(мОрганизация, Истина);
	//---АК Susk (Суслин К.В.) 
	НаборЗаписей.Прочитать();
	
	НастройкаПравДоступа.ПередЗаписьюРегистраСведенийПроверкаДоступностиПериода(НаборЗаписей, Отказ, Неопределено);
	
КонецПроцедуры


&НаКлиенте
Процедура ПередЗаписью(Отказ, ПараметрыЗаписи)
	
	//
	//+++АК Susk (Суслин К.В.) 2018.12.04 ИП-00020497	 
	//ПроверитьДоступностьПериода(ЭтаФорма.Запись.Период, Отказ);
	ПроверитьДоступностьПериода(ЭтаФорма.Запись.Период, Запись.Организация, Отказ);
	//---АК Susk (Суслин К.В.) 
	
КонецПроцедуры

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	УстановитьВидимостьЭлементов();
	
КонецПроцедуры


&НаКлиенте
Процедура СчетПриИзменении(Элемент)
	
	УстановитьВидимостьЭлементов();
	
КонецПроцедуры
