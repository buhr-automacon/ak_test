﻿
//+++АК SHEP 2018.07.06 ИП-00019140: добавлена форма

&НаСервере
Процедура ОбновитьСписокНаСервере()
	
	ТаблицаПеремещений.Очистить();
	
	ТекстЗапросаSQL = "
		|if OBJECT_ID('tempdb..#perem') is not null drop table #perem
		|
		|create table #perem(ДатаЗакрытия datetime
		|	, НомерМагазина int
		|	, МестоВыкладки varchar(500)
		|	, КолВоПозиций int
		|	, Id_doc varchar(36))
		|insert into #perem(ДатаЗакрытия,НомерМагазина,МестоВыкладки,КолВоПозиций,Id_doc)
		|exec sms_repl..Perem_list_1C " + ВнешниеДанные.ФорматПоля(ПараметрыСеанса.НомерТочкиПоАйпи) + "
		|
		|select * from #perem
		|";
	
	ADOСоединение = ВнешниеДанные.ПолучитьADOСоединение();
	rs = ADOСоединение.Execute(ТекстЗапросаSQL);
	
	Пока НЕ rs = Неопределено Цикл
		Если rs.Fields.Count > 0 Тогда
			Прервать;
		КонецЕсли;
		rs = rs.NextRecordSet();
	КонецЦикла;
	
	Попытка
		rs.MoveFirst();
		Пока НЕ rs.Eof() Цикл
			НовСтр = ТаблицаПеремещений.Добавить();
			НовСтр.ДатаДокумента = rs.Fields("ДатаЗакрытия").Value;
			НовСтр.МагазинОтправитель = rs.Fields("НомерМагазина").Value;
			//НовСтр.МагазинПолучатель = rs.Fields("Corr_id_tt").Value;
			НовСтр.МестоВыкладки = rs.Fields("МестоВыкладки").Value;
			НовСтр.КолВоПозиций = rs.Fields("КолВоПозиций").Value;
			НовСтр.Id_doc = rs.Fields("Id_doc").Value;
			rs.MoveNext();
		КонецЦикла;
	Исключение
	КонецПопытки;
	
	ADOСоединение.Close();
	
КонецПроцедуры	

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	ОбновитьСписокНаСервере();
	
КонецПроцедуры

&НаСервере
Функция СоздатьДокументНаСервере(ИдДок)
	
	УИДНовойОперации = "";
	
	ТекстЗапросаSQL = "
		|DECLARE @Message varchar(500)
		|DECLARE @Res_Doc_UID uniqueidentifier
		|
		|EXEC [SMS_REPL].[dbo].[CreatePerem_410_1C]
		|	@Doc_UID = " + ВнешниеДанные.ФорматПоля(ИдДок) + ",
		|	@CashierID = 111,
		|	@Message = @Message OUTPUT,
		|	@Res_Doc_UID = @Res_Doc_UID OUTPUT
		|
		|SELECT @Message as N'@Message',
		|	@Res_Doc_UID as N'@Res_Doc_UID'
		|";
	
	ADOСоединение = ВнешниеДанные.ПолучитьADOСоединение();
	rs = ADOСоединение.Execute(ТекстЗапросаSQL);
	
	Пока НЕ rs = Неопределено Цикл
		Если rs.Fields.Count > 0 Тогда
			Прервать;
		КонецЕсли;
		rs = rs.NextRecordSet();
	КонецЦикла;
	
	Попытка
		rs.MoveFirst();
		
		Пока НЕ rs.EOF() Цикл
			УИДНовойОперации = Rs.Fields("@Res_Doc_UID").Value;
			Если ЗначениеЗаполнено(УИДНовойОперации) Тогда
				УИДНовойОперации = НРег(Сред(УИДНовойОперации, 2, 36)); // т.к. возвращается {F3909518-7C01-4E7F-A17C-8F5173593592}
			Иначе
				УИДНовойОперации = rs.Fields("@Message").Value;
			КонецЕсли;
			rs.MoveNext();
		КонецЦикла;
	Исключение
	КонецПопытки;
	
	ADOСоединение.Close();
	
	ОбновитьСписокНаСервере();
	
	Возврат УИДНовойОперации;
	
КонецФункции

&НаКлиенте
Процедура СоздатьДокументПоВыделеннойСтроке(Команда)
	
	ТекущиеДанные = Элементы.ТаблицаПеремещений.ТекущиеДанные;
	Если ТекущиеДанные = Неопределено Тогда
		ПоказатьПредупреждение(, "Нужно выбрать перемещение!",, "Ошибка");
		Возврат;
	КонецЕсли;
	
	УИДНовойОперации = СоздатьДокументНаСервере(ТекущиеДанные.Id_doc);
	Если НЕ СтроковыеФункцииКлиентСервер.ЭтоУникальныйИдентификатор(УИДНовойОперации) Тогда
		ПоказатьПредупреждение(, УИДНовойОперации,, "Ошибка при создании перемещения");
		Возврат;
	КонецЕсли;
	
	ИмяОбработки = ПолучитьИПодключитьВнешнююОбработкуТоварныеОперации();
	ОткрытьФорму("ВнешняяОбработка."+ ИмяОбработки +".Форма.ФормаСписка", Новый Структура("ИмяВнешнейОбработки", ИмяОбработки),, "ТД_ЖурналТовародвижения");
	Оповестить("ЗапросНаОткрытиеТоварнойОперации", Новый Структура("ИД", ВРег(УИДНовойОперации)));
	
КонецПроцедуры

&НаКлиенте
Процедура ОбновитьСписок(Команда)
	
	ОбновитьСписокНаСервере();
	
КонецПроцедуры

//+++АК SHEP 2018.07.06 ИП-00019140
&НаСервереБезКонтекста
Функция ПолучитьИПодключитьВнешнююОбработкуТоварныеОперации()
	Возврат Обработки.РабочийСтолПродавца.ПолучитьИПодключитьВнешнююОбработкуТоварныеОперации();
КонецФункции
