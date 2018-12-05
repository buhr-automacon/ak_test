﻿
&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)

	Параметры.Свойство("Режим", Режим);
	
	Если Режим = "С остатками по складу" Тогда
	
		Список.ТекстЗапроса =
		"ВЫБРАТЬ
		|	СправочникНоменклатура.Наименование КАК Наименование,
		|	ВложенныйЗапрос.КоличествоОстаток
		|ИЗ
		|	Справочник.Номенклатура КАК СправочникНоменклатура
		|		ЛЕВОЕ СОЕДИНЕНИЕ (ВЫБРАТЬ
		|			ТоварыНаСкладахОстатки.Номенклатура КАК Номенклатура,
		|			ТоварыНаСкладахОстатки.КоличествоОстаток КАК КоличествоОстаток
		|		ИЗ
		|			РегистрНакопления.ТоварыНаСкладах.Остатки(, Склад = &Склад) КАК ТоварыНаСкладахОстатки) КАК ВложенныйЗапрос
		|		ПО СправочникНоменклатура.Ссылка = ВложенныйЗапрос.Номенклатура
		|ГДЕ
		|	СправочникНоменклатура.ПометкаУдаления = ЛОЖЬ
		|	И СправочникНоменклатура.ЭтоГруппа = ЛОЖЬ";
		
		Список.Параметры.УстановитьЗначениеПараметра("Склад",	Параметры.Склад);
		//Список.Параметры.УстановитьЗначениеПараметра("Дата",	Параметры.Дата);
		ЕстьОтборПоОстаткам	= Истина;
		ТолькоСОстатками	= Истина;
		СкладНаименование	= Строка(Параметры.Склад);
	
	ИначеЕсли Режим = "По товарному ассортименту"
			И Параметры.Свойство("ТорговаяТочка")
			И ЗначениеЗаполнено(Параметры.ТорговаяТочка) Тогда
		
		Список.ТекстЗапроса =
		"ВЫБРАТЬ
		|	СправочникНоменклатура.Ссылка КАК Ссылка,
		|	СправочникНоменклатура.ПометкаУдаления КАК ПометкаУдаления,
		|	СправочникНоменклатура.Предопределенный КАК Предопределенный,
		|	СправочникНоменклатура.Родитель КАК Родитель,
		|	СправочникНоменклатура.ЭтоГруппа КАК ЭтоГруппа,
		|	СправочникНоменклатура.Код КАК Код,
		|	СправочникНоменклатура.Наименование КАК Наименование,
		|	СправочникНоменклатура.Артикул КАК Артикул,
		|	СправочникНоменклатура.БазоваяЕдиницаИзмерения КАК БазоваяЕдиницаИзмерения
		|ИЗ
		|	Справочник.Номенклатура КАК СправочникНоменклатура
		|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ РегистрСведений.ТоварныйАссортиментТочек.СрезПоследних(, ТорговаяТочка = &ТорговаяТочка) КАК ТоварныйАссортимент
		|		ПО (ТоварныйАссортимент.Номенклатура = СправочникНоменклатура.Ссылка)
		|			И (НЕ ТоварныйАссортимент.Выведена)
		|ГДЕ
		|	НЕ СправочникНоменклатура.ПометкаУдаления";
		Список.Параметры.УстановитьЗначениеПараметра("ТорговаяТочка", Параметры.ТорговаяТочка);
		
	ИначеЕсли (Параметры.Свойство("Склад")
			И ЗначениеЗаполнено(Параметры.Склад)
			И Параметры.Склад.ВидСклада = Перечисления.ВидыСкладов.Оптовый)
			И НЕ Параметры.Склад.ЭтоЗонаОтгрузки Тогда
		
		Список.ТекстЗапроса =
		"ВЫБРАТЬ
		|	СправочникНоменклатура.Ссылка КАК Ссылка,
		|	СправочникНоменклатура.ПометкаУдаления КАК ПометкаУдаления,
		|	СправочникНоменклатура.Предопределенный КАК Предопределенный,
		|	СправочникНоменклатура.Родитель КАК Родитель,
		|	СправочникНоменклатура.ЭтоГруппа КАК ЭтоГруппа,
		|	СправочникНоменклатура.Код КАК Код,
		|	СправочникНоменклатура.Наименование КАК Наименование,
		|	СправочникНоменклатура.Артикул КАК Артикул,
		|	СправочникНоменклатура.БазоваяЕдиницаИзмерения КАК БазоваяЕдиницаИзмерения,
		|	ВЫБОР
		|		КОГДА СправочникНоменклатура.ЭтоГруппа
		|			ТОГДА 0
		|		ИНАЧЕ ЕСТЬNULL(ВЗ_Запрос.КоличествоОстаток, 0)
		|	КОНЕЦ КАК КоличествоОстаток
		|ИЗ
		|	Справочник.Номенклатура КАК СправочникНоменклатура
		|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ (ВЫБРАТЬ РАЗЛИЧНЫЕ
		|			ВложенныйЗапрос.Ссылка КАК Ссылка,
		|			ВложенныйЗапрос.КоличествоОстаток КАК КоличествоОстаток
		|		ИЗ
		|			(ВЫБРАТЬ
		|				СправочникНоменклатура.Ссылка КАК Ссылка,
		|				ЕСТЬNULL(ТоварыНаСкладахОстатки.КоличествоОстаток, 0) КАК КоличествоОстаток
		|			ИЗ
		|				(ВЫБРАТЬ
		|					СправочникНоменклатура.Ссылка КАК Ссылка
		|				ИЗ
		|					РегистрСведений.ДоступностьТоваровНаСкладах КАК ДоступностьТоваровНаСкладах
		|						ЛЕВОЕ СОЕДИНЕНИЕ Справочник.Номенклатура КАК СправочникНоменклатура
		|						ПО ДоступностьТоваровНаСкладах.Номенклатура = СправочникНоменклатура.Ссылка
		|				ГДЕ
		|					ДоступностьТоваровНаСкладах.Склад = &Склад
		|				
		|				ОБЪЕДИНИТЬ ВСЕ
		|				
		|				ВЫБРАТЬ
		|					СправочникНоменклатура.Ссылка
		|				ИЗ
		|					РегистрСведений.ДоступностьНоменклатураВОперацияхОрдеров КАК ДоступностьТоваровНаСкладах
		|						ЛЕВОЕ СОЕДИНЕНИЕ Справочник.Номенклатура КАК СправочникНоменклатура
		|						ПО (ДоступностьТоваровНаСкладах.Номенклатура = СправочникНоменклатура.Ссылка
		|								ИЛИ ДоступностьТоваровНаСкладах.Номенклатура = СправочникНоменклатура.Родитель
		|								ИЛИ ДоступностьТоваровНаСкладах.Номенклатура = СправочникНоменклатура.Родитель.Родитель)
		|				ГДЕ
		|					ДоступностьТоваровНаСкладах.Пользователь = &Пользователь) КАК СправочникНоменклатура
		|					ЛЕВОЕ СОЕДИНЕНИЕ РегистрНакопления.ТоварыНаСкладах.Остатки(, Склад = &Склад) КАК ТоварыНаСкладахОстатки
		|					ПО (ТоварыНаСкладахОстатки.Номенклатура = СправочникНоменклатура.Ссылка)) КАК ВложенныйЗапрос) КАК ВЗ_Запрос
		|		ПО СправочникНоменклатура.Ссылка = ВЗ_Запрос.Ссылка
		|ГДЕ
		|	СправочникНоменклатура.ПометкаУдаления = ЛОЖЬ";
		
		Список.Параметры.УстановитьЗначениеПараметра("Склад"		, Параметры.Склад);
		Список.Параметры.УстановитьЗначениеПараметра("Пользователь"	, ПараметрыСеанса.ТекущийПользователь);
		
		ЕстьОтборПоОстаткам	= Истина;
		
	Иначе
		
		Список.ТекстЗапроса =
		
		"ВЫБРАТЬ РАЗРЕШЕННЫЕ
		|	Пользователи.ФизЛицо,
		|	РолиПользователейСоставРоли.Ссылка КАК ФункциональнаяРоль,
		|	РолиПользователейТипыРолей.ТипРоли КАК ТипРоли,
		|	РолиПользователейТипыРолей.ТипРоли.Код,
		|	РолиПользователейТипыРолей.ТипРоли.Наименование
		|ПОМЕСТИТЬ ВТ_ФункциональныеРоли
		|ИЗ
		|	Справочник.Пользователи КАК Пользователи
		|		ЛЕВОЕ СОЕДИНЕНИЕ Справочник.РолиПользователей.СоставРоли КАК РолиПользователейСоставРоли
		|			ЛЕВОЕ СОЕДИНЕНИЕ Справочник.РолиПользователей.ТипыРолей КАК РолиПользователейТипыРолей
		|			ПО (РолиПользователейТипыРолей.Ссылка = РолиПользователейСоставРоли.Ссылка)
		|		ПО Пользователи.ФизЛицо = РолиПользователейСоставРоли.Сотрудник
		|ГДЕ
		|	РолиПользователейТипыРолей.ТипРоли.Код = ""TechnologPoKachestvu""
		|	И ВЫБОР
		|			КОГДА &ОтборПоПользователю
		|				ТОГДА Пользователи.Ссылка = &ТекущийПользователь
		|			ИНАЧЕ ИСТИНА
		|		КОНЕЦ
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ РАЗРЕШЕННЫЕ
		|	ВЫРАЗИТЬ(СоответствиеОбъектРольСрезПоследних.Объект КАК Справочник.ХарактеристикиНоменклатуры).Владелец КАК Ссылка
		|ПОМЕСТИТЬ ВТ_Номенклатура
		|ИЗ
		|	РегистрСведений.СоответствиеОбъектРоль.СрезПоследних(
		|			&Период {(&Период)},
		|			РольПользователя В
		|					(ВЫБРАТЬ
		|						ВТ_ФункциональныеРоли.ФункциональнаяРоль
		|					ИЗ
		|						ВТ_ФункциональныеРоли КАК ВТ_ФункциональныеРоли)
		|				И Объект ССЫЛКА Справочник.ХарактеристикиНоменклатуры) КАК СоответствиеОбъектРольСрезПоследних
		|
		|СГРУППИРОВАТЬ ПО
		|	ВЫРАЗИТЬ(СоответствиеОбъектРольСрезПоследних.Объект КАК Справочник.ХарактеристикиНоменклатуры).Владелец
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	СправочникНоменклатура.Ссылка КАК Ссылка,
		|	СправочникНоменклатура.ПометкаУдаления КАК ПометкаУдаления,
		|	СправочникНоменклатура.Предопределенный КАК Предопределенный,
		|	СправочникНоменклатура.Родитель КАК Родитель,
		|	СправочникНоменклатура.ЭтоГруппа КАК ЭтоГруппа,
		|	СправочникНоменклатура.Код КАК Код,
		|	СправочникНоменклатура.Наименование КАК Наименование,
		|	СправочникНоменклатура.Артикул КАК Артикул,
		|	СправочникНоменклатура.БазоваяЕдиницаИзмерения КАК БазоваяЕдиницаИзмерения
		|ИЗ
		|	ВТ_Номенклатура КАК ВТ_Номенклатура
		|		ЛЕВОЕ СОЕДИНЕНИЕ Справочник.Номенклатура КАК СправочникНоменклатура
		|		ПО ВТ_Номенклатура.Ссылка = СправочникНоменклатура.Ссылка
		|ГДЕ
		|	НЕ СправочникНоменклатура.ЭтоГруппа
		|	И НЕ СправочникНоменклатура.ПометкаУдаления";
		
		ЕстьОтборПоОстаткам	= Ложь;
		
		Список.Параметры.УстановитьЗначениеПараметра("Период", ТекущаяДата());
		Список.Параметры.УстановитьЗначениеПараметра("ТекущийПользователь", ПараметрыСеанса.ТекущийПользователь);
		Список.Параметры.УстановитьЗначениеПараметра("ОтборПоПользователю", Ложь);
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	ИзменитьФильтр("КоличествоОстаток", ВидСравненияКомпоновкиДанных.Больше, 0, ТолькоСОстатками);
	Элементы.Список.Отображение = ОтображениеТаблицы.Список;
	Если Режим = "С остатками по складу" Тогда
		ЭтаФорма.АвтоЗаголовок		= Ложь;
		Заголовок					= "Номенклатура. " + СкладНаименование;
	КонецЕсли;
	
	Элементы.ФильтрТолькоСОстатками.Видимость = ЕстьОтборПоОстаткам;
	
КонецПроцедуры

&НаКлиенте
Процедура ФильтрНаименованиеПриИзменении(Элемент)

	ИзменитьФильтр("Наименование", ВидСравненияКомпоновкиДанных.Содержит, Наименование, ЗначениеЗаполнено(Наименование));
	
КонецПроцедуры

&НаКлиенте
Процедура ФильтрТолькоСОстаткамиПриИзменении(Элемент)
	
	ИзменитьФильтр("КоличествоОстаток", ВидСравненияКомпоновкиДанных.Больше, 0, ТолькоСОстатками);
	
КонецПроцедуры

&НаКлиенте
Процедура ИзменитьФильтр(Имя, ВидСравнения, Значение, Использование)
	
	ЭлементОтбора = Неопределено;
	
	//Пытаемся найти элемент отбора
	Для Каждого Элемент Из Список.Отбор.Элементы Цикл
		Если Строка(Элемент.ЛевоеЗначение) = Имя Тогда
			ЭлементОтбора = Элемент;
			Прервать;
		КонецЕсли;
	КонецЦикла;
	
	//Удаляем элемент, если такой есть
	Если ЭлементОтбора <> Неопределено Тогда
		Список.Отбор.Элементы.Удалить(ЭлементОтбора);
	КонецЕсли;
	
	Если Не Использование Тогда
		Возврат;
	КонецЕсли;
	
	//Создаем
	ЭлементОтбора					= Список.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных")); 
	ЭлементОтбора.ЛевоеЗначение		= Новый ПолеКомпоновкиДанных(Имя); 
	ЭлементОтбора.ВидСравнения		= ВидСравнения; 
	ЭлементОтбора.РежимОтображения	= РежимОтображенияЭлементаНастройкиКомпоновкиДанных.Недоступный; 
		
	ЭлементОтбора.ПравоеЗначение	= ?(ТипЗнч(Значение)=Тип("Строка"), СокрЛП(Значение), Значение);
	ЭлементОтбора.Использование		= Истина;
	
КонецПроцедуры

