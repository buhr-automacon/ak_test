﻿
&НаКлиенте
Процедура ЗаполнитьПродавцов(Команда)
	ПроставитьПродавцовНаСервере();	
КонецПроцедуры

&НаСервере
Процедура ПроставитьПродавцовНаСервере()
	
	Если ЗначениеЗаполнено(Запись.СтруктурнаяЕдиница) И ЗначениеЗаполнено(Запись.ДатаПроверки) Тогда
		
		Запрос = Новый Запрос;
		Запрос.Текст = 
		"ВЫБРАТЬ
		|	ЛистУчетаПродавцы.Продавец
		|ИЗ
		|	Документ.ЛистУчета.Продавцы КАК ЛистУчетаПродавцы
		|ГДЕ
		|	НАЧАЛОПЕРИОДА(ЛистУчетаПродавцы.Ссылка.Дата, ДЕНЬ) = &Дата
		|	И ЛистУчетаПродавцы.Ссылка.ТорговаяТочка = &ТорговаяТочка";
		
		Запрос.УстановитьПараметр("Дата", НачалоДня(Запись.ДатаПроверки));
		Запрос.УстановитьПараметр("ТорговаяТочка", Запись.СтруктурнаяЕдиница);
		
		ТЗ_Результат = Запрос.Выполнить().Выгрузить();
		
		Если ТЗ_Результат.Количество() = 0 Тогда
			ЗапросПоТабелю = Новый Запрос;
			ЗапросПоТабелю.Текст = 
				"ВЫБРАТЬ
				|	ТабельРаботыПродавцов.Сотрудник КАК Продавец
				|ИЗ
				|	РегистрСведений.ТабельРаботыПродавцов КАК ТабельРаботыПродавцов
				|ГДЕ
				|	ТабельРаботыПродавцов.ТорговаяТочка = &ТорговаяТочка
				|	И НАЧАЛОПЕРИОДА(ТабельРаботыПродавцов.Период, ДЕНЬ) = &Дата";
		
			ЗапросПоТабелю.УстановитьПараметр("Дата", НачалоДня(Запись.ДатаПроверки));
			ЗапросПоТабелю.УстановитьПараметр("ТорговаяТочка", Запись.СтруктурнаяЕдиница);

	        ТЗ_Результат = ЗапросПоТабелю.Выполнить().Выгрузить();
		КонецЕсли; 
		
		Для Каждого Строка Из ТЗ_Результат Цикл
			НовСтрока = Продавцы.Добавить();		
			НовСтрока.Продавец = Строка.Продавец;
		КонецЦикла;
		
		
		//Выборка = 
		//Если ТЗ_Результат.Количество() = 3 Тогда
		//	Запись.Продавец1 = ТЗ_Результат[0].Продавец;
		//	Запись.Продавец2 = ТЗ_Результат[1].Продавец;
		//	Запись.Продавец3 = ТЗ_Результат[2].Продавец;
		//ИначеЕсли ТЗ_Результат.Количество() = 2 Тогда
		//	Запись.Продавец1 = ТЗ_Результат[0].Продавец;
		//	Запись.Продавец2 = ТЗ_Результат[1].Продавец;
		//ИначеЕсли ТЗ_Результат.Количество() = 1 Тогда	
		//	Запись.Продавец1 = ТЗ_Результат[0].Продавец;  									
		//КонецЕсли;	
 		
	КонецЕсли;	
	
КонецПроцедуры	

&НаСервере
Процедура ПередЗаписьюНаСервере(Отказ, ТекущийОбъект, ПараметрыЗаписи)
	
	
КонецПроцедуры

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	//Запись.Ответственный = ПараметрыСеанса.ТекущийПользователь;
	
КонецПроцедуры

&НаКлиенте
Процедура ИмяФайлаНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	ДиалогФайла = Новый ДиалогВыбораФайла(РежимДиалогаВыбораФайла.Открытие);
	ДиалогФайла.МножественныйВыбор = Ложь;
	//ДиалогФайла.Фильтр = "(*.jpg;*.jpeg;*.gif;*.tif;*.png)|*.jpg;*.jpeg;*.gif;*.tif;*.png";
	ДиалогФайла.ПроверятьСуществованиеФайла = Истина;
	Если ДиалогФайла.Выбрать() Тогда
		//ХранилищеКартинки = Новый ХранилищеЗначения(ДиалогФайла.ПолноеИмяФайла);
		Запись.ИмяФайла = ДиалогФайла.ПолноеИмяФайла;
	КонецЕсли;

КонецПроцедуры

&НаКлиенте
Процедура ИмяФайлаОткрытие(Элемент, СтандартнаяОбработка)
	Попытка
		СтандартнаяОбработка = Ложь;
		ЗапуститьПриложение(Запись.ИмяФайла);				
	Исключение
	
	КонецПопытки;
КонецПроцедуры
