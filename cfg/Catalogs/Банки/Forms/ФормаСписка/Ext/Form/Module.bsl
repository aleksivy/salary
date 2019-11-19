﻿////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ, ВЫЗЫВАЕМЫЕ ИЗ ЭЛЕМЕНТОВ ФОРМЫ

// Обработчик события "ПередОткрытием" формы
Процедура ПередОткрытием(Отказ, СтандартнаяОбработка)

	СправочникСписок.Колонки.Добавить("Телефоны");
	СправочникСписок.Колонки.Добавить("Адрес");

КонецПроцедуры // ПередОткрытием()

// Обработчик события "ПриАктивизации" реквизита "Список"
Процедура СправочникСписокПриАктивизацииСтроки(Элемент)

	ИнформационнаяНадписьТелефоны="Телефоны: ";
	ИнформационнаяНадписьАдрес="Адрес: ";

	Если Элемент.ТекущиеДанные <> Неопределено И НЕ Элемент.ТекущиеДанные.ЭтоГруппа Тогда
		ИнформационнаяНадписьТелефоны="Телефоны: "+Элемент.ТекущиеДанные.Телефоны;
		ИнформационнаяНадписьАдрес="Адрес: "+Элемент.ТекущиеДанные.Адрес;
	КонецЕсли;
	
	ЭлементыФормы.СправочникДерево.ТекущаяСтрока = ЭлементыФормы.СправочникСписок.ТекущийРодитель;
	
КонецПроцедуры // СправочникСписокПриАктивизацииСтроки()

// Обработчик события Действие элемента КоменднаяПанель.ДействиеПодбор.
//
Процедура ДействияФормыДействиеПодбор(Кнопка)

	Справочники.Банки.ПолучитьФорму("ФормаПодбораИзКлассификатора", ЭтаФорма, "ФормаПодбораИзКлассификатора").Открыть();

КонецПроцедуры
