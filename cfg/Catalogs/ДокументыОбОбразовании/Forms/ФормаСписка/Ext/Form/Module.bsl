﻿////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ ФОРМЫ

Процедура ДействияФормыРедактироватьКод(Кнопка)
	МеханизмНумерацииОбъектов.ИзменениеВозможностиРедактированияНомера(Метаданные.Справочники.ДокументыОбОбразовании, ЭлементыФормы.СправочникСписок, ЭлементыФормы.ДействияФормы.Кнопки.Подменю, ЭлементыФормы.СправочникСписок.Колонки.Код);
КонецПроцедуры

// Обработчик события ПриОткрытии Формы.
//
Процедура ПриОткрытии()
	МеханизмНумерацииОбъектов.ДобавитьВМенюДействияКнопкуРедактированияКода(ЭлементыФормы.ДействияФормы.Кнопки.Подменю);
	МеханизмНумерацииОбъектов.УстановитьДоступностьПоляВводаНомера(Метаданные.Справочники.ДокументыОбОбразовании, ЭлементыФормы.СправочникСписок, ЭлементыФормы.ДействияФормы.Кнопки.Подменю, ЭлементыФормы.СправочникСписок.Колонки.Код);
КонецПроцедуры //ПриОткрытии
