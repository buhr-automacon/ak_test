﻿&НаКлиенте                                                                                 
Процедура ТоварыПриАктивизацииСтроки(Элемент)
	ОтключитьОбработчикОжидания("ТоварыПриАктивизацииСтрокиОЖ");
	ПодключитьОбработчикОжидания("ТоварыПриАктивизацииСтрокиОЖ",0.5,Истина);	
КонецПроцедуры

&НаКлиенте
Процедура ТоварыПриАктивизацииСтрокиОЖ()
	Картинка = Новый Картинка();
	Файл = "";
	ТекущиеДанные = Элементы.Товары.ТекущиеДанные;
	ТекущаяСтрока = Элементы.Товары.ТекущаяСтрока;
	Если не ТекущиеДанные = Неопределено Тогда
		Если не Элементы.Товары.ТекущаяСтрока = ПредыдущееЗначениеСтроки Тогда
			ПредыдущееЗначениеСтроки = ТекущаяСтрока; 
			Декларация  = ТекущиеДанные.Декларация;
			Комментарии  = ТекущиеДанные.Комментарии;
			Если ТекущиеДанные.ПолноеНаименование="верно" Тогда	ПолноеНаименование = 1 иначеесли ТекущиеДанные.ПолноеНаименование="не верно" тогда ПолноеНаименование=2 иначе ПолноеНаименование=0 Конецесли;
			Если ТекущиеДанные.УсловияИСрокХраненияПродукции="верно" Тогда	УсловияИСрокХраненияПродукции = 1 иначеесли ТекущиеДанные.УсловияИСрокХраненияПродукции="не верно" тогда УсловияИСрокХраненияПродукции=2 иначе УсловияИСрокХраненияПродукции=0 Конецесли;
			Если ТекущиеДанные.ФактическийАдрес="верно" Тогда	ФактическийАдрес = 1 иначеесли ТекущиеДанные.ФактическийАдрес="не верно" тогда ФактическийАдрес=2 иначе ФактическийАдрес=0 Конецесли;
			Если ТекущиеДанные.НаименованиеПродукта="верно" Тогда	НаименованиеПродукта = 1 иначеесли ТекущиеДанные.НаименованиеПродукта="не верно" тогда НаименованиеПродукта=2 иначе НаименованиеПродукта=0 Конецесли;
			Если ТекущиеДанные.ДокументВСоответствииСКоторымПродуктПроизведен="верно" Тогда	ДокументВСоответствииСКоторымПродуктПроизведен = 1 иначеесли ТекущиеДанные.ДокументВСоответствииСКоторымПродуктПроизведен="не верно" тогда ДокументВСоответствииСКоторымПродуктПроизведен=2 иначе ДокументВСоответствииСКоторымПродуктПроизведен=0 Конецесли;
			Этикетка = ТекущиеДанные.Этикетка;
			Если ЗначениеЗаполнено(ТекущиеДанные.Ответственный) Тогда
				ТекстОтв = "Проверил "+ТекущиеДанные.Ответственный;	
			иначе
				ТекстОтв ="";	
			КонецЕсли;
			Элементы.ДекорацияПроверкуПроизвел.Заголовок = ТекстОтв;
			ПолучитьСписокКартинокНаСервере(ТекущиеДанные.Номенклатура,ТекущиеДанные.Характеристика);
			ПервончальноеЗаполнениеКартинок();       
		КонецЕсли;
		ДоступностьМеток();
	КонецЕсли;	
КонецПроцедуры

&НаСервере
Процедура ПолучитьСписокКартинокНаСервере(Номенклатура,Характеристика)
	СтруктураПоиска = Новый Структура();
	СтруктураПоиска.Вставить("Номенклатура",Номенклатура);
	СтруктураПоиска.Вставить("Характеристика",Характеристика);
	МассивНайденныхЭтикеток.Очистить();
	МассивНайденныхДеклараций.Очистить();
	Для каждого ЭлСпискаКартинок из СписокКартинок.НайтиСтроки(СтруктураПоиска) Цикл 
		Если ЭлСпискаКартинок.Тип = 1 Тогда
			НоваяСтрока = МассивНайденныхЭтикеток.Добавить();
		иначе
			НоваяСтрока = МассивНайденныхДеклараций.Добавить();
		КонецЕсли;
		ЗаполнитьЗначенияСвойств(НоваяСтрока,ЭлСпискаКартинок);
	КонецЦикла; 	
КонецПроцедуры

&НаСервере
Функция УстановитьКартинкуИзСтроки(Ключ, ИмяЭлемента)
	Если не(Ключ = "") Тогда
		Файл = Новый Картинка(Ключ);
		Если  ЗначениеЗаполнено(Файл) тогда                                                             
			ЭтаФорма[ИмяЭлемента] = ПоместитьВоВременноеХранилище(Файл);
		Иначе	
			ЭтаФорма[ИмяЭлемента] = "";
		КонецЕсли;
	КонецЕсли;
КонецФункции

&НаСервере
Процедура ПолучитьЭтикеткиДекларацииНаСервере() 
	Запрос = Новый Запрос;
	Запрос.Текст = "ВЫБРАТЬ
	|	ХарактеристикиНоменклатуры.Ссылка КАК Характеристика,
	|	ХарактеристикиНоменклатуры.Владелец КАК Номенклатура,
	|	ВЫРАЗИТЬ(НоменклатураЭтикетки.ИмяФайла КАК СТРОКА(1000)) КАК Файл,
	|	1 КАК Тип,
	|	NULL КАК ХранилищеИменФайловСертификата
	|ИЗ
	|	Справочник.ХарактеристикиНоменклатуры КАК ХарактеристикиНоменклатуры
	|		ЛЕВОЕ СОЕДИНЕНИЕ Справочник.Номенклатура.Этикетки КАК НоменклатураЭтикетки
	|		ПО ХарактеристикиНоменклатуры.Ссылка = НоменклатураЭтикетки.Характеристика
	|			И ХарактеристикиНоменклатуры.Владелец = НоменклатураЭтикетки.Ссылка
	|ГДЕ
	|	ХарактеристикиНоменклатуры.СтатусАктивностиХарактеристики = ЗНАЧЕНИЕ(Перечисление.СтатусыАктивностиХарактеристик.Активна)
	|	И НЕ ХарактеристикиНоменклатуры.Владелец.Выведена
	|
	|ОБЪЕДИНИТЬ ВСЕ
	|
	|ВЫБРАТЬ
	|	ХарактеристикиНоменклатуры.Ссылка,
	|	ХарактеристикиНоменклатуры.Владелец,
	|	ВЫРАЗИТЬ(СертификатыНаПродукциюСрезПоследних.ИмяФайла КАК СТРОКА(1000)),
	|	2,
	|	СертификатыНаПродукциюСрезПоследних.ХранилищеИменФайловСертификата
	|ИЗ
	|	Справочник.ХарактеристикиНоменклатуры КАК ХарактеристикиНоменклатуры
	|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.СертификатыНаПродукцию.СрезПоследних(, ДействуетДо > &ТекДата) КАК СертификатыНаПродукциюСрезПоследних
	|		ПО ХарактеристикиНоменклатуры.Ссылка = СертификатыНаПродукциюСрезПоследних.Характеристика
	|			И ХарактеристикиНоменклатуры.Владелец = СертификатыНаПродукциюСрезПоследних.Номенклатура
	|			И СертификатыНаПродукциюСрезПоследних.Удален = Ложь
	|ГДЕ
	|	ХарактеристикиНоменклатуры.СтатусАктивностиХарактеристики = ЗНАЧЕНИЕ(Перечисление.СтатусыАктивностиХарактеристик.Активна)
	|	И НЕ ХарактеристикиНоменклатуры.Владелец.Выведена";
	Запрос.УстановитьПараметр("ТекДата",ТекущаяДата());
	ТаблицаРезультат = Запрос.Выполнить().Выгрузить();
	Для каждого стр из ТаблицаРезультат Цикл
		Если стр.Тип = 1 Тогда
			//Файл = новый Файл(стр.Файл);       временно уберу проверку
			//Если Файл.Существует() Тогда
			СтрокаКартинки = СписокКартинок.Добавить();
			ЗаполнитьЗначенияСвойств(СтрокаКартинки,стр);
			//КонецЕсли;
		ИначеЕсли стр.Тип = 2 Тогда
			попытка
				ТЗ_СписокДекларации = стр.ХранилищеИменФайловСертификата.Получить();
				Если ТЗ_СписокДекларации = Неопределено ИЛИ ТЗ_СписокДекларации.Количество() = 0 Тогда
					//Файл = новый Файл(стр.Файл);
					//Если Файл.Существует() Тогда
					СтрокаКартинки = СписокКартинок.Добавить();
					ЗаполнитьЗначенияСвойств(СтрокаКартинки,стр);
					//КонецЕсли;
				Иначе
					Для Каждого СтрокаТЗ Из ТЗ_СписокДекларации Цикл
						Файл = новый Файл(СтрокаТЗ.ИмяФайла);
						Если Файл.Существует() Тогда
							СтрокаКартинки = СписокКартинок.Добавить();
							ЗаполнитьЗначенияСвойств(СтрокаКартинки,стр);
							СтрокаКартинки.Файл = СтрокаТЗ.ИмяФайла;
						КонецЕсли;
					КонецЦикла;
				КонецЕсли;
			исключение конецпопытки;
		КонецЕсли;
	КонецЦикла;
КонецПроцедуры

&НаКлиенте
Процедура ЗаписатьИПерейтиДальше(Команда)
	ТекСтрока = Элементы.Товары.ТекущиеДанные;
	ЗаписатьИПерейтиДальшеНаСервере(ТекСтрока);	
	Элементы.Товары.Обновить();
	ЭтаФорма.ОбновитьОтображениеДанных();
	Если (Элементы.Товары.ТекущаяСтрока <> Неопределено) тогда 
		Элементы.Товары.ТекущаяСтрока= Элементы.Товары.ТекущаяСтрока + 1;	
	КонецЕсли; 
	//ТоварыВыбор(неопределено,неопределено,неопределено,истина);
КонецПроцедуры

&НаСервере
Процедура ЗаписатьИПерейтиДальшеНаСервере(Строка)
	НоваяЗапись = РегистрыСведений.АК_РезультатСверкиДанныхДеклараций.СоздатьМенеджерЗаписи();
	НоваяЗапись.Период = ТекущаяДата(); 
	НоваяЗапись.Номенклатура =  Строка.Номенклатура; 
	НоваяЗапись.Характеристика =  Строка.Характеристика; 
	НоваяЗапись.Декларация  =Декларация;
	НоваяЗапись.Комментарии  = Комментарии; 
	НоваяЗапись.ПолноеНаименование =ПолноеНаименование;
	НоваяЗапись.УсловияИСрокХраненияПродукции = УсловияИСрокХраненияПродукции;
	НоваяЗапись.ФактическийАдрес = ФактическийАдрес;
	НоваяЗапись.Этикетка = Этикетка;
	НоваяЗапись.НаименованиеПродукта = НаименованиеПродукта;
	НоваяЗапись.ДокументВСоответствииСКоторымПродуктПроизведен = ДокументВСоответствииСКоторымПродуктПроизведен;
	Если (НоваяЗапись.ПолноеНаименование=1 и НоваяЗапись.УсловияИСрокХраненияПродукции=1 и НоваяЗапись.ФактическийАдрес=1 и НоваяЗапись.НаименованиеПродукта=1 и НоваяЗапись.ДокументВСоответствииСКоторымПродуктПроизведен=1) тогда
		НоваяЗапись.Статус = Истина;
	КонецЕсли;
	НоваяЗапись.Ответственный = ПараметрыСеанса.ТекущийПользователь;
	НоваяЗапись.Записать();	
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
Процедура ТехнологПриИзменении(Элемент)
	
	//+++АК SHEP 20170711 ИП-00016183: закомментировал, добавил отбор
	//Если фильтровать по технологу, не все позиции показывает (хотя без фильтра позиция есть в списке). По позиции проставлен технолог  (в карточке контрагента (КА))
	
	//МассивОтбора = Новый Массив;
	//ПараметрыОтбора = Новый Структура;
	//ПараметрыОтбора.Вставить("Технолог", Технолог);
	//МассивСтрок = ТаблицаТехнологов.НайтиСтроки(ПараметрыОтбора);
	//Если не МассивСтрок = Неопределено Тогда
	//	Для каждого элМассива из МассивСтрок Цикл
	//		МассивОтбора.Добавить(элМассива.Характеристика);	
	//	КонецЦикла;
	//КонецЕсли;
	//УстановитьЭлементОтбораДинамическогоСписка(Товары, "Характеристика", МассивОтбора, 
	//ВидСравненияКомпоновкиДанных.ВСписке, "Технолог", ЗначениеЗаполнено(Технолог));	
	
	Товары.Параметры.УстановитьЗначениеПараметра("Технолог", Технолог);
	//Элементы.Товары.Обновить();
	//---АК SHEP 20170711
	
КонецПроцедуры

&НаКлиенте
Функция ДекларацияФильтрПриИзменении(Элемент)
	ЗначениеОтбора = ""; 
	Если (ДекларацияФильтр = 1) тогда 
		УстановитьЭлементОтбораДинамическогоСписка(Товары, "Декларация", ПолучитьВидСтатуса(1), 
		ВидСравненияКомпоновкиДанных.Равно, "Декларация", ЗначениеЗаполнено(ДекларацияФильтр));	
	ИначеЕсли(ДекларацияФильтр = 2) тогда
		УстановитьЭлементОтбораДинамическогоСписка(Товары, "Декларация", ПолучитьВидСтатуса(1), 
		ВидСравненияКомпоновкиДанных.НеРавно, "Декларация", ЗначениеЗаполнено(ДекларацияФильтр));	
	Иначе
		УстановитьЭлементОтбораДинамическогоСписка(Товары, "Декларация", ДекларацияФильтр, 
		ВидСравненияКомпоновкиДанных.Равно, "Декларация", ЗначениеЗаполнено(ДекларацияФильтр));	
	КонецЕсли; 	
КонецФункции

&НаСервере
Функция ПолучитьВидСтатуса(Ключ)
	Если (Ключ= 1) тогда
		Возврат Перечисления.АК_ВидыСтатусовПроверкиИзображений.Проверено;
	ИначеЕсли (Ключ= 2) тогда 
		Возврат Перечисления.АК_ВидыСтатусовПроверкиИзображений.НеНаТотТовар
	ИначеЕсли (Ключ= 3) тогда 
		Возврат Перечисления.АК_ВидыСтатусовПроверкиИзображений.ПлохогоКачества
	КонецЕсли;	
КонецФункции

&НаКлиенте
Процедура СтатусПриИзменении(Элемент)
	ЗначениеОтбора = ""; 
	Если (Статус = 1) тогда 
		ЗначениеОтбора = Ложь;
	ИначеЕсли(Статус = 2) тогда
		ЗначениеОтбора = Истина; 
	КонецЕсли;
	УстановитьЭлементОтбораДинамическогоСписка(Товары, "Проверено",ЗначениеОтбора,	ВидСравненияКомпоновкиДанных.Равно,"Проверено", ЗначениеЗаполнено(Статус));	
КонецПроцедуры

&НаКлиенте
Процедура ЭтикеткиФильтрПриИзменении(Элемент)
	ЗначениеОтбора = ""; 
	Если (ЭтикеткиФильтр = 1) тогда 
		УстановитьЭлементОтбораДинамическогоСписка(Товары, "Этикетка", ПолучитьВидСтатуса(1), 
		ВидСравненияКомпоновкиДанных.Равно, "Этикетка", ЗначениеЗаполнено(ЭтикеткиФильтр));	
	ИначеЕсли(ЭтикеткиФильтр = 2) тогда
		УстановитьЭлементОтбораДинамическогоСписка(Товары, "Этикетка", ПолучитьВидСтатуса(1), 
		ВидСравненияКомпоновкиДанных.НеРавно, "Этикетка", ЗначениеЗаполнено(ЭтикеткиФильтр));	
	Иначе
		УстановитьЭлементОтбораДинамическогоСписка(Товары, "Этикетка", ДекларацияФильтр, 
		ВидСравненияКомпоновкиДанных.Равно, "Этикетка", ЗначениеЗаполнено(ЭтикеткиФильтр));	
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура ПечатьФайла(пИмяФайла,СсылкаВоВременномХранилище, СразуПечать = Истина) Экспорт
		
	Файл = Новый Файл(пИмяФайла);
	Если СразуПечать = Истина Тогда
		Если Найти(НРег(Файл.Расширение), ".doc") > 0 Тогда
			пПрограмма = """rundll32 SHELL32.DLL,ShellExec_RunDLL winword ""пИмяФайла"" /mFilePrintDefault /mDocClose /mFileExit""";
		ИначеЕсли Найти(НРег(Файл.Расширение), ".xls") > 0 Тогда
			пПрограмма = "WScript.exe ""D:\Izbenka\Базы 1С\ExcelPrint.vbs"" ""пИмяФайла""";
		ИначеЕсли Найти(НРег(Файл.Расширение), ".bmp") > 0
			ИЛИ Найти(НРег(Файл.Расширение), ".dib") > 0
			ИЛИ Найти(НРег(Файл.Расширение), ".rle") > 0
			ИЛИ Найти(НРег(Файл.Расширение), ".jpg") > 0
			ИЛИ Найти(НРег(Файл.Расширение), ".jpeg") > 0
			ИЛИ Найти(НРег(Файл.Расширение), ".tif") > 0
			ИЛИ Найти(НРег(Файл.Расширение), ".gif") > 0
			ИЛИ Найти(НРег(Файл.Расширение), ".png") > 0
			ИЛИ Найти(НРег(Файл.Расширение), ".ico") > 0
			ИЛИ Найти(НРег(Файл.Расширение), ".wmf") > 0
			ИЛИ Найти(НРег(Файл.Расширение), ".emf") > 0
			ИЛИ Найти(НРег(Файл.Расширение), ".bmp") > 0
			ИЛИ Найти(НРег(Файл.Расширение), ".dib") > 0
			ИЛИ Найти(НРег(Файл.Расширение), ".rle") > 0
			ИЛИ Найти(НРег(Файл.Расширение), ".jpg") > 0
			ИЛИ Найти(НРег(Файл.Расширение), ".jpeg") > 0
			ИЛИ Найти(НРег(Файл.Расширение), ".tif") > 0
			ИЛИ Найти(НРег(Файл.Расширение), ".gif") > 0
			ИЛИ Найти(НРег(Файл.Расширение), ".png") > 0
			ИЛИ Найти(НРег(Файл.Расширение), ".ico") > 0
			ИЛИ Найти(НРег(Файл.Расширение), ".wmf") > 0
			ИЛИ Найти(НРег(Файл.Расширение), ".emf") > 0 Тогда
			пПрограмма = """C:\Windows\system32\mspaint.exe"" /p ""пИмяФайла""";
		ИначеЕсли Найти(НРег(Файл.Расширение), ".txt") > 0 Тогда
			пПрограмма = """C:\Windows\system32\notepad.exe"" /p ""пИмяФайла""";
		ИначеЕсли Найти(НРег(Файл.Расширение), ".pdf") > 0 Тогда	
			пПрограмма = """c:\Program Files (x86)\Foxit Software\Foxit Reader\Foxit Reader.exe"" /p ""пИмяФайла""";
		Иначе
			ОбщегоНазначения.СообщитьОбОшибке("Печать файлов данного формата (" + пИмяФайла + ") не поддерживается");
			Возврат;
		КонецЕсли;	
	КонецЕсли;
	
	ИмяКаталога = "\\server00\Temp\"+ТекущийКаталог;		
	СоздатьКаталог(ИмяКаталога);
	
	ИмяВременногоФайла = РаботаСФайлами.ПолучитьИмяФайла(ИмяКаталога, Строка(Новый УникальныйИдентификатор) + Файл.Расширение);
	
	ДвоичныеДанные = ПолучитьИзВременногоХранилища(СсылкаВоВременномХранилище).ПолучитьДвоичныеДанные();
	//ПолучитьИзВременногоХранилища(ХранилищеЗначенияСервер(пИмяФайла));
	Если ТипЗнч(ДвоичныеДанные) = Тип("ДвоичныеДанные") Тогда
		ДвоичныеДанные.Записать(ИмяВременногоФайла); 		
		пПрограмма = СтрЗаменить(пПрограмма, "пИмяФайла", ИмяВременногоФайла); 		
		Если СразуПечать = Истина Тогда
			ЗапуститьПриложение(пПрограмма);
		Иначе
			ЗапуститьПриложение(ИмяВременногоФайла);
		КонецЕсли;
	КонецЕсли;    	
	
КонецПроцедуры

&НаСервере
Функция ХранилищеЗначенияСервер(ИмяФайла)
	Возврат ПоместитьВоВременноеХранилище(Новый ДвоичныеДанные(ИмяФайла), Новый УникальныйИдентификатор);	
КонецФункции

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	ПолучитьЭтикеткиДекларацииНаСервере();
	ПолучитьТехнологовНаСервере();
	Товары.Параметры.УстановитьЗначениеПараметра("Технолог", ПредопределенноеЗначение("Справочник.ФизическиеЛица.ПустаяСсылка"));
КонецПроцедуры

&НаКлиенте
Процедура УвеличитьКартинку(Команда)
	КартинкаВысотаЭтикетка = КартинкаВысотаЭтикетка+250;
	КартинкаЭтикетка();	
КонецПроцедуры
  
&НаСервере
Функция КартинкаНаСервере(СсылкаВоВременномХранилище)
возврат ПолучитьИзВременногоХранилища(СсылкаВоВременномХранилище);	
КонецФункции

&НаКлиенте
Процедура КартинкаЭтикетка()
	//ВыбраннаяЭтикетка = "";
	Если ЗначениеЗаполнено(ФайлЭтикетка) Тогда
		ВыбраннаяЭтикетка = "<html>
		|<body>
		|<div style = ""height: "+Формат(КартинкаВысотаЭтикетка,"ЧГ=")+"px;"">
		|<img src="""+ФайлЭтикетка+"""alt="""+Новый УникальныйИдентификатор()+""" style = ""height:100%"">
		|</div>
		|</body>
		|</html>";
	иначе
		ВыбраннаяЭтикетка = "<html>
		|<body>
		|<p>Этикетка отсутсвует
		|</body>
		|</html>";	
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура КартинкаДекларация()
	Если ЗначениеЗаполнено(ФайлДекларация) Тогда
		ВыбраннаяДекларация = "<html>
		|<body>
		|<div style = ""height: "+Формат(КартинкаВысотаДекларация,"ЧГ=")+"px;"">
		|<img src="""+ФайлДекларация+"""alt="""+Новый УникальныйИдентификатор()+""" style = ""height:100%"">
		|</div>
		|</body>
		|</html>";
	иначе
		ВыбраннаяДекларация = "<html>
		|<body>
		|<p>Декларация отсутсвует
		|</body>
		|</html>";	
	КонецЕсли;
	
КонецПроцедуры


&НаКлиенте
Процедура УменьшитьЭтикетку(Команда)
	КартинкаВысотаЭтикетка = КартинкаВысотаЭтикетка-250;
	КартинкаЭтикетка();
КонецПроцедуры

&НаКлиенте
Процедура ПервончальноеЗаполнениеКартинок()
	КартинкаВысотаЭтикетка = 750;
	КартинкаВысотаДекларация = 750;
	индЭтикетка = 0;
	индДекларация = 0;
	//Этикетки
	Этикеток = МассивНайденныхЭтикеток.Количество();
	Элементы.ЭтикеткаШт.Заголовок = строка(Этикеток)+" шт";
	Если Этикеток = 0 Тогда
		ФайлЭтикетка = Неопределено;
		Элементы.СледЭтикетка.Доступность = Ложь;
	иначе
		ФайлЭтикетка = МассивНайденныхЭтикеток[0].Файл;
		Если Этикеток > 1 Тогда
			Элементы.СледЭтикетка.Доступность = Истина;
		Иначе 
			Элементы.СледЭтикетка.Доступность = Ложь;
		КонецЕсли;
	КонецЕсли;	
	КартинкаЭтикетка();
	//Декларации
	Деклараций = МассивНайденныхДеклараций.Количество();
	Элементы.ДекларацияШт.Заголовок = строка(Деклараций)+" шт";
	Если Деклараций = 0 Тогда
		ФайлДекларация = Неопределено;
		Элементы.СледДекларация.Доступность = Ложь;
	иначе
		ФайлДекларация = МассивНайденныхДеклараций[0].Файл;
		Если Деклараций > 1 Тогда
			Элементы.СледДекларация.Доступность = Истина;
		Иначе 
			Элементы.СледДекларация.Доступность = Ложь;
		КонецЕсли;
	КонецЕсли;	
	КартинкаДекларация();
КонецПроцедуры


&НаКлиенте
Процедура УменьшитьДекларацию(Команда)
	КартинкаВысотаДекларация = КартинкаВысотаДекларация - 250;
	КартинкаДекларация();
КонецПроцедуры


&НаКлиенте
Процедура УвеличитьДекларацию(Команда)
	КартинкаВысотаДекларация = КартинкаВысотаДекларация + 250;
	КартинкаДекларация();
КонецПроцедуры


&НаКлиенте
Процедура СледЭтикеткаНажатие(Элемент)
	Если индЭтикетка = МассивНайденныхЭтикеток.Количество()-1 Тогда
		индЭтикетка = 0;
	иначе
		индЭтикетка = индЭтикетка + 1;
	КонецЕсли;
	ФайлЭтикетка = МассивНайденныхЭтикеток[индЭтикетка].Файл;
	КартинкаЭтикетка();
КонецПроцедуры


&НаКлиенте
Процедура СледДекларацияНажатие(Элемент)
	Если индДекларация = МассивНайденныхДеклараций.Количество()-1 Тогда
		индДекларация = 0;
	иначе
		индДекларация = индЭтикетка + 1;
	КонецЕсли;
	ФайлДекларация = МассивНайденныхДеклараций[индДекларация].Файл;
	КартинкаДекларация();
КонецПроцедуры


&НаКлиенте
Процедура ПовернутьНа90ПоЧасовойСтрелке(Команда)                           
	ПовернутьКартинку("Этикетка",2);
КонецПроцедуры

&НаКлиенте
Процедура ТоварыВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	ОткрытьЗначение(Элемент.ТекущиеДанные.Номенклатура);
КонецПроцедуры

&НаКлиенте
Процедура дкПовернутьНа180(Команда)
	ПовернутьКартинку("Декларация",3);
КонецПроцедуры

&НаКлиенте
Процедура дкПовернутьНа90ПоЧасовойСтрелке(Команда)
	ПовернутьКартинку("Декларация",2);
КонецПроцедуры

&НаКлиенте
Процедура дкПовернутьНа90ПротивЧасовойСтрелки(Команда)
	ПовернутьКартинку("Декларация",1);
КонецПроцедуры

&НаКлиенте
Процедура этПовернутьНа180(Команда)
	ПовернутьКартинку("Этикетка",3);
КонецПроцедуры

&НаКлиенте
Процедура этПовернутьНа90ПротивЧасовойСтрелки(Команда)
	ПовернутьКартинку("Этикетка",1);
КонецПроцедуры

&НаКлиенте
Процедура ПовернутьКартинку(ТипКартинки,Поворот)
	ИмяФайла = ЭтаФорма["Файл"+ТипКартинки];
	Файл = Новый Файл(ИмяФайла);
	ИмяКаталога = "\\server00\Temp\";
	Если Найти(ИмяФайла,ИмяКаталога) Тогда 
		ИмяВременногоФайла = ИмяФайла;
	иначе
		ИмяКаталога = "\\server00\Temp\";
		ИмяВременногоФайла = РаботаСФайлами.ПолучитьИмяФайла(ИмяКаталога, Строка(Новый УникальныйИдентификатор) + Файл.Расширение);
		КопироватьФайл(ЭтаФорма["Файл"+ТипКартинки],ИмяВременногоФайла);
	КонецЕсли;
	КомпонентаДопГрафика.ПовернутьИзображениеВФайле(ИмяВременногоФайла, Поворот);
	ЭтаФорма["Файл"+ТипКартинки] = ИмяВременногоФайла;
	Выполнить ("Картинка"+ТипКартинки+"()");
	//Элементы.ВыбраннаяЭтикетка.О ОбновитьОтображениеДанных();
КонецПроцедуры

&НаСервере
Процедура ПолучитьТехнологовНаСервере()
	Запрос = Новый Запрос;
	Запрос.Текст = "ВЫБРАТЬ
	|	РолиПользователейСоставРоли.Сотрудник,
	|	СоответствиеОбъектРольСрезПоследних.Период,
	|	СоответствиеОбъектРольСрезПоследних.ТипРоли,
	|	СоответствиеОбъектРольСрезПоследних.Объект,
	|	СоответствиеОбъектРольСрезПоследних.РольПользователя,
	|	СоответствиеОбъектРольСрезПоследних.ТипРолиID
	|ПОМЕСТИТЬ ВТ_ТаблицаТехнологов
	|ИЗ
	|	РегистрСведений.СоответствиеОбъектРоль.СрезПоследних КАК СоответствиеОбъектРольСрезПоследних
	|		ЛЕВОЕ СОЕДИНЕНИЕ Справочник.РолиПользователей.СоставРоли КАК РолиПользователейСоставРоли
	|		ПО (РолиПользователейСоставРоли.Ссылка = СоответствиеОбъектРольСрезПоследних.РольПользователя)
	|ГДЕ
	|	СоответствиеОбъектРольСрезПоследних.ТипРоли = ЗНАЧЕНИЕ(планвидовхарактеристик.ТипыРолейПользователя.ТехнологПоКачеству)
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	СписокНоменклатура.ГруппаНоменклатурыУРЗ КАК Группа,
	|	СписокНоменклатура.Родитель КАК Подгруппа,
	|	СписокНоменклатура.Ссылка КАК Номенклатура,
	|	ХарактеристикиНоменклатуры.Ссылка КАК Характеристика,
	|	СписокНоменклатура.Технолог,
	|	ВложенныйЗапрос.Значение КАК Производитель
	|ПОМЕСТИТЬ ВТ_СводнаяБезСотрудников
	|ИЗ
	|	Справочник.Номенклатура КАК СписокНоменклатура
	|		ЛЕВОЕ СОЕДИНЕНИЕ Справочник.ХарактеристикиНоменклатуры КАК ХарактеристикиНоменклатуры
	|			ЛЕВОЕ СОЕДИНЕНИЕ (ВЫБРАТЬ
	|				ЗначенияСвойствОбъектов.Объект КАК Объект,
	|				ЗначенияСвойствОбъектов.Значение КАК Значение
	|			ИЗ
	|				РегистрСведений.ЗначенияСвойствОбъектов КАК ЗначенияСвойствОбъектов
	|			ГДЕ
	|				ЗначенияСвойствОбъектов.Свойство = ЗНАЧЕНИЕ(планвидовхарактеристик.СвойстваОбъектов.Производитель)) КАК ВложенныйЗапрос
	|			ПО ХарактеристикиНоменклатуры.Ссылка = ВложенныйЗапрос.Объект
	|		ПО СписокНоменклатура.Ссылка = ХарактеристикиНоменклатуры.Владелец
	|ГДЕ
	|	НЕ СписокНоменклатура.Технолог = ЗНАЧЕНИЕ(Справочник.ФизическиеЛица.ПустаяСсылка)
	|	И НЕ СписокНоменклатура.Выведена
	|	И ХарактеристикиНоменклатуры.СтатусАктивностиХарактеристики = ЗНАЧЕНИЕ(Перечисление.СтатусыАктивностиХарактеристик.Активна)
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ВТ_СводнаяБезСотрудников.Характеристика КАК Характеристика,
	|	ЕСТЬNULL(ВТ_ТехнологиХарактеристика.Сотрудник, ВТ_ТехнологиПроизводитель.Сотрудник) КАК Технолог
	|ИЗ
	|	ВТ_СводнаяБезСотрудников КАК ВТ_СводнаяБезСотрудников
	|		ЛЕВОЕ СОЕДИНЕНИЕ ВТ_ТаблицаТехнологов КАК ВТ_ТехнологиХарактеристика
	|		ПО ВТ_СводнаяБезСотрудников.Характеристика = ВТ_ТехнологиХарактеристика.Объект
	|		ЛЕВОЕ СОЕДИНЕНИЕ ВТ_ТаблицаТехнологов КАК ВТ_ТехнологиПроизводитель
	|		ПО ВТ_СводнаяБезСотрудников.Производитель = ВТ_ТехнологиПроизводитель.Объект";
	ТаблицаТехнологов.Очистить();
	ТаблицаТехнологов.Загрузить(Запрос.Выполнить().Выгрузить());
	
КонецПроцедуры

&НаКлиенте
Процедура Обновить(Команда)
	ПолучитьЭтикеткиДекларацииНаСервере();
	ПолучитьТехнологовНаСервере();	
КонецПроцедуры

&НаКлиенте
Процедура ДоступностьМеток()
	Если Этикетка = ПредопределенноеЗначение("Перечисление.АК_ВидыСтатусовПроверкиИзображений.Проверено") и Декларация = ПредопределенноеЗначение("Перечисление.АК_ВидыСтатусовПроверкиИзображений.Проверено") Тогда
		Элементы.ГруппаМетки.Доступность = Истина;
	иначе
		Элементы.ГруппаМетки.Доступность = Ложь;
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура ДекларацияПриИзменении(Элемент)
	ДоступностьМеток();
КонецПроцедуры

&НаКлиенте
Процедура ЭтикеткаПриИзменении(Элемент)
	ДоступностьМеток();
КонецПроцедуры
