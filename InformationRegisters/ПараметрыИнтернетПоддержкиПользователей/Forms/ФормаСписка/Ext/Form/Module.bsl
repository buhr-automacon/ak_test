﻿
////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ ТАБЛИЦЫ ФОРМЫ Список

&НаКлиенте
Процедура СписокВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
КонецПроцедуры

&НаКлиенте
Процедура СписокПередНачаломИзменения(Элемент, Отказ)
	
	Отказ = Истина;
	
КонецПроцедуры

&НаКлиенте
Процедура СписокПередНачаломДобавления(Элемент, Отказ, Копирование, Родитель, Группа)
	
	Отказ = Истина;
	
КонецПроцедуры


&НаКлиенте
Процедура ИзменитьПараметры(Команда)
	
	ОткрытьФорму("РегистрСведений.ПараметрыИнтернетПоддержкиПользователей.Форма.ФормаВводаПараметровИПП",, ЭтаФорма);
	
КонецПроцедуры


&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	
	Если ИмяСобытия = "ВводПараметровАутентификации" Тогда
		Элементы.Список.Обновить();	
	КонецЕсли;
	
КонецПроцедуры

