﻿
&НаСервере
Функция Печать(ПараметрКоманды)

	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ
		|	ЗаявкаНаРоуминг.Ссылка
		|ИЗ
		|	Документ.ЗаявкаНаРоуминг КАК ЗаявкаНаРоуминг
		|ГДЕ
		|	ЗаявкаНаРоуминг.Проведен
		|	И ЗаявкаНаРоуминг.Основание = &Основание";

	Запрос.УстановитьПараметр("Основание", ПараметрКоманды);

	Результат = Запрос.Выполнить();

	ВыборкаДетальныеЗаписи = Результат.Выбрать();
    Мас=Новый Массив;
	Пока ВыборкаДетальныеЗаписи.Следующий() Цикл
		Мас.Добавить(Документы.ЗаявкаНаРоуминг.ПечатьПриложение(ВыборкаДетальныеЗаписи.Ссылка));
	КонецЦикла;

	Возврат Мас;	
	
КонецФункции

&НаКлиенте
Процедура ОбработкаКоманды(ПараметрКоманды, ПараметрыВыполненияКоманды)
	
	МасТабДок = Печать(ПараметрКоманды);
 	Если МасТабДок = Неопределено Тогда
		Возврат;
	КонецЕсли;

	//ОповеститьОбИзменении(ПараметрКоманды);
	Для каждого Эл Из МасТабДок Цикл
		ТабДок=Эл;	
		ТабДок.ОтображатьСетку			= Ложь;
		ТабДок.Защита					= Ложь;
		ТабДок.ТолькоПросмотр			= Истина;
		ТабДок.ОтображатьЗаголовки		= Ложь;
		ТабДок.ОриентацияСтраницы		= ОриентацияСтраницы.Ландшафт;
		ТабДок.РазмерКолонтитулаСнизу	= 0;
		ТабДок.РазмерКолонтитулаСверху 	= 0;
		ТабДок.ПолеСверху 				= 5;
		ТабДок.ПолеСнизу 				= 5;
		ТабДок.ПолеСлева 				= 5;
		ТабДок.ПолеСправа 				= 5;
		ТабДок.АвтоМасштаб				= Истина;
		ТабДок.Показать();			
	КонецЦикла; 
	
КонецПроцедуры
