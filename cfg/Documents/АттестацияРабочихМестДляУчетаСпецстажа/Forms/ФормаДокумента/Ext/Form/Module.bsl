Перем мТекущаяДатаДокумента; // Хранит последнюю установленную дату документа - для проверки перехода документа в другой период

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


// Процедура устанавливает подменю "Заполнить" в командных панелях ТЧ документа при необходимости
//
Процедура УстановитьКнопкиПодменюЗаполненияТЧ();
	
	мКнопкиЗаполненияТЧ = УниверсальныеМеханизмы.ПолучитьДеревоКнопокЗаполненияТабличныхЧастей(Ссылка,Новый Действие("НажатиеНаДополнительнуюКнопкуЗаполненияТЧ"));
	
	СоответствиеТЧ = Новый Соответствие;
	СоответствиеТЧ.Вставить(ЭлементыФормы.ШтатныеЕдиницы,ЭлементыФормы.КоманднаяПанельШтатныеЕдиницы);
	
	УниверсальныеМеханизмы.СформироватьПодменюЗаполненияТЧПоДеревуКнопок(мКнопкиЗаполненияТЧ,СоответствиеТЧ);
	
КонецПроцедуры

// Процедура устанавливает подменю "Печать" и кнопку "Печать по умолчанию" при необходимости
//
Процедура УстановитьКнопкиПечати()
	
	ФормированиеПечатныхФорм.СоздатьКнопкиПечати(ЭтотОбъект, ЭтаФорма);	
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// ПРОЦЕДУРЫ - ОБРАБОТЧИКИ СОБЫТИЙ ФОРМЫ

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

	Если ЭтоНовый() Тогда
		// Заполнить реквизиты значениями по умолчанию.
		ЗаполнениеДокументов.ЗаполнитьШапкуДокумента(ЭтотОбъект);
	Иначе 
		// Установить доступность формы с учетом даты запрета редактирования	
		РаботаСДиалогами.УстановитьДоступностьФормыДляРедактирования(ЭтотОбъект, ЭтаФорма);
	КонецЕсли;	

	МеханизмНумерацииОбъектов.УстановитьДоступностьПоляВводаНомера(Метаданные(), ЭтаФорма, ЭлементыФормы.ДействияФормы.Кнопки.Подменю,ЭлементыФормы.Номер);
	
	СтруктураКолонок = Новый Структура();

	// Установить колонки, видимостью которых пользователь управлять не может.
	СтруктураКолонок.Вставить("Подразделение");
 	СтруктураКолонок.Вставить("Должность");
 	СтруктураКолонок.Вставить("ВидСтажа");
	СтруктураКолонок.Вставить("Актуальность");

	// Установить ограничение - изменять видимоть колонок для таличной части Начисления
	ОбработкаТабличныхЧастей.УстановитьИзменятьВидимостьКолонокТабЧасти(ЭлементыФормы.ШтатныеЕдиницы.Колонки, СтруктураКолонок);

	// Вывести в заголовке формы вид операции и статус документа (новый, не проведен, проведен).
	РаботаСДиалогами.УстановитьЗаголовокФормыДокумента(, ЭтотОбъект, ЭтаФорма);

	// Запомнить текущие значения реквизитов формы.
	мТекущаяДатаДокумента        = Дата;

	// Установить активный реквизит.
	РаботаСДиалогами.АктивизироватьРеквизитВФорме(ЭтотОбъект, ЭтаФорма);

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

Процедура ОбработкаВыбора(ЗначениеВыбора, Источник)
	
	Если ТипЗнч(ЗначениеВыбора) = Тип("СправочникСсылка.ВидыСтажа") Тогда

		Если ЭлементыФормы.ШтатныеЕдиницы.ТекущаяСтрока  = Неопределено Тогда
			Возврат;
		КонецЕсли;
		
	    ЭлементыФормы.ШтатныеЕдиницы.ТекущаяСтрока.ВидСтажа  = ЗначениеВыбора;
		
	КонецЕсли; 
КонецПроцедуры



////////////////////////////////////////////////////////////////////////////////
// ПРОЦЕДУРЫ - ОБРАБОТЧИКИ СОБЫТИЙ РЕКВИЗИТОВ ШАПКИ

// Процедура - обработчик события "ПриИзменении" поля ввода даты документа
//
Процедура ДатаПриИзменении(Элемент = Неопределено)

	РаботаСДиалогами.ПроверитьНомерДокумента(ДокументОбъект, мТекущаяДатаДокумента);
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
// ПРОЦЕДУРЫ - ДЕЙСТВИЯ КОМАНДНЫХ ПАНЕЛЕЙ ФОРМЫ

////////////////////////////////////////////////////////////////////////////////
// ПРОЦЕДУРЫ - ОБРАБОТЧИКИ СОБЫТИЙ ТЧ ШтатныеЕдиницы

Процедура ШтатныеЕдиницыВидСтажаНачалоВыбора(Элемент, СтандартнаяОбработка)
	
	ФормаВыбора = Справочники.ВидыСтажа.ПолучитьФормуВыбора(,ЭтаФорма);

	// В качестве видов надбавом могут выступать расчеты, имеющий способ расчета "Проуентом" или "Фиксирвоанной суммой"
	ФормаВыбора.Отбор.ЛьготныйСтаж.ВидСравнения		= ВидСравнения.Равно;
	ФормаВыбора.Отбор.ЛьготныйСтаж.Значение			= Истина;
	ФормаВыбора.Отбор.ЛьготныйСтаж.Использование	= Истина;

	ФормаВыбора.Открыть();
	СтандартнаяОбработка = Ложь;

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




// Процедура вызывается при выборе пункта подменю "Движения документа по регистрам" меню "Перейти".
// командной панели формы. Процедура отрабатывает печать движений документа по регистрам.
//
Процедура ДействияФормыДвиженияДокументаПоРегистрам(Кнопка)

	РаботаСДиалогами.НапечататьДвиженияДокумента(Ссылка);

КонецПроцедуры

// Процедура разрешения/запрещения редактирования номера документа
Процедура ДействияФормыРедактироватьНомер(Кнопка)
	
	МеханизмНумерацииОбъектов.ИзменениеВозможностиРедактированияНомера(ЭтотОбъект.Метаданные(), ЭтаФорма, ЭлементыФормы.ДействияФормы.Кнопки.Подменю, ЭлементыФормы.Номер);
			
КонецПроцедуры

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


