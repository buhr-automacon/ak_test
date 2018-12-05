﻿
Функция ПечатьЗаявкиСтороннееФизЛицо(Заявка) Экспорт
	
	Таб = Новый ТабличныйДокумент();
	Макет = Документы.ЗаявкаНаРасходованиеСредств.ПолучитьМакет("ЗаявкаСтороннееФизЛицо");
	
	Запрос = Новый Запрос();
	Запрос.УстановитьПараметр("Ссылка", Заявка);
	Запрос.Текст =
	"ВЫБРАТЬ
	|	ЗаявкаНаРасходованиеСредств.Номер,
	|	ЗаявкаНаРасходованиеСредств.Дата,
	|	ЗаявкаНаРасходованиеСредств.Организация,
	|	ЗаявкаНаРасходованиеСредств.ДатаРасхода КАК ОплатитьДо,
	|	ЗаявкаНаРасходованиеСредств.СуммаДокумента КАК Сумма,
	|	ЗаявкаНаРасходованиеСредств.БанковскийСчетКасса КАК Касса,
	|	ВЫБОР
	|		КОГДА ЗаявкаНаРасходованиеСредств.Статус = ЗНАЧЕНИЕ(Перечисление.СтатусыЗаявокНаРасходованиеСредств.Акцептована)
	|			ТОГДА ИСТИНА
	|		ИНАЧЕ ЛОЖЬ
	|	КОНЕЦ КАК Акцептована,
	|	ЗаявкаНаРасходованиеСредств.ПринятоКОплате КАК Принята,
	|	ЗаявкаНаРасходованиеСредств.Контрагент КАК Получатель,
	|	ЗаявкаНаРасходованиеСредств.ВнешнееФизЛицоФамилия КАК Фамилия,
	|	ЗаявкаНаРасходованиеСредств.ВнешнееФизЛицоИмя КАК Имя,
	|	ЗаявкаНаРасходованиеСредств.ВнешнееФизЛицоОтчество КАК Отчество,
	|	ЗаявкаНаРасходованиеСредств.ЦФО,
	|	ЗаявкаНаРасходованиеСредств.СтатьяДвиженияДенежныхСредств КАК СтатьяДДС,
	|	ЗаявкаНаРасходованиеСредств.НазначениеПлатежа КАК Назначение,
	|	ЗаявкаНаРасходованиеСредств.Ответственный,
	|	ЗаявкаНаРасходованиеСредств.Комментарий
	|ИЗ
	|	Документ.ЗаявкаНаРасходованиеСредств КАК ЗаявкаНаРасходованиеСредств
	|ГДЕ
	|	ЗаявкаНаРасходованиеСредств.Ссылка = &Ссылка
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ЗаявкаНаРасходованиеСредствТорговыеТочки.НомерСтроки КАК НомерСтроки,
	|	ЗаявкаНаРасходованиеСредствТорговыеТочки.ТорговаяТочка КАК ТТ,
	|	ЗаявкаНаРасходованиеСредствТорговыеТочки.ЦФО,
	|	ЗаявкаНаРасходованиеСредствТорговыеТочки.Адрес,
	|	ЗаявкаНаРасходованиеСредствТорговыеТочки.Управляющий,
	|	ЗаявкаНаРасходованиеСредствТорговыеТочки.Статус,
	|	ЗаявкаНаРасходованиеСредствТорговыеТочки.Сумма,
	|	ЗаявкаНаРасходованиеСредствТорговыеТочки.НачалоПериода КАК НачПериода,
	|	ЗаявкаНаРасходованиеСредствТорговыеТочки.КонецПериода КАК КонПериода
	|ИЗ
	|	Документ.ЗаявкаНаРасходованиеСредств.ТорговыеТочки КАК ЗаявкаНаРасходованиеСредствТорговыеТочки
	|ГДЕ
	|	ЗаявкаНаРасходованиеСредствТорговыеТочки.Ссылка = &Ссылка
	|
	|УПОРЯДОЧИТЬ ПО
	|	НомерСтроки";
	
	Результаты = Запрос.ВыполнитьПакет();
	
	Выборка = Результаты[0].Выбрать();
	Выборка.Следующий();
	
	ТабТТ = Результаты[1].Выгрузить();
	
	Область = Макет.ПолучитьОбласть("Заголовок");
	Область.Параметры.Заполнить(Выборка);
	Таб.Вывести(Область);
	
	Если ТабТТ.Количество() > 0 Тогда
		
		Если ЗначениеЗаполнено(ТабТТ[0].НачПериода) Тогда
			ОбластьШапка 	= Макет.ПолучитьОбласть("ШапкаТаб1");
			ОбластьСтрока 	= Макет.ПолучитьОбласть("СтрокаТаб1");
		Иначе	
			ОбластьШапка 	= Макет.ПолучитьОбласть("ШапкаТаб");
			ОбластьСтрока 	= Макет.ПолучитьОбласть("СтрокаТаб");
		КонецЕсли;
		
		Таб.Вывести(ОбластьШапка);
		Для Каждого СтрокаТТ Из ТабТТ Цикл
			ОбластьСтрока.Параметры.Заполнить(СтрокаТТ);
			Таб.Вывести(ОбластьСтрока);
		КонецЦикла;	
		
		Таб.Вывести(Макет.ПолучитьОбласть("ПодвалТаблицы"));
	КонецЕсли;	
	
	
	Таб.ТолькоПросмотр 		= Истина;
	Таб.ОтображатьЗаголовки = Ложь;
	Таб.ОтображатьСетку 	= Ложь;
	
	Возврат Таб;
	
КонецФункции

Функция ПечатьЗаявки(Заявка) Экспорт
	
	Таб = Новый ТабличныйДокумент();
	Макет = Документы.ЗаявкаНаРасходованиеСредств.ПолучитьМакет("Макет");
	
	Запрос = Новый Запрос();
	Запрос.УстановитьПараметр("Ссылка", Заявка);
	Запрос.Текст =
	"ВЫБРАТЬ
	|	ЗаявкаНаРасходованиеСредств.Номер,
	|	ЗаявкаНаРасходованиеСредств.Дата,
	|	ЗаявкаНаРасходованиеСредств.ФормаОплаты,
	|	ЗаявкаНаРасходованиеСредств.Организация,
	|	ЗаявкаНаРасходованиеСредств.ДатаРасхода КАК ОплатитьДо,
	|	ЗаявкаНаРасходованиеСредств.СуммаДокумента КАК Сумма,
	|	ВЫБОР
	|		КОГДА ЗаявкаНаРасходованиеСредств.Статус = ЗНАЧЕНИЕ(Перечисление.СтатусыЗаявокНаРасходованиеСредств.Акцептована)
	|			ТОГДА ИСТИНА
	|		ИНАЧЕ ЛОЖЬ
	|	КОНЕЦ КАК Акцептована,
	|	ЗаявкаНаРасходованиеСредств.ПринятоКОплате КАК Принята,
	|	ЗаявкаНаРасходованиеСредств.Контрагент КАК Получатель,
	|	ЗаявкаНаРасходованиеСредств.ДоговорКонтрагента КАК ДоговорКонтрагента,
	|	ЗаявкаНаРасходованиеСредств.ЦФО,
	|	ЗаявкаНаРасходованиеСредств.СтатьяДвиженияДенежныхСредств КАК СтатьяДДС,
	|	ЗаявкаНаРасходованиеСредств.НазначениеПлатежа КАК Назначение,
	|	ЗаявкаНаРасходованиеСредств.СтавкаНДС КАК СтавкаНДС,
	|	ЗаявкаНаРасходованиеСредств.СуммаНДС КАК СуммаНДС,
	|	ЗаявкаНаРасходованиеСредств.Пояснение
	|ИЗ
	|	Документ.ЗаявкаНаРасходованиеСредств КАК ЗаявкаНаРасходованиеСредств
	|ГДЕ
	|	ЗаявкаНаРасходованиеСредств.Ссылка = &Ссылка
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ЗаявкаНаРасходованиеСредствТорговыеТочки.НомерСтроки КАК НомерСтроки,
	|	ЗаявкаНаРасходованиеСредствТорговыеТочки.ТорговаяТочка КАК ТТ,
	|	ЗаявкаНаРасходованиеСредствТорговыеТочки.ТорговаяТочка.id_TT КАК id_TT,
	|	ЗаявкаНаРасходованиеСредствТорговыеТочки.ЦФО,
	|	ЗаявкаНаРасходованиеСредствТорговыеТочки.Адрес,
	|	ЗаявкаНаРасходованиеСредствТорговыеТочки.Управляющий,
	|	ЗаявкаНаРасходованиеСредствТорговыеТочки.Статус,
	|	ЗаявкаНаРасходованиеСредствТорговыеТочки.Сумма,
	|	ЗаявкаНаРасходованиеСредствТорговыеТочки.НачалоПериода КАК НачПериода,
	|	ЗаявкаНаРасходованиеСредствТорговыеТочки.КонецПериода КАК КонПериода
	|ИЗ
	|	Документ.ЗаявкаНаРасходованиеСредств.ТорговыеТочки КАК ЗаявкаНаРасходованиеСредствТорговыеТочки
	|ГДЕ
	|	ЗаявкаНаРасходованиеСредствТорговыеТочки.Ссылка = &Ссылка
	|
	|УПОРЯДОЧИТЬ ПО
	|	НомерСтроки";
	
	Результаты = Запрос.ВыполнитьПакет();
	
	Выборка = Результаты[0].Выбрать();
	Выборка.Следующий();
	
	ТабТТ = Результаты[1].Выгрузить();
	
	Область = Макет.ПолучитьОбласть("Заголовок");
	Область.Параметры.Заполнить(Выборка);
	Область.Параметры.Дата = Формат(Выборка.Дата, "ДЛФ=Д");
	Если Выборка.СуммаНДС = 0 Тогда
		Область.Параметры.СуммаНДС = "-";
	КонецЕсли;
	Если ТабТТ.Количество() > 0 Тогда
		ЕстьТТ = Ложь;
		Для Каждого СтрокаТТ Из ТабТТ Цикл
			Если НЕ СтрокаТТ.id_TT = 0 Тогда
				ЕстьТТ = Истина;
				Прервать;
			КонецЕсли;
		КонецЦикла;
		Область.Параметры.СчетУчетаЗатрат = ?(ЕстьТТ, "44.3", "44.2");
	Иначе
		Область.Параметры.СчетУчетаЗатрат = "";
	КонецЕсли;
	Таб.Вывести(Область);
	
	Если ТабТТ.Количество() > 0 Тогда
		
		Если ЗначениеЗаполнено(ТабТТ[0].НачПериода) Тогда
			ОбластьШапка 	= Макет.ПолучитьОбласть("ШапкаТаб1");
			ОбластьСтрока 	= Макет.ПолучитьОбласть("СтрокаТаб1");
		Иначе	
			ОбластьШапка 	= Макет.ПолучитьОбласть("ШапкаТаб");
			ОбластьСтрока 	= Макет.ПолучитьОбласть("СтрокаТаб");
		КонецЕсли;
		
		Таб.Вывести(ОбластьШапка);
		Для Каждого СтрокаТТ Из ТабТТ Цикл
			ОбластьСтрока.Параметры.Заполнить(СтрокаТТ);
			Таб.Вывести(ОбластьСтрока);
		КонецЦикла;	
		
		Таб.Вывести(Макет.ПолучитьОбласть("ПодвалТаблицы"));
	КонецЕсли;	
	
	
	Таб.ТолькоПросмотр 		= Истина;
	Таб.ОтображатьЗаголовки = Ложь;
	Таб.ОтображатьСетку 	= Ложь;
	
	Возврат Таб;
	
КонецФункции

//+++АК POZM 2017.12.26 ИП-00017539 
Функция ПечатьЗаявленияНаАванс(Заявка) Экспорт
	Таб = Новый ТабличныйДокумент();
	Макет = Документы.ЗаявкаНаРасходованиеСредств.ПолучитьМакет("ЗаявлениеНаАванс");
	
	Запрос = Новый Запрос();
	Запрос.УстановитьПараметр("Ссылка", Заявка);
	Запрос.Текст =
	"ВЫБРАТЬ
	|	МАКСИМУМ(ЗаявкаНаРасходованиеСредствГрафикПогашенияЗайма.ДатаПлатежа) КАК ДатаОкончания,
	|	МИНИМУМ(ЗаявкаНаРасходованиеСредствГрафикПогашенияЗайма.ДатаПлатежа) КАК ДатаНачала,
	|	ЗаявкаНаРасходованиеСредствГрафикПогашенияЗайма.Ссылка.СуммаДокумента КАК Сумма,
	|	ЗаявкаНаРасходованиеСредствГрафикПогашенияЗайма.Ссылка.Организация.НаименованиеСокращенное КАК Организация,
	|	ЗаявкаНаРасходованиеСредствГрафикПогашенияЗайма.Ссылка.Дата КАК ДатаЗаявки,
	|	ЗаявкаНаРасходованиеСредствГрафикПогашенияЗайма.Ссылка.Организация КАК ОрганизацияДокумента
	|ИЗ
	|	Документ.ЗаявкаНаРасходованиеСредств.ГрафикПогашенияЗайма КАК ЗаявкаНаРасходованиеСредствГрафикПогашенияЗайма
	|ГДЕ
	|	ЗаявкаНаРасходованиеСредствГрафикПогашенияЗайма.Ссылка = &Ссылка
	|
	|СГРУППИРОВАТЬ ПО
	|	ЗаявкаНаРасходованиеСредствГрафикПогашенияЗайма.Ссылка.ДатаРасхода,
	|	ЗаявкаНаРасходованиеСредствГрафикПогашенияЗайма.Ссылка.СуммаДокумента,
	|	ЗаявкаНаРасходованиеСредствГрафикПогашенияЗайма.Ссылка.Дата,
	|	ЗаявкаНаРасходованиеСредствГрафикПогашенияЗайма.Ссылка.Организация.НаименованиеСокращенное,
	|	ЗаявкаНаРасходованиеСредствГрафикПогашенияЗайма.Ссылка.Организация";
	
	Выборка = Запрос.Выполнить().Выбрать();
	Выборка.Следующий();
	
	
	
	Область = Макет.ПолучитьОбласть("Заявление");
	Область.Параметры.Заполнить(Выборка);
	
	Область.Параметры.ДатаНачала = Формат(Выборка.ДатаНачала,"ДФ=MMMM.yyyy");
	Область.Параметры.ДатаОкончания = Формат(Выборка.ДатаОкончания,"ДФ=MMMM.yyyy");
	
	Руководители = РегламентированнаяОтчетность.ОтветственныеЛицаОрганизаций(Выборка.ОрганизацияДокумента, Выборка.ДатаЗаявки);
	Область.Параметры.Руководитель = ОбщегоНазначения.ПадежФИО(Руководители.Руководитель, 3);
	
	мВалютаРегламентированногоУчета   = Константы.ВалютаРегламентированногоУчета.Получить();
	
	Область.Параметры.СуммаПрописью = ОбщегоНазначения.СформироватьСуммуПрописью(Выборка.Сумма, мВалютаРегламентированногоУчета);;
		
	Таб.Вывести(Область);
		
	
	Таб.ТолькоПросмотр 		= Истина;
	Таб.ОтображатьЗаголовки = Ложь;
	Таб.ОтображатьСетку 	= Ложь;
	
	Возврат Таб;

КонецФункции	
//---АК POZM 

// Определяет номер расчетного счета по переданному банковскому счету
//
// Параметры:
//  СчетКонтрагента - справочник.БанковскиеСчета
//
// Возвращаемое значение
//  Номер расчетного счета
//
Функция ВернутьРасчетныйСчет(мСчетКонтрагента)
	
	БанкДляРасчетов = мСчетКонтрагента.БанкДляРасчетов;
	Результат       = ?(БанкДляРасчетов.Пустая(), мСчетКонтрагента.НомерСчета, мСчетКонтрагента.Банк.КоррСчет);

	Возврат Результат;
	
КонецФункции

// Форматирует сумму прописью документа
//
// Параметры:
//  СуммаДок 		- Число - реквизит, который надо представить прописью ;
//  СуммаБезКопеек 	- Булево - флаг представления суммы без копеек.
//
// Возвращаемое значение
//  Отформатированная строка
//
Функция ФорматироватьСуммуПрописи(СуммаДок, СуммаБезКопеек, ПарамПредмета)
	
	Результат     = СуммаДок;
	ЦелаяЧасть    = Цел(СуммаДок);
	ФорматСтрока  = "Л=ru_RU; ДП=Ложь";
	
	Если (Результат - ЦелаяЧасть) = 0 Тогда
		Если СуммаБезКопеек Тогда
			Результат = ЧислоПрописью(Результат, ФорматСтрока, ПарамПредмета);
			Результат = Лев(Результат,Найти(Результат, "0") - 1);
		Иначе
			Результат = ЧислоПрописью(Результат, ФорматСтрока, ПарамПредмета);
		КонецЕсли;
	Иначе
		Результат = ЧислоПрописью(Результат, ФорматСтрока, ПарамПредмета);
	КонецЕсли;
	
	Возврат Результат;
	
КонецФункции

// Форматирует сумму  документа
//
// Параметры:
//  СуммаДок - число - реквизит, который надо отформатировать
//  СуммаБезКопеек - булево - флаг представления суммы без копеек
//
// Возвращаемое значение
//  Отформатированную строку
//
Функция ФорматироватьСумму(СуммаДок, СуммаБезКопеек)
	
	Результат  = СуммаДок;
	ЦелаяЧасть = Цел(СуммаДок);
	
	Если (Результат - ЦелаяЧасть) = 0 Тогда
		Если СуммаБезКопеек Тогда
			Результат = Формат(Результат, "ЧДЦ=2; ЧРД='='; ЧГ=0");
			Результат = Лев(Результат, Найти(Результат, "="));
		Иначе
			Результат = Формат(Результат, "ЧДЦ=2; ЧРД='-'; ЧГ=0");
		КонецЕсли;
	Иначе
		Результат = Формат(Результат, "ЧДЦ=2; ЧРД='-'; ЧГ=0");
	КонецЕсли;
	
	Возврат Результат;
	
КонецФункции

Процедура ПроверитьЗаполнениеРеквизитовНалоговыхПлатежей(СписокОшибок, П101, П105, П106, П107, П108, П109, П110)

	Если ПустаяСтрока(П105) Тогда
		СписокОшибок.Добавить("Необходимо заполнить поле ""Код ОКАТО"" на закладке ""Перечисление в бюджет"".");
	КонецЕсли;
	
	Если П101 = "08" Тогда
		
		СписокОшибок.Добавить("Возможно, неверно указано значение в поле ""Статус составителя"" на закладке ""Перечисление в бюджет""." 
			+ Символы.ПС + Символы.Таб + "Статус ""08"" соответствует виду перечисления ""Иной платеж"".");
		
		Если СтрЗаменить(П106, "0", "") <> "" Тогда 
			СписокОшибок.Добавить("При статусе составителя ""08"" следует указать ""0"" в поле ""Основание платежа"" на закладке ""Перечисление в бюджет"".");
		КонецЕсли;
		Если СтрЗаменить(П107, "0", "") <> "" Тогда
			СписокОшибок.Добавить("При статусе составителя ""08"" следует указать ""0"" в поле ""Налоговый период"" на закладке ""Перечисление в бюджет"".");
		КонецЕсли;
		Если СтрЗаменить(П108, "0", "") <> "" Тогда
			СписокОшибок.Добавить("При статусе составителя ""08"" не следует заполнять поле ""Номер документа"" на закладке ""Перечисление в бюджет"".");
		КонецЕсли;
		Если СтрЗаменить(П109, "0", "") <> "" Тогда
			СписокОшибок.Добавить("При статусе составителя ""08"" не следует заполнять поле ""Дата документа"" на закладке ""Перечисление в бюджет"".");
		КонецЕсли;
		Если СтрЗаменить(П110, "0", "") <> "" Тогда
			СписокОшибок.Добавить("При статусе составителя ""08"" следует указать ""0"" в поле ""Тип платежа"" на закладке ""Перечисление в бюджет"".");
		КонецЕсли;
		
	Иначе
		
		Если СтрЗаменить(СокрЛП(П106), "0", "") = "" Тогда
			Если СтрЗаменить(П107, "0", "") <> "" Тогда
				Если НЕ ЗначениеЗаполнено(П107) Тогда
					СписокОшибок.Добавить("Возможно, неверно указано значение в поле ""Налоговый период"" на закладке ""Перечисление в бюджет""."); 
				КонецЕсли;
			КонецЕсли;
		ИначеЕсли СтрДлина(П106) <> 2 Тогда
			СписокОшибок.ДобавитьЗначение("Возможно, неверно заполнено поле ""Основание платежа"" на закладке ""Перечисление в бюджет"".");
			Если СтрЗаменить(П107, "0", "") <> "" Тогда
				Если НЕ ЗначениеЗаполнено(П107) Тогда
					СписокОшибок.Добавить("Возможно, неверно указано значение в поле ""Налоговый период"" на закладке ""Перечисление в бюджет""."); 
				КонецЕсли;
			КонецЕсли;
		ИначеЕсли Найти("АП, АР", П106) > 0 Тогда
			Если СтрЗаменить(П107, "0", "") <> "" Тогда
				СписокОшибок.Добавить("При основании платежа ""АП"" или ""АР"" следует указать ""0"" в поле ""Налоговый период"" на закладке ""Перечисление в бюджет"".");
			КонецЕсли;
		ИначеЕсли Найти("ТР, РС, ОТ, РТ, ВУ, ПР", П106) > 0 Тогда
			Если СтрЗаменить(П107, "0", "") <> "" Тогда
				Если НЕ ЗначениеЗаполнено(П107) Тогда
					СписокОшибок.Добавить("Возможно, неверно указано значение в поле ""Налоговый период"" на закладке ""Перечисление в бюджет""."); 
				КонецЕсли;
			КонецЕсли;
		ИначеЕсли Найти("ТП ,ЗД ", П106) > 0 Тогда
			Если СтрЗаменить(П107,"0","")<>"" Тогда
				ДД = Сред((П107), 1, 2);
				ММ = Сред((П107), 4, 2);
				ГГ = Сред((П107), 7, 4);
				
				Если НЕ ММ="" Тогда
					ММ = Число(Сред((П107), 4, 2));
				Иначе
					ММ = 0;
				КонецЕсли;	
				
				Если НЕ ГГ="" Тогда
					ГГ = Число(Сред((П107), 7, 4));
				Иначе
					ГГ = 0;
				КонецЕсли;
				
				Если (Найти("Д1, Д2, Д3, МС", ДД) > 0) Тогда
					Если (ММ < 1)или
						(ММ > 12)или 
						(ГГ < 2000)или
						(СтрДлина(П107) - СтрДлина(СтрЗаменить(П107, ".", "")) <> 2) Тогда
						СписокОшибок.Добавить("Возможно, неверно указано значение в поле ""Налоговый период"" на закладке ""Перечисление в бюджет""."); 
					КонецЕсли;
				ИначеЕсли (Найти("КВ", ДД) > 0) Тогда
					Если (ММ < 1)или
						(ММ > 4)или 
						(ГГ < 2000)или
						(СтрДлина(П107) - СтрДлина(СтрЗаменить(П107, ".", "")) <> 2) Тогда
						СписокОшибок.Добавить("Неверно указано значение в поле ""Налоговый период"" на закладке ""Перечисление в бюджет""."); 
					КонецЕсли;
				ИначеЕсли (Найти("ПЛ", ДД) > 0) Тогда
					Если (ММ < 1)или
						(ММ > 2)или 
						(ГГ < 2000)или
						(СтрДлина(П107) - СтрДлина(СтрЗаменить(П107, ".", "")) <> 2) Тогда
						СписокОшибок.Добавить("Неверно указано значение в поле ""Налоговый период"" на закладке ""Перечисление в бюджет""."); 
					КонецЕсли;
				ИначеЕсли (Найти("ГД", ДД) > 0) Тогда
					Если (ММ <> 0)или
						(ГГ < 2000)или
						(СтрДлина(П107) - СтрДлина(СтрЗаменить(П107, ".", "")) <> 2) Тогда
						СписокОшибок.Добавить("Неверно указано значение в поле ""Налоговый период"" на закладке ""Перечисление в бюджет""."); 
					КонецЕсли;
				Иначе
					Если НЕ ЗначениеЗаполнено(П107) Тогда
						СписокОшибок.Добавить("Возможно, неверно указано значение в поле ""Налоговый период"" на закладке ""Перечисление в бюджет""."); 
					КонецЕсли;
				КонецЕсли;
			КонецЕсли;
			Если СтрЗаменить(П108, "0", "") <> "" Тогда
				СписокОшибок.Добавить("При основании платежа ""ТП"" или ""ЗД"" необходимо указывать ""0"" в поле ""Номер документа"" на закладке ""Перечисление в бюджет"".");
			КонецЕсли;
			Если Найти("ЗД ", П106) > 0 Тогда
				Если СтрЗаменить(П109, "0", "") <> "" Тогда
					СписокОшибок.Добавить("При основании платежа ""ЗД"" не должно заполняться поле ""Дата документа"" на закладке ""Перечисление в бюджет"".");
				КонецЕсли;
			КонецЕсли;
		ИначеЕсли Найти("БФ", П106) > 0 Тогда
		Иначе
			СписокОшибок.Добавить("Неверно указано значение в поле ""Основание платежа"" на закладке ""Перечисление в бюджет"".");
		КонецЕсли;
		Если СтрЗаменить(П110,"0","")="" Тогда
		ИначеЕсли Найти("НС, АВ, ПЕ, ПЦ, СА, АШ, ИШ, ПЛ, ГП, ВЗ", П110) > 0 Тогда
		Иначе
			СписокОшибок.Добавить("Неверно указано значение в поле ""Тип платежа"" на закладке ""Перечисление в бюджет"".");
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

Процедура ПроверитьЗаполнениеРеквизитовТаможенныхПлатежей(СписокОшибок, П101, П105, П106, П107, П108, П109, П110)

	Если П101 = "08" Тогда
		СписокОшибок.Добавить("Возможно, неверно указано значение в поле ""Статус составителя"" на закладке ""Перечисление в бюджет""." 
			+ Символы.ПС + Символы.Таб + "Статус ""08"" соответствует виду перечисления ""Иной платеж"".");
	КонецЕсли;
	
	Если ПустаяСтрока(П105) Тогда
		СписокОшибок.Добавить("Возможно, следует указать значение в поле ""Код ОКАТО"" на закладке ""Перечисление в бюджет"".");
	КонецЕсли;
	
	Если (СтрЗаменить(СокрЛП(П106), "0", "") <> "")
		И (Найти("ДЕ, ПО, КВ, КТ, ИД, ИП, ТУ, БД, ИН, КП", П106) = 0) Тогда
		СписокОшибок.Добавить("Неверно указано значение в поле ""Основание платежа"" на закладке ""Перечисление в бюджет""."); 
	КонецЕсли;
		
	Если (СтрЗаменить(П107,"0","") = "") Тогда
		СписокОшибок.Добавить("Не указан ""Код таможенного органа"" на закладке ""Перечисление в бюджет""."); 
	КонецЕсли;
	
	Если (СтрЗаменить(П110,"0","") <> "") 
		И (Найти("ТП, ШТ, ЗД, ПЕ", П110) = 0) Тогда
		СписокОшибок.Добавить("Неверно указано значение в поле ""Тип платежа"" на закладке ""Перечисление в бюджет"".");
	КонецЕсли;
	
КонецПроцедуры

Процедура ПроверитьЗаполнениеРеквизитовИныхПлатежейВБюджет(СписокОшибок, П101, П105, П106, П107, П108, П109, П110)

	Если П101 <> "08" Тогда
		СписокОшибок.Добавить("Возможно, неверно указано значение в поле ""Статус составителя"" на закладке ""Перечисление в бюджет""." 
			+ Символы.ПС + Символы.Таб + "Вид перечисления ""Иной платеж"" соответствует статусу составителя ""08"".");
	КонецЕсли;
		
	Если ПустаяСтрока(П105) Тогда
		СписокОшибок.Добавить("Необходимо заполнить поле ""Код ОКАТО"" на закладке ""Перечисление в бюджет"".");
	КонецЕсли;
	
	Если СтрЗаменить(П106, "0", "") <> "" Тогда 
		СписокОшибок.Добавить("Следует указать ""0"" в поле ""Основание платежа"" на закладке ""Перечисление в бюджет"".");
	КонецЕсли;
	
	Если СтрЗаменить(П107, "0", "") <> "" Тогда
		СписокОшибок.Добавить("Следует указать ""0"" в поле ""Налоговый период"" на закладке ""Перечисление в бюджет"".");
	КонецЕсли;
	
	Если СтрЗаменить(П108, "0", "") <> "" Тогда
		СписокОшибок.Добавить("Следует указать ""0"" в поле ""Номер документа"" на закладке ""Перечисление в бюджет"".");
	КонецЕсли;
	
	Если СтрЗаменить(П109, "0", "") <> "" Тогда
		СписокОшибок.Добавить("Не следует заполнять поле ""Дата документа"" на закладке ""Перечисление в бюджет"".");
	КонецЕсли;
	
	Если СтрЗаменить(П110, "0", "") <> "" Тогда
		СписокОшибок.Добавить("Следует указать ""0"" в поле ""Тип платежа"" на закладке ""Перечисление в бюджет"".");
	КонецЕсли;

КонецПроцедуры

Функция ПроверитьЗаполнениеРеквизитовДляПеречисленияВБюджет(ТекДокумент)
	
	СписокОшибок = Новый СписокЗначений();
	
	П101 = СокрЛП(ТекДокумент.СтатусСоставителя);
	П104 = СокрЛП(ТекДокумент.КодБК);
	П105 = СокрЛП(ТекДокумент.КодОКАТО);
	Если ТекДокумент.ВидПеречисленияВБюджет = Перечисления.ВидыПеречисленийВБюджет.ТаможенныйПлатеж Тогда
		П105 = ?(ПустаяСтрока(П105), "0", П105);
	КонецЕсли;
	П106 = СокрЛП(ТекДокумент.ПоказательОснования);
	П107 = ?(ПустаяСтрока(СокрЛП(СтрЗаменить(ТекДокумент.ПоказательПериода, ".", ""))) = 1, "", ТекДокумент.ПоказательПериода);
	П107 = ?(СокрЛП(СтрЗаменить(ТекДокумент.ПоказательПериода, ".", "")) = "0", "", ТекДокумент.ПоказательПериода);
	П108 = СокрЛП(ТекДокумент.ПоказательНомера);
	П109 = ?(НЕ ЗначениеЗаполнено(ТекДокумент.ПоказательДаты), "0", Строка(ТекДокумент.ПоказательДаты));
	П110 = СокрЛП(ТекДокумент.ПоказательТипа);
	
	// Проверки, обшие для всех видов перечислений в бюджет
	
	Если (Найти("01,02,03,04,05,06,07,08,09,10,11,12,13,14,15,16,17,18,19,20", П101) = 0) 
			ИЛИ ПустаяСтрока(СокрЛП(П101)) Тогда
		СписокОшибок.Добавить("Неверное значение поля ""Статус составителя"" на закладке ""Перечисление в бюджет"".");
	КонецЕсли;
	
	Если (СтрЗаменить(П104, "0", "") = "")
			И (Найти(П101, "07") = 0) Тогда
		СписокОшибок.Добавить("Необходимо заполнить поле ""КБК"" на закладке ""Перечисление в бюджет"".");
	КонецЕсли;
	
	// Проверки, зависящие от вида перечисления в бюджет
	
	Если ТекДокумент.ВидПеречисленияВБюджет = Перечисления.ВидыПеречисленийВБюджет.НалоговыйПлатеж Тогда
		ПроверитьЗаполнениеРеквизитовНалоговыхПлатежей(СписокОшибок, П101, П105, П106, П107, П108, П109, П110);
	ИначеЕсли ТекДокумент.ВидПеречисленияВБюджет = Перечисления.ВидыПеречисленийВБюджет.ТаможенныйПлатеж Тогда
		ПроверитьЗаполнениеРеквизитовТаможенныхПлатежей(СписокОшибок, П101, П105, П106, П107, П108, П109, П110);
	Иначе
		ПроверитьЗаполнениеРеквизитовИныхПлатежейВБюджет(СписокОшибок, П101, П105, П106, П107, П108, П109, П110);
	КонецЕсли;
	
	//Выводим список найденных ошибок
	
	Для Ном = 0 По СписокОшибок.Количество()-1 Цикл
		Сообщить(СписокОшибок.Получить(Ном), СтатусСообщения.Важное);
	КонецЦикла;
	
	Возврат СписокОшибок;
	
КонецФункции

Функция ПечатьПлатежныхПоручений(Заявка) Экспорт
	
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("ЗаявкаНаРасходованиеСредств", Заявка);
	
	Запрос.Текст =
	"ВЫБРАТЬ
	|	РасходИзБанка.Ссылка
	|ИЗ
	|	Документ.РасходИзБанка КАК РасходИзБанка
	|ГДЕ
	|	РасходИзБанка.ЗаявкаНаРасходованиеСредств = &ЗаявкаНаРасходованиеСредств
	|	И РасходИзБанка.Оплачено
	|	И НЕ РасходИзБанка.ПометкаУдаления
	|
	|УПОРЯДОЧИТЬ ПО
	|	РасходИзБанка.МоментВремени";
	
	РезультатЗапроса = Запрос.Выполнить();
	Если РезультатЗапроса.Пустой() Тогда
		Возврат Неопределено;
	КонецЕсли;
	
	
	//
	ТабДокумент = Новый ТабличныйДокумент;
	ТабДокумент.ИмяПараметровПечати = "ПАРАМЕТРЫ_ПЕЧАТИ_ЗаявкаНаРасходованиеСредств_ПлатежноеПоручение";
	
	Макет = Документы.ЗаявкаНаРасходованиеСредств.ПолучитьМакет("ПлатежноеПоручение");
	
	//
	Выборка = РезультатЗапроса.Выбрать();
	Пока Выборка.Следующий() Цикл
		
		ТекДокумент = Выборка.Ссылка;
		
		ТекОрганизация = ТекДокумент.Организация;
		Если ТекОрганизация.Пустая() Тогда
			Сообщить("В документе """ + ТекДокумент + """ не указана организация.", СтатусСообщения.Важное);
			Продолжить;;
		КонецЕсли;

		ТекКонтрагент 	= ТекДокумент.Контрагент;
		ТекВидОперации 	= ТекДокумент.ВидОперации;
		Если ТекКонтрагент.Пустая()
				И НЕ ТекВидОперации = Перечисления.ВидыОперацийППИсходящее.ПереводНаДругойСчет Тогда
			Сообщить("В документе """ + ТекДокумент + """ не указан контрагент.", СтатусСообщения.Важное);
			Продолжить;;
		КонецЕсли;
	
		НомерПечать = ОбщегоНазначения.ПолучитьНомерНаПечать(ТекДокумент);
	
		Если Прав(НомерПечать, 3) = "000" Тогда
			Сообщить("Документ """ + ТекДокумент + """: номер платежного поручения не может оканчиваться на ""000""!", СтатусСообщения.Важное);
			Продолжить;;
		КонецЕсли;
	
		ОбластьМакета = Макет.ПолучитьОбласть("ЗаголовокТаблицы");

		ТекСчетОрганизации = ТекДокумент.СчетОрганизации;
		МесяцПрописью   = ТекСчетОрганизации.МесяцПрописью;
		СуммаБезКопеек  = ТекСчетОрганизации.СуммаБезКопеек;
		ФорматДаты      = "ДФ=" + ?(МесяцПрописью = 1, "'дд ММММ гггг'", "'дд.ММ.гггг'");
		
		БанкОрганизации = ?(НЕ ЗначениеЗаполнено(ТекСчетОрганизации.БанкДляРасчетов), ТекСчетОрганизации.Банк, ТекСчетОрганизации.БанкДляРасчетов);
		ТекСчетКонтрагента = ТекДокумент.СчетКонтрагента;
		БанкКонтрагента = ?(НЕ ЗначениеЗаполнено(ТекСчетКонтрагента.БанкДляРасчетов), ТекСчетКонтрагента.Банк, ТекСчетКонтрагента.БанкДляРасчетов);

		ОбластьМакета.Параметры.НаименованиеНомер	= "ПЛАТЕЖНОЕ ПОРУЧЕНИЕ № " + НомерПечать;
		ОбластьМакета.Параметры.ДатаДокумента       = Формат(ТекДокумент.Дата		, ФорматДаты);
		ОбластьМакета.Параметры.ДатаОплаты       	= Формат(ТекДокумент.ДатаОплаты	, ФорматДаты);
		ОбластьМакета.Параметры.ВидПлатежа          = ТекДокумент.ВидПлатежа;
		ОбластьМакета.Параметры.СуммаЧислом         = ФорматироватьСумму(ТекДокумент.СуммаДокумента, СуммаБезКопеек);
		ОбластьМакета.Параметры.СуммаПрописью       = ФорматироватьСуммуПрописи(ТекДокумент.СуммаДокумента, СуммаБезКопеек, ТекСчетОрганизации.ВалютаДенежныхСредств.ПараметрыПрописиНаРусском);

		ОбластьМакета.Параметры.ПлательщикИНН       = "ИНН " + ?(ПустаяСтрока(ТекДокумент.ИННПлательщика), ТекОрганизация.ИНН, СокрЛП(ТекДокумент.ИННПлательщика));
		ОбластьМакета.Параметры.ПлательщикКПП       = "КПП " + ?(ПустаяСтрока(ТекДокумент.КППплательщика),
							?(ТекВидОперации = Перечисления.ВидыОперацийППИсходящее.ПеречислениеНалога, "0", ""), СокрЛП(ТекДокумент.КППплательщика));	
		
		Если ТекСчетОрганизации.БанкДляРасчетов.Пустая() Тогда
			СтрКорреспондент = "";
		Иначе	
			СтрКорреспондент = " р/с " + ТекСчетОрганизации.НомерСчета + " в " + ТекСчетОрганизации.Банк + " " + ТекСчетОрганизации.Банк.Город;	
		КонецЕсли;
		
		Если ТекВидОперации = Перечисления.ВидыОперацийППИсходящее.ПеречислениеНалога Тогда
			ТекстПлательщикПечать = ?(ПустаяСтрока(ТекОрганизация.НаименованиеПлательщикаПриПеречисленииНалогов),
										?(ПустаяСтрока(ТекДокумент.ТекстПлательщика), ТекОрганизация.НаименованиеПолное, СокрЛП(ТекДокумент.ТекстПлательщика)),
										ТекОрганизация.НаименованиеПлательщикаПриПеречисленииНалогов + СтрКорреспондент);
		Иначе
	        ТекстПлательщикПечать = ?(ПустаяСтрока(ТекДокумент.ТекстПлательщика), ТекОрганизация.НаименованиеПолное, СокрЛП(ТекДокумент.ТекстПлательщика));
			
		КонецЕсли;
		
		ОбластьМакета.Параметры.Плательщик              = ТекстПлательщикПечать;
		ОбластьМакета.Параметры.БанкПлательщика         = "" + БанкОрганизации + " " + БанкОрганизации.Город;

		ОбластьМакета.Параметры.НомерСчетаПлательщика   = ВернутьРасчетныйСчет(ТекСчетОрганизации);

		ОбластьМакета.Параметры.БикБанкаПлательщика     = БанкОрганизации.Код;
		ОбластьМакета.Параметры.СчетБанкаПлательщика    = БанкОрганизации.КоррСчет;
		
		Если НЕ ТекВидОперации = Перечисления.ВидыОперацийППИсходящее.ПереводНаДругойСчет Тогда
			ОбластьМакета.Параметры.ПолучательИНН		= "ИНН " + ?(ПустаяСтрока(ТекДокумент.ИННПолучателя), ТекКонтрагент.ИНН	, СокрЛП(ТекДокумент.ИННПолучателя));
			ОбластьМакета.Параметры.ПолучательКПП		= "КПП " + ?(ПустаяСтрока(ТекДокумент.КПППолучателя), ""				, СокрЛП(ТекДокумент.КПППолучателя));
			ОбластьМакета.Параметры.Получатель			= ?(ПустаяСтрока(ТекДокумент.ТекстПолучателя), ТекКонтрагент.НаименованиеПолное, СокрЛП(ТекДокумент.ТекстПолучателя));
		Иначе
			ОбластьМакета.Параметры.ПолучательИНН		= "ИНН " + ?(ПустаяСтрока(ТекДокумент.ИННПолучателя), ТекОрганизация.ИНН, СокрЛП(ТекДокумент.ИННПолучателя));
			ОбластьМакета.Параметры.ПолучательКПП		= "КПП " + ?(ПустаяСтрока(ТекДокумент.КПППолучателя), ""				, СокрЛП(ТекДокумент.КПППолучателя));
			ОбластьМакета.Параметры.Получатель			= ?(ПустаяСтрока(ТекДокумент.ТекстПолучателя), ТекОрганизация.НаименованиеПолное, СокрЛП(ТекДокумент.ТекстПолучателя));
		КонецЕсли;
			
		ОбластьМакета.Параметры.БанкПолучателя          = "" + БанкКонтрагента + " " + БанкКонтрагента.Город;
		ОбластьМакета.Параметры.БикБанкаПолучателя      = БанкКонтрагента.Код;
		ОбластьМакета.Параметры.СчетБанкаПолучателя     = БанкКонтрагента.КоррСчет;

		ОбластьМакета.Параметры.НомерСчетаПолучателя    = ВернутьРасчетныйСчет(ТекСчетКонтрагента);

		ОбластьМакета.Параметры.НазначениеПлатежа       = СокрЛП(ТекДокумент.НазначениеПлатежа);
		ОбластьМакета.Параметры.Очередность             = ТекДокумент.ОчередностьПлатежа;
		ОбластьМакета.Параметры.СрокПлатежа             = "";

		// Реквизиты для перечисления в бюджет
		Если ТекДокумент.ПеречислениеВБюджет Тогда
			
			ПроверитьЗаполнениеРеквизитовДляПеречисленияВБюджет(ТекДокумент);
			
			ОбластьМакета.Параметры.СтатусСоставителя   = ?(ПустаяСтрока(ТекДокумент.СтатусСоставителя)	, "0"	, СокрЛП(ТекДокумент.СтатусСоставителя));
			ОбластьМакета.Параметры.КодБК               = ?(ПустаяСтрока(ТекДокумент.КодБК)				, ""	, СокрЛП(ТекДокумент.КодБК));
			ОбластьМакета.Параметры.КодОКАТО            = ?(ПустаяСтрока(ТекДокумент.КодОКАТО),
				?(ТекДокумент.ВидПеречисленияВБюджет = Перечисления.ВидыПеречисленийВБюджет.ТаможенныйПлатеж, "0", ""),
				СокрЛП(ТекДокумент.КодОКАТО));
			ОбластьМакета.Параметры.ПоказательОснования = ?(ПустаяСтрока(ТекДокумент.ПоказательОснования)	, "0", СокрЛП(ТекДокумент.ПоказательОснования));
			ОбластьМакета.Параметры.ПоказательНомера    = ?(ПустаяСтрока(ТекДокумент.ПоказательНомера)		, "0", СокрЛП(ТекДокумент.ПоказательНомера));
			ОбластьМакета.Параметры.ПоказательДаты      = ?(ТекДокумент.ПоказательДаты = '00010101000000'	, "0", Формат(ТекДокумент.ПоказательДаты, "ДФ='дд.ММ.гггг'"));
			ОбластьМакета.Параметры.ПоказательТипа      = ?(ПустаяСтрока(ТекДокумент.ПоказательТипа)		, "0", СокрЛП(ТекДокумент.ПоказательТипа));
			Если НЕ ТекДокумент.ВидПеречисленияВБюджет = Перечисления.ВидыПеречисленийВБюджет.ТаможенныйПлатеж
					И (ПустаяСтрока(ТекДокумент.ПоказательПериода)
						ИЛИ (ТекДокумент.ПоказательПериода = "  .  .    ")) Тогда
				ОбластьМакета.Параметры.ПоказательПериода = "0";
			Иначе
				ОбластьМакета.Параметры.ПоказательПериода = СокрЛП(ТекДокумент.ПоказательПериода);
			КонецЕсли;
			
		КонецЕсли;

		ОбластьМакета.Параметры.ПодписьБанкПлательщика 	= "" + БанкОрганизации;
		ОбластьМакета.Параметры.ПодписьГородПлательщика = "" + БанкОрганизации.Город;
		ДатаПрописью = Формат(ТекДокумент.Дата, "ДФ='дд ММММ гггг'");                                                        
		ОбластьМакета.Параметры.ПодписьДатаОплаты 		= Лев(ДатаПрописью, 2) + " " + ВРег(Сред(ДатаПрописью, 4, 3)) + " " + Прав(ДатаПрописью, 4);
		ОбластьМакета.Параметры.ПодписьКорСчет     		= "к/с " + БанкОрганизации.КоррСчет + " БИК " + БанкОрганизации.Код;
		
		
		ТабДокумент.Вывести(ОбластьМакета);
		ТабДокумент.ВывестиГоризонтальныйРазделительСтраниц();
		
	КонецЦикла;
	
	Возврат ТабДокумент;
	
КонецФункции
