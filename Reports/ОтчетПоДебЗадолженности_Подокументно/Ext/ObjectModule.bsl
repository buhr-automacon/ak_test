﻿
&НаСервере
Процедура УстановитьПараметрКомпоновки(Настройки,ИмяПараметра, Значение) Экспорт
	
	мПараметр = Настройки.ПараметрыДанных.Элементы.Найти(Новый ПараметрКомпоновкиДанных(ИмяПараметра));
    мПараметр.Значение      = Значение;
    мПараметр.Использование = Истина;
	
	//мПараметр = роек.ФиксированныеНастройки.ПараметрыДанных.Элементы.Найти(Новый ПараметрКомпоновкиДанных(ИмяПараметра));
	//мПараметр.Значение      = Значение;
	//мПараметр.Использование = Истина;
    
КонецПроцедуры

Процедура ПриКомпоновкеРезультата(ДокументРезультат, ДанныеРасшифровки, СтандартнаяОбработка)
	СтандартнаяОбработка = Истина;
	Возврат;
	
	УстановитьПривилегированныйРежим(Истина);
	
	Настройки = КомпоновщикНастроек.ПолучитьНастройки(); 
	КомпоновщикНастроек.Восстановить();
    
	//УстановитьПараметрКомпоновки(Настройки,"КонтрагентыИскл"	, Справочники.Контрагенты.НайтиПоКоду("000000518")); // Организации	
	//УстановитьПараметрКомпоновки(Настройки,"ИнициаторКлимчук"	, Справочники.ФизическиеЛица.НайтиПоНаименованию("Климчук Анатолий Алексеевич"));	
	
	КомпоновщикМакета = Новый КомпоновщикМакетаКомпоновкиДанных;
	
	ТекстЗапросаИсходный = СхемаКомпоновкиДанных.НаборыДанных.НаборДанных1.Запрос;
	
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("КонтрагентыИскл"	, Справочники.Контрагенты.НайтиПоКоду("000000518")); // Организации	
	Запрос.УстановитьПараметр("ИнициаторКлимчук"	, Справочники.ФизическиеЛица.НайтиПоНаименованию("Климчук Анатолий Алексеевич"));	
	ПараметрПериода = Настройки.ПараметрыДанных.Элементы.Найти("КонецПериода");
	Если ПараметрПериода<>Неопределено Тогда
		Запрос.УстановитьПараметр("КонецПериода",Дата(ПараметрПериода.Значение));
		Запрос.УстановитьПараметр("НачалоПредМес",НачалоМесяца(НачалоМесяца(ПараметрПериода.Значение)-1));
	КонецЕсли;
	Запрос.УстановитьПараметр("НачПериодаОбороты",Дата(Год(ТекущаяДата())-1,1,1));
	Запрос.УстановитьПараметр("ТекущаяДата",ТекущаяДата());
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	Финансовый.Ссылка КАК Счет
	|ПОМЕСТИТЬ ВТ_Счета
	|ИЗ
	|	ПланСчетов.Финансовый КАК Финансовый
	|ГДЕ
	|	Финансовый.Ссылка В ИЕРАРХИИ (ЗНАЧЕНИЕ(ПланСчетов.Финансовый.РасчетыСПоставщикамиИПодрядчиками), ЗНАЧЕНИЕ(ПланСчетов.Финансовый.РасчетыСПокупателями), ЗНАЧЕНИЕ(ПланСчетов.Финансовый.РасчетыСПрочимиДебиторамиИКредиторами))
	|
	|ИНДЕКСИРОВАТЬ ПО
	|	Счет
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ВЫРАЗИТЬ(ФинансовыйОстатки.Субконто2 КАК Справочник.Контрагенты) КАК Контрагент,
	|	ФинансовыйОстатки.Счет КАК Счет,
	|	СУММА(ФинансовыйОстатки.СуммаОстатокДт) КАК СуммаОстатокДт,
	|	ФинансовыйОстатки.Субконто1 КАК Организация
	|ПОМЕСТИТЬ ВТ_Остатки
	|ИЗ
	|	РегистрБухгалтерии.Финансовый.Остатки(
	|			&конецПериода,
	|			Счет В
	|				(ВЫБРАТЬ
	|					Таб.Счет
	|				ИЗ
	|					ВТ_Счета КАК Таб),
	|			,
	|			НЕ Субконто2.Родитель = &КонтрагентыИскл) КАК ФинансовыйОстатки
	|ГДЕ
	|	ФинансовыйОстатки.СуммаОстатокДт <> 0
	|
	|СГРУППИРОВАТЬ ПО
	|	ФинансовыйОстатки.Счет,
	|	ФинансовыйОстатки.Субконто1,
	|	ВЫРАЗИТЬ(ФинансовыйОстатки.Субконто2 КАК Справочник.Контрагенты)
	|
	|ИНДЕКСИРОВАТЬ ПО
	|	Организация,
	|	Контрагент,
	|	Счет
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ФинансовыйОбороты.Период,
	|	ФинансовыйОбороты.Счет КАК Счет,
	|	ФинансовыйОбороты.Регистратор,
	|	ВЫРАЗИТЬ(ФинансовыйОбороты.Субконто2 КАК Справочник.Контрагенты) КАК Контрагент,
	|	ФинансовыйОбороты.СуммаОборотДт,
	|	ВЫРАЗИТЬ(ФинансовыйОбороты.Субконто1 КАК Справочник.Организации) КАК Организация
	|ПОМЕСТИТЬ ВТ_Регистраторы_Предв
	|ИЗ
	|	РегистрБухгалтерии.Финансовый.Обороты(
	|			&НачПериодаОбороты,
	|			ДОБАВИТЬКДАТЕ(&конецПериода, СЕКУНДА, -1),
	|			Регистратор,
	|			Счет В
	|				(ВЫБРАТЬ
	|					Таб.Счет
	|				ИЗ
	|					ВТ_Счета КАК Таб),
	|			,
	|			НЕ ВЫРАЗИТЬ(Субконто2 КАК Справочник.Контрагенты).Родитель = &КонтрагентыИскл
	|				И (Субконто1, Субконто2) В
	|					(ВЫБРАТЬ
	|						Т.Организация,
	|						Т.Контрагент
	|					ИЗ
	|						ВТ_Остатки КАК Т),
	|			,
	|			) КАК ФинансовыйОбороты
	|ГДЕ
	|	(ВЫРАЗИТЬ(ФинансовыйОбороты.Субконто1 КАК Справочник.Организации), ВЫРАЗИТЬ(ФинансовыйОбороты.Субконто2 КАК Справочник.Контрагенты)) В
	|			(ВЫБРАТЬ
	|				Т.Организация,
	|				Т.Контрагент
	|			ИЗ
	|				ВТ_Остатки КАК Т)
	|
	|ИНДЕКСИРОВАТЬ ПО
	|	Организация,
	|	Контрагент,
	|	Счет
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ВТ_Регистраторы_Предв.Период,
	|	ВТ_Регистраторы_Предв.Счет,
	|	ВТ_Регистраторы_Предв.Регистратор,
	|	ВТ_Регистраторы_Предв.Контрагент,
	|	ВТ_Регистраторы_Предв.СуммаОборотДт,
	|	ВТ_Остатки.СуммаОстатокДт,
	|	ВТ_Остатки.Организация
	|ПОМЕСТИТЬ ВТ_Регистраторы
	|ИЗ
	|	ВТ_Регистраторы_Предв КАК ВТ_Регистраторы_Предв
	|		ЛЕВОЕ СОЕДИНЕНИЕ ВТ_Остатки КАК ВТ_Остатки
	|		ПО ВТ_Регистраторы_Предв.Организация = ВТ_Остатки.Организация
	|			И ВТ_Регистраторы_Предв.Контрагент = ВТ_Остатки.Контрагент
	|			И ВТ_Регистраторы_Предв.Счет = ВТ_Остатки.Счет
	|ГДЕ
	|	ВТ_Регистраторы_Предв.СуммаОборотДт <> 0
	|	И НЕ ВТ_Остатки.Счет ЕСТЬ NULL 
	|
	|ИНДЕКСИРОВАТЬ ПО
	|	ВТ_Остатки.Организация,
	|	ВТ_Регистраторы_Предв.Контрагент,
	|	ВТ_Регистраторы_Предв.Счет,
	|	ВТ_Регистраторы_Предв.Период,
	|	ВТ_Регистраторы_Предв.Регистратор
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ВТ_Регистраторы.Период КАК Период,
	|	ВТ_Регистраторы.Счет КАК Счет,
	|	ВТ_Регистраторы.Регистратор,
	|	ВТ_Регистраторы.Контрагент КАК Контрагент,
	|	ВТ_Регистраторы.СуммаОборотДт,
	|	ВТ_Регистраторы.СуммаОстатокДт КАК СуммаОстатокДт,
	|	ВТ_Регистраторы.Организация КАК Организация
	|ИЗ
	|	ВТ_Регистраторы КАК ВТ_Регистраторы
	|
	|УПОРЯДОЧИТЬ ПО
	|	Период УБЫВ
	|ИТОГИ
	|	МАКСИМУМ(СуммаОстатокДт)
	|ПО
	|	Контрагент,
	|	Счет,
	|	Организация";
	
	Запрос.МенеджерВременныхТаблиц = Новый МенеджерВременныхТаблиц;
	
	ТЗ = Новый ТаблицаЗначений;
	ТЗ.Колонки.Добавить("Контрагент",Новый ОписаниеТипов("СправочникСсылка.Контрагенты"));
	ТЗ.Колонки.Добавить("Счет",Новый ОписаниеТипов("ПланСчетовСсылка.Финансовый"));
	ТЗ.Колонки.Добавить("Организация",Новый ОписаниеТипов("СправочникСсылка.ОРганизации"));
	ТЗ.Колонки.Добавить("Период",Новый ОписаниеТипов("Дата"));
	ОТЧисло = Новый ОписаниеТипов("Число",,Новый КвалификаторыЧисла(10,2));
	ТЗ.Колонки.Добавить("СуммаОстатокДт",ОТЧисло);
	ТЗ.Колонки.Добавить("СуммаОборотДт",ОТЧисло);
	ТЗ.Колонки.Добавить("СуммаДокумента",ОТЧисло);
	ТЗ.Колонки.Добавить("Регистратор",Документы.ТипВсеСсылки());
	ВыборкаКонтрагент = Запрос.Выполнить().Выбрать(ОбходРезультатаЗапроса.ПоГруппировкам);
	Пока ВыборкаКонтрагент.Следующий()Цикл
		ВыборкаСчет = ВыборкаКонтрагент.Выбрать(ОбходРезультатаЗапроса.ПоГруппировкам);
		Пока ВыборкаСчет.Следующий()Цикл
			ВыборкаОрг= ВыборкаСчет.Выбрать(ОбходРезультатаЗапроса.ПоГруппировкам);
			Пока ВыборкаОрг.Следующий()Цикл
				Оборот = 0;
				Выборка = ВыборкаОрг.Выбрать();
				Пока Выборка.Следующий() Цикл
					СтрокаТЗ = ТЗ.Добавить();
					ЗаполнитьЗначенияСвойств(СтрокаТЗ,Выборка);
					СтрокаТЗ.СуммаОборотДт = Мин(Оборот,ВыборкаОрг.СуммаОстатокДт);
					СтрокаТЗ.СуммаДокумента = Выборка.СуммаОборотДт;
					Оборот = Оборот+Выборка.СуммаОборотДт;
					Если Оборот>=ВыборкаОрг.СуммаОстатокДт Тогда
						Прервать
					КонецЕсли;
				КонецЦикла;
				Если Оборот < ВыборкаОрг.СуммаОстатокДт Тогда
					СтрокаТЗ = ТЗ.Добавить();
					ЗаполнитьЗначенияСвойств(СтрокаТЗ,ВыборкаОрг);
					СтрокаТЗ.Период = Дата(1,1,1);
					СтрокаТЗ.Регистратор = "Операции прошлых лет";//Документы.РасходИзБанка.ПустаяСсылка();
					СтрокаТЗ.СуммаДокумента = ВыборкаОрг.СуммаОстатокДт -Оборот;
					СтрокаТЗ.СуммаОборотДт = Оборот;
				КонецЕсли;
			КонецЦикла;
		КонецЦикла;
	КонецЦикла;
	
	Запрос.УстановитьПараметр("ТЗ",ТЗ);
	Запрос.Текст =
"ВЫБРАТЬ
|	ВТ.Контрагент КАК Контрагент,
|	ВТ.Счет КАК Счет,
|	ВТ.Период КАК Период,
|	ВТ.Регистратор КАК Регистратор,
|	ВТ.СуммаДокумента КАК СуммаДокумента,
|	ВТ.СуммаОстатокДт КАК СуммаОстатокДт,
|	ВТ.СуммаОборотДт КАК СуммаОборотДт,
|	ВТ.Организация
|ПОМЕСТИТЬ ВТ_СуммыОборотовНарастающим
|ИЗ
|	&ТЗ КАК ВТ
|;

|
|ВЫБРАТЬ
|	Обороты.Счет,
|	Обороты.Контрагент,
|	Обороты.Организация,
|	СУММА(Обороты.СуммаДокумента) КАК СуммаДокумента
|ПОМЕСТИТЬ ВТРасчетыПоСделкам
|ИЗ
|	(ВЫБРАТЬ РАЗЛИЧНЫЕ
|		ЗаявкаНаРасходованиеСредствТорговыеТочки.Ссылка КАК Заявка
|	ИЗ
|		Документ.ЗаявкаНаРасходованиеСредств.ТорговыеТочки КАК ЗаявкаНаРасходованиеСредствТорговыеТочки
|	ГДЕ
|		ЗаявкаНаРасходованиеСредствТорговыеТочки.Сделка <> ЗНАЧЕНИЕ(Документ.СделкаСПоставщиком.ПустаяСсылка)) КАК ЗаявкиПоСделкам
|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ (ВЫБРАТЬ
|			ВТ_СуммыОборотовНарастающим.Регистратор КАК Регистратор,
|			ВТ_СуммыОборотовНарастающим.СуммаДокумента КАК СуммаДокумента,
|			ВТ_СуммыОборотовНарастающим.Счет КАК Счет,
|			ВТ_СуммыОборотовНарастающим.Организация КАК Организация,
|			ВТ_СуммыОборотовНарастающим.Контрагент КАК Контрагент
|		ИЗ
|			ВТ_СуммыОборотовНарастающим КАК ВТ_СуммыОборотовНарастающим
|		ГДЕ
|			ВТ_СуммыОборотовНарастающим.СуммаОборотДт <= ВТ_СуммыОборотовНарастающим.СуммаОстатокДт
|			И ВТ_СуммыОборотовНарастающим.Регистратор ССЫЛКА Документ.РасходИзБанка) КАК Обороты
|		ПО ЗаявкиПоСделкам.Заявка = Обороты.Регистратор.ЗаявкаНаРасходованиеСредств

|СГРУППИРОВАТЬ ПО
|	Обороты.Счет,
|	Обороты.Контрагент,
|	Обороты.Организация
|;

|
|ВЫБРАТЬ
|	ЛимитыАренднойПлатыСрезПоследних.ТорговаяТочка,
|	МАКСИМУМ(ЛимитыАренднойПлатыСрезПоследних.МесяцАренды) КАК МесяцАренды,
|	ЛимитыАренднойПлатыСрезПоследних.Период КАК Период
|ПОМЕСТИТЬ ВТЛимитыПоАренде
|ИЗ
|	РегистрСведений.ЛимитыАренднойПлаты.СрезПоследних(&КонецПериода, МесяцАренды <= &КонецПериода) КАК ЛимитыАренднойПлатыСрезПоследних

|СГРУППИРОВАТЬ ПО
|	ЛимитыАренднойПлатыСрезПоследних.ТорговаяТочка,
|	ЛимитыАренднойПлатыСрезПоследних.Период
|;

|
|ВЫБРАТЬ
|	АК_ЛимитыДебиторскойЗадолженностиСрезПервых.РазделУчета КАК Счет,
|	АК_ЛимитыДебиторскойЗадолженностиСрезПервых.Контрагент,
|	АК_ЛимитыДебиторскойЗадолженностиСрезПервых.Организация,
|	АК_ЛимитыДебиторскойЗадолженностиСрезПервых.Сумма
|ПОМЕСТИТЬ ВТ_ХорошаяДЗ
|ИЗ
|	РегистрСведений.АК_ЛимитыДебиторскойЗадолженности.СрезПервых(&конецПериода, ) КАК АК_ЛимитыДебиторскойЗадолженностиСрезПервых

|ОБЪЕДИНИТЬ ВСЕ

|ВЫБРАТЬ
|	ЗНАЧЕНИЕ(ПланСчетов.Финансовый.РасчетыПоАренде),
|	УслугиПоДоговорамАрендыСрезПоследних.Контрагент,
|	УслугиПоДоговорамАрендыСрезПоследних.Организация,
|	СУММА((ЛимитыАренднойПлатыСрезПоследних.СуммаАрендаПостоянная + ЛимитыАренднойПлатыСрезПоследних.СуммаАрендаПеременная) * ВЫБОР
|			КОГДА УслугиПоДоговорамАрендыСрезПоследних.Договор.ПериодОплатыАренды = ЗНАЧЕНИЕ(Перечисление.ВидыПериодовОплатыАренды.Следующий)
|				ТОГДА 2
|			ИНАЧЕ 1
|		КОНЕЦ)
|ИЗ
|	РегистрСведений.ЛимитыАренднойПлаты.СрезПоследних(&конецПериода, МесяцАренды <= &КонецПериода) КАК ЛимитыАренднойПлатыСрезПоследних
|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ (ВЫБРАТЬ
|			ВТЛимитыПоАренде.ТорговаяТочка КАК ТорговаяТочка,
|			МАКСИМУМ(ВТЛимитыПоАренде.Период) КАК Период,
|			ВТЛимитыПоАренде.МесяцАренды КАК МесяцАренды
|		ИЗ
|			ВТЛимитыПоАренде КАК ВТЛимитыПоАренде
|				ВНУТРЕННЕЕ СОЕДИНЕНИЕ (ВЫБРАТЬ
|					ВТЛимитыПоАренде.ТорговаяТочка КАК ТорговаяТочка,
|					МАКСИМУМ(ВТЛимитыПоАренде.Период) КАК Период
|				ИЗ
|					ВТЛимитыПоАренде КАК ВТЛимитыПоАренде
|				
|				СГРУППИРОВАТЬ ПО
|					ВТЛимитыПоАренде.ТорговаяТочка) КАК ВложенныйЗапрос
|				ПО ВТЛимитыПоАренде.ТорговаяТочка = ВложенныйЗапрос.ТорговаяТочка
|					И ВТЛимитыПоАренде.Период = ВложенныйЗапрос.Период
|		
|		СГРУППИРОВАТЬ ПО
|			ВТЛимитыПоАренде.ТорговаяТочка,
|			ВТЛимитыПоАренде.МесяцАренды) КАК ПоследниеПериоды
|		ПО (ПоследниеПериоды.ТорговаяТочка = ЛимитыАренднойПлатыСрезПоследних.ТорговаяТочка)
|			И (ПоследниеПериоды.Период = ЛимитыАренднойПлатыСрезПоследних.Период)
|			И (ПоследниеПериоды.МесяцАренды = ЛимитыАренднойПлатыСрезПоследних.МесяцАренды)
|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ РегистрСведений.УслугиПоДоговорамАренды.СрезПоследних(&конецПериода, ) КАК УслугиПоДоговорамАрендыСрезПоследних
|		ПО (УслугиПоДоговорамАрендыСрезПоследних.ОбъектАренды.СтруктурнаяЕдиница = ЛимитыАренднойПлатыСрезПоследних.ТорговаяТочка)
|ГДЕ
|	УслугиПоДоговорамАрендыСрезПоследних.Статус = ЗНАЧЕНИЕ(Перечисление.СтатусыДоговоровКонтрагентов.Действует)

|СГРУППИРОВАТЬ ПО
|	УслугиПоДоговорамАрендыСрезПоследних.Контрагент,
|	УслугиПоДоговорамАрендыСрезПоследних.Организация

|ОБЪЕДИНИТЬ ВСЕ

|ВЫБРАТЬ
|	ЗНАЧЕНИЕ(ПланСчетов.Финансовый.ОбеспечительныйВзнос),
|	УслугиПоДоговорамАрендыСрезПоследних.Контрагент,
|	УслугиПоДоговорамАрендыСрезПоследних.Организация,
|	СУММА(ВЫБОР УслугиПоДоговорамАрендыСрезПоследних.Регистратор.СпособРасчета
|			КОГДА ЗНАЧЕНИЕ(Перечисление.СпособыРасчетаКурсаВалюты.Расчетный)
|				ТОГДА УслугиПоДоговорамАрендыСрезПоследних.Регистратор.ВерхняяГраница
|			КОГДА ЗНАЧЕНИЕ(Перечисление.СпособыРасчетаКурсаВалюты.Фиксированный)
|				ТОГДА УслугиПоДоговорамАрендыСрезПоследних.Регистратор.Курс
|			ИНАЧЕ 1
|		КОНЕЦ * ВЫБОР УслугиПоДоговорамАрендыСрезПоследних.СпособНачисления.ПериодНачисления
|			КОГДА ЗНАЧЕНИЕ(Перечисление.Периодичность.Год)
|				ТОГДА 1 / 12
|			КОГДА ЗНАЧЕНИЕ(Перечисление.Периодичность.День)
|				ТОГДА 31
|			ИНАЧЕ 1
|		КОНЕЦ * УслугиПоДоговорамАрендыСрезПоследних.Ставка)
|ИЗ
|	РегистрСведений.УслугиПоДоговорамАренды.СрезПоследних(&конецПериода, ) КАК УслугиПоДоговорамАрендыСрезПоследних
|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ (ВЫБРАТЬ
|			МАКСИМУМ(УслугиПоДоговорамАрендыСрезПоследних.Период) КАК Период,
|			УслугиПоДоговорамАрендыСрезПоследних.Организация КАК Организация,
|			УслугиПоДоговорамАрендыСрезПоследних.Договор КАК Договор,
|			УслугиПоДоговорамАрендыСрезПоследних.ОбъектАренды КАК ОбъектАренды,
|			УслугиПоДоговорамАрендыСрезПоследних.Услуга КАК Услуга,
|			УслугиПоДоговорамАрендыСрезПоследних.Контрагент КАК Контрагент
|		ИЗ
|			РегистрСведений.УслугиПоДоговорамАренды.СрезПоследних(&конецПериода, ) КАК УслугиПоДоговорамАрендыСрезПоследних
|		ГДЕ
|			УслугиПоДоговорамАрендыСрезПоследних.Статус = ЗНАЧЕНИЕ(Перечисление.СтатусыДоговоровКонтрагентов.Действует)
|		
|		СГРУППИРОВАТЬ ПО
|			УслугиПоДоговорамАрендыСрезПоследних.Организация,
|			УслугиПоДоговорамАрендыСрезПоследних.Договор,
|			УслугиПоДоговорамАрендыСрезПоследних.ОбъектАренды,
|			УслугиПоДоговорамАрендыСрезПоследних.Услуга,
|			УслугиПоДоговорамАрендыСрезПоследних.Контрагент) КАК ВложенныйЗапрос
|		ПО УслугиПоДоговорамАрендыСрезПоследних.Организация = ВложенныйЗапрос.Организация
|			И УслугиПоДоговорамАрендыСрезПоследних.Договор = ВложенныйЗапрос.Договор
|			И УслугиПоДоговорамАрендыСрезПоследних.Контрагент = ВложенныйЗапрос.Контрагент
|			И УслугиПоДоговорамАрендыСрезПоследних.Услуга = ВложенныйЗапрос.Услуга
|			И УслугиПоДоговорамАрендыСрезПоследних.ОбъектАренды = ВложенныйЗапрос.ОбъектАренды
|			И УслугиПоДоговорамАрендыСрезПоследних.Период = ВложенныйЗапрос.Период

|СГРУППИРОВАТЬ ПО
|	УслугиПоДоговорамАрендыСрезПоследних.Контрагент,
|	УслугиПоДоговорамАрендыСрезПоследних.Организация

|ОБЪЕДИНИТЬ ВСЕ

|ВЫБРАТЬ
|	ВТРасчетыПоСделкам.Счет,
|	ВТРасчетыПоСделкам.Контрагент,
|	ВТРасчетыПоСделкам.Организация,
|	СУММА(ВТРасчетыПоСделкам.СуммаДокумента)
|ИЗ
|	ВТРасчетыПоСделкам КАК ВТРасчетыПоСделкам

|СГРУППИРОВАТЬ ПО
|	ВТРасчетыПоСделкам.Счет,
|	ВТРасчетыПоСделкам.Контрагент,
|	ВТРасчетыПоСделкам.Организация
|;

|
|ВЫБРАТЬ
|	СУММА(ВЫБОР
|			КОГДА ФинансовыйОстаткиИОбороты.Период = &НачалоПредМес
|				ТОГДА ФинансовыйОстаткиИОбороты.СуммаНачальныйОстаток
|			ИНАЧЕ 0
|		КОНЕЦ) КАК СальдоПредМесяца,
|	СУММА(ВЫБОР
|			КОГДА ФинансовыйОстаткиИОбороты.Период = НАЧАЛОПЕРИОДА(&КонецПериода, МЕСЯЦ)
|				ТОГДА ФинансовыйОстаткиИОбороты.СуммаНачальныйОстаток
|			ИНАЧЕ 0
|		КОНЕЦ) КАК СальдоТекМесяца,
|	СУММА(ВЫБОР
|			КОГДА ФинансовыйОстаткиИОбороты.Период = &НачалоПредМес
|				ТОГДА ФинансовыйОстаткиИОбороты.СуммаОборотДт
|			ИНАЧЕ 0
|		КОНЕЦ) КАК ОборотДтПредМесяца,
|	СУММА(ВЫБОР
|			КОГДА ФинансовыйОстаткиИОбороты.Период = НАЧАЛОПЕРИОДА(&КонецПериода, МЕСЯЦ)
|				ТОГДА ФинансовыйОстаткиИОбороты.СуммаОборотДт
|			ИНАЧЕ 0
|		КОНЕЦ) КАК ОборотДтТекМесяца,
|	СУММА(ВЫБОР
|			КОГДА ФинансовыйОстаткиИОбороты.Период = &НачалоПредМес
|				ТОГДА ФинансовыйОстаткиИОбороты.СуммаОборотКт
|			ИНАЧЕ 0
|		КОНЕЦ) КАК ОборотКтПредМесяца,
|	СУММА(ВЫБОР
|			КОГДА ФинансовыйОстаткиИОбороты.Период = НАЧАЛОПЕРИОДА(&КонецПериода, МЕСЯЦ)
|				ТОГДА ФинансовыйОстаткиИОбороты.СуммаОборотКт
|			ИНАЧЕ 0
|		КОНЕЦ) КАК ОборотКтТекМесяца,
|	ФинансовыйОстаткиИОбороты.Счет,
|	ФинансовыйОстаткиИОбороты.Субконто1 КАК Организация,
|	ФинансовыйОстаткиИОбороты.Субконто2 КАК Контрагент
|ПОМЕСТИТЬ ОстаткиИОбороты
|ИЗ
|	РегистрБухгалтерии.Финансовый.ОстаткиИОбороты(
|			&НачалоПредМес,
|			&КонецПериода,
|			Месяц,
|			,
|			Счет В
|				(ВЫБРАТЬ
|					Т.Счет
|				ИЗ
|					ВТ_Остатки КАК Т),
|			,
|			(Субконто1, Субконто2) В
|				(ВЫБРАТЬ
|					Т.Организация,
|					Т.Контрагент
|				ИЗ
|					ВТ_Остатки КАК Т)) КАК ФинансовыйОстаткиИОбороты

|СГРУППИРОВАТЬ ПО
|	ФинансовыйОстаткиИОбороты.Счет,
|	ФинансовыйОстаткиИОбороты.Субконто1,
|	ФинансовыйОстаткиИОбороты.Субконто2
|;

|
|ВЫБРАТЬ
|	ТаблицаЗадолженности.Контрагент,
|	ТаблицаЗадолженности.Счет,
|	ТаблицаЗадолженности.Период,
|	ТаблицаЗадолженности.Регистратор,
|	ТаблицаЗадолженности.СуммаДокумента,
|	ВЫБОР
|		КОГДА ТаблицаЗадолженности.СуммаОстатокДт - ТаблицаЗадолженности.СуммаОборотДт >= ТаблицаЗадолженности.СуммаДокумента
|			ТОГДА ТаблицаЗадолженности.СуммаДокумента
|		ИНАЧЕ ТаблицаЗадолженности.СуммаОстатокДт - ТаблицаЗадолженности.СуммаОборотДт
|	КОНЕЦ КАК Задолженность,
|	ВЫБОР
|		КОГДА ТаблицаЗадолженности.СуммаОстатокДт - ТаблицаЗадолженности.СуммаОборотДт <= ЕСТЬNULL(ВТ_ХорошаяДЗ.Сумма, 0)
|			ТОГДА ВЫБОР
|					КОГДА ТаблицаЗадолженности.СуммаОстатокДт - ТаблицаЗадолженности.СуммаОборотДт >= ТаблицаЗадолженности.СуммаДокумента
|						ТОГДА ТаблицаЗадолженности.СуммаДокумента
|					ИНАЧЕ ТаблицаЗадолженности.СуммаОстатокДт - ТаблицаЗадолженности.СуммаОборотДт
|				КОНЕЦ
|		КОГДА ТаблицаЗадолженности.СуммаОстатокДт - ТаблицаЗадолженности.СуммаОборотДт - ТаблицаЗадолженности.СуммаДокумента >= ЕСТЬNULL(ВТ_ХорошаяДЗ.Сумма, 0)
|			ТОГДА 0
|		КОГДА ТаблицаЗадолженности.СуммаОборотДт + ТаблицаЗадолженности.СуммаДокумента <= ТаблицаЗадолженности.СуммаОстатокДт
|			ТОГДА ЕСТЬNULL(ВТ_ХорошаяДЗ.Сумма, 0) - ТаблицаЗадолженности.СуммаОстатокДт + ТаблицаЗадолженности.СуммаОборотДт + ТаблицаЗадолженности.СуммаДокумента
|		ИНАЧЕ ЕСТЬNULL(ВТ_ХорошаяДЗ.Сумма, 0)
|	КОНЕЦ КАК ХорошаяДЗ,
|	ВЫБОР
|		КОГДА ТаблицаЗадолженности.СуммаОстатокДт - ТаблицаЗадолженности.СуммаОборотДт >= ТаблицаЗадолженности.СуммаДокумента
|			ТОГДА ТаблицаЗадолженности.СуммаДокумента
|		ИНАЧЕ ТаблицаЗадолженности.СуммаОстатокДт - ТаблицаЗадолженности.СуммаОборотДт
|	КОНЕЦ - ВЫБОР
|		КОГДА ТаблицаЗадолженности.СуммаОстатокДт - ТаблицаЗадолженности.СуммаОборотДт <= ЕСТЬNULL(ВТ_ХорошаяДЗ.Сумма, 0)
|			ТОГДА ВЫБОР
|					КОГДА ТаблицаЗадолженности.СуммаОстатокДт - ТаблицаЗадолженности.СуммаОборотДт >= ТаблицаЗадолженности.СуммаДокумента
|						ТОГДА ТаблицаЗадолженности.СуммаДокумента
|					ИНАЧЕ ТаблицаЗадолженности.СуммаОстатокДт - ТаблицаЗадолженности.СуммаОборотДт
|				КОНЕЦ
|		КОГДА ТаблицаЗадолженности.СуммаОстатокДт - ТаблицаЗадолженности.СуммаОборотДт - ТаблицаЗадолженности.СуммаДокумента >= ЕСТЬNULL(ВТ_ХорошаяДЗ.Сумма, 0)
|			ТОГДА 0
|		КОГДА ТаблицаЗадолженности.СуммаОборотДт + ТаблицаЗадолженности.СуммаДокумента <= ТаблицаЗадолженности.СуммаОстатокДт
|			ТОГДА ЕСТЬNULL(ВТ_ХорошаяДЗ.Сумма, 0) - ТаблицаЗадолженности.СуммаОстатокДт + ТаблицаЗадолженности.СуммаОборотДт + ТаблицаЗадолженности.СуммаДокумента
|		ИНАЧЕ ЕСТЬNULL(ВТ_ХорошаяДЗ.Сумма, 0)
|	КОНЕЦ КАК ПлохаяДЗ,
|	ЕСТЬNULL(ВТ_ХорошаяДЗ.Сумма, 0) КАК Лимит,
|	ТаблицаЗадолженности.Организация,
|	ВЫБОР
|		КОГДА ТаблицаЗадолженности.Регистратор ССЫЛКА Документ.РасходИзБанка
|				И НЕ ТаблицаЗадолженности.Регистратор.ЗаявкаНаРасходованиеСредств = ЗНАЧЕНИЕ(Документ.ЗаявкаНаРасходованиеСредств.ПустаяСсылка)
|			ТОГДА ВЫБОР
|					КОГДА ТаблицаЗадолженности.Регистратор.ЗаявкаНаРасходованиеСредств.ДокументОснование ССЫЛКА Документ.КомплектацияМагазинаПоСделкамСПоставщиком
|							И НЕ ТаблицаЗадолженности.Регистратор.ЗаявкаНаРасходованиеСредств.ДокументОснование = ЗНАЧЕНИЕ(Документ.КомплектацияМагазинаПоСделкамСПоставщиком.ПустаяСсылка)
|						ТОГДА ВЫБОР
|								КОГДА НЕ ТаблицаЗадолженности.Регистратор.ЗаявкаНаРасходованиеСредств.ДокументОснование.Ответственный.ФизЛицо = ЗНАЧЕНИЕ(Справочник.ФизическиеЛица.ПустаяСсылка)
|									ТОГДА ТаблицаЗадолженности.Регистратор.ЗаявкаНаРасходованиеСредств.ДокументОснование.Ответственный.ФизЛицо
|								ИНАЧЕ &ИнициаторКлимчук
|							КОНЕЦ
|					КОГДА НЕ ТаблицаЗадолженности.Регистратор.ЗаявкаНаРасходованиеСредств.ИнициаторЗаявки = ЗНАЧЕНИЕ(Справочник.ФизическиеЛица.ПустаяСсылка)
|							И НЕ ТаблицаЗадолженности.Регистратор.ЗаявкаНаРасходованиеСредств.ИнициаторЗаявки.НеЯвляетсяИнициаторомЗаявокНаРасходДС
|						ТОГДА ТаблицаЗадолженности.Регистратор.ЗаявкаНаРасходованиеСредств.ИнициаторЗаявки
|					ИНАЧЕ ВЫБОР
|							КОГДА НЕ ТаблицаЗадолженности.Контрагент.ОсновнойМенеджерПокупателя.ФизЛицо = ЗНАЧЕНИЕ(Справочник.ФизическиеЛица.ПустаяСсылка)
|								ТОГДА ТаблицаЗадолженности.Контрагент.ОсновнойМенеджерПокупателя.ФизЛицо
|							ИНАЧЕ ТаблицаЗадолженности.Контрагент.ОсновнойМенеджерПокупателя
|						КОНЕЦ
|				КОНЕЦ
|		ИНАЧЕ ВЫБОР
|				КОГДА НЕ ТаблицаЗадолженности.Контрагент.ОсновнойМенеджерПокупателя.ФизЛицо = ЗНАЧЕНИЕ(Справочник.ФизическиеЛица.ПустаяСсылка)
|					ТОГДА ТаблицаЗадолженности.Контрагент.ОсновнойМенеджерПокупателя.ФизЛицо
|				ИНАЧЕ ТаблицаЗадолженности.Контрагент.ОсновнойМенеджерПокупателя
|			КОНЕЦ
|	КОНЕЦ КАК Ответственный,
|	ЕСТЬNULL(ТаблицаЗадолженности.Регистратор.НазначениеПлатежа, """") КАК ЗаЧто,
|	ВЫБОР
|		КОГДА ТаблицаЗадолженности.СуммаОборотДт = 0
|			ТОГДА ТаблицаЗадолженности.СуммаДокумента
|		ИНАЧЕ 0
|	КОНЕЦ КАК СуммаПоследнейОперации,
|	ОстаткиИОбороты.СальдоПредМесяца,
|	ОстаткиИОбороты.СальдоТекМесяца,
|	ЕстьNull(ОстаткиИОбороты.ОборотДтПредМесяца,0) КАК ОборотДТПредМесяца,
|	ОстаткиИОбороты.ОборотДтТекМесяца,
|	ОстаткиИОбороты.ОборотКтПредМесяца,
|	ОстаткиИОбороты.ОборотКтТекМесяца,
|	ЕСТЬNULL(Комментарии.Комментарий, """") КАК Комментарий,
|	ЕСТЬNULL(Комментарии.Период, ДАТАВРЕМЯ(1, 1, 1)) КАК ДатаСоздания
|ИЗ
|	ВТ_СуммыОборотовНарастающим КАК ТаблицаЗадолженности
|		ЛЕВОЕ СОЕДИНЕНИЕ ВТ_ХорошаяДЗ КАК ВТ_ХорошаяДЗ
|		ПО ТаблицаЗадолженности.Контрагент = ВТ_ХорошаяДЗ.Контрагент
|			И ТаблицаЗадолженности.Счет = ВТ_ХорошаяДЗ.Счет
|			И ТаблицаЗадолженности.Организация = ВТ_ХорошаяДЗ.Организация
|		ЛЕВОЕ СОЕДИНЕНИЕ ОстаткиИОбороты КАК ОстаткиИОбороты
|		ПО ТаблицаЗадолженности.Контрагент = ОстаткиИОбороты.Контрагент
|			И ТаблицаЗадолженности.Организация = ОстаткиИОбороты.Организация
|			И ТаблицаЗадолженности.Счет = ОстаткиИОбороты.Счет
|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.АК_КомментарииКДебЗадолженности.СрезПоследних(&ТекущаяДата, ) КАК Комментарии
|		ПО ТаблицаЗадолженности.Регистратор = Комментарии.ДокументЗадолженности
|			И ТаблицаЗадолженности.Контрагент = Комментарии.Контрагент";	

	РезультатЗапроса = Запрос.Выполнить();
	//запрос.текст = "выбрать * из остаткиИОбороты КАК Т";
	//Выборка = РезультатЗапроса.Выбрать();
	//Пока Выборка.Следующий()Цикл
	//	В = Выборка;
	//КонецЦикла;
	ТаблицаДанных = РезультатЗапроса.Выгрузить();
	
	ВнешниеНаборыДанных = Новый Структура("ТаблицаДанных",ТаблицаДанных);
	ВнешнийНД = СхемаКомпоновкиДанных.НаборыДанных.Добавить(Тип("НаборДанныхОбъектСхемыКомпоновкиДанных"));
	НаборДанных = СхемаКомпоновкиДанных.НаборыДанных[0];
	ИмяНабора = НаборДанных.Имя;
	ЗаполнитьЗначенияСвойств(ВнешнийНД,СхемаКомпоновкиДанных.НаборыДанных.НаборДанных1);
	
	Для Каждого Поле из НаборДанных.Поля Цикл
		НовоеПоле = ВнешнийНД.Поля.Добавить(ТипЗнч(Поле));
		ЗаполнитьЗначенияСвойств(НОвоеПоле,Поле)
	КонецЦикла;
	
	СхемаКомпоновкиДанных.НаборыДанных.Удалить(НаборДанных);
	СхемаКомпоновкиДанных.НаборыДанных[0].Имя = ИмяНабора;
	СхемаКомпоновкиДанных.НаборыДанных[0].ИмяОбъекта = "ТаблицаДанных";
	
	
	
    МакетКомпоновки = КомпоновщикМакета.Выполнить(СхемаКомпоновкиДанных, Настройки, ДанныеРасшифровки); // +++ АК Зайцева А. задача 14301 добавила ДанныеРасшифровки
    ПроцессорКомпоновки = Новый ПроцессорКомпоновкиДанных;
    ПроцессорКомпоновки.Инициализировать(МакетКомпоновки, ВнешниеНаборыДанных, ДанныеРасшифровки); // +++ АК Зайцева А. задача 14301 добавила ДанныеРасшифровки
    ДокументРезультат.Очистить();
    
    ПроцессорВывода = Новый ПроцессорВыводаРезультатаКомпоновкиДанныхВТабличныйДокумент;
    ПроцессорВывода.УстановитьДокумент(ДокументРезультат);
    ПроцессорВывода.Вывести(ПроцессорКомпоновки);   
	
	// +++ АК Зайцева А. задача 14301 
	//Для Ряд = ДокументРезультат.ФиксацияСверху + 1 По ДокументРезультат.ВысотаТаблицы Цикл 
	//	Для Колонка = ДокументРезультат.ФиксацияСлева + 1 По ДокументРезультат.ШиринаТаблицы Цикл 
	//		ТекущаяОбласть = ДокументРезультат.Область(Ряд, Колонка, Ряд, Колонка);
	//		
	//		Если ТипЗнч(ТекущаяОбласть.Расшифровка) = Тип("Строка") Тогда
	//			ТекущаяОбласть.Защита = Ложь;	
	//		КонецЕсли;
	//	КонецЦикла;
	//КонецЦикла;
	// ---АК
	УстановитьПривилегированныйРежим(Ложь);
	
КонецПроцедуры
