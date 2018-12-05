﻿
&НаКлиенте
Процедура ПоставщикиНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	ОткрытьФорму("Отчет.ОтчетБлижайшиеТочкиПродажиТовара.Форма.ФормаВыбораПоставщиков", Новый Структура("Поставщики, Номенклатура", Поставщики, ПолучитьАналоги(Номенклатура, Отчет.НеПоказыватьАналоги)), Элемент);
	
КонецПроцедуры

&НаКлиенте
Процедура НоменклатураПриИзменении(Элемент)
	
	Отчет.Номенклатура.Очистить();
	//+++ GOLV 14.05.2018 ИП-00018610
	ВсяНоменклатура = ПолучитьАналоги(Номенклатура, Отчет.НеПоказыватьАналоги);
	//--- GOLV
	Для Каждого ЭлементСписка Из ВсяНоменклатура Цикл
		Отчет.Номенклатура.Добавить(ЭлементСписка.Значение);
	КонецЦикла;	
	
КонецПроцедуры

&НаКлиенте
Процедура ПоставщикиПриИзменении(Элемент)
	
	Отчет.Поставщики.Очистить();
	Для Каждого ЭлементСписка Из Поставщики Цикл
		Отчет.Поставщики.Добавить(ЭлементСписка.Значение);
	КонецЦикла;
	
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьКоординатыПоТТСервер(ТТ)
	
	Отчет.КоординатыШирота = ТТ.КоординатыШирота;
	Отчет.КоординатыДолгота = ТТ.КоординатыДолгота;
	
КонецПроцедуры	

&НаКлиенте
Процедура ЗаполнитьКоординатыПоТТ(Команда)
	
	ТТ = ОткрытьФормуМодально("Справочник.СтруктурныеЕдиницы.ФормаВыбора");
	
	Если ЗначениеЗаполнено(ТТ) Тогда
		ЗаполнитьКоординатыПоТТСервер(ТТ);
	КонецЕсли;	
	
КонецПроцедуры

//+++ GOLV 14.05.2018 ИП-00018610
&НаСервереБезКонтекста
Функция ПолучитьАналоги(СписокНоменклатуры, НеПоказыватьАналоги)
	
	Если НеПоказыватьАналоги Тогда
		Возврат СписокНоменклатуры;
	КонецЕсли;
	
	Запрос = Новый Запрос(
	//+++АК SHEP 2018.05.23 ИП-00018704: если у товара нет аналогов, отчёт строился по всей номенклатуре (
	//"ВЫБРАТЬ
	"ВЫБРАТЬ РАЗЛИЧНЫЕ
	|	СпрНоменклатура.Ссылка КАК Номенклатура
	|ИЗ
	|	Справочник.Номенклатура КАК СпрНоменклатура
	|ГДЕ
	|	СпрНоменклатура.Ссылка В (&СписокНоменклатуры)
	|
	|ОБЪЕДИНИТЬ
	|
	|ВЫБРАТЬ РАЗЛИЧНЫЕ
	//---АК SHEP 2018.05.23
	|	АналогиНоменклатурыТовары.Номенклатура
	|ИЗ
	|	Справочник.АналогиНоменклатуры.Товары КАК АналогиНоменклатурыТовары
	|ГДЕ
	|	АналогиНоменклатурыТовары.Ссылка В
	|			(ВЫБРАТЬ
	|				АналогиНоменклатурыТовары.Ссылка
	|			ИЗ
	|				Справочник.АналогиНоменклатуры.Товары КАК АналогиНоменклатурыТовары
	|			ГДЕ
	|				АналогиНоменклатурыТовары.Номенклатура В (&СписокНоменклатуры)
	|				И НЕ АналогиНоменклатурыТовары.Ссылка.ПометкаУдаления
	|				И АналогиНоменклатурыТовары.Ссылка.ПолностьюЗаменяемыйТовар)
	|	И НЕ АналогиНоменклатурыТовары.Номенклатура.ПометкаУдаления");
	Запрос.УстановитьПараметр("СписокНоменклатуры", СписокНоменклатуры);
	Результат = Новый СписокЗначений;
	Результат.ЗагрузитьЗначения(Запрос.Выполнить().Выгрузить().ВыгрузитьКолонку("Номенклатура"));
	Возврат Результат;
	
КонецФункции
//--- GOLV
