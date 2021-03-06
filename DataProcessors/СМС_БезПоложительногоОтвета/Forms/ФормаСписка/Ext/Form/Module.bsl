﻿//&НаСервере
//Перем CurrentConnection Экспорт;

//&НаСервере
//Процедура ПодключитьсяКSQL()
//	 CurrentConnection = База_Подключение();
//КонецПроцедуры

&НаКлиенте
Функция Обновить(Команда)
	Если Вопрос("Выборка данных может занять продолжительное время. Продолжить?", РежимДиалогаВопрос.ДаНет) = КодВозвратаДиалога.Да Тогда
		Состояние("Идёт выборка данных из базы. Ожидайте...");
		ОбновитьДанные();
    	Состояние("");
		Возврат Ложь;
	Иначе
		Возврат Истина;
	КонецЕсли;
КонецФункции


&НаСервере
Процедура ОбновитьДанные()
	
	Объект.ТЗ_СМС.Очистить();
	
	ТекстЗапроса = 	"SELECT *
	|  FROM [SMSGate].[dbo].[sms_bez_otveta]
	|order by ДатаСМС desc;";
	
	База_ВыполнитьЗапросИЗаполнитьТаблицуЗначений(ТекстЗапроса);

КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	Отказ = Обновить(Неопределено);
	
КонецПроцедуры




// Выполянет запрос и резульатат запроса возвращает в таблицу значений
//
&НаСервере
Процедура База_ВыполнитьЗапросИЗаполнитьТаблицуЗначений(ТекстЗапроса, допПараметры = Неопределено)  
	
	RecordSet = База_ВыполнитьЗапрос(ТекстЗапроса, допПараметры);
	тзРезультат = База_РезульататЗапросВТаблицуЗначений(RecordSet);
	RecordSet.Close();
	
 //   тзРезультат.Колонки.Добавить("Дата", Новый ОписаниеТипов("Дата"));
 //   Для каждого ТекСтрока Из тзРезультат Цикл
 //
 //		ТекСтрока.Дата = Дата(ТекСтрока.Date)+ (('00010101'-Дата("01.01.01 "+Лев(ТекСтрока.Time, Найти(ТекСтрока.Time, ".")-1))) * (-1));
 //
 //	КонецЦикла;
	//тзРезультат.Сортировать("ДатаСМС Убыв");
	
	
	Объект.ТЗ_СМС.Загрузить(тзРезультат);
		
КонецПроцедуры

&НаСервере
Функция База_ВыполнитьЗапрос(ТекстЗапроса, допПараметры = Неопределено)  
	Попытка
		Command = Новый COMОбъект("ADODB.Command");
		
		Если ТипЗнч(допПараметры) = Тип("Структура") тогда
			ЗаполнитьЗначенияСвойств(Command, допПараметры);
		КонецЕсли;			
		CurrentConnection = База_Подключение();
		
		Command.ActiveConnection = CurrentConnection;
		Command.CommandTimeout = 0;
		Command.CommandText = ТекстЗапроса;
		RecordSet = Новый COMОбъект("ADODB.RecordSet");
		RecordSet = Command.Execute(); //Выполнение и получение набора данных
		Возврат RecordSet;
	Исключение	
		ВызватьИсключение ОписаниеОшибки();
	КонецПопытки;	
КонецФункции

&НаСервере
Функция База_Подключение() экспорт	
	
	Попытка
		CurrentConnection = Новый COMОбъект("ADODB.Connection");
		Catalog = Новый COMОбъект("ADOX.Catalog");			
		
		СтрокаПодключения = ВнешниеДанные.ПолучитьСтрокуПодключенияMSSQL("srv-sql01", "SMS_UNION");
		Catalog.ActiveConnection = СтрокаПодключения;
		CurrentConnection.Open(СтрокаПодключения);
		Возврат CurrentConnection;	
		
	Исключение
		ОписаниеОшибки = ОписаниеОшибки();		
		#Если НаКлиенте тогда
		Сообщить(ОписаниеОшибки);			
		#КонецЕсли		
		Возврат Неопределено;
	КонецПопытки;
	
КонецФункции

// На основе результата запроса (База_ВыполнитьЗапрос) создаем таблицу значений!!
&НаСервере
Функция База_РезульататЗапросВТаблицуЗначений(RecordSet) 
	
	тз = Новый ТаблицаЗначений;
	Если ТипЗнч(RecordSet) <> Тип("COMОбъект") тогда
		Возврат тз;
	КонецЕсли;
	
	// Инициализируем колонки
	Для НомерКолонки = 0 По RecordSet.Fields.Count-1 Цикл
		NameFiled = RecordSet.Fields.Item(НомерКолонки).Name;
		NameFiled = СтрЗаменить(NameFiled,"$","_");
		тз.Колонки.Добавить(NameFiled,,RecordSet.Fields.Item(НомерКолонки).Name, 15);
	КонецЦикла;
	
	// Перебор данных
	Если НЕ RecordSet.EOF() Тогда
		RecordSet.MoveFirst();                 
		Пока RecordSet.EOF() = 0 Цикл
			СтрокаТаблицыЗначений = тз.Добавить();
			Для НомерКолонки = 0 По RecordSet.Fields.Count-1 Цикл
				СтрокаТаблицыЗначений[НомерКолонки] = RecordSet.Fields(RecordSet.Fields.Item(НомерКолонки).Name).Value;
			КонецЦикла;
			RecordSet.MoveNext();  
		КонецЦикла;
	КонецЕсли;
	
	Возврат ТЗ;
КонецФункции

// Закрываем датасет возвращаемй База_ВыполнитьЗапрос();
//
&НаСервере
Процедура База_ЗакрытьЗапрос(RecordSet) 
	Если ТипЗнч(RecordSet) = Тип("COMОбъект") тогда
		RecordSet.Close();
	КонецЕсли;		
КонецПроцедуры

&НаКлиенте
Процедура ТЗ_СМСВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	Если Поле.Имя = "ТЗ_СМСBonusCard" И СокрЛП(Элементы.ТЗ_СМС.ТекущиеДанные.BonusCard <> "") Тогда
		
		СтруктураПараметровФормы = Новый Структура;
		СтруктураПараметровФормы.Вставить("CustomerUID",Неопределено);
		СтруктураПараметровФормы.Вставить("rowguid",Неопределено);
		СтруктураПараметровФормы.Вставить("Email",СокрЛП(Элемент.ТекущиеДанные.BonusCard));
		
		ОткрытьФорму("Обработка.ОтчетыПоКартам.Форма.КарточкаКлиента", СтруктураПараметровФормы);
	
	Иначе	
		Форма = ПолучитьФорму("Обработка.АК_НеобработанныеСМС.Форма.ФормаРедактирования");
		Форма.ID_Строки = Элемент.ТекущиеДанные.rowguid;
		Форма.ПолеSMS = Элемент.ТекущиеДанные.text;
		Форма.ОткрытьМодально();
	КонецЕсли;
	
КонецПроцедуры
