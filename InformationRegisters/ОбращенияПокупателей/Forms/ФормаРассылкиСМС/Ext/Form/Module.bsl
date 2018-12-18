﻿
&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	ТекстЗапроса="ВЫБРАТЬ
	             |	ОбращенияПокупателей.ФИО_Покупателя КАК ФИО,
	             |	ОбращенияПокупателей.Телефон,
	             |	ОбращенияПокупателей.GUID_Загрузки КАК Бланк,
	             |	ИСТИНА КАК Пометка,
	             |	ОбращенияПокупателей.Номенклатура КАК Товар
	             |ИЗ
	             |	РегистрСведений.ОбращенияПокупателей КАК ОбращенияПокупателей
	             |ГДЕ
	             |	ОбращенияПокупателей.GUID_Загрузки В(&Бланки)
	             |
	             |СГРУППИРОВАТЬ ПО
	             |	ОбращенияПокупателей.ФИО_Покупателя,
	             |	ОбращенияПокупателей.Телефон,
	             |	ОбращенияПокупателей.GUID_Загрузки,
	             |	ОбращенияПокупателей.Номенклатура
	             |
	             |УПОРЯДОЧИТЬ ПО
	             |	Бланк,
	             |	ФИО";
	Запрос=Новый Запрос(ТекстЗапроса);
	Запрос.УстановитьПараметр("Бланки",Параметры.СписокБланков);
	ТО=Запрос.Выполнить().Выгрузить();
	ЗначениеВРеквизитФормы(ТО,"ТаблицаОтправки");
	ЗаполнитьСписокСообщенийСервер();
КонецПроцедуры


//Функция КнОтправитьНаСервере_()
//	
//	ТО = РеквизитФормыВЗначение("ТаблицаОтправки");
//	//АК БЕЛН 10.05.2016++
//	ТО.Свернуть("ФИО, Товар, Телефон, Бланк, Пометка");
//	ТаблицаОбработаныхПозиций.Очистить();	
//	//АК БЕЛН 10.05.2016--
//	СтрокиДляОтправки = ТО.НайтиСтроки(Новый Структура("Пометка", Истина));
//	
//	СтрокаВозврата = "";	
//	
//	ТекстЗапроса =
//	"Insert into SMSGate..Incoming
//	|	(Date,
//	|	nomer,
//	|	text,
//	|	Time,
//	|	source)
//	|Select
//	|	convert(datetime, CONVERT(date, getdate())),
//	|	/**BPar1**/'~~~~~'/**FPar**/,
//	|	/**BPar2**/'^^^^^'/**FPar**/,
//	|	CONVERT(time(7), getdate()),
//	|	11;";
//		
//	СтрокаПодключения = "Provider=SQLOLEDB.1;Persist Security Info=True;Initial Catalog=SMSGate;Data Source=srv-sql01;Password=cjyzcjyz;User ID=izbenka";	
//	
//	//минеев заглушка от задвоенных записей в таблицу скл
//	//СтрокаОтбора = "ФИО, Товар, Телефон";
//	МассивНомераБылиОтправки = Новый Массив();
//	//СтруктураОтбора = Новый Структура(СтрокаОтбора);
//	Для Каждого СтрокаДляОтправки Из СтрокиДляОтправки Цикл
//		
//		Если СтрДлина(Формат(СтрокаДляОтправки.Телефон, "ЧГ=0")) <> 10 Тогда
//			// Сообщить о пропуске строки
//			Продолжить;
//		КонецЕсли;
//		
//		//ЗаполнитьЗначенияСвойств(СтруктураОтбора, СтрокаДляОтправки, СтрокаОтбора);
//		//Если ТаблицаОбработаныхПозиций.НайтиСтроки(СтруктураОтбора).Количество() = 0 Тогда
//		Если МассивНомераБылиОтправки.Найти(СтрокаДляОтправки.Телефон) = Неопределено Тогда
//			
//			СообщениеSMS = ШаблонОтправки.ТекстСообщения;
//			СообщениеSMS = СтрЗаменить(СообщениеSMS, "[Товар]"	, СтрокаДляОтправки.Товар);
//			СообщениеSMS = СтрЗаменить(СообщениеSMS, "[ФИО]"	, СокрЛП(СтрокаДляОтправки.ФИО));
//			
//			ТекстЗапроса = СтрЗаменить(ТекстЗапроса, "~~~~~"	, Формат(СтрокаДляОтправки.Телефон, "ЧГ=0"));
//			ТекстЗапроса = СтрЗаменить(ТекстЗапроса, "^^^^^"	, СообщениеSMS);
//			
//			
//			База_ВыполнитьЗапросНеЗаполняяТЗ(ТекстЗапроса,, СтрокаПодключения);
//			СтрокаВозврата = "Сообщения отправлены.";
//			
//			//НовСтр = ТаблицаОбработаныхПозиций.Добавить();
//			//ЗаполнитьЗначенияСвойств(НовСтр, СтрокаДляОтправки);
//			
//			МассивНомераБылиОтправки.Добавить(СтрокаДляОтправки.Телефон);
//			
//		КонецЕсли;
//		
//		// установка флага "Отправлено СМС"
//		НаборЗаписей = РегистрыСведений.ОбращенияПокупателей.СоздатьНаборЗаписей();
//		НаборЗаписей.Отбор.GUID_Загрузки.Установить(СтрокаДляОтправки.Бланк);
//		НаборЗаписей.Прочитать();
//		Для Каждого Запись Из НаборЗаписей Цикл
//			Запись.ОтправленоСМСПокупателю = Истина;
//		КонецЦикла;
//		НаборЗаписей.Записать();
//		
//	КонецЦикла;	
//	
//	Возврат СтрокаВозврата;
//	
//КонецФункции

Функция КнОтправитьНаСервере()
	
	ТО = РеквизитФормыВЗначение("ТаблицаОтправки");
	//АК БЕЛН 10.05.2016++
	ТО.Свернуть("ФИО, Товар, Телефон, Бланк, Пометка");
	ТаблицаОбработаныхПозиций.Очистить();	
	//АК БЕЛН 10.05.2016--
	СтрокиДляОтправки = ТО.НайтиСтроки(Новый Структура("Пометка", Истина));
	
	СтрокаВозврата = "";	
	
	//+++АК KRAV 2018.12.12 ИП-00020550    		
	//ТекстЗапроса =
	ТекстЗапросаОбразец=
	"Insert into IES..Outgoing
	|	(Number,
	|	Message)
	|Select
	|	/**BPar1**/'~~~~~'/**FPar**/,
	|	/**BPar2**/'^^^^^'/**FPar**/";
	//---АК KRAV 2018.12.12 ИП-00020550
		
	СтрокаПодключения = ВнешниеДанные.ПолучитьСтрокуПодключенияMSSQL("srv-sql01", "SMSGate");
	
	//минеев заглушка от задвоенных записей в таблицу скл
	//СтрокаОтбора = "ФИО, Товар, Телефон";
	МассивНомераБылиОтправки = Новый Массив();
	//СтруктураОтбора = Новый Структура(СтрокаОтбора);
	Для Каждого СтрокаДляОтправки Из СтрокиДляОтправки Цикл
		//+++АК KRAV 2018.12.12 ИП-00020550    		
		//ДлинаНомера = СтрДлина(Формат(СтрокаДляОтправки.Телефон, "ЧГ=0"));
		ТелефонКОтправке=СокрЛП(СтрокаДляОтправки.Телефон);
		ДлинаНомера=СтрДлина(ТелефонКОтправке);
		//---АК KRAV 2018.12.12 ИП-00020550
		Если ДлинаНомера <> 10
			И ДлинаНомера <> 11 Тогда
			// Сообщить о пропуске строки
			Продолжить;
		КонецЕсли;
		
		//+++АК KRAV 2018.12.12 ИП-00020550    		
		//ТелефонКОтправке = Формат(СтрокаДляОтправки.Телефон, "ЧГ=0");
		//---АК KRAV 2018.12.12 ИП-00020550
		Если ДлинаНомера = 10 Тогда
			ТелефонКОтправке = "7" + ТелефонКОтправке;
		КонецЕсли;	
		//ЗаполнитьЗначенияСвойств(СтруктураОтбора, СтрокаДляОтправки, СтрокаОтбора);
		//Если ТаблицаОбработаныхПозиций.НайтиСтроки(СтруктураОтбора).Количество() = 0 Тогда
		Если МассивНомераБылиОтправки.Найти(ТелефонКОтправке) = Неопределено Тогда
			
			СообщениеSMS = ШаблонОтправки.ТекстСообщения;
			СообщениеSMS = СтрЗаменить(СообщениеSMS, "[Товар]"	, СтрокаДляОтправки.Товар);
			СообщениеSMS = СтрЗаменить(СообщениеSMS, "[ФИО]"	, СокрЛП(СтрокаДляОтправки.ФИО));
			
			//+++АК KRAV 2018.12.14 ИП-00020550    		
			//ТекстЗапроса = СтрЗаменить(ТекстЗапроса, "~~~~~"	, ТелефонКОтправке);
			//ТекстЗапроса = СтрЗаменить(ТекстЗапроса, "^^^^^"	, СообщениеSMS);
			ТекстЗапроса = СтрЗаменить(ТекстЗапросаОбразец, "~~~~~"	, ТелефонКОтправке);
			ТекстЗапроса = СтрЗаменить(ТекстЗапроса, "^^^^^"	, СообщениеSMS);
			//---АК KRAV 2018.12.14 ИП-00020550
			
			
			База_ВыполнитьЗапросНеЗаполняяТЗ(ТекстЗапроса,, СтрокаПодключения);
			СтрокаВозврата = "Сообщения отправлены.";
			
			//НовСтр = ТаблицаОбработаныхПозиций.Добавить();
			//ЗаполнитьЗначенияСвойств(НовСтр, СтрокаДляОтправки);
			
			МассивНомераБылиОтправки.Добавить(ТелефонКОтправке);
			
		КонецЕсли;
		
		// установка флага "Отправлено СМС"
		НаборЗаписей = РегистрыСведений.ОбращенияПокупателей.СоздатьНаборЗаписей();
		НаборЗаписей.Отбор.GUID_Загрузки.Установить(СтрокаДляОтправки.Бланк);
		НаборЗаписей.Прочитать();
		Для Каждого Запись Из НаборЗаписей Цикл
			Запись.ОтправленоСМСПокупателю = Истина;
		КонецЦикла;
		НаборЗаписей.Записать();
		
	КонецЦикла;	
	
	Возврат СтрокаВозврата;
	
КонецФункции



&НаКлиенте
Процедура ОтправитьСМС(Команда)
	
	Режим = РежимДиалогаВопрос.ДаНет;
	Текст = "ru = ""Отправить сообщения?""";
	Ответ = Вопрос(НСтр(Текст), Режим, 0);
	Если Ответ = КодВозвратаДиалога.Нет Тогда
	    Возврат;
	КонецЕсли;
    
	Предупреждение(КнОтправитьНаСервере());
	
КонецПроцедуры

&НаСервере
Процедура База_ВыполнитьЗапросНеЗаполняяТЗ(ТекстЗапроса, допПараметры = Неопределено, СтрокаПодключения = "")  
	
	RecordSet = База_ВыполнитьЗапрос(ТекстЗапроса, допПараметры, СтрокаПодключения);
	Попытка
		RecordSet.Close();
	Исключение
	КонецПопытки;	
		
КонецПроцедуры

&НаСервере
Функция База_ВыполнитьЗапрос(ТекстЗапроса, допПараметры = Неопределено, СтрокаПодключения = "")  
	
	Попытка
		Command = Новый COMОбъект("ADODB.Command");
		
		Если ТипЗнч(допПараметры) = Тип("Структура") тогда
			ЗаполнитьЗначенияСвойств(Command, допПараметры);
		КонецЕсли;			
		CurrentConnection = База_Подключение(СтрокаПодключения);
		Command.ActiveConnection 	= CurrentConnection;
		Command.CommandTimeout 		= 0;
		Command.CommandText 		= ТекстЗапроса;
		RecordSet = Новый COMОбъект("ADODB.RecordSet");
		RecordSet = Command.Execute(); //Выполнение и получение набора данных
		Возврат RecordSet;
	Исключение	
		ВызватьИсключение ОписаниеОшибки();
	КонецПопытки;
	
КонецФункции

&НаСервере
Функция База_Подключение(СтрокаПодключения) экспорт	
	
	Попытка
		CurrentConnection = Новый COMОбъект("ADODB.Connection");
		Catalog = Новый COMОбъект("ADOX.Catalog");			
		
		//СтрокаПодключения = "Provider=SQLOLEDB.1;Persist Security Info=True;Initial Catalog=SMS_UNION;Data Source=srv-sql01;Password=cjyzcjyz;User ID=izbenka";
		//СтрокаПодключения = "Provider=SQLOLEDB.1;Persist Security Info=True;Initial Catalog=Loyalty;Data Source=srv-sql01;Password=cjyzcjyz;User ID=izbenka";
		
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

&НаКлиенте
Процедура ШаблонОтправкиПриИзменении(Элемент)
	
	ЗаполнитьСписокСообщенийСервер();
	
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьСписокСообщенийСервер()
	
	ЭтаФорма.ПереченьСообщений.Очистить();
	
	НомерСтроки = 1;
	Для каждого СтрокаДляОтправки Из ЭтаФорма.ТаблицаОтправки Цикл
		НоваяСтрока = ЭтаФорма.ПереченьСообщений.Добавить();
		СообщениеSMS = ШаблонОтправки.ТекстСообщения;
		СообщениеSMS = СтрЗаменить(СообщениеSMS, "[Товар]"	, СтрокаДляОтправки.Товар);
		СообщениеSMS = СтрЗаменить(СообщениеSMS, "[ФИО]"	, СтрокаДляОтправки.ФИО);
		НоваяСтрока.НомерСтроки		= НомерСтроки;
		НоваяСтрока.НомерТелефона	= СтрокаДляОтправки.Телефон;
		НоваяСтрока.ТекстСообщения	= СообщениеSMS;
		НомерСтроки = НомерСтроки + 1;
	КонецЦикла;
	
КонецПроцедуры	

&НаКлиенте
Процедура ТаблицаОтправкиПриИзменении(Элемент)
	
	ЗаполнитьСписокСообщенийСервер();
	
КонецПроцедуры
