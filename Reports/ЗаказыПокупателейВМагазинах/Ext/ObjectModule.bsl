﻿
Функция База_Подключение(СтрокаПодключения) экспорт	
	
	Попытка
		CurrentConnection = Новый COMОбъект("ADODB.Connection");
		CurrentConnection.Open(СтрокаПодключения);
		Возврат CurrentConnection;			
	Исключение
		ОписаниеОшибки = ОписаниеОшибки();		
		//#Если НаКлиенте тогда
		Сообщить(ОписаниеОшибки);			
		//#КонецЕсли		
		Возврат Неопределено;
	КонецПопытки;
	
КонецФункции

Функция База_ВыполнитьЗапрос(ТекстЗапроса) Экспорт
	
	СтрокаПодключенияТелеграм = ВнешниеДанные.ПолучитьСтрокуПодключенияMSSQL("srv-sql03", "Telegram");
	
	Попытка
		
		CurrentConnection = База_Подключение(СтрокаПодключенияТелеграм);
		CurrentConnection.CursorLocation = 2;
		
		RecordSet = CurrentConnection.Execute(ТекстЗапроса);
		
		Пока RecordSet <> Неопределено И RecordSet.Fields.Count <= 0 Цикл
			RecordSet=RecordSet.NextRecordSet();
		КонецЦикла;				
		
		Возврат RecordSet;
	Исключение	
		ВызватьИсключение ОписаниеОшибки();
	КонецПопытки;	
	
КонецФункции

Функция ВКонецДня(Дата)
	Возврат ?(Дата = Дата(1,1,1), Дата, КонецДня(Дата));
КонецФункции

Процедура ПриКомпоновкеРезультата(ДокументРезультат, ДанныеРасшифровки, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	ТаблицаДанных = Новый ТаблицаЗначений;
	
	ДатаНачала = Дата(1,1,1);
	ДатаОкончания = Дата(1,1,1);
	
	УсловиеОтбораSQL = "";
	Для Каждого ПользПоле Из КомпоновщикНастроек.ПользовательскиеНастройки.Элементы Цикл
		Если ТипЗнч(ПользПоле) = Тип("ЗначениеПараметраНастроекКомпоновкиДанных") Тогда
			Если НЕ ПользПоле.Использование Тогда Продолжить; КонецЕсли;
			ИмяПараметра = Строка(ПользПоле.Параметр);
			Если ИмяПараметра = "Период" Тогда
				ДатаНачала = ПользПоле.Значение.ДатаНачала;
				ДатаОкончания = ВКонецДня(ПользПоле.Значение.ДатаОкончания);
			ИначеЕсли ИмяПараметра = "Магазин" Тогда
				УсловиеОтбораSQL = "AND ShopNo_rep = " + ВнешниеДанные.ФорматПоля(ОбщегоНазначения.ПолучитьЗначениеРеквизита(ПользПоле.Значение, "НомерТочки")) + Символы.ПС;
			КонецЕсли;
		КонецЕсли;
	КонецЦикла;
	
	Если ДатаНачала <> Дата(1,1,1) И ДатаОкончания <> Дата(1,1,1) Тогда
		УсловиеОтбораSQL = УсловиеОтбораSQL + "AND Date_proizv BETWEEN " + ВнешниеДанные.ФорматПоля(ДатаНачала, Истина) + " AND " + ВнешниеДанные.ФорматПоля(ДатаОкончания, Истина);
	ИначеЕсли ДатаНачала <> Дата(1,1,1) Тогда
		УсловиеОтбораSQL = УсловиеОтбораSQL + "AND Date_proizv >= " + ВнешниеДанные.ФорматПоля(ДатаНачала, Истина);
	ИначеЕсли ДатаОкончания <> Дата(1,1,1) Тогда
		УсловиеОтбораSQL = УсловиеОтбораSQL + "AND Date_proizv <= " + ВнешниеДанные.ФорматПоля(ДатаОкончания, Истина);
	КонецЕсли;
	
	ТекстЗапросаSQL =
		"SELECT id_tov
		|	, id_kontr
		|	, ShopNo_rep
		|	, CONVERT(datetime, Date_proizv) [ДатаПоступления]
		|	, CONVERT(datetime, closedate) [ДатаЗаказа]
		|	, CASE WHEN operation_type = 802 THEN Quantity ELSE -Quantity END [Количество]
		|FROM [SMS_Repl].[dbo].[TD_move] td (NOLOCK)
		|WHERE
		|	Confirm_type = 1
		|	AND operation_type BETWEEN 802 AND 803
		|	" + УсловиеОтбораSQL;
	
	ADOСоединение = ВнешниеДанные.ПолучитьADOСоединение();
	
	Command = Новый COMОбъект("ADODB.Command");
	Command.ActiveConnection = ADOСоединение;
	Command.CommandText = ТекстЗапросаSQL;
	
	rsTABLE = Новый COMОбъект("ADODB.RecordSet");
	rsTABLE = Command.Execute();
	
	ТаблицаДанных = ВнешниеДанные.ПреобразоватьРезультатВТаблицуЗначений(rsTABLE);
	Если ТаблицаДанных.Колонки.Количество() = 0 Тогда
		ОписаниеТиповЧисло = Новый ОписаниеТипов("Число");
		ТаблицаДанных.Колонки.Добавить("ДатаЗаказа", Новый ОписаниеТипов("Дата"));
		ТаблицаДанных.Колонки.Добавить("ДатаПоступления", Новый ОписаниеТипов("Дата"));
		ТаблицаДанных.Колонки.Добавить("Магазин", Новый ОписаниеТипов("СправочникСсылка.СтруктурныеЕдиницы"));
		ТаблицаДанных.Колонки.Добавить("Номенклатура", Новый ОписаниеТипов("СправочникСсылка.Номенклатура"));
		ТаблицаДанных.Колонки.Добавить("Характеристика", Новый ОписаниеТипов("СправочникСсылка.ХарактеристикиНоменклатуры"));
		ТаблицаДанных.Колонки.Добавить("Производитель", Новый ОписаниеТипов("СправочникСсылка.Контрагенты"));
		ТаблицаДанных.Колонки.Добавить("Количество", ОписаниеТиповЧисло);
		ТаблицаДанных.Колонки.Добавить("id_tov", ОписаниеТиповЧисло);
		ТаблицаДанных.Колонки.Добавить("id_kontr", ОписаниеТиповЧисло);
		ТаблицаДанных.Колонки.Добавить("ShopNo_rep", ОписаниеТиповЧисло);
	КонецЕсли;
	
	Запрос = Новый Запрос(
		"ВЫБРАТЬ
		|	ТаблицаДанных.id_tov,
		|	ТаблицаДанных.id_kontr,
		|	ТаблицаДанных.ShopNo_rep,
		|	ТаблицаДанных.ДатаПоступления,
		|	ТаблицаДанных.ДатаЗаказа,
		|	ТаблицаДанных.Количество
		|ПОМЕСТИТЬ ТаблицаДанных
		|ИЗ
		|	&ТаблицаДанных КАК ТаблицаДанных
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	СтруктурныеЕдиницы.Ссылка КАК Магазин,
		|	СпрНоменклатура.Ссылка КАК Номенклатура,
		|	ТаблицаДанных.ДатаПоступления,
		|	ТаблицаДанных.ДатаЗаказа,
		|	ТаблицаДанных.Количество,
		|	ЗНАЧЕНИЕ(Справочник.ХарактеристикиНоменклатуры.ПустаяСсылка) КАК Характеристика,
		|	ЕСТЬNULL(Контрагенты.Ссылка, ЗНАЧЕНИЕ(Справочник.Контрагенты.ПустаяСсылка)) КАК Производитель
		|ИЗ
		|	ТаблицаДанных КАК ТаблицаДанных
		|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ Справочник.СтруктурныеЕдиницы КАК СтруктурныеЕдиницы
		|		ПО ТаблицаДанных.ShopNo_rep = СтруктурныеЕдиницы.НомерТочки
		|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ Справочник.Номенклатура КАК СпрНоменклатура
		|		ПО ТаблицаДанных.id_tov = СпрНоменклатура.id_tov
		|		ЛЕВОЕ СОЕДИНЕНИЕ Справочник.Контрагенты КАК Контрагенты
		|		ПО ТаблицаДанных.id_kontr = Контрагенты.ИД");
	Запрос.УстановитьПараметр("ТаблицаДанных", ТаблицаДанных);
	
	ТаблицаДанных = Запрос.Выполнить().Выгрузить();
	
	ВнешниеНаборыДанных = Новый Структура;
	ВнешниеНаборыДанных.Вставить("ТаблицаДанных", ТаблицаДанных);
	
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
