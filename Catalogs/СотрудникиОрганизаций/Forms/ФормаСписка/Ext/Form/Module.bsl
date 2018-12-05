﻿
&НаКлиенте
Процедура СинхронизироватьСЗУП(Команда)
	
	СинхронизироватьСЗУПСервер();
	
	////+++ АК gusd (ИП-00013992)
	//
	//// Установим/Снимем флаг Активный у физ. лиц
	//ТаблицаИзменений = ПолучитьТаблицуИзмененийАктивностиФизЛицНаСервере();
	//
	//Если ТаблицаИзменений.Количество() > 0 Тогда
	//	
	//	Состояние("Выполняется снятие флага активности у физических лиц...");
	//	
	//	ОбработатьТаблицуИзмененийНаСервере(ТаблицаИзменений);
	//	
	//	// отказались от открытия формы
	//	
	//	//ПараметрыОткрытия = Новый Структура;
	//	//ПараметрыОткрытия.Вставить("Состав", ТаблицаИзменений);
	//	//
	//	//ОткрытьФорму("Справочник.СотрудникиОрганизаций.Форма.ФормаИзмененияАктивностиФизЛиц", ПараметрыОткрытия, ЭтаФорма);
	//	
	//КонецЕсли;
	//
	////--- АК gusd (ИП-00013992)
	
КонецПроцедуры

&НаСервере
Процедура СинхронизироватьСЗУПСервер()
	
	Обработки.ЗагрузкаДанныхИзAccess.ЗагрузитьДанныеОСотрудниках();
	
КонецПроцедуры

&НаСервере
Функция ПолучитьТаблицуИзмененийАктивностиФизЛицНаСервере()
	
	Возврат Справочники.СотрудникиОрганизаций.ПолучитьТаблицуИзмененийАктивностиФизЛиц();
	
КонецФункции

&НаСервереБезКонтекста
Процедура ОбработатьТаблицуИзмененийНаСервере(ТаблицаИзменений)
	
	Для Каждого Стр Из ТаблицаИзменений Цикл
		
		ФЛОбъект = Стр.ФизЛицо.ПолучитьОбъект();
		ФЛОбъект.Активный = Стр.Активный;
		
		Попытка
			ФЛОбъект.Записать();
		Исключение
			Сообщить("Не удалось изменить флаг ""Ативный"" у физического лица " + Строка(ФЛОбъект));
		КонецПопытки;
		
	КонецЦикла;
	
КонецПроцедуры

//+++АК POZM 2018.04.26 ИП-00018136
&НаКлиенте
Процедура Стажёры(Команда)
	Физик = Элементы.Список.ТекущаяСтрока.ФизЛицо;
	ОткрытьФорму("РегистрСведений.СтажерыПредприятия.ФормаСписка",Новый Структура("Отбор",Новый Структура("Наставник",Физик)));
КонецПроцедуры
//---АК POZM 


