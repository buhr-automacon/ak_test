﻿//+++АК ZHAS 16-09-17 ИП-00015200.03
Процедура ОбработатьАвтоматическоеПодтверждениеСтопОплаты(СтруктураПараметров) Экспорт 
	РезультатПроцесса = "";
	ТипЗаявки = СтруктураПараметров.ТипЗаявки;
	GUID = СтруктураПараметров.GUID_Заявки;
	Подтверждено = Истина;
	
	Если СтруктураПараметров.Акцептировано1 Тогда
		Запрос = Новый Запрос;
		Запрос.Текст = 
			"ВЫБРАТЬ
			|	СведенияОСтопОплате.Период,
			//+++АК sils 05.09.2018 ИП-00019634
			|	СведенияОСтопОплате.Организация,
			//---АК
			|	СведенияОСтопОплате.Контрагент,
			|	СведенияОСтопОплате.СтопОплата,
			|	СведенияОСтопОплате.Подтверждено,
			|	СведенияОСтопОплате.Руководитель,
			|	СведенияОСтопОплате.ЭлАдрес,
			|	СведенияОСтопОплате.Комментарий,
			|	СведенияОСтопОплате.УстановилВСтопОплату,
			|	СведенияОСтопОплате.GUID
			|ИЗ
			|	РегистрСведений.СведенияОСтопОплате КАК СведенияОСтопОплате
			|ГДЕ
			|	СведенияОСтопОплате.GUID = &GUID";
		
		Запрос.УстановитьПараметр("GUID", GUID);
		Контрагент = Неопределено;
		//+++АК sils 05.09.2018 ИП-00019634
		Организация = Справочники.Организации.ПустаяСсылка();
		//---АК
		РезультатЗапроса = Запрос.Выполнить();
		ВыборкаДетальныеЗаписи = РезультатЗапроса.Выбрать();
		Пока ВыборкаДетальныеЗаписи.Следующий() Цикл
			Контрагент = ВыборкаДетальныеЗаписи.Контрагент;
			//+++АК sils 05.09.2018 ИП-00019634
			Организация = ВыборкаДетальныеЗаписи.Организация;
			//---АК
		КонецЦикла;
		ДатаУчета = ТекущаяДата();
		
		НаборЗаписей = РегистрыСведений.СведенияОСтопОплате.СоздатьНаборЗаписей();
		НаборЗаписей.Отбор.Контрагент.Установить(Контрагент);
		//+++АК sils 05.09.2018 ИП-00019634
		НаборЗаписей.Отбор.Организация.Установить(Организация);
		//---АК
		НаборЗаписей.Отбор.Период.Установить(ДатаУчета);
		
		НаборЗаписей.Прочитать();
		НаборЗаписей.Очистить();
		
		НовЗапись = НаборЗаписей.Добавить();
		ЗаполнитьЗначенияСвойств(НовЗапись, ВыборкаДетальныеЗаписи);
		Если ТипЗаявки = 6 Тогда
			НовЗапись.Подтверждено = СтруктураПараметров.Акцептировано1;
		Иначе
			
			НовЗапись.Подтверждено = Ложь;
		КонецЕсли;
			НовЗапись.Период = ДатаУчета;
		
		//НаборЗаписей.Прочитать();
		//Для Каждого Строка ИЗ НаборЗаписей Цикл
		//	Строка.Подтверждено = СтруктураПараметров.Акцептировано1;
		//КонецЦикла;
		//ТЗ = НаборЗаписей.Выгрузить();
		//НаборЗаписей.Очистить();
		//Для Каждого Строка ИЗ ТЗ Цикл
		//	Строка.Период = СтруктураПараметров.ДатаПолучения1;
		//КонецЦикла;
		//НаборЗаписей.Загрузить(ТЗ);
		//НаборЗаписей.Отбор.Период.Установить(НачалоДня(СтруктураПараметров.ДатаПолучения1));
		Попытка
			НаборЗаписей.Записать();
			РезультатПроцесса = "УДАЧА";
		Исключение
			//Сообщить("Нет доступа к регистру сведений! Изменения не записаны!");
			//Возврат;
			РезультатПроцесса = "НЕУДАЧА " + ОписаниеОшибки();
		КонецПопытки;
		
		
		Попытка
			ОтправитьПисьмоАналитику(НаборЗаписей, РезультатПроцесса);
		Исключение
		КонецПопытки;
	Иначе
	КонецЕсли;
	
КонецПроцедуры

Функция ПроверкаКонтрагента_М(Контрагент)
	ФлагВозврата = Ложь;
	Если ЗначениеЗаполнено(Контрагент) Тогда
		Отбор = Новый Структура;
		Отбор.Вставить("Контрагент", Контрагент);
		ТЗ = РегистрыСведений.СведенияОСтопОплате.СрезПоследних(, Отбор);
		Если ТЗ.Количество() > 1 Тогда
			//Сообщить("Такой контрагент уже есть!");
			ФлагВозврата = Истина;
		КонецЕсли;
	Иначе
		//Сообщить("Контрагент не может быть пустым!");
		ФлагВозврата = Истина;
	КонецЕсли;
	Возврат ФлагВозврата;
Конецфункции

Процедура ОтправитьПисьмоАналитику(ЗаявкаНаПодтвреждение, РезультатПроцесса);
	ЗаписьХМЛ = Новый ЗаписьXML;
	ЗаписьХМЛ.УстановитьСтроку("UTF-16");
	ЗаписатьXML(ЗаписьХМЛ, ЗаявкаНаПодтвреждение);
	ОбъектХМЛ = ЗаписьХМЛ.Закрыть();
	Параметры = Новый Массив;
	Параметры.Добавить(ЗначениеВСтрокуВнутр(ОбъектХМЛ));
	ФоновоеЗадание = ФоновыеЗадания.Выполнить("УправлениеЭлектроннойПочтой.КонтрольАкцептРассылки", Параметры, Строка(Новый УникальныйИдентификатор), "ОС_ОТПАБОТКА_АКЦЕПТ");
КонецПроцедуры  
//+++АК ZHAS 16-09-17 ИП-00015200.03