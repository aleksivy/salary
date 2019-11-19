﻿////////////////////////////////////////////////////////////////////////////////
// ПЕРЕМЕННЫЕ МОДУЛЯ

// Хранит текущую дату документа - для проверки перехода документа в другой период установки номера
Перем мТекущаяДатаДокумента;
////////////////////////////////////////////////////////////////////////////////
// ПРОЦЕДУРЫ И ФУНКЦИИ ОБЩЕГО НАЗНАЧЕНИЯ

// Процедура выполняет действия, необходимые при выборе счета организации
//
// Параметры:
//  Нет.
//
Процедура ПриИзмененииСчетаОрганизации()
	
	Если СчетОрганизации.Пустая() Тогда
		Возврат;
	КонецЕсли;
	
	Если Организация.Пустая() Тогда
		Организация=СчетОрганизации.Владелец;
	КонецЕсли;
	
	Если НЕ СчетКонтрагента.Пустая() И НЕ СчетОрганизации.ВалютаДенежныхСредств=СчетКонтрагента.ВалютаДенежныхСредств Тогда
		Сообщить(НСтр("ru='Валюта счета контрагента не соответствует валюте счета организации!';uk='Валюта рахунку контрагента не відповідає валюті рахунку організації!'"));
		СчетКонтрагента="";
	КонецЕсли;	
	
	 УстановитьНомерПоручения();

	
КонецПроцедуры // ПриИзмененииСчетаОрганизации()

// Процедура выполняет действия, необходимые при выборе счета контрагента
//
// Параметры:
//  Нет.
//
Процедура ПриИзмененииСчетаКонтрагента()

	Если СчетКонтрагента.Пустая() Тогда
		Возврат;
	КонецЕсли;
		
	Если Контрагент.Пустая() Тогда
		Контрагент=СчетКонтрагента.Владелец;
	КонецЕсли;
	
	Если НЕ СчетКонтрагента.Пустая() И НЕ СчетОрганизации.ВалютаДенежныхСредств=СчетКонтрагента.ВалютаДенежныхСредств Тогда
		Сообщить(НСтр("ru='Валюта счета контрагента не соответствует валюте счета организации!';uk='Валюта рахунку контрагента не відповідає валюті рахунку організації!'"));
		СчетКонтрагента="";
		Возврат;
	КонецЕсли;	
	

	
КонецПроцедуры // ПриИзмененииСчетаКонтрагента()

////////////////////////////////////////////////////////////////////////////////
// ПРОЦЕДУРЫ - ОБРАБОТЧИКИ СОБЫТИЙ ФОРМЫ

// Процедура - обработчик события "ПриОткрытии" формы
//
Процедура ПриОткрытии()
	Если ЭтоНовый() Тогда // проверить объект на то, что он еще не внесен в ИБ
		
		// Заполнить реквизиты значениями по умолчанию.
		Если НЕ ЗначениеЗаполнено(ВидОперации) Тогда
			ВидОперации = Перечисления.ВидыОперацийППВходящее.ПоступлениеСредствОтФСС;
		КонецЕсли;
		
		ЗаполнениеДокументов.ЗаполнитьШапкуДокумента(ЭтотОбъект);
		
		ЗаполнитьБанковскийСчетОрганизации();
		
		УстановитьНомерПоручения()
	Иначе 
		// Установить доступность формы с учетом даты запрета редактирования	
		РаботаСДиалогами.УстановитьДоступностьФормыДляРедактирования(ЭтотОбъект, ЭтаФорма);
	КонецЕсли;

	// Заполняем подменю, вызываемое нажатием кнопки "Операция" командной панели 
	// формы, значениями перечисления "Вид операции" данного вида документа.
	// В качестве обработки выбора вида операции назначается процедура 
	// ДействияФормыДействиеУстановитьОперацию модуля формы.
	Массив = Новый Массив;
	Массив.Добавить(ВидОперации.Метаданные().ЗначенияПеречисления.ПоступлениеСредствОтФСС);
	
	РаботаСДиалогами.УстановитьПодменюВыбораВидаОперации(ЭлементыФормы.ДействияФормы.Кнопки.ПодменюВидаОперации,
										Массив, 
										Новый Действие("ДействияФормыДействиеУстановитьОперацию"));
										
	// Вывести в заголовке формы вид операции.
	РаботаСДиалогами.УстановитьЗаголовокФормыДокумента(Строка(ВидОперации), ЭтотОбъект, ЭтаФорма);
	
	//Доступность поля ввода номера
	МеханизмНумерацииОбъектов.УстановитьДоступностьПоляВводаНомера(Метаданные(), ЭтаФорма, ЭлементыФормы.ДействияФормы.Кнопки.Подменю1,ЭлементыФормы.Номер);
	МеханизмНумерацииОбъектов.ДобавитьВМенюДействияКнопкуРедактированияНомера(ЭлементыФормы.ДействияФормы.Кнопки.Подменю1);

	// Запомнить текущие значения реквизитов формы.
	мТекущаяДатаДокумента        = Дата;

	// Установить активный реквизит.
	РаботаСДиалогами.АктивизироватьРеквизитВФорме(ЭтотОбъект, ЭтаФорма);

КонецПроцедуры // ПриОткрытии()

Процедура ПередЗаписью(Отказ, РежимЗаписи, РежимПроведения)
	
	Если Ответственный.Пустая() Тогда
		Ответственный = глЗначениеПеременной("глТекущийПользователь");
	КонецЕсли;
	
КонецПроцедуры

// Процедура - обработчик события "ПослеЗаписи" формы.
//
Процедура ПослеЗаписи()

	// Вывести в заголовке формы вид операции и статус документа (новый, не проведен, проведен).
	РаботаСДиалогами.УстановитьЗаголовокФормыДокумента(Строка(ВидОперации), ЭтотОбъект, ЭтаФорма);

КонецПроцедуры // ПослеЗаписи()
////////////////////////////////////////////////////////////////////////////////
// ПРОЦЕДУРЫ - ОБРАБОТЧИКИ СОБЫТИЙ РЕКВИЗИТОВ ШАПКИ

// Процедура - обработчик события "ПриИзменении" поля ввода даты документа.
//
Процедура ДатаПриИзменении(Элемент)

	РаботаСДиалогами.ПроверитьНомерДокумента(ЭтотОбъект, мТекущаяДатаДокумента);

	мТекущаяДатаДокумента = Дата; // запомним текущую дату документа для контроля номера документа

КонецПроцедуры // ДатаПриИзменении()

// Обработчик события "ПриИзменении" реквизита "Организация"
//
Процедура ОрганизацияПриИзменении(Элемент)
	Если ЗначениеЗаполнено(Организация) Тогда
		СчетОрганизации=Организация.БанковскийСчетДляРасчетовСФСС;
	Иначе
		СчетОрганизации=Неопределено;
	КонецЕсли;
	
	ПриИзмененииСчетаОрганизации();
	
КонецПроцедуры // ОрганизацияПриИзменении()

// Процедура - обработчик события "ПриИзменении" поля ввода "Контрагент".
//
Процедура КонтрагентПриИзменении(Элемент)

	// проставим основной  банковский счет контрагента
    
	Если ЗначениеЗаполнено(Контрагент) Тогда
		СчетКонтрагента=Контрагент.ОсновнойБанковскийСчет;
	Иначе
		СчетКонтрагента=Неопределено;
	КонецЕсли;

	ПриИзмененииСчетаКонтрагента();

КонецПроцедуры

// Обработчик события "ПриИзменении" реквизита "СчетОрганизации"
//
Процедура СчетОрганизацииПриИзменении(Элемент)

	ПриИзмененииСчетаОрганизации();
	
КонецПроцедуры // СчетОрганизацииПриИзменении()

// Обработчик события "ПриИзменении" реквизита "СчетКонтрагента"
//
Процедура СчетКонтрагентаПриИзменении(Элемент)

	ПриИзмененииСчетаКонтрагента();
	
КонецПроцедуры // СчетКонтрагентаПриИзменении()
// Обработчик события "НачалоВыбора" реквизита "СчетОрганизации"
//
Процедура СчетОрганизацииНачалоВыбора(Элемент, СтандартнаяОбработка)
	
	Если НЕ Организация.Пустая() Тогда
		Элемент.ВыборПоВладельцу = Организация;	
	КонецЕсли;	

КонецПроцедуры // СчетОрганизацииНачалоВыбора()

// Обработчик события "НачалоВыбора" реквизита "СчетКонтрагента"
//
Процедура СчетКонтрагентаНачалоВыбора(Элемент, СтандартнаяОбработка)

	Если НЕ Контрагент.Пустая() Тогда
		Элемент.ВыборПоВладельцу = Контрагент;	
	КонецЕсли;

КонецПроцедуры // СчетКонтрагентаНачалоВыбора()

Процедура ЗаявкиЗаявлениеРасчетПриИзменении(Элемент)
	// необходимо записать, иначе будем расчитывать сумму старого документа
	Записать();
	РассчитатьСумму();
КонецПроцедуры

Процедура ЗаявкиЗаявлениеРасчетНачалоВыбора(Элемент, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	ФормаВыбора = Документы.ЗаявлениеРасчетВФСС.ПолучитьФормуВыбора(,Элемент,);
		
			
	ФормаВыбора.Отбор.Организация.ВидСравнения  = ВидСравнения.Равно;
	ФормаВыбора.Отбор.Организация.Значение      = Организация;
	ФормаВыбора.Отбор.Организация.Использование = Истина;
	
	ФормаВыбора.Отбор.Проведен.ВидСравнения  	= ВидСравнения.Равно;
	ФормаВыбора.Отбор.Проведен.Значение			= Истина;
	ФормаВыбора.Отбор.Проведен.Использование	= Истина;
	
	ФормаВыбора.Открыть();
	
	ФормаЗаявки = Документы.ЗаявлениеРасчетВФСС.ПолучитьФормуВыбора(,Элемент);
    	
КонецПроцедуры

// Процедура вызывается при выборе пункта подменю "ПодменюВидаОперации" командной панели
// формы. Процедура устанавливает значение реквизита ВидОперации.
//
Процедура ДействияФормыДействиеУстановитьОперацию(Кнопка)

	Если Кнопка <> Неопределено Тогда // найти новое значение вида операции

		Если ВидОперации = Перечисления.ВидыОперацийППВходящее[Кнопка.Имя] Тогда
			Возврат;
		КонецЕсли; 
		
		ВидОперации = Перечисления.ВидыОперацийППИсходящее[Кнопка.Имя];
		
		Список = Истина;
		             		
	КонецЕсли;

	// Отобразить в заголовке формы вид операции.
	РаботаСДиалогами.УстановитьЗаголовокФормыДокумента(Строка(ВидОперации), ЭтотОбъект, ЭтаФорма);
КонецПроцедуры // ДействияФормыДействиеУстановитьОперацию()

// Процедура разрешения/запрещения редактирования номера документа
Процедура ДействияФормыРедактироватьНомер(Кнопка)
	
	МеханизмНумерацииОбъектов.ИзменениеВозможностиРедактированияНомера(ЭтотОбъект.Метаданные(), ЭтаФорма, ЭлементыФормы.ДействияФормы.Кнопки.Подменю1, ЭлементыФормы.Номер);
			
КонецПроцедуры


Процедура ДействияФормыДвиженияДокументаПоРегистрам(Кнопка)
		РаботаСДиалогами.НапечататьДвиженияДокумента(Ссылка);
КонецПроцедуры

// Процедура вызова структуры подчиненности документа
Процедура ДействияФормыСтруктураПодчиненностиДокумента(Кнопка)
	РаботаСДиалогами.ПоказатьСтруктуруПодчиненностиДокумента(Ссылка);
КонецПроцедуры

Процедура ЗаполнитьБанковскийСчетОрганизации()
	 СчетОрганизации = Организация.БанковскийСчетДляРасчетовСФСС;
КонецПроцедуры;

