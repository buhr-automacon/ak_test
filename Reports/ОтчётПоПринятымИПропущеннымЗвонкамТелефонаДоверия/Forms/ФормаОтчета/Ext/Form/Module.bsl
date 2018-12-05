﻿
//+++АК SHEP 2018.01.25 ИП-00017665.02
// Добавлен новый отчёт "ОтчётПоПринятымИПропущеннымЗвонкамТелефоновДоверия" на основании "ОтчётПоПринятымИПропущеннымЗвонкам", тоже сделанного мной )

&НаКлиенте
Процедура Сформировать(Команда)
	
	СкомпоноватьРезультат(); //Результат, ДанныеРасшифровкиКД);
	Возврат;
	
	ТекстОшибки = СформироватьНаСервере();
	
	Если ЗначениеЗаполнено(ТекстОшибки) Тогда
		Предупреждение(ТекстОшибки);
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Функция СформироватьНаСервере()
	
	Настройки = Отчет.КомпоновщикНастроек.ПолучитьНастройки();
	
	Период = Настройки.ПараметрыДанных.НайтиЗначениеПараметра(Новый ПараметрКомпоновкиДанных("Период")).Значение;
	ДатаНачала = Период.ДатаНачала; ДатаОкончания = Период.ДатаОкончания;
	Если НЕ ЗначениеЗаполнено(ДатаНачала) ИЛИ НЕ ЗначениеЗаполнено(ДатаОкончания) Тогда
		Возврат "Дата начала и окончания периода должны быть заполнены!";
	КонецЕсли;
	
	СписокНомеров = Новый СписокЗначений;
	СтруктураНомеров = Новый Структура("НомераТелефонаДоверия", "Телефон доверия");
	Для Каждого КлючИЗначение Из СтруктураНомеров Цикл
		
		ЗначениеПараметра = Настройки.ПараметрыДанных.НайтиЗначениеПараметра(Новый ПараметрКомпоновкиДанных(КлючИЗначение.Ключ));
		Если НЕ ЗначениеПараметра.Использование ИЛИ НЕ ЗначениеЗаполнено(ЗначениеПараметра.Значение) Тогда Продолжить; КонецЕсли;
		
		МассивНомеров = ОбщегоНазначения.РазложитьСтрокуВМассивПодстрок(ЗначениеПараметра.Значение, ",");
		Для Каждого Номер Из МассивНомеров Цикл
			НомерТелефона = АК_ТелефонияСервер.ОчиститьНомерТелефона(Номер);
			Если СписокНомеров.НайтиПоЗначению(НомерТелефона) = Неопределено Тогда
				СписокНомеров.Добавить(НомерТелефона, КлючИЗначение.Значение);
			КонецЕсли;
		КонецЦикла;
		
	КонецЦикла;
	
	Если СписокНомеров.Количество() = 0 Тогда Возврат "Не заполнены номера телефонов!"; КонецЕсли;
	
	ЗаполнитьТЗнЗвонков(ДатаНачала, ДатаОкончания, СписокНомеров);
	Отчет.ТаблицаЗвонков.Загрузить(РеквизитФормыВЗначение("ТЗнЗвонков"));
	Возврат "";
	
	СхемаКомпоновкиДанных = РеквизитФормыВЗначение("Отчет").ПолучитьМакет("ОсновнаяСхемаКомпоновкиДанных");
	
	// Сформируем структуру внешних данных
	ВнешниеНаборыДанных = Новый Структура;
	ВнешниеНаборыДанных.Вставить("ТЗнЗвонков", РеквизитФормыВЗначение("ТЗнЗвонков"));
	
	ДанныеРасшифровкиКД = Новый ДанныеРасшифровкиКомпоновкиДанных;
	//ДанныеРасшифровкиКД = ДанныеРасшифровки;
	КомпоновщикМакета = Новый КомпоновщикМакетаКомпоновкиДанных;
	МакетКомпоновки = КомпоновщикМакета.Выполнить(СхемаКомпоновкиДанных, Настройки, ДанныеРасшифровкиКД);
	
	// Инициализируем процессор СКД
	ПроцессорКомпоновкиДанных = Новый ПроцессорКомпоновкиДанных;
	ПроцессорКомпоновкиДанных.Инициализировать(МакетКомпоновки, ВнешниеНаборыДанных, ДанныеРасшифровкиКД, Истина);
	ДанныеРасшифровки = ПоместитьВоВременноеХранилище(ДанныеРасшифровкиКД, ЭтаФорма.УникальныйИдентификатор);
	
	// Инициализируем процессор вывода
	Результат.Очистить();
	ПроцессорВывода = Новый ПроцессорВыводаРезультатаКомпоновкиДанныхВТабличныйДокумент;
	ПроцессорВывода.УстановитьДокумент(Результат);
	ПроцессорВывода.Вывести(ПроцессорКомпоновкиДанных);
	
КонецФункции

&НаСервере
Процедура ЗаполнитьТЗнЗвонков(ДатаНачала, ДатаОкончания, СписокНомеров)
	
	ТЗнЗвонков.Очистить();
	
	ТЗн = АК_ТелефонияСервер.ПрочитатьЛогAsterisk(ДатаНачала, ДатаОкончания);
	
	Для Каждого СтрокаТЗн Из ТЗн Цикл
		
		НомерТелефона = СокрЛП(СтрокаТЗн.src);
		
		ЭлементСписка = СписокНомеров.НайтиПоЗначению(НомерТелефона);
		Если ЭлементСписка = Неопределено Тогда Продолжить; КонецЕсли;
		
		НоваяСтрокаТЗнЗвонков = ТЗнЗвонков.Добавить();
		НоваяСтрокаТЗнЗвонков.Дата = СтрокаТЗн.calldate;
		НоваяСтрокаТЗнЗвонков.ПериодДень = СтрокаТЗн.calldate;
		НоваяСтрокаТЗнЗвонков.ПериодЧас = СтрокаТЗн.calldate;
		НоваяСтрокаТЗнЗвонков.КатегорияТелефона = ЭлементСписка.Представление;
		НоваяСтрокаТЗнЗвонков.НомерТелефона = НомерТелефона;
		НоваяСтрокаТЗнЗвонков.Статус = СтрокаТЗн.disposition;
		//НоваяСтрокаТЗнЗвонков.КвоПринятыхЗвонков = ?(СтрокаТЗн.NotAnswered, 0, 1);
		НоваяСтрокаТЗнЗвонков.КвоПринятыхЗвонков = ?(НоваяСтрокаТЗнЗвонков.Статус = "ANSWERED", 1, 0);
		НоваяСтрокаТЗнЗвонков.КвоПропущенныхЗвонков = 1 - НоваяСтрокаТЗнЗвонков.КвоПринятыхЗвонков;
		
	КонецЦикла;
	
КонецПроцедуры

&НаКлиенте
Процедура РезультатОбработкаРасшифровки00(Элемент, Расшифровка, СтандартнаяОбработка)
Перем ВыполненноеДействие;
	
	СтандартнаяОбработка = Истина;
	
	//ДанныеРасшифровки = ПолучитьИзВременногоХранилища(ДанныеРасшифровкиАдрес);
	//РезультатОбработкаРасшифровкиНаСервере(ПоместитьВоВременноеХранилище(Расшифровка));
	Возврат;
	
	//СхемаКД = РеквизитФормыВЗначение("Отчет").ПолучитьМакет("ОсновнаяСхемаКомпоновкиДанных");
	//ОбработкаРасшифровки = Новый ОбработкаРасшифровкиКомпоновкиДанных(ДанныеРасшифровки, Новый ИсточникДоступныхНастроекКомпоновкиДанных(СхемаКД));
	ОбработкаРасшифровки = Новый ОбработкаРасшифровкиКомпоновкиДанных(ЭтаФорма.ДанныеРасшифровки, Новый ИсточникДоступныхНастроекКомпоновкиДанных(ЭтаФорма.Отчет));
	
	НастройкиРасшифровки = ОбработкаРасшифровки.Выполнить(Расшифровка, ВыполненноеДействие);
	
	Если НастройкиРасшифровки <> Неопределено Тогда
		
		Отчет.КомпоновщикНастроек.ЗагрузитьНастройки(НастройкиРасшифровки);
		
		Сформировать(Неопределено);
		
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Функция ПолучитьСхемуКомпоновкиДанныхНаСервере()
	Возврат ПоместитьВоВременноеХранилище(РеквизитФормыВЗначение("Отчет").ПолучитьМакет("ОсновнаяСхемаКомпоновкиДанных"));
	//МакетСКД = Новый СхемаКомпоновкиДанных;
	//РеквОбъ = РеквизитФормыВЗначение("Отчет");
	//МакетСКД = РеквОбъ.ПолучитьМакет("ОсновнаяСхемаКомпоновкиДанных");
КонецФункции

&НаСервере
Функция РезультатОбработкаРасшифровкиНаСервере(АдресРасшифровки)
Перем ВыполненноеДействие;
	
	Расшифровка = ПолучитьИзВременногоХранилища(АдресРасшифровки);
	
	СхемаКД = РеквизитФормыВЗначение("Отчет").ПолучитьМакет("ОсновнаяСхемаКомпоновкиДанных");
	ДанныеРасшифровкиКД = ПолучитьИзВременногоХранилища(ДанныеРасшифровки);
	ОбработкаРасшифровки = Новый ОбработкаРасшифровкиКомпоновкиДанных(ДанныеРасшифровкиКД, Новый ИсточникДоступныхНастроекКомпоновкиДанных(СхемаКД));
	
	НастройкиРасшифровки = ОбработкаРасшифровки.Выполнить(Расшифровка, ВыполненноеДействие);
	//Возврат НастройкиРасшифровки;
	
КонецФункции

&НаКлиенте
Процедура ДокументРезультатОбработкаРасшифровки(Элемент, Расшифровка, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;      
	ИсточникНастроек = Новый ИсточникДоступныхНастроекКомпоновкиДанных(Отчет);      
	ОбработкаРасшифровкиКД = Новый ОбработкаРасшифровкиКомпоновкиДанных(ДанныеРасшифровки, ИсточникНастроек);            
	ВыполненноеДействие = Неопределено;      
	ПараметрДействия = Неопределено;      
	ОбработкаРасшифровкиКД.ВыбратьДействие(Расшифровка, ВыполненноеДействие, ПараметрДействия);            
	Если ВыполненноеДействие <> ДействиеОбработкиРасшифровкиКомпоновкиДанных.Нет Тогда                        
		Если ВыполненноеДействие = ДействиеОбработкиРасшифровкиКомпоновкиДанных.ОткрытьЗначение Тогда                                    
			ОткрытьЗначение(ПараметрДействия);                              
		КонецЕсли;                   
	КонецЕсли;       
	
КонецПроцедуры