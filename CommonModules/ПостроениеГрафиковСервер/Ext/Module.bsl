﻿
////////////////////////////////////////////////////////////////////////////////
// ПОДПИСКИ НА СОБЫТИЯ 

Процедура ТабельРаботыПередЗаписьюПередЗаписью(Источник, Отказ, Замещение) Экспорт
	
	//+++АК POZM 2018.09.21 ИП-00018201
	Если Источник.ОбменДанными.Загрузка = Истина Тогда
		Возврат;
	КонецЕсли;	
	//---АК POZM 
	
	СтруктураПараметров = Новый Структура("Уведомление","");
	
	Попытка 
		ПроверитьВозможностьИзмененияТабеляРабот(Источник.Отбор.Период.Значение, Отказ, СтруктураПараметров);
	Исключение
		ТекстУведомления = Строка(ТипЗнч(Источник)) + " 
		|" + СтруктураПараметров.Уведомление + "
		|" + ОписаниеОшибки();
		ЗаписьЖурналаРегистрации("Отладка.ТабельРабот.ОшибкаЗапретаРедактирования", УровеньЖурналаРегистрации.Ошибка, , , ТекстУведомления);
	КОнецПопытки;

КонецПроцедуры


////////////////////////////////////////////////////////////////////////////////
// КОНТРОЛЬ ВОЗМОЖНОСТИ РЕДАКТИРОВАНИЯ

// Предназначена для контроля возможности редактирования табелей работ //+++АК mika 2018.03.26 ИП-00018195
// Запрещено редактировать данные, которые отправлены на "расчет зароботной платы"
// 
// Помощники: Блокируется "прошлый период" каждого 2-го и 17 - го числа месяца (периоды расчета ЗП с 01-го по 15-е и с 15-го по "ПоследнийДеньМесяца")
// Продавцы: Блокируется "прошлый период" каждого 1-го и 16 - го числа месяца (периоды расчета ЗП с 01-го по 15-е и с 15-го по "ПоследнийДеньМесяца")
// "Управляющие": Блокируется если "прошлый период" меньше/равно Константы.ГраницаЗапретаРедактированияГрафикаПродавцов  
// Пользователи с "Полными" правами могут редактировать любой период.
//
// Параметры:
//  ТекущийПериод  - <Тип.Дата> - Период редактирования (дата)
//  СтруктураПараметров  - <Тип.Структура> - Структура дополнительных парметров
//                                           (ТекущийПользователь, ТекущийПродавец, ТекущаяДата) 
//  
//  Отказ  - <Тип.Булево> - Признак отказа
//
Процедура ПроверитьВозможностьИзмененияТабеляРабот(ТекущийПериод, Отказ, СтруктураПараметров = Неопределено) Экспорт

	Перем ТекущийПользователь;
	Перем ТекущийПродавец;
	Перем ТекущаяДата;
	Перем ТекстУведомления;

	Если НЕ ЗначениеЗаполнено(ТекущийПериод) Тогда
		Возврат;
	КонецЕсли;
	
	Если СтруктураПараметров = Неопределено Тогда
		СтруктураПараметров = Новый Структура();
		СтруктураПараметров.Вставить("Уведомление");
	КонецЕсли;
	
	СтруктураПараметров.Свойство("ТекущийПользователь", ТекущийПользователь);
	СтруктураПараметров.Свойство("ТекущийПродавец", ТекущийПродавец);
	СтруктураПараметров.Свойство("ТекущаяДата", ТекущаяДата);

	Запрос = Новый Запрос;
	Запрос.Текст = 
	"ВЫБРАТЬ РАЗРЕШЕННЫЕ РАЗЛИЧНЫЕ
	|	МАКСИМУМ(ТабИтоговая.ЭтоПолныеПрава) КАК ЭтоПолныеПрава,
	|	МАКСИМУМ(ТабИтоговая.ЭтоПродавец) КАК ЭтоПродавец,
	|	МАКСИМУМ(ТабИтоговая.ЭтоПомощник) КАК ЭтоПомощник,
	|	МАКСИМУМ(ТабИтоговая.ЭтоУправляющий) КАК ЭтоУправляющий
	|ИЗ
	|	(ВЫБРАТЬ
	|		ЛОЖЬ КАК ЭтоПолныеПрава,
	|		ЛОЖЬ КАК ЭтоПродавец,
	|		ВЫБОР
	|			КОГДА РолиПользователейТипыРолей.ТипРоли.Код = ""PomoshnikTerrUpravlyushego""
	//+++ AK suvv 2018.06.08 ИП-00018376.01
	|           ИЛИ РолиПользователейТипыРолей.ТипРоли.Код = ""PomoshnikStorRozn""
	//--- AK suvv
	|				ТОГДА ИСТИНА
	|			ИНАЧЕ ЛОЖЬ
	|		КОНЕЦ КАК ЭтоПомощник,
	|		ВЫБОР
	|			КОГДА РолиПользователейТипыРолей.ТипРоли.Код = ""UpravlyayushchiiPoRoznice""
	|				ТОГДА ИСТИНА
	|			ИНАЧЕ ЛОЖЬ
	|		КОНЕЦ КАК ЭтоУправляющий
	|	ИЗ
	|		Справочник.Пользователи КАК Пользователи
	|			ЛЕВОЕ СОЕДИНЕНИЕ Справочник.РолиПользователей.СоставРоли КАК РолиПользователейСоставРоли
	|				ЛЕВОЕ СОЕДИНЕНИЕ Справочник.РолиПользователей.ТипыРолей КАК РолиПользователейТипыРолей
	|				ПО РолиПользователейСоставРоли.Ссылка = РолиПользователейТипыРолей.Ссылка
	|					И (РолиПользователейТипыРолей.ТипРоли.Код = ""PomoshnikTerrUpravlyushego""
	//+++ AK suvv 2018.06.08 ИП-00018376.01
	|                       ИЛИ РолиПользователейТипыРолей.ТипРоли.Код = ""PomoshnikStorRozn""
	//--- AK suvv
	|						ИЛИ РолиПользователейТипыРолей.ТипРоли.Код = ""UpravlyayushchiiPoRoznice"")
	|			ПО Пользователи.ФизЛицо = РолиПользователейСоставРоли.Сотрудник
	|	ГДЕ
	|		(РолиПользователейТипыРолей.ТипРоли.Код = ""PomoshnikTerrUpravlyushego""
	//+++ AK suvv 2018.06.08 ИП-00018376.01
	|               ИЛИ РолиПользователейТипыРолей.ТипРоли.Код = ""PomoshnikStorRozn""
	//--- AK suvv
	|				ИЛИ РолиПользователейТипыРолей.ТипРоли.Код = ""UpravlyayushchiiPoRoznice"")
	|		И Пользователи.Ссылка = &Пользователь
	|	
	|	ОБЪЕДИНИТЬ ВСЕ
	|	
	|	ВЫБРАТЬ
	|		ЛОЖЬ,
	|		&ЭтоПродавец,
	|		ЛОЖЬ,
	|		ЛОЖЬ
	|	
	|	ОБЪЕДИНИТЬ ВСЕ
	|	
	|	ВЫБРАТЬ
	|		&ЭтоПолныеПрава,
	|		ЛОЖЬ,
	|		ЛОЖЬ,
	|		ЛОЖЬ) КАК ТабИтоговая";
	
	Попытка
		ТекущийПродавец = ПараметрыСеанса.ТекущийПродавец;
	Исключение
		ТекущийПродавец = Неопределено;
	КонецПопытки;
	
	Запрос.УстановитьПараметр("ЭтоПродавец", ЗначениеЗаполнено(ТекущийПродавец));
	Запрос.УстановитьПараметр("ЭтоПолныеПрава", РольДоступна("ПолныеПрава"));
	Запрос.УстановитьПараметр("Пользователь", ?(ЗначениеЗаполнено(ТекущийПользователь), ТекущийПользователь, ПараметрыСеанса.ТекущийПользователь));
	
	РезультатЗапроса = Запрос.Выполнить();
	
	Если Не РезультатЗапроса.Пустой() Тогда
		
		ДатаЗапрета = Константы.ГраницаЗапретаРедактированияГрафикаПродавцов.Получить();

		Выборка = РезультатЗапроса.Выбрать();
		
		СтруктураДоступа = Новый Структура();

		Пока Выборка.Следующий() Цикл		
			Для каждого Колонка Из РезультатЗапроса.Колонки Цикл
				СтруктураДоступа.Вставить(Колонка.Имя, Выборка[Колонка.Имя]);      
			КонецЦикла;
		КонецЦикла;
		
		СтруктураПараметров.Уведомление = "
		|Пользователь: " +  ?(ЗначениеЗаполнено(ТекущийПользователь), ТекущийПользователь, ПараметрыСеанса.ТекущийПользователь) + "
		|Это ЭтоПолныеПрава: " + СтруктураДоступа.ЭтоПолныеПрава + "
		|Это ЭтоУправляющий: " + СтруктураДоступа.ЭтоУправляющий + "
		|Это ЭтоПомощник: " + СтруктураДоступа.ЭтоПомощник + "
		|Это Продавец: " + СтруктураДоступа.ЭтоПродавец;
		
		//Не контролировать редактирование закрытых периодов для Управляющих и пользователей с полными правами
		Если СтруктураДоступа.ЭтоПолныеПрава Тогда
			Возврат;
		КонецЕсли;
		
		Если НЕ ЗначениеЗаполнено(ТекущаяДата) Тогда
			ТекущаяДата = ТекущаяДата();
		КонецЕсли;
		
		ТекстСообщения = "";
		
		Если СтруктураДоступа.ЭтоУправляющий И ТекущийПериод <= ДатаЗапрета Тогда
			
			//ДатаЗапрета устанавливается сотрудниками бухгалтерии через обработку «Расчет заработной платы продавцов».  
			ТекстСообщения = "Редактирование данных запрещено! Период ТекущийПериод закрыт для редактирования (обратитесь в отдел ""Бухгалтерии"").";
			
		ИначеЕсли СтруктураДоступа.ЭтоУправляющий И ТекущийПериод > ДатаЗапрета Тогда
			
			//(Доступный Управляющему период)ДатаЗапрета устанавливается сотрудниками бухгалтерии через обработку «Расчет заработной платы продавцов».   
			ТекстСообщения = "";
	
		ИначеЕсли СтруктураДоступа.ЭтоПродавец Тогда
			
			//Запрет активируется 1-го и 16-го числа
			Если (День(ТекущаяДата)>15 И День(ТекущийПериод)<16 И НачалоМесяца(ТекущийПериод)=НачалоМесяца(ТекущаяДата)) ИЛИ 
				(День(ТекущаяДата)>=1 И НачалоМесяца(ДобавитьМесяц(ТекущийПериод,1))= НачалоМесяца(ТекущаяДата)) ИЛИ
				НачалоМесяца(ДобавитьМесяц(ТекущийПериод,1))<НачалоМесяца(ТекущаяДата) Тогда
				ТекстСообщения = "Редактирование данных запрещено! Период ТекущийПериод отправлен на расчет заработной платы (обратитесь к помощнику магазина).";
			КонецЕсли; 
			
		ИначеЕсли СтруктураДоступа.ЭтоПомощник Тогда
			
			//Запрет активируется 2-го и 17-го числа
			Если (День(ТекущаяДата)>16 И День(ТекущийПериод)<16 И НачалоМесяца(ТекущийПериод)=НачалоМесяца(ТекущаяДата)) ИЛИ 
				(День(ТекущаяДата) > 1 И НачалоМесяца(ДобавитьМесяц(ТекущийПериод,1))= НачалоМесяца(ТекущаяДата)) ИЛИ
				НачалоМесяца(ДобавитьМесяц(ТекущийПериод,1))<НачалоМесяца(ТекущаяДата) Тогда
				ТекстСообщения = "Редактирование данных запрещено! Период ТекущийПериод отправлен на расчет заработной платы (обратитесь к управляющему магазина).";
			КонецЕсли; 
			
		ИначеЕсли НЕ СтруктураДоступа.ЭтоПродавец И НЕ СтруктураДоступа.ЭтоПомощник И НЕ СтруктураДоступа.ЭтоУправляющий Тогда
			ТекстСообщения = СтрЗаменить("Для пользователя ТекущийПользователь не установлены необходимые для работы с ""Графиками сотрудников"" роли/функциональные роли. 
						|Обратитесь в службу поддержки!", "ТекущийПользователь", ПараметрыСеанса.ТекущийПользователь);
		КонецЕсли;

		Если ЗначениеЗаполнено(ТекстСообщения) Тогда
			Отказ = Истина;
			Если СтруктураПараметров <> Неопределено И СтруктураПараметров.Свойство("БезУведомлений") Тогда
				Возврат;
			КонецЕсли;
			ТекстСообщения = СтрЗаменить(ТекстСообщения, "ТекущийПериод", Формат(ТекущийПериод,"ДФ=dd.MM.yyyy"));
			Сообщить(ТекстСообщения, СтатусСообщения.ОченьВажное);
		КонецЕсли;

	КонецЕсли;
	
КонецПроцедуры // ПроверитьВозможностьИзмененияТабеляРабот()

////////////////////////////////////////////////////////////////////////////////
// ОБНОВЛЕНИЕ ГРУППЫ СОТРУДНИКА ПРИ ПЕРЕДАЧЕ ИЗ ОДНОЙ ГРУППЫ В ДРУГУЮ

&НаСервере
// Выполняет проверку необходимости актуализации Группы сторудников в табелях учета при смене помощника управляющего //+++АК mika 2018.10.11 ИП-00019964 
// (актуализация группы сотрудника выполняется только в случае передачи в подчинение помощнику "Другой группы" магазинов)
//
// Параметры:
//  НачалоПериода  - <Тип.Дата> - Начало периода
//  КонецПериода  - <Тип.Дата> - Конец периода
//  Сотрудник  - <Тип.СправочникСсылка.ФизическиеЛица> - Сотрудник для контроля запланированных выходов
//  ПомощникТУ  - <Тип.СправочникСсылка.ФизическиеЛица> - Новый помощник ТУ
//  МассивТабелей - <Тип.Массив> - Массив наименований табелей работ для актуализации
//  СтрокаУведомления - <Тип.Строка> - Строка уведомления
//
Процедура ОбновитьГруппуСотрудникаПоНовомуПомощнику(НачалоПериода = Неопределено, КонецПериода = Неопределено, Сотрудник, ПомощникТУ, МассивТабелей = Неопределено, СтрокаУведомления = "") Экспорт
	
	//Заполнение основных параметров
	Если НЕ ЗначениеЗаполнено(НачалоПериода) Тогда
		НачалоПериода = НачалоМесяца(НачалоМесяца(ТекущаяДата())-1); // Начало предыдущего месяца
	КонецЕсли;
	
	Если НЕ ЗначениеЗаполнено(КонецПериода) Тогда
		КонецПериода = КонецДня(ТекущаяДата()) + 86400 * 365;       //На год вперед (хотя как правило планируют на 2-3 месяца)
	КонецЕсли;
	
	ГруппаПомощника = РегистрыСведений.ПользователиПоЦФО.ПолучитьСтрукрутуПодчиненияТекущегоСотрудника(ПомощникТУ, Ложь, Истина);
	
	//Обработка запланированных выходов
	Если ЗначениеЗаполнено(ГруппаПомощника) Тогда
		Если МассивТабелей = Неопределено Тогда
			МассивТабелей = ПолучитьМассивИспользуемыхТабелейРабот();
		КонецЕсли;
		
		Для каждого ТекущийТабель Из МассивТабелей Цикл
			
			Запрос = Новый Запрос();
			Запрос.Текст = "ВЫБРАТЬ
			|	*
			|ИЗ
			|	РегистрСведений.ТекущийТабель КАК ТабельРаботы
			|ГДЕ
			|	ТабельРаботы.Период МЕЖДУ &НачалоПериода И &КонецПериода
			|	И ТабельРаботы.Сотрудник = &Сотрудник
			|	И ТабельРаботы.ГруппаСотрудника <> &ГруппаПомощника";
			
			Запрос.Текст = СтрЗаменить(Запрос.Текст, "ТекущийТабель", ТекущийТабель);
			
			Запрос.УстановитьПараметр("НачалоПериода",НачалоПериода);
			Запрос.УстановитьПараметр("КонецПериода",КонецПериода);
			Запрос.УстановитьПараметр("Сотрудник",Сотрудник);
			Запрос.УстановитьПараметр("ГруппаПомощника",ГруппаПомощника);
			
			Результат = Запрос.Выполнить();
			
			Если НЕ Результат.Пустой() Тогда
				сч = 0;
				Выборка = Результат.Выбрать();
				Пока Выборка.Следующий() Цикл
					ОбновитьОбновитьВЗаписиГруппуСотрудника(Выборка, ТекущийТабель, ГруппаПомощника);
					сч = сч + 1;
				КонецЦикла;
				СтрокаУведомления = СтрокаУведомления + СтрЗаменить(СтрЗаменить(" ТекущийТабель: сч.","ТекущийТабель",ТекущийТабель), "сч", 
						СтрокаСЧислом(";Обновлено %1 запись;;Обновлено %1 записи;Обновлено %1 записей;Обновлено %1 записей", сч, 
							ВидЧисловогоЗначения.Количественное, "L=ru")) + Символы.ПС;
			КонецЕсли;
			
		КонецЦикла;
		
		Если НЕ ЗначениеЗаполнено(СтрокаУведомления) Тогда
			СтрокаУведомления = "В табелях работ нет записей, которые необходимо актуализировать!";
		КонецЕсли;
		
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
// Возвращает массив наименований основных табелей работ сотрудников
//
// Возвращаемое значение:
//   <Тип.Массив>   - Массив наименований
//
Функция ПолучитьМассивИспользуемыхТабелейРабот()//+++АК mika 2018.10.11 ИП-00019964 

	МассивТабелей = Новый Массив();
	МассивТабелей.Добавить("ТабельРаботыПродавцов");
	МассивТабелей.Добавить("ТабельРаботыКассиров");
	МассивТабелей.Добавить("ТабельРаботыГрузчиков");
	МассивТабелей.Добавить("ТабельРаботыПекарей");
	МассивТабелей.Добавить("ТабельРаботыПромоутеров");
	МассивТабелей.Добавить("ТабельРаботыУборщиц");
	
	Возврат МассивТабелей;

КонецФункции // ПолучитьМассивИспользуемыхТабелейРабот()

&НаСервере
// Выполняет обновление Группы сотрудника в записи регистра табель работы //+++АК mika 2018.10.11 ИП-00019964  
//
// Параметры:
//  Выборка  - <Тип.Выборка> - Текущая запись регистра
//  ТекущийТабель  - <Тип.Строка> - Имя регистра для актуализации группы
//  ГруппаПомощника  - <Тип.ГруппаПомощника> - Текущая группа нового помощника
//
Процедура ОбновитьОбновитьВЗаписиГруппуСотрудника(Выборка, ТекущийТабель, ГруппаПомощника)
	
	НаборЗаписей = РегистрыСведений[ТекущийТабель].СоздатьНаборЗаписей();
	
	НаборЗаписей.Отбор.Период.Установить(Выборка.Период);
	
	НаборЗаписей.Отбор.Сотрудник.Установить(Выборка.Сотрудник);
	НаборЗаписей.Отбор.Группа.Установить(Выборка.Группа);
	Если ТекущийТабель = "ТабельРаботыПромоутеров" ИЛИ ТекущийТабель = "ТабельРаботыУборщиц" Тогда
		НаборЗаписей.Отбор.ТорговаяТочка.Установить(Выборка.ТорговаяТочка);
	КонецЕсли;
	
	ОбновленнаяЗапись = НаборЗаписей.Добавить();
	
	ЗаполнитьЗначенияСвойств(ОбновленнаяЗапись, Выборка);
	
	ОбновленнаяЗапись.ГруппаСотрудника = ГруппаПомощника;
	
	НаборЗаписей.ОбменДанными.Загрузка = Истина;
	
	Попытка
		НаборЗаписей.Записать();
	Исключение
		//Обрабатывать "исключение" не нужно (все сообщения пользователю будут выведены в зависимости от причин невозможности исправления) 
	КонецПопытки;
	
КонецПроцедуры // ОбновитьОбновитьВЗаписиГруппуСотрудника()

