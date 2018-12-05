﻿
Процедура ПередЗаписью(Отказ, РежимЗаписи, РежимПроведения)
	
	//
	Запрос = Новый Запрос(	"ВЫБРАТЬ
	                      	|	МобильноеПриложение.Ссылка
	                      	|ИЗ
	                      	|	ПланОбмена.МобильноеПриложение КАК МобильноеПриложение
	                      	|ГДЕ
	                      	|	МобильноеПриложение.Магазин.Ссылка ЕСТЬ NULL
							|	И МобильноеПриложение.Профиль <> ЗНАЧЕНИЕ(Справочник.МП_ПрофилиИспользования.Строитель)");
	
	Выборка = Запрос.Выполнить().Выбрать();
	
	Пока Выборка.Следующий() Цикл
		Если Выборка.Ссылка <> ПланыОбмена.МобильноеПриложение.ЭтотУзел() Тогда
			ОбменДанными.Получатели.Добавить(Выборка.Ссылка);
		КонецЕсли;
	КонецЦикла;  
	
КонецПроцедуры

Процедура ОбработкаЗаполнения(ДанныеЗаполнения, СтандартнаяОбработка)
	
	Если ТипЗнч(ДанныеЗаполнения) = Тип("СправочникСсылка.ПлановыйАссортимент") Тогда
		ПлановыйАссортимент = ДанныеЗаполнения.Ссылка;
		//Исполнитель = ДанныеЗаполнения.Ответственный;
		Если ЗначениеЗаполнено(ДанныеЗаполнения.РольТехнолога) Тогда
			РольТехнологаСоставРоли = ДанныеЗаполнения.РольТехнолога.СоставРоли;
			Если РольТехнологаСоставРоли.Количество() >= 1 Тогда
				Исполнитель = РольТехнологаСоставРоли[0].Сотрудник;
			КонецЕсли;
		КонецЕсли;
		Ответственный = ДанныеЗаполнения.ПродактМенеджер;
	КонецЕсли;
	
КонецПроцедуры
