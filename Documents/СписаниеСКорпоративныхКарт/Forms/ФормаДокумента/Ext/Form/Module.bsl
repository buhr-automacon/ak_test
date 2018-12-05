﻿
&НаСервереБезКонтекста
Функция ПолучитьИННОрганизации(мОрганизация)
	
	Возврат мОрганизация.ИНН;
	
КонецФункции

&НаСервереБезКонтекста
Функция ПолучитьКППОрганизации(мОрганизация)
	
	Возврат мОрганизация.КПП;
	
КонецФункции

&НаСервереБезКонтекста
Функция КонтрагентПоОрганизации(мОрганизация)
	
	Возврат Справочники.Контрагенты.НайтиПоРеквизиту("Организация", мОрганизация);
	
КонецФункции	

&НаСервереБезКонтекста
Функция ПолучитьДубльНомераВхДокумента(СтруктураПараметров)
	
	ТекНомерВхДокумента = СтруктураПараметров.НомерВхДокумента;
	
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("НомерВходящегоДокумента"	, ТекНомерВхДокумента);
	Запрос.УстановитьПараметр("ДатаНач"					, НачалоГода(СтруктураПараметров.Дата));
	Запрос.УстановитьПараметр("ДатаКон"					, КонецГода(СтруктураПараметров.Дата));
	Запрос.Текст =
	"ВЫБРАТЬ
	|	СписаниеСКорпоративныхКарт.Ссылка
	|ИЗ
	|	Документ.СписаниеСКорпоративныхКарт КАК СписаниеСКорпоративныхКарт
	|ГДЕ
	|	СписаниеСКорпоративныхКарт.Дата МЕЖДУ &ДатаНач И &ДатаКон
	|	И СписаниеСКорпоративныхКарт.НомерВходящегоДокумента = &НомерВходящегоДокумента
	|	И СписаниеСКорпоративныхКарт.Проведен";
	
	Результат = Запрос.Выполнить();
	Если Результат.Пустой() Тогда
		Возврат ТекНомерВхДокумента;  // все нормально, такого номера еще не было
	КонецЕсли;

	// получение нового номера вх. документа
	Попытка
		ТекНомерВхДокумента = Строка(Число(СокрЛП(ТекНомерВхДокумента)) + 1);
	Исключение
		ТекНомерВхДокумента = "";
	КонецПопытки;

	Возврат ТекНомерВхДокумента;
	
КонецФункции

&НаСервереБезКонтекста
Функция ПолучитьНазначениеПлатежа(СтруктураПараметров)

	ТекНазначениеПлатежа = СтруктураПараметров.НазначениеПлатежа;
	
	ПозСуммы = Найти(ТекНазначениеПлатежа, "Сумма");
	Если ПозСуммы > 0 Тогда
		ТекстНазначение = Лев(ТекНазначениеПлатежа, ПозСуммы - 2);
	Иначе
		ТекстНазначение = ТекНазначениеПлатежа;
	КонецЕсли;
	
	ТекстСумма = "Сумма " + Формат(СтруктураПараметров.СуммаДокумента, "ЧЦ=15; ЧДЦ=2; ЧРД=-; ЧН=0-00; ЧГ=") + Символы.ПС + "Без НДС";
	
	Возврат СокрЛП(ТекстНазначение) + Символы.ПС + ТекстСумма;

КонецФункции

&НаСервереБезКонтекста
Функция ПолучитьСтатьюДДСБУ(мСтатьяДДС)

	Возврат ОбщегоНазначенияСервер.ПолучитьСтатьюДДС_БУ(мСтатьяДДС, Неопределено);
	
КонецФункции

Функция РеквизитПомеченНаУдаление(ИмяРеквизита)
	
	Возврат Объект[ИмяРеквизита].ПометкаУдаления;
	
КонецФункции

Процедура УстановитьВидимостьКартинкиНеСогласованаСумма()
	
	ВремТаблица = Объект.РасшифровкаПлатежа.Выгрузить(Новый Структура("Оплачено", Истина));
	Элементы.КартинкаНеСогласованаСумма.Видимость = (НЕ ВремТаблица.Итог("Сумма") = Объект.СуммаДокумента);
	
КонецПроцедуры


&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)

	Элементы.РасшифровкаПлатежаВидПлатежа.СписокВыбора.Добавить("Почтой");
	Элементы.РасшифровкаПлатежаВидПлатежа.СписокВыбора.Добавить("Телеграфом");
	Элементы.РасшифровкаПлатежаВидПлатежа.СписокВыбора.Добавить("Электронно");
	Элементы.РасшифровкаПлатежаВидПлатежа.СписокВыбора.Добавить("Срочно");
	
	Если Объект.Ссылка.Пустая() Тогда
		
		Объект.Автор 		= ПараметрыСеанса.ТекущийПользователь;
		Объект.Дата 		= ТекущаяДата();
		
		Если Объект.Организация.Пустая() Тогда
			Объект.Организация 	= УправлениеПользователями.ПолучитьЗначениеПоУмолчанию(глЗначениеПеременной("глТекущийПользователь"), "ОсновнаяОрганизация");
		КонецЕсли;
		
		Если Объект.Контрагент.Пустая()
				И НЕ Объект.Организация.Пустая() Тогда
			Объект.Контрагент	= КонтрагентПоОрганизации(Объект.Организация);
		КонецЕсли;
		
		//Если НЕ ЗначениеЗаполнено(Объект.ВидПлатежа) Тогда	
		//	Объект.ВидПлатежа    		= Элементы.ВидПлатежа.СписокВыбора[2];
		//КонецЕсли;
			
		//Если НЕ ЗначениеЗаполнено(Объект.ОчередностьПлатежа) Тогда
		//	Объект.ОчередностьПлатежа 	= ?(ТекущаяДата() < Дата("20131216"), 6, 5);
		//КонецЕсли;
		
		Объект.СчетУчетаБУ 						= ПланыСчетов.Хозрасчетный.ПрочиеСпециальныеСчета;
		Объект.СтатьяДвиженияДенежныхСредствБУ 	= Справочники.СтатьиДвиженияДенежныхСредствБУ.НайтиПоКоду("000000026");
		
	Иначе
		НастройкаПравДоступа.ОпределитьДоступностьВозможностьИзмененияДокументаПоДатеЗапрета(Объект.Ссылка.ПолучитьОбъект(), ЭтаФорма);		
	КонецЕсли;
	
	УстановитьВидимостьКартинкиНеСогласованаСумма();
	
	ЭтаФорма.НачальнаяДата = Объект.Дата;
	
КонецПроцедуры

&НаКлиенте
Процедура ПередЗаписью(Отказ, ПараметрыЗаписи)
	
	Если (НЕ Объект.СчетКонтрагента.Пустая())
			И РеквизитПомеченНаУдаление("СчетКонтрагента") 
			И Вопрос("Корпоративный счет помечен на удаление. Продолжить?", РежимДиалогаВопрос.ДаНет) = КодВозвратаДиалога.Нет Тогда
		Отказ = Истина;
	КонецЕсли;
	
	//Если Объект.Дата > ТекущаяДата() Тогда
	//	ЭтаФорма.ИспользоватьРежимаПроведения = ИспользованиеРежимаПроведения.Неоперативный;
	//Иначе
	//	ЭтаФорма.ИспользоватьРежимаПроведения = ИспользованиеРежимаПроведения.Оперативный;
	//КонецЕсли;

КонецПроцедуры

&НаСервере
Процедура ПередЗаписьюНаСервере(Отказ, ТекущийОбъект, ПараметрыЗаписи)
	
	//Если ЗначениеЗаполнено(Объект.НомерВходящегоДокумента)
	//		И Объект.Ссылка.Пустая() Тогда
	//		
	//	СтруктураПараметров = Новый Структура("НомерВхДокумента, Дата", Объект.НомерВходящегоДокумента, Объект.Дата);
	//	мНомерВхДокумента = ПолучитьДубльНомераВхДокумента(СтруктураПараметров);	
	//	
	//	Если НЕ Объект.НомерВходящегоДокумента = мНомерВхДокумента Тогда
	//		ОбщегоНазначения.СообщитьОбОшибке("Платежное поручение с таким исходящим номером уже есть! Будет назначен новый.");
	//		Объект.НомерВходящегоДокумента = мНомерВхДокумента;
	//	КонецЕсли;
	//	
	//КонецЕсли;
	
КонецПроцедуры


&НаКлиенте
Процедура ДатаПриИзменении(Элемент)
	
	РазностьДат = НачалоГода(ЭтаФорма.НачальнаяДата) - НачалоГода(Объект.Дата);
	Если НЕ РазностьДат = 0 Тогда
		Объект.Номер = "";
	КонецЕсли;

	ЭтаФорма.НачальнаяДата = Объект.Дата; // запомним текущую дату документа для контроля номера документа
	
КонецПроцедуры

&НаКлиенте
Процедура ОрганизацияПриИзменении(Элемент)

	Объект.Контрагент 		= КонтрагентПоОрганизации(Объект.Организация);
	Объект.СчетКонтрагента 	= ПредопределенноеЗначение("Справочник.БанковскиеСчета.ПустаяСсылка"); 
	Объект.СчетОрганизации 	= ПредопределенноеЗначение("Справочник.БанковскиеСчета.ПустаяСсылка"); 
	
КонецПроцедуры

&НаКлиенте
Процедура ОплаченоПриИзменении(Элемент)
	
	УстановитьВидимостьКартинкиНеСогласованаСумма();
	
КонецПроцедуры

&НаКлиенте
Процедура СтатьяДвиженияДенежныхСредствПриИзменении(Элемент)
	
	Объект.СтатьяДвиженияДенежныхСредствБУ = ПолучитьСтатьюДДСБУ(Объект.СтатьяДвиженияДенежныхСредств);
	
КонецПроцедуры

&НаКлиенте
Процедура СуммаДокументаПриИзменении(Элемент)
	
	СтруктураПараметров = Новый Структура("НазначениеПлатежа, СуммаДокумента", Объект.НазначениеПлатежа, Объект.СуммаДокумента);
	
	//Объект.НазначениеПлатежа = ПолучитьНазначениеПлатежа(СтруктураПараметров);
	
КонецПроцедуры

&НаКлиенте
Процедура СчетУчетаБУОбработкаВыбора(Элемент, ВыбранноеЗначение, СтандартнаяОбработка)
	
	Если ВыбранноеЗначение.Пустая()
			ИЛИ ВыбранноеЗначение.ЗапретитьИспользоватьВПроводках Тогда
		Предупреждение("Счет " + СокрЛП(ВыбранноеЗначение)+ " """ + ВыбранноеЗначение.Наименование + """ нельзя использовать в проводках.");
		СтандартнаяОбработка = Ложь;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ЗаполнитьИННПлательщика(Команда)

	Если НЕ Объект.Организация.Пустая() Тогда
		Объект.ИННПлательщика = ПолучитьИННОрганизации(Объект.Организация);
	КонецЕсли;

КонецПроцедуры

&НаКлиенте
Процедура ЗаполнитьКПППлательщика(Команда)

	Если НЕ Объект.Организация.Пустая() Тогда
		Объект.КПППлательщика = ПолучитьКППОрганизации(Объект.Организация);
	КонецЕсли;

КонецПроцедуры


&НаСервереБезКонтекста
Функция ПолучитьФизлицоКорпоративнойКарты(мКорпоративнаяКарты)
	
	Возврат мКорпоративнаяКарты.ФизЛицо;
	
КонецФункции

&НаСервереБезКонтекста
Функция ПолучитьКорпоративнуюКартуФизЛица(мФизЛицо)
	
	Возврат мФизЛицо.НомерКорпоративнойКарты;
	
КонецФункции

&НаКлиенте
Процедура РасшифровкаПлатежаПередОкончаниемРедактирования(Элемент, НоваяСтрока, ОтменаРедактирования, Отказ)
	
	ТекДанные = Элементы.РасшифровкаПлатежа.ТекущиеДанные;
	Если ТекДанные = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	//Если ТекДанные.НомерКорпоративнойКарты.Пустая() Тогда
	//	ТекДанные.НомерКорпоративнойКарты = ПолучитьКорпоративнуюКартуФизЛица(ТекДанные.Физлицо);
	//Иначе
	ТекДанные.Физлицо = ПолучитьФизлицоКорпоративнойКарты(ТекДанные.НомерКорпоративнойКарты);
	//КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура РасшифровкаПлатежаПриОкончанииРедактирования(Элемент, НоваяСтрока, ОтменаРедактирования)
	
	УстановитьВидимостьКартинкиНеСогласованаСумма();
	
КонецПроцедуры
