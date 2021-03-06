﻿
Процедура РасчитатьДанные(ДатаНачала, ДатаОкончания) Экспорт
	
	//будем выполнять расчет понедельно
	
	ДатаОбработки = НачалоНедели(ДатаНачала);
	Пока ДатаОбработки <= КонецНедели(ДатаОкончания) Цикл
		
		НаборЗаписей = РегистрыСведений.СтатистикаПоПродажам.СоздатьНаборЗаписей();
		НаборЗаписей.Отбор.ДатаНачалаНедели.Установить(ДатаОбработки);
		
		//получим данные по продажам за период расчета
		СтрСоединенияДанныеТовародвижение = ОбменСAccess.ПолучитьСтрокуСоединения("SMS_Izbenka");
		
		пСоед = Новый ПараметрыСоединенияВнешнегоИсточникаДанных;
		пСоед.СтрокаСоединения= СтрСоединенияДанныеТовародвижение;
		ВнешниеИсточникиДанных.SMS_Izbenka.УстановитьОбщиеПараметрыСоединения(пСоед);
		ВнешниеИсточникиДанных.SMS_Izbenka.УстановитьСоединение();
		
		Запрос = Новый Запрос();
		Запрос.Текст = "ВЫБРАТЬ
		               |	dbo_CheckLine.Quantity КАК Количество,
		               |	dbo_Checks.ShopNo КАК ShopNo,
		               |	dbo_CheckLine.id_tov_cl КАК id_tov,
		               |	dbo_Checks.CloseDate КАК ДатаИВремя,
		               |	НАЧАЛОПЕРИОДА(dbo_Checks.CloseDate, ДЕНЬ) КАК Дата,
		               |	dbo_Checks.CheckUID
		               |ИЗ
		               |	ВнешнийИсточникДанных.SMS_Izbenka.Таблица.dbo_CheckLine КАК dbo_CheckLine
		               |		ВНУТРЕННЕЕ СОЕДИНЕНИЕ ВнешнийИсточникДанных.SMS_Izbenka.Таблица.dbo_Checks КАК dbo_Checks
		               |		ПО dbo_CheckLine.CheckUID = dbo_Checks.CheckUID
		               |ГДЕ
		               |	(dbo_Checks.OperationType = 1
		               |				ИЛИ dbo_Checks.OperationType = 2)
		               |	И dbo_Checks.CloseDate МЕЖДУ &ДатаНач И &ДатаКон
		               |;
		               |
		               |////////////////////////////////////////////////////////////////////////////////
		               |ВЫБРАТЬ
		               |	dbo_Checks.CheckUID,
		               |	dbo_Checks.ShopNo КАК ShopNo,
		               |	dbo_Checks.CloseDate КАК ДатаИВремя,
		               |	НАЧАЛОПЕРИОДА(dbo_Checks.CloseDate, ДЕНЬ) КАК Дата
		               |ИЗ
		               |	ВнешнийИсточникДанных.SMS_Izbenka.Таблица.dbo_Checks КАК dbo_Checks
		               |ГДЕ
		               |	(dbo_Checks.OperationType = 1
		               |			ИЛИ dbo_Checks.OperationType = 2)
		               |	И dbo_Checks.CloseDate МЕЖДУ &ДатаНач И &ДатаКон";
		
		Запрос.УстановитьПараметр("ДатаНач", НачалоНедели(ДатаОбработки));
		Запрос.УстановитьПараметр("ДатаКон", КонецНедели(ДатаОбработки));
		
		Результаты = Запрос.ВыполнитьПакет();
		ТаблицаПродаж = Результаты[0].Выгрузить();
		ТаблицаЧеки = Результаты[1].Выгрузить();
		
		ВнешниеИсточникиДанных.SMS_Izbenka.РазорватьСоединение();
		
		СтрСоединенияДанныеТовародвижение = ОбменСAccess.ПолучитьСтрокуСоединения("SMS_Union");
		
		пСоед = Новый ПараметрыСоединенияВнешнегоИсточникаДанных;
		пСоед.СтрокаСоединения= СтрСоединенияДанныеТовародвижение;
		ВнешниеИсточникиДанных.SMS_Union.УстановитьОбщиеПараметрыСоединения(пСоед);
		ВнешниеИсточникиДанных.SMS_Union.УстановитьСоединение();
		
		Запрос = Новый Запрос();
		Запрос.Текст = "ВЫБРАТЬ
		               |	dbo_CheckLine.Quantity КАК Количество,
		               |	dbo_Checks.ShopNo КАК ShopNo,
		               |	dbo_CheckLine.id_tov_cl КАК id_tov,
		               |	dbo_Checks.CloseDate КАК ДатаИВремя,
					   |	НАЧАЛОПЕРИОДА(dbo_Checks.CloseDate, ДЕНЬ) КАК Дата,
		               |	dbo_Checks.CheckUID
		               |ИЗ
		               |	ВнешнийИсточникДанных.SMS_Union.Таблица.dbo_CheckLine КАК dbo_CheckLine
		               |		ВНУТРЕННЕЕ СОЕДИНЕНИЕ ВнешнийИсточникДанных.SMS_Union.Таблица.dbo_Checks КАК dbo_Checks
		               |		ПО dbo_CheckLine.CheckUID = dbo_Checks.CheckUID
		               |ГДЕ
		               |	dbo_Checks.CloseDate МЕЖДУ &ДатаНач И &ДатаКон
		               |;
		               |
		               |////////////////////////////////////////////////////////////////////////////////
		               |ВЫБРАТЬ
		               |	dbo_Checks.CheckUID,
		               |	dbo_Checks.ShopNo КАК ShopNo,
		               |	dbo_Checks.CloseDate КАК ДатаИВремя,
		               |	НАЧАЛОПЕРИОДА(dbo_Checks.CloseDate, ДЕНЬ) КАК Дата
		               |ИЗ
		               |	ВнешнийИсточникДанных.SMS_Union.Таблица.dbo_Checks КАК dbo_Checks
		               |ГДЕ
		               |	dbo_Checks.CloseDate МЕЖДУ &ДатаНач И &ДатаКон";
		
		Запрос.УстановитьПараметр("ДатаНач", НачалоНедели(ДатаОбработки));
		Запрос.УстановитьПараметр("ДатаКон", КонецНедели(ДатаОбработки));
		
		Результаты = Запрос.ВыполнитьПакет();
		ТаблицаПродажЮнион = Результаты[0].Выгрузить();
		ТаблицаЧекиЮнион = Результаты[1].Выгрузить();
		Для Каждого СтрокаТаб Из ТаблицаПродажЮнион Цикл
			ЗаполнитьЗначенияСвойств(ТаблицаПродаж.Добавить(), СтрокаТаб);
		КонецЦикла;
		
		Для Каждого СтрокаТаб Из ТаблицаЧекиЮнион Цикл
			ЗаполнитьЗначенияСвойств(ТаблицаЧеки.Добавить(), СтрокаТаб);
		КонецЦикла;
		
		ТаблицаПродажЮнион = Неопределено;
		ТаблицаЧекиЮнион = Неопределено;
		
		ВнешниеИсточникиДанных.SMS_Union.РазорватьСоединение();
		
		Запрос.Текст = "ВЫБРАТЬ
		               |	Таб.Количество КАК Количество,
		               |	Таб.ShopNo КАК ShopNo,
		               |	Таб.CheckUID КАК CheckUID,
		               |	Таб.id_tov,
					   |	Таб.Дата КАК Дата,
		               |	Таб.ДатаИВремя КАК ДатаИВремя
		               |ПОМЕСТИТЬ ВТПродажи
		               |ИЗ
		               |	&Таб КАК Таб
		               |;
		               |
		               |////////////////////////////////////////////////////////////////////////////////
		               |ВЫБРАТЬ
		               |	Таб.ShopNo КАК ShopNo,
		               |	Таб.CheckUID КАК CheckUID,
		               |	Таб.Дата КАК Дата,
		               |	Таб.ДатаИВремя КАК ДатаИВремя
		               |ПОМЕСТИТЬ ВТЧеки
		               |ИЗ
		               |	&ТабЧеки КАК Таб
		               |;
		               |
		               |////////////////////////////////////////////////////////////////////////////////
		               |ВЫБРАТЬ
		               |	ВТПродажи.ДатаИВремя,
					   |	ВТПродажи.Дата,
		               |	ВТПродажи.CheckUID,
		               |	СтруктурныеЕдиницы.Ссылка КАК ТорговаяТочка,
		               |	Номенклатура.Ссылка КАК Номенклатура,
		               |	ВТПродажи.Количество КАК Количество
		               |ИЗ
		               |	ВТПродажи КАК ВТПродажи
		               |		ВНУТРЕННЕЕ СОЕДИНЕНИЕ Справочник.СтруктурныеЕдиницы КАК СтруктурныеЕдиницы
		               |		ПО ВТПродажи.ShopNo = СтруктурныеЕдиницы.НомерТочки
		               |		ВНУТРЕННЕЕ СОЕДИНЕНИЕ Справочник.Номенклатура КАК Номенклатура
		               |		ПО ВТПродажи.id_tov = Номенклатура.id_tov
		               |ГДЕ
		               |	ВТПродажи.ShopNo <> 0
		               |	И ВТПродажи.id_tov <> 0
		               |;
		               |
		               |////////////////////////////////////////////////////////////////////////////////
		               |ВЫБРАТЬ
		               |	ВТЧеки.Дата,
		               |	ВТЧеки.CheckUID,
		               |	ВТЧеки.ДатаИВремя,
		               |	СтруктурныеЕдиницы.Ссылка КАК ТорговаяТочка
		               |ИЗ
		               |	ВТЧеки КАК ВТЧеки
		               |		ВНУТРЕННЕЕ СОЕДИНЕНИЕ Справочник.СтруктурныеЕдиницы КАК СтруктурныеЕдиницы
		               |		ПО ВТЧеки.ShopNo = СтруктурныеЕдиницы.НомерТочки
		               |ГДЕ
		               |	ВТЧеки.ShopNo <> 0";
		
		Запрос.УстановитьПараметр("Таб", ТаблицаПродаж);
		Запрос.УстановитьПараметр("ТабЧеки", ТаблицаЧеки);
		Результаты = Запрос.ВыполнитьПакет();
		ТаблицаПродажиИтоги = Результаты[2].Выгрузить();
		ТаблицаПродажиИтоги.Индексы.Добавить("ТорговаяТочка, Номенклатура, Дата");
		ТаблицаЧекиИтоги = Результаты[3].Выгрузить();
		ТаблицаЧекиИтоги.Индексы.Добавить("ТорговаяТочка, Дата");
		
		Запрос = Новый Запрос();
		Запрос.Текст = "ВЫБРАТЬ
		               |	ЦеныНоменклатурыСрезПоследних.ТорговаяТочка,
		               |	ЦеныНоменклатурыСрезПоследних.Номенклатура,
		               |	МАКСИМУМ(ЦеныНоменклатурыСрезПоследних.Цена) КАК Цена,
		               |	МАКСИМУМ(ЦеныНоменклатурыСрезПоследних.Характеристика) КАК Характеристика
		               |ИЗ
		               |	РегистрСведений.ЦеныНоменклатуры.СрезПоследних(&ДатаНач, ТипЦен = ЗНАЧЕНИЕ(Справочник.ТипыЦен.ОсновнойТипЦенПродаж)) КАК ЦеныНоменклатурыСрезПоследних
		               |ГДЕ
		               |	(ЦеныНоменклатурыСрезПоследних.ТорговаяТочка.Активное = ИСТИНА
		               |			ИЛИ ЦеныНоменклатурыСрезПоследних.ТорговаяТочка В
		               |				(ВЫБРАТЬ
		               |					ЛистУчета.ТорговаяТочка
		               |				ИЗ
		               |					Документ.ЛистУчета КАК ЛистУчета
		               |				ГДЕ
		               |					ЛистУчета.Проведен = ИСТИНА
		               |					И ЛистУчета.Дата МЕЖДУ &ДатаНач И &ДатаКон))
		               |
		               |СГРУППИРОВАТЬ ПО
		               |	ЦеныНоменклатурыСрезПоследних.ТорговаяТочка,
		               |	ЦеныНоменклатурыСрезПоследних.Номенклатура
		               |;
		               |
		               |////////////////////////////////////////////////////////////////////////////////
		               |ВЫБРАТЬ
		               |	ЛистУчетаТовары.Номенклатура,
		               |	МАКСИМУМ(ЛистУчетаТовары.КонОстаток) КАК КонОстаток,
		               |	НАЧАЛОПЕРИОДА(ЛистУчетаТовары.Ссылка.Дата, ДЕНЬ) КАК Дата,
		               |	ЛистУчетаТовары.Ссылка.ТорговаяТочка
		               |ИЗ
		               |	Документ.ЛистУчета.Товары КАК ЛистУчетаТовары
		               |ГДЕ
		               |	ЛистУчетаТовары.Ссылка.Проведен = ИСТИНА
		               |	И ЛистУчетаТовары.Ссылка.Дата МЕЖДУ &ДатаНач И &ДатаКон
		               |
		               |СГРУППИРОВАТЬ ПО
		               |	ЛистУчетаТовары.Номенклатура,
		               |	ЛистУчетаТовары.Ссылка.ТорговаяТочка,
		               |	НАЧАЛОПЕРИОДА(ЛистУчетаТовары.Ссылка.Дата, ДЕНЬ)
		               |;
		               |
		               |////////////////////////////////////////////////////////////////////////////////
		               |ВЫБРАТЬ
		               |	СтатистикаПоПродажам.ТорговаяТочка,
		               |	СтатистикаПоПродажам.Номенклатура,
		               |	МАКСИМУМ(СтатистикаПоПродажам.Частота) КАК Частота
		               |ИЗ
		               |	РегистрСведений.СтатистикаПоПродажам КАК СтатистикаПоПродажам
		               |ГДЕ
		               |	СтатистикаПоПродажам.ДатаНачалаНедели = &ДатаПредНеделя
		               |
		               |СГРУППИРОВАТЬ ПО
		               |	СтатистикаПоПродажам.ТорговаяТочка,
		               |	СтатистикаПоПродажам.Номенклатура";
					   
		Запрос.УстановитьПараметр("ДатаНач", НачалоНедели(ДатаОбработки));
		Запрос.УстановитьПараметр("ДатаКон", КонецНедели(ДатаОбработки));
		Запрос.УстановитьПараметр("ДатаПредНеделя", НачалоНедели(ДатаОбработки) - 86400 * 7);
		Результаты = Запрос.ВыполнитьПакет();
		Выборка = Результаты[0].Выбрать();
		ТоварыПоЛистамУчета = Результаты[1].Выгрузить();
		ТоварыПоЛистамУчета.Индексы.Добавить("ТорговаяТочка, Номенклатура, Дата");
		
		ЧастотаПредНедели = Результаты[2].Выгрузить();
		ЧастотаПредНедели.Индексы.Добавить("ТорговаяТочка, Номенклатура");
		
		//произведем сначала расчет частоты продаж
		ТаблицаЧастотыПоНоменклатуре = Новый ТаблицаЗначений();
		ТаблицаЧастотыПоНоменклатуре.Колонки.Добавить("ТорговаяТочка");
		ТаблицаЧастотыПоНоменклатуре.Колонки.Добавить("Номенклатура");
		ТаблицаЧастотыПоНоменклатуре.Колонки.Добавить("Частота");
		ТаблицаЧастотыПоНоменклатуре.Колонки.Добавить("ЧастотаВзятаСПредыдущейНедели");
		ТаблицаЧастотыПоНоменклатуре.Колонки.Добавить("КоличествоПродано", Новый ОписаниеТипов("Число"));
		ТаблицаЧастотыПоНоменклатуре.Колонки.Добавить("КоличествоЧеков", Новый ОписаниеТипов("Число")); //общее количество чеков, когда товар был на точке
		ТаблицаСтатистики = Новый ТаблицаЗначений();
		ТаблицаСтатистики.Колонки.Добавить("ТорговаяТочка");
		ТаблицаСтатистики.Колонки.Добавить("Номенклатура");
		ТаблицаСтатистики.Колонки.Добавить("Дата");
		ТаблицаСтатистики.Колонки.Добавить("ДатаПоследнегоЧека");
		ТаблицаСтатистики.Колонки.Добавить("КоличествоЧековПослеПоследнего");
		ТаблицаСтатистики.Колонки.Добавить("ОбщееКоличествоЧеков");
		ТаблицаСтатистики.Колонки.Добавить("ОстатокНаКонецДня");
		ТаблицаСтатистики.Колонки.Добавить("КоличествоПродано");
		ТаблицаСтатистики.Колонки.Добавить("Производитель");
		Пока Выборка.СледующийПоЗначениюПоля("ТорговаяТочка") Цикл
			Пока Выборка.СледующийПоЗначениюПоля("Номенклатура") Цикл
				Если Выборка.Цена <= 0 Тогда
					Продолжить;
				КонецЕсли;
				СтрокаСДаннымиЧастоты = ТаблицаЧастотыПоНоменклатуре.Добавить();
				СтрокаСДаннымиЧастоты.ТорговаяТочка = Выборка.ТорговаяТочка;
				СтрокаСДаннымиЧастоты.Номенклатура = Выборка.Номенклатура;
				СтрокаСДаннымиЧастоты.КоличествоПродано = 0;
				СтрокаСДаннымиЧастоты.КоличествоЧеков = 0;
				
				Для н = 0 По 6 Цикл //расчет по всем дня недели
					
					СтрокаСтатистики = ТаблицаСтатистики.Добавить();
					СтрокаСтатистики.ТорговаяТочка = Выборка.ТорговаяТочка;
					СтрокаСтатистики.Номенклатура = Выборка.Номенклатура;
					СтрокаСтатистики.Дата = ДатаОбработки + 86400*н;
					СтрокаСтатистики.ДатаПоследнегоЧека = '00010101';
					СтрокаСтатистики.КоличествоЧековПослеПоследнего = 0;
					СтрокаСтатистики.ОбщееКоличествоЧеков = 0;
					СтрокаСтатистики.КоличествоПродано = 0;
					СтрокаСтатистики.Производитель = Выборка.Характеристика;
					
					СтрокиПоЛистамУчета = ТоварыПоЛистамУчета.НайтиСтроки(Новый Структура("ТорговаяТочка, Номенклатура, Дата", Выборка.ТорговаяТочка, Выборка.Номенклатура, ДатаОбработки + 86400*н));
					ОстатокНаКонецДня = 0;
					Если СтрокиПоЛистамУчета.Количество() = 0 Тогда
						ОстатокНаКонецДня = 0;
					Иначе	
						ОстатокНаКонецДня = СтрокиПоЛистамУчета[0].КонОстаток;
					КонецЕсли;
					СтрокиЧеков = ТаблицаЧекиИтоги.НайтиСтроки(Новый Структура("ТорговаяТочка, Дата", Выборка.ТорговаяТочка, ДатаОбработки + 86400*н));
					СтрокиПродаж = ТаблицаПродажиИтоги.НайтиСтроки(Новый Структура("ТорговаяТочка, Номенклатура, Дата", Выборка.ТорговаяТочка, Выборка.Номенклатура, ДатаОбработки + 86400*н));
					СтрокаСтатистики.ОстатокНаКонецДня = ?(ОстатокНаКонецДня < 0, 0, ОстатокНаКонецДня);
					СтрокаСтатистики.ОбщееКоличествоЧеков = СтрокиЧеков.Количество();
					Если ОстатокНаКонецДня <= 0 Тогда
						//надо найти чек с последней продажей и посчитать общее количество чеков до этого времени
						МаксВремя = '00010101';
						Для Каждого СтрокаПродажа Из СтрокиПродаж Цикл
							СтрокаСДаннымиЧастоты.КоличествоПродано = СтрокаСДаннымиЧастоты.КоличествоПродано + СтрокаПродажа.Количество;
							СтрокаСтатистики.КоличествоПродано = СтрокаСтатистики.КоличествоПродано + СтрокаПродажа.Количество;
							МаксВремя = Макс(МаксВремя, СтрокаПродажа.ДатаИВремя);
						КонецЦикла;
						СтрокаСтатистики.ДатаПоследнегоЧека = МаксВремя;
						КолвоЧековПослеПоследнего = 0;
						Для Каждого СтрокаЧека Из СтрокиЧеков Цикл
							Если СтрокаЧека.ДатаИВремя <= МаксВремя Тогда
								СтрокаСДаннымиЧастоты.КоличествоЧеков = СтрокаСДаннымиЧастоты.КоличествоЧеков + 1;
							Иначе
								КолвоЧековПослеПоследнего = КолвоЧековПослеПоследнего + 1;
							КонецЕсли;	
						КонецЦикла;
						СтрокаСтатистики.КоличествоЧековПослеПоследнего = КолвоЧековПослеПоследнего;
					Иначе
						МаксВремя = '00010101';
						Для Каждого СтрокаПродажа Из СтрокиПродаж Цикл
							СтрокаСДаннымиЧастоты.КоличествоПродано = СтрокаСДаннымиЧастоты.КоличествоПродано + СтрокаПродажа.Количество;
							СтрокаСтатистики.КоличествоПродано = СтрокаСтатистики.КоличествоПродано + СтрокаПродажа.Количество;
							МаксВремя = Макс(МаксВремя, СтрокаПродажа.ДатаИВремя);
						КонецЦикла;
						СтрокаСтатистики.ДатаПоследнегоЧека = МаксВремя;
						СтрокаСДаннымиЧастоты.КоличествоЧеков = СтрокаСДаннымиЧастоты.КоличествоЧеков + СтрокиЧеков.Количество();
					КонецЕсли;	
				КонецЦикла;	
			КонецЦикла;	
		КонецЦикла;	
		
		//окончательный расчет частоты продаж
		Для Каждого СтрокаЧастоты Из ТаблицаЧастотыПоНоменклатуре Цикл
			Если СтрокаЧастоты.КоличествоЧеков <= 200 Тогда
				СтрокиЧастота = ЧастотаПредНедели.НайтиСтроки(Новый Структура("ТорговаяТочка, Номенклатура", СтрокаЧастоты.ТорговаяТочка, СтрокаЧастоты.Номенклатура));
				Если СтрокиЧастота.Количество() > 0 Тогда
					СтрокаЧастоты.Частота = СтрокиЧастота[0].Частота;
					СтрокаЧастоты.ЧастотаВзятаСПредыдущейНедели = Истина;
				Иначе
					СтрокаЧастоты.Частота = ?(СтрокаЧастоты.КоличествоЧеков = 0, 0, СтрокаЧастоты.КоличествоПродано / СтрокаЧастоты.КоличествоЧеков);
					СтрокаЧастоты.ЧастотаВзятаСПредыдущейНедели = Ложь;
				КонецЕсли;	
			Иначе	
				СтрокаЧастоты.Частота = ?(СтрокаЧастоты.КоличествоЧеков = 0, 0, СтрокаЧастоты.КоличествоПродано / СтрокаЧастоты.КоличествоЧеков);
				СтрокаЧастоты.ЧастотаВзятаСПредыдущейНедели = Ложь;
			КонецЕсли;	
		КонецЦикла;	
		
		ТаблицаЧастотыПоНоменклатуре.Индексы.Добавить("ТорговаяТочка, Номенклатура");
		
		Для Каждого СтрокаСтатистики Из ТаблицаСтатистики Цикл
			Движение = НаборЗаписей.Добавить();
			Движение.Период = СтрокаСтатистики.Дата;
			Движение.ТорговаяТочка = СтрокаСтатистики.ТорговаяТочка;
			Движение.Номенклатура = СтрокаСтатистики.Номенклатура;
			Движение.ДатаНачалаНедели = ДатаОбработки;
			Движение.ОстатокТовараНаКонецДня = СтрокаСтатистики.ОстатокНаКонецДня;
			Движение.ВремяПоследнегоЧекаСТоваром = СтрокаСтатистики.ДатаПоследнегоЧека;
			Движение.КоличествоЧековВПериодОтсутствия = СтрокаСтатистики.КоличествоЧековПослеПоследнего;
			Движение.ОбщееКоличествоЧековЗаДень = СтрокаСтатистики.ОбщееКоличествоЧеков;
			Движение.КоличествоПродано = СтрокаСтатистики.КоличествоПродано;
			СтрокиЧастоты = ТаблицаЧастотыПоНоменклатуре.НайтиСтроки(Новый Структура("ТорговаяТочка, Номенклатура", СтрокаСтатистики.ТорговаяТочка, СтрокаСтатистики.Номенклатура));
			Если СтрокиЧастоты.Количество() > 0 Тогда
				Движение.Частота = СтрокиЧастоты[0].Частота;
			КонецЕсли;	
			Движение.Характеристика = СтрокаСтатистики.Производитель;
			Движение.ЧастотаВзятаСПредыдущейНедели = СтрокиЧастоты[0].ЧастотаВзятаСПредыдущейНедели;
		КонецЦикла;	
		
		НаборЗаписей.Записать();
		
		ДатаОбработки = ДатаОбработки + 86400 * 7;
	КонецЦикла;
	
КонецПроцедуры

Процедура РасчитатьПотериТип6(ДатаНачала, ДатаОкончания) Экспорт
	
	//определим номенклатуры, которые не следует обрабатывать
	Запрос = Новый Запрос();
	Запрос.Текст = "ВЫБРАТЬ
	               |	Номенклатура.Ссылка,
	               |	Номенклатура.Порядок
	               |ИЗ
	               |	Справочник.Номенклатура КАК Номенклатура
	               |ГДЕ
	               |	Номенклатура.ЭтоГруппа = ЛОЖЬ";
				   
	ТабНоменклатура = Запрос.Выполнить().Выгрузить();
	
	КолвоСтрок = ТабНоменклатура.Количество();
	Для н = 1 По КолвоСтрок Цикл
		Если ТабНоменклатура[КолвоСтрок - н].Порядок = 0 Тогда
			Продолжить;
		КонецЕсли;
		Если Цел(ТабНоменклатура[КолвоСтрок - н].Порядок) <> ТабНоменклатура[КолвоСтрок - н].Порядок Тогда
			Продолжить;
		КонецЕсли;
		ТабНоменклатура.Удалить(КолвоСтрок - н);
	КонецЦикла;	
	
	ДатаОбработки = НачалоДня(ДатаНачала);
	Пока ДатаОбработки <= ДатаОкончания Цикл
		Набор = РегистрыСведений.ПотерянныеПродажиПоТочкам.СоздатьНаборЗаписей();
		Набор.Отбор.Дата.Установить(ДатаОбработки);
		Набор.Отбор.ТипПотери.Установить(Перечисления.ТипыПотерь.Значение6);
		Запрос = Новый Запрос();
		Запрос.Текст = "ВЫБРАТЬ
		               |	Таб.Ссылка КАК Ссылка
		               |ПОМЕСТИТЬ ВТ_НоменклатураИсключить
		               |ИЗ
		               |	&Таб КАК Таб
		               |
		               |ИНДЕКСИРОВАТЬ ПО
		               |	Ссылка
		               |;
		               |
		               |////////////////////////////////////////////////////////////////////////////////
		               |ВЫБРАТЬ РАЗЛИЧНЫЕ
		               |	ВЗ_Данные.ТорговаяТочка,
		               |	ЕСТЬNULL(КолвоЧековПоТочкам.ОбщееКоличествоЧековЗаДень, 0) КАК ОбщееКоличествоЧековЗаДень
		               |ИЗ
		               |	(ВЫБРАТЬ
		               |		ЦеныНоменклатурыСрезПоследних.ТорговаяТочка КАК ТорговаяТочка,
		               |		МАКСИМУМ(ЦеныНоменклатурыСрезПоследних.Цена) КАК Цена
		               |	ИЗ
		               |		РегистрСведений.ЦеныНоменклатуры.СрезПоследних(&Дата, ТипЦен = ЗНАЧЕНИЕ(Справочник.ТипыЦен.ОсновнойТипЦенПродаж)) КАК ЦеныНоменклатурыСрезПоследних
		               |	ГДЕ
		               |		(ЦеныНоменклатурыСрезПоследних.ТорговаяТочка.Активное = ИСТИНА
		               |				ИЛИ ЦеныНоменклатурыСрезПоследних.ТорговаяТочка В
		               |					(ВЫБРАТЬ
		               |						ЛистУчета.ТорговаяТочка
		               |					ИЗ
		               |						Документ.ЛистУчета КАК ЛистУчета
		               |					ГДЕ
		               |						ЛистУчета.Проведен = ИСТИНА
		               |						И ЛистУчета.Дата МЕЖДУ &ДатаНач И &ДатаКон))
		               |		И НЕ ЦеныНоменклатурыСрезПоследних.Номенклатура В
		               |					(ВЫБРАТЬ
		               |						Таб.Ссылка
		               |					ИЗ
		               |						ВТ_НоменклатураИсключить КАК Таб)
		               |	
		               |	СГРУППИРОВАТЬ ПО
		               |		ЦеныНоменклатурыСрезПоследних.ТорговаяТочка) КАК ВЗ_Данные
		               |		ЛЕВОЕ СОЕДИНЕНИЕ (ВЫБРАТЬ РАЗЛИЧНЫЕ
		               |			СтатистикаПоПродажам.ТорговаяТочка КАК ТорговаяТочка,
		               |			СтатистикаПоПродажам.ОбщееКоличествоЧековЗаДень КАК ОбщееКоличествоЧековЗаДень
		               |		ИЗ
		               |			РегистрСведений.СтатистикаПоПродажам КАК СтатистикаПоПродажам
		               |		ГДЕ
		               |			НАЧАЛОПЕРИОДА(СтатистикаПоПродажам.Период, ДЕНЬ) = НАЧАЛОПЕРИОДА(&Дата, ДЕНЬ)) КАК КолвоЧековПоТочкам
		               |		ПО ВЗ_Данные.ТорговаяТочка = КолвоЧековПоТочкам.ТорговаяТочка
		               |ГДЕ
		               |	ВЗ_Данные.Цена > 0
		               |;
		               |
		               |////////////////////////////////////////////////////////////////////////////////
		               |ВЫБРАТЬ РАЗЛИЧНЫЕ
		               |	ВЗ_Данные.Номенклатура
		               |ИЗ
		               |	(ВЫБРАТЬ
		               |		ЦеныНоменклатурыСрезПоследних.Номенклатура КАК Номенклатура,
		               |		МАКСИМУМ(ЦеныНоменклатурыСрезПоследних.Цена) КАК Цена
		               |	ИЗ
		               |		РегистрСведений.ЦеныНоменклатуры.СрезПоследних(&Дата, ТипЦен = ЗНАЧЕНИЕ(Справочник.ТипыЦен.ОсновнойТипЦенПродаж)) КАК ЦеныНоменклатурыСрезПоследних
		               |	ГДЕ
		               |		(ЦеныНоменклатурыСрезПоследних.ТорговаяТочка.Активное = ИСТИНА
		               |				ИЛИ ЦеныНоменклатурыСрезПоследних.ТорговаяТочка В
		               |					(ВЫБРАТЬ
		               |						ЛистУчета.ТорговаяТочка
		               |					ИЗ
		               |						Документ.ЛистУчета КАК ЛистУчета
		               |					ГДЕ
		               |						ЛистУчета.Проведен = ИСТИНА
		               |						И ЛистУчета.Дата МЕЖДУ &ДатаНач И &ДатаКон))
		               |		И НЕ ЦеныНоменклатурыСрезПоследних.Номенклатура В
		               |					(ВЫБРАТЬ
		               |						Таб.Ссылка
		               |					ИЗ
		               |						ВТ_НоменклатураИсключить КАК Таб)
		               |	
		               |	СГРУППИРОВАТЬ ПО
		               |		ЦеныНоменклатурыСрезПоследних.Номенклатура) КАК ВЗ_Данные
		               |ГДЕ
		               |	ВЗ_Данные.Цена > 0
		               |;
		               |
		               |////////////////////////////////////////////////////////////////////////////////
		               |ВЫБРАТЬ
		               |	ВЗ_Данные.ТорговаяТочка,
		               |	ВЗ_Данные.Номенклатура,
		               |	ВЗ_Данные.Цена
		               |ИЗ
		               |	(ВЫБРАТЬ
		               |		ЦеныНоменклатурыСрезПоследних.ТорговаяТочка КАК ТорговаяТочка,
		               |		ЦеныНоменклатурыСрезПоследних.Номенклатура КАК Номенклатура,
		               |		МАКСИМУМ(ЦеныНоменклатурыСрезПоследних.Цена) КАК Цена
		               |	ИЗ
		               |		РегистрСведений.ЦеныНоменклатуры.СрезПоследних(&Дата, ТипЦен = ЗНАЧЕНИЕ(Справочник.ТипыЦен.ОсновнойТипЦенПродаж)) КАК ЦеныНоменклатурыСрезПоследних
		               |	ГДЕ
		               |		(ЦеныНоменклатурыСрезПоследних.ТорговаяТочка.Активное = ИСТИНА
		               |				ИЛИ ЦеныНоменклатурыСрезПоследних.ТорговаяТочка В
		               |					(ВЫБРАТЬ
		               |						ЛистУчета.ТорговаяТочка
		               |					ИЗ
		               |						Документ.ЛистУчета КАК ЛистУчета
		               |					ГДЕ
		               |						ЛистУчета.Проведен = ИСТИНА
		               |						И ЛистУчета.Дата МЕЖДУ &ДатаНач И &ДатаКон))
		               |		И НЕ ЦеныНоменклатурыСрезПоследних.Номенклатура В
		               |					(ВЫБРАТЬ
		               |						Таб.Ссылка
		               |					ИЗ
		               |						ВТ_НоменклатураИсключить КАК Таб)
		               |	
		               |	СГРУППИРОВАТЬ ПО
		               |		ЦеныНоменклатурыСрезПоследних.ТорговаяТочка,
		               |		ЦеныНоменклатурыСрезПоследних.Номенклатура) КАК ВЗ_Данные
		               |ГДЕ
		               |	ВЗ_Данные.Цена > 0
		               |;
		               |
		               |////////////////////////////////////////////////////////////////////////////////
		               |ВЫБРАТЬ
		               |	СтатистикаПоПродажам.ТорговаяТочка,
		               |	СтатистикаПоПродажам.Номенклатура,
		               |	СтатистикаПоПродажам.Частота,
		               |	СтатистикаПоПродажам.ОбщееКоличествоЧековЗаДень,
		               |	СтатистикаПоПродажам.КоличествоЧековВПериодОтсутствия,
		               |	СтатистикаПоПродажам.КоличествоПродано
		               |ИЗ
		               |	РегистрСведений.СтатистикаПоПродажам КАК СтатистикаПоПродажам
		               |ГДЕ
		               |	НАЧАЛОПЕРИОДА(СтатистикаПоПродажам.Период, ДЕНЬ) = НАЧАЛОПЕРИОДА(&Дата, ДЕНЬ)
		               |	И НЕ СтатистикаПоПродажам.Номенклатура В
		               |				(ВЫБРАТЬ
		               |					Таб.Ссылка
		               |				ИЗ
		               |					ВТ_НоменклатураИсключить КАК Таб)
		               |;
		               |
		               |////////////////////////////////////////////////////////////////////////////////
		               |УНИЧТОЖИТЬ ВТ_НоменклатураИсключить";
					   
		Запрос.УстановитьПараметр("Дата", КонецДня(ДатаОбработки));
		Запрос.УстановитьПараметр("ДатаНач", НачалоДня(ДатаОбработки));
		Запрос.УстановитьПараметр("ДатаКон", КонецДня(ДатаОбработки));
		Запрос.УстановитьПараметр("Таб", ТабНоменклатура);
		Результаты = Запрос.ВыполнитьПакет();
		
		ВыборкаТорговыхТочек = Результаты[1].Выбрать();
		ВыборкаНоменклатуры = Результаты[2].Выбрать();
		ТаблицаПрайс = Результаты[3].Выгрузить();
		ТаблицаПрайс.Индексы.Добавить("ТорговаяТочка, Номенклатура");
		ТаблицаПрайс.Индексы.Добавить("Номенклатура");
		ТаблицаСтатистика = Результаты[4].Выгрузить();
		ТаблицаСтатистика.Индексы.Добавить("Номенклатура");
		
		Пока ВыборкаТорговыхТочек.Следующий() Цикл
			Пока ВыборкаНоменклатуры.Следующий() Цикл
				//если в прайсе у точки есть цена на эту номенклатуру, то пропускаем расчет данной потери
				СтрокиПрайса = ТаблицаПрайс.НайтиСтроки(Новый Структура("ТорговаяТочка, Номенклатура", ВыборкаТорговыхТочек.ТорговаяТочка, ВыборкаНоменклатуры.Номенклатура));
				Цена = 0;
				Для Каждого СтрокаПрайса Из СтрокиПрайса Цикл
					Цена = Макс(Цена, СтрокаПрайса.Цена);
				КонецЦикла;
				Если Цена > 0 Тогда
					Продолжить;
				КонецЕсли;
				КоличествоЧеков = 0;
				КоличествоПродано = 0;
				СтрокиПрайса = ТаблицаПрайс.НайтиСтроки(Новый Структура("Номенклатура", ВыборкаНоменклатуры.Номенклатура));
				МассивТоргТочек = Новый Массив();
				СуммаЦен = 0;
				Для Каждого СтрокаПрайса Из СтрокиПрайса Цикл
					Если СтрокаПрайса.Цена > 0 
						И СтрокаПрайса.ТорговаяТочка <> ВыборкаТорговыхТочек.ТорговаяТочка Тогда
						МассивТоргТочек.Добавить(СтрокаПрайса.ТорговаяТочка);
						СуммаЦен = СуммаЦен + СтрокаПрайса.Цена;
					КонецЕсли;	
				КонецЦикла;
				Если МассивТоргТочек.Количество() = 0 Тогда
					Продолжить;
				КонецЕсли;	
				СредняяЦена = СуммаЦен / МассивТоргТочек.Количество();
				СтрокиСтатистики = ТаблицаСтатистика.НайтиСтроки(Новый Структура("Номенклатура", ВыборкаНоменклатуры.Номенклатура));
				//расчитаем среднюю частоту продаж по всем торговым точкам
				Для Каждого СтрокаСтатистики Из СтрокиСтатистики Цикл
					Если МассивТоргТочек.Найти(СтрокаСтатистики.ТорговаяТочка) = Неопределено Тогда
						Продолжить;
					КонецЕсли;	
					КоличествоЧеков = КоличествоЧеков + ?(СтрокаСтатистики.ОбщееКоличествоЧековЗаДень <= СтрокаСтатистики.КоличествоЧековВПериодОтсутствия, 0, СтрокаСтатистики.ОбщееКоличествоЧековЗаДень - СтрокаСтатистики.КоличествоЧековВПериодОтсутствия);
					КоличествоПродано = КоличествоПродано + СтрокаСтатистики.КоличествоПродано;
				КонецЦикла;
				СредняяЧастота = ?(КоличествоЧеков = 0, 0, КоличествоПродано / КоличествоЧеков);
				
				Движение = Набор.Добавить();
				Движение.Дата = ДатаОбработки;
				Движение.ТорговаяТочка = ВыборкаТорговыхТочек.ТорговаяТочка;
				Движение.Номенклатура = ВыборкаНоменклатуры.Номенклатура;
				Движение.ТипПотери = Перечисления.ТипыПотерь.Значение6;
				Движение.Количество = СредняяЧастота * ВыборкаТорговыхТочек.ОбщееКоличествоЧековЗаДень;
				Движение.Сумма = СредняяЦена * Движение.Количество;
			КонецЦикла;	
		КонецЦикла;	
		
		ТабКЗаписи = Набор.Выгрузить();
		КолвоСтрок = ТабКЗаписи.Количество();
		Для н = 1 По КолвоСтрок Цикл
			Если ТабКЗаписи[КолвоСтрок - н].Сумма = 0 Тогда
				ТабКЗаписи.Удалить(КолвоСтрок - н);
			КонецЕсли;	
		КонецЦикла;
		Набор.Загрузить(ТабКЗаписи);
		Набор.Записать();
		
		ДатаОбработки = ДатаОбработки + 86400;
	КонецЦикла;
	
КонецПроцедуры	

Процедура РасчитатьПотериТип1(ДатаНачала, ДатаОкончания) Экспорт
	
	//определим номенклатуры, которые не следует обрабатывать
	Запрос = Новый Запрос();
	Запрос.Текст = "ВЫБРАТЬ
	               |	Номенклатура.Ссылка,
	               |	Номенклатура.Порядок
	               |ИЗ
	               |	Справочник.Номенклатура КАК Номенклатура
	               |ГДЕ
	               |	Номенклатура.ЭтоГруппа = ЛОЖЬ";
				   
	ТабНоменклатура = Запрос.Выполнить().Выгрузить();
	
	КолвоСтрок = ТабНоменклатура.Количество();
	Для н = 1 По КолвоСтрок Цикл
		Если ТабНоменклатура[КолвоСтрок - н].Порядок = 0 Тогда
			Продолжить;
		КонецЕсли;
		Если Цел(ТабНоменклатура[КолвоСтрок - н].Порядок) <> ТабНоменклатура[КолвоСтрок - н].Порядок Тогда
			Продолжить;
		КонецЕсли;
		ТабНоменклатура.Удалить(КолвоСтрок - н);
	КонецЦикла;	
	
	ДатаОбработки = НачалоДня(ДатаНачала);
	Пока ДатаОбработки <= ДатаОкончания Цикл
		Набор = РегистрыСведений.ПотерянныеПродажиПоТочкам.СоздатьНаборЗаписей();
		Набор.Отбор.Дата.Установить(ДатаОбработки);
		Набор.Отбор.ТипПотери.Установить(Перечисления.ТипыПотерь.Значение1);
		Запрос = Новый Запрос();
		Запрос.Текст = "ВЫБРАТЬ
		               |	Таб.Ссылка КАК Ссылка
		               |ПОМЕСТИТЬ ВТ_НоменклатураИсключить
		               |ИЗ
		               |	&Таб КАК Таб
		               |
		               |ИНДЕКСИРОВАТЬ ПО
		               |	Ссылка
		               |;
		               |
		               |////////////////////////////////////////////////////////////////////////////////
		               |ВЫБРАТЬ
		               |	ВЗ_Данные.ТорговаяТочка,
		               |	ВЗ_Данные.Номенклатура,
		               |	ВЗ_Данные.Цена,
		               |	ЕСТЬNULL(ВЗ_Статистика.КоличествоЧековВПериодОтсутствия, 0) КАК КоличествоЧековВПериодОтсутствия,
		               |	ЕСТЬNULL(ВЗ_Статистика.Частота, 0) КАК Частота
		               |ИЗ
		               |	(ВЫБРАТЬ
		               |		ЦеныНоменклатурыСрезПоследних.ТорговаяТочка КАК ТорговаяТочка,
		               |		ЦеныНоменклатурыСрезПоследних.Номенклатура КАК Номенклатура,
		               |		МАКСИМУМ(ЦеныНоменклатурыСрезПоследних.Цена) КАК Цена
		               |	ИЗ
		               |		РегистрСведений.ЦеныНоменклатуры.СрезПоследних(&Дата, ТипЦен = ЗНАЧЕНИЕ(Справочник.ТипыЦен.ОсновнойТипЦенПродаж)) КАК ЦеныНоменклатурыСрезПоследних
		               |	ГДЕ
		               |		(ЦеныНоменклатурыСрезПоследних.ТорговаяТочка.Активное = ИСТИНА
		               |				ИЛИ ЦеныНоменклатурыСрезПоследних.ТорговаяТочка В
		               |					(ВЫБРАТЬ
		               |						ЛистУчета.ТорговаяТочка
		               |					ИЗ
		               |						Документ.ЛистУчета КАК ЛистУчета
		               |					ГДЕ
		               |						ЛистУчета.Проведен = ИСТИНА
		               |						И ЛистУчета.Дата МЕЖДУ &ДатаНач И &ДатаКон))
		               |		И НЕ ЦеныНоменклатурыСрезПоследних.Номенклатура В
		               |					(ВЫБРАТЬ
		               |						Таб.Ссылка
		               |					ИЗ
		               |						ВТ_НоменклатураИсключить КАК Таб)
		               |	
		               |	СГРУППИРОВАТЬ ПО
		               |		ЦеныНоменклатурыСрезПоследних.ТорговаяТочка,
		               |		ЦеныНоменклатурыСрезПоследних.Номенклатура) КАК ВЗ_Данные
		               |		ЛЕВОЕ СОЕДИНЕНИЕ (ВЫБРАТЬ
		               |			СтатистикаПоПродажам.ТорговаяТочка КАК ТорговаяТочка,
		               |			СтатистикаПоПродажам.Номенклатура КАК Номенклатура,
		               |			СтатистикаПоПродажам.Частота КАК Частота,
		               |			СтатистикаПоПродажам.ОбщееКоличествоЧековЗаДень КАК ОбщееКоличествоЧековЗаДень,
		               |			СтатистикаПоПродажам.КоличествоЧековВПериодОтсутствия КАК КоличествоЧековВПериодОтсутствия,
		               |			СтатистикаПоПродажам.КоличествоПродано КАК КоличествоПродано
		               |		ИЗ
		               |			РегистрСведений.СтатистикаПоПродажам КАК СтатистикаПоПродажам
		               |		ГДЕ
		               |			НАЧАЛОПЕРИОДА(СтатистикаПоПродажам.Период, ДЕНЬ) = НАЧАЛОПЕРИОДА(&Дата, ДЕНЬ)
		               |			И НЕ СтатистикаПоПродажам.Номенклатура В
		               |						(ВЫБРАТЬ
		               |							Таб.Ссылка
		               |						ИЗ
		               |							ВТ_НоменклатураИсключить КАК Таб)) КАК ВЗ_Статистика
		               |		ПО ВЗ_Данные.ТорговаяТочка = ВЗ_Статистика.ТорговаяТочка
		               |			И ВЗ_Данные.Номенклатура = ВЗ_Статистика.Номенклатура
		               |ГДЕ
		               |	ВЗ_Данные.Цена > 0
		               |;
		               |
		               |////////////////////////////////////////////////////////////////////////////////
		               |УНИЧТОЖИТЬ ВТ_НоменклатураИсключить";
					   
		Запрос.УстановитьПараметр("Дата", КонецДня(ДатаОбработки));
		Запрос.УстановитьПараметр("ДатаНач", НачалоДня(ДатаОбработки));
		Запрос.УстановитьПараметр("ДатаКон", КонецДня(ДатаОбработки));
		Запрос.УстановитьПараметр("Таб", ТабНоменклатура);
		Результаты = Запрос.ВыполнитьПакет();
		
		ВыборкаПоПрайсу = Результаты[1].Выбрать();
		
		Пока ВыборкаПоПрайсу.Следующий() Цикл
			Если ВыборкаПоПрайсу.Цена = 0 ИЛИ ВыборкаПоПрайсу.КоличествоЧековВПериодОтсутствия <= 0 Тогда
				Продолжить;
			КонецЕсли;
			
			Движение = Набор.Добавить();
			Движение.Дата = ДатаОбработки;
			Движение.ТорговаяТочка = ВыборкаПоПрайсу.ТорговаяТочка;
			Движение.Номенклатура = ВыборкаПоПрайсу.Номенклатура;
			Движение.ТипПотери = Перечисления.ТипыПотерь.Значение1;
			Движение.Количество = ВыборкаПоПрайсу.Частота * ВыборкаПоПрайсу.КоличествоЧековВПериодОтсутствия;
			Движение.Сумма = ВыборкаПоПрайсу.Цена * Движение.Количество;
		КонецЦикла;	
		
		ТабКЗаписи = Набор.Выгрузить();
		КолвоСтрок = ТабКЗаписи.Количество();
		Для н = 1 По КолвоСтрок Цикл
			Если ТабКЗаписи[КолвоСтрок - н].Сумма = 0 Тогда
				ТабКЗаписи.Удалить(КолвоСтрок - н);
			КонецЕсли;	
		КонецЦикла;
		Набор.Загрузить(ТабКЗаписи);
		Набор.Записать();
		
		ДатаОбработки = ДатаОбработки + 86400;
	КонецЦикла;
	
КонецПроцедуры	

	