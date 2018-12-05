﻿
&НаСервере
Процедура ПослеЗаписиНаСервере(ТекущийОбъект, ПараметрыЗаписи)
	
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("ВариантОбеспеченияПерсоналом", ТекущийОбъект.ВариантОбеспеченияПерсоналом);
	Запрос.УстановитьПараметр("ДатаНачала"					, ТекущийОбъект.ДатаНачала);
	Запрос.УстановитьПараметр("ТорговаяТочка"				, ТекущийОбъект.ТорговаяТочка);
	
	Запрос.Текст =
	"ВЫБРАТЬ
	|	ТЧОбеспечениеПерсоналом.Контрагент КАК Контрагент,
	|	&ТорговаяТочка КАК ТорговаяТочка,
	|	&ДатаНачала КАК ДатаНачала,
	|	ТЧОбеспечениеПерсоналом.Должность,
	|	ТЧОбеспечениеПерсоналом.КоличествоЧеловек,
	|	ТЧОбеспечениеПерсоналом.НачалоСмены,
	|	ТЧОбеспечениеПерсоналом.ОкончаниеСмены
	|ИЗ
	|	Справочник.ВариантыОбеспеченияПерсоналомАутсорсинг.ОбеспечениеПерсоналом КАК ТЧОбеспечениеПерсоналом
	|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.ИсторияИзмененийПотребностиВПерсоналеАутсорсинг.СрезПоследних(
	|				,
	|				ТорговаяТочка = &ТорговаяТочка
	|					И ДатаНачала = &ДатаНачала) КАК РегистрИстория
	|		ПО (РегистрИстория.Контрагент = ТЧОбеспечениеПерсоналом.Контрагент)
	|			И (РегистрИстория.Должность = ТЧОбеспечениеПерсоналом.Должность)
	|			И (НЕ РегистрИстория.Отмена)
	|ГДЕ
	|	ТЧОбеспечениеПерсоналом.Ссылка = &ВариантОбеспеченияПерсоналом
	|	И РегистрИстория.Контрагент ЕСТЬ NULL ";
	
	РезультатЗапроса = Запрос.Выполнить();
	
	//
	Если НЕ РезультатЗапроса.Пустой() Тогда
		
		НаборЗаписей = РегистрыСведений.ИсторияИзмененийПотребностиВПерсоналеАутсорсинг.СоздатьНаборЗаписей();
		
		Выборка = РезультатЗапроса.Выбрать();
		Пока Выборка.Следующий() Цикл
			ТекЗапись = НаборЗаписей.Добавить();
			ЗаполнитьЗначенияСвойств(ТекЗапись, Выборка);
			ТекЗапись.Период = ТекущаяДата();
		КонецЦикла;
		
		Попытка
			НаборЗаписей.Записать(Ложь);
		Исключение
			Сообщить("Не удалось записать историю изменений варианта");
		КонецПопытки;
		
	КонецЕсли;

КонецПроцедуры
