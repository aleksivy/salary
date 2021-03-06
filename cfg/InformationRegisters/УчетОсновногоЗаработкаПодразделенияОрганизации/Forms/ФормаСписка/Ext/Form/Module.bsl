
////////////////////////////////////////////////////////////////////////////////
// ПЕРЕМЕННЫЕ МОДУЛЯ

Перем мЗаголовокФормы;

////////////////////////////////////////////////////////////////////////////////
// ПРОЦЕДУРЫ И ФУНКЦИИ ОБЩЕГО НАЗНАЧЕНИЯ

Процедура УстановитьВидимостьКолонкиОрганизация()

	ЭлементыФормы.РегистрСведенийСписок.Колонки.Организация.Видимость = Отбор.Организация.Значение.Пустая();

КонецПроцедуры

Процедура ОбработатьПодразделениеПриИзмененииОрганизации()

	Если Отбор.Организация.Значение.Пустая() ИЛИ Отбор.Организация.Значение <> Отбор.ПодразделениеОрганизации.Значение.Владелец Тогда
		Отбор.ПодразделениеОрганизации.Значение = Справочники.ПодразделенияОрганизаций.ПустаяСсылка();
		Отбор.ПодразделениеОрганизации.Использование = Ложь;
	КонецЕсли;
	
	ЭлементыФормы.ПодразделениеОрганизации.Доступность = Не Отбор.Организация.Значение.Пустая() и ЭлементыФормы.Организация.Доступность;
	
КонецПроцедуры



////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ ФОРМЫ

Процедура ПриОткрытии()
	
	мЗаголовокФормы = НСтр("ru='Бухучет основного заработка сотрудников подразделений организации ';uk='Бухоблік основного заробітку співробітників підрозділів організації '");
	Если ЗначениеЗаполнено(Отбор.ПодразделениеОрганизации.Значение) Тогда
		Отбор.Организация.Значение = Отбор.ПодразделениеОрганизации.Значение.Владелец;
		ОбработатьПодразделениеПриИзмененииОрганизации();
		УстановитьВидимостьКолонкиОрганизация();
	КонецЕсли;
	
	Если Не ЗначениеЗаполнено(Отбор.Организация.Значение) Тогда
		// заполним организацию
		РаботаСДиалогами.ЗаполнениеОтбораПоОрганизацииПоУмолчанию(ЭтаФорма, Отбор.Организация, ЭлементыФормы.Организация, Неопределено, Ложь, глЗначениеПеременной("глТекущийПользователь"),мЗаголовокФормы);
		ОбработатьПодразделениеПриИзмененииОрганизации();
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
	ОбработатьПодразделениеПриИзмененииОрганизации();
	
КонецПроцедуры

Процедура ПодразделениеОрганизацииПриИзменении(Элемент)
	
	Отбор.ПодразделениеОрганизации.Использование = Не Элемент.Значение.Пустая();
	
КонецПроцедуры


Процедура РегистрСведенийСписокПодразделениеОрганизацииПриИзменении(Элемент)
	
	ДанныеСтроки = ЭлементыФормы.РегистрСведенийСписок.ТекущиеДанные;
	ДанныеСтроки.Организация = Элемент.Значение.Владелец;
	
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

