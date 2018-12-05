﻿
#Область ОбработчикиСобытийФормы

//+++АК LATV 2018.08.09 ИП-00019120
&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)

	ЗаполнитьНаСервере();

КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормы_Открытки

//+++АК LATV 2018.08.09 ИП-00019120
&НаКлиенте
Процедура ОткрыткиИмяФайлаНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)

	СтандартнаяОбработка = Ложь;
	ПоказатьВыборФайла();

КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийКомандФормы

//+++АК LATV 2018.08.09 ИП-00019120
&НаКлиенте
Процедура Заполнить(Команда)

	ЗаполнитьНаСервере();

КонецПроцедуры

//+++АК LATV 2018.08.09 ИП-00019120
&НаКлиенте
Процедура СохранитьИзменения(Команда)

	СохранитьИзмененияНаКлиенте();

КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

//+++АК LATV 2018.08.09 ИП-00019120
&НаСервере
Процедура ЗаполнитьНаСервере()

	Открытки.Очистить();
	
	НоваяСтрока = Открытки.Добавить();
	НоваяСтрока.Наименование	= "Поздравление с днем рождения";
	НоваяСтрока.Открытка		= Справочники.Файлы.НайтиПоНаименованию(НоваяСтрока.Наименование, Истина);
	
	НоваяСтрока = Открытки.Добавить();
	НоваяСтрока.Наименование	= "Поздравление с 1 годовщиной";
	НоваяСтрока.Открытка		= Справочники.Файлы.НайтиПоНаименованию(НоваяСтрока.Наименование, Истина);
	
	НоваяСтрока = Открытки.Добавить();
	НоваяСтрока.Наименование	= "Поздравление с 2 годовщиной";
	НоваяСтрока.Открытка		= Справочники.Файлы.НайтиПоНаименованию(НоваяСтрока.Наименование, Истина);
	
	НоваяСтрока = Открытки.Добавить();
	НоваяСтрока.Наименование	= "Поздравление с 3 годовщиной";
	НоваяСтрока.Открытка		= Справочники.Файлы.НайтиПоНаименованию(НоваяСтрока.Наименование, Истина);
	
	НоваяСтрока = Открытки.Добавить();
	НоваяСтрока.Наименование	= "Поздравление с 4 годовщиной";
	НоваяСтрока.Открытка		= Справочники.Файлы.НайтиПоНаименованию(НоваяСтрока.Наименование, Истина);
	
	НоваяСтрока = Открытки.Добавить();
	НоваяСтрока.Наименование	= "Поздравление с 5 годовщиной";
	НоваяСтрока.Открытка		= Справочники.Файлы.НайтиПоНаименованию(НоваяСтрока.Наименование, Истина);
	
	НоваяСтрока = Открытки.Добавить();
	НоваяСтрока.Наименование	= "Поздравление с 6 годовщиной";
	НоваяСтрока.Открытка		= Справочники.Файлы.НайтиПоНаименованию(НоваяСтрока.Наименование, Истина);
	
	НоваяСтрока = Открытки.Добавить();
	НоваяСтрока.Наименование	= "Поздравление с 7 годовщиной";
	НоваяСтрока.Открытка		= Справочники.Файлы.НайтиПоНаименованию(НоваяСтрока.Наименование, Истина);
	
	НоваяСтрока = Открытки.Добавить();
	НоваяСтрока.Наименование	= "Поздравление с 8 годовщиной";
	НоваяСтрока.Открытка		= Справочники.Файлы.НайтиПоНаименованию(НоваяСтрока.Наименование, Истина);
	
	НоваяСтрока = Открытки.Добавить();
	НоваяСтрока.Наименование	= "Поздравление с 9 годовщиной";
	НоваяСтрока.Открытка		= Справочники.Файлы.НайтиПоНаименованию(НоваяСтрока.Наименование, Истина);
	
	//+++АК ILIK 2018.10.05 ИП-00019120.01
	НоваяСтрока = Открытки.Добавить();
	НоваяСтрока.Наименование	= "Поздравление при приеме на работу";
	НоваяСтрока.Открытка		= Справочники.Файлы.НайтиПоНаименованию(НоваяСтрока.Наименование, Истина);
	//---АК ILIK

КонецПроцедуры

//+++АК LATV 2018.08.09 ИП-00019120
&НаКлиенте
Процедура СохранитьИзмененияНаКлиенте()

	Для Каждого Открытка Из Открытки Цикл
		Если ПустаяСтрока(Открытка.ИмяФайла) Тогда
			Продолжить;
		КонецЕсли;
		
		Если ЗначениеЗаполнено(Открытка.Открытка) Тогда
			Хранение = ПоместитьВоВременноеХранилище(Новый ДвоичныеДанные(Открытка.ИмяФайла));
			ОбновитьФайлХранения(Открытка.Открытка, "jpg", Хранение);
		Иначе
			Хранение = ПоместитьВоВременноеХранилище(Новый ДвоичныеДанные(Открытка.ИмяФайла));
			Открытка.Открытка = СоздатьФайлХранения(Открытка.Наименование, "jpg", Хранение);
		КонецЕсли;
		
		Открытка.ИмяФайла = "";
		
	КонецЦикла;

КонецПроцедуры

//+++АК LATV 2018.08.09 ИП-00019120
&НаСервереБезКонтекста
Процедура ОбновитьФайлХранения(Файл, Расширение = "jpg", Хранение)

	СпрОбъект = Файл.ПолучитьОбъект();
	
	СпрОбъект.Расширение	= Расширение;
	СпрОбъект.ДополнительныеСвойства.Вставить("Хранилище"
		, Новый ХранилищеЗначения(ПолучитьИзВременногоХранилища(Хранение)));
	
	СпрОбъект.Записать();

КонецПроцедуры

//+++АК LATV 2018.08.09 ИП-00019120
&НаСервереБезКонтекста
Функция СоздатьФайлХранения(Наименование, Расширение = "jpg", Хранение)

	СпрОбъект = Справочники.Файлы.СоздатьЭлемент();
	
	СпрОбъект.Наименование	= Наименование;
	СпрОбъект.Расширение	= Расширение;
	СпрОбъект.ДополнительныеСвойства.Вставить("Хранилище"
		, Новый ХранилищеЗначения(ПолучитьИзВременногоХранилища(Хранение)));
	
	СпрОбъект.Записать();
	
	Возврат СпрОбъект.Ссылка;

КонецФункции

#Область ВыборФайла

&НаКлиенте
Процедура ПоказатьВыборФайла()

	ДиалогВыбораФайла = Новый ДиалогВыбораФайла(РежимДиалогаВыбораФайла.Открытие);
	ДиалогВыбораФайла.ПолноеИмяФайла	= Элементы.Открытки.ТекущиеДанные.ИмяФайла;
	ДиалогВыбораФайла.Фильтр			= "Файл открытки (*.jpg)|*.jpg";
	
	ОписаниеОповещения = Новый ОписаниеОповещения("ПоказатьВыборФайлаЗавершение", ЭтаФорма);
	ДиалогВыбораФайла.Показать(ОписаниеОповещения)

КонецПроцедуры

&НаКлиенте
Процедура ПоказатьВыборФайлаЗавершение(ВыбранныеФайлы, ДополнительныеПараметры) Экспорт

	Если ВыбранныеФайлы = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	Элементы.Открытки.ТекущиеДанные.ИмяФайла = ВыбранныеФайлы[0];

КонецПроцедуры

#КонецОбласти

#КонецОбласти
