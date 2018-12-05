﻿
Процедура ПриКомпоновкеРезультата(ДокументРезультат, ДанныеРасшифровки, СтандартнаяОбработка) 
	
	СтандартнаяОбработка = Ложь;		
 	
	Если РабочаяБаза Тогда
		СтрокаПодключения="Srvr=" + СерверРабочейБазы + "; Ref=" + ИмяБД + "; Usr=""Обмен""; Pwd=""123321""";
	Иначе
		СтрокаПодключения="Srvr=" + СерверТестовойБазы + "; Ref=" + ИмяТестовойБД + "; Usr=""Обмен""; Pwd=""123321""";
	КонецЕсли;
	
	v82COMОбъект = Новый COMОбъект("v82.COMConnector");
	Попытка
		v82 = v82COMОбъект.Connect(СтрокаПодключения);
		ПодключениеУстановлено=Истина;
	Исключение
		ПодключениеУстановлено=Ложь;
		Сообщить("Не удалось подключиться к базе бухгалтерии!");
		Возврат;
	КонецПопытки;
	
	Запрос=v82.NewObject("Запрос");
	
	ЗапросДанныеФинансов = Новый Запрос;
	
	ПТУ = Ложь;
	
	ДанныеБух.Очистить();
	ТаблицаФинансы.Очистить();
		
	КомпоновщикНастроек.ЗагрузитьНастройки(КомпоновщикНастроек.ПолучитьНастройки());
	
	Для каждого Параметр из КомпоновщикНастроек.Настройки.ПараметрыДанных.Элементы Цикл
		Если СокрЛП(Параметр.Параметр)="ПериодОтчета" Тогда
			Запрос.УстановитьПараметр("НачалоПериода",Параметр.Значение.ДатаНачала);
			Запрос.УстановитьПараметр("КонецПериода",КонецДня(Параметр.Значение.ДатаОкончания));
			
			ЗапросДанныеФинансов.УстановитьПараметр("НачалоПериода",Параметр.Значение.ДатаНачала);
			ЗапросДанныеФинансов.УстановитьПараметр("КонецПериода",КонецДня(Параметр.Значение.ДатаОкончания));			
			
		ИначеЕсли СокрЛП(Параметр.Параметр) = "Основной" Тогда
			Основной = Параметр.Использование;
		КонецЕсли;
	КонецЦикла;
	
	СводнаяТаблица = Новый ТаблицаЗначений;
	СводнаяТаблица.Колонки.Добавить("Раздел");
	СводнаяТаблица.Колонки.Добавить("ДокументБух");
	СводнаяТаблица.Колонки.Добавить("ДокументФин");
	СводнаяТаблица.Колонки.Добавить("СуммаБух");
	СводнаяТаблица.Колонки.Добавить("СуммаФин");	
	
	СводнаяТаблица.Колонки.Добавить("СчетДТФин");
	СводнаяТаблица.Колонки.Добавить("СчетКТФин");
	СводнаяТаблица.Колонки.Добавить("СчетДТБух");
	СводнаяТаблица.Колонки.Добавить("СчетКТБух");
		
	Если Основной Тогда		
			
		ДанныеБух.Очистить();
		ТаблицаФинансы.Очистить();
		
		//Удаленная база
		
		ТекстЗапроса = "ВЫБРАТЬ РАЗРЕШЕННЫЕ
		|	ПРЕДСТАВЛЕНИЕ(ХозрасчетныйОбороты.Регистратор) КАК Документ,
		|	ХозрасчетныйОбороты.Регистратор КАК ДокументСсылка,
		|	ХозрасчетныйОбороты.Регистратор.Дата КАК ДатаПоиска,
		|	ХозрасчетныйОбороты.Регистратор.Номер КАК НомерПоиска,
		|	СУММА(ХозрасчетныйОбороты.СуммаОборот) КАК Сумма,
		|	ХозрасчетныйОбороты.СчетДт.Код КАК СчетДт,
		|	ХозрасчетныйОбороты.СчетКт.Код КАК СчетКт
		|ИЗ
		|	РегистрБухгалтерии.Хозрасчетный.ОборотыДтКт(&НачалоПериода, &КонецПериода, Регистратор, СчетДт В (&СписокСчетов), , , , ) КАК ХозрасчетныйОбороты
		|ГДЕ
		|	(ХозрасчетныйОбороты.Регистратор ССЫЛКА Документ.ПоступлениеТоваровУслуг
		|	ИЛИ ХозрасчетныйОбороты.Регистратор ССЫЛКА Документ.ПоступлениеДопРасходов)
		//Отладка
		//|	И ХозрасчетныйОбороты.Регистратор.Номер В(&МассивНомеров)
		|
		|
		|СГРУППИРОВАТЬ ПО
		|	ХозрасчетныйОбороты.СчетДт.Код,
		|	ХозрасчетныйОбороты.СчетКт.Код,
		|	ХозрасчетныйОбороты.Регистратор,
		|	ХозрасчетныйОбороты.Регистратор.Дата,
		|	ХозрасчетныйОбороты.Регистратор.Номер,
		|	ХозрасчетныйОбороты.СчетДт,
		|	ХозрасчетныйОбороты.СчетКт
		|
		
		//Используется отбор только СчетДт. 

		//|ОБЪЕДИНИТЬ
		//|
		//|ВЫБРАТЬ
		//|	ПРЕДСТАВЛЕНИЕ(ХозрасчетныйОбороты.Регистратор),
		//|	ХозрасчетныйОбороты.Регистратор,
		//|	ХозрасчетныйОбороты.Регистратор.Дата,
		//|	ХозрасчетныйОбороты.Регистратор.Номер,
		//|	СУММА(ХозрасчетныйОбороты.СуммаОборот),
		//|	ХозрасчетныйОбороты.СчетДт.Код,
		//|	ХозрасчетныйОбороты.СчетКт.Код
		//|ИЗ
		//|	РегистрБухгалтерии.Хозрасчетный.ОборотыДтКт(&НачалоПериода, &КонецПериода, Регистратор, , , СчетКт В (&СписокСчетов), , ) КАК ХозрасчетныйОбороты
		//|ГДЕ
		//|	ХозрасчетныйОбороты.Регистратор ССЫЛКА Документ.ПоступлениеТоваровУслуг
		//|		ИЛИ ХозрасчетныйОбороты.Регистратор ССЫЛКА Документ.ПоступлениеДопРасходов
		//|
		//|
		//|СГРУППИРОВАТЬ ПО
		//|	ХозрасчетныйОбороты.Регистратор,
		//|	ХозрасчетныйОбороты.СчетКт.Код,
		//|	ХозрасчетныйОбороты.СчетДт.Код,
		//|	ХозрасчетныйОбороты.Регистратор.Дата,
		//|	ХозрасчетныйОбороты.Регистратор.Номер,
		//|	ХозрасчетныйОбороты.СчетДт,
		//|	ХозрасчетныйОбороты.СчетКт
		|
		|
		|УПОРЯДОЧИТЬ ПО
		|	СчетДт
		|АВТОУПОРЯДОЧИВАНИЕ";
	
		Запрос.Текст = ТекстЗапроса;
		
		МассивСчетов = v82.NewObject("Массив");
		МассивСчетов.Добавить(v82.ПланыСчетов.Хозрасчетный.НДС);
		
		Запрос.УстановитьПараметр("СписокСчетов", МассивСчетов);
		
		//Отладка
		//МассивНомеров = v82.NewObject("Массив");
		//МассивНомеров.Добавить("VV0039548");
		//МассивНомеров.Добавить("VV0039691");
		//МассивНомеров.Добавить("VV0039755");
		//Запрос.УстановитьПараметр("МассивНомеров", МассивНомеров);

		Выборка = Запрос.Выполнить().Выбрать();
			
		Пока Выборка.Следующий() Цикл
			НоваяСтрока = ДанныеБух.Добавить();
			ЗаполнитьЗначенияСвойств(НоваяСтрока, Выборка);
			НоваяСтрока.НомерПоиска = СокрЛП(Выборка.НомерПоиска);					
			НоваяСтрока.ГУИД = v82.XMLСтрока(Выборка.ДокументСсылка); 
			НоваяСтрока.Раздел = "Основной";
		КонецЦикла;			
		
		//Текущая база
		
		ЗапросДанныеФинансов.Текст = "ВЫБРАТЬ РАЗРЕШЕННЫЕ
		|	ФинансовыйОбороты.СчетДт,
		|	ФинансовыйОбороты.СчетКт,
		|	ФинансовыйОбороты.Регистратор КАК Документ,
		|	ФинансовыйОбороты.Регистратор.Дата КАК ДатаПоиска,
		|	ФинансовыйОбороты.Регистратор.Номер КАК НомерПоиска,
		|	СУММА(ФинансовыйОбороты.СуммаОборот) КАК Сумма
		|ИЗ
		|	РегистрБухгалтерии.Финансовый.ОборотыДтКт(&НачалоПериода, &КонецПериода, Регистратор, СчетДт В (&МассивСчетов), , , , ) КАК ФинансовыйОбороты
		|ГДЕ
		|	(ФинансовыйОбороты.Регистратор ССЫЛКА Документ.ПоступлениеТоваровУслуг
		|			ИЛИ ФинансовыйОбороты.Регистратор ССЫЛКА Документ.ПоступлениеДопРасходов)
		|
		|СГРУППИРОВАТЬ ПО
		|	ФинансовыйОбороты.Регистратор,
		|	ФинансовыйОбороты.СчетДт,
		|	ФинансовыйОбороты.СчетКт,
		|	ФинансовыйОбороты.Регистратор.Дата,
		|	ФинансовыйОбороты.Регистратор.Номер
		|
		|УПОРЯДОЧИТЬ ПО
		|	ФинансовыйОбороты.СчетДт
		|АВТОУПОРЯДОЧИВАНИЕ";
		
		МассивСчетов = Новый Массив;	
		МассивСчетов.Добавить(ПланыСчетов.Финансовый.НалогиУН);		
	
		ЗапросДанныеФинансов.УстановитьПараметр("МассивСчетов", МассивСчетов);

		ТаблицаФинансы.Загрузить(ЗапросДанныеФинансов.Выполнить().Выгрузить());
	
	Для Каждого Стр Из ТаблицаФинансы Цикл
		Стр.ГУИД = Стр.Документ.УникальныйИдентификатор();		
		Стр.ДатаПоиска = Стр.ДатаПоиска;
		Стр.НомерПоиска = СокрЛП(Стр.НомерПоиска);
		Стр.Раздел = "Основной";
	КонецЦикла;
	
	Запрос = Новый Запрос("Выбрать * ПОМЕСТИТЬ ВТ_Фин Из &ВременнаяТаблица Как ВременнаяТаблица");
	Запрос.МенеджерВременныхТаблиц = Новый МенеджерВременныхТаблиц;
	Запрос.УстановитьПараметр("ВременнаяТаблица", ТаблицаФинансы.Выгрузить());
	Запрос.Выполнить();
	
	Запрос.Текст = "Выбрать * ПОМЕСТИТЬ ВТ_Бух Из &ВременнаяТаблица Как ВременнаяТаблица";
	Запрос.УстановитьПараметр("ВременнаяТаблица", ДанныеБух.Выгрузить());
	Запрос.Выполнить();
	
	Запрос.Текст = "ВЫБРАТЬ РАЗЛИЧНЫЕ
	|	ЕСТЬNULL(ВТ_Бух.Раздел, ВТ_Фин.Раздел) КАК Раздел,
	|	ЕСТЬNULL(ВТ_Бух.Документ, ""ДОКУМЕНТ НЕ НАЙДЕН"") КАК ДокументБух,
	|	ЕСТЬNULL(ВТ_Фин.Документ, ""ДОКУМЕНТ НЕ НАЙДЕН"") КАК ДокументФин,
	|	ЕСТЬNULL(ВТ_Бух.Сумма, 0) КАК СуммаБух,
	|	ЕСТЬNULL(ВТ_Фин.Сумма, 0) КАК СуммаФин,
	|	ВТ_Бух.СчетДТ КАК СчетДтБух,
	|	ВТ_Бух.СчетКТ КАК СчетКтБух,
	|	ВТ_Фин.СчетДТ КАК СчетДтФин,
	|	ВТ_Фин.СчетКТ КАК СчетКтФин,
	|	ЕСТЬNULL(ВТ_Бух.Сумма, 0) - ЕСТЬNULL(ВТ_Фин.Сумма, 0) КАК Отклонение
	|ИЗ
	|	ВТ_Фин КАК ВТ_Фин
	|		ПОЛНОЕ СОЕДИНЕНИЕ ВТ_Бух КАК ВТ_Бух
	|		ПО (ВТ_Фин.ГУИД = ВТ_Бух.ГУИД
	|				ИЛИ ВТ_Фин.НомерПоиска = ВТ_Бух.НомерПоиска
	|					И ВТ_Фин.ДатаПоиска = ВТ_Бух.ДатаПоиска)";
	
	СводнаяТаблица = Запрос.Выполнить().Выгрузить();
		
	КонецЕсли;
	
	//Из схемы возьмем настройки по умолчанию
	Настройки = КомпоновщикНастроек.Настройки;

	//Помещаем в переменную данные о расшифровке данных
	ДанныеРасшифровки = Новый ДанныеРасшифровкиКомпоновкиДанных;

	//Формируем макет, с помощью компоновщика макета
	КомпоновщикМакета = Новый КомпоновщикМакетаКомпоновкиДанных;

	//Передаем в макет компоновки схему, настройки и данные расшифровки
	МакетКомпоновки = КомпоновщикМакета.Выполнить(СхемаКомпоновкиДанных,
											Настройки, ДанныеРасшифровки);

	ВнешниеНаборыДанных=Новый Структура;

	ВнешниеНаборыДанных.Вставить("СводнаяТаблица",СводнаяТаблица);										
											
	//Выполним компоновку с помощью процессора компоновки
	ПроцессорКомпоновкиДанных = Новый ПроцессорКомпоновкиДанных;
	ПроцессорКомпоновкиДанных.Инициализировать(МакетКомпоновки,ВнешниеНаборыДанных,
													   ДанныеРасшифровки);

	//Очищаем поле табличного документа

	//Выводим результат в табличный документ
	ПроцессорВывода = Новый ПроцессорВыводаРезультатаКомпоновкиДанныхВТабличныйДокумент;
	ПроцессорВывода.УстановитьДокумент(ДокументРезультат);

	ПроцессорВывода.Вывести(ПроцессорКомпоновкиДанных);

КонецПроцедуры

