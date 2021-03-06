﻿
#Область ОбработчикиСобытийФормы

//+++АК LATV 2018.09.07 ИП-00019662
&НаКлиенте
Процедура ПриОткрытии(Отказ)

	#Если Не ТолстыйКлиентОбычноеПриложение Тогда
		
		// Для тех кто запускается не в режиме обычного приложения, должны быть доступны роли полные права или финансист.
		Если Не РольДоступнаСервер("ПолныеПрава")
		   И Не РольДоступнаСервер("Финансист") Тогда
			ПоказатьПредупреждение(, НСтр("ru = 'Недостаточно прав!'"), 30);
			Отказ = Истина;
			Возврат;
		КонецЕсли;
		
		//Убрать видимость лишних колонок.
		Для Каждого КолонкаСписка Из Элементы.Список.ПодчиненныеЭлементы Цикл
			Если КолонкаСписка.Имя <> "Наименование" И КолонкаСписка.Имя <> "Код" Тогда
				КолонкаСписка.Видимость = Ложь;
			КонецЕсли;
		КонецЦикла;
		
		//Убрать видимость лишних кнопок.
		Элементы.ФормаФормированиеЗаявок.Видимость = Ложь;
		
	#КонецЕсли

КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийКомандФормы

//+++АК LATV 2018.09.08 ИП-00019662
&НаКлиенте
Процедура ФормированиеЗаявок(Команда)

	ПараметрыФормы = Новый Структура();
	ПараметрыФормы.Вставить("ВыбранныеЭлементы", ОтображаемыеЭлементыСписка());
	
	ОткрытьФорму("Справочник.АК_Размен.Форма.ФормаФормированияЗаявок", ПараметрыФормы, ЭтаФорма
		,,,,, РежимОткрытияОкнаФормы.БлокироватьОкноВладельца);

КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

//+++АК LATV 2018.09.07 ИП-00019662
&НаСервереБезКонтекста
Функция РольДоступнаСервер(Роль)
	Возврат РольДоступна(Роль);
КонецФункции

//+++АК LATV 2018.09.07 ИП-00019662
&НаСервере
Функция ОтображаемыеЭлементыСписка()

	Схема		= Элементы.Список.ПолучитьИсполняемуюСхемуКомпоновкиДанных();
	Настройки	= Элементы.Список.ПолучитьИсполняемыеНастройкиКомпоновкиДанных();
	
	КомпоновщикМакета = Новый КомпоновщикМакетаКомпоновкиДанных();
	МакетКомпоновки = КомпоновщикМакета.Выполнить(Схема, Настройки,,, Тип("ГенераторМакетаКомпоновкиДанныхДляКоллекцииЗначений"));
	
	ПроцессорКомпоновки = Новый ПроцессорКомпоновкиДанных;
	ПроцессорКомпоновки.Инициализировать(МакетКомпоновки);
	
	ПроцессорВывода = Новый ПроцессорВыводаРезультатаКомпоновкиДанныхВКоллекциюЗначений;
	
	ВременнаяТЗ = Новый ТаблицаЗначений;
	ПроцессорВывода.УстановитьОбъект(ВременнаяТЗ);
	ПроцессорВывода.Вывести(ПроцессорКомпоновки);
	
	ВыбранныеЭлементы = ВременнаяТЗ.ВыгрузитьКолонку("Ссылка");
	Возврат ВыбранныеЭлементы;

КонецФункции

#КонецОбласти
