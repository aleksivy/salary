﻿// Процедура вызывается при выборе пункта подменю "Движения документа по регистрам" меню "Перейти".
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

// Процедура вызывается при выборе пункта подменю "ГрафикОтпусковОрганизаций" меню "ВводНаОсновании"
//
Процедура ДействияФормыГрафикОтпусковОрганизацийВводНаОсновании(Кнопка)
	
	Если ЭлементыФормы.ДокументСписок.ТекущиеДанные = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	ПроцедурыУправленияПерсоналом.ВводРегламентированногоКадровогоДокументаНаОсновании(ЭлементыФормы.ДокументСписок.ТекущиеДанные.Ссылка);
	
КонецПроцедуры
