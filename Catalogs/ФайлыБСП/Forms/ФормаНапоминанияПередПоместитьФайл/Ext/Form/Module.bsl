﻿&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	БольшеНеПоказывать = Ложь;
	
	ТекстНапоминания = 
	НСтр("ru = 'Сейчас Вам будет предложено выбрать файл для того, чтобы поместить его в информационную базу и закончить редактирование.
	           |Найдите нужный файл в том каталоге, который Вы указывали ранее при начале редактирования.'");
	
КонецПроцедуры

&НаКлиенте
Процедура ОК(Команда)
	Закрыть(БольшеНеПоказывать);
КонецПроцедуры
