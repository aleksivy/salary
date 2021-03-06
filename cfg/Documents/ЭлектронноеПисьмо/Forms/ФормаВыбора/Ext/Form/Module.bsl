
// Процедура вызывается при выборе пункта подменю "Движения документа по регистрам" меню "Перейти".
// командной панели формы. Процедура отрабатывает печать движений документа по регистрам.
//
Процедура ДействияФормыДвиженияДокументаПоРегистрам(Кнопка)

	Если ЭлементыФормы.ДокументСписок.ТекущиеДанные = Неопределено тогда
		Возврат
	КонецЕсли;

	РаботаСДиалогами.НапечататьДвиженияДокумента(ЭлементыФормы.ДокументСписок.ТекущиеДанные.Ссылка);

КонецПроцедуры // ДействияФормыДвиженияДокументаПоРегистрам()

Процедура ДокументСписокПриВыводеСтроки(Элемент, ОформлениеСтроки, ДанныеСтроки)
	
	УправлениеЭлектроннойПочтой.ПриВыводеСтрокиЭлектронногоПисьма(Элемент, ОформлениеСтроки, ДанныеСтроки);
	
КонецПроцедуры

ДокументСписок.Колонки.Добавить("ЕстьВложения");
ДокументСписок.Колонки.Добавить("СтатусПисьма");
ДокументСписок.Колонки.Добавить("НеРассмотрено");
ДокументСписок.Колонки.Добавить("СостояниеПотомкаПисьма");
ДокументСписок.Колонки.Добавить("ПометкаУдаления");
ДокументСписок.Колонки.Добавить("СтатусПисьма");
ДокументСписок.Колонки.Добавить("ЕстьВложения");
ДокументСписок.Колонки.Добавить("УчетнаяЗапись");
