﻿////////////////////////////////////////////////////////////////////////////////
// ПЕРЕМЕННЫЕ МОДУЛЯ

Перем мДлинаСуток;
Перем мОбработкаТайпинга;
Перем мТекстТайпинга;
Перем мПоследнееЗначениеЭлементаТайпинга;

Перем мЗаголовокФормы;

////////////////////////////////////////////////////////////////////////////////
// ПРОЦЕДУРЫ И ФУНКЦИИ ОБЩЕГО НАЗНАЧЕНИЯ

// Функция формирует структуру параметров для для ввода головной организации по подстроке
//
// Параметры
//  НЕТ
//
// Возвращаемое значение:
//   Структура имен и значений параметров
//
Функция ПолучитьСтруктуруПараметровТайпинга()

	СтруктураПараметров = Новый Структура("ГоловнаяОрганизация", Справочники.Организации.ПустаяСсылка());
	
	Возврат СтруктураПараметров;

КонецФункции // ПолучитьСтруктуруПараметровТайпинга()()

////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ КОМАНДНОЙ ПАНЕЛИ ФОРМЫ

// Процедура формирует документ "Командировки организации".
Процедура ДействияФормыКомандировкиОрганизации(Кнопка)
	
	ДанныеСтроки = ЭлементыФормы.РаботникиОрганизации.ТекущиеДанные;
	
	Если ДанныеСтроки = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	НовыйДокумент = Документы.КомандировкиОрганизаций.СоздатьДокумент();
	ЗаполнениеДокументов.ЗаполнитьШапкуДокумента(НовыйДокумент);
	НовыйДокумент.УстановитьНовыйНомер();
	НоваяСтрока = НовыйДокумент.РаботникиОрганизации.Добавить();
	НоваяСтрока.Сотрудник	= ДанныеСтроки.Сотрудник;
	НоваяСтрока.ДатаНачала	= РабочаяДата;
	НовыйДокумент.ПолучитьФорму().Открыть();
	
КонецПроцедуры

// Процедура формирует документ "Отпуска организации".
Процедура ДействияФормыОтпускаОрганизации(Кнопка)
	
	ДанныеСтроки = ЭлементыФормы.РаботникиОрганизации.ТекущиеДанные;
	
	Если ДанныеСтроки = Неопределено Тогда
		Возврат
	КонецЕсли;
	
	НовыйДокумент = Документы.ОтпускаОрганизаций.СоздатьДокумент();
	ЗаполнениеДокументов.ЗаполнитьШапкуДокумента(НовыйДокумент);
	НовыйДокумент.УстановитьНовыйНомер();
	НоваяСтрока = НовыйДокумент.РаботникиОрганизации.Добавить();
	НоваяСтрока.Сотрудник	= ДанныеСтроки.Сотрудник;
	НоваяСтрока.ДатаНачала	= РабочаяДата;
	НовыйДокумент.ПолучитьФорму().Открыть();
	
КонецПроцедуры

// Процедура формирует документ "Отсутствие на работе в организации".
Процедура ДействияФормыОтсутствиеНаРаботе(Кнопка)
	
	ДанныеСтроки = ЭлементыФормы.РаботникиОрганизации.ТекущиеДанные;
	
	Если ДанныеСтроки = Неопределено Тогда
		Возврат
	КонецЕсли;
	
	НовыйДокумент = Документы.ОтсутствиеНаРаботеОрганизаций.СоздатьДокумент();
	ЗаполнениеДокументов.ЗаполнитьШапкуДокумента(НовыйДокумент);
	НовыйДокумент.УстановитьНовыйНомер();
	НоваяСтрока = НовыйДокумент.РаботникиОрганизации.Добавить();
	НоваяСтрока.Сотрудник	= ДанныеСтроки.Сотрудник;
	НоваяСтрока.ДатаНачала	= РабочаяДата;
	НовыйДокумент.ПолучитьФорму().Открыть();
	
КонецПроцедуры

// Процедура формирует документ "Возврат на работу организации".
//
Процедура ДействияФормыВозвратНаРаботу(Кнопка)
	
	ДанныеСтроки = ЭлементыФормы.РаботникиОрганизации.ТекущиеДанные;
	
	Если ДанныеСтроки = Неопределено Тогда
		Возврат
	КонецЕсли;
	
	НовыйДокумент = Документы.ВозвратНаРаботуОрганизаций.СоздатьДокумент();
	ЗаполнениеДокументов.ЗаполнитьШапкуДокумента(НовыйДокумент);
	НовыйДокумент.УстановитьНовыйНомер();
	НоваяСтрока = НовыйДокумент.РаботникиОрганизации.Добавить();
	НоваяСтрока.Сотрудник		= ДанныеСтроки.Сотрудник;
	НоваяСтрока.ДатаВозврата	= РабочаяДата;
	НовыйДокумент.ПолучитьФорму().Открыть();
	
КонецПроцедуры

// Процедура открывает форму списка регистра.
//
Процедура ДействияФормыИстория(Кнопка)
	
	Если Кнопка.Пометка Тогда
		Кнопка.Пометка = Ложь;
		ЭлементыФормы.РаботникиОрганизации.ВыбиратьСрез = ИспользованиеСреза.Последние;
	Иначе
		Кнопка.Пометка = Истина;
		ЭлементыФормы.РаботникиОрганизации.ВыбиратьСрез = ИспользованиеСреза.НеИспользовать;
	КонецЕсли;
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ ФОРМЫ

// Процедура - обработчик события "ПриОткрытии" формы
//
Процедура ПриОткрытии()

	мЗаголовокФормы = НСтр("ru='Состояние работников организации ';uk='Стан працівників організації '");
	
	// заполним организацию
	РаботаСДиалогами.ЗаполнениеОтбораПоОрганизацииПоУмолчанию(ЭтаФорма, Отбор.Организация, ЭлементыФормы.Организация, ПараметрОтборПоРегистратору, Ложь, глЗначениеПеременной("глТекущийПользователь"),мЗаголовокФормы);

	РаботаСДиалогами.УстановитьВидимостьЭУПоУчетнойПолитикеПоПерсоналу(ЭлементыФормы,глЗначениеПеременной("глУчетнаяПолитикаПоПерсоналуОрганизации")[ЭлементыФормы.Организация.Значение]);
	
	ЭлементыФормы.ДействияФормы.Кнопки.История.Пометка = Истина;

КонецПроцедуры

// Процедура - обработчик события "ПриПовторномОткрытии" формы
//
Процедура ПриПовторномОткрытии(СтандартнаяОбработка)
	
	// заполним организацию
	РаботаСДиалогами.ЗаполнениеОтбораПоОрганизацииПоУмолчанию(ЭтаФорма, Отбор.Организация, ЭлементыФормы.Организация, ПараметрОтборПоРегистратору, Ложь, глЗначениеПеременной("глТекущийПользователь"),мЗаголовокФормы);

	РаботаСДиалогами.УстановитьВидимостьЭУПоУчетнойПолитикеПоПерсоналу(ЭлементыФормы,глЗначениеПеременной("глУчетнаяПолитикаПоПерсоналуОрганизации")[ЭлементыФормы.Организация.Значение]);		
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ ЭЛЕМЕНТОВ УПРАВЛЕНИЯ

// Процедура прописывает заголовок формы 
//
// Параметры:
//  Элемент - элемент формы, который отображает организацию
//  
Процедура ОрганизацияПриИзменении(Элемент)

	Заголовок = мЗаголовокФормы + Элемент.Значение.Наименование;
    Отбор.Организация.Использование = Не Элемент.Значение.Пустая();
	
	РаботаСДиалогами.УстановитьВидимостьЭУПоУчетнойПолитикеПоПерсоналу(ЭлементыФормы,глЗначениеПеременной("глУчетнаяПолитикаПоПерсоналуОрганизации")[ЭлементыФормы.Организация.Значение]);	
	
КонецПроцедуры

Процедура ОрганизацияНачалоВыбора(Элемент, СтандартнаяОбработка)
	СтандартнаяОбработка = Ложь;
	СписокВыбора = ПроцедурыУправленияПерсоналом.ПолучитьСписокОрганизаций();
	ЭлементСписка = ВыбратьИзСписка(СписокВыбора,Элемент,СписокВыбора.НайтиПоЗначению(Элемент.Значение));
	Если ЭлементСписка <> Неопределено Тогда
		Элемент.Значение = ЭлементСписка.Значение;
		ОрганизацияПриИзменении(Элемент);
	КонецЕсли;
КонецПроцедуры

Процедура ОрганизацияАвтоПодборТекста(Элемент, Текст, ТекстАвтоПодбора, СтандартнаяОбработка)
	
	ПроцедурыПоискаПоСтроке.АвтоПодборТекстаВЭлементеУправления(Элемент, Текст, ТекстАвтоПодбора, СтандартнаяОбработка, ПолучитьСтруктуруПараметровТайпинга(), Тип("СправочникСсылка.Организации"));
	
КонецПроцедуры

Процедура ОрганизацияОкончаниеВводаТекста(Элемент, Текст, Значение, СтандартнаяОбработка)
	
	ПроцедурыПоискаПоСтроке.ОкончаниеВводаТекстаВЭлементеУправления(Элемент, Текст, Значение, СтандартнаяОбработка, ПолучитьСтруктуруПараметровТайпинга(), ЭтаФорма, Тип("СправочникСсылка.Организации"), мОбработкаТайпинга, мТекстТайпинга, мПоследнееЗначениеЭлементаТайпинга, Ложь);
	
КонецПроцедуры

Процедура РаботникиОрганизацииВыбор(Элемент, ВыбраннаяСтрока, Колонка, СтандартнаяОбработка)
	
	Если не ЭлементыФормы.ДействияФормы.Кнопки.История.Пометка Тогда
		ВыбраннаяСтрока.Физлицо.ПолучитьФорму().Открыть();
		СтандартнаяОбработка = Ложь;
	КонецЕсли;

КонецПроцедуры

Процедура РаботникиОрганизацииПриВыводеСтроки(Элемент, ОформлениеСтроки, ДанныеСтроки)
	Если Элемент.Колонки.ПериодЗавершения.Видимость Тогда
		ОформлениеСтроки.Ячейки.ПериодЗавершения.ОтображатьТекст = Истина;
		ОформлениеСтроки.Ячейки.ПериодЗавершения.УстановитьТекст(Формат(ДанныеСтроки.ПериодЗавершения - мДлинаСуток, "ДФ=dd.MM.yyyy"));
	КонецЕсли;
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// ОПЕРАТОРЫ ОСНОВНОЙ ПРОГРАММЫ

мДлинаСуток = 86400;
мОбработкаТайпинга                 = Ложь;
мТекстТайпинга                     = "";
мПоследнееЗначениеЭлементаТайпинга = Справочники.Организации.ПустаяСсылка();
