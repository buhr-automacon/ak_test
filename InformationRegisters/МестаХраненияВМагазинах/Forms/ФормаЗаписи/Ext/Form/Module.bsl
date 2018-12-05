﻿
&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)

//	Датчики.Параметры.УстановитьЗначениеПараметра("Дата"			, ТекущаяДата());
//	Датчики.Параметры.УстановитьЗначениеПараметра("Магазин"			, Запись.Магазин);
//	Датчики.Параметры.УстановитьЗначениеПараметра("МестоВыкладки"	, Запись.МестоВыкладки);
	
	// при создании нового Хватает = Истина
	Если Запись.ИсходныйКлючЗаписи.Магазин.Пустая() Тогда
		Запись.Хватает = Истина;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПослеЗаписи(ПараметрыЗаписи)

	//Датчики.Параметры.УстановитьЗначениеПараметра("Магазин"			, Запись.Магазин);
	//Датчики.Параметры.УстановитьЗначениеПараметра("МестоВыкладки"	, Запись.МестоВыкладки);
	
КонецПроцедуры


&НаКлиенте
Процедура СоздатьДатчик(Команда)
	
	Если Модифицированность Тогда
	    Сообщить("Необходимо записать изменения");
		Возврат;
	КонецЕсли; 
	
	//
	Парам = Новый Структура("МестоВыкладки, СтруктурнаяЕдиница", Запись.МестоВыкладки, Запись.Магазин);
	ОткрытьФорму("Справочник.Датчики.Форма.ФормаЭлемента", Парам);
	
КонецПроцедуры

&НаКлиенте
Процедура ИзменитьДатчик(Команда)
	
	ТекДанные = Элементы.Датчики.ТекущиеДанные;
	Если ТекДанные = Неопределено Тогда
	    Возврат;
	КонецЕсли;
	
	//
	Парам = Новый Структура("Ключ", ТекДанные.Датчик);
	ОткрытьФорму("Справочник.Датчики.Форма.ФормаЭлемента", Парам);
	
КонецПроцедуры

&НаКлиенте
Процедура ДатчикиВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	//
	//ТекДанные = Элементы.Датчики.ТекущиеДанные;
	//Если ТекДанные = Неопределено Тогда
	//     Возврат;
	//КонецЕсли; 
	//
	////
	//СтандартнаяОбработка = Ложь;
	////Отбор=Новый Структура("Датчик",ТекДанные.Датчик);
	//Парам = Новый Структура("Ключ", ТекДанные.Датчик);
	//ОткрытьФорму("Справочник.Датчики.Форма.ФормаЭлемента", Парам);
	
КонецПроцедуры


&НаСервере
Процедура ЗаполнитьНаСервере()
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ
		|	МестаВыкладки.ИД
		|ИЗ
		|	Справочник.МестаВыкладки КАК МестаВыкладки
		|ГДЕ
		|	МестаВыкладки.Ссылка В ИЕРАРХИИ(&Ссылка)";
	
	Запрос.УстановитьПараметр("Ссылка", Запись.МестоВыкладки);
	
	РезультатЗапроса = Запрос.Выполнить();
	
	ВыборкаДетальныеЗаписи = РезультатЗапроса.Выбрать();
	СтрОтб="1=0";
	Пока ВыборкаДетальныеЗаписи.Следующий() Цикл
		СтрОтб=СтрОтб+" or ts.id_mesto="+ВнешниеДанные.ФорматПоля(ВыборкаДетальныеЗаписи.ИД);
	КонецЦикла;
	
	ADOСоединение = ВнешниеДанные.ПолучитьADOСоединение();
	
	Если ADOСоединение = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	ДатаОкончание=КонецМесяца(ТекущаяДата());
	ДатаНачала=НачалоМесяца(ТекущаяДата());
	ТекстЗапросаSQL = "SELECT ts.date_add, 
						|	ts.is_made,
						|	ts.ShopNo, 
						|	ts.id_mesto,
						|	ts.id_sensor,
						|	ts.Sensor_value,
						|	SMS.Место,
						|	SMS.sensor_name,
						|	SMS.Name_TT,
						|	SMS.Location						
						|
						|FROM [M2].[dbo].[TemraSensorData] (nolock) as ts 
						|inner join [Reports].[dbo].[Shop_Mesto_Sensor] (nolock) as SMS
						|	on ts.id_mesto = SMS.id_mesto and ts.id_sensor = SMS.id_sendor
						|where ts.date_add between " + ВнешниеДанные.ФорматПоля(ДатаНачала) + " and " + ВнешниеДанные.ФорматПоля(ДатаОкончание) + " 
						|and SMS.Name_TT = " + ВнешниеДанные.ФорматПоля(СокрЛП(Запись.Магазин.Наименование))+ 
	" and ts.ShopNo="+ВнешниеДанные.ФорматПоля(Запись.Магазин.НомерТочки)+" and ("+СтрОтб+")";
	rs = ADOСоединение.Execute(ТекстЗапросаSQL);
				
	Данные.Очистить();			
	Пока НЕ rs.EOF() Цикл
		СтрНов = Данные.Добавить();
		СтрНов.Дата = Rs.Fields("date_add").Value;
		СтрНов.is_made = Rs.Fields("is_made").Value;
		СтрНов.ShopNo = Rs.Fields("ShopNo").Value;
		СтрНов.id_mesto = Rs.Fields("id_mesto").Value;
		СтрНов.id_sensor = Rs.Fields("id_sensor").Value;
		СтрНов.Sensor_value = Rs.Fields("Sensor_value").Value;
		СтрНов.Место = Rs.Fields("Место").Value;
		СтрНов.sensor_name = Rs.Fields("sensor_name").Value;
		СтрНов.Name_TT = Rs.Fields("Name_TT").Value;
		СтрНов.Месторасположение = Rs.Fields("Location").Value;
		
		rs.MoveNext();
	Конеццикла;
	Данные.Сортировать("ShopNo, id_mesto, id_sensor, Дата");
	
	ТекКол = Данные.Количество();
	Если ТекКол <> 0 Тогда
		стр = Данные[ТекКол - 1];
		ShopNo = стр.ShopNo;
		id_mesto = стр.id_mesto;
		id_sensor = стр.id_sensor;
		ТекДата0 = Дата(Год(стр.Дата), Месяц(стр.Дата), День(стр.Дата), 23, 59, 59) + 1;
	КонецЕсли;
	Пока ТекКол <> 0 Цикл
		стр = Данные[ТекКол - 1];
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
				Данные.Удалить(стр);
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
				Данные.Удалить(стр);
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
			Данные.Удалить(стр);
		КонецЕсли;
		
		ТекКол = ТекКол - 1;
	КонецЦикла;
	
	ADOСоединение.Close();
КонецПроцедуры

&НаСервере
Функция СформироватьНаСервере()
	УстановитьПривилегированныйРежим(Истина);
	ДатаОкончание=КонецМесяца(ТекущаяДата());
	ДатаНачала=НачалоМесяца(ТекущаяДата());

	Таблица = Новый ТабличныйДокумент;
	Данные.Сортировать("ShopNo, Место, sensor_name, Дата");
	
	КоличествоЧисел = 0;
	ТекДата = ДатаНачала;
	Пока ТекДата < ДатаОкончание Цикл
		ТекДата = КонецМесяца(ТекДата);
		КоличествоЧисел = КоличествоЧисел + День(ТекДата);
		ТекДата = КонецМесяца(ТекДата) + 1;
	КонецЦикла;
	
	//*******************************************************************************************
	//ТекОбъект = РеквизитФормыВЗначение("Объект");
	Макет = Обработки.ЖурналРегистрацииТемператур.ПолучитьМакет("Макет");
	
	//Заголовок
	ОбластьЗаголовок = Макет.ПолучитьОбласть("Заголовок|Основная");
	ОбластьЗаголовок.Параметры.Магазин = СокрЛП(Запись.Магазин);
	ОбластьЗаголовок.Параметры.Период = "месяц";
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
	
	ТекКолонка1 = 3;
	Линия = Новый Линия(ТипЛинииЯчейкиТабличногоДокумента.Сплошная, 1);
	ТекДата = ДатаНачала;
	Пока ТекДата < ДатаОкончание Цикл
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
		Область = Таблица.Область(4, ТекКолонка1 + 1+1, 4, ТекКолонка1 + День(ТекДата)+1);
		Область.Объединить();
		Область.Обвести(Линия, Линия, Линия, Линия);	
		ТекКолонка1 = ТекКолонка1 + День(ТекДата); 
		
		ТекДата = КонецМесяца(ТекДата) + 1;
	КонецЦикла;
	Область = Таблица.Область(3, 4 + 1, 3, ТекКолонка1 + 1);
	Область.Объединить();
	Область.Обвести(Линия, Линия, Линия, Линия);	
	
	//Строки
	ТЗ = Данные.Выгрузить();
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
		Массив = Данные.НайтиСтроки(Отбор);
		
		ТекДата = ДатаНачала;
		Пока ТекДата < ДатаОкончание Цикл
			ТекДата = КонецМесяца(ТекДата);
			
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
			
			ТекДата = КонецМесяца(ТекДата) + 1;
		КонецЦикла;
	КонецЦикла;
	Возврат Таблица;
КонецФункции


&НаКлиенте
Процедура ПриОткрытии(Отказ)
	Сформировать();
КонецПроцедуры
 
&НаКлиенте
Процедура Сформировать()
	ЗаполнитьНаСервере();
	
	ТД = СформироватьНаСервере();
	//ТД.Показать();
	ТабДок=ТД;	
КонецПроцедуры


&НаКлиенте
Процедура Обновить(Команда)
	Сформировать();
КонецПроцедуры
