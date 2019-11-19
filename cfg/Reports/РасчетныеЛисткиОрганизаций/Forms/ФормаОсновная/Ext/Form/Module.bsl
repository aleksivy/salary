﻿////////////////////////////////////////////////////////////////////////////////
// ПЕРЕМЕННЫЕ МОДУЛЯ

Перем НП; 
Перем ЭлементОтбораОрганизация;
Перем ЭлементОтбораРаботник;
Перем ЭлементОтбораПодразделение; 

////////////////////////////////////////////////////////////////////////////////
// ВСПОМОГАТЕЛЬНЫЕ ПРОЦЕДУРЫ И ФУНКЦИИ


// Процедура формирует заголовок окна
//
Процедура ОбновитьЗаголовокОкна()

	Заголовок = "Расчетные листки организации";
	
КонецПроцедуры 

////////////////////////////////////////////////////////////////////////////////
// ПРОЦЕДУРЫ - ОБРАБОТЧИКИ СОБЫТИЙ ФОРМЫ

// Процедура - обработчик события "ПередОткрытием" формы.
//
Процедура ПередОткрытием(Отказ, СтандартнаяОбработка)
	
	Если СохранениеНастроек.ЗаполнитьНастройкиПриОткрытииОтчета(ОтчетОбъект) Тогда
		ИнициализацияОтчета();
	КонецЕсли;
	
	ТиповыеОтчеты.НазначитьФормеУникальныйКлючИдентификации(ЭтаФорма);
	ТиповыеОтчеты.ОбновитьФормуТиповогоОтчетаПоКомпоновщику(ОтчетОбъект, ЭтаФорма);
	ТиповыеОтчеты.УправлениеОтображениемЭлементовФормыТиповогоОтчета(ОтчетОбъект, ЭтаФорма);
	
	ЗначениеНачалоПериода = КомпоновщикНастроек.Настройки.ПараметрыДанных.НайтиЗначениеПараметра(Новый ПараметрКомпоновкиДанных("НачалоПериода"));
	ЗначениеКонецПериода  = КомпоновщикНастроек.Настройки.ПараметрыДанных.НайтиЗначениеПараметра(Новый ПараметрКомпоновкиДанных("КонецПериода"));
	
	Если ЗначениеНачалоПериода.Значение = '00010101' или ЗначениеКонецПериода.Значение = '00010101' тогда
		РД = ОбщегоНазначения.ПолучитьРабочуюДату();
		
		НачалоПериода = НачалоМесяца(РД);
		КонецПериода  = КонецМесяца(РД);
		
		ЗначениеНачалоПериода.Значение      = НачалоПериода;
		ЗначениеНачалоПериода.Использование = Истина;
		ЗначениеКонецПериода.Значение       = КонецПериода;
		ЗначениеКонецПериода.Использование  = истина;
	Иначе
		НачалоПериода = ЗначениеНачалоПериода.Значение;
		КонецПериода  = ЗначениеКонецПериода.Значение;
	КонецЕсли;
	
	СтрокаНачалоПериода = РаботаСДиалогами.ДатаКакМесяцПредставление(НачалоПериода);
	СтрокаКонецПериода  = РаботаСДиалогами.ДатаКакМесяцПредставление(КонецПериода);
	
	// Создать список значений для поле ввода "ВидРасчетногоЛистка"
	СписокЗначенийВидовРЛ = Новый СписокЗначений;
	СписокЗначенийВидовРЛ.Добавить("Кратко");
	СписокЗначенийВидовРЛ.Добавить("Подробно");
	
	// Установим список значений полю ввода "ВидРасчетногоЛистка" и значение при открытии
	ЭлементыФормы.ВидРасчетногоЛистка.СписокВыбора = СписокЗначенийВидовРЛ;
	
	ЗначениеВидРасчетногоЛистка = КомпоновщикНастроек.Настройки.ПараметрыДанных.НайтиЗначениеПараметра(Новый ПараметрКомпоновкиДанных("ВидРасчетногоЛистка"));
	
	ЭлементыФормы.ВидРасчетногоЛистка.Значение = ЗначениеВидРасчетногоЛистка.Значение;
	
	//// Добавить расшифровку в схему компоновки данных
	//// расшифровка организация
	//Расшифровка = Новый ПараметрКомпоновкиДанных("Организация");
	//
	Для каждого МакетГруппировки из СхемаКомпоновкиДанных.МакетыГруппировок Цикл
		Если МакетГруппировки.ИмяГруппировки = "ШапкаРасчетногоЛистка" тогда
			ИмяМакетаШапкаРасчетногоЛистка = МакетГруппировки.Макет;
		КонецЕсли;
	КонецЦикла;
	//
	МакетШапкаРасчетногоЛистка = СхемаКомпоновкиДанных.Макеты.Найти(ИмяМакетаШапкаРасчетногоЛистка);
	//
	//МакетШапкаРасчетногоЛистка.Макет[2].Ячейки[0].Оформление.Элементы.Найти("Details").Значение      = Расшифровка;
	//МакетШапкаРасчетногоЛистка.Макет[2].Ячейки[0].Оформление.Элементы.Найти("Details").Использование = истина;
	//
	//// расшифровка подразделений
	//Расшифровка = Новый ПараметрКомпоновкиДанных("Подразделение");
	//МакетШапкаРасчетногоЛистка.Макет[3].Ячейки[9].Оформление.Элементы.Найти("Details").Значение      = Расшифровка;
	//МакетШапкаРасчетногоЛистка.Макет[3].Ячейки[9].Оформление.Элементы.Найти("Details").Использование = истина;
	//
	//// Расшифровка работник
	//Расшифровка = Новый ПараметрКомпоновкиДанных("Работник");
	//МакетШапкаРасчетногоЛистка.Макет[3].Ячейки[0].Оформление.Элементы.Найти("Details").Значение      = Расшифровка;
	//МакетШапкаРасчетногоЛистка.Макет[3].Ячейки[0].Оформление.Элементы.Найти("Details").Использование = истина;
	//
	//// Расшифровка должность
	//Расшифровка = Новый ПараметрКомпоновкиДанных("Должность");
	//МакетШапкаРасчетногоЛистка.Макет[5].Ячейки[9].Оформление.Элементы.Найти("Details").Значение      = Расшифровка;
	//МакетШапкаРасчетногоЛистка.Макет[5].Ячейки[9].Оформление.Элементы.Найти("Details").Использование = истина;
	//
	// запомнить настройки макета
	ЯчейкиМакета = МакетШапкаРасчетногоЛистка.Макет[0].Ячейки;
	
	Для каждого Ячейка из ЯчейкиМакета Цикл
		НастройкаШириныКолонокРасчетногоЛистка.Вставить(ЯчейкиМакета.Индекс(Ячейка), Ячейка.Оформление.Элементы.Найти("MaximumWidth").Значение);
		НастройкаРазмТекстаКолонокРасчетногоЛистка.Вставить(ЯчейкиМакета.Индекс(Ячейка), Ячейка.Оформление.Элементы.Найти("Placement").Значение);
	КонецЦикла;
	
	НастройкаРазмТекстаКолонокРасчетногоЛистка[1] = ТипРазмещенияТекстаКомпоновкиДанных.Выступать;
	
	МакетШапкаРасчетногоЛистка = Неопределено;
	ЯчейкиМакета               = Неопределено;
	
	//
	//// Расшифровка начислений
	//Для каждого МакетГруппировки из СхемаКомпоновкиДанных.МакетыГруппировок Цикл
	//	Если МакетГруппировки.ИмяГруппировки = "СтрокаНачисленийУдержаний" тогда
	//		ИмяМакетаСтрокиНачисления = МакетГруппировки.Макет;
	//	КонецЕсли;
	//КонецЦикла;
	//
	//МакетСтрокиНачисления = СхемаКомпоновкиДанных.Макеты.Найти(ИмяМакетаСтрокиНачисления);
	//
	//Параметр           = МакетСтрокиНачисления.Параметры.Добавить(Тип("ПараметрОбластиВыражениеКомпоновкиДанных"));
	//Параметр.Имя       = "ФизЛицоНачисление";
	//Параметр.Выражение = "Сотрудник";

	//Параметр           = МакетСтрокиНачисления.Параметры.Добавить(Тип("ПараметрОбластиВыражениеКомпоновкиДанных"));
	//Параметр.Имя       = "ФизЛицоУдержание";
	//Параметр.Выражение = "Сотрудник";
	//
	//Расшифровка = Новый ПараметрКомпоновкиДанных("ФизЛицоНачисление");
	//МакетСтрокиНачисления.Макет[0].Ячейки[0].Оформление.Элементы.Найти("Details").Значение      = Расшифровка;
	//МакетСтрокиНачисления.Макет[0].Ячейки[0].Оформление.Элементы.Найти("Details").Использование = истина;
	//
	//Расшифровка = Новый ПараметрКомпоновкиДанных("ФизЛицоУдержание");
	//МакетСтрокиНачисления.Макет[0].Ячейки[9].Оформление.Элементы.Найти("Details").Значение      = Расшифровка;
	//МакетСтрокиНачисления.Макет[0].Ячейки[9].Оформление.Элементы.Найти("Details").Использование = истина;
	
	ВосстановитьНастройкуТабличногоДокумента(ЭлементыФормы.Результат);
	
КонецПроцедуры

// Процедура - обработчик события "ПриОткрытии" формы.
//
Процедура ПриОткрытии()

	ОбновитьЗаголовокОкна();
	
КонецПроцедуры


// Процедура - обработчик события "ПриЗакрытии" формы.
//
Процедура ПриЗакрытии()
	
	СохранитьНастройкуТабличногоДокумента(ЭлементыФормы.Результат);
	
КонецПроцедуры


////////////////////////////////////////////////////////////////////////////////
// ПРОЦЕДУРЫ - ОБРАБОТЧИКИ СОБЫТИЙ КОМАНДНОЙ ПАНЕЛИ ФОРМЫ

Процедура ОбновитьОтчет()
	
	Если НачалоПериода > КонецПериода тогда
		Сообщить(НСтр("ru='Неправильно указан период.';uk='Неправильно вказаний період.'"));
		Возврат;
	КонецЕсли;
	
	Если ФормированиеПечатныхФорм.ЗаполненРегламентированныйПроизводственныйКалендарь(НачалоПериода, КонецПериода) тогда 
		СформироватьОтчет(ЭлементыФормы.Результат, ДанныеРасшифровки, Истина, Истина);
	Иначе
		Сообщить(НСтр("ru='Не заполнен регламентированный производственный календарь';uk='Не заповнений регламентований виробничий календар'"));
	КонецЕсли;
	
	ТекущийЭлемент = ЭлементыФормы.Результат;
	
КонецПроцедуры

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
	ТиповыеОтчеты.ОбработкаИзмененияТиповогоОтчетаНаФормеОтчета(ОтчетОбъект, ЭтаФорма);
	
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
Процедура ДатаНачПриИзменении(Элемент)
	
	РаботаСДиалогами.ДатаКакМесяцПодобратьДатуПоТексту(Элемент.Значение, НачалоПериода);
	
	Элемент.Значение           = РаботаСДиалогами.ДатаКакМесяцПредставление(НачалоПериода);
	
	ЗначениеПараметра          = КомпоновщикНастроек.Настройки.ПараметрыДанных.НайтиЗначениеПараметра(Новый ПараметрКомпоновкиДанных("НачалоПериода"));;
	ЗначениеПараметра.Значение = НачалоМесяца(НачалоПериода);
	ТиповыеОтчеты.ОбработкаИзмененияТиповогоОтчетаНаФормеОтчета(ОтчетОбъект, ЭтаФорма);
	
КонецПроцедуры

// Процедура - обработчик нажатия кнопки выбора даты окончания периода
//
Процедура ДатаКонПриИзменении(Элемент)
	
	РаботаСДиалогами.ДатаКакМесяцПодобратьДатуПоТексту(Элемент.Значение, КонецПериода);
	
	Элемент.Значение           = РаботаСДиалогами.ДатаКакМесяцПредставление(КонецПериода);
	
	ЗначениеПараметра          = КомпоновщикНастроек.Настройки.ПараметрыДанных.НайтиЗначениеПараметра(Новый ПараметрКомпоновкиДанных("КонецПериода"));
	ЗначениеПараметра.Значение = КонецМесяца(КонецПериода);
	ТиповыеОтчеты.ОбработкаИзмененияТиповогоОтчетаНаФормеОтчета(ОтчетОбъект, ЭтаФорма);
	
КонецПроцедуры


// Процедура - обработчик нажатия на кнопку "Настройки"
//
Процедура ДействияФормыНастройки(Кнопка)
	
	//Заполнить настройку группировки расчетного листка
	ЗапомнитьНастройкуРасчетногоЛистка();
	
	// Получим форму настройки отчета
	ФормаНастройки = ПолучитьФорму("ФормаНастройки", ЭтаФорма);
	
	// Заполним настройки  формы
	ФормаНастройки.ОтчетОбъект = ОтчетОбъект;
	
	// Откроем форму настройки
	СформироватьРасчетныеЛистки = ФормаНастройки.ОткрытьМодально();
	
	// Добавим настройку расчетного листка 
	ВосстановитьНастройкуРасчетногоЛистка();
	
	ЗначениеНачалоПериода = КомпоновщикНастроек.Настройки.ПараметрыДанных.НайтиЗначениеПараметра(Новый ПараметрКомпоновкиДанных("НачалоПериода"));
	ЗначениеКонецПериода  = КомпоновщикНастроек.Настройки.ПараметрыДанных.НайтиЗначениеПараметра(Новый ПараметрКомпоновкиДанных("КонецПериода"));
	
	Если ЗначениеКонецПериода.Значение = '00010101' или ЗначениеНачалоПериода.Значение = '00010101' тогда
		РаботаСДиалогами.ДатаКакМесяцПодобратьДатуПоТексту(СтрокаНачалоПериода, НачалоПериода);
		РаботаСДиалогами.ДатаКакМесяцПодобратьДатуПоТексту(СтрокаКонецПериода, КонецПериода);
		ЗначениеНачалоПериода.Значение = НачалоПериода;
		ЗначениеКонецПериода.Значение  = КонецПериода;
	КонецЕсли;
		
	Если СохраненнаяНастройка <> Неопределено 
		И ОтчетОбъект.СохраненнаяНастройка.СохранятьАвтоматически Тогда
		СохранитьНастройку();
	КонецЕсли;

	
	Если СформироватьРасчетныеЛистки <> Неопределено и СформироватьРасчетныеЛистки тогда
		ОбновитьОтчет();
	КонецЕсли;
		
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

// Процедура - обработчик выбора ячейки с расшифровкой 
//
Процедура РезультатОбработкаРасшифровки(Элемент, Расшифровка, СтандартнаяОбработка)
	
	Если ТипЗнч(Расшифровка) = Тип("ИдентификаторРасшифровкиКомпоновкиДанных") тогда
		
		ПоляРасшифровки = ДанныеРасшифровки.Элементы[Расшифровка].ПолучитьПоля();
		Для каждого ПолеРасшифровки из ПоляРасшифровки Цикл
			Если ПолеРасшифровки.Поле = "Сотрудник" тогда
				Сотрудник = ПолеРасшифровки.Значение;
			КонецЕсли;
			Если ПолеРасшифровки.Поле = "ПериодРегистрации" тогда
				ПериодРегистрации = ПолеРасшифровки.Значение;
			КонецЕсли;
		КонецЦикла;
	КонецЕсли;
	
	

	Если ВидРасчетногоЛистка = "Кратко" и Сотрудник <> Неопределено и ПериодРегистрации <> Неопределено тогда
		
		ПоляРасшифровки = ДанныеРасшифровки.Элементы[Расшифровка].ПолучитьПоля();
		Для каждого ПолеРасшифровки из ПоляРасшифровки Цикл
			Если ПолеРасшифровки.Поле = "Сотрудник" тогда
				Сотрудник = ПолеРасшифровки.Значение;
			КонецЕсли;
			Если ПолеРасшифровки.Поле = "ПериодРегистрации" тогда
				ПериодРегистрации = ПолеРасшифровки.Значение;
			КонецЕсли;
		КонецЦикла;
		
		Если Сотрудник <> Неопределено и ПериодРегистрации <> Неопределено тогда
			
			ОтчетРасшифровка = Отчеты.РасчетныеЛисткиОрганизаций.Создать();
			
			ТиповыеОтчеты.ДобавитьОтбор(ОтчетРасшифровка.КомпоновщикНастроек,      "Сотрудник",           Сотрудник);
			ТиповыеОтчеты.УстановитьПараметр(ОтчетРасшифровка.КомпоновщикНастроек, "НачалоПериода",       ПериодРегистрации);
			ТиповыеОтчеты.УстановитьПараметр(ОтчетРасшифровка.КомпоновщикНастроек, "КонецПериода",        КонецМесяца(ПериодРегистрации));
			ТиповыеОтчеты.УстановитьПараметр(ОтчетРасшифровка.КомпоновщикНастроек, "Группировать",        ложь);
			ТиповыеОтчеты.УстановитьПараметр(ОтчетРасшифровка.КомпоновщикНастроек, "ВидРасчетногоЛистка", "Подробно");
			
			ФормаОтчета = ОтчетРасшифровка.ПолучитьФорму("ФормаОсновная", );
			ФормаОтчета.Открыть();
			
			ОтчетРасшифровка.СформироватьОтчет(ФормаОтчета.ЭлементыФормы.Результат, ФормаОтчета.ДанныеРасшифровки, истина);
			
			СтандартнаяОбработка = ложь;
			
		КонецЕсли;
	ИначеЕсли Сотрудник <> Неопределено и ПериодРегистрации <> Неопределено тогда
		
		СтандартнаяОбработка = ложь;
		
	ИначеЕсли ТипЗнч(Расшифровка) = Тип("ИдентификаторРасшифровкиКомпоновкиДанных") тогда
		
		ВыполненноеДействие = Неопределено;

		СтандартнаяОбработка = Ложь;
		
		// Создадим и инициализируем обработчик расшифровки
		ОбработкаРасшифровки = Новый ОбработкаРасшифровкиКомпоновкиДанных(ДанныеРасшифровки, Новый ИсточникДоступныхНастроекКомпоновкиДанных(СхемаКомпоновкиДанных));
		
		ДоступныеДействия = Новый Массив();
		ДоступныеДействия.Добавить(ДействиеОбработкиРасшифровкиКомпоновкиДанных.ОткрытьЗначение);
		
		// Осуществим выбор действия расшифровки пользователем
		Настройки = ОбработкаРасшифровки.Выполнить(Расшифровка, ВыполненноеДействие, ДоступныеДействия);
		
	КонецЕсли;
	
КонецПроцедуры

Процедура ДействияФормыЗаголовок(Кнопка)
	Кнопка.Пометка = Не Кнопка.Пометка;
	ТиповыеОтчеты.УправлениеОтображениемЭлементовФормыТиповогоОтчета(ОтчетОбъект, ЭтаФорма);
	ТиповыеОтчеты.УправлениеОтображениемЗаголовкаТиповогоОтчета(ОтчетОбъект, ЭтаФорма.ЭлементыФормы.Результат);
КонецПроцедуры

Процедура НачалоПериодаРегулирование(Элемент, Направление, СтандартнаяОбработка)
	НачалоПериода = ДобавитьМесяц(НачалоПериода, Направление);
	Элемент.Значение = РаботаСДиалогами.ДатаКакМесяцПредставление(НачалоПериода);
	ЗначениеПараметра          = КомпоновщикНастроек.Настройки.ПараметрыДанных.НайтиЗначениеПараметра(Новый ПараметрКомпоновкиДанных("НачалоПериода"));;
	ЗначениеПараметра.Значение = НачалоМесяца(НачалоПериода);
	ТиповыеОтчеты.ОбработкаИзмененияТиповогоОтчетаНаФормеОтчета(ОтчетОбъект, ЭтаФорма);
КонецПроцедуры

Процедура НачалоПериодаАвтоПодборТекста(Элемент, Текст, ТекстАвтоПодбора, СтандартнаяОбработка)
	РаботаСДиалогами.ДатаКакМесяцАвтоПодборТекста(Текст, ТекстАвтоПодбора, СтандартнаяОбработка);
КонецПроцедуры

Процедура НачалоПериодаНачалоВыбораИзСписка(Элемент, СтандартнаяОбработка)
	РаботаСДиалогами.НачалоВыбораИзСпискаПредставленияПериодаРегистрации(Элемент, СтандартнаяОбработка, НачалоПериода, ЭтаФорма);
	ЗначениеПараметра          = КомпоновщикНастроек.Настройки.ПараметрыДанных.НайтиЗначениеПараметра(Новый ПараметрКомпоновкиДанных("НачалоПериода"));;
	ЗначениеПараметра.Значение = НачалоМесяца(НачалоПериода);
	ТиповыеОтчеты.ОбработкаИзмененияТиповогоОтчетаНаФормеОтчета(ОтчетОбъект, ЭтаФорма);
КонецПроцедуры

Процедура НачалоПериодаОчистка(Элемент, СтандартнаяОбработка)
	СтандартнаяОбработка = Ложь;
КонецПроцедуры

Процедура КонецПериодаНачалоВыбораИзСписка(Элемент, СтандартнаяОбработка)
	РаботаСДиалогами.НачалоВыбораИзСпискаПредставленияПериодаРегистрации(Элемент, СтандартнаяОбработка, КонецПериода, ЭтаФорма);
	ЗначениеПараметра          = КомпоновщикНастроек.Настройки.ПараметрыДанных.НайтиЗначениеПараметра(Новый ПараметрКомпоновкиДанных("КонецПериода"));
	ЗначениеПараметра.Значение = КонецМесяца(КонецПериода);
	ТиповыеОтчеты.ОбработкаИзмененияТиповогоОтчетаНаФормеОтчета(ОтчетОбъект, ЭтаФорма);
КонецПроцедуры

Процедура КонецПериодаОчистка(Элемент, СтандартнаяОбработка)
	СтандартнаяОбработка = Ложь;
КонецПроцедуры

Процедура КонецПериодаРегулирование(Элемент, Направление, СтандартнаяОбработка)
	КонецПериода = ДобавитьМесяц(КонецПериода, Направление);
	Элемент.Значение = РаботаСДиалогами.ДатаКакМесяцПредставление(КонецПериода);
	ЗначениеПараметра          = КомпоновщикНастроек.Настройки.ПараметрыДанных.НайтиЗначениеПараметра(Новый ПараметрКомпоновкиДанных("КонецПериода"));
	ЗначениеПараметра.Значение = КонецМесяца(КонецПериода);
	ТиповыеОтчеты.ОбработкаИзмененияТиповогоОтчетаНаФормеОтчета(ОтчетОбъект, ЭтаФорма);
КонецПроцедуры

Процедура КонецПериодаАвтоПодборТекста(Элемент, Текст, ТекстАвтоПодбора, СтандартнаяОбработка)
	РаботаСДиалогами.ДатаКакМесяцАвтоПодборТекста(Текст, ТекстАвтоПодбора, СтандартнаяОбработка);
КонецПроцедуры

Процедура ВидРасчетногоЛисткаПриИзменении(Элемент)
	ЗначениеПараметра          = КомпоновщикНастроек.Настройки.ПараметрыДанных.НайтиЗначениеПараметра(Новый ПараметрКомпоновкиДанных("ВидРасчетногоЛистка"));
	ЗначениеПараметра.Значение = Элемент.Значение;
КонецПроцедуры

// Процедура - обработчик события обновление отображения формы
//
Процедура ОбновлениеОтображения()
	
	ТиповыеОтчеты.ОбновитьЗаголовокТиповогоОтчета(ОтчетОбъект, ЭтаФорма);
	
КонецПроцедуры

Процедура ТабличноеПолеОтборПриИзмененииФлажка(Элемент, Колонка)
	
	ТиповыеОтчеты.ОбработкаИзмененияТиповогоОтчетаНаФормеОтчета(ОтчетОбъект, ЭтаФорма);
	
КонецПроцедуры

Процедура ТабличноеПолеОтборПравоеЗначениеДляКраткогоОтображенияЭлементаНачалоВыбора(Элемент, СтандартнаяОбработка)
	
	ФормированиеПечатныхФорм.ПодставитьОтборОрганизации(Элемент, КомпоновщикНастроек, Новый ПолеКомпоновкиДанных("Организация"), ЭтотОбъект, СтандартнаяОбработка);
	
КонецПроцедуры

Процедура ТабличноеПолеОтборПриОкончанииРедактирования(Элемент, НоваяСтрока, ОтменаРедактирования)
	
	ТиповыеОтчеты.ОбработкаИзмененияТиповогоОтчетаНаФормеОтчета(ОтчетОбъект, ЭтаФорма);
	
КонецПроцедуры

