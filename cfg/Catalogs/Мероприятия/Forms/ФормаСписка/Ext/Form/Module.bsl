
////////////////////////////////////////////////////////////////////////////////
// ПРОЦЕДУРЫ - ДЕЙСТВИЯ КОМАНДНЫХ ПАНЕЛЕЙ ФОРМЫ

Процедура ДействияФормыДействиеПечать(Кнопка)
    Если ЭлементыФормы.СправочникСписок.ТекущаяСтрока <> Неопределено Тогда
		ЭлементыФормы.СправочникСписок.ТекущаяСтрока.ПолучитьОбъект().Печать();
	КонецЕсли;
КонецПроцедуры



