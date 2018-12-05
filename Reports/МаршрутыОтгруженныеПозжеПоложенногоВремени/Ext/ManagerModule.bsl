﻿
//+++АК LATV 2018.10.20 ИП-00020070
Функция КодДляВыполненияВПериодическихЗаданиях(ТекущаяОбработка, Параметры) Экспорт

	ЗапросПолучателей = Новый Запрос();
	ЗапросПолучателей.Текст =
		"ВЫБРАТЬ
		|	ПериодическиеЗаданияПолучателиРассылки.ФизЛицо КАК ФизЛицо
		|ИЗ
		|	Справочник.ПериодическиеЗадания.ПолучателиРассылки КАК ПериодическиеЗаданияПолучателиРассылки
		|ГДЕ
		|	ПериодическиеЗаданияПолучателиРассылки.Ссылка = &Задание";
	
	ЗапросПолучателей.УстановитьПараметр("Задание", ТекущаяОбработка);
	Получатели = ЗапросПолучателей.Выполнить().Выгрузить().ВыгрузитьКолонку("ФизЛицо");
	
	// Выполнение отчета
	ВыполняемыйОтчет = Отчеты.МаршрутыОтгруженныеПозжеПоложенногоВремени.Создать();
	
	ВыполняемыйОтчет.КомпоновщикНастроек.ФиксированныеНастройки.ДополнительныеСвойства.Вставить("РежимРассылки");
	ВыполняемыйОтчет.КомпоновщикНастроек.ФиксированныеНастройки.ДополнительныеСвойства.Вставить("ОтчетЗаВесьДень",	Параметры.Свойство("ОтчетЗаВесьДень"));
	ВыполняемыйОтчет.КомпоновщикНастроек.ФиксированныеНастройки.ДополнительныеСвойства.Вставить("Получатели",		Получатели);
	ВыполняемыйОтчет.КомпоновщикНастроек.ФиксированныеНастройки.ДополнительныеСвойства.Вставить("ПолучателиСМС",	?(Параметры.Свойство("ПолучателиСМС"), Параметры.ПолучателиСМС, Новый Массив));
	
	ВыполняемыйОтчет.СкомпоноватьРезультат(Новый ТабличныйДокумент, Неопределено);

КонецФункции
