﻿// Функция возвращает значение по умолчанию для передаваемого пользователя и настройки.
//
// Параметры:
//  Пользователь - текущий пользователь программы
//  Настройка    - признак, для которого возвращается значение по умолчанию
//
// Возвращаемое значение:
//  Значение по умолчанию для настройки.
//
Функция ПолучитьЗначениеПоУмолчанию(Пользователь, Настройка) Экспорт

	Возврат ПолучитьЗначениеПоУмолчаниюПользователя(Пользователь, Настройка);

КонецФункции // ПолучитьЗначениеПоУмолчанию()

// Функция возвращает значение по умолчанию и значения реквизитов данного значения для передаваемого пользователя, настройки и списка реквизитов.
//
// Параметры:
//  Пользователь - текущий пользователь программы
//  Настройка    - признак, для которого возвращается значение по умолчанию
//	СписокПолей  - список значений, содержащий имена реквизитов значения настройки, которые необходимо получить
//
// Возвращаемое значение:
//  Элемент выборки запроса либо структура (в случае пустой выборки).
//
Функция ПолучитьЗначениеПоУмолчаниюСДополнительнымиПолями(Пользователь, Настройка, СписокПолей) Экспорт
	
	Возврат ПолучитьЗначениеПоУмолчаниюПользователя(Пользователь, Настройка, СписокПолей);
	
КонецФункции // ПолучитьЗначениеПоУмолчаниюСДополнительнымиПолями()

// Общая служебная функция получения значения настроек пользователя
Функция ПолучитьЗначениеПоУмолчаниюПользователя(Пользователь, Настройка, СписокПолей = Неопределено)
	
	НастройкаТипЗнч = ПланыВидовХарактеристик.НастройкиПользователей[Настройка].ТипЗначения;
	НастройкаТипЗнчСправочник = Справочники.ТипВсеСсылки().СодержитТип(НастройкаТипЗнч.Типы()[0]);
	Если НастройкаТипЗнчСправочник Тогда
		МетаданныеТипаНастройки = Метаданные.НайтиПоТипу(НастройкаТипЗнч.Типы()[0]);
	КонецЕсли;
		
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("Пользователь", Пользователь);
	Запрос.УстановитьПараметр("Настройка"   , ПланыВидовХарактеристик.НастройкиПользователей[Настройка]);	
	
	
	Запрос.Текст = "
	|ВЫБРАТЬ РАЗРЕШЕННЫЕ
	|	Значение КАК Значение";
	
	Если СписокПолей <> Неопределено И НастройкаТипЗнчСправочник Тогда
		
		СправочникИмя = МетаданныеТипаНастройки.Имя;
		
		Для каждого Элемент из СписокПолей цикл
			
			ИмяРеквизита = Элемент.Значение;
			Представление = Элемент.Представление;
			Если ПустаяСтрока(Представление) Тогда
				Представление = ИмяРеквизита;
			КонецЕсли;
				
			Запрос.Текст = Запрос.Текст + ",
			|ВЫРАЗИТЬ(Значение КАК Справочник." + СправочникИмя + ")." + ИмяРеквизита + "  КАК " + Представление;
			
		КонецЦикла;
		
	КонецЕсли;
	
	Запрос.Текст = Запрос.Текст + "		
	|ИЗ
	|	РегистрСведений.НастройкиПользователей КАК РегистрЗначениеПрав
	|
	|ГДЕ
	|	Пользователь = &Пользователь
	| И Настройка    = &Настройка
	|";
		
		
	Выборка = Запрос.Выполнить().Выбрать();
	
	Если СписокПолей = Неопределено Тогда
		ПустоеЗначение = НастройкаТипЗнч.ПривестиЗначение();
	Иначе
		ПустоеЗначение = новый Структура("Значение", НастройкаТипЗнч.ПривестиЗначение());
		Для каждого ЭлементСписка из СписокПолей цикл
			ПустоеЗначение.Вставить(?(ПустаяСтрока(ЭлементСписка.Представление), ЭлементСписка.Значение, ЭлементСписка.Представление));
		КонецЦикла;				
	КонецЕсли;
	
	Если Выборка.Количество() = 0 Тогда
		Если Настройка = "ОткрыватьПриЗапускеСписокТекущихЗадачПользователя" Тогда
			Возврат Истина;
		ИначеЕсли Настройка = "КодировкаПисьмаЭлектроннойПочтыПоУмолчанию" Тогда
			Возврат "utf-8";
		ИначеЕсли Настройка = "ЗапрашиватьПодтверждениеПриЗакрытии" Тогда
			Возврат Ложь;
		ИначеЕсли Настройка = "ИспользоватьПомощникаПриемаНаРаботу" Тогда
			Возврат Истина;	
		ИначеЕсли Настройка = "ОткрыватьПриЗапускеРабочийСтол" Тогда
			Возврат Истина;		
		КонецЕсли;
		
		Возврат ПустоеЗначение;
     КонецЕсли;

	Если Выборка.Следующий() Тогда
	
		Если НЕ ЗначениеЗаполнено(Выборка.Значение) Тогда
			Если Настройка = "ОткрыватьПриЗапускеСписокТекущихЗадачПользователя" Тогда
				Возврат Истина;
			ИначеЕсли Настройка = "КодировкаПисьмаЭлектроннойПочтыПоУмолчанию" Тогда
				Возврат "utf-8";
			ИначеЕсли Настройка = "ЗапрашиватьПодтверждениеПриЗакрытии" Тогда
				Возврат Ложь;
			ИначеЕсли Настройка = "ИспользоватьПомощникаПриемаНаРаботу" Тогда
				Возврат Истина;	
			ИначеЕсли Настройка = "ОткрыватьПриЗапускеРабочийСтол" Тогда
				Возврат Истина;	
			КонецЕсли;			
			Возврат ПустоеЗначение;
		КонецЕсли;		
		
		Если НастройкаТипЗнчСправочник И ПараметрыДоступа("Чтение", МетаданныеТипаНастройки, "Ссылка").ОграничениеУсловием Тогда
			Запрос = Новый Запрос;
			Запрос.Текст = "ВЫБРАТЬ РАЗРЕШЕННЫЕ 1 ИЗ Справочник." + МетаданныеТипаНастройки.Имя + " ГДЕ Ссылка = &Ссылка";
			Запрос.УстановитьПараметр("Ссылка", Выборка.Значение);
			РезультатЗапроса = Запрос.Выполнить();
			Если РезультатЗапроса.Пустой() Тогда
				Возврат ПустоеЗначение;
			КонецЕсли;
		КонецЕсли;		
		
		Если СписокПолей = Неопределено Тогда
			Возврат Выборка.Значение;
		Иначе
			ЗаполнитьЗначенияСвойств(ПустоеЗначение, Выборка);
			Возврат ПустоеЗначение;
		КонецЕсли;	
		
	Иначе
		Возврат ПустоеЗначение;
	КонецЕсли;	
	
	
КонецФункции // ПолучитьЗначениеПоУмолчаниюПользователя()

// Процедура записывает значение по умолчанию для передаваемого пользователя и настройки.
//
// Параметры:
//  Пользователь - текущий пользователь программы
//  Настройка    - признак, для которого записывается значение по умолчанию
//  Значение     - значение по умолчанию
//
// Возвращаемое значение:
//  Нет
//
Процедура УстановитьЗначениеПоУмолчанию(Пользователь, Настройка, Значение) Экспорт
	
	СсылкаНастройки = ПланыВидовХарактеристик.НастройкиПользователей[Настройка];
	МенеджерЗаписи = РегистрыСведений.НастройкиПользователей.СоздатьМенеджерЗаписи();
	МенеджерЗаписи.Пользователь = Пользователь;
	МенеджерЗаписи.Настройка = СсылкаНастройки;
	МенеджерЗаписи.Значение = Значение;
	МенеджерЗаписи.Записать();
	
КонецПроцедуры // ПолучитьЗначениеПоУмолчанию()

// Процедура выполняет установку настроек по умолчанию для нового пользователя
Процедура УстановитьНастройкиПоУмолчанию(Пользователь) Экспорт
	
	ЗначенияПоУмолчанию = Новый Соответствие;	
	ЗначенияПоУмолчанию.Вставить(ПланыВидовХарактеристик.НастройкиПользователей.ЗапрашиватьПодтверждениеПриЗакрытии, Истина);	
	ЗначенияПоУмолчанию.Вставить(ПланыВидовХарактеристик.НастройкиПользователей.ИспользоватьПомощникаПриемаНаРаботу, Истина);	
	ЗначенияПоУмолчанию.Вставить(ПланыВидовХарактеристик.НастройкиПользователей.ОткрыватьПриЗапускеРабочийСтол, Истина);	
	ЗначенияПоУмолчанию.Вставить(ПланыВидовХарактеристик.НастройкиПользователей.ОсновнойОтветственный, Пользователь);
	
	
	Запрос = Новый Запрос;
	Запрос.Текст = "ВЫБРАТЬ Ссылка ИЗ ПланВидовХарактеристик.НастройкиПользователей ГДЕ Не ЭтоГруппа И Не ПометкаУдаления";
	
	Выборка = Запрос.Выполнить().Выбрать();
	Набор = РегистрыСведений.НастройкиПользователей.СоздатьНаборЗаписей();
	Набор.Отбор.Пользователь.Установить(Пользователь);
	Пока Выборка.Следующий() Цикл
		Запись = Набор.Добавить();
		Запись.Пользователь = Пользователь;
		Запись.Настройка = Выборка.Ссылка;
		Запись.Значение = Запись.Настройка.ТипЗначения.ПривестиЗначение(ЗначенияПоУмолчанию[Запись.Настройка]);
	КонецЦикла;
	Набор.Записать();
	
КонецПроцедуры

Функция ПользовательОпределен() Экспорт
	Если Не ЗначениеЗаполнено(ПараметрыСеанса.ТекущийПользователь) Тогда
		ОписаниеОшибкиОпределенияПользователя = "Пользователь не был найден в справочнике пользователей.
			|Вход в программу возможен только при наличии роли ""Полные права"" или при наличии пользователя в справочнике.";
		#Если Клиент Тогда
			Предупреждение(ОписаниеОшибкиОпределенияПользователя);
			Возврат Ложь;
		#Иначе
			ВызватьИсключение ОписаниеОшибкиОпределенияПользователя;
		#КонецЕсли
	КонецЕсли;
	
	Возврат Истина;
	
КонецФункции

// Процедура инициализирует глобальную переменную глЗначениеПеременной("глТекущийПользователь").
// Переменная содержит ссылку на элемент справочника "Пользователи", 
// соответствующий текущему пользователю информационной базы.
//
// Параметры:
//  Нет.
//
Функция ОпределитьТекущегоПользователя() Экспорт

	Перем ТекущийПользователь;
	
	ИмяПользователя = ИмяПользователя();
	
	Если ПустаяСтрока(ИмяПользователя) Тогда
		// пользователь не авторизовался
		ИмяПользователя = "НеАвторизован";
	КонецЕсли;
	
	НачатьТранзакцию();

	Попытка
		
		// выполняем запрос по поиску элемента в справочнике пользователей
		Запрос = Новый Запрос();
		Запрос.Текст = "ВЫБРАТЬ Первые 1
		               |	Пользователи.Ссылка КАК ССЫЛКА
		               |ИЗ
		               |	Справочник.Пользователи КАК Пользователи
		               |ГДЕ
		               |	Пользователи.Код = &КодПользователя
					   |
					   |ДЛЯ ИЗМЕНЕНИЯ";
					   
		Запрос.УстановитьПараметр("КодПользователя", ИмяПользователя);
		
		Выборка = Запрос.Выполнить().Выбрать();
		
		Если Выборка.Следующий() Тогда
			
			ТекущийПользователь = Выборка.Ссылка;
			
		Иначе	
			
			ТекущийПользователь = Справочники.Пользователи.ПустаяСсылка();
			
		КонецЕсли;
		
		Если ЗначениеЗаполнено(ТекущийПользователь) Тогда
			
			ЗафиксироватьТранзакцию();
			
			Возврат ТекущийПользователь;
			
		КонецЕсли;
			
		// не нашли пользователя
		// попытаемся создать нового пользователя - не авторизован, если есть полные права
		Если НЕ РольДоступна("ПолныеПрава") Тогда
			
			ЗафиксироватьТранзакцию();
			Возврат ТекущийПользователь;
						
		КонецЕсли;		
			
		Если ПустаяСтрока(ИмяПользователя()) Тогда
			ПолноеИмяПользователя = НСтр("ru='Не авторизован';uk='Не авторизований'",Локализация.КодЯзыкаИнформационнойБазы());
		Иначе
			ПолноеИмяПользователя = ПользователиИнформационнойБазы.НайтиПоИмени(ИмяПользователя).ПолноеИмя;
		КонецЕсли;
			
		ОбъектПользователь = Справочники.Пользователи.СоздатьЭлемент();

		ОбъектПользователь.Код          = ИмяПользователя;
		ОбъектПользователь.Наименование = ПолноеИмяПользователя;

		ОбъектПользователь.Записать();
		
		ТекущийПользователь = ОбъектПользователь.Ссылка;
		
		ЗафиксироватьТранзакцию();
			
	Исключение
		
		ОтменитьТранзакцию();
		
		Возврат Справочники.Пользователи.ПустаяСсылка();
			
	КонецПопытки;
			
	УстановитьНастройкиПоУмолчанию(ТекущийПользователь);
		
	Возврат ТекущийПользователь;
	
КонецФункции // ОпределитьТекущегоПользователя()

///////////////////////////////////////////////////////////////////////////////
// ПРОЦЕДУРЫ И ФУНКЦИИ РАБОТЫ С ПОЛЬЗОВАТЕЛЯМИ ИБ

// Функция по имени ищет пользователя ИБ, если не находит - создает нового и его возвращает
// Параметры:
//	ИмяПользователя - строка по которой ищется пользователь ИБ
//  ПолноеИмяПользователя - строка, при добавлении пользователя ИБ таким будет установлено полное имя пользователя
//	СообщатьОДобавленииПользователя - Булево, нужно ли сообщать о добавлении нового пользователя ИБ
//	ЗаписатьПользователяВИБ - Нужно ли при добавлении пользователя записывать его
Функция НайтиПользователяИБ(ИмяПользователя) Экспорт
	
	Если ИмяПользователя = "НеАвторизован" Тогда
		ПользовательИБ = Неопределено
	Иначе
		// ищем пользователя ИБ по имени
		Попытка
			ПользовательИБ = ПользователиИнформационнойБазы.НайтиПоИмени(ИмяПользователя);
		Исключение
			ПользовательИБ = Неопределено;
		КонецПопытки;
		
	КонецЕсли;
	
	Возврат ПользовательИБ;
КонецФункции

#Если Клиент Тогда

//Функция редактирует или создает нового пользователя ИБ
//Процедура редактирует пользователя ИБ
Функция РедактироватьИлиСоздатьПользователяИБ(ОбъектПользователя, ТекущийПользовательИБ, Знач Модифицированность = Ложь,
	Знач ПользовательДляКопированияНастроек = Неопределено) Экспорт
	
	СозданНовыйЭлемент = Ложь;
	
	Если ТекущийПользовательИБ = Неопределено Тогда
		
		Если ОбъектПользователя = Неопределено Тогда
			Возврат Ложь;
		КонецЕсли;
		
		ИмяПользователя = СокрЛП(ОбъектПользователя.Код);
		
		ОтветПользователя = Вопрос(НСтр("ru='Пользователь ИБ с именем ""';uk='Користувач ІБ з іменем ""'") + ИмяПользователя + НСтр("ru='"" не найден. Создать нового пользователя ИБ?';uk='"" не знайдений. Створити нового користувача ІБ?'"), РежимДиалогаВопрос.ДаНет);
		Если ОтветПользователя <> КодВозвратаДиалога.Да Тогда
			Возврат Ложь;
		КонецЕсли;
		
		// создаем нового пользователя ИБ
		ТекущийПользовательИБ = ПользователиИнформационнойБазы.СоздатьПользователя();
		ТекущийПользовательИБ.Имя = ИмяПользователя;
		ТекущийПользовательИБ.ПолноеИмя = СокрЛП(ОбъектПользователя.Наименование);
		
		СозданНовыйЭлемент = Истина;		
		
	КонецЕсли;
	
	// надо показать форму редактирования настроек пользователя ИБ
	ФормаРедактированияПользователяИБ = ПолучитьОбщуюФорму("ФормаПользователяИБ");
	ФормаРедактированияПользователяИБ.ПользовательИБ = ТекущийПользовательИБ;
	ФормаРедактированияПользователяИБ.ПользовательДляКопированияНастроек = ПользовательДляКопированияНастроек;
	ФормаРедактированияПользователяИБ.Модифицированность = Модифицированность ИЛИ СозданНовыйЭлемент;
	ФормаРедактированияПользователяИБ.Пользователь = ОбъектПользователя;
	
	РезультатОткрытия = ФормаРедактированияПользователяИБ.ОткрытьМодально();
	
	Возврат РезультатОткрытия;
	
КонецФункции

#КонецЕсли                                      
