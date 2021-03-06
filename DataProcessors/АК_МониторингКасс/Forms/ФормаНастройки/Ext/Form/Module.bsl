﻿&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	Для Каждого СтрокаОтбор Из Параметры.НастройкиОтбора Цикл
		СтрокаТаблицы = ТаблицаНастроекОтбора.Добавить();
		ЗаполнитьЗначенияСвойств(СтрокаТаблицы,СтрокаОтбор);
		Если СтрокаОтбор.Условие = "IN" Тогда
			СписокВыбора = Новый СписокЗначений;
			СписокВыбора.ТипЗначения=Новый ОписаниеТипов("Число");
			СтрокаЗначений = СтрЗаменить(СтрокаОтбор.Значение,"(","");
			СтрокаЗначений = СтрЗаменить(СтрокаЗначений,")","");
			МассивЗначений = ОбщегоНазначения.РазложитьСтрокуВМассивПодстрок(СтрокаЗначений,",");
			Для Каждого Значение из МассивЗначений Цикл
				Попытка
					ЗначениеКакЧисло=Число(Значение)
				Исключение
					ЗначениеКакЧисло = 0
				КонецПопытки;
				СписокВыбора.Добавить(ЗначениеКакЧисло)
			КонецЦикла;
			СтрокаТаблицы.Значение = СписокВыбора;
		КонецЕсли;
	КонецЦикла;
	Если Параметры.Свойство("ВыбиратьПервых") Тогда
		ВыбиратьПервые = Параметры.ВыбиратьПервых
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура УстановитьТипЗначенияПоляЗначение(ТекущиеДанные)
	Если ТекущиеДанные.Поле = "Action" Тогда
		ТекущиеДанные.Значение = Формат(Строка(ТекущиеДанные.Значение),"Ч")
	ИначеЕсли ТекущиеДанные.Поле = "ПредыдущОпер" Тогда
		ТекущиеДанные.Значение = Формат(Строка(ТекущиеДанные.Значение),"Ч")
	ИначеЕсли (ТекущиеДанные.Поле = "DateTime")Тогда
		Если(ТипЗнч(ТекущиеДанные.Значение)<>Тип("Дата")) Тогда
			ТекущиеДанные.Значение = Дата(1,1,1)
		КонецЕсли;
	Иначе
		Попытка
			ТекущиеДанные.Значение = Число(ТекущиеДанные.Значение)
		Исключение
			ТекущиеДанные.Значение = 0
		КонецПопытки
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура ТаблицаНастроекОтбораУсловиеПриИзменении(Элемент)
	ТекущиеДанные = Элементы.ТаблицаНастроекОтбора.ТекущиеДанные;
	Если ТекущиеДанные.Условие = "IN" Тогда
		ТекущиеДанные.Значение = Новый СписокЗначений;
		ТекущиеДанные.Значение.ТипЗначения= Новый ОписаниеТипов("Число")
	Иначе
		УстановитьТипЗначенияПоляЗначение(ТекущиеДанные)
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура ТаблицаНастроекОтбораУсловиеОбработкаВыбора(Элемент, ВыбранноеЗначение, СтандартнаяОбработка)
КонецПроцедуры

&НаКлиенте
Процедура ТаблицаНастроекОтбораУсловиеНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	ДанныеВыбора = Элемент.СписокВыбора;
	ДанныеВыбора.Очистить();
	ДанныеВыбора.Добавить("=");
	ДанныеВыбора.Добавить("<>");
	ТекущиеДанные = Элементы.ТаблицаНастроекОтбора.ТекущиеДанные;
	Если (ТекущиеДанные.Поле = "Action")или(ТекущиеДанные.Поле = "ПредыдущОпер") Тогда
		ДанныеВыбора.Добавить("Like")
	Иначе
		ДанныеВыбора.Добавить("IN");
		ДанныеВыбора.Добавить(">");
		ДанныеВыбора.Добавить("<");
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура ТаблицаНастроекОтбораПолеПриИзменении(Элемент)
	ТекущиеДанные = Элементы.ТаблицаНастроекОтбора.ТекущиеДанные;
	Если ТекущиеДанные.Условие = "IN" Тогда
		Если ТекущиеДанные.Поле = "Action" Тогда
			ТекущиеДанные.Условие = "="
		ИначеЕсли ТекущиеДанные.Поле = "ПредыдущОпер" Тогда
			ТекущиеДанные.Условие = "="
		ИначеЕсли ТипЗнч(ТекущиеДанные.Значение)<>Тип("СписокЗначений")Тогда
			ТекущиеДанные.Условие = "="
		Иначе
			Возврат
		КонецЕсли;
	КонецЕсли;
	УстановитьТипЗначенияПоляЗначение(ТекущиеДанные)
КонецПроцедуры

&НаКлиенте
Процедура ПередЗакрытием(Отказ, СтандартнаяОбработка)
	//Вставить содержимое обработчика
КонецПроцедуры

&НаКлиенте
Процедура ПриЗакрытии()
	//Вставить содержимое обработчика
КонецПроцедуры

&НаКлиенте
Процедура ТаблицаНастроекОтбораУсловиеНачалоВыбораИзСписка(Элемент, СтандартнаяОбработка)
	//Элемент.СписокВыбора = ДанныеВыбора;
КонецПроцедуры

&НаКлиенте
Процедура Применить(Команда)
	МассивОтбор = Новый Массив;
	Для Каждого СтрокаОтбор из ТаблицаНастроекОтбора Цикл
		СтруктураОтбор = Новый Структура("Использовать,Поле,Условие,Значение");
		ЗаполнитьЗНаченияСвойств(СтруктураОтбор,СтрокаОтбор);
		Если СтрокаОтбор.Условие = "IN" Тогда
			СписокСтрокой = "";
			Для Каждого ЗнчСписка из СтрокаОтбор.Значение Цикл
				СписокСтрокой = СписокСтрокой+Формат(ЗнчСписка.Значение,"ЧН=; ЧГ=0")+","
			КонецЦикла;
			Если СписокСтрокой="" Тогда
				Продолжить
			КонецЕсли;
			СписокСтрокой = Лев(СписокСтрокой,СтрДлина(СписокСтрокой)-1);
			СтруктураОтбор.Значение = "("+СписокСтрокой+")";
		КонецЕсли;
		МассивОтбор.Добавить(СтруктураОтбор);
	КонецЦикла;
	Закрыть(Новый Структура("МассивОтбор,ВыбиратьПервые",МассивОтбор,ВыбиратьПервые))
КонецПроцедуры

&НаКлиенте
Процедура Отменить(Команда)
	Закрыть(Неопределено)
КонецПроцедуры
