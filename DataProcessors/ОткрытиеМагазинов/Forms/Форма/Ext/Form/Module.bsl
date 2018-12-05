﻿//+++ AK suvv 02.07.2018 ИП-00019135
//Процедура ЗаполнитьСервер()
&НаСервере
Процедура ЗаполнитьСервер(НазваниеТаблицы)
//--- AK suvv

	//АК БЕЛН 30.08.2017++
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("Дата"		, НачалоДня(ТекущаяДата()) - 2*86400);
	Запрос.УстановитьПараметр("ТекущаяДата"	, ТекущаяДата());
	//+++ AK suvv 02.07.2018 ИП-00019135
	Запрос.УстановитьПараметр("ПереданоВРозницу", НазваниеТаблицы = "МагазиныПереданныеВРозницу");
	//--- AK suvv
	Запрос.Текст = 
	"ВЫБРАТЬ РАЗРЕШЕННЫЕ
	|	СтруктурныеЕдиницы.Ссылка КАК Магазин,
	|	СтруктурныеЕдиницы.Адрес,
	|	СтруктурныеЕдиницы.АдминистративныйОкруг,
	|	СтруктурныеЕдиницы.ДатаОткрытия,
	|	СтруктурныеЕдиницы.ОсновнойСклад,
	|	СтруктурныеЕдиницы.НомерТочки
	|ИЗ
	|	Справочник.СтруктурныеЕдиницы КАК СтруктурныеЕдиницы
	|ГДЕ
	|	СтруктурныеЕдиницы.ТипСтруктурнойЕдиницы = ЗНАЧЕНИЕ(Перечисление.ТипыСтруктурныхЕдиниц.Розница)
	|	И СтруктурныеЕдиницы.СтатусТорговойТочки <> ЗНАЧЕНИЕ(Перечисление.СтатусыТорговыхТочек.Закрыт)
	//+++ AK suvv 02.07.2018 ИП-00019135
	//|	И (СтруктурныеЕдиницы.ДатаОткрытия = ДАТАВРЕМЯ(1, 1, 1)
	//|			ИЛИ СтруктурныеЕдиницы.ДатаОткрытия >= &Дата)
	|	И ВЫБОР
	|			КОГДА &ПереданоВРозницу
	|				ТОГДА СтруктурныеЕдиницы.МагазинПередан
	|						И СтруктурныеЕдиницы.ДатаНачалаПередачи >= ДОБАВИТЬКДАТЕ(&Дата, МЕСЯЦ, -3)
	|			ИНАЧЕ СтруктурныеЕдиницы.ДатаОткрытия = ДАТАВРЕМЯ(1, 1, 1)
	|					ИЛИ СтруктурныеЕдиницы.ДатаОткрытия >= &Дата
	|		КОНЕЦ
	//--- AK suvv	
	|	И СтруктурныеЕдиницы.ТипРозничнойТочки <> ЗНАЧЕНИЕ(Перечисление.ТипыРозничныхТочек.ПустаяСсылка)
	|	И НЕ СтруктурныеЕдиницы.ПометкаУдаления";
	
	
	РезультатЗапроса = Запрос.Выполнить();
	
	ВыборкаДетальныеЗаписи = РезультатЗапроса.Выбрать();
	СтрОтб="1=0";
	Пока ВыборкаДетальныеЗаписи.Следующий() Цикл
		СтрОтб=СтрОтб+" or "+"ts.ShopNo="+ВнешниеДанные.ФорматПоля(ВыборкаДетальныеЗаписи.НомерТочки);
	КонецЦикла;
		
	ADOСоединение = ВнешниеДанные.ПолучитьADOСоединение("10.0.0.40");
	
	Если ADOСоединение = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	ДатаОкончание=(ТекущаяДата());
	ДатаНачала=(ТекущаяДата()) - 30*60;
	
	ТекстЗапросаSQL ="SELECT [id]
	|,[date_add] 
	|,[is_made]
	|,[ShopNo] 
	|,[id_mesto]
	|,[id_sensor]
	|,[Sensor_value]
	|
	|, tt._Description Shop_name
	|,m._Description mest_name
	|FROM (SELECT [id]
	|	,[date_add] 
	|	,[is_made]
	|	,[ShopNo] 
	|	,[id_mesto]
	|	,[id_sensor]
	|	,[Sensor_value]
	|	FROM [M2].[dbo].[TemraSensorData] (nolock) as ts
	|	where ts.date_add between " + ВнешниеДанные.ФорматПоля(ДатаНачала) + " and " + ВнешниеДанные.ФорматПоля(ДатаОкончание) + "
	| and ("+СтрОтб+") and ts.Sensor_type = " + ВнешниеДанные.ФорматПоля(0) + ") as ts 
	|inner join IzbenkaFin.._Reference42 (nolock) as tt on ts.ShopNo=tt._Fld2756
	|inner join IzbenkaFin.._Reference5118 (nolock) as m on ts.id_mesto=m._Fld5280";
	
	rs = ADOСоединение.Execute(ТекстЗапросаSQL);
	ТЗ=Новый ТаблицаЗначений;
	ТЗ.Колонки.Добавить("Место");
	ТЗ.Колонки.Добавить("Сенсор");
	ТЗ.Колонки.Добавить("Shop_name");
	ТЗ.Колонки.Добавить("mest_name");
	ТЗ.Колонки.Добавить("Ответ");
	ТЗ.Колонки.Добавить("Дата");
	ТЗ.Колонки.Добавить("is_made");
	ТЗ.Колонки.Добавить("ShopNo");
	ТЗ.Колонки.Добавить("Параметр");
	
	ТЗДляЗапроса=Новый ТаблицаЗначений;
	ТЗДляЗапроса.Колонки.Добавить("Shop_name",Новый ОписаниеТипов("Строка", , Новый КвалификаторыСтроки(100)));
	ТЗДляЗапроса.Колонки.Добавить("mest_name", Новый ОписаниеТипов("Строка", , Новый КвалификаторыСтроки(100)));
	
	Попытка
		rs.MoveFirst();
		
		Пока НЕ rs.EOF() Цикл
			//Место = Rs.Fields("id_mesto").Value;
			//Сенсор = Rs.Fields("id_sensor").Value;
			//Shop_name = Rs.Fields("Shop_name").Value;
			//mest_name = Rs.Fields("mest_name").Value;
			//Ответ= Rs.Fields("Sensor_value").Value;
			//Дата= Rs.Fields("date_add").Value;
			//ShopNo=Rs.Fields("ShopNo").Value;
			
			СтрНов=ТЗ.Добавить();
			СтрНов.Место=Rs.Fields("id_mesto").Value;
			СтрНов.Сенсор=Rs.Fields("id_sensor").Value;
			СтрНов.Shop_name=Rs.Fields("Shop_name").Value;
			СтрНов.mest_name= Rs.Fields("mest_name").Value;
			СтрНов.Ответ= Rs.Fields("Sensor_value").Value;
			СтрНов.Дата= Rs.Fields("date_add").Value;
			СтрНов.is_made= Rs.Fields("is_made").Value;
			СтрНов.ShopNo= Rs.Fields("ShopNo").Value;
			
			СтрНов=ТЗДляЗапроса.Добавить();
			СтрНов.Shop_name=Rs.Fields("Shop_name").Value;
			СтрНов.mest_name= Rs.Fields("mest_name").Value;
			
			rs.MoveNext();
		КонецЦикла;
	Исключение
	КонецПопытки;
	ТЗДляЗапроса.Свернуть("Shop_name,mest_name");
	Запрос = Новый Запрос;
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	ТЗ.Shop_name,
	|	ТЗ.mest_name
	|ПОМЕСТИТЬ вт
	|ИЗ
	|	&ТЗ КАК ТЗ
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	СтруктурныеЕдиницы.Ссылка КАК Магазин,
	|	вт.Shop_name
	|ПОМЕСТИТЬ втМагазины
	|ИЗ
	|	Справочник.СтруктурныеЕдиницы КАК СтруктурныеЕдиницы
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ вт КАК вт
	|		ПО СтруктурныеЕдиницы.Наименование = вт.Shop_name
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	МестаВыкладки.Ссылка КАК МВ,
	|	МестаВыкладки.Родитель КАК МВРодитель,
	|	вт.mest_name,
	|	МестаВыкладки.ЭтоГруппа
	|ИЗ
	|	Справочник.МестаВыкладки КАК МестаВыкладки
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ вт КАК вт
	|		ПО МестаВыкладки.Наименование = вт.mest_name
	|;
	|
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	втМагазины.Магазин,
	|	втМагазины.Shop_name
	|ИЗ
	|	втМагазины КАК втМагазины";
	
	Запрос.УстановитьПараметр("ТЗ", ТЗДляЗапроса);
	
	Результаты = Запрос.ВыполнитьПакет();
	ТабМВ = Результаты[2].Выгрузить();
	ТабМагазины = Результаты[3].Выгрузить();
	
	
	ТЗДляЗапроса=Новый ТаблицаЗначений;
	Мас=новый Массив;
	Мас.Добавить(Тип("Число"));
	Мас.Добавить(Новый ОписаниеТипов("Строка", , Новый КвалификаторыСтроки(100)));
	ТЗДляЗапроса.Колонки.Добавить("Ответ", Новый ОписаниеТипов(Мас));
	ТЗДляЗапроса.Колонки.Добавить("Магазин",Новый ОписаниеТипов("СправочникСсылка.СтруктурныеЕдиницы"));
	ТЗДляЗапроса.Колонки.Добавить("МестоВыкладки", Новый ОписаниеТипов("СправочникСсылка.МестаВыкладки"));
	Для каждого СтрНов Из ТЗ Цикл
		Место=СтрНов.Место;
		Сенсор=СтрНов.Сенсор;
		Shop_name=СтрНов.Shop_name;
		mest_name=СтрНов.mest_name ;
		Ответ=СтрНов.Ответ;
		Дата=СтрНов.Дата;
		//СтрНов.is_made= Rs.Fields("is_made").Value;
		ShopNo=СтрНов.ShopNo;
		
		
		Мен=ТЗДляЗапроса.Добавить();
		
		СтрМагазин=ТабМагазины.НайтиСтроки(Новый Структура("Shop_name",Shop_name));
		Если СтрМагазин.Количество()=0 Тогда
			Продолжить;
		Иначе
			Магазин=СтрМагазин[0].Магазин;
		КонецЕсли; 
		
		
		СтрМВ=ТабМВ.НайтиСтроки(Новый Структура("mest_name",mest_name));
		Если СтрМВ.Количество()=0 Тогда
			МВ=Неопределено;
			МВРодитель=Неопределено;
			МВЭтоГруппа=Неопределено;
		Иначе
			МВ=СтрМВ[0].МВ;
			МВРодитель=СтрМВ[0].МВРодитель;
			МВЭтоГруппа=СтрМВ[0].ЭтоГруппа;
		КонецЕсли; 
		
		Мен.Магазин=Магазин;
		//Датчик=Датчик;
		//МВ=Справочники.МестаВыкладки.НайтиПоНаименованию(mest_name);
		Если ЗначениеЗаполнено(МВ)   Тогда
		   Если МВЭтоГруппа=Ложь Тогда
		       МВ=МВРодитель;
		   КонецЕсли; 
		Иначе	
		КонецЕсли; 
		
		Мен.МестоВыкладки=МВ;
		Если СтрЗаменить(Строка(Ответ)," ","")="1000" Тогда
			Мен.Ответ="Необработанная ошибка";
		ИначеЕсли СтрЗаменить(Строка(Ответ)," ","")="1001" Тогда
			Мен.Ответ="Поломка датчика";
		ИначеЕсли СтрЗаменить(Строка(Ответ)," ","")="1002" Тогда
			Мен.Ответ="Поломка модуля";
		ИначеЕсли СтрЗаменить(Строка(Ответ)," ","")="1003" Тогда
			Мен.Ответ="Драйвер модуля не установлен";
		ИначеЕсли СтрЗаменить(Строка(Ответ)," ","")="1004" Тогда
			Мен.Ответ="Нет связи с компьютером";
		ИначеЕсли СтрЗаменить(Строка(Ответ)," ","")="1005" Тогда
			Мен.Ответ="Нет связи с магазином";
		Иначе
			Мен.Ответ=Ответ;
		КонецЕсли; 
		
	КонецЦикла; 
	
	
	//
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("Дата"		, НачалоДня(ТекущаяДата()) - 2*86400);
	Запрос.УстановитьПараметр("ТекущаяДата"	, ТекущаяДата());
	Запрос.УстановитьПараметр("Датчики"	, ТЗДляЗапроса);
	//+++AK suvv 03.04.2018 ИП-00017689.02
	//установка параметра в запросе
	//Запрос.УстановитьПараметр("УправляющийРозницей", "UpravlyayushchiiPoRoznice");
	//---AK suvv
	
	//+++ AK Suvv 02.07.2018 ИП-00019135
	Запрос.УстановитьПараметр("ПереданоВРозницу", НазваниеТаблицы = "МагазиныПереданныеВРозницу");
	//--- AK suvv
	Запрос.Текст = 
	"ВЫБРАТЬ 
	|	Датчики.Ответ,
	|	Датчики.Магазин,
	|	Датчики.МестоВыкладки
	|ПОМЕСТИТЬ втДатчикиЗначения
	|ИЗ
	|	&Датчики КАК Датчики
	|;
	//АК БЕЛН 30.08.2017--
	|ВЫБРАТЬ РАЗРЕШЕННЫЕ
	|	СтруктурныеЕдиницы.Ссылка КАК Магазин,
	|	СтруктурныеЕдиницы.Адрес,
	|	СтруктурныеЕдиницы.АдминистративныйОкруг,
	|	СтруктурныеЕдиницы.ДатаОткрытия,
	|	СтруктурныеЕдиницы.ОсновнойСклад,
	|	СтруктурныеЕдиницы.Территория,
	//+++AK suvv 03.04.2018 ИП-00017689.02
	|   СтруктурныеЕдиницы.ГотовностьМагазина,
	//---AK
	|	НЕ (СтруктурныеЕдиницы.ДатаОткрытия >= &Дата И (СтруктурныеЕдиницы.МагазинПередан = Ложь И (СтруктурныеЕдиницы.ДатаНачалаПередачи <> ДАТАВРЕМЯ(1, 1, 1) ИЛИ СтруктурныеЕдиницы.ДатаОткрытия > ДАТАВРЕМЯ(2018, 1, 1)))) КАК МагазинНеСдан
	|ПОМЕСТИТЬ втТТ
	|ИЗ
	|	Справочник.СтруктурныеЕдиницы КАК СтруктурныеЕдиницы
	|ГДЕ
	|	СтруктурныеЕдиницы.ТипСтруктурнойЕдиницы = ЗНАЧЕНИЕ(Перечисление.ТипыСтруктурныхЕдиниц.Розница)
	|	И СтруктурныеЕдиницы.СтатусТорговойТочки <> ЗНАЧЕНИЕ(Перечисление.СтатусыТорговыхТочек.Закрыт)
	//+++AK suvv 02.07.2018 ИП-00019135
	//|	И (СтруктурныеЕдиницы.ДатаОткрытия = ДАТАВРЕМЯ(1, 1, 1)
	//|			ИЛИ СтруктурныеЕдиницы.ДатаОткрытия >= &Дата
	////+++AK GREK 30.11.2017 ИП-00015325.02
	//|   	ИЛИ (СтруктурныеЕдиницы.МагазинПередан = Ложь И (СтруктурныеЕдиницы.ДатаНачалаПередачи <> ДАТАВРЕМЯ(1, 1, 1) ИЛИ СтруктурныеЕдиницы.ДатаОткрытия > ДАТАВРЕМЯ(2018, 1, 1))))
	////---AK
	|	И выбор когда не &ПереданоВРозницу Тогда (СтруктурныеЕдиницы.ДатаОткрытия = ДАТАВРЕМЯ(1, 1, 1)
	|			ИЛИ СтруктурныеЕдиницы.ДатаОткрытия >= &Дата
	|   	ИЛИ (СтруктурныеЕдиницы.МагазинПередан = Ложь И (СтруктурныеЕдиницы.ДатаНачалаПередачи <> ДАТАВРЕМЯ(1, 1, 1) ИЛИ СтруктурныеЕдиницы.ДатаОткрытия > ДАТАВРЕМЯ(2018, 1, 1))))
	|   Иначе СтруктурныеЕдиницы.МагазинПередан = Истина и СтруктурныеЕдиницы.ДатаНачалаПередачи >= ДОБАВИТЬКДАТЕ(&Дата, МЕСЯЦ, -3)
	|   Конец
	//--- AK suvv
	|	И СтруктурныеЕдиницы.ТипРозничнойТочки <> ЗНАЧЕНИЕ(Перечисление.ТипыРозничныхТочек.ПустаяСсылка)
	|	И НЕ СтруктурныеЕдиницы.ПометкаУдаления
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ РАЗРЕШЕННЫЕ
	|	КОЛИЧЕСТВО(РАЗЛИЧНЫЕ ТоварныйАссортиментТочекСрезПоследних.Номенклатура) КАК Номенклатура,
	|	ТоварныйАссортиментТочекСрезПоследних.ТорговаяТочка
	|ПОМЕСТИТЬ втАссортимент
	|ИЗ
	|	РегистрСведений.ТоварныйАссортиментТочек.СрезПоследних(
	|			,
	|			ТорговаяТочка В
	|				(ВЫБРАТЬ
	|					втТТ.Магазин
	|				ИЗ
	|					втТТ КАК втТТ)) КАК ТоварныйАссортиментТочекСрезПоследних
	|ГДЕ
	|	ТоварныйАссортиментТочекСрезПоследних.Выведена = ЛОЖЬ
	|	И НЕ ТоварныйАссортиментТочекСрезПоследних.Запрещена
	|
	|СГРУППИРОВАТЬ ПО
	|	ТоварныйАссортиментТочекСрезПоследних.ТорговаяТочка
	|;
	//|
	//|////////////////////////////////////////////////////////////////////////////////
	//|ВЫБРАТЬ РАЗРЕШЕННЫЕ
	//|	МАКСИМУМ(ВЫБОР
	//|			КОГДА ТИПЗНАЧЕНИЯ(РеестрСостоянийДатчиковСрезПоследних.Ответ) = ТИП(ЧИСЛО)
	//|				ТОГДА ВЫБОР
	//|						КОГДА РеестрСостоянийДатчиковСрезПоследних.Ответ >= РеестрСостоянийДатчиковСрезПоследних.МестоВыкладки.ТемпературныйРежим.НижнийПределТемпературы
	//|								И (РеестрСостоянийДатчиковСрезПоследних.Ответ <= РеестрСостоянийДатчиковСрезПоследних.МестоВыкладки.ТемпературныйРежим.ВерхнийПределТемпературы
	//|									ИЛИ РеестрСостоянийДатчиковСрезПоследних.МестоВыкладки.ТемпературныйРежим.ВерхнийПределТемпературы = 0)
	//|							ТОГДА 1
	//|						ИНАЧЕ 2
	//|					КОНЕЦ
	//|			ИНАЧЕ 2
	//|		КОНЕЦ) КАК СостояниеДатчика,
	//|	РеестрСостоянийДатчиковСрезПоследних.Магазин
	//|ПОМЕСТИТЬ втДатчики
	//|ИЗ
	//|	РегистрСведений.РеестрСостоянийДатчиков.СрезПоследних(
	//|			&ТекущаяДата,
	//|			Магазин В
	//|				(ВЫБРАТЬ
	//|					втТТ.Магазин
	//|				ИЗ
	//|					втТТ КАК втТТ)) КАК РеестрСостоянийДатчиковСрезПоследних
	//|ГДЕ
	//|	РеестрСостоянийДатчиковСрезПоследних.Период МЕЖДУ &Дата И &ТекущаяДата
	//|
	//|СГРУППИРОВАТЬ ПО
	//|	РеестрСостоянийДатчиковСрезПоследних.Магазин
	//|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ РАЗРЕШЕННЫЕ
	|	МАКСИМУМ(ВЫБОР
	|			КОГДА ТИПЗНАЧЕНИЯ(РеестрСостоянийДатчиковСрезПоследних.Ответ) = ТИП(ЧИСЛО)
	|				ТОГДА ВЫБОР
	|						КОГДА РеестрСостоянийДатчиковСрезПоследних.Ответ >= РеестрСостоянийДатчиковСрезПоследних.МестоВыкладки.ТемпературныйРежим.НижнийПределТемпературы
	|								И (РеестрСостоянийДатчиковСрезПоследних.Ответ <= РеестрСостоянийДатчиковСрезПоследних.МестоВыкладки.ТемпературныйРежим.ВерхнийПределТемпературы
	|									ИЛИ РеестрСостоянийДатчиковСрезПоследних.МестоВыкладки.ТемпературныйРежим.ВерхнийПределТемпературы = 0)
	|							ТОГДА 1
	|						ИНАЧЕ 2
	|					КОНЕЦ
	|			ИНАЧЕ 2
	|		КОНЕЦ) КАК СостояниеДатчика,
	|	РеестрСостоянийДатчиковСрезПоследних.Магазин
	|ПОМЕСТИТЬ втДатчики
	|ИЗ
	|	втДатчикиЗначения КАК РеестрСостоянийДатчиковСрезПоследних
	|
	|СГРУППИРОВАТЬ ПО
	|	РеестрСостоянийДатчиковСрезПоследних.Магазин
	|;
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ РАЗРЕШЕННЫЕ
	|	СоответствиеОбъектРольСрезПоследних.Объект,
	|	СоответствиеОбъектРольСрезПоследних.РольПользователя
	|ПОМЕСТИТЬ втРолиСР
	|ИЗ
	|	РегистрСведений.СоответствиеОбъектРоль.СрезПоследних(, ТипРоли = ЗНАЧЕНИЕ(ПланВидовХарактеристик.ТипыРолейПользователя.СпециалистПоРазвитию)) КАК СоответствиеОбъектРольСрезПоследних
	|;
	//+++AK suvv 03.04.2018 ИП-00017689.02
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ РАЗРЕШЕННЫЕ
	|	СоответствиеОбъектРольСрезПоследних.Объект,
	|	СоответствиеОбъектРольСрезПоследних.РольПользователя,
	|	РолиПользователейСоставРоли.Сотрудник
	|ПОМЕСТИТЬ втРолиУправляющийРозницей
	|ИЗ
	|	РегистрСведений.СоответствиеОбъектРоль.СрезПоследних(, ТипРолиID = ""UpravlyayushchiiPoRoznice"") КАК СоответствиеОбъектРольСрезПоследних
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ Справочник.РолиПользователей.СоставРоли КАК РолиПользователейСоставРоли
	|		ПО СоответствиеОбъектРольСрезПоследних.РольПользователя = РолиПользователейСоставРоли.Ссылка
	|ГДЕ
	|	РолиПользователейСоставРоли.НомерСтроки = 1
	|;
	//---AK
	//+++AK suvv 17.08.2018 ИП-000193532
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ РАЗРЕШЕННЫЕ
	|	СоответствиеОбъектРольСрезПоследних.Объект,
	|	СоответствиеОбъектРольСрезПоследних.РольПользователя,
	|	РолиПользователейСоставРоли.Сотрудник
	|ПОМЕСТИТЬ втРолиРуководительПоСтроительству
	|ИЗ
	|	РегистрСведений.СоответствиеОбъектРоль.СрезПоследних(, ТипРолиID = ""RukovoditelPoStroitelstvu"") КАК СоответствиеОбъектРольСрезПоследних
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ Справочник.РолиПользователей.СоставРоли КАК РолиПользователейСоставРоли
	|		ПО СоответствиеОбъектРольСрезПоследних.РольПользователя = РолиПользователейСоставРоли.Ссылка
	|ГДЕ
	|	РолиПользователейСоставРоли.НомерСтроки = 1
	|;
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ РАЗРЕШЕННЫЕ
	|	СоответствиеОбъектРольСрезПоследних.Объект,
	|	СоответствиеОбъектРольСрезПоследних.РольПользователя,
	|	РолиПользователейСоставРоли.Сотрудник
	|ПОМЕСТИТЬ втРолиПомощникПоРознице
	|ИЗ
	|	РегистрСведений.СоответствиеОбъектРоль.СрезПоследних(, ТипРолиID = ""PomoshnikPoRaskrutke"") КАК СоответствиеОбъектРольСрезПоследних
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ Справочник.РолиПользователей.СоставРоли КАК РолиПользователейСоставРоли
	|		ПО СоответствиеОбъектРольСрезПоследних.РольПользователя = РолиПользователейСоставРоли.Ссылка
	|ГДЕ
	|	РолиПользователейСоставРоли.НомерСтроки = 1
	|;	
	//---AK
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	втТТ.Магазин,
	|	втТТ.Адрес,
	|	втТТ.АдминистративныйОкруг,
	|	втТТ.ДатаОткрытия КАК ДатаОткрытия,
	|	втТТ.ОсновнойСклад,
	|	втТТ.МагазинНеСдан,
	|	втТТ.Территория,
	//+++AK suvv 03.04.2018 ИП-00017689.02
	|	втТТ.ГотовностьМагазина,
	//---AK
	|	втРолиСР.РольПользователя КАК СпециалистПоРазвитию,
	//+++AK suvv 03.04.2018 ИП-00017689.02
	|   втРолиУправляющийРозницей.Сотрудник КАК УправляющийРозницей,
	//---AK
	//+++AK suvv 17.08.2018 ИП-000193532
	|   втРолиРуководительПоСтроительству.Сотрудник КАК РуководительПоСтроительству,
	|   втРолиПомощникПоРознице.Сотрудник КАК ПомощникПоРознице,
	//--- AK suvv
	|	втАссортимент.Номенклатура КАК КоличествоТоваровВАссортименте,
	|	ВЫБОР
	|		КОГДА втДатчики.СостояниеДатчика ЕСТЬ NULL 
	|			ТОГДА ""не подключено""
	|		КОГДА втДатчики.СостояниеДатчика = 1
	|			ТОГДА ""температура в норме""
	|		ИНАЧЕ ""плохо работает""
	|	КОНЕЦ КАК Состояние
	|ИЗ
	|	втТТ КАК втТТ
	|		ЛЕВОЕ СОЕДИНЕНИЕ втАссортимент КАК втАссортимент
	|		ПО втТТ.Магазин = втАссортимент.ТорговаяТочка
	|		ЛЕВОЕ СОЕДИНЕНИЕ втРолиСР КАК втРолиСР
	|		ПО втТТ.Магазин = втРолиСР.Объект
	//+++AK suvv 03.04.2018 ИП-00017689.02
	|		ЛЕВОЕ СОЕДИНЕНИЕ втРолиУправляющийРозницей КАК втРолиУправляющийРозницей
	|		ПО втТТ.Магазин = втРолиУправляющийРозницей.Объект
	//---AK
	//+++AK suvv 17.08.2018 ИП-000193532
	|		ЛЕВОЕ СОЕДИНЕНИЕ втРолиРуководительПоСтроительству КАК втРолиРуководительПоСтроительству
	|		ПО втТТ.Магазин = втРолиРуководительПоСтроительству.Объект
	|		ЛЕВОЕ СОЕДИНЕНИЕ втРолиПомощникПоРознице КАК втРолиПомощникПоРознице
	|		ПО втТТ.Магазин = втРолиПомощникПоРознице.Объект
	//--- AK suvv
	|		ЛЕВОЕ СОЕДИНЕНИЕ втДатчики КАК втДатчики
	|		ПО втТТ.Магазин = втДатчики.Магазин
	|
	|УПОРЯДОЧИТЬ ПО
	|	ДатаОткрытия";
	Выборка = Запрос.Выполнить().Выбрать();
	
	Пока Выборка.Следующий() Цикл
		//+++AK suvv 02.07.2018 ИП-00019135
		//НоваяСтрока = Объект.Магазины.Добавить();
		НоваяСтрока = Объект[НазваниеТаблицы].Добавить();
		//--- AK suvv
		ЗаполнитьЗначенияСвойств(НоваяСтрока, Выборка);
	КонецЦикла;
КонецПроцедуры

Процедура УстановитьДоступность()
	
	мДоступность = НЕ (РольДоступна("Перевозчик")
	И НЕ РольДоступна("ПолныеПрава"));
	//Элементы.Магазины.Доступность 				= мДоступность;
	Элементы.МагазиныНовыйМагазин.Доступность 	= мДоступность;
	Элементы.МагазиныТекущиеПараметры.Доступность 	= мДоступность;
	Элементы.ФормаНастроитьОповещение.Доступность 	= мДоступность;
	//+++AK GREK 07.12.2017
	ТекПользователь = Справочники.Пользователи.НайтиПоРеквизиту("ИдентификаторПользователяИБ",ПользователиИнформационнойБазы.ТекущийПользователь().УникальныйИдентификатор);
	Запрос = Новый Запрос;
	Запрос.Текст = "ВЫБРАТЬ
	               |	ЗначенияДополнительныхПравПользователя.Пользователь,
	               |	ЗначенияДополнительныхПравПользователя.Право,
	               |	ЗначенияДополнительныхПравПользователя.Значение КАК ДоступностьРедактирования
	               |ИЗ
	               |	РегистрСведений.ЗначенияДополнительныхПравПользователя КАК ЗначенияДополнительныхПравПользователя
	               |ГДЕ
	               |	ЗначенияДополнительныхПравПользователя.Пользователь = &Пользователь
	               |	И ЗначенияДополнительныхПравПользователя.Право = &Право";
	Запрос.УстановитьПараметр("Пользователь", ТекПользователь);
	Запрос.УстановитьПараметр("Право", ПредопределенноеЗначение("ПланВидовХарактеристик.ПраваПользователей.МожетРедактироватьСпискиРассылкиУведомленийПоОткрытиюМагазинов"));
	Рез = Запрос.Выполнить();
	Если НЕ Рез.Пустой() Тогда
		ДопПрава = Рез.Выгрузить();
		Элементы.ФормаНастроитьОповещение.Доступность = ДопПрава[0].ДоступностьРедактирования;
		Элементы.МагазиныНастройкаФормыСозданияНовогоМагазина.Доступность = ДопПрава[0].ДоступностьРедактирования;
	Иначе
		Элементы.ФормаНастроитьОповещение.Доступность = Ложь;
		Элементы.МагазиныНастройкаФормыСозданияНовогоМагазина.Доступность = Ложь;
	КонецЕсли;
	Если РольДоступна("ПолныеПрава") Тогда
		Элементы.ФормаНастроитьОповещение.Доступность = Истина;
		Элементы.МагазиныНастройкаФормыСозданияНовогоМагазина.Доступность = Истина;
	КонецЕсли;
	//---AK
	
	//+++ AK suvv 2018.09.05 ИП-00019673
	Элементы.МагазиныКонтрагентыИсключения.Доступность = Элементы.МагазиныНастройкаФормыСозданияНовогоМагазина.Доступность; 
	//--- AK suvv
		
КонецПроцедуры

&НаКлиенте
Процедура Заполнить(Команда)
	
	Объект.Магазины.Очистить();
	
	//+++ AK suvv 02.07.2018 ИП-00019135
	//ЗаполнитьСервер();
	ЗаполнитьСервер("Магазины");
	//--- AK suvv
	
КонецПроцедуры

Процедура МагазиныДатаОткрытияПриИзмененииСервер(ДатаОткрытия, Магазин)
	
	ОбъектМагазина = Магазин.ПолучитьОбъект();
	ОбъектМагазина.ДатаОткрытия = ДатаОткрытия;
	ОбъектМагазина.Записать();
	
КонецПроцедуры

&НаКлиенте
Процедура МагазиныДатаОткрытияПриИзменении(Элемент)
	
	ТекДанные = Элементы.Магазины.ТекущиеДанные;
	
	Если ТекДанные.ДатаОткрытия < НачалоДня(ТекущаяДата())
		ИЛИ ТекДанные.ДатаОткрытия > ДобавитьМесяц(ТекущаяДата(), 11) Тогда
		Сообщить("Некорректная дата открытия");
		ТекДанные.ДатаОткрытия = ТекДата;
		Возврат;
	КонецЕсли; 
	
	МагазиныДатаОткрытияПриИзмененииСервер(ТекДанные.ДатаОткрытия, ТекДанные.Магазин);
	ТекДата = ТекДанные.ДатаОткрытия;
	
КонецПроцедуры


&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	//+++ AK suvv 02.07.2018 ИП-00019135
	//ЗаполнитьСервер();
	ЗаполнитьСервер("Магазины");
	ЗаполнитьСервер("МагазиныПереданныеВРозницу");
	//--- AK suvv
	
	//
	УстановитьДоступность();
	
	//+++AK GREK 30.11.2017 ИП-00015325.02
	УстановитьУсловноеОформление();
	//---AK
КонецПроцедуры

//+++AK GREK 30.11.2017 ИП-00015325.02
Процедура УстановитьУсловноеОформление()
	ЭлементУсловногоОформления = УсловноеОформление.Элементы.Добавить();
	ЭлементУсловногоОформления.Оформление.УстановитьЗначениеПараметра("ЦветФона", Метаданные.ЭлементыСтиля.ФонЭпицентра.Значение);
	ПолеОформления = ЭлементУсловногоОформления.Поля.Элементы.Добавить();
	ПолеОформления.Использование = Истина;
	ПолеОформления.Поле = Новый ПолеКомпоновкиДанных(Элементы.Магазины.Имя);
	ЭлементОтбораДанных = ЭлементУсловногоОформления.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ЭлементОтбораДанных.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("Объект.Магазины.МагазинНеСдан");
	ЭлементОтбораДанных.ВидСравнения = ВидСравненияКомпоновкиДанных.Равно;
	ЭлементОтбораДанных.ПравоеЗначение = Истина;	
	ЭлементОтбораДанных.Использование = Истина;	
	
	//+++AK suvv 03.04.2018 ИП-00017689.02
	ЭлементУсловногоОформления = УсловноеОформление.Элементы.Добавить();
	ЭлементУсловногоОформления.Оформление.УстановитьЗначениеПараметра("ЦветФона", Новый Цвет(255,255,153));
	ПолеОформления = ЭлементУсловногоОформления.Поля.Элементы.Добавить();
	ПолеОформления.Использование = Истина;
	ПолеОформления.Поле = Новый ПолеКомпоновкиДанных(Элементы.Магазины.Имя);
	ЭлементОтбораДанных = ЭлементУсловногоОформления.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ЭлементОтбораДанных.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("Объект.Магазины.ГотовностьМагазина");
	ЭлементОтбораДанных.ВидСравнения = ВидСравненияКомпоновкиДанных.Равно;
	ЭлементОтбораДанных.ПравоеЗначение = Истина;	
	ЭлементОтбораДанных.Использование = Истина;	
	ЭлементОтбораДанных = ЭлементУсловногоОформления.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ЭлементОтбораДанных.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("Объект.Магазины.ДатаОткрытия");
	ЭлементОтбораДанных.ВидСравнения = ВидСравненияКомпоновкиДанных.Больше;
	ЭлементОтбораДанных.ПравоеЗначение = ТекущаяДата();	
	ЭлементОтбораДанных.Использование = Истина;	
	//---AK
	
КонецПроцедуры
	
&НаКлиенте
Процедура НастроитьОповещение(Команда)
	
	СписокГрупп = Новый Массив;
	СписокГрупп.Добавить(ПредопределенноеЗначение("Справочник.АК_ГруппыРассылки.ОткрытиеМагазина"));
	СписокГрупп.Добавить(ПредопределенноеЗначение("Справочник.АК_ГруппыРассылки.Список1"));
	СписокГрупп.Добавить(ПредопределенноеЗначение("Справочник.АК_ГруппыРассылки.Список2"));
	СписокГрупп.Добавить(ПредопределенноеЗначение("Справочник.АК_ГруппыРассылки.Список3"));
	//+++AK GREK 17.10.2017 ИП-00016367
	СписокГрупп.Добавить(ПредопределенноеЗначение("Справочник.АК_ГруппыРассылки.Список5"));
	//---AK
	//+++AK GREK 08.11.2017 ИП-00016367.01
	СписокГрупп.Добавить(ПредопределенноеЗначение("Справочник.АК_ГруппыРассылки.УведомленияОбИзмененияДатыЗавозаПродуктов"));
	//---AK
	//+++AK GREK 09.11.2017 ИП-00016600
	СписокГрупп.Добавить(ПредопределенноеЗначение("Справочник.АК_ГруппыРассылки.ИнформированиеОПланируемомОткрытии"));
	СписокГрупп.Добавить(ПредопределенноеЗначение("Справочник.АК_ГруппыРассылки.РассылкаПисемНаРегистрациюКасс"));
	СписокГрупп.Добавить(ПредопределенноеЗначение("Справочник.АК_ГруппыРассылки.РассылкаСканаДоговора"));
	СписокГрупп.Добавить(ПредопределенноеЗначение("Справочник.АК_ГруппыРассылки.РассылкаИнформацииМенеджерамОтделаАренды"));
	//---AK
	//+++AK GREK 18.01.2018 ИП-00017689      
	СписокГрупп.Добавить(ПредопределенноеЗначение("Справочник.АК_ГруппыРассылки.РассылкаОРасстановкеОборудования"));
	//---AK
	//+++AK suvv 03.04.2018 ИП-00017689.02
	СписокГрупп.Добавить(ПредопределенноеЗначение("Справочник.АК_ГруппыРассылки.РассылкаОГотовностиМагазина"));
	//---AK
	
	//+++ AK suvv 21.05.2018 ИП-00018555	
	СписокГрупп.Добавить(ПредопределенноеЗначение("Справочник.АК_ГруппыРассылки.РассылкаОПередачеПомещенияСЕ"));
	СписокГрупп.Добавить(ПредопределенноеЗначение("Справочник.АК_ГруппыРассылки.РассылкаОРазницеВПлощадяхСЕ"));
	//--- AK suvv
	
	СтруктураПараметров = Новый Структура("Группы", СписокГрупп);
	ОткрытьФорму("РегистрСведений.АК_ГруппыРассылки.Форма.ФормаСпискаУправляемая", СтруктураПараметров, ЭтаФорма);
	
КонецПроцедуры

&НаСервере
Процедура МагазиныСпециалистПоРазвитиюПриИзмененииСервер(Магазин,СпециалистПоРазвитию)
	
	Мен = РегистрыСведений.СоответствиеОбъектРоль.СоздатьМенеджерЗаписи();
	Мен.Период				= НачалоДня(ТекущаяДата());
	Мен.Объект				= Магазин;
	Мен.ТипРоли				= ПланыВидовХарактеристик.ТипыРолейПользователя.СпециалистПоРазвитию;
	Мен.РольПользователя	= СпециалистПоРазвитию;
	Мен.ТипРолиID			= ПланыВидовХарактеристик.ТипыРолейПользователя.СпециалистПоРазвитию.Код;
	Мен.Записать();
	
КонецПроцедуры

&НаКлиенте
Процедура МагазиныСпециалистПоРазвитиюПриИзменении(Элемент)
	
	ТекДанные = Элементы.Магазины.ТекущиеДанные;
	Если ЗначениеЗаполнено(ТекДанные.Магазин)
		И ЗначениеЗаполнено(ТекДанные.СпециалистПоРазвитию) Тогда
		МагазиныСпециалистПоРазвитиюПриИзмененииСервер(ТекДанные.Магазин, ТекДанные.СпециалистПоРазвитию);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура МагазиныСпециалистПоРазвитиюНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	СтруктураПараметров = Новый Структура("ОтборПоТипу, РежимВыбора", ПредопределенноеЗначение("ПланВидовХарактеристик.ТипыРолейПользователя.СпециалистПоРазвитию"), Истина);
	ОткрытьФорму("Справочник.РолиПользователей.Форма.ФормаВыбора", СтруктураПараметров, Элемент);
	
КонецПроцедуры

&НаКлиенте
Процедура МагазиныПриАктивизацииСтроки(Элемент)
	
	ТекДанные = Элементы.Магазины.ТекущиеДанные;
	Если ТекДанные <> Неопределено Тогда
		ТекДата = ТекДанные.Датаоткрытия;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура МагазиныВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	
	ТекущиеПараметры(Неопределено)
	
КонецПроцедуры

&НаКлиенте
Процедура ТекущиеПараметры(Команда)
	
	ОткрытьФорму("Справочник.СтруктурныеЕдиницы.Форма.НовыйМагазин", Новый Структура("Ключ", Элементы.Магазины.ТекущиеДанные.Магазин), ЭтаФорма);
	
КонецПроцедуры

&НаКлиенте
Процедура НовыйМагазин(Команда)
	
	ОткрытьФорму("Справочник.СтруктурныеЕдиницы.Форма.НовыйМагазин",, ЭтаФорма);
	
КонецПроцедуры

&НаКлиенте
Процедура НовыйМагазинСтараяФорма(Команда)
	ОткрытьФорму("Справочник.СтруктурныеЕдиницы.Форма.НовыйМагазинСтараяФорма",, ЭтаФорма);
КонецПроцедуры


&НаКлиенте
Процедура НастройкаФормыСозданияНовогоМагазина(Команда)
	//+++AK suvv 03.04.2018 ИП-00017689.02
	//ОткрытьФорму("Обработка.ОткрытиеМагазинов.Форма.НастройкаФормыСозданияНовогоМагазина",,ЭтаФорма);
	ОткрытьФорму("Обработка.ОткрытиеМагазинов.Форма.НастройкаФормыНовая",,ЭтаФорма);
	//---AK suvv
КонецПроцедуры


&НаКлиенте
Процедура НастройкаАвтоНазначенияПомощника(Команда)
	ОткрытьФорму("Обработка.ОткрытиеМагазинов.Форма.НастройкаАвтоматическогоПрисвоенияПомощникаПоРаскрутке");
КонецПроцедуры

//+++АК SUVV 2018.03.05 ИП-00017818
&НаКлиенте
Процедура ПодключитьРасширениеДляРаботыСФайлами()
	
	ДополнительныеПараметры = Новый Структура;
	ДополнительныеПараметры.Вставить("ВыборЗавершение", Новый ОписаниеОповещения("ВложениеВыборЗавершение", ЭтаФорма));
	Оповещение = Новый ОписаниеОповещения("НачатьПодключениеРасширенияРаботыСФайламиЗавершение", ЭтаФорма, ДополнительныеПараметры);
	НачатьПодключениеРасширенияРаботыСФайлами(Оповещение);
	
КонецПроцедуры //---АК SUVV 

//+++АК SUVV 2018.03.05 ИП-00017818		
&НаКлиенте
Процедура НачатьПодключениеРасширенияРаботыСФайламиЗавершение(Подключено, ДополнительныеПараметры) Экспорт
    
    Если Не Подключено Тогда
        Оповещение = Новый ОписаниеОповещения("НачатьУстановкуРасширенияРаботыСФайламиЗавершение", ЭтаФорма, ДополнительныеПараметры);
        ТекстСообщения = НСтр("ru='Для продолжении работы необходимо установить расширение для веб-клиента ""1С:Предприятие"". Установить?'");
        ПоказатьВопрос(Оповещение, ТекстСообщения, РежимДиалогаВопрос.ДаНет); 
    Иначе
        ВыполнитьОбработкуОповещения(ДополнительныеПараметры.ВыборЗавершение);
    КонецЕсли;
    
КонецПроцедуры //---АК SUVV 

//+++АК SUVV 2018.03.05 ИП-00017818
&НаКлиенте
Процедура НачатьУстановкуРасширенияРаботыСФайламиЗавершение(Результат, ДополнительныеПараметры) Экспорт
    
    Если Результат = КодВозвратаДиалога.Да Тогда
        НачатьУстановкуРасширенияРаботыСФайлами(ДополнительныеПараметры.ВыборЗавершение);
    КонецЕсли;
    
КонецПроцедуры //---АК SUVV 

//+++АК SUVV 2018.03.05 ИП-00017818
&НаКлиенте
Процедура ВложениеВыборЗавершение(Результат, ДополнительныеПараметры) Экспорт
	
КонецПроцедуры //---АК SUVV 

//+++АК SUVV 2018.03.05 ИП-00017818
&НаКлиенте
Процедура ПриОткрытии(Отказ)
	#Если ВебКлиент Тогда 
		ПодключитьРасширениеДляРаботыСФайлами();
	#КонецЕсли
	
	//+++ AK suvv 15.06.2018 ИП-00019009
	УстановитьОтбор();
	//--- AK suvv

КонецПроцедуры //---АК SUVV 

//+++ AK suvv 23.04.2018 ИП-00018244
&НаКлиенте
Процедура НоваяСтруктурнаяЕдиница(Команда)
	
	ОткрытьФорму("РегистрСведений.СтруктурныеЕдиницы.ФормаЗаписи");

КонецПроцедуры //--- AK suvv

//+++ AK suvv 23.04.2018 ИП-00018244
&НаКлиенте
Процедура СтруктурныеЕдиницыНесозданныеПередУдалением(Элемент, Отказ)
	Отказ = Истина;
КонецПроцедуры //--- AK suvv

//+++ AK suvv 23.04.2018 ИП-00018244
&НаКлиенте
Процедура СтруктурныеЕдиницыНесозданныеПередНачаломДобавления(Элемент, Отказ, Копирование, Родитель, Группа, Параметр)
	Отказ = Истина;
КонецПроцедуры //--- AK suvv

//+++ AK suvv 23.04.2018 ИП-00018244
&НаКлиенте
Процедура КомандаОбновить(Команда)
	Элементы.СтруктурныеЕдиницыНесозданные.Обновить();
КонецПроцедуры //---АК SUVV

//+++ AK suvv 23.04.2018 ИП-00018244
&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	Если Врег(ИмяСобытия) = Врег("Запись_СтруктурныеЕдиницы") Тогда
		Элементы.СтруктурныеЕдиницыНесозданные.Обновить();
	КонецЕсли;
КонецПроцедуры //---АК SUVV

//+++ AK suvv 10.05.2018 ИП-00017689.03
&НаКлиенте
Процедура ОткрытьОтчетОбОткрытыхМагазинах(Команда)
	
	ОткрытьФорму("Отчет.ОтчетОбОткрытыхМагазинах.Форма.ФормаОтчета");
	
КонецПроцедуры //--- AK suvv

//+++ AK suvv 21.05.2018 ИП-00018555
&НаКлиенте
Процедура ОткрытьОтчетОРасхождениях(Команда)
	
	ОткрытьФорму("Отчет.ОтчетОРасхожденияхПоСтруктурнымЕдиницам.Форма.ФормаОтчета");

КонецПроцедуры //--- AK suvv

//+++ AK suvv 15.06.2018 ИП-00019009
&НаКлиенте
Процедура СтатусПриИзменении(Элемент)
	УстановитьОтбор();
КонецПроцедуры  //--- AK suvv

//+++ AK suvv 15.06.2018 ИП-00019009
&НаКлиенте
Процедура УстановитьОтбор()

	ОтборНайден = Ложь;
	Для Каждого ЭлементОтбора из СтруктурныеЕдиницыНесозданные.Отбор.Элементы Цикл
		Если ЭлементОтбора.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("Статус") Тогда 
			ОтборНайден = Истина;
			Прервать;
		КонецЕсли;	
	КонецЦикла;
	
	Если не ОтборНайден Тогда
		ЭлементОтбора = СтруктурныеЕдиницыНесозданные.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
		ЭлементОтбора.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("Статус");
	КонецЕсли;
	
	СписокСтатусовДляОтбора = Новый СписокЗначений;
	Если СтатусНовый Тогда СписокСтатусовДляОтбора.Добавить(ПредопределенноеЗначение("Перечисление.СтатусыСтруктурныхЕдиниц.Новый")) КонецЕсли;
	Если НаУтверждении Тогда СписокСтатусовДляОтбора.Добавить(ПредопределенноеЗначение("Перечисление.СтатусыСтруктурныхЕдиниц.НаУтверждении")) КонецЕсли;
	Если НаИсправлении Тогда СписокСтатусовДляОтбора.Добавить(ПредопределенноеЗначение("Перечисление.СтатусыСтруктурныхЕдиниц.НаИсправлении")) КонецЕсли;
	Если УтвержденаИСоздана Тогда СписокСтатусовДляОтбора.Добавить(ПредопределенноеЗначение("Перечисление.СтатусыСтруктурныхЕдиниц.УтвержденаИСоздана")) КонецЕсли;
	
	ЭлементОтбора.ВидСравнения = ВидСравненияКомпоновкиДанных.ВСписке; 
	ЭлементОтбора.Использование = Истина; 
	ЭлементОтбора.ПравоеЗначение = СписокСтатусовДляОтбора;

КонецПроцедуры //--- AK suvv

//+++ AK suvv 02.07.2018 ИП-00019135
&НаКлиенте
Процедура МагазиныПереданныеВРозницуПередНачаломДобавления(Элемент, Отказ, Копирование, Родитель, Группа, Параметр)
	Отказ = Истина;
КонецПроцедуры //--- AK suvv

//+++ AK suvv 02.07.2018 ИП-00019135
&НаКлиенте
Процедура МагазиныПереданныеВРозницуПередУдалением(Элемент, Отказ)
	Отказ = Истина;
КонецПроцедуры //--- AK suvv

//+++ AK suvv 02.07.2018 ИП-00019135
&НаКлиенте
Процедура МагазиныПереданныеВРозницуВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	ОткрытьФорму("Справочник.СтруктурныеЕдиницы.Форма.НовыйМагазин", Новый Структура("Ключ", Элементы.МагазиныПереданныеВРозницу.ТекущиеДанные.Магазин), ЭтаФорма);
КонецПроцедуры //--- AK suvv

//+++ AK suvv 02.07.2018 ИП-00019135
&НаКлиенте
Процедура КомандаОбновитьТаблицуМагазиныПереданныеВРозницу(Команда)

	Объект.МагазиныПереданныеВРозницу.Очистить();
	
	ЗаполнитьСервер("МагазиныПереданныеВРозницу");
	
КонецПроцедуры //--- AK suvv

//+++ AK suvv 2018.09.05 ИП-00019410
&НаКлиенте
Процедура ОткрытьСписокКонтрагентовИсключений(Команда)
	
	ОткрытьФорму("РегистрСведений.КонтрагентыИсключенияАкцептованиеЗаявокНаМатериалыУслуги.ФормаСписка");
	
КонецПроцедуры //--- AK suvv

