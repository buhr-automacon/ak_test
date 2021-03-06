﻿
&НаКлиенте
Процедура УстановитьБухгалтераРасчетчика(Команда)
	
	Если Не ПроверитьЗаполнение()Тогда
		Возврат;
	КонецЕсли;
	
	ПараметрыОткрытия = Новый Структура("Период, ГоловноеПодразделение, ТипПомощника", Объект.Период, Объект.СтруктурнаяЕдиница, "БухгалтерРасчетчик");
	
	ОткрытьФорму("Обработка.ГрафикРаботыПродавцов_ТЗ.Форма.ФормаУстановкаПомощниковПродавцов", ПараметрыОткрытия, ЭтаФорма);	
	
КонецПроцедуры

&НаКлиенте
Процедура ОтчетЛистыУчетаРасчетчиков(Команда)
	
	ОткрытьФорму("Отчет.ОтчетЛистыУчетаБухгалтеровРасчетчиков.Форма.ФормаОтчета",, ЭтаФорма);	
	
КонецПроцедуры

&НаКлиенте
Процедура БухгалтераРасчетчики(Команда)
	
	ПараметрыОткрытия = Новый Структура("ГоловноеПодразделение", Объект.СтруктурнаяЕдиница);
	ОткрытьФорму("РегистрСведений.БухгалтераРасчетчикиВТорговыхТочках.Форма.ФормаСпискаУправляемая", ПараметрыОткрытия, ЭтаФорма);		
	
КонецПроцедуры

&НаКлиенте
Процедура СтруктурнаяЕдиницаНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	//открыть форму выбора структурных единиц
	ПараметрыОтбора = Новый Структура("НаименованиеГруппы", "Управление розницей.");
	Результат = ОткрытьФормуМодально("Обработка.ГрафикРаботыПродавцов_ТЗ.Форма.ФормаВыбораСтруктурнойЕдиницы", ПараметрыОтбора);
	
	Если Результат <> Неопределено Тогда
		
		Объект.СтруктурнаяЕдиница = Результат;
		
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Элементы.УстановитьБухгалтераРасчетчика.Доступность = УправлениеДопПравамиПользователей.ПолучитьПравоПользователяУпр(ПланыВидовХарактеристик.ПраваПользователей.РедактированиеПривязокТорговыхТочекКБухгалтерамРасчетчикам, Ложь);
	
КонецПроцедуры
