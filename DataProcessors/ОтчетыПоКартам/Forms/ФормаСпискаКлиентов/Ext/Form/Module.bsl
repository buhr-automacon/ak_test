﻿  
// Выполянет запрос и резульатат запроса возвращает в таблицу значений
//
&НаСервере
Процедура База_ВыполнитьЗапросИЗаполнитьТаблицуЗначений(ТекстЗапроса, допПараметры = Неопределено)  
	
	RecordSet = База_ВыполнитьЗапрос(ТекстЗапроса, допПараметры);
	тзРезультат = База_РезульататЗапросВТаблицуЗначений(RecordSet);
	RecordSet.Close();
	
 //   Для каждого ТекСтрока Из тзРезультат Цикл
 //
 //		ТекСтрока.Дата = Дата(ТекСтрока.Дата);
 //
 //   КонецЦикла;	
 //   тзРезультат.Сортировать("Дата Убыв");
 //   
 //   Объект.ТЗ_СМС_ВсеПоКлиенту.Загрузить(тзРезультат);
	
КонецПроцедуры

&НаСервере
Процедура База_ВыполнитьЗапросНеЗаполняяТЗ(ТекстЗапроса, допПараметры = Неопределено)  
	
	RecordSet = База_ВыполнитьЗапрос(ТекстЗапроса, допПараметры);
	тзРезультат = База_РезульататЗапросВТаблицуЗначений(RecordSet);
	RecordSet.Close();
		
КонецПроцедуры


&НаСервере
Функция База_ВыполнитьЗапрос(ТекстЗапроса, допПараметры = Неопределено, СтрокаПодключения = "")  
	Попытка
		Command = Новый COMОбъект("ADODB.Command");
		
		Если ТипЗнч(допПараметры) = Тип("Структура") тогда
			ЗаполнитьЗначенияСвойств(Command, допПараметры);
		КонецЕсли;			
		CurrentConnection = База_Подключение(СтрокаПодключения);
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
Процедура ПриОткрытии(Отказ)
	
	ЗаполнитьТЧНаСервере(СокрЛП(Параметры.Фамилия), СокрЛП(Параметры.Телефон), Формат(Параметры.ДатаРождения, "ДФ=yyyyMMdd"), СокрЛП(Параметры.email));
	
	Если Объект.Customer.Количество() = 1 Тогда
		
		СтруктураПараметровФормы = Новый Структура;
		СтруктураПараметровФормы.Вставить("CustomerUID",Объект.Customer[0].CustomerUID);
		СтруктураПараметровФормы.Вставить("rowguid",Объект.Customer[0].rowguid);
		//+++АК SHEP 2018.05.08 ИП-00018563
		//СтруктураПараметровФормы.Вставить("Email",Объект.Customer[0].Email);
		СтруктураПараметровФормы.Вставить("Email",Объект.Customer[0].bc_number);
		//---АК SHEP 2018.05.08
	
		ОткрытьФорму("Обработка.ОтчетыПоКартам.Форма.КарточкаКлиента", СтруктураПараметровФормы);	
		
		Отказ = Истина;
		
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьТЧНаСервере(Фамилия, Телефон, ДатаРождения, email)
	
	ТекстЗапроса = "SELECT  *  from dbo.Customer (nolock) WHERE ";
	
	Если ЗначениеЗаполнено(Фамилия) Тогда
		ТекстЗапроса = ТекстЗапроса +" [Фамилия] LIKE '%" +Фамилия+"%' ";
	КонецЕсли;
	
	Если ЗначениеЗаполнено(Телефон) Тогда
		
		Если ЗначениеЗаполнено(Фамилия) Тогда
			ТекстЗапроса = ТекстЗапроса +" AND [Phone] LIKE '%" +Телефон+"%' ";
		Иначе
			ТекстЗапроса = ТекстЗапроса +" [Phone] LIKE '%" +Телефон+"%' ";
		КонецЕсли;
		
	КонецЕсли;
	
	Если ЗначениеЗаполнено(ДатаРождения) Тогда
		Если ЗначениеЗаполнено(Фамилия) ИЛИ ЗначениеЗаполнено(Телефон) Тогда
			ТекстЗапроса = ТекстЗапроса +" AND [Birthday] = '"+ ДатаРождения +"' ";
		Иначе
			ТекстЗапроса = ТекстЗапроса +" [Birthday] = '"+ ДатаРождения +"' ";
		КонецЕсли;	
	КонецЕсли;
	
	Если ЗначениеЗаполнено(email) Тогда
		Если ЗначениеЗаполнено(Фамилия) ИЛИ ЗначениеЗаполнено(Телефон) ИЛИ ЗначениеЗаполнено(ДатаРождения) Тогда
			ТекстЗапроса = ТекстЗапроса +" AND [Email_fact] LIKE '%" +email+"%' ";
		Иначе
			ТекстЗапроса = ТекстЗапроса +" [Email_fact] LIKE '%" +email+"%' ";
		КонецЕсли;	
		
	КонецЕсли;
	
	ТекстЗапроса = ТекстЗапроса +" ;";
		
	СтрокаПодключения = ВнешниеДанные.ПолучитьСтрокуПодключенияMSSQL("srv-sql01", "Loyalty");
	
	RecordSet = База_ВыполнитьЗапрос(ТекстЗапроса, , СтрокаПодключения);
	ТЗ = База_РезульататЗапросВТаблицуЗначений(RecordSet);
	
	Объект.Customer.Загрузить(ТЗ.Скопировать());
	//+++АК SHEP 2018.05.08 ИП-00018563
	//Объект.Customer.Сортировать("Email");
	Объект.Customer.Сортировать("bc_number");
	//---АК SHEP 2018.05.08
	RecordSet.Close();
	
КонецПроцедуры

&НаКлиенте
Процедура CustomerВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	
	СтруктураПараметровФормы = Новый Структура;
	СтруктураПараметровФормы.Вставить("CustomerUID",Элемент.ТекущиеДанные.CustomerUID);
	СтруктураПараметровФормы.Вставить("rowguid",Элемент.ТекущиеДанные.rowguid);
	//+++АК SHEP 2018.05.08 ИП-00018563
	//СтруктураПараметровФормы.Вставить("Email",Элемент.ТекущиеДанные.Email);
	СтруктураПараметровФормы.Вставить("Email", Элемент.ТекущиеДанные.bc_number);
	//---АК SHEP 2018.05.08
	
	ОткрытьФорму("Обработка.ОтчетыПоКартам.Форма.КарточкаКлиента", СтруктураПараметровФормы);
	
КонецПроцедуры

&НаКлиенте
Процедура ОбновитьДанные(Команда)
	
	ЗаполнитьТЧНаСервере(СокрЛП(Параметры.Фамилия), СокрЛП(Параметры.Телефон), Формат(Параметры.ДатаРождения, "ДФ=yyyyMMdd"), СокрЛП(Параметры.email));
	
КонецПроцедуры
