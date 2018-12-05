﻿
//&НаСервереБезКонтекста
//Функция ПолучитьОС(мНаименование, мИнвНомер)
//	
//	Запрос = Новый Запрос;
//	Запрос.УстановитьПараметр("Наименование", СокрЛП(мНаименование));
//	Запрос.УстановитьПараметр("ИнвНомер"	, СокрЛП(мИнвНомер));
//	
//	Запрос.Текст =
//	"ВЫБРАТЬ РАЗРЕШЕННЫЕ ПЕРВЫЕ 1
//	|	ОсновныеСредства.Ссылка
//	|ИЗ
//	|	Справочник.ОсновныеСредства КАК ОсновныеСредства
//	|ГДЕ
//	|	ОсновныеСредства.Наименование = &Наименование
//	|	И ОсновныеСредства.ИнвентарныйНомер = &ИнвНомер";
//	
//	Выборка = Запрос.Выполнить().Выбрать();
//	Если Выборка.Следующий() Тогда
//		Возврат Выборка.Ссылка;
//	КонецЕсли;
//	
//	Возврат Неопределено;
//	
//КонецФункции

//&НаСервереБезКонтекста
//Функция ПолучитьРезультатЗапросаПоРегистраторам(мНачалоПериода, мКонецПериода, ТоргваяТочкаСсылка, СкладСсылка, ОсновноеСредствоСсылка)
//	
//	Запрос = Новый Запрос;
//	Запрос.УстановитьПараметр("ДатаНачала"		, мНачалоПериода);
//	Запрос.УстановитьПараметр("ДатаОкончания"	, мКонецПериода);
//	
//	Если ЗначениеЗаполнено(СкладСсылка) Тогда 
//		Запрос.УстановитьПараметр("МестоХранения"	, СкладСсылка);
//	Иначе 
//		Запрос.УстановитьПараметр("МестоХранения"	, ТоргваяТочкаСсылка);
//	КонецЕсли;
//	
//	Запрос.УстановитьПараметр("ОсновноеСредство"	, ОсновноеСредствоСсылка);
//	
//	Запрос.Текст =
//	"ВЫБРАТЬ
//	|	СостояниеОССрезПоследних.ОсновноеСредство,
//	|	СостояниеОССрезПоследних.Местоположение,
//	|	СостояниеОССрезПоследних.Регистратор
//	|ПОМЕСТИТЬ втСрезНачало
//	|ИЗ
//	|	РегистрСведений.СостояниеОС.СрезПоследних(&ДатаНачала, ОсновноеСредство = &ОсновноеСредство) КАК СостояниеОССрезПоследних
//	|ГДЕ
//	|	СостояниеОССрезПоследних.Списано <> ИСТИНА
//	|	И СостояниеОССрезПоследних.Местоположение = &МестоХранения
//	|;
//	|
//	|////////////////////////////////////////////////////////////////////////////////
//	|ВЫБРАТЬ
//	|	СостояниеОССрезПоследних.ОсновноеСредство,
//	|	СостояниеОССрезПоследних.Местоположение,
//	|	СостояниеОССрезПоследних.Регистратор
//	|ПОМЕСТИТЬ втСрезОкончание
//	|ИЗ
//	|	РегистрСведений.СостояниеОС.СрезПоследних(&ДатаОкончания, ОсновноеСредство = &ОсновноеСредство) КАК СостояниеОССрезПоследних
//	|ГДЕ
//	|	СостояниеОССрезПоследних.Списано <> ИСТИНА
//	|	И СостояниеОССрезПоследних.Местоположение = &МестоХранения
//	|;
//	|
//	|////////////////////////////////////////////////////////////////////////////////
//	|ВЫБРАТЬ
//	|	втСрезНачало.ОсновноеСредство,
//	|	втСрезНачало.Местоположение,
//	|	1 КАК НачальныйОстаток,
//	|	0 КАК КонечныйОстаток,
//	|	втСрезНачало.Регистратор
//	|ПОМЕСТИТЬ втОстатки
//	|ИЗ
//	|	втСрезНачало КАК втСрезНачало
//	|
//	|ОБЪЕДИНИТЬ ВСЕ
//	|
//	|ВЫБРАТЬ
//	|	втСрезОкончание.ОсновноеСредство,
//	|	втСрезОкончание.Местоположение,
//	|	0,
//	|	1,
//	|	втСрезОкончание.Регистратор
//	|ИЗ
//	|	втСрезОкончание КАК втСрезОкончание
//	|;
//	|
//	|////////////////////////////////////////////////////////////////////////////////
//	|ВЫБРАТЬ
//	|	втОстатки.ОсновноеСредство,
//	|	втОстатки.Местоположение,
//	|	СУММА(ЕСТЬNULL(втОстатки.НачальныйОстаток, 0)) КАК НачальныйОстаток,
//	|	СУММА(ЕСТЬNULL(втОстатки.КонечныйОстаток, 0)) КАК КонечныйОстаток,
//	|	втОстатки.Регистратор
//	|ПОМЕСТИТЬ втГруппировка
//	|ИЗ
//	|	втОстатки КАК втОстатки
//	|
//	|СГРУППИРОВАТЬ ПО
//	|	втОстатки.Местоположение,
//	|	втОстатки.ОсновноеСредство,
//	|	втОстатки.Регистратор
//	|;
//	|
//	|////////////////////////////////////////////////////////////////////////////////
//	|ВЫБРАТЬ
//	|	втГруппировка.ОсновноеСредство КАК ОС,
//	|	втГруппировка.Местоположение КАК МестоХранения,
//	|	втГруппировка.НачальныйОстаток КАК КоличествоНачальныйОстаток,
//	|	втГруппировка.КонечныйОстаток КАК КоличествоКонечныйОстаток,
//	|	ВЫБОР
//	|		КОГДА втГруппировка.КонечныйОстаток > 0
//	|				И втГруппировка.НачальныйОстаток = 0
//	|			ТОГДА 1
//	|		ИНАЧЕ 0
//	|	КОНЕЦ КАК КоличествоОборотДт,
//	|	ВЫБОР
//	|		КОГДА втГруппировка.КонечныйОстаток = 0
//	|				И втГруппировка.НачальныйОстаток > 0
//	|			ТОГДА 1
//	|		ИНАЧЕ 0
//	|	КОНЕЦ КАК КоличествоОборотКт,
//	|	втГруппировка.ОсновноеСредство.ИнвентарныйНомер,
//	|	втГруппировка.ОсновноеСредство.ЗаводскойНомер,
//	|	ИСТИНА КАК НовыйУчет,
//	|	втГруппировка.Регистратор
//	|ПОМЕСТИТЬ втОстаткиИОбороты
//	|ИЗ
//	|	втГруппировка КАК втГруппировка
//	|;
//	|
//	|////////////////////////////////////////////////////////////////////////////////
//	|ВЫБРАТЬ РАЗРЕШЕННЫЕ
//	|	ФинансовыйОстаткиИОбороты.КоличествоНачальныйОстаток,
//	|	ФинансовыйОстаткиИОбороты.КоличествоОборотДт КАК Приход,
//	|	ФинансовыйОстаткиИОбороты.КоличествоОборотКт КАК Расход,
//	|	ФинансовыйОстаткиИОбороты.КоличествоОборот КАК Оборот,
//	|	ФинансовыйОстаткиИОбороты.КоличествоКонечныйОстаток,
//	|	ФинансовыйОстаткиИОбороты.Регистратор КАК Регистратор,
//	|	ФинансовыйОстаткиИОбороты.Период КАК ДатаРегистратора
//	|ИЗ
//	|	РегистрБухгалтерии.Финансовый.ОстаткиИОбороты(&ДатаНачала, &ДатаОкончания, Регистратор, , Счет В ИЕРАРХИИ (ЗНАЧЕНИЕ(ПланСчетов.Финансовый.ОсновныеСредства)), , Субконто3 = &ОсновноеСредство) КАК ФинансовыйОстаткиИОбороты
//	|ГДЕ
//	|	НЕ(ФинансовыйОстаткиИОбороты.КоличествоОборотДт = 0
//	|				И ФинансовыйОстаткиИОбороты.КоличествоОборотКт = 0)
//	|
//	|ОБЪЕДИНИТЬ ВСЕ
//	|
//	|ВЫБРАТЬ
//	|	втОстаткиИОбороты.КоличествоНачальныйОстаток,
//	|	втОстаткиИОбороты.КоличествоОборотДт,
//	|	втОстаткиИОбороты.КоличествоОборотКт,
//	|	втОстаткиИОбороты.КоличествоОборотДт - втОстаткиИОбороты.КоличествоОборотКт,
//	|	втОстаткиИОбороты.КоличествоКонечныйОстаток,
//	|	втОстаткиИОбороты.Регистратор,
//	|	втОстаткиИОбороты.Регистратор.Дата
//	|ИЗ
//	|	втОстаткиИОбороты КАК втОстаткиИОбороты
//	|ГДЕ
//	|	НЕ(втОстаткиИОбороты.КоличествоОборотДт = 0
//	|				И втОстаткиИОбороты.КоличествоОборотКт = 0)";
//	
//	Возврат Запрос.Выполнить();
//	
//КонецФункции


//&НаСервере
//Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
//	
//	ОтчетОбъект = РеквизитФормыВЗначение("Отчет");
//	ЭтаФорма.АдресХранилищаСКД = ПоместитьВоВременноеХранилище(ОтчетОбъект.СхемаКомпоновкиДанных, Новый УникальныйИдентификатор);
//	
//КонецПроцедуры

//&НаКлиенте
//Процедура ПриОткрытии(Отказ)
//	
//	//Если ЗначениеЗаполнено(СтруктурноеПодразделение) Тогда
//	//			
//	//	Отчет.КомпоновщикНастроек.ПользовательскиеНастройки.Элементы[3].ПравоеЗначение = СтруктурноеПодразделение;
//	//	Отчет.КомпоновщикНастроек.ПользовательскиеНастройки.Элементы[3].Использование = Истина;
//	//	
//	//	ПараметрПериода = Отчет.КомпоновщикНастроек.ПользовательскиеНастройки.Элементы.Найти(Отчет.КомпоновщикНастроек.Настройки.ПараметрыДанных.НайтиЗначениеПараметра(Новый ПараметрКомпоновкиДанных("Период")).ИдентификаторПользовательскойНастройки);
//	//	ПараметрПериода.Значение.ДатаНачала 	= НачалоМесяца(ТекущаяДата());
//	//	ПараметрПериода.Значение.ДатаОкончания 	= КонецМесяца(ТекущаяДата());
//	//	ПараметрПериода.Использование = Истина;
//	//	
//	//КонецЕсли;	
//	
//КонецПроцедуры


// &НаСервере
//Функция ПолучитьТабличныйДокументРасшифровкаПоРегистраторам(Расшифровка, ОсновноеСредствоСсылка)
//	
//	Данные = ПолучитьИзВременногоХранилища(ДанныеРасшифровки);
//	
//	//
//	мПараметрыДанных = Данные.Настройки.ПараметрыДанных;
//	мНачалоПериода 	= мПараметрыДанных.НайтиЗначениеПараметра(Новый ПараметрКомпоновкиДанных("ДатаНачала")).Значение.Дата;
//	мКонецПериода 	= мПараметрыДанных.НайтиЗначениеПараметра(Новый ПараметрКомпоновкиДанных("ДатаОкончания")).Значение.Дата;
//	
//	
//	ТекРодители = Данные.Элементы[Расшифровка].ПолучитьРодителей();
//	//СкладСсылка = Данные.Элементы[ТекРодители[0].ПолучитьРодителей()[0].Идентификатор].ПолучитьПоля()[0].Значение;
//	СкладСсылка = Данные.Элементы[ТекРодители[0].ПолучитьРодителей()[0].Идентификатор].ПолучитьРодителей()[0].ПолучитьПоля()[0].Значение;
//	
//	ТекРодители = Данные.Элементы[ТекРодители[0].ПолучитьРодителей()[0].Идентификатор].ПолучитьРодителей();
//	//ТорговаяТочкаСсылка = Данные.Элементы[ТекРодители[0].ПолучитьРодителей()[0].Идентификатор].ПолучитьПоля()[0].Значение;
//	ТорговаяТочкаСсылка = Данные.Элементы[ТекРодители[0].ПолучитьРодителей()[0].Идентификатор].ПолучитьРодителей()[0].ПолучитьПоля()[0].Значение;
//	
// 	//
//	ТабДокумент = Новый ТабличныйДокумент;
//	
//	Макет = Отчеты.ВедомостьПоОборудованию.ПолучитьМакет("РасшифровкаПоРегистраторам");
//	
//	// шапка
//	ОбластьМакета = Макет.ПолучитьОбласть("Шапка");
//	ОбластьМакета.Параметры.ТекстПериода	= "Период:  " + Формат(мНачалоПериода, "ДФ=dd.MM.yyyy ЧЧ:мм:сс") + "  -  " + Формат(мКонецПериода, "ДФ=dd.MM.yyyy ЧЧ:мм:сс");
//	МестоХранения = "Торговая точка: " + СокрЛП(ТорговаяТочкаСсылка.Наименование);
//	Если ЗначениеЗаполнено(СкладСсылка) тогда
//		МестоХранения =  МестоХранения + " склад: " + СокрЛП(СкладСсылка.Наименование);
//	КонецЕсли;	
//	ОбластьМакета.Параметры.МестоХранения 	= МестоХранения;
//	ОбластьМакета.Параметры.ОС 				= "[" + СокрЛП(ОсновноеСредствоСсылка.ИнвентарныйНомер) + "] " + СокрЛП(ОсновноеСредствоСсылка.Наименование);
//	ТабДокумент.Вывести(ОбластьМакета);
//	
//	
//	// регистраторы
//	РезультатЗапроса = ПолучитьРезультатЗапросаПоРегистраторам(мНачалоПериода, мКонецПериода, ТорговаяТочкаСсылка, СкладСсылка, ОсновноеСредствоСсылка);
//	
//	ОбластьМакета = Макет.ПолучитьОбласть("Строка");
//	Выборка = РезультатЗапроса.Выбрать();
//	Пока Выборка.Следующий() Цикл
//		ЗаполнитьЗначенияСвойств(ОбластьМакета.Параметры, Выборка);
//		ТабДокумент.Вывести(ОбластьМакета);
//	КонецЦикла;
//	
//	Возврат ТабДокумент;
//	
//КонецФункции

//&НаКлиенте
//Процедура РезультатОбработкаРасшифровки(Элемент, Расшифровка, СтандартнаяОбработка)
//	
//	СтандартнаяОбработка = Ложь;
//	
//	//
//	ТекОбласть = ЭтаФорма.Результат.ТекущаяОбласть;
//	
//	ТекОСНаименование 	= ЭтаФорма.Результат.Область(ТекОбласть.Верх, 1, ТекОбласть.Верх, 1).Текст;
//	ТекОСИнвНомер 		= ЭтаФорма.Результат.Область(ТекОбласть.Верх, 2, ТекОбласть.Верх, 2).Текст;
//	ТекОС = ПолучитьОС(ТекОСНаименование, ТекОСИнвНомер);
//	Если ТекОС = Неопределено Тогда
//		Возврат;
//	КонецЕсли;
//	
//	//
//	ТабДок = ПолучитьТабличныйДокументРасшифровкаПоРегистраторам(Расшифровка, ТекОС);
//	
//	ТабДок.ТолькоПросмотр = Истина;
//	ТабДок.Показать("Ведомость по оборудованию: [" + СокрЛП(ТекОСИнвНомер) + "] " + СокрЛП(ТекОСНаименование));
//	
//КонецПроцедуры
