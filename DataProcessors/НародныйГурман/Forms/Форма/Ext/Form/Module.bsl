﻿
&НаКлиенте
Процедура ЗаполнитьСписокНовинок(Команда)
	ЗаполнитьСписокНовинокНаСервере();
КонецПроцедуры

Функция ПолучитьМассивИдТоваров(Новинки)
	
	ТекстЗапроса =
	"SELECT id_tov FROM vv03.dbo.tovari_ostatki (nolock) WHERE novinka = " + ?(Новинки, "1", "0");
	Результат = Телеграм.База_ВыполнитьЗапрос(ТекстЗапроса, ВнешниеДанные.ПолучитьСтрокуПодключенияMSSQL("srv-sql03", "Loyalty"));
	ТЗ = Телеграм.База_РезультатЗапросВТаблицуЗначений(Результат);
	Возврат ТЗ.ВыгрузитьКолонку("id_tov");

КонецФункции


&НаСервере
Процедура ЗаполнитьСписокНовинокНаСервере()
	
	МассивНовинок = ПолучитьМассивИдТоваров(Истина);
	
	Запрос = Новый Запрос(
	"ВЫБРАТЬ
	|	Номенклатура.Ссылка КАК Товар,
	|	КОЛИЧЕСТВО(РАЗЛИЧНЫЕ ОтзывНГ.Ссылка) КАК Отзывы,
	|	КОЛИЧЕСТВО(РАЗЛИЧНЫЕ РассылкаТелеграм.Ссылка) КАК Рассылки,
	|	МАКСИМУМ(ОтзывНГ.ДатаОтзыва) КАК ДатаОтзыва,
	|	ЕСТЬNULL(НГОтзывыСобраны.ОтзывыСобраны, ЛОЖЬ) КАК Собраны
	|ИЗ
	|	Справочник.Номенклатура КАК Номенклатура
	|		ЛЕВОЕ СОЕДИНЕНИЕ Документ.РассылкаТелеграм КАК РассылкаТелеграм
	|		ПО (РассылкаТелеграм.ТоварНГ = Номенклатура.Ссылка)
	|		ЛЕВОЕ СОЕДИНЕНИЕ Документ.ОтзывНГ КАК ОтзывНГ
	|		ПО (ОтзывНГ.ТоварНГ = Номенклатура.Ссылка)
	|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.НГОтзывыСобраны КАК НГОтзывыСобраны
	|		ПО НГОтзывыСобраны.Товар = Номенклатура.Ссылка
	|ГДЕ
	|	Номенклатура.id_tov В(&МассивНовинок)
	|
	|СГРУППИРОВАТЬ ПО
	|	Номенклатура.Ссылка,
	|	ЕСТЬNULL(НГОтзывыСобраны.ОтзывыСобраны, ЛОЖЬ)
	|
	|УПОРЯДОЧИТЬ ПО
	|	ДатаОтзыва УБЫВ,
	|	Номенклатура.Наименование");
	Запрос.УстановитьПараметр("МассивНовинок", МассивНовинок);
	СписокНовинок.Загрузить(Запрос.Выполнить().Выгрузить());
	
КонецПроцедуры

&НаКлиенте
Процедура СписокНовинокПриАктивизацииСтроки(Элемент)
	
	Если НЕ Элементы.СписокНовинок.ТекущиеДанные = Неопределено Тогда
		ВыбранныйТовар = Элементы.СписокНовинок.ТекущиеДанные.Товар;
		УстановитьОтборыПоТоваруНаСервере(ВыбранныйТовар);
		ПолучитьАвтоматическуюРассылку(ВыбранныйТовар);
		Элементы.Активна.Доступность = Истина;			
	Иначе
		УстановитьОтборыПоТоваруНаСервере(Неопределено);
		Активна = Ложь;
		Элементы.Активна.Доступность = Ложь;	
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура СписокНеНовинокПриАктивизацииСтроки(Элемент)
	
	Если НЕ Элементы.СписокНеНовинок.ТекущиеДанные = Неопределено Тогда
		ВыбранныйТовар = Элементы.СписокНеНовинок.ТекущиеДанные.Товар;
		УстановитьОтборыПоТоваруНаСервере(ВыбранныйТовар);
		ПолучитьАвтоматическуюРассылку(ВыбранныйТовар);
	Иначе
		УстановитьОтборыПоТоваруНаСервере(Неопределено);
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура УстановитьОтборыПоТоваруНаСервере(ВыбранныйТовар)
	
	//ОбщегоНазначенияКлиентСервер.НайтиЭлементОтбораПоПредставлению(СписокРассылок.Отбор.Элементы, "Товар");
	
	СписокРассылок.Отбор.Элементы.Очистить();
	ЭлементОтбора = СписокРассылок.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ЭлементОтбора.ЛевоеЗначение 	= Новый ПолеКомпоновкиДанных("ТоварНГ");
	ЭлементОтбора.ВидСравнения 		= ВидСравненияКомпоновкиДанных.Равно;
	ЭлементОтбора.Использование 	= Истина;
	ЭлементОтбора.ПравоеЗначение 	= ВыбранныйТовар;
	ЭлементОтбора.РежимОтображения = РежимОтображенияЭлементаНастройкиКомпоновкиДанных.Недоступный;	
	
	СписокОтзывов.Отбор.Элементы.Очистить();
	ЭлементОтбора = СписокОтзывов.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ЭлементОтбора.ЛевоеЗначение 	= Новый ПолеКомпоновкиДанных("ТоварНГ");
	ЭлементОтбора.ВидСравнения 		= ВидСравненияКомпоновкиДанных.Равно;
	ЭлементОтбора.Использование 	= Истина;
	ЭлементОтбора.ПравоеЗначение 	= ВыбранныйТовар;
	ЭлементОтбора.РежимОтображения = РежимОтображенияЭлементаНастройкиКомпоновкиДанных.Недоступный;		
		
КонецПроцедуры

&НаСервере
Процедура ПолучитьАвтоматическуюРассылку(ВыбранныйТовар)
	
	КодТовара = ВыбранныйТовар.id_tov;
	ТекстЗапроса = 
	"DECLARE
	|@id_tov int = " + Формат(КодТовара, "ЧН=0; ЧГ=") + ", @Qty_send int, @is_active bit, @date_deactivate date, @QTY_max int 
	|EXEC [vv03].[dbo].[Mailing_forNG_Stat_1]
	|@id_tov, @Qty_send	OUTPUT, @is_active	OUTPUT, @date_deactivate OUTPUT, @QTY_max output  
	|SELECT
	|@id_tov as id_tov, isNULL(@Qty_send, 0) as Qty_send, isNULL(@is_active, 0) as is_active, isNULL(@QTY_max, 0) as QTY_max";
	Результат = Телеграм.База_ВыполнитьЗапрос(ТекстЗапроса,
		ВнешниеДанные.ПолучитьСтрокуПодключенияMSSQL("srv-sql03", "Loyalty"));
	ТЗ = Телеграм.База_РезультатЗапросВТаблицуЗначений(Результат);	
	
	Если НЕ ТипЗнч(ТЗ) = Тип("ТаблицаЗначений") ИЛИ ТЗ.Количество() = 0 Тогда
		Активна = Ложь;
		Отправлено = 0;
		Ограничение = 0;
	Иначе
		Активна = (ТЗ[0].is_active=1);
		Отправлено = ТЗ[0].Qty_send;
		Ограничение = ТЗ[0].QTY_max;
	КонецЕсли;
		
КонецПроцедуры

&НаКлиенте
Процедура ЗагрузитьОтзывы(Команда)
	
	ЗагрузитьОтзывыНаСервере();
	ОбновитьТекущуюВкладку();
	
КонецПроцедуры

&НаСервере
Процедура ЗагрузитьОтзывыНаСервере()
	Телеграм.ЗагрузитьОтзывы();
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	ЗаполнитьСписокНовинокНаСервере();
	
КонецПроцедуры

&НаКлиенте
Процедура Настройка(Команда)
	ОткрытьФорму("ОбщаяФорма.НастройкаНародногоГурмана");
КонецПроцедуры

&НаКлиенте
Процедура ОтзывыСобраны(Команда)
	
	Если НЕ Элементы.СписокНовинок.ТекущиеДанные = Неопределено Тогда
		ОтзывыСобраныНаСервере(Элементы.СписокНовинок.ТекущиеДанные.Товар);
		АктивнаПриИзмененииНаСервере(Элементы.СписокНовинок.ТекущиеДанные.Товар, Истина);
		ЗаполнитьСписокНовинокНаСервере();
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ОтзывыСобраныНаСервере(Товар)
	
	МЗ = РегистрыСведений.НГОтзывыСобраны.СоздатьМенеджерЗаписи();
	МЗ.Товар = Товар;
	МЗ.ОтзывыСобраны = Истина;
	МЗ.Записать(Истина);	
		
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьСписокНеНовинокНаСервере()
	
	МассивНеНовинок = ПолучитьМассивИдТоваров(Ложь);
	
	Запрос = Новый Запрос(
	"ВЫБРАТЬ
	|	Номенклатура.Ссылка КАК Товар,
	|	КОЛИЧЕСТВО(РАЗЛИЧНЫЕ ОтзывНГ.Ссылка) КАК Отзывы,
	|	КОЛИЧЕСТВО(РАЗЛИЧНЫЕ РассылкаТелеграм.Ссылка) КАК Рассылки,
	|	МАКСИМУМ(ОтзывНГ.ДатаОтзыва) КАК ДатаОтзыва,
	|	ЕСТЬNULL(НГОтзывыСобраны.ОтзывыСобраны, ЛОЖЬ) КАК Собраны
	|ИЗ
	|	Справочник.Номенклатура КАК Номенклатура
	|		ЛЕВОЕ СОЕДИНЕНИЕ Документ.РассылкаТелеграм КАК РассылкаТелеграм
	|		ПО (РассылкаТелеграм.ТоварНГ = Номенклатура.Ссылка)
	|		ЛЕВОЕ СОЕДИНЕНИЕ Документ.ОтзывНГ КАК ОтзывНГ
	|		ПО (ОтзывНГ.ТоварНГ = Номенклатура.Ссылка)
	|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.НГОтзывыСобраны КАК НГОтзывыСобраны
	|		ПО НГОтзывыСобраны.Товар = Номенклатура.Ссылка
	|ГДЕ
	|	Номенклатура.id_tov В(&МассивНеНовинок)
	|
	|СГРУППИРОВАТЬ ПО
	|	Номенклатура.Ссылка,
	|	ЕСТЬNULL(НГОтзывыСобраны.ОтзывыСобраны, ЛОЖЬ)
	|
	|УПОРЯДОЧИТЬ ПО
	|	ДатаОтзыва УБЫВ,
	|	Номенклатура.Наименование");
	Запрос.УстановитьПараметр("МассивНеНовинок", МассивНеНовинок);
	СписокНеНовинок.Загрузить(Запрос.Выполнить().Выгрузить());
	
КонецПроцедуры

&НаКлиенте
Процедура ЗаполнитьСписокНеНовинок(Команда)
	ЗаполнитьСписокНеНовинокНаСервере();
КонецПроцедуры

&НаКлиенте
Процедура Группа4ПриСменеСтраницы(Элемент, ТекущаяСтраница)
	
	ОбновитьТекущуюВкладку();
	
КонецПроцедуры

&НаКлиенте
Процедура ОбновитьТекущуюВкладку()
	
	Если Элементы.Группа4.ТекущаяСтраница = Элементы.НеНовинки тогда 
		ЗаполнитьСписокНеНовинокНаСервере()
	ИначеЕсли Элементы.Группа4.ТекущаяСтраница = Элементы.Новинки тогда
		ЗаполнитьСписокНовинокНаСервере()
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура АктивнаПриИзмененииНаСервере(Товар, Выключить = Ложь)
	// Вставить содержимое обработчика.

	КодТовара = Формат(Товар.id_tov, "ЧГ=");
	Если Выключить Тогда
		Активна = Ложь;
	КонецЕсли;		
	Метка = ?(Активна, "1", "0");		
	
	ТекстЗапроса = 
		"EXEC vv03.[dbo].[Mailing_forNG_Edit] " + КодТовара + ", " + Метка + ", NULL, NULL";
	Результат = Телеграм.База_ВыполнитьЗапрос(ТекстЗапроса,
		ВнешниеДанные.ПолучитьСтрокуПодключенияMSSQL("srv-sql03", "Loyalty"));
	
КонецПроцедуры

&НаКлиенте
Процедура АктивнаПриИзменении(Элемент)
	
	Если ЗначениеЗаполнено(ВыбранныйТовар) Тогда
		АктивнаПриИзмененииНаСервере(ВыбранныйТовар);	
	КонецЕсли;
	
КонецПроцедуры


&НаСервере
Процедура УстановитьОграничениеНаСервере(Товар)
	
	КодТовара = Формат(Товар.id_tov, "ЧГ=");	
	
	ТекстЗапроса = 
		"EXEC vv03.[dbo].[Mailing_forNG_Edit] " + КодТовара + ", NULL, NULL, " + Формат(Ограничение, "ЧН=0; ЧГ=");
	Результат = Телеграм.База_ВыполнитьЗапрос(ТекстЗапроса,
		ВнешниеДанные.ПолучитьСтрокуПодключенияMSSQL("srv-sql03", "Loyalty"));
	
КонецПроцедуры


&НаКлиенте
Процедура УстановитьОграничение(Команда)
	
	Если ЗначениеЗаполнено(ВыбранныйТовар) Тогда
		УстановитьОграничениеНаСервере(ВыбранныйТовар);	
		Предупреждение("Установлено ограничение количества сообщений: " + Формат(Ограничение, "ЧН=0; ЧГ="), 4);
	КонецЕсли;	
	
КонецПроцедуры

