﻿
Функция ЭтоАналитик() Экспорт
	
	УстановитьПривилегированныйРежим(Истина);
	
	ТекПользователь = ПараметрыСеанса.ТекущийПользователь;
	Если НЕ ЗначениеЗаполнено(ТекПользователь) Тогда Возврат Ложь; КонецЕсли;
	
	ТипРоли = ПланыВидовХарактеристик.ТипыРолейПользователя.НайтиПоКоду("HotLineIT");
	Если НЕ ЗначениеЗаполнено(ТипРоли) Тогда Возврат Ложь; КонецЕсли;
	
	Запрос = Новый Запрос(
		"ВЫБРАТЬ РАЗЛИЧНЫЕ
		|	РолиПользователейТипыРолей.Ссылка,
		|	РолиПользователейСоставРоли.Сотрудник
		|ИЗ
		|	Справочник.РолиПользователей.ТипыРолей КАК РолиПользователейТипыРолей
		|		ЛЕВОЕ СОЕДИНЕНИЕ Справочник.РолиПользователей.СоставРоли КАК РолиПользователейСоставРоли
		|		ПО РолиПользователейТипыРолей.Ссылка = РолиПользователейСоставРоли.Ссылка
		|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ Справочник.РолиПользователей КАК РолиПользователей
		|		ПО РолиПользователейТипыРолей.Ссылка = РолиПользователей.Ссылка
		|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ Справочник.Пользователи КАК Пользователи
		|		ПО (РолиПользователейСоставРоли.Сотрудник = Пользователи.ФизЛицо)
		|			И (НЕ Пользователи.ФизЛицо = ЗНАЧЕНИЕ(Справочник.ФизическиеЛица.ПустаяСсылка))
		|ГДЕ
		|	РолиПользователейТипыРолей.ТипРоли = &ТипРоли
		|	И Пользователи.Ссылка = &ТекПользователь
		|	И НЕ РолиПользователей.ПометкаУдаления");
	Запрос.УстановитьПараметр("ТипРоли", ТипРоли);
	Запрос.УстановитьПараметр("ТекПользователь", ТекПользователь);
	
	Возврат НЕ Запрос.Выполнить().Пустой();
	
КонецФункции

Функция ЭтоУЕК() Экспорт
	
	УстановитьПривилегированныйРежим(Истина);
	
	ТекПользователь = ПараметрыСеанса.ТекущийПользователь;
	Если НЕ ЗначениеЗаполнено(ТекПользователь) Тогда Возврат Ложь; КонецЕсли;
	
	ТипРоли = ПланыВидовХарактеристик.ТипыРолейПользователя.НайтиПоКоду("UEK");
	Если НЕ ЗначениеЗаполнено(ТипРоли) Тогда Возврат Ложь; КонецЕсли;
	
	Запрос = Новый Запрос(
		"ВЫБРАТЬ РАЗЛИЧНЫЕ
		|	РолиПользователейТипыРолей.Ссылка,
		|	РолиПользователейСоставРоли.Сотрудник
		|ИЗ
		|	Справочник.РолиПользователей.ТипыРолей КАК РолиПользователейТипыРолей
		|		ЛЕВОЕ СОЕДИНЕНИЕ Справочник.РолиПользователей.СоставРоли КАК РолиПользователейСоставРоли
		|		ПО РолиПользователейТипыРолей.Ссылка = РолиПользователейСоставРоли.Ссылка
		|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ Справочник.РолиПользователей КАК РолиПользователей
		|		ПО РолиПользователейТипыРолей.Ссылка = РолиПользователей.Ссылка
		|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ Справочник.Пользователи КАК Пользователи
		|		ПО (РолиПользователейСоставРоли.Сотрудник = Пользователи.ФизЛицо)
		|			И (НЕ Пользователи.ФизЛицо = ЗНАЧЕНИЕ(Справочник.ФизическиеЛица.ПустаяСсылка))
		|ГДЕ
		|	РолиПользователейТипыРолей.ТипРоли = &ТипРоли
		|	И Пользователи.Ссылка = &ТекПользователь
		|	И НЕ РолиПользователей.ПометкаУдаления");
	Запрос.УстановитьПараметр("ТипРоли", ТипРоли);
	Запрос.УстановитьПараметр("ТекПользователь", ТекПользователь);
	
	Возврат НЕ Запрос.Выполнить().Пустой();
	
КонецФункции

Функция ЭтоУЕК2()
	
	УстановитьПривилегированныйРежим(Истина);
	
	ТекПользователь = ПараметрыСеанса.ТекущийПользователь;
	Если НЕ ЗначениеЗаполнено(ТекПользователь) Тогда Возврат Ложь; КонецЕсли;
	
	Запрос = Новый Запрос(
		"ВЫБРАТЬ
		|	АК_ГруппыРассылки.ФизЛицо КАК ТекАдрес
		|ИЗ
		|	Справочник.Пользователи КАК Пользователи
		|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.АК_ГруппыРассылки КАК АК_ГруппыРассылки
		|		ПО Пользователи.ФизЛицо = АК_ГруппыРассылки.ФизЛицо
		|			И (НЕ Пользователи.ФизЛицо = ЗНАЧЕНИЕ(Справочник.ФизическиеЛица.ПустаяСсылка))
		|ГДЕ
		|	Пользователи.Ссылка = &ТекПользователь
		|	И АК_ГруппыРассылки.Группа = &ГруппаРассылки
		|
		|СГРУППИРОВАТЬ ПО
		|	АК_ГруппыРассылки.ФизЛицо");
	Запрос.УстановитьПараметр("ТекПользователь", ТекПользователь);
	Запрос.УстановитьПараметр("ГруппаРассылки", Справочники.АК_ГруппыРассылки.УЕК);
	
	Возврат НЕ Запрос.Выполнить().Пустой();
	
КонецФункции

Функция ЭтоТехнолог() Экспорт
	
	УстановитьПривилегированныйРежим(Истина);
	
	ТекПользователь = ПараметрыСеанса.ТекущийПользователь;
	Если НЕ ЗначениеЗаполнено(ТекПользователь) Тогда Возврат Ложь; КонецЕсли;
	
	ТекФизЛицо = ОбщегоНазначения.ПолучитьЗначениеРеквизита(ТекПользователь, "ФизЛицо");
	
	МассивТехнологов = Справочники.КартыДизайнПроектов.ПолучитьМассивВсехТехнологов();
	Возврат (МассивТехнологов.Найти(ТекФизЛицо) <> Неопределено);
	
КонецФункции

Функция ПолучитьМассивКонтрагентовПоставщика(Поставщик = Неопределено) Экспорт
	
	МассивКонтрагентов = Новый Массив;
	
	УстановитьПривилегированныйРежим(Истина);
	Если Поставщик = Неопределено Тогда Поставщик = ПараметрыСеанса.ТекущийКонтрагент; КонецЕсли;
	
	Если НЕ ЗначениеЗаполнено(Поставщик) Тогда Возврат МассивКонтрагентов; КонецЕсли;
	
	Запрос = Новый Запрос(
		"ВЫБРАТЬ
		|	Контрагенты.Ссылка,
		|	Контрагенты.ГоловнойКонтрагент
		|ИЗ
		|	Справочник.Контрагенты КАК Контрагенты
		|ГДЕ
		|	Контрагенты.Ссылка = &Поставщик
		|	И ВЫРАЗИТЬ(&Поставщик КАК Справочник.Контрагенты).ГоловнойКонтрагент = ЗНАЧЕНИЕ(Справочник.Контрагенты.ПустаяСсылка)
		|
		|ОБЪЕДИНИТЬ ВСЕ
		|
		|ВЫБРАТЬ
		|	Контрагенты.Ссылка,
		|	Контрагенты.ГоловнойКонтрагент
		|ИЗ
		|	Справочник.Контрагенты КАК Контрагенты
		|ГДЕ
		|	Контрагенты.ГоловнойКонтрагент = ВЫРАЗИТЬ(&Поставщик КАК Справочник.Контрагенты).ГоловнойКонтрагент
		|	И НЕ ВЫРАЗИТЬ(&Поставщик КАК Справочник.Контрагенты).ГоловнойКонтрагент = ЗНАЧЕНИЕ(Справочник.Контрагенты.ПустаяСсылка)");
	Запрос.УстановитьПараметр("Поставщик", Поставщик);
	
	РезультатЗапроса = Запрос.Выполнить();
	Если НЕ РезультатЗапроса.Пустой() Тогда
		МассивКонтрагентов = РезультатЗапроса.Выгрузить().ВыгрузитьКолонку("Ссылка");
	КонецЕсли;
	
	УстановитьПривилегированныйРежим(Ложь);
	
	Возврат МассивКонтрагентов;
	
КонецФункции

Функция ПолучитьСтруктуруТехнологовПоставщика(Поставщик = Неопределено) Экспорт
	
	МассивТехнологов = Новый Массив;
	МассивРолейТехнологов = Новый Массив;
	
	УстановитьПривилегированныйРежим(Истина);
	Если Поставщик = Неопределено Тогда Поставщик = ПараметрыСеанса.ТекущийКонтрагент; КонецЕсли;
	
	Если ЗначениеЗаполнено(Поставщик) Тогда
		
		Запрос = Новый Запрос(
			"ВЫБРАТЬ
			|	Контрагенты.Ссылка,
			|	Контрагенты.ГоловнойКонтрагент
			|ПОМЕСТИТЬ ПоставщикиПроизводители
			|ИЗ
			|	Справочник.Контрагенты КАК Контрагенты
			|ГДЕ
			|	Контрагенты.Ссылка = &Поставщик
			|	И ВЫРАЗИТЬ(&Поставщик КАК Справочник.Контрагенты).ГоловнойКонтрагент = ЗНАЧЕНИЕ(Справочник.Контрагенты.ПустаяСсылка)
			|
			|ОБЪЕДИНИТЬ ВСЕ
			|
			|ВЫБРАТЬ
			|	Контрагенты.Ссылка,
			|	Контрагенты.ГоловнойКонтрагент
			|ИЗ
			|	Справочник.Контрагенты КАК Контрагенты
			|ГДЕ
			|	НЕ ВЫРАЗИТЬ(&Поставщик КАК Справочник.Контрагенты).ГоловнойКонтрагент = ЗНАЧЕНИЕ(Справочник.Контрагенты.ПустаяСсылка)
			|	И Контрагенты.ГоловнойКонтрагент = ВЫРАЗИТЬ(&Поставщик КАК Справочник.Контрагенты).ГоловнойКонтрагент
			|;
			|
			|////////////////////////////////////////////////////////////////////////////////
			|ВЫБРАТЬ
			|	ВЫРАЗИТЬ(ЗначенияСвойствОбъектов.Объект КАК Справочник.ХарактеристикиНоменклатуры).Владелец КАК Номенклатура,
			|	ЗначенияСвойствОбъектов.Объект
			|ПОМЕСТИТЬ ХарактеристикиНоменклатуры
			|ИЗ
			|	РегистрСведений.ЗначенияСвойствОбъектов КАК ЗначенияСвойствОбъектов
			|ГДЕ
			|	ЗначенияСвойствОбъектов.Объект ССЫЛКА Справочник.ХарактеристикиНоменклатуры
			|	И ЗначенияСвойствОбъектов.Свойство = ЗНАЧЕНИЕ(ПланВидовХарактеристик.СвойстваОбъектов.Производитель)
			|	И ЗначенияСвойствОбъектов.Значение В
			|			(ВЫБРАТЬ
			|				ПоставщикиПроизводители.Ссылка
			|			ИЗ
			|				ПоставщикиПроизводители КАК ПоставщикиПроизводители)
			|;
			|
			|////////////////////////////////////////////////////////////////////////////////
			|ВЫБРАТЬ РАЗЛИЧНЫЕ
			|	СоответствиеОбъектРольСрезПоследних.РольПользователя,
			|	РолиПользователейСоставРоли.Сотрудник КАК Технолог
			|ИЗ
			|	РегистрСведений.СоответствиеОбъектРоль.СрезПоследних(
			|			,
			|			ТипРоли = ЗНАЧЕНИЕ(ПланВидовХарактеристик.ТипыРолейПользователя.ТехнологПоКачеству)
			|				И Объект ССЫЛКА Справочник.ХарактеристикиНоменклатуры
			|				И Объект В
			|					(ВЫБРАТЬ
			|						ХарактеристикиНоменклатуры.Объект
			|					ИЗ
			|						ХарактеристикиНоменклатуры КАК ХарактеристикиНоменклатуры)) КАК СоответствиеОбъектРольСрезПоследних
			|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ Справочник.РолиПользователей.СоставРоли КАК РолиПользователейСоставРоли
			|		ПО СоответствиеОбъектРольСрезПоследних.РольПользователя = РолиПользователейСоставРоли.Ссылка
			|ГДЕ
			|	НЕ СоответствиеОбъектРольСрезПоследних.РольПользователя = ЗНАЧЕНИЕ(Справочник.РолиПользователей.ПустаяСсылка)
			|
			|ОБЪЕДИНИТЬ
			|
			|ВЫБРАТЬ РАЗЛИЧНЫЕ
			|	СоответствиеОбъектРольСрезПоследних.РольПользователя,
			|	РолиПользователейСоставРоли.Сотрудник
			|ИЗ
			|	РегистрСведений.СоответствиеОбъектРоль.СрезПоследних(
			|			,
			|			ТипРоли = ЗНАЧЕНИЕ(ПланВидовХарактеристик.ТипыРолейПользователя.ТехнологПоКачеству)
			|				И Объект ССЫЛКА Справочник.Контрагенты
			|				И Объект В
			|					(ВЫБРАТЬ
			|						ПоставщикиПроизводители.Ссылка
			|					ИЗ
			|						ПоставщикиПроизводители КАК ПоставщикиПроизводители)) КАК СоответствиеОбъектРольСрезПоследних
			|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ Справочник.РолиПользователей.СоставРоли КАК РолиПользователейСоставРоли
			|		ПО СоответствиеОбъектРольСрезПоследних.РольПользователя = РолиПользователейСоставРоли.Ссылка
			|ГДЕ
			|	НЕ СоответствиеОбъектРольСрезПоследних.РольПользователя = ЗНАЧЕНИЕ(Справочник.РолиПользователей.ПустаяСсылка)");
		Запрос.УстановитьПараметр("Поставщик", Поставщик);
		
		РезультатЗапроса = Запрос.Выполнить();
		Если НЕ РезультатЗапроса.Пустой() Тогда
			ВыгрузкаЗапроса = РезультатЗапроса.Выгрузить();
			МассивТехнологов = ВыгрузкаЗапроса.ВыгрузитьКолонку("Технолог");
			МассивРолейТехнологов = ВыгрузкаЗапроса.ВыгрузитьКолонку("РольПользователя");
		КонецЕсли;
	КонецЕсли;
	УстановитьПривилегированныйРежим(Ложь);
	
	СтруктураВозврата = Новый Структура("МассивТехнологов,МассивРолейТехнологов", МассивТехнологов, МассивРолейТехнологов);
	Возврат СтруктураВозврата;
	
КонецФункции

// 
Процедура СоздатьТоварХарактеристикуНоменклатуры(Ссылка, Знач ТЗнМестаХранения = Неопределено) Экспорт
Перем Объект;
	
	УстановитьПривилегированныйРежим(Истина);
	НачатьТранзакцию();
	
	Если ТЗнМестаХранения = Неопределено Тогда ТЗнМестаХранения = Новый ТаблицаЗначений; КонецЕсли;
	
	//Объект = Справочники.ХарактеристикиНоменклатурыПоставщиков.СоздатьЭлемент();
	Объект = Ссылка.ПолучитьОбъект();
	
	// Номенклатура
	Если ТипЗнч(Объект.НаименованиеДляЦенника) = Тип("СправочникСсылка.Номенклатура") Тогда
		
		СпрНоменклатураСсылка = Объект.НаименованиеДляЦенника;
		СпрЕдиницыИзмеренияСсылка = ПолучитьЕдиницуИзмеренияНоменклатуры(СпрНоменклатураСсылка);
		
	Иначе // строка -- создаём новый элемент с таким наименованием
		
		СпрНоменклатураОбъект = Справочники.Номенклатура.СоздатьЭлемент();
		СпрНоменклатураСсылка = СпрНоменклатураОбъект.ПолучитьСсылкуНового();
		Если НЕ ЗначениеЗаполнено(СпрНоменклатураСсылка) Тогда
			СпрНоменклатураСсылка = Справочники.Номенклатура.ПолучитьСсылку();
			СпрНоменклатураОбъект.УстановитьСсылкуНового(СпрНоменклатураСсылка);
		КонецЕсли;
		
		// единица измерения
		СпрЕдиницыИзмеренияОбъект = Справочники.ЕдиницыИзмерения.СоздатьЭлемент();
		СпрЕдиницыИзмеренияОбъект.Владелец = СпрНоменклатураСсылка;
		СпрЕдиницыИзмеренияОбъект.Наименование = Строка(Объект.ЕдиницаИзмерения);
		СпрЕдиницыИзмеренияОбъект.ЕдиницаПоКлассификатору = Объект.ЕдиницаИзмерения;
		СпрЕдиницыИзмеренияОбъект.Коэффициент = 1;
		СпрЕдиницыИзмеренияОбъект.ОбменДанными.Загрузка = Истина;
		
		ЕдИзм = НРег(СокрЛП(Объект.ЕдиницаИзмерения));
		Если ЕдИзм = "кг" Тогда
			СпрЕдиницыИзмеренияОбъект.Вес = Объект.Вес;
		ИначеЕсли ЕдИзм = "г" Тогда
			СпрЕдиницыИзмеренияОбъект.Вес = Объект.Вес / 1000;
		ИначеЕсли ЕдИзм = "л" Тогда
			СпрЕдиницыИзмеренияОбъект.Вес = Объект.Вес;
			СпрЕдиницыИзмеренияОбъект.Объем = Объект.Вес;
		ИначеЕсли ЕдИзм = "мл" Тогда
			СпрЕдиницыИзмеренияОбъект.Вес = Объект.Вес / 1000;
			СпрЕдиницыИзмеренияОбъект.Объем = Объект.Вес;
		//Иначе
		//	СпрЕдиницыИзмеренияОбъект.Объем = Объект.Вес;
		КонецЕсли;
		
		СпрЕдиницыИзмеренияОбъект.Записать();
		СпрЕдиницыИзмеренияСсылка = СпрЕдиницыИзмеренияОбъект.Ссылка;
		
		// номенклатура
		СпрНоменклатураОбъект.Наименование = Объект.НаименованиеДляЦенника;
		СпрНоменклатураОбъект.НаименованиеПолное = СпрНоменклатураОбъект.Наименование;
		СпрНоменклатураОбъект.Родитель = Объект.ПодгруппаНоменклатуры;
		СпрНоменклатураОбъект.БазоваяЕдиницаИзмерения = Объект.ЕдиницаИзмерения;
		СпрНоменклатураОбъект.ЕдиницаХраненияОстатков = СпрЕдиницыИзмеренияСсылка;
		СпрНоменклатураОбъект.ВидНоменклатуры = Перечисления.ВидыНоменклатуры.Товар;
		СпрНоменклатураОбъект.Состав = Объект.СоставПродуктаДляЭтикетки;
		СпрНоменклатураОбъект.ТипТовара = Перечисления.ТипыТоваров.ПокупнойТовар;
		СпрНоменклатураОбъект.СтавкаНДС = Объект.СтавкаНДСПриПоступленииТовара;
		СпрНоменклатураОбъект.КатегорияАссортимента = Перечисления.КатегорииАссортимента.Новинки;
		СпрНоменклатураОбъект.ТребуетсяНаличиеСертификата = Истина;
		СпрНоменклатураОбъект.Складируемая = (Объект.ВидСкладируемости <> ПредопределенноеЗначение("Перечисление.ВидыСкладируемостиТовара.Нескладируемый"));
		ЗаполнитьЗначенияСвойств(СпрНоменклатураОбъект, Ссылка, "ПозицияРазделителяДляЦенника,ФишкаКратко,ФишкаРазвёрнуто,ВидСкладируемости,БезУпаковки,ГруппаНоменклатурыУРЗ");
		//+++АК SHEP 2018.12.10 ИП-00018753.05
		СпрНоменклатураОбъект.ТорговаяМарка = Справочники.ТорговыеМарки.ВкусВилл;
		Если ЗначениеЗаполнено(Объект.СрокГодности) И ЗначениеЗаполнено(Объект.ТипСрокаГодности) Тогда
			// Зашить в код (если срок меньше 10 календарных дней, то ДА = короткий срок годности.
			СпрНоменклатураОбъект.КороткийСрокГодности = ((Объект.СрокГодности * ОбщегоНазначения.ЗначениеРеквизитаОбъекта(Объект.ТипСрокаГодности, "КоэффициентВСутках")) < 10);
		КонецЕсли;
		//---АК SHEP 2018.12.10
		//СпрНоменклатураОбъект.ОбменДанными.Загрузка = Истина;
		СпрНоменклатураОбъект.Записать();
		//СпрНоменклатураСсылка = СпрНоменклатураОбъект.Ссылка;
		
		// аналоги номенклатуры
		ГруппаАналоговСсылка = Справочники.АналогиНоменклатуры.ПолучитьАналогДляНоменклатуры(Объект.УсловноеЗадвоение);
		Если ЗначениеЗаполнено(Объект.УсловноеЗадвоение) Тогда
			Если ЗначениеЗаполнено(ГруппаАналоговСсылка) Тогда
				// Если выбранный товар уже состоит в какой-либо группе аналогов, тогда заводимый товар добавлять в эту группу.
				СпрАналогиНоменклатурыОбъект = ГруппаАналоговСсылка.ПолучитьОбъект();
			Иначе
				//Если выбранный товар не состоит ни в одной группе аналогов, тогда необходимо создать новую группу аналогов с названием = выбранному товару.
				СпрАналогиНоменклатурыОбъект = Справочники.АналогиНоменклатуры.СоздатьЭлемент();
				СпрАналогиНоменклатурыОбъект.Наименование = Строка(Объект.УсловноеЗадвоение);
				НоваяСтрокаТЧ = СпрАналогиНоменклатурыОбъект.Товары.Добавить();
				НоваяСтрокаТЧ.Номенклатура = Объект.УсловноеЗадвоение;
			КонецЕсли;
			НоваяСтрокаТЧ = СпрАналогиНоменклатурыОбъект.Товары.Добавить();
			НоваяСтрокаТЧ.Номенклатура = СпрНоменклатураСсылка;
			СпрАналогиНоменклатурыОбъект.Записать();
		КонецЕсли;
		
		// Планограмма / МестоВыкладки
		РегСвМенеджерЗаписи = РегистрыСведений.ВыкладкаПланограммы.СоздатьМенеджерЗаписи();
		РегСвМенеджерЗаписи.Номенклатура = СпрНоменклатураСсылка;
		РегСвМенеджерЗаписи.Планограмма = Объект.Планограмма;
		РегСвМенеджерЗаписи.МестоВыкладки = Объект.МестоВыкладки;
		РегСвМенеджерЗаписи.Записать();
		
		// склады хранения
		Для Каждого СтрокаТЗн Из ТЗнМестаХранения Цикл
			РегСвМенеджерЗаписи = РегистрыСведений.ДоступностьТоваровНаСкладах.СоздатьМенеджерЗаписи();
			РегСвМенеджерЗаписи.Номенклатура = СпрНоменклатураСсылка;
			РегСвМенеджерЗаписи.СтруктурнаяЕдиница = СтрокаТЗн.СтруктурнаяЕдиница;
			РегСвМенеджерЗаписи.Склад = СтрокаТЗн.Склад;
			РегСвМенеджерЗаписи.Записать();
		КонецЦикла;
	КонецЕсли;
	
	// Характеристика номенклатуры
	СпрХарактеристикиНоменклатурыОбъект = Справочники.ХарактеристикиНоменклатуры.СоздатьЭлемент();
	СпрХарактеристикиНоменклатурыОбъект.Владелец = СпрНоменклатураСсылка;
	СпрХарактеристикиНоменклатурыОбъект.Наименование = Строка(Объект.Производитель);
	СпрХарактеристикиНоменклатурыОбъект.НаименованиеТовараУПоставщика = Объект.Наименование;
	СпрХарактеристикиНоменклатурыОбъект.СтатусАктивностиХарактеристики = Перечисления.СтатусыАктивностиХарактеристик.Новая;
	ЗаполнитьЗначенияСвойств(СпрХарактеристикиНоменклатурыОбъект, Объект,
		"ТипСрокаГодности,СрокГодности,ТемператураХраненияОт,ТемператураХраненияДо,ПредельноеКоличествоДнейСрокаГодности");
	СпрХарактеристикиНоменклатурыОбъект.Ширина = Объект.ШиринаУпаковки;
	СпрХарактеристикиНоменклатурыОбъект.Высота = Объект.ВысотаУпаковки;
	СпрХарактеристикиНоменклатурыОбъект.Глубина = Объект.ГлубинаУпаковки;
	СпрХарактеристикиНоменклатурыОбъект.Записать();
	
	СпрХарактеристикиНоменклатурыСсылка = СпрХарактеристикиНоменклатурыОбъект.Ссылка;
	
	// ВесИГабаритыУпаковки
	Если Объект.ВесИГабаритыУпаковки.Количество() Тогда
		СпрНоменклатураОбъект = СпрНоменклатураСсылка.ПолучитьОбъект();
		СпрНоменклатураОбъект.ВесИГабаритыУпаковки.Загрузить(Объект.ВесИГабаритыУпаковки.Выгрузить());
		СпрНоменклатураОбъект.ВесИГабаритыУпаковки[0].Характеристика = СпрХарактеристикиНоменклатурыСсылка;
		СпрНоменклатураОбъект.Записать();
	КонецЕсли;
	
	// свойства объектов характеристики номенклатуры
	ЭтоШтучныйТовар = (Найти(НРег(Объект.ЕдиницаИзмерения), "шт") > 0);
	СтруктураПолей = Новый Структура("Производитель,СтранаПроисхождения");
	ЗаполнитьЗначенияСвойств(СтруктураПолей, Объект);
	СтруктураПолей.Вставить("КоличествоВУпаковке", Объект.Квант);
	
	Если ЭтоШтучныйТовар Тогда
		СтруктураПолей.Вставить("УпаковкаДляЦенника", "" + Формат(Объект.Вес, "ЧГ=") + СокрЛП(Объект.ЕдиницаИзмеренияВеса));
	Иначе
		СтруктураПолей.Вставить("УпаковкаДляЦенника", "1 кг");
	КонецЕсли;
	
	Для Каждого КлючИЗначение Из СтруктураПолей Цикл
		ИмяРекъ = КлючИЗначение.Ключ;
		РегСвМенеджерЗаписи = РегистрыСведений.ЗначенияСвойствОбъектов.СоздатьМенеджерЗаписи();
		РегСвМенеджерЗаписи.Объект = СпрХарактеристикиНоменклатурыСсылка;
		РегСвМенеджерЗаписи.Свойство = ?(ИмяРекъ = "УпаковкаДляЦенника", ПланыВидовХарактеристик.СвойстваОбъектов.НайтиПоНаименованию(ИмяРекъ), ПланыВидовХарактеристик.СвойстваОбъектов[ИмяРекъ]);
		РегСвМенеджерЗаписи.Значение =  КлючИЗначение.Значение;
		РегСвМенеджерЗаписи.Записать();
	КонецЦикла;
	
	// Штрих-код	
	Если ЗначениеЗаполнено(Объект.Штрихкод) Тогда
		Если НЕ РегистрыСведений.ШтриховыеКоды.ПроверкаШтрихКода(СокрЛП(Объект.Штрихкод), СпрНоменклатураСсылка, СпрХарактеристикиНоменклатурыСсылка) Тогда Возврат; КонецЕсли;
	Иначе
		Справочники.Номенклатура.УстановитьНомерПоНумератору(СпрНоменклатураСсылка, СпрХарактеристикиНоменклатурыСсылка);
		Объект.Штрихкод = РегистрыСведений.ШтриховыеКоды.ГенерироватьНовыйШтрихКод(СпрНоменклатураСсылка);
	КонецЕсли;
	
	РегСвМенеджерЗаписи = РегистрыСведений.ШтриховыеКоды.СоздатьМенеджерЗаписи();
	РегСвМенеджерЗаписи.Номенклатура = СпрНоменклатураСсылка;
	РегСвМенеджерЗаписи.Характеристика = СпрХарактеристикиНоменклатурыСсылка;
	РегСвМенеджерЗаписи.ЕдиницаИзмерения = СпрЕдиницыИзмеренияСсылка;
	РегСвМенеджерЗаписи.ШтрихКод = Объект.Штрихкод;
	РегСвМенеджерЗаписи.Записать();
	
	// роли ответственных
	Если ЗначениеЗаполнено(Объект.РольТехнолога) Тогда
		РегСвМенеджерЗаписи = РегистрыСведений.СоответствиеОбъектРоль.СоздатьМенеджерЗаписи();
		РегСвМенеджерЗаписи.Период = ТекущаяДата();
		РегСвМенеджерЗаписи.Объект = СпрХарактеристикиНоменклатурыСсылка;
		РегСвМенеджерЗаписи.ТипРоли = ПланыВидовХарактеристик.ТипыРолейПользователя.ТехнологПоКачеству;
		РегСвМенеджерЗаписи.РольПользователя = Объект.РольТехнолога;
		РегСвМенеджерЗаписи.ТипРолиID = ПланыВидовХарактеристик.ТипыРолейПользователя.ТехнологПоКачеству.Код;
		РегСвМенеджерЗаписи.Автор = ПараметрыСеанса.ТекущийПользователь;
		РегСвМенеджерЗаписи.Записать();
	КонецЕсли;
	
	// цены поставщиков
	РегСвМенеджерЗаписи = РегистрыСведений.ЦеныПоставщиков.СоздатьМенеджерЗаписи();
	РегСвМенеджерЗаписи.Период = ТекущаяДата();
	РегСвМенеджерЗаписи.Номенклатура = СпрНоменклатураСсылка;
	РегСвМенеджерЗаписи.Характеристика = СпрХарактеристикиНоменклатурыСсылка;
	РегСвМенеджерЗаписи.Цена = Объект.ЗакупочнаяЦена;
	РегСвМенеджерЗаписи.МинимальныйЗаказ = Объект.МинимальноеКоличествоВЗаказе;
	РегСвМенеджерЗаписи.Поставщик = Объект.Поставщик;
	РегСвМенеджерЗаписи.Комментарий = "Создано из карточки товара поставщика";
	РегСвМенеджерЗаписи.Записать();
	
	// СпецификацииПоставщиков
	РегСвМенеджерЗаписи = РегистрыСведений.СпецификацииПоставщиков.СоздатьМенеджерЗаписи();
	РегСвМенеджерЗаписи.Период = ТекущаяДата();
	РегСвМенеджерЗаписи.Поставщик = Объект.Поставщик;
	РегСвМенеджерЗаписи.Номенклатура = СпрНоменклатураСсылка;
	РегСвМенеджерЗаписи.Характеристика = СпрХарактеристикиНоменклатурыСсылка;
	
	Для Каждого СтрокаТЧ Из Объект.Состав Цикл
		РегСвМенеджерЗаписи.НоменклатураСырье = СтрокаТЧ.Номенклатура;
		РегСвМенеджерЗаписи.Количество = СтрокаТЧ.Количество;
		РегСвМенеджерЗаписи.ЕдиницаИзмерения = СтрокаТЧ.ЕдиницаИзмерения;
		РегСвМенеджерЗаписи.Записать();
	КонецЦикла;
	
	// НормативныйКвантУпаковки
	Если ТЗнМестаХранения.Количество() > 0 Тогда
		МассивСкладов = Новый Массив;
		Для Каждого СтрокаТЗн Из ТЗнМестаХранения Цикл
			Если МассивСкладов.Найти(СтрокаТЗн.СтруктурнаяЕдиница) <> Неопределено Тогда Продолжить; КонецЕсли;
			РегСвМенеджерЗаписи = РегистрыСведений.НормативныйКвантУпаковки.СоздатьМенеджерЗаписи();
			РегСвМенеджерЗаписи.Период = ТекущаяДата();
			РегСвМенеджерЗаписи.Склад = СтрокаТЗн.СтруктурнаяЕдиница;
			РегСвМенеджерЗаписи.Характеристика = СпрХарактеристикиНоменклатурыСсылка;
			РегСвМенеджерЗаписи.Квант = Объект.Квант;
			РегСвМенеджерЗаписи.Записать();
			МассивСкладов.Добавить(СтрокаТЗн.СтруктурнаяЕдиница);
		КонецЦикла;
	КонецЕсли;
	
	//+++АК SHEP 2018.05.17 ИП-00017035.01
	// Ветис. Cоответствие номенклатуры
	Если Объект.ТребуетсяВетеринарноеСвидетельство И ЗначениеЗаполнено(Объект.ПродукцияВетис) Тогда
		РегСвМенеджерЗаписи = РегистрыСведений.МЙ_СоответствиеНоменклатуры.СоздатьМенеджерЗаписи();
		РегСвМенеджерЗаписи.Номенклатура = СпрНоменклатураСсылка;
		РегСвМенеджерЗаписи.Характеристика = СпрХарактеристикиНоменклатурыСсылка;
		РегСвМенеджерЗаписи.ПродукцияВетис = Объект.ПродукцияВетис;
		ЗаполнитьЗначенияСвойств(РегСвМенеджерЗаписи, Объект.ПродукцияВетис, "ТипПродукции,ВидПродукции");
		РегСвМенеджерЗаписи.Записать();
	КонецЕсли;
	//---АК SHEP 2018.05.17
	
	//+++АК SHEP 2018.05.14 ИП-00017035.01
	// График поставки товара: создаём новый или корректируем существующий
	ТЗнГрафикПоставкиТовара = Объект.ГрафикПоставкиТовара.Выгрузить();
	Если ТЗнГрафикПоставкиТовара.Количество() > 0 Тогда
		СпрГрафикиПоставкиТовараСсылка = НайтиГрафикПоставкиТовара(Объект.Производитель, ТЗнГрафикПоставкиТовара);
		Если ЗначениеЗаполнено(СпрГрафикиПоставкиТовараСсылка) Тогда
			СпрГрафикиПоставкиТовараОбъект = СпрГрафикиПоставкиТовараСсылка.ПолучитьОбъект();
		Иначе
			СпрГрафикиПоставкиТовараОбъект = Справочники.ГрафикиПоставкиТовара.СоздатьЭлемент();
			СпрГрафикиПоставкиТовараОбъект.Владелец = Объект.Производитель;
			СпрГрафикиПоставкиТовараОбъект.График.Загрузить(ТЗнГрафикПоставкиТовара);
		КонецЕсли;
		НоваяСтрокаТЧ = СпрГрафикиПоставкиТовараОбъект.Товары.Добавить();
		НоваяСтрокаТЧ.Номенклатура = СпрНоменклатураСсылка;
		СпрГрафикиПоставкиТовараОбъект.Записать();
	КонецЕсли;
	//---АК SHEP 2018.05.14
	
	// записываем ссылку на созданную характеристику товара
	Объект.ХарактеристикаНоменклатуры = СпрХарактеристикиНоменклатурыСсылка;
	Объект.Статус = Перечисления.СтатусыКарточекТовараПоставщиков.Создана;
	Объект.Записать();
	
	ЗафиксироватьТранзакцию();
	УстановитьПривилегированныйРежим(Ложь);
	
КонецПроцедуры

//+++АК SHEP 2018.05.17 ИП-00017035.01: ищем совпадающий график поставки товара
Функция НайтиГрафикПоставкиТовара(Производитель, ТЗнГрафикПоставкиТовара)
	
	Возврат ПредопределенноеЗначение("Справочник.ГрафикиПоставкиТовара.ПустаяСсылка");
	
	// нужно найти аналогичный график, с совпадением ТЧ "График"
	Запрос = Новый Запрос(
		"ВЫБРАТЬ
		|	ТЗнГрафикПоставкиТовара.ДеньЗаказа,
		|	ТЗнГрафикПоставкиТовара.ДеньПоставки,
		|	ТЗнГрафикПоставкиТовара.КоличествоНедель
		|ПОМЕСТИТЬ ВТГрафикПоставкиТовара
		|ИЗ
		|	&ТЗнГрафикПоставкиТовара КАК ТЗнГрафикПоставкиТовара
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ ПЕРВЫЕ 1
		|	ГрафикиПоставкиТовара.Ссылка
		|ИЗ
		|	Справочник.ГрафикиПоставкиТовара.График КАК ГрафикиПоставкиТовараГрафик
		|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ Справочник.ГрафикиПоставкиТовара КАК ГрафикиПоставкиТовара
		|		ПО ГрафикиПоставкиТовараГрафик.Ссылка = ГрафикиПоставкиТовара.Ссылка
		|		ПОЛНОЕ СОЕДИНЕНИЕ ВТГрафикПоставкиТовара КАК ВТГрафикПоставкиТовара
		|		ПО ГрафикиПоставкиТовараГрафик.ДеньЗаказа = ВТГрафикПоставкиТовара.ДеньЗаказа
		|			И ГрафикиПоставкиТовараГрафик.ДеньПоставки = ВТГрафикПоставкиТовара.ДеньПоставки
		|			И ГрафикиПоставкиТовараГрафик.КоличествоНедель = ВТГрафикПоставкиТовара.КоличествоНедель
		|ГДЕ
		|	ГрафикиПоставкиТовара.Владелец = &Производитель");
	Запрос.УстановитьПараметр("Производитель", Производитель);
	Запрос.УстановитьПараметр("ТЗнГрафикПоставкиТовара", ТЗнГрафикПоставкиТовара);
	
	УстановитьПривилегированныйРежим(Истина);
	РезультатЗапроса = Запрос.Выполнить();
	
	Если РезультатЗапроса.Пустой() Тогда Возврат ПредопределенноеЗначение("Справочник.ГрафикиПоставкиТовара.ПустаяСсылка"); КонецЕсли;
	
	ВыборкаЗапроса = РезультатЗапроса.Выбрать();
	ВыборкаЗапроса.Следующий();
	Возврат ВыборкаЗапроса.Ссылка;
	
КонецФункции

Функция ПолучитьКаталогХраненияФайлов(Поставщик) Экспорт
Перем ДатаДок;
	
	УстановитьПривилегированныйРежим(Истина);
	
	КаталогХраненияФайлов = СокрЛП(Константы.КаталогХраненияФайлов.Получить());
	КаталогХраненияФайлов = КаталогХраненияФайлов + ?(Прав(КаталогХраненияФайлов, 1) = "\", "", "\") + "ХарактеристикиНоменклатурыПоставщиков\" + Строка(Поставщик.УникальныйИдентификатор()) + "\";
	
	ФайлКаталогХраненияФайлов = Новый Файл(КаталогХраненияФайлов);
	Если НЕ ФайлКаталогХраненияФайлов.Существует() Тогда
		СоздатьКаталог(КаталогХраненияФайлов);
	КонецЕсли;
	
	УстановитьПривилегированныйРежим(Ложь);
	
	Возврат КаталогХраненияФайлов;
	
КонецФункции // ПолучитьКаталогХраненияФайлов()

Процедура ЗаполнитьКонтактыДляЗаказаПоставщика(Поставщик, ОбъектДляЗаполнения) Экспорт
	
	Если НЕ ЗначениеЗаполнено(Поставщик) Тогда Возврат; КонецЕсли;
	
	УстановитьПривилегированныйРежим(Истина);
	
	Запрос = Новый Запрос(
		"ВЫБРАТЬ ПЕРВЫЕ 1
		|	ЕСТЬNULL(КонтактныеЛица.Наименование, """") КАК ЗаказыКонтактноеЛицо,
		|	ЕСТЬNULL(ВЫРАЗИТЬ(КонтактнаяИнформацияТелефоны.Представление КАК СТРОКА(200)), """") КАК ЗаказыКонтактныйТелефон,
		|	ЕСТЬNULL(ВЫРАЗИТЬ(ЕСТЬNULL(КонтактнаяИнформацияКонтрагента.Представление, КонтактнаяИнформацияЭлАдреса.Представление) КАК СТРОКА(300)), """") КАК ЗаказыЭлАдрес
		|ИЗ
		|	РегистрСведений.КонтактнаяИнформация КАК КонтактнаяИнформацияКонтрагента
		|		ПОЛНОЕ СОЕДИНЕНИЕ Справочник.КонтактныеЛицаКонтрагентов КАК КонтактныеЛицаКонтрагентов
		|			ЛЕВОЕ СОЕДИНЕНИЕ Справочник.КонтактныеЛица КАК КонтактныеЛица
		|			ПО КонтактныеЛицаКонтрагентов.КонтактноеЛицо = КонтактныеЛица.Ссылка
		|			ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.КонтактнаяИнформация КАК КонтактнаяИнформацияЭлАдреса
		|			ПО (КонтактнаяИнформацияЭлАдреса.Объект = КонтактныеЛицаКонтрагентов.Ссылка)
		|				И (КонтактнаяИнформацияЭлАдреса.Тип = ЗНАЧЕНИЕ(Перечисление.ТипыКонтактнойИнформации.АдресЭлектроннойПочты))
		|				И (КонтактнаяИнформацияЭлАдреса.Вид = ЗНАЧЕНИЕ(Справочник.ВидыКонтактнойИнформации.АдресЭлектроннойПочтыКонтактногоЛицаКонтрагента))
		|			ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.КонтактнаяИнформация КАК КонтактнаяИнформацияТелефоны
		|			ПО (КонтактнаяИнформацияТелефоны.Объект = КонтактныеЛицаКонтрагентов.Ссылка)
		|				И (КонтактнаяИнформацияТелефоны.Тип = ЗНАЧЕНИЕ(Перечисление.ТипыКонтактнойИнформации.Телефон))
		|				И (КонтактнаяИнформацияТелефоны.Вид = ЗНАЧЕНИЕ(Справочник.ВидыКонтактнойИнформации.РабочийТелефонКонтактногоЛицаКонтрагента))
		|		ПО КонтактнаяИнформацияКонтрагента.Объект = КонтактныеЛицаКонтрагентов.Владелец
		|			И (КонтактныеЛицаКонтрагентов.РольКонтактногоЛица = ЗНАЧЕНИЕ(Справочник.РолиКонтактныхЛиц.ДляЗаказов))
		|			И (НЕ КонтактныеЛицаКонтрагентов.ПометкаУдаления)
		|ГДЕ
		|	КонтактнаяИнформацияКонтрагента.Объект = &Поставщик
		|	И КонтактнаяИнформацияКонтрагента.Тип = ЗНАЧЕНИЕ(Перечисление.ТипыКонтактнойИнформации.АдресЭлектроннойПочты)
		|	И КонтактнаяИнформацияКонтрагента.Вид = ЗНАЧЕНИЕ(Справочник.ВидыКонтактнойИнформации.АдресЭлектроннойПочтыКонтрагентаДляОбменаДокументами)");
	Запрос.УстановитьПараметр("Поставщик", Поставщик);
	
	РезультатЗапроса = Запрос.Выполнить();
	Если РезультатЗапроса.Пустой() Тогда Возврат; КонецЕсли;
	
	ВыборкаЗапроса = РезультатЗапроса.Выбрать();
	ВыборкаЗапроса.Следующий();
	ЗаполнитьЗначенияСвойств(ОбъектДляЗаполнения, ВыборкаЗапроса);
	
	УстановитьПривилегированныйРежим(Ложь);
	
КонецПроцедуры

//+++АК SHEP 2018.12.19 ИП-00018753.05
Функция ПолучитьЕдиницуИзмеренияНоменклатуры(СпрНоменклатураСсылка) Экспорт
	
	Запрос = Новый Запрос(
		"ВЫБРАТЬ ПЕРВЫЕ 1
		|	ЕдиницыИзмерения.Ссылка
		|ИЗ
		|	Справочник.ЕдиницыИзмерения КАК ЕдиницыИзмерения
		|ГДЕ
		|	ЕдиницыИзмерения.Владелец = &СпрНоменклатура
		|	И ЕдиницыИзмерения.ЕдиницаПоКлассификатору = ВЫРАЗИТЬ(&СпрНоменклатура КАК Справочник.Номенклатура).БазоваяЕдиницаИзмерения
		|
		|УПОРЯДОЧИТЬ ПО
		|	ЕдиницыИзмерения.ПометкаУдаления");
	Запрос.УстановитьПараметр("СпрНоменклатура", СпрНоменклатураСсылка);
	
	РезультатЗапроса = Запрос.Выполнить();
	Если РезультатЗапроса.Пустой() Тогда
		СпрЕдиницыИзмеренияСсылка = ПредопределенноеЗначение("Справочник.ЕдиницыИзмерения.ПустаяСсылка");
	Иначе
		ВыборкаЗапроса = РезультатЗапроса.Выбрать();
		ВыборкаЗапроса.Следующий();
		СпрЕдиницыИзмеренияСсылка = ВыборкаЗапроса.Ссылка;
	КонецЕсли;
	
	Возврат СпрЕдиницыИзмеренияСсылка;
	
КонецФункции
