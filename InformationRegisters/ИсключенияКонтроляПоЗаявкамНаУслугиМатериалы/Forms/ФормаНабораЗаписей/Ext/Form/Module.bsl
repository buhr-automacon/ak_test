﻿
&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
		УправлениеИсключениямиКонтроляСчетов = УправлениеДопПравамиПользователей.ПолучитьПравоПользователяУпр(ПланыВидовХарактеристик.ПраваПользователей.УправлениеИсключениямиКонтроляСчетов, Ложь);
		ЭтаФорма.ТолькоПросмотр = НЕ УправлениеИсключениямиКонтроляСчетов;

КонецПроцедуры
