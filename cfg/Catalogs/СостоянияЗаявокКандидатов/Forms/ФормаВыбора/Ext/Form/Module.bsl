////////////////////////////////////////////////////////////////////////////////
// ПРОЦЕДУРЫ - ОБРАБОТЧИКИ СОБЫТИЙ ТАБЛИЧНОГО ПОЛЯ СправочникСписок

Процедура СправочникСписокПриОкончанииРедактирования(Элемент, НоваяСтрока, ОтменаРедактирования)
	
	Оповестить("ЗаписаноСостояниеЗаявки", , ВладелецФормы);
	
КонецПроцедуры

Процедура ДействияФормыРедактироватьКод(Кнопка)
	МеханизмНумерацииОбъектов.ИзменениеВозможностиРедактированияНомера(Метаданные.Справочники.СостоянияЗаявокКандидатов, ЭлементыФормы.СправочникСписок, ЭлементыФормы.ДействияФормы.Кнопки.Подменю, ЭлементыФормы.СправочникСписок.Колонки.Код);
КонецПроцедуры

Процедура ПриОткрытии()
	МеханизмНумерацииОбъектов.УстановитьДоступностьПоляВводаНомера(Метаданные.Справочники.СостоянияЗаявокКандидатов, ЭлементыФормы.СправочникСписок, ЭлементыФормы.ДействияФормы.Кнопки.Подменю, ЭлементыФормы.СправочникСписок.Колонки.Код);
КонецПроцедуры
