﻿&НаКлиенте
Перем ПеретаскиваниеВДатчикиЗавершено;

&НаКлиенте
Перем ПеретаскиваниеВНепривязаныеОСЗавершено;


&НаСервере
Процедура ПолучитьДанныеПоДатчикамSQL()
	
	ADOСоединение = ВнешниеДанные.ПолучитьADOСоединение();
	
	ТекстЗапросаSQL = "EXEC	[M2].[dbo].[FOR1C_GetSensorData] "+ ВнешниеДанные.ФорматПоля(НаДату, Истина);
	
	RecordSet = ADOСоединение.Execute(ТекстЗапросаSQL);
	
	Пока RecordSet <> Неопределено И RecordSet.Fields.Count <= 0 Цикл
		RecordSet = RecordSet.NextRecordSet();
	КонецЦикла;
	
	// Модели
	ТаблицаМоделей = ВнешниеДанные.ПреобразоватьРезультатВТаблицуЗначений(RecordSet);
	
	Обработки.КорректировкаСостоянияДатчиковИХолодильников.ОбновитьМоделиИзSQL(ТаблицаМоделей);
	
	// Датчики
	RecordSet = RecordSet.NextRecordSet();
	
	ТаблицаДатчиков = ВнешниеДанные.ПреобразоватьРезультатВТаблицуЗначений(RecordSet);
	
	Обработки.КорректировкаСостоянияДатчиковИХолодильников.ОбновитьДатчикиИзSQL(ТаблицаДатчиков);
	
	// Привязки датчиков к моделям
	RecordSet = RecordSet.NextRecordSet();
	
	ТаблицаДанных = ВнешниеДанные.ПреобразоватьРезультатВТаблицуЗначений(RecordSet);
	
	АдресТаблицыДанных	= ПоместитьВоВременноеХранилище(ТаблицаДанных, УникальныйИдентификатор);
	
	RecordSet.Close();
	
	ADOСоединение.Close();
	
КонецПроцедуры

&НаСервере
Процедура СопоставитьПоПараметрамОтбора(ПараметрыОтбора, ТипПривязки, ПроверятьДатуВводаВЭксплуатацию = Ложь)
	
	Для Каждого Строка ИЗ Датчики Цикл
		Если НЕ ЗначениеЗаполнено(Строка.Датчик) ИЛИ НЕ ЗначениеЗаполнено(Строка.Модель) ИЛИ НЕ ЗначениеЗаполнено(Строка.ТТ) Тогда
			Продолжить;
			//
		КонецЕсли; 
		
		Если ЗначениеЗаполнено(Строка.ОС) Тогда
			Продолжить;
		КонецЕсли; 
		
		ЗаполнитьЗначенияСвойств(ПараметрыОтбора, Строка);
		
		НайденныеСтроки = НепривязанныеОС.НайтиСтроки(ПараметрыОтбора);
		
		Для Каждого СтрокаПривязки ИЗ НайденныеСтроки Цикл
			Если ПроверятьДатуВводаВЭксплуатацию И (СтрокаПривязки.ДатаВводаВЭксплуатацию < Строка.ДатаНачалаРаботыТТ ИЛИ НЕ ЗначениеЗаполнено(Строка.ДатаНачалаРаботыТТ)) Тогда
				Продолжить;
			КонецЕсли; 			

			Строка.ОС = СтрокаПривязки.ОС;			
			Строка.ОС_ИнвентарныйНомер = СтрокаПривязки.ИнвентарныйНомер;						
			Строка.ОС_ТТ = СтрокаПривязки.ТТ;			
			Строка.ОС_Модель = СтрокаПривязки.Модель;						
			
			Строка.ТипПривязки = ТипПривязки;
			
			НепривязанныеОС.Удалить(СтрокаПривязки);
			
			Прервать;
		КонецЦикла;  
		
	КонецЦикла;  
	
КонецПроцедуры 

&НаСервере
Процедура ВыполнитьСопоставлениеДатчиков(ТолькоИзмененные = Ложь)
	
	ПараметрыОтбора = Новый Структура("Модель,ТТ");
	
	Если ТолькоИзмененные Тогда
		ПараметрыОтбора.Вставить("ОбновитьПривязки", Истина);
	КонецЕсли; 
	
	СопоставитьПоПараметрамОтбора(ПараметрыОтбора, "МодельТТ");

	// Далее просто по модели
	Если НЕ ЗначениеЗаполнено(ОтборТТНачалоРаботы) Тогда
		ПараметрыОтбора.Удалить("ТТ");
		
		СопоставитьПоПараметрамОтбора(ПараметрыОтбора, "Модель", Истина);
		СопоставитьПоПараметрамОтбора(ПараметрыОтбора, "Модель", Ложь);
	КонецЕсли; 
	
	Если ТолькоИзмененные Тогда
		ПараметрыОтбора = Новый Структура("ОбновитьПривязки", Истина);
		НайденныеСтроки = НепривязанныеОС.НайтиСтроки(ПараметрыОтбора);
		
		Для Каждого Строка Из НайденныеСтроки Цикл
			Строка.ОбновитьПривязки = Ложь;
		КонецЦикла;  
	КонецЕсли; 
	
КонецПроцедуры 

&НаСервере
Процедура ЗаполнитьТаблицыНаСервере(ПривязыватьАвтоматически = Истина)
	
	ТаблицаДанных = 	ПолучитьИзВременногоХранилища(АдресТаблицыДанных);
	
	Запрос = Новый Запрос("ВЫБРАТЬ
	                      |	ВТ_Данные.id_sensor,
	                      |	ВТ_Данные.refr_model,
	                      |	ВТ_Данные.refr_sn,
	                      |	ВТ_Данные.ShopNo
	                      |ПОМЕСТИТЬ ВТ_ДанныеSQL
	                      |ИЗ
	                      |	&ТаблицаДанных КАК ВТ_Данные
	                      |;
	                      |
	                      |////////////////////////////////////////////////////////////////////////////////
	                      |ВЫБРАТЬ
	                      |	ЛистУчета.ТорговаяТочка,
	                      |	НАЧАЛОПЕРИОДА(МИНИМУМ(ЛистУчета.Дата), ДЕНЬ) КАК Дата
	                      |ПОМЕСТИТЬ ВТ_НачалоРаботыТТ
	                      |ИЗ
	                      |	Документ.ЛистУчета КАК ЛистУчета
	                      |ГДЕ
	                      |	ЛистУчета.Проведен
	                      |
	                      |СГРУППИРОВАТЬ ПО
	                      |	ЛистУчета.ТорговаяТочка
	                      |;
	                      |
	                      |////////////////////////////////////////////////////////////////////////////////
	                      |ВЫБРАТЬ
	                      |	ПринятыеКУчетуОССрезПоследних.ОсновноеСредство,
	                      |	МАКСИМУМ(ПринятыеКУчетуОССрезПоследних.ДатаВводаВЭксплуатацию) КАК ДатаВводаВЭксплуатацию
	                      |ПОМЕСТИТЬ ВТ_ВводВЭксплуатацию
	                      |ИЗ
	                      |	РегистрСведений.ПринятыеКУчетуОС.СрезПоследних(, ОсновноеСредство.Номенклатура.ЭтоХолодильник) КАК ПринятыеКУчетуОССрезПоследних
	                      |
	                      |СГРУППИРОВАТЬ ПО
	                      |	ПринятыеКУчетуОССрезПоследних.ОсновноеСредство
	                      |;
	                      |
	                      |////////////////////////////////////////////////////////////////////////////////
	                      |ВЫБРАТЬ
	                      |	ВТ_ДанныеSQL.id_sensor КАК id_sensor,
	                      |	ВТ_ДанныеSQL.refr_model,
	                      |	ВТ_ДанныеSQL.refr_sn КАК СерийныйНомерХолодильника,
	                      |	Датчики.Ссылка КАК Датчик,
	                      |	МоделиХолодильников.Ссылка КАК Модель,
	                      |	СтруктурныеЕдиницы.Ссылка КАК ТТ,
	                      |	СоответствиеДатчиковИХолодильниковСрезПоследних.ОсновноеСредство КАК ОС,
	                      |	СоответствиеДатчиковИХолодильниковСрезПоследних.ОсновноеСредство.ИнвентарныйНомер КАК ОС_ИнвентарныйНомер,
	                      |	СостояниеОССрезПоследних.Местоположение КАК ОС_ТТ,
	                      |	СостояниеОССрезПоследних.ОсновноеСредство.Номенклатура.МодельХолодильника КАК ОС_Модель,
	                      |	ВЫБОР
	                      |		КОГДА СоответствиеДатчиковИХолодильниковСрезПоследних.ОсновноеСредство ЕСТЬ НЕ NULL 
	                      |				И СоответствиеДатчиковИХолодильниковСрезПоследних.ОсновноеСредство <> ЗНАЧЕНИЕ(Справочник.ОсновныеСредства.ПустаяСсылка)
	                      |			ТОГДА ""Регистр""
	                      |		ИНАЧЕ ""Нет""
	                      |	КОНЕЦ КАК ТипПривязки,
	                      |	ВТ_НачалоРаботыТТ.Дата КАК ДатаНачалаРаботыТТ
	                      |ИЗ
	                      |	ВТ_ДанныеSQL КАК ВТ_ДанныеSQL
	                      |		ЛЕВОЕ СОЕДИНЕНИЕ Справочник.Датчики КАК Датчики
	                      |		ПО ВТ_ДанныеSQL.id_sensor = Датчики.ИД
	                      |		ЛЕВОЕ СОЕДИНЕНИЕ Справочник.МоделиХолодильников КАК МоделиХолодильников
	                      |		ПО ВТ_ДанныеSQL.refr_model = МоделиХолодильников.Код
	                      |		ЛЕВОЕ СОЕДИНЕНИЕ Справочник.СтруктурныеЕдиницы КАК СтруктурныеЕдиницы
	                      |			ЛЕВОЕ СОЕДИНЕНИЕ ВТ_НачалоРаботыТТ КАК ВТ_НачалоРаботыТТ
	                      |			ПО СтруктурныеЕдиницы.Ссылка = ВТ_НачалоРаботыТТ.ТорговаяТочка
	                      |		ПО ВТ_ДанныеSQL.ShopNo = СтруктурныеЕдиницы.НомерТочки
	                      |		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.СоответствиеДатчиковИХолодильников.СрезПоследних(&НаДату, ) КАК СоответствиеДатчиковИХолодильниковСрезПоследних
	                      |		ПО (Датчики.Ссылка = СоответствиеДатчиковИХолодильниковСрезПоследних.Датчик)
	                      |		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.СостояниеОС.СрезПоследних(КОНЕЦПЕРИОДА(&НаДату, ДЕНЬ), ОсновноеСредство.Номенклатура.ЭтоХолодильник) КАК СостояниеОССрезПоследних
	                      |		ПО (СоответствиеДатчиковИХолодильниковСрезПоследних.ОсновноеСредство = СостояниеОССрезПоследних.ОсновноеСредство)
	                      |ГДЕ
	                      |	(НЕ &ИспользоватьОтборТТ
	                      |			ИЛИ СтруктурныеЕдиницы.Ссылка В (&ОтборТТ))
	                      |	И ЕСТЬNULL(ВТ_НачалоРаботыТТ.Дата, ДАТАВРЕМЯ(1, 1, 1)) >= &ОтборТТНачалоРаботы
	                      |	И (НЕ &ОтборТолькоНеСопоставленныеДатчики
	                      |			ИЛИ СоответствиеДатчиковИХолодильниковСрезПоследних.ОсновноеСредство.Ссылка ЕСТЬ NULL
	                      |			ИЛИ СтруктурныеЕдиницы.Ссылка <> СостояниеОССрезПоследних.Местоположение)
	                      |
	                      |УПОРЯДОЧИТЬ ПО
	                      |	ТТ,
	                      |	Датчик
	                      |АВТОУПОРЯДОЧИВАНИЕ
	                      |;
	                      |
	                      |////////////////////////////////////////////////////////////////////////////////
	                      |ВЫБРАТЬ
	                      |	СостояниеОССрезПоследних.ОсновноеСредство КАК ОС,
	                      |	СостояниеОССрезПоследних.Местоположение КАК ТТ,
	                      |	СостояниеОССрезПоследних.ОсновноеСредство.Номенклатура КАК Номенклатура,
	                      |	СостояниеОССрезПоследних.ОсновноеСредство.Номенклатура.МодельХолодильника КАК Модель,
	                      |	СостояниеОССрезПоследних.ОсновноеСредство.ИнвентарныйНомер КАК ИнвентарныйНомер,
	                      |	ВТ_ВводВЭксплуатацию.ДатаВводаВЭксплуатацию КАК ДатаВводаВЭксплуатацию
	                      |ИЗ
	                      |	РегистрСведений.СостояниеОС.СрезПоследних(КОНЕЦПЕРИОДА(&НаДату, ДЕНЬ), ОсновноеСредство.Номенклатура.ЭтоХолодильник) КАК СостояниеОССрезПоследних
	                      |		ЛЕВОЕ СОЕДИНЕНИЕ ВТ_НачалоРаботыТТ КАК ВТ_НачалоРаботыТТ
	                      |		ПО СостояниеОССрезПоследних.Местоположение = ВТ_НачалоРаботыТТ.ТорговаяТочка
	                      |		ЛЕВОЕ СОЕДИНЕНИЕ ВТ_ВводВЭксплуатацию КАК ВТ_ВводВЭксплуатацию
	                      |		ПО СостояниеОССрезПоследних.ОсновноеСредство = ВТ_ВводВЭксплуатацию.ОсновноеСредство
	                      |ГДЕ
	                      |	НЕ СостояниеОССрезПоследних.Списано
	                      |	И НЕ СостояниеОССрезПоследних.ОсновноеСредство В
	                      |				(ВЫБРАТЬ
	                      |					РегистрСведений.СоответствиеДатчиковИХолодильников.СрезПоследних.ОсновноеСредство
	                      |				ИЗ
	                      |					РегистрСведений.СоответствиеДатчиковИХолодильников.СрезПоследних(&НаДату))
	                      |	И ЕСТЬNULL(ВТ_НачалоРаботыТТ.Дата, ДАТАВРЕМЯ(1, 1, 1)) >= &ОтборТТНачалоРаботы
	                      |	И (НЕ &ИспользоватьОтборТТ
	                      |			ИЛИ СостояниеОССрезПоследних.Местоположение В (&ОтборТТ))
	                      |
	                      |УПОРЯДОЧИТЬ ПО
	                      |	СостояниеОССрезПоследних.ОсновноеСредство,
	                      |	ИнвентарныйНомер
	                      |АВТОУПОРЯДОЧИВАНИЕ");
	
	
	Запрос.УстановитьПараметр("ТаблицаДанных", ТаблицаДанных);
	Запрос.УстановитьПараметр("НаДату", НаДату);
	Запрос.УстановитьПараметр("ОтборТТ", ОтборТТ);			
	Если ТипЗнч(ОтборТТ) = Тип("СписокЗначений") И ОтборТТ.Количество() > 0 ИЛИ ТипЗнч(ОтборТТ) = Тип("СправочникСсылка.СтруктурныеЕдиницы") И ЗначениеЗаполнено(ОтборТТ) Тогда
		ИспользоватьОтборТТ= Истина;
	Иначе
		ИспользоватьОтборТТ= Ложь;		
	КонецЕсли;   
	Запрос.УстановитьПараметр("ИспользоватьОтборТТ", ИспользоватьОтборТТ);		
	Запрос.УстановитьПараметр("ОтборТТНачалоРаботы", ОтборТТНачалоРаботы);		
	Запрос.УстановитьПараметр("ОтборТолькоНеСопоставленныеДатчики", ОтборТолькоНеСопоставленныеДатчики);	
	
	РезультатыЗапроса = Запрос.ВыполнитьПакет();
	
	Датчики.Загрузить(РезультатыЗапроса[РезультатыЗапроса.ВГраница() - 1].Выгрузить());
	
	НепривязанныеОС.Загрузить(РезультатыЗапроса[РезультатыЗапроса.ВГраница()].Выгрузить());
	
	Если ПривязыватьАвтоматически Тогда
		ВыполнитьСопоставлениеДатчиков();
	КонецЕсли; 
	
КонецПроцедуры

&НаКлиенте
Процедура ЗаполнитьТаблицы(Команда = Неопределено)
	
	ПолучитьДанныеПоДатчикамSQL();
	
	ОповеститьОбИзменении(Тип("СправочникСсылка.МоделиХолодильников"));
	ОповеститьОбИзменении(Тип("СправочникСсылка.Датчики"));
	
	ЗаполнитьТаблицыНаСервере();
	
КонецПроцедуры


#Область ЗаписьПривязок

&НаСервере
Функция ПолучитьИзмененныеПривязки()
	
	Запрос = Новый Запрос("ВЫБРАТЬ
	                      |	ТаблицаДатчиков.Датчик,
	                      |	ТаблицаДатчиков.ОС,
	                      |	ТаблицаДатчиков.Датчик КАК Датчик1,
	                      |	ТаблицаДатчиков.СерийныйНомерХолодильника
	                      |ПОМЕСТИТЬ ВТ_Датчики
	                      |ИЗ
	                      |	&ТаблицаДатчиков КАК ТаблицаДатчиков
	                      |;
	                      |
	                      |////////////////////////////////////////////////////////////////////////////////
	                      |ВЫБРАТЬ
	                      |	ВТ_Датчики.Датчик,
	                      |	ВТ_Датчики.ОС КАК ОсновноеСредство,
	                      |	ВТ_Датчики.ОС.СерийныйНомер КАК СерийныйНомерОС,						  
	                      |	ВТ_Датчики.СерийныйНомерХолодильника
	                      |ИЗ
	                      |	ВТ_Датчики КАК ВТ_Датчики
	                      |		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.СоответствиеДатчиковИХолодильников.СрезПоследних(&НаДату, ) КАК СоответствиеДатчиковИХолодильниковСрезПоследних
	                      |		ПО ВТ_Датчики.Датчик = СоответствиеДатчиковИХолодильниковСрезПоследних.Датчик
	                      |ГДЕ
	                      |	ВТ_Датчики.ОС <> ЕСТЬNULL(СоответствиеДатчиковИХолодильниковСрезПоследних.ОсновноеСредство, ЗНАЧЕНИЕ(Справочник.ОсновныеСредства.ПустаяСсылка))");
	
	Запрос.УстановитьПараметр("ТаблицаДатчиков", РеквизитФормыВЗначение("Датчики"));
	Запрос.УстановитьПараметр("НаДату", НаДату);
	
	Возврат Запрос.Выполнить().Выгрузить();
	
КонецФункции

&НаСервере
Процедура ЗаписатьПривязкиНаСервере()
	
	ТаблицаИзмененных = ПолучитьИзмененныеПривязки();

	Для Каждого Строка Из ТаблицаИзмененных Цикл
		МЗ = РегистрыСведений.СоответствиеДатчиковИХолодильников.СоздатьМенеджерЗаписи();
		
		МЗ.Датчик = Строка .Датчик;
		МЗ.Период = НаДату;
		
		МЗ.Прочитать();
		
		ЗаполнитьЗначенияСвойств(МЗ, Строка);
		МЗ.Период = НаДату;
		
		МЗ.Записать();
		
		Если ЗначениеЗаполнено(Строка.ОсновноеСредство) И НЕ ЗначениеЗаполнено(Строка.СерийныйНомерОС) Тогда
			ОСОбъект = Строка.ОсновноеСредство.ПолучитьОбъект();
			ОСОбъект.СерийныйНомер = Строка.СерийныйНомерХолодильника;
			
			Попытка 
				ОСОбъект.Записать();
			Исключение
				ТекстСообщения = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку("Не удалось записать основное средство <%1> по причине: %2", ОСОбъект, ОписаниеОшибки());
				ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения);			
			КонецПопытки;
		КонецЕсли; 
	КонецЦикла;   
	
	ЗаполнитьТаблицыНаСервере(Ложь);
	
КонецПроцедуры

&НаСервере
Функция ЕстьИзменныеПривязки()
	
	ТаблицаИзмененных = ПолучитьИзмененныеПривязки();
	
	Возврат ТаблицаИзмененных.Количество() > 0;
	
КонецФункции

&НаКлиенте
Процедура ЗаписатьПривязки(Команда)
	ЗаписатьПривязкиНаСервере();
КонецПроцедуры

#КонецОбласти


#Область ФормированиеПеремещенийОС

&НаСервере
Процедура СформироватьПеремещенияНаСервере()
	
	Запрос = Новый Запрос("ВЫБРАТЬ
	                      |	ТаблицаДатчиков.ОС,
	                      |	ТаблицаДатчиков.ОС_ТТ,
	                      |	ТаблицаДатчиков.ТТ
	                      |ПОМЕСТИТЬ ВТ_Датчики
	                      |ИЗ
	                      |	&ТаблицаДатчиков КАК ТаблицаДатчиков
	                      |;
	                      |
	                      |////////////////////////////////////////////////////////////////////////////////
	                      |ВЫБРАТЬ
	                      |	ВТ_Датчики.ОС КАК ОсновноеСредство,
	                      |	ВТ_Датчики.ТТ КАК СтруктурнаяЕдиницаПолучатель
	                      |ИЗ
	                      |	ВТ_Датчики КАК ВТ_Датчики
	                      |ГДЕ
	                      |	ВТ_Датчики.ОС <> ЗНАЧЕНИЕ(Справочник.ОсновныеСредства.ПустаяСсылка)
	                      |	И ВТ_Датчики.ОС_ТТ <> НЕОПРЕДЕЛЕНО
	                      |	И ВТ_Датчики.ТТ <> ЗНАЧЕНИЕ(Справочник.СтруктурныеЕдиницы.ПустаяСсылка)
	                      |	И ВТ_Датчики.ТТ <> ВТ_Датчики.ОС_ТТ
	                      |
	                      |УПОРЯДОЧИТЬ ПО
	                      |	ВТ_Датчики.ОС
	                      |АВТОУПОРЯДОЧИВАНИЕ");
	
	Запрос.УстановитьПараметр("ТаблицаДатчиков", РеквизитФормыВЗначение("Датчики"));
	
	РезультатЗапросаОС = Запрос.Выполнить();
	
	Если РезультатЗапросаОС.Пустой() Тогда
		ТекстСообщения = "Не найдены основные средства, подлежащие перемещению на другие торговые точки.";
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения, ,"Датчики");			
		
		Возврат;
	КонецЕсли;
	
	// Ищем документ перемещения за эту дату: если нашли - распроводим, если не нашли - создаем
	ТекстКомментария = "##Документ создан автоматически обработкой корректировки состояния датчиков##";
	
	Запрос = Новый Запрос("ВЫБРАТЬ
	                      |	ПеремещениеОС.Ссылка,
	                      |	ПеремещениеОС.Проведен
	                      |ИЗ
	                      |	Документ.ПеремещениеОС КАК ПеремещениеОС
	                      |ГДЕ
	                      |	НАЧАЛОПЕРИОДА(ПеремещениеОС.Дата, ДЕНЬ) = &НаДату
	                      |	И ПеремещениеОС.Комментарий ПОДОБНО &Комментарий
	                      |	И НЕ ПеремещениеОС.ПометкаУдаления");
	
	Запрос.УстановитьПараметр("НаДату", НаДату);
	Запрос.УстановитьПараметр("Комментарий", ТекстКомментария);	
	
	Выборка = Запрос.Выполнить().Выбрать();
	
	Если Выборка.Следующий() Тогда
		ДокументПеремещениеОС = Выборка.Ссылка.ПолучитьОбъект();
		
		Если Выборка.Проведен Тогда
			Попытка 
				ДокументПеремещениеОС.Записать(РежимЗаписиДокумента.ОтменаПроведения);
			Исключение
				ТекстСообщения = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку("Не удалось отменить проведение документа <%1> по причине: %2" + Символы.ПС + "Перемещение ОС не выполнено!", ДокументПеремещениеОС, ОписаниеОшибки());
				ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения);			
				
				Возврат;
			КонецПопытки; 			
		КонецЕсли; 
	Иначе
		ДокументПеремещениеОС = Документы.ПеремещениеОС.СоздатьДокумент();
		
		ДокументПеремещениеОС.Дата = НаДату;
		ДокументПеремещениеОС.Ответственный = ПараметрыСеанса.ТекущийПользователь;
		ДокументПеремещениеОС.Организация = Справочники.Организации.НайтиПоРеквизиту("ИНН", "7734675810");
		ДокументПеремещениеОС.Комментарий = ТекстКомментария;		
	КонецЕсли;
	
	// Заполняем документ по "исходному" состоянию регистра. Если холодильник сейчас на виртуальном складе то перемещаем только в случае если до этого он был на ТТ, отличающейся от текущей ТТ датчика
	Запрос = Новый Запрос("ВЫБРАТЬ
	                      |	ТаблицаПеремещений.ОсновноеСредство,
	                      |	ТаблицаПеремещений.СтруктурнаяЕдиницаПолучатель
	                      |ПОМЕСТИТЬ ВТ_Данные
	                      |ИЗ
	                      |	&ТаблицаПеремещений КАК ТаблицаПеремещений
	                      |;
	                      |
	                      |////////////////////////////////////////////////////////////////////////////////
	                      |ВЫБРАТЬ
	                      |	ВТ_Данные.ОсновноеСредство,
	                      |	СостояниеОССрезПоследних.Местоположение КАК СтруктурнаяЕдиницаОтправитель,
	                      |	ВТ_Данные.СтруктурнаяЕдиницаПолучатель
	                      |ИЗ
	                      |	ВТ_Данные КАК ВТ_Данные
	                      |		ВНУТРЕННЕЕ СОЕДИНЕНИЕ РегистрСведений.СостояниеОС.СрезПоследних(КОНЕЦПЕРИОДА(&НаДату, ДЕНЬ), ) КАК СостояниеОССрезПоследних
	                      |		ПО ВТ_Данные.ОсновноеСредство = СостояниеОССрезПоследних.ОсновноеСредство
	                      |		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.СостояниеОС.СрезПоследних(КОНЕЦПЕРИОДА(&НаДату, ДЕНЬ), Местоположение <> &СкладХолодильников) КАК СостояниеОССрезПоследнихБезВиртуальногоСклада
	                      |		ПО ВТ_Данные.ОсновноеСредство = СостояниеОССрезПоследнихБезВиртуальногоСклада.ОсновноеСредство
	                      |ГДЕ
	                      |	СостояниеОССрезПоследних.Местоположение <> ВТ_Данные.СтруктурнаяЕдиницаПолучатель
	                      |	И (СостояниеОССрезПоследних.Местоположение <> &СкладХолодильников
	                      |			ИЛИ ЕСТЬNULL(СостояниеОССрезПоследнихБезВиртуальногоСклада.Местоположение, НЕОПРЕДЕЛЕНО) <> ВТ_Данные.СтруктурнаяЕдиницаПолучатель)
	                      |
	                      |УПОРЯДОЧИТЬ ПО
	                      |	ВТ_Данные.ОсновноеСредство
	                      |АВТОУПОРЯДОЧИВАНИЕ");
	
	Запрос.УстановитьПараметр("НаДату", НаДату);
	Запрос.УстановитьПараметр("ТаблицаПеремещений", РезультатЗапросаОС.Выгрузить());	
	Запрос.УстановитьПараметр("СкладХолодильников", Справочники.Склады.НайтиПоНаименованию("Склад Холодильников", Истина));
	
	ДокументПеремещениеОС.Номенклатура.Загрузить(Запрос.Выполнить().Выгрузить());
	
	Если ДокументПеремещениеОС.ЭтоНовый() И ДокументПеремещениеОС.Номенклатура.Количество() = 0 Тогда
		ТекстСообщения = "Не найдены основные средства, подлежащие перемещению на другие торговые точки.";
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения, ,"Датчики");			
		
		Возврат;
	КонецЕсли;
	
	Попытка 
		ДокументПеремещениеОС.Записать(РежимЗаписиДокумента.Запись);
	Исключение
		ТекстСообщения = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку("Не удалось записать документ <%1> по причине: %2", ДокументПеремещениеОС, ОписаниеОшибки());
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения);			
		
		Возврат;
	КонецПопытки; 
	
	Попытка 
		ДокументПеремещениеОС.Записать(РежимЗаписиДокумента.Проведение);
	Исключение
		ТекстСообщения = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку("Документ <%1> записан, но не проведен по причине: %2", ДокументПеремещениеОС, ОписаниеОшибки());
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения);			
		
		Возврат;
	КонецПопытки; 
	
	ТекстСообщения = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку("Документ <%1> записан и проведен", ДокументПеремещениеОС);
	ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения);	
	
КонецПроцедуры

&НаКлиенте
Процедура СформироватьПеремещения(Команда)
	Если ЕстьИзменныеПривязки() Тогда
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю("Перед формированием перемещения необходимо сохранить привязки!", , "Датчики");			
		Возврат;
	КонецЕсли; 

	СформироватьПеремещенияНаСервере();
	ЗаполнитьТаблицыНаСервере(Ложь);
КонецПроцедуры

#КонецОбласти


#Область СервисныеФункции

&НаКлиенте
Процедура УстановитьМоделиОС(Команда)
	Оповещение = Новый ОписаниеОповещения("ПослеУстановкиМоделейОС", ЭтаФорма);	
	
	ПараметрыФормы = Новый Структура("НаДату", НаДату);
	//ОткрытьФорму("ВнешняяОбработка.КорректировкаСостоянияДатчиковИХолодильников.Форма.ФормаПодбораМоделей", ПараметрыФормы, , , , ,Оповещение);
	ОткрытьФорму("Обработка.КорректировкаСостоянияДатчиковИХолодильников.Форма.ФормаПодбораМоделей", ПараметрыФормы, , , , ,Оповещение);
КонецПроцедуры

&НаКлиенте
Процедура ПослеУстановкиМоделейОС(Результат, ДополнительныеПараметры) Экспорт
	Если Результат = Неопределено Тогда
		Возврат;
	КонецЕсли; 
	
	Для Каждого КлючЗначение ИЗ Результат Цикл
		Номенклатура = КлючЗначение.Ключ;
		Модель = КлючЗначение.Значение;
		НайденныеСтроки = НепривязанныеОС.НайтиСтроки(Новый Структура("Номенклатура", Номенклатура)); 
		
		Для Каждого Строка Из НайденныеСтроки Цикл
			Строка.Модель = Модель;
			Строка.ОбновитьПривязки = Истина;
		КонецЦикла;  
	КонецЦикла;  
	
	ВыполнитьСопоставлениеДатчиков(Истина);	
	
	Элементы.Датчики.Обновить();
	Элементы.НепривязанныеОС.Обновить();
КонецПроцедуры

&НаКлиенте
Процедура ЗагрузитьДанныеПоХолодильникамИзФайла(Команда)
	//ОткрытьФорму("ВнешняяОбработка.КорректировкаСостоянияДатчиковИХолодильников.Форма.ФормаЗагрузкиДанныхПоХолодильникам");
	ОткрытьФорму("Обработка.КорректировкаСостоянияДатчиковИХолодильников.Форма.ФормаЗагрузкиДанныхПоХолодильникам");
КонецПроцедуры

&НаСервере
Процедура ПеренестиПривязкиДатчиковВНовыйРегистрНаСервере(Дата)
	Запрос = Новый Запрос("ВЫБРАТЬ
	                      |	&Дата КАК Период,
	                      |	СоответствиеДатчиковИОсновныхСредствСрезПоследних.Датчик,
	                      |	СоответствиеДатчиковИОсновныхСредствСрезПоследних.ОсновноеСредство
	                      |ИЗ
	                      |	РегистрСведений.СоответствиеДатчиковИОсновныхСредств.СрезПоследних(&Дата, ) КАК СоответствиеДатчиковИОсновныхСредствСрезПоследних");
	
	Запрос.УстановитьПараметр("Дата", Дата);
	
	НЗ = РегистрыСведений.СоответствиеДатчиковИХолодильников.СоздатьНаборЗаписей();
	
	НЗ.Отбор.Период.Установить(Дата);
	
	НЗ.Загрузить(Запрос.Выполнить().Выгрузить());
	
	НЗ.Записать();
	
	ТекстСообщения = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку("Перенесена информация по датчикам: <%1>", НЗ.Количество());
	ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения);			
КонецПроцедуры

&НаКлиенте
Процедура ПеренестиПривязкиДатчиковВНовыйРегистр(Команда)
	ПоказатьВводДаты(Новый ОписаниеОповещения("ПослеВводаДатыПереносаВНовыйРегистр", ЭтаФорма), , "Перенести по состоянию на:", ЧастиДаты.Дата);
КонецПроцедуры

&НаКлиенте
Процедура ПослеВводаДатыПереносаВНовыйРегистр(Дата, ДополнительныеПараметры) Экспорт
	Если ЗначениеЗаполнено(Дата) Тогда
		ПеренестиПривязкиДатчиковВНовыйРегистрНаСервере(Дата);		
	КонецЕсли; 
КонецПроцедуры 

#КонецОбласти


#Область ОбработчикиТабличныхЧастей

&НаКлиенте
Процедура ДатчикиПеретаскивание(Элемент, ПараметрыПеретаскивания, СтандартнаяОбработка, Строка, Поле)
	
	СтрокаДатчик = Датчики.НайтиПоИдентификатору(Строка);
	
	СтрокаОС = ПараметрыПеретаскивания.Значение;
	
	СтрокаДатчик.ОС = СтрокаОС.ОС;			
	СтрокаДатчик.ОС_ИнвентарныйНомер = СтрокаОС.ИнвентарныйНомер;						
	СтрокаДатчик.ОС_ТТ = СтрокаОС.ТТ;			
	СтрокаДатчик.ОС_Модель = СтрокаОС.Модель;						
	
	СтрокаДатчик.ТипПривязки = "Вручную";
	
	ПеретаскиваниеВДатчикиЗавершено = Истина;
	
КонецПроцедуры

&НаКлиенте
Процедура ДатчикиПроверкаПеретаскивания(Элемент, ПараметрыПеретаскивания, СтандартнаяОбработка, Строка, Поле)


	Если ТипЗнч(ПараметрыПеретаскивания.Значение) = Тип("Массив") ИЛИ Строка = Неопределено ИЛИ ЗначениеЗаполнено(Датчики.НайтиПоИдентификатору(Строка).ОС) Тогда
		ПараметрыПеретаскивания.Действие = ДействиеПеретаскивания.Отмена;	
	Иначе
		СтандартнаяОбработка = Ложь;
	КонецЕсли; 
	
КонецПроцедуры

&НаКлиенте
Процедура ДатчикиНачалоПеретаскивания(Элемент, ПараметрыПеретаскивания, Выполнение)
	
	ЕстьПривязанныеОС = Ложь;
	
	Для Каждого Идентификатор  Из ПараметрыПеретаскивания.Значение Цикл
		Строка = Датчики.НайтиПоИдентификатору(Идентификатор);
		
		Если ЗначениеЗаполнено(Строка.ОС) Тогда
			ЕстьПривязанныеОС = Истина;
			Прервать;
		КонецЕсли; 
	КонецЦикла;  
	
	Если НЕ ЕстьПривязанныеОС Тогда
		Выполнение = Ложь;
	КонецЕсли; 
	
	ПеретаскиваниеВНепривязаныеОСЗавершено = Ложь;
	
КонецПроцедуры

&НаКлиенте
Процедура ДатчикиОкончаниеПеретаскивания(Элемент, ПараметрыПеретаскивания, СтандартнаяОбработка)
	
	Если ПеретаскиваниеВНепривязаныеОСЗавершено Тогда
		
		Для Каждого СтрокаДатчик Из ПараметрыПеретаскивания.Значение Цикл
			СтрокаДатчик.ОС = Неопределено;			
			СтрокаДатчик.ОС_ИнвентарныйНомер = "";						
			СтрокаДатчик.ОС_ТТ = Неопределено;			
			СтрокаДатчик.ОС_Модель = Неопределено;;						
			
			СтрокаДатчик.ТипПривязки = "Нет";
		КонецЦикла;  	
		
	КонецЕсли; 
	
КонецПроцедуры

&НаКлиенте
Процедура ДатчикиВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	СтандартнаяОбработка = Ложь;
	
	Если Поле.Имя = "ДатчикиДатчик" И ЗначениеЗаполнено(Элемент.ТекущиеДанные.Датчик) Тогда
		ОткрытьФорму("Справочник.Датчики.ФормаОбъекта", Новый Структура("Ключ", Элемент.ТекущиеДанные.Датчик));		
	ИначеЕсли Поле.Имя = "ДатчикиМодель" И ЗначениеЗаполнено(Элемент.ТекущиеДанные.Модель) Тогда
		ОткрытьФорму("Справочник.МоделиХолодильников.ФормаОбъекта", Новый Структура("Ключ", Элемент.ТекущиеДанные.Модель));		
	ИначеЕсли (Поле.Имя = "ДатчикиОС" ИЛИ Поле.Имя = "ДатчикиОС_ИнвентарныйНомер") И ЗначениеЗаполнено(Элемент.ТекущиеДанные.ОС) Тогда
		ОткрытьФорму("Справочник.ОсновныеСредства.ФормаОбъекта", Новый Структура("Ключ", Элемент.ТекущиеДанные.ОС));		
	ИначеЕсли Поле.Имя = "ДатчикиТТ" И ЗначениеЗаполнено(Элемент.ТекущиеДанные.ТТ) Тогда
		ОткрытьФорму("Справочник.СтруктурныеЕдиницы.ФормаОбъекта", Новый Структура("Ключ", Элемент.ТекущиеДанные.ТТ));		
	КонецЕсли; 

КонецПроцедуры


&НаКлиенте
Процедура НепривязанныеОСПеретаскивание(Элемент, ПараметрыПеретаскивания, СтандартнаяОбработка, Строка, Поле)
	
	Для Каждого СтрокаДатчик ИЗ ПараметрыПеретаскивания.Значение Цикл
		Если НЕ ЗначениеЗаполнено(СтрокаДатчик.ОС) Тогда
			Продолжить;
		КонецЕсли; 	
		
		СтрокаОС = НепривязанныеОС.Вставить(НепривязанныеОС.Индекс(НепривязанныеОС.НайтиПоИдентификатору(Строка)));
		
		СтрокаОС.ОС = СтрокаДатчик.ОС;			
		СтрокаОС.ИнвентарныйНомер = СтрокаДатчик.ОС_ИнвентарныйНомер;						
		СтрокаОС.ТТ = СтрокаДатчик.ОС_ТТ;			
		СтрокаОС.Модель = СтрокаДатчик.ОС_Модель;						
	КонецЦикла;  
	
	//НепривязанныеОС.Сортировать("ОС, ИнвентарныйНомер");
	
	ПеретаскиваниеВНепривязаныеОСЗавершено = Истина;
	
КонецПроцедуры

&НаКлиенте
Процедура НепривязанныеОСПроверкаПеретаскивания(Элемент, ПараметрыПеретаскивания, СтандартнаяОбработка, Строка, Поле)
	
	Если ТипЗнч(ПараметрыПеретаскивания.Значение) <> Тип("Массив") Тогда
		ПараметрыПеретаскивания.Действие = ДействиеПеретаскивания.Отмена;	
	КонецЕсли; 
	
КонецПроцедуры

&НаКлиенте
Процедура НепривязанныеОСНачалоПеретаскивания(Элемент, ПараметрыПеретаскивания, Выполнение)
	
	Если ПараметрыПеретаскивания.Действие <> ДействиеПеретаскивания.Перемещение Тогда
		Выполнение = Ложь;
	КонецЕсли; 
	
	ПеретаскиваниеВДатчикиЗавершено = Ложь;
	
КонецПроцедуры

&НаКлиенте
Процедура НепривязанныеОСОкончаниеПеретаскивания(Элемент, ПараметрыПеретаскивания, СтандартнаяОбработка)
	
	Если ПеретаскиваниеВДатчикиЗавершено Тогда
		НепривязанныеОС.Удалить(ПараметрыПеретаскивания.Значение);		
	КонецЕсли; 
	
КонецПроцедуры

&НаКлиенте
Процедура НепривязанныеОСВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	ОткрытьФорму("Справочник.ОсновныеСредства.ФормаОбъекта", Новый Структура("Ключ", Элемент.ТекущиеДанные.ОС));
		
КонецПроцедуры

#КонецОбласти


#Область ОбработчикиРеквизитовФормы

&НаКлиенте
Процедура ОтборТТ_СпискомПриИзменении(Элемент)
	
	ОтборТТБыл = ОтборТТ;
		
	Если ОтборТТ_Списком Тогда
		ОтборТТ = Новый СписокЗначений;
		ОтборТТ.ТипЗначения = Новый ОписаниеТипов("СправочникСсылка.СтруктурныеЕдиницы");
		
		Если ЗначениеЗаполнено(ОтборТТБыл) Тогда
			ОтборТТ.Добавить(ОтборТТБыл);
		КонецЕсли; 
	Иначе
		ОтборТТ = ПредопределенноеЗначение("Справочник.СтруктурныеЕдиницы.ПустаяСсылка");
		
		Если ОтборТТБыл.Количество() > 0 Тогда
			ОтборТТ = ОтборТТБыл[0].Значение;
		КонецЕсли; 
		
	КонецЕсли; 
КонецПроцедуры

&НаКлиенте
Процедура НаДатуПриИзменении(Элемент)
	Если НЕ ЗначениеЗаполнено(НаДату) Тогда
		НаДату = ТекущаяДата();
	КонецЕсли; 
КонецПроцедуры

#КонецОбласти

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	ОтборТТ = ПредопределенноеЗначение("Справочник.СтруктурныеЕдиницы.ПустаяСсылка");

	НаДату = ТекущаяДата();
	
	//ЗаполнитьТаблицы();
КонецПроцедуры



