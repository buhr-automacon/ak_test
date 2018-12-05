﻿
// Проверяет на наличие уже созданных в заданный день документов "Маршрутный лист" (доставка на ТТ).
//
// Возврат:
//   Массив ссылок на документы.
//
Функция ПолучитьСозданныеДокументыСервер()
	
	Перем ОбъектОбработки, МассивСсылок;
	
	ОбъектОбработки = РеквизитФормыВЗначение("Объект");
	МассивСсылок = ОбъектОбработки.ПолучитьСозданныеДокументы();
	ЗначениеВРеквизитФормы(ОбъектОбработки, "Объект");
	
	Возврат МассивСсылок;
	
КонецФункции

// Удаляет документы, полученные в результате запроса.
//
// Параметры:
// 	 МассивСсылок - Массив ссылок на документы.
//
Процедура УдалитьСуществующиеДокументыСервер(МассивСсылок)
	
	Перем ОбъектОбработки;
	
	ОбъектОбработки = РеквизитФормыВЗначение("Объект");
	ОбъектОбработки.УдалитьСуществующиеДокументы(МассивСсылок);
	ЗначениеВРеквизитФормы(ОбъектОбработки, "Объект");
	
КонецПроцедуры

Процедура СоздатьДокументыСервер()
	
	Перем ОбъектОбработки;
	
	// создание новых документов "Маршрутный лист" (доставка на ТТ)
	ОбъектОбработки = РеквизитФормыВЗначение("Объект");
	ОбъектОбработки.СоздатьДокументы();
	ЗначениеВРеквизитФормы(ОбъектОбработки, "Объект");
	
КонецПроцедуры


&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)

	Объект.ДатаСоздания = ТекущаяДата();
	
	//+++АК sole 2018.06.27 ИП-00018321.05
	Объект.ПричинаПеревозки = Перечисления.ПричиныПеревозки.ОсновнаяПоставка;
	//---АК sole 2018.06.27 ИП-00018321.05
КонецПроцедуры


&НаКлиенте
Процедура СоздатьДокументы(Команда)
	
	Перем МассивСсылок;
		
	// проверка на существование документов "Маршрутный лист" (доставка на ТТ) в этот день. Если существуют - удалять совсем.
	МассивСсылок = ПолучитьСозданныеДокументыСервер();
	Если МассивСсылок.Количество() > 0 Тогда
		Если Вопрос("В указанную дату есть созданные документы ""Рейс"" (доставка на ТТ). Пометить на удаление?", РежимДиалогаВопрос.ДаНет) = КодВозвратаДиалога.Нет Тогда
			Возврат;
		КонецЕсли;
		
		УдалитьСуществующиеДокументыСервер(МассивСсылок);
	КонецЕсли;
		
	// создание новых документов "Маршрутный лист" (доставка на ТТ)
	СоздатьДокументыСервер();
		
КонецПроцедуры
