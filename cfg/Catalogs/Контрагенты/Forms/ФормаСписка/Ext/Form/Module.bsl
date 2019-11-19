﻿////////////////////////////////////////////////////////////////////////////////
// ПРОЦЕДУРЫ - ОБРАБОТЧИКИ СОБЫТИЙ ЭЛЕМЕНТОВ ФОРМЫ

// Процедура - обработчик события "ПриАктивизацииСтроки" элемента формы СправочникСписок.
//
Процедура СправочникСписокПриАктивизацииСтроки(Элемент)
	
	ЭлементыФормы.СправочникДерево.ТекущаяСтрока = ЭлементыФормы.СправочникСписок.ТекущийРодитель;
	
КонецПроцедуры

Процедура ДействияФормыПодбор(Кнопка)
	
	Справочники.Контрагенты.ПолучитьФорму("ФормаПодбораИзКлассификатора", ЭтаФорма, "ФормаПодбораИзКлассификатора").Открыть();
	
КонецПроцедуры
