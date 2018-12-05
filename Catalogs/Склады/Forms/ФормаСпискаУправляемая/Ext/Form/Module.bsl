﻿

&НаКлиенте
Процедура СтруктурнаяЕдиницаПриИзменении(Элемент)
	
	УстановитьОтборВСписке(СтруктурнаяЕдиница);
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	УстановитьОтборВСписке(ПолучитьСтруктурнуюЕдиницуПоУмолчанию());
	
КонецПроцедуры

&НаСервере
Функция ПолучитьСтруктурнуюЕдиницуПоУмолчанию()
	
	Возврат УправлениеПользователями.ПолучитьЗначениеПоУмолчанию(ПараметрыСеанса.ТекущийПользователь, "ОсновноеСтруктурноеПодразделение");
	
КонецФункции

&НаСервере
Процедура УстановитьОтборВСписке(пСтруктурнаяЕдиница)
	
	Список.Отбор.Элементы.Очистить();
	
	Отбор = Список.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных")); 
	Отбор.ЛевоеЗначение 	= Новый ПолеКомпоновкиДанных("Владелец"); 
	Отбор.ВидСравнения 		= ВидСравненияКомпоновкиДанных.Равно;
	Отбор.Использование 	= Истина; 
	Отбор.ПравоеЗначение 	= СтруктурнаяЕдиница;	
	
КонецПроцедуры

&НаКлиенте
Процедура СписокПриАктивизацииСтроки(Элемент)

	ТекущиеДанные = Элементы.Список.ТекущиеДанные;
	
	Если ТекущиеДанные=Неопределено Тогда
		Склад = ПредопределенноеЗначение("Справочник.Склады.ПустаяСсылка");
	Иначе
		Склад = ТекущиеДанные.Ссылка;
	КонецЕсли;
	
	СформироватьДеревоНоменклатуры(СтруктурнаяЕдиница, Склад);

	//Для красоты развернем дерево до 2-го уровня 
	Коллекция = НоменклатураСклада.ПолучитьЭлементы();
	Для Каждого СтрокаДерева Из Коллекция Цикл    
		ИдСтроки = СтрокаДерева.ПолучитьИдентификатор();
		Элементы.Номенклатура.Развернуть(ИдСтроки);
	КонецЦикла;

КонецПроцедуры

&НаСервере
Процедура СформироватьДеревоНоменклатуры(СтруктурнаяЕдиница, Склад)
	
	
	//Состав номенклатуры на данном складе
	Массив = ДатьМассивНоменклатурыСклада(Неопределено, СтруктурнаяЕдиница, Склад);
	
	//Выборка номенклатуры из справочника
	Запрос = Новый Запрос;
	Запрос.Параметры.Вставить("Список", Массив);
	Запрос.Текст =
	"ВЫБРАТЬ РАЗРЕШЕННЫЕ
	|	Номенклатура.Ссылка КАК Ссылка
	|ИЗ
	|	Справочник.Номенклатура КАК Номенклатура
	|ГДЕ
	|	Номенклатура.Ссылка В(&Список)
	|	И Номенклатура.ЭтоГруппа
	|
	|УПОРЯДОЧИТЬ ПО
	|	Номенклатура.Наименование
	|ИТОГИ ПО
	|	Ссылка ИЕРАРХИЯ";
	
	Дерево = Запрос.Выполнить().Выгрузить(ОбходРезультатаЗапроса.ПоГруппировкамСИерархией);
	
	//Убрать "паразитные" ветви
	УдалитьДублиВПоддереве(Дерево);
	
	//Обновляем на форме
	ЗначениеВРеквизитФормы(Дерево, "НоменклатураСклада");
	
КонецПроцедуры

&НаСервереБезКонтекста
Процедура УдалитьДублиВПоддереве(СтрокаДерева)
	
	Для Каждого Подстрока Из СтрокаДерева.Строки Цикл
		
		//поиск и удаление дубля на уровне +1
		СтрокаДубля = Подстрока.Строки.Найти(Подстрока.Ссылка);
		Если СтрокаДубля<>Неопределено Тогда
			Подстрока.Строки.Удалить(СтрокаДубля);
		КонецЕсли;
		
		//рекурсия
		УдалитьДублиВПоддереве(Подстрока);
		
	КонецЦикла;
	
КонецПроцедуры

&НаСервере
Функция ДатьМассивНоменклатурыСклада(НоменклатураРодитель, СтруктурнаяЕдиница, Склад)
	
	Запрос = Новый Запрос;
	Запрос.Параметры.Вставить("СтруктурнаяЕдиница",	СтруктурнаяЕдиница);
	Запрос.Текст =
	"ВЫБРАТЬ РАЗРЕШЕННЫЕ
	|	ДоступностьТоваровНаСкладах.Номенклатура КАК Номенклатура
	|ИЗ
	|	РегистрСведений.ДоступностьТоваровНаСкладах КАК ДоступностьТоваровНаСкладах
	|ГДЕ
	|	ДоступностьТоваровНаСкладах.СтруктурнаяЕдиница = &СтруктурнаяЕдиница
	|	И 1 = 1
	|	И 2 = 2";
	
	//Склад определен - для показа дерева номенклатуры
	//Не определен - для отвязки отовсюду перед привязкой
	Если ЗначениеЗаполнено(Склад) Тогда
		Запрос.Параметры.Вставить("Склад", Склад);
		Запрос.Текст = СтрЗаменить(Запрос.Текст, "1 = 1", "ДоступностьТоваровНаСкладах.Склад = &Склад");
	КонецЕсли;
	
	Если ЗначениеЗаполнено(НоменклатураРодитель) Тогда
		Запрос.Параметры.Вставить("Родитель", НоменклатураРодитель);
		Запрос.Текст = СтрЗаменить(Запрос.Текст, "2 = 2", "ДоступностьТоваровНаСкладах.Номенклатура В ИЕРАРХИИ (&Родитель)");
	КонецЕсли;
	
	Возврат Запрос.Выполнить().Выгрузить().ВыгрузитьКолонку("Номенклатура");
	
КонецФункции

&НаКлиенте
Процедура СписокПроверкаПеретаскивания(Элемент, ПараметрыПеретаскивания, СтандартнаяОбработка, Строка, Поле)

	СтандартнаяОбработка			 	= Ложь;
	
	НовыйСклад							= Строка;
	ТекущийСклад						= Элементы.Список.ТекущиеДанные.Ссылка;
	ПараметрыПеретаскивания.Действие	= ?(ЗначениеЗаполнено(НовыйСклад) И НовыйСклад<>ТекущийСклад,
											ДействиеПеретаскивания.Перемещение,
											ДействиеПеретаскивания.Отмена);
КонецПроцедуры

&НаКлиенте
Процедура СписокПеретаскивание(Элемент, ПараметрыПеретаскивания, СтандартнаяОбработка, Строка, Поле)

	Перем Номенклатура;
	
	СтандартнаяОбработка = Ложь;
	
	//Отсеиваем ситуации, когда перетащили на пустое поле, перетащили что-то из другой программы и т.п.
	Если Строка=Неопределено Или ТипЗнч(ПараметрыПеретаскивания.Значение)<>Тип("Массив") Тогда
		Возврат;
	КонецЕсли;
	
	//Другие непредвиденные ситуации
	Попытка
		НовыйСклад		= Строка;
		Номенклатура	= ПараметрыПеретаскивания.Значение[0].Ссылка;
	Исключение
	КонецПопытки;
	Если ТипЗнч(Номенклатура)<>Тип("СправочникСсылка.Номенклатура") Тогда
		Возврат;
	КонецЕсли;
	
	//Спросить пользователя
	Если Вопрос("Переместить """ + Строка(Номенклатура) + """ на склад """ + Строка(НовыйСклад) + """?", РежимДиалогаВопрос.ДаНет)<>КодВозвратаДиалога.Да Тогда
		Возврат;
	КонецЕсли;
	
	//Работаем
	ТекущийСклад = Элементы.Список.ТекущиеДанные.Ссылка;
	ВыполнитьПривязкуСервер(Номенклатура, СтруктурнаяЕдиница, НовыйСклад);
	СписокПриАктивизацииСтроки(Неопределено);
		
КонецПроцедуры

&НаСервере
Функция ПолучитьУровеньНоменклатурыСервер(Группа)
	
   мРодитель = Группа.Родитель;
   Возврат ?(Не ЗначениеЗаполнено(мРодитель), 1, 1 + ПолучитьУровеньНоменклатурыСервер(мРодитель));
   
КонецФункции

&НаСервере
Функция ВыполнитьПривязкуСервер(Номенклатура, СтруктурнаяЕдиница, НовыйСклад)
	
	Набор = РегистрыСведений.ДоступностьТоваровНаСкладах.СоздатьНаборЗаписей();
	
	//Отвязываем отовсюду
	Массив = ДатьМассивНоменклатурыСклада(Номенклатура, СтруктурнаяЕдиница, Неопределено);
	Для Каждого Элемент Из Массив Цикл
		Набор.Отбор.Номенклатура	.Установить(Элемент, Истина);
		Набор.Отбор.СтруктурнаяЕдиница	.Установить(СтруктурнаяЕдиница, Истина);
		Набор.Прочитать();
		Набор.Очистить();
		Набор.Записать(Истина);
	КонецЦикла;
	
	//В случае добавления номенклатуры сюда передана группа 2-го уровня
	//Если пертаскивание группы 1-го уровня, то нужно по факту переместить подчиненные ей группы
	Если ПолучитьУровеньНоменклатурыСервер(Номенклатура)=1 Тогда
		//массив уже есть
	Иначе
		Массив = Новый Массив;
		Массив.Добавить(Номенклатура);
	КонецЕсли;
	
	//Привязываем
	Набор.Отбор.Сбросить();
	Для Каждого Элемент Из Массив Цикл
		СтрокаРегистра						= Набор.Добавить();
		СтрокаРегистра.Номенклатура	= Элемент;
		СтрокаРегистра.СтруктурнаяЕдиница	= СтруктурнаяЕдиница;
		СтрокаРегистра.Склад				= НовыйСклад;
	КонецЦикла;
	Набор.Записать(Ложь);
	
КонецФункции

&НаСервере
Функция ДатьСкладНоменклатурыСервер(Номенклатура, СтруктурнаяЕдиница)
	
	Запрос = Новый Запрос;
	Запрос.Параметры.Вставить("Номенклатура"		, Номенклатура);
	Запрос.Параметры.Вставить("СтруктурнаяЕдиница"	, СтруктурнаяЕдиница);
	Запрос.Текст =
	"ВЫБРАТЬ РАЗРЕШЕННЫЕ
	|	ДоступностьТоваровНаСкладах.Склад
	|ИЗ
	|	РегистрСведений.ДоступностьТоваровНаСкладах КАК ДоступностьТоваровНаСкладах
	|ГДЕ
	|	ДоступностьТоваровНаСкладах.Номенклатура = &Номенклатура
	|	И ДоступностьТоваровНаСкладах.СтруктурнаяЕдиница = &СтруктурнаяЕдиница";
							
	Выборка = Запрос.Выполнить().Выбрать();
	
	Возврат ?(Выборка.Следующий(), Выборка.Склад, Неопределено);
	
КонецФункции

&НаКлиенте
Процедура ДобавитьНоменклатуруСклада(Команда)
	
	//Справочник складов не выведен - отсекаем
	Если Элементы.Список.ТекущиеДанные = Неопределено Тогда
		Предупреждение("Не выбран склад!");
		Возврат;
	КонецЕсли;
	
	//При записи в регистр структурная единица нужна будет обязательно
	Если НЕ ЗначениеЗаполнено(СтруктурнаяЕдиница) Тогда
		Предупреждение("Не указана структурная единица!");
		Возврат;
	КонецЕсли;
	
	//Выбор группы номенклатуры
	Форма		= ПолучитьФорму("Справочник.Номенклатура.ФормаВыбораГруппы");
	Результат	= Форма.ОткрытьМодально();
	
	//Действуем, если пользователь выбрал
	Если ЗначениеЗаполнено(Результат) Тогда
		
		Если ПолучитьУровеньНоменклатурыСервер(Результат) <> 2 Тогда
			Предупреждение("Можно добавлять группы только 2-го уровня!");
			Возврат;
		КонецЕсли;
		
		НовыйСклад		= Элементы.Список.ТекущиеДанные.Ссылка;
		ТекущийСклад	= ДатьСкладНоменклатурыСервер(Результат, СтруктурнаяЕдиница);
		
		//Проверка того, что номенклатура уже привязана
		Если ЗначениеЗаполнено(ТекущийСклад) Тогда
			Если НовыйСклад = ТекущийСклад Тогда
				Предупреждение("Группа """ + Строка(Результат) + """ уже привязана к данному складу. Операция отменена");
				Возврат;
			Иначе
				Если Вопрос("Группа """ + Строка(Результат) + """ сейчас привязана к """ + Строка(ТекущийСклад) + """. Будет перемещена на """ + Строка(НовыйСклад) + """. Продолжить?", РежимДиалогаВопрос.ДаНет) <> КодВозвратаДиалога.Да Тогда
					Возврат;
				КонецЕсли;
			КонецЕсли;
		КонецЕсли;
		
		ВыполнитьПривязкуСервер(Результат, СтруктурнаяЕдиница, НовыйСклад);
		СписокПриАктивизацииСтроки(Неопределено);
	КонецЕсли;
	
КонецПроцедуры
