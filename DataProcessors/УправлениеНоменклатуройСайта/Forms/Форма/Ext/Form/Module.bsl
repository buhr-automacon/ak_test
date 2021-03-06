﻿
&НаСервере
Процедура ПеренестиВГруппуСайтаСервер(МассивНоменклатуры, ГруппаСайта)
	
	Запрос = Новый Запрос();
	Запрос.Текст = "ВЫБРАТЬ
	               |	Номенклатура.Ссылка,
	               |	Номенклатура.ВыгружатьНаСайт,
	               |	Номенклатура.ГруппаНоменклатуры
	               |ИЗ
	               |	Справочник.Номенклатура КАК Номенклатура
	               |ГДЕ
	               |	Номенклатура.ЭтоГруппа = ЛОЖЬ
	               |	И Номенклатура.Ссылка В ИЕРАРХИИ (&МассивТоваров)";
				   
	Запрос.УстановитьПараметр("МассивТоваров", МассивНоменклатуры);
	Выборка = Запрос.Выполнить().Выбрать();
	Пока Выборка.Следующий() Цикл
		Если Выборка.ГруппаНоменклатуры <> ГруппаСайта
			ИЛИ Выборка.ВыгружатьНаСайт <> Истина Тогда
			СпрОбъект = Выборка.Ссылка.ПолучитьОбъект();
			СпрОбъект.ВыгружатьНаСайт = Истина;
			СпрОбъект.ГруппаНоменклатуры = ГруппаСайта;
			СпрОбъект.Записать();
		КонецЕсли;	
	КонецЦикла;	
	
	ОбновитьНоменклатуруГруппыСайта();
	
КонецПроцедуры	

&НаСервере
Процедура УбратьИзВыгружаемойСервер(МассивНоменклатуры)
	
	УстановитьПривилегированныйРежим(Истина);
	
	Запрос = Новый Запрос();
	Запрос.Текст = "ВЫБРАТЬ
	               |	Номенклатура.Ссылка,
	               |	Номенклатура.ВыгружатьНаСайт,
	               |	Номенклатура.ГруппаНоменклатуры
	               |ИЗ
	               |	Справочник.Номенклатура КАК Номенклатура
	               |ГДЕ
	               |	Номенклатура.ЭтоГруппа = ЛОЖЬ
	               |	И Номенклатура.Ссылка В ИЕРАРХИИ (&МассивТоваров)";
				   
	Запрос.УстановитьПараметр("МассивТоваров", МассивНоменклатуры);
	Выборка = Запрос.Выполнить().Выбрать();
	Пока Выборка.Следующий() Цикл
		Если Выборка.ВыгружатьНаСайт <> Ложь Тогда
			СпрОбъект = Выборка.Ссылка.ПолучитьОбъект();
			СпрОбъект.ВыгружатьНаСайт = Ложь;
			СпрОбъект.ГруппаНоменклатуры = Неопределено;
			СпрОбъект.Записать();
		КонецЕсли;	
	КонецЦикла;	
	
	ОбновитьНоменклатуруГруппыСайта();
	
	УстановитьПривилегированныйРежим(Ложь);
	
КонецПроцедуры	


&НаКлиенте
Процедура ПеренестиВГруппуСайта(Команда)
	
	МассивНоменклатуры = Новый Массив();
	Для Каждого СтрокаВыделенная Из Элементы.НоменклатураСпр.ВыделенныеСтроки Цикл
		МассивНоменклатуры.Добавить(СтрокаВыделенная);
	КонецЦикла;	
	
	Отказ = Ложь;
	Если Элементы.ГруппыСайта.ТекущаяСтрока = Неопределено Тогда
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю("Не выбрана группа сайта, в которую будут перенесены выделенные элементы номенклатуры",,,, Отказ);
	КонецЕсли;
	
	Если МассивНоменклатуры.Количество() = 0 Тогда
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю("Не выбраны элементы номенклатуры для переноса",,,, Отказ);
	КонецЕсли;
	
	Если Отказ Тогда
		Возврат;
	КонецЕсли;	
	
	ПеренестиВГруппуСайтаСервер(МассивНоменклатуры, Элементы.ГруппыСайта.ТекущаяСтрока);
	
КонецПроцедуры

Процедура ОбновитьНоменклатуруГруппыСайта()
	
	НоменклатураГруппыСайта.Очистить();
	
	Запрос = Новый Запрос();
	Запрос.Текст = "ВЫБРАТЬ
	               |	Номенклатура.Ссылка,
	               |	Номенклатура.id_tov
	               |ИЗ
	               |	Справочник.Номенклатура КАК Номенклатура
	               |ГДЕ
	               |	Номенклатура.ЭтоГруппа = ЛОЖЬ
	               |	И Номенклатура.ВыгружатьНаСайт = ИСТИНА
	               |	И Номенклатура.ГруппаНоменклатуры = &ГруппаНоменклатуры
	               |
	               |УПОРЯДОЧИТЬ ПО
	               |	Номенклатура.Наименование";
				   
	Запрос.УстановитьПараметр("ГруппаНоменклатуры", Элементы.ГруппыСайта.ТекущаяСтрока);
	Выборка = Запрос.Выполнить().Выбрать();
	Пока Выборка.Следующий() Цикл
		СтрокаДоб = НоменклатураГруппыСайта.Добавить();
		СтрокаДоб.Номенклатура = Выборка.Ссылка;
		СтрокаДоб.id_tov = Выборка.id_tov;
	КонецЦикла;	
	
КонецПроцедуры	

&НаКлиенте
Процедура ГруппыСайтаПриАктивизацииСтроки(Элемент)
	
	ОбновитьНоменклатуруГруппыСайта();
	
КонецПроцедуры

&НаКлиенте
Процедура ПеренестиИзЗаполненных(Команда)
	
	МассивНоменклатуры = Новый Массив();
	Для Каждого СтрокаВыделенная Из Элементы.НоменклатураГруппыСайта.ВыделенныеСтроки Цикл
		МассивНоменклатуры.Добавить(НоменклатураГруппыСайта.НайтиПоИдентификатору(СтрокаВыделенная).Номенклатура);
	КонецЦикла;	
	
	Отказ = Ложь;
	Если Элементы.ГруппыСайта.ТекущаяСтрока = Неопределено Тогда
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю("Не выбрана группа сайта, в которую будут перенесены выделенные элементы номенклатуры",,,, Отказ);
	КонецЕсли;
	
	ГруппаСайта = ОткрытьФормуМодально("Справочник.ГруппыНоменклатурыДляСайта.ФормаВыбора");
	Если ГруппаСайта = Неопределено Тогда
		Отказ = Истина;
	КонецЕсли;	
	
	Если Отказ Тогда
		Возврат;
	КонецЕсли;	
	
	ПеренестиВГруппуСайтаСервер(МассивНоменклатуры, ГруппаСайта);
	
КонецПроцедуры

&НаКлиенте
Процедура ГруппыСайтаПеретаскивание(Элемент, ПараметрыПеретаскивания, СтандартнаяОбработка, Строка, Поле)
	
	СтандартнаяОбработка = Ложь;
	
	ПеренестиВГруппуСайтаСервер(ПараметрыПеретаскивания.Значение, Строка);
	
КонецПроцедуры

&НаКлиенте
Процедура НоменклатураГруппыСайтаНачалоПеретаскивания(Элемент, ПараметрыПеретаскивания, Выполнение)
	
	МассивНоменклатуры = Новый Массив();
	Для Каждого СтрокаВыделенная Из Элементы.НоменклатураГруппыСайта.ВыделенныеСтроки Цикл
		МассивНоменклатуры.Добавить(НоменклатураГруппыСайта.НайтиПоИдентификатору(СтрокаВыделенная).Номенклатура);
	КонецЦикла;
	
	ПараметрыПеретаскивания.Значение = МассивНоменклатуры;
	
КонецПроцедуры

&НаКлиенте
Процедура УбратьИзВыгружаемойНаСайт(Команда)
	
	МассивНоменклатуры = Новый Массив();
	Для Каждого СтрокаВыделенная Из Элементы.НоменклатураГруппыСайта.ВыделенныеСтроки Цикл
		МассивНоменклатуры.Добавить(НоменклатураГруппыСайта.НайтиПоИдентификатору(СтрокаВыделенная).Номенклатура);
	КонецЦикла;	
	
	УбратьИзВыгружаемойСервер(МассивНоменклатуры);
	
КонецПроцедуры

&НаСервереБезКонтекста
Процедура ВыполнитьОбменСервер()
	
	//Запрос = Новый Запрос();
	//Запрос.Текст = "ВЫБРАТЬ
	//			   |	CMS1C_НастройкиОбменаССайтом.Ссылка
	//			   |ИЗ
	//			   |	Справочник.CMS1C_НастройкиОбменаССайтом КАК CMS1C_НастройкиОбменаССайтом
	//			   |ГДЕ
	//			   |	CMS1C_НастройкиОбменаССайтом.ПометкаУдаления = ЛОЖЬ";
	//			   
	//Выборка = Запрос.Выполнить().Выбрать();
	//Пока Выборка.Следующий() Цикл
	//	CMS1C_ПроцедурыОбменаССайтомСервер.ВызватьАвтообмен(Выборка.Ссылка);
	//КонецЦикла;	
	
	//РегламентныеЗаданияСервер.ВыгрузитьБаннерыНаСайт();
	РегламентныеЗаданияСервер.ВыгрузитьБаннерыНаСайт_Новый();
	
КонецПроцедуры	

&НаСервере
Функция ЭтоКопияБазы()
	
	СтрСоединения = НРег(СтрокаСоединенияИнформационнойБазы());
	СтрСоединения = СтрЗаменить(СтрСоединения, "10.0.0.40", "srv-sql01");
	СтрСоединения = СтрЗаменить(СтрСоединения, "srv-sql02", "srv-sql01");
	Возврат НРег(Константы.СтрокаПодключенияКБазе.Получить()) <> СтрСоединения;
	
КонецФункции

&НаКлиенте
Процедура ВыполнитьОбмен(Команда)
	
	Если ЭтоКопияБазы() Тогда
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю("Нельзя выполнить выгрузку товаров из копии базы");
		Возврат;
	КонецЕсли;	
	
	Ответ = Вопрос("Вы действительно хотите выполнить обмен с сайтом?", РежимДиалогаВопрос.ДаНет, 60, КодВозвратаДиалога.Да);
	Если Ответ = КодВозвратаДиалога.Нет Тогда
		Возврат;
	КонецЕсли;	
	
	ВыполнитьОбменСервер();
	
КонецПроцедуры

&НаКлиенте
Процедура НоменклатураГруппыСайтаВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	//ТекДанные = НоменклатураГруппыСайта.
	ТекДанные = Элементы.НоменклатураГруппыСайта.ДанныеСтроки(ВыбраннаяСтрока);
	ОткрытьЗначение(ТекДанные.Номенклатура);
	
КонецПроцедуры

Процедура ИзменитьПорядокСервер_Вверх(Ссылка)
	
	//ТекДанные = Элементы.ГруппыСайта.ДанныеСтроки(Элементы.ГруппыСайта.ТекущаяСтрока);
	Запрос = Новый Запрос();
	Запрос.Текст = "ВЫБРАТЬ
	               |	ГруппыНоменклатурыДляСайта.ПорядокСортировки КАК ПорядокСортировки,
	               |	ГруппыНоменклатурыДляСайта.Ссылка
	               |ИЗ
	               |	Справочник.ГруппыНоменклатурыДляСайта КАК ГруппыНоменклатурыДляСайта
	               |ГДЕ
	               |	ГруппыНоменклатурыДляСайта.Родитель = &Родитель
	               |
	               |УПОРЯДОЧИТЬ ПО
	               |	ПорядокСортировки,
	               |	ГруппыНоменклатурыДляСайта.Ссылка";
				   
	Запрос.УстановитьПараметр("Родитель", Ссылка.Родитель);
	
	ТабРезультат = Запрос.Выполнить().Выгрузить();
	Если ТабРезультат.Количество() <= 1 Тогда
		Возврат;
	КонецЕсли;	
	Если ТабРезультат[0].Ссылка = Ссылка Тогда
		ТабРезультат.Сдвинуть(0, ТабРезультат.Количество() - 1);
	Иначе
		СтрокаТаб = ТабРезультат.Найти(Ссылка, "Ссылка");
		ТабРезультат.Сдвинуть(ТабРезультат.Индекс(СтрокаТаб), -1);
	КонецЕсли;
	Счетчик = 1;
	Для Каждого СтрокаТаб Из ТабРезультат Цикл
		Если СтрокаТаб.ПорядокСортировки <> Счетчик Тогда
			СпрОбъект = СтрокаТаб.Ссылка.ПолучитьОбъект();
			СпрОбъект.ПорядокСортировки = Счетчик;
			СпрОбъект.Записать();
		КонецЕсли;	
		Счетчик = Счетчик + 1;
	КонецЦикла;	
	
КонецПроцедуры

&НаКлиенте
Процедура ИзменитьПорядок_Вверх(Команда)
	
	Ссылка = Элементы.ГруппыСайта.ТекущаяСтрока;
	Если НЕ ЗначениеЗаполнено(Ссылка) Тогда
		Возврат;
	КонецЕсли;
	
	ИзменитьПорядокСервер_Вверх(Ссылка);
	Элементы.ГруппыСайта.Обновить();
	
КонецПроцедуры

Процедура ИзменитьПорядокСервер_Вниз(Ссылка)
	
	Запрос = Новый Запрос();
	Запрос.Текст = "ВЫБРАТЬ
	               |	ГруппыНоменклатурыДляСайта.ПорядокСортировки КАК ПорядокСортировки,
	               |	ГруппыНоменклатурыДляСайта.Ссылка
	               |ИЗ
	               |	Справочник.ГруппыНоменклатурыДляСайта КАК ГруппыНоменклатурыДляСайта
	               |ГДЕ
	               |	ГруппыНоменклатурыДляСайта.Родитель = &Родитель
	               |
	               |УПОРЯДОЧИТЬ ПО
	               |	ПорядокСортировки,
	               |	ГруппыНоменклатурыДляСайта.Ссылка";
				   
	Запрос.УстановитьПараметр("Родитель", Ссылка.Родитель);
	
	ТабРезультат = Запрос.Выполнить().Выгрузить();
	Если ТабРезультат.Количество() <= 1 Тогда
		Возврат;
	КонецЕсли;	
	Если ТабРезультат[ТабРезультат.Количество() - 1].Ссылка = Ссылка Тогда
		ТабРезультат.Сдвинуть(ТабРезультат.Количество() - 1, -(ТабРезультат.Количество() - 1));
	Иначе
		СтрокаТаб = ТабРезультат.Найти(Ссылка, "Ссылка");
		ТабРезультат.Сдвинуть(ТабРезультат.Индекс(СтрокаТаб), 1);
	КонецЕсли;
	Счетчик = 1;
	Для Каждого СтрокаТаб Из ТабРезультат Цикл
		Если СтрокаТаб.ПорядокСортировки <> Счетчик Тогда
			СпрОбъект = СтрокаТаб.Ссылка.ПолучитьОбъект();
			СпрОбъект.ПорядокСортировки = Счетчик;
			СпрОбъект.Записать();
		КонецЕсли;	
		Счетчик = Счетчик + 1;
	КонецЦикла;
	
КонецПроцедуры

&НаКлиенте
Процедура ИзменитьПорядок_Вниз(Команда)
	
	Ссылка = Элементы.ГруппыСайта.ТекущаяСтрока;
	Если НЕ ЗначениеЗаполнено(Ссылка) Тогда
		Возврат;
	КонецЕсли;
	
	ИзменитьПорядокСервер_Вниз(Ссылка);
	Элементы.ГруппыСайта.Обновить();
	
КонецПроцедуры
