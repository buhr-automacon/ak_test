﻿
///////////////////////////////////////////////////////////////////////////////
// ИНФОРМАЦИОННЫЕ БАЗЫ ДЛЯ ОБМЕНА
//////////////////////////////////////////////////////////////////////////////

Процедура ОткрытьФормуВыполненияОбменаРТ() Экспорт
		
	ФормаВыполненияОбмена = ПолучитьОбщуюФорму("ФормаВыполненияОбменаДанными");
	ФормаВыполненияОбмена.ОтборПоТипуПланаОбмена = ПланыОбмена.ОбменРозницаЗарплатаИУправлениеПерсоналом.ПустаяСсылка();
		
	ФормаВыполненияОбмена.Открыть();
	
КонецПроцедуры
