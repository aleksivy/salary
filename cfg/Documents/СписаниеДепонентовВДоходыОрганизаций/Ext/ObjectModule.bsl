////////////////////////////////////////////////////////////////////////////////
// ВСПОМОГАТЕЛЬНЫЕ ПРОЦЕДУРЫ И ФУНКЦИИ
Процедура АвтозаполнениеСписаниеДепонента() Экспорт 
	// Заполнение ТЧ Зарплата и Работники
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("парамДата",	Дата);
	Запрос.УстановитьПараметр("парамНачало", СписаниеДепонентаНаДату);
	Запрос.УстановитьПараметр("парамОрганизация", Организация);
	
	ТекстЗапроса = 
	"ВЫБРАТЬ
	|	Взаиморасчеты.Сотрудник			КАК Сотрудник,
	|	Взаиморасчеты.Ведомость			КАК Ведомость,
	|	Взаиморасчеты.СуммаОстаток		КАК Сумма
	|ИЗ
	|	РегистрНакопления.ВзаиморасчетыСДепонентамиОрганизаций.Остатки( &парамДата,
	|			Организация = &парамОрганизация	И	Ведомость.ПериодРегистрации <= &парамНачало
	|    ) КАК Взаиморасчеты
	|";
	
	Запрос.Текст = ТекстЗапроса;
	Работники.Загрузить( Запрос.Выполнить().Выгрузить() );
	
КонецПроцедуры // Автозаполнение_ОсновнаяВыплата()



////////////////////////////////////////////////////////////////////////////////
// ПРОЦЕДУРЫ И ФУНКЦИИ ДЛЯ ОБЕСПЕЧЕНИЯ ПРОВЕДЕНИЯ ДОКУМЕНТА

Функция СформироватьЗапросПоШапке()

	Запрос = Новый Запрос;

	// Установим параметры запроса
	Запрос.УстановитьПараметр("ДокументСсылка" , Ссылка);
	Запрос.УстановитьПараметр("ПустаяОрганизация" , Справочники.Организации.ПустаяСсылка());
	Запрос.УстановитьПараметр("Задепонировано", Перечисления.ВыплаченностьЗарплаты.Задепонировано);

	ТекстЗапроса = 
	"ВЫБРАТЬ
	|	Депонирование.Дата,
	|	Депонирование.Ссылка,
	|	Депонирование.Организация,
	|	ВЫБОР
	|		КОГДА Депонирование.Организация.ГоловнаяОрганизация = &ПустаяОрганизация
	|			ТОГДА Депонирование.Организация
	|		ИНАЧЕ Депонирование.Организация.ГоловнаяОрганизация
	|	КОНЕЦ КАК ГоловнаяОрганизация
	|ИЗ
	|	Документ.СписаниеДепонентовВДоходыОрганизаций КАК Депонирование
	|ГДЕ
	|	Депонирование.Ссылка = &ДокументСсылка";

	Запрос.Текст = ТекстЗапроса;
	Возврат Запрос.Выполнить();

КонецФункции // СформироватьЗапросПоШапке()

Процедура ПроверитьЗаполнениеШапки(ВыборкаПоШапкеДокумента, Отказ, Заголовок)

	Если НЕ ЗначениеЗаполнено(ВыборкаПоШапкеДокумента.Организация) Тогда
		ОбщегоНазначения.СообщитьОбОшибке(НСтр("ru='Не указана организация!';uk='Не зазначена організація!'"), Отказ, Заголовок);
	КонецЕсли;
	
КонецПроцедуры // ПроверитьЗаполнениеШапки()

// Процедура выполняет движение по регистру ВзаиморасчетыСДепонентамиОрганизаций  и проводки по Бухгалтерскому учету
//
Процедура ВыполнитьДвиженияПоСписаниюЗарплаты()

	Запрос=Новый Запрос;
	Запрос.УстановитьПараметр("Ссылка", Ссылка); 
	
	ТекстЗапроса = "
	|ВЫБРАТЬ
	|	Депоненты.Ссылка.Организация	КАК Организация,
	|	Депоненты.Ссылка.Дата			КАК Период,
	|	Депоненты.Сотрудник				КАК Сотрудник,
	|	Депоненты.Ведомость				КАК Ведомость,
	|	Депоненты.Сумма					КАК Сумма
	|        
	|ИЗ	Документ.СписаниеДепонентовВДоходыОрганизаций.Работники КАК Депоненты
	|
	|ГДЕ Депоненты.Ссылка = &Ссылка
	|
	|";
	
	
	Запрос.Текст = ТекстЗапроса;
	
	Выборка = Запрос.Выполнить().Выбрать();
	Пока Выборка.Следующий() Цикл
		
		// 1. ВзаиморасчетыСДепонентамиОрганизаций
		НоваяСтрока = Движения.ВзаиморасчетыСДепонентамиОрганизаций.Добавить();
		ЗаполнитьЗначенияСвойств(НоваяСтрока, Выборка);
		НоваяСтрока.ВидДвижения	= ВидДвиженияНакопления.Расход;
		
		

	КонецЦикла;
	
КонецПроцедуры // ВыполнитьДвиженияПоСписаниюЗарплаты()



////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ

Процедура ПередЗаписью(Отказ, РежимЗаписи, РежимПроведения)
	
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;

	// Посчитать суммы документа и записать ее в соответствующий реквизит шапки для показа в журналах
	СуммаДокумента = Работники.Итог("Сумма");
	КраткийСоставДокумента = ПроцедурыУправленияПерсоналом.ЗаполнитьКраткийСоставДокумента(Работники,, "Сотрудник");
	ПроцедурыУправленияПерсоналом.ЗаполнитьФизЛицоПоТЧ(Работники);

КонецПроцедуры // ПередЗаписью

Процедура ОбработкаПроведения(Отказ, Режим)

	// Заголовок для сообщений об ошибках проведения.
	Заголовок = ОбщегоНазначения.ПредставлениеДокументаПриПроведении(Ссылка);
	
	// Получим реквизиты шапки из запроса
	ВыборкаПоШапкеДокумента = СформироватьЗапросПоШапке().Выбрать();
	
	Если ВыборкаПоШапкеДокумента.Следующий() Тогда
		
		//Надо позвать проверку заполнения реквизитов шапки
		ПроверитьЗаполнениеШапки(ВыборкаПоШапкеДокумента, Отказ, Заголовок);
		
		Если НЕ Отказ Тогда

			ВыполнитьДвиженияПоСписаниюЗарплаты();
								
		КонецЕсли; 
	КонецЕсли;
	
КонецПроцедуры

Функция ЗаполнитьДокументПоВедомости(Ведомость) Экспорт
	// Заполнение ТЧ Зарплата и Работники
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("парамДата",	Дата);
	Запрос.УстановитьПараметр("парамНачало", СписаниеДепонентаНаДату);
	Запрос.УстановитьПараметр("парамОрганизация", Организация);
	Запрос.УстановитьПараметр("Ведомость", Ведомость);
	
	ТекстЗапроса = 
	"ВЫБРАТЬ
	|	Взаиморасчеты.Сотрудник			КАК Сотрудник,
	|	Взаиморасчеты.Ведомость			КАК Ведомость,
	|	Взаиморасчеты.СуммаОстаток		КАК Сумма
	|ИЗ
	|	РегистрНакопления.ВзаиморасчетыСДепонентамиОрганизаций.Остатки( &парамДата,
	|			Организация = &парамОрганизация	И	Ведомость.ПериодРегистрации <= &парамНачало И Ведомость= &Ведомость
	|    ) КАК Взаиморасчеты
	|";
	
	Запрос.Текст = ТекстЗапроса;
    Возврат Запрос.Выполнить();
	
КонецФункции

Процедура ОбработкаЗаполнения(Основание)
	Если ТипЗнч(Основание) = Тип("ДокументСсылка.ЗарплатаКВыплатеОрганизаций") Тогда
		ЗаполнениеДокументов.ЗаполнитьШапкуДокументаПоОснованию(ЭтотОбъект, Основание);
		СписаниеДепонентаНаДату = ДобавитьМесяц(КонецМесяца(Основание.ПериодРегистрации), 36); 
		Результат = ЗаполнитьДокументПоВедомости(Основание);
		Работники.Загрузить(Результат.Выгрузить() );

	КонецЕсли;
КонецПроцедуры;

