﻿
&НаКлиенте
Процедура Выбрать(Команда)
	
	ТекДанные = Элементы.Список.ТекущиеДанные;
	Закрыть(ТекДанные.ФизЛицо);
	
КонецПроцедуры

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Список.Параметры.УстановитьЗначениеПараметра("ФизЛицо", Параметры.ТекущийПомощник);
	
	// Открытие из формы передачи помощнику ТТ
	Если Параметры.Адрес <> "" Тогда
		
		СписокЗначений = Новый СписокЗначений;
		СписокЗначений.ЗагрузитьЗначения(ПолучитьИзВременногоХранилища(Параметры.Адрес).ВыгрузитьКолонку("Значение"));
		
		Отбор = Список.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных")); 
		Отбор.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("ФизЛицо"); 
		Отбор.ВидСравнения = ВидСравненияКомпоновкиДанных.ВСписке; 
		Отбор.Использование = Истина; 
		Отбор.РежимОтображения = РежимОтображенияЭлементаНастройкиКомпоновкиДанных.БыстрыйДоступ;
		Отбор.ПравоеЗначение = СписокЗначений;
		
	Иначе
		
		//mind попросил Валера отключить
		//Отбор = Список.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных")); 
		//Отбор.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("ЦФО"); 
		//Отбор.ВидСравнения = ВидСравненияКомпоновкиДанных.Равно; 
		//Отбор.Использование = Истина; 
		//Отбор.РежимОтображения = РежимОтображенияЭлементаНастройкиКомпоновкиДанных.БыстрыйДоступ;
		//Отбор.ПравоеЗначение = Параметры.ЦФО;
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура СписокВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	ТекДанные = Элементы.Список.ТекущиеДанные;
	Закрыть(ТекДанные.ФизЛицо);	
	
КонецПроцедуры

&НаКлиенте
Процедура ОтключитьОтбор(Команда)
	
	Элементы.СписокОтключитьОтбор.Доступность = Ложь;
	ОчиститьОтборыНаСервере();
	
КонецПроцедуры

&НаСервере
Процедура ОчиститьОтборыНаСервере()
	
	Список.Отбор.Элементы.Очистить();
	
КонецПроцедуры
