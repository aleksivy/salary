////////////////////////////////////////////////////////////////////////////////
// ПЕРЕМЕННЫЕ МОДУЛЯ


////////////////////////////////////////////////////////////////////////////////
// ПРОЦЕДУРЫ И ФУНКЦИИ ОБЩЕГО НАЗНАЧЕНИЯ

// Процедура назначает форму отчета по умолчанию при изменении периода 
// представления отчета.
//   При отсутствии формы, соответствующей выбранному периоду, по умолчанию 
// выдаем текущую (действующую) форму.
//
// Вызывается из других процедур модуля.
//
Процедура ВыборФормыПоУмолчанию()
	
	Для Каждого Строка Из мТаблицаФормОтчета Цикл
		Если (Строка.ДатаНачалоДействия > КонецДня(мДатаКонцаПериодаОтчета)) ИЛИ
			((Строка.ДатаКонецДействия > '00010101000000') И (Строка.ДатаКонецДействия < НачалоДня(мДатаКонцаПериодаОтчета))) Тогда

			Продолжить;
		КонецЕсли;

		мВыбраннаяФорма = Строка.ФормаОтчета;
		ЭлементыФормы.ОписаниеНормативДок.Значение = Строка.ОписаниеОтчета;

		Возврат;
	КонецЦикла;

	// Если не удалось найти форму, соответствующую выбранному периоду,
	// то по умолчанию выдаем текущую (действующую) форму.
	Если мВыбраннаяФорма = Неопределено Тогда
		мВыбраннаяФорма = мТаблицаФормОтчета[0].ФормаОтчета;
		ЭлементыФормы.ОписаниеНормативДок.Значение = мТаблицаФормОтчета[0].ОписаниеОтчета;
	КонецЕсли;
	
КонецПроцедуры // ВыборФормыПоУмолчанию()

// Процедура управляет показом в форме периода построения отчета.
//
Процедура ПоказатьПериод()

	СтрПериодОтчета = ПредставлениеПериода( НачалоДня(мДатаНачалаПериодаОтчета), КонецДня(мДатаКонцаПериодаОтчета), "ФП = Истина; Л="+Локализация.КодЯзыкаИнтерфейса());
	
	// Покажем период в диалоге
	//ЭлементыФормы.ПериодСоставленияОтчета.Значение = мДатаНачалаПериодаОтчета;
    ЭлементыФормы.НадписьПериодСоставленияОтчета.Заголовок = СтрПериодОтчета;
	
	ВыборФормыПоУмолчанию();

КонецПроцедуры // ПоказатьПериод()

// Процедура устанавливает границы периода построения отчета.
//
// Параметры:
//  Шаг          - число, количество стандартных периодов, на которое необходимо
//                 сдвигать период построения отчета;
//
Процедура ИзменитьПериод(Шаг)

	Если Периодичность = Перечисления.Периодичность.Месяц Тогда
		мДатаКонцаПериодаОтчета  = КонецМесяца(ДобавитьМесяц(мДатаКонцаПериодаОтчета, Шаг));
		мДатаНачалаПериодаОтчета = НачалоМесяца(мДатаКонцаПериодаОтчета); 
	ИначеЕсли Периодичность = Перечисления.Периодичность.Квартал Тогда
		мДатаКонцаПериодаОтчета  = КонецКвартала(ДобавитьМесяц(мДатаКонцаПериодаОтчета, Шаг*3));
		мДатаНачалаПериодаОтчета = НачалоКвартала(мДатаКонцаПериодаОтчета);
	ИначеЕсли Периодичность = Перечисления.Периодичность.Год Тогда
		мДатаКонцаПериодаОтчета  = КонецГода(ДобавитьМесяц(мДатаКонцаПериодаОтчета, Шаг*12));
		мДатаНачалаПериодаОтчета = НачалоГода(мДатаКонцаПериодаОтчета);	
	ИначеЕсли Периодичность      = Перечисления.Периодичность.День Тогда
		мДатаКонцаПериодаОтчета  = КонецДня(мДатаКонцаПериодаОтчета + Шаг * 24 * 60 * 60);
		мДатаНачалаПериодаОтчета = мДатаКонцаПериодаОтчета;
	КонецЕсли;

	ПоказатьПериод();

КонецПроцедуры // ИзменитьПериод()

Функция КоличествоФормСоответствтвующихВыбранномуПериоду()
	// позволяем выбирать форму за любой период, по-умолчанию форма подбирается верная, но жесткий запрет на выбор формы не всегда уместен
	Возврат 99;
	
	ИтоговоеКоличество = 0;
	Для Каждого ЭлФорма Из мТаблицаФормОтчета Цикл
		ДатаКонца = ?(ЭлФорма.ДатаКонецДействия = ОбщегоНазначения.ПустоеЗначениеТипа(Тип("Дата")), '20291231',ЭлФорма.ДатаКонецДействия);
		Если (ЭлФорма.ДатаНачалоДействия >= мДатаНачалаПериодаОтчета И ЭлФорма.ДатаНачалоДействия <= мДатаКонцаПериодаОтчета) ИЛИ
			 (ДатаКонца  >= мДатаНачалаПериодаОтчета И ДатаКонца  <= мДатаКонцаПериодаОтчета)
			 Или (ДатаКонца  >= мДатаКонцаПериодаОтчета  И ЭлФорма.ДатаНачалоДействия <= мДатаНачалаПериодаОтчета) Тогда
			 ИтоговоеКоличество = ИтоговоеКоличество + 1; 
		КонецЕсли;
	КонецЦикла;
	Возврат ИтоговоеКоличество;
КонецФункции



////////////////////////////////////////////////////////////////////////////////
// ПРОЦЕДУРЫ - ОБРАБОТЧИКИ СОБЫТИЙ ФОРМЫ

// Процедура - обработчик события "ПередОткрытием" формы.
//
Процедура ПередОткрытием(Отказ, СтандартнаяОбработка)
	
	РегламентированнаяОтчетность.ПередОткрытиемОсновнойФормыРегламентиованногоОтчета(ЭтаФорма, Отказ, СтандартнаяОбработка);
	
	ЭтаФорма.АвтоЗаголовок = Ложь;

	Если ВладелецФормы <> Неопределено Тогда
		Если Не ВладелецФормы.ЭтоНовый() Тогда

			// При восстановлении сохраненных данных сразу открываем
			// нужную форму отчета, минуя основную форму.
			Отказ = Истина;

			мСохраненныйДок = ВладелецФормы.ДокументОбъект;

			// определяем границы периода построения отчета
			мДатаНачалаПериодаОтчета = мСохраненныйДок.ДатаНачала;
			мДатаКонцаПериодаОтчета  = мСохраненныйДок.ДатаОкончания;

			// по реквизиту ВыбраннаяФорма документа определяем,
			// какую форму следует открыть
			ВыбраннаяФорма = ВладелецФормы.ВыбраннаяФорма;

			Если ЭтотОбъект.Метаданные().Формы.Найти(СокрП(ВыбраннаяФорма)) <> Неопределено Тогда
				ВыбФормаОтчета = ПолучитьФорму(СокрП(ВыбраннаяФорма));
			Иначе
				// Если не удалось найти форму с таким названием (могла быть переименована),
				// то по умолчанию выдаем текущую (действующую) форму
				ВыбраннаяФорма = мТаблицаФормОтчета[0].ФормаОтчета;
				ВыбФормаОтчета = ПолучитьФорму(ВыбраннаяФорма);
			КонецЕсли;

			мВыбраннаяФорма = ВыбраннаяФорма;

			ВыбФормаОтчета.РежимВыбора = Ложь;
			ВыбФормаОтчета.Открыть();
            РегламентированнаяОтчетность.ДобавитьНадписьВнешнийОтчет(ВыбФормаОтчета);
			
		ИначеЕсли ВладелецФормы.мСкопированаФорма <> Неопределено Тогда
			// Новый документ РегламентированныйОтчет был получен
			// методом копирования имеющегося.
			// Переменной мСохраненныйДок присвоим текущий документ
			мСохраненныйДок   = ВладелецФормы.ДокументОбъект;
			мСкопированаФорма = ВладелецФормы.мСкопированаФорма;
		КонецЕсли;
	КонецЕсли;

КонецПроцедуры // ПередОткрытием()

// Процедура - обработчик события "ПриОткрытии" формы.
//
Процедура ПриОткрытии()

	Если мСохраненныйДок <> Неопределено Тогда
		Если ВладелецФормы.мСкопированаФорма <> Неопределено Тогда
			// для скопированного отчета период представления
			// определяем по реквизиту документа - объекта копирования
			Периодичность = мСохраненныйДок.Периодичность;
		КонецЕсли;
	КонецЕсли;
	
	Если Не ЗначениеЗаполнено(Периодичность) Тогда
		Периодичность = Перечисления.Периодичность.Год;	
	КонецЕсли;
	
	Если Организация = Справочники.Организации.ПустаяСсылка() Тогда
		ОргПоУмолчанию = УправлениеПользователями.ПолучитьЗначениеПоУмолчанию(глЗначениеПеременной("глТекущийПользователь"), "ОсновнаяОрганизация");
		Если ЗначениеЗаполнено(ОргПоУмолчанию) Тогда
			Организация = ОргПоУмолчанию;
		КонецЕсли;
	КонецЕсли;

	Если Периодичность = Перечисления.Периодичность.Год Тогда
		// Устанваливаем границы периода построения как год, предшествующий текущему
		мДатаКонцаПериодаОтчета  = КонецГода(ДобавитьМесяц(КонецГода(РабочаяДата), -12));
		мДатаНачалаПериодаОтчета = НачалоГода(мДатаКонцаПериодаОтчета);
	ИначеЕсли Периодичность = Перечисления.Периодичность.Квартал Тогда
		// Устанваливаем границы периода построения как квартал, предшествующий текущему
		мДатаКонцаПериодаОтчета  = КонецКвартала(ДобавитьМесяц(КонецКвартала(РабочаяДата), -3));
		мДатаНачалаПериодаОтчета = НачалоКвартала(мДатаКонцаПериодаОтчета);
	ИначеЕсли Периодичность = Перечисления.Периодичность.Месяц Тогда
		// Устанваливаем границы периода построения как месяц, предшествующий текущему
		мДатаКонцаПериодаОтчета  = КонецМесяца(ДобавитьМесяц(КонецМесяца(РабочаяДата), -1));
		мДатаНачалаПериодаОтчета = НачалоМесяца(мДатаКонцаПериодаОтчета);
	Иначе
		мДатаКонцаПериодаОтчета  = КонецДня(РабочаяДата);
		мДатаНачалаПериодаОтчета = мДатаКонцаПериодаОтчета;
	КонецЕсли;

	ПоказатьПериод();

	Если НЕ мТаблицаФормОтчета.Количество() > 1 Тогда
		ЭлементыФормы.КнопкаВыбораФормы.Доступность = Ложь;
	КонецЕсли;
	Если Не КоличествоФормСоответствтвующихВыбранномуПериоду() > 1 Тогда
		ЭлементыФормы.КнопкаВыбораФормы.Доступность = Ложь;
	Иначе
		ЭлементыФормы.КнопкаВыбораФормы.Доступность = Истина;
	КонецЕсли;


КонецПроцедуры // ПриОткрытии()

// Процедура - обработчик события "ПередЗакрытием" формы.
//
Процедура ПередЗакрытием(Отказ, СтандартнаяОбработка)

	// здесь отключаем стандартную обработку ПередЗакрытием формы
	// для подавления выдачи запроса на сохранение формы.
	СтандартнаяОбработка = Ложь;

КонецПроцедуры // ПередЗакрытием()

////////////////////////////////////////////////////////////////////////////////
// ПРОЦЕДУРЫ - ОБРАБОТЧИКИ СОБЫТИЙ ЭЛЕМЕНТОВ ФОРМЫ

// Процедура вызывается по нажатию кнопки "ОК" формы.
//   Инициализирует открытие нужной формы документа.
//
Процедура ОсновныеДействияФормыОК(Кнопка)

	Попытка
		// В не актуальных конфигурациях данной функции может не быть 
		Если Не РегламентированнаяОтчетность.ПроверитьВозможностьОткрытияДочернейФормыРегламентиованногоОтчета(ЭтаФорма) Тогда
			Возврат;
		КонецЕсли;
	Исключение
	КонецПопытки;
	
	Если мСкопированаФорма <> Неопределено Тогда
		// Документ был скопиран. 
		// Проверяем соответствие форм.
		Если мВыбраннаяФорма <> мСкопированаФорма Тогда

			Если Вопрос(НСтр("ru='Форма отчета изменилась, копирование данных не выполняется."
"Продолжить?';uk='Форма звіту змінилася, копіювання даних не виконується."
"Продовжити?'"), РежимДиалогаВопрос.ДаНет,,КодВозвратаДиалога.Да) = КодВозвратаДиалога.Нет Тогда

				ЭтаФорма.Закрыть();
				Возврат;
			КонецЕсли;

			// очищаем данные скопированного отчета
			мСохраненныйДок = Неопределено;
			мСкопированаФорма = Неопределено;

		КонецЕсли;
	КонецЕсли;

	// устанавливаем дату представления отчета как рабочая дата
	ДатаПодписи                = РабочаяДата;

	ВыбФормаОтчета             = ПолучитьФорму(мВыбраннаяФорма);
	
	РегламентированнаяОтчетность.ДобавитьНадписьВнешнийОтчет(ВыбФормаОтчета);
	
	ВыбФормаОтчета.РежимВыбора = Ложь;
	ЭтаФорма.Закрыть();
	
	ВыбФормаОтчета.Организация = Организация ;
	ВыбФормаОтчета.Открыть();
	РегламентированнаяОтчетность.ДобавитьНадписьВнешнийОтчет(ВыбФормаОтчета);
	
	ВыбФормаОтчета.Модифицированность = Истина;

КонецПроцедуры // ОсновныеДействияФормыОК()

// Процедура вызывается по нажатию кнопки "<" формы.
//   Инициализирует изменение переиода построения отчета.
//
Процедура КнопкаПредыдущийПериодНажатие(Элемент)

	// Бухгалтерская отчетность составляется помесячно
	ИзменитьПериод(-1);
	Если Не КоличествоФормСоответствтвующихВыбранномуПериоду() > 1 Тогда
		ЭлементыФормы.КнопкаВыбораФормы.Доступность = Ложь;
	Иначе
		ЭлементыФормы.КнопкаВыбораФормы.Доступность = Истина;
	КонецЕсли;

КонецПроцедуры // КнопкаПредыдущийПериодНажатие()

// Процедура вызывается по нажатию кнопки ">" формы.
//   Инициализирует изменение переиода построения отчета.
//
Процедура КнопкаСледующийПериодНажатие(Элемент)

	// Бухгалтерская отчетность составляется помесячно
	ИзменитьПериод(1);
    Если Не КоличествоФормСоответствтвующихВыбранномуПериоду() > 1 Тогда
		ЭлементыФормы.КнопкаВыбораФормы.Доступность = Ложь;
	Иначе
		ЭлементыФормы.КнопкаВыбораФормы.Доступность = Истина;
	КонецЕсли;
КонецПроцедуры // КнопкаСледующийПериодНажатие()

// Процедура вызывается по нажатию кнопки "..." формы.
//   Инициализирует выбор из списка требуемой формы отчета.
//
Процедура КнопкаВыбораФормыНажатие(Элемент)

	ТаблицаВыбораФормы = мТаблицаФормОтчета.Скопировать();
	ТаблицаВыбораФормы.Колонки.Удалить("ФормаОтчета");

	ИсхИндекс = 0;
	ИсхСтрока = мТаблицаФормОтчета.Найти(мВыбраннаяФорма, "ФормаОтчета");
	Если Не ИсхСтрока = Неопределено Тогда
		ИсхИндекс = мТаблицаФормОтчета.Индекс(ИсхСтрока);
	КонецЕсли;

	СтрокаТаблВыбора = ТаблицаВыбораФормы[ИсхИндекс];
	ВыбСтрока = ТаблицаВыбораФормы.ВыбратьСтроку(НСтр("ru='Выберите форму отчета';uk='Виберіть форму звіту'"), СтрокаТаблВыбора);

	Если Не ВыбСтрока = Неопределено Тогда
		ВыбИндекс = ТаблицаВыбораФормы.Индекс(ВыбСтрока);
		ВыбСтрока = мТаблицаФормОтчета[ВыбИндекс];

		мВыбраннаяФорма = ВыбСтрока.ФормаОтчета;
		ЭлементыФормы.ОписаниеНормативДок.Значение = ВыбСтрока.ОписаниеОтчета;
	КонецЕсли;

КонецПроцедуры // КнопкаВыбораФормыНажатие()


// Процедура обработчика НачалоВыбора 
Процедура ОрганизацияНачалоВыбораИзСписка(Элемент, СтандартнаяОбработка)
	СтандартнаяОбработка = Ложь;
	Запрос = Новый Запрос("ВЫБРАТЬ РАЗРЕШЕННЫЕ
	                      |	Организации.Ссылка
	                      |ИЗ
	                      |	Справочник.Организации КАК Организации
	                      |
	                      |УПОРЯДОЧИТЬ ПО
	                      |	Организации.Наименование");
	СписокОрганизаций = Новый СписокЗначений;
	СписокОрганизаций.ЗагрузитьЗначения(Запрос.Выполнить().Выгрузить(ОбходРезультатаЗапроса.Прямой).ВыгрузитьКолонку("Ссылка"));
	РезультатВыбора = ВыбратьИзСписка(СписокОрганизаций, Элемент, ?(НЕ ЗначениеЗаполнено(Организация), Неопределено, СписокОрганизаций.НайтиПоЗначению(Организация)));
	Если РезультатВыбора <> Неопределено Тогда
		Организация = РезультатВыбора.Значение;
		// Флаг мФильтрОбособ действует только в рамках одной организации, связан с формой
		// выбора организации из списка. При перевоборе организации, флаг очищаем в Неопределено.
		мФильтрОбособ = Неопределено;
	КонецЕсли;

КонецПроцедуры


////////////////////////////////////////////////////////////////////////////////
// РАЗДЕЛ ОСНОВНОЙ ПРОГРАММЫ
