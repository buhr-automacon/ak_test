﻿
&НаСервере
Процедура ЗагрузитьИзКлассификатораСервер()
	
	Справочники.СтанцииМетро.ЗагрузитьИзКлассификатора();
	
КонецПроцедуры

&НаКлиенте
Процедура ЗагрузитьИзКлассификатора(Команда)
	
	ЗагрузитьИзКлассификатораСервер();
	Элементы.Список.Обновить();
	
КонецПроцедуры
