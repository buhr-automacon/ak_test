﻿
&НаКлиенте
Процедура ИмяФайлаНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	ДиалогФайла = Новый ДиалогВыбораФайла(РежимДиалогаВыбораФайла.Открытие);
	ДиалогФайла.МножественныйВыбор = Истина;
	//ДиалогФайла.Фильтр = "(*.jpg;*.jpeg;*.gif;*.tif;*.png)|*.jpg;*.jpeg;*.gif;*.tif;*.png";
	ДиалогФайла.ПроверятьСуществованиеФайла = Истина;
	//АК БЕЛН 25.03.2016++
	Контрагент=ЗагрузитьКонтрагента();
	ДиалогФайла.Каталог=РаботаСДиалогамиКлиент.ПолучитьПапкуКонтрагента(Контрагент.Наименование);	
	//АК БЕЛН 25.03.2016--
	Если ДиалогФайла.Выбрать() Тогда
		//ХранилищеКартинки = Новый ХранилищеЗначения(ДиалогФайла.ПолноеИмяФайла);
		БылВыборФайла = Истина;
		ИмяФайла = ДиалогФайла.ПолноеИмяФайла;
	КонецЕсли;
	//ДиалогФайла.МножественныйВыбор = Ложь;
	////ДиалогФайла.Фильтр = "(*.jpg;*.jpeg;*.gif;*.tif;*.png)|*.jpg;*.jpeg;*.gif;*.tif;*.png";
	//ДиалогФайла.ПроверятьСуществованиеФайла = Истина;
	//Если ДиалогФайла.Выбрать() Тогда
	//	//ХранилищеКартинки = Новый ХранилищеЗначения(ДиалогФайла.ПолноеИмяФайла);
	//	БылВыборФайла = Истина;
	//	ИмяФайла = ДиалогФайла.ПолноеИмяФайла;
	//КонецЕсли;
	
КонецПроцедуры

&НаСервереБезКонтекста
Функция ЗагрузитьКонтрагента()
	Контрагент=ХранилищеОбщихНастроек.Загрузить("АК_Изб_Контрагент");
    Возврат Контрагент;
КонецФункции // ()
 

&НаКлиенте
Процедура Принять(Команда)
	
	//Закрыть(Новый Структура("ИмяФайла, БылВыборФайла", ИмяФайла, БылВыборФайла));
	Закрыть(Новый Структура("СписокФайлов, БылВыборФайла", ЭтаФорма.СписокФайлов, БылВыборФайла));
	
КонецПроцедуры

&НаКлиенте
Процедура ДобавитьФайлы(Команда)
	
	ДиалогФайла = Новый ДиалогВыбораФайла(РежимДиалогаВыбораФайла.Открытие);
	ДиалогФайла.МножественныйВыбор 			= Истина;
	ДиалогФайла.ПроверятьСуществованиеФайла = Истина;
	//АК БЕЛН 25.03.2016++
	Контрагент=ЗагрузитьКонтрагента();
	ДиалогФайла.Каталог=РаботаСДиалогамиКлиент.ПолучитьПапкуКонтрагента(Контрагент.Наименование);	
	//АК БЕЛН 25.03.2016--
	Если ДиалогФайла.Выбрать() Тогда
		БылВыборФайла = Истина;
		Для Каждого ВыбранныйФайл Из ДиалогФайла.ВыбранныеФайлы Цикл
			Если ЭтаФорма.СписокФайлов.НайтиПоЗначению(ВыбранныйФайл) = Неопределено Тогда
				ЭтаФорма.СписокФайлов.Добавить(ВыбранныйФайл);
			КонецЕсли;
		КонецЦикла;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура УдалитьФайл(Команда)
	
	ТекДанные = Элементы.СписокФайлов.ТекущиеДанные;
	Если ТекДанные = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	НайденныйЭлемент = ЭтаФорма.СписокФайлов.НайтиПоЗначению(ТекДанные.Значение);
	ЭтаФорма.СписокФайлов.Удалить(НайденныйЭлемент);
	
КонецПроцедуры
