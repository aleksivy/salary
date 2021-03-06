////////////////////////////////////////////////////////////////////////////////
// ПЕРЕМЕННЫЕ МОДУЛЯ

// Хранит текущую дату документа - для проверки перехода документа в другой период установки номера
Перем мТекущаяДатаДокумента; 

////////////////////////////////////////////////////////////////////////////////
// ВСПОМОГАТЕЛЬНЫЕ ПРОЦЕДУРЫ

Процедура ПроверитьДокументыВведенныеНаОсновании()
	
	ЗапросПоПлатежнымДокументам = Новый Запрос;
	ЗапросПоПлатежнымДокументам.УстановитьПараметр("Ведомость", Ссылка);
	
	ТекстЗапроса = 
	"ВЫБРАТЬ
	|	СУММА(ВложенныйЗапрос.Ведомость) КАК КоличествоДокументов
	|ИЗ
	|	(ВЫБРАТЬ
	|		КОЛИЧЕСТВО(РАЗЛИЧНЫЕ РасходныйКассовыйОрдерВыплатаЗаработнойПлаты.Ведомость) КАК Ведомость
	|	ИЗ
	|		Документ.РасходныйКассовыйОрдер.ВыплатаЗаработнойПлаты КАК РасходныйКассовыйОрдерВыплатаЗаработнойПлаты
	|	
	|	ГДЕ
	|		РасходныйКассовыйОрдерВыплатаЗаработнойПлаты.Ведомость = &Ведомость И
	|		(РасходныйКассовыйОрдерВыплатаЗаработнойПлаты.Ссылка.Проведен)
	|	
	|	ОБЪЕДИНИТЬ ВСЕ
	|	
	|	ВЫБРАТЬ
	|		КОЛИЧЕСТВО(РАЗЛИЧНЫЕ ПлатежноеПоручениеИсходящееПеречислениеЗаработнойПлаты.Ведомость)
	|	ИЗ
	|		Документ.ПлатежноеПоручениеИсходящее.ВыплатаЗаработнойПлаты КАК ПлатежноеПоручениеИсходящееПеречислениеЗаработнойПлаты
	|	
	|	ГДЕ
	|		ПлатежноеПоручениеИсходящееПеречислениеЗаработнойПлаты.Ведомость = &Ведомость И
	|		(ПлатежноеПоручениеИсходящееПеречислениеЗаработнойПлаты.Ссылка.Проведен)) КАК ВложенныйЗапрос";
	
	ЗапросПоПлатежнымДокументам.Текст = ТекстЗапроса;
	
	РезультатЗапроса = ЗапросПоПлатежнымДокументам.Выполнить().Выбрать();
	
	Если РезультатЗапроса.Следующий() Тогда
		
		Если РезультатЗапроса.КоличествоДокументов > 0 Тогда
			
			ЭтаФорма.ТолькоПросмотр = Истина
			
		КонецЕсли; 
		
	КонецЕсли; 
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ ФОРМЫ

Процедура ПередОткрытием(Отказ, СтандартнаяОбработка)
	
	Если ЭтоНовый() Тогда
		Отказ = Истина;
		Предупреждение(НСтр("ru='Документ больше не используется в работе.';uk='Документ більше не використовується в роботі.'"),10);
		Возврат;
	КонецЕсли;

КонецПроцедуры


Процедура ПриОткрытии()

	Если ЭтоНовый() Тогда // проверить объект на то, что он еще не внесен в ИБ
		
		// Заполнить реквизиты значениями по умолчанию.
		ЗаполнениеДокументов.ЗаполнитьШапкуДокумента(ЭтотОбъект);
		
        СпособВыплаты = Перечисления.СпособыВыплатыЗарплаты.ЧерезКассу;
		РегулярнаяВыплата = Истина;
		
	Иначе
		
		ПроверитьДокументыВведенныеНаОсновании()
		
	КонецЕсли;
	
	СтруктураКолонок = Новый Структура();

	// Установить колонки, видимостью которых пользователь управлять не может.
	СтруктураКолонок.Вставить("ФизЛицо");
	СтруктураКолонок.Вставить("Сумма");

	// Установить ограничение - изменять видимоть колонок для таличной части Зарплата
	ОбработкаТабличныхЧастей.УстановитьИзменятьВидимостьКолонокТабЧасти(ЭлементыФормы.НДФЛ.Колонки, СтруктураКолонок);

	// Активизируем табличную часть
	ТекущийЭлемент = ЭлементыФормы.Организация;

	// Вывести в заголовке формы статус документа (новый, не проведен, проведен).
	РаботаСДиалогами.УстановитьЗаголовокФормыДокумента(, ЭтотОбъект, ЭтаФорма);
	
	// Запомнить текущие значения реквизитов формы.
	мТекущаяДатаДокумента = Дата;

	ЗаполнитьСписокВзносов();
	ПолеВыбораВзносыПриИзменении();
	
КонецПроцедуры

Процедура ПослеЗаписи()
	// Вывести в заголовке формы статус документа (новый, не проведен, проведен).
	РаботаСДиалогами.УстановитьЗаголовокФормыДокумента(, ЭтотОбъект, ЭтаФорма);
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// ПРОЦЕДУРЫ - ДЕЙСТВИЯ КОМАНДНЫХ ПАНЕЛЕЙ ФОРМЫ

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

Процедура ДействияФормыОчистить(Кнопка)
	
	ТекстВопроса = НСтр("ru='Табличная часть будет очищена. Продолжить?';uk='Таблична частина буде очищена. Продовжити?'");
	Ответ = Вопрос(ТекстВопроса, РежимДиалогаВопрос.ДаНет, 60, КодВозвратаДиалога.Да,);
	
	Если Ответ <> КодВозвратаДиалога.Да Тогда
		Возврат;
	КонецЕсли; 
	
	РаботникиОрганизации.Очистить();
	Начисления.Очистить();
	Взносы.Очистить();   
	ПлатежиПоВзносам.Очистить();
	НДФЛ.Очистить();
		
КонецПроцедуры

Процедура ДействияФормыЗаполнить(Кнопка)
	
	НачатьТранзакцию();
	//
	//ТекстВопроса = "Табличные части будут очищены. Продолжить?";
	//Ответ = Вопрос(ТекстВопроса, РежимДиалогаВопрос.ДаНет, , КодВозвратаДиалога.Да,);

	Если НЕ ЗаписатьДокументОтменивПроведение("заполнить") Тогда
		Возврат;
	КонецЕсли; 
	
	РаботникиОрганизации.Очистить();
	Начисления.Очистить();
	Взносы.Очистить();
	ПлатежиПоВзносам.Очистить();
	НДФЛ.Очистить();
	
	АвтозаполнениеРаботники();
	ЗаполнитьАнализПлатежиЗП();
	Записать();
	ЗаполнитьАнализПлатежиВзносов();
	ЗаполнитьАнализПлатежиНДФЛ();
	
	ЗаполнитьСписокВзносов();
	ПолеВыбораВзносыПриИзменении();
	
	ЗафиксироватьТранзакцию();	
	
КонецПроцедуры


////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ РЕКВИЗИТОВ ШАПКИ

// Процедура - обработчик события "ПриИзменении" поля ввода даты документа.
//
Процедура ДатаПриИзменении(Элемент)

	РаботаСДиалогами.ПроверитьНомерДокумента(ЭтотОбъект, мТекущаяДатаДокумента);

	мТекущаяДатаДокумента = Дата;

КонецПроцедуры // ДатаПриИзменении

// Процедура - обработчик события "Регулирование" поля ввода периода регистрации.
//
Процедура ПериодРегистрацииРегулирование(Элемент, Направление, СтандартнаяОбработка)
	
	Если Направление = 1 Тогда // увеличиваем значение
		ПериодРегистрации = КонецМесяца(ПериодРегистрации) + 1
	Иначе // = -1 - уменьшаем значение
		ПериодРегистрации = НачалоМесяца(ПериодРегистрации - 1)
	КонецЕсли;
	
	СтандартнаяОбработка = Ложь;
	
КонецПроцедуры

// Процедура - обработчик события "ПриИзменении" поля ввода периода регистрации.
//
Процедура ПериодРегистрацииПриИзменении(Элемент)
    ПериодРегистрации = НачалоМесяца(ПериодРегистрации)
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

Процедура КоманднаяПанельНачисленияЗаполнить(Кнопка)
	
	Если НЕ ЗаписатьДокументОтменивПроведение("заполнить") Тогда
		Возврат;
	КонецЕсли; 
	
	НачатьТранзакцию();
	
	ТекстВопроса = НСтр("ru='Табличные части ""Начисления"" будут очищены. Продолжить?';uk='Табличні частини ""Нарахування"" будуть очищені. Продовжити?'");
	Ответ = Вопрос(ТекстВопроса, РежимДиалогаВопрос.ДаНет, , КодВозвратаДиалога.Да,);
	
	Если Ответ <> КодВозвратаДиалога.Да Тогда
		Возврат;
	КонецЕсли; 
	Начисления.Очистить();
	
	ЗаполнитьАнализПлатежиЗП();
	
	ЗафиксироватьТранзакцию();	
	
КонецПроцедуры

Процедура КоманднаяПанельВзносыЗаполнить(Кнопка)
	
	Если НЕ ЗаписатьДокументОтменивПроведение("заполнить") Тогда
		Возврат;
	КонецЕсли; 
	
	НачатьТранзакцию();
	
	ТекстВопроса = НСтр("ru='Табличная часть ""Взносы"" будет очищена. Продолжить?';uk='Таблична частина ""Внески"" буде очищена. Продовжити?'");
	Ответ = Вопрос(ТекстВопроса, РежимДиалогаВопрос.ДаНет, , КодВозвратаДиалога.Да,);
	
	Если Ответ <> КодВозвратаДиалога.Да Тогда
		Возврат;
	КонецЕсли; 
	Взносы.Очистить();
	ПлатежиПоВзносам.Очистить();
	
	ЗаполнитьАнализПлатежиВзносов();
	
	ЗаполнитьСписокВзносов();
	ПолеВыбораВзносыПриИзменении();
	
	ЗафиксироватьТранзакцию();	
	
КонецПроцедуры

Процедура КоманднаяПанельНДФЛЗаполнить(Кнопка)
	
	Если НЕ ЗаписатьДокументОтменивПроведение("заполнить") Тогда
		Возврат;
	КонецЕсли; 
	
	НачатьТранзакцию();
	
	ТекстВопроса = НСтр("ru='Табличная часть ""НДФЛ"" будет очищена. Продолжить?';uk='Таблична частина ""ПДФО"" буде очищена. Продовжити?'");
	Ответ = Вопрос(ТекстВопроса, РежимДиалогаВопрос.ДаНет, , КодВозвратаДиалога.Да,);
	
	Если Ответ <> КодВозвратаДиалога.Да Тогда
		Возврат;
	КонецЕсли; 
	НДФЛ.Очистить();
	
	ЗаполнитьАнализПлатежиНДФЛ();
	
	ЗафиксироватьТранзакцию();	
	
КонецПроцедуры

Процедура КоманднаяПанельРаботникиЗаполнить(Кнопка)
	
	Если НЕ ЗаписатьДокументОтменивПроведение("заполнить") Тогда
		Возврат;
	КонецЕсли; 
	
	НачатьТранзакцию();
	
	ЗадаватьВопрос = Истина;
	
	// необходимо перезаполнить работников
	АвтозаполнениеРаботники();
	
	ЗафиксироватьТранзакцию();	
	

КонецПроцедуры

Процедура ПанельВыплатИНалоговПриСменеСтраницы(Элемент, ТекущаяСтраница)
	Если Элемент.ТекущаяСтраница.Имя =  "Начисления" Тогда
		ЭлементыФормы.ПанельАвансы.ТекущаяСтраница =  ЭлементыФормы.ПанельАвансы.Страницы.Начисления
	ИначеЕсли Элемент.ТекущаяСтраница.Имя =  "Взносы" Тогда
		ЭлементыФормы.ПанельАвансы.ТекущаяСтраница =  ЭлементыФормы.ПанельАвансы.Страницы.Взносы
	ИначеЕсли Элемент.ТекущаяСтраница.Имя =  "НДФЛ" Тогда
		ЭлементыФормы.ПанельАвансы.ТекущаяСтраница =  ЭлементыФормы.ПанельАвансы.Страницы.НДФЛ
	КонецЕсли;
КонецПроцедуры


Функция ПолучитьСписокСтатейДекарации() Экспорт

	СписокЭлементовПеречисления = Новый СписокЗначений;
	СписокЭлементовПеречисления.Добавить(Неопределено, "По всем");
	
	ТЗ = ПлатежиПоВзносам.Выгрузить();
	ТЗ.Свернуть("СтатьяНалоговойДекларации");

	Для каждого СтрокаТЗ Из ТЗ Цикл
		СписокЭлементовПеречисления.Добавить(СтрокаТЗ.СтатьяНалоговойДекларации, "");
	КонецЦикла;
	ТЗ = "";
	
	Возврат СписокЭлементовПеречисления;

КонецФункции // ОбщегоНазначения.ПолучитьСписокЭлементовПеречисления()


Процедура ЗаполнитьСписокВзносов()
	ЭлементыФормы.ПолеВыбораВзносы.СписокВыбора = ПолучитьСписокСтатейДекарации();
КонецПроцедуры

Процедура ПолеВыбораВзносыПриИзменении()
	
	Если ЭлементыФормы.ПолеВыбораВзносы.Значение = Неопределено Тогда
		ЭлементыФормы.АвансыВзносы.ОтборСтрок.СтатьяНалоговойДекларации.Использование = Ложь;
		
	Иначе
		ЭлементыФормы.АвансыВзносы.ОтборСтрок.СтатьяНалоговойДекларации.Использование = Истина;
		ЭлементыФормы.АвансыВзносы.ОтборСтрок.СтатьяНалоговойДекларации.Значение		= ЭлементыФормы.ПолеВыбораВзносы.Значение;
		
	КонецЕсли; 
	
КонецПроцедуры


Процедура ВычислитьНераспределенныйНДФЛ()
	
	ЭлементыФормы.НеподтвержденныйНДФЛ.Значение = ЭлементыФормы.ПеречисленныйНДФЛ.Значение - НДФЛ.Итог("Налог");
	
КонецПроцедуры

Процедура НДФЛНалогПриИзменении(Элемент)
	
	ВычислитьНераспределенныйНДФЛ();
	
КонецПроцедуры



Процедура ВзносыВзносПриИзменении(Элемент)
	
	табПлатежиПоВзносам = Новый ТаблицаЗначений;
	табПлатежиПоВзносам = Взносы.Выгрузить();
	табПлатежиПоВзносам.Свернуть("СтатьяНалоговойДекларации", "База, БазаВзноса, Взнос");
	
	СтрокаТаблицы			= табПлатежиПоВзносам.Найти( ЭлементыФормы.Взносы.ТекущиеДанные.СтатьяНалоговойДекларации, "СтатьяНалоговойДекларации");
	ЗаполнитьСтроку_ВзносПриИзменении(СтрокаТаблицы, ЭлементыФормы.Взносы.ТекущиеДанные.СтатьяНалоговойДекларации);
	
	табПлатежиПоВзносам = "";
	
КонецПроцедуры























