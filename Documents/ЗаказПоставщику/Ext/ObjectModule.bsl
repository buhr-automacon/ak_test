﻿	
Функция РазложитьСтроку(Знач Стр, Разделитель = ";") Экспорт
    
    Список = Новый СписокЗначений;
    Длина  = СтрДлина(Разделитель);
    
    Стр = СокрЛП(Стр);
    Поз = Найти(Стр, Разделитель);
    
    Пока 0 < Поз Цикл
        Список.Добавить(СокрП(Лев(Стр, Поз-1)));
        
        Стр = СокрЛ(Сред(Стр, Поз+Длина));
        Поз = Найти(Стр, Разделитель);
    КонецЦикла;

    Список.Добавить(Стр);
    
    Возврат Список;
    
КонецФункции

Процедура ЗаписатьДатыПоставкиПоЗаказам() Экспорт
	
	НаборЗаписей = РегистрыСведений.ДатыПоставкиПоЗаказам.СоздатьНаборЗаписей();
	НаборЗаписей.Отбор.ЗаказПоставщику.Установить(ЭтотОбъект.Ссылка);
	НаборЗаписей.Прочитать();
	Если НаборЗаписей.Количество() = 0 Тогда // в первый раз записывается изменение даты - пишется первоначальное значение, на дату документа
		НоваяЗапись = НаборЗаписей.Добавить();
		НоваяЗапись.Период 			= ?(ТекущаяДата() < ЭтотОбъект.Дата, ТекущаяДата() - 1, ЭтотОбъект.Дата);
		НоваяЗапись.ЗаказПоставщику = ЭтотОбъект.Ссылка;
		НоваяЗапись.ДатаПоступления = ЭтотОбъект.Ссылка.ДатаПоступления;
		НоваяЗапись.Автор 			= ЭтотОбъект.Автор;
		Попытка
			НаборЗаписей.Записать();
		Исключение
			Сообщить(ОписаниеОшибки());
		КонецПопытки;
	КонецЕсли;
	НаборЗаписей = Неопределено; // забота о памяти приложения 1С
	
	// измененное значение даты поступления
	МенеджерЗаписи = РегистрыСведений.ДатыПоставкиПоЗаказам.СоздатьМенеджерЗаписи();
	МенеджерЗаписи.Период 			= ТекущаяДата();
	МенеджерЗаписи.ЗаказПоставщику 	= ЭтотОбъект.Ссылка;
	МенеджерЗаписи.ДатаПоступления 	= ЭтотОбъект.ДатаПоступления;
	МенеджерЗаписи.Комментарий		= ЭтотОбъект.КомментарийДатыПоступления;
	МенеджерЗаписи.Автор 			= ПараметрыСеанса.ТекущийПользователь;
	Попытка
		МенеджерЗаписи.Записать();
	Исключение
		Сообщить(ОписаниеОшибки());
	КонецПопытки;
	МенеджерЗаписи = Неопределено; // забота о памяти приложения 1С
	
КонецПроцедуры

Процедура ОтправитьПисьмоОбИзмененииДатыПоступления(СтруктураНовогоПисьма, СписокКому) Экспорт
	
	Попытка
		УчетнаяЗапись = ОбщиеПроцедуры.ПолучитьУчетнуюЗаписьДляРассылки();
		Если СписокКому.Количество() > 0 Тогда
			Почта = Новый ИнтернетПочта;
			Профиль = УправлениеЭлектроннойПочтой.ПолучитьИнтернетПочтовыйПрофиль(УчетнаяЗапись);
			Письмо = Новый ИнтернетПочтовоеСообщение;
			
			Почта.Подключиться(Профиль);
			Письмо.Тема = СтруктураНовогоПисьма.Тема;
			Письмо.ИмяОтправителя 	= "" + УчетнаяЗапись + "";
			Письмо.ИмяОтправителя 	= "" + СокрЛП(УчетнаяЗапись) + "";
			Письмо.Отправитель    	= "" + СокрЛП(УчетнаяЗапись) + "";
			Для Каждого ПолучательЭлемент Из СписокКому Цикл
				Получатель = Письмо.Получатели.Добавить();
				Получатель.Адрес	= ПолучательЭлемент.Значение;
			КонецЦикла;	
			
			ТекстСообщения = Письмо.Тексты.Добавить();
			ТекстСообщения.Текст     = СтруктураНовогоПисьма.Тело;
			ТекстСообщения.ТипТекста = ТипТекстаПочтовогоСообщения.ПростойТекст;
			
			Если НЕ ОбщегоНазначения.ЭтоКопияБазы() Тогда
				Почта.Послать(Письмо);
			КонецЕсли;	
			Почта.Отключиться();
		КонецЕсли;
	Исключение
		//Сообщить(ОписаниеОшибки());
	КонецПопытки;
	
КонецПроцедуры	

Процедура НаписатьПисьмоОбИзмененииДатыПоступления(мМассивТоваров, СтараяДатаПоступления, НоваяДатаПоступления) Экспорт

	УстановитьПривилегированныйРежим(Истина);
		
	СтруктураНовогоПисьма = Новый Структура;
	СтруктураНовогоПисьма.Вставить("Тема", "Изменена дата поступления заказа № " + Строка(ЭтотОбъект.Номер) + " " + Строка(ЭтотОбъект.Поставщик) + " от " + Формат(ЭтотОбъект.Дата, "ДФ=dd.MM.yyyy") + " ");
	СтруктураНовогоПисьма.Вставить("Тело", "Изменена дата поступления заказа № " + Строка(ЭтотОбъект.Номер) + " " + Строка(ЭтотОбъект.Поставщик) + " от " + Формат(ЭтотОбъект.Дата, "ДФ=dd.MM.yyyy") + Символы.ПС + Символы.ПС + 
											"Предыдущая дата: " + Формат(СтараяДатаПоступления, "ДЛФ=Д") 	+ Символы.ПС + 
											"Новая дата: "		+ Формат(НоваяДатаПоступления, "ДЛФ=Д") 	+ Символы.ПС +
											"Автор изменения: " + ПараметрыСеанса.ТекущийПользователь 		+ Символы.ПС +
											"Комментарий: " 	+ ЭтотОбъект.КомментарийДатыПоступления);
		
	СписокКому            = Новый СписокЗначений;
	МассивПользователей   = Новый Массив;
		
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("Объект"				, МассивПользователей);
	СписокВидов = Новый Массив;
	СписокВидов.Добавить(Справочники.ВидыКонтактнойИнформации.СлужебныйАдресЭлектроннойПочтыПользователя);
	СписокВидов.Добавить(Справочники.ВидыКонтактнойИнформации.EmailФизЛица);
	Запрос.УстановитьПараметр("Виды"				, СписокВидов);
	Запрос.УстановитьПараметр("СписокНоменклатуры"	, мМассивТоваров);
	Запрос.УстановитьПараметр("ПредЗаказы"			, Предзаказы.Выгрузить().ВыгрузитьКолонку("Документ"));
	Запрос.УстановитьПараметр("ДатаСреза"			, ЭтотОбъект.Дата);
	
	Запрос.Текст =
	"ВЫБРАТЬ РАЗЛИЧНЫЕ
	|	РолиПользователейСоставРоли.Сотрудник
	|ПОМЕСТИТЬ Пользователи
	|ИЗ
	|	(ВЫБРАТЬ
	|		ВЫБОР
	|			КОГДА ЕСТЬNULL(СоответствиеОбъектРольСрезПоследнихПоХар.РольПользователя, ЗНАЧЕНИЕ(Справочник.РолиПользователей.ПустаяСсылка)) = ЗНАЧЕНИЕ(Справочник.РолиПользователей.ПустаяСсылка)
	|				ТОГДА СоответствиеОбъектРольСрезПоследнихПоПроизв.РольПользователя
	|			ИНАЧЕ СоответствиеОбъектРольСрезПоследнихПоХар.РольПользователя
	|		КОНЕЦ КАК РольПользователя
	|	ИЗ
	|		Справочник.ХарактеристикиНоменклатуры КАК ХарактеристикиНоменклатуры
	|			ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.СоответствиеОбъектРоль.СрезПоследних(&ДатаСреза, ТипРоли = ЗНАЧЕНИЕ(ПланВидовХарактеристик.ТипыРолейПользователя.ТехнологПоКачеству)) КАК СоответствиеОбъектРольСрезПоследнихПоХар
	|			ПО ХарактеристикиНоменклатуры.Ссылка = СоответствиеОбъектРольСрезПоследнихПоХар.Объект
	|			ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.ЗначенияСвойствОбъектов КАК ЗначенияСвойствОбъектов
	|			ПО ХарактеристикиНоменклатуры.Ссылка = ЗначенияСвойствОбъектов.Объект
	|				И (ЗначенияСвойствОбъектов.Свойство = ЗНАЧЕНИЕ(ПланВидовХарактеристик.СвойстваОбъектов.Производитель))
	|			ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.СоответствиеОбъектРоль.СрезПоследних(&ДатаСреза, ТипРоли = ЗНАЧЕНИЕ(ПланВидовХарактеристик.ТипыРолейПользователя.ТехнологПоКачеству)) КАК СоответствиеОбъектРольСрезПоследнихПоПроизв
	|			ПО (ЗначенияСвойствОбъектов.Значение = СоответствиеОбъектРольСрезПоследнихПоПроизв.Объект)
	|	ГДЕ
	|		ХарактеристикиНоменклатуры.Ссылка В
	|				(ВЫБРАТЬ
	|					ПредзаказТовары.Характеристика
	|				ИЗ
	|					Документ.Предзаказ.Товары КАК ПредзаказТовары
	|				ГДЕ
	|					ПредзаказТовары.Ссылка В (&ПредЗаказы))) КАК ВЗ_Технологи
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ Справочник.РолиПользователей.СоставРоли КАК РолиПользователейСоставРоли
	|		ПО ВЗ_Технологи.РольПользователя = РолиПользователейСоставРоли.Ссылка
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ВЫРАЗИТЬ(РасчетчикиГруппыНоменклатуры.Ссылка.УчетнаяЗаписьЭлектроннойПочты.АдресЭлектроннойПочты КАК СТРОКА(100)) КАК Адрес
	|ПОМЕСТИТЬ Расчетчики
	|ИЗ
	|	Справочник.Расчетчики.ГруппыНоменклатуры КАК РасчетчикиГруппыНоменклатуры
	|ГДЕ
	|	РасчетчикиГруппыНоменклатуры.ГруппаНоменклатуры В(&СписокНоменклатуры)
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	КонтактнаяИнформация.Представление
	|ИЗ
	|	Пользователи КАК Пользователи
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ РегистрСведений.КонтактнаяИнформация КАК КонтактнаяИнформация
	|		ПО Пользователи.Сотрудник = КонтактнаяИнформация.Объект
	|ГДЕ
	|	КонтактнаяИнформация.Тип = ЗНАЧЕНИЕ(Перечисление.ТипыКонтактнойИнформации.АдресЭлектроннойПочты)
	|	И КонтактнаяИнформация.Вид В(&Виды)
	|
	|ОБЪЕДИНИТЬ ВСЕ
	|
	|ВЫБРАТЬ
	|	Расчетчики.Адрес
	|ИЗ
	|	Расчетчики КАК Расчетчики";	
		
	Выборка = Запрос.Выполнить().Выгрузить();
	Выборка.Свернуть("Представление");	
	
	Для каждого Адр из Выборка Цикл
		СписокАдресов = РазложитьСтроку(Адр.Представление);
		Для й = 0 По СписокАдресов.Количество() - 1 Цикл
			Адрес = СписокАдресов.Получить(й).Значение;
			Если СокрЛП(Адрес) = "" Тогда
				Продолжить;
			КонецЕсли;	
			СписокКому.Добавить(Адрес,Адрес);
		КонецЦикла;	
	КонецЦикла;
		
	ОтправитьПисьмоОбИзмененииДатыПоступления(СтруктураНовогоПисьма, СписокКому);
	
	УстановитьПривилегированныйРежим(Ложь);

КонецПроцедуры

Процедура СформироватьСообщенияОбИзмененииДатыПоступления(СтараяДатаПоступления, НоваяДатаПоступления) Экспорт
	
	СП1 = Новый Структура;
	СП1.Вставить("Тема"				, "Изменена дата поступления заказа № " + Строка(ЭтотОбъект.Номер) + " от " + Формат(ЭтотОбъект.Дата, "ДФ=dd.MM.yyyy") + " ");
	СП1.Вставить("ТекстСообщения"	, "Изменена дата поступления заказа № " + Строка(ЭтотОбъект.Номер) + " от " + Формат(ЭтотОбъект.Дата, "ДФ=dd.MM.yyyy") + Символы.ПС + Символы.ПС + 
										"Предыдущая дата: " + Формат(СтараяДатаПоступления, "ДЛФ=Д") 	+ Символы.ПС + 
										"Новая дата: " 		+ Формат(НоваяДатаПоступления, "ДЛФ=Д") 	+ Символы.ПС +
										"Автор изменения: " + ПараметрыСеанса.ТекущийПользователь 		+ Символы.ПС +
										"Комментарий: " 	+ ЭтотОбъект.КомментарийДатыПоступления);
	СП1.Вставить("Автор"			, ПараметрыСеанса.ТекущийПользователь);
				
	МеханизмОбменаСообщениями.СоздатьИОтправитьАвтоматическоеСообщение(СП1, Справочники.СобытияАвторассылкиМОС.ИзменениеДатыЗаказаПоставщику);
	
КонецПроцедуры
	
	
Процедура ЗаполнитьСтрокуПроизводителей()
	
	ТекСтрока = "";
	
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("МассивПредзаказов", ЭтотОбъект.Предзаказы.ВыгрузитьКолонку("Документ"));
	Запрос.Текст =
	"ВЫБРАТЬ
	|	ВЫРАЗИТЬ(ЗначенияСвойствОбъектов.Значение КАК Справочник.Контрагенты).Наименование КАК ПроизводительНаименование
	|ИЗ
	|	Документ.Предзаказ.Товары КАК ПредзаказТовары
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ РегистрСведений.ЗначенияСвойствОбъектов КАК ЗначенияСвойствОбъектов
	|		ПО (ЗначенияСвойствОбъектов.Свойство = ЗНАЧЕНИЕ(ПланВидовХарактеристик.СвойстваОбъектов.Производитель))
	|			И (ЗначенияСвойствОбъектов.Объект = ПредзаказТовары.Характеристика)
	|ГДЕ
	|	ПредзаказТовары.Ссылка В(&МассивПредзаказов)
	|
	|СГРУППИРОВАТЬ ПО
	|	ВЫРАЗИТЬ(ЗначенияСвойствОбъектов.Значение КАК Справочник.Контрагенты).Наименование
	|
	|УПОРЯДОЧИТЬ ПО
	|	ВЫРАЗИТЬ(ЗначенияСвойствОбъектов.Значение КАК Справочник.Контрагенты).Наименование";
	
	Выборка = Запрос.Выполнить().Выбрать();
	Пока Выборка.Следующий() Цикл
		ТекСтрока = ТекСтрока + "; " + СокрЛП(Выборка.ПроизводительНаименование);
	КонецЦикла;
	Если НЕ ТекСтрока = "" Тогда
		ТекСтрока = Сред(ТекСтрока, 3);
	КонецЕсли;
	
	//
	Если НЕ ЭтотОбъект.СтрокаПроизводители = ТекСтрока Тогда
		ЭтотОбъект.СтрокаПроизводители = ТекСтрока;
	КонецЕсли;
	
КонецПроцедуры

Процедура ПерезаполнитьПредзаказы()
	
	Если ЭтотОбъект.ЭтоНовый()
			ИЛИ ЭтотОбъект.ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	
	Для Каждого СтрокаТЧ Из ЭтотОбъект.Предзаказы Цикл
		
		Если СтрокаТЧ.Документ.ДатаПоступления = ЭтотОбъект.ДатаПоступления Тогда
			Продолжить;
		КонецЕсли;
		
		ОбъектПЗ = СтрокаТЧ.Документ.ПолучитьОбъект();
		ОбъектПЗ.ОбменДанными.Загрузка = Истина;
		ОбъектПЗ.ДатаПоступления = ЭтотОбъект.ДатаПоступления;
		Попытка
		    ОбъектПЗ.Записать();
			Сообщить("В документе """ + ОбъектПЗ + """ дата поступления изменена на " + Формат(ЭтотОбъект.ДатаПоступления, "ДЛФ=Д"));
		Исключение
			Сообщить(ОписаниеОшибки());
		КонецПопытки;
	КонецЦикла;
	
КонецПроцедуры


Процедура ПриКопировании(ОбъектКопирования)
	
	ЭтотОбъект.ЗагруженИзАкцес = Ложь;
	ЭтотОбъект.Статус=Перечисления.СтатусыЗаказовНаПоставку.ОжидаемДляРаспределения;
	ЗаказПоступилПолностью = Ложь;
КонецПроцедуры

//+++АК SHEP 2017.11.13 ИП-00016064
Процедура ПроверитьРазрешённоеКоличествоЗаказа(Отказ)
	
	МВТ = Новый МенеджерВременныхТаблиц;
	Запрос = Новый Запрос(
		"ВЫБРАТЬ
		|	ТЧТовары.Номенклатура,
		|	ТЧТовары.Характеристика,
		|	СУММА(ТЧТовары.Количество) КАК Количество
		|ПОМЕСТИТЬ ВТТовары
		|ИЗ
		|	Документ.Предзаказ.Товары КАК ТЧТовары
		|ГДЕ
		|	ТЧТовары.Ссылка В(&Предзаказы)
		|
		|СГРУППИРОВАТЬ ПО
		|	ТЧТовары.Номенклатура,
		|	ТЧТовары.Характеристика");
	Запрос.УстановитьПараметр("Предзаказы", Предзаказы.Выгрузить().ВыгрузитьКолонку("Документ"));
	Запрос.МенеджерВременныхТаблиц = МВТ;
	
	РезультатЗапроса = Запрос.Выполнить();
	Если РезультатЗапроса.Пустой() Тогда Возврат; КонецЕсли;
	
	Отказ = НЕ Документы.ЗаказПоставщику.ПроверитьРазрешённоеКоличествоЗаказа(МВТ);
	
КонецПроцедуры

Процедура ОбработкаПроведения(Отказ, РежимПроведения)
	
	//+++АК SHEP 20170307 ИП-00015092: Если в договоре контрагента галка "Есть оригинал договора" не проставлена, добавить запрет на размещение заказов этому поставщику
	Если РегистрыСведений.ПараметрыРаботыССоцСетями.ПолучитьЗначениеПараметра(, "ЗапретЗаказаПоставщикуБезОригиналаДог") = Истина Тогда
		Если Документы.ЗаказПоставщику.НетДоговоровПоставщикаСПолученнымОригиналом(Поставщик, Дата) Тогда
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю("У поставщика нет ни одного полученного оригинала договора. Размещение заказов запрещено!", Ссылка,,, Отказ);
			Возврат;
		КонецЕсли;
	КонецЕсли;
	//---АК SHEP 20170307
	
	// Проверить на дубли заказов
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("Предзаказы"	, ЭтотОбъект.Предзаказы.ВыгрузитьКолонку("Документ"));
	Запрос.УстановитьПараметр("Ссылка"		, ЭтотОбъект.Ссылка);
	Запрос.Текст =
	"ВЫБРАТЬ
	|	ЗаказПоставщикуПредзаказы.Документ КАК Предзаказ,
	|	ЗаказПоставщикуПредзаказы.Ссылка КАК Заказ
	|ИЗ
	|	Документ.ЗаказПоставщику.Предзаказы КАК ЗаказПоставщикуПредзаказы
	|ГДЕ
	|	ЗаказПоставщикуПредзаказы.Документ В(&Предзаказы)
	|	И ЗаказПоставщикуПредзаказы.Ссылка <> &Ссылка
	|	И ЗаказПоставщикуПредзаказы.Ссылка.Проведен
	|
	|СГРУППИРОВАТЬ ПО
	|	ЗаказПоставщикуПредзаказы.Документ,
	|	ЗаказПоставщикуПредзаказы.Ссылка";
	Выборка = Запрос.Выполнить().Выбрать();
	Пока Выборка.Следующий() Цикл
		Сообщение = Новый СообщениеПользователю();
		Сообщение.Текст = "На основании документа " + Выборка.Предзаказ + " уже есть заказ " + Выборка.Заказ;
		Сообщение.УстановитьДанные(Выборка.Заказ);
		Сообщение.Сообщить();
		//Отказ = Истина; // пока не надо
	КонецЦикла;	
	
	//+++АК SHEP 2017.11.13 ИП-00016064
	Если НЕ Отказ И Предзаказы.Количество() > 0 Тогда
		ПроверитьРазрешённоеКоличествоЗаказа(Отказ);
		Если Отказ Тогда Возврат; КонецЕсли;
	КонецЕсли;
	//---АК SHEP 2017.11.13
	
	//
	мДвижения = Движения.ЗаказыПоставщикам;
	мДвижения.Очистить();
	мДвижения.Записывать = Истина;
	
	Если ЭтотОбъект.Статус<>Перечисления.СтатусыЗаказовНаПоставку.ОтказОтПоставки Тогда
		Запрос = Новый Запрос;
		Запрос.УстановитьПараметр("ПредЗаказы"	, ЭтотОбъект.Предзаказы.Выгрузить().ВыгрузитьКолонку("Документ"));
		Запрос.УстановитьПараметр("Заказ"		, ЭтотОбъект.Ссылка);
		Запрос.Текст = Документы.ЗаказПоставщику.ПолучитьТекстЗапросаПоТоварамПредзаказов();
		Выборка = Запрос.Выполнить().Выбрать();
		Пока Выборка.Следующий() Цикл
			НовоеДвижение = мДвижения.ДобавитьПриход();
			НовоеДвижение.ЗаказПоставщику 	= ЭтотОбъект.Ссылка;
			НовоеДвижение.Количество		= Выборка.Количество;
			НовоеДвижение.Номенклатура		= Выборка.Номенклатура;
			НовоеДвижение.Период			= ЭтотОбъект.Дата;
		КонецЦикла;	
	КонецЕсли;	
	//++АК lobv 30/10/2016
	//Для Каждого Предзаказ из ЭтотОбъект.Предзаказы цикл
	//	Если Предзаказ.Документ.ФормироватьПоступлениеНаВиртуальныйСклад тогда
	//		Попытка
	//			Документы.Предзаказ.СоздатьПриходныеОрдераПоПредзаказу(Предзаказ.Документ);
	//		Исключение
	//			Сообщить("Не удалось скорректировать приходный ордер для виртуального склада по документу "+Строка(Предзаказ.Документ.Ссылка));
	//		КонецПопытки;
	//	КонецЕсли;
	//КонецЦикла;
	//--АК
КонецПроцедуры


Процедура ПередЗаписью(Отказ, РежимЗаписи, РежимПроведения)
	
	Если Не ЗначениеЗаполнено(ЭтотОбъект.Статус) Тогда
		ЭтотОбъект.Статус=Перечисления.СтатусыЗаказовНаПоставку.ОжидаемДляРаспределения;
	КонецЕсли;
	ЗаполнитьСтрокуПроизводителей();
	
	ПерезаполнитьПредзаказы();
	
КонецПроцедуры

Процедура ОбработкаУдаленияПроведения(Отказ)
	//++АК lobv 30/10/2016
	//Для Каждого Предзаказ из ЭтотОбъект.Предзаказы цикл
	//	Если Предзаказ.Документ.ФормироватьПоступлениеНаВиртуальныйСклад тогда
	//		Попытка
	//			Документы.Предзаказ.СоздатьПриходныеОрдераПоПредзаказу(Предзаказ.Документ,ЭтотОбъект.Ссылка);
	//		Исключение
	//			Сообщить("Не удалось скорректировать приходный ордер для виртуального склада по документу "+Строка(Предзаказ.Документ.Ссылка));
	//		КонецПопытки;
	//	КонецЕсли;
	//КонецЦикла;
	//--АК
КонецПроцедуры

Процедура ПриЗаписи(Отказ)
	
	//АК mind 2017-02-15 отключаю этот блок, так как логика прямых поставок меняется
	//++АК lobv 30/10/2016
	//Для Каждого Предзаказ из ЭтотОбъект.Предзаказы цикл
	//	Если Предзаказ.Документ.ФормироватьПоступлениеНаВиртуальныйСклад тогда
	//		Попытка
	//			Если ЭтотОбъект.ПометкаУдаления тогда
	//				Документы.Предзаказ.СоздатьПриходныеОрдераПоПредзаказу(Предзаказ.Документ, Истина);
	//			Иначе
	//				Документы.Предзаказ.СоздатьПриходныеОрдераПоПредзаказу(Предзаказ.Документ);
	//			КонецЕсли;
	//		Исключение
	//			Сообщить("Не удалось скорректировать приходный ордер для виртуального склада по документу "+Строка(Предзаказ.Документ.Ссылка));
	//		КонецПопытки;
	//	КонецЕсли;
	//КонецЦикла;
	//--АК
	
	//+++АК SHEP 20170421 ИП-00014350
	Если НЕ ПроверитьЦеныПоставщиков() Тогда
		Отказ = Истина;
		Возврат;
	КонецЕсли;
	//---АК SHEP 20170421
	
КонецПроцедуры

//+++АК SHEP 20170421 ИП-00014350
//Янышева Татьяна: 14 апр в 17:46
// нужно такое ограничение - при отсутствии установленной цены розницы заказ товара не возможен,
// при попытке заказа нужно уведомление о необходимости установки цены заказчику окошком, продакт-менеджеру отчетом и смс.
Функция ПроверитьЦеныПоставщиков()
	
	Запрос = Новый Запрос(
		"ВЫБРАТЬ
		|	ВЗ_Товары.Номенклатура,
		|	ВЗ_Товары.Характеристика,
		|	ВЗ_Товары.ЕдиницаИзмерения,
		|	ВЗ_Товары.Количество,
		|	ЗаказыПоставщикамОбороты.КоличествоРасход КАК Поступило
		|ИЗ
		|	(ВЫБРАТЬ
		|		ПредзаказТовары.Номенклатура КАК Номенклатура,
		|		ПредзаказТовары.Характеристика КАК Характеристика,
		|		ПредзаказТовары.ЕдиницаИзмерения КАК ЕдиницаИзмерения,
		|		СУММА(ПредзаказТовары.Количество) КАК Количество
		|	ИЗ
		|		Документ.Предзаказ.Товары КАК ПредзаказТовары
		|	ГДЕ
		|		ПредзаказТовары.Ссылка В(&ПредЗаказы)
		|	
		|	СГРУППИРОВАТЬ ПО
		|		ПредзаказТовары.Номенклатура,
		|		ПредзаказТовары.ЕдиницаИзмерения,
		|		ПредзаказТовары.Характеристика) КАК ВЗ_Товары
		|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрНакопления.ЗаказыПоставщикам.Обороты(, , , ЗаказПоставщику = &Заказ) КАК ЗаказыПоставщикамОбороты
		|		ПО ВЗ_Товары.Номенклатура = ЗаказыПоставщикамОбороты.Номенклатура
		|
		|УПОРЯДОЧИТЬ ПО
		|	ВЗ_Товары.Номенклатура.Наименование");
	Запрос.УстановитьПараметр("ПредЗаказы"	, ЭтотОбъект.Предзаказы.Выгрузить().ВыгрузитьКолонку("Документ"));
	Запрос.УстановитьПараметр("Заказ"		, ЭтотОбъект.Ссылка);
	ТЗнНоменклатуры = Запрос.Выполнить().Выгрузить();
	
	Запрос = Новый Запрос(
		"ВЫБРАТЬ РАЗЛИЧНЫЕ
		|	ТаблицаНоменклатуры.Номенклатура,
		|	ТаблицаНоменклатуры.Характеристика
		|ПОМЕСТИТЬ ТаблицаНоменклатуры
		|ИЗ
		|	&ТЗнНоменклатуры КАК ТаблицаНоменклатуры
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	РолиПользователейСоставРоли.Сотрудник КАК Сотрудник,
		|	""Продакт-Менеджер"" КАК Поле1,
		|	ТаблицаНоменклатуры.Номенклатура КАК Номенклатура,
		|	ТаблицаНоменклатуры.Характеристика КАК Характеристика,
		|	ВЫРАЗИТЬ(КонтактнаяИнформацияТелефон.Представление КАК СТРОКА(50)) КАК НомерТелефона,
		|	ВЫРАЗИТЬ(КонтактнаяИнформацияЭлПочта.Представление КАК СТРОКА(200)) КАК АдресЭП,
		|	ЕСТЬNULL(РолиПользователейСоставРоли.Ссылка, ЗНАЧЕНИЕ(Справочник.РолиПользователей.ПустаяСсылка)) КАК РольПользователя,
		|	ЕСТЬNULL(ЦеныПоставщиковСрезПоследних.Цена, 0) КАК Цена
		|ИЗ
		|	РегистрСведений.ЦеныПоставщиков.СрезПоследних(
		|			&Период,
		|			Номенклатура В
		|				(ВЫБРАТЬ
		|					ТаблицаНоменклатуры.Номенклатура
		|				ИЗ
		|					ТаблицаНоменклатуры КАК ТаблицаНоменклатуры)) КАК ЦеныПоставщиковСрезПоследних
		|		ПОЛНОЕ СОЕДИНЕНИЕ ТаблицаНоменклатуры КАК ТаблицаНоменклатуры
		|		ПО ЦеныПоставщиковСрезПоследних.Номенклатура = ТаблицаНоменклатуры.Номенклатура
		|			И (ВЫБОР
		|				КОГДА ВЫРАЗИТЬ(ТаблицаНоменклатуры.Номенклатура КАК Справочник.Номенклатура).НеВедетсяУчетПоХарактеристикам
		|					ТОГДА ИСТИНА
		|				ИНАЧЕ ЦеныПоставщиковСрезПоследних.Характеристика = ТаблицаНоменклатуры.Характеристика
		|			КОНЕЦ)
		|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.СоответствиеОбъектРоль.СрезПоследних(
		|				,
		|				ТипРоли = ЗНАЧЕНИЕ(ПланВидовХарактеристик.ТипыРолейПользователя.ТехнологПоКачеству)
		|					И Объект ССЫЛКА Справочник.ХарактеристикиНоменклатуры) КАК СоответствиеОбъектРольСрезПоследнихХ
		|		ПО (СоответствиеОбъектРольСрезПоследнихХ.Объект = ТаблицаНоменклатуры.Характеристика)
		|			И (СоответствиеОбъектРольСрезПоследнихХ.РольПользователя <> ЗНАЧЕНИЕ(Справочник.РолиПользователей.ПустаяСсылка))
		|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ РегистрСведений.ЗначенияСвойствОбъектов КАК ЗначенияСвойствОбъектов
		|		ПО (ЗначенияСвойствОбъектов.Объект = ТаблицаНоменклатуры.Характеристика)
		|			И (ЗначенияСвойствОбъектов.Свойство = ЗНАЧЕНИЕ(ПланВидовХарактеристик.СвойстваОбъектов.Производитель))
		|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.СоответствиеОбъектРоль.СрезПоследних(
		|				,
		|				ТипРоли = ЗНАЧЕНИЕ(ПланВидовХарактеристик.ТипыРолейПользователя.ТехнологПоКачеству)
		|					И Объект ССЫЛКА Справочник.Контрагенты) КАК СоответствиеОбъектРольСрезПоследнихК
		|		ПО (СоответствиеОбъектРольСрезПоследнихХ.Объект ЕСТЬ NULL )
		|			И (ЗначенияСвойствОбъектов.Значение = СоответствиеОбъектРольСрезПоследнихК.Объект)
		|			И (СоответствиеОбъектРольСрезПоследнихК.РольПользователя <> ЗНАЧЕНИЕ(Справочник.РолиПользователей.ПустаяСсылка))
		|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.СоответствиеОбъектРоль.СрезПоследних(
		|				,
		|				ТипРоли = ЗНАЧЕНИЕ(ПланВидовХарактеристик.ТипыРолейПользователя.БрендМенеджер)
		|					И Объект ССЫЛКА Справочник.РолиПользователей) КАК СоответствиеОбъектРольСрезПоследнихБМ
		|		ПО (ЕСТЬNULL(СоответствиеОбъектРольСрезПоследнихХ.РольПользователя, СоответствиеОбъектРольСрезПоследнихК.РольПользователя) <> ЗНАЧЕНИЕ(Справочник.РолиПользователей.ПустаяСсылка))
		|			И (СоответствиеОбъектРольСрезПоследнихБМ.Объект = ЕСТЬNULL(СоответствиеОбъектРольСрезПоследнихХ.РольПользователя, СоответствиеОбъектРольСрезПоследнихК.РольПользователя))
		|		ЛЕВОЕ СОЕДИНЕНИЕ Справочник.РолиПользователей.СоставРоли КАК РолиПользователейСоставРоли
		|		ПО (РолиПользователейСоставРоли.Ссылка = СоответствиеОбъектРольСрезПоследнихБМ.РольПользователя)
		|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.КонтактнаяИнформация КАК КонтактнаяИнформацияТелефон
		|		ПО (КонтактнаяИнформацияТелефон.Вид = ЗНАЧЕНИЕ(Справочник.ВидыКонтактнойИнформации.ТелефонСлужебный))
		|			И (РолиПользователейСоставРоли.Сотрудник = КонтактнаяИнформацияТелефон.Объект)
		|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.КонтактнаяИнформация КАК КонтактнаяИнформацияЭлПочта
		|		ПО (КонтактнаяИнформацияЭлПочта.Вид = ЗНАЧЕНИЕ(Справочник.ВидыКонтактнойИнформации.EmailФизЛица))
		|			И (РолиПользователейСоставРоли.Сотрудник = КонтактнаяИнформацияЭлПочта.Объект)
		|ГДЕ
		|	ЕСТЬNULL(ЦеныПоставщиковСрезПоследних.Цена, 0) = 0
		|ИТОГИ ПО
		|	Номенклатура,
		|	Характеристика");
	Запрос.УстановитьПараметр("Период", КонецДня(ТекущаяДата()));
	Запрос.УстановитьПараметр("ТЗнНоменклатуры", ТЗнНоменклатуры);
	
	РезультатЗапроса = Запрос.Выполнить();
	Если РезультатЗапроса.Пустой() Тогда Возврат Истина; КонецЕсли;
	
	ВыборкаПоНоменклатуре = РезультатЗапроса.Выбрать(ОбходРезультатаЗапроса.ПоГруппировкам);
	Пока ВыборкаПоНоменклатуре.Следующий() Цикл
		
		ВыборкаПоХарактеристике = ВыборкаПоНоменклатуре.Выбрать(ОбходРезультатаЗапроса.ПоГруппировкам);
		Пока ВыборкаПоХарактеристике.Следующий() Цикл
			
			ТекстПисьма = "" + ВыборкаПоХарактеристике.Номенклатура + " (" + ВыборкаПоХарактеристике.Характеристика + "): нет цены поставщика!";
			СписокКому = Новый СписокЗначений;
			СписокТелефонов = Новый СписокЗначений;
			
			ВыборкаДетальныеЗаписи = ВыборкаПоХарактеристике.Выбрать();
			Пока ВыборкаДетальныеЗаписи.Следующий() Цикл
				
				Если ЗначениеЗаполнено(ВыборкаДетальныеЗаписи.АдресЭП) Тогда СписокКому.Добавить(ВыборкаДетальныеЗаписи.АдресЭП); КонецЕсли;
				
				Если ЗначениеЗаполнено(ВыборкаДетальныеЗаписи.НомерТелефона) Тогда СписокТелефонов.Добавить(ВыборкаДетальныеЗаписи.НомерТелефона); КонецЕсли;
				
			КонецЦикла;
			
			Сообщить(ТекстПисьма);
			
			Если СписокКому.Количество() > 0 Тогда
				СтруктураНовогоПисьма = Новый Структура("Тема,Тело", "Нет цены поставщика", ТекстПисьма); 
				ОтправитьПисьмоОбИзмененииДатыПоступления(СтруктураНовогоПисьма, СписокКому);
			КонецЕсли;
			
			Если СписокТелефонов.Количество() > 0 Тогда
				ОтправитьСМС(ТекстПисьма, СписокТелефонов);
			КонецЕсли;

		КонецЦикла;

	КонецЦикла;
	
	Возврат Ложь;
	
КонецФункции

Процедура ОтправитьСМС(ТекстСообщения, СписокТелефонов)
	
	ОбработкаПочтоваяРассылкаОбъект = Обработки.ПочтоваяРассылка.Создать();
	ОбработкаПочтоваяРассылкаОбъект.ТекстПисьма = ТекстСообщения;
	ОбработкаПочтоваяРассылкаОбъект.ОтправитьСМСНаСервере(СписокТелефонов);
	ОбработкаПочтоваяРассылкаОбъект = Неопределено;
	
КонецПроцедуры
//---АК SHEP 20170421
