﻿
&НаСервере
Функция ПолучитьАдресДанныхКартинки()
	
	Картинка = Новый Картинка(Справочники.Файлы.ПолучитьИмяФайлаДляОбъекта(Объект.Ссылка));
	Возврат ПоместитьВоВременноеХранилище(Картинка);
	
КонецФункции

&НаКлиенте
Процедура Просмотреть(Команда)
	//+++АК SUVV 2018.03.05 ИП-00017818
	//ИмяФайла = ПолучитьИмяВременногоФайла(Объект.Расширение);
	Файл = ПолучитьИмяФайлаДляОткрытия();
	//---АК SUVV
	Если ПолучитьФайл(ПолучитьАдресДанныхКартинки(), Файл, Ложь) = Истина Тогда
		ЗапуститьПриложение(Файл);
	КонецЕсли;	
	
КонецПроцедуры

&НаКлиенте
Процедура СохранитьКак(Команда)
	
	//+++АК SUVV 2018.03.05 ИП-00017818
	//ИмяФайла = ПолучитьИмяВременногоФайла(Объект.Расширение);
	Файл = ПолучитьИмяФайлаДляОткрытия();
	//+++АК SUVV
	ПолучитьФайл(ПолучитьАдресДанныхКартинки(), Файл, Истина);
	
КонецПроцедуры

&НаКлиенте
Процедура ВидимостьСвойств(Команда)
	Элементы.ЗначенияСвойств.Видимость = Не Элементы.ЗначенияСвойств.Видимость;
КонецПроцедуры


&НаСервере
Процедура ЗаполнитьТаблицуСвойств(Заявка)
	//++ АК LUZA 20170731 ИП-00016332	
	СоответствиеРеквизитов = Новый Соответствие;
	СоответствиеРеквизитов.Вставить(ПланыВидовХарактеристик.СвойстваОбъектов.Файлы_НазваниеКонтрагента, "Контрагент");
	СоответствиеРеквизитов.Вставить(ПланыВидовХарактеристик.СвойстваОбъектов.Файлы_ИНН, "ИНН");
	СоответствиеРеквизитов.Вставить(ПланыВидовХарактеристик.СвойстваОбъектов.Файлы_СуммаСчета, "СуммаДокумента");
	СоответствиеРеквизитов.Вставить(ПланыВидовХарактеристик.СвойстваОбъектов.Файлы_НомерСчета, "НомерСчета");
	СоответствиеРеквизитов.Вставить(ПланыВидовХарактеристик.СвойстваОбъектов.Файлы_ДатаСчета, "ДатаСчета");
	СоответствиеРеквизитов.Вставить(ПланыВидовХарактеристик.СвойстваОбъектов.Файлы_БИК, "БИК");
	СоответствиеРеквизитов.Вставить(ПланыВидовХарактеристик.СвойстваОбъектов.Файлы_РассчетныйСчет, "РасчСчет");
	
	ПредставлениеРеквизитов = Новый Соответствие;
	ПредставлениеРеквизитов.Вставить("Контрагент", "Наименование контрагента");
	ПредставлениеРеквизитов.Вставить("ИНН", "ИНН контрагента");
	ПредставлениеРеквизитов.Вставить("СуммаДокумента", "Сумма счета");
	ПредставлениеРеквизитов.Вставить("НомерСчета", "Номер счета");
	ПредставлениеРеквизитов.Вставить("ДатаСчета", "Дата счета");
	ПредставлениеРеквизитов.Вставить("БИК", "БИК");
	ПредставлениеРеквизитов.Вставить("РасчСчет", "Рассчетный счет");
	
	Запрос = Новый Запрос;
	Запрос.Текст = "ВЫБРАТЬ
	|	ЗаявкаНаУслугиМатериалы.Ссылка,
	|	ЗаявкаНаУслугиМатериалы.Контрагент.Наименование КАК Контрагент,
	|	ЗаявкаНаУслугиМатериалы.Контрагент.ИНН КАК ИНН,
	|	ЗаявкаНаУслугиМатериалы.СуммаДокумента,
	|	ЗаявкаНаУслугиМатериалы.НомерСчета,
	|	ЗаявкаНаУслугиМатериалы.ДатаСчета,
	|	ЗаявкаНаУслугиМатериалы.СчетКонтрагента.Банк.Код КАК БИК,
	|	ЗаявкаНаУслугиМатериалы.СчетКонтрагента.НомерСчета КАК РасчСчет
	|ИЗ
	|	Документ.ЗаявкаНаУслугиМатериалы КАК ЗаявкаНаУслугиМатериалы	
	|ГДЕ
	|	ЗаявкаНаУслугиМатериалы.Ссылка = &Заявка
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ	
	|	ЗначенияСвойствОбъектов.Свойство КАК Свойство,
	|	ЗначенияСвойствОбъектов.Значение КАК ДанныеВСчете
	|ИЗ
	|	РегистрСведений.ЗначенияСвойствОбъектов КАК ЗначенияСвойствОбъектов
	|ГДЕ
	|	ЗначенияСвойствОбъектов.Объект = &СчетНаОплату";
	
	Запрос.УстановитьПараметр("Заявка", Заявка);
	Запрос.УстановитьПараметр("СчетНаОплату", Объект.Ссылка);
	
	МассивРезультат = Запрос.ВыполнитьПакет();
	
	ТЗ_ДанныеЗаявки = МассивРезультат[0].Выгрузить();		
	ТЗ_Данныефайла = МассивРезультат[1].Выгрузить();
		
	Для каждого СтрЗаявка Из ТЗ_Данныефайла Цикл
		НСтр = ЗначенияСвойств.Добавить();
		ЗаполнитьЗначенияСвойств(НСтр, СтрЗаявка);		
		
		Если ТЗ_ДанныеЗаявки.Количество() > 0 Тогда 
			НСтр.ДанныеВЗаявке = ТЗ_ДанныеЗаявки[0][СоответствиеРеквизитов[СтрЗаявка.Свойство]];
		КонецЕсли;	
	КонецЦикла;	
	
	Если ЗначениеЗаполнено(Заявка) = Ложь Тогда
		Элементы.ЗначенияСвойствДанныеВЗаявке.Видимость = Ложь;
	КонецЕсли;		
	//-- АК LUZA 20170731 ИП-00016332
КонецПроцедуры


&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)	
	
	//++ АК LUZA 20170731 ИП-00016332	
	Если Параметры.Свойство("Заявка") = Истина Тогда
		ЗаполнитьТаблицуСвойств(Параметры.Заявка);	
	Иначе	
		ЗаполнитьТаблицуСвойств(Документы.ЗаявкаНаУслугиМатериалы.ПустаяСсылка());
	КонецЕсли;		
	//-- АК LUZA 20170731 ИП-00016332

КонецПроцедуры	


&НаСервере
Процедура ПриЗаписиНаСервере(Отказ, ТекущийОбъект, ПараметрыЗаписи)
	//++ АК LUZA 20170731 ИП-00016332
	Для каждого Стр Из ЗначенияСвойств Цикл
		Запись = РегистрыСведений.ЗначенияСвойствОбъектов.СоздатьМенеджерЗаписи();
		Запись.Объект = Объект.Ссылка;
		Запись.Свойство = Стр.Свойство;
		Запись.Значение = Стр.ДанныеВСчете;
		Запись.Записать();
	КонецЦикла;	
	
	//Сбрасываем параметры обработки в очереди при перезаписи, для направления на повторный анализ
	Запись = РегистрыСведений.АК_ОчередьРаспознаванияФайлов.СоздатьМенеджерЗаписи();
	Запись.Файл = Объект.Ссылка;
	Запись.Прочитать();
	Если ЗначениеЗаполнено(Запись.Файл) Тогда
		Запись.Обработан = Ложь;
		Запись.Записать();	
	КонецЕсли;	
	//-- АК LUZA 20170731 ИП-00016332
КонецПроцедуры

//+++АК SUVV 2018.03.05 ИП-00017818 //&НаСервере
//+++АК sole 2018.06.06 ИП-00018850 (Заменил "&НаСервере" на "&НаКлиенте", для исправления ошибки)
&НаКлиенте  
Функция ПолучитьИмяФайлаДляОткрытия()
	Возврат ПолучитьИмяВременногоФайла(Объект.Расширение);
КонецФункции //---АК SUVV

