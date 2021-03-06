////////////////////////////////////////////////////////////////////////////////
// ВСПОМОГАТЕЛЬНЫЕ ПРОЦЕДУРЫ И ФУНКЦИИ

Процедура ЗаголовокФормы()
	
	Если ОтборОрганизации Тогда
		
		Заголовок = "Табель рабочего времени по " 
		+ ?(ВидСравненияОрганизации = ВидСравнения.ВСписке Или ВидСравненияОрганизации = ВидСравнения.НеВСписке,"списку организаций: ","организации: ") 
		+ ?(ЗначениеЗаполнено(Организация),Организация,"<Не задано значение>")
		
	Иначе
		Заголовок = "Табель рабочего времени"
	КонецЕсли; 	
	
	Заголовок = УправлениеОтчетами.СформироватьЗаголовокОсновнойФормы(ДатаНач, КонецМесяца(ДатаНач), Заголовок, 2);
	
КонецПроцедуры

// Устанавливает видимость панели быстрого отбора
Процедура УстановитьВидимостьПанелиБыстрогоОтбора(Показать = Неопределено)
	
	Если НЕ ЭлементыФормы.ПанельОтбор.Свертка = РежимСверткиЭлементаУправления.Верх 
		И  НЕ Показать = Истина Тогда
		
		ЭлементыФормы.ПанельОтбор.Свертка = РежимСверткиЭлементаУправления.Верх;
		ЭлементыФормы.ДействияФормы.Кнопки.Отбор.Пометка = Ложь;
		ЭлементыФормы.ДействияФормы.Кнопки.Подменю.Кнопки.Отбор.Пометка = Ложь;
		
	Иначе
		
		ЭлементыФормы.ПанельОтбор.Свертка = РежимСверткиЭлементаУправления.Нет;
		ЭлементыФормы.ДействияФормы.Кнопки.Отбор.Пометка = Истина;
		ЭлементыФормы.ДействияФормы.Кнопки.Подменю.Кнопки.Отбор.Пометка = Истина;
		
	КонецЕсли;
	
КонецПроцедуры



////////////////////////////////////////////////////////////////////////////////
// ПРОЦЕДУРЫ - ОБРАБОТЧИКИ СОБЫТИЙ КОМАНДНОЙ ПАНЕЛИ ФОРМЫ

Процедура ДействияФормыСформировать(Кнопка)
	ТекстОшибки = "";
	СформироватьОтчет(ЭлементыФормы.ДокументРезультат, "Табель", ТекстОшибки);
	Если ТекстОшибки <> "" Тогда
		Предупреждение(ТекстОшибки);
	КонецЕсли;
КонецПроцедуры

Процедура ДействияФормыБланк(Кнопка)
	ТекстОшибки = "";
	СформироватьОтчет(ЭлементыФормы.ДокументРезультат, "Бланк", ТекстОшибки);
	Если ТекстОшибки <> "" Тогда
		Предупреждение(ТекстОшибки);
	КонецЕсли;
КонецПроцедуры

Процедура ДействияФормыОтбор(Кнопка)
	УстановитьВидимостьПанелиБыстрогоОтбора();	
КонецПроцедуры

// Процедура - обработчик нажатия кнопки "На принтер"
Процедура ДействияФормыНаПринтер(Кнопка)
	
	ЭлементыФормы.ДокументРезультат.Напечатать();
	
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
// ПРОЦЕДУРЫ - ОБРАБОТЧИКИ СОБЫТИЙ ФОРМЫ

Процедура ПередОткрытием(Отказ, СтандартнаяОбработка)
	
	// Установим дату начала отчета
	Если ДатаНач = Дата(1,1,1) Тогда
		Если ЗначениеЗаполнено(глЗначениеПеременной("глТекущийПользователь")) Тогда
			
			ЕстьДатаОтчетаПользователя = ЗначениеЗаполнено(УправлениеПользователями.ПолучитьЗначениеПоУмолчанию(глЗначениеПеременной("глТекущийПользователь"),"ОсновнаяДатаНачалаОтчетов"));
			
			Если Не ЕстьДатаОтчетаПользователя Тогда
				ДатаНач = НачалоМесяца(ОбщегоНазначения.ПолучитьРабочуюДату());
			Иначе
				ДатаНач = НачалоМесяца(УправлениеПользователями.ПолучитьЗначениеПоУмолчанию(глЗначениеПеременной("глТекущийПользователь"),"ОсновнаяДатаНачалаОтчетов"));
			КонецЕсли;
			
		Иначе
			ДатаНач = НачалоМесяца(ОбщегоНазначения.ПолучитьРабочуюДату());
		КонецЕсли;
	КонецЕсли;	
	
	МесяцСтрока = РаботаСДиалогами.ДатаКакМесяцПредставление(ДатаНач);
	
	УстановитьВидимостьПанелиБыстрогоОтбора();	
	
КонецПроцедуры

Процедура ПриОткрытии()
	
	Если Не ЗначениеЗаполнено(Организация) Тогда
		
		ЭлементыФормы.ПолеНастройкиОрганизация.ОграничениеТипа = Новый ОписаниеТипов("СправочникСсылка.Организации");
		Организация = ОбщегоНазначения.ПустоеЗначениеТипа("СправочникСсылка.Организации");
		ВидСравненияОрганизации     = ВидСравнения.Равно;
		
		Если ЗначениеЗаполнено(глЗначениеПеременной("глТекущийПользователь")) Тогда
			
			Организация = УправлениеПользователями.ПолучитьЗначениеПоУмолчанию(глЗначениеПеременной("глТекущийПользователь"), "ОсновнаяОрганизация");
			ОтборОрганизации = Не Организация.Пустая();
			
		КонецЕсли;
		
	КонецЕсли;
	
	Если Не ЗначениеЗаполнено(Работник) Тогда
		ЭлементыФормы.ПолеНастройкиРаботник.ОграничениеТипа = Новый ОписаниеТипов("СправочникСсылка.СотрудникиОрганизаций");
		Работник = ОбщегоНазначения.ПустоеЗначениеТипа("СправочникСсылка.СотрудникиОрганизаций");
		ВидСравненияРаботника     = ВидСравнения.Равно;
	КонецЕсли;
	
	Если Не ЗначениеЗаполнено(Подразделение) Тогда
		ЭлементыФормы.ПолеНастройкиПодразделение.ОграничениеТипа = Новый ОписаниеТипов("СправочникСсылка.ПодразделенияОрганизаций");
		Подразделение = ОбщегоНазначения.ПустоеЗначениеТипа("СправочникСсылка.ПодразделенияОрганизаций");
		ВидСравненияПодразделения     = ВидСравнения.Равно;
	КонецЕсли;
	
	Если ОтборОрганизации ИЛИ ОтборПодразделения ИЛИ ОтборРаботника Тогда
		УстановитьВидимостьПанелиБыстрогоОтбора(Истина);
	КонецЕсли;
	
	ЗаголовокФормы();
	
КонецПроцедуры

Процедура ПослеВосстановленияЗначений()
	ЗаголовокФормы();
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// ПРОЦЕДУРЫ - ОБРАБОТЧИКИ СОБЫТИЙ ЭЛЕМЕНТОВ ФОРМЫ

// Процедура - обработчик события "ПриИзменении" поля ввода периода.
//
Процедура МесяцСтрокаПриИзменении(Элемент)
	
	РаботаСДиалогами.ДатаКакМесяцПодобратьДатуПоТексту(Элемент.Значение, ДатаНач);
	Элемент.Значение = РаботаСДиалогами.ДатаКакМесяцПредставление(ДатаНач);
	
	ЗаголовокФормы();
	
КонецПроцедуры

// Процедура - обработчик события "НачалоВыбораИзСписка" поля ввода периода.
//
Процедура МесяцСтрокаНачалоВыбораИзСписка(Элемент, СтандартнаяОбработка)
	
	РаботаСДиалогами.НачалоВыбораИзСпискаПредставленияПериодаРегистрации(Элемент, СтандартнаяОбработка, ДатаНач, ЭтаФорма);
	ЗаголовокФормы();
	
КонецПроцедуры

// Процедура - обработчик события "Очистка" поля ввода периода.
//
Процедура МесяцСтрокаОчистка(Элемент, СтандартнаяОбработка)
	СтандартнаяОбработка = Ложь;
КонецПроцедуры

// Процедура - обработчик события "Регулирование" поля ввода периода.
//
Процедура МесяцСтрокаРегулирование(Элемент, Направление, СтандартнаяОбработка)
	
	ДатаНач = ДобавитьМесяц(ДатаНач, Направление);
	Элемент.Значение = РаботаСДиалогами.ДатаКакМесяцПредставление(ДатаНач);
	
	ЗаголовокФормы();
	
КонецПроцедуры

// Процедура - обработчик события "АвтоПодборТекста" поля ввода периода.
//
Процедура МесяцСтрокаАвтоПодборТекста(Элемент, Текст, ТекстАвтоПодбора, СтандартнаяОбработка)
	РаботаСДиалогами.ДатаКакМесяцАвтоПодборТекста(Текст, ТекстАвтоПодбора, СтандартнаяОбработка);
КонецПроцедуры

// Процедура - обработчик события "ОкончаниеВводаТекста" поля ввода периода.
//
Процедура МесяцСтрокаОкончаниеВводаТекста(Элемент, Текст, Значение, СтандартнаяОбработка)
	РаботаСДиалогами.ДатаКакМесяцОкончаниеВводаТекста(Текст, Значение, СтандартнаяОбработка);
КонецПроцедуры

// Процедура - обработчик изменения флажка отбора по организации.
//
Процедура ФлажокНастройкиОрганизацияПриИзменении(Элемент)
	ЗаголовокФормы();
КонецПроцедуры

// Процедура - обработчик изменения данных в поле выбора вида сравнения
//
Процедура ПолеВидаСравненияОрганизацияПриИзменении(Элемент)
	
	Если ТипЗнч(Организация) = Тип("СправочникСсылка.Организации") Тогда
		ЗаписываемоеЗначение = Организация;                                                               
	Иначе
		Если Организация.Количество() = 0 Тогда    
			ЗаписываемоеЗначение = ОбщегоНазначения.ПустоеЗначениеТипа("СправочникСсылка.Организации")
		Иначе
			ЗаписываемоеЗначение = Организация[0].Значение;
		КонецЕсли;
	КонецЕсли;
	
	Если Элемент.Значение = ВидСравнения.ВСписке ИЛИ Элемент.Значение = ВидСравнения.НеВСписке Тогда
		
		ЭлементыФормы.ПолеНастройкиОрганизация.ОграничениеТипа	  = Новый ОписаниеТипов("СписокЗначений");
		Организация = Новый СписокЗначений;
		Если ЗначениеЗаполнено(ЗаписываемоеЗначение) Тогда
			Организация.Добавить(ЗаписываемоеЗначение);
		КонецЕсли;
		
	Иначе              
		
		ЭлементыФормы.ПолеНастройкиОрганизация.ОграничениеТипа = Новый ОписаниеТипов("СправочникСсылка.Организации");
		Организация = ЗаписываемоеЗначение;
		
	КонецЕсли; 
	
	ЗаголовокФормы();
	
КонецПроцедуры

// Процедура - обработчик изменения данных в поле значения отбора
//
Процедура ПолеНастройкиОрганизацияПриИзменении(Элемент)
	
	ОтборОрганизации = ЗначениеЗаполнено(Элемент.Значение);
	ЗаголовокФормы();
	
КонецПроцедуры

// Процедура - обработчик изменения данных в поле выбора вида сравнения
//
Процедура ПолеВидаСравненияПодразделениеПриИзменении(Элемент)
	
	Если ТипЗнч(Подразделение) = Тип("СправочникСсылка.ПодразделенияОрганизаций") Тогда
		ЗаписываемоеЗначение = Подразделение;                                                               
	Иначе
		Если Подразделение.Количество() = 0 Тогда    
			ЗаписываемоеЗначение = ОбщегоНазначения.ПустоеЗначениеТипа("СправочникСсылка.ПодразделенияОрганизаций")
		Иначе
			ЗаписываемоеЗначение = Подразделение[0].Значение;
		КонецЕсли;
	КонецЕсли;
	
	Если Элемент.Значение = ВидСравнения.ВСписке ИЛИ Элемент.Значение = ВидСравнения.ВСпискеПоИерархии ИЛИ Элемент.Значение = ВидСравнения.НеВСписке ИЛИ Элемент.Значение = ВидСравнения.НеВСпискеПоИерархии Тогда
		
		ЭлементыФормы.ПолеНастройкиПодразделение.ОграничениеТипа = Новый ОписаниеТипов("СписокЗначений");
		Подразделение = Новый СписокЗначений;
		Если ЗначениеЗаполнено(ЗаписываемоеЗначение) Тогда
			Подразделение.Добавить(ЗаписываемоеЗначение);
		КонецЕсли;
		
	Иначе              
		
		ЭлементыФормы.ПолеНастройкиПодразделение.ОграничениеТипа = Новый ОписаниеТипов("СправочникСсылка.ПодразделенияОрганизаций");
		Подразделение = ЗаписываемоеЗначение;
		
	КонецЕсли; 
	
КонецПроцедуры

// Процедура - обработчик изменения данных в поле значения отбора
//
Процедура ПолеНастройкиПодразделениеПриИзменении(Элемент)
	ОтборПодразделения = ЗначениеЗаполнено(Элемент.Значение);
КонецПроцедуры

// Процедура - обработчик изменения данных в поле выбора вида сравнения
//
Процедура ПолеВидаСравненияРаботникПриИзменении(Элемент)
	
	Если ТипЗнч(Работник) = Тип("СправочникСсылка.СотрудникиОрганизаций") Тогда
		ЗаписываемоеЗначение = Работник;                                                               
	Иначе
		Если Работник.Количество() = 0 Тогда    
			ЗаписываемоеЗначение = ОбщегоНазначения.ПустоеЗначениеТипа("СправочникСсылка.СотрудникиОрганизаций")
		Иначе
			ЗаписываемоеЗначение = Работник[0].Значение;
		КонецЕсли;
	КонецЕсли;
	
	Если Элемент.Значение = ВидСравнения.ВСписке ИЛИ Элемент.Значение = ВидСравнения.НеВСписке Тогда
		
		ЭлементыФормы.ПолеНастройкиРаботник.ОграничениеТипа	  = Новый ОписаниеТипов("СписокЗначений");
		Работник = Новый СписокЗначений;
		Если ЗначениеЗаполнено(ЗаписываемоеЗначение) Тогда
			Работник.Добавить(ЗаписываемоеЗначение);
		КонецЕсли;
		
	Иначе              
		
		ЭлементыФормы.ПолеНастройкиРаботник.ОграничениеТипа = Новый ОписаниеТипов("СправочникСсылка.СотрудникиОрганизаций");
		Работник	 = ЗаписываемоеЗначение;
		
	КонецЕсли; 
	
КонецПроцедуры

// Процедура - обработчик изменения данных в поле значения отбора
//
Процедура ПолеНастройкиРаботникПриИзменении(Элемент)
	ОтборРаботника = ЗначениеЗаполнено(Элемент.Значение);
КонецПроцедуры


ЭлементыФормы.ПолеВидаСравненияОрганизация.СписокВыбора = УправлениеОтчетами.ПолучитьСписокВидовСравненияПоТипу(Новый ОписаниеТипов("СправочникСсылка.Организации"));
ЭлементыФормы.ПолеВидаСравненияРаботник.СписокВыбора = УправлениеОтчетами.ПолучитьСписокВидовСравненияПоТипу(Новый ОписаниеТипов("СправочникСсылка.СотрудникиОрганизаций"));
ЭлементыФормы.ПолеВидаСравненияПодразделение.СписокВыбора = УправлениеОтчетами.ПолучитьСписокВидовСравненияПоТипу(Новый ОписаниеТипов("СправочникСсылка.ПодразделенияОрганизаций"));



