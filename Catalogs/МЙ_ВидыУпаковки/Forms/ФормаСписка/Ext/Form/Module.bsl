﻿
&НаСервере
Процедура ОбновитьИзМакетаНаСервере()
	Справочники.МЙ_ВидыУпаковки.ОбновитьИзМакета();
КонецПроцедуры

&НаКлиенте
Процедура ОбновитьИзМакета(Команда)
	ОбновитьИзМакетаНаСервере();
КонецПроцедуры
