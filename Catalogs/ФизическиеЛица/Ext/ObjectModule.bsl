﻿
Перем ВыполнятьРассылкуОбИзмененииФИО Экспорт;
Перем ФиоИзменили;
Перем БылоФИО;


Процедура ПередЗаписью(Отказ)
	
	ФиоИзменили = Ложь;
	Если НЕ ЭтоНовый() Тогда
		БылоФИО = Ссылка.Наименование;
		Если БылоФИО <> Наименование Тогда
			ФиоИзменили = Истина;
		КонецЕсли;	
	КонецЕсли;
	
	Если ЭтоНовый()
			И НЕ ОбменДанными.Загрузка Тогда
		УстановитьНовыйКод("0001");
	КонецЕсли;
	
	Если НЕ ЭтоГруппа Тогда
		Если НЕ ЭтотОбъект.Активный
				И ЭтотОбъект.Ссылка.Активный Тогда
			Запрос = Новый Запрос;
			Запрос.УстановитьПараметр("ФизЛицо", ЭтотОбъект.Ссылка);
			Запрос.Текст =
			"ВЫБРАТЬ
			|	ПользователиСПравомАкцептаОплат.Ссылка
			|ИЗ
			|	Справочник.ПользователиСПравомАкцептаОплат КАК ПользователиСПравомАкцептаОплат
			|ГДЕ
			|	ПользователиСПравомАкцептаОплат.Активен
			|	И ПользователиСПравомАкцептаОплат.Пользователь.ФизЛицо = &ФизЛицо";
			
			Выборка = Запрос.Выполнить().Выбрать();
			Пока Выборка.Следующий() Цикл
				ОбъектСправочника = Выборка.Ссылка.ПолучитьОбъект();
				ОбъектСправочника.Активен = Ложь;
				ОбъектСправочника.Записать();
			КонецЦикла;	
		КонецЕсли;
	КонецЕсли;
	
	//+++АК LAGP 2018.10.02 ИП-00018521.01 Проверка физ.лица контрагента ЮрФизЛицо = ФизЛицо
	Если ЗначениеЗаполнено(Контрагент) И НЕ (ЗначениеЗаполнено(ДатаРождения) И ЗначениеЗаполнено(УдостоверениеЛичности)) Тогда
		Сообщить("Для физ. лица с заполненным полем ""Контрагент"", указание даты рождения и удостоверения личности обязательно!");	
		Отказ = Истина;
	КонецЕсли;	
	//---АК LAGP
	
	//+++АК mika 2018.10.11 ИП-00019964
	Если НЕ Отказ И НЕ ЭтоНовый() И ЗначениеЗаполнено(ПомощникТУ)Тогда
		ЭтотОбъект.ДополнительныеСвойства.Вставить("ОбновитьГруппуСотрудника");
	КонецЕсли;
	//---АК mika
	
КонецПроцедуры

Процедура ПриЗаписи(Отказ)
	
	//Если НЕ ОбменДанными.Загрузка Тогда
		НомерКПроверке = СокрЛП(Код);
		СтрокаРазрешенные = "0123456789";
		Для н = 1 По СтрДлина(НомерКПроверке) Цикл
			Если Найти(СтрокаРазрешенные, Сред(НомерКПроверке, н, 1)) = 0 Тогда
				Сообщить("Код элемент физ лиц " + Наименование + " не должен содержать символы кроме цифр");
				Отказ = Истина;
			КонецЕсли;	
		КонецЦикла;	
	//КонецЕсли;
	
	УстановитьПривилегированныйРежим(Истина);
	
	//+++АК mika 2018.10.11 ИП-00019964
	Если НЕ Отказ И ЭтотОбъект.ДополнительныеСвойства.Свойство("ОбновитьГруппуСотрудника") Тогда
		ПостроениеГрафиковСервер.ОбновитьГруппуСотрудникаПоНовомуПомощнику(,,Ссылка, ПомощникТУ);
	КонецЕсли;
	//---АК mika

	//Если НЕ Отказ
	//		И ВыполнятьРассылкуОбИзмененииФИО
	//		И ФиоИзменили Тогда
	//	
	//	Запрос = Новый Запрос;
	//	Запрос.УстановитьПараметр("ТекДата", ТекущаяДата());
	//	Запрос.УстановитьПараметр("ФизЛицо", ЭтотОбъект.Ссылка);
	//	Запрос.Текст =
	//	"ВЫБРАТЬ
	//	|	ЕСТЬNULL(ПомощникиУправляющихВТорговыхТочкахСрезПоследних.ФизическоеЛицо, ЗНАЧЕНИЕ(Справочник.ФизическиеЛица.ПустаяСсылка)) КАК Помощник,
	//	|	ЕСТЬNULL(ПользователиПоЦФОСрезПоследних.Сотрудник, ЗНАЧЕНИЕ(Справочник.ФизическиеЛица.ПустаяСсылка)) КАК Управляющий
	//	|ПОМЕСТИТЬ ВТ_Работники
	//	|ИЗ
	//	|	РегистрСведений.ТабельРаботыПродавцов.СрезПоследних(
	//	|			&ТекДата,
	//	|			Сотрудник = &ФизЛицо
	//	|				И Отсутствие = ЗНАЧЕНИЕ(Перечисление.ВидыОтсутствия.ПустаяСсылка)) КАК ТабельРаботыПродавцовСрезПоследних
	//	|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.ПомощникиУправляющихВТорговыхТочках.СрезПоследних(&ТекДата, ) КАК ПомощникиУправляющихВТорговыхТочкахСрезПоследних
	//	|		ПО ТабельРаботыПродавцовСрезПоследних.ТорговаяТочка = ПомощникиУправляющихВТорговыхТочкахСрезПоследних.СтруктурнаяЕдиница
	//	|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.ПользователиПоЦФО.СрезПоследних(&ТекДата, ) КАК ПользователиПоЦФОСрезПоследних
	//	|		ПО (ТабельРаботыПродавцовСрезПоследних.Группа = ПользователиПоЦФОСрезПоследних.ЦФО
	//	|				И ПользователиПоЦФОСрезПоследних.РуководительОтдела = ИСТИНА)
	//	|;
	//	|
	//	|////////////////////////////////////////////////////////////////////////////////
	//	|ВЫБРАТЬ РАЗЛИЧНЫЕ
	//	|	ВЫРАЗИТЬ(КонтактнаяИнформация.Представление КАК СТРОКА(150)) КАК Мейл
	//	|ИЗ
	//	|	ВТ_Работники КАК ВТ_Работники
	//	|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.КонтактнаяИнформация КАК КонтактнаяИнформация
	//	|		ПО ВТ_Работники.Помощник = КонтактнаяИнформация.Объект
	//	|			И (КонтактнаяИнформация.Тип = ЗНАЧЕНИЕ(Перечисление.ТипыКонтактнойИнформации.АдресЭлектроннойПочты))
	//	|			И (КонтактнаяИнформация.Вид = ЗНАЧЕНИЕ(Справочник.ВидыКонтактнойИнформации.EmailФизЛица))
	//	|;
	//	|
	//	|////////////////////////////////////////////////////////////////////////////////
	//	|ВЫБРАТЬ РАЗЛИЧНЫЕ
	//	|	ВЫРАЗИТЬ(КонтактнаяИнформация.Представление КАК СТРОКА(150)) КАК Мейл
	//	|ИЗ
	//	|	ВТ_Работники КАК ВТ_Работники
	//	|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.КонтактнаяИнформация КАК КонтактнаяИнформация
	//	|		ПО ВТ_Работники.Управляющий = КонтактнаяИнформация.Объект
	//	|			И (КонтактнаяИнформация.Тип = ЗНАЧЕНИЕ(Перечисление.ТипыКонтактнойИнформации.АдресЭлектроннойПочты))
	//	|			И (КонтактнаяИнформация.Вид = ЗНАЧЕНИЕ(Справочник.ВидыКонтактнойИнформации.EmailФизЛица))";
	//				   
	//	Результаты = Запрос.ВыполнитьПакет();
	//	МассивПолучатели = Новый Массив();
	//	Выборка = Результаты[1].Выбрать();
	//	Пока Выборка.Следующий() Цикл
	//		Если ЗначениеЗаполнено(Выборка.Мейл) Тогда
	//			МассивПолучатели.Добавить(СокрЛП(Выборка.Мейл));
	//		КонецЕсли;	
	//	КонецЦикла;
	//	
	//	Выборка = Результаты[2].Выбрать();
	//	Пока Выборка.Следующий() Цикл
	//		Если ЗначениеЗаполнено(Выборка.Мейл) Тогда
	//			МассивПолучатели.Добавить(СокрЛП(Выборка.Мейл));
	//		КонецЕсли;	
	//	КонецЦикла;
	//	
	//	Попытка
	//		УчетнаяЗапись = Справочники.УчетныеЗаписиЭлектроннойПочты.НайтиПоКоду("000000001");
	//		Если МассивПолучатели.Количество() > 0 Тогда
	//			Почта = Новый ИнтернетПочта;
	//			Профиль = УправлениеЭлектроннойПочтой.ПолучитьИнтернетПочтовыйПрофиль(УчетнаяЗапись);
	//			Письмо = Новый ИнтернетПочтовоеСообщение;
	//			
	//			Почта.Подключиться(Профиль);
	//			Письмо.Тема = "Изменено ФИО сотрудника";
	//			Письмо.ИмяОтправителя = ""+УчетнаяЗапись+"";
	//			Письмо.ИмяОтправителя  = ""+СокрЛП(УчетнаяЗапись)+"";
	//			Письмо.Отправитель     = ""+СокрЛП(УчетнаяЗапись)+"";
	//			Для Каждого ПолучательЭлемент Из МассивПолучатели Цикл
	//				Получатель = Письмо.Получатели.Добавить();
	//				Получатель.Адрес           = ПолучательЭлемент;
	//			КонецЦикла;	
	//			
	//			ТекстСообщения = Письмо.Тексты.Добавить();
	//			ТекстСообщения.Текст     = "Фамилия сотрудника <" + БылоФИО + "> была изменена на <" + Наименование + ">";
	//			ТекстСообщения.ТипТекста = ТипТекстаПочтовогоСообщения.ПростойТекст;
	//			
	//			Если НЕ ОбщегоНазначения.ЭтоКопияБазы() Тогда
	//				Почта.Послать(Письмо);
	//			КонецЕсли;	
	//			Почта.Отключиться();
	//		КонецЕсли;
	//	Исключение
	//		Сообщить(ОписаниеОшибки());
	//	КонецПопытки;	
	//КонецЕсли;	
	
КонецПроцедуры

Процедура ПриКопировании(ОбъектКопирования)
	
	УинВЗуп = "";
	
КонецПроцедуры


ВыполнятьРассылкуОбИзмененииФИО = Истина;
