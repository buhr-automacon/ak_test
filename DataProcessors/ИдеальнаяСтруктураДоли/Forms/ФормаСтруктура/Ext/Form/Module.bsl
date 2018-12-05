﻿
&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Заголовок = "Идеальная структура с " + Формат(Параметры.ДатаСтарта, "ДФ=dd.MM.yyyy");
	ЗаполнитьТаблицуПлановСтруктур();
	
КонецПроцедуры

&НаКлиенте
// Возвращает для управляемых форм полный путь к форме отчёта, внешней обработки или любого объекта метаданных в виде:
// "Отчет.<ИмяОтчёта>.Форма.ИмяФормы"
// "ВнешняяОбработка.<ИмяВнешнейОбработки>.Форма.ИмяФормы"
// "Документ.<ИмяОбъекта>.Форма.ИмяФормы"
//
// Может быть полезна при встраивании внешней обработки/отчёта в конфигурацию или переименовании объекта, т.к. не требуется изменять вызовы форм. 
//
Функция ПолучитьПолноеИмяФормы(ИмяВызвавшейФормы, ИмяФормы = "")
	
    ПозицияТочки = СтрДлина(ИмяВызвавшейФормы);
    Пока Сред(ИмяВызвавшейФормы, ПозицияТочки, 1) <> "." Цикл ПозицияТочки = ПозицияТочки - 1; КонецЦикла;
    Возврат Лев(ИмяВызвавшейФормы, ПозицияТочки - 1) + ?(ПустаяСтрока(ИмяФормы), "", "." + ИмяФормы);
	
КонецФункции

&НаСервере
Процедура ЗаполнитьТаблицуПлановСтруктур()
	
	Объект.ТаблицаПлановСтруктур.Очистить();
	
	ТекстЗапросаSQL = "
		|DECLARE @date_start date = " + ВнешниеДанные.ФорматПоля(Параметры.ДатаСтарта, Истина) + "
		|
		|SELECT
		|	a.[id_group] [КодГруппы],
		|	gr.Name_gr [Группа],
		|	[PlanProc] [Доля],
		|	CAST([date_start] AS datetime) [ДатаСтарта]
		|
		|FROM
		|	[Reports].[dbo].[PlanStructury_GroupTov] a
		|	inner join M2..[Group tovari] as gr 
		|		on a.id_group=gr.id_group
		|
		|WHERE
		|	date_start = @date_start
		|";
	
	ADOСоединение = ВнешниеДанные.ПолучитьADOСоединение();
	rs = ADOСоединение.Execute(ТекстЗапросаSQL);
	Пока rs <> Неопределено И rs.Fields.Count <= 0 Цикл
		rs=rs.NextRecordSet();
	КонецЦикла;
	
	Попытка
		rs.MoveFirst();
		
		МассивПолей = СтроковыеФункцииКлиентСервер.РазложитьСтрокуВМассивПодстрок("КодГруппы,Группа,Доля,ДатаСтарта", ",", Истина, Истина);
		Пока НЕ rs.EOF() Цикл
			НоваяСтрокаТЗ = Объект.ТаблицаПлановСтруктур.Добавить();
			Для Каждого ИмяПоля Из МассивПолей Цикл
				НоваяСтрокаТЗ[ИмяПоля] = Rs.Fields(ИмяПоля).Value;
			КонецЦикла;
			rs.MoveNext();
		КонецЦикла;
	Исключение
	КонецПопытки;
	ADOСоединение.Close();
	
КонецПроцедуры

&НаКлиенте
Процедура ОбновитьТаблицуПлановСтруктур(Команда)
	ЗаполнитьТаблицуПлановСтруктур();
КонецПроцедуры

&НаКлиенте
Процедура УдалитьЗаписьИзСтруктуры(Команда)
	
	ТекущиеДанные = Элементы.ТаблицаПлановСтруктур.ТекущиеДанные;
	Если ТекущиеДанные = Неопределено Тогда Возврат; КонецЕсли;
	
	ДопПараметры = Новый Структура("КодГруппы,ДатаСтарта");
	ЗаполнитьЗначенияСвойств(ДопПараметры, ТекущиеДанные);
	ДопПараметры.Вставить("Идентификатор", ТекущиеДанные.ПолучитьИдентификатор());
	ОповещениеЗавершения = Новый ОписаниеОповещения("УдалитьЗаписьИзСтруктурыЗавершение", ЭтаФорма, ДопПараметры);
	ПоказатьВопрос(ОповещениеЗавершения, "Удалить текущую запись?", РежимДиалогаВопрос.ДаНетОтмена);
	
КонецПроцедуры

&НаКлиенте
Процедура УдалитьЗаписьИзСтруктурыЗавершение(Результат, ДопПараметры) Экспорт
	
	Если Результат <> КодВозвратаДиалога.Да Тогда Возврат; КонецЕсли;
	
	Если УдалитьЗаписьИзСтруктурыНаСервере(ДопПараметры) Тогда
		Объект.ТаблицаПлановСтруктур.Удалить(Объект.ТаблицаПлановСтруктур.НайтиПоИдентификатору(ДопПараметры.Идентификатор));
		Элементы.ТаблицаПлановСтруктур.Обновить();
	КонецЕсли;
	
КонецПроцедуры

&НаСервереБезКонтекста
Функция УдалитьЗаписьИзСтруктурыНаСервере(ДопПараметры)
	
	ТекстЗапросаSQL = "
		|DELETE
		|
		|FROM
		|	[Reports].[dbo].[PlanStructury_GroupTov]
		|
		|WHERE
		|	date_start = " + ВнешниеДанные.ФорматПоля(ДопПараметры.ДатаСтарта, Истина) + "
		|	AND id_group = " + ВнешниеДанные.ФорматПоля(ДопПараметры.КодГруппы, Истина) + "
		|";
	
	ADOСоединение = ВнешниеДанные.ПолучитьADOСоединение();
	
	Попытка
		rs = ADOСоединение.Execute(ТекстЗапросаSQL);
		Ответ = Истина;
	Исключение
		Ответ = Ложь;
		Сообщить(ОписаниеОшибки());
	КонецПопытки; 
	
	ADOСоединение.Close();
	Возврат Ответ;
	
КонецФункции

&НаКлиенте
Процедура ПриЗакрытии()
	Оповестить("ОбновитьИдеальныеСтруктуры");
КонецПроцедуры
