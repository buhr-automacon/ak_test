﻿
&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если ЭтаФорма.Параметры.Свойство("п_Дата") Тогда
		Запись.Дата 			= ЭтаФорма.Параметры.п_Дата;
	КонецЕсли;
	Если ЭтаФорма.Параметры.Свойство("п_ТорговаяТочка") Тогда
		Запись.ТорговаяТочка 	= ЭтаФорма.Параметры.п_ТорговаяТочка;
	КонецЕсли;
	Если ЭтаФорма.Параметры.Свойство("п_Номенклатура") Тогда
		Запись.Номенклатура 	= ЭтаФорма.Параметры.п_Номенклатура;
	КонецЕсли;
	Если ЭтаФорма.Параметры.Свойство("п_Количество") Тогда
		Запись.Количество 		= ЭтаФорма.Параметры.п_Количество;
	КонецЕсли;
	
КонецПроцедуры
