﻿////////////////////////////////////////////////////////////////////////////////
// ПЕРЕМЕННЫЕ МОДУЛЯ

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

////////////////////////////////////////////////////////////////////////////////
// ПРОЦЕДУРЫ - ОБРАБОТЧИКИ СОБЫТИЙ ФОРМЫ

// Процедура устанавливает подменю "Заполнить" в командных панелях ТЧ документа при необходимости
//
Процедура УстановитьКнопкиПодменюЗаполненияТЧ();

	мКнопкиЗаполненияТЧ = УниверсальныеМеханизмы.ПолучитьДеревоКнопокЗаполненияТабличныхЧастей(Ссылка,Новый Действие("НажатиеНаДополнительнуюКнопкуЗаполненияТЧ"));

	СоответствиеТЧ = Новый Соответствие;
	СоответствиеТЧ.Вставить(ЭлементыФормы.Работники,ЭлементыФормы.КоманднаяПанельРаботникиОрганизации);
	
	УниверсальныеМеханизмы.СформироватьПодменюЗаполненияТЧПоДеревуКнопок(мКнопкиЗаполненияТЧ,СоответствиеТЧ);
	
КонецПроцедуры

// Процедура устанавливает подменю "Печать" и кнопку "Печать по умолчанию" при необходимости
//
Процедура УстановитьКнопкиПечати()
	
	ФормированиеПечатныхФорм.СоздатьКнопкиПечати(ЭтотОбъект, ЭтаФорма);	
	
КонецПроцедуры

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
	
	МеханизмНумерацииОбъектов.УстановитьДоступностьПоляВводаНомера(Метаданные(), ЭтаФорма, ЭлементыФормы.ДействияФормы.Кнопки.Подменю1, ЭлементыФормы.Номер);

	СтруктураКолонок = Новый Структура();

	// Установить колонки, видимостью которых пользователь управлять не может.
	СтруктураКолонок.Вставить("ФизЛицо");
 	СтруктураКолонок.Вставить("ДатаИзменения");
 	СтруктураКолонок.Вставить("СпособОтраженияВУпрУчете");

	// Установить ограничение - изменять видимость колонок для табличной части Начисления
	ОбработкаТабличныхЧастей.УстановитьИзменятьВидимостьКолонокТабЧасти(ЭлементыФормы.Работники.Колонки, СтруктураКолонок);

	// Вывести в заголовке формы вид операции и статус документа (новый, не проведен, проведен).
	РаботаСДиалогами.УстановитьЗаголовокФормыДокумента(, ЭтотОбъект, ЭтаФорма);

	мМассивЭУ = Новый Массив();
	мМассивЭУ.Добавить(ЭлементыФормы.Работники.Колонки.ТабельныйНомерСтрока);
	РаботаСДиалогами.УстановитьВидимостьЭУПоУчетнойПолитикеПоПерсоналу(мМассивЭУ,глЗначениеПеременной("глУчетнаяПолитикаПоПерсоналу"));
	
	// Запомнить текущие значения реквизитов формы.
	мТекущаяДатаДокумента        = Дата;

	// Установить активный реквизит.
	//Если Не РаботаСДиалогами.АктивизироватьРеквизитВФорме(ЭтотОбъект, ЭтаФорма) Тогда
	//	ТекущийЭлемент = ЭлементыФормы.Работники;
	//КонецЕсли;
	РаботаСДиалогами.АктивизироватьРеквизитВФорме(ЭтотОбъект, ЭтаФорма);

КонецПроцедуры

// Процедура - обработчик события "ОбработкаВыбора" формы.
//
Процедура ОбработкаВыбора(ЗначениеВыбора, Источник)
	
	Если ТипЗнч(ЗначениеВыбора) = Тип("Структура") Тогда
		Команда = "";
		Если ЗначениеВыбора.Свойство("Команда",Команда) и Команда = "ЗаполнитьСписокРаботников" Тогда
			Работники.Загрузить(ЗначениеВыбора.Данные.Выгрузить())
		КонецЕсли;
	КонецЕсли;

КонецПроцедуры

// Процедура - обработчик события "ПослеЗаписи" формы.
//
Процедура ПослеЗаписи()

	// Установка кнопок печати
	УстановитьКнопкиПечати();
	// Вывести в заголовке формы статус документа (новый, не проведен, проведен).
	РаботаСДиалогами.УстановитьЗаголовокФормыДокумента(, ЭтотОбъект, ЭтаФорма);
	МеханизмНумерацииОбъектов.ОбновитьПодсказкуКодНомерОбъекта(ЭтотОбъект.Метаданные(), ЭлементыФормы.ДействияФормы.Кнопки.Подменю1, ЭлементыФормы.Номер);
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// ПРОЦЕДУРЫ - ДЕЙСТВИЯ КОМАНДНЫХ ПАНЕЛЕЙ ФОРМЫ

Процедура ДействияФормыОчистить(Кнопка)
	
	Если Работники.Количество() > 0 Тогда
		
		ТекстВопроса = НСтр("ru='Табличная часть будет очищена. Продолжить?';uk='Таблична частина буде очищена. Продовжити?'");
		Ответ = Вопрос(ТекстВопроса, РежимДиалогаВопрос.ДаНет, , КодВозвратаДиалога.Да,);
		
		Если Ответ <> КодВозвратаДиалога.Да Тогда
			Возврат;
		КонецЕсли; 
		
		Работники.Очистить();
		
	КонецЕсли; 
	
КонецПроцедуры

// Процедура вызывается при выборе пункта подменю "Движения документа по регистрам" меню "Перейти".
// командной панели формы. Процедура отрабатывает печать движений документа по регистрам.
//
Процедура ДействияФормыДвиженияДокументаПоРегистрам(Кнопка)

	РаботаСДиалогами.НапечататьДвиженияДокумента(Ссылка);

КонецПроцедуры // ДействияФормыДвиженияДокументаПоРегистрам()

// Процедура - вызывается при нажатии на кнопку "Заполнить"
//
Процедура ДействияФормыЗаполнить(Кнопка)
	
	Если Работники.Количество() > 0 Тогда
		ТекстВопроса = НСтр("ru='Перед заполнением табличные части будут очищены. Заполнить?';uk='Перед заповненням табличні частини будуть очищені. Заповнити?'");
		Ответ = Вопрос(ТекстВопроса, РежимДиалогаВопрос.ДаНет, , КодВозвратаДиалога.Да,);
		
		Если Ответ <> КодВозвратаДиалога.Да Тогда
			Возврат;
		КонецЕсли;
		Работники.Очистить();
	КонецЕсли;
	
	ПроцедурыУправленияПерсоналом.ОткрытьФормуОтбораСпискаРаботников(ЭтаФорма, Дата, "Работники", );
	
КонецПроцедуры

// Процедура - вызывается при нажатии на кнопку "Подбор"
//
Процедура КоманднаяПанельРаботникиОрганизацииПодбор(Кнопка)
	
	ПроцедурыУправленияПерсоналом.ОткрытьФормуВыбораСотрудника(ЭлементыФормы.Работники, Ссылка, Ложь, Дата);
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// ПРОЦЕДУРЫ - ОБРАБОТЧИКИ СОБЫТИЙ РЕКВИЗИТОВ ШАПКИ

// Процедура - обработчик события "ПриИзменении" поля ввода даты документа
//
Процедура ДатаПриИзменении(Элемент = Неопределено)

	РаботаСДиалогами.ПроверитьНомерДокумента(ДокументОбъект, мТекущаяДатаДокумента);
	МеханизмНумерацииОбъектов.ОбновитьПодсказкуКодНомерОбъекта(ЭтотОбъект.Метаданные(), ЭлементыФормы.ДействияФормы.Кнопки.Подменю1, ЭлементыФормы.Номер);

	мТекущаяДатаДокумента = Дата;

КонецПроцедуры // ДатаПриИзменении

// Процедура - обработчик события "ПриИзменении" документа-основания
Процедура ДокументОснованиеПриИзменении(Элемент)
	
	Если Не ЗначениеЗаполнено(ДокументОснование) Тогда
		Возврат;
	КонецЕсли; 
	
	Если Работники.Количество() > 0 Тогда
		Ответ = Вопрос(НСтр("ru='Список работников будет перезаполнен."
"Продолжить?';uk='Список працівників буде перезаповнений."
"Продовжити?'"), РежимДиалогаВопрос.ОКОтмена);
		Если Ответ = КодВозвратаДиалога.Отмена Тогда
			Возврат;
		КонецЕсли;
	КонецЕсли; 
	                 
	Работники.Очистить();
	
	ОснованиеПрием = (ТипЗнч(ДокументОснование) = Тип("ДокументСсылка.ПриемНаРаботу"));
	ТЧОснования = ДокументОснование.Работники;
	
	Для каждого  СтрокаОснования Из ТЧОснования Цикл
		
		НоваяСтрока = Работники.Добавить();
		НоваяСтрока.ФизЛицо = СтрокаОснования.Физлицо;
		Если ОснованиеПрием Тогда
			НоваяСтрока.ДатаИзменения = СтрокаОснования.ДатаПриема;
		Иначе
			НоваяСтрока.ДатаИзменения = СтрокаОснования.ДатаНачала;
		КонецЕсли;
		
	КонецЦикла; 
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// ПРОЦЕДУРЫ - ОБРАБОТЧИКИ СОБЫТИЙ ТАБЛИЧНОГО ПОЛЯ

// Процедура - обработчик события "НачалоВыбора" поля ввода приказа  о приёме работника организации
Процедура РаботникиОбработкаВыбора(Элемент, ВыбранноеЗначение, СтандартнаяОбработка)
		
	Если ТипЗнч(ВыбранноеЗначение) <> Тип("СправочникСсылка.СотрудникиОрганизаций") Тогда
		Возврат;
	КонецЕсли;
	
	СтандартнаяОбработка = Ложь;
	
	Если Работники.НайтиСтроки(Новый Структура("Сотрудник", ВыбранноеЗначение)).Количество() = 0 Тогда
		Работники.Добавить().Сотрудник = ВыбранноеЗначение;
	КонецЕсли;
	
КонецПроцедуры // РаботникиОбработкаВыбора

// Процедура - обработчик события "ПриПолученииДанных"
Процедура РаботникиПриПолученииДанных(Элемент, ОформленияСтрок)
	РаботаСДиалогами.УстановитьЗначенияКолонкиТабельныйНомерСтрока(ЭлементыФормы.Работники, ОформленияСтрок);
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ РЕКВИЗИТОВ ТАБЛИЧНОЙ ЧАСТИ

Процедура РаботникиСотрудникПриИзменении(Элемент)
	
	ДанныеСтроки = ЭлементыФормы.Работники.ТекущиеДанные;
	ДанныеСтроки.ФизЛицо = Элемент.Значение.ФизЛицо;
	
КонецПроцедуры

// Процедура - обработчик события "ПриИзменении" поля ввода физического лица -  
// подбирает подходящие должность и подразделение
//
// Параметры:
//  Элемент - элемент формы, который отображает физическое лицо
//
Процедура РаботникиСотрудникНачалоВыбора(Элемент, СтандартнаяОбработка)
	
	ПроцедурыУправленияПерсоналом.ОткрытьФормуВыбораСотрудника(Элемент, Ссылка, Истина, Дата, СтандартнаяОбработка, Элемент.Значение);
	
КонецПроцедуры

// Процедура - обработчик события "АвтоПодборТекста" поля ввода физлица
// переопеределим выбор физлица на выбор из списка регистра сведений
//
Процедура РаботникиСотрудникАвтоПодборТекста(Элемент, Текст, ТекстАвтоПодбора, СтандартнаяОбработка)
	ТекстАвтоПодбора = ПроцедурыУправленияПерсоналом.ПодобратьФИОРаботникаКандидата(СтандартнаяОбработка, "Работники", Текст);
КонецПроцедуры

// Процедура - обработчик события "АвтоПодборТекста" поля ввода физлица
// переопеределим выбор физлица на выбор из списка регистра сведений
//
Процедура РаботникиСотрудникОкончаниеВводаТекста(Элемент, Текст, Значение, СтандартнаяОбработка)
	Значение = ПроцедурыУправленияПерсоналом.ПодобратьСписокРаботниковКандидатов(СтандартнаяОбработка, "Работники", Текст, Элемент.Значение);
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

// Процедура вызова структуры подчиненности документа
Процедура ДействияФормыСтруктураПодчиненностиДокумента(Кнопка)
	РаботаСДиалогами.ПоказатьСтруктуруПодчиненностиДокумента(Ссылка);
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

// Процедура разрешения/запрещения редактирования номера документа
Процедура ДействияФормыРедактироватьНомер(Кнопка)
	
	МеханизмНумерацииОбъектов.ИзменениеВозможностиРедактированияНомера(ЭтотОбъект.Метаданные(), ЭтаФорма, ЭлементыФормы.ДействияФормы.Кнопки.Подменю1, ЭлементыФормы.Номер);
			
КонецПроцедуры









