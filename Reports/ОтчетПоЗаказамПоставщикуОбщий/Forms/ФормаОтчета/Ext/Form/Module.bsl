﻿
&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Отчет.ДнейПродажВГруппировке 	= 7;
	Отчет.ГлубинаАнализа 			= 14;
	
	//+++АК KIRN 2018.08.01  ИП-00012852.07
	Отчет.ИспользоватьНормативныйКвантДляРасчетаПлановогоОстатка = Истина;
	//---АК KIRN 
	
КонецПроцедуры

&НаКлиенте
Процедура ВыводитьТТМиниТТПустоПриИзменении(Элемент)
	
	Если Отчет.ВыводитьТТМиниТТПусто Тогда
		Отчет.ВыводитьТолькоВВ = Ложь;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ВыводитьТолькоВВПриИзменении(Элемент)
	
	Если Отчет.ВыводитьТолькоВВ Тогда
		Отчет.ВыводитьТТМиниТТПусто = Ложь;
	КонецЕсли;
	
КонецПроцедуры


Функция ПолучитьКомпоновщикНастроек()
	
	ОтчетОбъект = ЭтаФорма.РеквизитФормыВЗначение("Отчет");
	
	мСхемаКомпоновки = ОтчетОбъект.ПолучитьМакет(?(Отчет.ВыводитьДополнительныеСтолбцы, "ДопМакет", "Макет"));
	
	мКомпоновщикНастроек = Новый КомпоновщикНастроекКомпоновкиДанных;
	мКомпоновщикНастроек.Инициализировать(Новый ИсточникДоступныхНастроекКомпоновкиДанных(мСхемаКомпоновки));
	мКомпоновщикНастроек.ЗагрузитьНастройки(мСхемаКомпоновки.НастройкиПоУмолчанию);
	
	Возврат мКомпоновщикНастроек;
	
КонецФункции

&НаКлиенте
Процедура ВыводитьДополнительныеСтолбцыПриИзменении(Элемент)

	Отчет.КомпоновщикНастроек = ПолучитьКомпоновщикНастроек();
	
КонецПроцедуры
