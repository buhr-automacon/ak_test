﻿////////////////////////////////////////////////////////////////////////////////
// ПРОЦЕДУРЫ И ФУНКЦИИ РАБОТЫ С ТАБЛИЧНЫМИ ПОЛЯМИ


////////////////////////////////////////////////////////////////////////////////
// ПРОЦЕДУРЫ И ФУНКЦИИ ЗАПОЛНЕНИЯ РЕКВИЗИТОВ

Процедура ПолучитьФизлицИзДополнительныхТабличныхЧастей(Источник, Отказ, РежимЗаписи, РежимПроведения, СоответствиеФизлица) Экспорт

	
	Если Источник.Метаданные().ТабличныеЧасти.Найти("ОтражениеВУчете") = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	Для Каждого Строка Из Источник.ОтражениеВУчете Цикл
		Для СчетчикВидовСубконто = 1 По 4 Цикл
			ДтКт = ?(СчетчикВидовСубконто = 1, "Дт", ?(СчетчикВидовСубконто = 2,"Кт", ?(СчетчикВидовСубконто = 3, "ДтНУ", "КтНУ")));
			Для СчетчикСубконто = 1 По 3 Цикл
				ЗначениеСубконто = Строка["Субконто"+ДтКт+СчетчикСубконто];
				Если ЗначениеСубконто <> Неопределено и ТипЗнч(ЗначениеСубконто) = Тип("СправочникСсылка.ФизическиеЛица") Тогда
					СоответствиеФизлица.Вставить(ЗначениеСубконто, "");
				КонецЕсли;
			КонецЦикла;	
		КонецЦикла;	
	КонецЦикла;

КонецПроцедуры
