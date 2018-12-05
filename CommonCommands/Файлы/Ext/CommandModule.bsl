﻿
&НаКлиенте
Процедура ОбработкаКоманды(ПараметрКоманды, ПараметрыВыполненияКоманды)
	
	Ссылка = ПараметрКоманды;
	
	Если Ссылка.Пустая() Тогда
		Предупреждение("Сначала запишите документ.");
		Возврат;
	КонецЕсли;

	ФормаФайлов = ПолучитьФорму("ОбщаяФорма.ФормаСпискаФайловИИзображений");
	
	ФормаФайлов.Изображения.Отбор.Объект.Использование                               = Истина;
	ФормаФайлов.Изображения.Отбор.Объект.Значение                                    = Ссылка;
	ФормаФайлов.ЭлементыФормы.Изображения.НастройкаОтбора.Объект.Доступность         = Ложь;
	ФормаФайлов.ЭлементыФормы.Изображения.Колонки.Объект.Видимость                   = Ложь;

	ФормаФайлов.ДополнительныеФайлы.Отбор.Объект.Использование                       = Истина;
	ФормаФайлов.ДополнительныеФайлы.Отбор.Объект.Значение                            = Ссылка;
	ФормаФайлов.ЭлементыФормы.ДополнительныеФайлы.НастройкаОтбора.Объект.Доступность = Ложь;
	ФормаФайлов.ЭлементыФормы.ДополнительныеФайлы.Колонки.Объект.Видимость           = Ложь;

	ОбязательныеОтборы = Новый Структура;
	ОбязательныеОтборы.Вставить("Объект",Ссылка);

	ФормаФайлов.ОбязательныеОтборы = ОбязательныеОтборы;
	
	ФормаФайлов.Открыть();
КонецПроцедуры
