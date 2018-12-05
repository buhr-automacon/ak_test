﻿
Перем ИсторияИзмененияРеквизитов; //+++АК SHEP 2018.10.26 ИП-00019584: сохраняем историю изменения реквизитов

Процедура ОбработкаПроверкиЗаполнения(Отказ, ПроверяемыеРеквизиты)
	
	Если НЕ ЗначениеЗаполнено(Наименование) Тогда
		Наименование = Строка(Номенклатура) + " (" + Строка(ХарактеристикаНоменклатуры) + ")";
	КонецЕсли;
	
КонецПроцедуры

Процедура ПередЗаписью(Отказ)
	
	Если НЕ Отказ Тогда
		ИсторияИзмененияРеквизитов = РегистрыСведений.ИсторияИзмененияРеквизитов.ЗаполнитьДанныеДляИстории(ЭтотОбъект, "Отключена");
	КонецЕсли;
	
КонецПроцедуры

Процедура ПриЗаписи(Отказ)
	
	Если ОбменДанными.Загрузка Тогда Возврат; КонецЕсли;	
	
	Если НЕ Отказ И ИсторияИзмененияРеквизитов.Количество() > 0 Тогда
		РегистрыСведений.ИсторияИзмененияРеквизитов.ЗаписатьИсторию(Ссылка, ИсторияИзмененияРеквизитов);
		
		// если отключили, должна возвращать товар в магазины, из которых убрала; убирать из магазинов, в которые добавила.
		Если ЭтотОбъект.Отключена Тогда
			 ВернутьАссортиментМагазинов();
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

Процедура ВернутьАссортиментМагазинов()
	
	Запрос = Новый Запрос(
		"ВЫБРАТЬ
		//|	АссортиментСплитТестирования.НоменклатураСплитТестирования,
		|	АссортиментСплитТестирования.ТорговаяТочка,
		|	СУММА(АссортиментСплитТестирования.Добавлен) КАК Добавлен
		|ИЗ
		|	РегистрСведений.АссортиментСплитТестирования КАК АссортиментСплитТестирования
		|ГДЕ
		|	АссортиментСплитТестирования.НоменклатураСплитТестирования = &НоменклатураСплитТестирования
		|
		|СГРУППИРОВАТЬ ПО
		|	АссортиментСплитТестирования.НоменклатураСплитТестирования,
		|	АссортиментСплитТестирования.ТорговаяТочка
		|
		|ИМЕЮЩИЕ
		|	СУММА(АссортиментСплитТестирования.Добавлен) <> 0");
	Запрос.УстановитьПараметр("НоменклатураСплитТестирования", ЭтотОбъект.Ссылка);
	
	РезультатЗапроса = Запрос.Выполнить();
	Если РезультатЗапроса.Пустой() Тогда Возврат; КонецЕсли;
	
	ДатаЗаписиРС = НачалоДня(ТекущаяДата());
	МенеджерЗаписиТАТ = РегистрыСведений.ТоварныйАссортиментТочек.СоздатьМенеджерЗаписи();
	МенеджерЗаписиАСТ = РегистрыСведений.АссортиментСплитТестирования.СоздатьМенеджерЗаписи();
	
	СтруктураОтбор = Новый Структура("Период,Номенклатура,Характеристика,НоменклатураСплитТестирования", ДатаЗаписиРС, Номенклатура, ХарактеристикаНоменклатуры, Ссылка);
	
	ВыборкаЗапроса = РезультатЗапроса.Выбрать();
	Пока ВыборкаЗапроса.Следующий() Цикл
		
		ДобавленаТТ = ВыборкаЗапроса.Добавлен;
		ТекТорговаяТочка = ВыборкаЗапроса.ТорговаяТочка;
		СтруктураОтбор.Вставить("ТорговаяТочка", ТекТорговаяТочка);
		
		// возвращаем ТоварныйАссортиментТочек
		ЗаполнитьЗначенияСвойств(МенеджерЗаписиТАТ, СтруктураОтбор);
		МенеджерЗаписиТАТ.Прочитать();
		
		Если НЕ МенеджерЗаписиТАТ.Выбран() Тогда
			ЗаполнитьЗначенияСвойств(МенеджерЗаписиТАТ, СтруктураОтбор);
		КонецЕсли;
		
		Если ДобавленаТТ > 0 Тогда
			МенеджерЗаписиТАТ.Выведена = Истина;
			МенеджерЗаписиТАТ.Комментарий = "Сплит-тестирование товаров: убрали добавленный ассортимент";
		Иначе
			МенеджерЗаписиТАТ.Выведена = Ложь;
			МенеджерЗаписиТАТ.Комментарий = "Сплит-тестирование товаров: вернули удалённый ассортимент";
		КонецЕсли;
		
		МенеджерЗаписиТАТ.Записать();
		
		// возвращаем АссортиментСплитТестирования
		ЗаполнитьЗначенияСвойств(МенеджерЗаписиАСТ, СтруктураОтбор);
		МенеджерЗаписиАСТ.Прочитать();
		
		Если НЕ МенеджерЗаписиАСТ.Выбран() Тогда
			ЗаполнитьЗначенияСвойств(МенеджерЗаписиАСТ, СтруктураОтбор);
		КонецЕсли;
		
		МенеджерЗаписиАСТ.Добавлен = -ДобавленаТТ;
		
		МенеджерЗаписиАСТ.Записать();
		
	КонецЦикла;
	
КонецПроцедуры
