﻿
&НаКлиенте
Процедура НачалоДействияПриИзменении(Элемент)
	
	//+++АК_Кибарев, 09.09.17, ИП-00016684
	Объект.ОкончанияДействия = ДобавитьМесяц(Объект.НачалоДействия, 36) - 86400;
	//---АК_Кибарев, 09.09.17, ИП-00016684
	
КонецПроцедуры

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	ЗаполнитьОтветсвенныхЛицИПоставщика();  //+++АК_Кибарев, 09.09.17, ИП-00016684
	УстановитьВидимостьДоступность();
	
	////+++АК_Кибарев, 01.10.17, ИП-00016684
	//В обработчике после записи будет проверятся равеностово этих значний, если  <>, тогда будет отправлено письмо для подтверждения
	ПринялПриОткрытии = Объект.Принял;
	//ЗаполнитьОбновитьДатуПринятияТехПаспорта(); //+++АК LAGP 2018.01.26 ИП-00017769 Эта процедура для акцепта через письма, а он отключен.
	////---АК_Кибарев, 01.10.17, ИП-00016684
	
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьОтветсвенныхЛицИПоставщика();
	
	//+++АК_Кибарев, 09.09.17, ИП-00016684 Заполняем только во вновь созданных элементах
	Если НЕ Параметры.Ключ.Пустая() Тогда
		Возврат;	
	КонецЕсли; 
	
	//Заполнить Потсавщика из константы
	Объект.Поставщик = Константы.АК_ТехПаспортаПоставщик.Получить();
	
	//ЗАполнить ответсвенных лиц
	НачЭкспл = ПланыВидовХарактеристик.ТипыРолейПользователя.АК_НачальникЭксплуатации;
	ПомУпр   = ПланыВидовХарактеристик.ТипыРолейПользователя.ПомощникТерриториальногоУправляющего;
	//+++ AK suvv 2018.06.08 ИП-00018376.01
	ПомСторРозн   = ПланыВидовХарактеристик.ТипыРолейПользователя.ПомощникСтороннейРозницы;
	//--- AK suvv
	Управляющий   = ПланыВидовХарактеристик.ТипыРолейПользователя.НайтиПоКоду("UpravlyayushchiiPoRoznice"); //+++АК LAGP 17.11.23 ИП-00017313 Реквизит не предопределен
	
	ТипыРолей = Новый Массив;
	ТипыРолей.Добавить(НачЭкспл);
	ТипыРолей.Добавить(ПомУпр);
	//+++ AK suvv 2018.06.08 ИП-00018376.01
	ТипыРолей.Добавить(ПомСторРозн);
	//--- AK suvv
	
	Запрос = Новый Запрос("ВЫБРАТЬ
	                      |	СоответствиеОбъектРольСрезПоследних.РольПользователя,
	                      |	СоответствиеОбъектРольСрезПоследних.ТипРоли
	                      |ПОМЕСТИТЬ ВТ
	                      |ИЗ
	                      |	РегистрСведений.СоответствиеОбъектРоль.СрезПоследних(
	                      |			,
	                      |			Объект = &Объект
	                      |				И ТипРоли В (&ТипРоли)) КАК СоответствиеОбъектРольСрезПоследних
	                      |;
	                      |
	                      |////////////////////////////////////////////////////////////////////////////////
	                      |ВЫБРАТЬ
	                      |	ВТ.ТипРоли,
	                      |	РолиПользователейСоставРоли.Сотрудник,
						  //+++АК LAGP 17.11.23 ИП-00017313 Добавил Ссылку на справочник, дабы найти усправляющего, по его помощнику
	                      |	РолиПользователейСоставРоли.Ссылка КАК СпрРолиПользователейСсылка
	                      |ИЗ
	                      |	ВТ КАК ВТ
	                      |		ЛЕВОЕ СОЕДИНЕНИЕ Справочник.РолиПользователей.СоставРоли КАК РолиПользователейСоставРоли
	                      |		ПО ВТ.РольПользователя = РолиПользователейСоставРоли.Ссылка
	                      |ГДЕ
	                      |	РолиПользователейСоставРоли.Ссылка В
	                      |			(ВЫБРАТЬ
	                      |				т.РольПользователя
	                      |			ИЗ
	                      |				ВТ КАК т)");
	Запрос.УстановитьПараметр("Объект", Объект.Владелец);
	Запрос.УстановитьПараметр("ТипРоли", ТипыРолей);
	
	РезультатЗапроса = Запрос.Выполнить();
	
	Если НЕ РезультатЗапроса.Пустой() Тогда   //+++АК LAGP 2018.10.24 б/н По просьбе Богомаз Марии.
		Выборка = РезультатЗапроса.Выбрать();
		//В том случае ,если в Роли пользователя указано несколько сотрудников в соответсвующе ТЧ, будет выбран первый попавшийся
		Выборка.НайтиСледующий(Новый Структура("ТипРоли", НачЭкспл));
		Объект.НачальникЭксплуатации = Выборка.Сотрудник;
		
		Выборка.Сбросить();
		
		Выборка.НайтиСледующий(Новый Структура("ТипРоли", ПомУпр));
		Объект.ПомощникУправляющего = Выборка.Сотрудник;
		
		//---АК_Кибарев, 09.09.17, ИП-00016684
		
		//+++АК LAGP 17.11.23 ИП-00017313 
		Если НЕ ЗначениеЗаполнено(Объект.Владелец) Тогда
			Сообщить("Не указана структурная единица-владелец!");
			Возврат;
		КонецЕсли;	
			
		РодительПомощникаУправляющего = Выборка.СпрРолиПользователейСсылка.Родитель;
		Если ЗначениеЗаполнено(РодительПомощникаУправляющего) Тогда
			Если РодительПомощникаУправляющего.СоставРоли.Количество() > 0 Тогда
				Объект.Принял = РодительПомощникаУправляющего.СоставРоли[0].Сотрудник;		
			КонецЕсли;	
		КонецЕсли;
	КонецЕсли;	
	//---АК LAGP
	
КонецПроцедуры

&НаСервере
Функция ЭтоОткрытаяРозничнаяТочка()
	
	мВладелец = Объект.Владелец;
	
	Возврат ?(мВладелец.ТипСтруктурнойЕдиницы = Перечисления.ТипыСтруктурныхЕдиниц.Розница 
				И мВладелец.ТипРозничнойТочки <> Перечисления.ТипыРозничныхТочек.Избенка И
				мВладелец.СтатусТорговойТочки = Перечисления.СтатусыТорговыхТочек.Открыт, Истина, Ложь);
				
КонецФункции
			
&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	//+++АК_Кибарев, 10.09.17, ИП-00016684
	Если НЕ Параметры.Ключ.Пустая() Тогда   //Проверка на новый
		Возврат;	
	КонецЕсли; 
	
	//Запрещаем создавать нов. элементы непосредственно из самого справочника и для Структурных единиц не являющихся
	//розницей и для Избенки
	                                                        
	Если Не ЗначениеЗаполнено(Объект.Владелец) Тогда
		
	    ТекстСообщения = НСтр("ru = 'Для добавления нового элемента перейдите с справочник-владелец """"Розничные магазины""'");
		ВыводСообщений.ВывестиСообщениеВОкноСообщений(ТекстСообщения, СтатусСообщения.Информация, "Создание элемента", "", Истина);
		Отказ = Истина;
	    Возврат;
	КонецЕсли; 
	
	Если Не ЭтоОткрытаяРозничнаяТочка() Тогда
		
		ТекстСообщения = НСтр("ru = 'Тех. паспорта необходимы только для открытых Розничных магазинов, не являющимися Избёнкой'");
		ВыводСообщений.ВывестиСообщениеВОкноСообщений(ТекстСообщения, СтатусСообщения.Информация, "Создание элемента", "", Истина);
		Отказ = Истина;	
		
	КонецЕсли; 
	
	//---АК_Кибарев, 10.09.17, ИП-00016684
	
КонецПроцедуры

&НаКлиенте
Процедура ПослеЗаписи(ПараметрыЗаписи)
		
	Оповестить("ТехническийПаспортИзменен");  //+++АК_Кибарев, 10.09.17, ИП-00016684
	//+++АК_Кибарев, 01.10.17, ИП-00016684
	//Если ПринялПриОткрытии <> Объект.Принял Тогда //есл был измнен Принимающий, отправить письмо для подтверждения
	Если Ложь Тогда //+++АК LAGP 17.11.23 ИП-00017313 Отключить
		Попытка
			ОтправитьПисьмоСервер(); 	 
		Исключение
			Сообщение = Новый СообщениеПользователю;
			Сообщение.Текст = "Уведмление не отправлено: " + ОписаниеОшибки();
			Сообщение.Сообщить();      
		КонецПопытки;
	
	КонецЕсли; 
	//---АК_Кибарев, 01.10.17, ИП-00016684
	
КонецПроцедуры

&НаСервере
Процедура УстановитьВидимостьДоступность()
	
	//Элементы.ГруппаПринял.Видимость = Объект.Передан;  //+++АК_Кибарев, 28.09.17, ИП-00016684
	
	//+++АК LAGP 2017.11.23 <*ИП-00017313 первоначальная задача (не актуально)*> 2017.12.13 ИП-00017425 доступ до реквизитов Принял, есть только у ответственных по магазину     
	ТЗОтветственных = ПолучитьОтветственных();
	Элементы.ГруппаПринял.Видимость = Истина;  
	
	СотрудникВОтветственных = ТЗОтветственных.Найти(ПараметрыСеанса.ТекущийПользователь.ФизЛицо);
	
	//+++АК LAGP 2017.12.19 ИП-00017425.01 Унифицируется принцип доступности элементов формы
	ЭтоРедакторТехПаспортов = Ложь;
	Если НЕ ЗначениеЗаполнено(СотрудникВОтветственных) И РольДоступна("АК_РедактированиеТехПаспортов") Тогда
		СотрудникВОтветственных = Истина;
		ЭтоРедакторТехПаспортов = Истина;
	КонецЕсли;	
		
	ИзменитьДоступностьЭлементовФормы(ЗначениеЗаполнено(СотрудникВОтветственных));	
	
	Если ЭтоРедакторТехПаспортов Тогда
		Элементы.Принято.Доступность = Истина;	
	КонецЕсли;	
	//Элементы.Принято.Доступность = СотрудникВОтветственных ИЛИ РольДоступна("ПолныеПрава"));  
	//Элементы.Принял.Доступность  = Элементы.Принято.Доступность;
	//---АК LAGP 2017.12.19
	//---АК LAGP 2017.11.23
	
	//+++АК LAGP 2017.12.19 ИП-00017425.01 Начальнику эксплуатации (любому) есть доступ до полей "Начальник эксплуатации"
	ТекущееФизЛицо = ПараметрыСеанса.ТекущийПользователь.ФизЛицо;
	ТЗРолей = ПолучитьРолиСотрудника(ТекущееФизЛицо);	
	НайденнаяРоль = ТЗРолей.Найти(ПланыВидовХарактеристик.ТипыРолейПользователя.АК_НачальникЭксплуатации, "ТипРоли");
	Если ЗначениеЗаполнено(НайденнаяРоль) Тогда
		Элементы.НачальникЭксплуатации.Доступность = Истина;			
	КонецЕсли;	
	
	Если Объект.НачальникЭксплуатации = ТекущееФизЛицо И Элементы.НачальникЭксплуатации.Доступность Тогда
		Элементы.Принято.Доступность = Истина;	
	КонецЕсли;	
	
	Если НЕ ЗначениеЗаполнено(СотрудникВОтветственных) Тогда
		Сообщить("Текущий сотрудник не находится в списке ответственных по структурной единице. Доступ к реквизитам закрыт.");	
	КонецЕсли;
	
	Если НЕ ЗначениеЗаполнено(СотрудникВОтветственных) И ЗначениеЗаполнено(НайденнаяРоль) Тогда
		Сообщить("Текущий сотрудник является начальником эксплуатации, доступ к части полей открыт!");
	КонецЕсли;	
	//---АК LAGP 2017.12.19
	
	//+++АК LAGP 2018.04.09 ИП-00018343 Добавлен вид "ИД ЭОМ" в тех.паспорт
	Элементы.ОкончанияДействия.Видимость 	= НЕ Объект.ВидТехническогоПаспорта = Перечисления.ВидыТехническихПаспортов.ИД_ЭОМ;
	Если Объект.ВидТехническогоПаспорта = Перечисления.ВидыТехническихПаспортов.ИД_ЭОМ Тогда
		Элементы.Наименование.Видимость = Ложь;
	Иначе
		Элементы.Наименование.Заголовок = "№ техпаспорта";
		Элементы.Наименование.Видимость = Истина;
	КонецЕсли;	
	//---АК LAGP
	
КонецПроцедуры // ИзментьВидимостьДоступность()()

&НаКлиенте
Процедура ПереданПриИзменении(Элемент)
	
	УстановитьВидимостьДоступность();
	
	//+++АК LAGP 17.11.23 ИП-00017313 Отключено, проставлена зависимость от галки "Принято"
	//Если Не Объект.Передан Тогда 
	//
	//	Объект.Принял = "";
	//
	//КонецЕсли; 	
	
	//ЗаполнитьОбновитьДатуПринятияТехПаспорта();
	
	Если Объект.Принято И НЕ ЗначениеЗаполнено(Объект.ДатаПриемаПередачиПаспорта) Тогда
		Объект.ДатаПриемаПередачиПаспорта = ТекущаяДата();
	КонецЕсли;			
	//---АК LAGP
	
КонецПроцедуры

&НаСервере
Процедура ОтправитьПисьмоСервер()
	
	СписокКому = Новый СписокЗначений;
	
	ПредставлениеАдреса = ПолучитьАдресЭлПочтыПолучателяПредставление();
	
	Если Не ЗначениеЗаполнено(ПредставлениеАдреса) Тогда
		
		ДобавитьЗаписьВРегистрАкцептТехПаспортов("");
		Возврат;	
	
	КонецЕсли; 
	
	МассивАдресов = Справочники.Контрагенты.РазложитьСтрокуВМассивПодстрок(ПредставлениеАдреса,";");	
	
	Для каждого Эл Из МассивАдресов Цикл
		
		Если ЗначениеЗаполнено(Эл) Тогда
			СписокКому.Добавить(СокрЛП(Эл));
		КонецЕсли; 
		
	КонецЦикла; 
	
	АкцептоватьЗаявкуОтправкаПочты(СписокКому);
	
КонецПроцедуры

&НаСервере
Функция ПолучитьАдресЭлПочтыПолучателяПредставление() 
	
	Запрос = Новый Запрос;
	Запрос.Текст =                                                                                   
	"ВЫБРАТЬ                                                   
	|	КонтактнаяИнформация.Представление
	|ИЗ
	|	РегистрСведений.КонтактнаяИнформация КАК КонтактнаяИнформация
	|ГДЕ
	|	КонтактнаяИнформация.Объект = &Объект
	|	И КонтактнаяИнформация.Тип = &Тип
	|	И КонтактнаяИнформация.Вид = Значение(Справочник.ВидыКонтактнойИнформации.EmailФизЛица)";
	Запрос.УстановитьПараметр("Объект", Объект.Принял);
	Запрос.УстановитьПараметр("Тип", Перечисления.ТипыКонтактнойИнформации.АдресЭлектроннойПочты);
	
	Результат = Запрос.Выполнить();
	
	Если Результат.Пустой()  Тогда
		
	    ТекстСообщения = "Не заполнен адрес электронной почты у принимающего!!";
		СообщениеПользователю = Новый СообщениеПользователю;
		СообщениеПользователю.Текст = ТекстСообщения;
		СообщениеПользователю.Сообщить();
		Возврат "";	
	
	КонецЕсли; 
	 
	ВыборкаДетальныеЗаписи = Результат.Выбрать();
	ВыборкаДетальныеЗаписи.Следующий();
	
	Возврат ВыборкаДетальныеЗаписи.Представление;
	
КонецФункции

&НаСервере
Процедура АкцептоватьЗаявкуОтправкаПочты(Адрес)
	
	СтруктураДанных = Новый Структура;
	
	СтруктураДанных.Вставить("Акцептант", ПараметрыСеанса.ТекущийПользователь);
	Получатели = Новый СписокЗначений;

	МассивАдресов = Справочники.Контрагенты.РазложитьСтрокуВМассивПодстрок(Адрес,";");	
	
	Для каждого Эл Из МассивАдресов Цикл
		Если ЗначениеЗаполнено(Эл) Тогда
			Получатели.Добавить(СокрЛП(Эл));
		КонецЕсли; 
	КонецЦикла; 
	
	СтруктураДанных.Вставить("Получатели", Получатели);
		
	СтруктураДанных.Вставить("УчетнаяЗапись", ОбщиеПроцедуры.ПолучитьУчетнуюЗаписьДляРассылки());
	
	Запрос = Новый Запрос("ВЫБРАТЬ
	                      |	АК_ТехническиеПаспорта.Владелец,
	                      |	АК_ТехническиеПаспорта.Код,
	                      |	АК_ТехническиеПаспорта.Наименование,
	                      |	АК_ТехническиеПаспорта.НачалоДействия,
	                      |	АК_ТехническиеПаспорта.ОкончанияДействия,
	                      |	АК_ТехническиеПаспорта.Поставщик,
	                      |	АК_ТехническиеПаспорта.ПомощникУправляющего,
	                      |	АК_ТехническиеПаспорта.НачальникЭксплуатации,
	                      |	АК_ТехническиеПаспорта.Комментарий
	                      |ИЗ
	                      |	Справочник.АК_ТехническиеПаспорта КАК АК_ТехническиеПаспорта
	                      |ГДЕ
	                      |	АК_ТехническиеПаспорта.Ссылка = &Ссылка");
	Запрос.УстановитьПараметр("Ссылка", Объект.Ссылка);
	
	Выборка = Запрос.Выполнить().Выбрать();
	
	Таблица 									= ""; 
	style 										= "<td style = ""background: #fff; text-align: left;""><font FACE=""Verdana"" color=""000000"" size=2";
	ЦветШапки 									= "E5D4F2";
	ЦветШапки 									= "F0FFFF";
	TR 											= "<th style = ""background: #";
	TA											= "; text-align: left;""><font FACE=""Verdana"" color=""000000"" size=2";
	TA1											= "; text-align: left;""><font FACE=""Verdana"" color=""000000"" size=2";
	Инд 										= 1;
	РезЗапросДоки_1 							= Выборка;
	Таблица 							 		= Таблица + "<b>Информация из шапки документа</b>";
	 
	РезЗапросДоки_1.Следующий(); 
	Таблица = Таблица + "<BR>" + "Розничный магазин: " 				+ РезЗапросДоки_1.Владелец;
	Таблица = Таблица + "<BR>" + "Номер тех. паспорта: " 			+ РезЗапросДоки_1.Наименование;
	Таблица = Таблица + "<BR>" + "Дата начала действия: " 			+ РезЗапросДоки_1.НачалоДействия;
	Таблица = Таблица + "<BR>" + "Дата окончания действия: " 		+ РезЗапросДоки_1.ОкончанияДействия;
			
	Таблица = Таблица + "<BR>";	
	Таблица = Таблица + "</Table>";
	Таблица = Таблица + "<br>";
	СтруктураДанных.Вставить("Таблица", Таблица);
	
	Тема = "Принятие Тех. паспорта №" + СокрЛП(РезЗапросДоки_1.Наименование) + " по магазину " + СокрЛП(РезЗапросДоки_1.Владелец);
	СтруктураДанных.Вставить("Тема", Тема);
	СтруктураДанных.Вставить("НомерПаспорта", СокрЛП(РезЗапросДоки_1.Наименование));
	
	СтруктураДанных.Вставить("ID_MESSAGE", Новый УникальныйИдентификатор);
	СтруктураДанных.Вставить("GUID_ТехПаспорта", Строка(Объект.Ссылка.УникальныйИдентификатор()));
	СтруктураДанных.Вставить("ОбъектСсылка", Объект.Ссылка);
	ОтправитьЗаявкуНаПриемТехПаспорта(СтруктураДанных);
	
	ИДПисьма = СтруктураДанных.ID_MESSAGE;
	
КонецПроцедуры

&НаСервере
Процедура ОтправитьЗаявкуНаПриемТехПаспорта(Данные) Экспорт 
	
	ПолучателиВстроку = "";
	
	УчетнаяЗапись = Данные.УчетнаяЗапись;
	
	Если УчетнаяЗапись = Неопределено Тогда
		УчетнаяЗапись = ОбщиеПроцедуры.ПолучитьУчетнуюЗаписьДляРассылки();
	КонецЕсли;	
	
	Почта 										= Новый ИнтернетПочта;
	Профиль 									= УправлениеЭлектроннойПочтой.ПолучитьИнтернетПочтовыйПрофиль(УчетнаяЗапись);
	Письмо 										= Новый ИнтернетПочтовоеСообщение;
	Почта.Подключиться(Профиль);
	Письмо.Тема 								= Данные.Тема;
	Письмо.ИмяОтправителя  						= "accept@izbenka.msk.ru";
	Письмо.Отправитель     						= "accept@izbenka.msk.ru";
	Для Каждого ПолучательЭлемент Из Данные.Получатели Цикл
		
		Письмо.Получатели.Добавить(ПолучательЭлемент);	
		ПолучателиВстроку = ПолучательЭлемент.Значение + "; " + ПолучателиВстроку;
		
	КонецЦикла;	
	ТекстСообщения 								= Письмо.Тексты.Добавить();
	ТекстСообщения.Текст    					= ТекстСообщения.Текст + Данные.Таблица;
		
	пТекстСсылкиНаКнопкуПодтвердить 			= "mailto:vkusvill.444@gmail.com?reply-to=vkusvill.444@gmail.com&subject=Принятие тех. пасорта №" + Данные.НомерПаспорта + "&body=GUID%20" + Данные.GUID_ТехПаспорта + "%20ID_MESSAGE%20" + Данные.ID_MESSAGE + "%20TYPE_MESSAGE%20" + " " + "%20Акцептировано";
	пТекстСсылкиНаКнопкуОтменитьПодтверждение 	= "mailto:vkusvill.444@gmail.com?reply-to=vkusvill.444@gmail.com&subject=Принятие тех. пасорта №" + Данные.НомерПаспорта + "&body=GUID%20" + Данные.GUID_ТехПаспорта + "%20ID_MESSAGE%20" + Данные.ID_MESSAGE + "%20TYPE_MESSAGE%20" + " " + "%20Отклонено";
	
	пТекстКнопкиПодтвердить 					= "<a href=""" + пТекстСсылкиНаКнопкуПодтвердить + """><b>Принять</b></a><br><br>";
	пТекстКнопкиОтменитьПодтверждение 			= "<a href=""" + пТекстСсылкиНаКнопкуОтменитьПодтверждение + """><b>Отклонить</b></a><br><br>";
	ТекстСообщения.Текст 						= ТекстСообщения.Текст + пТекстКнопкиПодтвердить + пТекстКнопкиОтменитьПодтверждение;
	ТекстСообщения.ТипТекста 					= ТипТекстаПочтовогоСообщения.HTML;
	Почта.Послать(Письмо);
	Почта.Отключиться();
	
	ДобавитьЗаписьВРегистрАкцептТехПаспортов(Данные.ID_MESSAGE);
	
	СообщениеПоОтправке 						= НСтр("ru = 'Отправлено письмо по акцептанту:  %Выборка_Акцептант% и документу %РезЗапросДокиСсылка%'");
	СообщениеПоОтправке 						= СтрЗаменить(СообщениеПоОтправке, "%РезЗапросДокиСсылка%", Данные.ОбъектСсылка);
	СообщениеПоОтправке =                         СтрЗаменить(СообщениеПоОтправке, "%Выборка_Акцептант%", Данные.Акцептант);
	
	Сообщение = Новый СообщениеПользователю;
	Сообщение.Текст = СообщениеПоОтправке;
	Сообщение.Сообщить(); 
		
КонецПроцедуры

&НаСервере
Процедура ДобавитьЗаписьВРегистрАкцептТехПаспортов(ИДПисьма)
	
	МенеджерЗаписи = РегистрыСведений.АК_АкцептТехПаспортов.СоздатьМенеджерЗаписи();
	МенеджерЗаписи.ИДТехПаспорта = Строка(Объект.Ссылка.УникальныйИдентификатор());
	МенеджерЗаписи.ИДПисьма = ИДПисьма;
	МенеджерЗаписи.ЭлектронныеАдресаРассылки = ПолучитьАдресЭлПочтыПолучателяПредставление();
	МенеджерЗаписи.ДатаОтправки = ТекущаяДата();
	МенеджерЗаписи.СтатусАкцепта = Перечисления.АК_СтатусыАкцептаТехПаспортов.ВПроцессеПринятия;
	МенеджерЗаписи.ТехПаспорт = Объект.Ссылка;
	МенеджерЗаписи.Принимающий = Объект.Принял;
	МенеджерЗаписи.Записать();
	
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьОбновитьДатуПринятияТехПаспорта()
	
	Запрос = Новый Запрос("ВЫБРАТЬ
	                      |	АК_АкцептТехПаспортов.ДатаОтвета
	                      |ИЗ
	                      |	РегистрСведений.АК_АкцептТехПаспортов КАК АК_АкцептТехПаспортов
	                      |ГДЕ
	                      |	АК_АкцептТехПаспортов.ТехПаспорт = &ТехПаспорт
	                      |	И АК_АкцептТехПаспортов.СтатусАкцепта = ЗНАЧЕНИЕ(Перечисление.АК_СтатусыАкцептаТехПаспортов.Принят)
	                      |	И АК_АкцептТехПаспортов.Принимающий = &Принимающий");
	Запрос.УстановитьПараметр("ТехПаспорт", Объект.Ссылка);
	Запрос.УстановитьПараметр("Принимающий", Объект.Принял);
	Выборка = Запрос.Выполнить().Выбрать();
	
	Если  Выборка.Следующий() Тогда
		ДатаПриемаПередачиПаспорта = Выборка.ДатаОтвета;	
	Иначе
	   ДатаПриемаПередачиПаспорта = "";
	КонецЕсли; 
	
КонецПроцедуры

&НаКлиенте
Процедура ПринялПриИзменении(Элемент)
		
	//ЗаполнитьОбновитьДатуПринятияТехПаспорта(); //+++АК LAGP 17.11.23 ИП-00017313 Отключена работа с почтой, проставлена зависимость от галки "Принято"
	
КонецПроцедуры

//+++АК LAGP 2017.12.13 ИП-00017425 доступ до реквизитов Принял, есть только у ответственных по магазину
&НаСервере
Функция ПолучитьОтветственных()
	
	НачЭкспл = ПланыВидовХарактеристик.ТипыРолейПользователя.АК_НачальникЭксплуатации;
	ПомУпр   = ПланыВидовХарактеристик.ТипыРолейПользователя.ПомощникТерриториальногоУправляющего;
	//+++ AK suvv 2018.06.08 ИП-00018376.01 
	ПомСторРозн   = ПланыВидовХарактеристик.ТипыРолейПользователя.ПомощникСтороннейРозницы;
	//--- AK suvv
	Управляющий   = ПланыВидовХарактеристик.ТипыРолейПользователя.НайтиПоКоду("UpravlyayushchiiPoRoznice"); 
	
	ТипыРолей = Новый Массив;
	ТипыРолей.Добавить(НачЭкспл);
	ТипыРолей.Добавить(ПомУпр);
	ТипыРолей.Добавить(Управляющий);
	//+++ AK suvv 2018.06.08 ИП-00018376.01
	ТипыРолей.Добавить(ПомСторРозн);
	//--- AK suvv
	
	Запрос = Новый Запрос("ВЫБРАТЬ
	                      |	СоответствиеОбъектРольСрезПоследних.РольПользователя,
	                      |	СоответствиеОбъектРольСрезПоследних.ТипРоли
	                      |ПОМЕСТИТЬ ВТ
	                      |ИЗ
	                      |	РегистрСведений.СоответствиеОбъектРоль.СрезПоследних(
	                      |			,
	                      |			Объект = &Объект
	                      |				И ТипРоли В (&ТипРоли)) КАК СоответствиеОбъектРольСрезПоследних
	                      |;
	                      |
	                      |////////////////////////////////////////////////////////////////////////////////
	                      |ВЫБРАТЬ
	                      |	ВТ.ТипРоли,
	                      |	РолиПользователейСоставРоли.Сотрудник,
	                      |	РолиПользователейСоставРоли.Ссылка КАК СпрРолиПользователейСсылка,
	                      |	ВТ.РольПользователя
	                      |ИЗ
	                      |	ВТ КАК ВТ
	                      |		ЛЕВОЕ СОЕДИНЕНИЕ Справочник.РолиПользователей.СоставРоли КАК РолиПользователейСоставРоли
	                      |		ПО ВТ.РольПользователя = РолиПользователейСоставРоли.Ссылка
	                      |ГДЕ
	                      |	РолиПользователейСоставРоли.Ссылка В
	                      |			(ВЫБРАТЬ
	                      |				т.РольПользователя
	                      |			ИЗ
	                      |				ВТ КАК т)");
	Запрос.УстановитьПараметр("Объект", Объект.Владелец);
	Запрос.УстановитьПараметр("ТипРоли", ТипыРолей);
	
	ТЗОтветственных = Запрос.Выполнить().Выгрузить();

	ОтборПомощниковУправляющего = Новый Структура();
	ОтборПомощниковУправляющего.Вставить("ТипРоли", Управляющий);
	МассивПомощниковУправляющего = ТЗОтветственных.НайтиСтроки(ОтборПомощниковУправляющего);	
	
	Для каждого ПомощникУправляющего из МассивПомощниковУправляющего Цикл
		РодительПомощникаУправляющего = ПомощникУправляющего.СпрРолиПользователейСсылка.Родитель;
		Если ЗначениеЗаполнено(РодительПомощникаУправляющего) Тогда
			Если РодительПомощникаУправляющего.СоставРоли.Количество() > 0 Тогда
				Для каждого Управляющий Из РодительПомощникаУправляющего.СоставРоли Цикл
					ДобавляемыйУправляющий = ТЗОтветственных.Добавить();
					ДобавляемыйУправляющий.Сотрудник = Управляющий.Сотрудник;					
				КонецЦикла;		
			КонецЕсли;	
		КонецЕсли;	
	КонецЦикла;	
	
	ТЗОтветственных.Свернуть("Сотрудник");
	
	Возврат ТЗОтветственных;
		
КонецФункции	

//+++АК LAGP 2017.12.19 ИП-00017425.01
&НаСервере
Функция ПолучитьРолиСотрудника(Сотрудники) //Сотрудники - справочник физических лиц - параметр для запроса

	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ
		|	РолиПользователейСоставРоли.Ссылка,
		|	РолиПользователейСоставРоли.Сотрудник,
		|	РолиПользователейТипыРолей.ТипРоли
		|ИЗ
		|	Справочник.РолиПользователей.СоставРоли КАК РолиПользователейСоставРоли
		|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ Справочник.РолиПользователей.ТипыРолей КАК РолиПользователейТипыРолей
		|		ПО РолиПользователейСоставРоли.Ссылка = РолиПользователейТипыРолей.Ссылка
		|ГДЕ
		|	РолиПользователейСоставРоли.Сотрудник В (&Сотрудники)";
	
	Запрос.УстановитьПараметр("Сотрудники", Сотрудники);
	
	РезультатЗапросаРолей = Запрос.Выполнить().Выгрузить();
		
	Возврат РезультатЗапросаРолей;
	
КонецФункции	

//+++АК LAGP 2017.12.19 ИП-00017425.01
&НаКлиенте
Процедура НачальникЭксплуатацииПриИзменении(Элемент)
	
	Если Объект.НачальникЭксплуатации = ПараметрыСеанса.ТекущийПользователь.ФизЛицо Тогда
		Элементы.Принято.Доступность = Истина;
	Иначе
		Элементы.Принято.Доступность = Элементы.Принял.Доступность;
	КонецЕсли;	
	
КонецПроцедуры

//+++АК LAGP 2017.12.19 ИП-00017425.01 Унифицируется принцип доступности элементов формы
&НаСервере
Процедура ИзменитьДоступностьЭлементовФормы(Доступность)
	
	Если РольДоступна("ПолныеПрава") Тогда
		Возврат;	
	КонецЕсли;	
	
	Для каждого ЭлементФормы Из ЭтаФорма.Элементы Цикл
		Если НЕ ТипЗнч(ЭлементФормы) = Тип("ДекорацияФормы") И НЕ ТипЗнч(ЭлементФормы) = Тип("ГруппаФормы") Тогда
			ЭлементФормы.Доступность = Доступность;	
		КонецЕсли;	
	КонецЦикла;
	
	Если НЕ Доступность Тогда   
		МассивРазрешенныхЭлементов = Новый Массив;
		МассивРазрешенныхЭлементов.Добавить("ФормаЗаписать");
		МассивРазрешенныхЭлементов.Добавить("ФормаЗаписатьИЗакрыть");
			                                          	
		Для каждого ЭлементМассиваРазрешенныхЭлементов Из МассивРазрешенныхЭлементов Цикл
			Попытка  
				ЭтаФорма.Элементы[ЭлементМассиваРазрешенныхЭлементов].Доступность = Истина;	
			Исключение
			КонецПопытки;	
		КонецЦикла;
	КонецЕсли;	
		
КонецПроцедуры	

//+++АК LAGP 2018.04.09 ИП-00018343 Добавлен вид документа ИД ЭОМ в тех.паспорт
&НаКлиенте
Процедура ВидТехническогоПаспортаПриИзменении(Элемент)
	
	УстановитьВидимостьДоступность();
	
КонецПроцедуры

&НаКлиенте
Процедура ПередЗаписью(Отказ, ПараметрыЗаписи)
	
	//+++АК LAGP 2018.04.09 ИП-00018343 Добавлен вид "ИД ЭОМ" в тех.паспорт
	Если Объект.ВидТехническогоПаспорта = Перечисления.ВидыТехническихПаспортов.ИД_ЭОМ Тогда
		Объект.Наименование = "ИД ЭОМ";
		Объект.ОкончанияДействия = Неопределено;
	КонецЕсли;
	//---АК LAGP
	
КонецПроцедуры
