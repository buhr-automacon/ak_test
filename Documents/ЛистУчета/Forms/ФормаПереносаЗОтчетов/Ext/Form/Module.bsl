﻿
&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	УстановитьПривилегированныйРежим(Истина);
	
	Дата = Параметры.Дата;
	ТорговаяТочка = Параметры.ТорговаяТочка;
	Организация = Параметры.Организация;
	ТабЗВЛисте = ЗначениеИзСтрокиВнутр(Параметры.ТаблицаЗОтчетыВЛисте);
	Выручка = ЗначениеИзСтрокиВнутр(Параметры.Выручка);
	ОплатыПоБанковскимКартам = ЗначениеИзСтрокиВнутр(Параметры.ОплатыПоБанковскимКартам);
	
	Если ТорговаяТочка.ТипРозничнойТочки = Перечисления.ТипыРозничныхТочек.Избенка Тогда
		СтрСоединенияДанныеТовародвижение = ОбменСAccess.ПолучитьСтрокуСоединения("sms_izbenka");
		
		пСоед = Новый ПараметрыСоединенияВнешнегоИсточникаДанных;
		пСоед.СтрокаСоединения= СтрСоединенияДанныеТовародвижение;
		ВнешниеИсточникиДанных.SMS_Izbenka.УстановитьОбщиеПараметрыСоединения(пСоед);
		ВнешниеИсточникиДанных.SMS_Izbenka.УстановитьСоединение();
		
		Запрос = Новый Запрос();
		Запрос.Текст = "ВЫБРАТЬ
		               |	dbo_Shifts.CashID,
		               |	СУММА(dbo_Checks.BaseSum) КАК BaseSum,
		               |	СУММА(dbo_Checks.SummBonus) КАК SummBonus,
		               |	СУММА(dbo_Checks.SummBank) КАК SummBank
		               |ИЗ
		               |	ВнешнийИсточникДанных.SMS_Izbenka.Таблица.dbo_Shifts КАК dbo_Shifts
		               |		ВНУТРЕННЕЕ СОЕДИНЕНИЕ ВнешнийИсточникДанных.SMS_Izbenka.Таблица.dbo_Checks КАК dbo_Checks
		               |		ПО dbo_Shifts.ShiftUID = dbo_Checks.ShiftUID
		               |ГДЕ
		               |	ДОБАВИТЬКДАТЕ(dbo_Shifts.CloseDateTime, СЕКУНДА, -dbo_Shifts.Second_lag) >= &ДатаНач
		               |	И ДОБАВИТЬКДАТЕ(dbo_Shifts.CloseDateTime, СЕКУНДА, -dbo_Shifts.Second_lag) <= &ДатаКон
		               |	И dbo_Checks.OperationType > 0
		               |	И dbo_Checks.BaseSum - dbo_Checks.SummBonus > 0
		               |	И dbo_Checks.ShopNo = &ShopNo
		               |
		               |СГРУППИРОВАТЬ ПО
		               |	dbo_Shifts.CashID
		               |;
		               |
		               |////////////////////////////////////////////////////////////////////////////////
		               |ВЫБРАТЬ
		               |	ОсновныеСредства.Ссылка,
		               |	ОсновныеСредства.ЗаводскойНомер,
		               |	ВЫБОР
		               |		КОГДА ОсновныеСредства.Наименование ПОДОБНО &ККМ
		               |			ТОГДА ВЫБОР
		               |					КОГДА ОсновныеСредства.ДатаПереходаЧПМВККМ <> ДАТАВРЕМЯ(1, 1, 1)
		               |							И ОсновныеСредства.ДатаПереходаЧПМВККМ > &ДатаНач
		               |						ТОГДА ЛОЖЬ
		               |					ИНАЧЕ ИСТИНА
		               |				КОНЕЦ
		               |		ИНАЧЕ ЛОЖЬ
		               |	КОНЕЦ КАК ЭтоККМ,
		               |	ВЫБОР
		               |		КОГДА ОсновныеСредства.Наименование ПОДОБНО &ЧПМ
		               |			ТОГДА ИСТИНА
		               |		ИНАЧЕ ВЫБОР
		               |				КОГДА ОсновныеСредства.ДатаПереходаЧПМВККМ <> ДАТАВРЕМЯ(1, 1, 1)
		               |						И ОсновныеСредства.ДатаПереходаЧПМВККМ > &ДатаНач
		               |					ТОГДА ИСТИНА
		               |				ИНАЧЕ ЛОЖЬ
		               |			КОНЕЦ
		               |	КОНЕЦ КАК ЭтоЧПМ
		               |ИЗ
		               |	Справочник.ОсновныеСредства КАК ОсновныеСредства
		               |ГДЕ
		               |	(ОсновныеСредства.Наименование ПОДОБНО &ККМ
		               |			ИЛИ ОсновныеСредства.Наименование ПОДОБНО &ЧПМ)";
		
		Запрос.УстановитьПараметр("ShopNo", ТорговаяТочка.НомерТочки);
		Запрос.УстановитьПараметр("ДатаНач", НачалоДня(Дата));
		Запрос.УстановитьПараметр("ДатаКон", КонецДня(Дата));
		Запрос.УстановитьПараметр("ККМ", "%ККМ%");
		Запрос.УстановитьПараметр("ЧПМ", "%ЧПМ%");
		
		Результаты = Запрос.ВыполнитьПакет();
		ТабКешККМ = Результаты[1].Выгрузить();
		Выборка = Результаты[0].Выбрать();
		
		ВнешниеИсточникиДанных.SMS_Izbenka.РазорватьСоединение();
		
		ОргСП = Справочники.Организации.НайтиПоКоду("000000003");
		
		Пока Выборка.Следующий() Цикл
			Если Организация = ОргСП Тогда
				СтрокиККМ = ТабКешККМ.НайтиСтроки(Новый Структура("ЗаводскойНомер, ЭтоЧПМ", Формат(Выборка.CashID, "ЧРГ=; ЧГ=0"), Истина));
			Иначе
				СтрокиККМ = ТабКешККМ.НайтиСтроки(Новый Структура("ЗаводскойНомер, ЭтоККМ", Формат(Выборка.CashID, "ЧРГ=; ЧГ=0"), Истина));
			КонецЕсли;
			Если СтрокиККМ.Количество() = 0 Тогда
				СтрокиККМ = ТабКешККМ.НайтиСтроки(Новый Структура("ЗаводскойНомер", Формат(Выборка.CashID, "ЧРГ=; ЧГ=0")));
			КонецЕсли;	
			Если СтрокиККМ.Количество() > 0 Тогда
				СтрокаВЛисте = ТабЗВЛисте.Найти(СтрокиККМ[0].Ссылка, "Касса");
				Если СтрокаВЛисте = Неопределено Тогда
					СтрокаДоб = ТаблицаДанных.Добавить();
					СтрокаДоб.Касса = СтрокиККМ[0].Ссылка;
					СтрокаДоб.СуммаПоНал = Выборка.BaseSum - Выборка.SummBonus - Выборка.SummBank;
					СтрокаДоб.СуммаПоБезнал = Выборка.SummBank;
				КонецЕсли;	
			КонецЕсли;	
		КонецЦикла;
	Иначе
		ТабКеш = Документы.ЛистУчета.ПересчитатьТаблицуЗОтчетов(Выручка.Выгрузить(), ОплатыПоБанковскимКартам.Выгрузить(), Дата);
		Для Каждого СтрокаКеш Из ТабКеш Цикл
			СтрокаВЛисте = ТабЗВЛисте.Найти(СтрокаКеш.Касса, "Касса");
			Если СтрокаВЛисте = Неопределено Тогда
				СтрокаДоб = ТаблицаДанных.Добавить();
				СтрокаДоб.Касса = СтрокаКеш.Касса;
				СтрокаДоб.СуммаПоНал = СтрокаКеш.СуммаПоНал;
				СтрокаДоб.СуммаПоБезнал = СтрокаКеш.СуммаПоБезнал;
			КонецЕсли;
		КонецЦикла;	
	КонецЕсли;	
	
КонецПроцедуры

Процедура ЗаписатьЛист()
	
	ЛистОбъект = ЛистУчета.ПолучитьОбъект();
	Для Каждого СтрокаД Из ТаблицаДанных Цикл
		СтрокаВДоке = ЛистОбъект.ZОтчеты.Найти(СтрокаД.Касса, "Касса");
		Если СтрокаВДоке = Неопределено Тогда
			СтрокаВДоке = ЛистОбъект.ZОтчеты.Добавить();
			СтрокаВДоке.Касса = СтрокаД.Касса;
		КонецЕсли;	
		СтрокаВДоке.Сумма = СтрокаВДоке.Сумма + СтрокаД.СуммаПоНал + СтрокаД.СуммаПоБезнал;
		СтрокаВДоке.СуммаПоНал = СтрокаВДоке.СуммаПоНал + СтрокаД.СуммаПоНал;
		СтрокаВДоке.СуммаПоБезнал = СтрокаВДоке.СуммаПоБезнал + СтрокаД.СуммаПоБезнал;
	КонецЦикла;
	ЛистОбъект.НеПерезагружатьЗОтчеты = Истина;
	ЛистОбъект.Записать(РежимЗаписиДокумента.Проведение);
	
КонецПроцедуры	

&НаКлиенте
Процедура Перенести(Команда)
	
	Если Не ЗначениеЗаполнено(ЛистУчета) Тогда
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю("Не указан лист учета");
		Возврат;
	КонецЕсли;	
	
	ЗаписатьЛист();
	Закрыть(Истина);
	
КонецПроцедуры
