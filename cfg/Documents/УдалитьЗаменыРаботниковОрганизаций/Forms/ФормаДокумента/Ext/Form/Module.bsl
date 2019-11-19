﻿////////////////////////////////////////////////////////////////////////////////
// ПЕРЕМЕННЫЕ МОДУЛЯ

Перем мТекущаяДатаДокумента; // Хранит последнюю установленную дату документа - для проверки перехода документа в другой период
Перем мФормаВыбораПриказаОПриеме; // Форма для выбора подразделения организации
Перем мВалютаРегламентированногоУчета; // Хранит значение константы ВалютаРегламентированногоУчета - для ввода значений по умолчанию

// для синхронизации строк табличных полей
Перем мСтрокаРаботникиУстановлена;
Перем мСтрокаНачисленияУстановлена;
Перем мСтрокаДопНачисленияУстановлена;

Перем мСинхронизируемыеТабличныеЧасти;

////////////////////////////////////////////////////////////////////////////////
// ОБЩИЕ ПРОЦЕДУРЫ И ФУНКЦИИ

// Процедура формирует таблицу работников на основе данных табличных частей документа 
//
// Параметры
//
Процедура ЗаполнитьТаблицуРаботниковОрганизации()
	
	РаботникиОрганизации.Очистить();
	
	ТЗ = Замены.Выгрузить();
	ТЗ.Свернуть("ФизЛицо");
	Для каждого Строка Из ТЗ Цикл
		НоваяСтрока 		= РаботникиОрганизации.Добавить();
		НоваяСтрока.ФизЛицо = Строка.ФизЛицо;
	КонецЦикла; 
	
	
	ТЗ = Замены.Выгрузить();
	ТЗ.Свернуть("ЗаменаФизЛицо");
	СтруктураПоиска = Новый Структура("ФизЛицо");
	Для каждого Строка Из ТЗ Цикл
		
		СтруктураПоиска.ФизЛицо = Строка.ЗаменаФизЛицо;
		Если РаботникиОрганизации.НайтиСтроки(СтруктураПоиска).Количество() <> 0 Тогда
			Продолжить;			
		КонецЕсли;
		
		НоваяСтрока 		= РаботникиОрганизации.Добавить();
		НоваяСтрока.ФизЛицо = Строка.ЗаменаФизЛицо;
	КонецЦикла; 
      
    РаботникиОрганизации.Сортировать("ФизЛицо");	
КонецПроцедуры

// Выполняет аворасчет реквизитов строки назначений
Процедура ВыполнитьАвторасчетРеквизитовСтрокиНазначений()
	
	ТекущаяСтрока = ЭлементыФормы.Замены.ТекущаяСтрока;
	
КонецПроцедуры

Процедура УстановитьВидимостьПанели(ИзменятьДанные = Ложь)

	ПоказыватьПодразделения = Организация.ЮрФизЛицо <> Перечисления.ЮрФизЛицо.ФизЛицо и ЗначениеЗаполнено(Организация);
	
	Если ПоказыватьПодразделения Тогда
		// Получим список обособленных подразделений организации
		ПоказыватьПодразделения = ЗначениеЗаполнено(Организация.ГоловнаяОрганизация) или ПроцедурыУправленияПерсоналом.ПолучитьСписокОбособленныхПодразделенийОрганизации(Организация).Количество() > 0
	КонецЕсли;
	
	Если ИзменятьДанные Тогда
		Если ПоказыватьПодразделения Тогда
			ОбособленноеПодразделениеКуда = Организация;
			ОбособленноеПодразделениеОткуда = Организация;
		Иначе
			ОбособленноеПодразделениеКуда = ОбщегоНазначения.ПустоеЗначениеТипа("СправочникСсылка.Организации");
			ОбособленноеПодразделениеОткуда = ОбщегоНазначения.ПустоеЗначениеТипа("СправочникСсылка.Организации");
		КонецЕсли;
	КонецЕсли;
	
	ЭлементыФормы.Замены.Колонки.ПодразделениеОрганизации.ЭлементУправления.ВыборПоВладельцу = ?(ПоказыватьПодразделения,ОбособленноеПодразделениеКуда,Организация);
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ ФОРМЫ

Процедура ПередОткрытием(Отказ, СтандартнаяОбработка)
	
	Если ЭтоНовый() Тогда
		Отказ = Истина;
		Предупреждение(НСтр("ru='Документ не используется в работе. Для регистрации замен используется документ ""Замены организаций""';uk='Документ не використовується в роботі. Для реєстрації замін використовується документ ""Заміни організацій""'"),10);
		Возврат;
	КонецЕсли;

КонецПроцедуры


// Процедура - обработчик события "ПриОткрытии" формы
//
Процедура ПриОткрытии()

	Если ЭтоНовый() Тогда
		// Заполнить реквизиты значениями по умолчанию.
		ЗаполнениеДокументов.ЗаполнитьШапкуДокумента(ЭтотОбъект);
		Если ЗначениеЗаполнено(Организация.ГоловнаяОрганизация) Тогда
			ОбособленноеПодразделениеОткуда = Организация;
			ОбособленноеПодразделениеКуда = Организация;
			Организация = Организация.ГоловнаяОрганизация;
		КонецЕсли;
	КонецЕсли;	

	СтруктураКолонок = Новый Структура();

	// Установить колонки, видимостью которых пользователь управлять не может.
	СтруктураКолонок.Вставить("ФизЛицо");
	СтруктураКолонок.Вставить("ПодразделениеОрганизации");
 	СтруктураКолонок.Вставить("Должность");
 	СтруктураКолонок.Вставить("ГрафикРаботы");
 	СтруктураКолонок.Вставить("ТарифнаяСтавка");
 	СтруктураКолонок.Вставить("ДатаНачала");
 	СтруктураКолонок.Вставить("СпособРасчета");
 	СтруктураКолонок.Вставить("ВидРасчета");
 	СтруктураКолонок.Вставить("ГрафикРаботы");

	// Установить ограничение - изменять видимость колонок табличной части
	ОбработкаТабличныхЧастей.УстановитьИзменятьВидимостьКолонокТабЧасти(ЭлементыФормы.Замены.Колонки, СтруктураКолонок);

	// Вывести в заголовке формы вид операции и статус документа (новый, не проведен, проведен).
	РаботаСДиалогами.УстановитьЗаголовокФормыДокумента(, ЭтотОбъект, ЭтаФорма);

	// Запомнить текущие значения реквизитов формы.
	мТекущаяДатаДокумента = Дата;

	// Установить активный реквизит.
	РаботаСДиалогами.АктивизироватьРеквизитВФорме(ЭтотОбъект, ЭтаФорма);

	УстановитьВидимостьПанели();
	
	// Установим видимость реквизита "Приказ"
	РаботаСДиалогами.УстановитьВидимостьПриказа(ЭтаФорма,Организация,глЗначениеПеременной("глУчетнаяПолитикаПоПерсоналуОрганизации"));
	Колонки		= ЭлементыФормы.Замены.Колонки;                                            
	Для Каждого Колонка Из Колонки Цикл
		Если Колонка.Имя = "ЗаменаПриказ" Тогда
			Колонка.Видимость			= глЗначениеПеременной("глУчетнаяПолитикаПоПерсоналуОрганизации")[Организация].ПоддержкаВнутреннегоСовместительства;
		КонецЕсли;
	КонецЦикла;
	
	// Список видов записей расчета среднего
	ЭлементыФормы.Замены.Колонки.ВидРасчета.ЭлементУправления.СписокВыбора.Добавить(ПланыВидовРасчета.ОсновныеНачисленияОрганизаций.Замещение);
	ЭлементыФормы.Замены.Колонки.ВидРасчета.ЭлементУправления.СписокВыбора.Добавить(ПланыВидовРасчета.ОсновныеНачисленияОрганизаций.Совмещение);

КонецПроцедуры

// Процедура - обработчик события "ПослеЗаписи" формы.
//
Процедура ПослеЗаписи()
	// Вывести в заголовке формы статус документа (новый, не проведен, проведен).
	РаботаСДиалогами.УстановитьЗаголовокФормыДокумента(, ЭтотОбъект, ЭтаФорма);
КонецПроцедуры

// Процедура - обработчик события "ОбработкаВыбора" формы
Процедура ОбработкаВыбора(ЗначениеВыбора, Источник)

	Если ЭлементыФормы.Замены.ТекущаяСтрока  = Неопределено Тогда
		Возврат;
	КонецЕсли;

	Если Источник = мФормаВыбораПриказаОПриеме Тогда
		
		ЭлементыФормы.Замены.ТекущаяСтрока.Приказ  = ЗначениеВыбора;
		ВыполнитьАвторасчетРеквизитовСтрокиНазначений();

	КонецЕсли;

КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// ПРОЦЕДУРЫ - ДЕЙСТВИЯ КОМАНДНЫХ ПАНЕЛЕЙ ФОРМЫ

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

// Процедура - обработчик события "ПриИзменении" поля ввода организации.
//
Процедура ОрганизацияПриИзменении(Элемент)

	УстановитьВидимостьПанели(Истина);
	
	// Установим видимость реквизита "Приказ"
	РаботаСДиалогами.УстановитьВидимостьПриказа(ЭтаФорма,Организация,глЗначениеПеременной("глУчетнаяПолитикаПоПерсоналуОрганизации"));

	
КонецПроцедуры // ОрганизацияПриИзменении()

// Процедура - обработчик события "НачалоВыбора" поля ввода организации.
//
Процедура ОрганизацияНачалоВыбора(Элемент, СтандартнаяОбработка)
	СтандартнаяОбработка = Ложь
КонецПроцедуры

// Процедура - обработчик события "НачалоВыбораИзСписка" поля ввода организации.
//
Процедура ОрганизацияНачалоВыбораИзСписка(Элемент, СтандартнаяОбработка)
	Запрос = Новый Запрос("ВЫБРАТЬ
	                      |	Организации.Ссылка
	                      |ИЗ
	                      |	Справочник.Организации КАК Организации
	                      |
	                      |ГДЕ
	                      |	Организации.ГоловнаяОрганизация = &ПустаяОрганизация");
	
	Запрос.УстановитьПараметр("ПустаяОрганизация",ОбщегоНазначения.ПустоеЗначениеТипа("СправочникСсылка.Организации"));					  
	Выборка = Запрос.Выполнить().Выбрать();
	Список = Новый СписокЗначений;
	Пока Выборка.Следующий() Цикл
	     Список.Добавить(Выборка.Ссылка);
	КонецЦикла;
    Элемент.СписокВыбора = Список
КонецПроцедуры

Процедура ОрганизацияАвтоПодборТекста(Элемент, Текст, ТекстАвтоПодбора, СтандартнаяОбработка)

	ТекстЗапроса = "ВЫБРАТЬ РАЗЛИЧНЫЕ ПЕРВЫЕ 2
	               |	Организации.Наименование
	               |ИЗ
	               |	Справочник.Организации КАК Организации
	               |
	               |ГДЕ
	               |	Организации.ГоловнаяОрганизация = &ПустаяОрганизация И
	               |	(Организации.Наименование ПОДОБНО &парамТекст СПЕЦСИМВОЛ ""~"")";
				   
	Запрос = Новый Запрос(ТекстЗапроса);
	
	// заменим спецсимволы
	Текст = СтрЗаменить(Текст, "~", "~~");
	Текст = СтрЗаменить(Текст, "%", "~%");
	Текст = СтрЗаменить(Текст, "_", "~_");
	Текст = СтрЗаменить(Текст, "[", "~[");
	Текст = СтрЗаменить(Текст, "-", "~-");
	Текст = Текст+"%";
	
	Запрос.УстановитьПараметр("парамТекст", Текст);
	Запрос.УстановитьПараметр("ПустаяОрганизация", ОбщегоНазначения.ПустоеЗначениеТипа("СправочникСсылка.Организации"));
	
	Выборка = Запрос.Выполнить().Выбрать();
	
	Если Выборка.Количество() = 1 Тогда
		Выборка.Следующий();
		ТекстАвтоПодбора = Выборка.Наименование;
	КонецЕсли;

КонецПроцедуры

Процедура ОрганизацияОкончаниеВводаТекста(Элемент, Текст, Значение, СтандартнаяОбработка)

	ТекстЗапроса = "ВЫБРАТЬ РАЗЛИЧНЫЕ ПЕРВЫЕ 51
	               |	Организации.Наименование,
	               |	Организации.Ссылка
	               |ИЗ
	               |	Справочник.Организации КАК Организации
	               |
	               |ГДЕ
	               |	Организации.ГоловнаяОрганизация = &ПустаяОрганизация И
	               |	Организации.Наименование ПОДОБНО &парамТекст";
				   
	Запрос = Новый Запрос(ТекстЗапроса);
	
	ТекстВПоле = Текст;
	
	// заменим спецсимволы
	ТекстВПоле = СтрЗаменить(ТекстВПоле, "~", "~~");
	ТекстВПоле = СтрЗаменить(ТекстВПоле, "%", "~%");
	ТекстВПоле = СтрЗаменить(ТекстВПоле, "_", "~_");
	ТекстВПоле = СтрЗаменить(ТекстВПоле, "[", "~[");
	ТекстВПоле = СтрЗаменить(ТекстВПоле, "-", "~-");
	ТекстВПоле = ТекстВПоле+"%";
	
	Запрос.УстановитьПараметр("парамТекст", ТекстВПоле);
	Запрос.УстановитьПараметр("ПустаяОрганизация", ОбщегоНазначения.ПустоеЗначениеТипа("СправочникСсылка.Организации"));
	Выборка = Запрос.Выполнить().Выбрать();
	
	Количество = Выборка.Количество();
	
	Если Количество = 0 Тогда
		Предупреждение(НСтр("ru='В поле ввода неверно задано наименование организации!';uk='В полі введення невірно задане найменування організації!'"));
		Значение = ОбщегоНазначения.ПустоеЗначениеТипа("СправочникСсылка.Организации");
	ИначеЕсли Количество < 51 Тогда
		Значение = Новый СписокЗначений;
		Пока Выборка.Следующий() Цикл
			Значение.Добавить(Выборка.Ссылка, Выборка.Наименование);
		КонецЦикла;
	Иначе
		Значение = Неопределено;
	КонецЕсли;
	
	СтандартнаяОбработка = (Значение = Неопределено);
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// ПРОЦЕДУРЫ - ОБРАБОТЧИКИ СОБЫТИЙ ТАБЛИЧНОГО ПОЛЯ "Замены"

// Процедура - обработчик события "ПриАктивизацииСтроки" строки ТЧ
Процедура ЗаменыПриАктивизацииСтроки(Элемент)
	мСинхронизируемыеТабличныеЧасти["Замены"] = Ложь;
	ПроцедурыУправленияПерсоналом.СинхронизироватьСтроки(ЭтаФорма, ДокументОбъект, Элемент, мСинхронизируемыеТабличныеЧасти, "Физлицо");
КонецПроцедуры

// // Процедура обеспечивает начальное значение реквизита "ЗанимаемыхСтавок" и 
//  "ГрафикРаботы".
//
// Параметры:
//  Элемент      - табличное поле, которое отображает т.ч.
//  НоваяСтрока  - булево, признак редактирования новой строки
//  
Процедура ЗаменыПриНачалеРедактирования(Элемент, НоваяСтрока)	
	Если НоваяСтрока Тогда
		Если НЕ ЗначениеЗаполнено(Элемент.ТекущаяСтрока.ЗанимаемыхСтавок) Тогда
			Элемент.ТекущаяСтрока.ЗанимаемыхСтавок = 1;
		КонецЕсли;
		Если НЕ ЗначениеЗаполнено(Элемент.ТекущаяСтрока.ГрафикРаботы) Тогда
			Элемент.ТекущаяСтрока.ГрафикРаботы = УправлениеПользователями.ПолучитьЗначениеПоУмолчанию(Ответственный, "ГрафикРаботы");
		КонецЕсли;
	КонецЕсли;	
КонецПроцедуры

// Процедура - обработчик оповещения о выборе, присланного формой рег-ра сведений
//
Процедура ЗаменыОбработкаВыбора(Элемент, ВыбранноеЗначение, СтандартнаяОбработка)
	
	Если ТипЗнч(ВыбранноеЗначение) <> Тип("Структура") Тогда
		Возврат;
	КонецЕсли;
	
	ДополнительнаяСтрока = "Замена";
	Если Найти(Элемент.ТекущаяКолонка.Данные,ДополнительнаяСтрока) = 0 Тогда
		ДополнительнаяСтрока = "";	
		//Элемент.ТекущаяСтрока["ЗанимаемыхСтавок"] = ВыбранноеЗначение.ЗанимаемыхСтавок;	
	КонецЕсли; 
	
	Элемент.ТекущаяСтрока["" + ДополнительнаяСтрока + "Физлицо"] 				    = ВыбранноеЗначение.Физлицо;
	Элемент.ТекущаяСтрока["" + ДополнительнаяСтрока + "Приказ"]				   		= ВыбранноеЗначение.Приказ;
	Элемент.ТекущаяСтрока["" + ДополнительнаяСтрока + "ПодразделениеОрганизации"] 	= ВыбранноеЗначение.ПодразделениеОрганизации;
	Элемент.ТекущаяСтрока["" + ДополнительнаяСтрока + "Должность"]                	= ВыбранноеЗначение.Должность;
	Элемент.ТекущаяСтрока["" + ДополнительнаяСтрока + "ГрафикРаботы"]               = ВыбранноеЗначение.ГрафикРаботы;
	
	СтандартнаяОбработка = Ложь;
	
КонецПроцедуры

// Процедура - обработчик события перед началом редактирования Замены
//
Процедура ЗаменыПередОкончаниемРедактирования(Элемент, НоваяСтрока, ОтменаРедактирования, Отказ)
	ЗаполнитьТаблицуРаботниковОрганизации();
	ПроцедурыУправленияПерсоналом.СинхронизироватьСтроки(ЭтаФорма, ДокументОбъект, Элемент, мСинхронизируемыеТабличныеЧасти, "Физлицо");
КонецПроцедуры

// Процедура - обработчик события после удаления ТЧ Замены
Процедура ЗаменыПослеУдаления(Элемент)
	ЗаполнитьТаблицуРаботниковОрганизации();
КонецПроцедуры

    
////////////////////////////////////////////////////////////////////////////////
// ПРОЦЕДУРЫ - ОБРАБОТЧИКИ СОБЫТИЙ РЕКВИЗИТОВ ТАБЛИЧНОЙ ЧАСТИ Замены

// Процедура - обработчик события "ПриИзменении" поля ввода физлица
Процедура ЗаменыФизЛицоПриИзменении(Элемент)

	НаборДанных = ПроцедурыУправленияПерсоналом.ПодборДанныхПоФизлицу(ЭтаФорма, Элемент, ЭлементыФормы.Замены.ТекущаяСтрока.Физлицо, Организация, , глЗначениеПеременной("глУчетнаяПолитикаПоПерсоналуОрганизации"));
	ЗаполняемаяСтрока = ЭлементыФормы.Замены.ТекущаяСтрока;
	Если НаборДанных <> НеОпределено Тогда

		ЗаполняемаяСтрока.Должность = НаборДанных.Должность;
		Если НЕ ЗначениеЗаполнено(ЗаполняемаяСтрока.ЗанимаемыхСтавок) Тогда
			ЗаполняемаяСтрока.ЗанимаемыхСтавок  = 1;
		КонецЕсли;
		////Если НЕ ЗначениеЗаполнено(ЗаполняемаяСтрока.ВалютаТарифнойСтавки) Тогда
		////	ЗаполняемаяСтрока.ВалютаТарифнойСтавки  = мВалютаРегламентированногоУчета;
		////КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

// Процедура - обработчик события "НачалоВыбора" поля ввода физлица
// переопеределим выбор физлица на выбор из списка регистра сведений
//
Процедура ЗаменыФизЛицоНачалоВыбора(Элемент, СтандартнаяОбработка)
	ПроцедурыУправленияПерсоналом.ОткрытьФормуВыбораРаботникаОрганизации(ЭлементыФормы.Замены, СтандартнаяОбработка, Ссылка, Дата, Организация, Справочники.ПодразделенияОрганизаций.ПустаяСсылка());
КонецПроцедуры

// Процедура - обработчик события "АвтоПодборТекста" поля ввода физлица
// переопеределим выбор физлица на выбор из списка регистра сведений
//
Процедура ЗаменыФизЛицоАвтоПодборТекста(Элемент, Текст, ТекстАвтоПодбора, СтандартнаяОбработка)
	ТекстАвтоПодбора = ПроцедурыУправленияПерсоналом.ПодобратьФИОРаботникаКандидата("Замены", Текст, Организация);
	СтандартнаяОбработка = Ложь;
КонецПроцедуры

// Процедура - обработчик события "ОкончаниеВводаТекста" поля ввода физлица
// переопеределим выбор физлица на выбор из списка регистра сведений
//
Процедура ЗаменыФизЛицоОкончаниеВводаТекста(Элемент, Текст, Значение, СтандартнаяОбработка)
	Значение = ПроцедурыУправленияПерсоналом.ПодобратьСписокРаботниковКандидатов("Замены", Текст, Элемент.Значение, Организация);
	СтандартнаяОбработка = (Значение = Неопределено);
КонецПроцедуры
                    
// проставляет в строку табличной части или реквизит формы полученные данные по физлицу
//
Процедура ПроставитьДанныеСтрокиЗамены(НаборДанных, ЭлементФормы) Экспорт

	Если НаборДанных = НеОпределено Тогда
		Возврат;
	КонецЕсли;
	
	Если ТипЗнч(ЭлементФормы) = Тип("ТабличноеПоле") Тогда
		
		ЭлементФормы.ТекущаяСтрока["ЗаменаДолжность"] = НаборДанных.Должность;
		ЭлементФормы.ТекущаяСтрока["ЗаменаГрафикРаботы"] = НаборДанных.ГрафикРаботы;
		ЭлементФормы.ТекущаяСтрока["ЗаменаПриказ"] = НаборДанных.Приказ;
		ЭлементФормы.ТекущаяСтрока["ЗаменаПодразделениеОрганизации"] = НаборДанных.ПодразделениеОрганизации;
		
	КонецЕсли; 

КонецПроцедуры  

Процедура ЗаменыФизЛицоКогоЗаменялПриИзменении(Элемент)

	НаборДанных = ПроцедурыУправленияПерсоналом.ПодборДанныхПоФизлицу(ЭтаФорма, Элемент, ЭлементыФормы.Замены.ТекущаяСтрока.ЗаменаФизлицо, Организация, , глЗначениеПеременной("глУчетнаяПолитикаПоПерсоналуОрганизации"));
	ЗаполняемаяСтрока = ЭлементыФормы.Замены.ТекущаяСтрока;
	Если НаборДанных <> НеОпределено Тогда
		Если НЕ ЗначениеЗаполнено(ЗаполняемаяСтрока.ЗанимаемыхСтавок) Тогда   //??
			ЗаполняемаяСтрока.ЗанимаемыхСтавок  = 1;
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

Процедура ЗаменыФизЛицоКогоЗаменялНачалоВыбора(Элемент, СтандартнаяОбработка)
	ПроцедурыУправленияПерсоналом.ОткрытьФормуВыбораРаботникаОрганизации(ЭлементыФормы.Замены, СтандартнаяОбработка, Ссылка, Дата, Организация, Справочники.ПодразделенияОрганизаций.ПустаяСсылка());
КонецПроцедуры

Процедура ЗаменыФизЛицоКогоЗаменялАвтоПодборТекста(Элемент, Текст, ТекстАвтоПодбора, СтандартнаяОбработка)
	ТекстАвтоПодбора = ПроцедурыУправленияПерсоналом.ПодобратьФИОРаботникаКандидата("Замены", Текст, Организация);
	СтандартнаяОбработка = Ложь;
	
	НаборДанных = ПроцедурыУправленияПерсоналом.ПодборДанныхПоФизлицу(ЭтаФорма, Элемент, ЭлементыФормы.Замены.ТекущаяСтрока.ЗаменаФизлицо, Организация, , глЗначениеПеременной("глУчетнаяПолитикаПоПерсоналуОрганизации"));
	ЗаполняемаяСтрока = ЭлементыФормы.Замены.ТекущаяСтрока;
	Если НаборДанных <> НеОпределено Тогда
		Если НЕ ЗначениеЗаполнено(ЗаполняемаяСтрока.ЗанимаемыхСтавок) Тогда   //??
			ЗаполняемаяСтрока.ЗанимаемыхСтавок  = 1;
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

Процедура ЗаменыФизЛицоКогоЗаменялОкончаниеВводаТекста(Элемент, Текст, Значение, СтандартнаяОбработка)
	Значение = ПроцедурыУправленияПерсоналом.ПодобратьСписокРаботниковКандидатов("Замены", Текст, Элемент.Значение, Организация);
	СтандартнаяОбработка = (Значение = Неопределено);
	
КонецПроцедуры

                  
// Процедура - обработчик события "НачалоВыбора" поля ввода приказа  о приёме работника организации
Процедура ЗаменыПриказНачалоВыбора(Элемент, СтандартнаяОбработка)

	// Откроем диалог выбора приказа о приеме работника в организацию
    СтандартнаяОбработка = Ложь;

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

Процедура ЗаменыПриказКогоЗаменялНачалоВыбора(Элемент, СтандартнаяОбработка)

	// Откроем диалог выбора приказа о приеме работника в организацию
    СтандартнаяОбработка = Ложь;
	
КонецПроцедуры


////////////////////////////////////////////////////////////////////////////////
// ОПЕРАТОРЫ ОСНОВНОЙ ПРОГРАММЫ
// 

мВалютаРегламентированногоУчета = Константы.ВалютаРегламентированногоУчета.Получить();

мСтрокаРаботникиУстановлена		= Ложь;
мСтрокаНачисленияУстановлена    = Ложь;
мСтрокаДопНачисленияУстановлена = Ложь;

мСинхронизируемыеТабличныеЧасти = Новый Соответствие;

мСинхронизируемыеТабличныеЧасти["Замены"]		= Ложь;
мСинхронизируемыеТабличныеЧасти["РаботникиОрганизации"]		= Ложь;
