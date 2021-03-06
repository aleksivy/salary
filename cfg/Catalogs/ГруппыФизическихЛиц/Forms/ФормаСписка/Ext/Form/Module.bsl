
Процедура ДействияФормыПраваДоступаПользователейКТекущемуЭлементу(Кнопка)
	
	Если Не ЭлементыФормы.СправочникСписок.ТекущиеДанные = Неопределено Тогда
		НастройкаПравДоступа.РедактироватьПраваДоступа(ЭлементыФормы.СправочникСписок.ТекущиеДанные.Ссылка);
	КонецЕсли;
	
КонецПроцедуры

Процедура ДействияФормыПраваДоступаПользователейКоВсемуСправочнику(Кнопка)
	
	НастройкаПравДоступа.РедактироватьПраваДоступа(Справочники.ГруппыФизическихЛиц.ПустаяСсылка());
	
КонецПроцедуры

Процедура ПередОткрытием(Отказ, СтандартнаяОбработка)
	
	//Если НЕ ПараметрыСеанса.ИспользоватьОграниченияПравДоступаНаУровнеЗаписей Тогда
		ЭлементыФормы.ДействияФормы.Кнопки.Удалить(ЭлементыФормы.ДействияФормы.Кнопки.Права);
		ЭлементыФормы.ДействияФормы.Кнопки.Удалить(ЭлементыФормы.ДействияФормы.Кнопки.РазделительПрава);
	//КонецЕсли;
	
КонецПроцедуры

Процедура ДействияФормыРедактироватьКод(Кнопка)
	МеханизмНумерацииОбъектов.ИзменениеВозможностиРедактированияНомера(Метаданные.Справочники.ГруппыФизическихЛиц, ЭлементыФормы.СправочникСписок, ЭлементыФормы.ДействияФормы.Кнопки.Подменю, ЭлементыФормы.СправочникСписок.Колонки.Код);
КонецПроцедуры

Процедура ПриОткрытии()
	МеханизмНумерацииОбъектов.УстановитьДоступностьПоляВводаНомера(Метаданные.Справочники.ГруппыФизическихЛиц, ЭлементыФормы.СправочникСписок, ЭлементыФормы.ДействияФормы.Кнопки.Подменю, ЭлементыФормы.СправочникСписок.Колонки.Код);
КонецПроцедуры
