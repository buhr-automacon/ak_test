﻿
Процедура ПередЗаписью(Отказ)
	
	Если НЕ ЗначениеЗаполнено(ЭтотОбъект.ИД) Тогда
		ЭтотОбъект.ИД = ОбщегоНазначенияСервер.ПолучитьНовыйУникальныйИдентификатор("ОписаниеАкцийДляСайта", "ИД");
	КонецЕсли;
	
КонецПроцедуры
