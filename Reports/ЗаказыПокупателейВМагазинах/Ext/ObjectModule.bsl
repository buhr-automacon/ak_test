﻿
Функция ВКонецДня(Дата)
	Возврат ?(Дата = Дата(1,1,1), Дата, КонецДня(Дата));
КонецФункции

Функция ТаблицаДанных(ДатаНачала, ДатаОкончания, Магазин, ТолькоБулево = Ложь) Экспорт
	
	УсловиеОтбораSQL1 = "";
	УсловиеОтбораSQL2 = "";
	Если ЗначениеЗаполнено(Магазин) Тогда
		МагазинДанные = ОбщегоНазначения.ПолучитьЗначенияРеквизитов(Магазин, "НомерТочки,id_TT");
		УсловиеОтбораSQL1 = "AND ShopNo_rep = " + ВнешниеДанные.ФорматПоля(МагазинДанные.НомерТочки) + Символы.ПС;
		УсловиеОтбораSQL2 = "AND ar.id_tt = " + ВнешниеДанные.ФорматПоля(МагазинДанные.id_TT) + Символы.ПС;
	КонецЕсли;
	
	УсловиеОтбораSQL = "";
	Если ДатаНачала <> Дата(1,1,1) И ДатаОкончания <> Дата(1,1,1) Тогда
		УсловиеОтбораSQL = УсловиеОтбораSQL + "AND Date_proizv BETWEEN " + ВнешниеДанные.ФорматПоля(ДатаНачала, Истина) + " AND " + ВнешниеДанные.ФорматПоля(ДатаОкончания, Истина);
	ИначеЕсли ДатаНачала <> Дата(1,1,1) Тогда
		УсловиеОтбораSQL = УсловиеОтбораSQL + "AND Date_proizv >= " + ВнешниеДанные.ФорматПоля(ДатаНачала, Истина);
	ИначеЕсли ДатаОкончания <> Дата(1,1,1) Тогда
		УсловиеОтбораSQL = УсловиеОтбораSQL + "AND Date_proizv <= " + ВнешниеДанные.ФорматПоля(ДатаОкончания, Истина);
	КонецЕсли;
	
	ТекстЗапросаSQL =
		"SELECT
		|	td.Id_doc [НомерЗаказа]
		|	, ISNULL(td.BonusCard, '') AS [НомерКарты]
		|	, ISNULL(cs.FullName, '') AS [ФИО]
		|	, ISNULL(cs.Phone, '') AS [НомерТелефона]
		|	, td.id_tov
		|	, td.id_kontr
		|	, td.ShopNo_rep AS ShopNo
		|	, CONVERT(datetime, td.Date_proizv) [ДатаПоступления]
		|	, CONVERT(datetime, td.closedate) [ДатаЗаказа]
		|	, CASE WHEN td.operation_type = 802 THEN td.Quantity ELSE -td.Quantity END [Количество]
		|	, 0 [Пришло]
		|FROM [SMS_Repl].[dbo].[TD_move] td (NOLOCK)
		|	LEFT JOIN [Loyalty].[dbo].[Customer] cs (NOLOCK)
		|	ON td.BonusCard = cs.Email
		|WHERE
		|	td.Confirm_type = 1
		|	AND td.operation_type BETWEEN 802 AND 803
		|	" + УсловиеОтбораSQL1 + "
		|	" + УсловиеОтбораSQL + "
		|ORDER BY
		|	td.closedate";
	
	ADOСоединение = ВнешниеДанные.ПолучитьADOСоединение();
	
	rs = ADOСоединение.Execute(ТекстЗапросаSQL);
	ТаблицаДанных = ВнешниеДанные.ПреобразоватьРезультатВТаблицуЗначений(rs);
	
	Если ТаблицаДанных.Колонки.Количество() = 0 Тогда
		ОписаниеТиповЧисло = Новый ОписаниеТипов("Число");
		ОписаниеТиповСтрока = Новый ОписаниеТипов("Строка");
		ТаблицаДанных = Новый ТаблицаЗначений;
		ТаблицаДанных.Колонки.Добавить("НомерЗаказа", ОписаниеТиповСтрока);
		ТаблицаДанных.Колонки.Добавить("НомерКарты", ОписаниеТиповСтрока);
		ТаблицаДанных.Колонки.Добавить("ФИО", ОписаниеТиповСтрока);
		ТаблицаДанных.Колонки.Добавить("НомерТелефона", ОписаниеТиповСтрока);
		ТаблицаДанных.Колонки.Добавить("ДатаЗаказа", Новый ОписаниеТипов("Дата"));
		ТаблицаДанных.Колонки.Добавить("ДатаПоступления", Новый ОписаниеТипов("Дата"));
		ТаблицаДанных.Колонки.Добавить("Магазин", Новый ОписаниеТипов("СправочникСсылка.СтруктурныеЕдиницы"));
		ТаблицаДанных.Колонки.Добавить("Номенклатура", Новый ОписаниеТипов("СправочникСсылка.Номенклатура"));
		ТаблицаДанных.Колонки.Добавить("Характеристика", Новый ОписаниеТипов("СправочникСсылка.ХарактеристикиНоменклатуры"));
		ТаблицаДанных.Колонки.Добавить("Производитель", Новый ОписаниеТипов("СправочникСсылка.Контрагенты"));
		ТаблицаДанных.Колонки.Добавить("Количество", ОписаниеТиповЧисло);
		ТаблицаДанных.Колонки.Добавить("Пришло", ОписаниеТиповЧисло);
		ТаблицаДанных.Колонки.Добавить("id_tov", ОписаниеТиповЧисло);
		ТаблицаДанных.Колонки.Добавить("id_kontr", ОписаниеТиповЧисло);
		ТаблицаДанных.Колонки.Добавить("ShopNo", ОписаниеТиповЧисло);
	КонецЕсли;
	
	ТаблицаДанных.Колонки.Добавить("ЗаказЗакрыт", Новый ОписаниеТипов("Булево"));
	
	// Пришло
	ТекстЗапросаSQL =
		"SELECT
		|	CONVERT(datetime, rz.Date_r) AS ДатаПоступления,
		|	tt.N AS ShopNo,
		|	ar.id_tov,
		|	ar.id_kontr,
		|	ar.q_raspr AS Пришло
		|FROM [M2].[dbo].[archive_rasp] ar (NOLOCK)
		|	INNER JOIN M2..Raspr_zadanie AS rz With (NOLOCK)
		|	ON ar.number_r = rz.Number_r
		|	INNER JOIN M2..tt tt (NOLOCK)
		|	ON ar.id_tt = tt.id_TT
		|where
		|	isNULL(ar.q_zakaz, 0) > 0
		|	AND isNULL(ar.q_raspr, 0) > 0
		|	" + УсловиеОтбораSQL2 + "
		|	" + СтрЗаменить(УсловиеОтбораSQL, "Date_proizv", "rz.Date_r") + "
		|";
	rs = ADOСоединение.Execute(ТекстЗапросаSQL);
	ТаблицаДанныхПришло = ВнешниеДанные.ПреобразоватьРезультатВТаблицуЗначений(rs);
	
	ADOСоединение.Close();
	ADOСоединение = Неопределено;
	
	Если ТолькоБулево Тогда
		Возврат ТаблицаДанныхПришло.Количество() > 0;
	КонецЕсли;
	
	Для Каждого СтрокаПришло Из ТаблицаДанныхПришло Цикл
		ОсталосьРаспределить = СтрокаПришло.Пришло;
		
		СтруктураОтбор = Новый Структура("ДатаПоступления,ShopNo,id_tov,id_kontr");
		ЗаполнитьЗначенияСвойств(СтруктураОтбор, СтрокаПришло);
		СтруктураОтбор.Вставить("Количество", СтрокаПришло.Пришло);
		СтруктураОтбор.Вставить("Пришло", 0);
		
		Для Сч = 1 По 3 Цикл
			МассивСтрок = ТаблицаДанных.НайтиСтроки(СтруктураОтбор);
			Для Каждого СтрокаТД Из МассивСтрок Цикл
				Распределяем = Мин(ОсталосьРаспределить, СтрокаТД.Количество - СтрокаТД.Пришло);
				СтрокаТД.Пришло = Распределяем;
				ОсталосьРаспределить = ОсталосьРаспределить - Распределяем; 
				Если ОсталосьРаспределить = 0 Тогда Прервать; КонецЕсли;
			КонецЦикла;
			Если ОсталосьРаспределить = 0 Тогда Прервать; КонецЕсли;
			
			Если Сч = 1 Тогда
				СтруктураОтбор.Удалить("Количество"); // сначала пытаемся распределить по равному кол-ву
			ИначеЕсли Сч = 2 Тогда
				СтруктураОтбор.Удалить("id_kontr"); // потом — по тому же поставщику
			КонецЕсли;
		КонецЦикла;
		
		// если не распределили, добавлять ли новую строку? пока не добавляем
		Если ОсталосьРаспределить > 0 Тогда КонецЕсли;
	КонецЦикла;
	
	// закрываем заказы
	ТаблицаДанныхПришло = ТаблицаДанных.Скопировать(, "НомерЗаказа,Количество,Пришло");
	ТаблицаДанныхПришло.Свернуть("НомерЗаказа", "Количество,Пришло");
	
	СтруктураОтбор = Новый Структура("НомерЗаказа");
	Для Каждого СтрокаПришло Из ТаблицаДанныхПришло Цикл
		Если СтрокаПришло.Количество <> СтрокаПришло.Пришло Тогда Продолжить; КонецЕсли;
		ЗаполнитьЗначенияСвойств(СтруктураОтбор, СтрокаПришло);
		МассивСтрок = ТаблицаДанных.НайтиСтроки(СтруктураОтбор);
		Для Каждого СтрокаТД Из МассивСтрок Цикл
			СтрокаТД.ЗаказЗакрыт = Истина;
		КонецЦикла;
	КонецЦикла;
	
	ТаблицаДанныхПришло.Очистить();
	ТаблицаДанныхПришло = Неопределено;
	
	// итоговые данные
	Запрос = Новый Запрос(
		"ВЫБРАТЬ
		|	ТаблицаДанных.НомерЗаказа,
		|	ТаблицаДанных.НомерКарты,
		|	ТаблицаДанных.ФИО,
		|	ТаблицаДанных.НомерТелефона,
		|	ТаблицаДанных.id_tov,
		|	ТаблицаДанных.id_kontr,
		|	ТаблицаДанных.ShopNo,
		|	ТаблицаДанных.ДатаПоступления,
		|	ТаблицаДанных.ЗаказЗакрыт,
		|	ТаблицаДанных.ДатаЗаказа,
		|	ТаблицаДанных.Количество,
		|	ТаблицаДанных.Пришло
		|ПОМЕСТИТЬ ТаблицаДанных
		|ИЗ
		|	&ТаблицаДанных КАК ТаблицаДанных
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	ТаблицаДанных.НомерЗаказа,
		|	ТаблицаДанных.НомерКарты,
		|	ТаблицаДанных.ФИО,
		|	ТаблицаДанных.НомерТелефона,
		|	ТаблицаДанных.ЗаказЗакрыт,
		|	ТаблицаДанных.ДатаПоступления,
		|	СтруктурныеЕдиницы.Ссылка КАК Магазин,
		|	СпрНоменклатура.Ссылка КАК Номенклатура,
		|	ТаблицаДанных.ДатаПоступления,
		|	ТаблицаДанных.ДатаЗаказа,
		|	ТаблицаДанных.Количество,
		|	ТаблицаДанных.Пришло,
		|	ЗНАЧЕНИЕ(Справочник.ХарактеристикиНоменклатуры.ПустаяСсылка) КАК Характеристика,
		|	ЕСТЬNULL(Контрагенты.Ссылка, ЗНАЧЕНИЕ(Справочник.Контрагенты.ПустаяСсылка)) КАК Производитель
		|ИЗ
		|	ТаблицаДанных КАК ТаблицаДанных
		|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ Справочник.СтруктурныеЕдиницы КАК СтруктурныеЕдиницы
		|		ПО ТаблицаДанных.ShopNo = СтруктурныеЕдиницы.НомерТочки
		|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ Справочник.Номенклатура КАК СпрНоменклатура
		|		ПО ТаблицаДанных.id_tov = СпрНоменклатура.id_tov
		|		ЛЕВОЕ СОЕДИНЕНИЕ Справочник.Контрагенты КАК Контрагенты
		|		ПО ТаблицаДанных.id_kontr = Контрагенты.ИД");
	Запрос.УстановитьПараметр("ТаблицаДанных", ТаблицаДанных);
	
	ТаблицаДанных = Запрос.Выполнить().Выгрузить();
	Возврат ТаблицаДанных;
	
КонецФункции

Процедура ПриКомпоновкеРезультата(ДокументРезультат, ДанныеРасшифровки, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	ДатаНачала = Дата(1,1,1);
	ДатаОкончания = Дата(1,1,1);
	Магазин = ПредопределенноеЗначение("Справочник.СтруктурныеЕдиницы.ПустаяСсылка");
	
	Для Каждого ПользПоле Из КомпоновщикНастроек.ПользовательскиеНастройки.Элементы Цикл
		Если ТипЗнч(ПользПоле) = Тип("ЗначениеПараметраНастроекКомпоновкиДанных") Тогда
			Если НЕ ПользПоле.Использование Тогда Продолжить; КонецЕсли;
			ИмяПараметра = Строка(ПользПоле.Параметр);
			Если ИмяПараметра = "Период" Тогда
				ДатаНачала = ПользПоле.Значение.ДатаНачала;
				ДатаОкончания = ВКонецДня(ПользПоле.Значение.ДатаОкончания);
			ИначеЕсли ИмяПараметра = "Магазин" Тогда
				Магазин = ПользПоле.Значение;
			КонецЕсли;
		КонецЕсли;
	КонецЦикла;
	
	ВнешниеНаборыДанных = Новый Структура;
	ВнешниеНаборыДанных.Вставить("ТаблицаДанных", ТаблицаДанных(ДатаНачала, ДатаОкончания, Магазин));
	
	//Макет компоновки 
	КомпоновщикМакета = Новый КомпоновщикМакетаКомпоновкиДанных;
	МакетКомпоновки = КомпоновщикМакета.Выполнить(СхемаКомпоновкиДанных, КомпоновщикНастроек.ПолучитьНастройки(), ДанныеРасшифровки);
	
	//Компоновка данных
	ПроцессорКомпоновки = Новый ПроцессорКомпоновкиДанных;
	ПроцессорКомпоновки.Инициализировать(МакетКомпоновки, ВнешниеНаборыДанных, ДанныеРасшифровки);
	
	//Вывод результата
	ПроцессорВывода = Новый ПроцессорВыводаРезультатаКомпоновкиДанныхВТабличныйДокумент;
	ПроцессорВывода.УстановитьДокумент(ДокументРезультат);
	ПроцессорВывода.Вывести(ПроцессорКомпоновки);
	
КонецПроцедуры
