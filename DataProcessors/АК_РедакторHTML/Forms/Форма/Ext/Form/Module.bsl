﻿
&НаКлиенте
Перем Документ, Адрес, ПредыдущийРежим;

&НаКлиенте
Перем Эксплорер, КаталогДанных;


&НаСервере
Функция Инициализация(Принудительно = Ложь, КаталогДанных) Экспорт
	
	ДвоичныеДанные = обработки.АК_РедакторHTML.ПолучитьМакет("TinyMCE_zip");
	КаталогДанных = КаталогВременныхФайлов() + "TinyMCE\";
	КаталогСкриптов = КаталогДанных + "tinymce\";
	ФайлАрхива = КаталогДанных + "TinyMCE.zip";
	
	ФайлКаталогСкриптов = Новый Файл(КаталогСкриптов);
	ФайлСкрипта = КаталогСкриптов + "tinyMCE\jscripts\tiny_mce\tiny_mce.js";
	Файл = Новый Файл(ФайлСкрипта);
	Если НЕ Принудительно И ФайлКаталогСкриптов.Существует() И Файл.Существует() Тогда
		Возврат Истина;
	КонецЕсли;
	
	Файл = Новый Файл(КаталогСкриптов);
	Если НЕ Файл.Существует() Тогда
		СоздатьКаталог(КаталогСкриптов);
	КонецЕсли;
	
	Попытка
		ДвоичныеДанные.Записать(ФайлАрхива);
	Исключение
		Сообщить(ОписаниеОшибки(), СтатусСообщения.Информация);
		Возврат Ложь;
	КонецПопытки;
	
	зип = Новый ЧтениеZipФайла(ФайлАрхива);
	зип.ИзвлечьВсе(КаталогСкриптов, РежимВосстановленияПутейФайловZIP.Восстанавливать);
	УдалитьФайлы(ФайлАрхива);
	
	Возврат Истина;
	
КонецФункции


&НаКлиенте
Процедура ПриОткрытии(Отказ)

	//Заголовок= "Введите текст!";
	Список = Элементы.КомандаformatBlock.СписокВыбора;
	Список.Добавить("<p>", "Обычный");
	Список.Добавить("<h1>", "Заголовок 1");
	Список.Добавить("<h2>", "Заголовок 2");
	Список.Добавить("<h3>", "Заголовок 3");
	Список.Добавить("<h4>", "Заголовок 4");
	Список.Добавить("<h5>", "Заголовок 5");
	Список.Добавить("<h6>", "Заголовок 6");
	Список.Добавить("<pre>", "Форматированный");
	Список.Добавить("<address>", "Адрес");
	ТекЭлемент = Список.НайтиПоИдентификатору(0);
	СтилиТекста = ТекЭлемент.Значение;

	// Заполнение списка шрифтов
	Список = Элементы.КомандаFontName.СписокВыбора;
	Список.Добавить("Arial");
	Список.Добавить("Arial Black");
	Список.Добавить("Arial Narrow");
	Список.Добавить("Comic Sans MS");
	Список.Добавить("Courier New");
	Список.Добавить("System");
	Список.Добавить("Tahoma");
	Список.Добавить("Times New Roman");
	Список.Добавить("Verdana");
	Список.Добавить("Wingdings");
	ТекЭлемент = Список.НайтиПоИдентификатору(0);
    ИмяШрифта = ТекЭлемент.Значение;
	
	// Заполнение списка размеров
	Список = Элементы.КомандаFontSize.СписокВыбора;
	Для Ном = 1 По 14 Цикл
		Список.Добавить(Ном);
	КонецЦикла;
	ТекЭлемент = Список.НайтиПоИдентификатору(2);
	РазмерыШрифта = ТекЭлемент.Значение;
	
	Документ = Элементы.ПолеHTMLДокумента.Документ;
	ПредыдущийРежим = Элементы.Редактирование;
	Элементы.Редактирование.Пометка = Истина;
	
	СохранитьКомпонентуНаКлиенте();
	
	
КонецПроцедуры

&НаСервере
Функция ПоказатьТекст(Текст, Редактирование = Ложь, ФайлCSS = Неопределено, Каталог) Экспорт
	
	ТекстНастроек = Обработки.АК_РедакторHTML.ПолучитьМакет("TinyMCE_txt").ПолучитьТекст();
	
	Возврат ТекстНастроек;
	
КонецФункции


&НаКлиенте
Процедура ВставитьКартинкуИзБуфера(Команда)
	
	КодВозврата = Неопределено;
		
	ВремКаталог = КаталогВременныхФайлов();
	ТекДатаСтрока = СтрЗаменить(СтрЗаменить(СтрЗаменить(Формат(ТекущаяДата(), "ДЛФ=DT"), ".", "")," " ,""),":","");
	
	ПолноеИмяФайла = ТекДатаСтрока + (Новый УникальныйИдентификатор) + "_temp_img.jpg";
	КартинкаПуть = ВремКаталог+ПолноеИмяФайла;	
		
	ИмяИспФайла = ВремКаталог+"clipboardtojpg.exe";
		
	ЗапуститьПриложение(ИмяИспФайла +" "+КартинкаПуть, ВремКаталог, Истина, КодВозврата);
	
	ФайлКартинка = Новый Файл(КартинкаПуть);
	Если НЕ ФайлКартинка.Существует() Тогда
		Предупреждение("В буфере нет картинки!");
		Возврат;
	КонецЕсли;
	
	//Документ.execCommand("insertimage", Ложь, КартинкаПуть);	
	Документ.execCommand("insertimage", Ложь, "" + КартинкаПуть + """ style=""width:90%; """);	
	
КонецПроцедуры

&НаКлиенте
Процедура СохранитьКомпонентуНаКлиенте()
	
	ВремКаталог = КаталогВременныхФайлов();
	ИмяИспФайла = ВремКаталог+"clipboardtojpg.exe";
	clipboardtojpg = Новый Файл(ИмяИспФайла);
	Если НЕ clipboardtojpg.Существует() Тогда
		ПолучитьФайл(СохранитьКомпонентуНаСервере(),ИмяИспФайла, Ложь);
	КонецЕсли;
		
КонецПроцедуры

&НаСервере
Функция СохранитьКомпонентуНаСервере()
	
	ИмяВрФ = КаталогВременныхФайлов()+"clipboardtojpg_exe.tmp";
	Обработки.АК_РедакторHTML.ПолучитьМакет("clipboardtojpg_exe").Записать(ИмяВрФ);
	Возврат ПоместитьВоВременноеХранилище(Новый ДвоичныеДанные(ИмяВрФ));
	
КонецФункции

&НаКлиенте
Процедура ВыполнитьКоманду(Кнопка)
	
	Команда = Сред(Кнопка.Имя, 8);
	Если Документ.queryCommandSupported(Команда) Тогда
		//Документ.execCommand(Команда, Ложь);
		ЭтаФорма.Элементы.ПолеHTMLДокумента.Документ.execCommand(Команда, Ложь);
		ПоказатьРежимыКнопок();
		
	КонецЕсли;	
		
КонецПроцедуры

&НаКлиенте
Процедура ПоказатьРежимыКнопок()
	
	Для каждого Группа Из Элементы.КоманднаяПанельКнопок.ПодчиненныеЭлементы Цикл
		Для каждого Кнопка Из Группа.ПодчиненныеЭлементы Цикл
	        Если ТипЗнч(Кнопка) = тип("КнопкаФормы") Тогда
				Команда = Сред(Кнопка.Имя, 8);
				Если ЭтаФорма.Элементы.ПолеHTMLДокумента.Документ.queryCommandSupported(Команда) Тогда
					Попытка
						Кнопка.Пометка = ЭтаФорма.Элементы.ПолеHTMLДокумента.Документ.queryCommandState(Команда);
					Исключение
					КонецПопытки;
				КонецЕсли;
			КонецЕсли;
		КонецЦикла;
	КонецЦикла;
	
КонецПроцедуры

&НаКлиенте
Процедура КоманднаяПанельРежим(Команда)
	
	Кнопка = Элементы.Найти(Команда.Имя);
	Если Кнопка.Пометка Тогда
		Возврат;
	КонецЕсли; 
	
	Элементы.Редактирование.Пометка = Ложь;
	Элементы.Текст.Пометка = Ложь;
	Элементы.Просмотр.Пометка = Ложь;
	Кнопка.Пометка = Истина;
	
	Если Кнопка = Элементы.Текст Тогда
		
		// На некоторых машинах видимо из за настроек безопасности IE раскраска кода не получается
		// Поэтому делаем через попытку
		Попытка 
			sExpression = "
			|document.body.innerText = document.body.innerHTML;
			|document.body.innerHTML = colourCode(document.body.innerHTML);
			|function colourCode(code)
			|{
			|    htmlTag = /(&lt;([\s\S]*?)&gt;)/gi
			|    tableTag = /(&lt;(table|tbody|th|tr|td|\/table|\/tbody|\/th|\/tr|\/td)([\s\S]*?)&gt;)/gi
			|    commentTag = /(&lt;!--([\s\S]*?)&gt;)/gi
			|    imageTag = /(&lt;img([\s\S]*?)&gt;)/gi
			|    linkTag = /(&lt;(a|\/a)([\s\S]*?)&gt;)/gi
			|    scriptTag = /(&lt;(script|\/script)([\s\S]*?)&gt;)/gi
			|    code = code.replace(htmlTag,""<font color=#FF0000>$1</font>"")
			|    code = code.replace(tableTag,""<font color=#008080>$1</font>"")
			|    code = code.replace(commentTag,""<font color=#808080>$1</font>"")
			|    code = code.replace(imageTag,""<font color=#800080>$1</font>"")
			|    code = code.replace(linkTag,""<font color=#008000>$1</font>"")
			|    code = code.replace(scriptTag,""<font color=#800000>$1</font>"")
			|    return code;
			|}";
			Документ.parentWindow.execScript(sExpression);
		
		Исключение
			Документ.Body.InnerText = Документ.Body.InnerHTML;
		КонецПопытки;

	ИначеЕсли ПредыдущийРежим = Элементы.Текст Тогда
		Документ.Body.InnerHTML = Документ.Body.InnerText;
	КонецЕсли;
	
	Если Кнопка = Элементы.Просмотр Тогда
		Документ.Body.ContentEditable = "false";
	Иначе
		Документ.Body.ContentEditable = "true";
	КонецЕсли;

	ДоступностьКнопок = (Кнопка = Элементы.Редактирование);
	Элементы.КомандаFormatBlock.Доступность = ДоступностьКнопок;
	Элементы.КомандаFontName.Доступность = ДоступностьКнопок;
	Элементы.КомандаFontSize.Доступность = ДоступностьКнопок;

	Для каждого Группа Из Элементы.КоманднаяПанельКнопок.ПодчиненныеЭлементы Цикл
		Если Группа.Имя = "ГруппаУправлениеРежимом" Тогда
			УправлятьДоступностью = Ложь;
		Иначе
			УправлятьДоступностью = Истина;
		КонецЕсли;
		
		Для каждого Кн Из Группа.ПодчиненныеЭлементы Цикл
			Если ТипЗнч(Кн) = тип("КнопкаФормы") Тогда
				Если УправлятьДоступностью Тогда
					Кн.Доступность = ДоступностьКнопок
				КонецЕсли; 
			КонецЕсли;
		КонецЦикла;
		
	КонецЦикла; 
	
	ПредыдущийРежим = Кнопка;
	ПоказатьРежимыКнопок();
	
КонецПроцедуры

&НаСервере
Функция ПолучитьОбъектОбработки() Экспорт
	
	оо = РеквизитФормыВЗначение("Объект");
	
	Возврат оо;
	
КонецФункции	

&НаКлиенте
Процедура ПолеHTMLДокументаДокументСформирован(Элемент)
	
	Элемент.Документ.Body.ContentEditable = "true";
	Элемент.Документ.body.scroll = "yes";
	Если СтрДлина(Параметры.текстHTML) > 0 Тогда		
		ЭтаФорма.Элементы.ПолеHTMLДокумента.Документ.Body.innerHTML = Параметры.текстHTML;
	КонецЕсли;
		
	ВремКаталог = КаталогВременныхФайлов();
	лкКартинки = Элемент.Документ.all.tags("img");
		
	Для каждого лкКартинка Из лкКартинки Цикл
         		
		ТекИмяКартинки = Строка(лкКартинка.nameProp);
		ПолныйПутьКартинки = ВремКаталог+ТекИмяКартинки;
		СтарыйПуть = лкКартинка.href;
		
		МассивКартинок = НайтиФайлы(СтарыйПуть, , Ложь); 
				
		Если МассивКартинок.Количество() = 0 Тогда
						
			Попытка			
				ПолучитьФайл(ПолучитьАдресКартинкиНаСервере(ТекИмяКартинки), ПолныйПутьКартинки, Ложь);
				лкКартинка.src = ПолныйПутьКартинки;
			Исключение				
			КонецПопытки;				
				
		КонецЕсли;	
		
	КонецЦикла;
	
	//Если Не Инициализация(Истина,КаталогДанных) Тогда
	//	
	//	Сообщить("Ошибка инициализаци компоненты проверки орфографии. Функция будет недоступна!");
	//	Элементы.ФормаПроверитьОрфографию.Доступность = Ложь;
	//	
	//КонецЕсли;
	//
	//Эксплорер = Элементы.ПолеHTMLДокумента;
	//ТекстНастроек = ПоказатьТекст(Параметры.ТекстHTML, ,,КаталогДанных);
	//Редактирование = Истина; 
	//ФайлCSS = Неопределено;	
	//Т = Новый ТекстовыйДокумент;
	//Т.ДобавитьСтроку("<HTML><HEAD><meta http-equiv=""Content-Type"" content=""text/html; charset=windows-1251"" content=""no-cache"">");
	//Если Редактирование И ЗначениеЗаполнено(ТекстНастроек) Тогда
	//	Т.ДобавитьСтроку("<script type=""text/javascript"" src=""tinyMCE/tinyMCE/jscripts/tiny_mce/tiny_mce.js""></script>");
	//	Т.ДобавитьСтроку(ТекстНастроек);
	//	Т.ДобавитьСтроку("</HEAD><BODY><FONT FACE=""Arial"" SIZE=""-1"">");
	//	Т.ДобавитьСтроку("<form method=""\"" action=""\"" onsubmit=""return false;"">");
	//	Т.ДобавитьСтроку("<textarea id=""elm1"" name=""elm1"" style=""width: 100%;height:100%"">");
	//Иначе
	//	Т.ДобавитьСтроку("</HEAD><BODY><FONT FACE=""Arial"" SIZE=""-1"">");
	//КонецЕсли;
	//
	//Если Редактирование И ЗначениеЗаполнено(ТекстНастроек) Тогда
	//	Т.ДобавитьСтроку("</textarea>");
	//КонецЕсли;
	//
	//Т.ДобавитьСтроку("</FONT></BODY></HTML>");
	//
	//Если ФайлCSS <> Неопределено Тогда
	//	Файл = Новый Файл(ФайлCSS);
	//	Если Файл.Существует() Тогда
	//		КопироватьФайл(ФайлCSS, КаталогДанных + "temp.css");
	//		
	//		ВремТекст = Т.ПолучитьТекст();
	//		ВремТекст = СтрЗаменить(ВремТекст, "[CSS]", КаталогДанных + "temp.css");
	//		Т.УстановитьТекст(ВремТекст);
	//	КонецЕсли;
	//КонецЕсли;
	//		
	//ВремФайл = КаталогДанных + "temp.html";
	//Т.Записать(ВремФайл, КодировкаТекста.ANSI);
	//
	////url=СокрЛП(ВремФайл);
	////Эксплорер.Документ.location.href=url;
	//
	//Если Не ПустаяСтрока(Параметры.текстHTML) Тогда
	//	ПодключитьОбработчикОжидания("УстановитьИпроверитьТекст", 0.1, Истина); 
	//КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура УстановитьИПроверитьТекст() Экспорт

	JScript = "tinyMCE.execCommand('mceInsertContent',false,'"+ИзТекстаВХТМЛ(Эксплорер.Документ.body.innertext)+"');";
    Эксплорер.Документ.parentWindow.ExecScript(JScript,"JavaScript");
    ПроверитьТекст();

КонецПроцедуры

&НаКлиенте
Функция ИзХТМЛВТекст(ТекстХТМЛ)
	//ТУДУ: Переписать на RegExp
	ТекстХТМЛ = СтрЗаменить(ТекстХТМЛ, "<br>", Символы.ПС);
	ТекстХТМЛ = СтрЗаменить(ТекстХТМЛ, "<br />", Символы.ПС);
 	RegExp = Новый COMОбъект("VBScript.RegExp");
    RegExp.IgnoreCase = Ложь; //Игнорировать регистр   
    RegExp.Global = Истина; //Поиск всех вхождений шаблона   
    RegExp.MultiLine = Ложь; //Многострочный режим      
    RegExp.Pattern = "<[^>]*>&>"; //Ищем теги HTML   
    Возврат RegExp.Replace(ТекстХТМЛ, ""); //Заменяем все теги на пустоту	
КонецФункции	

&НаКлиенте
Функция ИзТекстаВХТМЛ(Текст)
    Возврат "<p>"+СтрЗаменить(Текст, Символы.ПС, "<br />")+"</p>";
КонецФункции	
&НаСервере
Функция ПолучитьАдресКартинкиНаСервере(ТекИмяКартинки)
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	ВложенияHTML.ХранилищеФайла,
	|	ВложенияHTML.ИмяФайла
	|ИЗ
	|	РегистрСведений.ВложенияHTML КАК ВложенияHTML
	|ГДЕ
	|	ВложенияHTML.ИмяФайла = &ИмяФайла";
	
	Запрос.УстановитьПараметр("ИмяФайла", ТекИмяКартинки);
	
	РезультатЗапроса = Запрос.Выполнить();
	
	ВыборкаДетальныеЗаписи = РезультатЗапроса.Выбрать();
	
	Пока ВыборкаДетальныеЗаписи.Следующий() Цикл
		
		Возврат ПоместитьВоВременноеХранилище(ВыборкаДетальныеЗаписи.ХранилищеФайла.Получить());
				
	КонецЦикла;
		
КонецФункции	

&НаКлиенте
Процедура ПолеHTMLДокументаПриНажатии(Элемент, ДанныеСобытия, СтандартнаяОбработка)
	
	ПоказатьРежимыКнопок();
	
КонецПроцедуры

&НаКлиенте
Процедура ВыполнитьКомандуСписка(Элемент, ВыбранноеЗначение, СтандартнаяОбработка)
	
	Команда = Сред(Элемент.Имя, 8);
	Если ЭтаФорма.Элементы.ПолеHTMLДокумента.Документ.queryCommandSupported(Команда) Тогда
		Список = Элемент.СписокВыбора;
		ЭтаФорма.Элементы.ПолеHTMLДокумента.Документ.execCommand(Команда, Истина, ВыбранноеЗначение);
		ПоказатьРежимыКнопок();
	КонецЕсли;
	ЭтаФорма.ТекущийЭлемент = Элементы.ПолеHTMLДокумента;
	
КонецПроцедуры

&НаКлиенте
Процедура ВставитьГиперссылку(Команда)
	
	ИмяОткрываемойФормы = Лев(ЭтаФорма.ИмяФормы,СтрДлина(ЭтаФорма.ИмяФормы)-5)+ "ВыборГиперссылки";
	Гиперссылка = ПолучитьФорму(ИмяОткрываемойФормы).ОткрытьМодально();
	Если Гиперссылка <> Неопределено Тогда
		ЭтаФорма.Элементы.ПолеHTMLДокумента.Документ.execCommand("CreateLink", Ложь, Гиперссылка);
	КонецЕсли;
	ПоказатьРежимыКнопок();

КонецПроцедуры

&НаКлиенте
Процедура ВыборЦвета(Команда)
	
	ИмяОткрываемойФормы = Лев(ЭтаФорма.ИмяФормы,СтрДлина(ЭтаФорма.ИмяФормы)-5)+ "ВыборЦвета";
	Цвет = ПолучитьФорму(ИмяОткрываемойФормы).ОткрытьМодально();
	
	Если Цвет <> Неопределено Тогда
		Кнопка = Сред(Команда.Имя, 8);
		Если ЭтаФорма.Элементы.ПолеHTMLДокумента.Документ.queryCommandSupported(Кнопка) Тогда
			ЭтаФорма.Элементы.ПолеHTMLДокумента.Документ.execCommand(Кнопка, Ложь, "" + ПеревестиИз10(Цвет.Красный) + ПеревестиИз10(Цвет.Зеленый) + ПеревестиИз10(Цвет.Синий));
		КонецЕсли;
	КонецЕсли;
	ПоказатьРежимыКнопок();
	
КонецПроцедуры

&НаКлиенте
Функция ПеревестиИз10(Знач Значение = 0) Экспорт
	
	Значение = Число(Значение);
	Если Значение <= 0 Тогда
		Возврат "00";
	КонецЕсли;
	
	Значение = Цел(Значение);
	Результат = "";
	
	Пока Значение > 0 Цикл
		Результат = Сред("0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ",Значение%16+1,1) + Результат;
		Значение = Цел(Значение/16);
	КонецЦикла;
	
	Если СтрДлина(Результат) = 1 Тогда
		Результат = "0" + Результат;
	КонецЕсли; 
  
	Возврат Результат;
	
КонецФункции

&НаКлиенте
Процедура ЗакрытьПоOK(Команда)
	
	Перем АдресКартинкиНаСервере;
	// +++ golv
	//КартинкиВФайлах = АК_КартинкиКлиент.КартинкиВФайлах();
	//ПутьСохраненныхКартинок = АК_КартинкиКлиент.ПолучитьАдресКартинки(АК_КартинкиКлиент.ДобавитьСимволыЗамены(""));
	// --- golv
	ТекстВозврата = Элементы.ПолеHTMLДокумента.Документ.body.innerHTML;	
	//ВремКаталог = КаталогВременныхФайлов();
	//лкКартинки = Элементы.ПолеHTMLДокумента.Документ.all.tags("img");
	//Для каждого лкКартинка Из лкКартинки Цикл
	//	// +++ golv
	//	Если КартинкиВФайлах Тогда
	//		ТекИмяКартинки = Строка(лкКартинка.nameProp);
	//		ТекПутьКартинки = Строка(лкКартинка.src);
	//		ПолныйПутьКартинки = ВремКаталог+ТекИмяКартинки;   
	//		АдресКартинкиНаСервере = "";
	//		//ФайлСохранен = Найти(ТекПутьКартинки, АК_КартинкиКлиент.ПолучитьАдресКартинки(АК_КартинкиКлиент.ДобавитьСимволыЗамены(""))) > 0;
	//		//Если ФайлСохранен Тогда 
	//		//	ПутьКартинкиССимволамиЗамены = АК_КартинкиКлиент.ДобавитьСимволыЗамены(ТекИмяКартинки);
	//		//КонецЕсли;
	//		Если Не ФайлСохранен И ЗначениеЗаполнено(НайтиФайлы(ПолныйПутьКартинки)) Тогда
	//			ПоместитьФайл(АдресКартинкиНаСервере, ПолныйПутьКартинки, , Ложь);
	//			ПутьКартинкиССимволамиЗамены = СохранитьФайлКартинки(ТекИмяКартинки, АдресКартинкиНаСервере);
	//			ФайлСохранен = Истина;
	//		КонецЕсли;
	//		Если ФайлСохранен Тогда
	//			//ПутьКартинкиССимволамиЗамены = СохранитьФайлКартинки(ТекИмяКартинки, АдресКартинкиНаСервере);
	//			ПутьКартинкиВиндовый = СтрЗаменить(СтрЗаменить(ТекПутьКартинки, "file:///", ""), "/", "\");
	//			ТекстВозврата = СтрЗаменить(ТекстВозврата, ТекПутьКартинки, ПутьКартинкиССимволамиЗамены); 
	//			ТекстВозврата = СтрЗаменить(ТекстВозврата, "file:///" + ТекПутьКартинки, ПутьКартинкиССимволамиЗамены);
	//			ТекстВозврата = СтрЗаменить(ТекстВозврата, ПутьКартинкиВиндовый, ПутьКартинкиССимволамиЗамены);
	//		КонецЕсли;
	//	Иначе
	//	// --- golv
	//		АдресКартинкиНаСервере = ""; 		
	//		
	//		ТекИмяКартинки = Строка(лкКартинка.nameProp);
	//		ПолныйПутьКартинки = ВремКаталог+ТекИмяКартинки;
	//		СтарыйПуть = лкКартинка.href;
	//		
	//		МассивКартинок = НайтиФайлы(СтарыйПуть, , Ложь); 
	//		Если МассивКартинок.Количество() = 0 Тогда
	//					
	//			ПоместитьФайл(АдресКартинкиНаСервере, ПолныйПутьКартинки, , Ложь);
	//			ЗаписатьКартинкуВБазу(ТекИмяКартинки, ПолныйПутьКартинки, АдресКартинкиНаСервере, Параметры.Задание);			
	//			
	//		Иначе
	//			ПоместитьФайл(АдресКартинкиНаСервере, СтарыйПуть, , Ложь);
	//			ЗаписатьКартинкуВБазу(ТекИмяКартинки, ПолныйПутьКартинки, АдресКартинкиНаСервере, Параметры.Задание);
	//			
	//		КонецЕсли;
	//	// +++ golv
	//	КонецЕсли;
	//	// --- golv
	//	
	//КонецЦикла;		
	
	
	Если Документ.body.innerHTML <> "" Тогда
		Закрыть(ТекстВозврата);
	Иначе
		Закрыть();
	КонецЕсли;
	
КонецПроцедуры

// +++ golv
&НаСервереБезКонтекста
Функция ПолучитьКонстантуКартинки()
	Возврат Константы.АК_КартинкиНеВБазе.Получить();
КонецФункции

&НаСервереБезКонтекста
Функция СохранитьФайлКартинки(ИмяКартинки, АдресКартинкиНаСервере)
//	Если ЗначениеЗаполнено(АдресКартинкиНаСервере) Тогда
//		ПутьКартинки = АК_КартинкиВызовСервера.ПолучитьАдресФайла(ИмяКартинки);
//		Если НЕ ЗначениеЗаполнено(НайтиФайлы(ПутьКартинки)) Тогда
//			МояКартинка = ПолучитьИзВременногоХранилища(АдресКартинкиНаСервере);
//			МояКартинка.Записать(ПутьКартинки);
//		КонецЕсли;
//	КонецЕсли;
	Возврат "";//АК_КартинкиВызовСервера.ДобавитьСимволыЗамены(ИмяКартинки);
КонецФункции
// --- golv

&НаСервереБезКонтекста
Процедура ЗаписатьКартинкуВБазу(ПолноеИмяФайла, КартинкаПуть, АдресКартинкиНаСервере,  Задание = Неопределено)
	
	лкМенеджер = РегистрыСведений.ВложенияHTML.СоздатьМенеджерЗаписи();
	лкМенеджер.ИмяФайла = ПолноеИмяФайла;
	лкМенеджер.Прочитать();
	
	Если НЕ лкМенеджер.Выбран() Тогда
		
		МояКартинка = ПолучитьИзВременногоХранилища(АдресКартинкиНаСервере);
		
		лкМенеджер.ИмяФайла = ПолноеИмяФайла;
		лкМенеджер.ХранилищеФайла = Новый ХранилищеЗначения(МояКартинка, Новый СжатиеДанных(9));
		лкМенеджер.Записать();
		
	КонецЕсли;	
	
	//Если не ЗначениеЗаполнено(Задание) Тогда
	//
	//	Возврат;
	//
	//КонецЕсли; 
	
	//Запрос = Новый Запрос;
	//Запрос.Текст = "ВЫБРАТЬ РАЗРЕШЕННЫЕ
	//			   |	ВложенияЭлектронныхПисем.Ссылка
	//			   |ИЗ
	//			   |	Справочник.ВложенияЭлектронныхПисем КАК ВложенияЭлектронныхПисем
	//			   |ГДЕ
	//			   |	ВложенияЭлектронныхПисем.ИДФайлаПочтовогоПисьма = &ИДФайлаПочтовогоПисьма
	//			   |	И ВложенияЭлектронныхПисем.ЗаданиеРезультата = &ЗаданиеРезультата";
	//
	//Запрос.УстановитьПараметр("ИДФайлаПочтовогоПисьма", КартинкаПуть);
	//Запрос.УстановитьПараметр("ЗаданиеРезультата", Задание);
	//
	//РезультатЗапроса = Запрос.Выполнить().Выгрузить();
	//
	//Если Не РезультатЗапроса.Количество() Тогда
	//
	//	НовоеВложение = Справочники.ВложенияЭлектронныхПисем.СоздатьЭлемент();
	//	НовоеВложение.ИДФайлаПочтовогоПисьма = КартинкаПуть;
	//	НовоеВложение.Хранилище = Новый ХранилищеЗначения(Новый Картинка(КартинкаПуть));
	//	НовоеВложение.ЗаданиеРезультата = Задание;
	//	НовоеВложение.Записать();
	//	
	//Иначе
	//															 
	//	НовоеВложение = РезультатЗапроса[0].Ссылка.ПолучитьОбъект();
	//	НовоеВложение.ИДФайлаПочтовогоПисьма = КартинкаПуть;
	//	НовоеВложение.Хранилище = Новый ХранилищеЗначения(Новый Картинка(КартинкаПуть));
	//	НовоеВложение.ЗаданиеРезультата = Задание;
	//	НовоеВложение.Записать();
	//	
	//КонецЕсли; 
	
КонецПроцедуры

&НаКлиенте
Процедура ПроверитьОрфографию(Команда)
	
	ПроверитьТекст();	
	
КонецПроцедуры

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	Если Параметры.Свойство("ТекстПисьма1") Тогда
		
		Объект.ТекстHTML = Параметры.ТекстПисьма1 ;
		
	КонецЕсли;	
КонецПроцедуры

&НаКлиенте
Процедура ПроверитьТекст() Экспорт
    
    Элементы.ПолеHTMLДокумента.Документ.parentWindow.ExecScript("tinyMCE.execCommand('mceSave')","JavaScript");
	Элементы.ПолеHTMLДокумента.Документ.parentWindow.ExecScript("tinyMCE.execCommand('mceSpellCheck')","JavaScript");

КонецПроцедуры

&НаКлиенте
Процедура проверка(Команда)
	
	//ТекстВозврата = Элементы.ПолеHTMLДокумента.Документ.all.item().outertext();
	ТекстВозврата = Элементы.ПолеHTMLДокумента.Документ.body.innerhtml;
	//текст = ИзХТМЛВТекст(ТекстВозврата);
	//Текст = СтрЗаменить(текст, "<P>","");
	//Текст = СтрЗаменить(текст, "</P>", Символы.ПС);
	//Текст = СтрЗаменить(текст, ">", "");
	
	Если ТекущийРежимЗапуска() = РежимЗапускаКлиентскогоПриложения.УправляемоеПриложение Тогда
	
		правильныйтекст = проверканаклиенте(ТекстВозврата);
		
	Иначе	
		
		правильныйтекст = проверканасервереклиенте(ТекстВозврата);
		
	КонецЕсли;	
	//
	Попытка
	
		Если ЗначениеЗаполнено(правильныйтекст) Тогда
		
			Элементы.ПолеHTMLДокумента.Документ.body.innerHTML = правильныйтекст;
			
		КонецЕсли;	
		
		
	Исключение
	КонецПопытки;	

КонецПроцедуры

&НаКлиенте 
функция проверканасервереклиенте(текст)
	
	параметры1 = Новый Структура;
	Параметры1.Вставить("ТекстХТМЛ", текст);
		
	Возврат  ОткрытьФормуМодально("Обработка.SpellChecker1С.Форма.Форма1", Параметры1, ЭтаФорма);

конецфункции	

&НаКлиенте 
функция проверканаклиенте(текст)
	
	параметры1 = Новый Структура;
	Параметры1.Вставить("ТекстХТМЛ", текст);
	
		//лкФорма = ПолучитьФорму("Обработка.SpellChecker1С.Форма.Форма2");
		//лкФорма.Параметры.ТекстХТМЛ = текст;
		////лкФорма.Заголовок = "Содержание (подробно)";
		//Возврат  лкФорма.ОткрытьМодально();
	
	
	Возврат  ОткрытьФормуМодально("Обработка.SpellChecker1С.Форма.Форма1", Параметры1, ЭтаФорма);
	
конецфункции	
