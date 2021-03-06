
////////////////////////////////////////////////////////////////////////////////
// СЛУЖЕБНЫЕ ПРОЦЕДУРЫ И ФУНКЦИИ

// Управляет пометками кнопок ком. панели
//
// Параметры:
//	Нет.
//
Процедура УправлениеПометкамиКнопокКоманднойПанели()
	
	Если ПоказыватьЗаголовок Тогда
		ЭлементыФормы.КоманднаяПанель.Кнопки.Заголовок.Пометка = Истина;
		ЭлементыФормы.КоманднаяПанель.Кнопки[0].Кнопки.Заголовок.Пометка = Истина;

	Иначе
		ЭлементыФормы.КоманднаяПанель.Кнопки.Заголовок.Пометка = Ложь;
		ЭлементыФормы.КоманднаяПанель.Кнопки[0].Кнопки.Заголовок.Пометка = Ложь;

	КонецЕсли;

	Если ЭлементыФормы.ПанельОтбор.Свертка = РежимСверткиЭлементаУправления.Верх Тогда
		ЭлементыФормы.КоманднаяПанель.Кнопки.Отбор.Пометка = Ложь;
		ЭлементыФормы.КоманднаяПанель.Кнопки[0].Кнопки.Отбор.Пометка = Ложь;
	Иначе
		ЭлементыФормы.КоманднаяПанель.Кнопки.Отбор.Пометка = Истина;
		ЭлементыФормы.КоманднаяПанель.Кнопки[0].Кнопки.Отбор.Пометка = Истина;
	КонецЕсли;
	
КонецПроцедуры // УправлениеПометкамиКнопокКоманднойПанели()

////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ ФОРМЫ

// Обработчик события ПриОткрытии формы.
//
Процедура ПриОткрытии()
	
	УправлениеОтчетами.УстановитьСвязьПолейБыстрогоОтбораНаФорме(ЭлементыФормы, ПостроительОтчета.Отбор, мСтруктураСвязиЭлементовСДанными, "ОбработкаОбъект.ПостроительОтчета.Отбор");
	
	Если НЕ ЗначениеЗаполнено(ДатаНач) Тогда
		ДатаНач = ОбщегоНазначения.ПолучитьРабочуюДату();
	КонецЕсли;
	
	ВидСравнения1 = ВидСравнения.Равно;
	ВидСравнения2 = ВидСравнения.Равно;
	
	ЭлементыФормы.ПанельОтбор.Свертка = РежимСверткиЭлементаУправления.Верх;	

	УправлениеПометкамиКнопокКоманднойПанели();
		
КонецПроцедуры

// Обработчик события ПередОткрытием формы.
//
Процедура ПередОткрытием(Отказ, СтандартнаяОбработка)
	
	ЗаполнитьТаблицуВидовКИ();	
	
	ЗаполнитьНачальныеНастройки();
	
КонецПроцедуры

// Обработчик события ПередСохранениемЗначений формы.
//
Процедура ПередСохранениемЗначений(Отказ)
	
	СохраненныеНастройки = Новый Структура;
	
	СохраненныеНастройки.Вставить("ВидыКонтактнойИнформации"               , ВидыКонтактнойИнформации.Выгрузить());
	СохраненныеНастройки.Вставить("НастройкиПостроителя"                   , ПостроительОтчета.ПолучитьНастройки());
	СохраненныеНастройки.Вставить("ПоказыватьЗаголовок"                    , ПоказыватьЗаголовок);
	СохраненныеНастройки.Вставить("РаскрашиватьГруппировки"                , РаскрашиватьГруппировки);
	
КонецПроцедуры

// Обработчик события ПослеВосстановленияЗначений формы.
//
Процедура ПослеВосстановленияЗначений()
	
	Перем ТаблицаНастроек;
	
	Если НЕ НеЗаполнятьНастройкиПриОткрытии Тогда
	
		Если ТипЗнч(СохраненныеНастройки) = Тип("Структура") Тогда
			
			ЗаполнитьНачальныеНастройки();
	    	
	    	ПостроительОтчета.УстановитьНастройки(СохраненныеНастройки.НастройкиПостроителя);
	    	
	    	СохраненныеНастройки.Свойство("ПоказыватьЗаголовок"                    , ПоказыватьЗаголовок);
	    	СохраненныеНастройки.Свойство("РаскрашиватьГруппировки"                , РаскрашиватьГруппировки);
	    	СохраненныеНастройки.Свойство("ВидыКонтактнойИнформации"               , ТаблицаНастроек);
	    	ВидыКонтактнойИнформации.Загрузить(ТаблицаНастроек);
		
		КонецЕсли;
		
	КонецЕсли;
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ ЭЛЕМЕНТОВ УПРАВЛЕНИЯ КОМАНДНОЙ ПАНЕЛИ ФОРМЫ

// Обработчик события элемента КоманднаяПанельФормы.Сформировать.
//
Процедура КоманднаяПанельФормыСформировать(Кнопка)

	СформироватьОтчет(ЭлементыФормы.ПолеТабличногоДокумента);

КонецПроцедуры

// Обработчик события элемента КоманднаяПанельФормы.Сформировать.
//
Процедура КоманднаяПанельФормыНастройка(Кнопка)

	ОтветОтФормы = ОбработкаОбъект.ПолучитьФорму("ФормаНастройки", ЭтаФорма).ОткрытьМодально();

	Если ОтветОтФормы = Истина Тогда
		СформироватьОтчет(ЭлементыФормы.ПолеТабличногоДокумента);
	КонецЕсли; 

КонецПроцедуры

// Обработчик события элемента КоманднаяПанельФормы.Заголовок.
//
Процедура КоманднаяПанельФормыЗаголовок(Кнопка)

	ПоказыватьЗаголовок = НЕ ПоказыватьЗаголовок;
	ИзменитьВидимостьЗаголовка(ЭлементыФормы.ПолеТабличногоДокумента);
	УправлениеПометкамиКнопокКоманднойПанели();
	
КонецПроцедуры

// Обработчик события элемента КоманднаяПанельФормы.Отбор.
//
Процедура КоманднаяПанельФормыОтбор(Кнопка)

	Если НЕ ЭлементыФормы.ПанельОтбор.Свертка = РежимСверткиЭлементаУправления.Верх Тогда
		ЭлементыФормы.ПанельОтбор.Свертка = РежимСверткиЭлементаУправления.Верх;
	Иначе
		ЭлементыФормы.ПанельОтбор.Свертка = РежимСверткиЭлементаУправления.Нет;
	КонецЕсли;	

	УправлениеПометкамиКнопокКоманднойПанели();
	
КонецПроцедуры

// Процедура - обработчик нажатия кнопки "На принтер"
Процедура ДействияФормыНаПринтер(Кнопка)
	
	ЭлементыФормы.ПолеТабличногоДокумента.Напечатать();

КонецПроцедуры

// Процедура - обработчик нажатия кнопки "НовыйОтчет"
//
Процедура КоманднаяПанельФормыНовыйОтчет(Кнопка)
	
	Если Строка(ЭтотОбъект) = "ВнешняяОбработкаОбъект." + ЭтотОбъект.Метаданные().Имя Тогда
			
		Предупреждение(НСтр("ru='Данный отчет является внешней обработкой.';uk='Даний звіт є зовнішньою обробкою.'") + Символы.ПС + НСтр("ru='Открытие нового отчета возможно только для объектов конфигурации.';uk=""Відкриття нового звіту можливо тільки для об'єктів конфігурації."""));
		Возврат;
			
	Иначе
			
		НовыйОтчет = Отчеты[ЭтотОбъект.Метаданные().Имя].Создать();
			
	КонецЕсли;
	
	ФормаНовогоОтчета = НовыйОтчет.ПолучитьФорму();
	ФормаНовогоОтчета.Открыть();

КонецПроцедуры // КоманднаяПанельФормыНовыйОтчет()

////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ ЭЛЕМЕНТОВ ФОРМЫ


// Обработчик события ПриИзменении элемента формы ПолеВидаСравненияОбъект.
//
Процедура ПолеВидаСравненияОбъектПриИзменении(Элемент)
	
	УправлениеОтчетами.ПолеВидаСравненияПриИзменении(Элемент, ЭлементыФормы);
	
КонецПроцедуры

// Обработчик события ПриИзменении элемента формы ПолеНастройкиОбъект.
//
Процедура ПолеНастройкиОбъектПриИзменении(Элемент)
	
	УправлениеОтчетами.ПолеНастройкиПриИзменении(Элемент, ПостроительОтчета.Отбор);
	
КонецПроцедуры

