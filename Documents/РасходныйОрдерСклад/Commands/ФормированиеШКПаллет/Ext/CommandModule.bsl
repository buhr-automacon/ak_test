﻿
&НаКлиенте
Процедура ОбработкаКоманды(ПараметрКоманды, ПараметрыВыполненияКоманды)
	
	Если ТипЗнч(ПараметрКоманды) <> Тип("Массив") Тогда
		МассивДоки = Новый Массив();
		МассивДоки.Добавить(ПараметрКоманды);
	Иначе
		МассивДоки = ПараметрКоманды;
	КонецЕсли;
	ОткрытьФорму("Обработка.ФормированиеШтрихКодаПаллеты.Форма.Форма", Новый Структура("МассивРасходники", МассивДоки));
	
КонецПроцедуры
