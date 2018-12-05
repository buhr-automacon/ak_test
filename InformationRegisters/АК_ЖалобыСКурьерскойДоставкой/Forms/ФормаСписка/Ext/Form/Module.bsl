﻿
&НаКлиенте
Процедура СписокПередНачаломИзменения(Элемент, Отказ)
	
	Если Элемент.ТекущийЭлемент.Имя = "ID_ok_Жалобы" Тогда
		
		Жалоба = НайтиЖалобуСервер(Элемент.ТекущиеДанные.ID_ok_Жалобы, Истина);
		Если Жалоба = Неопределено тогда
			Предупреждение("В базе не найдена жалоба с номером " + Элемент.ТекущиеДанные.ID_ok_Жалобы);
		Иначе
			Структура = Новый Структура("Ключ", Жалоба);
			ОткрытьФорму("РегистрСведений.ОбращенияПокупателей.ФормаЗаписи", Структура, ЭтаФорма);
		КонецЕсли;
		
		Отказ = Истина;
		
	КонецЕсли;
	
КонецПроцедуры

Функция НайтиЖалобуСервер(НомерЖалобы, ВозвратКлюча)
	
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("id_OK", НомерЖалобы);
	Запрос.Текст =
	"ВЫБРАТЬ
	|	ОбращенияПокупателей.Телефон,
	|	ОбращенияПокупателей.id_OK,
	|	ОбращенияПокупателей.GUID_Загрузки,
	|	ОбращенияПокупателей.ДатаДок
	|ИЗ
	|	РегистрСведений.ОбращенияПокупателей КАК ОбращенияПокупателей
	|ГДЕ
	|	ОбращенияПокупателей.id_OK = &id_OK";
	ВыборкаЖалоб = Запрос.Выполнить().Выбрать();
	ЖалобаНайдена = Ложь;
	Пока ВыборкаЖалоб.Следующий() Цикл
		ЖалобаНайдена = Истина;
		Если ВозвратКлюча Тогда
			Возврат РегистрыСведений.ОбращенияПокупателей.СоздатьКлючЗаписи(Новый Структура("id_OK, GUID_Загрузки, ДатаДок", ВыборкаЖалоб.id_OK, ВыборкаЖалоб.GUID_Загрузки, ВыборкаЖалоб.ДатаДок)); 
		Иначе
			Возврат ВыборкаЖалоб.Телефон;
		КонецЕсли;
		Прервать;
	КонецЦикла;
	Если НЕ ЖалобаНайдена Тогда
		Возврат Неопределено;
	КонецЕсли;
	
КонецФункции

&НаКлиенте
Процедура ОбновитьСписок(Команда)
	
	ЭтаФорма.ОбновитьОтображениеДанных();
	
КонецПроцедуры
