﻿

&НаСервере
Процедура База_ВыполнитьЗапросНеЗаполняяТЗ(ТекстЗапроса, допПараметры = Неопределено, СтрокаПодключения = "")  
	
	RecordSet = База_ВыполнитьЗапрос(ТекстЗапроса, допПараметры, СтрокаПодключения);
	//тзРезультат = База_РезульататЗапросВТаблицуЗначений(RecordSet);
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
Процедура ОтправитьСообщения(Команда)
	
	Если Вопрос("Действительно хотите отправить сообщения?", РежимДиалогаВопрос.ДаНет) = КодВозвратаДиалога.Да Тогда
		
		ОтправитьСообщенияНаСервере();
		Закрыть(Истина);
		
	КонецЕсли;	
	
КонецПроцедуры

&НаСервере
Процедура ОтправитьСообщенияНаСервере()
	
	//запишем во временную скульную таб
	Для каждого ТекСтрокадвижений Из ТаблицаSMS Цикл
		
		//	"INSERT INTO 3p ( НомерКарты_3p, Date_activation, user_call, desc_3p, id_3p_q, id_3p_v, Проект, id_type_BV, type_svyz, contact )
		//|SELECT dbo_Outgoing_prepare.CardNumber, Date() AS Выражение1, Environ("USERNAME") AS Выражение9, dbo_Outgoing_prepare.Message, dbo_Outgoing_prepare.id_3p_q, dbo_Outgoing_prepare.id_3p_v, dbo_Outgoing_prepare.Project, dbo_Outgoing_prepare.type_BV, "sms" AS Выражение8, dbo_Outgoing_prepare.Number
		//|FROM dbo_Outgoing_prepare
		//|WITH OWNERACCESS OPTION;"
		СтрокаПодключения = ВнешниеДанные.ПолучитьСтрокуПодключенияMSSQL("srv-sql01", "Loyalty");
		
		ТекстЗапроса = "/****** Сценарий для команды SelectTopNRows среды SSMS  ******/
		|insert into [IES].[dbo].[Outgoing]
		|    ([Number]                       
		|    ,[Message]
		|    ,[AddDate]
		|    ,[DiscountCardUID]
		|    ,[type_BV]
		|    ,[Project]
		|    ,[user_add])
		|VALUES 
		|	 ('7' +left('"+ТекСтрокадвижений.НомерТелефона+"',10), '"+ТекСтрокадвижений.ТекстСообщения+"','"+ТекущаяДата()+"', '"+ТекСтрокадвижений.DiscountCardUID+"', '"+2+"', '"+СокрЛП(ТекСтрокадвижений.Проект)+"', '"+СокрЛП(ПараметрыСеанса.ТекущийПользователь)+"') ;";
		
		База_ВыполнитьЗапросНеЗаполняяТЗ(ТекстЗапроса, , СтрокаПодключения);
				
		ТекстЗапроса = "update [SMS_IZBENKA].[dbo].[sms_tovar_card]
		|set sent_sms=1
		|FROM [SMS_IZBENKA].[dbo].[sms_tovar_card] (nolock) stc 
		|inner join [SMS_IZBENKA].[dbo].[sms_tovar] (nolock) st on st.id_sms_tovar= stc.id_sms_tovar
		|where st.date_sms=dateadd(day,0,CONVERT(date,getdate())) AND stc.DiscountCardUID = '"+СокрЛП(ТекСтрокадвижений.DiscountCardUID)+"';";
		База_ВыполнитьЗапросНеЗаполняяТЗ(ТекстЗапроса, , СтрокаПодключения);
		
	КонецЦикла;	
				
КонецПроцедуры

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	СписокИД = Новый СписокЗначений();
	СписокИД.ЗагрузитьЗначения(Параметры.ВходящийСписок[0].Значение);
	
	СписокGUID = Новый СписокЗначений();
	СписокGUID.ЗагрузитьЗначения(Параметры.ВходящийСписок[1].Значение);
	
	лкТекПроект = Параметры.ВходящийСписок[2];
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ
		|	ОбращенияКПокупателям.id_3p,
		|	ОбращенияКПокупателям.GUID_Загрузки,
		|	ОбращенияКПокупателям.НомерКарты_3p,
		|	ОбращенияКПокупателям.ДатаДобавления,
		|	ОбращенияКПокупателям.ДатаЗвонка,
		|	ОбращенияКПокупателям.КтоЗвонил,
		|	ОбращенияКПокупателям.ГлавныйОтвет,
		|	ОбращенияКПокупателям.Ответ2,
		|	ОбращенияКПокупателям.Ответ3,
		|	ОбращенияКПокупателям.Комментарий,
		|	ОбращенияКПокупателям.Вопрос,
		|	ОбращенияКПокупателям.Выборка,
		|	ОбращенияКПокупателям.Проект,
		|	ОбращенияКПокупателям.ТипОбращения,
		|	ОбращенияКПокупателям.Доступность,
		|	ОбращенияКПокупателям.Статус,
		|	ОбращенияКПокупателям.Контакт,
		|	ОбращенияКПокупателям.Область,
		|	ОбращенияКПокупателям.ДатаОбласть,
		|	ОбращенияКПокупателям.ТипСвязи,
		|	ОбращенияКПокупателям.DiscountCardUID
		|ИЗ
		|	РегистрСведений.ОбращенияКПокупателям КАК ОбращенияКПокупателям
		|ГДЕ
		|	ОбращенияКПокупателям.id_3p В(&id_3p)
		|	И ОбращенияКПокупателям.GUID_Загрузки В(&GUID_Загрузки)";

	Запрос.УстановитьПараметр("GUID_Загрузки", СписокGUID);
	Запрос.УстановитьПараметр("id_3p", СписокИД);

	лкТЗРезультат = Запрос.Выполнить().Выгрузить();
	i = 1;
	Для каждого ТекСтр Из лкТЗРезультат Цикл
	
		НоваяСтр = ТаблицаSMS.Добавить();	
		НоваяСтр.НомерСтроки = i;
		НоваяСтр.НомерТелефона = ТекСтр.Контакт;
		НоваяСтр.ТекстСообщения = СокрЛП(ТекСтр.Комментарий);
	    НоваяСтр.GUID_Загрузки = СокрЛП(ТекСтр.GUID_Загрузки);
		НоваяСтр.DiscountCardUID = СокрЛП(ТекСтр.DiscountCardUID);
		НоваяСтр.Проект = СокрЛП(лкТекПроект);
		i = i + 1;
		
	КонецЦикла;
	
КонецПроцедуры

&НаКлиенте
Процедура ЗакрытьЭтуФорму(Команда)
	
	СписовВозможныхОтветов = Новый СписокЗначений;
	СписовВозможныхОтветов.Добавить("Да, очистить...");
	СписовВозможныхОтветов.Добавить("Нет, просто закрыть эту форму");
	СписовВозможныхОтветов.Добавить("Отменить закрытие этой формы");
	
	РезВопроса = Вопрос("Сообщения не отправлены. Очистить выбранные записи?", СписовВозможныхОтветов);
	
	Если РезВопроса = "Да, очистить..." Тогда
		
		ОчиститьЗаписиРегистраНаСервере();		
		ЭтаФорма.Закрыть();
		
	ИначеЕсли РезВопроса = "Нет, просто закрыть эту форму" Тогда
		 ЭтаФорма.Закрыть();
	ИначеЕсли РезВопроса = "Отменить закрытие этой формы" Тогда
		 Возврат;
	КонецЕсли;	
	
	
КонецПроцедуры

&НаСервере
Процедура ОчиститьЗаписиРегистраНаСервере()

	
	ТекПарам = ТаблицаSMS[0].GUID_Загрузки;
	
	Набор = РегистрыСведений.ОбращенияКПокупателям.СоздатьНаборЗаписей();		
	Набор.Отбор.GUID_Загрузки.Установить(ТекПарам);
	Набор.Прочитать();
	Набор.Очистить();
	Набор.Записать();
	
КонецПроцедуры


