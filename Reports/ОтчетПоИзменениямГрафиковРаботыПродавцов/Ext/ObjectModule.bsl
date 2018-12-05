﻿
Процедура ПриКомпоновкеРезультата(ДокументРезультат, ДанныеРасшифровки, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	МассивДат = Новый Массив;
	
	НачалоПериода = Дата(1,1,1);
	КонецПериода  = Дата(1,1,1);
	
	ДатаВыходаПродавцаНаТочку 	= Дата(1,1,1);
	КоличествоДней 				= 0;
	
	Для Каждого ПользПоле Из КомпоновщикНастроек.ПользовательскиеНастройки.Элементы Цикл
		Если ТипЗнч(ПользПоле) = Тип("ЗначениеПараметраНастроекКомпоновкиДанных")
			И Строка(ПользПоле.Параметр) = "Период" Тогда
			
			НачалоПериода = ПользПоле.Значение.ДатаНачала;
			КонецПериода  = ПользПоле.Значение.ДатаОкончания;
			
		ИначеЕсли ТипЗнч(ПользПоле) = Тип("ЗначениеПараметраНастроекКомпоновкиДанных")
			И Строка(ПользПоле.Параметр) = "КоличествоДней" Тогда
				
			КоличествоДней = ПользПоле.Значение;
			
		КонецЕсли;	
	КонецЦикла;
	
	Если Не ЗначениеЗаполнено(НачалоПериода)Тогда
		Сообщить("Не заполнена начальная дата для формирования отчета!");
		Возврат;
	КонецЕсли;
	
	//Если КоличествоДней = 0 Тогда
	//	Сообщить("Не указано количество дней для обработки данных!");
	//	Возврат;
	//КонецЕсли;
	
	// Если не выбран конец периода
	МаксСЧ = 100;
	СЧ = 1;
	Пока НачалоДня(НачалоПериода) <= НачалоДня(КонецПериода) И СЧ <= МаксСЧ Цикл
		МассивДат.Добавить(НачалоДня(НачалоПериода));
		НачалоПериода = НачалоПериода + 86400;
		СЧ = СЧ + 1;
	КонецЦикла;
	
	ТаблицаДанных = Новый ТаблицаЗначений;
	ТаблицаДанных.Колонки.Добавить("Группа", 	 		Новый ОписаниеТипов("СправочникСсылка.СтруктурныеЕдиницы"));
	ТаблицаДанных.Колонки.Добавить("Дата", 		 		Новый ОписаниеТипов("Дата"));
	ТаблицаДанных.Колонки.Добавить("Количество", 		Новый ОписаниеТипов("Число"));
	ТаблицаДанных.Колонки.Добавить("ВсегоИзменений",	Новый ОписаниеТипов("Число"));
	
	ТаблицаДанныхПоВсемИзменениям = Новый ТаблицаЗначений;
	ТаблицаДанныхПоВсемИзменениям.Колонки.Добавить("Группа", 	 Новый ОписаниеТипов("СправочникСсылка.СтруктурныеЕдиницы"));
	ТаблицаДанныхПоВсемИзменениям.Колонки.Добавить("Дата", 		 Новый ОписаниеТипов("Дата"));
	ТаблицаДанныхПоВсемИзменениям.Колонки.Добавить("Количество", Новый ОписаниеТипов("Число"));
	
	Для Каждого ДатаВыходаПродавцаНаТочку Из МассивДат Цикл
		
		Запрос = Новый Запрос(
		"ВЫБРАТЬ
		|	ЕСТЬNULL(ТаблицаНачальныхДанных.Сотрудник, ИзмененияВПериоде.Сотрудник) КАК Сотрудник,
		|	ЕСТЬNULL(ТаблицаНачальныхДанных.Дата, &Период) КАК Дата,
		|	ЕСТЬNULL(ТаблицаНачальныхДанных.Группа, ЗНАЧЕНИЕ(Справочник.СтруктурныеЕдиницы.ПустаяСсылка)) КАК Группа,
		|	ЕСТЬNULL(ТаблицаНачальныхДанных.ТорговаяТочка, ЗНАЧЕНИЕ(Справочник.СтруктурныеЕдиницы.ПустаяСсылка)) КАК ТорговаяТочка,
		|	ДАТАВРЕМЯ(1, 1, 1) КАК ДатаИзменения,
		|	ВЫБОР
		|		КОГДА ЕСТЬNULL(ТаблицаНачальныхДанных.ТорговаяТочка, ЗНАЧЕНИЕ(Справочник.СтруктурныеЕдиницы.ПустаяСсылка)) = ЗНАЧЕНИЕ(Справочник.СтруктурныеЕдиницы.ПустаяСсылка)
		|				ИЛИ ЕСТЬNULL(ТаблицаНачальныхДанных.Отсутствие, ЗНАЧЕНИЕ(Перечисление.ВидыОтсутствия.ПустаяСсылка)) <> ЗНАЧЕНИЕ(Перечисление.ВидыОтсутствия.ПустаяСсылка)
		|			ТОГДА ИСТИНА
		|		ИНАЧЕ ЛОЖЬ
		|	КОНЕЦ КАК ПризнакОтсутствия,
		|	ЕСТЬNULL(ТаблицаНачальныхДанных.Отсутствие, ЗНАЧЕНИЕ(Перечисление.ВидыОтсутствия.ПустаяСсылка)) КАК Отсутствие,
		|	ЕСТЬNULL(ТаблицаНачальныхДанных.СвойствоПродавца, 0) КАК СвойствоПродавца,
		|	0 КАК Количество,
		|	ЗНАЧЕНИЕ(Справочник.Пользователи.ПустаяСсылка) КАК Пользователь
		|ИЗ
		|	(ВЫБРАТЬ
		|		ЖурналТабельРаботыПродавцов.Сотрудник КАК Сотрудник,
		|		ЖурналТабельРаботыПродавцов.Дата КАК Дата,
		|		ЖурналТабельРаботыПродавцов.Группа КАК Группа,
		|		ЖурналТабельРаботыПродавцов.ТорговаяТочка КАК ТорговаяТочка,
		|		ЖурналТабельРаботыПродавцов.ДатаИзменения КАК ДатаИзменения,
		|		ЖурналТабельРаботыПродавцов.Пользователь КАК Пользователь,
		|		ЖурналТабельРаботыПродавцов.Отсутствие КАК Отсутствие,
		|		ЖурналТабельРаботыПродавцов.СвойствоПродавца КАК СвойствоПродавца
		|	ИЗ
		|		(ВЫБРАТЬ
		|			ЖурналТабельРаботыПродавцов.Сотрудник КАК Сотрудник,
		|			МАКСИМУМ(ЖурналТабельРаботыПродавцов.ДатаИзменения) КАК ДатаИзменения
		|		ИЗ
		|			РегистрСведений.ЖурналТабельРаботыПродавцов КАК ЖурналТабельРаботыПродавцов
		|		ГДЕ
		|			ЖурналТабельРаботыПродавцов.Дата = &Период
		|			И ЖурналТабельРаботыПродавцов.ДатаИзменения < &ДатаНачала
		|		
		|		СГРУППИРОВАТЬ ПО
		|			ЖурналТабельРаботыПродавцов.Сотрудник) КАК НачальныеЗначения
		|			ВНУТРЕННЕЕ СОЕДИНЕНИЕ РегистрСведений.ЖурналТабельРаботыПродавцов КАК ЖурналТабельРаботыПродавцов
		|			ПО НачальныеЗначения.Сотрудник = ЖурналТабельРаботыПродавцов.Сотрудник
		|				И НачальныеЗначения.ДатаИзменения = ЖурналТабельРаботыПродавцов.ДатаИзменения
		|	ГДЕ
		|		ЖурналТабельРаботыПродавцов.Дата = &Период) КАК ТаблицаНачальныхДанных
		|		ПОЛНОЕ СОЕДИНЕНИЕ (ВЫБРАТЬ РАЗЛИЧНЫЕ
		|			ЖурналТабельРаботыПродавцов.Сотрудник КАК Сотрудник
		|		ИЗ
		|			РегистрСведений.ЖурналТабельРаботыПродавцов КАК ЖурналТабельРаботыПродавцов
		|		ГДЕ
		|			ЖурналТабельРаботыПродавцов.Дата = &Период
		|			И ЖурналТабельРаботыПродавцов.ДатаИзменения >= &ДатаНачала) КАК ИзмененияВПериоде
		|		ПО ТаблицаНачальныхДанных.Сотрудник = ИзмененияВПериоде.Сотрудник
		|
		|УПОРЯДОЧИТЬ ПО
		|	Сотрудник
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	ЖурналТабельРаботыПродавцов.Группа,
		|	ЖурналТабельРаботыПродавцов.Сотрудник КАК Сотрудник,
		|	ЖурналТабельРаботыПродавцов.ТорговаяТочка,
		|	ЖурналТабельРаботыПродавцов.Дата КАК Дата,
		|	ЖурналТабельРаботыПродавцов.ДатаИзменения КАК ДатаИзменения,
		|	ЖурналТабельРаботыПродавцов.Пользователь,
		|	ЖурналТабельРаботыПродавцов.Отсутствие,
		|	ВЫБОР
		|		КОГДА ЖурналТабельРаботыПродавцов.ТорговаяТочка = ЗНАЧЕНИЕ(Справочник.СтруктурныеЕдиницы.ПустаяСсылка)
		|				ИЛИ ЖурналТабельРаботыПродавцов.Отсутствие <> ЗНАЧЕНИЕ(Перечисление.ВидыОтсутствия.ПустаяСсылка)
		|			ТОГДА ИСТИНА
		|		ИНАЧЕ ЛОЖЬ
		|	КОНЕЦ КАК ПризнакОтсутствия,
		|	ЖурналТабельРаботыПродавцов.СвойствоПродавца,
		|	1 КАК Количество
		|ИЗ
		|	РегистрСведений.ЖурналТабельРаботыПродавцов КАК ЖурналТабельРаботыПродавцов
		|ГДЕ
		|	ЖурналТабельРаботыПродавцов.ДатаИзменения >= &ДатаНачала
		|	И ЖурналТабельРаботыПродавцов.Дата = &Период
		|
		|УПОРЯДОЧИТЬ ПО
		|	Сотрудник,
		|	Дата,
		|	ДатаИзменения");
		
		Запрос.УстановитьПараметр("Период", 		ДатаВыходаПродавцаНаТочку);
		Запрос.УстановитьПараметр("ДатаНачала", 	КонецДня(ДатаВыходаПродавцаНаТочку - 86400*КоличествоДней));
		
		Результат = Запрос.ВыполнитьПакет();
		ТаблицаНачальныхДанных 	= Результат[0].Выгрузить();
		ТаблицаИзменений 		= Результат[1].Выгрузить();
		
		// Выходы на ТТ {
		ЗапросПоВыходам = Новый Запрос(
		"ВЫБРАТЬ
		|	ТабельРаботыПродавцов.Период КАК Дата,
		|	ТабельРаботыПродавцов.Группа,
		|	1 КАК Количество
		|ИЗ
		|	РегистрСведений.ТабельРаботыПродавцов КАК ТабельРаботыПродавцов
		|ГДЕ
		|	ТабельРаботыПродавцов.Период = &Период
		|	И ТабельРаботыПродавцов.ТорговаяТочка <> ЗНАЧЕНИЕ(Справочник.СтруктурныеЕдиницы.ПустаяСсылка)");
		
		ЗапросПоВыходам.УстановитьПараметр("Период", ДатаВыходаПродавцаНаТочку);
		ТаблицаВсехВыходов = ЗапросПоВыходам.Выполнить().Выгрузить();
		
		Для Каждого Стр Из ТаблицаВсехВыходов Цикл
			ЗаполнитьЗначенияСвойств(ТаблицаДанныхПоВсемИзменениям.Добавить(), Стр);
		КонецЦикла;
		// }Выходы на ТТ
		
		ИндексКолонки = ТаблицаНачальныхДанных.Колонки.Индекс(ТаблицаНачальныхДанных.Колонки.ДатаИзменения);
		ТаблицаНачальныхДанных.Колонки.Удалить(ИндексКолонки);
		
		ПараметрыДаты = Новый КвалификаторыДаты(ЧастиДаты.ДатаВремя);
		ТаблицаНачальныхДанных.Колонки.Добавить("ДатаИзменения", Новый ОписаниеТипов("Дата",,, ПараметрыДаты));
		
		СтруктураПоиска = Новый Структура;
		СтруктураПоиска.Вставить("Сотрудник");
		СтруктураПоиска.Вставить("Дата");
		
		СтруктураПолей = Новый Структура;
		СтруктураПолей.Вставить("Сотрудник");
		СтруктураПолей.Вставить("Дата");
		//СтруктураПолей.Вставить("СвойствоПродавца");
		СтруктураПолей.Вставить("ТорговаяТочка");
		СтруктураПолей.Вставить("ПризнакОтсутствия");
		
		МассивСтрокДляУдаления = Новый Массив;
		
		Для Каждого Стр Из ТаблицаНачальныхДанных Цикл
			
			//Если Стр.Сотрудник.Код = "0000001216" И Стр.Дата = '20140610'Тогда
			//	Сообщить("1212");
			//КонецЕсли;
			
			ЗаполнитьЗначенияСвойств(СтруктураПоиска, Стр);
			НайденныеСтроки = ТаблицаИзменений.НайтиСтроки(СтруктураПоиска);
			
			КоличествоСтрок = НайденныеСтроки.Количество();
			
			//НачальноеЗначение = Новый Структура("Сотрудник, Дата, СвойствоПродавца, ТорговаяТочка, ПризнакОтсутствия");
			НачальноеЗначение = Новый Структура("Сотрудник, Дата, ТорговаяТочка, ПризнакОтсутствия");
			ЗаполнитьЗначенияСвойств(НачальноеЗначение, Стр);
			
			ПервыйПоиск = Истина;
			//ПредыдущееЗначение = Новый Структура("Сотрудник, Дата, СвойствоПродавца, ТорговаяТочка, ПризнакОтсутствия");
			ПредыдущееЗначение = Новый Структура("Сотрудник, Дата, ТорговаяТочка, ПризнакОтсутствия");
			
			СчетчикСтрок = 0;
			
			Для Каждого НайденнаяСтрока Из НайденныеСтроки Цикл
				
				СчетчикСтрок = СчетчикСтрок + 1;
				
				Если НачалоДня(НайденнаяСтрока.ДатаИзменения)>= ДатаВыходаПродавцаНаТочку Тогда
					
					Если СчетчикСтрок = КоличествоСтрок Тогда
						СтрокаИзменение = НайденныеСтроки[КоличествоСтрок-1];
					Иначе
						ТаблицаИзменений.Удалить(НайденнаяСтрока);
						Продолжить;
					КонецЕсли;
					
				Иначе	
					СтрокаИзменение = НайденнаяСтрока;
				КонецЕсли;
				
				//ТекущееЗначение = Новый Структура("Сотрудник, Дата, СвойствоПродавца, ТорговаяТочка, ПризнакОтсутствия");
				ТекущееЗначение = Новый Структура("Сотрудник, Дата, ТорговаяТочка, ПризнакОтсутствия");
				ЗаполнитьЗначенияСвойств(ТекущееЗначение, СтрокаИзменение);
				
				Если ПервыйПоиск Тогда
					
					Если СравнениеСтруктур(НачальноеЗначение, ТекущееЗначение)Тогда
						//Начальные данные
						ЗаполнитьЗначенияСвойств(ТаблицаДанных.Добавить(), Стр);
						
						//Изменение
						ЗаполнитьЗначенияСвойств(ТаблицаДанных.Добавить(), СтрокаИзменение);
					КонецЕсли;
					
					ПервыйПоиск = Ложь;
					
				Иначе
					
					Если СравнениеСтруктур(ПредыдущееЗначение, ТекущееЗначение)Тогда
						ЗаполнитьЗначенияСвойств(ТаблицаДанных.Добавить(), СтрокаИзменение);
					КонецЕсли;
					
				КонецЕсли;
				
				ПредыдущееЗначение = ТекущееЗначение;
				ТаблицаИзменений.Удалить(НайденнаяСтрока);
				
			КонецЦикла;
			
		КонецЦикла;
		
		// Если остались строки
		
		ТЗ_ОстатокИзменений = ТаблицаИзменений.Скопировать(, "Сотрудник, Группа, Дата");
		ТЗ_ОстатокИзменений.Сортировать("Сотрудник, Дата");
		
		ТаблицаИзменений.Сортировать("Сотрудник, Дата, ДатаИзменения");
		
		Для Каждого Стр Из ТЗ_ОстатокИзменений Цикл
			
			//Если Стр.Сотрудник.Код = "0000000676" Тогда
			//	Сообщить("1212");
			//КонецЕсли;
			
			//НачальноеЗначение = Новый Структура("Сотрудник, Дата, СвойствоПродавца, ТорговаяТочка, ПризнакОтсутствия");
			НачальноеЗначение = Новый Структура("Сотрудник, Дата, ТорговаяТочка, ПризнакОтсутствия");
			ЗаполнитьЗначенияСвойств(НачальноеЗначение, Стр);
			НачальноеЗначение.ПризнакОтсутствия = Истина;
			//НачальноеЗначение.СвойствоПродавца = 0;
			НачальноеЗначение.ТорговаяТочка = Справочники.СтруктурныеЕдиницы.ПустаяСсылка();
			
			ПервыйПоиск = Истина;
			//ПредыдущееЗначение = Новый Структура("Сотрудник, Дата, СвойствоПродавца, ТорговаяТочка, ПризнакОтсутствия");
			ПредыдущееЗначение = Новый Структура("Сотрудник, Дата, ТорговаяТочка, ПризнакОтсутствия");
			
			НайденныеСтроки = ТаблицаИзменений.НайтиСтроки(Новый Структура("Сотрудник, Дата", Стр.Сотрудник, Стр.Дата));
			
			КоличествоСтрок = НайденныеСтроки.Количество();
			
			Если КоличествоСтрок > 0 Тогда
				
				//ТекущееЗначение = Новый Структура("Сотрудник, Дата, СвойствоПродавца, ТорговаяТочка, ПризнакОтсутствия");
				ТекущееЗначение = Новый Структура("Сотрудник, Дата, ТорговаяТочка, ПризнакОтсутствия");
				ЗаполнитьЗначенияСвойств(ТекущееЗначение, НайденныеСтроки[КоличествоСтрок-1]);
				
				Если СравнениеСтруктур(НачальноеЗначение, ТекущееЗначение)Тогда
					//Начальные данные
					ЗаполнитьЗначенияСвойств(ТаблицаДанных.Добавить(), Стр);
					
					//Изменение
					ЗаполнитьЗначенияСвойств(ТаблицаДанных.Добавить(), НайденныеСтроки[КоличествоСтрок-1]);
				КонецЕсли;
				
			КонецЕсли;
			
		КонецЦикла;
		
	КонецЦикла;
	
	ТаблицаДанныхПоВсемИзменениям.Свернуть("Группа, Дата", "Количество");
	ТаблицаДанных.Свернуть("Группа, Дата", "Количество, ВсегоИзменений");
	
	Для Каждого Стр Из ТаблицаДанных Цикл
		Данные = ТаблицаДанныхПоВсемИзменениям.НайтиСтроки(Новый Структура("Группа, Дата", Стр.Группа, Стр.Дата));
		Если Данные.Количество()Тогда
			Стр.ВсегоИзменений = Данные[0].Количество;
			ТаблицаДанныхПоВсемИзменениям.Удалить(Данные[0]);
		КонецЕсли;
	КонецЦикла;
	
	// Если отались строки то добавим в таблицу данных
	Для Каждого Стр Из ТаблицаДанныхПоВсемИзменениям Цикл
		НовСтр = ТаблицаДанных.Добавить();
		НовСтр.Группа = Стр.Группа;
		НовСтр.Дата = Стр.Дата;
		НовСтр.ВсегоИзменений = Стр.Количество;
	КонецЦикла;
	
	ВнешниеНаборыДанных = Новый Структура;
	ВнешниеНаборыДанных.Вставить("ДанныеДляФормирования", ТаблицаДанных);
	
	//Макет компоновки 
	КомпоновщикМакета = Новый КомпоновщикМакетаКомпоновкиДанных;
	МакетКомпоновки = КомпоновщикМакета.Выполнить(СхемаКомпоновкиДанных, КомпоновщикНастроек.ПолучитьНастройки(), ДанныеРасшифровки);
	
	//Компоновка данных
	ПроцессорКомпоновки = Новый ПроцессорКомпоновкиДанных;
	ПроцессорКомпоновки.Инициализировать(МакетКомпоновки, ВнешниеНаборыДанных, ДанныеРасшифровки);
	
	//Вывод результата
	ПроцессорВывода = Новый ПроцессорВыводаРезультатаКомпоновкиДанныхВТабличныйДокумент;
	ПроцессорВывода.УстановитьДокумент(ДокументРезультат);
	ПроцессорВывода.Вывести(ПроцессорКомпоновки);
	
КонецПроцедуры

Функция СравнениеСтруктур(НачальнаяСтруктура, КонечнаяСтруктура)
	
	Для Каждого текПоле Из НачальнаяСтруктура Цикл
		
		ЗначениеСравнение = ?(КонечнаяСтруктура.Свойство(текПоле.Ключ), КонечнаяСтруктура[текПоле.Ключ], Неопределено);
        Если текПоле.Значение <> ЗначениеСравнение тогда
            Возврат Истина;
        КонецЕсли;
		
	КонецЦикла;
	
	Возврат Ложь;
	
КонецФункции
