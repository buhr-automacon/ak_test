﻿
&НаКлиенте
Процедура ОбработкаКоманды(ПараметрКоманды, ПараметрыВыполненияКоманды)
	
	//Магазины_Клиент.УправлениеОкнамиМагазинов("КассовыеОперации");
	ОткрытьФорму("Обработка.РекламныеМатериалыМагазинов.Форма.Форма", , , "ТД_РекламныеМатериалы", ПараметрыВыполненияКоманды.Окно);
	//+++АК mika 2018.08.09 ИП-00019475 "Статистика использования(Удалить)"?
	ОбщегоНазначенияСервер.СтатистикаИспользованияПодсистемДобавитьЗапись(Новый Структура("Подсистема, ИмяОбъекта, ИмяФормы, ИмяЭлемента, ДопИнформация", 
			"Магазины", "ОбщаяКоманда.РекламныеМатериалы" , , ,"ОткрытьФорму(Обработка.РекламныеМатериалыМагазинов.Форма.Форма)")); 
	//---АК mika
КонецПроцедуры
