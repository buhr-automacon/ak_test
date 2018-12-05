﻿&НаСервере
Функция ПолучитьРасшифровкуНаСервере(Расшифровка)
	Данные = ПолучитьИзВременногоХранилища(ДанныеРасшифровки);
	Строка = Расшифровка;
	ПолеКонтрагент = Неопределено;
	ПолеСчет = Неопределено;
	ПолеОрганизация = Неопределено;
	Пока Число(Строка) >=0 Цикл
		Элемент = Данные.Элементы.Получить(Строка);
		Строка = Строка-1;
		Если ТипЗнч(Элемент)<>Тип("ЭлементРасшифровкиКомпоновкиДанныхПоля") Тогда
			Продолжить
		КонецЕсли;
		Поля = Элемент.ПолучитьПоля();
		Если ПолеКонтрагент=Неопределено Тогда
			ПолеКонтрагент = Поля.Найти("Контрагент");
		КонецЕсли;
		Если ПолеСчет=Неопределено Тогда
			ПолеСчет = Поля.Найти("Счет");
		КонецЕсли;
		Если ПолеОрганизация=Неопределено Тогда
			ПолеОрганизация = Поля.Найти("Организация");
		КонецЕсли;
		Если ПолеКонтрагент<>Неопределено и ПолеСчет <>Неопределено и ПолеОрганизация<>Неопределено Тогда
			Прервать
		КонецЕсли;
	КонецЦикла;
	Значения = Новый Соответствие;
	Если ПолеКонтрагент<>Неопределено Тогда
		Значения.Вставить("Контрагент",ПолеКонтрагент.Значение);
	КонецЕсли;
	Если ПолеСчет<>Неопределено Тогда
		Значения.Вставить("Счет",ПолеСчет.Значение);
	КонецЕсли;
	Если ПолеОрганизация<>Неопределено Тогда
		Значения.Вставить("Организация",ПолеОрганизация.Значение);
	КонецЕсли;	
	Возврат Значения;
	
КонецФункции

// +++АК Зайцева А. задача 14301
&НаКлиенте
Процедура РезультатОбработкаРасшифровки(Элемент, Расшифровка, СтандартнаяОбработка)
	
	
	Если ТипЗнч(Расшифровка)= Тип("ИдентификаторРасшифровкиКомпоновкиДанных") Тогда
		
		СтандартнаяОбработка = Ложь;
		
		Поля = ПолучитьРасшифровкуНаСервере(Расшифровка);
		ОтборР = Новый Структура;
		Для Каждого Элемент из Поля Цикл
			ОтборР.Вставить(Элемент.Ключ,Элемент.Значение)
		КонецЦикла;
		ПараметрыР = Новый Структура("СформироватьПриОткрытии,Отбор,КлючВарианта",Истина,ОтборР,"ДляРасшифровки");
		ОткрытьФорму("Отчет.ЗаявкиБезПоступлений.Форма.ФормаОтчета",ПараметрыР,ЭтаФорма);
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура РезультатПриИзмененииСодержимогоОбласти(Элемент, Область)
	
	Комментарий = СокрЛП(Область.Текст);
	Контрагент = Неопределено;
	Документ = Неопределено;
	
	Ряд = Область.Верх - 1;
	Пока Ряд >= Результат.ФиксацияСверху + 1  Цикл
		Для Колонка = Результат.ФиксацияСлева + 1 По Результат.ШиринаТаблицы Цикл 
			ИскомаяОбласть = Результат.Область(Ряд, Колонка, Ряд, Колонка);
			
			Если ИскомаяОбласть.Расшифровка <> Неопределено И ТипЗнч(ИскомаяОбласть.Расшифровка) = Тип("СправочникСсылка.Контрагенты") Тогда
				Контрагент = ИскомаяОбласть.Расшифровка;
				Ряд = Результат.ФиксацияСверху;
				Прервать;
			КонецЕсли;
		КонецЦикла;
		Ряд = Ряд - 1;
	КонецЦикла;
	
	Для Колонка = Результат.ФиксацияСлева + 1 По Результат.ШиринаТаблицы Цикл 
		ИскомаяОбласть = Результат.Область(Область.Верх, Колонка, Область.Низ, Колонка);
		
		Если ИскомаяОбласть.Расшифровка <> Неопределено И ЭтоДокумент(ТипЗнч(ИскомаяОбласть.Расшифровка)) Тогда
			Документ = ИскомаяОбласть.Расшифровка;
			Прервать;
		КонецЕсли;
	КонецЦикла;
	
	Если Контрагент <> Неопределено И Документ <> Неопределено Тогда 
		Если НужноСоздатьЗаписьРегистра(Контрагент, Документ, Комментарий) Тогда 
			ДатаСоздания = СоздатьЗаписьРегистра(Контрагент, Документ, Комментарий);
			Если ЗначениеЗаполнено(ДатаСоздания) Тогда 
				Для Колонка = Результат.ФиксацияСлева + 1 По Результат.ШиринаТаблицы Цикл 
					ИскомаяОбласть = Результат.Область(Область.Верх, Колонка, Область.Низ, Колонка);
					
					Если ИскомаяОбласть.Расшифровка <> Неопределено И ТипЗнч(ИскомаяОбласть.Расшифровка) = Тип("Дата") Тогда
						ИскомаяОбласть.Текст = Строка(ДатаСоздания);
						ИскомаяОбласть.Расшифровка = ДатаСоздания;
						Прервать;
					КонецЕсли;
				КонецЦикла;
			КонецЕсли;
		КонецЕсли;
	Иначе
		Сообщить("В отчете нет поля Контрагент или поля Регистратор. Запись комментария в регистр не будет выполнена."); 
	КонецЕсли;
КонецПроцедуры

&НаСервере
Функция СоздатьЗаписьРегистра(Контрагент, Документ, Комментарий)
	НаборЗаписей = РегистрыСведений.АК_КомментарииКДебЗадолженности.СоздатьНаборЗаписей();
	НаборЗаписей.Отбор.Контрагент.Установить(Контрагент);
	НаборЗаписей.Отбор.ДокументЗадолженности.Установить(Документ);
	НаборЗаписей.Прочитать();
	
	Если НаборЗаписей.Количество() = 0 Тогда 
		Если ЗначениеЗаполнено(Комментарий) Тогда 
			НоваяЗапись = НаборЗаписей.Добавить();
			НоваяЗапись.Контрагент = Контрагент;
			НоваяЗапись.ДокументЗадолженности = Документ;
		Иначе
			Возврат Дата(1, 1, 1);
		КонецЕсли;
	Иначе
		НоваяЗапись = НаборЗаписей[0];
	КонецЕсли;
	НоваяЗапись.Комментарий = Комментарий;
	НоваяЗапись.Период = ТекущаяДата();
	НаборЗаписей.Записать();
	
	Возврат НоваяЗапись.Период;
КонецФункции

&НаСервере
Функция НужноСоздатьЗаписьРегистра(Контрагент, Документ, Комментарий)
	Запрос = Новый Запрос;
	Запрос.Текст = "ВЫБРАТЬ
	               |	АК_КомментарииКДебЗадолженностиСрезПоследних.Контрагент
	               |ИЗ
	               |	РегистрСведений.АК_КомментарииКДебЗадолженности.СрезПоследних(
	               |			,
	               |			Контрагент = &Контрагент
	               |				И Комментарий = &Комментарий
	               |				И ДокументЗадолженности = &ДокументЗадолженности) КАК АК_КомментарииКДебЗадолженностиСрезПоследних";
	Запрос.УстановитьПараметр("Контрагент", Контрагент);
	Запрос.УстановитьПараметр("ДокументЗадолженности", Документ);
	Запрос.УстановитьПараметр("Комментарий", Комментарий);
	
	РезультатЗапроса = Запрос.Выполнить();
	
	Если РезультатЗапроса.Пустой() Тогда 
		Возврат Истина;
	Иначе
		Возврат Ложь;
	КонецЕсли;
КонецФункции

&НаСервере
Функция ЭтоДокумент(Расшифровка)
	Возврат Документы.ТипВсеСсылки().СодержитТип(Расшифровка);
КонецФункции
// ---АК