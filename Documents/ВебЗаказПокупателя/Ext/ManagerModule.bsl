﻿

//
//
Функция ПечатьЗаказНаДоставку(Ссылка) Экспорт
	
	//
	УстановитьПривилегированныйРежим(Истина);
	
	//
	ТабличныйДокумент = Новый ТабличныйДокумент();
	
	//
	Запрос = Новый Запрос();
	Запрос.УстановитьПараметр("Ссылка", Ссылка);
	Запрос.УстановитьПараметр("Планограмма", ПараметрыСеанса.ТорговаяТочкаПоАйпи.Планограмма);
	Запрос.Текст = "ВЫБРАТЬ
	               |	ВебЗаказПокупателяТовары.Ссылка КАК Ссылка,
	               |	ВЫБОР
	               |		КОГДА ВебЗаказПокупателяТовары.Ссылка.ДатаПередачиВМагазин <> ДАТАВРЕМЯ(1, 1, 1)
	               |			ТОГДА ВебЗаказПокупателяТовары.Ссылка.ДатаПередачиВМагазин
	               |		ИНАЧЕ ВебЗаказПокупателяТовары.Ссылка.Дата
	               |	КОНЕЦ КАК Дата,
	               |	CMS1C_ДополнительныеРеквизитыЗаказа.Номер КАК Номер,
	               |	ВЗ_Запрос.МестоВыкладки КАК МестоВыкладки,
	               |	ВебЗаказПокупателяТовары.Номенклатура КАК Номенклатура,
	               |	СУММА(ВебЗаказПокупателяТовары.Количество) КАК Количество,
	               |	ВебЗаказПокупателяТовары.Ссылка.СтатусМагазина КАК Статус,
	               |	ВЫРАЗИТЬ(ВебЗаказПокупателяТовары.Номенклатура.МассаУпаковки КАК СТРОКА(100)) КАК ОписаниеУпаковки,
	               |	ВЫБОР
	               |		КОГДА ВебЗаказПокупателяТовары.Номенклатура.ОднаУпаковкаСодержит = 0
	               |			ТОГДА ВебЗаказПокупателяТовары.Номенклатура.ЕдиницаХраненияОстатков.Вес
	               |		ИНАЧЕ ВебЗаказПокупателяТовары.Номенклатура.ОднаУпаковкаСодержит
	               |	КОНЕЦ КАК Вес,
	               |	ВебЗаказПокупателяТовары.Цена,
	               |	СУММА(ВебЗаказПокупателяТовары.Сумма) КАК Сумма,
	               |	ВебЗаказПокупателяТовары.Комментарий,
	               |	ВЫРАЗИТЬ(ВебЗаказПокупателяТовары.Ссылка.АдресДоставкиДополнительно КАК СТРОКА(250)) КАК АдресДоставкиДополнительно,
	               |	ВЫРАЗИТЬ(ВебЗаказПокупателяТовары.Ссылка.ДополнительнаяИнформация КАК СТРОКА(250)) КАК ДополнительнаяИнформация
	               |ИЗ
	               |	Документ.ВебЗаказПокупателя.Товары КАК ВебЗаказПокупателяТовары
	               |		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.CMS1C_ДополнительныеРеквизитыЗаказа КАК CMS1C_ДополнительныеРеквизитыЗаказа
	               |		ПО ВебЗаказПокупателяТовары.Ссылка = CMS1C_ДополнительныеРеквизитыЗаказа.Заказ
	               |		ЛЕВОЕ СОЕДИНЕНИЕ (ВЫБРАТЬ
	               |			ВыкладкаПланограммы.МестоВыкладки КАК МестоВыкладки,
	               |			ВыкладкаПланограммы.Номенклатура КАК Ссылка
	               |		ИЗ
	               |			РегистрСведений.ВыкладкаПланограммы КАК ВыкладкаПланограммы
	               |		ГДЕ
	               |			ВыкладкаПланограммы.Планограмма = &Планограмма) КАК ВЗ_Запрос
	               |		ПО ВебЗаказПокупателяТовары.Номенклатура = ВЗ_Запрос.Ссылка
	               |ГДЕ
	               |	ВебЗаказПокупателяТовары.Ссылка = &Ссылка
	               |
	               |СГРУППИРОВАТЬ ПО
	               |	ВЗ_Запрос.МестоВыкладки,
	               |	ВебЗаказПокупателяТовары.Номенклатура,
	               |	ВебЗаказПокупателяТовары.Ссылка,
	               |	CMS1C_ДополнительныеРеквизитыЗаказа.Номер,
	               |	ВЫРАЗИТЬ(ВебЗаказПокупателяТовары.Номенклатура.МассаУпаковки КАК СТРОКА(100)),
	               |	ВебЗаказПокупателяТовары.Ссылка.СтатусМагазина,
	               |	ВебЗаказПокупателяТовары.Цена,
	               |	ВебЗаказПокупателяТовары.Масса,
	               |	ВебЗаказПокупателяТовары.Комментарий,
	               |	ЕСТЬNULL(ВебЗаказПокупателяТовары.Ссылка.ДатаПередачиВМагазин, ВебЗаказПокупателяТовары.Ссылка.Дата),
	               |	ВЫБОР
	               |		КОГДА ВебЗаказПокупателяТовары.Ссылка.ДатаПередачиВМагазин <> ДАТАВРЕМЯ(1, 1, 1)
	               |			ТОГДА ВебЗаказПокупателяТовары.Ссылка.ДатаПередачиВМагазин
	               |		ИНАЧЕ ВебЗаказПокупателяТовары.Ссылка.Дата
	               |	КОНЕЦ,
	               |	ВЫБОР
	               |		КОГДА ВебЗаказПокупателяТовары.Номенклатура.ОднаУпаковкаСодержит = 0
	               |			ТОГДА ВебЗаказПокупателяТовары.Номенклатура.ЕдиницаХраненияОстатков.Вес
	               |		ИНАЧЕ ВебЗаказПокупателяТовары.Номенклатура.ОднаУпаковкаСодержит
	               |	КОНЕЦ,
	               |	ВЫРАЗИТЬ(ВебЗаказПокупателяТовары.Ссылка.АдресДоставкиДополнительно КАК СТРОКА(250)),
	               |	ВЫРАЗИТЬ(ВебЗаказПокупателяТовары.Ссылка.ДополнительнаяИнформация КАК СТРОКА(250)),
	               |	ВЫРАЗИТЬ(ВебЗаказПокупателяТовары.Ссылка.АдресДоставкиДополнительно КАК СТРОКА(250)),
	               |	ВЫРАЗИТЬ(ВебЗаказПокупателяТовары.Ссылка.ДополнительнаяИнформация КАК СТРОКА(250))
	               |
	               |УПОРЯДОЧИТЬ ПО
	               |	ВЗ_Запрос.МестоВыкладки.Наименование,
	               |	ВебЗаказПокупателяТовары.Номенклатура.Наименование
	               |ИТОГИ
	               |	МАКСИМУМ(Дата),
	               |	МАКСИМУМ(Номер)
	               |ПО
	               |	Ссылка,
	               |	МестоВыкладки";
				   
	//				   
	Результат = Запрос.Выполнить();
	Выборка = Результат.Выбрать(ОбходРезультатаЗапроса.ПоГруппировкам);
	
	//
	СуммаПокупки = 0;
	
	//
	Пока Выборка.Следующий() Цикл
		
		//
		Макет = Документы.ВебЗаказПокупателя.ПолучитьМакет("ЗаказНаДоставку");
		
		//
		Область = Макет.ПолучитьОбласть("Шапка");
	
		//
		Номер = Выборка.Номер;//ОбщегоНазначения.ПолучитьНомерНаПечать(Выборка.Ссылка);
		Дата = Выборка.Дата;
		
		//
		Область.Параметры.Номер = Номер;
		Область.Параметры.Дата = Формат(Дата, "ДФ=dd.MM.yyyy");
		
		//
		ТабличныйДокумент.Вывести(Область);
		
		//
		Область = Макет.ПолучитьОбласть("ШапкаПокупатель");
		
		//
		Область.Параметры.ПокупательФИО = Ссылка.ФИОПокупателя;
		Область.Параметры.НомерКарты = Ссылка.НомерБонуснойКарты;
		Область.Параметры.ПокупательEmail = Ссылка.Email;
		Область.Параметры.ПокупательТелефон = Ссылка.Телефон;
		
		//
		Область.Параметры.ДополнительнаяИнформация = Ссылка.ДополнительнаяИнформация; 
		
		
		//
		ТабличныйДокумент.Вывести(Область);
		
		//
		Если Ссылка.Услуги.Количество() > 0 Тогда
			
			//
			Область = Макет.ПолучитьОбласть("ШапкаДоставка");
			
			//
			Тариф = Ссылка.Услуги[0].Номенклатура;
			Если ЗначениеЗаполнено(Тариф) Тогда
				
				//
				Область.Параметры.ДоставкаТариф = Тариф;
				Область.Параметры.ДоставкаАдрес = Ссылка.АдресДоставки;
				
				//
				Область.Параметры.АдресДоставкиДополнительно = Ссылка.АдресДоставкиДополнительно;
				
				//
				ТабличныйДокумент.Вывести(Область);
			
			КонецЕсли; 
			
		КонецЕсли; 
		
		//
		Область = Макет.ПолучитьОбласть("ТаблицаШапка");
		ТабличныйДокумент.Вывести(Область);
		
		//
		ВыборкаПланограмма = Выборка.Выбрать(ОбходРезультатаЗапроса.ПоГруппировкам);
		Пока ВыборкаПланограмма.Следующий() Цикл
			
			//
			Область = Макет.ПолучитьОбласть("МестоВыкладки");
			Область.Параметры.МестоВыкладки = ВыборкаПланограмма.МестоВыкладки;
			
			//
			ТабличныйДокумент.Вывести(Область);	
				
			//
			ВыборкаНоменклатура = ВыборкаПланограмма.Выбрать(ОбходРезультатаЗапроса.ПоГруппировкам);
			Пока ВыборкаНоменклатура.Следующий() Цикл
				
				//
				Область = Макет.ПолучитьОбласть("Строка");
				Область.Параметры.Заполнить(ВыборкаНоменклатура);
				
				//
				ТабличныйДокумент.Вывести(Область);	
				
				////
				//Если ЗначениеЗаполнено(ВыборкаНоменклатура.Комментарий) Тогда
				//	
				//	//
				//	Область = Макет.ПолучитьОбласть("Комментарий");
				//	Область.Параметры.Комментарий = ВыборкаНоменклатура.Комментарий;
				//	
				//	//
				//	ТабличныйДокумент.Вывести(Область);
				//
				//КонецЕсли; 
			
			КонецЦикла; 
		
		КонецЦикла; 
	
	КонецЦикла; 
	
	//
	Область = Макет.ПолучитьОбласть("Подвал");
	
	//
	Область.Параметры.ИтогоСуммаПокупки = Ссылка.Товары.Итог("Сумма");
	Область.Параметры.СуммаДоставки = Ссылка.Услуги.Итог("Сумма");
	Область.Параметры.ИтогоКоплате = Ссылка.СуммаДокумента;	
	
	//
	ТабличныйДокумент.Вывести(Область);	
	
	//			   
	ДокОбъект = Ссылка.ПолучитьОбъект();
	ДокОбъект.СтатусМагазина = Перечисления.СтатусыМагазинаДляВебЗаказов.Распечатан;
	ДокОбъект.Записать();
	
	//
	Возврат ТабличныйДокумент;
	
КонецФункции	



Функция ПолучитьЗаказНаДоставку(Ссылка) Экспорт
	
	УстановитьПривилегированныйРежим(Истина);
	
	Запрос = Новый Запрос();
	Запрос.УстановитьПараметр("Ссылка", Ссылка);
	Запрос.УстановитьПараметр("Планограмма", ПараметрыСеанса.ТорговаяТочкаПоАйпи.Планограмма);
	Запрос.Текст = "ВЫБРАТЬ
	               |	CMS1C_ДополнительныеРеквизитыЗаказа.Номер
	               |ИЗ
	               |	РегистрСведений.CMS1C_ДополнительныеРеквизитыЗаказа КАК CMS1C_ДополнительныеРеквизитыЗаказа
	               |ГДЕ
	               |	CMS1C_ДополнительныеРеквизитыЗаказа.Заказ = &Ссылка
	               |;
	               |
	               |////////////////////////////////////////////////////////////////////////////////
	               |ВЫБРАТЬ
	               |	ВЗ_Запрос.МестоВыкладки КАК МестоВыкладки,
	               |	ВебЗаказПокупателяТовары.Номенклатура,
	               |	СУММА(ВебЗаказПокупателяТовары.Количество) КАК Количество
	               |ИЗ
	               |	Документ.ВебЗаказПокупателя.Товары КАК ВебЗаказПокупателяТовары
	               |		ЛЕВОЕ СОЕДИНЕНИЕ (ВЫБРАТЬ
	               |			ВыкладкаПланограммы.МестоВыкладки КАК МестоВыкладки,
	               |			ВыкладкаПланограммы.Номенклатура КАК Ссылка
	               |		ИЗ
	               |			РегистрСведений.ВыкладкаПланограммы КАК ВыкладкаПланограммы
	               |		ГДЕ
	               |			ВыкладкаПланограммы.Планограмма = &Планограмма) КАК ВЗ_Запрос
	               |		ПО ВебЗаказПокупателяТовары.Номенклатура = ВЗ_Запрос.Ссылка
	               |ГДЕ
	               |	ВебЗаказПокупателяТовары.Ссылка = &Ссылка
	               |
	               |СГРУППИРОВАТЬ ПО
	               |	ВЗ_Запрос.МестоВыкладки,
	               |	ВебЗаказПокупателяТовары.Номенклатура
	               |
	               |УПОРЯДОЧИТЬ ПО
	               |	ВЗ_Запрос.МестоВыкладки.Наименование,
	               |	ВебЗаказПокупателяТовары.Номенклатура.Наименование";
				   
	Результаты = Запрос.ВыполнитьПакет();
	Выборка = Результаты[0].Выбрать();
	
	ТабличныйДокумент = Новый ТабличныйДокумент();
	
	Макет = Документы.ВебЗаказПокупателя.ПолучитьМакет("Макет");
	Область = Макет.ПолучитьОбласть("Шапка");
	Если Выборка.Следующий() Тогда
		Область.Параметры.Номер = Выборка.Номер;
	Иначе
		Область.Параметры.Номер = Ссылка.Номер;
	КонецЕсли;	
	Область.Параметры.Дата = Формат(Ссылка.Дата, "ДФ=dd.MM.yyyy");
	ТабличныйДокумент.Вывести(Область);
	
				   
	Выборка = Результаты[1].Выбрать();
	Пока Выборка.СледующийПоЗначениюПоля("МестоВыкладки") Цикл
		Область = Макет.ПолучитьОбласть("МестоВыкладки");
		Область.Параметры.МестоВыкладки = Выборка.МестоВыкладки;
		ТабличныйДокумент.Вывести(Область);
		Пока Выборка.Следующий() Цикл
			Область = Макет.ПолучитьОбласть("Строка");
			Область.Параметры.Номенклатура = Выборка.Номенклатура;
			Область.Параметры.Количество = Выборка.Количество;
			ТабличныйДокумент.Вывести(Область);
		КонецЦикла;	
	КонецЦикла;	
				   
	ДокОбъект = Ссылка.ПолучитьОбъект();
	ДокОбъект.СтатусМагазина = Перечисления.СтатусыМагазинаДляВебЗаказов.Распечатан;
	ДокОбъект.Записать();
	
	Возврат ТабличныйДокумент;
	
КонецФункции	
