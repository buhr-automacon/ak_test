﻿
Процедура ОбработкаПроведения(Отказ, РежимПроведения)
	//{{__КОНСТРУКТОР_ДВИЖЕНИЙ_РЕГИСТРОВ
	// Данный фрагмент построен конструктором.
	// При повторном использовании конструктора, внесенные вручную изменения будут утеряны!!!

	// регистр ЦеныНоменклатуры
	МассивТовары = Новый Массив();
	Движения.ЦеныНоменклатуры.Записывать = Истина;
	Движения.ЦеныНоменклатуры.Очистить();
	Для Каждого ТекСтрокаТовары Из Товары Цикл
		Движение = Движения.ЦеныНоменклатуры.Добавить();
		Движение.Период = Дата;
		Движение.ТипЦен = ТекСтрокаТовары.ТипЦен;
		Движение.ТорговаяТочка = ТекСтрокаТовары.ТорговаяТочка;
		Движение.Номенклатура = ТекСтрокаТовары.Номенклатура;
		Движение.Характеристика = ТекСтрокаТовары.Характеристика;
		Движение.Валюта = ТекСтрокаТовары.Валюта;
		Движение.Цена = ТекСтрокаТовары.Цена;
		МассивТовары.Добавить(ТекСтрокаТовары.Номенклатура);
	КонецЦикла;
	
	Запрос = Новый Запрос();
	Запрос.Текст = "ВЫБРАТЬ
	               |	Таб.Номенклатура
	               |ПОМЕСТИТЬ ВТ_Номенклатура
	               |ИЗ
	               |	&Таб КАК Таб
	               |ГДЕ
	               |	Таб.ТорговаяТочка = ЗНАЧЕНИЕ(Справочник.СтруктурныеЕдиницы.ПустаяСсылка)
	               |	И Таб.ТипЦен = ЗНАЧЕНИЕ(Справочник.ТипыЦен.ОсновнойТипЦенПродаж)
	               |;
	               |
	               |////////////////////////////////////////////////////////////////////////////////
	               |ВЫБРАТЬ
	               |	ЦеныНоменклатурыСрезПоследних.ТипЦен,
	               |	ЦеныНоменклатурыСрезПоследних.ТорговаяТочка,
	               |	ЦеныНоменклатурыСрезПоследних.Номенклатура,
	               |	ЦеныНоменклатурыСрезПоследних.Характеристика,
	               |	ЦеныНоменклатурыСрезПоследних.Валюта
	               |ИЗ
	               |	РегистрСведений.ЦеныНоменклатуры.СрезПоследних(
	               |			&Дата,
	               |			Номенклатура В
	               |					(ВЫБРАТЬ
	               |						ВТ_Номенклатура.Номенклатура
	               |					ИЗ
	               |						ВТ_Номенклатура КАК ВТ_Номенклатура)
	               |				И ТорговаяТочка <> ЗНАЧЕНИЕ(Справочник.СтруктурныеЕдиницы.ПустаяСсылка)
	               |				И ТипЦен = ЗНАЧЕНИЕ(Справочник.ТипыЦен.ОсновнойТипЦенПродаж)) КАК ЦеныНоменклатурыСрезПоследних
	               |ГДЕ
	               |	ЦеныНоменклатурыСрезПоследних.Цена <> 0
	               |;
	               |
	               |////////////////////////////////////////////////////////////////////////////////
	               |УНИЧТОЖИТЬ ВТ_Номенклатура";
				   
	Запрос.УстановитьПараметр("Таб", Товары.Выгрузить());
	Запрос.УстановитьПараметр("Дата", Дата - 1);
	
	Выборка = Запрос.Выполнить().Выбрать();
	
	Пока Выборка.Следующий() Цикл
		Движение = Движения.ЦеныНоменклатуры.Добавить();
		Движение.Период = Дата;
		Движение.ТипЦен = Выборка.ТипЦен;
		Движение.ТорговаяТочка = Выборка.ТорговаяТочка;
		Движение.Номенклатура = Выборка.Номенклатура;
		Движение.Характеристика = Выборка.Характеристика;
		Движение.Валюта = Выборка.Валюта;
		Движение.Цена = 0;
	КонецЦикла;
	
	//МассивПараметров = Новый Массив(2);
	//МассивПараметров[0] = Неопределено;
	//МассивПараметров[1] = МассивТовары;
	//Ключ = Новый УникальныйИдентификатор;
	//
	//ФоновыеЗадания.Выполнить("РегламентныеЗаданияСервер.ПересчитатьНеобходимостьПечатиЦенников", МассивПараметров, Ключ, "Пересчет необходимости печати ценников");
	//ФоновыеЗадания.Выполнить("РегламентныеЗаданияСервер.ПересчитатьНеобходимостьПечатиЦенниковТТ", МассивПараметров, Ключ, "Пересчет необходимости печати ценников ТТ");

	//}}__КОНСТРУКТОР_ДВИЖЕНИЙ_РЕГИСТРОВ
	
	//+++АК mika 2018.12.14 ИП-00020382 Отправлять рассылку при каждом изменении цен по Вендингам 
	МассивПараметров = Новый Массив();
	МассивПараметров.Добавить(Ссылка);
	ФоновыеЗадания.Выполнить("РегламентныеЗаданияСервер.ВыполнитьРассылкуПоИзменениюРозничныхЦенВкусоматы", МассивПараметров, Новый УникальныйИдентификатор(), "Отправка рассылки изменение цен (Вкусоматы)"); 
	//---АК mika
	
КонецПроцедуры
