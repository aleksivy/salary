﻿
////////////////////////////////////////////////////////////////////////////////
// ПЕРЕМЕННЫЕ МОДУЛЯ

Перем мЗаголовокФормы;

////////////////////////////////////////////////////////////////////////////////
// ПРОЦЕДУРЫ И ФУНКЦИИ ОБЩЕГО НАЗНАЧЕНИЯ

Процедура УстановитьВидимостьКолонкиОрганизация()

	ЭлементыФормы.РегистрСведенийСписок.Колонки.Организация.Видимость = Отбор.Организация.Значение.Пустая();
	ЭлементыФормы.РегистрСведенийСписок.Колонки.Организация.Доступность = Отбор.Организация.Значение.Пустая();

КонецПроцедуры


////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ ФОРМЫ

Процедура ПриОткрытии()
	
	мЗаголовокФормы = НСтр("ru='Бухучет основного заработка сотрудников организации ';uk='Бухоблік основного заробітку співробітників організації '");
	
	Если Не ЗначениеЗаполнено(Отбор.Организация.Значение) Тогда
		// заполним организацию
		РаботаСДиалогами.ЗаполнениеОтбораПоОрганизацииПоУмолчанию(ЭтаФорма, Отбор.Организация, ЭлементыФормы.Организация, Неопределено, Ложь, глЗначениеПеременной("глТекущийПользователь"),мЗаголовокФормы);
		УстановитьВидимостьКолонкиОрганизация();
	КонецЕсли;
	
	ЭлементыФормы.ДействияФормы.Кнопки.История.Пометка					= Истина;
	ЭлементыФормы.ДействияФормы.Кнопки.Подменю.Кнопки.История.Пометка	= Истина;
	
КонецПроцедуры


////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ ЭЛЕМЕНТОВ УПРАВЛЕНИЯ

// Процедура прописывает заголовок формы 
//
// Параметры:
//  Элемент - элемент формы, который отображает организацию
//  
Процедура ОрганизацияПриИзменении(Элемент)

	Заголовок = мЗаголовокФормы + Элемент.Значение.Наименование;
	Отбор.Организация.Использование = Не Элемент.Значение.Пустая();
	УстановитьВидимостьКолонкиОрганизация();
	
КонецПроцедуры


Процедура ДействияФормыИстория(Кнопка)
	
	Если Кнопка.Пометка Тогда
		
		ЭлементыФормы.ДействияФормы.Кнопки.История.Пометка					= Ложь;
		ЭлементыФормы.ДействияФормы.Кнопки.Подменю.Кнопки.История.Пометка	= Ложь;
		
		ЭлементыФормы.РегистрСведенийСписок.ВыбиратьСрез = ИспользованиеСреза.Последние;
		
	Иначе
		
		ЭлементыФормы.ДействияФормы.Кнопки.История.Пометка					= Истина;
		ЭлементыФормы.ДействияФормы.Кнопки.Подменю.Кнопки.История.Пометка	= Истина;
		
		ЭлементыФормы.РегистрСведенийСписок.ВыбиратьСрез = ИспользованиеСреза.НеИспользовать;
		
	КонецЕсли;
	
КонецПроцедуры



////////////////////////////////////////////////////////////////////////////////
// ОПЕРАТОРЫ ОСНОВНОЙ ПРОГРАММЫ

