﻿
&НаКлиенте
Процедура ОбработкаКоманды(ПараметрКоманды, ПараметрыВыполненияКоманды)
	Табдок = Новый ТабличныйДокумент;
	СформироватьСписокВопросовСервер(ТабДок);
	ТабДок.Показать("Проект вопросов продавца",);
	//Вставить содержимое обработчика.
	//ПараметрыФормы = Новый Структура("", );
	//ОткрытьФорму("Справочник.ОпросникДляЭкзаменацииПродавца.ФормаСписка", ПараметрыФормы, ПараметрыВыполненияКоманды.Источник, ПараметрыВыполненияКоманды.Уникальность, ПараметрыВыполненияКоманды.Окно, ПараметрыВыполненияКоманды.НавигационнаяСсылка);
КонецПроцедуры

&НаСервере
Процедура СформироватьСписокВопросовСервер(ТабДок)
	ДанныеРасшифровки = Новый ДанныеРасшифровкиКомпоновкиДанных;
	КомпоновщикМакета = Новый КомпоновщикМакетаКомпоновкиДанных;
	
	СКД=Справочники.ОпросникДляЭкзаменацииПродавца.ПолучитьМакет("МакетВыводаВопросовНаПечать");
	//СКД.Параметры.Заявка.Значение = ЭтотОбъект.ЗаявкаНаРасходованиеСредств;
	//СКД.Параметры.Ссылка.Значение = ЭтотОбъект.Ссылка;
	НастройкиСКД = СКД.НастройкиПоУмолчанию;
	
	Для Каждого Эл Из НастройкиСКД.Отбор.Элементы Цикл
		Если СокрЛП(Эл.ЛевоеЗначение) = "Должность" Тогда
			Эл.Использование = Истина;
			Эл.ПравоеЗначение = Справочники.ДолжностиОрганизаций.НайтиПоНаименованию("Продавец-консультант");
		ИначеЕсли СокрЛП(Эл.ЛевоеЗначение)="Проект" Тогда
			Эл.Использование = Истина;
			Эл.ПравоеЗначение = Истина;
		КонецЕсли;	
	КонецЦикла;	
	
	
	МакетКомпоновки = КомпоновщикМакета.Выполнить(СКД, НастройкиСКД, ДанныеРасшифровки);
	
	ПроцессорКомпоновкиДанных = Новый ПроцессорКомпоновкиДанных;
	ПроцессорКомпоновкиДанных.Инициализировать(МакетКомпоновки, ,ДанныеРасшифровки);
	
	ПроцессорВывода = Новый ПроцессорВыводаРезультатаКомпоновкиДанныхВТабличныйДокумент;
	ПроцессорВывода.УстановитьДокумент(ТабДок);
	ПроцессорВывода.Вывести(ПроцессорКомпоновкиДанных);
	
КонецПроцедуры	