﻿Процедура ПередОткрытием(Отказ, СтандартнаяОбработка)
	
	СписокДляВыбораПеиода = Новый СписокЗначений;
	СписокДляВыбораПеиода.Добавить(Перечисления.Периодичность.Месяц);
	СписокДляВыбораПеиода.Добавить(Перечисления.Периодичность.Квартал);
	СписокДляВыбораПеиода.Добавить(Перечисления.Периодичность.Неделя);
	СписокДляВыбораПеиода.Добавить(Перечисления.Периодичность.Год);
	СписокДляВыбораПеиода.Добавить(Перечисления.Периодичность.День);
	ЭлементыФормы.Периодичность.СписокВыбора = СписокДляВыбораПеиода;
	
	Если Не ЭтоОтработкаРасшифровки 
	   И Не СохранениеНастроек.ЗаполнитьНастройкиПриОткрытииОтчета(ОтчетОбъект) Тогда
		ИнициализацияОтчета();
		//ЭлементыФормы.РежимПланированияЗатрат.Доступность = ЭлементОтбора.Использование;
		//ЭлементыФормы.РежимПланированияЗатрат2.Доступность = ЭлементОтбора.Использование;
		ЭлементыФормы.Периодичность.Значение = Перечисления.Периодичность.Месяц;
	КонецЕсли;
	
	РежимПланированияЗатрат = "ПоЦентрамОтветственности";

	 
	ТиповыеОтчеты.ОбновитьФормуТиповогоОтчетаПоКомпоновщику(ОтчетОбъект, ЭтаФорма);
	УправлениеОтображениемЭлементовФормыТиповогоОтчета();
	
	
КонецПроцедуры


Процедура УправлениеОтображениемЭлементовФормыТиповогоОтчета()
	
	ЭлементыФормы.ДействияФормы.Кнопки.Отбор.Пометка = ОтчетОбъект.ПоказыватьБыстрыйОтбор;
	Если ЭлементыФормы.ДействияФормы.Кнопки.Заголовок.Пометка Тогда
		Значение = ТипВыводаТекстаКомпоновкиДанных.Выводить;
	Иначе
		Значение = ТипВыводаТекстаКомпоновкиДанных.НеВыводить;
	КонецЕсли;
	
	ОтчетОбъект.КомпоновщикНастроек.Настройки.ПараметрыВывода.НайтиЗначениеПараметра(Новый ПараметрКомпоновкиДанных("TitleOutput")).Значение = Значение;
	
	Если ОтчетОбъект.ПоказыватьБыстрыйОтбор Тогда
		// Нужно показывать отбор
		ЭлементыФормы.Разделитель1.Свертка = РежимСверткиЭлементаУправления.Нет;
		ЭлементыФормы.ПанельОтбора.Свертка = РежимСверткиЭлементаУправления.Нет;
		ЭлементыФормы.Разделитель1.УстановитьПривязку(ГраницаЭлементаУправления.Право, ЭлементыФормы.ДействияФормы, ГраницаЭлементаУправления.Лево, ЭлементыФормы.КоманднаяПанельПериод, ГраницаЭлементаУправления.Право);
		ЭлементыФормы.ПанельОтбора.УстановитьПривязку(ГраницаЭлементаУправления.Лево, ЭлементыФормы.Разделитель1, ГраницаЭлементаУправления.Право);
		
	Иначе
		// Не нужно показывать отбор
		ЭлементыФормы.ПанельОтбора.УстановитьПривязку(ГраницаЭлементаУправления.Лево);
		ЭлементыФормы.Разделитель1.УстановитьПривязку(ГраницаЭлементаУправления.Право, ЭлементыФормы.ПанельОтбора, ГраницаЭлементаУправления.Лево);
		ЭлементыФормы.ПанельОтбора.Свертка = РежимСверткиЭлементаУправления.Право;
		ЭлементыФормы.Разделитель1.Свертка = РежимСверткиЭлементаУправления.Право;
	КонецЕсли;
	
КонецПроцедуры

Процедура ДействияФормыНастройки(Кнопка)
	
	Если ТиповыеОтчеты.РедактироватьНастройкиТиповогоОтчета(ОтчетОбъект, ЭтаФорма) Тогда
		ОбновитьОтчет();
	КонецЕсли;
	
	Для каждого ЭлементОтб из  КомпоновщикНастроек.Настройки.Отбор.Элементы Цикл
		Если ТипЗнч(ЭлементОтб) = Тип("ЭлементОтбораКомпоновкиДанных") И ЭлементОтб.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("Учет") тогда
			ЭлементОтбора = ЭлементОтб;
		КонецЕсли;
	КонецЦикла;
	
	//Если ЭлементОтбора = Неопределено тогда
	//	ЭлементОтбора               = КомпоновщикНастроек.Настройки.Отбор.Элементы.Добавить("ЭлементОтбораКомпоновкиДанных");
	//	ЭлементОтбора.Использование  = Истина;
	//	ЭлементОтбора.ЛевоеЗначение  = Новый ПолеКомпоновкиДанных("Учет");
	//	ЭлементОтбора.ПравоеЗначение = Истина;
	//КонецЕсли;
	
	//ЭлементыФормы.РежимПланированияЗатрат.Доступность  = ЭлементОтбора.Использование;
	//ЭлементыФормы.РежимПланированияЗатрат2.Доступность = ЭлементОтбора.Использование;
	
КонецПроцедуры

Процедура ДействияФормыСформировать(Кнопка)
	
	ОбновитьОтчет();
	
КонецПроцедуры

Процедура ДействияФормыЗаголовок(Кнопка)
	
	Кнопка.Пометка = Не Кнопка.Пометка;
	УправлениеОтображениемЭлементовФормыТиповогоОтчета();
	ЭлементыФормы.Разделитель.Свертка = РежимСверткиЭлементаУправления.Нет;
	ТиповыеОтчеты.УправлениеОтображениемЗаголовкаТиповогоОтчета(ОтчетОбъект, ЭтаФорма.ЭлементыФормы.Результат);
	
КонецПроцедуры

Процедура ДействияФормыОткрытьВНовомОкне(Кнопка)
	
	НовыйОтчет = Отчеты[ОтчетОбъект.Метаданные().Имя].Создать();
	
	ЗаполнитьЗначенияСвойств(НовыйОтчет, ОтчетОбъект,, "СохраненнаяНастройка");
	НовыйОтчет.КомпоновщикНастроек.ЗагрузитьНастройки(ОтчетОбъект.КомпоновщикНастроек.ПолучитьНастройки());
	НовыйОтчет.Сценарии.Загрузить(Сценарии.Выгрузить());
	ФормаНовогоОтчета = НовыйОтчет.ПолучитьФорму();
	ФормаНовогоОтчета.ЭтоОтработкаРасшифровки = Истина;
	ФормаНовогоОтчета.Открыть();
	ФормаНовогоОтчета.ОбновитьОтчет();
	
	//СформироватьТиповойОтчет(НовыйОтчет, ФормаНовогоОтчета.ЭлементыФормы.Результат, ФормаНовогоОтчета.ДанныеРасшифровки);
	
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
	УправлениеОтображениемЭлементовФормыТиповогоОтчета();
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
	
	Перем ВыполненноеДействие;

	// Запретим стандартную обработку расшифровки
	СтандартнаяОбработка = Ложь;

	// Создадим и инициализируем обработчик расшифровки
	ОбработкаРасшифровки = Новый ОбработкаРасшифровкиКомпоновкиДанных(ДанныеРасшифровки, Новый ИсточникДоступныхНастроекКомпоновкиДанных(СхемаКомпоновкиДанных));
	
	ДоступныеДействия = Новый Массив();
	ДоступныеДействия.Добавить(ДействиеОбработкиРасшифровкиКомпоновкиДанных.ОткрытьЗначение);
	ДоступныеДействия.Добавить(ДействиеОбработкиРасшифровкиКомпоновкиДанных.Упорядочить);
	
	Элемент = ДанныеРасшифровки.Элементы[Расшифровка];
	Если ТипЗнч(Элемент) <> Тип("ЭлементРасшифровкиКомпоновкиДанныхПоля") Тогда
		ДоступныеДействия.Добавить(ДействиеОбработкиРасшифровкиКомпоновкиДанных.Расшифровать);
	Иначе
		Элементы = Элемент.ПолучитьРодителей();
		Если Элементы.Количество() > 0 Тогда
			Элемент = Элементы[0];
			Если ТипЗнч(Элемент) <> Тип("ЭлементРасшифровкиКомпоновкиДанныхГруппировка") Тогда
				ДоступныеДействия.Добавить(ДействиеОбработкиРасшифровкиКомпоновкиДанных.Расшифровать);
			КонецЕсли;
		КонецЕсли;
	КонецЕсли;
	
	// Осуществим выбор действия расшифровки пользователем
	Настройки = ОбработкаРасшифровки.Выполнить(Расшифровка, ВыполненноеДействие, ДоступныеДействия);
	
	Если Настройки <> Неопределено Тогда
		
		// Пользователь выбрал действие, для которого нужно менять настройки
        Если ВыполненноеДействие = ДействиеОбработкиРасшифровкиКомпоновкиДанных.Упорядочить Тогда
			
			ФормированиеПечатныхФорм.ПеренестиПорядокВОтчет(Настройки);
			
			Если ЭлементыФормы.ДействияФормы.Кнопки.Заголовок.Пометка тогда
				
				ЗначениеПараметра = Настройки.ПараметрыВывода.НайтиЗначениеПараметра(Новый ПараметрКомпоновкиДанных("TitleOutput"));
				ЗначениеПараметра.Значение = ТипВыводаТекстаКомпоновкиДанных.Выводить;
				
			КонецЕсли;
			
			// Если требется упорядочить - упорядочим в текущем отчете
			КомпоновщикНастроек.ЗагрузитьНастройки(Настройки);
			ОбновитьОтчет();

		Иначе
            // При других действиях - создадим новый отчет, откроем форму, сформируем отчет в ней
			Отчет = Отчеты[Метаданные().Имя].Создать();
			//Отчет = Отчеты.СравнительныйАнализЗатратНаПерсонал.Создать();
			Отчет.Сценарии.Загрузить(Сценарии.Выгрузить());
			Отчет.КомпоновщикНастроек.ЗагрузитьНастройки(Настройки);
			Отчет.Периодичность = Периодичность;
			Форма = Отчет.ПолучитьФорму();
			Форма.ЭтоОтработкаРасшифровки = истина;
			Форма.ОбновитьОтчет();
			Форма.Открыть();

		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

Процедура ДействияФормыПечать(Кнопка)
	
	ТиповыеОтчеты.ПечатьТиповогоОтчета(ЭлементыФормы.Результат);
	
КонецПроцедуры

Процедура ОбновитьОтчет() Экспорт
	
	СформироватьОтчет(ЭтаФорма.ЭлементыФормы.Результат, ЭтаФорма.ДанныеРасшифровки);
	
КонецПроцедуры

Процедура ТабличноеПолеОтборПриОкончанииРедактирования(Элемент, НоваяСтрока, ОтменаРедактирования)
	
	ТиповыеОтчеты.ОбработкаИзмененияТиповогоОтчетаНаФормеОтчета(ОтчетОбъект, ЭтаФорма);
	
КонецПроцедуры

Процедура СценарииПриВыводеСтроки(Элемент, ОформлениеСтроки, ДанныеСтроки)
	
	// Первая строка выделяется жирным шрифтом
	Если Сценарии.Индекс(ДанныеСтроки) = 0 Тогда
		ОформлениеСтроки.Шрифт = Новый Шрифт(ОформлениеСтроки.Шрифт, , , Истина, , , );
	КонецЕсли;
	
	Если НЕ ДанныеСтроки.ВидДанных=Перечисления.ВидыДанныхДляПланФактногоАнализаЗатратНаПерсонал.Сценарий Тогда
		ОформлениеСтроки.Ячейки.Сценарий.ТолькоПросмотр = Истина;
	КонецЕсли;
	
КонецПроцедуры

Процедура СценарииВидДанныхПриИзменении(Элемент)
	
	Если НЕ Элемент.Значение = Перечисления.ВидыДанныхДляПланФактногоАнализаЗатратНаПерсонал.Сценарий Тогда
		ЭлементыФормы.Сценарии.ТекущиеДанные.Сценарий = Справочники.СценарииПланирования.ПустаяСсылка();
	КонецЕсли;
	
КонецПроцедуры

Процедура СценарииСтрокаНачалоПериодаПриИзменении(Элемент)
	
	Сценарий = ЭлементыФормы.Сценарии.ТекущаяСтрока.Сценарий;
	Если Сценарии.Количество() > 0 тогда
		Периодичность = Сценарии[0].Сценарий.Периодичность;
	КонецЕсли;
	Если НЕ Сценарий.Пустая() тогда
		Периодичность = Сценарий.Периодичность;
	КонецЕсли;
	Если Периодичность <> Неопределено И Периодичность.Пустая() тогда
		Периодичность = Перечисления.Периодичность.Месяц;
	КонецЕсли;
	РаботаСДиалогами.ПериодПодобратьПоТексту(Элемент.Значение, Периодичность, ЭлементыФормы.Сценарии.ТекущаяСтрока.НачалоПериода);
	Элемент.Значение = ОбщегоНазначения.ПолучитьПериодСтрокой(ЭлементыФормы.Сценарии.ТекущаяСтрока.НачалоПериода, ОбщегоНазначения.ПолучитьИмяЭлементаПеречисленияПоЗначению(Периодичность));

КонецПроцедуры

Процедура СценарииСтрокаНачалоПериодаНачалоВыбораИзСписка(Элемент, СтандартнаяОбработка)
	
	Сценарий = ЭлементыФормы.Сценарии.ТекущаяСтрока.Сценарий;
	Если Сценарии.Количество() > 0 тогда
		Периодичность = Сценарии[0].Сценарий.Периодичность;
	КонецЕсли;
	Если НЕ Сценарий.Пустая() тогда
		Периодичность = Сценарий.Периодичность;
	КонецЕсли;
	Если Периодичность <> Неопределено И Периодичность.Пустая() тогда
		Периодичность = Перечисления.Периодичность.Месяц;
	КонецЕсли;
	НачалоПериода = ЭлементыФормы.Сценарии.ТекущаяСтрока.НачалоПериода;
	Бюджетирование.ПериодНачалоВыбораИзСписка(Элемент, СтандартнаяОбработка, ЭтаФорма, НачалоПериода, Периодичность);
	ЭлементыФормы.Сценарии.ТекущаяСтрока.НачалоПериода = НачалоПериода;
	
КонецПроцедуры

Процедура СценарииСтрокаНачалоПериодаОчистка(Элемент, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
КонецПроцедуры

Процедура СценарииСтрокаНачалоПериодаРегулирование(Элемент, Направление, СтандартнаяОбработка)
	
	Сценарий = ЭлементыФормы.Сценарии.ТекущаяСтрока.Сценарий;
	
	//Если Сценарий.Пустая() Тогда
	//	Возврат;
	//КонецЕсли;
	Если Сценарии.Количество() > 0 тогда
		Периодичность = Сценарии[0].Сценарий.Периодичность;
	КонецЕсли;
	Если НЕ Сценарий.Пустая() тогда
		Периодичность = Сценарий.Периодичность;
	КонецЕсли;
	Если Периодичность <> Неопределено И Периодичность.Пустая() тогда
		Периодичность = Перечисления.Периодичность.Месяц;
	КонецЕсли;
	
	ДатаПланирования = ЭлементыФормы.Сценарии.ТекущаяСтрока.НачалоПериода;
	ДатаПланирования = ОбщегоНазначения.ДатаНачалаПериода(ОбщегоНазначения.ДобавитьИнтервал(ДатаПланирования, Периодичность, Направление), Периодичность);
	ЭлементыФормы.Сценарии.ТекущаяСтрока.НачалоПериода = ДатаПланирования;
	Элемент.Значение = ОбщегоНазначения.ПолучитьПериодСтрокой(ДатаПланирования, ОбщегоНазначения.ПолучитьИмяЭлементаПеречисленияПоЗначению(Периодичность));
	
КонецПроцедуры

Процедура СценарииСтрокаНачалоПериодаАвтоПодборТекста(Элемент, Текст, ТекстАвтоПодбора, СтандартнаяОбработка)
	
	Сценарий = ЭлементыФормы.Сценарии.ТекущаяСтрока.Сценарий;
	Если Сценарии.Количество() > 0 тогда
		Периодичность = Сценарии[0].Сценарий.Периодичность;
	КонецЕсли;
	Если НЕ Сценарий.Пустая() тогда
		Периодичность = Сценарий.Периодичность;
	КонецЕсли;
	Если Периодичность <> Неопределено И Периодичность.Пустая() тогда
		Периодичность = Перечисления.Периодичность.Месяц;
	КонецЕсли;
	
	РаботаСДиалогами.ПериодАвтоПодборТекста(Текст, ТекстАвтоПодбора, Периодичность, СтандартнаяОбработка);
	
КонецПроцедуры

Процедура СценарииСтрокаНачалоПериодаОкончаниеВводаТекста(Элемент, Текст, Значение, СтандартнаяОбработка)
	
	Сценарий = ЭлементыФормы.Сценарии.ТекущаяСтрока.Сценарий;
	Если Сценарии.Количество() > 0 тогда
		Периодичность = Сценарии[0].Сценарий.Периодичность;
	КонецЕсли;
	Если НЕ Сценарий.Пустая() тогда
		Периодичность = Сценарий.Периодичность;
	КонецЕсли;
	Если Периодичность <> Неопределено И Периодичность.Пустая() тогда
		Периодичность = Перечисления.Периодичность.Месяц;
	КонецЕсли;
	РаботаСДиалогами.ПериодОкончаниеВводаТекста(Текст, Значение, Периодичность, СтандартнаяОбработка, ЭлементыФормы.Сценарии.ТекущаяСтрока.НачалоПериода);
	Элемент.Значение = Значение;
КонецПроцедуры

Процедура СценарииСтрокаКонецПериодаПриИзменении(Элемент)
	
	Сценарий = ЭлементыФормы.Сценарии.ТекущаяСтрока.Сценарий;
	Если Сценарии.Количество() > 0 тогда
		Периодичность = Сценарии[0].Сценарий.Периодичность;
	КонецЕсли;
	Если НЕ Сценарий.Пустая() тогда
		Периодичность = Сценарий.Периодичность;
	КонецЕсли;
	Если Периодичность <> Неопределено И Периодичность.Пустая() тогда
		Периодичность = Перечисления.Периодичность.Месяц;
	КонецЕсли;
	
	РаботаСДиалогами.ПериодПодобратьПоТексту(Элемент.Значение, Периодичность, ЭлементыФормы.Сценарии.ТекущаяСтрока.КонецПериода);
	
	Элемент.Значение = ОбщегоНазначения.ПолучитьПериодСтрокой(ЭлементыФормы.Сценарии.ТекущаяСтрока.КонецПериода, ОбщегоНазначения.ПолучитьИмяЭлементаПеречисленияПоЗначению(Периодичность));
	
	ЭлементыФормы.Сценарии.ТекущаяСтрока.КонецПериода = ОбщегоНазначения.ДатаКонцаПериода(ЭлементыФормы.Сценарии.ТекущаяСтрока.КонецПериода, Периодичность);
	
КонецПроцедуры

Процедура СценарииСтрокаКонецПериодаНачалоВыбораИзСписка(Элемент, СтандартнаяОбработка)
	
	Сценарий = ЭлементыФормы.Сценарии.ТекущаяСтрока.Сценарий;
	Если Сценарии.Количество() > 0 тогда
		Периодичность = Сценарии[0].Сценарий.Периодичность;
	КонецЕсли;
	Если НЕ Сценарий.Пустая() тогда
		Периодичность = Сценарий.Периодичность;
	КонецЕсли;
	Если Периодичность <> Неопределено И Периодичность.Пустая() тогда
		Периодичность = Перечисления.Периодичность.Месяц;
	КонецЕсли;
	
	ДатаПланирования = ОбщегоНазначения.ДатаНачалаПериода(ЭлементыФормы.Сценарии.ТекущаяСтрока.КонецПериода, Периодичность);
	
	Бюджетирование.ПериодНачалоВыбораИзСписка(Элемент, СтандартнаяОбработка, ЭтаФорма, ДатаПланирования, Периодичность);
	
	ЭлементыФормы.Сценарии.ТекущаяСтрока.КонецПериода = ОбщегоНазначения.ДатаКонцаПериода(ДатаПланирования, Периодичность);
	
КонецПроцедуры

Процедура СценарииСтрокаКонецПериодаОчистка(Элемент, СтандартнаяОбработка)
	
	СтандартнаяОбработка = ложь;
	
КонецПроцедуры

Процедура СценарииСтрокаКонецПериодаРегулирование(Элемент, Направление, СтандартнаяОбработка)
	
	Сценарий = ЭлементыФормы.Сценарии.ТекущаяСтрока.Сценарий;
	
	Если Сценарии.Количество() > 0 тогда
		Периодичность = Сценарии[0].Сценарий.Периодичность;
	КонецЕсли;
	Если НЕ Сценарий.Пустая() тогда
		Периодичность = Сценарий.Периодичность;
	КонецЕсли;
	Если Периодичность <> Неопределено И Периодичность.Пустая() тогда
		Периодичность = Перечисления.Периодичность.Месяц;
	КонецЕсли;
	
	ДатаПланирования = ЭлементыФормы.Сценарии.ТекущаяСтрока.КонецПериода;
	ДатаПланирования = КонецДня(ОбщегоНазначения.ДатаКонцаПериода(ОбщегоНазначения.ДобавитьИнтервал(ДатаПланирования, Периодичность, Направление), Периодичность));
	ЭлементыФормы.Сценарии.ТекущаяСтрока.КонецПериода = ОбщегоНазначения.ДатаКонцаПериода(ДатаПланирования, Периодичность);
	Элемент.Значение = ОбщегоНазначения.ПолучитьПериодСтрокой(ДатаПланирования, ОбщегоНазначения.ПолучитьИмяЭлементаПеречисленияПоЗначению(Периодичность));
	
КонецПроцедуры

Процедура СценарииСтрокаКонецПериодаАвтоПодборТекста(Элемент, Текст, ТекстАвтоПодбора, СтандартнаяОбработка)
	
	Сценарий = ЭлементыФормы.Сценарии.ТекущаяСтрока.Сценарий;
	Если Сценарии.Количество() > 0 тогда
		Периодичность = Сценарии[0].Сценарий.Периодичность;
	КонецЕсли;
	Если НЕ Сценарий.Пустая() тогда
		Периодичность = Сценарий.Периодичность;
	КонецЕсли;
	Если Периодичность <> Неопределено И Периодичность.Пустая() тогда
		Периодичность = Перечисления.Периодичность.Месяц;
	КонецЕсли;
	
	РаботаСДиалогами.ПериодАвтоПодборТекста(Текст, ТекстАвтоПодбора, Периодичность, СтандартнаяОбработка);
	
КонецПроцедуры

Процедура СценарииСтрокаКонецПериодаОкончаниеВводаТекста(Элемент, Текст, Значение, СтандартнаяОбработка)
	
	Сценарий = ЭлементыФормы.Сценарии.ТекущаяСтрока.Сценарий;
	Если Сценарии.Количество() > 0 тогда
		Периодичность = Сценарии[0].Сценарий.Периодичность;
	КонецЕсли;
	Если НЕ Сценарий.Пустая() тогда
		Периодичность = Сценарий.Периодичность;
	КонецЕсли;
	Если Периодичность <> Неопределено И Периодичность.Пустая() тогда
		Периодичность = Перечисления.Периодичность.Месяц;
	КонецЕсли;
	РаботаСДиалогами.ПериодОкончаниеВводаТекста(Текст, Значение, Периодичность, СтандартнаяОбработка, ЭлементыФормы.Сценарии.ТекущаяСтрока.КонецПериода);
	ЭлементыФормы.Сценарии.ТекущаяСтрока.КонецПериода = ОбщегоНазначения.ДатаКонцаПериода(ЭлементыФормы.Сценарии.ТекущаяСтрока.КонецПериода, Периодичность);
	Элемент.Значение = Значение;

КонецПроцедуры

Процедура РежимПланированияЗатратПриИзменении(Элемент)
	
	ЭлементОтбораПодразделения = Неопределено;
	
	Для каждого ЭлементОтб из  КомпоновщикНастроек.Настройки.Отбор.Элементы Цикл
		Если ТипЗнч(ЭлементОтб) = Тип("ЭлементОтбораКомпоновкиДанных") И ЭлементОтб.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("Подразделение") тогда
			ЭлементОтбораПодразделения = ЭлементОтб;
		КонецЕсли;
	КонецЦикла;
	
	Если Элемент.Значение = "ПоЦентрамОтветственности" тогда
		Если ЭлементОтбораПодразделения <> Неопределено тогда
			ЭлементОтбораПодразделения.ПравоеЗначение = Справочники.Подразделения.ПустаяСсылка();
		КонецЕсли;
	ИначеЕсли Элемент.Значение = "ПоОрганизационнойСтруктуреПредприятия" тогда
		Если ЭлементОтбораПодразделения <> Неопределено тогда
			ЭлементОтбораПодразделения.ПравоеЗначение = Справочники.ПодразделенияОрганизаций.ПустаяСсылка();
		КонецЕсли;
	КонецЕсли;
КонецПроцедуры

Процедура СценарииПриНачалеРедактирования(Элемент, НоваяСтрока, Копирование)
	Если НоваяСтрока тогда
		Если Сценарии.Количество() > 0 И Элемент.ТекущаяСтрока.НомерСтроки <> 1 тогда
			Элемент.ТекущаяСтрока.НачалоПериода = Сценарии[0].НачалоПериода;
			Элемент.ТекущаяСтрока.КонецПериода  = Сценарии[0].КонецПериода;
		Иначе
			Элемент.ТекущаяСтрока.НачалоПериода = НачалоМесяца(ОбщегоНазначения.ПолучитьРабочуюДату());
			Элемент.ТекущаяСтрока.КонецПериода  = НачалоМесяца(ОбщегоНазначения.ПолучитьРабочуюДату());
		КонецЕсли;
		Сценарий = Элемент.ТекущаяСтрока.Сценарий;
		Если Сценарии.Количество() > 0 тогда
			Периодичность = Сценарии[0].Сценарий.Периодичность;
		КонецЕсли;
		Если НЕ Сценарий.Пустая() тогда
			Периодичность = Сценарий.Периодичность;
		КонецЕсли;
		Если Периодичность <> Неопределено И Периодичность.Пустая() тогда
			Периодичность = Перечисления.Периодичность.Месяц;
		КонецЕсли;
		Элемент.ТекущаяСтрока.СтрокаНачалоПериода = ОбщегоНазначения.ПолучитьПериодСтрокой(Сценарии[0].НачалоПериода, ОбщегоНазначения.ПолучитьИмяЭлементаПеречисленияПоЗначению(Периодичность));
		Элемент.ТекущаяСтрока.СтрокаКонецПериода  = ОбщегоНазначения.ПолучитьПериодСтрокой(Сценарии[0].КонецПериода, ОбщегоНазначения.ПолучитьИмяЭлементаПеречисленияПоЗначению(Периодичность));
	КонецЕсли;
КонецПроцедуры

Процедура СценарииСценарийПриИзменении(Элемент)
	Таблица = ЭлементыФормы.Сценарии;
	Если Таблица.ТекущаяСтрока.НачалоПериода = '00010101' тогда
		Таблица.ТекущаяСтрока.НачалоПериода = ОбщегоНазначения.ПолучитьРабочуюДату();
	КонецЕсли;
	Если Таблица.ТекущаяСтрока.КонецПериода = '00010101' тогда
		 Таблица.ТекущаяСтрока.КонецПериода = ОбщегоНазначения.ПолучитьРабочуюДату();
	КонецЕсли;
	Таблица.ТекущаяСтрока.НачалоПериода = ОбщегоНазначения.ДатаНачалаПериода(Таблица.ТекущаяСтрока.НачалоПериода, Элемент.Значение.Периодичность);
	Таблица.ТекущаяСтрока.КонецПериода  = КонецДня(ОбщегоНазначения.ДатаКонцаПериода(Таблица.ТекущаяСтрока.КонецПериода, Элемент.Значение.Периодичность));
	Таблица.ТекущаяСтрока.СтрокаНачалоПериода = ОбщегоНазначения.ПолучитьПериодСтрокой(Таблица.ТекущаяСтрока.НачалоПериода, ОбщегоНазначения.ПолучитьИмяЭлементаПеречисленияПоЗначению(Элемент.Значение.Периодичность));
	Таблица.ТекущаяСтрока.СтрокаКонецПериода  = ОбщегоНазначения.ПолучитьПериодСтрокой(Таблица.ТекущаяСтрока.КонецПериода, ОбщегоНазначения.ПолучитьИмяЭлементаПеречисленияПоЗначению(Элемент.Значение.Периодичность));
	Если Таблица.ТекущаяСтрока.НомерСтроки = 1 тогда
		ФактическиеДанныеСтроки = Сценарии.Найти(Справочники.СценарииПланирования.ПустаяСсылка(), "Сценарий");
		Если ФактическиеДанныеСтроки <> Неопределено тогда
			ФактическиеДанныеСтроки.НачалоПериода = ОбщегоНазначения.ДатаНачалаПериода(ФактическиеДанныеСтроки.НачалоПериода, Элемент.Значение.Периодичность);
			ФактическиеДанныеСтроки.КонецПериода  = КонецДня(ОбщегоНазначения.ДатаКонцаПериода(ФактическиеДанныеСтроки.КонецПериода, Элемент.Значение.Периодичность));
			ФактическиеДанныеСтроки.СтрокаНачалоПериода = ОбщегоНазначения.ПолучитьПериодСтрокой(ФактическиеДанныеСтроки.НачалоПериода, ОбщегоНазначения.ПолучитьИмяЭлементаПеречисленияПоЗначению(Элемент.Значение.Периодичность));
			ФактическиеДанныеСтроки.СтрокаКонецПериода  = ОбщегоНазначения.ПолучитьПериодСтрокой(ФактическиеДанныеСтроки.КонецПериода, ОбщегоНазначения.ПолучитьИмяЭлементаПеречисленияПоЗначению(Элемент.Значение.Периодичность));
		КонецЕсли;
	КонецЕсли;
КонецПроцедуры

