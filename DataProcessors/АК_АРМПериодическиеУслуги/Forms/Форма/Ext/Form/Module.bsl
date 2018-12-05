﻿
&НаКлиенте
Процедура КонтрагентыПриАктивизацииСтроки(Элемент)
	УстановитьОтборы();
КонецПроцедуры

&НаКлиенте
Процедура УстановитьОтборПоКонтрагенту()
		
	Если Элементы.Контрагенты.ТекущаяСтрока = Неопределено или Элементы.Контрагенты.ТекущиеДанные = Неопределено  Тогда
		УстановитьЭлементОтбораДинамическогоСписка(Расшифровка, "Контрагент", ПредопределенноеЗначение("Справочник.Контрагенты.ПустаяСсылка"), 
		ВидСравненияКомпоновкиДанных.Равно, "Контрагент", Ложь);
	Иначе
		ОтборПоКонтрагенту = Элементы.Контрагенты.ТекущиеДанные.Контрагент;
		УстановитьЭлементОтбораДинамическогоСписка(Расшифровка, "Контрагент", ОтборПоКонтрагенту, 
		ВидСравненияКомпоновкиДанных.Равно, "Контрагент", Истина);
	КонецЕсли;
	
КонецПроцедуры
	
&НаКлиенте
Процедура УстановитьЭлементОтбораДинамическогоСписка(ДинамическийСписок, ИмяПоля,
	ПравоеЗначение = Неопределено,
	ВидСравнения = Неопределено,
	Представление = Неопределено,
	Использование = Неопределено,
	РежимОтображения = Неопределено,
	ИдентификаторПользовательскойНастройки = Неопределено) Экспорт
	
	Если РежимОтображения = Неопределено Тогда
		РежимОтображения = РежимОтображенияЭлементаНастройкиКомпоновкиДанных.Недоступный;
	КонецЕсли;
	
	Если РежимОтображения = РежимОтображенияЭлементаНастройкиКомпоновкиДанных.Недоступный Тогда
		ОтборДинамическогоСписка = ДинамическийСписок.Отбор;
	Иначе
		ОтборДинамическогоСписка = ДинамическийСписок.Отбор;
	КонецЕсли;
	
	УстановитьЭлементОтбора(
	ОтборДинамическогоСписка,
	ИмяПоля,
	ПравоеЗначение,
	ВидСравнения,
	Представление,
	Использование,
	РежимОтображения,
	ИдентификаторПользовательскойНастройки);
	
КонецПроцедуры

&НаКлиенте
Процедура УстановитьЭлементОтбора(ОбластьПоискаДобавления,
								Знач ИмяПоля,
								Знач ПравоеЗначение = Неопределено,
								Знач ВидСравнения = Неопределено,
								Знач Представление = Неопределено,
								Знач Использование = Неопределено,
								Знач РежимОтображения = Неопределено,
								Знач ИдентификаторПользовательскойНастройки = Неопределено) Экспорт
	
	ЧислоИзмененных = ИзменитьЭлементыОтбора(ОбластьПоискаДобавления, ИмяПоля, Представление,
							ПравоеЗначение, ВидСравнения, Использование, РежимОтображения, ИдентификаторПользовательскойНастройки);
	
	Если ЧислоИзмененных = 0 Тогда
		Если ВидСравнения = Неопределено Тогда
			Если ТипЗнч(ПравоеЗначение) = Тип("Массив")
				Или ТипЗнч(ПравоеЗначение) = Тип("ФиксированныйМассив")
				Или ТипЗнч(ПравоеЗначение) = Тип("СписокЗначений") Тогда
				ВидСравнения = ВидСравненияКомпоновкиДанных.ВСписке;
			Иначе
				ВидСравнения = ВидСравненияКомпоновкиДанных.Равно;
			КонецЕсли;
		КонецЕсли;
		Если РежимОтображения = Неопределено Тогда
			РежимОтображения = РежимОтображенияЭлементаНастройкиКомпоновкиДанных.Недоступный;
		КонецЕсли;
		ДобавитьЭлементКомпоновки(ОбластьПоискаДобавления, ИмяПоля, ВидСравнения,
								ПравоеЗначение, Представление, Использование, РежимОтображения, ИдентификаторПользовательскойНастройки);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Функция ИзменитьЭлементыОтбора(ОбластьПоиска,
								Знач ИмяПоля = Неопределено,
								Знач Представление = Неопределено,
								Знач ПравоеЗначение = Неопределено,
								Знач ВидСравнения = Неопределено,
								Знач Использование = Неопределено,
								Знач РежимОтображения = Неопределено,
								Знач ИдентификаторПользовательскойНастройки = Неопределено) Экспорт
	
	Если ЗначениеЗаполнено(ИмяПоля) Тогда
		ЗначениеПоиска = Новый ПолеКомпоновкиДанных(ИмяПоля);
		СпособПоиска = 1;
	Иначе
		СпособПоиска = 2;
		ЗначениеПоиска = Представление;
	КонецЕсли;
	
	МассивЭлементов = Новый Массив;
	
	НайтиРекурсивно(ОбластьПоиска.Элементы, МассивЭлементов, СпособПоиска, ЗначениеПоиска);
	
	Для Каждого Элемент Из МассивЭлементов Цикл
		Если ИмяПоля <> Неопределено Тогда
			Элемент.ЛевоеЗначение = Новый ПолеКомпоновкиДанных(ИмяПоля);
		КонецЕсли;
		Если Представление <> Неопределено Тогда
			Элемент.Представление = Представление;
		КонецЕсли;
		Если Использование <> Неопределено Тогда
			Элемент.Использование = Использование;
		КонецЕсли;
		Если ВидСравнения <> Неопределено Тогда
			Элемент.ВидСравнения = ВидСравнения;
		КонецЕсли;
		Если ПравоеЗначение <> Неопределено Тогда
			Элемент.ПравоеЗначение = ПравоеЗначение;
		КонецЕсли;
		Если РежимОтображения <> Неопределено Тогда
			Элемент.РежимОтображения = РежимОтображения;
		КонецЕсли;
		Если ИдентификаторПользовательскойНастройки <> Неопределено Тогда
			Элемент.ИдентификаторПользовательскойНастройки = ИдентификаторПользовательскойНастройки;
		КонецЕсли;
	КонецЦикла;
	
	Возврат МассивЭлементов.Количество();
	
КонецФункции

&НаКлиенте
Процедура НайтиРекурсивно(КоллекцияЭлементов, МассивЭлементов, СпособПоиска, ЗначениеПоиска)
	
	Для каждого ЭлементОтбора Из КоллекцияЭлементов Цикл
		
		Если ТипЗнч(ЭлементОтбора) = Тип("ЭлементОтбораКомпоновкиДанных") Тогда
			
			Если СпособПоиска = 1 Тогда
				Если ЭлементОтбора.ЛевоеЗначение = ЗначениеПоиска Тогда
					МассивЭлементов.Добавить(ЭлементОтбора);
				КонецЕсли;
			ИначеЕсли СпособПоиска = 2 Тогда
				Если ЭлементОтбора.Представление = ЗначениеПоиска Тогда
					МассивЭлементов.Добавить(ЭлементОтбора);
				КонецЕсли;
			КонецЕсли;
		Иначе
			
			НайтиРекурсивно(ЭлементОтбора.Элементы, МассивЭлементов, СпособПоиска, ЗначениеПоиска);
			
			Если СпособПоиска = 2 И ЭлементОтбора.Представление = ЗначениеПоиска Тогда
				МассивЭлементов.Добавить(ЭлементОтбора);
			КонецЕсли;
			
		КонецЕсли;
		
	КонецЦикла;
	
КонецПроцедуры

&НаКлиенте
Функция ДобавитьЭлементКомпоновки(ОбластьДобавления,
									Знач ИмяПоля,
									Знач ВидСравнения,
									Знач ПравоеЗначение = Неопределено,
									Знач Представление  = Неопределено,
									Знач Использование  = Неопределено,
									знач РежимОтображения = Неопределено,
									знач ИдентификаторПользовательскойНастройки = Неопределено) Экспорт
	
	Элемент = ОбластьДобавления.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	Элемент.ЛевоеЗначение = Новый ПолеКомпоновкиДанных(ИмяПоля);
	Элемент.ВидСравнения = ВидСравнения;
	
	Если РежимОтображения = Неопределено Тогда
		Элемент.РежимОтображения = РежимОтображенияЭлементаНастройкиКомпоновкиДанных.Недоступный;
	Иначе
		Элемент.РежимОтображения = РежимОтображения;
	КонецЕсли;
	
	Если ПравоеЗначение <> Неопределено Тогда
		Элемент.ПравоеЗначение = ПравоеЗначение;
	КонецЕсли;
	
	Если Представление <> Неопределено Тогда
		Элемент.Представление = Представление;
	КонецЕсли;
	
	Если Использование <> Неопределено Тогда
		Элемент.Использование = Использование;
	КонецЕсли;
	
	// Важно: установка идентификатора должна выполняться
	// в конце настройки элемента, иначе он будет скопирован
	// в пользовательские настройки частично заполненным.
	Если ИдентификаторПользовательскойНастройки <> Неопределено Тогда
		Элемент.ИдентификаторПользовательскойНастройки = ИдентификаторПользовательскойНастройки;
	ИначеЕсли Элемент.РежимОтображения <> РежимОтображенияЭлементаНастройкиКомпоновкиДанных.Недоступный Тогда
		Элемент.ИдентификаторПользовательскойНастройки = ИмяПоля;
	КонецЕсли;
	
	Возврат Элемент;
	
КонецФункции

&НаКлиенте
Процедура УслугиПриАктивизацииСтроки(Элемент)
	УстановитьОтборы();
КонецПроцедуры

&НаКлиенте
Процедура УстановитьОтборПоСтруктурнойЕдинице()
	Если Элементы.СписокСтруктурныхЕдиниц.ТекущаяСтрока = Неопределено Тогда	
		УстановитьЭлементОтбораДинамическогоСписка(Расшифровка, "СтруктурнаяЕдиница", ПредопределенноеЗначение("Справочник.СтруктурныеЕдиницы.ПустаяСсылка"), 
		ВидСравненияКомпоновкиДанных.Равно, "СтруктурнаяЕдиница", Ложь);
	Иначе
		ОтборПоСтруктурнойЕдинице = Элементы.СписокСтруктурныхЕдиниц.ТекущаяСтрока;
		УстановитьЭлементОтбораДинамическогоСписка(Расшифровка, "СтруктурнаяЕдиница", ОтборПоСтруктурнойЕдинице, 
		ВидСравненияКомпоновкиДанных.Равно, "СтруктурнаяЕдиница", Истина);	
	КонецЕсли;
		
КонецПроцедуры

&НаКлиенте
Процедура УстановитьОтборПоУслуге()
	
	Если Элементы.Услуги.ТекущаяСтрока = Неопределено Тогда
		УстановитьЭлементОтбораДинамическогоСписка(Контрагенты, "Услуга", ПредопределенноеЗначение("Справочник.Контрагенты.ПустаяСсылка"), 
		ВидСравненияКомпоновкиДанных.Равно, "Услуга", Ложь);
		УстановитьЭлементОтбораДинамическогоСписка(Расшифровка, "Услуга", ПредопределенноеЗначение("Справочник.Номенклатура.ПустаяСсылка"), 
		ВидСравненияКомпоновкиДанных.Равно, "Услуга", Ложь);
	Иначе
		ОтборПоУслуге = Элементы.Услуги.ТекущаяСтрока;
		УстановитьЭлементОтбораДинамическогоСписка(Контрагенты, "Услуга", ОтборПоУслуге, 
		ВидСравненияКомпоновкиДанных.Равно, "Услуга", Истина);
		УстановитьЭлементОтбораДинамическогоСписка(Расшифровка, "Услуга", ОтборПоУслуге, 
		ВидСравненияКомпоновкиДанных.Равно, "Услуга", Истина);
	КонецЕсли;
		
КонецПроцедуры

&НаКлиенте
Процедура УслугиВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	СтандартнаяОбработка = Ложь;	
	Объект.Услуга = ВыбраннаяСтрока;
КонецПроцедуры

&НаКлиенте
Процедура КонтрагентыВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	//СтандартнаяОбработка = Ложь;
	//Объект.Контрагент = Элементы.Контрагенты.ТекущиеДанные.Контрагент;
КонецПроцедуры

&НаКлиенте
Процедура ВедомостьРегламетныхРаботОткрыть(Команда)
	//ОткрытьФорму("Отчет.ВедомостьРегламентныхРаботВМагазинах.Форма.ФормаОтчета");
	Ссылка = ПолучитьИПодключитьВнешнююОбработкуВедомостьРегламентныхРаботВМагазинах();
	ИмяФайла = ПолучитьИмяВременногоФайла("ert");
	ДвоичныеДанные = Ссылка.ХранилищеВнешнейОбработки.Получить();
	ДвоичныеДанные.Записать(ИмяФайла);
	ТекущйОтчет = ВнешниеОтчеты.Создать(ИмяФайла);
	Форма = ТекущйОтчет.ПолучитьФорму();
	Форма.Открыть();
КонецПроцедуры

&НаКлиенте
Процедура ПлатежныйКалендарь(Команда)
	//ОткрытьФорму("Обработка.АК_ПлатежныйКалендарьПоРегламентнымРаботам.Форма.Форма");
	Ссылка = ПолучитьИПодключитьВнешнююОбработкуПлатежныйКалендарь();
	ИмяФайла = ПолучитьИмяВременногоФайла("epf");
	ДвоичныеДанные = Ссылка.ХранилищеВнешнейОбработки.Получить();
	ДвоичныеДанные.Записать(ИмяФайла);
	ТекущаяОбработка = ВнешниеОбработки.Создать(ИмяФайла);
	Форма = ТекущаяОбработка.ПолучитьФорму("ФормаОбработки");                                 
	Форма.Открыть();
КонецПроцедуры

&НаКлиенте
Процедура СозданиеДокументовПоступления(Команда)
	ОткрытьФорму("Обработка.АК_СозданиеДокументовПоступленияПоУслугамПоставщиков.Форма.Форма");
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	ПапкаРеглУслуг = ПапкаРегУслуг("000621342");
	Если ЗначениеЗаполнено(ПапкаРеглУслуг) тогда
		УстановитьЭлементОтбораДинамическогоСписка(Услуги, "Родитель", ПапкаРеглУслуг, 
		ВидСравненияКомпоновкиДанных.ВИерархии, "Услуга", Истина);
	КонецЕсли;
	ПапкаОсновныхРеглУслуг = ПапкаРегУслуг("000621370");
	Если ЗначениеЗаполнено(ПапкаОсновныхРеглУслуг) Тогда
		Услуги.УсловноеОформление.Элементы[0].Отбор.Элементы[0].ПравоеЗначение = ПапкаОсновныхРеглУслуг;
	КонецЕсли;
КонецПроцедуры

&НаСервере
Функция ПапкаРегУслуг(НомерЭлемента)
	возврат Справочники.Номенклатура.НайтиПоКоду(НомерЭлемента);	
КонецФункции

Функция ПолучитьИПодключитьВнешнююОбработкуВедомостьРегламентныхРаботВМагазинах()	
	Возврат  Справочники.ВнешниеОбработки.НайтиПоНаименованию("Ведомость регламентных работ в магазинах");
КонецФункции

Функция ПолучитьИПодключитьВнешнююОбработкуПлатежныйКалендарь()	
	Возврат  Справочники.ВнешниеОбработки.НайтиПоНаименованию("Платежный календарь по регламентным работам в торговых точках");
КонецФункции


&НаКлиенте
Процедура СписокСтруктурныхЕдиницПриАктивизацииСтроки(Элемент)
	УстановитьОтборы();
КонецПроцедуры

&НаКлиенте
Процедура УстановитьОтборы()
	УстановитьОтборПоСтруктурнойЕдинице();
	УстановитьОтборПоУслуге();
	УстановитьОтборПоКонтрагенту();
КонецПроцедуры


&НаКлиенте
Процедура ВсеУслуги(Команда)
	Элементы.Услуги.ТекущаяСтрока = Неопределено;
	Элементы.Контрагенты.ТекущаяСтрока = Неопределено;
	УстановитьОтборы();
КонецПроцедуры


&НаКлиенте
Процедура ВсеКонтрагенты(Команда)
	Элементы.Контрагенты.ТекущаяСтрока = Неопределено;
	УстановитьОтборы();
КонецПроцедуры


&НаКлиенте
Процедура ОтборПоУслуге(Команда)
	Элементы.СписокСтруктурныхЕдиниц.ТекущаяСтрока = Неопределено;
	Элементы.Контрагенты.ТекущаяСтрока = Неопределено;
	УстановитьОтборы();
КонецПроцедуры

&НаКлиенте
Процедура ИзменитьУсловия(Команда)
	СтруктураДанных = Новый Структура; 
	ПроверкаСозданияИзменения(СтруктураДанных);
	Если Не СтруктураДанных.Отказ Тогда
		Форма = ПолучитьФорму("Документ.АК_ИзменениеУсловийОбслуживания.Форма.ФормаДокумента");
		фОбъект = Форма.Объект;
		ЗаполнитьДокумент(фОбъект,ПредопределенноеЗначение("Перечисление.АК_ВидыОперацийИзменениеУсловийОбслуживаний.Изменение"),СтруктураДанных.Контрагент,СтруктураДанных.Услуга);
		Форма.Открыть();
	иначе
		ОбщегоНазначения.СообщитьОбОшибке("Веделены разные контрагенты или услуги. Создание документа невозможно.");
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура ПроверкаСозданияИзменения(СтруктураДанных)
	Отказ = Ложь;
	ПредыдущийКонтрагент = неопределено;
	ПредыдущиаяУслуга = Неопределено;
	Для Каждого стр из Элементы.Расшифровка.ВыделенныеСтроки Цикл
		Если не Отказ Тогда
			Если ПредыдущийКонтрагент = Неопределено или ПредыдущиаяУслуга = Неопределено Тогда
				ПредыдущийКонтрагент = стр.Контрагент;
				ПредыдущиаяУслуга = стр.Услуга;
				Продолжить;			
			КонецЕсли;
			Если не ПредыдущиаяУслуга = стр.Услуга или не ПредыдущийКонтрагент = стр.Контрагент Тогда
				Отказ = Истина;
			КонецЕсли;
			ПредыдущийКонтрагент = стр.Контрагент;
			ПредыдущиаяУслуга = стр.Услуга;
		КонецЕсли;
	КонецЦикла;
	СтруктураДанных.Вставить("Отказ",Отказ);
	СтруктураДанных.Вставить("Контрагент",ПредыдущийКонтрагент);
	СтруктураДанных.Вставить("Услуга",ПредыдущиаяУслуга);
КонецПроцедуры

&НаКлиенте
Процедура ЗаполнитьДокумент(фОбъект,ВидОперации,Контрагент,Услуга)
	фОбъект.ВидОперации = ВидОперации;
	фОбъект.Контрагент = Контрагент;
	фОбъект.Услуга = Услуга;
	Для Каждого стр из Элементы.Расшифровка.ВыделенныеСтроки Цикл
		НоваяСтрока = фОбъект.СтруктурныеЕдиницы.Добавить();
		НоваяСтрока.СтруктурнаяЕдиница = стр.СтруктурнаяЕдиница;
	КонецЦикла;
КонецПроцедуры