﻿Процедура ОтобразитьСостояние(ТекстСообщения) Экспорт
		
	#Если Клиент Тогда
	Состояние(ТекстСообщения);
	#КонецЕсли

КонецПроцедуры

Процедура ПроверитьПрерывание() Экспорт
	#Если Клиент Тогда
	ОбработкаПрерыванияПользователя();
	#КонецЕсли
КонецПроцедуры	

Функция ОткрытьФормуХодаОбработки() Экспорт
	
	#Если Клиент Тогда
		возврат ПолучитьОбщуюФорму("ХодВыполненияОбработкиДанных");
	#Иначе			
		возврат Новый Структура("НаименованиеОбработкиДанных,КомментарийОбработкиДанных,КомментарийЗначения,МаксимальноеЗначение,Значение");			
	#КонецЕсли
	
КонецФункции

//Функция ПолучитьФормуЗагрузкиЗаказов() Экспорт
//	
//	возврат ПолучитьФорму("ФормаЗагрузкиЗаказов");
//	
//КонецФункции