﻿////////////////////////////////////////////////////////////////////////////////
//  ОСНОВНЫЕ МЕТОДЫ

// Удаляет записи из табличной части ЭЦП
//
// Параметры
//  ТаблицаВыделенныеСтроки  - ТаблицаЗначений - таблица, содержащая данные - ссылка на объект и номер строки в его табличной части
//  РеквизитПодписанИзменен - Булево - возвращаемое значение - если удалена последняя подпись, 
//     РеквизитПодписанИзменен примет значение Истина
//  КоличествоПодписей - Число - количество подписей в объекте после удаления
//  УникальныйИдентификатор - УникальныйИдентификатор - уникальный идентификатор формы
Процедура УдалитьПодписи(ОбъектСсылка, ТаблицаВыделенныеСтроки, РеквизитПодписанИзменен, 
	КоличествоПодписей, УникальныйИдентификатор = Неопределено) Экспорт
	
	РеквизитПодписанИзменен = Ложь;

	// Сортировка по убыванию номера строки - вначале будут последние строки
	ТаблицаВыделенныеСтроки.Сортировать("НомерСтроки Убыв");  

	ПодписанныйОбъект = ОбъектСсылка.ПолучитьОбъект();
	ЗаблокироватьДанныеДляРедактирования(ОбъектСсылка, , УникальныйИдентификатор);
	
	Для Каждого ДанныеПодписи Из ТаблицаВыделенныеСтроки Цикл
		УдалитьПодпись(ПодписанныйОбъект, ДанныеПодписи);
	КонецЦикла;
	
	КоличествоПодписей = ПодписанныйОбъект.ЭлектронныеЦифровыеПодписи.Количество();
	ПодписанныйОбъект.ПодписанЭЦП = (КоличествоПодписей <> 0);
	РеквизитПодписанИзменен = НЕ ПодписанныйОбъект.ПодписанЭЦП;
	
	ПодписанныйОбъект.ДополнительныеСвойства.Вставить("ЗаписьПодписанногоОбъекта", Истина); // чтобы прошла запись ранее подписанного объекта
	УстановитьПривилегированныйРежим(Истина);
	ПодписанныйОбъект.Записать();
	РазблокироватьДанныеДляРедактирования(ОбъектСсылка, УникальныйИдентификатор);
	
КонецПроцедуры

// Проверяет подпись. В случае ошибки бросает исключение
//
// Параметры
//  МенеджерКриптографии  - МенеджерКриптографии - менеджер криптографии
//  ДвоичныеДанныеФайла  -    двоичные данные файла
//  ДвоичныеДанныеПодписи  -  двоичные данные подписи
Процедура ПроверитьПодпись(МенеджерКриптографии, ДвоичныеДанныеФайла, ДвоичныеДанныеПодписи) Экспорт
	
	Сертификат = Неопределено;
	МенеджерКриптографии.ПроверитьПодпись(ДвоичныеДанныеФайла, ДвоичныеДанныеПодписи, Сертификат);
	
	МассивРежимовПроверки = Новый Массив;
	МассивРежимовПроверки.Добавить(РежимПроверкиСертификатаКриптографии.ИгнорироватьВремяДействия);
	МассивРежимовПроверки.Добавить(РежимПроверкиСертификатаКриптографии.РазрешитьТестовыеСертификаты);
	МенеджерКриптографии.ПроверитьСертификат(Сертификат, МассивРежимовПроверки);
	
КонецПроцедуры	

////////////////////////////////////////////////////////////////////////////////
//  ВСПОМОГАТЕЛЬНЫЕ МЕТОДЫ

// Заносит информацию о подписи объекта
//
// Параметры
//	ПодписываемыйОбъектСсылка  - любая ссылка / объект - в табличную часть которого будет занесена информация о ЭЦП
//								в случае если ссылка - будет получен объект, блокировка, запись в ИБ
//								в случае объекта - за блокировку и запись - ответственнен вызывающий код
//	НоваяПодписьДвоичныеДанные  - ДвоичныеДанные - двоичные данные подписи
//	Отпечаток  - Строка - Base64 закодированная строка с отпечатком сертификата подписавшего
//	ДатаПодписи  - Дата - дата подписи
//	Комментарий  - Строка - комментарий подписи
//	ИмяФайлаПодписи  - Строка - имя файла подписи (не пусто только в случае если подпись добавлена из файла)
//	КомуВыданСертификат  - Строка - представление поля КомуВыдан сертификата
//	УникальныйИдентификатор - УникальныйИдентификатор - уникальный идентификатор формы
//
Процедура ЗанестиИнформациюОПодписи(
			ПодписываемыйОбъектСсылка,
			НоваяПодписьДвоичныеДанные,
			Отпечаток,
			ДатаПодписи,
			Комментарий,
			ИмяФайлаПодписи,
			КомуВыданСертификат,
			ДвоичныеДанныеСертификата,
			УникальныйИдентификатор = Неопределено) Экспорт
	
	Если ОбщегоНазначения.ЭтоСсылка(ТипЗнч(ПодписываемыйОбъектСсылка)) Тогда
		ПодписываемыйОбъект = ПодписываемыйОбъектСсылка.ПолучитьОбъект();
		ПодписываемыйОбъект.Заблокировать();
	Иначе
		ПодписываемыйОбъект = ПодписываемыйОбъектСсылка;
	КонецЕсли;
	
	Если ДатаПодписи = Дата('00010101') Тогда
		ДатаПодписи = ТекущаяДатаСеанса();
	КонецЕсли;	
	
	НоваяЗапись = ПодписываемыйОбъект.ЭлектронныеЦифровыеПодписи.Добавить();
	
	НоваяЗапись.КомуВыданСертификат	= КомуВыданСертификат;
	НоваяЗапись.ДатаПодписи			= ДатаПодписи;
	НоваяЗапись.ИмяФайлаПодписи		= ИмяФайлаПодписи;
	НоваяЗапись.Комментарий			= Комментарий;
	НоваяЗапись.Отпечаток			= Отпечаток;
	НоваяЗапись.Подпись				= Новый ХранилищеЗначения(НоваяПодписьДвоичныеДанные);
	НоваяЗапись.УстановившийПодпись = Пользователи.ТекущийПользователь();
	НоваяЗапись.Сертификат 			= Новый ХранилищеЗначения(ДвоичныеДанныеСертификата);
	
	ПодписываемыйОбъект.ПодписанЭЦП = Истина;
	ПодписываемыйОбъект.ДополнительныеСвойства.Вставить("ЗаписьПодписанногоОбъекта", Истина); // чтобы прошла запись ранее подписанного объекта
	
	Если ОбщегоНазначения.ЭтоСсылка(ТипЗнч(ПодписываемыйОбъектСсылка)) Тогда
		УстановитьПривилегированныйРежим(Истина);
		ПодписываемыйОбъект.Записать();
		ПодписываемыйОбъект.Разблокировать();
	КонецЕсли;
	
КонецПроцедуры

// Возвращает количество подписей у данного объекта
//
// Параметры
//  ОбъектСсылка  - ЛюбаяСсылка - ссылка на объект, в табличной части которого содержатся подписи
//
// Возвращаемое значение:
//   Число  - количество подписей
Функция КоличествоПодписей(ОбъектСсылка) Экспорт
	
	УстановитьПривилегированныйРежим(Истина);
	
	Запрос = Новый Запрос;
	Запрос.Текст = "ВЫБРАТЬ
				   |	КОЛИЧЕСТВО(*) КАК ЧислоЗаписей
				   |ИЗ
				   |	";
				   
	Запрос.Текст = Запрос.Текст + ОбщегоНазначения.ИмяТаблицыПоСсылке(ОбъектСсылка); 
	Запрос.Текст = Запрос.Текст + ".ЭлектронныеЦифровыеПодписи КАК ЭлектронныеЦифровыеПодписи
				   |ГДЕ
				   |	ЭлектронныеЦифровыеПодписи.Ссылка = &ОбъектСсылка";
				   
	Запрос.Параметры.Вставить("ОбъектСсылка", ОбъектСсылка);
	
	ВыборкаЗапроса = Запрос.Выполнить().Выбрать();
	
	ЧислоЗаписей = 0;
	Если ВыборкаЗапроса.Следующий() Тогда
		ЧислоЗаписей = ВыборкаЗапроса.ЧислоЗаписей;
	КонецЕсли;
	
	Возврат ЧислоЗаписей;
	
КонецФункции	

// Удаляет одну запись из табл части ЭЦП
//
// Параметры
//  ПодписываемыйОбъект - СправочникОбъект - подписываемый объект
//  ДанныеПодписи  - Структура - данные для поиска объекта и строки в его табличной части
Процедура УдалитьПодпись(ПодписанныйОбъект, ДанныеПодписи)
	
	НомерСтроки = ДанныеПодписи.НомерСтроки;
	
	СтрокаТабличнойЧасти = ПодписанныйОбъект.ЭлектронныеЦифровыеПодписи.Найти(НомерСтроки, "НомерСтроки");
	Если СтрокаТабличнойЧасти <> Неопределено Тогда
		
		Если НЕ Пользователи.ЭтоПолноправныйПользователь() Тогда 
			Если СтрокаТабличнойЧасти.УстановившийПодпись <> Пользователи.ТекущийПользователь() Тогда
				ВызватьИсключение НСтр("ru = 'Недостаточно прав на удаление подписи.'");
			КонецЕсли; 		
		КонецЕсли; 
		
		ПодписанныйОбъект.ЭлектронныеЦифровыеПодписи.Удалить(СтрокаТабличнойЧасти);
	Иначе	
		ВызватьИсключение НСтр("ru = 'Строка с подписью не найдена.'");
	КонецЕсли;
		
КонецПроцедуры

// Возвращает структуру, содержащую различные персональные настройки по работе с ЭЦП
// Возвращаемое значение:
//   Структура  - структура с настройками
Функция ПолучитьПерсональныеНастройкиРаботыСЭЦПСервер() Экспорт
	
	Настройки = Новый Структура;
	
	УстановитьПривилегированныйРежим(Истина);
	
	ПровайдерЭЦП = Константы.ПровайдерЭЦП.Получить();
	Настройки.Вставить("ПровайдерЭЦП", ПровайдерЭЦП);
	ТипПровайдераЭЦП = Константы.ТипПровайдераЭЦП.Получить();
	Настройки.Вставить("ТипПровайдераЭЦП", ТипПровайдераЭЦП);
	ВыполнятьПроверкуЭЦПНаСервере = Константы.ВыполнятьПроверкуЭЦПНаСервере.Получить();
	Настройки.Вставить("ВыполнятьПроверкуЭЦПНаСервере", ВыполнятьПроверкуЭЦПНаСервере);
	
	АлгоритмПодписи = Константы.АлгоритмПодписи.Получить();
	Настройки.Вставить("АлгоритмПодписи", АлгоритмПодписи);
	АлгоритмХеширования = Константы.АлгоритмХеширования.Получить();
	Настройки.Вставить("АлгоритмХеширования", АлгоритмХеширования);
	АлгоритмШифрования = Константы.АлгоритмШифрования.Получить();
	Настройки.Вставить("АлгоритмШифрования", АлгоритмШифрования);
	
	ПутьМодуляКриптографии = ОбщегоНазначения.ХранилищеОбщихНастроекЗагрузить("ЭЦП", "ПутьМодуляКриптографии");
	Если ПутьМодуляКриптографии = Неопределено Тогда
		ПутьМодуляКриптографии = "";
	КонецЕсли;
	Настройки.Вставить("ПутьМодуляКриптографии", ПутьМодуляКриптографии);
	
	ДействияПриСохраненииСЭЦП = ОбщегоНазначения.ХранилищеОбщихНастроекЗагрузить("ЭЦП", "ДействияПриСохраненииСЭЦП");
	Если ДействияПриСохраненииСЭЦП = Неопределено Тогда
		ДействияПриСохраненииСЭЦП = Перечисления.ДействияПриСохраненииСЭЦП.Спрашивать;
	КонецЕсли;
	
	СтрокаДействияПриСохраненииСЭЦП = "";
	Если ДействияПриСохраненииСЭЦП = Перечисления.ДействияПриСохраненииСЭЦП.Спрашивать Тогда
		СтрокаДействияПриСохраненииСЭЦП = "Спрашивать";
	ИначеЕсли ДействияПриСохраненииСЭЦП = Перечисления.ДействияПриСохраненииСЭЦП.СохранятьВсеПодписи Тогда
		СтрокаДействияПриСохраненииСЭЦП = "СохранятьВсеПодписи";
	КонецЕсли;
	
	Настройки.Вставить("ДействияПриСохраненииСЭЦП", СтрокаДействияПриСохраненииСЭЦП);
	
	РасширениеДляФайловПодписи = ОбщегоНазначения.ХранилищеОбщихНастроекЗагрузить("ЭЦП", "РасширениеДляФайловПодписи");
	Если РасширениеДляФайловПодписи = Неопределено ИЛИ ПустаяСтрока(РасширениеДляФайловПодписи) Тогда
		РасширениеДляФайловПодписи = "p7s";
	КонецЕсли;
	Настройки.Вставить("РасширениеДляФайловПодписи", РасширениеДляФайловПодписи);

	РасширениеДляЗашифрованныхФайлов = ОбщегоНазначения.ХранилищеОбщихНастроекЗагрузить("ЭЦП", "РасширениеДляЗашифрованныхФайлов");
	Если РасширениеДляЗашифрованныхФайлов = Неопределено ИЛИ ПустаяСтрока(РасширениеДляЗашифрованныхФайлов) Тогда
		РасширениеДляЗашифрованныхФайлов = "p7m";
	КонецЕсли;
	Настройки.Вставить("РасширениеДляЗашифрованныхФайлов", РасширениеДляЗашифрованныхФайлов);	
	
	Возврат Настройки; 
	
КонецФункции

// Преобразует назначения сертификатов в дружественный вид
// Параметры
//  Назначение  - Строка - назначение сертификата вида "TLS Web Client Authentication (1.3.6.1.5.5.7.3.2)"
//  НовоеНазначение  - Строка - удобное для понимания назначение сертификата вида "Проверка подлинности клиента"
//  ДобавлятьКодНазначения  - Булево - надо ли добавлять к назначению код назначения 
//    (например 1.3.6.1.5.5.7.3.2, чтобы получилось "Проверка подлинности клиента (1.3.6.1.5.5.7.3.2)")
Процедура ЗаполнитьНазначениеСертификата(Назначение, НовоеНазначение, ДобавлятьКодНазначения = Ложь) Экспорт
	
	УстановитьПривилегированныйРежим(Истина);
	НовоеНазначение = "";
	
	Для Индекс = 1 По СтрЧислоСтрок(Назначение) Цикл
		
		Строка = СтрПолучитьСтроку(Назначение, Индекс); 		
		Представление = Назначение;
		Код = "";
		
		Позиция = СтроковыеФункцииКлиентСервер.НайтиСимволСКонца(Строка, "(");
		Если Позиция <> 0 Тогда
			
			Представление = Лев(Строка, Позиция - 1);
			Код = Сред(Строка, Позиция + 1, СтрДлина(Строка) - Позиция - 1);
			
			СпрСсылка = Справочники.НазначенияСертификатовЭЦП.НайтиПоКоду(Код);
			Если СпрСсылка <> Неопределено И НЕ СпрСсылка.Пустая() Тогда
				Представление = СпрСсылка.Наименование;
			КонецЕсли;	
			
			Если ДобавлятьКодНазначения Тогда
				Представление = Представление  + " (" + Код + ")";
			КонецЕсли;
			
		КонецЕсли;		
		
		НовоеНазначение = НовоеНазначение + Представление;
		НовоеНазначение = НовоеНазначение + Символы.ПС;
		
	КонецЦикла;	
	
КонецПроцедуры


// Получает все подписи файла
//
// Параметры
//  СсылкаНаОбъект  - СправочникСсылка - ссылка объект, в табличной части которого содержатся подписи
//  УникальныйИдентификатор - УникальныйИдентификатор - уникальный идентификатор формы
//
// Возвращаемое значение:
//  МассивВозврата - Массив  - массив структур с возвращаемыми значениями
//
Функция ПолучитьВсеПодписи(СсылкаНаОбъект, УникальныйИдентификатор) Экспорт
	
	МассивВозврата = Новый Массив;
	
	//ВерсияСсылка = ОбщегоНазначения.ПолучитьЗначениеРеквизита(ФайлСсылка, "ТекущаяВерсия");
	ПолноеИмяОбъектаСЭЦП = СсылкаНаОбъект.Метаданные().ПолноеИмя();
	
	ТекстЗапроса = "ВЫБРАТЬ РАЗРЕШЕННЫЕ
					|	ЭлектронныеЦифровыеПодписи.КомуВыданСертификат КАК КомуВыданСертификат,
					|	ЭлектронныеЦифровыеПодписи.Подпись             КАК Подпись,
					|	ЭлектронныеЦифровыеПодписи.ИмяФайлаПодписи     КАК ИмяФайлаПодписи
					|ИЗ
					|	[ПолноеИмяОбъектаСЭЦП].ЭлектронныеЦифровыеПодписи КАК ЭлектронныеЦифровыеПодписи
					|ГДЕ
					|	ЭлектронныеЦифровыеПодписи.Ссылка = &СсылкаНаОбъект";
	
	ТекстЗапроса = СтрЗаменить(ТекстЗапроса, "[ПолноеИмяОбъектаСЭЦП]", ПолноеИмяОбъектаСЭЦП);
	
	Запрос = Новый Запрос;
	Запрос.Текст = ТекстЗапроса;
	Запрос.Параметры.Вставить("СсылкаНаОбъект", СсылкаНаОбъект);
	
	ВыборкаЗапроса = Запрос.Выполнить().Выбрать();
	
	Пока ВыборкаЗапроса.Следующий() Цикл
		ДвоичныеДанные = ВыборкаЗапроса.Подпись.Получить();
		АдресПодписи = ПоместитьВоВременноеХранилище(ДвоичныеДанные, УникальныйИдентификатор);
		СтруктураВозврата = Новый Структура("АдресПодписи, КомуВыданСертификат, ИмяФайлаПодписи",
											АдресПодписи,
											ВыборкаЗапроса.КомуВыданСертификат,
											ВыборкаЗапроса.ИмяФайлаПодписи);
		МассивВозврата.Добавить(СтруктураВозврата);
	КонецЦикла;
	
	Возврат МассивВозврата;
	
КонецФункции

// Возвращает структурe данных из файла подписи
//
// Параметры
//  Подпись - ДвоичныеДанные - файл подписи.
//
// Возвращаемое значение
//  Структура:
//   Отпечаток                 - Строка
//   КомуВыданСертификат       - Строка
//   ДвоичныеДанныеСертификата - ДвоичныеДанные
//   Подпись                   - ХранилищеЗначения
//   Сертификат                - ХранилищеЗначения
//
// При возникновении ошибок разбора подписи возвращает Неопределено.
Функция ПрочитатьДанныеПодписи(Подпись) Экспорт
	
	Результат = Неопределено;
		
	МенеджерКриптографии = СоздатьМенеджерКриптографии();
	Если МенеджерКриптографии = Неопределено Тогда
		Возврат Результат;
	КонецЕсли;
	
	Попытка
		Сертификаты = МенеджерКриптографии.ПолучитьСертификатыИзПодписи(Подпись);
	Исключение
		Возврат Результат;
	КонецПопытки;
		
	Если Сертификаты.Количество() > 0 Тогда
		Сертификат = Сертификаты[0];
			
		Результат = Новый Структура;
		Результат.Вставить("Отпечаток", Base64Строка(Сертификат.Отпечаток));
		Результат.Вставить("КомуВыданСертификат", ЭлектроннаяЦифроваяПодписьКлиентСервер.ПолучитьПредставлениеПользователя(Сертификат.Субъект));
		Результат.Вставить("ДвоичныеДанныеСертификата", Сертификат.Выгрузить());
		Результат.Вставить("Подпись", Новый ХранилищеЗначения(Подпись));
		Результат.Вставить("Сертификат", Новый ХранилищеЗначения(Сертификат.Выгрузить()));
	КонецЕсли;
	
	Возврат Результат;
    
КонецФункции

Функция СоздатьМенеджерКриптографии()
	
	Настройки = ПолучитьПерсональныеНастройкиРаботыСЭЦПСервер();

	Если Не Настройки.ВыполнятьПроверкуЭЦПНаСервере Тогда
		Возврат Неопределено;
	КонецЕсли;
	
	Попытка
		МенеджерКриптографии = Новый МенеджерКриптографии(Настройки.ПровайдерЭЦП, Настройки.ПутьМодуляКриптографии, Настройки.ТипПровайдераЭЦП);		
	Исключение
		Возврат Неопределено;
	КонецПопытки;
	
	ЗаполнитьЗначенияСвойств(МенеджерКриптографии, Настройки);

	Возврат МенеджерКриптографии;
	
КонецФункции

////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ ОБНОВЛЕНИЯ ИНФОРМАЦИОННОЙ БАЗЫ

// Добавляет в список Обработчики процедуры-обработчики обновления,
// необходимые данной подсистеме.
//
// Параметры:
//   Обработчики - ТаблицаЗначений - см. описание функции НоваяТаблицаОбработчиковОбновления
//                                   общего модуля ОбновлениеИнформационнойБазы.
// 
Процедура ЗарегистрироватьОбработчикиОбновления(Обработчики) Экспорт
	
	Обработчик = Обработчики.Добавить();
	Обработчик.Версия = "1.0.7.1";
	Обработчик.Процедура = "ЭлектроннаяЦифроваяПодпись.ЗаполнитьНазначенияСертификатовЭЦП";
	
	Обработчик = Обработчики.Добавить();
	Обработчик.Версия = "1.1.1.8";
	Обработчик.Процедура = "ЭлектроннаяЦифроваяПодпись.УдалитьСтарыеИЗаполнитьНазначенияСертификатовЭЦП";
	
КонецПроцедуры	

// Заполняет справочник НазначенияСертификатовЭЦП значениями из макета
Процедура УдалитьСтарыеИЗаполнитьНазначенияСертификатовЭЦП() Экспорт
	
	УстановитьПривилегированныйРежим(Истина);
	
	МакетУдаленный = Справочники.НазначенияСертификатовЭЦП.ПолучитьМакет("УдаленныйНазначенияСертификатов");
	ТабЗначенийУдаленный = ОбщегоНазначения.ПрочитатьXMLВТаблицу(МакетУдаленный.ПолучитьТекст()).Данные;
	
	Макет = Справочники.НазначенияСертификатовЭЦП.ПолучитьМакет("НазначенияСертификатов");
	ТабЗначений = ОбщегоНазначения.ПрочитатьXMLВТаблицу(Макет.ПолучитьТекст()).Данные;
	
	НачатьТранзакцию();
	Попытка
		
		Для Каждого Запись Из ТабЗначенийУдаленный Цикл
			
			СпрСсылка = Справочники.НазначенияСертификатовЭЦП.НайтиПоКоду(Запись.Code);
			Если СпрСсылка <> Неопределено И НЕ СпрСсылка.Пустая() Тогда
				
				СправочникОбъект = СпрСсылка.ПолучитьОбъект();
				СправочникОбъект.УстановитьПометкуУдаления(Истина);
				
			КонецЕсли;
			
		КонецЦикла;	
		
		Для Каждого Запись Из ТабЗначений Цикл
			
			СпрСсылка = Справочники.НазначенияСертификатовЭЦП.НайтиПоКоду(Запись.Code);
			Если СпрСсылка = Неопределено ИЛИ СпрСсылка.Пустая() Тогда
				Элемент = Справочники.НазначенияСертификатовЭЦП.СоздатьЭлемент();
				Элемент.Код = Запись.Code;
				Элемент.Наименование = Запись.Name;
				Элемент.Записать();
			КонецЕсли;	
			
		КонецЦикла;	
		
		ЗафиксироватьТранзакцию();
	Исключение
		ОтменитьТранзакцию();
		ВызватьИсключение;
	КонецПопытки;
	
КонецПроцедуры	

// Заполняет справочник НазначенияСертификатовЭЦП значениями из макета
Процедура ЗаполнитьНазначенияСертификатовЭЦП() Экспорт
	
	УстановитьПривилегированныйРежим(Истина);
	Макет = Справочники.НазначенияСертификатовЭЦП.ПолучитьМакет("НазначенияСертификатов");
	ТабЗначений = ОбщегоНазначения.ПрочитатьXMLВТаблицу(Макет.ПолучитьТекст()).Данные;
	
	НачатьТранзакцию();
	Попытка
		
		Для Каждого Запись Из ТабЗначений Цикл
			
			СпрСсылка = Справочники.НазначенияСертификатовЭЦП.НайтиПоКоду(Запись.Code);
			Если СпрСсылка = Неопределено ИЛИ СпрСсылка.Пустая() Тогда
				Элемент = Справочники.НазначенияСертификатовЭЦП.СоздатьЭлемент();
				Элемент.Код = Запись.Code;
				Элемент.Наименование = Запись.Name;
				Элемент.Записать();
			КонецЕсли;	
			
		КонецЦикла;	
		
		ЗафиксироватьТранзакцию();
	Исключение
		ОтменитьТранзакцию();
		ВызватьИсключение;
	КонецПопытки;
	
КонецПроцедуры	
