////////////////////////////////////////////////////////////////////////////////
// ЭКСПОРТНЫЕ ПРОЦЕДУРЫ И ФУНКЦИИ

Процедура ОбновитьРабочиеМестаУпр(Подразделение, Период = Неопределено) Экспорт
	
	Запрос = Новый Запрос;
	
	Запрос.УстановитьПараметр("Подразделение",	Подразделение);
	
	Если Период <> Неопределено Тогда
		Запрос.УстановитьПараметр("ДатаАктуальности",	Период);
		
		Запрос.Текст =
		"ВЫБРАТЬ
		|	КадровыйПланСрезПоследних.Подразделение КАК Подразделение,
		|	МАКСИМУМ(ВЫБОР
		|		КОГДА КадровыйПланСрезПоследних.Подразделение = &Подразделение
		|			ТОГДА ЛОЖЬ
		|		ИНАЧЕ ИСТИНА
		|	КОНЕЦ) КАК ЕстьИерархия,
		|	КадровыйПланСрезПоследних.Должность КАК Должность,
		|	КадровыйПланСрезПоследних.Должность.Наименование КАК ДолжностьНаименование,
		|	СУММА(ЕСТЬNULL(ЗанятыеРабочиеМестаОстатки.КоличествоОстаток, 0)) КАК Занято,
		|	СУММА(КадровыйПланСрезПоследних.Количество) КАК Запланировано,
		|	СУММА(КадровыйПланСрезПоследних.Количество - ЕСТЬNULL(ЗанятыеРабочиеМестаОстатки.КоличествоОстаток, 0)) КАК Вакантно
		|ИЗ
		|	РегистрСведений.КадровыйПлан.СрезПоследних(
		|		&ДатаАктуальности,
		|		ПодразделениеОрганизации = ЗНАЧЕНИЕ(Справочник.ПодразделенияОрганизаций.ПустаяСсылка)";
		Если Подразделение <> Неопределено Тогда
		Запрос.Текст = Запрос.Текст + "
		|			И Подразделение В ИЕРАРХИИ (&Подразделение)";
		КонецЕсли;
		Запрос.Текст = Запрос.Текст + "
		|			) КАК КадровыйПланСрезПоследних
		|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрНакопления.ЗанятыеРабочиеМеста.Остатки(&ДатаАктуальности,";
		Если Подразделение <> Неопределено Тогда
		Запрос.Текст = Запрос.Текст + "
		|			Подразделение В ИЕРАРХИИ (&Подразделение)";
		КонецЕсли;
		Запрос.Текст = Запрос.Текст + "
		|			) КАК ЗанятыеРабочиеМестаОстатки
		|		ПО КадровыйПланСрезПоследних.Подразделение = ЗанятыеРабочиеМестаОстатки.Подразделение
		|			И КадровыйПланСрезПоследних.Должность = ЗанятыеРабочиеМестаОстатки.Должность.Должность
		|
		|СГРУППИРОВАТЬ ПО
		|	КадровыйПланСрезПоследних.Подразделение,
		|	КадровыйПланСрезПоследних.Должность,
		|	КадровыйПланСрезПоследних.Должность.Наименование
		|
		|ОБЪЕДИНИТЬ
		|
		|ВЫБРАТЬ
		|	ЗанятыеРабочиеМестаОстатки.Подразделение КАК Подразделение,
		|	ЗанятыеРабочиеМестаОстатки.Должность.Должность,
		|	ЗанятыеРабочиеМестаОстатки.Должность.Должность.Наименование,
		|	МАКСИМУМ(ВЫБОР
		|		КОГДА ЗанятыеРабочиеМестаОстатки.Подразделение = &Подразделение
		|			ТОГДА ЛОЖЬ
		|		ИНАЧЕ ИСТИНА
		|	КОНЕЦ) КАК ЕстьИерархия,
		|	СУММА(ЗанятыеРабочиеМестаОстатки.КоличествоОстаток),
		|	СУММА(0),
		|	СУММА(-ЗанятыеРабочиеМестаОстатки.КоличествоОстаток)
		|ИЗ
		|	РегистрНакопления.ЗанятыеРабочиеМеста.Остатки(&ДатаАктуальности,";
		Если Подразделение <> Неопределено Тогда
		Запрос.Текст = Запрос.Текст + "
		|		Подразделение В ИЕРАРХИИ (&Подразделение)";
		КонецЕсли;
		Запрос.Текст = Запрос.Текст + "
		|		) КАК ЗанятыеРабочиеМестаОстатки
		|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.КадровыйПлан.СрезПоследних(
		|		&ДатаАктуальности,
		|		ПодразделениеОрганизации = ЗНАЧЕНИЕ(Справочник.ПодразделенияОрганизаций.ПустаяСсылка)";
		Если Подразделение <> Неопределено Тогда
		Запрос.Текст = Запрос.Текст + "
		|			И Подразделение В ИЕРАРХИИ (&Подразделение)";
		КонецЕсли;
		Запрос.Текст = Запрос.Текст + "
		|		) КАК КадровыйПланСрезПоследних
		|		ПО ЗанятыеРабочиеМестаОстатки.Подразделение = КадровыйПланСрезПоследних.Подразделение
		|			И ЗанятыеРабочиеМестаОстатки.Должность.Должность = КадровыйПланСрезПоследних.Должность
		|ГДЕ
		|	ЗанятыеРабочиеМестаОстатки.Должность.Должность <> ЗНАЧЕНИЕ(Справочник.Должности.ПустаяСсылка)
		|	И КадровыйПланСрезПоследних.Количество ЕСТЬ NULL 
		|
		|СГРУППИРОВАТЬ ПО
		|	ЗанятыеРабочиеМестаОстатки.Подразделение,
		|	ЗанятыеРабочиеМестаОстатки.Должность.Должность,
		|	ЗанятыеРабочиеМестаОстатки.Должность.Должность.Наименование
		|
		|УПОРЯДОЧИТЬ ПО
		|	ДолжностьНаименование";
		
	Иначе
		Запрос.Текст =
		"ВЫБРАТЬ
		|	КадровыйПлан.Регистратор.Дата КАК Период,
		|	КадровыйПлан.Подразделение КАК Подразделение,
		|	МАКСИМУМ(ВЫБОР
		|		КОГДА КадровыйПлан.Подразделение = &Подразделение
		|			ТОГДА ЛОЖЬ
		|		ИНАЧЕ ИСТИНА
		|	КОНЕЦ) КАК ЕстьИерархия,
		|	КадровыйПлан.Должность КАК Должность,
		|	КадровыйПлан.Должность.Наименование КАК ДолжностьНаименование,
		|	СУММА(КадровыйПлан.Количество) КАК Запланировано
		|ИЗ
		|	РегистрСведений.КадровыйПлан КАК КадровыйПлан
		|ГДЕ
		|	КадровыйПлан.ПодразделениеОрганизации = ЗНАЧЕНИЕ(Справочник.ПодразделенияОрганизаций.ПустаяСсылка)";
		Если Подразделение <> Неопределено Тогда
		Запрос.Текст = Запрос.Текст + "
		|	И КадровыйПлан.Подразделение В ИЕРАРХИИ (&Подразделение)";
		КонецЕсли;
		Запрос.Текст = Запрос.Текст + "
		|
		|СГРУППИРОВАТЬ ПО
		|	КадровыйПлан.Регистратор.Дата,
		|	КадровыйПлан.Подразделение,
		|	КадровыйПлан.Должность,
		|	КадровыйПлан.Должность.Наименование
		|
		|УПОРЯДОЧИТЬ ПО
		|	ДолжностьНаименование,
		|	Период";
		
	КонецЕсли;
	
	РабочиеМеста.Загрузить(Запрос.Выполнить().Выгрузить());
	
КонецПроцедуры

Процедура ОбновитьРабочиеМестаРегл(Организация, ПодразделениеОрганизации, Период = Неопределено) Экспорт
	
	Запрос = Новый Запрос;
	
	Запрос.УстановитьПараметр("Организация",				Организация);
	Запрос.УстановитьПараметр("ПодразделениеОрганизации",	ПодразделениеОрганизации);
	
	Если Период <> Неопределено Тогда
		Запрос.УстановитьПараметр("ДатаАктуальности",	Период);
		
		Запрос.Текст =
		"ВЫБРАТЬ
		|	КадровыйПланСрезПоследних.ПодразделениеОрганизации КАК Подразделение,
		|	МАКСИМУМ(ВЫБОР
		|		КОГДА КадровыйПланСрезПоследних.ПодразделениеОрганизации = &ПодразделениеОрганизации
		|			ТОГДА ЛОЖЬ
		|		ИНАЧЕ ИСТИНА
		|	КОНЕЦ) КАК ЕстьИерархия,
		|	КадровыйПланСрезПоследних.Должность КАК Должность,
		|	КадровыйПланСрезПоследних.Должность.Наименование КАК ДолжностьНаименование,
		|	СУММА(ЕСТЬNULL(ЗанятыеШтатныеЕдиницыОрганизацийОстатки.КоличествоСтавокОстаток, 0)) КАК Занято,
		|	СУММА(КадровыйПланСрезПоследних.Количество) КАК Запланировано,
		|	СУММА(КадровыйПланСрезПоследних.Количество - ЕСТЬNULL(ЗанятыеШтатныеЕдиницыОрганизацийОстатки.КоличествоСтавокОстаток, 0)) КАК Вакантно
		|ИЗ
		|	РегистрСведений.КадровыйПлан.СрезПоследних(
		|		&ДатаАктуальности,
		|		Подразделение = ЗНАЧЕНИЕ(Справочник.Подразделения.ПустаяСсылка)
		|			И ПодразделениеОрганизации.Владелец = &Организация";
		Если ПодразделениеОрганизации <> Неопределено Тогда
		Запрос.Текст = Запрос.Текст + "
		|			И ПодразделениеОрганизации В ИЕРАРХИИ (&ПодразделениеОрганизации)";
		КонецЕсли;
		Запрос.Текст = Запрос.Текст + "
		|		) КАК КадровыйПланСрезПоследних
		|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрНакопления.ЗанятыеШтатныеЕдиницыОрганизаций.Остатки(&ДатаАктуальности,
		|			ПодразделениеОрганизации.Владелец = &Организация";
		Если ПодразделениеОрганизации <> Неопределено Тогда
		Запрос.Текст = Запрос.Текст + "
		|				И ПодразделениеОрганизации В ИЕРАРХИИ (&ПодразделениеОрганизации)";
		КонецЕсли;
		Запрос.Текст = Запрос.Текст + "
		|			) КАК ЗанятыеШтатныеЕдиницыОрганизацийОстатки
		|		ПО КадровыйПланСрезПоследних.ПодразделениеОрганизации = ЗанятыеШтатныеЕдиницыОрганизацийОстатки.ПодразделениеОрганизации
		|			И КадровыйПланСрезПоследних.Должность = ЗанятыеШтатныеЕдиницыОрганизацийОстатки.Должность.Должность
		|
		|СГРУППИРОВАТЬ ПО
		|	КадровыйПланСрезПоследних.ПодразделениеОрганизации,
		|	КадровыйПланСрезПоследних.Должность,
		|	КадровыйПланСрезПоследних.Должность.Наименование
		|
		|ОБЪЕДИНИТЬ
		|
		|ВЫБРАТЬ
		|	ЗанятыеШтатныеЕдиницыОрганизацийОстатки.ПодразделениеОрганизации КАК Подразделение,
		|	МАКСИМУМ(ВЫБОР
		|		КОГДА ЗанятыеШтатныеЕдиницыОрганизацийОстатки.ПодразделениеОрганизации = &ПодразделениеОрганизации
		|			ТОГДА ЛОЖЬ
		|		ИНАЧЕ ИСТИНА
		|	КОНЕЦ) КАК ЕстьИерархия,
		|	ЗанятыеШтатныеЕдиницыОрганизацийОстатки.Должность.Должность,
		|	ЗанятыеШтатныеЕдиницыОрганизацийОстатки.Должность.Должность.Наименование,
		|	СУММА(ЗанятыеШтатныеЕдиницыОрганизацийОстатки.КоличествоСтавокОстаток),
		|	СУММА(0),
		|	СУММА(-ЗанятыеШтатныеЕдиницыОрганизацийОстатки.КоличествоСтавокОстаток)
		|ИЗ
		|	РегистрНакопления.ЗанятыеШтатныеЕдиницыОрганизаций.Остатки(&ДатаАктуальности,
		|		ПодразделениеОрганизации.Владелец = &Организация";
		Если ПодразделениеОрганизации <> Неопределено Тогда
		Запрос.Текст = Запрос.Текст + "
		|			И ПодразделениеОрганизации В ИЕРАРХИИ (&ПодразделениеОрганизации)";
		КонецЕсли;
		Запрос.Текст = Запрос.Текст + "
		|		) КАК ЗанятыеШтатныеЕдиницыОрганизацийОстатки
		|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.КадровыйПлан.СрезПоследних(
		|		&ДатаАктуальности,
		|		Подразделение = ЗНАЧЕНИЕ(Справочник.Подразделения.ПустаяСсылка)
		|			И ПодразделениеОрганизации.Владелец = &Организация";
		Если ПодразделениеОрганизации <> Неопределено Тогда
		Запрос.Текст = Запрос.Текст + "
		|			И ПодразделениеОрганизации В ИЕРАРХИИ (&ПодразделениеОрганизации)";
		КонецЕсли;
		Запрос.Текст = Запрос.Текст + "
		|		) КАК КадровыйПланСрезПоследних
		|		ПО КадровыйПланСрезПоследних.ПодразделениеОрганизации = ЗанятыеШтатныеЕдиницыОрганизацийОстатки.ПодразделениеОрганизации
		|			И КадровыйПланСрезПоследних.Должность = ЗанятыеШтатныеЕдиницыОрганизацийОстатки.Должность.Должность
		|ГДЕ
		|	ЗанятыеШтатныеЕдиницыОрганизацийОстатки.Должность.Должность <> ЗНАЧЕНИЕ(Справочник.Должности.ПустаяСсылка)
		|	И КадровыйПланСрезПоследних.Количество ЕСТЬ NULL 
		|
		|СГРУППИРОВАТЬ ПО
		|	ЗанятыеШтатныеЕдиницыОрганизацийОстатки.ПодразделениеОрганизации,
		|	ЗанятыеШтатныеЕдиницыОрганизацийОстатки.Должность.Должность,
		|	ЗанятыеШтатныеЕдиницыОрганизацийОстатки.Должность.Должность.Наименование
		|
		|УПОРЯДОЧИТЬ ПО
		|	ДолжностьНаименование";
		
	Иначе
		Запрос.Текст =
		"ВЫБРАТЬ
		|	КадровыйПлан.Регистратор.Дата КАК Период,
		|	КадровыйПлан.ПодразделениеОрганизации КАК Подразделение,
		|	МАКСИМУМ(ВЫБОР
		|		КОГДА КадровыйПлан.ПодразделениеОрганизации = &ПодразделениеОрганизации
		|			ТОГДА ЛОЖЬ
		|		ИНАЧЕ ИСТИНА
		|	КОНЕЦ) КАК ЕстьИерархия,
		|	КадровыйПлан.Должность КАК Должность,
		|	КадровыйПлан.Должность.Наименование КАК ДолжностьНаименование,
		|	СУММА(КадровыйПлан.Количество) КАК Запланировано
		|ИЗ
		|	РегистрСведений.КадровыйПлан КАК КадровыйПлан
		|ГДЕ
		|	КадровыйПлан.Подразделение = ЗНАЧЕНИЕ(Справочник.Подразделения.ПустаяСсылка)
		|	И КадровыйПлан.ПодразделениеОрганизации.Владелец = &Организация";
		Если ПодразделениеОрганизации <> Неопределено Тогда
		Запрос.Текст = Запрос.Текст + "
		|	И КадровыйПлан.ПодразделениеОрганизации В ИЕРАРХИИ (&ПодразделениеОрганизации)";
		КонецЕсли;
		Запрос.Текст = Запрос.Текст + "
		|
		|СГРУППИРОВАТЬ ПО
		|	КадровыйПлан.Регистратор.Дата,
		|	КадровыйПлан.ПодразделениеОрганизации,
		|	КадровыйПлан.Должность,
		|	КадровыйПлан.Должность.Наименование
		|
		|УПОРЯДОЧИТЬ ПО
		|	ДолжностьНаименование,
		|	Период";
		
	КонецЕсли;
	
	РабочиеМеста.Загрузить(Запрос.Выполнить().Выгрузить());
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// ОПЕРАТОРЫ ОСНОВНОЙ ПРОГРАММЫ
