////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ

// Обработчик события ОбработкаЗаписиНовогоОбъекта формы.
//
Процедура ОбработкаЗаписиНовогоОбъекта(Объект, Источник)

	ЭлементыФормы.СписокКлассификаторСтранМира.ТекущаяСтрока = Объект.Ссылка;

КонецПроцедуры

// Обработчик события Действие элемента КоменднаяПанель.ДействиеПодбор.
//
Процедура ДействияФормыДействиеПодбор(Кнопка)

	Справочники.КлассификаторСтранМира.ПолучитьФорму("ФормаПодбораИзКлассификатора", ЭтаФорма, "ФормаПодбораИзКлассификатора").Открыть();

КонецПроцедуры
