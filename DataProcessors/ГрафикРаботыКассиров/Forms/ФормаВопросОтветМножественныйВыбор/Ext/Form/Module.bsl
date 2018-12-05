﻿
&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Элементы.Надпись.Заголовок = "С " + Формат(Параметры.Период, "ДЛФ=D") + " торговая точка " + Параметры.ТорговаяТочка + " уже закреплена за " + Параметры.ФизическоеЛицо + "! Выполнить отвязку?";
	
КонецПроцедуры

&НаКлиенте
Процедура Оставить(Команда)
	Закрыть(Новый Структура("Оставить", Истина));
КонецПроцедуры

&НаКлиенте
Процедура ОставитьВСЕ(Команда)
	Закрыть(Новый Структура("ОставитьВсе", Истина));
КонецПроцедуры

&НаКлиенте
Процедура Отвязать(Команда)
	Закрыть(Новый Структура("Отвязать", Истина));
КонецПроцедуры

&НаКлиенте
Процедура ОтвязатьВСЕ(Команда)
	Закрыть(Новый Структура("ОтвязатьВсе", Истина));
КонецПроцедуры
