﻿
&НаКлиенте
Процедура КнопкаЛевоНажатие(Команда)
	
	//+++АК BARA 8.11.17 ИП-00015929.01 изменение на месяц, ранее был период от текущего месяца, теперь отчет за месяц.
	Объект.ДатаОкончание = КонецМесяца(ДобавитьМесяц(Объект.ДатаОкончание, -1));
	Объект.ДатаНачала = НачалоМесяца(ДобавитьМесяц(Объект.ДатаНачала, -1));
	//---АК BARA 8.11.17 ИП-00015929.01
	
	ОбновитьЗаголовокПериода();
	
КонецПроцедуры

&НаКлиенте
Процедура КнопкаПравоНажатие(Элемент)
	
	//+++АК BARA 8.11.17 ИП-00015929.01 изменение на месяц, ранее был период от текущего месяца, теперь отчет за месяц.
	Объект.ДатаОкончание = КонецМесяца(ДобавитьМесяц(Объект.ДатаОкончание, 1));
	Объект.ДатаНачала = НачалоМесяца(ДобавитьМесяц(Объект.ДатаНачала, 1));
	//---АК BARA 8.11.17 ИП-00015929.01
	
	ОбновитьЗаголовокПериода();
	
КонецПроцедуры

&НаКлиенте
Процедура ОбновитьЗаголовокПериода()
	Элементы.ВыбранныйПериод.Заголовок = ПредставлениеПериода(Объект.ДатаНачала, Объект.ДатаОкончание, "ФП = Истина");
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	Объект.ДатаНачала = НачалоМесяца(ТекущаяДата());
	Объект.ДатаОкончание = КонецМесяца(ТекущаяДата());
	ОбновитьЗаголовокПериода();
КонецПроцедуры

&НаКлиенте
Процедура Сформировать(Команда)
	ЗаполнитьНаСервере();	
	//+++АК sils 19.01.2018 ИП-00017637
	//Таблица = СформироватьНаСервере();
	ИтоговаяТаблица = СформироватьНаСервере();
	//---АК
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьНаСервере()
	Если не ЗначениеЗаполнено(Объект.Магазин) Тогда
		Сообщить("Не выбран магазин! Отчет не сформирован!");
		Возврат;
	КонецЕсли;
	
	ADOСоединение = ВнешниеДанные.ПолучитьADOСоединение("10.0.0.40");
	
	Если ADOСоединение = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	//+++АК BARA 8.11.17 ИП-00015929.01
	//Запросы вынимающий максимальные приближенные значения по времени к 8 и 20 часам каждый день, значения датчиков.
	ТекстЗапросаSQL = "SELECT ts.date_add, 
	|CONVERT(varchar(8),ts.date_add,112) as datedd,
	|CONVERT(varchar(8),ts.date_add,108) as tmm,
	|	ts.is_made,
	|	ts.ShopNo, 
	|	ts.id_mesto,
	|	ts.id_sensor,
	//+++АК sils 18.01.2018 ИП-00017637
	//|	ts.Sensor_value,
	//|	SMS.Место,
	//|	SMS.sensor_name,
	//|	SMS.Name_TT,
	//|	SMS.Location						
	//---АК
	|	ts.Sensor_value
	|
	|FROM [M2].[dbo].[TemraSensorData] (nolock) as ts
	//+++АК sils 18.01.2018 ИП-00017637
	//|inner join [Reports].[dbo].[Shop_Mesto_Sensor] (nolock) as SMS
	//|	on ts.id_mesto = SMS.id_mesto and ts.id_sensor = SMS.id_sendor
	//---АК
	|	Inner join 
	|	(SELECT 
	|CONVERT(varchar(8),ts.date_add,112) as datedd, 
	|max(CONVERT(varchar(8),ts.date_add,108)) as tmm,
	|	ts.ShopNo, 
	|	ts.id_mesto,
	|	ts.id_sensor					
	|
	|FROM [M2].[dbo].[TemraSensorData] (nolock) as ts 
	|
	|where ts.date_add between " + ВнешниеДанные.ФорматПоля(Объект.ДатаНачала) + " and " + ВнешниеДанные.ФорматПоля(Объект.ДатаОкончание) + "
	|and ts.ShopNo = '"+Формат(Объект.Магазин.НомерТочки,"ЧГ=")+"'
	|and (CONVERT(varchar(8),ts.date_add,108) between '19:00:00' and '20:00:00')
	|group by CONVERT(varchar(8),ts.date_add,112),ShopNo,id_mesto,id_sensor
	|Union
	|SELECT 
	|CONVERT(varchar(8),ts.date_add,112) as datedd, 
	|max(CONVERT(varchar(8),ts.date_add,108)) as tmm,
	|	ts.ShopNo, 
	|	ts.id_mesto,
	|	ts.id_sensor as id_sendor					
	|
	|FROM [M2].[dbo].[TemraSensorData] (nolock) as ts 
	|
	|where ts.date_add between " + ВнешниеДанные.ФорматПоля(Объект.ДатаНачала) + " and " + ВнешниеДанные.ФорматПоля(Объект.ДатаОкончание) + "
	|and ts.ShopNo = '"+Формат(Объект.Магазин.НомерТочки,"ЧГ=")+"'
	|and (CONVERT(varchar(8),ts.date_add,108) between '07:00:00' and '08:00:00')
	|group by CONVERT(varchar(8),ts.date_add,112),ShopNo,id_mesto,id_sensor) as ddd
	|on ts.id_mesto = ddd.id_mesto and ts.id_sensor = ddd.id_sensor and ts.ShopNo = ddd.ShopNo
	| and CONVERT(varchar(8),ts.date_add,108) = ddd.tmm and CONVERT(varchar(8),ts.date_add,112) = ddd.datedd
	|where ts.date_add between " + ВнешниеДанные.ФорматПоля(Объект.ДатаНачала) + " and " + ВнешниеДанные.ФорматПоля(Объект.ДатаОкончание) + "
	|and ts.ShopNo = '"+Формат(Объект.Магазин.НомерТочки,"ЧГ=")+"'
	|and (CONVERT(varchar(8),ts.date_add,108) between '07:00:00' and '08:00:00'
	|or CONVERT(varchar(8),ts.date_add,108) between '19:00:00' and '20:00:00')";
	
	
	//Два варианта с MoveNext и ВнешниеДанные.ПреобразоватьРезультатВТаблицуЗначений. Замеры производительностьи показали одинаковую скорость.
	rs = ADOСоединение.Execute(ТекстЗапросаSQL);
	Movenext = Истина;
	Объект.Данные.Очистить();
	Если Movenext Тогда 
		Пока НЕ rs.EOF() Цикл		
			СтрНов = Объект.Данные.Добавить();
			СтрНов.Дата = Rs.Fields("date_add").Value;
			СтрНов.Дата1 = СтрНов.Дата;//AK BARA #15929.02		
			СтрНов.is_made = Rs.Fields("is_made").Value;
			СтрНов.ShopNo = Rs.Fields("ShopNo").Value;
			СтрНов.id_mesto = Rs.Fields("id_mesto").Value;
			СтрНов.id_sensor = Rs.Fields("id_sensor").Value;
			СтрНов.Sensor_value = Rs.Fields("Sensor_value").Value;
			//+++АК sils 18.01.2018 ИП-00017637
			//СтрНов.Место = Rs.Fields("Место").Value;
			//СтрНов.sensor_name = Rs.Fields("sensor_name").Value;
			//СтрНов.Name_TT = Rs.Fields("Name_TT").Value;
			//СтрНов.Месторасположение = Rs.Fields("Location").Value;
			//---АК
			
			rs.MoveNext();
		Конеццикла;
	Иначе		 
		rsТЗ = ВнешниеДанные.ПреобразоватьРезультатВТаблицуЗначений(rs);	
		Для каждого Rs Из rsТЗ Цикл		
			СтрНов = Объект.Данные.Добавить();
			СтрНов.Дата = Rs["date_add"];
			СтрНов.Дата1 = СтрНов.Дата;//AK BARA #15929.02		
			СтрНов.is_made = Rs["is_made"];;
			СтрНов.ShopNo = Rs["ShopNo"];
			СтрНов.id_mesto = Rs["id_mesto"];
			СтрНов.id_sensor = Rs["id_sensor"];
			СтрНов.Sensor_value = Rs["Sensor_value"];
			//+++АК sils 18.01.2018 ИП-00017637
			//СтрНов.Место = Rs["Место"];
			//СтрНов.sensor_name = Rs["sensor_name"];
			//СтрНов.Name_TT = Rs["Name_TT"];
			//СтрНов.Месторасположение = Rs["Location"];
			//---АК
		Конеццикла;	
	КонецЕсли;
	//---АК BARA 8.11.17 ИП-00015929.01

	Объект.Данные.Сортировать("ShopNo, id_mesto, id_sensor, Дата");
	
	ТекКол = Объект.Данные.Количество();
	Если ТекКол <> 0 Тогда
		стр = Объект.Данные[ТекКол - 1];
		ShopNo = стр.ShopNo;
		id_mesto = стр.id_mesto;
		id_sensor = стр.id_sensor;
		ТекДата0 = Дата(Год(стр.Дата), Месяц(стр.Дата), День(стр.Дата), 23, 59, 59) + 1;
	КонецЕсли;
	Пока ТекКол <> 0 Цикл
		стр = Объект.Данные[ТекКол - 1];
		Если ShopNo <> стр.ShopNo или id_mesto <> стр.id_mesto или id_sensor <> стр.id_sensor Тогда
			ShopNo = стр.ShopNo;
			id_mesto = стр.id_mesto;
			id_sensor = стр.id_sensor;
			ТекДата0 = Дата(Год(стр.Дата), Месяц(стр.Дата), День(стр.Дата), 23, 59, 59) + 1;
		КонецЕсли;
		Если стр.Дата < ТекДата0 Тогда
			ТекДата0 = Дата(Год(стр.Дата), Месяц(стр.Дата), День(стр.Дата), 0, 0, 0);
			ТекДата1 = Дата(Год(стр.Дата), Месяц(стр.Дата), День(стр.Дата), 8, 0, 0);
			ТекДата1_1 = Дата(Год(стр.Дата), Месяц(стр.Дата), День(стр.Дата), 7, 0, 0);
			ТекДата2 = Дата(Год(стр.Дата), Месяц(стр.Дата), День(стр.Дата), 20, 0, 0);
			ТекДата2_1 = Дата(Год(стр.Дата), Месяц(стр.Дата), День(стр.Дата), 19, 0, 0);
		КонецЕсли;
		Если ТекДата2 <> 0 и стр.Дата < ТекДата2_1 Тогда
			ТекДата2 = 0;
		КонецЕсли;
		Если ТекДата1 <> 0 и стр.Дата < ТекДата1_1 Тогда
			ТекДата1 = 0;
		КонецЕсли;
		Если ТекДата2 <> 0 Тогда
			Если стр.Дата > ТекДата2 Тогда
				Объект.Данные.Удалить(стр);
				ТекКол = ТекКол - 1;
				Продолжить;
			ИначеЕсли стр.Дата = ТекДата2 Тогда
				ТекДата2 = 0; // Оставляем строку
				стр.УтроВечер = 2;
			ИначеЕсли стр.Дата <= ТекДата2 и стр.Дата >= ТекДата2_1 Тогда
				ТекДата2 = 0; // Оставляем строку
				стр.УтроВечер = 2;
			КонецЕсли;
		ИначеЕсли ТекДата1 <> 0 Тогда
			Если стр.Дата > ТекДата1 Тогда
				Объект.Данные.Удалить(стр);
				ТекКол = ТекКол - 1;
				Продолжить;
			ИначеЕсли стр.Дата = ТекДата1 Тогда
				ТекДата1 = 0; // Оставляем строку
				стр.УтроВечер = 1;
				ТекКол = ТекКол - 1;
				Продолжить;
			ИначеЕсли стр.Дата <= ТекДата1 и стр.Дата >= ТекДата1_1 Тогда
				ТекДата1 = 0; // Оставляем строку
				стр.УтроВечер = 1;
				ТекКол = ТекКол - 1;
				Продолжить;
			КонецЕсли;
		КонецЕсли;
		Если стр.Дата >= ТекДата0 и (стр.Дата < ТекДата1_1 или ТекДата1 = 0) Тогда
			Объект.Данные.Удалить(стр);
		КонецЕсли;
		
		ТекКол = ТекКол - 1;
	КонецЦикла;
	
	ADOСоединение.Close();
	
	//+++АК sils 18.01.2018 ИП-00017637
	Запрос = Новый Запрос;
	Запрос.Текст = "ВЫБРАТЬ
	               |	МестаВыкладки.Ссылка,
	               |	МестаВыкладки.Код
	               |ИЗ
	               |	Справочник.МестаВыкладки КАК МестаВыкладки
	               |ГДЕ
	               |	НЕ МестаВыкладки.ПометкаУдаления
	               |;
	               |
	               |////////////////////////////////////////////////////////////////////////////////
	               |ВЫБРАТЬ
	               |	Датчики.Код,
	               |	Датчики.Ссылка
	               |ИЗ
	               |	Справочник.Датчики КАК Датчики
	               |ГДЕ
	               |	НЕ Датчики.ПометкаУдаления";
	Результат = Запрос.ВыполнитьПакет();
	ТЗ_МВ = Результат[0].Выгрузить();
	ТЗ_МВ.Колонки.Добавить("Номер");
	ТЗ_Дат = Результат[1].Выгрузить();
	ТЗ_Дат.Колонки.Добавить("Номер");
	Для каждого стр из ТЗ_МВ Цикл
		стр.Номер = Число(стр.код);
	КонецЦикла;
	Для каждого стр из ТЗ_Дат Цикл
		стр.Номер = Число(СтрЗаменить(стр.код, "-", ""));
	КонецЦикла;
	
	Для каждого стр из Объект.Данные Цикл
		ТекСтр = ТЗ_МВ.Найти(стр.id_mesto, "Номер");
		Если ТекСтр <> Неопределено Тогда
			стр.Место = ТекСтр.Ссылка;
		Иначе
			стр.Место = "Место хранения с кодом " + стр.id_mesto;
		КонецЕсли;
		ТекСтр = ТЗ_Дат.Найти(стр.id_sensor, "Номер");
		Если ТекСтр <> Неопределено Тогда
			стр.sensor_name = ТекСтр.Ссылка;
			//+++АК sils 22.03.2018 ИП-00018011
			стр.Датчик = ТекСтр.Ссылка;
			//---АК
		Иначе
			стр.sensor_name = "Номер датчика с кодом " + стр.id_sensor;
		КонецЕсли;
	КонецЦикла;
	//---АК
КонецПроцедуры


&НаСервере
Функция СформироватьНаСервере()
	
	//+++AK BARA #15929.02

	Запрос = Новый Запрос;
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	МестаВыкладки.ТемпературныйРежим.НижнийПределТемпературы КАК ТемпературныйРежимНижнийПределТемпературы,
	|	МестаВыкладки.ТемпературныйРежим.ВерхнийПределТемпературы КАК ТемпературныйРежимВерхнийПределТемпературы,
	|	МестаВыкладки.Ссылка КАК Место
	|ИЗ
	|	Справочник.МестаВыкладки КАК МестаВыкладки
	|ГДЕ
	|	МестаВыкладки.Родитель = ЗНАЧЕНИЕ(Справочник.МестаВыкладки.ПустаяСсылка)";
		
	РезультатЗапроса = Запрос.Выполнить();
	
	Выборка = РезультатЗапроса.Выбрать();
	
	Пока Выборка.Следующий() Цикл
		ОтборПарам = Новый Структура("Место",Строка(Выборка.Место));	
		РезПоиска = Объект.Данные.НайтиСтроки(ОтборПарам);
		Для каждого Стр Из РезПоиска Цикл			
			Если Выборка.ТемпературныйРежимНижнийПределТемпературы>Стр.Sensor_value или Выборка.ТемпературныйРежимВерхнийПределТемпературы<Стр.Sensor_value Тогда 
			Стр.ОтклонениеОтНормы = Истина;	
			КонецЕсли;
		КонецЦикла;				
	КонецЦикла;
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	ИзмененныеЗначенияТемператур.МестоХранения.ИД КАК id_mesto,
	|	ИзмененныеЗначенияТемператур.Датчик.ИД КАК id_sensor,
	|	ИзмененныеЗначенияТемператур.Местоположение.Наименование КАК Местоположение,
	|	ВЫБОР
	|		КОГДА ИзмененныеЗначенияТемператур.ЭтоУтро
	|			ТОГДА 1
	|		ИНАЧЕ 2
	|	КОНЕЦ КАК УтроВечер,
	|	ИзмененныеЗначенияТемператур.ЗначениеТемпературы КАК ЗначениеТемпературы,
	|	ИзмененныеЗначенияТемператур.Датчик,
	|	ИзмененныеЗначенияТемператур.ДатаИзмерения  КАК ДатаИзмерения
	|ИЗ
	|	РегистрСведений.ИзмененныеЗначенияТемператур КАК ИзмененныеЗначенияТемператур
	|ГДЕ
	|	ИзмененныеЗначенияТемператур.Магазин = &Магазин
	|	И ИзмененныеЗначенияТемператур.ДатаИзмерения МЕЖДУ &ДатаОт И &ДатаДо";
	
	Запрос.УстановитьПараметр("Магазин", Объект.Магазин);
	Запрос.УстановитьПараметр("ДатаОт", Объект.ДатаНачала);	
	Запрос.УстановитьПараметр("ДатаДо", Объект.ДатаОкончание);	
	
	РезультатЗапроса = Запрос.Выполнить();
	
	Выборка = РезультатЗапроса.Выбрать();
	
	Пока Выборка.Следующий() Цикл
		ОтборПарам = Новый Структура("id_mesto,id_sensor,УтроВечер,Дата1",Выборка.id_mesto,Выборка.id_sensor,Выборка.УтроВечер,Выборка.ДатаИзмерения);	
		РезПоиска = Объект.Данные.НайтиСтроки(ОтборПарам);
		Для каждого Стр Из РезПоиска Цикл
			Стр.Sensor_value =  Выборка.ЗначениеТемпературы ;
			Стр.ИзмененноеЗначение = Истина;		
		КонецЦикла;				
	КонецЦикла;
	
	//---AK BARA #15929.02
	Таблица = Новый ТабличныйДокумент;
	Объект.Данные.Сортировать("ShopNo, Место, sensor_name, Дата");
	
	КоличествоЧисел = 0;
	ТекДата = Объект.ДатаНачала;
	Пока ТекДата < Объект.ДатаОкончание Цикл
		ТекДата = КонецМесяца(ТекДата);
		КоличествоЧисел = КоличествоЧисел + День(ТекДата);
		ТекДата = КонецМесяца(ТекДата) + 1;
	КонецЦикла;
	
	//*******************************************************************************************
	ТекОбъект = РеквизитФормыВЗначение("Объект");
	Макет = ТекОбъект.ПолучитьМакет("Макет");
	
	//Заголовок
	ОбластьЗаголовок = Макет.ПолучитьОбласть("Заголовок|Основная");
	ОбластьЗаголовок.Параметры.Магазин = СокрЛП(Объект.Магазин);
	ОбластьЗаголовок.Параметры.Период = СокрЛП(Элементы.ВыбранныйПериод.Заголовок);
	Таблица.Вывести(ОбластьЗаголовок);
	
	Для й = 1 По КоличествоЧисел Цикл
		ОбластьЗаголовок = Макет.ПолучитьОбласть("Заголовок|Столбец");
		Таблица.Присоединить(ОбластьЗаголовок);
	КонецЦикла;
	Область = Таблица.Область(1, 1, 1, 3 + КоличествоЧисел);
	Область.Объединить();
	Область = Таблица.Область(2, 1, 2, 3 + КоличествоЧисел);
	Область.Объединить();
	
	//Шапка
	ОбластьШапка = Макет.ПолучитьОбласть("Шапка|Основная");
	Таблица.Вывести(ОбластьШапка);
	
	//+++АК sils 19.01.2018 ИП-00017637
	//ТекКолонка1 = 3;
	ТекКолонка1 = 4;
	//---АК
	Линия = Новый Линия(ТипЛинииЯчейкиТабличногоДокумента.Сплошная, 1);
	ТекДата = Объект.ДатаНачала;
	Пока ТекДата < Объект.ДатаОкончание Цикл
		ТекДата = КонецМесяца(ТекДата);
		
		ТекМесяц = ПредставлениеПериода(НачалоМесяца(ТекДата), КонецМесяца(ТекДата), "ФП = Истина");
		Для й = 1 По День(ТекДата) Цикл
			ОбластьШапка = Макет.ПолучитьОбласть("Шапка|Столбец");
			ОбластьШапка.Параметры.Месяц = ТекМесяц;
			ОбластьШапка.Параметры.Число = й;
			Таблица.Присоединить(ОбластьШапка);
			
			Область = Таблица.Область(5, ТекКолонка1 + й, 5, ТекКолонка1 + й);
			Область.Обвести(Линия, Линия, Линия, Линия);	
		КонецЦикла;
		Область = Таблица.Область(4, ТекКолонка1 + 1, 4, ТекКолонка1 + День(ТекДата));
		Область.Объединить();
		Область.Обвести(Линия, Линия, Линия, Линия);	
		ТекКолонка1 = ТекКолонка1 + День(ТекДата); 
		
		ТекДата = КонецМесяца(ТекДата) + 1;
	КонецЦикла;
	//+++АК sils 19.01.2018 ИП-00017637
	//Область = Таблица.Область(3, 4, 3, ТекКолонка1);
	Область = Таблица.Область(3, 5, 3, ТекКолонка1);
	//---АК
	Область.Объединить();
	Область.Обвести(Линия, Линия, Линия, Линия);	
	//+++АК BARA 29.01.2018 Рустем попросил поменять цвет на светло розовый.	
	//ЦветИзменения = Новый Цвет(255,0,0);
	ЦветИзменения = WebЦвета.Розовый;
	//---
	//+++АК SHEP 2017.11.23 ИП-00015929.05
	//ЦветОтклонения = Новый Цвет(255,55,133);
	ЦветОтклонения = WebЦвета.Желтый;
	АК_ТекДата = НачалоДня(ТекущаяДата());
	//---АК SHEP 2017.11.23
	
	//Строки
	ТЗ = Объект.Данные.Выгрузить();
	ТЗ.Свернуть("Место, sensor_name,Месторасположение", "");
	ТЗ.Сортировать("Место, sensor_name,Месторасположение");
	Для каждого стр из ТЗ Цикл
		ОбластьСтрока = Макет.ПолучитьОбласть("Строка|Основная");
		ОбластьСтрока.Параметры.МестоХранения = стр.Место;
		ОбластьСтрока.Параметры.НомерДатчика = стр.sensor_name;
		ОбластьСтрока.Параметры.Месторасположение = стр.Месторасположение;
		
		Таблица.Вывести(ОбластьСтрока);
		
		Отбор = Новый Структура;
		Отбор.Вставить("Место", стр.Место);
		Отбор.Вставить("sensor_name", стр.sensor_name);
		Отбор.Вставить("Месторасположение", стр.Месторасположение);
		Массив = Объект.Данные.НайтиСтроки(Отбор);
		
		ТекДата = Объект.ДатаНачала;
		Пока ТекДата < Объект.ДатаОкончание Цикл
			ТекДата = КонецМесяца(ТекДата);
			
			Для й = 1 По День(ТекДата) Цикл
				ВыводимыйДень = Дата(Год(ТекДата), Месяц(ТекДата), й, 0, 0, 0);
				
				ОбластьСтрока = Макет.ПолучитьОбласть("Строка|Столбец");
				//ОбластьСтрока.Параметры.Утро = 0;     //AK BARA #16963
				//ОбластьСтрока.Параметры.Вечер = 0;    //AK BARA #16963
				ЕстьЗначениеУтро = Ложь;
				ЕстьЗначениеВечер = Ложь;

				Для каждого стр из Массив Цикл
					Если НачалоДня(стр.Дата) = ВыводимыйДень и стр.УтроВечер = 1 Тогда
						ОбластьСтрока.Параметры.Утро = стр.Sensor_value;
						ЕстьЗначениеУтро = Истина;  //AK BARA #15929.02
					ИначеЕсли НачалоДня(стр.Дата) = ВыводимыйДень и стр.УтроВечер = 2 Тогда
						ОбластьСтрока.Параметры.Вечер = стр.Sensor_value;
						ЕстьЗначениеВечер = Истина; //AK BARA #15929.02
					КонецЕсли;
					//+++AK BARA #15929.02
					//+++АК SHEP 2017.11.23 ИП-00015929.05
					//Если НачалоДня(стр.Дата) = ВыводимыйДень и Стр.ОтклонениеОтНормы Тогда 
					Если НачалоДня(стр.Дата) = ВыводимыйДень и Стр.ОтклонениеОтНормы И ВыводимыйДень <= АК_ТекДата Тогда
					//---АК SHEP 2017.11.23
						ОбластьСтрока.Область("R"+стр.УтроВечер+"C1").ЦветФона = ЦветОтклонения;	
					КонецЕсли;
					Если НачалоДня(стр.Дата) = ВыводимыйДень и Стр.ИзмененноеЗначение Тогда 
						ОбластьСтрока.Область("R"+стр.УтроВечер+"C1").ЦветФона = ЦветИзменения;	
					КонецЕсли;
					//---AK BARA #15929.02
				КонецЦикла;
				//+++AK BARA #15929.02
				//+++АК SHEP 2017.11.23 ИП-00015929.05
				//Если ЕстьЗначениеУтро = Ложь Тогда
				Если ЕстьЗначениеУтро = Ложь И ВыводимыйДень <= АК_ТекДата Тогда
				//---АК SHEP 2017.11.23
					ОбластьСтрока.Область("R1C1").ЦветФона = ЦветОтклонения;	
				КонецЕсли;
				//+++АК SHEP 2017.11.23 ИП-00015929.05
				Если ЕстьЗначениеВечер = Ложь И ВыводимыйДень <= АК_ТекДата Тогда
				//Если ЕстьЗначениеВечер = Ложь Тогда
				//---АК SHEP 2017.11.23
					ОбластьСтрока.Область("R2C1").ЦветФона = ЦветОтклонения;	
				КонецЕсли;
				//---AK BARA #15929.02
				Таблица.Присоединить(ОбластьСтрока);
			КонецЦикла;
			
			ТекДата = КонецМесяца(ТекДата) + 1;
		КонецЦикла;
	КонецЦикла;
	Возврат Таблица;
КонецФункции

&НаКлиенте
Процедура Печать(Команда)
	ТекДата = Объект.ДатаНачала;
	Пока ТекДата < Объект.ДатаОкончание Цикл
		ТекДата = КонецМесяца(ТекДата);
		ТекМесяц = ПредставлениеПериода(НачалоМесяца(ТекДата), КонецМесяца(ТекДата), "ФП = Истина");
		
		Таблица1 = ПечатьНаСервере(ТекДата);
		Таблица1.ОтображатьСетку = Ложь;
		Таблица1.ОтображатьЗаголовки = Ложь;
		Таблица1.ТолькоПросмотр = Истина;
		Таблица1.ОриентацияСтраницы = ОриентацияСтраницы.Ландшафт;
		Таблица1.АвтоМасштаб = Истина;
		Таблица1.ИмяПараметровПечати = "Журнал регистрации температур";
		Таблица1.Показать("Журнал регистрации температур за " + ТекМесяц);
		
		ТекДата = КонецМесяца(ТекДата) + 1;
	КонецЦикла;
КонецПроцедуры

&НаСервере
Функция ПечатьНаСервере(ТекДата)
	ТекМесяц = ПредставлениеПериода(НачалоМесяца(ТекДата), КонецМесяца(ТекДата), "ФП = Истина");
	
	Таблица = Новый ТабличныйДокумент;
	Таблица.Очистить();
	ТекОбъект = РеквизитФормыВЗначение("Объект");
	Макет = ТекОбъект.ПолучитьМакет("Макет");
	
	//Заголовок
	ОбластьЗаголовок = Макет.ПолучитьОбласть("Заголовок|Основная");
	ОбластьЗаголовок.Параметры.Магазин = СокрЛП(Объект.Магазин);
	ОбластьЗаголовок.Параметры.Период = ТекМесяц;
	Таблица.Вывести(ОбластьЗаголовок);
	
	Для й = 1 По День(ТекДата) Цикл
		ОбластьЗаголовок = Макет.ПолучитьОбласть("Заголовок|Столбец");
		Таблица.Присоединить(ОбластьЗаголовок);
	КонецЦикла;
	Область = Таблица.Область(1, 1, 1, 3 + День(ТекДата));
	Область.Объединить();
	Область = Таблица.Область(2, 1, 2, 3 + День(ТекДата));
	Область.Объединить();
	
	//Шапка
	ОбластьШапка = Макет.ПолучитьОбласть("Шапка|Основная");
	Таблица.Вывести(ОбластьШапка);
	
	Линия = Новый Линия(ТипЛинииЯчейкиТабличногоДокумента.Сплошная, 1);
	Для й = 1 По День(ТекДата) Цикл
		ОбластьШапка = Макет.ПолучитьОбласть("Шапка|Столбец");
		ОбластьШапка.Параметры.Месяц = ТекМесяц;
		ОбластьШапка.Параметры.Число = й;
		Таблица.Присоединить(ОбластьШапка);
		
		//+++АК sils 19.01.2018 ИП-00017637
		//Область = Таблица.Область(5, 3 + й, 5, 3 + й);
		Область = Таблица.Область(5, 4 + й, 5, 4 + й);
		//---АК
		Область.Обвести(Линия, Линия, Линия, Линия);	
	КонецЦикла;
	//+++АК sils 19.01.2018 ИП-00017637
	//Область = Таблица.Область(4, 3 + 1, 4, 3 + День(ТекДата));
	Область = Таблица.Область(4, 4 + 1, 4, 4 + День(ТекДата));
	//---АК
	Область.Объединить();
	Область.Обвести(Линия, Линия, Линия, Линия);	

	//+++АК sils 19.01.2018 ИП-00017637
	//Область = Таблица.Область(3, 4, 3, 3 + День(ТекДата));
	Область = Таблица.Область(3, 5, 3, 4 + День(ТекДата));
	//---АК
	Область.Объединить();
	Область.Обвести(Линия, Линия, Линия, Линия);	
	
	//Строки
	ТЗ = Объект.Данные.Выгрузить();
	ТЗ.Свернуть("Место, sensor_name", "");
	ТЗ.Сортировать("Место, sensor_name");
	Для каждого стр из ТЗ Цикл
		ОбластьСтрока = Макет.ПолучитьОбласть("Строка|Основная");
		ОбластьСтрока.Параметры.МестоХранения = стр.Место;
		ОбластьСтрока.Параметры.НомерДатчика = стр.sensor_name;
		Таблица.Вывести(ОбластьСтрока);
		
		Отбор = Новый Структура;
		Отбор.Вставить("Место", стр.Место);
		Отбор.Вставить("sensor_name", стр.sensor_name);
		Массив = Объект.Данные.НайтиСтроки(Отбор);
		
		Для й = 1 По День(ТекДата) Цикл
			ВыводимыйДень = Дата(Год(ТекДата), Месяц(ТекДата), й, 0, 0, 0);
			
			ОбластьСтрока = Макет.ПолучитьОбласть("Строка|Столбец");
			ОбластьСтрока.Параметры.Утро = 0;
			ОбластьСтрока.Параметры.Вечер = 0;
			Для каждого стр из Массив Цикл
				Если НачалоДня(стр.Дата) = ВыводимыйДень и стр.УтроВечер = 1 Тогда
					ОбластьСтрока.Параметры.Утро = стр.Sensor_value;
				ИначеЕсли НачалоДня(стр.Дата) = ВыводимыйДень и стр.УтроВечер = 2 Тогда
					ОбластьСтрока.Параметры.Вечер = стр.Sensor_value;
				КонецЕсли;
			КонецЦикла;
			Таблица.Присоединить(ОбластьСтрока);
		КонецЦикла;
	КонецЦикла;

	Возврат Таблица;
КонецФункции

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	Объект.ДатаНачала = НачалоМесяца(ТекущаяДата());
	Объект.ДатаОкончание = КонецМесяца(ТекущаяДата());
	
	Если ПараметрыСеанса.ТорговаяТочкаПоАйпи.Пустая() Тогда
		Сообщить("Не установлен параметр сеанса ""Тороговая точка по айпи""");
	Иначе
		Объект.Магазин = ПараметрыСеанса.ТорговаяТочкаПоАйпи;
	КонецЕсли;
КонецПроцедуры
//+++AK BARA #15929.02
&НаСервере
Процедура ТаблицаПриИзмененииНаСервере(Место,Местоположение,НомерДатчика,ТекДата,Утро,Температура)

	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ
		|	МестаВыкладки.Ссылка КАК Ссылка
		|ИЗ
		|	Справочник.МестаВыкладки КАК МестаВыкладки
		|ГДЕ
		|	МестаВыкладки.Наименование = &Наименование
		|	И МестаВыкладки.ЭтоГруппа";
	
	Запрос.УстановитьПараметр("Наименование", Место);
	
	РезультатЗапроса = Запрос.Выполнить();
	
	ВыборкаДетальныеЗаписи = РезультатЗапроса.Выбрать();
	МестоСсылка = Неопределено;
	Пока ВыборкаДетальныеЗаписи.Следующий() Цикл
		МестоСсылка = ВыборкаДетальныеЗаписи.Ссылка;
		Прервать;
	КонецЦикла;
	
	Если Местоположение = "" Тогда 
		МестоположениеСсылка = Справочники.МестоположениеДатчика.ПустаяСсылка();
	Иначе
		МестоположениеСсылка = Справочники.МестоположениеДатчика.НайтиПоНаименованию(Местоположение,Истина);
	КонецЕсли;	
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ
		|	Датчики.Ссылка КАК Ссылка
		|ИЗ
		|	Справочник.Датчики КАК Датчики
		|ГДЕ
		|	Датчики.Наименование = &Наименование
		|	И Датчики.Владелец = &Владелец";
	
	Запрос.УстановитьПараметр("Владелец", Объект.Магазин);
	Запрос.УстановитьПараметр("Наименование", НомерДатчика);
	
	РезультатЗапроса = Запрос.Выполнить();
	
	ВыборкаДетальныеЗаписи = РезультатЗапроса.Выбрать();
	
	Пока ВыборкаДетальныеЗаписи.Следующий() Цикл
		ДатчикСсылка = ВыборкаДетальныеЗаписи.Ссылка;
	КонецЦикла;
	//+++АК sils 22.03.2018 ИП-00018011
	ОтборДатчика = Новый Структура;
	ОтборДатчика.Вставить("sensor_name", НомерДатчика);
	МассивСтр = Объект.Данные.НайтиСтроки(ОтборДатчика);
	Для каждого стр из МассивСтр Цикл
		Если ЗначениеЗаполнено(стр.Датчик) и стр.Датчик.Владелец = Объект.Магазин Тогда
			ДатчикСсылка = стр.Датчик;
			Прервать;
		КонецЕсли;
	КонецЦикла;
	//---АК
	
	НовЗапись = РегистрыСведений.ИзмененныеЗначенияТемператур.СоздатьМенеджерЗаписи();
	НовЗапись.Магазин = Объект.Магазин;
	НовЗапись.Датчик = ДатчикСсылка;
	НовЗапись.ДатаИзмерения = ТекДата;
	НовЗапись.МестоХранения = МестоСсылка;
	НовЗапись.Местоположение = МестоположениеСсылка;
	НовЗапись.ЭтоУтро = Утро;
	НовЗапись.ЗначениеТемпературы = Число(Температура);
	НовЗапись.Записать(Истина);
	
КонецПроцедуры

&НаКлиенте
Процедура ТаблицаПриИзменении(Элемент)
	
	//+++АК sils 19.01.2018 ИП-00017637
	//ТекОбластьИмя = Таблица.ТекущаяОбласть.Имя;
	ТекОбластьИмя = ИтоговаяТаблица.ТекущаяОбласть.Имя;
	//---АК
	ТекОбластьИмя = СтрЗаменить(ТекОбластьИмя,"R","");
	ТекОбластьИмя = СтрЗаменить(ТекОбластьИмя,"C",Символы.ПС);
	ТекОбластьИмя = СтрЗаменить(ТекОбластьИмя,"С",Символы.ПС);
	Строка = Число(СтрПолучитьСтроку(ТекОбластьИмя,1));
	Столбец = Число(СтрПолучитьСтроку(ТекОбластьИмя,2));
	//+++АК sils 19.01.2018 ИП-00017637
	//Если Таблица.Область("R"+Строка+"C4").Текст = "Утро" Тогда
	Если ИтоговаяТаблица.Область("R"+Строка+"C4").Текст = "Утро" Тогда
	//---АК
		Утро = Истина;
	Иначе
		Утро = Ложь;
		Строка = Строка - 1;
	КонецЕсли;	  
	
	Красный =  Новый Цвет(255,0,0);
	//+++АК sils 19.01.2018 ИП-00017637
	//Таблица.ТекущаяОбласть.ЦветФона = Красный;	
	//
	//Место = Таблица.Область("R"+Строка+"C1").Текст;	
	//Местоположение = Таблица.Область("R"+Строка+"C2").Текст;
	//НомерДатчика = Таблица.Область("R"+Строка+"C3").Текст;
	//
	//ДатаДень = Число(Таблица.Область("R5C"+Столбец).Текст);
	ИтоговаяТаблица.ТекущаяОбласть.ЦветФона = Красный;	
	
	Место = ИтоговаяТаблица.Область("R"+Строка+"C1").Текст;	
	Местоположение = ИтоговаяТаблица.Область("R"+Строка+"C2").Текст;
	НомерДатчика = ИтоговаяТаблица.Область("R"+Строка+"C3").Текст;
	
	ДатаДень = Число(ИтоговаяТаблица.Область("R5C"+Столбец).Текст);
	//---АК
	
	ТекДата = Объект.ДатаНачала + (Столбец -  5) * 86400;
	
	//+++АК sils 19.01.2018 ИП-00017637
	//ТаблицаПриИзмененииНаСервере(Место,Местоположение,НомерДатчика,ТекДата,Утро,Таблица.ТекущаяОбласть.Текст);
	ТаблицаПриИзмененииНаСервере(Место,Местоположение,НомерДатчика,ТекДата,Утро,ИтоговаяТаблица.ТекущаяОбласть.Текст);
	//---АК
	
КонецПроцедуры
//---AK BARA #15929.02

//+++AK BARA #17406 2017.12.08
&НаКлиенте
Процедура НаПечать(Команда)
	//+++АК sils 19.01.2018 ИП-00017637
	//Таблица.Напечатать(РежимИспользованияДиалогаПечати.Использовать);
	ИтоговаяТаблица.Напечатать(РежимИспользованияДиалогаПечати.Использовать);
	//---АК
КонецПроцедуры

//+++АК ILIK 2018.06.19 ИП-00018838
&НаКлиенте
Процедура ОткрытьВариантДляСклада(Команда)
	ОткрытьФорму("Отчет.ЖурналРегистрацииТемпературВариантДляСклада.Форма");
	Закрыть();
КонецПроцедуры
