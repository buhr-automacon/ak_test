﻿Функция ПолучитьНовыйИнвентарныйНомер() Экспорт 
	
	//ШаблонНомераБУ = "Б_000000000";
	
	Префикс = "Б_";
	ДлинаПрефикса = 2;
	ДлинаНомера = 9;
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ
		|	ОсновныеСредства.ИнвентарныйНомер,
		|	ПОДСТРОКА(ОсновныеСредства.ИнвентарныйНомер, 1, &ДлинаПрефикса) КАК Префикс,
		|	ПОДСТРОКА(ОсновныеСредства.ИнвентарныйНомер, &ДлинаПрефикса + 1, &ДлинаНомера) КАК Номер,
		|	ПОДСТРОКА(ОсновныеСредства.ИнвентарныйНомер, &ДлинаПрефикса + &ДлинаНомера, 1) КАК ПолследнийСимвол,
		|	ПОДСТРОКА(ОсновныеСредства.ИнвентарныйНомер, &ДлинаПрефикса + &ДлинаНомера + 1, 1) КАК СимволПроверка
		|ПОМЕСТИТЬ втОсновныеСредства
		|ИЗ
		|	Справочник.ОсновныеСредства КАК ОсновныеСредства
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	втОсновныеСредства.ИнвентарныйНомер,
		|	втОсновныеСредства.Префикс,
		|	втОсновныеСредства.Номер КАК Номер
		|ИЗ
		|	втОсновныеСредства КАК втОсновныеСредства
		|ГДЕ
		|	втОсновныеСредства.ПолследнийСимвол <> """"
		|	И втОсновныеСредства.СимволПроверка = """"
		|	И втОсновныеСредства.Префикс = &Префикс
		|
		|УПОРЯДОЧИТЬ ПО
		|	Номер УБЫВ";

	Запрос.УстановитьПараметр("Префикс", Префикс);
	Запрос.УстановитьПараметр("ДлинаПрефикса", ДлинаПрефикса);
	Запрос.УстановитьПараметр("ДлинаНомера", ДлинаНомера);

	Результат = Запрос.Выполнить();

	ВыборкаДетальныеЗаписи = Результат.Выбрать();

	Пока ВыборкаДетальныеЗаписи.Следующий() Цикл
		
		Если ПроверитьСимволыВНомере(ВыборкаДетальныеЗаписи.Номер) Тогда
			
			Номер = Число(ВыборкаДетальныеЗаписи.Номер) + 1;
			Возврат  Префикс + СтрЗаменить(Формат(Номер, "ЧЦ=" +ДлинаНомера + "; ЧДЦ=0; ЧРГ=' '; ЧВН=")," ",""); 	
			
		Конецесли;
		                                
	КонецЦикла;                            

	Возврат  Префикс + СтрЗаменить(Формат(1, "ЧЦ=" +ДлинаНомера + "; ЧДЦ=0; ЧРГ=' '; ЧВН=")," ","");
	
КонецФункции



Функция ПроверитьСимволыВНомере(Номер)
	
	Цифры = "1234567890";
	
	Для НомСимвола = 1 По СтрДлина(Номер) Цикл
		
		Если Найти(Цифры, Сред(Номер, НомСимвола, 1)) = 0 Тогда
			Возврат Ложь;
		КонецЕсли;
		
	КонецЦикла;
	
	Возврат Истина
	
КонецФункции	

