﻿
&НаКлиенте
Процедура ОбработкаКоманды(ПараметрКоманды, ПараметрыВыполненияКоманды)
	
	//+++АК mika 2018.10.19 Без задачи. Отображать все типы розничных точек для сторонней розницы
	//СписокВывора = Новый СписокЗначений;
	//СписокВывора.Добавить(ПредопределенноеЗначение("Перечисление.ТипыРозничныхТочек.Перекресток"));
	////+++AK GREK 13.09.2018 ИП-00019839
	//СписокВывора.Добавить(ПредопределенноеЗначение("Перечисление.ТипыРозничныхТочек.Пятерочка"));
	////---АК GREK
	СписокВывора = ПолучитьАктуальныеТипыРозничныхТочекСтороннейРозницы();
	//---АК mika
	
	СписокВывора.ПоказатьВыборЭлемента(Новый ОписаниеОповещения("ОбработкаОповещенияВыбораТипРозничнойТочки", ЭтотОбъект),"Выберите тип розничной точки");
	
КонецПроцедуры

&НаКлиенте
Процедура ВыбратьМагазинКлиент(ТипРозничнойТочки)
	
	СписокВыбора = Новый СписокЗначений;
	СписокВыбора.ЗагрузитьЗначения(ПолныеПрава.ПолучитьМассивМагазинов(,,Истина, ТипРозничнойТочки));
	
	СписокВыбора.ПоказатьВыборЭлемента(Новый ОписаниеОповещения("ОбработкаОповещенияВыбораМагазин", ЭтотОбъект), "Выберите магазин");
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещенияВыбораТипРозничнойТочки(ЗначениеВыбора, ДополнительныеПараметры) Экспорт
	
	Если ЗначениеВыбора <> Неопределено Тогда
		ВыбратьМагазинКлиент(ЗначениеВыбора.Значение);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещенияВыбораМагазин(ЗначениеВыбора, ДопПараметры) Экспорт
	
	Если ЗначениеВыбора <> Неопределено Тогда
		ПолныеПрава.УстановитьТекущийМагазин(ЗначениеВыбора.Значение);
		Магазины_Клиент.УправлениеОкнамиМагазинов("Товародвижения");
		Магазины_Клиент.УправлениеОкнамиМагазинов("КассовыеОперации");
		УстановитьЗаголовокПриложения("Текущий магазин: " + ЗначениеВыбора.Значение);
	Иначе
		УстановитьЗаголовокПриложения("Текущий магазин: <Не установлен>");
		ПолныеПрава.УстановитьТекущийМагазин(ПредопределенноеЗначение("Справочник.СтруктурныеЕдиницы.ПустаяСсылка"));
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Функция ПолучитьАктуальныеТипыРозничныхТочекСтороннейРозницы();
	
	СписокВыбора = Новый СписокЗначений();
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
	"ВЫБРАТЬ РАЗРЕШЕННЫЕ
	|	СтруктурныеЕдиницы.ТипРозничнойТочки КАК ТипРозничнойТочки
	|ИЗ
	|	Справочник.СтруктурныеЕдиницы КАК СтруктурныеЕдиницы
	|ГДЕ
	|	СтруктурныеЕдиницы.ТипСтруктурнойЕдиницы = ЗНАЧЕНИЕ(Перечисление.ТипыСтруктурныхЕдиниц.СторонняяРозница)
	|	И СтруктурныеЕдиницы.ДатаЗапускаНовойСистемыУчета <> ДАТАВРЕМЯ(1, 1, 1)
	|
	|СГРУППИРОВАТЬ ПО
	|	СтруктурныеЕдиницы.ТипРозничнойТочки
	|
	|УПОРЯДОЧИТЬ ПО
	|	ТипРозничнойТочки
	|АВТОУПОРЯДОЧИВАНИЕ";
	
	РезультатЗапроса = Запрос.Выполнить();
	
	Если НЕ  РезультатЗапроса.Пустой() Тогда
		Выборка = РезультатЗапроса.Выбрать();
		Пока Выборка.Следующий() Цикл
			СписокВыбора.Добавить(Выборка.ТипРозничнойТочки);
		КонецЦикла;
	КонецЕсли;
	
	Возврат СписокВыбора;
	
КонецФункции