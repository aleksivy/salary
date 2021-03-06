////////////////////////////////////////////////////////////////////////////////
// ПЕРЕМЕННЫЕ МОДУЛЯ

Перем мДлинаСуток;
Перем мОбработкаТайпинга;
Перем мТекстТайпинга;
Перем мПоследнееЗначениеЭлементаТайпинга;

Перем мСведенияОвидахРасчета;
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
// ОБРАБОТЧИКИ СОБЫТИЙ ФОРМЫ

// Если форма открывается из списка документов, процедура заполняет организацию 
// прописывает заголовок формы и выставляет отбор регистру
//
Процедура ПриОткрытии()
	
	мЗаголовокФормы = НСтр("ru='Удержания работников организации ';uk='Утримання працівників організації '");
	
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
	
	ПроцедурыПоискаПоСтроке.АвтоПодборТекстаВЭлементеУправления(Элемент, Текст, ТекстАвтоПодбора, СтандартнаяОбработка, ПолучитьСтруктуруПараметровТайпинга(), Тип("СправочникСсылка.Организации"));
	
КонецПроцедуры

Процедура ОрганизацияОкончаниеВводаТекста(Элемент, Текст, Значение, СтандартнаяОбработка)
	
	ПроцедурыПоискаПоСтроке.ОкончаниеВводаТекстаВЭлементеУправления(Элемент, Текст, Значение, СтандартнаяОбработка, ПолучитьСтруктуруПараметровТайпинга(), ЭтаФорма, Тип("СправочникСсылка.Организации"), мОбработкаТайпинга, мТекстТайпинга, мПоследнееЗначениеЭлементаТайпинга, Ложь);
	
КонецПроцедуры

Процедура РегистрСведенийСписокПриПолученииДанных(Элемент, ОформленияСтрок)
	РаботаСДиалогами.ОформитьСтрокиПлановыхУдержаний(Элемент, мСведенияОВидахРасчета, ОформленияСтрок);
КонецПроцедуры


////////////////////////////////////////////////////////////////////////////////
// ОПЕРАТОРЫ ОСНОВНОЙ ПРОГРАММЫ

мДлинаСуток = 86400;

мОбработкаТайпинга                 = Ложь;
мТекстТайпинга                     = "";
мПоследнееЗначениеЭлементаТайпинга = Справочники.Организации.ПустаяСсылка();
мСведенияОВидахРасчета 				= Новый Соответствие;

