﻿
&НаКлиенте
Процедура СменитьВодителя(Команда)
	
	ТекВыделенныеСтроки = Элементы.Список.ВыделенныеСтроки;
	Если ТекВыделенныеСтроки.Количество() = 0 Тогда
		ОбщегоНазначения.СообщитьОбОшибке("Необходимо выбрать хотя бы один маршрут!");
		Возврат;
	КонецЕсли;
	
	//
	мМассив = Новый Массив;
	Для Каждого СтрокаСписка Из ТекВыделенныеСтроки Цикл	
		ТекДанные = ЭтаФорма.Список.НайтиПоИдентификатору(СтрокаСписка);
		мМассив.Добавить(ТекДанные.Ссылка);
	КонецЦикла;
	
	ПараметрыФормы = Новый Структура("МассивМаршрутов", мМассив);
	ФормаСменыВодителя = ПолучитьФорму("Справочник.МаршрутыТранспортныхКомпаний.Форма.ФормаСменыВодителя", ПараметрыФормы, ЭтаФорма);
	ФормаСменыВодителя.ОткрытьМодально();
	
КонецПроцедуры

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	УстановитьФильтрациюСпискаДляПеревозчика();
КонецПроцедуры

//+++АК sole 2018.06.20 ИП-00018920.01
&НаСервере
Процедура УстановитьФильтрациюСпискаДляПеревозчика()
	
	Если 
				НЕ РольДоступна("ПолныеПрава") 
			И	РольДоступна("Перевозчик") 
	Тогда
		СписокДоступныхПеревозчиков = РегистрыСведений.АК_ПеревозчикиПоКонтрагентам.ПолучитьСписокКонтрагентовДляФильтрации(ПараметрыСеанса.ТекущийПользователь);
		
		ЭлементОтбора = Список.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
		ЭлементОтбора.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("Перевозчик");
		ЭлементОтбора.Использование = Истина;
		ЭлементОтбора.ВидСравнения = ВидСравненияКомпоновкиДанных.ВСписке;
		ЭлементОтбора.ПравоеЗначение = СписокДоступныхПеревозчиков;
		ЭлементОтбора.РежимОтображения = РежимОтображенияЭлементаНастройкиКомпоновкиДанных.Недоступный;

	КонецЕсли;
	

КонецПроцедуры
