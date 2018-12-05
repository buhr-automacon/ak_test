﻿
&НаКлиенте
Процедура ТаблицаФайловПриНачалеРедактирования(Элемент, НоваяСтрока, Копирование)
	
	Если НоваяСтрока Тогда
		ТекДанные = Элементы.ТаблицаФайлов.ТекущиеДанные;
		ТекДанные.ЭтоНовыйФайл 	= Истина;
		ТекДанные.Идентификатор = Строка(Новый УникальныйИдентификатор());
		ТекДанные.ЭтоОтветПроизводителя = Ложь; //+++АК SHEP 2018.07.26 ИП-00018753.03: добавляем как не файл производителя
	КонецЕсли;	
	
КонецПроцедуры

&НаКлиенте
Процедура ТаблицаФайловИмяФайлаНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	//+++АК SHEP 2018.07.26 ИП-00018753.03: файлы производителей не удаляем
	ТекущиеДанные = Элементы.ТаблицаФайлов.ТекущиеДанные;
	Если ТекущиеДанные <> Неопределено И ТекущиеДанные.ЭтоОтветПроизводителя Тогда
		СтандартнаяОбработка = Ложь;
		Возврат;
	КонецЕсли;
	//---АК SHEP 2018.07.26
	
	ДиалогВыбора = Новый ДиалогВыбораФайла(РежимДиалогаВыбораФайла.Открытие);
	Если ДиалогВыбора.Выбрать() Тогда
		ТекДанные = Элементы.ТаблицаФайлов.ТекущиеДанные;
		ТекДанные.Идентификатор 			= Строка(Новый УникальныйИдентификатор());
		ТекДанные.ЭтоНовыйФайл 				= Истина;
		ТекДанные.ПолныйПутьКНовомуФайлу 	= ДиалогВыбора.ПолноеИмяФайла;
		ФайлВыбранный = Новый Файл(ДиалогВыбора.ПолноеИмяФайла);
		ТекДанные.ИмяФайла 					= ФайлВыбранный.Имя;
		ТекДанные.Расширение 				= ФайлВыбранный.Расширение;
	КонецЕсли;	
	
КонецПроцедуры

&НаСервере
Функция ПолучитьАдресФайлаССервера(ИмяФайла)
	
	//+++АК SHEP 2018.04.02 ИП-00017032
	//УстановитьПривилегированныйРежим(Истина);
	//КаталогФайлов = Константы.КаталогХраненияФайловКартинок.Получить();
	//
	//Если Прав(КаталогФайлов, 1) <> "\" Тогда
	//	КаталогФайлов = КаталогФайлов + "\";
	//КонецЕсли;	
	//
	//КаталогФайлов = КаталогФайлов + "ОбращенияПокупателей\";
	КаталогФайлов = РегистрыСведений.ОбращенияПокупателей.ПолучитьКаталогХраненияФайлов();
	//---АК SHEP 2018.04.02
	
	Возврат ПоместитьВоВременноеХранилище(Новый ДвоичныеДанные(КаталогФайлов + ИмяФайла));
	
КонецФункции	

&НаКлиенте
Процедура ТаблицаФайловИмяФайлаОткрытие(Элемент, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	ТекДанные = Элементы.ТаблицаФайлов.ТекущиеДанные;
	Если ТекДанные.ЭтоНовыйФайл
			И ЗначениеЗаполнено(ТекДанные.ПолныйПутьКНовомуФайлу) Тогда
		ЗапуститьПриложение(ТекДанные.ПолныйПутьКНовомуФайлу);
	Иначе
		ДвДанные = ПолучитьИзВременногоХранилища(ПолучитьАдресФайлаССервера(Формат(ТекДанные.ДатаДобавления, "ДФ=yyyyMM") + "\" +
					ТекДанные.Идентификатор	+ ТекДанные.Расширение));
		ВрРасширение = ?(ЗначениеЗаполнено(ТекДанные.Расширение), ТекДанные.Расширение, ".jpg");
		ИмяВрФайла = ПолучитьИмяВременногоФайла(ВрРасширение);
		ДвДанные.Записать(ИмяВрФайла);
		ЗапуститьПриложение(ИмяВрФайла);
	КонецЕсли;	
	
КонецПроцедуры

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если ЗначениеЗаполнено(Параметры.ТабФайлов) Тогда
		ТабДанные = ЗначениеИзСтрокиВнутр(Параметры.ТабФайлов);
		
		//+++АК SHEP 2018.08.06 ИП-00018753.03
		Если Параметры.Свойство("ЭтоОтветПроизводителя") Тогда
			ТабДанные = РегистрыСведений.ОбращенияПокупателейОтветыПроизводителейНаВключения.ВернутьТЗнПрикреплённыхФайлов(Параметры.ТабФайлов);
			ТабДанные.ЗаполнитьЗначения(Параметры.ЭтоОтветПроизводителя, "ЭтоОтветПроизводителя");
		КонецЕсли;
		//---АК SHEP 2018.08.06

		Для Каждого СтрокаТаб Из ТабДанные Цикл
			СтрокаДоб = ТаблицаФайлов.Добавить();
			//+++АК SHEP 2018.08.06 ИП-00018753.03
			//СтрокаДоб.ИмяФайла 			= СтрокаТаб.ИмяФайла;
			//СтрокаДоб.Идентификатор 	= СтрокаТаб.Идентификатор;
			//СтрокаДоб.ДатаДобавления 	= СтрокаТаб.ДатаДобавления;
			//СтрокаДоб.Расширение 		= СтрокаТаб.Расширение;
			ЗаполнитьЗначенияСвойств(СтрокаДоб, СтрокаТаб);
			//---АК SHEP 2018.08.06
		КонецЦикла;	
	КонецЕсли;	
	
	//+++АК SHEP 2018.07.26 ИП-00018753.03
	ТабФайловОтветПроизводителя = "";
	Если Параметры.Свойство("ТабФайловОтветПроизводителя", ТабФайловОтветПроизводителя) И ЗначениеЗаполнено(ТабФайловОтветПроизводителя) Тогда
		ТабДанные = ЗначениеИзСтрокиВнутр(ТабФайловОтветПроизводителя);
		Для Каждого СтрокаТаб Из ТабДанные Цикл
			СтрокаДоб = ТаблицаФайлов.Добавить();
			ЗаполнитьЗначенияСвойств(СтрокаДоб, СтрокаТаб);
			СтрокаДоб.ЭтоОтветПроизводителя = Истина;
			СтрокаДоб.ОтветПроизводителяНаВключения = Истина;
		КонецЦикла;
		Элементы.ТаблицаФайловЭтоОтветПроизводителя.Видимость = Истина;
	КонецЕсли;
	//---АК SHEP 2018.07.26
	
КонецПроцедуры

&НаСервере
Функция ЗаписатьФайлыИПолучитьТаблицу()
	
	//+++АК SHEP 2018.04.02 ИП-00017032
	//УстановитьПривилегированныйРежим(Истина);
	//КаталогФайлов = Константы.КаталогХраненияФайловКартинок.Получить();
	//
	//Если Прав(КаталогФайлов, 1) <> "\" Тогда
	//	КаталогФайлов = КаталогФайлов + "\";
	//КонецЕсли;
	//
	//КаталогФайлов = КаталогФайлов + "ОбращенияПокупателей\";
	КаталогФайлов = РегистрыСведений.ОбращенияПокупателей.ПолучитьКаталогХраненияФайлов();
	//---АК SHEP 2018.04.02
	
	Для Каждого СтрокаТаб Из ТаблицаФайлов Цикл
		Если СтрокаТаб.ЭтоНовыйФайл
				И ЗначениеЗаполнено(СтрокаТаб.ПолныйПутьКНовомуФайлу)
				И ЗначениеЗаполнено(СтрокаТаб.СсылкаНаВременноеХранилище) Тогда
			СтрокаТаб.ДатаДобавления = ТекущаяДата();
			СоздатьКаталог(КаталогФайлов + Формат(СтрокаТаб.ДатаДобавления, "ДФ=yyyyMM"));
			ДвДанные = ПолучитьИзВременногоХранилища(СтрокаТаб.СсылкаНаВременноеХранилище);
			ДвДанные.Записать(КаталогФайлов + Формат(СтрокаТаб.ДатаДобавления, "ДФ=yyyyMM") + "\" + СтрокаТаб.Идентификатор + СтрокаТаб.Расширение);
			УдалитьИзВременногоХранилища(СтрокаТаб.СсылкаНаВременноеХранилище);
		КонецЕсли;	
	КонецЦикла;
	
	//
	//+++АК SHEP 2018.07.26 ИП-00018753.03: добавил отбор по ответу производителя, остальное было
	МассивСтрокКВозврату = ТаблицаФайлов.НайтиСтроки(Новый Структура("ЭтоОтветПроизводителя", Ложь));
	Если МассивСтрокКВозврату.Количество() > 0 Тогда
		
		//+++АК SHEP 2018.08.06 ИП-00018753.03
		//ТабКВозврату = Новый ТаблицаЗначений;
		//ТабКВозврату.Колонки.Добавить("ИмяФайла");
		//ТабКВозврату.Колонки.Добавить("Идентификатор");
		//ТабКВозврату.Колонки.Добавить("ДатаДобавления");
		//ТабКВозврату.Колонки.Добавить("Расширение");
		//
		//Для Каждого СтрокаТаб Из МассивСтрокКВозврату Цикл
		//	СтрокаДоб = ТабКВозврату.Добавить();
		//	СтрокаДоб.ИмяФайла 			= СтрокаТаб.ИмяФайла;
		//	СтрокаДоб.Идентификатор 	= СтрокаТаб.Идентификатор;
		//	СтрокаДоб.ДатаДобавления 	= СтрокаТаб.ДатаДобавления;
		//	СтрокаДоб.Расширение 		= СтрокаТаб.Расширение;
		//КонецЦикла;
		
		ТабКВозврату = РегистрыСведений.ОбращенияПокупателейОтветыПроизводителейНаВключения.СоздатьТЗнПрикреплённыхФайлов();
		Для Каждого СтрокаТаб Из МассивСтрокКВозврату Цикл
			СтрокаДоб = ТабКВозврату.Добавить();
			ЗаполнитьЗначенияСвойств(СтрокаДоб, СтрокаТаб);
		КонецЦикла;
		//---АК SHEP 2018.08.06
		
	Иначе
		Возврат "";
	КонецЕсли; //---АК SHEP 2018.07.26
	
	//
	Возврат ЗначениеВСтрокуВнутр(ТабКВозврату);
		
КонецФункции	

&НаКлиенте
Процедура ЗаписатьИЗакрыть(Команда)
	
	Для Каждого СтрокаТаб Из ТаблицаФайлов Цикл
		Если СтрокаТаб.ЭтоНовыйФайл
				И ЗначениеЗаполнено(СтрокаТаб.ПолныйПутьКНовомуФайлу) Тогда
			СтрокаТаб.СсылкаНаВременноеХранилище = ПоместитьВоВременноеХранилище(Новый ДвоичныеДанные(СтрокаТаб.ПолныйПутьКНовомуФайлу));
		КонецЕсли;	
	КонецЦикла;
	
	СтрокаТаблица = ЗаписатьФайлыИПолучитьТаблицу();
	
	//
	Закрыть(СтрокаТаблица);
	
КонецПроцедуры

//+++АК SHEP 2018.07.26 ИП-00018753.03: файлы производителей не удаляем
&НаКлиенте
Процедура ТаблицаФайловПередУдалением(Элемент, Отказ)
	
	ТекущиеДанные = Элемент.ТекущиеДанные;
	Если ТекущиеДанные = Неопределено ИЛИ ТекущиеДанные.ЭтоОтветПроизводителя Тогда Отказ = Истина; КонецЕсли;
	
КонецПроцедуры

//+++АК SHEP 2018.07.26 ИП-00018753.03: файлы производителей не переименовываем
&НаКлиенте
Процедура ТаблицаФайловИмяФайлаОкончаниеВводаТекста(Элемент, Текст, ДанныеВыбора, ПараметрыПолученияДанных, СтандартнаяОбработка)
	
	ТекущиеДанные = Элементы.ТаблицаФайлов.ТекущиеДанные;
	Если ТекущиеДанные <> Неопределено И ТекущиеДанные.ЭтоОтветПроизводителя Тогда
		СтандартнаяОбработка = Ложь;
		Элементы.ТаблицаФайлов.ЗакончитьРедактированиеСтроки(Истина);
	КонецЕсли;
	
КонецПроцедуры
