﻿
#Область ПрограммныйИнтерфейс

//+++АК LATV 2018.10.03 ИП-00020009
Функция ПечатьСДополнительнойОбработкой(Параметры, АдресХранилища) Экспорт

	ТабличныйДокумент = Печать(Параметры.ИмяМакета, Параметры.МассивСсылок);
	ОбновитьДокументыИСформироватьРасходныеОрдера(Параметры.МассивСсылок, Параметры.ПараметрыДополнительнойОбработки);
	
	Результат = Новый Структура;
	Результат.Вставить("ТабличныйДокумент", ТабличныйДокумент);
	Результат.Вставить("МассивСсылок",		Параметры.МассивСсылок);
	ПоместитьВоВременноеХранилище(Результат, АдресХранилища);

КонецФункции

//+++АК LATV 2018.10.03 ИП-00020009
Функция Печать(ИмяМакета, МассивСсылок) Экспорт

	ТабличныйДокумент = Новый ТабличныйДокумент;
	
	Если ИмяМакета = "ЗаданиеНаРазборку" Тогда
		ЗаполнитьПечатнуюФорму_ЗаданиеНаРазборку(ТабличныйДокумент, МассивСсылок);
	КонецЕсли;
	
	Возврат ТабличныйДокумент;

КонецФункции

//+++АК KIRN 2018.07.03 ИП-00019172
&НаСервере
Процедура УдалитьЗаданиеИзРО(Ссылка) Экспорт
	Запрос = Новый Запрос;
	Запрос.Текст = "ВЫБРАТЬ
	|	РасходныйОрдерСкладТовары.Номенклатура,
	|	ВЫРАЗИТЬ(РасходныйОрдерСкладТовары.Ссылка.Получатель КАК Справочник.СтруктурныеЕдиницы) КАК СтруктурнаяЕдиница,
	|	РасходныйОрдерСкладТовары.Ссылка.Склад КАК Склад,
	|	РасходныйОрдерСкладТовары.Характеристика,
	|	РасходныйОрдерСкладТовары.КоличествоУРЗ КАК Количество,
	|	РасходныйОрдерСкладТовары.Ссылка КАК Ссылка,
	|	РасходныйОрдерСкладТовары.ДатаПроизводства,
	|	РасходныйОрдерСкладТовары.ЗаданиеНаРазборку,
	|	РасходныйОрдерСкладТовары.ЗаданиеНаРазборку.Закрыто КАК Закрыто,
	|	НАЧАЛОПЕРИОДА(РасходныйОрдерСкладТовары.Ссылка.Дата, ДЕНЬ) КАК Дата
	|ИЗ
	|	Документ.РасходныйОрдерСклад.Товары КАК РасходныйОрдерСкладТовары
	|ГДЕ
	|	РасходныйОрдерСкладТовары.ЗаданиеНаРазборку в (&ЗаданиеНаРазборку)
	|
	|УПОРЯДОЧИТЬ ПО
	|	РасходныйОрдерСкладТовары.Ссылка";
	Запрос.УстановитьПараметр("ЗаданиеНаРазборку",Ссылка);
	Выборка = Запрос.Выполнить().Выбрать();
	Пока Выборка.СледующийПоЗначениюПоля("Ссылка") Цикл
		РасхОрдерОбъект = Выборка.Ссылка.ПолучитьОбъект();
		Пока Выборка.Следующий() Цикл
			СтрокиТовар = РасхОрдерОбъект.Товары.НайтиСтроки(Новый Структура("ЗаданиеНаРазборку", Выборка.ЗаданиеНаРазборку));
			Для Каждого СтрокаТовар ИЗ СтрокиТовар Цикл
				РасхОрдерОбъект.Товары.Удалить(СтрокаТовар);
			КонецЦикла;
		КонецЦикла;
		
		Если РасхОрдерОбъект.Модифицированность() Тогда
			РасхОрдерОбъект.Записать(?(РасхОрдерОбъект.ПометкаУдаления, РежимЗаписиДокумента.Запись, РежимЗаписиДокумента.Проведение));
		КонецЕСли;
	КонецЦикла;
	
	Если типЗнч(Ссылка) = Тип("ДокументСсылка.ЗаданиеНаРазборку") Тогда
		Если Ссылка.ЗакрытоИОбновлено Тогда
			Об = Ссылка.ПолучитьОбъект();
			Об.ЗакрытоИОбновлено = ложь;
			Об.ДополнительныеСвойства.Вставить("ЗаполнениеРасходниковВЗаданиях");
			Об.Записать();
		КонецЕСли;
	иначеЕсли ТипЗнч(Ссылка) = Тип("Массив") Тогда
		Для Каждого СтрСсылка из Ссылка Цикл
			Если СтрСсылка.ЗакрытоИОбновлено Тогда
				Об = СтрСсылка.ПолучитьОбъект();
				Об.ЗакрытоИОбновлено = ложь;
				Об.ДополнительныеСвойства.Вставить("ЗаполнениеРасходниковВЗаданиях");
				Об.Записать();
			КонецЕСли;
		КонецЦикла;
	КонецеСли;
КонецПроцедуры

//+++АК KIRN 2018.07.05 ИП-00019172
&НаСервере
Процедура ДобавитьЗаданиеВРО(Ссылка) ЭКспорт
	Обработки.ЗаполнитьРасходникиПоЗаданиямНаРазборку.ЗаполнитьРасходники(Новый Структура("ДатаРаспределения, СписокЗаданий",?(ТипЗнч(Ссылка)=Тип("ДокументСсылка.ЗаданиеНаРазборку"),Ссылка.Дата, Ссылка[0].Дата),Ссылка));
КонецПРоцедуры

#КонецОбласти

#Область ОбработчикиСобытий


#КонецОбласти

#Область СлужебныеПроцедурыИФункции

//+++АК LATV 2018.10.03 ИП-00020009
Процедура ЗаполнитьПечатнуюФорму_ЗаданиеНаРазборку(ТабДок, МассивСсылок)

	// Данные для печати
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ
		|	ЗаданиеНаРазборку.Ссылка,
		|	ЗаданиеНаРазборку.ВерсияДанных,
		|	ЗаданиеНаРазборку.ПометкаУдаления,
		|	ЗаданиеНаРазборку.Номер,
		|	ЗаданиеНаРазборку.Дата,
		|	ЗаданиеНаРазборку.Проведен,
		|	ЗаданиеНаРазборку.Склад,
		|	ЗаданиеНаРазборку.Склад.Владелец,
		|	ЗаданиеНаРазборку.Подготовлен,
		|	ЗаданиеНаРазборку.Закрыто,
		|	ЗаданиеНаРазборку.Автор,
		|	ЗаданиеНаРазборку.Комментарий,
		|	ЗаданиеНаРазборку.Ответственный,
		|	ЗаданиеНаРазборку.Номенклатура,
		|	ЗаданиеНаРазборку.Номенклатура.ЕдиницаХраненияОстатков КАК ЕдиницаИзмерения,
		|	ЗаданиеНаРазборку.Характеристика,
		|	ЗаданиеНаРазборку.ДанныеСборкиНаМобильномУстройстве,
		|	ЗаданиеНаРазборку.Сборщик,
		|	ЗаданиеНаРазборку.Представление,
		|	ЗаданиеНаРазборку.МоментВремени
		|ИЗ
		|	Документ.ЗаданиеНаРазборку КАК ЗаданиеНаРазборку
		|ГДЕ
		|	ЗаданиеНаРазборку.Ссылка В(&Ссылка)";
	
	Запрос.УстановитьПараметр("Ссылка", МассивСсылок);
	ТЗДок = Запрос.Выполнить().Выгрузить();
	
	//
	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ
		|	ЗаданиеНаРазборкуТовары.Ссылка,
		|	МИНИМУМ(ЗаданиеНаРазборкуТовары.СтруктурнаяЕдиница.НомерТочки) КАК СтруктурнаяЕдиницаНомерТочки
		|ПОМЕСТИТЬ вт
		|ИЗ
		|	Документ.ЗаданиеНаРазборку.Товары КАК ЗаданиеНаРазборкуТовары
		|ГДЕ
		|	ЗаданиеНаРазборкуТовары.Ссылка В(&Ссылка)
		|
		|СГРУППИРОВАТЬ ПО
		|	ЗаданиеНаРазборкуТовары.Ссылка
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	ЗаданиеНаРазборкуТовары.Ссылка КАК Ссылка,
		|	ЗаданиеНаРазборкуТовары.НомерСтроки,
		|	ЗаданиеНаРазборкуТовары.СтруктурнаяЕдиница,
		|	ПРЕДСТАВЛЕНИЕ(ЗаданиеНаРазборкуТовары.СтруктурнаяЕдиница) КАК СтруктурнаяЕдиницаПредставление,
		|	ЗаданиеНаРазборкуТовары.ДатаПроизводства,
		|	ЗаданиеНаРазборкуТовары.Количество,
		|	ЗаданиеНаРазборкуТовары.КоличествоКоробок,
		|	ЗаданиеНаРазборкуТовары.Собран,
		|	ЗаданиеНаРазборкуТовары.СтруктурнаяЕдиница.НомерТочки КАК СтруктурнаяЕдиницаНомерТочки,
		|	вт.СтруктурнаяЕдиницаНомерТочки КАК СтруктурнаяЕдиницаНомерТочки1
		|ИЗ
		|	вт КАК вт
		|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ Документ.ЗаданиеНаРазборку.Товары КАК ЗаданиеНаРазборкуТовары
		|		ПО вт.Ссылка = ЗаданиеНаРазборкуТовары.Ссылка
		|
		|УПОРЯДОЧИТЬ ПО
		|	СтруктурнаяЕдиницаНомерТочки1,
		|	СтруктурнаяЕдиницаНомерТочки
		|ИТОГИ ПО
		|	Ссылка";
	
	Запрос.УстановитьПараметр("Ссылка", МассивСсылок);
	РезультатЗапроса = Запрос.Выполнить();
	ВыборкаДок = РезультатЗапроса.Выбрать(ОбходРезультатаЗапроса.ПоГруппировкам);
	
	Северный = Справочники.СтруктурныеЕдиницы.НайтиПоКоду("P00000243", Истина);
	
	// Заполнение
	ТабДок.АвтоМасштаб			= Истина;
	ТабДок.ИмяПараметровПечати	= "АКЗаданиеРазборка";
	
	Макет = Документы.ЗаданиеНаРазборку.ПолучитьМакет("Разборка");
	
	ОбластьЗаголовок	= Макет.ПолучитьОбласть("Заголовок");
	ОбластьСклад		= Макет.ПолучитьОбласть("Склад");
	ОбластьВремяПечати	= Макет.ПолучитьОбласть("ВремяПечати");
	
	ЭтоПервыйДокумент = Истина;
	Пока ВыборкаДок.Следующий() Цикл
		
		Если Не ЭтоПервыйДокумент Тогда
			ТабДок.ВывестиГоризонтальныйРазделительСтраниц();
		КонецЕсли;
		
		// Данные документа
		Выборка = ТЗДок.НайтиСтроки(Новый Структура("Ссылка", ВыборкаДок.Ссылка))[0];
		Если Выборка.СкладВладелец = Северный Тогда
			ОбластьШапкаТаблицы	= Макет.ПолучитьОбласть("ШапкаТаблицыСеверный");
			ОбластьСтрока		= Макет.ПолучитьОбласть("СтрокаСеверный");
			ОбластьПодвал		= Макет.ПолучитьОбласть("ПодвалСеверный");
		Иначе
			ОбластьШапкаТаблицы	= Макет.ПолучитьОбласть("ШапкаТаблицы");
			ОбластьСтрока		= Макет.ПолучитьОбласть("Строка");
			ОбластьПодвал		= Макет.ПолучитьОбласть("Подвал");
		КонецЕсли;
		
		// Подсчет количества
		ВыборкаНоменклатура = ВыборкаДок.Выбрать();
		КолКороб	= 0;
		Кол			= 0;
		Пока ВыборкаНоменклатура.Следующий() Цикл
			КолКороб	= КолКороб + ВыборкаНоменклатура.КоличествоКоробок;
			Кол			= Кол + ВыборкаНоменклатура.Количество;
		КонецЦикла;
		ВыборкаНоменклатура.Сбросить();
		
		// Заполнение
		ОбластьЗаголовок.Параметры.Заполнить(Выборка);
		ОбластьЗаголовок.Параметры.Дата = Формат(Выборка.Дата,"ДЛФ=DD");
		
		ОбщегоНазначенияКлиентСервер.ДобавитьQRКодВОбластьДокумента(ОбластьЗаголовок, Выборка.Ссылка);
		
		ТабДок.Вывести(ОбластьЗаголовок);
		
		ОбластьСклад.Параметры.Заполнить(Выборка);
		ОбластьСклад.Параметры.Коробок=КолКороб;
		ТабДок.Вывести(ОбластьСклад, ВыборкаДок.Уровень());
		
		ТабДок.Вывести(ОбластьШапкаТаблицы);
		
		Пока ВыборкаНоменклатура.Следующий() Цикл
			ОбластьСтрока.Параметры.Заполнить(ВыборкаНоменклатура);
			ОбластьСтрока.Параметры.ЕдиницаИзмерения = Выборка.ЕдиницаИзмерения;
			
			Если Выборка.СкладВладелец = Северный Тогда
				СтруктурнаяЕдиницаСтрокой = ВыборкаНоменклатура.СтруктурнаяЕдиницаПредставление;
				ПозицияПодчеркивания = Найти(СтруктурнаяЕдиницаСтрокой, "_");
				ОбластьСтрока.Параметры.НомерСтруктурнойЕдиницы			= Лев(СтруктурнаяЕдиницаСтрокой, ПозицияПодчеркивания - 1);
				ОбластьСтрока.Параметры.НаименованиеСтруктурнойЕдиницы	= Сред(СтруктурнаяЕдиницаСтрокой, ПозицияПодчеркивания + 1);
			КонецЕсли;
			
			ТабДок.Вывести(ОбластьСтрока, ВыборкаНоменклатура.Уровень());
		КонецЦикла;
		
		ОбластьПодвал.Параметры.Количество			= Кол;
		ОбластьПодвал.Параметры.КоличествоКоробок	= КолКороб;
		ТабДок.Вывести(ОбластьПодвал);
		
		ТабДок.Вывести(ОбластьВремяПечати);
		
		ЭтоПервыйДокумент = Ложь;
	КонецЦикла;

КонецПроцедуры

//+++АК LATV 2018.10.03 ИП-00020009
Процедура ОбновитьДокументыИСформироватьРасходныеОрдера(МассивСсылок, Параметры)

	Если Параметры.Свойство("УстановитьПризнакНапечатан") Тогда
		
		СформироватьРасходныеОрдера = Ложь;
		ДатаРаспределения			= НачалоДня(ТекущаяДата()) + 24*60*60;
		
		Запрос = Новый Запрос;
		Запрос.Текст = 
			"ВЫБРАТЬ
			|	ЗаданиеНаРазборку.Дата,
			|	ЗаданиеНаРазборку.Ссылка
			|ИЗ
			|	Документ.ЗаданиеНаРазборку КАК ЗаданиеНаРазборку
			|ГДЕ
			|	ЗаданиеНаРазборку.Ссылка В(&Ссылка)
			|	И НЕ ЗаданиеНаРазборку.Напечатан";
		
		Запрос.УстановитьПараметр("Ссылка", МассивСсылок);
		
		РезультатЗапроса = Запрос.Выполнить();
		Если РезультатЗапроса.Пустой() Тогда
			Возврат;
		КонецЕсли;
		
		Выборка = РезультатЗапроса.Выбрать();
		Пока Выборка.Следующий() Цикл
			ОбДок = Выборка.Ссылка.ПолучитьОбъект();
			ОбДок.Напечатан = Истина;
			ОбДок.Записать();
			
			Если НачалоДня(Выборка.Дата) = ДатаРаспределения Тогда
				СформироватьРасходныеОрдера = Истина;
			КонецЕсли;
		КонецЦикла;
		
		Если Параметры.Свойство("СформироватьРасходныеОрдера")
		   И СформироватьРасходныеОрдера Тогда
			
			ПараметрыФормирования = Новый Структура;
			ПараметрыФормирования.Вставить("ДатаРаспределения", ДатаРаспределения);
			ПараметрыФормирования.Вставить("СписокЗаданий",		МассивСсылок);
			Обработки.ЗаполнитьРасходникиПоЗаданиямНаРазборку.ЗаполнитьРасходники(ПараметрыФормирования);
		КонецЕсли;
	КонецЕсли;

КонецПроцедуры

#КонецОбласти
