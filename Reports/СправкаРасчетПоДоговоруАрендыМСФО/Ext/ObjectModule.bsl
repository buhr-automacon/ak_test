﻿
Процедура ПриКомпоновкеРезультата(ДокументРезультат, ДанныеРасшифровки, СтандартнаяОбработка)
	Параметры =  ЭтотОбъект.КомпоновщикНастроек.Настройки.ПараметрыДанных;
	
	//Параметры.УстановитьЗначениеПараметра("Контрагент", Контрагент);
	//Параметры.УстановитьЗначениеПараметра("ТорговаяТочка", ТорговаяТочка);
	//Параметры.УстановитьЗначениеПараметра("Организация", Организация);
	
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("Контрагент", Контрагент);
	Запрос.УстановитьПараметр("ТорговаяТочка", ТорговаяТочка);
	Запрос.УстановитьПараметр("Организация", Организация);
	Запрос.УстановитьПараметр("ДатаНачалаУчета", '20180101');
	Запрос.Текст = "ВЫБРАТЬ
	               |	ВложенныйЗапрос.Организация КАК Организация,
	               |	ВложенныйЗапрос.НачалоПериода КАК НачалоПериода,
	               |	ВложенныйЗапрос.КонецПериода КАК КонецПериода,
	               |	ВложенныйЗапрос.Контрагент КАК Контрагент,
	               |	ВложенныйЗапрос.ТорговаяТочка КАК ТорговаяТочка,
	               |	СУММА(ВложенныйЗапрос.ДДПНачальныйОстаток) КАК ДДПНачальныйОстаток,
	               |	СУММА(ВложенныйЗапрос.Начисление) КАК Начисление,
	               |	СУММА(ВложенныйЗапрос.ДДПНачальныйОстаток - ВложенныйЗапрос.Начисление) КАК Разница,
	               |	СУММА(ВложенныйЗапрос.ЕжемесячныйПроцент) КАК ЕжемесячныйПроцент,
	               |	СУММА(ВложенныйЗапрос.ДДПКонечныйОстаток) КАК ДДПКонечныйОстаток,
	               |	СУММА(ВложенныйЗапрос.ИзменениеЕжемесячногоПлатежа) КАК ИзменениеЕжемесячногоПлатежа,
	               |	СУММА(ВложенныйЗапрос.Закрыто) КАК Закрыто
	               |ПОМЕСТИТЬ ДанныеСРегистра
	               |ИЗ
	               |	(ВЫБРАТЬ
	               |		ИнформацияПоДоговоруАрендыОстаткиИОбороты.Организация КАК Организация,
	               |		НАЧАЛОПЕРИОДА(ИнформацияПоДоговоруАрендыОстаткиИОбороты.Период, МЕСЯЦ) КАК НачалоПериода,
	               |		КОНЕЦПЕРИОДА(ИнформацияПоДоговоруАрендыОстаткиИОбороты.Период, МЕСЯЦ) КАК КонецПериода,
	               |		ИнформацияПоДоговоруАрендыОстаткиИОбороты.Контрагент КАК Контрагент,
	               |		ИнформацияПоДоговоруАрендыОстаткиИОбороты.ТорговаяТочка КАК ТорговаяТочка,
	               |		ИнформацияПоДоговоруАрендыОстаткиИОбороты.ДДПНачальныйОстаток КАК ДДПНачальныйОстаток,
	               |		0 КАК Начисление,
	               |		0 КАК ЕжемесячныйПроцент,
	               |		ИнформацияПоДоговоруАрендыОстаткиИОбороты.ДДПКонечныйОстаток КАК ДДПКонечныйОстаток,
	               |		0 КАК ИзменениеЕжемесячногоПлатежа,
	               |		0 КАК Закрыто
	               |	ИЗ
	               |		РегистрНакопления.ИнформацияПоДоговоруАренды.ОстаткиИОбороты(
	               |				,
	               |				,
	               |				Месяц,
	               |				,
	               |				Контрагент = &Контрагент
	               |					И ТорговаяТочка = &ТорговаяТочка
	               |					И Организация = &Организация) КАК ИнформацияПоДоговоруАрендыОстаткиИОбороты
	               |	
	               |	ОБЪЕДИНИТЬ ВСЕ
	               |	
	               |	ВЫБРАТЬ
	               |		ИнформацияПоДоговоруАренды.Организация,
	               |		НАЧАЛОПЕРИОДА(ИнформацияПоДоговоруАренды.Период, МЕСЯЦ),
	               |		КОНЕЦПЕРИОДА(ИнформацияПоДоговоруАренды.Период, МЕСЯЦ),
	               |		ИнформацияПоДоговоруАренды.Контрагент,
	               |		ИнформацияПоДоговоруАренды.ТорговаяТочка,
	               |		0,
	               |		0,
	               |		0,
	               |		0,
	               |		ИнформацияПоДоговоруАренды.ДДП,
	               |		0
	               |	ИЗ
	               |		РегистрНакопления.ИнформацияПоДоговоруАренды КАК ИнформацияПоДоговоруАренды
	               |	ГДЕ
	               |		ИнформацияПоДоговоруАренды.Контрагент = &Контрагент
	               |		И ИнформацияПоДоговоруАренды.ТорговаяТочка = &ТорговаяТочка
	               |		И ИнформацияПоДоговоруАренды.КодОперации = ЗНАЧЕНИЕ(Перечисление.КодОперацийПоАрендеМСФО.ИзменениеЕжемесячногоПлатежа)
	               |		И ИнформацияПоДоговоруАренды.Организация = &Организация
	               |	
	               |	ОБЪЕДИНИТЬ ВСЕ
	               |	
	               |	ВЫБРАТЬ
	               |		ИнформацияПоДоговоруАренды.Организация,
	               |		НАЧАЛОПЕРИОДА(ИнформацияПоДоговоруАренды.Период, МЕСЯЦ),
	               |		КОНЕЦПЕРИОДА(ИнформацияПоДоговоруАренды.Период, МЕСЯЦ),
	               |		ИнформацияПоДоговоруАренды.Контрагент,
	               |		ИнформацияПоДоговоруАренды.ТорговаяТочка,
	               |		ИнформацияПоДоговоруАренды.ДДП,
	               |		0,
	               |		0,
	               |		0,
	               |		0,
	               |		0
	               |	ИЗ
	               |		РегистрНакопления.ИнформацияПоДоговоруАренды КАК ИнформацияПоДоговоруАренды
	               |	ГДЕ
	               |		ИнформацияПоДоговоруАренды.Контрагент = &Контрагент
	               |		И ИнформацияПоДоговоруАренды.ТорговаяТочка = &ТорговаяТочка
	               |		И (ИнформацияПоДоговоруАренды.КодОперации = ЗНАЧЕНИЕ(Перечисление.КодОперацийПоАрендеМСФО.НовыйДоговор)
	               |				ИЛИ ИнформацияПоДоговоруАренды.КодОперации = ЗНАЧЕНИЕ(Перечисление.КодОперацийПоАрендеМСФО.ИзменениеЕжемесячногоПлатежа))
	               |		И ИнформацияПоДоговоруАренды.Организация = &Организация
	               |	
	               |	ОБЪЕДИНИТЬ ВСЕ
	               |	
	               |	ВЫБРАТЬ
	               |		ИнформацияПоДоговоруАренды.Организация,
	               |		НАЧАЛОПЕРИОДА(ИнформацияПоДоговоруАренды.Период, МЕСЯЦ),
	               |		КОНЕЦПЕРИОДА(ИнформацияПоДоговоруАренды.Период, МЕСЯЦ),
	               |		ИнформацияПоДоговоруАренды.Контрагент,
	               |		ИнформацияПоДоговоруАренды.ТорговаяТочка,
	               |		0,
	               |		0,
	               |		ИнформацияПоДоговоруАренды.ДДП,
	               |		0,
	               |		0,
	               |		0
	               |	ИЗ
	               |		РегистрНакопления.ИнформацияПоДоговоруАренды КАК ИнформацияПоДоговоруАренды
	               |	ГДЕ
	               |		ИнформацияПоДоговоруАренды.Контрагент = &Контрагент
	               |		И ИнформацияПоДоговоруАренды.ТорговаяТочка = &ТорговаяТочка
	               |		И ИнформацияПоДоговоруАренды.КодОперации = ЗНАЧЕНИЕ(Перечисление.КодОперацийПоАрендеМСФО.ЕжемесячныйПроцент)
	               |		И ИнформацияПоДоговоруАренды.Организация = &Организация
	               |	
	               |	ОБЪЕДИНИТЬ ВСЕ
	               |	
	               |	ВЫБРАТЬ
	               |		ИнформацияПоДоговоруАренды.Организация,
	               |		НАЧАЛОПЕРИОДА(ИнформацияПоДоговоруАренды.Период, МЕСЯЦ),
	               |		КОНЕЦПЕРИОДА(ИнформацияПоДоговоруАренды.Период, МЕСЯЦ),
	               |		ИнформацияПоДоговоруАренды.Контрагент,
	               |		ИнформацияПоДоговоруАренды.ТорговаяТочка,
	               |		0,
	               |		ИнформацияПоДоговоруАренды.ДДП,
	               |		0,
	               |		0,
	               |		0,
	               |		0
	               |	ИЗ
	               |		РегистрНакопления.ИнформацияПоДоговоруАренды КАК ИнформацияПоДоговоруАренды
	               |	ГДЕ
	               |		ИнформацияПоДоговоруАренды.Контрагент = &Контрагент
	               |		И ИнформацияПоДоговоруАренды.ТорговаяТочка = &ТорговаяТочка
	               |		И ИнформацияПоДоговоруАренды.КодОперации = ЗНАЧЕНИЕ(Перечисление.КодОперацийПоАрендеМСФО.Начисление)
	               |		И ИнформацияПоДоговоруАренды.Организация = &Организация
	               |	
	               |	ОБЪЕДИНИТЬ ВСЕ
	               |	
	               |	ВЫБРАТЬ
	               |		ИнформацияПоДоговоруАренды.Организация,
	               |		НАЧАЛОПЕРИОДА(ИнформацияПоДоговоруАренды.Период, МЕСЯЦ),
	               |		КОНЕЦПЕРИОДА(ИнформацияПоДоговоруАренды.Период, МЕСЯЦ),
	               |		ИнформацияПоДоговоруАренды.Контрагент,
	               |		ИнформацияПоДоговоруАренды.ТорговаяТочка,
	               |		0,
	               |		0,
	               |		0,
	               |		0,
	               |		0,
	               |		ИнформацияПоДоговоруАренды.ДДП
	               |	ИЗ
	               |		РегистрНакопления.ИнформацияПоДоговоруАренды КАК ИнформацияПоДоговоруАренды
	               |	ГДЕ
	               |		ИнформацияПоДоговоруАренды.Контрагент = &Контрагент
	               |		И ИнформацияПоДоговоруАренды.ТорговаяТочка = &ТорговаяТочка
	               |		И ИнформацияПоДоговоруАренды.КодОперации = ЗНАЧЕНИЕ(Перечисление.КодОперацийПоАрендеМСФО.Закрыто)
	               |		И ИнформацияПоДоговоруАренды.Организация = &Организация) КАК ВложенныйЗапрос
	               |
	               |СГРУППИРОВАТЬ ПО
	               |	ВложенныйЗапрос.Организация,
	               |	ВложенныйЗапрос.НачалоПериода,
	               |	ВложенныйЗапрос.КонецПериода,
	               |	ВложенныйЗапрос.Контрагент,
	               |	ВложенныйЗапрос.ТорговаяТочка
	               |;
	               |
	               |////////////////////////////////////////////////////////////////////////////////
	               |ВЫБРАТЬ
	               |	ДанныеСРегистра.Организация,
	               |	ДанныеСРегистра.Контрагент,
	               |	ДанныеСРегистра.ТорговаяТочка,
	               |	ДанныеСРегистра.ДДПКонечныйОстаток КАК ДДПНачальныйОстаток,
	               |	ДанныеСРегистра.Начисление,
	               |	0 КАК Разница,
	               |	0 КАК ЕжемесячныйПроцент,
	               |	0 КАК ДДПКонечныйОстаток,
	               |	ДОБАВИТЬКДАТЕ(ДанныеСРегистра.КонецПериода, ДЕНЬ, 1) КАК НачалоПериода,
	               |	ВЫБОР
	               |		КОГДА ДанныеСРегистра.ТорговаяТочка <> ЗНАЧЕНИЕ(Справочник.СтруктурныеЕдиницы.ПустаяСсылка)
	               |				И ДанныеСРегистра.ТорговаяТочка.ТипРозничнойТочки = ЗНАЧЕНИЕ(Перечисление.ТипыРозничныхТочек.Избенка)
	               |			ТОГДА ДАТАВРЕМЯ(2018, 12, 31)
	               |		ИНАЧЕ ДОБАВИТЬКДАТЕ(ДОБАВИТЬКДАТЕ(ВложенныйЗапрос.НачалоПериода, ГОД, 5), ДЕНЬ, -1)
	               |	КОНЕЦ КАК ДатаОкончанияПредп,
	               |	0 КАК ИзменениеЕжемесячногоПлатежа,
	               |	ДанныеСРегистра.Закрыто
	               |ПОМЕСТИТЬ ХвостикБезПериода
	               |ИЗ
	               |	ДанныеСРегистра КАК ДанныеСРегистра
	               |		ВНУТРЕННЕЕ СОЕДИНЕНИЕ (ВЫБРАТЬ
	               |			ДанныеСРегистра.Организация КАК Организация,
	               |			ДанныеСРегистра.Контрагент КАК Контрагент,
	               |			ДанныеСРегистра.ТорговаяТочка КАК ТорговаяТочка,
	               |			МИНИМУМ(ДанныеСРегистра.НачалоПериода) КАК НачалоПериода,
	               |			МАКСИМУМ(ДанныеСРегистра.КонецПериода) КАК КонецПериода
	               |		ИЗ
	               |			ДанныеСРегистра КАК ДанныеСРегистра
	               |		
	               |		СГРУППИРОВАТЬ ПО
	               |			ДанныеСРегистра.Организация,
	               |			ДанныеСРегистра.Контрагент,
	               |			ДанныеСРегистра.ТорговаяТочка) КАК ВложенныйЗапрос
	               |		ПО ДанныеСРегистра.Организация = ВложенныйЗапрос.Организация
	               |			И ДанныеСРегистра.Контрагент = ВложенныйЗапрос.Контрагент
	               |			И ДанныеСРегистра.ТорговаяТочка = ВложенныйЗапрос.ТорговаяТочка
	               |			И ДанныеСРегистра.КонецПериода = ВложенныйЗапрос.КонецПериода
	               |;
	               |
	               |////////////////////////////////////////////////////////////////////////////////
	               |ВЫБРАТЬ
	               |	ХвостикБезПериода.Организация,
	               |	ХвостикБезПериода.Контрагент,
	               |	ХвостикБезПериода.ТорговаяТочка,
	               |	НАЧАЛОПЕРИОДА(РегламентированныйПроизводственныйКалендарь.ДатаКалендаря, МЕСЯЦ) КАК НачалоПериода,
	               |	КОНЕЦПЕРИОДА(РегламентированныйПроизводственныйКалендарь.ДатаКалендаря, МЕСЯЦ) КАК КонецПериода,
	               |	ХвостикБезПериода.ДДПНачальныйОстаток,
	               |	ХвостикБезПериода.Начисление,
	               |	ХвостикБезПериода.Разница,
	               |	ХвостикБезПериода.ЕжемесячныйПроцент,
	               |	ХвостикБезПериода.ДДПКонечныйОстаток,
	               |	ХвостикБезПериода.ИзменениеЕжемесячногоПлатежа,
	               |	ХвостикБезПериода.Закрыто
	               |ПОМЕСТИТЬ ХвостикСПериодами
	               |ИЗ
	               |	ХвостикБезПериода КАК ХвостикБезПериода
	               |		ВНУТРЕННЕЕ СОЕДИНЕНИЕ РегистрСведений.РегламентированныйПроизводственныйКалендарь КАК РегламентированныйПроизводственныйКалендарь
	               |		ПО ХвостикБезПериода.НачалоПериода <= РегламентированныйПроизводственныйКалендарь.ДатаКалендаря
	               |			И ХвостикБезПериода.ДатаОкончанияПредп >= РегламентированныйПроизводственныйКалендарь.ДатаКалендаря
	               |
	               |СГРУППИРОВАТЬ ПО
	               |	ХвостикБезПериода.Организация,
	               |	ХвостикБезПериода.Контрагент,
	               |	ХвостикБезПериода.ТорговаяТочка,
	               |	ХвостикБезПериода.ДДПНачальныйОстаток,
	               |	ХвостикБезПериода.Начисление,
	               |	ХвостикБезПериода.Разница,
	               |	ХвостикБезПериода.ЕжемесячныйПроцент,
	               |	ХвостикБезПериода.ДДПКонечныйОстаток,
	               |	НАЧАЛОПЕРИОДА(РегламентированныйПроизводственныйКалендарь.ДатаКалендаря, МЕСЯЦ),
	               |	КОНЕЦПЕРИОДА(РегламентированныйПроизводственныйКалендарь.ДатаКалендаря, МЕСЯЦ),
	               |	ХвостикБезПериода.ИзменениеЕжемесячногоПлатежа,
	               |	ХвостикБезПериода.Закрыто
	               |;
	               |
	               |////////////////////////////////////////////////////////////////////////////////
	               |ВЫБРАТЬ
	               |	ДанныеСРегистра.Организация,
	               |	ДанныеСРегистра.Контрагент,
	               |	ДанныеСРегистра.ТорговаяТочка,
	               |	ДанныеСРегистра.НачалоПериода,
	               |	ДанныеСРегистра.КонецПериода,
	               |	ДанныеСРегистра.ДДПНачальныйОстаток,
	               |	ДанныеСРегистра.Начисление,
	               |	ДанныеСРегистра.Разница КАК Разница,
	               |	ДанныеСРегистра.ЕжемесячныйПроцент КАК ЕжемесячныйПроцент,
	               |	ДанныеСРегистра.ДДПКонечныйОстаток КАК ДДПКонечныйОстаток,
	               |	ДанныеСРегистра.ИзменениеЕжемесячногоПлатежа,
	               |	ДанныеСРегистра.Закрыто
	               |ПОМЕСТИТЬ ВсеВместе
	               |ИЗ
	               |	ДанныеСРегистра КАК ДанныеСРегистра
	               |
	               |ОБЪЕДИНИТЬ ВСЕ
	               |
	               |ВЫБРАТЬ
	               |	ХвостикСПериодами.Организация,
	               |	ХвостикСПериодами.Контрагент,
	               |	ХвостикСПериодами.ТорговаяТочка,
	               |	ХвостикСПериодами.НачалоПериода,
	               |	ХвостикСПериодами.КонецПериода,
	               |	ХвостикСПериодами.ДДПНачальныйОстаток,
	               |	ХвостикСПериодами.Начисление,
	               |	0,
	               |	0,
	               |	0,
	               |	ХвостикСПериодами.ИзменениеЕжемесячногоПлатежа,
	               |	0
	               |ИЗ
	               |	ХвостикСПериодами КАК ХвостикСПериодами
	               |;
	               |
	               |////////////////////////////////////////////////////////////////////////////////
	               |ВЫБРАТЬ
	               |	ВсеВместе.Организация,
	               |	ВсеВместе.Контрагент,
	               |	ВсеВместе.ТорговаяТочка,
	               |	ВсеВместе.НачалоПериода КАК НачалоПериода,
	               |	ВсеВместе.КонецПериода,
	               |	ВсеВместе.ДДПНачальныйОстаток,
	               |	ВсеВместе.Начисление,
	               |	ВсеВместе.Разница,
	               |	ВсеВместе.ЕжемесячныйПроцент,
	               |	ВсеВместе.ДДПКонечныйОстаток,
	               |	ЕСТЬNULL(ВложенныйЗапрос.Ставка, 0) КАК Ставка,
	               |	ВсеВместе.ИзменениеЕжемесячногоПлатежа,
	               |	0 КАК СуммаАктива031,
	               |	0 КАК СуммаАмортизации,
	               |	ВсеВместе.Закрыто
	               |ИЗ
	               |	ВсеВместе КАК ВсеВместе
	               |		ВНУТРЕННЕЕ СОЕДИНЕНИЕ (ВЫБРАТЬ
	               |			ВложенныйЗапрос.Контрагент КАК Контрагент,
	               |			ВложенныйЗапрос.ТорговаяТочка КАК ТорговаяТочка,
	               |			СтавкиДисконтированияПоДоговорам.Ставка КАК Ставка
	               |		ИЗ
	               |			(ВЫБРАТЬ
	               |				ВложенныйЗапрос.Контрагент КАК Контрагент,
	               |				ВложенныйЗапрос.ТорговаяТочка КАК ТорговаяТочка,
	               |				МАКСИМУМ(СтавкиДисконтированияПоДоговорам.Период) КАК Период
	               |			ИЗ
	               |				(ВЫБРАТЬ
	               |					ВсеВместе.Контрагент КАК Контрагент,
	               |					ВсеВместе.ТорговаяТочка КАК ТорговаяТочка,
	               |					ИнформацияПоДоговоруАренды.ДатаНачалаВзаимоотношений КАК ДатаНачалаВзаимоотношений
	               |				ИЗ
	               |					ВсеВместе КАК ВсеВместе
	               |						ВНУТРЕННЕЕ СОЕДИНЕНИЕ РегистрНакопления.ИнформацияПоДоговоруАренды КАК ИнформацияПоДоговоруАренды
	               |						ПО ВсеВместе.Контрагент = ИнформацияПоДоговоруАренды.Контрагент
	               |							И ВсеВместе.ТорговаяТочка = ИнформацияПоДоговоруАренды.ТорговаяТочка
	               |				
	               |				СГРУППИРОВАТЬ ПО
	               |					ВсеВместе.Контрагент,
	               |					ВсеВместе.ТорговаяТочка,
	               |					ИнформацияПоДоговоруАренды.ДатаНачалаВзаимоотношений) КАК ВложенныйЗапрос
	               |					ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.СтавкиДисконтированияПоДоговорам КАК СтавкиДисконтированияПоДоговорам
	               |					ПО ВложенныйЗапрос.ДатаНачалаВзаимоотношений >= СтавкиДисконтированияПоДоговорам.Период
	               |			
	               |			СГРУППИРОВАТЬ ПО
	               |				ВложенныйЗапрос.Контрагент,
	               |				ВложенныйЗапрос.ТорговаяТочка) КАК ВложенныйЗапрос
	               |				ВНУТРЕННЕЕ СОЕДИНЕНИЕ РегистрСведений.СтавкиДисконтированияПоДоговорам КАК СтавкиДисконтированияПоДоговорам
	               |				ПО ВложенныйЗапрос.Период = СтавкиДисконтированияПоДоговорам.Период) КАК ВложенныйЗапрос
	               |		ПО ВсеВместе.Контрагент = ВложенныйЗапрос.Контрагент
	               |			И ВсеВместе.ТорговаяТочка = ВложенныйЗапрос.ТорговаяТочка
	               |
	               |УПОРЯДОЧИТЬ ПО
	               |	НачалоПериода
	               |;
	               |
	               |////////////////////////////////////////////////////////////////////////////////
	               |ВЫБРАТЬ
	               |	ВложенныйЗапрос.Организация,
	               |	ВложенныйЗапрос.ТорговаяТочка,
	               |	ВложенныйЗапрос.Контрагент,
	               |	ВложенныйЗапрос.НачалоПериода,
	               |	ВложенныйЗапрос.КонецПериода,
	               |	СУММА(ВложенныйЗапрос.СуммаАктива) КАК СуммаАктива,
	               |	СУММА(ВложенныйЗапрос.СуммаАмортизации) КАК СуммаАмортизации
	               |ИЗ
	               |	(ВЫБРАТЬ
	               |		ФинансовыйОстаткиИОбороты.Организация КАК Организация,
	               |		ФинансовыйОстаткиИОбороты.Субконто1 КАК ТорговаяТочка,
	               |		ФинансовыйОстаткиИОбороты.Субконто2 КАК Контрагент,
	               |		НАЧАЛОПЕРИОДА(ФинансовыйОстаткиИОбороты.Период, МЕСЯЦ) КАК НачалоПериода,
	               |		КОНЕЦПЕРИОДА(ФинансовыйОстаткиИОбороты.Период, МЕСЯЦ) КАК КонецПериода,
	               |		ФинансовыйОстаткиИОбороты.СуммаМСФОКонечныйОстаток КАК СуммаАктива,
	               |		0 КАК СуммаАмортизации
	               |	ИЗ
	               |		РегистрБухгалтерии.Финансовый.ОстаткиИОбороты(
	               |				,
	               |				,
	               |				Месяц,
	               |				,
	               |				Счет = ЗНАЧЕНИЕ(ПланСчетов.Финансовый.АктивПоАрендеАренда),
	               |				,
	               |				Организация = &Организация
	               |					И Субконто1 = &ТорговаяТочка
	               |					И Субконто2 = &Контрагент) КАК ФинансовыйОстаткиИОбороты
	               |	
	               |	ОБЪЕДИНИТЬ ВСЕ
	               |	
	               |	ВЫБРАТЬ
	               |		ФинансовыйОстаткиИОбороты.Организация,
	               |		ФинансовыйОстаткиИОбороты.Субконто1,
	               |		ФинансовыйОстаткиИОбороты.Субконто2,
	               |		НАЧАЛОПЕРИОДА(ФинансовыйОстаткиИОбороты.Период, МЕСЯЦ),
	               |		КОНЕЦПЕРИОДА(ФинансовыйОстаткиИОбороты.Период, МЕСЯЦ),
	               |		0,
	               |		-ФинансовыйОстаткиИОбороты.СуммаМСФОКонечныйОстаток
	               |	ИЗ
	               |		РегистрБухгалтерии.Финансовый.ОстаткиИОбороты(
	               |				,
	               |				,
	               |				Месяц,
	               |				,
	               |				Счет = ЗНАЧЕНИЕ(ПланСчетов.Финансовый.АмортизацияРасходыПоАренде),
	               |				,
	               |				Организация = &Организация
	               |					И Субконто1 = &ТорговаяТочка
	               |					И Субконто2 = &Контрагент) КАК ФинансовыйОстаткиИОбороты) КАК ВложенныйЗапрос
	               |
	               |СГРУППИРОВАТЬ ПО
	               |	ВложенныйЗапрос.Организация,
	               |	ВложенныйЗапрос.ТорговаяТочка,
	               |	ВложенныйЗапрос.Контрагент,
	               |	ВложенныйЗапрос.НачалоПериода,
	               |	ВложенныйЗапрос.КонецПериода
	               |;
	               |
	               |////////////////////////////////////////////////////////////////////////////////
	               |ВЫБРАТЬ
	               |	ВложенныйЗапрос.Организация,
	               |	ВложенныйЗапрос.ТорговаяТочка,
	               |	ВложенныйЗапрос.Контрагент,
	               |	СУММА(ВложенныйЗапрос.СуммаАктива) КАК СуммаАктива,
	               |	СУММА(ВложенныйЗапрос.СуммаАмортизации) КАК СуммаАмортизации
	               |ИЗ
	               |	(ВЫБРАТЬ
	               |		ФинансовыйОстаткиИОбороты.Организация КАК Организация,
	               |		ФинансовыйОстаткиИОбороты.Субконто1 КАК ТорговаяТочка,
	               |		ФинансовыйОстаткиИОбороты.Субконто2 КАК Контрагент,
	               |		ФинансовыйОстаткиИОбороты.СуммаМСФООборот КАК СуммаАктива,
	               |		0 КАК СуммаАмортизации
	               |	ИЗ
	               |		РегистрБухгалтерии.Финансовый.ОстаткиИОбороты(
	               |				&ДатаНачалаУчета,
	               |				&ДатаНачалаУчета,
	               |				Запись,
	               |				,
	               |				Счет = ЗНАЧЕНИЕ(ПланСчетов.Финансовый.АктивПоАрендеАренда),
	               |				,
	               |				Организация = &Организация
	               |					И Субконто1 = &ТорговаяТочка
	               |					И Субконто2 = &Контрагент) КАК ФинансовыйОстаткиИОбороты
	               |	
	               |	ОБЪЕДИНИТЬ ВСЕ
	               |	
	               |	ВЫБРАТЬ
	               |		ФинансовыйОстаткиИОбороты.Организация,
	               |		ФинансовыйОстаткиИОбороты.Субконто1,
	               |		ФинансовыйОстаткиИОбороты.Субконто2,
	               |		0,
	               |		-ФинансовыйОстаткиИОбороты.СуммаМСФООборот
	               |	ИЗ
	               |		РегистрБухгалтерии.Финансовый.ОстаткиИОбороты(
	               |				&ДатаНачалаУчета,
	               |				&ДатаНачалаУчета,
	               |				Запись,
	               |				,
	               |				Счет = ЗНАЧЕНИЕ(ПланСчетов.Финансовый.АмортизацияРасходыПоАренде),
	               |				,
	               |				Организация = &Организация
	               |					И Субконто1 = &ТорговаяТочка
	               |					И Субконто2 = &Контрагент) КАК ФинансовыйОстаткиИОбороты) КАК ВложенныйЗапрос
	               |
	               |СГРУППИРОВАТЬ ПО
	               |	ВложенныйЗапрос.Организация,
	               |	ВложенныйЗапрос.ТорговаяТочка,
	               |	ВложенныйЗапрос.Контрагент";
	РезультатЗапроса = Запрос.ВыполнитьПакет();
	ТЗ = РезультатЗапроса[4].Выгрузить();
	ТЗ1 = РезультатЗапроса[5].Выгрузить();
	ТЗ_Проводки10118 = РезультатЗапроса[6].Выгрузить();
	
	ТекОстаток = 0;
	НомерЗакрытогоПериода = 0;
	Для каждого стр из ТЗ Цикл
		Если стр.Разница = 0 и стр.ДДПНачальныйОстаток <> 0 и ТекОстаток <> 0 Тогда
			стр.ДДПНачальныйОстаток = ТекОстаток;
			стр.Разница = стр.ДДПНачальныйОстаток - стр.Начисление;
			стр.ЕжемесячныйПроцент = Окр(стр.Разница * (стр.Ставка/1200), 2, 1);
			стр.ДДПКонечныйОстаток = стр.ДДПНачальныйОстаток + стр.ЕжемесячныйПроцент - стр.Начисление;
			Если стр.ДДПКонечныйОстаток < 0 Тогда
				стр.ЕжемесячныйПроцент = стр.ЕжемесячныйПроцент - стр.ДДПКонечныйОстаток;
				стр.ДДПКонечныйОстаток = 0;
			КонецЕсли;
			Если ТЗ.Индекс(стр) + 1 = ТЗ.Количество() Тогда
				стр.ЕжемесячныйПроцент = стр.ЕжемесячныйПроцент - стр.ДДПКонечныйОстаток;
				стр.ДДПКонечныйОстаток = 0;
			КонецЕсли;
		КонецЕсли;
		
		Если стр.Закрыто <> 0 Тогда
			стр.ЕжемесячныйПроцент = стр.ЕжемесячныйПроцент - стр.ДДПКонечныйОстаток;
			стр.ДДПКонечныйОстаток = 0;
			НомерЗакрытогоПериода = ТЗ.Индекс(стр);
		КонецЕсли;
		ТекОстаток = стр.ДДПКонечныйОстаток;
	КонецЦикла;
	Если НомерЗакрытогоПериода <> 0 Тогда
		ТекКол = ТЗ.Количество();
		Для й = 1 По ТекКол - НомерЗакрытогоПериода - 1 Цикл
			стр = ТЗ[ТекКол - й];
			ТЗ.Удалить(стр);
		КонецЦикла;
	КонецЕсли;
	
	// Заполнение осатка на 03.1 и 04.1
	СуммаАмортизации_Посл = 0;
	Для каждого стр из ТЗ Цикл
		Выборка = ТЗ1.НайтиСтроки(Новый Структура("НачалоПериода, КонецПериода", стр.НачалоПериода, стр.КонецПериода));
		Для каждого стр1 из Выборка Цикл
			стр.СуммаАктива031 = стр.СуммаАктива031 + стр1.СуммаАктива;
			стр.СуммаАмортизации = стр.СуммаАмортизации + стр1.СуммаАмортизации;
		КонецЦикла;
		
		Если стр.СуммаАмортизации <> 0 Тогда
			СуммаАмортизации_Посл = стр.СуммаАмортизации;
		КонецЕсли;
	КонецЦикла;
	
	// Дозаполнение по 03.1 после 1.01.18 
	СуммаАктива031_Посл = 0;
	Для каждого стр из ТЗ Цикл
		Если стр.СуммаАктива031 <> 0 Тогда
			СуммаАктива031_Посл = стр.СуммаАктива031;
		ИначеЕсли стр.СуммаАктива031 = 0 и СуммаАктива031_Посл <> 0 Тогда
			стр.СуммаАктива031 = СуммаАктива031_Посл;
		КонецЕсли;
	КонецЦикла;
	
	// Дозаполнение по 03.1 и 04.1 до 1.01.18 
	Если ТЗ_Проводки10118.Количество() > 0 Тогда
		СтрОстаток = ТЗ_Проводки10118[0];
		СуммаАктива031_Посл = СтрОстаток.СуммаАктива;
		СуммаАмортизации_Посл = СтрОстаток.СуммаАмортизации;
		Для й = 1 По ТЗ.Количество() Цикл
			стр = ТЗ[ТЗ.Количество() - й];
			Если стр.НачалоПериода >= '20180101' Тогда
				Продолжить;
			КонецЕсли;
			
			стр.СуммаАмортизации = СуммаАмортизации_Посл;
			СуммаАмортизации_Посл = СуммаАмортизации_Посл - Окр(СуммаАктива031_Посл / 60, 2, 1);

			стр.СуммаАктива031 = СуммаАктива031_Посл;
			СуммаАктива031_Посл = СуммаАктива031_Посл - стр.ИзменениеЕжемесячногоПлатежа;
		КонецЦикла;
	КонецЕсли;
	
	// Дозаполнение по 04.1 после 1.01.18 
	ТекАмортизация = 0;
	Для й = 1 По ТЗ.Количество() Цикл
		стр = ТЗ[й - 1];
		ТекАмортизация1 = стр.СуммаАмортизации;
		Если стр.СуммаАмортизации <> 0 Тогда
			стр.СуммаАмортизации = стр.СуммаАмортизации - ТекАмортизация;
		КонецЕсли;
		ТекАмортизация = ТекАмортизация1;
	КонецЦикла;
	
	ВнешниеНаборыДанных = Новый Структура;
	ВнешниеНаборыДанных.Вставить("ТЗ", ТЗ);
	
	СтандартнаяОбработка = Ложь; // отключаем стандартный вывод отчета - будем выводить программно 

	Настройки = КомпоновщикНастроек.ПолучитьНастройки() ;// Получаем настройки отчета 
	ДанныеРасшифровки = Новый ДанныеРасшифровкиКомпоновкиДанных; // Создаем данные расшифровки 
	КомпоновщикМакета = Новый КомпоновщикМакетаКомпоновкиДанных; // Создаем компоновщик макета 
	// Инициализируем макет компоновки используя схему компоновки данных 
	// и созданные ранее настройки и данные расшифровки
	СхемаКомпоновкиДанных = ПолучитьМакет("ОсновнаяСхемаКомпоновкиДанных");
	МакетКомпоновки = КомпоновщикМакета.Выполнить(СхемаКомпоновкиДанных, Настройки, ДанныеРасшифровки);
	
	// Скомпонуем результат
	ПроцессорКомпоновки = Новый ПроцессорКомпоновкиДанных;
	ПроцессорКомпоновки.Инициализировать(МакетКомпоновки, ВнешниеНаборыДанных, ДанныеРасшифровки);
	
	ДокументРезультат.Очистить();
	
	// Выводим результат в табличный документ
	ПроцессорВывода = Новый ПроцессорВыводаРезультатаКомпоновкиДанныхВТабличныйДокумент;
	ПроцессорВывода.УстановитьДокумент(ДокументРезультат);	
	ПроцессорВывода.Вывести(ПроцессорКомпоновки);
	
	ДокументРезультат.ФиксацияСверху = 6;	
	ДокументРезультат.ФиксацияСлева = 2;	
КонецПроцедуры
