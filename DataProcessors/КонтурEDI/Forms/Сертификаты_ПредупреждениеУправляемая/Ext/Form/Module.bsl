﻿
&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	ЗаполнитьСписокСертификатов();	
	
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьСписокСертификатов()

	Для каждого Строка Из Параметры.МассивСертификатов Цикл
	
		НоваяСтрока = СписокСертификатов.Добавить();
		ЗаполнитьЗначенияСвойств(НоваяСтрока, Строка); 	
	
	КонецЦикла;
	
КонецПроцедуры

&НаКлиенте
Процедура НадписьТелефонУЦНажатие(Элемент)
	
	ЗапуститьПриложение("callto:+78005000508");
	
КонецПроцедуры

&НаКлиенте
Процедура НадписьТелефонТПEDIНажатие(Элемент)
	
	ЗапуститьПриложение("callto:+78005003351");
	
КонецПроцедуры
