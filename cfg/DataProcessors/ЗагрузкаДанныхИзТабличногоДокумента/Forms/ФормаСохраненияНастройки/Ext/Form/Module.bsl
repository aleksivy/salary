﻿Перем СоздавалиНовуюСтроку;

////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ ФОРМЫ

// Процедура - обаботчик события "ПриОткрытии" Формы
//
Процедура ПриОткрытии()
	
	Если СпискокНастроек.Колонки.Найти("Значение") = Неопределено Тогда
		СпискокНастроек.Колонки.Добавить("Значение");
	КонецЕсли;
	 
	
	Если СпискокНастроек.Количество() = 0 Тогда
		ТекущиеДанные = СпискокНастроек.Добавить();
		ТекущиеДанные.Представление = "Основная";
		СоздавалиНовуюСтроку = Истина;
	Иначе
		СоздавалиНовуюСтроку = Ложь;
		ТекущиеДанные = СпискокНастроек[0];
	КонецЕсли;
	
	//НаименованиеНастройки = ТекущиеДанные.Представление;
	ЭлементыФормы.СпискокНастроек.ТекущаяСтрока = ТекущиеДанные;
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ ЭЛЕМЕНТОВ УПРАВЛЕНИЯ

// Процедура - обаботчик события "Нажатие" в: Кнопка "ОК"
//
Процедура ОКНажатие(Элемент)
	Закрыть(ЭлементыФормы.СпискокНастроек.ТекущиеДанные);
КонецПроцедуры

// Процедура - обаботчик события "Нажатие" в: Кнопка "Отмена"
//
Процедура ОтменаНажатие(Элемент)
	Закрыть();
КонецПроцедуры

// Процедура - обаботчик события "Нажатие" в: Кнопка "Удалить"
//
Процедура УдалитьНажатие(Элемент)
	
	ТекущиеДанные = ЭлементыФормы.СпискокНастроек.ТекущиеДанные;
	Если ТекущиеДанные = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	Если СоздавалиНовуюСтроку и ТекущиеДанные = СпискокНастроек[СпискокНастроек.Количество() - 1] Тогда
		СоздавалиНовуюСтроку = Ложь;
	КонецЕсли;
	
	Если СпискокНастроек.Количество() = 1 Тогда
		СоздавалиНовуюСтроку = Истина;
		ТекущиеДанные.Представление = "";
		ТекущиеДанные.Пометка = Ложь;
	Иначе
		СпискокНастроек.Удалить(ТекущиеДанные);
	КонецЕсли;
	
КонецПроцедуры

// Процедура - обаботчик события "ПриИзменении" в: Поле ввода "НаименованиеНастройки"
//
Процедура НаименованиеНастройкиПриИзменении(Элемент)
	НаименованиеНастройки = "";
	Возврат;
	Нашли = Ложь;
	Для каждого ТекущиеДанные Из СпискокНастроек Цикл
		Если ТекущиеДанные.Представление = НаименованиеНастройки Тогда
			Нашли = Истина;
			Прервать;
		КонецЕсли;
	КонецЦикла;
	
	Если Не Нашли Тогда
		
		Если Не СоздавалиНовуюСтроку Тогда
			ТекущиеДанные = СпискокНастроек.Добавить();
			СоздавалиНовуюСтроку = истина;
		Иначе
			ТекущиеДанные = СпискокНастроек[СпискокНастроек.Количество() - 1];
		КонецЕсли;
		
		ТекущиеДанные.Представление = НаименованиеНастройки;
		
	КонецЕсли;
	ЭлементыФормы.СпискокНастроек.ТекущаяСтрока = ТекущиеДанные;
	
КонецПроцедуры

// Процедура - обаботчик события "ПриАктивизацииСтроки"  табличного поля "СпискокНастроек"
//
Процедура СпискокНастроекПриАктивизацииСтроки(Элемент)
	Возврат;
	НаименованиеНастройки = ЭлементыФормы.СпискокНастроек.ТекущиеДанные.Представление;
КонецПроцедуры

// Процедура - обаботчик события "ПриИзмененииФлажка"  табличного поля "СпискокНастроек"
//
Процедура СпискокНастроекПриИзмененииФлажка(Элемент, Колонка)
	
	ТекущиеДанные = ЭлементыФормы.СпискокНастроек.ТекущиеДанные;
	Если ТекущиеДанные.Пометка Тогда
		Для каждого ЭлементСписка Из СпискокНастроек Цикл
			Если ЭлементСписка.Пометка и Не ЭлементСписка = ТекущиеДанные Тогда
				ЭлементСписка.Пометка = Ложь;
			КонецЕсли;
		КонецЦикла;
	КонецЕсли;
	
КонецПроцедуры

// Процедура - обаботчик события "ПриИзменении" флажка "ИспользоватьПриОткрытии"
//
Процедура ИспользоватьПриОткрытииПриИзменении(Элемент)
	
	ТекущиеДанные = ЭлементыФормы.СпискокНастроек.ТекущиеДанные;
	Если ТекущиеДанные.Пометка Тогда
		Для каждого ЭлементСписка Из СпискокНастроек Цикл
			Если ЭлементСписка.Пометка и Не ЭлементСписка = ТекущиеДанные Тогда
				ЭлементСписка.Пометка = Ложь;
			КонецЕсли;
		КонецЦикла;
	КонецЕсли;
	
КонецПроцедуры

// Процедура - обаботчик события "ПриВыводеСтроки"  табличного поля "СпискокНастроек"
//
Процедура СпискокНастроекПриВыводеСтроки(Элемент, ОформлениеСтроки, ДанныеСтроки)
	
	Если ДанныеСтроки.Пометка Тогда
		ОформлениеСтроки.Шрифт = Новый Шрифт(,, Истина);
	КонецЕсли;
	
КонецПроцедуры

// Процедура - обаботчик события "ОкончаниеВводаТекста" в: Поле ввода "НаименованиеНастройки"
//
Процедура НаименованиеНастройкиОкончаниеВводаТекста(Элемент, Текст, Значение, СтандартнаяОбработка)
	
	
	Нашли = Ложь;
	
	Для каждого ТекущиеДанные Из СпискокНастроек Цикл
		Если ТекущиеДанные.Представление = Текст Тогда
			Нашли = Истина;
			Прервать;
		КонецЕсли;
	КонецЦикла;
	
	Если Не Нашли Тогда
		
		Если Не СоздавалиНовуюСтроку Тогда
			ТекущиеДанные = СпискокНастроек.Добавить();
			СоздавалиНовуюСтроку = истина;
		Иначе
			ТекущиеДанные = СпискокНастроек[СпискокНастроек.Количество() - 1];
		КонецЕсли;
		
		ТекущиеДанные.Представление = Текст;
	КонецЕсли;
	
	ЭлементыФормы.СпискокНастроек.ТекущаяСтрока = ТекущиеДанные;
	
КонецПроцедуры

