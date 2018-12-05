﻿
Процедура ОбработкаПроведения(Отказ, РежимПроведения)
	ЭтотОбъект.Движения.Финансовый.Очистить();
	ЭтотОбъект.Движения.Финансовый.Записывать = Истина;

	Для каждого стр из ЭтотОбъект.Резервы Цикл
		Если стр.Номенклатура.ПринадлежитЭлементу(ЭтотОбъект.ГруппаНонФуд) Тогда
			Если стр.РезервыНачисление_Количество <> 0 или стр.РезервыНачисление_Сумма <> 0 Тогда
				НоваяПроводка = Движения.Финансовый.Добавить();
				НоваяПроводка.Период = ЭтотОбъект.Дата;
				НоваяПроводка.Содержание = "Резервы к начислению";
				НоваяПроводка.Организация = ЭтотОбъект.Организация;
				
				НоваяПроводка.СчетДт = ЭтотОбъект.Долгосрочный_Счет;
				БухгалтерскийУчет.УстановитьСубконто(НоваяПроводка.СчетДт, НоваяПроводка.СубконтоДт, "ТорговыеТочки", ЭтотОбъект.Долгосрочный_ТорговыеТочки);
				БухгалтерскийУчет.УстановитьСубконто(НоваяПроводка.СчетДт, НоваяПроводка.СубконтоДт, "СтатьиДоходовРасходов", ЭтотОбъект.Долгосрочный_СтатьяРасходов);
				БухгалтерскийУчет.УстановитьСубконто(НоваяПроводка.СчетДт, НоваяПроводка.СубконтоДт, "ЦФО", ЭтотОбъект.Долгосрочный_ЦФО);
				
				НоваяПроводка.СчетКт = ПланыСчетов.Финансовый.РезервПодОбесцениваниеЗапасовПоСрокуДолгосрочные;
				БухгалтерскийУчет.УстановитьСубконто(НоваяПроводка.СчетКт, НоваяПроводка.СубконтоКт, "Товары", стр.Номенклатура);
				НоваяПроводка.КоличествоКт = стр.РезервыНачисление_Количество;
				
				НоваяПроводка.СуммаМСФО = стр.РезервыНачисление_Сумма;
			КонецЕсли;
			Если стр.РезервыСписание_Количество <> 0 или стр.РезервыСписание_Сумма <> 0 Тогда
				НоваяПроводка = Движения.Финансовый.Добавить();
				НоваяПроводка.Период = ЭтотОбъект.Дата;
				НоваяПроводка.Содержание = "Резервы к списанию";
				НоваяПроводка.Организация = ЭтотОбъект.Организация;
				
				НоваяПроводка.СчетДт = ПланыСчетов.Финансовый.РезервПодОбесцениваниеЗапасовПоСрокуДолгосрочные;
				БухгалтерскийУчет.УстановитьСубконто(НоваяПроводка.СчетДт, НоваяПроводка.СубконтоДт, "Товары", стр.Номенклатура);
				НоваяПроводка.КоличествоДт = стр.РезервыСписание_Количество;
				
				НоваяПроводка.СчетКт = ЭтотОбъект.Долгосрочный_Счет;
				БухгалтерскийУчет.УстановитьСубконто(НоваяПроводка.СчетКт, НоваяПроводка.СубконтоКт, "ТорговыеТочки", ЭтотОбъект.Долгосрочный_ТорговыеТочки);
				БухгалтерскийУчет.УстановитьСубконто(НоваяПроводка.СчетКт, НоваяПроводка.СубконтоКт, "СтатьиДоходовРасходов", ЭтотОбъект.Долгосрочный_СтатьяРасходов);
				БухгалтерскийУчет.УстановитьСубконто(НоваяПроводка.СчетКт, НоваяПроводка.СубконтоКт, "ЦФО", ЭтотОбъект.Долгосрочный_ЦФО);
				
				НоваяПроводка.СуммаМСФО = стр.РезервыСписание_Сумма;
				
				НоваяПроводка = Движения.Финансовый.Добавить();
				НоваяПроводка.Период = ЭтотОбъект.Дата;
				НоваяПроводка.Содержание = "Резервы к списанию";
				НоваяПроводка.Организация = ЭтотОбъект.Организация;
				
				НоваяПроводка.СчетДт = ЭтотОбъект.Долгосрочный_Счет;
				БухгалтерскийУчет.УстановитьСубконто(НоваяПроводка.СчетДт, НоваяПроводка.СубконтоДт, "ТорговыеТочки", ЭтотОбъект.Долгосрочный_ТорговыеТочки);
				БухгалтерскийУчет.УстановитьСубконто(НоваяПроводка.СчетДт, НоваяПроводка.СубконтоДт, "СтатьиДоходовРасходов", ЭтотОбъект.Долгосрочный_СтатьяРасходов);
				БухгалтерскийУчет.УстановитьСубконто(НоваяПроводка.СчетДт, НоваяПроводка.СубконтоДт, "ЦФО", ЭтотОбъект.Долгосрочный_ЦФО);
				
				НоваяПроводка.СчетКт = ЭтотОбъект.Долгосрочный_Счет;
				БухгалтерскийУчет.УстановитьСубконто(НоваяПроводка.СчетКт, НоваяПроводка.СубконтоКт, "ТорговыеТочки", ЭтотОбъект.Долгосрочный_ТорговыеТочки);
				БухгалтерскийУчет.УстановитьСубконто(НоваяПроводка.СчетКт, НоваяПроводка.СубконтоКт, "СтатьиДоходовРасходов", ЭтотОбъект.Долгосрочный_СтатьяСписания);
				БухгалтерскийУчет.УстановитьСубконто(НоваяПроводка.СчетКт, НоваяПроводка.СубконтоКт, "ЦФО", ЭтотОбъект.Долгосрочный_ЦФО);
				
				НоваяПроводка.СуммаМСФО = стр.РезервыСписание_Сумма;
			КонецЕсли;
		Иначе
			Если стр.РезервыНачисление_Количество <> 0 или стр.РезервыНачисление_Сумма <> 0 Тогда
				НоваяПроводка = Движения.Финансовый.Добавить();
				НоваяПроводка.Период = ЭтотОбъект.Дата;
				НоваяПроводка.Содержание = "Резервы к начислению";
				НоваяПроводка.Организация = ЭтотОбъект.Организация;
				
				НоваяПроводка.СчетДт = ЭтотОбъект.Краткосрочный_Счет;
				БухгалтерскийУчет.УстановитьСубконто(НоваяПроводка.СчетДт, НоваяПроводка.СубконтоДт, "ТорговыеТочки", ЭтотОбъект.Краткосрочный_ТорговыеТочки);
				БухгалтерскийУчет.УстановитьСубконто(НоваяПроводка.СчетДт, НоваяПроводка.СубконтоДт, "СтатьиДоходовРасходов", ЭтотОбъект.Краткосрочный_СтатьяРасходов);
				БухгалтерскийУчет.УстановитьСубконто(НоваяПроводка.СчетДт, НоваяПроводка.СубконтоДт, "ЦФО", ЭтотОбъект.Краткосрочный_ЦФО);
				
				НоваяПроводка.СчетКт = ПланыСчетов.Финансовый.РезервПодОбесцениваниеЗапасовПоСрокуКраткосрочные;
				БухгалтерскийУчет.УстановитьСубконто(НоваяПроводка.СчетКт, НоваяПроводка.СубконтоКт, "Товары", стр.Номенклатура);
				НоваяПроводка.КоличествоКт = стр.РезервыНачисление_Количество;
				
				НоваяПроводка.СуммаМСФО = стр.РезервыНачисление_Сумма;
			КонецЕсли;
			Если стр.РезервыСписание_Количество <> 0 или стр.РезервыСписание_Сумма <> 0 Тогда
				НоваяПроводка = Движения.Финансовый.Добавить();
				НоваяПроводка.Период = ЭтотОбъект.Дата;
				НоваяПроводка.Содержание = "Резервы к списанию";
				НоваяПроводка.Организация = ЭтотОбъект.Организация;
				
				НоваяПроводка.СчетДт = ПланыСчетов.Финансовый.РезервПодОбесцениваниеЗапасовПоСрокуКраткосрочные;
				БухгалтерскийУчет.УстановитьСубконто(НоваяПроводка.СчетДт, НоваяПроводка.СубконтоДт, "Товары", стр.Номенклатура);
				НоваяПроводка.КоличествоДт = стр.РезервыСписание_Количество;
				
				НоваяПроводка.СчетКт = ЭтотОбъект.Краткосрочный_Счет;
				БухгалтерскийУчет.УстановитьСубконто(НоваяПроводка.СчетКт, НоваяПроводка.СубконтоКт, "ТорговыеТочки", ЭтотОбъект.Краткосрочный_ТорговыеТочки);
				БухгалтерскийУчет.УстановитьСубконто(НоваяПроводка.СчетКт, НоваяПроводка.СубконтоКт, "СтатьиДоходовРасходов", ЭтотОбъект.Краткосрочный_СтатьяРасходов);
				БухгалтерскийУчет.УстановитьСубконто(НоваяПроводка.СчетКт, НоваяПроводка.СубконтоКт, "ЦФО", ЭтотОбъект.Краткосрочный_ЦФО);
				
				НоваяПроводка.СуммаМСФО = стр.РезервыСписание_Сумма;
				
				НоваяПроводка = Движения.Финансовый.Добавить();
				НоваяПроводка.Период = ЭтотОбъект.Дата;
				НоваяПроводка.Содержание = "Резервы к списанию";
				НоваяПроводка.Организация = ЭтотОбъект.Организация;
				
				НоваяПроводка.СчетДт = ЭтотОбъект.Краткосрочный_Счет;
				БухгалтерскийУчет.УстановитьСубконто(НоваяПроводка.СчетДт, НоваяПроводка.СубконтоДт, "ТорговыеТочки", ЭтотОбъект.Краткосрочный_ТорговыеТочки);
				БухгалтерскийУчет.УстановитьСубконто(НоваяПроводка.СчетДт, НоваяПроводка.СубконтоДт, "СтатьиДоходовРасходов", ЭтотОбъект.Краткосрочный_СтатьяРасходов);
				БухгалтерскийУчет.УстановитьСубконто(НоваяПроводка.СчетДт, НоваяПроводка.СубконтоДт, "ЦФО", ЭтотОбъект.Краткосрочный_ЦФО);
				
				НоваяПроводка.СчетКт = ЭтотОбъект.Краткосрочный_Счет;
				БухгалтерскийУчет.УстановитьСубконто(НоваяПроводка.СчетКт, НоваяПроводка.СубконтоКт, "ТорговыеТочки", ЭтотОбъект.Краткосрочный_ТорговыеТочки);
				БухгалтерскийУчет.УстановитьСубконто(НоваяПроводка.СчетКт, НоваяПроводка.СубконтоКт, "СтатьиДоходовРасходов", ЭтотОбъект.Краткосрочный_СтатьяСписания);
				БухгалтерскийУчет.УстановитьСубконто(НоваяПроводка.СчетКт, НоваяПроводка.СубконтоКт, "ЦФО", ЭтотОбъект.Краткосрочный_ЦФО);
				
				НоваяПроводка.СуммаМСФО = стр.РезервыСписание_Сумма;
			КонецЕсли;
		КонецЕсли;
	КонецЦикла;
КонецПроцедуры

Процедура ОбработкаПроверкиЗаполнения(Отказ, ПроверяемыеРеквизиты)
	ТЗ_Резервы = ЭтотОбъект.Резервы.Выгрузить();
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("ТЗ", ТЗ_Резервы);
	Запрос.УстановитьПараметр("ДатаНач", НачалоМесяца(ЭтотОбъект.ДатаНачала));
	Запрос.УстановитьПараметр("Организация", ЭтотОбъект.Организация);	
	Запрос.Текст = "ВЫБРАТЬ
	               |	ТЗ.Номенклатура,
	               |	ТЗ.РезервыСписание_Количество,
	               |	ТЗ.РезервыСписание_Сумма
	               |ПОМЕСТИТЬ ТЗ
	               |ИЗ
	               |	&ТЗ КАК ТЗ
	               |;
	               |
	               |////////////////////////////////////////////////////////////////////////////////
	               |ВЫБРАТЬ
	               |	ФинансовыйОстатки.Субконто1 КАК Номенклатура,
	               |	-ФинансовыйОстатки.КоличествоОстаток КАК КоличествоД,
	               |	-ФинансовыйОстатки.СуммаМСФООстаток КАК СуммаД,
	               |	0 КАК КоличествоК,
	               |	0 КАК СуммаК
	               |ПОМЕСТИТЬ ВР_96СК
	               |ИЗ
	               |	РегистрБухгалтерии.Финансовый.Остатки(&ДатаНач, Счет = ЗНАЧЕНИЕ(ПланСчетов.Финансовый.РезервПодОбесцениваниеЗапасовПоСрокуДолгосрочные), , Организация = &Организация) КАК ФинансовыйОстатки
	               |
	               |ОБЪЕДИНИТЬ ВСЕ
	               |
	               |ВЫБРАТЬ
	               |	ФинансовыйОстатки.Субконто1,
	               |	0,
	               |	0,
	               |	-ФинансовыйОстатки.КоличествоОстаток,
	               |	-ФинансовыйОстатки.СуммаМСФООстаток
	               |ИЗ
	               |	РегистрБухгалтерии.Финансовый.Остатки(&ДатаНач, Счет = ЗНАЧЕНИЕ(ПланСчетов.Финансовый.РезервПодОбесцениваниеЗапасовПоСрокуКраткосрочные), , Организация = &Организация) КАК ФинансовыйОстатки
	               |;
	               |
	               |////////////////////////////////////////////////////////////////////////////////
	               |ВЫБРАТЬ
	               |	ВложенныйЗапрос.Номенклатура,
	               |	ВложенныйЗапрос.РезервыСписание_Количество,
	               |	ВложенныйЗапрос.РезервыСписание_Сумма,
	               |	ВложенныйЗапрос.КоличествоД,
	               |	ВложенныйЗапрос.СуммаД,
	               |	ВложенныйЗапрос.КоличествоК,
	               |	ВложенныйЗапрос.СуммаК
	               |ИЗ
	               |	(ВЫБРАТЬ
	               |		ВложенныйЗапрос.Номенклатура КАК Номенклатура,
	               |		СУММА(ВложенныйЗапрос.РезервыСписание_Количество) КАК РезервыСписание_Количество,
	               |		СУММА(ВложенныйЗапрос.РезервыСписание_Сумма) КАК РезервыСписание_Сумма,
	               |		СУММА(ВложенныйЗапрос.КоличествоД) КАК КоличествоД,
	               |		СУММА(ВложенныйЗапрос.СуммаД) КАК СуммаД,
	               |		СУММА(ВложенныйЗапрос.КоличествоК) КАК КоличествоК,
	               |		СУММА(ВложенныйЗапрос.СуммаК) КАК СуммаК
	               |	ИЗ
	               |		(ВЫБРАТЬ
	               |			ТЗ.Номенклатура КАК Номенклатура,
	               |			ТЗ.РезервыСписание_Количество КАК РезервыСписание_Количество,
	               |			ТЗ.РезервыСписание_Сумма КАК РезервыСписание_Сумма,
	               |			0 КАК КоличествоД,
	               |			0 КАК СуммаД,
	               |			0 КАК КоличествоК,
	               |			0 КАК СуммаК
	               |		ИЗ
	               |			ТЗ КАК ТЗ
	               |		
	               |		ОБЪЕДИНИТЬ ВСЕ
	               |		
	               |		ВЫБРАТЬ
	               |			ВР_96СК.Номенклатура,
	               |			0,
	               |			0,
	               |			ВР_96СК.КоличествоД,
	               |			ВР_96СК.СуммаД,
	               |			ВР_96СК.КоличествоК,
	               |			ВР_96СК.СуммаК
	               |		ИЗ
	               |			ВР_96СК КАК ВР_96СК) КАК ВложенныйЗапрос
	               |	
	               |	СГРУППИРОВАТЬ ПО
	               |		ВложенныйЗапрос.Номенклатура) КАК ВложенныйЗапрос
	               |ГДЕ
	               |	(ВложенныйЗапрос.РезервыСписание_Количество <> 0
	               |			ИЛИ ВложенныйЗапрос.РезервыСписание_Сумма <> 0)
	               |	И НЕ ВложенныйЗапрос.Номенклатура ЕСТЬ NULL
	               |
	               |УПОРЯДОЧИТЬ ПО
	               |	ВложенныйЗапрос.Номенклатура.Наименование";
	ТЗ = Запрос.Выполнить().Выгрузить();
	
	Для каждого стр из ТЗ Цикл
		Если стр.Номенклатура.ПринадлежитЭлементу(ЭтотОбъект.ГруппаНонФуд) Тогда
			Если стр.РезервыСписание_Количество > стр.КоличествоД Тогда
				ОбщегоНазначенияКлиентСервер.СообщитьПользователю("Превышение количества остатка резерва по номенклатуре " + СокрЛП(стр.Номенклатура) + 
					". Остаток резерва " + Формат(стр.КоличествоД, "ЧДЦ=3; ЧРД=,; ЧРГ=' '") + 
					". Списывается " + Формат(стр.РезервыСписание_Количество, "ЧДЦ=3; ЧРД=,; ЧРГ=' '") + ".",,,, Отказ);
			ИначеЕсли стр.РезервыСписание_Сумма > стр.СуммаД Тогда
				ОбщегоНазначенияКлиентСервер.СообщитьПользователю("Превышение суммы остатка резерва по номенклатуре " + СокрЛП(стр.Номенклатура) + 
					". Сумма резерва " + Формат(стр.СуммаД, "ЧДЦ=2; ЧРД=,; ЧРГ=' '") + 
					". Списывается " + Формат(стр.РезервыСписание_Сумма, "ЧДЦ=2; ЧРД=,; ЧРГ=' '") + ".",,,, Отказ);
			ИначеЕсли стр.КоличествоД = стр.РезервыСписание_Количество и
				стр.РезервыСписание_Сумма <> стр.СуммаД Тогда
				
				ОбщегоНазначенияКлиентСервер.СообщитьПользователю("При списании остатка по номенклатуре " + СокрЛП(стр.Номенклатура) + 
					" количество списано полностью, но сумма осталась. Сумма резерва " + Формат(стр.СуммаД, "ЧДЦ=2; ЧРД=,; ЧРГ=' '") + 
					". Списывается " + Формат(стр.РезервыСписание_Сумма, "ЧДЦ=2; ЧРД=,; ЧРГ=' '") + ".",,,, Отказ);
			КонецЕсли;
		Иначе
			Если стр.РезервыСписание_Количество > стр.КоличествоК Тогда
				ОбщегоНазначенияКлиентСервер.СообщитьПользователю("Превышение количества остатка резерва по номенклатуре " + СокрЛП(стр.Номенклатура) + 
					". Остаток резерва " + Формат(стр.КоличествоК, "ЧДЦ=3; ЧРД=,; ЧРГ=' '") + 
					". Списывается " + Формат(стр.РезервыСписание_Количество, "ЧДЦ=3; ЧРД=,; ЧРГ=' '") + ".",,,, Отказ);
			ИначеЕсли стр.РезервыСписание_Сумма > стр.СуммаК Тогда
				ОбщегоНазначенияКлиентСервер.СообщитьПользователю("Превышение суммы остатка резерва по номенклатуре " + СокрЛП(стр.Номенклатура) + 
					". Сумма резерва " + Формат(стр.СуммаК, "ЧДЦ=2; ЧРД=,; ЧРГ=' '") + 
					". Списывается " + Формат(стр.РезервыСписание_Сумма, "ЧДЦ=2; ЧРД=,; ЧРГ=' '") + ".",,,, Отказ);
			ИначеЕсли стр.КоличествоК = стр.РезервыСписание_Количество и
				стр.РезервыСписание_Сумма <> стр.СуммаК Тогда
				
				ОбщегоНазначенияКлиентСервер.СообщитьПользователю("При списании остатка по номенклатуре " + СокрЛП(стр.Номенклатура) + 
					" количество списано полностью, но сумма осталась. Сумма резерва " + Формат(стр.СуммаК, "ЧДЦ=2; ЧРД=,; ЧРГ=' '") + 
					". Списывается " + Формат(стр.РезервыСписание_Сумма, "ЧДЦ=2; ЧРД=,; ЧРГ=' '") + ".",,,, Отказ);
			КонецЕсли;
		КонецЕсли;
	КонецЦикла;
	
	КолСтрок = ЭтотОбъект.Резервы.Количество();
	ТЗ_Резервы.Колонки.Добавить("КолСтрок");
	ТЗ_Резервы.ЗаполнитьЗначения(1, "КолСтрок");
	ТЗ_Резервы.Свернуть("Номенклатура", "КолСтрок");
	Для каждого стр из ТЗ_Резервы Цикл
		Если стр.КолСтрок > 1 Тогда
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю("Строка с номенклатурой " + СокрЛП(стр.Номенклатура) + " не уникальна!",,,, Отказ);
		КонецЕсли;
	КонецЦикла;
КонецПроцедуры


