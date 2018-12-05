﻿
Функция ПолучитьКодПродавца(Знач КодПродавца)
	
	ОбработатьСтроку = Истина;
	
	Пока ОбработатьСтроку Цикл
		Если Лев(КодПродавца, 1) = "0" Тогда
			КодПродавца = Прав(КодПродавца, СтрДлина(КодПродавца)-1);
		Иначе
			ОбработатьСтроку = Ложь;
		КонецЕсли;	
	КонецЦикла;
	
	Если СтрДлина(КодПродавца) <= 3 Тогда
		КодПродавца = "000" + КодПродавца;
		КодПродавца = "0." + Прав(КодПродавца, 3);
	Иначе
		КодПродавца = "00000" + КодПродавца;
		КодПродавца = Прав(КодПродавца, 5);
		КодПродавца = Лев(КодПродавца, 2) + "." + Прав(КодПродавца, 3);
	КонецЕсли;
	
	Возврат КодПродавца;
	
КонецФункции

Функция ПечатьБейджейНаСервере(МассивСотрудников) Экспорт
	
	ВнешняяКомпонента = Обработки.ПечатьБейджейПродавцов.ПодключитьВнешнююКомпонентуПечатиШтрихкода();
	
	ТабДок = Новый ТабличныйДокумент;
	Макет = Обработки.ПечатьБейджейПродавцов.ПолучитьМакет("Бэйдж_Аутсорсинг");
	
	СпрПерсоналККМ = Справочники.ПерсоналККМ;
	Для Каждого ТекСотрудник Из МассивСотрудников Цикл
		
		ОбластьМакета = Макет.ПолучитьОбласть("Строка");
		ОбластьМакета.Параметры.ФИО = СокрЛП(ТекСотрудник.Наименование);
		
		//ОбластьМакета.Параметры.Код = ПолучитьКодПродавца(ТекСотрудник.Код);
		
		ТекИД = Формат(ТекСотрудник.ИД, "ЧГ=");
		Для н = 1 по 10 - СтрДлина(ТекИД) Цикл
			ТекИД = "0" + ТекИД;
		КонецЦикла;
		ТекПерсоналККМ = СпрПерсоналККМ.НайтиПоКоду(ТекИД);
		Если (НЕ ВнешняяКомпонента = Неопределено)
			 	И НЕ ТекПерсоналККМ.Пустая() Тогда
			
			//ВнешняяКомпонента.АвтоТип = Ложь;
			//ВнешняяКомпонента.ТипКода = 1; // указан тип EAN13
			
			ТекШК = ТекПерсоналККМ.Пароль;
			СтруктураПараметры = Новый Структура();
			СтруктураПараметры.Вставить("Ширина"			, ОбластьМакета.Рисунки.Штрихкод.Ширина);
			СтруктураПараметры.Вставить("Высота"			, ОбластьМакета.Рисунки.Штрихкод.Высота);
			СтруктураПараметры.Вставить("ТипКода"			, 1);
			СтруктураПараметры.Вставить("ОтображатьТекст"	, Истина);
			СтруктураПараметры.Вставить("РазмерШрифта"		, 8);
			СтруктураПараметры.Вставить("Штрихкод"			, ТекШК);
			
			ОбластьМакета.Рисунки.Штрихкод.Картинка = ОбщегоНазначенияКлиентСервер.ПолучитьКартинкуШтрихкода(ВнешняяКомпонента, СтруктураПараметры);
			
		КонецЕсли;
		
		Если НЕ ТабДок.ПроверитьВывод(ОбластьМакета) Тогда
			ТабДок.ВывестиГоризонтальныйРазделительСтраниц();
		КонецЕсли;
		
		ТабДок.Вывести(ОбластьМакета);
		
	КонецЦикла;
	
	Возврат ТабДок;
	
КонецФункции

Функция НадоЗаполнятьОтветственногоМенеджера(Должность) Экспорт
	
	Возврат (Должность = Справочники.ДолжностиВнештатныхСотрудников.НайтиПоНаименованию("Грузчик")
				ИЛИ Должность = Справочники.ДолжностиВнештатныхСотрудников.НайтиПоНаименованию("Кассир")
				ИЛИ Должность = Справочники.ДолжностиВнештатныхСотрудников.НайтиПоНаименованию("Продавец")
				ИЛИ Должность = Справочники.ДолжностиВнештатныхСотрудников.НайтиПоНаименованию("Контролер")
				ИЛИ Должность = Справочники.ДолжностиВнештатныхСотрудников.НайтиПоНаименованию("Уборщица"));
	
КонецФункции

// Возвращает массив контрагентов предоставляющих аутсорс услуги
//
// Параметры:
//  ЗапретРедактирвания  - <Тип.Булево> - Дополнительный признак для запрета редактирования  
//                                        (если функцию вызывает пользователь с ограниченными правами)
// Возвращаемое значение:
//   <Тип.СправочникСсылка.Котрагенты> - Массив контрагетнов  
//
Функция ПолучитьКонтрагентовПредоставляющихАутсорсУслуги(ГруппаСотрудников, Период = Неопределено) Экспорт //+++АК mika 2018.01.15 ИП-00017263.02
	
	Если НЕ ЗначениеЗаполнено(Период) Тогда
		Период = ТекущаяДата();
	КонецЕсли;
	
	МассивКонтрагентов = Новый Массив();
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
	"ВЫБРАТЬ РАЗРЕШЕННЫЕ
	|	КонтрагентыСотрудниковАутсорсингСрезПоследних.Контрагент КАК Контрагент
	|ИЗ
	|	РегистрСведений.КонтрагентыСотрудниковАутсорсинг.СрезПоследних(
	|			&Период,
	|			ВЫБОР
	|				КОГДА &ГруппаСотрудников = ЗНАЧЕНИЕ(Справочник.ГруппыСотрудниковАутсорсинг.ПустаяСсылка)
	|						ИЛИ &ГруппаСотрудников = ЛОЖЬ
	|					ТОГДА ИСТИНА
	|				ИНАЧЕ ГруппаСотрудников = &ГруппаСотрудников
	|			КОНЕЦ) КАК КонтрагентыСотрудниковАутсорсингСрезПоследних
	|
	|СГРУППИРОВАТЬ ПО
	|	КонтрагентыСотрудниковАутсорсингСрезПоследних.Контрагент
	|
	|УПОРЯДОЧИТЬ ПО
	|	Контрагент
	|АВТОУПОРЯДОЧИВАНИЕ";
	
	Запрос.УстановитьПараметр("ГруппаСотрудников", ?(ГруппаСотрудников = Неопределено, Ложь, ГруппаСотрудников));
	Запрос.УстановитьПараметр("Период", Период);
	
	РезультатЗапроса = Запрос.Выполнить();
	
	Если НЕ РезультатЗапроса.Пустой() Тогда
		
		Выборка = РезультатЗапроса.Выбрать();
		
		Пока Выборка.Следующий() Цикл
			МассивКонтрагентов.Добавить(Выборка.Контрагент); 
		КонецЦикла;
		
	КонецЕсли;	

	Возврат МассивКонтрагентов;
	
КонецФункции // ПолучитьГруппуСотрудниковПоКонтрагенту()

// Возвращает группу сотрудников аутсорсинг по контрагенту
//
// Параметры:
//  Контрагент  - <Тип.СправочникСсылка.Контрагенты> - Ссылка на контрагента
//
// Возвращаемое значение:
//   <Тип.СправочникСсылка.ГруппыСотрудниковАутсорсинг> - Группа сотрудников  
//
Функция ПолучитьГруппуСотрудниковПоКонтрагенту(Контрагент) Экспорт //+++АК mika 2018.01.15 ИП-00017263.02
	
	Если НЕ ЗначениеЗаполнено(Контрагент) Тогда
		Возврат Справочники.ГруппыСотрудниковАутсорсинг.ПустаяСсылка();
	КонецЕсли;
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
	"ВЫБРАТЬ РАЗРЕШЕННЫЕ
	|	КонтрагентыСотрудниковАутсорсингСрезПоследних.ГруппаСотрудников КАК ГруппаСотрудников 
	|ИЗ
	|	РегистрСведений.КонтрагентыСотрудниковАутсорсинг.СрезПоследних(&Период, Контрагент = &Контрагент) КАК КонтрагентыСотрудниковАутсорсингСрезПоследних";
	
	Запрос.УстановитьПараметр("Контрагент", Контрагент);
	Запрос.УстановитьПараметр("Период", ТекущаяДата());
	
	РезультатЗапроса = Запрос.Выполнить();
	
	Если НЕ РезультатЗапроса.Пустой() Тогда
		
		Выборка = РезультатЗапроса.Выбрать();
		
		Пока Выборка.Следующий() Цикл
			Возврат Выборка.ГруппаСотрудников; 
		КонецЦикла;
		
	КонецЕсли;	

	Возврат Справочники.ГруппыСотрудниковАутсорсинг.ПустаяСсылка();
	
КонецФункции // ПолучитьГруппуСотрудниковПоКонтрагенту()

//Стандартная процедура модуля менеджера для заполнения ДанныхВыбора
//
Процедура ОбработкаПолученияДанныхВыбора(ДанныеВыбора, Параметры, СтандартнаяОбработка) //+++АК mika 2018.01.15 ИП-00017263.02
	
	//Получение данных выбора 
	Если Параметры.Свойство("ДополнительныеПараметры") Тогда
		
		СтандартнаяОбработка = Ложь;
		
		ДанныеВыбора = Новый СписокЗначений;
		
		Если НЕ ЗначениеЗаполнено(Параметры.ТекстПоиска) Тогда
			Возврат;
		КонецЕсли;
		
		Если Параметры.ДополнительныеПараметры = "Контрагент" Тогда
			
			Запрос = Новый Запрос;
			
			Запрос.Текст = "ВЫБРАТЬ РАЗРЕШЕННЫЕ
			|	СотрудникиАутсорсинг.Ссылка КАК Ссылка
			|ИЗ
			|	РегистрСведений.КонтрагентыСотрудниковАутсорсинг.СрезПоследних(
			|			&Период,
			|			ВЫБОР
			|				КОГДА &Контрагент = ЗНАЧЕНИЕ(Справочник.Контрагенты.ПустаяСсылка)
			|					ТОГДА ИСТИНА
			|				ИНАЧЕ Контрагент = &Контрагент
			|			КОНЕЦ) КАК КонтрагентыСотрудниковАутсорсингСрезПоследних
			|		ЛЕВОЕ СОЕДИНЕНИЕ Справочник.СотрудникиАутсорсинг КАК СотрудникиАутсорсинг
			|		ПО КонтрагентыСотрудниковАутсорсингСрезПоследних.ГруппаСотрудников = СотрудникиАутсорсинг.ГруппаСотрудников
			|ГДЕ
			|	СотрудникиАутсорсинг.Наименование ПОДОБНО &Наименование
			|
			|УПОРЯДОЧИТЬ ПО
			|	СотрудникиАутсорсинг.Наименование";
			
			Запрос.УстановитьПараметр("Период", ТекущаяДата());
			Запрос.УстановитьПараметр("Наименование", "%" + Параметры.ТекстПоиска + "%");
			Запрос.УстановитьПараметр("Контрагент", Параметры.Контрагент);
			
			Результат = Запрос.Выполнить();
			
			Если НЕ Результат.Пустой() Тогда
				
				Выборка = Результат.Выбрать();
				
				Пока Выборка.Следующий() Цикл
					ДанныеВыбора.Добавить(Выборка.Ссылка);
				КонецЦикла;
				
			КонецЕсли;
			
		КонецЕсли;
		
	КонецЕсли;
	
КонецПроцедуры
 