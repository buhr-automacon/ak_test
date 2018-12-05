﻿Функция ОчиститьНомер(Номер)
	ЧистыйНомер = "";
	Для Ном = 1 По СтрДлина(Номер) Цикл
		Сим = Сред(Номер, Ном, 1);
		Если Найти("0123456789", Сим)>0 Тогда
			ЧистыйНомер = ЧистыйНомер + Сим;
		КонецЕсли;
	КонецЦикла;
	Возврат ЧистыйНомер;
КонецФункции

&НаСервере
Процедура УдалитьНомер(Номер, Привязка)

	МенеджерЗаписи = РегистрыСведений.КонтактнаяИнформация.СоздатьМенеджерЗаписи(); 
	МенеджерЗаписи.Объект   = Привязка; 
	МенеджерЗаписи.Тип = Перечисления.ТипыКонтактнойИнформации.Телефон; 
	МенеджерЗаписи.Вид = Справочники.ВидыКонтактнойИнформации.ТелефонСлужебный;
	МенеджерЗаписи.Прочитать();
	Если МенеджерЗаписи.Выбран() Тогда
		Если ОчиститьНомер(МенеджерЗаписи.Представление) = Номер Тогда
			МенеджерЗаписи.Удалить(); 	
		КонецЕсли;
	КонецЕсли;

КонецПроцедуры


Процедура ПроверитьТелефонПоРегистрам(Телефон, ПроверятьДальше = Истина,  ИскатьВКонтактнойИнформации=Ложь) Экспорт
	
	// Найдем текущую привязку
	Запрос = Новый Запрос;
	Запрос.Текст = "ВЫБРАТЬ
	|	ПривязкаТелефоновСрезПоследних.Номер,
	|	ПривязкаТелефоновСрезПоследних.Привязка,
	|	ПривязкаТелефоновСрезПоследних.Назначение
	|ИЗ
	|	РегистрСведений.ПривязкаТелефонов.СрезПоследних КАК ПривязкаТелефоновСрезПоследних
	|ГДЕ
	|	ПривязкаТелефоновСрезПоследних.Номер = &Номер";
	Запрос.УстановитьПараметр("Номер", Телефон);
	
	ТЗ = Запрос.Выполнить().Выгрузить();	
	Если ТЗ.Количество() = 0 Тогда   
		ТекущаяПривязка = Неопределено;
		Текущееназначение = Неопределено;   
	Иначе
		ТекущаяПривязка = ТЗ[0].Привязка;
		Текущееназначение = ТЗ[0].Назначение;	
	КонецЕсли;	
	
	// Удалим лищние записи регистра основных телефонов
	Запрос.Текст = "ВЫБРАТЬ
	|	ОсновныеТелефоны.Привязка,
	|	ОсновныеТелефоны.Назначение
	|ИЗ
	|	РегистрСведений.ОсновныеТелефоны КАК ОсновныеТелефоны
	|ГДЕ
	|	ОсновныеТелефоны.Телефон = &Телефон";
	Запрос.УстановитьПараметр("Телефон", Телефон);
	ТЗ = Запрос.Выполнить().Выгрузить();
	
	ЕстьОсновной = Ложь;
	Для Каждого Стр Из ТЗ Цикл
		Если НЕ Стр.Привязка = ТекущаяПривязка ИЛИ НЕ Стр.Назначение = ТекущееНазначение Тогда
			МенеджерЗаписи = РегистрыСведений.ОсновныеТелефоны.СоздатьМенеджерЗаписи(); 
			МенеджерЗаписи.Привязка   = Стр.Привязка; 
			МенеджерЗаписи.Назначение = Стр.Назначение; 
			МенеджерЗаписи.Телефон = Телефон;
			МенеджерЗаписи.Прочитать(); 	
			МенеджерЗаписи.Удалить(); 
			
			Если Стр.Назначение = Справочники.НазначенияИспользованияSIMКарт.СлужебныйТелефон ИЛИ Телефон.ДляГолосовойСвязи Тогда
				УдалитьНомер(Телефон.Код, Стр.Привязка);
			КонецЕсли;
		Иначе
			ЕстьОсновной = Истина;	
		КонецЕсли;
	КонецЦикла;
	
	//Создадим основной, если его нет
	Если НЕ ТекущаяПривязка = Неопределено и НЕ ЕстьОсновной Тогда
		
		Запрос.Текст = "ВЫБРАТЬ
		               |	ОсновныеТелефоны.Привязка,
		               |	ОсновныеТелефоны.Назначение,
		               |	ОсновныеТелефоны.Телефон
		               |ИЗ
		               |	РегистрСведений.ОсновныеТелефоны КАК ОсновныеТелефоны
		               |ГДЕ
		               |	ОсновныеТелефоны.Привязка = &Привязка
		               |	И ОсновныеТелефоны.Назначение = &Назначение";
		Запрос.УстановитьПараметр("Привязка", ТекущаяПривязка);
		Запрос.УстановитьПараметр("Назначение", Текущееназначение);						   
		ТЗ = Запрос.Выполнить().Выгрузить();
		
		Если ПроверятьДальше Тогда
			
			Для каждого Тел ИЗ ТЗ Цикл
				ПроверитьТелефонПоРегистрам(Тел.телефон, Ложь);
			КонецЦикла;
			
			Запрос.Текст = "ВЫБРАТЬ
			               |	ОсновныеТелефоны.Привязка,
			               |	ОсновныеТелефоны.Назначение,
			               |	ОсновныеТелефоны.Телефон
			               |ИЗ
			               |	РегистрСведений.ОсновныеТелефоны КАК ОсновныеТелефоны
			               |ГДЕ
			               |	ОсновныеТелефоны.Привязка = &Привязка
			               |	И ОсновныеТелефоны.Назначение = &Назначение";
			Запрос.УстановитьПараметр("Привязка", ТекущаяПривязка);
			Запрос.УстановитьПараметр("Назначение", Текущееназначение);						   
			ТЗ = Запрос.Выполнить().Выгрузить();			
		КонецЕсли;
		Если ТЗ.Количество() = 0 Тогда	
			СделатьОсновным(Телефон, Текущееназначение, ТекущаяПривязка, Ложь)
		КонецЕсли;
	КонецЕсли;
	
	Если ИскатьВКонтактнойИнформации Тогда
	КонецЕсли;	
	
КонецПроцедуры


Процедура СделатьОсновным(СимКарта, Назначение, Абонент, Проверка = Истина) Экспорт
		
	МенеджерЗаписи = РегистрыСведений.ОсновныеТелефоны.СоздатьМенеджерЗаписи(); 
	МенеджерЗаписи.Привязка   = Абонент; 
	МенеджерЗаписи.Назначение = Назначение; 
	МенеджерЗаписи.Телефон = СимКарта; 
	МенеджерЗаписи.Записать();
	
	Если Строка(Строка(ТипЗнч(Абонент))) = "Физические лица" И Назначение = Справочники.НазначенияИспользованияSIMКарт.СлужебныйТелефон  Тогда
		МенеджерЗаписи = РегистрыСведений.КонтактнаяИнформация.СоздатьМенеджерЗаписи(); 
		МенеджерЗаписи.Объект	= Абонент; 
		МенеджерЗаписи.Тип		= Перечисления.ТипыКонтактнойИнформации.Телефон; 
		МенеджерЗаписи.Вид		= Справочники.ВидыКонтактнойИнформации.ТелефонСлужебный;
		МенеджерЗаписи.Представление = СимКарта.Код;
		МенеджерЗаписи.Записать();
	КонецЕсли;
	
	
	Если Проверка Тогда ПроверитьТелефонПоРегистрам(СимКарта) КонецЕсли;	
	
КонецПроцедуры