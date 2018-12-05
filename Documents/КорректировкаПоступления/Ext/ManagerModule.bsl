﻿
////////////////////////////////////////////////////////////////////////////////
// СЛУЖЕБНЫЕ ПРОЦЕДУРЫ И ФУНКЦИИ

Процедура ЗаполнитьПоПоступлению(Объект) Экспорт
	
	Если НЕ ЗначениеЗаполнено(Объект.ДокументПоступления) Тогда
		Возврат;
	КонецЕсли;
	
	Объект.Товары.Очистить();
	Объект.Услуги.Очистить();
	
	МетаданныеДокумента = Объект.ДокументПоступления.Метаданные();
	ИмяВидаДокумента = МетаданныеДокумента.Имя;
	
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("Ссылка", Объект.ДокументПоступления);
	Текст =
	"ВЫБРАТЬ
	|	ПоступлениеТоваровУслугТовары.Номенклатура,
	|	ПоступлениеТоваровУслугТовары.Номенклатура КАК НоменклатураДоИзменения,
	|	ПоступлениеТоваровУслугТовары.Количество,
	|	ПоступлениеТоваровУслугТовары.Количество КАК КоличествоДоИзменения,
	|	ПоступлениеТоваровУслугТовары.Цена,
	|	ПоступлениеТоваровУслугТовары.Цена КАК ЦенаДоИзменения,
	|	ПоступлениеТоваровУслугТовары.Сумма,
	|	ПоступлениеТоваровУслугТовары.Сумма КАК СуммаДоИзменения,
	|	ПоступлениеТоваровУслугТовары.СтавкаНДС,
	|	ПоступлениеТоваровУслугТовары.СтавкаНДС КАК СтавкаНДСДоИзменения,
	|	ПоступлениеТоваровУслугТовары.СуммаНДС,
	|	ПоступлениеТоваровУслугТовары.СуммаНДС КАК СуммаНДСДоИзменения,
	|	ПоступлениеТоваровУслугТовары.СчетУчета,
	|	ПоступлениеТоваровУслугТовары.Номенклатура.ЕдиницаХраненияОстатков КАК ЕдиницаИзмерения,
	|	ПоступлениеТоваровУслугТовары.Номенклатура.ЕдиницаХраненияОстатков.Коэффициент КАК Коэффициент,
	|	ПоступлениеТоваровУслугТовары.СтатьяТовародвижения,
	|	NULL КАК ТорговаяТочка,
	|	ПоступлениеТоваровУслугТовары.Количество - ПоступлениеТоваровУслугТовары.КоличествоПретензияКСкладу - ПоступлениеТоваровУслугТовары.ПоПриходнымОрдерам - ПоступлениеТоваровУслугТовары.КоличествоПретензияКПеревозчику КАК КоличествоПретензияПоставщику,";  //+++ AK suvv ИП-00020607 
	
	Если ИмяВидаДокумента = "КорректировкаПоступления" Тогда
		Текст = Текст + "
		|	ПоступлениеТоваровУслугТовары.КоличествоДоКорректировки,
		|	ПоступлениеТоваровУслугТовары.ЦенаДоКорректировки,
		|	ПоступлениеТоваровУслугТовары.СуммаДоКорректировки,
		|	ПоступлениеТоваровУслугТовары.СуммаНДСДоКорректировки,";
	КонецЕсли;
	
	Текст = Текст + "
	|	ИСТИНА КАК ЕстьВДокументеПоступления,
	|	""Товары"" КАК ТЧ,
	|	NULL КАК Содержание,
	|	NULL КАК СодержаниеДоИзменения,
	|	NULL КАК СчетЗатрат,
	|	NULL КАК Субконто1,
	|	NULL КАК Субконто2,
	|	NULL КАК Субконто3,
	|	NULL КАК СчетЗатратБУ,
	|	NULL КАК СубконтоБУ1,
	|	NULL КАК СубконтоБУ2,
	|	NULL КАК СубконтоБУ3,
	|	NULL КАК СчетЗатратНУ,
	|	NULL КАК СубконтоНУ1,
	|	NULL КАК СубконтоНУ2,
	|	NULL КАК СубконтоНУ3,
	|	NULL КАК ИнвентарныйНомер,
	|	NULL КАК ЗаводскойНомер,
	|	NULL КАК ОсновноеСредство,
	|	NULL КАК Инвестиция,
	|	NULL КАК СчетУчетаБУ,
	|	NULL КАК СрокАмортизации,
	|	NULL КАК НоменклатураПоставщика,
	|	NULL КАК Сделка,
	|	NULL КАК Предпоступление
	|ИЗ
	|	Документ." + ИмяВидаДокумента + ".Товары КАК ПоступлениеТоваровУслугТовары
	|ГДЕ
	|	ПоступлениеТоваровУслугТовары.Ссылка = &Ссылка
	|
	|ОБЪЕДИНИТЬ ВСЕ
	|
	|ВЫБРАТЬ
	|	ПоступлениеТоваровУслугУслуги.Номенклатура,
	|	ПоступлениеТоваровУслугУслуги.Номенклатура,
	|	ПоступлениеТоваровУслугУслуги.Количество,
	|	ПоступлениеТоваровУслугУслуги.Количество,
	|	ПоступлениеТоваровУслугУслуги.Цена,
	|	ПоступлениеТоваровУслугУслуги.Цена,
	|	ПоступлениеТоваровУслугУслуги.Сумма,
	|	ПоступлениеТоваровУслугУслуги.Сумма,
	|	ПоступлениеТоваровУслугУслуги.СтавкаНДС,
	|	ПоступлениеТоваровУслугУслуги.СтавкаНДС,
	|	ПоступлениеТоваровУслугУслуги.СуммаНДС,
	|	ПоступлениеТоваровУслугУслуги.СуммаНДС,
	|	NULL,
	|	NULL,
	|	NULL,
	|	NULL,
	|	ПоступлениеТоваровУслугУслуги.ТорговаяТочка,
	|	0,";
	
	Если ИмяВидаДокумента = "КорректировкаПоступления" Тогда
		Текст = Текст + "
		|	ПоступлениеТоваровУслугУслуги.КоличествоДоКорректировки,
		|	ПоступлениеТоваровУслугУслуги.ЦенаДоКорректировки,
		|	ПоступлениеТоваровУслугУслуги.СуммаДоКорректировки,
		|	ПоступлениеТоваровУслугУслуги.СуммаНДСДоКорректировки,";
	КонецЕсли;
	
	Текст = Текст + "
	|	ИСТИНА,
	|	""Услуги"",
	|	ПоступлениеТоваровУслугУслуги.Содержание,
	|	ПоступлениеТоваровУслугУслуги.Содержание,
	|	ПоступлениеТоваровУслугУслуги.СчетЗатрат,
	|	ПоступлениеТоваровУслугУслуги.Субконто1,
	|	ПоступлениеТоваровУслугУслуги.Субконто2,
	|	ПоступлениеТоваровУслугУслуги.Субконто3,
	|	ПоступлениеТоваровУслугУслуги.СчетЗатратБУ,
	|	ПоступлениеТоваровУслугУслуги.СубконтоБУ1,
	|	ПоступлениеТоваровУслугУслуги.СубконтоБУ2,
	|	ПоступлениеТоваровУслугУслуги.СубконтоБУ3,
	|	ПоступлениеТоваровУслугУслуги.СчетЗатратНУ,
	|	ПоступлениеТоваровУслугУслуги.СубконтоНУ1,
	|	ПоступлениеТоваровУслугУслуги.СубконтоНУ2,
	|	ПоступлениеТоваровУслугУслуги.СубконтоНУ3,
	|	NULL,
	|	NULL,
	|	NULL,
	|	NULL,
	|	NULL,
	|	NULL,
	|	NULL,
	|	NULL,
	|	NULL
	|ИЗ
	|	Документ." + ИмяВидаДокумента + ".Услуги КАК ПоступлениеТоваровУслугУслуги
	|ГДЕ
	|	ПоступлениеТоваровУслугУслуги.Ссылка = &Ссылка";
	
	//Оборудование
	
	Текст = Текст + "
	|
	|ОБЪЕДИНИТЬ ВСЕ
	|
	|ВЫБРАТЬ
	|	ПоступлениеТоваровУслугОборудование.Номенклатура,
	|	ПоступлениеТоваровУслугОборудование.Номенклатура,
	|	0,
	|	0,
	|	0,
	|	0,
	|	ПоступлениеТоваровУслугОборудование.Сумма,
	|	ПоступлениеТоваровУслугОборудование.Сумма,
	|	ПоступлениеТоваровУслугОборудование.СтавкаНДС,
	|	ПоступлениеТоваровУслугОборудование.СтавкаНДС,
	|	ПоступлениеТоваровУслугОборудование.СуммаНДС,
	|	ПоступлениеТоваровУслугОборудование.СуммаНДС,
	|	ПоступлениеТоваровУслугОборудование.СчетУчета,
	|	ПоступлениеТоваровУслугОборудование.Номенклатура.ЕдиницаХраненияОстатков,
	|	ПоступлениеТоваровУслугОборудование.Номенклатура.ЕдиницаХраненияОстатков.Коэффициент,
	|	NULL,
	|	ПоступлениеТоваровУслугОборудование.ТорговаяТочка,
	|	0,";
	
	Если ИмяВидаДокумента = "КорректировкаПоступления" Тогда
		Текст = Текст + "
		|	ПоступлениеТоваровУслугОборудование.КоличествоДоКорректировки,
		|	ПоступлениеТоваровУслугОборудование.ЦенаДоКорректировки,
		|	ПоступлениеТоваровУслугОборудование.СуммаДоКорректировки,
		|	ПоступлениеТоваровУслугОборудование.СуммаНДСДоКорректировки,";
	КонецЕсли;
	
	Текст = Текст + "
	|	ИСТИНА,
	|	""Оборудование"",
	|	"""",
	|	"""",
	|	NULL,
	|	NULL,
	|	NULL,
	|	NULL,
	|	NULL,
	|	NULL,
	|	NULL,
	|	NULL,
	|	NULL,
	|	NULL,
	|	NULL,
	|	NULL,	
	|	ПоступлениеТоваровУслугОборудование.ИнвентарныйНомер,
	|	ПоступлениеТоваровУслугОборудование.ЗаводскойНомер,
	|	ПоступлениеТоваровУслугОборудование.ОсновноеСредство,
	|	ПоступлениеТоваровУслугОборудование.Инвестиция,
	|	ПоступлениеТоваровУслугОборудование.СчетУчетаБУ,
	|	ПоступлениеТоваровУслугОборудование.СрокАмортизации,
	|	ПоступлениеТоваровУслугОборудование.НоменклатураПоставщика,
	|	ПоступлениеТоваровУслугОборудование.Сделка,
	|	ПоступлениеТоваровУслугОборудование.Предпоступление
	|ИЗ
	|	Документ." + ИмяВидаДокумента + ".Оборудование КАК ПоступлениеТоваровУслугОборудование
	|ГДЕ
	|	ПоступлениеТоваровУслугОборудование.Ссылка = &Ссылка";
	
	Запрос.Текст = Текст;
	Результат = Запрос.Выполнить().Выбрать();
	
	Пока Результат.Следующий() Цикл
		Если Результат.ТЧ = "Товары" Тогда
			
			СтрокаТоваров = Объект.Товары.Добавить();
			ЗаполнитьЗначенияСвойств(СтрокаТоваров, Результат);
			
			Если СтрокаТоваров.КоличествоПретензияПоставщику <> 0 Тогда
				
				СтрокаТоваров.Количество = СтрокаТоваров.Количество - СтрокаТоваров.КоличествоПретензияПоставщику;
				
				//
				СтрокаТоваров.Сумма = СтрокаТоваров.Цена * СтрокаТоваров.Количество;
				
				СуммаВключаетНДС = (Объект.ВариантРасчетаНДС = ПредопределенноеЗначение("Перечисление.ВариантыРасчетаНДС.НДСвТомЧисле"));
				УчитыватьНДС = Истина;
				
				СтрокаТоваров.СуммаНДС = УчетНДС.РассчитатьСуммуНДС(СтрокаТоваров.Сумма,
																	УчитыватьНДС, СуммаВключаетНДС,
																	УчетНДС.ПолучитьСтавкуНДС(СтрокаТоваров.СтавкаНДС));
																	
			КонецЕсли;
				
		ИначеЕсли Результат.ТЧ = "Услуги" Тогда
			СтрокаУслуг = Объект.Услуги.Добавить();
			ЗаполнитьЗначенияСвойств(СтрокаУслуг, Результат);
		ИначеЕсли Результат.ТЧ = "Оборудование" Тогда
			СтрокаОб = Объект.Оборудование.Добавить();
			ЗаполнитьЗначенияСвойств(СтрокаОб, Результат);
		КонецЕсли;
	КонецЦикла;
		
КонецПроцедуры

Процедура ЗаполнитьПоДокументу(Объект) Экспорт
	
	Если ТипЗнч(Объект.ДокументПоступления) = Тип("ДокументСсылка.ПоступлениеТоваровУслуг") 
		ИЛИ ТипЗнч(Объект.ДокументПоступления) = Тип("ДокументСсылка.КорректировкаПоступления") Тогда
		ЗаполнитьПоПоступлению(Объект);
	КонецЕсли;
	
КонецПроцедуры
