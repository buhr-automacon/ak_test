﻿
&НаСервереБезКонтекста
Функция ПолучитьСписокПериодичностей()
	
	мПериодичность = Перечисления.Периодичность;
	
	СписокПериодичностей = Новый СписокЗначений;
	СписокПериодичностей.Добавить(мПериодичность.День);
	СписокПериодичностей.Добавить(мПериодичность.Неделя);
	СписокПериодичностей.Добавить(мПериодичность.Месяц);
	СписокПериодичностей.Добавить(мПериодичность.Год);
	
	Возврат СписокПериодичностей;
	
КонецФункции

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)

	Если Запись.Периодичность.Пустая() Тогда
		Запись.Периодичность = ПредопределенноеЗначение("Перечисление.Периодичность.Месяц");
	КонецЕсли;
	Если НЕ ЗначениеЗаполнено(Запись.ДатаНачала) Тогда
		Если Запись.Периодичность = ПредопределенноеЗначение("Перечисление.Периодичность.Неделя") Тогда
			Запись.ДатаНачала = НачалоНедели(ТекущаяДата());
		ИначеЕсли Запись.Периодичность = ПредопределенноеЗначение("Перечисление.Периодичность.Месяц") Тогда
			Запись.ДатаНачала = НачалоМесяца(ТекущаяДата());
		ИначеЕсли Запись.Периодичность = ПредопределенноеЗначение("Перечисление.Периодичность.Год") Тогда
			Запись.ДатаНачала = НачалоГода(ТекущаяДата());
		Иначе
			Запись.ДатаНачала = ТекущаяДата();
		КонецЕсли;
	КонецЕсли;
	Если НЕ ЗначениеЗаполнено(Запись.ДатаОкончания) Тогда
		Если Запись.Периодичность = ПредопределенноеЗначение("Перечисление.Периодичность.Неделя") Тогда
			Запись.ДатаОкончания = КонецНедели(Запись.ДатаНачала);
		ИначеЕсли Запись.Периодичность = ПредопределенноеЗначение("Перечисление.Периодичность.Месяц") Тогда
			Запись.ДатаОкончания = НачалоМесяца(Запись.ДатаНачала);
		ИначеЕсли Запись.Периодичность = ПредопределенноеЗначение("Перечисление.Периодичность.Год") Тогда
			Запись.ДатаОкончания = НачалоГода(Запись.ДатаНачала);
		Иначе
			Запись.ДатаОкончания = ТекущаяДата();
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры


&НаКлиенте
Процедура КонтрагентНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	#Если ТолстыйКлиентОбычноеПриложение Тогда
	СтандартнаяОбработка = Ложь;
	
	ФормаВыбора = ПолучитьФорму("Справочник.Контрагенты.ФормаВыбора",, Элемент);
	ФормаВыбора.НачальноеЗначениеВыбора = Запись.Контрагент;
	
	ФормаВыбора.Отбор.ОказываетРегламентныеУслуги.Установить(Истина);
	
	ФормаВыбора.Открыть();
	#КонецЕсли
	
КонецПроцедуры

&НаКлиенте
Процедура УслугаНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	#Если ТолстыйКлиентОбычноеПриложение Тогда
	СтандартнаяОбработка = Ложь;
	
	ФормаВыбора = ПолучитьФорму("Справочник.Номенклатура.ФормаВыбора",, Элемент);
	ФормаВыбора.НачальноеЗначениеВыбора = Запись.Услуга;
	
	ФормаВыбора.Отбор.ВидНоменклатуры.Установить(Перечисления.ВидыНоменклатуры.Услуга);
	ФормаВыбора.ЭлементыФормы.СправочникСписок.НастройкаОтбора.ВидНоменклатуры.Доступность = Ложь;
	
	ФормаВыбора.Открыть();
	#КонецЕсли
	
КонецПроцедуры

&НаКлиенте
Процедура ТорговаяТочкаНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	#Если ТолстыйКлиентОбычноеПриложение Тогда
	СтандартнаяОбработка = Ложь;
	
	ФормаВыбора = ПолучитьФорму("Справочник.СтруктурныеЕдиницы.ФормаВыбора",, Элемент);
	ФормаВыбора.НачальноеЗначениеВыбора = Запись.ТорговаяТочка;
	
	ФормаВыбора.Отбор.Активное.Установить(Истина);
	
	ФормаВыбора.Отбор.ТипСтруктурнойЕдиницы.Установить(Перечисления.ТипыСтруктурныхЕдиниц.Розница);
	ФормаВыбора.ЭлементыФормы.СправочникСписок.НастройкаОтбора.ТипСтруктурнойЕдиницы.Доступность = Ложь;
	
	ФормаВыбора.Отбор.ТипРозничнойТочки.Установить(Перечисления.ТипыРозничныхТочек.Магазин);
	ФормаВыбора.ЭлементыФормы.СправочникСписок.НастройкаОтбора.ТипРозничнойТочки.Доступность = Ложь;
	
	ФормаВыбора.Открыть();
	#КонецЕсли
	
КонецПроцедуры

&НаКлиенте
Процедура ПериодичностьПриИзменении(Элемент)
	
	Если ЗначениеЗаполнено(Запись.ДатаНачала) Тогда
		Если Запись.Периодичность = ПредопределенноеЗначение("Перечисление.Периодичность.Неделя")
				 И НЕ Запись.ДатаНачала = НачалоНедели(Запись.ДатаНачала) Тогда
			Запись.ДатаНачала = НачалоНедели(Запись.ДатаНачала);
		ИначеЕсли Запись.Периодичность = ПредопределенноеЗначение("Перечисление.Периодичность.Месяц")
				 И НЕ Запись.ДатаНачала = НачалоМесяца(Запись.ДатаНачала) Тогда
			Запись.ДатаНачала = НачалоМесяца(Запись.ДатаНачала);
		ИначеЕсли Запись.Периодичность = ПредопределенноеЗначение("Перечисление.Периодичность.Год")
				 И НЕ Запись.ДатаНачала = НачалоГода(Запись.ДатаНачала) Тогда
			Запись.ДатаНачала = НачалоГода(Запись.ДатаНачала);
		КонецЕсли;
	КонецЕсли;
	Если ЗначениеЗаполнено(Запись.ДатаОкончания) Тогда
		Если Запись.Периодичность = ПредопределенноеЗначение("Перечисление.Периодичность.Неделя")
				 И НЕ Запись.ДатаОкончания = КонецНедели(Запись.ДатаНачала) Тогда
			Запись.ДатаОкончания = КонецНедели(Запись.ДатаНачала);
		ИначеЕсли Запись.Периодичность = ПредопределенноеЗначение("Перечисление.Периодичность.Месяц")
				 И НЕ Запись.ДатаОкончания = КонецМесяца(Запись.ДатаНачала) Тогда
			Запись.ДатаОкончания = КонецМесяца(Запись.ДатаНачала);
		ИначеЕсли Запись.Периодичность = ПредопределенноеЗначение("Перечисление.Периодичность.Год")
				 И НЕ Запись.ДатаОкончания = КонецГода(Запись.ДатаНачала) Тогда
			Запись.ДатаОкончания = КонецГода(Запись.ДатаНачала);
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПериодичностьНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)

	СтандартнаяОбработка = Ложь;
	
	СписокПериодичностей = ПолучитьСписокПериодичностей();
	ВыбранныйЭлемент = ВыбратьИзСписка(СписокПериодичностей, Элемент, СписокПериодичностей.НайтиПоЗначению(Запись.Периодичность));
	Если НЕ ВыбранныйЭлемент = Неопределено Тогда
		Запись.Периодичность = ВыбранныйЭлемент.Значение;
		ПериодичностьПриИзменении(Элемент);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ДатаНачалаПриИзменении(Элемент)
	
	Если ЗначениеЗаполнено(Запись.ДатаНачала) Тогда
		Если Запись.Периодичность = ПредопределенноеЗначение("Перечисление.Периодичность.Неделя")
				 И НЕ Запись.ДатаНачала = НачалоНедели(Запись.ДатаНачала) Тогда
			Запись.ДатаНачала = НачалоНедели(Запись.ДатаНачала);
		ИначеЕсли Запись.Периодичность = ПредопределенноеЗначение("Перечисление.Периодичность.Месяц")
				 И НЕ Запись.ДатаНачала = НачалоМесяца(Запись.ДатаНачала) Тогда
			Запись.ДатаНачала = НачалоМесяца(Запись.ДатаНачала);
		ИначеЕсли Запись.Периодичность = ПредопределенноеЗначение("Перечисление.Периодичность.Год")
				 И НЕ Запись.ДатаНачала = НачалоГода(Запись.ДатаНачала) Тогда
			Запись.ДатаНачала = НачалоГода(Запись.ДатаНачала);
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ДатаОкончанияПриИзменении(Элемент)
	
	Если ЗначениеЗаполнено(Запись.ДатаОкончания) Тогда
		Если Запись.Периодичность = ПредопределенноеЗначение("Перечисление.Периодичность.Неделя")
				 И НЕ Запись.ДатаОкончания = КонецНедели(Запись.ДатаНачала) Тогда
			Запись.ДатаОкончания = КонецНедели(Запись.ДатаНачала);
		ИначеЕсли Запись.Периодичность = ПредопределенноеЗначение("Перечисление.Периодичность.Месяц")
				 И НЕ Запись.ДатаОкончания = КонецМесяца(Запись.ДатаНачала) Тогда
			Запись.ДатаОкончания = КонецМесяца(Запись.ДатаНачала);
		ИначеЕсли Запись.Периодичность = ПредопределенноеЗначение("Перечисление.Периодичность.Год")
				 И НЕ Запись.ДатаОкончания = КонецГода(Запись.ДатаНачала) Тогда
			Запись.ДатаОкончания = КонецГода(Запись.ДатаНачала);
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры
