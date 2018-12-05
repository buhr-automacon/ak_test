﻿
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка) //+++АК mika 2018.09.14 ИП-00019442
	
	Если Параметры.Свойство("ОтборПоДате") Тогда
		
		//Отбор по сотруднику
		ЭлементОтбора = Список.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
		
		ЭлементОтбора.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("Сотрудник");
		ЭлементОтбора.ВидСравнения  = ВидСравненияКомпоновкиДанных.Равно;
		ЭлементОтбора.Использование = Истина;
		ЭлементОтбора.ПравоеЗначение  = Параметры.ОтборПоДате.Сотрудник;
		ЭлементОтбора.РежимОтображения = РежимОтображенияЭлементаНастройкиКомпоновкиДанных.БыстрыйДоступ;
		
		//Отбор по Дате
		ГруппаОтбора = Список.Отбор.Элементы.Добавить(Тип("ГруппаЭлементовОтбораКомпоновкиДанных"));
        ГруппаОтбора.ТипГруппы = ТипГруппыЭлементовОтбораКомпоновкиДанных.ГруппаИ;
		
	    ЭлементОтбора = ГруппаОтбора.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
		
		ЭлементОтбора.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("Приход");
		ЭлементОтбора.ВидСравнения  = ВидСравненияКомпоновкиДанных.БольшеИлиРавно;
		ЭлементОтбора.Использование = Истина;
		ЭлементОтбора.ПравоеЗначение  = НачалоДня(Параметры.ОтборПоДате.Период);
		ЭлементОтбора.РежимОтображения = РежимОтображенияЭлементаНастройкиКомпоновкиДанных.БыстрыйДоступ;

		ЭлементОтбора = ГруппаОтбора.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
		
		ЭлементОтбора.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("Приход");
		ЭлементОтбора.ВидСравнения  = ВидСравненияКомпоновкиДанных.МеньшеИлиРавно;
		ЭлементОтбора.Использование = Истина;
		ЭлементОтбора.ПравоеЗначение  = КонецДня(Параметры.ОтборПоДате.Период);
		ЭлементОтбора.РежимОтображения = РежимОтображенияЭлементаНастройкиКомпоновкиДанных.БыстрыйДоступ;

	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

