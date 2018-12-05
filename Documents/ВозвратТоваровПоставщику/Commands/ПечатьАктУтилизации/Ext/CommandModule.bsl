﻿
&НаКлиенте
Процедура ОбработкаКоманды(ПараметрКоманды, ПараметрыВыполненияКоманды)
	
	Если НЕ ПолучитьПризкакПроведенности(ПараметрКоманды) Тогда
		ОбщегоНазначения.СообщитьИнформациюПользователю("Документ не проведен! Для печати необходимо провести документ!");
		Возврат;
	КонецЕсли;
	
	Если НЕ ПроверитьРасходныйОрдер(ПараметрКоманды) Тогда
		ОбщегоНазначения.СообщитьИнформациюПользователю("Не задан ""Расходный ордер (склад)"" - основание документа!");
		Возврат;
	КонецЕсли;
	
	Если НЕ ПроверитьЗаданиеТехнолога(ПараметрКоманды) Тогда
		ОбщегоНазначения.СообщитьИнформациюПользователю("У ""Расходного ордера"" основание является не ""Задание технолога магазинам""!");
		Возврат;
	КонецЕсли;
	
	ТабДок = ПечатьАктУтилизации(ПараметрКоманды);
	
	ТабДок.ОтображатьСетку 		= Ложь;
	ТабДок.ТолькоПросмотр 		= Истина;
	ТабДок.ОтображатьЗаголовки 	= Ложь;
	ТабДок.Показать();
	
КонецПроцедуры

&НаСервере
Функция ПолучитьПризкакПроведенности(СсылкаНаОбъект)
	
	Возврат СсылкаНаОбъект.Проведен;
	
КонецФункции

&НаСервере
Функция ПечатьАктУтилизации(СсылкаНаОбъект)
	
	Возврат Документы.ВозвратТоваровПоставщику.ПечатьАктУтилизации(СсылкаНаОбъект);
	
КонецФункции

&НаСервере
Функция ПроверитьРасходныйОрдер(СсылкаНаОбъект)
	// Проверим, что документ подходит
	Если СсылкаНаОбъект.РасходныеОрдера.Количество() = 0 Тогда
		Возврат Ложь;
	КонецЕсли;
	
	Возврат Истина;
КонецФункции

&НаСервере
Функция ПроверитьЗаданиеТехнолога(СсылкаНаОбъект)
	// Проверим, что документ подходит
	Док_РасхОрдерСклад = СсылкаНаОбъект.РасходныеОрдера[0].РасходныйОрдер;
	Док_ЗаданиеТехнолога = Док_РасхОрдерСклад.Основание;
	Если не (ЗначениеЗаполнено(Док_ЗаданиеТехнолога) и ТипЗнч(Док_ЗаданиеТехнолога) = Тип("ДокументСсылка.ЗаданиеТехнологаМагазинам")) Тогда
	    Возврат Ложь;
	КонецЕсли;
	
	Возврат Истина;
КонецФункции
