﻿////////////////////////////////////////////////////////////////////////////////
// ПЕРЕМЕННЫЕ МОДУЛЯ

Перем мТекущаяДатаДокумента;			// Хранит последнюю установленную дату документа - для проверки перехода документа в другой период
Перем мСведенияОВидахРасчета;
Перем мДеревоМакетов;					// Хранит дерево макетов печатных форм
Перем мПодменюПечати;					// Хранит элемент управления подменю печати
Перем мПечатьПоУмолчанию;				// Хранит элемент управления кнопку печать по умолчанию
Перем мКнопкиЗаполненияТЧ;				// Хранит дерево кнопок подменю заполнение ТЧ

Перем мВалютаРегламентированногоУчета;

// Массив ЭУ видимостью которых необходимо управлять в зависимости от учетной политики по персоналу
Перем мМассивЭУ;


////////////////////////////////////////////////////////////////////////////////
// ПРОЦЕДУРЫ И ФУНКЦИИ ОБЩЕГО НАЗНАЧЕНИЯ

// Процедура устанавливает подменю "Заполнить" в командных панелях ТЧ документа при необходимости
//
Процедура УстановитьКнопкиПодменюЗаполненияТЧ()

	мКнопкиЗаполненияТЧ = УниверсальныеМеханизмы.ПолучитьДеревоКнопокЗаполненияТабличныхЧастей(Ссылка,Новый Действие("НажатиеНаДополнительнуюКнопкуЗаполненияТЧ"));

	СоответствиеТЧ = Новый Соответствие;
	СоответствиеТЧ.Вставить(ЭлементыФормы.Удержания,ЭлементыФормы.КоманднаяПанельУдержания);
	
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
	СтруктураКолонок.Вставить("ВидРасчета");
	СтруктураКолонок.Вставить("Действие");
	СтруктураКолонок.Вставить("ДатаДействия");

	// Установить ограничение - изменять видимость колонок для табличной части Удержания
	ОбработкаТабличныхЧастей.УстановитьИзменятьВидимостьКолонокТабЧасти(ЭлементыФормы.Удержания.Колонки, СтруктураКолонок);

	// Вывести в заголовке формы статус документа (новый, не проведен, проведен).
	РаботаСДиалогами.УстановитьЗаголовокФормыДокумента(, ЭтотОбъект, ЭтаФорма);

	// Запомнить текущие значения реквизитов формы.
	мТекущаяДатаДокумента = Дата;
	
	// Установим видимость реквизитов в зависимости от уч.политики по персоналу организаций
	мМассивЭУ = Новый Массив();
	мМассивЭУ.Добавить(ЭлементыФормы.Удержания.Колонки.ТабельныйНомерСтрока);
	мМассивЭУ.Добавить(ЭлементыФормы.Удержания.Колонки.Валюта1);
	мМассивЭУ.Добавить(ЭлементыФормы.Удержания.Колонки.Валюта2);
	мМассивЭУ.Добавить(ЭлементыФормы.Удержания.Колонки.Валюта3);
	мМассивЭУ.Добавить(ЭлементыФормы.Удержания.Колонки.Валюта4);
	мМассивЭУ.Добавить(ЭлементыФормы.Удержания.Колонки.Валюта5);
	мМассивЭУ.Добавить(ЭлементыФормы.Удержания.Колонки.Валюта6);
	РаботаСДиалогами.УстановитьВидимостьЭУПоУчетнойПолитикеПоПерсоналу(мМассивЭУ,глЗначениеПеременной("глУчетнаяПолитикаПоПерсоналуОрганизации"),Организация);
	
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
	
	// Получим и запомним ссылку на головную организацию
	мГоловнаяОрганизация = ОбщегоНазначения.ГоловнаяОрганизация(Организация);
	
	РаботаСДиалогами.УстановитьВидимостьЭУПоУчетнойПолитикеПоПерсоналу(мМассивЭУ, глЗначениеПеременной("глУчетнаяПолитикаПоПерсоналуОрганизации"),Организация);

КонецПроцедуры // ОрганизацияПриИзменении()


////////////////////////////////////////////////////////////////////////////////
// ПРОЦЕДУРЫ - ОБРАБОТЧИКИ СОБЫТИЙ ТАБЛИЧНОГО ПОЛЯ Удержания
 
Процедура УдержанияПриВыводеСтроки(Элемент, ОформлениеСтроки, ДанныеСтроки)
	
	РаботаСДиалогами.ПриВыводеСтрокиПлановыхНачисленийИУдержаний(Элемент, ОформлениеСтроки, ДанныеСтроки, мСведенияОВидахРасчета, Ложь);
	
КонецПроцедуры // УдержанияПриВыводеСтроки()

Процедура УдержанияПриОкончанииРедактирования(Элемент, НоваяСтрока, ОтменаРедактирования)
	
	Если ОтменаРедактирования Тогда
		Возврат;
	КонецЕсли;
	
КонецПроцедуры // УдержанияПриОкончанииРедактирования()

Процедура УдержанияОбработкаВыбора(Элемент, ВыбранноеЗначение, СтандартнаяОбработка)
	
	Если ТипЗнч(ВыбранноеЗначение) <> Тип("СправочникСсылка.СотрудникиОрганизаций") Тогда
		Возврат;
	КонецЕсли;
	
	СтандартнаяОбработка = Ложь;
	
	Если Удержания.НайтиСтроки(Новый Структура("Сотрудник", ВыбранноеЗначение)).Количество() = 0 Тогда
		Удержания.Добавить().Сотрудник = ВыбранноеЗначение;
				
	КонецЕсли;
	
КонецПроцедуры // УдержанияОбработкаВыбора()

Процедура УдержанияПриПолученииДанных(Элемент, ОформленияСтрок)
	
	РаботаСДиалогами.УстановитьЗначенияКолонкиТабельныйНомерСтрока(ЭлементыФормы.Удержания, ОформленияСтрок);

КонецПроцедуры


////////////////////////////////////////////////////////////////////////////////
// ПРОЦЕДУРЫ - ОБРАБОТЧИКИ СОБЫТИЙ РЕКВИЗИТОВ ТАБЛИЧНОГО ПОЛЯ Удержания

Процедура УдержанияСотрудникНачалоВыбора(Элемент, СтандартнаяОбработка)
	
	ПроцедурыУправленияПерсоналом.ОткрытьФормуВыбораСотрудникаОрганизации(Элемент, Ссылка, Истина, Дата, Организация, 0, СтандартнаяОбработка, Элемент.Значение);
	
КонецПроцедуры // УдержанияФизЛицоНачалоВыбора()

Процедура УдержанияСотрудникОбработкаВыбора(Элемент, ВыбранноеЗначение, СтандартнаяОбработка)
	
	Если ТипЗнч(ВыбранноеЗначение) = Тип("СправочникСсылка.СотрудникиОрганизаций") Тогда
		СтандартнаяОбработка = Ложь;
		Элемент.Значение = ВыбранноеЗначение;
	КонецЕсли;
	
КонецПроцедуры

Процедура УдержанияСотрудникАвтоПодборТекста(Элемент, Текст, ТекстАвтоПодбора, СтандартнаяОбработка)
	
	ТекстАвтоПодбора = ПроцедурыУправленияПерсоналом.ПодобратьФИОРаботникаКандидата(СтандартнаяОбработка, "РаботникиИДоговорники", Текст, Организация);
	
КонецПроцедуры // УдержанияФизЛицоАвтоПодборТекста()

Процедура УдержанияСотрудникОкончаниеВводаТекста(Элемент, Текст, Значение, СтандартнаяОбработка)
	
	Значение = ПроцедурыУправленияПерсоналом.ПодобратьСписокРаботниковКандидатов(СтандартнаяОбработка, "РаботникиИДоговорники", Текст, Элемент.Значение, Организация);
	
КонецПроцедуры // УдержанияФизЛицоОкончаниеВводаТекста()

	
	
	
	

Процедура КоманднаяПанельУдержанияПодбор(Кнопка)
	
	ПроцедурыУправленияПерсоналом.ОткрытьФормуВыбораСотрудникаОрганизации(ЭлементыФормы.Удержания, Ссылка, Ложь, Дата, Организация);
	
КонецПроцедуры

Процедура УдержанияПриНачалеРедактирования(Элемент, НоваяСтрока, Копирование)
	
	Если НоваяСтрока Тогда
		ЭлементыФормы.Удержания.ТекущиеДанные.ДатаДействия = Дата;
		ЭлементыФормы.Удержания.ТекущиеДанные.Действие = Перечисления.ВидыДействияСНачислением.Начать;
	КонецЕсли;
	
КонецПроцедуры



////////////////////////////////////////////////////////////////////////////////
// ОПЕРАТОРЫ ОСНОВНОЙ ПРОГРАММЫ

мСведенияОВидахРасчета = Новый Соответствие;
мВалютаРегламентированногоУчета = Константы.ВалютаРегламентированногоУчета.Получить();
