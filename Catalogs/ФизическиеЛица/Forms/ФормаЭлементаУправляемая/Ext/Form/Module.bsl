﻿
&НаСервере
Перем мНаборЗаписейФИО;


&НаСервереБезКонтекста
Функция ПолучитьПол(ОтчествоРаботника)
	
	Если Прав(ОтчествоРаботника, 2) = "ич" Тогда
		Возврат Перечисления.ПолФизическихЛиц.Мужской;
	
	ИначеЕсли Прав(ОтчествоРаботника, 2) = "на" Тогда
		Возврат Перечисления.ПолФизическихЛиц.Женский;
	
	КонецЕсли;
	
	Возврат Перечисления.ПолФизическихЛиц.ПустаяСсылка();
	
КонецФункции

&НаСервереБезКонтекста
Функция ПолучитьСписокВозможныхНаименований(мФамилия, мИмя, мОтчество) Экспорт
	
	СписокВозможныхНаименований = Новый СписокЗначений;
	Если ЗначениеЗаполнено(мФамилия) Тогда
		СписокВозможныхНаименований.Добавить(мФамилия);
		Если ЗначениеЗаполнено(мИмя) Тогда
			СписокВозможныхНаименований.Добавить(СокрЛП(мФамилия) + " " + СокрЛП(мИмя));
			СписокВозможныхНаименований.Добавить(СокрЛП(мФамилия) + " " + Лев(мИмя,1) + ".");
			Если ЗначениеЗаполнено(мОтчество) Тогда
				СписокВозможныхНаименований.Добавить(СокрЛП(мФамилия) + " " + СокрЛП(мИмя) + " " + СокрЛП(мОтчество));
				СписокВозможныхНаименований.Добавить(СокрЛП(мФамилия) + " " + Лев(мИмя,1) + ". " + Лев(мОтчество,1)+ ".");
			КонецЕсли;
		КонецЕсли;
	Иначе
		Если ЗначениеЗаполнено(мИмя) Тогда
			СписокВозможныхНаименований.Добавить(мИмя);
			Если ЗначениеЗаполнено(мОтчество) Тогда
				СписокВозможныхНаименований.Добавить(СокрЛП(мИмя) + " " + СокрЛП(мОтчество));
				СписокВозможныхНаименований.Добавить(СокрЛП(мИмя) + ". " + Лев(мОтчество,1)+ ".");
			КонецЕсли;
		Иначе
			Если ЗначениеЗаполнено(мОтчество) Тогда
				СписокВозможныхНаименований.Добавить(мОтчество);
			КонецЕсли;
		КонецЕсли;
	КонецЕсли;
	
	Возврат СписокВозможныхНаименований;
	
КонецФункции

&НаСервереБезКонтекста
// Возвращает доступно ли редактирование в диалоге по типу контактной информации.
//
// Параметры:
//	Тип - ПеречислениеСсылка.ТипыКонтактнойИнформации - тип контактной информации.
//
// Возвращаемое значение - Булево - доступно или нет редактирование в диалоге.
//
Функция ДляТипаКонтактнойИнформацииДоступноРедактированиеВДиалоге(мТип)
	
	Если мТип = Перечисления.ТипыКонтактнойИнформации.Адрес
			ИЛИ мТип = Перечисления.ТипыКонтактнойИнформации.Телефон
			ИЛИ мТип = Перечисления.ТипыКонтактнойИнформации.АдресЭлектроннойПочты
			ИЛИ мТип = Перечисления.ТипыКонтактнойИнформации.ВебСтраница Тогда
		Возврат Истина;
	Иначе
		Возврат Ложь;
	КонецЕсли;
	
КонецФункции

&НаСервереБезКонтекста
// Возвращает номер по типу контактной информации.
//
// Параметры:
//	Тип - ПеречислениеСсылка.ТипыКонтактнойИнформации - тип контактной информации.
//
// Возвращаемое значение - Число:
// 		1 - Адрес
// 		2 - Телефон
//		0 - Все остальные типы
//
Функция ПоТипуКонтактнойИнформацииПолучитьНомер(Тип)
	
	Если Тип = Перечисления.ТипыКонтактнойИнформации.Адрес Тогда
		Возврат 1;
	ИначеЕсли Тип = Перечисления.ТипыКонтактнойИнформации.Телефон Тогда
		Возврат 2;
	Иначе
		Возврат 0;
	КонецЕсли;
	
КонецФункции

&НаСервереБезКонтекста
// Возвращает список значений. Преобразует строку полей в список значений.
//
// Параметры:
//	СтрокаПолей - Строка - строка полей.
//
// Возвращаемое значение - Список значений - список значений полей.
//
Функция ПреобразоватьСтрокуВСписокПолей(СтрокаПолей)
	
	Результат = Новый СписокЗначений;
	ПоследнийЭлемент = Неопределено;
	
	Для Итерация = 1 По СтрЧислоСтрок(СтрокаПолей) Цикл
		ПолученнаяСтрока = СтрПолучитьСтроку(СтрокаПолей, Итерация);
		Если Лев(ПолученнаяСтрока, 1) = Символы.Таб Тогда
			Если ПоследнийЭлемент <> Неопределено Тогда
				ПоследнийЭлемент.Значение = ПоследнийЭлемент.Значение + Символы.ПС + Сред(ПолученнаяСтрока, 2);
			КонецЕсли;
		Иначе
			ПозицияСимвола = Найти(ПолученнаяСтрока, "=");
			Если ПозицияСимвола <> 0 Тогда
				ПоследнийЭлемент = Результат.Добавить(Сред(ПолученнаяСтрока, ПозицияСимвола + 1), Лев(ПолученнаяСтрока, ПозицияСимвола - 1));
			КонецЕсли;
		КонецЕсли;
	КонецЦикла;
	
	Возврат Результат;
	
КонецФункции

Процедура УстановитьДоступностьПоПравам()
	
	ЕстьДоступность = РольДоступна("РедактированиеФизЛиц")
						ИЛИ РольДоступна("Помощник"); 
	
	Элементы.БанковскиеСчета.ТолькоПросмотр 					= НЕ ЕстьДоступность;
	Элементы.БанковскиеСчетаКнопкаСделатьОсновным.Доступность	= ЕстьДоступность;
	Элементы.Симкарты.ТолькоПросмотр 							= НЕ ЕстьДоступность;
	Элементы.СимкартыСделатьНомерОсновным.Доступность			= ЕстьДоступность;
	
	//+++АК LAGP 2017.12.15 ИП-00017446 Открываем определенные строки по доп.праву
	МассивДопПраво=УправлениеДопПравамиПользователей.ПрочитатьЗначениеПраваПользователя(ПланыВидовХарактеристик.ПраваПользователей.РедактированиеОсновнойИнформацииФизЛица,Ложь,ПараметрыСеанса.ТекущийПользователь);	
	ДопПравоРедактированиеОсновнойИнформацииФизЛица=МассивДопПраво[0];
	
	Если НЕ ДопПравоРедактированиеОсновнойИнформацииФизЛица Тогда
		ИзменитьДоступностьЭлементовФормыПоДопПраву("Редактирование основной информации физ лица", Ложь);
	КонецЕсли;	
	//---АК LAGP 2017.12.15
	
	//+++АК mika 2018.11.30 ИП-00019755.02
	Элементы.ТипВахты.ТолькоПросмотр = НЕ УправлениеДопПравамиПользователей.ПолучитьПравоПользователяУпр(ПланыВидовХарактеристик.ПраваПользователей.РедактированиеТипаВахтыВГрафике, Ложь);  
	//---АК mika 
	
КонецПроцедуры

Процедура ВывестиФИОНаФорму()
	
	ЭтаФорма.Период = ?(ЗначениеЗаполнено(Объект.ДатаРождения), Объект.ДатаРождения, Дата(1980, 1, 1));
	
	Если НЕ Объект.Ссылка.Пустая() Тогда	
		МассивФИО = ПолучитьСвязанныеДанныеФизлица();
		Если МассивФИО.Количество() > 0 Тогда
			ЭтаФорма.Фамилия  	= МассивФИО[0].Фамилия;
			ЭтаФорма.Имя      	= МассивФИО[0].Имя;
			ЭтаФорма.Отчество 	= МассивФИО[0].Отчество;
			ЭтаФорма.Период 	= МассивФИО[0].Период;
			
			//ЭтаФорма.Модифицированность = Истина;
		КонецЕсли;
	КонецЕсли;
	
	Если ЗначениеЗаполнено(Объект.Наименование)
			И НЕ ЗначениеЗаполнено(ЭтаФорма.Фамилия) Тогда
		МассивФИО = ОбщегоНазначения.ПолучитьМассивФИО(Объект.Наименование);
		ЭтаФорма.Фамилия  = МассивФИО[0];
		ЭтаФорма.Имя      = МассивФИО[1];
		ЭтаФорма.Отчество = МассивФИО[2];
		
		//ЭтаФорма.Модифицированность = Истина;
	КонецЕсли;

КонецПроцедуры

Процедура ЗаписатьФИОФизЛица(СсылкаТек)
	
	Если ЗначениеЗаполнено(ЭтаФорма.Период) Тогда
		
		МенеджерЗаписи = РегистрыСведений.ФИОФизЛиц.СоздатьМенеджерЗаписи();
		МенеджерЗаписи.Период	= ЭтаФорма.Период;
		МенеджерЗаписи.Физлицо 	= СсылкаТек;
		МенеджерЗаписи.Фамилия 	= ЭтаФорма.Фамилия;
		МенеджерЗаписи.Имя 		= ЭтаФорма.Имя;
		МенеджерЗаписи.Отчество	= ЭтаФорма.Отчество;
		
		Попытка
			МенеджерЗаписи.Записать();
		Исключение
			Сообщить(ОписаниеОшибки());
		КонецПопытки;
		
	КонецЕсли;
	
КонецПроцедуры

Процедура ДобавитьКонтактнуюИнформациюНаФормуСервер()
	
	МассивРеквизитов = Новый Массив;
	
	// Создадим таблицу значений
	ИмяОписания = "КонтактнаяИнформацияОписаниеДополнительныхРеквизитов";
	МассивРеквизитов.Добавить(Новый РеквизитФормы(ИмяОписания		, Новый ОписаниеТипов("ТаблицаЗначений")));
	МассивРеквизитов.Добавить(Новый РеквизитФормы("ИмяРеквизита"	, Новый ОписаниеТипов("Строка")										, ИмяОписания));
	МассивРеквизитов.Добавить(Новый РеквизитФормы("ЗначенияПолей"	, Новый ОписаниеТипов("СписокЗначений")								, ИмяОписания));
	МассивРеквизитов.Добавить(Новый РеквизитФормы("Тип"				, Новый ОписаниеТипов("ПеречислениеСсылка.ТипыКонтактнойИнформации"), ИмяОписания));
	МассивРеквизитов.Добавить(Новый РеквизитФормы("Вид"				, Новый ОписаниеТипов("СправочникСсылка.ВидыКонтактнойИнформации")	, ИмяОписания));
	МассивРеквизитов.Добавить(Новый РеквизитФормы("ТипНомер"		, Новый ОписаниеТипов("Число")										, ИмяОписания));
 	МассивРеквизитов.Добавить(Новый РеквизитФормы("ТолькоРоссийский", Новый ОписаниеТипов("Булево")										, ИмяОписания));

	
	// Получим список видов КИ
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("ТекущееФЛ", Объект.Ссылка);
	
	Запрос.Текст =
	"ВЫБРАТЬ
	|	КонтактнаяИнформация.Вид КАК Вид,
	|	КонтактнаяИнформация.Тип КАК Тип,
	|	КонтактнаяИнформация.Представление КАК Представление
	|ПОМЕСТИТЬ ВТТекущаяКИ
	|ИЗ
	|	РегистрСведений.КонтактнаяИнформация КАК КонтактнаяИнформация
	|ГДЕ
	|	КонтактнаяИнформация.Объект = &ТекущееФЛ
	|	И КонтактнаяИнформация.Вид ССЫЛКА Справочник.ВидыКонтактнойИнформации
	|
	|ИНДЕКСИРОВАТЬ ПО
	|	Тип
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ВидыКонтактнойИнформации.Ссылка КАК Вид,
	|	ВидыКонтактнойИнформации.Наименование КАК Наименование,
	|	ВидыКонтактнойИнформации.Тип КАК Тип,
	|	ВидыКонтактнойИнформации.ПометкаУдаления КАК ПометкаУдаления,
	|	ЕСТЬNULL(ВТТекущаяКИ.Представление, """") КАК Представление,
	|	ИСТИНА КАК Использовать
	|ИЗ
	|	Справочник.ВидыКонтактнойИнформации КАК ВидыКонтактнойИнформации
	|		ЛЕВОЕ СОЕДИНЕНИЕ ВТТекущаяКИ КАК ВТТекущаяКИ
	|		ПО (ВТТекущаяКИ.Тип = ВидыКонтактнойИнформации.Тип)
	|			И (ВТТекущаяКИ.Вид = ВидыКонтактнойИнформации.Ссылка)
	|ГДЕ
	|	ВидыКонтактнойИнформации.ВидОбъектаКонтактнойИнформации = ЗНАЧЕНИЕ(Перечисление.ВидыОбъектовКонтактнойИнформации.ФизическиеЛица)
	|   И НЕ ВидыКонтактнойИнформации.ПометкаУдаления
	|
	|УПОРЯДОЧИТЬ ПО
	|	ПометкаУдаления,
	|	ВидыКонтактнойИнформации.Наименование
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|УНИЧТОЖИТЬ ВТТекущаяКИ";
	
	УстановитьПривилегированныйРежим(Истина);
	ТаблицаЗапроса = Запрос.Выполнить().Выгрузить();
	УстановитьПривилегированныйРежим(Ложь);
	
	
	// Добавим нужные реквизиты
	Номер = 0;
	СоответствиеВидаКИИмениРеквизита = Новый Соответствие;
	Для Каждого СтрокаКИ Из ТаблицаЗапроса Цикл
		
		//+++AK GOLV
		// Убрать отсюда старые служебные телефоны
		Если СтрокаКИ.ПометкаУдаления Тогда
		//Если СтрокаКИ.ПометкаУдаления ИЛИ СтрокаКИ.Вид = Справочники.ВидыКонтактнойИнформации.ТелефонСлужебный Тогда
		//---AK GOLV
			
			СтрокаКИ.Использовать = Ложь;
			Продолжить;
		КонецЕсли;
		
		Номер = Номер + 1;
		ИмяРеквизита = "КонтактнаяИнформацияПоле" + Номер;
		МассивРеквизитов.Добавить(Новый РеквизитФормы(ИмяРеквизита, Новый ОписаниеТипов("Строка"), , СтрокаКИ.Наименование, Истина));
		
		СоответствиеВидаКИИмениРеквизита.Вставить(СтрокаКИ.Вид, ИмяРеквизита);
		
	КонецЦикла;
	
	// Изменение отображения новых реквизитов
	ЭтаФорма.ИзменитьРеквизиты(МассивРеквизитов);
	
	//+++АК PISH 2018.10.08 ИП-00019949      
	
	МожноРедактироватьТелефон = МожноРедактироватьТелефон();
	
	//---АК PISH
	

	
	// Создание элементов на форме и заполнение значений реквизитов
	ЭлементРодитель = Элементы.СтраницаКонтактнаяИнформация;
	Для Каждого СтрокаКИ Из ТаблицаЗапроса Цикл
		
		Если НЕ СтрокаКИ.Использовать Тогда
			Продолжить;
		КонецЕсли;
		
		мВид = СтрокаКИ.Вид;
		ИмяРеквизита = СоответствиеВидаКИИмениРеквизита.Получить(мВид);
		Элемент = Элементы.Вставить(ИмяРеквизита, Тип("ПолеФормы"), ЭлементРодитель);
		Элемент.Вид 				= ВидПоляФормы.ПолеВвода;
		Элемент.ПутьКДанным 		= ИмяРеквизита;
		Элемент.ПоложениеЗаголовка 	= ПоложениеЗаголовкаЭлементаФормы.Верх;
		
		
		Если СтрокаКИ.Тип = Перечисления.ТипыКонтактнойИнформации.Другое Тогда
			Элемент.Высота 				= 5;
			Элемент.МногострочныйРежим 	= Истина;
			Если мВид.Код = "000000027" Тогда //бонусная карта
				Элемент.Маска = "9999999";
				Элемент.Высота 				= 1;
				Элемент.МногострочныйРежим 	= Ложь;
			КонецЕсли;	
		КонецЕсли;
		
		Если ДляТипаКонтактнойИнформацииДоступноРедактированиеВДиалоге(СтрокаКИ.Тип) Тогда
			Элемент.КнопкаВыбора = Истина;
			Элемент.УстановитьДействие("НачалоВыбора", "Подключаемый_КонтактнаяИнформацияНачалоВыбора");
			Элемент.УстановитьДействие("ПриИзменении", "Подключаемый_КонтактнаяИнформацияПриИзменении");
		КонецЕсли;
		
		НоваяСтрока = ЭтаФорма.КонтактнаяИнформацияОписаниеДополнительныхРеквизитов.Добавить();
		НоваяСтрока.ИмяРеквизита     = ИмяРеквизита;
		НоваяСтрока.ТолькоРоссийский = Истина;
		НоваяСтрока.Вид              = мВид;
		НоваяСтрока.Тип              = СтрокаКИ.Тип;
		НоваяСтрока.ТипНомер         = ПоТипуКонтактнойИнформацииПолучитьНомер(СтрокаКИ.Тип);
		
		Если НЕ СтрокаКИ.Представление = "" Тогда	
			ЭтаФорма[ИмяРеквизита] = СтрокаКИ.Представление;	
		КонецЕсли;
		
		// Доступность служебного телефона
		Если СтрокаКИ.Вид = Справочники.ВидыКонтактнойИнформации.ТелефонСлужебный Тогда
			//Элементы[ИмяРеквизита].Доступность = УправлениеДопПравамиПользователей.РазрешитьРедактированиеСлужебногоТелефонаФизЛица();   //GOLV
		КонецЕсли;
		  //+++АК BARA 16739 2017.12.04
		  Если НоваяСтрока.Тип = Перечисления.ТипыКонтактнойИнформации.Телефон и НоваяСтрока.Вид = Справочники.ВидыКонтактнойИнформации.ТелефонСлужебный Тогда
		        Элементы[НоваяСтрока.ИмяРеквизита].ТолькоПросмотр = Истина;
		  КонецЕсли; 	
		  //---
		  //+++АК PISH 2018.10.08 ИП-00019949		  		  
		  Если МожноРедактироватьТелефон И НоваяСтрока.Тип = Перечисления.ТипыКонтактнойИнформации.Телефон и НоваяСтрока.Вид = Справочники.ВидыКонтактнойИнформации.ТелефонФизЛица Тогда
			  ИмяРеквизитаТелефонСотрудника =  СокрЛП(НоваяСтрока.ИмяРеквизита);
		  КонецЕсли;		  
		  //---АК PISH

	КонецЦикла;
	
КонецПроцедуры

Процедура ЗаписатьКИПриЗаписиНаСервере()
	
	мРегистр = РегистрыСведений.КонтактнаяИнформация;
	
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("Ссылка", Объект.Ссылка);
	
	Запрос.Текст =
	"ВЫБРАТЬ
	|	КонтактнаяИнформация.Вид КАК Вид,
	|	КонтактнаяИнформация.Тип КАК Тип,
	|	КонтактнаяИнформация.Представление КАК Представление
	|ИЗ
	|	РегистрСведений.КонтактнаяИнформация КАК КонтактнаяИнформация
	|ГДЕ
	|	КонтактнаяИнформация.Объект = &Ссылка
	|	И КонтактнаяИнформация.Вид ССЫЛКА Справочник.ВидыКонтактнойИнформации";
	
	ТаблицаКИ = Запрос.Выполнить().Выгрузить();
	
	СтруктураПоиска = Новый Структура("Тип, Вид");
	
	Для Каждого СтрокаТаблицы Из ЭтаФорма.КонтактнаяИнформацияОписаниеДополнительныхРеквизитов Цикл
		
		ТекТип = СтрокаТаблицы.Тип;
		ТекВид = СтрокаТаблицы.Вид;
		
		мПредставление = ЭтаФорма[СтрокаТаблицы.ИмяРеквизита];
		Если ПустаяСтрока(мПредставление) Тогда
			СтруктураПоиска.Тип = ТекТип;
			СтруктураПоиска.Вид = ТекВид;
			СтрокиКИ = ТаблицаКИ.НайтиСтроки(СтруктураПоиска);
			Если СтрокиКИ.Количество() > 0 Тогда
				НаборЗаписей = мРегистр.СоздатьНаборЗаписей();
				НаборЗаписей.Отбор.Объект.Установить(Объект.Ссылка);
				НаборЗаписей.Отбор.Тип.Установить(ТекТип);
				НаборЗаписей.Отбор.Вид.Установить(ТекВид);
				НаборЗаписей.Прочитать();
				
				НаборЗаписей.Очистить();
				Попытка
					НаборЗаписей.Записать();
				Исключение
					СообщениеПользователю = Новый СообщениеПользователю;
					СообщениеПользователю.Текст = "Не удалось очистить запись регистра ""Контактная информация""";
					СообщениеПользователю.Сообщить();
				КонецПопытки;
		    КонецЕсли;
			Продолжить;
		КонецЕсли;
		
		МенеджерЗаписи = мРегистр.СоздатьМенеджерЗаписи();
		МенеджерЗаписи.Объект 			= Объект.Ссылка;
		МенеджерЗаписи.Тип 				= ТекТип;
		МенеджерЗаписи.Вид 				= ТекВид;
		МенеджерЗаписи.Представление 	= мПредставление;
		
		Попытка
			МенеджерЗаписи.Записать();
		Исключение
			Сообщить("Не удалось добавить запись в регистр ""Контактная информация""" + Символы.ПС + ОписаниеОшибки());
		КонецПопытки;
		
	КонецЦикла;
	
КонецПроцедуры


////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ ФОРМЫ

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
    //+++АК mika 2018.03.16 Без задачи. Аутсорсинг 
	//(Внештатные менеджеры могут открыть карточку через через F2 формы выбора)
	// Коллизия - обязательное наличие роли Пользователь (в которой есть возможность просмотра карточки)
	Если РольДоступна("ОтветственныйЗаРаботуСАутсорсингом") Тогда
		Отказ = Истина;
		Сообщить("Нарушение прав доступа!");
		Возврат
	КонецЕсли;
	//---АК mika Без задачи.
	
	ДобавитьКонтактнуюИнформациюНаФормуСервер();
	
	// банковские счета (отбор по текущему контрагенту)
	ЭлементОтбора = ЭтаФорма.БанковскиеСчета.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ЭлементОтбора.ЛевоеЗначение 	= Новый ПолеКомпоновкиДанных("Владелец");
	ЭлементОтбора.ВидСравнения 		= ВидСравненияКомпоновкиДанных.Равно;
	ЭлементОтбора.Использование 	= Истина;
	ЭлементОтбора.ПравоеЗначение 	= Объект.Ссылка;
	
	//+++АК GOLV
	ЭлементОтбора = ЭтаФорма.Симкарты.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ЭлементОтбора.ЛевоеЗначение 	= Новый ПолеКомпоновкиДанных("Привязка");
	ЭлементОтбора.ВидСравнения 		= ВидСравненияКомпоновкиДанных.Равно;
	ЭлементОтбора.Использование 	= Истина;
	ЭлементОтбора.ПравоеЗначение 	= Объект.Ссылка;	
	//---АК
	
	ВывестиФИОНаФорму();
	
	Об = РеквизитФормыВЗначение("Объект");
	ЗначениеПодписи = Об.Подпись.Получить();
	Если ТипЗнч(ЗначениеПодписи) = Тип("Картинка") Тогда
		КартинкаПодписи = ЗначениеПодписи;
	Иначе
		КартинкаПодписи = Новый Картинка();
	КонецЕсли;
	
	УстановитьКартинкуПодписи();
	
	//+++АК пмм 18.05.17
	Элементы.КоэффициентБонусаПомощникаУправляющего.Видимость = УправлениеДопПравамиПользователей.ПолучитьПравоПользователяУпр(ПланыВидовХарактеристик.ПраваПользователей.ДоступККоэффициентамБонусовПомощниковУправляющих, Ложь);
	//---АК пмм 18.05.17
	
	УстановитьДоступностьПоПравам();
	
	//mika Дата: 2017.10.16 ИП-00016863
	ОбновитьВозможностьРедактированияПомощниковТУ();
	//mika
	
	//+++АК SHEP 2017.11.27 ИП-00017310
	УстановитьПривилегированныйРежим(Истина);
	Если РольДоступна("ПолныеПрава") ИЛИ РольДоступна("КабинетРассылки") Тогда
		Если ЗначениеЗаполнено(Объект.Ссылка) Тогда
			Элементы.СтраницаКабинетРассылки.Видимость = Истина;
			СообщенияФизЛица.Параметры.УстановитьЗначениеПараметра("Владелец", Объект.Ссылка);
		КонецЕсли;
	КонецЕсли;
	//---АК SHEP 2017.11.27

	//+++АК mika 2018.05.15 ИП-00018153
	АтестацииСотрудника.Параметры.УстановитьЗначениеПараметра("Ссылка", Объект.Ссылка);
	//---АК mika ИП-00018153
	
	//+++АК PISH 2018.10.17 ИП-00019935
	Если НЕ Параметры.Ключ.Пустая() Тогда 
		ЗаполнитьДанныеОПрохожденииЧекапов();	
	КонецЕсли;
	//---АК PISH
	
КонецПроцедуры

&НаСервере
Процедура ПриЗаписиНаСервере(Отказ, ТекущийОбъект, ПараметрыЗаписи)

	ЗаписатьКИПриЗаписиНаСервере();
	
	ЗаписатьФИОФизЛица(ТекущийОбъект.Ссылка);
	
	//mika Дата: 2017.10.16 ИП-00016863
	ОбновитьВозможностьРедактированияПомощниковТУ();
	//mika
	
КонецПроцедуры


////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ ЭЛЕМЕНТОВ ШАПКИ ФОРМЫ

&НаКлиенте
Процедура НаименованиеПриИзменении(Элемент)
	
	ТекФИО = Объект.Наименование;
	
	Если ПустаяСтрока(ЭтаФорма.Фамилия)
			ИЛИ НЕ ЗначениеЗаполнено(Объект.Ссылка) Тогда
			
		МассивФИО = ОбщегоНазначения.ПолучитьМассивФИО(ТекФИО);
		ЭтаФорма.Фамилия  = МассивФИО[0];
		ЭтаФорма.Имя      = МассивФИО[1];
		ЭтаФорма.Отчество = МассивФИО[2];
		
		Если ЗначениеЗаполнено(ЭтаФорма.Отчество)
				И НЕ ЗначениеЗаполнено(Объект.Пол) Тогда
			Объект.Пол = ПолучитьПол(ЭтаФорма.Отчество);
		КонецЕсли;
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура НаименованиеНачалоВыбораИзСписка(Элемент, СтандартнаяОбработка)

	СтандартнаяОбработка = Ложь;

	// Формирование списка выбора.
	СписокВозможныхНаименований = ПолучитьСписокВозможныхНаименований(ЭтаФорма.Фамилия, ЭтаФорма.Имя, ЭтаФорма.Отчество);
	
	// Выбор из списка и обработка выбора.
	РезультатВыбора = ВыбратьИзСписка(СписокВозможныхНаименований, Элементы.Наименование);
	
	Если НЕ РезультатВыбора = Неопределено Тогда
		Объект.Наименование = РезультатВыбора.Значение;
	КонецЕсли;
	
КонецПроцедуры

Функция ПолучитьСвязанныеДанныеФизлица()
	
	СтруктураФИО = Новый Структура;
	СтруктураФИО.Вставить("Период"	, ЭтаФорма.Период);
	СтруктураФИО.Вставить("Фамилия"	, ЭтаФорма.Фамилия);
	СтруктураФИО.Вставить("Имя"		, ЭтаФорма.Имя);
	СтруктураФИО.Вставить("Отчество", ЭтаФорма.Отчество);
	
	МассивФИО = Новый Массив;
	Если НЕ Объект.Ссылка.Пустая() Тогда
		Запрос = Новый Запрос;
		Запрос.УстановитьПараметр("ПарамФизЛицо"	, Объект.Ссылка);
		Запрос.УстановитьПараметр("парамДатаСреза"	, ОбщегоНазначения.ПолучитьРабочуюДату());
		
		Запрос.Текст = 
		"ВЫБРАТЬ
		|	СвязанныеДанные.*
		|ИЗ
		|	РегистрСведений.ФИОФизЛиц.СрезПоследних(&парамДатаСреза, ФизЛицо = &ПарамФизЛицо) КАК СвязанныеДанные";
		
		Выборка = Запрос.Выполнить().Выбрать();
		Если Выборка.Следующий() Тогда
			ЗаполнитьЗначенияСвойств(СтруктураФИО, Выборка);
		КонецЕсли;
		
		МассивФИО.Добавить(СтруктураФИО);
	КонецЕсли;	
	
	
	Возврат МассивФИО;
	
КонецФункции

&НаКлиенте
Процедура СменитьФИО(Команда)
	
	МассивФИО = ПолучитьСвязанныеДанныеФизлица();
	
	ПараметрыФормы = Новый Структура;
	ПараметрыФормы.Вставить("Физлицо", Объект.Ссылка);
	Если МассивФИО.Количество() = 0 Тогда
		ПараметрыФормы.Вставить("Период"	, ЭтаФорма.Период);
		ПараметрыФормы.Вставить("Фамилия"	, ЭтаФорма.Фамилия);
		ПараметрыФормы.Вставить("Имя"		, ЭтаФорма.Имя);
		ПараметрыФормы.Вставить("Отчество"	, ЭтаФорма.Отчество);
	Иначе
		ПараметрыФормы.Вставить("Период"	, МассивФИО[0].Период);
		ПараметрыФормы.Вставить("Фамилия"	, МассивФИО[0].Фамилия);
		ПараметрыФормы.Вставить("Имя"		, МассивФИО[0].Имя);
		ПараметрыФормы.Вставить("Отчество"	, МассивФИО[0].Отчество);
	КонецЕсли;	
		
	ФормаЗаписиФИО = ПолучитьФорму("Справочник.ФизическиеЛица.Форма.ФормаЗаписиФИОУправляемая", ПараметрыФормы, ЭтаФорма);//, ЭтаФорма);
	Результат = ФормаЗаписиФИО.ОткрытьМодально();
	
	Если НЕ Результат = Неопределено Тогда
		ЭтаФорма.Период 	= Результат.Период;
		ЭтаФорма.Фамилия 	= Результат.Фамилия;
		ЭтаФорма.Имя 		= Результат.Имя;
		ЭтаФорма.Отчество 	= Результат.Отчество;
		
		ПредлагаемНаименование = СокрЛП(ЭтаФорма.Фамилия) + " " + СокрЛП(ЭтаФорма.Имя) + " " + СокрЛП(ЭтаФорма.Отчество);
		Если НЕ Объект.Наименование = ПредлагаемНаименование Тогда
			ТекстВопроса = "Вы сменили ФИО физического лица. Изменить наименование на " + ПредлагаемНаименование + "?";
			Ответ = Вопрос(ТекстВопроса, РежимДиалогаВопрос.ДаНет);
			Если Ответ = КодВозвратаДиалога.Да Тогда
				Объект.Наименование = ПредлагаемНаименование;
			КонецЕсли;
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры


////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ ЭЛЕМЕНТОВ ТАБЛИЦЫ ФОРМЫ КОНТАКТНАЯ ИНФОРМАЦИЯ

&НаКлиенте
Процедура Подключаемый_КонтактнаяИнформацияПриИзменении(Элемент)
	
	УправлениеКонтактнойИнформациейКлиент.ПредставлениеПриИзменении(ЭтаФорма, Элемент);
	
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_КонтактнаяИнформацияНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	УправлениеКонтактнойИнформациейКлиент.ПредставлениеНачалоВыбора(ЭтаФорма, Элемент, Модифицированность, СтандартнаяОбработка);
	
КонецПроцедуры


////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ КОМАНД ФОРМЫ

&НаКлиенте
// Процедура изменяет доступность кнопки установки основного банковского счета.
//
Процедура ПроверитьПометкуКнопкиУстановкиОсновногоБанковскогоСчета()
	
	// Pans 2017.08.24 ИП-00015757 ТекДанные изменены на ТекСтрока, т.к. выходила ошибка
	//Перем ТекДанные;
	
	//ТекДанные = Элементы.БанковскиеСчета.ТекущиеДанные;
	ТекСтрока = Элементы.БанковскиеСчета.ТекущаяСтрока;
	//Если ТекДанные = Неопределено Тогда
	Если ТекСтрока = Неопределено Тогда
		Элементы.БанковскиеСчетаКнопкаСделатьОсновным.Доступность = Ложь;
		Элементы.БанковскиеСчетаКнопкаСделатьОсновным.Пометка     = Ложь;
	Иначе
		Элементы.БанковскиеСчетаКнопкаСделатьОсновным.Доступность = Истина;
		
		//Элементы.БанковскиеСчетаКнопкаСделатьОсновным.Пометка     = (ТекДанные.Ссылка = Объект.ОсновнойБанковскийСчет);
		Элементы.БанковскиеСчетаКнопкаСделатьОсновным.Пометка     = (ТекСтрока = Объект.ОсновнойБанковскийСчет);
	КонецЕсли; 

КонецПроцедуры


&НаКлиенте
Процедура ДатаРожденияПриИзменении(Элемент)
	
	Если НЕ ЗначениеЗаполнено(ЭтаФорма.Период) ТОгда
		ЭтаФорма.Период = ?(ЗначениеЗаполнено(Объект.ДатаРождения), Объект.ДатаРождения, Дата(1980, 1, 1));
	КонецЕсли;
	
КонецПроцедуры

Процедура СделатьОсновнымБанковскийСчетСервер(мСсылка)
	
	Если НЕ ЗначениеЗаполнено(мСсылка) Тогда
		Возврат;
	КонецЕсли;

	Если Объект.ОсновнойБанковскийСчет = мСсылка Тогда
		Объект.ОсновнойБанковскийСчет = Справочники.БанковскиеСчета.ПустаяСсылка();
	Иначе
		Объект.ОсновнойБанковскийСчет = мСсылка;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура СделатьОсновнымБанковскийСчет(Команда)
	
	// Pans 2017.08.24 ИП-00015757 ТекДанные изменены на ТекСтрока, т.к. выходила ошибка
	//Перем ТекДанные;
	
	//ТекДанные = Элементы.БанковскиеСчета.ТекущиеДанные;
	ТекСтрока = Элементы.БанковскиеСчета.ТекущаяСтрока;
	//Если ТекДанные = Неопределено Тогда
	//	Возврат;
	//КонецЕсли; 
	//СделатьОсновнымБанковскийСчетСервер(ТекДанные.Ссылка);
	Если ТекСтрока <> Неопределено Тогда
		СделатьОсновнымБанковскийСчетСервер(ТекСтрока);	
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура БанковскиеСчетаПриАктивизацииСтроки(Элемент)
	
	ПроверитьПометкуКнопкиУстановкиОсновногоБанковскогоСчета();
	
КонецПроцедуры

&НаКлиенте
Процедура ПечатьБэйджа(Команда)
	
	МассивФизЛиц = Новый Массив;
	МассивФизЛиц.Добавить(Объект.Ссылка);
	
	ТабДокумент = ПолучитьТабличныйДокумент(МассивФизЛиц);
	
	ТабДокумент.ОтображатьСетку = Ложь;
	ТабДокумент.Защита = Истина;
	ТабДокумент.ТолькоПросмотр = Истина;
	ТабДокумент.ОтображатьЗаголовки = Ложь;
	ТабДокумент.Показать();
	
КонецПроцедуры

&НаСервере
Функция ПолучитьТабличныйДокумент(МассивФизическихЛиц)
	
	Возврат Обработки.ГрафикРаботыПродавцов_ТЗ.СформироватьТабличныйДокумент(МассивФизическихЛиц);
	
КонецФункции

&НаСервере
Функция УстановитьКартинкуПодписи()
	
	ПолеКартинкиПодписи = ПоместитьВоВременноеХранилище(КартинкаПодписи);
	
КонецФункции

&НаКлиенте
Процедура ПолеКартинкиПодписиНажатие(Элемент, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	СтруктураВозврат = ОткрытьФормуМодально("Справочник.Номенклатура.Форма.ФормаВыбораФайлаКартинки");
	Если СтруктураВозврат <> Неопределено
		И СтруктураВозврат.БылВыборФайла Тогда
		КартинкаПодписи = Новый Картинка(СтруктураВозврат.ИмяФайла);
	КонецЕсли;
    УстановитьКартинкуПодписи();
	
КонецПроцедуры

&НаСервере
Процедура ПередЗаписьюНаСервере(Отказ, ТекущийОбъект, ПараметрыЗаписи)
	
	ТекущийОбъект.Подпись = Новый ХранилищеЗначения(КартинкаПодписи, Новый СжатиеДанных(9));
	
КонецПроцедуры


&НаСервере
Процедура СделатьНомерОсновнымНаСервере(Привязка, Назначение, Номер)
	
	ТелефоннаяКнига.СделатьОсновным(Номер, Назначение, Привязка);
	
	Элементы.Симкарты.Обновить();
	
КонецПроцедуры

&НаКлиенте
Процедура СделатьНомерОсновным(Команда)
	
	Перем ТекДанные;
	
	ТекДанные = Элементы.Симкарты.ТекущиеДанные;
	Если ТекДанные = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	//
	СделатьНомерОсновнымНаСервере(ТекДанные.Привязка, ТекДанные.Назначение, ТекДанные.Номер);
	Оповестить("Изменена привязка номера");
	
КонецПроцедуры

&НаКлиенте
Процедура СимкартыВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	ПараметрыФормы = Новый Структура("Ключ", Элемент.ТекущиеДанные.Номер);
	ФормаСимКарты = ПолучитьФорму("Справочник.СлужебныеSIMКарты.ФормаОбъекта", ПараметрыФормы); 
	Если ФормаСимКарты.Открыта() Тогда
		ФормаСимКарты.Активизировать();
	Иначе
		ФормаСимКарты.Открыть();
	КонецЕсли;
	
КонецПроцедуры


&НаКлиенте
Процедура ПоказатьКодДоступа(Команда)

	КодДоступа = ФизическиеЛицаДополнительный.КодДоступаФизлицаПоКоду(Объект.Код);
	//КонтрольнаяСумма = 0;

	//Для Сч = 1 По СтрДлина(Объект.Код) Цикл
	//	КонтрольнаяСумма = КонтрольнаяСумма  + Сред(Объект.Код, Сч, 1);
	//КонецЦикла;

	//КодДоступа = Формат(Число(Объект.Код), "ЧГ=") + Прав(Формат(КонтрольнаяСумма, "ЧЦ=3; ЧВН=; ЧГ="), 2);

	Предупреждение("Код доступа в МП: " + КодДоступа);

КонецПроцедуры

//+++АК mika 2018.10.11 ИП-00019964
&НаКлиенте
Процедура КомандаОбновитьГруппуСотрудниковВТабеле(Команда)
	
	Если ЭтаФорма.Модифицированность Тогда
		ПоказатьПредупреждение(,"Есть несохраненные данные! Запишите элемент справочника перед обновлением Группы сотрудника!");
		Возврат;
	КонецЕсли;
	
	СтрокаУведомления = "";
	
	ОбновитьГруппуСотрудниковВТабелеСервер(Объект.Ссылка, Объект.ПомощникТУ, СтрокаУведомления);
	
	Если ЗначениеЗаполнено(СтрокаУведомления) Тогда
		ПоказатьПредупреждение(,СтрокаУведомления,15);
	КонецЕсли;
	
КонецПроцедуры
//---АК mika

////////////////////////////////////////////////////////////////////////////////
// СЛУЖЕБНЫЕ ПРОЦЕДУРЫ И ФУНКЦИИ

//Процедура проверяет возможность изменения помощника управляющего.
//Описание:
//Передать своего сотрудника в подчинение другому помощнику, может только текущий "Помощник ТУ"
//по предварительной договоренности. 
//После окончания "договоренности" временный "Помощник ТУ должен "вернуть" сотрудника, указав в 
//карточке физ. лица основного "Помощника ТУ".
Процедура ОбновитьВозможностьРедактированияПомощниковТУ() 
	
	//+++АК mika 2018.01.31 ИП-00016863.03
	//Попросили дать возможность редактирования устанавливать Помощников ТУ любому помощнику ТУ
	//Если ЗначениеЗаполнено(Объект.ПомощникТУ) Тогда
	//	Элементы.ПомощникТУ.ТолькоПросмотр = Объект.ПомощникТУ <> ПараметрыСеанса.ТекущийПользователь.ФизЛицо;
	//Иначе
	//	Элементы.ПомощникТУ.ТолькоПросмотр = Ложь;
	//КонецЕсли;
	Если ЗначениеЗаполнено(Объект.ПомощникТУ) И Элементы.ПомощникТУ.ТолькоПросмотр Тогда
		Элементы.ПомощникТУ.ТолькоПросмотр = Ложь;
	КонецЕсли;
	//---АК mika ИП-00016863.03

КонецПроцедуры

&НаКлиенте
Процедура ПомощникТУНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;

	Оповещение = Новый ОписаниеОповещения("ОбработатьВыбор", ЭтаФорма);

	ОткрытьФорму("Справочник.ФизическиеЛица.Форма.ФормаВыбораПомощников", Новый Структура("ЗакрыватьПриВыборе", Истина), Элементы.ПомощникТУ,,,,Оповещение);
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработатьВыбор (Результат, ДополнительныеПараметры) Экспорт
	
	Если Результат <> Неопределено Тогда
		Объект.ПомощникТУ = Результат.ПомощникТУ;
		ЭтаФорма.Модифицированность = Истина;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПомощникТУАвтоПодбор(Элемент, Текст, ДанныеВыбора, ПараметрыПолученияДанных, Ожидание, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;

	ПолучитьПомощникТУПоЧастиТекста(Текст);
	
КонецПроцедуры

&НаКлиенте
Функция ПолучитьПомощникТУПоЧастиТекста(Текст)
	
    Возврат ПолучитьДанныеВыбора(Тип("СправочникСсылка.ФизическиеЛица"),Новый Структура("ВариантПодбора, ТекстПоиска", "ПодборПомощниковТУ", Текст));
	
КонецФункции

//+++АК SHEP 2017.11.27 ИП-00017310
&НаКлиенте
Процедура СгенерироватьПароль(Команда)
	
	Объект.КабинетРассылкиПароль = СгенерироватьПарольНаСервере();
    
КонецПроцедуры

//+++АК SHEP 2017.11.27 ИП-00017310
&НаСервереБезКонтекста
Функция СгенерироватьПарольНаСервере()
	
	МинимальнаяДлинаПароля = Макс(8, ПолучитьМинимальнуюДлинуПаролейПользователей());
    ПараметрыПароля = ПользователиПолныеПрава.ПараметрыПароля(МинимальнаяДлинаПароля, Истина);
    Возврат ПользователиПолныеПрава.СоздатьПароль(ПараметрыПароля);
    
КонецФункции

//+++АК LAGP 2017.12.15 ИП-00017446 Открываем определенные строки по доп.праву
&НаСервере
Процедура ИзменитьДоступностьЭлементовФормыПоДопПраву(СтрокаДопПраво, Доступность)
	
	Если Доступность = Ложь И РольДоступна("ПолныеПрава") Тогда
		Возврат;	
	КонецЕсли;	
	
	МассивРазрешенныхГрупп = Новый Массив;
	МассивРазрешенныхЭлементов = Новый Массив;
	
	Если СтрокаДопПраво = "Редактирование основной информации физ лица" Тогда	
		МассивРазрешенныхГрупп.Добавить("ГруппаРуководитель");
		МассивРазрешенныхГрупп.Добавить("СтраницаКонтактнаяИнформация");
			
		МассивРазрешенныхЭлементов.Добавить("Активный");
		МассивРазрешенныхЭлементов.Добавить("Стажер");
		МассивРазрешенныхЭлементов.Добавить("Промоутер");
		МассивРазрешенныхЭлементов.Добавить("ВнештатныйСотрудник");
		МассивРазрешенныхЭлементов.Добавить("ДатаОкончанияДействияАнализовПоМедКнижке");
		МассивРазрешенныхЭлементов.Добавить("ДатаОкончанияДействияАнализовПоМедКнижке");
		МассивРазрешенныхЭлементов.Добавить("ФормаЗаписать");
		МассивРазрешенныхЭлементов.Добавить("ФормаЗаписатьИЗакрыть");
	КонецЕсли;	
	
	//+++АК PISH 2018.10.08 ИП-00019949 
	МожноРедактироватьТелефон = МожноРедактироватьТелефон();	
	//---АК PISH

		                                          
	Для каждого ЭлементМассиваРазрешенныхГрупп Из МассивРазрешенныхГрупп Цикл
		Для каждого ПодчинённыйЭлемент Из ЭтаФорма.Элементы[ЭлементМассиваРазрешенныхГрупп].ПодчиненныеЭлементы Цикл
			Попытка
				ПодчинённыйЭлемент.Доступность = Доступность;
				//+++АК PISH 2018.10.08 ИП-00019949
				Если ПодчинённыйЭлемент.Имя = ИмяРеквизитаТелефонСотрудника и МожноРедактироватьТелефон Тогда 
					ПодчинённыйЭлемент.Доступность = Истина;
				КонецЕсли;				
				//---АК PISH
				
			Исключение
			КонецПопытки;
		КонецЦикла;	
	КонецЦикла;
	
	Для каждого ЭлементМассиваРазрешенныхЭлементов Из МассивРазрешенныхЭлементов Цикл
		Попытка  
			ЭтаФорма.Элементы[ЭлементМассиваРазрешенныхЭлементов].Доступность = Доступность;	
		Исключение
		КонецПопытки;	
	КонецЦикла;
	
	//+++АК PISH 2018.10.08 ИП-00019949
	Если МожноРедактироватьТелефон и Не РольДоступна("ПолныеПрава") Тогда 
		Элементы.Наименование.ТолькоПросмотр = Истина;
		Элементы.КнопкаСменаФИО.Доступность = Ложь;
		Элементы.ГруппаПройденныеТренинги.ТолькоПросмотр = Истина;
		Для Каждого Эл Из ЭтаФорма.Элементы.СтраницаОбщие.ПодчиненныеЭлементы Цикл 
			Эл.ТолькоПросмотр = Истина;
		КонецЦикла;		
		ЭтаФорма.Элементы.ФормаЗаписать.Доступность = Истина;
		ЭтаФорма.Элементы.ФормаЗаписатьИЗакрыть.Доступность = Истина;
		ЭтаФорма.ТолькоПросмотр = Ложь;
	КонецЕсли;	
	//---АК PISH
		
КонецПроцедуры	


	//+++АК POZM 2018.04.26 ИП-00018136
&НаКлиенте
Процедура Стажёры(Команда)
	ОткрытьФорму("РегистрСведений.СтажерыПредприятия.ФормаСписка",Новый Структура("Отбор",Новый Структура("Наставник",Объект.Ссылка)));
КонецПроцедуры
//---АК POZM 

//+++АК ILIK 2018.07.05 ИП-00019161.01
&НаСервере
Процедура ОбработкаПроверкиЗаполненияНаСервере(Отказ, ПроверяемыеРеквизиты)
	Если ЗначениеЗаполнено(Объект.ДатаРождения) Тогда
		ПолныхЛет = 0;
		ОбщегоНазначения.РазобратьРазностьДат(ТекущаяДата(), Объект.ДатаРождения, ПолныхЛет);
		Если ПолныхЛет >= 100 Тогда
			Сообщить("Возраст физлица превышает 100 лет!");
			Отказ = Истина;
		КонецЕсли;
	КонецЕсли;
	
	//+++АК mika 2018.10.08 ИП-00019848
	Если Объект.СотрудникТилси И Объект.Промоутер Тогда
		Сообщить(НСтр("ru = '""Промоутер"" не может одновременно являться сотрудником ""Тилси""(проверьте коректность установленных признаков)!';"));
		Отказ = Истина;
	ИначеЕсли Объект.СотрудникТилси	Тогда
		ПроверитьНаличиеСотрудниковВДругихОрганизациях(Объект.Ссылка, Отказ);
	КонецЕсли;
	//---АК mika
	
КонецПроцедуры

//+++АК PISH 2018.10.08 ИП-00019949 
&НаСервереБезКонтекста
Функция МожноРедактироватьТелефон()
	
	Возврат РольДоступна("РедактированиеТелефонаВКарточкеФизЛица");
	
КонецФункции
	//---АК PISH
	
//+++АК PISH 2018.10.17 ИП-00019935
&НаСервере
Процедура ЗаполнитьДанныеОПрохожденииЧекапов()
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
	"ВЫБРАТЬ ПЕРВЫЕ 1
	|	Чекапы.ПрошелЧекап,
	|	Чекапы.ДатаПрохождения,
	|	Чекапы.Статус,
	|	Чекапы.ДатаЗаявки КАК ДатаЗаявки
	|ИЗ
	|	РегистрСведений.Чекапы КАК Чекапы
	|ГДЕ
	|	Чекапы.ФИЗЛицо = &ФИЗЛицо
	|
	|УПОРЯДОЧИТЬ ПО
	|	ДатаЗаявки УБЫВ";
	
	Запрос.УстановитьПараметр("ФИЗЛицо", Объект.Ссылка);
	
	РезультатЗапроса = Запрос.Выполнить();
	
	ВыборкаДетальныеЗаписи = РезультатЗапроса.Выбрать();
	
	Если  ВыборкаДетальныеЗаписи.Следующий() Тогда 
		ДатаПрохожденияЧекапа 	= ВыборкаДетальныеЗаписи.ДатаПрохождения;
		ДатаЗаявкиНаЧекап 		= ВыборкаДетальныеЗаписи.ДатаЗаявки;
		СтатусЧекапа 			= ВыборкаДетальныеЗаписи.Статус;
		ПрошелЧекап 			= ВыборкаДетальныеЗаписи.ПрошелЧекап;
	КонецЕсли;;
	
КонецПроцедуры

//---АК PISH

// Выполняниет вызов процедуры обновдения группы сотрудников //+++АК mika 2018.10.11 ИП-00019964 
//
// Параметры:
//  Сотрудник  - <Тип.СправочникСсылка.ФизическиеЛица> - Сотрудник для контроля запланированных выходов
//  ПомощникТУ  - <Тип.СправочникСсылка.ФизическиеЛица> - Помощник ТУ
//  СтрокаУведомления - <Тип.Строка> - Строка уведомления
//
Процедура ОбновитьГруппуСотрудниковВТабелеСервер(Сотрудник, ПомощникТУ, СтрокаУведомления) 

	ПостроениеГрафиковСервер.ОбновитьГруппуСотрудникаПоНовомуПомощнику(,,Сотрудник,ПомощникТУ,,СтрокаУведомления);
	

КонецПроцедуры // ОбновитьГруппуСотрудниковВТабелеСервер(Объект.Ссылка, Объект.ПомощникТУ, СтрокаУведомления)()

// Проверяет наличие "работающих" сотрудников в других огранизациях /+++АК mika 2018.10.08 ИП-00019848
// "Работающим" сотрудник считается, если дата увольнения не заполнена, или больше текущей даты 
//
// Параметры:
//  ФизЛицо  - <Тип.СправочникСсылка.ФизическиеЛица> - Сотрудник для контроля запланированных выходов
//  Отказ  - <Тип.Булево> - Признак отказа
//
Процедура ПроверитьНаличиеСотрудниковВДругихОрганизациях(ФизЛицо, Отказ)

	Если НЕ ЗначениеЗаполнено(ФизЛицо) Тогда
		Возврат;
	КонецЕсли;
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
	"ВЫБРАТЬ РАЗРЕШЕННЫЕ
	|	СотрудникиОрганизаций.Физлицо.Код КАК КодФизлицо,
	|	СотрудникиОрганизаций.Физлицо КАК Физлицо,
	|	СотрудникиОрганизаций.Код КАК КодСотрудник,
	|	СотрудникиОрганизаций.Ссылка КАК Сотрудник,
	|	СотрудникиОрганизаций.Организация,
	|	СотрудникиОрганизаций.ДатаПриемаНаРаботу КАК ДатаПриемаНаРаботу,
	|	СотрудникиОрганизаций.ДатаУвольнения
	|ИЗ
	|	Справочник.СотрудникиОрганизаций КАК СотрудникиОрганизаций
	|ГДЕ
	|	СотрудникиОрганизаций.Физлицо = &ФизЛицо
	|	И НЕ СотрудникиОрганизаций.ПометкаУдаления
	|	И СотрудникиОрганизаций.Организация.ИНН <> ""7734410589""
	|	И (СотрудникиОрганизаций.ДатаУвольнения = ДАТАВРЕМЯ(1, 1, 1)
	|			ИЛИ СотрудникиОрганизаций.ДатаУвольнения > &ТекущаяДата)";
	
	Запрос.УстановитьПараметр("ТекущаяДата", ТекущаяДата());
	Запрос.УстановитьПараметр("ФизЛицо", ФизЛицо);
	
	РезультатЗапроса = Запрос.Выполнить();
	
	Если НЕ РезультатЗапроса.Пустой() Тогда
		
		Выборка = РезультатЗапроса.Выбрать();
		
		СтрокаУведомления = "";
		ШаблонУведомления = "Код: %1, Сотрудник: %2, Организация: %3";
		
		Пока Выборка.Следующий() Цикл
			СтрокаУведомления = СтрокаУведомления + СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(ШаблонУведомления, СокрЛП(Выборка.КодСотрудник), СокрЛП(Выборка.Физлицо), Выборка.Организация) + Символы.ПС;  
		КонецЦикла;
		
		Если ЗначениеЗаполнено(СтрокаУведомления) Тогда
			Сообщить(СтрЗаменить("У текущего физ. лица есть работающие сотрудники по другим организациям! 
			        |Проверьте корректность ведения кадрового учета:
					|СтрокаУведомления", "СтрокаУведомления",СтрокаУведомления));
			Отказ = Истина;
		КонецЕсли;
		
	КонецЕсли;

КонецПроцедуры // ПроверитьНаличиеСотрудниковВДругихОрганизациях()

