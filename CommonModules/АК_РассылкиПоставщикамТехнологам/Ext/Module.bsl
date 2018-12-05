﻿
&НаСервере
Функция ПолучитьСтруктуруПараметровНастройкиРассылокПоставщикамТехнологам()
	ТП=Новый Структура;
	ТП.Вставить("ИнтервалНеделя1",Ложь);
	ТП.Вставить("ИнтервалНеделя2",Ложь);
	ТП.Вставить("ИнтервалМесяц",Ложь);
	ТП.Вставить("ИнтервалПроизвольный",Ложь);
	ТП.Вставить("ИспользоватьТестовыйАдрес",Ложь);
	ТП.Вставить("ИнтервалДни",0);
	ТП.Вставить("ТестовыйАдрес","");
	ТП.Вставить("АдресПоУмолчанию","");
	ТП.Вставить("о1","");
	ТП.Вставить("о2","");
	ВК1=Новый ТаблицаЗначений;
	ВК1.Колонки.Добавить("ВидКонтактнойИнформации",Новый ОписаниеТипов("СправочникСсылка.ВидыКонтактнойИнформации"));
	ТП.Вставить("ВидыКонтактнойИнформацииПроизводитель",ВК1);
	ВК2=Новый ТаблицаЗначений;
	ВК2.Колонки.Добавить("ВидКонтактнойИнформации",Новый ОписаниеТипов("СправочникСсылка.ВидыКонтактнойИнформации"));
	ТП.Вставить("ВидыКонтактнойИнформацииТехнолог",ВК2);
	Возврат ТП;
КонецФункции

&НаСервере
Функция ПолучитьПараметрыНастройкиРассылокПоставщикамТехнологам(Результат,ТекстОписаниеОшибки) экспорт
	Результат=ПолучитьСтруктуруПараметровНастройкиРассылокПоставщикамТехнологам();
	ТекстОписаниеОшибки="";
	ЗначениеКонстанты=Константы.АК_НастройкиРассылокПоставщикамТехнологам.Получить();
	Если НЕ ПустаяСтрока(ЗначениеКонстанты) тогда
		Попытка
			Данные=ЗначениеИзСтрокиВнутр(ЗначениеКонстанты);
		Исключение
			ТекстОписаниеОшибки="ошибка при получении константы, "+ОписаниеОшибки();
			возврат Ложь;
		КонецПопытки;
		Если ТипЗнч(Данные)=Тип("Структура") тогда
			Для Каждого Элемент из Данные цикл
				попытка
					Если Элемент.Ключ="ВидыКонтактнойИнформацииПроизводитель" тогда
						Результат.ВидыКонтактнойИнформацииПроизводитель=Элемент.Значение;
					ИначеЕсли Элемент.Ключ="ВидыКонтактнойИнформацииТехнолог" тогда
						Результат.ВидыКонтактнойИнформацииТехнолог=Элемент.Значение;
					ИначеЕсли 
						(Элемент.Ключ="ИнтервалНеделя1"	ИЛИ	Элемент.Ключ="ИнтервалНеделя2" ИЛИ Элемент.Ключ="ИнтервалМесяц" ИЛИ	Элемент.Ключ="ИнтервалПроизвольный")
						И Элемент.Значение 
					тогда
						Результат[Элемент.Ключ]=Истина;
					ИначеЕсли Элемент.Ключ="ИнтервалДни" тогда
						Результат.ИнтервалДни=Элемент.Значение;
					ИначеЕсли Элемент.Ключ="ТестовыйАдрес" тогда
						Результат.ТестовыйАдрес=Элемент.Значение;
					ИначеЕсли Элемент.Ключ="АдресПоУмолчанию" тогда
						Результат.АдресПоУмолчанию=Элемент.Значение;
					ИначеЕсли Элемент.Ключ="ИспользоватьТестовыйАдрес" тогда
						Результат.ИспользоватьТестовыйАдрес=Элемент.Значение;
					ИначеЕсли Элемент.Ключ="о1" тогда
						Результат.о1=Элемент.Значение;
					ИначеЕсли Элемент.Ключ="о2" тогда
						Результат.о2=Элемент.Значение;
					КонецЕсли;
				Исключение
					ТекстОписаниеОшибки="Ошибка получения данных константы """+Элемент.Ключ+""": "+ОписаниеОшибки();
					возврат Ложь;
				КонецПопытки;
			КонецЦикла;
		Иначе 
			ТекстОписаниеОшибки="Данные константы повреждены либо не заполнены";
			Возврат Ложь;
		КонецЕсли;
	КонецЕсли;	
	возврат Истина;
	
КонецФункции

&НаСервере
Процедура ВыполнитьРассылку() экспорт
	перем Результат,ТекстОписаниеОшибки;
	если ПолучитьПараметрыНастройкиРассылокПоставщикамТехнологам(Результат,ТекстОписаниеОшибки) тогда
	КонецЕсли;
КонецПроцедуры

Процедура АК_РассылкаПоставщикамТехнологамПриЗаписи(Источник, Отказ, Замещение) Экспорт
КонецПроцедуры

&НаСервере
Процедура АК_РассылкаПлановогоАссортиментаРегламент() Экспорт
	
	Обр = Обработки.АК_РассылкаПлановогоАссортимента.Создать();
	обр.ВыполнитьПолнуюРассылку();
	
КонецПроцедуры	

// +++ АК mirv 29.08.2017 [ИП-00015993]
// Регламентное задание
Процедура АК_ОтправитьНаДегустацию() Экспорт
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ
		|	АК_НастройкиОтправкаНаДегустацию.КоличествоОбращений,
		|	АК_НастройкиОтправкаНаДегустацию.ПериодДляАнализа
		|ИЗ
		|	РегистрСведений.АК_НастройкиОтправкаНаДегустацию КАК АК_НастройкиОтправкаНаДегустацию";
	
	РезультатЗапроса = Запрос.Выполнить();
	
	ВыборкаДетальныеЗаписи = РезультатЗапроса.Выбрать();
	
	Если ВыборкаДетальныеЗаписи.Следующий() Тогда
		ДатаПервогоОбращения = НачалоДня(ТекущаяДата()) - ВыборкаДетальныеЗаписи.ПериодДляАнализа * 24*60*60;
		Количество = ВыборкаДетальныеЗаписи.КоличествоОбращений;
	Иначе
		Возврат;
	КонецЕсли;
	
	СписокНаДегустацию = Новый Массив;
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ
		|	АК_ЗаданияНаДегустациюНочные.Номенклатура,
		|	ИСТИНА КАК НадоДегустировать
		|ПОМЕСТИТЬ ВТ_НочнаяДегустация
		|ИЗ
		|	РегистрСведений.АК_ЗаданияНаДегустациюНочные КАК АК_ЗаданияНаДегустациюНочные
		|ГДЕ
		|	АК_ЗаданияНаДегустациюНочные.ДатаДегустации = ДАТАВРЕМЯ(1, 1, 1, 0, 0, 0)";
	
	СписокНаДегустацию = Запрос.Выполнить().Выгрузить().ВыгрузитьКолонку("Номенклатура");
	

	
	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ
		|	ОбращенияПокупателей.Номенклатура,
		|	КОЛИЧЕСТВО(ОбращенияПокупателей.id_OK) КАК Количество
		|ПОМЕСТИТЬ ВсеОбращения
		|ИЗ
		|	РегистрСведений.ОбращенияПокупателей КАК ОбращенияПокупателей
		|ГДЕ
		|	ОбращенияПокупателей.ДатаДок >= &ДатаПервогоОбращения
		|	И НЕ ОбращенияПокупателей.Номенклатура В (&Номенклатура)
		|
		|СГРУППИРОВАТЬ ПО
		|	ОбращенияПокупателей.Номенклатура
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	ВсеОбращения.Номенклатура
		|ИЗ
		|	ВсеОбращения КАК ВсеОбращения
		|		ЛЕВОЕ СОЕДИНЕНИЕ ВТ_НочнаяДегустация КАК ВТ_НочнаяДегустация
		|		ПО ВсеОбращения.Номенклатура = ВТ_НочнаяДегустация.Номенклатура
		|ГДЕ
		|	ВсеОбращения.Количество >= &Количество";
	
	Запрос.УстановитьПараметр("ДатаПервогоОбращения", ДатаПервогоОбращения);
	Запрос.УстановитьПараметр("Количество", Количество);
	
	РезультатЗапроса = Запрос.Выполнить();
	
	ВыборкаДетальныеЗаписи = РезультатЗапроса.Выбрать();
	
	Пока ВыборкаДетальныеЗаписи.Следующий() Цикл
		Если ЗначениеЗаполнено(ВыборкаДетальныеЗаписи.Номенклатура) Тогда
			НоваяЗапись = РегистрыСведений.АК_ЗаданияНаДегустациюНочные.СоздатьМенеджерЗаписи();
			НоваяЗапись.Номенклатура = ВыборкаДетальныеЗаписи.Номенклатура;
			НоваяЗапись.ДатаРегистрации = ТекущаяДата();
			НоваяЗапись.Записать(Истина);
		КонецЕсли; 
	КонецЦикла;
	
КонецПроцедуры
// --- АК mirv  
