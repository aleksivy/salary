////////////////////////////////////////////////////////////////////////////////
// ЭКСПОРТНЫЕ ПРОЦЕДУРЫ И ФУНКЦИИ

Процедура Автозаполнение() Экспорт

	ПланируемыеЗатраты.Очистить();
	
	Если Сценарий.Пустая() Тогда
		Возврат;
	КонецЕсли;
	
	Отказ = Ложь;
	
	Если НЕ ЗначениеЗаполнено(КурсДокумента) Тогда
		ОбщегоНазначения.СообщитьОбОшибке(НСтр("ru='В документе нет данных о курсе валюты. Проверьте, что на период планирования у валюты установлен курс и перевыберите валюту!';uk='У документі немає даних про курс валюти. Перевірте, що на період планування у валюти встановлений курс і перевиберіть валюту!'"), Отказ);
	КонецЕсли;
	Если НЕ ЗначениеЗаполнено(КратностьДокумента) Тогда
		ОбщегоНазначения.СообщитьОбОшибке(НСтр("ru='В документе нет данных о кратности валюты. Проверьте, что на период планирования у валюты установлена кратность и перевыберите валюту!';uk='У документі немає даних про кратність валюти. Перевірте, що на період планування у валюти встановлена кратність та перевыберіть валюту!'"), Отказ);
	КонецЕсли;
	
	Если Отказ Тогда
		Возврат;
	КонецЕсли;
	
	ПериодичностьПланирования = Сценарий.Периодичность;
	
	ПрошлыйПериодПланирования = ОбщегоНазначения.ДатаНачалаПериода(ОбщегоНазначения.ДобавитьИнтервал(ДатаПланирования, ПериодичностьПланирования, -1), ПериодичностьПланирования);
	
	ИмяПериода = ОбщегоНазначения.ПолучитьИмяЭлементаПеречисленияПоЗначению(ПериодичностьПланирования);
	
	Если РежимПланированияЗатрат = Перечисления.ВидыОрганизационнойСтруктурыПредприятия.ПоСтруктуреЮридическихЛиц Тогда
		ВалютаУчета	= Константы.ВалютаРегламентированногоУчета.Получить();
	Иначе
		ВалютаУчета	= Константы.ВалютаУправленческогоУчета.Получить();
	КонецЕсли;
	
	ТекущийКурс				= МодульВалютногоУчета.ПолучитьКурсВалюты(ВалютаУчета, ПрошлыйПериодПланирования);
	КурсВалютыУчета			= ТекущийКурс.Курс;
	КратностьВалютыУчета	= ТекущийКурс.Кратность;
	
	Если РежимПланированияЗатрат = Перечисления.ВидыОрганизационнойСтруктурыПредприятия.ПоСтруктуреЮридическихЛиц Тогда
		Если НЕ ЗначениеЗаполнено(КурсВалютыУчета) Тогда
			ОбщегоНазначения.СообщитьОбОшибке(НСтр("ru='Для валюты регл. учета не установлен курс на начало предыдущего периода планирования (';uk='Для валюти регл. обліку не встановлено курс на початок попереднього періоду планування ('")+Формат(ПрошлыйПериодПланирования, "ДФ='dd MMMM yyyy ""г.""'")+НСтр("ru='). Установите курс и повторите автозаполнение документа!';uk='). Встановіть курс і повторіть автозаповнення документа!'"), Отказ);
		КонецЕсли;
		Если НЕ ЗначениеЗаполнено(КратностьВалютыУчета) Тогда
			ОбщегоНазначения.СообщитьОбОшибке(НСтр("ru='Для валюты регл. учета не установлен кратность на начало предыдущего периода планирования (';uk='Для валюти регл. обліку не встановлено кратність на початок попереднього періоду планування ('")+Формат(ПрошлыйПериодПланирования, "ДФ='dd MMMM yyyy ""г.""'")+НСтр("ru='). Установите курс и повторите автозаполнение документа!';uk='). Встановіть курс і повторіть автозаповнення документа!'"), Отказ);
		КонецЕсли;
		
	Иначе
		Если НЕ ЗначениеЗаполнено(КурсВалютыУчета) Тогда
			ОбщегоНазначения.СообщитьОбОшибке(НСтр("ru='Для валюты упр. учета не установлен курс на начало предыдущего периода планирования (';uk='Для валюти упр. обліку не встановлено курс на початок попереднього періоду планування ('")+Формат(ПрошлыйПериодПланирования, "ДФ='dd MMMM yyyy ""г.""'")+НСтр("ru='). Установите курс и повторите автозаполнение документа!';uk='). Встановіть курс і повторіть автозаповнення документа!'"), Отказ);
		КонецЕсли;
		Если НЕ ЗначениеЗаполнено(КратностьВалютыУчета) Тогда
			ОбщегоНазначения.СообщитьОбОшибке(НСтр("ru='Для валюты упр. учета не установлен кратность на начало предыдущего периода планирования (';uk='Для валюти упр. обліку не встановлено кратність на початок попереднього періоду планування ('")+Формат(ПрошлыйПериодПланирования, "ДФ='dd MMMM yyyy ""г.""'")+НСтр("ru='). Установите курс и повторите автозаполнение документа!';uk='). Встановіть курс і повторіть автозаповнення документа!'"), Отказ);
		КонецЕсли;
		
	КонецЕсли;
	
	Если Отказ Тогда
		Возврат;
	КонецЕсли;
	
	Запрос = Новый Запрос;
	
	Запрос.УстановитьПараметр("ДатаНач",				ОбщегоНазначения.ДатаНачалаПериода(ПрошлыйПериодПланирования, ПериодичностьПланирования));
	Запрос.УстановитьПараметр("ДатаКон",				ОбщегоНазначения.ДатаКонцаПериода(ПрошлыйПериодПланирования, ПериодичностьПланирования));
	
	Запрос.УстановитьПараметр("КурсВалютыУчета",		КурсВалютыУчета);
	Запрос.УстановитьПараметр("КратностьВалютыУчета",	КратностьВалютыУчета);
	Запрос.УстановитьПараметр("КурсДокумента",			КурсДокумента);
	Запрос.УстановитьПараметр("КратностьДокумента",		КратностьДокумента);
	
	Если РежимПланированияЗатрат = Перечисления.ВидыОрганизационнойСтруктурыПредприятия.ПоСтруктуреЮридическихЛиц Тогда
		Запрос.УстановитьПараметр("Организация",		Организация);
		
		Запрос.Текст =
		"ВЫБРАТЬ РАЗРЕШЕННЫЕ
		|	НАЧАЛОПЕРИОДА(ОтражениеЗарплатыВРеглУчетеОтражениеВУчете.Ссылка.ПериодРегистрации, "+ИмяПериода+") КАК Период,
		|	ВЫБОР
		|		КОГДА ОтражениеЗарплатыВРеглУчетеОтражениеВУчете.СубконтоДт1 ССЫЛКА Справочник.ПодразделенияОрганизаций
		|			ТОГДА ОтражениеЗарплатыВРеглУчетеОтражениеВУчете.СубконтоДт1
		|		КОГДА ОтражениеЗарплатыВРеглУчетеОтражениеВУчете.СубконтоДт2 ССЫЛКА Справочник.ПодразделенияОрганизаций
		|			ТОГДА ОтражениеЗарплатыВРеглУчетеОтражениеВУчете.СубконтоДт2
		|		КОГДА ОтражениеЗарплатыВРеглУчетеОтражениеВУчете.СубконтоДт3 ССЫЛКА Справочник.ПодразделенияОрганизаций
		|			ТОГДА ОтражениеЗарплатыВРеглУчетеОтражениеВУчете.СубконтоДт3
		|	КОНЕЦ КАК Подразделение,
		|	ВЫБОР
		|		КОГДА ОтражениеЗарплатыВРеглУчетеОтражениеВУчете.СубконтоДт1 ССЫЛКА Справочник.СтатьиЗатрат
		|			ТОГДА ОтражениеЗарплатыВРеглУчетеОтражениеВУчете.СубконтоДт1
		|		КОГДА ОтражениеЗарплатыВРеглУчетеОтражениеВУчете.СубконтоДт2 ССЫЛКА Справочник.СтатьиЗатрат
		|			ТОГДА ОтражениеЗарплатыВРеглУчетеОтражениеВУчете.СубконтоДт2
		|		КОГДА ОтражениеЗарплатыВРеглУчетеОтражениеВУчете.СубконтоДт3 ССЫЛКА Справочник.СтатьиЗатрат
		|			ТОГДА ОтражениеЗарплатыВРеглУчетеОтражениеВУчете.СубконтоДт3
		|	КОНЕЦ КАК СтатьяЗатрат,
		|	СУММА(ОтражениеЗарплатыВРеглУчетеОтражениеВУчете.Сумма * (&КурсВалютыУчета / &КратностьВалютыУчета) / (&КурсДокумента / &КратностьДокумента)) КАК Сумма
		|ИЗ
		|	Документ.ОтражениеЗарплатыВРеглУчете.ОтражениеВУчете КАК ОтражениеЗарплатыВРеглУчетеОтражениеВУчете
		|ГДЕ
		|	ОтражениеЗарплатыВРеглУчетеОтражениеВУчете.Ссылка.Организация = &Организация
		|	И ОтражениеЗарплатыВРеглУчетеОтражениеВУчете.Ссылка.ПериодРегистрации МЕЖДУ &ДатаНач И &ДатаКон
		|	И ОтражениеЗарплатыВРеглУчетеОтражениеВУчете.Ссылка.Проведен
		|	И НЕ (ОтражениеЗарплатыВРеглУчетеОтражениеВУчете.СчетДт В ИЕРАРХИИ (ЗНАЧЕНИЕ(ПланСчетов.Хозрасчетный.РасчетыПоОплатеТруда), ЗНАЧЕНИЕ(ПланСчетов.Хозрасчетный.РасчетыПоНалогам), ЗНАЧЕНИЕ(ПланСчетов.Хозрасчетный.РасчетыПоСтрахованию)))
		|
		|СГРУППИРОВАТЬ ПО
		|	НАЧАЛОПЕРИОДА(ОтражениеЗарплатыВРеглУчетеОтражениеВУчете.Ссылка.ПериодРегистрации, "+ИмяПериода+"),
		|	ВЫБОР
		|		КОГДА ОтражениеЗарплатыВРеглУчетеОтражениеВУчете.СубконтоДт1 ССЫЛКА Справочник.ПодразделенияОрганизаций
		|			ТОГДА ОтражениеЗарплатыВРеглУчетеОтражениеВУчете.СубконтоДт1
		|		КОГДА ОтражениеЗарплатыВРеглУчетеОтражениеВУчете.СубконтоДт2 ССЫЛКА Справочник.ПодразделенияОрганизаций
		|			ТОГДА ОтражениеЗарплатыВРеглУчетеОтражениеВУчете.СубконтоДт2
		|		КОГДА ОтражениеЗарплатыВРеглУчетеОтражениеВУчете.СубконтоДт3 ССЫЛКА Справочник.ПодразделенияОрганизаций
		|			ТОГДА ОтражениеЗарплатыВРеглУчетеОтражениеВУчете.СубконтоДт3
		|	КОНЕЦ,
		|	ВЫБОР
		|		КОГДА ОтражениеЗарплатыВРеглУчетеОтражениеВУчете.СубконтоДт1 ССЫЛКА Справочник.СтатьиЗатрат
		|			ТОГДА ОтражениеЗарплатыВРеглУчетеОтражениеВУчете.СубконтоДт1
		|		КОГДА ОтражениеЗарплатыВРеглУчетеОтражениеВУчете.СубконтоДт2 ССЫЛКА Справочник.СтатьиЗатрат
		|			ТОГДА ОтражениеЗарплатыВРеглУчетеОтражениеВУчете.СубконтоДт2
		|		КОГДА ОтражениеЗарплатыВРеглУчетеОтражениеВУчете.СубконтоДт3 ССЫЛКА Справочник.СтатьиЗатрат
		|			ТОГДА ОтражениеЗарплатыВРеглУчетеОтражениеВУчете.СубконтоДт3
		|	КОНЕЦ";
		
	Иначе
		Запрос.Текст =
		"ВЫБРАТЬ РАЗРЕШЕННЫЕ
		|	НАЧАЛОПЕРИОДА(ОтражениеЗарплатыВУпрУчетеОтражениеВУчете.Ссылка.ПериодРегистрации, "+ИмяПериода+") КАК Период,
		|	ОтражениеЗарплатыВУпрУчетеОтражениеВУчете.Подразделение,
		|	ОтражениеЗарплатыВУпрУчетеОтражениеВУчете.СтатьяЗатрат,
		|	СУММА(ОтражениеЗарплатыВУпрУчетеОтражениеВУчете.Сумма * (&КурсВалютыУчета / &КратностьВалютыУчета) / (&КурсДокумента / &КратностьДокумента)) КАК Сумма
		|ИЗ
		|	Документ.ОтражениеЗарплатыВУпрУчете.ОтражениеВУчете КАК ОтражениеЗарплатыВУпрУчетеОтражениеВУчете
		|ГДЕ
		|	ОтражениеЗарплатыВУпрУчетеОтражениеВУчете.Ссылка.ПериодРегистрации МЕЖДУ &ДатаНач И &ДатаКон
		|	И ОтражениеЗарплатыВУпрУчетеОтражениеВУчете.Ссылка.Проведен
		|
		|СГРУППИРОВАТЬ ПО
		|	ОтражениеЗарплатыВУпрУчетеОтражениеВУчете.Подразделение,
		|	ОтражениеЗарплатыВУпрУчетеОтражениеВУчете.СтатьяЗатрат,
		|	НАЧАЛОПЕРИОДА(ОтражениеЗарплатыВУпрУчетеОтражениеВУчете.Ссылка.ПериодРегистрации, "+ИмяПериода+")";
		
	КонецЕсли;
	
	ПланируемыеЗатраты.Загрузить(Запрос.Выполнить().Выгрузить());
	
КонецПроцедуры // Автозаполнение()

////////////////////////////////////////////////////////////////////////////////
// ПРОЦЕДУРЫ И ФУНКЦИИ ДЛЯ ОБЕСПЕЧЕНИЯ ПРОВЕДЕНИЯ ДОКУМЕНТА

// Формирует запрос по шапке документа
//
// Параметры: 
//  Режим - режим проведения
//
// Возвращаемое значение:
//  Результат запроса
//
Функция СформироватьЗапросПоШапке(Режим)

	Запрос = Новый Запрос;

	// Установим параметры запроса
	Запрос.УстановитьПараметр("ДокументСсылка",		Ссылка);
	Запрос.УстановитьПараметр("ПустаяОрганизация",	Справочники.Организации.ПустаяСсылка());

	Запрос.Текст =
	"ВЫБРАТЬ
	|	ПланируемыеЗатратыНаПерсонал.Дата,
	|	ПланируемыеЗатратыНаПерсонал.Ссылка,
	|	ПланируемыеЗатратыНаПерсонал.Сценарий,
	|	ПланируемыеЗатратыНаПерсонал.ДатаПланирования КАК Период,
	|	ПланируемыеЗатратыНаПерсонал.ВалютаДокумента,
	|	ПланируемыеЗатратыНаПерсонал.КурсДокумента,
	|	ПланируемыеЗатратыНаПерсонал.КратностьДокумента
	|ИЗ
	|	Документ.ПланируемыеЗатратыНаПерсонал КАК ПланируемыеЗатратыНаПерсонал
	|ГДЕ
	|	ПланируемыеЗатратыНаПерсонал.Ссылка = &ДокументСсылка";

	Возврат Запрос.Выполнить();

КонецФункции // СформироватьЗапросПоШапке()

// Формирует запрос по таблице "ПланируемыеЗатраты" документа
//
// Параметры: 
//  Режим - режим проведения
//
// Возвращаемое значение:
//  Результат запроса.
//
Функция СформироватьЗапросПоПланируемыеЗатраты(ВыборкаПоШапкеДокумента, Режим)

	Запрос = Новый Запрос;

	// Установим параметры запроса
	Запрос.УстановитьПараметр("ДокументСсылка",	Ссылка);
	
	Запрос.Текст =
	"ВЫБРАТЬ
	|	ПланируемыеЗатратыНаПерсоналПланируемыеЗатраты.НомерСтроки КАК НомерСтроки,
	|	ПланируемыеЗатратыНаПерсоналПланируемыеЗатраты.Подразделение,
	|	ПланируемыеЗатратыНаПерсоналПланируемыеЗатраты.СтатьяЗатрат,
	|	ПланируемыеЗатратыНаПерсоналПланируемыеЗатраты.Сумма,
	|	ПланируемыеЗатратыНаПерсоналПланируемыеЗатраты.Ссылка.ВалютаДокумента КАК Валюта
	|ИЗ
	|	Документ.ПланируемыеЗатратыНаПерсонал.ПланируемыеЗатраты КАК ПланируемыеЗатратыНаПерсоналПланируемыеЗатраты
	|ГДЕ
	|	ПланируемыеЗатратыНаПерсоналПланируемыеЗатраты.Ссылка = &ДокументСсылка
	|
	|УПОРЯДОЧИТЬ ПО
	|	НомерСтроки";

	Возврат Запрос.Выполнить();

КонецФункции // СформироватьЗапросПоПланируемыеЗатраты()

// Проверяет правильность заполнения шапки документа.
// Если какой-то из реквизтов шапки, влияющий на проведение не заполнен или
// заполнен не корректно, то выставляется флаг отказа в проведении.
// Проверка выполняется по выборке из результата запроса по шапке,
// все проверяемые реквизиты должны быть включены в выборку по шапке.
//
// Параметры: 
//  ВыборкаПоШапкеДокумента	- выборка из результата запроса по шапке документа,
//  Отказ 					- флаг отказа в проведении,
//	Заголовок				- Заголовок для сообщений об ошибках проведения.
//
Процедура ПроверитьЗаполнениеШапки(ВыборкаПоШапкеДокумента, Отказ, Заголовок)

	Если НЕ ЗначениеЗаполнено(ВыборкаПоШапкеДокумента.Сценарий) Тогда
		ОбщегоНазначения.СообщитьОбОшибке(НСтр("ru='Не указан сценарий планирования!';uk='Не зазначений сценарій планування!'"), Отказ, Заголовок);
	КонецЕсли;

	Если НЕ ЗначениеЗаполнено(ВыборкаПоШапкеДокумента.Период) Тогда
		ОбщегоНазначения.СообщитьОбОшибке(НСтр("ru='Не указана дата планирования!';uk='Не вказана дата планування!'"), Отказ, Заголовок);
	КонецЕсли;

	Если НЕ ЗначениеЗаполнено(ВыборкаПоШапкеДокумента.ВалютаДокумента) Тогда
		ОбщегоНазначения.СообщитьОбОшибке(НСтр("ru='Не указана валюта документа!';uk='Не зазначена валюта документа!'"), Отказ, Заголовок);
	КонецЕсли;

	Если НЕ ЗначениеЗаполнено(ВыборкаПоШапкеДокумента.КурсДокумента) Тогда
		ОбщегоНазначения.СообщитьОбОшибке(НСтр("ru='Для указанной валюты не был получен курс на дату планирования!';uk='Для зазначеної валюти не був отриманий курс на дату планування!'"), Отказ, Заголовок);
	КонецЕсли;

	Если НЕ ЗначениеЗаполнено(ВыборкаПоШапкеДокумента.КратностьДокумента) Тогда
		ОбщегоНазначения.СообщитьОбОшибке(НСтр("ru='Для указанной валюты не была получена кратность на дату планирования!';uk='Для зазначеної валюти не була отримана кратність на дату планування!'"), Отказ, Заголовок);
	КонецЕсли;

КонецПроцедуры // ПроверитьЗаполнениеШапки()

// Проверяет правильность заполнения реквизитов в строке ТЧ "ПланируемыеЗатраты" документа.
// Если какой-то из реквизтов, влияющий на проведение не заполнен или
// заполнен не корректно, то выставляется флаг отказа в проведении.
// Проверка выполняется по выборке из результата запроса по строке ТЧ документа,
// все проверяемые реквизиты должны быть включены в выборку.
//
// Параметры: 
//  ВыборкаПоШапкеДокумента		- выборка из результата запроса по шапке документа,
//  ВыборкаПоСтрокамДокумента	- спозиционированная на определеной строке выборка 
//  							  из результата запроса по товарам документа, 
//  Отказ 						- флаг отказа в проведении,
//	Заголовок					- Заголовок для сообщений об ошибках проведения.
//
Процедура ПроверитьЗаполнениеСтрокиПланируемыеЗатраты(ВыборкаПоШапкеДокумента, ВыборкаПоСтрокамДокумента, Отказ, Заголовок)

	СтрокаНачалаСообщенияОбОшибке = НСтр("ru='В строке номер ""';uk='У рядку номер ""'")+ СокрЛП(ВыборкаПоСтрокамДокумента.НомерСтроки) +
	НСтр("ru='"" табл. части ""Планируемые затраты"": ';uk='"" табл. частини ""Плановані витрати"": '");

КонецПроцедуры // ПроверитьЗаполнениеСтрокиПланируемыеЗатраты()

// По строке выборки результата запроса по документу формируем движения по регистрам
//
// Параметры: 
//  ВыборкаПоШапкеДокумента                  - выборка из результата запроса по шапке документа
//  СтруктураПроведенияПоРегистрамНакопления - структура, содержащая имена регистров 
//                                             накопления по которым надо проводить документ
//  СтруктураПараметров                      - структура параметров проведения.
//
// Возвращаемое значение:
//  Нет.
//
Процедура ДобавитьСтрокуВДвиженияПоРегистрамНакопления(ВыборкаПоШапкеДокумента, ВыборкаПоПланируемыеЗатраты, СтруктураПараметров = "")
	
	Движение = Движения.ПланируемыеЗатратыНаПерсонал.Добавить();
	
	// Свойства
	Движение.Период			= ВыборкаПоШапкеДокумента.Период;
	
	// Измерения
	Движение.Сценарий		= ВыборкаПоШапкеДокумента.Сценарий;
	Движение.Подразделение	= ВыборкаПоПланируемыеЗатраты.Подразделение;
	Движение.СтатьяЗатрат	= ВыборкаПоПланируемыеЗатраты.СтатьяЗатрат;
	
	// Ресурсы
	Движение.Сумма			= ВыборкаПоПланируемыеЗатраты.Сумма;
	
	// Реквизиты
	Движение.Валюта			= ВыборкаПоПланируемыеЗатраты.Валюта;
	
КонецПроцедуры // ДобавитьСтрокуВДвиженияПоРегистрамНакопления()

////////////////////////////////////////////////////////////////////////////////
// ПРОЦЕДУРЫ - ОБРАБОТЧИКИ СОБЫТИЙ

Процедура ОбработкаПроведения(Отказ, Режим)
	
	//структура, содержащая имена регистров накопления по которым надо проводить документ
	Перем СтруктураПроведенияПоРегистрамНакопления;

	// Заголовок для сообщений об ошибках проведения.
	Заголовок = ОбщегоНазначения.ПредставлениеДокументаПриПроведении(Ссылка);
	
	РезультатЗапросаПоШапке = СформироватьЗапросПоШапке(Режим);

	// Получим реквизиты шапки из запроса
	ВыборкаПоШапкеДокумента = РезультатЗапросаПоШапке.Выбрать();
	Если ВыборкаПоШапкеДокумента.Следующий() Тогда
		
		//Надо позвать проверку заполнения реквизитов шапки
		ПроверитьЗаполнениеШапки(ВыборкаПоШапкеДокумента, Отказ, Заголовок);

		// Движения стоит добавлять, если в проведении еще не отказано (отказ =ложь)
		Если НЕ Отказ Тогда

			// получим реквизиты табличной части
			РезультатЗапросаПоПланируемыеЗатраты = СформироватьЗапросПоПланируемыеЗатраты(ВыборкаПоШапкеДокумента, Режим);
			ВыборкаПоСтрокамДокумента = РезультатЗапросаПоПланируемыеЗатраты.Выбрать(ОбходРезультатаЗапроса.ПоГруппировкам);
			
			// обходим строки документа
			Пока ВыборкаПоСтрокамДокумента.Следующий() Цикл

				
				ПроверитьЗаполнениеСтрокиПланируемыеЗатраты(ВыборкаПоШапкеДокумента, ВыборкаПоСтрокамДокумента , Отказ, Заголовок);
				
				Если НЕ Отказ Тогда
					ДобавитьСтрокуВДвиженияПоРегистрамНакопления(ВыборкаПоШапкеДокумента, ВыборкаПоСтрокамДокумента);
				КонецЕсли;
				

			КонецЦикла;

		КонецЕсли;

	КонецЕсли;

КонецПроцедуры // ОбработкаПроведения()

////////////////////////////////////////////////////////////////////////////////
// ОПЕРАТОРЫ ОСНОВНОЙ ПРОГРАММЫ
