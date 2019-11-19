﻿
////////////////////////////////////////////////////////////////////////////////
// ПРОЦЕДУРЫ - ДЕЙСТВИЯ КОМАНДНЫХ ПАНЕЛЕЙ ФОРМЫ

// Процедура вызывается при нажатии кнопки "Печать" командной панели формы,
// вызывает печать по умолчанию для формы документа.
//
Процедура ДействияФормыДействиеПечать(Кнопка)
	Если ЭлементыФормы.ДокументСписок.ТекущаяСтрока <> Неопределено Тогда

		Попытка
			УниверсальныеМеханизмы.НапечататьДокументИзФормыСписка(ЭлементыФормы.ДокументСписок.ТекущаяСтрока.ПолучитьОбъект())
		Исключение
		КонецПопытки
			
	КонецЕсли;
КонецПроцедуры

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
