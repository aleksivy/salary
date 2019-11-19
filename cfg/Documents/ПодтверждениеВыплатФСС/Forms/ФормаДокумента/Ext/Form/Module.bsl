﻿////////////////////////////////////////////////////////////////////////////////
// ПЕРЕМЕННЫЕ МОДУЛЯ
// Хранит дерево макетов печатных форм
Перем мДеревоМакетов;

// Хранит элемент управления подменю печати
Перем мПодменюПечати;

// Хранит элемент управления кнопку печать по умолчанию
Перем мПечатьПоУмолчанию;

Перем мТекущаяДатаДокумента; // Хранит текущую дату документа - для проверки перехода документа в другой период установки номера

// Хранит дерево кнопок подменю заполнение ТЧ
Перем мКнопкиЗаполненияТЧ;

////////////////////////////////////////////////////////////////////////////////
// ОБЩИЕ ПРОЦЕДУРЫ И ФУНКЦИИ

// Процедура устанавливает подменю "Заполнить" в командных панелях ТЧ документа при необходимости
//
Процедура УстановитьКнопкиПодменюЗаполненияТЧ();
	
	мКнопкиЗаполненияТЧ = УниверсальныеМеханизмы.ПолучитьДеревоКнопокЗаполненияТабличныхЧастей(Ссылка,Новый Действие("НажатиеНаДополнительнуюКнопкуЗаполненияТЧ"));
	
	СоответствиеТЧ = Новый Соответствие;
	СоответствиеТЧ.Вставить(ЭлементыФормы.Выплаты,ЭлементыФормы.КоманднаяПанель);
	
	УниверсальныеМеханизмы.СформироватьПодменюЗаполненияТЧПоДеревуКнопок(мКнопкиЗаполненияТЧ,СоответствиеТЧ);
	
КонецПроцедуры

// Процедура устанавливает подменю "Печать" и кнопку "Печать по умолчанию" при необходимости
//
Процедура УстановитьКнопкиПечати()
	
	ФормированиеПечатныхФорм.СоздатьКнопкиПечати(ЭтотОбъект, ЭтаФорма);	
	
КонецПроцедуры
////////////////////////////////////////////////////////////////////////////////
// ПРОЦЕДУРЫ - ДЕЙСТВИЯ КОМАНДНЫХ ПАНЕЛЕЙ ФОРМЫ

// Процедура - обработчик нажатия на любую из дополнительных кнопок по заполнению ТЧ
//
Процедура НажатиеНаДополнительнуюКнопкуЗаполненияТЧ(Кнопка)
	
	УниверсальныеМеханизмы.ОбработатьНажатиеНаДополнительнуюКнопкуЗаполненияТЧ(мКнопкиЗаполненияТЧ.Строки.Найти(Кнопка.Имя,"Имя",Истина),ЭтотОбъект);
	
КонецПроцедуры

// Процедура - обработчик нажатия на кнопку "Печать по умолчанию"
//
Процедура ОсновныеДействияФормыПечатьПоУмолчанию(Кнопка)
	
	УниверсальныеМеханизмы.ПечатьПоДополнительнойКнопке(мДеревоМакетов, ЭтотОбъект, ЭтаФорма, Кнопка.Текст);
	
КонецПроцедуры

// Процедура - обработчик нажатия на кнопку "Печать"
//
Процедура ОсновныеДействияФормыПечать(Кнопка)
	
	УниверсальныеМеханизмы.ПечатьПоДополнительнойКнопке(мДеревоМакетов, ЭтотОбъект, ЭтаФорма, Кнопка.Текст);
	
КонецПроцедуры

// Процедура - обработчик нажатия на кнопку "Установить печать по умолчанию"
//
Процедура ОсновныеДействияФормыУстановитьПечатьПоУмолчанию(Кнопка)
	
	Если УниверсальныеМеханизмы.НазначитьКнопкуПечатиПоУмолчанию(мДеревоМакетов, Метаданные().Имя) Тогда
		
		УстановитьКнопкиПечати();
		
	КонецЕсли; 
	
	
КонецПроцедуры

// Процедура разрешения/запрещения редактирования номера документа
Процедура ДействияФормыРедактироватьНомер(Кнопка)
	
	МеханизмНумерацииОбъектов.ИзменениеВозможностиРедактированияНомера(ЭтотОбъект.Метаданные(), ЭтаФорма, ЭлементыФормы.ДействияФормы.Кнопки.Подменю1, ЭлементыФормы.Номер);
			
КонецПроцедуры

Процедура ОсновныеДействияФормыВыгрузитьВЗвит1С(Кнопка)
	
	//Запишем документ
	Если Не РаботаСДиалогами.ПроверитьМодифицированность(ЭтотОбъект,НСтр("ru='Для выгрзки';uk='Для вивантаження'")) Тогда
		Возврат;
	КонецЕсли;
	
	
	ВыгрузитьВоФРЕДО();
	
КонецПроцедуры


/////////////////////////////////////////////////////////////////////////////////////////////////////
// ПРОЦЕДУРЫ - ОБРАБОТЧИКИ СОБЫТИЙ ФОРМЫ

Процедура ПередОткрытием(Отказ, СтандартнаяОбработка)
	
	// Установка кнопок печати
	УстановитьКнопкиПечати();
	
	// Установка кнопок заполнение ТЧ
	УстановитьКнопкиПодменюЗаполненияТЧ();

КонецПроцедуры

Процедура ПриОткрытии()
	
	Если ЭтоНовый() Тогда // проверить объект на то, что он еще не внесен в ИБ
		
		// Заполнить реквизиты значениями по умолчанию.
		ЗаполнениеДокументов.ЗаполнитьШапкуДокумента(ЭтотОбъект);
	Иначе 
		// Установить доступность формы с учетом даты запрета редактирования	
		РаботаСДиалогами.УстановитьДоступностьФормыДляРедактирования(ЭтотОбъект, ЭтаФорма);
	КонецЕсли;
	
	МеханизмНумерацииОбъектов.УстановитьДоступностьПоляВводаНомера(Метаданные(), ЭтаФорма, ЭлементыФормы.ДействияФормы.Кнопки.Подменю1,ЭлементыФормы.Номер);

	// Заполним реквизит формы МесяцСтрока.
	МесяцСтрока = РаботаСДиалогами.ДатаКакМесяцПредставление(ПериодРегистрации);
	
КонецПроцедуры

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
	
	РаботаСДиалогами.ПроверитьНомерДокумента(ЭтотОбъект, мТекущаяДатаДокумента);
	МеханизмНумерацииОбъектов.ОбновитьПодсказкуКодНомерОбъекта(ЭтотОбъект.Метаданные(), ЭлементыФормы.ДействияФормы.Кнопки.Подменю, ЭлементыФормы.Номер);
	
	мТекущаяДатаДокумента = Дата;

КонецПроцедуры // ДатаПриИзменении

// Процедура - обработчик события "ПриИзменении" поля ввода организации.
//
Процедура ОрганизацияПриИзменении(Элемент)
	
    Если Не ПустаяСтрока(Номер) Тогда
		МеханизмНумерацииОбъектов.СброситьУстановленныйКодНомерОбъекта(ЭтотОбъект, "Номер", ЭлементыФормы.ДействияФормы.Кнопки.Подменю, ЭлементыФормы.Номер);
	КонецЕсли;
	
КонецПроцедуры // ОрганизацияПриИзменении()

// Процедура - обработчик события "ПриИзменении" поля ввода периода регистрации.
//
Процедура ПериодРегистрацииПриИзменении(Элемент)
	
	РаботаСДиалогами.ДатаКакМесяцПодобратьДатуПоТексту(Элемент.Значение, ПериодРегистрации);
	Элемент.Значение = РаботаСДиалогами.ДатаКакМесяцПредставление(ПериодРегистрации);
		
КонецПроцедуры

// Процедура - обработчик события "Регулирование" поля ввода периода регистрации.
//
Процедура ПериодРегистрацииРегулирование(Элемент, Направление, СтандартнаяОбработка)
	
	ПериодРегистрации = ДобавитьМесяц(ПериодРегистрации, Направление);
	Элемент.Значение = РаботаСДиалогами.ДатаКакМесяцПредставление(ПериодРегистрации);
	
КонецПроцедуры

// Процедура - обработчик события "Очистка" поля ввода периода регистрации.
//
Процедура ПериодРегистрацииОчистка(Элемент, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
КонецПроцедуры

// Процедура - обработчик события "НачалоВыбораИзСписка" поля ввода периода регистрации.
//
Процедура ПериодРегистрацииНачалоВыбораИзСписка(Элемент, СтандартнаяОбработка)
	
	РаботаСДиалогами.НачалоВыбораИзСпискаПредставленияПериодаРегистрации(Элемент, СтандартнаяОбработка, ПериодРегистрации, ЭтаФорма);
	
КонецПроцедуры

// Процедура - обработчик события "АвтоПодборТекста" поля ввода периода регистрации.
//
Процедура ПериодРегистрацииАвтоПодборТекста(Элемент, Текст, ТекстАвтоПодбора, СтандартнаяОбработка)
	
	РаботаСДиалогами.ДатаКакМесяцАвтоПодборТекста(Текст, ТекстАвтоПодбора, СтандартнаяОбработка);
	
КонецПроцедуры

// Процедура - обработчик события "ОкончаниеВводаТекста" поля ввода периода регистрации.
//
Процедура ПериодРегистрацииОкончаниеВводаТекста(Элемент, Текст, Значение, СтандартнаяОбработка)
	
	РаботаСДиалогами.ДатаКакМесяцОкончаниеВводаТекста(Текст, Значение, СтандартнаяОбработка);
	
КонецПроцедуры

Процедура ЗаявлениеРасчетВФССПриИзменении(Элемент)
	
	Если Не Элемент = Документы.ЗаявлениеРасчетВФСС.ПустаяСсылка() Тогда 
		АвтозаполнениеДокумента();
	КонецЕсли;	

КонецПроцедуры

Процедура ЗаявлениеРасчетВФССНачалоВыбора(Элемент, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	ФормаВыбора = Документы.ЗаявлениеРасчетВФСС.ПолучитьФормуВыбора(,Элемент,);
	
	
	ФормаВыбора.Отбор.Организация.ВидСравнения  = ВидСравнения.Равно;
	ФормаВыбора.Отбор.Организация.Значение      = Организация;
	ФормаВыбора.Отбор.Организация.Использование = Истина;
	
	ФормаВыбора.Открыть();
	
КонецПроцедуры



