﻿
&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Элементы.ПримечаниеОтвета.Видимость = Ложь;
	
КонецПроцедуры


&НаСервереБезКонтекста
Процедура ВнестиОтветПроизводителяСервер(СтруктураПараметров)
	
	ТекГУИД = СтруктураПараметров.GUID_Загрузки;
	
	//
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("GUID_Загрузки", ТекГУИД);
	Запрос.Текст =
	"ВЫБРАТЬ
	|	*
	|ИЗ
	|	РегистрСведений.ОбращенияПокупателей КАК ОбращенияПокупателей
	|ГДЕ
	|	ОбращенияПокупателей.GUID_Загрузки = &GUID_Загрузки";
	
	РезультатЗапроса = Запрос.Выполнить();
	Если РезультатЗапроса.Пустой() Тогда
		Сообщить("Обращений с таким GUID загрузки не найдено!");
		Возврат;
	КонецЕсли;
	
	//
	РегОбращения = РегистрыСведений.ОбращенияПокупателей;
	
	Выборка = РезультатЗапроса.Выбрать();
	Пока Выборка.Следующий() Цикл
		
		МенеджерЗаписи = РегОбращения.СоздатьМенеджерЗаписи();
		МенеджерЗаписи.GUID_Загрузки 	= ТекГУИД;
		МенеджерЗаписи.id_OK			= Выборка.id_OK;
		МенеджерЗаписи.ДатаДок			= Выборка.ДатаДок;
		МенеджерЗаписи.Прочитать();
		
		Если МенеджерЗаписи.Выбран() Тогда
			МенеджерЗаписи.GUID_Загрузки 		= ТекГУИД;
			//МенеджерЗаписи.id_OK				= Выборка.id_OK;
			//МенеджерЗаписи.ДатаДок				= Выборка.ДатаДок;
			ЗаполнитьЗначенияСвойств(МенеджерЗаписи, Выборка);
			МенеджерЗаписи.РезультатОбращения 	= СтруктураПараметров.РезультатОбращения;
			МенеджерЗаписи.СтатусЖалобы 		= СтруктураПараметров.СтатусЖалобы;
			МенеджерЗаписи.ОтветПроизводителя 	= СтруктураПараметров.ОтветПроизводителя;
			Если СтруктураПараметров.ВноситьСутьОтвета Тогда
				МенеджерЗаписи.ПримечаниеОтвета = СтруктураПараметров.ПримечаниеОтвета;
			КонецЕсли;
			МенеджерЗаписи.ПрикрепленныеФайлы 	= СтруктураПараметров.ПрикрепленныеФайлы;
			МенеджерЗаписи.Записать();
		КонецЕсли;
		
		МенеджерЗаписи = Неопределено;
		
	КонецЦикла;
	
КонецПроцедуры

&НаКлиенте
Процедура ВнестиОтветПроизводителя(Команда)
	
	Если НЕ ЗначениеЗаполнено(ЭтаФорма.GUID_Загрузки) Тогда
		Сообщить("Не указан GUID загрузки!");
		Возврат;
	КонецЕсли;
	Если НЕ ЗначениеЗаполнено(ЭтаФорма.ОтветПроизводителя) Тогда
		Сообщить("Не указан ответ производителя!");
		Возврат;
	КонецЕсли;
	Если ЭтаФорма.ВноситьПримечаниеОтвета
			И НЕ ЗначениеЗаполнено(ЭтаФорма.ПримечаниеОтвета) Тогда
		Сообщить("Не указана суть ответа!");
		Возврат;
	КонецЕсли;
	
	//
	СтруктураПараметров = Новый Структура;
	СтруктураПараметров.Вставить("GUID_Загрузки"		, ЭтаФорма.GUID_Загрузки);
	СтруктураПараметров.Вставить("РезультатОбращения"	, ЭтаФорма.РезультатОбращения);
	СтруктураПараметров.Вставить("СтатусЖалобы"			, ЭтаФорма.СтатусЖалобы);
	СтруктураПараметров.Вставить("ОтветПроизводителя"	, ЭтаФорма.ОтветПроизводителя);
	СтруктураПараметров.Вставить("ВноситьСутьОтвета"	, ЭтаФорма.ВноситьПримечаниеОтвета);
	СтруктураПараметров.Вставить("ПримечаниеОтвета"		, ЭтаФорма.ПримечаниеОтвета);
	СтруктураПараметров.Вставить("ПрикрепленныеФайлы"	, ЭтаФорма.ПрикрепленныеФайлы);
	
	ВнестиОтветПроизводителяСервер(СтруктураПараметров);
	
	ЭтаФорма.Закрыть();
	
КонецПроцедуры

&НаКлиенте
Процедура ВноситьПримечаниеОтветаПриИзменении(Элемент)
	
	Элементы.ПримечаниеОтвета.Видимость = ЭтаФорма.ВноситьПримечаниеОтвета;
	
КонецПроцедуры

&НаКлиенте
Процедура ПрикрепитьФайлы(Команда)
	
	ЗначениеВозврат = ОткрытьФормуМодально("РегистрСведений.ОбращенияПокупателей.Форма.ФормаПрикрепленныхФайлов", Новый Структура("ТабФайлов", ЭтаФорма.ПрикрепленныеФайлы));
	Если ЗначениеЗаполнено(ЗначениеВозврат) Тогда
		ЭтаФорма.ПрикрепленныеФайлы = ЗначениеВозврат;
	КонецЕсли;
	
КонецПроцедуры
