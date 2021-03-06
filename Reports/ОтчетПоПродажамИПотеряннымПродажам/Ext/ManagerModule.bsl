﻿
// Функция возвращает массив доступной номенклатуры (групп номенклатуры) расчетчика
//
Функция ПолучитьМассивДоступнойНоменклатуры(мРасчетчик)
	
	Перем Запрос, ТекстЗапроса;
	
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("Расчетчик", мРасчетчик);
	
	Запрос.Текст =
	"ВЫБРАТЬ РАЗРЕШЕННЫЕ РАЗЛИЧНЫЕ
	|	ГруппыНоменклатуры.ГруппаНоменклатуры КАК Номенклатура
	|ИЗ
	|	Справочник.Расчетчики.ГруппыНоменклатуры КАК ГруппыНоменклатуры
	|ГДЕ
	//+++АК SHEP 2018.08.02 ИП-00019381
	//|	ГруппыНоменклатуры.Ссылка = &Расчетчик
	|	ВЫБОР
	|		КОГДА &Расчетчик = НЕОПРЕДЕЛЕНО
	|			ТОГДА ИСТИНА
	|		ИНАЧЕ ГруппыНоменклатуры.Ссылка = &Расчетчик
	|	КОНЕЦ
	//+++АК SHEP 2018.08.02
	|	И НЕ ГруппыНоменклатуры.ГруппаНоменклатуры.ЭтоГруппа";
	
	Возврат Запрос.Выполнить().Выгрузить().ВыгрузитьКолонку("Номенклатура");
	
КонецФункции

Функция ПолучитьТекстУсловияПоДатам(мДатаНачала, мДатаОкончания, ТекстПоляДаты)
	
	ТекстУсловияПоДатам =
	" " + ТекстПоляДаты + " >= '" + Формат(мДатаНачала, "ДФ='yyyy-MM-ddTHH:mm:ss'") + "'
	| 	AND " + ТекстПоляДаты + " <= '" + Формат(мДатаОкончания, "ДФ='yyyy-MM-ddTHH:mm:ss'") + "'
	| 	AND";
	
	Возврат ТекстУсловияПоДатам;
	
КонецФункции 

Функция ПолучитьТаблицуПродаж(мДатаНачала, мДатаОкончания, мРасчетчик, мОсновнойСклад, МассивТТВкл, МассивТТИскл, ВыводитьТТМиниТТПусто = Ложь, ВыводитьТолькоВВ = Ложь, ВыводитьТолькоПерекрестки = Ложь, ВыводитьТолькоПятерочки = Ложь) Экспорт
	
	ЕстьОтборПоТТВкл 	= (МассивТТВкл.Количество() > 0);
	ЕстьОтборПоТТИскл 	= (МассивТТИскл.Количество() > 0);
	
	МассивНоменклатуры 	= ПолучитьМассивДоступнойНоменклатуры(мРасчетчик);
	//+++АК SHEP 2018.08.02 ИП-00019381
	Если мРасчетчик = Неопределено И ЕстьОтборПоТТВкл Тогда
		МассивТТ = МассивТТВкл;
	ИначеЕсли ТипЗнч(мРасчетчик) = Тип("СправочникСсылка.Номенклатура") И ЕстьОтборПоТТВкл Тогда
		МассивТТ = МассивТТВкл;
		МассивНоменклатуры = ОбщегоНазначенияКлиентСервер.ЗначениеВМассиве(мРасчетчик);
	Иначе
	//---АК SHEP 2018.08.02
	//+++АК MIND 2017.12.07 правлю, чтобы работало хотя бы
	Если ЗначениеЗаполнено(мРасчетчик) Тогда
		МассивТТ 			= ДопМодульСервер.ПолучитьМассивДоступныхТорговыхТочек_ПлюсНеучаст(мРасчетчик.Склад, МассивНоменклатуры);
	Иначе
		МассивТТ = Новый Массив();
	КонецЕсли;	
	КонецЕсли; //+++АК SHEP 2018.08.02 ИП-00019381
	
	// описание служебных переменных
	мТипЧисло = Новый ОписаниеТипов("Число");
	мТипТТМагазин		= Перечисления.ТипыРозничныхТочек.Магазин;
	СпрНоменклатура 	= Справочники.Номенклатура;
	СпрТорговыеТочки 	= Справочники.СтруктурныеЕдиницы;
	мТипТТДляТАВВ		= Перечисления.ТипыТорговыхТочекДляТоварногоАссортимента.ВВ;
	мТипТТПерекресток	= ПредопределенноеЗначение("Перечисление.ТипыРозничныхТочек.Перекресток");
	мТипТТПятерочка		= ПредопределенноеЗначение("Перечисление.ТипыРозничныхТочек.Пятерочка");
	
	ЕстьОсновнойСклад   = ЗначениеЗаполнено(мОсновнойСклад);
	
	СтрокаОтбораТТ			= "(9999999)";
	СтрокаОтбораТТМагазин 	= "(9999999)";
	СтрокаОтбораТТИзбенка 	= "(9999999)";
	Для Каждого ТекТорговаяТочка Из МассивТТ Цикл		
		Если (ЕстьОсновнойСклад
					И НЕ ТекТорговаяТочка.ОсновнойСклад = мОсновнойСклад)
				ИЛИ (ЕстьОтборПоТТВкл
						И МассивТТВкл.Найти(ТекТорговаяТочка) = Неопределено)
				ИЛИ (ЕстьОтборПоТТИскл
						И НЕ МассивТТИскл.Найти(ТекТорговаяТочка) = Неопределено)
				ИЛИ (ВыводитьТТМиниТТПусто
						И ТекТорговаяТочка.ТипТорговойТочкиДляАссортимента = мТипТТДляТАВВ)
				ИЛИ (ВыводитьТолькоВВ
						И НЕ ТекТорговаяТочка.ТипТорговойТочкиДляАссортимента = мТипТТДляТАВВ) 
				ИЛИ (ВыводитьТолькоПерекрестки
						И НЕ ТекТорговаяТочка.ТипРозничнойТочки = мТипТТПерекресток)
				ИЛИ (ВыводитьТолькоПятерочки
						И НЕ ТекТорговаяТочка.ТипРозничнойТочки = мТипТТПятерочка) Тогда
			Продолжить;
		КонецЕсли;
		СтрокаДобавления = ", (" + Формат(ТекТорговаяТочка.id_tt, "ЧГ=0") + ")";
		Если ТекТорговаяТочка.ТипРозничнойТочки = мТипТТМагазин Тогда
			СтрокаОтбораТТМагазин = СтрокаОтбораТТМагазин + СтрокаДобавления;
		Иначе
			СтрокаОтбораТТИзбенка = СтрокаОтбораТТИзбенка + СтрокаДобавления;
		КонецЕсли;	
		СтрокаОтбораТТ = СтрокаОтбораТТ + СтрокаДобавления;
	КонецЦикла;
	
	СтрокаОтбораНоменклатура = "(9999999)";
	//+++АК SHEP 2018.08.02 ИП-00019381: оптимизация
	//Для Каждого ТекНоменклатура Из МассивНоменклатуры Цикл		
	//	СтрокаОтбораНоменклатура = СтрокаОтбораНоменклатура + ", (" + Формат(ТекНоменклатура.id_tov, "ЧГ=0") + ")";
	//КонецЦикла;
	Если МассивНоменклатуры.Количество() > 0 Тогда
		СоответствиеЗначения = ОбщегоНазначения.ЗначениеРеквизитаОбъектов(МассивНоменклатуры, "id_tov");
		Для Каждого КлючИЗначение Из СоответствиеЗначения Цикл
			Если НЕ ЗначениеЗаполнено(КлючИЗначение.Значение) Тогда Продолжить; КонецЕсли;
			СтрокаОтбораНоменклатура = СтрокаОтбораНоменклатура + ", (" + Формат(КлючИЗначение.Значение, "ЧГ=0") + ")";
		КонецЦикла;
	КонецЕсли;
	//---АК SHEP 2018.08.02
	
	//ТекстУсловияПоДатам1 = ПолучитьТекстУсловияПоДатам(мДатаНачала, мДатаОкончания, "ListUcheta.date_ch");
	//ТекстУсловияПоДатам2 = ПолучитьТекстУсловияПоДатам(мДатаНачала, мДатаОкончания, "CheckLine.date_ch");
	ТекстУсловияПоДатам2 = ПолучитьТекстУсловияПоДатам(мДатаНачала, мДатаОкончания, "DTT.date_tt");
	ТекстУсловияПоДатам3 = ПолучитьТекстУсловияПоДатам(мДатаНачала, мДатаОкончания, "LostSales.date_ls");
	ТекстУсловияПоДатам4 = ПолучитьТекстУсловияПоДатам(мДатаНачала, мДатаОкончания, "Sales_.date_tt");
	
	
	// получение таблицы из SQL
	ADOСоединение = Новый COMОбъект("ADODB.Connection");
	ADOСоединение.ConnectionTimeOut = 0;
	ADOСоединение.CommandTimeOut    = 0;
	ADOСоединение.ConnectionString  = ОбменСAccess.ПолучитьСтрокуСоединения("SMS_Izbenka");
	ADOСоединение.Open();
	
	ТекстЗапроса =
	"If OBJECT_ID('tempdb..#dtt') Is Not Null	Drop Table #dtt
	|-----------------------------------------------------------------------------------------------
	|create table #dtt (
	|	id_tt int,
	|	id_tov int,
	|	date_tt datetime,
	|	kol numeric(15, 3),
	|	kol_c numeric(15, 3),
	|	Kol_p numeric(15, 3)) 
    |
	|Insert into #dtt
	|Exec (
	|	'Select
	|		DTT.id_tt,
	|		DTT.id_tov,
	|		DTT.date_tt,
	|		(DTT.quantity - DTT.discount50_qty - DTT.discount50_sms_qty),
	|		(DTT.discount50_qty + DTT.discount50_sms_qty),
	|		0
	|	From vv03..DTT as DTT (nolock) 
    |	Where" + СтрЗаменить(ТекстУсловияПоДатам2, "'", "''") + 
	" 		DTT.id_tov in (" + СтрокаОтбораНоменклатура + ")
	| 		And DTT.id_tt in (" + СтрокаОтбораТТ + ")
	|
	|	Union All
	|
	|	Select
	|		LostSales.id_tt_ls,
	|		LostSales.id_tov_ls,
	|		CONVERT(Date, LostSales.date_ls),
	|		0,
	|		0,
	|		LostSales.lost1
	|	From vv03..Lost_sales as LostSales (nolock)
	|	Where" + СтрЗаменить(ТекстУсловияПоДатам3, "'", "''") +
	" 		LostSales.id_tov_ls in (" + СтрокаОтбораНоменклатура + ")
	| 		And LostSales.id_tt_ls in (" + СтрокаОтбораТТ + ")
	|	')
	|at [SRV-SQL03]
	|-----------------------------------------------------------------------------------------------
	|Select
	|	tabuidytt.UID AS TTUID,
	|	tabuidytov.UID AS TovarUID,
	|	dtt.date_tt AS Day_ch,
	//|	CONVERT(Date, dtt.date_tt) AS Day_ch,
	|	SUM(dtt.kol) as kol,
	|	SUM(dtt.kol_c) as kol_c,
	|	SUM(dtt.Kol_p) as Kol_p
	|From (
	|	Select
	|		dtt.id_tt as id_tt,
	|		dtt.id_tov as id_tov,
	|		dtt.date_tt as date_tt,
	|		dtt.kol as kol,
	|		dtt.kol_c as kol_c,
	|		dtt.Kol_p as Kol_p
	|	From #dtt as dtt
	|
	|	Union All
	|
	|	Select
	|		Sales_.id_tt,
	|		Sales_.id_tov,
	|		Sales_.date_tt,
	|		Sales_.quantity - Sales_.discount50_qty - Sales_.discount50_sms_qty,
	|		Sales_.discount50_qty + Sales_.discount50_sms_qty,
	|		0
	|	From OLAP..DTT_2014 as Sales_ (nolock)
	| 	Where" + ТекстУсловияПоДатам4 +
	" Sales_.id_tov IN (" + СтрокаОтбораНоменклатура + ")
	| 	AND Sales_.id_tt IN (" + СтрокаОтбораТТ + ")
	|
	|	Union All
	|
	|	Select
	|		Sales_.id_tt,
	|		Sales_.id_tov,
	|		Sales_.date_tt,
	|		Sales_.quantity - Sales_.discount50_qty,
	|		Sales_.discount50_qty,
	|		0
	|	From OLAP..DTT_2013 as Sales_ (nolock)
	| 	Where" + ТекстУсловияПоДатам4 +
	" Sales_.id_tov IN (" + СтрокаОтбораНоменклатура + ")
	| 	AND Sales_.id_tt IN (" + СтрокаОтбораТТ + ")
	|
	|	Union All
	|
	|	Select
	|		Sales_.id_tt,
	|		Sales_.id_tov,
	|		Sales_.date_tt,
	|		Sales_.quantity - Sales_.discount50_qty,
	|		Sales_.discount50_qty,
	|		0
	|	From OLAP..DTT_2012 as Sales_ (nolock)
	| 	Where" + ТекстУсловияПоДатам4 +
	" Sales_.id_tov IN (" + СтрокаОтбораНоменклатура + ")
	| 	AND Sales_.id_tt IN (" + СтрокаОтбораТТ + ")
	|		) as dtt
 	| Left Outer Join IzbenkaFin..TTBin2UID as tabuidytt (nolock)
 	| On dtt.id_tt = tabuidytt.id_tt
 	| Left Outer Join IzbenkaFin..ArticleBin2UID as tabuidytov (nolock)
 	| On dtt.id_tov = tabuidytov.id_tov
	|Group By
	|	dtt.date_tt,
//	|	CONVERT(Date, dtt.date_tt),
	|	tabuidytt.UID,
	|	tabuidytov.UID
	|-----------------------------------------------------------------------------------------------
	|Drop Table	#dtt";
	
	Выборка = ADOСоединение.Execute(ТекстЗапроса);
	
	ТабДанные = Новый ТаблицаЗначений;
	ТабДанные.Колонки.Добавить("Дата"				, Новый ОписаниеТипов("Дата"));
	ТабДанные.Колонки.Добавить("ТорговаяТочка"		, Новый ОписаниеТипов("СправочникСсылка.СтруктурныеЕдиницы"));
	ТабДанные.Колонки.Добавить("Номенклатура"		, Новый ОписаниеТипов("СправочникСсылка.Номенклатура"));
	ТабДанные.Колонки.Добавить("Количество"			, мТипЧисло);
	ТабДанные.Колонки.Добавить("Количество_с"		, мТипЧисло);
	ТабДанные.Колонки.Добавить("Количество_п"		, мТипЧисло);
	
	Пока НЕ Выборка = Неопределено Цикл
		Если Выборка.Fields.Count > 0 Тогда
			Пока НЕ Выборка.EOF Цикл
				
				НоваяСтрока = ТабДанные.Добавить();
				НоваяСтрока.Дата 			= Выборка.Fields("Day_ch").Value;
				Если НЕ Выборка.Fields("TovarUID").Value = NULL Тогда
					мУникальныйИД = Новый УникальныйИдентификатор(Сред(Выборка.Fields("TovarUID").Value, 2, 36));
					НоваяСтрока.Номенклатура 	= СпрНоменклатура.ПолучитьСсылку(мУникальныйИД);
				КонецЕсли;
				Если НЕ Выборка.Fields("TTUID").Value = NULL Тогда
					мУникальныйИД = Новый УникальныйИдентификатор(Сред(Выборка.Fields("TTUID").Value, 2, 36));
					НоваяСтрока.ТорговаяТочка 	= СпрТорговыеТочки.ПолучитьСсылку(мУникальныйИД);
				КонецЕсли;
				НоваяСтрока.Количество 		= Выборка.Fields("kol").Value;
				НоваяСтрока.Количество_с 	= Выборка.Fields("kol_c").Value;
				НоваяСтрока.Количество_п 	= Выборка.Fields("kol_p").Value;
				
				Если НЕ Выборка.EOF Тогда
					Выборка.MoveNext();
				КонецЕсли;
				
			КонецЦикла;
		КонецЕсли;
		Выборка = Выборка.NextRecordSet();
	КонецЦикла;
	
	ADOСоединение.Close();		
	
	
	// присоединение поставщика (производителя то есть)
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("ДатаАссортимента"	, КонецДня(ТекущаяДата() + 86400));
	Запрос.УстановитьПараметр("ТабДанные"			, ТабДанные);
	Запрос.УстановитьПараметр("МассивТТ"			, МассивТТ);
	Запрос.УстановитьПараметр("МассивНоменклатуры"	, МассивНоменклатуры);
	
	Запрос.Текст =
	"ВЫБРАТЬ
	|	НАЧАЛОПЕРИОДА(ТабДанные.Дата, ДЕНЬ) КАК Дата,
	|	ТабДанные.Номенклатура КАК Номенклатура,
	|	ТабДанные.ТорговаяТочка КАК ТорговаяТочка,
	|	ТабДанные.Количество КАК Количество,
	|	ТабДанные.Количество_с КАК Количество_с,
	|	ТабДанные.Количество_п КАК Количество_п
	|ПОМЕСТИТЬ ВТДанные
	|ИЗ
	|	&ТабДанные КАК ТабДанные
	|
	|ИНДЕКСИРОВАТЬ ПО
	|	Номенклатура,
	|	ТорговаяТочка
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ТоварныйАссортиментТочек.Номенклатура КАК Номенклатура,
	|	ТоварныйАссортиментТочек.ТорговаяТочка КАК ТорговаяТочка,
	|	ВТПроизводители.Значение КАК Производитель
	|ПОМЕСТИТЬ ВТТоварныйАссортимент
	|ИЗ
	|	РегистрСведений.ТоварныйАссортиментТочек.СрезПоследних(
	|			&ДатаАссортимента,
	|			Номенклатура В (&МассивНоменклатуры)
	|				И ТорговаяТочка В (&МассивТТ)) КАК ТоварныйАссортиментТочек
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ РегистрСведений.ЗначенияСвойствОбъектов КАК ВТПроизводители
	|		ПО (ВТПроизводители.Свойство = ЗНАЧЕНИЕ(ПланВидовХарактеристик.СвойстваОбъектов.Производитель))
	|			И (ВТПроизводители.Объект = ТоварныйАссортиментТочек.Характеристика)
	|ГДЕ
	|	НЕ ТоварныйАссортиментТочек.Выведена
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ВТДанные.Дата КАК Дата,
	|	ВТДанные.Номенклатура КАК Номенклатура,
	|	ЕСТЬNULL(ТоварныйАссортиментТочек.Производитель, ЗНАЧЕНИЕ(Справочник.Контрагенты.ПустаяСсылка)) КАК Поставщик,
	|	ВТДанные.ТорговаяТочка КАК ТорговаяТочка,
	|	ВТДанные.Количество КАК Количество_пр,
	|	ВТДанные.Количество_с КАК Количество_с,
	|	ВТДанные.Количество_п КАК Количество_пот
	|ИЗ
	|	ВТДанные КАК ВТДанные
	|		ЛЕВОЕ СОЕДИНЕНИЕ ВТТоварныйАссортимент КАК ТоварныйАссортиментТочек
	|		ПО (ТоварныйАссортиментТочек.ТорговаяТочка = ВТДанные.ТорговаяТочка)
	|			И (ТоварныйАссортиментТочек.Номенклатура = ВТДанные.Номенклатура)
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|УНИЧТОЖИТЬ ВТДанные
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|УНИЧТОЖИТЬ ВТТоварныйАссортимент";
	
	Возврат Запрос.Выполнить().Выгрузить();
	
КонецФункции

//+++АК MIND 2017.12.07 
Функция ПолучитьТаблицуДегустаций(мДатаНачала, мДатаОкончания, МассивТТВкл, МассивТТИскл) Экспорт
	
	ТабДанные = Новый ТаблицаЗначений();
	ТабДанные.Колонки.Добавить("Номенклатура");
	ТабДанные.Колонки.Добавить("Поставщик");
	ТабДанные.Колонки.Добавить("ТорговаяТочка");
	ТабДанные.Колонки.Добавить("Дата");
	ТабДанные.Колонки.Добавить("Количество_пр");
	ТабДанные.Колонки.Добавить("Сумма");
	
	ЗапросКешДанные = Новый Запрос();
	ЗапросКешДанные.Текст = "ВЫБРАТЬ
	                        |	СтруктурныеЕдиницы.Ссылка,
	                        |	СтруктурныеЕдиницы.НомерТочки
	                        |ИЗ
	                        |	Справочник.СтруктурныеЕдиницы КАК СтруктурныеЕдиницы
	                        |;
	                        |
	                        |////////////////////////////////////////////////////////////////////////////////
	                        |ВЫБРАТЬ
	                        |	Контрагенты.Ссылка,
	                        |	Контрагенты.ИД
	                        |ИЗ
	                        |	Справочник.Контрагенты КАК Контрагенты
	                        |ГДЕ
	                        |	Контрагенты.ЭтоГруппа = ЛОЖЬ";
	
	Результаты = ЗапросКешДанные.ВыполнитьПакет();
	ТабКешТТ = Результаты[0].Выгрузить();
	ТабКешТТ.Индексы.Добавить("Ссылка");
	ТабКешКонтрагенты = Результаты[1].Выгрузить();
	ТабКешКонтрагенты.Индексы.Добавить("ИД");
	
	СтрокаОтборТТ = "";
	Для Каждого ЭлементМассивТТ Из МассивТТВкл Цикл
		СтрокаКеш = ТабКешТТ.Найти(ЭлементМассивТТ, "Ссылка");
		Если СтрокаКеш <> Неопределено Тогда
			СтрокаОтборТТ = СтрокаОтборТТ + ?(ЗначениеЗаполнено(СтрокаОтборТТ), ",", "") + Формат(СтрокаКеш.НомерТочки, "ЧГ=0");
		КонецЕсли;	
	КонецЦикла;
	
	СтрокаОтборТТИсключить = "";
	Для Каждого ЭлементМассивТТ Из МассивТТИскл Цикл
		СтрокаКеш = ТабКешТТ.Найти(ЭлементМассивТТ, "Ссылка");
		Если СтрокаКеш <> Неопределено Тогда
			СтрокаОтборТТИсключить = СтрокаОтборТТИсключить + ?(ЗначениеЗаполнено(СтрокаОтборТТИсключить), ",", "") + Формат(СтрокаКеш.НомерТочки, "ЧГ=0");
		КонецЕсли;	
	КонецЦикла;
	
	ADOСоединение = ВнешниеДанныеКлиентСервер.ПолучитьADOСоединение();
	
	ТекстЗапроса = "
	|/*** Себестоимость ***/
	|SELECT DATEADD(YEAR, -2000, RegSebestoimost._Period) as Period
	|      ,Tovari._Fld760 as Tovar_Id
	|      ,RegSebestoimost._Fld3772 as Sebestoimost
	|into #sb
	|  FROM IzbenkaFin.dbo._InfoRg3770 as RegSebestoimost (nolock)
	|  INNER JOIN IzbenkaFin.dbo._Reference29 as Tovari (nolock)
	|  ON RegSebestoimost._Fld3771RRef = Tovari._IDRRef
	|where RegSebestoimost._Period BETWEEN DATEADD(YEAR, 2000, " + ВнешниеДанные.ФорматПоля(НачалоМесяца(мДатаНачала)) + ") AND DATEADD(YEAR, 2000, " + ВнешниеДанные.ФорматПоля(мДатаОкончания) + ")
 	|
	|SELECT CAST(master.dbo.Binary2UID(UINTT._IdRRef) as nvarchar(36)) TTUID, CAST(convert(date, td.closedate) as datetime) closedate, UINTov._Fld4946 as TovarUID, id_kontr
	|, SUM(td.Quantity*tpo.znak) AS Quantity,
	|SUM(td.Quantity*sb.sebestoimost*tpo.znak) AS summa
	|
	|FROM         SMS_REPL.dbo.TD_move AS td WITH (nolock) 
	|	left join #sb sb on (sb.Tovar_Id = td.id_tov) and (month(sb.Period) = month(td.closedate)) and (year(sb.Period) = year(td.closedate))
	|   INNER JOIN    SMS_REPL.dbo.Types_Operation AS tpo WITH (nolock) ON td.operation_type = tpo.code_operation 
	|    AND tpo.field_operation = 'operation_type_orig' AND tpo.table_operation = 'TD_move' 
	|            left join SMS_REPL..Types_Operation  as tpor with(nolock)
	|            on tpor.code_operation=td.id_reason  and tpor.field_operation='id_reason'          
	|            INNER JOIN    M2.dbo.Tovari AS tov ON td.id_tov = tov.id_tov
	|            left join M2..tt (nolock) tt on tt.n = td.ShopNo_rep
	|LEFT OUTER JOIN IzbenkaFin.dbo._Reference42 UINTT (nolock) ON td.ShopNo_rep = UINTT._Fld2756
	|LEFT OUTER JOIN IzbenkaFin.dbo._InfoRg4943 UINTov (nolock) ON td.id_tov = UINTov._Fld4953 and UINTov._Fld4944_TYPE = 0x08 and UINTov._Fld4944_RTRef = 0x0000001D
	|            
	|WHERE     (td.Confirm_type = 1) AND (td.operation_type IN (101, 111))
	|and td.closedate BETWEEN " + ВнешниеДанные.ФорматПоля(НачалоДня(мДатаНачала)) + " AND " + ВнешниеДанные.ФорматПоля(КонецДня(мДатаОкончания)) + "
	|	" + ?(ЗначениеЗаполнено(СтрокаОтборТТ), " and td.ShopNo_rep IN (" + СтрокаОтборТТ + ")", "") + "
	|	" + ?(ЗначениеЗаполнено(СтрокаОтборТТИсключить), " and not td.ShopNo_rep IN (" + СтрокаОтборТТИсключить + ")", "") + "
	|GROUP BY CAST(master.dbo.Binary2UID(UINTT._IdRRef) as nvarchar(36)), CAST(convert(date, td.closedate) as datetime), UINTov._Fld4946, id_kontr
	|HAVING      (SUM(td.Quantity) <> 0)
	|
	|UNION ALL
	|SELECT CAST(master.dbo.Binary2UID(UINTT._IdRRef) as nvarchar(36)) TTUID, CAST(convert(date, Ch.closedate) as datetime) closedate
	|  , UINTov._Fld4946 as TovarUID, Chl.id_kontr, SUM(Chl.Quantity * CASE WHEN Ch.OperationType = 3 THEN -1 ELSE 1 END) AS Quantity,
	|SUM(Chl.Quantity * CASE WHEN Ch.OperationType = 3 THEN -1 ELSE 1 END) AS summa
	|FROM [SMS_UNION].[dbo].[Checks] as Ch (nolock)
	|LEFT OUTER JOIN [SMS_UNION].[dbo].[CheckLine] as Chl (nolock)
	|ON Ch.CheckUID = Chl.CheckUID
	|	left join #sb sb on (sb.Tovar_Id = Chl.id_tov_cl) and (month(sb.Period) = month(Chl.date_ch)) and (year(sb.Period) = year(Chl.date_ch))
	|LEFT OUTER JOIN IzbenkaFin.dbo._Reference42 UINTT (nolock) ON Ch.ShopNo = UINTT._Fld2756
	|LEFT OUTER JOIN IzbenkaFin.dbo._InfoRg4943 UINTov (nolock) ON chl.id_tov_cl = UINTov._Fld4953 and UINTov._Fld4944_TYPE = 0x08 and UINTov._Fld4944_RTRef = 0x0000001D
	|where CloseDate Between " + ВнешниеДанные.ФорматПоля(НачалоДня(мДатаНачала)) + " AND " + ВнешниеДанные.ФорматПоля(КонецДня(мДатаОкончания)) + " and BONUSCARD = '4806534'
	|GROUP BY
	|CAST(master.dbo.Binary2UID(UINTT._IdRRef) as nvarchar(36)), CAST(convert(date, Ch.closedate) as datetime)
	|  , UINTov._Fld4946, Chl.id_kontr";
	
	rs = ADOСоединение.Execute(ТекстЗапроса);
	Пока rs <> Неопределено И rs.Fields.Count <= 0 Цикл
		rs=rs.NextRecordSet();
	КонецЦикла;
	
	Попытка
		rs.MoveFirst();
		
		Пока НЕ rs.EOF() Цикл
			СтрокаДоб = ТабДанные.Добавить();
			Если Rs.Fields("TovarUID").Value <> NULL Тогда
				СтрокаДоб.Номенклатура = Справочники.Номенклатура.ПолучитьСсылку(Новый УникальныйИдентификатор(Rs.Fields("TovarUID").Value));
			КонецЕсли;
			Если Rs.Fields("TTUID").Value <> NULL Тогда
				СтрокаДоб.ТорговаяТочка = Справочники.СтруктурныеЕдиницы.ПолучитьСсылку(Новый УникальныйИдентификатор(Rs.Fields("TTUID").Value));
			КонецЕсли;
			СтрокаДоб.Дата = Rs.Fields("closedate").Value;
			СтрокаДоб.Количество_пр = Rs.Fields("Quantity").Value * (-1);
			СтрокаДоб.Сумма = Rs.Fields("summa").Value * (-1);
			ИДКонтрагент = Rs.Fields("id_kontr").Value;
			Если ЗначениеЗаполнено(ИДКонтрагент) Тогда
				СтрокаПоставщик = ТабКешКонтрагенты.Найти(ИДКонтрагент, "ИД");
				Если СтрокаПоставщик <> Неопределено Тогда
					СтрокаДоб.Поставщик = СтрокаПоставщик.Ссылка;
				КонецЕсли;	
			КонецЕсли;	
			rs.MoveNext();
		КонецЦикла;
	Исключение
	КонецПопытки;
	ADOСоединение.Close();
	ADOСоединение = Неопределено;		
	
	
	Возврат ТабДанные;
	
КонецФункции
//---АК MIND 