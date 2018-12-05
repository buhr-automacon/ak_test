﻿
&НаКлиенте
Процедура Дата1ПриИзменении(Элемент)
	Кол=Список.Отбор.Элементы.Количество();
	Для Сч=0 По Кол-1 Цикл
		Список.Отбор.Элементы.Удалить(Кол-1-Сч);
	КонецЦикла; 
	УстановитьОтбор();
	Если НеРассмотренные Тогда
		ЭлементОтбора = Список.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
		ЭлементОтбора.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("ИсполнительФизЛицо");          
		ЭлементОтбора.ВидСравнения 		= ВидСравненияКомпоновкиДанных.Равно;
		ЭлементОтбора.Использование 	= Истина;
		ЭлементОтбора.ПравоеЗначение 	= ПредопределенноеЗначение("Справочник.ФизическиеЛица.ПустаяСсылка");
	
		ЭлементОтбора = Список.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
		ЭлементОтбора.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("ВидЗаявки");          
		ЭлементОтбора.ВидСравнения 		= ВидСравненияКомпоновкиДанных.Равно;
		ЭлементОтбора.Использование 	= Истина;
		ЭлементОтбора.ПравоеЗначение 	= ПредопределенноеЗначение("Перечисление.ВидыЗаявокНаРемонт.ТекущийРемонт");
	
	КонецЕсли; 
КонецПроцедуры

Процедура УстановитьОтбор()
	УстановитьПривилегированныйРежим(Истина);	
	ЭтоТехник=РольДоступна("Техник");
	Если ЭтоТехник Тогда
    	ФизЛицо=ПараметрыСеанса.ТекущийПользователь.ФизЛицо;
	
		Запрос = Новый Запрос;
		Запрос.Текст = 
			"ВЫБРАТЬ
			|	Техники.Ссылка
			|ИЗ
			|	Справочник.Техники КАК Техники
			|ГДЕ
			|	Техники.ПометкаУдаления = ЛОЖЬ
			|	И Техники.ФизЛицо = &ФизЛицо";
		
		Запрос.УстановитьПараметр("ФизЛицо", ФизЛицо);
		
		РезультатЗапроса = Запрос.Выполнить();
		
		ВыборкаДетальныеЗаписи = РезультатЗапроса.Выбрать();
		
		Пока ВыборкаДетальныеЗаписи.Следующий() Цикл
    		ИсполнительОтбор=ВыборкаДетальныеЗаписи.Ссылка;
		КонецЦикла;
		
		Элементы.ИсполнительОтбор.ТолькоПросмотр=Истина;
	КонецЕсли; 
	
	ЭлементОтбора = Список.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ЭлементОтбора.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("Дата");          
	ЭлементОтбора.ВидСравнения 		= ВидСравненияКомпоновкиДанных.БольшеИлиРавно;
	ЭлементОтбора.Использование 	= Истина;
	ЭлементОтбора.ПравоеЗначение 	= ДатаОтбор.ДатаНачала;
	
	ЭлементОтбора = Список.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ЭлементОтбора.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("Дата");          
	ЭлементОтбора.ВидСравнения 		= ВидСравненияКомпоновкиДанных.МеньшеИлиРавно;
	ЭлементОтбора.Использование 	= Истина;
	ЭлементОтбора.ПравоеЗначение 	= КонецДня(ДатаОтбор.ДатаОкончания);
	
	//
	Если ЗначениеЗаполнено(ВидЗаявкиОтбор) Тогда
		ЭлементОтбора = Список.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
		ЭлементОтбора.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("ВидЗаявки");          
		ЭлементОтбора.ВидСравнения 		= ВидСравненияКомпоновкиДанных.Равно;
		ЭлементОтбора.Использование 	= Истина;
		ЭлементОтбора.ПравоеЗначение 	= ВидЗаявкиОтбор;
	КонецЕсли; 
		//
	Если ВыполненоОтбор="Да" Тогда
		ЭлементОтбора = Список.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
		ЭлементОтбора.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("Выполнено");          
		ЭлементОтбора.ВидСравнения 		= ВидСравненияКомпоновкиДанных.Равно;
		ЭлементОтбора.Использование 	= Истина;
		ЭлементОтбора.ПравоеЗначение 	= Истина;
	ИначеЕсли ВыполненоОтбор="Нет" Тогда
		ЭлементОтбора = Список.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
		ЭлементОтбора.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("Выполнено");          
		ЭлементОтбора.ВидСравнения 		= ВидСравненияКомпоновкиДанных.Равно;
		ЭлементОтбора.Использование 	= Истина;
		ЭлементОтбора.ПравоеЗначение 	= Ложь;
	КонецЕсли; 
	Если ЗначениеЗаполнено(ИсполнительОтбор) Тогда
		Если ТипЗнч(ИсполнительОтбор)=Тип("СправочникСсылка.Техники") Тогда
			ЭлементОтбора = Список.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
			ЭлементОтбора.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("ИсполнительФизЛицо");          
			ЭлементОтбора.ВидСравнения 		= ВидСравненияКомпоновкиДанных.Равно;
			ЭлементОтбора.Использование 	= Истина;
			ЭлементОтбора.ПравоеЗначение 	= ИсполнительОтбор;
		ИначеЕсли ТипЗнч(ИсполнительОтбор)=Тип("СправочникСсылка.Контрагенты") Тогда                              
			ЭлементОтбора = Список.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
			ЭлементОтбора.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("ИсполнительКонтрагент");          
			ЭлементОтбора.ВидСравнения 		= ВидСравненияКомпоновкиДанных.Равно;
			ЭлементОтбора.Использование 	= Истина;
			ЭлементОтбора.ПравоеЗначение 	= ИсполнительОтбор;
		КонецЕсли; 
	КонецЕсли; 
		
	ЭлементОтбора = Список.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ЭлементОтбора.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("Описание");          
	ЭлементОтбора.ВидСравнения 		= ВидСравненияКомпоновкиДанных.Содержит;
	ЭлементОтбора.Использование 	= Истина;
	ЭлементОтбора.ПравоеЗначение 	= ОписаниеОтбор;
	//
	ЭлементОтбора = Список.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ЭлементОтбора.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("Номер");          
	ЭлементОтбора.ВидСравнения 		= ВидСравненияКомпоновкиДанных.Содержит;
	ЭлементОтбора.Использование 	= Истина;
	ЭлементОтбора.ПравоеЗначение 	= НомерОтбор;
	//
	Если ЗначениеЗаполнено(ГруппаОтбор) Тогда
		ЭлементОтбора = Список.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
		ЭлементОтбора.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("Подгруппа");          
		ЭлементОтбора.ВидСравнения 		= ВидСравненияКомпоновкиДанных.Равно;
		ЭлементОтбора.Использование 	= Истина;
		ЭлементОтбора.ПравоеЗначение 	= ГруппаОтбор;
	КонецЕсли; 
	
	Если ЗначениеЗаполнено(МагазинОтбор) Тогда
		ЭлементОтбора = Список.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
		ЭлементОтбора.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("Магазин");          
		ЭлементОтбора.ВидСравнения 		= ВидСравненияКомпоновкиДанных.Равно;
		ЭлементОтбора.Использование 	= Истина;
		ЭлементОтбора.ПравоеЗначение 	= МагазинОтбор;
	КонецЕсли; 
	
	Если Не РольДоступна("ПолныеПрава") Тогда
		Запрос = Новый Запрос;
		Запрос.Текст = 
			"ВЫБРАТЬ
			|	РолиПользователейТипыРолей.ТипРоли,
			|	РолиПользователейСоставРоли.Ссылка
			|ИЗ
			|	Справочник.РолиПользователей.ТипыРолей КАК РолиПользователейТипыРолей
			|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ Справочник.РолиПользователей.СоставРоли КАК РолиПользователейСоставРоли
			|		ПО РолиПользователейТипыРолей.Ссылка = РолиПользователейСоставРоли.Ссылка
			|ГДЕ
			|	РолиПользователейТипыРолей.ТипРоли В(&ТипРоли)
			|	И РолиПользователейСоставРоли.Сотрудник = &Сотрудник
			|	И РолиПользователейСоставРоли.Ссылка.ПометкаУдаления = ЛОЖЬ";
		
		Запрос.УстановитьПараметр("Сотрудник", ПараметрыСеанса.ТекущийПользователь.ФизЛицо);
		МасТР=Новый Массив;
		РольУпр=ПланыВидовХарактеристик.ТипыРолейПользователя.НайтиПоНаименованию("Управляющий по рознице");
		МасТР.Добавить(ПланыВидовХарактеристик.ТипыРолейПользователя.ПомощникТерриториальногоУправляющего);
		//+++ AK suvv 2018.06.08 ИП-00018376.01
		МасТР.Добавить(ПланыВидовХарактеристик.ТипыРолейПользователя.ПомощникСтороннейРозницы);
		//--- AK suvv
		МасТР.Добавить(РольУпр);
		Запрос.УстановитьПараметр("ТипРоли", МасТР);
		
		РезультатЗапроса = Запрос.Выполнить();
		
		ВыборкаДетальныеЗаписи = РезультатЗапроса.Выбрать();
		ЭтоУправляющий=Ложь;
		ЭтоПомощник=Ложь;
		ЭтоМагазин=РольДоступна("Продавец") ИЛИ РольДоступна("ПродавецТолькоПросмотр");
		МассивРолей=Новый Массив;
		
		Если Не ЭтоМагазин Тогда
			
			Пока ВыборкаДетальныеЗаписи.Следующий() Цикл
				Если ВыборкаДетальныеЗаписи.ТипРоли=РольУпр Тогда
					ЭтоУправляющий=Истина;
					МассивРолей.Добавить(ВыборкаДетальныеЗаписи.ссылка);	
				ИначеЕсли  ВыборкаДетальныеЗаписи.ТипРоли=ПланыВидовХарактеристик.ТипыРолейПользователя.ПомощникТерриториальногоУправляющего 
					//+++ AK suvv 2018.06.08 ИП-00018376.01
					ИЛИ  ВыборкаДетальныеЗаписи.ТипРоли=ПланыВидовХарактеристик.ТипыРолейПользователя.ПомощникСтороннейРозницы Тогда
					//--- AK suvv
					ЭтоПомощник=Истина;
					МассивРолей.Добавить(ВыборкаДетальныеЗаписи.ссылка);	
				КонецЕсли; 
			КонецЦикла;
	
			Запрос = Новый Запрос;
			Запрос.Текст = 
				"ВЫБРАТЬ
				|	СоответствиеОбъектРольСрезПоследних.Объект
				|ИЗ
				|	РегистрСведений.СоответствиеОбъектРоль.СрезПоследних(
				|			,
				|			ТипРоли = &ТипРоли
				//+++ AK suvv 2018.06.08 ИП-00018376.01
				|           ИЛИ ТипРоли = &ТипРолиСторонняяРозница
				//--- AK suvv
				|				ИЛИ ТипРоли = &ТипРоли1) КАК СоответствиеОбъектРольСрезПоследних
				|ГДЕ
				|	СоответствиеОбъектРольСрезПоследних.РольПользователя В ИЕРАРХИИ(&РольПользователя)";
			
			Запрос.УстановитьПараметр("РольПользователя", МассивРолей);
			Запрос.УстановитьПараметр("ТипРоли", ПланыВидовХарактеристик.ТипыРолейПользователя.ПомощникТерриториальногоУправляющего);
			//+++ AK suvv 2018.06.08 ИП-00018376.01
			Запрос.УстановитьПараметр("ТипРолиСторонняяРозница", ПланыВидовХарактеристик.ТипыРолейПользователя.ПомощникСтороннейРозницы);
			//--- AK suvv
			Запрос.УстановитьПараметр("ТипРоли1", РольУпр);
			
			РезультатЗапроса = Запрос.Выполнить();
			
			ВыборкаДетальныеЗаписи = РезультатЗапроса.Выбрать();
			СписокМагазинов=Новый СписокЗначений;
			Пока ВыборкаДетальныеЗаписи.Следующий() Цикл
				СписокМагазинов.Добавить(ВыборкаДетальныеЗаписи.Объект);
			КонецЦикла;
			Если СписокМагазинов.Количество() Тогда
				ЭлементОтбора = Список.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
				ЭлементОтбора.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("Магазин");          
				ЭлементОтбора.ВидСравнения 		= ВидСравненияКомпоновкиДанных.ВСписке;
				ЭлементОтбора.Использование 	= Истина;
				ЭлементОтбора.ПравоеЗначение 	= СписокМагазинов;
			КонецЕсли; 
		Иначе	
	    	МагазинОтбор=ПараметрыСеанса.ТорговаяТочкаПоАйпи;
			Элементы.МагазинОтбор.ТолькоПросмотр=Истина;
			ЭлементОтбора = Список.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
			ЭлементОтбора.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("Магазин");          
			ЭлементОтбора.ВидСравнения 		= ВидСравненияКомпоновкиДанных.Равно;
			ЭлементОтбора.Использование 	= Истина;
			ЭлементОтбора.ПравоеЗначение 	= МагазинОтбор;
		КонецЕсли; 
	
	КонецЕсли; 

КонецПроцедуры


&НаКлиенте
Процедура ПриОткрытии(Отказ)
	ДатаОтбор.Вариант=ВариантСтандартногоПериода.Месяц;
	УстановитьОтбор();

КонецПроцедуры


&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	

КонецПроцедуры
 
