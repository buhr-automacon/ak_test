﻿
Перем ТаблицаДанных;

Процедура ПолучитьТаблицуABCD_МетодКасательных(ИмяПоказателя)
	
	Сч = 0;
	ПоказательСумма = 0;
	Для Каждого СтрокаТЗ Из ТаблицаДанных Цикл
		Если СтрокаТЗ[ИмяПоказателя] > 0 Тогда 
			Сч = Сч + 1;
			ПоказательСумма = ПоказательСумма + СтрокаТЗ[ИмяПоказателя];
		КонецЕСли;
	КонецЦикла;
	
	Если Сч = 0 Тогда Возврат; КонецЕсли;
	
	ПоказательСреднее = ПоказательСумма / Сч;
	
	ТаблицаДанных.Колонки.Добавить(ИмяПоказателя + "КлассПредварительно");
	
	СтруктураСтатистикаКлассПредварительноКоличество = Новый Структура;
	СтруктураСтатистикаКлассПредварительноКоличество.Вставить("AB", 0);
	СтруктураСтатистикаКлассПредварительноКоличество.Вставить("BC", 0);
	
	СтруктураСтатистикаКлассПредварительноСумма = Новый Структура;
	СтруктураСтатистикаКлассПредварительноСумма.Вставить("AB", 0);
	СтруктураСтатистикаКлассПредварительноСумма.Вставить("BC", 0);
	
	//выполняем AB,BC классификацию
	Для Каждого СтрокаТЗ Из ТаблицаДанных Цикл
		
		Если СтрокаТЗ[ИмяПоказателя] <= 0 Тогда
			
			СтрокаТЗ[ИмяПоказателя + "КлассПредварительно"] = "D";
			Продолжить;
			
		ИначеЕсли СтрокаТЗ[ИмяПоказателя] >= ПоказательСреднее Тогда
			
			СтрокаТЗ[ИмяПоказателя + "КлассПредварительно"] = "AB";
			СтруктураСтатистикаКлассПредварительноКоличество.AB = СтруктураСтатистикаКлассПредварительноКоличество.AB + 1;
			СтруктураСтатистикаКлассПредварительноСумма.AB = СтруктураСтатистикаКлассПредварительноСумма.AB + СтрокаТЗ[ИмяПоказателя];
			
		Иначе
			
			СтрокаТЗ[ИмяПоказателя + "КлассПредварительно"] = "BC";
			СтруктураСтатистикаКлассПредварительноКоличество.BC = СтруктураСтатистикаКлассПредварительноКоличество.BC + 1;
			СтруктураСтатистикаКлассПредварительноСумма.BC = СтруктураСтатистикаКлассПредварительноСумма.BC + СтрокаТЗ[ИмяПоказателя];
			
		КонецЕсли;	
		
	КонецЦикла; 
	
	//выполняем A, B, C, D классификацию
	Для Каждого СтрокаТЗ Из ТаблицаДанных Цикл
		
		Если СтрокаТЗ[ИмяПоказателя + "КлассПредварительно"] = "D" Тогда
			СтрокаТЗ[ИмяПоказателя + "Класс"] = "D";
			
		ИначеЕсли СтрокаТЗ[ИмяПоказателя] * СтруктураСтатистикаКлассПредварительноКоличество[СтрокаТЗ[ИмяПоказателя + "КлассПредварительно"]] >= СтруктураСтатистикаКлассПредварительноСумма[СтрокаТЗ[ИмяПоказателя + "КлассПредварительно"]] Тогда
			
			Если СтрокаТЗ[ИмяПоказателя + "КлассПредварительно"] = "AB" Тогда
				СтрокаТЗ[ИмяПоказателя + "Класс"] = "A";
				СтрокаТЗ["ЭтоПроблемныйПоказатель"] = Истина;
			ИначеЕсли СтрокаТЗ[ИмяПоказателя + "КлассПредварительно"] = "BC" Тогда	
				СтрокаТЗ[ИмяПоказателя + "Класс"] = "B";
			КонецЕсли;	
			
		Иначе
			
			Если СтрокаТЗ[ИмяПоказателя + "КлассПредварительно"] = "AB" Тогда
				СтрокаТЗ[ИмяПоказателя + "Класс"] = "B";
			ИначеЕсли СтрокаТЗ[ИмяПоказателя + "КлассПредварительно"] = "BC" Тогда	
				СтрокаТЗ[ИмяПоказателя + "Класс"] = "C";
			КонецЕсли;
			
		КонецЕсли;	
		
	КонецЦикла;
	
	ТаблицаДанных.Колонки.Удалить(ИмяПоказателя + "КлассПредварительно");
	
КонецПроцедуры

Процедура ПриКомпоновкеРезультата(ДокументРезультат, ДанныеРасшифровки, СтандартнаяОбработка)
	
	ДатаНачала = '00010101';
	ДатаОкончания = '00010101';
	ВыводитьТолькоСПроблемнымиПоказателями = Ложь;
	
	НастройкиКомпоновщика = КомпоновщикНастроек.ПолучитьНастройки();
	ПользПоле = НастройкиКомпоновщика.ПараметрыДанных.НайтиЗначениеПараметра(Новый ПараметрКомпоновкиДанных("Период"));
	Если ПользПоле.Использование Тогда
		ДатаНачала = ПользПоле.Значение.ДатаНачала;
		ДатаОкончания = КонецДня(ПользПоле.Значение.ДатаОкончания);
	КонецЕсли;
	
	ЭлементыОтбора = НастройкиКомпоновщика.Отбор.Элементы;
	Для Каждого ПользПоле Из ЭлементыОтбора Цикл
		//Если ТипЗнч(ПользПоле) = Тип("ЭлементОтбораКомпоновкиДанных") Тогда
			Если ПользПоле.Представление = "Выводить только с проблемными показателями" Тогда
				ВыводитьТолькоСПроблемнымиПоказателями = ПользПоле.Использование;
			КонецЕсли;
		//КонецЕсли;
	КонецЦикла;
	
	Если Периодичность = "По неделям" Тогда
		ДатаНачала = НачалоНедели(ДатаНачала);
		ДатаОкончания = КонецНедели(ДатаОкончания);
	Иначе	
		ДатаНачала = НачалоМесяца(ДатаНачала);
		ДатаОкончания = КонецМесяца(ДатаОкончания);
	КонецЕсли;	
	
	//МассивТТ = Новый Массив();
	//ЕстьОтборТТ = Ложь;
	//Для Каждого ЭлементОтбор Из КомпоновщикНастроек.Настройки.Отбор.Элементы Цикл
	//	Если ЭлементОтбор.ПредставлениеПользовательскойНастройки = "Торговая точка" Тогда
	//		ОтборТТ = ПолучитьПользовательскуюНастройку(ЭлементОтбор.ИдентификаторПользовательскойНастройки);
	//		Если ОтборТТ <> Неопределено
	//			И ОтборТТ.Использование = Истина Тогда
	//			Если ОтборТТ.ВидСравнения = ВидСравненияКомпоновкиДанных.Равно Тогда
	//				ЕстьОтборТТ = Истина;
	//				МассивТТ.Добавить(ОтборТТ.ПравоеЗначение);
	//			КонецЕсли;	
	//			Если ОтборТТ.ВидСравнения = ВидСравненияКомпоновкиДанных.ВСписке Тогда
	//				ЕстьОтборТТ = Истина;
	//				Для Каждого ЭлементТТ Из ОтборТТ.ПравоеЗначение Цикл
	//					МассивТТ.Добавить(ЭлементТТ.Значение);
	//				КонецЦикла;	
	//			КонецЕсли;	
	//		КонецЕсли;	
	//	КонецЕсли;	
	//КонецЦикла;	
	
	//ТаблицаДанных = Отчеты.ОтчетПоРасхождениямДвиженийЛистовУчетаИSQL.ПолучитьТаблицуРасхождений(ДатаНачала, ДатаОкончания, ЕстьОтборТТ, МассивТТ);	
	
	Запрос = Новый Запрос(
		"ВЫБРАТЬ
		|	ЗаданиеАудитору.Производитель КАК Производитель,
		|	МАКСИМУМ(ЗаданиеАудитору.Маркер) КАК Маркер
		|ПОМЕСТИТЬ ВложенныйЗапрос
		|ИЗ
		|	Документ.ЗаданиеАудитору КАК ЗаданиеАудитору
		|ГДЕ
		|	ЗаданиеАудитору.ПометкаУдаления = ЛОЖЬ
		|	И ЗаданиеАудитору.ДатаАудита > ДАТАВРЕМЯ(1, 1, 1)
		|
		|СГРУППИРОВАТЬ ПО
		|	ЗаданиеАудитору.Производитель
		|
		|ИНДЕКСИРОВАТЬ ПО
		|	Производитель
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	ВЫБОР
		|		КОГДА Контрагенты.ГоловнойКонтрагент = ЗНАЧЕНИЕ(Справочник.Контрагенты.ПустаяСсылка)
		|			ТОГДА Контрагенты.Ссылка
		|		ИНАЧЕ Контрагенты.ГоловнойКонтрагент
		|	КОНЕЦ КАК Поставщик,
		|	Контрагенты.ИД,
		|	ВложенныйЗапрос.Маркер КАК СтатусАудитаПоставщика
		|ИЗ
		|	Справочник.Контрагенты КАК Контрагенты
		|		ЛЕВОЕ СОЕДИНЕНИЕ ВложенныйЗапрос КАК ВложенныйЗапрос
		|		ПО Контрагенты.Ссылка = ВложенныйЗапрос.Производитель
		|ГДЕ
		|	Контрагенты.ЭтоГруппа = ЛОЖЬ");
	
	Запрос.Текст = "ВЫБРАТЬ
	               |	ВЫБОР
	               |		КОГДА Контрагенты.ГоловнойКонтрагент <> ЗНАЧЕНИЕ(Справочник.Контрагенты.ПустаяСсылка)
	               |			ТОГДА Контрагенты.ГоловнойКонтрагент
	               |		ИНАЧЕ Контрагенты.Ссылка
	               |	КОНЕЦ КАК Поставщик,
	               |	Контрагенты.ИД,
	               |	ВложенныйЗапрос.Маркер КАК СтатусАудитаПоставщика
	               |ИЗ
	               |	Справочник.Контрагенты КАК Контрагенты
	               |		ЛЕВОЕ СОЕДИНЕНИЕ (ВЫБРАТЬ
	               |			ВЗ_Макс.Производитель КАК Производитель,
	               |			МАКСИМУМ(ЗаданиеАудитору.Маркер) КАК Маркер
	               |		ИЗ
	               |			(ВЫБРАТЬ
	               |				МАКСИМУМ(ЗаданиеАудитору.ДатаАудита) КАК ДатаАудита,
	               |				ЗаданиеАудитору.Производитель КАК Производитель
	               |			ИЗ
	               |				Документ.ЗаданиеАудитору КАК ЗаданиеАудитору
	               |			ГДЕ
	               |				ЗаданиеАудитору.ПометкаУдаления = Ложь
	               |				И ЗаданиеАудитору.ДатаАудита > ДАТАВРЕМЯ(1, 1, 1)
	               |			
	               |			СГРУППИРОВАТЬ ПО
	               |				ЗаданиеАудитору.Производитель) КАК ВЗ_Макс
	               |				ВНУТРЕННЕЕ СОЕДИНЕНИЕ Документ.ЗаданиеАудитору КАК ЗаданиеАудитору
	               |				ПО ВЗ_Макс.ДатаАудита = ЗаданиеАудитору.ДатаАудита
	               |					И ВЗ_Макс.Производитель = ЗаданиеАудитору.Производитель
	               |		
	               |		СГРУППИРОВАТЬ ПО
	               |			ВЗ_Макс.Производитель) КАК ВложенныйЗапрос
	               |		ПО Контрагенты.Ссылка = ВложенныйЗапрос.Производитель";
	
	ТабКонтрагенты = Запрос.Выполнить().Выгрузить();
	ТабКонтрагенты.Индексы.Добавить("ИД");
	
	ОписаниеТиповЧисло = Новый ОписаниеТипов("Число");
	ТаблицаДанных = Новый ТаблицаЗначений();
	ТаблицаДанных.Колонки.Добавить("Период", Новый ОписаниеТипов("Строка",, Новый КвалификаторыСтроки(100, ДопустимаяДлина.Переменная)));
	ТаблицаДанных.Колонки.Добавить("Дата", Новый ОписаниеТипов("Дата"));
	ТаблицаДанных.Колонки.Добавить("Товар", Новый ОписаниеТипов("СправочникСсылка.Номенклатура"));
	ТаблицаДанных.Колонки.Добавить("Поставщик", Новый ОписаниеТипов("СправочникСсылка.Контрагенты"));
	ТаблицаДанных.Колонки.Добавить("Выручка", ОписаниеТиповЧисло);
	ТаблицаДанных.Колонки.Добавить("ДоляПоставщикаВВыручке", ОписаниеТиповЧисло);
	ТаблицаДанных.Колонки.Добавить("ЖалобыПоПоставщику", ОписаниеТиповЧисло);
	ТаблицаДанных.Колонки.Добавить("ВозвратыПоПоставщику", ОписаниеТиповЧисло);
	ТаблицаДанных.Колонки.Добавить("КоличествоВключений", ОписаниеТиповЧисло);
	ТаблицаДанных.Колонки.Добавить("КоличествоВключенийКВыручкеНа100Тысяч", ОписаниеТиповЧисло);
	ТаблицаДанных.Колонки.Добавить("КоличествоЖалобИВозвратовНа100Тысяч", ОписаниеТиповЧисло);
	ТаблицаДанных.Колонки.Добавить("ДоляЖалобИВозвратовПоПоставщику", ОписаниеТиповЧисло);
	ТаблицаДанных.Колонки.Добавить("КоличествоНарушенийВЛабораторныхПротоколах", ОписаниеТиповЧисло);
	ТаблицаДанных.Колонки.Добавить("СредняяЧастотаПоВВ", ОписаниеТиповЧисло);
	ТаблицаДанных.Колонки.Добавить("КолвоНедельВЧастоте", ОписаниеТиповЧисло);
	ТаблицаДанных.Колонки.Добавить("ЖалобыИВозвраты", ОписаниеТиповЧисло);
	ТаблицаДанных.Колонки.Добавить("СтатусАудитаПоставщика", Новый ОписаниеТипов("ПеречислениеСсылка.МаркерыДляАудита"));
	ТаблицаДанных.Колонки.Добавить("ЭтоПроблемныйПоказатель", Новый ОписаниеТипов("Булево"));
								
	СтандартнаяОбработка = Ложь;
	
	КэшНоменклатура = Новый Соответствие;
	
	ADOСоединение = ВнешниеДанные.ПолучитьADOСоединение();
	
	//ТекстЗапроса = "exec sms_repl..Get_Sale_Vozvrat_Tov_Harakt_Data " + ВнешниеДанные.ФорматПоля(ДатаНачала, Истина) + ", " + ВнешниеДанные.ФорматПоля(ДатаОкончания, Истина);
	
	СтрокаПериода = ?(Периодичность = "По неделям", "DATEADD(DAY, DATEDIFF(DAY,0, #t.date_ch)/7*7,0)", "cast(convert(char(6),#t.date_ch,112)+'01' as datetime)");
	
	ТекстЗапроса = "create table #t (id_tov int, id_kontr int,date_ch date,  Qty_vozvrat decimal(15,3),Qty_Sale decimal(15,3), summa  decimal(15,2))
					|
					|insert into #t(id_tov,id_kontr,date_ch,Qty_vozvrat,Qty_Sale,  summa)
					|
					|exec SMS_REPL..Get_Sale_Vozvrat_Tov_Harakt_Data " + ВнешниеДанные.ФорматПоля(ДатаНачала, Истина) + ", " + ВнешниеДанные.ФорматПоля(ДатаОкончания, Истина) + "
					|
					|select #t.id_tov, #t.id_kontr, CONVERT(datetime, #t.date_ch) date_ch, #t.summa, #t.Qty_vozvrat as Vozvrat, UINTov._Fld4946 as TovarUID
					|	, " + СтрокаПериода + " as [Дата]
					|from #t
					|LEFT OUTER JOIN IzbenkaFin.dbo._InfoRg4943 UINTov (nolock) ON #t.id_tov = UINTov._Fld4953 and UINTov._Fld4944_TYPE = 0x08 and UINTov._Fld4944_RTRef = 0x0000001D
					|			WHERE NOT UINTov._Fld4946 is null and ISNULL(#t.id_kontr, 0) <> 0";
	
	rs = ADOСоединение.Execute(ТекстЗапроса);
	Пока rs <> Неопределено И rs.Fields.Count <= 0 Цикл
		rs=rs.NextRecordSet();
	КонецЦикла;
	
	Попытка
		rs.MoveFirst();
		
		Пока НЕ rs.EOF() Цикл
			СтрокаКешКонтр = ТабКонтрагенты.Найти(Rs.Fields("id_kontr").Value, "ИД");
			Если СтрокаКешКонтр = Неопределено Тогда
				rs.MoveNext();
				Продолжить;
			КонецЕсли;	
			СтрокаДоб = ТаблицаДанных.Добавить();
			//Если Периодичность = "По неделям" Тогда
			//	СтрокаДоб.Дата = НачалоНедели(Rs.Fields("date_ch").Value);
			//Иначе
			//	СтрокаДоб.Дата = НачалоМесяца(Rs.Fields("date_ch").Value);
			//КонецЕсли;
			СтрокаДоб.Дата = Rs.Fields("Дата").Value;
			TovarUID = Rs.Fields("TovarUID").Value;
			Товар = КэшНоменклатура.Получить(TovarUID);
			Если Товар = Неопределено Тогда
				Товар = Справочники.Номенклатура.ПолучитьСсылку(Новый УникальныйИдентификатор(TovarUID));
				КэшНоменклатура.Вставить(TovarUID, Товар);
			КонецЕсли;
			СтрокаДоб.Товар = Товар;
			ЗаполнитьЗначенияСвойств(СтрокаДоб, СтрокаКешКонтр, "Поставщик,СтатусАудитаПоставщика");
			СтрокаДоб.Выручка = Rs.Fields("Summa").Value;
			СтрокаДоб.ВозвратыПоПоставщику = Rs.Fields("Vozvrat").Value;
			
			rs.MoveNext();
		КонецЦикла;
	Исключение
	КонецПопытки;
	
	ТаблицаДанных.Индексы.Добавить("Дата, Товар, Поставщик");
	
	//ДатаОбработки = ДатаНачала;
	//Пока ДатаОбработки <= ДатаОкончания Цикл
	
		СтрокаПериода = ?(Периодичность = "По неделям", "DATEADD(DAY, DATEDIFF(DAY,0, ls.date_ls)/7*7,0)", "cast(convert(char(6),ls.date_ls,112)+'01' as datetime)");
		
		ТекстЗапроса = "declare @date1 as date , @date2 as date
						//|declare @Start_week as int 
						//|set @Start_week=master.dbo.nedely(" + ВнешниеДанные.ФорматПоля(ДатаОбработки) + ")-1
						//|
						//|set @date1=dateadd(day,(@start_week-1)*7,{d'2009-05-11'})
						//|set @date2 = dateadd(day,(@start_week-1)*7+6,{d'2009-05-11'})
                        |
						|set @date1 = " + ВнешниеДанные.ФорматПоля(ДатаНачала, Истина) + "
						|set @date2 = " + ВнешниеДанные.ФорматПоля(ДатаОкончания, Истина) + "
                        |
						|declare @tt_format as int = 2
                        |
						|select UINTov._Fld4946 as TovarUID, case when isnull(ls.id_kontr_ls,0)=0 
						|	 then  case when isnull(ls.id_kontr_fp,0)=0  then isnull(ls.id_kontr_matrix,0) else ls.id_kontr_fp end 
						|	 else ls.id_kontr_ls end   id_kontr_ls   
						|  ," + СтрокаПериода + " [ДатаПоиска]
						|  ,SUM (ls.sales_ls )  / SUM ( ls.checks_1 + case when ls.konost_ls>=0.1 then ls.checks_2 else 0 end )  * 10 частота 
						|  ,SUM(ls.sales_fact ) kolvo 
						|  ,SUM(case when isnull(ls.id_kontr_ls,0)<>0 then ls.sales_fact_scan else ls.sales_fact end ) kolvo_s       
						|from m2..Lost_sales (nolock) ls
						|   inner join M2..tt on tt.id_TT = ls.id_tt_ls and tt.tt_format=@tt_format
						|   LEFT OUTER JOIN IzbenkaFin.dbo._InfoRg4943 UINTov (nolock) ON ls.id_tov_ls = UINTov._Fld4953 and UINTov._Fld4944_TYPE = 0x08 and UINTov._Fld4944_RTRef = 0x0000001D
						| where ls.date_ls between @date1 and @date2 --and ls.chastota >0 and ls.sales_ls>0
						| group by UINTov._Fld4946,  case when isnull(ls.id_kontr_ls,0)=0 
						|	 then  case when isnull(ls.id_kontr_fp,0)=0  then isnull(ls.id_kontr_matrix,0) else ls.id_kontr_fp end 
						|	 else ls.id_kontr_ls end   
						|  ," + СтрокаПериода + "
						| having SUM(sales_q)>20";
		
		rs = ADOСоединение.Execute(ТекстЗапроса);
		Пока rs <> Неопределено И rs.Fields.Count <= 0 Цикл
			rs=rs.NextRecordSet();
		КонецЦикла;
		
		Попытка
			rs.MoveFirst();
			
			Пока НЕ rs.EOF() Цикл
				СтрокаКешКонтр = ТабКонтрагенты.Найти(Rs.Fields("id_kontr_ls").Value, "ИД");
				Если СтрокаКешКонтр = Неопределено Тогда
					rs.MoveNext();
					Продолжить;
				КонецЕсли;
				//Если Периодичность = "По неделям" Тогда
				//	ДатаПоиска = НачалоНедели(ДатаОбработки);
				//Иначе
				//	ДатаПоиска = НачалоМесяца(ДатаОбработки);
				//КонецЕсли;
				ДатаПоиска = Rs.Fields("ДатаПоиска").Value;
				TovarUID = Rs.Fields("TovarUID").Value;
				Товар = КэшНоменклатура.Получить(TovarUID);
				Если Товар = Неопределено Тогда
					Товар = Справочники.Номенклатура.ПолучитьСсылку(Новый УникальныйИдентификатор(TovarUID));
					КэшНоменклатура.Вставить(TovarUID, Товар);
				КонецЕсли;
				СтрокиДанных = ТаблицаДанных.НайтиСтроки(Новый Структура("Дата, Товар, Поставщик", ДатаПоиска, Товар, СтрокаКешКонтр.Поставщик));
				Если СтрокиДанных.Количество() = 0 Тогда
					rs.MoveNext();
					Продолжить;
				КонецЕсли;	
				СтрокаДоб = СтрокиДанных[0];
				СтрокаДоб.КолвоНедельВЧастоте = СтрокаДоб.КолвоНедельВЧастоте + 1;
				//+++АК SHEP 20170914 ИП-00016657
				СтрокаДоб.СредняяЧастотаПоВВ = СтрокаДоб.СредняяЧастотаПоВВ + Rs.Fields("частота").Value;
				// вычисляем среднее арифметическое на текущий момент, чтобы не перебирать потом всю таблицу
				//СтрокаДоб.СредняяЧастотаПоВВ = (СтрокаДоб.СредняяЧастотаПоВВ * (СтрокаДоб.КолвоНедельВЧастоте - 1) + Rs.Fields("частота").Value) / СтрокаДоб.КолвоНедельВЧастоте;
				//---АК SHEP 20170914
				
				rs.MoveNext();
			КонецЦикла;
		Исключение
		КонецПопытки;
		
	//	ДатаОбработки = ДатаОбработки + 86400*7;
	//КонецЦикла;	
	
	//+++АК SHEP 20170914 ИП-00016657 закомментировал
	Для Каждого СтрокаТаб Из ТаблицаДанных Цикл
		Если СтрокаДоб.КолвоНедельВЧастоте <> 0 Тогда
			СтрокаТаб.СредняяЧастотаПоВВ = Окр(СтрокаТаб.СредняяЧастотаПоВВ / СтрокаДоб.КолвоНедельВЧастоте, 6);
		КонецЕсли;
	КонецЦикла;
	//---АК SHEP 20170914
	
	ТаблицаДанных.Свернуть("Дата, Период, Товар, Поставщик, СтатусАудитаПоставщика, ЭтоПроблемныйПоказатель", "Выручка, ДоляПоставщикаВВыручке, ЖалобыПоПоставщику, ВозвратыПоПоставщику, КоличествоВключений
							|, КоличествоВключенийКВыручкеНа100Тысяч, КоличествоЖалобИВозвратовНа100Тысяч, ДоляЖалобИВозвратовПоПоставщику, КоличествоНарушенийВЛабораторныхПротоколах, СредняяЧастотаПоВВ, ЖалобыИВозвраты");
							
	//Выберем жалобы
	Запрос = Новый Запрос();
	Запрос.УстановитьПараметр("ДатаНач", ДатаНачала);
	Запрос.УстановитьПараметр("ДатаКон", ДатаОкончания);
	Запрос.Текст = "ВЫБРАТЬ
	               |	ОбращенияПокупателей.Номенклатура,
	               |	ВЫБОР
	               |		КОГДА ОбращенияПокупателей.Производитель.ГоловнойКонтрагент <> ЗНАЧЕНИЕ(Справочник.Контрагенты.ПустаяСсылка)
	               |			ТОГДА ОбращенияПокупателей.Производитель.ГоловнойКонтрагент
	               |		ИНАЧЕ ОбращенияПокупателей.Производитель
	               |	КОНЕЦ КАК Поставщик,
	               |	НАЧАЛОПЕРИОДА(ОбращенияПокупателей.ДатаДок, НЕДЕЛЯ) КАК Период,
	               |	СУММА(1) КАК ЖалобыПоПоставщику,
	               |	СУММА(ВЫБОР
	               |			КОГДА ОбращенияПокупателей.ТипЖалобы.ЭтоВключениеВПродукт
	               |				ТОГДА 1
	               |			ИНАЧЕ 0
	               |		КОНЕЦ) КАК КоличествоВключений,
	               |	СУММА(0) КАК КоличествоНарушенийВЛабораторныхПротоколах
	               |ПОМЕСТИТЬ ТаблицаДанных
	               |ИЗ
	               |	РегистрСведений.ОбращенияПокупателей КАК ОбращенияПокупателей
	               |ГДЕ
	               |	ОбращенияПокупателей.ДатаДок МЕЖДУ &ДатаНач И &ДатаКон
	               |	И ОбращенияПокупателей.ТипЖалобы.СчитатьЖалобойНаТовар = ИСТИНА
	               |
	               |СГРУППИРОВАТЬ ПО
	               |	ОбращенияПокупателей.Номенклатура,
	               |	ВЫБОР
	               |		КОГДА ОбращенияПокупателей.Производитель.ГоловнойКонтрагент <> ЗНАЧЕНИЕ(Справочник.Контрагенты.ПустаяСсылка)
	               |			ТОГДА ОбращенияПокупателей.Производитель.ГоловнойКонтрагент
	               |		ИНАЧЕ ОбращенияПокупателей.Производитель
	               |	КОНЕЦ,
	               |	НАЧАЛОПЕРИОДА(ОбращенияПокупателей.ДатаДок, НЕДЕЛЯ)
	               |
	               |ОБЪЕДИНИТЬ ВСЕ
	               |
	               |ВЫБРАТЬ
	               |	ПроверкаКачестваТоваров.Номенклатура,
	               |	ВЫБОР
	               |		КОГДА ЗначенияСвойствОбъектов.Значение.ГоловнойКонтрагент <> ЗНАЧЕНИЕ(Справочник.Контрагенты.ПустаяСсылка)
	               |			ТОГДА ЗначенияСвойствОбъектов.Значение.ГоловнойКонтрагент
	               |		ИНАЧЕ ЗначенияСвойствОбъектов.Значение
	               |	КОНЕЦ,
	               |	НАЧАЛОПЕРИОДА(ПроверкаКачестваТоваров.Дата, НЕДЕЛЯ),
	               |	СУММА(0),
	               |	СУММА(0),
	               |	СУММА(1)
	               |ИЗ
	               |	Документ.ПроверкаКачестваТоваров КАК ПроверкаКачестваТоваров
	               |		ВНУТРЕННЕЕ СОЕДИНЕНИЕ Документ.ПроверкаКачестваТоваров.СоставПоказателей КАК ПроверкаКачестваТоваровСоставПоказателей
	               |		ПО ПроверкаКачестваТоваров.Ссылка = ПроверкаКачестваТоваровСоставПоказателей.Ссылка
	               |		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.ЗначенияСвойствОбъектов КАК ЗначенияСвойствОбъектов
	               |		ПО ПроверкаКачестваТоваров.ХарактеристикаНоменклатуры = ЗначенияСвойствОбъектов.Объект
	               |			И (ЗначенияСвойствОбъектов.Свойство = ЗНАЧЕНИЕ(ПланВидовХарактеристик.СвойстваОбъектов.Производитель))
	               |ГДЕ
	               |	ПроверкаКачестваТоваров.Дата МЕЖДУ &ДатаНач И &ДатаКон
	               |	И ПроверкаКачестваТоваров.Проведен = ИСТИНА
	               |	И ПроверкаКачестваТоваровСоставПоказателей.Нарушение = ИСТИНА
	               |
	               |СГРУППИРОВАТЬ ПО
	               |	ВЫБОР
	               |		КОГДА ЗначенияСвойствОбъектов.Значение.ГоловнойКонтрагент <> ЗНАЧЕНИЕ(Справочник.Контрагенты.ПустаяСсылка)
	               |			ТОГДА ЗначенияСвойствОбъектов.Значение.ГоловнойКонтрагент
	               |		ИНАЧЕ ЗначенияСвойствОбъектов.Значение
	               |	КОНЕЦ,
	               |	ПроверкаКачестваТоваров.Номенклатура,
	               |	НАЧАЛОПЕРИОДА(ПроверкаКачестваТоваров.Дата, НЕДЕЛЯ)
	               |;
	               |
	               |////////////////////////////////////////////////////////////////////////////////
	               |ВЫБРАТЬ
	               |	ТаблицаДанных.Номенклатура,
	               |	ТаблицаДанных.Поставщик,
	               |	ТаблицаДанных.Период,
	               |	СУММА(ТаблицаДанных.ЖалобыПоПоставщику) КАК ЖалобыПоПоставщику,
	               |	СУММА(ТаблицаДанных.КоличествоВключений) КАК КоличествоВключений,
	               |	СУММА(ТаблицаДанных.КоличествоНарушенийВЛабораторныхПротоколах) КАК КоличествоНарушенийВЛабораторныхПротоколах
	               |ИЗ
	               |	ТаблицаДанных КАК ТаблицаДанных
	               |
	               |СГРУППИРОВАТЬ ПО
	               |	ТаблицаДанных.Номенклатура,
	               |	ТаблицаДанных.Поставщик,
	               |	ТаблицаДанных.Период";
				   
	Если Периодичность <> "По неделям" Тогда
		Запрос.Текст = СтрЗаменить(Запрос.Текст, "НЕДЕЛЯ)", "МЕСЯЦ)");
	КонецЕсли;
	
	РезультатЗапроса = Запрос.Выполнить();
	Если НЕ РезультатЗапроса.Пустой() Тогда
		Выборка = РезультатЗапроса.Выбрать();
		Пока Выборка.Следующий() Цикл
			СтрокиДанных = ТаблицаДанных.НайтиСтроки(Новый Структура("Дата, Товар, Поставщик", Выборка.Период, Выборка.Номенклатура, Выборка.Поставщик));
			Если СтрокиДанных.Количество() = 0 Тогда
				Продолжить;
			КонецЕсли;	
			ЗаполнитьЗначенияСвойств(СтрокиДанных[0], Выборка, "ЖалобыПоПоставщику,КоличествоВключений,КоличествоНарушенийВЛабораторныхПротоколах");
		КонецЦикла;
	КонецЕсли;
	
	Для Каждого СтрокаТаб Из ТаблицаДанных Цикл
		Если Периодичность = "По неделям" Тогда
			СтрокаТаб.Период = "Неделя с " + Формат(СтрокаТаб.Дата, "ДФ=dd.MM.yy") + " по " + Формат(КонецНедели(СтрокаТаб.Дата), "ДФ=dd.MM.yy");
		Иначе
			СтрокаТаб.Период = Формат(СтрокаТаб.Дата, "ДФ='MMMM yy'");
		КонецЕсли;	
		СтрокаТаб.ЖалобыИВозвраты = СтрокаТаб.ЖалобыПоПоставщику + СтрокаТаб.ВозвратыПоПоставщику;
		Если СтрокаТаб.Выручка <> 0 Тогда
			СтрокаТаб.КоличествоВключенийКВыручкеНа100Тысяч = Окр(100000 / СтрокаТаб.Выручка * СтрокаТаб.КоличествоВключений, 3);
			СтрокаТаб.КоличествоЖалобИВозвратовНа100Тысяч = Окр(100000 / СтрокаТаб.Выручка * СтрокаТаб.ЖалобыИВозвраты, 3);
		КонецЕсли;	
	КонецЦикла;	
	
	ТабКопия = ТаблицаДанных.Скопировать();
	ТабКопия.Свернуть("Дата, Товар");
	
	Для Каждого СтрокаКопия Из ТабКопия Цикл
		СтрокиДанные = ТаблицаДанных.НайтиСтроки(Новый Структура("Дата, Товар", СтрокаКопия.Дата, СтрокаКопия.Товар));
		ОбщаяСуммаВыручка = 0;
		ОбщаяСуммаЖалобИВозвратов = 0;
		Для Каждого СтрокаДанные Из СтрокиДанные Цикл
			ОбщаяСуммаВыручка = ОбщаяСуммаВыручка + СтрокаДанные.Выручка;
			ОбщаяСуммаЖалобИВозвратов = ОбщаяСуммаЖалобИВозвратов + СтрокаДанные.ЖалобыИВозвраты;
		КонецЦикла;
		Для Каждого СтрокаДанные Из СтрокиДанные Цикл
			Если ОбщаяСуммаВыручка > 0 Тогда
				СтрокаДанные.ДоляПоставщикаВВыручке = Окр(СтрокаДанные.Выручка / ОбщаяСуммаВыручка * 100, 2);
			КонецЕсли;
			Если ОбщаяСуммаЖалобИВозвратов > 0 Тогда
				СтрокаДанные.ДоляЖалобИВозвратовПоПоставщику = Окр(СтрокаДанные.ЖалобыИВозвраты / ОбщаяСуммаЖалобИВозвратов * 100, 2);
			КонецЕсли;
		КонецЦикла;
	КонецЦикла;
	
	ТабКопия = Неопределено;
	
	ОписаниеТиповСтрока2 = Новый ОписаниеТипов("Строка",,,, Новый КвалификаторыСтроки(2));
	МассивПоказателей = ОбщегоНазначения.РазложитьСтрокуВМассивПодстрок("ЖалобыПоПоставщику,ВозвратыПоПоставщику,КоличествоВключений,КоличествоНарушенийВЛабораторныхПротоколах");
	Для Каждого ИмяПоказателя Из МассивПоказателей Цикл
		ТаблицаДанных.Колонки.Добавить(ИмяПоказателя + "Класс", ОписаниеТиповСтрока2);
	КонецЦикла;
	
	//+++АК SHEP 2017.10.02 ИП-00016657
	Если ВыводитьТолькоСПроблемнымиПоказателями Тогда
		
		СтрокаОтбора = "Дата,Товар,Поставщик";
		МассивИмёнКолонок = ОбщегоНазначения.РазложитьСтрокуВМассивПодстрок(СтрокаОтбора);
		//Для Каждого Колонка Из ТаблицаДанных.Колонки Цикл
		//	МассивИмёнКолонок.Добавить(Колонка.Имя);
		//КонецЦикла;
		
		СтруктураОтбора = Новый Структура(СтрокаОтбора);
		
		// Массив показателей для расчёта по методу касательных
		// Для более понятного восприятия текста запроса, он приведён в справочной информации по 2 показателям
		//+++АК SHEP 2017.10.26 ИП-00016657: придётся делать запрос в цикле, иначе выдаёт ошибку "Недостаточно памяти для получения результата запроса к базе данных"
		Для Каждого ИмяРекъ Из МассивПоказателей Цикл
			//МассивИмёнКолонок.Добавить(ИмяРекъ);
			ПолучитьТаблицуABCD_МетодКасательных(ИмяРекъ);
		КонецЦикла;
		
		//Для Каждого ИмяПоказателя Из МассивПоказателей Цикл
		//	
		//	ТекстЗапроса = "ВЫБРАТЬ";
		//	
		//	Для Каждого ИмяРекъ Из МассивИмёнКолонок Цикл
		//		ТекстЗапроса = ТекстЗапроса + "
		//		|	ИсходныеДанные." + ИмяРекъ + ",";
		//	КонецЦикла;
		//	
		//	ТекстЗапроса = ТекстЗапроса + "
		//		|	ИсходныеДанные." + ИмяПоказателя + "
		//		|ПОМЕСТИТЬ ВТ_ИсходныеДанные
		//		|ИЗ &ИсходныеДанные КАК ИсходныеДанные
		//		|;
		//		|
		//		|////////////////////////////////////////////////////////////////////////////////
		//		|ВЫБРАТЬ
		//		|	СУММА(ВЫБОР
		//		|			КОГДА ВТ_ИсходныеДанные." + ИмяПоказателя + " > 0
		//		|				ТОГДА 1
		//		|			ИНАЧЕ 0
		//		|		КОНЕЦ) КАК Количество" + ИмяПоказателя + ",
		//		|	СУММА(ВЫБОР
		//		|			КОГДА ВТ_ИсходныеДанные." + ИмяПоказателя + " > 0
		//		|				ТОГДА ВТ_ИсходныеДанные." + ИмяПоказателя + "
		//		|			ИНАЧЕ 0
		//		|		КОНЕЦ) КАК Сумма" + ИмяПоказателя + ",
		//		|	ВТ_ИсходныеДанные.Дата КАК Дата
		//		|ПОМЕСТИТЬ ВТ_ИтогиИсходныхДанных
		//		|ИЗ
		//		|	ВТ_ИсходныеДанные КАК ВТ_ИсходныеДанные
		//		|СГРУППИРОВАТЬ ПО ВТ_ИсходныеДанные.Дата
		//		|;
		//		|
		//		|////////////////////////////////////////////////////////////////////////////////
		//		|ВЫБРАТЬ
		//		|	ВТ_ИсходныеДанные." + ИмяПоказателя + ",
		//		|	ВЫБОР
		//		|		КОГДА ВТ_ИсходныеДанные." + ИмяПоказателя + " <= 0
		//		|			ТОГДА ""D""
		//		|		КОГДА ВТ_ИсходныеДанные." + ИмяПоказателя + " * ВТ_Итоги.Количество" + ИмяПоказателя + " >= ВТ_Итоги.Сумма" + ИмяПоказателя + "
		//		|			ТОГДА ""AB""
		//		|		ИНАЧЕ ""BC""
		//		|	КОНЕЦ КАК Группа" + ИмяПоказателя + ",
		//		|	ВТ_ИсходныеДанные.Дата
		//		|ПОМЕСТИТЬ ВТ_ПромежуточныйАнализ
		//		|ИЗ
		//		|	ВТ_ИсходныеДанные КАК ВТ_ИсходныеДанные
		//		|	ЛЕВОЕ СОЕДИНЕНИЕ ВТ_ИтогиИсходныхДанных КАК ВТ_Итоги
		//		|	ПО ВТ_ИсходныеДанные.Дата = ВТ_Итоги.Дата
		//		|;
		//		|
		//		|УНИЧТОЖИТЬ ВТ_ИтогиИсходныхДанных;
		//		|
		//		|////////////////////////////////////////////////////////////////////////////////
		//		|ВЫБРАТЬ
		//		|	ВТ_ПромежуточныйАнализ.Группа" + ИмяПоказателя + ",
		//		|	СУММА(ВЫБОР
		//		|			КОГДА ВТ_ПромежуточныйАнализ." + ИмяПоказателя + " > 0
		//		|				ТОГДА 1
		//		|			ИНАЧЕ 0
		//		|		КОНЕЦ) КАК Количество" + ИмяПоказателя + ",
		//		|	СУММА(ВЫБОР
		//		|			КОГДА ВТ_ПромежуточныйАнализ." + ИмяПоказателя + " > 0
		//		|				ТОГДА ВТ_ПромежуточныйАнализ." + ИмяПоказателя + "
		//		|			ИНАЧЕ 0
		//		|		КОНЕЦ) КАК Сумма" + ИмяПоказателя + ",
		//		|	ВТ_ПромежуточныйАнализ.Дата
		//		|ПОМЕСТИТЬ ВТ_ИтогиПромежуточногоАнализа" + ИмяПоказателя + "
		//		|ИЗ
		//		|	ВТ_ПромежуточныйАнализ КАК ВТ_ПромежуточныйАнализ
		//		|
		//		|СГРУППИРОВАТЬ ПО
		//		|	ВТ_ПромежуточныйАнализ.Дата,
		//		|	ВТ_ПромежуточныйАнализ.Группа" + ИмяПоказателя + "
		//		|;
		//		|
		//		|////////////////////////////////////////////////////////////////////////////////
		//		|ВЫБРАТЬ";
		//	
		//	Для Каждого ИмяРекъ Из МассивИмёнКолонок Цикл
		//		ТекстЗапроса = ТекстЗапроса + "
		//		|	ИсходныеДанные." + ИмяРекъ + ",";
		//	КонецЦикла;
		//	
		//	ТекстЗапроса = ТекстЗапроса + "
		//		|	ВЫБОР
		//		|		КОГДА ВТ_ПромежуточныйАнализ.Группа" + ИмяПоказателя + "  = ""D""
		//		|			ТОГДА ""D""
		//		|		КОГДА ВТ_ПромежуточныйАнализ.Группа" + ИмяПоказателя + "  = ""AB""
		//		|				И ВТ_ПромежуточныйАнализ." + ИмяПоказателя + " * ВТ_ИтогиПромежуточногоАнализа" + ИмяПоказателя + ".Количество" + ИмяПоказателя +
		//						" >= ВТ_ИтогиПромежуточногоАнализа" + ИмяПоказателя + ".Сумма" + ИмяПоказателя + "
		//		|			ТОГДА ""A""
		//		|		КОГДА ВТ_ПромежуточныйАнализ.Группа" + ИмяПоказателя + "  = ""BC""
		//		|				И ВТ_ПромежуточныйАнализ." + ИмяПоказателя + " * ВТ_ИтогиПромежуточногоАнализа" + ИмяПоказателя + ".Количество" + ИмяПоказателя +
		//						" < ВТ_ИтогиПромежуточногоАнализа" + ИмяПоказателя + ".Сумма" + ИмяПоказателя + "
		//		|			ТОГДА ""C""
		//		|		ИНАЧЕ ""B""
		//		|	КОНЕЦ КАК Группа" + ИмяПоказателя + "
		//		|ИЗ
		//		|	ВТ_ИсходныеДанные КАК ИсходныеДанные
		//		|		ЛЕВОЕ СОЕДИНЕНИЕ ВТ_ПромежуточныйАнализ КАК ВТ_ПромежуточныйАнализ
		//		|		ПО ИсходныеДанные.Дата = ВТ_ПромежуточныйАнализ.Дата
		//		|			И ИсходныеДанные." + ИмяПоказателя + " = ВТ_ПромежуточныйАнализ." + ИмяПоказателя + "
		//		|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ ВТ_ИтогиПромежуточногоАнализа" + ИмяПоказателя + " КАК ВТ_ИтогиПромежуточногоАнализа" + ИмяПоказателя + "
		//		|		ПО ВТ_ПромежуточныйАнализ.Дата = ВТ_ИтогиПромежуточногоАнализа" + ИмяПоказателя + ".Дата
		//		|			И ВТ_ПромежуточныйАнализ.Группа" + ИмяПоказателя + " = ВТ_ИтогиПромежуточногоАнализа" + ИмяПоказателя + ".Группа" + ИмяПоказателя;
		//	
		//	ТабКопия = ТаблицаДанных.Скопировать(, СтрокаОтбора + "," + ИмяПоказателя);
		//	Запрос = Новый Запрос(ТекстЗапроса);
		//	Запрос.УстановитьПараметр("ИсходныеДанные", ТабКопия);
		//	//ТаблицаДанных = Запрос.Выполнить().Выгрузить();
		//	
		//	РезультатЗапроса = Запрос.Выполнить();
		//	ТабКопия = Неопределено;
		//	
		//	Если НЕ РезультатЗапроса.Пустой() Тогда
		//		
		//		Выборка = РезультатЗапроса.Выбрать();
		//		Пока Выборка.Следующий() Цикл
		//			
		//			ЗаполнитьЗначенияСвойств(СтруктураОтбора, Выборка);
		//			СтрокиДанных = ТаблицаДанных.НайтиСтроки(СтруктураОтбора);
		//			Если СтрокиДанных.Количество() = 0 Тогда Продолжить; КонецЕсли;
		//			
		//			ЭтоПроблемныйПоказатель = СтрокиДанных[0].ЭтоПроблемныйПоказатель ИЛИ (Выборка["Группа" + ИмяПоказателя] = "A");
		//			СтрокиДанных[0].ЭтоПроблемныйПоказатель = ЭтоПроблемныйПоказатель ИЛИ (СтрокиДанных[0].СтатусАудитаПоставщика = ПредопределенноеЗначение("Перечисление.МаркерыДляАудита.Красный"));
		//			
		//		КонецЦикла;
		//	
		//	КонецЕсли;
		//	
		//	РезультатЗапроса = Неопределено;
		//	
		//КонецЦикла;
		
	КонецЕсли;
	//---АК SHEP 2017.10.02
	
	ВнешниеНаборыДанных = Новый Структура;
	ВнешниеНаборыДанных.Вставить("ДанныеДляФормирования", ТаблицаДанных);
	
	//Макет компоновки 
	КомпоновщикМакета = Новый КомпоновщикМакетаКомпоновкиДанных;
	МакетКомпоновки = КомпоновщикМакета.Выполнить(СхемаКомпоновкиДанных, НастройкиКомпоновщика, ДанныеРасшифровки);
	
	//Компоновка данных
	ПроцессорКомпоновки = Новый ПроцессорКомпоновкиДанных;
	ПроцессорКомпоновки.Инициализировать(МакетКомпоновки, ВнешниеНаборыДанных, ДанныеРасшифровки);
	
	//Вывод результата
	ПроцессорВывода = Новый ПроцессорВыводаРезультатаКомпоновкиДанныхВТабличныйДокумент;
	ПроцессорВывода.УстановитьДокумент(ДокументРезультат);
	ПроцессорВывода.Вывести(ПроцессорКомпоновки);
	
КонецПроцедуры
