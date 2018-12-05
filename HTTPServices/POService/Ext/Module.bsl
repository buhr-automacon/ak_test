﻿
//
//
Функция СформироватьHTTPСервисОтвет(КодСостояния, Описание)

	//
	Соответствие = Новый Соответствие;
	Соответствие.Вставить("description", Описание);
	
	//
	ЗаписьJSON = Новый ЗаписьJSON;
	ЗаписьJSON.УстановитьСтроку();
	
	//
	ЗаписатьJSON(ЗаписьJSON, Соответствие);
	ТекстJSON = ЗаписьJSON.Закрыть();
	
	//
	HTTPСервисОтвет = Новый HTTPСервисОтвет(КодСостояния);
	HTTPСервисОтвет.Причина = Описание;
	
	//
	HTTPСервисОтвет.УстановитьТелоИзСтроки(ТекстJSON);
	
	//
	Возврат HTTPСервисОтвет;
	
КонецФункции	
	
//
//
Функция unified(Запрос)
	
	//
	УстановитьПривилегированныйРежим(Истина);
	
	//
	HTTPСервисОтвет = СформироватьHTTPСервисОтвет(500, "Не найдена обработка обслуживания");
	
	//
	ИмяФайлаTEMP = КаталогВременныхФайлов() + "_POSAPI.epf";
	ИмяФайлаБД = КаталогВременныхФайлов() + "_POSAPI_БД.epf";
	
	//
	ФайлTEMP = Новый Файл(ИмяФайлаTEMP);
	
	//
	ТЗ = "ВЫБРАТЬ
	     |	Таблица.Ссылка,
	     |	Таблица.ХранилищеВнешнейОбработки
	     |ИЗ
	     |	Справочник.ВнешниеОбработки КАК Таблица
	     |ГДЕ
	     |	Таблица.Код = ""_POSAPI""";
	
	//
	ПЗ = Новый ПостроительЗапроса;
	ПЗ.Текст = ТЗ;
	
	//
	Выборка = ПЗ.Результат.Выбрать();
	Если Выборка.Следующий() Тогда
		
		//
		ДвоичныеДанные = Выборка.ХранилищеВнешнейОбработки.Получить();
		Если ДвоичныеДанные = Неопределено Тогда 
			HTTPСервисОтвет = СформироватьHTTPСервисОтвет(500, "Ошибка в настройке обработки обслуживания №1: " + ОписаниеОшибки());
			Возврат HTTPСервисОтвет;
		КонецЕсли;
		
		//
		Попытка
			ДвоичныеДанные.Записать(ИмяФайлаБД);
		Исключение	
			HTTPСервисОтвет = СформироватьHTTPСервисОтвет(500, "Ошибка в настройке обработки обслуживания №2: " + ОписаниеОшибки());
			Возврат HTTPСервисОтвет;
		КонецПопытки;	
		
	КонецЕсли;	
	
	//
	ФайлTEMP = Новый Файл(ИмяФайлаTEMP);
	ФайлБД = Новый Файл(ИмяФайлаБД);
	
	//
	Если НЕ ФайлTEMP.Существует() Тогда
		
		//
		КопироватьФайл(ИмяФайлаБД, ИмяФайлаTEMP);
		
	ИначеЕсли ФайлБД.Существует() Тогда
		
		//
		Если ФайлБД.Размер() > ФайлTEMP.Размер() Тогда
			КопироватьФайл(ИмяФайлаБД, ИмяФайлаTEMP);
		КонецЕсли;
		
	Иначе
		
		//
		HTTPСервисОтвет = СформироватьHTTPСервисОтвет(500, "Ошибка в настройке обработки обслуживания №3: " + ОписаниеОшибки());
		Возврат HTTPСервисОтвет;
		
	КонецЕсли;	
		
	//
	Попытка
		Обработка = ВнешниеОбработки.Создать(ИмяФайлаTEMP, Ложь);
		HTTPСервисОтвет = Обработка.ОбработатьHTTPСервисЗапрос(Запрос);
	Исключение	
		HTTPСервисОтвет = СформироватьHTTPСервисОтвет(500, "Ошибка при вызове метода обработки обслуживания: " + ОписаниеОшибки());
	КонецПопытки;	
	
	//
	Возврат HTTPСервисОтвет;
	
КонецФункции

