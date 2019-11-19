﻿////////////////////////////////////////////////////////////////////////////////
// ПЕРЕМЕННЫЕ МОДУЛЯ

//Перем СписокИдентифицирующихВопросов;
Перем ТекущийРаздел;
Перем ЕстьФизическиеЛица;
Перем ЕстьКонтрагенты;
Перем ЕстьКонтактныеЛица;

//Хранит область"R1C1" пустого табличного документа в качестве образца
Перем мОбластьОбразцовойЯчейки;

////////////////////////////////////////////////////////////////////////////////
// ПРОЦЕДУРЫ И ФУНКЦИИ ОБЩЕГО НАЗНАЧЕНИЯ

Процедура ДействияФормыРедактироватьКод(Кнопка)
	МеханизмНумерацииОбъектов.ИзменениеВозможностиРедактированияНомера(ЭтотОбъект.Метаданные(), ЭтаФорма, ЭлементыФормы.ДействияФормы.Кнопки.Подменю, ЭлементыФормы.Код);
КонецПроцедуры
// Процедура очищает макет печатной формы анкеты
//
Процедура ОчиститьМакет(ДокументМакет)
	Если Вопрос(НСтр("ru='Макет будет очищен. Продолжить?';uk='Макет буде очищений. Продовжити?'"),РежимДиалогаВопрос.ДаНет)=КодВозвратаДиалога.Да тогда
		ДокументМакет.Очистить();
	КонецЕсли;	
КонецПроцедуры

Функция ПроверкаПравильностиЗаполненияАнкеты(ВыводитьСообщения = Истина)
	
	ОбнаруженыОшибки = Ложь;
	
	Если ЗагружатьОбъекты и НЕ ЗначениеЗаполнено(ВидСправочникаДляЗагрузки) тогда
		Если ВыводитьСообщения тогда
			Сообщить(НСтр("ru='Для анкеты, загружаемой в справочники, обязательно надо указать в какой именно справочник следует загружать данные.';uk=""Для анкети, що завантажується в довідники, обов'язково треба вказати, в який саме довідник слід завантажувати дані."""));
		КонецЕсли;
		ОбнаруженыОшибки = Истина;
	КонецЕсли;
	
	Если ЗагружатьОбъекты тогда
		
		Если ЕстьФизическиеЛица И ВидСправочникаДляЗагрузки = Перечисления.ВидыОбъектовЗагружаемыхИзОпроса.ФизическиеЛица тогда
			Если ВопросыАнкеты.Количество() > 0 тогда
				Если ВопросыАнкеты[0].Вопрос <> ПланыВидовХарактеристик.ВопросыДляАнкетирования.Фамилия тогда
					Если ВыводитьСообщения тогда
						Сообщить(НСтр("ru='Первым вопросом в анкете, из которой будут создаваться физические лица, должен быть ""Фамилия""';uk='Першим питанням в анкеті, з якої будуть створюватися фізичні особи, повинне бути ""Прізвище""'"));
					КонецЕсли;
					ОбнаруженыОшибки = Истина;
				КонецЕсли;
			КонецЕсли;
			Если ВопросыАнкеты.Количество() > 1 тогда
				Если ВопросыАнкеты[1].Вопрос <> ПланыВидовХарактеристик.ВопросыДляАнкетирования.Имя тогда
					Если ВыводитьСообщения тогда
						Сообщить(НСтр("ru='Вторым вопросом в анкете, из которой будут создаваться физические лица, должен быть ""Имя""';uk='Другим питанням в анкеті, з якої будуть створюватися фізичні особи, повинно бути ""Ім''я""'"));
					КонецЕсли;
					ОбнаруженыОшибки = Истина;
				КонецЕсли;
			КонецЕсли;
		
			Если ВопросыАнкеты.Количество() > 2 тогда
				Если ВопросыАнкеты[2].Вопрос <> ПланыВидовХарактеристик.ВопросыДляАнкетирования.Отчество тогда
					Если ВыводитьСообщения тогда
						Сообщить(НСтр("ru='Третьим вопросом в анкете, из которой будут создаваться физические лица, должен быть ""Отчество""';uk='Третім питанням в анкеті, з якої будуть створюватися фізичні особи, повинено бути ""По-батькові""'"));
					КонецЕсли;
					ОбнаруженыОшибки = Истина;
				КонецЕсли;
			КонецЕсли;
			
			Если ВопросыАнкеты.Количество() > 3 тогда
				Если ВопросыАнкеты[3].Вопрос <> ПланыВидовХарактеристик.ВопросыДляАнкетирования.ДатаРождения тогда
					Если ВыводитьСообщения тогда
						Сообщить(НСтр("ru='Четвертым вопросом в анкете, из которой будут создаваться физические лица, должен быть ""Дата рождения""';uk='Четвертим питанням в анкеті, з якої будуть створюватися фізичні особи, повинно бути ""Дата народження""'"));
					КонецЕсли;
					ОбнаруженыОшибки = Истина;
				КонецЕсли;
			КонецЕсли;
		
		Иначе
			// если анкета не загружаемая, тогда ничего проверять не надо
			Если Адресная И НЕ ЗначениеЗаполнено(ВидСправочникаДляЗагрузки) тогда
				Если ВыводитьСообщения тогда
					Сообщить(НСтр("ru='Для адресной анкеты, необходимо указать вид справочника для загрузки.';uk='Для адресної анкети, необхідно вказати вид довідника для завантаження.'"));
				КонецЕсли;
				ОбнаруженыОшибки = Истина;
			КонецЕсли;
		КонецЕсли;
	КонецЕсли;
	
	Возврат НЕ ОбнаруженыОшибки;
	
КонецФункции

////////////////////////////////////////////////////////////////////////////////
// ПРОЦЕДУРЫ - ОБРАБОТЧИКИ СОБЫТИЙ ФОРМЫ

// Обработчик события "ПередОткрытием" формы.
Процедура ПередОткрытием(Отказ, СтандартнаяОбработка)
	
	// у нового элемента не может быть ссылок на Раздел в ТЧ Вопросы анкеты
	Если ЭтоНовый() Тогда
		Для каждого Строка из ВопросыАнкеты Цикл
			Если ЗначениеЗаполнено(Строка.Раздел) Тогда
				Строка.Раздел = Справочники.РазделыАнкеты.ПустаяСсылка();
			КонецЕсли;
		КонецЦикла;
	КонецЕсли;
	
	//Параметры макета по умолчанию 
	ЭлементыФормы.ДокументМакет.ОтображатьСетку = Истина;
	ЭлементыФормы.ДокументМакет.ОтображатьЗаголовки = Истина;
	ЭлементыФормы.ДокументМакет.Автомасштаб = Истина;
	
	//Берем образец из пустого табличного документа
   	ЭлементыФормы.ДокументМакет.Очистить();
	мОбластьОбразцовойЯчейки=ЭлементыФормы.ДокументМакет.Область(1,1); 

	//Загружаем макет для редактирования
	ЭлементыФормы.ДокументМакет.ВставитьОбласть(ВосстановитьМакет().Область(), ЭлементыФормы.ДокументМакет.Область(),,Ложь);
	
	ЗагружатьОбъектыДоступность();
	
КонецПроцедуры

// Обработчик события "ПриОткрытии" формы.
Процедура ПриОткрытии()
	
	ЭлементыФормы.РазделыАнкеты.НастройкаПорядка.Код.Доступность = Истина;
	ЭлементыФормы.РазделыАнкеты.Значение.Порядок.Установить("Код возр");
	
	МеханизмНумерацииОбъектов.ДобавитьВМенюДействияКнопкуРедактированияКода(ЭлементыФормы.ДействияФормы.Кнопки.Подменю);
	МеханизмНумерацииОбъектов.УстановитьДоступностьПоляВводаНомера(Метаданные(), ЭтаФорма, ЭлементыФормы.ДействияФормы.Кнопки.Подменю,ЭлементыФормы.Код);
	
КонецПроцедуры

// Обработчик события "ПередЗаписью" формы.
Процедура ПередЗаписью(Отказ)
	
	//ТабличныйДокумент = Новый ТабличныйДокумент;
	//ТабличныйДокумент.Вывести(ЭлементыФормы.ДокументМакет);
	СохранитьМакет(ЭлементыФормы.ДокументМакет);
	
	// проверка заполнение полей таблицы вопросов
	Для каждого Вопрос из ВопросыАнкеты Цикл
		Если НЕ ЗначениеЗаполнено(Вопрос.Вопрос) Тогда
			Предупреждение(НСтр("ru='В строке № ';uk='У рядку № '")+Вопрос.НомерСтроки+НСтр("ru=' не выбран вопрос!';uk=' не вибрано питання!'"));
			Отказ = Истина;
		КонецЕсли;
	КонецЦикла;
	
КонецПроцедуры

Процедура ПослеЗаписи()
	
	ПроверкаПравильностиЗаполненияАнкеты();
	
	МеханизмНумерацииОбъектов.ОбновитьПодсказкуКодНомерОбъекта(ЭтотОбъект.Метаданные(), ЭлементыФормы.ДействияФормы.Кнопки.Подменю, ЭлементыФормы.Код);
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// ПРОЦЕДУРЫ - ДЕЙСТВИЯ КОМАНДНЫХ ПАНЕЛЕЙ ФОРМЫ

// Процедура выводит на экран печатную форму анкеты
//
Процедура ОсновныеДействияФормыДействиеПечать(Кнопка) 

	Если Модифицированность() Тогда
		Вопрос = НСтр("ru='Перед печатью необходимо записать анкету. Записать?';uk='Перед друком необхідно записати анкету. Записати?'");
		Ответ  = Вопрос(Вопрос, РежимДиалогаВопрос.ОКОтмена);

		Если Ответ = КодВозвратаДиалога.ОК Тогда
			ЗаписатьВФорме();
		Иначе
			Возврат;
		КонецЕсли;
	КонецЕсли;

	ПечатныйДокумент = Новый ТабличныйДокумент;
	ПечатныйДокумент.ИмяПараметровПечати = "ПАРАМЕТРЫ_ПЕЧАТИ_ТиповыеАнкеты";
	// если макет еще был заполнен - сформируем его по умолчанию
	Если ЭлементыФормы.ДокументМакет.ВысотаТаблицы = 0 Тогда
		СформироватьМакет(ЭлементыФормы.ДокументМакет);
		ПечатныйДокумент.Вывести(ЭлементыФормы.ДокументМакет);
	Иначе
		ПечатныйДокумент.Вывести(ЭлементыФормы.ДокументМакет);
	КонецЕсли;
	ПечатныйДокумент.Автомасштаб = Истина;
	УниверсальныеМеханизмы.НапечататьДокумент(ПечатныйДокумент, , , "Типовая анкета " + Наименование, Ссылка);
	
КонецПроцедуры

Процедура ОсновныеДействияФормыОтправить(Кнопка)
	
	Отказ = НЕ ПроверкаПравильностиЗаполненияАнкеты();
	Если Отказ тогда
		Сообщить(НСтр("ru='В анкете обнаружены ошибки. Рекомендуется их исправить и только после этого приступать к рассылке.';uk='В анкеті виявлені помилки. Рекомендується їх виправити і тільки після цього приступати до розсилки.'"));
	Иначе
		Если Модифицированность() тогда
			Если Вопрос(НСтр("ru='Перед рассылкой необходимо сохранить внесенные изменения. Записать анкету?';uk='Перед розсилкою необхідно зберегти внесені зміни. Записати анкету?'"), РежимДиалогаВопрос.ДаНет) = КодВозвратаДиалога.Да тогда
				Отказ = НЕ ЗаписатьВФорме();
			Иначе
				Отказ = Истина;
			КонецЕсли;
		КонецЕсли;
		Если Не Отказ Тогда
			ФормаСпискаДокументовРассылки = Документы.РассылкаАнкет.ПолучитьФормуСписка("ФормаСписка");
			ФормаСпискаДокументовРассылки.Отбор.Анкета.Значение 		= Ссылка;
			ФормаСпискаДокументовРассылки.Отбор.Анкета.Использование 	= Истина;
			ФормаСпискаДокументовРассылки.Открыть();
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

Процедура ОсновныеДействияФормыПросмотрHTML(Кнопка)
	
	Если Модифицированность() Тогда
		Вопрос = НСтр("ru='Перед просмотром необходимо записать анкету. Записать?';uk='Перед переглядом необхідно записати анкету. Записати?'");
		Ответ  = Вопрос(Вопрос, РежимДиалогаВопрос.ОКОтмена);

		Если Ответ = КодВозвратаДиалога.ОК Тогда
			ЗаписатьВФорме();
		Иначе
			Возврат;
		КонецЕсли;
	КонецЕсли;
	
	ОткрытьВложение();
	
КонецПроцедуры

// Процедура - обработчик нажатия кнопки "Очистить" панели редактирования макета печатной формы анкеты
//
Процедура КоманднаяПанельМакетаДействиеОчистить(Кнопка)
	ОчиститьМакет(ЭлементыФормы.ДокументМакет)
КонецПроцедуры

// Процедура - обработчик нажатия кнопки "Заполнить" панели редактирования макета печатной формы анкеты
//
Процедура КоманднаяПанельМакетаДействиеЗаполнитьМакет(Кнопка)

	Если Модифицированность() Тогда
		Вопрос = НСтр("ru='Для автоматического заполнения макета необходимо записать анкету. Записать?';uk='Для автоматичного заповнення макета необхідно записати анкету. Записати?'");
		Ответ  = Вопрос(Вопрос, РежимДиалогаВопрос.ОКОтмена);

		Если Ответ = КодВозвратаДиалога.ОК Тогда
			ЗаписатьВФорме();
		Иначе
			Возврат;
		КонецЕсли;
	КонецЕсли;

	ЭлементыФормы.ДокументМакет.Очистить();
	СформироватьМакет(ЭлементыФормы.ДокументМакет);
	Модифицированность = Истина;
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// ПРОЦЕДУРЫ - ОБРАБОТЧИКИ СОБЫТИЙ ЭЛЕМЕНТОВ ФОРМЫ

Процедура ЗагружатьОбъектыДоступность()
	
	Если НЕ ЗагружатьОбъекты И НЕ Адресная тогда
		ЭлементыФормы.ВидСправочникаДляЗагрузки.Доступность = Ложь;
		Если ЗначениеЗаполнено(ВидСправочникаДляЗагрузки) тогда
			ВидСправочникаДляЗагрузки = "";
		КонецЕсли;
	Иначе	
		ЭлементыФормы.ВидСправочникаДляЗагрузки.Доступность = Истина;
		Если НЕ ЗначениеЗаполнено(ВидСправочникаДляЗагрузки) тогда
			Если ЕстьФизическиеЛица тогда
				ВидСправочникаДляЗагрузки = Перечисления.ВидыОбъектовЗагружаемыхИзОпроса.ФизическиеЛица;
			ИначеЕсли ЕстьКонтрагенты тогда
				ВидСправочникаДляЗагрузки = Перечисления.ВидыОбъектовЗагружаемыхИзОпроса.Контрагенты;
			ИначеЕсли ЕстьКонтактныеЛица тогда
				ВидСправочникаДляЗагрузки = Перечисления.ВидыОбъектовЗагружаемыхИзОпроса.КонтактныеЛица;
			КонецЕсли;
		КонецЕсли;
	КонецЕсли;
	ЭлементыФормы.ОсновныеДействияФормы.Кнопки.ПросмотрHTML.Доступность = НЕ Адресная;
	
КонецПроцедуры

Процедура ЗагружатьОбъектыПриИзменении(Элемент)
	
	ЗагружатьОбъектыДоступность();

КонецПроцедуры

Процедура РазделыАнкетыПриАктивизацииСтроки(Элемент)
	
	Если Элемент.ТекущаяСтрока <> Неопределено тогда
		ТекущийРаздел = Элемент.ТекущаяСтрока.Ссылка;
		ПервыйВопросРаздела = ЭлементыФормы.ВопросыАнкеты.Значение.Найти(ТекущийРаздел, "Раздел");
		Если ПервыйВопросРаздела <> Неопределено тогда
			Если ЭлементыФормы.ВопросыАнкеты.ТекущаяСтрока.Раздел <> Элемент.ТекущаяСтрока тогда
				Попытка
					ЭлементыФормы.ВопросыАнкеты.ТекущаяСтрока = ПервыйВопросРаздела;
				Исключение
				КонецПопытки
			КонецЕсли;
		КонецЕсли;
		Обновить();
	КонецЕсли;
	
КонецПроцедуры

Процедура ВопросыАнкетыПриВыводеСтроки(Элемент, ОформлениеСтроки, ДанныеСтроки)
	
	ЦветТекущегоРаздела 	= Новый Цвет(-1, -1, -1);
	ЦветНЕТекущегоРаздела 	= ЦветаСтиля.ЦветФонаФормы;
	Если ДанныеСтроки.Раздел = ТекущийРаздел тогда
		ОформлениеСтроки.ЦветФона = ЦветТекущегоРаздела;
	Иначе
		ОформлениеСтроки.ЦветФона = ЦветНЕТекущегоРаздела;
	КонецЕсли;
	
	Если ОформлениеСтроки.ДанныеСтроки.Обязательный = Перечисления.ОбязательностьЗаполненияОтветаНаВопрос.НеОбязателенКЗаполнению тогда
		ОформлениеСтроки.Ячейки.Обязательный.Текст = "";
	ИначеЕсли ОформлениеСтроки.ДанныеСтроки.Обязательный = Перечисления.ОбязательностьЗаполненияОтветаНаВопрос.ОбязателенКЗаполнению тогда
		ОформлениеСтроки.Ячейки.Обязательный.Текст = "О";
	ИначеЕсли ОформлениеСтроки.ДанныеСтроки.Обязательный = Перечисления.ОбязательностьЗаполненияОтветаНаВопрос.УсловноОбязателенКЗаполнению тогда
		ОформлениеСтроки.Ячейки.Обязательный.Текст = "У";
	КонецЕсли;
	
КонецПроцедуры

Процедура ВопросыАнкетыПриАктивизацииСтроки(Элемент)
	Если Элемент.ТекущаяСтрока = Неопределено тогда
		Возврат;
	конецЕсли;
	Если ТекущийРаздел <> Элемент.ТекущаяСтрока.Раздел тогда
		ТекущийРаздел = Элемент.ТекущаяСтрока.Раздел;
		ЭлементыФормы.РазделыАнкеты.ТекущаяСтрока = ТекущийРаздел;
		Обновить();
	КонецЕсли;
	
КонецПроцедуры

Процедура ВопросыАнкетыПередНачаломИзменения(Элемент, Отказ)
	
	Если ЭтоНовый() И Элемент.ТекущаяКолонка.Имя = "Раздел" тогда
		Вопрос = НСтр("ru='Перед выбором раздела необходимо записать анкету. Записать?';uk='Перед вибором розділу необхідно записати анкету. Записати?'");
		Ответ  = Вопрос(Вопрос, РежимДиалогаВопрос.ОКОтмена);

		Если Ответ = КодВозвратаДиалога.ОК Тогда
			Записать();
		Иначе
			Отказ = Истина;
			Возврат;
		КонецЕсли;
	КонецЕсли;
	
	Если ТекущийРаздел <> Элемент.ТекущаяСтрока.Раздел тогда
		Отказ = Истина;
	КонецЕсли;
	
КонецПроцедуры

Процедура СортироватьВопросы(Элемент)
	
	// сделаем правильную сортировку по разделам
	Если Элемент.ТекущаяСтрока = Неопределено тогда
		Возврат;
	КонецЕсли;
	ТаблицаЗначенийВопросов = Элемент.Значение.Выгрузить();
	НомерРедСтроки = Элемент.Значение.Индекс(Элемент.ТекущаяСтрока);
	ТаблицаЗначенийВопросов.Колонки.Добавить("НомерРаздела", 	Новый ОписаниеТипов("Число"));
	ТаблицаЗначенийВопросов.Колонки.Добавить("ИндСтр", 	 		Новый ОписаниеТипов("Число"));
	ТаблицаЗначенийВопросов.Колонки.Добавить("СтрокаТаблицы");
	Для каждого Вопрос из ТаблицаЗначенийВопросов Цикл
		Вопрос.НомерРаздела  = Вопрос.Раздел.Код;
		ИндСтроки            = ТаблицаЗначенийВопросов.Индекс(Вопрос);
		Вопрос.ИндСтр	     = ИндСтроки;
		Вопрос.СтрокаТаблицы = Элемент.Значение[ИндСтроки];
	КонецЦикла;
	
	ТаблицаЗначенийВопросов.Сортировать("НомерРаздела возр, НомерСтроки возр");
	РедактируемаяСтрока	 	= ТаблицаЗначенийВопросов.Найти(НомерРедСтроки, "ИндСтр");
	ИндРедактируемойСтроки 	= ТаблицаЗначенийВопросов.Индекс(РедактируемаяСтрока);
	инд = 0;
	Для каждого СтрокаПослеСортировки из ТаблицаЗначенийВопросов Цикл
		СтарыйИндекс = Элемент.Значение.Индекс(СтрокаПослеСортировки.СтрокаТаблицы);
		НовыйИндекс  = ТаблицаЗначенийВопросов.Индекс(СтрокаПослеСортировки);
		Смещение = НовыйИндекс - СтарыйИндекс;
		Элемент.Значение.Сдвинуть(СтрокаПослеСортировки.СтрокаТаблицы, Смещение);
		инд = инд + 1;
	КонецЦикла;
	Элемент.ТекущаяСтрока = Элемент.Значение[ИндРедактируемойСтроки];
	
КонецПроцедуры

Процедура ВопросыАнкетыПриОкончанииРедактирования(Элемент, НоваяСтрока, ОтменаРедактирования)
	
	СортироватьВопросы(Элемент)
	
КонецПроцедуры

Процедура ВопросыАнкетыПриНачалеРедактирования(Элемент, НоваяСтрока)
	
	Если НоваяСтрока тогда
		Если ЭлементыФормы.РазделыАнкеты.ТекущаяСтрока <> Неопределено тогда
			Элемент.ТекущаяСтрока.Раздел = ЭлементыФормы.РазделыАнкеты.ТекущаяСтрока.Ссылка;
			ТекущийРаздел = ЭлементыФормы.РазделыАнкеты.ТекущаяСтрока.Ссылка;
			Обновить();
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

Процедура РазделыАнкетыПередНачаломДобавления(Элемент, Отказ, Копирование, Родитель, ЭтоГруппа)
	
	Если ЭтоНовый() тогда
		Вопрос = НСтр("ru='Перед вводом раздела необходимо записать анкету. Записать?';uk='Перед введенням розділу необхідно записати анкету. Записати?'");
		Ответ  = Вопрос(Вопрос, РежимДиалогаВопрос.ОКОтмена);

		Если Ответ = КодВозвратаДиалога.ОК Тогда
			Записать();
		Иначе
			Отказ = Истина;
			Возврат;
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

Процедура РазделыАнкетыПриОкончанииРедактирования(Элемент, НоваяСтрока, ОтменаРедактирования)
	
	Если Элемент.ТекущаяСтрока <> Неопределено тогда
		ТекущийРаздел = Элемент.ТекущаяСтрока.Ссылка;
	КонецЕсли;
	СортироватьВопросы(ЭлементыФормы.ВопросыАнкеты);
	
КонецПроцедуры

Процедура ВопросыАнкетыПеретаскивание(Элемент, ПараметрыПеретаскивания, СтандартнаяОбработка, Строка, Колонка)
	
	Если Строка = Неопределено тогда
		СтандартнаяОбработка = Ложь;
		Возврат;
	КонецЕсли;
	ТекущийРаздел = Строка.Раздел;
	Для каждого СтрокаИзЗначения из ПараметрыПеретаскивания.Значение Цикл
		СтрокаИзЗначения.Раздел = ТекущийРаздел;
	КонецЦикла;
	Обновить();
	
КонецПроцедуры

Процедура РазделыАнкетыПроверкаПеретаскивания(Элемент, ПараметрыПеретаскивания, СтандартнаяОбработка, Строка, Колонка)
	
	ПараметрыПеретаскивания.Действие = ДействиеПеретаскивания.Выбор;
	ПараметрыПеретаскивания.ДопустимыеДействия = ДопустимыеДействияПеретаскивания.НеОбрабатывать;
	СтандартнаяОбработка = Ложь;
	
КонецПроцедуры

Процедура РазделыАнкетыПеретаскивание(Элемент, ПараметрыПеретаскивания, СтандартнаяОбработка, Строка, Колонка)
	
	Если Строка <> Неопределено и ПараметрыПеретаскивания.Значение <> Неопределено тогда
		Для каждого СтрокаИзЗначения из ПараметрыПеретаскивания.Значение Цикл
			СтрокаИзЗначения.Раздел = Строка.Ссылка;
		КонецЦикла;
	КонецЕсли;
	СортироватьВопросы(ЭлементыФормы.ВопросыАнкеты);
	
КонецПроцедуры

Процедура УдалитьРаздел(УдаляемыйЭлемент)
	
		ВопросРаздела 		= ВопросыАнкеты.Найти(УдаляемыйЭлемент, "Раздел");
		Если ВопросРаздела <> Неопределено тогда
			Вопрос 			= "Вы уверены, что хотите удалить раздел """ + Строка(УдаляемыйЭлемент) + """, включая его вопросы?";
			Ответ  			= Вопрос(Вопрос, РежимДиалогаВопрос.ОКОтмена, , КодВозвратаДиалога.Отмена);
			Если Ответ = КодВозвратаДиалога.ОК Тогда
				СтруктураПоиска = Новый Структура("Раздел");
				СтруктураПоиска.Раздел 	= УдаляемыйЭлемент;
				МассивУдаляемыхСтрок 	= ВопросыАнкеты.НайтиСтроки(СтруктураПоиска);
				Для каждого УдаляемаяСтрока из МассивУдаляемыхСтрок Цикл
					ВопросыАнкеты.Удалить(УдаляемаяСтрока);
				КонецЦикла;
				Если Ответ = КодВозвратаДиалога.ОК Тогда
					УдаляемыйЭлемент.ПолучитьОбъект().Удалить();
				КонецЕсли;
			КонецЕсли;
		Иначе
			Вопрос = "Вы уверены, что хотите удалить раздел """ + Строка(УдаляемыйЭлемент) + """?";
			Ответ  = Вопрос(Вопрос, РежимДиалогаВопрос.ОКОтмена, , КодВозвратаДиалога.Отмена);
			Если Ответ = КодВозвратаДиалога.ОК Тогда
				УдаляемыйЭлемент.ПолучитьОбъект().Удалить();
			КонецЕсли;
		КонецЕсли;
		
КонецПроцедуры
	
Процедура РазделыАнкетыПередУстановкойПометкиУдаления(Элемент, Отказ)
	
	Отказ = Истина;
	Если Элемент.ТекущаяСтрока <> Неопределено тогда
		УдаляемыйЭлемент	= Элемент.ТекущаяСтрока.Ссылка;
		УдалитьРаздел(УдаляемыйЭлемент);
	КонецЕсли;
	
КонецПроцедуры

Процедура КоманднаяПанель1УдалитьРаздел(Кнопка)
	
	Если ЭлементыФормы.РазделыАнкеты.ТекущаяСтрока <> Неопределено тогда
		УдаляемыйЭлемент	= ЭлементыФормы.РазделыАнкеты.ТекущаяСтрока.Ссылка;
		УдалитьРаздел(УдаляемыйЭлемент);
	КонецЕсли;
	
КонецПроцедуры

Процедура ВопросыАнкетыВыбор(Элемент, ВыбраннаяСтрока, Колонка, СтандартнаяОбработка)
	
	Если Колонка = Элемент.Колонки.Обязательный тогда
		ФормаОбязательногоВопроса 				 = ПолучитьФорму("ФормаОбязательногоВопроса");
		ФормаОбязательногоВопроса.Анкета		 = ЭтотОбъект;
		ФормаОбязательногоВопроса.ВопросИсходный = ВыбраннаяСтрока.Вопрос;
		ФормаОбязательногоВопроса.ВопросУсловия  = ВыбраннаяСтрока.ВопросУсловия;
		ФормаОбязательногоВопроса.УсловиеОтвета  = ВыбраннаяСтрока.УсловиеОтвета;
		ФормаОбязательногоВопроса.Ответ		     = ВыбраннаяСтрока.ОтветУсловия;
		ФормаОбязательногоВопроса.Обязательный   = ВыбраннаяСтрока.Обязательный;
		МассивВопросов = Элемент.Значение.ВыгрузитьКолонку("Вопрос");
		МассивВопросов.Удалить(ВыбраннаяСтрока.НомерСтроки - 1); // удаляем текущий вопрос из списка
		ФормаОбязательногоВопроса.СписокВопросовДляВыбора.ЗагрузитьЗначения(МассивВопросов);
		РезультатФормы = ФормаОбязательногоВопроса.ОткрытьМодально();
		Если РезультатФормы = "ОК" тогда
			ВыбраннаяСтрока.Вопрос 			= ФормаОбязательногоВопроса.ВопросИсходный;
			ВыбраннаяСтрока.ВопросУсловия 	= ФормаОбязательногоВопроса.ВопросУсловия;
			ВыбраннаяСтрока.УсловиеОтвета 	= ФормаОбязательногоВопроса.ЭлементыФормы.УсловиеОтвета.Значение;
			ВыбраннаяСтрока.ОтветУсловия 	= ФормаОбязательногоВопроса.Ответ;
			ВыбраннаяСтрока.Обязательный 	= ФормаОбязательногоВопроса.Обязательный;
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// ОПЕРАТОРЫ ОСНОВНОЙ ПРОГРАММЫ

//СписокИдентифицирующихВопросов = Новый СписокЗначений;
//СписокИдентифицирующихВопросов.Добавить(ПланыВидовХарактеристик.ВопросыДляАнкетирования.ДатаРождения);
//СписокИдентифицирующихВопросов.Добавить(ПланыВидовХарактеристик.ВопросыДляАнкетирования.Отчество);
//СписокИдентифицирующихВопросов.Добавить(ПланыВидовХарактеристик.ВопросыДляАнкетирования.Имя);
//СписокИдентифицирующихВопросов.Добавить(ПланыВидовХарактеристик.ВопросыДляАнкетирования.Фамилия);
//СписокИдентифицирующихВопросов.Добавить(ПланыВидовХарактеристик.ВопросыДляАнкетирования.ИНН);

Попытка
	ЕстьФизическиеЛица = Перечисления.ВидыОбъектовЗагружаемыхИзОпроса.ФизическиеЛица = Перечисления.ВидыОбъектовЗагружаемыхИзОпроса.ФизическиеЛица;
Исключение
	ЕстьФизическиеЛица = Ложь;
КонецПопытки;

Попытка
	ЕстьКонтрагенты = Перечисления.ВидыОбъектовЗагружаемыхИзОпроса.Контрагенты = Перечисления.ВидыОбъектовЗагружаемыхИзОпроса.Контрагенты;
Исключение
	ЕстьКонтрагенты = Ложь;
КонецПопытки;

Попытка
	ЕстьКонтактныеЛица = Перечисления.ВидыОбъектовЗагружаемыхИзОпроса.КонтактныеЛица = Перечисления.ВидыОбъектовЗагружаемыхИзОпроса.КонтактныеЛица;
Исключение
	ЕстьКонтактныеЛица = Ложь;
КонецПопытки;
