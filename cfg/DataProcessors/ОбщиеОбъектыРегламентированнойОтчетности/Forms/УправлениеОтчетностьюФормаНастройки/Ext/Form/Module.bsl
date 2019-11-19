﻿Перем мЗадаватьВопросПриЗакрытии;

Процедура СохранитьНастройки()
	
	ВладелецФормы.мОтображатьПустые = ПоказыватьПустыеДокументыВыгрузки;
	ВладелецФормы.мФильтроватьВидыОтчетовПоПериоду = ФильтроватьВидыОтчетовПоПериоду;
	СохранитьЗначение("ИнтервалАвтосохраненияРегламентированнойОтчетности", ?(ФлажокАвтосохранение, ИнтервалАвтосохранения, 0));
	
КонецПроцедуры

Процедура ОсновныеДействияФормыОК(Кнопка)
	
	СохранитьНастройки();
	мЗадаватьВопросПриЗакрытии = Ложь;
	Закрыть(Истина);
	
КонецПроцедуры

Процедура ПередОткрытием(Отказ, СтандартнаяОбработка)
	
	ИнтервалАвтосохранения = РегламентированнаяОтчетность.ЗначениеИнтервалаАвтосохраненияРегламентированнойОтчетности();
	Если ИнтервалАвтосохранения = 0 Тогда
		ФлажокАвтосохранение = Ложь;
		ЭлементыФормы.ИнтервалАвтосохранения.Доступность = Ложь;
	КонецЕсли;
	ФлажокАвтосохранение = (ИнтервалАвтосохранения <> 0);
	Если ИнтервалАвтосохранения = 0 Тогда
		ИнтервалАвтосохранения = 10;
	КонецЕсли;
	РегулированиеДоступностиПараметровАвтосохранения();
	
	ПоказыватьПустыеДокументыВыгрузки = ВладелецФормы.мОтображатьПустые;
	ФильтроватьВидыОтчетовПоПериоду = ВладелецФормы.мФильтроватьВидыОтчетовПоПериоду;
	
КонецПроцедуры

// Процедура регулирует доступность элементов формы в зависимости от
// значения флажка ФлажокАвтосохранение.
//
// Параметры:
//	Нет.
//
Процедура РегулированиеДоступностиПараметровАвтосохранения()
	
	ЭлементыФормы.ИнтервалАвтосохранения.Доступность = ФлажокАвтосохранение;
	ЭлементыФормы.НадписьМинут.Доступность = ФлажокАвтосохранение;
	
КонецПроцедуры

Процедура ПередЗакрытием(Отказ, СтандартнаяОбработка)
	
	Если Модифицированность И мЗадаватьВопросПриЗакрытии Тогда
		Ответ = Вопрос(НСтр("ru='Сохранить настройки?';uk='Зберегти настроювання?'"), РежимДиалогаВопрос.ДаНетОтмена);
		Если Ответ = КодВозвратаДиалога.Да Тогда
			СохранитьНастройки();
			мЗадаватьВопросПриЗакрытии = Ложь;
			Закрыть(Истина);
		ИначеЕсли Ответ = КодВозвратаДиалога.Нет Тогда
			Возврат;
		Иначе
			Отказ = Истина;
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

// Процедура - обарботчик события ПриИзменении флажка ФлажокАвтосохранение.
//
Процедура ФлажокАвтосохранениеПриИзменении(Элемент)
	
	РегулированиеДоступностиПараметровАвтосохранения();
	
КонецПроцедуры
	
мЗадаватьВопросПриЗакрытии = Истина;
