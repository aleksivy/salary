////////////////////////////////////////////////////////////////////////////////
// ПЕРЕМЕННЫЕ МОДУЛЯ

Перем мТекущаяДатаДокумента; // Хранит текущую дату документа - для проверки перехода документа в другой период установки номера

// Хранит ссылку на головную организацию
Перем мГоловнаяОрганизация;

// Хранит дерево макетов печатных форм
Перем мДеревоМакетов;

// Хранит элемент управления подменю печати
Перем мПодменюПечати;

// Хранит элемент управления кнопку печать по умолчанию
Перем мПечатьПоУмолчанию;

// Хранит дерево кнопок подменю заполнение ТЧ
Перем мКнопкиЗаполненияТЧ;


////////////////////////////////////////////////////////////////////////////////
// ВСПОМОГАТЕЛЬНЫЕ ПРОЦЕДУРЫ

// Процедура устанавливает подменю "Заполнить" в командных панелях ТЧ документа при необходимости
//
Процедура УстановитьКнопкиПодменюЗаполненияТЧ()
	
	мКнопкиЗаполненияТЧ = УниверсальныеМеханизмы.ПолучитьДеревоКнопокЗаполненияТабличныхЧастей(Ссылка,Новый Действие("НажатиеНаДополнительнуюКнопкуЗаполненияТЧ"));
	
	СоответствиеТЧ = Новый Соответствие;
	СоответствиеТЧ.Вставить(ЭлементыФормы.Доходы,ЭлементыФормы.КоманднаяПанель1);
	
	УниверсальныеМеханизмы.СформироватьПодменюЗаполненияТЧПоДеревуКнопок(мКнопкиЗаполненияТЧ,СоответствиеТЧ);	
КонецПроцедуры // УстановитьКнопкиПодменюЗаполненияТЧ()

// Процедура устанавливает подменю "Печать" и кнопку "Печать по умолчанию" при необходимости
//
Процедура УстановитьКнопкиПечати()
	
	ФормированиеПечатныхФорм.СоздатьКнопкиПечати(ЭтотОбъект, ЭтаФорма);	
	
КонецПроцедуры

Процедура УстановитьВидимость()
	
	//Отключаем видимость всех элементов
	ЭлементыФормы.НадписьНазначениеСправки.Видимость = Ложь;
	ЭлементыФормы.НазначениеСправки.Видимость = Ложь;
		
	ЭлементыФормы.Доходы.Колонки.ОтработаноДней.Видимость = Ложь;
	ЭлементыФормы.Доходы.Колонки.ВсегоОблагаемое.Видимость = Ложь;
	ЭлементыФормы.Доходы.Колонки.Предел.Видимость = Ложь;
	ЭлементыФормы.Доходы.Колонки.РезультатВсего.Видимость = Ложь;
	ЭлементыФормы.Доходы.Колонки.РезультатОсновное.Видимость = Ложь;
	ЭлементыФормы.Доходы.Колонки.РезультатСовместительство.Видимость = Ложь;
		
	ЭлементыФормы.Доходы.Колонки.СовокупныйДоход.Видимость = Ложь;
	ЭлементыФормы.Доходы.Колонки.СуммаКВыплате.Видимость = Ложь;
	ЭлементыФормы.Доходы.Колонки.Удержания.Видимость = Ложь;
		
	ЭлементыФормы.Доходы.Колонки.НачисленоЗП.Видимость = Ложь;
	ЭлементыФормы.Доходы.Колонки.НачисленоПрочее.Видимость = Ложь;
	ЭлементыФормы.Доходы.Колонки.Алименты.Видимость = Ложь;
		
	ЭлементыФормы.Доходы.Колонки.КалендарныеДни.Видимость = Ложь;
	ЭлементыФормы.Доходы.Колонки.РезультатВзносы.Видимость = Ложь;
		
	ЭлементыФормы.Доходы.Колонки.ДоходНДФЛ.Видимость = Ложь;
	ЭлементыФормы.Доходы.Колонки.НДФЛ.Видимость = Ложь;
	ЭлементыФормы.Доходы.Колонки.ОблагаемоеЕСВ.Видимость = Ложь;
	ЭлементыФормы.Доходы.Колонки.ОблагаемоеЕСВСУчетомПредела.Видимость = Ложь;
	ЭлементыФормы.Доходы.Колонки.Выплачено.Видимость = Ложь;
	ЭлементыФормы.НастройкаПечатнойФормыСправкиОДоходах.Видимость = Ложь;
	ЭлементыФормы.Доходы.Колонки.ПризнакСоциальнойЛьготы.Видимость = Ложь;
	ЭлементыФормы.Доходы.Колонки.СуммаНалоговойЛьготы.Видимость = Ложь;
		
	ЭлементыФормы.Доходы.Колонки.ДоходВоенныйСбор.Видимость = Ложь;
	ЭлементыФормы.Доходы.Колонки.ВоенныйСбор.Видимость = Ложь;
	ЭлементыФормы.Доходы.Колонки.ДоходЗаВычетомНДФЛ.Видимость = Ложь;

	ЭлементыФормы.Доходы.Колонки.НДФЛПрочее.Видимость = Ложь;
	
	ЭлементыФормы.Доходы.Колонки.СтавкаВзносов.Видимость = Ложь;
	
	//Включаем видимость нужных элементов
	Если ВидСправки = Перечисления.ВидыСправокОДоходах.Произвольная Тогда
		
		ЭлементыФормы.НадписьНазначениеСправки.Видимость = Истина;
		ЭлементыФормы.НазначениеСправки.Видимость = Истина;
		ЭлементыФормы.Доходы.Колонки.СовокупныйДоход.Видимость = Истина;
		ЭлементыФормы.Доходы.Колонки.СуммаКВыплате.Видимость = Истина;
		ЭлементыФормы.Доходы.Колонки.Удержания.Видимость = Истина;
// Серна - Начало
		ЭлементыФормы.Доходы.Колонки.НачисленоПрочее.Видимость = Истина;
// Серна - Конец
		
	ИначеЕсли ВидСправки = Перечисления.ВидыСправокОДоходах.Соцстрах Тогда
		
		ЭлементыФормы.Доходы.Колонки.ОтработаноДней.Видимость = Истина;
		ЭлементыФормы.Доходы.Колонки.ВсегоОблагаемое.Видимость = Истина;
		ЭлементыФормы.Доходы.Колонки.Предел.Видимость = Истина;
		ЭлементыФормы.Доходы.Колонки.РезультатВсего.Видимость = Истина;
		ЭлементыФормы.Доходы.Колонки.РезультатОсновное.Видимость = Истина;
		ЭлементыФормы.Доходы.Колонки.РезультатСовместительство.Видимость = Истина;
		
// Серна - Начало
	ИначеЕсли (ВидСправки = Перечисления.ВидыСправокОДоходах.Безработица) или (ВидСправки = Перечисления.ВидыСправокОДоходах.БезработицаСОграничениями) Тогда
// Серна - Конец
		
		ЭлементыФормы.Доходы.Колонки.ВсегоОблагаемое.Видимость = Истина;
		ЭлементыФормы.Доходы.Колонки.ВсегоОблагаемое.Доступность = Истина;
		ЭлементыФормы.Доходы.Колонки.Предел.Видимость = Истина;
		ЭлементыФормы.Доходы.Колонки.РезультатВсего.Видимость = Истина;
		ЭлементыФормы.Доходы.Колонки.КалендарныеДни.Видимость = Истина;
		ЭлементыФормы.Доходы.Колонки.РезультатВзносы.Видимость = Истина;	
		
	ИначеЕсли ВидСправки = Перечисления.ВидыСправокОДоходах.Пенсия Тогда
		
		ЭлементыФормы.Доходы.Колонки.ВсегоОблагаемое.Видимость = Истина;
		ЭлементыФормы.Доходы.Колонки.Предел.Видимость = Истина;
		ЭлементыФормы.Доходы.Колонки.РезультатВсего.Видимость = Истина;
		
	ИначеЕсли ВидСправки = Перечисления.ВидыСправокОДоходах.Субсидия Тогда
		
		ЭлементыФормы.Доходы.Колонки.СовокупныйДоход.Видимость = Истина;
		ЭлементыФормы.Доходы.Колонки.НачисленоЗП.Видимость = Истина;
		ЭлементыФормы.Доходы.Колонки.НачисленоПрочее.Видимость = Истина;
		ЭлементыФормы.Доходы.Колонки.Алименты.Видимость = Истина;
	
	ИначеЕсли ВидСправки = Перечисления.ВидыСправокОДоходах.ДоходыИНалоги Тогда
		
		ЭлементыФормы.Доходы.Колонки.РезультатВзносы.Видимость = Истина;
		ЭлементыФормы.Доходы.Колонки.ДоходНДФЛ.Видимость = Истина;
		ЭлементыФормы.Доходы.Колонки.НДФЛ.Видимость = Истина;
		ЭлементыФормы.Доходы.Колонки.ОблагаемоеЕСВ.Видимость = Истина;
		ЭлементыФормы.Доходы.Колонки.ОблагаемоеЕСВСУчетомПредела.Видимость = Истина;
		ЭлементыФормы.Доходы.Колонки.Выплачено.Видимость = Истина;
		ЭлементыФормы.НастройкаПечатнойФормыСправкиОДоходах.Видимость = Истина;
		ЭлементыФормы.Доходы.Колонки.ПризнакСоциальнойЛьготы.Видимость = Истина;
		ЭлементыФормы.Доходы.Колонки.СуммаНалоговойЛьготы.Видимость = Истина;
		ЭлементыФормы.Доходы.Колонки.ДоходВоенныйСбор.Видимость = Истина;
		ЭлементыФормы.Доходы.Колонки.ВоенныйСбор.Видимость = Истина;
		ЭлементыФормы.Доходы.Колонки.ДоходЗаВычетомНДФЛ.Видимость = Истина;
		
	ИначеЕсли ВидСправки = Перечисления.ВидыСправокОДоходах.Субсидия2015 Тогда
		
		ЭлементыФормы.Доходы.Колонки.СовокупныйДоход.Видимость = Истина;
		ЭлементыФормы.Доходы.Колонки.НачисленоЗП.Видимость = Истина;
		ЭлементыФормы.Доходы.Колонки.НачисленоПрочее.Видимость = Истина;
		ЭлементыФормы.Доходы.Колонки.НДФЛ.Видимость = Истина;
		ЭлементыФормы.Доходы.Колонки.НДФЛПрочее.Видимость = Истина;
		ЭлементыФормы.Доходы.Колонки.Алименты.Видимость = Истина;
		
	ИначеЕсли ВидСправки = Перечисления.ВидыСправокОДоходах.Соцстрах2015 Тогда	
		
		ЭлементыФормы.Доходы.Колонки.РезультатВсего.Видимость = Истина;
		ЭлементыФормы.Доходы.Колонки.КалендарныеДни.Видимость = Истина;
		ЭлементыФормы.Доходы.Колонки.РезультатВзносы.Видимость = Истина;
		ЭлементыФормы.Доходы.Колонки.СтавкаВзносов.Видимость = Истина;
		
	ИначеЕсли ВидСправки = Перечисления.ВидыСправокОДоходах.Пенсия2015 Тогда
		
		ЭлементыФормы.Доходы.Колонки.РезультатВсего.Видимость = Истина;	
		
// Серна - Начало
	ИначеЕсли ВидСправки = Перечисления.ВидыСправокОДоходах.СернаБанк Тогда
		ЭлементыФормы.НадписьНазначениеСправки.Видимость = Истина;
		ЭлементыФормы.НазначениеСправки.Видимость = Истина;
		
		
		ЭлементыФормы.Доходы.Колонки.РезультатВзносы.Видимость = Истина;
		ЭлементыФормы.Доходы.Колонки.ДоходНДФЛ.Видимость = Истина;
		ЭлементыФормы.Доходы.Колонки.НДФЛ.Видимость = Истина;
		ЭлементыФормы.Доходы.Колонки.ОблагаемоеЕСВ.Видимость = Истина;
		ЭлементыФормы.Доходы.Колонки.ОблагаемоеЕСВСУчетомПредела.Видимость = Истина;
		ЭлементыФормы.Доходы.Колонки.Выплачено.Видимость = Истина;
		ЭлементыФормы.НастройкаПечатнойФормыСправкиОДоходах.Видимость = Истина;
		ЭлементыФормы.Доходы.Колонки.ПризнакСоциальнойЛьготы.Видимость = Истина;
		ЭлементыФормы.Доходы.Колонки.СуммаНалоговойЛьготы.Видимость = Истина;
		ЭлементыФормы.Доходы.Колонки.ДоходВоенныйСбор.Видимость = Истина;
		ЭлементыФормы.Доходы.Колонки.ВоенныйСбор.Видимость = Истина;
		ЭлементыФормы.Доходы.Колонки.ДоходЗаВычетомНДФЛ.Видимость = Истина;
		
		ЭлементыФормы.Доходы.Колонки.СуммаКВыплате.Видимость = Ложь;
		
// Серна - Конец
	КонецЕсли;	
	
	
КонецПроцедуры
	

////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ ФОРМЫ

// Процедура - обработчик события "ПередОткрытием" формы.
//
Процедура ПередОткрытием(Отказ, СтандартнаяОбработка)
	
	// Установка кнопок печати
	УстановитьКнопкиПечати();
	
	// Установка кнопок заполнение ТЧ
	УстановитьКнопкиПодменюЗаполненияТЧ();
	
КонецПроцедуры // ПередОткрытием()

// Процедура - обработчик события "ПриОткрытии" формы.
Процедура ПриОткрытии()

	Если ЭтоНовый() Тогда // проверить объект на то, что он еще не внесен в ИБ
		
		// Заполнить реквизиты значениями по умолчанию.
		ЗаполнениеДокументов.ЗаполнитьШапкуДокумента(ЭтотОбъект);
		Если НЕ ЗначениеЗаполнено(Видсправки) Тогда
			ВидСправки = Перечисления.ВидыСправокОДоходах.Произвольная;
		КонецЕсли;	
		
	КонецЕсли;

	МеханизмНумерацииОбъектов.УстановитьДоступностьПоляВводаНомера(Метаданные(), ЭтаФорма, ЭлементыФормы.ДействияФормы.Кнопки.Подменю,ЭлементыФормы.Номер);

	СтруктураКолонок = Новый Структура();

	// Установить колонки, видимостью которых пользователь управлять не может.
	СтруктураКолонок.Вставить("Период");

	// Установить ограничение - изменять видимоть колонок для таличной части 
	ОбработкаТабличныхЧастей.УстановитьИзменятьВидимостьКолонокТабЧасти(ЭлементыФормы.Доходы.Колонки, СтруктураКолонок);

	// Активизируем табличную часть
	ТекущийЭлемент = ЭлементыФормы.Доходы;

	// Вывести в заголовке формы статус документа (новый, не проведен, проведен).
	РаботаСДиалогами.УстановитьЗаголовокФормыДокумента(, ЭтотОбъект, ЭтаФорма);

	// Запомнить текущие значения реквизитов формы.
	мТекущаяДатаДокумента = Дата;
	
	// Получим и запомним ссылку на головную организацию
	мГоловнаяОрганизация = ОбщегоНазначения.ГоловнаяОрганизация(Организация);
	
	РаботаСДиалогами.АктивизироватьРеквизитВФорме(ЭтотОбъект, ЭтаФорма);
	
	УстановитьВидимость();
	
КонецПроцедуры

// Процедура - обработчик события "ПослеЗаписи" формы.
Процедура ПослеЗаписи()
	
	// Установка кнопок печати
	УстановитьКнопкиПечати();
	
	// Вывести в заголовке формы статус документа (новый, не проведен, проведен).
	РаботаСДиалогами.УстановитьЗаголовокФормыДокумента(, ЭтотОбъект, ЭтаФорма);
	МеханизмНумерацииОбъектов.ОбновитьПодсказкуКодНомерОбъекта(ЭтотОбъект.Метаданные(), ЭлементыФормы.ДействияФормы.Кнопки.Подменю, ЭлементыФормы.Номер);
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// ПРОЦЕДУРЫ - ОБРАБОТЧИКИ СОБЫТИЙ РЕКВИЗИТОВ ШАПКИ

// Процедура - обработчик события "ПриИзменении" поля ввода даты документа
//
Процедура ДатаПриИзменении(Элемент = Неопределено)

	РаботаСДиалогами.ПроверитьНомерДокумента(ДокументОбъект, мТекущаяДатаДокумента);

	МеханизмНумерацииОбъектов.ОбновитьПодсказкуКодНомерОбъекта(ЭтотОбъект.Метаданные(), ЭлементыФормы.ДействияФормы.Кнопки.Подменю, ЭлементыФормы.Номер);
	
	мТекущаяДатаДокумента = Дата;
КонецПроцедуры // ДатаПриИзменении

////////////////////////////////////////////////////////////////////////////////
// ПРОЦЕДУРЫ - ОБРАБОТЧИКИ СОБЫТИЙ ТАБЛИЧНОГО ПОЛЯ

////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ РЕКВИЗИТОВ ТАБЛИЧНОЙ ЧАСТИ 

////////////////////////////////////////////////////////////////////////////////
// ПРОЦЕДУРЫ - ДЕЙСТВИЯ КОМАНДНЫХ ПАНЕЛЕЙ ФОРМЫ

// Процедура вызывается при при нажатии на кнопку "Заполнить" 
Процедура ДействияФормыЗаполнить(Кнопка)
	
	Если Доходы.Количество() > 0 Тогда
	
		ТекстВопроса = НСтр("ru='Перед заполнением табличная часть будет очищена. Заполнить?';uk='Перед заповненням таблична частина буде очищена. Заповнити?'");
		Ответ = Вопрос(ТекстВопроса, РежимДиалогаВопрос.ДаНет, , КодВозвратаДиалога.Да,);
		
		Если Ответ <> КодВозвратаДиалога.Да Тогда
			Возврат;
		КонецЕсли; 
		
	КонецЕсли;
	
	Если ВидСправки = Перечисления.ВидыСправокОДоходах.Произвольная Тогда
		АвтозаполнениеПроизвольная();
	ИначеЕсли ВидСправки = Перечисления.ВидыСправокОДоходах.Соцстрах Тогда	
		АвтозаполнениеСоцстрах();
	ИначеЕсли ВидСправки = Перечисления.ВидыСправокОДоходах.Безработица Тогда	
		АвтозаполнениеБезработица();
	ИначеЕсли ВидСправки = Перечисления.ВидыСправокОДоходах.Пенсия Тогда	
		АвтозаполнениеПенсия();	
	ИначеЕсли ВидСправки = Перечисления.ВидыСправокОДоходах.Субсидия Тогда	
		АвтозаполнениеСубсидия();
	ИначеЕсли ВидСправки = Перечисления.ВидыСправокОДоходах.Субсидия2015 Тогда	
		АвтозаполнениеСубсидия2015();
	ИначеЕсли ВидСправки = Перечисления.ВидыСправокОДоходах.Соцстрах2015 Тогда	
		АвтозаполнениеСоцстрах2015();
	ИначеЕсли ВидСправки = Перечисления.ВидыСправокОДоходах.Пенсия2015 Тогда	
		АвтозаполнениеПенсия2015();		
	ИначеЕсли ВидСправки = Перечисления.ВидыСправокОДоходах.ДоходыИНалоги Тогда	
		АвтозаполнениеДоходыИНалоги();
// Серна - Начало
	ИначеЕсли ВидСправки = Перечисления.ВидыСправокОДоходах.СернаБанк Тогда	
		АвтозаполнениеДоходыИНалоги();
	ИначеЕсли ВидСправки = Перечисления.ВидыСправокОДоходах.БезработицаСОграничениями Тогда	
		АвтозаполнениеБезработицаСОграничениями();
// Серна - Конец
	КонецЕсли;	

	Если Доходы.Количество() = 0 Тогда
		
		Сообщить(НСтр("ru='Не обнаружены данные для записи в табличную часть документа.';uk='Не виявлені дані для запису в табличну частину документа.'"), СтатусСообщения.Важное)
		
	КонецЕсли;
	
	//Дозаполним периоды
	ДатаТек = НачалоМесяца(ДатаНач);
	Пока ДатаТек <= ДатаКон Цикл
		СтрокаТЧ = Доходы.Найти(ДатаТек,"Период");
		Если СтрокаТЧ = Неопределено Тогда
			НС = Доходы.Добавить();
			НС.Период = ДатаТек;
// Серна - Начало
			Если (ВидСправки = Перечисления.ВидыСправокОДоходах.Безработица) или (ВидСправки = Перечисления.ВидыСправокОДоходах.БезработицаСОграничениями) Тогда
// Серна - Конец
				НС.КалендарныеДни = День(КонецМесяца(ДатаТек));
				Срез = Регистрысведений.СведенияОВзносахВФонды.СрезПоследних(ДатаТек,Новый Структура("Налог",Справочники.Налоги.Безработица));
				Если Срез.Количество() > 0 Тогда
					НС.Предел = Срез[0].Предел;
				КонецЕсли;	
			КонецЕсли;	
		КонецЕсли;
		ДатаТек = ДобавитьМесяц(ДатаТек,1);
	КонецЦикла;
	Доходы.Сортировать("Период");
	
КонецПроцедуры

// Процедура вызывается при при нажатии на кнопку "Очистить" 
Процедура ДействияФормыОчистить(Кнопка)
	
	ТекстВопроса = НСтр("ru='Табличная часть будет очищена. Продолжить?';uk='Таблична частина буде очищена. Продовжити?'");
	Ответ = Вопрос(ТекстВопроса, РежимДиалогаВопрос.ДаНет, , КодВозвратаДиалога.Да,);
	
	Если Ответ <> КодВозвратаДиалога.Да Тогда
		Возврат;
	КонецЕсли; 
	
	Доходы.Очистить();
		
КонецПроцедуры

// Процедура разрешения/запрещения редактирования номера документа
//
Процедура ДействияФормыРедактироватьНомер(Кнопка)
	
	МеханизмНумерацииОбъектов.ИзменениеВозможностиРедактированияНомера(ЭтотОбъект.Метаданные(), ЭтаФорма, ЭлементыФормы.ДействияФормы.Кнопки.Подменю, ЭлементыФормы.Номер);
			
КонецПроцедуры

// Процедура - обработчик нажатия на любую из дополнительных кнопок по заполнению ТЧ
//
Процедура НажатиеНаДополнительнуюКнопкуЗаполненияТЧ(Кнопка)
	
	УниверсальныеМеханизмы.ОбработатьНажатиеНаДополнительнуюКнопкуЗаполненияТЧ(мКнопкиЗаполненияТЧ.Строки.Найти(Кнопка.Имя,"Имя",Истина),ЭтотОбъект);
	
КонецПроцедуры // НажатиеНаДополнительнуюКнопкуЗаполненияТЧ()

// Процедура - обработчик нажатия на кнопку "Печать по умолчанию"
//
Процедура ОсновныеДействияФормыПечатьПоУмолчанию(Кнопка)
	
	УниверсальныеМеханизмы.ПечатьПоДополнительнойКнопке(мДеревоМакетов, ЭтотОбъект, ЭтаФорма, Кнопка.Текст);
	
КонецПроцедуры // ОсновныеДействияФормыПечатьПоУмолчанию()

// Процедура - обработчик нажатия на кнопку "Печать"
//
Процедура ОсновныеДействияФормыПечать(Кнопка)
	
	УниверсальныеМеханизмы.ПечатьПоДополнительнойКнопке(мДеревоМакетов, ЭтотОбъект, ЭтаФорма, Кнопка.Текст);
	
КонецПроцедуры // ОсновныеДействияФормыПечать()

// Процедура - обработчик нажатия на кнопку "Установить печать по умолчанию"
//
Процедура ОсновныеДействияФормыУстановитьПечатьПоУмолчанию(Кнопка)
	
	Если УниверсальныеМеханизмы.НазначитьКнопкуПечатиПоУмолчанию(мДеревоМакетов, Метаданные().Имя) Тогда
		УстановитьКнопкиПечати();
	КонецЕсли;
	
КонецПроцедуры // ОсновныеДействияФормыУстановитьПечатьПоУмолчанию()

Процедура НастройкаПечатнойФормыСправкиОДоходахНажатие(Элемент)  
	Если НастройкиВыводаНаПечать.Количество() = 0 Тогда
		ОпределитьСтруктуруНастройкиВыводаНаПечать();
	КонецЕсли;	
    ФормаНастройки = ПолучитьФорму("ФормаНастройкиВыводаНаПечать");
	ФормаНастройки.ДокументОбъект = ЭтотОбъект;
	ФормаНастройки.ТабличнаяЧастьНастройки.Очистить();
	Для Каждого СтрокаНастройки Из НастройкиВыводаНаПечать Цикл
		НоваяСтрока = ФормаНастройки.ТабличнаяЧастьНастройки.Добавить();
		НоваяСтрока.ИмяКолонки 				= СтрокаНастройки.ИмяКолонки;
		НоваяСтрока.ИмяКолонкиДляПечати 	= СтрокаНастройки.ИмяКолонкиДляПечати;
		НоваяСтрока.ИтогиВПодвале 			= СтрокаНастройки.ИтогиВПодвале;
		НоваяСтрока.Выводить 				= СтрокаНастройки.Выводить;
	КонецЦикла;
	ФормаНастройки.Открыть();
КонецПроцедуры


Процедура ОрганизацияПриИзменении(Элемент)
	Если Не ПустаяСтрока(Номер) Тогда
		МеханизмНумерацииОбъектов.СброситьУстановленныйКодНомерОбъекта(ЭтотОбъект, "Номер", ЭлементыФормы.ДействияФормы.Кнопки.Подменю, ЭлементыФормы.Номер);
	КонецЕсли;
	
	// Получим и запомним ссылку на головную организацию
	мГоловнаяОрганизация = ОбщегоНазначения.ГоловнаяОрганизация(Организация);
	
КонецПроцедуры


Процедура КнопкаНастройкаПериодаНажатие(Элемент)
	Если НП.Редактировать() Тогда
		ДатаНач = НП.ПолучитьДатуНачала();
		ДатаКон = НП.ПолучитьДатуОкончания();
	КонецЕсли;
КонецПроцедуры

Процедура ДатаНачПриИзменении(Элемент)
	НП.УстановитьПериод(ДатаНач, КонецДня(ДатаКон), Истина);
КонецПроцедуры

Процедура ДатаКонПриИзменении(Элемент)
	НП.УстановитьПериод(ДатаНач, КонецДня(ДатаКон), Истина);
КонецПроцедуры

Процедура ДоходыСовокупныйДоходПриИзменении(Элемент)
	ЭлементыФормы.Доходы.ТекущаяСтрока.СуммаКВыплате = ЭлементыФормы.Доходы.ТекущаяСтрока.СовокупныйДоход -ЭлементыФормы.Доходы.ТекущаяСтрока.Удержания;
КонецПроцедуры     

Процедура ДоходыУдержанияПриИзменении(Элемент)
	ЭлементыФормы.Доходы.ТекущаяСтрока.СуммаКВыплате = ЭлементыФормы.Доходы.ТекущаяСтрока.СовокупныйДоход -ЭлементыФормы.Доходы.ТекущаяСтрока.Удержания;
КонецПроцедуры

Процедура СотрудникПриИзменении(Элемент)
	
// Серна - Начало
	Если Сотрудник <> Элемент.Значение Тогда
		Физлицо = Элемент.Значение.Физлицо;
		ТекстВопроса = НСтр("ru='Очистить табличную часть?';uk='Очистити табличну частину?'");
		
		Если Доходы.Количество() > 0 Тогда
			Ответ = Вопрос(ТекстВопроса, РежимДиалогаВопрос.ДаНет, , КодВозвратаДиалога.Да,);
			
			Если Ответ <> КодВозвратаДиалога.Да Тогда
				Возврат;
			КонецЕсли; 
			
			Доходы.Очистить();
		КонецЕсли;	
	КонецЕсли;	
// Серна - Конец
		
			
			

КонецПроцедуры

Функция ОчиститьТабличнуюЧасть()
	
	Если Доходы.Количество() > 0 Тогда
		
		ТекстВопроса = НСтр("ru='Табличная часть будет очищена. Продолжить?';uk='Таблична частина буде очищена. Продовжити?'");
		Ответ = Вопрос(ТекстВопроса, РежимДиалогаВопрос.ДаНет, , КодВозвратаДиалога.Да,);
		
		Если Ответ <> КодВозвратаДиалога.Да Тогда
			Возврат Ложь;
		КонецЕсли; 
		
		Доходы.Очистить();
		
	КонецЕсли;
	
	Возврат Истина;
		
КонецФункции



// Процедура - обработчик события "НачалоВыбора" поля ввода физлица
// переопеределим выбор физлица на выбор из списка регистра сведений
//
Процедура СотрудникНачалоВыбора(Элемент, СтандартнаяОбработка)
	
	ПроцедурыУправленияПерсоналом.ОткрытьФормуВыбораСотрудникаОрганизации(Элемент, Ссылка, Истина, Дата, Организация, 1, СтандартнаяОбработка, Элемент.Значение);
	
КонецПроцедуры // ФизлицоНачалоВыбора()

// Процедура - обработчик события "АвтоПодборТекста" поля ввода физлица
// переопеределим выбор физлица на выбор из списка регистра сведений
//
Процедура СотрудникАвтоПодборТекста(Элемент, Текст, ТекстАвтоПодбора, СтандартнаяОбработка)
	
	ТекстАвтоПодбора = ПроцедурыУправленияПерсоналом.ПодобратьФИОРаботникаКандидата(СтандартнаяОбработка, "РаботникиОрганизации", Текст, Организация);
	
КонецПроцедуры // ФизЛицоАвтоПодборТекста()

// Процедура - обработчик события "ОкончаниеВводаТекста" поля ввода физлица
// переопеределим выбор физлица на выбор из списка регистра сведений
//
Процедура СотрудникОкончаниеВводаТекста(Элемент, Текст, Значение, СтандартнаяОбработка)
	
	Значение = ПроцедурыУправленияПерсоналом.ПодобратьСписокРаботниковКандидатов(СтандартнаяОбработка, "РаботникиОрганизации", Текст, Элемент.Значение, Организация);
	
КонецПроцедуры // ФизЛицоОкончаниеВводаТекста()

Процедура ВидСправкиПриИзменении(Элемент)
	
	ТекстВопроса = НСтр("ru='Очистить табличную часть?';uk='Очистити табличну частину?'");
		
	Если Доходы.Количество() > 0 Тогда
		Ответ = Вопрос(ТекстВопроса, РежимДиалогаВопрос.ДаНет, , КодВозвратаДиалога.Да,);
			
		Если Ответ = КодВозвратаДиалога.Да Тогда
			Доходы.Очистить();
		КонецЕсли; 
		
	КонецЕсли;	
// Серна - Начало
	Если (ВидСправки = Перечисления.ВидыСправокОДоходах.ДоходыИНалоги) или (ВидСправки = Перечисления.ВидыСправокОДоходах.СернаБанк) Тогда
// Серна - Конец
		ОпределитьСтруктуруНастройкиВыводаНаПечать();
	КонецЕсли;	

	УстановитьВидимость();
	
КонецПроцедуры

Процедура СотрудникОбработкаВыбора(Элемент, ВыбранноеЗначение, СтандартнаяОбработка)
	
	Если НЕ ОчиститьТабличнуюЧасть() Тогда
		СтандартнаяОбработка = Ложь;
    КонецЕсли;
    
КонецПроцедуры
////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ ФОРМЫ

