﻿&НаСервере
Функция Печать(ПараметрКоманды)
	
	Возврат обработки.АК_ПечатьТТН.ПечатьТ1(ПараметрКоманды);
	
КонецФункции


&НаКлиенте
Процедура ОбработкаКоманды(ПараметрКоманды, ПараметрыВыполненияКоманды)
	
	ТабДок = Печать(ПараметрКоманды);

  	Если ТабДок = Неопределено Тогда
		Возврат;
	КонецЕсли;

	ТабДок.ОтображатьСетку 		= Ложь;
	ТабДок.Защита 				= Ложь;
	ТабДок.ТолькоПросмотр 		= Истина;
	ТабДок.ОтображатьЗаголовки 	= Ложь;
	
	ТабДок.Показать("Печать ТТН (форма 1-Т)");
	
КонецПроцедуры
