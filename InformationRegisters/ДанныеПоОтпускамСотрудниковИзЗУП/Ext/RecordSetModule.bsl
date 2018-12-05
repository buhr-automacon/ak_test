﻿
Процедура ПередЗаписью(Отказ, Замещение)
	
	
	Для каждого ТекСтрНабора Из ЭтотОбъект Цикл
		
		ТекЗаместитель = ТекСтрНабора.Заместитель;
		ТекСотрудник = ТекСтрНабора.Сотрудник;
		
		Если ЗначениеЗаполнено(ТекЗаместитель) Тогда 
			
			СтрокаКонтактнойИнф = "";
			
			Запрос = Новый Запрос;
			Запрос.Текст = 
			"ВЫБРАТЬ
			|	КонтактнаяИнформация.Представление КАК Телефон
			|ИЗ
			|	РегистрСведений.КонтактнаяИнформация КАК КонтактнаяИнформация
			|ГДЕ
			|	КонтактнаяИнформация.Объект = &Объект
			|	И КонтактнаяИнформация.Тип = &ТипТелефон
			|	И КонтактнаяИнформация.Вид = &ВидТелефон";
						
			Запрос.УстановитьПараметр("ВидТелефон", Справочники.ВидыКонтактнойИнформации.ТелефонСлужебный);
			Запрос.УстановитьПараметр("Объект", ТекЗаместитель.Физлицо);			
			Запрос.УстановитьПараметр("ТипТелефон", Перечисления.ТипыКонтактнойИнформации.Телефон);
			
			Результат = Запрос.Выполнить();
			
			ВыборкаДетальныеЗаписи = Результат.Выбрать();
			ТекТелефон = "";
			Пока ВыборкаДетальныеЗаписи.Следующий() Цикл
				ТекТелефон = "тел.: "+ВыборкаДетальныеЗаписи.Телефон;
			КонецЦикла;
			
			Если ТекТелефон = "" Тогда
				
				Запрос = Новый Запрос;
				Запрос.Текст = 
				"ВЫБРАТЬ
				|	КонтактнаяИнформация.Представление КАК Телефон
				|ИЗ
				|	РегистрСведений.КонтактнаяИнформация КАК КонтактнаяИнформация
				|ГДЕ
				|	КонтактнаяИнформация.Объект = &Объект
				|	И КонтактнаяИнформация.Тип = &ТипТелефон
				|	И КонтактнаяИнформация.Вид = &ВидТелефон";
				
				Запрос.УстановитьПараметр("ВидТелефон", Справочники.ВидыКонтактнойИнформации.ТелефонФизЛица);
				Запрос.УстановитьПараметр("Объект", ТекЗаместитель.Физлицо);			
				Запрос.УстановитьПараметр("ТипТелефон", Перечисления.ТипыКонтактнойИнформации.Телефон);
				
				Результат = Запрос.Выполнить();
				
				ВыборкаДетальныеЗаписи = Результат.Выбрать();
				
				Пока ВыборкаДетальныеЗаписи.Следующий() Цикл
					ТекТелефон = "тел.: "+ВыборкаДетальныеЗаписи.Телефон;
				КонецЦикла;
				
			КонецЕсли;	
			
			Запрос = Новый Запрос;
			Запрос.Текст = 
			"ВЫБРАТЬ
			|	КонтактнаяИнформация1.Представление КАК Емейл
			|ИЗ
			|	РегистрСведений.КонтактнаяИнформация КАК КонтактнаяИнформация1
			|ГДЕ
			|	КонтактнаяИнформация1.Объект = &Объект
			|	И КонтактнаяИнформация1.Тип = &ТипЕмейл
			|	И КонтактнаяИнформация1.Вид = &ВидЕмейл";
			
			Запрос.УстановитьПараметр("ВидЕмейл", Справочники.ВидыКонтактнойИнформации.EmailФизЛица);			
			Запрос.УстановитьПараметр("Объект", ТекЗаместитель.Физлицо);
			Запрос.УстановитьПараметр("ТипЕмейл", Перечисления.ТипыКонтактнойИнформации.АдресЭлектроннойПочты);
						
			Результат = Запрос.Выполнить();
			
			ВыборкаДетальныеЗаписи = Результат.Выбрать();
			ТекЕмейл = "";
			Пока ВыборкаДетальныеЗаписи.Следующий() Цикл
				ТекЕмейл = "email: "+ВыборкаДетальныеЗаписи.Емейл;
			КонецЦикла;
			
			СтрокаКонтактнойИнф = ТекТелефон + ?(ТекТелефон = "","", ?(ТекЕмейл = "", "", ", "))+ТекЕмейл;
			
			ТекСтрНабора.КонтактыЗаместителя = 	СтрокаКонтактнойИнф;
			
		КонецЕсли;	
		
		ТекРук = ТекСтрНабора.РуководительСотрудника;
		
		Если ЗначениеЗаполнено(ТекРук) Тогда 
			
			СтрокаКонтактнойИнф = "";
			
			Запрос = Новый Запрос;
			Запрос.Текст = 
			"ВЫБРАТЬ
			|	КонтактнаяИнформация.Представление КАК Телефон
			|ИЗ
			|	РегистрСведений.КонтактнаяИнформация КАК КонтактнаяИнформация
			|ГДЕ
			|	КонтактнаяИнформация.Объект = &Объект
			|	И КонтактнаяИнформация.Тип = &ТипТелефон
			|	И КонтактнаяИнформация.Вид = &ВидТелефон";
						
			Запрос.УстановитьПараметр("ВидТелефон", Справочники.ВидыКонтактнойИнформации.ТелефонСлужебный);
			Запрос.УстановитьПараметр("Объект", ТекРук);			
			Запрос.УстановитьПараметр("ТипТелефон", Перечисления.ТипыКонтактнойИнформации.Телефон);
			
			Результат = Запрос.Выполнить();
			
			ВыборкаДетальныеЗаписи = Результат.Выбрать();
			ТекТелефон = "";
			Пока ВыборкаДетальныеЗаписи.Следующий() Цикл
				ТекТелефон = "тел.: "+ВыборкаДетальныеЗаписи.Телефон;
			КонецЦикла;
			
			Если ТекТелефон = "" Тогда
				
				Запрос = Новый Запрос;
				Запрос.Текст = 
				"ВЫБРАТЬ
				|	КонтактнаяИнформация.Представление КАК Телефон
				|ИЗ
				|	РегистрСведений.КонтактнаяИнформация КАК КонтактнаяИнформация
				|ГДЕ
				|	КонтактнаяИнформация.Объект = &Объект
				|	И КонтактнаяИнформация.Тип = &ТипТелефон
				|	И КонтактнаяИнформация.Вид = &ВидТелефон";
				
				Запрос.УстановитьПараметр("ВидТелефон", Справочники.ВидыКонтактнойИнформации.ТелефонФизЛица);
				Запрос.УстановитьПараметр("Объект", ТекРук);			
				Запрос.УстановитьПараметр("ТипТелефон", Перечисления.ТипыКонтактнойИнформации.Телефон);
				
				Результат = Запрос.Выполнить();
				
				ВыборкаДетальныеЗаписи = Результат.Выбрать();
				
				Пока ВыборкаДетальныеЗаписи.Следующий() Цикл
					ТекТелефон = "тел.: "+ВыборкаДетальныеЗаписи.Телефон;
				КонецЦикла;
				
			КонецЕсли;	
			
			Запрос = Новый Запрос;
			Запрос.Текст = 
			"ВЫБРАТЬ
			|	КонтактнаяИнформация1.Представление КАК Емейл
			|ИЗ
			|	РегистрСведений.КонтактнаяИнформация КАК КонтактнаяИнформация1
			|ГДЕ
			|	КонтактнаяИнформация1.Объект = &Объект
			|	И КонтактнаяИнформация1.Тип = &ТипЕмейл
			|	И КонтактнаяИнформация1.Вид = &ВидЕмейл";
			
			Запрос.УстановитьПараметр("ВидЕмейл", Справочники.ВидыКонтактнойИнформации.EmailФизЛица);			
			Запрос.УстановитьПараметр("Объект", ТекРук);
			Запрос.УстановитьПараметр("ТипЕмейл", Перечисления.ТипыКонтактнойИнформации.АдресЭлектроннойПочты);
						
			Результат = Запрос.Выполнить();
			
			ВыборкаДетальныеЗаписи = Результат.Выбрать();
			ТекЕмейл = "";
			Пока ВыборкаДетальныеЗаписи.Следующий() Цикл
				ТекЕмейл = "email: "+ВыборкаДетальныеЗаписи.Емейл;
			КонецЦикла;
			
			СтрокаКонтактнойИнф = ТекТелефон + ?(ТекТелефон = "","", ?(ТекЕмейл = "", "", ", "))+ТекЕмейл;
			
			ТекСтрНабора.КонтактыРуководителя = 	СтрокаКонтактнойИнф;
						
		КонецЕсли;	
				
	КонецЦикла;
	
КонецПроцедуры
