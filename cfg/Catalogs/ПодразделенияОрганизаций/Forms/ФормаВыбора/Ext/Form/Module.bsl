////////////////////////////////////////////////////////////////////////////////
// ПРОЦЕДУРЫ - ОБРАБОТЧИКИ ИЗМЕНЕНИЯ ЗНАЧЕНИЙ РЕКВИЗИТОВ ШАПКИ

// устанавливаем отбор по организации
Процедура ОрганизацияПриИзменении(Элемент)
	
	Если ЗначениеЗаполнено(Элемент.Значение) Тогда
		
		Отбор.Владелец.Использование = Истина;
		Отбор.Владелец.Значение		 = Элемент.Значение;
		
	Иначе	
		
		Отбор.Владелец.Использование = Ложь
		
	КонецЕсли; 
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ, ОБЩИХ ДЛЯ ВСЕЙ ФОРМЫ

Процедура ПриОткрытии()
	
	// проставляем организацию пользователя по умолчанию
    Если ПараметрВыборПоВладельцу <> Неопределено Тогда
        Организация = ПараметрВыборПоВладельцу
	КонецЕсли;
    Если ПараметрОтборПоВладельцу <> Неопределено Тогда
        Организация = ПараметрОтборПоВладельцу
	КонецЕсли;
	Если Организация.Пустая() Тогда
		Организация = УправлениеПользователями.ПолучитьЗначениеПоУмолчанию(глЗначениеПеременной("глТекущийПользователь"), "ОсновнаяОрганизация");
		Если Не Организация.Пустая() Тогда
			Отбор.Владелец.Использование = Истина;
			Отбор.Владелец.Значение	= Организация;
		КонецЕсли;
	КонецЕсли;
	          
КонецПроцедуры

Процедура ПриПовторномОткрытии()

	Если ПараметрВыборПоВладельцу <> Неопределено Тогда
        Организация = ПараметрВыборПоВладельцу
	КонецЕсли;
    Если ПараметрОтборПоВладельцу <> Неопределено Тогда
        Организация = ПараметрОтборПоВладельцу
	КонецЕсли;

КонецПроцедуры

Процедура ДействияФормыИерархическийПросмотр(Кнопка)
	Если Кнопка.Пометка = Истина Тогда
		ЭлементыФормы.СправочникСписок.Дерево = Ложь;
	 	ЭлементыФормы.СправочникСписок.ИерархическийПросмотр = Ложь;
		Кнопка.Пометка = Ложь;
	Иначе
		ЭлементыФормы.СправочникСписок.Дерево = Истина;
	 	ЭлементыФормы.СправочникСписок.ИерархическийПросмотр = Истина;
		Кнопка.Пометка = Истина;
	КонецЕсли;
КонецПроцедуры
