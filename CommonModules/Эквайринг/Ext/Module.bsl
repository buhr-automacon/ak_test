﻿Функция ПолучитьТерминал(Терминал,ДатаДокумента) Экспорт
	Если ДатаДокумента >= Дата("20131201000000") Тогда
	    Возврат ?(Терминал.Справочно,Справочники.Терминалы.ПустаяСсылка(),Терминал);
	Иначе
		Возврат Терминал;
	КонецЕсли
КонецФункции

Функция Получить_ТТ_Терминала(Дата_Расч,Терминал,ТаблицаКешПривязокТТ=неопределено,Сообщать=истина) Экспорт
	Если НЕ ЗначениеЗаполнено(Терминал) Тогда
		Возврат Справочники.СтруктурныеЕдиницы.ПустаяСсылка();
	КонецЕсли;	
	
	Если ТаблицаКешПривязокТТ = Неопределено
		ИЛИ ТаблицаКешПривязокТТ.Найти(НачалоДня(Дата_Расч), "Дата") = Неопределено Тогда
		Если ТаблицаКешПривязокТТ = Неопределено Тогда
			ТаблицаКешПривязокТТ = Новый ТаблицаЗначений();
			ТаблицаКешПривязокТТ.Колонки.Добавить("Дата");
			ТаблицаКешПривязокТТ.Колонки.Добавить("Терминал");
			ТаблицаКешПривязокТТ.Колонки.Добавить("ТТ");
			ТаблицаКешПривязокТТ.Индексы.Добавить("Дата, Терминал");
		КонецЕсли;	
		//+++АК LAGP 2018.08.02 ИП-00019421 Добавлено упорядочивание по периоду для получения в первую очередь самых свежих записей
		ТекстЗапроса="ВЫБРАТЬ
		             |	ПривязкиОборудованияКРабочимМестамСрезПоследних.РабочееМесто.СтруктурнаяЕдиница КАК ТТ,
		             |	ПривязкиОборудованияКРабочимМестамСрезПоследних.Терминал
		             |ИЗ
		             |	РегистрСведений.ПривязкиОборудованияКРабочимМестам.СрезПоследних(&НаДату, ) КАК ПривязкиОборудованияКРабочимМестамСрезПоследних
		             |
		             |УПОРЯДОЧИТЬ ПО
		             |	ПривязкиОборудованияКРабочимМестамСрезПоследних.Период УБЫВ
		             |;
		             |
		             |////////////////////////////////////////////////////////////////////////////////
		             |ВЫБРАТЬ
		             |	Терминалы.Ссылка,
		             |	Терминалы.Код
		             |ИЗ
		             |	Справочник.Терминалы КАК Терминалы
		             |;
		             |
		             |////////////////////////////////////////////////////////////////////////////////
		             |ВЫБРАТЬ
		             |	СтруктурныеЕдиницы.Ссылка,
		             |	СтруктурныеЕдиницы.НомерТочки
		             |ИЗ
		             |	Справочник.СтруктурныеЕдиницы КАК СтруктурныеЕдиницы
		             |ГДЕ
		             |	СтруктурныеЕдиницы.НомерТочки <> 0";
		//---АК LAGP
		Запрос=Новый Запрос(ТекстЗапроса);
		Запрос.УстановитьПараметр("НаДату",Дата_Расч);
		Запрос.УстановитьПараметр("Терминал",Терминал);
		Результаты = Запрос.ВыполнитьПакет();
		Выборка = Результаты[0].Выбрать();
		ТабТерминалы = Результаты[1].Выгрузить();
		ТабТТ = Результаты[2].Выгрузить();
		Пока Выборка.Следующий() Цикл
			СтрокаДоб = ТаблицаКешПривязокТТ.Добавить();
			СтрокаДоб.Дата = НачалоДня(Дата_Расч);
			СтрокаДоб.Терминал = Выборка.Терминал;
			СтрокаДоб.ТТ = Выборка.ТТ;
		КонецЦикла;
		
	//	//ADOСоединение = ВнешниеДанные.ПолучитьADOСоединение();
	//	ADOСоединение = Новый COMОбъект("ADODB.Connection");
	////	SQLDMOServer.LoginTimeout = 0;
	//	ADOСоединение.ConnectionTimeOut = 0;
	//	ADOСоединение.CommandTimeOut    = 0;
	////	ADOСоединение.Mode              = 3; 
	//	ADOСоединение.ConnectionString  = "SERVER=10.0.0.40; DRIVER=SQL Server; UID=izbenka; PWD=cjyzcjyz; OLE DB Services=-2;";
	//	ADOСоединение.Open();
	//	
	//	стрТекстЗапросаSQL = "
	//	|select cm.number_cert courier
	//	|	,c.ShopNo
	//	|	
	//	|from Loyalty..Coupon_move cm (nolock)
	//	|inner join SMS_UNION..Checks c (nolock) on c.CashCheckNo = cm.CashCheckNo 
	//	|	and convert(date,c.CloseDate) = convert(date,cm.time_add) 
	//	|	and cm.cashid/10 = c.ShopNo
	//	|inner join SMS_UNION..Cash ca (nolock) on c.CashUID = ca.CashUID AND ca.CashID = cm.CashID
	//	|left join SMS_UNION..CreditCardUsed ccu (nolock) on c.CheckUID = ccu.CheckUID
	//	|where cm.id_type_coupon = 'D46DA4DA-6E0D-4C2F-91D7-E89669ADC7E9'
	//	|and CONVERT(date,cm.time_add) = CONVERT(DATE,'" + Формат(Дата_Расч, "ДФ=yyyy-MM-dd") + "')";
	//	
	//	Попытка
	//		rs = ADOСоединение.Execute(стрТекстЗапросаSQL);
	//		Пока НЕ rs.EOF() Цикл
	//			СтрокаТерминал = ТабТерминалы.Найти(Формат(Rs.Fields("courier").Value, "ЧГ=0"), "Код");
	//			Если СтрокаТерминал <> Неопределено Тогда
	//				СтрокаДоб = ТаблицаКешПривязокТТ.Добавить();
	//				СтрокаДоб.Дата = НачалоДня(Дата_Расч);
	//				СтрокаДоб.Терминал	= СтрокаТерминал.Ссылка;
	//				СтрокаТТ = ТабТТ.Найти(Rs.Fields("ShopNo").Value, "НомерТочки");
	//				СтрокаДоб.ТТ = ?(СтрокаТТ <> Неопределено, СтрокаТТ.Ссылка, Справочники.СтруктурныеЕдиницы.ПустаяСсылка());
	//			КонецЕсли;	
	//			rs.MoveNext();
	//		КонецЦикла;
	//	Исключение
	//	КонецПопытки;	
	//	ADOСоединение = Неопределено;
		
	КонецЕсли;	
	
	СтрокиКеш = ТаблицаКешПривязокТТ.НайтиСтроки(Новый Структура("Дата, Терминал", НачалоДня(Дата_Расч), Терминал));
	Если СтрокиКеш.Количество() > 0 Тогда
		Возврат СтрокиКеш[0].ТТ;
	КонецЕсли;
	Если Сообщать Тогда
		Сообщить("Для терминала "+Терминал+" нет информации о привязке к рабочим местам, взята точка, к которой он подчинен");
	КонецЕсли;	
	Возврат Терминал.Владелец;
КонецФункции	
