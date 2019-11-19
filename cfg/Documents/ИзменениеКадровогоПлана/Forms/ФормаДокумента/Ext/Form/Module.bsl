﻿////////////////////////////////////////////////////////////////////////////////
// ПЕРЕМЕННЫЕ МОДУЛЯ

// Хранит последнюю установленную дату документа - для проверки перехода документа в другой период
Перем мТекущаяДатаДокумента;

// Хранит дерево макетов печатных форм
Перем мДеревоМакетов;

// Хранит элемент управления подменю печати
Перем мПодменюПечати;

// Хранит элемент управления кнопку печать по умолчанию
Перем мПечатьПоУмолчанию;

// Хранит дерево кнопок подменю заполнение ТЧ
Перем мКнопкиЗаполненияТЧ;

Перем мОбновлятьВладельца;

Перем мРежимНабораПерсонала;

////////////////////////////////////////////////////////////////////////////////
// ПРОЦЕДУРЫ И ФУНКЦИИ ОБЩЕГО НАЗНАЧЕНИЯ

// Процедура устанавливает подменю "Заполнить" в командных панелях ТЧ документа при необходимости
//
Процедура УстановитьКнопкиПодменюЗаполненияТЧ()
	
	мКнопкиЗаполненияТЧ = УниверсальныеМеханизмы.ПолучитьДеревоКнопокЗаполненияТабличныхЧастей(Ссылка,Новый Действие("НажатиеНаДополнительнуюКнопкуЗаполненияТЧ"));
	
	СоответствиеТЧ = Новый Соответствие;
	СоответствиеТЧ.Вставить(ЭлементыФормы.РабочиеМеста,ЭлементыФормы.КоманднаяПанельРабочиеМеста);
	
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

	мРежимНабораПерсонала = Константы.РежимНабораПерсонала.Получить();
	
	// Установить колонки, видимостью которых пользователь управлять не может.
	СтруктураКолонок = Новый Структура();
	СтруктураКолонок.Вставить("Подразделение");
	СтруктураКолонок.Вставить("Должность");

	// Установить ограничение - изменять видимость колонок табличной части РабочиеМеста
	ОбработкаТабличныхЧастей.УстановитьИзменятьВидимостьКолонокТабЧасти(ЭлементыФормы.РабочиеМеста.Колонки, СтруктураКолонок);

	// Вывести в заголовке формы вид операции и статус документа (новый, не проведен, проведен).
	РаботаСДиалогами.УстановитьЗаголовокФормыДокумента(, ЭтотОбъект, ЭтаФорма);

	// Запомнить текущие значения реквизитов формы.
	мТекущаяДатаДокумента = ДокументОбъект.Дата;

	// Установить активный реквизит.
	//Если Не РаботаСДиалогами.АктивизироватьРеквизитВФорме(ЭтотОбъект, ЭтаФорма) Тогда
	//	ТекущийЭлемент = ЭлементыФормы.РабочиеМеста;
	//КонецЕсли;
	РаботаСДиалогами.АктивизироватьРеквизитВФорме(ЭтотОбъект, ЭтаФорма);

КонецПроцедуры

Процедура ПередЗаписью(Отказ, РежимЗаписи, РежимПроведения)
	
	Если Модифицированность И ВладелецФормы <> Неопределено И НЕ ЭтоНовый() Тогда
		мОбновлятьВладельца = Истина;
	КонецЕсли;
	
КонецПроцедуры

// Процедура - обработчик события "ПослеЗаписи" формы.
//
Процедура ПослеЗаписи()
	
	// если открыт кадровый план - оповестим о необходимости обновить список рабочих мест
	Оповестить("ИзмененКадровыйПлан");
	
	// Установка кнопок печати
	УстановитьКнопкиПечати();
	// Вывести в заголовке формы статус документа (новый, не проведен, проведен).
	РаботаСДиалогами.УстановитьЗаголовокФормыДокумента(, ЭтотОбъект, ЭтаФорма);
	МеханизмНумерацииОбъектов.ОбновитьПодсказкуКодНомерОбъекта(ЭтотОбъект.Метаданные(), ЭлементыФормы.ДействияФормы.Кнопки.Подменю, ЭлементыФормы.Номер);
	
КонецПроцедуры

Процедура ПриЗакрытии()
	
	Если мОбновлятьВладельца Тогда
		ОповеститьОЗаписиНовогоОбъекта(Ссылка);
	КонецЕсли;
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// ПРОЦЕДУРЫ - ДЕЙСТВИЯ КОМАНДНЫХ ПАНЕЛЕЙ ФОРМЫ

// Процедура вызывается при выборе пункта подменю "Движения документа по регистрам" меню "Перейти".
// командной панели формы. Процедура отрабатывает печать движений документа по регистрам.
//
Процедура ДействияФормыДвиженияДокументаПоРегистрам(Кнопка)

	РаботаСДиалогами.НапечататьДвиженияДокумента(Ссылка);

КонецПроцедуры // ДействияФормыДвиженияДокументаПоРегистрам()

// Процедура вызова структуры подчиненности документа
Процедура ДействияФормыСтруктураПодчиненностиДокумента(Кнопка)
	
	РаботаСДиалогами.ПоказатьСтруктуруПодчиненностиДокумента(Ссылка);
	
КонецПроцедуры

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


Процедура КоманднаяПанельРабочиеМестаЗаполнитьПоТекущемуСостоянию(Кнопка)
	
	Если РабочиеМеста.Количество() > 0 Тогда
		ТекстВопроса = НСтр("ru='Имеющийся кадровый план будет очищен. Продолжить?';uk='Наявний кадровий план буде очищений. Продовжити?'");
		Ответ  = Вопрос(ТекстВопроса, РежимДиалогаВопрос.ОКОтмена);
		
		Если Ответ = КодВозвратаДиалога.Отмена Тогда
			Возврат;
		КонецЕсли;
	КонецЕсли;
	
	ЗаполнитьТабличнуюЧастьРабочиеМестаПоТекущемуСостоянию();
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ РЕКВИЗИТОВ ШАПКИ

// Процедура выполняет алгоритм действий при изменении даты документа
//
// Параметры:
//  Элемент - элемент формы, который отображает дату документа
//
Процедура ДатаПриИзменении(Элемент = Неопределено)

	РаботаСДиалогами.ПроверитьНомерДокумента(ДокументОбъект, мТекущаяДатаДокумента);
	МеханизмНумерацииОбъектов.ОбновитьПодсказкуКодНомерОбъекта(ЭтотОбъект.Метаданные(), ЭлементыФормы.ДействияФормы.Кнопки.Подменю, ЭлементыФормы.Номер);

	мТекущаяДатаДокумента = ДокументОбъект.Дата;

КонецПроцедуры // ДатаПриИзменении

////////////////////////////////////////////////////////////////////////////////
// ПРОЦЕДУРЫ - ОБРАБОТЧИКИ СОБЫТИЙ ТЧ РабочиеМеста

// Процедура обеспечивает начальное значение реквизита "КоличествоСтавок"
//
// Параметры:
//  Элемент      - табличное поле, которое отображает т.ч.
//  НоваяСтрока  - булево, признак редактирования новой строки
//  
Процедура РабочиеМестаПриНачалеРедактирования(Элемент, НоваяСтрока)
	
	Если НоваяСтрока Тогда
		Если НЕ ЗначениеЗаполнено(Элемент.ТекущаяСтрока.Подразделение) Тогда
			Если мРежимНабораПерсонала = Перечисления.ВидыОрганизационнойСтруктурыПредприятия.ПоСтруктуреЮридическихЛиц Тогда
				Элемент.ТекущаяСтрока.Подразделение = Справочники.ПодразделенияОрганизаций.ПустаяСсылка();
			Иначе
				Элемент.ТекущаяСтрока.Подразделение = Справочники.Подразделения.ПустаяСсылка();
			КонецЕсли;
		КонецЕсли;	
		
		Если НЕ ЗначениеЗаполнено(Элемент.ТекущаяСтрока.Количество) Тогда
			Элемент.ТекущаяСтрока.Количество = 1;
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

// Процедура разрешения/запрещения редактирования номера документа
Процедура ДействияФормыРедактироватьНомер(Кнопка)
	
	МеханизмНумерацииОбъектов.ИзменениеВозможностиРедактированияНомера(ЭтотОбъект.Метаданные(), ЭтаФорма, ЭлементыФормы.ДействияФормы.Кнопки.Подменю, ЭлементыФормы.Номер);
			
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// ОПЕРАТОРЫ ОСНОВНОЙ ПРОГРАММЫ

мОбновлятьВладельца = Ложь;
