﻿
Функция ПолучитьДанныеДляФормирования(мДатаРаспределения, мРасчетчик, мСклад, мПоставщик, ДнейПродажВГруппировке, ГлубинаАнализаПродаж,
										ВыводитьТТМиниТТПусто = Ложь, ВыводитьТолькоВВ = Ложь, ИспользоватьНормативныйКвантДляРасчетаПлановогоОстатка = Истина) Экспорт
		
	ИспользоватьНормативныйКвантДляРасчетаПлановогоОстатка = Истина;
	
	мТипЧисло = Новый ОписаниеТипов("Число", Новый КвалификаторыЧисла(12, 3));
	
	ТекстДаты 			= "'4" + Сред(СтрЗаменить(Формат(мДатаРаспределения, "ДФ=""гггг ММ дд"""), " ", ""), 2) + "'";
	ТекстДатыНеделя     = "'4" + Сред(СтрЗаменить(Формат(НачалоНедели(мДатаРаспределения), "ДФ=""гггг ММ дд"""), " ", ""), 2) + "'";
	ТекстУИДРасчетчик 	= "'" + Строка(мРасчетчик.УникальныйИдентификатор()) 	+ "'";
	ТекстУИДСклад 		= "'" + Строка(мСклад.УникальныйИдентификатор()) 		+ "'";
	
	МассивНоменклатуры 	= ПолучитьМассивДоступнойНоменклатуры(мРасчетчик);
	
	Если ЗначениеЗаполнено(мРасчетчик) Тогда
		МассивТТ = ДопМодульСервер.ПолучитьМассивДоступныхТорговыхТочек_ПлюсНеучаст(мРасчетчик.Склад, МассивНоменклатуры);
	Иначе
		МассивТТ = Новый Массив();
	КонецЕсли;	
	
	Если ЗначениеЗаполнено(мПоставщик) Тогда
		ИДКонтрагента = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(мПоставщик, "ИД");
		ИДКонтрагента = Формат(ИДКонтрагента, "ЧГ=0");
	Иначе	
		ИДКонтрагента = "";
	КонецЕсли;
	
	// описание служебных переменных
	мТипЧисло = Новый ОписаниеТипов("Число");
	мТипТТМагазин		= Перечисления.ТипыРозничныхТочек.Магазин;
	СпрНоменклатура 	= Справочники.Номенклатура;
	СпрТорговыеТочки 	= Справочники.СтруктурныеЕдиницы;
	мТипТТДляТАВВ		= Перечисления.ТипыТорговыхТочекДляТоварногоАссортимента.ВВ;
	
	ЕстьОсновнойСклад   = Ложь;
	
	СтрокаОтбораТТ			= "(9999999)";
	СтрокаОтбораТТМагазин 	= "(9999999)";
	СтрокаОтбораТТИзбенка 	= "(9999999)";
	Для Каждого ТекТорговаяТочка Из МассивТТ Цикл		
		СтрокаДобавления = ", (" + Формат(ТекТорговаяТочка.id_tt, "ЧГ=0") + ")";
		Если ТекТорговаяТочка.ТипРозничнойТочки = мТипТТМагазин Тогда
			СтрокаОтбораТТМагазин = СтрокаОтбораТТМагазин + СтрокаДобавления;
		Иначе
			СтрокаОтбораТТИзбенка = СтрокаОтбораТТИзбенка + СтрокаДобавления;
		КонецЕсли;	
		СтрокаОтбораТТ = СтрокаОтбораТТ + СтрокаДобавления;
	КонецЦикла;
	
	КолПериодов = ?(ДнейПродажВГруппировке > 0, Окр(ГлубинаАнализаПродаж / ДнейПродажВГруппировке), 0);
	Если КолПериодов = 0 Тогда
		КолПериодов = 1;
	КонецЕсли;
		
	ТекстКолПериодов 	= Формат(КолПериодов, "ЧГ=");
	ТекстГлубинаПродаж = Формат(ГлубинаАнализаПродаж, "ЧГ=");	
	
	ТаблицаДанные = Новый ТаблицаЗначений;
	
	ТаблицаДанные.Колонки.Добавить("КоличествоПродаж1"		, мТипЧисло);
	ТаблицаДанные.Колонки.Добавить("КоличествоПродаж2"		, мТипЧисло);
	ТаблицаДанные.Колонки.Добавить("КоличествоПродаж3"		, мТипЧисло);
	ТаблицаДанные.Колонки.Добавить("КоличествоПродаж4"		, мТипЧисло);
	ТаблицаДанные.Колонки.Добавить("КоличествоПродаж5"		, мТипЧисло);
	ТаблицаДанные.Колонки.Добавить("КоличествоПродаж6"		, мТипЧисло);
	ТаблицаДанные.Колонки.Добавить("КоличествоПродаж7"		, мТипЧисло);
	
	ТаблицаДанные.Колонки.Добавить("КоличествоПродажВ1"		, мТипЧисло);
	ТаблицаДанные.Колонки.Добавить("КоличествоПродажВ2"		, мТипЧисло);
	ТаблицаДанные.Колонки.Добавить("КоличествоПродажВ3"		, мТипЧисло);
	ТаблицаДанные.Колонки.Добавить("КоличествоПродажВ4"		, мТипЧисло);
	ТаблицаДанные.Колонки.Добавить("КоличествоПродажВ5"		, мТипЧисло);
	ТаблицаДанные.Колонки.Добавить("КоличествоПродажВ6"		, мТипЧисло);
	ТаблицаДанные.Колонки.Добавить("КоличествоПродажВ7"		, мТипЧисло);
	
	ТаблицаДанные.Колонки.Добавить("КоличествоПродажВ21"	, мТипЧисло);
	ТаблицаДанные.Колонки.Добавить("КоличествоПродажВ22"	, мТипЧисло);
	ТаблицаДанные.Колонки.Добавить("КоличествоПродажВ23"	, мТипЧисло);
	ТаблицаДанные.Колонки.Добавить("КоличествоПродажВ24"	, мТипЧисло);
	ТаблицаДанные.Колонки.Добавить("КоличествоПродажВ25"	, мТипЧисло);
	ТаблицаДанные.Колонки.Добавить("КоличествоПродажВ26"	, мТипЧисло);
	ТаблицаДанные.Колонки.Добавить("КоличествоПродажВ27"	, мТипЧисло);
	
	ТаблицаДанные.Колонки.Добавить("Поставщик"				, Новый ОписаниеТипов("СправочникСсылка.Контрагенты"));
	ТаблицаДанные.Колонки.Добавить("ТорговаяТочка"			, Новый ОписаниеТипов("СправочникСсылка.СтруктурныеЕдиницы"));
	ТаблицаДанные.Колонки.Добавить("Номенклатура"			, Новый ОписаниеТипов("СправочникСсылка.Номенклатура"));
	ТаблицаДанные.Колонки.Добавить("МинимальныйОстаток"		, мТипЧисло);
	ТаблицаДанные.Колонки.Добавить("ФактическийОстаток"		, мТипЧисло);
	ТаблицаДанные.Колонки.Добавить("Распределено"			, мТипЧисло);
	ТаблицаДанные.Колонки.Добавить("КоличествоПланПродаж"	, мТипЧисло);
	
	ТаблицаДанные.Колонки.Добавить("КоличествоЗаказ"		, мТипЧисло);
	ТаблицаДанные.Колонки.Добавить("КоличествоЗаказ2"		, мТипЧисло);
	ТаблицаДанные.Колонки.Добавить("КоличествоЗаказ3"		, мТипЧисло);
	ТаблицаДанные.Колонки.Добавить("КоличествоЗаказ4"		, мТипЧисло);
	ТаблицаДанные.Колонки.Добавить("КоличествоЗаказ5"		, мТипЧисло);
	ТаблицаДанные.Колонки.Добавить("КоличествоЗаказ6"		, мТипЧисло);
	
	ТаблицаДанные.Колонки.Добавить("КоличествоЗаказ_"		, мТипЧисло);	
	ТаблицаДанные.Колонки.Добавить("КоличествоЗаказ2_"		, мТипЧисло);	
	ТаблицаДанные.Колонки.Добавить("КоличествоЗаказ3_"		, мТипЧисло);	
	ТаблицаДанные.Колонки.Добавить("КоличествоЗаказ4_"		, мТипЧисло);	
	ТаблицаДанные.Колонки.Добавить("КоличествоЗаказ5_"		, мТипЧисло);	
	ТаблицаДанные.Колонки.Добавить("КоличествоЗаказ6_"		, мТипЧисло);
				
	ТаблицаДанные.Колонки.Добавить("ПлановыйОстатокРасчетный"		, мТипЧисло);
	ТаблицаДанные.Колонки.Добавить("ПлановыйОстатокУРЗ"				, мТипЧисло);             
	ТаблицаДанные.Колонки.Добавить("ПлановыйОстатокНаКонецДня"		, мТипЧисло);
	ТаблицаДанные.Колонки.Добавить("ПлановыйОстатокПередСледЗаказом", мТипЧисло);
	ТаблицаДанные.Колонки.Добавить("ФактПродаж"								, мТипЧисло);
	ТаблицаДанные.Колонки.Добавить("ОстатокПослеРаспределения"				, мТипЧисло);
	ТаблицаДанные.Колонки.Добавить("ПлановыйОстатокПередСледНеразмЗаказом"	, мТипЧисло);
	ТаблицаДанные.Колонки.Добавить("КоличествоТТСОграничением05"			, мТипЧисло);
	ТаблицаДанные.Колонки.Добавить("ПлановыйОстатокДняРазмещения"			, мТипЧисло);
	ТаблицаДанные.Колонки.Добавить("ФактПродажДнейРазмещения"				, мТипЧисло);
	
	ТаблицаДанные.Колонки.Добавить("КоличествоДнейРазмещения"				, мТипЧисло);
	ТаблицаДанные.Колонки.Добавить("ФактНеРазмещения"						, мТипЧисло);
	ТаблицаДанные.Колонки.Добавить("РазмещенныеПослеРаспределения"			, мТипЧисло);
	
	ТаблицаДанные.Колонки.Добавить("ФактПродажДнейПоНеразмещеннымЗаказам"	, мТипЧисло);
	ТаблицаДанные.Колонки.Добавить("НеразмещенныеЗаказыНаДату"				, мТипЧисло);
	
	ТаблицаДанные.Колонки.Добавить("ПродажаПредНедели"						, мТипЧисло);
	
	ТаблицаДанные.Колонки.Добавить("ЧислоДнейЗапаса"						, мТипЧисло);
	ТаблицаДанные.Колонки.Добавить("КоэффициентПлановогоРасчетногоОстатка"	, мТипЧисло);
	ТаблицаДанные.Колонки.Добавить("КоличествоВУпаковке"					, мТипЧисло);
	
	ADOСоединение = Новый COMОбъект("ADODB.Connection");
	ADOСоединение.ConnectionTimeOut = 0;
	ADOСоединение.CommandTimeOut    = 0;
	ADOСоединение.ConnectionString  = ОбменСAccess.ПолучитьСтрокуСоединения("SMS_Izbenka");
	ADOСоединение.Open();
	
	ТекстЗапроса =
	"exec Reports.dbo.FOR1C_Order_Provider3
	  |@UID_Raschetchik = " + ТекстУИДРасчетчик + "
	  |,@UID_Sklad  = " + ТекстУИДСклад+ "
	  |,@DateRaspr  = " + ТекстДаты + "
	  |,@DateRasprDW  = " + ТекстДатыНеделя + "
	  |,@GlubinaProdaj = " + ТекстГлубинаПродаж + "
	  |,@KolPeriodov = " + ТекстКолПериодов + "
	  |,@id_kontr  = '" + ИДКонтрагента + "'
	  |
	  |  select *
	  |  from ##FOR1C_Order_Provider3";
		
	//Сообщить(ТекстЗапроса);
	Выборка = ADOСоединение.Execute(ТекстЗапроса);
		
	СпрКонтрагенты 		= Справочники.Контрагенты;
	СпрНоменклатура 	= Справочники.Номенклатура;
	СпрТорговыеТочки 	= Справочники.СтруктурныеЕдиницы;
	Пока НЕ Выборка = Неопределено Цикл
		Если Выборка.Fields.Count > 0 Тогда
			Пока НЕ Выборка.EOF Цикл
				
				НоваяСтрока = ТаблицаДанные.Добавить();
				Попытка
					НоваяСтрока.Поставщик 	= СпрКонтрагенты.ПолучитьСсылку(Новый УникальныйИдентификатор(Выборка.Fields("kontr").Value));
				Исключение
				КонецПопытки;
				НоваяСтрока.Номенклатура 	= СпрНоменклатура.ПолучитьСсылку(Новый УникальныйИдентификатор(Выборка.Fields("tov").Value));
				НоваяСтрока.ТорговаяТочка	= СпрТорговыеТочки.ПолучитьСсылку(Новый УникальныйИдентификатор(Выборка.Fields("tt").Value));
				
				НоваяСтрока.МинимальныйОстаток		= Выборка.Fields("Min_Ostatok").Value;
				НоваяСтрока.ФактическийОстаток		= Выборка.Fields("Fact_Ostatok").Value;
				НоваяСтрока.Распределено			= Выборка.Fields("Raspredeleno").Value;
				НоваяСтрока.КоличествоПланПродаж	= Выборка.Fields("Plan_Prodaj").Value;
				НоваяСтрока.КоличествоЗаказ			= Выборка.Fields("Kol_Zakaz").Value;
				НоваяСтрока.КоличествоЗаказ_		= Выборка.Fields("Kol_Zakaz_").Value;
				НоваяСтрока.КоличествоЗаказ2		= Выборка.Fields("Kol_Zakaz2").Value;
				НоваяСтрока.КоличествоЗаказ2_		= Выборка.Fields("Kol_Zakaz2_").Value;
				НоваяСтрока.КоличествоЗаказ3		= Выборка.Fields("Kol_Zakaz3").Value;
				НоваяСтрока.КоличествоЗаказ3_		= Выборка.Fields("Kol_Zakaz3_").Value;
				НоваяСтрока.КоличествоЗаказ4		= Выборка.Fields("Kol_Zakaz4").Value;
				НоваяСтрока.КоличествоЗаказ4_		= Выборка.Fields("Kol_Zakaz4_").Value;
				НоваяСтрока.КоличествоЗаказ5		= Выборка.Fields("Kol_Zakaz5").Value;
				НоваяСтрока.КоличествоЗаказ5_		= Выборка.Fields("Kol_Zakaz5_").Value;
				НоваяСтрока.КоличествоЗаказ6		= Выборка.Fields("Kol_Zakaz6").Value;
				НоваяСтрока.КоличествоЗаказ6_		= Выборка.Fields("Kol_Zakaz6_").Value;
											
				НоваяСтрока.КоличествоПродаж1			= Выборка.Fields("Kol_Fact_Prodaj").Value;
				НоваяСтрока.КоличествоПродаж2			= Выборка.Fields("Kol_Fact_Prodaj2").Value;
				НоваяСтрока.КоличествоПродаж3			= Выборка.Fields("Kol_Fact_Prodaj3").Value;
				НоваяСтрока.КоличествоПродаж4			= Выборка.Fields("Kol_Fact_Prodaj4").Value;
				НоваяСтрока.КоличествоПродаж5			= Выборка.Fields("Kol_Fact_Prodaj5").Value;
				НоваяСтрока.КоличествоПродаж6			= Выборка.Fields("Kol_Fact_Prodaj6").Value;
				НоваяСтрока.КоличествоПродаж7			= Выборка.Fields("Kol_Fact_Prodaj7").Value;
				
				НоваяСтрока.КоличествоПродажВ1			= Выборка.Fields("Kol_Fact_ProdajW").Value;
				НоваяСтрока.КоличествоПродажВ2			= Выборка.Fields("Kol_Fact_Prodaj2W").Value;
				НоваяСтрока.КоличествоПродажВ3			= Выборка.Fields("Kol_Fact_Prodaj3W").Value;
				НоваяСтрока.КоличествоПродажВ4			= Выборка.Fields("Kol_Fact_Prodaj4W").Value;
				НоваяСтрока.КоличествоПродажВ5			= Выборка.Fields("Kol_Fact_Prodaj5W").Value;
				НоваяСтрока.КоличествоПродажВ6			= Выборка.Fields("Kol_Fact_Prodaj6W").Value;
				НоваяСтрока.КоличествоПродажВ7			= Выборка.Fields("Kol_Fact_Prodaj7W").Value;
				
				НоваяСтрока.ПродажаПредНедели			= НоваяСтрока.КоличествоПродажВ1 + НоваяСтрока.КоличествоПродажВ2 + НоваяСтрока.КоличествоПродажВ3 + НоваяСтрока.КоличествоПродажВ4 + НоваяСтрока.КоличествоПродажВ5 + НоваяСтрока.КоличествоПродажВ6 + НоваяСтрока.КоличествоПродажВ7;
				
				НоваяСтрока.КоличествоПродажВ21			= Выборка.Fields("Kol_Fact_ProdajW2").Value;
				НоваяСтрока.КоличествоПродажВ22			= Выборка.Fields("Kol_Fact_Prodaj2W2").Value;
				НоваяСтрока.КоличествоПродажВ23			= Выборка.Fields("Kol_Fact_Prodaj3W2").Value;
				НоваяСтрока.КоличествоПродажВ24			= Выборка.Fields("Kol_Fact_Prodaj4W2").Value;
				НоваяСтрока.КоличествоПродажВ25			= Выборка.Fields("Kol_Fact_Prodaj5W2").Value;
				НоваяСтрока.КоличествоПродажВ26			= Выборка.Fields("Kol_Fact_Prodaj6W2").Value;
				НоваяСтрока.КоличествоПродажВ27			= Выборка.Fields("Kol_Fact_Prodaj7W2").Value;
					
				НоваяСтрока.КоличествоДнейРазмещения	=  ?(НоваяСтрока.КоличествоЗаказ > 0, 1, 0)  
				+ ?(НоваяСтрока.КоличествоЗаказ2 > 0, 1, 0)
				+ ?(НоваяСтрока.КоличествоЗаказ3 > 0, 1, 0)
				+ ?(НоваяСтрока.КоличествоЗаказ4 > 0, 1, 0)
				+ ?(НоваяСтрока.КоличествоЗаказ5 > 0, 1, 0)
				+ ?(НоваяСтрока.КоличествоЗаказ6 > 0, 1, 0);											

				НоваяСтрока.ПлановыйОстатокУРЗ			= Выборка.Fields("PlanOst_URZ").Value;
				НоваяСтрока.ПлановыйОстатокНаКонецДня	= Выборка.Fields("Plan_Konec_Dnya").Value;
				НоваяСтрока.ПлановыйОстатокПередСледЗаказом	= 0;//Выборка.Fields("Ost_Pered_Sled_Zakazom").Value; 
				Если КолПериодов = 1 Тогда
					Выполнить("НоваяСтрока.ФактПродаж = НоваяСтрока.КоличествоПродажВ" + ДеньНедели(мДатаРаспределения));
				Иначе
					Выполнить("НоваяСтрока.ФактПродаж = НоваяСтрока.КоличествоПродажВ" + ДеньНедели(мДатаРаспределения) + " + НоваяСтрока.КоличествоПродажВ2" + ДеньНедели(мДатаРаспределения));
				КонецЕсли;	
				НоваяСтрока.ФактПродаж = НоваяСтрока.ФактПродаж * 0.95 / КолПериодов;
				
				НоваяСтрока.ОстатокПослеРаспределения		= Выборка.Fields("Ost_Sklad").Value;
				НоваяСтрока.ПлановыйОстатокПередСледНеразмЗаказом	= Выборка.Fields("Plan_Ost_Do_Razm").Value;
				НоваяСтрока.КоличествоТТСОграничением05				= Выборка.Fields("KolTTWith05").Value;
				НоваяСтрока.ПлановыйОстатокДняРазмещения			= Выборка.Fields("Plan_Ost_Razm").Value;
				НоваяСтрока.ФактПродажДнейРазмещения				= Выборка.Fields("Fact_Razm").Value;
				НоваяСтрока.ФактПродажДнейПоНеразмещеннымЗаказам	= Выборка.Fields("Fact_NeRazm").Value;
				
				Если НЕ Выборка.EOF Тогда
					Выборка.MoveNext();
				КонецЕсли;
			КонецЦикла;
		КонецЕсли;
		Выборка = Выборка.NextRecordSet();
	КонецЦикла;
	
	ADOСоединение.Close();		
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ РАЗРЕШЕННЫЕ
		|	ГрафикиПоставкиТовараТовары.Ссылка,
		|	ГрафикиПоставкиТовараТовары.Номенклатура
		|ПОМЕСТИТЬ втНоменклатура
		|ИЗ
		|	Справочник.ГрафикиПоставкиТовара.Товары КАК ГрафикиПоставкиТовараТовары
		|ГДЕ
		|	ГрафикиПоставкиТовараТовары.Ссылка.СтруктурноеПодразделение = &СтруктурноеПодразделение
		|	И ГрафикиПоставкиТовараТовары.Ссылка.Расчетчик = &Расчетчик
		|	И ГрафикиПоставкиТовараТовары.Ссылка.ПометкаУдаления = ЛОЖЬ
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ РАЗРЕШЕННЫЕ
		|	ГрафикиПоставкиТовараГрафик.ДеньЗаказа,
		|	ГрафикиПоставкиТовараГрафик.ДеньПоставки КАК ДеньПоставки,
		|	ГрафикиПоставкиТовараГрафик.Ссылка,
		|	ГрафикиПоставкиТовараГрафик.КоличествоНедель
		|ПОМЕСТИТЬ втГрафики
		|ИЗ
		|	Справочник.ГрафикиПоставкиТовара.График КАК ГрафикиПоставкиТовараГрафик
		|ГДЕ
		|	ГрафикиПоставкиТовараГрафик.Ссылка.СтруктурноеПодразделение = &СтруктурноеПодразделение
		|	И ГрафикиПоставкиТовараГрафик.Ссылка.Расчетчик = &Расчетчик
		|	И ГрафикиПоставкиТовараГрафик.Ссылка.ПометкаУдаления = ЛОЖЬ
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	втНоменклатура.Номенклатура КАК Номенклатура,
		|	втГрафики.ДеньЗаказа.Порядок + 1 КАК ДеньЗаказа,
		|	втГрафики.ДеньПоставки.Порядок + 1 КАК ДеньПоставки,
		|	ДЕНЬНЕДЕЛИ(&ДеньРасчёта) КАК ДеньРасчёта,
		|	втНоменклатура.Ссылка.СтруктурноеПодразделение КАК ТорговаяТочка,
		|	втНоменклатура.Ссылка.Владелец КАК Поставщик,
		|	втГрафики.КоличествоНедель,
		|	втГрафики.Ссылка
		|ИЗ
		|	втНоменклатура КАК втНоменклатура
		|		ЛЕВОЕ СОЕДИНЕНИЕ втГрафики КАК втГрафики
		|		ПО втНоменклатура.Ссылка = втГрафики.Ссылка
		|ГДЕ
		|	НЕ втГрафики.Ссылка ЕСТЬ NULL
		|
		|СГРУППИРОВАТЬ ПО
		|	втНоменклатура.Номенклатура,
		|	втНоменклатура.Ссылка.Владелец,
		|	втНоменклатура.Ссылка.СтруктурноеПодразделение,
		|	втГрафики.КоличествоНедель,
		|	втГрафики.ДеньЗаказа.Порядок + 1,
		|	втГрафики.ДеньПоставки.Порядок + 1,
		|	втГрафики.Ссылка
		|
		|УПОРЯДОЧИТЬ ПО
		|	Поставщик,
		|	Номенклатура,
		|	ДеньПоставки
		|ИТОГИ ПО
		|	Поставщик,
		|	Номенклатура";
	
	Запрос.УстановитьПараметр("ДеньРасчёта", мДатаРаспределения);
	Запрос.УстановитьПараметр("Расчетчик", мРасчетчик);
	Запрос.УстановитьПараметр("СтруктурноеПодразделение", мСклад);
	
	РезультатЗапроса = Запрос.Выполнить();
	                                                                                                   	
	ВыборкаПоставщик = РезультатЗапроса.Выбрать(ОбходРезультатаЗапроса.ПоГруппировкам, "Поставщик");

	НачальнаяКолонкаКоличества = 8;
	НачальнаяКолонкаЗаказа	   = 29;
	ДеньРаспределения = ДеньНедели(мДатаРаспределения);
	
	ТЗНоменклатура = Новый ТаблицаЗначений;
	ТЗНоменклатура.Колонки.Добавить("Номенклатура");
	ТЗНоменклатура.Колонки.Добавить("КоличествоПродажВ");
	ТЗНоменклатура.Колонки.Добавить("КоличествоПродаж2В");
	ТЗНоменклатура.Колонки.Добавить("КоличествоПродаж3В");
	ТЗНоменклатура.Колонки.Добавить("КоличествоПродаж4В");
	ТЗНоменклатура.Колонки.Добавить("КоличествоПродаж5В");
	ТЗНоменклатура.Колонки.Добавить("КоличествоПродаж6В");
	ТЗНоменклатура.Колонки.Добавить("КоличествоПродаж7В");  
	ТЗНоменклатура.Колонки.Добавить("КоличествоПродажВ21");
	ТЗНоменклатура.Колонки.Добавить("КоличествоПродажВ22");
	ТЗНоменклатура.Колонки.Добавить("КоличествоПродажВ23");
	ТЗНоменклатура.Колонки.Добавить("КоличествоПродажВ24");
	ТЗНоменклатура.Колонки.Добавить("КоличествоПродажВ25");
	ТЗНоменклатура.Колонки.Добавить("КоличествоПродажВ26");
	ТЗНоменклатура.Колонки.Добавить("КоличествоПродажВ27");
	ТЗНоменклатура.Колонки.Добавить("РазмещенныеПослеРаспределения");
	
	ТЗЗаказаннаяНоменклатура = ТаблицаДанные.Скопировать(); //нужна для случаев когда в 1 день заказывается на несколько поставок.
	ТЗЗаказаннаяНоменклатура.Свернуть("Номенклатура, Поставщик", "КоличествоЗаказ, КоличествоЗаказ2, КоличествоЗаказ3, КоличествоЗаказ4, КоличествоЗаказ5, КоличествоЗаказ6");
	
	Пока ВыборкаПоставщик.Следующий() Цикл
		
		ОтборПоГрафику = Новый Структура();
		ОтборПоГрафику.Вставить("Поставщик", ВыборкаПоставщик.Поставщик);
		
		ВыборкаНоменклатура = ВыборкаПоставщик.Выбрать(ОбходРезультатаЗапроса.ПоГруппировкам, "Номенклатура");		
		
		Пока ВыборкаНоменклатура.Следующий() Цикл
			ВыборкаДниГрафикаПоставок = ВыборкаНоменклатура.Выбрать();
			КоличествоДнейМеждуЗаказомИПоступлением = 0;
			КоличествоДнейМеждуПоступлениями		= 0;
			ДеньПоставки 							= 0;
			
			СтруктураПоиска = Новый Структура();
			СтруктураПоиска.Вставить("ДеньЗаказа", ДеньРаспределения);
			Если ВыборкаДниГрафикаПоставок.НайтиСледующий(СтруктураПоиска) Тогда
			Иначе 
				Продолжить;				
			КонецЕсли;	
			
			Если ВыборкаДниГрафикаПоставок.Количество() = 1 Тогда	
				Если ВыборкаДниГрафикаПоставок.ДеньПоставки = 0 Тогда
					Продолжить;
				КонецЕсли;	
					
				КоличествоДнейМеждуЗаказомИПоступлением = ?(ВыборкаДниГрафикаПоставок.ДеньПоставки < ВыборкаДниГрафикаПоставок.ДеньЗаказа, ВыборкаДниГрафикаПоставок.ДеньПоставки + 7, ВыборкаДниГрафикаПоставок.ДеньПоставки) - ВыборкаДниГрафикаПоставок.ДеньЗаказа + 1 + ВыборкаДниГрафикаПоставок.КоличествоНедель * 7;
				КоличествоДнейМеждуПоступлениями		= 7;
			    ДеньПоставки = ВыборкаДниГрафикаПоставок.ДеньПоставки;
				ДеньЗаказа 	 = ВыборкаДниГрафикаПоставок.ДеньЗаказа;
			Иначе     
				НомПП = 1;
				Если ВыборкаДниГрафикаПоставок.ДеньПоставки = 0 Тогда
					Продолжить;
				КонецЕсли;
				
				КоличествоДнейМеждуЗаказомИПоступлением = ?(КоличествоДнейМеждуЗаказомИПоступлением = 0, ?(ВыборкаДниГрафикаПоставок.ДеньПоставки < ВыборкаДниГрафикаПоставок.ДеньЗаказа, ВыборкаДниГрафикаПоставок.ДеньПоставки + 7, ВыборкаДниГрафикаПоставок.ДеньПоставки) - ВыборкаДниГрафикаПоставок.ДеньЗаказа + 1 + ВыборкаДниГрафикаПоставок.КоличествоНедель * 7, КоличествоДнейМеждуЗаказомИПоступлением);
								
				ДеньЗаказа 	 = ВыборкаДниГрафикаПоставок.ДеньЗаказа;
				ДеньПоставки = ВыборкаДниГрафикаПоставок.ДеньПоставки;
				КоличествоНедель = ВыборкаДниГрафикаПоставок.КоличествоНедель;					
				
				Если НЕ ВыборкаДниГрафикаПоставок.Следующий() Тогда
					ВыборкаДниГрафикаПоставок.Сбросить();
					ВыборкаДниГрафикаПоставок.Следующий();
					КоличествоДнейМеждуПоступлениями = ?(ВыборкаДниГрафикаПоставок.ДеньПоставки - ДеньПоставки > 0, ВыборкаДниГрафикаПоставок.ДеньПоставки - ДеньПоставки, ВыборкаДниГрафикаПоставок.ДеньПоставки + 7 - ДеньПоставки) + КоличествоНедель * 7;
				Иначе
					КоличествоДнейМеждуПоступлениями = ?(ВыборкаДниГрафикаПоставок.ДеньПоставки - ДеньПоставки > 0, ВыборкаДниГрафикаПоставок.ДеньПоставки - ДеньПоставки, ВыборкаДниГрафикаПоставок.ДеньПоставки + 7 - ДеньПоставки) + КоличествоНедель * 7;
				КонецЕсли;
												 				
			КонецЕсли;          
			
			СуммаПродажНеразмещенныхЗаказов 	= 0;
			СуммаПродажДнейРазмещенныхЗаказов   = 0;
			СуммаРазмещенныхЗаказов             = 0;
							
			Если ЗначениеЗаполнено(КоличествоДнейМеждуЗаказомИПоступлением) ИЛИ ЗначениеЗаполнено(КоличествоДнейМеждуПоступлениями) Тогда
				ОтборПоГрафику.Вставить("Номенклатура", ВыборкаНоменклатура.Номенклатура);
				НайденныеСтроки = ТаблицаДанные.НайтиСтроки(ОтборПоГрафику);
				СтрокаДнейМеждуЗаказомИПоступлением = "";
				СтрокаДнейМеждуПоступлениями = "";

				КоличествоДнейМеждуЗаказомИПоступлением = КоличествоДнейМеждуЗаказомИПоступлением - 2; //период "не включая", отсекаем конец
						
						ОбрабатываемыйДень = ДеньЗаказа;
						
						Пока КоличествоДнейМеждуЗаказомИПоступлением > 0 Цикл 
							ОбрабатываемыйДень = ?(ОбрабатываемыйДень + 1 = 8, 1, ОбрабатываемыйДень + 1);
							СтрокаДнейМеждуЗаказомИПоступлением = "" + СтрокаДнейМеждуЗаказомИПоступлением + ОбрабатываемыйДень;
							КоличествоДнейМеждуЗаказомИПоступлением = КоличествоДнейМеждуЗаказомИПоступлением - 1;
						КонецЦикла;	
						
						ОбрабатываемыйДень = ДеньПоставки;
						Пока КоличествоДнейМеждуПоступлениями > 0 Цикл 						
							СтрокаДнейМеждуПоступлениями = "" + СтрокаДнейМеждуПоступлениями + ОбрабатываемыйДень;
							ОбрабатываемыйДень = ?(ОбрабатываемыйДень + 1 = 8, 1, ОбрабатываемыйДень + 1);   //В данном случае начало периода нужно, поэтому стоит после добавление в строку
							КоличествоДнейМеждуПоступлениями = КоличествоДнейМеждуПоступлениями - 1;
						КонецЦикла;
						
				Если НайденныеСтроки.Количество() > 0 Тогда						
					Для каждого СтрокаНайденныеСтроки Из НайденныеСтроки Цикл	
						СуммаПродажНеразмещенныхЗаказов 	= 0;
						СуммаПродажДнейРазмещенныхЗаказов 	= 0;
						СуммаРазмещенныеПослеРаспределения  = 0;
						
						Для ПозицияВСтроке = 1 по СтрДлина(СтрокаДнейМеждуЗаказомИПоступлением) Цикл
							ОбрабатываемыйДень = Число(Сред(СтрокаДнейМеждуЗаказомИПоступлением, ПозицияВСтроке, 1));
							НомерКолонкиОсновнойТаблицы = НачальнаяКолонкаКоличества + ОбрабатываемыйДень - 1;
							НомерКолонкиОсновнойТаблицы2НедНазад = НомерКолонкиОсновнойТаблицы + 6;
							СуммаПродажДнейРазмещенныхЗаказов = СуммаПродажДнейРазмещенныхЗаказов + СтрокаНайденныеСтроки[НомерКолонкиОсновнойТаблицы] + ?(КолПериодов = 2, СтрокаНайденныеСтроки[НомерКолонкиОсновнойТаблицы2НедНазад], 0);	
							Если КолПериодов = 2 Тогда
								СуммаПродажДнейРазмещенныхЗаказов = СуммаПродажДнейРазмещенныхЗаказов / 2;	
							КонецЕсли;	
							//Сообщить("ОбрабатываемыйДень: " + ОбрабатываемыйДень + ". НомерКолонкиОсновнойТаблицы: " + НомерКолонкиОсновнойТаблицы + ". СуммаПродажДнейРазмещенныхЗаказов: " + СуммаПродажДнейРазмещенныхЗаказов + ". СтрокаНайденныеСтроки[НомерКолонкиОсновнойТаблицы]: " + СтрокаНайденныеСтроки[НомерКолонкиОсновнойТаблицы]);
						КонецЦикла;	
						
						СтрокаНайденныеСтроки.ФактПродажДнейРазмещения = СуммаПродажДнейРазмещенныхЗаказов * 0.95;
						
						Для ПозицияВСтроке = 1 по СтрДлина(СтрокаДнейМеждуЗаказомИПоступлением) Цикл
							//ОбрабатываемыйДень = Число(Сред(СтрокаДнейМеждуЗаказомИПоступлением, ПозицияВСтроке, 1));
							НомерКолонкиОсновнойТаблицы = НачальнаяКолонкаЗаказа + ПозицияВСтроке - 1;	
							СуммаРазмещенныеПослеРаспределения = СуммаРазмещенныеПослеРаспределения + СтрокаНайденныеСтроки[НомерКолонкиОсновнойТаблицы];	
						КонецЦикла;	
						
						СтрокаНайденныеСтроки.РазмещенныеПослеРаспределения = СуммаРазмещенныеПослеРаспределения;//СтрокаНайденныеСтроки.ПлановыйОстатокПередСледЗаказом + СуммаРазмещенныхЗаказов;
						
						//Сообщить("" + ВыборкаНоменклатура.Номенклатура + " - " + СтрокаДнейМеждуЗаказомИПоступлением + " - " + СуммаРазмещенныхЗаказов);
						
						Для ПозицияВСтроке = 1 по СтрДлина(СтрокаДнейМеждуПоступлениями) Цикл
							ОбрабатываемыйДень = Число(Сред(СтрокаДнейМеждуПоступлениями, ПозицияВСтроке, 1));
							НомерКолонкиОсновнойТаблицы = НачальнаяКолонкаКоличества + ОбрабатываемыйДень - 1;
							НомерКолонкиОсновнойТаблицы2НедНазад = НомерКолонкиОсновнойТаблицы + 6;
							СуммаПродажНеразмещенныхЗаказов = СуммаПродажНеразмещенныхЗаказов + СтрокаНайденныеСтроки[НомерКолонкиОсновнойТаблицы] + ?(КолПериодов = 2 И НЕ СтрокаНайденныеСтроки[НомерКолонкиОсновнойТаблицы2НедНазад] = Неопределено, СтрокаНайденныеСтроки[НомерКолонкиОсновнойТаблицы2НедНазад], 0);							
							Если КолПериодов = 2 Тогда
								СуммаПродажНеразмещенныхЗаказов = СуммаПродажНеразмещенныхЗаказов / 2;	
							КонецЕсли;
						КонецЦикла;
						
						СтрокаНайденныеСтроки.ФактПродажДнейПоНеразмещеннымЗаказам = СуммаПродажНеразмещенныхЗаказов * 0.95;							
						
						СтрокаТЗНоменклатура = ТЗНоменклатура.Добавить();
						СтрокаТЗНоменклатура.Номенклатура = СтрокаНайденныеСтроки.Номенклатура;
						
						СтрокаТЗНоменклатура.КоличествоПродажВ  = СтрокаНайденныеСтроки.КоличествоПродажВ1;
						СтрокаТЗНоменклатура.КоличествоПродаж2В = СтрокаНайденныеСтроки.КоличествоПродажВ2;
						СтрокаТЗНоменклатура.КоличествоПродаж3В = СтрокаНайденныеСтроки.КоличествоПродажВ3;
						СтрокаТЗНоменклатура.КоличествоПродаж4В = СтрокаНайденныеСтроки.КоличествоПродажВ4;
						СтрокаТЗНоменклатура.КоличествоПродаж5В = СтрокаНайденныеСтроки.КоличествоПродажВ5;
						СтрокаТЗНоменклатура.КоличествоПродаж6В = СтрокаНайденныеСтроки.КоличествоПродажВ6;
						СтрокаТЗНоменклатура.КоличествоПродаж7В = СтрокаНайденныеСтроки.КоличествоПродажВ7;
						
						СтрокаТЗНоменклатура.КоличествоПродажВ21 = СтрокаНайденныеСтроки.КоличествоПродажВ21;
						СтрокаТЗНоменклатура.КоличествоПродажВ22 = СтрокаНайденныеСтроки.КоличествоПродажВ22;
						СтрокаТЗНоменклатура.КоличествоПродажВ23 = СтрокаНайденныеСтроки.КоличествоПродажВ23;
						СтрокаТЗНоменклатура.КоличествоПродажВ24 = СтрокаНайденныеСтроки.КоличествоПродажВ24;
						СтрокаТЗНоменклатура.КоличествоПродажВ25 = СтрокаНайденныеСтроки.КоличествоПродажВ25;
						СтрокаТЗНоменклатура.КоличествоПродажВ26 = СтрокаНайденныеСтроки.КоличествоПродажВ26;
						СтрокаТЗНоменклатура.КоличествоПродажВ27 = СтрокаНайденныеСтроки.КоличествоПродажВ27;
						
						СтрокаТЗНоменклатура = ТЗНоменклатура.Добавить();
						СтрокаТЗНоменклатура.Номенклатура = СтрокаНайденныеСтроки.Номенклатура;

						СтрокаТЗНоменклатура.РазмещенныеПослеРаспределения  = СтрокаНайденныеСтроки.РазмещенныеПослеРаспределения;
						
					КонецЦикла;					
				КонецЕсли;
			КонецЕсли;	
		КонецЦикла;
		
	КонецЦикла;	
		
	ТЗНоменклатура.Свернуть("Номенклатура", "КоличествоПродажВ, КоличествоПродаж2В, КоличествоПродаж3В, КоличествоПродаж4В, КоличествоПродаж5В, КоличествоПродаж6В, КоличествоПродаж7В, КоличествоПродажВ21, КоличествоПродажВ22, КоличествоПродажВ23, КоличествоПродажВ24, КоличествоПродажВ25, КоличествоПродажВ26, КоличествоПродажВ27");
	//ТЗНоменклатура.Свернуть("Номенклатура", "РазмещенныеПослеРаспределения");
	//Для каждого СтрокаНайденныеСтроки Из ТЗНоменклатура Цикл	
	//Сообщить("Номенклатура: " + СтрокаНайденныеСтроки.Номенклатура + ", РазмещенныеПослеРаспределения:" + СтрокаНайденныеСтроки.РазмещенныеПослеРаспределения);							
	//КонецЦикла;
	
	Для каждого СтрокаНайденныеСтроки Из ТЗНоменклатура Цикл
		
		Сообщить(		" Номенклатура: " + СтрокаНайденныеСтроки.Номенклатура + ", продажи прошлой недели:" +							
						" КоличествоПродаж понедельник: " + СтрокаНайденныеСтроки.КоличествоПродажВ	+
						" КоличествоПродаж вторник: " + СтрокаНайденныеСтроки.КоличествоПродаж2В	+
						" КоличествоПродаж среда: " + СтрокаНайденныеСтроки.КоличествоПродаж3В	+
						" КоличествоПродаж четверг: " + СтрокаНайденныеСтроки.КоличествоПродаж4В	+
						" КоличествоПродаж пятница: " + СтрокаНайденныеСтроки.КоличествоПродаж5В	+
						" КоличествоПродаж суббота: " + СтрокаНайденныеСтроки.КоличествоПродаж6В	+
						" КоличествоПродаж воскресенье: " + СтрокаНайденныеСтроки.КоличествоПродаж7В);
		Сообщить(		" Номенклатура: " + СтрокаНайденныеСтроки.Номенклатура + ", продажи позапрошлой недели:" +							
						" КоличествоПродаж пред понедельник: " + СтрокаНайденныеСтроки.КоличествоПродажВ21	+
						" КоличествоПродаж пред вторник: " + СтрокаНайденныеСтроки.КоличествоПродажВ22	+
						" КоличествоПродаж пред среда: " + СтрокаНайденныеСтроки.КоличествоПродажВ23	+
						" КоличествоПродаж пред четверг: " + СтрокаНайденныеСтроки.КоличествоПродажВ24	+
						" КоличествоПродаж пред пятница: " + СтрокаНайденныеСтроки.КоличествоПродажВ25	+
						" КоличествоПродаж пред суббота: " + СтрокаНайденныеСтроки.КоличествоПродажВ26	+
						" КоличествоПродаж пред воскресенье: " + СтрокаНайденныеСтроки.КоличествоПродажВ27);
		
	КонецЦикла;
	
	//+Расчёт колонки "Плановый остаток расчетный"
	ЗапросНоменклатурыДляЗаказа = Новый Запрос;
	ЗапросНоменклатурыДляЗаказа.Текст = 
	
		"ВЫБРАТЬ
		|	ТоварныйАссортиментТочек.ТорговаяТочка КАК ТорговаяТочка,
		|	ТоварныйАссортиментТочек.Номенклатура КАК Номенклатура,
		|	ТоварныйАссортиментТочек.Характеристика КАК Характеристика,
		|	ЕСТЬNULL(ПорядокОбеспеченияТорговыхТочекСрезПоследних.Расчетчик, ЗНАЧЕНИЕ(Справочник.СтруктурныеЕдиницы.ПустаяСсылка)) КАК Склад,
		|	ЗначенияСвойствОбъектов.Значение КАК КоличествоВУпаковке,
		|	ПараметрыНоменклатурыДляЗаказа.ЧислоДнейЗапаса,
		|	ПараметрыНоменклатурыДляЗаказа.КоэффициентПлановогоРасчетногоОстатка,
		|	ЦФОСтруктурныхЕдиницСрезПоследних.Организация
		|ПОМЕСТИТЬ вт
		|ИЗ
		|	РегистрСведений.ТоварныйАссортиментТочек.СрезПоследних(&ТекущаяДата, ТорговаяТочка.Активное = ИСТИНА) КАК ТоварныйАссортиментТочек
		|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.ПорядокОбеспеченияТорговыхТочек.СрезПоследних(&ТекущаяДата, ) КАК ПорядокОбеспеченияТорговыхТочекСрезПоследних
		|		ПО ТоварныйАссортиментТочек.ТорговаяТочка = ПорядокОбеспеченияТорговыхТочекСрезПоследних.ТорговаяТочка
		|			И ТоварныйАссортиментТочек.Номенклатура.ГруппаНоменклатурыУРЗ = ПорядокОбеспеченияТорговыхТочекСрезПоследних.ГруппаУРЗ
		|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.ТоварныеОграниченияНаТочках КАК ТоварныеОграниченияНаТочках
		|		ПО ТоварныйАссортиментТочек.ТорговаяТочка = ТоварныеОграниченияНаТочках.ТорговаяТочка
		|			И (ТоварныеОграниченияНаТочках.ГруппаНоменклатуры = ТоварныйАссортиментТочек.Номенклатура)
		|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.ЗначенияСвойствОбъектов КАК ЗначенияСвойствОбъектов
		|		ПО (ЗначенияСвойствОбъектов.Свойство = ЗНАЧЕНИЕ(ПланВидовХарактеристик.СвойстваОбъектов.КоличествоВУпаковке))
		|			И (ЗначенияСвойствОбъектов.Объект = ТоварныйАссортиментТочек.Характеристика)
		|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.КоличествоВКоробке.СрезПоследних(&ТекущаяДата, ) КАК КоличествоВКоробкеСрезПоследних
		|		ПО (КоличествоВКоробкеСрезПоследних.Номенклатура = ТоварныйАссортиментТочек.Номенклатура)
		|			И (КоличествоВКоробкеСрезПоследних.Характеристика = ТоварныйАссортиментТочек.Характеристика)
		|			И (КоличествоВКоробкеСрезПоследних.Характеристика.БратьКоличествоВКоробкеПоСкладуДляРаспределения)
		|			И (КоличествоВКоробкеСрезПоследних.СтруктурнаяЕдиница = ПорядокОбеспеченияТорговыхТочекСрезПоследних.Расчетчик)
		|			И (НЕ КоличествоВКоробкеСрезПоследних.Количество = 0)
		|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.ПараметрыНоменклатурыДляЗаказа КАК ПараметрыНоменклатурыДляЗаказа
		|		ПО ТоварныйАссортиментТочек.Номенклатура = ПараметрыНоменклатурыДляЗаказа.Номенклатура
		|			И ТоварныйАссортиментТочек.Характеристика = ПараметрыНоменклатурыДляЗаказа.Характеристика
		|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.ЦФОСтруктурныхЕдиниц.СрезПоследних КАК ЦФОСтруктурныхЕдиницСрезПоследних
		|		ПО ТоварныйАссортиментТочек.ТорговаяТочка = ЦФОСтруктурныхЕдиницСрезПоследних.СтруктурнаяЕдиница
		|ГДЕ
		|	ПараметрыНоменклатурыДляЗаказа.Склад = &Склад
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	вт.Номенклатура КАК Номенклатура,
		|	вт.Характеристика,
		|	вт.Склад,
		|	ЕСТЬNULL(вт.КоличествоВУпаковке, 0) КАК КоличествоВУпаковке,
		|	ЕСТЬNULL(вт.ЧислоДнейЗапаса, 0) КАК ЧислоДнейЗапаса,
		|	ЕСТЬNULL(вт.КоэффициентПлановогоРасчетногоОстатка, 0) КАК КоэффициентПлановогоРасчетногоОстатка,
		|	ЗначенияСвойствОбъектов.Значение КАК Производитель,
		|	вт.Организация,
		|	КОЛИЧЕСТВО(РАЗЛИЧНЫЕ вт.ТорговаяТочка) КАК КоличествоТорговыхТочек
		|ИЗ
		|	вт КАК вт
		|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ РегистрСведений.ЗначенияСвойствОбъектов КАК ЗначенияСвойствОбъектов
		|		ПО (ЗначенияСвойствОбъектов.Свойство = ЗНАЧЕНИЕ(ПланВидовХарактеристик.СвойстваОбъектов.Производитель))
		|			И (ЗначенияСвойствОбъектов.Объект = вт.Характеристика)
		|ГДЕ
		|	вт.ТорговаяТочка.Активное = ИСТИНА
		|	И вт.Организация = &Организация
		|	И вт.Склад = &Склад
		|
		|СГРУППИРОВАТЬ ПО
		|	вт.Номенклатура,
		|	вт.Характеристика,
		|	вт.Склад,
		|	ЗначенияСвойствОбъектов.Значение,
		|	вт.Организация,
		|	ЕСТЬNULL(вт.КоличествоВУпаковке, 0),
		|	ЕСТЬNULL(вт.ЧислоДнейЗапаса, 0),
		|	ЕСТЬNULL(вт.КоэффициентПлановогоРасчетногоОстатка, 0)
		|
		|УПОРЯДОЧИТЬ ПО
		|	Номенклатура,
		|	Производитель,
		|	КоэффициентПлановогоРасчетногоОстатка УБЫВ,
		|	КоличествоВУпаковке УБЫВ";
	
	ЗапросНоменклатурыДляЗаказа.УстановитьПараметр("Склад", мСклад);
	ЗапросНоменклатурыДляЗаказа.УстановитьПараметр("Организация", Справочники.Организации.НайтиПоКоду("000000006")); //Вкусвилл
	ЗапросНоменклатурыДляЗаказа.УстановитьПараметр("ТекущаяДата", мДатаРаспределения);	
	
	РезультатЗапросаНоменклатурыДляЗаказа = ЗапросНоменклатурыДляЗаказа.Выполнить();
	
	ВыборкаДетальныеЗаписиНоменклатурыДляЗаказа = РезультатЗапросаНоменклатурыДляЗаказа.Выбрать();
	
	ТаблицаДанные.Колонки.Добавить("НужноПоМинОстатку", мТипЧисло);
	ТаблицаДанные.Колонки.Добавить("ПланПродажСМинОстатком", мТипЧисло);
	
	ТаблицаТорговыхТочек = ТаблицаДанные.Скопировать(); //Поиск прямого количеста ТТ (строк в отчёте)
	ТаблицаТорговыхТочек.Свернуть("Номенклатура, Поставщик, ТорговаяТочка");
	
	Пока ВыборкаДетальныеЗаписиНоменклатурыДляЗаказа.Следующий() Цикл
		
		СтруктураПоиска = Новый Структура;
		СтруктураПоиска.Вставить("Номенклатура", 	ВыборкаДетальныеЗаписиНоменклатурыДляЗаказа.Номенклатура);
		СтруктураПоиска.Вставить("Поставщик", 		ВыборкаДетальныеЗаписиНоменклатурыДляЗаказа.Производитель);
		МассивНайденных = ТаблицаДанные.НайтиСтроки(СтруктураПоиска);
		
		//Поиск прямого количеста ТТ (строк в отчёте)
		МассивТТ 		= ТаблицаТорговыхТочек.НайтиСтроки(СтруктураПоиска);
		КоличествоТТ	= 0;
		КоличествоТТ 	= МассивТТ.Количество();
		
		Если МассивНайденных.Количество() > 0 Тогда
	    	МассивНайденных[0].ПлановыйОстатокРасчетный = ВыборкаДетальныеЗаписиНоменклатурыДляЗаказа.КоличествоВУпаковке * ВыборкаДетальныеЗаписиНоменклатурыДляЗаказа.КоэффициентПлановогоРасчетногоОстатка * КоличествоТТ;	
			МассивНайденных[0].КоличествоВУпаковке	 	= ВыборкаДетальныеЗаписиНоменклатурыДляЗаказа.КоличествоВУпаковке;
			МассивНайденных[0].ЧислоДнейЗапаса	 		= ВыборкаДетальныеЗаписиНоменклатурыДляЗаказа.ЧислоДнейЗапаса;
			МассивНайденных[0].КоэффициентПлановогоРасчетногоОстатка = ВыборкаДетальныеЗаписиНоменклатурыДляЗаказа.КоэффициентПлановогоРасчетногоОстатка;
							
			ВспомогательныйКоэффициент = ВыборкаДетальныеЗаписиНоменклатурыДляЗаказа.КоэффициентПлановогоРасчетногоОстатка * ВыборкаДетальныеЗаписиНоменклатурыДляЗаказа.КоличествоВУпаковке;
			
			Для каждого СтрокаНайденных Из МассивНайденных Цикл			
				Если СтрокаНайденных.МинимальныйОстаток > ВспомогательныйКоэффициент Тогда
					СтрокаНайденных.НужноПоМинОстатку = СтрокаНайденных.МинимальныйОстаток - ВспомогательныйКоэффициент;	
				КонецЕсли;	
				Если СтрокаНайденных.МинимальныйОстаток > 0 Тогда
					СтрокаНайденных.ПланПродажСМинОстатком 	= СтрокаНайденных.КоличествоПланПродаж; 
				КонецЕсли
			КонецЦикла;	
		КонецЕсли;	
		
	КонецЦикла;
		
	Возврат ТаблицаДанные;
	
КонецФункции

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
	|	ГруппыНоменклатуры.Ссылка = &Расчетчик
	|	И НЕ ГруппыНоменклатуры.ГруппаНоменклатуры.ЭтоГруппа";
	
	Возврат Запрос.Выполнить().Выгрузить().ВыгрузитьКолонку("Номенклатура");
	
КонецФункции
