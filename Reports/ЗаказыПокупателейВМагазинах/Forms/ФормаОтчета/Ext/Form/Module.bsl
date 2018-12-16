﻿
&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	УстановитьПривилегированныйРежим(Истина);
	Отчёт.Магазин = ПараметрыСеанса.ТорговаяТочкаПоАйпи;
	НомерТочкиПоАйпи = ПараметрыСеанса.НомерТочкиПоАйпи;
	ЭтоПродавецТолькоПросмотр = РольДоступна("ПродавецТолькоПросмотр");
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	Если ЗначениеЗаполнено(Параметры.Магазин) Тогда
		Отчёт.Магазин = Параметры.Магазин;
	КонецЕсли;
	
	Для Каждого ПользПоле Из Отчёт.КомпоновщикНастроек.ПользовательскиеНастройки.Элементы Цикл
		Если ТипЗнч(ПользПоле) = Тип("ЗначениеПараметраНастроекКомпоновкиДанных") Тогда
			ИмяПараметра = Строка(ПользПоле.Параметр);
			Если ИмяПараметра = "Магазин" Тогда
				ПользПоле.Значение = Отчёт.Магазин;
				ПользПоле.Использование = ЗначениеЗаполнено(Отчёт.Магазин);
				РежимОтображенияПараметра = ?(ЗначениеЗаполнено(Отчёт.Магазин) И НомерТочкиПоАйпи <> 999 И НЕ ЭтоПродавецТолькоПросмотр, "Недоступный", "БыстрыйДоступ");
				ПользПоле.РежимОтображения = РежимОтображенияЭлементаНастройкиКомпоновкиДанных[РежимОтображенияПараметра];
			ИначеЕсли ИмяПараметра = "Период" Тогда
				Если ЗначениеЗаполнено(Параметры.ДатаНачала) ИЛИ ЗначениеЗаполнено(Параметры.ДатаОкончания) Тогда
					ПользПоле.Значение = Новый СтандартныйПериод(Параметры.ДатаНачала, Параметры.ДатаОкончания);
					ПользПоле.Использование = Истина;
				КонецЕсли;
			КонецЕсли;
		КонецЕсли;
	КонецЦикла;
	
	Если Параметры.СформироватьПриОткрытии Тогда
		СкомпоноватьРезультат(РежимКомпоновкиРезультата.Фоновый);
	КонецЕсли;
	
КонецПроцедуры
