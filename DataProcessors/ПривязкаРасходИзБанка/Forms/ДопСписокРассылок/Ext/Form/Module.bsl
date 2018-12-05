﻿
&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Попытка
		Хран = Константы.ДопСписокРассылкиСвязокПостБанка.Получить();		
		СписокРассылки.Загрузить(Хран.Получить());
	Исключение
	КонецПопытки;
	
КонецПроцедуры

&НаКлиенте
Процедура Сохранить(Команда)
	
	СохранитьНаСервере();	
	
КонецПроцедуры

&НаСервере
Процедура СохранитьНаСервере()
	
	тз = СписокРассылки.Выгрузить();
	
	Сжатие = Новый СжатиеДанных(9);
	Хран = Новый ХранилищеЗначения(тз,Сжатие);
	Константы.ДопСписокРассылкиСвязокПостБанка.Установить(хран);
	
КонецПроцедуры
 
