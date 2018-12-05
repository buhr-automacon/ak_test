﻿Перем СохраненнаяНастройка Экспорт;        // Текущий вариант отчета

Перем ТаблицаВариантовОтчета Экспорт;      // Таблица вариантов доступных текущему пользователю

Перем мПользователиИБ;
Перем мРолиПользователей;
Перем мРолиИБ;


Функция ПолучитьПользователяПоИмени(ИмяПользователяИБ)
	
	Запрос = Новый Запрос;
	
	ТекстЗапроса = "ВЫБРАТЬ ПЕРВЫЕ 1
	               |	Пользователи.Ссылка
	               |ИЗ
	               |	Справочник.Пользователи КАК Пользователи
	               |ГДЕ
	               |	Пользователи.ЭтоГруппа = ЛОЖЬ
	               |	И Пользователи.Код = &Код";
	 
	Запрос.Текст = ТекстЗапроса;
	Запрос.УстановитьПараметр("Код", ИмяПользователяИБ);
	Результат = Запрос.Выполнить();
	Выборка = Результат.Выбрать();
	
	Пользователь = Неопределено;
	Если Выборка.Следующий() Тогда
		Пользователь = Выборка.Ссылка;
	КонецЕсли;
	
	Возврат Пользователь;

КонецФункции // ПолучитьПользователяПоИмени

Процедура СформироватьТаблицуПользователиИБ()
	
	мПользователиИБ = Новый ТаблицаЗначений;
	мПользователиИБ.Колонки.Добавить("ИмяПользователяИБ", Новый ОписаниеТипов("Строка",, Новый КвалификаторыСтроки(50)));
	мПользователиИБ.Колонки.Добавить("ПолноеИмяПользователяИБ", Новый ОписаниеТипов("Строка",, Новый КвалификаторыСтроки(100)));
	
	мРолиПользователей = Новый ТаблицаЗначений;
	мРолиПользователей.Колонки.Добавить("Пользователь", Новый ОписаниеТипов("СправочникСсылка.Пользователи"));
	мРолиПользователей.Колонки.Добавить("РольПользователя", Новый ОписаниеТипов("Строка",, Новый КвалификаторыСтроки(100)));
	мРолиПользователей.Колонки.Добавить("ПредставлениеРолиПользователя", Новый ОписаниеТипов("Строка",, Новый КвалификаторыСтроки(100)));

	Для каждого ЭлКоллекции Из ПользователиИнформационнойБазы.ПолучитьПользователей() Цикл
		НовыйПользователь = мПользователиИБ.Добавить();
		НовыйПользователь.ИмяПользователяИБ       = СокрЛП(ЭлКоллекции.Имя);
		НовыйПользователь.ПолноеИмяПользователяИБ = СокрЛП(ЭлКоллекции.ПолноеИмя);
		
		Пользователь = ПолучитьПользователяПоИмени(СокрЛП(ЭлКоллекции.Имя));
		Если Пользователь <> Неопределено Тогда
			Для каждого ЭлРоль Из ЭлКоллекции.Роли Цикл
				НоваяРоль = мРолиПользователей.Добавить();
				НоваяРоль.Пользователь = Пользователь;
				НоваяРоль.РольПользователя = ЭлРоль.Имя;
				НоваяРоль.ПредставлениеРолиПользователя = ЭлРоль.Синоним;
			КонецЦикла; 
		КонецЕсли; 
	КонецЦикла; 
	
КонецПроцедуры // СформироватьТаблицуПользователиИБ

Процедура СформироватьТаблицуРолиИБ()
	
	мРолиИБ = Новый ТаблицаЗначений;
	мРолиИБ.Колонки.Добавить("РольИБ");
	мРолиИБ.Колонки.Добавить("ПредставлениеРолиИБ");
	мРолиИБ.Колонки.Добавить("ПорядокРолиИБ");
	
	ПорядокРоли = 1;
	Для каждого ЭлКоллекции Из Метаданные.Роли Цикл
		НоваяРоль = мРолиИБ.Добавить();
		НоваяРоль.РольИБ              = ЭлКоллекции.Имя;
		НоваяРоль.ПредставлениеРолиИБ = ЭлКоллекции.Синоним;
		НоваяРоль.ПорядокРолиИБ       = ПорядокРоли;
		
		ПорядокРоли = ПорядокРоли + 1;
	КонецЦикла;

КонецПроцедуры // СформироватьТаблицуРолиИБ
                           
Функция ПолучитьВнешниеДанные()
	
	ВнешниеНаборыДанных = Новый Структура;
	
	ВнешниеНаборыДанных.Вставить("ПользователиИБ", мПользователиИБ);
	ВнешниеНаборыДанных.Вставить("РолиИБ", мРолиИБ);
	ВнешниеНаборыДанных.Вставить("РолиПользователей", мРолиПользователей);
	
	Возврат ВнешниеНаборыДанных;
	
КонецФункции // УстановитьВнешниеДанные


#Если Клиент ИЛИ ВнешнееСоединение Тогда
	
Функция СформироватьОтчет(Результат = Неопределено, ДанныеРасшифровки = Неопределено, ВыводВФормуОтчета = Истина) Экспорт
	
	ВнешниеНаборыДанных = ПолучитьВнешниеДанные();
	
	НастрокаПоУмолчанию = КомпоновщикНастроек.ПолучитьНастройки();
	
	ТиповыеОтчеты.ПолучитьПримененуюНастройку(ЭтотОбъект);
	ТиповыеОтчеты.СформироватьТиповойОтчет(ЭтотОбъект, Результат, ДанныеРасшифровки, ВыводВФормуОтчета, ВнешниеНаборыДанных);
	
	КомпоновщикНастроек.ЗагрузитьНастройки(НастрокаПоУмолчанию);
		
КонецФункции

Процедура СохранитьНастройку() Экспорт

	СтруктураНастроек = ТиповыеОтчеты.ПолучитьСтруктуруПараметровТиповогоОтчета(ЭтотОбъект);
	СохранениеНастроек.СохранитьНастройкуОбъекта(СохраненнаяНастройка, СтруктураНастроек);
	
КонецПроцедуры

Процедура ПрименитьНастройку() Экспорт
	
	Схема = ТиповыеОтчеты.ПолучитьСхемуКомпоновкиОбъекта(ЭтотОбъект);

	// Считываение структуры настроек отчета
 	Если Не СохраненнаяНастройка.Пустая() Тогда
		
		СтруктураНастроек = СохраненнаяНастройка.ХранилищеНастроек.Получить();
		Если Не СтруктураНастроек = Неопределено Тогда
			КомпоновщикНастроек.ЗагрузитьНастройки(СтруктураНастроек.НастройкиКомпоновщика);
			ЗаполнитьЗначенияСвойств(ЭтотОбъект, СтруктураНастроек);
		Иначе
			КомпоновщикНастроек.ЗагрузитьНастройки(Схема.НастройкиПоУмолчанию);
		КонецЕсли;
		
	Иначе
		КомпоновщикНастроек.ЗагрузитьНастройки(Схема.НастройкиПоУмолчанию);
	КонецЕсли;

КонецПроцедуры

Функция ПолучитьПараметрыИсполненияОтчета() Экспорт
	
	СтруктураНатроек = Новый Структура();
	Возврат СтруктураНатроек;
	
КонецФункции
	
#КонецЕсли

#Если Клиент Тогда
	
// Настройка отчета при отработки расшифровки
Процедура Настроить(Отбор) Экспорт
	
	// Настройка отбора
	Для каждого ЭлементОтбора Из Отбор Цикл
		
		Если ТипЗнч(ЭлементОтбора) = Тип("ЭлементОтбораКомпоновкиДанных") Тогда
			ПолеОтбора = ЭлементОтбора.ЛевоеЗначение;
		Иначе
			ПолеОтбора = Новый ПолеКомпоновкиДанных(ЭлементОтбора.Поле);
		КонецЕсли;
		
		Если КомпоновщикНастроек.Настройки.ДоступныеПоляОтбора.НайтиПоле(ПолеОтбора) = Неопределено Тогда
			Продолжить;
		КонецЕсли;
		
		НовыйЭлементОтбора = КомпоновщикНастроек.Настройки.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
		Если ТипЗнч(ЭлементОтбора) = Тип("ЭлементОтбораКомпоновкиДанных") Тогда
			ЗаполнитьЗначенияСвойств(НовыйЭлементОтбора, ЭлементОтбора);
		Иначе
			НовыйЭлементОтбора.Использование  = Истина;
			НовыйЭлементОтбора.ЛевоеЗначение  = ПолеОтбора;
			Если ЭлементОтбора.Иерархия Тогда
				Если ТипЗнч(ЭлементОтбора.Значение) = Тип("СписокЗначений") Тогда
					НовыйЭлементОтбора.ВидСравнения = ВидСравненияКомпоновкиДанных.ВСпискеПоИерархии;
				Иначе
					НовыйЭлементОтбора.ВидСравнения = ВидСравненияКомпоновкиДанных.ВИерархии;
				КонецЕсли;
			Иначе
				Если ТипЗнч(ЭлементОтбора.Значение) = Тип("СписокЗначений") Тогда
					НовыйЭлементОтбора.ВидСравнения = ВидСравненияКомпоновкиДанных.ВСписке;
				Иначе
					НовыйЭлементОтбора.ВидСравнения = ВидСравненияКомпоновкиДанных.Равно;
				КонецЕсли;
			КонецЕсли;
			
			НовыйЭлементОтбора.ПравоеЗначение = ЭлементОтбора.Значение;
			
		КонецЕсли;
				
	КонецЦикла;
	
	ТиповыеОтчеты.УдалитьДублиОтбора(КомпоновщикНастроек);
	
КонецПроцедуры

#КонецЕсли

// Процедура запускается каждый раз перед формированием отчета. В ней содержиться код который обрабатывает настройки отчета 
// перед формированим отчета. К примеру подстановка периода отчета по умолчанию если пользователь не задал не период в отчете
Процедура ДоработатьКомпоновщикПередВыводом() Экспорт
	
КонецПроцедуры


Процедура ИнициализацияОтчета()

	СформироватьТаблицуПользователиИБ();
	СформироватьТаблицуРолиИБ();
	
	СписокРолей = Новый СписокЗначений;
	Для каждого ЭлКоллекции Из мРолиИБ Цикл
		СписокРолей.Добавить(ЭлКоллекции.РольИБ, ЭлКоллекции.ПредставлениеРолиИБ);
	КонецЦикла;
	
	ПолеСхемы = СхемаКомпоновкиДанных.НаборыДанных["ЗапросПользователи"].Поля.Найти("РольПрофиля");
	ПолеСхемы.УстановитьДоступныеЗначения(СписокРолей);
	
	ПолеСхемы = СхемаКомпоновкиДанных.НаборыДанных["РолиПользователей"].Поля.Найти("РольПользователя");
	ПолеСхемы.УстановитьДоступныеЗначения(СписокРолей);
	
КонецПроцедуры // ИнициализацияОтчета
 

ИнициализацияОтчета();


Если СохраненнаяНастройка = Неопределено Тогда
	СохраненнаяНастройка =  Справочники.СохраненныеНастройки.ПустаяСсылка();
КонецЕсли;
