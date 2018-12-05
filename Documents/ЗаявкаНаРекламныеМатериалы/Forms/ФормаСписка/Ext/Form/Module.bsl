﻿
&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	ЗаявкиТолькоПоМоимМагазинам = УправлениеПользователями.ПолучитьЗначениеПоУмолчанию(ПараметрыСеанса.ТекущийПользователь, "ОтображатьЗаявкиНаРеклМатериалыТолькоСвоиМагазины");
	
	Список.Параметры.УстановитьЗначениеПараметра("ТекущаяДата", ТекущаяДата());
	Список.Параметры.УстановитьЗначениеПараметра("Сотрудник", ПараметрыСеанса.ТекущийПользователь);
	Список.Параметры.УстановитьЗначениеПараметра("ОтборТолькоПоСвоим", ЗаявкиТолькоПоМоимМагазинам);
	
КонецПроцедуры

&НаКлиенте
Процедура ЗаявкиТолькоПоМоимМагазинамПриИзменении(Элемент)
	
	Список.Параметры.УстановитьЗначениеПараметра("ОтборТолькоПоСвоим", ЗаявкиТолькоПоМоимМагазинам);
	Элементы.Список.Обновить();
	
КонецПроцедуры

&НаСервере
Процедура ПриЗакрытииНаСервере()
	
	УправлениеПользователями.УстановитьЗначениеПоУмолчанию(ПараметрыСеанса.ТекущийПользователь, "ОтображатьЗаявкиНаРеклМатериалыТолькоСвоиМагазины", ЗаявкиТолькоПоМоимМагазинам);
	
КонецПроцедуры

&НаКлиенте
Процедура ПриЗакрытии()
	ПриЗакрытииНаСервере();
КонецПроцедуры
