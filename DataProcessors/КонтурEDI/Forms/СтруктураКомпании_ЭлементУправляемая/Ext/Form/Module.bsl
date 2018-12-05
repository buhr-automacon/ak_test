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

&НаКлиенте
Процедура ОткрытьФормуОбъектаМодально(ИмяФормы, ПараметрыФормы = Неопределено, ИмяОбработчика = Неопределено, ПараметрыОбработчика = Неопределено, ВладелецОбработчика = Неопределено,РежимБлокирования = Неопределено)
	//отказ от модальности
	Если РежимБлокирования = Неопределено Тогда
		РежимБлокирования=	РежимОткрытияОкнаФормы.БлокироватьОкноВладельца;
	КонецЕсли;
	
	Если ВладелецОбработчика = Неопределено Тогда
		ВладелецОбработчика=	ЭтаФорма;
	КонецЕсли;
	
	Если ИмяОбработчика = Неопределено Тогда
		ОписаниеОбработчика=	Неопределено;
	Иначе	
		Выполнить("ОписаниеОбработчика=	Новый ОписаниеОповещения(ИмяОбработчика, ВладелецОбработчика, ПараметрыОбработчика)");
	КонецЕсли;
	
	Выполнить("ОткрытьФорму(ИмяФормы, ПараметрыФормы, ВладелецОбработчика, , , ,  ОписаниеОбработчика, РежимБлокирования)");
	
КонецПроцедуры

&НаКлиенте
Функция ПолучитьФормуОбработки(ИмяФормы, ПараметрыФормы = Неопределено , ВладелецФормы  = Неопределено, КлючУникальности = Неопределено, ЗакрыватьПризакрытииВладельца = Ложь)
	
	ПолучаемаяФорма=	ПолучитьФорму(ПутьКФормам+ИмяФормы
										, ПараметрыФормы
										,
										, КлючУникальности);
	
	Если НЕ ВладелецФормы = Неопределено Тогда
		ПолучаемаяФорма.ВладелецФормы=	ВладелецФормы;
	КонецЕсли;
	
	Возврат ПолучаемаяФорма;
	
КонецФункции

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Параметры.МодальностьЗапрещена=МодульОбъекта().МодальностьЗапрещена();
	ПутьКФормам = МодульОбъекта().Метаданные().ПолноеИмя() + ".Форма.";
	
	GLN					= МодульОбъекта().ПолучитьКонстантуEDI("GLN_Основной");
	
	МыПоставщик			= МодульОбъекта().НастройкиМодуля.МыПоставщик;
	МыТорговаяСеть		= МодульОбъекта().НастройкиМодуля.МыТорговаяСеть;
	
	Если МыТорговаяСеть = Истина Тогда
		КтоМы = "ТорговаяСеть";
	Иначе
		КтоМы = "Поставщик";
	КонецЕсли;
	
	УправлениеВидимостью();
	
	ОбновитьСписокЮрЛиц();
    ОбновитьСписокТочекДоставки();
	
	УстановитьТипыЗначенийПолей();

	//+синонимы
	
	ТабСинонимов = Новый ТаблицаЗначений;
	
	ТипПоляЮрФизЛицоСвое		= МодульОбъекта().ПолучитьТипЗначенияОбъекта("ЮрФизЛицоСвое");
	
	ТабСинонимов.Колонки.Добавить("ЮрФизЛицо",Новый ОписаниеТипов(ТипПоляЮрФизЛицоСвое));
	ТабСинонимов.Колонки.Добавить("GLN",Новый ОписаниеТипов("Строка"));
	
	Для Каждого СтрокаЮрФизЛица Из ТаблицаЮрФизЛиц Цикл
		
		СинонимыОднойСтрокой = МодульОбъекта().ПолучитьЗначениеСвойстваОбъектаEDI(СтрокаЮрФизЛица.ЮрФизЛицо, "GLN_Организации_Синонимы");
		
		МассивСинонимов = МодульОбъекта().EDI_РазложитьСтрокуВМассивСлов(СинонимыОднойСтрокой,",");
		Для Каждого Синоним Из МассивСинонимов Цикл
			НовСтрока = ТабСинонимов.Добавить();
			НовСтрока.ЮрФизЛицо = СтрокаЮрФизЛица.ЮрФизЛицо;
			НовСтрока.GLN = Синоним;
		КонецЦикла;
		
	КонецЦикла;	
	
	//СинонимыОрганизации = 
	ЗначениеВРеквизитФормы(ТабСинонимов,"СинонимыОрганизации");
	
	УстановитьТипЗначенияКолонки(Элементы.СинонимыОрганизацииЮрФизЛицо,		"ЮрФизЛицоСвое");
	//-синонимы
	
	Если ЗначениеЗаполнено(ТекущаяВкладка) Тогда
		Элементы.ПанельСоответствий.ТекущаяСтраница = ТекущаяВкладка;//в отлич. от ОФ, в ТекущаяВкладка будем хранить сам элемент
	КонецЕсли;
	
	СтандартнаяОбработка=Истина;
    МодульОбъекта().ОбработкаСобытияПодключаемогоМодуля("ПриОткрытииФормыСтруктурыКомпании",СтандартнаяОбработка, Новый Структура("Форма", ЭтаФорма));

КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	Оповестить("КонтурEDI_АктивизироватьФормуОшибок","Открытие",ЭтаФорма);
	
	// Автотесты
	Если ЗначениеЗаполнено(Параметры.ПараметрыАвтотестирования) Тогда

		ПодключитьОбработчикОжидания("ЗаписатьНастройкиАвтотестирования",0.1,Истина);
		
	КонецЕсли;

КонецПроцедуры

&НаСервере
Функция НайтиОрганизациюПоНаименованию(НаименованиеОрганизации)
	
	 Возврат Справочники.Организации.НайтиПоНаименованию(НаименованиеОрганизации);
	
КонецФункции

&НаКлиенте
Процедура ЗаписатьНастройкиАвтотестирования()

	СтруктураПараметров = ПолучитьИзВременногоХранилища(Параметры.ПараметрыАвтотестирования);
		
	СтруктураПараметров = СтруктураПараметров.Настройки.СтруктураКомпании;
	
	GLN = СтруктураПараметров.GLN;
	
	МыПоставщик = СтруктураПараметров.Поставщик;
	МыТорговаяСеть = СтруктураПараметров.Покупатель;
	
	Для Каждого Стр ИЗ СтруктураПараметров.ЮрЛица Цикл
		
		НоваяСтрока = ТаблицаЮрФизЛиц.Добавить();
		НоваяСтрока.ЮрФизЛицо	= НайтиОрганизациюПоНаименованию(Стр.Организация);
		НоваяСтрока.GLN			= Стр.GLN;
		
	КонецЦикла;
	
	ОсновныеДействияФормыВыполнить("");

КонецПроцедуры

&НаСервере
Процедура ОбновитьСписокЮрЛиц()
	
	ТаблицаЮрФизЛиц.Очистить();
	
	СписокЮрЛиц = МодульОбъекта().ПолучитьСписокЭлементовСправочника("ЮрФизЛицаСвои");
	
	Для каждого Стр ИЗ СписокЮрЛиц Цикл
			
		НоваяСтрока = ТаблицаЮрФизЛиц.Добавить();
		ЗаполнитьЗначенияСвойств(НоваяСтрока,Стр);
			
	КонецЦикла;
	
КонецПроцедуры

&НаСервере
Процедура ОбновитьСписокТочекДоставки()
	
	ТаблицаТочекДоставки.Очистить();
	
	СписокТочекДоставки = МодульОбъекта().ПолучитьСписокЭлементовСправочника("ТочкиДоставкиСвои");
		
	Для каждого Стр ИЗ СписокТочекДоставки Цикл
			
		НоваяСтрока = ТаблицаТочекДоставки.Добавить();
		ЗаполнитьЗначенияСвойств(НоваяСтрока,Стр);
			
	КонецЦикла;
	
КонецПроцедуры

&НаСервере
Процедура УстановитьТипЗначенияКолонки(Колонка,Тип1С)
	
	ПолеФормы	= Колонка;
	ТипПоля		= МодульОбъекта().ПолучитьТипЗначенияОбъекта(Тип1С);
	
	Если ТипПоля = Неопределено Тогда
		Сообщить("Не задан тип объекта 1С для поля с типом "+Тип1С);
	Иначе	
		
		ПолеФормы.ОграничениеТипа = Новый ОписаниеТипов(ТипПоля);
		
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура УстановитьТипыЗначенийПолей()
	
	УстановитьТипЗначенияКолонки(Элементы.ТаблицаЮрФизЛицЮрФизЛицо,		"ЮрФизЛицоСвое");
	
	УстановитьТипЗначенияКолонки(Элементы.ТаблицаТочекДоставкиТочкаДоставки,	"ТочкаДоставкиСвоя");
	
КонецПроцедуры

Процедура УправлениеВидимостью()
	
	Элементы.СтраницаТочкиДоставки.Видимость = ?(МыТорговаяСеть,Истина,Ложь);
	
КонецПроцедуры

&НаКлиенте
Процедура ТаблицаЮрФизЛицПриНачалеРедактирования(Элемент, НоваяСтрока, Копирование)
	
	ТекущаяСтрока = Элементы.ТаблицаЮрФизЛиц.ТекущиеДанные;
	
	Если НЕ ТекущаяСтрока = Неопределено Тогда
		Если НЕ ЗначениеЗаполнено(ТекущаяСтрока.ЮрФизЛицо) Тогда
			ТекущаяСтрока.ЮрФизЛицо = ПолучитьПустуюСсылкуОбъектаКлиентСервер("ЮрФизЛицоСвое");
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ТаблицаТочекДоставкиПриНачалеРедактирования(Элемент, НоваяСтрока, Копирование)
	
	ТекущаяСтрока = Элементы.ТаблицаТочекДоставки.ТекущиеДанные;
	
	Если НЕ ТекущаяСтрока = Неопределено Тогда
		Если НЕ ЗначениеЗаполнено(ТекущаяСтрока.ТочкаДоставки) Тогда
			Если МыТорговаяСеть и МыПоставщик Тогда
				//выбери тип пожалуйста 
			ИначеЕсли МыТорговаяСеть Тогда
				ТекущаяСтрока.ТочкаДоставки = ПолучитьПустуюСсылкуОбъектаКлиентСервер("ТочкаДоставкиСвоя");
			ИначеЕсли ПолучитьПустуюСсылкуОбъектаКлиентСервер("Грузоотправитель")<>неопределено Тогда 
				ТекущаяСтрока.ТочкаДоставки = ПолучитьПустуюСсылкуОбъектаКлиентСервер("Грузоотправитель");
			КонецЕсли;
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Функция ПолучитьПустуюСсылкуОбъектаКлиентСервер(Имя)
	Возврат МодульОбъекта().ПолучитьПустуюСсылкуОбъекта(Имя);
КонецФункции


&НаКлиенте
Процедура ТаблицаЮрФизЛицВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	
	Если Поле.Имя = "ТаблицаЮрФизЛицОрганизацияAPIПредставление" Тогда
		ТекСтрока = Элементы.ТаблицаЮрФизЛиц.ТекущиеДанные;
		Если ТекСтрока <> Неопределено Тогда
			СтандартнаяОбработка = Ложь;
			
			
			
			
			//открыть форму выбора АПИ организации
			//ВыбратьЭлементСправочника(ТекСтрока.ОрганизацияAPI,"НашиОрганизации",,СтандартнаяОбработка);                //в ОФ так
			
			ПараметрыФормы=	Новый Структура;
			ПараметрыФормы.Вставить("ФормаОткрытаКакВыбор",Истина);
			
			ДополнительныеПараметры = Новый Структура;
			ДополнительныеПараметры.Вставить("ТекСтрока",ТекСтрока);
			
			Если Параметры.МодальностьЗапрещена Тогда                                                                           				
				Выполнить("ОткрытьФормуОбъектаМодально(ПутьКФормам + ""НашиОрганизации_СписокУправляемая"", ПараметрыФормы,""ОбработчикВыбораОрганизацииАПИ"",ДополнительныеПараметры)");
			Иначе
				ВыбранноеЗначение=ПолучитьФормуОбработки("НашиОрганизации_СписокУправляемая",ПараметрыФормы).ОткрытьМодально();
				ОбработчикВыбораОрганизацииАПИ(ВыбранноеЗначение,ДополнительныеПараметры);
				
			КонецЕсли;
			
			
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработчикВыбораОрганизацииАПИ(ВыбранноеЗначение,ДополнительныеПараметры) Экспорт

	ТекСтрока = ДополнительныеПараметры.ТекСтрока;
	Если ВыбранноеЗначение<>Неопределено Тогда 
		ТекСтрока.ОрганизацияAPI 				= ВыбранноеЗначение;
		ТекСтрока.ОрганизацияAPIПредставление 	= ПолучитьПредставлениеЭлементаСправочникаКлиентСервер(ВыбранноеЗначение);
	КонецЕсли;

КонецПроцедуры


&НаСервере
Функция ПолучитьПредставлениеЭлементаСправочникаКлиентСервер(Имя)
	Возврат МодульОбъекта().ПолучитьПредставлениеЭлементаСправочника(Имя);
КонецФункции 

&НаКлиенте
Процедура ТаблицаЮрФизЛицПередНачаломДобавления(Элемент, Отказ, Копирование, Родитель, Группа)
	Отказ = истина;
КонецПроцедуры

&НаКлиенте
Процедура ТаблицаЮрФизЛицПередУдалением(Элемент, Отказ)
	Отказ = истина;
КонецПроцедуры

&НаКлиенте
Процедура ДобавитьЮрЛицо(Команда)
	ТаблицаЮрФизЛиц.Добавить();	
КонецПроцедуры

&НаКлиенте
Процедура УдалитьЮрЛицо(Команда)
	ТаблицаЮрФизЛиц.Удалить(Элементы.ТаблицаЮрФизЛиц.ТекущаяСтрока);
КонецПроцедуры

&НаКлиенте
Процедура ОсновныеДействияФормыВыполнить(Команда)
	ОчиститьСообщения();
	Если НЕ ПроверитьЗначенияФормы() Тогда
		Возврат ;
	КонецЕсли;
	
	//Если НЕ ПроверитьЮрЛиц() Тогда
	//	Предупреждение("Неверно заполнен список юридических лиц!");
	//	Возврат Ложь;
	//КонецЕсли;
	//Если НЕ ПроверитьТочкиДоставки() Тогда
	//	Предупреждение("Неверно заполнен список точек доставки!");
	//	Возврат Ложь;
	//КонецЕсли;
	
	СохранитьИзменения();
	
	//Оповестить("КонтурEDI_НастроитьФорму");      в основной форме уже привязвн обработчик и как в ОФ не надо.
	
	ЭтаФорма.Закрыть();
КонецПроцедуры

&НаСервере
Функция ПроверитьЗначенияФормы()
	
	// 1. инициализируем таблицу вывода ошибок
	ТаблицаОшибок = МодульОбъекта().ИнициализироватьТаблицуОшибок();
	
	// 2. передать структуру для проверки
	Если МыПоставщик Тогда
		МодульОбъекта().ПроверитьПолеФормы(ТаблицаОшибок, GLN,	 "GLN",	Истина, "GLN");
	Иначе
		МодульОбъекта().ПроверитьПолеФормы(ТаблицаОшибок, GLN,	 "GLN",	 , "GLN");
	КонецЕсли;
	
	// юр лица
	
	ТабПроверки = РеквизитФормыВЗначение("ТаблицаЮрФизЛиц").Скопировать();
	
	СписокПолей = Новый СписокЗначений;
	СписокПолей.Добавить("ЮрФизЛицо", "Юр\физ лицо");
	СписокПолей.Добавить("GLN","GLN");
	
	МодульОбъекта().НайтиДублиВТаблице(ТаблицаОшибок,ТабПроверки, "ЮрФизЛицо", "Юр. лица", "Юр\физ лицо");
	МодульОбъекта().НайтиДублиВТаблице(ТаблицаОшибок,ТабПроверки, "GLN", 		"Юр. лица", "GLN");
	
	сч = 0;
	
	Для каждого Стр Из ТабПроверки Цикл
		
		сч = сч + 1;
		
		Если ЗначениеЗаполнено(Стр.GLN) ИЛИ ЗначениеЗаполнено(Стр.ЮрФизЛицо) Тогда
		
	 		МодульОбъекта().ПроверитьПолеФормы(ТаблицаОшибок, Стр.GLN,			"GLN", Истина, "GLN", 		"ТаблицаЮрФизЛиц",сч,				,"Юр. лица");
	 		МодульОбъекта().ПроверитьПолеФормы(ТаблицаОшибок, Стр.ЮрФизЛицо,		 , Истина, "ЮрФизЛицо", "ТаблицаЮрФизЛиц",сч,"Юр\физ лицо"	,"Юр. лица");
		
		КонецЕсли;
		
	КонецЦикла;
	
	// точки доставки
	
	ТабПроверки = РеквизитФормыВЗначение("ТаблицаТочекДоставки").Скопировать();
	
	//НайтиДублиВТаблице(ТаблицаОшибок, ТабПроверки, "GLN",				"Точки доставки", "GLN");
	МодульОбъекта().НайтиДублиВТаблице(ТаблицаОшибок, ТабПроверки, "ТочкаДоставки",	"Точки доставки", "Точка доставки");
	
	сч = 0;
	
	Для каждого Стр Из ТабПроверки Цикл
		
		сч = сч + 1;
		
		Если ЗначениеЗаполнено(Стр.GLN) ИЛИ ЗначениеЗаполнено(Стр.ТочкаДоставки) Тогда
			
			МодульОбъекта().ПроверитьПолеФормы(ТаблицаОшибок, Стр.GLN,				"GLN", Истина, "GLN", 			"ТаблицаТочекДоставки",сч,					,"Точки доставки");
	 		МодульОбъекта().ПроверитьПолеФормы(ТаблицаОшибок, Стр.ТочкаДоставки,		 , Истина, "ТочкаДоставки", "ТаблицаТочекДоставки",сч,"Точка доставки"	,"Точки доставки");
			
		КонецЕсли;
			
	КонецЦикла;
	
	// доп. проверки
	
	Если МыТорговаяСеть Тогда
		
		Если НЕ ЗначениеЗаполнено(GLN) Тогда
			
			Если ТаблицаТочекДоставки.Количество() = 0 Тогда
				
				ТекстОшибки = "В случае, когда не указан основной код GLN, список точек доставки должен быть обязательно заполнен.";
				МодульОбъекта().ЗафиксироватьОшибку(ТаблицаОшибок,"GLN","ТаблицаТочекДоставки",,ТекстОшибки);
				
			КонецЕсли;
			
		КонецЕсли;	
		
	КонецЕсли;
	
	//проверим синонимы
	Для Каждого СтрокаСинонима Из СинонимыОрганизации Цикл
		
		Если Не ЗначениеЗаполнено(СтрокаСинонима.GLN) Тогда
			
			МодульОбъекта().ЗафиксироватьОшибку(ТаблицаОшибок,"GLN","СинонимыОрганизации",,"Не заполнены все GLN на закладке ""Синонимы""");
			
		ИначеЕсли Не ЗначениеЗаполнено(СтрокаСинонима.ЮрФизЛицо) Тогда
			
			МодульОбъекта().ЗафиксироватьОшибку(ТаблицаОшибок,"ЮрФизЛицо","СинонимыОрганизации",,"Не заполнены все юр\физ.лица на закладке ""Синонимы""");
			
		ИначеЕсли ТаблицаЮрФизЛиц.НайтиСтроки(Новый Структура("ЮрФизЛицо",СтрокаСинонима.ЮрФизЛицо))=Неопределено или ТаблицаЮрФизЛиц.НайтиСтроки(Новый Структура("ЮрФизЛицо",СтрокаСинонима.ЮрФизЛицо)).Количество()=0 Тогда
			
			МодульОбъекта().ЗафиксироватьОшибку(ТаблицаОшибок,"ЮрФизЛицо","СинонимыОрганизации",,"Юр\физ.лицо "+СтрокаСинонима.ЮрФизЛицо+" на закладке ""Синонимы"" отсутствует в структуре компании");
			
		ИначеЕсли ТаблицаЮрФизЛиц.НайтиСтроки(Новый Структура("GLN",СтрокаСинонима.GLN))<>Неопределено и ТаблицаЮрФизЛиц.НайтиСтроки(Новый Структура("GLN",СтрокаСинонима.GLN)).Количество()>0 Тогда
			
			ЮрФизЛицоДубль = ТаблицаЮрФизЛиц.НайтиСтроки(Новый Структура("GLN",СтрокаСинонима.GLN))[0].ЮрФизЛицо;
			МодульОбъекта().ЗафиксироватьОшибку(ТаблицаОшибок,"GLN","СинонимыОрганизации",,"Синоним "+СтрокаСинонима.GLN+" уже указан в качестве основного GLN для юр\физ.лица "+ЮрФизЛицоДубль);
			
		ИначеЕсли СинонимыОрганизации.НайтиСтроки(Новый Структура("GLN",СтрокаСинонима.GLN)).Количество()>1 Тогда
			
			МодульОбъекта().ЗафиксироватьОшибку(ТаблицаОшибок,"GLN","СинонимыОрганизации",,"Синоним "+СтрокаСинонима.GLN+" встречается несколько раз");
			
		КонецЕсли;
		
	КонецЦикла;
	
	
	Если ТаблицаОшибок.Количество() > 0 Тогда
		
		ТекстЗаголовка = "При заполнении структуры компании найдены ошибки.";
			
		//ОткрытьФормуВыводаОшибок(ТекстЗаголовка,ТаблицаОшибок,ЭтаФорма);
		Для Каждого СтрокаОшибки из ТаблицаОшибок Цикл 
			СП = новый СообщениеПользователю;
			СП.Текст = СтрокаОшибки.СведенияОбОшибках;
			Сп.Сообщить();
		КонецЦикла;
		Возврат Ложь;
		
	Иначе
		
		Возврат Истина;
		
	КонецЕсли;
	
	// 3. обработать результат
	
КонецФункции

&НаСервере
Процедура СохранитьИзменения()
	
	МодульОбъекта().УстановитьКонстантуEDI("GLN_Основной",	GLN);
	
	МодульОбъекта().УстановитьКонстантуEDI("МыПоставщик",	МыПоставщик);
	МодульОбъекта().УстановитьКонстантуEDI("МыТорговаяСеть",	МыТорговаяСеть);
	
	МодульОбъекта().СохранитьСписокЭлементовСправочника("ЮрФизЛицаСвои",		РеквизитФормыВЗначение("ТаблицаЮрФизЛиц"));
	
	Если МыТорговаяСеть ИЛИ Элементы.СтраницаТочкиДоставки.Видимость = Истина Тогда  //видимость - признак принудительного использования грузоотправителей
    	МодульОбъекта().СохранитьСписокЭлементовСправочника("ТочкиДоставкиСвои",	РеквизитФормыВЗначение("ТаблицаТочекДоставки"));
	КонецЕсли;
	
	//предварительно удалим все предыдущие синонимы
	Если МодульОбъекта().ВнешнееХранилище Тогда
		НаборЗаписей = МодульОбъекта().СоединениеСХранилищем.РегистрыСведений.КонтурEDI_ДополнительныеРеквизиты.СоздатьНаборЗаписей();
	Иначе
		НаборЗаписей = РегистрыСведений.КонтурEDI_ДополнительныеРеквизиты.СоздатьНаборЗаписей();
	КонецЕсли;
	НаборЗаписей.Отбор.Свойство.Установить("GLN_Организации_Синонимы");
	НаборЗаписей.Записать();
	
	//и запишем новые
	_ЮрФизЛица = РеквизитФормыВЗначение("СинонимыОрганизации").Скопировать(,"ЮрфизЛицо");
	_ЮрФизЛица.Свернуть("ЮрфизЛицо");
	Для Каждого СтрокаЮрФизЛица Из _ЮрФизЛица Цикл
		СтрокиСинонимов = СинонимыОрганизации.НайтиСтроки(Новый Структура("ЮрФизЛицо",СтрокаЮрФизЛица.ЮрФизЛицо));
		СинонимыОднойСтрокой = "";
		Для Каждого СтрокаСинонимов Из СтрокиСинонимов Цикл
			СинонимыОднойСтрокой = ?(СинонимыОднойСтрокой="","",СинонимыОднойСтрокой+",")+СтрокаСинонимов.GLN;
		КонецЦикла;
		МодульОбъекта().УстановитьЗначениеСвойстваОбъекта(СтрокаЮрФизЛица.ЮрФизЛицо, "GLN_Организации_Синонимы", СинонимыОднойСтрокой);
	КонецЦикла;	
	
КонецПроцедуры

&НаКлиенте
Процедура ТаблицаЮрФизЛицОрганизацияAPIПредставлениеНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	ТаблицаЮрФизЛицВыбор(Элемент, Элементы.ТаблицаЮрФизЛиц.ТекущаяСтрока, Элементы.ТаблицаЮрФизЛицОрганизацияAPIПредставление, СтандартнаяОбработка);
КонецПроцедуры

