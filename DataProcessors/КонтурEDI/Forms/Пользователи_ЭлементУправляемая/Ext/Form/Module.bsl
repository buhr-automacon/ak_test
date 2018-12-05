﻿&НаСервере
Перем ОбработкаОбъект; 

&НаСервере
//инициализация модуля и его экспортных функций
Функция МодульОбъекта()

	Если ОбработкаОбъект=Неопределено Тогда
		ОбработкаОбъект = РеквизитФормыВЗначение("Объект");
		ОбработкаОбъект.ИнициализироватьПодключаемыеМодули();
	КонецЕсли;	
	
	Возврат ОбработкаОбъект;
	
КонецФункции 

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Пользователь = Параметры.Пользователь;
	
	ПраваДоступаКСпискам = "";
	СписокПравДоступаКСообщениям = Новый СписокЗначений;
	МассивНедоступныхПартнеров = Новый Массив;
	МассивНедоступныхОрганизаций = Новый Массив;
	Параметры.МодальностьЗапрещена=МодульОбъекта().МодальностьЗапрещена();
	
	Если ЗначениеЗаполнено(Пользователь) Тогда
		
		СтруктураЭлемента = МодульОбъекта().ПолучитьЭлементСправочника("Пользователи", Пользователь);
		
		Если НЕ СтруктураЭлемента = Неопределено Тогда
		
			УчетнаяЗапись			= СтруктураЭлемента.УчетнаяЗапись;

			РольПользователяEDI		= СтруктураЭлемента.РольПользователяEDI;
			
            ПраваДоступаКСпискам	= СтруктураЭлемента.ПраваДоступаКСпискам;
			
			СлужебныйПользовательАвтообмен = СтруктураЭлемента.СлужебныйПользовательАвтообмен;
			
			СписокПравДоступаКСообщениям	= МодульОбъекта().ПолучитьНедоступныеСообщения(СтруктураЭлемента.ПраваДоступаКСообщениям);
			
			Если ЗначениеЗаполнено(СтруктураЭлемента.ПраваДоступаКПартнерам) Тогда
				МассивНедоступныхПартнеров = СтруктураЭлемента.ПраваДоступаКПартнерам;
			КонецЕсли;
			Если ЗначениеЗаполнено(СтруктураЭлемента.ПраваДоступаКОрганизациям) Тогда
				МассивНедоступныхОрганизаций = СтруктураЭлемента.ПраваДоступаКОрганизациям;
			КонецЕсли;
				
			ТекВариантОбмена	= СтруктураЭлемента.ВариантОбмена;
			НайденноеЗначение	= Элементы.ВариантОбмена.СписокВыбора.НайтиПоЗначению(ТекВариантОбмена);
			Если НЕ НайденноеЗначение = Неопределено Тогда
				
				ВариантОбмена = НайденноеЗначение.Значение;
				
			КонецЕсли;

		КонецЕсли;
		
	КонецЕсли;
	
	НастройкиСписков = МодульОбъекта().ПолучитьНастройкиСписков();
	
	Для Каждого Стр Из НастройкиСписков Цикл
		Если Стр.Вид = "Кнопка" Тогда
			
			ПодстрокаПоиска = "\"+СокрЛП(Стр.Код)+"\";
			Если Найти(ПраваДоступаКСпискам,ПодстрокаПоиска)>0 Тогда
				Пометка = Ложь;
			Иначе
				Пометка = Истина;
			КонецЕсли;
			
			СписокНастроекДокументов.Добавить(Стр.Имя,Стр.Представление, Пометка);
			
		КонецЕсли;
	КонецЦикла;
	
	МассивТиповСообщений = МодульОбъекта().ПолучитьМассивТиповСообщенийМодулей();
	
	Для каждого ТипСообщения Из МассивТиповСообщений Цикл
	
		СписокНастроекСообщений.Добавить(ТипСообщения, 
										ТипСообщения + " (" + МодульОбъекта().ПеревестиТипСообщения(ТипСообщения) + ")",
										?(СписокПравДоступаКСообщениям.НайтиПоЗначению(ТипСообщения) = Неопределено, Истина, Ложь));	
	
	КонецЦикла;
		
	Партнеры = МодульОбъекта().ПолучитьСписокЭлементовСправочника("Партнеры");
	
	Для каждого Стр Из Партнеры Цикл
		Если МассивНедоступныхПартнеров.Найти(Стр.Ссылка) = Неопределено Тогда
			СписокНастроекПартнеров.Добавить(Стр.Ссылка,Стр.Наименование,Истина);
		Иначе
			СписокНастроекПартнеров.Добавить(Стр.Ссылка,Стр.Наименование,Ложь);
		КонецЕсли;
	КонецЦикла;
	
	СписокЮрЛиц = МодульОбъекта().ПолучитьСписокЭлементовСправочника("ЮрФизЛицаСвои");
	
	Для каждого Стр ИЗ СписокЮрЛиц Цикл
		Если МассивНедоступныхОрганизаций.Найти(Стр.ЮрФизЛицо) = Неопределено Тогда
			СписокНастроекОрганизаций.Добавить(Стр.ЮрФизЛицо,,Истина);
		Иначе
			СписокНастроекОрганизаций.Добавить(Стр.ЮрФизЛицо,,Ложь);
		КонецЕсли;
	КонецЦикла;
	
	УстановитьТипПоля1С("Пользователь",	"Пользователь");
	УстановитьТипПоля1С("УчетнаяЗапись","УчетнаяЗапись");
	
	Если НЕ РольПользователяEDI = "ПолныеПрава" И НЕ РольПользователяEDI = "Пользователь" Тогда
		РольПользователяEDI = "ПолныеПрава";
	КонецЕсли;
	
	УстановкаДоступностиПрав();
	
	СтрокаСИБ = СтрокаСоединенияИнформационнойБазы();
	Если Лев(СтрокаСИБ, 4) = "File" Тогда
		АвтообменВариантБазыДанных = "ФайловыйВариант";
		АвтообменПутьКБазе = НСтр(СтрокаСоединенияИнформационнойБазы(), "File");
	ИначеЕсли Лев(СтрокаСИБ, 4) = "Srvr" Тогда
		АвтообменВариантБазыДанных = "СерверныйВариант";
		АвтообменСервер = НСтр(СтрокаСоединенияИнформационнойБазы(), "Srvr");
		АвтообменИмяБазы = НСтр(СтрокаСоединенияИнформационнойБазы(), "Ref");
	КонецЕсли;
	АвтообменНастроитьВидимостьЭлементов();
	Если ЗначениеЗаполнено(Пользователь) Тогда 
		
		Если Пользователь.Метаданные().Реквизиты.Найти("ИдентификаторПользователяИБ")<>Неопределено Тогда
			ПользовательИБ = ПользователиИнформационнойБазы.НайтиПоУникальномуИдентификатору(Пользователь.ИдентификаторПользователяИБ);
		Иначе 
			ПользовательИБ = ПользователиИнформационнойБазы.НайтиПоИмени(Пользователь.Наименование);
		КонецЕсли;	
		
		Если Не ПользовательИБ = Неопределено Тогда
			АвтообменПользователь = ПользовательИБ.Имя;
		КонецЕсли;
		
		//Попытка
		//	ПользовательИБ = ПользователиИнформационнойБазы.НайтиПоУникальномуИдентификатору(Пользователь.ИдентификаторПользователяИБ);
		//	Если Не ПользовательИБ = Неопределено Тогда
		//		АвтообменПользователь = ПользовательИБ.Имя;
		//	КонецЕсли;
		//Исключение
		//	ПользовательИБ = ПользователиИнформационнойБазы.НайтиПоИмени(Пользователь.Наименование);
		//	Если Не ПользовательИБ = Неопределено Тогда
		//		АвтообменПользователь = ПользовательИБ.Имя;
		//	КонецЕсли;
		//КонецПопытки;
	КонецЕсли;
	ИмяФайлаМодуля = "";
	Попытка
		ИмяФайлаМодуля = МодульОбъекта().ИспользуемоеИмяФайла;
		Если Прав(СокрЛП(ИмяФайлаМодуля),3) = "tmp" Тогда
			ИмяФайлаМодуля = "";		
		КонецЕсли;
	Исключение
	КонецПопытки;
	АвтообменПутьКМодулю = ИмяФайлаМодуля;
	
	УчетнаяЗаписьПредставление = МодульОбъекта().ПолучитьПредставлениеЭлементаСправочника(УчетнаяЗапись);
КонецПроцедуры

&НаСервере
Процедура АвтообменНастроитьВидимостьЭлементов()
	//TODO сделать автообмен
	
	//Если АвтообменВариантБазыДанных = "ФайловыйВариант" Тогда
	//	ЭлементыФормы.НадписьАвтообменПутьКБазе.Видимость 		= Истина;
	//	ЭлементыФормы.АвтообменПутьКБазе.Видимость				= Истина;
	//	ЭлементыФормы.НадписьАвтообменСерверИмяБазы.Видимость 	= Ложь;
	//	ЭлементыФормы.НадписьАвтообменРазделитель.Видимость 	= Ложь;
	//	ЭлементыФормы.АвтообменСервер.Видимость 				= Ложь;
	//	ЭлементыФормы.АвтообменИмяБазы.Видимость 				= Ложь;
	//ИначеЕсли АвтообменВариантБазыДанных = "СерверныйВариант" Тогда
	//	ЭлементыФормы.НадписьАвтообменСерверИмяБазы.Видимость 	= Истина;
	//	ЭлементыФормы.НадписьАвтообменРазделитель.Видимость 	= Истина;
	//	ЭлементыФормы.АвтообменСервер.Видимость 				= Истина;
	//	ЭлементыФормы.АвтообменИмяБазы.Видимость 				= Истина;
	//	ЭлементыФормы.НадписьАвтообменПутьКБазе.Видимость 		= Ложь;
	//	ЭлементыФормы.АвтообменПутьКБазе.Видимость				= Ложь;
	//КонецЕсли;			
	
КонецПроцедуры

&НаСервере
Процедура УстановкаДоступностиПрав()
	
	Если РольПользователяEDI = "ПолныеПрава" Тогда
		Элементы.ПанельНастроекПрав.Доступность = Ложь;
		Элементы.КнопкаВсеГалкиПроставить.Доступность = Ложь;
		Элементы.КнопкаВсеГалкиУбрать.Доступность = Ложь;
	Иначе
		Элементы.ПанельНастроекПрав.Доступность = Истина;
		Элементы.КнопкаВсеГалкиПроставить.Доступность = Истина;
		Элементы.КнопкаВсеГалкиУбрать.Доступность = Истина;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура УстановкаДоступностиПравКлиент()
	
	Если РольПользователяEDI = "ПолныеПрава" Тогда
		Элементы.ПанельНастроекПрав.Доступность = Ложь;
		Элементы.КнопкаВсеГалкиПроставить.Доступность = Ложь;
		Элементы.КнопкаВсеГалкиУбрать.Доступность = Ложь;
	Иначе
		Элементы.ПанельНастроекПрав.Доступность = Истина;
		Элементы.КнопкаВсеГалкиПроставить.Доступность = Истина;
		Элементы.КнопкаВсеГалкиУбрать.Доступность = Истина;
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
 Процедура УстановитьТипПоля1С(ИмяНаФорме,Тип1С)
	
	ПолеФормы	= Элементы[ИмяНаФорме];
	ТипПоля		= МодульОбъекта().ПолучитьТипЗначенияОбъекта(Тип1С);
			
	Если ТипПоля = Неопределено Тогда
		
		Сообщить("Не задан тип объекта 1С для поля с типом "+Тип1С);
		
	Иначе	
		
		Элементы[ИмяНаФорме].ОграничениеТипа = Новый ОписаниеТипов(ТипПоля);
		
		Если НЕ ЗначениеЗаполнено(ЭтаФорма[ИмяНаФорме]) Тогда
			
			ЭтаФорма[ИмяНаФорме] = МодульОбъекта().ПолучитьПустуюСсылкуОбъекта(Тип1С);
			
		КонецЕсли;
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура РольПользователяEDIПриИзменении(Элемент)
	УстановкаДоступностиПравКлиент();
	
	Если РольПользователяEDI = "ПолныеПрава" Тогда
		Для Каждого НастройкаДокумента Из СписокНастроекДокументов Цикл
			НастройкаДокумента.Пометка = Истина;
		КонецЦикла;
		Для Каждого НастройкаСообщения Из СписокНастроекСообщений Цикл
			НастройкаСообщения.Пометка = Истина;
		КонецЦикла;
		СписокНастроекПартнеров.ЗаполнитьПометки(Истина);
		СписокНастроекОрганизаций.ЗаполнитьПометки(Истина);
	КонецЕсли;
КонецПроцедуры

&НаСервереБезКонтекста
Функция ТекПользовательИЗПараметровСеанса()
	Возврат ПараметрыСеанса.ТекущийПользователь; 
КонецФункции

&НаКлиенте
Процедура ЗаписатьИЗакрыть(Команда)
	
	СтруктураПолей = Новый Структура();
	СтруктураПолей.Вставить("Пользователь", 		Пользователь);
	СтруктураПолей.Вставить("РольПользователяEDI",	РольПользователяEDI);
	СтруктураПолей.Вставить("УчетнаяЗапись",		УчетнаяЗапись);
	
	Если ВариантОбмена = "Обмен по кнопке ""Выполнить обмен""" или ВариантОбмена = "Ручной" Тогда
		ТекВариантОбмена = "Ручной";
	ИначеЕсли ВариантОбмена = "Работа в offline" или ВариантОбмена = "БезОбмена" Тогда
		ТекВариантОбмена = "БезОбмена";
	Иначе
		ТекВариантОбмена = "Автоматический";
	КонецЕсли;
    СтруктураПолей.Вставить("ВариантОбмена", ТекВариантОбмена);
	
	СтруктураПолей.Вставить("СлужебныйПользовательАвтообмен", СлужебныйПользовательАвтообмен);
	
	ЗаписатьИЗакрытьСервер(СтруктураПолей);
	
	Если ТекПользовательИЗПараметровСеанса() = Пользователь Тогда
		Оповестить("КонтурEDI_НастроитьФорму");
	КонецЕсли;
	
	ЭтаФорма.Закрыть(Истина);
	
КонецПроцедуры

&НаСервере
Процедура ЗаписатьИЗакрытьСервер(СтруктураПолей)
	
	Если СлужебныйПользовательАвтообмен Тогда 
		СброситьНастройкуПодтвержденияЗакрытия1С();
	КонецЕсли;
	
	СписокПравКСпискам = Новый СписокЗначений;
	
	НастройкиСписков = МодульОбъекта().ПолучитьНастройкиСписков();
	
	ПраваДоступаКСпискам = "\";
	
	Для Каждого Стр Из НастройкиСписков Цикл
		Если Стр.Вид = "Кнопка" Тогда
			
			НайденноеЗначение = СписокНастроекДокументов.НайтиПоЗначению(Стр.Имя);
			Если НЕ НайденноеЗначение = Неопределено Тогда
				Если НЕ НайденноеЗначение.Пометка Тогда
					ПраваДоступаКСпискам = ПраваДоступаКСпискам+СокрЛП(Стр.Код)+"\";
				КонецЕсли;
			КонецЕсли;
			
		КонецЕсли;
	КонецЦикла;
	
	Если ПраваДоступаКСпискам = "\" Тогда
		ПраваДоступаКСпискам = "";
	КонецЕсли;
	
	ПраваДоступаКСообщениям = "";
	
	МассивИменМодулей = МодульОбъекта().ПолучитьМассивИменИспользуемыхМодулей();
	
	Для Каждого ИмяМодуля Из МассивИменМодулей Цикл
		
		МассивТиповСообщенийМодуля = МодульОбъекта().ПолучитьМассивТиповСообщенийМодулей(ИмяМодуля);
		ПраваДоступаКСообщениям = ПраваДоступаКСообщениям + ИмяМодуля + "(";
		
		Для Каждого Зн Из СписокНастроекСообщений Цикл
			
			Если МассивТиповСообщенийМодуля.Найти(Зн.Значение) = Неопределено Тогда
				Продолжить;
			КонецЕсли;
			
			Если Зн.Пометка Тогда
				ПраваДоступаКСообщениям = ПраваДоступаКСообщениям + "1";
			Иначе
				ПраваДоступаКСообщениям = ПраваДоступаКСообщениям + "0";
			КонецЕсли;
			
		КонецЦикла;
		
		ПраваДоступаКСообщениям = ПраваДоступаКСообщениям + ")";
		
	КонецЦикла;
	
	СтруктураПолей.Вставить("ПраваДоступаКСпискам", 		ПраваДоступаКСпискам);
	СтруктураПолей.Вставить("ПраваДоступаКСообщениям",		ПраваДоступаКСообщениям);
	СтруктураПолей.Вставить("ПраваДоступаКПартнерам",		МодульОбъекта().ПолучитьПраваДоступаСтрокой(СписокНастроекПартнеров));
	СтруктураПолей.Вставить("ПраваДоступаКОрганизациям",	МодульОбъекта().ПолучитьПраваДоступаСтрокой(СписокНастроекОрганизаций));

	МодульОбъекта().СохранитьЭлементСправочника("Пользователи", Пользователь, СтруктураПолей);
	
   	ПараметрыПользователяEDI = МодульОбъекта().ПолучитьПараметрыТекущегоПользователяEDI();	

КонецПроцедуры // ()

&НаСервере
Процедура СброситьНастройкуПодтвержденияЗакрытия1С();
	
	//TODO
	//
	//Попытка
	//	ЗаписьПодтверждения=РегистрыСведений.НастройкиПользователей.СоздатьМенеджерЗаписи();
	//	ЗаписьПодтверждения.Пользователь=Пользователь;
	//	ЗаписьПодтверждения.Настройка=ПланыВидовХарактеристик.НастройкиПользователей.ЗапрашиватьПодтверждениеПриЗакрытии;
	//	ЗаписьПодтверждения.Прочитать();
	//	
	//	Если не ЗаписьПодтверждения.Выбран() или ЗаписьПодтверждения.Значение=истина Тогда 
	//		ЗаписьПодтверждения.Пользователь=Пользователь;
	//		ЗаписьПодтверждения.Настройка=ПланыВидовХарактеристик.НастройкиПользователей.ЗапрашиватьПодтверждениеПриЗакрытии;
	//		ЗаписьПодтверждения.Значение=Ложь;
	//		ЗаписьПодтверждения.Записать();
	//	КонецЕсли;
	//Исключение
	//	Сообщить("Не удалось скинуть настройку ""Запрашивать подтверждение программы перед закрытием""! Попробуйте скинуть эту настройку вручную.");
	//КонецПопытки;
	
КонецПроцедуры

&НаКлиенте
Процедура ПроверитьДоступностьНастроек(Элемент,Отказ=ложь)
	
	Если НЕ ПроверитьДоступностьНастроекВызовСервера() Тогда
		ПредложитьОбновитьОбъектыМетаданныхКонтурEDI(,"Для возможности настраивать доступ необходимо обновить объекты Контур.EDI. Сохранить файл обновления?");
		Отказ=Истина;
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Функция ПроверитьДоступностьНастроекВызовСервера()

	Возврат МодульОбъекта().ЕстьМетаданныеХраненияОрганизации;

КонецФункции // ПроверитьДоступностьНастроекВызовСервера()


&НаКлиенте
Процедура ОбработчикСогласияСохраненияФайла(РезультатВопроса,ДопПараметр)Экспорт

	Если РезультатВопроса<>"Да" Тогда 
		Возврат;
	КонецЕсли;
	
	ДиалогВыбора = Новый ДиалогВыбораФайла(РежимДиалогаВыбораФайла.Сохранение);
	ДиалогВыбора.Заголовок		= "Укажите файл, в который нужно сохранить обновление для вашей конфигурации";
	ДиалогВыбора.Фильтр			= "Файл конфигурации 1С (*.cf)|*.cf";      
	ДиалогВыбора.ПолноеИмяФайла = "КонтурEDI_upd.cf";
	
	Если ДиалогВыбора.Выбрать() Тогда      
		
		ПутьКФайлу = ДиалогВыбора.ПолноеИмяФайла;
		
	Иначе
		
		Возврат;
		
	КонецЕсли;
	
	ИмяМакетаОбновления = "ОбновлениеДляХраненияДанных";
	
	Макет=ПолучитьМакетВызовСервера(ИмяМакетаОбновления);
	Макет.Записать(ПутьКФайлу);
	
	//еще высветим на экране текстовый документ с описанием того, что надо делать
	Чтиво=Новый ТекстовыйДокумент;
	Чтиво.УстановитьТекст(
	"ВНИМАНИЕ! 
	|При добавлении оптимизированных объектов хранения данных в окне ""Сравнение, объединение"" НЕОБХОДИМО снять флажок с раздела ""Свойства""!"
	);
	Чтиво.Показать();
	
	Предупреждение("Запустите модуль после обновления конфигурации базы из файла");

КонецПроцедуры // ОбработчикСогласияСохраненияФайла()

&НаСервере
Функция ПолучитьМакетВызовСервера(ИмяМакетаОбновления)

Возврат МодульОбъекта().ПолучитьМакет(ИмяМакетаОбновления);	

КонецФункции // ПолучитьМакет(ИмяМакетаОбновления)()

&НаКлиенте
Процедура ПредложитьОбновитьОбъектыМетаданныхКонтурEDI(ИмяМакетаОбновления = Неопределено,ТекстВопроса = Неопределено) Экспорт
	Если ЗначениеЗаполнено(ТекстВопроса) Тогда
		
		КнопкиВопроса=новый СписокЗначений;
		КнопкиВопроса.Добавить("Да");
		КнопкиВопроса.Добавить("Нет");
		ДопПараметрДляПередачиВОбработчик=Неопределено;
		РезультатВопроса = Неопределено;
		
		Если Параметры.МодальностьЗапрещена Тогда
			Выполнить("ПоказатьВопрос(Новый ОписаниеОповещения(""ОбработчикСогласияСохраненияФайла"", ЭтаФорма, ДопПараметрДляПередачиВОбработчик), ТекстВопроса, КнопкиВопроса,,,""Контур.EDI"")");
		Иначе
			РезультатВопроса = Вопрос(ТекстВопроса, КнопкиВопроса,,,"Контур.EDI");
			ОбработчикСогласияСохраненияФайла(РезультатВопроса,ДопПараметрДляПередачиВОбработчик);
		КонецЕсли;
		
	Иначе
		ОбработчикСогласияСохраненияФайла("Да","Не задан вопрос");
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура СписокНастроекПартнеровПередНачаломИзменения(Элемент, Отказ)
	ПроверитьДоступностьНастроек(Элемент,Отказ);
КонецПроцедуры
&НаКлиенте
Процедура СписокНастроекОрганизацийПередНачаломИзменения(Элемент, Отказ)
	ПроверитьДоступностьНастроек(Элемент,Отказ);
КонецПроцедуры
&НаКлиенте
Процедура СписокНастроекПартнеровПередНачаломДобавления(Элемент, Отказ, Копирование, Родитель, Группа)
	Отказ=Истина;
КонецПроцедуры
&НаКлиенте
Процедура СписокНастроекПартнеровПередУдалением(Элемент, Отказ)
	Отказ=Истина;
КонецПроцедуры
&НаКлиенте
Процедура СписокНастроекОрганизацийПередНачаломДобавления(Элемент, Отказ, Копирование, Родитель, Группа)
	Отказ=Истина;
КонецПроцедуры
&НаКлиенте
Процедура СписокНастроекОрганизацийПередУдалением(Элемент, Отказ)
	Отказ=Истина;
КонецПроцедуры
&НаКлиенте
Процедура СписокНастроекДокументовПередНачаломДобавления(Элемент, Отказ, Копирование, Родитель, Группа)
	Отказ=Истина;
КонецПроцедуры
&НаКлиенте
Процедура СписокНастроекДокументовПередУдалением(Элемент, Отказ)
	Отказ=Истина;
КонецПроцедуры
&НаКлиенте
Процедура СписокНастроекСообщенийПередНачаломДобавления(Элемент, Отказ, Копирование, Родитель, Группа)
	Отказ=Истина;
КонецПроцедуры
&НаКлиенте
Процедура СписокНастроекСообщенийПередУдалением(Элемент, Отказ)
	Отказ=Истина;
КонецПроцедуры

&НаКлиенте
Процедура АвтообменСохранитьБатФайл(Команда)
	ЕстьОшибки = Ложь;
	
	Если АвтообменВариантБазыДанных = "ФайловыйВариант" Тогда
		Если Не ЗначениеЗаполнено(АвтообменПутьКБазе) Тогда
			Сообщить("Не заполнено обязательное поле ""Путь к базе""");
			ЕстьОшибки = Истина;
		КонецЕсли;
	ИначеЕсли АвтообменВариантБазыДанных = "СерверныйВариант" Тогда
		Если Не ЗначениеЗаполнено(АвтообменСервер) Тогда
			Сообщить("Не заполнено обязательное поле ""Сервер""");
			ЕстьОшибки = Истина;
		КонецЕсли;
		Если Не ЗначениеЗаполнено(АвтообменИмяБазы) Тогда
			Сообщить("Не заполнено обязательное поле ""Имя базы""");
			ЕстьОшибки = Истина;
		КонецЕсли;
	КонецЕсли;
	
	Если Не ЗначениеЗаполнено(АвтообменПользователь) Тогда
		Сообщить("Не заполнено необязательное поле ""Пользователь""");
	КонецЕсли;
	Если Не ЗначениеЗаполнено(АвтообменПутьКМодулю) Тогда
		Сообщить("Не заполнено обязательное поле ""Путь к модулю""");
		ЕстьОшибки = Истина;
	КонецЕсли;
	
	//Если ЕстьОшибки Тогда
	//	Сообщить("Не заполнены одно или несколько обязательных полей!");
	//	Возврат;
	//КонецЕсли;		
	
	ПакетнаяКоманда = "";
	
	ПакетнаяКоманда = ПакетнаяКоманда + """" + КаталогПрограммы() + "1cv8.exe" + """ ";
	ПакетнаяКоманда = ПакетнаяКоманда + "enterprise ";
	Если АвтообменВариантБазыДанных = "ФайловыйВариант" Тогда
		ПакетнаяКоманда = ПакетнаяКоманда + "/F" + " " + """" + АвтообменПутьКБазе + """ ";
	ИначеЕсли АвтообменВариантБазыДанных = "СерверныйВариант" Тогда
		ПакетнаяКоманда = ПакетнаяКоманда + "/S" + " " + """" + АвтообменСервер + "\" + АвтообменИмяБазы + """ ";	
	КонецЕсли;
	ПакетнаяКоманда = ПакетнаяКоманда + "/N" + " " + """" + АвтообменПользователь + """" + " " + "/P" + " " + """" + АвтообменПароль + """ ";
	ПакетнаяКоманда = ПакетнаяКоманда + "/Execute" + " " + """" + АвтообменПутьКМодулю + """";
	
	ИмяБатФайла = "";
	
	Режим = РежимДиалогаВыбораФайла.Сохранение;
	ДиалогСохраненияФайла = Новый ДиалогВыбораФайла(Режим);
	ДиалогСохраненияФайла.ПолноеИмяФайла = "Автообмен Контур.EDI";
	Фильтр = "Пакетный файл Windows" + "(*.bat)|*.bat";
	ДиалогСохраненияФайла.Фильтр = Фильтр;
	ДиалогСохраненияФайла.МножественныйВыбор = Ложь;
	ДиалогСохраненияФайла.Заголовок = "Выберите место сохранения файла ...";
	Если ДиалогСохраненияФайла.Выбрать() Тогда
		МассивФайлов = ДиалогСохраненияФайла.ВыбранныеФайлы;
		ИмяБатФайла = МассивФайлов[0];
	Иначе
		Сообщить("Файл автозапуска не сохранен!");	    
	КонецЕсли;
	
	Если ЗначениеЗаполнено(ИмяБатФайла) Тогда
		Попытка
			БатФайл = Новый ЗаписьТекста(ИмяБатФайла, КодировкаТекста.OEM);
			БатФайл.ЗаписатьСтроку(ПакетнаяКоманда);
			БатФайл.Закрыть();
			ТекстПредупреждения="Файл автозапуска успешно сохранен!";
			Если Параметры.МодальностьЗапрещена Тогда 
				Выполнить("ПоказатьПредупреждение(,ТекстПредупреждения,,""Контур.EDI"")");
			Иначе
				Предупреждение(ТекстПредупреждения,,"Контур.EDI");
			КонецЕсли;
			
		Исключение
			Сообщить("Не удалось записать файл: " + ОписаниеОшибки());
		КонецПопытки;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура АвтообменПутьКБазеНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	Режим = РежимДиалогаВыбораФайла.ВыборКаталога;
	ДиалогВыбораКаталога = Новый ДиалогВыбораФайла(Режим);
	ДиалогВыбораКаталога.Каталог = Элемент.Значение;
	ДиалогВыбораКаталога.Заголовок = "Укажите расположение базы данных...";
	Если ДиалогВыбораКаталога.Выбрать() Тогда
		Элемент.Значение = ДиалогВыбораКаталога.Каталог;
	КонецЕсли;

КонецПроцедуры

&НаКлиенте
Процедура АвтообменПутьКМодулюНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	СтандартнаяОбработка 		= Ложь;
	
	Режим = РежимДиалогаВыбораФайла.Открытие;
	ДиалогОткрытияФайла = Новый ДиалогВыбораФайла(Режим);
	ДиалогОткрытияФайла.ПолноеИмяФайла = "";
	Фильтр = "Внешняя обработка 1С:Предприятия 8 " + "(*.epf)|*.epf";
	ДиалогОткрытияФайла.Фильтр = Фильтр;
	ДиалогОткрытияФайла.МножественныйВыбор = Ложь;
	ДиалогОткрытияФайла.Заголовок = "Укажите расположение файла модуля ""Контур.EDI""...";
	Если ДиалогОткрытияФайла.Выбрать() Тогда
		МассивФайлов = ДиалогОткрытияФайла.ВыбранныеФайлы;
		ИмяФайла = МассивФайлов[0];
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура АвтообменПользовательНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	СтандартнаяОбработка = Ложь;
	
	
	МассивПользователейИБ = ПолучитьПользователейИБВызовСервера();
	
	Если МассивПользователейИБ.Количество() = 0 Тогда
		Возврат;
	КонецЕсли;
	
	СписокПользователейИБ = Новый СписокЗначений;
	Для Каждого Элемент Из МассивПользователейИБ Цикл
		СписокПользователейИБ.Добавить(Элемент);
	КонецЦикла;
	
	Если Параметры.МодальностьЗапрещена Тогда 
		Выполнить("ПоказатьВыборИзСписка(Новый ОписаниеОповещения(""СписокПользователейИБВыборЗавершение"", ЭтаФорма), СписокПользователейИБ,Элемент,)");
	Иначе
		ВыбранноеЗначение = ВыбратьИзСписка(СписокПользователейИБ,Элемент,);
		СписокПользователейИБВыборЗавершение(ВыбранноеЗначение, );
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура СписокПользователейИБВыборЗавершение(ВыбранноеЗначение=Неопределено,ДопПараметр=Неопределено)Экспорт

	Если Не ВыбранноеЗначение = Неопределено Тогда
		АвтообменПользователь = ВыбранноеЗначение.Значение;
	КонецЕсли;

КонецПроцедуры // СписокПользователейИБВыборЗавершение()

&НаСервере
Функция ПолучитьПользователейИБВызовСервера()
	
	МассивПользователей =  ПользователиИнформационнойБазы.ПолучитьПользователей();	
	МассивСтрокПользователей = Новый Массив;
	
	Для Каждого ПользовательИБ Из МассивПользователей Цикл
		МассивСтрокПользователей.Добавить(ПользовательИБ.Имя);
	КонецЦикла;
	
	Возврат МассивСтрокПользователей; 
	
КонецФункции // ПолучитьПользователейИБВызовСервера()

&НаКлиенте
Процедура АвтообменВариантБазыДанныхПриИзменении(Элемент)
	Элементы.ГруппаСерверныйВариант.Видимость=АвтообменВариантБазыДанных="СерверныйВариант";
	Элементы.ГруппаФайловыйВариант.Видимость=АвтообменВариантБазыДанных="ФайловыйВариант";
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	АвтообменВариантБазыДанныхПриИзменении("");
КонецПроцедуры

&НаКлиенте
Процедура ВсеГалкиПроставить(Команда)
	ПолучитьРаскрытыйСписокНастроек().ЗаполнитьПометки(Истина);
КонецПроцедуры

&НаКлиенте
Процедура ВсеГалкиУбрать(Команда)
	ПолучитьРаскрытыйСписокНастроек().ЗаполнитьПометки(Ложь);
КонецПроцедуры

&НаКлиенте
Функция ПолучитьРаскрытыйСписокНастроек()
	
	ИмяТекущейСтраницы = Элементы.ПанельНастроекПрав.ТекущаяСтраница.Имя;
	
	Если ИмяТекущейСтраницы = "Организации" Тогда 
		Возврат СписокНастроекОрганизаций;
	ИначеЕсли ИмяТекущейСтраницы = "Партнеры" Тогда
		Возврат СписокНастроекПартнеров;
	ИначеЕсли ИмяТекущейСтраницы = "Документы" Тогда 
		Возврат СписокНастроекДокументов;
	ИначеЕсли ИмяТекущейСтраницы = "EDI_сообщения" Тогда 
		Возврат СписокНастроекСообщений;
	КонецЕсли;
	
КонецФункции
