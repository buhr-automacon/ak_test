﻿Функция ПолучитьУтверждающихПоПремии(Период, ФизЛицо) Экспорт
	
	МСРез = Новый Массив;
	
	Запрос1 = Новый Запрос;
	Запрос1.Текст = 
	"ВЫБРАТЬ
	|	Премии.Регистратор.Утверждающий КАК Утверждающий,
	|	Премии.Регистратор.Утверждено КАК Утверждено,
	|	Премии.Регистратор
	|ИЗ
	|	РегистрНакопления.Премии КАК Премии
	|ГДЕ
	|	Премии.ФизЛицо = &ФизЛицо
	|	И Премии.Период МЕЖДУ &ДатаНач И &ДатаКон
	|	И Премии.Регистратор.Утверждено = ИСТИНА";
	
	Запрос1.УстановитьПараметр("ФизЛицо", ФизЛицо);
	Запрос1.УстановитьПараметр("ДатаНач", НачалоМесяца(Период));
	Запрос1.УстановитьПараметр("ДатаКон", КонецМесяца(Период));
	
	Рез1 = Запрос1.Выполнить();
	Выб1 = Рез1.Выбрать();
	
	Пока Выб1.Следующий() Цикл
		Эл1 = МСРез.Найти(Выб1.Утверждающий);
		Если Эл1 = Неопределено Тогда
			МСРез.Добавить(Выб1.Утверждающий);
		КонецЕсли;
	КонецЦикла;
	
	Возврат МСРез;

КонецФункции // ()
