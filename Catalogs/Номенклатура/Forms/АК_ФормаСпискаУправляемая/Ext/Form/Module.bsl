﻿
&НаКлиенте
Процедура КаталогиСайта(Команда)
		ОткрытьФорму("Обработка.УправлениеНоменклатуройСайта.Форма.Форма");
КонецПроцедуры

&НаКлиенте
Процедура УстановитьАкции(Команда)
		ОткрытьФорму("Обработка.УстановкаАкцийПоНоменклатуре.Форма.Форма");
КонецПроцедуры

&НаКлиенте
Процедура ОтчетПоДействующимАкциям(Команда)
	ОткрытьФорму("Отчет.ДействующиеАкцииПоТоварам.Форма.ФормаОтчета");
КонецПроцедуры

&НаКлиенте
Процедура ПроблемыЭтикетокНаСайте(Команда)
	ОткрытьФорму("Справочник.Номенклатура.Форма.ПривязкиЭтикетокКСайту");
КонецПроцедуры

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	//+++АК KIRN 2018.03.20 ИП-00018103
	ОбщиеПроцедуры.НоменклатураФормаУпрПриСозданииНаСервере(ЭтаФорма, "Список");
	//---АК KIRN 
КонецПроцедуры
