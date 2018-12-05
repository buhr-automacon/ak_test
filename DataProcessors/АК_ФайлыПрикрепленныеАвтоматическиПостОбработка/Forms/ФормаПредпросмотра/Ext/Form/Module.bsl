﻿&НаСервере
Функция ПолучитьПолныйПутьКФайлу(Файл)
	
	//
	Возврат Справочники.Файлы.ПолучитьИмяФайлаДляОбъекта(Файл);
	
КонецФункции



&НаСервере
Функция ОбновитьПолеПредпросмотра(ТекущийФайл, ТекущийОбъект, ЭтоУПД, ЭтоСФ, ЭтоАктНакладная)
	
	//
	ТекстHTML = "<HTML><HEAD>
					|<META content=""text/html; charset=utf-8"" http-equiv=Content-Type>
					|<META name=GENERATOR content=""MSHTML 8.00.7601.18870""></HEAD>
					|<BODY><TABLE cellpadding=5 border=1><TR>";
	//
	ТекстHTML1 = "<HEAD>
					|<META content=""text/html; charset=utf-8"" http-equiv=Content-Type>
					|<META name=GENERATOR content=""MSHTML 8.00.7601.18870""></HEAD>
					|<BODY><TABLE cellpadding=5 border=1><TR>";				
	//
	ТекстHTML2 = "<BODY><TABLE cellpadding=5 border=1><TR>";								
	
	//
	стрИзображение = "";
					
	//				
	Если ЗначениеЗаполнено(ТекущийФайл) Тогда				
		
		//
		ИмяФайла = ПолучитьПолныйПутьКФайлу(ТекущийФайл);					
		
		//
		стрИзображение = "<TD><DIV>ТЕКУЩИЙ ФАЙЛ</DIV>"; 
		
		//
		Файл = Новый Файл(ИмяФайла);
		Если Файл.Существует() И НЕ Файл.ЭтоКаталог() Тогда
			
			//
			Если Файл.Расширение = ".pdf" Тогда
				
				//
				стрИзображение = стрИзображение + "<DIV><EMBED width=600 height=800 src=""#REF""></DIV></TD>";
				
				
			Иначе
				
				//
				стрИзображение = стрИзображение + "<DIV><IMG width=600 src=""#REF""></DIV></TD>";
				
			КонецЕсли;							
			
			//
			ДвоичныеДанные = Новый ДвоичныеДанные(ИмяФайла);
			ИзображениеСкан = ПоместитьВоВременноеХранилище(ДвоичныеДанные, УникальныйИдентификатор);
			
			//
			ТекстHTML = ТекстHTML + СтрЗаменить(стрИзображение, "#REF", Файл.ПолноеИмя);
			
		Иначе
			
			//
			ТекстHTML = ТекстHTML + СтрЗаменить(стрИзображение, "#REF", "");
			
		КонецЕсли;
		
	КонецЕсли;	
	
	//				
	Если ЭтоУПД И ЗначениеЗаполнено(ТекущийОбъект) Тогда				
		
		//
		Если ЗначениеЗаполнено(ТекущийОбъект.УПД) Тогда
		
			//
			ИмяФайла = ПолучитьПолныйПутьКФайлу(ТекущийОбъект.УПД);					
			
			//
			Если ТекущийОбъект.УПД <> ТекущийФайл Тогда 
				стрИзображение = "<TD bgcolor=#FF9090><DIV>УПД (" + ТекущийОбъект.УПД + ")" + "</DIV>"; 
			Иначе
				стрИзображение = "<TD bgcolor=#B4FFB4><DIV>УПД (" + ТекущийОбъект.УПД + ")" + "</DIV>"; 
			КонецЕсли;	
			
			//
			Файл = Новый Файл(ИмяФайла);
			Если Файл.Существует() И НЕ Файл.ЭтоКаталог() Тогда
				
				//
				Если Файл.Расширение = ".pdf" Тогда
					
					//
					стрИзображение = стрИзображение + "<DIV><EMBED width=600 height=800 src=""#REF""></DIV></TD>";
					
				Иначе
					
					//
					стрИзображение = стрИзображение + "<DIV><IMG width=600 src=""#REF""></DIV></TD>";
					
				КонецЕсли;							
				
				//
				ДвоичныеДанные = Новый ДвоичныеДанные(ИмяФайла);
				ИзображениеСкан = ПоместитьВоВременноеХранилище(ДвоичныеДанные, УникальныйИдентификатор);
				
				//
				ТекстHTML = ТекстHTML + СтрЗаменить(стрИзображение, "#REF", Файл.ПолноеИмя);
				
			Иначе
				
				//
				ТекстHTML = ТекстHTML + СтрЗаменить(стрИзображение, "#REF", "");
				
			КонецЕсли;
			
		КонецЕсли;	
		
	КонецЕсли;	
	
	//				
	Если ЭтоСФ И ЗначениеЗаполнено(ТекущийОбъект) Тогда				
		
		//
		Если ЗначениеЗаполнено(ТекущийОбъект.СчетФактура) Тогда
		
			//
			ИмяФайла = ПолучитьПолныйПутьКФайлу(ТекущийОбъект.СчетФактура);					
			
			//
			Если ТекущийОбъект.СчетФактура <> ТекущийФайл Тогда 
				стрИзображение = "<TD bgcolor=#FF9090><DIV>СЧЕТ-ФАКТУРА (" + ТекущийОбъект.СчетФактура + ")" + "</DIV>"; 
			Иначе
				стрИзображение = "<TD bgcolor=#B4FFB4><DIV>СЧЕТ-ФАКТУРА (" + ТекущийОбъект.СчетФактура + ")" + "</DIV>"; 
			КонецЕсли;
			
			//
			Файл = Новый Файл(ИмяФайла);
			Если Файл.Существует() И НЕ Файл.ЭтоКаталог() Тогда
				
				//
				Если Файл.Расширение = ".pdf" Тогда
					
					//
					стрИзображение = стрИзображение + "<DIV><EMBED width=600 height=800 src=""#REF""></DIV></TD>";
					
				Иначе
					
					//
					стрИзображение = стрИзображение + "<DIV><IMG width=600 src=""#REF""></DIV></TD>";
					
				КонецЕсли;							
				
				//
				ДвоичныеДанные = Новый ДвоичныеДанные(ИмяФайла);
				ИзображениеСкан = ПоместитьВоВременноеХранилище(ДвоичныеДанные, УникальныйИдентификатор);
				
				//
				ТекстHTML = ТекстHTML + СтрЗаменить(стрИзображение, "#REF", Файл.ПолноеИмя);
				
			Иначе
				
				//
				ТекстHTML = ТекстHTML + СтрЗаменить(стрИзображение, "#REF", "");
				
			КонецЕсли;
			
		КонецЕсли;	
		
	КонецЕсли;	
	
	//				
	Если ЭтоАктНакладная И ЗначениеЗаполнено(ТекущийОбъект) Тогда				
		
		//
		Если ЗначениеЗаполнено(ТекущийОбъект.Акт) Тогда
		
			//
			ИмяФайла = ПолучитьПолныйПутьКФайлу(ТекущийОбъект.Акт);					
			
			//
			Если ТекущийОбъект.Акт <> ТекущийФайл Тогда 
				стрИзображение = "<TD bgcolor=#FF9090><DIV>АКТ/НАКЛАДНАЯ (" + ТекущийОбъект.Акт + ")" + "</DIV>"; 
			Иначе
				стрИзображение = "<TD bgcolor=#B4FFB4><DIV>АКТ/НАКЛАДНАЯ (" + ТекущийОбъект.Акт + ")" + "</DIV>"; 
			КонецЕсли;
			
			//
			Файл = Новый Файл(ИмяФайла);
			Если Файл.Существует() И НЕ Файл.ЭтоКаталог() Тогда
				
				//
				Если Файл.Расширение = ".pdf" Тогда
					
					//
					стрИзображение = стрИзображение + "<DIV><EMBED width=600 height=800 src=""#REF""></DIV></TD>";
					
				Иначе
					
					//
					стрИзображение = стрИзображение + "<DIV><IMG width=600 src=""#REF""></DIV></TD>";
					
				КонецЕсли;							
				
				//
				ДвоичныеДанные = Новый ДвоичныеДанные(ИмяФайла);
				ИзображениеСкан = ПоместитьВоВременноеХранилище(ДвоичныеДанные, УникальныйИдентификатор);
				
				//
				ТекстHTML = ТекстHTML + СтрЗаменить(стрИзображение, "#REF", Файл.ПолноеИмя);
				
			Иначе
				
				//
				ТекстHTML = ТекстHTML + СтрЗаменить(стрИзображение, "#REF", "");
				
			КонецЕсли;
			
		КонецЕсли;	
		
	КонецЕсли;
	
	//
	ТекстHTML = ТекстHTML + "</TR></TABLE></BODY>";
	//ТекстHTML = ТекстHTML + "</TR></TABLE></BODY></HTML>";

	//
	Возврат ТекстHTML;
	
КонецФункции


&НаКлиенте
Процедура ОбновитьПолеПредпросмотраОбработчикОжидания(ТекущаСтрока)
	
	
	
	//
	ТекстHTML = ОбновитьПолеПредпросмотра(ТекущаСтрока.Файл, ТекущаСтрока.Объект, ТекущаСтрока.ПризнакЭтоУПД, ТекущаСтрока.ПризнакЭтоСФ, ТекущаСтрока.ПризнакЭтоАктНакладная);
	Если HTMLПредпросмотр <> ТекстHTML Тогда
		//Элементы.HTMLПредпросмотр.Документ.body.innerHTML = ТекстHTML;
		HTMLПредпросмотр = ТекстHTML;
		//Элементы.HTMLПредпросмотр.Обн
	КонецЕсли;	
	
КонецПроцедуры	


&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	
	//
	Если ИмяСобытия = "ТекстHTML" Тогда
		ОбновитьПолеПредпросмотраОбработчикОжидания(Параметр);
		//ВладелецФормы.Активизировать();
	КонецЕсли;	
	
КонецПроцедуры
