﻿////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ ФОРМЫ


Процедура ДействияФормыРедактироватьКод(Кнопка)
	МеханизмНумерацииОбъектов.ИзменениеВозможностиРедактированияНомера(Метаданные.ПланыВидовХарактеристик.НазначенияСвойствКатегорийОбъектов, ЭлементыФормы.ПланВидовХарактеристикСписок, ЭлементыФормы.ДействияФормы.Кнопки.Подменю, ЭлементыФормы.ПланВидовХарактеристикСписок.Колонки.Код);
КонецПроцедуры
// Обработчик события ПриОткрытии Формы.
//
Процедура ПриОткрытии()

	МеханизмНумерацииОбъектов.ДобавитьВМенюДействияКнопкуРедактированияКода(ЭлементыФормы.ДействияФормы.Кнопки.Подменю);
	МеханизмНумерацииОбъектов.УстановитьДоступностьПоляВводаНомера(Метаданные.ПланыВидовХарактеристик.НазначенияСвойствКатегорийОбъектов, ЭлементыФормы.ПланВидовХарактеристикСписок, ЭлементыФормы.ДействияФормы.Кнопки.Подменю, ЭлементыФормы.ПланВидовХарактеристикСписок.Колонки.Код);
КонецПроцедуры //ПриОткрытии
