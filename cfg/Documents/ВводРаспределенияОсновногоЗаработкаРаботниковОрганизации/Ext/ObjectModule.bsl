////////////////////////////////////////////////////////////////////////////////
// ПРОЦЕДУРЫ И ФУНКЦИИ ДЛЯ ОБЕСПЕЧЕНИЯ ПРОВЕДЕНИЯ ДОКУМЕНТА

// Формирует запрос по шапке документа
//
// Параметры:
//	Режим - режим проведения
//
// Возвращаемое значение:
//	Результат запроса
//
Функция СформироватьЗапросПоШапке()

	Запрос = Новый Запрос;

	// Установим параметры запроса
	Запрос.УстановитьПараметр("ДокументСсылка" ,		Ссылка);
	Запрос.УстановитьПараметр("парамПустаяОрганизация",	Справочники.Организации.ПустаяСсылка());
	
	Запрос.Текст =
	"ВЫБРАТЬ
	|	РаспределениеОсновногоЗаработка.Дата,
	|	РаспределениеОсновногоЗаработка.Организация,
	|	РаспределениеОсновногоЗаработка.Организация КАК ГоловнаяОрганизация,
	|	РаспределениеОсновногоЗаработка.Период,
	|	РаспределениеОсновногоЗаработка.Ссылка
	|ИЗ
	|	Документ.ВводРаспределенияОсновногоЗаработкаРаботниковОрганизации КАК РаспределениеОсновногоЗаработка
	|ГДЕ
	|	РаспределениеОсновногоЗаработка.Ссылка = &ДокументСсылка";

	Возврат Запрос.Выполнить();

КонецФункции // СформироватьЗапросПоШапке()

// Формирует запрос по таблице "РаботникиОрганизации" документа
//
// Параметры:
//	Режим - режим проведения
//
// Возвращаемое значение:
//	Результат запроса.
//
Функция СформироватьЗапросПоРаботникиОрганизации(ВыборкаПоШапкеДокумента)

	Запрос = Новый Запрос;
	
	// Установим параметры запроса
	Запрос.УстановитьПараметр("ДокументСсылка", Ссылка);
	Запрос.УстановитьПараметр("Организация", ВыборкаПоШапкеДокумента.ГоловнаяОрганизация);
	Запрос.УстановитьПараметр("Период", Период);
	
	Запрос.Текст =
	"ВЫБРАТЬ
	|	СписокРаботников.Сотрудник,
	|	СписокРаботников.Сотрудник.Наименование,
	|	СписокРаботников.Назначение,
	|	СписокРаботников.НомерСтроки КАК НомерСтроки,
	|	ВЫБОР
	|		КОГДА СписокРаботников.Сотрудник.Организация = &Организация
	|			ТОГДА ЛОЖЬ
	|		ИНАЧЕ ИСТИНА
	|	КОНЕЦ КАК ОшибкаНеСоответствиеСотрудникаИОрганизации,
	|	СуществующиеДвиженияРаспределение.РегистраторПредставление КАК КонфликтныйДокументРаспределения
	|ИЗ
	|	(ВЫБРАТЬ
	|		РаспределениеНачислений.Сотрудник КАК Сотрудник,
	|		РаспределениеНачислений.Назначение КАК Назначение,
	|		СУММА(РаспределениеНачислений.ДоляСпособаОтражения) КАК ДоляСпособаОтражения,
	|		МИНИМУМ(РаспределениеНачислений.НомерСтроки) КАК НомерСтроки
	|	ИЗ
	|		Документ.ВводРаспределенияОсновногоЗаработкаРаботниковОрганизации.РаспределениеНачислений КАК РаспределениеНачислений
	|	ГДЕ
	|		РаспределениеНачислений.Ссылка = &ДокументСсылка
	|	
	|	СГРУППИРОВАТЬ ПО
	|		РаспределениеНачислений.Сотрудник,
	|		РаспределениеНачислений.Назначение
	|	) КАК СписокРаботников
	|		ЛЕВОЕ СОЕДИНЕНИЕ (ВЫБРАТЬ РАЗЛИЧНЫЕ
	|			СуществующееРаспределение.Сотрудник КАК Сотрудник,
	|			ПРЕДСТАВЛЕНИЕ(СуществующееРаспределение.Регистратор) КАК РегистраторПредставление
	|		ИЗ
	|			РегистрСведений.РаспределениеОсновногоЗаработкаРаботниковОрганизаций КАК СуществующееРаспределение
	|		ГДЕ
	|			СуществующееРаспределение.ПериодРегистрации = &Период
	|			И СуществующееРаспределение.Организация = &Организация) КАК СуществующиеДвиженияРаспределение
	|		ПО СписокРаботников.Сотрудник = СуществующиеДвиженияРаспределение.Сотрудник
	|
	|УПОРЯДОЧИТЬ ПО
	|	НомерСтроки";
	
	Возврат Запрос.Выполнить();

КонецФункции // СформироватьЗапросПоРаботникиОрганизации()

// Формирует запрос по таблице "РаботникиОрганизации" документа
//
// Параметры:
//	Режим - режим проведения
//
// Возвращаемое значение:
//	Результат запроса.
//
Функция СформироватьЗапросПоРаботникиОрганизацииРаспределение()

	Запрос = Новый Запрос;
	
	Запрос.УстановитьПараметр("ДокументСсылка" , Ссылка);
	
	Запрос.Текст =
	"ВЫБРАТЬ
	|	СписокРаспределения.Сотрудник,
	|	СписокРаспределения.Назначение,
	|	СписокРаспределения.СпособОтраженияВБухучете,
	|	СписокРаспределения.ДоляСпособаОтражения,
	|	ВЫБОР
	|		КОГДА СписокРаспределения.СпособОтраженияВБухучете.СчетДт = ЗНАЧЕНИЕ(ПланСчетов.Хозрасчетный.ПустаяСсылка)
	|			ТОГДА ЛОЖЬ
	|		КОГДА СписокРаспределения.СпособОтраженияВБухучете.СчетКт = ЗНАЧЕНИЕ(ПланСчетов.Хозрасчетный.ПустаяСсылка)
	|			ТОГДА ЛОЖЬ
	|		ИНАЧЕ ИСТИНА
	|	КОНЕЦ КАК СчетВыбран,
	|	ВЫБОР
	|		КОГДА СписокРаспределения.СпособОтраженияВБухучете.Ссылка = ЗНАЧЕНИЕ(Справочник.СпособыОтраженияЗарплатыВРеглУчете.НеОтражатьВБухучете)
	|			ТОГДА ИСТИНА
	|		ИНАЧЕ ЛОЖЬ
	|	КОНЕЦ КАК НеОтражатьВБухучете,
	|	ВЫБОР
	|		КОГДА СписокРаспределения.СпособОтраженияВБухучете.Ссылка = ЗНАЧЕНИЕ(Справочник.СпособыОтраженияЗарплатыВРеглУчете.ОтражениеНачисленийПоУмолчанию)
	|			ТОГДА ИСТИНА
	|		ИНАЧЕ ЛОЖЬ
	|	КОНЕЦ КАК ОтражениеНачисленийПоУмолчанию,
	|	ВЫБОР
	|		КОГДА СписокРаспределения.СпособОтраженияВБухучете = ЗНАЧЕНИЕ(Справочник.СпособыОтраженияЗарплатыВРеглУчете.ПустаяСсылка)
	|			ТОГДА ИСТИНА
	|		ИНАЧЕ ЛОЖЬ
	|	КОНЕЦ КАК ПустойСпособОтражения,	
	|	СписокРаспределения.НомерСтроки КАК НомерСтроки
	|ИЗ
	|	Документ.ВводРаспределенияОсновногоЗаработкаРаботниковОрганизации.РаспределениеНачислений КАК СписокРаспределения
	|ГДЕ
	|	СписокРаспределения.Ссылка = &ДокументСсылка
	|
	|УПОРЯДОЧИТЬ ПО
	|	НомерСтроки";
	
	Возврат Запрос.Выполнить();

КонецФункции // СформироватьЗапросПоРаботникиОрганизацииРаспределение()

// Формирует запрос по таблице "РаботникиОрганизации" документа
//
// Параметры:
//	Режим - режим проведения
//
// Возвращаемое значение:
//	Результат запроса.
//
Функция СформироватьЗапросПоРаботникиОрганизацииРаспределениеИтоги()

	Запрос = Новый Запрос;
	
	Запрос.УстановитьПараметр("ДокументСсылка" , Ссылка);
	
	Запрос.Текст =
	"ВЫБРАТЬ
	|	СписокРаспределения.Назначение,
	|	СУММА(СписокРаспределения.ДоляСпособаОтражения) КАК ДоляСпособаОтражения
	|ИЗ
	|	Документ.ВводРаспределенияОсновногоЗаработкаРаботниковОрганизации.РаспределениеНачислений КАК СписокРаспределения
	|ГДЕ
	|	СписокРаспределения.Ссылка = &ДокументСсылка
	|
	|СГРУППИРОВАТЬ ПО
	|	СписокРаспределения.Назначение";
	
	Возврат Запрос.Выполнить();

КонецФункции // СформироватьЗапросПоРаботникиОрганизацииРаспределение()

// Проверяет правильность заполнения шапки документа.
// Если какой-то из реквизитов шапки, влияющий на проведение не заполнен или
// заполнен не корректно, то выставляется флаг отказа в проведении.
// Проверка выполняется по выборке из результата запроса по шапке,
// все проверяемые реквизиты должны быть включены в выборку по шапке.
//
// Параметры: 
//	ВыборкаПоШапкеДокумента	- выборка из результата запроса по шапке документа,
//	Отказ 					- флаг отказа в проведении.
//
Процедура ПроверитьЗаполнениеШапки(ВыборкаПоШапкеДокумента, Отказ, Заголовок)

	Если НЕ ЗначениеЗаполнено(ВыборкаПоШапкеДокумента.Организация) Тогда
		ОбщегоНазначения.СообщитьОбОшибке(ОбщегоНазначения.ПреобразоватьСтрокуИнтерфейса(НСтр("ru='Не указана организация!';uk='Не зазначена організація!'")), Отказ, Заголовок);
	КонецЕсли;	
		
	Если НЕ ЗначениеЗаполнено(ВыборкаПоШапкеДокумента.Период) Тогда
		ОбщегоНазначения.СообщитьОбОшибке(НСтр("ru='Не указан период!';uk='Не зазначений період!'"), Отказ, Заголовок);
	КонецЕсли;

КонецПроцедуры // ПроверитьЗаполнениеШапки()

// Проверяет правильность заполнения реквизитов в строке ТЧ "РаботникиОрганизации" документа.
// Если какой-то из реквизитов, влияющий на проведение не заполнен или
// заполнен не корректно, то выставляется флаг отказа в проведении.
// Проверка выполняется по выборке из результата запроса по строке ТЧ документа,
// все проверяемые реквизиты должны быть включены в выборку.
//
// Параметры: 
//	ВыборкаПоШапкеДокумента		- выборка из результата запроса по шапке документа,
//	ВыборкаПоСтрокамДокумента	- спозиционированная на определенной строке выборка 
//								  из результата запроса
//	Отказ						- флаг отказа в проведении.
//	Заголовок					- Заголовок для сообщений об ошибках проведения
//
Процедура ПроверитьЗаполнениеСтрокиРаботникаОрганизации(ВыборкаПоСтрокамДокумента, Отказ, Заголовок)

	СтрокаНачалаСообщенияОбОшибке = НСтр("ru='В строке номер ""';uk='У рядку номер ""'")+ СокрЛП(ВыборкаПоСтрокамДокумента.НомерСтроки) +
									НСтр("ru='"" табл. части ""Распределение основного заработка"": ';uk='"" табл. частини ""Розподіл основного заробітку"": '");
									
									
	Если ВыборкаПоСтрокамДокумента.ПустойСпособОтражения Тогда
		ОбщегоНазначения.СообщитьОбОшибке(СтрокаНачалаСообщенияОбОшибке + НСтр("ru='не задан способ отражения!';uk='не вказаний спосіб відображення!'"), Отказ, Заголовок);
	КонецЕсли;
	
	// Проверка способа отражения
	Если ВыборкаПоСтрокамДокумента.НеОтражатьВБухучете Тогда
		ОбщегоНазначения.СообщитьОбОшибке(СтрокаНачалаСообщенияОбОшибке + НСтр("ru='заданный способ отражения нельзя указывать в документе!';uk='заданий спосіб відображення не можна вказувати в документі!'"), Отказ, Заголовок);
	ИначеЕсли Не ВыборкаПоСтрокамДокумента.СчетВыбран Тогда
		ОбщегоНазначения.СообщитьОбОшибке(СтрокаНачалаСообщенияОбОшибке + НСтр("ru='в способе отражения не задан счет дебета и/или кредита!';uk='у способі відображення не заданий рахунок дебету і/або кредиту!'"), Отказ, Заголовок);
	КонецЕсли;
	
КонецПроцедуры // ПроверитьЗаполнениеСтрокиРаботникаОрганизации()

// Проверяет правильность заполнения реквизитов в строке ТЧ "РаботникиОрганизации" документа.
// Если какой-то из реквизитов, влияющий на проведение не заполнен или
// заполнен не корректно, то выставляется флаг отказа в проведении.
// Проверка выполняется по выборке из результата запроса по строке ТЧ документа,
// все проверяемые реквизиты должны быть включены в выборку.
//
// Параметры: 
//	ВыборкаПоШапкеДокумента		- выборка из результата запроса по шапке документа,
//	ВыборкаПоСтрокамДокумента	- спозиционированная на определенной строке выборка 
//								  из результата запроса
//	Отказ						- флаг отказа в проведении.
//	Заголовок					- Заголовок для сообщений об ошибках проведения
//
Процедура ПроверитьЗаполнениеДанныхПоРаботнику(ВыборкаПоШапкеДокумента, ВыборкаПоСтрокамДокумента, Отказ, Заголовок, ЕстьЕНВД)

	СтрокаНачалаСообщенияОбОшибке = НСтр("ru='В строке номер ""';uk='У рядку номер ""'")+ СокрЛП(ВыборкаПоСтрокамДокумента.НомерСтроки) +
									НСтр("ru='"" табл. части ""Распределение основного заработка"": ';uk='"" табл. частини ""Розподіл основного заробітку"": '");
	
	// Сотрудник
	Если НЕ ЗначениеЗаполнено(ВыборкаПоСтрокамДокумента.Сотрудник) Тогда
		ОбщегоНазначения.СообщитьОбОшибке(СтрокаНачалаСообщенияОбОшибке + НСтр("ru='не выбран сотрудник!';uk='не обраний співробітник!'"), Отказ, Заголовок);
	КонецЕсли;
	
	// Сотрудник и организация
	Если ВыборкаПоСтрокамДокумента.ОшибкаНеСоответствиеСотрудникаИОрганизации Тогда
		ОбщегоНазначения.СообщитьОбОшибке(СтрокаНачалаСообщенияОбОшибке + ВыборкаПоСтрокамДокумента.СотрудникНаименование+ОбщегоНазначения.ПреобразоватьСтрокуИнтерфейса(НСтр("ru=' работает в другой организации!';uk=' працює в іншій організації!'")), Отказ, Заголовок);
	КонецЕсли;

////	Если ВыборкаПоСтрокамДокумента.ИтогоОтражено <> 100 Тогда
////		ОбщегоНазначения.СообщитьОбОшибке(СтрокаНачалаСообщенияОбОшибке + "суммарная доля распределения начислений по сотруднику не равна 100%!", Отказ, Заголовок);
////	КонецЕсли;
////	
	// Движения в регистре распределения
	Если ЗначениеЗаполнено(ВыборкаПоСтрокамДокумента.КонфликтныйДокументРаспределения) Тогда
		ОбщегоНазначения.СообщитьОбОшибке(СтрокаНачалаСообщенияОбОшибке + НСтр("ru='на период ';uk='на період '")+ Формат(ВыборкаПоШапкеДокумента.Период, "ДФ='ММММ гггг'") + НСтр("ru=' распределение основного заработка уже зарегистрировано документом ';uk=' розподіл основного заробітку вже зареєстрований документом '") + Символы.ПС + ВыборкаПоСтрокамДокумента.КонфликтныйДокументРаспределения + "!", Отказ, Заголовок);
	КонецЕсли;

	
КонецПроцедуры // ПроверитьЗаполнениеДанныхПоРаботнику()

// По строке выборки результата запроса по документу формируем движения по регистрам
//
// Параметры: 
//	ВыборкаПоШапкеДокумента					- выборка из результата запроса по шапке документа,
//	ИмяРегистра								- строка, имя регистра по которому делаем движения
//	СтруктураПараметров						- структура параметров проведения,
//
// Возвращаемое значение:
//	Нет.
//
Процедура ДобавитьСтрокуВДвиженияПоРегистрамСведений(ВыборкаПоШапкеДокумента, ВыборкаПоРаботникиОрганизации, ИмяРегистра)
	
	Движение = Движения[ИмяРегистра].Добавить();
	
	Если ИмяРегистра = "РаспределениеОсновногоЗаработкаРаботниковОрганизаций" Тогда	
		
		// Измерения
		Движение.ПериодРегистрации			= ВыборкаПоШапкеДокумента.Период;
		Движение.Сотрудник					= ВыборкаПоРаботникиОрганизации.Сотрудник;
		Движение.Назначение					= ВыборкаПоРаботникиОрганизации.Назначение;
		Движение.СпособОтраженияВБухучете 	= ВыборкаПоРаботникиОрганизации.СпособОтраженияВБухучете;
		Движение.Организация				= ВыборкаПоШапкеДокумента.ГоловнаяОрганизация;
		
		// Ресурсы
		Движение.ДоляСпособаОтражения		= ВыборкаПоРаботникиОрганизации.ДоляСпособаОтражения;
		
	КонецЕсли; 
	
		
КонецПроцедуры // ДобавитьСтрокуВДвиженияПоРегистрамСведений()

////////////////////////////////////////////////////////////////////////////////
// ПРОЦЕДУРЫ - ОБРАБОТЧИКИ СОБЫТИЙ

Процедура ОбработкаПроведения(Отказ, Режим)
	
	// Заголовок для сообщений об ошибках проведения.
	Заголовок = ОбщегоНазначения.ПредставлениеДокументаПриПроведении(Ссылка);

	РезультатЗапросаПоШапке = СформироватьЗапросПоШапке();

	// Получим реквизиты шапки из запроса
	ВыборкаПоШапкеДокумента = РезультатЗапросаПоШапке.Выбрать();

	Если ВыборкаПоШапкеДокумента.Следующий() Тогда

		//Надо позвать проверку заполнения реквизитов шапки
		ПроверитьЗаполнениеШапки(ВыборкаПоШапкеДокумента, Отказ, Заголовок);

		РезультатЗапросаПоРаботникиИтоги = СформироватьЗапросПоРаботникиОрганизацииРаспределениеИтоги();
		ВыборкаПоРаботникиОрганизацииИтоги = РезультатЗапросаПоРаботникиИтоги.Выбрать();

		Пока ВыборкаПоРаботникиОрганизацииИтоги.Следующий() Цикл
			Если ВыборкаПоРаботникиОрганизацииИтоги.ДоляСпособаОтражения <> 100 Тогда
				Сообщить(НСтр("ru='По сотруднику ';uk='По співробітнику '")+ВыборкаПоРаботникиОрганизацииИтоги.Назначение.Наименование+НСтр("ru=' общий процент распределения не равен 100%!';uk=' загальний відсоток розподілу не дорівнює 100%!'"), СтатусСообщения.Внимание);
			КонецЕсли;	
		КонецЦикла;	
		
		// Движения стоит добавлять, если в проведении еще не отказано (отказ =ложь)
		Если НЕ Отказ Тогда

			// получим реквизиты табличной части, сгруппированные по работникам
			РезультатЗапросаПоРаботники = СформироватьЗапросПоРаботникиОрганизации(ВыборкаПоШапкеДокумента);
			ВыборкаПоРаботникиОрганизации = РезультатЗапросаПоРаботники.Выбрать();
			
			// получим реквизиты табличной части
			РезультатЗапросаПоРаботники = СформироватьЗапросПоРаботникиОрганизацииРаспределение();
			ВыборкаПоРаботникиОрганизации = РезультатЗапросаПоРаботники.Выбрать();
			
			Пока ВыборкаПоРаботникиОрганизации.Следующий() Цикл 

				// проверим очередную строку табличной части
				ПроверитьЗаполнениеСтрокиРаботникаОрганизации(ВыборкаПоРаботникиОрганизации, Отказ, Заголовок);
				
				Если Не Отказ Тогда
					// Заполним записи в наборах записей регистров
					ДобавитьСтрокуВДвиженияПоРегистрамСведений(ВыборкаПоШапкеДокумента, ВыборкаПоРаботникиОрганизации, "РаспределениеОсновногоЗаработкаРаботниковОрганизаций");
				КонецЕсли;
				
			КонецЦикла;
			
			Если Отказ Тогда
				Возврат;
			КонецЕсли; 
			
		КонецЕсли;

	КонецЕсли;

КонецПроцедуры // ОбработкаПроведения()

Процедура ПередЗаписью(Отказ, РежимЗаписи, РежимПроведения)
	
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	
	КраткийСоставДокумента = ПроцедурыУправленияПерсоналом.ЗаполнитьКраткийСоставДокумента(РаботникиОрганизации);
	ПроцедурыУправленияПерсоналом.ЗаполнитьФизЛицоПоТЧ(РаботникиОрганизации);

КонецПроцедуры // ПередЗаписью()

////////////////////////////////////////////////////////////////////////////////
// ОПЕРАТОРЫ ОСНОВНОЙ ПРОГРАММЫ

