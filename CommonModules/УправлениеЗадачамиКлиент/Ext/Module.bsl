﻿///////////////////////////////////////////////////////////////////////////////
// ПРОЦЕДУРЫ И ФУНКЦИИ ВЫПОЛНЕНИЯ ЗАДАЧ

Процедура ВыполнитьВыбраннуюЗадачу(Задача) Экспорт
	
	//Запрос = Новый Запрос;
	//Запрос.УстановитьПараметр("Ссылка",	Задача);
	//Запрос.Текст =
	//"ВЫБРАТЬ
	//|	Задачи.ВидЗадачи,
	//|	Задачи.ОбъектЗадачи,
	//|	Задачи.Дата КАК ДатаЗадачи
	//|ИЗ
	//|	Задача.ЗадачаИсполнителя КАК Задачи
	//|ГДЕ
	//|	Задачи.Ссылка = &Ссылка";
	//Выборка = Запрос.Выполнить().Выбрать();
	//Если Не Выборка.Следующий() Тогда
	//	Возврат;
	//КонецЕсли;
	//
	//ВидЗадачи			= Выборка.ВидЗадачи;
	//ОбъектЗадачи		= Выборка.ОбъектЗадачи;
	//ДатаЗадачи			= Выборка.ДатаЗадачи;
	//
	//Если ВидЗадачи = Справочники.ВидыЗадачПользователей.ДеньРождения Тогда
	//	ЗадачаДеньРождения(ОбъектЗадачи);
	//	
	//	Результат = УправлениеЗадачамиКлиентПереопределяемый.ВыполнитьЗадачи(ВидЗадачи, ОбъектЗадачи, ДатаЗадачи);
	//	
	//	Если Не Результат Тогда
	//		Задача.ПолучитьФорму().Открыть();
	//	КонецЕсли;
	//	
	//КонецЕсли;
	
	обЗадача = Задача.ПолучитьОбъект();
	обЗадача.ВыполнитьЗадачу();
	обЗадача.Записать();
	
КонецПроцедуры

///////////////////////////////////////////////////////////////////////////////
// ПРОЦЕДУРЫ И ФУНКЦИИ ВЫПОЛНЕНИЯ ЗАДАЧ ЗАРПЛАТНО-КАДРОВОЙ ФУНКЦИОНАЛЬНОСТИ


Процедура ЗадачаДеньРождения(ОбъектЗадачи)
	
	ФормаЭлемента = ОбъектЗадачи.ПолучитьФорму();
	ФормаЭлемента.Открыть();
	
КонецПроцедуры

Процедура ЗадачаДоначисление(ОбъектЗадачи, ДатаЗадачи)
	
	Запрос = Новый Запрос;
	
	Запрос.УстановитьПараметр("Сотрудник",		ОбъектЗадачи);
	Запрос.УстановитьПараметр("ДатаНачала",		НачалоМесяца(ДатаЗадачи));
	Запрос.УстановитьПараметр("ДатаОкончания",	КонецМесяца(ДатаЗадачи));
	
	Запрос.Текст = 
	"ВЫБРАТЬ ПЕРВЫЕ 1
	|	Доначисления.Сотрудник КАК Ссылка,
	|	Доначисления.ДатаНачала КАК ДатаНачала,
	|	Доначисления.ДатаОкончания КАК ДатаОкончания,
	|	Доначисления.Организация
	|ИЗ
	|	РегистрСведений.ДоначисленияСотрудникам КАК Доначисления
	|ГДЕ
	|	Доначисления.Сотрудник = &Сотрудник
	|	И Доначисления.ДатаНачала >= &ДатаНачала
	|	И Доначисления.ДатаОкончания <= &ДатаОкончания";
	
	Выборка = Запрос.Выполнить().Выбрать();
	
	Если Не Выборка.Следующий() Тогда
		Возврат;
	КонецЕсли;
	
	ДокументДоначисление = Документы.НачислениеЗарплатыРаботникамОрганизаций.СоздатьДокумент();
	ДокументДоначисление.Организация					= Выборка.Организация;
	
	ЗаполнениеДокументовПереопределяемый.ЗаполнитьШапкуДокумента(ДокументДоначисление, глЗначениеПеременной("глТекущийПользователь"));
	
	СписокСотрудников = Новый Массив;
	СписокСотрудников.Добавить(ОбъектЗадачи);
	
	ДокументДоначисление.ПериодНачисления				= Перечисления.ПериодНачисленияЗарплаты.ПрошлыйПериод;
	ДокументДоначисление.ПериодНачисленияДатаНачала		= Выборка.ДатаНачала;
	ДокументДоначисление.ПериодНачисленияДатаОкончания	= Выборка.ДатаОкончания;
	ДокументДоначисление.ВыполнитьАвтозаполнение(
	ДокументДоначисление.ПериодНачисленияДатаНачала, 
	ДокументДоначисление.ПериодНачисленияДатаОкончания,,,,
	СписокСотрудников);
	
	ФормаДокумента = ДокументДоначисление.ПолучитьФорму();
	ФормаДокумента.Открыть();
	
КонецПроцедуры


#Если Клиент Тогда

// Процедура открывает форму обработки НастройкаПрограммы на нужной странице
//
// Параметры
//		ИмяСтраницы - строка с именем страницы, на которой необходимо открыть форму
//		СтруктураПараметрыФормы - структура, содержит параметры которые необходимо передать в форму
//					или значения реквизитов обработки.
//					Ключ - имя реквизита формы или экспортной переменной, значение - его значение
//
Процедура ОткрытьФормуНастройкаПрограммы(ИмяСтраницы = Неопределено, СтруктураПараметрыФормы = Неопределено) Экспорт
	
	Если ИмяСтраницы = Неопределено Тогда
		Возврат;
	ИначеЕсли ТипЗнч(ИмяСтраницы) = Тип("Массив") Тогда
		МассивПараметров = ИмяСтраницы;
		СтруктураПараметрыФормы = ?(МассивПараметров.Количество() = 2, МассивПараметров[1], Неопределено);
		ИмяСтраницыФормы = ?(МассивПараметров.Количество() > 0, МассивПараметров[0], Неопределено);
	Иначе
		ИмяСтраницыФормы = ИмяСтраницы;
	КонецЕсли;
	
	Если ИмяСтраницыФормы = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	Форма = Обработки.НастройкиПрограммы.ПолучитьФорму("НастройкаПрограммы");
	Если СтруктураПараметрыФормы <> Неопределено Тогда
		ЗаполнитьЗначенияСвойств(Форма, СтруктураПараметрыФормы);
	КонецЕсли;
	Форма.Открыть();
	Если Форма.Открыта() Тогда
		Форма.ЭлементыФормы.ПанельРазделов.ТекущаяСтраница = Форма.ЭлементыФормы.ПанельРазделов.Страницы.Найти(ИмяСтраницыФормы);
		Форма.ЭлементыФормы.СписокРазделов.ТекущаяСтрока = Форма.ЭлементыФормы.СписокРазделов.Значение.Найти(ИмяСтраницыФормы);
	КонецЕсли;
	
КонецПроцедуры

#КонецЕсли
