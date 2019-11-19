﻿
////////////////////////////////////////////////////////////////////////////////
// СЛУЖЕБНЫЕ ПРОЦЕДУРЫ И ФУНКЦИИ

////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ ФОРМЫ

// Обработчик события ПередЗакрытием формы.
//
Процедура ПередЗакрытием(Отказ, СтандартнаяОбработка)
	
	Для Каждого СтрокаОтбора Из ПостроительОтчета.Отбор Цикл
		
		Если НЕ ЗначениеЗаполнено(СтрокаОтбора.ПутьКДанным) Тогда
			Предупреждение(НСтр("ru='В отборе не должно быть пустых полей!';uk='У відборі не повинне бути порожніх полів!'"), 30);			
			Отказ = Истина;
			Прервать;
		КонецЕсли;
		
	КонецЦикла;

КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ ЭЛЕМЕНТОВ УПРАВЛЕНИЯ КОМАНДНЫХ ПАНЕЛИ

// Обработчик события элемента КоманднаяПанельСпискаВыбранныхВидовКИ.КнопкаУстановитьФлажки.
//
Процедура КоманднаяПанельСпискаВыбранныхВидовКИКнопкаУстановитьФлажки(Кнопка)
	
	Для каждого СтрокаТаблицы Из ВидыКонтактнойИнформации Цикл
		СтрокаТаблицы.Использование = Истина;
	КонецЦикла; 
	
КонецПроцедуры

// Обработчик события элемента КоманднаяПанельСпискаВыбранныхВидовКИ.КнопкаСнятьФлажки.
//
Процедура КоманднаяПанельСпискаВыбранныхВидовКИКнопкаСнятьФлажки(Кнопка)
	
	Для каждого СтрокаТаблицы Из ВидыКонтактнойИнформации Цикл
		СтрокаТаблицы.Использование = Ложь;
	КонецЦикла; 
	
КонецПроцедуры

// Обработчик события элемента ОсновныеДействияФормы.ОК.
//
Процедура ОсновныеДействияФормыОК(Элемент)	
	
	ЕстьОшибки = Ложь;
	
	Для Каждого СтрокаОтбора Из ПостроительОтчета.Отбор Цикл
		
		Если НЕ ЗначениеЗаполнено(СтрокаОтбора.ПутьКДанным) Тогда
			Предупреждение(НСтр("ru='В отборе не должно быть пустых полей!';uk='У відборі не повинне бути порожніх полів!'"), 30);			
			ЕстьОшибки = Истина;
			Прервать;
		КонецЕсли;
		
	КонецЦикла;
	
	Если ЕстьОшибки Тогда
		Возврат;
	КонецЕсли;	
	
	ЭтаФорма.Закрыть(Истина);
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ ЭЛЕМЕНТОВ ФОРМЫ

//Обработчик события ПередНачаломДобавления элемента формы ВидыКИ.
//
Процедура ВидыКИПередНачаломДобавления(Элемент, Отказ, Копирование)
	
	Отказ = Истина;
	
КонецПроцедуры

// Обработчик события ПередУдалением элемента формы ВидыКИ.
//
Процедура ВидыКИПередУдалением(Элемент, Отказ)
	
	Отказ = Истина;
	
КонецПроцедуры

// Обработчик события ПередУдалением элемента формы Отбор.
//
Процедура ОтборПередУдалением(Элемент, Отказ)
	
	Если Не ПустаяСтрока(Элемент.ТекущаяСтрока.Имя) Тогда	
		Отказ = УправлениеОтчетами.ОтборСвязанСДанными(ЭлементыФормы.Отбор.ТекущиеДанные.Имя, мСтруктураСвязиЭлементовСДанными);		
	КонецЕсли;
	
КонецПроцедуры

// Обработчик события НачалоВыбораИзСписка элемента формы ВидыКонтактнойИнформацииВидКонтактной
//
Процедура ВидыКонтактнойИнформацииВидКонтактнойИнформацииНачалоВыбораИзСписка(Элемент, СтандартнаяОбработка)
	
	Запрос = Новый Запрос(
	"ВЫБРАТЬ
	|	ВидыКонтактнойИнформации.Ссылка
	|ИЗ
	|	Справочник.ВидыКонтактнойИнформации КАК ВидыКонтактнойИнформации
	|ГДЕ
	|	ВидыКонтактнойИнформации.Тип = &Тип
	|	И ВидыКонтактнойИнформации.ВидОбъектаКонтактнойИнформации = &ФизЛицо");
	
	Запрос.УстановитьПараметр("Тип",ЭлементыФормы.ВидыКонтактнойИнформации.ТекущиеДанные.ТипКонтактнойИнформации);	
	Запрос.УстановитьПараметр("ФизЛицо",Перечисления.ВидыОбъектовКонтактнойИнформации.ФизическиеЛица);
	
	СписокВидовКИ = Новый СписокЗначений();
	Выборка = Запрос.Выполнить().Выбрать();
	Пока Выборка.Следующий() Цикл
		СписокВидовКИ.Добавить(Выборка.Ссылка,Выборка.Ссылка.Наименование);
	КонецЦикла;
	Элемент.СписокВыбора = СписокВидовКИ;
	
КонецПроцедуры



