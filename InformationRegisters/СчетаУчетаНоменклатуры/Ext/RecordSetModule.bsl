﻿
//+++АК Susk (Суслин К.В.) 2018.08.31 б/н 
Процедура ПередЗаписью(Отказ, Замещение)
	
	Если ДополнительныеСвойства.Свойство("НеПроверятьНаборПередЗаписью") Тогда
		Возврат;
	КонецЕсли;
	
	МассивНоменклатур = ЭтотОбъект.ВыгрузитьКолонку("Номенклатура");
	
	ЗначенияРеквизитаВидНом = ОбщегоНазначения.ЗначенияРеквизитовОбъектов(МассивНоменклатур, "ВидНоменклатуры");
		
	Для Каждого Ном Из МассивНоменклатур Цикл
		
		Если ЗначенияРеквизитаВидНом[Ном].ВидНоменклатуры = Перечисления.ВидыНоменклатуры.Товар Тогда
			ОбщегоНазначения.СообщитьОбОшибке("Номенклатура """ + Строка(Ном) + """ имеет вид Товар. Внесение данных о счетах учета - запрещено!", Отказ);
		КонецЕсли;
		
	КонецЦикла;
	
КонецПроцедуры
