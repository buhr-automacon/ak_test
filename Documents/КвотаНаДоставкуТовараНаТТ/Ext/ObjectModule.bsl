﻿
Процедура ОбработкаПроведения(Отказ, Режим)
 	
	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ
		|	КОЛИЧЕСТВО(РАЗЛИЧНЫЕ Маршруты.Ссылка) КАК Кол,
		|	Маршруты.Перевозчик
		|ИЗ
		|	Справочник.Маршруты КАК Маршруты
		|ГДЕ
		|	Маршруты.Перевозчик =(&Перевозчик)
		|	И Маршруты.ПометкаУдаления = ЛОЖЬ
		|	И Маршруты.СтруктурноеПодразделение = &СтруктурноеПодразделение
		|	И ВЫБОР
		|			КОГДА Маршруты.Организация = ЗНАЧЕНИЕ(Справочник.организации.ПустаяСсылка)
		|				ТОГДА &Вкусвилл
		|			ИНАЧЕ Маршруты.Организация
		|		КОНЕЦ = &Организация
		|
		|СГРУППИРОВАТЬ ПО
		|	Маршруты.Перевозчик";

	ТЗ=ВременныеИнтервалы.Выгрузить();                                           
	//ТЗ.Свернуть("Подрядчик","КоличествоМаршрутов");
	Запрос.УстановитьПараметр("Перевозчик", Подрядчик);
	Запрос.УстановитьПараметр("СтруктурноеПодразделение", Склад);
	Запрос.УстановитьПараметр("Организация", ?(ЗначениеЗаполнено(Организация),Организация,Справочники.Организации.НайтиПоКоду("000000006")));
	Запрос.УстановитьПараметр("Вкусвилл", Справочники.Организации.НайтиПоКоду("000000006"));
	
	Результат = Запрос.Выполнить();

	ВыборкаДетальныеЗаписи = Результат.Выбрать();

	Для каждого Стр Из ТЗ Цикл
		Кол=0;
		Если ВыборкаДетальныеЗаписи.НайтиСледующий(Новый Структура("Перевозчик",Подрядчик))  Тогда
			Кол=ВыборкаДетальныеЗаписи.Кол;
		КонецЕсли;
		//Если Кол<>Стр.КоличествоМаршрутов Тогда
		//	Сообщить("Для перевозчика "+Подрядчик+" обнаружено несоответствие количества маршрутов: в документе их заложено "+Строка(Стр.КоличествоМаршрутов)
		//	+", а в справочнике Маршруты у этого перевозчика "+Строка(Кол)+" активных маршрутов");
		//КонецЕсли; 
		ВыборкаДетальныеЗаписи.Сбросить();
	
	КонецЦикла; 
	
	
	Движения.КвотаПеревозчика.Записывать = Истина;
	Движения.КвотаПеревозчика.Очистить();
	Для Каждого ТекСтрокаВременныеИнтервалы Из ВременныеИнтервалы Цикл
		Движение = Движения.КвотаПеревозчика.Добавить();
		Движение.Период = Дата;
		Движение.Подрядчик = Подрядчик;
		Движение.Организация = Организация;
		Движение.КоличествоМаршрутов = ТекСтрокаВременныеИнтервалы.КоличествоМаршрутов;
		Движение.ВременнойИнтервал = ТекСтрокаВременныеИнтервалы.ВременнойИнтервал;
		Движение.Склад = Склад;
	КонецЦикла;

КонецПроцедуры
