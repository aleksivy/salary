﻿Процедура ПередОткрытием(Отказ, СтандартнаяОбработка)
	
	Если НЕ ИзДокумента Тогда
		НастройкаПериода.ВариантНастройки	= ВариантНастройкиПериода.Период;
		НастройкаПериода.УстановитьПериод(НачалоМесяца(РабочаяДата), КонецМесяца(РабочаяДата));
		НачалоПериода	= НастройкаПериода.ПолучитьДатуНачала();
		Период = НастройкаПериода.ПолучитьДатуНачала();
		КонецПериода	= НастройкаПериода.ПолучитьДатуОкончания();
		ТиповыеОтчеты.ОбновитьПараметрыПериодаПоФорме(КомпоновщикНастроек, ЭтаФорма);
	КонецЕсли;	
		
	Если Не ЭтоОтработкаРасшифровки 
	   И Не СохранениеНастроек.ЗаполнитьНастройкиПриОткрытииОтчета(ОтчетОбъект) Тогда
		ИнициализацияОтчета();
	КонецЕсли;

	ТиповыеОтчеты.НазначитьФормеУникальныйКлючИдентификации(ЭтаФорма);
	ТиповыеОтчеты.ОбновитьФормуТиповогоОтчетаПоКомпоновщику(ОтчетОбъект, ЭтаФорма);
	ТиповыеОтчеты.УправлениеОтображениемЭлементовФормыТиповогоОтчета(ОтчетОбъект, ЭтаФорма);
	
	ЗначениеПараметраНачалоПериода = КомпоновщикНастроек.Настройки.ПараметрыДанных.НайтиЗначениеПараметра(Новый ПараметрКомпоновкиДанных("НачалоПериода"));
	ЗначениеПараметраКонецПериода  = КомпоновщикНастроек.Настройки.ПараметрыДанных.НайтиЗначениеПараметра(Новый ПараметрКомпоновкиДанных("КонецПериода"));
	
	Если ЗначениеПараметраНачалоПериода.Значение = '00010101' ИЛИ ЗначениеПараметраКонецПериода.Значение = '00010101' тогда
		
		РД = ОбщегоНазначения.ПолучитьРабочуюДату();
		
		ЗначениеПараметраНачалоПериода.Значение = НачалоМесяца(РД);
		ЗначениеПараметраКонецПериода.Значение  = КонецМесяца(РД);
		
	КонецЕсли;
	
	НачалоПериода = ЗначениеПараметраНачалоПериода.Значение;
	КонецПериода  = ЗначениеПараметраКонецПериода.Значение;	
		
	СтрокаНачалоПериода = РаботаСДиалогами.ДатаКакМесяцПредставление(НачалоПериода);
	СтрокаКонецПериода  = РаботаСДиалогами.ДатаКакМесяцПредставление(КонецПериода);

	ИнициализацияОтчета();
КонецПроцедуры

Процедура ДействияФормыНастройки(Кнопка)
	
	Если ТиповыеОтчеты.РедактироватьНастройкиТиповогоОтчета(ОтчетОбъект, ЭтаФорма) Тогда
		ОбновитьОтчет();
	КонецЕсли;
	
КонецПроцедуры

Процедура ДействияФормыСформировать(Кнопка)
		
	ОбновитьОтчет();
	
КонецПроцедуры

Процедура ДействияФормыЗаголовок(Кнопка)
	
	Кнопка.Пометка = Не Кнопка.Пометка;
	ТиповыеОтчеты.УправлениеОтображениемЭлементовФормыТиповогоОтчета(ОтчетОбъект, ЭтаФорма);
	ТиповыеОтчеты.УправлениеОтображениемЗаголовкаТиповогоОтчета(ОтчетОбъект, ЭтаФорма.ЭлементыФормы.Результат);
	
КонецПроцедуры

Процедура ДействияФормыОткрытьВНовомОкне(Кнопка)
	
	ТиповыеОтчеты.ОткрытьВНовомОкнеТиповойОтчет(ОтчетОбъект, ЭтаФорма);
	
КонецПроцедуры

Процедура ДействияФормыВосстановитьЗначения(Кнопка)
	
	СохранениеНастроек.ВыбратьНастройкуФормы(СохраненнаяНастройка, ЭтаФорма, "ОтчетОбъект." + ОтчетОбъект.Метаданные().Имя, Ложь);
	ТиповыеОтчеты.ОбновитьФормуТиповогоОтчетаПоКомпоновщику(ОтчетОбъект, ЭтаФорма);
	ТиповыеОтчеты.ОбновитьЗаголовокТиповогоОтчета(ОтчетОбъект, ЭтаФорма);
	
КонецПроцедуры

Процедура ДействияФормыСохранитьЗначения(Кнопка)
	
	СохранениеНастроек.ВыбратьНастройкуФормы(СохраненнаяНастройка, ЭтаФорма, "ОтчетОбъект." + ОтчетОбъект.Метаданные().Имя, Истина);
	ТиповыеОтчеты.ОбновитьЗаголовокТиповогоОтчета(ОтчетОбъект, ЭтаФорма);
	
КонецПроцедуры

Процедура ДействияФормыОтбор(Кнопка)
	
	Кнопка.Пометка = Не Кнопка.Пометка;
	ПоказыватьБыстрыйОтбор = Кнопка.Пометка;
	ТиповыеОтчеты.УправлениеОтображениемЭлементовФормыТиповогоОтчета(ОтчетОбъект, ЭтаФорма);
	ТиповыеОтчеты.ОбработкаИзмененияТиповогоОтчетаНаФормеОтчета(ОтчетОбъект, ЭтаФорма);
	
КонецПроцедуры

Процедура ОбновлениеОтображения()
	
	ТиповыеОтчеты.ОбновитьЗаголовокТиповогоОтчета(ОтчетОбъект, ЭтаФорма);
	
КонецПроцедуры

Процедура КнопкаНастройкаПериодаНажатие(Элемент)
	
	ТиповыеОтчеты.НастроитьПериод(НастройкаПериода, НачалоПериода, КонецПериода);
	ТиповыеОтчеты.ОбновитьПараметрыПериодаПоФорме(КомпоновщикНастроек, ЭтаФорма);
	ТиповыеОтчеты.ОбработкаИзмененияТиповогоОтчетаНаФормеОтчета(ОтчетОбъект, ЭтаФорма);
	
КонецПроцедуры

Процедура ПолеВводаПериодПриИзменении(Элемент)
	
	ТиповыеОтчеты.ОбновитьПараметрыПериодаПоФорме(КомпоновщикНастроек, ЭтаФорма);
	ТиповыеОтчеты.ОбработкаИзмененияТиповогоОтчетаНаФормеОтчета(ОтчетОбъект, ЭтаФорма);
	
КонецПроцедуры

Процедура РезультатОбработкаРасшифровки(Элемент, Расшифровка, СтандартнаяОбработка)
	
	ТиповыеОтчеты.ОбработкаРасшифровкиТиповогоОтчета(Расшифровка, СтандартнаяОбработка, ОтчетОбъект, ЭтаФорма);
	
КонецПроцедуры

Процедура ДействияФормыПечать(Кнопка)
	
	ТиповыеОтчеты.ПечатьТиповогоОтчета(ЭлементыФормы.Результат);
	
КонецПроцедуры

Процедура ОбновитьОтчет() Экспорт
	
	СформироватьОтчет(ЭтаФорма.ЭлементыФормы.Результат, ЭтаФорма.ДанныеРасшифровки);
	
КонецПроцедуры

Процедура ТабличноеПолеОтборПравоеЗначениеДляКраткогоОтображенияЭлементаНачалоВыбора(Элемент, СтандартнаяОбработка)
	СтрокаОтбора = ЭлементыФормы.ТабличноеПолеОтбор.ТекущаяСтрока;
	
	Если ТипЗнч(СтрокаОтбора.ПравоеЗначение) = Тип("СправочникСсылка.ПодразделенияОрганизаций") тогда
		 
		 ПолеОрганизации               = Новый ПолеКомпоновкиДанных("Организация");
		 
		 Для каждого ЭлементОтбора из КомпоновщикНастроек.Настройки.Отбор.Элементы Цикл
			 
			Если ЭлементОтбора.ЛевоеЗначение = ПолеОрганизации 
				 И ТипЗнч(ЭлементОтбора.ПравоеЗначение) = Тип("СправочникСсылка.Организации") тогда
				Элемент.ВыборПоВладельцу = ЭлементОтбора.ПравоеЗначение;
				Прервать;
			КонецЕсли;
			
		КонецЦикла;	
	КонецЕсли;
КонецПроцедуры

Процедура ТабличноеПолеОтборПриОкончанииРедактирования(Элемент, НоваяСтрока, ОтменаРедактирования)
	
	ТиповыеОтчеты.ОбработкаИзмененияТиповогоОтчетаНаФормеОтчета(ОтчетОбъект, ЭтаФорма);
	
КонецПроцедуры

//ИЗМЕНЕНИЕ ПЕРИОДА
// Процедура - обработчик нажатия кнопки выбора даты начала периода
//
Процедура НачалоПериодаПриИзменении(Элемент)
	
	РаботаСДиалогами.ДатаКакМесяцПодобратьДатуПоТексту(Элемент.Значение, НачалоПериода);
	
	Элемент.Значение           = РаботаСДиалогами.ДатаКакМесяцПредставление(НачалоПериода);
	
	ЗначениеПараметра          = КомпоновщикНастроек.Настройки.ПараметрыДанных.НайтиЗначениеПараметра(Новый ПараметрКомпоновкиДанных("НачалоПериода"));;
	ЗначениеПараметра.Значение = НачалоМесяца(НачалоПериода);
	ТиповыеОтчеты.ОбработкаИзмененияТиповогоОтчетаНаФормеОтчета(ОтчетОбъект, ЭтаФорма);

	
КонецПроцедуры //НачалоПериодаПриИзменении()

// Процедура - обработчик нажатия кнопки выбора даты окончания периода
//
Процедура КонецПериодаПриИзменении(Элемент)
	
	РаботаСДиалогами.ДатаКакМесяцПодобратьДатуПоТексту(Элемент.Значение, КонецПериода);
	
	Элемент.Значение           = РаботаСДиалогами.ДатаКакМесяцПредставление(КонецПериода);
	
	ЗначениеПараметра          = КомпоновщикНастроек.Настройки.ПараметрыДанных.НайтиЗначениеПараметра(Новый ПараметрКомпоновкиДанных("КонецПериода"));
	ЗначениеПараметра.Значение = КонецМесяца(КонецПериода);
	ТиповыеОтчеты.ОбработкаИзмененияТиповогоОтчетаНаФормеОтчета(ОтчетОбъект, ЭтаФорма);

КонецПроцедуры //КонецПериодаПриИзменении()

// Процедура - обработчик события регулирование поле ввода "НачалоПериода"
//
Процедура НачалоПериодаРегулирование(Элемент, Направление, СтандартнаяОбработка)
	
	НачалоПериода    = ДобавитьМесяц(НачалоПериода, Направление);
	Элемент.Значение = РаботаСДиалогами.ДатаКакМесяцПредставление(НачалоПериода);
	КомпоновщикНастроек.Настройки.ПараметрыДанных.Элементы.Найти("НачалоПериода").Значение = НачалоМесяца(НачалоПериода);
	ТиповыеОтчеты.ОбработкаИзмененияТиповогоОтчетаНаФормеОтчета(ОтчетОбъект, ЭтаФорма);
	
КонецПроцедуры //НачалоПериодаРегулирование()

// Процедура - обработчик события авто подбора текста поле ввода "НачалоПериода"
//
Процедура НачалоПериодаАвтоПодборТекста(Элемент, Текст, ТекстАвтоПодбора, СтандартнаяОбработка)
	
	РаботаСДиалогами.ДатаКакМесяцАвтоПодборТекста(Текст, ТекстАвтоПодбора, СтандартнаяОбработка);
	
КонецПроцедуры //НачалоПериодаАвтоПодборТекста()

// Процедура - обработчик события начало выбора из списка кнопки "НачалоПериода"
//
Процедура НачалоПериодаНачалоВыбораИзСписка(Элемент, СтандартнаяОбработка)
	
	РаботаСДиалогами.НачалоВыбораИзСпискаПредставленияПериодаРегистрации(Элемент, СтандартнаяОбработка, НачалоПериода, ЭтаФорма);
	КомпоновщикНастроек.Настройки.ПараметрыДанных.Элементы.Найти("НачалоПериода").Значение = НачалоМесяца(НачалоПериода);
	ТиповыеОтчеты.ОбработкаИзмененияТиповогоОтчетаНаФормеОтчета(ОтчетОбъект, ЭтаФорма);
	
КонецПроцедуры //НачалоПериодаНачалоВыбораИзСписка()

// Процедура - обработчик события очистка кнопки "НачалоПериода"
//
Процедура НачалоПериодаОчистка(Элемент, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
КонецПроцедуры //НачалоПериодаОчистка()

// Процедура - обработчик события начало выбора из списка кнопки "КонецПериода"
//
Процедура КонецПериодаНачалоВыбораИзСписка(Элемент, СтандартнаяОбработка)
	
	РаботаСДиалогами.НачалоВыбораИзСпискаПредставленияПериодаРегистрации(Элемент, СтандартнаяОбработка, КонецПериода, ЭтаФорма);
	КомпоновщикНастроек.Настройки.ПараметрыДанных.Элементы.Найти("КонецПериода").Значение = КонецМесяца(КонецПериода);
	ТиповыеОтчеты.ОбработкаИзмененияТиповогоОтчетаНаФормеОтчета(ОтчетОбъект, ЭтаФорма);
	
КонецПроцедуры //КонецПериодаНачалоВыбораИзСписка()

// Процедура - обработчик события очистка кнопки "КонецПериода"
//
Процедура КонецПериодаОчистка(Элемент, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
КонецПроцедуры //КонецПериодаОчистка()

// Процедура - обработчик события регулирование поле ввода "КонецПериода"
//
Процедура КонецПериодаРегулирование(Элемент, Направление, СтандартнаяОбработка)
	
	КонецПериода     = ДобавитьМесяц(КонецПериода, Направление);
	Элемент.Значение = РаботаСДиалогами.ДатаКакМесяцПредставление(КонецПериода);
	КомпоновщикНастроек.Настройки.ПараметрыДанных.Элементы.Найти("КонецПериода").Значение = КонецМесяца(КонецПериода);
	ТиповыеОтчеты.ОбработкаИзмененияТиповогоОтчетаНаФормеОтчета(ОтчетОбъект, ЭтаФорма);
	
КонецПроцедуры //КонецПериодаРегулирование()

// Процедура - обработчик события авто подбора текста поле ввода "КонецПериода"
//
Процедура КонецПериодаАвтоПодборТекста(Элемент, Текст, ТекстАвтоПодбора, СтандартнаяОбработка)
	
	РаботаСДиалогами.ДатаКакМесяцАвтоПодборТекста(Текст, ТекстАвтоПодбора, СтандартнаяОбработка);
	
КонецПроцедуры //КонецПериодаАвтоПодборТекста()


