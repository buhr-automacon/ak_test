﻿
//+++АК SHEP 2018.09.24 ИП-00019906: добавлена форма
 
&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	ОбновитьСписокНаСервере();
	
КонецПроцедуры

&НаСервере
Процедура ОбновитьСписокНаСервере()
	
	ТЗн = УправлениеКонтактнойИнформацией.НеподтверждённыеАдресаТТПомощникаТУ();
	НеподтверждённыеАдреса.Загрузить(ТЗн);
	
КонецПроцедуры

&НаКлиенте
Процедура ОбновитьСписок(Команда)
	ОбновитьСписокНаСервере();
КонецПроцедуры

&НаСервере
Процедура ПодтвердитьНаСервере(Магазин)
	
	СтруктураДанных = Новый Структура("Объект", Магазин);
	СтруктураДанных.Вставить("Вид", ПредопределенноеЗначение("Справочник.ВидыКонтактнойИнформации.ФактАдресСтруктурнойЕдиницы"));
	СтруктураДанных.Вставить("Тип", ПредопределенноеЗначение("Перечисление.ТипыКонтактнойИнформации.Адрес"));
	СтруктураДанных.Вставить("Комментарий", "");
	
	УправлениеКонтактнойИнформацией.ЗаписатьКонтактнуюИнформациюИзСтруктуры(СтруктураДанных);
	
	ОбновитьСписокНаСервере();
	
КонецПроцедуры

&НаКлиенте
Процедура Подтвердить(Команда)
	
	ТекущиеДанные = Элементы.НеподтверждённыеАдреса.ТекущиеДанные;
	Если ТекущиеДанные = Неопределено Тогда Возврат; КонецЕсли;
	
	ПодтвердитьНаСервере(ТекущиеДанные.Магазин);
	
КонецПроцедуры

&НаКлиенте
Процедура НеподтверждённыеАдресаВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	
	ТекущиеДанные = Элемент.ТекущиеДанные;
	Если ТекущиеДанные = Неопределено Тогда Возврат; КонецЕсли;
	
	Если Поле.Имя = "НеподтверждённыеАдресаАдресМагазина" Тогда
		ВидКИ = ПредопределенноеЗначение("Справочник.ВидыКонтактнойИнформации.ФактАдресСтруктурнойЕдиницы");
		ПараметрыОткрытия = Новый Структура;
		ПараметрыОткрытия.Вставить("ВидКонтактнойИнформации", ВидКИ);
		ПараметрыОткрытия.Вставить("ТолькоПросмотр", Ложь);
		ПараметрыОткрытия.Вставить("Представление", ТекущиеДанные.АдресМагазина);
		ПараметрыОткрытия.Вставить("Комментарий", "");
		
		ДопПараметры = Новый Структура("Объект", ТекущиеДанные.Магазин);
		ДопПараметры.Вставить("Вид", ВидКИ);
		ДопПараметры.Вставить("Тип", ПредопределенноеЗначение("Перечисление.ТипыКонтактнойИнформации.Адрес"));
		//ЗаполнитьДопПараметрыВводКонтактнойИнформацииНаСервере(ДопПараметры);
		Оповещение = Новый ОписаниеОповещения("ЗаписьКонтактнойИнформацииИзВводКонтактнойИнформации", ОбщегоНазначенияКлиент.ОбщийМодуль("УправлениеКонтактнойИнформациейКлиент"), ДопПараметры);
		
		УправлениеКонтактнойИнформациейКлиент.ОткрытьФормуКонтактнойИнформации(ПараметрыОткрытия, , , , Оповещение);
	Иначе
		ПоказатьЗначение(, ТекущиеДанные.Магазин);
	КонецЕсли;
	
КонецПроцедуры
