Перем СимволМеньше, СимволРавно, СимволБольше;

Процедура ОсновныеДействияФормыОК(Кнопка)
	
	Если ПустаяСтрока(ВерхняяГраница)
	 ИЛИ ПустаяСтрока(Значение)
	 ИЛИ ПустаяСтрока(НижняяГраница)
	 ИЛИ ПустаяСтрока(Наименование) Тогда
		Возврат;
	КонецЕсли;
	
	СозданоПользовательскоеПоле = Ложь;
	Если ПользовательскоеПоле = Неопределено Тогда
		ПользовательскоеПоле = КомпоновщикНастроек.Настройки.ПользовательскиеПоля.Элементы.Добавить(Тип("ПользовательскоеПолеВыборКомпоновкиДанных"));
		СозданоПользовательскоеПоле = Истина;
	Иначе
		ПользовательскоеПоле.Варианты.Элементы.Очистить();
	КонецЕсли;
	ПользовательскоеПоле.Заголовок = Наименование;
	
	// меньше
	Вариант = ПользовательскоеПоле.Варианты.Элементы.Добавить();
	ЭлементОтбора = Вариант.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	//ЭлементОтбора.Представление = ПользовательскоеПоле.Заголовок + " " + СимволМеньше;
	ЭлементОтбора.ЛевоеЗначение = Новый ПолеКомпоновкиДанных(Значение);
	ЭлементОтбора.ВидСравнения = ВидСравненияКомпоновкиДанных.Меньше;
	ЭлементОтбора.ПравоеЗначение = Новый ПолеКомпоновкиДанных(НижняяГраница);
	Вариант.Значение = "1" + Режим;
	Вариант.Представление = СимволМеньше;
	// равно
	Вариант = ПользовательскоеПоле.Варианты.Элементы.Добавить();
	ГруппаЭлементовОтбора = Вариант.Отбор.Элементы.Добавить(Тип("ГруппаЭлементовОтбораКомпоновкиДанных"));
	ГруппаЭлементовОтбора.ТипГруппы = ТипГруппыЭлементовОтбораКомпоновкиДанных.ГруппаИ;
	//ГруппаЭлементовОтбора.Представление = ПользовательскоеПоле.Заголовок + " " + СимволРавно;
	// 1 элемент
	ЭлементОтбора = ГруппаЭлементовОтбора.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ЭлементОтбора.ЛевоеЗначение = Новый ПолеКомпоновкиДанных(Значение);
	ЭлементОтбора.ВидСравнения = ВидСравненияКомпоновкиДанных.МеньшеИлиРавно;
	ЭлементОтбора.ПравоеЗначение = Новый ПолеКомпоновкиДанных(ВерхняяГраница);
	// 2 элемент
	ЭлементОтбора = ГруппаЭлементовОтбора.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ЭлементОтбора.ЛевоеЗначение = Новый ПолеКомпоновкиДанных(Значение);
	ЭлементОтбора.ВидСравнения = ВидСравненияКомпоновкиДанных.БольшеИлиРавно;
	ЭлементОтбора.ПравоеЗначение = Новый ПолеКомпоновкиДанных(НижняяГраница);
	Вариант.Значение = "2" + Режим;
	Вариант.Представление = СимволРавно;
	// больше
	Вариант = ПользовательскоеПоле.Варианты.Элементы.Добавить();
	ЭлементОтбора = Вариант.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	//ЭлементОтбора.Представление = ПользовательскоеПоле.Заголовок + " " + СимволБольше;
	ЭлементОтбора.ЛевоеЗначение = Новый ПолеКомпоновкиДанных(Значение);
	ЭлементОтбора.ВидСравнения = ВидСравненияКомпоновкиДанных.Больше;
	ЭлементОтбора.ПравоеЗначение = Новый ПолеКомпоновкиДанных(ВерхняяГраница);
	Вариант.Значение = "3" + Режим;
	Вариант.Представление = СимволБольше;
	Закрыть(СозданоПользовательскоеПоле);
	
КонецПроцедуры

Процедура ПриОткрытии()
	
	СписокРесурсов = ТиповыеОтчеты.ПолучитьСписокДоступныхРесурсов(КомпоновщикНастроек, Ложь, Ложь);
	
	ЭлементыФормы.НижняяГраница.СписокВыбора = СписокРесурсов;
	ЭлементыФормы.ВерхняяГраница.СписокВыбора = СписокРесурсов;
	ЭлементыФормы.Значение.СписокВыбора = СписокРесурсов;
	
	Если ПользовательскоеПоле <> Неопределено Тогда
		Наименование = ПользовательскоеПоле.Заголовок;
		НижняяГраница = ПользовательскоеПоле.Варианты.Элементы[0].Отбор.Элементы[0].ПравоеЗначение;
		ВерхняяГраница = ПользовательскоеПоле.Варианты.Элементы[2].Отбор.Элементы[0].ПравоеЗначение;
		Значение = ПользовательскоеПоле.Варианты.Элементы[0].Отбор.Элементы[0].ЛевоеЗначение;
		Режим = Сред(ПользовательскоеПоле.Варианты.Элементы[0].Значение, 2);
	КонецЕсли;
	
	Если Режим = "Тренд" Тогда
		//СимволМеньше = Символ(8595);
		СимволМеньше = Символ(8594);
		СимволРавно  = Символ(8594);
		СимволБольше = Символ(8594);
		//СимволБольше = Символ(8593);
	Иначе
		СимволМеньше = Символ(9660);
		СимволРавно  = Символ(9632);
		СимволБольше = Символ(9650);
	КонецЕсли;
	Заголовок = "Редактирование поля """ + Режим + """";
	
КонецПроцедуры               

Процедура ЗначениеПриИзменении(Элемент)
	
	Если ПустаяСтрока(Наименование) Тогда
		Наименование = Режим + " (" + Значение + ")";
	КонецЕсли;
	
КонецПроцедуры
