﻿
// Обработчик события ПередЗаписью .
//
Процедура ПередЗаписью(Отказ)

	Если НЕ ОбменДанными.Загрузка
	   И ТипЗнч(Владелец) = Тип("СправочникСсылка.Номенклатура") Тогда
		Если Владелец.ЕдиницаХраненияОстатков = Ссылка Тогда

			Запрос = Новый Запрос;
			Запрос.УстановитьПараметр("ТекущийЭлемент", ЭтотОбъект.Ссылка);

			Запрос.Текст =
			"ВЫБРАТЬ
			|	ЕдиницыИзмерения.Ссылка КАК Элемент,
			|	ЕдиницыИзмерения.Коэффициент КАК Коэффициент
			|ИЗ
			|	Справочник.ЕдиницыИзмерения КАК ЕдиницыИзмерения
			|
			|ГДЕ
			|	ЕдиницыИзмерения.Ссылка = &ТекущийЭлемент";

			Выборка = Запрос.Выполнить().Выбрать();

			Если Выборка.Следующий() Тогда
				Если Выборка.Коэффициент <> Коэффициент Тогда
					Если ПолныеПрава.Номенклатура_СуществуютСсылки(Владелец, Неопределено) Тогда
						ОбщегоНазначения.СообщитьОбОшибке("Единица """ + Наименование + """ является единицей хранения остатков для """ + Владелец.Наименование + """ и уже участвует в товародвижении. Изменить коэффициент уже нельзя!", Отказ);
					КонецЕсли;
				КонецЕсли;
			КонецЕсли;

		КонецЕсли;
	КонецЕсли;

	Если Не ОбменДанными.Загрузка
	   И Не Отказ
	   И Коэффициент = 0 Тогда
		ОбщегоНазначения.СообщитьОбОшибке("Для "+СокрЛП(Владелец)+" у единицы измерения "+СокрЛП(Ссылка)+" не задан коэффициент! Он будет установлен равным 1.");
		Коэффициент = 1;
	КонецЕсли;

КонецПроцедуры // ПередЗаписью()


Процедура ПриЗаписи(Отказ)
	
	//+++shar
	// Регистрация изменений в плане обмена
	Попытка
		
		УстановитьПривилегированныйРежим(Истина);
		
		//+++АК SHEP 20160810: исключаем ненужные узлы
		ПрофилиИспользования = Новый Массив;
		ПрофилиИспользования.Добавить(ПредопределенноеЗначение("Справочник.МП_ПрофилиИспользования.Строитель"));
		ПрофилиИспользования.Добавить(ПредопределенноеЗначение("Справочник.МП_ПрофилиИспользования.ПлановыйАссортимент"));
		ПрофилиИспользования.Добавить(ПредопределенноеЗначение("Справочник.МП_ПрофилиИспользования.НовыеТоварыТехнолог"));
		ПрофилиИспользования.Добавить(ПредопределенноеЗначение("Справочник.МП_ПрофилиИспользования.НовыеТоварПостановщикЗадач"));
		//---АК SHEP 20160810
		
		МассивУзлов = Новый Массив;
		Запрос = Новый Запрос;
		Запрос.Текст = 
		"ВЫБРАТЬ
		|	МобильноеПриложение.Ссылка
		|ИЗ
		|	ПланОбмена.МобильноеПриложение КАК МобильноеПриложение
		|ГДЕ
		|	МобильноеПриложение.Ссылка <> &ЭтотУзел
		|	И НЕ МобильноеПриложение.Профиль В (&ПрофилиИспользования)";
		Запрос.УстановитьПараметр("ПрофилиИспользования", ПрофилиИспользования);
		Запрос.УстановитьПараметр("ЭтотУзел", ПланыОбмена.МобильноеПриложение.ЭтотУзел());
		МассивУзлов = Запрос.Выполнить().Выгрузить().ВыгрузитьКолонку("Ссылка");
		
		Если ЭтоГруппа Тогда
			ПланыОбмена.ЗарегистрироватьИзменения(МассивУзлов, Ссылка);
		Иначе
			
			Запрос = Новый Запрос;
			Запрос.Текст = 
			"ВЫБРАТЬ
			|	ШтриховыеКоды.Номенклатура,
			|	ШтриховыеКоды.ШтрихКод
			|ИЗ
			|	РегистрСведений.ШтриховыеКоды КАК ШтриховыеКоды
			|ГДЕ
			|	ШтриховыеКоды.ЕдиницаИзмерения = &Ссылка";
			Запрос.УстановитьПараметр("Ссылка", Ссылка);
			Выборка = Запрос.Выполнить().Выбрать();
			Если Выборка.Следующий() Тогда
				ПланыОбмена.ЗарегистрироватьИзменения(МассивУзлов, Ссылка);
			КонецЕсли;
			
		КонецЕсли;
		
	Исключение
		ЗаписьЖурналаРегистрации(ОписаниеОшибки(), УровеньЖурналаРегистрации.Ошибка);
	КонецПопытки;
	УстановитьПривилегированныйРежим(Ложь);

	//---shar
КонецПроцедуры

