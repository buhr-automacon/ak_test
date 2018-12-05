﻿
&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	ДатаФормирования = ТекущаяДата();
	
	ИнвДляОтбора = Этаформа.Параметры.ИнвДляОтбора; 
	
	Если ЗначениеЗаполнено(ИнвДляОтбора) Тогда	
		ОбновитьДанные(ИнвДляОтбора);
	Иначе
		ОбновитьДанные();
	КонецЕсли;
	
КонецПроцедуры

Процедура ОбновитьДанные(ИнвДляОтбора = Неопределено)
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ
		|	АК_ОсновныеСредстваКСписаниюОприходованиюОстатки.ОсновноеСредство,
		|	АК_ОсновныеСредстваКСписаниюОприходованиюОстатки.КоличествоОстаток КАК Количество
		|ПОМЕСТИТЬ втОС
		|ИЗ
		|	РегистрНакопления.АК_ОсновныеСредстваКСписаниюОприходованию.Остатки(&ДатаСреза, ) КАК АК_ОсновныеСредстваКСписаниюОприходованиюОстатки
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	АК_ОсновныеСредстваКСписаниюОприходованиюОбороты.ОсновноеСредство,
		|	ВЫБОР
		|		КОГДА СУММА(АК_ОсновныеСредстваКСписаниюОприходованиюОбороты.КоличествоОборот) > 0
		|			ТОГДА 1
		|		ИНАЧЕ 0
		|	КОНЕЦ КАК КОприходованию,
		|	ВЫБОР
		|		КОГДА СУММА(АК_ОсновныеСредстваКСписаниюОприходованиюОбороты.КоличествоОборот) < 0
		|			ТОГДА 1
		|		ИНАЧЕ 0
		|	КОНЕЦ КАК КСписанию,
		|	МАКСИМУМ(АК_ОсновныеСредстваКСписаниюОприходованиюОбороты.Регистратор) КАК Документ,
		|	ПринятыеКУчетуОССрезПоследних.Организация,
		|	СостояниеОССрезПоследних.Местоположение,
		|	ИСТИНА КАК Флаг,
		|	АК_ОсновныеСредстваКСписаниюОприходованиюОбороты.ОсновноеСредство.ИнвентарныйНомер КАК ИнвентарныйНомер,
		|	АК_ОсновныеСредстваКСписаниюОприходованиюОбороты.ОсновноеСредство.ЗаводскойНомер КАК ЗаводскойНомер
		|ПОМЕСТИТЬ СводнаяТаблицаБезСтоимости
		|ИЗ
		|	РегистрНакопления.АК_ОсновныеСредстваКСписаниюОприходованию.Обороты(
		|			,
		|			&ДатаСреза,
		|			Авто,
		|			ОсновноеСредство В
		|				(ВЫБРАТЬ
		|					втОС.ОсновноеСредство
		|				ИЗ
		|					втОС)) КАК АК_ОсновныеСредстваКСписаниюОприходованиюОбороты
		|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.СостояниеОС.СрезПоследних(
		|				&ДатаСреза,
		|				ОсновноеСредство В
		|					(ВЫБРАТЬ
		|						втОС.ОсновноеСредство
		|					ИЗ
		|						втОС)) КАК СостояниеОССрезПоследних
		|		ПО АК_ОсновныеСредстваКСписаниюОприходованиюОбороты.ОсновноеСредство = СостояниеОССрезПоследних.ОсновноеСредство
		|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.ПринятыеКУчетуОС.СрезПоследних(
		|				&ДатаСреза,
		|				ОсновноеСредство В
		|					(ВЫБРАТЬ
		|						втОС.ОсновноеСредство
		|					ИЗ
		|						втОС)) КАК ПринятыеКУчетуОССрезПоследних
		|		ПО АК_ОсновныеСредстваКСписаниюОприходованиюОбороты.ОсновноеСредство = ПринятыеКУчетуОССрезПоследних.ОсновноеСредство
		|
		|СГРУППИРОВАТЬ ПО
		|	АК_ОсновныеСредстваКСписаниюОприходованиюОбороты.ОсновноеСредство,
		|	ПринятыеКУчетуОССрезПоследних.Организация,
		|	СостояниеОССрезПоследних.Местоположение,
		|	АК_ОсновныеСредстваКСписаниюОприходованиюОбороты.ОсновноеСредство.ИнвентарныйНомер,
		|	АК_ОсновныеСредстваКСписаниюОприходованиюОбороты.ОсновноеСредство.ЗаводскойНомер
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	СводнаяТаблицаБезСтоимости.ОсновноеСредство,
		|	СводнаяТаблицаБезСтоимости.КОприходованию,
		|	СводнаяТаблицаБезСтоимости.КСписанию,
		|	СводнаяТаблицаБезСтоимости.Документ,
		|	СводнаяТаблицаБезСтоимости.Организация,
		|	СводнаяТаблицаБезСтоимости.Местоположение,
		|	СводнаяТаблицаБезСтоимости.Флаг,
		|	СводнаяТаблицаБезСтоимости.ИнвентарныйНомер,
		|	СводнаяТаблицаБезСтоимости.ЗаводскойНомер,
		|	ЕСТЬNULL(ФинансовыйОстатки.СуммаОстаток, 0) КАК ПервоначальнаяСтоимость,
		|	ЕСТЬNULL(ФинансовыйОстаткиАмортизация.СуммаОстаток, 0) КАК СуммаАмортизации
		|ИЗ
		|	СводнаяТаблицаБезСтоимости КАК СводнаяТаблицаБезСтоимости
		|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрБухгалтерии.Финансовый.Остатки(
		|				&ДатаСреза,
		|				Счет В (&СчетаУчетаОСМСФО),
		|				,
		|				Субконто1 В
		|					(ВЫБРАТЬ
		|						ВтОС.ОсновноеСредство
		|					ИЗ
		|						ВтОС)) КАК ФинансовыйОстатки
		|		ПО СводнаяТаблицаБезСтоимости.ОсновноеСредство = ФинансовыйОстатки.Субконто1
		|			И СводнаяТаблицаБезСтоимости.Организация = ФинансовыйОстатки.Организация
		|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрБухгалтерии.Финансовый.Остатки(
		|				&ДатаСреза,
		|				Счет В (&СчетаУчетаОСАмортизация),
		|				,
		|				Субконто1 В
		|					(ВЫБРАТЬ
		|						ВтОС.ОсновноеСредство
		|					ИЗ
		|						ВтОС)) КАК ФинансовыйОстаткиАмортизация
		|		ПО СводнаяТаблицаБезСтоимости.ОсновноеСредство = ФинансовыйОстаткиАмортизация.Субконто1
		|			И СводнаяТаблицаБезСтоимости.Организация = ФинансовыйОстаткиАмортизация.Организация
		|ГДЕ СводнаяТаблицаБезСтоимости.ОсновноеСредство В(&СписокОС)";
	
	Если ИнвДляОтбора <> Неопределено Тогда
		
		МассОС = Новый Массив;
		
		//НайдСтроки = ИнвДляОтбора.ОС.НайтиСтроки(Новый Структура("Количество", 0));
		
		Для Каждого Стр Из ИнвДляОтбора.ОС Цикл
			Если Стр.Количество <> Стр.КоличествоУчет Тогда
				МассОс.Добавить(Стр.ОсновноеСредство);
			КонецЕсли;
		КонецЦикла;
		
		//Для Каждого НСтр Из НайдСтроки Цикл
		//	МассОс.Добавить(НСтр.ОсновноеСредство);
		//КонецЦикла;
		
		Запрос.УстановитьПараметр("СписокОС", МассОС);
		
	Иначе
		
		Запрос.Текст = СтрЗаменить(Запрос.Текст, "ГДЕ СводнаяТаблицаБезСтоимости.ОсновноеСредство В(&СписокОС)", "");
		
	КонецЕсли;
	
	
	ПараметрыГраницы = Новый Массив(2);
	ПараметрыГраницы[0] = КонецДня(ДатаФормирования);
	ПараметрыГраницы[1] = ВидГраницы.Включая;
	ДатаСреза = Новый(Тип("Граница"),ПараметрыГраницы);
		
	Запрос.УстановитьПараметр("ДатаСреза",ДатаСреза);
	Запрос.УстановитьПараметр("СчетаУчетаОСМСФО", АК_УчетМСФО.СчетаУчетаОС());
	
	СчетаАмортизацииОС = Новый Массив;
	СчетаАмортизацииОС.Добавить(ПланыСчетов.Финансовый.АмортизацияОсновныхСредств);
	СчетаАмортизацииОС.Добавить(ПланыСчетов.Финансовый.АмортизацияОсновныхСредствДо100000);	
	Запрос.УстановитьПараметр("СчетаУчетаОСАмортизация",СчетаАмортизацииОС);
	
	Результат = Запрос.Выполнить().Выгрузить();

	ОсновныеСредстваКОприходованиюСписанию.Загрузить(Результат);
	
	ВсегоКОприходованию = Результат.Итог("КОприходованию");
	ВсегоКСписанию =      Результат.Итог("КСписанию");
	
КонецПроцедуры	

&НаКлиенте
Процедура ДатаНачалаПриИзменении(Элемент)
	
	ОбновитьДанные();
	
КонецПроцедуры

&НаКлиенте
Процедура СформироватьСкладскиеАкты(Команда)
	
	СообщениеОбОшибке = "";
	
	Для Каждого Стр Из ОсновныеСредстваКОприходованиюСписанию Цикл
		Если Стр.Флаг И НЕ ЗначениеЗаполнено(Стр.ПервоначальнаяСтоимость) Тогда
			СообщениеОбОшибке = СообщениеОбОшибке + "У основного средства: " + Строка(Стр.ОсновноеСредство) + " (" + СокрЛП(Стр.ИнвентарныйНомер) + ") не заполнена первоначальная стоимость" + Символы.ПС;
		КонецЕсли;
	КонецЦикла;
	
	Если ЗначениеЗаполнено(СообщениеОбОшибке) Тогда
		Ответ = Вопрос(СообщениеОбОшибке + "Продолжить?", РежимДиалогаВопрос.ДаНет);
		
		Если Ответ=КодВозвратаДиалога.Нет Тогда
			ВозвраТ;
		КонецЕсли;
	КонецЕсли;
	
	Если ЗначениеЗаполнено(ИнвДляОтбора) Тогда
		ФормированиеАктов(ПолучитьДатуФормирования());
	Иначе
		ФормированиеАктов(Неопределено);
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Функция ПолучитьДатуФормирования()
	
	Возврат ИнвДляОтбора.Дата;
	
КонецФункции

Процедура ФормированиеАктов(ДатаДок = Неопределено)
	
	Отбор = Новый Структура("Флаг",Истина);
	КФормированию = ОсновныеСредстваКОприходованиюСписанию.Выгрузить(Отбор);
	
	Разделение = КФормированию.Скопировать(,"Документ,Организация");
	Разделение.Свернуть("Документ,Организация");
	
	Для каждого Строка из Разделение Цикл
		
		ОтборСтрок = Новый Структура;
		ОтборСтрок.Вставить("Документ",Строка.Документ);
		ОтборСтрок.Вставить("Организация",Строка.Организация);
		ОтборСтрок.Вставить("КСписанию",0);
		
		КОприходованию = КФормированию.Скопировать(ОтборСтрок); 		
		СформироватьОприходование(Строка,КОприходованию, ДатаДок);
		
		ОтборСтрок = Новый Структура;
		ОтборСтрок.Вставить("Документ",Строка.Документ);
		ОтборСтрок.Вставить("Организация",Строка.Организация);
		ОтборСтрок.Вставить("КОприходованию",0);

		КСписанию = КФормированию.Скопировать(ОтборСтрок);
        СформироватьСписание(Строка,КСписанию, ДатаДок);
		
	КонецЦикла;	
	
КонецПроцедуры	

Процедура СформироватьОприходование(Реквизиты,Таблица, ДатаДок)

	Если Таблица.Количество() = 0 Тогда
		Возврат;
	КонецЕсли;	
	
    ДокументОприходование = Документы.ОприходованиеОС.СоздатьДокумент();
	ДокументОприходование.ДокИнвентаризации = Реквизиты.Документ;
	ДокументОприходование.Организация = Реквизиты.Организация; 
	
	Если ДатаДок = Неопределено Тогда
		ДокументОприходование.Дата = КонецДня(ДатаФормирования);	
	Иначе
		ДокументОприходование.Дата = ДатаДок;	
	КонецЕсли;
	
	ДокументОприходование.Номенклатура.Очистить();
		
	Для каждого Строка из Таблица Цикл
		
		НоваяСтрока = ДокументОприходование.Номенклатура.Добавить();
		НоваяСтрока.Местоположение = Строка.Местоположение;
		НоваяСтрока.СчетУчетаЗабалансовый = ПланыСчетов.Финансовый.ОсновныеСредстваВОрганизации;
		НоваяСтрока.ОсновноеСредство = Строка.ОсновноеСредство;
		НоваяСтрока.СрокПолезногоИспользования = 61;
		НоваяСтрока.АК_ДатаВводаВЭксплуатацию = ДатаФормирования;
		НоваяСтрока.Сумма = Строка.ПервоначальнаяСтоимость;
		НоваяСтрока.АК_СуммаАмортизации = Строка.СуммаАмортизации;
		
	КонецЦикла;	
	
	ДокументОприходование.Ответственный = ПараметрыСеанса.ТекущийПользователь;
	
	ДокПроведен = Истина;
	ДокЗаписан = Истина;
	
	Попытка
		ДокументОприходование.Записать(РежимЗаписиДокумента.Проведение);
	Исключение
		ДокПроведен = Ложь;
		
		Попытка
			ДокументОприходование.Записать(РежимЗаписиДокумента.Запись);
		Исключение
			ДокЗаписан = Ложь;
		КонецПопытки;
	КонецПопытки;
	
	Если ДокЗаписан Тогда
		ОбщегоНазначения.СообщитьОбОшибке("Создан " + ?(ДокПроведен, "и проведен", "и записан (НЕОБХОДИМО ПРОВЕСТИ ВРУЧНУЮ!!!)") + " документ: " + Строка(ДокументОприходование.Ссылка), , , СтатусСообщения.Информация);
	Иначе
		ОбщегоНазначения.СообщитьОбОшибке("Не удалось создать документ оприходования ОС по причине: " + ОписаниеОшибки());
	КонецЕсли;
	
КонецПроцедуры	

Процедура СформироватьСписание(Реквизиты,Таблица, ДатаДок)
 
	Если Таблица.Количество() = 0 Тогда
		Возврат;
	КонецЕсли;	

	//Запрос = Новый Запрос;
	//Запрос.Текст = 
	//	"ВЫБРАТЬ
	//	|	ОсновныеСредства.ОсновноеСредство,
	//	|	ОсновныеСредства.Местоположение
	//	|ПОМЕСТИТЬ втОС
	//	|ИЗ
	//	|	&ОсновныеСредства КАК ОсновныеСредства
	//	|;
	//	|
	//	|////////////////////////////////////////////////////////////////////////////////
	//	|ВЫБРАТЬ
	//	|	ФинансовыйОстатки.Субконто1,
	//	|	ФинансовыйОстатки.СуммаОстаток,
	//	|	ФинансовыйОстатки.Счет
	//	|ПОМЕСТИТЬ втСтоимость
	//	|ИЗ
	//	|	РегистрБухгалтерии.Финансовый.Остатки(
	//	|			&ДатаФормирования,
	//	|			Счет В (&СчетаУчетаОС),
	//	|			,
	//	|			Субконто1 В
	//	|				(ВЫБРАТЬ
	//	|					втОС.ОсновноеСредство
	//	|				ИЗ
	//	|					втОС)) КАК ФинансовыйОстатки
	//	|;
	//	|
	//	|////////////////////////////////////////////////////////////////////////////////
	//	|ВЫБРАТЬ
	//	|	ФинансовыйОстатки.Субконто1,
	//	|	ФинансовыйОстатки.СуммаОстаток,
	//	|	ФинансовыйОстатки.Счет
	//	|ПОМЕСТИТЬ втАмортизация
	//	|ИЗ
	//	|	РегистрБухгалтерии.Финансовый.Остатки(
	//	|			&ДатаФормирования,
	//	|			Счет В (&СчетаАмортизацииОС),
	//	|			,
	//	|			Субконто1 В
	//	|				(ВЫБРАТЬ
	//	|					втОС.ОсновноеСредство
	//	|				ИЗ
	//	|					втОС)) КАК ФинансовыйОстатки
	//	|;
	//	|
	//	|////////////////////////////////////////////////////////////////////////////////
	//	|ВЫБРАТЬ
	//	|	втОС.ОсновноеСредство,
	//	|	втОС.Местоположение,
	//	|	втСтоимость.СуммаОстаток КАК Сумма,
	//	|	втАмортизация.СуммаОстаток КАК АК_СуммаАмортизации,
	//	|	втСтоимость.Счет КАК СчетУчетаЗабалансовый
	//	|ИЗ
	//	|	втОС КАК втОС
	//	|		ЛЕВОЕ СОЕДИНЕНИЕ втСтоимость КАК втСтоимость
	//	|		ПО втОС.ОсновноеСредство = втСтоимость.Субконто1
	//	|		ЛЕВОЕ СОЕДИНЕНИЕ втАмортизация КАК втАмортизация
	//	|		ПО втОС.ОсновноеСредство = втАмортизация.Субконто1";


	//СчетаУчетаОС = Новый Массив;
	//СчетаУчетаОС.Добавить(ПланыСчетов.Финансовый.ОсновныеСредстваВОрганизации);
	//СчетаУчетаОС.Добавить(ПланыСчетов.Финансовый.ОсновныеСредстваДо100000);	
	//Запрос.УстановитьПараметр("СчетаУчетаОС",СчетаУчетаОС);
	//СчетаАмортизацииОС = Новый Массив;
	//СчетаАмортизацииОС.Добавить(ПланыСчетов.Финансовый.АмортизацияОсновныхСредств);
	//СчетаАмортизацииОС.Добавить(ПланыСчетов.Финансовый.АмортизацияОсновныхСредствДо100000);	
	//Запрос.УстановитьПараметр("СчетаАмортизацииОС",СчетаАмортизацииОС);
	//Запрос.УстановитьПараметр("ДатаФормирования",ДатаФормирования);	
	//
	//Запрос.УстановитьПараметр("ОсновныеСредства",Таблица);
	//
	//Результат = Запрос.Выполнить().Выгрузить();

    ДокументСписание = Документы.СписаниеОС.СоздатьДокумент();
	
	Если ДатаДок = Неопределено Тогда
		ДокументСписание.Дата = КонецДня(ДатаФормирования);	
	Иначе
		ДокументСписание.Дата = ДатаДок;
	КонецЕсли;
	
	ДокументСписание.ДокИнвентаризации = Реквизиты.Документ;
	ДокументСписание.Организация = Реквизиты.Организация; 
	
	Для каждого Строка из Таблица Цикл
		
		НоваяСтрока = ДокументСписание.Номенклатура.Добавить();
		НоваяСтрока.Местоположение = Строка.Местоположение;
		НоваяСтрока.СчетУчетаЗабалансовый = ПланыСчетов.Финансовый.ОсновныеСредстваВОрганизации;
		НоваяСтрока.ОсновноеСредство = Строка.ОсновноеСредство;				
		НоваяСтрока.Сумма = Строка.ПервоначальнаяСтоимость;
		НоваяСтрока.СуммаАмортизация = Строка.СуммаАмортизации;
		
	КонецЦикла;		
	
	ДокументСписание.Ответственный = ПараметрыСеанса.ТекущийПользователь;
	
	ДокПроведен = Истина;
	ДокЗаписан = Истина;
	
	Попытка
		ДокументСписание.Записать(РежимЗаписиДокумента.Проведение);
	Исключение
		ДокПроведен = Ложь;
		
		Попытка
			ДокументСписание.Записать(РежимЗаписиДокумента.Запись);
		Исключение
			ДокЗаписан = Ложь;
		КонецПопытки;
	КонецПопытки;
	
	Если ДокЗаписан Тогда
		ОбщегоНазначения.СообщитьОбОшибке("Создан " + ?(ДокПроведен, "и проведен", "и записан (НЕОБХОДИМО ПРОВЕСТИ ВРУЧНУЮ!!!)") + " документ: " + Строка(ДокументСписание.Ссылка), , , СтатусСообщения.Информация);
	Иначе
		ОбщегоНазначения.СообщитьОбОшибке("Не удалось создать документ списания ОС по причине: " + ОписаниеОшибки());
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ОткрытьДокументыПоОС(Команда)
	
	ТекущаяСтрока = Элементы.ОсновныеСредстваКОприходованиюСписанию.ТекущиеДанные;
	Если ТекущаяСтрока <> Неопределено Тогда
		Если ЗначениеЗаполнено(ТекущаяСтрока.ОсновноеСредство) Тогда
			ПараметрыФормы = Новый Структура("ОсновноеСредство",ТекущаяСтрока.ОсновноеСредство);
			ОткрытьФорму("Справочник.ОсновныеСредства.Форма.ДокументыПоОС", ПараметрыФормы);
		КонецЕсли;
	КонецЕсли;	

КонецПроцедуры

&НаКлиенте
Процедура ОсновныеСредстваКОприходованиюСписаниюДокументОснованиеОбработкаВыбора(Элемент, ВыбранноеЗначение, СтандартнаяОбработка)
	
	ОткрытьЗначение(ВыбранноеЗначение);
	
КонецПроцедуры
