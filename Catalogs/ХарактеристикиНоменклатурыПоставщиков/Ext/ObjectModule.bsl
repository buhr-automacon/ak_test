﻿
Процедура ОбработкаЗаполнения(ДанныеЗаполнения, СтандартнаяОбработка)
	
	УстановитьПривилегированныйРежим(Истина);
	Поставщик = ПараметрыСеанса.ТекущийКонтрагент;
	ЗаполнитьКонтактыДляЗаказа();
	УстановитьПривилегированныйРежим(Ложь);
	
	Статус = Перечисления.СтатусыКарточекТовараПоставщиков.ВРаботе;
	
КонецПроцедуры

Процедура ЗаполнитьКонтактыДляЗаказа() Экспорт
	
	Справочники.ХарактеристикиНоменклатурыПоставщиков.ЗаполнитьКонтактыДляЗаказаПоставщика(Поставщик, ЭтотОбъект);
	
КонецПроцедуры

Процедура ПриКопировании(ОбъектКопирования)
	Статус = Перечисления.СтатусыКарточекТовараПоставщиков.ВРаботе;
	ХарактеристикаНоменклатуры = Справочники.ХарактеристикиНоменклатуры.ПустаяСсылка();
КонецПроцедуры
