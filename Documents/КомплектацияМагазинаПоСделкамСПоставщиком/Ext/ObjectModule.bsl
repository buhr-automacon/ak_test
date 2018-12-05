﻿
Процедура ОбработкаПроведения(Отказ, РежимПроведения)
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	КомплектацияМагазинаПоСделкамСПоставщикомУслуги.Ссылка,
	|	КомплектацияМагазинаПоСделкамСПоставщикомУслуги.Услуга
	|ИЗ
	|	Документ.КомплектацияМагазинаПоСделкамСПоставщиком.Услуги КАК КомплектацияМагазинаПоСделкамСПоставщикомУслуги
	|ГДЕ
	|	КомплектацияМагазинаПоСделкамСПоставщикомУслуги.Ссылка.Проведен
	|	И КомплектацияМагазинаПоСделкамСПоставщикомУслуги.Ссылка <> &Ссылка
	|	И КомплектацияМагазинаПоСделкамСПоставщикомУслуги.Ссылка.Магазин = &Магазин
	|	И КомплектацияМагазинаПоСделкамСПоставщикомУслуги.Услуга В(&Услуга)
	|
	|СГРУППИРОВАТЬ ПО
	|	КомплектацияМагазинаПоСделкамСПоставщикомУслуги.Ссылка,
	|	КомплектацияМагазинаПоСделкамСПоставщикомУслуги.Услуга";
	
	Запрос.УстановитьПараметр("Магазин", Магазин);
	Запрос.УстановитьПараметр("Ссылка", Ссылка);
	Запрос.УстановитьПараметр("Услуга", Услуги.ВыгрузитьКолонку("Услуга"));
	
	Результат = Запрос.Выполнить();
	
	ВыборкаДетальныеЗаписи = Результат.Выбрать();
	
	Пока ВыборкаДетальныеЗаписи.Следующий() Цикл
		Сообщить("В документе "+ВыборкаДетальныеЗаписи.Ссылка+" уже оформлена услуга "+ВыборкаДетальныеЗаписи.Услуга+" для "+Магазин+"");
		Отказ=Истина;
	КонецЦикла;
		
	Движения.ТоварыККомплектацииСделокСПоставщиками.Записывать = Истина;
	Движения.ТоварыККомплектацииСделокСПоставщиками.Очистить();
	
	Движения.РасчетыПоСделкамСПоставщиками.Записывать=Истина;
	Движения.РасчетыПоСделкамСПоставщиками.Очистить();
	
	//+++АК POZM 2018.05.08 ИП-00018375 
	ОтразитьПлановуюКомплектацию();
	//---АК POZM 
	
КонецПроцедуры

//+++АК POZM 2018.05.08 ИП-00018375 
Процедура ОтправитьПисьмаПоПлановойКомплектации() Экспорт
	
	Если Не ЗначениеЗаполнено(ЭтотОбъект.Ссылка) Тогда
		Возврат;
	КонецЕсли;	
	УстановитьПривилегированныйРежим(Истина);
	
	ТекстЗапроса="ВЫБРАТЬ
	             |	КомплектацияМагазинаПоСделкамСПоставщикомПлановаяКомплектацияИсторияИзменений.Источник КАК Контрагент,
	             |	МАКСИМУМ(ВЫРАЗИТЬ(КонтактнаяИнформация.Представление КАК СТРОКА(100))) КАК Адрес,
	             |	""Поставщик"" КАК Кто
	             |ИЗ
	             |	Документ.КомплектацияМагазинаПоСделкамСПоставщиком.ПлановаяКомплектацияИсторияИзменений КАК КомплектацияМагазинаПоСделкамСПоставщикомПлановаяКомплектацияИсторияИзменений
	             |		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.КонтактнаяИнформация КАК КонтактнаяИнформация
	             |		ПО КомплектацияМагазинаПоСделкамСПоставщикомПлановаяКомплектацияИсторияИзменений.Источник = КонтактнаяИнформация.Объект
	             |			И (КонтактнаяИнформация.Тип = &ТипКИПочта)
	             |ГДЕ
	             |	КомплектацияМагазинаПоСделкамСПоставщикомПлановаяКомплектацияИсторияИзменений.Источник ССЫЛКА Справочник.Контрагенты
	             |	И КомплектацияМагазинаПоСделкамСПоставщикомПлановаяКомплектацияИсторияИзменений.Ссылка = &Ссылка
	             |
	             |СГРУППИРОВАТЬ ПО
	             |	КомплектацияМагазинаПоСделкамСПоставщикомПлановаяКомплектацияИсторияИзменений.Источник
	             |
	             |ОБЪЕДИНИТЬ ВСЕ
	             |
	             |ВЫБРАТЬ
	             |	КомплектацияМагазинаПоСделкамСПоставщиком.МонтажнаяОрганизация,
	             |	МАКСИМУМ(ВЫРАЗИТЬ(КонтактнаяИнформация.Представление КАК СТРОКА(100))),
	             |	""Монтажник""
	             |ИЗ
	             |	Документ.КомплектацияМагазинаПоСделкамСПоставщиком КАК КомплектацияМагазинаПоСделкамСПоставщиком
	             |		ЛЕВОЕ СОЕДИНЕНИЕ Справочник.КонтактныеЛицаКонтрагентов КАК КонтактныеЛицаКонтрагентов
	             |			ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.КонтактнаяИнформация КАК КонтактнаяИнформация
	             |			ПО КонтактныеЛицаКонтрагентов.Ссылка = КонтактнаяИнформация.Объект
	             |				И (КонтактнаяИнформация.Тип = &ТипКИПочта)
	             |		ПО КомплектацияМагазинаПоСделкамСПоставщиком.МонтажнаяОрганизация = КонтактныеЛицаКонтрагентов.Владелец
	             |			И (КонтактныеЛицаКонтрагентов.РольКонтактногоЛица = &РольКИМонтаж)
	             |			И (КонтактныеЛицаКонтрагентов.ПометкаУдаления = ЛОЖЬ)
	             |ГДЕ
	             |	КомплектацияМагазинаПоСделкамСПоставщиком.Ссылка = &Ссылка
	             |
	             |СГРУППИРОВАТЬ ПО
	             |	КомплектацияМагазинаПоСделкамСПоставщиком.МонтажнаяОрганизация
	             |
	             |ОБЪЕДИНИТЬ ВСЕ
	             |
	             |ВЫБРАТЬ
	             |	КомплектацияМагазинаПоСделкамСПоставщиком.ОтветственныйЗаПредкомплектацию,
	             |	МАКСИМУМ(ВЫРАЗИТЬ(КонтактнаяИнформация.Представление КАК СТРОКА(100))),
	             |	""Ответственный""
	             |ИЗ
	             |	Документ.КомплектацияМагазинаПоСделкамСПоставщиком КАК КомплектацияМагазинаПоСделкамСПоставщиком
	             |		ВНУТРЕННЕЕ СОЕДИНЕНИЕ РегистрСведений.КонтактнаяИнформация КАК КонтактнаяИнформация
	             |		ПО КомплектацияМагазинаПоСделкамСПоставщиком.ОтветственныйЗаПредкомплектацию.ФизЛицо = КонтактнаяИнформация.Объект
	             |ГДЕ
	             |	КомплектацияМагазинаПоСделкамСПоставщиком.Ссылка = &Ссылка
	             |	И КонтактнаяИнформация.Тип = &ТипКИПочта
	             |
	             |СГРУППИРОВАТЬ ПО
	             |	КомплектацияМагазинаПоСделкамСПоставщиком.ОтветственныйЗаПредкомплектацию";
				 //---АК POZM 
	Запрос = Новый Запрос(ТекстЗапроса);
	Запрос.УстановитьПараметр("Ссылка",ЭтотОбъект.Ссылка);
	Запрос.УстановитьПараметр("ТипКИПочта",Перечисления.ТипыКонтактнойИнформации.АдресЭлектроннойПочты);
	//+++АК POZM 2018.07.03 ИП-00018375.02 
	Запрос.УстановитьПараметр("РольКИМонтаж",Справочники.РолиКонтактныхЛиц.МонтажнаяОрганизация);
	//---АК POZM 
	ВыборкаПолучателей = Запрос.Выполнить().Выбрать();
	
	СписокКому = Новый СписокЗначений;
	
	Пока ВыборкаПолучателей.Следующий() Цикл
	    Если ЗначениеЗаполнено(ВыборкаПолучателей.Адрес) Тогда
			МассивАдресов=Справочники.Контрагенты.РазложитьСтрокуВМассивПодстрок(ВыборкаПолучателей.Адрес,";");	
			Для каждого Эл Из МассивАдресов Цикл
				Если ЗначениеЗаполнено(Эл) Тогда
					СписокКому.Добавить(СокрЛП(Эл));
				КонецЕсли; 
			КонецЦикла; 
		Иначе
			Сообщить("Не заполнен адрес электронной почты для " + ВыборкаПолучателей.Контрагент);
		КонецЕсли;	
		Если ВыборкаПолучателей.Кто = "Ответственный" Тогда
			 ТекстОтветственный = "Специалист по закупке холод. оборудования Вкусвилл:" + ВыборкаПолучателей.Контрагент + ", e-mail:"+ВыборкаПолучателей.Адрес;
		КонецЕсли;	
	КонецЦикла; 	
	
	ДанныеРасшифровки = Новый ДанныеРасшифровкиКомпоновкиДанных;
	КомпоновщикМакета = Новый КомпоновщикМакетаКомпоновкиДанных;
	
	СКД=Документы.КомплектацияМагазинаПоСделкамСПоставщиком.ПолучитьМакет("ПисьмоОПлановойКомплектации");
	СКД.Параметры.Ссылка.Значение = ЭтотОбъект.Ссылка;
	НастройкиСКД = СКД.НастройкиПоУмолчанию;
	
	МакетКомпоновки = КомпоновщикМакета.Выполнить(СКД, НастройкиСКД, ДанныеРасшифровки);
	
	ПроцессорКомпоновкиДанных = Новый ПроцессорКомпоновкиДанных;
	ПроцессорКомпоновкиДанных.Инициализировать(МакетКомпоновки, ,ДанныеРасшифровки);
	
	ТабДок=Новый ТабличныйДокумент;
	
	ПроцессорВывода = Новый ПроцессорВыводаРезультатаКомпоновкиДанныхВТабличныйДокумент;
	ПроцессорВывода.УстановитьДокумент(ТабДок);
	ПроцессорВывода.Вывести(ПроцессорКомпоновкиДанных);
	
	ИмяФайла=Новый УникальныйИдентификатор;
	ИмяФайла=КаталогВременныхФайлов()+ИмяФайла+".xls";
	
	ТабДок.Записать(ИмяФайла,ТипФайлаТабличногоДокумента.XLS);
	//Отправка письма
	
		
	////СписокКому.Добавить(ВыборкаДетальныеЗаписи.Представление);
	//СписокКому.Добавить("retail.e@vkusvill.ru");
	//СписокКому.Добавить("buh09@vkusvill.ru");
	//
	//СписокКому.Добавить("pozm@automacon.ru");
	//СписокКому.Добавить("abdr@automacon.ru");
	
	
	УчетнаяЗапись = ОбщиеПроцедуры.ПолучитьУчетнуюЗаписьДляРассылки();
	
	Почта = Новый ИнтернетПочта;
	Профиль = УправлениеЭлектроннойПочтой.ПолучитьИнтернетПочтовыйПрофиль(УчетнаяЗапись);
	Письмо = Новый ИнтернетПочтовоеСообщение;
	
	Почта.Подключиться(Профиль);
	Письмо.Тема = ""+"Необходимо поставить оборудование в магазин "+ЭтотОбъект.Магазин+" - Вкусвилл: дата отправки письма - "+ТекущаяДата();
	Письмо.ИмяОтправителя 	= "" + УчетнаяЗапись + "";
	Письмо.ИмяОтправителя  	= "" + СокрЛП(УчетнаяЗапись) + "";
	Письмо.Отправитель     	= "" + СокрЛП(УчетнаяЗапись) + "";
	Для Каждого ПолучательЭлемент Из СписокКому Цикл
		Получатель = Письмо.Получатели.Добавить();
		Получатель.Адрес = ПолучательЭлемент.Значение;
	КонецЦикла;	
	
	ТекстСообщения = Письмо.Тексты.Добавить();
	ТекстСообщения.Текст     = "Во вложении находится информация о нужном оборудовании";
	ТекстСообщения.Текст = ТекстСообщения.Текст + Символы.ПС + ТекстОтветственный;
	ТекстСообщения.ТипТекста = ТипТекстаПочтовогоСообщения.ПростойТекст;
	
	Письмо.Вложения.Добавить(ИмяФайла);
	
	//	Если НЕ ОбщегоНазначения.ЭтоКопияБазы() Тогда
	Почта.Послать(Письмо);
	//	КонецЕсли;	
	Почта.Отключиться();
КонецПроцедуры	
//---АК POZM 

//+++АК POZM 2018.05.08 ИП-00018375 
Процедура ОтразитьПлановуюКомплектацию()
	
	Движения.ПлановаяКомплектацияТорговыхТочек.Записывать = Истина;
	Движения.ПлановаяКомплектацияТорговыхТочек.Очистить();
	Для каждого Стр Из ЭтотОбъект.ПлановаяКомплектация Цикл
		
		Если Стр.ОборудованиеПоставленоНаОбъект Тогда
			НД = Движения.ПлановаяКомплектацияТорговыхТочек.ДобавитьПриход();
			НД.Количество = 1;
			НД.Магазин = ЭтотОбъект.Магазин;
			НД.Период = ЭтотОбъект.Дата;
			НД.ТипОборудования = Стр.ТипОборудования;
		КонецЕсли;	
	
	КонецЦикла; 
КонецПроцедуры
//---АК POZM 

Процедура ПередЗаписью(Отказ, РежимЗаписи, РежимПроведения)
	Для Каждого ТекСтрокаКомплектация Из Комплектация Цикл
		Если СокрЛП(ТекСтрокаКомплектация.УИН_Строки)="" Тогда
			ТекСтрокаКомплектация.УИН_Строки=Новый УникальныйИдентификатор();
		КонецЕсли;	
	КонецЦикла;
	
	//+++АК POZM 2018.05.06 ИП-00018469 
	Если РежимЗаписи = РежимЗаписиДокумента.Проведение Тогда
		НомерВерсии = 0;
		ЕстьИзменения = Ложь;
		Если ЭтотОбъект.ПлановаяКомплектацияИсторияИзменений.Количество()>0 Тогда
			НомерВерсии = ЭтотОбъект.ПлановаяКомплектацияИсторияИзменений[ЭтотОбъект.ПлановаяКомплектацияИсторияИзменений.Количество()-1].НомерВерсии+1;
			ТЗ = ЭтотОбъект.ПлановаяКомплектация.Выгрузить();
			ТЗ.Колонки.Добавить("Количество");
			ТЗ.ЗаполнитьЗначения(1,"Количество");
			ПредВерсии = ЭтотОбъект.ПлановаяКомплектацияИсторияИзменений.НайтиСтроки(Новый Структура("НомерВерсии",НомерВерсии - 1));
			Для Каждого СтрПред Из ПредВерсии Цикл
				НС = ТЗ.Добавить();
				ЗаполнитьЗначенияСвойств(НС,СтрПред);
				НС.Количество = -1;
			КонецЦикла;	
			ТЗ.Свернуть("Оборудование,ТипОборудования,ОборудованиеБУ,ДатаПоступления,Источник,Собран,ТипТранспорта,Комментарий,","Количество");
			Если ТЗ.НайтиСтроки(Новый Структура("Количество",0)).Количество() <> ТЗ.Количество() Тогда
				ЕстьИзменения = Истина;
			КонецЕсли;	
		Иначе
			ЕстьИзменения = Истина;
		КонецЕсли;	
		Если ЕстьИзменения Тогда
			Для каждого СтрокаПлана Из ЭтотОбъект.ПлановаяКомплектация Цикл
			
				НС = ПлановаяКомплектацияИсторияИзменений.Добавить();
				ЗаполнитьЗначенияСвойств(НС,СтрокаПлана,,"НомерСтроки");
				НС.Дата = ТекущаяДата();
				НС.НомерВерсии = НомерВерсии;
				
			КонецЦикла; 
		КонецЕсли;	
	КонецЕсли;	
	//---АК POZM 
КонецПроцедуры

Процедура ОбработкаЗаполнения(ДанныеЗаполнения, ТекстЗаполнения, СтандартнаяОбработка)
	
КонецПроцедуры

Процедура ПриКопировании(ОбъектКопирования)
	ЭтотОбъект.ПлановаяКомплектацияИсторияИзменений.Очистить();
КонецПроцедуры
