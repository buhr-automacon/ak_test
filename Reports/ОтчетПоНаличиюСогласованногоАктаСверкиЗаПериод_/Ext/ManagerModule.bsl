﻿
Функция ПолучитьТаблицу(СтруктураПараметров, МассивОрганизацийВкл, МассивКонтрагентовВкл, МассивОрганизацийИскл, МассивКонтрагентовИскл) Экспорт
	
	ЕстьОтборПоОрганизацииВкл 	= (МассивОрганизацийВкл.Количество() > 0);
	ЕстьОтборПоОрганизацииИскл 	= (МассивОрганизацийискл.Количество() > 0);
	ЕстьОтборПоКонтрагентуВкл 	= (МассивКонтрагентовВкл.Количество() > 0);
	ЕстьОтборПоКонтрагентуИскл 	= (МассивКонтрагентовИскл.Количество() > 0);
	
	
	/////////////////////////////////////////////////////////////////////////////////////////////
	// Запрос к Бух Корп
	СтрокаПодключения = ПолныеПрава.ПолучитьСтрокуПодключения_Бух();
	
	v82COMОбъект = Новый COMОбъект(ПолныеПрава.ПолучитьВерсиюКомОбъекта_Бух() + ".COMConnector");
	Попытка
		БухКорп = v82COMОбъект.Connect(СтрокаПодключения);
	Исключение
		Сообщить("Не удалось подключиться к базе бухгалтерии");
		Возврат Неопределено;
	КонецПопытки;
	
	Запрос = БухКорп.NewObject("Запрос");  
	Запрос.УстановитьПараметр("Счет"			, БухКорп.ПланыСчетов.Хозрасчетный.НайтиПоКоду(СтруктураПараметров.Счет.Код));
	Запрос.УстановитьПараметр("ДатаОкончания"	, СтруктураПараметров.ДатаОкончания);
	ТекстЗапроса = "";
	Если ЕстьОтборПоОрганизацииВкл Тогда
		МассивИННОрганизаций = БухКорп.NewObject("Массив");
		Для Каждого ЭлементМассива Из МассивОрганизацийВкл Цикл
			МассивИННОрганизаций.Добавить(ЭлементМассива.ИНН);
		КонецЦикла;	
		Запрос.УстановитьПараметр("МассивИННОрганизацийВкл"	, МассивИННОрганизаций);
	КонецЕсли;
	Если ЕстьОтборПоОрганизацииИскл Тогда
		МассивИННОрганизаций = БухКорп.NewObject("Массив");
		Для Каждого ЭлементМассива Из МассивОрганизацийИскл Цикл
			МассивИННОрганизаций.Добавить(ЭлементМассива.ИНН);
		КонецЦикла;	
		Запрос.УстановитьПараметр("МассивИННОрганизацийИскл", МассивИННОрганизаций);
	КонецЕсли;
	Если ЕстьОтборПоКонтрагентуВкл Тогда
		ТаблицаКонтрВкл = БухКорп.NewObject("ТаблицаЗначений");
		ТаблицаКонтрВкл.Колонки.Добавить("ИНН", БухКорп.NewObject("ОписаниеТипов", "Строка", БухКорп.NewObject("КвалификаторыСтроки", 12)));
		ТаблицаКонтрВкл.Колонки.Добавить("КПП", БухКорп.NewObject("ОписаниеТипов", "Строка", БухКорп.NewObject("КвалификаторыСтроки", 9)));
		Для Каждого ЭлементМассива Из МассивКонтрагентовВкл Цикл
			НоваяСтрока = ТаблицаКонтрВкл.Добавить();
			НоваяСтрока.ИНН = ЭлементМассива.ИНН;
			НоваяСтрока.КПП = ЭлементМассива.КПП;
		КонецЦикла;	
		Запрос.УстановитьПараметр("ТаблицаКонтрВкл", ТаблицаКонтрВкл);
		
		ТекстЗапроса = ТекстЗапроса +
		"ВЫБРАТЬ 
		|	ТаблицаКонтрВкл.ИНН КАК ИНН,
		|	ТаблицаКонтрВкл.КПП КАК КПП
		|ПОМЕСТИТЬ ВТТаблицаКонтрВкл
		|ИЗ
		|	&ТаблицаКонтрВкл КАК ТаблицаКонтрВкл
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ 
		|	СпрКонтрагенты.Ссылка КАК Контрагент
		|ПОМЕСТИТЬ ВТКонтрагентыВкл
		|ИЗ
		|	Справочник.Контрагенты КАК СпрКонтрагенты
		|ВНУТРЕННЕЕ СОЕДИНЕНИЕ ВТТаблицаКонтрВкл КАК ВТТаблицаКонтрВкл_
		|	ПО ВТТаблицаКонтрВкл_.ИНН = СпрКонтрагенты.ИНН
		|	И ВТТаблицаКонтрВкл_.КПП = СпрКонтрагенты.КПП
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|";
	КонецЕсли;
	Если ЕстьОтборПоКонтрагентуИскл Тогда
		ТаблицаКонтрИскл = БухКорп.NewObject("ТаблицаЗначений");
		ТаблицаКонтрИскл.Колонки.Добавить("ИНН", БухКорп.NewObject("ОписаниеТипов", "Строка", БухКорп.NewObject("КвалификаторыСтроки", 12)));
		ТаблицаКонтрИскл.Колонки.Добавить("КПП", БухКорп.NewObject("ОписаниеТипов", "Строка", БухКорп.NewObject("КвалификаторыСтроки", 9)));
		Для Каждого ЭлементМассива Из МассивКонтрагентовИскл Цикл
			НоваяСтрока = ТаблицаКонтрИскл.Добавить();
			НоваяСтрока.ИНН = ЭлементМассива.ИНН;
			НоваяСтрока.КПП = ЭлементМассива.КПП;
		КонецЦикла;	
		Запрос.УстановитьПараметр("ТаблицаКонтрИскл", ТаблицаКонтрИскл);
		
		ТекстЗапроса = ТекстЗапроса +
		"ВЫБРАТЬ 
		|	ТаблицаКонтрИскл.ИНН КАК ИНН,
		|	ТаблицаКонтрИскл.КПП КАК КПП
		|ПОМЕСТИТЬ ВТТаблицаКонтрИскл
		|ИЗ
		|	&ТаблицаКонтрИскл КАК ТаблицаКонтрИскл
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ 
		|	СпрКонтрагенты.Ссылка КАК Контрагент
		|ПОМЕСТИТЬ ВТКонтрагентыИскл
		|ИЗ
		|	Справочник.Контрагенты КАК СпрКонтрагенты
		|ВНУТРЕННЕЕ СОЕДИНЕНИЕ ВТТаблицаКонтрИскл КАК ВТТаблицаКонтрИскл
		|	ПО ВТТаблицаКонтрИскл.ИНН = СпрКонтрагенты.ИНН
		|	И ВТТаблицаКонтрИскл.КПП = СпрКонтрагенты.КПП
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|";
	КонецЕсли;
	ТекстЗапроса = ТекстЗапроса +
	"ВЫБРАТЬ РАЗЛИЧНЫЕ
	|	ТЧСписокСчетов.Ссылка.Организация КАК Организация,
	|	ТЧСписокСчетов.Ссылка.Контрагент КАК Контрагент,
	|	ТЧСписокСчетов.Ссылка КАК Ссылка,
	|	ТЧСписокСчетов.Ссылка.Дата КАК Дата,
	|	ТЧСписокСчетов.Ссылка.ДатаОкончания КАК ДатаОкончания
	|ПОМЕСТИТЬ АктыСверки_До__
	|ИЗ
	|	Документ.АктСверкиВзаиморасчетов.СписокСчетов КАК ТЧСписокСчетов
	|ГДЕ
	|	ТЧСписокСчетов.Счет В ИЕРАРХИИ(&Счет)
	|	И ТЧСписокСчетов.УчаствуетВРасчетах
	|	И &Условие1
	|	И НЕ ТЧСписокСчетов.Ссылка.ДатаОкончания > &ДатаОкончания
	|	И ТЧСписокСчетов.Ссылка.СверкаСогласована
	|	И НЕ ТЧСписокСчетов.Ссылка.ПометкаУдаления
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	АктыСверки_До__.Организация КАК Организация,
	|	АктыСверки_До__.Контрагент КАК Контрагент,
	|	АктыСверки_До__.Ссылка КАК Ссылка,
	|	АктыСверки_До__.Дата КАК Дата
	|ПОМЕСТИТЬ АктыСверки_До_
	|ИЗ
	|	АктыСверки_До__ КАК АктыСверки_До__
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ (ВЫБРАТЬ
	|			АктыСверки_До__.Организация КАК Организация,
	|			АктыСверки_До__.Контрагент КАК Контрагент,
	|			МАКСИМУМ(АктыСверки_До__.ДатаОкончания) КАК ДатаОкончания
	|		ИЗ
	|			АктыСверки_До__ КАК АктыСверки_До__
	|		
	|		СГРУППИРОВАТЬ ПО
	|			АктыСверки_До__.Организация,
	|			АктыСверки_До__.Контрагент) КАК МаксДатыОкончания
	|		ПО (МаксДатыОкончания.Организация = АктыСверки_До__.Организация)
	|			И (МаксДатыОкончания.Контрагент = АктыСверки_До__.Контрагент)
	|			И (МаксДатыОкончания.ДатаОкончания = АктыСверки_До__.ДатаОкончания)
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	АктыСверки_До_.Организация КАК Организация,
	|	АктыСверки_До_.Контрагент КАК Контрагент,
	|	АктыСверки_До_.Ссылка КАК Ссылка
	|ПОМЕСТИТЬ АктыСверки_До
	|ИЗ
	|	АктыСверки_До_ КАК АктыСверки_До_
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ (ВЫБРАТЬ
	|			АктыСверки_До_.Организация КАК Организация,
	|			АктыСверки_До_.Контрагент КАК Контрагент,
	|			МАКСИМУМ(АктыСверки_До_.Дата) КАК Дата
	|		ИЗ
	|			АктыСверки_До_ КАК АктыСверки_До_
	|		
	|		СГРУППИРОВАТЬ ПО
	|			АктыСверки_До_.Организация,
	|			АктыСверки_До_.Контрагент) КАК МаксДаты
	|		ПО (МаксДаты.Организация = АктыСверки_До_.Организация)
	|			И (МаксДаты.Контрагент = АктыСверки_До_.Контрагент)
	|			И (МаксДаты.Дата = АктыСверки_До_.Дата)
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ РАЗЛИЧНЫЕ
	|	ТЧСписокСчетов.Ссылка.Организация КАК Организация,
	|	ТЧСписокСчетов.Ссылка.Контрагент КАК Контрагент,
	|	ТЧСписокСчетов.Ссылка КАК Ссылка,
	|	ТЧСписокСчетов.Ссылка.Дата КАК Дата,
	|	ТЧСписокСчетов.Ссылка.ДатаОкончания КАК ДатаОкончания
	|ПОМЕСТИТЬ АктыСверки_После__
	|ИЗ
	|	Документ.АктСверкиВзаиморасчетов.СписокСчетов КАК ТЧСписокСчетов
	|ГДЕ
	|	ТЧСписокСчетов.Счет В ИЕРАРХИИ(&Счет)
	|	И ТЧСписокСчетов.УчаствуетВРасчетах
	|	И &Условие1
	|	И ТЧСписокСчетов.Ссылка.ДатаОкончания > &ДатаОкончания
	|	И ТЧСписокСчетов.Ссылка.СверкаСогласована
	|	И НЕ ТЧСписокСчетов.Ссылка.ПометкаУдаления
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	АктыСверки_После__.Организация КАК Организация,
	|	АктыСверки_После__.Контрагент КАК Контрагент,
	|	АктыСверки_После__.Ссылка КАК Ссылка,
	|	АктыСверки_После__.Дата КАК Дата
	|ПОМЕСТИТЬ АктыСверки_После_
	|ИЗ
	|	АктыСверки_После__ КАК АктыСверки_После__
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ (ВЫБРАТЬ
	|			АктыСверки_После__.Организация КАК Организация,
	|			АктыСверки_После__.Контрагент КАК Контрагент,
	|			МИНИМУМ(АктыСверки_После__.ДатаОкончания) КАК ДатаОкончания
	|		ИЗ
	|			АктыСверки_После__ КАК АктыСверки_После__
	|		
	|		СГРУППИРОВАТЬ ПО
	|			АктыСверки_После__.Организация,
	|			АктыСверки_После__.Контрагент) КАК МаксДатыОкончания
	|		ПО (МаксДатыОкончания.Организация = АктыСверки_После__.Организация)
	|			И (МаксДатыОкончания.Контрагент = АктыСверки_После__.Контрагент)
	|			И (МаксДатыОкончания.ДатаОкончания = АктыСверки_После__.ДатаОкончания)
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	АктыСверки_После_.Организация.ИНН КАК ИННОрганизации,
	|	АктыСверки_После_.Контрагент.ИНН КАК ИННКонтрагента,
	|	АктыСверки_После_.Контрагент.КПП КАК КППКонтрагента,
	|	АктыСверки_После_.Ссылка.Номер КАК Номер,
	|	АктыСверки_После_.Дата КАК Дата
	|ИЗ
	|	АктыСверки_После_ КАК АктыСверки_После_
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ (ВЫБРАТЬ
	|			АктыСверки_После_.Организация КАК Организация,
	|			АктыСверки_После_.Контрагент КАК Контрагент,
	|			МИНИМУМ(АктыСверки_После_.Дата) КАК Дата
	|		ИЗ
	|			АктыСверки_После_ КАК АктыСверки_После_
	|		
	|		СГРУППИРОВАТЬ ПО
	|			АктыСверки_После_.Организация,
	|			АктыСверки_После_.Контрагент) КАК МаксДаты
	|		ПО (МаксДаты.Организация = АктыСверки_После_.Организация)
	|			И (МаксДаты.Контрагент = АктыСверки_После_.Контрагент)
	|			И (МаксДаты.Дата = АктыСверки_После_.Дата)
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	АктСверкиВзаиморасчетов.Организация.ИНН КАК ИННОрганизации,
	|	АктСверкиВзаиморасчетов.Контрагент.ИНН КАК ИННКонтрагента,
	|	АктСверкиВзаиморасчетов.Контрагент.КПП КАК КППКонтрагента,
	|	ВЫБОР
	|		КОГДА ВТМаксПериоды.Период ЕСТЬ NULL 
	|				ИЛИ НЕ ВТМаксПериоды.Период > КОНЕЦПЕРИОДА(АктСверкиВзаиморасчетов.Ссылка.ДатаОкончания, ДЕНЬ)
	|			ТОГДА 1
	|		ИНАЧЕ 0
	|	КОНЕЦ КАК НеПоследний,
	|	АктСверкиВзаиморасчетов.Ссылка.Номер КАК Номер,
	|	АктСверкиВзаиморасчетов.Ссылка.Дата КАК Дата
	|ИЗ
	|	АктыСверки_До КАК АктСверкиВзаиморасчетов
	|		ЛЕВОЕ СОЕДИНЕНИЕ (ВЫБРАТЬ
	|			ХозрасчетныйОстаткиИОбороты.Организация КАК Организация,
	|			ХозрасчетныйОстаткиИОбороты.Субконто1 КАК Контрагент,
	|			МАКСИМУМ(ХозрасчетныйОстаткиИОбороты.Период) КАК Период
	|		ИЗ
	|			РегистрБухгалтерии.Хозрасчетный.ОстаткиИОбороты(, &ДатаОкончания, Регистратор, , Счет В ИЕРАРХИИ (&Счет), , &Условие2) КАК ХозрасчетныйОстаткиИОбороты
	|		
	|		СГРУППИРОВАТЬ ПО
	|			ХозрасчетныйОстаткиИОбороты.Организация,
	|			ХозрасчетныйОстаткиИОбороты.Субконто1) КАК ВТМаксПериоды
	|		ПО (ВТМаксПериоды.Организация = АктСверкиВзаиморасчетов.Организация)
	|			И (ВТМаксПериоды.Контрагент = АктСверкиВзаиморасчетов.Контрагент)";
	
	ТекстУсловия1 = "";
	ТекстУсловия2 = "ИСТИНА";
	Если ЕстьОтборПоОрганизацииВкл Тогда
		ТекстУсловия1 = ТекстУсловия1 + "И ТЧСписокСчетов.Ссылка.Организация.ИНН В (&МассивИННОрганизацийВкл)";
		ТекстУсловия2 = ТекстУсловия2 + " И Организация.ИНН В (&МассивИННОрганизацийВкл)";
	КонецЕсли;
	Если ЕстьОтборПоОрганизацииИскл Тогда
		ТекстУсловия1 = ТекстУсловия1 + " И НЕ ТЧСписокСчетов.Ссылка.Организация.ИНН В (&МассивИННОрганизацийИскл)";
		ТекстУсловия2 = ТекстУсловия2 + " И НЕ Организация.ИНН В (&МассивИННОрганизацийИскл)";
	КонецЕсли;
	Если ЕстьОтборПоКонтрагентуВкл Тогда
		ТекстУсловия1 = ТекстУсловия1 + " И ТЧСписокСчетов.Ссылка.Контрагент В (ВЫБРАТЬ Контрагент ИЗ ВТКонтрагентыВкл)";
		ТекстУсловия2 = ТекстУсловия2 + " И Субконто1 В (ВЫБРАТЬ Контрагент ИЗ ВТКонтрагентыВкл)";
	КонецЕсли;
	Если ЕстьОтборПоКонтрагентуИскл Тогда
		ТекстУсловия1 = ТекстУсловия1 + " И НЕ ТЧСписокСчетов.Ссылка.Контрагент В (ВЫБРАТЬ Контрагент ИЗ ВТКонтрагентыИскл)";
		ТекстУсловия2 = ТекстУсловия2 + " И НЕ Субконто1 В (ВЫБРАТЬ Контрагент ИЗ ВТКонтрагентыИскл)";
	КонецЕсли;
	ТекстЗапроса = СтрЗаменить(ТекстЗапроса, "И &Условие1"	, ТекстУсловия1);
	ТекстЗапроса = СтрЗаменить(ТекстЗапроса, "&Условие2"	, ТекстУсловия2);
	
	Запрос.Текст = ТекстЗапроса;
	
	Попытка
		РезультатыЗапроса = Запрос.ВыполнитьПакет();
		
		Ном1 = 1;
		Если ЕстьОтборПоКонтрагентуВкл Тогда
			Ном1 = Ном1 + 2;
		КонецЕсли;
		Если ЕстьОтборПоКонтрагентуИскл Тогда
			Ном1 = Ном1 + 2;
		КонецЕсли;
		АктыБух_До_ 	= РезультатыЗапроса.Получить(Ном1 + 5).Выгрузить();
		АктыБух_После_ 	= РезультатыЗапроса.Получить(Ном1 + 4).Выгрузить();
	Исключение
		БухКорп 		= Неопределено;
		v82COMОбъект 	= Неопределено;
		Сообщить(ОписаниеОшибки());
		Возврат Неопределено;
	КонецПопытки;
	
	БухКорп 		= Неопределено;
	v82COMОбъект 	= Неопределено;
	
	
	АктыБух_До = Новый ТаблицаЗначений;
	АктыБух_До.Колонки.Добавить("ДокАкт"		, Новый ОписаниеТипов("Строка"));
	АктыБух_До.Колонки.Добавить("ИННОрганизации", Новый ОписаниеТипов("Строка"	, Новый КвалификаторыСтроки(12)));
	АктыБух_До.Колонки.Добавить("ИННКонтрагента", Новый ОписаниеТипов("Строка"	, Новый КвалификаторыСтроки(12)));
	АктыБух_До.Колонки.Добавить("КППКонтрагента", Новый ОписаниеТипов("Строка"	, Новый КвалификаторыСтроки(9)));
	АктыБух_До.Колонки.Добавить("НеПоследний"	, Новый ОписаниеТипов("Число"	, Новый КвалификаторыЧисла(1, 0)));
	Для Каждого СтрокаТаблицы Из АктыБух_До_ Цикл
		НоваяСтрока = АктыБух_До.Добавить();
		ЗаполнитьЗначенияСвойств(НоваяСтрока, СтрокаТаблицы);
		НоваяСтрока.ДокАкт = СтрокаТаблицы.Номер + " от " + Формат(СтрокаТаблицы.Дата, "ДЛФ=Д");
	КонецЦикла;
	
	АктыБух_После = Новый ТаблицаЗначений;
	АктыБух_После.Колонки.Добавить("ДокАкт"			, Новый ОписаниеТипов("Строка"));
	АктыБух_После.Колонки.Добавить("ИННОрганизации"	, Новый ОписаниеТипов("Строка", Новый КвалификаторыСтроки(12)));
	АктыБух_После.Колонки.Добавить("ИННКонтрагента"	, Новый ОписаниеТипов("Строка", Новый КвалификаторыСтроки(12)));
	АктыБух_После.Колонки.Добавить("КППКонтрагента"	, Новый ОписаниеТипов("Строка", Новый КвалификаторыСтроки(9)));
	Для Каждого СтрокаТаблицы Из АктыБух_После_ Цикл
		НоваяСтрока = АктыБух_После.Добавить();
		ЗаполнитьЗначенияСвойств(НоваяСтрока, СтрокаТаблицы);
		НоваяСтрока.ДокАкт = СтрокаТаблицы.Номер + " от " + Формат(СтрокаТаблицы.Дата, "ДЛФ=Д");
	КонецЦикла;
	
	/////////////////////////////////////////////////////////////////////////////////////////////
	// Запрос к финансам
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("ДатаНачала"		, СтруктураПараметров.ДатаНачала);
	Запрос.УстановитьПараметр("ДатаОкончания"	, СтруктураПараметров.ДатаОкончания);
	Запрос.УстановитьПараметр("Счет"			, СтруктураПараметров.Счет);
	Запрос.УстановитьПараметр("АктыБух_До"		, АктыБух_До);
	Запрос.УстановитьПараметр("АктыБух_После"	, АктыБух_После);
	Если ЕстьОтборПоОрганизацииВкл Тогда
		Запрос.УстановитьПараметр("МассивОрганизацийВкл"	, МассивОрганизацийВкл);
	КонецЕсли;
	Если ЕстьОтборПоОрганизацииИскл Тогда
		Запрос.УстановитьПараметр("МассивОрганизацийИскл"	, МассивОрганизацийИскл);
	КонецЕсли;
	Если ЕстьОтборПоКонтрагентуВкл Тогда
		Запрос.УстановитьПараметр("МассивКонтрагентовВкл"	, МассивКонтрагентовВкл);
	КонецЕсли;
	Если ЕстьОтборПоКонтрагентуИскл Тогда
		Запрос.УстановитьПараметр("МассивКонтрагентовИскл"	, МассивКонтрагентовИскл);
	КонецЕсли;
	
	ТекстЗапроса =
	"ВЫБРАТЬ РАЗЛИЧНЫЕ
	|	ТЧСписокСчетов.Ссылка.Организация КАК Организация,
	|	ТЧСписокСчетов.Ссылка.Контрагент КАК Контрагент,
	|	ТЧСписокСчетов.Ссылка КАК Ссылка,
	|	ТЧСписокСчетов.Ссылка.Дата КАК Дата,
	|	ТЧСписокСчетов.Ссылка.ДатаОкончания КАК ДатаОкончания
	|ПОМЕСТИТЬ АктыСверки_До__
	|ИЗ
	|	Документ.АктСверкиВзаиморасчетов.СписокСчетов КАК ТЧСписокСчетов
	|ГДЕ
	|	ТЧСписокСчетов.Счет В ИЕРАРХИИ(&Счет)
	|	И ТЧСписокСчетов.УчаствуетВРасчетах
	|	И &Условие1
	|	И НЕ ТЧСписокСчетов.Ссылка.ДатаОкончания > &ДатаОкончания
	|	И ТЧСписокСчетов.Ссылка.СверкаСогласована
	|	И НЕ ТЧСписокСчетов.Ссылка.ПометкаУдаления
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	АктыСверки_До__.Организация КАК Организация,
	|	АктыСверки_До__.Контрагент КАК Контрагент,
	|	АктыСверки_До__.Ссылка КАК Ссылка,
	|	АктыСверки_До__.Дата КАК Дата
	|ПОМЕСТИТЬ АктыСверки_До_
	|ИЗ
	|	АктыСверки_До__ КАК АктыСверки_До__
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ (ВЫБРАТЬ
	|			АктыСверки_До__.Организация КАК Организация,
	|			АктыСверки_До__.Контрагент КАК Контрагент,
	|			МАКСИМУМ(АктыСверки_До__.ДатаОкончания) КАК ДатаОкончания
	|		ИЗ
	|			АктыСверки_До__ КАК АктыСверки_До__
	|		
	|		СГРУППИРОВАТЬ ПО
	|			АктыСверки_До__.Организация,
	|			АктыСверки_До__.Контрагент) КАК МаксДатыОкончания
	|		ПО (МаксДатыОкончания.Организация = АктыСверки_До__.Организация)
	|			И (МаксДатыОкончания.Контрагент = АктыСверки_До__.Контрагент)
	|			И (МаксДатыОкончания.ДатаОкончания = АктыСверки_До__.ДатаОкончания)
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	АктыСверки_До_.Организация КАК Организация,
	|	АктыСверки_До_.Контрагент КАК Контрагент,
	|	АктыСверки_До_.Ссылка КАК Ссылка
	|ПОМЕСТИТЬ АктыСверки_До
	|ИЗ
	|	АктыСверки_До_ КАК АктыСверки_До_
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ (ВЫБРАТЬ
	|			АктыСверки_До_.Организация КАК Организация,
	|			АктыСверки_До_.Контрагент КАК Контрагент,
	|			МАКСИМУМ(АктыСверки_До_.Дата) КАК Дата
	|		ИЗ
	|			АктыСверки_До_ КАК АктыСверки_До_
	|		
	|		СГРУППИРОВАТЬ ПО
	|			АктыСверки_До_.Организация,
	|			АктыСверки_До_.Контрагент) КАК МаксДаты
	|		ПО (МаксДаты.Организация = АктыСверки_До_.Организация)
	|			И (МаксДаты.Контрагент = АктыСверки_До_.Контрагент)
	|			И (МаксДаты.Дата = АктыСверки_До_.Дата)
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ РАЗЛИЧНЫЕ
	|	ТЧСписокСчетов.Ссылка.Организация КАК Организация,
	|	ТЧСписокСчетов.Ссылка.Контрагент КАК Контрагент,
	|	ТЧСписокСчетов.Ссылка КАК Ссылка,
	|	ТЧСписокСчетов.Ссылка.Дата КАК Дата,
	|	ТЧСписокСчетов.Ссылка.ДатаОкончания КАК ДатаОкончания
	|ПОМЕСТИТЬ АктыСверки_После__
	|ИЗ
	|	Документ.АктСверкиВзаиморасчетов.СписокСчетов КАК ТЧСписокСчетов
	|ГДЕ
	|	ТЧСписокСчетов.Счет В ИЕРАРХИИ(&Счет)
	|	И ТЧСписокСчетов.УчаствуетВРасчетах
	|	И &Условие1
	|	И ТЧСписокСчетов.Ссылка.ДатаОкончания > &ДатаОкончания
	|	И ТЧСписокСчетов.Ссылка.СверкаСогласована
	|	И НЕ ТЧСписокСчетов.Ссылка.ПометкаУдаления
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	АктыСверки_После__.Организация КАК Организация,
	|	АктыСверки_После__.Контрагент КАК Контрагент,
	|	АктыСверки_После__.Ссылка КАК Ссылка,
	|	АктыСверки_После__.Дата КАК Дата
	|ПОМЕСТИТЬ АктыСверки_После_
	|ИЗ
	|	АктыСверки_После__ КАК АктыСверки_После__
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ (ВЫБРАТЬ
	|			АктыСверки_После__.Организация КАК Организация,
	|			АктыСверки_После__.Контрагент КАК Контрагент,
	|			МИНИМУМ(АктыСверки_После__.ДатаОкончания) КАК ДатаОкончания
	|		ИЗ
	|			АктыСверки_После__ КАК АктыСверки_После__
	|		
	|		СГРУППИРОВАТЬ ПО
	|			АктыСверки_После__.Организация,
	|			АктыСверки_После__.Контрагент) КАК МаксДатыОкончания
	|		ПО (МаксДатыОкончания.Организация = АктыСверки_После__.Организация)
	|			И (МаксДатыОкончания.Контрагент = АктыСверки_После__.Контрагент)
	|			И (МаксДатыОкончания.ДатаОкончания = АктыСверки_После__.ДатаОкончания)
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	АктыСверки_После_.Организация КАК Организация,
	|	АктыСверки_После_.Контрагент КАК Контрагент,
	|	АктыСверки_После_.Ссылка КАК Ссылка
	|ПОМЕСТИТЬ АктыСверки_После
	|ИЗ
	|	АктыСверки_После_ КАК АктыСверки_После_
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ (ВЫБРАТЬ
	|			АктыСверки_После_.Организация КАК Организация,
	|			АктыСверки_После_.Контрагент КАК Контрагент,
	|			МИНИМУМ(АктыСверки_После_.Дата) КАК Дата
	|		ИЗ
	|			АктыСверки_После_ КАК АктыСверки_После_
	|		
	|		СГРУППИРОВАТЬ ПО
	|			АктыСверки_После_.Организация,
	|			АктыСверки_После_.Контрагент) КАК МаксДаты
	|		ПО (МаксДаты.Организация = АктыСверки_После_.Организация)
	|			И (МаксДаты.Контрагент = АктыСверки_После_.Контрагент)
	|			И (МаксДаты.Дата = АктыСверки_После_.Дата)
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	АктСверкиВзаиморасчетов.Организация КАК Организация,
	|	АктСверкиВзаиморасчетов.Контрагент КАК Контрагент,
	|	ВЫБОР
	|		КОГДА ВТМаксПериоды.Период ЕСТЬ NULL 
	|				ИЛИ НЕ ВТМаксПериоды.Период > КОНЕЦПЕРИОДА(АктСверкиВзаиморасчетов.Ссылка.ДатаОкончания, ДЕНЬ)
	|			ТОГДА 1
	|		ИНАЧЕ 0
	|	КОНЕЦ КАК НеПоследний,
	|	АктСверкиВзаиморасчетов.Ссылка КАК Ссылка
	|ПОМЕСТИТЬ ВТАктыСверки_До
	|ИЗ
	|	АктыСверки_До КАК АктСверкиВзаиморасчетов
	|		ЛЕВОЕ СОЕДИНЕНИЕ (ВЫБРАТЬ
	|			ФинансовыйОстаткиИОбороты.Субконто1 КАК Организация,
	|			ФинансовыйОстаткиИОбороты.Субконто2 КАК Контрагент,
	|			МАКСИМУМ(ФинансовыйОстаткиИОбороты.Период) КАК Период
	|		ИЗ
	|			РегистрБухгалтерии.Финансовый.ОстаткиИОбороты(, &ДатаОкончания, Регистратор, , Счет В ИЕРАРХИИ (&Счет), , &Условие2) КАК ФинансовыйОстаткиИОбороты
	|		
	|		СГРУППИРОВАТЬ ПО
	|			ФинансовыйОстаткиИОбороты.Субконто1,
	|			ФинансовыйОстаткиИОбороты.Субконто2) КАК ВТМаксПериоды
	|		ПО (ВТМаксПериоды.Организация = АктСверкиВзаиморасчетов.Организация)
	|			И (ВТМаксПериоды.Контрагент = АктСверкиВзаиморасчетов.Контрагент)
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ РАЗРЕШЕННЫЕ
	|	ФинансовыйОстаткиИОбороты.Субконто1 КАК Организация,
	|	ФинансовыйОстаткиИОбороты.Субконто2 КАК Контрагент,
	|	СУММА(ФинансовыйОстаткиИОбороты.СуммаНачальныйОстатокДт) КАК НачальныйОстатокДт,
	|	СУММА(ФинансовыйОстаткиИОбороты.СуммаНачальныйОстатокКт) КАК НачальныйОстатокКт,
	|	СУММА(ФинансовыйОстаткиИОбороты.СуммаОборотДт) КАК ОборотДт,
	|	СУММА(ФинансовыйОстаткиИОбороты.СуммаОборотКт) КАК ОборотКт,
	|	СУММА(ФинансовыйОстаткиИОбороты.СуммаКонечныйОстатокДт) КАК КонечныйОстатокДт,
	|	СУММА(ФинансовыйОстаткиИОбороты.СуммаКонечныйОстатокКт) КАК КонечныйОстатокКт
	|ПОМЕСТИТЬ ВТОсновная
	|ИЗ
	|	РегистрБухгалтерии.Финансовый.ОстаткиИОбороты(&ДатаНачала, &ДатаОкончания, , , Счет В ИЕРАРХИИ (&Счет), , &Условие2) КАК ФинансовыйОстаткиИОбороты
	|
	|СГРУППИРОВАТЬ ПО
	|	ФинансовыйОстаткиИОбороты.Субконто1,
	|	ФинансовыйОстаткиИОбороты.Субконто2
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	АктыБух_До.ИННОрганизации КАК ИННОрганизации,
	|	АктыБух_До.ИННКонтрагента КАК ИННКонтрагента,
	|	АктыБух_До.КППКонтрагента КАК КППКонтрагента,
	|	АктыБух_До.ДокАкт КАК ДокАкт,
	|	АктыБух_До.НеПоследний КАК НеПоследний
	|ПОМЕСТИТЬ ВТАктыБух_До
	|ИЗ
	|	&АктыБух_До КАК АктыБух_До
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	АктыБух_После.ИННОрганизации КАК ИННОрганизации,
	|	АктыБух_После.ИННКонтрагента КАК ИННКонтрагента,
	|	АктыБух_После.КППКонтрагента КАК КППКонтрагента,
	|	АктыБух_После.ДокАкт КАК ДокАкт
	|ПОМЕСТИТЬ ВТАктыБух_Пссле
	|ИЗ
	|	&АктыБух_После КАК АктыБух_После
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ВТОсновная.Организация КАК Организация,
	|	ВТОсновная.Контрагент КАК Контрагент,
	|	ВТОсновная.НачальныйОстатокДт КАК НачальныйОстатокДт,
	|	ВТОсновная.НачальныйОстатокКт КАК НачальныйОстатокКт,
	|	ВТОсновная.ОборотДт КАК ОборотДт,
	|	ВТОсновная.ОборотКт КАК ОборотКт,
	|	ВТОсновная.КонечныйОстатокДт КАК КонечныйОстатокДт,
	|	ВТОсновная.КонечныйОстатокКт КАК КонечныйОстатокКт,
	|	ЕСТЬNULL(АктыСверки_До.Ссылка, ЕСТЬNULL(АктыСверки_После.Ссылка, ЗНАЧЕНИЕ(Документ.АктСверкиВзаиморасчетов.ПустаяСсылка))) КАК АктСверкиФин,
	|	ЕСТЬNULL(АктыСверки_До.Ссылка, ЕСТЬNULL(АктыСверки_После.Ссылка, ЕСТЬNULL(АктыСверки_Последний.Ссылка, ЗНАЧЕНИЕ(Документ.АктСверкиВзаиморасчетов.ПустаяСсылка)))) КАК ПоследнийАктФин,
	|	ЕСТЬNULL(АктыБух_До.ДокАкт, ЕСТЬNULL(АктыБух_Пссле.ДокАкт, """")) КАК АктСверкиБух,
	|	ЕСТЬNULL(АктыБух_До.ДокАкт, ЕСТЬNULL(АктыБух_Пссле.ДокАкт, ЕСТЬNULL(АктыБух_Последний.ДокАкт, """"))) КАК ПоследнийАктБух
	|ИЗ
	|	ВТОсновная КАК ВТОсновная
	|		ЛЕВОЕ СОЕДИНЕНИЕ ВТАктыСверки_До КАК АктыСверки_До
	|		ПО (АктыСверки_До.Организация = ВТОсновная.Организация)
	|			И (АктыСверки_До.Контрагент = ВТОсновная.Контрагент)
	|			И (АктыСверки_До.НеПоследний = 1)
	|		ЛЕВОЕ СОЕДИНЕНИЕ ВТАктыСверки_До КАК АктыСверки_Последний
	|		ПО (АктыСверки_Последний.Организация = ВТОсновная.Организация)
	|			И (АктыСверки_Последний.Контрагент = ВТОсновная.Контрагент)
	|			И (АктыСверки_Последний.НеПоследний = 0)
	|		ЛЕВОЕ СОЕДИНЕНИЕ АктыСверки_После КАК АктыСверки_После
	|		ПО (АктыСверки_После.Организация = ВТОсновная.Организация)
	|			И (АктыСверки_После.Контрагент = ВТОсновная.Контрагент)
	|		ЛЕВОЕ СОЕДИНЕНИЕ ВТАктыБух_До КАК АктыБух_До
	|		ПО (АктыБух_До.ИННОрганизации = ВТОсновная.Организация.ИНН)
	|			И (АктыБух_До.ИННКонтрагента = ВТОсновная.Контрагент.ИНН)
	|			И (АктыБух_До.КППКонтрагента = ВТОсновная.Контрагент.КПП)
	|			И (АктыБух_До.НеПоследний = 1)
	|		ЛЕВОЕ СОЕДИНЕНИЕ ВТАктыБух_До КАК АктыБух_Последний
	|		ПО (АктыБух_Последний.ИННОрганизации = ВТОсновная.Организация.ИНН)
	|			И (АктыБух_Последний.ИННКонтрагента = ВТОсновная.Контрагент.ИНН)
	|			И (АктыБух_Последний.КППКонтрагента = ВТОсновная.Контрагент.КПП)
	|			И (АктыБух_Последний.НеПоследний = 0)
	|		ЛЕВОЕ СОЕДИНЕНИЕ ВТАктыБух_Пссле КАК АктыБух_Пссле
	|		ПО (АктыБух_Пссле.ИННОрганизации = ВТОсновная.Организация.ИНН)
	|			И (АктыБух_Пссле.ИННКонтрагента = ВТОсновная.Контрагент.ИНН)
	|			И (АктыБух_Пссле.КППКонтрагента = ВТОсновная.Контрагент.КПП)
	|
	|УПОРЯДОЧИТЬ ПО
	|	ВТОсновная.Организация.Наименование,
	|	ВТОсновная.Контрагент.Наименование";
	
	ТекстЗапроса = СтрЗаменить(ТекстЗапроса, "
	|	И &Условие1", "" +
		?(ЕстьОтборПоОрганизацииВкл, "
	|	И ТЧСписокСчетов.Ссылка.Организация В (&МассивОрганизацийВкл)", "") +
		?(ЕстьОтборПоКонтрагентуВкл, "
	|	И ТЧСписокСчетов.Ссылка.Контрагент В (&МассивКонтрагентовВкл)", "") +
		?(ЕстьОтборПоОрганизацииИскл, "
	|	И НЕ ТЧСписокСчетов.Ссылка.Организация В (&МассивОрганизацийИскл)", "") +
		?(ЕстьОтборПоКонтрагентуИскл, "
	|	И НЕ ТЧСписокСчетов.Ссылка.Контрагент В (&МассивКонтрагентовИскл)", ""));
	
	ТекстЗапроса = СтрЗаменить(ТекстЗапроса, "&Условие2", "ИСТИНА" +
		?(ЕстьОтборПоОрганизацииВкл, " И Субконто1 В (&МассивОрганизацийВкл)", "") +
		?(ЕстьОтборПоКонтрагентуВкл, " И Субконто2 В (&МассивКонтрагентовВкл)", "") +
		?(ЕстьОтборПоОрганизацииИскл, " И НЕ Субконто1 В (&МассивОрганизацийИскл)", "") +
		?(ЕстьОтборПоКонтрагентуИскл, " И НЕ Субконто2 В (&МассивКонтрагентовИскл)", ""));
	
	Запрос.Текст = ТекстЗапроса;
	
	Возврат Запрос.Выполнить().Выгрузить();
	
КонецФункции
