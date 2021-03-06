Перем мОрганизация;



////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ ФОРМЫ

Процедура ПриОткрытии()	
	
	Если Организация.Пустая() Тогда
		Организация   = УправлениеПользователями.ПолучитьЗначениеПоУмолчанию(глЗначениеПеременной("глТекущийПользователь"), "ОсновнаяОрганизация");
	КонецЕсли;
	мОрганизация = Организация;
	ДатаПлатежки = ТекущаяДата();
	УстановитьОтборы();	
	
КонецПроцедуры


////////////////////////////////////////////////////////////////////////////////
// ПРОЦЕДУРЫ - ДЕЙСТВИЯ КОМАНДНЫХ ПАНЕЛЕЙ ФОРМЫ

Процедура КоманднаяПанельПлатежкиОбновить(Кнопка)

	Платежки.Очистить();
	Налоги.Очистить(); 
	Автозаполнение();
	
КонецПроцедуры

Процедура КоманднаяПанельПлатежкиУстановитьФлаги(Кнопка)
	
	Для Каждого СтрокаТаблицы Из Платежки Цикл
		СтрокаТаблицы.Отметка = Истина
	КонецЦикла;
	
КонецПроцедуры

Процедура КоманднаяПанельПлатежкиСнятьфлаги(Кнопка)
	
	Для Каждого СтрокаТаблицы Из Платежки Цикл
		СтрокаТаблицы.Отметка = Ложь
	КонецЦикла;
	
КонецПроцедуры

Процедура КоманднаяПанельПлатежкиИнвертировать(Кнопка)
	
	Для Каждого СтрокаТаблицы Из Платежки Цикл		
		СтрокаТаблицы.Отметка = Не СтрокаТаблицы.Отметка;
	КонецЦикла;
	
КонецПроцедуры


Процедура ОсновныеДействияФормыСоздать(Кнопка)
	
	Если НЕ ЗначениеЗаполнено(ДатаПлатежки) Тогда
		Предупреждение(НСтр("ru='Не указана дата платежного документа!';uk='Не зазначена дата платіжного документа!'"));
		Возврат;
	КонецЕсли;	
		
	
	Валюта = Константы.ВалютаРегламентированногоУчета.Получить();
	
	Отбор = Новый Структура ("СчетУчета, Контрагент, СчетКонтрагента");
	Для Каждого СтрокаТаблицы Из Платежки Цикл
		
		Если СтрокаТаблицы.Отметка И НЕ ЗначениеЗаполнено(СтрокаТаблицы.Платежка) Тогда
			
			ДокументПлатежка = Документы.ПлатежноеПоручениеИсходящее.СоздатьДокумент();
			ДокументПлатежка.Дата		 		= ДатаПлатежки;
			ДокументПлатежка.ВидОперации		= Перечисления.ВидыОперацийППИсходящее.ПеречислениеНалога;
			ДокументПлатежка.СуммаДокумента		= СтрокаТаблицы.Сумма;
			ДокументПлатежка.Контрагент			= СтрокаТаблицы.Контрагент;
			ДокументПлатежка.СчетКонтрагента	= СтрокаТаблицы.СчетКонтрагента;
			ДокументПлатежка.ДокументОснование	= ДокументНачисления;
			ДокументПлатежка.Организация		= Организация;
			ДокументПлатежка.СтатьяДвиженияДенежныхСредств	= СтатьяДвиженияДенежныхСредств;
			ДокументПлатежка.СчетОрганизации				= Организация.ОсновнойБанковскийСчет;
			ДокументПлатежка.СчетУчетаРасчетовСКонтрагентом	= СтрокаТаблицы.СчетУчета;
			ЗаполнениеДокументов.ЗаполнитьШапкуДокумента(ДокументПлатежка);
			

			// табличная часть
			Отбор.СчетУчета = СтрокаТаблицы.СчетУчета;
	 		Отбор.Контрагент = СтрокаТаблицы.Контрагент;
			Отбор.СчетКонтрагента = СтрокаТаблицы.СчетКонтрагента;
			СтрокиНалогов = Налоги.НайтиСтроки(Отбор);
			Для Каждого СтрокаНалогов Из СтрокиНалогов Цикл
				
				СтрокаПлатежки = ДокументПлатежка.ПеречислениеНалогов.Добавить();
				СтрокаПлатежки.СтатьяДвиженияДенежныхСредств = СтатьяДвиженияДенежныхСредств;
				СтрокаПлатежки.СубконтоДт1 = СтрокаНалогов.Налог;
				СтрокаПлатежки.СубконтоДт2 = СтрокаНалогов.СтатьяНалоговойДекларации;
				СтрокаПлатежки.Сумма = СтрокаНалогов.Сумма;
				СтрокаПлатежки.Ведомость = СтрокаНалогов.Ведомость;
				
			КонецЦикла;
			ДокументПлатежка.Записать();
			СтрокаТаблицы.Платежка	= ДокументПлатежка.Ссылка;
			
		КонецЕсли;
		
	КонецЦикла;
	
КонецПроцедуры

Процедура ОсновныеДействияФормыПровести(Кнопка)
	
	Для Каждого СтрокаТаблицы Из Платежки Цикл
		Если СтрокаТаблицы.Отметка и ЗначениеЗаполнено(СтрокаТаблицы.Платежка) Тогда
			ДокументПлатежка = СтрокаТаблицы.Платежка.ПолучитьОбъект();
			Если ДокументПлатежка.ПометкаУдаления Тогда
				ДокументПлатежка.УстановитьПометкуУдаления(Ложь);
			КонецЕсли;
			Попытка
				ДокументПлатежка.Записать(РежимЗаписиДокумента.Проведение);
			Исключение
				Предупреждение(НСтр("ru='Операция не выполнена!';uk='Операція не виконана!'"));
			КонецПопытки;
			СтрокаТаблицы.Отметка = Не СтрокаТаблицы.Отметка;
		КонецЕсли;
	КонецЦикла;
	
	Оповестить("ОбновитьФорму", ,ДокументНачисления);
	
КонецПроцедуры

Процедура ОсновныеДействияФормыАвтозаполнение(Кнопка)
	
	Платежки.Очистить();
	Налоги.Очистить(); 
	Автозаполнение();
	
КонецПроцедуры


////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ РЕКВИЗИТОВ ШАПКИ

Процедура ОрганизацияПриИзменении(Элемент)
	
	Если мОрганизация <> Организация Тогда
		//ПлатежнаяВедомость = Документы.ЗарплатаКВыплатеОрганизаций.ПустаяСсылка();
		ДокументНачисления = "";
		Платежки.Очистить();
		Налоги.Очистить();
	КонецЕсли;
	мОрганизация = Организация;
	УстановитьОтборы();
	
КонецПроцедуры


////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ

Процедура КоманднаяПанельРегистрСведенийСписокЗаполнить(Кнопка)
	
	// список взносов
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("парамДата", ТекущаяДата());
	Запрос.УстановитьПараметр("парамОрганизация", Организация);
	
	ТекстЗапроса = "
	|ВЫБРАТЬ РАЗЛИЧНЫЕ
	|	Шкала.СтатьяНалоговойДекларации.Родитель КАК Родитель,
	|	Отражение.СпособОтраженияВРеглУчете.СчетКт КАК СчетУчета
	|ИЗ РегистрСведений.ШкалаСтавокНалогов.СрезПоследних(&парамДата) КАК Шкала
	|ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.ОтражениеВзносовВРеглУчете КАК Отражение
	|По		Шкала.Налог = Отражение.Налог
	|ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.ПараметрыПлатежныхДокументовПоВзносамВФонды КАК Параметры
	|По		Параметры.СтатьяНалоговойДекларации = Шкала.СтатьяНалоговойДекларации
	|	И	Параметры.Организация = &парамОрганизация
	|ГДЕ	Шкала.СтатьяНалоговойДекларации.Родитель ЕСТЬ НЕ NULL
	|	И	Отражение.СпособОтраженияВРеглУчете.СчетКт ЕСТЬ НЕ NULL
	|
	|// НДФЛ
	|ОБЪЕДИНИТЬ ВСЕ
	|ВЫБРАТЬ РАЗЛИЧНЫЕ
	|	NULL КАК Родитель,
	|	ЗНАЧЕНИЕ(ПланСчетов.Хозрасчетный.РасчетыПоНДФЛ)
	|ИЗ РегистрСведений.ШкалаСтавокНалогов.СрезПоследних(&парамДата) КАК Шкала
	|ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.ПараметрыПлатежныхДокументовПоВзносамВФонды КАК Параметры
	|По		Параметры.СтатьяНалоговойДекларации ЕСТЬ NULL
	|	И	Параметры.Организация = &парамОрганизация
	|ГДЕ   Параметры.Организация ЕСТЬ NULL
	|";
	
	Запрос.Текст = ТекстЗапроса;
	
	Выборка = Запрос.Выполнить().Выбрать();
	Пока Выборка.Следующий() Цикл
		
		МенеджерЗаписи = РегистрыСведений.ПараметрыПлатежныхДокументовПоВзносамВФонды.СоздатьМенеджерЗаписи();
		МенеджерЗаписи.Организация = Организация;
		МенеджерЗаписи.СтатьяНалоговойДекларации = Выборка.Родитель;
		МенеджерЗаписи.СчетУчета = Выборка.СчетУчета;
		МенеджерЗаписи.Записать();
		
	КонецЦикла;
	
	//Коммунальный налог
	МенеджерЗаписи = РегистрыСведений.ПараметрыПлатежныхДокументовПоВзносамВФонды.СоздатьМенеджерЗаписи();
	МенеджерЗаписи.Организация = Организация;
	МенеджерЗаписи.СтатьяНалоговойДекларации = Справочники.СтатьиНалоговыхДеклараций.НП_Р2Коммунальный;
	МенеджерЗаписи.СчетУчета = ПланыСчетов.Хозрасчетный.РасчетыПоДругимНалогам;
	МенеджерЗаписи.Записать();

	
КонецПроцедуры

Процедура УстановитьОтборы()
	
	//Будет выводится информация по выбранной организации и по организации заданной по умолчанию (пустой организации)
	Если ЗначениеЗаполнено(Организация) Тогда
		СписокОрганизаций = Новый СписокЗначений;
		СписокОрганизаций.Добавить(Организация);
		СписокОрганизаций.Добавить(Справочники.Организации.ПустаяСсылка());
	Иначе
		СписокОрганизаций = Новый СписокЗначений;
		СписокОрганизаций.Добавить(Справочники.Организации.ПустаяСсылка());
	КонецЕсли;
	
	
		РегистрСведенийСписок.Отбор.Организация.Использование = Истина;
		РегистрСведенийСписок.Отбор.Организация.ВидСравнения = ВидСравнения.ВСписке;
		РегистрСведенийСписок.Отбор.Организация.Значение = СписокОрганизаций;		
	
КонецПроцедуры

Процедура УстановитьОтборНалоги(ПоВедомости)
	
	Если ПоВедомости Тогда
		Если ДокументыНачисления.Количество() > 0 Тогда
			мВедомость = ЭлементыФормы.ДокументыНачисления.ТекущаяСтрока.Ведомость;
			ЭлементыФормы.Налоги.ОтборСтрок.Ведомость.Значение  = мВедомость;
			ЭлементыФормы.Налоги.ОтборСтрок.Ведомость.Использование = Истина;
			ЭлементыФормы.Налоги.ОтборСтрок.Платежка.Использование = Ложь;
			
			ЭлементыФормы.НадписьПлатежка.Заголовок = ""+мВедомость;	
		КонецЕсли;
	ИначеЕсли Платежки.Количество() > 0 Тогда
		мСчетУчета = ЭлементыФормы.Платежки.ТекущаяСтрока.СчетУчета;
		мПлатежка = ЭлементыФормы.Платежки.ТекущаяСтрока.Платежка;
		
		ЭлементыФормы.Налоги.ОтборСтрок.Платежка.Значение  = мПлатежка;
		ЭлементыФормы.Налоги.ОтборСтрок.Платежка.Использование = Истина;
		ЭлементыФормы.Налоги.ОтборСтрок.Ведомость.Использование = Ложь;
		
		ЭлементыФормы.НадписьПлатежка.Заголовок = НСтр("ru='Счет Кт ';uk='Рахунок Кт '")+мСчетУчета+" - "+мПлатежка;	
	КонецЕсли;
	
КонецПроцедуры



////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ ТАБЛИЧНОГО ПОЛЯ Платежки 

// Процедура - обработчик события "ПриПолученииДанных" таблицы "РКО".
//
Процедура ТабличноеПолеПлатежкиПриПолученииДанных(Элемент, ОформленияСтрок)
	
	Запрос = Новый Запрос();
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	ПлатежноеПоручение.Проведен,
	|	ПлатежноеПоручение.ПометкаУдаления
	|ИЗ
	|	Документ.ПлатежноеПоручениеИсходящее КАК ПлатежноеПоручение
	|ГДЕ
	|	ПлатежноеПоручение.Ссылка = &Ссылка";
	
	// получим данные для отрисовки в ячейках
	Для Каждого Строка Из ОформленияСтрок Цикл
		ДанныеСтроки = Строка.ДанныеСтроки;
		Строка.Ячейки.Картинка.ОтображатьКартинку = Истина;
		
		Если ДанныеСтроки.Платежка.Пустая() Тогда
			Строка.Ячейки.Картинка.ИндексКартинки = 3;
		Иначе
			Запрос.УстановитьПараметр("Ссылка",ДанныеСтроки.Платежка);
			Выборка = Запрос.Выполнить().Выбрать();
			Если Выборка.Следующий() Тогда
				Если Выборка.Проведен Тогда
					Строка.Ячейки.Картинка.ИндексКартинки = 0;
				ИначеЕсли Выборка.ПометкаУдаления Тогда
					Строка.Ячейки.Картинка.ИндексКартинки = 1;
				Иначе
					Строка.Ячейки.Картинка.ИндексКартинки = 2;	
				КонецЕсли;
			КонецЕсли;
		КонецЕсли;			
	КонецЦикла;
	
КонецПроцедуры

Процедура ПлатежкиПриАктивизацииСтроки(Элемент)
	
	УстановитьОтборНалоги(Ложь);
	
КонецПроцедуры



////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ ТАБЛИЧНОГО ПОЛЯ ДокументыНачисления 

Процедура ДокументыНачисленияВедомостьНачалоВыбора(Элемент, СтандартнаяОбработка)
	
	Если Элемент.Значение <> Неопределено Тогда
		СтандартнаяОбработка=Ложь;
		
		Если ТипЗнч(Элемент.Значение) = Тип("ДокументСсылка.ЗарплатаКВыплатеОрганизаций") Тогда
			ФормаВыбора = Документы["ЗарплатаКВыплатеОрганизаций"].ПолучитьФормуВыбора(,Элемент,);
	
			ФормаВыбора.Отбор.Организация.ВидСравнения  = ВидСравнения.Равно;
			ФормаВыбора.Отбор.Организация.Значение      = Организация;
			ФормаВыбора.Отбор.Организация.Использование = Истина;
	
		ФормаВыбора.Открыть();
	ИначеЕсли ТипЗнч(Элемент.Значение) = Тип("ДокументСсылка.НачислениеКоммунальногоНалога") Тогда
			СтандартнаяОбработка = Ложь;
			ФормаВыбора = Документы["НачислениеКоммунальногоНалога"].ПолучитьФормуВыбора(,Элемент,);
			//
			ФормаВыбора.Отбор.Организация.ВидСравнения  = ВидСравнения.Равно;
			ФормаВыбора.Отбор.Организация.Значение      = Организация;
			ФормаВыбора.Отбор.Организация.Использование = Истина;
			//
			ФормаВыбора.Открыть();
		Иначе
			Возврат;

		КонецЕсли;
	КонецЕсли;

КонецПроцедуры

Процедура ДокументыНачисленияВедомостьПриИзменении(Элемент)
	
	Платежки.Очистить();
	Налоги.Очистить();
	Автозаполнение();		
	
	УстановитьОтборНалоги(Истина);
	
КонецПроцедуры

Процедура ДокументыНачисленияПриАктивизацииСтроки(Элемент)
	Если ЗначениеЗаполнено(Элемент.Значение) Тогда
		УстановитьОтборНалоги(Истина);
	КонецЕсли;
КонецПроцедуры

Процедура ДокументыНачисленияОбработкаВыбора(Элемент, ВыбранноеЗначение, СтандартнаяОбработка)
	
	УстановитьОтборНалоги(Истина);
	
КонецПроцедуры

Процедура ДокументыНачисленияВедомостьОбработкаВыбора(Элемент, ВыбранноеЗначение, СтандартнаяОбработка)
  	Если Не ЗначениеЗаполнено(Элемент.Значение) Тогда
		
		Если ВыбранноеЗначение= Тип("ДокументСсылка.ЗарплатаКВыплатеОрганизаций") Тогда
			СтандартнаяОбработка=Ложь;
		//
			ФормаВыбора = Документы["ЗарплатаКВыплатеОрганизаций"].ПолучитьФормуВыбора(,Элемент,);
			//
			ФормаВыбора.Отбор.Организация.ВидСравнения  = ВидСравнения.Равно;
			ФормаВыбора.Отбор.Организация.Значение      = Организация;
			ФормаВыбора.Отбор.Организация.Использование = Истина;
			//
			ФормаВыбора.Открыть();
		ИначеЕсли ВыбранноеЗначение = Тип("ДокументСсылка.НачислениеКоммунальногоНалога") Тогда
			СтандартнаяОбработка = Ложь;
			ФормаВыбора = Документы["НачислениеКоммунальногоНалога"].ПолучитьФормуВыбора(,Элемент,);
			//
			ФормаВыбора.Отбор.Организация.ВидСравнения  = ВидСравнения.Равно;
			ФормаВыбора.Отбор.Организация.Значение      = Организация;
			ФормаВыбора.Отбор.Организация.Использование = Истина;
			//
			ФормаВыбора.Открыть();
		Иначе
			Возврат;
			
		КонецЕсли;
	КонецЕсли;
КонецПроцедуры

Процедура ПлатежкиКонтрагентПриИзменении(Элемент)
	Данные = ЭлементыФормы.Платежки.ТекущиеДанные;
	
	пСчетУчета = Данные.СчетУчета;
	пСчетКонтрагента = Данные.СчетКонтрагента;
	пКонтрагент = Элемент.Значение;
	
	Для Каждого Строка ИЗ Налоги Цикл
		Если (Строка.СчетУчета = пСчетУчета) И (Строка.СчетКонтрагента = пСчетКонтрагента) Тогда
			Строка.Контрагент = пКонтрагент;
		КонецЕсли;
	КонецЦикла;
	
КонецПроцедуры

Процедура ПлатежкиСчетКонтрагентаПриИзменении(Элемент)
	Данные = ЭлементыФормы.Платежки.ТекущиеДанные;
	
	пСчетУчета = Данные.СчетУчета;
	пСчетКонтрагента = Элемент.Значение;
	пКонтрагент = Данные.Контрагент;
	
	Для Каждого Строка ИЗ Налоги Цикл
		Если (Строка.СчетУчета = пСчетУчета) И (Строка.Контрагент = пКонтрагент) Тогда
			Строка.СчетКонтрагента = пСчетКонтрагента;
		КонецЕсли;
	КонецЦикла;
	
КонецПроцедуры
