﻿
&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Объект.access_token = РаботаССайтомВКонтакте.access_tokenПолучить();
	Объект.owner_id = РаботаССайтомВКонтакте.ПолучитьЗначениеПараметра("owner_id");
	Объект.domain = РаботаССайтомВКонтакте.ПолучитьЗначениеПараметра("domain");
	
КонецПроцедуры

&НаКлиенте
Процедура ВыбратьФайл(Команда)
	
	Диалог = Новый ДиалогВыбораФайла(РежимДиалогаВыбораФайла.Открытие);
	Если Диалог.Выбрать() Тогда
		Объект.file_name = Диалог.ПолноеИмяФайла;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПрочитатьЗаписи(Команда)
	
	Попытка
		
		МассивКомментариев = РаботаССайтомВКонтакте.ПрочитатьЗаписиСоСтены(Объект.access_token, Объект.owner_id, Объект.domain,, Объект.count, Объект.filter,
			?(extended, "1", ""), ?(extended, fields, "")); // дополнительные поля
		
		Профили = Новый Соответствие;
		Если ТипЗнч(МассивКомментариев) = Тип("Структура") Тогда
			Профили = МассивКомментариев.Профили;
			МассивКомментариев = МассивКомментариев.Комментарии;
		КонецЕсли;
		
		Объект.Комментарии.Очистить();
		Если МассивКомментариев.Количество() > 0 Тогда
			ЗаполнитьКомментарииНаСервере(МассивКомментариев, Профили);
		КонецЕсли;
		
	Исключение
		Сообщить("Ошибка чтения записей со стены: " + ОписаниеОшибки());
	КонецПопытки;
	
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьКомментарииНаСервере(МассивКомментариев, Профили)
	
	// создаём реквизиты
	ДобавляемыеРеквизиты = Новый Массив;
	СтруктураРеквизитов = МассивКомментариев[0];
	Для Каждого КлючИЗначение Из СтруктураРеквизитов Цикл
		ТипДобавляемогоЗначения = ?(КлючИЗначение.Значение = Неопределено, "Строка", Строка(ТипЗнч(КлючИЗначение.Значение)));
		Если КлючИЗначение.Ключ = "date" Тогда ТипДобавляемогоЗначения = "Дата"; КонецЕсли;
		ДобавляемыеРеквизиты.Добавить(Новый РеквизитФормы(КлючИЗначение.Ключ, Новый ОписаниеТипов(ТипДобавляемогоЗначения), "Объект.Комментарии"));
	КонецЦикла;
	
	// пакетное создание и удаление
	Попытка
		ИзменитьРеквизиты(ДобавляемыеРеквизиты);
		
		// создаём элементы
		Для Каждого КлючИЗначение Из СтруктураРеквизитов Цикл
			Элемент = Элементы.Добавить(КлючИЗначение.Ключ, Тип("ПолеФормы"), Элементы.Комментарии); 
			Элемент.Вид = ВидПоляФормы.ПолеВвода;
			Элемент.ПутьКДанным = "Объект.Комментарии." + КлючИЗначение.Ключ;
		КонецЦикла;
	Исключение КонецПопытки;
	
	Для Каждого СтруктураКомментарий Из МассивКомментариев Цикл
		НоваяСтрокаТЧ = Объект.Комментарии.Добавить();
		ЗаполнитьЗначенияСвойств(НоваяСтрокаТЧ, СтруктураКомментарий);
		Если СтруктураКомментарий.Свойство("date") Тогда
			НоваяСтрокаТЧ.date = МестноеВремя(РаботаСВнешнимВебСервером.ПолучитьДатуВремяИзUnixTime(СтруктураКомментарий.date));
		КонецЕсли;
	КонецЦикла;
	
КонецПроцедуры

&НаКлиенте
Процедура ЗаписатьОбращения(Команда)
	
	ЗаписатьОбращенияНаСервере();
	
КонецПроцедуры

&НаСервере
Процедура ЗаписатьОбращенияНаСервере()
	
	ИсточникОбращения = Справочники.ИсточникиОбращений.ВКонтакте;
	СсылкаНаСайт = "https://vk.com/" + Объект.domain + "?w=wall" + Объект.owner_id + "_";
	СмещениеВЧасах = РаботаССайтомВКонтакте.ПолучитьЗначениеПараметра("СмещениеВЧасах");
	СмещениеВСекундах = ?(СмещениеВЧасах = Неопределено, Неопределено, СмещениеВЧасах * 3600);
	
	ПоследняяЗаписьСоСтены = РаботаССайтомВКонтакте.ПолучитьЗначениеПараметра("ПоследняяЗаписьСоСтены");
	ПоследняяЗаписьСоСтены = ?(ТипЗнч(ПоследняяЗаписьСоСтены) = Тип("Число"), ПоследняяЗаписьСоСтены, 0);
	
	Попытка
		МассивКомментариев = РаботаССайтомВКонтакте.ПрочитатьЗаписиСоСтены(Объект.access_token, Объект.owner_id, Объект.domain,, Объект.count, Объект.filter,
			?(extended, "1", ""), ?(extended, fields, "")); // дополнительные поля
		
		Профили = Новый Соответствие;
		Если ТипЗнч(МассивКомментариев) = Тип("Структура") Тогда
			Профили = МассивКомментариев.Профили;
			МассивКомментариев = МассивКомментариев.Комментарии;
		КонецЕсли;
		
		// считываем записи с конца
		КвоЗаписей = МассивКомментариев.ВГраница();
		Если КвоЗаписей = -1 Тогда Возврат; КонецЕсли;
		
		Для Сч = 0 По КвоЗаписей Цикл
			
			СтруктураКомментарий = МассивКомментариев[КвоЗаписей - Сч];
			НомерЗаписиСоСтены = Число(СтруктураКомментарий.id);
			Если НомерЗаписиСоСтены <= ПоследняяЗаписьСоСтены Тогда Продолжить; КонецЕсли;
			
			Запись = РегистрыСведений.ОбращенияПокупателей.СоздатьМенеджерЗаписи();
			Запись.GUID_Загрузки = Новый УникальныйИдентификатор();
			Запись.ДатаДок = РаботаСВнешнимВебСервером.ПолучитьДатуВремяИзUnixTime(СтруктураКомментарий.date);
			Запись.ДатаДок = ?(СмещениеВСекундах = Неопределено, МестноеВремя(Запись.ДатаДок), Запись.ДатаДок + СмещениеВСекундах);
			Запись.ИсточникОбращения = ИсточникОбращения;
			
			Запись.Примечание = СокрЛП(СтрЗаменить(СтруктураКомментарий.text, "<br>", Символы.ПС));
			Запись.СсылкаНаСайт = СсылкаНаСайт + СтруктураКомментарий.id + "&from_id=" + СтруктураКомментарий.from_id;
			
			ФИО_Покупателя = Профили.Получить(СтруктураКомментарий.from_id);
			Если ФИО_Покупателя <> Неопределено Тогда
				Запись.ФИО_Покупателя = ФИО_Покупателя;
			КонецЕсли;
			
			Запись.id_OK = РегистрыСведений.ОбращенияПокупателей.ПолучитьСледующийid_OK();
			Запись.Записать();
			
			РаботаССайтомВКонтакте.УстановитьЗначениеПараметра("ПоследняяЗаписьСоСтены", НомерЗаписиСоСтены);
			
		КонецЦикла;
		
	Исключение
		Сообщить("Ошибка чтения записей со стены: " + ОписаниеОшибки());
	КонецПопытки;
	
КонецПроцедуры
