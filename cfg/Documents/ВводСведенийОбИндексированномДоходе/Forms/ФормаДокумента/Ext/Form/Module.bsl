////////////////////////////////////////////////////////////////////////////////
// ПЕРЕМЕННЫЕ МОДУЛЯ

Перем мТекущаяДатаДокумента; // Хранит последнюю установленную дату документа - для проверки перехода документа в другой период
Перем мФормаПодбора; // Форма подбора работников

// Хранит дерево макетов печатных форм
Перем мДеревоМакетов;

// Хранит элемент управления подменю печати
Перем мПодменюПечати;

// Хранит элемент управления кнопку печать по умолчанию
Перем мПечатьПоУмолчанию;

// Хранит дерево кнопок подменю заполнение ТЧ
Перем мКнопкиЗаполненияТЧ;


////////////////////////////////////////////////////////////////////////////////
// ОБЩИЕ ПРОЦЕДУРЫ И ФУНКЦИИ

Процедура ПриИзмененииРаботника(Значение)
	
КонецПроцедуры

// Процедура устанавливает подменю "Заполнить" в командных панелях ТЧ документа при необходимости
//
Процедура УстановитьКнопкиПодменюЗаполненияТЧ();
	
	мКнопкиЗаполненияТЧ = УниверсальныеМеханизмы.ПолучитьДеревоКнопокЗаполненияТабличныхЧастей(Ссылка,Новый Действие("НажатиеНаДополнительнуюКнопкуЗаполненияТЧ"));

	СоответствиеТЧ = Новый Соответствие;
	СоответствиеТЧ.Вставить(ЭлементыФормы.РаботникиОрганизации,ЭлементыФормы.КоманднаяПанельРаботникиОрганизации);
	
	УниверсальныеМеханизмы.СформироватьПодменюЗаполненияТЧПоДеревуКнопок(мКнопкиЗаполненияТЧ,СоответствиеТЧ);
	
КонецПроцедуры

// Процедура устанавливает подменю "Печать" и кнопку "Печать по умолчанию" при необходимости
//
Процедура УстановитьКнопкиПечати()
	
	ФормированиеПечатныхФорм.СоздатьКнопкиПечати(ЭтотОбъект, ЭтаФорма);	
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ ФОРМЫ

// Процедура - обработчик события "ПередОткрытием" формы.
//
Процедура ПередОткрытием(Отказ, СтандартнаяОбработка)
	
	// Установка кнопок печати
	УстановитьКнопкиПечати();
	
	// Установка кнопок заполнение ТЧ
	УстановитьКнопкиПодменюЗаполненияТЧ();
	
	
КонецПроцедуры // ПередОткрытием()

// Процедура - обработчик события "ПриОткрытии" формы
//
Процедура ПриОткрытии()

	Если ЭтоНовый() Тогда // проверить объект на то, что он еще не внесен в ИБ
		
		// Заполнить реквизиты значениями по умолчанию.
		ЗаполнениеДокументов.ЗаполнитьШапкуДокумента(ЭтотОбъект);
	Иначе 
		// Установить доступность формы с учетом даты запрета редактирования	
		РаботаСДиалогами.УстановитьДоступностьФормыДляРедактирования(ЭтотОбъект, ЭтаФорма);
	КонецЕсли;
	
	МеханизмНумерацииОбъектов.УстановитьДоступностьПоляВводаНомера(Метаданные(), ЭтаФорма, ЭлементыФормы.ДействияФормы.Кнопки.Подменю,ЭлементыФормы.Номер);

	СтруктураКолонок = Новый Структура();

	// Установить колонки, видимостью которых пользователь управлять не может.
	СтруктураКолонок.Вставить("Сотрудник");
 	СтруктураКолонок.Вставить("ВидРасчета");
 	СтруктураКолонок.Вставить("Действие");
 	СтруктураКолонок.Вставить("ДатаДействия");

	// Установить ограничение - изменять видимоть колонок для таличной части РаботникиОрганизации
	ОбработкаТабличныхЧастей.УстановитьИзменятьВидимостьКолонокТабЧасти(ЭлементыФормы.РаботникиОрганизации.Колонки, СтруктураКолонок);

	// Активизируем табличное поле
	ТекущийЭлемент = ЭлементыФормы.РаботникиОрганизации;

	// Вывести в заголовке формы статус документа (новый, не проведен, проведен).
	РаботаСДиалогами.УстановитьЗаголовокФормыДокумента(, ЭтотОбъект, ЭтаФорма);
	
	// Запомнить текущие значения реквизитов формы.
	мТекущаяДатаДокумента = Дата;
	
КонецПроцедуры

// Процедура - обработчик события "ПослеЗаписи" формы.
//
Процедура ПослеЗаписи()
	// Установка кнопок печати
	УстановитьКнопкиПечати();

	// Вывести в заголовке формы статус документа (новый, не проведен, проведен).
	РаботаСДиалогами.УстановитьЗаголовокФормыДокумента(, ЭтотОбъект, ЭтаФорма);
	
	МеханизмНумерацииОбъектов.ОбновитьПодсказкуКодНомерОбъекта(ЭтотОбъект.Метаданные(), ЭлементыФормы.ДействияФормы.Кнопки.Подменю, ЭлементыФормы.Номер);
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// ПРОЦЕДУРЫ - ДЕЙСТВИЯ КОМАНДНЫХ ПАНЕЛЕЙ ФОРМЫ

// Процедура вызывается при выборе пункта подменю "Движения документа по регистрам" меню "Перейти".
// командной панели формы. Процедура отрабатывает печать движений документа по регистрам.
//
Процедура ДействияФормыДвиженияДокументаПоРегистрам(Кнопка)

	РаботаСДиалогами.НапечататьДвиженияДокумента(Ссылка);

КонецПроцедуры // ДействияФормыДвиженияДокументаПоРегистрам()

// Процедура - обработчик нажатия на любую из дополнительных кнопок по заполнению ТЧ
//
Процедура НажатиеНаДополнительнуюКнопкуЗаполненияТЧ(Кнопка)
	
	УниверсальныеМеханизмы.ОбработатьНажатиеНаДополнительнуюКнопкуЗаполненияТЧ(мКнопкиЗаполненияТЧ.Строки.Найти(Кнопка.Имя,"Имя",Истина),ЭтотОбъект);
	
КонецПроцедуры

// Процедура - обработчик нажатия на кнопку "Печать по умолчанию"
//
Процедура ОсновныеДействияФормыПечатьПоУмолчанию(Кнопка)
	
	УниверсальныеМеханизмы.ПечатьПоДополнительнойКнопке(мДеревоМакетов, ЭтотОбъект, ЭтаФорма, Кнопка.Текст);
	
КонецПроцедуры

// Процедура - обработчик нажатия на кнопку "Печать"
//
Процедура ОсновныеДействияФормыПечать(Кнопка)
	
	УниверсальныеМеханизмы.ПечатьПоДополнительнойКнопке(мДеревоМакетов, ЭтотОбъект, ЭтаФорма, Кнопка.Текст);
	
КонецПроцедуры

// Процедура - обработчик нажатия на кнопку "Установить печать по умолчанию"
//
Процедура ОсновныеДействияФормыУстановитьПечатьПоУмолчанию(Кнопка)
	
	Если УниверсальныеМеханизмы.НазначитьКнопкуПечатиПоУмолчанию(мДеревоМакетов, Метаданные().Имя) Тогда
		
		УстановитьКнопкиПечати();
		
	КонецЕсли; 
	
	
КонецПроцедуры

// Процедура разрешения/запрещения редактирования номера документа
Процедура ДействияФормыРедактироватьНомер(Кнопка)
	
	МеханизмНумерацииОбъектов.ИзменениеВозможностиРедактированияНомера(ЭтотОбъект.Метаданные(), ЭтаФорма, ЭлементыФормы.ДействияФормы.Кнопки.Подменю, ЭлементыФормы.Номер);
			
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ РЕКВИЗИТОВ ШАПКИ

// Процедура - обработчик события "ПриИзменении" поля ввода даты документа.
//
Процедура ДатаПриИзменении(Элемент)

	РаботаСДиалогами.ПроверитьНомерДокумента(ЭтотОбъект, мТекущаяДатаДокумента);
	МеханизмНумерацииОбъектов.ОбновитьПодсказкуКодНомерОбъекта(ЭтотОбъект.Метаданные(), ЭлементыФормы.ДействияФормы.Кнопки.Подменю, ЭлементыФормы.Номер);

	мТекущаяДатаДокумента = Дата;

КонецПроцедуры // ДатаПриИзменении

// Процедура - обработчик события "ПриИзменении" поля ввода организации.
//
Процедура ОрганизацияПриИзменении(Элемент)

	Если Не ПустаяСтрока(Номер) Тогда
		МеханизмНумерацииОбъектов.СброситьУстановленныйКодНомерОбъекта(ЭтотОбъект, "Номер", ЭлементыФормы.ДействияФормы.Кнопки.Подменю, ЭлементыФормы.Номер);
	КонецЕсли;

КонецПроцедуры // ОрганизацияПриИзменении()

////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ РЕКВИЗИТОВ ТАБЛИЧНОГО ПОЛЯ РаботникиОрганизации

Процедура РаботникиОрганизацииСотрудникПриИзменении(Элемент)
	ЭлементыФормы.РаботникиОрганизации.ТекущаяСтрока.ФизЛицо = Элемент.Значение.ФизЛицо;
	ЭлементыФормы.РаботникиОрганизации.ТекущаяСтрока.ВидЗанятости = Элемент.Значение.ВидЗанятости;
	ПриИзмененииРаботника(Элемент.Значение)
КонецПроцедуры

Процедура РаботникиОрганизацииСотрудникНачалоВыбора(Элемент, СтандартнаяОбработка)
	
	ПроцедурыУправленияПерсоналом.ОткрытьФормуВыбораСотрудникаОрганизации(Элемент, Ссылка, Истина, Дата, Организация, 3, СтандартнаяОбработка, Элемент.Значение);
	
КонецПроцедуры


////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ РЕКВИЗИТОВ ТАБЛИЧНОЙ ЧАСТИ РаботникиОрганизации


// Процедура - обработчик события "АвтоПодборТекста" поля ввода физлица
// переопеределим выбор физлица на выбор из списка регистра сведений
//
Процедура РаботникиОрганизацииСотрудникАвтоПодборТекста(Элемент, Текст, ТекстАвтоПодбора, СтандартнаяОбработка)
	
	ТекстАвтоПодбора = ПроцедурыУправленияПерсоналом.ПодобратьФИОРаботникаКандидата(СтандартнаяОбработка, "РаботникиОрганизации", Текст, Организация);
	
КонецПроцедуры

// Процедура - обработчик события "ОкончаниеВводаТекста" поля ввода физлица
// переопеределим выбор физлица на выбор из списка регистра сведений
//
Процедура РаботникиОрганизацииСотрудникОкончаниеВводаТекста(Элемент, Текст, Значение, СтандартнаяОбработка)
	
	Значение = ПроцедурыУправленияПерсоналом.ПодобратьСписокРаботниковКандидатов(СтандартнаяОбработка, "РаботникиОрганизации", Текст, Элемент.Значение, Организация);
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// ПРОЦЕДУРЫ ОБРАБОТКИ СВОЙСТВ И КАТЕГОРИЙ

// Процедура выполняет открытие формы работы со свойствами документа
//
Процедура ДействияФормыДействиеОткрытьСвойства(Кнопка)

	РаботаСДиалогами.ОткрытьСвойстваДокумента(ЭтотОбъект, ЭтаФорма);

КонецПроцедуры

// Процедура выполняет открытие формы работы с категориями документа
//
Процедура ДействияФормыДействиеОткрытьКатегории(Кнопка)

	РаботаСДиалогами.ОткрытьКатегорииДокумента(ЭтотОбъект, ЭтаФорма);

КонецПроцедуры


  
////////////////////////////////////////////////////////////////////////////////
// ОПЕРАТОРЫ ОСНОВНОЙ ПРОГРАММЫ
// 

мФормаПодбора = ПолучитьОбщуюФорму("ФормаВыбораРаботникаОрганизации", ЭлементыФормы.РаботникиОрганизации, Ссылка);


