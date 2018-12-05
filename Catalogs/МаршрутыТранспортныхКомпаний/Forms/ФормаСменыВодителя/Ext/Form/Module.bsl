﻿ 
&НаСервереБезКонтекста
Функция ПолучитьПеревозчикаМаршрута(ТекМаршрут)
	
	Возврат ТекМаршрут.Перевозчик;
	
КонецФункции

Процедура ПерезаписатьМаршруты()
	
	РегСвВодителиПоМаршруту = РегистрыСведений.ВодителиПоМаршруту;
	ТекПеревозчик = ЭтаФорма.Автомобиль.Перевозчик;
	
	Для Каждого СтрокаТаблицы Из ЭтаФорма.ТаблицаМаршрутов Цикл
		
		ТекМаршрут = СтрокаТаблицы.Маршрут;
		Если ТекМаршрут.Пустая() Тогда
			Продолжить;
		КонецЕсли;
		
		Если НЕ ТекМаршрут.Перевозчик = ТекПеревозчик Тогда
			ОбъектМаршрута = ТекМаршрут.ПолучитьОбъект();
			ОбъектМаршрута.Перевозчик = ТекПеревозчик;
			Попытка
				ОбъектМаршрута.Записать();
			Исключение
			КонецПопытки;
		КонецЕсли;
		
		МенеджерЗаписи = РегСвВодителиПоМаршруту.СоздатьМенеджерЗаписи();
		МенеджерЗаписи.Период 		= ТекущаяДата();
		МенеджерЗаписи.Маршрут 		= ТекМаршрут;
		МенеджерЗаписи.Водитель 	= ЭтаФорма.Водитель;
		МенеджерЗаписи.Автомобиль 	= ЭтаФорма.Автомобиль;
		МенеджерЗаписи.Контрагент 	= ТекПеревозчик;
		Попытка
			МенеджерЗаписи.Записать();
		Исключение
		КонецПопытки;
		
	КонецЦикла;
	
КонецПроцедуры


&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	мМассивМаршрутов = ЭтаФорма.Параметры.МассивМаршрутов;
	Для Каждого ТекМаршрут Из мМассивМаршрутов Цикл
		НоваяСтрока = ЭтаФорма.ТаблицаМаршрутов.Добавить();
		НоваяСтрока.Маршрут 	= ТекМаршрут;
		НоваяСтрока.Перевозчик 	= ТекМаршрут.Перевозчик;
	КонецЦикла;
	
КонецПроцедуры


&НаКлиенте
Процедура ТаблицаМаршрутовПриОкончанииРедактирования(Элемент, НоваяСтрока, ОтменаРедактирования)
	
	ТекДанные = Элементы.ТаблицаМаршрутов.ТекущиеДанные;
	ТекДанные.Перевозчик = ПолучитьПеревозчикаМаршрута(ТекДанные.Маршрут);
	
КонецПроцедуры


&НаКлиенте
Процедура Установить(Команда)
	
	ПерезаписатьМаршруты();
	
	//
	ЭтаФорма.Закрыть();
	
КонецПроцедуры
