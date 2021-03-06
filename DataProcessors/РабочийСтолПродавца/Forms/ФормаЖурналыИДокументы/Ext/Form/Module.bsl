﻿
&НаКлиенте
Процедура ИнвентаризацияОС(Команда)
	
	//+++АК mika 2018.08.09 ИП-00019475 "Статистика использования(Удалить)"↓
	ОбщегоНазначенияСервер.СтатистикаИспользованияПодсистемДобавитьЗапись(Новый Структура("Подсистема, ИмяОбъекта, ИмяФормы, ИмяЭлемента, ДопИнформация", 
			"Магазины", Лев(Этаформа.ИмяФормы,Найти(Этаформа.ИмяФормы,".Форма")-1) , Этаформа.ИмяФормы, СокрЛП(Этаформа.ТекущийЭлемент) +"."+?(Этаформа.ТекущийЭлемент <> Неопределено, Этаформа.ТекущийЭлемент.Имя, "Неопределено"), 
					"ОткрытьФорму(Документ.ИнвентаризацияОС.ФормаСписка)")); 
	//---АК mika
	
	ОткрытьФорму("Документ.ИнвентаризацияОС.ФормаСписка", , , "ИОС_РабочийСтол");
	
КонецПроцедуры

&НаКлиенте
Процедура ЖурналРеглРабот(Команда)
	
	//+++АК mika 2018.08.09 ИП-00019475 "Статистика использования(Удалить)"↓
	ОбщегоНазначенияСервер.СтатистикаИспользованияПодсистемДобавитьЗапись(Новый Структура("Подсистема, ИмяОбъекта, ИмяФормы, ИмяЭлемента, ДопИнформация", 
			"Магазины", Лев(Этаформа.ИмяФормы,Найти(Этаформа.ИмяФормы,".Форма")-1) , Этаформа.ИмяФормы, СокрЛП(Этаформа.ТекущийЭлемент) +"."+?(Этаформа.ТекущийЭлемент <> Неопределено, Этаформа.ТекущийЭлемент.Имя, "Неопределено"), 
					"ОткрытьФорму(Обработка.РедактированиеЖурналаРеглРаботВМагазинах.Форма.Форма)")); 
	//---АК mika
	
	Магазины_Клиент.УправлениеОкнамиМагазинов("ЖурналРеглРаботВМагазинах");
	ОткрытьФорму("Обработка.РедактированиеЖурналаРеглРаботВМагазинах.Форма.Форма", , , "СЕ_РабочийСтол");
	
КонецПроцедуры

//+++АК БЕЛН 02.10.2017 (начало)
&НаКлиенте
Процедура ЗаявкиНаРемонт(Команда)
	
	//+++АК mika 2018.08.09 ИП-00019475 "Статистика использования(Удалить)"↓
	ОбщегоНазначенияСервер.СтатистикаИспользованияПодсистемДобавитьЗапись(Новый Структура("Подсистема, ИмяОбъекта, ИмяФормы, ИмяЭлемента, ДопИнформация", 
			"Магазины", Лев(Этаформа.ИмяФормы,Найти(Этаформа.ИмяФормы,".Форма")-1) , Этаформа.ИмяФормы, СокрЛП(Этаформа.ТекущийЭлемент) +"."+?(Этаформа.ТекущийЭлемент <> Неопределено, Этаформа.ТекущийЭлемент.Имя, "Неопределено"), 
					"ОткрытьФорму(Документ.ЗаявкаНаРемонт.ФормаСписка)")); 
	//---АК mika
	
	ОткрытьФорму("Документ.ЗаявкаНаРемонт.ФормаСписка", , , "ЗР_РабочийСтол");
	
КонецПроцедуры
//---АК БЕЛН 02.10.2017

//+++АК sils 10.08.2017 (начало)
&НаКлиенте
Процедура ЖурналРегистрТемператур(Команда)
	
	//+++АК mika 2018.08.09 ИП-00019475 "Статистика использования(Удалить)"↓
	ОбщегоНазначенияСервер.СтатистикаИспользованияПодсистемДобавитьЗапись(Новый Структура("Подсистема, ИмяОбъекта, ИмяФормы, ИмяЭлемента, ДопИнформация", 
			"Магазины", Лев(Этаформа.ИмяФормы,Найти(Этаформа.ИмяФормы,".Форма")-1) , Этаформа.ИмяФормы, СокрЛП(Этаформа.ТекущийЭлемент) +"."+?(Этаформа.ТекущийЭлемент <> Неопределено, Этаформа.ТекущийЭлемент.Имя, "Неопределено"), 
					"ОткрытьФорму(Обработка.ЖурналРегистрацииТемператур.Форма.УправляемаяФорма)")); 
	//---АК mika
	
	ОткрытьФорму("Обработка.ЖурналРегистрацииТемператур.Форма.УправляемаяФорма", , , "ЖРТ_РабочийСтол");
КонецПроцедуры
//---АК

//+++АК bara #15929
&НаСервере
Функция  ТорговаяТочкаПоАйпиСервер()
	Возврат ПараметрыСеанса.ТорговаяТочкаПоАйпи;
КонецФункции

&НаКлиенте
Процедура МестоположенияДатчиков(Команда)
	
	//+++АК mika 2018.08.09 ИП-00019475 "Статистика использования(Удалить)"↓
	ОбщегоНазначенияСервер.СтатистикаИспользованияПодсистемДобавитьЗапись(Новый Структура("Подсистема, ИмяОбъекта, ИмяФормы, ИмяЭлемента, ДопИнформация", 
			"Магазины", Лев(Этаформа.ИмяФормы,Найти(Этаформа.ИмяФормы,".Форма")-1) , Этаформа.ИмяФормы, СокрЛП(Этаформа.ТекущийЭлемент) +"."+?(Этаформа.ТекущийЭлемент <> Неопределено, Этаформа.ТекущийЭлемент.Имя, "Неопределено"), 
					"ОткрытьФорму(Справочник.Датчики.Форма.ФормаСписка1)")); 
	//---АК mika
	
	ТорговаяТочкаПоАйпи = ТорговаяТочкаПоАйпиСервер();
	Если ТорговаяТочкаПоАйпи.Пустая() Тогда 
		ОткрытьФорму("Справочник.Датчики.Форма.ФормаСписка1");
	Иначе
		П = Новый Структура();
		
		ПараметрыФормы = Новый Структура;
		ФН = Новый НастройкиКомпоновкиДанных;
		Эл =  ФН.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
		Эл.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("Владелец");
		Эл.ВидСравнения = ВидСравненияКомпоновкиДанных.Равно;
		Эл.ПравоеЗначение = ТорговаяТочкаПоАйпи;
		Эл.Использование = Истина;
		Эл.РежимОтображения =  РежимОтображенияЭлементаНастройкиКомпоновкиДанных.Недоступный;
		П.Вставить("ФиксированныеНастройки",ФН);
		
		//	П = Новый Структура();
		//	Отбор = Новый Структура();
		//	Отбор.Вставить("Владелец",ТорговаяТочкаПоАйпи);
		//	П.Вставить("Отбор",Отбор);
		ОткрытьФорму("Справочник.Датчики.Форма.ФормаСписка1",П);
	КонецЕсли;
КонецПроцедуры

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ
		|	ЗначенияДополнительныхПравПользователя.Пользователь,
		|	ЗначенияДополнительныхПравПользователя.Право,
		|	ЗначенияДополнительныхПравПользователя.Значение
		|ИЗ
		|	РегистрСведений.ЗначенияДополнительныхПравПользователя КАК ЗначенияДополнительныхПравПользователя
		|ГДЕ
		|	ЗначенияДополнительныхПравПользователя.Право = &Право
		|	И ЗначенияДополнительныхПравПользователя.Пользователь = &Пользователь";
	
	Запрос.УстановитьПараметр("Пользователь", ПараметрыСеанса.ТекущийПользователь);
	Запрос.УстановитьПараметр("Право", ПланыВидовХарактеристик.ПраваПользователей.МестоположенияДатчиков);
	
	РезультатЗапроса = Запрос.Выполнить();
	
	ВыборкаДетальныеЗаписи = РезультатЗапроса.Выбрать();
	ЕстьПраво = Ложь;
	Если ВыборкаДетальныеЗаписи.Следующий() Тогда 
		ЕстьПраво = ВыборкаДетальныеЗаписи.Значение;
	Иначе
		ЕстьПраво = Ложь;
	КонецЕсли;;
	
	Если ЕстьПраво = Ложь Тогда
	
		ЭтаФорма.Элементы.МестоположенияДатчиков.Видимость = Ложь;
	
	КонецЕсли;
КонецПроцедуры
//---АК bara



