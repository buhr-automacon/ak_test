﻿
&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	ОбнулитьНаДату = ТекущаяДата();
	
КонецПроцедуры

&НаСервере
Процедура ОбнулитьНаСервере()
	
	СтрСоединения = НРег(СтрокаСоединенияИнформационнойБазы());
	СтрСоединения = СтрЗаменить(СтрСоединения, "10.0.0.40", "srv-sql01");
	ЭтоКопияБазы = НРег(Константы.СтрокаПодключенияКБазе.Получить()) <> СтрСоединения;
	
	ADOСоединение = Новый COMОбъект("ADODB.Connection");
	ADOСоединение.ConnectionTimeOut = 0;
	ADOСоединение.CommandTimeOut    = 0;
	ADOСоединение.ConnectionString  = ОбменСAccess.ПолучитьСтрокуСоединения("SMS_Izbenka");
	ADOСоединение.Open();
	
	СтрЗапрос = "SELECT     LU.Дата, 
				|			LU.id_tov,
				|			LU.id_tt,
				|			LU.nach_ost,
				|			LU.post,
				|			LU.digust,
				|			LU.spisanie,
				|			LU.spisanie_kach,
				|			LU.boi,
				|			LU.rashod,
				|			LU.kon_ost,
				|			LU.summa,
				|			LU.so_sklada,
				|			LU.razniza, 
				|			LU.ЦенаЗак,
				|			LU.time_fin,
				|			LU.cena_pr,
				|			LU.akcia,
				|			LU.date_update
				|FROM         SMS_IZBENKA" + ?(ЭтоКопияБазы, "_Deb", "") + ".dbo.LIST_UCHETA AS LU WITH (nolock) INNER JOIN
				|						  (SELECT     MAX(Дата) AS Data, id_tov, id_tt
				|							FROM          SMS_IZBENKA" + ?(ЭтоКопияБазы, "_Deb", "") + ".dbo.LIST_UCHETA AS LU WITH (nolock)
				|							WHERE LU.Дата <= '" + Формат(КонецДня(ОбнулитьНаДату), "ДФ=yyyy-MM-ddTHH:mm:ss") + "'
				|							and LU.id_tov = " + Формат(Номенклатура.id_tov, "ЧГ=0") + "
				|							" + ?(ЗначениеЗаполнено(СтруктурнаяЕдиница), "and LU.id_tt = " + Формат(СтруктурнаяЕдиница.id_TT, "ЧГ=0"), "") + "
				|							GROUP BY id_tt, id_tov) AS LU_Max ON LU.Дата = LU_Max.Data AND LU.id_tov = LU_Max.id_tov AND LU.id_tt = LU_Max.id_tt";
				   
	rs = ADOСоединение.Execute(СтрЗапрос);
	
	ТабДанные = Новый ТаблицаЗначений();
	ТабДанные.Колонки.Добавить("Дата");
	ТабДанные.Колонки.Добавить("id_tov");
	ТабДанные.Колонки.Добавить("id_tt");
	ТабДанные.Колонки.Добавить(СтатьяОбнуления);
	ТабДанные.Колонки.Добавить("kon_ost");
	
	Попытка
		rs.MoveFirst();
		
		Пока НЕ rs.EOF() Цикл
			СтрокаДоб = ТабДанные.Добавить();
			СтрокаДоб.Дата = Rs.Fields("Дата").Value;
			СтрокаДоб.id_tov = Rs.Fields("id_tov").Value;
			СтрокаДоб.id_tt = Rs.Fields("id_tt").Value;
			СтрокаДоб[СтатьяОбнуления] = Rs.Fields(СтатьяОбнуления).Value;
			СтрокаДоб.kon_ost = Rs.Fields("kon_ost").Value;
			rs.MoveNext();
		КонецЦикла;
	Исключение
	КонецПопытки;
	
	ТекстКоманды = "";
	Для Каждого СтрокаДанные Из ТабДанные Цикл
		КонОстаток = СтрокаДанные.kon_ost;
		Если ТипЗнч(КонОстаток) <> Тип("Число") 
			ИЛИ КонОстаток = 0 Тогда
			Продолжить;
		КонецЕсли;
		Дельта = КонОстаток * (-1);
		ТекстКоманды = ТекстКоманды + ?(ЗначениеЗаполнено(ТекстКоманды), Символы.ПС, "")
			+ "UPDATE [SMS_IZBENKA" + ?(ЭтоКопияБазы, "_Deb", "") + "].[dbo].[LIST_UCHETA]
   				|SET [kon_ost] = 0,
				|	" + СтатьяОбнуления + " = " + Формат(СтрокаДанные[СтатьяОбнуления] + Дельта, "ЧДЦ=3; ЧРД=.; ЧН=; ЧГ=0") + "
				|WHERE [Дата] = '" + Формат(СтрокаДанные.Дата, "ДФ=yyyy-MM-ddTHH:mm:ss") + "'
				|		and [id_tov] = " + Формат(СтрокаДанные.id_tov, "ЧГ=0") + "
				|		and [id_tt] = " + Формат(СтрокаДанные.id_tt, "ЧГ=0");
	КонецЦикла;	
	
	Если ЗначениеЗаполнено(ТекстКоманды) Тогда
		ADOСоединение.Execute("Begin Transaction" + Символы.ПС + ТекстКоманды + Символы.ПС + "Commit");
	КонецЕсли;	
	
	ADOСоединение.Close();
	
КонецПроцедуры	

&НаКлиенте
Процедура Обнулить(Команда)
	
	Отказ = Ложь;
	Если НЕ ЗначениеЗаполнено(Номенклатура) Тогда
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю("Не указана номенклатура", , "Номенклатура", , Отказ);
	КонецЕсли;
	
	Если НЕ ЗначениеЗаполнено(СтатьяОбнуления) Тогда
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю("Не указана статья обнуления", , "СтатьяОбнуления", , Отказ);
	КонецЕсли;
	
	Если Отказ Тогда
		Возврат;
	КонецЕсли;	
	
	Ответ = Вопрос("Обнулить позицию?", РежимДиалогаВопрос.ДаНет, 60, КодВозвратаДиалога.Да);
	Если Ответ = КодВозвратаДиалога.Да Тогда
		ОбнулитьНаСервере();
	Иначе
		Возврат;
	КонецЕсли;
	
	Предупреждение("Изменения внесены успешно");
	
	Закрыть();
	
КонецПроцедуры
