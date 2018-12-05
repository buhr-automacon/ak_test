﻿Функция ИзменитьЗапросС_1_1_2018(ТекстЗапроса) Экспорт
	ТекстЗапроса = СтрЗаменить(ТекстЗапроса,
	"ВЫБРАТЬ
	|	""Гарантийные депозиты по договорам аренды"",
	|	""60.1"",
	|	""Дт"",
	|	ЛОЖЬ,
	|	10
	|
	|ОБЪЕДИНИТЬ ВСЕ",
	"ВЫБРАТЬ
	|	""Гарантийные депозиты по договорам аренды"",
	|	""60.1"",
	|	""Дт"",
	|	ЛОЖЬ,
	|	10
	|ГДЕ
	|	&НачалоПериода < ДАТАВРЕМЯ(2018, 1, 1)
	|
	|ОБЪЕДИНИТЬ ВСЕ");
	
	ТекстЗапроса = СтрЗаменить(ТекстЗапроса,
	"ВЫБРАТЬ
	|	""Долгосрочные гарантийные депозиты по договорам аренды"",
	|	""Долгосрочные депозиты аренды (60.1)"",
	|	""Дт"",
	|	ЛОЖЬ,
	|	2
	|
	|ОБЪЕДИНИТЬ ВСЕ",
	"ВЫБРАТЬ
	|	""Долгосрочные гарантийные депозиты по договорам аренды"",
	|	""Долгосрочные депозиты аренды (60.1)"",
	|	""Дт"",
	|	ЛОЖЬ,
	|	2
	|ГДЕ
	|	&НачалоПериода < ДАТАВРЕМЯ(2018, 1, 1)
	|
	|ОБЪЕДИНИТЬ ВСЕ");
	
	ТекстЗапроса = СтрЗаменить(ТекстЗапроса,
	"ВЫБРАТЬ
	|	""Гарантийные депозиты по договорам аренды"",
	|	""96.Д"",
	|	""Кт"",
	|	ИСТИНА,
	|	10
	|
	|ОБЪЕДИНИТЬ ВСЕ",
	"ВЫБРАТЬ
	|	""Гарантийные депозиты по договорам аренды"",
	|	""96.Д"",
	|	""Кт"",
	|	ИСТИНА,
	|	10
	|ГДЕ
	|	&НачалоПериода < ДАТАВРЕМЯ(2018, 1, 1)
	|
	|ОБЪЕДИНИТЬ ВСЕ");
	
	ТекстЗапроса = СтрЗаменить(ТекстЗапроса,
	"ВЫБРАТЬ
	|	""Активы в форме права пользования"",
	|	""Долгосрочные депозиты аренды (60.1)"",
	|	""Дт"",
	|	Ложь,
	|	10
	|ГДЕ
	|	Ложь
	|
	|ОБЪЕДИНИТЬ ВСЕ",
	"ВЫБРАТЬ
	|	""Активы в форме права пользования"",
	|	""Долгосрочные депозиты аренды (60.1)"",
	|	""Дт"",
	|	Ложь,
	|	10
	|ГДЕ
	|	&НачалоПериода >= ДАТАВРЕМЯ(2018, 1, 1)
	|
	|ОБЪЕДИНИТЬ ВСЕ");
	
	ТекстЗапроса = СтрЗаменить(ТекстЗапроса,
	"ВЫБРАТЬ
	|	""Активы в форме права пользования"",
	|	""Актив по аренде (аренда) (03.1)"",
	|	""Дт"",
	|	Ложь,
	|	10
	|ГДЕ
	|	Ложь
	|
	|ОБЪЕДИНИТЬ ВСЕ",
	"ВЫБРАТЬ
	|	""Активы в форме права пользования"",
	|	""Актив по аренде (аренда) (03.1)"",
	|	""Дт"",
	|	Ложь,
	|	10
	|ГДЕ
	|	&НачалоПериода >= ДАТАВРЕМЯ(2018, 1, 1)
	|
	|ОБЪЕДИНИТЬ ВСЕ");
	
	ТекстЗапроса = СтрЗаменить(ТекстЗапроса,
	"ВЫБРАТЬ
	|	""Активы в форме права пользования"",
	|	""Актив по аренде (ремонтные работы) (03.2)"",
	|	""Дт"",
	|	Ложь,
	|	10
	|ГДЕ
	|	Ложь
	|
	|ОБЪЕДИНИТЬ ВСЕ",
	"ВЫБРАТЬ
	|	""Активы в форме права пользования"",
	|	""Актив по аренде (ремонтные работы) (03.2)"",
	|	""Дт"",
	|	Ложь,
	|	10
	|ГДЕ
	|	&НачалоПериода >= ДАТАВРЕМЯ(2018, 1, 1)
	|
	|ОБЪЕДИНИТЬ ВСЕ");
	
	ТекстЗапроса = СтрЗаменить(ТекстЗапроса,
	"ВЫБРАТЬ
	|	""Активы в форме права пользования"",
	|	""Амортизация (расходы по аренде) (04.1)"",
	|	""Кт"",
	|	Истина,
	|	10
	|ГДЕ
	|	Ложь
	|
	|ОБЪЕДИНИТЬ ВСЕ",
	"ВЫБРАТЬ
	|	""Активы в форме права пользования"",
	|	""Амортизация (расходы по аренде) (04.1)"",
	|	""Кт"",
	|	Истина,
	|	10
	|ГДЕ
	|	&НачалоПериода >= ДАТАВРЕМЯ(2018, 1, 1)
	|
	|ОБЪЕДИНИТЬ ВСЕ");
	
	ТекстЗапроса = СтрЗаменить(ТекстЗапроса,
	"ОБЪЕДИНИТЬ ВСЕ
	|
	|ВЫБРАТЬ
	|	""Активы в форме права пользования"",
	|	""Амортизация (ремонтные работы) (04.2)"",
	|	""Кт"",
	|	Истина,
	|	10
	|ГДЕ
	|	Ложь",
	"ОБЪЕДИНИТЬ ВСЕ
	|
	|ВЫБРАТЬ
	|	""Активы в форме права пользования"",
	|	""Амортизация (ремонтные работы) (04.2)"",
	|	""Кт"",
	|	Истина,
	|	10
	|ГДЕ
	|	&НачалоПериода >= ДАТАВРЕМЯ(2018, 1, 1)");
	
	Возврат ТекстЗапроса;
КонецФункции









