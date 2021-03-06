////////////////////////////////////////////////////////////////////////////////
// ПРОЦЕДУРЫ - ОБРАБОТЧИКИ СОБЫТИЙ ФОРМЫ

Процедура ПередОткрытием(Отказ, СтандартнаяОбработка)
	ДокументСписок.Колонки.Добавить("ПоВременнойСхемеМотивации");
КонецПроцедуры

// Процедура - обработчик события "ПриОткрытии" формы
//
Процедура ПриОткрытии()
	
	РаботаСДиалогами.УстановитьВидимостьЭУПоУчетнойПолитикеПоПерсоналу(ЭлементыФормы,глЗначениеПеременной("глУчетнаяПолитикаПоПерсоналу"));
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// ПРОЦЕДУРЫ - ДЕЙСТВИЯ КОМАНДНЫХ ПАНЕЛЕЙ ФОРМЫ

// Процедура вызывается при выборе пункта подменю "Движения документа по регистрам" меню "Перейти".
// командной панели формы. Процедура отрабатывает печать движений документа по регистрам.
//
Процедура ДействияФормыДвиженияДокументаПоРегистрам(Кнопка)

	Если ЭлементыФормы.ДокументСписок.ТекущиеДанные = Неопределено тогда
		Возврат
	КонецЕсли;

	РаботаСДиалогами.НапечататьДвиженияДокумента(ЭлементыФормы.ДокументСписок.ТекущиеДанные.Ссылка);

КонецПроцедуры // ДействияФормыДвиженияДокументаПоРегистрам()
                       
// Процедура вызывается при выборе пункта подменю "Структура подчиненности" меню "Перейти".
Процедура ДействияФормыСтруктураПодчиненностиДокумента(Кнопка)
	
	Если ЭлементыФормы.ДокументСписок.ТекущиеДанные = Неопределено тогда
		Возврат
	КонецЕсли;
	
	РаботаСДиалогами.ПоказатьСтруктуруПодчиненностиДокумента(ЭлементыФормы.ДокументСписок.ТекущиеДанные.Ссылка);
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// ПРОЦЕДУРЫ - ОБРАБОТЧИКИ СОБЫТИЙ ТАБЛИЧНОГО ПОЛЯ 

Процедура ДокументСписокПриВыводеСтроки(Элемент, ОформлениеСтроки, ДанныеСтроки)
	Если Элемент.Колонки.ПоВременнойСхемеМотивации.Видимость Тогда
		ОформлениеСтроки.Ячейки.ПоВременнойСхемеМотивации.ОтображатьКартинку = Истина;
		ОформлениеСтроки.Ячейки.ПоВременнойСхемеМотивации.ИндексКартинки = ДанныеСтроки.ПоВременнойСхемеМотивации;
	КонецЕсли;
КонецПроцедуры

