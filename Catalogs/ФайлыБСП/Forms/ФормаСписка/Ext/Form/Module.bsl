﻿
&НаКлиенте
Процедура СписокВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	СтандартнаяОбработка = Ложь;
	РаботаСФайламиКлиент.ОткрытьФайл(
		РаботаСФайламиВызовСервера.ПолучитьДанныеФайлаДляОткрытия(Элементы.Список.ТекущаяСтрока, Неопределено, УникальныйИдентификатор)); 
КонецПроцедуры

&НаКлиенте
Процедура СписокПередНачаломДобавления(Элемент, Отказ, Копирование, Родитель, Группа)
	Отказ = Истина;
КонецПроцедуры

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Список.Параметры.УстановитьЗначениеПараметра(
		"ТекущийПользователь", Пользователи.ТекущийПользователь());
	
	РаботаСФайламиВызовСервера.ЗаполнитьУсловноеОформлениеСпискаФайлов(Список);
	
	Если РаботаСФайламиВызовСервера.ПолучитьИспользоватьЭлектронныеЦифровыеПодписиИШифрование() = Ложь Тогда
		Элементы.ПодписанЭЦП.Видимость = Ложь;
		Элементы.Зашифрован.Видимость = Ложь;
	КонецЕсли;	
	
КонецПроцедуры

// Доступны файловые команды - есть хотя бы одна строка в списке и выделена не группировка
&НаКлиенте
Функция ФайловыеКомандыДоступны()
	
	Если Элементы.Список.ТекущаяСтрока = Неопределено Тогда 
		Возврат Ложь;
	КонецЕсли;
	
	Если ТипЗнч(Элементы.Список.ТекущаяСтрока) = Тип("СтрокаГруппировкиДинамическогоСписка") Тогда
		Возврат Ложь;
	КонецЕсли;	
	
	Возврат Истина;
	
КонецФункции

&НаКлиенте
Процедура Просмотреть(Команда)
	Если Не ФайловыеКомандыДоступны() Тогда 
		Возврат;
	КонецЕсли;
	
	ДанныеФайла = РаботаСФайламиВызовСервера.ПолучитьДанныеФайлаДляОткрытия(Элементы.Список.ТекущаяСтрока, Неопределено, УникальныйИдентификатор);
	КомандыРаботыСФайламиКлиент.Открыть(ДанныеФайла);
КонецПроцедуры


&НаКлиенте
Процедура СохранитьКак(Команда)
	
	Если Не ФайловыеКомандыДоступны() Тогда 
		Возврат;
	КонецЕсли;
	
	ДанныеФайла = РаботаСФайламиВызовСервера.ПолучитьДанныеФайлаДляСохранения(Элементы.Список.ТекущаяСтрока, Неопределено, УникальныйИдентификатор);
	КомандыРаботыСФайламиКлиент.СохранитьКак(ДанныеФайла);
	
КонецПроцедуры

&НаКлиенте
Процедура Освободить(Команда)
	Если Не ФайловыеКомандыДоступны() Тогда 
		Возврат;
	КонецЕсли;
	
	КомандыРаботыСФайламиКлиент.ОсвободитьФайл(
		Элементы.Список.ТекущаяСтрока,
		Элементы.Список.ТекущиеДанные.ХранитьВерсии,
		Элементы.Список.ТекущиеДанные.РедактируетТекущийПользователь,
		Элементы.Список.ТекущиеДанные.Редактирует);
		
	УстановитьДоступностьФайловыхКомманд();		
КонецПроцедуры

&НаКлиенте
Процедура СписокПриАктивизацииСтроки(Элемент)
	УстановитьДоступностьФайловыхКомманд();
КонецПроцедуры

&НаКлиенте
Процедура УстановитьДоступностьФайловыхКомманд()
	
	Если Элементы.Список.ТекущиеДанные <> Неопределено Тогда
		
		Если ТипЗнч(Элементы.Список.ТекущаяСтрока) <> Тип("СтрокаГруппировкиДинамическогоСписка") Тогда
			
				УстановитьДоступностьКомманд(Элементы.Список.ТекущиеДанные.РедактируетТекущийПользователь,
					Элементы.Список.ТекущиеДанные.Редактирует);
		КонецЕсли;	
			
	КонецЕсли;	
КонецПроцедуры


&НаКлиенте
Процедура УстановитьДоступностьКомманд(РедактируетТекущийПользователь, Редактирует)
	Элементы.Освободить.Доступность = Не Редактирует.Пустая();
	Элементы.СписокКонтекстноеМеню.ПодчиненныеЭлементы.КонтекстноеМенюСписокОсвободить.Доступность = Не Редактирует.Пустая();
КонецПроцедуры


&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	
	Если ИмяСобытия = "ИмпортФайловЗавершен" Тогда
		Элементы.Список.Обновить();
		
		Если Параметр <> Неопределено Тогда
			Элементы.Список.ТекущаяСтрока = Параметр;
		КонецЕсли;
	КонецЕсли;
	
	Если ИмяСобытия = "ИмпортКаталоговЗавершен" Тогда
		Элементы.Список.Обновить();
	КонецЕсли;

	Если ИмяСобытия = "Запись_Файл" И Параметр.Событие = "СозданФайл" Тогда
		Элементы.Список.Обновить();
		Если Параметр <> Неопределено И Параметр.Файл <> Неопределено Тогда
			Элементы.Список.ТекущаяСтрока = Параметр.Файл;
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

