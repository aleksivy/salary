﻿////////////////////////////////////////////////////////////////////////////////
// ПРОЦЕДУРЫ И ФУНКЦИИ ОБЩЕГО НАЗНАЧЕНИЯ

// Процедура назначает форму отчета по умолчанию 
//   при изменении периода представления отчета.
// При отсутствии формы, соответствующей выбранному 
//   периоду, по умолчанию выдаем текущую (действующую) форму.
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
	ЭлементыФормы.НадписьПериодСоставленияОтчета.Заголовок = СтрПериодОтчета;
	
	ЭлементыФормы.ОписаниеНормативДок.Значение = "";
	
	ВыборФормыПоУмолчанию();
	
	КоличествоФорм = КоличествоФормСоответствтвующихВыбранномуПериоду();
	
	ЭлементыФормы.КнопкаВыбораФормы.Доступность 			  = КоличествоФорм > 1;
	ЭлементыФормы.ОсновныеДействияФормы.Кнопки.ОК.Доступность = КоличествоФорм > 0;

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
		
		мДатаКонцаПериодаОтчета  = КонецКвартала(ДобавитьМесяц(мДатаКонцаПериодаОтчета, Шаг*12));
		мДатаНачалаПериодаОтчета = НачалоГода(мДатаКонцаПериодаОтчета);
		
	КонецЕсли;

	ПоказатьПериод();

КонецПроцедуры // ИзменитьПериод()

// Функция определяет количество форм, подходящих выбранному периоду
//
Функция КоличествоФормСоответствтвующихВыбранномуПериоду()
	// позволяем выбирать форму за любой период, по-умолчанию форма подбирается верная, но жесткий запрет на выбор формы не всегда уместен
	Возврат 99;
	
	ИтоговоеКоличество = 0;
	
	Для Каждого ЭлФорма Из мТаблицаФормОтчета Цикл
		
		ДатаКонца = ?(ЭлФорма.ДатаКонецДействия = ОбщегоНазначения.ПустоеЗначениеТипа(Тип("Дата")), '20291231',ЭлФорма.ДатаКонецДействия);
		Если  НачалоДня(ЭлФорма.ДатаНачалоДействия) <= НачалоДня(мДатаКонцаПериодаОтчета)
			И НачалоДня(ЭлФорма.ДатаКонецДействия) = '00010101' ИЛИ НачалоДня(ЭлФорма.ДатаКонецДействия) >= НачалоДня(мДатаКонцаПериодаОтчета) Тогда
			
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
	
	Если Не Отказ Тогда
		
	 	Если мЗаписьЗапрещена <> Истина Тогда
			// Открывается встроенный/зарегистрированный внешний отчет
			ТекстВопроса = НСтр("ru = 'Формирование отчета поддерживается только для ""FREDO Звіт""
								 //|
								 //|Настройка заполнения отчета выполняется в форме ""Настройка ""FREDO Звіт"""". 
								 //|Там же находится справка по заполнению данного отчета
								 |';uk = '
								 |Формування звіту підтримується тільки для ""FREDO Звіт""
								 //|
								 //|Налаштування заповнення звіту виконується у формі ""Налаштування ""FREDO Звіт"""".
								 //|Та же знаходиться довідка щодо заповнення даного звіту
								 |'");
			СписокКнопок = Новый СписокЗначений;
			//СписокКнопок.Добавить("Настройка",  НСтр("ru = 'Открыть форму настройки...'; uk = 'Відкрити форму налаштування...'"));
			СписокКнопок.Добавить(КодВозвратаДиалога.Отмена);
			Ответ = Вопрос(ТекстВопроса, СписокКнопок, ,КодВозвратаДиалога.Отмена, ЭтаФорма.Заголовок);
			Если Ответ = "Настройка" Тогда
				// Используем актуальный менеджер, учетем возможности поставки менеджера в виде внешней обработки
				// Выведем причины невозможности использования FREDO Звіт, в случае если менеджер не инициализирован
				Если глПодключитьМенеджерЗвит1С() Тогда
					
					ФормаНастройки = глМенеджерЗвит1С.ОткрытьФормуНастроекЗвит1С();
					
					Если ТипЗнч(ФормаНастройки) = Тип("Форма") Тогда
						ФормаНастройки.АвтивироватьНастройку(Метаданные().Имя);
					КонецЕсли;
					
				КонецЕсли;
			КонецЕсли;
		КонецЕсли;
		
		Если    глМенеджерЗвит1С = Неопределено 
			ИЛИ НЕ глМенеджерЗвит1С.ФлагОтладки = Истина Тогда
			Отказ = Истина;		
		КонецЕсли;
		
	КонецЕсли;

КонецПроцедуры // ПередОткрытием()

// Процедура - обработчик события "ПриОткрытии" формы.
//
Процедура ПриОткрытии()

	Периодичность = Перечисления.Периодичность.Год;
	
	Если мСохраненныйДок <> Неопределено Тогда
		Если ВладелецФормы.мСкопированаФорма <> Неопределено Тогда
			// для скопированного отчета период представления
			// определяем по реквизиту документа - объекта копирования
			Периодичность = мСохраненныйДок.Периодичность;
		КонецЕсли;
	КонецЕсли;
    
	// Устанваливаем границы периода построения как месяц, предшествующий текущему
	Если Периодичность = Перечисления.Периодичность.Год Тогда
		мДатаКонцаПериодаОтчета  = КонецГода(ДобавитьМесяц(РабочаяДата, -12));
		мДатаНачалаПериодаОтчета = НачалоГода(мДатаКонцаПериодаОтчета);
	ИначеЕсли Периодичность = Перечисления.Периодичность.Месяц Тогда
		мДатаКонцаПериодаОтчета  = КонецМесяца(ДобавитьМесяц(РабочаяДата, -1));
		мДатаНачалаПериодаОтчета = НачалоМесяца(мДатаКонцаПериодаОтчета);
	ИначеЕсли Периодичность = Перечисления.Периодичность.Квартал Тогда
		мДатаКонцаПериодаОтчета  = КонецКвартала(ДобавитьМесяц(РабочаяДата, -1));
		мДатаНачалаПериодаОтчета = НачалоКвартала(мДатаКонцаПериодаОтчета);
	КонецЕсли;		
		
	Если Организация = Справочники.Организации.ПустаяСсылка() Тогда
		ОргПоУмолчанию = УправлениеПользователями.ПолучитьЗначениеПоУмолчанию(глЗначениеПеременной("глТекущийПользователь"), "ОсновнаяОрганизация");
		Если ЗначениеЗаполнено(ОргПоУмолчанию) Тогда
			Организация = ОргПоУмолчанию;
		КонецЕсли;
	КонецЕсли;
	
	ПоказатьПериод();

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
"Продовжити?'"), РежимДиалогаВопрос.ДаНет,30,КодВозвратаДиалога.Да) = КодВозвратаДиалога.Нет Тогда

				ЭтаФорма.Закрыть();
				Возврат;
			КонецЕсли;

			// очищаем данные скопированного отчета
			СписокСохранения = Новый Структура();
			ХранилищеДанных  = Новый ХранилищеЗначения(СписокСохранения);
			мСохраненныйДок.ДанныеОтчета    = ХранилищеДанных;

		КонецЕсли;
	КонецЕсли;

	// устанавливаем дату представления отчета как рабочая дата
	ДатаПодписи                = РабочаяДата;

	ВыбФормаОтчета             = ПолучитьФорму(мВыбраннаяФорма);
	ВыбФормаОтчета.РежимВыбора = Ложь;

	ЭтаФорма.Закрыть();
    ВыбФормаОтчета.Организация= Организация;
	ВыбФормаОтчета.Открыть();
	РегламентированнаяОтчетность.ДобавитьНадписьВнешнийОтчет(ВыбФормаОтчета);

	ВыбФормаОтчета.Модифицированность = Истина;
	
КонецПроцедуры // ОсновныеДействияФормыОК()

// Процедура вызывается по нажатию кнопки "<" формы.
//   Инициализирует изменение переиода построения отчета.
//
Процедура КнопкаПредыдущийПериодНажатие(Элемент)

	ИзменитьПериод(-1);

КонецПроцедуры // КнопкаПредыдущийПериодНажатие()

// Процедура вызывается по нажатию кнопки ">" формы.
//   Инициализирует изменение переиода построения отчета.
//
Процедура КнопкаСледующийПериодНажатие(Элемент)

	ИзменитьПериод(1);

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

//Обработчик события ОрганизацияНачалоВыбораИзСписка
//
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
	
КонецПроцедуры // ОрганизацияНачалоВыбораИзСписка
