﻿
&НаКлиенте
Процедура СохранитьИзменения(Команда)
	
	//+++АК mika 2018.07.17 ИП-00019185
	ЗаполнитьЦФОТорговыхТочек();
	//---АК mika
	
	СтруктураВозврата = Новый Структура;
	
	СтруктураВозврата.Вставить("Сотрудник"	, Сотрудник);
	СтруктураВозврата.Вставить("Период"		, Период);
	
	ТЗ = Новый ТаблицаЗначений;
	ТЗ.Колонки.Добавить("ТорговаяТочка"	 , Новый ОписаниеТипов("СправочникСсылка.СтруктурныеЕдиницы"));
	ТЗ.Колонки.Добавить("КоличествоЧасов", Новый ОписаниеТипов("Число"));
	ТЗ.Колонки.Добавить("ЦФО"	         , Новый ОписаниеТипов("СправочникСсылка.СтруктурныеЕдиницы")); //+++АК mika 2018.07.17 ИП-00019185
	
	Для Каждого Стр Из ТаблицаДанных Цикл
		ЗаполнитьЗначенияСвойств(ТЗ.Добавить(), Стр);
	КонецЦикла;
		
	СтруктураВозврата.Вставить("ТаблицаДанных", ТЗ);
	Закрыть(СтруктураВозврата);
	
КонецПроцедуры

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("Сотрудник")Тогда
		Сотрудник = Параметры.Сотрудник;
	КонецЕсли;
	
	Если Параметры.Свойство("Период")Тогда
		Период = Параметры.Период;
	КонецЕсли;
	
	Если Параметры.Свойство("ТаблицаДанных")Тогда
		ТаблицаДанных.Загрузить(Параметры.ТаблицаДанных);	
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ТаблицаДанныхПередНачаломДобавления(Элемент, Отказ, Копирование, Родитель, Группа, Параметр)	
//+++ziga 26.10.2017 	 
		Если Не ПолучитьАктивный(Сотрудник) Тогда
		Ответ = Вопрос("Сотрудник "+Сотрудник.Наименование+" не активный, сделать активным?", РежимДиалогаВопрос.ДаНет);
		Если (Ответ = КодВозвратаДиалога.Да) Тогда
			ИзменитьСотрудникаСервер(Сотрудник);
		КонецЕсли;		
		КонецЕсли; 	
	//---ziga 26.10.2017
КонецПроцедуры
//+++ziga 30.10.2017
&НаСервере
Процедура ИзменитьСотрудникаСервер(Сотр)
	Сотр=Сотрудник.Получитьобъект();
	Сотр.Активный=Истина;
	Сотр.записать();
КонецПроцедуры
&НаСервере
Функция ПолучитьАктивный(Сотр)
	Запрос=Новый Запрос;
	Запрос.Текст="ВЫБРАТЬ
	             |	ФизическиеЛица.Активный
	             |ИЗ
	             |	Справочник.ФизическиеЛица КАК ФизическиеЛица
	             |ГДЕ
	             |	ФизическиеЛица.Ссылка = &Ссылка";
	Запрос.УстановитьПараметр("Ссылка",Сотр);
	Выборка=Запрос.Выполнить().Выбрать();
	Пока Выборка.Следующий() Цикл
		Возврат	Выборка.Активный;	
	КонецЦикла; 	
	
КонецФункции

//---ziga 30.10.2017

//+++АК mika 2018.07.17 ИП-00019185
&Насервере
Процедура ЗаполнитьЦФОТорговыхТочек();
	
	Запрос = Новый Запрос("Выбрать * ПОМЕСТИТЬ ВТ Из &ВременнаяТаблица Как ВременнаяТаблица");
	Запрос.МенеджерВременныхТаблиц = Новый МенеджерВременныхТаблиц;
	Запрос.УстановитьПараметр("ВременнаяТаблица", ТаблицаДанных.Выгрузить());
	Запрос.Выполнить();
	
	Запрос.Текст = "ВЫБРАТЬ РАЗРЕШЕННЫЕ
	|	ЦФОСтруктурныхЕдиницСрезПоследних.СтруктурнаяЕдиница,
	|	МАКСИМУМ(ЦФОСтруктурныхЕдиницСрезПоследних.ЦФО) КАК ЦФО
	|ПОМЕСТИТЬ ВТ_ЦФО
	|ИЗ
	|	РегистрСведений.ЦФОСтруктурныхЕдиниц.СрезПоследних КАК ЦФОСтруктурныхЕдиницСрезПоследних
	|
	|СГРУППИРОВАТЬ ПО
	|	ЦФОСтруктурныхЕдиницСрезПоследних.СтруктурнаяЕдиница
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ВТ.ТорговаяТочка,
	|	ВТ.КоличествоЧасов,
	|	ВТ_ЦФО.ЦФО
	|ИЗ
	|	ВТ КАК ВТ
	|		ЛЕВОЕ СОЕДИНЕНИЕ ВТ_ЦФО КАК ВТ_ЦФО
	|		ПО ВТ.ТорговаяТочка = ВТ_ЦФО.СтруктурнаяЕдиница";
	
	Результат = Запрос.Выполнить();
	
	Если НЕ Результат.Пустой() Тогда
		ТаблицаДанных.Загрузить(Результат.Выгрузить());
	КонецЕсли;
	
КонецПроцедуры

//---ziga 30.10.2017
