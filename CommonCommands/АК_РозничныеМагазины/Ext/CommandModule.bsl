﻿
&НаКлиенте
Процедура ОбработкаКоманды(ПараметрКоманды, ПараметрыВыполненияКоманды)
	
	//+++АК_Кибарев, 10.09.17, ИП-00016684
	
	ПараметрыФормы = Новый Структура("АК_РозничныеМагазины", Истина);
	МФорма = ПолучитьФорму("Справочник.СтруктурныеЕдиницы.ФормаСписка", ПараметрыФормы);
		
	УстновитьОтборВСписке(мФорма);	
	МФорма.Открыть();
	
	//---АК_Кибарев, 10.09.17, ИП-00016684
	
КонецПроцедуры

&НаКлиенте
Процедура УстновитьОтборВСписке(мФорма)
	
	элОтбора = МФорма.Список.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	элОтбора.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("ТипСтруктурнойЕдиницы");
	элОтбора.ВидСравнения = ВидСравненияКомпоновкиДанных.Равно;
	элОтбора.ПравоеЗначение = ПеречисленияТипыСтруктурныхЕдиницРозница();
	элОтбора.Использование = Истина;
	
	элОтбора = МФорма.Список.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	элОтбора.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("ТипРозничнойТочки");
	элОтбора.ВидСравнения = ВидСравненияКомпоновкиДанных.НеРавно;
	элОтбора.ПравоеЗначение = ПеречисленияТипыРозничныхТочекИзбенка();
	элОтбора.Использование = Истина;
	
КонецПроцедуры

&НаСервере
Функция ПеречисленияТипыСтруктурныхЕдиницРозница()
	Возврат Перечисления.ТипыСтруктурныхЕдиниц.Розница;
КонецФункции

&НаСервере
Функция ПеречисленияТипыРозничныхТочекИзбенка()
	Возврат Перечисления.ТипыРозничныхТочек.Избенка;
КонецФункции



