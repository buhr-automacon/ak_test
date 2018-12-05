﻿
////////////////////////////////////////////////////////////////////////////////
// Обработчики событий формы
//

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	// Отказ от инициализации, чтобы гарантировать получение формы при передаче параметра "АвтоТест".
	Если Параметры.Свойство("АвтоТест") Тогда
		Возврат;
	КонецЕсли;
	
	Если НЕ ПравоДоступа("Администрирование", Метаданные) Тогда
		ВызватьИсключение(НСтр("ru = 'У пользователя нет права администрирования!'"));
	КонецЕсли;
	
	ИнформационнаяБазаФайловая = ОбщегоНазначения.ИнформационнаяБазаФайловая();
	ПустойИдентификатор = Строка(Новый УникальныйИдентификатор("00000000-0000-0000-0000-000000000000"));
	ТекстНеОпределено = РегламентныеЗаданияСервер.ТекстНеОпределено();
	
	Если ИнформационнаяБазаФайловая Тогда
		Элементы.ИмяПользователя.Видимость = Ложь;
		Элементы.ТаблицаРегламентныеЗаданияНастройкаВыполнения.Видимость             = Истина;
		Элементы.ТаблицаРегламентныеЗаданияОткрытьОтдельныйСеансВыполнения.Видимость = Истина;
		Элементы.ТаблицаФоновыеЗаданияОтменить.Доступность = Ложь;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	Если НЕ НастройкиЗагружены Тогда
		ПриЗагрузкеДанныхИзНастроекНаСервере(Новый Соответствие);
	КонецЕсли;
	ОбновитьСписокВыбораРегламентногоЗадания();
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	
	Если ИмяСобытия = "РегламентноеЗаданиеИзменено" Тогда
		ОбновитьТаблицуРегламентныхЗаданий();
		ОбновитьСписокВыбораРегламентногоЗадания();
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ПриЗагрузкеДанныхИзНастроекНаСервере(Настройки)
		
	ОбновитьТаблицуРегламентныхЗаданий();
	
	// Настроим отбор фоновых заданий
	Если Настройки.Получить("ОтборПоСостояниюАктивно") = Неопределено Тогда
		Настройки.Вставить("ОтборПоСостояниюАктивно", Истина);
	КонецЕсли;
	
	Если Настройки.Получить("ОтборПоСостояниюЗавершено") = Неопределено Тогда
		Настройки.Вставить("ОтборПоСостояниюЗавершено", Истина);
	КонецЕсли;
	
	Если Настройки.Получить("ОтборПоСостояниюЗавершеноАварийно") = Неопределено Тогда
		Настройки.Вставить("ОтборПоСостояниюЗавершеноАварийно", Истина);
	КонецЕсли;

	Если Настройки.Получить("ОтборПоСостояниюОтменено") = Неопределено Тогда
		Настройки.Вставить("ОтборПоСостояниюОтменено", Истина);
	КонецЕсли;
	
	Если Настройки.Получить("ОтбиратьПоРегламентномуЗаданию") = Неопределено
	 ИЛИ Настройки.Получить("РегламентноеЗаданиеДляОтбораИдентификатор")   = Неопределено Тогда
		Настройки.Вставить("ОтбиратьПоРегламентномуЗаданию", Ложь);
		Настройки.Вставить("РегламентноеЗаданиеДляОтбораИдентификатор", ПустойИдентификатор);
	КонецЕсли;
	
	// Настроим отбор по периоду "Без отбора"
	// (см. обработчик события ВидОтбораПоПериодуПриИзменении переключателя)
	Если Настройки.Получить("ВидОтбораПоПериоду") = Неопределено
	 ИЛИ Настройки.Получить("ОтборПериодС")       = Неопределено
	 ИЛИ Настройки.Получить("ОтборПериодПо")      = Неопределено Тогда
		Настройки.Вставить("ВидОтбораПоПериоду", 0);
		Настройки.Вставить("ОтборПериодС",  НачалоДня(ТекущаяДата()) - 3*360);
		Настройки.Вставить("ОтборПериодПо", НачалоДня(ТекущаяДата()) + 9*360);
	КонецЕсли;
	
	Для каждого КлючИЗначение Из Настройки Цикл
		Попытка
			ЭтаФорма[КлючИЗначение.Ключ] = КлючИЗначение.Значение;
		Исключение
		КонецПопытки;
	КонецЦикла;
	// Настроим видимость и доступность.
	Элементы.ОтборПериодС.ТолькоПросмотр  = НЕ (ВидОтбораПоПериоду = 4);
	Элементы.ОтборПериодПо.ТолькоПросмотр = НЕ (ВидОтбораПоПериоду = 4);
	Элементы.РегламентноеЗаданиеДляОтбора.Доступность = ОтбиратьПоРегламентномуЗаданию;
	
	ОбновитьТаблицуФоновыхЗаданий();
	
	
	НастройкиЗагружены = Истина;
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// Обработчики событий команд и элементов формы
//

&НаКлиенте
Процедура ИзменитьРегламентноеЗаданиеВыполнить()
	
	ДобавитьСкопироватьИзменитьРегламентноеЗадание("Изменить");
	
КонецПроцедуры

&НаКлиенте
Процедура ОбновитьДанныеВыполнить()
	
	ОбновитьДанные();
	
КонецПроцедуры

&НаКлиенте
Процедура ОткрытьФоновоеЗаданиеВыполнить()
	
	Если Элементы.ТаблицаФоновыеЗадания.ТекущиеДанные = Неопределено Тогда
		Предупреждение (НСтр("ru = 'Выберите фоновое задание!'"));
	Иначе
		СписокПередаваемыхСвойств =
		"Идентификатор,
		|Ключ,
		|Наименование,
		|ИмяМетода,
		|Состояние,
		|Начало,
		|Конец,
		|Расположение,
		|СообщенияПользователюИОписаниеИнформацииОбОшибке,
		|ИдентификаторРегламентногоЗадания,
		|НаименованиеРегламентногоЗадания";
		ЗначенияТекущихДанных = Новый Структура(СписокПередаваемыхСвойств);
		ЗаполнитьЗначенияСвойств(ЗначенияТекущихДанных, Элементы.ТаблицаФоновыеЗадания.ТекущиеДанные);
		ОткрытьФормуМодально("Обработка.РегламентныеИФоновыеЗадания.Форма.ФоновоеЗадание",
		                     Новый Структура("Идентификатор, СвойстваФоновогоЗадания",
		                                     Элементы.ТаблицаФоновыеЗадания.ТекущиеДанные.Идентификатор,
		                                     ЗначенияТекущихДанных));
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ОтменитьФоновоеЗаданиеВыполнить()
	
	Если Элементы.ТаблицаФоновыеЗадания.ТекущиеДанные = Неопределено Тогда
		Предупреждение( НСтр("ru = 'Выберите фоновое задание!'") );
		
	Иначе
		ОтменитьФоновоеЗаданиеНаСервере(Элементы.ТаблицаФоновыеЗадания.ТекущиеДанные.Идентификатор);
		Предупреждение( НСтр("ru = 'Задание отменено, но состояние отмены будет
		                           |установлено сервером только через секунды,
		                           |возможно потребуется обновить данные вручную!'") );
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ОткрытьРасписаниеРегламентногоЗаданияВыполнить()
	
	ТекущиеДанные = Элементы.ТаблицаРегламентныеЗадания.ТекущиеДанные;
	
	Если ТекущиеДанные = Неопределено Тогда
		Предупреждение( НСтр("ru = 'Выберите регламентное задание!'") );
	Иначе
		Диалог = Новый ДиалогРасписанияРегламентногоЗадания(РегламентныеЗаданияКлиент.ПолучитьРасписаниеРегламентногоЗадания(ТекущиеДанные.Идентификатор));
		Если Диалог.ОткрытьМодально() Тогда
			РегламентныеЗаданияКлиент.УстановитьРасписаниеРегламентногоЗадания(ТекущиеДанные.Идентификатор, Диалог.Расписание);
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ЗапуститьОтдельныйСеанс(Команды)
	
	ПодключитьОбработчикОжидания("ЗапуститьОтдельныйСеансДляВыполненияРегламентныхЗаданийЧерезОбработчикОжидания", 1, Истина);
	
КонецПроцедуры

&НаКлиенте
Процедура НастройкаВыполненияРегламентныхЗаданий(Команда)
	
	ПараметрыФормы = Новый Структура("СкрытьКомандуЗапускаОтдельногоСеанса", Истина);
	
	ОткрытьФормуМодально("Обработка.РегламентныеИФоновыеЗадания.Форма.НастройкаВыполненияРегламентныхЗаданий", ПараметрыФормы);
	
КонецПроцедуры

&НаКлиенте
Процедура ВыполнитьРегламентноеЗаданиеВручную(Команда)

	Если Элементы.ТаблицаРегламентныеЗадания.ТекущиеДанные = Неопределено Тогда
		Предупреждение( НСтр("ru = 'Выберите регламентное задание!'") );
	Иначе
		ВыделенныеСтроки = Элементы.ТаблицаРегламентныеЗадания.ВыделенныеСтроки;
		ВыделенныеСтроки = Новый Массив;
		Для каждого ВыделеннаяСтрока Из Элементы.ТаблицаРегламентныеЗадания.ВыделенныеСтроки Цикл
			ВыделенныеСтроки.Добавить(ВыделеннаяСтрока);
		КонецЦикла;
		Индекс = 0;
		Для каждого ВыделеннаяСтрока Из ВыделенныеСтроки Цикл
			ОбновитьВсе = Индекс = ВыделенныеСтроки.Количество()-1;
			ПроцедураУжеВыполняется = Неопределено;
			ТекущиеДанные = ТаблицаРегламентныеЗадания.НайтиПоИдентификатору(ВыделеннаяСтрока);
			Если ИнформационнаяБазаФайловая Тогда
				МоментЗапуска = ТекущаяДата();
				МоментОкончания = Неопределено;
				НомерСеанса  = Неопределено;
				НачалоСеанса = Неопределено;
				Если ВыполнитьРегламентноеЗаданиеВручнуюНаСервере(ТекущиеДанные.Идентификатор, МоментЗапуска, , МоментОкончания, НомерСеанса, НачалоСеанса, , ОбновитьВсе, ПроцедураУжеВыполняется) Тогда
					ПоказатьОповещениеПользователя(НСтр("ru = 'Выполнена процедура регламентного задания'"), ,
						СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(НСтр("ru = '%1.
							|Процедура выполнялась с %2 по %3'"),
							ТекущиеДанные.Наименование,
							Строка(МоментЗапуска),
							Строка(МоментОкончания)),
						БиблиотекаКартинок.ВыполнитьРегламентноеЗаданиеВручную);
				Иначе
					Если ПроцедураУжеВыполняется Тогда
						ОбщегоНазначенияКлиентСервер.СообщитьПользователю(
							СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
								НСтр("ru = 'Процедура регламентного задания ""%1"" уже выполняется в сеансе %2, открытом %3.'"),
								ТекущиеДанные.Наименование,
								Строка(НомерСеанса),
								Строка(НачалоСеанса)));
					Иначе
						Элементы.ТаблицаРегламентныеЗадания.ВыделенныеСтроки.Удалить(Элементы.ТаблицаРегламентныеЗадания.ВыделенныеСтроки.Найти(ВыделеннаяСтрока));
					КонецЕсли;
				КонецЕсли;
			Иначе
				МоментЗапуска = Неопределено;
				ИдентификаторФоновогоЗадания = "";
				ПредставлениеФоновогоЗадания = "";
				Если ВыполнитьРегламентноеЗаданиеВручнуюНаСервере(ТекущиеДанные.Идентификатор, МоментЗапуска, ИдентификаторФоновогоЗадания, , , , ПредставлениеФоновогоЗадания, ОбновитьВсе, ПроцедураУжеВыполняется) Тогда
					ПоказатьОповещениеПользователя(НСтр("ru = 'Запущена процедура регламентного задания'"), ,
						СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(НСтр("ru = '%1.
							|Процедура запущена в фоновом задании %2'"),
							ТекущиеДанные.Наименование,
							Строка(МоментЗапуска)),
						БиблиотекаКартинок.ВыполнитьРегламентноеЗаданиеВручную);
					ИдентификаторыФоновыхЗаданийПриРучномВыполнении.Добавить(ИдентификаторФоновогоЗадания, ТекущиеДанные.Наименование);
					ПодключитьОбработчикОжидания("СообщитьОбОкончанииРучногоВыполненияРегламентногоЗадания", 0.1, Истина);
				Иначе
					Если ПроцедураУжеВыполняется Тогда
						ОбщегоНазначенияКлиентСервер.СообщитьПользователю(
							СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
								НСтр("ru = 'Процедура регламентного задания ""%1"" уже выполняется в фоновом задании ""%2"", начатом %3.'"),
								ТекущиеДанные.Наименование,
								ПредставлениеФоновогоЗадания,
								Строка(МоментЗапуска)));
					Иначе
						Элементы.ТаблицаРегламентныеЗадания.ВыделенныеСтроки.Удалить(Элементы.ТаблицаРегламентныеЗадания.ВыделенныеСтроки.Найти(ВыделеннаяСтрока));
					КонецЕсли;
				КонецЕсли;
			КонецЕсли;
			Индекс = Индекс + 1;
		КонецЦикла;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ВидОтбораПоПериодуПриИзменении(Элемент)

	Элементы.ОтборПериодС.ТолькоПросмотр  = НЕ (ВидОтбораПоПериоду = 4);
	Элементы.ОтборПериодПо.ТолькоПросмотр = НЕ (ВидОтбораПоПериоду = 4);
	Если ВидОтбораПоПериоду = 0 Тогда
		ОтборПериодС    = '00010101';
		ОтборПериодПо   = '00010101';
	ИначеЕсли ВидОтбораПоПериоду = 1 Тогда
		ОтборПериодС    = НачалоДня(ТекущаяДата()) - 3*3600;
		ОтборПериодПо   = НачалоДня(ТекущаяДата()) + 9*3600;
	ИначеЕсли ВидОтбораПоПериоду = 2 Тогда
		ОтборПериодС    = НачалоДня(ТекущаяДата()) - 24*3600;
		ОтборПериодПо   = КонецДня(ОтборПериодС);
	ИначеЕсли ВидОтбораПоПериоду = 3 Тогда
		ОтборПериодС    = НачалоДня(ТекущаяДата());
		ОтборПериодПо   = КонецДня(ОтборПериодС);
	ИначеЕсли ВидОтбораПоПериоду = 4 Тогда
		ОтборПериодС    = НачалоДня(ТекущаяДата());
		ОтборПериодПо   = ОтборПериодС;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ОтбиратьПоРегламентномуЗаданиюПриИзменении(Элемент)

	Элементы.РегламентноеЗаданиеДляОтбора.Доступность = ОтбиратьПоРегламентномуЗаданию;
	
КонецПроцедуры

&НаКлиенте
Процедура РегламентноеЗаданиеДляОтбораОчистка(Элемент, СтандартнаяОбработка)

	СтандартнаяОбработка = Ложь;
	РегламентноеЗаданиеДляОтбораИдентификатор = ПустойИдентификатор;
	РегламентноеЗаданиеДляОтбораПредставление = ТекстНеОпределено;
	
КонецПроцедуры

&НаКлиенте
Процедура РегламентноеЗаданиеДляОтбораОбработкаВыбора(Элемент, ВыбранноеЗначение, СтандартнаяОбработка)
	
	ЭлементСписка = Элементы.РегламентноеЗаданиеДляОтбора.СписокВыбора.НайтиПоЗначению(ВыбранноеЗначение);
	РегламентноеЗаданиеДляОтбораИдентификатор = ЭлементСписка.Значение;
	РегламентноеЗаданиеДляОтбораПредставление = ЭлементСписка.Представление;
	СтандартнаяОбработка = Ложь;
	
КонецПроцедуры

&НаКлиенте
Процедура ТаблицаФоновыеЗаданияВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	
	ОткрытьФоновоеЗаданиеВыполнить();
	
КонецПроцедуры

&НаКлиенте
Процедура ТаблицаРегламентныеЗаданияВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	
	ИзменитьРегламентноеЗаданиеВыполнить();
	
КонецПроцедуры

&НаКлиенте
Процедура ТаблицаРегламентныеЗаданияПередНачаломДобавления(Элемент, Отказ, Копирование, Родитель, Группа)
	
	Отказ = Истина;
	
	ДобавитьСкопироватьИзменитьРегламентноеЗадание(?(Копирование, "Скопировать", "Добавить"));
	
КонецПроцедуры

&НаКлиенте
Процедура ТаблицаРегламентныеЗаданияПередУдалением(Элемент, Отказ)
	
	Отказ = Истина;
	
	Если Элементы.ТаблицаРегламентныеЗадания.ВыделенныеСтроки.Количество() > 1 Тогда
		Предупреждение(НСтр("ru = 'Выберите одно регламентное задание!'"));
	ИначеЕсли Элемент.ТекущиеДанные.Предопределенное Тогда
		Предупреждение( НСтр("ru = 'Невозможно удалить предопределенное регламентное задание!'") );
	ИначеЕсли Вопрос(НСтр("ru = 'Удалить регламентное задание?'"), РежимДиалогаВопрос.ДаНет) = КодВозвратаДиалога.Да Тогда
		УдалитьРегламентноеЗаданиеВыполнитьНаСервере(Элементы.ТаблицаРегламентныеЗадания.ТекущиеДанные.Идентификатор);
	КонецЕсли;
	
КонецПроцедуры


////////////////////////////////////////////////////////////////////////////////
// Вспомогательные процедуры и функции формы
//

&НаСервере
Функция ОповещенияОбОкончанииВыполненияРегламентныхЗаданий()
	
	ОповещенияОбОкончанииВыполнения = Новый Массив;
	Если ИдентификаторыФоновыхЗаданийПриРучномВыполнении.Количество() > 0 Тогда
		Индекс = ИдентификаторыФоновыхЗаданийПриРучномВыполнении.Количество() - 1;
		УстановитьПривилегированныйРежим(Истина);
		Пока Индекс >= 0 Цикл
			Отбор = Новый Структура("УникальныйИдентификатор", Новый УникальныйИдентификатор(ИдентификаторыФоновыхЗаданийПриРучномВыполнении[Индекс].Значение));
			МассивФоновыхЗаданий = ФоновыеЗадания.ПолучитьФоновыеЗадания(Отбор);
			Если МассивФоновыхЗаданий.Количество() = 1 Тогда
				МоментОкончания = МассивФоновыхЗаданий[0].Конец;
				Если ЗначениеЗаполнено(МоментОкончания) Тогда
					ОповещенияОбОкончанииВыполнения.Добавить(Новый Структура("ПредставлениеРегламентногоЗадания, МоментОкончания", ИдентификаторыФоновыхЗаданийПриРучномВыполнении[Индекс].Представление, МоментОкончания));
					ИдентификаторыФоновыхЗаданийПриРучномВыполнении.Удалить(Индекс);
				КонецЕсли;
			Иначе
				ИдентификаторыФоновыхЗаданийПриРучномВыполнении.Удалить(Индекс);
			КонецЕсли;
			Индекс = Индекс - 1;
		КонецЦикла;
		УстановитьПривилегированныйРежим(Ложь);
	КонецЕсли;
	
	ОбновитьДанные();
	
	Возврат ОповещенияОбОкончанииВыполнения;
	
КонецФункции

&НаКлиенте
Процедура СообщитьОбОкончанииРучногоВыполненияРегламентногоЗадания()
	
	ОповещенияОбОкончанииВыполнения = ОповещенияОбОкончанииВыполненияРегламентныхЗаданий();
	Для каждого Оповещение Из ОповещенияОбОкончанииВыполнения Цикл
			ПоказатьОповещениеПользователя(НСтр("ru = 'Выполнена процедура регламентного задания'"), ,
				СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(НСтр("ru = '%1.
					|Процедура завершена в фоновом задании %2'"),
					Оповещение.ПредставлениеРегламентногоЗадания,
					Строка(Оповещение.МоментОкончания)),
				БиблиотекаКартинок.ВыполнитьРегламентноеЗаданиеВручную);
	КонецЦикла;
	
	Если ИдентификаторыФоновыхЗаданийПриРучномВыполнении.Количество() > 0 Тогда
		ПодключитьОбработчикОжидания("СообщитьОбОкончанииРучногоВыполненияРегламентногоЗадания", 2, Истина);
	КонецЕсли;

КонецПроцедуры

&НаСервере
Процедура ОбновитьСписокВыбораРегламентногоЗадания()
	
	Таблица = ТаблицаРегламентныеЗадания;
	Список = Элементы.РегламентноеЗаданиеДляОтбора.СписокВыбора;
	// Добавление предопределенного элемента.
	Если Список.Количество() = 0 Тогда
		Список.Добавить(ПустойИдентификатор, ТекстНеОпределено);
	КонецЕсли;
	Индекс = 1;
	Для каждого Задание ИЗ Таблица Цикл
		Если Индекс >= Список.Количество() ИЛИ Список[Индекс].Значение <> Задание.Идентификатор Тогда
			// Вставка нового задания
			Список.Вставить(Индекс, Задание.Идентификатор, Задание.Наименование);
		Иначе
			Список[Индекс].Представление = Задание.Наименование;
		КонецЕсли;
		Индекс = Индекс + 1;
	КонецЦикла;
	// Удаление лишних строк
	Пока Индекс < Список.Количество() Цикл
		Список.Удалить(Индекс);
	КонецЦикла;
	
	ЭлементСписка = Список.НайтиПоЗначению(РегламентноеЗаданиеДляОтбораИдентификатор);
	Если ЭлементСписка = Неопределено Тогда
		РегламентноеЗаданиеДляОтбораИдентификатор = ПустойИдентификатор;
		РегламентноеЗаданиеДляОтбораПредставление = ТекстНеОпределено;
	Иначе
		РегламентноеЗаданиеДляОтбораПредставление = ЭлементСписка.Представление;
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Функция ВыполнитьРегламентноеЗаданиеВручнуюНаСервере(Знач ИдентификаторРегламентногоЗадания, МоментЗапуска, ИдентификаторФоновогоЗадания, МоментОкончания = Неопределено, НомерСеанса = Неопределено, НачалоСеанса = Неопределено, ПредставлениеФоновогоЗадания = Неопределено, ОбновитьВсе = Ложь, ПроцедураУжеВыполняется = Неопределено)
	
	ЗапускВыполнен = РегламентныеЗаданияСервер.ВыполнитьРегламентноеЗаданиеВручную(ИдентификаторРегламентногоЗадания, МоментЗапуска, ИдентификаторФоновогоЗадания, МоментОкончания, НомерСеанса, НачалоСеанса, ПредставлениеФоновогоЗадания, ПроцедураУжеВыполняется);
	
	Если ОбновитьВсе Тогда
		ОбновитьДанные();
	Иначе
		ОбновитьТаблицуРегламентныхЗаданий(ИдентификаторРегламентногоЗадания);
	КонецЕсли;
	
	Возврат ЗапускВыполнен;
	
КонецФункции

&НаСервере
Процедура ОтменитьФоновоеЗаданиеНаСервере(Идентификатор)
	
	РегламентныеЗаданияСервер.ОтменитьФоновоеЗадание(Идентификатор);
	
	ОбновитьДанные();
	
КонецПроцедуры


&НаСервере
Процедура УдалитьРегламентноеЗаданиеВыполнитьНаСервере(Идентификатор)
	
	Задание = РегламентныеЗаданияСервер.ПолучитьРегламентноеЗадание(Идентификатор);
	Строка = ТаблицаРегламентныеЗадания.НайтиСтроки(Новый Структура("Идентификатор", Идентификатор))[0];
	Задание.Удалить();
	ТаблицаРегламентныеЗадания.Удалить(ТаблицаРегламентныеЗадания.Индекс(Строка));
	
КонецПроцедуры

&НаКлиенте
Процедура ДобавитьСкопироватьИзменитьРегламентноеЗадание(Действие)
	
	Если Элементы.ТаблицаРегламентныеЗадания.ТекущиеДанные = Неопределено Тогда
		Предупреждение ( НСтр("ru = 'Выберите регламентное задание!'") );
		
	ИначеЕсли Действие = "Изменить" И Элементы.ТаблицаРегламентныеЗадания.ВыделенныеСтроки.Количество() > 1 Тогда
		Предупреждение(НСтр("ru = 'Выберите одно регламентное задание!'"));
	Иначе
		ОткрытьФормуМодально("Обработка.РегламентныеИФоновыеЗадания.Форма.РегламентноеЗадание",
		                     Новый Структура("Идентификатор, Действие",
		                                      Элементы.ТаблицаРегламентныеЗадания.ТекущиеДанные.Идентификатор,
		                                      Действие));
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ОбновитьДанные()
	
	ОбновитьТаблицуРегламентныхЗаданий();
	ОбновитьТаблицуФоновыхЗаданий();
	ОбновитьСписокВыбораРегламентногоЗадания();
	
КонецПроцедуры

&НаСервере
Процедура ОбновитьТаблицуРегламентныхЗаданий(ИдентификаторРегламентногоЗадания = Неопределено)

	// Обновление таблицы РегламентныеЗадания и списка СписокВыбора регламентного задания для отбора.
	ТекущиеЗадания = РегламентныеЗадания.ПолучитьРегламентныеЗадания();
	Таблица = ТаблицаРегламентныеЗадания;
	
	Если ИдентификаторРегламентногоЗадания = Неопределено Тогда
		//
		Индекс = 0;
		Для каждого Задание ИЗ ТекущиеЗадания Цикл
			Идентификатор = Строка(Задание.УникальныйИдентификатор);
			Если Индекс >= Таблица.Количество() ИЛИ Таблица[Индекс].Идентификатор <> Идентификатор Тогда
				// Вставка нового задания
				Обновляемое = Таблица.Вставить(Индекс);
				// Установка уникального идентификатора
				Обновляемое.Идентификатор = Идентификатор;
			Иначе
				Обновляемое = Таблица[Индекс];
			КонецЕсли;
			ОбновитьСтрокуТаблицыРегламентныхЗаданий(Обновляемое, Задание);
			Индекс = Индекс + 1;
		КонецЦикла;
	
		// Удаление лишних строк
		Пока Индекс < Таблица.Количество() Цикл
			Таблица.Удалить(Индекс);
		КонецЦикла;
	Иначе
		Задание = РегламентныеЗадания.НайтиПоУникальномуИдентификатору(Новый УникальныйИдентификатор(ИдентификаторРегламентногоЗадания));
		Строки = Таблица.НайтиСтроки(Новый Структура("Идентификатор", ИдентификаторРегламентногоЗадания));
		Если Задание <> Неопределено И Строки.Количество() > 0 Тогда
			ОбновитьСтрокуТаблицыРегламентныхЗаданий(Строки[0], Задание);
		КонецЕсли;
	КонецЕсли;
	
	Элементы.ТаблицаРегламентныеЗадания.Обновить();
	
КонецПроцедуры

Процедура ОбновитьСтрокуТаблицыРегламентныхЗаданий(Строка, Задание);
	
	ЗаполнитьЗначенияСвойств(Строка, Задание);
	// Уточнение наименования
	Строка.Наименование = РегламентныеЗаданияСервер.ПредставлениеРегламентногоЗадания(Задание);
	// Установка Даты завершения и Состояния завершения по последней фоновой процедуре
	СвойстваПоследнегоФоновогоЗадания = РегламентныеЗаданияСервер.ПолучитьСвойстваПоследнегоФоновогоЗаданияВыполненияРегламентногоЗадания(Задание);
	Если СвойстваПоследнегоФоновогоЗадания = Неопределено Тогда
		Строка.ДатаОкончания       = ТекстНеОпределено;
		Строка.СостояниеВыполнения = ТекстНеОпределено;
	Иначе
		Строка.ДатаОкончания       = ?(ЗначениеЗаполнено(СвойстваПоследнегоФоновогоЗадания.Конец),
											СвойстваПоследнегоФоновогоЗадания.Конец,
											"<>");
		Строка.СостояниеВыполнения = СвойстваПоследнегоФоновогоЗадания.Состояние;
	КонецЕсли;
		
КонецПроцедуры

&НаСервере
Процедура ОбновитьТаблицуФоновыхЗаданий()
	
	// 1. Подготовка отбора
	Отбор = Новый Структура;
	// 1.1. Добавление отбора по состояниям
	МассивСостояний = Новый Массив;
	Если ОтборПоСостояниюАктивно Тогда 
		МассивСостояний.Добавить(СостояниеФоновогоЗадания.Активно);
	КонецЕсли;
	Если ОтборПоСостояниюЗавершено Тогда 
		МассивСостояний.Добавить(СостояниеФоновогоЗадания.Завершено);
	КонецЕсли;
	Если ОтборПоСостояниюЗавершеноАварийно Тогда 
		МассивСостояний.Добавить(СостояниеФоновогоЗадания.ЗавершеноАварийно);
	КонецЕсли;
	Если ОтборПоСостояниюОтменено Тогда 
		МассивСостояний.Добавить(СостояниеФоновогоЗадания.Отменено);
	КонецЕсли;
	Если МассивСостояний.Количество() <> 4 Тогда
		Если МассивСостояний.Количество() = 1 Тогда
			Отбор.Вставить("Состояние", МассивСостояний[0]);
		Иначе
			Отбор.Вставить("Состояние", МассивСостояний);
		КонецЕсли;
	КонецЕсли;
	// 1.2. Добавление отбор по регламентному заданию
	Если ОтбиратьПоРегламентномуЗаданию Тогда
		Отбор.Вставить(
				"ИдентификаторРегламентногоЗадания",
				?(РегламентноеЗаданиеДляОтбораИдентификатор = ПустойИдентификатор,
				"",
				РегламентноеЗаданиеДляОтбораИдентификатор));
	КонецЕсли;
	// 1.3. Добавление отбор по периоду
	Если ВидОтбораПоПериоду <> 0 Тогда
		Отбор.Вставить("Начало", ОтборПериодС);
		Отбор.Вставить("Конец",  ОтборПериодПо);
	КонецЕсли;
	
	// 2. Обновление списока фоновых заданий
	Таблица = ТаблицаФоновыеЗадания;
	КоличествоФоновыхЗаданийВсего = 0;
	ТекущаяТаблица = РегламентныеЗаданияСервер.ПолучитьТаблицуСвойствФоновыхЗаданий(Отбор, КоличествоФоновыхЗаданийВсего);
	Индекс = 0;
	Для каждого Задание ИЗ ТекущаяТаблица Цикл
		Если Индекс >= Таблица.Количество() ИЛИ Таблица[Индекс].Идентификатор <> Задание.Идентификатор Тогда
			// Вставка нового задания
			Обновляемое = Таблица.Вставить(Индекс);
			// Установка уникального идентификатора
			Обновляемое.Идентификатор = Задание.Идентификатор;
		Иначе
			Обновляемое = Таблица[Индекс];
		КонецЕсли;
		ЗаполнитьЗначенияСвойств(Обновляемое, Задание);
		// Установка наименования регламентного задания из коллекции ТаблицаРегламентныеЗадания
		Если ЗначениеЗаполнено(Обновляемое.ИдентификаторРегламентногоЗадания) Тогда
			Обновляемое.ИдентификаторРегламентногоЗадания = Обновляемое.ИдентификаторРегламентногоЗадания;
			Строки = ТаблицаРегламентныеЗадания.НайтиСтроки(Новый Структура("Идентификатор", Обновляемое.ИдентификаторРегламентногоЗадания));
			Обновляемое.НаименованиеРегламентногоЗадания = ?(Строки.Количество() = 0, НСтр("ru = '<не найдено>'"), Строки[0].Наименование);
		Иначе
			Обновляемое.НаименованиеРегламентногоЗадания  = ТекстНеОпределено;
			Обновляемое.ИдентификаторРегламентногоЗадания = ТекстНеОпределено;
		КонецЕсли;
		// Получение информации об ошибках
		ТекстОшибки = РегламентныеЗаданияСервер.СообщенияИОписанияОшибокФоновогоЗадания(Обновляемое.Идентификатор, Задание);
		Пока Найти(ТекстОшибки, Символ(1)) Цикл
			ТекстОшибки = СтрЗаменить(ТекстОшибки,Символ(1),"");	
		КонецЦикла;
		Обновляемое.СообщенияПользователюИОписаниеИнформацииОбОшибке = ТекстОшибки;
		// Увеличение индекса
		Индекс = Индекс + 1;
	КонецЦикла;
	// Удаление лишних строк
	Пока Индекс < Таблица.Количество() Цикл
		Таблица.Удалить(Таблица.Количество()-1);
	КонецЦикла;
	КоличествоФоновыхЗаданийВТаблице = Таблица.Количество();

	Элементы.ТаблицаФоновыеЗадания.Обновить();
	
КонецПроцедуры
