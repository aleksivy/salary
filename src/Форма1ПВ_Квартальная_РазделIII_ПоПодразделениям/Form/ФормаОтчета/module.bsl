// УстановитьОтбор
//
Процедура УстановитьОтбор(КомпоновщикНастроек, ИмяПараметра, ЗначениеПараметра, ВидСравнения, ФильтроватьПустые = Ложь)
	ЭлементОтбора = КомпоновщикНастроек.Настройки.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ЭлементОтбора.ЛевоеЗначение = Новый ПолеКомпоновкиДанных(ИмяПараметра);
	ЭлементОтбора.РежимОтображения = РежимОтображенияЭлементаНастройкиКомпоновкиДанных.Обычный;
	ЭлементОтбора.ПравоеЗначение = ЗначениеПараметра;	
	ЭлементОтбора.ВидСравнения = ВидСравнения;
	ЭлементОтбора.Использование = (ФильтроватьПустые или ЗначениеЗаполнено(ЗначениеПараметра));
КонецПроцедуры

// УстановитьПараметр
//
Процедура УстановитьПараметр(КомпоновщикНастроек, ИмяПараметра, ЗначениеПараметра)
	ПараметрДанныхТекущий = КомпоновщикНастроек.Настройки.ПараметрыДанных.НайтиЗначениеПараметра(Новый ПараметрКомпоновкиДанных(ИмяПараметра));
	ПараметрДанныхТекущий.Значение = ЗначениеПараметра;
	ПараметрДанныхТекущий.Использование = ЗначениеЗаполнено(ЗначениеПараметра);
КонецПроцедуры

Процедура УстановитьПараметрыОтборы()
	УстановитьПараметр(КомпоновщикНастроек, "НачалоПериода", НачалоПериода);
	УстановитьПараметр(КомпоновщикНастроек, "КонецПериода", КонецПериода);
	УстановитьПараметр(КомпоновщикНастроек, "ВнутреннееСовместительство", Перечисления.ВидыЗанятостиВОрганизации.ВнутреннееСовместительство);
	УстановитьПараметр(КомпоновщикНастроек, "ОсновноеМестоРаботы", Перечисления.ВидыЗанятостиВОрганизации.ОсновноеМестоРаботы);
	УстановитьПараметр(КомпоновщикНастроек, "парамОрганизация", глЗначениеПеременной("ОсновнаяОрганизация"));
КонецПроцедуры

Процедура ПриОткрытии()
	Если Не ЗначениеЗаполнено(НачалоПериода) Тогда НачалоПериода = НачалоКвартала( НачалоМесяца( ТекущаяДата() ) - 1 ); КонецЕсли;
	Если Не ЗначениеЗаполнено(КонецПериода) Тогда 
		Если ЗначениеЗаполнено(НачалоПериода) Тогда
			КонецПериода = КонецКвартала( НачалоПериода ); 
		Иначе
			КонецПериода = КонецКвартала( НачалоМесяца( ТекущаяДата() ) - 1 ); 
		КонецЕсли;
	КонецЕсли;
	УстановитьПараметрыОтборы();
КонецПроцедуры

Процедура НачалоПериодаПриИзменении(Элемент)
	Если Не ЗначениеЗаполнено(НачалоПериода) Тогда НачалоПериода = НачалоМесяца( НачалоМесяца( ТекущаяДата() ) - 1 ); КонецЕсли;
	УстановитьПараметрыОтборы();
КонецПроцедуры

Процедура КонецПериодаПриИзменении(Элемент)
	Если Не ЗначениеЗаполнено(КонецПериода) Тогда 
		Если ЗначениеЗаполнено(НачалоПериода) Тогда
			КонецПериода = КонецКвартала( НачалоПериода ); 
		Иначе
			КонецПериода = КонецКвартала( НачалоМесяца( ТекущаяДата() ) - 1 ); 
		КонецЕсли;
	КонецЕсли;
	УстановитьПараметрыОтборы();
КонецПроцедуры
