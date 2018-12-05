﻿
&НаКлиенте
Процедура ВидЗаявкиПриИзменении(Элемент)
	УстановитьВидимость();
	Если Объект.Срочность=ПредопределенноеЗначение("Справочник.СрочностьВыполненияЗаявкиНаРемонт.Срочно") Тогда
		Объект.Дата=ТекущаяДата();
	КонецЕсли; 
	Если Объект.ВидЗаявки=ПредопределенноеЗначение("Перечисление.ВидыЗаявокНаРемонт.РемонтХолодильников")  Тогда
		Объект.Подгруппа=Неопределено;
		Объект.ИсполнительФизЛицо=Неопределено;
		Объект.ОбъектРемонта=Неопределено;
		Объект.ПодтвержденоПомощником=Неопределено;
		Объект.ОбъектыРемонта.Очистить();
		
		МагазинПриИзмененииСервер();
	Иначе
		Объект.ИсполнительКонтрагент=Неопределено;
	КонецЕсли; 
КонецПроцедуры

&НаКлиенте
Процедура УстановитьВидимость()
	Если Объект.ВидЗаявки=ПредопределенноеЗначение("Перечисление.ВидыЗаявокНаРемонт.РемонтХолодильников")Тогда
		Элементы.ИсполнительКонтрагент.Видимость=Истина;
		Элементы.ИсполнительФизЛицо.Видимость=Ложь;
		Если ЗначениеЗаполнено(Объект.ИсполнительФизЛицо) Тогда
			Объект.ИсполнительФизЛицо=Неопределено;
		КонецЕсли; 
		//Элементы.Подгруппа.Видимость=Ложь;
		//Элементы.ОбъектРемонта.Видимость=Ложь;
		Элементы.ПодтвержденоПомощником.Видимость=Ложь;
		Элементы.ОбъектыРемонта.Видимость=Ложь;
	Иначе
		Элементы.ИсполнительКонтрагент.Видимость=Ложь;
		Элементы.ИсполнительФизЛицо.Видимость=Истина;
		Если ЗначениеЗаполнено(Объект.ИсполнительКонтрагент) Тогда
			Объект.ИсполнительКонтрагент=Неопределено;
		КонецЕсли; 
		//Элементы.Подгруппа.Видимость=Истина;
		//Элементы.ОбъектРемонта.Видимость=Истина;
		Элементы.ОбъектыРемонта.Видимость=Истина;
		Элементы.ПодтвержденоПомощником.Видимость=Истина;
	КонецЕсли; 
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	УстановитьВидимость();
	//+++АК sils 08.06.2018 ИП-00018876
	APDEX_ОценкаПроизводительностиКлиентСервер.ЗакончитьЗамерВремени(ОперацияАпдекс, ?(Параметры.Ключ.Пустая(), "Новый документ", "" + Объект.Ссылка));
	//---АК
КонецПроцедуры

&НаКлиенте
Процедура ФайлыИмяФайлаНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	//ДиалогВыбора = Новый ДиалогВыбораФайла(РежимДиалогаВыбораФайла.Открытие);
	//Если ДиалогВыбора.Выбрать() Тогда
	//	Элементы.Файлы.ТекущиеДанные.ИмяФайла = ДиалогВыбора.ПолноеИмяФайла;
	//КонецЕсли;	
	
	
	
	Режим = РежимДиалогаВыбораФайла.Открытие;
	ДиалогФайла = Новый ДиалогВыбораФайла(Режим);
	
	ДиалогФайла.МножественныйВыбор = Ложь;
	ДиалогФайла.ПроверятьСуществованиеФайла = Истина;
	
	Если ДиалогФайла.Выбрать() Тогда
		
		ПолноеИмяФайла   = ДиалогФайла.ПолноеИмяФайла;
		ИмяФайлаСРасширением = ПолучитьСтрокуОтделеннойСимволом(ПолноеИмяФайла, "\");
		Расширение = ПроцедурыОбменаДанными.ПолучитьРасширениеИмениФайла(ПолноеИмяФайла);
		
		АдресВременногоХранилища = "";
		Если ПоместитьФайл(АдресВременногоХранилища, ПолноеИмяФайла,, Ложь)Тогда
			ИмяФайла="";
			ЗаписатьФайлНаСервере(АдресВременногоХранилища, ИмяФайлаСРасширением, Расширение,ИмяФайла);
			Элементы.Файлы.ТекущиеДанные.ИмяФайла = ИмяФайла;
		Иначе 
			Сообщить(НСтр("ru = 'Не удалось добавить файл.'"));
		КонецЕсли;
		
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
// функция возвращает часть строки после последнего встреченного символа в строке
Функция ПолучитьСтрокуОтделеннойСимволом(Знач ИсходнаяСтрока, Знач СимволПоиска)
	
	ПозицияСимвола = СтрДлина(ИсходнаяСтрока);
	Пока ПозицияСимвола >= 1 Цикл
		
		Если Сред(ИсходнаяСтрока, ПозицияСимвола, 1) = СимволПоиска Тогда
			
			Возврат Сред(ИсходнаяСтрока, ПозицияСимвола + 1); 
			
		КонецЕсли;
		
		ПозицияСимвола = ПозицияСимвола - 1;	
	КонецЦикла;
	
	Возврат "";
	
КонецФункции

&НаСервере
Процедура ЗаписатьФайлНаСервере(АдресВременногоХранилища, ИмяФайлаСРасширением, Расширение,ИмяФайла)
	
	ДвоичныеДанные = ПолучитьИзВременногоХранилища(АдресВременногоХранилища);
	
	Попытка
		КаталогХраненияФайлов = ПолучитьКаталогХраненияФайлов();
		
		Если Прав(КаталогХраненияФайлов, 1) <> "\" Тогда
			КаталогХраненияФайлов = КаталогХраненияФайлов + "\";
		КонецЕсли;
		
	Исключение
		Сообщить(НСтр("ru = 'Не удалось получить каталог хранения файлов.'"));
		Возврат;
		
	КонецПопытки;
	
	УникальноеИмяФайла = Новый УникальныйИдентификатор;
	ИмяФайлаНаСервере = КаталогХраненияФайлов + УникальноеИмяФайла + "." + Расширение;
	
	Попытка
		
		ДвоичныеДанные.Записать(ИмяФайлаНаСервере);
		
		ИмяФайла = ИмяФайлаНаСервере;
		ИмяФайлаСРасширением = ИмяФайлаСРасширением;
		
		Модифицированность = Истина;
		
	Исключение
		Сообщить(НСтр("ru = 'Не удалось добавить файл.'"));
	КонецПопытки;
	
КонецПроцедуры

&НаСервере
Функция ПолучитьКаталогХраненияФайлов()
	
	Возврат Константы.КаталогХраненияФайлов.Получить();	
	
КонецФункции



&НаКлиенте
Процедура ФайлыИмяФайлаОткрытие(Элемент, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	Если Элемент = Элементы.ФайлыИмяФайла Тогда
		ЗапуститьПриложение(Папка()+Элементы.Файлы.ТекущиеДанные.ОтносительноеИмяФайла);
	ИначеЕсли Элемент = Элементы.ФайлыИсполнителяИмяФайла Тогда
		ЗапуститьПриложение(Папка()+Элементы.ФайлыИсполнителя.ТекущиеДанные.ОтносительноеИмяФайла);
	КонецЕсли;	
	
КонецПроцедуры

Функция Папка()
	Если ЗначениеЗаполнено(Объект.ИД) Тогда
		Возврат "\\10.0.0.51\1c$\";
	Иначе	
		Возврат СокрЛП(Константы.МП_КаталогХраненияФайловЗадачМП.Получить())+"\";
	КонецЕсли; 
	
	
КонецФункции // ()


&НаКлиенте
Процедура МагазинПриИзменении(Элемент)
	Если  Объект.ВидЗаявки=ПредопределенноеЗначение("Перечисление.ВидыЗаявокНаРемонт.РемонтХолодильников") Тогда
		МагазинПриИзмененииСервер();
	КонецЕсли; 
	
КонецПроцедуры

&НаСервере
Процедура МагазинПриИзмененииСервер()
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	АК_УсловияРегламентныхРаботСрезПоследних.Регистратор,
	|	АК_УсловияРегламентныхРаботСрезПоследних.Контрагент,
	|	АК_УсловияРегламентныхРаботСрезПоследних.Услуга,
	|	АК_УсловияРегламентныхРаботСрезПоследних.СтруктурнаяЕдиница,
	|	АК_УсловияРегламентныхРаботСрезПоследних.Стоимость,
	|	АК_УсловияРегламентныхРаботСрезПоследних.ФормаОплаты,
	|	АК_УсловияРегламентныхРаботСрезПоследних.ДатаНачала,
	|	АК_УсловияРегламентныхРаботСрезПоследних.ДатаОкончания,
	|	АК_УсловияРегламентныхРаботСрезПоследних.ЧислоОплаты,
	|	АК_УсловияРегламентныхРаботСрезПоследних.ПериодОплаты,
	|	АК_УсловияРегламентныхРаботСрезПоследних.ДоговорКонтрагента,
	|	АК_УсловияРегламентныхРаботСрезПоследних.Статус,
	|	АК_УсловияРегламентныхРаботСрезПоследних.Периодичность
	|ИЗ
	|	РегистрСведений.АК_УсловияРегламентныхРабот.СрезПоследних(
	|			&Дата,
	|			СтруктурнаяЕдиница = &СтруктурнаяЕдиница
	|				И Услуга = &Услуга) КАК АК_УсловияРегламентныхРаботСрезПоследних
	|ГДЕ
	|	АК_УсловияРегламентныхРаботСрезПоследних.Статус = &Статус";
	
	Запрос.УстановитьПараметр("Дата", Объект.Дата);
	Запрос.УстановитьПараметр("СтруктурнаяЕдиница", Объект.Магазин);
	Запрос.УстановитьПараметр("Услуга", Справочники.Номенклатура.НайтиПоКоду("000615698"));
	Запрос.УстановитьПараметр("Статус", Перечисления.СтатусыДоговоровКонтрагентов.Действует);
	Результат = Запрос.Выполнить();
	
	ВыборкаДетальныеЗаписи = Результат.Выбрать();
	
	Пока ВыборкаДетальныеЗаписи.Следующий() Цикл
		Объект.ИсполнительКонтрагент=ВыборкаДетальныеЗаписи.Контрагент;
	КонецЦикла;
	
	
КонецПроцедуры

&НаКлиенте
Процедура ФайлыПередНачаломДобавления(Элемент, Отказ, Копирование, Родитель, Группа)
	
	Отказ = Истина;
	
	ДиалогОткрытияФайла = Новый ДиалогВыбораФайла(РежимДиалогаВыбораФайла.Открытие);
	ДиалогОткрытияФайла.Заголовок = "Выберите файл с фотографией";
	ДиалогОткрытияФайла.ПолноеИмяФайла = "";
	ДиалогОткрытияФайла.ПредварительныйПросмотр = Истина;
	ДиалогОткрытияФайла.ПроверятьСуществованиеФайла = Истина;
	ДиалогОткрытияФайла.Фильтр = 
	"Все картинки (*.bmp;*.dib;*.rle;*.jpg;*.jpeg;*.tif;*.gif;*.png;*.ico;*.wmf;*.emf)|*.bmp;*.dib;*.rle;*.jpg;*.jpeg;*.tif;*.gif;*.png;*.ico;*.wmf;*.emf|" 
	+ "Формат bmp (*.bmp;*.dib;*.rle)|*.bmp;*.dib;*.rle|"
	+ "Формат JPEG (*.jpg;*.jpeg)|*.jpg;*.jpeg|"
	+ "Формат TIFF (*.tif)|*.tif|"
	+ "Формат GIF (*.gif)|*.gif|"
	+ "Формат PNG (*.png)|*.png|"
	+ "Формат icon (*.ico)|*.ico|"
	+ "Формат метафайл (*.wmf;*.emf)|*.wmf;*.emf|"; // картинки
	
	Если ДиалогОткрытияФайла.Выбрать() = Ложь Тогда
		Возврат;
	КонецЕсли;
	
	ФайлКартинки = Новый Файл(ДиалогОткрытияФайла.ПолноеИмяФайла);
	ИдентификаторФотографии = Строка(Новый УникальныйИдентификатор);
	ДанныеФотографии = Новый Структура("ИдентификаторФотографии, Расширение", ИдентификаторФотографии, ФайлКартинки.Расширение);
	
	ОтносительноеИмяФайла = ОбменМобильноеПриложениеПереопределяемый.ОбновитьФайлФотографииНаДиске(Новый ДвоичныеДанные(ФайлКартинки.ПолноеИмя), Объект.Ссылка, ДанныеФотографии);
	Если ОтносительноеИмяФайла = Неопределено Тогда
		Предупреждение("Ошибка при добавлении фотографии!");
		Возврат;
	КонецЕсли;
	
	Если Элемент = Элементы.Файлы Тогда
		СтрокаФотографии = Объект.Файлы.Добавить();
	ИначеЕсли Элемент = Элементы.ФайлыИсполнителя Тогда
		СтрокаФотографии = Объект.ФайлыИсполнителя.Добавить();
	Иначе
		Возврат;
	КонецЕсли;
	СтрокаФотографии.ИмяФайла = ФайлКартинки.Имя;
	СтрокаФотографии.ИдентификаторФотографии = ИдентификаторФотографии;
	СтрокаФотографии.ОтносительноеИмяФайла = ОтносительноеИмяФайла;
	
КонецПроцедуры

&НаКлиенте
Процедура ФайлыПередУдалением(Элемент, Отказ)
	ТекущиеДанные = Элемент.ТекущиеДанные;
	Если ТекущиеДанные = Неопределено Тогда Возврат; КонецЕсли;
	
	Если Вопрос("Удалить фотографию?", РежимДиалогаВопрос.ДаНетОтмена,,, "Заявка на ремонт") <> КодВозвратаДиалога.Да Тогда
		Отказ = Истина;
		Возврат;
	КонецЕсли;
	
	Если НЕ ПустаяСтрока(ТекущиеДанные.ОтносительноеИмяФайла) Тогда
		УдалитьФотографиюНаСервере(ТекущиеДанные.ОтносительноеИмяФайла);
	КонецЕсли;
	
КонецПроцедуры


&НаСервереБезКонтекста
Процедура УдалитьФотографиюНаСервере(ОтносительноеИмяФайла)
	
	КаталогФотографий = СокрЛП(Константы.МП_КаталогХраненияФайловЗадачМП.Получить());
	Если Прав(КаталогФотографий, 1) <> "\" Тогда
		КаталогФотографий = КаталогФотографий + "\";
	КонецЕсли;
	
	ФайлКартинки = Новый Файл(КаталогФотографий + ОтносительноеИмяФайла);
	Если ФайлКартинки.Существует() Тогда
		УдалитьФайлы(ФайлКартинки.ПолноеИмя);
	КонецЕсли;
	
КонецПроцедуры


&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	//+++АК sils 08.06.2018 ИП-00018876
	ОперацияАпдекс = APDEX_ОценкаПроизводительностиКлиентСервер.ПолучитьОперацию("Открытие документа Заявка на ремонт");
	APDEX_ОценкаПроизводительностиКлиентСервер.НачатьЗамерВремени(ОперацияАпдекс);
	//---АК
	УстановитьПривилегированныйРежим(Истина);
	ЭтоМагазин=РольДоступна("Продавец") ИЛИ РольДоступна("ПродавецТолькоПросмотр");
	Объект.Автор=Неопределено;
	Если НЕ ЗначениеЗаполнено(Объект.Ссылка)  Тогда
		Если ЭтоМагазин Тогда
			Объект.Магазин=ПараметрыСеанса.ТорговаяТочкаПоАйпи;
			Элементы.Магазин.ТолькоПросмотр=Истина;
			
			Запрос = Новый Запрос;
			Запрос.Текст = 
			"ВЫБРАТЬ
			|	ТабельРаботыПродавцов.Сотрудник
			|ИЗ
			|	РегистрСведений.ТабельРаботыПродавцов КАК ТабельРаботыПродавцов
			|ГДЕ
			|	ТабельРаботыПродавцов.Период = &Период
			|	И ТабельРаботыПродавцов.СвойствоПродавца = 2
			|	И ТабельРаботыПродавцов.ТорговаяТочка = &ТорговаяТочка
			|	И ТабельРаботыПродавцов.Отсутствие = Значение(Перечисление.ВидыОтсутствия.ПустаяСсылка)";
			
			Запрос.УстановитьПараметр("Период", НачалоДня(ТекущаяДата()));
			Запрос.УстановитьПараметр("ТорговаяТочка", Объект.Магазин);
			
			РезультатЗапроса = Запрос.Выполнить();
			
			ВыборкаДетальныеЗаписи = РезультатЗапроса.Выбрать();
			
			Если ВыборкаДетальныеЗаписи.Следующий() Тогда
				Объект.Автор=ВыборкаДетальныеЗаписи.Сотрудник;
			КонецЕсли;
			Элементы.ПодтвержденоПомощником.Доступность=Ложь;
		Иначе
			Объект.Автор=ПараметрыСеанса.ТекущийПользователь.ФизЛицо;
		КонецЕсли; 
	КонецЕсли; 
	
	Если  НЕ ЗначениеЗаполнено(Объект.Ссылка) Тогда
		Объект.ИД="";
	КонецЕсли; 
	
	Если Не РольДоступна("ПолныеПрава") И Не ЭтоМагазин Тогда
		Запрос = Новый Запрос;
		Запрос.Текст = 
		"ВЫБРАТЬ
		|	РолиПользователейТипыРолей.ТипРоли,
		|	РолиПользователейСоставРоли.Ссылка
		|ИЗ
		|	Справочник.РолиПользователей.ТипыРолей КАК РолиПользователейТипыРолей
		|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ Справочник.РолиПользователей.СоставРоли КАК РолиПользователейСоставРоли
		|		ПО РолиПользователейТипыРолей.Ссылка = РолиПользователейСоставРоли.Ссылка
		|ГДЕ
		|	РолиПользователейТипыРолей.ТипРоли В(&ТипРоли)
		|	И РолиПользователейСоставРоли.Сотрудник = &Сотрудник
		|	И РолиПользователейСоставРоли.Ссылка.ПометкаУдаления = ЛОЖЬ";
		
		Запрос.УстановитьПараметр("Сотрудник", ПараметрыСеанса.ТекущийПользователь.ФизЛицо);
		МасТР=Новый Массив;
		РольУпр=ПланыВидовХарактеристик.ТипыРолейПользователя.НайтиПоНаименованию("Управляющий по рознице");
		МасТР.Добавить(ПланыВидовХарактеристик.ТипыРолейПользователя.ПомощникТерриториальногоУправляющего);
		//+++ AK suvv 2018.06.08 ИП-00018376.01
		МасТР.Добавить(ПланыВидовХарактеристик.ТипыРолейПользователя.ПомощникСтороннейРозницы);
		//--- AK suvv
		МасТР.Добавить(РольУпр);
		Запрос.УстановитьПараметр("ТипРоли", МасТР);
		
		РезультатЗапроса = Запрос.Выполнить();
		
		ВыборкаДетальныеЗаписи = РезультатЗапроса.Выбрать();
		ЭтоУправляющий=Ложь;
		ЭтоПомощник=Ложь;
		МассивРолей=Новый Массив;
		Пока ВыборкаДетальныеЗаписи.Следующий() Цикл
			Если ВыборкаДетальныеЗаписи.ТипРоли=РольУпр Тогда
				ЭтоУправляющий=Истина;
				МассивРолей.Добавить(ВыборкаДетальныеЗаписи.ссылка);	
			//+++ AK suvv 2018.06.08 ИП-00018376.01
			//ИначеЕсли  ВыборкаДетальныеЗаписи.ТипРоли=ПланыВидовХарактеристик.ТипыРолейПользователя.ПомощникТерриториальногоУправляющего Тогда
			ИначеЕсли  ВыборкаДетальныеЗаписи.ТипРоли=ПланыВидовХарактеристик.ТипыРолейПользователя.ПомощникТерриториальногоУправляющего
				ИЛИ ВыборкаДетальныеЗаписи.ТипРоли=ПланыВидовХарактеристик.ТипыРолейПользователя.ПомощникСтороннейРозницы Тогда
			//--- AK suvv
				ЭтоПомощник=Истина;
				МассивРолей.Добавить(ВыборкаДетальныеЗаписи.ссылка);	
			КонецЕсли; 
		КонецЦикла;
		
		Запрос = Новый Запрос;
		Запрос.Текст = 
		"ВЫБРАТЬ РАЗЛИЧНЫЕ
		|	СоответствиеОбъектРольСрезПоследних.Объект КАК Объект,
		|	Выразить(СоответствиеОбъектРольСрезПоследних.Объект как Справочник.структурныеЕдиницы).НомерТочки КАК ОбъектНомерТочки
		|ИЗ
		|	РегистрСведений.СоответствиеОбъектРоль.СрезПоследних(
		|			,
		|			ТипРоли = &ТипРоли
		//+++ AK suvv 2018.06.08 ИП-00018376.01
		|           ИЛИ ТипРоли = &ТипРолиСторонняяРозница
		//--- AK suvv
		|				ИЛИ ТипРоли = &ТипРоли1) КАК СоответствиеОбъектРольСрезПоследних
		|ГДЕ
		|	СоответствиеОбъектРольСрезПоследних.РольПользователя В ИЕРАРХИИ(&РольПользователя)
		|
		|УПОРЯДОЧИТЬ ПО
		|	ОбъектНомерТочки";
		
		Запрос.УстановитьПараметр("РольПользователя", МассивРолей);
		Запрос.УстановитьПараметр("ТипРоли", ПланыВидовХарактеристик.ТипыРолейПользователя.ПомощникТерриториальногоУправляющего);
		Запрос.УстановитьПараметр("ТипРоли1", РольУпр);
		//+++ AK suvv 2018.06.08 ИП-00018376.01
		Запрос.УстановитьПараметр("ТипРолиСторонняяРозница", ПланыВидовХарактеристик.ТипыРолейПользователя.ПомощникСтороннейРозницы);
		//--- AK suvv
		
		РезультатЗапроса = Запрос.Выполнить();
		
		ВыборкаДетальныеЗаписи = РезультатЗапроса.Выбрать();
		СписокМагазинов=Новый СписокЗначений;
		Пока ВыборкаДетальныеЗаписи.Следующий() Цикл
			СписокМагазинов.Добавить(ВыборкаДетальныеЗаписи.Объект);
		КонецЦикла;
		ЭтоПомощник=Ложь;
		Если СписокМагазинов.Количество() Тогда
			Элементы.Магазин.РежимВыбораИзСписка=Истина;
			Для каждого Эл Из  СписокМагазинов Цикл
				Элементы.Магазин.СписокВыбора.Добавить(Эл.Значение);
			КонецЦикла; 
			ЭтоПомощник=Истина;
			
		КонецЕсли; 
		
		Запрос = Новый Запрос;
		Запрос.Текст = 
		"ВЫБРАТЬ
		|	РолиПользователейСоставРоли.Ссылка
		|ИЗ
		|	Справочник.РолиПользователей.СоставРоли КАК РолиПользователейСоставРоли
		|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ Справочник.РолиПользователей.ТипыРолей КАК РолиПользователейТипыРолей
		|		ПО РолиПользователейСоставРоли.Ссылка = РолиПользователейТипыРолей.Ссылка
		|ГДЕ
		|	РолиПользователейСоставРоли.Сотрудник = &Сотрудник
		|	И РолиПользователейТипыРолей.ТипРоли = &ТипРоли";
		
		Запрос.УстановитьПараметр("Сотрудник", ПараметрыСеанса.ТекущийПользователь.ФизЛицо);
		Запрос.УстановитьПараметр("ТипРоли", ПланыВидовХарактеристик.ТипыРолейПользователя.АК_НачальникЭксплуатации);
		
		РезультатЗапроса = Запрос.Выполнить();
		
		
		Если НЕ РезультатЗапроса.Пустой() Тогда
		Иначе
			Элементы.ИсполнительКонтрагент.Доступность=Ложь;
			Элементы.ИсполнительФизЛицо.Доступность=Ложь;
		КонецЕсли;
		Элементы.ПодвержденоИсполнителем.Доступность=Ложь;
		Элементы.ОтветПолучен.Доступность=Ложь;
		Элементы.Выполнено.Доступность=Ложь;
		Элементы.ВыполнениеПодтверждено.Доступность= ЭтоМагазин;
		Элементы.ПодтвержденоПомощником.Доступность=ЭтоПомощник;
	КонецЕсли;
КонецПроцедуры


&НаКлиенте
Процедура ПередЗаписью(Отказ, ПараметрыЗаписи)
	Если Объект.ВидЗаявки=ПредопределенноеЗначение("Перечисление.ВидыЗаявокНаРемонт.РемонтХолодильников") И НЕ ЗначениеЗаполнено(Объект.ИсполнительКонтрагент) Тогда
		Отказ=Истина;
		Сообщить(НСтр("ru = 'Выберите ремонтную компанию'"));
	КонецЕсли; 
	Если Объект.ВидЗаявки=ПредопределенноеЗначение("Перечисление.ВидыЗаявокНаРемонт.ТекущийРемонт") Тогда
		Если Объект.ОбъектыРемонта.Количество()=0 Тогда
			Отказ=Истина;
			Сообщить(НСтр("ru = 'Не заполнена подгруппа или объект ремонта'"));
		КонецЕсли; 
		Для каждого Стр Из Объект.ОбъектыРемонта Цикл
			Если  (НЕ ЗначениеЗаполнено(Стр.ОбъектРемонта) ИЛИ НЕ ЗначениеЗаполнено(Стр.Подгруппа)) Тогда
				Отказ=Истина;
				Сообщить(НСтр("ru = 'Не заполнена подгруппа или объект ремонта в строке "+Строка(Стр.НомерСтроки)+"'"));
			КонецЕсли; 
		КонецЦикла; 
	КонецЕсли; 
КонецПроцедуры


&НаКлиенте
Процедура ВыполнениеПодтвержденоПриИзменении(Элемент)
	Если Объект.ВыполнениеПодтверждено Тогда
		Объект.Выполнено=Истина;	
	КонецЕсли; 
КонецПроцедуры


&НаКлиенте
Процедура ИсполнительФизЛицоНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	Если ЭтоМагазин Тогда
		СтандартнаяОбработка=Ложь;
		Парам=Новый Структура("ОтборПоЦФО,ТТ,ОбъектРемонта,Дата",Истина,Объект.Магазин,Объект.ОбъектРемонта,?(ЗначениеЗаполнено(Объект.Дата),Объект.Дата,ТекущаяДата()));
		ОткрытьФорму("Справочник.Техники.ФормаВыбора",Парам,Элемент);
		
	КонецЕсли; 
КонецПроцедуры


&НаКлиенте
Процедура ОбъектыРемонтаПриНачалеРедактирования(Элемент, НоваяСтрока, Копирование)
	
	Если НоваяСтрока Тогда
		Элемент.ТекущиеДанные.СтрокаИД = Строка(Новый УникальныйИдентификатор);
	КонецЕсли;
	
КонецПроцедуры


&НаКлиенте
Процедура ОбъектыРемонтаПриАктивизацииСтроки(Элемент)
	
	ТекДанные=Элемент.ТекущиеДанные;
	ОтборСтрок = Новый Структура;
	Если ТекДанные<>Неопределено Тогда
		ОтборСтрок.Вставить("СтрокаИД", ТекДанные.СтрокаИД);
	КонецЕсли;
	Элементы.Файлы.ОтборСтрок = Новый ФиксированнаяСтруктура(ОтборСтрок);
	Элементы.ФайлыИсполнителя.ОтборСтрок = Новый ФиксированнаяСтруктура(ОтборСтрок);	
	
КонецПроцедуры

