﻿
Перем мОбработкаПоискаПоСтроке;
Перем мТекстПоискаПоСтроке;
Перем мПоследнееЗначениеЭлементаПоискаПоСтроке;

Перем мСтруктураИзмерений Экспорт;

////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ ФОРМЫ
//

// Процедура вызывается при открытии формы.
//
Процедура ПриОткрытии()

	ЭлементыФормы.Объект.ТолькоПросмотр     = НЕ ДоступностьОбъекта;
	
	Если Вид = Неопределено Тогда
		Вид = Справочники.ВидыКонтактнойИнформации.ПустаяСсылка();
	КонецЕсли;
	
	Если НЕ ЗначениеЗаполнено(Объект) И ДоступностьОбъекта Тогда
		ЭтаФорма.ТекущийЭлемент = ЭлементыФормы.Объект;
	ИначеЕсли НЕ ЗначениеЗаполнено(Вид) Тогда
		ЭтаФорма.ТекущийЭлемент = ЭлементыФормы.Вид;
	Иначе
		ЭтаФорма.ТекущийЭлемент = ЭлементыФормы.Поле3;
	КонецЕсли; 
	
	Если НЕ ЗначениеЗаполнено(Представление) Тогда
		Поле1 = УправлениеПользователями.ПолучитьЗначениеПоУмолчанию(глЗначениеПеременной("глТекущийПользователь"), "ОсновнойКодСтраныТелефона");
		Поле2 = УправлениеПользователями.ПолучитьЗначениеПоУмолчанию(глЗначениеПеременной("глТекущийПользователь"), "ОсновнойКодГородаТелефона");
	КонецЕсли;
	
	мПоследнееЗначениеЭлементаПоискаПоСтроке = Вид;
	
КонецПроцедуры // ПриОткрытии()

// Процедура вызывается при ОбновлениеОтображения формы.
//
Процедура ОбновлениеОтображения()
	
	ЭтаФорма.ЭлементыФормы.Вид.ТолькоПросмотр = (Объект = Неопределено);

	ПроцедурыПоискаПоСтроке.ОбновлениеОтображенияВФормеПриПоискеПоСтроке(ЭтаФорма, ЭтаФорма.ЭлементыФормы.Вид, мОбработкаПоискаПоСтроке, мТекстПоискаПоСтроке);
	
КонецПроцедуры

Процедура ОсновныеДействияФормыЗаписать(Кнопка)
	
	Если Записать() = Истина Тогда
		Модифицированность = Ложь;
	КонецЕсли;
	
КонецПроцедуры

Процедура ОсновныеДействияФормыОК(Кнопка)
	
	Если Записать() = Истина Тогда
		Модифицированность = Ложь;
		Закрыть();
	КонецЕсли;
	
КонецПроцедуры

Процедура ПередЗакрытием(Отказ, СтандартнаяОбработка)
	
	Если Модифицированность Тогда
		Отказ = ЗакрыватьФормуРедактирования();
	КонецЕсли; 
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ ЭЛЕМЕНТОВ ФОРМЫ
//

// Процедура вызывается при очистке значения элемента формы Объект.
//
Процедура ОбъектОчистка(Элемент, СтандартнаяОбработка)
	
	Если ТипЗнч(Вид) = Тип("СправочникСсылка.ВидыКонтактнойИнформации") Тогда
		Вид = Справочники.ВидыКонтактнойИнформации.ПустаяСсылка();
	КонецЕсли; 
	
КонецПроцедуры

// Процедура вызывается при изменении реквизита Поле3 - собственно номер телефона.
Процедура Поле3ПриИзменении(Элемент)

	Элемент.Значение = УправлениеКонтактнойИнформацией.ПривестиНомерТелефонаКШаблону(Элемент.Значение);
	УправлениеКонтактнойИнформацией.СформироватьПредставлениеТелефона(ЭтотОбъект);
	
КонецПроцедуры // Поле3ПриИзменении()

// Процедура вызывается при изменении реквизита Поле4 - добавочный номер телефона.
Процедура Поле4ПриИзменении(Элемент)
	
	Элемент.Значение = УправлениеКонтактнойИнформацией.ПривестиНомерТелефонаКШаблону(Элемент.Значение);
	УправлениеКонтактнойИнформацией.СформироватьПредставлениеТелефона(ЭтотОбъект);
	
КонецПроцедуры // Поле4ПриИзменении()

// Процедура вызывается при изменении реквизита Поле1 - код страны.
Процедура Поле1ПриИзменении(Элемент)
	
	Если Лев(СокрЛ(Поле1), 1) <> "+" И НЕ ПустаяСтрока(Поле1) Тогда
		Поле1 = СокрЛП(Поле1);
		Пока Лев(Поле1, 1) = "0" Цикл
			Поле1 = Сред(Поле1, 2);
		КонецЦикла;
		Если НЕ ПустаяСтрока(Поле1) Тогда
			Поле1 = "+" + Поле1;
		КонецЕсли; 
	КонецЕсли; 
	
	УправлениеКонтактнойИнформацией.СформироватьПредставлениеТелефона(ЭтотОбъект);
	
КонецПроцедуры // Поле1ПриИзменении()

// Процедура вызывается при изменении реквизита Поле2 - код города.
Процедура Поле2ПриИзменении(Элемент)
	
	УправлениеКонтактнойИнформацией.СформироватьПредставлениеТелефона(ЭтотОбъект);
	
КонецПроцедуры // Поле2ПриИзменении()

// Процедура перехватывает момент начала выбора вида контактной информации.
//
// Параметры
//  Элемент - элемент формы, выбор значения которого должен произойти
//  СтандартнаяОбработка - булево, флаг стандартной обработки выбора.
Процедура ВидНачалоВыбора(Элемент, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;

	Если Объект = Неопределено ИЛИ Объект.Ссылка.Пустая() Тогда
		Сообщить(НСтр("ru='Выберите объект.';uk=""Виберіть об'єкт."""));
		Возврат;
	КонецЕсли;

	УправлениеКонтактнойИнформацией.ОткрытьФормуВыбораВидаКИ(Истина, Элемент, Тип, УправлениеКонтактнойИнформацией.ВидОбъектаКИ(Объект));
	
КонецПроцедуры // ВидНачалоВыбора()

// Процедура перехватывает момент начала выбора Объекта.
//
// Параметры
//  Элемент - элемент формы, выбор значения которого должен произойти
//  СтандартнаяОбработка - булево, флаг стандартной обработки выбора.
Процедура ОбъектНачалоВыбора(Элемент, СтандартнаяОбработка)
	
	СтандартнаяОбработка = УправлениеКонтактнойИнформацией.НачалоВыбораОбъектаКИ(ЭтаФорма, Элемент, глЗначениеПеременной("глТекущийПользователь"));

КонецПроцедуры

// Процедура обработчик события АвтоПодборТекста элемента формы Вид.
//
Процедура ВидАвтоПодборТекста(Элемент, Текст, ТекстАвтоПодбора, СтандартнаяОбработка)
	
	ПроцедурыПоискаПоСтроке.АвтоПодборТекстаВЭлементеУправления(Элемент, Текст, ТекстАвтоПодбора, СтандартнаяОбработка, Новый Структура("Тип, ВидОбъектаКонтактнойИнформации", Тип, УправлениеКонтактнойИнформацией.ВидОбъектаКИ(Объект)), Тип("СправочникСсылка.ВидыКонтактнойИнформации"));
	
КонецПроцедуры

// Процедура обработчик события ОкончаниеВводаТекста элемента формы Вид.
//
Процедура ВидОкончаниеВводаТекста(Элемент, Текст, Значение, СтандартнаяОбработка)
	
	ПроцедурыПоискаПоСтроке.ОкончаниеВводаТекстаВЭлементеУправления(Элемент, Текст, Значение, СтандартнаяОбработка, Новый Структура("Тип, ВидОбъектаКонтактнойИнформации", Тип, УправлениеКонтактнойИнформацией.ВидОбъектаКИ(Объект)), ЭтаФорма, Тип("СправочникСсылка.ВидыКонтактнойИнформации"), мОбработкаПоискаПоСтроке, мТекстПоискаПоСтроке, мПоследнееЗначениеЭлементаПоискаПоСтроке);
	
КонецПроцедуры

// Процедура обработчик события ПриИзменении элемента формы Вид.
//
Процедура ВидПриИзменении(Элемент)
	
	мПоследнееЗначениеЭлементаПоискаПоСтроке = Элемент.Значение;
	
КонецПроцедуры

мОбработкаПоискаПоСтроке                 = Ложь;
мТекстПоискаПоСтроке                     = "";
мПоследнееЗначениеЭлементаПоискаПоСтроке = Неопределено;
мСтруктураИзмерений                = Неопределено;
