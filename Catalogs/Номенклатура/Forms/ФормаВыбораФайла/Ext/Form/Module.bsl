﻿
&НаКлиенте
Процедура ИмяФайлаНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	ДиалогФайла = Новый ДиалогВыбораФайла(РежимДиалогаВыбораФайла.Открытие);
	ДиалогФайла.МножественныйВыбор = Ложь;
	//ДиалогФайла.Фильтр = "(*.jpg;*.jpeg;*.gif;*.tif;*.png)|*.jpg;*.jpeg;*.gif;*.tif;*.png";
	ДиалогФайла.ПроверятьСуществованиеФайла = Истина;
	Если ДиалогФайла.Выбрать() Тогда
		//ХранилищеКартинки = Новый ХранилищеЗначения(ДиалогФайла.ПолноеИмяФайла);
		БылВыборФайла = Истина;
		ИмяФайла = ДиалогФайла.ПолноеИмяФайла;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура Принять(Команда)
	
	Закрыть(Новый Структура("ТЗ_ИмяФайла, БылВыборФайла", ТаблицаФайлов, БылВыборФайла));
	
КонецПроцедуры

&НаКлиенте
Процедура ТаблицаФайловИмяФайловНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	ТекущиеДанные = Элементы.ТаблицаФайлов.ТекущиеДанные;
	ДиалогФайла = Новый ДиалогВыбораФайла(РежимДиалогаВыбораФайла.Открытие);
	ДиалогФайла.МножественныйВыбор = Ложь;
	//ДиалогФайла.Фильтр = "(*.jpg;*.jpeg;*.gif;*.tif;*.png)|*.jpg;*.jpeg;*.gif;*.tif;*.png";
	ДиалогФайла.ПроверятьСуществованиеФайла = Истина;
	Если ДиалогФайла.Выбрать() Тогда
		//ХранилищеКартинки = Новый ХранилищеЗначения(ДиалогФайла.ПолноеИмяФайла);
		
		ПолноеИмяФайла = ДиалогФайла.ПолноеИмяФайла;
		
		БылВыборФайла = Истина;
		ВыбранныйФайл = Новый Файл(ПолноеИмяФайла);
		//Если ВыбранныйФайл.Размер() > 1048576 Тогда
		//	Сообщить("Размер файла превышает допустимое значение 1мб(1024 кб)! Необходимо отсканировать сертификат в более низком качестве!", СтатусСообщения.Важное);
		//	Возврат;
		//КонецЕсли;	
		
		//ДМ глючит ужасно, отключил код
		
		//Если ВыбранныйФайл.Размер() > 524288 Тогда
		//	
		//	// Попытаемся сжать
		//	Попытка
		//		
		//		пПрограмма = """C:\Program Files\FileOptimizer\FileOptimizer64.exe"" ""пИмяФайла""";	
		//		пПрограмма = СтрЗаменить(пПрограмма, "пИмяФайла", ПолноеИмяФайла);
		//	
		//		ЗапуститьПриложение(пПрограмма,, Истина);
		//		
		//		ВыбранныйФайл = Новый Файл(ПолноеИмяФайла);
		//		Если ВыбранныйФайл.Размер() > 524288 Тогда
		//			Сообщить("Размер файла превышает допустимое значение 512 кб! Необходимо отсканировать сертификат в более низком качестве!", СтатусСообщения.Важное);
		//			Возврат;
		//		КонецЕсли;	
		//		
		//	Исключение 
		//		
		//		Сообщить("Размер файла превышает допустимое значение 512 кб! Необходимо отсканировать сертификат в более низком качестве!", СтатусСообщения.Важное);
		//		Возврат;
		//		
		//	КонецПопытки;
		//		
		//КонецЕсли;
		
		//
		СтандартнаяОбработка = Ложь;
		
		//
		ДанныеВыбора = ПолноеИмяФайла;
		ТекущиеДанные.ИмяФайла = ПолноеИмяФайла;
		
	КонецЕсли;	
	
КонецПроцедуры
