﻿
&НаКлиенте
Процедура ОбработкаКоманды(ПараметрКоманды, ПараметрыВыполненияКоманды)
	//{{_КОНСТРУКТОР_ПЕЧАТИ(Приказ)
	ТабДок = Новый ТабличныйДокумент;
	ПечатьСписаниеОС(ТабДок, ПараметрКоманды);

	ТабДок.ОтображатьСетку = Ложь;
	ТабДок.Защита = Ложь;
	ТабДок.ТолькоПросмотр = Ложь;
	ТабДок.ОтображатьЗаголовки = Ложь;
	ТабДок.Показать();
	//}}
КонецПроцедуры

&НаСервере
Процедура ПечатьСписаниеОС(ТабДок, ПараметрКоманды)
	Документы.СписаниеОС.ПечатьСписаниеОС(ТабДок, ПараметрКоманды);
КонецПроцедуры
