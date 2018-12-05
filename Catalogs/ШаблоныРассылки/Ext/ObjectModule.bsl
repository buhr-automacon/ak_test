﻿Перем ТекстПисьма экспорт;
Перем ИмяКомпьютераРедактированияХТМЛТекста экспорт;
Перем ИмяФайлаРедактированияХТМЛТекста экспорт;

// Выполняет формирование картинки скриншота
//

Функция ПолучитьБуферОбмена() Экспорт
	ИмяФайлаКартинки 	= ПолучитьИмяВременногоФайла("jpg");

	Попытка
		ФайлКартинки 		= Новый Файл(ИмяФайлаКартинки);
		ИмяФайлаПрограммы 	= КаталогВременныхФайлов()+"/cbtojpeg.exe";
		ЭтотОбъект.ПолучитьМакет("СШ").Записать(ИмяФайлаПрограммы);
		ЗапуститьПриложение(ИмяФайлаПрограммы+" """+СокрЛП(ФайлКартинки.ПолноеИмя)+"""",,Истина);
	Исключение
	КонецПопытки;
	
	Возврат ИмяФайлаКартинки;
КонецФункции

// ПРОЦЕДУРЫ И ФУНКЦИИ ОБЩЕГО НАЗНАЧЕНИЯ

#Если Клиент Тогда

Функция ЗахватитьТекст() Экспорт
    			
	ИмяСохраненияФайла = ПолучитьИмяВременногоФайла("HTM");
	ТекстовыйДокумент = Новый ТекстовыйДокумент;
	ТекстовыйДокумент.УстановитьТекст(ТекстПисьма);
	Попытка
		ТекстовыйДокумент.Записать(ИмяСохраненияФайла);
	Исключение
		ОбщегоНазначения.СообщитьОбОшибке(ОписаниеОшибки(),, "Не удалось сохранить файл на диск!");
		Возврат Ложь;
	КонецПопытки;
	
	Если НЕ УправлениеЭлектроннойПочтой.ОткрытьФайлДляРедактированияВнешнимХТМЛРедактором(ИмяСохраненияФайла) Тогда
		Файл = Новый Файл(ИмяСохраненияФайла);
		Если Файл.Существует() Тогда
			УдалитьФайлы(ИмяСохраненияФайла);
		КонецЕсли; 
		Возврат Ложь;
	КонецЕсли; 
	
	ИмяФайлаРедактированияХТМЛТекста      = ИмяСохраненияФайла;
	ИмяКомпьютераРедактированияХТМЛТекста = ИмяКомпьютера();
	
	ТекстПисьма = "<HTML><HEAD>
	|<META http-equiv=Content-Type content=""" + "text/html; charset=utf-8""" + ">
	|<META content=""" + "MSHTML 6.00.2800.1458""" + " name=GENERATOR></HEAD>
	|<BODY>
	|<P>Текст данного письма редактируется внешним редактором HTML текстов.</P>
	|<P><A href=""" + "ИмяФайлаРедактированияХТМЛТекста" + """>Перейдите по гиперссылке для начала редактирования.</A></P>
	|<P>(" + ИмяФайлаРедактированияХТМЛТекста + ")</A></P>
	|</BODY></HTML>";
	
	Возврат Истина;
	
КонецФункции

Процедура ОсвободитьТекст() Экспорт

	Если ИмяКомпьютера() <> ИмяКомпьютераРедактированияХТМЛТекста Тогда
		Сообщить("Файл редактируется на копмьютере""" + ИмяКомпьютераРедактированияХТМЛТекста + """" + ". Редактирование на текущем комьютере невозможно.");
		Возврат;
	КонецЕсли;
	
	ТекстовыйДокумент = Новый ТекстовыйДокумент;
	Попытка
		ТекстовыйДокумент.Прочитать(ИмяФайлаРедактированияХТМЛТекста);
	Исключение
		ОбщегоНазначения.СообщитьОбОшибке(ОписаниеОшибки(),, "Файл редактирования не удалось открыть.");
		Возврат;
	КонецПопытки;
	
	ТекстПисьма = ТекстовыйДокумент.ПолучитьТекст();
	
	Если ЗначениеЗаполнено(ИмяФайлаРедактированияХТМЛТекста) Тогда
		Попытка
			УдалитьФайлы(ИмяФайлаРедактированияХТМЛТекста);
		Исключение
		КонецПопытки;
	КонецЕсли; 

	ИмяКомпьютераРедактированияХТМЛТекста = "";
	ИмяФайлаРедактированияХТМЛТекста      = "";

КонецПроцедуры

#КонецЕсли
