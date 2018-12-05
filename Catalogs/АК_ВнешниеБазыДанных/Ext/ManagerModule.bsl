﻿

//////////////////////////////////////////////////////////////
//ADO

//
//
Функция ADO_Execute(ADOСоединение, ТекстЗапроса) Экспорт
	
	//
	Попытка
		ADORecordSet = ADOСоединение.Execute(ТекстЗапроса);
	Исключение
		ADORecordSet = Неопределено;
		Сообщить(ОписаниеОшибки());
	КонецПопытки;	

	//
	Возврат ADORecordSet;
	
КонецФункции	

//
//
Функция ADO_Connection(СтрокаПоключения) Экспорт
	
	//
	ADOСоединение = Новый COMОбъект("ADODB.Connection");
	ADOСоединение.ConnectionTimeOut = 0;
	ADOСоединение.CommandTimeOut    = 0;
	ADOСоединение.ConnectionString  = СтрокаПоключения;
	
	//
	Попытка
		ADOСоединение.Open();
	Исключение
		ADOСоединение = Неопределено;
		Сообщить(ОписаниеОшибки());
	КонецПопытки;	

	//
	Возврат ADOСоединение;
	
КонецФункции

//////////////////////////////////////////////////////////////
//ADO->1C

//
//
Функция RecordSet_в_ТаблицуЗначений(RecordSet) Экспорт 
	
	//
	РезультатТЗ = Новый ТаблицаЗначений;
	
	//
	Для Каждого Field Из RecordSet.Fields Цикл
		
		//
		РезультатТЗ.Колонки.Добавить(Field.Name);
		
	КонецЦикла;	
	
	//
	Если НЕ RecordSet.EOF Тогда
		
		//
		RecordSet.MoveFirst();
		
		//
		Пока НЕ RecordSet.EOF Цикл
			
			//
			НоваяСтрока = РезультатТЗ.Добавить();
			Для Каждого Колонка Из РезультатТЗ.Колонки Цикл
				
				//
				Индекс = РезультатТЗ.Колонки.Индекс(Колонка);
				
				//
				НоваяСтрока[Индекс] = RecordSet.Fields.Item(Индекс).Value;
					
			КонецЦикла;	
			
			//
			Если НЕ RecordSet.EOF Тогда 
				RecordSet.MoveNext();
			КонецЕсли;	
			
		КонецЦикла;	
		
	КонецЕсли;	
	
	//
	Возврат РезультатТЗ;
	
КонецФункции	

//////////////////////////////////////////////////////////////
//1С

//
//
Функция ПолучитьОписаниеПолейТаблицыБазыДанных(БазаДанных, ИмяТаблицы) Экспорт
	
	//
	РезультатТЗ = Новый ТаблицаЗначений;
	
	//
	ADOСоединение = ADO_Connection(БазаДанных.СтрокаПодключения);	
	Если ADOСоединение <> Неопределено Тогда
		
		//
		RecordSet = ADO_Execute(ADOСоединение, СтрЗаменить("exec sp_columns @table_name = &table_name", "&table_name", ИмяТаблицы)); 
		
		//
		РезультатТЗ = RecordSet_в_ТаблицуЗначений(RecordSet); 
		
	КонецЕсли;	
	
	//
	Возврат РезультатТЗ;
	
КонецФункции	

//
//
Функция ПолучитьОписаниеТаблицБазыДанных(БазаДанных) Экспорт
	
	//
	РезультатТЗ = Новый ТаблицаЗначений;
	
	//
	ADOСоединение = ADO_Connection(БазаДанных.СтрокаПодключения);	
	Если ADOСоединение <> Неопределено Тогда
		
		//
		RecordSet = ADO_Execute(ADOСоединение, "exec sp_tables @table_owner = 'dbo'"); 
		
		//
		РезультатТЗ = RecordSet_в_ТаблицуЗначений(RecordSet); 
		
	КонецЕсли;	
	
	//
	Возврат РезультатТЗ;
	
КонецФункции	

///////////

//
Функция СоздатьТаблицуВнешнейБазыДанных(БазаДанных, ИмяТаблицы) Экспорт
	
	//
	РезультатЭлемент = Неопределено;
	
	//
	СправочникОбъект = Справочники.АК_ТаблицыВнешнейБазыДанных.СоздатьЭлемент();
	СправочникОбъект.Владелец = БазаДанных;
	СправочникОбъект.Код = ИмяТаблицы;
	
	//
	ТЗ_ОписаниеПолей = ПолучитьОписаниеПолейТаблицыБазыДанных(БазаДанных, ИмяТаблицы);
	Для Каждого СтрокаТЗ Из ТЗ_ОписаниеПолей Цикл
		
		//
		НоваяСтрока = СправочникОбъект.Поля.Добавить();
		НоваяСтрока.Имя = СтрокаТЗ.COLUMN_NAME;
		НоваяСтрока.Тип = СтрокаТЗ.TYPE_NAME;
		
	КонецЦикла;	
	
	//
	Попытка
		
		СправочникОбъект.Записать();
		
		//
		РезультатЭлемент = СправочникОбъект.Ссылка;
		
	Исключение	
		Сообщить(ОписаниеОшибки());
	КонецПопытки;	
	
	//
	Возврат РезультатЭлемент;
	
КонецФункции	
	
///////////

//
//
Функция ПолучитьТаблицуСРезультатомВыполненияЗапросовКВнешнейБазеДанных(БазаДанных, СводнаяТаблица, ТаблицаВыбранныхПолей, КомпоновщикНастроек) Экспорт
	
	//
	РезультатТЗ = Новый ТаблицаЗначений;
	
	//
	ТекстЗапроса = "";
	
	//
	Для Каждого СтрокаТЗ Из СводнаяТаблица Цикл
		
		//
		МассивПолей = Новый Массив;
		
		//
		Если ЗначениеЗаполнено(ТекстЗапроса) Тогда
			ТекстЗапроса = ТекстЗапроса + Символы.ПС + " UNION ALL " + Символы.ПС;
		КонецЕсли;	
		
		//
		Для Каждого _СтрокаТЗ Из ТаблицаВыбранныхПолей Цикл
			
			//
			Если НЕ _СтрокаТЗ.Пометка Тогда
				Продолжить;
			КонецЕсли;	
			
			//
			стрОписаниеПоля = "";
			
			//
			ИмяРеквизита = _СтрокаТЗ.ИмяПоля;
			ЗначениеРеквизита = _СтрокаТЗ[СтрокаТЗ.ИмяТаблицы];
			
			//
			Если ЗначениеЗаполнено(ЗначениеРеквизита) Тогда
				стрОписаниеПоля = ЗначениеРеквизита + " as " + ИмяРеквизита;
			Иначе
				стрОписаниеПоля = "NULL as " + ИмяРеквизита;
			КонецЕсли;
			
			//
			МассивПолей.Добавить(стрОписаниеПоля);
			
		КонецЦикла;	
		
		//
		СтрокаТекстЗапроса = "";
		
		//
		Для Каждого ЭлементМассива Из МассивПолей Цикл
			СтрокаТекстЗапроса = СтрокаТекстЗапроса + ЭлементМассива + ", " + Символы.ПС;
		КонецЦикла;	
		
		//
		СтрокаТекстЗапроса = Лев(СтрокаТекстЗапроса, СтрДлина(СтрокаТекстЗапроса) - 3);
		
		//
		СтрокаТекстЗапроса = "SELECT " + Символы.ПС + СтрокаТекстЗапроса + Символы.ПС + " FROM " + СтрокаТЗ.ИмяТаблицы;
		
		//??? ТУТ КУСОК С ОТБОРАМИ ДОЛЖЕН БЫТЬ
		
		//
		ТекстЗапроса = ТекстЗапроса + СтрокаТекстЗапроса;
		
	КонецЦикла;	
	
	//ВСЕГДА ЗАПИХИВАЕМ ВО ВЛОЖЕННЫЙ
	
	//
	МассивПолейДляГруппировки = Новый Массив;
	МассивВыбранныхПолей = Новый Массив;
	МассивПолейСАгрегатнымиФункциями = Новый Массив;	
	
	//
	Для Каждого _СтрокаТЗ Из ТаблицаВыбранныхПолей Цикл
		
		//
		Если НЕ _СтрокаТЗ.Пометка Тогда
			Продолжить;
		КонецЕсли;	
			
		//
		стрОписаниеПоля = "";
		
		//
		ИмяРеквизита = _СтрокаТЗ.ИмяПоля;
		ЗначениеРеквизита = _СтрокаТЗ.ИмяПоля;
		
		//
		Если ЗначениеЗаполнено(_СтрокаТЗ.Формула) Тогда
			ЗначениеРеквизита = "(" + _СтрокаТЗ.Формула +")";
		КонецЕсли;
			
		//
		Если ЗначениеЗаполнено(_СтрокаТЗ.Функция) Тогда
			
			//
			стрОписаниеПоля = _СтрокаТЗ.Функция + "(" + ЗначениеРеквизита + ") as " + ИмяРеквизита;
			
			//
			МассивПолейСАгрегатнымиФункциями.Добавить(стрОписаниеПоля);
			
		Иначе
			
			//
			Если ЗначениеЗаполнено(_СтрокаТЗ.Формула) Тогда
				МассивВыбранныхПолей.Добавить(ЗначениеРеквизита + " as " + ИмяРеквизита);
				МассивПолейДляГруппировки.Добавить(_СтрокаТЗ.Формула);
			Иначе	
				МассивВыбранныхПолей.Добавить(ИмяРеквизита);
				МассивПолейДляГруппировки.Добавить(ИмяРеквизита);
			КонецЕсли;
			
		КонецЕсли;
		
	КонецЦикла;	
		
	//
	СтрокаТекстЗапроса = "";
	
	//
	Для Каждого ЭлементМассива Из МассивВыбранныхПолей Цикл
		СтрокаТекстЗапроса = СтрокаТекстЗапроса + ЭлементМассива + ", " + Символы.ПС;
	КонецЦикла;	
	
	//
	Для Каждого ЭлементМассива Из МассивПолейСАгрегатнымиФункциями Цикл
		СтрокаТекстЗапроса = СтрокаТекстЗапроса + ЭлементМассива + ", " + Символы.ПС;
	КонецЦикла;	
	
	//
	СтрокаТекстЗапроса = Лев(СтрокаТекстЗапроса, СтрДлина(СтрокаТекстЗапроса) - 3);
	
	//
	СтрокаТекстЗапроса = "SELECT TOP 1000" + Символы.ПС + СтрокаТекстЗапроса + Символы.ПС + " FROM (" + ТекстЗапроса +") as QUERY" + Символы.ПС;
	
	//
	Если МассивПолейСАгрегатнымиФункциями.Количество() > 0 Тогда 
		
		//
		СтрокаТекстЗапроса = СтрокаТекстЗапроса + "GROUP BY" + Символы.ПС;
		
		//
		Для Каждого ЭлементМассива Из МассивПолейДляГруппировки Цикл
			СтрокаТекстЗапроса = СтрокаТекстЗапроса + ЭлементМассива + ", " + Символы.ПС;
		КонецЦикла;
		
		//
		СтрокаТекстЗапроса = Лев(СтрокаТекстЗапроса, СтрДлина(СтрокаТекстЗапроса) - 3);
		
	КонецЕсли;	
	
	//
	ТекстЗапроса = СтрокаТекстЗапроса;
	
	//
	ADOСоединение = ADO_Connection(БазаДанных.СтрокаПодключения);	
	Если ADOСоединение <> Неопределено Тогда

		//
		RecordSet = ADO_Execute(ADOСоединение, ТекстЗапроса); 
		Если RecordSet = Неопределено Тогда
			Сообщить("Возникли ошибки при выполнении запроса");
			Возврат РезультатТЗ;
		КонецЕсли; 
		
		//
		РезультатТЗ = RecordSet_в_ТаблицуЗначений(RecordSet);
		
	КонецЕсли;
	
	//
	Возврат РезультатТЗ;
	
КонецФункции	

