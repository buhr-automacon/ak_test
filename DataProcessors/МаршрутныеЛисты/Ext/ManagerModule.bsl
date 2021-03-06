﻿//+++АК LAGP 2018.05.09 ИП-00018465 Для подстановки в РТУ Тилси-Перекресток
Функция ПолучитьДоговорКонтрагентаСтороннейРозницы(КонтрагентВладелец, СтруктурнаяЕдиница, Организация, ДатаСреза) Экспорт
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ РАЗРЕШЕННЫЕ
		|	ПривязкаСтороннихМагазиновКДоговорамСрезПоследних.ДоговорКонтрагента
		|ИЗ
		|	РегистрСведений.ПривязкаСтороннихМагазиновКДоговорам.СрезПоследних(
		|			&ДатаСреза,
		|			ДоговорКонтрагента.Владелец = &КонтрагентВладелец
		|				И ДоговорКонтрагента.Организация = &Организация
		|				И ДоговорКонтрагента.СторонняяРозницаРасчетыПоРТУ = ИСТИНА
		|				И СтруктурнаяЕдиница = &СтруктурнаяЕдиница
		|				И Активный = ИСТИНА) КАК ПривязкаСтороннихМагазиновКДоговорамСрезПоследних";
	
	Запрос.УстановитьПараметр("ДатаСреза", 			ДатаСреза);
	Запрос.УстановитьПараметр("Организация", 		Организация);
	Запрос.УстановитьПараметр("КонтрагентВладелец", КонтрагентВладелец);
	Запрос.УстановитьПараметр("СтруктурнаяЕдиница", СтруктурнаяЕдиница);
		
	РезультатЗапроса = Запрос.Выполнить();
	
	ВыборкаДетальныеЗаписи = РезультатЗапроса.Выбрать();
	
	Если ВыборкаДетальныеЗаписи.Следующий() Тогда
		Возврат ВыборкаДетальныеЗаписи.ДоговорКонтрагента;
	Иначе	
		Возврат Справочники.ДоговорыКонтрагентов.ПустаяСсылка();
	КонецЕсли;	
	
КонецФункции	

//+++shae 2018.10.15 ИП-00020073 
Функция ПечатьРаспределениеНаВендинги(МассивОрдеров) Экспорт   
		
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("МассивОрдеров", 	МассивОрдеров);	
	Запрос.Текст =
	"ВЫБРАТЬ РАЗРЕШЕННЫЕ РАЗЛИЧНЫЕ
	|	РасходныйОрдерСклад.Организация КАК Организация,
	|	ВЫРАЗИТЬ(ЗначенияСвойствОбъектов.Объект КАК Справочник.СтруктурныеЕдиницы).id_TT КАК id_TT,
	|	НАЧАЛОПЕРИОДА(РасходныйОрдерСклад.Дата, ДЕНЬ) КАК Период
	|ИЗ
	|	Документ.РасходныйОрдерСклад КАК РасходныйОрдерСклад
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ РегистрСведений.ЗначенияСвойствОбъектов КАК ЗначенияСвойствОбъектов
	|		ПО РасходныйОрдерСклад.Получатель = ЗначенияСвойствОбъектов.Значение
	|			И (ЗначенияСвойствОбъектов.Свойство = ЗНАЧЕНИЕ(ПланВидовХарактеристик.СвойстваОбъектов.СкладМагазинаСтороннейРозницы))
	|ГДЕ
	|	РасходныйОрдерСклад.Ссылка В(&МассивОрдеров)
	|ИТОГИ ПО
	|	Период,
	|	Организация";
	
	Результат = Запрос.Выполнить();
	
	ТабДокумент	= Новый ТабличныйДокумент;
	ТабДокумент.ИмяПараметровПечати = "ПараметрыПечати_МаршрутныеЛисты_РаспределениеНаВендинги";	
	
	Если НЕ Результат.Пустой() Тогда 
		Макет = Обработки.МаршрутныеЛисты.ПолучитьМакет("РаспределениеНаВендинги");
		
		ОбластьМакетаШапкаТочка     = Макет.ПолучитьОбласть("Шапка");
		ОбластьМакетаЗаголовок 		= Макет.ПолучитьОбласть("Заголовок");
		ОбластьМакетаСтрока         = Макет.ПолучитьОбласть("Строка");
		ОбластьМакетаИтог 			= Макет.ПолучитьОбласть("Итог");
		
		ADOСоединение = Новый COMОбъект("ADODB.Connection");
		ADOСоединение.ConnectionTimeOut	= 0;
		ADOСоединение.CommandTimeOut	= 0;
		ADOСоединение.ConnectionString	= ОбменСAccess.ПолучитьСтрокуСоединения("M2");
		ADOСоединение.Open();
		
		ВыборкаОрганизация = Результат.Выбрать(ОбходРезультатаЗапроса.ПоГруппировкам);
		Пока ВыборкаОрганизация.Следующий() Цикл 
			ВыборкаДата = ВыборкаОрганизация.Выбрать(ОбходРезультатаЗапроса.ПоГруппировкам);
			Пока ВыборкаДата.Следующий() Цикл 
				мТекстId_TT	= "";
				ВыборкаТТ = ВыборкаДата.Выбрать();
				Пока ВыборкаТТ.Следующий() Цикл 
					мТекстId_TT = мТекстId_TT + "," + Формат(ВыборкаТТ.id_TT, "ЧГ=0");
				КонецЦикла;
				
				мТекстId_TT = Сред(мТекстId_TT, 2);
				
				ТекстЗапроса = "EXEC [M2].[dbo].[FOR1C_GetArchive_raspr]
				|    @id_tt = '" + мТекстId_TT + "',
				|    @DateRaspr = " + ВнешниеДанные.ФорматПоля(ВыборкаДата.Период);
				
				ОбластьМакетаЗаголовок.Параметры.Организация 	= ВыборкаДата.Организация;
				ОбластьМакетаЗаголовок.Параметры.Дата 			= ВыборкаДата.Период;			
				ТабДокумент.Вывести(ОбластьМакетаЗаголовок);
				
				rs = ADOСоединение.Execute(ТекстЗапроса);
				ТТ = Неопределено;
				НомерСтроки = 0;
				КоличествоВсего = 0;
				Если НЕ rs = Неопределено Тогда 
					Если rs.Fields.Count > 0 Тогда
						Пока НЕ rs.EOF Цикл
							ТТ_Текущая = rs.Fields("Name_tt").Value;
							Если НЕ ТТ = ТТ_Текущая Тогда 
								Если НЕ ТТ = Неопределено Тогда 
									ОбластьМакетаИтог.Параметры.Количество 	= КоличествоВсего;			
									ТабДокумент.Вывести(ОбластьМакетаИтог);		
								КонецЕсли;	
								ОбластьМакетаШапкаТочка.Параметры.ТорговаяТочка = ТТ_Текущая;
								ТабДокумент.Вывести(ОбластьМакетаШапкаТочка);	
								ТТ = ТТ_Текущая;
								НомерСтроки = 0;
								КоличествоВсего = 0;
							КонецЕсли;	
							НомерСтроки 	= НомерСтроки + 1;		
							Количество 		= rs.Fields("q_raspr").Value;
							КоличествоВсего = КоличествоВсего + Количество; 
							ОбластьМакетаСтрока.Параметры.Номенклатура   	= rs.Fields("Name_tov").Value;			
							ОбластьМакетаСтрока.Параметры.Характеристика 	= rs.Fields("Name_harac").Value;
							ОбластьМакетаСтрока.Параметры.Количество 		= Количество;
							ОбластьМакетаСтрока.Параметры.Номер 			= НомерСтроки;			
							ТабДокумент.Вывести(ОбластьМакетаСтрока);								
							rs.MoveNext();
						КонецЦикла;
						Если НЕ ТТ = Неопределено Тогда 
							ОбластьМакетаИтог.Параметры.Количество 	= КоличествоВсего;			
							ТабДокумент.Вывести(ОбластьМакетаИтог);		
						КонецЕсли;	
					КонецЕсли;	
					rs = rs.NextRecordSet();
				КонецЕсли;			
			КонецЦикла;
		КонецЦикла;		
		ADOСоединение.Close();
	КонецЕсли;		

	Возврат ТабДокумент;
	
КонецФункции

//+++АК Vert 2018.12.20 без задания
// Процедура устанавливает СтруктураНастроек.Статус для массива документов РО СтруктураНастроек.МассивДокументов для реквизита статус 
Процедура УстановитьСтатусСервер(СтруктураНастроек, АдресРезультатаВоВременномХранилище) Экспорт
	
	МассивДокументов = СтруктураНастроек.МассивДокументов;
	Статус			 = СтруктураНастроек.Статус;	
	
	УстановитьПривилегированныйРежим(Истина);
	
	Если МассивДокументов.Количество() > 0 И ТипЗнч(МассивДокументов[0]) <> Тип("ДокументСсылка.РасходныйОрдерСклад") Тогда 
		ВызватьИсключение "В процедуру установки статуса переданы не расходные ордера";		
	КонецЕсли;
	
	ДокументыКСменеСтатуса = ДокументыКСменеСтатуса(МассивДокументов, Статус);
	ДокументыНеПроведенные = Новый Массив;
	
	Для Каждого ЭлементДокумент Из ДокументыКСменеСтатуса Цикл
		
		ДокОбъект = ЭлементДокумент.ПолучитьОбъект();		
		ДокОбъект.Статус = Статус;		
		Попытка
			ДокОбъект.Записать(РежимЗаписиДокумента.Проведение);
		Исключение
			ДокументыНеПроведенные.Добавить(ЭлементДокумент);
		КонецПопытки;
		
		//ДокументыНеПроведенные.Добавить(ЭлементДокумент); // для теста
		
	КонецЦикла;
	
	ПоместитьВоВременноеХранилище(ДокументыНеПроведенные, АдресРезультатаВоВременномХранилище);
	
КонецПроцедуры	

Функция ДокументыКСменеСтатуса(МассивДокументов, Статус)
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ
		|	РасходныйОрдерСклад.Ссылка
		|ИЗ
		|	Документ.РасходныйОрдерСклад КАК РасходныйОрдерСклад
		|ГДЕ
		|	РасходныйОрдерСклад.Ссылка В(&МассивДокументов)
		|	И РасходныйОрдерСклад.Статус = &Статус";
	
	Запрос.УстановитьПараметр("МассивДокументов", МассивДокументов);
	// Отбратть документы с другим статусом, чем устанавливается. Перепроводить документы с таким же статусом смысла нет.
	Если Статус = Перечисления.СтатусыРасходныхОрдеров.НеОбработан Тогда 
		СтатусОтбор = Перечисления.СтатусыРасходныхОрдеров.ВСборке;
	Иначе
		СтатусОтбор = Перечисления.СтатусыРасходныхОрдеров.НеОбработан;
	КонецЕсли;
	Запрос.УстановитьПараметр("Статус", СтатусОтбор);
	
	РезультатЗапроса = Запрос.Выполнить();
	Если РезультатЗапроса.Пустой() Тогда 
		Возврат Новый Массив;
	Иначе 
	
		Возврат РезультатЗапроса.Выгрузить().ВыгрузитьКолонку("Ссылка");
		
	КонецЕсли;

КонецФункции