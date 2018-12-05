﻿
&НаКлиенте
Процедура ОбработкаКоманды(ПараметрКоманды, ПараметрыВыполненияКоманды)
	//Вставить содержимое обработчика.
	//ПараметрыФормы = Новый Структура("", );
	//ОткрытьФорму("Документ.РеестрПолученныхДокументов.ФормаСписка", ПараметрыФормы, ПараметрыВыполненияКоманды.Источник, ПараметрыВыполненияКоманды.Уникальность, ПараметрыВыполненияКоманды.Окно, ПараметрыВыполненияКоманды.НавигационнаяСсылка);
	ТабДок = ПечатьРеестраСервер(ПараметрКоманды);
	ТабДок.Показать();
КонецПроцедуры

&НаСервере
Функция ПечатьРеестраСервер(Ссылка);
	ДанныеРасшифровки = Новый ДанныеРасшифровкиКомпоновкиДанных;
	КомпоновщикМакета = Новый КомпоновщикМакетаКомпоновкиДанных;
	
	СКД=Документы.РеестрПолученныхКонвертов.ПолучитьМакет("МакетПечатнойФормыРеестра");
	СКД.Параметры.Ссылки.Значение = Ссылка;
	
	
	ТабДок = Новый ТабличныйДокумент;
		
		
	НастройкиСКД = СКД.НастройкиПоУмолчанию;
		
		
	МакетКомпоновки = КомпоновщикМакета.Выполнить(СКД, НастройкиСКД, ДанныеРасшифровки);
		
	ПроцессорКомпоновкиДанных = Новый ПроцессорКомпоновкиДанных;
	ПроцессорКомпоновкиДанных.Инициализировать(МакетКомпоновки, ,ДанныеРасшифровки);
		

		
	ПроцессорВывода = Новый ПроцессорВыводаРезультатаКомпоновкиДанныхВТабличныйДокумент;
	ПроцессорВывода.УстановитьДокумент(ТабДок);
	ПроцессорВывода.Вывести(ПроцессорКомпоновкиДанных);
	Возврат ТабДок;
КонецФункции	
