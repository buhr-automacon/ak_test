﻿
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Список.Параметры.УстановитьЗначениеПараметра("ТекущаяДата", ?(Не ЗначениеЗаполнено(Параметры.ТекущаяДата), ТекущаяДата(), Параметры.ТекущаяДата));
	Список.Параметры.УстановитьЗначениеПараметра("НаименованиеГруппы", Параметры.НаименованиеГруппы);
	
	Если ЗначениеЗаполнено(Параметры.ГоловноеПодразделение)Тогда
		
		Отбор = Список.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных")); 
		Отбор.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("ГоловноеПодразделение"); 
		Отбор.ВидСравнения = ВидСравненияКомпоновкиДанных.Равно; 
		Отбор.Использование = Истина; 
		Отбор.РежимОтображения = РежимОтображенияЭлементаНастройкиКомпоновкиДанных.БыстрыйДоступ;
		Отбор.ПравоеЗначение = Параметры.ГоловноеПодразделение;
		
	Иначе
		
		Элементы.СписокОтключитьОтбор.Доступность = Ложь;
		
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

#КонецОбласти

#Область ОбработчикиСобытийЭлементовСписка

&НаКлиенте
Процедура СписокВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	
	ТекДанные = Элементы.Список.ТекущиеДанные;
	Закрыть(ТекДанные.СтруктурнаяЕдиница);	
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура Выбрать(Команда)
	
	ТекДанные = Элементы.Список.ТекущиеДанные;
	Закрыть(ТекДанные.СтруктурнаяЕдиница);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаКлиенте
Процедура ОтключитьОтбор(Команда)
	
	Элементы.СписокОтключитьОтбор.Доступность = Ложь;
	
	ОчиститьОтборыНаСервере();
	
КонецПроцедуры

&НаСервере
Процедура ОчиститьОтборыНаСервере()
	
	Список.Отбор.Элементы.Очистить();
	
КонецПроцедуры

#КонецОбласти




