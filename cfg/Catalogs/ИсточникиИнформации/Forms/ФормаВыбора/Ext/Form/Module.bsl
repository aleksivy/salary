////////////////////////////////////////////////////////////////////////////////
// ПРОЦЕДУРЫ - ОБРАБОТЧИКИ СОБЫТИЙ ТАБЛИЧНОГО ПОЛЯ СправочникСписок

Процедура СправочникСписокПриОкончанииРедактирования(Элемент, НоваяСтрока, ОтменаРедактирования)
	
	Оповестить("ЗаписанИсточникИнформации", , ВладелецФормы);
	
КонецПроцедуры

Процедура ДействияФормыРедактироватьКод(Кнопка)
	МеханизмНумерацииОбъектов.ИзменениеВозможностиРедактированияНомера(Метаданные.Справочники.ИсточникиИнформации, ЭлементыФормы.СправочникСписок, ЭлементыФормы.ДействияФормы.Кнопки.Подменю, ЭлементыФормы.СправочникСписок.Колонки.Код);
КонецПроцедуры

Процедура ПриОткрытии()
	МеханизмНумерацииОбъектов.УстановитьДоступностьПоляВводаНомера(Метаданные.Справочники.ИсточникиИнформации, ЭлементыФормы.СправочникСписок, ЭлементыФормы.ДействияФормы.Кнопки.Подменю, ЭлементыФормы.СправочникСписок.Колонки.Код);
КонецПроцедуры
