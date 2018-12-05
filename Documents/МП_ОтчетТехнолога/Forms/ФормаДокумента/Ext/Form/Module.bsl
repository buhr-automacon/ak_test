﻿
&НаКлиенте
Процедура ПараметрыЗадачиПриАктивизацииСтроки(Элемент)
	
	ТекущиеДанные = Элементы.ПараметрыЗадачи.ТекущиеДанные;
	
	Если ТекущиеДанные <> Неопределено Тогда
		ОбновитьHTML(ТекущиеДанные.Параметр);
		
		Элементы.ГруппаТекущийПараметр.Заголовок = ТекущиеДанные.Параметр;
	КонецЕсли
	
КонецПроцедуры

&НаСервере
Процедура ОбновитьHTML(ПараметрЗадачи)
	
	ТаблицаКартинок.Очистить();
	
	// 
	КаталогФотографий = СокрЛП(Константы.МП_КаталогХраненияФайловЗадачМП.Получить());

	Если Прав(КаталогФотографий, 1) <> "\" Тогда
		КаталогФотографий = КаталогФотографий + "\";
	КонецЕсли;

    СтрокиПараметра = Объект.Фотографии.НайтиСтроки(Новый Структура("Параметр",  ПараметрЗадачи));
	
	Для Каждого СтрокаПараметра ИЗ СтрокиПараметра Цикл
	
		Файл = Новый Файл(КаталогФотографий+СтрокаПараметра.ОтносительноеИмяФайла);
		
		Если ПустаяСтрока(СтрокаПараметра.ОтносительноеИмяФайла) Тогда
			Продолжить;
		КонецЕсли;

		Попытка 
			Если  НЕ Файл.Существует() Тогда
				Продолжить;
			КонецЕсли;

		Исключение
						
		КонецПопытки; 

		Если НЕ Файл.Существует() Тогда 
		Иначе
			НоваяСтрока = ТаблицаКартинок.Добавить();
			НоваяСтрока.ИмяФайла = КаталогФотографий+СтрокаПараметра.ОтносительноеИмяФайла;
		КонецЕсли;	
	КонецЦикла;
	
	//
	ФотографииHTML = ПолучитьHTMLПоТаблицеКартинок();

КонецПроцедуры

&НаСервере
Функция ПолучитьHTMLПоТаблицеКартинок()

	КартинокВСтроке = 4;

	ПолныйТекстHTML = "
		|<html><body>
		|<table name = ""PictView"">";

	Для НомерСтроки = 1 По ОбщегоНазначения.ЦелМаксимальное(ТаблицаКартинок.Количество()/КартинокВСтроке) Цикл
		ПолныйТекстHTML = ПолныйТекстHTML + "
			|<tr>";
		Для НомерКолонки = 1 По КартинокВСтроке Цикл
			ИндексСтрокиКартики = (НомерСтроки-1) * КартинокВСтроке + НомерКолонки - 1;
			Если ИндексСтрокиКартики = ТаблицаКартинок.Количество() Тогда
				Прервать;
			КонецЕсли; 
			ИмяФайла = ТаблицаКартинок[ИндексСтрокиКартики].ИмяФайла;
			ПолныйТекстHTML = ПолныйТекстHTML+ "
			|<td><table id=""" + ИндексСтрокиКартики + "_T" + """ border=""2"" cellpadding=""0"" bordercolor=#ffffff cellspacing=""0""><tr><td><img name=""picture"" width = 125 height=125 style = ""cursor: pointer"" id = """  + ИндексСтрокиКартики  + """ src = ""file:///" + СтрЗаменить(ИмяФайла, "\", "/") + """></td></tr></table></td>";
		КонецЦикла;	
		ПолныйТекстHTML = ПолныйТекстHTML + "
			|</tr>";
	КонецЦикла;	

	ПолныйТекстHTML = ПолныйТекстHTML + "</body></html>";

	Возврат ПолныйТекстHTML;

КонецФункции

&НаКлиенте
Процедура HTMLПриНажатии(Элемент, ДанныеСобытия, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;

	Попытка 
		
		Если ДанныеСобытия.Element.name = "picture" Тогда
			ИндексСтроки = Число(ДанныеСобытия.Element.id);

			Картинка = Новый Картинка(ТаблицаКартинок[ИндексСтроки].ИмяФайла);
			АдресКартинки = ПоместитьВоВременноеХранилище(Картинка, УникальныйИдентификатор);
			ПараметрыФормы = Новый Структура("КартинкаСсылка", АдресКартинки); 
			
			ОткрытьФорму("ОбщаяФорма.Фото", ПараметрыФормы);
		КонецЕсли;

	Исключение
	КонецПопытки; 
	
КонецПроцедуры

&НаСервере
Процедура УстановитьВидимость()
	
	//Элементы.ДокументОснование.Видимость = (Объект.Задача.ВидПроверяемойОперации = Перечисления.ВидыОперацийПроверяемыхТехнологом.Поставка);
	
КонецПроцедуры 

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	УстановитьВидимость();
	
	//+++АК sils 08.06.2018 ИП-00018876
	APDEX_ОценкаПроизводительностиКлиентСервер.ЗакончитьЗамерВремени(ОперацияАпдекс, ?(Параметры.Ключ.Пустая(), "Новый документ", "" + Объект.Ссылка));
	//---АК
КонецПроцедуры

//+++АК sils 08.06.2018 ИП-00018876
&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	ОперацияАпдекс = APDEX_ОценкаПроизводительностиКлиентСервер.ПолучитьОперацию("Открытие документа Отчет технолога");
	APDEX_ОценкаПроизводительностиКлиентСервер.НачатьЗамерВремени(ОперацияАпдекс);
КонецПроцедуры
