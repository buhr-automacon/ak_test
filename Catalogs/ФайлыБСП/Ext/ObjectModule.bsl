﻿
// _Демо начало примера
// Подсистема "Управление доступом"

// Процедура ЗаполнитьНаборыЗначенийДоступа по свойствам объекта заполняет наборы значений доступа
// в таблице с полями:
//    НомерНабора     - Число                                     (необязательно, если набор один),
//    ВидДоступа      - ПланВидовХарактеристикСсылка.ВидыДоступа, (обязательно),
//    ЗначениеДоступа - Неопределено, СправочникСсылка или др.    (обязательно),
//    Чтение          - Булево (необязательно, если набор для всех прав) устанавливается для одной строки набора,
//    Добавление      - Булево (необязательно, если набор для всех прав) устанавливается для одной строки набора,
//    Изменение       - Булево (необязательно, если набор для всех прав) устанавливается для одной строки набора,
//    Удаление        - Булево (необязательно, если набор для всех прав) устанавливается для одной строки набора,
//
//  Вызывается из процедуры УправлениеДоступом.ЗаписатьНаборыЗначенийДоступа(),
// если объект зарегистрирован в "ПодпискаНаСобытие.ЗаписатьНаборыЗначенийДоступа" и
// из таких же процедур объектов, у которых наборы значений доступа зависят от наборов этого
// объекта (в этом случае объект зарегистрирован в "ПодпискаНаСобытие.ЗаписатьЗависимыеНаборыЗначенийДоступа").
//
// Параметры:
//  Таблица      - ТабличнаяЧасть,
//                 РегистрСведенийНаборЗаписей.НаборыЗначенийДоступа,
//                 ТаблицаЗначений, возвращаемая УправлениеДоступом.ТаблицаНаборыЗначенийДоступа().
//
Процедура ЗаполнитьНаборыЗначенийДоступа(Таблица) Экспорт
	
	// Логика ограничения:
	// Чтения, Добавления, Изменения: ВладелецФайла
	
	Если ВладелецФайла = Неопределено Тогда
		
		// Доступ всегда запрещен.
		Строка = Таблица.Добавить();
		Строка.ВидДоступа      = ПланыВидовХарактеристик.ВидыДоступа.ПустаяСсылка();
		Строка.ЗначениеДоступа = Неопределено;
		
	ИначеЕсли ТипЗнч(ВладелецФайла) = Тип("СправочникСсылка._ДемоНоменклатура") ИЛИ
	          ТипЗнч(ВладелецФайла) = Тип("СправочникСсылка._ДемоПартнеры") ИЛИ
	          ТипЗнч(ВладелецФайла) = Тип("СправочникСсылка._ДемоПодразделения") Тогда
		
		// Доступ всегда разрешен.
		Строка = Таблица.Добавить();
		Строка.ВидДоступа      = ПланыВидовХарактеристик.ВидыДоступа.ПустаяСсылка();
		Строка.ЗначениеДоступа = Справочники.ГруппыПользователей.ВсеПользователи;
	
	Иначе
		
		// Доступ определяется владельцем файла.
		УправлениеДоступом.ЗаполнитьНаборыЗначенийДоступа(ВладелецФайла, Таблица, Ссылка);
	КонецЕсли;
	
КонецПроцедуры // ЗаполнитьНаборыЗначенийДоступа()

// Подсистема "Управление доступом"
// _Демо конец примера

// Обработка события ПередЗаписью
//
Процедура ПередЗаписью(Отказ)
	
	//Если ОбменДанными.Загрузка Тогда
	//	Возврат;
	//КонецЕсли;
	//
	//Если ДополнительныеСвойства.Свойство("КонвертацияФайлов") Тогда
	//	Возврат;
	//КонецЕсли;
	//
	//Если Не ЗначениеЗаполнено(ВладелецФайла) Тогда	
	//			
	//	ВызватьИсключение НСтр("ru = 'Нельзя записать файл, если не указан владелец файла.'");
	//		
	//КонецЕсли;	
	//
	//Если Не ЭтоНовый() Тогда
	//	
	//	ЕстьПометкаУдаленияВИБ = ПометкаУдаленияВИБ();
	//	УстановленаПометкаУдаления = ПометкаУдаления И Не ЕстьПометкаУдаленияВИБ;
	//	ИзмененаПометкаУдаления = (ПометкаУдаления <> ЕстьПометкаУдаленияВИБ);
	//	
	//	ЗаписьПодписанногоОбъекта = Ложь;
	//	Если ДополнительныеСвойства.Свойство("ЗаписьПодписанногоОбъекта") Тогда
	//		ЗаписьПодписанногоОбъекта = ДополнительныеСвойства.ЗаписьПодписанногоОбъекта;
	//	КонецЕсли;	
	//	
	//	// разрешаем ставить пометку удаления на подписанный файл
	//	Если НЕ ПривилегированныйРежим() И ЗаписьПодписанногоОбъекта <> Истина И НЕ УстановленаПометкаУдаления Тогда
	//		
	//		Если ЗначениеЗаполнено(Ссылка) Тогда
	//			
	//			СтруктураРеквизитов = ОбщегоНазначения.ПолучитьЗначенияРеквизитов(Ссылка, "ПодписанЭЦП, Зашифрован");
	//			СсылкаПодписан = СтруктураРеквизитов.ПодписанЭЦП;
	//			СсылкаЗашифрован = СтруктураРеквизитов.Зашифрован;
	//			
	//			Если ПодписанЭЦП И СсылкаПодписан Тогда
	//				ВызватьИсключение НСтр("ru = 'Подписанный файл нельзя редактировать.'");
	//			КонецЕсли;	
	//			
	//			Если Зашифрован И СсылкаЗашифрован И ПодписанЭЦП И НЕ СсылкаПодписан Тогда
	//				ВызватьИсключение НСтр("ru = 'Зашифрованный файл нельзя подписывать.'");
	//			КонецЕсли;	
	//			
	//		КонецЕсли;	
	//		
	//	КонецЕсли;	
	//	
	//	Если Не ТекущаяВерсия.Пустая() Тогда
	//		
	//		РеквизитыТекущейВерсии = ОбщегоНазначения.ПолучитьЗначенияРеквизитов(ТекущаяВерсия, 
	//			"ПолноеНаименование");
	//		
	//		// Проверим равенство имени файла и его текущей версии
	//		// Если имена отличаются - имя у версии должно стать как у карточки с файлом
	//		Если РеквизитыТекущейВерсии.ПолноеНаименование <> ПолноеНаименование Тогда
	//			Объект = ТекущаяВерсия.ПолучитьОбъект();
	//			Если Объект <> Неопределено И Объект.Ссылка <> Неопределено Тогда
	//				ЗаблокироватьДанныеДляРедактирования(Объект.Ссылка);
	//				УстановитьПривилегированныйРежим(Истина);
	//				Объект.ПолноеНаименование = ПолноеНаименование;
	//				Объект.ДополнительныеСвойства.Вставить("ПереименованиеФайла", Истина); // чтобы не сработала подписка СкопироватьРеквизитыВерсииФайловВФайл
	//				Объект.Записать();
	//				УстановитьПривилегированныйРежим(Ложь);
	//			КонецЕсли;	
	//		КонецЕсли;
	//		
	//	КонецЕсли;
	//	
	//	Если ИзмененаПометкаУдаления Тогда
	//		
	//		// Проверка права "Пометка на удаление".
	//		Если НЕ РаботаСФайламиПереопределяемый.ПометкаУдаленияРазрешена(ВладелецФайла) Тогда
	//			ВызватьИсключение СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
	//			                     НСтр("ru = 'У вас нет права ""Пометка на удаление"" файла ""%1"".'"),
	//			                     Строка(Ссылка));
	//		КонецЕсли;
	//		
	//		// Попытка установить пометку удаления
	//		Если УстановленаПометкаУдаления И Не Редактирует.Пустая() Тогда
	//			ВызватьИсключение СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
	//			                    НСтр("ru = 'Нельзя удалить файл ""%1"", т.к. он занят для редактирования пользователем ""%2"".'"),
	//			                    ПолноеНаименование,
	//			                    Строка(Редактирует) );
	//		КонецЕсли;
	//		
	//	КонецЕсли;
	//	
	//	НаименованиеВИБ = НаименованиеВИБ();
	//	Если ПолноеНаименование <> НаименованиеВИБ Тогда 
	//		Если Не Редактирует.Пустая() Тогда
	//			ВызватьИсключение СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
	//			                    НСтр("ru = 'Нельзя переименовать файл ""%1"", т.к. он занят для редактирования пользователем ""%2"".'"),
	//			                    НаименованиеВИБ,
	//			                    Строка(Редактирует) );
	//		КонецЕсли;
	//	КонецЕсли;
	//	
	//КонецЕсли;
	//
	//
	//Наименование = СокрЛП(ПолноеНаименование);
КонецПроцедуры

// Возвращает текущее значение пометки удаления в информационной базе
Функция ПометкаУдаленияВИБ()
	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ
		|	Файлы.ПометкаУдаления
		|ИЗ
		|	Справочник.Файлы КАК Файлы
		|ГДЕ
		|	Файлы.Ссылка = &Ссылка";

	Запрос.УстановитьПараметр("Ссылка", Ссылка);

	Результат = Запрос.Выполнить();

	Если Не Результат.Пустой() Тогда
		Выборка = Результат.Выбрать();
		Выборка.Следующий();
		Возврат Выборка.ПометкаУдаления;
	КонецЕсли;	
	
	Возврат Неопределено;
КонецФункции

// Возвращает текущее значение наименования в информационной базе
Функция НаименованиеВИБ()
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	Файлы.ПолноеНаименование
	|ИЗ
	|	Справочник.ФайлыБСП КАК Файлы
	|ГДЕ
	|	Файлы.Ссылка = &Ссылка";
	
	Запрос.УстановитьПараметр("Ссылка", Ссылка);
	Результат = Запрос.Выполнить();
	
	Если Не Результат.Пустой() Тогда
		Выборка = Результат.Выбрать();
		Выборка.Следующий();
		Возврат Выборка.ПолноеНаименование;
	КонецЕсли;
	
	Возврат Неопределено;	
	
КонецФункции

Процедура ОбработкаЗаполнения(ДанныеЗаполнения, СтандартнаяОбработка)
	
	//Если ЭтоНовый() Тогда
	//	ДатаСоздания = ТекущаяДатаСеанса();
	//	ХранитьВерсии = Истина;
	//	ИндексКартинки = ФайловыеФункцииКлиентСервер.ПолучитьИндексПиктограммыФайла(Неопределено);
	//	
	//	Автор = Пользователи.ТекущийПользователь();
	//КонецЕсли;
	
КонецПроцедуры

