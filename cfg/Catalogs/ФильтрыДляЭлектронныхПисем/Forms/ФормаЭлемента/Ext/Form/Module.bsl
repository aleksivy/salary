
////////////////////////////////////////////////////////////////////////////////
// ПРОЦЕДУРЫ - ОБРАБОТЧИКИ СОБЫТИЙ ФОРМЫ

// Процедура - обработчик события "ПриОткрытии" формы.
//
Процедура ПриОткрытии()
	
	Если ЭтоНовый() Тогда
		Использование = Истина;
	КонецЕсли;
	
	МеханизмНумерацииОбъектов.УстановитьДоступностьПоляВводаНомера(Метаданные(), ЭтаФорма, ЭлементыФормы.ДействияФормы.Кнопки.Подменю, ЭлементыФормы.Код);	
	
КонецПроцедуры

// Процедура - обработчик события "ПередЗаписью" формы.
//
Процедура ПередЗаписью(Отказ)
	
	Если НЕ ЗначениеЗаполнено(Наименование) Тогда
		Сообщить(НСтр("ru='Не заполнено наименование';uk='Не заповнено найменування'"));
		Отказ = Истина;
	КонецЕсли;
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// ПРОЦЕДУРЫ - ОБРАБОТЧИКИ СОБЫТИЙ ЭЛЕМЕНТОВ ФОРМЫ

// Процедура - обработчик события "ПриВыводеСтроки" элемента формы "ДействияФильтра".
//
Процедура ДействияФильтраПриВыводеСтроки(Элемент, ОформлениеСтроки, ДанныеСтроки)
	
	Если ДанныеСтроки.ДействиеФильтра = Перечисления.ВидыДействийФильтровЭлектронныхПисем.ПоместитьПисьмоВПапку Тогда
		ОформлениеСтроки.Ячейки.ГруппаПисем.ТолькоПросмотр = Ложь;
	Иначе
		ОформлениеСтроки.Ячейки.ГруппаПисем.ТолькоПросмотр = Истина;
	КонецЕсли; 
	
	Если ДанныеСтроки.ДействиеФильтра = Перечисления.ВидыДействийФильтровЭлектронныхПисем.УстановитьПисьмуОформление Тогда
		ОформлениеСтроки.Ячейки.Оформление.ТолькоПросмотр = Ложь;
	Иначе
		ОформлениеСтроки.Ячейки.Оформление.ТолькоПросмотр = Истина;
	КонецЕсли; 
	
КонецПроцедуры

// Процедура - обработчик события "ПриИзменении" элемента формы "Владелец".
//
Процедура ВладелецПриИзменении(Элемент)
	
	Для каждого СтрокаТЧ Из ДействияФильтра Цикл
		
		Если ЗначениеЗаполнено(СтрокаТЧ.ГруппаПисем) И СтрокаТЧ.ГруппаПисем.Владелец <> Владелец Тогда
			СтрокаТЧ.ГруппаПисем = Справочники.ГруппыПисемЭлектроннойПочты.ПустаяСсылка();
		КонецЕсли; 
		
	КонецЦикла; 
	
КонецПроцедуры

Процедура ДействияФормыРедактироватьКод(Кнопка)
	МеханизмНумерацииОбъектов.ИзменениеВозможностиРедактированияНомера(Метаданные(), ЭтаФорма, ЭлементыФормы.ДействияФормы.Кнопки.Подменю, ЭлементыФормы.Код);
КонецПроцедуры
