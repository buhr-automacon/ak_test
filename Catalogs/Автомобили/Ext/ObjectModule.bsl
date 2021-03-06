﻿
// Приводит строку гос. номер автомобиля к стандартному виду, заменяя русские буквы на латинские (латинские на русские согласно задаче 2889), удаляя лишние пробелы
//
// Параметры
// 	ТекНомер	- Строка - обрабатываемый гос. номер
// 	ЭтоПрицеп   - Булево - является ли транспортное средство прицепом.
//
// Возвращаемое значение:
// 	Нет
//
Функция глФорматГосНомера(Знач ТекНомер, ЭтоПрицеп = Ложь) Экспорт
                
    ТекНомер = СокрЛП(ТекНомер);
    ТекНомер = СтрЗаменить(ТекНомер, " ", Символы.НПП);
    Если НЕ ЭтоПрицеп Тогда         
		ТекНомер = СтрЗаменить(ТекНомер, Символы.НПП, "");
		ТекНомер = СтрЗаменить(ТекНомер, "-"		, "");
    КонецЕсли;
    ТекНомер = ВРег(ТекНомер);
    
    // замена русских букв на латинские - чтобы исключить дублирование
    Замена = Новый Соответствие;
	//Замена.Вставить("А","A");
	//Замена.Вставить("В","B");
	//Замена.Вставить("Е","E");
	//Замена.Вставить("К","K");
	//Замена.Вставить("М","M");
	//Замена.Вставить("Н","H");
	//Замена.Вставить("О","O");
	//Замена.Вставить("Р","P");
	//Замена.Вставить("С","C");
	//Замена.Вставить("Т","T");
	//Замена.Вставить("Х","X");
	//Замена.Вставить("У","Y");
	//Замена.Вставить("І","I"); // замена спец символа
	
	//Задача 2889. В номере должны быть русские буквы
	Замена.Вставить("A","А");
	Замена.Вставить("B","В");
	Замена.Вставить("E","Е");
	Замена.Вставить("K","К");
	Замена.Вставить("M","М");
	Замена.Вставить("H","Н");
	Замена.Вставить("O","О");
	Замена.Вставить("P","Р");
	Замена.Вставить("C","С");
	Замена.Вставить("T","Т");
	Замена.Вставить("X","Х");
	Замена.Вставить("Y","У");
	
	Замена.Вставить("а","А");
	Замена.Вставить("в","В");
	Замена.Вставить("е","Е");
	Замена.Вставить("к","К");
	Замена.Вставить("м","М");
	Замена.Вставить("н","Н");
	Замена.Вставить("о","О");
	Замена.Вставить("р","Р");
	Замена.Вставить("с","С");
	Замена.Вставить("т","Т");
	Замена.Вставить("х","Х");
	Замена.Вставить("у","У");
	
	Замена.Вставить("a","А");
	Замена.Вставить("b","В");
	Замена.Вставить("e","Е");
	Замена.Вставить("k","К");
	Замена.Вставить("m","М");
	Замена.Вставить("h","Н");
	Замена.Вставить("o","О");
	Замена.Вставить("p","Р");
	Замена.Вставить("c","С");
	Замена.Вставить("t","Т");
	Замена.Вставить("x","Х");
	Замена.Вставить("y","У");
	

    
    НовНомер = "";
    СейчасЦифры = Неопределено;
    Пробел = Ложь;
	ПредыдущийПробел = Ложь;
    Для Пер = 1 По СтрДлина(ТекНомер) Цикл
                   
		ТекСимвол = Сред(ТекНомер, Пер, 1);

		НовСимвол = Замена.Получить(ТекСимвол);
		Если НЕ НовСимвол = Неопределено Тогда
			ТекСимвол = НовСимвол;
		КонецЕсли;

		ЭтоЦифра = (Найти("0123456789", ТекСимвол) > 0);
		Пробел = (ТекСимвол = " ") ИЛИ (ТекСимвол = Символы.НПП);
		Если СейчасЦифры <> Неопределено
				И СейчасЦифры <> ЭтоЦифра
				И НЕ Пробел
				И НЕ ПредыдущийПробел Тогда
			НовНомер = НовНомер + Символы.НПП;
		КонецЕсли;

		Если НЕ Пробел
				ИЛИ НЕ ПредыдущийПробел Тогда 
			НовНомер = НовНомер + ТекСимвол;
		КонецЕсли;

		СейчасЦифры = ЭтоЦифра;
		ПредыдущийПробел = Пробел;
    КонецЦикла;
    
    Возврат НовНомер;
            
КонецФункции
		
Функция ГосНомерНеСоответствуетФормату(ТекНомер)			
	
	НомерСоответствует = Истина;
	Если СтрДлина(ТекНомер) < 11 Тогда
		НомерСоответствует = Ложь;
		ВыводСообщений.ВывестиСообщениеВОкноСообщений("Слишком короткий госномер", СтатусСообщения.Внимание, "Госномер не соотвествует формату", "", Истина);
	КонецЕсли;
	Для Пер = 1 По СтрДлина(ТекНомер) Цикл
		Если (Пер=1)или(Пер=7)или(Пер=8) Тогда// здесь должна быть буква
			ТекСимвол = Сред(ТекНомер, Пер, 1);
			ЭтоВернаяБуква=(Найти("АВЕКМНОРСТУХ",ТекСимвол)>0);
			Если не ЭтоВернаяБуква Тогда
				НомерСоответствует=Ложь;
				ВыводСообщений.ВывестиСообщениеВОкноСообщений("Символ "+Пер+" в строке госномера не соответствует формату. Должна быть буква из (А, В, Е, К, М, Н, О, Р, С, Т, У, Х)", СтатусСообщения.Внимание, "Госномер не соотвествует формату", "", истина);
			КонецЕсли;
		ИначеЕсли	(Пер=2)или(Пер=6)или(Пер=9) Тогда// здесь должен быть пробел
			ТекСимвол = Сред(ТекНомер, Пер, 1);
			Если СокрЛП(ТекСимвол)<>"" Тогда
				НомерСоответствует=Ложь;
				ВыводСообщений.ВывестиСообщениеВОкноСообщений("Символ "+Пер+" в строке госномера не соответствует формату. Должен быть пробел.", СтатусСообщения.Внимание, "Госномер не соотвествует формату", "", истина);
			КонецЕсли;
		ИначеЕсли	(Пер=3)или(Пер=4)или(Пер=5)или(Пер=10)или(Пер=11)или(Пер=12) Тогда// здесь должна быть цифра
			ТекСимвол=Сред(ТекНомер,Пер,1);
			ЭтоЦифра=(Найти("0123456789",ТекСимвол)>0);
			Если НЕ ЭтоЦифра Тогда
				НомерСоответствует=Ложь;
				ВыводСообщений.ВывестиСообщениеВОкноСообщений("Символ "+Пер+" в строке госномера не соответствует формату. Должна быть цифра.", СтатусСообщения.Внимание, "Госномер не соотвествует формату", "", истина);
			КонецЕсли;	
		КонецЕсли;	
	КонецЦикла;	
	
	Возврат НЕ НомерСоответствует;
	
КонецФункции	

Процедура ПередЗаписью(Отказ)
	
	Наименование = глФорматГосНомера(Наименование);
	Отказ = ГосНомерНеСоответствуетФормату(Наименование);
	Если ЭтоНовый()
			И НЕ ОбменДанными.Загрузка Тогда
		УжеЕсть = Справочники.Автомобили.НайтиПоНаименованию(Наименование);
		Если НЕ УжеЕсть.Пустая() Тогда
			ВыводСообщений.ВывестиСообщениеВОкноСообщений("Госномер " + Наименование + " уже используется для другого автомобиля. Госномер неверен.", СтатусСообщения.Внимание, "Госномер не уникален", "", истина);
			Отказ = Истина;
		КонецЕсли;	
	КонецЕсли;
	
КонецПроцедуры
