﻿
&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	СменаТекущегоОтчета = Ложь;
	МакетОглавления = Справочники.ОтчетМСФО.ПолучитьМакет("Оглавление");
	СписокРазделов = МакетОглавления.ПолучитьОбласть("СписокРазделов");
	Сч = 1;
	Пока Сч <= СписокРазделов.ВысотаТаблицы Цикл
		НовыйРаздел = РазделыИзШаблона.Добавить();
		НовыйРаздел.Название = СписокРазделов.Область("R" + Сч + "C1").Текст;
		НовыйРаздел.ИмяПроцедуры = СписокРазделов.Область("R" + Сч + "C2").Текст;
		НовыйРаздел.НомерСтроки = Сч;
		Сч = Сч + 1;
	КонецЦикла;
КонецПроцедуры

&НаКлиенте
Процедура ОтчетыПриАктивизацииСтроки(Элемент)
	Если НЕ СменаТекущегоОтчета Тогда
		СменаТекущегоОтчета = Истина;
		КодСправочника = Элемент.ТекущиеДанные.Код;
		ЗаполнитьРазделыИзОчета(КодСправочника);
		СменаТекущегоОтчета = Ложь;
	КонецЕсли;
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьРазделыИзОчета(КодСправочника)
	РазделыИзОтчета.Очистить();
	Отчет = Справочники.ОтчетМСФО.НайтиПоКоду(КодСправочника);
	Если Отчет <> ПредопределенноеЗначение("Справочник.ОтчетМСФО.ПустаяСсылка") Тогда
		РазделыИзОтчета.Загрузить(Отчет.Разделы.Выгрузить());
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура Перенести(Команда)
	Рез = Новый Структура;
	МассивНомеров = Новый Массив;
	Для каждого Стр из РазделыИзШаблона Цикл
		Если Стр.Выбран Тогда
			МассивНомеров.Добавить(Стр.НомерСтроки);
		КонецЕсли;
	КонецЦикла;
	Рез.Вставить("Шаблон", МассивНомеров);
	
	МассивНомеров = Новый Массив;
	Для каждого Стр из РазделыИзОтчета Цикл
		Если Стр.Выбран Тогда
			МассивНомеров.Добавить(Стр.НомерСтроки);
		КонецЕсли;
	КонецЦикла;
	Рез.Вставить("Отчет", МассивНомеров);
	Рез.Вставить("ОтчетКод", КодСправочника);
	
	Закрыть(Рез);
КонецПроцедуры
