﻿//+++АК SHEP 2018.07.05 ИП-00019140: добавлена форма

//+++АК SHEP 2018.07.05 ИП-00019140
&НаСервереБезКонтекста
Функция ПолучитьМассивОткрытыхМагазинов()
	
	МассивТТ = Новый Массив;
	
	УстановитьПривилегированныйРежим(Истина);
	
	Запрос = Новый Запрос(
		"ВЫБРАТЬ
		|	СтруктурныеЕдиницы.Ссылка,
		|	СтруктурныеЕдиницы.НомерТочки КАК НомерТочки
		|ИЗ
		|	Справочник.СтруктурныеЕдиницы КАК СтруктурныеЕдиницы
		|ГДЕ
		|	СтруктурныеЕдиницы.ТипСтруктурнойЕдиницы = ЗНАЧЕНИЕ(Перечисление.ТипыСтруктурныхЕдиниц.Розница)
		|	И СтруктурныеЕдиницы.ТипРозничнойТочки В (ЗНАЧЕНИЕ(Перечисление.ТипыРозничныхТочек.Магазин), ЗНАЧЕНИЕ(Перечисление.ТипыРозничныхТочек.Избенка))
		|	И СтруктурныеЕдиницы.Активное
		|	И НЕ СтруктурныеЕдиницы.Ссылка = &ТекущаяТТ
		|
		|УПОРЯДОЧИТЬ ПО
		|	НомерТочки");
	Запрос.УстановитьПараметр("ТекущаяТТ", ПараметрыСеанса.ТорговаяТочкаПоАйпи);
	
	РезультатЗапроса = Запрос.Выполнить();
	Если НЕ РезультатЗапроса.Пустой() Тогда
		МассивТТ = РезультатЗапроса.Выгрузить().ВыгрузитьКолонку("Ссылка");
	КонецЕсли;
	
	Возврат МассивТТ;
	
КонецФункции

//+++АК SHEP 2018.07.05 ИП-00019140
&НаСервере
Процедура ЗаполнитьДеревоМестВыкладки()
	
	ДеревоЗначений = РеквизитФормыВЗначение("ДеревоМестВыкладки");
	
	Запрос = Новый Запрос(
		"ВЫБРАТЬ
		|	СправочникМестаВыкладки.Ссылка,
		|	СправочникМестаВыкладки.Родитель КАК Родитель,
		|	СправочникМестаВыкладки.ЭтоГруппа
		|ИЗ
		|	Справочник.МестаВыкладки КАК СправочникМестаВыкладки
		|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ РегистрСведений.СоответствиеТиповРозничныхТочекИТорговыхМарок КАК СоответствиеТиповРозничныхТочекИТорговыхМарок
		|		ПО СправочникМестаВыкладки.ТорговаяМарка = СоответствиеТиповРозничныхТочекИТорговыхМарок.ТорговаяМарка
		|ГДЕ
		|	СоответствиеТиповРозничныхТочекИТорговыхМарок.ТипРозничнойТочки = &ТипРозничнойТочки
		|	И НЕ СправочникМестаВыкладки.Родитель = ЗНАЧЕНИЕ(Справочник.МестаВыкладки.ПустаяСсылка)
		|ИТОГИ ПО
		|	Родитель ИЕРАРХИЯ");
	Запрос.УстановитьПараметр("ТипРозничнойТочки", ОбщегоНазначения.ЗначениеРеквизитаОбъекта(ПараметрыСеанса.ТорговаяТочкаПоАйпи, "ТипРозничнойТочки"));
	
	РезультатЗапроса = Запрос.Выполнить();
	
	ВыборкаРодитель = РезультатЗапроса.Выбрать(ОбходРезультатаЗапроса.ПоГруппировкам);
	Пока ВыборкаРодитель.Следующий() Цикл
		
		СтрокаДереваРодитель = ДеревоЗначений.Строки.Найти(ВыборкаРодитель.Родитель, "МестоВыкладки", Истина);
		Если СтрокаДереваРодитель = Неопределено Тогда
			СтрокаДереваРодитель = ДеревоЗначений.Строки.Добавить();
			СтрокаДереваРодитель.МестоВыкладки = ВыборкаРодитель.Родитель;
			//СтрокаДереваРодитель.ЭтоГруппа = Истина;
		КонецЕсли;
		
		ВыборкаДетальныеЗаписи = ВыборкаРодитель.Выбрать();
		Пока ВыборкаДетальныеЗаписи.Следующий() Цикл
			
			СтрокаДерева = СтрокаДереваРодитель.Строки.Добавить();
			//СтрокаДерева.Родитель = СтрокаДереваРодитель;
			СтрокаДерева.МестоВыкладки = ВыборкаДетальныеЗаписи.Ссылка;
			
		КонецЦикла;
		
	КонецЦикла;
	
	ЗначениеВРеквизитФормы(ДеревоЗначений, "ДеревоМестВыкладки");
	
КонецПроцедуры

//+++АК SHEP 2018.07.05 ИП-00019140
&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Элементы.КудаПереместить.СписокВыбора.ЗагрузитьЗначения(ПолучитьМассивОткрытыхМагазинов());
	ЗаполнитьДеревоМестВыкладки();
	
КонецПроцедуры

//+++АК SHEP 2018.07.06 ИП-00019140
&НаСервереБезКонтекста
Функция ПолучитьИПодключитьВнешнююОбработкуТоварныеОперации()
	Возврат Обработки.РабочийСтолПродавца.ПолучитьИПодключитьВнешнююОбработкуТоварныеОперации();
КонецФункции

//+++АК SHEP 2018.07.05 ИП-00019140
&НаСервереБезКонтекста
Функция СоздатьПеремещениеНаСервере(КудаПереместить, МассивМестВыкладки)
	
	СтрокаМестВыкладки = "";
	СоответствиеИД = ОбщегоНазначения.ЗначениеРеквизитаОбъектов(МассивМестВыкладки, "ИД");
	НужнаЗапятая = Ложь;
	Для Каждого КлючИЗначение Из СоответствиеИД Цикл
		Если ПустаяСтрока(КлючИЗначение.Значение) Тогда Продолжить; КонецЕсли;
		СтрокаМестВыкладки = СтрокаМестВыкладки + ?(НужнаЗапятая, ",", "") + КлючИЗначение.Значение;
		НужнаЗапятая = Истина;
	КонецЦикла;
	
	ADOСоединение = ВнешниеДанные.ПолучитьADOСоединение();
	
	ТекстЗапросаSQL = "
		|USE [SMS_REPL]
		//|GO
		|
		|DECLARE @return_value int,
		|	@message varchar(1000),
		|	@id_doc uniqueidentifier
		|
		|EXEC @return_value = [dbo].[CreatePerem_all_ost_411_1C]
		|	@shopNo = " + ВнешниеДанные.ФорматПоля(ПараметрыСеанса.НомерТочкиПоАйпи) + ",
		|	@Corr_ShopNo = " + ВнешниеДанные.ФорматПоля(ОбщегоНазначения.ЗначениеРеквизитаОбъекта(КудаПереместить, "НомерТочки")) + ",
		|	@CashierID = 111,
		|	@Vikl_str = N" + ВнешниеДанные.ФорматПоля(СтрокаМестВыкладки) + ",
		|	@message = @message OUTPUT,
		|	@id_doc = @id_doc OUTPUT
		|
		|SELECT @return_value as N'@return_value',
		|	@message as N'@message',
		|	@id_doc as N'@id_doc'
		|
		//|SELECT 'Return Value' = @return_value, @message as N'@message'
		//|GO
		|";
	
	rs = ADOСоединение.Execute(ТекстЗапросаSQL);
	
	Пока НЕ rs = Неопределено Цикл
		Если rs.Fields.Count > 0 Тогда
			Прервать;
		КонецЕсли;
		rs = rs.NextRecordSet();
	КонецЦикла;
	
	УИДНовойОперации = "";
	
	Попытка
		rs.MoveFirst();
		
		Пока НЕ rs.EOF() Цикл
			//СтрокаДоб.Касса = rs.Fields("CashId").Value;
			//СтрокаДоб.Ip = rs.Fields("Ip").Value;
			УИДНовойОперации = rs.Fields("@message").Value;
			Если НЕ ЗначениеЗаполнено(УИДНовойОперации) И rs.Fields("@return_value").Value <> -1 Тогда
				УИДНовойОперации = rs.Fields("@id_doc").Value;
				УИДНовойОперации = НРег(Сред(УИДНовойОперации, 2, 36)); // т.к. возвращается {F3909518-7C01-4E7F-A17C-8F5173593592}
			КонецЕсли;
			rs.MoveNext();
		КонецЦикла;
	Исключение
	КонецПопытки;
	
	Возврат УИДНовойОперации;
	
КонецФункции

//+++АК SHEP 2018.07.05 ИП-00019140
&НаКлиенте
Функция МестаВыкладки()
	
	МестаВыкладки = Новый Массив;
	Если НЕ ПереместитьВсё Тогда
		
	КонецЕсли;
	
КонецФункции

&НаКлиенте
Процедура СоздатьПеремещение(Команда)
	
	Если НЕ ПроверитьЗаполнение() Тогда Возврат; КонецЕсли;
	
	УИДНовойОперации = СоздатьПеремещениеНаСервере(КудаПереместить, СписокМестВыкладки.ВыгрузитьЗначения());
	Если НЕ СтроковыеФункцииКлиентСервер.ЭтоУникальныйИдентификатор(УИДНовойОперации) Тогда
		ПоказатьПредупреждение(, УИДНовойОперации,, "Ошибка при создании перемещения");
		Возврат;
	КонецЕсли;
	
	ИмяОбработки = ПолучитьИПодключитьВнешнююОбработкуТоварныеОперации();
	ОткрытьФорму("ВнешняяОбработка."+ ИмяОбработки +".Форма.ФормаСписка", Новый Структура("ИмяВнешнейОбработки", ИмяОбработки),, "ТД_ЖурналТовародвижения");
	Оповестить("ЗапросНаОткрытиеТоварнойОперации", Новый Структура("ИД", ВРег(УИДНовойОперации)));
	
КонецПроцедуры

//+++АК SHEP 2018.07.05 ИП-00019140
&НаКлиенте
Процедура ДеревоВыделитьВсё(Команда)
	УстановитьПометкиПодчинённыхЭлементовДерева(Истина);
КонецПроцедуры

//+++АК SHEP 2018.07.05 ИП-00019140
&НаКлиенте
Процедура ДеревоСнятьВсё(Команда)
	УстановитьПометкиПодчинённыхЭлементовДерева(Ложь);
КонецПроцедуры

//+++АК SHEP 2018.07.05 ИП-00019140
&НаКлиенте
Процедура УстановитьПометкиПодчинённыхЭлементовДерева(Пометка, СтрокаДереваРодитель = Неопределено)
	
	Если СтрокаДереваРодитель = Неопределено Тогда
		СтрокаДереваРодитель = ДеревоМестВыкладки;
	КонецЕсли;
	
	СтрокиДерева = СтрокаДереваРодитель.ПолучитьЭлементы();
	Для Каждого СтрокаДерева Из СтрокиДерева Цикл
		СтрокаДерева.Пометка = Пометка;
		УстановитьПометкиПодчинённыхЭлементовДерева(Пометка, СтрокаДерева);
	КонецЦикла;
	
КонецПроцедуры

//+++АК SHEP 2018.07.05 ИП-00019140
&НаКлиенте
Процедура ДеревоМестВыкладкиПометкаПриИзменении(Элемент)
	
	ТекущиеДанные = Элементы.ДеревоМестВыкладки.ТекущиеДанные;
	Если ТекущиеДанные = Неопределено Тогда Возврат; КонецЕсли;
	
	УстановитьПометкиПодчинённыхЭлементовДерева(ТекущиеДанные.Пометка, ТекущиеДанные);
	//СтрокаДерева = 
КонецПроцедуры

//+++АК SHEP 2018.07.05 ИП-00019140
&НаКлиенте
Процедура ПереместитьВсёПриИзменении(Элемент)
	
	// не обязательно, закомментировал
	// устанавливаем все пометки
	//Если ПереместитьВсё = Истина Тогда
	//	УстановитьПометкиПодчинённыхЭлементовДерева(Истина);
	//КонецЕсли;
	
КонецПроцедуры

//+++АК SHEP 2018.07.06 ИП-00019140
&НаСервере
Процедура ЗаполнитьСписокМестВыкладки(МестаВыкладкиЭлементы)
	
	Для Каждого СтрокаДерева Из МестаВыкладкиЭлементы Цикл
		ЭлементыМестаВыкладки = СтрокаДерева.ПолучитьЭлементы();
		Если ЭлементыМестаВыкладки.Количество() = 0 Тогда
			// элемент, добавляем в список
			Если СтрокаДерева.Пометка Тогда
				СписокМестВыкладки.Добавить(СтрокаДерева.МестоВыкладки);
			КонецЕсли;
		Иначе
			// это группа, добавляем подчинённые
			ЗаполнитьСписокМестВыкладки(ЭлементыМестаВыкладки);
		КонецЕсли;
	КонецЦикла;
	
КонецПроцедуры

//+++АК SHEP 2018.07.06 ИП-00019140
&НаСервере
Процедура ОбработкаПроверкиЗаполненияНаСервере(Отказ, ПроверяемыеРеквизиты)
	
	СписокМестВыкладки.Очистить();
	Если НЕ ПереместитьВсё Тогда
		ЗаполнитьСписокМестВыкладки(ДеревоМестВыкладки.ПолучитьЭлементы());
		Если СписокМестВыкладки.Количество() = 0 Тогда
			Отказ = Истина;
			Сообщить("Должно быть выбрано «Переместить всё» или выбраны места выкладки!", СтатусСообщения.Важное);
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

//+++АК SHEP 2018.07.06 ИП-00019140
&НаКлиенте
Процедура ПереместитьВсёНажатие(Команда)
Перем Элемент;
	
	Элемент = Элементы.КнопкаПереместитьВсё;
	Элемент.Пометка = НЕ Элементы.КнопкаПереместитьВсё.Пометка;
	ПереместитьВсё = Элемент.Пометка;
	Элемент.Картинка = БиблиотекаКартинок[?(ПереместитьВсё, "УстановитьФлажки", "СнятьФлажки")];
	
	УстановитьПометкиПодчинённыхЭлементовДерева(ПереместитьВсё);
	Элементы.ДеревоМестВыкладки.Доступность = НЕ ПереместитьВсё;
	Элементы.ДеревоМестВыкладкиВыделитьВсё.Доступность = НЕ ПереместитьВсё;
	Элементы.ДеревоМестВыкладкиСнятьВсё.Доступность = НЕ ПереместитьВсё;
	
КонецПроцедуры
