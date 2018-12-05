﻿
Функция ТелефонУказанВДругихТТ(Ссылка, Телефон1, Телефон2) Экспорт
	
	МассивТТ = Новый Массив();
	МассивТелефоны = Новый Массив();
	Если ЗначениеЗаполнено(Телефон1) Тогда
		МассивТелефоны.Добавить(Телефон1);
	КонецЕсли;	
	Если ЗначениеЗаполнено(Телефон2) Тогда
		МассивТелефоны.Добавить(Телефон2);
	КонецЕсли;
	
	Если МассивТелефоны.Количество() = 0 Тогда
		Возврат МассивТТ;
	КонецЕсли;	
	
	Запрос = Новый Запрос();
	Запрос.Текст = "ВЫБРАТЬ
	               |	СтруктурныеЕдиницы.Ссылка
	               |ИЗ
	               |	Справочник.СтруктурныеЕдиницы КАК СтруктурныеЕдиницы
	               |ГДЕ
	               |	СтруктурныеЕдиницы.Ссылка <> &Ссылка
	               |	И (СтруктурныеЕдиницы.ТелефонныйНомер1 В (&Телефоны)
	               |			ИЛИ СтруктурныеЕдиницы.ТелефонныйНомер2 В (&Телефоны))";
				   
	Запрос.УстановитьПараметр("Ссылка", Ссылка);
	Запрос.УстановитьПараметр("Телефоны", МассивТелефоны);
	Выборка = Запрос.Выполнить().Выбрать();
	Пока Выборка.Следующий() Цикл
		МассивТТ.Добавить(Выборка.Ссылка);
	КонецЦикла;	
	
	Возврат МассивТТ;
	
КонецФункции	

Функция ПечатьОткрытиеОбособленногоПодразделения(Ссылка) Экспорт
	
	ТабДок = Новый ТабличныйДокумент();
	Макет = Справочники.СтруктурныеЕдиницы.ПолучитьМакет("ОткрытиеОбособленногоПодразделения");
	
	ЭтоВкусвилл = Ссылка.ТипРозничнойТочки = Перечисления.ТипыРозничныхТочек.Магазин;
	
	Область = Макет.ПолучитьОбласть("Шапка");
	Область.Параметры.НаименованиеОрганизации = ?(ЭтоВкусвилл, "Общество с ограниченной ответственностью" + Символы.ПС + """Вкусвилл""", "Общество с ограниченной ответственностью" + Символы.ПС + """Луг да Поле""");
	Область.Параметры.Дата = Формат(Ссылка.ДатаПереходаНаУчетПоОбособленномуПодразделению, "ДФ='dd MMMM yyyy ""года""'");
	Область.Параметры.Адрес = "" + Ссылка.Город + ", " + Ссылка.Адрес;
	Область.Параметры.ГенДиректорР = ?(ЭтоВкусвилл, "Фарафонову А.В.", "Кривенко А.А.");
	Область.Параметры.НаименованиеОрганизацииКратко = ?(ЭтоВкусвилл, "ООО ""Вкусвилл""", "ООО ""Луг да Поле""");
	Область.Параметры.ГенДиректор = ?(ЭтоВкусвилл, "Фарафонов Алексей Владимирович", "Кривенко Андрей Александрович");
	
	Если ЭтоВкусвилл Тогда
		ПодписьФизЛица = Справочники.ФизическиеЛица.НайтиПоНаименованию("Фарафонов Алексей Владимирович").Подпись;
	Иначе
		ПодписьФизЛица = Справочники.ФизическиеЛица.НайтиПоНаименованию("Кривенко Андрей Александрович").Подпись;
	КонецЕсли;	
	
	Подпись = ПодписьФизЛица.Получить();
	Если ТипЗнч(Подпись) = Тип("Картинка") Тогда
		Рис = Область.Рисунки.Добавить(ТипРисункаТабличногоДокумента.Картинка);
		Рис.Расположить(Область.Область(21,23,22,28));
		Рис.Узор = ТипУзораТабличногоДокумента.БезУзора;
		Рис.ЦветФона = Новый Цвет; // автоцвет (прозрачный чтоб полоску подчеркивания видно было)
		Рис.Линия = Новый Линия(ТипЛинииРисункаТабличногоДокумента.НетЛинии, 0);
		Рис.Картинка = Подпись;
	КонецЕсли;
	
	Если ЭтоВкусвилл Тогда
		ПечатьОрг = Справочники.Организации.НайтиПоРеквизиту("ИНН", "7734675810").Печать;
	Иначе
		ПечатьОрг = Справочники.Организации.НайтиПоРеквизиту("ИНН", "7726660031").Печать;
	КонецЕсли;	
	
	Печать = ПечатьОрг.Получить();
	Если ТипЗнч(Печать) = Тип("Картинка") Тогда
		Рис = Область.Рисунки.Добавить(ТипРисункаТабличногоДокумента.Картинка);
		Рис.Расположить(Область.Область(20,25,29,33));
		Рис.Узор = ТипУзораТабличногоДокумента.БезУзора;
		Рис.ЦветФона = Новый Цвет; // автоцвет (прозрачный чтоб полоску подчеркивания видно было)
		Рис.Линия = Новый Линия(ТипЛинииРисункаТабличногоДокумента.НетЛинии, 0);
		Рис.Картинка = Печать;
	КонецЕсли;
	
	ТабДок.Вывести(Область);
	
	Возврат ТабДок;
	
КонецФункции

Функция ПечатьЗакрытиеОбособленногоПодразделения(Ссылка) Экспорт
	
	ТабДок = Новый ТабличныйДокумент();
	Макет = Справочники.СтруктурныеЕдиницы.ПолучитьМакет("ЗакрытиеОбособленногоПодразделения");
	
	ЭтоВкусвилл = Ссылка.ТипРозничнойТочки = Перечисления.ТипыРозничныхТочек.Магазин;
	
	Область = Макет.ПолучитьОбласть("Шапка");
	Область.Параметры.НаименованиеОрганизации = ?(ЭтоВкусвилл, "Общество с ограниченной ответственностью" + Символы.ПС + """Вкусвилл""", "Общество с ограниченной ответственностью" + Символы.ПС + """Луг да Поле""");
	Область.Параметры.Дата = Формат(Ссылка.ДатаЗакрытия, "ДФ='dd MMMM yyyy ""года""'");
	Область.Параметры.Адрес = "" + Ссылка.Город + ", " + Ссылка.Адрес;
	Область.Параметры.ГенДиректорР = ?(ЭтоВкусвилл, "Фарафонову А.В.", "Кривенко А.А.");
	Область.Параметры.НаименованиеОрганизацииКратко = ?(ЭтоВкусвилл, "ООО ""Вкусвилл""", "ООО ""Луг да Поле""");
	Область.Параметры.ГенДиректор = ?(ЭтоВкусвилл, "Фарафонов Алексей Владимирович", "Кривенко Андрей Александрович");
	
	Если ЭтоВкусвилл Тогда
		ПодписьФизЛица = Справочники.ФизическиеЛица.НайтиПоНаименованию("Фарафонов Алексей Владимирович").Подпись;
	Иначе
		ПодписьФизЛица = Справочники.ФизическиеЛица.НайтиПоНаименованию("Кривенко Андрей Александрович").Подпись;
	КонецЕсли;	
	
	Подпись = ПодписьФизЛица.Получить();
	Если ТипЗнч(Подпись) = Тип("Картинка") Тогда
		Рис = Область.Рисунки.Добавить(ТипРисункаТабличногоДокумента.Картинка);
		Рис.Расположить(Область.Область(17,23,18,28));
		Рис.Узор = ТипУзораТабличногоДокумента.БезУзора;
		Рис.ЦветФона = Новый Цвет; // автоцвет (прозрачный чтоб полоску подчеркивания видно было)
		Рис.Линия = Новый Линия(ТипЛинииРисункаТабличногоДокумента.НетЛинии, 0);
		Рис.Картинка = Подпись;
	КонецЕсли;
	
	Если ЭтоВкусвилл Тогда
		ПечатьОрг = Справочники.Организации.НайтиПоРеквизиту("ИНН", "7734675810").Печать;
	Иначе
		ПечатьОрг = Справочники.Организации.НайтиПоРеквизиту("ИНН", "7726660031").Печать;
	КонецЕсли;	
	
	Печать = ПечатьОрг.Получить();
	Если ТипЗнч(Печать) = Тип("Картинка") Тогда
		Рис = Область.Рисунки.Добавить(ТипРисункаТабличногоДокумента.Картинка);
		Рис.Расположить(Область.Область(16,25,25,33));
		Рис.Узор = ТипУзораТабличногоДокумента.БезУзора;
		Рис.ЦветФона = Новый Цвет; // автоцвет (прозрачный чтоб полоску подчеркивания видно было)
		Рис.Линия = Новый Линия(ТипЛинииРисункаТабличногоДокумента.НетЛинии, 0);
		Рис.Картинка = Печать;
	КонецЕсли;
	
	ТабДок.Вывести(Область);
	
	Возврат ТабДок;
	
КонецФункции

Функция НомерДляНовойТочки(Ссылка=Неопределено)Экспорт
	Запрос = Новый Запрос;
	Запрос.Текст =
	"ВЫБРАТЬ
	|	МАКСИМУМ(СтруктурныеЕдиницы.НомерТочки) КАК НомерТочки
	|ИЗ
	|	Справочник.СтруктурныеЕдиницы КАК СтруктурныеЕдиницы
	|ГДЕ
	|	СтруктурныеЕдиницы.Ссылка <> &Ссылка
	|	И СтруктурныеЕдиницы.НомерТочки < 90000
	|	И НЕ СтруктурныеЕдиницы.ПометкаУдаления
	|
	|ДЛЯ ИЗМЕНЕНИЯ
	|	Справочник.СтруктурныеЕдиницы";
	
	Запрос.УстановитьПараметр("Ссылка",Ссылка);
	Выборка = Запрос.Выполнить().Выбрать();
	Если Выборка.Следующий()Тогда
		Возврат Выборка.НомерТочки+1
	Иначе
		Возврат 1
	КонецЕсли;
КонецФункции

Процедура ОбработатьПодтверждениеПередачиИзПисьма(СЕСсылка, СтруктураПараметров) Экспорт	
Если ТипЗнч(СЕСсылка) = Тип("СправочникСсылка.СтруктурныеЕдиницы") И ((СтруктураПараметров.Согласовано И НЕ СтруктураПараметров.Отклонено) ИЛИ (НЕ СтруктураПараметров.Согласовано И СтруктураПараметров.Отклонено)) Тогда
		Попытка
			СЕОбъект = СЕСсылка.ПолучитьОбъект();
			СЕОбъект.МагазинПередан = СтруктураПараметров.Согласовано;
			//+++AK GREK 06.09.2018 ИП-00019760
			Если ЗначениеЗаполнено(СЕОбъект.БонусПоПередаче) Тогда
				СЕОбъект.СрокПередачи = СЕОбъект.БонусПоПередаче;
			КонецЕсли;
			//Получим данные для записи одним запросом
			ТипРолиУправляющийРозницей = ПланыВидовХарактеристик.ТипыРолейПользователя.НайтиПоКоду("PomoshnikTerrUpravlyushego");
			Запрос = Новый Запрос;
			Запрос.Текст = "ВЫБРАТЬ ПЕРВЫЕ 1
			               |	РолиПользователейСоставРоли.Ссылка КАК РольПомощникаТУ,
			               |	РолиПользователейСоставРоли.Ссылка.Родитель КАК РольТУ,
			               |	РолиПользователейСоставРоли1.Сотрудник КАК ТУ,
			               |	ПользователиПоЦФОСрезПоследних.ЦФО,
			               |	ПользователиПоЦФОСрезПоследних.Период,
			               |	ПользователиПоЦФОСрезПоследних.Сотрудник КАК ПользовательТУ
			               |ИЗ
			               |	Справочник.РолиПользователей.ТипыРолей КАК РолиПользователейТипыРолей
			               |		ВНУТРЕННЕЕ СОЕДИНЕНИЕ Справочник.РолиПользователей.СоставРоли КАК РолиПользователейСоставРоли
			               |			ЛЕВОЕ СОЕДИНЕНИЕ Справочник.РолиПользователей.СоставРоли КАК РолиПользователейСоставРоли1
			               |				ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.ПользователиПоЦФО.СрезПоследних КАК ПользователиПоЦФОСрезПоследних
			               |				ПО РолиПользователейСоставРоли1.Сотрудник = ПользователиПоЦФОСрезПоследних.Сотрудник.ФизЛицо
			               |			ПО РолиПользователейСоставРоли.Ссылка.Родитель = РолиПользователейСоставРоли1.Ссылка
			               |		ПО РолиПользователейТипыРолей.Ссылка = РолиПользователейСоставРоли.Ссылка
			               |ГДЕ
			               |	РолиПользователейСоставРоли.Сотрудник = &Сотрудник
			               |	И РолиПользователейТипыРолей.ТипРоли = &ТипРоли
			               |	И РолиПользователейСоставРоли.Ссылка.ПометкаУдаления = ЛОЖЬ
			               |
			               |УПОРЯДОЧИТЬ ПО
			               |	ПользователиПоЦФОСрезПоследних.Период УБЫВ";
			Запрос.УстановитьПараметр("Сотрудник",СЕОбъект.ПомощникУправляющего);
			Запрос.УстановитьПараметр("ТипРоли",ТипРолиУправляющийРозницей);
			Рез = Запрос.Выполнить();
			Выборка = Рез.Выбрать();
			Если НЕ Рез.Пустой() Тогда
				Выборка.Следующий();
				СЕОбъект.АкцептантЗаявок = Выборка.ПользовательТУ;
			КонецЕсли;
			//---AK
			//+++AK GREK 16.09.2018 ИП-00019859
			СЕОбъект.ФорматМагазинаВВ = ПредопределенноеЗначение("Перечисление.ФорматМагазинаВВ.Обычный");
			//---
			СЕОбъект.Записать();
			//Меняем ЦФО на ЦФО помощника управляющего
			ЦФО = Неопределено;
			Если НЕ Рез.Пустой() Тогда
				ЗаписьЦФО = РегистрыСведений.ЦФОСтруктурныхЕдиниц.СоздатьМенеджерЗаписи();
				ЗаписьЦФО.Период = ТекущаяДата();
				ЗаписьЦФО.СтруктурнаяЕдиница = СЕОбъект.Ссылка;
				ЗаписьЦФО.Организация = СЕОбъект.Организация;
				ЗаписьЦФО.ЦФО = Выборка.ЦФО;
				ЗаписьЦФО.АвторИзменений = СЕОбъект.ПомощникУправляющего;
				ЗаписьЦФО.ДатаИзменений = ТекущаяДата();
				Если ЗначениеЗаполнено(ЗаписьЦФО.ЦФО) И ЗначениеЗаполнено(ЗаписьЦФО.Организация) Тогда
					ЗаписьЦФО.Записать();
				КонецЕсли;
				ЦФО = Выборка.ЦФО;
			КонецЕсли;
			//Убираем ответственного по раскрутке
			ТипРолиПомощникПоРаскрутке = ПланыВидовХарактеристик.ТипыРолейПользователя.НайтиПоКоду("PomoshnikPoRaskrutke");
			Если ЗначениеЗаполнено(ТипРолиПомощникПоРаскрутке) Тогда 
				НаборЗаписей = РегистрыСведений.СоответствиеОбъектРоль.СоздатьНаборЗаписей();
				НаборЗаписей.Отбор.Объект.Установить(СЕСсылка);
				НаборЗаписей.Отбор.ТипРоли.Установить(ТипРолиПомощникПоРаскрутке);
				НаборЗаписей.Записать();
			КонецЕсли;
			//Обновляем управляющего розницей
			Если ЗначениеЗаполнено(ТипРолиУправляющийРозницей) И НЕ Рез.Пустой() Тогда 
				РолиПользователя = Рез.Выгрузить();
				НаборЗаписей = РегистрыСведений.СоответствиеОбъектРоль.СоздатьНаборЗаписей();
				НаборЗаписей.Отбор.Объект.Установить(СЕСсылка);
				НаборЗаписей.Отбор.ТипРоли.Установить(ТипРолиУправляющийРозницей);
				НаборЗаписей.Прочитать();
				НаборЗаписей.Очистить();
				НоваяЗапись = НаборЗаписей.Добавить();
				НоваяЗапись.Период = ТекущаяДата();
				НоваяЗапись.ТипРоли = ТипРолиУправляющийРозницей;
				НоваяЗапись.Объект = СЕСсылка;
				НоваяЗапись.РольПользователя = Выборка.РольПомощникаТУ;
				НоваяЗапись.ТипРолиID = "PomoshnikTerrUpravlyushego";
				НоваяЗапись.Автор = СЕОбъект.ПомощникУправляющего;
				НаборЗаписей.Записать();
			КонецЕсли;
		Исключение
			Возврат;
		КонецПопытки;
		ПараметрыУведомления = Новый Структура;
		ПараметрыУведомления.Вставить("НаименованиеМагазина",СЕОбъект.Наименование);
		ПараметрыУведомления.Вставить("КтоПередает",СЕОбъект.КтоПередает);
		ПараметрыУведомления.Вставить("МагазинПередан",СтруктураПараметров.Согласовано);
		ПараметрыУведомления.Вставить("АдресМагазина", "" +СЕОбъект.Регион + ", " + СЕОбъект.Город.ПолноеНаименование + ", " + СЕОбъект.ПомощникУправляющего);
		//+++AK GREK 16.09.2018 ИП-00019822
		ПараметрыУведомления.Вставить("Группа",ЦФО);
		ПараметрыУведомления.Вставить("СрокПередачи",СЕОбъект.СрокПередачи);
		//---AK
		Справочники.СтруктурныеЕдиницы.РассылкаОПередачеМагазинаВРозницу(ПараметрыУведомления);
	КонецЕсли;
КонецПроцедуры

//+++AK GREK 05.08.2018 ИП-00019354
&НаСервере
Процедура РассылкаОПередачеМагазинаВРозницу(ПараметрыУведомления) Экспорт
	УчетнаяЗапись = ОбщиеПроцедуры.ПолучитьУчетнуюЗаписьДляРассылки("Razvitie@vkusvill.ru");
	Почта = Новый ИнтернетПочта;
	Профиль = УправлениеЭлектроннойПочтой.ПолучитьИнтернетПочтовыйПрофиль(УчетнаяЗапись);
	Почта.Подключиться(Профиль);
	Письмо = Новый ИнтернетПочтовоеСообщение;
	
	Если ПараметрыУведомления.МагазинПередан Тогда
		Письмо.Тема = "Получено подтверждение передачи магазина в розницу: " + ПараметрыУведомления.НаименованиеМагазина;
		Письмо.ИмяОтправителя  	= "" + СокрЛП(УчетнаяЗапись) + "";
		Письмо.Отправитель     	= "" + СокрЛП(УчетнаяЗапись) + "";
		//+++AK GREK 16.09.2018 ИП-00019822
		ТекстПисьма = "Магазин &НаименованиеМагазина был передан в розницу в группу &Группа. Срок передачи &СрокПередачи, передал(а) &КтоПередает";
		ТекстПисьма = СтрЗаменить(ТекстПисьма, "&НаименованиеМагазина"	, ПараметрыУведомления.НаименованиеМагазина);
		ТекстПисьма = СтрЗаменить(ТекстПисьма, "&Группа"				, ПараметрыУведомления.Группа);
		ТекстПисьма = СтрЗаменить(ТекстПисьма, "&СрокПередачи"			, ПараметрыУведомления.СрокПередачи);
		ТекстПисьма = СтрЗаменить(ТекстПисьма, "&КтоПередает"			, ПараметрыУведомления.КтоПередает);
		//---AK
		//+++AK GREK 04.09.2018 ИП-00019742   
		Запрос = Новый Запрос;
		Запрос.Текст = "ВЫБРАТЬ
	               |	АК_ГруппыРассылки.ФизЛицо,
	               |	АК_ГруппыРассылки.Емейл
	               |ИЗ
	               |	РегистрСведений.АК_ГруппыРассылки КАК АК_ГруппыРассылки
	               |ГДЕ
	               |	АК_ГруппыРассылки.Группа = &Группа";
		Запрос.УстановитьПараметр("Группа",ПредопределенноеЗначение("Справочник.АК_ГруппыРассылки.Список5"));
		Рез = Запрос.Выполнить();
		Если НЕ Рез.Пустой() Тогда
			АдресаПолучателей = Рез.Выбрать();
			Пока АдресаПолучателей.Следующий() Цикл
				Строки = СтрЗаменить(СокрЛП(АдресаПолучателей.Емейл),";",Символы.ПС);
				Получатель = Письмо.Получатели.Добавить();
				Получатель.Адрес = СтрПолучитьСтроку(Строки,1);
			КонецЦикла;
		КонецЕсли;
		//---AK
	Иначе
		Письмо.Тема = "Отклонена передачи магазина в розницу: " + ПараметрыУведомления.НаименованиеМагазина;
		Письмо.ИмяОтправителя  	= "" + СокрЛП(УчетнаяЗапись) + "";
		Письмо.Отправитель     	= "" + СокрЛП(УчетнаяЗапись) + "";
		ТекстПисьма = "
		|Передача магазина в розницу отклонена: " + ПараметрыУведомления.НаименованиеМагазина;
	КонецЕсли;
	ТекстСообщения = Письмо.Тексты.Добавить(ТекстПисьма);
	
	Получатель = Письмо.Получатели.Добавить();
	Получатель.Адрес = РегистрыСведений.КонтактнаяИнформация.КонтактнаяИнформацияОбъекта(ПараметрыУведомления.КтоПередает, ПредопределенноеЗначение("Справочник.ВидыКонтактнойИнформации.EmailФизЛица"));
		
	Попытка
		Почта.Послать(Письмо);
	Исключение
	КонецПопытки;
КонецПроцедуры

//+++ AK suvv 2018.09.05 ИП-00019673
Функция ПолучитьТекстЗапросаНастройкиОткрытияМагазина() Экспорт
	
	ТекстЗапроса = "ВЫБРАТЬ РАЗЛИЧНЫЕ
	|	РолиПользователейСоставРоли.Ссылка КАК РольПользователя
	|ПОМЕСТИТЬ ВТ_ФункциональныеРолиТекПользователя
	|ИЗ
	|	Справочник.РолиПользователей.СоставРоли КАК РолиПользователейСоставРоли
	|ГДЕ
	|	РолиПользователейСоставРоли.Сотрудник = &ФизлицоТекПользователя
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ РАЗЛИЧНЫЕ
	|	РолиПользователейТипыРолей.ТипРоли
	|ПОМЕСТИТЬ ВТ_ТипыРолейФизЛицаТекПользователя
	|ИЗ
	|	ВТ_ФункциональныеРолиТекПользователя КАК ВТ_ФункциональныеРолиТекПользователя
	|		ЛЕВОЕ СОЕДИНЕНИЕ Справочник.РолиПользователей.ТипыРолей КАК РолиПользователейТипыРолей
	|		ПО ВТ_ФункциональныеРолиТекПользователя.РольПользователя = РолиПользователейТипыРолей.Ссылка
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	НастройкиОткрытияМагазинов.ВидНастройки,
	|	НастройкиОткрытияМагазинов.НастраеваемыйОбъект,
	|	НастройкиОткрытияМагазинов.Значение
	|ПОМЕСТИТЬ ВТ_ПоляПоПользователям
	|ИЗ
	|	РегистрСведений.НастройкиОткрытияМагазинов КАК НастройкиОткрытияМагазинов
	|ГДЕ
	|	(НастройкиОткрытияМагазинов.ВидНастройки = &ВидНастройки
	|				И НастройкиОткрытияМагазинов.Значение ПОДОБНО ""%"" + &ИмяПользователя + ""%""
	|			ИЛИ НастройкиОткрытияМагазинов.ВидНастройки = &ВидНастройки2
	|				И НЕ НастройкиОткрытияМагазинов.Значение ПОДОБНО ""%"" + &ИмяПользователя + ""%"")
	|	И НЕ НастройкиОткрытияМагазинов.НастраеваемыйОбъект ССЫЛКА Справочник.ФизическиеЛица
	|	И НастройкиОткрытияМагазинов.Значение <> """"
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ РАЗЛИЧНЫЕ
	|	НастройкиОткрытияМагазинов.ВидНастройки,
	|	НастройкиОткрытияМагазинов.НастраеваемыйОбъект,
	|	НастройкиОткрытияМагазинов.ЗначениеТипРолиПользователя
	|ПОМЕСТИТЬ ВТ_ПоляПоРолям
	|ИЗ
	|	РегистрСведений.НастройкиОткрытияМагазинов КАК НастройкиОткрытияМагазинов,
	|	ВТ_ТипыРолейФизЛицаТекПользователя КАК ВТ_ТипыРолейФизЛицаТекПользователя
	|ГДЕ
	|	(НастройкиОткрытияМагазинов.ВидНастройки = &ВидНастройки
	|				И НастройкиОткрытияМагазинов.ЗначениеТипРолиПользователя ПОДОБНО ""%"" + ВТ_ТипыРолейФизЛицаТекПользователя.ТипРоли.Код + ""%""
	|			ИЛИ НастройкиОткрытияМагазинов.ВидНастройки = &ВидНастройки2
	|				И НастройкиОткрытияМагазинов.ЗначениеТипРолиПользователя ПОДОБНО ""%"" + ВТ_ТипыРолейФизЛицаТекПользователя.ТипРоли.Код + ""%"")
	|	И НЕ НастройкиОткрытияМагазинов.НастраеваемыйОбъект ССЫЛКА Справочник.ФизическиеЛица
	|	И НастройкиОткрытияМагазинов.ЗначениеТипРолиПользователя <> """"
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ВТ_ПоляПоПользователям.ВидНастройки,
	|	ВТ_ПоляПоПользователям.НастраеваемыйОбъект,
	|	ВТ_ПоляПоПользователям.Значение
	|ПОМЕСТИТЬ ВТ_Объединение
	|ИЗ
	|	ВТ_ПоляПоПользователям КАК ВТ_ПоляПоПользователям
	|
	|ОБЪЕДИНИТЬ ВСЕ
	|
	|ВЫБРАТЬ
	|	ВТ_ПоляПоРолям.ВидНастройки,
	|	ВТ_ПоляПоРолям.НастраеваемыйОбъект,
	|	ВТ_ПоляПоРолям.ЗначениеТипРолиПользователя
	|ИЗ
	|	ВТ_ПоляПоРолям КАК ВТ_ПоляПоРолям
	|ГДЕ
	|	ВТ_ПоляПоРолям.ВидНастройки = &ВидНастройки
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ВТ_ПоляПоРолям.ВидНастройки,
	|	ВТ_ПоляПоРолям.НастраеваемыйОбъект,
	|	ВТ_ПоляПоРолям.ЗначениеТипРолиПользователя
	|ПОМЕСТИТЬ ВТ_Исключения
	|ИЗ
	|	ВТ_ПоляПоРолям КАК ВТ_ПоляПоРолям
	|ГДЕ
	|	ВТ_ПоляПоРолям.ВидНастройки = &ВидНастройки2
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ВТ_Объединение.ВидНастройки,
	|	ВТ_Объединение.НастраеваемыйОбъект,
	|	ВТ_Объединение.Значение
	|ИЗ
	|	ВТ_Объединение КАК ВТ_Объединение
	|		ЛЕВОЕ СОЕДИНЕНИЕ ВТ_Исключения КАК ВТ_Исключения
	|		ПО ВТ_Объединение.НастраеваемыйОбъект = ВТ_Исключения.НастраеваемыйОбъект
	|ГДЕ
	|	ЕСТЬNULL(ВТ_Исключения.НастраеваемыйОбъект, """") = """"";
	
	Возврат ТекстЗапроса;
	
КонецФункции //--- AK suvv

//+++ AK suvv 2018.09.05 ИП-00019673
Функция ПолучитьОграниченияДоступа() Экспорт
	
	РезОграничениеДоступа = Новый Структура;
	РезОграничениеДоступа.Вставить("Наименование", Истина);
	
	ТекПользователь = ПараметрыСеанса.ТекущийПользователь;
	Если ТекПользователь.Наименование = "Ковальчук Александр" Тогда
		РезОграничениеДоступа.Наименование = Ложь;	
	КонецЕсли;
	
	Запрос = Новый Запрос;
	Запрос.Текст = ПолучитьТекстЗапросаНастройкиОткрытияМагазина();
	Запрос.УстановитьПараметр("ВидНастройки",           ПредопределенноеЗначение("Перечисление.ВидыНастроекОткрытияМагазина.ЗапретРедактирования"));
	Запрос.УстановитьПараметр("ВидНастройки2",          ПредопределенноеЗначение("Перечисление.ВидыНастроекОткрытияМагазина.ЗапретРедактированияДляВсехЗаИсключением"));
	Запрос.УстановитьПараметр("ИмяПользователя",        ТекПользователь.Наименование);
	Запрос.УстановитьПараметр("ФизлицоТекПользователя", ТекПользователь.ФизЛицо);
	
	РезультатЗапроса = Запрос.Выполнить();
	
	Если НЕ РезультатЗапроса.Пустой() Тогда
		ОграничениеДоступа = РезультатЗапроса.Выбрать();
		Пока ОграничениеДоступа.Следующий() цикл
			Если ТипЗнч(ОграничениеДоступа.НастраеваемыйОбъект) = Тип("Строка") Тогда
				РезОграничениеДоступа.Вставить(ОграничениеДоступа.НастраеваемыйОбъект, Истина);
			КонецЕсли;
		КонецЦикла;
	КонецЕсли;
		
	Возврат РезОграничениеДоступа
	
КонецФункции //--- AK suvv
