﻿//+++АК KOPA +Модуль 2018.01.09 ИП-00017595
//Модуль содержит функционал для возможности изменять состав паллеты при дегустации

Функция ВыполнитьДействие(СтруктураПараметры) Экспорт 
	Действие = СтруктураПараметры.Действие;
	
	Если Действие = "ПроверитьТовар" Тогда		
		Результат = ТоварЕстьНаПаллетеРезультат(СтруктураПараметры);
	ИначеЕсли Действие = "ПересоздатьПаллету" Тогда
		Результат = ПересоздатьПаллетуРезультат(СтруктураПараметры);
	Иначе 
		ВызватьИсключение "Не установлено действие для выполнения!";
	КонецЕсли;
	
	Возврат ПоместитьДанныеВХранилище(Результат);
КонецФункции

Функция ПолучитьСсылкуПоГУИД(Знач ГУИД, Менеджер)
	Если ТипЗнч(ГУИД) = Тип("Строка") Тогда
		ГУИД = Новый УникальныйИдентификатор(ГУИД);	
	КонецЕсли;
	
	Ссылка = Менеджер.ПолучитьСсылку(ГУИД);	
		
	Возврат Ссылка;
КонецФункции

Функция ПоместитьДанныеВХранилище(Данные)
	Возврат Новый ХранилищеЗначения(Данные, Новый СжатиеДанных(9));	
КонецФункции

Функция ПреобразоватьГУИД_ВСсылки(Данные)
	Паллета = ПолучитьСсылкуПоГУИД(Данные.Паллета, Справочники.СоставПаллеты);
	Номенклатура = ПолучитьСсылкуПоГУИД(Данные.Номенклатура, Справочники.Номенклатура);
	
	Характеристика = Справочники.ХарактеристикиНоменклатуры.ПустаяСсылка();
	
	Если ЗначениеЗаполнено(Данные.Характеристика) Тогда
		Характеристика = ПолучитьСсылкуПоГУИД(Данные.Характеристика, Справочники.ХарактеристикиНоменклатуры);		
	КонецЕсли;	

	Возврат Новый Структура("Паллета,Номенклатура,Характеристика", Паллета, Номенклатура, Характеристика);
КонецФункции

Функция ТоварЕстьНаПаллете(ДанныеСсылки, ДатаПроизводства) Экспорт 
	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ
		|	СоставПаллетыСостав.Характеристика,
		|	СоставПаллетыСостав.ДатаПроизводства,
		|	ВЫБОР
		|		КОГДА СоставПаллетыСостав.Характеристика = &Характеристика
		|			ТОГДА ИСТИНА
		|		ИНАЧЕ ЛОЖЬ
		|	КОНЕЦ КАК ЕстьХарактеристика,
		|	ВЫБОР
		|		КОГДА СоставПаллетыСостав.ДатаПроизводства = &ДатаПроизводства
		|			ТОГДА ИСТИНА
		|		ИНАЧЕ ЛОЖЬ
		|	КОНЕЦ КАК ЕстьДатаПроизводства,
		|	СоставПаллетыСостав.Ссылка.Актуален КАК Актуален
		|ИЗ
		|	Справочник.СоставПаллеты.Состав КАК СоставПаллетыСостав
		|ГДЕ
		|	СоставПаллетыСостав.Ссылка = &Паллета
		|	И СоставПаллетыСостав.Номенклатура = &Номенклатура
		|ИТОГИ
		|	МАКСИМУМ(Актуален)
		|ПО
		|	ОБЩИЕ";
	
	Запрос.УстановитьПараметр("ДатаПроизводства", ДатаПроизводства);
	Запрос.УстановитьПараметр("Номенклатура", ДанныеСсылки.Номенклатура);
	Запрос.УстановитьПараметр("Паллета", ДанныеСсылки.Паллета);
	Запрос.УстановитьПараметр("Характеристика", ДанныеСсылки.Характеристика);
	
	РезультатЗапроса = Запрос.Выполнить();
	
	ЕстьНоменклатура = Не РезультатЗапроса.Пустой();
	
	Результат = Новый Структура;
	
	Если Не ЕстьНоменклатура Тогда
		Результат.Вставить("Ошибка", "Нет товара на паллете!");
		
		Возврат Результат;
	КонецЕсли;
	
	Выборка = РезультатЗапроса.Выбрать(ОбходРезультатаЗапроса.ПоГруппировкам);	
	
	Выборка.Следующий();
	
	Если Не Выборка.Актуален Тогда
		Результат.Вставить("Ошибка", "Паллета не актуальна!");
		
	    Возврат Результат;
	КонецЕсли;
	
	Выборка = Выборка.Выбрать();
	
	ЕстьВсе = Ложь;
	
	Пока Выборка.Следующий() Цикл
		ЕстьВсе = Выборка.ЕстьХарактеристика и Выборка.ЕстьДатаПроизводства;
		
		Если ЕстьВсе Тогда
			Прервать;	
		КонецЕсли;
	КонецЦикла;
	
	Если Не ЕстьВсе Тогда
		Результат.Вставить("Ошибка", "Товар не совпадает по характеристике или дате производства!");	
		
	    Возврат Результат;
	КонецЕсли;
	
	Результат.Вставить("ОК", Истина);
	
	Возврат Результат;
КонецФункции

Функция ТоварЕстьНаПаллетеРезультат(Данные) Экспорт 
	ДанныеСсылки = ПреобразоватьГУИД_ВСсылки(Данные);
	 
	Результат = ТоварЕстьНаПаллете(ДанныеСсылки, Данные.ДатаПроизводства);
	
	Возврат Результат;
КонецФункции

Функция ПересоздатьПаллету(ДанныеСсылки, ДатаПроизводства, ВзятоКоличество) экспорт		
//Закрываем текущую паллету
	ПаллетаРодитель = ДанныеСсылки.Паллета.ПолучитьОбъект();
	ПаллетаРодитель.Актуален = Ложь;
	ПаллетаРодитель.Записать();
	
//Создаем новую паллету	
	обк = ДанныеСсылки.Паллета.Скопировать();
	обк.ДатаСоздания = ТекущаяДата();
	обк.ИД = Неопределено;
	обк.Актуален = Истина;
	обк.СтарыйИД = ПаллетаРодитель.ИД;
	
	Отбор = Новый Структура("Номенклатура,Характеристика,ДатаПроизводства");
	ЗаполнитьЗначенияСвойств(Отбор, ДанныеСсылки);
	Отбор.ДатаПроизводства = ДатаПроизводства;
	
	Строки = обк.Состав.НайтиСтроки(Отбор);
	
	Строка = Строки[0];
	Строка.Количество = Строка.Количество - ВзятоКоличество;
	
	обк.Записать();		
	
	Возврат Новый Структура("Штрихкод", "85" + Формат(обк.ИД, "ЧЦ=13; ЧВН=; ЧГ=0"));
КонецФункции

Функция ПересоздатьПаллетуРезультат(Данные) экспорт
	ДанныеСсылки = ПреобразоватьГУИД_ВСсылки(Данные);
		
	Результат = ТоварЕстьНаПаллете(ДанныеСсылки, Данные.ДатаПроизводства);
	
	Если Не Результат.Свойство("ОК") Тогда
		Возврат Результат;	
	КонецЕсли;
	
	Результат = Новый Структура;
	
	Попытка
	    НачатьТранзакцию();
		
		НоваяПаллета = ПересоздатьПаллету(ДанныеСсылки, Данные.ДатаПроизводства, Данные.ВзятоКоличество);
		Результат.Вставить("ОК", Истина);
		Результат.Вставить("Штрихкод", НоваяПаллета.Штрихкод);
		
		ЗафиксироватьТранзакцию();
	Исключение
		Ошибка = ОписаниеОшибки();
		
		Если ТранзакцияАктивна() Тогда
			ОтменитьТранзакцию();
		КонецЕсли;
		
		Результат.Вставить("Ошибка", Ошибка);
		
		Возврат Результат;
	КонецПопытки;		
		
	Возврат Результат;
КонецФункции