﻿//+++ AK suvv 12.07.2018 ИП-00019053
//Процедура ПередЗаписью(Отказ, Замещение)
//	
//	//
//	Для каждого ТекСтрНабора Из ЭтотОбъект Цикл
//		
//		ТекФизЛицо = ТекСтрНабора.ФизЛицо;
//		
//		Если ЗначениеЗаполнено(ТекФизЛицо) Тогда 
//			
//			Если ТипЗнч(ТекФизЛицо)=Тип("СправочникСсылка.Контрагенты") Тогда
//				Запрос = Новый Запрос;
//				Запрос.Текст = 
//				"ВЫБРАТЬ
//				|	КонтактнаяИнформация.Представление,
//				|	КонтактнаяИнформация.Тип
//				|ИЗ
//				|	(ВЫБРАТЬ
//				|		КонтактныеЛицаКонтрагентов.Ссылка КАК Ссылка
//				|	ИЗ
//				|		Справочник.КонтактныеЛицаКонтрагентов КАК КонтактныеЛицаКонтрагентов
//				|	ГДЕ
//				|		КонтактныеЛицаКонтрагентов.Владелец = &Владелец) КАК ВложенныйЗапрос
//				|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ РегистрСведений.КонтактнаяИнформация КАК КонтактнаяИнформация
//				|		ПО ВложенныйЗапрос.Ссылка = КонтактнаяИнформация.Объект
//				|ГДЕ
//				|	КонтактнаяИнформация.Тип В (ЗНАЧЕНИЕ(Перечисление.ТипыКонтактнойИнформации.Телефон), ЗНАЧЕНИЕ(Перечисление.ТипыКонтактнойИнформации.АдресЭлектроннойПочты))
//				|	И КонтактнаяИнформация.Вид В (ЗНАЧЕНИЕ(Справочник.ВидыКонтактнойИнформации.МобильныйТелефонКонтактногоЛицаКонтрагента), ЗНАЧЕНИЕ(Справочник.ВидыКонтактнойИнформации.АдресЭлектроннойПочтыКонтактногоЛицаКонтрагента), ЗНАЧЕНИЕ(Справочник.ВидыКонтактнойИнформации.РабочийТелефонКонтактногоЛицаКонтрагента))";
//				Запрос.УстановитьПараметр("Владелец",ТекФизЛицо);
//				Выборка = Запрос.Выполнить().Выбрать();
//				Емейл = "";
//				Телефон = "";
//				Пока Выборка.Следующий()Цикл
//					Если Выборка.Тип = Перечисления.ТипыКонтактнойИнформации.АдресЭлектроннойПочты Тогда
//						Емейл = ?(Емейл="","",Емейл+";")+Выборка.Представление;
//					Иначе
//						Телефон = ?(Телефон="","",Телефон+";")+Выборка.Представление;
//					КонецЕсли;
//				КонецЦикла;
//				
//				ТекСтрНабора.Емейл = Емейл;
//				ТекСтрНабора.Телефон = Телефон;
//				
//				//+++АК SHEP 2018.05.11 ИП-00017310.02
//			ИначеЕсли ТипЗнч(ТекФизЛицо) = Тип("СправочникСсылка.ПользователиДляРассылки") Тогда
//				
//				Емейл = "";	Телефон = "";
//				
//				Запрос = Новый Запрос(
//				"ВЫБРАТЬ
//				|	КонтактнаяИнформация.Представление
//				|ИЗ
//				|	РегистрСведений.КонтактнаяИнформация КАК КонтактнаяИнформация
//				|ГДЕ
//				|	КонтактнаяИнформация.Объект = &Объект
//				|	И КонтактнаяИнформация.Тип = ЗНАЧЕНИЕ(Перечисление.ТипыКонтактнойИнформации.АдресЭлектроннойПочты)
//				|	И КонтактнаяИнформация.Вид = ЗНАЧЕНИЕ(Справочник.ВидыКонтактнойИнформации.ЭлАдресПользователяДляРассылки)");
//				Запрос.УстановитьПараметр("Объект", ТекФизЛицо);
//				
//				РезультатЗапроса = Запрос.Выполнить();
//				Если НЕ РезультатЗапроса.Пустой() Тогда
//					Выборка = РезультатЗапроса.Выбрать();
//					Пока Выборка.Следующий()Цикл
//						Емейл = ?(Емейл = "", "", Емейл + ";") + Выборка.Представление;
//					КонецЦикла;
//				КонецЕсли;
//				
//				ТекСтрНабора.Емейл = Емейл;
//				ТекСтрНабора.Телефон = Телефон;
//				//---АК SHEP 2018.05.11
//				
//			Иначе
//				Запрос = Новый Запрос;
//				Запрос.УстановитьПараметр("Объект", ТекФизЛицо);			
//				Запрос.Текст = 
//				"ВЫБРАТЬ
//				|	КонтактнаяИнформация.Представление КАК Телефон
//				|ИЗ
//				|	РегистрСведений.КонтактнаяИнформация КАК КонтактнаяИнформация
//				|ГДЕ
//				|	КонтактнаяИнформация.Объект = &Объект
//				|	И КонтактнаяИнформация.Тип = ЗНАЧЕНИЕ(Перечисление.ТипыКонтактнойИнформации.Телефон)
//				|	И КонтактнаяИнформация.Вид = ЗНАЧЕНИЕ(Справочник.ВидыКонтактнойИнформации.ТелефонСлужебный)";
//				ВыборкаДетальныеЗаписи = Запрос.Выполнить().Выбрать();
//				Пока ВыборкаДетальныеЗаписи.Следующий() Цикл
//					ТекСтрНабора.Телефон = ВыборкаДетальныеЗаписи.Телефон;
//				КонецЦикла;
//				
//				Запрос = Новый Запрос;
//				Запрос.УстановитьПараметр("Объект", ТекФизЛицо);
//				Запрос.Текст = 
//				"ВЫБРАТЬ
//				|	КонтактнаяИнформация1.Представление КАК Емейл
//				|ИЗ
//				|	РегистрСведений.КонтактнаяИнформация КАК КонтактнаяИнформация1
//				|ГДЕ
//				|	КонтактнаяИнформация1.Объект = &Объект
//				|	И КонтактнаяИнформация1.Тип = ЗНАЧЕНИЕ(Перечисление.ТипыКонтактнойИнформации.АдресЭлектроннойПочты)
//				|	И КонтактнаяИнформация1.Вид = ЗНАЧЕНИЕ(Справочник.ВидыКонтактнойИнформации.EmailФизЛица)";
//				ВыборкаДетальныеЗаписи = Запрос.Выполнить().Выбрать();
//				Пока ВыборкаДетальныеЗаписи.Следующий() Цикл
//					ТекСтрНабора.Емейл = ВыборкаДетальныеЗаписи.Емейл;
//				КонецЦикла;
//			КонецЕсли;							
//		КонецЕсли;	
//		
//	КонецЦикла;
//	
//КонецПроцедуры
//--- AK suvv
Процедура ПередЗаписью(Отказ, Замещение)
	
	Для каждого ТекСтрНабора Из ЭтотОбъект Цикл
		
		ТекФизЛицо = ТекСтрНабора.ФизЛицо;
		
		Если ЗначениеЗаполнено(ТекФизЛицо) Тогда 
			
			ВидыТелефонов = Новый Массив;
			ВидыEmail = Новый Массив;
			
			Если ТипЗнч(ТекФизЛицо) = Тип("СправочникСсылка.Контрагенты") Тогда
				ВидыТелефонов.Добавить(Справочники.ВидыКонтактнойИнформации.ТелефонКонтрагента);
				ВидыEmail.Добавить(Справочники.ВидыКонтактнойИнформации.АдресЭлектроннойПочтыКонтрагентаДляОбменаДокументами);			
			ИначеЕсли ТипЗнч(ТекФизЛицо) = Тип("СправочникСсылка.КонтактныеЛицаКонтрагентов") Тогда
				ВидыТелефонов.Добавить(Справочники.ВидыКонтактнойИнформации.МобильныйТелефонКонтактногоЛицаКонтрагента);
				ВидыТелефонов.Добавить(Справочники.ВидыКонтактнойИнформации.РабочийТелефонКонтактногоЛицаКонтрагента);
				ВидыEmail.Добавить(Справочники.ВидыКонтактнойИнформации.АдресЭлектроннойПочтыКонтактногоЛицаКонтрагента);
			ИначеЕсли ТипЗнч(ТекФизЛицо) = Тип("СправочникСсылка.ПользователиДляРассылки") Тогда
				ВидыEmail.Добавить(Справочники.ВидыКонтактнойИнформации.ЭлАдресПользователяДляРассылки);
			Иначе	
				ВидыТелефонов.Добавить(Справочники.ВидыКонтактнойИнформации.ТелефонСлужебный);
				ВидыEmail.Добавить(Справочники.ВидыКонтактнойИнформации.EmailФизЛица);	
			КонецЕсли;
			
			Если ВидыТелефонов.Количество() <> 0 Тогда
				
				Телефон = "";
				
				Запрос = Новый Запрос;
				Запрос.УстановитьПараметр("Объект", ТекФизЛицо);
				Запрос.УстановитьПараметр("ВидыТелефонов", ВидыТелефонов);
				Запрос.Текст = 
				"ВЫБРАТЬ
				|	КонтактнаяИнформация.Представление КАК Телефон
				|ИЗ
				|	РегистрСведений.КонтактнаяИнформация КАК КонтактнаяИнформация
				|ГДЕ
				|	КонтактнаяИнформация.Объект = &Объект
				|	И КонтактнаяИнформация.Тип = ЗНАЧЕНИЕ(Перечисление.ТипыКонтактнойИнформации.Телефон)
				|	И ВЫБОР
				|			КОГДА КонтактнаяИнформация.Объект ССЫЛКА Справочник.КонтактныеЛицаКонтрагентов
				|				ТОГДА ИСТИНА
				|			ИНАЧЕ КонтактнаяИнформация.Вид В (&ВидыТелефонов)
				|		КОНЕЦ";
				
				Выборка = Запрос.Выполнить().Выбрать();
				
				Пока Выборка.Следующий() Цикл
					Телефон = ?(Телефон = "", "", Телефон + ";") + Выборка.Телефон;
				КонецЦикла;
				
				ТекСтрНабора.Телефон = Телефон;
				
			КонецЕсли;
			
			Если ВидыEmail.Количество() <> 0 Тогда
				
				Емейл = "";
				
				Запрос = Новый Запрос;
				Запрос.УстановитьПараметр("Объект", ТекФизЛицо);
				Запрос.УстановитьПараметр("ВидыEmail", ВидыEmail);
				Запрос.Текст = 
				"ВЫБРАТЬ
				|	КонтактнаяИнформация1.Представление КАК Емейл
				|ИЗ
				|	РегистрСведений.КонтактнаяИнформация КАК КонтактнаяИнформация1
				|ГДЕ
				|	КонтактнаяИнформация1.Объект = &Объект
				|	И КонтактнаяИнформация1.Тип = ЗНАЧЕНИЕ(Перечисление.ТипыКонтактнойИнформации.АдресЭлектроннойПочты)
				|	И КонтактнаяИнформация1.Вид в (&ВидыEmail)";
				
				Выборка = Запрос.Выполнить().Выбрать();
				
				Пока Выборка.Следующий() Цикл
					Емейл = ?(Емейл = "", "", Емейл + ";") + Выборка.Емейл;
				КонецЦикла;
				
				ТекСтрНабора.Емейл = Емейл;
				
			КонецЕсли;
			
		КонецЕсли;
		
	КонецЦикла;
	
КонецПроцедуры
