﻿
Процедура ПроверитьПоПравам(Отказ)
	
	Если НЕ УправлениеДопПравамиПользователей.ПолучитьПравоПользователяУпр(ПланыВидовХарактеристик.ПраваПользователей.ПолныеПраваПоРекламнымМатериалам, Ложь) Тогда
		Возврат;
	КонецЕсли;
	
	//
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("Товары", ЭтотОбъект.ВыгрузитьКолонку("Номенклатура"));
	Запрос.Текст =
	"ВЫБРАТЬ
	|	Номенклатура.Ссылка
	|ИЗ
	|	Справочник.Номенклатура КАК Номенклатура
	|ГДЕ
	|	Номенклатура.Ссылка В(&Товары)
	|	И НЕ Номенклатура.РекламныйМатериал";

	РезультатЗапроса = Запрос.Выполнить();
	Если НЕ РезультатЗапроса.Пустой() Тогда
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю("Нет прав на редактирование записей для не рекламных материалов",,,, Отказ);
	КонецЕсли;	
	
	
КонецПроцедуры


Процедура ПередЗаписью(Отказ, Замещение)
	
	//Если УправлениеДопПравамиПользователей.ПолучитьПравоПользователяУпр(ПланыВидовХарактеристик.ПраваПользователей.РедактированиеРегистраДоступностьТоваров, Ложь) = Ложь Тогда
	//	ОбщегоНазначенияКлиентСервер.СообщитьПользователю("Нет прав на редактирование регистра доступности товаров на складах",,,, Отказ);
	//КонецЕсли;
	
	//
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("Товары", ЭтотОбъект.ВыгрузитьКолонку("Номенклатура"));
	Запрос.Текст =
	"ВЫБРАТЬ
	|	Номенклатура.Ссылка
	|ИЗ
	|	Справочник.Номенклатура КАК Номенклатура
	|ГДЕ
	|	Номенклатура.ЭтоГруппа = ИСТИНА
	|	И Номенклатура.Ссылка В(&Товары)";

	Выборка = Запрос.Выполнить().Выбрать();
	Если Выборка.Количество() > 0 Тогда
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю("Нельзя добавлять записи с группой товаров в номенклатуре",,,, Отказ);
		Пока Выборка.Следующий() Цикл
			Сообщить(Выборка.Ссылка);
		КонецЦикла;	
	КонецЕсли;	
	
	//
	//ПроверитьПоПравам(Отказ);  //+++АК LAGP 2018.04.14 // Склад Северный, Полещук Валерий. Не получается изменить доступность десерта на складах, раньше права были у всех, сейчас у всех ругается на рекламный материал.
	
КонецПроцедуры
