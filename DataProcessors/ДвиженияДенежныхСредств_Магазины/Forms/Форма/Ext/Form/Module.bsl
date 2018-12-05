﻿
&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	ИмяВнешнейОбработки = Параметры.ИмяВнешнейОбработки;
	
	Если НЕ ЗначениеЗаполнено(ИмяВнешнейОбработки) Тогда
		ИмяВнешнейОбработки = "ДвиженияДенежныхСредств";
	КонецЕсли;
	
	Если НЕ ЗначениеЗаполнено(Объект.ФормироватьСДаты) Тогда
		Объект.ФормироватьСДаты = ТекущаяДата();
	КонецЕсли;
	
	СформироватьПриОткрытии = Параметры.СформироватьПриОткрытии;
	
КонецПроцедуры

&НаСервере
Функция СформироватьЗаДату_(ДатаФормирования)
	
	ТабДок = Новый ТабличныйДокумент();
	ОбъектОбр = РеквизитФормыВЗначение("Объект");
	Макет = ОбъектОбр.ПолучитьМакет("Ведомость");
	
	ТаблицаДвижения = Новый ТаблицаЗначений();
	ТаблицаДвижения.Колонки.Добавить("Касса", Новый ОписаниеТипов("Строка",,Новый КвалификаторыСтроки(100)));
	ТаблицаДвижения.Колонки.Добавить("id_doc", Новый ОписаниеТипов("Строка",,Новый КвалификаторыСтроки(100)));
	ТаблицаДвижения.Колонки.Добавить("КодОперации");
	ТаблицаДвижения.Колонки.Добавить("ДатаОперации", Новый ОписаниеТипов("Дата",,,Новый КвалификаторыДаты(ЧастиДаты.ДатаВремя)));
	ТаблицаДвижения.Колонки.Добавить("НачальныйОстаток", Новый ОписаниеТипов("Число",Новый КвалификаторыЧисла(15,2)));
	ТаблицаДвижения.Колонки.Добавить("СуммаПриход", Новый ОписаниеТипов("Число",Новый КвалификаторыЧисла(15,2)));
	ТаблицаДвижения.Колонки.Добавить("СуммаРасход", Новый ОписаниеТипов("Число",Новый КвалификаторыЧисла(15,2)));
	ТаблицаДвижения.Колонки.Добавить("КонечныйОстаток", Новый ОписаниеТипов("Число",Новый КвалификаторыЧисла(15,2)));
	
	ТабОстаткиНач = Новый ТаблицаЗначений();
	ТабОстаткиНач.Колонки.Добавить("Касса", Новый ОписаниеТипов("Число",Новый КвалификаторыЧисла(15,0)));
	ТабОстаткиНач.Колонки.Добавить("Остаток", Новый ОписаниеТипов("Число",Новый КвалификаторыЧисла(15,2)));
	
	ТабОстаткиКон = Новый ТаблицаЗначений();
	ТабОстаткиКон.Колонки.Добавить("Касса", Новый ОписаниеТипов("Число",Новый КвалификаторыЧисла(15,0)));
	ТабОстаткиКон.Колонки.Добавить("Остаток", Новый ОписаниеТипов("Число",Новый КвалификаторыЧисла(15,2)));
	
	ТабОстатки = Новый ТаблицаЗначений();
	ТабОстатки.Колонки.Добавить("Касса", Новый ОписаниеТипов("Строка",,Новый КвалификаторыСтроки(100)));
	ТабОстатки.Колонки.Добавить("НачальныйОстаток", Новый ОписаниеТипов("Число",Новый КвалификаторыЧисла(15,2)));
	ТабОстатки.Колонки.Добавить("СуммаПриход", Новый ОписаниеТипов("Число",Новый КвалификаторыЧисла(15,2)));
	ТабОстатки.Колонки.Добавить("СуммаРасход", Новый ОписаниеТипов("Число",Новый КвалификаторыЧисла(15,2)));
	ТабОстатки.Колонки.Добавить("КонечныйОстаток", Новый ОписаниеТипов("Число",Новый КвалификаторыЧисла(15,2)));
	
	Запрос = Новый Запрос();
	Запрос.Текст = "ВЫБРАТЬ
	               |	ТипыОпераций.Ссылка,
	               |	ТипыОпераций.code_operation,
	               |	ТипыОпераций.znak
	               |ИЗ
	               |	Справочник.ТипыОперацийМагазина КАК ТипыОпераций
	               |ГДЕ
	               |	ТипыОпераций.table_operation = &table_operation
	               |	И ТипыОпераций.field_operation = &field_operation";
				   
	Запрос.УстановитьПараметр("table_operation", "Cash_move");
	Запрос.УстановитьПараметр("field_operation", "operation_type");
	ТабОперацииКеш = Запрос.Выполнить().Выгрузить();
	
	СтрокаКодыОтрцОпераций = "99999";
	Для Каждого СтрокаОперации Из ТабОперацииКеш Цикл
		Если СтрокаОперации.znak = -1 Тогда
			СтрокаКодыОтрцОпераций = СтрокаКодыОтрцОпераций + ", " + ВнешниеДанные.ФорматПоля(СтрокаОперации.code_operation);
		КонецЕсли;	
	КонецЦикла;	
	
	ADOСоединение = ВнешниеДанные.ПолучитьADOСоединение();
	
	ИмяБд = "SMS_Repl";
	НомерМагазина = ВнешниеДанные.ФорматПоля(ПараметрыСеанса.НомерТочкиПоАйпи);
	
	ЗапросСкуль = "SELECT 
				|      Cash_ost.cash_id as cash_id
				|      , isnull(Cash_ost.balance_ost, 0) as Nach_ost
				|  FROM " + ИмяБд + ".[dbo].[Cash_Move] as Cash_ost (nolock)
				|INNER JOIN (SELECT 
				|      Cash_ost.closedate
				|      ,Cash_ost.cash_id as cash_id
				|      ,Cash_ost.id_doc as id_doc
				|      ,ROW_NUMBER() OVER (PARTITION BY Cash_ost.cash_id order by Cash_ost.closedate desc) as rn
				|      
				|  FROM " + ИмяБд + ".[dbo].[Cash_Move] as Cash_ost (nolock)
				|  WHERE CONVERT(date, Cash_ost.closedate) = " + ВнешниеДанные.ФорматПоля(ДатаФормирования - 1, Истина) + "
				|	and Cash_ost.ShopNo_rep = " + НомерМагазина + "
				|	and Cash_ost.Confirm_type IN (1, -1) and Cash_ost.operation_type > 0) as VZ_Max
				|	ON Cash_ost.cash_id = VZ_Max.cash_id and VZ_Max.rn = 1 and Cash_ost.id_doc = VZ_Max.id_doc
				|  WHERE CONVERT(date, Cash_ost.closedate) = " + ВнешниеДанные.ФорматПоля(ДатаФормирования - 1, Истина) + "
				|	and Cash_ost.ShopNo_rep = " + НомерМагазина + " and Cash_ost.cash_id = 0
				|
				|SELECT 
				|      Cash_ost.cash_id as cash_id
				|      , isnull(Cash_ost.balance_ost, 0) - Cash_ost.Cash_sum * IsNull(Typs.znak, 1) as Nach_ost
				|  FROM " + ИмяБд + ".[dbo].[Cash_Move] as Cash_ost (nolock)
				|INNER JOIN (SELECT 
				|      Cash_ost.closedate
				|      ,Cash_ost.cash_id as cash_id
				|      ,Cash_ost.id_doc as id_doc
				|      ,ROW_NUMBER() OVER (PARTITION BY Cash_ost.cash_id order by Cash_ost.closedate) as rn
				|      
				|  FROM " + ИмяБд + ".[dbo].[Cash_Move] as Cash_ost (nolock)
				|  WHERE CONVERT(date, Cash_ost.closedate) = " + ВнешниеДанные.ФорматПоля(ДатаФормирования, Истина) + "
				|	and Cash_ost.ShopNo_rep = " + НомерМагазина + "
				|	and Cash_ost.Confirm_type IN (1, -1) and Cash_ost.operation_type > 0) as VZ_Max
				|	ON Cash_ost.cash_id = VZ_Max.cash_id and VZ_Max.rn = 1 and Cash_ost.id_doc = VZ_Max.id_doc
				|LEFT OUTER JOIN " + ИмяБд + ".[dbo].[Types_Operation] as Typs (nolock) ON Cash_ost.operation_type = Typs.code_operation and Typs.table_operation = 'Cash_move' and Typs.field_operation = 'operation_type'
				|  WHERE CONVERT(date, Cash_ost.closedate) = " + ВнешниеДанные.ФорматПоля(ДатаФормирования, Истина) + "
				|	and Cash_ost.ShopNo_rep = " + НомерМагазина + " and Cash_ost.cash_id = 0
				|
				|
				|SELECT 
				|      Cash_ost.cash_id as cash_id
				|      , isnull(Cash_ost.balance_ost, 0) as Kon_ost
				|  FROM " + ИмяБд + ".[dbo].[Cash_Move] as Cash_ost (nolock)
				|INNER JOIN (SELECT 
				|      Cash_ost.closedate
				|      ,Cash_ost.cash_id as cash_id
				|      ,Cash_ost.id_doc as id_doc
				|      ,ROW_NUMBER() OVER (PARTITION BY Cash_ost.cash_id order by Cash_ost.closedate desc) as rn
				|      
				|  FROM " + ИмяБд + ".[dbo].[Cash_Move] as Cash_ost (nolock)
				|  WHERE CONVERT(date, Cash_ost.closedate) = " + ВнешниеДанные.ФорматПоля(ДатаФормирования, Истина) + "
				|	and Cash_ost.ShopNo_rep = " + НомерМагазина + "
				|	and Cash_ost.Confirm_type IN (1, -1) and Cash_ost.operation_type > 0) as VZ_Max
				|	ON Cash_ost.cash_id = VZ_Max.cash_id and VZ_Max.rn = 1 and Cash_ost.id_doc = VZ_Max.id_doc
				|  WHERE CONVERT(date, Cash_ost.closedate) = " + ВнешниеДанные.ФорматПоля(ДатаФормирования, Истина) + "
				|	and Cash_ost.ShopNo_rep = " + НомерМагазина + " and Cash_ost.cash_id = 0
				|
				|
				|
				|SELECT 
				|      Cash_ost.cash_id as cash_id
				|      , isnull(Cash_ost.Ost_kon, 0) as Nach_ost
				|  FROM " + ИмяБд + ".[dbo].[Cash_ost] as Cash_ost (nolock)
				|  WHERE Cash_ost.ShopNo_rep = " + НомерМагазина + " and Cash_ost.cash_id = 0
				|
				|
				|
				|SELECT 
				|      Checks.CashId as cash_id
				|      , isnull(Checks.balance_ost, 0) as Nach_ost
				|  FROM " + ИмяБд + ".[dbo].[Checks] as Checks (nolock)
				|INNER JOIN (SELECT 
				|      Checks.closedate
				|      ,Checks.CashId as cash_id
				|      ,Checks.CheckUID as CheckUID
				|      ,ROW_NUMBER() OVER (PARTITION BY Checks.CashId order by Checks.closedate desc) as rn
				|      
				|  FROM " + ИмяБд + ".[dbo].[Checks] as Checks (nolock)
				|  WHERE CONVERT(date, Checks.closedate) = " + ВнешниеДанные.ФорматПоля(ДатаФормирования - 1, Истина) + "
				|	and Checks.ShopNo_rep = " + НомерМагазина + ") as VZ_Max
				|	ON Checks.CashId = VZ_Max.cash_id and VZ_Max.rn = 1 and Checks.CheckUID = VZ_Max.CheckUID
				|  WHERE CONVERT(date, Checks.closedate) = " + ВнешниеДанные.ФорматПоля(ДатаФормирования - 1, Истина) + "
				|	and Checks.ShopNo_rep = " + НомерМагазина + "
				|
				|
				|SELECT 
				|      Checks.CashId as cash_id
				|      , isnull(Checks.balance_ost, 0) as Nach_ost
				|  FROM " + ИмяБд + ".[dbo].[Checks] as Checks (nolock)
				|INNER JOIN (SELECT 
				|      Checks.closedate
				|      ,Checks.CashId as cash_id
				|      ,Checks.CheckUID as CheckUID
				|      ,ROW_NUMBER() OVER (PARTITION BY Checks.CashId order by Checks.closedate desc) as rn
				|      
				|  FROM " + ИмяБд + ".[dbo].[Checks] as Checks (nolock)
				|  WHERE CONVERT(date, Checks.closedate) = " + ВнешниеДанные.ФорматПоля(ДатаФормирования, Истина) + "
				|	and Checks.ShopNo_rep = " + НомерМагазина + ") as VZ_Max
				|	ON Checks.CashId = VZ_Max.cash_id and VZ_Max.rn = 1 and Checks.CheckUID = VZ_Max.CheckUID
				|  WHERE CONVERT(date, Checks.closedate) = " + ВнешниеДанные.ФорматПоля(ДатаФормирования, Истина) + "
				|	and Checks.ShopNo_rep = " + НомерМагазина + "
				|
				|
				|
				|SELECT 
				|      Cash_ost.cash_id as cash_id
				|      , isnull(Cash_ost.Ost_kon, 0) as Nach_ost
				|  FROM " + ИмяБд + ".[dbo].[Cash_ost] as Cash_ost (nolock)
				|  WHERE Cash_ost.ShopNo_rep = " + НомерМагазина + " and Cash_ost.cash_id = 0
				|
				|
				|SELECT 
				|      Cash_Move.closedate
				|      ,Cash_Move.id_doc as id_doc
				|      ,Cash_Move.cash_id as cash_id
				|      ,Cash_Move.operation_type
				|      , Cash_Move.balance_ost 
				|			+ CASE WHEN Cash_Move.operation_type IN (" + СтрокаКодыОтрцОпераций + ") THEN 1 ELSE -1 END * Cash_Move.Cash_sum as Nach_ost
				|      , Cash_Move.balance_ost as Kon_ost
				|      , CASE WHEN Cash_Move.operation_type IN (" + СтрокаКодыОтрцОпераций + ") THEN 1 ELSE 0 END * Cash_Move.Cash_sum as Rashod
				|      , CASE WHEN Cash_Move.operation_type NOT IN (" + СтрокаКодыОтрцОпераций + ") THEN 1 ELSE 0 END * Cash_Move.Cash_sum as Prihod
				|  FROM " + ИмяБд + ".[dbo].[Cash_move] as Cash_Move (nolock)
				|  WHERE Cash_Move.closedate >= " + ВнешниеДанные.ФорматПоля(ДатаФормирования) + " and Cash_Move.closedate <= " + ВнешниеДанные.ФорматПоля(КонецДня(ДатаФормирования)) + " and Confirm_type IN (1) and Cash_Move.operation_type > 0 and Cash_Move.operation_type <> 9
				|	and Cash_Move.ShopNo_rep = " + НомерМагазина + "
				|
				|SELECT 
				|      Checks.cashid as cash_id
				|      , SUM(Checks.SumCash * CASE WHEN Checks.OperationType = 1 THEN 1 ELSE 0 END) as Prihod
				|      , SUM(Checks.SumCash * CASE WHEN Checks.OperationType = 3 THEN 1 ELSE 0 END) as Rashod
				|      
				|  FROM " + ИмяБд + ".[dbo].[Checks] as Checks (nolock)
				|  WHERE Checks.closedate >= " + ВнешниеДанные.ФорматПоля(ДатаФормирования) + " and Checks.closedate <= " + ВнешниеДанные.ФорматПоля(КонецДня(ДатаФормирования)) + "
				//+++АК ILIK 2018.06.25 ИП-00018883
				//|	and Checks.SumCash <> 0 and Checks.ShopNo_rep = " + НомерМагазина + " and isnull(Checks.N_terminal, '') = ''
				|	and Checks.SumCash <> 0 and Checks.ShopNo_rep = " + НомерМагазина + "
				//---АК ILIK
				|GROUP BY Checks.cashid
				|
				|SELECT 
				|      Checks.cashid as cash_id
				|      , SUM(Checks.SumCash * CASE WHEN Checks.OperationType = 1 THEN 1 ELSE 0 END) as Prihod
				|      , SUM(Checks.SumCash * CASE WHEN Checks.OperationType = 3 THEN 1 ELSE 0 END) as Rashod
				|      
				|  FROM " + ИмяБд + ".[dbo].[Checks] as Checks (nolock)
				|  WHERE Checks.closedate >= " + ВнешниеДанные.ФорматПоля(ДатаФормирования) + " and Checks.closedate <= " + ВнешниеДанные.ФорматПоля(КонецДня(ДатаФормирования)) + "
				//+++АК ILIK 2018.06.25 ИП-00018883
				//|	and Checks.SumCash <> 0 and Checks.ShopNo_rep = " + НомерМагазина + " and isnull(Checks.N_terminal, '') <> ''
				|	and Checks.SumCash <> 0 and Checks.ShopNo_rep = " + НомерМагазина + " and 1 <> 1
				//---АК ILIK
				|GROUP BY Checks.cashid
				|";
				
	//считывание начлаьного остатка по движениям предыдущего дня
	Сообщить(ЗапросСкуль);
	Попытка	
		Выборка = ADOСоединение.Execute(ЗапросСкуль);
		
		Выборка.MoveFirst();
		Пока НЕ Выборка.EOF() Цикл
			СтрокаДоб = ТабОстаткиНач.Добавить();
			СтрокаДоб.Касса = Выборка.Fields("cash_id").Value;
			СтрокаДоб.Остаток = Выборка.Fields("Nach_ost").Value;
			Выборка.MoveNext();
		КонецЦикла;	
	Исключение
	КонецПопытки;
	
	Выборка = Выборка.NextRecordSet();
	
	//считывание начального остатка по движениям текущего дня
	Попытка			
		Выборка.MoveFirst();
		Пока НЕ Выборка.EOF() Цикл
			Если ТабОстаткиНач.Найти(Выборка.Fields("cash_id").Value, "Касса") = Неопределено Тогда
				СтрокаДоб = ТабОстаткиНач.Добавить();
				СтрокаДоб.Касса = Выборка.Fields("cash_id").Value;
				СтрокаДоб.Остаток = Выборка.Fields("Nach_ost").Value;
			КонецЕсли;	
			Выборка.MoveNext();
		КонецЦикла;	
	Исключение
	КонецПопытки;
	
	Выборка = Выборка.NextRecordSet();
				
	Попытка			
		Выборка.MoveFirst();
		Пока НЕ Выборка.EOF() Цикл
			СтрокаДоб = ТабОстаткиКон.Добавить();
			СтрокаДоб.Касса = Выборка.Fields("cash_id").Value;
			СтрокаДоб.Остаток = Выборка.Fields("Kon_ost").Value;
			Выборка.MoveNext();
		КонецЦикла;	
	Исключение
	КонецПопытки;
	
	Выборка = Выборка.NextRecordSet();
	
	//считывание остатков по таблице остатков
	Попытка			
		Выборка.MoveFirst();
		Пока НЕ Выборка.EOF() Цикл
			Если ТабОстаткиНач.Найти(Выборка.Fields("cash_id").Value, "Касса") = Неопределено Тогда
				СтрокаДоб = ТабОстаткиНач.Добавить();
				СтрокаДоб.Касса = Выборка.Fields("cash_id").Value;
				СтрокаДоб.Остаток = Выборка.Fields("Nach_ost").Value;
			КонецЕсли;
			Если ТабОстаткиКон.Найти(Выборка.Fields("cash_id").Value, "Касса") = Неопределено Тогда
				СтрокаДоб = ТабОстаткиКон.Добавить();
				СтрокаДоб.Касса = Выборка.Fields("cash_id").Value;
				СтрокаДоб.Остаток = Выборка.Fields("Nach_ost").Value;
			КонецЕсли;
			Выборка.MoveNext();
		КонецЦикла;	
	Исключение
	КонецПопытки;
	
	Выборка = Выборка.NextRecordSet();
	
	Попытка	
		Выборка.MoveFirst();
		Пока НЕ Выборка.EOF() Цикл
			СтрокаДоб = ТабОстаткиНач.Добавить();
			СтрокаДоб.Касса = Выборка.Fields("cash_id").Value;
			СтрокаДоб.Остаток = Выборка.Fields("Nach_ost").Value;
			Выборка.MoveNext();
		КонецЦикла;	
	Исключение
	КонецПопытки;
	
	Выборка = Выборка.NextRecordSet();
	
	Попытка			
		Выборка.MoveFirst();
		Пока НЕ Выборка.EOF() Цикл
			СтрокаДоб = ТабОстаткиКон.Добавить();
			СтрокаДоб.Касса = Выборка.Fields("cash_id").Value;
			СтрокаДоб.Остаток = Выборка.Fields("Kon_ost").Value;
			Выборка.MoveNext();
		КонецЦикла;	
	Исключение
	КонецПопытки;
	
	Выборка = Выборка.NextRecordSet();
	
	//считывание остатков по таблице остатков
	Попытка			
		Выборка.MoveFirst();
		Пока НЕ Выборка.EOF() Цикл
			Если ТабОстаткиНач.Найти(Выборка.Fields("cash_id").Value, "Касса") = Неопределено Тогда
				СтрокаДоб = ТабОстаткиНач.Добавить();
				СтрокаДоб.Касса = Выборка.Fields("cash_id").Value;
				СтрокаДоб.Остаток = Выборка.Fields("Nach_ost").Value;
			КонецЕсли;
			Если ТабОстаткиКон.Найти(Выборка.Fields("cash_id").Value, "Касса") = Неопределено Тогда
				СтрокаДоб = ТабОстаткиКон.Добавить();
				СтрокаДоб.Касса = Выборка.Fields("cash_id").Value;
				СтрокаДоб.Остаток = Выборка.Fields("Nach_ost").Value;
			КонецЕсли;
			Выборка.MoveNext();
		КонецЦикла;	
	Исключение
	КонецПопытки;
	
	
	Для Каждого СтрокаОст Из ТабОстаткиНач Цикл
		СтрокаДоб = ТабОстатки.Добавить();
		СтрокаДоб.Касса = СтрокаОст.Касса;
		СтрокаДоб.НачальныйОстаток = СтрокаОст.Остаток;
	КонецЦикла;
	
	Для Каждого СтрокаОст Из ТабОстаткиКон Цикл
		СтрокаДоб = ТабОстатки.Добавить();
		СтрокаДоб.Касса = СтрокаОст.Касса;
		СтрокаДоб.КонечныйОстаток = СтрокаОст.Остаток;
	КонецЦикла;
	
	ТабОстатки.Свернуть("Касса", "НачальныйОстаток, КонечныйОстаток, СуммаПриход, СуммаРасход");
	
	Выборка = Выборка.NextRecordSet();
								
	Попытка			
		Выборка.MoveFirst();
		Пока НЕ Выборка.EOF() Цикл
			СтрокаДоб = ТаблицаДвижения.Добавить();
			СтрокаДоб.Касса = Выборка.Fields("cash_id").Value;
			СтрокаДоб.id_doc = Выборка.Fields("id_doc").Value;
			СтрокаДоб.ДатаОперации = Выборка.Fields("closedate").Value;
			Если Выборка.Fields("operation_type").Value >= 0 Тогда
				СтрокаКеш = ТабОперацииКеш.Найти(Выборка.Fields("operation_type").Value, "code_operation");
				Если СтрокаКеш <> Неопределено Тогда
					СтрокаДоб.КодОперации = СтрокаКеш.Ссылка;
				КонецЕсли;	
			КонецЕсли;
			//СтрокаДоб.НачальныйОстаток = Выборка.Fields("Nach_ost").Value;
			//СтрокаДоб.КонечныйОстаток = Выборка.Fields("Kon_ost").Value;
			СтрокаДоб.СуммаПриход = Выборка.Fields("Prihod").Value;
			СтрокаДоб.СуммаРасход = Выборка.Fields("Rashod").Value;
			
			СтрокаОст = ТабОстатки.Добавить();
			СтрокаОст.Касса = Выборка.Fields("cash_id").Value;
			СтрокаОст.СуммаПриход = СтрокаДоб.СуммаПриход;
			СтрокаОст.СуммаРасход = СтрокаДоб.СуммаРасход;
			
			Выборка.MoveNext();
		КонецЦикла;	
	Исключение
	КонецПопытки;
	
	Выборка = Выборка.NextRecordSet();
								
	Попытка			
		Выборка.MoveFirst();
		Пока НЕ Выборка.EOF() Цикл
			СтрокаДоб = ТаблицаДвижения.Добавить();
			СтрокаДоб.Касса = Выборка.Fields("cash_id").Value;
			СтрокаДоб.КодОперации = "Розничные операции по кассе";
			//СтрокаДоб.НачальныйОстаток = Выборка.Fields("Nach_ost").Value;
			//СтрокаДоб.КонечныйОстаток = Выборка.Fields("Kon_ost").Value;
			СтрокаДоб.СуммаПриход = Выборка.Fields("Prihod").Value;
			СтрокаДоб.СуммаРасход = Выборка.Fields("Rashod").Value;
			
			СтрокаОст = ТабОстатки.Добавить();
			СтрокаОст.Касса = Выборка.Fields("cash_id").Value;
			СтрокаОст.СуммаПриход = СтрокаДоб.СуммаПриход;
			СтрокаОст.СуммаРасход = СтрокаДоб.СуммаРасход;
			
			Выборка.MoveNext();
		КонецЦикла;	
	Исключение
	КонецПопытки;
	
	Выборка = Выборка.NextRecordSet();
								
	Попытка			
		Выборка.MoveFirst();
		Пока НЕ Выборка.EOF() Цикл
			СтрокаДоб = ТаблицаДвижения.Добавить();
			СтрокаДоб.Касса = Выборка.Fields("cash_id").Value;
			СтрокаДоб.КодОперации = "Розничные операции по кассе (доставка)";
			//СтрокаДоб.НачальныйОстаток = Выборка.Fields("Nach_ost").Value;
			//СтрокаДоб.КонечныйОстаток = Выборка.Fields("Kon_ost").Value;
			СтрокаДоб.СуммаПриход = Выборка.Fields("Prihod").Value;
			СтрокаДоб.СуммаРасход = Выборка.Fields("Rashod").Value;
			
			СтрокаОст = ТабОстатки.Добавить();
			СтрокаОст.Касса = Выборка.Fields("cash_id").Value;
			СтрокаОст.СуммаПриход = СтрокаДоб.СуммаПриход;
			СтрокаОст.СуммаРасход = СтрокаДоб.СуммаРасход;
			
			Выборка.MoveNext();
		КонецЦикла;	
	Исключение
	КонецПопытки;
	
	ADOСоединение.Close();
	
	ТабОстатки.Свернуть("Касса", "НачальныйОстаток, КонечныйОстаток, СуммаПриход, СуммаРасход");
	
	ТабОстатки.Сортировать("Касса");
	ТаблицаДвижения.Сортировать("Касса, ДатаОперации");
	
	Область = Макет.ПолучитьОбласть("Шапка");
	Область.Параметры.ДатаОтчета = Формат(ДатаФормирования, "ДФ=dd.MM.yyyy");
	ТабДок.Вывести(Область);
	
	Для Каждого СтрокаОстаток Из ТабОстатки Цикл
		Область = Макет.ПолучитьОбласть("ГруппировкаКасса");
		Область.Параметры.Заполнить(СтрокаОстаток);
		Область.Параметры.ГруппировкаКасса = ?(СтрокаОстаток.Касса = "0", "Ц", СтрокаОстаток.Касса);
		ТабДок.Вывести(Область);
		СтрокиДвижения = ТаблицаДвижения.НайтиСтроки(Новый Структура("Касса", СтрокаОстаток.Касса));
		Для Каждого СтрокаДвижение Из СтрокиДвижения Цикл
			Область = Макет.ПолучитьОбласть("Строка");
			Область.Параметры.Заполнить(СтрокаДвижение);
			Если СтрокаДвижение.КодОперации = "Розничные операции по кассе" Тогда
				РасшифровкаСтроки = Новый Структура();
				РасшифровкаСтроки.Вставить("ТипСтроки", "РозничныеДвиженияПоКассе");
				РасшифровкаСтроки.Вставить("Касса", СтрокаДвижение.Касса);
				РасшифровкаСтроки.Вставить("Дата", ДатаФормирования);
			ИначеЕсли СтрокаДвижение.КодОперации = "Розничные операции по кассе (доставка)" Тогда
				РасшифровкаСтроки = Новый Структура();
				РасшифровкаСтроки.Вставить("ТипСтроки", "РозничныеДвиженияПоКассеДоставка");
				РасшифровкаСтроки.Вставить("Касса", СтрокаДвижение.Касса);
				РасшифровкаСтроки.Вставить("Дата", ДатаФормирования);
			Иначе	
				РасшифровкаСтроки = Новый Структура();
				РасшифровкаСтроки.Вставить("ТипСтроки", "ДвижениеПоКассе");
				РасшифровкаСтроки.Вставить("id_doc", СтрокаДвижение.id_doc);
			КонецЕсли;	
			Область.Параметры.Расшифровка = РасшифровкаСтроки;
			ТабДок.Вывести(Область);
		КонецЦикла;	
	КонецЦикла;
	
	Возврат ТабДок;
	
КонецФункции

&НаСервере
Функция СформироватьЗаДату(ДатаФормирования)
	
	ТабДок = Новый ТабличныйДокумент();
	ОбъектОбр = РеквизитФормыВЗначение("Объект");
	Макет = ОбъектОбр.ПолучитьМакет("Ведомость");
	
	ТаблицаДвижения = Новый ТаблицаЗначений();
	ТаблицаДвижения.Колонки.Добавить("Касса", Новый ОписаниеТипов("Строка",,Новый КвалификаторыСтроки(100)));
	ТаблицаДвижения.Колонки.Добавить("id_doc", Новый ОписаниеТипов("Строка",,Новый КвалификаторыСтроки(100)));
	ТаблицаДвижения.Колонки.Добавить("КодОперации");
	ТаблицаДвижения.Колонки.Добавить("ДатаОперации", Новый ОписаниеТипов("Дата",,,Новый КвалификаторыДаты(ЧастиДаты.ДатаВремя)));
	ТаблицаДвижения.Колонки.Добавить("СуммаПриход", Новый ОписаниеТипов("Число",Новый КвалификаторыЧисла(15,2)));
	ТаблицаДвижения.Колонки.Добавить("СуммаРасход", Новый ОписаниеТипов("Число",Новый КвалификаторыЧисла(15,2)));
	ТаблицаДвижения.Колонки.Добавить("Комментарий", Новый ОписаниеТипов("Строка",,Новый КвалификаторыСтроки(100)));
	
	ТабОстатки = Новый ТаблицаЗначений();
	ТабОстатки.Колонки.Добавить("Касса", Новый ОписаниеТипов("Строка",,Новый КвалификаторыСтроки(100)));
	ТабОстатки.Колонки.Добавить("НачальныйОстаток", Новый ОписаниеТипов("Число",Новый КвалификаторыЧисла(15,2)));
	ТабОстатки.Колонки.Добавить("СуммаПриход", Новый ОписаниеТипов("Число",Новый КвалификаторыЧисла(15,2)));
	ТабОстатки.Колонки.Добавить("СуммаРасход", Новый ОписаниеТипов("Число",Новый КвалификаторыЧисла(15,2)));
	ТабОстатки.Колонки.Добавить("КонечныйОстаток", Новый ОписаниеТипов("Число",Новый КвалификаторыЧисла(15,2)));
	
	Запрос = Новый Запрос();
	Запрос.Текст = "ВЫБРАТЬ
	               |	ТипыОпераций.Ссылка,
	               |	ТипыОпераций.code_operation,
	               |	ТипыОпераций.znak
	               |ИЗ
	               |	Справочник.ТипыОперацийМагазина КАК ТипыОпераций
	               |ГДЕ
	               |	ТипыОпераций.table_operation = &table_operation
	               |	И ТипыОпераций.field_operation = &field_operation";
				   
	Запрос.УстановитьПараметр("table_operation", "Cash_move");
	Запрос.УстановитьПараметр("field_operation", "operation_type");
	ТабОперацииКеш = Запрос.Выполнить().Выгрузить();
	
	СтрокаКодыОтрцОпераций = "99999";
	Для Каждого СтрокаОперации Из ТабОперацииКеш Цикл
		Если СтрокаОперации.znak = -1 Тогда
			СтрокаКодыОтрцОпераций = СтрокаКодыОтрцОпераций + ", " + ВнешниеДанные.ФорматПоля(СтрокаОперации.code_operation);
		КонецЕсли;	
	КонецЦикла;	
	
	ADOСоединение = ВнешниеДанные.ПолучитьADOСоединение();
	
	ИмяБд = "SMS_Repl";
	НомерМагазина = ВнешниеДанные.ФорматПоля(ПараметрыСеанса.НомерТочкиПоАйпи);
	
	ЗапросСкуль = "select *
					|from SMS_REPL.dbo.Ostatki_and_Dvig_Cash (" + НомерМагазина + ", " + ВнешниеДанные.ФорматПоля(ДатаФормирования, Истина) + ")";
				
	//считывание начлаьного остатка по движениям предыдущего дня
	Попытка	
		Выборка = ADOСоединение.Execute(ЗапросСкуль);
		
		Выборка.MoveFirst();
		Пока НЕ Выборка.EOF() Цикл
			Если Выборка.Fields("ТипСтроки").Value = "Розничный оборот по кассе"
				ИЛИ Выборка.Fields("ТипСтроки").Value = "Розничный оборот по кассе (доставка)" Тогда
				СтрокаДоб = ТаблицаДвижения.Добавить();
				СтрокаДоб.Касса = Выборка.Fields("Касса").Value;
				СтрокаДоб.КодОперации = Выборка.Fields("ТипСтроки").Value;
				СтрокаДоб.СуммаПриход = Выборка.Fields("Приход").Value;
				СтрокаДоб.СуммаРасход = Выборка.Fields("Расход").Value;
				
				СтрокаОст = ТабОстатки.Добавить();
				СтрокаОст.Касса = СтрокаДоб.Касса;
				СтрокаОст.СуммаПриход = СтрокаДоб.СуммаПриход;
				СтрокаОст.СуммаРасход = СтрокаДоб.СуммаРасход;
			КонецЕсли;
			
			Если Выборка.Fields("ТипСтроки").Value = "Операции по CashMove" Тогда
				КодОперации = Неопределено;
				Если Выборка.Fields("ТипОперации").Value >= 0 Тогда
					СтрокаКеш = ТабОперацииКеш.Найти(Выборка.Fields("ТипОперации").Value, "code_operation");
					Если СтрокаКеш <> Неопределено Тогда
						КодОперации = СтрокаКеш.Ссылка;
					КонецЕсли;	
				КонецЕсли;
				ВыполнятьСверткуЗаписи = Ложь;
				Если Выборка.Fields("Касса").Value = 0
					И Выборка.Fields("ТипОперации").Value = 1
					И Найти(Выборка.Fields("Комментарий").Value, "Корректировка доставки по кассе:") > 0 Тогда
					ВыполнятьСверткуЗаписи = Истина;
				ИначеЕсли Выборка.Fields("Касса").Value <> 0
					И Выборка.Fields("ТипОперации").Value = 2
					И Найти(Выборка.Fields("Комментарий").Value, "Корректировка по доставке") > 0 Тогда
					ВыполнятьСверткуЗаписи = Истина;
				КонецЕсли;
				Если ВыполнятьСверткуЗаписи Тогда
					СтрокиТаб = ТаблицаДвижения.НайтиСтроки(Новый Структура("Касса, КодОперации", СокрЛП(Выборка.Fields("Касса").Value), КодОперации));
					Если СтрокиТаб.Количество() = 0 Тогда
						СтрокаДоб = ТаблицаДвижения.Добавить();
					Иначе
						СтрокаДоб = СтрокиТаб[0];
					КонецЕсли;	
				Иначе	
					СтрокаДоб = ТаблицаДвижения.Добавить();
					СтрокаДоб.id_doc = Выборка.Fields("АйдиОперации").Value;
				КонецЕсли;	
				СтрокаДоб.Касса = Выборка.Fields("Касса").Value;
				СтрокаДоб.ДатаОперации = Выборка.Fields("ДатаОперации").Value;
				СтрокаДоб.КодОперации = КодОперации;
				
				СтрокаДоб.СуммаПриход = СтрокаДоб.СуммаПриход + Выборка.Fields("Приход").Value;
				СтрокаДоб.СуммаРасход = СтрокаДоб.СуммаРасход + Выборка.Fields("Расход").Value;
				СтрокаДоб.Комментарий = СокрЛП(Выборка.Fields("Комментарий").Value);
				
				СтрокаОст = ТабОстатки.Добавить();
				СтрокаОст.Касса = СтрокаДоб.Касса;
				СтрокаОст.СуммаПриход = Выборка.Fields("Приход").Value;
				СтрокаОст.СуммаРасход = Выборка.Fields("Расход").Value;
			КонецЕсли;
			
			Если Выборка.Fields("ТипСтроки").Value = "Конечный остаток" Тогда
				СтрокаОст = ТабОстатки.Добавить();
				СтрокаОст.Касса = Выборка.Fields("Касса").Value;
				СтрокаОст.КонечныйОстаток = Выборка.Fields("ОстатокНаКонец").Value;
			КонецЕсли;
			
			Если Выборка.Fields("ТипСтроки").Value = "Начальный остаток" Тогда
				СтрокаОст = ТабОстатки.Добавить();
				СтрокаОст.Касса = Выборка.Fields("Касса").Value;
				СтрокаОст.НачальныйОстаток = Выборка.Fields("ОстатокНаНачало").Value;
			КонецЕсли;
			
			Выборка.MoveNext();
		КонецЦикла;	
	Исключение
	КонецПопытки;
	
	ADOСоединение.Close();
	
	ТабОстатки.Свернуть("Касса", "НачальныйОстаток, КонечныйОстаток, СуммаПриход, СуммаРасход");
	
	ТабОстатки.Сортировать("Касса");
	ТаблицаДвижения.Сортировать("Касса, ДатаОперации");
	
	Область = Макет.ПолучитьОбласть("Шапка");
	Область.Параметры.ДатаОтчета = Формат(ДатаФормирования, "ДФ=dd.MM.yyyy");
	ТабДок.Вывести(Область);
	
	Для Каждого СтрокаОстаток Из ТабОстатки Цикл
		Область = Макет.ПолучитьОбласть("ГруппировкаКасса");
		Область.Параметры.Заполнить(СтрокаОстаток);
		Область.Параметры.ГруппировкаКасса = ?(СтрокаОстаток.Касса = "0", "Ц", СтрокаОстаток.Касса);
		ТабДок.Вывести(Область);
		СтрокиДвижения = ТаблицаДвижения.НайтиСтроки(Новый Структура("Касса", СтрокаОстаток.Касса));
		Для Каждого СтрокаДвижение Из СтрокиДвижения Цикл
			Область = Макет.ПолучитьОбласть("Строка");
			Область.Параметры.Заполнить(СтрокаДвижение);
			Если ЗначениеЗаполнено(СтрокаДвижение.Комментарий) Тогда
				Область.Параметры.КодОперации = СокрЛП(Область.Параметры.КодОперации) + Символы.ПС + СтрокаДвижение.Комментарий;
			КонецЕсли;	
			Если СтрокаДвижение.КодОперации = "Розничные операции по кассе" Тогда
				РасшифровкаСтроки = Новый Структура();
				РасшифровкаСтроки.Вставить("ТипСтроки", "РозничныеДвиженияПоКассе");
				РасшифровкаСтроки.Вставить("Касса", СтрокаДвижение.Касса);
				РасшифровкаСтроки.Вставить("Дата", ДатаФормирования);
			ИначеЕсли СтрокаДвижение.КодОперации = "Розничные операции по кассе (доставка)" Тогда
				РасшифровкаСтроки = Новый Структура();
				РасшифровкаСтроки.Вставить("ТипСтроки", "РозничныеДвиженияПоКассеДоставка");
				РасшифровкаСтроки.Вставить("Касса", СтрокаДвижение.Касса);
				РасшифровкаСтроки.Вставить("Дата", ДатаФормирования);	
			Иначе	
				РасшифровкаСтроки = Новый Структура();
				РасшифровкаСтроки.Вставить("ТипСтроки", "ДвижениеПоКассе");
				РасшифровкаСтроки.Вставить("id_doc", СтрокаДвижение.id_doc);
			КонецЕсли;	
			Область.Параметры.Расшифровка = РасшифровкаСтроки;
			ТабДок.Вывести(Область);
		КонецЦикла;	
	КонецЦикла;
	
	Возврат ТабДок;
	
КонецФункции


&НаСервере
Процедура СформироватьНаСервере()
	
	ТабДокумент.Очистить();
	ДатаОбработки = НачалоДня(?(Объект.ФормироватьСДаты > ТекущаяДата(), ТекущаяДата(), Объект.ФормироватьСДаты));
	Пока ДатаОбработки <= ТекущаяДата() Цикл
		ТабДокумент.Вывести(СформироватьЗаДату(ДатаОбработки));
		ДатаОбработки = ДатаОбработки + 86400;
	КонецЦикла;
	
КонецПроцедуры	

&НаКлиенте
Процедура Сформировать(Команда)
	
	СформироватьНаСервере();
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	Если СформироватьПриОткрытии Тогда
		СформироватьНаСервере();
	КонецЕсли;	
	
КонецПроцедуры

&НаКлиенте
Процедура Печать(Команда)
	
	ТабДокумент.Напечатать(РежимИспользованияДиалогаПечати.Использовать);
	
КонецПроцедуры

&НаСервере
Функция ПолучитьИПодключитьВнешнююОбработкуКассовыеОперации()
	
	Ссылка = Справочники.ВнешниеОбработки.НайтиПоНаименованию("КассовыеОперации_Магазины");
	
	АдресВоВременномХранилище = ПоместитьВоВременноеХранилище(Ссылка.ХранилищеВнешнейОбработки.Получить());
	
	ИмяОбработки = ВнешниеОбработки.Подключить(АдресВоВременномХранилище, , Ложь);
	
	ВнешниеОбработки.Создать(ИмяОбработки);
	
	Возврат ИмяОбработки;
	
КонецФункции

&НаКлиенте
Процедура ТабДокументОбработкаРасшифровки(Элемент, Расшифровка, СтандартнаяОбработка)
	
	Если ТипЗнч(Расшифровка) = Тип("Структура") Тогда
		СтандартнаяОбработка = Ложь;
		Если Расшифровка.ТипСтроки = "ДвижениеПоКассе"
			И ЗначениеЗаполнено(Расшифровка.id_doc) Тогда
			ИмяОбработки = ПолучитьИПодключитьВнешнююОбработкуКассовыеОперации();
			ОткрытьФорму("ВнешняяОбработка."+ ИмяОбработки +".Форма.ФормаСписка", Новый Структура("ИмяВнешнейОбработки", ИмяОбработки),, "КО_ЖурналКассовыхОпераций");
			Оповестить("ЗапросНаОткрытиеКассовойОперации", Новый Структура("РежимСозданияОперации, Ссылка, id_doc", Ложь, Неопределено, Сред(Расшифровка.id_doc, 2, 36)));
		ИначеЕсли Расшифровка.ТипСтроки = "РозничныеДвиженияПоКассе" Тогда
			ОткрытыеОкна = ПолучитьОкна();
			ОкноКассОперации = Неопределено;
			Для Каждого Окно Из ОткрытыеОкна Цикл
				Если Окно.Основное Тогда
					Продолжить;
				КонецЕсли;
				ОкноСодержимое = Окно.ПолучитьСодержимое();
				Если ОкноСодержимое.КлючУникальности = "РасшифровкаРозничныхПродаж" Тогда
					ОкноСодержимое.Закрыть();
				КонецЕсли;	
			КонецЦикла;
			ОткрытьФорму("ВнешняяОбработка."+ ИмяВнешнейОбработки +".Форма.РасшифровкаРозничныхПродаж", Новый Структура("ДатаРасшифровки, Касса", Расшифровка.Дата, Расшифровка.Касса),, "КО_РасшифровкаРозничныхПродаж");
		ИначеЕсли Расшифровка.ТипСтроки = "РозничныеДвиженияПоКассеДоставка" Тогда
			ОткрытыеОкна = ПолучитьОкна();
			ОкноКассОперации = Неопределено;
			Для Каждого Окно Из ОткрытыеОкна Цикл
				Если Окно.Основное Тогда
					Продолжить;
				КонецЕсли;
				ОкноСодержимое = Окно.ПолучитьСодержимое();
				Если ОкноСодержимое.КлючУникальности = "РасшифровкаРозничныхПродаж" Тогда
					ОкноСодержимое.Закрыть();
				КонецЕсли;	
			КонецЦикла;
			ОткрытьФорму("ВнешняяОбработка."+ ИмяВнешнейОбработки +".Форма.РасшифровкаРозничныхПродажДоставка", Новый Структура("ДатаРасшифровки, Касса", Расшифровка.Дата, Расшифровка.Касса),, "КО_РасшифровкаРозничныхПродаж");	
		КонецЕсли;	
	КонецЕсли;	
	
КонецПроцедуры
