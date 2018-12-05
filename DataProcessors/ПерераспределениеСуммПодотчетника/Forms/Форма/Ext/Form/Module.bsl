﻿
&НаКлиенте
Процедура СоздатьДокументы(Команда)
	Если Объект.Сумма<>Объект.КудаРаспределять.Итог("Сумма") и Объект.Сумма<>0 Тогда
		Сообщение=Новый СообщениеПользователю;
		Сообщение.Текст="Для формирование документов итог по табличной части должен совпадать с суммой к закрытию";
		Сообщение.Сообщить();
	Иначе
		СоздатьДокументыСервер();
	КонецЕсли;	
КонецПроцедуры

&НаСервере
Процедура СоздатьДокументыСервер()
	Если Объект.сумма >0 Тогда
		ПКО=Документы.ПоступлениеВКассу.СоздатьДокумент();
		ПКО.Организация=Объект.Организация;
		ПКО.ДокументОснование=Объект.АвансовыйОтчет;
		
		ПКО.Дата=Объект.Дата;
		ПКО.ВидОперации=Перечисления.ВидыОперацийПКО.ПриходДенежныхСредствПрочее;
		ПКО.Комментарий="Сформирован обработкой перераспределения сумм подотчетника";
		ПКО.ПринятоОт=Объект.ФизЛицо.НаименованиеПолное;
		ПКО.СтатьяДвиженияДенежныхСредств=Справочники.СтатьиДвиженияДенежныхСредств.НайтиПоКоду("901012");
		ПКО.СтатьяДвиженияДенежныхСредствБУ=ОбщегоНазначенияСервер.ПолучитьСтатьюДДС_БУ(ПКО.СтатьяДвиженияДенежныхСредств,ПКО.ВидОперации);
		ПКО.СтруктурнаяЕдиница=Объект.СтруктурнаяЕдиница;
		ПКО.СубконтоКт1=ПКО.Организация;
		ПКО.СубконтоКт2=Объект.ФизЛицо;
		ПКО.СуммаДокумента=Объект.Сумма;
		ПКО.СчетБУ=ПланыСчетов.Хозрасчетный.НайтиПоКоду("71");
		ПКО.СчетКасса=ПланыСчетов.Хозрасчетный.НайтиПоКоду("50");
		ПКО.СчетУчетаРасчетовСКонтрагентом=ПланыСчетов.Финансовый.НайтиПоКоду("71.1");
		ПКО.ТорговаяТочка=Объект.СтруктурнаяЕдиница;
		ПКО.Записать();
		ПКО.Записать(РежимЗаписиДокумента.Проведение);
		Сообщить("Сформирован "+ПКО);
		Для каждого стр из объект.КудаРаспределять Цикл
			РКО=Документы.РасходИзКассы.СоздатьДокумент();
			РКО.ДокументОснование=Объект.АвансовыйОтчет;
			//Стр=РКО.ДокументыОснования.Добавить();
			//Стр.ДокументОснование=Объект.АвансовыйОтчет;
			РКО.ВидОперации=Перечисления.ВидыОперацийРКО.РасходДенежныхСредствПрочее;
			РКО.Выдать=Объект.ФизЛицо;
			РКО.Дата=Объект.Дата;
			РКО.Комментарий="Сформирован обработкой перераспределения сумм подотчетника";
			РКО.Организация=Стр.Организация;
			РКО.СтатьяДвиженияДенежныхСредств=?(ЗначениеЗаполнено(Стр.СтатьяДДС),Стр.СтатьяДДС,Справочники.СтатьиДвиженияДенежныхСредств.НайтиПоКоду("901012"));
			РКО.СтруктурнаяЕдиница=Объект.СтруктурнаяЕдиница;
			РКО.СубконтоДт1=Стр.Организация;
			РКО.СубконтоДт2=Объект.ФизЛицо;
			РКО.СуммаДокумента=Стр.Сумма;
			РКО.СчетКасса=ПланыСчетов.Хозрасчетный.НайтиПоКоду("50");
			РКО.СчетУчетаРасчетовСКонтрагентом=ПланыСчетов.Финансовый.НайтиПоКоду("71.1");
			РКО.СчетУчетаРасчетовСКонтрагентомБУ=ПланыСчетов.Хозрасчетный.НайтиПоКоду("71");
			РКО.ДополнительныеСвойства.Вставить("НеПроверятьЗаявку",истина);
			РКО.СтатьяДвиженияДенежныхСредствБУ=ОбщегоНазначенияСервер.ПолучитьСтатьюДДС_БУ(РКО.СтатьяДвиженияДенежныхСредств,РКО.ВидОперации);
			РКО.Записать();
			РКО.Записать(РежимЗаписиДокумента.Проведение);
			Сообщить("Сформирован "+РКО);
		КонецЦикла;	
	ИначеЕсли Объект.сумма <0 Тогда
		СтатьяДДСБУ = ОбщегоНазначенияСервер.ПолучитьСтатьюДДС_БУ(Объект.СтатьяДДС,Перечисления.ВидыОперацийРКО.РасходДенежныхСредствПрочее);
		Если Не ЗначениеЗаполнено(СтатьяДДСБУ) Тогда
			Сообщить("Не найдено соответствие статьи ДДС УУ и БУ!", СтатусСообщения.Важное);
			Возврат;
		КонецЕсли;
		РКО=Документы.РасходИзКассы.СоздатьДокумент();
		РКО.ДокументОснование=Объект.АвансовыйОтчет;
		//Стр=РКО.ДокументыОснования.Добавить();
		//Стр.ДокументОснование=Объект.АвансовыйОтчет;
		РКО.ВидОперации=Перечисления.ВидыОперацийРКО.РасходДенежныхСредствПрочее;
		РКО.Выдать=Объект.ФизЛицо;
		РКО.Дата=Объект.Дата;
		РКО.Комментарий="Сформирован обработкой перераспределения сумм подотчетника";
		РКО.Организация=Объект.Организация;
		РКО.СтатьяДвиженияДенежныхСредств = Объект.СтатьяДДС;
		РКО.СтатьяДвиженияДенежныхСредствБУ=ОбщегоНазначенияСервер.ПолучитьСтатьюДДС_БУ(РКО.СтатьяДвиженияДенежныхСредств,РКО.ВидОперации);
		РКО.СтруктурнаяЕдиница=Объект.СтруктурнаяЕдиница;
		РКО.СубконтоДт1=Объект.Организация;;
		РКО.СубконтоДт2=Объект.ФизЛицо;
		РКО.СуммаДокумента=-Объект.Сумма;
		РКО.СчетКасса=ПланыСчетов.Хозрасчетный.НайтиПоКоду("50");
		РКО.СчетУчетаРасчетовСКонтрагентом=ПланыСчетов.Финансовый.НайтиПоКоду("71.1");
		РКО.СчетУчетаРасчетовСКонтрагентомБУ=ПланыСчетов.Хозрасчетный.НайтиПоКоду("71");
		РКО.ДополнительныеСвойства.Вставить("НеПроверятьЗаявку",истина);
		РКО.СтатьяДвиженияДенежныхСредствБУ=СтатьяДДСБУ;
		РКО.Записать();
		РКО.Записать(РежимЗаписиДокумента.Проведение);
		Сообщить("Сформирован "+РКО);	
		Для каждого стр из объект.КудаРаспределять Цикл
			ПКО = Документы.ПоступлениеВКассу.СоздатьДокумент();
			ПКО.Организация = Стр.Организация;
			ПКО.ДокументОснование=Объект.АвансовыйОтчет;
			ПКО.Дата = Объект.Дата;
			ПКО.ВидОперации = Перечисления.ВидыОперацийПКО.ПриходДенежныхСредствПрочее;
			ПКО.Комментарий = "Сформирован обработкой перераспределения сумм подотчетника";
			ПКО.ПринятоОт = Объект.ФизЛицо.НаименованиеПолное;
			ПКО.СтатьяДвиженияДенежныхСредств = Справочники.СтатьиДвиженияДенежныхСредств.НайтиПоКоду("901012");
			ПКО.СтруктурнаяЕдиница = Объект.СтруктурнаяЕдиница;
			ПКО.СубконтоКт1 = ПКО.Организация;
			ПКО.СубконтоКт2 = Объект.ФизЛицо;
			ПКО.СуммаДокумента = -Стр.Сумма;
			ПКО.СчетБУ = ПланыСчетов.Хозрасчетный.НайтиПоКоду("71");
			ПКО.СчетКасса = ПланыСчетов.Хозрасчетный.НайтиПоКоду("50");
			ПКО.СчетУчетаРасчетовСКонтрагентом = ПланыСчетов.Финансовый.НайтиПоКоду("71.1");
			ПКО.ТорговаяТочка = Объект.СтруктурнаяЕдиница;
			ПКО.СтатьяДвиженияДенежныхСредствБУ = ОбщегоНазначенияСервер.ПолучитьСтатьюДДС_БУ(ПКО.СтатьяДвиженияДенежныхСредств,ПКО.ВидОперации);
			ПКО.Записать();
			ПКО.Записать(РежимЗаписиДокумента.Проведение);
			Сообщить("Сформирован "+ПКО);
		КонецЦикла;	
	КонецЕсли;	
КонецПроцедуры	

&НаКлиенте
Процедура ОбновитьОстаток(Команда)
	ОбновитьОстатокСервер();
КонецПроцедуры

&НаСервере
Процедура ОбновитьОстатокСервер(Избенка=Ложь)
	Объект.КудаРаспределять.Очистить();
	ОргИзбенка=Справочники.Организации.Избенка;
	ТекстЗапроса="ВЫБРАТЬ
	|	ФинансовыйОстатки.СуммаОстаток КАК Остаток,
	|	ФинансовыйОстатки.Субконто1 КАК Организация
	|ИЗ
	|	РегистрБухгалтерии.Финансовый.Остатки(
	|			&Дата,
	|			Счет = ЗНАЧЕНИЕ(ПланСчетов.Финансовый.РасчетыСПодотчетнымиЛицами),
	|			,
	|			Субконто2 = &ФизЛицо
	|				) КАК ФинансовыйОстатки";
	
	Запрос=Новый Запрос(ТекстЗапроса);			 
	Запрос.УстановитьПараметр("Дата",Объект.Дата);
	Запрос.УстановитьПараметр("ФизЛицо",Объект.ФизЛицо);
	Запрос.УстановитьПараметр("Организация",Объект.Организация);
	выборка=Запрос.Выполнить().Выбрать();
	Объект.Сумма=0;
	Если Избенка И ЗначениеЗаполнено(Объект.АвансовыйОтчет) И Объект.АвансовыйОтчет.Организация=ОргИзбенка Тогда
		Пока Выборка.Следующий() Цикл
			Если Выборка.Организация=Объект.Организация Тогда	
				Объект.Сумма=-Выборка.Остаток;
			ИначеЕсли Выборка.Остаток>0 Тогда	
				ОргКуда=Выборка.Организация;
			КонецЕсли;
		КонецЦикла;	
		Если ЗначениеЗаполнено(ОргКуда) Тогда
			Объект.Организация=ОргКуда;
		КонецЕсли;
		Для Каждого Стр Из Объект.АвансовыйОтчет.Услуги Цикл
			НС=Объект.КудаРаспределять.Добавить();
			НС.Сумма=Стр.Сумма;
			Если ТипЗнч(Стр.Субконто2)=Тип("СправочникСсылка.СтатьиДоходовРасходов") Тогда
				НС.СтатьяДДС=Стр.Субконто2.ОсновнаяСтатьяДвиженияДенежныхСредств;
			КонецЕсли;
			//Если ЗначениеЗаполнено(ОргКуда) Тогда 
			НС.Организация= ОргИзбенка;
			//КонецЕсли;	
			
		КонецЦикла;	
	Иначе	
		Пока Выборка.Следующий() Цикл
			Если Выборка.Организация=Объект.Организация Тогда	
				Объект.Сумма=Выборка.Остаток;
			Иначе	
				НС=Объект.КудаРаспределять.Добавить();
				НС.Организация=Выборка.Организация;
				НС.Сумма=Выборка.Остаток;
			КонецЕсли;
		КонецЦикла;	
	КонецЕсли;	
	
	ТЗ=Объект.КудаРаспределять.Выгрузить();
	ТЗ.Свернуть("Организация,СтатьяДДС","Сумма");
	Объект.КудаРаспределять.Загрузить(ТЗ);
	
	Если Объект.КудаРаспределять.Количество()= 0 Тогда
		//НС=Объект.КудаРаспределять.Добавить();
		//Если Объект.Организация<>Справочники.Организации.Избенка Тогда
		//	НС.Организация=Справочники.Организации.Избенка;
		//КонецЕсли;	
		//НС.Сумма=Объект.Сумма;
	ИначеЕсли Объект.КудаРаспределять.Количество()= 1 Тогда
		//Объект.КудаРаспределять[0].Сумма=Объект.Сумма;	
	КонецЕсли;	
	Если Объект.Сумма=0 Тогда
		//Объект.Сумма=Объект.КудаРаспределять.Итог("Сумма");
	КонецЕсли;	
КонецПроцедуры	

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	Объект.СтруктурнаяЕдиница=Справочники.СтруктурныеЕдиницы.НайтиПоКоду("000000250");
	Объект.СтатьяДДС = Справочники.СтатьиДвиженияДенежныхСредств.НайтиПоКоду("901012");
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	Если Объект.Организация=Справочники.Организации.Избенка Тогда
		Элементы.Группа3.ТекущаяСтраница=Элементы.Группа6;
		Объект.Дата=КонецМесяца(Объект.АвансовыйОтчет.Дата);
		ОбновитьОстатокСервер(Истина);
	Иначе
		ОбновитьОстатокСервер();
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура ДатаПриИзменении(Элемент)
	ОбновитьОстатокСервер()
КонецПроцедуры

&НаКлиенте
Процедура ФизЛицоПриИзменении(Элемент)
	ОбновитьОстатокСервер()
КонецПроцедуры

&НаКлиенте
Процедура ОрганизацияПриИзменении(Элемент)
	ОбновитьОстатокСервер()
КонецПроцедуры

&НаКлиенте
Процедура ЗаполнитьЗаПериод(Команда)
	ЗаполнитьОстаткиПоИзбеСервер();
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьОстаткиПоИзбеСервер()
	ТекстЗапроса="ВЫБРАТЬ
	|	СотрудникиОрганизаций.Физлицо,
	|	МАКСИМУМ(СотрудникиОрганизаций.Организация) КАК Организация
	|ПОМЕСТИТЬ ОрганизацииФизлиц
	|ИЗ
	|	Справочник.СотрудникиОрганизаций КАК СотрудникиОрганизаций
	|ГДЕ
	|	СотрудникиОрганизаций.ДатаУвольнения = &ДатаУвольнения
	|	И СотрудникиОрганизаций.Организация <> &Организация
	|
	|СГРУППИРОВАТЬ ПО
	|	СотрудникиОрганизаций.Физлицо
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ФинансовыйОстатки.Субконто2 КАК ФизЛицо,
	|	-ФинансовыйОстатки.СуммаОстаток КАК Остаток,
	|	ОрганизацииФизлиц.Организация КАК Организация
	|ИЗ
	|	РегистрБухгалтерии.Финансовый.Остатки(&НаДату, Счет.Код = ""71.1"", , Субконто1 = &Организация) КАК ФинансовыйОстатки
	|		ЛЕВОЕ СОЕДИНЕНИЕ ОрганизацииФизлиц КАК ОрганизацииФизлиц
	|		ПО ФинансовыйОстатки.Субконто2 = ОрганизацииФизлиц.Физлицо
	|
	|УПОРЯДОЧИТЬ ПО
	|	Организация,
	|	ФизЛицо";
	Запрос=Новый Запрос(ТекстЗапроса);			 
	Запрос.УстановитьПараметр("НаДату",КонецМесяца(Объект.Дата)+1);
	Запрос.УстановитьПараметр("ДатаС",НачалоМесяца(Объект.Дата));
	Запрос.УстановитьПараметр("Организация",Справочники.Организации.Избенка);
	Запрос.УстановитьПараметр("ДатаУвольнения",Дата(1,1,1));
	ЗначениеВРеквизитФормы(Запрос.Выполнить().Выгрузить(),"ОстаткиПодотчета");
	
	
КонецПроцедуры	

&НаСервере
Процедура ЗаполнитьЗаПериодСервер()
	ТекстЗапроса="ВЫБРАТЬ
	|	ФинансовыйОбороты.Регистратор.ФизЛицо,
	|	ФинансовыйОбороты.Регистратор.Организация,
	|	ФинансовыйОбороты.СуммаОборот,
	|	ФинансовыйОбороты.Субконто2 КАК СтатьяДР
	|ИЗ
	|	РегистрБухгалтерии.Финансовый.Обороты(&НачПер, &КонПер, Регистратор, Счет = &Сч44_3, , , , ) КАК ФинансовыйОбороты
	|ГДЕ
	|	ФинансовыйОбороты.Регистратор ССЫЛКА Документ.АвансовыйОтчет
	|	И ФинансовыйОбороты.Регистратор.Организация = &Организация
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ФинансовыйОстатки.СуммаОстаток,
	|	ФинансовыйОстатки.Субконто1 КАК Организация,
	|	ФинансовыйОстатки.Субконто2 КАК ФизЛицо
	|ИЗ
	|	РегистрБухгалтерии.Финансовый.Остатки(&КонПер, Счет = &Сч71_1, , Субконто1 <> &Организация) КАК ФинансовыйОстатки
	|ГДЕ
	|	ФинансовыйОстатки.СуммаОстаток > 0";
КонецПроцедуры	

&НаКлиенте
Процедура СоздатьДокументыИзбенка(Команда)
	// Вставить содержимое обработчика.
КонецПроцедуры

&НаКлиенте
Процедура ОбновитьОстатокИзбенка(Команда)
	ОбновитьОстатокСервер(Истина);
КонецПроцедуры

&НаКлиенте
Процедура ДатаПриИзмененииИзбенка(Элемент)
	ОбновитьОстатокСервер(Истина)
КонецПроцедуры

&НаКлиенте
Процедура ФизЛицоПриИзмененииИзбенка(Элемент)
	ОбновитьОстатокСервер(Истина)
КонецПроцедуры

&НаКлиенте
Процедура ОрганизацияПриИзмененииИзбенка(Элемент)
	ОбновитьОстатокСервер(Истина)
КонецПроцедуры

&НаКлиенте
Процедура СоздатьДокументыПКО(Команда)
	СоздатьДокументыПКОСервер();
КонецПроцедуры

&НаСервере
Процедура СоздатьДокументыПКОСервер()
	
	//СтатьяДДСБУ = ОбщегоНазначенияСервер.ПолучитьСтатьюДДС_БУ(Объект.СтатьяДДС,Перечисления.ВидыОперацийРКО.РасходДенежныхСредствПрочее);
	//Если Не ЗначениеЗаполнено(СтатьяДДСБУ) Тогда
	//	Сообщить("Не найдено соответствие статьи ДДС УУ и БУ!", СтатусСообщения.Важное);
	//	Возврат;
	//КонецЕсли;
	Для каждого стр из ОстаткиПодотчета Цикл
		ПКО = Документы.ПоступлениеВКассу.СоздатьДокумент();
		ПКО.Организация = Стр.Организация;
		//ПКО.ДокументОснование=Объект.АвансовыйОтчет;
		ПКО.Дата = Объект.Дата;
		ПКО.ВидОперации = Перечисления.ВидыОперацийПКО.ПриходДенежныхСредствПрочее;
		ПКО.Комментарий = "Сформирован обработкой перераспределения сумм подотчетника, закрытие остатка.";
		ПКО.ПринятоОт = Стр.ФизЛицо.НаименованиеПолное;
		ПКО.СтатьяДвиженияДенежныхСредств = Справочники.СтатьиДвиженияДенежныхСредств.НайтиПоКоду("901012");
		ПКО.СтруктурнаяЕдиница = Объект.СтруктурнаяЕдиница;
		ПКО.СубконтоКт1 = ПКО.Организация;
		ПКО.СубконтоКт2 = Стр.ФизЛицо;
		ПКО.СуммаДокумента = Стр.Остаток;
		ПКО.СчетБУ = ПланыСчетов.Хозрасчетный.НайтиПоКоду("71");
		ПКО.СчетКасса = ПланыСчетов.Хозрасчетный.НайтиПоКоду("50");
		ПКО.СчетУчетаРасчетовСКонтрагентом = ПланыСчетов.Финансовый.НайтиПоКоду("71.1");
		ПКО.ТорговаяТочка = Объект.СтруктурнаяЕдиница;
		ПКО.СтатьяДвиженияДенежныхСредствБУ = ОбщегоНазначенияСервер.ПолучитьСтатьюДДС_БУ(ПКО.СтатьяДвиженияДенежныхСредств,ПКО.ВидОперации);
		ПКО.Записать();
		ПКО.Записать(РежимЗаписиДокумента.Проведение);
		Сообщить("Сформирован "+ПКО);
	КонецЦикла;	
	
КонецПроцедуры	

&НаКлиенте
Процедура СформироватьРКО58(Команда)
	СформироватьРКО58Сервер();
КонецПроцедуры

&НаСервере
Процедура СформироватьРКО58Сервер()
	КривенкоФизлицо=Справочники.Контрагенты.НайтиПоКоду("000000414");
	Для каждого стр из объект.КудаРаспределять Цикл
		РКО=Документы.РасходИзКассы.СоздатьДокумент();
		РКО.ДокументОснование=Объект.АвансовыйОтчет;
		//Стр=РКО.ДокументыОснования.Добавить();
		//Стр.ДокументОснование=Объект.АвансовыйОтчет;
		РКО.ВидОперации=Перечисления.ВидыОперацийРКО.РасходДенежныхСредствПрочее;
		РКО.Выдать=Объект.ФизЛицо;
		РКО.Дата=Объект.Дата;
		РКО.Комментарий="Сформирован обработкой перераспределения сумм подотчетника";
		РКО.Организация=Стр.Организация;
		РКО.СтатьяДвиженияДенежныхСредств=?(ЗначениеЗаполнено(Стр.СтатьяДДС),Стр.СтатьяДДС,Справочники.СтатьиДвиженияДенежныхСредств.НайтиПоКоду("901012"));
		РКО.СтруктурнаяЕдиница=Объект.СтруктурнаяЕдиница;
		РКО.СубконтоДт1=Стр.Организация;
		РКО.СубконтоДт2=КривенкоФизЛицо;
		РКО.СуммаДокумента=Стр.Сумма;
		РКО.СчетКасса=ПланыСчетов.Хозрасчетный.НайтиПоКоду("50");
		РКО.СчетУчетаРасчетовСКонтрагентом=ПланыСчетов.Финансовый.НайтиПоКоду("58.1");
		РКО.СчетУчетаРасчетовСКонтрагентомБУ=ПланыСчетов.Хозрасчетный.НайтиПоКоду("58.03");
		РКО.ДополнительныеСвойства.Вставить("НеПроверятьЗаявку",истина);
		РКО.СтатьяДвиженияДенежныхСредствБУ=ОбщегоНазначенияСервер.ПолучитьСтатьюДДС_БУ(РКО.СтатьяДвиженияДенежныхСредств,РКО.ВидОперации);
		РКО.Записать();
		РКО.Записать(РежимЗаписиДокумента.Проведение);
		Сообщить("Сформирован "+РКО);
	КонецЦикла;
КонецПроцедуры	

&НаКлиенте
Процедура СформироватьПКО58(Команда)
	СформироватьПКО58Сервер();
КонецПроцедуры
Процедура СформироватьПКО58Сервер()
	КривенкоФизлицо=Справочники.Контрагенты.НайтиПоКоду("000000414");
	Для каждого стр из объект.КудаРаспределять Цикл
		ПКО = Документы.ПоступлениеВКассу.СоздатьДокумент();
		ПКО.Организация = Стр.Организация;
		ПКО.ДокументОснование=Объект.АвансовыйОтчет;
		ПКО.Дата = Объект.Дата;
		ПКО.ВидОперации = Перечисления.ВидыОперацийПКО.ПриходДенежныхСредствПрочее;
		ПКО.Комментарий = "Сформирован обработкой перераспределения сумм подотчетника";
		ПКО.ПринятоОт = Объект.ФизЛицо.НаименованиеПолное;
		ПКО.СтатьяДвиженияДенежныхСредств = ?(ЗначениеЗаполнено(Стр.СтатьяДДС),Стр.СтатьяДДС,Справочники.СтатьиДвиженияДенежныхСредств.НайтиПоКоду("901012"));
		ПКО.СтруктурнаяЕдиница = Объект.СтруктурнаяЕдиница;
		ПКО.СубконтоКт1 = Стр.Организация;
		ПКО.СубконтоКт2 = КривенкоФизлицо;
		ПКО.СуммаДокумента = Стр.Сумма;
		ПКО.СчетБУ = ПланыСчетов.Хозрасчетный.НайтиПоКоду("58.03");
		ПКО.СчетКасса = ПланыСчетов.Хозрасчетный.НайтиПоКоду("50");
		ПКО.СчетУчетаРасчетовСКонтрагентом = ПланыСчетов.Финансовый.НайтиПоКоду("58.1");
		ПКО.ТорговаяТочка = Объект.СтруктурнаяЕдиница;
		ПКО.СтатьяДвиженияДенежныхСредствБУ = ОбщегоНазначенияСервер.ПолучитьСтатьюДДС_БУ(ПКО.СтатьяДвиженияДенежныхСредств,ПКО.ВидОперации);
		ПКО.Записать();
		ПКО.Записать(РежимЗаписиДокумента.Проведение);
		Сообщить("Сформирован "+ПКО);
	КонецЦикла;	
КонецПроцедуры	


