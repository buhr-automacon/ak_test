﻿
&НаСервере
Процедура ДобавитьПризнакНоменклатуре(ПризнакУчета)
	
	Запрос = Новый Запрос();
	Запрос.Текст = "ВЫБРАТЬ РАЗЛИЧНЫЕ
	               |	НоменклатураПризнакиУчетаНоменклатуры.Ссылка
	               |ПОМЕСТИТЬ ВТ_ВБазе
	               |ИЗ
	               |	Справочник.Номенклатура.ПризнакиУчетаНоменклатуры КАК НоменклатураПризнакиУчетаНоменклатуры
	               |ГДЕ
	               |	НоменклатураПризнакиУчетаНоменклатуры.Признак = &Признак
	               |;
	               |
	               |////////////////////////////////////////////////////////////////////////////////
	               |ВЫБРАТЬ
	               |	Таб.Номенклатура
	               |ПОМЕСТИТЬ ВТ_ВФорме
	               |ИЗ
	               |	&Таб КАК Таб
	               |;
	               |
	               |////////////////////////////////////////////////////////////////////////////////
	               |ВЫБРАТЬ
	               |	ВТ_ВБазе.Ссылка КАК ВБазе,
	               |	ВТ_ВФорме.Номенклатура КАК ВФорме
	               |ИЗ
	               |	ВТ_ВБазе КАК ВТ_ВБазе
	               |		ПОЛНОЕ СОЕДИНЕНИЕ ВТ_ВФорме КАК ВТ_ВФорме
	               |		ПО ВТ_ВБазе.Ссылка = ВТ_ВФорме.Номенклатура";
				   
	Запрос.УстановитьПараметр("Признак", ПризнакУчета);
	Запрос.УстановитьПараметр("Таб", ТаблицаНоменклатура.Выгрузить());
	ТабОбработать = Запрос.Выполнить().Выгрузить();
	
	Для Каждого СтрокаТаб Из ТабОбработать Цикл
		Если СтрокаТаб.ВБазе = Null Тогда
			СпрОбъект = СтрокаТаб.ВФорме.ПолучитьОбъект();
			СтрокаДоб = СпрОбъект.ПризнакиУчетаНоменклатуры.Добавить();
			СтрокаДоб.Признак = ПризнакУчета;
			СпрОбъект.Записать();
		КонецЕсли;
		Если СтрокаТаб.ВФорме = Null Тогда
			СпрОбъект = СтрокаТаб.ВБазе.ПолучитьОбъект();
			СтрокаТаб = СпрОбъект.ПризнакиУчетаНоменклатуры.Найти(ПризнакУчета);
			Если СтрокаТаб <> Неопределено Тогда
				СпрОбъект.ПризнакиУчетаНоменклатуры.Удалить(СтрокаТаб);
			КонецЕсли;	
			СпрОбъект.Записать();
		КонецЕсли;
	КонецЦикла;	
	
КонецПроцедуры	

&НаКлиенте
Процедура ТаблицаНоменклатураПриОкончанииРедактирования(Элемент, НоваяСтрока, ОтменаРедактирования)
	
	Если ОтменаРедактирования Тогда
		Возврат;
	КонецЕсли;
	
	ДобавитьПризнакНоменклатуре(Элементы.Список.ТекущаяСтрока);
	
КонецПроцедуры

&НаКлиенте
Процедура ТаблицаНоменклатураПередНачаломДобавления(Элемент, Отказ, Копирование, Родитель, Группа)
	
	Если НЕ ЗначениеЗаполнено(Элементы.Список.ТекущаяСтрока) Тогда
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю("Не выбран признак учета номенклатуры");
		Отказ = Истина;
	КонецЕсли;	
	
КонецПроцедуры

&НаСервере
Процедура ПерезаполнитьНоменклатуру()
	
	ТаблицаНоменклатура.Очистить();
	
	Запрос = Новый Запрос();
	Запрос.Текст = "ВЫБРАТЬ
	               |	НоменклатураПризнакиУчетаНоменклатуры.Ссылка КАК Номенклатура
	               |ИЗ
	               |	Справочник.Номенклатура.ПризнакиУчетаНоменклатуры КАК НоменклатураПризнакиУчетаНоменклатуры
	               |ГДЕ
	               |	НоменклатураПризнакиУчетаНоменклатуры.Признак = &Признак
	               |
	               |УПОРЯДОЧИТЬ ПО
	               |	НоменклатураПризнакиУчетаНоменклатуры.Ссылка.Наименование";
				   
	Запрос.УстановитьПараметр("Признак", Элементы.Список.ТекущаяСтрока);
	
	ТаблицаНоменклатура.Загрузить(Запрос.Выполнить().Выгрузить());
	
КонецПроцедуры	

&НаКлиенте
Процедура СписокПриАктивизацииСтроки(Элемент)
	
	ПерезаполнитьНоменклатуру();
	
КонецПроцедуры

&НаКлиенте
Процедура ТаблицаНоменклатураПослеУдаления(Элемент)
	
	ДобавитьПризнакНоменклатуре(Элементы.Список.ТекущаяСтрока);
	
КонецПроцедуры
