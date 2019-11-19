﻿////////////////////////////////////////////////////////////////////////////////
// ПЕРЕМЕННЫЕ МОДУЛЯ

// Хранит текущую дату документа - для проверки перехода документа в другой период установки номера
Перем мТекущаяДатаДокумента; 
Перем мКнопкаЗаполнения;

// Хранит дерево макетов печатных форм
Перем мДеревоМакетов;

// Хранит элемент управления подменю печати
Перем мПодменюПечати;

// Хранит элемент управления кнопку печать по умолчанию
Перем мПечатьПоУмолчанию;

// Хранит дерево кнопок подменю заполнение ТЧ
Перем мКнопкиЗаполненияТЧ;

////////////////////////////////////////////////////////////////////////////////
// ВСПОМОГАТЕЛЬНЫЕ ПРОЦЕДУРЫ И ФУНКЦИИ

// Процедура устанавливает подменю "Заполнить" в командных панелях ТЧ документа при необходимости
//
Процедура УстановитьКнопкиПодменюЗаполненияТЧ();
	
	мКнопкиЗаполненияТЧ = УниверсальныеМеханизмы.ПолучитьДеревоКнопокЗаполненияТабличныхЧастей(Ссылка,Новый Действие("НажатиеНаДополнительнуюКнопкуЗаполненияТЧ"));
	
	СоответствиеТЧ = Новый Соответствие;
	СоответствиеТЧ.Вставить(ЭлементыФормы.ОбучающиесяРаботники,ЭлементыФормы.КоманднаяПанельОбучающиесяРаботники.Кнопки.ПодменюЗаполнить);
	
	УниверсальныеМеханизмы.СформироватьПодменюЗаполненияТЧПоДеревуКнопок(мКнопкиЗаполненияТЧ,СоответствиеТЧ);
	
КонецПроцедуры

// Процедура устанавливает подменю "Печать" и кнопку "Печать по умолчанию" при необходимости
//
Процедура УстановитьКнопкиПечати()
	
	ФормированиеПечатныхФорм.СоздатьКнопкиПечати(ЭтотОбъект, ЭтаФорма);	
	
КонецПроцедуры

// Процедура показывает / скрывает колонки с реквизитами документа об обучении.
//
Процедура УправлениеВидимостьюТЧ()

	ПоказатьКолонки = Ложь;
	
	// Показ полей для ввода реквизитов документов об образовании,
	// в случае, если таковой предусмотрен курсом.
	// И если установлен флаг прохождения курса.
	
	Если ФактЗавершенияКурса
    И ЗначениеЗаполнено(КурсОбучения) 
    И ЗначениеЗаполнено(КурсОбучения.ВидДокументаОбОбразовании) Тогда
		ПоказатьКолонки = Истина				 
	КонецЕсли;

	// Если введены данные в колоники реквизитов - показывать колонки
	Если НЕ ПоказатьКолонки Тогда  
		Для Каждого СтрокаТЧ Из ОбучающиесяРаботники Цикл
			Если НЕ СтрокаТЧ.РеквизитыДокумента = "" Тогда 
				ПоказатьКолонки = Истина;
				Прервать;	
			КонецЕсли;	
		КонецЦикла;
	КонецЕсли;

	
	Если НЕ ПоказатьКолонки Тогда 
		ПустаяДата = Дата('00010101');
		Для Каждого СтрокаТЧ Из ОбучающиесяРаботники Цикл
			Если НЕ СтрокаТЧ.ДатаПолученияДокумента = ПустаяДата Тогда 
				ПоказатьКолонки = Истина;
				Прервать;	
			КонецЕсли;	
		КонецЦикла;
	КонецЕсли;
	
	ЭлементыФормы.ОбучающиесяРаботники.Колонки.ДатаПолученияДокумента.Видимость = ПоказатьКолонки;
    ЭлементыФормы.ОбучающиесяРаботники.Колонки.РеквизитыДокумента.Видимость = ПоказатьКолонки;
	
	Если Не ПоказатьКолонки Тогда
		Если Элементыформы.КоманднаяПанельОбучающиесяРаботники.Кнопки.Количество() = 14 Тогда
			Элементыформы.КоманднаяПанельОбучающиесяРаботники.Кнопки.Удалить(13)
		КонецЕсли;
	ИначеЕсли Элементыформы.КоманднаяПанельОбучающиесяРаботники.Кнопки.Количество() = 12 Тогда  
		Элементыформы.КоманднаяПанельОбучающиесяРаботники.Кнопки.Вставить(12,мКнопкаЗаполнения.Имя,мКнопкаЗаполнения.ТипКнопки,мКнопкаЗаполнения.Текст,мКнопкаЗаполнения.Действие)
	КонецЕсли;
	
КонецПроцедуры // УправлениеВидимостьюТЧ()

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

Процедура ПриОткрытии()

	Если ЭтоНовый() Тогда // проверить объект на то, что он еще не внесен в ИБ
		
		// Заполнить реквизиты значениями по умолчанию.
		ЗаполнениеДокументов.ЗаполнитьШапкуДокумента(ЭтотОбъект);
	Иначе 
		// Установить доступность формы с учетом даты запрета редактирования	
		РаботаСДиалогами.УстановитьДоступностьФормыДляРедактирования(ЭтотОбъект, ЭтаФорма);
	КонецЕсли;

	МеханизмНумерацииОбъектов.УстановитьДоступностьПоляВводаНомера(Метаданные(), ЭтаФорма, ЭлементыФормы.ДействияФормы.Кнопки.Подменю,ЭлементыФормы.Номер);
	
	ЭлементыФормы.ДатаЗавершенияКурса.АвтоОтметкаНезаполненного = ФактЗавершенияКурса;
	мКнопкаЗаполнения = Элементыформы.КоманднаяПанельОбучающиесяРаботники.Кнопки.ПодменюЗаполнить.Кнопки.ЗаполнитьДату;
	УправлениеВидимостьюТЧ();
	
	// Вывести в заголовке формы статус документа (новый, не проведен, проведен).
	РаботаСДиалогами.УстановитьЗаголовокФормыДокумента(, ЭтотОбъект, ЭтаФорма);

	// Запомнить текущие значения реквизитов формы.
	мТекущаяДатаДокумента = Дата;
	
	// Название кнопки "Мероприятия"
	Если Мероприятие.Пустая() Тогда
		ЭлементыФормы.ДействияФормы.Кнопки.Организация.Кнопки.СоздатьМероприятие.Текст = НСтр("ru='Создать мероприятие';uk='Створити захід'")
	Иначе
		ЭлементыФормы.ДействияФормы.Кнопки.Организация.Кнопки.СоздатьМероприятие.Текст  = НСтр("ru='Открыть мероприятие';uk='Відкрити захід'")
	КонецЕсли;
	
	Если ДокументУчастияВМероприятии.Пустая() Тогда
		ЭлементыФормы.ДействияФормы.Кнопки.Организация.Кнопки.Занятость.Текст = НСтр("ru='Запланировать занятость';uk='Запланувати занятість'")
	Иначе
		ЭлементыФормы.ДействияФормы.Кнопки.Организация.Кнопки.Занятость.Текст  = НСтр("ru='Открыть занятость';uk='Відкрити занятість'")
	КонецЕсли;
	
	мМассивЭУ = Новый Массив();
	мМассивЭУ.Добавить(ЭлементыФормы.ОбучающиесяРаботники.Колонки.ТабельныйНомерСтрока);
	РаботаСДиалогами.УстановитьВидимостьЭУПоУчетнойПолитикеПоПерсоналу(мМассивЭУ,глЗначениеПеременной("глУчетнаяПолитикаПоПерсоналу"));

	
	// Установить активный реквизит.
	//Если Не РаботаСДиалогами.АктивизироватьРеквизитВФорме(ЭтотОбъект, ЭтаФорма) Тогда
	//	ТекущийЭлемент = ЭлементыФормы.ОбучающиесяРаботники;
	//КонецЕсли;	
	РаботаСДиалогами.АктивизироватьРеквизитВФорме(ЭтотОбъект, ЭтаФорма);

КонецПроцедуры

Процедура ПослеЗаписи()

	// Установка кнопок печати
	УстановитьКнопкиПечати();
	// Вывести в заголовке формы статус документа (новый, не проведен, проведен).
	РаботаСДиалогами.УстановитьЗаголовокФормыДокумента(, ЭтотОбъект, ЭтаФорма);
	МеханизмНумерацииОбъектов.ОбновитьПодсказкуКодНомерОбъекта(ЭтотОбъект.Метаданные(), ЭлементыФормы.ДействияФормы.Кнопки.Подменю, ЭлементыФормы.Номер);
КонецПроцедуры

// Процедура - обработчик события "ОбработкаВыбора" формы.
//
Процедура ОбработкаВыбора(ЗначениеВыбора, Источник)
	
	Если ТипЗнч(ЗначениеВыбора) <> Тип("Структура") Тогда
		Возврат;
	КонецЕсли;
	
	Команда = "";
	Если ЗначениеВыбора.Свойство("Команда",Команда) и Команда = "ЗаполнитьСписокРаботников" Тогда
		ОбучающиесяРаботники.Загрузить(ЗначениеВыбора.Данные.Выгрузить());
	КонецЕсли;
	
КонецПроцедуры


////////////////////////////////////////////////////////////////////////////////
// ПРОЦЕДУРЫ - ДЕЙСТВИЯ КОМАНДНЫХ ПАНЕЛЕЙ ФОРМЫ

// Процедура вызова структуры подчиненности документа
Процедура ДействияФормыСтруктураПодчиненностиДокумента(Кнопка)
	РаботаСДиалогами.ПоказатьСтруктуруПодчиненностиДокумента(Ссылка);
КонецПроцедуры

// Процедура вызывается при выборе пункта подменю "Движения документа по регистрам" меню "Перейти".
// командной панели формы. Процедура отрабатывает печать движений документа по регистрам.
//
Процедура ДействияФормыДвиженияДокументаПоРегистрам(Кнопка)

	РаботаСДиалогами.НапечататьДвиженияДокумента(Ссылка);

КонецПроцедуры // ДействияФормыДвиженияДокументаПоРегистрам()

// Процедура вызывается при нажатии кнопки "СоздатьМероприятие" в командной 
// панели формы, модменю "Организация обучения".
// Создает или открывает мероприятие.
//
Процедура ДействияФормыСоздатьМероприятие(Кнопка)

	// Проверка на запись. Если не записан - записать надо или отмена действия.
	Если НЕ Проведен Тогда
		Вопрос(НСтр("ru='Сначала проведите документ';uk='Спочатку проведіть документ'"), РежимДиалогаВопрос.ОК,,);
		возврат
	Конецесли;
		
	Если Модифицированность Тогда 
		
		Отказ = Ложь;
	
	
		Если Вопрос(НСтр("ru='Перед созданием мероприятия документ необходимо записать. Записать документ?';uk='Перед створенням заходу документ необхідно записати. Записати документ?'"), РежимДиалогаВопрос.ОКОтмена,, КодВозвратаДиалога.ОК,) = КодВозвратаДиалога.ОК Тогда
			Отказ = Не ЗаписатьВФорме();
		Иначе
			Возврат
		КонецЕсли;
	

		Если Отказ Тогда
			Возврат 
		КонецЕсли;

	КонецЕсли;
		
	Если Мероприятие.Пустая() Тогда 
		// Если курс помечен как пройденный, спросить "а стоит ли планировать?"
		Отказ = Ложь;
		Если ФактЗавершенияКурса тогда
			
			ОтветНаВопрос = Вопрос(НСтр("ru='Данный курс помечен как пройденный. Надо планировать его проведение?';uk='Даний курс позначений як пройдений. Потрібно планувати його проведення?'"), РежимДиалогаВопрос.ДаНет);
			Если ОтветНаВопрос = КодВозвратаДиалога.Нет Тогда
            	Отказ = Истина
			КонецЕсли;
			
		КонецЕсли;
		
		Если НЕ Отказ Тогда
		// Создать мероприятие
		ИмяМероприятия = Строка(КурсОбучения) + ". " + Строка(Ответственный) + ". " + Строка(ОбучающиесяРаботники.Количество()) + НСтр("ru=' Чел.';uk=' Чол.'");  
		
		НовоеМероприятие = Справочники.Мероприятия.СоздатьЭлемент();
		НовоеМероприятие.Наименование = ИмяМероприятия;
		НовоеМероприятие.Записать();
		
		// Скопировать занятия в состав мероприятия
		Для каждого строкаТЧ из КурсОбучения.ЗанятияКурса Цикл
			ЧастьМероприятия = Справочники.СоставМероприятия.СоздатьЭлемент();
			ЧастьМероприятия.Владелец = НовоеМероприятие.Ссылка;
			ЧастьМероприятия.Наименование = строкаТЧ.Занятие.Наименование;
			ЧастьМероприятия.Записать();		
		КонецЦикла;
		
		
		// Присвоить новое мероприятие реквезиту мероприятие. Открыть форму
		Мероприятие = НовоеМероприятие.Ссылка;
		Мероприятие.ПолучитьФорму("ФормаЭлемента").Открыть();

		КонецЕсли;
	
	Иначе
		
	// Если мероприятие уже созданно - открыть его.
	Мероприятие.ПолучитьФорму("ФормаЭлемента").Открыть();
	КонецЕсли;
	
	// Название кнопки "Мероприятия"
	Если Мероприятие.Пустая() Тогда
		ЭлементыФормы.ДействияФормы.Кнопки.Организация.Кнопки.СоздатьМероприятие.Текст = НСтр("ru='Создать мероприятие';uk='Створити захід'")
	Иначе
		ЭлементыФормы.ДействияФормы.Кнопки.Организация.Кнопки.СоздатьМероприятие.Текст  = НСтр("ru='Открыть мероприятие';uk='Відкрити захід'")
	КонецЕсли;
	
	// Записать документ еще раз.
	ЗаписатьВФорме();
	
КонецПроцедуры

// Процедура вызывается при нажатии кнопки "Занятость" в командной 
// панели формы, модменю "Организация обучения".
// создает или открывает документ "Участие в мероприятии"
//
Процедура ДействияФормыЗанятость(Кнопка)
	
	Если Мероприятие.Пустая() Тогда 
		Вопрос(НСтр("ru='Сначала создайте мероприятие';uk='Спочатку створіть захід'"), РежимДиалогаВопрос.ОК,,);
		Возврат;	
	КонецЕсли;
	
	Если ДокументУчастияВМероприятии.Пустая() Тогда 
		
		// Создать мероприятие
		ИмяМероприятия = Строка(КурсОбучения) + ". " + Строка(Ответственный) + ". " + Строка(ОбучающиесяРаботники.Количество()) + НСтр("ru=' Чел.';uk=' Чол.'");  
		
		НовоеУчастие = Документы.УчастиеВМероприятиях.СоздатьДокумент();
		НовоеУчастие.Мероприятие = Мероприятие.Ссылка;
		НовоеУчастие.Ответственный = Ответственный;
		НовоеУчастие.Дата = ТекущаяДата();
		
		// Скопировать занятия в состав мероприятия
		// Для каждой части мероприятия
		НаборЧастейМероприятия = справочники.СоставМероприятия.Выбрать(,Мероприятие.Ссылка,,);
		
		Пока НаборЧастейМероприятия.Следующий() Цикл 
			
			ЧастьМероприятия = НаборЧастейМероприятия.Ссылка;
			
			Для каждого строкаТЧ из ОбучающиесяРаботники Цикл
				УчастиеРаботника = НовоеУчастие.Работники.Добавить();
				УчастиеРаботника.Сотрудник			= строкаТЧ.Сотрудник;
				УчастиеРаботника.Физлицо			= строкаТЧ.Физлицо;
				УчастиеРаботника.ЧастьМероприятия	= ЧастьМероприятия;
				УчастиеРаботника.ХарактерУчастия	= Перечисления.ХарактерУчастияВМероприятиях.Участник;
			КонецЦикла;
		КонецЦикла;
		
		НовоеУчастие.Записать();
		
		ДокументУчастияВМероприятии = НовоеУчастие.Ссылка;
		ДокументУчастияВМероприятии.ПолучитьФорму("ФормаДокумента").Открыть();
		
	Иначе;
		
		// Если мероприятие уже созданно - открыть его.
		ДокументУчастияВМероприятии.ПолучитьФорму("ФормаДокумента").Открыть();
		
	КонецЕсли;
	
	Если ДокументУчастияВМероприятии.Пустая() Тогда
		ЭлементыФормы.ДействияФормы.Кнопки.Организация.Кнопки.Занятость.Текст = НСтр("ru='Запланировать занятость';uk='Запланувати занятість'");
	Иначе
		ЭлементыФормы.ДействияФормы.Кнопки.Организация.Кнопки.Занятость.Текст  = НСтр("ru='Открыть занятость';uk='Відкрити занятість'");
	КонецЕсли;
	
КонецПроцедуры

Процедура КоманднаяПанельОбучающиесяРаботникиЗаполнитьДату(Кнопка)
	
	Для Каждого СтрокаТаблицы из ОбучающиесяРаботники Цикл
		Если  НЕ ЗначениеЗаполнено(СтрокаТаблицы.ДатаПолученияДокумента) Тогда
			СтрокаТаблицы.ДатаПолученияДокумента = ДатаЗавершенияКурса;	
		КонецЕсли;
	КонецЦикла;
	
КонецПроцедуры

// Процедура - обработчик кнопки "Подбор" коммандной панели "КоманднаяПанельОбучающиесяРаботники".
// Процедура обеспечивает подбор работников из справочника ФизЛиц при вводе наименования ФизЛица.
//
Процедура КоманднаяПанельОбучающиесяРаботникиПодбор(Кнопка)
	
	ПроцедурыУправленияПерсоналом.ОткрытьФормуВыбораСотрудника(ЭлементыФормы.ОбучающиесяРаботники, Ссылка, Ложь, Дата);
	
КонецПроцедуры

// Процедура - вызывается при нажатии на кнопку "Заполнить"
//
Процедура КоманднаяПанельОбучающиесяРаботникиСписокРаботников(Кнопка)
		Если ОбучающиесяРаботники.Количество() > 0 Тогда
		ТекстВопроса = НСтр("ru='Перед заполнением табличные части будут очищены. Заполнить?';uk='Перед заповненням табличні частини будуть очищені. Заповнити?'");
		Ответ = Вопрос(ТекстВопроса, РежимДиалогаВопрос.ДаНет, , КодВозвратаДиалога.Да,);
		
		Если Ответ <> КодВозвратаДиалога.Да Тогда
			Возврат;
		КонецЕсли; 
		ОбучающиесяРаботники.Очистить();
	КонецЕсли;
	
	ПроцедурыУправленияПерсоналом.ОткрытьФормуОтбораСпискаРаботников(ЭтаФорма, Дата, "Работники");
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
// ОБРАБОТЧИКИ СОБЫТИЙ РЕКВИЗИТОВ ШАПКИ

// Процедура - обработчик события "ПриИзменении" поля ввода даты документа.
//
Процедура ДатаПриИзменении(Элемент)

	РаботаСДиалогами.ПроверитьНомерДокумента(ЭтотОбъект, мТекущаяДатаДокумента);
	МеханизмНумерацииОбъектов.ОбновитьПодсказкуКодНомерОбъекта(ЭтотОбъект.Метаданные(), ЭлементыФормы.ДействияФормы.Кнопки.Подменю, ЭлементыФормы.Номер);

	мТекущаяДатаДокумента = Дата;

КонецПроцедуры // ДатаПриИзменении

// Процедура - обработчик события "ПриИзменении" Флажка "ФактЗавершенияКурса"
// Управляект видимостью полей в ТЧ. 
//
Процедура ФактЗавершенияКурсаПриИзменении(Элемент)
	
	// Установка даты завершения обучения
	Если ФактЗавершенияКурса
		И НЕ ЗначениеЗаполнено(ДатаЗавершенияКурса) Тогда
		ДатаЗавершенияКурса = ТекущаяДата();	
	КонецЕсли;
	
	ЭлементыФормы.ДатаЗавершенияКурса.АвтоОтметкаНезаполненного = ФактЗавершенияКурса;
	УправлениеВидимостьюТЧ();

КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ РЕКВИЗИТОВ ТАБЛИЧНОЙ ЧАСТИ

// Процедура - обработчик события "ПриПолученииДанных"
Процедура ОбучающиесяРаботникиПриПолученииДанных(Элемент, ОформленияСтрок)
	РаботаСДиалогами.УстановитьЗначенияКолонкиТабельныйНомерСтрока(ЭлементыФормы.ОбучающиесяРаботники, ОформленияСтрок);
КонецПроцедуры

// Процедура - обработчик события "ОбработкаВыбора" таблицы "ОбучающиесяРаботники".
// Процедура обеспечивает подбор работников из справочника ФизЛиц при вводе наименования ФизЛица.
//
Процедура ОбучающиесяРаботникиОбработкаВыбора(Элемент, ВыбранноеЗначение, СтандартнаяОбработка)
	
	Если ТипЗнч(ВыбранноеЗначение) <> Тип("СправочникСсылка.СотрудникиОрганизаций") Тогда
		Возврат;
	КонецЕсли;
	
	СтандартнаяОбработка = Ложь;
	
	Если ОбучающиесяРаботники.НайтиСтроки(Новый Структура("Физлицо", ВыбранноеЗначение.Физлицо)).Количество() = 0 Тогда
		НоваяСтрока = ОбучающиесяРаботники.Добавить();
		НоваяСтрока.Сотрудник	= ВыбранноеЗначение;
		НоваяСтрока.Физлицо		= ВыбранноеЗначение.Физлицо;
	КонецЕсли;
	
КонецПроцедуры

Процедура ОбучающиесяРаботникиСотрудникПриИзменении(Элемент)
	
	ДанныеСтроки = ЭлементыФормы.ОбучающиесяРаботники.ТекущиеДанные;
	
	ДанныеСтроки.ФизЛицо = Элемент.Значение.ФизЛицо;
	
КонецПроцедуры

// Процедура - обработчик события "НачалоВыбора" поля ввода "Работник"
// Процедура обеспечивает подбор работников из справочника ФизЛиц.
Процедура ОбучающиесяРаботникиРаботникНачалоВыбора(Элемент, СтандартнаяОбработка)
	
	ПроцедурыУправленияПерсоналом.ОткрытьФормуВыбораСотрудника(Элемент, Ссылка, Истина, Дата, СтандартнаяОбработка, Элемент.Значение);
	
КонецПроцедуры

Процедура ОбучающиесяРаботникиФизЛицоОбработкаВыбора(Элемент, ВыбранноеЗначение, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	СтрокиРаботников = ОбучающиесяРаботники.НайтиСтроки(Новый Структура("Физлицо", ВыбранноеЗначение.Физлицо));
	Если СтрокиРаботников.Количество() > 0 И Элемент.Значение <> ВыбранноеЗначение Тогда
		Предупреждение(НСтр("ru='В данном документе по одному работнику можно вводить только одну строку!';uk='В даному документі по одному працівнику можна вводити тільки один рядок!'"));
		Возврат;
	КонецЕсли;
	
	Элемент.Значение = ВыбранноеЗначение;
	
	ДанныеСтроки = ЭлементыФормы.ОбучающиесяРаботники.ТекущиеДанные;
	ДанныеСтроки.ФизЛицо = ВыбранноеЗначение.ФизЛицо;
	
КонецПроцедуры

// Процедура - обработчик события "НачалоВыбора" поля ввода "Работник"
// Процедура обеспечивает подбор работников из справочника ФизЛиц при вводе наименования ФизЛица.
Процедура ОбучающиесяРаботникиРаботникАвтоПодборТекста(Элемент, Текст, ТекстАвтоПодбора, СтандартнаяОбработка)
	
	ТекстАвтоПодбора = ПроцедурыУправленияПерсоналом.ПодобратьФИОРаботникаКандидата(СтандартнаяОбработка, "Работники", Текст);
	
КонецПроцедуры

// Процедура - обработчик события "НачалоВыбора" поля ввода "Работник"
// Процедура обеспечивает подбор работников из справочника ФизЛиц при вводе наименования ФизЛица.
Процедура ОбучающиесяРаботникиРаботникОкончаниеВводаТекста(Элемент, Текст, Значение, СтандартнаяОбработка)
	
	Значение = ПроцедурыУправленияПерсоналом.ПодобратьСписокРаботниковКандидатов(СтандартнаяОбработка, "Работники", Текст, Элемент.Значение);
	
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
	
	МеханизмНумерацииОбъектов.ИзменениеВозможностиРедактированияНомера(ЭтотОбъект.Метаданные(), ЭтаФорма, ЭлементыФормы.ДействияФормы.Кнопки.Подменю, ЭлементыФормы.Номер);
			
КонецПроцедуры

