﻿
// Функция возвращает таблицу значений для заполнение табличной части Товары по документу основанию.
// При заполнении копируется состав документа.
//
// Параметры:
//  ДанныеОбъекта     - данные текущего объекта.
//  ДокументОснование - ссылка на документ основание.
//
Функция ТоварыПоДаннымОснования(ДанныеОбъекта, ДокументОснование) Экспорт
	
	ТаблицаЗначенийТовары = ДанныеОбъекта.Товары.Выгрузить().СкопироватьКолонки();
	Запрос = Новый Запрос;
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	РеализацияТоваровУслугТовары.Номенклатура,
	|	РеализацияТоваровУслугТовары.ЕдиницаИзмерения,
	|	РеализацияТоваровУслугТовары.Коэффициент,
	|	РеализацияТоваровУслугТовары.Количество,
	|	РеализацияТоваровУслугТовары.Цена,
	|	РеализацияТоваровУслугТовары.Сумма,
	|	РеализацияТоваровУслугТовары.СтавкаНДС,
	|	РеализацияТоваровУслугТовары.СуммаНДС,
	|	РеализацияТоваровУслугТовары.СчетУчета,
	|	РеализацияТоваровУслугТовары.СтатьяТовародвижения,
	|	РеализацияТоваровУслугТовары.ПоРасходнымОрдерам
	|ИЗ
	|	Документ.РеализацияТоваровУслуг.Товары КАК РеализацияТоваровУслугТовары
	|ГДЕ
	|	РеализацияТоваровУслугТовары.Ссылка = &Ссылка";
	Запрос.УстановитьПараметр("Ссылка", ДокументОснование);
	РезультатЗапроса = Запрос.Выполнить();
		
	Выборка = РезультатЗапроса.Выбрать();
	Пока Выборка.Следующий() Цикл
		
		СтрокаТабличнойЧасти = ТаблицаЗначенийТовары.Добавить();
		ЗаполнитьЗначенияСвойств(СтрокаТабличнойЧасти, Выборка);
		СтрокаТабличнойЧасти.Сделка = ДокументОснование;
		СтрокаТабличнойЧасти.СтатьяТовародвижения = Справочники.СтатьиТовародвижения.ПоступлениеОтПокупателя;
		//РассчитатьСуммуСтрокиТЧ(СтрокаТабличнойЧасти);
		//РассчитатьСуммуНДССтрокиТЧ(СтрокаТабличнойЧасти, ДанныеОбъекта.СуммаВключаетНДС);
		
	КонецЦикла;
	
	Возврат ТаблицаЗначенийТовары;
	
КонецФункции

//+++AK GREK 28.07.2018 ИП-00019390      
Функция ПечатьСписанияТовараПоВозвратамОтX5(Период) Экспорт
	ПечатныеФормы = Новый Структура;
	ТабДок = Новый ТабличныйДокумент;
	Макет = ПолучитьМакет("СписанияТовараПоВозвратамОтX5");
	
	//Формируем 1 страницу
	Шапка = Макет.ПолучитьОбласть("Шапка");
	НомерДокумента = ((Год(Период.КонецПериода) - 2018) * 12) + Месяц(Период.КонецПериода) - 3;//необходимо вести нумерацию с апреля 2018 - №1 и т.д. помесячно.
	Если НомерДокумента > 0 Тогда
	  	Шапка.Параметры.НомерДокумента =  НомерДокумента;
	КонецЕсли;
	Шапка.Параметры.ДатаСоставления = Период.КонецПериода;
	ТабДок.Вывести(Шапка);
	
	Запрос = Новый Запрос;
	Запрос.Текст = "ВЫБРАТЬ
	               |	ВозвратТоваровОтПокупателя.ДатаВходящегоДокумента КАК ДатаПоступления,
	               |	ВозвратТоваровОтПокупателя.ДатаВходящегоДокумента КАК ДатаСписания,
	               |	ВозвратТоваровОтПокупателя.НомерВходящегоДокумента КАК НомерДокумента,
	               |	ВозвратТоваровОтПокупателя.ДатаВходящегоДокумента КАК ДатаДокумента
	               |ИЗ
	               |	Документ.ВозвратТоваровОтПокупателя КАК ВозвратТоваровОтПокупателя
	               |ГДЕ
	               |	ВозвратТоваровОтПокупателя.Проведен = ИСТИНА
	               |	И ВозвратТоваровОтПокупателя.Дата МЕЖДУ &НачалоПериода И &КонецПериода";
	Запрос.УстановитьПараметр("НачалоПериода", Период.НачалоПериода); 
	Запрос.УстановитьПараметр("КонецПериода", Период.КонецПериода); 
	Рез = Запрос.Выполнить();
	Если НЕ Рез.Пустой() Тогда
		Строка = Макет.ПолучитьОбласть("Строка");
		Выборка = Рез.Выбрать();
		Пока Выборка.Следующий() Цикл
			ЗаполнитьЗначенияСвойств(Строка.Параметры,Выборка);
			ТабДок.Вывести(Строка);
		КонецЦикла;
	КонецЕсли;
	ПечатныеФормы.Вставить("Стр1", ТабДок);

	//Формируем 2 страницу
	ТабДок = Новый ТабличныйДокумент;
	Шапка = Макет.ПолучитьОбласть("Шапка2");
	ТабДок.Вывести(Шапка);
	Запрос = Новый Запрос;
	Запрос.Текст = "ВЫБРАТЬ
	               |	ВозвратТоваровОтПокупателяТовары.Номенклатура,
	               |	ВозвратТоваровОтПокупателяТовары.ЕдиницаИзмерения,
	               |	ВозвратТоваровОтПокупателяТовары.ЕдиницаИзмерения.ЕдиницаПоКлассификатору.Код КАК ЕдиницаИзмеренияКод,
	               |	СУММА(ВЫБОР
	               |			КОГДА ВозвратТоваровОтПокупателяТовары.ЕдиницаИзмерения.ЕдиницаПоКлассификатору.Код = ""796""
	               |				ТОГДА ВозвратТоваровОтПокупателяТовары.Количество
	               |			КОГДА ВозвратТоваровОтПокупателяТовары.ЕдиницаИзмерения.ЕдиницаПоКлассификатору.Код В (""1"", ""166"", ""168"")
	               |				ТОГДА ВозвратТоваровОтПокупателяТовары.Количество * ВозвратТоваровОтПокупателяТовары.ЕдиницаИзмерения.Вес
	               |			ИНАЧЕ NULL
	               |		КОНЕЦ) КАК Количество,
	               |	МАКСИМУМ(ВозвратТоваровОтПокупателяТовары.Цена) КАК Цена,
	               |	СУММА(ВозвратТоваровОтПокупателяТовары.Сумма) КАК Стоимость,
	               |	ВозвратТоваровОтПокупателяТовары.Номенклатура.Код КАК Код
	               |ИЗ
	               |	Документ.ВозвратТоваровОтПокупателя.Товары КАК ВозвратТоваровОтПокупателяТовары
	               |ГДЕ
	               |	ВозвратТоваровОтПокупателяТовары.Ссылка.Проведен = ИСТИНА
	               |	И ВозвратТоваровОтПокупателяТовары.Ссылка.Дата МЕЖДУ &НачалоПериода И &КонецПериода
	               |
	               |СГРУППИРОВАТЬ ПО
	               |	ВозвратТоваровОтПокупателяТовары.ЕдиницаИзмерения,
	               |	ВозвратТоваровОтПокупателяТовары.ЕдиницаИзмерения.ЕдиницаПоКлассификатору.Код,
	               |	ВозвратТоваровОтПокупателяТовары.Номенклатура,
	               |	ВозвратТоваровОтПокупателяТовары.Номенклатура.Код";
	Запрос.УстановитьПараметр("НачалоПериода", Период.НачалоПериода); 
	Запрос.УстановитьПараметр("КонецПериода", Период.КонецПериода); 
	Рез = Запрос.Выполнить();
	ИтогоСтоимость = 0;
	Если НЕ Рез.Пустой() Тогда
		Строка = Макет.ПолучитьОбласть("Строка2");
		Выборка = Рез.Выбрать();
		Пока Выборка.Следующий() Цикл
			ЗаполнитьЗначенияСвойств(Строка.Параметры,Выборка);
			ТабДок.Вывести(Строка);
			ИтогоСтоимость = ИтогоСтоимость + Выборка.Стоимость;
		КонецЦикла;
	КонецЕсли;
	Подвал = Макет.ПолучитьОбласть("Подвал2");
	Подвал.Параметры.ИтогоСтоимость = ИтогоСтоимость;
	ИтогоСтоимостьРуб = ЧислоПрописью(ИтогоСтоимость, "Л=ru_RU;НП=ЛОЖЬ", "рубль,рубля,рублей,м,копейка,копейки,копеек,ж,0");
	Подвал.Параметры.ИтогоСтоимостьРуб1 = ИтогоСтоимостьРуб;
	Подвал.Параметры.ИтогоСтоимостьКоп = (ИтогоСтоимость - Цел(ИтогоСтоимость))*100;
	ТабДок.Вывести(Подвал);

	ПечатныеФормы.Вставить("Стр2", ТабДок);
	
 
	Возврат ПечатныеФормы;
КонецФункции