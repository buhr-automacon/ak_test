﻿
#Область Информация

//+++АК mika 2018.03.16 Рефакторинг кода формы 

#КонецОбласти

#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	//+++АК mika 2018.01.19 В рамках приведения подсистемы в рабочее состояние.
	РольПолныеПрава = РольДоступна("ПолныеПрава");	
	//+++АК mika
	
	Если НЕ РольПолныеПрава И Объект.Ссылка.Пустая() Тогда
		ТекПользователь = ПараметрыСеанса.ТекущийПользователь;
		Если ТекПользователь.ГруппаСотрудниковАутсорсинг.Пустая() Тогда
			Сообщить("Для текущего пользователя не указана группа сотрудников (аутсорсинг)!");
			Отказ = Истина;
			Возврат;
		КонецЕсли;
		Объект.ГруппаСотрудников = ТекПользователь.ГруппаСотрудниковАутсорсинг;
	КонецЕсли;
	
	РазложитьФИОНаФамилиюИмяОтчество(Объект.Наименование);
	
КонецПроцедуры

&НаСервере
Процедура ПередЗаписьюНаСервере(Отказ, ТекущийОбъект, ПараметрыЗаписи)
	
	НадоЗаполнять = Справочники.СотрудникиАутсорсинг.НадоЗаполнятьОтветственногоМенеджера(Объект.Должность);
	Если НадоЗаполнять
			И Объект.ОтветственныйМенеджер.Пустая() Тогда
		Сообщить("Не указан ответственный менеджер! Запись невозможна.");
		Отказ = Истина;
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура НаименованиеПриИзменении(Элемент)

	РазложитьФИОНаФамилиюИмяОтчество(Объект.Наименование);
	
КонецПроцедуры

&НаКлиенте
Процедура ФамилияПриИзменении(Элемент)
	
	ПредлагаемНаименование = СокрЛП(ЭтаФорма.Фамилия) + " " + СокрЛП(ЭтаФорма.Имя) + " " + СокрЛП(ЭтаФорма.Отчество);
	Если НЕ Объект.Наименование = ПредлагаемНаименование Тогда
		Объект.Наименование = ПредлагаемНаименование;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ИмяПриИзменении(Элемент)
	
	ПредлагаемНаименование = СокрЛП(ЭтаФорма.Фамилия) + " " + СокрЛП(ЭтаФорма.Имя) + " " + СокрЛП(ЭтаФорма.Отчество);
	Если НЕ Объект.Наименование = ПредлагаемНаименование Тогда
		Объект.Наименование = ПредлагаемНаименование;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ОтчествоПриИзменении(Элемент)
	
	ПредлагаемНаименование = СокрЛП(ЭтаФорма.Фамилия) + " " + СокрЛП(ЭтаФорма.Имя) + " " + СокрЛП(ЭтаФорма.Отчество);
	Если НЕ Объект.Наименование = ПредлагаемНаименование Тогда
		Объект.Наименование = ПредлагаемНаименование;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ДолжностьНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)

	СтандартнаяОбработка = Ложь;
	
	ФормаВыбора = ПолучитьФорму("Справочник.ДолжностиВнештатныхСотрудников.Форма.ФормаВыбора",, Элемент);
	
	ФормаВыбора.Элементы.Список.ТекущаяСтрока = Объект.Должность;

	ФормаВыбора.ТолькоПросмотр = Истина;
	
	ФормаВыбора.Открыть();
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

Функция ПечатьБейджаНаСервере()
	
	МассивСотрудников = Новый Массив;
	МассивСотрудников.Добавить(Объект.Ссылка);
	
	Возврат Справочники.СотрудникиАутсорсинг.ПечатьБейджейНаСервере(МассивСотрудников);
	
КонецФункции

&НаКлиенте
Процедура ПечатьБейджа(Команда)
	
	Если Объект.Ссылка.Пустая() Тогда
		Сообщить("Печать бейджа возможна только после записи!");
		Возврат;
	КонецЕсли;
	
	//+++АК mika 2018.01.22 ИП-00017263.02
	ОткрытьФорму("Обработка.ПечатьБейджейПродавцов.Форма.Форма", Новый Структура("ГруппаСотрудников", Объект.ГруппаСотрудников), , "ТД_ПечатьБейджей");
	Возврат;
	//---АК mika
	
	//
	ТабДок = ПечатьБейджаНаСервере();
	
	ОткрытьФорму("ОбщаяФорма.ФормаОтображенияТабДокумента", Новый Структура("ТабДок, УстановитьЗаголовок", ТабДок, "Бэйдж"));
	
КонецПроцедуры

&НаКлиенте
Процедура ОбновитьДолжностьЖурналУчета(Команда) //+++АК mika 2018.02.16 ИП-00017263.04
	
	Оповещение = Новый ОписаниеОповещения("ОбновитьДолжностьЖурналУчетаВопросЗавершение", ЭтаФорма);
	
	ПоказатьВопрос(Оповещение, НСтр("ru = 'Обновить должность в журнале учета?'", "ru"), РежимДиалогаВопрос.ДаНет, 15 );
	
КонецПроцедуры

&НаКлиенте
Процедура КодПерсоналККМОткрытие(Элемент, СтандартнаяОбработка) //+++АК mika 2018.03.15 ИП-00017869
	
	СтандартнаяОбработка = Ложь;
	
	Если ЗначениеЗаполнено(Объект.КодПерсоналККМ) Тогда
		ОткрытьЗначение(ПолучитьСсылкаПоКодуПерсоналККМ(Объект.КодПерсоналККМ));
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиОповещений

&НаКлиенте
Процедура ОбновитьДолжностьЖурналУчетаВопросЗавершение(Результат, ДополнительныеПараметры) Экспорт //+++АК mika 2018.02.16 ИП-00017263.04
	
	Если Результат = КодВозвратаДиалога.Да Тогда
		
		Диалог = Новый ДиалогРедактированияСтандартногоПериода();
		СтандартныйПериод = Новый СтандартныйПериод();
		
		СтандартныйПериод.ДатаНачала = НачалоМесяца(ТекущаяДата());
		СтандартныйПериод.ДатаОкончания = КонецМесяца(ТекущаяДата());
		
		Диалог.Период = СтандартныйПериод;
		
		ОписаниеОповещения = Новый ОписаниеОповещения("ОбработкаВыбораПериода",ЭтаФорма);
		
		Диалог.Показать(ОписаниеОповещения)  
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаВыбораПериода(Результат, ДополнительныеПараметры) Экспорт //+++АК mika 2018.02.16 ИП-00017263.04
	
	Если Результат <> Неопределено Тогда
		
		СтруктураПараметров = Новый Структура();
		
		СтруктураПараметров.Вставить("НачалоПериода", Результат.ДатаНачала);
		СтруктураПараметров.Вставить("КонецПериода", Результат.ДатаОкончания);
		СтруктураПараметров.Вставить("Сотрудник", Объект.Ссылка);
		
		ОбновитьДолжностьСотрудникаЖурналУчетаСервер(СтруктураПараметров);

	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Процедура РазложитьФИОНаФамилиюИмяОтчество(ТекФИО)
	
	ТекущиеФИО = ТекФИО;
	ПозПробела = Найти(ТекущиеФИО, " ");
	Если ПозПробела > 0 Тогда
		ЭтаФорма.Фамилия = СокрЛП(Лев(ТекущиеФИО, ПозПробела - 1));
		ТекущиеФИО = Сред(ТекущиеФИО, ПозПробела + 1);
		ПозПробела = Найти(ТекущиеФИО, " ");
		Если ПозПробела > 0 Тогда
			ЭтаФорма.Имя 		= СокрЛП(Лев(ТекущиеФИО	, ПозПробела - 1));
			ЭтаФорма.Отчество 	= СокрЛП(Сред(ТекущиеФИО, ПозПробела + 1));
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ОбновитьДолжностьСотрудникаЖурналУчетаСервер(СтруктураПараметров)  //+++АК mika 2018.02.16 ИП-00017263.04
	
	РегистрыСведений.ЖурналУчетаСотрудниковПоДнямАутсорсинг.ОбновитьДолжностьСотрудникаЖурналУчета(СтруктураПараметров);
		
КонецПроцедуры

&НаСервереБезКонтекста 
Функция ПолучитьСсылкаПоКодуПерсоналККМ(КодККМ) //+++АК mika 2018.03.15 ИП-00017869
	
	Возврат Справочники.ПерсоналККМ.НайтиПоКоду(КодККМ);
		
КонецФункции

#КонецОбласти




