// Список значений обособленный подразделений организации, чтобы делать фильтр
Перем мОбособ;

Перем мЕстьОбособленныеПодразделения;
Перем мРежимРаботы Экспорт;
Перем мНазвФормыФильтра;
Перем мСохранитьЗначения;

Перем НП; // Настройка периода

////////////////////////////////////////////////////////////////////////////////
// ПРОЦЕДУРЫ И ФУНКЦИИ ОБЩЕГО НАЗНАЧЕНИЯ

// Процедура заполняет список выбора вида регламентированной отчетности,
// по которому устанавливается отбор в списке документов.
//
// Список заполняется видами сохраненных в информационной базе отчетов.
// Список обновляется динамически при начале выбора значения из списка.
//
Процедура ЗаполнитьСписокВидовОтчетов()

	// Заполняем список видов регламентированной отчетности по обнаруженным
	// в информационной базе сохраненным документам РегламентированныйОтчет.

	// Используем механизм запросов.
	Запрос = Новый Запрос();

	Запрос.Текст = 
	"ВЫБРАТЬ
	|	РегламентированныйОтчет.ИсточникОтчета КАК ИсточникВДокументе
	|ИЗ
	|	Документ.РегламентированныйОтчет КАК РегламентированныйОтчет
	|
	|УПОРЯДОЧИТЬ ПО
	|	ИсточникВДокументе";

	РезультатЗапроса = Запрос.Выполнить();
	ТаблицаЗапроса   = РезультатЗапроса.Выгрузить();
	ТаблицаЗапроса.Свернуть("ИсточникВДокументе");
	МассивЗначений   = ТаблицаЗапроса.ВыгрузитьКолонку("ИсточникВДокументе");

	// заполняем список выбора
	ЭлементыФормы.СписокВидовОтчета.СписокВыбора.ЗагрузитьЗначения(МассивЗначений);
	
	Для Каждого Эл Из ЭлементыФормы.СписокВидовОтчета.СписокВыбора Цикл
		
		НайденныйЭлемент = РегламентированнаяОтчетность.ПолучитьРеглОтчетПоУмолчанию(Эл.Значение);
		Если НайденныйЭлемент = Неопределено ИЛИ ПустаяСтрока(НайденныйЭлемент.Наименование) Тогда
			Эл.Представление = Эл.Значение;
		Иначе
			Эл.Представление = НайденныйЭлемент.Наименование;
		КонецЕсли;
		
	КонецЦикла;
	
	ЭлементыФормы.СписокВидовОтчета.СписокВыбора.СортироватьПоПредставлению();

КонецПроцедуры // ЗаполнитьСписокВидовОтчетов()

// Устанавливает отбор списка отчетов по заданному виду.
//
// Параметры
//  ВидОтчета  – строка – вид регламентированного отчета.
//
Процедура УстановитьОтборПоВидуОтчета(ВидОтчета)

	Если ПустаяСтрока(ВидОтчета) Тогда
		Отбор.ИсточникОтчета.Использование = Ложь;
	Иначе
		Отбор.ИсточникОтчета.Установить(ВидОтчета);
	КонецЕсли;

КонецПроцедуры // УстановитьОтборПоВидуОтчета()

////////////////////////////////////////////////////////////////////////////////
// ПРОЦЕДУРЫ - ОБРАБОТЧИКИ СОБЫТИЙ ФОРМЫ

////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ ФОРМЫ

// Процедура - обработчик события "ПриОткрытии" формы.
//
Процедура ПриОткрытии()

	//ЭлементыФормы.ДокументСписок.НастройкаОтбора.ДатаНачала.Доступность = Ложь;
	//ЭлементыФормы.ДокументСписок.НастройкаОтбора.ДатаОкончания.Доступность = Ложь;
	//ЭлементыФормы.ДокументСписок.НастройкаОтбора.Организация.Доступность = Ложь;
	//ЭлементыФормы.ДокументСписок.НастройкаОтбора.КодИМНС.Доступность = Ложь;
	//ЭлементыФормы.ДокументСписок.НастройкаОтбора.ИсточникОтчета.Доступность = Ложь;
	//ЭлементыФормы.ДокументСписок.НастройкаОтбора.НаименованиеОтчета.Доступность = Ложь;

	НастройкиФильтров = ВосстановитьЗначение("ДокументРегламентированнаяОтчетность" + глЗначениеПеременной("глТекущийПользователь").Наименование);
	мСохранитьЗначения = Истина;
	мНазвФормыФильтра = "";

	Если РегламентированнаяОтчетность.ИДКонфигурации() <> "БП" Тогда

		// Получим организация по умолчанию и вычислим признак глЗначениеПеременной("УчетПоВсемОрганизациям")
		ОсновнаяОрганизация = УправлениеПользователями.ПолучитьЗначениеПоУмолчанию(глЗначениеПеременной("глТекущийПользователь"), "ОсновнаяОрганизация");

		Если ОсновнаяОрганизация = ОбщегоНазначения.ПустоеЗначениеТипа("СправочникСсылка.Организации") Тогда
			УчетПоВсемОрганизациям = Истина;
		Иначе
			УчетПоВсемОрганизациям = Ложь;
		КонецЕсли;

		// Для УПП временно поставлен всегда признак глЗначениеПеременной("УчетПоВсемОрганизациям") = Истина,
		// т.к. нет специализированного признака учет по одной или нескольким организациям.
		УчетПоВсемОрганизациям = Истина;

	КонецЕсли;

	// глЗначениеПеременной("УчетПоВсемОрганизациям") - Истина - отбор не устанавливать, Ложь установить отбор
	
	Если НЕ глЗначениеПеременной("УчетПоВсемОрганизациям") Тогда

		// Если ((НастройкиФильтров = Неопределено) Или (НастройкиФильтров.ОтборПоОрг)) И (ОсновнаяОрганизация <> ОбщегоНазначения.ПустоеЗначениеТипа("СправочникСсылка.Организации")) Тогда

		РаботаСДиалогами.УстановитьОтборПоОрганизации(ЭтаФорма, глЗначениеПеременной("УчетПоВсемОрганизациям"), глЗначениеПеременной("ОсновнаяОрганизация"), "ДокументСписок");

		// КонецЕсли;

		Организация = УправлениеПользователями.ПолучитьЗначениеПоУмолчанию(глЗначениеПеременной("глТекущийПользователь"), "ОсновнаяОрганизация");
		ЭлементыФормы.Организация.Доступность = Ложь;
		ЭлементыФормы.ОтборПоОрг.Значение = Истина;

		// Дизейблим флажок
		ЭлементыФормы.ОтборПоОрг.Доступность = Ложь;

	Иначе

		// Если включен учет по всем организациям
		Организация = ?(НастройкиФильтров = Неопределено, УправлениеПользователями.ПолучитьЗначениеПоУмолчанию(глЗначениеПеременной("глТекущийПользователь"), "ОсновнаяОрганизация"), НастройкиФильтров.Организация);
		//ЭлементыФормы.Организация.Доступность = Ложь;

		// ЭлементыФормы.ОтборПоОрг.Доступность = Истина;

		Если ((НастройкиФильтров = Неопределено) Или (НастройкиФильтров.ОтборПоОрг)) И (Организация <> ОбщегоНазначения.ПустоеЗначениеТипа("СправочникСсылка.Организации")) Тогда

			// Отбор.Организация.Установить(Организация);
			СоставФильтраОбособленныеПодразделения();
			ЭлементыФормы.ОтборПоОрг.Значение = Истина;

		КонецЕсли;

	КонецЕсли;

	ЭлементыФормы.ДокументСписок.НастройкаПорядка.Дата.Доступность = Истина;

	Если НастройкиФильтров = Неопределено Тогда

		// в случае первого раза, устанавиливаем фильтр по датам
		ДатаКонцаПериодаОтчета  = КонецМесяца(ДобавитьМесяц(КонецКвартала(РабочаяДата), -1));
		ДатаНачалаПериодаОтчета = НачалоМесяца(ДатаКонцаПериодаОтчета);
		ЭлементыФормы.Период.Значение = Истина;

		ПоказатьПериод();
		ПолеВыбораПериодичность = Перечисления.Периодичность.Месяц;
		УстановитьОтборПоПериоду();

		ЭлементыФормы.ПанельПериод.Страницы.СтандартныйПериод.Видимость = Истина;
		ЭлементыФормы.ПанельПериод.Страницы.ПроизвольныйПериод.Видимость = Ложь;


	ИначеЕсли НастройкиФильтров <> Неопределено Тогда

		//ЭлементыФормы.СписокВидовОтчета.Доступность = Ложь;
		//ЭлементыФормы.СписокВидовНО.Доступность = Ложь;

		// *** восстанавливаем ****************
		мНазвФормыФильтра = "";

		ДатаНачалаПериодаОтчета = НастройкиФильтров.ДатаНач;
		ДатаКонцаПериодаОтчета = НастройкиФильтров.ДатаКон;

		ПолеВыбораПериодичность = НастройкиФильтров.Периодичность;

		Если (ПолеВыбораПериодичность = Перечисления.Периодичность.Месяц)
		Или (ПолеВыбораПериодичность = Перечисления.Периодичность.Квартал) Тогда  // ежеквартально

			ЭлементыФормы.ПанельПериод.Страницы.СтандартныйПериод.Видимость = Истина;
			ЭлементыФормы.ПанельПериод.Страницы.ПроизвольныйПериод.Видимость = Ложь;
			ПоказатьПериод();

		Иначе

			ЭлементыФормы.ПанельПериод.Страницы.ПроизвольныйПериод.Видимость = Истина;
			ЭлементыФормы.ПанельПериод.Страницы.СтандартныйПериод.Видимость = Ложь;

		КонецЕсли;

		Если НастройкиФильтров.Период Тогда

			ДейстияПриУстановленномФЛПериод();

			ЭлементыФормы.Период.Значение = Истина;

		Иначе

			ДейстияПриСнятомФЛПериод();
			ЭлементыФормы.Период.Значение = Ложь;

		КонецЕсли;

		Если глЗначениеПеременной("УчетПоВсемОрганизациям") Тогда

			Если НастройкиФильтров.ОтборПоОрг Тогда

				ЭлементыФормы.ОтборПоОрг.Значение = Истина;

			Иначе

				ЭлементыФормы.ОтборПоОрг.Значение = Ложь;

			КонецЕсли;

		КонецЕсли;

		
		// Если вызвано из справочника, то фильтр установи та форма которая вызвала
		// в этом случае не восстанавливаем свой фильтр
		// Восстановим его только когда форма списка документов будет открыта напрямую

		Если мРежимРаботы <> "ВызваноИзСправочника" Тогда

			ИсточникОтчетаДляОтбора = НастройкиФильтров.ОтчетнаяФормаЗначение;
			НаименованиеОтчетаДляОтбора = НастройкиФильтров.ОтчетнаяФормаПредставление;
			ДанныеОтчета = Новый СписокЗначений;
			ДанныеОтчета.Добавить(ИсточникОтчетаДляОтбора, НаименованиеОтчетаДляОтбора);
			
			//ЭлементыФормы.СписокВидовОтчета.СписокВыбора.Добавить(ИсточникОтчетаДляОтбора, НаименованиеОтчетаДляОтбора);
			ЭлементыФормы.СписокВидовОтчета.СписокВыбора = ДанныеОтчета;
			ЭлементыФормы.СписокВидовОтчета.ВыделенныйТекст = НаименованиеОтчетаДляОтбора;
			

			Если НастройкиФильтров.ОтборПоФорме Тогда

				ЭлементыФормы.СписокВидовОтчета.Доступность = Истина;
				Отбор.ИсточникОтчета.Установить(ИсточникОтчетаДляОтбора);
				ЭлементыФормы.ОтборПоФорме.Значение = Истина;

			Иначе

				Отбор.ИсточникОтчета.Использование = Ложь;
				ЭлементыФормы.СписокВидовОтчета.Доступность = Ложь;
				ЭлементыФормы.ОтборПоФорме.Значение = Ложь;

			КонецЕсли;

		Иначе

			мНазвФормыФильтра = Элементыформы.СписокВидовОтчета.СписокВыбора[0].Представление;

		КонецЕсли;


	КонецЕсли;

	//Если НЕ ЭлементыФормы.ОтборПоОрг.Значение Тогда

	//	ЭлементыФормы.Организация.Доступность = Ложь;

	//ИначеЕсли ЭлементыФормы.ОтборПоОрг.Значение Тогда

	//	ЭлементыФормы.Организация.Доступность = Истина;

	//КонецЕсли;

КонецПроцедуры

// УстановитьОтборПоПериоду
//
Процедура УстановитьОтборПоПериоду()

	Если ПолеВыбораПериодичность = Перечисления.Периодичность.Месяц Тогда
	// При такой установке отбора в журнал попадают отчеты, у которых периодичность – ежемесячно,
	// а дата конца периода составления отчета совпадает с датой конца указанного периода отбора.
		Отбор.Периодичность.Установить(Перечисления.Периодичность.Месяц);
		Отбор.ДатаОкончания.Установить(ДатаКонцаПериодаОтчета);
	ИначеЕсли ПолеВыбораПериодичность = Перечисления.Периодичность.Квартал Тогда
		Отбор.Периодичность.Использование = Ложь;
		Отбор.ДатаОкончания.Установить(ДатаКонцаПериодаОтчета);
	Иначе
		Отбор.Периодичность.Использование = Ложь;
		Отбор.ДатаОкончания.ЗначениеС = НачалоДня(ДатаНачалаПериодаОтчета);
		Отбор.ДатаОкончания.ЗначениеПо = КонецДня(ДатаКонцаПериодаОтчета);
		Отбор.ДатаОкончания.ВидСравнения = ВидСравнения.ИнтервалВключаяГраницы;
		Отбор.ДатаОкончания.Использование = Истина;
	КонецЕсли;

КонецПроцедуры // УстановитьОтборПоПериоду

///////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ ЭЛЕМЕНТОВ ДИАЛОГА

// Процедура - обработчик события "ПриИзменении" поля выбора
// вида отчета, по которому устанавливается отбор.
//
// Управляет отбором документов по виду отчетности.
//
Процедура СписокВидовОтчетаПриИзменении(Элемент)

	мНазвФормыФильтра = ЭлементыФормы.СписокВидовОтчета.ВыделенныйТекст;
	ЭлементыФормы.ОтборПоФорме.Значение = Истина;
	УстановитьОтборПоВидуОтчета(Элемент.Значение);

КонецПроцедуры // СписокВидовОтчетаПриИзменении()

// Процедура - обработчик события "НачалоВыбораИзСписка" поля выбора
// вида отчета, по которому устанавливается отбор.
//
// Вызывает заполнение списка выбора поля выбора вида регламентированной
// отчетности.
//
Процедура СписокВидовОтчетаНачалоВыбораИзСписка(Элемент, СтандартнаяОбработка)

	ЗаполнитьСписокВидовОтчетов();

КонецПроцедуры // СписокВидовОтчетаНачалоВыбораИзСписка()

// Процедура - обработчик события "ПриВыводеСтроки" табличного поля.
Процедура ДокументСписокПриВыводеСтроки(Элемент, ОформлениеСтроки, ДанныеСтроки)

	ОформлениеСтроки.Ячейки.Период.УстановитьТекст(ПредставлениеПериода(НачалоДня(ДанныеСтроки.ДатаНачала), КонецДня(ДанныеСтроки.ДатаОкончания), "ФП = Истина" ));
	ОформлениеСтроки.Ячейки.Период.ОтображатьТекст = Истина;

КонецПроцедуры

// Процедура  - обработчик события "ПередЗакрытием" формы.
// Процедура осуществит запись настроек
//
Процедура ПередЗакрытием(Отказ, СтандартнаяОбработка)

	Если мСохранитьЗначения Тогда

		НастройкиФильтров = Новый Структура;

		НастройкиФильтров.Вставить("Период", ЭлементыФормы.Период.Значение);

		НастройкиФильтров.Вставить("ДатаНач", ДатаНачалаПериодаОтчета);
		НастройкиФильтров.Вставить("ДатаКон", ДатаКонцаПериодаОтчета);

		НастройкиФильтров.Вставить("Организация", Организация);
		НастройкиФильтров.Вставить("ОтборПоОрг", ЭлементыФормы.ОтборПоОрг.Значение);

		Если (мНазвФормыФильтра = Неопределено) Или РегламентированнаяОтчетность.ПустоеЗначение(мНазвФормыФильтра)
		 И (Элементыформы.СписокВидовОтчета.СписокВыбора.Количество() > 0) Тогда
		 	мНазвФормыФильтра = Элементыформы.СписокВидовОтчета.СписокВыбора[0].Представление;

		КонецЕсли;

		НастройкиФильтров.Вставить("ОтчетнаяФормаПредставление", мНазвФормыФильтра);

		НастройкиФильтров.Вставить("ОтчетнаяФормаЗначение", Элементыформы.СписокВидовОтчета.Значение);

		НастройкиФильтров.Вставить("ОтборПоФорме", ЭлементыФормы.ОтборПоФорме.Значение);

		НастройкиФильтров.Вставить("Периодичность", ПолеВыбораПериодичность);

		СохранитьЗначение("ДокументРегламентированнаяОтчетность" + глЗначениеПеременной("глТекущийПользователь").Наименование, НастройкиФильтров);

	КонецЕсли;

КонецПроцедуры

// Процедура СоставФильтраОбособленныеПодразделения()
// Процедура устанавливает отбор (фильтр) по организации
//
Процедура СоставФильтраОбособленныеПодразделения()

	Если Организация <> ОбщегоНазначения.ПустоеЗначениеТипа("СправочникСсылка.Организации") Тогда

		// Скроем колонку, т.к. организация определена
		ЭлементыФормы.ДокументСписок.Колонки.Организация.Видимость         = Ложь;
		ЭлементыФормы.ДокументСписок.Колонки.Организация.ИзменятьВидимость = Ложь;

		мОбособ.Очистить();

		мОбособ = ОбщегоНазначения.ПолучитьСписокОбособленныхПодразделенийОрганизации(Организация);

		// На будущее в мОбособ хранится списокзначений обособленных подразделений
		Если мОбособ.Количество() = 0 Тогда

			// Сделаем отбор по текущей организации
			Отбор.Организация.Установить(Организация);

			мЕстьОбособленныеПодразделения = Ложь;

		Иначе

			//Отбор.Организация.Использование = Ложь;
			мЕстьОбособленныеПодразделения = Истина;

			Отбор.Организация.Установить(Организация);
			ЭлементыФормы.ДокументСписок.Колонки.Организация.Видимость         = Ложь;
			ЭлементыФормы.ДокументСписок.Колонки.Организация.ИзменятьВидимость = Ложь;

		КонецЕсли;

	Иначе

		Отбор.Организация.Установить(Организация);

	КонецЕсли;

КонецПроцедуры

// Процедура ОтборПоОрг
// Процедура устанавливает отбор, с возведением флажка.
//
Процедура ОтборПоОрг()

	СоставФильтраОбособленныеПодразделения();
	ЭлементыФормы.ОтборПоОрг.Значение = Истина;

КонецПроцедуры // ОтборПоОрг

// Процедура - обработчик "ПриИзменении".
//
Процедура ОрганизацияПриИзменении(Элемент)

	ОтборПоОрг();

КонецПроцедуры // ОрганизацияПриИзменении

// Процедура ДейстияПриСнятомФЛПериод.
// Процедура устанавливает "окружение" для режима без периода
//
Процедура ДейстияПриСнятомФЛПериод()

	// При снятом флажке фильтра нет и дизейблим элементы

	ЭлементыФормы.ПолеВыбораПериодичность.Доступность = Ложь;
	ЭлементыФормы.ПанельПериод.Доступность = Ложь;
	ЭлементыФормы.ПолеВыбораПериодичность.Доступность = Ложь;

	Отбор.ДатаНачала.Использование = Ложь;
	Отбор.ДатаОкончания.Использование = Ложь;
	Отбор.Периодичность.Использование = Ложь;

КонецПроцедуры // ДейстияПриСнятомФЛПериод

// Процедура ДейстияПриУстановленномФЛПериод
// Устанавливает режим, при установленном флажке Период
//
Процедура ДейстияПриУстановленномФЛПериод()

	ЭлементыФормы.ПолеВыбораПериодичность.Доступность = Истина;
	ЭлементыФормы.ПанельПериод.Доступность = Истина;

	УстановитьОтборПоПериоду();

КонецПроцедуры // ДейстияПриУстановленномФЛПериод

// Процедура - обработчик события "ПриИзменении"
//
Процедура ПериодПриИзменении(Элемент)

	Если НЕ Элемент.Значение Тогда

		ДейстияПриСнятомФЛПериод();

		//Отбор.ДатаОкончания.Использование = Ложь;

	Иначе

		ДейстияПриУстановленномФЛПериод();

	КонецЕсли;

КонецПроцедуры // ПериодПриИзменении

// Процедура - обработчик события "Нажатие" кнопки "Настройка" верхней командной панели.
//
Процедура КнопкаНастройкаПериодаНажатие(Элемент)

	НП.ВариантНастройки = ВариантНастройкиПериода.Период;
	НП.РедактироватьКакПериод = Истина;
	НП.РедактироватьКакИнтервал = Ложь;

	Если НП.Редактировать() Тогда

		ДатаНачалаПериодаОтчета = НП.ПолучитьДатуНачала();
		ДатаКонцаПериодаОтчета = НП.ПолучитьДатуОкончания();
		УстановитьОтборПоПериоду();

	КонецЕсли;

КонецПроцедуры // КнопкаНастройкаПериодаНажатие()

// Процедура - обработчик "ПередОткрытием"
// Обрабатывает переменную мРежимРаботы
//
Процедура ПередОткрытием(Отказ, СтандартнаяОбработка)

	Если мРежимРаботы = Неопределено Тогда
		мРежимРаботы = "";
	КонецЕсли;

КонецПроцедуры // ПередОткрытием

// Процедура ДействияФормыДействие11.
// По кнопке осуществляется переход в справочник регл. отчетов
//
Процедура ДействияФормыДействие11(Кнопка)

	РегОтчеты = Справочники.РегламентированныеОтчеты.ПолучитьФорму("ФормаСписка");
	РегОтчеты.РежимВыбора = Ложь;
	РегОтчеты.Открыть();

КонецПроцедуры // ДействияФормыДействие11

// Процедура вызывается по нажатию кнопки "<" формы.
//   Инициализирует изменение переиода построения отчета.
//
Процедура КнопкаПредыдущийПериодНажатие(Элемент)

	ИзменитьПериод(-1);

КонецПроцедуры // КнопкаПредыдущийПериодНажатие()

// Процедура вызывается по нажатию кнопки ">" формы.
//   Инициализирует изменение переиода построения отчета.
//
Процедура КнопкаСледующийПериодНажатие(Элемент)

	ИзменитьПериод(1);

КонецПроцедуры // КнопкаСледующийПериодНажатие()

// Процедура устанавливает границы периода построения отчета.
//
// Параметры:
//  Шаг          - число, количество стандартных периодов, на которое необходимо
//                 сдвигать период построения отчета.
//
Процедура ИзменитьПериод(Шаг)

	Если ПолеВыбораПериодичность = Перечисления.Периодичность.Квартал Тогда  // ежеквартально

//		ДатаКонцаПериодаОтчета  = КонецКвартала(ДобавитьМесяц(ДатаКонцаПериодаОтчета, Шаг*3));
//		ДатаНачалаПериодаОтчета = НачалоГода(ДатаКонцаПериодаОтчета);

		ДатаКонцаПериодаОтчета  = КонецМесяца(ДобавитьМесяц(ДатаКонцаПериодаОтчета, 3*Шаг)); 
		ДатаНачалаПериодаОтчета = НачалоКвартала(ДатаКонцаПериодаОтчета);

	Иначе
		ДатаКонцаПериодаОтчета  = КонецМесяца(ДобавитьМесяц(ДатаКонцаПериодаОтчета, Шаг)); 
		ДатаНачалаПериодаОтчета = НачалоМесяца(ДатаКонцаПериодаОтчета);
	КонецЕсли;

	ПоказатьПериод();

	УстановитьОтборПоПериоду();

КонецПроцедуры // ИзменитьПериод()

// ОперацииПриСменеПериодичности
//
Процедура ОперацииПриСменеПериодичности()

	Если ПолеВыбораПериодичность = Перечисления.Периодичность.Квартал Тогда  // ежеквартально
		// ДатаКонцаПериодаОтчета  = КонецКвартала(ДатаКонцаПериодаОтчета);
		// ДатаНачалаПериодаОтчета = НачалоКвартала(ДатаКонцаПериодаОтчета);
		ДатаКонцаПериодаОтчета  = КонецМесяца(ДобавитьМесяц(КонецКвартала(РабочаяДата), -3));
		ДатаНачалаПериодаОтчета = НачалоКвартала(ДатаКонцаПериодаОтчета);

		ЭлементыФормы.ПанельПериод.Страницы.СтандартныйПериод.Видимость = Истина;
		ЭлементыФормы.ПанельПериод.Страницы.ПроизвольныйПериод.Видимость = Ложь;

	ИначеЕсли ПолеВыбораПериодичность = Перечисления.Периодичность.Месяц Тогда  // ежеквартально

		ДатаКонцаПериодаОтчета  = КонецМесяца(ДатаКонцаПериодаОтчета);
		ДатаНачалаПериодаОтчета = НачалоМесяца(ДатаКонцаПериодаОтчета);

		ЭлементыФормы.ПанельПериод.Страницы.СтандартныйПериод.Видимость = Истина;
		ЭлементыФормы.ПанельПериод.Страницы.ПроизвольныйПериод.Видимость = Ложь;


	Иначе

		ЭлементыФормы.ПанельПериод.Страницы.ПроизвольныйПериод.Видимость = Истина;
		ЭлементыФормы.ПанельПериод.Страницы.СтандартныйПериод.Видимость = Ложь;

	КонецЕсли;

	ИзменитьПериод(0);
	ПоказатьПериод();

КонецПроцедуры // ОперацииПриСменеПериодичности

// Процедура вызывается при изменении периодичности проедставления декларации.
//
Процедура ПолеВыбораПериодичностьПриИзменении(Элемент)

	ОперацииПриСменеПериодичности();

КонецПроцедуры

// Процедура управляет показом в форме периода построения отчета.
//
Процедура ПоказатьПериод()

	СтрПериодОтчета = ПредставлениеПериода( НачалоДня(ДатаНачалаПериодаОтчета), КонецДня(ДатаКонцаПериодаОтчета), "ФП = Истина" );

	// Покажем период в диалоге
	ЭлементыФормы.НадписьПериодСоставленияОтчета.Заголовок = СтрПериодОтчета;

КонецПроцедуры // ПоказатьПериод()

// Процедура - обработчик "ПриИзменении"
// Осуществляется отбор по форе отчетности
//
Процедура ОтборПоФормеПриИзменении(Элемент)

	Если НЕ Элемент.Значение Тогда
		Отбор.ИсточникОтчета.Использование = Ложь;
		ЭлементыФормы.СписокВидовОтчета.Доступность = Ложь;
	Иначе
		ЭлементыФормы.СписокВидовОтчета.Доступность = Истина;
		Отбор.ИсточникОтчета.Использование = Истина;
	КонецЕсли;

КонецПроцедуры // ОтборПоФормеПриИзменении

// Процедура - обработчик "ПриИзменении"
//
Процедура ДатаНачПриИзменении(Элемент)
	УстановитьОтборПоПериоду();
КонецПроцедуры // ДатаНачПриИзменении

// Процедура - обработчик "ПриИзменении"
// При изменении даты
//
Процедура ПолеВвода2ПриИзменении(Элемент)

	УстановитьОтборПоПериоду();

КонецПроцедуры

// ДействияПриВыклФлОрг
//
Процедура ДействияПриВыклФлОрг()

	Отбор.Организация.Использование = Ложь;
	ЭлементыФормы.Организация.Доступность = Ложь;
	// покажем колонку орг
	ЭлементыФормы.ДокументСписок.Колонки.Организация.Видимость         = Истина;
	ЭлементыФормы.ДокументСписок.Колонки.Организация.ИзменятьВидимость = Истина;

КонецПроцедуры // ДействияПриВыклФлОрг

// ДействияПриВклФлОрг
//
Процедура ДействияПриВклФлОрг()

	ЭлементыФормы.Организация.Доступность = Истина;
	СоставФильтраОбособленныеПодразделения();

КонецПроцедуры // ДействияПриВклФлОрг

// Процедура ОтборПоОргПриИзменении.
// Осуществляет отбор по организации.
//
Процедура ОтборПоОргПриИзменении(Элемент)

	Если НЕ Элемент.Значение Тогда

		ДействияПриВыклФлОрг();

	Иначе

		ДействияПриВклФлОрг();

	КонецЕсли;

КонецПроцедуры // ОтборПоОргПриИзменении

// Процедура - обработчик "ДействияФормы"
// Процедура возвращает значения по умолчанию, путем записи значения Неопределено
//
Процедура ДействияФормыВернуть(Кнопка)

	СохранитьЗначение("ДокументРегламентированнаяОтчетность" + глЗначениеПеременной("глТекущийПользователь").Наименование, Неопределено);
	мСохранитьЗначения = Ложь;
	ЭтаФорма.Закрыть();

КонецПроцедуры

ДокументСписок.Колонки.Добавить("ДатаНачала");
ДокументСписок.Колонки.Добавить("ДатаОкончания");
ДокументСписок.Колонки.Добавить("ИсточникОтчета");

мОбособ = Новый СписокЗначений;

НП = Новый НастройкаПериода;

ЭлементыФормы.ПолеВыбораПериодичность.СписокВыбора.Добавить(Перечисления.Периодичность.Месяц,   НСтр("ru='Ежемесячно';uk='Щомісяця'"));
ЭлементыФормы.ПолеВыбораПериодичность.СписокВыбора.Добавить(Перечисления.Периодичность.Квартал, НСтр("ru='Ежеквартально';uk='Щокварталу'"));
ЭлементыФормы.ПолеВыбораПериодичность.СписокВыбора.Добавить("Произвольный", НСтр("ru='Произвольный';uk='Довільний'"));
