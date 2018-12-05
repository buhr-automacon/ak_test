﻿////////////////////////////////////////////////////////////////////////////////
// ЭКСПОРТИРУЕМЫЕ ПРОЦЕДУРЫ И ФУНКЦИИ

Функция ПрочитатьТаблицуКатегорийОбъекта()
	
	Запрос = Новый Запрос();

	Запрос.УстановитьПараметр("НазначениеКатегорий",     ОбщегоНазначения.ПолучитьСписокНазначенийСвойствКатегорийОбъектовПоСсылке(ОбъектОтбораКатегорий));
	Запрос.УстановитьПараметр("ОбъектОтбораКатегорий",   ОбъектОтбораКатегорий);

	Запрос.Текст = "
	|ВЫБРАТЬ РАЗЛИЧНЫЕ РАЗРЕШЕННЫЕ
	|	КатегорииОбъектов.Наименование                               КАК КатегорииОбъектовНаименование,
	|	КатегорииОбъектов.ПометкаУдаления                            КАК ПометкаУдаления,
	|	КатегорииОбъектов.Ссылка                                     КАК Категория,
	|
	|	ВЫБОР КОГДА
	|		РегистрСведений.КатегорииОбъектов.Объект ЕСТЬ НЕ NULL
	|	ТОГДА
	|		Истина
	|	ИНАЧЕ
	|		Ложь
	|	КОНЕЦ                                                        КАК Принадлежность
	|
	|ИЗ
	|// Отбираются категории, предназначенные для заданного типа объектов.
	|	(
	|	ВЫБРАТЬ 
	|		Справочник.КатегорииОбъектов.Ссылка          КАК Ссылка,
	|		Справочник.КатегорииОбъектов.Наименование    КАК Наименование,
	|		Справочник.КатегорииОбъектов.ПометкаУдаления КАК ПометкаУдаления
	|
	|	ИЗ
	|		Справочник.КатегорииОбъектов
	|
	|	ГДЕ
	|		Справочник.КатегорииОбъектов.НазначениеКатегории В ( &НазначениеКатегорий )
	|
	|	)                                                            КАК КатегорииОбъектов
	|
	|ЛЕВОЕ ВНЕШНЕЕ СОЕДИНЕНИЕ
	|// Присоединяются категории, назначенные для заданного объекта.
	|	РегистрСведений.КатегорииОбъектов
	|ПО
	|	РегистрСведений.КатегорииОбъектов.Категория = КатегорииОбъектов.Ссылка
	|	И
	|	РегистрСведений.КатегорииОбъектов.Объект = &ОбъектОтбораКатегорий
	|
	|УПОРЯДОЧИТЬ ПО
	|	КатегорииОбъектовНаименование
	|";
	
	ТабЗн = Запрос.Выполнить().Выгрузить();
	ТабЗн.Колонки.Удалить(0);
	
	Возврат ТабЗн;
	
КонецФункции

// Процедура заполняет табличную часть обработки категориями объекта.
// При заполнении используются значения реквизитов обработки: 
// ОбъектОтбораКатегорий - объект, категории которого отбираются.
// НазначениеКатегорий - значение реквизита, по которому отбораются категории.
//
// Параметры:
//  Нет.
//
Процедура ПрочитатьЗаполнитьКатегорииОбъекта() Экспорт

	КатегорииОбъекта.Загрузить(ПрочитатьТаблицуКатегорийОбъекта());

КонецПроцедуры

// Процедура открывает форму новой категории.
// Предназначена для вызова из обработчиков форм КатегорииОбъектаПередНачаломДобавления.
//
// Параметры:
//  Нет.
//
Процедура ОткрытьФормуНовойКатегории(ФормаВладелец) Экспорт

	ФормаНовойКатегории = Справочники.КатегорииОбъектов.ПолучитьФормуНовогоЭлемента(, ФормаВладелец, );

	НазначениеКатегорий = ОбщегоНазначения.ПолучитьСписокНазначенийСвойствКатегорийОбъектовПоСсылке(ОбъектОтбораКатегорий);
	Если НазначениеКатегорий.Количество() > 1 Тогда
		ВыбранныйЭлемент = НазначениеКатегорий.ВыбратьЭлемент("Выбор назначения категории");

		Если ВыбранныйЭлемент <> Неопределено Тогда
			
			ФормаНовойКатегории.НазначениеКатегории = ВыбранныйЭлемент.Значение;
			
		КонецЕсли;

	ИначеЕсли НазначениеКатегорий.Количество() = 1  Тогда
		
		ФормаНовойКатегории.НазначениеКатегории = НазначениеКатегорий[0].Значение;
		
	КонецЕсли;

	ФормаНовойКатегории.Открыть();

КонецПроцедуры

// Процедура проверяет, должна ли новая категория попасть в табличную часть обработки, 
// если да - добавляет категорию и активизирует соответствующую строку в табличном поле.
// Предназначена для вызова из обработчиков форм ОбработкаЗаписиНовогоОбъекта.
//
// Параметры:
//  Категория - добавляемая категория.
//  ТабличноеПоле - ТабличноеПоле, в котором надо активизировать строку.
//
Процедура ПроверитьДобавитьНовуюКатегорию(Категория, ТабличноеПоле) Экспорт

	Если ТипЗнч(НазначениеКатегорий) = Тип("СписокЗначений") Тогда
		Если НазначениеКатегорий.НайтиПоЗначению(Категория.НазначениеКатегории) = Неопределено Тогда
			Возврат;
		КонецЕсли;

	ИначеЕсли Категория.НазначениеКатегории <> НазначениеКатегорий Тогда
		Возврат;
	КонецЕсли;

	// Определение позиции категории в табличной части.

	Для Индекс = 0 По КатегорииОбъекта.Количество() - 1 Цикл
		Если Категория.Наименование < КатегорииОбъекта[Индекс].Категория.Наименование Тогда
			Прервать;
		КонецЕсли;
	КонецЦикла;

	// Вставка категории с соответствующую позицию.

	НоваяСтрока = КатегорииОбъекта.Вставить(Индекс);

	НоваяСтрока.ПометкаУдаления = Категория.ПометкаУдаления;
	НоваяСтрока.Категория       = Категория;
	НоваяСтрока.Принадлежность  = Истина;

	// Позиционирование курсора.

	ТабличноеПоле.ТекущаяСтрока = НоваяСтрока;

КонецПроцедуры

// Процедура снимает и устанавливает пометку удаления категории.
// Предназначена для вызова из обработчиков форм КатегорииОбъектаПередУдалением.
//
// Параметры:
//  ТекущаяСтрока - текущая строка табличной части.
//
Процедура ИнвертироватьПометкуУдаленияКатегории(ТекущаяСтрока) Экспорт

	ОбъектКатегория = ТекущаяСтрока.Категория.ПолучитьОбъект();

	Попытка
		ОбъектКатегория.УстановитьПометкуУдаления(НЕ ТекущаяСтрока.ПометкаУдаления, Истина);
	Исключение
		#Если Клиент Тогда
			Предупреждение("Не удалось изменить пометку удаления категории:" + Символы.ПС + ОписаниеОшибки());
		#КонецЕсли
	КонецПопытки;

	ТекущаяСтрока.ПометкаУдаления = ОбъектКатегория.ПометкаУдаления;

	//Если ТекущаяСтрока.ПометкаУдаления Тогда
	//	ТекущаяСтрока.Принадлежность = Ложь;
	//КонецЕсли;

КонецПроцедуры

// Функция записывеет категории объекта в информационную базу.
//
// Параметры:
//  Нет.
//
// Возвращаемое значение:
//  Истина - если категории объекта были записаны, или их не требуется записывать
//  Ложь   - если категории объекта не удалось записать.
//
Функция ЗаписатьКатегорииОбъекта() Экспорт

	НаборЗаписейКатегорииОбъекта = РегистрыСведений.КатегорииОбъектов.СоздатьНаборЗаписей();

	Для каждого Строка Из КатегорииОбъекта Цикл
		Если Строка.Принадлежность Тогда
			Запись = НаборЗаписейКатегорииОбъекта.Добавить();

			Запись.Объект    = ОбъектОтбораКатегорий;
			Запись.Категория = Строка.Категория;
		КонецЕсли;
	КонецЦикла;

	НаборЗаписейКатегорииОбъекта.Отбор.Объект.Установить(ОбъектОтбораКатегорий);

	Попытка
		НаборЗаписейКатегорииОбъекта.Записать();
	Исключение
		#Если Клиент Тогда
			Предупреждение("Не удалось записать категории объекта:" + Символы.ПС + ОписаниеОшибки());
		#КонецЕсли
		Возврат Ложь;
	КонецПопытки;

	Возврат Истина;

КонецФункции

Функция ЗначенияКатегорийМодифицированы() Экспорт

	ТаблицаКатегорий = КатегорииОбъекта.Выгрузить();
	ТаблицаКатегорий.Колонки.Удалить("НомерСтроки");
	
	ТаблицаЗапроса = ПрочитатьТаблицуКатегорийОбъекта();
	// Приведем типы Неопределено к Null
	Для каждого СтрокаТЗ Из ТаблицаЗапроса Цикл
		Для каждого КолонкаТЗ Из ТаблицаЗапроса.Колонки Цикл
			Если СтрокаТЗ[КолонкаТЗ.Имя] = Null Тогда
				СтрокаТЗ[КолонкаТЗ.Имя] = Неопределено;
			КонецЕсли; 
		КонецЦикла;
	КонецЦикла; 
	
	Возврат НЕ НастройкаПравДоступа.СравнитьТаблицыНаборовЗаписей(ТаблицаЗапроса, ТаблицаКатегорий);

КонецФункции // ЗначенияКатегорийМодифицированы()
