﻿
//+++АК LATV 2018.09.25 ИП-00019950
Функция Печать(Ссылка) Экспорт

	ТабДок = Новый ТабличныйДокумент;
	ТабДок.ИмяПараметровПечати = "АКИнвентаризацияЗадание";
	
	Макет = Документы.ЗаданиеНаИнвентаризацию.ПолучитьМакет("Инвентаризация");
	
	Запрос = Новый Запрос;
	Запрос.Текст =
		"ВЫБРАТЬ
		|	ИнвентаризацияСклад.Ссылка КАК Ссылка,
		|	ИнвентаризацияСклад.ВерсияДанных,
		|	ИнвентаризацияСклад.ПометкаУдаления,
		|	ИнвентаризацияСклад.Номер,
		|	ИнвентаризацияСклад.Дата КАК Дата,
		|	ИнвентаризацияСклад.Проведен,
		|	ИнвентаризацияСклад.Склад,
		|	ИнвентаризацияСклад.Автор,
		|	ИнвентаризацияСклад.Ответственный,
		|	ИнвентаризацияСклад.Камера,
		|	ИнвентаризацияСклад.Товары.(
		|		Ссылка,
		|		НомерСтроки,
		|		Номенклатура,
		|		Характеристика,
		|		ДатаПроизводства,
		|		ЕдиницаИзмерения,
		|		Количество
		|	)
		|ИЗ
		|	Документ.ЗаданиеНаИнвентаризацию КАК ИнвентаризацияСклад
		|ГДЕ
		|	ИнвентаризацияСклад.Ссылка В(&Ссылка)
		|
		|УПОРЯДОЧИТЬ ПО
		|	Дата,
		|	Ссылка
		|ИТОГИ ПО
		|	Ссылка";
	
	Запрос.УстановитьПараметр("Ссылка", Ссылка);
	
	ВставлятьРазделительСтраниц = Ложь;
	
	ВыборкаДок = Запрос.Выполнить().Выбрать(ОбходРезультатаЗапроса.ПоГруппировкам);
	Пока ВыборкаДок.Следующий() Цикл
		
		Если ВставлятьРазделительСтраниц Тогда
			ТабДок.ВывестиГоризонтальныйРазделительСтраниц();
		КонецЕсли;
		
		ОбластьЗаголовок	= Макет.ПолучитьОбласть("Заголовок");
		ОбластьСклад		= Макет.ПолучитьОбласть("Склад");
		ОбластьШапкаТаблицы	= Макет.ПолучитьОбласть("ШапкаТаблицы");
		ОбластьСтрока		= Макет.ПолучитьОбласть("Строка");
		ОбластьПодвал		= Макет.ПолучитьОбласть("Подвал");
		ОбластьВремяПечати	= Макет.ПолучитьОбласть("ВремяПечати");
		
		Выборка = ВыборкаДок.Выбрать(ОбходРезультатаЗапроса.ПоГруппировкам);
		Пока Выборка.Следующий() Цикл
			Если ВставлятьРазделительСтраниц Тогда
				ТабДок.ВывестиГоризонтальныйРазделительСтраниц();
			КонецЕсли;
			
			ОбластьЗаголовок.Параметры.Заполнить(Выборка);
			ОбластьЗаголовок.Параметры.Дата = Формат(Выборка.Дата, "ДЛФ=DD");
			ОбщегоНазначенияКлиентСервер.ДобавитьQRКодВОбластьДокумента(ОбластьЗаголовок, Выборка.Ссылка);
			
			ТабДок.Вывести(ОбластьЗаголовок);
			
			ОбластьСклад.Параметры.Заполнить(Выборка);
			Если ЗначениеЗаполнено(Выборка.Камера) Тогда
				ОбластьСклад.Параметры.Вид		= "Камера:";
				ОбластьСклад.Параметры.Склад	= Выборка.Камера;
			Иначе
				ОбластьСклад.Параметры.Вид		= "Склад:";
				ОбластьСклад.Параметры.Склад	= Выборка.Склад;
			КонецЕсли;
			
			ТабДок.Вывести(ОбластьСклад, Выборка.Уровень());
			
			ТабДок.Вывести(ОбластьШапкаТаблицы);
			
			ВыборкаНоменклатура = Выборка.Товары.Выбрать();
			Пока ВыборкаНоменклатура.Следующий() Цикл
				ОбластьСтрока.Параметры.Заполнить(ВыборкаНоменклатура);
				ТабДок.Вывести(ОбластьСтрока, ВыборкаНоменклатура.Уровень());
			КонецЦикла;
			
			ТабДок.Вывести(ОбластьПодвал);
			
			ОбластьВремяПечати.Параметры.Заполнить(Выборка);
			ТекстВремяПечати = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
				НСтр("ru = '[%1] Автор: %2'"), ТекущаяДата(), Выборка.Автор);
			ОбластьВремяПечати.Параметры.ВремяПечати = ТекстВремяПечати;
			
			ТабДок.Вывести(ОбластьВремяПечати);
			
			ВставлятьРазделительСтраниц = Истина;
		КонецЦикла;
		
		ВставлятьРазделительСтраниц = Истина;
	КонецЦикла;
	
	Возврат ТабДок;

КонецФункции

Процедура ОбъединитьЗадания(МассивСсылок) Экспорт
	ИсходныйДок=МассивСсылок[0];
	НовДок=Документы.ЗаданиеНаИнвентаризацию.СоздатьДокумент();
	НовДок.Дата=ТекущаяДата();
	НовДок.Склад=ИсходныйДок.Склад;
	НовДок.Инвентаризация=ИсходныйДок.Инвентаризация;
	НовДок.Автор=ИсходныйДок.Автор;
	НовДок.СтруктурнаяЕдиница=ИсходныйДок.СтруктурнаяЕдиница;
	
	Для каждого Док Из МассивСсылок Цикл
		Для каждого Стр Из Док.Товары Цикл
			НовСтр=НовДок.Товары.Добавить();
			ЗаполнитьЗначенияСвойств(НовСтр,Стр);		
		КонецЦикла; 
	КонецЦикла; 
	НовДок.Записать(РежимЗаписиДокумента.Проведение);
	Сообщить("Создано новое задание на инвентаризацию - "+НовДок.Ссылка);
	Для каждого Док Из МассивСсылок Цикл
		ОбъектДок=Док.ПолучитьОбъект();
		Если ОбъектДок.Проведен Тогда
			ОбъектДок.Записать(РежимЗаписиДокумента.ОтменаПроведения);
		КонецЕсли; 
		ОбъектДок.ПометкаУдаления=Истина;
		ОбъектДок.Записать(РежимЗаписиДокумента.Запись);
	КонецЦикла; 
КонецПроцедуры
 