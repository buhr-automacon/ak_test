﻿
&НаКлиенте
Процедура Сохранить(Команда)
	
	Если Не ПроверитьЗаполнение()Тогда
		Возврат;
	КонецЕсли;
	
	Если НачалоПериода < НачалоГрафика Тогда
		Предупреждение("Начало периода не должно быть меньше " + Формат(НачалоГрафика, "ДФ=dd.MM.yyyy"));
		Возврат;
	КонецЕсли;
	
	Если КонецПериода > КонецГрафика Тогда
		Предупреждение("Окончание периода не должно быть больше " + Формат(КонецГрафика, "ДФ=dd.MM.yyyy"));
		Возврат;
	КонецЕсли;
	
	ДанныеКопирования = Новый Структура("ФизическоеЛицо, НачалоПериода, КонецПериода", ФизическоеЛицо, НачалоПериода, КонецПериода);
	Закрыть(ДанныеКопирования);
	
КонецПроцедуры

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	ФизическоеЛицо = Параметры.ФизическоеЛицо;
	НачалоПериода  = Параметры.НачалоПериода;
	НачалоГрафика  = Параметры.НачалоПериода;
	КонецПериода   = Параметры.КонецПериода;
	КонецГрафика   = Параметры.КонецПериода;
	
КонецПроцедуры
