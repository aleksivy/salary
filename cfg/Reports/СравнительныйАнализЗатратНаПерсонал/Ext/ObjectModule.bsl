Перем СохраненнаяНастройка Экспорт;
Перем Расшифровки Экспорт;
Перем ЭлементОтбора Экспорт;

#Если Клиент ИЛИ ВнешнееСоединение Тогда
	
	
// Формирует текст отбора данных по строке ТЧ "ТаблицаСценарии"
//
// Параметры
//  СтрокаСценарий( строка табличной части): строка ТЧ "ТаблицаСценарии", для которой
// 	формируется текст запроса;
// СтруктураПараметров (структура): структура, в которой хранятся згачения параметров для 
//	основного запроса
// Возвращаемое значение:
//   ТекстЗапроса(текст)- текст отбора данных по строке ТЧ "ТаблицаСценарии"
//
Функция ТекстЗапросаПоСценарию(СтрокаСценарий, Номер, СтруктураПараметров, Эталон, ДатаНачалаЭталон, ДатаКонецЭталон, ТекстПолей)
	
	ПериодДанных=ОбщегоНазначения.ПолучитьИмяЭлементаПеречисленияПоЗначению(Периодичность);
	
	Если СтрокаСценарий.ВидДанных=Перечисления.ВидыДанныхДляПланФактногоАнализаЗатратНаПерсонал.Сценарий Тогда
		
		ТекстЗапроса =
		"	
		|	ОБЪЕДИНИТЬ ВСЕ
		|		ВЫБРАТЬ
		|			НАЧАЛОПЕРИОДА(ПланДвижения.Период, "+ПериодДанных+") КАК Период,
		|			ПланДвижения.Сценарий КАК Сценарий,
		|			ПланДвижения.Подразделение КАК Подразделение,
		|			ПланДвижения.СтатьяЗатрат КАК СтатьяЗатрат,
		|			&ПараметрВидДанных_"+Номер+" КАК ПредставлениеСценария,
		|			&ПараметрНомерСценария_"+Номер+" КАК Порядок,
		|			СУММА(ПланДвижения.Сумма * (ЕСТЬNULL(РеглКурсДвижения.Курс, 1) / ЕСТЬNULL(РеглКурсДвижения.Кратность, 1)) / (ЕСТЬNULL(РеглКурс.Курс, 1) / ЕСТЬNULL(РеглКурс.Кратность, 1))) КАК СуммаРегл,
		|			СУММА(ПланДвижения.Сумма * (УпрКурсДвижения.Курс / УпрКурсДвижения.Кратность) / (УпрКурс.Курс / УпрКурс.Кратность)) КАК СуммаУпр,
		|			0 Как АбсОтклонениеРегл,
		|			0 Как АбсОтклонениеУпр,
		|			0 Как Обработана		
		|		ИЗ
		|			РегистрНакопления.ПланируемыеЗатратыНаПерсонал КАК ПланДвижения
		|				ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.КурсыВалютДляРасчетовСПерсоналом КАК УпрКурс
		|				ПО (УпрКурс.Валюта = &ВалютаУпрУчета И УпрКурс.Период = НАЧАЛОПЕРИОДА(ПланДвижения.Период, МЕСЯЦ))
		|				ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.КурсыВалютДляРасчетовСПерсоналом.СрезПоследних(&ДатаКон_"+Номер+") КАК РеглКурс
		|				ПО (РеглКурс.Валюта = &ВалютаРеглУчета)
		|				ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.КурсыВалютДляРасчетовСПерсоналом КАК УпрКурсДвижения
		|				ПО (УпрКурсДвижения.Валюта = ПланДвижения.Валюта И УпрКурсДвижения.Период = НАЧАЛОПЕРИОДА(ПланДвижения.Период, МЕСЯЦ))
		|				ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.КурсыВалютДляРасчетовСПерсоналом КАК РеглКурсДвижения
		|				ПО (РеглКурсДвижения.Валюта = ПланДвижения.Валюта И РеглКурсДвижения.Период = НАЧАЛОПЕРИОДА(ПланДвижения.Период, МЕСЯЦ))
		
		|		ГДЕ
		|			ПланДвижения.Период МЕЖДУ &ДатаНач_"+Номер+" И &ДатаКон_"+Номер+"
		|			И ПланДвижения.Сценарий = &Сценарий_"+Номер+"
		|			И ВЫБОР КОГДА ПланДвижения.Подразделение ССЫЛКА Справочник.Подразделения ТОГДА ИСТИНА ИНАЧЕ ЛОЖЬ КОНЕЦ = &Учет";
		Если Эталон <> СтрокаСценарий.Сценарий тогда 
		ТекстЗапроса = ТекстЗапроса +
		"	
		|			И ПланДвижения.Подразделение В (ВЫБРАТЬ ПланДвижения.Подразделение ИЗ РегистрНакопления.ПланируемыеЗатратыНаПерсонал КАК ПланДвижения ГДЕ ПланДвижения.Период МЕЖДУ &НачалоПериодаЭталон И &КонецПериодаЭталон И ПланДвижения.Сценарий = &Эталон)
		|			И ПланДвижения.СтатьяЗатрат В (ВЫБРАТЬ ПланДвижения.СтатьяЗатрат ИЗ РегистрНакопления.ПланируемыеЗатратыНаПерсонал КАК ПланДвижения ГДЕ ПланДвижения.ПЕриод МЕЖДУ &НачалоПериодаЭталон И &КонецПериодаЭталон И ПланДвижения.Сценарий = &Эталон)";
		КонецЕсли;
		ТекстЗапроса = ТекстЗапроса +
		"	
		|		
		|		СГРУППИРОВАТЬ ПО
		|			НАЧАЛОПЕРИОДА(ПланДвижения.Период, "+ПериодДанных+"),
		|			ПланДвижения.Сценарий,
		|			ПланДвижения.Подразделение,
		|			ПланДвижения.СтатьяЗатрат";
	
	ИначеЕсли СтрокаСценарий.ВидДанных=Перечисления.ВидыДанныхДляПланФактногоАнализаЗатратНаПерсонал.ФактическиеДанные Тогда
		
		ТекстЗапроса =
		"	
		|	ОБЪЕДИНИТЬ ВСЕ
		|		ВЫБРАТЬ
		|			ОтражениеВУчете.Период,
		|			ЗНАЧЕНИЕ(Справочник.СценарииПланирования.ПустаяССылка) КАК Сценарий, 	
		|			ОтражениеВУчете.Подразделение,
		|			ОтражениеВУчете.СтатьяЗатрат,
		|			&ПараметрВидДанных_"+Номер+" КАК ПредставлениеСценария,
		|			&ПараметрНомерСценария_"+Номер+" КАК Порядок,
		|			СУММА(ОтражениеВУчете.СуммаРегл) КАК СуммаРегл,
		|			СУММА(ОтражениеВУчете.СуммаУпр) КАК СуммаУпр,
		|			0 Как АбсОтклонениеРегл,
		|			0 Как АбсОтклонениеУпр,
		|			0 Как Обработана
		|		ИЗ
		|			(ВЫБРАТЬ
		|				НАЧАЛОПЕРИОДА(ОтражениеЗарплатыВУпрУчетеОтражениеВУчете.Ссылка.ПериодРегистрации, "+ПериодДанных+") КАК Период,
		|				ОтражениеЗарплатыВУпрУчетеОтражениеВУчете.Подразделение КАК Подразделение,
		|				ОтражениеЗарплатыВУпрУчетеОтражениеВУчете.СтатьяЗатрат КАК СтатьяЗатрат,
		|				ОтражениеЗарплатыВУпрУчетеОтражениеВУчете.Сумма * (УпрКурс.Курс / УпрКурс.Кратность) / (ЕСТЬNULL(РеглКурс.Курс, 1) / ЕСТЬNULL(РеглКурс.Кратность, 1)) КАК СуммаРегл,
		|				ОтражениеЗарплатыВУпрУчетеОтражениеВУчете.Сумма КАК СуммаУпр
		|			ИЗ
		|				Документ.ОтражениеЗарплатыВУпрУчете.ОтражениеВУчете КАК ОтражениеЗарплатыВУпрУчетеОтражениеВУчете
		|					ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.КурсыВалютДляРасчетовСПерсоналом КАК УпрКурс
		|					ПО (УпрКурс.Валюта = &ВалютаУпрУчета И УпрКурс.Период = НАЧАЛОПЕРИОДА(ОтражениеЗарплатыВУпрУчетеОтражениеВУчете.Ссылка.ПериодРегистрации, МЕСЯЦ))
		|					ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.КурсыВалютДляРасчетовСПерсоналом.СрезПоследних(&ДатаКон_"+Номер+") КАК РеглКурс
		|					ПО (РеглКурс.Валюта = &ВалютаРеглУчета)
		|			ГДЕ
		|				ОтражениеЗарплатыВУпрУчетеОтражениеВУчете.Ссылка.ПериодРегистрации МЕЖДУ &ДатаНач_"+Номер+" И &ДатаКон_"+Номер+"
		|				И (НЕ ОтражениеЗарплатыВУпрУчетеОтражениеВУчете.Ссылка.ПометкаУдаления)
		|			
		|			ОБЪЕДИНИТЬ
		|			
		|			ВЫБРАТЬ
		|				НАЧАЛОПЕРИОДА(ОтражениеЗарплатыВРеглУчетеОтражениеВУчете.Ссылка.ПериодРегистрации, "+ПериодДанных+"),
		|				ВЫБОР
		|					КОГДА ОтражениеЗарплатыВРеглУчетеОтражениеВУчете.СубконтоДт1 ССЫЛКА Справочник.ПодразделенияОрганизаций
		|						ТОГДА ОтражениеЗарплатыВРеглУчетеОтражениеВУчете.СубконтоДт1
		|					КОГДА ОтражениеЗарплатыВРеглУчетеОтражениеВУчете.СубконтоДт2 ССЫЛКА Справочник.ПодразделенияОрганизаций
		|						ТОГДА ОтражениеЗарплатыВРеглУчетеОтражениеВУчете.СубконтоДт2
		|					КОГДА ОтражениеЗарплатыВРеглУчетеОтражениеВУчете.СубконтоДт3 ССЫЛКА Справочник.ПодразделенияОрганизаций
		|						ТОГДА ОтражениеЗарплатыВРеглУчетеОтражениеВУчете.СубконтоДт3
		|					ИНАЧЕ ЗНАЧЕНИЕ(Справочник.ПодразделенияОрганизаций.ПустаяСсылка)
		|				КОНЕЦ,
		|				ВЫБОР
		|					КОГДА ОтражениеЗарплатыВРеглУчетеОтражениеВУчете.СубконтоДт1 ССЫЛКА Справочник.СтатьиЗатрат
		|						ТОГДА ОтражениеЗарплатыВРеглУчетеОтражениеВУчете.СубконтоДт1
		|					КОГДА ОтражениеЗарплатыВРеглУчетеОтражениеВУчете.СубконтоДт2 ССЫЛКА Справочник.СтатьиЗатрат
		|						ТОГДА ОтражениеЗарплатыВРеглУчетеОтражениеВУчете.СубконтоДт2
		|					КОГДА ОтражениеЗарплатыВРеглУчетеОтражениеВУчете.СубконтоДт3 ССЫЛКА Справочник.СтатьиЗатрат
		|						ТОГДА ОтражениеЗарплатыВРеглУчетеОтражениеВУчете.СубконтоДт3
		|					ИНАЧЕ ЗНАЧЕНИЕ(Справочник.СтатьиЗатрат.ПустаяСсылка)
		|				КОНЕЦ,
		|				ОтражениеЗарплатыВРеглУчетеОтражениеВУчете.Сумма,
		|				ОтражениеЗарплатыВРеглУчетеОтражениеВУчете.Сумма * (ЕСТЬNULL(РеглКурс.Курс, 1) / ЕСТЬNULL(РеглКурс.Кратность, 1)) / (УпрКурс.Курс / УпрКурс.Кратность)
		|			ИЗ
		|				Документ.ОтражениеЗарплатыВРеглУчете.ОтражениеВУчете КАК ОтражениеЗарплатыВРеглУчетеОтражениеВУчете
		|					ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.КурсыВалютДляРасчетовСПерсоналом КАК УпрКурс
		|					ПО (УпрКурс.Валюта = &ВалютаУпрУчета И УпрКурс.Период = НАЧАЛОПЕРИОДА(ОтражениеЗарплатыВРеглУчетеОтражениеВУчете.Ссылка.ПериодРегистрации, МЕСЯЦ))
		|					ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.КурсыВалютДляРасчетовСПерсоналом.СрезПоследних(&ДатаКон_"+Номер+") КАК РеглКурс
		|					ПО (РеглКурс.Валюта = &ВалютаРеглУчета)
		|			ГДЕ
		|				ОтражениеЗарплатыВРеглУчетеОтражениеВУчете.Ссылка.ПериодРегистрации МЕЖДУ &ДатаНач_"+Номер+" И &ДатаКон_"+Номер+"
		|				И ОтражениеЗарплатыВРеглУчетеОтражениеВУчете.Ссылка.Проведен
		|				И НЕ (ОтражениеЗарплатыВРеглУчетеОтражениеВУчете.СчетДт В ИЕРАРХИИ (ЗНАЧЕНИЕ(ПланСчетов.Хозрасчетный.РасчетыПоОплатеТруда), ЗНАЧЕНИЕ(ПланСчетов.Хозрасчетный.РасчетыПоНалогам), ЗНАЧЕНИЕ(ПланСчетов.Хозрасчетный.РасчетыПоСтрахованию)))
		|			) КАК ОтражениеВУчете
		|		ГДЕ
		|			ВЫБОР КОГДА ОтражениеВУчете.Подразделение ССЫЛКА Справочник.Подразделения ТОГДА ИСТИНА ИНАЧЕ ЛОЖЬ КОНЕЦ = &Учет";
		Если НЕ Эталон.Пустая() тогда 
		ТекстЗапроса = ТекстЗапроса +
		"	
		|			И (" + СтрЗаменить(ТекстПолей, "<ВыбираемыйРегистр>", "ОтражениеВУчете")+ ") В
		|					(ВЫБРАТЬ
		|						" + СтрЗаменить(ТекстПолей, "<ВыбираемыйРегистр>", "ПланДвижения")+ "
		|					ИЗ
		|						РегистрНакопления.ПланируемыеЗатратыНаПерсонал КАК ПланДвижения
		|					ГДЕ
		|						ПланДвижения.Период МЕЖДУ &НачалоПериодаЭталон И &КонецПериодаЭталон
		|						И ПланДвижения.Сценарий = &Эталон)";
		КонецЕсли;
		ТекстЗапроса = ТекстЗапроса +
		"	
		|		
		|		СГРУППИРОВАТЬ ПО
		|			ОтражениеВУчете.Период,
		|			ОтражениеВУчете.Подразделение,
		|			ОтражениеВУчете.СтатьяЗатрат";
		
	КонецЕсли;
	
	СтруктураПараметров.Вставить("ДатаНач_"+Номер,				 СтрокаСценарий.НачалоПериода);
	СтруктураПараметров.Вставить("ДатаКон_"+Номер,				 КонецДня(СтрокаСценарий.КонецПериода));
	СтруктураПараметров.Вставить("Сценарий_"+Номер,				 СтрокаСценарий.Сценарий);
	СтруктураПараметров.Вставить("ПараметрНомерСценария_"+Номер, Номер);
	СтруктураПараметров.Вставить("ПараметрВидДанных_"+Номер,	 СтрокаСценарий.НазваниеКолонки);
	
	Возврат ТекстЗапроса;
КонецФункции // ТекстЗапросаПоСценарию()
	
	
Функция СформироватьОтчет(Результат = Неопределено, ДанныеРасшифровки = Неопределено, ВыводВФормуОтчета = Истина) Экспорт
	
	КодЯзыка = ЛокализацияПовтИсп.ПолучитьЯзыкФормированияПечатныхФормОтчетов();
	
	Если Сценарии.Количество() = 0 тогда
		Возврат Неопределено;
	КонецЕсли;
	
	Эталон     = Сценарии[0].Сценарий;
	ДатаНачала = Сценарии[0].НачалоПериода;
	ДатаКонец  = Сценарии[0].КонецПериода;
	
	НеправильноВведено = ложь;
	Для каждого СтрокаТаблицыСценария из Сценарии Цикл
		Если СтрокаТаблицыСценария.НачалоПериода > СтрокаТаблицыСценария.КонецПериода ИЛИ СтрокаТаблицыСценария.КонецПериода = '00010101' ИЛИ СтрокаТаблицыСценария.НачалоПериода = '00010101' тогда
			Сообщить(Строка(?(СтрокаТаблицыСценария.Сценарий = Справочники.СценарииПланирования.ПустаяСсылка(),НСтр("ru='Фактические данные';uk='Фактичні дані'"), СтрокаТаблицыСценария.Сценарий)) + НСтр("ru=':Не павильно задан период.';uk=':Не павильно заданий період.'"));
			НеправильноВведено = Истина;
			Продолжить;
		КонецЕсли;
		
		// перепишем заголовок во всех строках
		Номер        = СтрокаТаблицыСценария.НомерСтроки;
		СтрокаПериод = НСтр("ru='Период : ';uk='Період : '" ,КодЯзыка) + ПредставлениеПериода(СтрокаТаблицыСценария.НачалоПериода, СтрокаТаблицыСценария.КонецПериода);
		Если СтрокаТаблицыСценария.Сценарий.Пустая() Тогда
			СтрокаТаблицыСценария.НазваниеКолонки = ?(Номер = 1,НСтр("ru='Эталонный период.';uk='Еталонний період.'" ,КодЯзыка),НСтр("ru='Сравниваемый период ';uk='Період, що порівнюється '" ,КодЯзыка) + Номер + ".")
			+ Символы.ПС + НСтр("ru='Фактические данные.';uk='Фактичні дані.'" ,КодЯзыка) + НСтр("ru=' Нет периода.';uk=' Немає періоду.'" ,КодЯзыка) + Символы.ПС + СтрокаПериод;
		Иначе
			ПериодДанных = СтрокаТаблицыСценария.Сценарий.Периодичность;
			СтрокаТаблицыСценария.НазваниеКолонки = ?(Номер = 1,НСтр("ru='Эталонный период.';uk='Еталонний період.'" ,КодЯзыка),НСтр("ru='Сравниваемый период ';uk='Період, що порівнюється '" ,КодЯзыка) + Номер + ".")
			+ Символы.ПС + СтрокаТаблицыСценария.Сценарий + " " + Локализация.ПолучитьЛокализованныйСинонимОбъекта(ПериодДанных,КодЯзыка) + "." + Символы.ПС+СтрокаПериод;
		КонецЕсли;
	КонецЦикла;
	Если НеправильноВведено тогда
		Возврат Результат;
	КонецЕсли;
		
	Если КомпоновщикНастроек.Настройки.Структура.Количество() > 0 И ТипЗнч(КомпоновщикНастроек.Настройки.Структура[0]) = Тип("ТаблицаКомпоновкиДанных") И КомпоновщикНастроек.Настройки.Структура[0].Строки.Количество() > 0 тогда
		Группировки = ТиповыеОтчеты.ПолучитьМассивГруппировок(КомпоновщикНастроек.Настройки.Структура[0].Строки[0], КомпоновщикНастроек);
	ИначеЕсли КомпоновщикНастроек.Настройки.Структура.Количество() > 0 И ТипЗнч(КомпоновщикНастроек.Настройки.Структура[0]) = Тип("ДиаграммаКомпоновкиДанных")
		    И (КомпоновщикНастроек.Настройки.Структура[0].Серии.Количество() > 0 ИЛИ КомпоновщикНастроек.Настройки.Структура[0].Точки.Количество() > 0) тогда
		Группировки = ТиповыеОтчеты.ПолучитьМассивГруппировок(КомпоновщикНастроек.Настройки.Структура[0].Серии[0], КомпоновщикНастроек);
		Группировки = ТиповыеОтчеты.ПолучитьМассивГруппировок(КомпоновщикНастроек.Настройки.Структура[0].Серии[0], КомпоновщикНастроек, Группировки);
	ИначеЕсли КомпоновщикНастроек.Настройки.Структура.Количество() > 0 И ТипЗнч(КомпоновщикНастроек.Настройки.Структура[0]) = Тип("ГруппировкаТаблицыКомпоновкиДанных") тогда
		Группировки = ТиповыеОтчеты.ПолучитьМассивГруппировок(КомпоновщикНастроек.Настройки.Структура[0].Строки[0], КомпоновщикНастроек);
	Иначе 
		Возврат Результат;
	КонецЕсли;
	
	ТекстПоле = "";
	
	Для каждого Поле из Группировки Цикл
		Если Поле = НСтр("ru='Подразделение';uk='Підрозділ'" ,КодЯзыка) тогда
			ТекстПоле = ТекстПоле + "<ВыбираемыйРегистр>.Подразделение, ";
			//Прервать;
		ИначеЕсли Поле = НСтр("ru='Статья затрат';uk='Стаття витрат'" ,КодЯзыка) тогда
			ТекстПоле = ТекстПоле + "<ВыбираемыйРегистр>.СтатьяЗатрат, ";
			//Прервать;
		КонецЕсли;
	КонецЦикла;
	
	ТекстПоле = Лев(ТекстПоле, СтрДлина(ТекстПоле)-2);
	
	ТекстЗапросаСценарии = "";
	
	Номер=0;
	
	СтруктураПараметров = Новый Структура;
	
	Для каждого СтрокаСценарий Из Сценарии Цикл
		ТекстЗапросаСценарии = ТекстЗапросаСценарии + ТекстЗапросаПоСценарию(СтрокаСценарий, Номер, СтруктураПараметров, Эталон, ДатаНачала, ДатаКонец, ТекстПоле);
		Номер = Номер + 1;
	КонецЦикла;
	
	НомерПервойВыборки   = Найти(ТекстЗапросаСценарии, "ВЫБРАТЬ");
	ТекстЗапросаСценарии = Прав(ТекстЗапросаСценарии, СтрДлина(ТекстЗапросаСценарии) - НомерПервойВыборки + 1);
	
	Запрос =  Новый Запрос(ТекстЗапросаСценарии);
	Для Каждого Параметр Из СтруктураПараметров Цикл
		Запрос.УстановитьПараметр(Параметр.Ключ,Параметр.Значение);
	КонецЦикла;
	Запрос.УстановитьПараметр("ВалютаРеглУчета", Константы.ВалютаРегламентированногоУчета.Получить());
	Запрос.УстановитьПараметр("ВалютаУпрУчета",  Константы.ВалютаУправленческогоУчета.Получить());
	
	Запрос.УстановитьПараметр("Эталон",              Эталон);
	Запрос.УстановитьПараметр("НачалоПериодаЭталон", ДатаНачала);
	Запрос.УстановитьПараметр("КонецПериодаЭталон",  ДатаКонец);
	Запрос.УстановитьПараметр("Учет",  ?(РежимФормированияОтчета = "ПоЦентрамОтветственности", истина, ложь));
	
	ТаблицаДанных = Запрос.Выполнить().Выгрузить();
	СписокСценарии = Сценарии.Выгрузить();
	СписокСценарии.Удалить(0);
	СтрокиЭталона = ТаблицаДанных.НайтиСтроки(Новый Структура("Сценарий", Эталон));
	Для каждого СтрокаЭталонаДанных из СтрокиЭталона Цикл
		СтрокаЭталонаДанных.Обработана = 1;
		Для каждого СтрокаСценарий из СписокСценарии Цикл
			СтрокиДругихДанных = ТаблицаДанных.НайтиСтроки(Новый Структура("Период, Сценарий, Подразделение, СтатьяЗатрат", СтрокаЭталонаДанных.Период, СтрокаСценарий.Сценарий, СтрокаЭталонаДанных.Подразделение, СтрокаЭталонаДанных.СтатьяЗатрат));
			Если СтрокиДругихДанных.Количество() > 0  тогда
				Для каждого СтрокаДанных из СтрокиДругихДанных Цикл
					ЭталонРегл = ?(СтрокаЭталонаДанных.СуммаРегл <> Null, СтрокаЭталонаДанных.СуммаРегл, 0);
					Регл       = ?(СтрокаДанных.СуммаРегл <> Null, СтрокаДанных.СуммаРегл, 0);
					УпрЭталон  = ?(СтрокаЭталонаДанных.СуммаУпр <> Null, СтрокаЭталонаДанных.СуммаУпр, 0);
					Упр        = ?(СтрокаДанных.СуммаУпр <> Null, СтрокаДанных.СуммаУпр, 0);
					СтрокаДанных.АбсОтклонениеРегл = ЭталонРегл - Регл;
					СтрокаДанных.АбсОтклонениеУпр  = УпрЭталон  - Упр;
					СтрокаДанных.Обработана        = 1;
				КонецЦикла;
			Иначе
				НоваяСтрока                       = ТаблицаДанных.Добавить();
				НоваяСтрока.Период                = СтрокаЭталонаДанных.Период;
				НоваяСтрока.Сценарий              = СтрокаСценарий.Сценарий;
				НоваяСтрока.Подразделение         = СтрокаЭталонаДанных.Подразделение;
				НоваяСтрока.СтатьяЗатрат          = СтрокаЭталонаДанных.СтатьяЗатрат;
				НоваяСтрока.СуммаРегл             = 0;
				НоваяСтрока.СуммаУпр              = 0;
				ЭталонРегл                        = ?(СтрокаЭталонаДанных.СуммаРегл <> Null, СтрокаЭталонаДанных.СуммаРегл, 0);
				УпрЭталон                         = ?(СтрокаЭталонаДанных.СуммаУпр <> Null, СтрокаЭталонаДанных.СуммаУпр, 0);
				НоваяСтрока.АбсОтклонениеРегл     = ЭталонРегл;
				НоваяСтрока.АбсОтклонениеУпр      = УпрЭталон;
				НоваяСтрока.ПредставлениеСценария = СтрокаСценарий.НазваниеКолонки;
				НоваяСтрока.Порядок               = СтрокаСценарий.НомерСтроки-1;
				НоваяСтрока.Обработана            = 1;
			КонецЕсли;
		КонецЦикла;
	КонецЦикла;
	
	НеОбработанныеСтроки = ТаблицаДанных.НайтиСтроки(Новый Структура("Обработана", 0));
	
	Для каждого СтрокаДанных из НеОбработанныеСтроки Цикл
		СтрокаДанных.АбсОтклонениеРегл = ?(СтрокаДанных.СуммаРегл <> Null, -СтрокаДанных.СуммаРегл, 0);
		СтрокаДанных.АбсОтклонениеУпр  = ?(СтрокаДанных.СуммаУпр <> Null, -СтрокаДанных.СуммаУпр, 0);
	КонецЦикла;
	
	ВнешниеНаборыДанных = Новый Структура("ТаблицаСценариев", ТаблицаДанных);
	
	Возврат ТиповыеОтчеты.СформироватьТиповойОтчет(ЭтотОбъект, Результат, ДанныеРасшифровки, ВыводВФормуОтчета, ВнешниеНаборыДанных);
	
КонецФункции

// В процедуре можно доработать компоновщик перед выводом в отчет
// Изменения сохранены не будут
Процедура ДоработатьКомпоновщикПередВыводом() Экспорт
	
	//ЗначениеПараметра = КомпоновщикНастроек.Настройки.ПараметрыДанных.НайтиЗначениеПараметра(Новый ПараметрКомпоновкиДанных("Период"));
	//Если ЗначениеПараметра = Неопределено Тогда
	//	Возврат;
	//КонецЕсли;
	//
	//Если ЗначениеПараметра.Значение = '00010101' Тогда
	//	ЗначениеПараметра.Значение = КонецДня(ТекущаяДата());
	//	ЗначениеПараметра.Использование = Истина;
	//КонецЕсли;
	
	СтрокаУсловногоОформления = КомпоновщикНастроек.Настройки.УсловноеОформление.Элементы.Добавить();
	СтрокаПоля = СтрокаУсловногоОформления.Поля.Элементы.Добавить();
	СтрокаПоля.Поле = Новый ПолеКомпоновкиДанных("Период");
	СтрокаПоля.Использование = Истина;
	СтрокаУсловногоОформления.Использование=Истина;
	Оформление = СтрокаУсловногоОформления.Оформление.НайтиЗначениеПараметра(Новый ПараметрКомпоновкиДанных("Format"));
	Если Периодичность <> Перечисления.Периодичность.Квартал И Периодичность <> Перечисления.Периодичность.Неделя тогда
		Оформление = СтрокаУсловногоОформления.Оформление.НайтиЗначениеПараметра(Новый ПараметрКомпоновкиДанных("Format"));
		Оформление.Использование = истина;
		Если Периодичность = Перечисления.Периодичность.Год тогда
			Оформление.Значение = "ДФ='yyyy ""г.""'"
		ИначеЕсли Периодичность = Перечисления.Периодичность.День тогда
			Оформление.Значение = "ДФ=dd.MM.yyyy"
		ИначеЕсли Периодичность = Перечисления.Периодичность.Месяц тогда
			Оформление.Значение = "ДФ='MMMM yyyy ""г.""'"
		ИначеЕсли Периодичность = Перечисления.Периодичность.Неделя тогда
			Оформление.Значение = "ДФ='yyyy ""г.""'"
		КонецЕсли;	
	ИначеЕсли Периодичность = Перечисления.Периодичность.Квартал тогда
		Оформление = СтрокаУсловногоОформления.Оформление.НайтиЗначениеПараметра(Новый ПараметрКомпоновкиДанных("Text"));
		Оформление.Использование = истина;
		Оформление.Значение       = Новый ПолеКомпоновкиДанных("ПериодПоКварталам");
	ИначеЕсли Периодичность = Перечисления.Периодичность.Неделя тогда 
		Оформление = СтрокаУсловногоОформления.Оформление.НайтиЗначениеПараметра(Новый ПараметрКомпоновкиДанных("Text"));
		Оформление.Использование = истина;
		Оформление.Значение       = Новый ПолеКомпоновкиДанных("ПериодПоНеделям");
	КонецЕсли;
	//СтрокаУсловногоОформления.Оформление = Оформление;
КонецПроцедуры

#КонецЕсли

#Если Клиент Тогда
	
// Для настройки отчета (расшифровка и др.)
Процедура Настроить(Отбор, КомпоновщикНастроекОсновногоОтчета = Неопределено) Экспорт
	
	ТиповыеОтчеты.НастроитьТиповойОтчет(ЭтотОбъект, Отбор, КомпоновщикНастроекОсновногоОтчета);
	
КонецПроцедуры

Процедура СохранитьНастройку() Экспорт
	
	СтруктураНастроек = ТиповыеОтчеты.ПолучитьСтруктуруПараметровТиповогоОтчета(ЭтотОбъект);
	СтруктураНастроек.Вставить("Периодичность", Периодичность);
	СохранениеНастроек.СохранитьНастройкуОбъекта(СохраненнаяНастройка, СтруктураНастроек);
	
КонецПроцедуры

// Процедура заполняет параметры отчета по элементу справочника из переменной СохраненнаяНастройка.
Процедура ПрименитьНастройку() Экспорт
	
	Если СохраненнаяНастройка.Пустая() Тогда
		Возврат;
	КонецЕсли;
	 
	СтруктураПараметров = СохраненнаяНастройка.ХранилищеНастроек.Получить();
	ТиповыеОтчеты.ПрименитьСтруктуруПараметровОтчета(ЭтотОбъект, СтруктураПараметров);
	Если СтруктураПараметров <> Неопределено и СтруктураПараметров.Свойство("Периодичность") тогда
		Периодичность = СтруктураПараметров.Периодичность;
	КонецЕсли;
	
КонецПроцедуры

Процедура ИнициализацияОтчета() Экспорт
	
	ЗначениеПараметра = КомпоновщикНастроек.Настройки.ПараметрыДанных.НайтиЗначениеПараметра(Новый ПараметрКомпоновкиДанных("НачалоПериода"));
	
	Если ЗначениеПараметра <> Неопределено и ЗначениеПараметра.Значение = '00010101' тогда
		
		ЗначениеПараметра.Значение = НачалоМесяца(ОбщегоНазначения.ПолучитьРабочуюДату());
		
	КонецЕсли;
	
	ЗначениеПараметра = КомпоновщикНастроек.Настройки.ПараметрыДанных.НайтиЗначениеПараметра(Новый ПараметрКомпоновкиДанных("КонецПериода"));
	
	Если ЗначениеПараметра <> Неопределено и ЗначениеПараметра.Значение = '00010101' тогда
		
		ЗначениеПараметра.Значение = КонецМесяца(ОбщегоНазначения.ПолучитьРабочуюДату());
		
	КонецЕсли;
	
	ЗначениеПараметра = КомпоновщикНастроек.Настройки.ПараметрыДанных.НайтиЗначениеПараметра(Новый ПараметрКомпоновкиДанных("Период"));
	
	Если ЗначениеПараметра <> Неопределено и ЗначениеПараметра.Значение = '00010101' тогда
		
		ЗначениеПараметра.Значение = КонецМесяца(ОбщегоНазначения.ПолучитьРабочуюДату());
		
	КонецЕсли;
	
	Если Сценарии.Количество() = 0 Тогда
		
		Запрос = Новый Запрос;
		Запрос.Текст =
		"ВЫБРАТЬ ПЕРВЫЕ 1
		|	СценарииПланирования.Ссылка
		|ИЗ
		|	Справочник.СценарииПланирования КАК СценарииПланирования
		|
		|УПОРЯДОЧИТЬ ПО
		|	СценарииПланирования.Периодичность.Порядок УБЫВ";
		
		Выборка = Запрос.Выполнить().Выбрать();
		
		Если Выборка.Следующий() Тогда
			Сценарий = Выборка.Ссылка;
		
			НоваяСтрока                     = Сценарии.Добавить();
			НоваяСтрока.ВидДанных	        = Перечисления.ВидыДанныхДляПланФактногоАнализаЗатратНаПерсонал.Сценарий;
			НоваяСтрока.Сценарий	        = Сценарий;
			НоваяСтрока.НачалоПериода       = ОбщегоНазначения.ДатаНачалаПериода(ОбщегоНазначения.ПолучитьРабочуюДату(), Сценарий.Периодичность);
			НоваяСтрока.КонецПериода        = КонецДня(ОбщегоНазначения.ДатаКонцаПериода(ОбщегоНазначения.ПолучитьРабочуюДату(), Сценарий.Периодичность));
			НоваяСтрока.СтрокаНачалоПериода = ОбщегоНазначения.ПолучитьПериодСтрокой(НоваяСтрока.НачалоПериода, ОбщегоНазначения.ПолучитьИмяЭлементаПеречисленияПоЗначению(Сценарий.Периодичность));
			НоваяСтрока.СтрокаКонецПериода  = ОбщегоНазначения.ПолучитьПериодСтрокой(НоваяСтрока.КонецПериода, ОбщегоНазначения.ПолучитьИмяЭлементаПеречисленияПоЗначению(Сценарий.Периодичность));
			
			НоваяСтрока               = Сценарии.Добавить();
			НоваяСтрока.ВидДанных	  = Перечисления.ВидыДанныхДляПланФактногоАнализаЗатратНаПерсонал.ФактическиеДанные;
			НоваяСтрока.НачалоПериода = ОбщегоНазначения.ДатаНачалаПериода(ОбщегоНазначения.ПолучитьРабочуюДату(), Сценарий.Периодичность);
			НоваяСтрока.КонецПериода  = КонецДня(ОбщегоНазначения.ДатаКонцаПериода(ОбщегоНазначения.ПолучитьРабочуюДату(), Сценарий.Периодичность));
			НоваяСтрока.СтрокаНачалоПериода = ОбщегоНазначения.ПолучитьПериодСтрокой(НоваяСтрока.НачалоПериода, ОбщегоНазначения.ПолучитьИмяЭлементаПеречисленияПоЗначению(Сценарий.Периодичность));
			НоваяСтрока.СтрокаКонецПериода  = ОбщегоНазначения.ПолучитьПериодСтрокой(НоваяСтрока.КонецПериода, ОбщегоНазначения.ПолучитьИмяЭлементаПеречисленияПоЗначению(Сценарий.Периодичность));
		КонецЕсли;
		
	КонецЕсли;
	
	ЭлементОтбораПодразделения = Неопределено;
	Для каждого ЭлементОтб из  КомпоновщикНастроек.Настройки.Отбор.Элементы Цикл
		Если ТипЗнч(ЭлементОтб) = Тип("ЭлементОтбораКомпоновкиДанных") И ЭлементОтб.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("Подразделение") тогда
			ЭлементОтбораПодразделения = ЭлементОтб;
		КонецЕсли;
	КонецЦикла;
	
	Если РежимФормированияОтчета = "ПоЦентрамОтветственности" тогда
		Если ЭлементОтбораПодразделения <> Неопределено тогда
			ЭлементОтбораПодразделения.ПравоеЗначение = Справочники.Подразделения.ПустаяСсылка();
		КонецЕсли;
	ИначеЕсли РежимФормированияОтчета = "ПоОрганизационнойСтруктуреПредприятия" тогда
		Если ЭлементОтбораПодразделения <> Неопределено тогда
			ЭлементОтбораПодразделения.ПравоеЗначение = Справочники.ПодразделенияОрганизаций.ПустаяСсылка();
		КонецЕсли;
	Иначе
		РежимФормированияОтчета      = "ПоЦентрамОтветственности";
		Если ЭлементОтбораПодразделения <> Неопределено тогда
			ЭлементОтбораПодразделения.ПравоеЗначение = Справочники.Подразделения.ПустаяСсылка();
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

Расшифровки = Новый СписокЗначений;

НастройкаПериода = Новый НастройкаПериода;

#КонецЕсли
