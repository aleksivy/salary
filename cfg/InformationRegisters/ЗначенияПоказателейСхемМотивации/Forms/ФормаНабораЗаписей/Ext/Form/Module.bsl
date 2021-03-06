////////////////////////////////////////////////////////////////////////////////
// ПЕРЕМЕННЫЕ МОДУЛЯ

Перем мСписокДоступныхВозможностейИзменения;

Перем мОбработкаТайпинга;
Перем мТекстТайпинга;
Перем мПоследнееЗначениеЭлементаТайпинга;

Перем мСведенияОПоказателях;

Перем мСотрудникДляОткрытия Экспорт;
Перем мПоказательДляОткрытия Экспорт;

////////////////////////////////////////////////////////////////////////////////
// ОБЩИЕ ПРОЦЕДУРЫ И ФУНКЦИИ

// Читает и сохраняет для последующего использования реквизиты показателей схем мотивации
//
// Параметры
//  СведенияОПоказателях  - соответствие с данными о показателях
//  Показатель - ссылка на эл-т спр-ка ПоказателиСхемМотивации
//
// Возвращаемое значение:
//   Структура  - содержит реквизиты эл-та спр-ка ПоказателиСхемМотивации
//
Функция ПолучитьСведенияОПоказателе(СведенияОПоказателях,Показатель)

	СведенияОПоказателе = мСведенияОПоказателях[Показатель];
	Если СведенияОПоказателе = Неопределено Тогда
		СведенияОПоказателе = Новый Структура("ВидПоказателя,ТипПоказателя",Перечисления.ВидыПоказателейСхемМотивации.ПустаяСсылка(),Перечисления.ТипыПоказателейСхемМотивации.ПустаяСсылка());
		Запрос = Новый Запрос(
		"ВЫБРАТЬ
		|	ПоказателиСхемМотивации.ВидПоказателя,
		|	ПоказателиСхемМотивации.ТипПоказателя
		|ИЗ
		|	Справочник.ПоказателиСхемМотивации КАК ПоказателиСхемМотивации
		|ГДЕ ПоказателиСхемМотивации.Ссылка = &Ссылка");
		Запрос.УстановитьПараметр("Ссылка",Показатель);
		Выборка = Запрос.Выполнить().Выбрать();
		Если Выборка.Следующий() Тогда
			СведенияОПоказателе.ВидПоказателя = Выборка.ВидПоказателя;
			СведенияОПоказателе.ТипПоказателя = Выборка.ТипПоказателя;
		КонецЕсли;
		мСведенияОПоказателях[Показатель] = СведенияОПоказателе
	КонецЕсли;
	
	Возврат СведенияОПоказателе

КонецФункции // ПолучитьСведенияОПоказателе()

////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ ФОРМЫ


////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ т.п. РегистрСведенийНаборЗаписей

// Процедура - обработчик события "ПриВыводеСтроки"
//
Процедура РегистрСведенийНаборЗаписейПриВыводеСтроки(Элемент, ОформлениеСтроки, ДанныеСтроки)
	
	СведенияОПоказателе = ПолучитьСведенияОПоказателе(мСведенияОПоказателях, ДанныеСтроки.Показатель);
	
	ОформлениеСтроки.Ячейки.Сотрудник.Видимость	= Не (СведенияОПоказателе.ВидПоказателя = Перечисления.ВидыПоказателейСхемМотивации.Общий 
												Или СведенияОПоказателе.ВидПоказателя = Перечисления.ВидыПоказателейСхемМотивации.ПоПодразделению);

	Если СведенияОПоказателе.ВидПоказателя = Перечисления.ВидыПоказателейСхемМотивации.ПоПодразделению Тогда
		ОформлениеСтроки.Ячейки.Подразделение.Видимость = Истина;
		ЭлементыФормы.РегистрСведенийНаборЗаписей.Колонки.по.ТекстШапки = НСтр("ru='Сотрудник (подразделение)';uk='Співробітник (підрозділ)'");
	Иначе
		ОформлениеСтроки.Ячейки.Подразделение.Видимость = Ложь
	КонецЕсли;
	
	ОформлениеСтроки.Ячейки.Валюта.ТолькоПросмотр = СведенияОПоказателе.ТипПоказателя <> Перечисления.ТипыПоказателейСхемМотивации.Денежный;
	
	Если СведенияОПоказателе.ТипПоказателя = Перечисления.ТипыПоказателейСхемМотивации.Денежный Тогда
		ОформлениеСтроки.Ячейки.Значение.УстановитьТекст(Формат(ДанныеСтроки["Значение"],"ЧДЦ=2"));
		ОформлениеСтроки.Ячейки.Валюта.ТолькоПросмотр = Ложь;
	Иначе
		ОформлениеСтроки.Ячейки.Значение.УстановитьТекст(Формат(ДанныеСтроки["Значение"],"ЧДЦ=3"));
		ОформлениеСтроки.Ячейки.Валюта.ТолькоПросмотр = Истина;
	КонецЕсли;
	
	ОформлениеСтроки.Ячейки.по.Видимость = Ложь;
	//
КонецПроцедуры

Процедура РегистрСведенийНаборЗаписейПередНачаломДобавления(Элемент, Отказ, Копирование)
	Отказ = Истина;
КонецПроцедуры

// Процедура - обработчик события "ПоказательНачалоВыбора"
//
Процедура РегистрСведенийНаборЗаписейПоказательНачалоВыбора(Элемент, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;

	ФормаВыбораПоказателя = Справочники.ПоказателиСхемМотивации.ПолучитьФормуВыбора("ФормаВыбора", Элемент, "дляДокументаПриемНаРаботу");
	
	ФормаВыбораПоказателя.НачальноеЗначениеВыбора = Элемент;
	
	ФормаВыбораПоказателя.Открыть();
	
КонецПроцедуры

Процедура РегистрСведенийНаборЗаписейПоказательАвтоПодборТекста(Элемент, Текст, ТекстАвтоПодбора, СтандартнаяОбработка)
	ПроцедурыПоискаПоСтроке.АвтоПодборТекстаВЭлементеУправления(Элемент, Текст, ТекстАвтоПодбора, СтандартнаяОбработка, Новый Структура("ВозможностьИзменения", мСписокДоступныхВозможностейИзменения), Элемент.ТипЗначения.Типы()[0]);
КонецПроцедуры

Процедура РегистрСведенийНаборЗаписейПоказательОкончаниеВводаТекста(Элемент, Текст, Значение, СтандартнаяОбработка)
	ПроцедурыПоискаПоСтроке.ОкончаниеВводаТекстаВЭлементеУправления(Элемент, Текст, Значение, СтандартнаяОбработка, Новый Структура("ВозможностьИзменения", мСписокДоступныхВозможностейИзменения), ЭтаФорма, Элемент.ТипЗначения.Типы()[0], мОбработкаТайпинга, мТекстТайпинга, мПоследнееЗначениеЭлементаТайпинга, Ложь);
КонецПроцедуры

Процедура ПриОткрытии()
	
	Организация = РегистрСведенийНаборЗаписей.Отбор.Организация.Значение;
	Если ЗначениеЗаполнено(Организация) Тогда
		мМассивЭУ = Новый Массив();
		мМассивЭУ.Добавить(ЭлементыФормы.РегистрСведенийНаборЗаписей.Колонки.Валюта);
		РаботаСДиалогами.УстановитьВидимостьЭУПоУчетнойПолитикеПоПерсоналу(мМассивЭУ,глЗначениеПеременной("глУчетнаяПолитикаПоПерсоналуОрганизации"),Организация);
	КонецЕсли;
	
	ЭлементыФормы.РегистрСведенийНаборЗаписей.ТекущаяКолонка = ЭлементыФормы.РегистрСведенийНаборЗаписей.Колонки.Значение;
	
	Если мСотрудникДляОткрытия <> Неопределено Тогда
		Для Каждого СтркаНабора Из РегистрСведенийНаборЗаписей Цикл
			ТекущийСотрудник = СтркаНабора.Сотрудник;
			Если ТекущийСотрудник = мСотрудникДляОткрытия Или ТекущийСотрудник.Физлицо = мСотрудникДляОткрытия Тогда
				ЭлементыФормы.РегистрСведенийНаборЗаписей.ТекущаяСтрока = СтркаНабора;
				Прервать;
			КонецЕсли;
		КонецЦикла;
	КонецЕсли;

КонецПроцедуры

Процедура ПослеЗаписи()
	
	Оповестить("ЗаписьПоказателя", РегистрСведенийНаборЗаписей.Выгрузить());
	
КонецПроцедуры

Процедура РегистрСведенийНаборЗаписейПриАктивизацииСтроки(Элемент)
	
	Показатель = ЭлементыФормы.РегистрСведенийНаборЗаписей.ТекущиеДанные.Показатель;
	СведенияОПоказателе = ПолучитьСведенияОПоказателе(мСведенияОПоказателях, Показатель);
	Если СведенияОПоказателе.ТипПоказателя = Перечисления.ТипыПоказателейСхемМотивации.Денежный Тогда
		ЭлементыФормы.РегистрСведенийНаборЗаписей.Колонки["Значение"].ЭлементУправления.Формат = "ЧДЦ=2";
	КонецЕсли;

КонецПроцедуры

Процедура РегистрСведенийНаборЗаписейПередУдалением(Элемент, Отказ)
	Отказ = Истина;
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// ОПЕРАТОРЫ ОСНОВНОЙ ПРОГРАММЫ

мСведенияОПоказателях = Новый Соответствие;

мОбработкаТайпинга					= Ложь;
мТекстТайпинга						= "";
мПоследнееЗначениеЭлементаТайпинга	= Неопределено;

мСписокДоступныхВозможностейИзменения = Новый СписокЗначений;
мСписокДоступныхВозможностейИзменения.Добавить(Перечисления.ИзменениеПоказателейСхемМотивации.ВводитсяПриРасчете);
мСписокДоступныхВозможностейИзменения.Добавить(Перечисления.ИзменениеПоказателейСхемМотивации.ВиденНоНеРедактируетсяПриРасчете);



