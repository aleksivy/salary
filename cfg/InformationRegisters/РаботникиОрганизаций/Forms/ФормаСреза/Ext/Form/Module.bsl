////////////////////////////////////////////////////////////////////////////////
// ПЕРЕМЕННЫЕ МОДУЛЯ

Перем мЗаголовокФормы;
Перем мДлинаСуток;

////////////////////////////////////////////////////////////////////////////////
// ПРОЦЕДУРЫ И ФУНКЦИИ ОБЩЕГО НАЗНАЧЕНИЯ

// Открывает форму нового приказа о приеме на работу
//
// Параметры
//  нет
//
Процедура ОткрытьНовыйПриказОПриеме()

	Организация = Отбор.ОбособленноеПодразделение.Значение;
	Если НЕ ЗначениеЗаполнено(Организация) Тогда
		Организация = УправлениеПользователями.ПолучитьЗначениеПоУмолчанию(глЗначениеПеременной("глТекущийПользователь"),"ОсновнаяОрганизация");
	КонецЕсли;
	
	НовыйДокумент = Документы.ПриемНаРаботуВОрганизацию.СоздатьДокумент();
	ЗаполнениеДокументов.ЗаполнитьШапкуДокумента(НовыйДокумент);
	НовыйДокумент.Организация = Организация;
	НовыйДокумент.УстановитьНовыйНомер();
	
	НовыйДокумент.ПолучитьФорму().Открыть();

КонецПроцедуры // ОткрытьНовыйПриказОПриеме()

////////////////////////////////////////////////////////////////////////////////
// ПРОЦЕДУРЫ - ОБРАБОТЧИКИ СОБЫТИЙ ФОРМЫ

// Процедура - обработчик события "ПередОткрытием" формы.
//
Процедура ПередОткрытием(Отказ, СтандартнаяОбработка)
	
	// настройка порядка
	ЭлементыФормы.РаботникиОрганизации.НастройкаПорядка.Сотрудник.Доступность = Истина;
	
КонецПроцедуры // ПередОткрытием()

// Процедура - обработчик события "ПриОткрытии" формы
//
Процедура ПриОткрытии()
	
	мЗаголовокФормы = НСтр("ru='Работники организации ';uk='Працівники організації '");
	// заполним организацию
	РаботаСДиалогами.ЗаполнениеОтбораПоОрганизацииПоУмолчанию(ЭтаФорма, Отбор.ОбособленноеПодразделение, ЭлементыФормы.Организация, ПараметрОтборПоРегистратору, Ложь, глЗначениеПеременной("глТекущийПользователь"), мЗаголовокФормы);

	СтруктураКолонок = Новый Структура();

	// Установить колонки, видимостью которых пользователь управлять не может.
	СтруктураКолонок.Вставить("Сотрудник");
	
	// Установить ограничение - изменять видимость колонок для табличной части 
	ОбработкаТабличныхЧастей.УстановитьИзменятьВидимостьКолонокТабЧасти(ЭлементыФормы.РаботникиОрганизации.Колонки, СтруктураКолонок);
	РаботникиОрганизации.Колонки.Добавить("ПричинаИзмененияСостояния", Ложь);
	
	ЭлементыФормы.ДействияФормы.Кнопки.История.Пометка					= Истина;
	ЭлементыФормы.ДействияФормы.Кнопки.Подменю.Кнопки.История.Пометка	= Истина;
	
	РаботаСДиалогами.УстановитьВидимостьЭУПоУчетнойПолитикеПоПерсоналу(ЭлементыФормы,глЗначениеПеременной("глУчетнаяПолитикаПоПерсоналуОрганизации")[ЭлементыФормы.Организация.Значение]);	
	
	Если НЕ Отбор.Регистратор.Использование Тогда

		Отбор.Период.Использование = Истина;
		Отбор.Период.ВидСравнения =ВидСравнения.МеньшеИлиРавно;
		Отбор.Период.Значение = ОбщегоНазначения.ПолучитьРабочуюДату();
	КонецЕсли;	
		
	
	Порядок.Установить("Сотрудник ВОЗР");
	
КонецПроцедуры // ПриОткрытии()

// Процедура - обработчик события "ПриПовторномОткрытии" формы
//
Процедура ПриПовторномОткрытии(СтандартнаяОбработка)
	
	// заполним организацию
	РаботаСДиалогами.ЗаполнениеОтбораПоОрганизацииПоУмолчанию(ЭтаФорма, Отбор.ОбособленноеПодразделение, ЭлементыФормы.Организация, ПараметрОтборПоРегистратору, Ложь, глЗначениеПеременной("глТекущийПользователь"),мЗаголовокФормы);

	РаботаСДиалогами.УстановитьВидимостьЭУПоУчетнойПолитикеПоПерсоналу(ЭлементыФормы,глЗначениеПеременной("глУчетнаяПолитикаПоПерсоналуОрганизации")[ЭлементыФормы.Организация.Значение]);	
	
КонецПроцедуры // ПриПовторномОткрытии()

////////////////////////////////////////////////////////////////////////////////
// ПРОЦЕДУРЫ - ДЕЙСТВИЯ КОМАНДНЫХ ПАНЕЛЕЙ ФОРМЫ

// Процедура формирует документ "Прием на работу".
Процедура ДействияФормыПриемНаРаботу(Кнопка)
	
	ОткрытьНовыйПриказОПриеме();
	
КонецПроцедуры // ДействияФормыПриемНаРаботу()

// Процедура формирует документ "Приказ об увольнении".
//
Процедура ДействияФормыПриказОбУвольнении(Кнопка)
	
	ТекущиеДанные = ЭлементыФормы.РаботникиОрганизации.ТекущиеДанные;
	
	Если ТекущиеДанные = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	Организация = Отбор.ОбособленноеПодразделение.Значение;
	Если НЕ ЗначениеЗаполнено(Организация) Тогда
		Организация = УправлениеПользователями.ПолучитьЗначениеПоУмолчанию(глЗначениеПеременной("глТекущийПользователь"),"ОсновнаяОрганизация");
	КонецЕсли;
	
	НовыйДокумент = Документы.УвольнениеИзОрганизаций.СоздатьДокумент();
	ЗаполнениеДокументов.ЗаполнитьШапкуДокумента(НовыйДокумент);
	НовыйДокумент.Организация = ТекущиеДанные.Сотрудник.Организация;
	НовыйДокумент.УстановитьНовыйНомер();
	
	НоваяСтрока	= НовыйДокумент.РаботникиОрганизации.Добавить();
	НоваяСтрока.Сотрудник		= ТекущиеДанные.Сотрудник;
	НоваяСтрока.ДатаУвольнения	= ОбщегоНазначения.ПолучитьРабочуюДату();
	
	НовыйДокумент.ПолучитьФорму().Открыть();
	
КонецПроцедуры // ДействияФормыПриказОбУвольнении()

// Процедуда формирует документ "Кадровое перемещение".
//
Процедура ДействияФормыКадровоеПеремещение(Кнопка)
	
	ТекущиеДанные = ЭлементыФормы.РаботникиОрганизации.ТекущиеДанные;
	
	Если ТекущиеДанные = Неопределено Тогда
		Возврат
	КонецЕсли;
	
	Организация = Отбор.ОбособленноеПодразделение.Значение;
	Если НЕ ЗначениеЗаполнено(Организация) Тогда
		Организация = УправлениеПользователями.ПолучитьЗначениеПоУмолчанию(глЗначениеПеременной("глТекущийПользователь"), "ОсновнаяОрганизация");
	КонецЕсли;
	
	НовыйДокумент = Документы.КадровоеПеремещениеОрганизаций.СоздатьДокумент();
	ЗаполнениеДокументов.ЗаполнитьШапкуДокумента(НовыйДокумент);
	НовыйДокумент.УстановитьНовыйНомер();
	НовыйДокумент.Организация = ТекущиеДанные.Сотрудник.Организация;
	
	НоваяСтрока = НовыйДокумент.РаботникиОрганизации.Добавить();
	НоваяСтрока.Сотрудник			= ТекущиеДанные.Сотрудник;
	НоваяСтрока.ЗанимаемыхСтавок	= 1;
	НоваяСтрока.ДатаНачала			= ОбщегоНазначения.ПолучитьРабочуюДату();
	НоваяСтрока.НапомнитьПоЗавершении	= Ложь;
	НовыйДокумент.ПолучитьФорму().Открыть();
	
КонецПроцедуры // ДействияФормыКадровоеПеремещение()

// Процедура открывает форму списка регистра.
//
Процедура ДействияФормыИстория(Кнопка)
	
	ПоказыватьВсеЗаписиРегистра = Не Кнопка.Пометка;
	
	ЭлементыФормы.РаботникиОрганизации.ВыбиратьСрез = ?(ПоказыватьВсеЗаписиРегистра,ИспользованиеСреза.НеИспользовать,ИспользованиеСреза.Последние);
	ЭлементыФормы.ДействияФормы.Кнопки.История.Пометка					= ПоказыватьВсеЗаписиРегистра;
	ЭлементыФормы.ДействияФормы.Кнопки.Подменю.Кнопки.История.Пометка	= ПоказыватьВсеЗаписиРегистра;
	ЭлементыФормы.РаботникиОрганизации.Колонки.Картинка.ОтображатьСтандартнуюКартинку = ПоказыватьВсеЗаписиРегистра;
	
КонецПроцедуры // ДействияФормыИстория()

////////////////////////////////////////////////////////////////////////////////
// ПРОЦЕДУРЫ - ОБРАБОТЧИКИ СОБЫТИЙ ЭЛЕМЕНТОВ ФОРМЫ

// Процедура - обработчик события "ПриИзменении" поля ввода "Организация".
Процедура ОрганизацияПриИзменении(Элемент)
	
	Заголовок = мЗаголовокФормы + Элемент.Значение.Наименование;
	Отбор.ОбособленноеПодразделение.Использование = Не Элемент.Значение.Пустая();
	
	РаботаСДиалогами.УстановитьВидимостьЭУПоУчетнойПолитикеПоПерсоналу(ЭлементыФормы, глЗначениеПеременной("глУчетнаяПолитикаПоПерсоналуОрганизации")[ЭлементыФормы.Организация.Значение]);
	
КонецПроцедуры // ОрганизацияПриИзменении()

////////////////////////////////////////////////////////////////////////////////
// ПРОЦЕДУРЫ - ОБРАБОТЧИКИ СОБЫТИЙ ТАБЛИЧНОГО ПОЛЯ РаботникиОрганизации

// Процедура - обработчик события "ПередНачаломДобавления" табличного поля.
//
Процедура РаботникиОрганизацииПередНачаломДобавления(Элемент, Отказ, Копирование)
	
	ОткрытьНовыйПриказОПриеме();
	
КонецПроцедуры // РаботникиОрганизацииПередНачаломДобавления()

// Процедура обеспечивает управление картинкой строки.
//
Процедура РаботникиОрганизацииПриВыводеСтроки(Элемент, ОформлениеСтроки, ДанныеСтроки)

	Если Элемент.Колонки.Картинка.Видимость И Не ЭлементыФормы.ДействияФормы.Кнопки.История.Пометка Тогда
		ОформлениеСтроки.Ячейки.Картинка.ОтображатьКартинку = Истина;
		ОформлениеСтроки.Ячейки.Картинка.ИндексКартинки = Число(ДанныеСтроки.ПричинаИзмененияСостояния = Перечисления.ПричиныИзмененияСостояния.Увольнение);
	КонецЕсли;

КонецПроцедуры // РаботникиОрганизацииПриВыводеСтроки()

////////////////////////////////////////////////////////////////////////////////
// ОПЕРАТОРЫ ОСНОВНОЙ ПРОГРАММЫ

мДлинаСуток = 86400;
