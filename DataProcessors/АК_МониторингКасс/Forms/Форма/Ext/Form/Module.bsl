﻿&НаСервере
Процедура ПрочитатьНаСервере()
   ADOСоединение = ВнешниеДанные.ПолучитьADOСоединение();
   ТекстЗапроса =
	"SELECT &TOP f.ACTION , f.CashID , f.DATETIME , f.ПредыдущОпер, f.id , f.Acquiring , f.FR , f.Monobloc , f.script , f.script , f.vesi
	|FROM [frontol].[dbo].[List_errors] f (nolock)
	|&WHERE 
	|order by f.DATETIME desc";
	
	УсловиеОтбора = "";
	Для Каждого СтрокаОтбор из ТаблицаНастроекОтбора Цикл
		Если СтрокаОтбор.Использовать Тогда
			ЗначениеСтрокой = "";
			Если ТипЗнч(СтрокаОтбор.Значение)=Тип("Строка")И СтрокаОтбор.Условие<>"IN" Тогда
				ЗначениеСтрокой = "'"+СтрЗаменить(СтрокаОтбор.Значение,"'","''")+"'"
			ИначеЕсли ТипЗнч(СтрокаОтбор.Значение)=Тип("Число") Тогда
				ЗначениеСтрокой = Формат(СтрокаОтбор.Значение,"ЧН=; ЧГ=0")
			ИначеЕсли ТипЗнч(СтрокаОтбор.Значение)=Тип("Дата") Тогда
				ЗначениеСтрокой ="Convert(DATETIME,'"+Формат(СтрокаОтбор.Значение,"ДФ='yyyy-dd-MM HH:mm:ss")+"')"
			Иначе
				ЗначениеСтрокой = СтрокаОтбор.Значение
			КонецЕсли;
			УсловиеОтбора = ?(УсловиеОтбора="","Where ",УсловиеОтбора+" and ")+СтрокаОтбор.Поле+" "+СтрокаОтбор.Условие+" "+ЗначениеСтрокой
		КонецЕсли;
	КонецЦикла;
	
	ТекстЗапроса = СтрЗаменить(ТекстЗапроса,"&TOP","TOP "+Формат(ВыбиратьПервые,"ЧН=; ЧГ=0"));
	ТекстЗапроса = СтрЗаменить(ТекстЗапроса,"&WHERE",УсловиеОтбора);
	
   rs = ADOСоединение.Execute(ТекстЗапроса);
   Объект.ТаблицаОшибок.Очистить();
   Попытка
       rs.MoveFirst();
       
       Пока НЕ rs.EOF() Цикл
           СтрокаДоб = Объект.ТаблицаОшибок.Добавить();
		   СтрокаДоб.CashId = rs.Fields("CashId").Value;
		   СтрокаДоб.Action = rs.Fields("Action").Value;
		   СтрокаДоб.DateTime = rs.Fields("DATETIME").Value;
		   СтрокаДоб.Id = rs.Fields("ID").Value;
		   СтрокаДоб.Monobloc = rs.Fields("Monobloc").Value;
		   СтрокаДоб.Acquiring = rs.Fields("Acquiring").Value;
		   СтрокаДоб.script = rs.Fields("script").Value;
		   СтрокаДоб.Vesi = rs.Fields("vesi").Value;
		   СтрокаДоб.FR = rs.Fields("FR").Value;
		   СтрокаДоб.ПредыдущОпер = rs.Fields("ПредыдущОпер").Value;
           rs.MoveNext();
       КонецЦикла;
   Исключение
	   Сообщить("Не удалось прочитать все записи")
   КонецПопытки;
   ADOСоединение.Close();
КонецПроцедуры

&НаКлиенте
Процедура Прочитать(Команда)
	// Вставить содержимое обработчика.
	СнятьФильтр(Неопределено);
	ПрочитатьНаСервере();
	Элементы.Страницы.ТекущаяСтраница=Элементы.СтраницаОшибки
КонецПроцедуры

&НаКлиенте
Процедура Фильтровать(Команда)
	// Вставить содержимое обработчика.
	СтруктураОтбора = Новый Структура("Action,DateTime,FR,Acquiring,ПредыдущОпер,Script,Monobloc");
    ЗаполнитьЗначенияСвойств(СтруктураОтбора,ЭтаФорма);
	ФильтрТекст = "";
	Для Каждого Элемент из СтруктураОтбора цикл
		Если Не ЗначениеЗаполнено(Элемент.Значение)Тогда
			СтруктураОтбора.Удалить(Элемент.Ключ)
		Иначе
			ФильтрТекст = ФильтрТекст+Элемент.Ключ+": "+Строка(Элемент.Значение)+";"
		КонецЕсли;
	КонецЦикла;
	ФМ = Новый ФиксированнаяСтруктура(СтруктураОтбора);
	Элементы.ТаблицаОшибок.ОтборСтрок=ФМ;
	Если ФильтрТекст <>"" Тогда
		Элементы.ФильтрТекст.Заголовок = ФильтрТекст;
	КонецЕсли;
КонецПроцедуры

&НаСервере
Процедура ПрочитатьЛогиКассыНаСервере(ТекущаяСтрока)
	
	ADOСоединение = ВнешниеДанные.ПолучитьADOСоединение();
	
	ТекстЗапроса = Обработки.АК_МониторингКасс.ПолучитьМакет("Запрос_01").ПолучитьТекст();
	
	ТекстЗапроса = СтрЗаменить(ТекстЗапроса,"&ID",Формат(ТекущаяСтрока.Id,"ЧГ=0"));
	ТекстЗапроса = СтрЗаменить(ТекстЗапроса,"&CashID",Формат(ТекущаяСтрока.CashId,"ЧГ=0"));
	
        МассивКУдалению = Новый Массив;
		Для Каждого Колонка из Элементы.ЛогиКассы.ПодчиненныеЭлементы Цикл
			МассивКУдалению.Добавить(Колонка);
		КонецЦикла;
		
		Для Каждого Колонка из МассивКУдалению Цикл
			Элементы.Удалить(Колонка)
		КонецЦикла;
		
		МассивРеквизитов = Новый Массив;
		Для Каждого Колонка из ЭтаФорма.ПолучитьРеквизиты("ТабЛогиКассы") Цикл
			МассивРеквизитов.Добавить("ТабЛогиКассы."+Колонка.Имя);
		КонецЦикла;
		
		ЭтаФорма.ИзменитьРеквизиты(,МассивРеквизитов);
		ТЗ = Новый ТаблицаЗначений;
	    ЗначениеВРеквизитФормы(ТЗ,"ТабЛогиКассы");
	
	
	rs = ADOСоединение.Execute(ТекстЗапроса);
	   
	Rez = New ValueTable;	
	
	Попытка
		For i=0 to rs.Fields.Count-1 do
			Rez.Columns.Add(rs.Fields(i).Name,Новый ОписаниеТипов("Строка"));
		EndDo;
	Исключение
	   ADOСоединение.Close();
	   Сообщить("Ошибка чтения структуры таблицы");
	   Возврат
		
	КонецПопытки;
	
	МассивРеквизитов = Новый Массив;
	Для Каждого Колонка из Rez.Колонки Цикл
		МассивРеквизитов.Добавить(Новый РеквизитФормы(Колонка.Имя,Колонка.ТипЗначения,"ТабЛогиКассы"));
	КонецЦикла;
	ЭтаФорма.ИзменитьРеквизиты(МассивРеквизитов);
	Попытка
       rs.MoveFirst();
       
	   Пока НЕ rs.EOF() Цикл
		   Row = Rez.Add();
		   For i=0 to rs.Fields.Count-1 do
		   	Row[rs.Fields(i).Name]=rs.Fields(i).Value
		   EndDo;
           rs.MoveNext();
       КонецЦикла;
	   
   Исключение
	   Сообщить("Нет записей в таблице");
	   ADOСоединение.Close();
	   Возврат
   КонецПопытки;
   
   Для Каждого Поле из Rez.Колонки Цикл
	   Колонка = Элементы.Добавить("ЛогиКассы"+Поле.Имя,Тип("ПолеФормы"),Элементы.ЛогиКассы);
	   Колонка.ПутьКДанным="ТабЛогиКассы."+Поле.Имя;
	   Колонка.Вид = ВидПоляФормы.ПолеВвода;
   КонецЦикла;
   
   ЗначениеВРеквизитФормы(Rez,"ТабЛогиКассы");
   
КонецПроцедуры

&НаКлиенте
Процедура ПрочитатьЛогиКассы(Команда)
	// Вставить содержимое обработчика.
	ДанныеСтроки = Новый Структура("Id,CashId");
	ЗаполнитьЗначенияСвойств(ДанныеСтроки,Элементы.ТаблицаОшибок.ТекущиеДанные);
	Если ДанныеСтроки.Id=0 Тогда
		Возврат
	КонецЕсли;
	ПрочитатьЛогиКассыНаСервере(ДанныеСтроки);
	Элементы.Страницы.ТекущаяСтраница=Элементы.СтраницаКасса;
КонецПроцедуры

&НаКлиенте
Процедура ТаблицаОшибокВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	// Вставить содержимое обработчика.
	ПрочитатьЛогиКассы(Неопределено)
КонецПроцедуры

&НаСервере
Процедура УстановитьЗаголовокОтбора()
	ЗаголовокОтбор = "";
	Для Каждого СтрокаОтбор из ТаблицаНастроекОтбора Цикл
		Если СтрокаОтбор.Использовать Тогда
			ЗаголовокОтбор = ЗаголовокОтбор+СтрокаОтбор.Поле+" "+СтрокаОТбор.Условие+" "+СтрокаОтбор.Значение+";"
		КонецЕсли;
	КонецЦикла;
	Элементы.УстановитьОтбор.Заголовок = ?(ЗаголовокОтбор="","Установить отбор","Текущий отбор: "+ЗаголовокОтбор)
КонецПроцедуры

&НаКлиенте
Процедура УстановитьОтбор(Команда)
	МассивНастроек = Новый Массив;
	Для Каждого СтрокаОтбор из ТаблицаНастроекОтбора Цикл
		МассивНастроек.Добавить(Новый Структура("Использовать,Поле,Условие,Значение",СтрокаОтбор.Использовать,СтрокаОтбор.Поле,СтрокаОтбор.Условие,СтрокаОтбор.Значение));
	КонецЦикла;
		
	ПараметрыОткрытия = Новый Структура("НастройкиОтбора,ВыбиратьПервых",МассивНастроек,ВыбиратьПервые);
	
	РезультатНастройки = ОткрытьФормуМодально("Обработка.АК_МониторингКасс.Форма.ФормаНастройки",ПараметрыОткрытия,ЭтаФорма);
	Если РезультатНастройки<>Неопределено Тогда
		ТаблицаНастроекОтбора.Очистить();
		Для Каждого СтрокаРезультат из РезультатНастройки.МассивОтбор Цикл
			СтрокаНастроек = ТаблицаНАстроекОтбора.Добавить();
			ЗаполнитьЗначенияСвойств(СтрокаНастроек,СтрокаРезультат)
		КонецЦикла;
		ВыбиратьПервые = РезультатНастройки.ВыбиратьПервые;
		УстановитьЗаголовокОтбора();
		Прочитать(Неопределено);
	КонецЕсли;
КонецПроцедуры

&НаСервере
Процедура УстановитьПустыеНастройкиОтбора()
	ТаблицаНастроекОтбора.Очистить();
	СтрокаОтбор = ТаблицаНастроекОтбора.Добавить();
	СтрокаОтбор.Поле = "Action";
	СтрокаОтбор.Условие = "=";
	СтрокаОтбор.Значение = "";
	СтрокаОтбор.Использовать = Ложь;
	
	СтрокаОтбор = ТаблицаНастроекОтбора.Добавить();
	СтрокаОтбор.Поле = "CashID";
	СтрокаОтбор.Условие = "=";
	СтрокаОтбор.Значение = 0;
	СтрокаОтбор.Использовать = Ложь;
	
	
	СтрокаОтбор = ТаблицаНастроекОтбора.Добавить();
	СтрокаОтбор.Поле = "Id";
	СтрокаОтбор.Условие = "=";
	СтрокаОтбор.Значение = 0;
	СтрокаОтбор.Использовать = Ложь;

	СтрокаОтбор = ТаблицаНастроекОтбора.Добавить();
	СтрокаОтбор.Поле = "FR";
	СтрокаОтбор.Условие = "=";
	СтрокаОтбор.Значение = 0;
	СтрокаОтбор.Использовать = Ложь;

	СтрокаОтбор = ТаблицаНастроекОтбора.Добавить();
	СтрокаОтбор.Поле = "DateTime";
	СтрокаОтбор.Условие = "=";
	СтрокаОтбор.Значение = Дата(1,1,1);
	СтрокаОтбор.Использовать = Ложь;
	
	СтрокаОтбор = ТаблицаНастроекОтбора.Добавить();
	СтрокаОтбор.Поле = "Monobloc";
	СтрокаОтбор.Условие = "=";
	СтрокаОтбор.Значение = 0;
	СтрокаОтбор.Использовать = Ложь;

	СтрокаОтбор = ТаблицаНастроекОтбора.Добавить();
	СтрокаОтбор.Поле = "Script";
	СтрокаОтбор.Условие = "=";
	СтрокаОтбор.Значение = 0;
	СтрокаОтбор.Использовать = Ложь;
	
	СтрокаОтбор = ТаблицаНастроекОтбора.Добавить();
	СтрокаОтбор.Поле = "Acquiring";
	СтрокаОтбор.Условие = "=";
	СтрокаОтбор.Значение = 0;
	СтрокаОтбор.Использовать = Ложь;
	
	СтрокаОтбор = ТаблицаНастроекОтбора.Добавить();
	СтрокаОтбор.Поле = "Vesi";
	СтрокаОтбор.Условие = "=";
	СтрокаОтбор.Значение = 0;
	СтрокаОтбор.Использовать = Ложь;
	
	СтрокаОтбор = ТаблицаНастроекОтбора.Добавить();
	СтрокаОтбор.Поле = "ПредыдущОпер";
	СтрокаОтбор.Условие = "=";
	СтрокаОтбор.Значение = "";
	СтрокаОтбор.Использовать = Ложь;
	
	ВыбиратьПервые = 500
КонецПроцедуры

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	//Вставить содержимое обработчика
	УстановитьПустыеНастройкиОтбора();	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	УстановитьЗаголовокОтбора()
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	// Вставить содержимое обработчика.
КонецПроцедуры

&НаКлиенте
Процедура СнятьФильтр(Команда)
	Элементы.ТаблицаОшибок.ОтборСтрок=Неопределено;
	Элементы.ФильтрТекст.Заголовок = "Все записи";
КонецПроцедуры

&НаКлиенте
Процедура ОчиститьНастройки(Команда)
	// Вставить содержимое обработчика.
	УстановитьПустыеНастройкиОтбора();
	УстановитьЗаголовокОтбора();
	Если Вопрос("Прочитать данные с сервера?",РежимДиалогаВопрос.ДаНет)=КодВозвратаДиалога.Да Тогда
		Прочитать(Неопределено)
	КонецЕсли;
КонецПроцедуры

&НаСервере
Процедура ПриЗагрузкеДанныхИзНастроекНаСервере(Настройки)
КонецПроцедуры

&НаСервере
Процедура ПередЗагрузкойДанныхИзНастроекНаСервере(Настройки)
	//Вставить содержимое обработчика
КонецПроцедуры
