﻿////////////////////////////////////////////////////////////////////////////////
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
 
// Управляет доступностью реквизитов формы
Процедура ОпределитьДоступностьРеквизитов()

	ЭлементыФормы.СтавкаПоПериодуРегистрации.Доступность = НЕ ЕСВ;
	
КонецПроцедуры
 
////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ ФОРМЫ

// Процедура - вызывается при открытии формы
Процедура ПриОткрытии()

	Если ЭтоНовый() Тогда

		// Инициализация реквизитов для нового объекта
		СпособРасчета	= Перечисления.СпособыРасчетаОплатыТруда.Взносы;
		КатегорияРасчета = Перечисления.КатегорииРасчетов.Первичное;
		ЕСВ = Истина;
		СтавкаПоПериодуРегистрации = Истина;
		Актуальность = Истина;
		
	КонецЕсли;
	

	// Для предопределённых элементов запрещено редактирование некоторых реквизитов 
	ЭлементыФормы.СпособРасчета.Доступность = Не Предопределенный;
	ЭлементыФормы.СпособРасчетаПоШкале.Доступность = Не Предопределенный;
	ЭлементыФормы.КатегорияРасчета.Доступность = Не Предопределенный;
	ЭлементыФормы.ЕСВ.Доступность = Не Предопределенный;
	
	// контексно-зависимое управление доступностью
	ОпределитьДоступностьРеквизитов();	
	
	РаботаСДиалогами.СоздатьКнопкуПодбораДляПВР(Ссылка, ЭтаФорма, Ложь);
	
КонецПроцедуры

// Процедура - обработчик события записи вида расчета
Процедура ПриЗаписи(Отказ)

	// Проверка правильности настройки вида расчета
	РезультатПроверки = ПроведениеРасчетов.ПроверитьНастройкуВидаРасчета(ЭтотОбъект, Отказ);
	Если Не Отказ Тогда
		Если Не ПустаяСтрока(РезультатПроверки) Тогда
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
		
	ИначеЕсли мТабличнаяЧасть = "ВытесняющиеВидыРасчета"  Тогда
		
		Если ВытесняющиеВидыРасчета.Найти(ЗначениеВыбора,"ВидРасчета") = Неопределено Тогда
			ВытесняющиеВидыРасчета.Добавить().ВидРасчета = ЗначениеВыбора;
		КонецЕсли;
		
	КонецЕсли; 
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ ЭЛЕМЕНТОВ ФОРМЫ

// Процедура - обработчик события изменения способа расчета
Процедура СпособРасчетаПриИзменении(Элемент)

	ОпределитьДоступностьРеквизитов();
	
КонецПроцедуры

Процедура ЕСВПриИзменении(Элемент)
	
	Если ЕСВ Тогда
		СтавкаПоПериодуРегистрации = Истина;
	КонецЕсли;	
	ОпределитьДоступностьРеквизитов();
	
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

Процедура КоманднаяПанельВедущиеВидыРасчетаЗаполнить(Кнопка)
	
	Если Модифицированность() Тогда	
		Если Вопрос(НСтр("ru='Перед заполнением необходимо записать. Записать вид расчета?';uk='Перед заповненням необхідно записати. Записати вид розрахунку?'"), РежимДиалогаВопрос.ДаНет, , КодВозвратаДиалога.Нет) = КодВозвратаДиалога.Нет Тогда
			// отказались от записи
			Возврат;
		КонецЕсли;
	КонецЕсли;
	
	Записать();
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("парамВидРасчета", Ссылка);
	ТекстЗапроса = "
	|ВЫБРАТЬ РАЗЛИЧНЫЕ
	|	Основные.ВидРасчета КАК ВидРасчета
	|ИЗ ПланВидовРасчета.ВзносыВФонды.БазовыеВидыРасчета КАК Базовые
	|
	|ЛЕВОЕ СОЕДИНЕНИЕ ПланВидовРасчета.ОсновныеНачисленияОрганизаций.ВедущиеВидыРасчета КАК Основные
	|ПО Базовые.ВидРасчета = Основные.Ссылка 
	|
	|ЛЕВОЕ СОЕДИНЕНИЕ ПланВидовРасчета.ВзносыВФонды.ВедущиеВидыРасчета КАК Ведущие
	|ПО 	Ведущие.Ссылка = &парамВидРасчета
	|	И	Основные.ВидРасчета = Ведущие.ВидРасчета 
	|
	|ГДЕ 	Базовые.Ссылка = &парамВидРасчета
	|	И	Основные.ВидРасчета <> ЗНАЧЕНИЕ(ПланВидовРасчета.ОсновныеНачисленияОрганизаций.ПустаяСсылка)
	|	И	Ведущие.ВидРасчета ЕСТЬ NULL  // только те которых не хватает
	|
	|
	|ОБЪЕДИНИТЬ
	|ВЫБРАТЬ РАЗЛИЧНЫЕ
	|	Основные.ВидРасчета КАК ВидРасчета
	|ИЗ ПланВидовРасчета.ВзносыВФонды.БазовыеВидыРасчета КАК Базовые
	|
	|ЛЕВОЕ СОЕДИНЕНИЕ ПланВидовРасчета.ОсновныеНачисленияОрганизаций.ВытесняющиеВидыРасчета КАК Основные
	|ПО Базовые.ВидРасчета = Основные.Ссылка 
	|
	|ЛЕВОЕ СОЕДИНЕНИЕ ПланВидовРасчета.ВзносыВФонды.ВедущиеВидыРасчета КАК Ведущие
	|ПО 	Ведущие.Ссылка = &парамВидРасчета
	|	И	Основные.ВидРасчета = Ведущие.ВидРасчета 
	|
	|ГДЕ 	Базовые.Ссылка = &парамВидРасчета
	|	И	Основные.ВидРасчета <> ЗНАЧЕНИЕ(ПланВидовРасчета.ОсновныеНачисленияОрганизаций.ПустаяСсылка)
	|	И	Ведущие.ВидРасчета ЕСТЬ NULL  // только те которых не хватает
	|
	|
	|ОБЪЕДИНИТЬ
	|ВЫБРАТЬ РАЗЛИЧНЫЕ
	|	Основные.ВидРасчета КАК ВидРасчета
	|ИЗ ПланВидовРасчета.ВзносыВФонды.БазовыеВидыРасчета КАК Базовые
	|
	|ЛЕВОЕ СОЕДИНЕНИЕ ПланВидовРасчета.ОсновныеНачисленияОрганизаций.БазовыеВидыРасчета КАК Основные
	|ПО Базовые.ВидРасчета = Основные.Ссылка 
	|
	|ЛЕВОЕ СОЕДИНЕНИЕ ПланВидовРасчета.ВзносыВФонды.ВедущиеВидыРасчета КАК Ведущие
	|ПО 	Ведущие.Ссылка = &парамВидРасчета
	|	И	Основные.ВидРасчета = Ведущие.ВидРасчета 
	|
	|ГДЕ 	Базовые.Ссылка = &парамВидРасчета
	|	И	Основные.ВидРасчета <> ЗНАЧЕНИЕ(ПланВидовРасчета.ОсновныеНачисленияОрганизаций.ПустаяСсылка)
	|	И	Ведущие.ВидРасчета ЕСТЬ NULL  // только те которых не хватает
	|
	|
	|ОБЪЕДИНИТЬ
	|ВЫБРАТЬ РАЗЛИЧНЫЕ
	|	Базовые.ВидРасчета КАК ВидРасчета
	|ИЗ ПланВидовРасчета.ВзносыВФонды.БазовыеВидыРасчета КАК Базовые
	|
	|ЛЕВОЕ СОЕДИНЕНИЕ ПланВидовРасчета.ВзносыВФонды.ВедущиеВидыРасчета КАК Ведущие
	|ПО 	Ведущие.Ссылка = &парамВидРасчета
	|	И	Базовые.ВидРасчета = Ведущие.ВидРасчета 
	|
	|ГДЕ 	Базовые.Ссылка = &парамВидРасчета
	|	И	Базовые.ВидРасчета <> ЗНАЧЕНИЕ(ПланВидовРасчета.ОсновныеНачисленияОрганизаций.ПустаяСсылка)
	|	И	Ведущие.ВидРасчета ЕСТЬ NULL  // только те которых не хватает
	|";
	Запрос.Текст = ТекстЗапроса;
	
	Выборка = Запрос.Выполнить().Выбрать();	
	Пока Выборка.Следующий() Цикл
		СтрокаВедущие = ВедущиеВидыРасчета.Добавить();
		СтрокаВедущие.ВидРасчета = Выборка.ВидРасчета;
	КонецЦикла;
	
КонецПроцедуры


// инициализируем списки выбора

// для СпособРасчета
Если ТипЗнч(ВладелецФормы) = Тип("Форма") Тогда
	
	// Этот элемент создан из формы выбора, у которой предустановлен отбор по способу расчета.
	// В элементе вида расчета создадим точно такой же список выбора.
	
	Если ТипЗнч(ВладелецФормы.Отбор.СпособРасчета.Значение) = Тип("СписокЗначений") Тогда
		ЭлементыФормы.СпособРасчета.СписокВыбора = ВладелецФормы.Отбор.СпособРасчета.Значение
	Иначе
		ЭлементыФормы.СпособРасчета.СписокВыбора = ПроведениеРасчетов.ПолучитьСписокВариантовВзносовВФондыОрганизации();
	КонецЕсли; 
	
Иначе
	
	// Доступные способы расчета - все начисления
	ЭлементыФормы.СпособРасчета.СписокВыбора = ПроведениеРасчетов.ПолучитьСписокВариантовВзносовВФондыОрганизации();
	
КонецЕсли; 
