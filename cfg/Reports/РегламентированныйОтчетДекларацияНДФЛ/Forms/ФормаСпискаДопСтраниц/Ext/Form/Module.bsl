﻿////////////////////////////////////////////////////////////////////////////////
// ПЕРЕМЕННЫЕ МОДУЛЯ

Перем мТаблицаСтраницРаздела;
Перем мФлагМодифицированности;


////////////////////////////////////////////////////////////////////////////////
// ПРОЦЕДУРЫ И ФУНКЦИИ ОБЩЕГО НАЗНАЧЕНИЯ

// Процедура модифицирует таблицу значений - начальное значение выбора
// и передает владельцу формы выбранное значение.
//
Процедура ВывестиВыбраннуюСтраницу(ВыбраннаяСтрока)

	// сначала снимем признак активной страницы с текущей
	// страницы (на момент открытия формы списка страниц)
	ТекСтраницаРаздела = мТаблицаСтраницРаздела.Найти(Истина, "АктивнаяСтраница");

	Если ТекСтраницаРаздела <> Неопределено Тогда
		ТекСтраницаРаздела.АктивнаяСтраница = Ложь;
	КонецЕсли;

	ВыбраннаяСтрока.АктивнаяСтраница = Истина;

	ВозвращаемыеПараметры = Новый Структура;
	ВозвращаемыеПараметры.Вставить("ТаблицаСтраницРаздела",  мТаблицаСтраницРаздела);
	ВозвращаемыеПараметры.Вставить("ФлагМодифицированности", мФлагМодифицированности);

	Закрыть(ВозвращаемыеПараметры);

КонецПроцедуры // ВывестиВыбраннуюСтраницу()


////////////////////////////////////////////////////////////////////////////////
// ПРОЦЕДУРЫ - ОБРАБОТЧИКИ СОБЫТИЙ ФОРМЫ

// Процедура - обработчик события "ПриОткрытии" формы.
//
Процедура ПриОткрытии()

	мТаблицаСтраницРаздела = НачальноеЗначениеВыбора.Скопировать();

	ЭлементыФормы.ТаблицаДопСтраниц.Значение = мТаблицаСтраницРаздела;
	ЭлементыФормы.ТаблицаДопСтраниц.Колонки.Представление.Данные = "Представление";

	// отметим строку таблицы, соответствующую текущей активной странице
	// многостраничного раздела
	ТекСтраницаРаздела = мТаблицаСтраницРаздела.Найти(Истина, "АктивнаяСтраница");

	Если ТекСтраницаРаздела <> Неопределено Тогда
		ЭлементыФормы.ТаблицаДопСтраниц.ТекущаяСтрока = ТекСтраницаРаздела;
	КонецЕсли;

КонецПроцедуры // ПриОткрытии()

// Процедура - обработчик события ПриИзменении поля ввода табличного поля.
//
Процедура ТаблицаДопСтраницПредставлениеПриИзменении(Элемент)

	мФлагМодифицированности = Истина;

КонецПроцедуры // ТаблицаДопСтраницПредставлениеПриИзменении()

// Процедура - обработчик выбора строки табличного поля ТаблицаДопСтраниц.
// Вызывается при двойном щелчке мыши или нажатии Enter.
//
Процедура ТаблицаДопСтраницВыбор(Элемент, ВыбраннаяСтрока, Колонка, СтандартнаяОбработка)

	ВывестиВыбраннуюСтраницу(ВыбраннаяСтрока);

КонецПроцедуры // ТаблицаДопСтраницВыбор()


////////////////////////////////////////////////////////////////////////////////
// ПРОЦЕДУРЫ - ДЕЙСТВИЯ КОМАНДНЫХ ПАНЕЛЕЙ ФОРМЫ

// Процедура вызывается при нажатии кнопки "ОК" командной панели формы.
// Отрабатывает выбранное значение - страницу многостраничного раздела.
//
Процедура ОсновныеДействияФормыКнопкаВыбратьНажатие(Кнопка)

	ВыбраннаяСтрока = ЭлементыФормы.ТаблицаДопСтраниц.ТекущаяСтрока;
	ВывестиВыбраннуюСтраницу(ВыбраннаяСтрока);

КонецПроцедуры // ОсновныеДействияФормыКнопкаВыбратьНажатие()


////////////////////////////////////////////////////////////////////////////////
// ОПЕРАТОРЫ ОСНОВНОЙ ПРОГРАММЫ

мФлагМодифицированности = Ложь;








