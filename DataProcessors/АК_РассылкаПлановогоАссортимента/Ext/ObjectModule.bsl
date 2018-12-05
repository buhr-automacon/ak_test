﻿

//Выполнение рассылок по Планируемому запуску
// и Плана ассортимента на следующий месяц.

Процедура ВыполнитьПолнуюРассылку() Экспорт
	
	СтруктураНастройки = ПрочитатьПараметрыИзКонстанты();
	
	ВыполнитьРассылкуПланируемогоЗапуска(СтруктураНастройки);
	
	ВыполнитьРассылкуПлановогоАссортимента(СтруктураНастройки);
	
	СохранитьПараметрыВКонстанту(СтруктураНастройки);
	
КонецПроцедуры

// Чтение структуры параметров из константы
// АК_НастройкаРассылкиПлановогоАссортимента
Функция ПрочитатьПараметрыИзКонстанты() Экспорт
	
	СтруктураНастройки = ПолучитьПустуюСтруктуруНастроек();
	
	ЗначениеКонстанты = Константы.АК_НастройкаРассылкиПлановогоАссортимента.Получить().Получить();
	
	Если ТипЗнч(ЗначениеКонстанты) = Тип("Структура") тогда
		
		ЗаполнитьЗначенияСвойств(СтруктураНастройки, ЗначениеКонстанты);
		
		Если НЕ ЗначениеКонстанты.Свойство("МассивЛог", СтруктураНастройки.МассивЛог) Тогда
			
			СтруктураНастройки.Вставить("МассивЛог" , Новый Массив);
			
		КонецЕсли; 
		
	КонецЕсли;
	
	Возврат СтруктураНастройки;
	
КонецФункции

// Запись настроек рассылки в константу
// АК_НастройкаРассылкиПлановогоАссортимента
Процедура СохранитьПараметрыВКонстанту(ТекущийОбъект) Экспорт
	
	ЗначениеКонстанты = ПолучитьПустуюСтруктуруНастроек();
	
	ЗаполнитьЗначенияСвойств(ЗначениеКонстанты, ТекущийОбъект);
	
	ЗначениеКонстанты.Вставить("МассивЛог", ТекущийОбъект.МассивЛог);
	
	Пока ЗначениеКонстанты.МассивЛог.Количество() > 20 Цикл
		ЗначениеКонстанты.МассивЛог.Удалить(0);
	КонецЦикла; 
	
	Константы.АК_НастройкаРассылкиПлановогоАссортимента.Установить(Новый ХранилищеЗначения(ЗначениеКонстанты));
	
КонецПроцедуры

Функция ПолучитьПустуюСтруктуруНастроек()
	
	СтруктураНастройки = Новый структура;
	СтруктураНастройки.Вставить("ДнейРассылкиПлана",5);
	
	СтруктураНастройки.Вставить("УчетнаяЗаписьОтправителя");
	СтруктураНастройки.Вставить("ПочтаКонтролера");
	
	СтруктураНастройки.Вставить("МассивЛог" , Новый Массив);
	
	
	Возврат СтруктураНастройки;
	
КонецФункции


// формирование и рассылка писем по ассортименту запуск которого планируется через неделю

Процедура ВыполнитьРассылкуПланируемогоЗапуска(СтруктураРассылки)
	
	НачалоПериода = НачалоДня(ТекущаяДата()+7*86400);
	КонецПериода = КонецДня(НачалоПериода);
	
	СформироватьСтруктуруДляРассылки(НачалоПериода, КонецПериода, СтруктураРассылки);
	
	
КонецПроцедуры


Процедура ВыполнитьРассылкуПлановогоАссортимента(СтруктураРассылки) 
	
	ДнейДоКонцаМесяца = цел((КонецМесяца(ТекущаяДата())  - КонецДня(ТекущаяДата() ) ) / 86400);
	
	Если ДнейДоКонцаМесяца <> СтруктураРассылки.ДнейРассылкиПлана Тогда
		Возврат;
	КонецЕсли; 
	
	НачалоПериода = КонецМесяца(ТекущаяДата()) +1;
	КонецПериода = КонецМесяца((НачалоПериода));
	
	СформироватьСтруктуруДляРассылки(НачалоПериода, КонецПериода, СтруктураРассылки);
	
КонецПроцедуры


Процедура СформироватьСтруктуруДляРассылки(НачалоПериода, КонецПериода, СтруктураРассылки)
	
	СписокРассылки = Новый ТаблицаЗначений;
	СписокРассылки.Колонки.Добавить("Получатель");
	СписокРассылки.Колонки.Добавить("Адрес");
	СписокРассылки.Колонки.Добавить("ИмяСписка");
	СписокРассылки.Колонки.Добавить("Роль");
	СписокРассылки.Колонки.Добавить("ТабДок");
	
	
	СтруктураРассылки.вставить("ТекущийЛог", "");
	СтруктураРассылки.вставить("СписокРассылки", СписокРассылки);
	СтруктураРассылки.Вставить("НачалоПериода", НачалоПериода);
	СтруктураРассылки.Вставить("КонецПериода", КонецПериода);
	
	СтруктураРассылки.ТекущийЛог = "Рассылка за период "+Формат(НачалоПериода, "ДФ=dd.MM.yyyy") +" - " + Формат(КонецПериода, "ДФ=dd.MM.yyyy")+ 
			". Сформирована " + строка(ТекущаяДата()) + Символы.ПС;
	
	
	Запрос = Новый запрос;
	Запрос.Текст =  "ВЫБРАТЬ
	                |	ПлановыйАссортимент.Ссылка,
	                |	ПлановыйАссортимент.Наименование КАК Наименование
	                |ИЗ
	                |	Справочник.ПлановыйАссортимент КАК ПлановыйАссортимент
	                |ГДЕ
	                |	ПлановыйАссортимент.ПлановаяДатаЗапуска МЕЖДУ &НачалоПериода И &КонецПериода
	                |	И НЕ ПлановыйАссортимент.ПометкаУдаления
	                |
	                |УПОРЯДОЧИТЬ ПО
	                |	Наименование";
					
	Запрос.УстановитьПараметр("НачалоПериода", НачалоПериода);
	Запрос.УстановитьПараметр("КонецПериода",  КонецПериода);
	СписокАсортимента = Запрос.Выполнить().Выгрузить();
	
	ИмяСпискаКонтролера = Неопределено;
	
	Для каждого Асортимент Из СписокАсортимента Цикл
		
		Если ЗначениеЗаполнено(СтруктураРассылки.ПочтаКонтролера) Тогда
			// добавление Асортимента в список контролера
			ДобавитьАсортиментВСписок(СтруктураРассылки, Асортимент.Ссылка, СтруктураРассылки.ПочтаКонтролера, "Контролер");
			
			Если ИмяСпискаКонтролера = Неопределено Тогда
				СтрокаКонтролера = СтруктураРассылки.СписокРассылки.Найти(СтруктураРассылки.ПочтаКонтролера, "Получатель");
				ИмяСпискаКонтролера = СтрокаКонтролера.ИмяСписка;
				
				СтруктураРассылки [ИмяСпискаКонтролера].Колонки.Добавить("ПолучательТехнолог");
				СтруктураРассылки [ИмяСпискаКонтролера].Колонки.Добавить("ПолучательПродакт");
			КонецЕсли; 
		КонецЕсли; 
		
		ПолучательТехнолог = "";
		ПолучательПродакт = "";
		
		// добавление в рассылку Продакт-Менеджера
		Если ЗначениеЗаполнено(Асортимент.Ссылка.ПродактМенеджер) Тогда
			ДобавитьАсортиментВСписок(СтруктураРассылки, Асортимент.Ссылка, Асортимент.Ссылка.ПродактМенеджер, "Продакт");
			ПолучательПродакт = Строка(Асортимент.Ссылка.ПродактМенеджер);
		КонецЕсли; 
		
		// добавление в рассылку технологов по списку РолиТехнолога
		Если ЗначениеЗаполнено(Асортимент.Ссылка.РольТехнолога) Тогда
			РольТехнолога = Асортимент.Ссылка.РольТехнолога;
			Для каждого Технолог Из РольТехнолога.СоставРоли Цикл
				
				ДобавитьАсортиментВСписок(СтруктураРассылки, Асортимент.Ссылка, Технолог.Сотрудник, "Технолог");
				ПолучательТехнолог = ?(ЗначениеЗаполнено(ПолучательТехнолог),ПолучательТехнолог + Символы.ПС,"") + Строка(Технолог.Сотрудник);
				
			КонецЦикла; 
		КонецЕсли; 
		
		
		// заполнение в списке асортимента контролера полей получателей ответственных
		Если ИмяСпискаКонтролера <> Неопределено Тогда
			СтрокаРассылки = СтруктураРассылки [ИмяСпискаКонтролера] [СтруктураРассылки [ИмяСпискаКонтролера].Количество() -1] ;
			СтрокаРассылки.ПолучательТехнолог = ПолучательТехнолог;
			СтрокаРассылки.ПолучательПродакт = ПолучательПродакт;
		КонецЕсли;
		
	КонецЦикла; 
	
	// заполнение адреса получателя по списку
	СписокПолучателей = СтруктураРассылки.СписокРассылки.ВыгрузитьКолонку("Получатель");
	Запрос = Новый Запрос;
	Запрос.Текст = "ВЫБРАТЬ
	               |	КонтактнаяИнформация.Объект,
	               |	КонтактнаяИнформация.Тип,
	               |	КонтактнаяИнформация.Вид,
	               |	КонтактнаяИнформация.Представление
	               |ИЗ
	               |	РегистрСведений.КонтактнаяИнформация КАК КонтактнаяИнформация
	               |ГДЕ
	               |	КонтактнаяИнформация.Объект В(&СписокПолучатетлей)
	               |	И КонтактнаяИнформация.Тип = ЗНАЧЕНИЕ(Перечисление.ТипыКонтактнойИнформации.АдресЭлектроннойПочты)";
				   
				   
	Запрос.УстановитьПараметр("СписокПолучатетлей",СписокПолучателей);
	
	СписокАдресов = Запрос.Выполнить().Выгрузить();
	
	Для каждого Получатель Из СтруктураРассылки.СписокРассылки Цикл
		адрес = СписокАдресов.Найти(Получатель.Получатель);
		Если Адрес <> Неопределено Тогда
			Получатель.Адрес = Адрес.Представление;
		КонецЕсли; 
	КонецЦикла; 
	
	// формирование Табличных документов рассылки
	тема = "Рассылка по плановому ассортименту с датой запуска с " + Формат(СтруктураРассылки.НачалоПериода, "ДЛФ=D")+
		" по " + Формат(СтруктураРассылки.КонецПериода, "ДЛФ=D");
	СтруктураРассылки.Вставить("Тема", тема);
	
	Для каждого Получатель Из  СтруктураРассылки.СписокРассылки Цикл
		
		Если Получатель.Адрес = Неопределено Тогда
			Получатель.ТабДок = Неопределено;
			СтруктураРассылки.ТекущийЛог = СтруктураРассылки.ТекущийЛог + "Получатель " + Строка(Получатель.Получатель) + " почтовый адрес не задан." + символы.ПС;
		Иначе	
			
			СтруктураРассылки.ТекущийЛог = СтруктураРассылки.ТекущийЛог + "Получатель " + Строка(Получатель.Получатель) + " адрес отправки " + Получатель.Адрес;
			
			Если Получатель.Роль = "Контролер" тогда
				Получатель.ТабДок = ПолучитьТекстКонтролера(СтруктураРассылки, Получатель, Истина);
				
			Иначе
				Получатель.ТабДок = ПолучитьТекстКонтролера(СтруктураРассылки, Получатель, Ложь);
			КонецЕсли;
			
			Попытка
				ОтправитьПисьмомНаПочту(СтруктураРассылки, Получатель.ТабДок, Получатель.Адрес);
				
				СтруктураРассылки.ТекущийЛог = СтруктураРассылки.ТекущийЛог + ". Отправлено." + Символы.ПС;
				
			Исключение
				СтруктураРассылки.ТекущийЛог = СтруктураРассылки.ТекущийЛог + ". СБОЙ отправления письма." + Символы.ПС;
			КонецПопытки;
			
			
		КонецЕсли;
		
	КонецЦикла;
	
	Если СтруктураРассылки.СписокРассылки.Количество() = 0  Тогда
		СтруктураРассылки.ТекущийЛог = СтруктураРассылки.ТекущийЛог + "Информации для рассылки не обнаружено.";
	КонецЕсли; 
	
	СтруктураРассылки.МассивЛог.Добавить(СтруктураРассылки.ТекущийЛог);
	
	
КонецПроцедуры


Функция ПолучитьТабДокКонтролера(СтруктураРассылки, Получатель)
	
	Макет = Обработки.АК_РассылкаПлановогоАссортимента.ПолучитьМакет("МакетРассылки");
	
	ТабДок = Новый ТабличныйДокумент;
	
	ОблНачало 	= Макет.ПолучитьОбласть("Начало");
	ОблШапка 	= Макет.ПолучитьОбласть("Шапка1");
	ОблСтрока 	= Макет.ПолучитьОбласть("Строка1");
	
	ОблНачало.Параметры.Описание = "Рассылка сформирована по ассортименту с датой запуска с " + Формат(СтруктураРассылки.НачалоПериода, "ДЛФ=D")+
		" по " + Формат(СтруктураРассылки.КонецПериода, "ДЛФ=D");
	ТабДок.Вывести(ОблНачало);
	
	ТабДок.Вывести(ОблШапка);
	
	ИмяСписка = Получатель.ИмяСписка;
	
	Для каждого строка Из СтруктураРассылки [ИмяСписка] Цикл
		ОблСтрока.параметры.Наименование = строка.Асортимент.Наименование;
		ОблСтрока.Параметры.Номенклатура = Строка.Номенклатура.Наименование;
		
		ОблСтрока.Параметры.Выручка 	= Формат(Строка.Выручка, "ЧЦ=15; ЧДЦ=0"); 
		ОблСтрока.Параметры.ВыручкаТС 	= Формат(Строка.ВыручкаТС, "ЧЦ=15; ЧДЦ=0"); 
		ОблСтрока.Параметры.Количество 	= Формат(Строка.Количество, "ЧЦ=15; ЧДЦ=0"); 
		ОблСтрока.Параметры.КоличествоТС= Формат(Строка.КоличествоТС, "ЧЦ=15; ЧДЦ=0"); 
		
		ОблСтрока.Параметры.Розница		= Формат(Строка.Розница, "ЧЦ=15; ЧДЦ=2"); 
		ОблСтрока.Параметры.Закупка		= Формат(Строка.Закупка, "ЧЦ=15; ЧДЦ=2"); 
		ОблСтрока.Параметры.Маржа		= Формат(Строка.Маржа, "ЧЦ=15; ЧДЦ=2"); 
		
		ОблСтрока.Параметры.ДатаЗапуска =  Формат(Строка.ДатаЗапуска, "ДЛФ=D");
		
		ОблСтрока.Параметры.ПолучательТехнолог = Строка.ПолучательТехнолог;
		ОблСтрока.Параметры.ПолучательПродакт = Строка.ПолучательПродакт;
		
		ТабДок.Вывести(ОблСтрока);
	КонецЦикла; 
	
	// добавление в отчет список получателей без почтовых адресов
	СписокБезАдресов = СтруктураРассылки.СписокРассылки.НайтиСтроки(Новый Структура("Адрес", Неопределено));
	
	Если СписокБезАдресов.Количество() > 0 Тогда
		
		ОблШапка = Макет.ПолучитьОбласть("ШапкаАдрес");
		ОблСтрока = Макет.ПолучитьОбласть("СтрокаАдрес");
		ТабДок.Вывести(ОблШапка);
		
		Для каждого Строка Из СписокБезАдресов Цикл
			
			ОблСтрока.Параметры.Получатель = Строка(Строка.Получатель);
			ОблСтрока.Параметры.Роль = Строка.Роль;
			ТабДок.Вывести(ОблСтрока);
			
		КонецЦикла; 
	КонецЕсли; 
	
	Возврат ТабДок;
КонецФункции
 
Функция ПолучитьТабДокПолучателя(СтруктураРассылки, Получатель)
	
	Макет = Обработки.АК_РассылкаПлановогоАссортимента.ПолучитьМакет("МакетРассылки");
	
	ТабДок = Новый ТабличныйДокумент;
	
	ОблНачало 	= Макет.ПолучитьОбласть("Начало");
	ОблШапка 	= Макет.ПолучитьОбласть("Шапка2");
	ОблСтрока 	= Макет.ПолучитьОбласть("Строка2");
	
	ОблНачало.Параметры.Описание = "Рассылка сформирована по ассортименту с датой запуска с " + Формат(СтруктураРассылки.НачалоПериода, "ДЛФ=D")+
		" по " + Формат(СтруктураРассылки.КонецПериода, "ДЛФ=D");
	
	ТабДок.Вывести(ОблНачало);
	
	ТабДок.Вывести(ОблШапка);
	
	ИмяСписка = Получатель.ИмяСписка;
	
	Для каждого строка Из СтруктураРассылки [ИмяСписка] Цикл
		ОблСтрока.параметры.Наименование = строка.Асортимент.Наименование;
		ОблСтрока.Параметры.Номенклатура = Строка.Номенклатура.Наименование;
		
		ОблСтрока.Параметры.Выручка 	= Формат(Строка.Выручка, "ЧЦ=15; ЧДЦ=0"); 
		ОблСтрока.Параметры.ВыручкаТС 	= Формат(Строка.ВыручкаТС, "ЧЦ=15; ЧДЦ=0"); 
		ОблСтрока.Параметры.Количество 	= Формат(Строка.Количество, "ЧЦ=15; ЧДЦ=0"); 
		ОблСтрока.Параметры.КоличествоТС= Формат(Строка.КоличествоТС, "ЧЦ=15; ЧДЦ=0"); 
		
		ОблСтрока.Параметры.Розница		= Формат(Строка.Розница, "ЧЦ=15; ЧДЦ=2"); 
		ОблСтрока.Параметры.Закупка		= Формат(Строка.Закупка, "ЧЦ=15; ЧДЦ=2"); 
		
		ОблСтрока.Параметры.ДатаЗапуска =  Формат(Строка.ДатаЗапуска, "ДЛФ=D");
		
		ТабДок.Вывести(ОблСтрока);
	КонецЦикла; 
	
	Возврат ТабДок;
КонецФункции

Функция ПолучитьТекстКонтролера(СтруктураРассылки, Получатель, ЭтоКонтролер)
	
	Тело = "<HTML><HEAD></HEAD><BODY> 
	| <META HTTP-EQUIV=""Content-Type"" CONTENT=""text/html; charset=windows-1251"">";
	
	Тело = Тело +  "<h3> Рассылка сформирована автоматически " + Формат(ТекущаяДата(), "ДЛФ=DDT")+ "</h3>"+ Символы.ПС + 
	"<h3>" + "По ассортименту с датой запуска с "+ Формат(СтруктураРассылки.НачалоПериода, "ДЛФ=D")+
		" по " + Формат(СтруктураРассылки.КонецПериода, "ДЛФ=D")+"</h3>";
		

	ИтогШирины = 0;
	СтрокаЗаголовок = "";
	
	ДобавитьОписаниеКолонки(СтрокаЗаголовок, "Наимменование", 300, ИтогШирины);
	ДобавитьОписаниеКолонки(СтрокаЗаголовок, "Номенклатура", 300, ИтогШирины);
	ДобавитьОписаниеКолонки(СтрокаЗаголовок, "Розница", 100, ИтогШирины);
	ДобавитьОписаниеКолонки(СтрокаЗаголовок, "Закупка", 100, ИтогШирины);
	
	ДобавитьОписаниеКолонки(СтрокаЗаголовок, "Количество, шт.на 1 ВВ в неделю", 100, ИтогШирины);
	ДобавитьОписаниеКолонки(СтрокаЗаголовок, "Выручка, руб.на 1 ВВ в неделю", 100, ИтогШирины);
	ДобавитьОписаниеКолонки(СтрокаЗаголовок, "Маржа, руб.на 1 ВВ в неделю", 100, ИтогШирины);
	
	ДобавитьОписаниеКолонки(СтрокаЗаголовок, "Количество, шт.на торг.сеть в неделю", 100, ИтогШирины);
	ДобавитьОписаниеКолонки(СтрокаЗаголовок, "Выручка, руб.на торг.сеть в неделю", 100, ИтогШирины);
	ДобавитьОписаниеКолонки(СтрокаЗаголовок, "Маржа, руб.на торг.сеть в неделю", 100, ИтогШирины);
	
	ДобавитьОписаниеКолонки(СтрокаЗаголовок, "Дата запуска", 100, ИтогШирины);
	
	Если ЭтоКонтролер Тогда
		ДобавитьОписаниеКолонки(СтрокаЗаголовок, "Получатель технолог", 250, ИтогШирины);
		ДобавитьОписаниеКолонки(СтрокаЗаголовок, "Получатель продакт", 250, ИтогШирины);
	КонецЕсли; 
	
	Тело = Тело + Символы.ПС + "<table border='1' width = """+ Формат(ИтогШирины, "Л=; ЧГ=") + """>" + СтрокаЗаголовок;
	
	ИмяСписка = Получатель.ИмяСписка;
	
	Для каждого строка Из СтруктураРассылки [ИмяСписка] Цикл
		Тело = Тело + "<tr>";
		
		Тело = Тело + "<td>"+ строка.Асортимент.Наименование 			+"</td>";
		Тело = Тело + "<td>"+ Строка.Номенклатура.Наименование 			+"</td>";
		Тело = Тело + "<td align = ""right"">"+ Формат(Строка.Розница, "ЧЦ=15; ЧДЦ=0")	+"</td>"; 
		Тело = Тело + "<td align = ""right"">"+ Формат(Строка.Закупка, "ЧЦ=15; ЧДЦ=0") 	+"</td>";
		Тело = Тело + "<td align = ""right"">"+ Формат(Строка.Количество, "ЧЦ=15; ЧДЦ=0")	+"</td>";
		Тело = Тело + "<td align = ""right"">"+ Формат(Строка.Выручка, "ЧЦ=15; ЧДЦ=0") 	+"</td>";
		Тело = Тело + "<td align = ""right"">"+ Формат(Строка.Маржа, "ЧЦ=15; ЧДЦ=0") 		+"</td>";
		Тело = Тело + "<td align = ""right"">"+ Формат(Строка.КоличествоТС,"ЧЦ=15; ЧДЦ=0")+"</td>";
		Тело = Тело + "<td align = ""right"">"+ Формат(Строка.ВыручкаТС, "ЧЦ=15; ЧДЦ=0") 	+"</td>";
		Тело = Тело + "<td align = ""right"">"+ Формат(Строка.МаржаТС, "ЧЦ=15; ЧДЦ=0") 	+"</td>";
		Тело = Тело + "<td align = ""right"">"+ Формат(Строка.ДатаЗапуска, "ДЛФ=D") 		+"</td>";
		
		Если ЭтоКонтролер Тогда
			Тело = Тело + "<td>"+ Строка.ПолучательТехнолог 				+"</td>";
			Тело = Тело + "<td>"+ Строка.ПолучательПродакт 					+"</td>";
		КонецЕсли;	
		Тело = Тело + Символы.ПС + "</tr>";
		
	КонецЦикла; 
	
	СтруктураРассылки.ТекущийЛог = СтруктураРассылки.ТекущийЛог + ". Количество строк " + Строка(СтруктураРассылки [ИмяСписка].Количество());

	
	Тело = Тело + Символы.ПС + "</table>" + Символы.ПС;
	
	// добавление в отчет список получателей без почтовых адресов
	СписокБезАдресов = СтруктураРассылки.СписокРассылки.НайтиСтроки(Новый Структура("Адрес", Неопределено));
	
	Если СписокБезАдресов.Количество() > 0  и ЭтоКонтролер Тогда
		
		//ОблШапка = Макет.ПолучитьОбласть("ШапкаАдрес");
		//ОблСтрока = Макет.ПолучитьОбласть("СтрокаАдрес");
		//ТабДок.Вывести(ОблШапка);
		
		Тело = Тело + Символы.ПС + " <h3>"+символы.ПС+"Список получателей рассылки у которых не заполнен адрес электронной почты в справочнике физических лиц. </h3>";
			
		ИтогШирины = 0;
		СтрокаЗаголовок = "";
		
		ДобавитьОписаниеКолонки(СтрокаЗаголовок, "Получатель",	300, ИтогШирины);
		ДобавитьОписаниеКолонки(СтрокаЗаголовок, "Роль",		150, ИтогШирины);
		
		Тело = Тело + Символы.ПС + "<table border='1' width = """+ Формат(ИтогШирины, "Л=; ЧГ=") + """>" + СтрокаЗаголовок;
		
		Для каждого Строка Из СписокБезАдресов Цикл
			
			Тело = Тело + "<tr>";
			
			Тело = Тело + "<td>"+ Строка(Строка.Получатель)	+"</td>";
			Тело = Тело + "<td align = ""center"">"+ Строка.Роль +"</td>";
			
			Тело = Тело + Символы.ПС + "</tr>";
			
		КонецЦикла; 
		Тело = Тело + Символы.ПС + "</table>" + Символы.ПС;
		
	КонецЕсли; 
	
	Тело = Тело + Символы.ПС+ "</BODY></HTML>";
	
	Возврат Тело;
		
КонецФункции
 
Процедура ДобавитьОписаниеКолонки(ТелоСтрока, НаименованиеКолонки, ШиринаКолонки = 50, ИтогШирины)
	
	ТелоСтрока = ТелоСтрока + "<th align = ""center"" width = """+ Формат(ШиринаКолонки, "Л=; ЧГ=") + """>"+НаименованиеКолонки+"</th>";
	
	ИтогШирины = ИтогШирины + ШиринаКолонки;
	
КонецПроцедуры
 


Процедура ДобавитьАсортиментВСписок(СтруктураРассылки, Асортимент, Получатель, Роль)
	
	СтрокаСписка = СтруктураРассылки.СписокРассылки.Найти(Получатель, "Получатель");
	
	Если СтрокаСписка = Неопределено Тогда
		
		ТаблицаРассылки = Новый ТаблицаЗначений;
		ТаблицаРассылки.Колонки.Добавить("Асортимент");
		ТаблицаРассылки.Колонки.Добавить("Номенклатура");
		ТаблицаРассылки.Колонки.Добавить("Количество");
		ТаблицаРассылки.Колонки.Добавить("КоличествоТС");
		ТаблицаРассылки.Колонки.Добавить("Выручка");
		ТаблицаРассылки.Колонки.Добавить("ВыручкаТС");
		ТаблицаРассылки.Колонки.Добавить("ДатаЗапуска");
		ТаблицаРассылки.Колонки.Добавить("Розница");
		ТаблицаРассылки.Колонки.Добавить("Закупка");
		ТаблицаРассылки.Колонки.Добавить("Маржа");
		ТаблицаРассылки.Колонки.Добавить("МаржаТС");
		
		СтрокаПолучателя = СтруктураРассылки.СписокРассылки.добавить();
		СтрокаПолучателя.Получатель = Получатель;
		СтрокаПолучателя.Роль = роль;
		
		ИмяСписка = "Список" + Формат(СтруктураРассылки.СписокРассылки.Количество(),"ЧЦ=3; ЧВН=; ЧГ=");
		СтрокаПолучателя.ИмяСписка = ИмяСписка;
		
		СтруктураРассылки.Вставить(ИмяСписка, ТаблицаРассылки);
		
	Иначе 	
		ИмяСписка = СтрокаСписка.ИмяСписка;
	КонецЕсли;
	
	НоваяСтрока = СтруктураРассылки [ИмяСписка].Добавить();
	НоваяСтрока.Асортимент 		= Асортимент;
	НоваяСтрока.Номенклатура 	= Асортимент.Номенклатура;
	НоваяСтрока.Количество 		= Асортимент.ПродажиНаМагазинВДеньШтук * 7;  // на неделю
	НоваяСтрока.КоличествоТС 	= Асортимент.ПродажиНаСетьМагазиновШтук;
	НоваяСтрока.Выручка 		= Окр(Асортимент.ВыручкаВМесяцНаМагазин /30 *7, 2); // на неделю
	НоваяСтрока.ВыручкаТС 		= Асортимент.ВыручкаНаСетьМагазинов;
	НоваяСтрока.ДатаЗапуска		= Асортимент.ПлановаяДатаЗапуска;
	НоваяСтрока.Розница			= Асортимент.Розница;
	НоваяСтрока.Закупка			= Асортимент.Закупка;
	НоваяСтрока.МаржаТС			= Асортимент.МаржаПлановые400Магазинов;
	НоваяСтрока.Маржа			= Окр(Асортимент.МаржаВМесяцНаМагазин / 30 * 7, 2);// на неделю
	
КонецПроцедуры


Процедура ОтправитьПисьмомНаПочту(СтруктураРассылки, ТелоПисьма, АдресПолучателя)
	
	// адрес разработчика для теста
	//АдресПолучателя = "pavel71@list.ru";

	Тема = СтруктураРассылки.Тема;
	ТекстПисьма = "Рассылка сформирована автоматически " + Формат(ТекущаяДата(), "ДЛФ=DDT");
	
	Если ЗначениеЗаполнено(СтруктураРассылки.УчетнаяЗаписьОтправителя) Тогда
		УчетнаяЗапись = СтруктураРассылки.УчетнаяЗаписьОтправителя;
	иначе	
		УчетнаяЗапись = ОбщиеПроцедуры.ПолучитьУчетнуюЗаписьДляРассылки();
	КонецЕсли; 
	
	СпАдресов=Новый СписокЗначений;
	МассивАдресов=Справочники.Контрагенты.РазложитьСтрокуВМассивПодстрок(АдресПолучателя,";");	
	Для каждого Эл Из МассивАдресов Цикл
		Если ЗначениеЗаполнено(Эл) Тогда
			СпАдресов.Добавить(Сокрлп(Эл));
		КонецЕсли; 
	КонецЦикла; 
	
	Почта = Новый ИнтернетПочта;
	Профиль = УправлениеЭлектроннойПочтой.ПолучитьИнтернетПочтовыйПрофиль(УчетнаяЗапись);
	Письмо = Новый ИнтернетПочтовоеСообщение;
	
	Почта.Подключиться(Профиль);
	Письмо.ИмяОтправителя = ""+УчетнаяЗапись+"";
	Письмо.ИмяОтправителя  = ""+СокрЛП(УчетнаяЗапись)+"";
	Письмо.Отправитель     = ""+СокрЛП(УчетнаяЗапись)+"";
	
	Письмо.Тексты.Добавить(ТелоПисьма, ТипТекстаПочтовогоСообщения.HTML);
	
//	Письмо.Вложения.Добавить(АдресФайла);
	
	Письмо.Тема=Тема;
	
	Для каждого Адрес Из СпАдресов Цикл
		Получатель = Письмо.Получатели.Добавить();
		Получатель.Адрес           = Адрес.Значение;
	КонецЦикла;	
	
	Почта.Послать(Письмо);
	Сообщить("Отправлено письмо на "+АдресПолучателя);
	Почта.Отключиться();
	
КонецПроцедуры

Процедура ОтправитьФайломНаПочту(СтруктураРассылки, ТабДокВложения, АдресПолучателя)
	
	Если типЗнч(ТабДокВложения) <> Тип("ТабличныйДокумент") Тогда
		возврат;
	КонецЕсли; 
	
//	ТабДокВложения.Показать();
//	возврат;
	
	АдресФайла = ПолучитьИмяВременногоФайла("XLSX");
	
	попытка
		ТабДокВложения.Записать(АдресФайла, ТипФайлаТабличногоДокумента.XLSX);
	Исключение
		возврат;
	КонецПопытки;

	Тема = СтруктураРассылки.Тема;
	ТекстПисьма = "Рассылка сформирована автоматически " + Формат(ТекущаяДата(), "ДЛФ=DDT");
	
	Если ЗначениеЗаполнено(СтруктураРассылки.УчетнаяЗаписьОтправителя) Тогда
		УчетнаяЗапись = СтруктураРассылки.УчетнаяЗаписьОтправителя;
	иначе	
		УчетнаяЗапись = ОбщиеПроцедуры.ПолучитьУчетнуюЗаписьДляРассылки();
	КонецЕсли; 
	
	СпАдресов=Новый СписокЗначений;
	МассивАдресов=Справочники.Контрагенты.РазложитьСтрокуВМассивПодстрок(АдресПолучателя,";");	
	Для каждого Эл Из МассивАдресов Цикл
		Если ЗначениеЗаполнено(Эл) Тогда
			СпАдресов.Добавить(Сокрлп(Эл));
		КонецЕсли; 
	КонецЦикла; 
	
	Почта = Новый ИнтернетПочта;
	Профиль = УправлениеЭлектроннойПочтой.ПолучитьИнтернетПочтовыйПрофиль(УчетнаяЗапись);
	Письмо = Новый ИнтернетПочтовоеСообщение;
	
	Почта.Подключиться(Профиль);
	Письмо.ИмяОтправителя = ""+УчетнаяЗапись+"";
	Письмо.ИмяОтправителя  = ""+СокрЛП(УчетнаяЗапись)+"";
	Письмо.Отправитель     = ""+СокрЛП(УчетнаяЗапись)+"";
	
	Письмо.Тексты.Добавить(ТекстПисьма,ТипТекстаПочтовогоСообщения.ПростойТекст);
	
	Письмо.Вложения.Добавить(АдресФайла);
	
	Письмо.Тема=Тема;
	
	Для каждого Адрес Из СпАдресов Цикл
		Получатель = Письмо.Получатели.Добавить();
		Получатель.Адрес           = Адрес.Значение;
	КонецЦикла;	
	
	Почта.Послать(Письмо);
	Сообщить("Отправлено письмо на "+АдресПолучателя);
	Почта.Отключиться();
	
КонецПроцедуры
