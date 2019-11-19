﻿////////////////////////////////////////////////////////////////////////////////
// ПЕРЕМЕННЫЕ МОДУЛЯ

Перем мМассивВыбранныхЗначений Экспорт;

////////////////////////////////////////////////////////////////////////////////
// ПРОЦЕДУРЫ И ФУНКЦИИ ОБЩЕГО НАЗНАЧЕНИЯ

Процедура ПерерисоватьКнопкиВыбора(ДанныеСтроки)
	
	КнопкиПодменю = ЭлементыФормы.ДействияФормы.Кнопки.Подменю.Кнопки;
	
	// В зависимости от того, подобран элемент или нет, "дорисуем" контекстное меню
	Если ДанныеСтроки = Неопределено Тогда
		Кнопка = КнопкиПодменю.Найти("КнопкаОтменитьВыбор");
		Если Кнопка <> Неопределено Тогда
			КнопкиПодменю.Удалить(Кнопка);
		КонецЕсли;
		Кнопка = КнопкиПодменю.Найти("КнопкаВыбрать");
		Если Кнопка <> Неопределено Тогда
			КнопкиПодменю.Удалить(Кнопка);
		КонецЕсли;
		
	ИначеЕсли мМассивВыбранныхЗначений = Неопределено ИЛИ мМассивВыбранныхЗначений.Найти(ДанныеСтроки.Ссылка) = Неопределено Тогда
		Если КнопкиПодменю.Найти("КнопкаВыбрать") = Неопределено Тогда
			НоваяКнопка = КнопкиПодменю.Вставить(0);
			НоваяКнопка.ТипКнопки	= ТипКнопкиКоманднойПанели.Действие;
			НоваяКнопка.Действие	= Новый Действие("ПланВидовРасчетаСписокВыбор");
			НоваяКнопка.Имя			= "КнопкаВыбрать";
			НоваяКнопка.Текст		= "Выбрать";
			НоваяКнопка.Подсказка	= "Выбрать";
			НоваяКнопка.Пояснение	= "Выбрать значение";
			НоваяКнопка.Картинка	= БиблиотекаКартинок.ВыбратьИзСписка;
		КонецЕсли;
		
	Иначе
		Кнопка = КнопкиПодменю.Найти("КнопкаВыбрать");
		Если Кнопка <> Неопределено Тогда
			КнопкиПодменю.Удалить(Кнопка);
		КонецЕсли;
		
	КонецЕсли;
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// ПРОЦЕДУРЫ - ОБРАБОТЧИКИ СОБЫТИЙ ФОРМЫ

Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	
	Если мМассивВыбранныхЗначений = Неопределено ИЛИ ТипЗнч(Параметр) <> Тип("ПланВидовРасчетаСсылка.УправленческиеНачисления") Тогда
		Возврат;
	КонецЕсли;
	
	Если ИмяСобытия = "ПодборВыбор" Тогда
		Если мМассивВыбранныхЗначений.Найти(Параметр) = Неопределено Тогда
			мМассивВыбранныхЗначений.Добавить(Параметр);
			
			ДанныеСтроки = ЭлементыФормы.ПланВидовРасчетаСписок.ТекущиеДанные;
			Если ДанныеСтроки <> Неопределено Тогда
				ПерерисоватьКнопкиВыбора(ДанныеСтроки);
			КонецЕсли;
			ЭлементыФормы.ПланВидовРасчетаСписок.ОбновитьСтроки(Параметр);
		КонецЕсли;
	
	ИначеЕсли ИмяСобытия = "ПодборОтменаВыбора" Тогда
		ИндексСтроки = мМассивВыбранныхЗначений.Найти(Параметр);
		
		Если ИндексСтроки <> Неопределено Тогда
			мМассивВыбранныхЗначений.Удалить(ИндексСтроки);
			
			ДанныеСтроки = ЭлементыФормы.ПланВидовРасчетаСписок.ТекущиеДанные;
			Если ДанныеСтроки <> Неопределено Тогда
				ПерерисоватьКнопкиВыбора(ДанныеСтроки);
			КонецЕсли;
			ЭлементыФормы.ПланВидовРасчетаСписок.ОбновитьСтроки(Параметр);
		КонецЕсли;
		
	КонецЕсли;
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// ПРОЦЕДУРЫ - ОБРАБОТЧИКИ СОБЫТИЙ ТАБЛИЧНОГО ПОЛЯ ПланВидовРасчетаСписок

Процедура ПланВидовРасчетаСписокПриАктивизацииСтроки(Элемент)
	
	ДанныеСтроки = ЭлементыФормы.ПланВидовРасчетаСписок.ТекущиеДанные;
	
	ПерерисоватьКнопкиВыбора(ДанныеСтроки);
	
КонецПроцедуры

Процедура ПланВидовРасчетаСписокПриВыводеСтроки(Элемент, ОформлениеСтроки, ДанныеСтроки)
	
	Если мМассивВыбранныхЗначений <> Неопределено И мМассивВыбранныхЗначений.Найти(ДанныеСтроки.Ссылка) <> Неопределено Тогда
		ОформлениеСтроки.ЦветТекста	= ЦветаСтиля.ТекстВторостепеннойНадписи;
	КонецЕсли;
	
КонецПроцедуры

Процедура ПланВидовРасчетаСписокВыбор(Элемент, ВыбраннаяСтрока, Колонка, СтандартнаяОбработка)
	
	ДанныеСтроки = ЭлементыФормы.ПланВидовРасчетаСписок.ТекущиеДанные;
	Если ДанныеСтроки = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	Если мМассивВыбранныхЗначений <> Неопределено И мМассивВыбранныхЗначений.Найти(ДанныеСтроки.Ссылка) = Неопределено Тогда
		мМассивВыбранныхЗначений.Добавить(ДанныеСтроки.Ссылка);
		ПерерисоватьКнопкиВыбора(ДанныеСтроки);
		ЭлементыФормы.ПланВидовРасчетаСписок.ОбновитьСтроки(ДанныеСтроки);
	КонецЕсли;
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// ОПЕРАТОРЫ ОСНОВНОЙ ПРОГРАММЫ
