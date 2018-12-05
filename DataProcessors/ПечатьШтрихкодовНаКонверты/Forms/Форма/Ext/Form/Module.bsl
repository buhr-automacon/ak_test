﻿
&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	Дата = ТекущаяДата();
	//Магазин = УправлениеПользователями.ПолучитьЗначениеПоУмолчанию(ПараметрыСеанса.ТекущийПользователь, "ОсновноеСтруктурноеПодразделение");
	Магазин = ПараметрыСеанса.ТорговаяТочкаПоАйпи;
	ЗаполнитьНаСервере();
КонецПроцедуры

&НаКлиенте
Процедура НастройкаВидовВложений(Команда)
	ОткрытьФорму("Справочник.ВидыВложенийВКонверты.ФормаСписка");
КонецПроцедуры

&НаСервере
Процедура ПечатьНаСервере(ТабДок)
	
	ВнешняяКомпонента = Справочники.Номенклатура.ПодключитьВнешнююКомпонентуПечатиШтрихкода();
	
	Обр = РеквизитФормыВЗначение("Объект");
	Макет = Обр.ПолучитьМакет("Штрихкод");
	Обл = Макет.ПолучитьОбласть("Строка|Левый");
	
	
	Рисунок = Обл.Рисунки["Штрихкод"];	
	
	
	
	ПараметрыШК = Новый Структура();
	ПараметрыШК.Вставить("Ширина", Рисунок.Ширина);
	ПараметрыШК.Вставить("Высота", Рисунок.Высота);
	ПараметрыШК.Вставить("ТипКода", 4);
	ПараметрыШК.Вставить("ОтображатьТекст", Истина);
	ПараметрыШК.Вставить("РазмерШрифта", 10);
	
	й = 1;
	Для каждого Стр Из ТаблицаВложений Цикл
		
		
		Штрихкод = "19"+Формат(Магазин.НомерТочки,"ЧЦ=4; ЧВН=; ЧГ=0")+Формат(Дата,"ДФ=ddMM")+Стр.КодПФ;
		
		ПараметрыШК.Вставить("Штрихкод", Штрихкод);
		Рисунок.Картинка = ОбщегоНазначенияКлиентСервер.ПолучитьКартинкуШтрихкода(ВнешняяКомпонента, ПараметрыШК);
		Обл.Параметры.ШК = Стр.ВидВложения;
		
		
		Если й = 1 Тогда
			ТабДок.Вывести(Обл);
		Иначе
			ТабДок.Присоединить(Обл);
		КонецЕсли;	
		й = й + 1;
		Если й = 3 Тогда
			й = 1;
		КонецЕсли;	
		
	КонецЦикла; 
КонецПроцедуры

&НаКлиенте
Процедура Печать(Команда)
	ТабДок = Новый ТабличныйДокумент;
	ПечатьНаСервере(ТабДок);
	ТабДок.Показать();
КонецПроцедуры


&НаСервере
Процедура ЗаполнитьНаСервере()
	ТекстЗапроса="ВЫБРАТЬ
	|	ВидыВложенийВКонверты.Ссылка КАК ВидВложения,
	|	ИСТИНА КАК Пометка,
	|	ВидыВложенийВКонверты.Код КАК КодПФ
	|ИЗ
	|	Справочник.ВидыВложенийВКонверты КАК ВидыВложенийВКонверты
	|ГДЕ
	|	ВидыВложенийВКонверты.Актуально
	|
	|УПОРЯДОЧИТЬ ПО
	|	ВидыВложенийВКонверты.Наименование";
	Запрос = Новый Запрос(ТекстЗапроса);
	ТЗ = Запрос.Выполнить().Выгрузить();
	ЗначениеВРеквизитФормы(ТЗ,"ТаблицаВложений");
КонецПроцедуры


&НаКлиенте
Процедура Заполнить(Команда)
	ЗаполнитьНаСервере();
КонецПроцедуры

