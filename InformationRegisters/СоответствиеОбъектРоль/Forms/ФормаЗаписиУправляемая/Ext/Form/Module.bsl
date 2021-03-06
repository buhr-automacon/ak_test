﻿
&НаКлиенте
Процедура ПослеЗаписи(ПараметрыЗаписи)
	
	Оповестить("СоответствиеОбъектРоль.Изменен");
	
КонецПроцедуры

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если ЗначениеЗаполнено(Параметры.Объект) Тогда
		Запись.Объект = Параметры.Объект;
	КонецЕсли;
	
	Если ЗначениеЗаполнено(Параметры.ТипРоли) Тогда
		Запись.ТипРоли = Параметры.ТипРоли;
	КонецЕсли;
	Если Параметры.Свойство("ОграничитьДоступность") Тогда
		Элементы.ТипРоли.ТолькоПросмотр=Истина;
		Элементы.Номенклатура.ТолькоПросмотр=Истина;
		Элементы.Период.ТолькоПросмотр=Истина;
	
	КонецЕсли; 
	
КонецПроцедуры
