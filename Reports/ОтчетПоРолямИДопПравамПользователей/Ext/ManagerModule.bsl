﻿
Функция ПолучитьТаблицуДанных(МассивРолей = Неопределено) Экспорт
	
	ПользователиИБ = ПользователиИнформационнойБазы.ПолучитьПользователей();
	
	ТаблицаРолей = Новый ТаблицаЗначений;
	ТаблицаРолей.Колонки.Добавить("НаименованиеРолиПрава"	, Новый ОписаниеТипов("Строка"));
	ТаблицаРолей.Колонки.Добавить("Пользователь"			, Новый ОписаниеТипов("СправочникСсылка.Пользователи"));
	
	СпрПользователи = Справочники.Пользователи;
	Для Каждого ПользовательИБ Из ПользователиИБ Цикл
		Если ПользовательИБ.ПоказыватьВСпискеВыбора = Ложь
				И НЕ ПользовательИБ.АутентификацияОС Тогда
			Продолжить;
		КонецЕсли;
		Для Каждого ТекРоль Из ПользовательИБ.Роли Цикл
			Если (НЕ МассивРолей = Неопределено)
					И МассивРолей.Найти(ТекРоль.Имя) = Неопределено Тогда // не входит в выбранный на форме отчета список ролей
				Продолжить;
			КонецЕсли;
			НоваяСтрока = ТаблицаРолей.Добавить();
			НоваяСтрока.НаименованиеРолиПрава 	= ТекРоль.Имя;
			НоваяСтрока.Пользователь 			= СпрПользователи.НайтиПоРеквизиту("ИдентификаторПользователяИБ", ПользовательИБ.УникальныйИдентификатор);
		КонецЦикла;
	КонецЦикла;
	
	
	//
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("ТаблицаРолей"		, ТаблицаРолей);
	Запрос.УстановитьПараметр("МассивПользователей"	, ТаблицаРолей.ВыгрузитьКолонку("Пользователь"));
	Запрос.Текст =
	"ВЫБРАТЬ
	|	ТаблицаРолей.НаименованиеРолиПрава КАК НаименованиеРолиПрава,
	|	ТаблицаРолей.Пользователь КАК Пользователь
	|ПОМЕСТИТЬ ВТТаблицаРолей
	|ИЗ
	|	&ТаблицаРолей КАК ТаблицаРолей
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ВТТаблицаРолей.Пользователь КАК Пользователь,
	|	ВТТаблицаРолей.НаименованиеРолиПрава КАК НаименованиеРолиПрава,
	|	"""" КАК ПравоРодитель,
	|	ЗНАЧЕНИЕ(ПланВидовХарактеристик.ПраваПользователей.ПустаяСсылка) КАК Право,
	|	ЛОЖЬ КАК ПравоЭтоГруппа,
	|	ИСТИНА КАК ЗначениеПрава,
	|	ЛОЖЬ КАК ПризнакДопПраво
	|ПОМЕСТИТЬ ВТОсновная
	|ИЗ
	|	ВТТаблицаРолей КАК ВТТаблицаРолей
	|
	|ОБЪЕДИНИТЬ ВСЕ
	|
	|ВЫБРАТЬ
	|	ЗначениеПрав.Пользователь,
	|	Права.Наименование,
	|	Права.Родитель.Наименование,
	|	Права.Ссылка,
	|	Права.ЭтоГруппа,
	|	ЗначениеПрав.Значение,
	|	ИСТИНА
	|ИЗ
	|	ПланВидовХарактеристик.ПраваПользователей КАК Права
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ РегистрСведений.ЗначенияДополнительныхПравПользователя КАК ЗначениеПрав
	|		ПО (ЗначениеПрав.Право = Права.Ссылка)
	|			И (ЗначениеПрав.Пользователь В (&МассивПользователей))
	|			И (ТИПЗНАЧЕНИЯ(ЗначениеПрав.Значение) = ТИП(БУЛЕВО))
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ПользователиПОЦФО.Период,
	|	ПользователиПОЦФО.Сотрудник,
	|	ПользователиПОЦФО.ЦФО
	|ПОМЕСТИТЬ ВТЦФОПользователей
	|ИЗ
	|	РегистрСведений.ПользователиПоЦФО.СрезПоследних(, Сотрудник В (&МассивПользователей)) КАК ПользователиПОЦФО
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ВТОсновная.Пользователь КАК Пользователь,
	|	ВТОсновная.НаименованиеРолиПрава КАК НаименованиеРолиПрава,
	|	ВТОсновная.ПравоРодитель,
	|	ВТОсновная.Право,
	|	ВТОсновная.ПравоЭтоГруппа,
	|	ВТОсновная.ЗначениеПрава,
	|	ВТОсновная.ПризнакДопПраво,
	|	ЕСТЬNULL(ЦФОПользователей.ЦФО, ЗНАЧЕНИЕ(Справочник.СтруктурныеЕдиницы.ПустаяСсылка)) КАК ЦФО
	|ИЗ
	|	ВТОсновная КАК ВТОсновная
	|		ЛЕВОЕ СОЕДИНЕНИЕ (ВЫБРАТЬ
	|			ВТЦФОПользователей.Сотрудник КАК Сотрудник,
	|			ВТЦФОПользователей.ЦФО КАК ЦФО
	|		ИЗ
	|			ВТЦФОПользователей КАК ВТЦФОПользователей
	|				ВНУТРЕННЕЕ СОЕДИНЕНИЕ (ВЫБРАТЬ
	|					ВТЦФОПользователей.Сотрудник КАК Сотрудник,
	|					МАКСИМУМ(ВТЦФОПользователей.Период) КАК Период
	|				ИЗ
	|					ВТЦФОПользователей КАК ВТЦФОПользователей
	|				
	|				СГРУППИРОВАТЬ ПО
	|					ВТЦФОПользователей.Сотрудник) КАК МаксПериоды
	|				ПО (МаксПериоды.Сотрудник = ВТЦФОПользователей.Сотрудник)
	|					И (МаксПериоды.Период = ВТЦФОПользователей.Период)) КАК ЦФОПользователей
	|		ПО (ЦФОПользователей.Сотрудник = ВТОсновная.Пользователь)";
	
	Возврат Запрос.Выполнить().Выгрузить();
	
КонецФункции