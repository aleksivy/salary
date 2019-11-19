﻿////////////////////////////////////////////////////////////////////////////////
// ПЕРЕМЕННЫЕ МОДУЛЯ

// Хранит последнюю установленную дату документа - для проверки перехода документа в другой период
Перем мТекущаяДатаДокумента;

////////////////////////////////////////////////////////////////////////////////
// ПРОЦЕДУРЫ - ОБРАБОТЧИКИ СОБЫТИЙ ФОРМЫ

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
	
	МеханизмНумерацииОбъектов.УстановитьДоступностьПоляВводаНомера(Метаданные(), ЭтаФорма, ЭлементыФормы.ДействияФормы.Кнопки.Подменю1,ЭлементыФормы.Номер);

	// Вывести в заголовке формы вид операции и статус документа (новый, не проведен, проведен). И вид операции документа.
	РаботаСДиалогами.УстановитьЗаголовокФормыДокумента("Дни отпуска", ЭтотОбъект, ЭтаФорма);
КонецПроцедуры // ПриОткрытии()

// Процедура - обработчик события "ПослеЗаписи" формы.
//
Процедура ПослеЗаписи()

	// Вывести в заголовке формы статус документа (новый, не проведен, проведен).
	РаботаСДиалогами.УстановитьЗаголовокФормыДокумента("Дни отпуска", ЭтотОбъект, ЭтаФорма);
	МеханизмНумерацииОбъектов.ОбновитьПодсказкуКодНомерОбъекта(ЭтотОбъект.Метаданные(), ЭлементыФормы.ДействияФормы.Кнопки.Подменю1, ЭлементыФормы.Номер);
	
КонецПроцедуры // ПослеЗаписи()

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
	
КонецПроцедуры // ДействияФормыСтруктураПодчиненностиДокумента()

// Процедура выполняет открытие формы работы со свойствами документа
//
Процедура ДействияФормыДействиеОткрытьСвойства(Кнопка)

	РаботаСДиалогами.ОткрытьСвойстваДокумента(ЭтотОбъект, ЭтаФорма);

КонецПроцедуры // ДействияФормыДействиеОткрытьСвойства()

// Процедура выполняет открытие формы работы с категориями документа
//
Процедура ДействияФормыДействиеОткрытьКатегории(Кнопка)

	РаботаСДиалогами.ОткрытьКатегорииДокумента(ЭтотОбъект, ЭтаФорма);

КонецПроцедуры // ДействияФормыДействиеОткрытьКатегории()

////////////////////////////////////////////////////////////////////////////////
// ПРОЦЕДУРЫ - ОБРАБОТЧИКИ СОБЫТИЙ РЕКВИЗИТОВ ШАПКИ

// Процедура - обработчик события "ПриИзменении" поля ввода даты документа
//
Процедура ДатаПриИзменении(Элемент = Неопределено)

	Если мТекущаяДатаДокумента = Неопределено Тогда мТекущаяДатаДокумента = Дата; КонецЕсли;
	РаботаСДиалогами.ПроверитьНомерДокумента(ДокументОбъект, мТекущаяДатаДокумента);
	МеханизмНумерацииОбъектов.ОбновитьПодсказкуКодНомерОбъекта(ЭтотОбъект.Метаданные(), ЭлементыФормы.ДействияФормы.Кнопки.Подменю1, ЭлементыФормы.Номер);

	мТекущаяДатаДокумента = Дата;

КонецПроцедуры // ДатаПриИзменении()

// Процедура - обработчик события "ПриИзменении" поля ввода организации.
//
Процедура ОрганизацияПриИзменении(Элемент)

	Если Не ПустаяСтрока(Номер) Тогда
		МеханизмНумерацииОбъектов.СброситьУстановленныйКодНомерОбъекта(ЭтотОбъект, "Номер", ЭлементыФормы.ДействияФормы.Кнопки.Подменю1, ЭлементыФормы.Номер);
	КонецЕсли;
	
	// Получим и запомним ссылку на головную организацию
	мГоловнаяОрганизация = ОбщегоНазначения.ГоловнаяОрганизация(Организация);

КонецПроцедуры // ОрганизацияПриИзменении()

////////////////////////////////////////////////////////////////////////////////
// ПРОЦЕДУРЫ - ОБРАБОТЧИКИ СОБЫТИЙ РЕКВИЗИТОВ ТАБЛИЧНОГО ПОЛЯ РаботникиОрганизации

Процедура РаботникиОрганизацииСотрудникПриИзменении(Элемент)
	ЭлементыФормы.РаботникиОрганизации.ТекущиеДанные.ФизЛицо = Элемент.Значение.ФизЛицо;
КонецПроцедуры

// Процедура - обработчик события "НачалоВыбора" поля ввода физического лица -  
// переопеределим выбор физлица на выбор из списка регистра сведений
//
// Параметры:
//	Элемент - элемент формы, который отображает физическое лицо
//
Процедура РаботникиОрганизацииСотрудникНачалоВыбора(Элемент, СтандартнаяОбработка)
	
	ПроцедурыУправленияПерсоналом.ОткрытьФормуВыбораСотрудникаОрганизации(Элемент, Ссылка, Истина, Дата, Организация, 1, СтандартнаяОбработка, Элемент.Значение);
	
КонецПроцедуры // РаботникиОрганизацииСотрудникНачалоВыбора()

// Процедура - обработчик события "АвтоПодборТекста" поля ввода физлица
// переопеределим выбор физлица на выбор из списка регистра сведений
//
Процедура РаботникиОрганизацииСотрудникАвтоПодборТекста(Элемент, Текст, ТекстАвтоПодбора, СтандартнаяОбработка)
	
	ТекстАвтоПодбора = ПроцедурыУправленияПерсоналом.ПодобратьФИОРаботникаКандидата(СтандартнаяОбработка, "РаботникиОрганизации", Текст, Организация);
	
КонецПроцедуры // РаботникиОрганизацииСотрудникАвтоПодборТекста()

// Процедура - обработчик события "ОкончаниеВводаТекста" поля ввода физлица
// переопеределим выбор физлица на выбор из списка регистра сведений
//
Процедура РаботникиОрганизацииСотрудникОкончаниеВводаТекста(Элемент, Текст, Значение, СтандартнаяОбработка)
	
	Значение = ПроцедурыУправленияПерсоналом.ПодобратьСписокРаботниковКандидатов(СтандартнаяОбработка, "РаботникиОрганизации", Текст, Элемент.Значение, Организация);
	
КонецПроцедуры // РаботникиОрганизацииСотрудникОкончаниеВводаТекста()

// Процедура разрешения/запрещения редактирования номера документа
Процедура ДействияФормыРедактироватьНомер(Кнопка)
	
	МеханизмНумерацииОбъектов.ИзменениеВозможностиРедактированияНомера(ЭтотОбъект.Метаданные(), ЭтаФорма, ЭлементыФормы.ДействияФормы.Кнопки.Подменю1, ЭлементыФормы.Номер);
			
КонецПроцедуры

Процедура РаботникиОрганизацииПриПолученииДанных(Элемент, ОформленияСтрок)
	Для Каждого СтрокаТабличнойЧасти Из ОформленияСтрок Цикл
		лДата = СтрокаТабличнойЧасти.Ячейки.Сотрудник.Значение.ДатаПриемаНаРаботу;
		лДата = ?(ЗначениеЗаполнено(лДата), Формат(лДата, "ДФ=dd.MM.yyyy" ), "");
		СтрокаТабличнойЧасти.Ячейки.ДатаПриема.УстановитьТекст( лДата );
		лДата = СтрокаТабличнойЧасти.Ячейки.Сотрудник.Значение.ДатаУвольнения;
		лДата = ?(ЗначениеЗаполнено(лДата), Формат(лДата, "ДФ=dd.MM.yyyy" ), "");
		СтрокаТабличнойЧасти.Ячейки.ДатаУвольнения.УстановитьТекст( лДата );
	КонецЦикла;
КонецПроцедуры

Процедура КоманднаяПанельРаботникиОрганизацииНачислитьДниОтпускаЗаЭтотМесяц(Кнопка)
	лЗапрос = Новый Запрос;
	лЗапрос.УстановитьПараметр("Дата", КонецМесяца(Дата) );
	Если Не ЗначениеЗаполнено(ВидОтпуска) Тогда ВидОтпуска = Справочники.ВидыОтпусков.ЕжегодныйОсновной; КонецЕсли;
	лЗапрос.УстановитьПараметр("ВидОтпуска", ВидОтпуска );
	лЗапрос.УстановитьПараметр("УчетПоКалендарнымГодам", ВидОтпуска.УчетПоКалендарнымГодам );
	лЗапрос.УстановитьПараметр("Ссылка", Ссылка );
	лЗапрос.Текст =
	"ВЫБРАТЬ
	|	Рег.Сотрудник,
	|	Рег.КвоДней КАК КоличествоДнейОтпускаВГод
	|ПОМЕСТИТЬ НормыОтпусковПоСотрудникам
	|ИЗ
	|	РегистрСведений.ггуНормыОтпусков.СрезПоследних(
	|			КОНЕЦПЕРИОДА(&Дата, ДЕНЬ),
	|			ВидОтпуска = &ВидОтпуска
	|				И НЕ Сотрудник = ЗНАЧЕНИЕ(Справочник.СотрудникиОрганизаций.ПустаяСсылка)) КАК Рег
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	Рег.КвоДней КАК КоличествоДнейОтпускаВГод
	|ПОМЕСТИТЬ НормыОтпусковПоВсем
	|ИЗ
	|	РегистрСведений.ггуНормыОтпусков.СрезПоследних(
	|			КОНЕЦПЕРИОДА(&Дата, ДЕНЬ),
	|			ВидОтпуска = &ВидОтпуска
	|				И Сотрудник = ЗНАЧЕНИЕ(Справочник.СотрудникиОрганизаций.ПустаяСсылка)) КАК Рег
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	Рег.Сотрудник КАК Сотрудник,
	|	Рег.Сотрудник.ДатаПриемаНаРаботу КАК ДатаПриема,
	|	ВЫБОР
	|		КОГДА ДОБАВИТЬКДАТЕ(Рег.Сотрудник.ДатаПриемаНаРаботу, ГОД, РАЗНОСТЬДАТ(Рег.Сотрудник.ДатаПриемаНаРаботу, КОНЕЦПЕРИОДА(&Дата, МЕСЯЦ), ГОД)) > НАЧАЛОПЕРИОДА(&Дата, МЕСЯЦ)
	|			ТОГДА ДОБАВИТЬКДАТЕ(Рег.Сотрудник.ДатаПриемаНаРаботу, ГОД, РАЗНОСТЬДАТ(Рег.Сотрудник.ДатаПриемаНаРаботу, КОНЕЦПЕРИОДА(&Дата, МЕСЯЦ), ГОД) - 1)
	|		ИНАЧЕ ДОБАВИТЬКДАТЕ(Рег.Сотрудник.ДатаПриемаНаРаботу, ГОД, РАЗНОСТЬДАТ(Рег.Сотрудник.ДатаПриемаНаРаботу, КОНЕЦПЕРИОДА(&Дата, МЕСЯЦ), ГОД))
	|	КОНЕЦ КАК КонецГода
	|ПОМЕСТИТЬ КонецПоследнегоГода1
	|ИЗ
	|	РегистрСведений.РаботникиОрганизаций.СрезПоследних(КОНЕЦПЕРИОДА(&Дата, МЕСЯЦ), ) КАК Рег
	|ГДЕ
	|	Рег.ЗанимаемыхСтавок > 0
	|	И Рег.Сотрудник.ДатаПриемаНаРаботу <= НАЧАЛОПЕРИОДА(&Дата, МЕСЯЦ)
	|	И (Рег.Сотрудник.ДатаУвольнения = ДАТАВРЕМЯ(1, 1, 1)
	|			ИЛИ Рег.Сотрудник.ДатаУвольнения > КОНЕЦПЕРИОДА(&Дата, МЕСЯЦ))
	|	И НЕ Рег.Сотрудник В
	|				(ВЫБРАТЬ
	|					Рег.Сотрудник КАК Сотрудник
	|				ИЗ
	|					РегистрСведений.СостояниеРаботниковОрганизаций.СрезПоследних(КОНЕЦПЕРИОДА(&Дата, МЕСЯЦ), ПериодЗавершения > КОНЕЦПЕРИОДА(&Дата, МЕСЯЦ)
	|						И (Состояние = ЗНАЧЕНИЕ(Перечисление.СостоянияРаботникаОрганизации.ОтпускПоУходуЗаРебенком)
	|							ИЛИ Состояние = ЗНАЧЕНИЕ(Перечисление.СостоянияРаботникаОрганизации.ОтпускПоБеременностиИРодам))) КАК Рег)
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	КонецПоследнегоГода.Сотрудник КАК Сотрудник,
	|	КонецПоследнегоГода.ДатаПриема КАК ДатаПриема,
	|	ВЫБОР
	|		КОГДА НЕ &ВидОтпуска = ЗНАЧЕНИЕ(Справочник.ВидыОтпусков.ЕжегодныйОсновной)
	|				И КонецПоследнегоГода.КонецГода < ДАТАВРЕМЯ(2017, 1, 1)
	|			ТОГДА ВЫБОР
	|					КОГДА КонецПоследнегоГода.ДатаПриема > КОНЕЦПЕРИОДА(ДОБАВИТЬКДАТЕ(&Дата, ГОД, -1), ГОД)
	|						ТОГДА КонецПоследнегоГода.ДатаПриема
	|					ИНАЧЕ КОНЕЦПЕРИОДА(ДОБАВИТЬКДАТЕ(&Дата, ГОД, -1), ГОД)
	|				КОНЕЦ
	|		ИНАЧЕ ВЫБОР
	|				КОГДА &УчетПоКалендарнымГодам = ИСТИНА
	|					ТОГДА КОНЕЦПЕРИОДА(ДОБАВИТЬКДАТЕ(&Дата, ГОД, -1), ГОД)
	|				ИНАЧЕ КонецПоследнегоГода.КонецГода
	|			КОНЕЦ
	|	КОНЕЦ КАК КонецГода
	|ПОМЕСТИТЬ КонецПоследнегоГода
	|ИЗ
	|	КонецПоследнегоГода1 КАК КонецПоследнегоГода
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	КонецПоследнегоГода.Сотрудник КАК Сотрудник,
	|	КонецПоследнегоГода.ДатаПриема КАК ДатаПриема,
	|	КонецПоследнегоГода.КонецГода КАК КонецГода,
	|	ВЫБОР
	|		КОГДА ДЕНЬ(КонецПоследнегоГода.КонецГода) = 1
	|			ТОГДА РАЗНОСТЬДАТ(КонецПоследнегоГода.КонецГода, КОНЕЦПЕРИОДА(&Дата, МЕСЯЦ), МЕСЯЦ) + 1
	|		ИНАЧЕ РАЗНОСТЬДАТ(КонецПоследнегоГода.КонецГода, КОНЕЦПЕРИОДА(&Дата, МЕСЯЦ), МЕСЯЦ)
	|	КОНЕЦ КАК КолвоМесяцев
	|ПОМЕСТИТЬ Месяцы
	|ИЗ
	|	КонецПоследнегоГода КАК КонецПоследнегоГода
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	Рег.Сотрудник КАК Сотрудник,
	|	СУММА(Рег.КвоДней) КАК КвоДнейНачислено
	|ПОМЕСТИТЬ Начислено
	|ИЗ
	|	РегистрНакопления.СернаДниОтпуска КАК Рег
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ Месяцы КАК Месяцы
	|		ПО Рег.Сотрудник = Месяцы.Сотрудник
	|ГДЕ
	|	Рег.ВидДвижения = ЗНАЧЕНИЕ(ВидДвиженияНакопления.Приход)
	|	И Рег.ВидОтпуска = &ВидОтпуска
	|	И НЕ Рег.ЭтоКорректировка
	|	И Рег.КвоДней > 0
	|	И Рег.Период > КОНЕЦПЕРИОДА(Месяцы.КонецГода, ДЕНЬ)
	|	И Рег.Период <= КОНЕЦПЕРИОДА(&Дата, МЕСЯЦ)
	|	И (НЕ Рег.Регистратор = &Ссылка
	|			ИЛИ &Ссылка = НЕОПРЕДЕЛЕНО
	|			ИЛИ &Ссылка = ЗНАЧЕНИЕ(Документ.ДниОтпускаОрганизаций.ПустаяСсылка))
	|
	|СГРУППИРОВАТЬ ПО
	|	Рег.Сотрудник
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ЛОЖЬ КАК Расход,
	|	ВЫБОР
	|		КОГДА &УчетПоКалендарнымГодам = ИСТИНА
	|			ТОГДА НАЧАЛОПЕРИОДА(&Дата, МЕСЯЦ)
	|		ИНАЧЕ ВЫБОР
	|				КОГДА ДОБАВИТЬКДАТЕ(НАЧАЛОПЕРИОДА(&Дата, МЕСЯЦ), ДЕНЬ, ДЕНЬ(Месяцы.ДатаПриема) - 2) < НАЧАЛОПЕРИОДА(&Дата, МЕСЯЦ)
	|					ТОГДА НАЧАЛОПЕРИОДА(КОНЕЦПЕРИОДА(&Дата, МЕСЯЦ), ДЕНЬ)
	|				ИНАЧЕ ДОБАВИТЬКДАТЕ(НАЧАЛОПЕРИОДА(&Дата, МЕСЯЦ), ДЕНЬ, ДЕНЬ(Месяцы.ДатаПриема) - 2)
	|			КОНЕЦ
	|	КОНЕЦ КАК Период,
	|	Месяцы.Сотрудник КАК Сотрудник,
	|	(ВЫРАЗИТЬ(Месяцы.КолвоМесяцев * ВЫБОР
	|			КОГДА НормыОтпусковПоСотрудникам.КоличествоДнейОтпускаВГод ЕСТЬ NULL 
	|				ТОГДА НормыОтпусковПоВсем.КоличествоДнейОтпускаВГод
	|			ИНАЧЕ НормыОтпусковПоСотрудникам.КоличествоДнейОтпускаВГод
	|		КОНЕЦ / 12 КАК ЧИСЛО(12, 0))) - ЕСТЬNULL(Начислено.КвоДнейНачислено, 0) КАК КвоДней
	|ПОМЕСТИТЬ Врем
	|ИЗ
	|	Месяцы КАК Месяцы
	|		ЛЕВОЕ СОЕДИНЕНИЕ Начислено КАК Начислено
	|		ПО Месяцы.Сотрудник = Начислено.Сотрудник
	|		ЛЕВОЕ СОЕДИНЕНИЕ НормыОтпусковПоСотрудникам КАК НормыОтпусковПоСотрудникам
	|		ПО Месяцы.Сотрудник = НормыОтпусковПоСотрудникам.Сотрудник,
	|	НормыОтпусковПоВсем КАК НормыОтпусковПоВсем
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	Врем.Расход,
	|	Врем.Период,
	|	Врем.Сотрудник КАК Сотрудник,
	|	Врем.КвоДней
	|ИЗ
	|	Врем КАК Врем
	|ГДЕ
	|	НЕ Врем.КвоДней = 0
	|
	|УПОРЯДОЧИТЬ ПО
	|	Врем.Сотрудник.Наименование";
	лтзРез = лЗапрос.Выполнить().Выгрузить();
	РаботникиОрганизации.Очистить();
	РаботникиОрганизации.Загрузить( лтзРез );
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// ОПЕРАТОРЫ ОСНОВНОЙ ПРОГРАММЫ

мНастройкаПериода = Новый НастройкаПериода;
