﻿
&НаКлиенте
Процедура ОбработкаКоманды(ПараметрКоманды, ПараметрыВыполненияКоманды)
	//Вставить содержимое обработчика.
	
	Если ТипЗнч(ПараметрКоманды)=Тип("ДокументСсылка.ЗаявкаНаУслугиМатериалы") Тогда
		Магазин = ПараметрКоманды.Услуги.Выгрузить().ВыгрузитьКолонку("СтруктурнаяЕдиница");
	ИначеЕсли ТипЗнч(ПараметрКоманды)=Тип("ДокументСсылка.КомплектацияМагазинаПоСделкамСПоставщиком") Тогда
		Магазин = ПараметрКоманды.Магазин;	
	КонецЕсли;
	Отбор = Новый Структура;
	Отбор.Вставить("Магазин",Магазин);
	
	ПараметрыФормы = Новый Структура("Отбор,СФормироватьПриОткрытии",Отбор,Истина );
	ОткрытьФорму("Отчет.УслугиКомплектацийПоТТ.Форма", ПараметрыФормы, ПараметрыВыполненияКоманды.Источник, ПараметрыВыполненияКоманды.Уникальность, ПараметрыВыполненияКоманды.Окно);
КонецПроцедуры
