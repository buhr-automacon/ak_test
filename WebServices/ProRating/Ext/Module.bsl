﻿
//+++АК SHEP 2018.11.07 ИП-00018753.06 Добавлен Web-Сервис ProRating
//Синхронизация данных для обмена 1С с Личным кабинетом системы оценок поставщиков


//+++АК SHEP 2018.11.07 ИП-00018753.06 
Функция ПолучитьИПодключитьВнешнююОбработку(ИмяОбработки = "ВебСервис_ProRating")
	
	//Возврат Неопределено; // для внешней обработки!
	
	УстановитьПривилегированныйРежим(Истина);
	
	ВнешниеОбработкиСсылка = Справочники.ВнешниеОбработки.НайтиПоНаименованию(ИмяОбработки);
	Если НЕ ЗначениеЗаполнено(ВнешниеОбработкиСсылка) Тогда Возврат Неопределено; КонецЕсли;
	
	ДвоичныеДанные = ВнешниеОбработкиСсылка.ХранилищеВнешнейОбработки.Получить();
	
	#Если Сервер Тогда
		АдресВоВременномХранилище = ПоместитьВоВременноеХранилище(ДвоичныеДанные);
		ИмяОбработки = ВнешниеОбработки.Подключить(АдресВоВременномХранилище, , Ложь);
	#Иначе
		ИмяОбработки = ПолучитьИмяВременногоФайла("epf");
		ДвоичныеДанные.Записать(ИмяОбработки); 
	#КонецЕсли
	
	Обработка = ВнешниеОбработки.Создать(ИмяОбработки);
	
	УстановитьПривилегированныйРежим(Ложь);
	
	Возврат Обработка;
	
КонецФункции

//+++АК SHEP 2018.11.07 ИП-00018753.06 
Функция Autorization(Логин, Пароль) Экспорт
	
	ОбработкаОбъект = ПолучитьИПодключитьВнешнююОбработку();
	Если ОбработкаОбъект <> Неопределено Тогда
		Возврат ОбработкаОбъект.Autorization(Логин, Пароль);
	КонецЕсли;
	
КонецФункции

Функция GetSuppliersList(ВидОбъекта, СписокПолей, ФильтрСтрокой, НомерСтраницы, КвоНаСтраницу, ДопУсловие, Сортировка) Экспорт
	
	ОбработкаОбъект = ПолучитьИПодключитьВнешнююОбработку();
	Если ОбработкаОбъект <> Неопределено Тогда
		Возврат ОбработкаОбъект.GetSuppliersList(ВидОбъекта, СписокПолей, ФильтрСтрокой, НомерСтраницы, КвоНаСтраницу, ДопУсловие, Сортировка);
	КонецЕсли;
	
КонецФункции

Функция GetObjectsList(ВидОбъекта, СписокПолей, ФильтрСтрокой, НомерСтраницы, КвоНаСтраницу, ДопУсловие, Сортировка) Экспорт
	
	ОбработкаОбъект = ПолучитьИПодключитьВнешнююОбработку();
	Если ОбработкаОбъект <> Неопределено Тогда
		Возврат ОбработкаОбъект.GetObjectsList(ВидОбъекта, СписокПолей, ФильтрСтрокой, НомерСтраницы, КвоНаСтраницу, ДопУсловие, Сортировка);
	КонецЕсли;
	
КонецФункции

Функция GetObjectData(ВидОбъекта, Ссылка, ФорматДанных) Экспорт
	
	ОбработкаОбъект = ПолучитьИПодключитьВнешнююОбработку();
	Если ОбработкаОбъект <> Неопределено Тогда
		Возврат ОбработкаОбъект.GetObjectData(ВидОбъекта, Ссылка, ФорматДанных);
	КонецЕсли;
	
КонецФункции

Функция GetSupplierInfo(ФильтрСтрокой) Экспорт
	
	ОбработкаОбъект = ПолучитьИПодключитьВнешнююОбработку();
	Если ОбработкаОбъект <> Неопределено Тогда
		Возврат ОбработкаОбъект.GetSupplierInfo(ФильтрСтрокой);
	КонецЕсли;
	
КонецФункции

Функция SaveComment(ФильтрСтрокой, Период, Текст) Экспорт
	
	ОбработкаОбъект = ПолучитьИПодключитьВнешнююОбработку();
	Если ОбработкаОбъект <> Неопределено Тогда
		Возврат ОбработкаОбъект.SaveComment(ФильтрСтрокой, Период, Текст);
	КонецЕсли;
	
КонецФункции

Функция SaveRatingData(ФильтрСтрокой, Период, Оценка) Экспорт
	
	ОбработкаОбъект = ПолучитьИПодключитьВнешнююОбработку();
	Если ОбработкаОбъект <> Неопределено Тогда
		Возврат ОбработкаОбъект.SaveRatingData(ФильтрСтрокой, Период, Оценка);
	КонецЕсли;
	
КонецФункции

// Сохранить отзыв о поставщике
Функция SaveSupplierReview(ФильтрСтрокой, Период, Оценка, Комментарий, ОпытИспользования, РекомендуемДрузьям) Экспорт
	
	ОбработкаОбъект = ПолучитьИПодключитьВнешнююОбработку();
	Если ОбработкаОбъект <> Неопределено Тогда
		Возврат ОбработкаОбъект.SaveSupplierReview(ФильтрСтрокой, Период, Оценка, Комментарий, ОпытИспользования, РекомендуемДрузьям);
	КонецЕсли;
	
КонецФункции

// Получить отзывы о поставщике
Функция GetSupplierReviews(СписокПолей, ФильтрСтрокой, НомерСтраницы, КвоНаСтраницу, ДопУсловие, Сортировка) Экспорт
	
	ОбработкаОбъект = ПолучитьИПодключитьВнешнююОбработку();
	Если ОбработкаОбъект <> Неопределено Тогда
		Возврат ОбработкаОбъект.GetSupplierReviews(СписокПолей, ФильтрСтрокой, НомерСтраницы, КвоНаСтраницу, ДопУсловие, Сортировка);
	КонецЕсли;
	
КонецФункции

// Получить оценки поставщика
Функция GetSupplierMarks(ФильтрСтрокой, ДопУсловие, Сортировка) Экспорт
	
	ОбработкаОбъект = ПолучитьИПодключитьВнешнююОбработку();
	Если ОбработкаОбъект <> Неопределено Тогда
		Возврат ОбработкаОбъект.GetSupplierMarks(ФильтрСтрокой, ДопУсловие, Сортировка);
	КонецЕсли;
	
КонецФункции

// Установить статус работы
Функция SetWorkingStatus(ФильтрСтрокой, Работаем, ОпытИспользования) Экспорт
	
	ОбработкаОбъект = ПолучитьИПодключитьВнешнююОбработку();
	Если ОбработкаОбъект <> Неопределено Тогда
		Возврат ОбработкаОбъект.SetWorkingStatus(ФильтрСтрокой, Работаем, ОпытИспользования);
	КонецЕсли;
	
КонецФункции
