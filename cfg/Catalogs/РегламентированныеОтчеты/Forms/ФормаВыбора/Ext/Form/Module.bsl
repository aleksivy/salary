
////////////////////////////////////////////////////////////////////////////////
// ПРОЦЕДУРЫ И ФУНКЦИИ ОБЩЕГО НАЗНАЧЕНИЯ

// Отображает в форме описание регламентированного отчета.
//
// Параметры
//  ТекЭлемент – СправочникСсылка – текущий элемент справочника.
//
Процедура ПоказатьОписаниеОтчета(ТекЭлемент)

	ТекущееОписание = ТекЭлемент.Ссылка.Описание;
	ЭлементыФормы.НадписьОписаниеОтчета.Значение = ТекущееОписание;

КонецПроцедуры // ПоказатьОписаниеОтчета()


///////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ ЭЛЕМЕНТОВ ДИАЛОГА

// Процедура - обработчик события "ПриОкончанииРедактирования" табличного поля "Список" формы.
//
Процедура СписокПриОкончанииРедактирования(Элемент, НоваяСтрока, ОтменаРедактирования)

	Если Не ОтменаРедактирования Тогда
		ПоказатьОписаниеОтчета(Элемент.ТекущиеДанные);
	КонецЕсли;

КонецПроцедуры // СписокПриОкончанииРедактирования()

// Процедура - обработчик события ПриАктивизацииСтроки табличного поля "Список" формы
Процедура СписокПриАктивизацииСтроки(Элемент)
	
	ТекущиеДанные = Элемент.ТекущиеДанные;

	Если Не ТекущиеДанные = Неопределено Тогда
		ПоказатьОписаниеОтчета(Элемент.ТекущиеДанные);
	КонецЕсли;

	ЭлементыФормы.СправочникДерево.ТекущаяСтрока = ЭлементыФормы.СправочникСписок.ТекущийРодитель;

КонецПроцедуры

