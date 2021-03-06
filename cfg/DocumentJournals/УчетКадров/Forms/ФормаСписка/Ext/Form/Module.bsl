Перем	мИмяОбъектаМетаданных;

////////////////////////////////////////////////////////////////////////////////
// ПРОЦЕДУРЫ И ФУНКЦИИ ОБЩЕГО НАЗНАЧЕНИЯ

// Процедура выполняет запись новой строки в истории ввода
//
Процедура ДополнитьИсторию()

	СписокДляИстории = Новый СписокЗначений();
	СписокДляИстории.Добавить(Отбор.ДокументыПоРаботнику.Значение);
	
	РаботаСДиалогами.ДополнитьСписокИсторииВвода(мИмяОбъектаМетаданных + "." + "ФизЛицо", СписокДляИстории);

КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// ПРОЦЕДУРЫ - ДЕЙСТВИЯ КОМАНДНЫХ ПАНЕЛЕЙ ФОРМЫ


// Процедура вызывается при выборе пункта подменю "Движения документа по регистрам" меню "Перейти".
// командной панели формы. Процедура отрабатывает печать движений документа по регистрам.
//
Процедура ДействияФормыДвиженияДокументаПоРегистрам(Кнопка)
	
	Если ЭтаФорма.ЭлементыФормы.Список.ТекущаяСтрока = Неопределено тогда
		Возврат
	КонецЕсли;

	РаботаСДиалогами.НапечататьДвиженияДокумента(ЭлементыФормы.Список.ТекущиеДанные.Ссылка);
	
КонецПроцедуры // ДействияФормыДвиженияДокументаПоРегистрам()

Процедура ДействияФормыСтруктураПодчиненностиДокумента(Кнопка)
	
	Если ЭлементыФормы.Список.ТекущиеДанные = Неопределено тогда
		Возврат
	КонецЕсли;
	
	ФормаСтруктурыПодчиненности = ПолучитьОбщуюФорму("ФормаСтруктурыПодчиненности", ЭтаФорма);
	Если ФормаСтруктурыПодчиненности.Открыта() Тогда
		ФормаСтруктурыПодчиненности.Закрыть();
	КонецЕсли;
	ФормаСтруктурыПодчиненности.ДокументСсылка = ЭлементыФормы.Список.ТекущиеДанные.Ссылка;
	ФормаСтруктурыПодчиненности.Открыть();
	
КонецПроцедуры


// Процедура вызывается при нажатии кнопки "Печать" командной панели формы,
// вызывает печать по умолчанию для формы документа.
//
Процедура ДействияФормыДействиеПечать(Кнопка)
	Если ЭлементыФормы.Список.ТекущаяСтрока <> Неопределено Тогда

		Попытка
			УниверсальныеМеханизмы.НапечататьДокументИзФормыСписка(ЭлементыФормы.Список.ТекущаяСтрока.ПолучитьОбъект())
		Исключение
		КонецПопытки
			
	КонецЕсли;
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ ЭЛЕМЕНТОВ УПРАВЛЕНИЯ

// Процедура - обработчик события "ПриИзменении" поля ввода Физ Лицо.
//
Процедура ФизЛицоПриИзменении(Элемент)

	ДополнитьИсторию();
	Отбор.ДокументыПоРаботнику.Использование = ЗначениеЗаполнено(Элемент.Значение);

КонецПроцедуры

// Процедура - обработчик события "НачалоВыбораИзСписка" поля ввода Физ Лицо.
//
Процедура ФизЛицоНачалоВыбораИзСписка(Элемент, СтандартнаяОбработка)

	СтандартнаяОбработка = Ложь;
	НовоеЗначение = ВыбратьИзСписка(РаботаСДиалогами.ПолучитьСписокИсторииВвода(мИмяОбъектаМетаданных + "." + "ФизЛицо"), Элемент);

	Если НовоеЗначение <> Неопределено Тогда
		Если ТипЗнч(НовоеЗначение.Значение) = Тип("СписокЗначений") Тогда
			Элемент.Значение = НовоеЗначение.Значение.Получить(0).Значение;
		КонецЕсли;

		// При изменении
		ДополнитьИсторию();
		Отбор.ДокументыПоРаботнику.Использование = ЗначениеЗаполнено(Элемент.Значение);
	КонецЕсли;

КонецПроцедуры

мИмяОбъектаМетаданных =  "ЖурналДокументов.УчетКадровКомпании";
