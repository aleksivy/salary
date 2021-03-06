Перем ВладелецТС Экспорт;

////////////////////////////////////////////////////////////////////////////////
// СЛУЖЕБНЫЕ ПРОЦЕДУРЫ И ФУНКЦИИ

// Процедура формирует необходимый набор параметров и вызывает экспортную
// процедуру формы регламентированного отчета, соответствующего переданной в качестве
// параметра строке ВыбраннаяСтрока. Вызываемая экспортная процедура активизирует
// описываемую ячейку одного из табличных документов, расположенных на форме.
//
// Параметры:
//	ВыбраннаяСтрока - строка табличного поля ТаблицаСообщений формы, ячейку, 
//						соответствующую которой, следует активизировать.
//
Процедура АктивизироватьЯчейку(ВыбраннаяСтрока)
	
	Если ВыбраннаяСтрока = Неопределено Тогда
		Возврат;
	КонецЕсли;
		
	ТекДок = ВыбраннаяСтрока.ОтчетДок;
	
	Если ТекДок = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	ТекДок.ПолучитьФорму().Открыть();
	
	Ячейка = Новый Структура;
	Ячейка.Вставить("Раздел", ВыбраннаяСтрока.Раздел);
	Ячейка.Вставить("Страница", ВыбраннаяСтрока.Страница);
	Ячейка.Вставить("Строка", ВыбраннаяСтрока.Строка);
	Ячейка.Вставить("Графа", ВыбраннаяСтрока.Графа);
	Ячейка.Вставить("СтрокаПП", ВыбраннаяСтрока.СтрокаПП);
	Ячейка.Вставить("ИмяЯчейки", ВыбраннаяСтрока.ИмяЯчейки);
	Ячейка.Вставить("Описание", ВыбраннаяСтрока.Описание);
	
	Попытка
		РегламентированнаяОтчетность.ФормаРеглОтчета(ТекДок.ИсточникОтчета, ТекДок.ВыбраннаяФорма, , ТекДок.Ссылка).АктивизироватьЯчейку(Ячейка);
	Исключение
	КонецПопытки;
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// ПРОЦЕДУРЫ - ОБРАБОТЧИКИ СОБЫТИЙ ФОРМЫ

// Процедура - обработчик события ПриОткрытии формы.
//
Процедура ПриОткрытии()
	
	ТС = ВладелецТС;
	
	Для Каждого Стр Из ТС Цикл
		
		НовСтр = ТаблицаСообщений.Добавить();
		НовСтр.Отчет = Стр.Отчет;
		НовСтр.Описание = Стр.Описание;
		НовСтр.Страница = Стр.Страница;
		НовСтр.Строка = Стр.Строка;
		НовСтр.Графа = Стр.Графа;
		НовСтр.ИмяЯчейки = Стр.ИмяЯчейки;
		НовСтр.СтрокаПП = Стр.СтрокаПП;
		НовСтр.ОтчетДок = Стр.ОтчетДок;
		НовСтр.Раздел = Стр.Раздел;
			
	КонецЦикла;
	
	Надпись12 = "";
	Надпись13 = "";
	Надпись14 = "";
	Надпись15 = "";
	Надпись16 = "";
	Надпись23 = "";
	Надпись25 = "";
	СохрИнтерактивно = ВосстановитьЗначение("ПризнакИнтерактивностиНавигацииОшибок");
	Если СохрИнтерактивно <> Неопределено Тогда
		Интерактивно = СохрИнтерактивно;
	КонецЕсли;
	АктивизироватьЯчейку(ЭлементыФормы.ТаблицаСообщений.ТекущиеДанные);
	
КонецПроцедуры

// Процедура - обработчик события ПриЗакрытии формы.
//
Процедура ПриЗакрытии()
	
	СохранитьЗначение("ПризнакИнтерактивностиНавигацииОшибок", Интерактивно);
	ТаблицаСообщений.Очистить();
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// ПРОЦЕДУРЫ - ОБРАБОТЧИКИ СОБЫТИЙ ЭЛЕМЕНТОВ ФОРМЫ

// Процедура - обработчик события ПриНажатии кнопки КнопкаВперед.
//
Процедура КнопкаВпередНажатие(Элемент)
	
	ЭлементыФормы.ТаблицаСообщений.ТекущаяСтрока = ТаблицаСообщений.Получить(Мин(ТаблицаСообщений.Индекс(ЭлементыФормы.ТаблицаСообщений.ТекущиеДанные) + 1, ТаблицаСообщений.Количество() - 1));
	АктивизироватьЯчейку(ЭлементыФормы.ТаблицаСообщений.ТекущиеДанные);
	
КонецПроцедуры

// Процедура - обработчик события ПриНажатии кнопки КнопкаНазад.
//
Процедура КнопкаНазадНажатие(Элемент)
	
	ЭлементыФормы.ТаблицаСообщений.ТекущаяСтрока = ТаблицаСообщений.Получить(Макс(ТаблицаСообщений.Индекс(ЭлементыФормы.ТаблицаСообщений.ТекущиеДанные) - 1, 0));
	АктивизироватьЯчейку(ЭлементыФормы.ТаблицаСообщений.ТекущиеДанные);
	
КонецПроцедуры

// Процедура - обработчик события Выбор табличного поля ТаблицаСообщений.
//
Процедура ТаблицаСообщенийВыбор(Элемент, ВыбраннаяСтрока, Колонка, СтандартнаяОбработка)
	
	АктивизироватьЯчейку(ВыбраннаяСтрока);
	
КонецПроцедуры

// Процедура - обработчик события ПриАктивизацииСтроки табличного поля ТаблицаСообщений.
//
Процедура ТаблицаСообщенийПриАктивизацииСтроки(Элемент)
	
	Если Интерактивно Тогда
		АктивизироватьЯчейку(ЭлементыФормы.ТаблицаСообщений.ТекущиеДанные);
	КонецЕсли;
	
КонецПроцедуры
