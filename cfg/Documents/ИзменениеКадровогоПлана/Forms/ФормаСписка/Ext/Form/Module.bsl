﻿// Процедура вызывается при выборе пункта подменю "Движения документа по регистрам" меню "Перейти".
// командной панели формы. Процедура отрабатывает печать движений документа по регистрам.
//
Процедура ДействияФормыДвиженияДокументаПоРегистрам(Кнопка)

	Если ЭлементыФормы.Список.ТекущаяСтрока = Неопределено тогда
		Возврат
	КонецЕсли;

	РаботаСДиалогами.НапечататьДвиженияДокумента(ЭлементыФормы.Список.ТекущиеДанные.Ссылка);

КонецПроцедуры // ДействияФормыДвиженияДокументаПоРегистрам()
                        
// Процедура вызывается при выборе пункта подменю "Структура подчиненности" меню "Перейти".
Процедура ДействияФормыСтруктураПодчиненностиДокумента(Кнопка)
	
	Если ЭлементыФормы.Список.ТекущиеДанные = Неопределено тогда
		Возврат
	КонецЕсли;
	
	РаботаСДиалогами.ПоказатьСтруктуруПодчиненностиДокумента(ЭлементыФормы.Список.ТекущиеДанные.Ссылка);
	
КонецПроцедуры
