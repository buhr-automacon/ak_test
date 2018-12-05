﻿Функция ПрочитатьЭксель_(СтрокаПутьКФайлу)
	
	ИсходныеДанные = Новый ТаблицаЗначений;
	
	Попытка 
		Эксель = Новый COMОбъект("Excel.Application");
	Исключение       
		//Предупреждение("MS Excel не установлен на компьютере!",10);
		//Сообщить(ОписаниеОшибки());
		ЗаписьЖурналаРегистрации("Геолокация", УровеньЖурналаРегистрации.Ошибка, , , "MS Excel не установлен на компьютере: " + ОписаниеОшибки());
	   	Возврат ИсходныеДанные;                                  
	КонецПопытки;
	Эксель.DisplayAlerts = 0;
	Эксель.Visible = 0;   	
	
	Попытка
		Эксель.Application.Workbooks.Open(СтрокаПутьКФайлу);
		
	Исключение
		//Предупреждение("Не удалось открыть файл "  +  ПутьКФайлу,10);
		Эксель = Неопределено;
		Возврат ИсходныеДанные   		
	КонецПопытки;
	
	СчетчикКолонок = 0;
	КоличествоКолонок = 7;
	
	
	Для Сч= 1 По КоличествоКолонок Цикл
			
		ИсходныеДанные.Колонки.Добавить("Колонка"  +  Строка(Сч))
			
	КонецЦикла; 
	
	НомерСтрокиНачалоТаблицы = 1;
	НомерКолонкиНачалоТаблицы = 1;
	КоличествоСтрок = 1000;
	
	ActiveCell = Эксель.ActiveCell.SpecialCells(11);
	RowCount = ActiveCell.Row;
	
	Для СчетчикСтрок = 0 По RowCount - 1 Цикл
		
		НовСтрока = ИсходныеДанные.Добавить();
		
		Для СчетчикКолонок = 1 По КоличествоКолонок Цикл
			
			 НовСтрока["Колонка"  +  СчетчикКолонок] =  СокрЛП(Эксель.Cells(НомерСтрокиНачалоТаблицы   +  СчетчикСтрок, НомерКолонкиНачалоТаблицы  +  СчетчикКолонок -1).Text)
			 
		 КонецЦикла;
		 
	КонецЦикла;	 
	
	СтрокаСвертки = "";
	
	Для каждого Колонка Из ИсходныеДанные.Колонки Цикл
	
		СтрокаСвертки = СтрокаСвертки  +  Колонка.Имя  +  ",";
	
	КонецЦикла; 
	
	СтрокаСвертки = Лев(СтрокаСвертки, СтрДлина(СтрокаСвертки) - 1);
	
	ИсходныеДанные.Свернуть(СтрокаСвертки);
	
	ПослСтрока = ИсходныеДанные[ИсходныеДанные.Количество() - 1];
	
	УдалятьПослСтроку = Истина;
	
	Для каждого Колонка Из  ИсходныеДанные.Колонки Цикл
	
		Если ЗначениеЗаполнено(СокрЛП(ПослСтрока[Колонка.Имя])) Тогда
			
			УдалятьПослСтроку = Ложь;
			
		КонецЕсли;	
			
	КонецЦикла; 
	
	Если УдалятьПослСтроку Тогда
	
		ИсходныеДанные.Удалить(ИсходныеДанные.Количество() - 1);
	
	КонецЕсли; 
	
	Эксель.Quit();
	Эксель = Неопределено;
	
	Возврат ИсходныеДанные;
		
КонецФункции

Функция ПрочитатьЭксель(Адрес, Расширение)
	
	ИсходныеДанные = Новый ТаблицаЗначений;
	
	
	СтрокаПутьКФайлу = ПолучитьИмяВременногоФайла(Расширение);    
	Файл = ПолучитьИзВременногоХранилища(Адрес);
	Файл.Записать(СтрокаПутьКФайлу);
	
	ТабДок = Новый ТабличныйДокумент;
	Попытка
		ТабДок.Прочитать(СтрокаПутьКФайлу, СпособЧтенияЗначенийТабличногоДокумента.Значение);
	Исключение
		ЗаписьЖурналаРегистрации("Геолокация", УровеньЖурналаРегистрации.Ошибка, , , "Не удалось прочитать Excel: " + ОписаниеОшибки());
		//Сообщить(ОписаниеОшибки());
		Возврат ИсходныеДанные;
	КонецПопытки;
	
	//Попытка 
	//	Эксель = Новый COMОбъект("Excel.Application");
	//Исключение       
	//	//Предупреждение("MS Excel не установлен на компьютере!",10);
	//	Сообщить(ОписаниеОшибки());
	//   	Возврат ИсходныеДанные                                  
	//КонецПопытки;
	//Эксель.DisplayAlerts = 0;
	//Эксель.Visible = 0;   	
	//
	//Попытка
	//	Эксель.Application.Workbooks.Open(СтрокаПутьКФайлу);
	//	
	//Исключение
	//	//Предупреждение("Не удалось открыть файл "  +  ПутьКФайлу,10);
	//	Эксель = Неопределено;
	//	Возврат ИсходныеДанные   		
	//КонецПопытки;
	
	СчетчикКолонок = 0;
	КоличествоКолонок = 7;
	
	
	Для Сч= 1 По КоличествоКолонок Цикл
			
		ИсходныеДанные.Колонки.Добавить("Колонка"  +  Строка(Сч))
			
	КонецЦикла; 
	
	НомерСтрокиНачалоТаблицы = 1;
	НомерКолонкиНачалоТаблицы = 1;
	КоличествоСтрок = 2000;
	
	//ActiveCell = Эксель.ActiveCell.SpecialCells(11);
	//RowCount = ActiveCell.Row;
	//
	//Для СчетчикСтрок = 0 По RowCount - 1 Цикл
	//	
	//	НовСтрока = ИсходныеДанные.Добавить();
	//	
	//	Для СчетчикКолонок = 1 По КоличествоКолонок Цикл
	//		
	//		 НовСтрока["Колонка"  +  СчетчикКолонок] =  СокрЛП(Эксель.Cells(НомерСтрокиНачалоТаблицы   +  СчетчикСтрок, НомерКолонкиНачалоТаблицы  +  СчетчикКолонок -1).Text)
	//		 
	//	 КонецЦикла;
	//	 
	//КонецЦикла;	 
	
	КолСтр = ТабДок.ВысотаТаблицы;
	Для Сч = 2 по КолСтр Цикл
		НовСтрока = ИсходныеДанные.Добавить();
		Для СчетчикКолонок = 1 По КоличествоКолонок Цикл
			
			 НовСтрока["Колонка"  +  СчетчикКолонок] = ТабДок.ПолучитьОбласть("R" + Формат(Сч, "ЧГ=0") + "C" + Формат(СчетчикКолонок, "ЧГ=0")).ТекущаяОбласть.Текст;
			 
		 КонецЦикла;
//		Попытка
//			ТБ = Таб.Добавить();
////Обращаемся к ячейки и забираем данные
//			ТБ.Номенклатура = Строка(ТабДок.ПолучитьОбласть("R" + Формат(Сч, "ЧГ=0") + "C" + 1).ТекущаяОбласть.Текст);		
//			ТБ.Количество = Число(ТабДок.ПолучитьОбласть("R" + Формат(Сч, "ЧГ=0") + "C" + 2).ТекущаяОбласть.Текст);				
//			ТБ.Цена = Число(ТабДок.ПолучитьОбласть("R" + Формат(Сч, "ЧГ=0") + "C" + 3).ТекущаяОбласть.Текст);		
//		Исключение
//			Сообщение = Новый СообщениеПользователю;
//			Сообщение.Текст = "Не удалось загрузить строку "+Строка(Сч);
//			Сообщение.Сообщить();
//		КонецПопытки;
	КонецЦикла;	
	СтрокаСвертки = "";
	
	Для каждого Колонка Из ИсходныеДанные.Колонки Цикл
	
		СтрокаСвертки = СтрокаСвертки  +  Колонка.Имя  +  ",";
	
	КонецЦикла; 
	
	СтрокаСвертки = Лев(СтрокаСвертки, СтрДлина(СтрокаСвертки) - 1);
	
	ИсходныеДанные.Свернуть(СтрокаСвертки);
	
	ПослСтрока = ИсходныеДанные[ИсходныеДанные.Количество() - 1];
	
	УдалятьПослСтроку = Истина;
	
	Для каждого Колонка Из  ИсходныеДанные.Колонки Цикл
	
		Если ЗначениеЗаполнено(СокрЛП(ПослСтрока[Колонка.Имя])) Тогда
			
			УдалятьПослСтроку = Ложь;
			
		КонецЕсли;	
			
	КонецЦикла; 
	
	Если УдалятьПослСтроку Тогда
	
		ИсходныеДанные.Удалить(ИсходныеДанные.Количество() - 1);
	
	КонецЕсли; 
	
	//Эксель.Quit();
	Эксель = Неопределено;
	
	Возврат ИсходныеДанные;
		
КонецФункции



Функция НомерПервойСтроки(ТаблицаПоиска, ЗначениеПоиска)
	СтрокаТаблицы = ТаблицаПоиска.Найти(ЗначениеПоиска);
	Если СтрокаТаблицы = Неопределено Тогда
		Возврат "";
	КонецЕсли;
	
	Возврат ТаблицаПоиска.Индекс(СтрокаТаблицы)  +  1;
	
КонецФункции

Функция СписокАвтомобилей()
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ
		|	Автомобили.Ссылка,
		|	Автомобили.Наименование
		|ИЗ
		|	Справочник.Автомобили КАК Автомобили";
	
	ТабРезультатЗапроса = Запрос.Выполнить().Выгрузить();
	
	Для каждого СтрокаТаб Из ТабРезультатЗапроса Цикл
		СтрокаТаб.Наименование = ВРег(УбратьВсеПробелы(СтрокаТаб.Наименование));
	КонецЦикла; 	 
	
	Возврат ТабРезультатЗапроса;
	
КонецФункции
 

Функция УбратьВсеПробелы(ИсходнаяСтрока)
	// " " - это не пробел !!! - а НеразрывныйПробел
	Возврат СтрЗаменить(СтрЗаменить(СтрЗаменить(ИсходнаяСтрока, " ", ""), " ", ""), " ", "");
КонецФункции    

Функция ОпределитьНомерМашиныМаршрут(ИсходнаяСтрока)
	
	НомерМашины = "";
	Маршрут = "";
	Позиция = Найти(ИсходнаяСтрока, " ");
	Если Позиция > 0 Тогда
		НомерМашины = ВРег(Лев(ИсходнаяСтрока, Позиция - 1));
		Маршрут = Сред(ИсходнаяСтрока, Позиция  +  1);
	Иначе
		НомерМашины = ИсходнаяСтрока;
	КонецЕсли; 
	
	Возврат Новый Структура("НомерМашины, Маршрут", НомерМашины, Маршрут);
		
КонецФункции

Функция ОпределитьНомерМашиныМаршрут2(ИсходнаяСтрока)
	
	НомерМашины = "";
	Маршрут = "";
	Позиция = Найти(ИсходнаяСтрока, " ");
	Если Позиция > 0 Тогда
		Маршрут = Лев(ИсходнаяСтрока, Позиция - 1);
		
		ТекСтр = Сред(ИсходнаяСтрока, Позиция + 1);
		ПозицияАвто1 = Найти(ТекСтр, " ");
		ПозицияАвто2 = Найти(ТекСтр, "(");
		Если ПозицияАвто1 = 0 Тогда
			ПозицияАвто1 = ПозицияАвто2;
		КонецЕсли; 
		Если ПозицияАвто2 = 0 Тогда
			ПозицияАвто2 = ПозицияАвто1;
		КонецЕсли; 
		ПозицияАвто = Мин(ПозицияАвто1, ПозицияАвто2);
		Если ПозицияАвто > 0 Тогда
			НомерМашины = ВРег(Лев(ТекСтр, ПозицияАвто - 1));
		КонецЕсли;
		
	Иначе
		// Формат не распознан
	КонецЕсли; 
	
	Возврат Новый Структура("НомерМашины, Маршрут", НомерМашины, Маршрут);
		
КонецФункции

Функция НайтиСкладПоРейсу(СтруктураПоиска)
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ ПЕРВЫЕ 1
		|	МаршрутныйЛист.СтруктурноеПодразделение
		|ИЗ
		|	Документ.МаршрутныйЛист КАК МаршрутныйЛист
		|ГДЕ
		|	НАЧАЛОПЕРИОДА(МаршрутныйЛист.Дата, ДЕНЬ) = НАЧАЛОПЕРИОДА(&Дата, ДЕНЬ)
		//|	И МаршрутныйЛист.Автомобиль = &Автомобиль
		|	И МаршрутныйЛист.Маршрут = &Маршрут";
	
	//Запрос.УстановитьПараметр("Автомобиль", СтруктураПоиска.Автомобиль);
	Запрос.УстановитьПараметр("Маршрут", СтруктураПоиска.Маршрут);
	Запрос.УстановитьПараметр("Дата", СтруктураПоиска.ДатаДокумента);
	
	РезультатЗапроса = Запрос.Выполнить();
	
	ВыборкаДетальныеЗаписи = РезультатЗапроса.Выбрать();
	
	Если ВыборкаДетальныеЗаписи.Следующий() Тогда
		Возврат	ВыборкаДетальныеЗаписи.СтруктурноеПодразделение;
	Иначе
		Возврат Справочники.СтруктурныеЕдиницы.ПустаяСсылка();
	КонецЕсли;
	
КонецФункции
 

Функция НайтиТТ(ИсходнаяСтрока, ДопСтруктураПоиска)
	ЭтоСклад = Ложь;
	Если Лев(ИсходнаяСтрока, 5) = "СКЛАД" ИЛИ Лев(ИсходнаяСтрока, 1) = "t" Тогда
		ЭтоСклад = Истина;
		Возврат НайтиСкладПоРейсу(ДопСтруктураПоиска);
	Иначе
		НомерТочки = "";
		// Номер точки - это первые 2, 3 или 4 символа
		Если НЕ СтрДлина(ИсходнаяСтрока) = 0 Тогда
			КодСивола4 = КодСимвола(Сред(ИсходнаяСтрока, 4, 1)); 
			Попытка
				Если КодСивола4 >= 48 И КодСивола4 <= 57 Тогда
					НомерТочки = Число(Лев(ИсходнаяСтрока, 4));
				Иначе
					КодСивола3 = КодСимвола(Сред(ИсходнаяСтрока, 3, 1)); 
					Если КодСивола3 >= 48 И КодСивола3 <= 57 Тогда
						НомерТочки = Число(Лев(ИсходнаяСтрока, 3));
					Иначе
						НомерТочки = Число(Лев(ИсходнаяСтрока, 2));
					КонецЕсли; 
				КонецЕсли; 
			Исключение
			    //Сообщить("Не найдена по номеру точки: " + ИсходнаяСтрока);
				ЗаписьЖурналаРегистрации("Геолокация", УровеньЖурналаРегистрации.Ошибка, , , "Не найдена по номеру точки: " + ИсходнаяСтрока);
			КонецПопытки; 
		КонецЕсли; 

		Если НомерТочки = "" Тогда
			Возврат Справочники.СтруктурныеЕдиницы.ПустаяСсылка();
		КонецЕсли; 
		
		Возврат Справочники.СтруктурныеЕдиницы.НайтиПоРеквизиту("НомерТочки", НомерТочки);
		
	КонецЕсли; 
КонецФункции

Функция ДатаИзСтроки(ИсходнаяСтрока)
	Если ИсходнаяСтрока = "-" Тогда
		Возврат Дата(1, 1, 1, 0, 0, 0);
	КонецЕсли; 	
	
	ДлинаСтроки = СтрДлина(ИсходнаяСтрока);
	
	Если СтрДлина(ИсходнаяСтрока) = 19 Тогда
		День 	= Лев(ИсходнаяСтрока, 2);
		Месяц 	= Сред(ИсходнаяСтрока, 4, 2);
		Год 	= Сред(ИсходнаяСтрока, 7, 4);
		Час 	= Сред(ИсходнаяСтрока, 12, 2);
		Минута	= Сред(ИсходнаяСтрока, 15, 2);
		Секунда	= Прав(ИсходнаяСтрока, 2);
		
		Возврат Дата(Год + Месяц + День + Час + Минута + Секунда);
		
	Иначе
		Возврат Дата(1, 1, 1, 0, 0, 0);
	КонецЕсли; 
	
КонецФункции

Функция ДлительностьИзСтроки(ИсходнаяСтрока)
	
	ДлинаСтроки = СтрДлина(ИсходнаяСтрока);
	Если ДлинаСтроки <= 6 Тогда
		Возврат 0;
	КонецЕсли; 
	Час 	= Число(Лев(ИсходнаяСтрока, ДлинаСтроки - 6));
	Минута 	= Число(Сред(ИсходнаяСтрока, ДлинаСтроки - 4, 2));
	Секунда = Число(Прав(ИсходнаяСтрока, 2));
	Возврат 60*60*Час + 60*Минута + Секунда;
		
КонецФункции

Функция НайтиМаршрутПоАвтомобилю(Автомобиль, ДатаВыхода)
	
	Если Не ЗначениеЗаполнено(ДатаВыхода) Тогда
		ДатаВыхода = ТекущаяДата();
	КонецЕсли; 
	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ ПЕРВЫЕ 1
		|	ВодителиПоМаршрутуСрезПоследних.Маршрут
		|ИЗ
		|	РегистрСведений.ВодителиПоМаршруту.СрезПоследних(&ДатаСреза, Автомобиль = &Автомобиль) КАК ВодителиПоМаршрутуСрезПоследних
		|
		|УПОРЯДОЧИТЬ ПО
		|	ВодителиПоМаршрутуСрезПоследних.Период УБЫВ";
	
	Запрос.УстановитьПараметр("Автомобиль", Автомобиль);
	Запрос.УстановитьПараметр("ДатаСреза", КонецДня(ДатаВыхода));
	
	РезультатЗапроса = Запрос.Выполнить();
	
	ВыборкаДетальныеЗаписи = РезультатЗапроса.Выбрать();
	
	Если ВыборкаДетальныеЗаписи.Следующий() Тогда
		Возврат ВыборкаДетальныеЗаписи.Маршрут;
	Иначе
		Возврат Справочники.Маршруты.ПустаяСсылка();
	КонецЕсли;
	
КонецФункции

Функция НайтиМаршрутПоПолномуНаименованию(Наименование)

	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ
		|	Маршруты.Ссылка
		|ИЗ
		|	Справочник.Маршруты КАК Маршруты
		|ГДЕ
		|	Маршруты.ПолноеНаименование = &Наименование";
	
	Запрос.УстановитьПараметр("Наименование", Наименование);
	
	РезультатЗапроса = Запрос.Выполнить();
	
	ВыборкаДетальныеЗаписи = РезультатЗапроса.Выбрать();
	
	Если ВыборкаДетальныеЗаписи.Следующий() Тогда
		Возврат ВыборкаДетальныеЗаписи.Ссылка;
	Иначе
		Возврат Справочники.Маршруты.ПустаяСсылка();
	КонецЕсли;	
	
КонецФункции
 
 

Функция ОпределитьДатыВходаВыхода(ДопСтруктура)
	СтрокаДатаВхода	= ДопСтруктура.ДатаВхода;
	СтрокаДатаВыхода= ДопСтруктура.ДатаВыхода;
	
	Если СтрокаДатаВхода = "-" И НЕ СтрокаДатаВыхода = "-" Тогда
		ДатаВыхода = ДатаИзСтроки(СтрокаДатаВыхода);
		Возврат Новый Структура("ДатаВхода, ДатаВыхода", 
								 ДатаВыхода - ДлительностьИзСтроки(ДопСтруктура.Длительность), 
								 ДатаВыхода);
	ИначеЕсли НЕ СтрокаДатаВхода = "-" И СтрокаДатаВыхода = "-" Тогда
		ДатаВхода = ДатаИзСтроки(СтрокаДатаВхода);
		Возврат Новый Структура("ДатаВхода, ДатаВыхода", 
								 ДатаВхода, 
								 ДатаВхода + ДлительностьИзСтроки(ДопСтруктура.Длительность));
	ИначеЕсли НЕ СтрокаДатаВхода = "-" И НЕ СтрокаДатаВыхода = "-" Тогда
		Возврат Новый Структура("ДатаВхода, ДатаВыхода", 
								 ДатаИзСтроки(СтрокаДатаВхода), 
								 ДатаИзСтроки(СтрокаДатаВыхода));
	Иначе
		Возврат Новый Структура("ДатаВхода, ДатаВыхода", 
								 Дата(1, 1, 1), Дата(1, 1, 1));
	КонецЕсли; 
	
КонецФункции
 
Процедура ПрочитатьДанныеИзФайла(СтрокаПутьКФайлу, Расширение) Экспорт
	Если Не ЗначениеЗаполнено(СтрокаПутьКФайлу) Тогда
		//Сообщить("Файл не выбран");
		Возврат;		
	КонецЕсли; 	
	
	ИндексТС = 0;
	ИндексТТ = 1;
	ИндексДатаВхода = 2;
	ИндексДатаВыхода = 3;
	ИндексДлительность = 4;
	
	ТабличнаяЧастьОбработки.Очистить();
	
	ИсходныеДанные = ПрочитатьЭксель(СтрокаПутьКФайлу, Расширение);
	КоличествоСтрок = ИсходныеДанные.Количество();
	Если КоличествоСтрок = 0 Тогда
		Возврат;
	КонецЕсли; 
	
	НачалоДанных = НомерПервойСтроки(ИсходныеДанные, "Т/С");
	Если НачалоДанных = "" Тогда
		Возврат;
	КонецЕсли; 
	
	// Т.к. номера авто забиты с пробелами - сформируем список Авто для поиска
	ТабАвтомобили = СписокАвтомобилей();	
	
	Для Сч = НачалоДанных По КоличествоСтрок - 1 Цикл
		
		ДопСтруктура = Новый Структура("ДатаВхода, ДатаВыхода", 
										ИсходныеДанные [Сч][ИндексДатаВхода], 
										ИсходныеДанные [Сч][ИндексДатаВыхода]);
		Если ДопСтруктура.ДатаВхода = "-"
		   И ДопСтруктура.ДатаВыхода = "-" Тогда  // Итоговая строка - не загружаем
			Продолжить;
		КонецЕсли; 
		
		ДопСтруктура.Вставить("Длительность", ИсходныеДанные [Сч][ИндексДлительность]);
		СтруктураДатыВходаВыхода = ОпределитьДатыВходаВыхода(ДопСтруктура);
		
		СтруктураНомерМашиныМаршрут = ОпределитьНомерМашиныМаршрут(ИсходныеДанные [Сч][ИндексТС]);
		
		НоваяСтрока = ТабличнаяЧастьОбработки.Добавить();
		//НоваяСтрока.Пометка 	= Истина;
		Автомобиль = ТабАвтомобили.Найти(СтруктураНомерМашиныМаршрут.НомерМашины, "Наименование");
		//Автомобиль = ТабАвтомобили.Найти(ИсходныеДанные [Сч][ИндексТС], "Наименование");
		Если Автомобиль = Неопределено Тогда
			// По-пробуем найти номер машины и маршрут по второму варианту
			СтруктураНомерМашиныМаршрут = ОпределитьНомерМашиныМаршрут2(ИсходныеДанные [Сч][ИндексТС]);
			Автомобиль = ТабАвтомобили.Найти(СтруктураНомерМашиныМаршрут.НомерМашины, "Наименование");
			Если Автомобиль = Неопределено Тогда				
				Автомобиль = Справочники.Автомобили.ПустаяСсылка();	
				ЗаписьЖурналаРегистрации("Геолокация", УровеньЖурналаРегистрации.Ошибка, , , "Не найден автомобиль г/н " + СтруктураНомерМашиныМаршрут.НомерМашины);
			КонецЕсли; 
		Иначе
		//	ййй = 1;

		КонецЕсли; 
		
		НоваяСтрока.Автомобиль = Автомобиль.Ссылка;	
		
		Если ЗначениеЗаполнено(СтруктураНомерМашиныМаршрут.Маршрут) Тогда
			НоваяСтрока.Маршрут 	= Справочники.Маршруты.НайтиПоНаименованию(СтруктураНомерМашиныМаршрут.Маршрут);
			Если Не ЗначениеЗаполнено(НоваяСтрока.Маршрут) Тогда
				НоваяСтрока.Маршрут = НайтиМаршрутПоПолномуНаименованию(СтруктураНомерМашиныМаршрут.Маршрут);
				Если Не ЗначениеЗаполнено(НоваяСтрока.Маршрут) Тогда
					ЗаписьЖурналаРегистрации("Геолокация", УровеньЖурналаРегистрации.Ошибка, , , "Не найден маршрут " + СтруктураНомерМашиныМаршрут.Маршрут);
				КонецЕсли; 
			КонецЕсли; 
		КонецЕсли; 
		
		Если Не ЗначениеЗаполнено(НоваяСтрока.Маршрут) И ЗначениеЗаполнено(Автомобиль.Ссылка) Тогда
			Если ТипЗнч(Автомобиль.Ссылка) = Тип("СправочникСсылка.Автомобили") Тогда
				НоваяСтрока.Маршрут = НайтиМаршрутПоАвтомобилю(Автомобиль.Ссылка, СтруктураДатыВходаВыхода.ДатаВхода);
				Если Не ЗначениеЗаполнено(НоваяСтрока.Маршрут) Тогда
					ЗаписьЖурналаРегистрации("Геолокация", УровеньЖурналаРегистрации.Ошибка, , , "Не найден маршрут по автомобилю г/н " + СтруктураНомерМашиныМаршрут.НомерМашины);
				КонецЕсли; 
			КонецЕсли; 
		КонецЕсли; 
		
		
		НоваяСтрока.ДатаВхода 	= СтруктураДатыВходаВыхода.ДатаВхода;
		НоваяСтрока.ДатаВыхода 	= СтруктураДатыВходаВыхода.ДатаВыхода;
		
		ДопСтруктураПоиска = Новый Структура("Автомобиль, Маршрут, ДатаДокумента", Автомобиль.Ссылка, НоваяСтрока.Маршрут, СтруктураДатыВходаВыхода.ДатаВхода);

		НоваяСтрока.Точка 		= НайтиТТ(ИсходныеДанные [Сч][ИндексТТ], ДопСтруктураПоиска);
		
		НоваяСтрока.Пометка 	= ЗначениеЗаполнено(НоваяСтрока.Автомобиль) И ЗначениеЗаполнено(НоваяСтрока.Маршрут); 
		
	КонецЦикла;  	
	
	
КонецПроцедуры

Функция ПолучитьФайлыИзПочты()
	СписокФайловДляЗагрузки = Новый СписокЗначений;
	
	УчетнаяЗапись = Справочники.УчетныеЗаписиЭлектроннойПочты.НайтиПоНаименованию("inbox@vkusvill.ru");
	Если ЗначениеЗаполнено(УчетнаяЗапись) Тогда
		Профиль = УправлениеЭлектроннойПочтой.ПолучитьИнтернетПочтовыйПрофиль(УчетнаяЗапись);
		
		Профиль.ИспользоватьSSLPOP3	= Истина;
		Профиль.ИспользоватьSSLSMTP	= Истина;
		
		//Профиль.Пользователь = "inbox";
	//Профиль.ПользовательSMTP = "inbox";

		ИнтернетПочта = Новый ИнтернетПочта;
		
		Попытка
			ИнтернетПочта.Подключиться(Профиль);
		Исключение
			ЗаписьЖурналаРегистрации("Геолокация", УровеньЖурналаРегистрации.Ошибка, , , "Не удалось подключиться: " + ОписаниеОшибки());
			//Сообщить(ОписаниеОшибки());
			Возврат СписокФайловДляЗагрузки;
		КонецПопытки;
		
		Заголовки = ИнтернетПочта.ПолучитьЗаголовки();
		МассивПисем = ИнтернетПочта.Выбрать(Истина, Заголовки);
		
		Для каждого ИнтернетПисьмо Из МассивПисем Цикл
			Для каждого Вложение Из ИнтернетПисьмо.Вложения Цикл
				Если Вложение.Данные = Неопределено Тогда
					Продолжить;
				КонецЕсли;
				ИмяФайла = Вложение.ИмяФайла;
				Если Найти(ИмяФайла, ".xls") > 0 Тогда
					ВременныйПутьКФайлу = КаталогВременныхФайлов() + ИмяФайла;
					ДанныеФайла = Вложение.Данные;
					ДанныеФайла.Записать(ВременныйПутьКФайлу);  				
					
					Расширение = ?(Прав(ИмяФайла, 4) = "xlsx", "xlsx", "xls");
					СписокФайловДляЗагрузки.Добавить(ПоместитьВоВременноеХранилище(ДанныеФайла), Расширение);
				КонецЕсли; 
			КонецЦикла;
		КонецЦикла;
		
		ИнтернетПочта.Отключиться();

		
	КонецЕсли; 
	
	Возврат СписокФайловДляЗагрузки;
КонецФункции
 

Процедура Загрузить() Экспорт
	
	СписокФайловДляЗагрузки = ПолучитьФайлыИзПочты();
	
	Для каждого ФайлДляЗагрузки Из СписокФайловДляЗагрузки Цикл
		
//		Если ТабличнаяЧастьОбработки.Количество() = 0 Тогда
			ПрочитатьДанныеИзФайла(ФайлДляЗагрузки.Значение, ФайлДляЗагрузки.Представление);
//		КонецЕсли; 
		Отбор = Новый Структура("Пометка", Истина);
		МассивОтбора = ТабличнаяЧастьОбработки.НайтиСтроки(Отбор);
		Для каждого СтрокаТаб Из МассивОтбора Цикл
			НоваяЗапись = РегистрыСведений.ДвижениеАвтомобиляПоМаршруту.СоздатьМенеджерЗаписи();
			ЗаполнитьЗначенияСвойств(НоваяЗапись, СтрокаТаб);
			Если ЗначениеЗаполнено(НоваяЗапись.ДатаВыхода) Тогда
				НоваяЗапись.Период = НоваяЗапись.ДатаВыхода;
			Иначе 
				НоваяЗапись.Период = ТекущаяДата();
			КонецЕсли; 
			НоваяЗапись.Записать(Истина);
		КонецЦикла; 
	КонецЦикла; 
	
КонецПроцедуры
