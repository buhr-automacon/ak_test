﻿
&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	ДатаОпроса = НачалоДня(ТекущаяДата());
	
	Кандидаты.Параметры.УстановитьЗначениеПараметра("ДатаОпроса", ДатаОпроса);
	Кандидаты.Параметры.УстановитьЗначениеПараметра("Продавец"	, Справочники.ДолжностиОрганизаций.НайтиПоНаименованию("Продавец-консультант"));
	Кандидаты.Параметры.УстановитьЗначениеПараметра("Кассир"	, Справочники.ДолжностиОрганизаций.НайтиПоНаименованию("Кассир"));
	//+++АК POZM 2018.05.03 ИП-00018208
	Кандидаты.Параметры.УстановитьЗначениеПараметра("Пекарь"	, Справочники.ДолжностиОрганизаций.НайтиПоНаименованию("Пекарь"));
	//---АК POZM 
	
	ОпрошенныеСегодня.Параметры.УстановитьЗначениеПараметра("ДатаОпроса"	, ДатаОпроса);
	НеопрошенныеСегодня.Параметры.УстановитьЗначениеПараметра("ДатаОпроса"	, ДатаОпроса);
	
	ТекстЗапроса="ВЫБРАТЬ ПЕРВЫЕ 1
	             |	ТабельРаботыПродавцов.ТорговаяТочка
	             |ИЗ
	             |	РегистрСведений.ТабельРаботыПродавцов КАК ТабельРаботыПродавцов
	             |ГДЕ
	             |	ТабельРаботыПродавцов.Период = &НаДату
	             |	И ТабельРаботыПродавцов.ТорговаяТочка <> ЗНАЧЕНИЕ(Справочник.СтруктурныеЕдиницы.ПустаяСсылка)";
	Запрос = Новый Запрос(ТекстЗапроса);
	Запрос.УстановитьПараметр("НаДату",ДатаОпроса);
	Выборка = Запрос.Выполнить().Выбрать();
	Выборка.Следующий();
	
	ФильтрПоТочке = Выборка.ТорговаяТочка;
	ФильтрПоТочкеПриИзмененииСервер();
	
КонецПроцедуры


Процедура ФильтрПоТочкеПриИзмененииСервер()
	
	Кандидаты.Параметры.УстановитьЗначениеПараметра("ФильтрПоТочке"				, ФильтрПоТочке);
	ОпрошенныеСегодня.Параметры.УстановитьЗначениеПараметра("ФильтрПоТочке"		, ФильтрПоТочке);
	НеопрошенныеСегодня.Параметры.УстановитьЗначениеПараметра("ФильтрПоТочке"	, ФильтрПоТочке);
	
	Если ЗначениеЗаполнено(ФильтрПоТочке) Тогда
		Кандидаты.Параметры.УстановитьЗначениеПараметра("ПоВсемТочкам"			, Ложь);
		ОпрошенныеСегодня.Параметры.УстановитьЗначениеПараметра("ПоВсемТочкам"	, Ложь);
		НеопрошенныеСегодня.Параметры.УстановитьЗначениеПараметра("ПоВсемТочкам", Ложь);
	Иначе
		Кандидаты.Параметры.УстановитьЗначениеПараметра("ПоВсемТочкам"			, Истина);
		ОпрошенныеСегодня.Параметры.УстановитьЗначениеПараметра("ПоВсемТочкам"	, Истина);
		НеопрошенныеСегодня.Параметры.УстановитьЗначениеПараметра("ПоВсемТочкам", Истина);
	КонецЕсли;
	
КонецПроцедуры	

&НаКлиенте
Процедура ФильтрПоТочкеПриИзменении(Элемент)
	
	ФильтрПоТочкеПриИзмененииСервер();
	
КонецПроцедуры

&НаКлиенте
Процедура КандидатыВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	ТекДанные = Элементы.Кандидаты.ТекущиеДанные;
	Если Вопрос("Создать экзамен для " + ТекДанные.Продавец + " ?", РежимДиалогаВопрос.ДаНет) = КодВозвратаДиалога.Да Тогда
		Парам = Новый Структура;
		Парам.Вставить("Продавец"			, ТекДанные.Продавец);
		Парам.Вставить("Точка"				, ТекДанные.Точка);
		Парам.Вставить("Свойство"			, ТекДанные.Свойство);
		Парам.Вставить("Должность"			, ТекДанные.Должность);
		Парам.Вставить("ВопросовВЭкзамене"	, ТекДанные.ВопросовВЭкзамене);
		ОткрытьФормуМодально("Документ.ЭкзаменыПродавцов.Форма.ФормаДокумента", Парам);
		//Элементы.Кандидаты.Обновить();
	КонецЕсли;	
	
КонецПроцедуры


&НаКлиенте
Процедура ДатаОпросаПриИзменении(Элемент)
	
	Кандидаты.Параметры.УстановитьЗначениеПараметра("ДатаОпроса"			, ДатаОпроса);
	ОпрошенныеСегодня.Параметры.УстановитьЗначениеПараметра("ДатаОпроса"	, ДатаОпроса);
	НеопрошенныеСегодня.Параметры.УстановитьЗначениеПараметра("ДатаОпроса"	, ДатаОпроса);
	
КонецПроцедуры
