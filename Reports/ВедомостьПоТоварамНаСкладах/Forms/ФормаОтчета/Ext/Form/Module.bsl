﻿
&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	СтруктурноеПодразделение = Параметры.СтруктурноеПодразделение;
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	Если ЗначениеЗаполнено(СтруктурноеПодразделение) Тогда
				
		//СтруктурноеПодразделениеОтбор = Отчет.КомпоновщикНастроек.ПользовательскиеНастройки.Элементы.Найти(Отчет.КомпоновщикНастроек.Настройки.ПараметрыДанных.НайтиЗначениеПараметра(Новый ПараметрКомпоновкиДанных("Структурное подразделение")).ИдентификаторПользовательскойНастройки);
		Отчет.КомпоновщикНастроек.ПользовательскиеНастройки.Элементы[3].ПравоеЗначение = СтруктурноеПодразделение;
		//Отчет.КомпоновщикНастроек.Настройки.Отбор.Элементы[2].ПравоеЗначение = СтруктурноеПодразделение;
		//СтруктурноеПодразделениеОтбор.Значение = СтруктурноеПодразделение;
		Отчет.КомпоновщикНастроек.ПользовательскиеНастройки.Элементы[3].Использование = Истина;
		
		ПараметрПериода = Отчет.КомпоновщикНастроек.ПользовательскиеНастройки.Элементы.Найти(Отчет.КомпоновщикНастроек.Настройки.ПараметрыДанных.НайтиЗначениеПараметра(Новый ПараметрКомпоновкиДанных("Период")).ИдентификаторПользовательскойНастройки);
		ПараметрПериода.Значение.ДатаНачала = НачалоМесяца(ТекущаяДата());
		ПараметрПериода.Значение.ДатаОкончания = КонецМесяца(ТекущаяДата());
	    ПараметрПериода.Использование = Истина;
		
		//СкомпоноватьРезультат();
	КонецЕсли;	
	
КонецПроцедуры


