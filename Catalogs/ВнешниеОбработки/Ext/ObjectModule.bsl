﻿Перем ПрошлыйИзмененныйРодительОбъектаДоступа;

Процедура ПередЗаписью(Отказ)
	
	Если НЕ ОбменДанными.Загрузка Тогда
		
		ПрошлыйИзмененныйРодительОбъектаДоступа = ?(Не ЭтоНовый() и Не Ссылка.Родитель = Родитель, Ссылка.Родитель, Неопределено);
		НастройкаПравДоступа.ПередЗаписьюНовогоОбъектаСПравамиДоступаПользователей(ЭтотОбъект, Отказ, Родитель);
		
		#Если Клиент Тогда
		Если ВидОбработки = Перечисления.ВидыДополнительныхВнешнихОбработок.ЗаполнениеТабличныхЧастей Тогда
				
			// Сообщить о неуказанных табличных частей для заполнения.
			Для Каждого СтрокаПринадлежность Из Принадлежность Цикл
					
				Если ПустаяСтрока(СтрокаПринадлежность.ТабличнаяЧастьИмя) ИЛИ ПустаяСтрока(СтрокаПринадлежность.ТабличнаяЧастьПредставление) Тогда
					Сообщить("Не указана табличная часть для заполнения: " + СтрокаПринадлежность.ПредставлениеОбъекта, СтатусСообщения.Внимание);
				КонецЕсли;
					
			КонецЦикла;
				
		КонецЕсли;
		#КонецЕсли
		
	КонецЕсли;
	
КонецПроцедуры

Процедура ПриЗаписи(Отказ)
	
	Если ПометкаУдаления Тогда
		Возврат;
	КонецЕсли;
	
	Если НЕ ОбменДанными.Загрузка Тогда
		
		НастройкаПравДоступа.ОбновитьПраваДоступаКИерархическимОбъектамПриНеобходимости(Ссылка,ПрошлыйИзмененныйРодительОбъектаДоступа, Отказ);
		
	КонецЕсли;
	
КонецПроцедуры

