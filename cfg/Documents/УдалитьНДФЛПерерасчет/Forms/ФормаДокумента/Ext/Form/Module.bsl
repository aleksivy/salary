////////////////////////////////////////////////////////////////////////////////
// ПЕРЕМЕННЫЕ МОДУЛЯ

Перем мТекущаяДатаДокумента; // Хранит последнюю установленную дату документа - для проверки перехода документа в другой период

////////////////////////////////////////////////////////////////////////////////
// ОБЩИЕ ПРОЦЕДУРЫ И ФУНКЦИИ

// Записывает документ в режиме отмены проведения, спросив об этом у пользователя
Функция ЗаписатьДокументОтменивПроведение(Действие = "рассчитать")

	Если Проведен Тогда
		
		Если Вопрос(НСтр("ru='Автоматически ';uk='Автоматично '") + Действие +НСтр("ru=' документ можно только после отмены его проведения. Выполнить отмену проведения документа?';uk=' документ можна тільки після скасування його проведення. Виконати скасування проведення документа?'"), РежимДиалогаВопрос.ДаНет) = КодВозвратаДиалога.Нет Тогда
			Возврат Ложь;
		КонецЕсли;
		
		ЗаписатьВФорме(РежимЗаписиДокумента.ОтменаПроведения);
		
	ИначеЕсли Модифицированность ИЛИ ЭтоНовый() Тогда
		
		Если Вопрос(НСтр("ru='Автоматически ';uk='Автоматично '") + Действие +НСтр("ru=' документ можно только после его записи. Записать?';uk=' документ можна тільки після його запису. Записати?'"), РежимДиалогаВопрос.ДаНет) = КодВозвратаДиалога.Нет Тогда
			Возврат Ложь;
		КонецЕсли;
		
		ЗаписатьВФорме(РежимЗаписиДокумента.Запись);
		
	КонецЕсли;
	
	Возврат Истина;

КонецФункции  



////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ ФОРМЫ

Процедура ПередОткрытием(Отказ, СтандартнаяОбработка)
	
	Если ЭтоНовый() Тогда
		Отказ = Истина;
		Предупреждение(НСтр("ru='Документ больше не используется в работе. Используйте документ ""Начисление зарплаты работникам организаций""';uk='Документ більше не використовується в роботі. Використовуйте документ ""Нарахування зарплати працівникам організацій""'"),10);
		Возврат;
	КонецЕсли;

КонецПроцедуры

// Процедура - обработчик события "ПриОткрытии" формы
//
Процедура ПриОткрытии()

	Если ЭтоНовый() Тогда
		// Заполнить реквизиты значениями по умолчанию.
		ЗаполнениеДокументов.ЗаполнитьШапкуДокумента(ЭтотОбъект);
		
		ПериодРегистрации = НачалоМесяца(Дата);
		
		НалоговыйПериодНачало	= НачалоГода(Дата);	
		НалоговыйПериодКонец	= КонецМесяца(Дата);	
		
	КонецЕсли;	

	// Вывести в заголовке формы вид операции и статус документа (новый, не проведен, проведен).
	РаботаСДиалогами.УстановитьЗаголовокФормыДокумента(, ЭтотОбъект, ЭтаФорма);

	// Запомнить текущие значения реквизитов формы.
	мТекущаяДатаДокумента        = Дата;
	
	// Установить активный реквизит.
	РаботаСДиалогами.АктивизироватьРеквизитВФорме(ЭтотОбъект, ЭтаФорма);
	
	// Установим видимость реквизита "Приказ"
	РаботаСДиалогами.УстановитьВидимостьПриказа(ЭтаФорма,Организация,глЗначениеПеременной("глУчетнаяПолитикаПоПерсоналуОрганизации"));
	
КонецПроцедуры

// Процедура - обработчик события "ПослеЗаписи" формы.
//
Процедура ПослеЗаписи()
	// Вывести в заголовке формы статус документа (новый, не проведен, проведен).
	РаботаСДиалогами.УстановитьЗаголовокФормыДокумента(, ЭтотОбъект, ЭтаФорма);
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// ПРОЦЕДУРЫ - ДЕЙСТВИЯ КОМАНДНЫХ ПАНЕЛЕЙ ФОРМЫ

Функция ОчиститьТабличныеЧасти()
	
		ТекстВопроса = НСтр("ru='Табличные части будут очищены. Продолжить?';uk='Табличні частини будуть очищені. Продовжити?'");
		Ответ = Вопрос(ТекстВопроса, РежимДиалогаВопрос.ДаНет, , КодВозвратаДиалога.Да,);
		
		Если Ответ <> КодВозвратаДиалога.Да Тогда
			Возврат Ложь;
		КонецЕсли; 
		
		РаботникиОрганизации.Очистить();
		НДФЛ.Очистить();
		
		Возврат Истина;
		
КонецФункции

Процедура ДействияФормыОчистить(Кнопка)
	
		ОчиститьТабличныеЧасти();
		
КонецПроцедуры


// Процедура вызывается при выборе пункта подменю "Движения документа по регистрам" меню "Перейти".
// командной панели формы. Процедура отрабатывает печать движений документа по регистрам.
//
Процедура ДействияФормыДвиженияДокументаПоРегистрам(Кнопка)

	РаботаСДиалогами.НапечататьДвиженияДокумента(Ссылка);

КонецПроцедуры // ДействияФормыДвиженияДокументаПоРегистрам()

////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ РЕКВИЗИТОВ ШАПКИ

// Процедура - обработчик события "ПриИзменении" поля ввода даты документа.
//
Процедура ДатаПриИзменении(Элемент)

	РаботаСДиалогами.ПроверитьНомерДокумента(ЭтотОбъект, мТекущаяДатаДокумента);

	мТекущаяДатаДокумента = Дата;
	
КонецПроцедуры // ДатаПриИзменении


Процедура ОрганизацияОбработкаВыбора(Элемент, ВыбранноеЗначение, СтандартнаяОбработка)
	
	Если НЕ ОчиститьТабличныеЧасти() Тогда
		СтандартнаяОбработка = Ложь;
    КонецЕсли;

КонецПроцедуры


// Процедура - обработчик события "ПриИзменении" поля ввода периода взаиморасчетов
Процедура ПериодРегистрацииПриИзменении(Элемент)
    ПериодРегистрации = НачалоМесяца(ПериодРегистрации);
КонецПроцедуры

// Процедура - обработчик события "Регулирование" поля ввода периода взаиморасчетов
Процедура ПериодРегистрацииРегулирование(Элемент, Направление, СтандартнаяОбработка)
	
	Если Направление = 1 Тогда // увеличиваем значение
		ПериодРегистрации = КонецМесяца(ПериодРегистрации) + 1
	Иначе // = -1 - уменьшаем значение
		ПериодРегистрации = НачалоМесяца(ПериодРегистрации - 1)
	КонецЕсли;
	СтандартнаяОбработка = Ложь;
	
КонецПроцедуры

Процедура ВыбПериодНажатие(Элемент)
	
	НастройкаПериода = Новый НастройкаПериода;
	НастройкаПериода.УстановитьПериод(НалоговыйПериодНачало, ?(НалоговыйПериодКонец='00010101', НалоговыйПериодКонец, КонецДня(НалоговыйПериодКонец)));
	НастройкаПериода.РедактироватьКакИнтервал = Истина;
	НастройкаПериода.РедактироватьКакПериод = Истина;
	НастройкаПериода.ВариантНастройки = ВариантНастройкиПериода.Период;
	НастройкаПериода.Редактировать();
	
	НалоговыйПериодНачало	= НачалоМесяца( НастройкаПериода.ПолучитьДатуНачала() );
	НалоговыйПериодКонец	= КонецМесяца( НастройкаПериода.ПолучитьДатуОкончания() );
	
КонецПроцедуры


////////////////////////////////////////////////////////////////////////////////
// ПРОЦЕДУРЫ - ОБРАБОТЧИКИ СОБЫТИЙ ТАБЛИЧНОГО ПОЛЯ

Процедура КоманднаяПанельРаботникиОрганизацииПереключитьОтборСписка(Кнопка)
	
	Если ЭлементыФормы.КоманднаяПанельРаботникиОрганизации.Кнопки.ПереключитьОтборСписка.Текст = "/ Все сотрудники /" Тогда
		// отключим отбор
		ЭлементыФормы.НДФЛ.ОтборСтрок.Физлицо.Использование                     = Ложь;
		
		ЭлементыФормы.КоманднаяПанельРаботникиОрганизации.Кнопки.ПереключитьОтборСписка.Текст = "/ По сотруднику /";
		
	Иначе
		
		Если ЭлементыФормы.РаботникиОрганизации.ТекущаяСтрока <> Неопределено Тогда
			ТекущееФизЛицо = ЭлементыФормы.РаботникиОрганизации.ТекущаяСтрока.ФизЛицо;
			
			// установим отбор
			
			ЭлементыФормы.НДФЛ.ОтборСтрок.Физлицо.Использование                     = Истина;
			ЭлементыФормы.НДФЛ.ОтборСтрок.Физлицо.Значение                          = ТекущееФизЛицо;
			
			ЭлементыФормы.КоманднаяПанельРаботникиОрганизации.Кнопки.ПереключитьОтборСписка.Текст = "/ Все сотрудники /";
			
		Иначе
			Сообщить(НСтр("ru='В таблице сотрудников не выбрана строка!';uk='У таблиці співробітників не обраний рядок!'")) 
		КонецЕсли; 
		
	КонецЕсли;
	
КонецПроцедуры

 
// Процедура - обработчик оповещения о выборе, присланного формой рег-ра сведений
//
Процедура РаботникиОрганизацииОбработкаВыбора(Элемент, ВыбранноеЗначение, СтандартнаяОбработка)
	
	Если ТипЗнч(ВыбранноеЗначение) <> Тип("Структура") Тогда
		Возврат;
	КонецЕсли;
	Элемент.ТекущаяСтрока.Физлицо = ВыбранноеЗначение.Физлицо;
	СтандартнаяОбработка = Ложь;
	
КонецПроцедуры

Процедура РаботникиОрганизацииПриАктивизацииСтроки(Элемент)
			
	ТекущаяСтрока = Элемент.ТекущаяСтрока;
	
	Если ТекущаяСтрока = Неопределено Тогда
		мТекущееФизЛицо = Неопределено;
		Возврат;
	КонецЕсли;
	
		
	// запомним текущего сотрудника
	мТекущееФизЛицо = ТекущаяСтрока.ФизЛицо;
	
	ЭлементыФормы.НДФЛ.ОтборСтрок.ФизЛицо.Значение = мТекущееФизЛицо;


КонецПроцедуры

Процедура КоманднаяПанельРаботникиОрганизацииЗаполнить(Кнопка)

	Если НЕ ЗаписатьДокументОтменивПроведение("заполнить") Тогда
		Возврат;
	КонецЕсли; 
	
	НачатьТранзакцию();
	
	ЗадаватьВопрос = Истина;
	
	АвтозаполнениеРаботникиОрганизации();
	
	ЗафиксироватьТранзакцию();	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ ТАБЛИЧНОЙ ЧАСТИ РаботникиОрганизации

// Процедура - обработчик события "НачалоВыбора" поля ввода физлица
// переопеределим выбор физлица на выбор из списка регистра сведений
//
Процедура РаботникиОрганизацииФизЛицоНачалоВыбора(Элемент, СтандартнаяОбработка)
	ПроцедурыУправленияПерсоналом.ОткрытьФормуВыбораРаботникаОрганизации(ЭлементыФормы.РаботникиОрганизации, СтандартнаяОбработка, Ссылка, ПериодРегистрации, Организация, Справочники.ПодразделенияОрганизаций.ПустаяСсылка(),Истина);
КонецПроцедуры                                                                                            

// Процедура - обработчик события "АвтоПодборТекста" поля ввода физлица
// переопеределим выбор физлица на выбор из списка регистра сведений
//
Процедура РаботникиОрганизацииФизЛицоАвтоПодборТекста(Элемент, Текст, ТекстАвтоПодбора, СтандартнаяОбработка)
	ТекстАвтоПодбора = ПроцедурыУправленияПерсоналом.ПодобратьФИОРаботникаКандидата("РаботникиОрганизации", Текст, Организация);
	СтандартнаяОбработка = Ложь;
КонецПроцедуры

// Процедура - обработчик события "ОкончаниеВводаТекста" поля ввода физлица
// переопеределим выбор физлица на выбор из списка регистра сведений
//
Процедура РаботникиОрганизацииФизЛицоОкончаниеВводаТекста(Элемент, Текст, Значение, СтандартнаяОбработка)
	Значение = ПроцедурыУправленияПерсоналом.ПодобратьСписокРаботниковКандидатов("РаботникиОрганизации", Текст, Элемент.Значение, Организация);
	СтандартнаяОбработка = (Значение = Неопределено);
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

Процедура НДФЛПриАктивизацииСтроки(Элемент)
			
	ТекущаяСтрока = Элемент.ТекущаяСтрока;
	
	Если ТекущаяСтрока = Неопределено Тогда
		мТекущееФизЛицо = Неопределено;
		Возврат;
	КонецЕсли;
	
		
	// запомним текущего сотрудника
	мТекущееФизЛицо = ТекущаяСтрока.ФизЛицо;
	
	ЭлементыФормы.РаботникиОрганизации.ОтборСтрок.ФизЛицо.Значение = мТекущееФизЛицо;


КонецПроцедуры

Процедура КоманднаяПанельНДФЛЗаполнить(Кнопка)
	Перем НеобходимыеДанные;
	
	НачатьТранзакцию();
	
	масФизЛицо = НеобходимыеДанные.масФизЛицо;
	
	НеобходимыеДанные.Вставить("НеобходимНаборНДФЛ"                    , Истина);
	ПроведениеРасчетов.ЗаполнитьНаборы( НеобходимыеДанные );
	
	ПроведениеРасчетов.АвтозаполнениеНДФЛ( НеобходимыеДанные );
  
	ПроведениеРасчетов.ОчиститьНаборы( НеобходимыеДанные );
	
	ЗафиксироватьТранзакцию();	
	
КонецПроцедуры

Процедура КоманднаяПанельНДФЛРассчитать(Кнопка)
	Перем НеобходимыеДанные;
	
	НачатьТранзакцию();
	ЗаписатьДокументОтменивПроведение();
	
	масФизЛицо = НеобходимыеДанные.масФизЛицо;
	//удаляем только сторно-записи
	
	НеобходимыеДанные.Вставить("НеобходимНаборНДФЛ"	, Истина);
	ПроведениеРасчетов.ЗаполнитьНаборы( НеобходимыеДанные );
	
	ИмяРегистратора = Ссылка.Метаданные().Имя;
	
  	НеобходимыеДанные.Вставить("МинимальнаяДата"	, НалоговыйПериодНачало);
	НеобходимыеДанные.Вставить("МаксимальнаяДата"	, НалоговыйПериодКонец);

	ПроведениеРасчетов.РассчитатьНДФЛ( НеобходимыеДанные, НДФЛ );

	ПроведениеРасчетов.ОчиститьНаборы( НеобходимыеДанные );
	
	ЗафиксироватьТранзакцию();	
КонецПроцедуры

Процедура НДФЛПриВыводеСтроки(Элемент, ОформлениеСтроки, ДанныеСтроки)
	
	Если ДанныеСтроки.Сторно Тогда
	
		ОформлениеСтроки.ЦветТекста = Новый Цвет(255, 0, 0);
	
	КонецЕсли;
	
КонецПроцедуры














