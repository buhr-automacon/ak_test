﻿//+++АК LAGP 2018.03.09 ИП-00017097.03 Создание.

&НаКлиенте
Процедура ТолькоАктивные(Команда)
	
	Элементы.ТолькоАктивные.Пометка = НЕ Элементы.ТолькоАктивные.Пометка;
	
	Если Элементы.ТолькоАктивные.Пометка Тогда
		НовЭлементОтбора 				= Список.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
		НовЭлементОтбора.ЛевоеЗначение 	= Новый ПолеКомпоновкиДанных("Статус"); 
		НовЭлементОтбора.ВидСравнения 	= ВидСравненияКомпоновкиДанных.НеРавно; 
		НовЭлементОтбора.Использование 	= Истина; 
		НовЭлементОтбора.ПравоеЗначение = Перечисления.СтатусыЗаданийЛаборатории.Выполнено;
		ЭтаФорма.ОбновитьОтображениеДанных();
	Иначе
		Список.Отбор.Элементы.Очистить();
		ЭтаФорма.ОбновитьОтображениеДанных();
	КонецЕсли; 	
	
	//+++АК CISA 2018.11.08 ИП-00020059
	ПроверитьНаличиеПрав();
	//---АК CISA
	
КонецПроцедуры

//+++АК CISA 2018.11.08 ИП-00020059
&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	ПроверитьНаличиеПрав();
КонецПроцедуры

//+++АК CISA 2018.11.08 ИП-00020059
&НаСервере
Процедура ПроверитьНаличиеПрав()
	Если НЕ РольДоступна("Технолог") Тогда
		ЭлементОтбора 					= Список.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
		ЭлементОтбора.ЛевоеЗначение 	= Новый ПолеКомпоновкиДанных("Автор"); 
		ЭлементОтбора.ВидСравнения 		= ВидСравненияКомпоновкиДанных.НеРавно; 
		ЭлементОтбора.Использование 	= Истина; 
		ЭлементОтбора.ПравоеЗначение	= Справочники.Пользователи.НайтиПоНаименованию("ОбменБухия");
		ЭлементОтбора.РежимОтображения 	= РежимОтображенияЭлементаНастройкиКомпоновкиДанных.Недоступный;
	КонецЕсли;
КонецПроцедуры