﻿
Процедура ПриЗаписи(Отказ, Замещение)
	
КонецПроцедуры

Процедура ПередЗаписью(Отказ, Замещение)
	Если ОбменДанными.Загрузка = Истина Тогда
		Возврат;
	КонецЕсли;	
	ТекстЗапроса="ВЫБРАТЬ
	             |	ВложенныйЗапрос.Заявка,
	             |	ВложенныйЗапрос.УИН_СтрокиОплат,
	             |	СУММА(ВложенныйЗапрос.СуммаОстаток) КАК СуммаОстаток
	             |ИЗ
	             |	(ВЫБРАТЬ
	             |		РасчетыПоЗаявкамНаУслугиМатериалыОстатки.Заявка КАК Заявка,
	             |		РасчетыПоЗаявкамНаУслугиМатериалыОстатки.УИН_СтрокиОплат КАК УИН_СтрокиОплат,
	             |		РасчетыПоЗаявкамНаУслугиМатериалыОстатки.СуммаОстаток КАК СуммаОстаток
	             |	ИЗ
	             |		РегистрНакопления.РасчетыПоЗаявкамНаУслугиМатериалы.Остатки(
	             |				,
	             |				Заявка = &Регистратор
	             |					ИЛИ Заявка В
	             |						(
				 //ВЫБРАТЬ
				 //|							РасходИзБанка.ЗаявкаНаРасходованиеСредств КАК ЗаявкаНаРасходованиеСредств
				 //|						ИЗ
				 //|							Документ.РасходИзБанка КАК РасходИзБанка
				 //|						ГДЕ
				 //|							РасходИзБанка.Ссылка = &Регистратор  И РасходИзБанка.ЗаявкаНаРасходованиеСредств Ссылка Документ.ЗаявкаНаУслугиМатериалы)
				 //|				
				 //|						ОБЪЕДИНИТЬ ВСЕ
	             |				
	             |						ВЫБРАТЬ
	             |							РасходИзБанка.ДокументОснование КАК ДокументОснование
	             |						ИЗ
	             |							Документ.РасходИзБанка КАК РасходИзБанка
	             |						ГДЕ
	             |							РасходИзБанка.Ссылка = &Регистратор И РасходИзБанка.ДокументОснование Ссылка Документ.ЗаявкаНаУслугиМатериалы)) КАК РасчетыПоЗаявкамНаУслугиМатериалыОстатки
	             |	
	             |	ОБЪЕДИНИТЬ ВСЕ
	             |	
	             |	ВЫБРАТЬ
	             |		РасчетыПоЗаявкамНаУслугиМатериалы.Заявка,
	             |		РасчетыПоЗаявкамНаУслугиМатериалы.УИН_СтрокиОплат,
	             |		ВЫБОР
	             |			КОГДА РасчетыПоЗаявкамНаУслугиМатериалы.ВидДвижения = ЗНАЧЕНИЕ(ВидДвиженияНакопления.Приход)
	             |				ТОГДА -РасчетыПоЗаявкамНаУслугиМатериалы.Сумма
	             |			ИНАЧЕ РасчетыПоЗаявкамНаУслугиМатериалы.Сумма
	             |		КОНЕЦ
	             |	ИЗ
	             |		РегистрНакопления.РасчетыПоЗаявкамНаУслугиМатериалы КАК РасчетыПоЗаявкамНаУслугиМатериалы
	             |	ГДЕ
	             |		РасчетыПоЗаявкамНаУслугиМатериалы.Регистратор = &Регистратор) КАК ВложенныйЗапрос
	             |
	             |СГРУППИРОВАТЬ ПО
	             |	ВложенныйЗапрос.Заявка,
	             |	ВложенныйЗапрос.УИН_СтрокиОплат";
	Запрос=Новый Запрос(ТекстЗапроса);		
	Регистратор = ЭтотОбъект.Отбор.Регистратор.Значение;
	Если ТипЗнч(Регистратор) = Тип("ДокументСсылка.РасходИзБанка") И Регистратор.Оплачено Тогда
		Возврат;
	КонецЕсли;	
	Запрос.УстановитьПараметр("Регистратор",Регистратор);
	ТекущиеОстатки = Запрос.Выполнить().Выгрузить();
	Для Каждого Дв Из ЭтотОбъект Цикл
		НС = ТекущиеОстатки.Добавить();
		ЗаполнитьЗначенияСвойств(НС,Дв);
		НС.СуммаОстаток = ?(Дв.ВидДвижения = ВидДвиженияНакопления.Приход,Дв.Сумма,-Дв.Сумма);
	КонецЦикла;	
	ТекущиеОстатки.Свернуть("Заявка","СуммаОстаток");
	ТекущиеОстатки.Сортировать("СуммаОстаток");
	Если ТекущиеОстатки.Количество()>0 И ТекущиеОстатки[0].СуммаОстаток < 0 Тогда
		Отказ = Истина;
		Сообщить("Возникает переплата по этапу оплаты по заявке "+ ТекущиеОстатки[0].Заявка);
	КонецЕсли;	
КонецПроцедуры
