﻿
&НаКлиенте
Процедура ОбработкаКоманды(ПараметрКоманды, ПараметрыВыполненияКоманды)
	ОбработкаКомандыНаСервере(ПараметрКоманды);
	Оповестить("УдалилиЗаданияВРО",ПараметрКоманды);
КонецПроцедуры

&НаСервере
Процедура ОбработкаКомандыНаСервере(ПараметрКоманды)
	Документы.ЗаданиеНаРазборку.УдалитьЗаданиеИзРО(ПараметрКоманды);
КонецПроцедуры

