﻿
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Параметры.Свойство("ТекущееЗначение", ТекущееЗначение);
	Параметры.Свойство("ВидНоменклатуры", ВидНоменклатуры);

	ЗаполнитьДерево();
	
	ОбновитьЗаголовокФормы(Параметры.Поставщик);
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	Если ЗначениеЗаполнено(ТекущееЗначение) Тогда
		УстановитьПозициюТекущегоЗначенияКлиент();
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиДинамическогоСписка

&НаКлиенте
Процедура ДоступнаяНоменклатураВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	
	Если Элемент.ТекущиеДанные.РодительскаяГруппировкаСтроки = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	Закрыть(Новый Структура("Номенклатура, Характеристика, Поставщик", Элемент.ТекущиеДанные.Ссылка, Элемент.ТекущиеДанные.Характеристика, Элемент.ТекущиеДанные.РодительскаяГруппировкаСтроки));

КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ВсяНоменклатура(Команда)
	
	ВсяНоменклатура = Истина;
	
	Элементы.ДоступнаяНоменклатураДерево.ПодчиненныеЭлементы.ДоступнаяНоменклатураДеревоХарактеристика.Видимость = ВсяНоменклатура;
	
	ЗаполнитьДеревоСервер();
	
КонецПроцедуры

#КонецОбласти

#Область ДополнительныеФункцииИПроцедуры

&НаСервере
Процедура УстановитьПараметрыДинамическогоСписка()
	
	Период = ТекущаяДата();
	
	ДоступнаяНоменклатура.Параметры.УстановитьЗначениеПараметра("Период", Период);
	ДоступнаяНоменклатура.Параметры.УстановитьЗначениеПараметра("ТекущийПользователь", Параметры.ТекущийПользователь);
	ДоступнаяНоменклатура.Параметры.УстановитьЗначениеПараметра("ОтборПоПользователю", Параметры.ОтборПоПользователю);
	ДоступнаяНоменклатура.Параметры.УстановитьЗначениеПараметра("ОтборПоПоставщику", Параметры.Поставщик);
	
КонецПроцедуры

&НаКлиенте
Процедура УстановитьПозициюТекущегоЗначенияКлиент()
	
	//В тонком клиенте не отрабатывает метод "Найти строки", для получения актуального идентификатора  
	//строки Динамического списка.
	
	сч = 1; 
	Пока Истина Цикл
		
		Если сч = 1000 Тогда 
			Прервать;
		КонецЕсли;
		
		Попытка
			Если Элементы.ДоступнаяНоменклатура.ДанныеСтроки(сч).Ссылка = ТекущееЗначение Тогда;
				Элементы.ДоступнаяНоменклатура.ТекущаяСтрока = сч;
				Прервать;
			Иначе
				сч = сч + 1;
			КонецЕсли;
		Исключение
			Прервать;
		КонецПопытки;
		
	КонецЦикла;
	
КонецПроцедуры

&НаСервере 
Процедура ОбновитьЗаголовокФормы(Поставщик)
	
	ЭтаФорма.АвтоЗаголовок = Ложь;
	
	ЭтаФорма.Заголовок = СтрЗаменить("#Поставщик", "#Поставщик", 
				(?(ЗначениеЗаполнено(Поставщик), Строка(Поставщик) + "","Все доступные поставщики")));      
	
КонецПроцедуры

&НаСервере 
Процедура ЗаполнитьДерево()
	
	ДеревоЗначенийНоменклатуры = РеквизитФормыВЗначение("ДоступнаяНоменклатураДерево");
	
	ДеревоЗначенийНоменклатуры.Строки.Очистить();
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
	
	"ВЫБРАТЬ РАЗРЕШЕННЫЕ
	|	Таб_ДоступнаяНоменклатура.Номенклатура КАК Ссылка,
	|	Таб_ДоступнаяНоменклатура.Номенклатура.Наименование КАК Наименование,
	|	Таб_ДоступнаяНоменклатура.Номенклатура.Код КАК Код,
	|	Таб_ДоступнаяНоменклатура.Характеристика КАК Характеристика,
	|	Таб_Поставщики.Поставщик КАК Поставщик
	|ИЗ
	|	(ВЫБРАТЬ РАЗЛИЧНЫЕ
	|		ВЫРАЗИТЬ(ДоступныеХарактеристики.Объект КАК Справочник.ХарактеристикиНоменклатуры).Владелец КАК Номенклатура,
	|		ДоступныеХарактеристики.Объект КАК Характеристика
	|	ИЗ
	|		(ВЫБРАТЬ
	|			СоответствиеОбъектРольСрезПоследних.Объект КАК Характеристика
	|		ИЗ
	|			(ВЫБРАТЬ
	|				РолиПользователейСоставРоли.Ссылка КАК ФункциональнаяРоль
	|			ИЗ
	|				Справочник.Пользователи КАК Пользователи
	|					ЛЕВОЕ СОЕДИНЕНИЕ Справочник.РолиПользователей.СоставРоли КАК РолиПользователейСоставРоли
	|						ЛЕВОЕ СОЕДИНЕНИЕ Справочник.РолиПользователей.ТипыРолей КАК РолиПользователейТипыРолей
	|						ПО (РолиПользователейТипыРолей.Ссылка = РолиПользователейСоставРоли.Ссылка)
	|					ПО Пользователи.ФизЛицо = РолиПользователейСоставРоли.Сотрудник
	|			ГДЕ
	|				ВЫБОР
	|						КОГДА &ВсяНоменклатура
	|								ИЛИ &ВидНоменклатуры <> ЗНАЧЕНИЕ(Перечисление.ВидыНоменклатуры.Товар)
	|							ТОГДА ЛОЖЬ
	|						ИНАЧЕ ИСТИНА
	|					КОНЕЦ
	|				И РолиПользователейТипыРолей.ТипРоли.Код = ""TechnologPoKachestvu""
	|				И ВЫБОР
	|						КОГДА &ОтборПоПользователю
	|							ТОГДА Пользователи.Ссылка = &ТекущийПользователь
	|						ИНАЧЕ ИСТИНА
	|					КОНЕЦ
	|			
	|			СГРУППИРОВАТЬ ПО
	|				РолиПользователейСоставРоли.Ссылка
	|			
	|			ОБЪЕДИНИТЬ
	|			
	|			ВЫБРАТЬ
	|				РолиПользователейТипыРолей.Ссылка.Родитель
	|			ИЗ
	|				Справочник.Пользователи КАК Пользователи
	|					ЛЕВОЕ СОЕДИНЕНИЕ Справочник.РолиПользователей.СоставРоли КАК РолиПользователейСоставРоли
	|						ЛЕВОЕ СОЕДИНЕНИЕ Справочник.РолиПользователей.ТипыРолей КАК РолиПользователейТипыРолей
	|						ПО (РолиПользователейТипыРолей.Ссылка = РолиПользователейСоставРоли.Ссылка)
	|					ПО Пользователи.ФизЛицо = РолиПользователейСоставРоли.Сотрудник
	|			ГДЕ
	|				ВЫБОР
	|						КОГДА &ВсяНоменклатура
	|								ИЛИ &ВидНоменклатуры <> ЗНАЧЕНИЕ(Перечисление.ВидыНоменклатуры.Товар)
	|							ТОГДА ЛОЖЬ
	|						ИНАЧЕ ИСТИНА
	|					КОНЕЦ
	|				И ВЫБОР
	|						КОГДА &ОтборПоПользователю
	|							ТОГДА Пользователи.Ссылка = &ТекущийПользователь
	|						ИНАЧЕ ИСТИНА
	|					КОНЕЦ
	|			
	|			СГРУППИРОВАТЬ ПО
	|				РолиПользователейТипыРолей.Ссылка.Родитель) КАК Таб_ФункциональныеРоли
	|				ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.СоответствиеОбъектРоль.СрезПоследних(
	|						&Период,
	|						ТипРолиID = ""TechnologPoKachestvu""
	|							И Объект ССЫЛКА Справочник.ХарактеристикиНоменклатуры) КАК СоответствиеОбъектРольСрезПоследних
	|				ПО Таб_ФункциональныеРоли.ФункциональнаяРоль = СоответствиеОбъектРольСрезПоследних.РольПользователя) КАК Таб_ДоступныеХарактеристики
	|			ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.ЗначенияСвойствОбъектов КАК ДоступныеХарактеристики
	|			ПО Таб_ДоступныеХарактеристики.Характеристика = ДоступныеХарактеристики.Объект
	|				И (ДоступныеХарактеристики.Объект ССЫЛКА Справочник.ХарактеристикиНоменклатуры)
	|	ГДЕ
	|		ВЫРАЗИТЬ(ДоступныеХарактеристики.Объект КАК Справочник.ХарактеристикиНоменклатуры).Неактивная = ЛОЖЬ
	|	
	|	ОБЪЕДИНИТЬ
	|	
	|	ВЫБРАТЬ
	|		ВЫРАЗИТЬ(ДоступныеХарактеристики.Объект КАК Справочник.ХарактеристикиНоменклатуры).Владелец,
	|		ДоступныеХарактеристики.Объект
	|	ИЗ
	|		(ВЫБРАТЬ
	|			СоответствиеОбъектРольСрезПоследних.Объект КАК Контрагент
	|		ИЗ
	|			(ВЫБРАТЬ
	|				РолиПользователейСоставРоли.Ссылка КАК ФункциональнаяРоль
	|			ИЗ
	|				Справочник.Пользователи КАК Пользователи
	|					ЛЕВОЕ СОЕДИНЕНИЕ Справочник.РолиПользователей.СоставРоли КАК РолиПользователейСоставРоли
	|						ЛЕВОЕ СОЕДИНЕНИЕ Справочник.РолиПользователей.ТипыРолей КАК РолиПользователейТипыРолей
	|						ПО (РолиПользователейТипыРолей.Ссылка = РолиПользователейСоставРоли.Ссылка)
	|					ПО Пользователи.ФизЛицо = РолиПользователейСоставРоли.Сотрудник
	|			ГДЕ
	|				ВЫБОР
	|						КОГДА &ВсяНоменклатура
	|								ИЛИ &ВидНоменклатуры <> ЗНАЧЕНИЕ(Перечисление.ВидыНоменклатуры.Товар)
	|							ТОГДА ЛОЖЬ
	|						ИНАЧЕ ИСТИНА
	|					КОНЕЦ
	|				И РолиПользователейТипыРолей.ТипРоли.Код = ""TechnologPoKachestvu""
	|				И ВЫБОР
	|						КОГДА &ОтборПоПользователю
	|							ТОГДА Пользователи.Ссылка = &ТекущийПользователь
	|						ИНАЧЕ ИСТИНА
	|					КОНЕЦ
	|			
	|			СГРУППИРОВАТЬ ПО
	|				РолиПользователейСоставРоли.Ссылка
	|			
	|			ОБЪЕДИНИТЬ
	|			
	|			ВЫБРАТЬ
	|				РолиПользователейТипыРолей.Ссылка.Родитель
	|			ИЗ
	|				Справочник.Пользователи КАК Пользователи
	|					ЛЕВОЕ СОЕДИНЕНИЕ Справочник.РолиПользователей.СоставРоли КАК РолиПользователейСоставРоли
	|						ЛЕВОЕ СОЕДИНЕНИЕ Справочник.РолиПользователей.ТипыРолей КАК РолиПользователейТипыРолей
	|						ПО (РолиПользователейТипыРолей.Ссылка = РолиПользователейСоставРоли.Ссылка)
	|					ПО Пользователи.ФизЛицо = РолиПользователейСоставРоли.Сотрудник
	|			ГДЕ
	|				ВЫБОР
	|						КОГДА &ВсяНоменклатура
	|								ИЛИ &ВидНоменклатуры <> ЗНАЧЕНИЕ(Перечисление.ВидыНоменклатуры.Товар)
	|							ТОГДА ЛОЖЬ
	|						ИНАЧЕ ИСТИНА
	|					КОНЕЦ
	|				И ВЫБОР
	|						КОГДА &ОтборПоПользователю
	|							ТОГДА Пользователи.Ссылка = &ТекущийПользователь
	|						ИНАЧЕ ИСТИНА
	|					КОНЕЦ
	|			
	|			СГРУППИРОВАТЬ ПО
	|				РолиПользователейТипыРолей.Ссылка.Родитель) КАК Таб_ФункциональныеРоли
	|				ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.СоответствиеОбъектРоль.СрезПоследних(
	|						&Период,
	|						ТипРолиID = ""TechnologPoKachestvu""
	|							И Объект ССЫЛКА Справочник.Контрагенты) КАК СоответствиеОбъектРольСрезПоследних
	|				ПО Таб_ФункциональныеРоли.ФункциональнаяРоль = СоответствиеОбъектРольСрезПоследних.РольПользователя) КАК Таб_ДоступныеКонтрагенты
	|			ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.ЗначенияСвойствОбъектов КАК ДоступныеХарактеристики
	|			ПО Таб_ДоступныеКонтрагенты.Контрагент = ДоступныеХарактеристики.Значение
	|				И (ДоступныеХарактеристики.Объект ССЫЛКА Справочник.ХарактеристикиНоменклатуры)
	|	ГДЕ
	|		ВЫРАЗИТЬ(ДоступныеХарактеристики.Объект КАК Справочник.ХарактеристикиНоменклатуры).Неактивная = ЛОЖЬ) КАК Таб_ДоступнаяНоменклатура
	|		ЛЕВОЕ СОЕДИНЕНИЕ (ВЫБРАТЬ
	|			ЦеныПоставщиковСрезПоследних.Номенклатура КАК Номенклатура,
	|			ЦеныПоставщиковСрезПоследних.Характеристика КАК Характеристика,
	|			ЦеныПоставщиковСрезПоследних.Поставщик КАК Поставщик
	|		ИЗ
	|			РегистрСведений.ЦеныПоставщиков.СрезПоследних(
	|					&Период,
	|					ВЫБОР
	|						КОГДА &ОтборПоПоставщику = ЗНАЧЕНИЕ(СПРАВОЧНИК.КОНТРАГЕНТЫ.ПУСТАЯССЫЛКА)
	|							ТОГДА ИСТИНА
	|						ИНАЧЕ Поставщик = &ОтборПоПоставщику
	|					КОНЕЦ) КАК ЦеныПоставщиковСрезПоследних
	|		
	|		СГРУППИРОВАТЬ ПО
	|			ЦеныПоставщиковСрезПоследних.Номенклатура,
	|			ЦеныПоставщиковСрезПоследних.Характеристика,
	|			ЦеныПоставщиковСрезПоследних.Поставщик) КАК Таб_Поставщики
	|		ПО Таб_ДоступнаяНоменклатура.Номенклатура = Таб_Поставщики.Номенклатура
	|			И Таб_ДоступнаяНоменклатура.Характеристика = Таб_Поставщики.Характеристика
	|ГДЕ
	|	Таб_Поставщики.Поставщик <> ЗНАЧЕНИЕ(Справочник.Контрагенты.ПустаяСсылка)
	|	И НЕ Таб_Поставщики.Поставщик.ПометкаУдаления
	|
	|ОБЪЕДИНИТЬ
	|
	|ВЫБРАТЬ
	|	ХарактеристикиНоменклатуры.Владелец,
	|	ХарактеристикиНоменклатуры.Владелец.Наименование,
	|	ХарактеристикиНоменклатуры.Владелец.Код,
	|	ХарактеристикиНоменклатуры.Ссылка,
	|	ЗНАЧЕНИЕ(Справочник.Контрагенты.ПустаяСсылка)
	|ИЗ
	|	Справочник.ХарактеристикиНоменклатуры КАК ХарактеристикиНоменклатуры
	|ГДЕ
	|	ВЫБОР
	|			КОГДА &ВсяНоменклатура
	|				ТОГДА ИСТИНА
	|			ИНАЧЕ ЛОЖЬ
	|		КОНЕЦ
	|	И НЕ ХарактеристикиНоменклатуры.ПометкаУдаления
	|	И ХарактеристикиНоменклатуры.Неактивная = ЛОЖЬ
	|	И ХарактеристикиНоменклатуры.Владелец.НеВедетсяУчетПоХарактеристикам = ЛОЖЬ
	|
	|ОБЪЕДИНИТЬ ВСЕ
	|
	|ВЫБРАТЬ
	|	Таб_Характеристики.Ссылка,
	|	Таб_Характеристики.Наименование,
	|	Таб_Характеристики.Код,
	|	Таб_Характеристики.Характеристика,
	|	Таб_Поставщики.Поставщик
	|ИЗ
	|	(ВЫБРАТЬ
	|		Номенклатура.Ссылка КАК Ссылка,
	|		Номенклатура.Наименование КАК Наименование,
	|		Номенклатура.Код КАК Код,
	|		ЕСТЬNULL(ХарактеристикиНоменклатуры.Ссылка, ЗНАЧЕНИЕ(Справочник.ХарактеристикиНоменклатуры.ПустаяСсылка)) КАК Характеристика
	|	ИЗ
	|		Справочник.Номенклатура КАК Номенклатура
	|			ЛЕВОЕ СОЕДИНЕНИЕ Справочник.ХарактеристикиНоменклатуры КАК ХарактеристикиНоменклатуры
	|			ПО Номенклатура.Ссылка = ХарактеристикиНоменклатуры.Владелец
	|				И (ХарактеристикиНоменклатуры.Неактивная = ЛОЖЬ)
	|				И (Номенклатура.НеВедетсяУчетПоХарактеристикам = ЛОЖЬ)
	|	ГДЕ
	|		ВЫБОР
	|				КОГДА &ВсяНоменклатура
	|					ТОГДА ЛОЖЬ
	|				ИНАЧЕ &ВидНоменклатуры <> ЗНАЧЕНИЕ(Перечисление.ВидыНоменклатуры.Товар)
	|						И ВЫБОР
	|							КОГДА &ВидНоменклатуры = ЗНАЧЕНИЕ(Перечисление.ВидыНоменклатуры.Материал)
	|								ТОГДА Номенклатура.ТипТовара = ЗНАЧЕНИЕ(Перечисление.ТипыТоваров.Упаковка)
	|							ИНАЧЕ Номенклатура.ВидНоменклатуры = &ВидНоменклатуры
	|						КОНЕЦ
	|						И НЕ Номенклатура.ПометкаУдаления
	|			КОНЕЦ) КАК Таб_Характеристики
	|		ЛЕВОЕ СОЕДИНЕНИЕ (ВЫБРАТЬ
	|			ЦеныПоставщиковСрезПоследних.Номенклатура КАК Номенклатура,
	|			ЦеныПоставщиковСрезПоследних.Характеристика КАК Характеристика,
	|			ЦеныПоставщиковСрезПоследних.Поставщик КАК Поставщик
	|		ИЗ
	|			РегистрСведений.ЦеныПоставщиков.СрезПоследних(
	|					&Период,
	|					ВЫБОР
	|						КОГДА &ОтборПоПоставщику = ЗНАЧЕНИЕ(СПРАВОЧНИК.КОНТРАГЕНТЫ.ПУСТАЯССЫЛКА)
	|							ТОГДА ВЫБОР
	|									КОГДА &ВидНоменклатуры = ЗНАЧЕНИЕ(Перечисление.ВидыНоменклатуры.Материал)
	|										ТОГДА Номенклатура.ТипТовара = ЗНАЧЕНИЕ(Перечисление.ТипыТоваров.Упаковка)
	|									КОГДА &ВидНоменклатуры = ЗНАЧЕНИЕ(Перечисление.ВидыНоменклатуры.Оборудование)
	|										ТОГДА Номенклатура.ВидНоменклатуры = &ВидНоменклатуры
	|									ИНАЧЕ ЛОЖЬ
	|								КОНЕЦ
	|						ИНАЧЕ Поставщик = &ОтборПоПоставщику
	|					КОНЕЦ) КАК ЦеныПоставщиковСрезПоследних
	|		
	|		СГРУППИРОВАТЬ ПО
	|			ЦеныПоставщиковСрезПоследних.Номенклатура,
	|			ЦеныПоставщиковСрезПоследних.Характеристика,
	|			ЦеныПоставщиковСрезПоследних.Поставщик) КАК Таб_Поставщики
	|		ПО Таб_Характеристики.Ссылка = Таб_Поставщики.Номенклатура
	|ГДЕ
	|	Таб_Поставщики.Поставщик <> ЗНАЧЕНИЕ(Справочник.Контрагенты.ПустаяСсылка)
	|	И НЕ Таб_Поставщики.Поставщик.ПометкаУдаления
	|
	|УПОРЯДОЧИТЬ ПО
	|	Поставщик,
	|	Наименование
	|ИТОГИ ПО
	|	Поставщик
	|АВТОУПОРЯДОЧИВАНИЕ";
	
	Если ВсяНоменклатура Тогда
		Запрос.УстановитьПараметр("Период", ТекущаяДата());
		Запрос.УстановитьПараметр("ТекущийПользователь", Справочники.Пользователи.ПустаяСсылка());
		Запрос.УстановитьПараметр("ОтборПоПользователю", Истина);
		Запрос.УстановитьПараметр("ОтборПоПоставщику", Справочники.Контрагенты.ПустаяСсылка());
		Запрос.УстановитьПараметр("ТипРолиТехнолог", Перечисления.ТипыРолейПользователейМОС.Технолог);
	Иначе
		Запрос.УстановитьПараметр("Период", ТекущаяДата());
		Запрос.УстановитьПараметр("ТекущийПользователь", Параметры.ТекущийПользователь);
		Запрос.УстановитьПараметр("ОтборПоПользователю", Параметры.ОтборПоПользователю);
		Запрос.УстановитьПараметр("ОтборПоПоставщику",   Параметры.Поставщик);
		Запрос.УстановитьПараметр("ТипРолиТехнолог",  Перечисления.ТипыРолейПользователейМОС.Технолог);
	КонецЕсли;
	
	Запрос.УстановитьПараметр("ВсяНоменклатура", ВсяНоменклатура);
	Запрос.УстановитьПараметр("ВидНоменклатуры", ВидНоменклатуры);
	
	РезультатЗапроса = Запрос.Выполнить();
	
	ВыборкаПоставщик = РезультатЗапроса.Выбрать(ОбходРезультатаЗапроса.ПоГруппировкам);
	
	Пока ВыборкаПоставщик.Следующий() Цикл
		
		СтрокаПоставщик = ДеревоЗначенийНоменклатуры.Строки.Добавить(); 
		
		СтрокаПоставщик.Ссылка = ВыборкаПоставщик.Поставщик;

		ВыборкаДетальныеЗаписи = ВыборкаПоставщик.Выбрать();
	
		Пока ВыборкаДетальныеЗаписи.Следующий() Цикл
			ЗаполнитьЗначенияСвойств(СтрокаПоставщик.Строки.Добавить(), ВыборкаДетальныеЗаписи);			
		КонецЦикла;
		
	КонецЦикла;
	
	ЗначениеВРеквизитФормы(ДеревоЗначенийНоменклатуры, "ДоступнаяНоменклатураДерево");
	
КонецПроцедуры

&НаСервере 
Процедура ЗаполнитьДеревоСервер()
	
	ЗаполнитьДерево();
	
	ОбновитьЗаголовокФормы(Неопределено);
	
КонецПроцедуры

&НаКлиенте
Процедура ДоступнаяНоменклатураДеревоВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	
	Если НЕ ЗначениеЗаполнено(Элемент.ТекущиеДанные.Характеристика) И ВидНоменклатуры = ПредопределенноеЗначение("Перечисление.ВидыНоменклатуры.Товар") Тогда
		Возврат;
	КонецЕсли;
	
	Закрыть(Новый Структура("Номенклатура, Характеристика, Поставщик, ВсяНоменклатура", Элемент.ТекущиеДанные.Ссылка, 
						Элемент.ТекущиеДанные.Характеристика, Элементы.ДоступнаяНоменклатураДерево.ТекущиеДанные.ПолучитьРодителя().Ссылка, ВсяНоменклатура));
	
КонецПроцедуры

#КонецОбласти

