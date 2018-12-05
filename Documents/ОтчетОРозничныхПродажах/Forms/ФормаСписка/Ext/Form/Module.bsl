﻿
&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	
	Если ИмяСобытия = "ОбновитьОтчетыОПродажах" Тогда
		Элементы.Список.Обновить();
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура Загрузить(Команда)
	
	ОткрытьФорму("Документ.ОтчетОРозничныхПродажах.Форма.ФормаЗаполненияОтчетов",, ЭтаФорма);
	
КонецПроцедуры

Функция ПолучитьОРППоСтроке(Ссылка)
	Возврат Документы.ОтчетОРозничныхПродажах.ПечатьОРП(Ссылка);
КонецФункции	

&НаКлиенте
Процедура ПечатьОРП(Команда)
	
	ТабДок = Новый ТабличныйДокумент();
	Для Каждого ВыделеннаяСтрока Из Элементы.Список.ВыделенныеСтроки Цикл
		Если ТабДок.ВысотаТаблицы > 0 Тогда
			ТабДок.ВывестиГоризонтальныйРазделительСтраниц();
		КонецЕсли;	
		ТабДок.Вывести(ПолучитьОРППоСтроке(ВыделеннаяСтрока));
	КонецЦикла;	
	ТабДок.ОтображатьСетку = Ложь;
	ТабДок.ОтображатьЗаголовки = Ложь;
	ТабДок.Показать();
	
КонецПроцедуры
