﻿
&НаСервере
Функция Печать(ПараметрКоманды,ФИОДир,ФИОКлиента)
	
	Возврат Справочники.ДополнительныеСоглашения.ПечатьДопСоглашение(ПараметрКоманды,ФИОДир,ФИОКлиента);
	
КонецФункции

&НаКлиенте
Процедура ОбработкаКоманды(ПараметрКоманды, ПараметрыВыполненияКоманды)
    ФИОДир="";
	ФИОКлиента="";
	ПолучитьФИО(ПараметрКоманды, ФИОДир,ФИОКлиента);
	ОбщиеПроцедуры.ПросклонятьФИО(ФИОДир, 2,,ФИОДир);
	ОбщиеПроцедуры.ПросклонятьФИО(ФИОКлиента, 2,,ФИОКлиента);
	ТабДок = Печать(ПараметрКоманды,ФИОДир,ФИОКлиента);
  	Если ТабДок = Неопределено Тогда
		Возврат;
	КонецЕсли;

	ТабДок.ОтображатьСетку 		= Ложь;
	ТабДок.Защита 				= Ложь;
	ТабДок.ТолькоПросмотр 		= Истина;
	ТабДок.ОтображатьЗаголовки 	= Ложь;
	ТабДок.Показать();
		
	
КонецПроцедуры

&НаСервере
Процедура ПолучитьФИО(Ссылка,ФИОДир,ФИОКлиента)
	Руководители 		= ОбщегоНазначения.ОтветственныеЛица(Ссылка.Договор.Организация, Ссылка.Дата,);
    Контрагент=Ссылка.Договор.Владелец;
	Организация=Ссылка.Договор.Организация;
	
	ФИОДир = Руководители.Руководитель;
	
	ФИОКлиента = Контрагент.ГенеральныйДиректор;

КонецПроцедуры
 