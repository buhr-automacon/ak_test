﻿
&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	Если не УправлениеДопПравамиПользователей.ПолучитьПравоПользователяУпр(ПланыВидовХарактеристик.ПраваПользователей.РазрешеныЛюбыеОперацииСЧекЛистом, Ложь) Тогда 
		ЭтаФорма.ТолькоПросмотр = Истина;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура СписокПередНачаломДобавления(Элемент, Отказ, Копирование, Родитель, Группа, Параметр)
	
	Если Копирование = Истина Тогда 
		Сообщить("Добавление настройки копированием запрещено.");
		Отказ = Истина;
	КонецЕсли;
	
КонецПроцедуры
