﻿
Процедура ПередЗаписью(Отказ, Замещение)
	
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;

	Для каждого ЗаписьРегистра Из ЭтотОбъект Цикл
		Если НЕ ЗначениеЗаполнено(ЗаписьРегистра.БанковскийСчет) Тогда
			ОбщегоНазначения.СообщитьОбОшибке("Не заполнено значение реквизита ""Банковский Счет""", Отказ);
		КонецЕсли;
		Если НЕ ЗначениеЗаполнено(ЗаписьРегистра.Организация) Тогда
			ОбщегоНазначения.СообщитьОбОшибке("Не заполнено значение реквизита ""Организация""", Отказ);
		КонецЕсли;
		Если НЕ ЗначениеЗаполнено(ЗаписьРегистра.Программа) Тогда
			ОбщегоНазначения.СообщитьОбОшибке("Не заполнено значение реквизита ""Программа""", Отказ);
		КонецЕсли;
		Если НЕ ЗначениеЗаполнено(ЗаписьРегистра.Кодировка) Тогда
			ОбщегоНазначения.СообщитьОбОшибке("Не заполнено значение реквизита ""Кодировка""", Отказ);
		КонецЕсли;
		
	КонецЦикла;

КонецПроцедуры
