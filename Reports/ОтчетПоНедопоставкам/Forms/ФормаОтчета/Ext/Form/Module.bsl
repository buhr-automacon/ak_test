﻿
&НаКлиенте
Процедура Сформировать(Команда)
	//Сообщить(ТекущаяДата());
	СформироватьСервер();
	//Сообщить(ТекущаяДата());
КонецПроцедуры

&НаСервере
Процедура СформироватьСервер()
	Отчет.Товары.Очистить();
	Результат.Очистить();
	ADOСоединение = ВнешниеДанные.ПолучитьADOСоединение();
	СтрМаг="";
	Если ЗначениеЗаполнено(Магазин) Тогда
		СтрМаг=" and TD.ShopNo_rep = " + ВнешниеДанные.ФорматПоля(Магазин.НомерТочки) + "";
	КонецЕсли; 
	//АК БЕЛН 05.09.2016++
	//ТекстЗапросаSQL = "SELECT TD.Id_doc, TD.opendate, TD.closedate, TD.id_tov, TD.id_kontr, CAST(CASE WHEN ISNULL(TD.Date_proizv, '1900-01-01') < '2000-01-01' THEN '1900-01-01' ELSE TD.Date_proizv END as datetime) as Date_proizv, TD.Quantity as Quantity, TD.Quantity_inv as Quantity_inv, TD.operation_type, TD.Corr_id_tt
	//			|, TD.Confirm_type, TD.Confirm_date, CAST(TD.Confirm_reason as integer) as Confirm_reason, TD.id_reason, TD.balance_ost, CAST(TD.tduid as nvarchar(36)) as tduid, TD.Descr, TD.Quantity_inv, TD.Basesum, TD.id_vikl, TD.CashierID, CONVERT(datetime, TD.time_delivery) as time_delivery, ISNULL(TD.Komment_raspr, '') as Komment_raspr
	//			|FROM  SMS_Repl.dbo.TD_move as TD with (nolock, index (ind1))
	//			| WHERE (TD.Id_doc = " + ВнешниеДанные.ФорматПоля(ИдДок) + " or (TD.Id_doc_General = " + ВнешниеДанные.ФорматПоля(ИдДок) + " and TD.Operation_type > 0)) and TD.ShopNo_rep = " + ВнешниеДанные.ФорматПоля(198) + "
	//			|	and CAST(ISNULL(TD.Confirm_reason, 0) as integer) <> 8";	
	ТекстЗапросаSQL = "SELECT TD.ShopNo_rep, TD.Id_doc, TD.opendate, TD.closedate, TD.id_tov, TD.id_kontr, CAST(CASE WHEN ISNULL(TD.Date_proizv, '1900-01-01') < '2000-01-01' THEN '1900-01-01' ELSE TD.Date_proizv END as datetime) as Date_proizv, TD.Quantity as Quantity, TD.Quantity_inv as Quantity_inv, TD.operation_type, TD.Corr_id_tt, TD.Upakovka_Opened
				|, TD.Confirm_type, TD.Confirm_date, CAST(TD.Confirm_reason as integer) as Confirm_reason, TD.id_reason, TD.balance_ost, CAST(TD.tduid as nvarchar(36)) as tduid, TD.Descr, TD.Quantity_inv, TD.Basesum, TD.id_vikl, TD.CashierID, CONVERT(datetime, TD.time_delivery) as time_delivery, ISNULL(TD.Komment_raspr, '') as Komment_raspr
				|FROM  SMS_Repl.dbo.TD_move as TD with (nolock, index (ind1))
				|inner join(SELECT distinct  TD.id_tov
				|FROM  SMS_Repl.dbo.TD_move as TD with (nolock, index (ind1))
 				|WHERE TD.Operation_type =400 and TD.opendate>="+ВнешниеДанные.ФорматПоля(ДатаРаспределения.ДатаНачала) +" and TD.opendate<="+ВнешниеДанные.ФорматПоля(КонецДня(ДатаРаспределения.ДатаОкончания)) +  "
				|	and td.quantity>0 and CAST(ISNULL(TD.Confirm_reason, 0) as integer) <> 8 and TD.Upakovka_Opened=2
				|) as Tov on Tov.id_tov=Td.id_tov
				| WHERE TD.Operation_type =400 and TD.opendate>="+ВнешниеДанные.ФорматПоля(ДатаРаспределения.ДатаНачала) +" and TD.opendate<="+ВнешниеДанные.ФорматПоля(КонецДня(ДатаРаспределения.ДатаОкончания)) +  "
				|	and td.quantity>0 and CAST(ISNULL(TD.Confirm_reason, 0) as integer) <> 8"+СтрМаг;	
	//АК БЕЛН 05.09.2016--
	//rs.MoveFirst();
	//Результат = ВнешниеДанные.ПреобразоватьРезультатВТаблицуЗначений(rs);
	
	ДокЗакрыт = Ложь;
	
	//КодыПодтверждений = ВернутьТаблицуКодовПодтверждений();
	//
	//ЗапросПричинаСписания = Новый Запрос();
	//ЗапросПричинаСписания.Текст = "ВЫБРАТЬ
	//							  |	ПричиныСписания.Ссылка,
	//							  |	ПричиныСписания.ИД
	//							  |ИЗ
	//							  |	Справочник.ПричиныСписания КАК ПричиныСписания";
	//							  
	//ТабПричиныСписания = ЗапросПричинаСписания.Выполнить().Выгрузить();
	//
	ИнвентаризацияРаспечатана = Ложь;
	
	rs = ADOСоединение.Execute(ТекстЗапросаSQL);
	Попытка
		rs.MoveFirst();
		Пока НЕ rs.Eof() Цикл
			НовСтр = Отчет.Товары.Добавить();
			НовСтр.ИдТовара = rs.Fields("id_tov").Value;
			НовСтр.ИдПроизводитель = rs.Fields("id_kontr").Value;
			НовСтр.ДатаПроизводства = ?(rs.Fields("Date_proizv").Value < '2000-01-01', '00010101', rs.Fields("Date_proizv").Value);
			НовСтр.Количество = rs.Fields("Quantity").Value;
			НовСтр.Сумма = rs.Fields("Basesum").Value;
			НовСтр.Цена = ?(НовСтр.Количество = 0, 0, НовСтр.Сумма / НовСтр.Количество);
			//АК БЕЛН 05.09.2016++
			Если rs.Fields("Upakovka_Opened").Value=1 Тогда
				НовСтр.ВскрытаУпаковка = Перечисления.ВскрытаУпаковка.Да;
			ИначеЕсли rs.Fields("Upakovka_Opened").Value=2 Тогда
				НовСтр.ВскрытаУпаковка = Перечисления.ВскрытаУпаковка.Нет;
			КонецЕсли; 
			//АК БЕЛН 05.09.2016--
			Если Не ЗначениеЗаполнено(НовСтр.Продавец) Тогда
				НовСтр.Продавец = Справочники.ПерсоналККМ.НайтиПоКоду(Прав("0000000000" + Формат(rs.Fields("CashierID").Value, "ЧН=; ЧГ=0"), 10));
			КонецЕсли;	
			
			//Если Выборка.closedate <> Дата("19000101") Тогда
			//	ДокЗакрыт = Истина;
			//КонецЕсли;
			//Если НЕ ЗначениеЗаполнено(ГруппаНоменклатурыДляИнвентаризации)
			//	И ЗначениеЗаполнено(rs.Fields("id_vikl").Value) Тогда
			//	ГруппаНоменклатурыДляИнвентаризации = Справочники.МестаВыкладки.НайтиПоРеквизиту("ИД", rs.Fields("id_vikl").Value);
			//КонецЕсли;
			ЭтоОбязательнаяИнвентаризация = (rs.Fields("id_vikl").Value = 99999);
			ДокЗакрыт = rs.Fields("operation_type").Value > 0;
			//Объект.ВремяДоставки = rs.Fields("time_delivery").Value;
			
			ИнвентаризацияРаспечатана = Макс(ИнвентаризацияРаспечатана, rs.Fields("Quantity_inv").Value <> null);
			//Объект.КодОперации = rs.Fields("operation_type").Value * ?(ДокЗакрыт, 1, -1);
			//Объект.Комментарий = rs.Fields("Descr").Value;
			ПричинаСписанияКод = rs.Fields("id_reason").Value;
			
			//Объект.ТочкаПолучатель = rs.Fields("Corr_id_tt").Value;
			
			//НайдСтр = КодыПодтверждений.Найти(rs.Fields("Confirm_reason").Value, "code_operation");
			//
			//Если НЕ НайдСтр = Неопределено Тогда
			//	НовСтр.ПричинаПодтверждения = НайдСтр.Наименование;
			//КонецЕсли;
			
			НовСтр.Подтвержден = rs.Fields("Confirm_type").Value;
			НовСтр.ДатаПодтверждения = rs.Fields("Confirm_date").Value;
			НовСтр.ДатаСоздания = НачалоДня(rs.Fields("opendate").Value);
			//Если ЗначениеЗаполнено(rs.Fields("id_reason").Value) Тогда
			//	СтрПричинаСписания = ТабПричиныСписания.Найти(rs.Fields("id_reason").Value, "ИД");
			//	Если СтрПричинаСписания <> Неопределено Тогда
			//		НовСтр.ПричинаСписания = СтрПричинаСписания.Ссылка;
			//		//Объект.ПричинаСписания = НовСтр.ПричинаСписания;
			//	КонецЕсли;	
			//КонецЕсли;	
			НовСтр.УидСтроки = rs.Fields("tduid").Value;
			НовСтр.КомментарийКРаспределению = ?(СокрЛП(rs.Fields("Komment_raspr").Value)="",rs.Fields("Descr").Value,СокрЛП(rs.Fields("Komment_raspr").Value));
			НовСтр.Получатель=Справочники.СтруктурныеЕдиницы.НайтиПоРеквизиту("НомерТочки",rs.Fields("ShopNo_rep").Value);
			rs.MoveNext();
		КонецЦикла;
		
	Исключение
	КонецПопытки;
	
	ADOСоединение.Close();
	ЗаполнитьНоменклатуруВТЧСервер();
	
	СписокДР=Новый СписокЗначений; 
	Для каждого Эл Из Отчет.Товары Цикл
		Если СписокДР.НайтиПоЗначению(Началодня(Эл.ДатаСоздания))=Неопределено Тогда
			СписокДР.Добавить(Началодня(Эл.ДатаСоздания));
		КонецЕсли; 
	КонецЦикла;
	СписокМаг=Новый СписокЗначений; 
	Для каждого Эл Из Отчет.Товары Цикл
		Если СписокМаг.НайтиПоЗначению(Эл.Получатель)=Неопределено и ЗначениеЗаполнено(Эл.Получатель) Тогда
			СписокМаг.Добавить(Эл.Получатель);
		КонецЕсли; 
	КонецЦикла;
	ТЗОперации=Отчет.Товары.Выгрузить(,"Номенклатура,Характеристика,ДатаПроизводства,ДатаСоздания,Получатель,Количество,ВскрытаУпаковка,Продавец");
	Запрос = Новый Запрос();
	Запрос.УстановитьПараметр("Дата", СписокДР);
	Запрос.УстановитьПараметр("Получатель", СписокМаг);
	Запрос.УстановитьПараметр("ТЗОперации", ТЗОперации);
	Запрос.Текст = "ВЫБРАТЬ
	               |	ТЗОперации.Номенклатура КАК Номенклатура,
	               |	ТЗОперации.Характеристика КАК Характеристика,
	               |	ТЗОперации.ДатаПроизводства КАК ДатаПроизводства,
	               |	ТЗОперации.ДатаСоздания КАК ДатаСоздания,
	               |	ТЗОперации.Получатель КАК Получатель,
	               |	ТЗОперации.Количество,
	               |	ТЗОперации.Продавец,
	               |	ТЗОперации.ВскрытаУпаковка
	               |ПОМЕСТИТЬ вт
	               |ИЗ
	               |	&ТЗОперации КАК ТЗОперации
	               |;
	               |
	               |////////////////////////////////////////////////////////////////////////////////
	               |ВЫБРАТЬ
	               |	РасходныйОрдерСкладТовары.Номенклатура КАК Номенклатура,
	               |	РасходныйОрдерСкладТовары.Характеристика КАК Характеристика,
	               |	РасходныйОрдерСкладТовары.ДатаПроизводства КАК ДатаПроизводства,
	               |	РасходныйОрдерСкладТовары.Ссылка.ДатаРаспределения КАК ДатаРаспределения,
	               |	РасходныйОрдерСкладТовары.Ссылка.Получатель КАК Получатель,
	               |	СУММА(РасходныйОрдерСкладТовары.Количество) КАК ОтправилСклад
	               |ПОМЕСТИТЬ втРасходники
	               |ИЗ
	               |	Документ.РасходныйОрдерСклад.Товары КАК РасходныйОрдерСкладТовары
	               |ГДЕ
	               |	НАЧАЛОПЕРИОДА(РасходныйОрдерСкладТовары.Ссылка.ДатаРаспределения, ДЕНЬ) В (&Дата)
	               |	И РасходныйОрдерСкладТовары.Ссылка.Проведен = ИСТИНА
	               |	И РасходныйОрдерСкладТовары.Ссылка.Получатель В(&Получатель)
	               |	И РасходныйОрдерСкладТовары.Ссылка.ВидОперации = ЗНАЧЕНИЕ(Перечисление.ВидыОперацийРасходСкладскойУчет.ОтгрузкаВТорговуюТочку)
	               |
	               |СГРУППИРОВАТЬ ПО
	               |	РасходныйОрдерСкладТовары.Номенклатура,
	               |	РасходныйОрдерСкладТовары.Количество,
	               |	РасходныйОрдерСкладТовары.Характеристика,
	               |	РасходныйОрдерСкладТовары.ДатаПроизводства,
	               |	РасходныйОрдерСкладТовары.Ссылка.ДатаРаспределения,
	               |	РасходныйОрдерСкладТовары.Ссылка.Получатель
	               |;
	               |
	               |////////////////////////////////////////////////////////////////////////////////
	               |ВЫБРАТЬ
	               |	вт.Номенклатура КАК Номенклатура,
	               |	вт.Характеристика,
	               |	вт.ДатаПроизводства,
	               |	вт.ДатаСоздания КАК ДатаСоздания,
	               |	вт.Получатель КАК Получатель,
	               |	вт.Количество КАК Количество,
	               |	вт.ВскрытаУпаковка,
	               |	вт.Продавец,
	               |	ЕСТЬNULL(РасходныйОрдерСкладТовары.ОтправилСклад, 0) КАК ОтправилСклад
	               |ИЗ
	               |	вт КАК вт
	               |		ЛЕВОЕ СОЕДИНЕНИЕ втРасходники КАК РасходныйОрдерСкладТовары
	               |		ПО вт.Характеристика = РасходныйОрдерСкладТовары.Характеристика
	               |			И вт.Получатель = РасходныйОрдерСкладТовары.Получатель
	               |			И вт.ДатаПроизводства = РасходныйОрдерСкладТовары.ДатаПроизводства
	               |			И вт.ДатаСоздания = РасходныйОрдерСкладТовары.ДатаРаспределения
				   //|ГДЕ
				   //|	вт.Количество < 0.95 * ЕСТЬNULL(РасходныйОрдерСкладТовары.ОтправилСклад, 0)
				   //|	И вт.Количество >= 0.5 * ЕСТЬNULL(РасходныйОрдерСкладТовары.ОтправилСклад, 0)
	               |
	               |УПОРЯДОЧИТЬ ПО
	               |	ДатаСоздания,
	               |	Получатель,
	               |	Номенклатура";
					   
		Выборка = Запрос.Выполнить().Выбрать();
		//Пока Выборка.Следующий() Цикл
		//	СтрокиВТоварах = Отчет.Товары.НайтиСтроки(Новый Структура("Номенклатура, Характеристика, ДатаПроизводства, Получатель", Выборка.Номенклатура, Выборка.Характеристика, Выборка.ДатаПроизводства, Выборка.Получатель));
		//	Для Каждого СтрокаВТоварах Из СтрокиВТоварах Цикл
		//		Если НачалоДня(СтрокаВТоварах.ДатаСоздания)= Выборка.ДатаРаспределения Тогда
		//			СтрокаВТоварах.ОтправилСклад = Выборка.Количество;
		//			СтрокаВТоварах.РазницаПоставки = СтрокаВТоварах.Количество - Выборка.Количество;
		//		КонецЕсли; 
		//	КонецЦикла;
		//КонецЦикла;
		
		Об=РеквизитФормыВЗначение("Отчет");
	    Макет=Об.ПолучитьМакет("Макет");
		Обл=Макет.ПолучитьОбласть("Шапка");
		Результат.Вывести(Обл);
		Обл=Макет.ПолучитьОбласть("Строка");
		//Для каждого Стр Из Отчет.Товары Цикл
		//	Если Стр.Количество<0.95*Стр.ОтправилСклад Тогда
		//		Обл.Параметры.Заполнить(Стр);
		//		Результат.Вывести(Обл);
		//	КонецЕсли; 
		//КонецЦикла; 
		Пока Выборка.Следующий() Цикл
			Обл.Параметры.Заполнить(Выборка);
			Обл.Параметры.РазницаПоставки= -Выборка.ОтправилСклад + Выборка.Количество;
			Результат.Вывести(Обл);
		КонецЦикла;
		Отчет.Товары.Очистить();
		//Сообщить(ТекущаяДата());
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьНоменклатуруВТЧСервер()
	
	СписокИд = Отчет.Товары.Выгрузить().ВыгрузитьКолонку("ИдТовара");
	
	Запрос = Новый Запрос;
	Запрос.Текст = "ВЫБРАТЬ
	               |	Номенклатура.Ссылка,
	               |	Номенклатура.id_tov КАК ИД,
	               |	Номенклатура.Наименование
	               |ИЗ
	               |	Справочник.Номенклатура КАК Номенклатура
	               |ГДЕ
	               |	Номенклатура.id_tov В(&СписокИд)";
				   
	Запрос.УстановитьПараметр("СписокИд", СписокИд);
	
	ТзНом = Запрос.Выполнить().Выгрузить();
	
	Для Каждого Стр Из Отчет.Товары Цикл
		
		НайдСтр = ТзНом.Найти(Стр.ИдТовара, "Ид");
		
		Если Не НайдСтр = Неопределено Тогда
			Стр.Номенклатура = НайдСтр.Ссылка;
			Стр.Наименование = НайдСтр.Наименование;
		КонецЕсли;
		
	КонецЦикла;
	
	Запрос.УстановитьПараметр("Номенклатура", ТзНом.ВыгрузитьКолонку("Ссылка"));
	Запрос.Текст = "ВЫБРАТЬ
	               |	ЗначенияСвойствОбъектов.Объект КАК Характеристика,
	               |	ВЫРАЗИТЬ(ЗначенияСвойствОбъектов.Объект КАК Справочник.ХарактеристикиНоменклатуры).Владелец КАК Номенклатура,
	               |	ВЫРАЗИТЬ(ЗначенияСвойствОбъектов.Значение КАК Справочник.Контрагенты).ИД КАК ИДПроизв
	               |ИЗ
	               |	РегистрСведений.ЗначенияСвойствОбъектов КАК ЗначенияСвойствОбъектов
	               |ГДЕ
	               |	ЗначенияСвойствОбъектов.Свойство = ЗНАЧЕНИЕ(ПланВидовХарактеристик.СвойстваОбъектов.Производитель)
	               |	И ВЫРАЗИТЬ(ЗначенияСвойствОбъектов.Объект КАК Справочник.ХарактеристикиНоменклатуры).Владелец В (&Номенклатура)";
				   
	ТзХар = Запрос.Выполнить().Выгрузить();
	
	Для Каждого Стр Из Отчет.Товары Цикл
		
		НайдСтр = ТзХар.НайтиСтроки(Новый Структура("Номенклатура, ИДПроизв", Стр.Номенклатура, Стр.ИдПроизводитель));
		
		Если НайдСтр.Количество() > 0 Тогда
			Стр.Характеристика = НайдСтр[0].Характеристика;
		КонецЕсли;
		
	КонецЦикла;
	
	Отчет.Товары.Сортировать("ДатаСоздания,Получатель,Наименование");
	
КонецПроцедуры

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	ДатаРаспределения.Вариант=ВариантСтандартногоПериода.Сегодня;
КонецПроцедуры


 
