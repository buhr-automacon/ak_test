﻿
////////////////////////////////////////////////////////////////////////////////
// СЛУЖЕБНЫЕ ПРОЦЕДУРЫ И ФУНКЦИИ

#Область КонтрольПросроченногоТовара

// Процедура формирует список магазинов по которым необходимо запустить "обнуление" 
// позиций в таблице SMS_REPL.TD_OstDetail, если фактический остаток (SMS_REPL.TD_Ost) равен "0".
//
Процедура ОбнулениеПозицийБезОстаткаВсеМагазины() Экспорт
	
	ТаблицаМагазинов = Новый ТаблицаЗначений();
	
	ТаблицаМагазинов.Колонки.Добавить("ShopNo", Новый ОписаниеТипов("Число", Новый КвалификаторыЧисла(10, 0)));
	
	ADOСоединение = ВнешниеДанные.ПолучитьADOСоединение();
	
	ТекстЗапросаМагазины = "
	|SELECT [ShopNo]
	|FROM [SMS_REPL].[dbo].[TD_ost_detail]
	|GROUP BY [ShopNo]
	|ORDER BY [ShopNo]";
	
	rs = ADOСоединение.Execute(ТекстЗапросаМагазины);
	
	Попытка
		rs.MoveFirst();
		Сч = 1;
		Пока НЕ rs.EOF() Цикл

			НоваяСтрока = ТаблицаМагазинов.Добавить();
			
			НоваяСтрока.ShopNo = rs.Fields("ShopNo").Value;

			Сч = Сч+1;
			rs.MoveNext();
		КонецЦикла;
	Исключение
		
		ЗаписьЖурналаРегистрации("ИнформационнаяБаза.РеглмОбнулениеПозицийБезОстатка", УровеньЖурналаРегистрации.Ошибка, , , 
					СтрЗаменить(НСтр("ru = 'Не удалось сформировать список магазинов! ОписаниеОшибки'", "ru"), "ОписаниеОшибки", ОписаниеОшибки()));

		ADOСоединение.Close();
		
		Возврат;
		
	КонецПопытки;
	
	//Очистка позиций с нулевыми остатками по каждому из магазинов отдельно
	Для каждого Строка Из ТаблицаМагазинов Цикл
		Обработки.РабочийСтолПродавца.ОбнулениеПозицийБезОстатка(Строка.ShopNo, ADOСоединение, "NULL");
	КонецЦикла;
	
	ADOСоединение.Close();
	
КонецПроцедуры // ОбнулениеПозицийБезОстаткаВсеМагазины()

//Процедура предназначена для списания позиций из TD_ost_detail если нет фактического остатка товара (TD_ost)
//
//Параметры: 
//		id_TT - номер торговой точки.
//      ADOСоединение - Соединение
//      id_user - Уникальный идентификатор пользователя
Процедура ОбнулениеПозицийБезОстатка(Знач id_TT, ADOСоединение = Неопределено, Знач id_user = Неопределено) Экспорт
	
	Если ADOСоединение = Неопределено Тогда
		ADOСоединение = ВнешниеДанные.ПолучитьADOСоединение();
	КонецЕсли;
	
	Если id_user = Неопределено Тогда
		id_user = ПолучитьGUIDАвтора();
	КонецЕсли;
	
	ТекстЗапроса = 
	
	"declare @err int =1
	|while @err=1
	|begin
	| begin try
	//Основной текст запроса
	|INSERT INTO SMS_REPL.dbo.TD_ost_detail
	|                      (ShopNo, id_tov, id_kontr, date_proizv, balance_ost, comment, id_user)
	|SELECT TD_ost_detail.ShopNo
	|, TD_ost_detail.id_tov
	|, TD_ost_detail.id_kontr
	|, TD_ost_detail.date_proizv
	|, - SUM(TD_ost_detail.balance_ost) AS balance_ost
	|, 'correction' AS comment
	|, &id_user AS id_user
	|FROM (SELECT id_tov, ShopNo_rep
	|          FROM SMS_REPL.dbo.TD_ost WITH (nolock)
	|          WHERE(ShopNo_rep = &id_TT)
	|          GROUP BY id_tov, ShopNo_rep
	|          HAVING(SUM(Ost_kon) = 0)) AS Tab_ost LEFT JOIN
	|          SMS_REPL.dbo.TD_ost_detail AS TD_ost_detail WITH (nolock) ON 
	|                   Tab_ost.ShopNo_rep = TD_ost_detail.ShopNo 
	|								AND Tab_ost.id_tov = TD_ost_detail.id_tov
	|WHERE (TD_ost_detail.ShopNo = &id_TT) 
	|--AND (TD_ost_detail.id_tov = '371')
	|GROUP BY TD_ost_detail.ShopNo, TD_ost_detail.id_tov, TD_ost_detail.id_kontr, TD_ost_detail.date_proizv
	|HAVING (SUM(TD_ost_detail.balance_ost) <> 0)	
	//Основной текст запроса
	|select @err=0
	| 
	| END TRY
	|  BEGIN CATCH
	| 
	|if CHARINDEX('вызвала взаимоблокировку ресурсов',ERROR_MESSAGE(),1)>0
	|begin
	|-- запись в лог факта блокировки
	|	set @err=1
	|end
	|else
	|begin
	| 
	|-- прочая ошибка - выход  
	| return
	| end
	| 
	|  END CATCH 
	|end -- while";
	
	Если id_user = "NULL" Тогда
		ТекстЗапроса = СтрЗаменить(ТекстЗапроса, "&id_user", id_user);
		ТекстЗапроса = СтрЗаменить(ТекстЗапроса, "correction", "correction (регламент)");
	Иначе
		ТекстЗапроса = СтрЗаменить(ТекстЗапроса, "&id_user", ВнешниеДанные.ФорматПоля(id_user));
	КонецЕсли;
	
	ТекстЗапроса = СтрЗаменить(ТекстЗапроса, "&id_TT", ВнешниеДанные.ФорматПоля(id_TT));
	
	Попытка	
		ADOСоединение.Execute(ТекстЗапроса);
	Исключение
		ЗаписьЖурналаРегистрации("Ошибка создания записей Correction", УровеньЖурналаРегистрации.Ошибка,,, 
							ОписаниеОшибки() + Символы.ПС + "Выполняемый запрос" + Символы.ПС + ТекстЗапроса);
	КонецПопытки;	
	
КонецПроцедуры

//Функция возвращает строку уникального идентификатора продавца
//или текущего пользователя
Функция ПолучитьGUIDАвтора()
	
	Попытка
		АвторИзменения = ПараметрыСеанса.ТекущийПродавец;
	Исключение
	КонецПопытки;
	
	Если НЕ ЗначениеЗаполнено(АвторИзменения) Тогда
		Попытка
			АвторИзменения = ПараметрыСеанса.ТекущийПользователь;
		Исключение
			Возврат NULL;
		КонецПопытки;
	КонецЕсли;
	
	Возврат Строка(АвторИзменения.УникальныйИдентификатор());
	
КонецФункции

// Процедура добавления записей по отредактированным пользователями строкам ("Редактирование просрочки")
// в таблицу [SMS_REPL].[dbo].[TD_ost_detail]
//
// Параметры:
// id_TT            - <Тип.Число>     - Номер магазина
// СтруктураДанных  - <Тип.Структура> - Структура параметров добавления 
//                                     (id_tov, ПроизводительИД, ДатаПроизводства, id_doc, date)
// ADOСоединение    - <Тип.ComОбъект> - Соединение с базой SMS_REPL
// МассивИдентификаторов - <Тип.Массив> - Массив идентификаторов редактируемых строк
// id_user               - <Тип.Строка> - GUID пользователя
// УдалитьСтроку         - <Тип.Булево> - Признак удаления строки
Процедура ЗаписьInsert(id_TT, СтруктураДанных, ADOСоединение, МассивИдентификаторов, id_user, УдалитьСтроку = Ложь) Экспорт
	
	// С 04.09.2017 Процедура ЗаписьUpdate таблицы остатков не используется!
	// Алгоритмы модифицыированы на добавление новых строк (Фактически "Таблица Остатков" теперть "Таблица Оборотов").
	// ВАЖНО! Таблица никогда не закроется "в ноль", поскольку на предприятии отсутствую "партии", и товар списывается без учета даты производства.
	// Примечание: При "проведении" операции с кодом 400 обязательно заполнить поля id_doc и date
	
	ТекстЗапросаОстатки =
	"INSERT INTO [SMS_REPL].[dbo].[TD_ost_detail]
	|(id_tov, id_kontr, date_proizv, balance_ost, ShopNo, ID_user, comment, id_doc, date)
	|VALUES ("+ ВнешниеДанные.ФорматПоля(Число(СтруктураДанных.id_tov)) + " 
	|      ," + ВнешниеДанные.ФорматПоля(СтруктураДанных.ПроизводительИД)+ "
	|      ," + ?(ЗначениеЗаполнено(СтруктураДанных.ДатаПроизводства), ВнешниеДанные.ФорматПоля(СтруктураДанных.ДатаПроизводства), "NULL") + "
	|      ," + ?(СтруктураДанных.Удалена,"-","") + ВнешниеДанные.ФорматПоля(СтруктураДанных.Остаток)+ "
	|      ," + ВнешниеДанные.ФорматПоля(id_TT) + "
	|      ," + ВнешниеДанные.ФорматПоля(Строка(id_user)) + " 
	|      ," + ВнешниеДанные.ФорматПоля(СокрЛП(СтруктураДанных.Комментарий)) + " 
	|      ," + ?(СтруктураДанных.Свойство("id_doc"), СтруктураДанных.id_doc, "NULL") + "
	|      ," + ?(СтруктураДанных.Свойство("date"), ВнешниеДанные.ФорматПоля(СтруктураДанных.date), "NULL") + ")";
	
	//mika Дата: 2017.10.13 для возможности удаления строк, в которые пользователи уже повносили "минусовые остатки". 
	//Минимальное допустимое значение ввода "Остатка" установлено 0,001.
	ТекстЗапросаОстатки = СтрЗаменить(ТекстЗапросаОстатки, "--","");
	//mika

	Попытка
		rs = ADOСоединение.Execute(ТекстЗапросаОстатки);
		Если Не СтруктураДанных.Удалена Тогда 
			МассивИдентификаторов.Добавить(СтруктураДанных.IDСтроки);
		КонецЕсли;
	Исключение
		Сообщить(НСтр("ru = 'Ошибка записи! Стр.'", "ru") + " " + СтруктураДанных.TD_ost_detail_ID + " " + ОписаниеОшибки());
	КонецПопытки;

КонецПроцедуры

//Процедура обновляет записи по отредактированным пользователями строкам формы "Редактирования просрочки"
//
Процедура ЗаписьUpdate(id_TT, Выборка, ADOСоединение, МассивИдентификаторов, id_user, УдалитьСтроку = Ложь) Экспорт
	
	Если УдалитьСтроку Тогда
		
		ТекстЗапросаОстатки =
		"DELETE FROM [SMS_Repl].[dbo].[TD_ost_detail] 
		|WHERE TD_ost_detail_ID = " +  ВнешниеДанные.ФорматПоля(Число(Выборка.TD_ost_detail_ID)) + "";
		
	ИначеЕсли Выборка.НоваяСтрока Тогда
		
		ТекстЗапросаОстатки =
		"INSERT INTO [SMS_REPL].[dbo].[TD_ost_detail]
		|(id_tov, id_kontr, date_proizv, balance_ost, ShopNo, ID_user, comment)
		|VALUES ("+ ВнешниеДанные.ФорматПоля(Число(Выборка.id_tov)) + " 
		|      ," + ВнешниеДанные.ФорматПоля(Выборка.ПроизводительИД)+ "
		|      ," + ?(ЗначениеЗаполнено(Выборка.ДатаПроизводства), ВнешниеДанные.ФорматПоля(Выборка.ДатаПроизводства), "NULL") + "
		|      ," + ВнешниеДанные.ФорматПоля(Выборка.Остаток)+ "
		|      ," + ВнешниеДанные.ФорматПоля(id_TT) + "
		|      ," + ВнешниеДанные.ФорматПоля(Строка(id_user)) + " 
		|      ," + ВнешниеДанные.ФорматПоля(СокрЛП(Выборка.Комментарий)) +")";
		
	Иначе
		
		ТекстЗапросаОстатки = 
		"UPDATE [SMS_REPL].[dbo].[TD_ost_detail]  
		|SET [id_tov] = "	   + ВнешниеДанные.ФорматПоля(Число(Выборка.id_tov)) + "
		|   ,[id_kontr] = "    + ВнешниеДанные.ФорматПоля(Выборка.ПроизводительИД)+  "
		|   ,[date_proizv] = " + ?(ЗначениеЗаполнено(Выборка.ДатаПроизводства), ВнешниеДанные.ФорматПоля(Выборка.ДатаПроизводства), "NULL") + "
		|   ,[balance_ost] = " + ВнешниеДанные.ФорматПоля(Выборка.Остаток)+ "
		|   ,[id_user] = " 	   + ВнешниеДанные.ФорматПоля(Строка(id_user)) + "
		|   ,[ShopNo] = " 	   + ВнешниеДанные.ФорматПоля(Выборка.id_TT) + "
		|   ,[comment] = " 	   + ВнешниеДанные.ФорматПоля(СокрЛП(Выборка.Комментарий)) + "
		|WHERE TD_ost_detail_ID = " +  ВнешниеДанные.ФорматПоля(Число(Выборка.TD_ost_detail_ID)) + "";
		
	КонецЕсли;
	
	Попытка
		rs = ADOСоединение.Execute(ТекстЗапросаОстатки);
		Если Не УдалитьСтроку Тогда 
			МассивИдентификаторов.Добавить(Выборка.IDСтроки);
		КонецЕсли;
	Исключение
		Сообщить(НСтр("ru = 'Ошибка записи! Стр.'", "ru") + " " + Выборка.TD_ost_detail_ID + " " + ОписаниеОшибки());
	КонецПопытки;

КонецПроцедуры

#КонецОбласти

//+++АК SHEP 2018.07.06 ИП-00019140: взял из формы "ФормаТовародвижения"
Функция ПолучитьИПодключитьВнешнююОбработкуТоварныеОперации() Экспорт
	
	УстановитьПривилегированныйРежим(Истина);
	
	Ссылка = Справочники.ВнешниеОбработки.НайтиПоНаименованию("ТоварныеОперации_Магазины");
	АдресВоВременномХранилище = ПоместитьВоВременноеХранилище(Ссылка.ХранилищеВнешнейОбработки.Получить());
	ИмяОбработки = ВнешниеОбработки.Подключить(АдресВоВременномХранилище, , Ложь);
	ВнешниеОбработки.Создать(ИмяОбработки);
	
	Возврат ИмяОбработки;
	
КонецФункции
