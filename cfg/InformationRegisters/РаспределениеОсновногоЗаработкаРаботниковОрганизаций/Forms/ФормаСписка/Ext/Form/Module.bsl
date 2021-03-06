////////////////////////////////////////////////////////////////////////////////
// ПЕРЕМЕННЫЕ МОДУЛЯ

Перем мОбработкаПодбораПоСтроке;
Перем мТекстПодбораПоСтроке;
Перем мПоследнееЗначениеЭлементаПодбораПоСтроке;

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
Функция ПолучитьСтруктуруПараметровПодбораПоСтроке()

	СтруктураПараметров = Новый Структура("ГоловнаяОрганизация", Справочники.Организации.ПустаяСсылка());
	
	Возврат СтруктураПараметров;

КонецФункции // ПолучитьСтруктуруПараметровПодбораПоСтроке()()

////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ ФОРМЫ

// Процедура - обработчик события "ПередОткрытием" формы.
//
Процедура ПередОткрытием(Отказ, СтандартнаяОбработка)
	
	// настройка порядка
	ЭлементыФормы.РегистрСведенийСписок.НастройкаПорядка.Сотрудник.Доступность = Истина;

КонецПроцедуры

// Если форма открывается из списка документов, процедура заполняет организацию 
// прописывает заголовок формы и выставляет отбор регистру
//
Процедура ПриОткрытии()
	
	мЗаголовокФормы = НСтр("ru='Распределение основного заработка сотрудников организации в регламентированном учете ';uk='Розподіл основного заробітку співробітників організації в регламентованому обліку '");
	
	// заполним организацию
	РаботаСДиалогами.ЗаполнениеОтбораПоОрганизацииПоУмолчанию(ЭтаФорма, Отбор.Организация, ЭлементыФормы.Организация, ПараметрОтборПоРегистратору, Ложь, глЗначениеПеременной("глТекущийПользователь"),мЗаголовокФормы);
	
КонецПроцедуры

Процедура ПриПовторномОткрытии(СтандартнаяОбработка)
	
	// заполним организацию
	РаботаСДиалогами.ЗаполнениеОтбораПоОрганизацииПоУмолчанию(ЭтаФорма, Отбор.Организация, ЭлементыФормы.Организация, ПараметрОтборПоРегистратору, Ложь, глЗначениеПеременной("глТекущийПользователь"),мЗаголовокФормы);
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
	
	ПроцедурыПоискаПоСтроке.АвтоПодборТекстаВЭлементеУправления(Элемент, Текст, ТекстАвтоПодбора, СтандартнаяОбработка, ПолучитьСтруктуруПараметровПодбораПоСтроке(), Тип("СправочникСсылка.Организации"));
	
КонецПроцедуры

Процедура ОрганизацияОкончаниеВводаТекста(Элемент, Текст, Значение, СтандартнаяОбработка)
	
	ПроцедурыПоискаПоСтроке.ОкончаниеВводаТекстаВЭлементеУправления(Элемент, Текст, Значение, СтандартнаяОбработка, ПолучитьСтруктуруПараметровПодбораПоСтроке(), ЭтаФорма, Тип("СправочникСсылка.Организации"), мОбработкаПодбораПоСтроке, мТекстПодбораПоСтроке, мПоследнееЗначениеЭлементаПодбораПоСтроке, Ложь);
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// ОПЕРАТОРЫ ОСНОВНОЙ ПРОГРАММЫ

мОбработкаПодбораПоСтроке                 = Ложь;
мТекстПодбораПоСтроке                     = "";
мПоследнееЗначениеЭлементаПодбораПоСтроке = Справочники.Организации.ПустаяСсылка();

