
Процедура СправочникСписокПриАктивизацииСтроки(Элемент)
	
	ЭлементыФормы.СправочникДерево.ТекущаяСтрока = ЭлементыФормы.СправочникСписок.ТекущийРодитель;
	
КонецПроцедуры

// Процедура обновляет заголовок формы по выбранному 
//  владельцу справочника
//
// Параметры: 
//  Нет.
//
// Возвращаемое значение:
//  Нет.
//
Процедура ОбновитьЗаголовок()

	Заголовок = "Список групп писем учетной записи " + УчетнаяЗапись.Наименование

КонецПроцедуры // ОбновитьЗаголовок()

////////////////////////////////////////////////////////////////////////////////
// ПРОЦЕДУРЫ - ОБРАБОТЧИКИ ИЗМЕНЕНИЯ ЗНАЧЕНИЙ РЕКВИЗИТОВ ШАПКИ

// обновляем заголовок формы
Процедура УчетнаяЗаписьПриИзменении(Элемент)

	ОбновитьЗаголовок()

КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ, ОБЩИХ ДЛЯ ВСЕЙ ФОРМЫ

Процедура ПриОткрытии()
	
	// проставляем организацию пользователя по умолчанию
	Если ПараметрВыборПоВладельцу <> Неопределено Тогда
		УчетнаяЗапись = ПараметрВыборПоВладельцу
	КонецЕсли;
	Если ПараметрОтборПоВладельцу <> Неопределено Тогда
		УчетнаяЗапись = ПараметрОтборПоВладельцу
	КонецЕсли;
	Если УчетнаяЗапись.Пустая() Тогда
		УчетнаяЗапись = УправлениеПользователями.ПолучитьЗначениеПоУмолчанию(глЗначениеПеременной("глТекущийПользователь"), "ОсновнаяУчетнаяЗапись");
	КонецЕсли;
	
	ОбновитьЗаголовок()
	
КонецПроцедуры

Процедура ПриПовторномОткрытии()

	Если ПараметрВыборПоВладельцу <> Неопределено Тогда
		УчетнаяЗапись = ПараметрВыборПоВладельцу
	КонецЕсли;
	Если ПараметрОтборПоВладельцу <> Неопределено Тогда
		УчетнаяЗапись = ПараметрОтборПоВладельцу
	КонецЕсли;

	ОбновитьЗаголовок()

КонецПроцедуры
