﻿//+++АК sole 2018.09.05 ИП-00018241
&НаКлиенте
Перем ФормаРодитель Экспорт;

//+++АК sole 2018.09.06 ИП-00018241
&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	ЭтаФорма.Элементы.кнОк.Доступность = Ложь;
КонецПроцедуры

//+++АК sole 2018.09.06 ИП-00018241
&НаКлиенте
Процедура ИмяФайлаНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	СтандартнаяОбработка = Ложь;
	
	Диалог = Новый ДиалогВыбораФайла(РежимДиалогаВыбораФайла.Открытие);
	Диалог.Заголовок = "Выберите файл";
	Диалог.ПолноеИмяФайла = ""; 
	Диалог.Фильтр = "Файлы сертификатов (*.cer)|*.cer"; 
	Диалог.ИндексФильтра = 0;
    Диалог.МножественныйВыбор = Ложь;
	Оповещение = Новый ОписаниеОповещения("ИмяФайлаНачалоВыбораЗавершение", ЭтаФорма);
	Диалог.Показать(Оповещение);
	
КонецПроцедуры

//+++АК sole 2018.09.06 ИП-00018241
&НаКлиенте
Процедура ИмяФайлаНачалоВыбораЗавершение(Результат, ДополнительныеПараметры) Экспорт
    Если Результат = Неопределено Тогда
        Возврат;
    КонецЕсли;
    
    ЭтаФорма.ИмяФайла = Результат[0];
	ЭтаФорма.Элементы.кнОк.Доступность = Истина;
	
КонецПроцедуры

//+++АК sole 2018.09.05 ИП-00018241
&НаКлиенте
Процедура ДействиеОк(Команда)
	
	дд = Новый ДвоичныеДанные(ЭтаФорма.ИмяФайла);
	
	ФормаРодитель.ЗаполнитьСертификатВСтроке
		(
			ЭтаФорма.ИдентификаторСтроки,  
			Base64Строка(дд)
		);
		
	ЭтаФорма.Закрыть();
	
КонецПроцедуры

//+++АК sole 2018.09.06 ИП-00018241
&НаКлиенте
Процедура ДействиеОтмена(Команда)
	ЭтаФорма.Закрыть();
КонецПроцедуры


//