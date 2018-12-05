﻿
Функция ПолучитьЕжедневныеБонусы(ДатаНач, ДатаКон) Экспорт
	
	УстановитьПривилегированныйРежим(Истина);
	
	ADOСоединение = ВнешниеДанные.ПолучитьADOСоединение();
	
	Запрос = "
		|SELECT SUM(BonusValue) Bonus    
  		|FROM [Loyalty].[dbo].[Bonus_date_shopno]
  		|WHERE [date] >= " + ВнешниеДанные.ФорматПоля(ДатаНач, Истина) + "and [date] <= " + ВнешниеДанные.ФорматПоля(ДатаКон, Истина);
		
	rs = ADOСоединение.Execute(Запрос);

	СуммаКРаспределению = 0;
	
	Попытка
		Если НЕ rs.EOF() Тогда
			СуммаКРаспределению = rs.Fields("Bonus").Value;
		КонецЕсли;
	Исключение
	КонецПопытки;
	
	ADOСоединение.Close();
	
	Запрос = Новый Запрос();
	Запрос.УстановитьПараметр("ДатаНач", НачалоДня(ДатаНач));
	Запрос.УстановитьПараметр("ДатаКон", КонецДня(ДатаКон));
	Запрос.Текст = "ВЫБРАТЬ
	               |	ЛистУчета.ТорговаяТочка,
	               |	СУММА(ЛистУчета.СуммаДокумента) КАК СуммаДокумента,
	               |	ЛистУчета.ТорговаяТочка.НомерТочки КАК ТорговаяТочкаНомерТочки
	               |ИЗ
	               |	Документ.ЛистУчета КАК ЛистУчета
	               |ГДЕ
	               |	ЛистУчета.Дата МЕЖДУ &ДатаНач И &ДатаКон
	               |	И ЛистУчета.Проведен = ИСТИНА
	               |
	               |СГРУППИРОВАТЬ ПО
	               |	ЛистУчета.ТорговаяТочка
	               |
	               |УПОРЯДОЧИТЬ ПО
	               |	ТорговаяТочкаНомерТочки";
				   
	ТабСумм = Запрос.Выполнить().Выгрузить();			   
	
	РаспределениеРег = ОбщегоНазначения.РаспределитьПропорционально(СуммаКРаспределению,ТабСумм.выгрузитьКолонку("СуммаДокумента"));
	ТабСумм.Колонки.Добавить("Сумма");
	Если Не РаспределениеРег = Неопределено Тогда
		ТабСумм.ЗагрузитьКолонку(РаспределениеРег,"Сумма");
	КонецЕсли;
		
	Возврат ТабСумм;
	
КонецФункции

//+++ AK BARA   ИП-00015552.01
Функция ПолучитьДаныеПоСертификатам(ДатаОбработки,НачисленияПоСертификатам,ДобавилиСертификаты,ВыдалиСертификаты)Экспорт 
	 
	 РезультатСертификатов = Новый Структура;
	 РезультатСертификатов.Вставить("НеИспользованныеЗаКвартал",0);
	 РезультатСертификатов.Вставить("ДобавилиКупонов",0);
	 РезультатСертификатов.Вставить("СписалиКупонов",0);	 
 		
	УстановитьПривилегированныйРежим(Истина);
		
	ADOСоединение = ВнешниеДанные.ПолучитьADOСоединение();
	
	Запрос = "SELECT  [CashID] as CashID
	|      ,max([ShopNo]) as ShopNo
	|  FROM [SMS_REPL].[dbo].[CashIP]
	|  group by [CashID]";
	
	rs = ADOСоединение.Execute(Запрос);	
	НомераМагазинов = Новый ТаблицаЗначений;
	
	НомераМагазинов = ВнешниеДанные.ПреобразоватьРезультатВТаблицуЗначений(rs);
	ADOСоединение.Close();
	////
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	dbo_CashIP.CashID,
	|	dbo_CashIP.ShopNo
	|ПОМЕСТИТЬ ВТ_ЧекНомер
	|ИЗ
	|	&НомераМагазинов КАК dbo_CashIP
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	МАКСИМУМ(СтруктурныеЕдиницы.Ссылка) КАК Ссылка,
	|	ВТ_ЧекНомер.CashID КАК CashID
	|ИЗ
	|	ВТ_ЧекНомер КАК ВТ_ЧекНомер
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ Справочник.СтруктурныеЕдиницы КАК СтруктурныеЕдиницы
	|		ПО ВТ_ЧекНомер.ShopNo = СтруктурныеЕдиницы.НомерТочки
	|ГДЕ
	|	СтруктурныеЕдиницы.НомерТочки > 0
	|
	|СГРУППИРОВАТЬ ПО
	|	ВТ_ЧекНомер.CashID";
	
	Запрос.УстановитьПараметр("НомераМагазинов", НомераМагазинов); 
	СтруктурныеЕдиницы = Запрос.Выполнить().Выгрузить();
	
	///////////////////
	ADOСоединение = ВнешниеДанные.ПолучитьADOСоединение();

	ЗапросТекст = 
	"SELECT TM.Sum_coupon as СуммаСертификата,
	|TM.date_st as ДатаНачалаДействия,
	|TM.date_fi as ДатаОкончанияДействия,
	|CM.time_add as ДатаДобавления,
	|CM.number_cert as number_cert,
	|TM.Sum_coupon as СуммаСкидки,
	|CM.kolvo as  КличествоКупонов,
	|TM.name_coupon as  Наименование,
	|TM.id_type_coupon as  Инентификатор,	
	|CM.CashID as CashID
	|  FROM [Loyalty].[dbo].[Coupon_move] CM
	|  Inner join 
	|  [Loyalty].[dbo].[Types_coupon]TM
	|  on CM.id_type_coupon = TM.id_type_coupon
	|  Where isnull(CM.number_cert,0)<>0  and (CM.CashID <> 9991 or isnull(CM.CashID,0)=0)
	|  and TM.kind = 1
	|  and CM.time_add >= '%ДатаНачала' and CM.time_add <= '%ДатаКонца'
	|  order by CM.time_add desc";
	 
	ЗапросТекст = СтрЗаменить(ЗапросТекст,"%ДатаНачала",Формат(НачалоМесяца(ДатаОбработки),"ДФ=yyyyMMdd")+" 00:00:00");
	ЗапросТекст = СтрЗаменить(ЗапросТекст,"%ДатаКонца",Формат(КонецМесяца(ДатаОбработки),"ДФ=yyyyMMdd")+" 23:59:59");

	rs = ADOСоединение.Execute(ЗапросТекст);	
	ВремРез0 = Новый ТаблицаЗначений;	
	ВремРез0 = ВнешниеДанные.ПреобразоватьРезультатВТаблицуЗначений(rs);
	
	Для каждого Стр Из ВремРез0 Цикл
		Стр.Инентификатор = СтрЗаменить(Стр.Инентификатор,"{","");
		Стр.Инентификатор = СтрЗаменить(Стр.Инентификатор,"}","");
	КонецЦикла; 
	
	ЗапросТекст = 
	"SELECT TM.Sum_coupon as СуммаСкидки,
	| TM.Sum_coupon as СуммаСертификата,
	|CM.number_cert as НомерСертификата,
	|CM.kolvo as  КличествоКупонов
	|
  	|FROM [Loyalty].[dbo].[Coupon_move] CM
	|  Inner join 
	|  [Loyalty].[dbo].[Types_coupon]TM
	|  on CM.id_type_coupon = TM.id_type_coupon
	|  Where isnull(CM.number_cert,0)<>0 and (CM.CashID <> 9991 or isnull(CM.CashID,0)=0)
	|  and TM.kind = 1
	| and TM.date_fi >= '%ДатаНачала' and TM.date_fi <= '%ДатаКонца'";
	
	ЗапросТекст = СтрЗаменить(ЗапросТекст,"%ДатаНачала",Формат(НачалоМесяца(ДатаОбработки),"ДФ=yyyyMMdd"));
	ЗапросТекст = СтрЗаменить(ЗапросТекст,"%ДатаКонца",Формат(КонецМесяца(ДатаОбработки),"ДФ=yyyyMMdd"));
	
	rs1 = ADOСоединение.Execute(ЗапросТекст);	
	ВремРез1 = Новый ТаблицаЗначений;	
	ВремРез1 = ВнешниеДанные.ПреобразоватьРезультатВТаблицуЗначений(rs1);
	ADOСоединение.Close();
	ВремРез1 = Новый ТаблицаЗначений;
	
	Если ВремРез1.Количество() = 0 Тогда
		КЧ = Новый КвалификаторыЧисла(12,2);
		
		Массив = Новый Массив;
		Массив.Добавить(Тип("Число"));
		ОписаниеТиповЧ = Новый ОписаниеТипов(Массив, , ,КЧ);
		
		ВремРез1.Колонки.Добавить("СуммаСкидки",ОписаниеТиповЧ);
		ВремРез1.Колонки.Добавить("СуммаСертификата",ОписаниеТиповЧ);
		ВремРез1.Колонки.Добавить("НомерСертификата",ОписаниеТиповЧ);
		ВремРез1.Колонки.Добавить("КличествоКупонов",ОписаниеТиповЧ);		
	КонецЕсли;
	
	МВТ = НОВый МенеджерВременныхТаблиц;
	Запрос = Новый Запрос;
	Запрос.МенеджерВременныхТаблиц = МВТ;
	Запрос.УстановитьПараметр("ВремРез0",ВремРез0);
	Запрос.УстановитьПараметр("ВремРез1",ВремРез1);
	Запрос.Текст = 
		"ВЫБРАТЬ
		|	Рез0.СуммаСертификата КАК СуммаСертификата,
		|	Рез0.ДатаНачалаДействия,
		|	Рез0.ДатаОкончанияДействия,
		|	Рез0.ДатаДобавления КАК ДатаДобавления,
		|	Рез0.number_cert КАК number_cert,
		|	Рез0.СуммаСкидки КАК СуммаСкидки,
		|	Рез0.КличествоКупонов КАК КличествоКупонов,
		|	ВЫРАЗИТЬ(Рез0.Наименование КАК СТРОКА(20)) КАК Наименование,
		|	ВЫРАЗИТЬ(Рез0.Инентификатор КАК СТРОКА(36)) КАК Инентификатор,
		|	Рез0.CashID
		|ПОМЕСТИТЬ Рез0
		|ИЗ
		|	&ВремРез0 КАК Рез0
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	Рез1.СуммаСкидки КАК СуммаСертификата,
		|	Рез1.НомерСертификата КАК number_cert,
		|	Рез1.СуммаСкидки КАК СуммаСкидки,
		|	Рез1.КличествоКупонов КАК КличествоКупонов
		|ПОМЕСТИТЬ Рез1
		|ИЗ
		|	&ВремРез1 КАК Рез1";
	
	РезультатЗапроса = Запрос.Выполнить();
	
	////////////////////////
	
	Запрос = Новый Запрос;
	Запрос.МенеджерВременныхТаблиц = МВТ;
	Запрос.Текст = 
		"ВЫБРАТЬ
		|	Рез0.СуммаСкидки КАК СуммаСертификата,
		|	Рез0.ДатаНачалаДействия,
		|	Рез0.ДатаОкончанияДействия,
		|	Рез0.ДатаДобавления КАК ДатаДобавления,
		|	Рез0.number_cert КАК НомерСертификата,
		|	НАЧАЛОПЕРИОДА(Рез0.ДатаДобавления, МЕСЯЦ) КАК Период,
		|	Рез0.СуммаСкидки КАК СуммаСкидки,
		|	Рез0.КличествоКупонов КАК КличествоКупонов,
		|	Рез0.CashID
		|ИЗ
		|	Рез0 КАК Рез0
		|УПОРЯДОЧИТЬ ПО
		|	ДатаДобавления УБЫВ
		|ИТОГИ
		|	СУММА(СуммаСкидки)
		|ПО
		|	КличествоКупонов
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	Рез1.СуммаСкидки КАК СуммаСертификата,
		|	Рез1.number_cert КАК НомерСертификата,
		|	СУММА(Рез1.СуммаСкидки) КАК СуммаСкидки,
		|	СУММА(Рез1.КличествоКупонов) КАК КличествоКупонов
		|ИЗ
		|	Рез1 КАК Рез1
		|СГРУППИРОВАТЬ ПО
		|	Рез1.number_cert,
		|	Рез1.СуммаСкидки
		|
		|ИМЕЮЩИЕ
		|	СУММА(Рез1.КличествоКупонов) = 1
		|ИТОГИ
		|	СУММА(СуммаСкидки)
		|ПО
		|	ОБЩИЕ
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	Рез0.ДатаНачалаДействия,
		|	Рез0.ДатаОкончанияДействия,
		|	НАЧАЛОПЕРИОДА(Рез0.ДатаДобавления, МЕСЯЦ) КАК Период,
		|	СУММА(Рез0.СуммаСкидки) КАК СуммаСкидки,
		|	СУММА(Рез0.КличествоКупонов) КАК КличествоКупонов,
		|	Рез0.Наименование,
		|	Рез0.Инентификатор,
		|	МАКСИМУМ(Рез0.СуммаСкидки) КАК СертификатНаСумму
		|ИЗ
		|	Рез0 Как Рез0
		|ГДЕ
		|	 Рез0.КличествоКупонов = 1
		|
		|СГРУППИРОВАТЬ ПО
		|	Рез0.ДатаНачалаДействия,
		|	НАЧАЛОПЕРИОДА(Рез0.ДатаДобавления, МЕСЯЦ),
		|	Рез0.ДатаОкончанияДействия,
		|	Рез0.Инентификатор,
		|	Рез0.Наименование
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	АК_Сертификаты.Сертификат КАК Сертификат,
		|	СУММА(ВЫБОР
		|			КОГДА АК_Сертификаты.ВидОперации = ЗНАЧЕНИЕ(Перечисление.АК_ВидыОперацийСертификат.Выдача)
		|				ТОГДА АК_Сертификаты.Количество
		|			КОГДА АК_Сертификаты.ВидОперации = ЗНАЧЕНИЕ(Перечисление.АК_ВидыОперацийСертификат.Возврат)
		|				ТОГДА АК_Сертификаты.Количество * -1
		|			ИНАЧЕ 0
		|		КОНЕЦ) КАК Количество,
		|	СУММА(АК_Сертификаты.Сертификат.Сумма * ВЫБОР
		|			КОГДА АК_Сертификаты.ВидОперации = ЗНАЧЕНИЕ(Перечисление.АК_ВидыОперацийСертификат.Выдача)
		|				ТОГДА АК_Сертификаты.Количество
		|			КОГДА АК_Сертификаты.ВидОперации = ЗНАЧЕНИЕ(Перечисление.АК_ВидыОперацийСертификат.Возврат)
		|				ТОГДА АК_Сертификаты.Количество * -1
		|			ИНАЧЕ 0
		|		КОНЕЦ) КАК Сумма
		|ИЗ
		|	РегистрСведений.АК_Сертификаты КАК АК_Сертификаты
		|ГДЕ
		|	АК_Сертификаты.ДатаЗаписи МЕЖДУ &ДатаНачала И &ДатаКонца
		|	И (АК_Сертификаты.ВидОперации = ЗНАЧЕНИЕ(Перечисление.АК_ВидыОперацийСертификат.Выдача)
		|			ИЛИ АК_Сертификаты.ВидОперации = ЗНАЧЕНИЕ(Перечисление.АК_ВидыОперацийСертификат.Возврат))
		|
		|СГРУППИРОВАТЬ ПО
		|	АК_Сертификаты.Сертификат";


	Запрос.УстановитьПараметр("ДатаКонца", КонецМесяца(ДатаОбработки));
	Запрос.УстановитьПараметр("ДатаНачала", НачалоМесяца(ДатаОбработки));
	//+++ AK BARA ИП-00015572.03 
	Если НачалоМесяца(ДатаОбработки) = Дата("20171201") Тогда 
		Запрос.УстановитьПараметр("ДатаНачала", НачалоМесяца(ДобавитьМесяц(ДатаОбработки,-2)));
	КонецЕсли;
	//---
	Запрос.УстановитьПараметр("Начало2017Года", Дата("20170101000000"));

	Результат = Запрос.ВыполнитьПакет();
	
	////
	ВыборкаВыдалиСерт = Результат[3].Выбрать();
	ВыдалиСертификаты.Очистить();
	
	Пока ВыборкаВыдалиСерт.Следующий() Цикл
		НовСтр = ВыдалиСертификаты.Добавить();
		НовСтр.Сертификат = ВыборкаВыдалиСерт.Сертификат;
		НовСтр.ВидОперации = ?(ВыборкаВыдалиСерт.Количество>0,Перечисления.АК_ВидыОперацийСертификат.Выдача,Перечисления.АК_ВидыОперацийСертификат.Возврат);//ВыборкаВыдалиСерт.ВидОперации;
		//НовСтр.СтруктурнаяЕдиница = ВыборкаВыдалиСерт.СтруктурнаяЕдиница;
		НовСтр.Сумма = ?(ВыборкаВыдалиСерт.Количество>0,ВыборкаВыдалиСерт.Сумма,ВыборкаВыдалиСерт.Сумма*-1);//ВыборкаВыдалиСерт.Сумма;
		НовСтр.Количество =  ?(ВыборкаВыдалиСерт.Количество>0,ВыборкаВыдалиСерт.Количество,ВыборкаВыдалиСерт.Количество*-1);
	КонецЦикла;
	/////////////

	
	////
	ВыборкаДобавилиСерт = Результат[2].Выбрать();
	ДобавилиСертификаты.Очистить();
	
	Пока ВыборкаДобавилиСерт.Следующий() Цикл
		АК_Сертификат = Справочники.АК_Сертификат.НайтиПоРеквизиту("ID",ВыборкаДобавилиСерт.Инентификатор);
		Если АК_Сертификат.Пустая() Тогда
			
			НовСерт = Справочники.АК_Сертификат.СоздатьЭлемент();
			НовСерт.Наименование = ВыборкаДобавилиСерт.Наименование;
			НовСерт.ДатаНачала = ВыборкаДобавилиСерт.ДатаНачалаДействия;
			НовСерт.ДатаОкончания = ВыборкаДобавилиСерт.ДатаОкончанияДействия;
			НовСерт.Сумма = ВыборкаДобавилиСерт.СертификатНаСумму;
			НовСерт.ID = ВыборкаДобавилиСерт.Инентификатор;
			НовСерт.Записать();
			АК_Сертификат = НовСерт.Ссылка;
			
		КонецЕсли;
		НовСтр = ДобавилиСертификаты.Добавить();
		НовСтр.Сертификат = АК_Сертификат;
		НовСтр.Сумма = ВыборкаДобавилиСерт.СуммаСкидки;
		НовСтр.Количество = ВыборкаДобавилиСерт.КличествоКупонов;
	КонецЦикла;
	/////////////
	ВыборкаКличествоКупонов = Результат[0].Выбрать(ОбходРезультатаЗапроса.ПоГруппировкам);
	НачисленияПоСертификатам.Очистить();
	
	Пока ВыборкаКличествоКупонов.Следующий() Цикл
		Если ВыборкаКличествоКупонов.КличествоКупонов = 1 Тогда
			ДобавилиКупонов = ВыборкаКличествоКупонов.СуммаСкидки;
		ИначеЕсли ВыборкаКличествоКупонов.КличествоКупонов = -1 Тогда
			СписалиКупонов = ВыборкаКличествоКупонов.СуммаСкидки;	
			
			ВыборкаДетали = ВыборкаКличествоКупонов.Выбрать();
			Пока ВыборкаДетали.Следующий() Цикл
				
				НовСтр = НачисленияПоСертификатам.Добавить();
				НовСтр.Сумма = ВыборкаДетали.СуммаСкидки;
				НовСтр.CashID = ВыборкаДетали.CashID;
				МагазинСтр = СтруктурныеЕдиницы.Найти(ВыборкаДетали.CashID,"CashID");
				Если МагазинСтр = Неопределено Тогда
					
					ADOСоединение = ВнешниеДанные.ПолучитьADOСоединение();
					ТекстЗапроса = 
					"select distinct Shopno from SMS_UNION..Checks as ch with(nolock)
					|where ch.CashID="+Формат(ВыборкаДетали.CashID,"ЧГ=")+" and convert(date,closedate)='"+Формат(ВыборкаДетали.ДатаДобавления,"ДФ=yyyyMMdd")+"'";
					rs = ADOСоединение.Execute(ТекстЗапроса);
					Попытка
						rs.MoveFirst();
						ShopNO = rs.Fields("ShopNO").Value;  
						НовСтрТорговаяТочка = Справочники.СтруктурныеЕдиницы.НайтиПоРеквизиту("НомерТочки",ShopNO);
						
						Если ЗначениеЗаполнено(ShopNO) и ЗначениеЗаполнено(НовСтрТорговаяТочка) Тогда 
							ADOСоединение.Close();	
							НовСтр.ТорговаяТочка  = НовСтрТорговаяТочка;
							Продолжить;	
						иначе
							
						КонецЕсли;
						//Пока НЕ rs.EOF() Цикл
						//		rs.MoveNext();
						//КонецЦикла;
					Исключение
					КонецПопытки;	
					ADOСоединение.Close();	
				КонецЕсли;
				
				Если МагазинСтр <> Неопределено Тогда 
					НовСтр.ТорговаяТочка = МагазинСтр.Ссылка;
				Иначе
					ShopNo = "";
					НомераМагазиновСтр = НомераМагазинов.Найти(ВыборкаДетали.CashID,"CashID");
					Если НомераМагазиновСтр <> Неопределено Тогда 
						ShopNo = НомераМагазиновСтр.ShopNo;
					КонецЕсли;
					Сообщить("Не найдена структурная единица по CashID="+ВыборкаДетали.CashID+", номер магазина "+ShopNo+".");
				КонецЕсли;
				
			КонецЦикла;
		КонецЕсли;
	КонецЦикла;

		
	ВыборкаОбщийИтог = Результат[1].Выбрать(ОбходРезультатаЗапроса.ПоГруппировкам);

	ВыборкаОбщийИтог.Следующий();		// Общий итог

	НеИспользованныеЗаКвартал = ВыборкаОбщийИтог.СуммаСкидки; 
 		
		
	РезультатСертификатов.Вставить("НеИспользованныеЗаКвартал",НеИспользованныеЗаКвартал);
	РезультатСертификатов.Вставить("ДобавилиКупонов",ДобавилиКупонов);
	РезультатСертификатов.Вставить("СписалиКупонов",СписалиКупонов);
		
	Возврат РезультатСертификатов;//ТабДанные;
	
КонецФункции // ()
//--- AK

 //+++ AK BARA   22.03.2017 ИП-00015329.000.00000001
 Функция ПолучитьДаныеПоСертификатам_ВнещниеИсточники(ДатаОбработки,НачисленияПоСертификатам,ДобавилиСертификаты,ВыдалиСертификаты)Экспорт 
	 
	 РезультатСертификатов = Новый Структура;
	 РезультатСертификатов.Вставить("НеИспользованныеЗаКвартал",0);
	 РезультатСертификатов.Вставить("ДобавилиКупонов",0);
	 РезультатСертификатов.Вставить("СписалиКупонов",0);	 
	 
	 //Если КонецКвартала(ДатаОбработки) <> КонецМесяца(ДатаОбработки) Тогда
	 //	
	 //	Возврат РезультатСертификатов;
	 //КонецЕсли;
 		
	УстановитьПривилегированныйРежим(Истина);
	
	
		////
	//СтрСоединенияДанныеSMS_Repl = ОбменСAccess.ПолучитьСтрокуСоединения("SMS_Repl");
	//
	//пСоед = Новый ПараметрыСоединенияВнешнегоИсточникаДанных;
	//пСоед.СтрокаСоединения= СтрСоединенияДанныеSMS_Repl;
	//ВнешниеИсточникиДанных.SMS_Repl.УстановитьОбщиеПараметрыСоединения(пСоед);
	ВнешниеИсточникиДанных.SMS_Repl.УстановитьСоединение();
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	dbo_CashIP.CashID,
	|	МАКСИМУМ(dbo_CashIP.ShopNo) КАК ShopNo
	|ИЗ
	|	ВнешнийИсточникДанных.SMS_Repl.Таблица.dbo_CashIP КАК dbo_CashIP
	|
	|СГРУППИРОВАТЬ ПО
	|	dbo_CashIP.CashID";
	
	НомераМагазинов = Запрос.Выполнить().Выгрузить();
	
	ВнешниеИсточникиДанных.SMS_Repl.РазорватьСоединение();
	////
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	dbo_CashIP.CashID,
	|	dbo_CashIP.ShopNo
	|ПОМЕСТИТЬ ВТ_ЧекНомер
	|ИЗ
	|	&НомераМагазинов КАК dbo_CashIP
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	МАКСИМУМ(СтруктурныеЕдиницы.Ссылка) КАК Ссылка,
	|	ВТ_ЧекНомер.CashID КАК CashID
	|ИЗ
	|	ВТ_ЧекНомер КАК ВТ_ЧекНомер
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ Справочник.СтруктурныеЕдиницы КАК СтруктурныеЕдиницы
	|		ПО ВТ_ЧекНомер.ShopNo = СтруктурныеЕдиницы.НомерТочки
	|ГДЕ
	|	СтруктурныеЕдиницы.НомерТочки > 0
	|
	|СГРУППИРОВАТЬ ПО
	|	ВТ_ЧекНомер.CashID";
	
	Запрос.УстановитьПараметр("НомераМагазинов", НомераМагазинов); 
	СтруктурныеЕдиницы = Запрос.Выполнить().Выгрузить();
	
	
	//СтрСоединенияДанныеТовародвижение = ОбменСAccess.ПолучитьСтрокуСоединения("loyalty");
	//
	//пСоед = Новый ПараметрыСоединенияВнешнегоИсточникаДанных;
	//пСоед.СтрокаСоединения= СтрСоединенияДанныеТовародвижение;
	//ВнешниеИсточникиДанных.Loyality.УстановитьОбщиеПараметрыСоединения(пСоед);
	ВнешниеИсточникиДанных.Loyality.УстановитьСоединение();

	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ
		|	ТипыКупонов.СуммаСкидки КАК СуммаСертификата,
		|	ТипыКупонов.ДатаНачалаДействия,
		|	ТипыКупонов.ДатаОкончанияДействия,
		|	ВыданныеКупоны.ДатаДобавления КАК ДатаДобавления,
		|	ВыданныеКупоны.number_cert КАК НомерСертификата,
		|	НАЧАЛОПЕРИОДА(ВыданныеКупоны.ДатаДобавления, МЕСЯЦ) КАК Период,
		|	ТипыКупонов.СуммаСкидки КАК СуммаСкидки,
		|	ВыданныеКупоны.КличествоКупонов КАК КличествоКупонов,
		|	ВыданныеКупоны.CashID
		|ИЗ
		|	ВнешнийИсточникДанных.Loyality.Таблица.ВыданныеКупоны КАК ВыданныеКупоны
		|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ ВнешнийИсточникДанных.Loyality.Таблица.ТипыКупонов КАК ТипыКупонов
		|		ПО ВыданныеКупоны.ТипКупона = ТипыКупонов.Инентификатор
		|ГДЕ
		|	ЕСТЬNULL(ВыданныеКупоны.number_cert, 0) <> 0
		|	И ТипыКупонов.Kind = 1
		|	И ВыданныеКупоны.ДатаДобавления МЕЖДУ &ДатаНачала И &ДатаКонца
		|
		|УПОРЯДОЧИТЬ ПО
		|	ДатаДобавления УБЫВ
		|ИТОГИ
		|	СУММА(СуммаСкидки)
		|ПО
		|	КличествоКупонов
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	ТипыКупонов.СуммаСкидки КАК СуммаСертификата,
		|	ВыданныеКупоны.number_cert КАК НомерСертификата,
		|	СУММА(ТипыКупонов.СуммаСкидки) КАК СуммаСкидки,
		|	СУММА(ВыданныеКупоны.КличествоКупонов) КАК КличествоКупонов
		|ИЗ
		|	ВнешнийИсточникДанных.Loyality.Таблица.ВыданныеКупоны КАК ВыданныеКупоны
		|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ ВнешнийИсточникДанных.Loyality.Таблица.ТипыКупонов КАК ТипыКупонов
		|		ПО ВыданныеКупоны.ТипКупона = ТипыКупонов.Инентификатор
		|ГДЕ
		|	ЕСТЬNULL(ВыданныеКупоны.number_cert, 0) <> 0
		|	И ТипыКупонов.Kind = 1
		|	И ТипыКупонов.ДатаОкончанияДействия МЕЖДУ &ДатаНачала И &ДатаКонца
		|
		|СГРУППИРОВАТЬ ПО
		|	ВыданныеКупоны.number_cert,
		|	ТипыКупонов.СуммаСкидки
		|
		|ИМЕЮЩИЕ
		|	СУММА(ВыданныеКупоны.КличествоКупонов) = 1
		|ИТОГИ
		|	СУММА(СуммаСкидки)
		|ПО
		|	ОБЩИЕ
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	ТипыКупонов.ДатаНачалаДействия,
		|	ТипыКупонов.ДатаОкончанияДействия,
		|	НАЧАЛОПЕРИОДА(ВыданныеКупоны.ДатаДобавления, МЕСЯЦ) КАК Период,
		|	СУММА(ТипыКупонов.СуммаСкидки) КАК СуммаСкидки,
		|	СУММА(ВыданныеКупоны.КличествоКупонов) КАК КличествоКупонов,
		|	ТипыКупонов.Наименование,
		|	ТипыКупонов.Инентификатор,
		|	МАКСИМУМ(ТипыКупонов.СуммаСкидки) КАК СертификатНаСумму
		|ИЗ
		|	ВнешнийИсточникДанных.Loyality.Таблица.ВыданныеКупоны КАК ВыданныеКупоны
		|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ ВнешнийИсточникДанных.Loyality.Таблица.ТипыКупонов КАК ТипыКупонов
		|		ПО ВыданныеКупоны.ТипКупона = ТипыКупонов.Инентификатор
		|ГДЕ
		|	ЕСТЬNULL(ВыданныеКупоны.number_cert, 0) <> 0
		|	И ТипыКупонов.Kind = 1
		|	И ВыданныеКупоны.ДатаДобавления МЕЖДУ &ДатаНачала И &ДатаКонца
		|	И ВыданныеКупоны.КличествоКупонов = 1
		|
		|СГРУППИРОВАТЬ ПО
		|	ТипыКупонов.ДатаНачалаДействия,
		|	НАЧАЛОПЕРИОДА(ВыданныеКупоны.ДатаДобавления, МЕСЯЦ),
		|	ТипыКупонов.ДатаОкончанияДействия,
		|	ТипыКупонов.Инентификатор,
		|	ТипыКупонов.Наименование
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	АК_Сертификаты.Сертификат КАК Сертификат,
		|	СУММА(ВЫБОР
		|			КОГДА АК_Сертификаты.ВидОперации = ЗНАЧЕНИЕ(Перечисление.АК_ВидыОперацийСертификат.Выдача)
		|				ТОГДА АК_Сертификаты.Количество
		|			КОГДА АК_Сертификаты.ВидОперации = ЗНАЧЕНИЕ(Перечисление.АК_ВидыОперацийСертификат.Возврат)
		|				ТОГДА АК_Сертификаты.Количество * -1
		|			ИНАЧЕ 0
		|		КОНЕЦ) КАК Количество,
		|	СУММА(АК_Сертификаты.Сертификат.Сумма * ВЫБОР
		|			КОГДА АК_Сертификаты.ВидОперации = ЗНАЧЕНИЕ(Перечисление.АК_ВидыОперацийСертификат.Выдача)
		|				ТОГДА АК_Сертификаты.Количество
		|			КОГДА АК_Сертификаты.ВидОперации = ЗНАЧЕНИЕ(Перечисление.АК_ВидыОперацийСертификат.Возврат)
		|				ТОГДА АК_Сертификаты.Количество * -1
		|			ИНАЧЕ 0
		|		КОНЕЦ) КАК Сумма
		|ИЗ
		|	РегистрСведений.АК_Сертификаты КАК АК_Сертификаты
		|ГДЕ
		|	АК_Сертификаты.ДатаЗаписи МЕЖДУ &ДатаНачала И &ДатаКонца
		|	И (АК_Сертификаты.ВидОперации = ЗНАЧЕНИЕ(Перечисление.АК_ВидыОперацийСертификат.Выдача)
		|			ИЛИ АК_Сертификаты.ВидОперации = ЗНАЧЕНИЕ(Перечисление.АК_ВидыОперацийСертификат.Возврат))
		|
		|СГРУППИРОВАТЬ ПО
		|	АК_Сертификаты.Сертификат";


	Запрос.УстановитьПараметр("ДатаКонца", КонецМесяца(ДатаОбработки));
	Запрос.УстановитьПараметр("ДатаНачала", НачалоМесяца(ДатаОбработки));
	Запрос.УстановитьПараметр("Начало2017Года", Дата("20170101000000"));
	
	Результат = Запрос.ВыполнитьПакет();
    ВнешниеИсточникиДанных.Loyality.РазорватьСоединение();
	////
	//СтрСоединенияДанныеSMS_Repl = ОбменСAccess.ПолучитьСтрокуСоединения("SMS_Repl");
	//
	//пСоед = Новый ПараметрыСоединенияВнешнегоИсточникаДанных;
	//пСоед.СтрокаСоединения= СтрСоединенияДанныеSMS_Repl;
	//ВнешниеИсточникиДанных.SMS_Repl.УстановитьОбщиеПараметрыСоединения(пСоед);
	ВнешниеИсточникиДанных.SMS_Repl.УстановитьСоединение();
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	dbo_CashIP.CashID,
	|	МАКСИМУМ(dbo_CashIP.ShopNo) КАК ShopNo
	|ИЗ
	|	ВнешнийИсточникДанных.SMS_Repl.Таблица.dbo_CashIP КАК dbo_CashIP
	|
	|СГРУППИРОВАТЬ ПО
	|	dbo_CashIP.CashID";
	
	НомераМагазинов = Запрос.Выполнить().Выгрузить();
	
	ВнешниеИсточникиДанных.SMS_Repl.РазорватьСоединение();
	
		////
	ВыборкаВыдалиСерт = Результат[3].Выбрать();
	ВыдалиСертификаты.Очистить();
	
	Пока ВыборкаВыдалиСерт.Следующий() Цикл
		НовСтр = ВыдалиСертификаты.Добавить();
		НовСтр.Сертификат = ВыборкаВыдалиСерт.Сертификат;
		НовСтр.ВидОперации = ?(ВыборкаВыдалиСерт.Количество>0,Перечисления.АК_ВидыОперацийСертификат.Выдача,Перечисления.АК_ВидыОперацийСертификат.Возврат);//ВыборкаВыдалиСерт.ВидОперации;
		//НовСтр.СтруктурнаяЕдиница = ВыборкаВыдалиСерт.СтруктурнаяЕдиница;
		НовСтр.Сумма = ?(ВыборкаВыдалиСерт.Количество>0,ВыборкаВыдалиСерт.Сумма,ВыборкаВыдалиСерт.Сумма*-1);//ВыборкаВыдалиСерт.Сумма;
		НовСтр.Количество =  ?(ВыборкаВыдалиСерт.Количество>0,ВыборкаВыдалиСерт.Количество,ВыборкаВыдалиСерт.Количество*-1);
	КонецЦикла;
	/////////////

	
	////
	ВыборкаДобавилиСерт = Результат[2].Выбрать();
	ДобавилиСертификаты.Очистить();
	
	Пока ВыборкаДобавилиСерт.Следующий() Цикл
		АК_Сертификат = Справочники.АК_Сертификат.НайтиПоРеквизиту("ID",ВыборкаДобавилиСерт.Инентификатор);
		Если АК_Сертификат.Пустая() Тогда
			
			НовСерт = Справочники.АК_Сертификат.СоздатьЭлемент();
			НовСерт.Наименование = ВыборкаДобавилиСерт.Наименование;
			НовСерт.ДатаНачала = ВыборкаДобавилиСерт.ДатаНачалаДействия;
			НовСерт.ДатаОкончания = ВыборкаДобавилиСерт.ДатаОкончанияДействия;
			НовСерт.Сумма = ВыборкаДобавилиСерт.СертификатНаСумму;
			НовСерт.ID = ВыборкаДобавилиСерт.Инентификатор;
			НовСерт.Записать();
			АК_Сертификат = НовСерт.Ссылка;
			
		КонецЕсли;
		НовСтр = ДобавилиСертификаты.Добавить();
		НовСтр.Сертификат = АК_Сертификат;
		НовСтр.Сумма = ВыборкаДобавилиСерт.СуммаСкидки;
		НовСтр.Количество = ВыборкаДобавилиСерт.КличествоКупонов;
	КонецЦикла;
	/////////////
	ВыборкаКличествоКупонов = Результат[0].Выбрать(ОбходРезультатаЗапроса.ПоГруппировкам);
	НачисленияПоСертификатам.Очистить();
	
	Пока ВыборкаКличествоКупонов.Следующий() Цикл
		Если ВыборкаКличествоКупонов.КличествоКупонов = 1 Тогда
			ДобавилиКупонов = ВыборкаКличествоКупонов.СуммаСкидки;
		ИначеЕсли ВыборкаКличествоКупонов.КличествоКупонов = -1 Тогда
			СписалиКупонов = ВыборкаКличествоКупонов.СуммаСкидки;	
			
			ВыборкаДетали = ВыборкаКличествоКупонов.Выбрать();
			Пока ВыборкаДетали.Следующий() Цикл
				
				НовСтр = НачисленияПоСертификатам.Добавить();
				НовСтр.Сумма = ВыборкаДетали.СуммаСкидки;
				НовСтр.CashID = ВыборкаДетали.CashID;
				МагазинСтр = СтруктурныеЕдиницы.Найти(ВыборкаДетали.CashID,"CashID");
				Если МагазинСтр = Неопределено Тогда
					
					ADOСоединение = ВнешниеДанные.ПолучитьADOСоединение();
					ТекстЗапроса = 
					"select distinct Shopno from SMS_UNION..Checks as ch with(nolock)
					|where ch.CashID="+Формат(ВыборкаДетали.CashID,"ЧГ=")+" and convert(date,closedate)='"+Формат(ВыборкаДетали.ДатаДобавления,"ДФ=yyyyMMdd")+"'";
					rs = ADOСоединение.Execute(ТекстЗапроса);
					Попытка
						rs.MoveFirst();
						ShopNO = rs.Fields("ShopNO").Value;  
						НовСтрТорговаяТочка = Справочники.СтруктурныеЕдиницы.НайтиПоРеквизиту("НомерТочки",ShopNO);
						
						Если ЗначениеЗаполнено(ShopNO) и ЗначениеЗаполнено(НовСтрТорговаяТочка) Тогда 
							ADOСоединение.Close();	
							НовСтр.ТорговаяТочка  = НовСтрТорговаяТочка;
							Продолжить;	
						иначе
							
						КонецЕсли;
						//Пока НЕ rs.EOF() Цикл
						//		rs.MoveNext();
						//КонецЦикла;
					Исключение
					КонецПопытки;	
					ADOСоединение.Close();	
				КонецЕсли;
				
				Если МагазинСтр <> Неопределено Тогда 
					НовСтр.ТорговаяТочка = МагазинСтр.Ссылка;
				Иначе
					ShopNo = "";
					НомераМагазиновСтр = НомераМагазинов.Найти(ВыборкаДетали.CashID,"CashID");
					Если НомераМагазиновСтр <> Неопределено Тогда 
						ShopNo = НомераМагазиновСтр.ShopNo;
					КонецЕсли;
					Сообщить("Не найдена структурная единица по CashID="+ВыборкаДетали.CashID+", номер магазина "+ShopNo+".");
				КонецЕсли;
				
				//НомераМагазиновСтр = НомераМагазинов.Найти(ВыборкаДетали.CashID,"CashID");
				//Если НомераМагазиновСтр <> Неопределено Тогда 
				//	НовСтр.ShopNo = НомераМагазиновСтр.ShopNo;
				//КонецЕсли;

			КонецЦикла;
		КонецЕсли;
	КонецЦикла;

		
	ВыборкаОбщийИтог = Результат[1].Выбрать(ОбходРезультатаЗапроса.ПоГруппировкам);

	ВыборкаОбщийИтог.Следующий();		// Общий итог

	НеИспользованныеЗаКвартал = ВыборкаОбщийИтог.СуммаСкидки; 
 		
		
	РезультатСертификатов.Вставить("НеИспользованныеЗаКвартал",НеИспользованныеЗаКвартал);
	РезультатСертификатов.Вставить("ДобавилиКупонов",ДобавилиКупонов);
	РезультатСертификатов.Вставить("СписалиКупонов",СписалиКупонов);
		
	Возврат РезультатСертификатов;//ТабДанные;
	
КонецФункции // ()
//--- AK 
 



Функция ПолучитьБонусыЗаМесяц(ДатаОбработки) Экспорт
	
	УстановитьПривилегированныйРежим(Истина);
	//+++AK BARA #15552.01
	ADOСоединение = ВнешниеДанные.ПолучитьADOСоединение();
	
	Запрос = "SELECT [ShopNo]
	|     ,[Бонус] as Сумма
	| FROM [Loyalty].[dbo].[Bonus_month_Shopno]
	| where [год] = %Год and [Месяц] = %Месяц";
	
	Запрос = СтрЗаменить(Запрос,"%Год",Формат(Год(ДатаОбработки),"ЧГ="));
	Запрос = СтрЗаменить(Запрос,"%Месяц",Формат(Месяц(ДатаОбработки),"ЧГ="));
	
	rs = ADOСоединение.Execute(Запрос);	
	ТабДанные = Новый ТаблицаЗначений;
	
	ТабДанные = ВнешниеДанные.ПреобразоватьРезультатВТаблицуЗначений(rs);
	ТабДанные.Колонки.Добавить("ТорговаяТочка", Новый ОписаниеТипов("СправочникСсылка.СтруктурныеЕдиницы"));
	ADOСоединение.Close();
	//---AK BARA #15552.01
		
	Запрос = Новый Запрос();
	
	Запрос.Текст = "ВЫБРАТЬ
	|	СтруктурныеЕдиницы.Ссылка,
	|	СтруктурныеЕдиницы.НомерТочки
	|ИЗ
	|	Справочник.СтруктурныеЕдиницы КАК СтруктурныеЕдиницы
	|ГДЕ
	|	СтруктурныеЕдиницы.НомерТочки > 0";
	
	
	Запрос.УстановитьПараметр("ДатаОбработки", ДатаОбработки);
	
	Результаты = Запрос.Выполнить();

	ТабТТ = Результаты.Выгрузить();
	
	ТТВсе = Справочники.СтруктурныеЕдиницы.НайтиПоНаименованию("Все");
	
	Для Каждого СтрокаТаб Из ТабДанные Цикл
		СтрокаТТ = ТабТТ.Найти(СтрокаТаб.ShopNo, "НомерТочки");
		Если СтрокаТТ <> Неопределено Тогда
			СтрокаТаб.ТорговаяТочка = СтрокаТТ.Ссылка;
		Иначе
			СтрокаТаб.ТорговаяТочка = ТТВсе;
		КонецЕсли;	
	КонецЦикла;
	Если ТабДанные.Количество()<>0 Тогда 
		ТабДанные.Сортировать("ShopNo");
		ТабДанные.Свернуть("ТорговаяТочка", "Сумма");
	КонецЕсли;
	Возврат ТабДанные;
	
КонецФункции