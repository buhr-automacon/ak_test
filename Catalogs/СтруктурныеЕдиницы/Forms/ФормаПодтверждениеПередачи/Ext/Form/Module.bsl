﻿//+++AK GREK 01.12.2017 ИП-00015325.02
//Форма для подтверждения передачи магазинов. На почту управляющему приходит уведомление
//о передающихся магазинах и ссылка, нажав на которую он попадет в вэб клиент 1с, 
//где ему откроется эта форма

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	Запрос = новый запрос;
	Запрос.Текст = "ВЫБРАТЬ РАЗРЕШЕННЫЕ
	               |	СтруктурныеЕдиницы.Ссылка КАК ТорговаяТочка,
	               |	СтруктурныеЕдиницы.МагазинПередан КАК Передан
	               |ИЗ
	               |	Справочник.СтруктурныеЕдиницы КАК СтруктурныеЕдиницы
	               |ГДЕ
	               |	СтруктурныеЕдиницы.ТипСтруктурнойЕдиницы = ЗНАЧЕНИЕ(Перечисление.ТипыСтруктурныхЕдиниц.Розница)
	               |	И СтруктурныеЕдиницы.СтатусТорговойТочки <> ЗНАЧЕНИЕ(Перечисление.СтатусыТорговыхТочек.Закрыт)
	               |	И (СтруктурныеЕдиницы.ДатаОткрытия = ДАТАВРЕМЯ(1, 1, 1)
	               |			ИЛИ СтруктурныеЕдиницы.ДатаОткрытия >= &Дата
	               |			ИЛИ СтруктурныеЕдиницы.МагазинПередан = ЛОЖЬ
	               |				И СтруктурныеЕдиницы.ДатаНачалаПередачи <> ДАТАВРЕМЯ(1, 1, 1))
	               |	И СтруктурныеЕдиницы.ТипРозничнойТочки <> ЗНАЧЕНИЕ(Перечисление.ТипыРозничныхТочек.ПустаяСсылка)
	               |	И НЕ СтруктурныеЕдиницы.ПометкаУдаления
	               |	И НЕ СтруктурныеЕдиницы.ПомощникУправляющего ЕСТЬ NULL
	               |	И СтруктурныеЕдиницы.ПомощникУправляющего = &Управляющий";
	Запрос.УстановитьПараметр("Дата", ТекущаяДата());
	ТекПользователь = Справочники.Пользователи.НайтиПоРеквизиту("ИдентификаторПользователяИБ",ПользователиИнформационнойБазы.ТекущийПользователь().УникальныйИдентификатор);
	Запрос.УстановитьПараметр("Управляющий",ТекПользователь.ФизЛицо);
	Рез = Запрос.Выполнить();
	Если НЕ Рез.Пустой() Тогда
		Магазины.Загрузить(Рез.Выгрузить());	
	КонецЕсли;
КонецПроцедуры

&НаСервере
Процедура ПодтвердитьПередачуНаСервере()
	Для каждого Стр из Магазины цикл
		Если Стр.ТорговаяТочка.МагазинПередан <> Стр.Передан	Тогда
			Магазин = Стр.ТорговаяТочка.ПолучитьОбъект();
			Магазин.МагазинПередан = Стр.Передан;
			Магазин.Записать();
		КонецЕсли;
	КонецЦикла;
КонецПроцедуры

&НаКлиенте
Процедура ПодтвердитьПередачу(Команда)
	ПодтвердитьПередачуНаСервере();
КонецПроцедуры
