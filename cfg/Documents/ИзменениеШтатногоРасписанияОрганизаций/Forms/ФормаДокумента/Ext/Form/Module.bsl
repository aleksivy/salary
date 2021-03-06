Перем мТекущаяДатаДокумента; // Хранит последнюю установленную дату документа - для проверки перехода документа в другой период
Перем мВалютаПоУмолчанию; // Хранит значение константы ВалютаРегламентированногоУчета - для ввода значений по умолчанию
Перем мФормаВыбораВидаНадбавки;// Форма выбора вида надбавки
Перем мСпособыРасчетов; // список способов расчета надбавок
Перем мСведенияОВидахРасчета;

// Хранит дерево макетов печатных форм
Перем мДеревоМакетов;

// Хранит элемент управления подменю печати
Перем мПодменюПечати;

// Хранит элемент управления кнопку печать по умолчанию
Перем мПечатьПоУмолчанию;

// Хранит дерево кнопок подменю заполнение ТЧ
Перем мКнопкиЗаполненияТЧ;

////////////////////////////////////////////////////////////////////////////////
// ОБЩИЕ ПРОЦЕДУРЫ И ФУНКЦИИ


// Функция формирует структуру параметров для для ввода головной организации по подстроке
//
// Параметры
//  НЕТ
//
// Возвращаемое значение:
//   Структура имен и значений параметров
//
Функция ПолучитьСтруктуруПараметровТайпинга()
		
	СтруктураПараметров = Новый Структура("ТребуетВводаТарифногоРазряда,СпособРасчета",Ложь,мСпособыРасчетов);
	
	Возврат СтруктураПараметров;	
	
КонецФункции

// Процедура устанавливает подменю "Заполнить" в командных панелях ТЧ документа при необходимости
//
Процедура УстановитьКнопкиПодменюЗаполненияТЧ();
	
	мКнопкиЗаполненияТЧ = УниверсальныеМеханизмы.ПолучитьДеревоКнопокЗаполненияТабличныхЧастей(Ссылка,Новый Действие("НажатиеНаДополнительнуюКнопкуЗаполненияТЧ"));
	
	СоответствиеТЧ = Новый Соответствие;
	СоответствиеТЧ.Вставить(ЭлементыФормы.ШтатныеЕдиницы,ЭлементыФормы.КоманднаяПанельШтатныеЕдиницы);
	СоответствиеТЧ.Вставить(ЭлементыФормы.Надбавки,ЭлементыФормы.КоманднаяПанельНадбавки);
	
	УниверсальныеМеханизмы.СформироватьПодменюЗаполненияТЧПоДеревуКнопок(мКнопкиЗаполненияТЧ,СоответствиеТЧ);
	
КонецПроцедуры

// Процедура устанавливает подменю "Печать" и кнопку "Печать по умолчанию" при необходимости
//
Процедура УстановитьКнопкиПечати()
	
	ФормированиеПечатныхФорм.СоздатьКнопкиПечати(ЭтотОбъект, ЭтаФорма);	
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// ПРОЦЕДУРЫ - ОБРАБОТЧИКИ СОБЫТИЙ ФОРМЫ

// Процедура - обработчик события "ПередОткрытием" формы.
//
Процедура ПередОткрытием(Отказ, СтандартнаяОбработка)
	
	// Установка кнопок печати
	УстановитьКнопкиПечати();
	
	// Установка кнопок заполнение ТЧ
	УстановитьКнопкиПодменюЗаполненияТЧ();
	
	
КонецПроцедуры // ПередОткрытием()

// Процедура - обработчик события "ПриОткрытии" формы
//
Процедура ПриОткрытии()

	Если ЭтоНовый() Тогда
		// Заполнить реквизиты значениями по умолчанию.
		ЗаполнениеДокументов.ЗаполнитьШапкуДокумента(ЭтотОбъект);
	Иначе 
		// Установить доступность формы с учетом даты запрета редактирования	
		РаботаСДиалогами.УстановитьДоступностьФормыДляРедактирования(ЭтотОбъект, ЭтаФорма);
	КонецЕсли;	

	МеханизмНумерацииОбъектов.УстановитьДоступностьПоляВводаНомера(Метаданные(), ЭтаФорма, ЭлементыФормы.ДействияФормы.Кнопки.Подменю,ЭлементыФормы.Номер);
	
	СтруктураКолонок = Новый Структура();

	// Установить колонки, видимостью которых пользователь управлять не может.
	СтруктураКолонок.Вставить("Подразделение");
 	СтруктураКолонок.Вставить("Должность");
 	СтруктураКолонок.Вставить("ГрафикРаботы");

	// Установить ограничение - изменять видимоть колонок для таличной части Начисления
	ОбработкаТабличныхЧастей.УстановитьИзменятьВидимостьКолонокТабЧасти(ЭлементыФормы.ШтатныеЕдиницы.Колонки, СтруктураКолонок);

	СтруктураКолонок = Новый Структура();

	// Установить колонки, видимостью которых пользователь управлять не может.
	СтруктураКолонок.Вставить("Подразделение");
 	СтруктураКолонок.Вставить("Должность");
 	СтруктураКолонок.Вставить("ВидНадбавки");
 	СтруктураКолонок.Вставить("РазмерНадбавки");

	// Установить ограничение - изменять видимоть колонок для таличной части Начисления
	ОбработкаТабличныхЧастей.УстановитьИзменятьВидимостьКолонокТабЧасти(ЭлементыФормы.Надбавки.Колонки, СтруктураКолонок);

	// Вывести в заголовке формы вид операции и статус документа (новый, не проведен, проведен).
	РаботаСДиалогами.УстановитьЗаголовокФормыДокумента(, ЭтотОбъект, ЭтаФорма);

	// Запомнить текущие значения реквизитов формы.
	мТекущаяДатаДокумента        = Дата;

	// Установить активный реквизит.
	РаботаСДиалогами.АктивизироватьРеквизитВФорме(ЭтотОбъект, ЭтаФорма);

КонецПроцедуры

// Процедура - обработчик события "ПослеЗаписи" формы.
//
Процедура ПослеЗаписи()
	
	// Установка кнопок печати
	УстановитьКнопкиПечати();
	
	// Вывести в заголовке формы статус документа (новый, не проведен, проведен).
	РаботаСДиалогами.УстановитьЗаголовокФормыДокумента(, ЭтотОбъект, ЭтаФорма);
	
	МеханизмНумерацииОбъектов.ОбновитьПодсказкуКодНомерОбъекта(ЭтотОбъект.Метаданные(), ЭлементыФормы.ДействияФормы.Кнопки.Подменю, ЭлементыФормы.Номер);
	
КонецПроцедуры

// Процедура - обработчик события "ОбработкаВыбора" формы
//
Процедура ОбработкаВыбора(ЗначениеВыбора, Источник)

	Если Источник = мФормаВыбораВидаНадбавки Тогда

		Если ЭлементыФормы.Надбавки.ТекущаяСтрока  = Неопределено Тогда
			Возврат;
		КонецЕсли;
		
	    ЭлементыФормы.Надбавки.ТекущаяСтрока.ВидНадбавки  = ЗначениеВыбора;
        НадбавкиВидНадбавкиПриИзменении(ЭлементыФормы.Надбавки.ТекущаяСтрока.ВидНадбавки);
		
	КонецЕсли; 

КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// ПРОЦЕДУРЫ - ОБРАБОТЧИКИ СОБЫТИЙ РЕКВИЗИТОВ ШАПКИ

// Процедура - обработчик события "ПриИзменении" поля ввода даты документа
//
Процедура ДатаПриИзменении(Элемент = Неопределено)

	РаботаСДиалогами.ПроверитьНомерДокумента(ДокументОбъект, мТекущаяДатаДокумента);
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

////////////////////////////////////////////////////////////////////////////////
// ПРОЦЕДУРЫ - ДЕЙСТВИЯ КОМАНДНЫХ ПАНЕЛЕЙ ФОРМЫ

////////////////////////////////////////////////////////////////////////////////
// ПРОЦЕДУРЫ - ОБРАБОТЧИКИ СОБЫТИЙ ТЧ ШтатныеЕдиницы

// Процедура обеспечивает начальное значение реквизита "КоличествоСтавок"
//
// Параметры:
//  Элемент      - табличное поле, которое отображает т.ч.
//  НоваяСтрока  - булево, признак редактирования новой строки
//  
Процедура ШтатныеЕдиницыПриНачалеРедактирования(Элемент, НоваяСтрока)
	Если НоваяСтрока Тогда
		Если НЕ ЗначениеЗаполнено(Элемент.ТекущаяСтрока.КоличествоСтавок) Тогда
			Элемент.ТекущаяСтрока.КоличествоСтавок = 1;
		КонецЕсли;
		Если НЕ ЗначениеЗаполнено(Элемент.ТекущаяСтрока.ВалютаТарифнойСтавки) Тогда
			Элемент.ТекущаяСтрока.ВалютаТарифнойСтавки = мВалютаПоУмолчанию
		КонецЕсли;
		Если НЕ ЗначениеЗаполнено(Элемент.ТекущаяСтрока.ГрафикРаботы) Тогда
			Элемент.ТекущаяСтрока.ГрафикРаботы = ПроцедурыУправленияПерсоналом.ПолучитьГрафикРаботы(Ответственный);
		КонецЕсли;
		
	КонецЕсли;
КонецПроцедуры

// Процедура обеспечивает нестандартный шаг регулирования 
//
// Параметры:
//  Элемент      - элемент формы, который отображает занимаемые ставки.
//  Направление  - число, определяет, какая из кнопок регулирования была нажата.
//  СтандартнаяОбработка - булево, признак выполнения системной обработки события.
//  
Процедура ШтатныеЕдиницыКоличествоСтавокРегулирование(Элемент, Направление, СтандартнаяОбработка)
	Если Направление = 1 Тогда // увеличиваем значение
		ЭлементыФормы.ШтатныеЕдиницы.ТекущиеДанные.КоличествоСтавок = ЭлементыФормы.ШтатныеЕдиницы.ТекущиеДанные.КоличествоСтавок + 0.5
	Иначе // = -1 - уменьшаем значение
		ЭлементыФормы.ШтатныеЕдиницы.ТекущиеДанные.КоличествоСтавок = ЭлементыФормы.ШтатныеЕдиницы.ТекущиеДанные.КоличествоСтавок - 0.5
	КонецЕсли;
	СтандартнаяОбработка = Ложь;
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// ПРОЦЕДУРЫ - ОБРАБОТЧИКИ СОБЫТИЙ ТЧ Надбавки

Процедура НадбавкиВидНадбавкиПриИзменении(Элемент)
	
	Надбавка = ЭлементыФормы.Надбавки.ТекущиеДанные;
	
	Если Надбавка = Неопределено Тогда
		Возврат;
	КонецЕсли;	
		
	Если Надбавка.ВидНадбавки.СпособРасчета = Перечисления.СпособыРасчетаОплатыТруда.ДоплатаЗаВечерниеЧасы Тогда
		СтавкаВечерних = 100*РегистрыСведений.ПараметрыРасчетаЗарплатыОрганизаций.Получить(Новый Структура ("Организация", Организация)).КоэффициентВечерних;
		Надбавка.Показатель2 = СтавкаВечерних;
	ИначеЕсли  Надбавка.ВидНадбавки.СпособРасчета = Перечисления.СпособыРасчетаОплатыТруда.ДоплатаЗаНочныеЧасы Тогда
		СтавкаНочных = 100*РегистрыСведений.ПараметрыРасчетаЗарплатыОрганизаций.Получить(Новый Структура ("Организация", Организация)).КоэффициентНочных;
		Надбавка.Показатель2 = СтавкаНочных;
	КонецЕсли;

КонецПроцедуры

// Процедура - обработчик события "НачалоВыбора" значения реквизита "ВидНадбавки"
//
Процедура НадбавкиВидНадбавкиНачалоВыбора(Элемент, СтандартнаяОбработка)
	
	мФормаВыбораВидаНадбавки = ПланыВидовРасчета.ОсновныеНачисленияОрганизаций.ПолучитьФормуВыбора("ФормаВыбора", ЭтаФорма, "дляДокументаИзменениеШтатногоРасписания");

	// В качестве видов надбавом могут выступать расчеты, имеющий способ расчета "Проуентом" или "Фиксирвоанной суммой"
	мФормаВыбораВидаНадбавки.Отбор.СпособРасчета.ВидСравнения	= ВидСравнения.ВСписке;
	мФормаВыбораВидаНадбавки.Отбор.СпособРасчета.Значение		= мСпособыРасчетов;
	мФормаВыбораВидаНадбавки.Отбор.СпособРасчета.Использование	= Истина;
	
	мФормаВыбораВидаНадбавки.Отбор.ЗачетНормыВремени.ВидСравнения	= ВидСравнения.Равно;
	мФормаВыбораВидаНадбавки.Отбор.ЗачетНормыВремени.Значение		= Ложь;
	мФормаВыбораВидаНадбавки.Отбор.ЗачетНормыВремени.Использование	= Истина;

	мФормаВыбораВидаНадбавки.Открыть();
	СтандартнаяОбработка = Ложь;

КонецПроцедуры

Процедура НадбавкиПриВыводеСтроки(Элемент, ОформлениеСтроки, ДанныеСтроки)
	
	Если ТипЗнч(ДанныеСтроки.ВидНадбавки) = Тип("ПланВидовРасчетаСсылка.ОсновныеНачисленияОрганизаций") Тогда
		
		СведенияОВидеРасчета = РаботаСДиалогами.ПолучитьСведенияОВидеРасчетаСхемыМотивации(мСведенияОВидахРасчета, ДанныеСтроки.ВидНадбавки);
		ТолькоПросмотрЯчеек = Ложь;
		
		ЕстьПоказатели = Ложь;
		Для СчПоказателей = 1 По 6 Цикл
			УстановитьТолькоПросмотр = ТолькоПросмотрЯчеек;
			Если СчПоказателей <= СведенияОВидеРасчета["КоличествоПоказателей"] Тогда			
				
				Если СведенияОВидеРасчета["Показатель" + СчПоказателей + "НаименованиеВидимость"] Тогда
					ЕстьПоказатели = Истина;
					ОформлениеСтроки.Ячейки["НаименованиеПоказатель" + СчПоказателей].УстановитьТекст(СведенияОВидеРасчета["Показатель" + СчПоказателей + "Наименование"]);
					ОформлениеСтроки.Ячейки["НаименованиеПоказатель" + СчПоказателей].Видимость = Истина;
					ОформлениеСтроки.Ячейки["Показатель" + СчПоказателей].УстановитьТекст(Формат(ДанныеСтроки["Показатель" + СчПоказателей],"ЧДЦ=" + СведенияОВидеРасчета["Показатель" + СчПоказателей + "Точность"]));

				Иначе
					ОформлениеСтроки.Ячейки["НаименованиеПоказатель" + СчПоказателей].Видимость = Ложь;

				КонецЕсли;
				ОформлениеСтроки.Ячейки["Показатель" + СчПоказателей].Видимость = СведенияОВидеРасчета["Показатель" + СчПоказателей + "Видимость"];
				ОформлениеСтроки.Ячейки["Валюта" + СчПоказателей].Видимость = СведенияОВидеРасчета["Валюта" + СчПоказателей + "Видимость"];
				ОформлениеСтроки.Ячейки["Валюта" + СчПоказателей].ТолькоПросмотр = (НЕ СведенияОВидеРасчета["Валюта" + СчПоказателей + "Видимость"]) ИЛИ (УстановитьТолькоПросмотр);
				ОформлениеСтроки.Ячейки["Показатель" + СчПоказателей].ТолькоПросмотр = УстановитьТолькоПросмотр;
			Иначе
				ОформлениеСтроки.Ячейки["НаименованиеПоказатель" + СчПоказателей].Видимость = Ложь;
				ОформлениеСтроки.Ячейки["Показатель" + СчПоказателей].Видимость = Ложь;
				ОформлениеСтроки.Ячейки["Валюта" + СчПоказателей].Видимость = Ложь;

			КонецЕсли;
		КонецЦикла;
		
		Если не ЕстьПоказатели Тогда
			ОформлениеСтроки.Ячейки.НаименованиеПоказатель1.УстановитьТекст(НСтр("ru='<ввод при расчете>';uk='<введення при розрахунку>'"));
			ОформлениеСтроки.Ячейки.НаименованиеПоказатель1.Видимость = Истина;
			ОформлениеСтроки.Ячейки["Показатель1"].ТолькоПросмотр = Истина;
		КонецЕсли;
		
		ОформлениеСтроки.Ячейки.Показатели.Видимость = Ложь;

	КонецЕсли;
КонецПроцедуры

// Процедура - обработчик события "АвтоПодборТекста" значения реквизита "ВидНадбавки"
//
Процедура НадбавкиВидНадбавкиАвтоПодборТекста(Элемент, Текст, ТекстАвтоПодбора, СтандартнаяОбработка)
	
	ПроцедурыПоискаПоСтроке.АвтоПодборТекстаВЭлементеУправления(Элемент, Текст, ТекстАвтоПодбора, СтандартнаяОбработка, ПолучитьСтруктуруПараметровТайпинга(), Тип("ПланВидовРасчетаСсылка.ОсновныеНачисленияОрганизаций"));
	
КонецПроцедуры

// Процедура - обработчик события "ОкончаниеВводаТекста" значения реквизита "ВидНадбавки"
//
Процедура НадбавкиВидНадбавкиОкончаниеВводаТекста(Элемент, Текст, Значение, СтандартнаяОбработка)
	
	ПроцедурыПоискаПоСтроке.ОкончаниеВводаТекстаВЭлементеУправления(Элемент, Текст, Значение, СтандартнаяОбработка, ПолучитьСтруктуруПараметровТайпинга(), ЭтаФорма, Тип("ПланВидовРасчетаСсылка.ОсновныеНачисленияОрганизаций"), Ложь, Ложь, Неопределено, Ложь);
	НадбавкиВидНадбавкиПриИзменении(Элемент);
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// ПРОЦЕДУРЫ ОБРАБОТКИ СВОЙСТВ И КАТЕГОРИЙ

// Процедура выполняет открытие формы работы со свойствами документа
//
Процедура ДействияФормыДействиеОткрытьСвойства(Кнопка)

	РаботаСДиалогами.ОткрытьСвойстваДокумента(ЭтотОбъект, ЭтаФорма);

КонецПроцедуры

// Процедура выполняет открытие формы работы с категориями документа
//
Процедура ДействияФормыДействиеОткрытьКатегории(Кнопка)

	РаботаСДиалогами.ОткрытьКатегорииДокумента(ЭтотОбъект, ЭтаФорма);

КонецПроцедуры

// Процедура вызывается при выборе пункта подменю "Движения документа по регистрам" меню "Перейти".
// командной панели формы. Процедура отрабатывает печать движений документа по регистрам.
//
Процедура ДействияФормыДвиженияДокументаПоРегистрам(Кнопка)

	РаботаСДиалогами.НапечататьДвиженияДокумента(Ссылка);

КонецПроцедуры

// Процедура разрешения/запрещения редактирования номера документа
Процедура ДействияФормыРедактироватьНомер(Кнопка)
	
	МеханизмНумерацииОбъектов.ИзменениеВозможностиРедактированияНомера(ЭтотОбъект.Метаданные(), ЭтаФорма, ЭлементыФормы.ДействияФормы.Кнопки.Подменю, ЭлементыФормы.Номер);
			
КонецПроцедуры

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




////////////////////////////////////////////////////////////////////////////////
// ОПЕРАТОРЫ ОСНОВНОЙ ПРОГРАММЫ
// 

мВалютаПоУмолчанию = Константы.ВалютаРегламентированногоУчета.Получить();
мСпособыРасчетов = ПроведениеРасчетов.ПолучитьСписокВариантовНадбавок();
мСведенияОВидахРасчета = Новый Соответствие;

