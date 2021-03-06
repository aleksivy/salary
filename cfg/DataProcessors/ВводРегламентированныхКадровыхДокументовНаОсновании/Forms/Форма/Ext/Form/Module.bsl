////////////////////////////////////////////////////////////////////////////////
// ПРОЦЕДУРЫ - ОБРАБОТЧИКИ СОБЫТИЙ ФОРМЫ

Процедура ПередОткрытием(Отказ, СтандартнаяОбработка)
	
	ИмяДокумента = ПолучитьИмяДокумента();
	
	Если НЕ ЗначениеЗаполнено(ИмяДокумента) Тогда
		Отказ = Истина;
		Возврат;
	КонецЕсли;
	
	Если Не ПравоДоступа("Добавление", Метаданные.Документы[ИмяДокумента]) Тогда
		Предупреждение(НСтр("ru='У вас нет прав на создание документа ""';uk='У вас немає прав на створення документа ""'") + Метаданные.Документы[ИмяДокумента].Синоним + """");
		Отказ = Истина;
		Возврат;
	КонецЕсли;
	
КонецПроцедуры

// Процедура - обработчик события "ПриОткрытии" формы
//
Процедура ПриОткрытии()
	
	Автозаполнение();
	
КонецПроцедуры // ПриОткрытии()

////////////////////////////////////////////////////////////////////////////////
// ПРОЦЕДУРЫ - ДЕЙСТВИЯ КОМАНДНЫХ ПАНЕЛЕЙ ФОРМЫ

// Процедура - обработчик нажатия на кнопку "Выполнить" командной панели "ОсновныеДействияФормы"
//
Процедура ОсновныеДействияФормыВыполнить(Кнопка)
	
	ИмяДокумента = ПолучитьИмяДокумента();
	
	Если НЕ ЗначениеЗаполнено(ИмяДокумента) Тогда
		Возврат;
	КонецЕсли;
	
	Для Каждого СтрокаТаблицы Из ВводНаОсновании.НайтиСтроки(Новый Структура("Отметка", Истина)) Цикл
		
		Форма = Документы[ИмяДокумента].ПолучитьФормуНовогоДокумента(,, СтрокаТаблицы.Организация);
		Форма.Организация = СтрокаТаблицы.Организация;
		Форма.Заполнить(Основание);
		
		Форма.Открыть();
		
	КонецЦикла;
	
	Закрыть();
	
КонецПроцедуры // ОсновныеДействияФормыОсновныеДействияФормыВыполнить()


// Процедура - обработчик нажатия на кнопку "УстановитьФлажки" командной панели "ВводНаОсновании"
//
Процедура КоманднаяПанельВводНаОснованииУстановитьФлажки(Кнопка)
	
	Для Каждого СтрокаТЧ Из ВводНаОсновании Цикл
		СтрокаТЧ.Отметка = Истина;
	КонецЦикла;
	
КонецПроцедуры // КоманднаяПанельВводНаОснованииУстановитьФлажки()

// Процедура - обработчик нажатия на кнопку "СнятьФлажки" командной панели "ВводНаОсновании"
//
Процедура КоманднаяПанельВводНаОснованииСнятьФлажки(Кнопка)
	
	Для Каждого СтрокаТЧ Из ВводНаОсновании Цикл
		СтрокаТЧ.Отметка = Ложь;
	КонецЦикла;
	
КонецПроцедуры // КоманднаяПанельВводНаОснованииСнятьФлажки()

// Процедура - обработчик нажатия на кнопку "Обновить" командной панели "ВводНаОсновании"
//
Процедура КоманднаяПанельВводНаОснованииОбновить(Кнопка)
	
	Автозаполнение();
	
КонецПроцедуры // КоманднаяПанельВводНаОснованииОбновить()

////////////////////////////////////////////////////////////////////////////////
// ПРОЦЕДУРЫ - ОБРАБОТЧИКИ СОБЫТИЙ ЭЛЕМЕНТОВ ФОРМЫ

// Процедура - обработчик события "ПриИзменении" реквизита "ДокументОснование"
//
Процедура ДокументОснованиеПриИзменении(Элемент)
	
	Автозаполнение();
	
КонецПроцедуры // ДокументОснованиеПриИзменении()

////////////////////////////////////////////////////////////////////////////////
// ОПЕРАТОРЫ ОСНОВНОЙ ПРОГРАММЫ
