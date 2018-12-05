﻿
/////////////////////////////////////////////
// ПРОЦЕДУРЫ И ФУНКЦИИ
////////////////////////////////////////////

&НаСервере
Процедура ПоказатьИсториюСервер()
	
	ТаблицаОтчетов.Загрузить(Обработки.УправлениеРассылкойОтчетовПоEmail.ВернутьСписокОтправленных(НомерОтчета, НачалоПериода, КонецПериода, email));	
	
КонецПроцедуры

////////////////////////////////////////////
// ФОРМА
///////////////////////////////////////////

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	НачалоПериода = НачалоДня(ТекущаяДата());
	КонецПериода = КонецДня(ТекущаяДата());
	
КонецПроцедуры

&НаКлиенте
Процедура ПоказатьИсторию(Команда)
	
	ПоказатьИсториюСервер();
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	ПоказатьИсториюСервер();
	
КонецПроцедуры
