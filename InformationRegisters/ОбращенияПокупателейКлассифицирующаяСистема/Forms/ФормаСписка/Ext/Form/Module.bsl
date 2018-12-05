﻿&НаКлиенте
Перем мПоказатьДерево;


&НаСервере
Процедура ПакетВДеревоНаСервере(id_OK, GUID_Загрузки, ДатаДок)
	запись = РегистрыСведений.ОбращенияПокупателейКлассифицирующаяСистема.СоздатьМенеджерЗаписи();
	запись.id_OK = id_OK;
	запись.GUID_Загрузки = GUID_Загрузки;
	запись.ДатаДок = ДатаДок;
	
	запись.Прочитать();
	
	Данные = запись.ОтветКлассифицирующейСистемы.Получить();
	
	СтрокуВДеревоНаСервере(Данные);	
КонецПроцедуры

&НаСервере
Процедура СтрокуВДеревоНаСервере(Данные)		
	ДеревоДанных.ПолучитьЭлементы().Очистить();
		
	Попытка	
		ДобавитьУзелВДерево(ДеревоДанных, "Данные", Данные);		
	Исключение
	    Ошибка = ОписаниеОшибки();
		Сообщение = Новый СообщениеПользователю;
		Сообщение.Текст = Ошибка;
		Сообщение.Сообщить();
	КонецПопытки;	
КонецПроцедуры

&НаСервере
Функция ДобавитьУзелВДерево(Родитель, Ключ, Значение)
	Узел = Родитель.ПолучитьЭлементы().Добавить();
	Узел.Ключ = Ключ;
	Узел.Значение = Значение;
	
	Если ТипЗнч(Значение) = Тип("Структура") Тогда	
		Для каждого КлючЗначение Из Значение Цикл
			ДобавитьУзелВДерево(Узел, КлючЗначение.Ключ, КлючЗначение.Значение);
		КонецЦикла;
	ИначеЕсли ТипЗнч(Значение) = Тип("Массив") Тогда
	    Для е = 0 По Значение.Количество() - 1 Цикл
			ДобавитьУзелВДерево(Узел, "[" + е + "]", Значение[е]);
		КонецЦикла;
	КонецЕсли;
КонецФункции

&НаКлиенте
Процедура СписокПриАктивизацииСтроки(Элемент)
		Если мПоказатьДерево = Ложь Тогда
		Возврат;
	КонецЕсли;
	
	мПоказатьДерево = Ложь;
	
	ПодключитьОбработчикОжидания("ПоказатьДерево", 1, Истина);	
КонецПроцедуры

&НаКлиенте
Процедура ПоказатьДерево() Экспорт 
	тд = Элементы.Список.ТекущиеДанные;
	
	Попытка	
		ПакетВДеревоНаСервере(тд.id_OK, тд.GUID_Загрузки, тд.ДатаДок);	
	Исключение
	
	КонецПопытки;
	
	мПоказатьДерево = Истина;
КонецПроцедуры


&НаКлиенте
Процедура ОткрытьФормуПараметры(Команда)
	ОткрытьФорму("РегистрСведений.ОбращенияПокупателейКлассифицирующаяСистема.Форма.ФормаПараметры");
КонецПроцедуры

