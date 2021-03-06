﻿
&НаКлиенте
Процедура ЗаписатьИзменения(Команда)
	
	Если Модифицированность Тогда
		
		Изменения = Новый Структура;
		Изменения.Вставить("Подтверждено", Подтверждено);
		Изменения.Вставить("ДатаОтраженияВФинУчете", ?(Подтверждено, ДатаОтраженияВФинУчете, Дата(1,1,1)));
		Изменения.Вставить("Организация", Организация);
		
		Закрыть(Изменения);
		
	Иначе
		Закрыть(Неопределено);
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Подтверждено 			= Параметры.Подтверждено;
	ДатаОтраженияВФинУчете 	= Параметры.ДатаОтраженияВФинУчете;
	Организация 			= Параметры.Организация;
	ВидОперации				= Параметры.ВидОперации;
	
	УстановитьВидимостьДоступностьРеквизитовФормы();
	
КонецПроцедуры

&НаСервере
Процедура УстановитьВидимостьДоступностьРеквизитовФормы()
	
	Если ВидОперации = Перечисления.ВидыОперацийРасходСкладскойУчет.ОтгрузкаТехнологу
			ИЛИ ВидОперации = Перечисления.ВидыОперацийРасходСкладскойУчет.Утилизация 
			ИЛИ ВидОперации = Перечисления.ВидыОперацийРасходСкладскойУчет.УтилизацияБой
			ИЛИ ВидОперации = Перечисления.ВидыОперацийРасходСкладскойУчет.СписаниеНаНуждыСклада Тогда
	
		Элементы.ДатаОтраженияВФинУчете.Видимость = Подтверждено;
		
	Иначе
		
		Элементы.ДатаОтраженияВФинУчете.Видимость = Ложь;
		Элементы.Подтверждено.Видимость = Ложь;
		
	КонецЕсли;
	
	Элементы.ФормаЗаписатьИзменения.Доступность = Модифицированность;
	
КонецПроцедуры

&НаКлиенте
Процедура ПодтвержденоПриИзменении(Элемент)
	
	Модифицированность = Истина;
	УстановитьВидимостьДоступностьРеквизитовФормы();
	
КонецПроцедуры

&НаКлиенте
Процедура ДатаОтраженияВФинУчетеПриИзменении(Элемент)
	
	Модифицированность = Истина;
	УстановитьВидимостьДоступностьРеквизитовФормы();
	
КонецПроцедуры

&НаКлиенте
Процедура ОрганизацияПриИзменении(Элемент)
	
	Модифицированность = Истина;
	УстановитьВидимостьДоступностьРеквизитовФормы();
	
КонецПроцедуры
