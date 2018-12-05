﻿
Функция ПолучитьПочтуПолучателя(Получатель)
	
	Если ТипЗнч(Получатель) = Тип("СправочникСсылка.ФизическиеЛица") Тогда
		Запрос = Новый Запрос();
		Запрос.УстановитьПараметр("ФизЛицо", Получатель);
		Запрос.Текст = "ВЫБРАТЬ
		               |	КонтактнаяИнформация.Представление
		               |ИЗ
		               |	РегистрСведений.КонтактнаяИнформация КАК КонтактнаяИнформация
		               |ГДЕ
		               |	КонтактнаяИнформация.Объект = &ФизЛицо
		               |	И КонтактнаяИнформация.Тип = ЗНАЧЕНИЕ(Перечисление.ТипыКонтактнойИнформации.АдресЭлектроннойПочты)
		               |	И КонтактнаяИнформация.Вид = ЗНАЧЕНИЕ(Справочник.ВидыКонтактнойИнформации.EmailФизЛица)";
					   
		Выборка = Запрос.Выполнить().Выбрать();
		Если Выборка.Следующий() Тогда
			Возврат Выборка.Представление;
		Иначе
			Возврат "";
		КонецЕсли;
	ИначеЕсли ТипЗнч(Получатель) = Тип("СправочникСсылка.СтруктурныеЕдиницы") Тогда
		Возврат Получатель.АдресЭлектроннойПочты;
	КонецЕсли;	
	
КонецФункции	

&НаКлиенте
Процедура ПолучателиСотрудникПриИзменении(Элемент)
	
	Элементы.Получатели.ТекущиеДанные.Почта = ПолучитьПочтуПолучателя(Элементы.Получатели.ТекущиеДанные.Получатель);
	
КонецПроцедуры

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если ЗначениеЗаполнено(Параметры.ТТ) Тогда
		СтрокаДоб = Получатели.Добавить();
		СтрокаДоб.Получатель = Параметры.ТТ;
		СтрокаДоб.Почта = ПолучитьПочтуПолучателя(СтрокаДоб.Получатель);
		
		Запрос = Новый Запрос();
		Запрос.УстановитьПараметр("ТТ", Параметры.ТТ);
		Запрос.УстановитьПараметр("ТекДата", ТекущаяДата());
		Запрос.Текст = "ВЫБРАТЬ РАЗЛИЧНЫЕ
		               |	РолиПользователейСоставРоли.Сотрудник
		               |ИЗ
		               |	РегистрСведений.СоответствиеОбъектРоль.СрезПоследних(
		               |			&ТекДата,
					   //+++ AK suvv 2018.06.08 ИП-00018376.01
					   //|			ТипРоли = ЗНАЧЕНИЕ(ПланВидовХарактеристик.ТипыРолейПользователя.ПомощникТерриториальногоУправляющего)
					   |			(ТипРоли = ЗНАЧЕНИЕ(ПланВидовХарактеристик.ТипыРолейПользователя.ПомощникТерриториальногоУправляющего)
					   |            ИЛИ ТипРоли = ЗНАЧЕНИЕ(ПланВидовХарактеристик.ТипыРолейПользователя.ПомощникСтороннейРозницы))
					   //--- AK suvv
		               |				И Объект = &ТТ) КАК СоответствиеОбъектРольСрезПоследних
		               |		ВНУТРЕННЕЕ СОЕДИНЕНИЕ Справочник.РолиПользователей.СоставРоли КАК РолиПользователейСоставРоли
		               |		ПО СоответствиеОбъектРольСрезПоследних.РольПользователя = РолиПользователейСоставРоли.Ссылка";
					   
		Выборка = Запрос.Выполнить().Выбрать();
		Пока Выборка.Следующий() Цикл
			Если Получатели.НайтиСтроки(Новый Структура("Получатель", Выборка.Сотрудник)).Количество() = 0 Тогда
				СтрокаДоб = Получатели.Добавить();
				СтрокаДоб.Получатель = Выборка.Сотрудник;
				СтрокаДоб.Почта = ПолучитьПочтуПолучателя(СтрокаДоб.Получатель);
			КонецЕсли;	
		КонецЦикла;
		
		Запрос.Текст = "ВЫБРАТЬ РАЗЛИЧНЫЕ
		               |	РолиПользователейСоставРоли.Сотрудник
		               |ИЗ
		               |	РегистрСведений.СоответствиеОбъектРоль.СрезПоследних(
		               |			&ТекДата,
		               |			(ТипРоли = ЗНАЧЕНИЕ(ПланВидовХарактеристик.ТипыРолейПользователя.ПомощникТерриториальногоУправляющего)
					   //+++ AK suvv 2018.06.08 ИП-00018376.01
					   |            ИЛИ ТипРоли = ЗНАЧЕНИЕ(ПланВидовХарактеристик.ТипыРолейПользователя.ПомощникСтороннейРозницы))
					   //--- AK suvv
		               |				И Объект = &ТТ) КАК СоответствиеОбъектРольСрезПоследних
		               |		ВНУТРЕННЕЕ СОЕДИНЕНИЕ Справочник.РолиПользователей.СоставРоли КАК РолиПользователейСоставРоли
		               |		ПО СоответствиеОбъектРольСрезПоследних.РольПользователя.Родитель = РолиПользователейСоставРоли.Ссылка";
					   
		Выборка = Запрос.Выполнить().Выбрать();
		Пока Выборка.Следующий() Цикл
			Если Получатели.НайтиСтроки(Новый Структура("Получатель", Выборка.Сотрудник)).Количество() = 0 Тогда
				СтрокаДоб = Получатели.Добавить();
				СтрокаДоб.Получатель = Выборка.Сотрудник;
				СтрокаДоб.Почта = ПолучитьПочтуПолучателя(СтрокаДоб.Получатель);
			КонецЕсли;	
		КонецЦикла;
		
	КонецЕсли;
	
	ТемаПисьма = Параметры.ТемаПисьма;
	ТекстПисьма = Параметры.ТекстПисьма;
	
	ПочтаОтветственного = ПолучитьПочтуПолучателя(ПараметрыСеанса.ТекущийПользователь.ФизЛицо);
	ТекстПисьма = ТекстПисьма + Символы.ПС + Символы.ПС + "Ответственный: " + ПараметрыСеанса.ТекущийПользователь + Символы.ПС + ?(ЗначениеЗаполнено(ПочтаОтветственного), Символы.ПС + ПочтаОтветственного, "");
	
КонецПроцедуры

Процедура ОтправитьНаСервере()
	
	УчетнаяЗапись = ОбщиеПроцедуры.ПолучитьУчетнуюЗаписьДляРассылки();
	
	Почта = Новый ИнтернетПочта;
	Профиль = УправлениеЭлектроннойПочтой.ПолучитьИнтернетПочтовыйПрофиль(УчетнаяЗапись);
	Письмо = Новый ИнтернетПочтовоеСообщение;
	Почта.Подключиться(Профиль);
	Письмо.Тема = ТемаПисьма;
	Письмо.ИмяОтправителя = ""+УчетнаяЗапись+"";
	Письмо.ИмяОтправителя  = ""+СокрЛП(УчетнаяЗапись)+"";
	Письмо.Отправитель     = ""+СокрЛП(УчетнаяЗапись)+"";
	Для Каждого СтрокаПолучатель Из Получатели Цикл
		Если ЗначениеЗаполнено(СтрокаПолучатель.Почта) Тогда
			Получатель = Письмо.Получатели.Добавить();
			Получатель.Адрес           = СтрокаПолучатель.Почта;
			Получатель.ОтображаемоеИмя = СокрЛП(СтрокаПолучатель.Получатель);
		КонецЕсли;	
	КонецЦикла;
	
	ТекстСообщения = Письмо.Тексты.Добавить();
	ТекстСообщения.Текст     = ТекстПисьма;
	ТекстСообщения.ТипТекста = ТипТекстаПочтовогоСообщения.ПростойТекст;
	
	Почта.Послать(Письмо);
	Почта.Отключиться();
	
КонецПроцедуры	

&НаКлиенте
Процедура Отправить(Команда)
	
	ОтправитьНаСервере();
	Сообщить("Сообщение отправлено");
	
КонецПроцедуры
