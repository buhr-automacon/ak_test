﻿
//+++АК LATV 2018.06.26 ИП-00018971
Процедура ДобавитьДокументВОчередь(Документ, Отказ) Экспорт

	НаборЗаписей = РегистрыСведений.ОтложенныеДвиженияДокументовПоБухРегистру.СоздатьНаборЗаписей();
	НаборЗаписей.Отбор.Документ.Установить(Документ);
	
	Запись = НаборЗаписей.Добавить();
	Запись.Документ = Документ;
	
	Попытка
		НаборЗаписей.Записать();
	Исключение
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ОписаниеОшибки(),,,, Отказ);
	КонецПопытки;

КонецПроцедуры
