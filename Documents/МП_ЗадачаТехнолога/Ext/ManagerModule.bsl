﻿//+++VERN
//+++АК SHEP 20170123: добавил документ ПеремещениеСклад для склада склада
Функция ПолучитьОрдерНаВозврат(Основание) Экспорт
	
	УстановитьПривилегированныйРежим(Истина);
	
	МассивТиповЗаданий = Новый Массив;
	МассивТиповЗаданий.Добавить(Перечисления.ТипыЗаданийТехнологаМагазинам.ВозвратНаСклад);
	МассивТиповЗаданий.Добавить(Перечисления.ТипыЗаданийТехнологаМагазинам.СамовывозСМагазинов);
	МассивТиповЗаданий.Добавить(Перечисления.ТипыЗаданийТехнологаМагазинам.СписаниеСМагазинов);
	МассивТиповЗаданий.Добавить(Перечисления.ТипыЗаданийТехнологаМагазинам.УбратьСПолок);
	
	Запрос = Новый Запрос(
		"ВЫБРАТЬ ПЕРВЫЕ 1
		|	ПриходныйОрдерСклад.Ссылка,
		|	ПриходныйОрдерСклад.МоментВремени КАК МоментВремени,
		|	ПриходныйОрдерСклад.Проведен КАК Проведен,
		|	ПриходныйОрдерСклад.ПометкаУдаления КАК ПометкаУдаления
		|ИЗ
		|	Документ.ПриходныйОрдерСклад КАК ПриходныйОрдерСклад
		|ГДЕ
		|	ПриходныйОрдерСклад.Основание = &Основание
		|	И НЕ ПриходныйОрдерСклад.ПометкаУдаления
		//|	И ВЫРАЗИТЬ(&Основание КАК Документ.МП_ЗадачаТехнолога).СкладСклада = ЗНАЧЕНИЕ(Справочник.Склады.ПустаяСсылка)
		|	И ВЫРАЗИТЬ(&Основание КАК Документ.МП_ЗадачаТехнолога).ТипЗадания В (&МассивТиповЗаданий)
		|
		//|
		//|ОБЪЕДИНИТЬ ВСЕ
		//|
		//|ВЫБРАТЬ ПЕРВЫЕ 1
		//|	ПеремещениеСклад.Ссылка,
		//|	ПеремещениеСклад.МоментВремени,
		//|	ПеремещениеСклад.Проведен,
		//|	ПеремещениеСклад.ПометкаУдаления
		//|ИЗ
		//|	Документ.ПеремещениеСклад КАК ПеремещениеСклад
		//|ГДЕ
		//|	ПеремещениеСклад.Основание = &Основание
		//|	И НЕ ПеремещениеСклад.ПометкаУдаления
		//|	И НЕ ВЫРАЗИТЬ(&Основание КАК Документ.МП_ЗадачаТехнолога).СкладСклада = ЗНАЧЕНИЕ(Справочник.Склады.ПустаяСсылка)
		//|	И ВЫРАЗИТЬ(&Основание КАК Документ.МП_ЗадачаТехнолога).ТипЗадания В (&МассивТиповЗаданий)
		|
		|УПОРЯДОЧИТЬ ПО
		|	МоментВремени УБЫВ,
		|	Проведен УБЫВ,
		|	ПометкаУдаления");
	Запрос.УстановитьПараметр("Основание", Основание);
	Запрос.УстановитьПараметр("МассивТиповЗаданий", МассивТиповЗаданий);
	
	// через ОБЪЕДИНИТЬ ВСЕ, ВЫБРАТЬ ПЕРВЫЕ 1, УПОРЯДОЧИТЬ ПО МоментВремени УБЫВ выдаёт неправильный результат!!!
	Если ЗначениеЗаполнено(Основание.СкладСклада) Тогда
		Запрос.Текст = СтрЗаменить(Запрос.Текст, "ПриходныйОрдерСклад", "ПеремещениеСклад");
	КонецЕсли;
	
	РезультатЗапроса = Запрос.Выполнить();
	Если РезультатЗапроса.Пустой() Тогда
		Возврат Документы.ПриходныйОрдерСклад.ПустаяСсылка();
	КонецЕсли;
	
	ВыборкаЗапроса = РезультатЗапроса.Выбрать();
	ВыборкаЗапроса.Следующий();
	
	УстановитьПривилегированныйРежим(Ложь);

	Возврат ВыборкаЗапроса.Ссылка;
	
КонецФункции
//---VERN

////////////////////////////////////////////////////////////////////////////////
// Печать

Функция ПечатьПередачаТоваровПоставщику(МассивОбъектов, ОбъектыПечати)
	
	Перем ТабДокумент, Запрос, Выборка;
	
	ТабДокумент = Новый ТабличныйДокумент;
	ТабДокумент.ИмяПараметровПечати = "ПАРАМЕТРЫ_ПЕЧАТИ_МП_ЗадачаТехнолога_ПередачаТоваровПоставщику";
	
	Запрос = Новый Запрос(
		"ВЫБРАТЬ
		|	Накладная.Ссылка КАК Ссылка,
		|	Накладная.Номер,
		|	Накладная.Дата,
		|	Накладная.ДокументОснование.Поставщик КАК Поставщик,
		|	Накладная.Магазин.Организация КАК Организация,
		|	ВалютаРегламентированногоУчета.Значение КАК ВалютаДокумента,
		|	ЛОЖЬ КАК УчитыватьНДС,
		|	ИСТИНА КАК СуммаВключаетНДС,
		|	ЗНАЧЕНИЕ(Справочник.Пользователи.ПустаяСсылка) КАК Ответственный,
		|	Накладная.Магазин.Представление КАК ОтветственныйПредставление,
		|	Накладная.ПараметрыЗадачи.(
		|		НомерСтроки КАК НомерСтроки,
		|		Номенклатура,
		|		Номенклатура.Код КАК Код,
		|		Номенклатура.Артикул КАК Артикул,
		|		Номенклатура.Наименование КАК Товар,
		|		Количество,
		|		Номенклатура.БазоваяЕдиницаИзмерения.Наименование КАК ЕдиницаИзмерения,
		|		Цена,
		|		Сумма
		|	) КАК Товары
		|ИЗ
		|	Документ.МП_ЗадачаТехнолога КАК Накладная,
		|	Константа.ВалютаРегламентированногоУчета КАК ВалютаРегламентированногоУчета
		|ГДЕ
		|	Накладная.Ссылка В(&МассивОбъектов)
		|	И Накладная.ПараметрыЗадачи.Количество <> 0
		|
		|УПОРЯДОЧИТЬ ПО
		|	Накладная.МоментВремени,
		|	Накладная.ПараметрыЗадачи.НомерСтроки");
	Запрос.УстановитьПараметр("МассивОбъектов", МассивОбъектов);
	
	Выборка = Запрос.Выполнить().Выбрать();
	
	Макет = Документы.МП_ЗадачаТехнолога.ПолучитьМакет("ПередачаТоваровПоставщику");
	
	ПервыйДокумент = Истина;
	
	Пока Выборка.Следующий() Цикл
		
		Если НЕ ПервыйДокумент Тогда
			ТабДокумент.ВывестиГоризонтальныйРазделительСтраниц();
		КонецЕсли;
		
		ПервыйДокумент = Ложь;
		
		НомерСтрокиНачало = ТабДокумент.ВысотаТаблицы + 1;
		
		СведенияОбОрганизации    = УправлениеКонтактнойИнформацией.СведенияОЮрФизЛице(Выборка.Организация, Выборка.Дата);
		ПредставлениеОрганизации = ФормированиеПечатныхФорм.ОписаниеОрганизации(СведенияОбОрганизации	, "НаименованиеДляПечатныхФорм,");
		
		СведенияОКонтрагенте     = УправлениеКонтактнойИнформацией.СведенияОЮрФизЛице(Выборка.Поставщик, Выборка.Дата);
		ПредставлениеКонтрагента = ФормированиеПечатныхФорм.ОписаниеОрганизации(СведенияОКонтрагенте	, "НаименованиеДляПечатныхФорм,");
		
			
		// Вывод шапки
		ОбластьМакета = Макет.ПолучитьОбласть("Заголовок");
		ОбластьМакета.Параметры.ТекстЗаголовка = ОбщегоНазначения.СформироватьЗаголовокДокумента(Выборка, "Передача товаров поставщику");
		ТабДокумент.Вывести(ОбластьМакета);

		ОбластьМакета = Макет.ПолучитьОбласть("Поставщик");
		ОбластьМакета.Параметры.ПредставлениеПоставщика = ПредставлениеКонтрагента;
		ОбластьМакета.Параметры.Поставщик 				= Выборка.Поставщик;
		ТабДокумент.Вывести(ОбластьМакета);

		ОбластьМакета = Макет.ПолучитьОбласть("Покупатель");
		ОбластьМакета.Параметры.ПредставлениеПолучателя = ПредставлениеОрганизации;
		ОбластьМакета.Параметры.Получатель = Выборка.Организация;
		ТабДокумент.Вывести(ОбластьМакета);

		// Вывод табличной части
		ОбластьНомера = Макет.ПолучитьОбласть("ШапкаТаблицы|НомерСтроки");
		ОбластьДанных = Макет.ПолучитьОбласть("ШапкаТаблицы|Данные");
		ОбластьСуммы  = Макет.ПолучитьОбласть("ШапкаТаблицы|Сумма");
		
		ТабДокумент.Вывести(ОбластьНомера);
		ТабДокумент.Присоединить(ОбластьДанных);
		ТабДокумент.Присоединить(ОбластьСуммы);

		ОбластьКолонкаТовар = Макет.Область("Товар");
		ОбластьКолонкаТовар.ШиринаКолонки = ОбластьКолонкаТовар.ШиринаКолонки +	Макет.Область("КолонкаКодов").ШиринаКолонки;

		ОбластьНомера = Макет.ПолучитьОбласть("Строка|НомерСтроки");
		ОбластьДанных = Макет.ПолучитьОбласть("Строка|Данные");
		ОбластьСуммы  = Макет.ПолучитьОбласть("Строка|Сумма");

		ИтСумма = 0;
		Ном 	= 0;
		
		ВыборкаСтрокТовары = Выборка.Товары.Выбрать();
		Пока ВыборкаСтрокТовары.Следующий() Цикл

			Ном = Ном + 1;
			
			ОбластьНомера.Параметры.НомерСтроки = Ном;
			ТабДокумент.Вывести(ОбластьНомера);
			
			ОбластьДанных.Параметры.Заполнить(ВыборкаСтрокТовары);
			ОбластьДанных.Параметры.Товар 	= СокрЛП(ВыборкаСтрокТовары.Товар);
			ТабДокумент.Присоединить(ОбластьДанных);

			ОбластьСуммы.Параметры.Заполнить(ВыборкаСтрокТовары);
			ТабДокумент.Присоединить(ОбластьСуммы);

			ИтСумма = ИтСумма + ВыборкаСтрокТовары.Сумма;

		КонецЦикла;
		
		// Вывести Итого
		ОбластьНомера = Макет.ПолучитьОбласть("Итого|НомерСтроки");
		ОбластьДанных = Макет.ПолучитьОбласть("Итого|Данные");
		ОбластьСуммы  = Макет.ПолучитьОбласть("Итого|Сумма");

		ТабДокумент.Вывести(ОбластьНомера);
		ТабДокумент.Присоединить(ОбластьДанных);
		ОбластьСуммы.Параметры.Всего = ОбщегоНазначения.ФорматСумм(ИтСумма);
		ТабДокумент.Присоединить(ОбластьСуммы);
		
		// Вывести Сумму прописью
		ОбластьМакета = Макет.ПолучитьОбласть("СуммаПрописью");
		СуммаКПрописи = ИтСумма;// + ?(Выборка.СуммаВключаетНДС, 0, ИтСуммаНДС);
		ОбластьМакета.Параметры.ИтоговаяСтрока 	= "Всего наименований " + Ном + ", на сумму " +
													ОбщегоНазначения.ФорматСумм(СуммаКПрописи, Выборка.ВалютаДокумента);
		ОбластьМакета.Параметры.СуммаПрописью 	= ОбщегоНазначения.СформироватьСуммуПрописью(СуммаКПрописи, Выборка.ВалютаДокумента);
		ТабДокумент.Вывести(ОбластьМакета);

		// Вывести подписи
		ОбластьМакета = Макет.ПолучитьОбласть("Подписи");
		ОбластьМакета.Параметры.Заполнить(Выборка);
		СведенияОбОтветственном 	= УправлениеКонтактнойИнформацией.СведенияОЮрФизЛице(Выборка.Ответственный, Выборка.Дата, Ложь);
		ОтветственныйПредставление 	= ФормированиеПечатныхФорм.ОписаниеОрганизации(СведенияОбОтветственном, "НаименованиеДляПечатныхФорм,");
		ТабДокумент.Вывести(ОбластьМакета);
        				
		УправлениеПечатью.ЗадатьОбластьПечатиДокумента(ТабДокумент, НомерСтрокиНачало, ОбъектыПечати, Выборка.Ссылка);
		
	КонецЦикла;
	
	ТабДокумент.АвтоМасштаб = Истина;
	
	Возврат ТабДокумент;
	
КонецФункции

Функция ПечатьПриходныйОрдерСклад(МассивОбъектов, ОбъектыПечати)
	
	Перем ТабДокумент, Запрос, Выборка;
	
	ТабДокумент = Новый ТабличныйДокумент;
	ТабДокумент.ИмяПараметровПечати = "ПАРАМЕТРЫ_ПЕЧАТИ_МП_ЗадачаТехнолога_ПриходныйОрдерСклад";
	
	Ордер = Документы.МП_ЗадачаТехнолога.ПолучитьОрдерНаВозврат(МассивОбъектов);
	Если ЗначениеЗаполнено(Ордер) тогда
		ТабДокумент = Документы.ПриходныйОрдерСклад.Печать(Ордер);
	Иначе
		ТабДокумент = Новый ТабличныйДокумент;
	КонецЕсли;
	
	ТабДокумент.АвтоМасштаб = Истина;
	
	Возврат ТабДокумент;
	
КонецФункции

// Сформировать печатные формы объектов
//
// ВХОДЯЩИЕ:
//   ИменаМакетов    - Строка    - Имена макетов, перечисленные через запятую
//   МассивОбъектов  - Массив    - Массив ссылок на объекты которые нужно распечатать
//   ПараметрыПечати - Структура - Структура дополнительных параметров печати
//
// ИСХОДЯЩИЕ:
//   КоллекцияПечатныхФорм - Таблица значений - Сформированные табличные документы
//   ПараметрыВывода       - Структура        - Параметры сформированных табличных документов
//
Процедура Печать(МассивОбъектов, ПараметрыПечати, КоллекцияПечатныхФорм, ОбъектыПечати, ПараметрыВывода) Экспорт
	
	Если УправлениеПечатью.НужноПечататьМакет(КоллекцияПечатныхФорм, "ПередачаТоваровПоставщику") Тогда
		УправлениеПечатью.ВывестиТабличныйДокументВКоллекцию(КоллекцияПечатныхФорм, "ПередачаТоваровПоставщику", "Передача товаров поставщику",
																ПечатьПередачаТоваровПоставщику(МассивОбъектов, ОбъектыПечати));
		
	ИначеЕсли УправлениеПечатью.НужноПечататьМакет(КоллекцияПечатныхФорм, "ПриходныйОрдерСклад") Тогда
		УправлениеПечатью.ВывестиТабличныйДокументВКоллекцию(КоллекцияПечатныхФорм, "ПриходныйОрдерСклад", "Приходный ордер (склад)",
																ПечатьПриходныйОрдерСклад(МассивОбъектов, ОбъектыПечати));
		
	КонецЕсли;
	
КонецПроцедуры

Функция ТоварныеОперации_ДокументПринятСервером(Знач ИдДокумента, Знач НомерТочкиПоАйпи = 0, МассивОшибок = Неопределено, ЖдатьОбработки = Истина) Экспорт
Перем ДокументОбработан, ДокументПринят, НомерОшибки, ТекстОшибки;
	
	Если НомерТочкиПоАйпи = 0 Тогда
		НомерТочкиПоАйпи = ПараметрыСеанса.НомерТочкиПоАйпи;
	КонецЕсли;
	
	МассивОшибок = Новый Массив;
	
	ADOСоединение = ВнешниеДанныеКлиентСервер.ПолучитьADOСоединение();
	
	ЗапросSQL = "
		|SELECT DISTINCT Confirm_type, Confirm_reason, tpo.name_operation as confirm_description
  		|FROM [SMS_Repl].[dbo].[TD_move] as td_move (nolock)
		|LEFT JOIN SMS_REPL..Types_Operation as tpo with(nolock)
		|	ON tpo.code_operation = td_move.confirm_reason
		|	AND tpo.table_operation = 'td_move' and field_operation='confirm_reason'
		|
  		|WHERE
		|	ShopNo_rep = " + ВнешниеДанные.ФорматПоля(НомерТочкиПоАйпи) + "
		|	AND [Id_doc] = " + ВнешниеДанные.ФорматПоля(ИдДокумента);
		
	Пока Истина Цикл
		
		ДокументПринят = Неопределено;
		ДокументОбработан = Неопределено;
		
		rs = ADOСоединение.Execute(ЗапросSQL);

		//Попытка
		Если rs.EOF() Тогда
			МассивОшибок.Добавить(Новый Структура("НомерОшибки,ТекстОшибки", "-", "При последней попытке записи произошла ошибка, откройте журнал торговых операций!"));
			Прервать;
			
		Иначе
			Пока НЕ rs.EOF() Цикл
				
				ТипПодтверждения = rs.fields("Confirm_type").Value;
				ДокументОбработан = ?(ДокументОбработан = Ложь, Ложь, (ТипПодтверждения <> 0));
				ДокументПринят = ?(ДокументПринят = Ложь, Ложь, (ТипПодтверждения = 1));
				
				Если ДокументОбработан И НЕ ДокументПринят Тогда
					НомерОшибки = rs.fields("Confirm_reason").Value;
					МассивОшибок.Добавить(Новый Структура("НомерОшибки,ТекстОшибки", НомерОшибки, СокрЛП(rs.fields("confirm_description").Value)));
				КонецЕсли;
				
				rs.MoveNext();
				
			КонецЦикла;
		КонецЕсли;
		//Исключение
		//	ОбщегоНазначения.СообщитьОбОшибке(ОписаниеОшибки());		
		//КонецПопытки;
		
		Если ДокументОбработан = Истина Тогда Прервать;
		ИначеЕсли НЕ ЖдатьОбработки Тогда Прервать;
		КонецЕсли;
		
	КонецЦикла;
	
	ADOСоединение.Close();
	
	Возврат ?(ЖдатьОбработки, ДокументПринят = Истина И ДокументОбработан = Истина, ДокументОбработан);
	
КонецФункции

Функция ТоварныеОперации_ПровестиДок(ИдСсылкиСтр, ИдДокумента, КодОперации, ДатаЗакрытия = Неопределено, Знач НомерТочкиПоАйпи = 0, Обязательно = Ложь) Экспорт
Перем МассивОшибок, НомерОшибки, ТекстОшибки;
	
	Если ДатаЗакрытия = Неопределено Тогда
		ДатаЗакрытия = ВнешниеДанные.ВернутьТекущуюДатуSQL();
	КонецЕсли;
	
	Если НомерТочкиПоАйпи = 0 Тогда
		НомерТочкиПоАйпи = ПараметрыСеанса.НомерТочкиПоАйпи;
	КонецЕсли;
	
	ADOСоединение = ВнешниеДанныеКлиентСервер.ПолучитьADOСоединение();
	
	ИмяБд = "SMS_Repl";
	ЗапросСкуль = "UPDATE [" + ИмяБд + "].[dbo].[TD_Move]
   			|SET closedate = " + ВнешниеДанные.ФорматПоля(ДатаЗакрытия) + ", operation_type = " + ВнешниеДанные.ФорматПоля(КодОперации) + ", operation_type_orig = " + ВнешниеДанные.ФорматПоля(КодОперации) + "
			|,Confirm_type = 0
		  |,balance_ost = TD_move.Quantity * OpType.znak + TD_ost.Ost_kon, Descr = " + ВнешниеДанные.ФорматПоля(ИдСсылкиСтр) + "
		  |" + ?(Обязательно, ", flg_confirm = 1, Qty_Other_TT = Quantity", "") + "
		  |
		  |
		  |	FROM [" + ИмяБд + "].[dbo].[TD_move] as TD_move with (rowlock, index (ind1))
		  |	LEFT OUTER JOIN [" + ИмяБд + "].[dbo].[TD_ost] as TD_ost (nolock) ON TD_move.id_tov = TD_ost.id_tov and TD_ost.ShopNo_rep = " + ВнешниеДанные.ФорматПоля(НомерТочкиПоАйпи) + "
		  |	LEFT OUTER JOIN (SELECT [Znak], [code_operation] FROM [" + ИмяБд + "].[dbo].[Types_Operation] (nolock) where [table_operation] = 'td_move' and [field_operation] = 'operation_type_orig') as OpType ON TD_move.operation_type = OpType.code_operation
		  | WHERE TD_move.Id_doc = " + ВнешниеДанные.ФорматПоля(ИдДокумента) + " and TD_move.ShopNo_rep = " + ВнешниеДанные.ФорматПоля(НомерТочкиПоАйпи); // + " and operation_type < 0";
	
	флУспешно = Истина;
	ТекстОшибки = "";
	
	ЗапросПолный = "declare @err int =1
					|while @err=1
					|begin
					| begin try
					|" + ЗапросСкуль + "
					|select @err=0
					| 
					| END TRY
					|  BEGIN CATCH
					| 
					|if CHARINDEX('вызвала взаимоблокировку ресурсов',ERROR_MESSAGE(),1)>0
					|begin
					|-- запись в лог факта блокировки
					|	set @err=1
					|end
					|else
					|begin
					| 
					|-- прочая ошибка - выход  
					| return
					| end
					| 
					|  END CATCH 
					|end -- while";
					
	Попытка	
		ADOСоединение.Execute(ЗапросПолный);
	Исключение
		ТекстОшибки = ОписаниеОшибки();
		ЗаписьЖурналаРегистрации("Ошибка проведения документа", УровеньЖурналаРегистрации.Ошибка, ,, ТекстОшибки + Символы.ПС + "Выполняемый запрос" + Символы.ПС + ЗапросСкуль);
		флУспешно = Ложь;
	КонецПопытки;
	
	ADOСоединение.Close();
	
	//+++АК SHEP 20161023: если обязательно проводить, то сервер sql должен операцию пропустить, не проверяем принятие сервером
	Если Обязательно Тогда Возврат ТекстОшибки; КонецЕсли;
	//---АК SHEP 20161023
	
	Если ТоварныеОперации_ДокументПринятСервером(ИдДокумента, НомерТочкиПоАйпи, МассивОшибок) Тогда
		Возврат ТекстОшибки;
	Иначе
		
		МассивНекритическихОшибок = ОбщегоНазначения.РазложитьСтрокуВМассивПодстрок(РегистрыСведений.ПараметрыРаботыССоцСетями.ПолучитьЗначениеПараметра(, "НекритическиеОшибки[TD_Move]"), ",");
		
		// проверяем, если ошибка некритическая, проводим принудительно
		Для Каждого ЭлементМассива Из МассивОшибок Цикл
			НомерОшибки = Строка(ЭлементМассива.НомерОшибки);
			Если МассивНекритическихОшибок.Найти(НомерОшибки) = Неопределено Тогда
				ТекстОшибки = ТекстОшибки + """" + НомерОшибки + ". " + ЭлементМассива.ТекстОшибки + """" + Символы.ПС;
				Возврат ТекстОшибки;
			КонецЕсли;
		КонецЦикла;
		
		Возврат ТоварныеОперации_ПровестиДок(ИдДокумента, КодОперации, ДатаЗакрытия, НомерТочкиПоАйпи, Истина);
		
	КонецЕсли;
	
КонецФункции

Функция ПолучитьИПодключитьВнешнююОбработкуТоварныеОперации() Экспорт
	
	УстановитьПривилегированныйРежим(Истина);
	
	ВнешниеОбработкиСсылка = Справочники.ВнешниеОбработки.НайтиПоНаименованию("ТоварныеОперации_Магазины");
	ДвоичныеДанные = ВнешниеОбработкиСсылка.ХранилищеВнешнейОбработки.Получить();
	
	#Если Сервер Тогда
		АдресВоВременномХранилище = ПоместитьВоВременноеХранилище(ДвоичныеДанные);
		ИмяОбработки = ВнешниеОбработки.Подключить(АдресВоВременномХранилище, , Ложь);
	#Иначе
		ИмяОбработки = ПолучитьИмяВременногоФайла("epf");
		ДвоичныеДанные.Записать(ИмяОбработки); 
	#КонецЕсли
	
	Обработка = ВнешниеОбработки.Создать(ИмяОбработки);
	
	УстановитьПривилегированныйРежим(Ложь);
	
	Возврат Обработка;
	
КонецФункции

Функция ВернутьИДНоменклатуры(НомСсылка) Экспорт
	
	Запрос = Новый Запрос(
		"ВЫБРАТЬ
		|	Номенклатура.id_tov
		|ИЗ
		|	Справочник.Номенклатура КАК Номенклатура
		|ГДЕ
		|	Номенклатура.Ссылка = &Ссылка");
	Запрос.УстановитьПараметр("Ссылка", НомСсылка);
	
	РезультатЗапроса = Запрос.Выполнить();
	Если РезультатЗапроса.Пустой() Тогда Возврат НомСсылка.id_tov; КонецЕсли;
	
	ВыборкаЗапроса = РезультатЗапроса.Выбрать();
	ВыборкаЗапроса.Следующий();
	Возврат ВыборкаЗапроса.id_tov;
	
КонецФункции

Функция ВернутьИДХарактеристики(ХарСсылка) Экспорт
	
	Запрос = Новый Запрос(
		"ВЫБРАТЬ
		|	ЕСТЬNULL(ВЫРАЗИТЬ(ЗначенияСвойствОбъектов.Значение КАК Справочник.Контрагенты).ИД, 0) КАК ИДПроизв
		|ИЗ
		|	РегистрСведений.ЗначенияСвойствОбъектов КАК ЗначенияСвойствОбъектов
		|ГДЕ
		|	ЗначенияСвойствОбъектов.Объект = &Объект
		|	И ЗначенияСвойствОбъектов.Свойство = ЗНАЧЕНИЕ(ПланВидовХарактеристик.СвойстваОбъектов.Производитель)");
	Запрос.УстановитьПараметр("Объект", ХарСсылка);
	
	РезультатЗапроса = Запрос.Выполнить();
	Если РезультатЗапроса.Пустой() Тогда Возврат 0; КонецЕсли;
	
	ВыборкаЗапроса = РезультатЗапроса.Выбрать();
	ВыборкаЗапроса.Следующий();
	Возврат ВыборкаЗапроса.ИДПроизв;
	
КонецФункции

Функция РозничнаяЦена(ВыбНоменклатура, НаДату = '00010101') Экспорт
	
	Запрос = Новый Запрос(
		"ВЫБРАТЬ
		|	ЦеныНоменклатурыСрезПоследних.Номенклатура,
		|	ЦеныНоменклатурыСрезПоследних.Цена
		|ИЗ
		|	РегистрСведений.ЦеныНоменклатуры.СрезПоследних(
		|			&НаДату,
		|			ТорговаяТочка = ЗНАЧЕНИЕ(Справочник.СтруктурныеЕдиницы.ПустаяСсылка)
		|				И ТипЦен = ЗНАЧЕНИЕ(Справочник.ТипыЦен.ОсновнойТипЦенПродаж)
		|				И Номенклатура = &Номенклатура) КАК ЦеныНоменклатурыСрезПоследних");
	Запрос.УстановитьПараметр("НаДату", ?(НаДату = Дата(1,1,1), ТекущаяДата(), НаДату));
	Запрос.УстановитьПараметр("Номенклатура", ВыбНоменклатура);
	
	РезультатЗапроса = Запрос.Выполнить();
	Если РезультатЗапроса.Пустой() Тогда Возврат 0; КонецЕсли;
	
	ВыборкаЗапроса = РезультатЗапроса.Выбрать();
	ВыборкаЗапроса.Следующий();
	Возврат ВыборкаЗапроса.Цена;
	
КонецФункции
