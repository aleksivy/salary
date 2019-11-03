﻿Перем мСведенияОСчетах;
Перем мСведенияОСтатьяхЗатрат;
Перем мПустойСчет;


////////////////////////////////////////////////////////////////////////////////
// ВСПОМОГАТЕЛЬНЫЕ ПРОЦЕДУРЫ И ФУНКЦИИ

// Формирует запрос по шапке документа
//
// Параметры: 
//  нет
//
// Возвращаемое значение:
//  Результат запроса
//
Функция СформироватьЗапросПоШапке() Экспорт
	
	Запрос = Новый Запрос;
	
	// Установим параметры запроса
	Запрос.УстановитьПараметр("ДокументСсылка" , Ссылка);
	Запрос.УстановитьПараметр("парамПустаяОрганизация", Справочники.Организации.ПустаяСсылка());
	
	Запрос.Текст = "
	|ВЫБРАТЬ 
	|	Дата                                               	КАК Дата, 
	|	ПериодРегистрации                                  	КАК ПериодРегистрации, 
	|	ВЫБОР КОГДА Организация.ГоловнаяОрганизация = &парамПустаяОрганизация 
	|			ТОГДА Организация 
	|			ИНАЧЕ Организация.ГоловнаяОрганизация 
	|		  КОНЕЦ                                         КАК ГоловнаяОрганизация, 
	|	Организация											КАК Организация, 
	|	Организация											КАК ОбособленноеПодразделение, 
	| 	Ссылка                                              КАК Ссылка
	| 
	|	ИЗ	Документ.НачислениеКоммунальногоНалога
	| 
	|ГДЕ	Ссылка = &ДокументСсылка
	|";
	
	Возврат Запрос.Выполнить();
	
КонецФункции // СформироватьЗапросПоШапке()

// проверяет должен ли быть указан или нет счет учета по НУ
//
// Параметры
//  СчетДт,СчетКт - счета хозрасчетного плана счетов
//  СчетДтНУ	  - счет налогового плана счетов - будущий счет дебета
//
// Возвращаемое значение:
//   булево   – если сочетание корректно, то истина
//
Функция КорректноеСочетаниеСчетов(Выборка,Сообщение)
	
	Сообщение = "";
	
	СчетКт = Выборка.СчетКт;
	СчетДт = Выборка.СчетДт;
	
	Если (СчетДт = ПланыСчетов.Хозрасчетный.РасчетыПоОплатеТруда 
		или СчетДт = ПланыСчетов.Хозрасчетный.ПрочиеФинансовыеДоходы) Тогда
		Сообщение = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(НСтр("ru='Проводки в дебет %1 не должны отражаться в налоговом учете!';uk='Проводки в дебет %1 не повинні відображатись в податковому обліку!'"), Выборка.НаименованиеСчетДт);
	КонецЕсли;
	
	Возврат НЕ ЗначениеЗаполнено(Сообщение)
	
КонецФункции // КорректноеСочетаниеСчетов()

////////////////////////////////////////////////////////////////////////////////
// ЭКСПОРТНЫЕ ПРОЦЕДУРЫ И ФУНКЦИИ

Процедура АвтозаполнениеПроводок() Экспорт
	
	
	ОтражениеВУчете.Очистить();
	Записать();  // запишем документ
	
	ВыборкаПоПроводкам = СформироватьЗапросПроводки().Выбрать();
	
	ПлохиеДанные = Ложь;
	
	Пока ВыборкаПоПроводкам.Следующий() Цикл
		//ПроверитьЗаполнениеСтрокиДохода(ВыборкаПоПроводкам, ПлохиеДанные);
		ДобавитьСтрокуВПроводки(ВыборкаПоПроводкам, ОтражениеВУчете);
	КонецЦикла;
	
	Если ПлохиеДанные Тогда
		Возврат;
	КонецЕсли;
	
КонецПроцедуры  // АвтозаполнениеПроводок

///////////////////////////////////////////////////////////////////////////
// общие функции для всех Автозаполнений

Функция ДобавитьСтрокуВПроводки(ДанныеУчета, ТЧ)
	
	СтрокаДанных = ТЧ.Добавить();
	
	// ресурсы
	
	Если Не ЗначениеЗаполнено(СтавкаКоммунальногоНалога) Тогда
		ПроведениеРасчетов.ОпределитьРегламентированныеПараметрыДляРасчетаКоммунальногоНалога(СтавкаКоммунальногоНалога, 0, ПериодРегистрации, Организация );
	КонецЕсли;
	
	Если Не ЗначениеЗаполнено(НеоблагаемыйМинимум) Тогда
		ПроведениеРасчетов.ОпределитьРегламентированныеПараметрыДляРасчетаКоммунальногоНалога(0, НеоблагаемыйМинимум, ПериодРегистрации, Организация );
	КонецЕсли;

	СуммаНалога = СреднесписочнаяЧисленность * СтавкаКоммунальногоНалога * НеоблагаемыйМинимум; 
	СтрокаДанных.Сумма			= СуммаНалога;
	
	// реквизиты
	СтрокаДанных.НалоговоеНазначение	= ДанныеУчета.НалоговоеНазначение;
	
	СтрокаДанных.СчетДт      = ДанныеУчета.СчетДт;
	СтрокаДанных.СубконтоДт1 = ДанныеУчета.СубконтоДт1;
	СтрокаДанных.СубконтоДт2 = ДанныеУчета.СубконтоДт2;
	СтрокаДанных.СубконтоДт3 = ДанныеУчета.СубконтоДт3;
	
	СтрокаДанных.СчетКт      = ДанныеУчета.СчетКт;
	СтрокаДанных.СубконтоКт1 = ДанныеУчета.СубконтоКт1;
	СтрокаДанных.СубконтоКт2 = ДанныеУчета.СубконтоКт2;
	СтрокаДанных.СубконтоКт3 = ДанныеУчета.СубконтоКт3;
	
	
	СтрокаДанных.СтатьяВаловыхРасходов	= ДанныеУчета.СтатьяВаловыхРасходов;
	
	Возврат СтрокаДанных;
	
КонецФункции     // ДобавитьСтрокуВПроводки()

///////////////////////////////////////////////////////////////////////////
// Автозаполнения

////////////////////////////////////////////////////////////////////////////////
// ПРОЦЕДУРЫ И ФУНКЦИИ ДЛЯ ОБЕСПЕЧЕНИЯ ПРОВЕДЕНИЯ ДОКУМЕНТА

Функция СформироватьЗапросПроводки()
	
	Запрос = Новый Запрос();
	
	ТекстЗапроса  = "
	|ВЫБРАТЬ
	|	Основные.НалоговоеНазначение		КАК НалоговоеНазначение,
	|	Основные.СчетДт						КАК СчетДт,
	|	Основные.СубконтоДт1				КАК СубконтоДт1,
	|	Основные.СубконтоДт2				КАК СубконтоДт2,
	|	Основные.СубконтоДт3				КАК СубконтоДт3,
	|	Основные.СчетКт						КАК СчетКт,
	|	Основные.СубконтоКт1				КАК СубконтоКт1,
	|	Основные.СубконтоКт2				КАК СубконтоКт2,
	|	Основные.СубконтоКт3				КАК СубконтоКт3,    
	|	Основные.СтатьяВаловыхРасходов		КАК СтатьяВаловыхРасходов
	|	
	|ИЗ	Справочник.СпособыОтраженияЗарплатыВРеглУчете КАК Основные
	|ГДЕ Основные.Ссылка = &парамКоммунальный
	|
	|";
	
	Запрос.Текст = ТекстЗапроса;
	Запрос.УстановитьПараметр("парамКоммунальный", СпособОтраженияВБухучете);
	
	Возврат Запрос.Выполнить();
	
КонецФункции // СформироватьЗапросПроводки()

Функция СформироватьЗапросПоОтражениюВУчете()
	
	Запрос = Новый Запрос();
	ТекстЗапроса = "
	|ВЫБРАТЬ
	|	ОтражениеЗарплаты.НомерСтроки				КАК НомерСтроки,
	|	ОтражениеЗарплаты.СтатьяВаловыхРасходов 	КАК СтатьяВаловыхРасходов,
	|
	|	ОтражениеЗарплаты.НалоговоеНазначение 							КАК НалоговоеНазначение,
	|
	|	ОтражениеЗарплаты.СчетДт				КАК СчетДт,
	|	ОтражениеЗарплаты.СчетДт.Наименование	КАК НаименованиеСчетДт,
	|	ОтражениеЗарплаты.СубконтоДт1			КАК СубконтоДт1,
	|	ОтражениеЗарплаты.СубконтоДт2			КАК СубконтоДт2,
	|	ОтражениеЗарплаты.СубконтоДт3			КАК СубконтоДт3,
	|	ВидСубконтоДт1.ВидСубконто				КАК ВидСубконтоДт1,
	|	ВидСубконтоДт2.ВидСубконто 				КАК ВидСубконтоДт2,
	|	ВидСубконтоДт3.ВидСубконто 				КАК ВидСубконтоДт3,
	|
	|	ОтражениеЗарплаты.СчетКт				КАК СчетКт,
	|	ОтражениеЗарплаты.СубконтоКт1			КАК СубконтоКт1,
	|	ОтражениеЗарплаты.СубконтоКт2			КАК СубконтоКт2,
	|	ОтражениеЗарплаты.СубконтоКт3			КАК СубконтоКт3,
	|	ВидСубконтоКт1.ВидСубконто 				КАК ВидСубконтоКт1,
	|	ВидСубконтоКт2.ВидСубконто 				КАК ВидСубконтоКт2,
	|	ВидСубконтоКт3.ВидСубконто 				КАК ВидСубконтоКт3,
	|
	|	ОтражениеЗарплаты.Сумма					КАК Сумма
	|
	|ИЗ	Документ.НачислениеКоммунальногоНалога.ОтражениеВУчете КАК ОтражениеЗарплаты
	|
	|ЛЕВОЕ СОЕДИНЕНИЕ ПланСчетов.Хозрасчетный.ВидыСубконто КАК ВидСубконтоДт1
	|ПО ВидСубконтоДт1.Ссылка = ОтражениеЗарплаты.СчетДт И (ВидСубконтоДт1.НомерСтроки = 1)
	|
	|ЛЕВОЕ СОЕДИНЕНИЕ ПланСчетов.Хозрасчетный.ВидыСубконто КАК ВидСубконтоДт2
	|ПО ВидСубконтоДт2.Ссылка = ОтражениеЗарплаты.СчетДт И (ВидСубконтоДт2.НомерСтроки = 2)
	|
	|ЛЕВОЕ СОЕДИНЕНИЕ ПланСчетов.Хозрасчетный.ВидыСубконто КАК ВидСубконтоДт3
	|ПО ВидСубконтоДт3.Ссылка = ОтражениеЗарплаты.СчетДт И (ВидСубконтоДт3.НомерСтроки = 3)
	|
	|
	|ЛЕВОЕ СОЕДИНЕНИЕ ПланСчетов.Хозрасчетный.ВидыСубконто КАК ВидСубконтоКт1
	|ПО ВидСубконтоКт1.Ссылка = ОтражениеЗарплаты.СчетКт И (ВидСубконтоКт1.НомерСтроки = 1)
	|
	|ЛЕВОЕ СОЕДИНЕНИЕ ПланСчетов.Хозрасчетный.ВидыСубконто КАК ВидСубконтоКт2
	|ПО ВидСубконтоКт2.Ссылка = ОтражениеЗарплаты.СчетКт И (ВидСубконтоКт2.НомерСтроки = 2)
	|
	|ЛЕВОЕ СОЕДИНЕНИЕ ПланСчетов.Хозрасчетный.ВидыСубконто КАК ВидСубконтоКт3
	|ПО ВидСубконтоКт3.Ссылка = ОтражениеЗарплаты.СчетКт И (ВидСубконтоКт3.НомерСтроки = 3)
	|
	|
	|ГДЕ	ОтражениеЗарплаты.Ссылка = &парамРегистратор
	|";
	
	Запрос.Текст = ТекстЗапроса;
	
	Запрос.УстановитьПараметр("парамРегистратор", Ссылка);
	Запрос.УстановитьПараметр("РасходыБудущихПериодов", ПланыВидовХарактеристик.ВидыСубконтоХозрасчетные.РасходыБудущихПериодов);
	Запрос.УстановитьПараметр("ПустоеПодразделение", Справочники.ПодразделенияОрганизаций.ПустаяСсылка());
	Запрос.УстановитьПараметр("ПустаяНоменклатурнаяГруппа", Справочники.НоменклатурныеГруппы.ПустаяСсылка());
	Запрос.УстановитьПараметр("ПустаяСтатьяЗатрат", Справочники.СтатьиЗатрат.ПустаяСсылка());
	
	Возврат Запрос.Выполнить();
	
КонецФункции  // СформироватьЗапросПоОтражениюВУчете()

// Проверяет правильность заполнения шапки документа.
// Если какой-то из реквизтов шапки, влияющий на проведение не заполнен или
// заполнен не корректно, то выставляется флаг отказа в проведении.
// Проверка выполняется по выборке из результата запроса по шапке,
// все проверяемые реквизиты должны быть включены в выборку по шапке.
//
// Параметры: 
//  ВыборкаПоШапкеДокумента	- выборка из результата запроса по шапке документа,
//  Отказ 					- флаг отказа в проведении.
//
Процедура ПроверитьЗаполнениеШапки(Отказ)
	
	Если НЕ ЗначениеЗаполнено(Организация) Тогда
		ОбщегоНазначения.СообщитьОбОшибке(НСтр("ru='Не задана организация!';uk='Не задана організація!'"), Отказ);
	КонецЕсли;
	
	Если Не ЗначениеЗаполнено(ПериодРегистрации) Тогда
		ОбщегоНазначения.СообщитьОбОшибке(НСтр("ru='Не задан период за который выполняется отражение начислений в бухгалтерском учете!';uk='Не заданий період за який виконується відображення нарахувань у бухгалтерському обліку!'"), Отказ);
	КонецЕсли;
	
КонецПроцедуры // ПроверитьЗаполнениеШапки()

Процедура ПроверитьЗаполнениеСтрокиОтраженияВУчете(ВыборкаПоДоходам, Отказ, Заголовок = "")
	
	СтрокаНачалаСообщенияОбОшибке = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(НСтр("ru='В строке номер ""%1"" табл. части ""Проводки"": ';uk='У рядку номер ""%1"" табл. частини ""Проводки"": '"), СокрЛП(ВыборкаПоДоходам.НомерСтроки));
	
	Если НЕ ЗначениеЗаполнено(ВыборкаПоДоходам.СчетДт) Тогда
		ОбщегоНазначения.СообщитьОбОшибке(СтрокаНачалаСообщенияОбОшибке + НСтр("ru='Не указан счет дебета!';uk='Не зазначений рахунок дебету!'"), Отказ);
	КонецЕсли;
	
	Если НЕ ЗначениеЗаполнено(ВыборкаПоДоходам.СчетКт) Тогда
		ОбщегоНазначения.СообщитьОбОшибке(СтрокаНачалаСообщенияОбОшибке + НСтр("ru='Не указан счет кредита!';uk='Не зазначений рахунок кредиту!'"), Отказ);
	КонецЕсли;
	
	Сообщение = "";
	Если Не КорректноеСочетаниеСчетов(ВыборкаПоДоходам,Сообщение) Тогда
		ОбщегоНазначения.СообщитьОбОшибке(СтрокаНачалаСообщенияОбОшибке + Сообщение, Отказ, Заголовок);
	КонецЕсли;
	
КонецПроцедуры // ПроверитьЗаполнениеСтрокиОтраженияВУчете()

////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ

Процедура ОбработкаПроведения(Отказ, Режим)
	
	Если ПроведениеРасчетов.ИспользуетсяНК(ПериодРегистрации) Тогда
		Сообщить(НСтр("ru='С 01.01.2011 г. коммунальный налог отменен и документ больше не используется';uk='З 01.01.2011 комунальний податок скасовано і документ більше не використовується'"),СтатусСообщения.Важное);
		Отказ = Истина;
		Возврат;
	КонецЕсли;
	
	// Сформируем структуру реквизитов шапки документа
	СтруктураШапкиДокумента = ОбщегоНазначения.СформироватьСтруктуруШапкиДокумента(ЭтотОбъект);
	
	// Заголовок для сообщений об ошибках проведения.
	Заголовок = ОбщегоНазначения.ПредставлениеДокументаПриПроведении(Ссылка);
	
	СтруктураПолейУчетнойПолитикиНУ = Новый Структура("ЕстьНалогНаПрибыльНал");
		
	// При получении учетной политики произошли ошибки
	Если Отказ Тогда
		Возврат;
	КонецЕсли;
	
	ПроверитьЗаполнениеШапки(Отказ);
	
	Если Отказ Тогда
		Возврат;
	КонецЕсли;
	
	ВыборкаПоОтражениюВУчете = СформироватьЗапросПоОтражениюВУчете().Выбрать();
	
	Пока ВыборкаПоОтражениюВУчете.Следующий() Цикл
		
		ПроверитьЗаполнениеСтрокиОтраженияВУчете(ВыборкаПоОтражениюВУчете, Отказ, Заголовок);
		
		
	КонецЦикла;
	

КонецПроцедуры // ОбработкаПроведения()

Процедура ПередЗаписью(Отказ, РежимЗаписи, РежимПроведения)
	
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	
КонецПроцедуры

Процедура ОбработкаУдаленияПроведения(Отказ)
	
	Возврат;
	
КонецПроцедуры

мПустойСчет = ПланыСчетов.Хозрасчетный.ПустаяСсылка();
мСведенияОСчетах = Новый Соответствие;
мСведенияОСтатьяхЗатрат = Новый Соответствие;
