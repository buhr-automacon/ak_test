﻿
&НаКлиенте
Процедура ЗаписатьИЗакрыть(Команда)
	Отказ = Ложь;
	ПроверитьЗаполнениеДанных(Отказ);
	Если Отказ = Истина Тогда
		Возврат
	КонецЕсли;
	
	ЗаписатьИЗакрытьНаСервере();
	ВладелецФормы.Элементы.Список.Обновить();
	Закрыть();
КонецПроцедуры

&НаСервере
Процедура ЗаписатьИЗакрытьНаСервере()
	СоздатьНаборЗаписейНаСервере();	
КонецПроцедуры
	
&НаКлиенте
Процедура Записать(Команда)
	Отказ = Ложь;
	ПроверитьЗаполнениеДанных(Отказ);
	Если Отказ = Истина Тогда
		Возврат
	КонецЕсли;
	ЗаписатьНаСервере();
	ВладелецФормы.Элементы.Список.Обновить()
КонецПроцедуры

&НаСервере
Процедура ЗаписатьНаСервере()
	СоздатьНаборЗаписейНаСервере();	
КонецПроцедуры

&НаКлиенте
Процедура ЗаполнитьПродавцов(Команда)
	ПроставитьПродавцовНаСервере();	
КонецПроцедуры

&НаСервере
Процедура ПроставитьПродавцовНаСервере()
	
	Если ЗначениеЗаполнено(СтруктурнаяЕдиница) И ЗначениеЗаполнено(ДатаПроверки) Тогда
		
		Продавцы.Очистить();
		
		Запрос = Новый Запрос;
		Запрос.Текст = 
		"ВЫБРАТЬ
		|	ЛистУчетаПродавцы.Продавец
		|ИЗ
		|	Документ.ЛистУчета.Продавцы КАК ЛистУчетаПродавцы
		|ГДЕ
		|	НАЧАЛОПЕРИОДА(ЛистУчетаПродавцы.Ссылка.Дата, ДЕНЬ) = &Дата
		|	И ЛистУчетаПродавцы.Ссылка.ТорговаяТочка = &ТорговаяТочка";
		
		Запрос.УстановитьПараметр("Дата", НачалоДня(ДатаПроверки));
		Запрос.УстановитьПараметр("ТорговаяТочка", СтруктурнаяЕдиница);
		
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
		
			ЗапросПоТабелю.УстановитьПараметр("Дата", НачалоДня(ДатаПроверки));
			ЗапросПоТабелю.УстановитьПараметр("ТорговаяТочка", СтруктурнаяЕдиница);

	        ТЗ_Результат = ЗапросПоТабелю.Выполнить().Выгрузить();
		КонецЕсли; 
		
		Для Каждого Строка Из ТЗ_Результат Цикл
			НовСтрока = Продавцы.Добавить();		
			НовСтрока.Продавец = Строка.Продавец;
		КонецЦикла;
 		
	КонецЕсли;	
	
КонецПроцедуры	

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	Ответственный = ПараметрыСеанса.ТекущийПользователь;
	Период = ТекущаяДата();
КонецПроцедуры

&НаСервере
Процедура СоздатьНаборЗаписейНаСервере()
	
	Для Каждого Строка Из Продавцы Цикл	
		
		НЗ = РегистрыСведений.ПроцентыТайногоПокупателя.СоздатьНаборЗаписей();
		НЗ.Отбор.Продавец.Установить(Строка.Продавец);
		НЗ.Отбор.СтруктурнаяЕдиница.Установить(СтруктурнаяЕдиница);
        НЗ.Отбор.ДатаПроверки.Установить(ДатаПроверки);
        НЗ.Отбор.ТипАнкет.Установить(ТипАнкет);
        НЗ.Отбор.Период.Установить(Период);
		НЗ.Прочитать();
		НЗ.Очистить();
		
		НоваяЗапись = НЗ.Добавить();
		НоваяЗапись.Продавец = Строка.Продавец;
		НоваяЗапись.СтруктурнаяЕдиница = СтруктурнаяЕдиница;
		НоваяЗапись.ДатаПроверки = ДатаПроверки;
		НоваяЗапись.ТипАнкет = ТипАнкет;
		НоваяЗапись.Период = Период;
		НоваяЗапись.Процент = Процент;
		НоваяЗапись.ИмяФайла = ИмяФайла;
		НоваяЗапись.Комментарий = Комментарий;
		НоваяЗапись.Ответственный = Ответственный;
		//Беляк +
		НоваяЗапись.Задача = Задача;
		//Беляк -
		//НЗ.Записывать = Истина;
		НЗ.Записать();
		
	КонецЦикла;
	
КонецПроцедуры

&НаКлиенте
Процедура ЗакрытьОкно(Команда)
	Закрыть();
КонецПроцедуры

&НаСервере
Процедура ПроверитьЗаполнениеДанных(Отказ = Ложь)
	
	Если НЕ ЗначениеЗаполнено(Период) Тогда
		Сообщить("Значение Период не заполнено!", СтатусСообщения.Важное);
		Отказ = Истина;
	КонецЕсли;
	Если Продавцы.Количество() = 0 Тогда
		Сообщить("Значение Продавец не заполнено!", СтатусСообщения.Важное);
		Отказ = Истина;
	КонецЕсли;
	Если НЕ ЗначениеЗаполнено(СтруктурнаяЕдиница) Тогда
		Сообщить("Значение Структурная Единица не заполнено!", СтатусСообщения.Важное);
		Отказ = Истина;
	КонецЕсли;
	Если НЕ ЗначениеЗаполнено(ДатаПроверки) Тогда
		Сообщить("Значение Дата Проверки не заполнено!", СтатусСообщения.Важное);
		Отказ = Истина;
	КонецЕсли;
	Если НЕ ЗначениеЗаполнено(ТипАнкет) Тогда
		Сообщить("Значение Тип Анкет не заполнено!", СтатусСообщения.Важное);
		Отказ = Истина;
	КонецЕсли;
	Если НЕ ЗначениеЗаполнено(Процент) Тогда
		Сообщить("Значение Процент не заполнено!", СтатусСообщения.Важное);
		Отказ = Истина;
	КонецЕсли;  	
	
КонецПроцедуры

&НаКлиенте
Процедура ИмяФайлаНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	ДиалогФайла = Новый ДиалогВыбораФайла(РежимДиалогаВыбораФайла.Открытие);
	ДиалогФайла.МножественныйВыбор = Ложь;
	//ДиалогФайла.Фильтр = "(*.jpg;*.jpeg;*.gif;*.tif;*.png)|*.jpg;*.jpeg;*.gif;*.tif;*.png";
	ДиалогФайла.ПроверятьСуществованиеФайла = Истина;
	Если ДиалогФайла.Выбрать() Тогда
		ИмяФайла = ДиалогФайла.ПолноеИмяФайла;
	КонецЕсли;
КонецПроцедуры
