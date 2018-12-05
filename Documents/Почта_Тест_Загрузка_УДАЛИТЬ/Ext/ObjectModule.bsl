﻿
Процедура ОбработкаПроведения(Отказ, РежимПроведения)
	// Вставить содержимое обработчика.
	ПолучитьПочтуСФильтрами(ДатаПолучения, ПоДню, НеПолучатьПочту);
	//РегламентныеЗаданияСервер.ПолучитьСообщенияСПочтовогоЯщика(ДатаПолучения, ПолучитьУчетнуюЗаписьПоАдресу("vkusvill@it-stuff.ru"), ПоДням);
КонецПроцедуры

Процедура ПолучитьПочтуСФильтрами(ДатаПолучения, ПоДням, НеПолучатьПочту) Экспорт
	УправлениеЭлектроннойПочтойРегламент.ПолучитьСообщенияСПочтовогоЯщика(ДатаПолучения, ПоДням, НеПолучатьПочту);
	 //ПолучитьСообщенияСПочтовогоЯщика(ДатаПолучения = Неопределено, ПоДню = Ложь, НеПолучатьПочту = Ложь)
КонецПроцедуры

Функция ПолучитьСообщенияСПочтовогоЯщика(ДатаПолучения = Неопределено, УчетнаяЗаписьЭлектроннойПочты, ПоДню, НеПолучатьПочту) Экспорт
	Если НЕ НеПолучатьПочту Тогда
	Почта 						= Новый ИнтернетПочта;
	Профиль 					= Новый ИнтернетПочтовыйПрофиль;
	Профиль.Пользователь 		= УчетнаяЗаписьЭлектроннойПочты.Логин;
	Профиль.ПользовательSMTP 	= УчетнаяЗаписьЭлектроннойПочты.Логин;
	Профиль.ПользовательIMAP 	= УчетнаяЗаписьЭлектроннойПочты.Логин;
	Профиль.Пароль 				= УчетнаяЗаписьЭлектроннойПочты.Пароль;
	Профиль.ПарольSMTP 			= УчетнаяЗаписьЭлектроннойПочты.Пароль;
	Профиль.ПарольIMAP 			= УчетнаяЗаписьЭлектроннойПочты.Пароль;
	Профиль.ПарольIMAP 			= УчетнаяЗаписьЭлектроннойПочты.Пароль;
	Профиль.ПортIMAP 			= УчетнаяЗаписьЭлектроннойПочты.ПортPOP3;
	Профиль.ПортPOP3 			= УчетнаяЗаписьЭлектроннойПочты.ПортPOP3;
	Профиль.АутентификацияSMTP = СпособSMTPАутентификации.БезАутентификации;
	ФорматированныйДокумент 	= Новый ФорматированныйДокумент;
	КартинкиФорматДок 			= Новый Структура();
	//------------------------------------------------------------------------
	Профиль.Пользователь 		= "vkusvill@it-stuff.ru";
	Профиль.ПользовательSMTP 	= "vkusvill@it-stuff.ru";
	Профиль.ПользовательIMAP 	= "vkusvill@it-stuff.ru";
	Профиль.Пароль 				= "s539Ti11";
	Профиль.ПарольSMTP 			= "s539Ti11";
	Профиль.ПарольIMAP 			= "s539Ti11";
	Профиль.ПортIMAP 			= 993;
	Профиль.ИспользоватьSSLIMAP = Истина;
	Профиль.Таймаут 			= 1000;
	Профиль.АдресСервераIMAP 	= "imap.gmail.com";
	Почта.Подключиться(Профиль, ПротоколИнтернетПочты.IMAP);
	Попытка
		НужныйЗаголовок 		= "RVV823_";
		
		Если НЕ ПоДню Тогда
			ДатаПоследнегоПисьма = ДатаПолучения - 60*60*24;
			МассивЗаголовковПисем = Почта.ПолучитьЗаголовки(Новый Структура("ПослеДатыОтправления", ДатаПоследнегоПисьма));
		Иначе
			ДатаПоследнегоПисьма = ДатаПолучения;
			МассивЗаголовковПисем = Почта.ПолучитьЗаголовки(Новый Структура("ДатаОтправления", ДатаПоследнегоПисьма));
		КонецЕсли;
		//МассивЗаголовковПисем = Почта.ПолучитьЗаголовки();
		МассивЗаголовковДляЗагрузки = Новый Массив;
		Если МассивЗаголовковПисем.Количество() = 0 Тогда
			Почта.Отключиться();
			Возврат 0;
		КонецЕсли;
		Для Каждого Строка ИЗ МассивЗаголовковПисем Цикл
			Если СтрЧислоВхождений(Строка.Тема, НужныйЗаголовок) > 0 Тогда
				МассивЗаголовковДляЗагрузки.Добавить(Строка);
			КонецЕсли;
		КонецЦикла;
		Письма = Почта.Выбрать(Ложь, МассивЗаголовковПисем, Истина);
		
		КвоЗаписей = Письма.ВГраница();                          
		Если КвоЗаписей = -1 Тогда 
			Возврат 0; 
		КонецЕсли;
		
		//Загружено = 0;
		
		Для Сч = 0 По КвоЗаписей Цикл
			Письмо 								= Письма[КвоЗаписей - Сч];
			ТемаПисьма 							= Письмо.Тема;
			
			//Если СтрЧислоВхождений(ТемаПисьма, НужныйЗаголовок) = 0 Тогда
			//	//Продолжить;
			//КонецЕсли;
			
			REF_ = "";
			MID = "";
			IRT = "";
			
			
			Если Найти(Письмо.Заголовок, "References") > 0 Тогда
				REF_ = Сред(Письмо.Заголовок, Найти(Письмо.Заголовок, "References") + 13, 36);
			Иначе
				REF_ = "";
			КонецЕсли;
			Если Найти(Письмо.Заголовок, "Message-Id") > 0 Тогда
				MID = Сред(Письмо.Заголовок, Найти(Письмо.Заголовок, "Message-Id") + 13, 36);
			Иначе
				MID = "";
			КонецЕсли;
			Если Найти(Письмо.Заголовок, "In-Reply-To") > 0 Тогда	
				IRT = Сред(Письмо.Заголовок, Найти(Письмо.Заголовок, "In-Reply-To") + 14, 36);
			Иначе
				IRT = "";
			КонецЕсли;
			
			//ИдентификаторСообщения 				= Письмо.ИдентификаторСообщения;
			//
			//Если ИдентификаторСообщения <> "BD748847-9A5C-4EC0-B0E9-2BD35295B82F@yandex.ru" Тогда
			//	Продолжить;
			//КонецЕсли;
			
			//ОтправительПисьма 					= Письмо.Отправитель;
			//ДатаПисьма 							= Письмо.ДатаОтправления;
			
			//Поз									= Найти(СокрЛП(ТемаПисьма), "rtrim(@");
			//ЧастьДоЕмЮид 						= Лев(ТемаПисьма, (Поз +6));
			//Остаток								= СтрЗаменить(ТемаПисьма, ЧастьДоЕмЮид, "");
			//Поз									= Найти(СокрЛП(Остаток), "_");
			//ЧастьДо_	 						= Лев(Остаток, Поз);
			//Остаток_							= СтрЗаменить(Остаток, ЧастьДо_, "");
			//Поз									= Найти(СокрЛП(Остаток_), "#");
			//ЧастьДоР	 						= Лев(Остаток_, Поз -1);
			//UID 								= ЧастьДоР;
			
			
			ТекстПисьмаПростой 					= "";
			Для Каждого ТекстПисьма Из Письмо.Тексты Цикл
				Если ТекстПисьма.ТипТекста 		= ТипТекстаПочтовогоСообщения.ПростойТекст Тогда
					ТекстПисьмаПростой 			= СокрЛП(ТекстПисьма.Текст);
					Прервать;
				ИначеЕсли ТекстПисьма.ТипТекста = ТипТекстаПочтовогоСообщения.HTML Тогда
					ФорматированныйДокумент.УстановитьHTML(ТекстПисьма.Текст, КартинкиФорматДок);
					ТекстПисьмаПростой 			= СокрЛП(ФорматированныйДокумент.ПолучитьТекст());
					Прервать;
				КонецЕсли;
			КонецЦикла;  
			
			
			
			
			
			//Сообщить(ТекстПисьмаПростой);
			Отправка = Ложь;
			Отправка = Истина;
			Если Отправка Тогда
				//email_uid 						= UID;
				//date_email 						= ДатаПисьма;
				//email_from						= ОтправительПисьма.Адрес;
				//text_email						= ТекстПисьмаПростой;
				//
				//
				//
				//Сообщить(email_uid);
				//Сообщить(date_email);
				//Сообщить(email_from);
				////Сообщить(text_email);
				//Сообщить(ИдентификаторСообщения);
				//Сообщить(ТемаПисьма);
				//Сообщить("-------------------------");
				
				
				////Сообщить(text_email);
				//		ДобавитьСтрокуПисьмоВSQL_(email_uid, date_email, email_from, text_email, ТемаПисьма);
				//Отчет_823 = Ложь;
				//Если СтрЧислоВхождений(ТемаПисьма, НужныйЗаголовок) = 0 Тогда
				//	//Продолжить;
				//	Отчет_823 = Истина;
				//КонецЕсли;
				
								
				//Если СтрЧислоВхождений(ТемаПисьма, НужныйЗаголовок) <> 0 Тогда
				//	//Продолжить;
				//	Отчет_823 = Истина;
				//	Строка.ID_Отчета = 823;
				//Иначе
				//	Строка.ID_Отчета = 0;
				//КонецЕсли;
				
				//Поз_823 = Найти(ТемаПисьма, "#RVV823_");
				
				//НужныйЗаголовок 		= "RVV823_";

				//Строка.UID = Сред(Строка.ТемаПисьма, Поз_823 + 8, 36);

				
				
				

				
				//Попытка
				//	МенеджерЗаписи 							= РегистрыСведений.ЛогиПисемGMAILУДАЛИТЬ.СоздатьМенеджерЗаписи();
				//	МенеджерЗаписи.GUID_Загрузки 			= MID;
				//	//МенеджерЗаписи.REF_ 						= REF_;
				//	МенеджерЗаписи.IRT 						= IRT;
				//	МенеджерЗаписи.MID 						= MID;
				//	МенеджерЗаписи.ДатаОтправки 			= ДатаПисьма;
				//	
				//	МенеджерЗаписи.ИдентификаторСообщения 	= ИдентификаторСообщения;
				//	
				//	МенеджерЗаписи.ДатаПолучения 			= ТекущаяДата();
				//	МенеджерЗаписи.email_uid 				= email_uid;
				//	МенеджерЗаписи.ДатаПолучения 			= date_email;
				//	МенеджерЗаписи.email_from 				= email_from;
				//	МенеджерЗаписи.text_email 				= text_email;
				//	МенеджерЗаписи.ТемаПисьма 				= ТемаПисьма;
				//	
				//	Если СтрЧислоВхождений(ТемаПисьма, НужныйЗаголовок) <> 0 Тогда
				//		Отчет_823 = Истина;
				//		МенеджерЗаписи.ID_Отчета = 823;
				//		МенеджерЗаписи.UID = Сред(ТемаПисьма, Поз_823 + 8, 36);
				//	Иначе
				//		МенеджерЗаписи.ID_Отчета = 0;
				//	КонецЕсли;

				//Исключение
				//	Сообщить(ОписаниеОшибки());
				//	//Сообщить(
				//КонецПопытки;
				НужныйЗаголовок_1 		= "RVV823_";
				НужныйЗаголовок_2 		= "RVV829_";

				Поз_823 = Найти(Письмо.Тема, "#RVV823_");
				Поз_829 = Найти(Письмо.Тема, "#RVV829_");
				
				
				НужныйЗаголовок_1 		= "RVV823_";
				НужныйЗаголовок_2 		= "RVV829_";

				Поз_823 = Найти(Письмо.Тема, "#RVV823_");
				Поз_829 = Найти(Письмо.Тема, "#RVV829_");

				
				
				Попытка
					МенеджерЗаписи 							= РегистрыСведений.ЛогиПисемGMAIL.СоздатьМенеджерЗаписи();
					МенеджерЗаписи.GUID_Загрузки 			= MID;
					//МенеджерЗаписи.REF_ 						= REF_;
					МенеджерЗаписи.IRT 						= IRT;
					МенеджерЗаписи.MID 						= MID;
					МенеджерЗаписи.ДатаОтправки 			= Письмо.ДатаОтправления;
					МенеджерЗаписи.ИдентификаторСообщения 	= Письмо.ИдентификаторСообщения;
					МенеджерЗаписи.ДатаПолучения 			= ТекущаяДата();
					МенеджерЗаписи.email 					= Письмо.Отправитель.Адрес;
					МенеджерЗаписи.text_email	 			= ТекстПисьмаПростой;
					МенеджерЗаписи.ТемаПисьма				= Письмо.Тема;
					МенеджерЗаписи. Заархивировано			= Ложь;
					//МенеджерЗаписи.UID   					= UID;
					//МенеджерЗаписи.ID_Отчета				= Число(?(Отчет_823, 823, 0));
					
					Если СтрЧислоВхождений(Письмо.Тема, НужныйЗаголовок_1) <> 0 Тогда
						Отчет_823 = Истина;
						МенеджерЗаписи.ID_Отчета = 823;
						МенеджерЗаписи.UID = Сред(Письмо.Тема, Поз_823 + 8, 36);
					ИначеЕсли СтрЧислоВхождений(Письмо.Тема, НужныйЗаголовок_2) <> 0 Тогда
						Отчет_829 = Истина;
						МенеджерЗаписи.ID_Отчета = 829;
						МенеджерЗаписи.UID = Сред(Письмо.Тема, Поз_829 + 8, 36);
					Иначе
						МенеджерЗаписи.ID_Отчета = 0;
					КонецЕсли;

					
					МенеджерЗаписи.Записать();
				Исключение
					Сообщить(ОписаниеОшибки());
				КонецПопытки;
				
			КонецЕсли;
			//Загружено = Загружено + 1;
			//Если Загружено = 5 Тогда
			//	//Прервать;
			//КонецЕсли;
		КонецЦикла;
	Исключение
		Сообщить(ОписаниеОшибки());
		ТекстОшибки = "Не удалось прочитать заголовки писем. Ошибка: " + ОписаниеОшибки();
		Сообщить(ТекстОшибки);
	КонецПопытки;
	Почта.Отключиться();
	КонецЕсли;
	//Обновление_SQL()
	Insert_or_UpdateНажатие(Неопределено);
КонецФункции // ()

Процедура Insert_or_UpdateНажатие(Чтото) Экспорт 
		//{{КОНСТРУКТОР_ЗАПРОСА_С_ОБРАБОТКОЙ_РЕЗУЛЬТАТА
	// Данный фрагмент построен конструктором.
	// При повторном использовании конструктора, внесенные вручную изменения будут утеряны!!!
	Сообщить("Insert_or_UpdateНажатие");

	
	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ
		|	ЛогиПисемGMAIL.ИдентификаторСообщения,
		|	ЛогиПисемGMAIL.email,
		|	ЛогиПисемGMAIL.ДатаОтвета,
		|	ЛогиПисемGMAIL.GUID_Связи,
		|	ЛогиПисемGMAIL.UIDTelegram,
		|	ЛогиПисемGMAIL.REF,
		|	ЛогиПисемGMAIL.MID,
		|	ЛогиПисемGMAIL.IRT,
		|	ЛогиПисемGMAIL.Отработано,
		|	ЛогиПисемGMAIL.Акцептировано,
		|	ЛогиПисемGMAIL.Отклонено,
		|	ЛогиПисемGMAIL.ИдентификаторЗаявки,
		|	ЛогиПисемGMAIL.ОтправленаНаАкцепт,
		|	ЛогиПисемGMAIL.ТипЗаявки,
		|	ЛогиПисемGMAIL.UID,
		|	ЛогиПисемGMAIL.text_email,
		|	ЛогиПисемGMAIL.ТемаПисьма,
		|	ЛогиПисемGMAIL.ДатаПолучения,
		|	ЛогиПисемGMAIL.GUID_Заявки,
		|	ЛогиПисемGMAIL.Акцептант,
		|	ЛогиПисемGMAIL.ЗаявкаНаУслугиМатериалы,
		|	ЛогиПисемGMAIL.ДатаОтправки,
		|	ЛогиПисемGMAIL.GUID_Загрузки,
		|	ЛогиПисемGMAIL.id_OK,
		|	ЛогиПисемGMAIL.ID_Отчета
		|ИЗ
		|	РегистрСведений.ЛогиПисемGMAIL КАК ЛогиПисемGMAIL
		|ГДЕ
		|	НЕ ЛогиПисемGMAIL.Заархивировано
		|	И (ЛогиПисемGMAIL.ID_Отчета = 823 ИЛИ ЛогиПисемGMAIL.ID_Отчета = 829)";
	
	Запрос.УстановитьПараметр("ДатаПолучения", НачалоДня(ТекущаяДата()) - 60 * 60 * 24 * 10);
	
	РезультатЗапроса = Запрос.Выполнить();
	
	
	
	ВыборкаДетальныеЗаписи = РезультатЗапроса.Выбрать();
	
	мСоединение = АДОКоннекшн_СоздатьОбъект();
	Если 0 = АДОДБ_УстановитьСоединение(мСоединение) Тогда
       	Сообщить("Не удалось подключиться...", 30);
	  Возврат;
  КонецЕсли; 
  
  Кол = ВыборкаДетальныеЗаписи.Количество();
	
	Пока ВыборкаДетальныеЗаписи.Следующий() Цикл
		// Вставить обработку выборки ВыборкаДетальныеЗаписи
		Состояние(Кол);
		Кол = Кол -1;
	
	
	//}}КОНСТРУКТОР_ЗАПРОСА_С_ОБРАБОТКОЙ_РЕЗУЛЬТАТА

	email_uid 	= ВыборкаДетальныеЗаписи.UID; //"11111111-1111-1111-1111-111111111111";
	date_email	= ВыборкаДетальныеЗаписи.ДатаОтправки; //ТекущаяДата();
	email_from	= ВыборкаДетальныеЗаписи.email; //"Адрес";
	text_email	= ВыборкаДетальныеЗаписи.text_email; //"ТекстПисьмаПростой";
	text_email 			= СтрЗаменить(text_email, "'", "");
	subject		= ВыборкаДетальныеЗаписи.ТемаПисьма; //"subject";
	subject 			= СтрЗаменить(subject, "'", "");

	guid_gmail	= ВыборкаДетальныеЗаписи.ИдентификаторСообщения; //"MID";
	   
   Попытка
		rs = мСоединение.Execute("exec SMS_REPL..List_answer_emails_insert_or_update @email_uid ="
		+ ФорматПоля(email_uid) 
		+ ", @date_email = " 
		+ ФорматПоля(date_email)
		+ ", @email_from = " 
		+ ФорматПоля(email_from)
		+ ", @text_email = " 
		+ ФорматПоля(text_email)
		+ ", @subject = " 
		+ ФорматПоля(subject)
		+ ", @gui_gmail = " 
		+ ФорматПоля(guid_gmail)
		);
		МенеджерЗаписи = РегистрыСведений.ЛогиПисемGMAIL.СоздатьМенеджерЗаписи();
		МенеджерЗаписи.ИдентификаторСообщения = ВыборкаДетальныеЗаписи.ИдентификаторСообщения;
		МенеджерЗаписи.Прочитать();
		МенеджерЗаписи.Заархивировано = Истина;
		МенеджерЗаписи.ТекстПисьма = Новый ХранилищеЗначения(МенеджерЗаписи.text_email, Новый СжатиеДанных(9));
		МенеджерЗаписи.text_email = "";
		МенеджерЗаписи.Записать();
		МенеджерЗаписи = Неопределено;
	Исключение
		Сообщить("exec SMS_REPL..List_answer_emails_insert_or_update @email_uid ="
		+ ФорматПоля(email_uid) 
		+ ", @date_email = " 
		+ ФорматПоля(date_email)
		+ ", @email_from = " 
		+ ФорматПоля(email_from)
		+ ", @text_email = " 
		+ ФорматПоля(text_email)
		+ ", @subject = " 
		+ ФорматПоля(subject)
		+ ", @gui_gmail = " 
		+ ФорматПоля(guid_gmail)
		);
		Сообщить(ОписаниеОшибки());
		//мСоединение.Close();
			КонецПопытки;
	КонецЦикла;
	ОБщегоНазначения.СообщитьОбОшибке("Операция завершена успешно.", , , СтатусСообщения.Информация);
	мСоединение.Close();
	
	Возврат;

	
	Запрос.Текст = 
		"ВЫБРАТЬ
		|	ЛогиПисемGMAIL.ИдентификаторСообщения,
		|	ЛогиПисемGMAIL.email,
		|	ЛогиПисемGMAIL.ДатаОтвета,
		|	ЛогиПисемGMAIL.GUID_Связи,
		|	ЛогиПисемGMAIL.UIDTelegram,
		|	ЛогиПисемGMAIL.REF,
		|	ЛогиПисемGMAIL.MID,
		|	ЛогиПисемGMAIL.IRT,
		|	ЛогиПисемGMAIL.Отработано,
		|	ЛогиПисемGMAIL.Акцептировано,
		|	ЛогиПисемGMAIL.Отклонено,
		|	ЛогиПисемGMAIL.ИдентификаторЗаявки,
		|	ЛогиПисемGMAIL.ОтправленаНаАкцепт,
		|	ЛогиПисемGMAIL.ТипЗаявки,
		|	ЛогиПисемGMAIL.UID,
		|	ЛогиПисемGMAIL.text_email,
		|	ЛогиПисемGMAIL.ТемаПисьма,
		|	ЛогиПисемGMAIL.ДатаПолучения,
		|	ЛогиПисемGMAIL.GUID_Заявки,
		|	ЛогиПисемGMAIL.Акцептант,
		|	ЛогиПисемGMAIL.ЗаявкаНаУслугиМатериалы,
		|	ЛогиПисемGMAIL.ДатаОтправки,
		|	ЛогиПисемGMAIL.GUID_Загрузки,
		|	ЛогиПисемGMAIL.id_OK,
		|	ЛогиПисемGMAIL.ID_Отчета
		|ИЗ
		|	РегистрСведений.ЛогиПисемGMAIL КАК ЛогиПисемGMAIL
		|ГДЕ
		|	НЕ ЛогиПисемGMAIL.Заархивировано
		|	И ЛогиПисемGMAIL.ID_Отчета <> 829 И ЛогиПисемGMAIL.ID_Отчета <> 823";
	
	Запрос.УстановитьПараметр("ДатаПолучения", НачалоДня(ТекущаяДата()) - 60 * 60 * 24 * 5);
	
	РезультатЗапроса = Запрос.Выполнить();
	
	
	
	ВыборкаДетальныеЗаписи = РезультатЗапроса.Выбрать();
	
	мСоединение = АДОКоннекшн_СоздатьОбъект();
	Если 0 = АДОДБ_УстановитьСоединение(мСоединение) Тогда
       	Сообщить("Не удалось подключиться...", 30);
	  Возврат;
  КонецЕсли; 
  
  Кол = ВыборкаДетальныеЗаписи.Количество();
	
	Пока ВыборкаДетальныеЗаписи.Следующий() Цикл
		// Вставить обработку выборки ВыборкаДетальныеЗаписи
		Состояние(Кол);
		Кол = Кол -1;
	
	
	//}}КОНСТРУКТОР_ЗАПРОСА_С_ОБРАБОТКОЙ_РЕЗУЛЬТАТА

	email_uid 	= ВыборкаДетальныеЗаписи.UID; //"11111111-1111-1111-1111-111111111111";
	date_email	= ВыборкаДетальныеЗаписи.ДатаПолучения; //ТекущаяДата();
	email_from	= ВыборкаДетальныеЗаписи.email; //"Адрес";
	text_email	= ВыборкаДетальныеЗаписи.text_email; //"ТекстПисьмаПростой";
	subject		= ВыборкаДетальныеЗаписи.ТемаПисьма; //"subject";
	guid_gmail	= ВыборкаДетальныеЗаписи.ИдентификаторСообщения; //"MID";
	   
   //Попытка
   // 	rs = мСоединение.Execute("exec SMS_REPL..List_answer_emails_insert_or_update @email_uid ="
   // 	+ ФорматПоля(email_uid) 
   // 	+ ", @date_email = " 
   // 	+ ФорматПоля(date_email)
   // 	+ ", @email_from = " 
   // 	+ ФорматПоля(email_from)
   // 	+ ", @text_email = " 
   // 	+ ФорматПоля(text_email)
   // 	+ ", @subject = " 
   // 	+ ФорматПоля(subject)
   // 	+ ", @gui_gmail = " 
   // 	+ ФорматПоля(guid_gmail)
   // 	);
		МенеджерЗаписи = РегистрыСведений.ЛогиПисемGMAIL.СоздатьМенеджерЗаписи();
		МенеджерЗаписи.ИдентификаторСообщения = ВыборкаДетальныеЗаписи.ИдентификаторСообщения;
		МенеджерЗаписи.Прочитать();
		МенеджерЗаписи.Заархивировано = Истина;
		МенеджерЗаписи.ТекстПисьма = Новый ХранилищеЗначения(МенеджерЗаписи.text_email, Новый СжатиеДанных(9));
		МенеджерЗаписи.text_email = "";
		МенеджерЗаписи.Записать();
		МенеджерЗаписи = Неопределено;
	
КонецЦикла;	
	
	
КонецПроцедуры

Процедура Обновление_SQL()
	//{{КОНСТРУКТОР_ЗАПРОСА_С_ОБРАБОТКОЙ_РЕЗУЛЬТАТА
	// Данный фрагмент построен конструктором.
	// При повторном использовании конструктора, внесенные вручную изменения будут утеряны!!!
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	ЛогиПисемGMAIL.id_OK,
	|	ЛогиПисемGMAIL.GUID_Загрузки,
	|	ЛогиПисемGMAIL.ДатаОтправки,
	|	ЛогиПисемGMAIL.ЗаявкаНаУслугиМатериалы,
	|	ЛогиПисемGMAIL.Акцептант,
	|	ЛогиПисемGMAIL.ДатаПолучения,
	|	ЛогиПисемGMAIL.GUID_Заявки,
	|	ЛогиПисемGMAIL.email,
	|	ЛогиПисемGMAIL.ДатаОтвета,
	|	ЛогиПисемGMAIL.GUID_Связи,
	|	ЛогиПисемGMAIL.UIDTelegram,
	|	ЛогиПисемGMAIL.REF,
	|	ЛогиПисемGMAIL.MID,
	|	ЛогиПисемGMAIL.IRT,
	|	ЛогиПисемGMAIL.ИдентификаторСообщения,
	|	ЛогиПисемGMAIL.Отработано,
	|	ЛогиПисемGMAIL.Акцептировано,
	|	ЛогиПисемGMAIL.Отклонено,
	|	ЛогиПисемGMAIL.ИдентификаторЗаявки,
	|	ЛогиПисемGMAIL.ОтправленаНаАкцепт,
	|	ЛогиПисемGMAIL.ТипЗаявки,
	|	ЛогиПисемGMAIL.UID,
	|	ЛогиПисемGMAIL.text_email,
	|	ЛогиПисемGMAIL.ТемаПисьма
	|ИЗ
	|	РегистрСведений.ЛогиПисемGMAIL КАК ЛогиПисемGMAIL
	|ГДЕ
	|	ЛогиПисемGMAIL.ДатаПолучения >= &ДатаПолучения";
	
	Запрос.УстановитьПараметр("ДатаПолучения", НачалоДня(ТекущаяДата()));
	
	РезультатЗапроса = Запрос.Выполнить();
	
	ВыборкаДетальныеЗаписи = РезультатЗапроса.Выбрать();
	
	Пока ВыборкаДетальныеЗаписи.Следующий() Цикл
		email_uid 	= ВыборкаДетальныеЗаписи.UID; //"11111111-1111-1111-1111-111111111111";
		date_email	= ВыборкаДетальныеЗаписи.ДатаОтправки; //ТекущаяДата();
		email_from	= ВыборкаДетальныеЗаписи.email; //"Адрес";
		text_email	= ВыборкаДетальныеЗаписи.text_email; //"ТекстПисьмаПростой";
		text_email	= СтрЗаменить(text_email, "'", "");
		subject		= ВыборкаДетальныеЗаписи.ТемаПисьма; //"subject";
		guid_gmail	= ВыборкаДетальныеЗаписи.GUID_Загрузки; //"MID";
		мСоединение = АДОКоннекшн_СоздатьОбъект();
		Если 0 = АДОДБ_УстановитьСоединение(мСоединение) Тогда
			Сообщить("Не удалось подключиться...", 30);
			Возврат;
		КонецЕсли;    
		Попытка
			rs = мСоединение.Execute("exec SMS_REPL..List_answer_emails_insert_or_update @email_uid ="
			+ ФорматПоля(email_uid) 
			+ ", @date_email = " 
			+ ФорматПоля(date_email)
			+ ", @email_from = " 
			+ ФорматПоля(email_from)
			+ ", @text_email = " 
			+ ФорматПоля(text_email)
			+ ", @subject = " 
			+ ФорматПоля(subject)
			+ ", @gui_gmail = " 
			+ ФорматПоля(guid_gmail)
			);
		Исключение
			Сообщить(ОписаниеОшибки());
			мСоединение.Close();
			Возврат;
		КонецПопытки;
		ОБщегоНазначения.СообщитьОбОшибке("Операция завершена успешно.", , , СтатусСообщения.Информация);
		мСоединение.Close();
		
	КонецЦикла;
	
	//}}КОНСТРУКТОР_ЗАПРОСА_С_ОБРАБОТКОЙ_РЕЗУЛЬТАТА
	
КонецПроцедуры

Функция ФорматПоля(Поле)
	
	Если ТипЗнч(Поле) = Тип("Дата") Тогда
		Возврат "'" + Формат(Поле, "ДФ=yyyy-MM-ddTHH:mm:ss") + "'";
	ИначеЕсли ТипЗнч(Поле) = Тип("Строка") Тогда
		Если Лев(Поле,2)="$$" Тогда
			Возврат Сред(Поле,3)
		Иначе
			Возврат "'" + Поле + "'";
		КонецЕсли
	ИначеЕсли ТипЗнч(Поле) = Тип("Число") Тогда
		Возврат Формат(Поле, "ЧРД=.; ЧН=; ЧГ=0");
	ИначеЕсли ТипЗнч(Поле) = Тип("Булево") Тогда
		Возврат ?(Поле = Истина, 1, 0);
	КонецЕсли;
	
КонецФункции

Функция АДОДБ_УстановитьСоединение(Соединение, БД = "SMS_IZBENKA") Экспорт
	
	Строка = ВнешниеДанные.ПолучитьСтрокуСоединенияSQL(,,БД,,,"LANGUAGE=русский");
	
	Возврат Соединение.Open(Строка);
	
КонецФункции // АДОДБ_УстановитьСоединение()

Функция АДОКоннекшн_СоздатьОбъект() Экспорт
	
	ADOСоединение = New ComObject("ADODB.Connection"); 
	ADOСоединение.CommandTimeOut    = 0;
	ADOСоединение.ConnectionTimeOut = 0;
	
	Возврат ADOСоединение;
	
КонецФункции    // АДОКоннекшн_СоздатьОбъект


//Для автоматического разбора в теме должно быть написано #RVV823. Если нашли, то загружаем тело письма. Если по теме ясно, что оно нам не нужно, то не загружаем его.
//В таких письмах формат темы будет указан в следующем виде: Текст темы +   «#RVV823» + rtrim(@email_uid) + '#'.
//Необходимо из таких писем грузить данные в таблицу:sms_repl.[dbo].[List_answer_emails].
//Заполнение полей таблицы: 
//[email_uid]  - uid из темы 
//[date_email]  - дата отправки письма 
//[email_from] [nvarchar](100) NOT NULL - отправитель, 
//[text_email] [nvarchar](max) NOT NULL – из текстовых тегов необходимо выхватить текст и  скомпоновав записать в этот реквизит., 
//[Shopno] [int] NULL – пока не заполняем, 
//[Date_pr] [date] NULL – пока не заполняем, 
//[Res] [nvarchar](max) NULL – пока не заполняем

Процедура ДобавитьСтрокуПисьмоВSQL_(email_uid, date_email, email_from, text_email, ТемаПисьма)
	Транслит 			= СокрЛП(email_uid);
	ЗапрещенныеСимволы 	= "'!№;%:?*()+ ";
	Для Инд 			= 1 По СтрДлина(ЗапрещенныеСимволы) Цикл
		ТекСимвол 		= Сред(ЗапрещенныеСимволы,Инд,1);
		Транслит 		= СтрЗаменить(Транслит,ТекСимвол,"");
	КонецЦикла;
	email_uid 			= СтрЗаменить(Транслит,"""","");
	email_uid 			= ВнешниеДанные.ФорматПоля(email_uid);
	date_email 			= ВнешниеДанные.ФорматПоля(date_email);
	email_from 			= ВнешниеДанные.ФорматПоля(email_from);
	//text_email 			= СтрЗаменить(text_email, "'", "");
	text_email  		= ВнешниеДанные.ФорматПоля(text_email);
	subject				= ВнешниеДанные.ФорматПоля(ТемаПисьма);
	
	Если СтрДлина(email_uid) < 38 Тогда
		email_uid = "'11111111-1111-1111-1111-111111111111'";
	КонецЕсли;
	
	//пока не заполняем
	//Shopno	= Shopno;
	//Date_pr	= Date_pr;
	//Res		= Res;
	ADOСоединение = ВнешниеДанные.ПолучитьADOСоединение("10.0.0.40");
	ТекстЗапроса = "INSERT INTO [SMS_Repl].[dbo].[List_answer_emails]
	|	(email_uid, date_email, email_from, text_email, subject)
	|VALUES (" + email_uid  + ", " + date_email + ", " + email_from + ",  " + text_email + ",  " + subject +"
	|)"	;
	Попытка	
		ADOСоединение.Execute(ТекстЗапроса);
		//Сообщить(ТекстЗапроса);
	Исключение
		ОписаниеОшибки = ОписаниеОшибки();
	КонецПопытки;
КонецПроцедуры

Функция ПолучитьУчетнуюЗаписьПоАдресу(АдресЭлектроннойПочты) Экспорт      
	Запрос1 = Новый Запрос;
	Запрос1.Текст = 
	"ВЫБРАТЬ
	|	УчетныеЗаписиЭлектроннойПочты.Ссылка
	|ИЗ
	|	Справочник.УчетныеЗаписиЭлектроннойПочты КАК УчетныеЗаписиЭлектроннойПочты
	|ГДЕ
	|	УчетныеЗаписиЭлектроннойПочты.ПометкаУдаления = ЛОЖЬ
	|	И УчетныеЗаписиЭлектроннойПочты.АдресЭлектроннойПочты = &АдресЭлектроннойПочты
	|
	|УПОРЯДОЧИТЬ ПО
	|	УчетныеЗаписиЭлектроннойПочты.Код УБЫВ";
	
	Запрос1.УстановитьПараметр("АдресЭлектроннойПочты", СокрЛП(АдресЭлектроннойПочты));
	
	Рез1 = Запрос1.Выполнить();
	Если Рез1.Пустой() Тогда
		Возврат Неопределено;
	Иначе
		Выб1 = Рез1.Выбрать();
		Выб1.Следующий();
		Возврат Выб1.Ссылка;
	КонецЕсли;
КонецФункции // ()

Функция ПроверкаТаблицыНажатиеМодуль() Экспорт 
КонецФункции
