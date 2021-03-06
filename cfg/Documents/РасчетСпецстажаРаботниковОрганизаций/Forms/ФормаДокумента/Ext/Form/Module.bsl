////////////////////////////////////////////////////////////////////////////////
// ПЕРЕМЕННЫЕ МОДУЛЯ

Перем мТекущаяДатаДокумента;			// Хранит последнюю установленную дату документа - для проверки перехода документа в другой период
Перем мДеревоМакетов;					// Хранит дерево макетов печатных форм
Перем мПодменюПечати;					// Хранит элемент управления подменю печати
Перем мПечатьПоУмолчанию;				// Хранит элемент управления кнопку печать по умолчанию
Перем мКнопкиЗаполненияТЧ;				// Хранит дерево кнопок подменю заполнение ТЧ

// Массив ЭУ видимостью которых необходимо управлять в зависимости от учетной политики по персоналу
Перем мМассивЭУ;


////////////////////////////////////////////////////////////////////////////////
// ПРОЦЕДУРЫ И ФУНКЦИИ ОБЩЕГО НАЗНАЧЕНИЯ

// Процедура устанавливает подменю "Заполнить" в командных панелях ТЧ документа при необходимости
//
Процедура УстановитьКнопкиПодменюЗаполненияТЧ()

	мКнопкиЗаполненияТЧ = УниверсальныеМеханизмы.ПолучитьДеревоКнопокЗаполненияТабличныхЧастей(Ссылка,Новый Действие("НажатиеНаДополнительнуюКнопкуЗаполненияТЧ"));

	СоответствиеТЧ = Новый Соответствие;
	СоответствиеТЧ.Вставить(ЭлементыФормы.Спецстаж,ЭлементыФормы.КоманднаяПанельСпецстаж);
	
	УниверсальныеМеханизмы.СформироватьПодменюЗаполненияТЧПоДеревуКнопок(мКнопкиЗаполненияТЧ,СоответствиеТЧ);
	
КонецПроцедуры // УстановитьКнопкиПодменюЗаполненияТЧ()

// Процедура устанавливает подменю "Печать" и кнопку "Печать по умолчанию" при необходимости
//
Процедура УстановитьКнопкиПечати()
	
	ФормированиеПечатныхФорм.СоздатьКнопкиПечати(ЭтотОбъект, ЭтаФорма);	
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// ПРОЦЕДУРЫ - ОБРАБОТЧИКИ СОБЫТИЙ ФОРМЫ

Процедура ПередОткрытием(Отказ, СтандартнаяОбработка)
	
	// Установка кнопок печати
	УстановитьКнопкиПечати();
	
	// Установка кнопок заполнение ТЧ
	УстановитьКнопкиПодменюЗаполненияТЧ();
	
КонецПроцедуры // ПередОткрытием()

Процедура ПриОткрытии()

	Если ЭтоНовый() Тогда // проверить объект на то, что он еще не внесен в ИБ
		
		// Заполнить реквизиты значениями по умолчанию.
		ЗаполнениеДокументов.ЗаполнитьШапкуДокумента(ЭтотОбъект);
		УстановитьНовыйНомер();
	Иначе 
		// Установить доступность формы с учетом даты запрета редактирования	
		РаботаСДиалогами.УстановитьДоступностьФормыДляРедактирования(ЭтотОбъект, ЭтаФорма);
	КонецЕсли;
	
	МеханизмНумерацииОбъектов.УстановитьДоступностьПоляВводаНомера(Метаданные(), ЭтаФорма, ЭлементыФормы.ДействияФормы.Кнопки.Подменю,ЭлементыФормы.Номер);

	СтруктураКолонок = Новый Структура();

	// Установить колонки, видимостью которых пользователь управлять не может.
	СтруктураКолонок.Вставить("Сотрудник");
	СтруктураКолонок.Вставить("ВидСтажа");
	СтруктураКолонок.Вставить("Результат");
	СтруктураКолонок.Вставить("Норма");

	// Установить ограничение - изменять видимость колонок для табличной части Спецстаж
	ОбработкаТабличныхЧастей.УстановитьИзменятьВидимостьКолонокТабЧасти(ЭлементыФормы.Спецстаж.Колонки, СтруктураКолонок);

	// Вывести в заголовке формы статус документа (новый, не проведен, проведен).
	РаботаСДиалогами.УстановитьЗаголовокФормыДокумента(, ЭтотОбъект, ЭтаФорма);

	// Запомнить текущие значения реквизитов формы.
	мТекущаяДатаДокумента = Дата;
	
	// Установим видимость реквизитов в зависимости от уч.политики по персоналу организаций
	мМассивЭУ = Новый Массив();
	мМассивЭУ.Добавить(ЭлементыФормы.Спецстаж.Колонки.ТабельныйНомерСтрока);
	РаботаСДиалогами.УстановитьВидимостьЭУПоУчетнойПолитикеПоПерсоналу(мМассивЭУ,глЗначениеПеременной("глУчетнаяПолитикаПоПерсоналуОрганизации"),Организация);
	
	// Заполним реквизит формы МесяцСтрока.
	МесяцСтрока = РаботаСДиалогами.ДатаКакМесяцПредставление(ПериодРегистрации);
	
	// Установить активный реквизит.
	РаботаСДиалогами.АктивизироватьРеквизитВФорме(ЭтотОбъект, ЭтаФорма);
	
КонецПроцедуры // ПриОткрытии()

Процедура ПослеЗаписи()

	// Установка кнопок печати
	УстановитьКнопкиПечати();
	// Вывести в заголовке формы статус документа (новый, не проведен, проведен).
	РаботаСДиалогами.УстановитьЗаголовокФормыДокумента(, ЭтотОбъект, ЭтаФорма);
	МеханизмНумерацииОбъектов.ОбновитьПодсказкуКодНомерОбъекта(ЭтотОбъект.Метаданные(), ЭлементыФормы.ДействияФормы.Кнопки.Подменю, ЭлементыФормы.Номер);
	
КонецПроцедуры // ПослеЗаписи()

////////////////////////////////////////////////////////////////////////////////
// ПРОЦЕДУРЫ - ДЕЙСТВИЯ КОМАНДНЫХ ПАНЕЛЕЙ ФОРМЫ

// Процедура разрешения/запрещения редактирования номера документа
Процедура ДействияФормыРедактироватьНомер(Кнопка)
	
	МеханизмНумерацииОбъектов.ИзменениеВозможностиРедактированияНомера(ЭтотОбъект.Метаданные(), ЭтаФорма, ЭлементыФормы.ДействияФормы.Кнопки.Подменю, ЭлементыФормы.Номер);
			
КонецПроцедуры

// Процедура вызывается при выборе пункта подменю "Движения документа по регистрам" меню "Перейти".
// командной панели формы. Процедура отрабатывает печать движений документа по регистрам.
//
Процедура ДействияФормыДвиженияДокументаПоРегистрам(Кнопка)

	РаботаСДиалогами.НапечататьДвиженияДокумента(Ссылка);

КонецПроцедуры // ДействияФормыДвиженияДокументаПоРегистрам()

// Процедура вызова структуры подчиненности документа
//
Процедура ДействияФормыСтруктураПодчиненностиДокумента(Кнопка)
	
	РаботаСДиалогами.ПоказатьСтруктуруПодчиненностиДокумента(Ссылка);
	
КонецПроцедуры // ДействияФормыСтруктураПодчиненностиДокумента()

// Процедура выполняет открытие формы работы со свойствами документа
//
Процедура ДействияФормыДействиеОткрытьСвойства(Кнопка)

	РаботаСДиалогами.ОткрытьСвойстваДокумента(ЭтотОбъект, ЭтаФорма);

КонецПроцедуры // ДействияФормыДействиеОткрытьСвойства()

// Процедура выполняет открытие формы работы с категориями документа
//
Процедура ДействияФормыДействиеОткрытьКатегории(Кнопка)

	РаботаСДиалогами.ОткрытьКатегорииДокумента(ЭтотОбъект, ЭтаФорма);

КонецПроцедуры // ДействияФормыДействиеОткрытьКатегории()

// Процедура - обработчик нажатия на кнопку "Печать по умолчанию"
//
Процедура ОсновныеДействияФормыПечатьПоУмолчанию(Кнопка)
	
	УниверсальныеМеханизмы.ПечатьПоДополнительнойКнопке(мДеревоМакетов, ЭтотОбъект, ЭтаФорма, Кнопка.Текст);
	
КонецПроцедуры // ОсновныеДействияФормыПечатьПоУмолчанию()

// Процедура - обработчик нажатия на кнопку "Печать"
//
Процедура ОсновныеДействияФормыПечать(Кнопка)
	
	УниверсальныеМеханизмы.ПечатьПоДополнительнойКнопке(мДеревоМакетов, ЭтотОбъект, ЭтаФорма, Кнопка.Текст);
	
КонецПроцедуры // ОсновныеДействияФормыПечать()

// Процедура - обработчик нажатия на кнопку "Установить печать по умолчанию"
//
Процедура ОсновныеДействияФормыУстановитьПечатьПоУмолчанию(Кнопка)
	
	Если УниверсальныеМеханизмы.НазначитьКнопкуПечатиПоУмолчанию(мДеревоМакетов, Метаданные().Имя) Тогда
		
		УстановитьКнопкиПечати();
		
	КонецЕсли;
	
КонецПроцедуры // ОсновныеДействияФормыУстановитьПечатьПоУмолчанию()

// Процедура - обработчик нажатия на любую из дополнительных кнопок по заполнению ТЧ
//
Процедура НажатиеНаДополнительнуюКнопкуЗаполненияТЧ(Кнопка)
	
	УниверсальныеМеханизмы.ОбработатьНажатиеНаДополнительнуюКнопкуЗаполненияТЧ(мКнопкиЗаполненияТЧ.Строки.Найти(Кнопка.Имя,"Имя",Истина),ЭтотОбъект);
	
КонецПроцедуры // НажатиеНаДополнительнуюКнопкуЗаполненияТЧ()


////////////////////////////////////////////////////////////////////////////////
// ПРОЦЕДУРЫ - ОБРАБОТЧИКИ СОБЫТИЙ ФОРМЫ

Процедура ДатаПриИзменении(Элемент)

	РаботаСДиалогами.ПроверитьНомерДокумента(ЭтотОбъект, мТекущаяДатаДокумента);
	МеханизмНумерацииОбъектов.ОбновитьПодсказкуКодНомерОбъекта(ЭтотОбъект.Метаданные(), ЭлементыФормы.ДействияФормы.Кнопки.Подменю, ЭлементыФормы.Номер);

	мТекущаяДатаДокумента = Дата;

КонецПроцедуры // ДатаПриИзменении()

Процедура ОрганизацияПриИзменении(Элемент)

	Если Не ПустаяСтрока(Номер) Тогда
		МеханизмНумерацииОбъектов.СброситьУстановленныйКодНомерОбъекта(ЭтотОбъект, "Номер", ЭлементыФормы.ДействияФормы.Кнопки.Подменю, ЭлементыФормы.Номер);
	КонецЕсли;
	
	ПодразделениеОрганизации = Справочники.ПодразделенияОрганизаций.ПустаяСсылка();
	
	// Получим и запомним ссылку на головную организацию
	мГоловнаяОрганизация = ОбщегоНазначения.ГоловнаяОрганизация(Организация);
	
	РаботаСДиалогами.УстановитьВидимостьЭУПоУчетнойПолитикеПоПерсоналу(мМассивЭУ, глЗначениеПеременной("глУчетнаяПолитикаПоПерсоналуОрганизации"),Организация);

КонецПроцедуры // ОрганизацияПриИзменении()

// Процедура - обработчик события "ПриИзменении" поля ввода периода регистрации.
//
Процедура ПериодПриИзменении(Элемент)
	
	РаботаСДиалогами.ДатаКакМесяцПодобратьДатуПоТексту(Элемент.Значение, ПериодРегистрации);
	Элемент.Значение = РаботаСДиалогами.ДатаКакМесяцПредставление(ПериодРегистрации);
	
КонецПроцедуры // ПериодПриИзменении()

// Процедура - обработчик события "Регулирование" поля ввода периода регистрации.
//
Процедура ПериодРегулирование(Элемент, Направление, СтандартнаяОбработка)
	
	ПериодРегистрации = ДобавитьМесяц(ПериодРегистрации, Направление);
	Элемент.Значение = РаботаСДиалогами.ДатаКакМесяцПредставление(ПериодРегистрации);
	
КонецПроцедуры // ПериодРегулирование()

// Процедура - обработчик события "Очистка" поля ввода периода регистрации.
//
Процедура ПериодОчистка(Элемент, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
КонецПроцедуры // ПериодРегулирование()

// Процедура - обработчик события "НачалоВыбораИзСписка" поля ввода периода регистрации.
//
Процедура ПериодНачалоВыбораИзСписка(Элемент, СтандартнаяОбработка)
	
	РаботаСДиалогами.НачалоВыбораИзСпискаПредставленияПериодаРегистрации(Элемент, СтандартнаяОбработка, ПериодРегистрации, ЭтаФорма);
	
КонецПроцедуры // ПериодНачалоВыбораИзСписка()

// Процедура - обработчик события "АвтоПодборТекста" поля ввода периода регистрации.
//
Процедура ПериодАвтоПодборТекста(Элемент, Текст, ТекстАвтоПодбора, СтандартнаяОбработка)
	
	РаботаСДиалогами.ДатаКакМесяцАвтоПодборТекста(Текст, ТекстАвтоПодбора, СтандартнаяОбработка);
	
КонецПроцедуры // ПериодАвтоПодборТекста()

// Процедура - обработчик события "ОкончаниеВводаТекста" поля ввода периода регистрации.
//
Процедура ПериодОкончаниеВводаТекста(Элемент, Текст, Значение, СтандартнаяОбработка)
	
	РаботаСДиалогами.ДатаКакМесяцОкончаниеВводаТекста(Текст, Значение, СтандартнаяОбработка);
	
КонецПроцедуры // ПериодОкончаниеВводаТекста()


////////////////////////////////////////////////////////////////////////////////
// ПРОЦЕДУРЫ - ОБРАБОТЧИКИ СОБЫТИЙ ТАБЛИЧНОГО ПОЛЯ 

Процедура СпецСтажОбработкаВыбора(Элемент, ВыбранноеЗначение, СтандартнаяОбработка)
	
	Если ТипЗнч(ВыбранноеЗначение) = Тип("СправочникСсылка.ВидыСтажа") Тогда

		Если ЭлементыФормы.СпецСтаж.ТекущаяСтрока  = Неопределено Тогда
			Возврат;
		КонецЕсли;
		
	    ЭлементыФормы.СпецСтаж.ТекущаяСтрока.ВидСтажа  = ВыбранноеЗначение;
		
	ИначеЕсли ТипЗнч(ВыбранноеЗначение) = Тип("СправочникСсылка.СотрудникиОрганизаций") Тогда

		СтандартнаяОбработка = Ложь;
	
		Если СпецСтаж.НайтиСтроки(Новый Структура("Сотрудник", ВыбранноеЗначение)).Количество() = 0 Тогда
			СтрокаТабличнойЧасти = СпецСтаж.Добавить();
			СтрокаТабличнойЧасти.Сотрудник	= ВыбранноеЗначение;
			СтрокаТабличнойЧасти.ДатаНачала	= ПериодРегистрации;
			СтрокаТабличнойЧасти.ДатаОкончания = КонецМесяца(ПериодРегистрации);
		КонецЕсли;

	КонецЕсли;
	
КонецПроцедуры

Процедура СпецСтажПриПолученииДанных(Элемент, ОформленияСтрок)
	
	РаботаСДиалогами.УстановитьЗначенияКолонкиТабельныйНомерСтрока(ЭлементыФормы.СпецСтаж, ОформленияСтрок);

КонецПроцедуры


////////////////////////////////////////////////////////////////////////////////
// ПРОЦЕДУРЫ - ОБРАБОТЧИКИ СОБЫТИЙ РЕКВИЗИТОВ ТАБЛИЧНОГО ПОЛЯ

Процедура СпецСтажСотрудникНачалоВыбора(Элемент, СтандартнаяОбработка)
	
	ПроцедурыУправленияПерсоналом.ОткрытьФормуВыбораСотрудникаОрганизации(Элемент, Ссылка, Истина, Дата, Организация, 0, СтандартнаяОбработка, Элемент.Значение);
	
КонецПроцедуры

Процедура СпецСтажСотрудникОбработкаВыбора(Элемент, ВыбранноеЗначение, СтандартнаяОбработка)
	
	Если ТипЗнч(ВыбранноеЗначение) = Тип("СправочникСсылка.СотрудникиОрганизаций") Тогда
		СтандартнаяОбработка = Ложь;
		Элемент.Значение = ВыбранноеЗначение;
	КонецЕсли;
	
КонецПроцедуры

Процедура СпецСтажСотрудникАвтоПодборТекста(Элемент, Текст, ТекстАвтоПодбора, СтандартнаяОбработка)
	
	ТекстАвтоПодбора = ПроцедурыУправленияПерсоналом.ПодобратьФИОРаботникаКандидата(СтандартнаяОбработка, "Работники", Текст, Организация);
	
КонецПроцедуры

Процедура СпецСтажСотрудникОкончаниеВводаТекста(Элемент, Текст, Значение, СтандартнаяОбработка)
	
	Значение = ПроцедурыУправленияПерсоналом.ПодобратьСписокРаботниковКандидатов(СтандартнаяОбработка, "Работники", Текст, Элемент.Значение, Организация);
	
КонецПроцедуры

Процедура СпецстажВидСтажаНачалоВыбора(Элемент, СтандартнаяОбработка)
	
	ФормаВыбора = Справочники.ВидыСтажа.ПолучитьФормуВыбора(,ЭлементыФормы.Спецстаж);

	ФормаВыбора.Отбор.ЛьготныйСтаж.ВидСравнения		= ВидСравнения.Равно;
	ФормаВыбора.Отбор.ЛьготныйСтаж.Значение			= Истина;
	ФормаВыбора.Отбор.ЛьготныйСтаж.Использование	= Истина;

	ФормаВыбора.Открыть();
	СтандартнаяОбработка = Ложь;

КонецПроцедуры



Процедура КоманднаяПанельСпецстажПодбор(Кнопка)
	
	ПроцедурыУправленияПерсоналом.ОткрытьФормуВыбораСотрудникаОрганизации(ЭлементыФормы.Спецстаж, Ссылка, Ложь, Дата, Организация);
	
КонецПроцедуры

Процедура ДействияФормыЗаполнить(Кнопка)
	
	Если Спецстаж.Количество() > 0 Тогда
			
		ТекстВопроса = НСтр("ru='Перед заполнением табличная часть будет очищена. Продолжить?';uk='Перед заповненням таблична частина буде очищена. Продовжити?'");
		Если Вопрос(ТекстВопроса, РежимДиалогаВопрос.ДаНет, , КодВозвратаДиалога.Да,) <> КодВозвратаДиалога.Да Тогда
			Возврат;
		КонецЕсли;
			
	КонецЕсли;
	
	ЗаполнитьДокумент();
	
КонецПроцедуры

Процедура ДействияФормыРассчитать(Кнопка)
	
	Если Спецстаж.Количество() > 0 Тогда
		Если НЕ РаботаСДиалогами.ЗаписатьДокументОтменивПроведениеПередВыполнениемДействия(ДокументОбъект, ЭтаФорма, НСтр("ru='рассчитать';uk='розрахувати'")) Тогда
			Возврат;
		КонецЕсли;
		РассчитатьДокумент();
	Иначе
		Сообщить(НСтр("ru='Нет информации о стаже для рассчета!';uk='Немає інформації про стаж для розрахунку!'"));
	КонецЕсли;	
	
КонецПроцедуры

Процедура ДействияФормыЗаполнитьИРассчитать(Кнопка)
	
	Если Спецстаж.Количество() > 0 Тогда
			
		ТекстВопроса = НСтр("ru='Перед заполнением табличная часть будет очищена. Продолжить?';uk='Перед заповненням таблична частина буде очищена. Продовжити?'");
		Если Вопрос(ТекстВопроса, РежимДиалогаВопрос.ДаНет, , КодВозвратаДиалога.Да,) <> КодВозвратаДиалога.Да Тогда
			Возврат;
		КонецЕсли;
			
	КонецЕсли;
	
	ЗаполнитьДокумент();
	
	Если Спецстаж.Количество() > 0 Тогда
		Если НЕ РаботаСДиалогами.ЗаписатьДокументОтменивПроведениеПередВыполнениемДействия(ДокументОбъект, ЭтаФорма, НСтр("ru='рассчитать';uk='розрахувати'")) Тогда
			Возврат;
		КонецЕсли;
		РассчитатьДокумент();
	Иначе
		Сообщить(НСтр("ru='Нет информации о стаже для рассчета!';uk='Немає інформації про стаж для розрахунку!'"));
	КонецЕсли;
	
КонецПроцедуры

Процедура ДействияФормыЗаполнитьСписком(Кнопка)
	
	Если Спецстаж.Количество() > 0 Тогда
		ТекстВопроса = НСтр("ru='Перед заполнением табличная часть будет очищены. Заполнить?';uk='Перед заповненням таблична частина будуть очищені. Заповнити?'");
		Ответ = Вопрос(ТекстВопроса, РежимДиалогаВопрос.ДаНет, , КодВозвратаДиалога.Да,);
		
		Если Ответ <> КодВозвратаДиалога.Да Тогда
			Возврат;
		КонецЕсли;
		
		Спецстаж.Очистить();
	КонецЕсли;

	ПроцедурыУправленияПерсоналом.ОткрытьФормуОтбораСпискаРаботников(ЭтаФорма, ПериодРегистрации, , Организация, , , ,"СпецСтаж", Новый Структура("ВидСтажа,СтажС,СтажПо,ЕдиницаСтажа, Сезонность, ГрафикНормыСтажа,Аттестация",Справочники.ВидыСтажа.ПустаяСсылка(), ПериодРегистрации,КонецМесяца(ПериодРегистрации), Перечисления.ЕдиницыВремениУчетаСпецстажа.КалендарныеДни,0,Справочники.ГрафикиРаботы.ПустаяСсылка(),Документы.АттестацияРабочихМестДляУчетаСпецстажа.ПустаяСсылка()));
	
КонецПроцедуры

Процедура ОбработкаВыбора(ЗначениеВыбора, Источник)
	
	Если ТипЗнч(ЗначениеВыбора) = Тип("Структура") Тогда
		Команда = "";  Реквизиты = "";
		Если ЗначениеВыбора.Свойство("Команда",Команда) и Команда = "ЗаполнитьСписокРаботников" Тогда			
			ВременнаяТаблица = ЗначениеВыбора.Данные.Выгрузить();
			
			Если ЗначениеВыбора.Свойство("Реквизиты",Реквизиты) Тогда
				Для Каждого Значение Из Реквизиты Цикл
					Если Значение.Ключ = "ВидСтажа" Тогда
						ВременнаяТаблица.Колонки.Добавить("ВидСтажа"); 
						ВременнаяТаблица.ЗаполнитьЗначения(Значение.Значение,"ВидСтажа");
					ИначеЕсли Значение.Ключ = "СтажС" Тогда
						ВременнаяТаблица.Колонки.Добавить("ДатаНачала"); 
						ВременнаяТаблица.ЗаполнитьЗначения(Значение.Значение,"ДатаНачала");	
					ИначеЕсли Значение.Ключ = "СтажПо" Тогда
						ВременнаяТаблица.Колонки.Добавить("ДатаОкончания"); 
						ВременнаяТаблица.ЗаполнитьЗначения(Значение.Значение,"ДатаОкончания");
					ИначеЕсли Значение.Ключ = "ЕдиницаСтажа" Тогда
						ВременнаяТаблица.Колонки.Добавить("ЕдиницаВремени"); 
						ВременнаяТаблица.ЗаполнитьЗначения(Значение.Значение,"ЕдиницаВремени");
					ИначеЕсли Значение.Ключ = "Сезонность" Тогда
						ВременнаяТаблица.Колонки.Добавить("Сезонность"); 
						ВременнаяТаблица.ЗаполнитьЗначения(Значение.Значение,"Сезонность");
					ИначеЕсли Значение.Ключ = "ГрафикНормыСтажа" Тогда
						ВременнаяТаблица.Колонки.Добавить("ГрафикНормы"); 
						ВременнаяТаблица.ЗаполнитьЗначения(Значение.Значение,"ГрафикНормы");
					ИначеЕсли Значение.Ключ = "Аттестация" Тогда
						ВременнаяТаблица.Колонки.Добавить("Приказ"); 
						ВременнаяТаблица.ЗаполнитьЗначения(Значение.Значение,"Приказ");	
					КонецЕсли;
				КонецЦикла;
					
			КонецЕсли;
			СпецСтаж.Загрузить(ВременнаяТаблица);
		КонецЕсли;	
	КонецЕсли;

КонецПроцедуры

Процедура СпецстажПриВыводеСтроки(Элемент, ОформлениеСтроки, ДанныеСтроки)
	
	Если ЗначениеЗаполнено(ДанныеСтроки.Приказ) Тогда
		ОформлениеСтроки.Ячейки.Приказ.Текст = "№ "+ДанныеСтроки.Приказ.Номер+" от "+Строка(ДанныеСтроки.Приказ.Дата); 
	КонецЕсли;
	
КонецПроцедуры






////////////////////////////////////////////////////////////////////////////////
// ОПЕРАТОРЫ ОСНОВНОЙ ПРОГРАММЫ

мСведенияОВидахРасчета = Новый Соответствие;
мВалютаРегламентированногоУчета = Константы.ВалютаРегламентированногоУчета.Получить();
