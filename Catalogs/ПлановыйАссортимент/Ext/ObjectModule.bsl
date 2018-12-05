﻿
Процедура ПриЗаписи(Отказ)
	
	ПрофилиИспользования = Новый Массив;
	ПрофилиИспользования.Добавить(ПредопределенноеЗначение("Справочник.МП_ПрофилиИспользования.ПлановыйАссортимент"));
	ПрофилиИспользования.Добавить(ПредопределенноеЗначение("Справочник.МП_ПрофилиИспользования.НовыеТоварыТехнолог"));
	ПрофилиИспользования.Добавить(ПредопределенноеЗначение("Справочник.МП_ПрофилиИспользования.НовыеТоварПостановщикЗадач"));
	
	Запрос = Новый Запрос(
	"ВЫБРАТЬ
	|	МобильноеПриложение.Ссылка
	|ИЗ
	|	ПланОбмена.МобильноеПриложение КАК МобильноеПриложение
	|ГДЕ
	|	МобильноеПриложение.Профиль В (&ПрофилиИспользования)");
	Запрос.УстановитьПараметр("ПрофилиИспользования", ПрофилиИспользования);
	
	Выборка = Запрос.Выполнить().Выбрать();
	Пока Выборка.Следующий() Цикл
		ОбменДанными.Получатели.Добавить(Выборка.Ссылка);
	КонецЦикла;
	//+++АК BELN 2017.11.02
	Если ЭтоГруппа ИЛИ ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли; 

	
	МасВсем=Новый Массив;
	Запрос = Новый Запрос;
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	ГруппыТехнологовТехнологи.Технолог КАК РольПользователя
	|ПОМЕСТИТЬ втТехнологи
	|ИЗ
	|	Справочник.ГруппыТехнологов.Технологи КАК ГруппыТехнологовТехнологи
	|ГДЕ
	|	ГруппыТехнологовТехнологи.Технолог <> ЗНАЧЕНИЕ(Справочник.РолиПользователей.ПустаяСсылка)
	|	И ГруппыТехнологовТехнологи.Ссылка = &Ссылка
	|
	|СГРУППИРОВАТЬ ПО
	|	ГруппыТехнологовТехнологи.Технолог
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	РолиПользователей.Ссылка КАК РольПользователя
	|ПОМЕСТИТЬ втПомощники
	|ИЗ
	|	втТехнологи КАК втТехнологи
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ Справочник.РолиПользователей КАК РолиПользователей
	|		ПО втТехнологи.РольПользователя = РолиПользователей.Родитель
	|ГДЕ
	|	РолиПользователей.ПометкаУдаления = ЛОЖЬ
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	СоответствиеОбъектРольСрезПоследних.РольПользователя
	|ПОМЕСТИТЬ втПродакты
	|ИЗ
	|	втТехнологи КАК втТехнологи
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ РегистрСведений.СоответствиеОбъектРоль.СрезПоследних(&Дата, ТипРоли = &ТипРоли1) КАК СоответствиеОбъектРольСрезПоследних
	|		ПО (СоответствиеОбъектРольСрезПоследних.Объект = втТехнологи.РольПользователя)
	|ГДЕ
	|	СоответствиеОбъектРольСрезПоследних.РольПользователя.ПометкаУдаления = ЛОЖЬ
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	РолиПользователейСоставРоли.Сотрудник
	|ИЗ
	|	Справочник.РолиПользователей.СоставРоли КАК РолиПользователейСоставРоли
	|ГДЕ
	|	(РолиПользователейСоставРоли.Ссылка В
	|				(ВЫБРАТЬ
	|					втТехнологи.РольПользователя
	|				ИЗ
	|					втТехнологи)
	|			ИЛИ РолиПользователейСоставРоли.Ссылка В
	|				(ВЫБРАТЬ
	|					втПродакты.РольПользователя
	|				ИЗ
	|					втПродакты)
	|			ИЛИ РолиПользователейСоставРоли.Ссылка В
	|				(ВЫБРАТЬ
	|					втПомощники.РольПользователя
	|				ИЗ
	|					втПомощники))
	|
	|СГРУППИРОВАТЬ ПО
	|	РолиПользователейСоставРоли.Сотрудник";
	Запрос.УстановитьПараметр("Дата", ТекущаяДата());
	Запрос.УстановитьПараметр("Ссылка", ГруппаТехнологов);
	Запрос.УстановитьПараметр("ТипРоли", ПланыВидовХарактеристик.ТипыРолейПользователя.ТехнологПоКачеству);
	Запрос.УстановитьПараметр("ТипРоли1", ПланыВидовХарактеристик.ТипыРолейПользователя.БрендМенеджер);
	Запрос.УстановитьПараметр("СтатусАктивностиХарактеристики1", Перечисления.СтатусыАктивностиХарактеристик.Выведена);
	Запрос.УстановитьПараметр("СтатусАктивностиХарактеристики", Перечисления.СтатусыАктивностиХарактеристик.Неактивная);
	РезультатЗапроса = Запрос.Выполнить();
	Выб=РезультатЗапроса.Выбрать();
	Пока Выб.Следующий() Цикл
		МасВсем.Добавить(Выб.Сотрудник);
	КонецЦикла; 
	
	Если ДополнительныеСвойства.Свойство("Новый") И не ПометкаУдаления Тогда
		
		
		
		ОтправитьПисьмо("Добавлена в плановый ассортимент "+Строка(Ссылка)+", автор - "+Строка(Автор),МасВсем);	
		
	КонецЕсли; 
	Если ДополнительныеСвойства.Свойство("ИзмененоНаименование") И не ПометкаУдаления Тогда
		
		
		
		ОтправитьПисьмо("Изменено наименование "+Строка(Ссылка)+" ( было "+ДополнительныеСвойства.ИзмененоНаименование+"), автор - "+Строка(Автор),МасВсем);	
		
	КонецЕсли; 
	
	Если ДополнительныеСвойства.Свойство("Незаполнено") И не ПометкаУдаления  Тогда
		Мас=Новый Массив();
		Мас.Добавить(ПродактМенеджер);
		ОтправитьПисьмо("Не заполнены плановые показатели в позиции планового ассортимента "+Строка(Ссылка)+", автор - "+Строка(Автор),Мас);	
		
	КонецЕсли; 
	
	Если ДополнительныеСвойства.Свойство("План") И не ПометкаУдаления  Тогда
		
		ОтправитьПисьмо("Установлен статус План для позиции планового ассортимента "+Строка(Ссылка)+", автор - "+Строка(Автор),МасВсем);	
		
	КонецЕсли;
	
	Если ДополнительныеСвойства.Свойство("Закрыт") И не ПометкаУдаления  Тогда
		//Мас=Новый Массив();
		//Для каждого Стр Из Дегустация Цикл
		//	Если ЗначениеЗаполнено(Стр.ТехнологФЛ) Тогда
		//		Мас.Добавить(Стр.ТехнологФЛ);
		//	КонецЕсли; 
		//КонецЦикла; 
		
		ОтправитьПисьмо("Установлен статус Закрыт для позиции планового ассортимента "+Строка(Ссылка)+", автор - "+Строка(Автор),МасВсем);	
		
	КонецЕсли; 
	
	Если ДополнительныеСвойства.Свойство("БылоИзменениеДегустации") И не ПометкаУдаления  Тогда
		СоотУИН=ДополнительныеСвойства.БылоИзменениеДегустации;
		ТекстПисьма="Изменены дегустации в "+Строка(Ссылка)+", автор - "+Строка(Автор)+Символы.ПС;
		МасФЛ=Новый Массив;
		Для каждого Эл Из МасВсем Цикл
			МасФЛ.Добавить(Эл);
		КонецЦикла; 
		Для каждого Эл Из СоотУИН Цикл
			СтрДег=Дегустация.Найти(Эл.Ключ);
			Если СтрДег<>Неопределено Тогда
				Если Эл.Значение=Неопределено Тогда
					ТекстПисьма=ТекстПисьма+"Было: -"
				Иначе
					Струк=Эл.Значение;
					ТекстПисьма=ТекстПисьма+"Было: дата "+Строка(Формат(Струк.Дата,"ДФ=dd.MM.yyyy"))+", описание "+Струк.Описание+", ед. изм. "+Строка(Струк.ЕдиницаИзмерения)+", ед. изм. шт. "+Строка(Струк.ЕдиницаИзмеренияШтуки)
					+", вес усл. ед. "+Строка(Струк.ВесУсловнойЕдиницы)+", цена закуп. "+Строка(Струк.ЦенаЗакупочная)
					+", цена за кг "+Строка(Струк.ЦенаЗаКилограмм)+", поставщик "+Строка(Струк.Поставщик)
					+", технолог "+Строка(Струк.ТехнологФЛ)+", состав "+Строка(Струк.Состав)
					+", комментарий "+Строка(Струк.Комментарий)+", подходит "+Строка(Струк.Подходит);
					
				КонецЕсли;                                               
				ТекстПисьма=ТекстПисьма+Символы.ПС;
				ТекстПисьма=ТекстПисьма+"Стало: дата "+Строка(Формат(СтрДег.Дата,"ДФ=dd.MM.yyyy"))+", описание "+СтрДег.Описание+", ед. изм. "+Строка(СтрДег.ЕдиницаИзмерения)+", ед. изм. шт. "+Строка(СтрДег.ЕдиницаИзмеренияШтуки)
				+", вес усл. ед. "+Строка(СтрДег.ВесУсловнойЕдиницы)+", цена закуп. "+Строка(СтрДег.ЦенаЗакупочная)
				+", цена за кг "+Строка(СтрДег.ЦенаЗаКилограмм)+", поставщик "+Строка(СтрДег.Поставщик)
				+", технолог "+Строка(СтрДег.ТехнологФЛ)+", состав "+Строка(СтрДег.Состав)
				+", комментарий "+Строка(СтрДег.Комментарий)+", подходит "+Строка(СтрДег.Подходит);
				ТекстПисьма=ТекстПисьма+Символы.ПС+Символы.ПС;
				МасФЛ.Добавить(СтрДег.ТехнологФЛ);
			КонецЕсли;                                                  
		КонецЦикла; 
		
		ОтправитьПисьмо(ТекстПисьма,МасФЛ);	
		
	КонецЕсли; 
	
	Если ДополнительныеСвойства.Свойство("БылоИзменениеДегустацииПодходит") И не ПометкаУдаления  Тогда
		СоотУИН=ДополнительныеСвойства.БылоИзменениеДегустации;
		ТекстПисьма="Установлен флажок Подходит в дегустациях "+Строка(Ссылка)+", автор - "+Строка(Автор)+Символы.ПС;
		Для каждого Эл Из СоотУИН Цикл
			СтрДег=Дегустация.Найти(Эл.Ключ);
			Если СтрДег<>Неопределено Тогда
				ТекстПисьма=ТекстПисьма+"Дата "+Строка(Формат(СтрДег.Дата,"ДФ=dd.MM.yyyy"))+", описание "+СтрДег.Описание+", ед. изм. "+Строка(СтрДег.ЕдиницаИзмерения)+", ед. изм. шт. "+Строка(СтрДег.ЕдиницаИзмеренияШтуки)
				+", вес усл. ед. "+Строка(СтрДег.ВесУсловнойЕдиницы)+", цена закуп. "+Строка(СтрДег.ЦенаЗакупочная)
				+", цена за кг "+Строка(СтрДег.ЦенаЗаКилограмм)+", поставщик "+Строка(СтрДег.Поставщик)
				+", технолог "+Строка(СтрДег.ТехнологФЛ)+", состав "+Строка(СтрДег.Состав)
				+", комментарий "+Строка(СтрДег.Комментарий)+", подходит "+Строка(СтрДег.Подходит);
				ТекстПисьма=ТекстПисьма+Символы.ПС+Символы.ПС;
			КонецЕсли;                                                  
		КонецЦикла; 
		
		ОтправитьПисьмо(ТекстПисьма,ГруппаТехнологов.Технологи.ВыгрузитьКолонку("Технолог"));	
		
	КонецЕсли; 
КонецПроцедуры                                                          

Процедура ПередЗаписью(Отказ)
	Если ЭтоГруппа ИЛИ ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли; 
	Если ЭтоНовый() Тогда
		ДополнительныеСвойства.Вставить("Новый",Истина);
	КонецЕсли; 
	Если МаржаВДеньНаМагазин=0 И Статус=Перечисления.СтатусыПлановогоАссортимента.План Тогда
		ДополнительныеСвойства.Вставить("Незаполнено",Истина);
	КонецЕсли; 
	Если Статус=Перечисления.СтатусыПлановогоАссортимента.План И Ссылка.Статус<>Перечисления.СтатусыПлановогоАссортимента.План Тогда
		ДополнительныеСвойства.Вставить("План",Истина);
	КонецЕсли;
	
	Если Статус=Перечисления.СтатусыПлановогоАссортимента.Закрыт И Ссылка.Статус<>Перечисления.СтатусыПлановогоАссортимента.Закрыт Тогда
		ДополнительныеСвойства.Вставить("Закрыт",Истина);
	КонецЕсли;
	
	Если Ссылка.Наименование<>Наименование Тогда
		ДополнительныеСвойства.Вставить("ИзмененоНаименование",Ссылка.Наименование);
	КонецЕсли;
	
	Для каждого Стр Из Дегустация Цикл
		Если ПлановаяДатаЗапуска<Стр.Дата И Статус<>Перечисления.СтатусыПлановогоАссортимента.Идея И Не ОбменДанными.Загрузка Тогда
			Сообщить("Некорректная дата запуска");
			Отказ=Истина;
		КонецЕсли; 
	КонецЦикла; 
	
	Если Не Отказ И ПометкаУдаления Тогда
		ГруппаДоПометкиУдаления=Родитель;
		Родитель=Справочники.ПлановыйАссортимент.НайтиПоНаименованию("Удаленные");
	КонецЕсли; 
	Если Не Отказ И Не ПометкаУдаления И Ссылка.ПометкаУдаления Тогда
		Родитель=ГруппаДоПометкиУдаления;
	КонецЕсли; 
КонецПроцедуры
//АК БЕЛН 13.06.2017+
Процедура ОтправитьПисьмо(Текст,МасФЛ)
	
	СтруктураНовогоПисьма 	= Новый Структура;
	СтруктураНовогоПисьма.Вставить("ВидТекста", Перечисления.ВидыТекстовЭлектронныхПисем.Текст);
	
	СписокФайловВложений 	= Новый СписокЗначений;
	//
	СтруктураНовогоПисьма.Вставить("Тема", Текст);
	СтруктураНовогоПисьма.Вставить("Тело", Текст);
	
	
	
	СтруктураНовогоПисьма.Вставить("СписокФайловВложений", СписокФайловВложений);
	
	Кому 			= Новый СписокЗначений;
	
	//
	
	
	
	//
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("Объект", МасФЛ);
	Запрос.Текст =                                                                                   
	"ВЫБРАТЬ
	|	КонтактнаяИнформация.Представление
	|ИЗ
	|	РегистрСведений.КонтактнаяИнформация КАК КонтактнаяИнформация
	|ГДЕ
	|	КонтактнаяИнформация.Объект В(&Объект)
	|	И КонтактнаяИнформация.Тип = ЗНАЧЕНИЕ(Перечисление.ТипыКонтактнойИнформации.АдресЭлектроннойПочты)";
	Выборка = Запрос.Выполнить().Выбрать();
	
	Если Выборка.Количество()>0 Тогда
		Пока Выборка.Следующий() Цикл
			Если Кому.НайтиПоЗначению(Выборка.Представление) = Неопределено Тогда
				Кому.Добавить(Выборка.Представление);
			КонецЕсли; 
		КонецЦикла;
	Иначе
		Возврат;
	КонецЕсли;
	
	СтруктураНовогоПисьма.Вставить("Кому", Кому);
	
	
	СтрКому = "";
	Для каждого Эл Из Кому Цикл
		СтрКому = СтрКому + Эл.Значение + "; ";
	КонецЦикла; 
	Попытка
		ОбщегоНазначенияКлиентСервер.ОтправитьПисьмоПоПочте(СтруктураНовогоПисьма);
		Сообщить("Отправлено письмо с информацией о позиции на " + СтрКому);
	Исключение
		Сообщить(ОписаниеОшибки());
	КонецПопытки; 
	
	
КонецПроцедуры
//АК БЕЛН 13.06.2017-

