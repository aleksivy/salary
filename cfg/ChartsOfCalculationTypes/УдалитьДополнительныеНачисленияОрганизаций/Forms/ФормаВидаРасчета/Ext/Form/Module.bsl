////////////////////////////////////////////////////////////////////////////////
// ПЕРЕМЕННЫЕ МОДУЛЯ
// 
Перем мТабличнаяЧасть;


////////////////////////////////////////////////////////////////////////////////
// ПРОЦЕДУРЫ И ФУНКЦИИ
// 

// Открывает список видов расчета для подбора
Процедура ОткрытьФормуПодбора(ИмяПВР)

	ФормаПодбора = ПланыВидовРасчета[ИмяПВР].ПолучитьФормуВыбора(, ЭтаФорма);
	ФормаПодбора.ЗакрыватьПриВыборе = Ложь;
	ФормаПодбора.Открыть();

КонецПроцедуры

Функция МножественноеЧислоЗначения(ЗначениеМнЧисла)

		Если ЗначениеМнЧисла > 4 Тогда
			ЭлементыФормы.НадписьМесяцев.Заголовок = "месяцев"
		ИначеЕсли ЗначениеМнЧисла = 1 Тогда
			ЭлементыФормы.НадписьМесяцев.Заголовок = "месяц"
		Иначе
			ЭлементыФормы.НадписьМесяцев.Заголовок = "месяца"
		КонецЕсли; 

КонецФункции // МножественноеЧислоЗначения()
 
// Управляет доступностью реквизитов формы
Процедура ОпределитьДоступностьРеквизитов()
	
	// доступность группы элеметов "Число месяцев"
	Если СпособРасчета = Перечисления.СпособыРасчетаОплатыТруда.Процентом Тогда
		
		ЭлементыФормы.ВидПремии.Доступность = Истина;
		ЭлементыФормы.НадписьВидПремии.Доступность = Истина;
		
		Если ЭлементыФормы.ВидПремии.Значение = Перечисления.ВидыПремии.ГодоваяПремия ИЛИ
			ЭлементыФормы.ВидПремии.Значение = Перечисления.ВидыПремии.Премия Тогда
			
			ЭлементыФормы.НадписьЗа.Заголовок  = НСтр("ru='Премия за:';uk='Премія за:'");
			ЭлементыФормы.НадписьЗа.Доступность   = Истина;
			ЭлементыФормы.НадписьМесяцев.Доступность   = Истина;
			ЭлементыФормы.ЧислоМесяцев.Доступность   = Истина;
		КонецЕсли;	
		
		
	ИначеЕсли СпособРасчета = Перечисления.СпособыРасчетаОплатыТруда.ПоСреднемуЗаработку Тогда
		
		ЭлементыФормы.НадписьЗа.Заголовок  = НСтр("ru='Средний заработок за:';uk='Середній заробіток за:'");
		ЭлементыФормы.НадписьЗа.Доступность   = Истина;
		ЭлементыФормы.НадписьМесяцев.Доступность   = Истина;
		ЭлементыФормы.ЧислоМесяцев.Доступность   = Истина;
		
	Иначе
		
		ЭлементыФормы.ВидПремии.Доступность = Ложь;
		ЭлементыФормы.НадписьВидПремии.Доступность = Ложь;
		
		ЭлементыФормы.НадписьЗа.Доступность   = Ложь;
		ЭлементыФормы.НадписьМесяцев.Доступность   = Ложь;
		ЭлементыФормы.ЧислоМесяцев.Доступность   = Ложь;
		
	КонецЕсли;	
	
	Если СпособРасчета = Перечисления.СпособыРасчетаОплатыТруда.ГосударственноеПособие Тогда
		
		ЭлементыФормы.НадписьВидПособия.Видимость	= Истина;
		ЭлементыФормы.ВидПособия.Видимость			= Истина;
		
	Иначе
		
		ЭлементыФормы.НадписьВидПособия.Видимость	= Ложь;
		ЭлементыФормы.ВидПособия.Видимость			= Ложь;
		
	КонецЕсли;

	
КонецПроцедуры

//Заполняет табличку "Является базой для"
Процедура ЗаполнитьЯвляетсяБазойДля()
	ЯвляетсяБазойДля.Очистить();
	Для Каждого ПВР Из ПланыВидовРасчета Цикл
		Выборка = ПВР.Выбрать();
		Пока Выборка.Следующий() Цикл
			Если Выборка.БазовыеВидыРасчета.Найти(ЭтотОбъект.Ссылка) <> Неопределено Тогда
				ЯвляетсяБазойДля.Добавить(Выборка.Ссылка);	
			КонецЕсли;
		КонецЦикла;
	КонецЦикла;
КонецПроцедуры

Процедура ДобавитьЯвляетсяБазойДля(Элемент)
	мТабличнаяЧасть = "ЯвляетсяБазойДля";
	ЭлементыФормы.ЯвляетсяБазойДля.ДобавитьСтроку();
КонецПроцедуры


//
Процедура ЗаписатьЯвляетсяБазойДля()
	Для каждого ПВР Из ПланыВидовРасчета Цикл
		
		СписокПВР = ПВР.Выбрать();
		
		Пока СписокПВР.Следующий() Цикл
			
			ВР = СписокПВР.Ссылка.ПолучитьОбъект();
			ЯвляетсяБазой = ВР.БазовыеВидыРасчета.Найти(ЭтотОбъект.Ссылка);
			Если ЯвляетсяБазой = Неопределено Тогда      
				
				Строка = ЯвляетсяБазойДля.НайтиПоЗначению(ВР.Ссылка);
				Если Строка <> Неопределено Тогда
					ОбъектВР = ВР.БазовыеВидыРасчета.Добавить();
					ОбъектВР.ВидРасчета = ЭтотОбъект.Ссылка;
					ВР.Записать();
				КонецЕсли;
				
			Иначе
				
				Строка = ЯвляетсяБазойДля.НайтиПоЗначению(ВР.Ссылка);
				Если Строка = Неопределено Тогда
					ВР.БазовыеВидыРасчета.Удалить(ВР.БазовыеВидыРасчета.Индекс(ЯвляетсяБазой));
					ВР.Записать();
				КонецЕсли;
				
			КонецЕсли;
			
		КонецЦикла;
		
	КонецЦикла;
КонецПроцедуры
////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ ФОРМЫ

Процедура ПередОткрытием(Отказ, СтандартнаяОбработка)

	
	Если ЭтоНовый() Тогда
		Отказ = Истина;
		Предупреждение(НСтр("ru='Используйте основные начисления.';uk='Використовуйте основні нарахування.'"),10);
		Возврат;
	КонецЕсли;

КонецПроцедуры
		
// Процедура - вызывается при открытии формы
Процедура ПриОткрытии()
	
	Если ЭтоНовый() Тогда

		// Инициализация реквизитов для нового объекта
		СпособРасчета			= Перечисления.СпособыРасчетаОплатыТруда.ФиксированнойСуммой;
		КатегорияРасчета		= Перечисления.КатегорииРасчетов.Первичное;
		ДоходНДФЛ				= Справочники.ВидыДоходовНДФЛ.Код01;
		ВидВзаиморасчетов       = Перечисления.ВидыВзаиморасчетовСРаботниками.ЗаработнаяПлата;
		ВидПремии				= Перечисления.ВидыПремии.НеПремия;
		
	КонецЕсли;
	
	// Доступные способы расчета
	ЭлементыФормы.СпособРасчета.СписокВыбора = ПроведениеРасчетов.ПолучитьСписокДополнительныхВариантовНачислений();
	
	// Доступные категории начислений  - все
	ЭлементыФормы.КатегорияРасчета.СписокВыбора = ОбщегоНазначения.ПолучитьСписокЭлементовПеречисления("КатегорииРасчетов");
	
	// Для предопределённых элементов запрещено редактирование способа расчета 
	ЭлементыФормы.СпособРасчета.Доступность = Не Предопределенный;
	ЭлементыФормы.ВидПособия.Доступность	= Не Предопределенный;
	
	// Сформируем кнопку "Подбор" для ТЧ "БазовыеВидыРасчета" и "ВедущиеВидыРасчета"
	РаботаСДиалогами.СоздатьКнопкуПодбораДляПВР(Ссылка, ЭтаФорма, Истина, Истина);
	
	// Видимость месяцев по премии.
	ОпределитьДоступностьРеквизитов();
	МножественноеЧислоЗначения(ЧислоМесяцев);
	
	ЗаполнитьЯвляетсяБазойДля();
		
КонецПроцедуры

// Процедура - обработчик события записи вида расчета
Процедура ПриЗаписи(Отказ)

	// Проверка правильности настройки вида расчета
	РезультатПроверки = ПроведениеРасчетов.ПроверитьНастройкуВидаРасчета(ЭтотОбъект, Отказ);
	Если не Отказ Тогда
		Если не ПустаяСтрока(РезультатПроверки) Тогда
			Ответ = Вопрос(РезультатПроверки + НСтр("ru=' Записать вид расчета?';uk=' Записати вид розрахунку?'"), РежимДиалогаВопрос.ДаНет, , КодВозвратаДиалога.Нет);
			// отказались от записи
			Отказ = Ответ <> КодВозвратаДиалога.Да;
		КонецЕсли;
	КонецЕсли;

КонецПроцедуры

Процедура ОбработкаВыбора(ЗначениеВыбора, Источник)
	
	Если мТабличнаяЧасть = "БазовыеВидыРасчета" Тогда
		
		Если БазовыеВидыРасчета.Найти(ЗначениеВыбора,"ВидРасчета") = Неопределено Тогда
			БазовыеВидыРасчета.Добавить().ВидРасчета = ЗначениеВыбора;	
		КонецЕсли;
		
	ИначеЕсли мТабличнаяЧасть = "ВедущиеВидыРасчета"  Тогда
		
		Если ВедущиеВидыРасчета.Найти(ЗначениеВыбора,"ВидРасчета") = Неопределено Тогда
			ВедущиеВидыРасчета.Добавить().ВидРасчета = ЗначениеВыбора;	
		КонецЕсли;
	ИначеЕсли мТабличнаяЧасть = "ЯвляетсяБазойДля"  Тогда
		
		Если ЯвляетсяБазойДля.НайтиПоЗначению(ЗначениеВыбора.Ссылка) = Неопределено Тогда
			ЯвляетсяБазойДля.Добавить(ЗначениеВыбора.Ссылка);
		КонецЕсли;	
	КонецЕсли; 
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ РЕКВИЗИТОВ

Процедура ЧислоМесяцевПриИзменении(Элемент)
	
	МножественноеЧислоЗначения(Элемент.Значение)
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ КОМАНДНОЙ ПАНЕЛИ ТЧ БазовыеВидыРасчета

// Не является ошибкой проверки конфигурации - Обработчик устанавливается динамически методом "Действие"
// в процедуре "СоздатьКнопкуПодбораДляПВР" общего модуля "РаботаСДиалогами"
// 
Процедура КоманднаяПанельБазовыеВидыРасчетаПодборПодМеню(Кнопка)
	
	мТабличнаяЧасть = "БазовыеВидыРасчета";
	ОткрытьФормуПодбора(Кнопка.Имя);
	
КонецПроцедуры

// Не является ошибкой проверки конфигурации - Обработчик устанавливается динамически методом "Действие"
// в процедуре "СоздатьКнопкуПодбораДляПВР" общего модуля "РаботаСДиалогами"
// 
Процедура КоманднаяПанельБазовыеВидыРасчетаПодбор(Кнопка)
	
	мТабличнаяЧасть = "БазовыеВидыРасчета";
	
	Для каждого СтрокаКолекции Из Метаданные().БазовыеВидыРасчета Цикл
		
		ОткрытьФормуПодбора(СтрокаКолекции.Имя);
		Прервать;
		
	КонецЦикла; 
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ КОМАНДНОЙ ПАНЕЛИ ТЧ ЯвляетсяБазойДля

// Не является ошибкой проверки конфигурации - Обработчик устанавливается динамически методом "Действие"
// в процедуре "СоздатьКнопкуПодбораДляПВР" общего модуля "РаботаСДиалогами"
// 
Процедура КоманднаяПанельЯвляетсяБазойДляПодМеню(Кнопка)
	
	мТабличнаяЧасть = "ЯвляетсяБазойДля";
	ОткрытьФормуПодбора(Кнопка.Имя);
	
КонецПроцедуры

// Не является ошибкой проверки конфигурации - Обработчик устанавливается динамически методом "Действие"
// в процедуре "СоздатьКнопкуПодбораДляПВР" общего модуля "РаботаСДиалогами"
// 
Процедура КоманднаяПанельЯвляетсяБазойДляПодбор(Кнопка)
	
	мТабличнаяЧасть = "ЯвляетсяБазойДля";
	
	////Для каждого СтрокаКолекции Из Метаданные().ЯвляетсяБазойДля Цикл
	////	
	////	ОткрытьФормуПодбора(СтрокаКолекции.Имя);
	////	Прервать;
	////	
	////КонецЦикла; 
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ КОМАНДНОЙ ПАНЕЛИ ТЧ ВедущиеВидыРасчета

// Не является ошибкой проверки конфигурации - Обработчик устанавливается динамически методом "Действие"
// в процедуре "СоздатьКнопкуПодбораДляПВР" общего модуля "РаботаСДиалогами"
// 
Процедура КоманднаяПанельВедущиеВидыРасчетаПодМеню(Кнопка)
	
	мТабличнаяЧасть = "ВедущиеВидыРасчета";
	ОткрытьФормуПодбора(Кнопка.Имя);
	
КонецПроцедуры

// Не является ошибкой проверки конфигурации - Обработчик устанавливается динамически методом "Действие"
// в процедуре "СоздатьКнопкуПодбораДляПВР" общего модуля "РаботаСДиалогами"
// 
Процедура КоманднаяПанельВедущиеВидыРасчетаПодбор(Кнопка)
	
	мТабличнаяЧасть = "ВедущиеВидыРасчета";
	
	Для каждого СтрокаКолекции Из Метаданные().БазовыеВидыРасчета Цикл
		
		ОткрытьФормуПодбора(СтрокаКолекции.Имя);
		Прервать;
		
	КонецЦикла; 
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ ТЧ ВедущиеВидыРасчета

Процедура ВедущиеВидыРасчетаВидРасчетаНачалоВыбора(Элемент, СтандартнаяОбработка)
	
	КоллекцияБазовыхВидовРасчета = Метаданные.ПланыВидовРасчета[Метаданные().Имя].БазовыеВидыРасчета;
	
	Если КоллекцияБазовыхВидовРасчета.Количество() = 1 Тогда
		Элемент.Значение = ЭлементыФормы.ВедущиеВидыРасчета.Колонки.ВидРасчета.ЭлементУправления.ОграничениеТипа.ПривестиЗначение(Элемент.Значение);		
	КонецЕсли;
	
КонецПроцедуры

Процедура ВидПремииПриИзменении(Элемент)
	
	ОпределитьДоступностьРеквизитов()

КонецПроцедуры

Процедура ДоходНДФЛПриИзменении(Элемент)
	
	Если ЭлементыФормы.ДоходНДФЛ.Значение.ВидВзаиморасчетов <> Неопределено Тогда
		ЭлементыФормы.ВидВзаиморасчетов.Значение = ЭлементыФормы.ДоходНДФЛ.Значение.ВидВзаиморасчетов
	КонецЕсли;
	
	ОпределитьДоступностьРеквизитов();
	
КонецПроцедуры

Процедура ПоказателиВидовОплатыТрудаНачалоВыбора(Элемент, СтандартнаяОбработка)
			
	РаботаСДиалогами.НачалоВыбораСтатьяНалоговойДекларации(Элемент, СтандартнаяОбработка, 
			Перечисления.ВидыНалоговыхДеклараций.ОтчетПоТруду);

		КонецПроцедуры
		
////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ ТЧ ЯвляетсяБазойДля
		
Процедура ПослеЗаписи()
	ЗаписатьЯвляетсяБазойДля();
КонецПроцедуры

Процедура КоманднаяПанельЯвляетсяБазойДля(Кнопка)
	
	мТабличнаяЧасть = "ЯвляетсяБазойДля";
	ОткрытьФормуПодбора("ВзносыВФонды");
	
КонецПроцедуры

Процедура ПередЗаписью(Отказ)
	
	Отказ = Истина;
	
КонецПроцедуры

	
		
		
ЭлементыФормы.ВидВзаиморасчетов.ДоступныеЗначения.Очистить();
ЭлементыФормы.ВидВзаиморасчетов.ДоступныеЗначения.Добавить(Перечисления.ВидыВзаиморасчетовСРаботниками.ЗаработнаяПлата);
ЭлементыФормы.ВидВзаиморасчетов.ДоступныеЗначения.Добавить(Перечисления.ВидыВзаиморасчетовСРаботниками.ЗаработнаяПлатаНеФОТ);
ЭлементыФормы.ВидВзаиморасчетов.ДоступныеЗначения.Добавить(Перечисления.ВидыВзаиморасчетовСРаботниками.Дивиденды);
