////////////////////////////////////////////////////////////////////////////////
// ПЕРЕМЕННЫЕ МОДУЛЯ

////////////////////////////////////////////////////////////////////////////////
// ВСПОМОГАТЕЛЬНЫЕ ПРОЦЕДУРЫ И ФУНКЦИИ


// Поиск элемента структуры с названием НачисленияУдержания
//
Процедура НайтиСледующийУровень(СтруктураПриемник, СтруктураИсточник, ЭлементСтруктурыФизЛицо)
	
	Для каждого ЭлементСтруктуры из СтруктураИсточник.Структура Цикл
		
		Если ЭлементСтруктуры.Имя = "НачисленияУдержания" тогда
			
			ЭлементГруппировки = СтруктураПриемник.Структура.Добавить(Тип("ГруппировкаКомпоновкиДанных"));
			ТиповыеОтчеты.СкопироватьНастройкиКомпоновкиДанных(ЭлементГруппировки, ЭлементСтруктурыФизЛицо);
			Прервать;
			
		КонецЕсли;
		
		ЭлементПриемник = СтруктураПриемник.Структура.Добавить(Тип("ГруппировкаКомпоновкиДанных"));
		ТиповыеОтчеты.СкопироватьЭлементы(ЭлементПриемник.ПоляГруппировки.Элементы, ЭлементСтруктуры.ПоляГруппировки.Элементы);
		ТиповыеОтчеты.СкопироватьЭлементы(ЭлементПриемник.Выбор.Элементы, ЭлементСтруктуры.Выбор.Элементы);
		НайтиСледующийУровень(ЭлементПриемник,ЭлементСтруктуры, ЭлементСтруктурыФизЛицо);
		
	КонецЦикла;
	
КонецПроцедуры

// Обновление отчета
//
// Параметры:
//  Нет.
//
Процедура ОбновитьОтчет() Экспорт
	
	НачалоПериода = КомпоновщикНастроек.Настройки.ПараметрыДанных.НайтиЗначениеПараметра(Новый ПараметрКомпоновкиДанных("НачалоПериода")).Значение;
	КонецПериода  = КомпоновщикНастроек.Настройки.ПараметрыДанных.НайтиЗначениеПараметра(Новый ПараметрКомпоновкиДанных("КонецПериода")).Значение;
	
	Если НачалоПериода > КонецПериода тогда
		Сообщить(НСтр("ru='Неправильно указан период.';uk='Неправильно вказаний період.'"));
		Возврат;
	КонецЕсли;
	
	КодЯзыкаПечать = ЛокализацияПовтИсп.ПолучитьЯзыкФормированияПечатныхФормОтчетов();
	КомпоновщикНастроек.Настройки.ПараметрыДанных.УстановитьЗначениеПараметра("НачисленоВидДвижения", НСтр("ru='1. Начислено';uk='1. Нараховано'",КодЯзыкаПечать));
	КомпоновщикНастроек.Настройки.ПараметрыДанных.УстановитьЗначениеПараметра("УдержаноВидДвижения", НСтр("ru='2. Удержано';uk='2. Утримано'",КодЯзыкаПечать));
	КомпоновщикНастроек.Настройки.ПараметрыДанных.УстановитьЗначениеПараметра("ВыплатаВидДвижения", НСтр("ru='3. Выплата';uk='3. Виплата'",КодЯзыкаПечать));
	КомпоновщикНастроек.Настройки.ПараметрыДанных.УстановитьЗначениеПараметра("Выплата", НСтр("ru='Выплата';uk='Виплата'",КодЯзыкаПечать));
	КомпоновщикНастроек.Настройки.ПараметрыДанных.УстановитьЗначениеПараметра("ПогашениеЗайма", НСтр("ru='Погашение займа';uk='Погашення позики'",КодЯзыкаПечать));
	КомпоновщикНастроек.Настройки.ПараметрыДанных.УстановитьЗначениеПараметра("ДолгЗаПредприятиемНаНачалоМесяца", НСтр("ru='Долг за предприятием на начало месяца';uk='Борг за підприємством на початок місяця'",КодЯзыкаПечать));
	КомпоновщикНастроек.Настройки.ПараметрыДанных.УстановитьЗначениеПараметра("ДолгЗаПредприятиемНаКонецМесяца", НСтр("ru='Долг за предприятием на конец месяца';uk='Борг за підприємством на кінець місяця'",КодЯзыкаПечать));
	КомпоновщикНастроек.Настройки.ПараметрыДанных.УстановитьЗначениеПараметра("ДолгЗаРаботникомНаНачалоМесяца", НСтр("ru='Долг за работником на начало месяца';uk='Борг за працівником на початок місяця'",КодЯзыкаПечать));
	КомпоновщикНастроек.Настройки.ПараметрыДанных.УстановитьЗначениеПараметра("ДолгЗаРаботникомНаКонецМесяца", НСтр("ru='Долг за работником на конец месяца';uk='Борг за працівником на кінець місяця'",КодЯзыкаПечать));
	Если ФормированиеПечатныхФорм.ЗаполненРегламентированныйПроизводственныйКалендарь(НачалоПериода, КонецПериода) тогда 
		ЭтоРасшифровка = ЭтоОтработкаРасшифровки;
		СформироватьОтчет(ЭлементыФормы.Результат, ДанныеРасшифровки);
	Иначе
		Сообщить(НСтр("ru='Не заполнен регламентированный производственный календарь';uk='Не заповнений регламентований виробничий календар'"));
	КонецЕсли;
	
	ТекущийЭлемент = ЭлементыФормы.Результат;
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// ПРОЦЕДУРЫ - ОБРАБОТЧИКИ СОБЫТИЙ ФОРМЫ

// Процедура - обработчик события "ПередОткрытием" формы.
//
Процедура ПередОткрытием(Отказ, СтандартнаяОбработка)
	
	Если Не ЭтоОтработкаРасшифровки 
		И Не СохранениеНастроек.ЗаполнитьНастройкиПриОткрытииОтчета(ОтчетОбъект) Тогда
		ИнициализацияОтчета();
	КонецЕсли;
	
	ТиповыеОтчеты.НазначитьФормеУникальныйКлючИдентификации(ЭтаФорма);
	ТиповыеОтчеты.ОбновитьФормуТиповогоОтчетаПоКомпоновщику(ОтчетОбъект, ЭтаФорма);
	ТиповыеОтчеты.УправлениеОтображениемЭлементовФормыТиповогоОтчета(ОтчетОбъект, ЭтаФорма);
	
	РД = ОбщегоНазначения.ПолучитьРабочуюДату();
	
	НачалоПериода = НачалоМесяца(РД);
	КонецПериода  = КонецМесяца(РД);
	
	СтрокаНачалоПериода = РаботаСДиалогами.ДатаКакМесяцПредставление(НачалоПериода);
	СтрокаКонецПериода  = РаботаСДиалогами.ДатаКакМесяцПредставление(КонецПериода);
	
	КомпоновщикНастроек.Настройки.ПараметрыДанных.Элементы.Найти("НачалоПериода").Значение      = НачалоПериода;
	КомпоновщикНастроек.Настройки.ПараметрыДанных.Элементы.Найти("НачалоПериода").Использование = Истина;
	КомпоновщикНастроек.Настройки.ПараметрыДанных.Элементы.Найти("КонецПериода").Значение       = КонецПериода;
	КомпоновщикНастроек.Настройки.ПараметрыДанных.Элементы.Найти("КонецПериода").Использование  = истина;
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// ПРОЦЕДУРЫ - ОБРАБОТЧИКИ СОБЫТИЙ КОМАНДНОЙ ПАНЕЛИ ФОРМЫ

// Процедура - обработчик нажатия кнопки "Сформировать"
//
Процедура ДействияФормыСформировать(Кнопка)
	
	ОбновитьОтчет();
	
КонецПроцедуры

// Процедура - обработчик нажатия кнопки "Отбор"
//
Процедура ДействияФормыОтбор(Кнопка)
	
	Кнопка.Пометка = Не Кнопка.Пометка;
	ПоказыватьБыстрыйОтбор = Кнопка.Пометка;
	ТиповыеОтчеты.УправлениеОтображениемЭлементовФормыТиповогоОтчета(ОтчетОбъект, ЭтаФорма);
	
КонецПроцедуры

// Процедура - обработчик нажатия кнопки "На принтер"
//
Процедура ДействияФормыНаПринтер(Кнопка)
	
	ЭлементыФормы.Результат.Напечатать();

КонецПроцедуры

// Обработчик события элемента КоманднаяПанельФормы.НовыйОтчет.
//
Процедура ДействияФормыНовыйОтчет(Кнопка)
	
	Если Строка(ЭтотОбъект) = "ВнешняяОбработкаОбъект." + ЭтотОбъект.Метаданные().Имя Тогда
			
		Предупреждение(НСтр("ru='Данный отчет является внешней обработкой.';uk='Даний звіт є зовнішньою обробкою.'") + Символы.ПС + НСтр("ru='Открытие нового отчета возможно только для объектов конфигурации.';uk=""Відкриття нового звіту можливо тільки для об'єктів конфігурації."""));
		Возврат;
			
	Иначе
			
		НовыйОтчет = Отчеты[ЭтотОбъект.Метаданные().Имя].Создать();
			
	КонецЕсли;
	
	ФормаНовогоОтчета = НовыйОтчет.ПолучитьФорму();
	ФормаНовогоОтчета.Открыть();

КонецПроцедуры // КоманднаяПанельФормыДействиеНовыйОтчет()

////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ ЭЛЕМЕНТОВ ДИАЛОГА

// Процедура - обработчик нажатия кнопки выбора даты начала периода
//
Процедура НачалоПериодаПриИзменении(Элемент)
	
	РаботаСДиалогами.ДатаКакМесяцПодобратьДатуПоТексту(Элемент.Значение, НачалоПериода);
	Элемент.Значение           = РаботаСДиалогами.ДатаКакМесяцПредставление(НачалоПериода);
	ЗначениеПараметра          = КомпоновщикНастроек.Настройки.ПараметрыДанных.НайтиЗначениеПараметра(Новый ПараметрКомпоновкиДанных("НачалоПериода"));;
	ЗначениеПараметра.Значение = НачалоМесяца(НачалоПериода);
	ТиповыеОтчеты.ОбработкаИзмененияТиповогоОтчетаНаФормеОтчета(ОтчетОбъект, ЭтаФорма);
	
КонецПроцедуры

// Процедура - обработчик нажатия кнопки выбора даты окончания периода
//
Процедура КонецПериодаПриИзменении(Элемент)
	
	РаботаСДиалогами.ДатаКакМесяцПодобратьДатуПоТексту(Элемент.Значение, КонецПериода);
	
	Элемент.Значение           = РаботаСДиалогами.ДатаКакМесяцПредставление(КонецПериода);
	ЗначениеПараметра          = КомпоновщикНастроек.Настройки.ПараметрыДанных.НайтиЗначениеПараметра(Новый ПараметрКомпоновкиДанных("КонецПериода"));
	ЗначениеПараметра.Значение = КонецМесяца(КонецПериода);
	ТиповыеОтчеты.ОбработкаИзмененияТиповогоОтчетаНаФормеОтчета(ОтчетОбъект, ЭтаФорма);
	
КонецПроцедуры

// Процедура - обработчик нажатия на кнопку "ВосстановитьЗначения"
//
Процедура ДействияФормыВосстановитьЗначения___(Кнопка)
	
	СохранениеНастроек.ВыбратьНастройкуФормы(СохраненнаяНастройка, ЭтаФорма, "ОтчетОбъект." + ОтчетОбъект.Метаданные().Имя, Ложь);
	ТиповыеОтчеты.ОбновитьФормуТиповогоОтчетаПоКомпоновщику(ОтчетОбъект, ЭтаФорма);
	ТиповыеОтчеты.ОбновитьЗаголовокТиповогоОтчета(ОтчетОбъект, ЭтаФорма);
	
	ЗначениеНачалоПериода = КомпоновщикНастроек.Настройки.ПараметрыДанных.НайтиЗначениеПараметра(Новый ПараметрКомпоновкиДанных("НачалоПериода"));
	ЗначениеКонецПериода  = КомпоновщикНастроек.Настройки.ПараметрыДанных.НайтиЗначениеПараметра(Новый ПараметрКомпоновкиДанных("КонецПериода"));
	
	НачалоПериода = ЗначениеНачалоПериода.Значение;
	КонецПериода  = ЗначениеКонецПериода.Значение;
	
	СтрокаНачалоПериода = РаботаСДиалогами.ДатаКакМесяцПредставление(НачалоПериода);
	СтрокаКонецПериода  = РаботаСДиалогами.ДатаКакМесяцПредставление(КонецПериода);
КонецПроцедуры

// Процедура - обработчик нажатия на кнопку "СохранитьЗначения"
//
Процедура ДействияФормыСохранитьЗначения(Кнопка)
	
	СохранениеНастроек.ВыбратьНастройкуФормы(СохраненнаяНастройка, ЭтаФорма, "ОтчетОбъект." + ОтчетОбъект.Метаданные().Имя, Истина);
	ТиповыеОтчеты.ОбновитьЗаголовокТиповогоОтчета(ОтчетОбъект, ЭтаФорма);
	
КонецПроцедуры

// Процедура - обработчик нажатия на кнопку "Настройки"
//
Процедура ДействияФормыНастройки(Кнопка)
	
	Если ТиповыеОтчеты.РедактироватьНастройкиТиповогоОтчета(ОтчетОбъект, ЭтаФорма) Тогда
		ОбновитьОтчет();	
	КонецЕсли;
	
	ЗначениеПараметраНачалоПериода = КомпоновщикНастроек.Настройки.ПараметрыДанных.НайтиЗначениеПараметра(Новый ПараметрКомпоновкиДанных("НачалоПериода"));
	ЗначениеПараметраКонецПериода  = КомпоновщикНастроек.Настройки.ПараметрыДанных.НайтиЗначениеПараметра(Новый ПараметрКомпоновкиДанных("КонецПериода"));
	ЗначениеПараметраНачалоПериода.Значение = НачалоМесяца(ЗначениеПараметраНачалоПериода.Значение);
	ЗначениеПараметраКонецПериода.Значение  = КонецМесяца(ЗначениеПараметраКонецПериода.Значение);
	
	НачалоПериода = ЗначениеПараметраНачалоПериода.Значение;
	КонецПериода  = ЗначениеПараметраКонецПериода.Значение;
	
	СтрокаНачалоПериода = РаботаСДиалогами.ДатаКакМесяцПредставление(НачалоПериода);
	СтрокаКонецПериода  = РаботаСДиалогами.ДатаКакМесяцПредставление(КонецПериода);
	
КонецПроцедуры

// Процедура - обработчик события регулирование поле ввода "НачалоПериода"
//
Процедура НачалоПериодаРегулирование(Элемент, Направление, СтандартнаяОбработка)
	
	НачалоПериода = ДобавитьМесяц(НачалоПериода, Направление);
	Элемент.Значение = РаботаСДиалогами.ДатаКакМесяцПредставление(НачалоПериода);
	КомпоновщикНастроек.Настройки.ПараметрыДанных.Элементы.Найти("НачалоПериода").Значение = НачалоМесяца(НачалоПериода);
	ТиповыеОтчеты.ОбработкаИзмененияТиповогоОтчетаНаФормеОтчета(ОтчетОбъект, ЭтаФорма);
	
КонецПроцедуры

// Процедура - обработчик события авто подбора текста поле ввода "НачалоПериода"
//
Процедура НачалоПериодаАвтоПодборТекста(Элемент, Текст, ТекстАвтоПодбора, СтандартнаяОбработка)
	
	РаботаСДиалогами.ДатаКакМесяцАвтоПодборТекста(Текст, ТекстАвтоПодбора, СтандартнаяОбработка);
	
КонецПроцедуры

// Процедура - обработчик события начало выбора из списка кнопки "НачалоПериода"
//
Процедура НачалоПериодаНачалоВыбораИзСписка(Элемент, СтандартнаяОбработка)
	
	РаботаСДиалогами.НачалоВыбораИзСпискаПредставленияПериодаРегистрации(Элемент, СтандартнаяОбработка, НачалоПериода, ЭтаФорма);
	КомпоновщикНастроек.Настройки.ПараметрыДанных.Элементы.Найти("НачалоПериода").Значение = НачалоМесяца(НачалоПериода);
	ТиповыеОтчеты.ОбработкаИзмененияТиповогоОтчетаНаФормеОтчета(ОтчетОбъект, ЭтаФорма);
	
КонецПроцедуры

// Процедура - обработчик события очистка кнопки "НачалоПериода"
//
Процедура НачалоПериодаОчистка(Элемент, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
КонецПроцедуры

// Процедура - обработчик события начало выбора из списка кнопки "КонецПериода"
//
Процедура КонецПериодаНачалоВыбораИзСписка(Элемент, СтандартнаяОбработка)
	
	РаботаСДиалогами.НачалоВыбораИзСпискаПредставленияПериодаРегистрации(Элемент, СтандартнаяОбработка, КонецПериода, ЭтаФорма);
	КомпоновщикНастроек.Настройки.ПараметрыДанных.Элементы.Найти("КонецПериода").Значение = КонецМесяца(КонецПериода);
	ТиповыеОтчеты.ОбработкаИзмененияТиповогоОтчетаНаФормеОтчета(ОтчетОбъект, ЭтаФорма);
	
КонецПроцедуры

// Процедура - обработчик события очистка кнопки "КонецПериода"
//
Процедура КонецПериодаОчистка(Элемент, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
КонецПроцедуры

// Процедура - обработчик события регулирование поле ввода "КонецПериода"
//
Процедура КонецПериодаРегулирование(Элемент, Направление, СтандартнаяОбработка)
	
	КонецПериода     = ДобавитьМесяц(КонецПериода, Направление);
	Элемент.Значение = РаботаСДиалогами.ДатаКакМесяцПредставление(КонецПериода);
	КомпоновщикНастроек.Настройки.ПараметрыДанных.Элементы.Найти("КонецПериода").Значение = КонецМесяца(КонецПериода);
	ТиповыеОтчеты.ОбработкаИзмененияТиповогоОтчетаНаФормеОтчета(ОтчетОбъект, ЭтаФорма);
	
КонецПроцедуры

// Процедура - обработчик события авто подбора текста поле ввода "КонецПериода"
//
Процедура КонецПериодаАвтоПодборТекста(Элемент, Текст, ТекстАвтоПодбора, СтандартнаяОбработка)
	
	РаботаСДиалогами.ДатаКакМесяцАвтоПодборТекста(Текст, ТекстАвтоПодбора, СтандартнаяОбработка);
	
КонецПроцедуры

// Процедура - обработчик нажатия кнопки "Заголовок".
//
Процедура ДействияФормыЗаголовок(Кнопка)
	
	Кнопка.Пометка = Не Кнопка.Пометка;
	ТиповыеОтчеты.УправлениеОтображениемЭлементовФормыТиповогоОтчета(ОтчетОбъект, ЭтаФорма);
	ТиповыеОтчеты.УправлениеОтображениемЗаголовкаТиповогоОтчета(ОтчетОбъект, ЭтаФорма.ЭлементыФормы.Результат);
	
КонецПроцедуры

// Процедура - обработчик события обработка расшифровки табличного поля "Результат"
//
Процедура РезультатОбработкаРасшифровки(Элемент, Расшифровка, СтандартнаяОбработка)
	
	Перем ВыполненноеДействие;

	// Запретим стандартную обработку расшифровки
	СтандартнаяОбработка = Ложь;

	// Создадим и инициализируем обработчик расшифровки
	ОбработкаРасшифровки = Новый ОбработкаРасшифровкиКомпоновкиДанных(ДанныеРасшифровки, Новый ИсточникДоступныхНастроекКомпоновкиДанных(СхемаКомпоновкиДанных));
	
	ДоступныеДействия = Новый Массив();
	ДоступныеДействия.Добавить(ДействиеОбработкиРасшифровкиКомпоновкиДанных.ОткрытьЗначение);
	ДоступныеДействия.Добавить(ДействиеОбработкиРасшифровкиКомпоновкиДанных.Упорядочить);
	
	//определим какое поле расшифровывается
	МассивПолейРасшифровки = ТиповыеОтчеты.ПолучитьМассивПолейРасшифровки(Расшифровка, ДанныеРасшифровки);
	
	Если НЕ ЭтоОтработкаРасшифровки тогда
		Для каждого НазваниеПоля из МассивПолейРасшифровки Цикл
			Если ТипЗнч(НазваниеПоля) = Тип("ЗначениеПоляРасшифровкиКомпоновкиДанных") И (НазваниеПоля.Поле = "Раздел" или НазваниеПоля.Поле = "ВидРасчета") тогда
				ДоступныеДействия.Добавить(ДействиеОбработкиРасшифровкиКомпоновкиДанных.Расшифровать);
				Прервать;
			КонецЕсли;
		КонецЦИкла;
	Иначе
		ДоступныеДействия.Добавить(ДействиеОбработкиРасшифровкиКомпоновкиДанных.Расшифровать);
	КонецЕсли;
	
	// Осуществим выбор действия расшифровки пользователем
	Настройки = ОбработкаРасшифровки.Выполнить(Расшифровка, ВыполненноеДействие, ДоступныеДействия);
	
	Если Настройки <> Неопределено Тогда
		// Пользователь выбрал действие, для которого нужно менять настройки

		Если ВыполненноеДействие = ДействиеОбработкиРасшифровкиКомпоновкиДанных.Упорядочить Тогда
			
			ФормированиеПечатныхФорм.ПеренестиПорядокВОтчет(Настройки);
			
			// Если требется упорядочить - упорядочим в текущем отчете
			КомпоновщикНастроек.ЗагрузитьНастройки(Настройки);
			ОбновитьОтчет();

		Иначе
            // При других действиях - создадим новый отчет, откроем форму, сформируем отчет в ней
			Отчет = Отчеты[Метаданные().Имя].Создать();
			Отчет.КомпоновщикНастроек.ЗагрузитьНастройки(Настройки);
			Форма = Отчет.ПолучитьФорму();
			Форма.ЭтоОтработкаРасшифровки = истина;
			Форма.ОбновитьОтчет();
			Форма.Открыть();

		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

// Процедура - обработчик события обновление отображения формы
//
Процедура ОбновлениеОтображения()
	
	ТиповыеОтчеты.ОбновитьЗаголовокТиповогоОтчета(ОтчетОбъект, ЭтаФорма);
	
КонецПроцедуры

Процедура ТабличноеПолеОтборПриОкончанииРедактирования(Элемент, НоваяСтрока, ОтменаРедактирования)
	
	ТиповыеОтчеты.ОбработкаИзмененияТиповогоОтчетаНаФормеОтчета(ОтчетОбъект, ЭтаФорма);
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// ОПЕРАТОРЫ ОСНОВНОЙ ПРОГРАММЫ
