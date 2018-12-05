﻿
&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	// Пропускаем инициализацию, чтобы гарантировать получение формы при передаче параметра "АвтоТест".
	Если Параметры.Свойство("АвтоТест") Тогда
		Возврат;
	КонецЕсли;
	
	ТекстВопроса = Параметры.ТекстВопроса;
	
КонецПроцедуры

&НаКлиенте
Процедура Вернуться(Команда)
	Закрыть("Вернуться");
КонецПроцедуры

&НаКлиенте
Процедура НеСохранять(Команда)
	Закрыть("НеСохранять");
КонецПроцедуры

&НаКлиенте
Процедура СохранитьИЗакончитьРедактирование(Команда)
	Закрыть("СохранитьИЗакончитьРедактирование");
КонецПроцедуры

&НаКлиенте
Процедура СохранитьИзменения(Команда)
	Закрыть("СохранитьИзменения");
КонецПроцедуры
