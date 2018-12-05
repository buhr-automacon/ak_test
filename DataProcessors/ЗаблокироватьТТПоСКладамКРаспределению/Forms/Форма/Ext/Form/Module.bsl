﻿
#Область ОбработчикиСобытийФормы

//+++АК LATV 2018.10.23 ИП-00020239
&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)

	Объект.Склад = СкладыСервер.ПолучитьСкладТекущегоПользователя();
	
	ИнициализироватьСКД();

КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовФормы

//+++АК LATV 2018.10.23 ИП-00020239
&НаКлиенте
Процедура СкладПриИзменении(Элемент)

	Объект.СкладыХранения.Очистить();

КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийКомандФормы

//+++АК LATV 2018.10.23 ИП-00020239
&НаКлиенте
Процедура ЗаблокироватьВыделенные(Команда)

	ИзменитьПризнакБлокировкиТТ(Истина);

КонецПроцедуры

//+++АК LATV 2018.10.23 ИП-00020239
&НаКлиенте
Процедура РазблокироватьВыделенные(Команда)

	ИзменитьПризнакБлокировкиТТ(Ложь);

КонецПроцедуры

//+++АК LATV 2018.10.23 ИП-00020239
&НаКлиенте
Процедура ЗаполнитьСклады(Команда)

	ЗаполнитьСкладыХранения();

КонецПроцедуры

//+++АК LATV 2018.10.23 ИП-00020239
&НаКлиенте
Процедура ЗаполнитьТТ(Команда)

	ЗаполнитьТорговыеТочки();

КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

//+++АК LATV 2018.10.24 ИП-00020239
&НаСервере
Процедура ИнициализироватьСКД()

	ОбработкаОбъект = РеквизитФормыВЗначение("Объект");
	
	// Склады
	СхемаКомпоновкиДанных = ОбработкаОбъект.ПолучитьМакет("ПодборДанных_Склады");
	
	АдресСхемыКД_Склады = ПоместитьВоВременноеХранилище(СхемаКомпоновкиДанных, УникальныйИдентификатор);
	ИсточникДоступныхНастроек = Новый ИсточникДоступныхНастроекКомпоновкиДанных(АдресСхемыКД_Склады);
	
	Объект.КомпоновщикНастроек_Склады.Инициализировать(ИсточникДоступныхНастроек);
	Объект.КомпоновщикНастроек_Склады.ЗагрузитьНастройки(СхемаКомпоновкиДанных.НастройкиПоУмолчанию);
	
	// ТТ
	СхемаКомпоновкиДанных = ОбработкаОбъект.ПолучитьМакет("ПодборДанных_ТТ");
	
	АдресСхемыКД_ТТ = ПоместитьВоВременноеХранилище(СхемаКомпоновкиДанных, УникальныйИдентификатор);
	ИсточникДоступныхНастроек = Новый ИсточникДоступныхНастроекКомпоновкиДанных(АдресСхемыКД_ТТ);
	
	Объект.КомпоновщикНастроек_ТТ.Инициализировать(ИсточникДоступныхНастроек);
	Объект.КомпоновщикНастроек_ТТ.ЗагрузитьНастройки(СхемаКомпоновкиДанных.НастройкиПоУмолчанию);

КонецПроцедуры

//+++АК LATV 2018.10.24 ИП-00020239
&НаСервере
Процедура УстановитьПараметрыСКД()

	Если Объект.ВыполняемоеДействие = "ЗаполнениеСкладов" Тогда
		Объект.КомпоновщикНастроек_Склады.Настройки.ПараметрыДанных.УстановитьЗначениеПараметра("СтруктурнаяЕдиница", Объект.Склад);
		
	ИначеЕсли Объект.ВыполняемоеДействие = "ЗаполнениеТТ" Тогда
		СкладыХранения = Новый СписокЗначений;
		СкладыХранения.ЗагрузитьЗначения(Объект.СкладыХранения.Выгрузить().ВыгрузитьКолонку("СкладХранения"));
		
		Объект.КомпоновщикНастроек_ТТ.Настройки.ПараметрыДанных.УстановитьЗначениеПараметра("СтруктурнаяЕдиница",	Объект.Склад);
		Объект.КомпоновщикНастроек_ТТ.Настройки.ПараметрыДанных.УстановитьЗначениеПараметра("СкладыХранения",		СкладыХранения);
	КонецЕсли;

КонецПроцедуры

//+++АК LATV 2018.10.23 ИП-00020239
&НаСервере
Процедура ЗаполнитьСкладыХранения()

	Объект.ВыполняемоеДействие = "ЗаполнениеСкладов";
	Если Не ПроверитьЗаполнение() Тогда
		Возврат;
	КонецЕсли;
	
	УстановитьПараметрыСКД();
	
	// Подбор данных
	СхемаКомпоновкиДанных = ПолучитьИзВременногоХранилища(АдресСхемыКД_Склады);
	
	КомпоновщикМакета = Новый КомпоновщикМакетаКомпоновкиДанных;
	МакетКомпоновки = КомпоновщикМакета.Выполнить(СхемаКомпоновкиДанных, Объект.КомпоновщикНастроек_Склады.ПолучитьНастройки(),,,
		Тип("ГенераторМакетаКомпоновкиДанныхДляКоллекцииЗначений"));
	
	ПроцессорКомпоновкиДанных = Новый ПроцессорКомпоновкиДанных;
	ПроцессорКомпоновкиДанных.Инициализировать(МакетКомпоновки);
	
	РезультатВыполнения = Новый ТаблицаЗначений;
	ПроцессорВывода = Новый ПроцессорВыводаРезультатаКомпоновкиДанныхВКоллекциюЗначений;
	ПроцессорВывода.УстановитьОбъект(РезультатВыполнения);
	ПроцессорВывода.Вывести(ПроцессорКомпоновкиДанных, Истина);
	
	Объект.СкладыХранения.Загрузить(РезультатВыполнения);

КонецПроцедуры

//+++АК LATV 2018.10.24 ИП-00020239
&НаСервере
Процедура ЗаполнитьТорговыеТочки()

	Объект.ВыполняемоеДействие = "ЗаполнениеТТ";
	Если Не ПроверитьЗаполнение() Тогда
		Возврат;
	КонецЕсли;
	
	УстановитьПараметрыСКД();
	
	// Подбор данных
	СхемаКомпоновкиДанных = ПолучитьИзВременногоХранилища(АдресСхемыКД_ТТ);
	
	КомпоновщикМакета = Новый КомпоновщикМакетаКомпоновкиДанных;
	МакетКомпоновки = КомпоновщикМакета.Выполнить(СхемаКомпоновкиДанных, Объект.КомпоновщикНастроек_ТТ.ПолучитьНастройки(),,,
		Тип("ГенераторМакетаКомпоновкиДанныхДляКоллекцииЗначений"));
	
	ПроцессорКомпоновкиДанных = Новый ПроцессорКомпоновкиДанных;
	ПроцессорКомпоновкиДанных.Инициализировать(МакетКомпоновки);
	
	РезультатВыполнения = Новый ТаблицаЗначений;
	ПроцессорВывода = Новый ПроцессорВыводаРезультатаКомпоновкиДанныхВКоллекциюЗначений;
	ПроцессорВывода.УстановитьОбъект(РезультатВыполнения);
	ПроцессорВывода.Вывести(ПроцессорКомпоновкиДанных, Истина);
	
	Объект.ТорговыеТочки.Загрузить(РезультатВыполнения);

КонецПроцедуры

//+++АК LATV 2018.10.23 ИП-00020239
&НаСервере
Процедура ИзменитьПризнакБлокировкиТТ(Заблокирована)

	Объект.ВыполняемоеДействие = "ИзменениеБлокировки";
	Если Не ПроверитьЗаполнение() Тогда
		Возврат;
	КонецЕсли;
	
	ТекущийПользователь = глЗначениеПеременной("глТекущийПользователь");
	
	Для Каждого СтрокаТаблицы Из Элементы.ТорговыеТочки.ВыделенныеСтроки Цикл
		
		ТекДанные = Объект.ТорговыеТочки.НайтиПоИдентификатору(СтрокаТаблицы);
		
		Для Каждого ТекСкладХранения Из Объект.СкладыХранения Цикл
			Запись = РегистрыСведений.ЗаблокированныеТТ.СоздатьМенеджерЗаписи();
			Запись.Период					= ТекущаяДата();
			Запись.СтруктурноеПодразделение	= Объект.Склад;
			Запись.Склад					= ТекСкладХранения.СкладХранения;
			Запись.ТТ						= ТекДанные.ТТ;
			
			Запись.Заблокировано			= Заблокирована;
			Запись.Пользователь				= ТекущийПользователь;
			//+++АК BELN 2018.12.04 ИП-00020614
			Если Заблокирована Тогда
				Запись.Причина			= Причина;
			КонецЕсли; 
			//---АК BELN 2018.12.04 
			
			Попытка
				Запись.Записать();
			Исключение
				ТекстСообщения = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
					НСтр("ru = 'Не удалось изменить блокировку для ""%1"" - ""%2"" по причине: %3'")
					, ТекСкладХранения.СкладХранения, ТекДанные.ТТ, ОписаниеОшибки());
				ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения);
			КонецПопытки;
		КонецЦикла;
		
	КонецЦикла;
	
	ЗаполнитьТорговыеТочки();

КонецПроцедуры
//+++АК BELN 2018.12.04 ИП-00020614      
&НаКлиенте
Процедура ПричинаНачалоВыбораИзСписка(Элемент, СтандартнаяОбработка)
	//СтандартнаяОбработка=Ложь;	
	Элементы.Причина.СписокВыбора.ЗагрузитьЗначения(ПолучитьМассивПричин());
КонецПроцедуры
//---АК BELN 2018.12.04 

//+++АК BELN 2018.12.04 ИП-00020614 
&НаСервере
Функция ПолучитьМассивПричин()
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ РАЗЛИЧНЫЕ
		|	ВЫРАЗИТЬ(ЗаблокированныеТТ.Причина КАК СТРОКА(100)) КАК Причина
		|ИЗ
		|	РегистрСведений.ЗаблокированныеТТ КАК ЗаблокированныеТТ
		|
		|УПОРЯДОЧИТЬ ПО
		|	Причина";
	
	РезультатЗапроса = Запрос.Выполнить();
	
	ВыборкаДетальныеЗаписи = РезультатЗапроса.Выбрать();
	Мас=Новый Массив;
	Пока ВыборкаДетальныеЗаписи.Следующий() Цикл
		Если ЗначениеЗаполнено(ВыборкаДетальныеЗаписи.Причина) Тогда
			Мас.Добавить(ВыборкаДетальныеЗаписи.Причина);
		КонецЕсли; 
	КонецЦикла;
	Возврат Мас;	

КонецФункции // ()

//---АК BELN 2018.12.04 
#КонецОбласти
