﻿
Процедура ПриЗаписи(Отказ, Замещение)
	ЕстьПравоРедактирования = УправлениеДопПравамиПользователей.ПолучитьПравоПользователяУпр(ПланыВидовХарактеристик.ПраваПользователей.РедактированиеАкцептантовОтветственныхПоЗаявкам, Ложь);
	Если Не ЕстьПравоРедактирования Тогда
		Сообщить("У вас нет права редактировать акцептантов для заявок по умолчанию.");
		Отказ = Истина;
	КонецЕсли;	
КонецПроцедуры
