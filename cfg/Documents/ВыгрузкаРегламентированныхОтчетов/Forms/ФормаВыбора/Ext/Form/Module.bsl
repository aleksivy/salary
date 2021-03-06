
////////////////////////////////////////////////////////////////////////////////
// ПРОЦЕДУРЫ - ОБРАБОТЧИКИ СОБЫТИЙ ЭЛЕМЕНТОВ ФОРМЫ

// Процедура - обработчик события ПриВыводеСтроки табличного поля ДокументСписок.
// Формирует и показывает текст в колонке "Период" выводимой строки.
//
Процедура ДокументСписокПриВыводеСтроки(Элемент, ОформлениеСтроки, ДанныеСтроки)
	
	Док = ДанныеСтроки.Ссылка;
	Если Док = Неопределено Тогда
		Возврат;
	КонецЕсли;
	ОформлениеСтроки.Ячейки.Период.Текст = ПредставлениеПериода(НачалоДня(ДанныеСтроки.ПериодС), КонецДня(ДанныеСтроки.ПериодПо), "ФП = Истина" );
	ОформлениеСтроки.Ячейки.Период.ОтображатьТекст = Истина;
	
КонецПроцедуры

// Процедура - обработчик события Выбор табличного поля ДокументСписок.
//
Процедура ДокументСписокВыбор(Элемент, ВыбраннаяСтрока, Колонка, СтандартнаяОбработка)
	
	Если Колонка.Имя = "Период" Тогда
		Выбраннаястрока.Ссылка.ПолучитьФорму().Открыть();
	КонецЕсли;
	
КонецПроцедуры

// Процедура - обработчик события ПриВыводеСтроки табличного поля ТабличноеПолеВыгружаемыеОтчеты.
// Формирует и показывает текст в колонке "Выгружаемый отчет" выводимой строки.
//
Процедура ТабличноеПолеВыгружаемыеОтчетыПриВыводеСтроки(Элемент, ОформлениеСтроки, ДанныеСтроки)
	
	ОформлениеСтроки.Ячейки.Основание.Текст = РегламентированнаяОтчетность.ПредставлениеДокументаРеглОтч(ДанныеСтроки.Основание);
	ОформлениеСтроки.Ячейки.Основание.ОтображатьТекст = Истина;
	
КонецПроцедуры

// Процедура - обработчик события ПриАктивизацииСтроки табличного поля ДокументСписок.
// Заполняет список отчетов-оснований, тексты выгрузки. Регулирует видимость закладок,
// соответствующих версиям форматов выгрузки.
//
Процедура ДокументСписокПриАктивизацииСтроки(Элемент)
	
	ТекДанные = Элемент.ТекущиеДанные;
	ЭлементыФормы.ТабличноеПолеВыгружаемыеОтчеты.Видимость = НЕ (ТекДанные = Неопределено);
	Если ТекДанные = Неопределено Тогда
		ЭлементыФормы.ТекстыВыгрузок.Страницы.ТекстВыгрузки.Видимость = Ложь;
		ЭлементыФормы.ТекстыВыгрузок.Страницы.Формат201.Видимость = Ложь;
		ЭлементыФормы.ТекстыВыгрузок.Страницы.Формат300.Видимость = Ложь;
		Возврат;
	КонецЕсли;
	Док = ТекДанные.Ссылка;
	ТекстФормата = "";
	//ЭлементыФормы.ТекстыВыгрузок.Видимость = Ложь;
	ЭлементыФормы.ТекстыВыгрузок.Страницы.ТекстВыгрузки.Видимость = Ложь;
	ЭлементыФормы.ТекстыВыгрузок.Страницы.Формат201.Видимость = Ложь;
	ЭлементыФормы.ТекстыВыгрузок.Страницы.Формат300.Видимость = Ложь;
	Если НЕ ЗначениеЗаполнено(Док) Тогда
		Возврат;
	КонецЕсли;
	Для Каждого ТекстВыгрузки Из Док.Выгрузки Цикл
		ТекстФормата = ТекстВыгрузки.Текст;
		ЭлементыФормы.ТекстыВыгрузок.Страницы.ТекстВыгрузки.Видимость = Истина;
	КонецЦикла;
	
КонецПроцедуры

// Процедура - обработчик события Выбор табличного поля ТабличноеПолеВыгружаемыеОтчеты.
// Открывает форму текущего регламентированного отчета - основания.
//
Процедура ТабличноеПолеВыгружаемыеОтчетыВыбор(Элемент, ВыбраннаяСтрока, Колонка, СтандартнаяОбработка)
	
	ВыбраннаяСтрока.Основание.ПолучитьФорму().Открыть();
	
КонецПроцедуры

ДокументСписок.Колонки.Добавить("ПериодС");
ДокументСписок.Колонки.Добавить("ПериодПо");
