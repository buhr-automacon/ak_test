﻿
Процедура УдалитьНаСервере_()
	
	ОбрабатыватьСКоличеством = ЗначениеЗаполнено(ОставитьКоличество);
	
	Запрос = Новый Запрос();
	Запрос.УстановитьПараметр("Номенклатура", Товар);
	Запрос.УстановитьПараметр("ДатаРаспределения", ДатаРаспределения);
	Запрос.УстановитьПараметр("СтрЕдиница", Подразделение);
	Запрос.Текст = "ВЫБРАТЬ РАЗЛИЧНЫЕ
	               |	РасходныйОрдерСкладТовары.Ссылка,
	               |	РасходныйОрдерСкладТовары.Ссылка.Проведен
	               |ИЗ
	               |	Документ.РасходныйОрдерСклад.Товары КАК РасходныйОрдерСкладТовары
	               |ГДЕ
	               |	РасходныйОрдерСкладТовары.Номенклатура = &Номенклатура
	               |	И РасходныйОрдерСкладТовары.Ссылка.ДатаРаспределения = &ДатаРаспределения
	               |	И РасходныйОрдерСкладТовары.Ссылка.ВидОперации = ЗНАЧЕНИЕ(Перечисление.ВидыОперацийРасходСкладскойУчет.ОтгрузкаВТорговуюТочку)
	               |	И РасходныйОрдерСкладТовары.Ссылка.Проведен = ИСТИНА
	               |	И (РасходныйОрдерСкладТовары.Ссылка.Склад.Владелец = &СтрЕдиница
	               |			ИЛИ &СтрЕдиница = ЗНАЧЕНИЕ(Справочник.СтруктурныеЕдиницы.ПустаяСсылка))";
				   
	Выборка = Запрос.Выполнить().Выбрать();
	КолвоКОбработке = ОставитьКоличество;
	Пока Выборка.Следующий() Цикл
		ДокОб = Выборка.Ссылка.ПолучитьОбъект();
		КолвоСтрок = ДокОб.Товары.Количество();
		Для н = 1 По КолвоСтрок Цикл
			Если (ДокОб.Товары[КолвоСтрок - н].Номенклатура = Товар)
				И (НЕ ЗначениеЗаполнено(Характеристика) ИЛИ ДокОб.Товары[КолвоСтрок - н].Характеристика = Характеристика) Тогда
				Если ОбрабатыватьСКоличеством Тогда
					МожноОставить = Мин(ДокОб.Товары[КолвоСтрок - н].Количество, КолвоКОбработке);
					Если МожноОставить <> 0 Тогда
						Если МожноОставить < ДокОб.Товары[КолвоСтрок - н].Количество Тогда
							ДокОб.Товары[КолвоСтрок - н].Количество = МожноОставить;
						КонецЕсли;	
					Иначе
						ДокОб.Товары.Удалить(КолвоСтрок - н);
					КонецЕсли;
					КолвоКОбработке = КолвоКОбработке - МожноОставить;
				Иначе	
					ДокОб.Товары.Удалить(КолвоСтрок - н);
				КонецЕсли;	
			КонецЕсли;	
		КонецЦикла;
		Попытка
			Если ДокОб.Модифицированность() Тогда
				ДокОб.Записать(?(Выборка.Проведен, РежимЗаписиДокумента.Проведение, РежимЗаписиДокумента.Запись));
			КонецЕсли;	
		Исключение	
			Сообщить(ОписаниеОшибки());
		КонецПопытки;	
	КонецЦикла;	
	
КонецПроцедуры	

Процедура УдалитьНаСервере()
	
	ОбрабатыватьСКоличеством = ЗначениеЗаполнено(ОставитьКоличество);
	
	Запрос = Новый Запрос();
	Запрос.УстановитьПараметр("Номенклатура", Товар);
	Запрос.УстановитьПараметр("ДатаРаспределения", ДатаРаспределения);
	Запрос.УстановитьПараметр("СтрЕдиница", Подразделение);
	Запрос.УстановитьПараметр("Получатель", ПоМагазину);
	Запрос.Текст = "ВЫБРАТЬ РАЗЛИЧНЫЕ
	               |	РасходныйОрдерСкладТовары.Ссылка,
	               |	РасходныйОрдерСкладТовары.Ссылка.Проведен
	               |ИЗ
	               |	Документ.РасходныйОрдерСклад.Товары КАК РасходныйОрдерСкладТовары
	               |ГДЕ
	               |	РасходныйОрдерСкладТовары.Номенклатура = &Номенклатура
	               |	И РасходныйОрдерСкладТовары.Ссылка.ДатаРаспределения = &ДатаРаспределения
	               |	И РасходныйОрдерСкладТовары.Ссылка.ВидОперации = ЗНАЧЕНИЕ(Перечисление.ВидыОперацийРасходСкладскойУчет.ОтгрузкаВТорговуюТочку)
	               |	И РасходныйОрдерСкладТовары.Ссылка.Проведен = ИСТИНА
	               |	И (РасходныйОрдерСкладТовары.Ссылка.Склад.Владелец = &СтрЕдиница
	               |			ИЛИ &СтрЕдиница = ЗНАЧЕНИЕ(Справочник.СтруктурныеЕдиницы.ПустаяСсылка))
				   |	И (РасходныйОрдерСкладТовары.Ссылка.Получатель = &Получатель
	               |			ИЛИ &Получатель = ЗНАЧЕНИЕ(Справочник.СтруктурныеЕдиницы.ПустаяСсылка))";
				   
	Выборка = Запрос.Выполнить().Выбрать();
	КолвоКОбработке = ОставитьКоличество;
	Попытка
		НачатьТранзакцию();
		Пока Выборка.Следующий() Цикл
			ДокОб = Выборка.Ссылка.ПолучитьОбъект();
			КолвоСтрок = ДокОб.Товары.Количество();
			НаборУдалены = РегистрыСведений.ТоварыУдаленныеИзРасходниковОбработкой.СоздатьНаборЗаписей();
			НаборУдалены.Отбор.Период.Установить(ТекущаяДата());
			НаборУдалены.Отбор.Расходник.Установить(Выборка.Ссылка);
			Для н = 1 По КолвоСтрок Цикл
				Если (ДокОб.Товары[КолвоСтрок - н].Номенклатура = Товар)
					И (НЕ ЗначениеЗаполнено(Характеристика) ИЛИ ДокОб.Товары[КолвоСтрок - н].Характеристика = Характеристика) Тогда
					Если ОбрабатыватьСКоличеством Тогда
						НужноУдалить = Мин(ДокОб.Товары[КолвоСтрок - н].Количество, КолвоКОбработке);
						Если НужноУдалить <> ДокОб.Товары[КолвоСтрок - н].Количество Тогда
							Если НужноУдалить <> 0 Тогда
								ДокОб.Товары[КолвоСтрок - н].Количество = ДокОб.Товары[КолвоСтрок - н].Количество - НужноУдалить;
								Запись = НаборУдалены.Добавить();
								Запись.ДатаРаспределения = ДатаРаспределения;
								Запись.Период = ТекущаяДата();
								Запись.Расходник = Выборка.Ссылка;
								Запись.Номенклатура = Товар;
								Запись.Характеристика = ДокОб.Товары[КолвоСтрок - н].Характеристика;
								Запись.Пользователь = ПараметрыСеанса.ТекущийПользователь;
								Запись.НомерСтрокиДокумента = ДокОб.Товары[КолвоСтрок - н].НомерСтроки;
								Запись.КоличествоУдалено = НужноУдалить;
							КонецЕсли;	
						Иначе
							Запись = НаборУдалены.Добавить();
							Запись.ДатаРаспределения = ДатаРаспределения;
							Запись.Период = ТекущаяДата();
							Запись.Расходник = Выборка.Ссылка;
							Запись.Номенклатура = Товар;
							Запись.Характеристика = ДокОб.Товары[КолвоСтрок - н].Характеристика;
							Запись.Пользователь = ПараметрыСеанса.ТекущийПользователь;
							Запись.НомерСтрокиДокумента = ДокОб.Товары[КолвоСтрок - н].НомерСтроки;
							Запись.КоличествоУдалено = ДокОб.Товары[КолвоСтрок - н].Количество;
							ДокОб.Товары.Удалить(КолвоСтрок - н);
						КонецЕсли;
						КолвоКОбработке = КолвоКОбработке - НужноУдалить;
					Иначе
						Запись = НаборУдалены.Добавить();
						Запись.ДатаРаспределения = ДатаРаспределения;
						Запись.Период = ТекущаяДата();
						Запись.Расходник = Выборка.Ссылка;
						Запись.Номенклатура = Товар;
						Запись.Характеристика = ДокОб.Товары[КолвоСтрок - н].Характеристика;
						Запись.Пользователь = ПараметрыСеанса.ТекущийПользователь;
						Запись.НомерСтрокиДокумента = ДокОб.Товары[КолвоСтрок - н].НомерСтроки;
						Запись.КоличествоУдалено = ДокОб.Товары[КолвоСтрок - н].Количество;
						ДокОб.Товары.Удалить(КолвоСтрок - н);
					КонецЕсли;
				КонецЕсли;	
			КонецЦикла;
			Если ДокОб.Модифицированность() Тогда
				ДокОб.Записать(?(Выборка.Проведен, РежимЗаписиДокумента.Проведение, РежимЗаписиДокумента.Запись));
				НаборУдалены.Записать();
			КонецЕсли;
		КонецЦикла;	
		ЗафиксироватьТранзакцию();
	Исключение
		ОтменитьТранзакцию();
		Сообщить(ОписаниеОшибки());
	КонецПопытки;	
	
КонецПроцедуры	

Процедура УдалитьНаСервере_ПослеСборки()
	
	Запрос = Новый Запрос();
	Запрос.УстановитьПараметр("Номенклатура", Товар);
	Запрос.УстановитьПараметр("ДатаРаспределения", ДатаРаспределения);
	Запрос.УстановитьПараметр("СтрЕдиница", Подразделение);
	Запрос.УстановитьПараметр("Получатель", ПоМагазину);
	Запрос.Текст = "ВЫБРАТЬ РАЗЛИЧНЫЕ
	               |	РасходныйОрдерСкладТовары.Ссылка,
	               |	РасходныйОрдерСкладТовары.Ссылка.Проведен
	               |ИЗ
	               |	Документ.РасходныйОрдерСклад.Товары КАК РасходныйОрдерСкладТовары
	               |ГДЕ
	               |	РасходныйОрдерСкладТовары.Номенклатура = &Номенклатура
	               |	И РасходныйОрдерСкладТовары.Ссылка.ДатаРаспределения = &ДатаРаспределения
	               |	И РасходныйОрдерСкладТовары.Ссылка.ВидОперации = ЗНАЧЕНИЕ(Перечисление.ВидыОперацийРасходСкладскойУчет.ОтгрузкаВТорговуюТочку)
	               |	И РасходныйОрдерСкладТовары.Ссылка.Проведен = ИСТИНА
	               |	И (РасходныйОрдерСкладТовары.Ссылка.Склад.Владелец = &СтрЕдиница
	               |			ИЛИ &СтрЕдиница = ЗНАЧЕНИЕ(Справочник.СтруктурныеЕдиницы.ПустаяСсылка))
	               |	И РасходныйОрдерСкладТовары.Количество = 0
	               |	И РасходныйОрдерСкладТовары.КоличествоУРЗ <> 0
	               |	И (РасходныйОрдерСкладТовары.Ссылка.Получатель = &Получатель
	               |			ИЛИ &Получатель = ЗНАЧЕНИЕ(Справочник.СтруктурныеЕдиницы.ПустаяСсылка))";
				   
	Выборка = Запрос.Выполнить().Выбрать();
	Попытка
		НачатьТранзакцию();
		Пока Выборка.Следующий() Цикл
			ДокОб = Выборка.Ссылка.ПолучитьОбъект();
			КолвоСтрок = ДокОб.Товары.Количество();
			Для н = 1 По КолвоСтрок Цикл
				Если (ДокОб.Товары[КолвоСтрок - н].Номенклатура = Товар)
					И (НЕ ЗначениеЗаполнено(Характеристика) ИЛИ ДокОб.Товары[КолвоСтрок - н].Характеристика = Характеристика) Тогда
					Запись = РегистрыСведений.ТоварыУдаленныеИзРасходниковОбработкой.СоздатьМенеджерЗаписи();
					Запись.ДатаРаспределения = ДатаРаспределения;
					Запись.Период = ТекущаяДата();
					Запись.Расходник = Выборка.Ссылка;
					Запись.Номенклатура = Товар;
					Запись.Характеристика = ДокОб.Товары[КолвоСтрок - н].Характеристика;
					Запись.Пользователь = ПараметрыСеанса.ТекущийПользователь;
					Если ДокОб.Товары[КолвоСтрок - н].Количество = 0 Тогда
						ДокОб.Товары.Удалить(КолвоСтрок - н);
					КонецЕсли;
					Запись.Записать();
				КонецЕсли;	
			КонецЦикла;
			Если ДокОб.Модифицированность() Тогда
				ДокОб.Записать(?(Выборка.Проведен, РежимЗаписиДокумента.Проведение, РежимЗаписиДокумента.Запись));
			КонецЕсли;
		КонецЦикла;	
		ЗафиксироватьТранзакцию();
	Исключение
		ОтменитьТранзакцию();
		Сообщить(ОписаниеОшибки());
	КонецПопытки;	
	
КонецПроцедуры	



&НаКлиенте
Процедура Удалить(Команда)
	
	Если НЕ ЗначениеЗаполнено(ДатаРаспределения) Тогда
		Сообщить("Не заполнена дата распределения товара");
		Возврат;
	КонецЕсли;
	
	Если НЕ ЗначениеЗаполнено(Товар) Тогда
		Сообщить("Не заполнен товар");
		Возврат;
	КонецЕсли;
	
	Если РежимУдаления = 1 Тогда
		УдалитьНаСервере_ПослеСборки();
	Иначе	
		УдалитьНаСервере();
	КонецЕсли;	
	
КонецПроцедуры

&НаКлиенте
Процедура РежимУдаленияПриИзменении(Элемент)
	
	Элементы.ОставитьКоличество.Видимость = РежимУдаления = 0;
	Элементы.Декорация1.Видимость = РежимУдаления = 0;
	
КонецПроцедуры

&НаКлиенте
Процедура ОтчетПоУдалениям(Команда)
	
	ОткрытьФорму("Отчет.ОтчетПоУдалениюТоваровИзРасходниковОбработкой.Форма");
	
КонецПроцедуры
