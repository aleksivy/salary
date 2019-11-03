﻿#Если Клиент Тогда
////////////////////////////////////////////////////////////////////////////////
// ПЕРЕМЕННЫЕ МОДУЛЯ

// Все возможные показатели
Перем мТаблицаПоказатели Экспорт; 

// Настройка периода
Перем НП Экспорт;

Перем мСоответствиеНазначений Экспорт; // Соответствия, содержащая назначения свойств и категорий именам

Перем мСтруктураДляОтбораПоКатегориям Экспорт; // содержит связь отборов текста запроса Построителя и значений категорий

Перем мСтруктураСвязиПоказателейИИзмерений Экспорт; // содержит связь показателей и измерений

Перем СтруктураФорматаПолей Экспорт;

Перем мМассивШиринКолонок Экспорт;

Перем мИсходныйМакетОтчета; // исходный макет, используемый для отчета. По умолчанию "Макет", но может быть переопределен

Перем мНазваниеОтчета Экспорт;

Перем мВыбиратьИмяРегистра Экспорт;

Перем мРежимВводаПериода Экспорт;

Перем мВыбиратьИспользованиеСвойств Экспорт;

////////////////////////////////////////////////////////////////////////////////
// ПРОЦЕДУРЫ И ФУНКЦИИ 
// 

Процедура Транспонировать() Экспорт

	ПолеСерии = Неопределено;
	Если ПостроительОтчета.ИзмеренияСтроки.Количество() = 1 Тогда
		ПолеСерии = ПостроительОтчета.ИзмеренияСтроки[0];
	КонецЕсли;
	
	ПолеТочки = Неопределено;
	Если ПостроительОтчета.ИзмеренияКолонки.Количество()=1 Тогда
		ПолеТочки = ПостроительОтчета.ИзмеренияКолонки[0];
	КонецЕсли;
	
	Если ПолеСерии<>Неопределено Тогда
		ПутьКДаннымСерии = ПолеСерии.ПутьКДанным;
		ПостроительОтчета.ИзмеренияСтроки.Удалить(ПолеСерии);
		ПостроительОтчета.ИзмеренияКолонки.Добавить(ПутьКДаннымСерии);
	КонецЕсли;
	Если ПолеТочки<>Неопределено Тогда
		ПутьКДаннымТочки = ПолеТочки.ПутьКДанным;
		ПостроительОтчета.ИзмеренияКолонки.Удалить(ПолеТочки);
		ПостроительОтчета.ИзмеренияСтроки.Добавить(ПутьКДаннымТочки);
	КонецЕсли;

КонецПроцедуры


// Выполняет настройку отчета по умолчанию для заданного регистра накопления.
//
// Параметры: 
//	ИмяРегистра   - строка, имя регистра накопления
// 
Процедура ЗаполнитьНачальныеНастройки() Экспорт

	мТаблицаПоказатели.Очистить();

	СтруктураПредставлениеПолей = Новый Структура;

	мСоответствиеНазначений = Новый Соответствие;

	МассивОтбора = Новый Массив;

	Показатели.Очистить();

	//Очистим отбор
	Пока ПостроительОтчета.Отбор.Количество()>0 Цикл
		ПостроительОтчета.Отбор.Удалить(0);
	КонецЦикла; 

	Если ПустаяСтрока(ИмяРегистра) Тогда 
		Возврат 
	КонецЕсли;

	УправлениеОтчетами.ЗаполнитьНачальныеНастройкиПоМетаданнымРегистра(СтруктураПредставлениеПолей, МассивОтбора, ЭтотОбъект, "Диаграмма");

	УправлениеОтчетами.ЗаполнитьПредставленияПолей(СтруктураПредставлениеПолей, ПостроительОтчета);
	УправлениеОтчетами.ОчиститьДополнительныеПоляПостроителя(ПостроительОтчета);
	УправлениеОтчетами.ЗаполнитьОтбор(МассивОтбора, ПостроительОтчета);
	
КонецПроцедуры // ЗаполнитьНачальныеНастройки()


Процедура ЗаполнитьПоляОсновногоРеквизита(УниверсальныйОтчет) Экспорт
	РеквизитыЭтогоОбъекта = ЭтотОбъект.Метаданные().Реквизиты;
	Для каждого Реквизит из РеквизитыЭтогоОбъекта Цикл
		ЭтотОбъект[Реквизит.Имя] = УниверсальныйОтчет[Реквизит.Имя];
	КонецЦикла;
	СтруктураФорматаПолей.Вставить("Период", "ДЛФ=D");
	
	// Все возможные показатели
	мТаблицаПоказатели = УниверсальныйОтчет.мТаблицаПоказатели; 
	
	// Настройка периода
	НП = УниверсальныйОтчет.НП;
	
	// Соответствия, содержащая назначения свойств и категорий именам
	мСоответствиеНазначений = УниверсальныйОтчет.мСоответствиеНазначений;
	
	мСтруктураСвязиПоказателейИИзмерений = УниверсальныйОтчет.мСтруктураСвязиПоказателейИИзмерений; // содержит связь показателей и измерений
	
	мМассивШиринКолонок = УниверсальныйОтчет.мМассивШиринКолонок; // массив ширин колонок табличного документа для сохранения между формированиями отчета
	
	мНазваниеОтчета  = УниверсальныйОтчет.мНазваниеОтчета; // название отчета
	
	мВыбиратьИмяРегистра  = УниверсальныйОтчет.мВыбиратьИмяРегистра; // признак выбора (изменения) имени регистра (вида отчета)
	
	мВыбиратьИспользованиеСвойств = УниверсальныйОтчет.мВыбиратьИспользованиеСвойств; // признак выбора (изменения) флажка использования свойств и категорий
	
	мРежимВводаПериода = УниверсальныйОтчет.мРежимВводаПериода;
	
	СтруктураФорматаПолей  = УниверсальныйОтчет.СтруктураФорматаПолей; // хранит формат полей примитивных типов
	
	мСтруктураДляОтбораПоКатегориям  = УниверсальныйОтчет.мСтруктураДляОтбораПоКатегориям; // предназначена для связи отборов Построителя с категориями из соединяемых таблиц
	
	УниверсальныйОтчет = ЭтотОбъект;

КонецПРоцедуры

Процедура ЗаполнитьПоказатели(ИмяПоля, ПредставлениеПоля, ВклПоУмолчанию, ФорматнаяСтрока) Экспорт

	//СтруктураПредставлениеПолей.Вставить(ИмяПоля, ПредставлениеПоля);

	// Показатели заносятся в специальную таблицу и добавляются в список
	СтрПоказатели = мТаблицаПоказатели.Добавить();
	СтрПоказатели.ИмяПоля           = ИмяПоля;
	СтрПоказатели.ПредставлениеПоля = ПредставлениеПоля;
	//СтрПоказатели.ВклПоУмолчанию    = ВклПоУмолчанию;
	СтрПоказатели.ФорматнаяСтрока   = ФорматнаяСтрока;
	Если Показатели.Найти(ИмяПоля) = Неопределено Тогда
		НовыйПоказатель = Показатели.Добавить();
		НовыйПоказатель.Имя = ИмяПоля;
		НовыйПоказатель.Представление = ПредставлениеПоля;
		НовыйПоказатель.Использование    = ВклПоУмолчанию;
	КонецЕсли;
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// ПРОЦЕДУРЫ И ФУНКЦИИ ФОРМИРОВАНИЯ ОТЧЕТА 
// 

// Выполняет запрос и формирует табличный документ-результат отчета
// в соответствии с настройками, заданными значениями реквизитов отчета.
//
// Параметры:
//	ДокументРезультат - табличный документ, формируемый отчетом,
//	ЕстьОшибки - флаг того, что при формировании произошли ошибки
//
//Процедура СформироватьОтчет(ДокументРезультат, ЕстьОшибки = Ложь) Экспорт
Процедура СформироватьОтчет(Диаграмма, ЕстьОшибки = Ложь)	Экспорт

    // Проверка на пустые значения
	Если ПустаяСтрока(ИмяРегистра) Тогда
		Предупреждение(НСтр("ru='Не определен запрос отчета!';uk='Не визначений запит звіту!'"));
		
		ЕстьОшибки = Истина;
		Возврат;
	КонецЕсли;

	Если ДатаНач > ДатаКон И ДатаКон <> '00010101000000' Тогда
		Предупреждение(НСтр("ru='Дата начала периода не может быть больше даты конца периода';uk='Дата початку періоду не може бути більше дати кінця періоду'"));
		ЕстьОшибки = Истина;
		Возврат;
	КонецЕсли;
	
	Если НЕ УправлениеОтчетами.ЗадатьПараметрыОтбораПоКатегориям(ПостроительОтчета, мСтруктураДляОтбораПоКатегориям) Тогда
		Предупреждение(НСтр("ru='По одной категории нельзя устанавливать несколько отборов';uk='По одній категорії не можна встановлювати кілька відборів'"));
		ЕстьОшибки = Истина;
		Возврат;
	КонецЕсли;
	
	Если ПостроительОтчета.ИзмеренияСтроки.Количество()= 0 Тогда
		Предупреждение(НСтр("ru='Не выбраны серии диаграммы!';uk='Не вибрані серії діаграми!'"));
		Возврат;
	КонецЕсли;

	ИмяВыводимогоПоказателя = мТаблицаПоказатели[НомерПоказателя].ИмяПоля;

	//Если (мНазваниеОтчета = "Дебиторская задолженность") ИЛИ (мНазваниеОтчета = "Кредиторская задолженность") Тогда
	//	ПостроительОтчета.Параметры.Вставить("ДатаКон", ?(НЕ ЗначениеЗаполнено(ДатаКон), ДатаКон, НачалоДня(ДатаКон + 60*60*24)));
	//Иначе
	//	ПостроительОтчета.Параметры.Вставить("ДатаКон", НачалоДня(ДатаКон + 60*60*24));
	//КонецЕсли;
	//	
	
	ПостроительОтчета.Параметры.Вставить("ДатаНач", ДатаНач);

	Если ДатаКон <> '00010101000000' Тогда
		Если мРежимВводаПериода = 1 Тогда
			ПостроительОтчета.Параметры.Вставить("ДатаКон", НачалоДня(ДатаКон + 60*60*24));
		Иначе
			ПостроительОтчета.Параметры.Вставить("ДатаКон", КонецДня(ДатаКон ));
		КонецЕсли;
	Иначе
		ПостроительОтчета.Параметры.Вставить("ДатаКон", '00010101000000');
	КонецЕсли;

	// Макет по умолчанию может быть переопределен
	Если мИсходныйМакетОтчета = Неопределено Тогда

		МакетОтчета = ПолучитьМакет("Макет");

	Иначе

		МакетОтчета = мИсходныйМакетОтчета;

	КонецЕсли; 

	// Оформление измерений
	//МассивОформлениеИзмерений = Новый Массив;
	ОформлениеДетальныхЗаписей = Неопределено;

	КоличествоКолонок = 6;

	Периодичность=Неопределено;
	Если ПостроительОтчета.ИзмеренияСтроки.Найти("ПериодГод")<>Неопределено 
		ИЛИ ПостроительОтчета.ИзмеренияКолонки.Найти("ПериодГод")<>Неопределено Тогда
		Периодичность = 9;
	КонецЕсли; 
	Если ПостроительОтчета.ИзмеренияСтроки.Найти("ПериодПолугодие")<>Неопределено 
		ИЛИ ПостроительОтчета.ИзмеренияКолонки.Найти("ПериодПолугодие")<>Неопределено Тогда
		Периодичность = 8;
	КонецЕсли; 
	Если ПостроительОтчета.ИзмеренияСтроки.Найти("ПериодКвартал")<>Неопределено 
		ИЛИ ПостроительОтчета.ИзмеренияКолонки.Найти("ПериодКвартал")<>Неопределено Тогда
		Периодичность = 7;
	КонецЕсли; 
	Если ПостроительОтчета.ИзмеренияСтроки.Найти("ПериодМесяц")<>Неопределено 
		ИЛИ ПостроительОтчета.ИзмеренияКолонки.Найти("ПериодМесяц")<>Неопределено Тогда
		Периодичность = 6;
	КонецЕсли; 
	Если ПостроительОтчета.ИзмеренияСтроки.Найти("ПериодДекада")<>Неопределено 
		ИЛИ ПостроительОтчета.ИзмеренияКолонки.Найти("ПериодДекада")<>Неопределено Тогда
		Периодичность = 5;
	КонецЕсли; 
	Если ПостроительОтчета.ИзмеренияСтроки.Найти("ПериодНеделя")<>Неопределено 
		ИЛИ ПостроительОтчета.ИзмеренияКолонки.Найти("ПериодНеделя")<>Неопределено Тогда
		Периодичность = 4;
	КонецЕсли; 
	Если ПостроительОтчета.ИзмеренияСтроки.Найти("ПериодДень")<>Неопределено 
		ИЛИ ПостроительОтчета.ИзмеренияКолонки.Найти("ПериодДень")<>Неопределено Тогда
		Периодичность = 3;
	КонецЕсли; 

	Если ПостроительОтчета.ВыбранныеПоля.Найти("Регистратор")<>Неопределено Тогда
		Периодичность = 2;
	КонецЕсли; 

	НайденаПериодичность=Ложь;

	Для Инд = 0 По ПостроительОтчета.Отбор.Количество()-1 Цикл

		ПолеОтбора = ПостроительОтчета.Отбор[Инд];

		Если Найти(ПолеОтбора.Представление, "Периодичность")>0 Тогда
			НайденаПериодичность=Истина;
			Прервать;
		КонецЕсли;

	КонецЦикла;

	Если Периодичность<>Неопределено Тогда
		Если Не НайденаПериодичность Тогда
			ПолеОтбора = ПостроительОтчета.Отбор.Добавить("Периодичность");

		Иначе

			ПостроительОтчета.Отбор.Удалить(ПостроительОтчета.Отбор.Индекс(ПолеОтбора));

			ПолеОтбора = ПостроительОтчета.Отбор.Добавить("Периодичность");
			
		КонецЕсли; 

		ПолеОтбора.Значение = Периодичность;
		ПолеОтбора.Использование = (Периодичность<>Неопределено);
	КонецЕсли;

	// Расшифровки
	ПостроительОтчета.ЗаполнениеРасшифровки = ВидЗаполненияРасшифровкиПостроителяОтчета.Расшифровка;

	Заголовок = мНазваниеОтчета;
	
	//Добавим показатели в выбранные поля
	ИмяПоказателя = мТаблицаПоказатели[НомерПоказателя].ИмяПоля;
	
	Попытка
		УправлениеОтчетами.ОбработкаПоказателейДобавитьВВыбранныеПоля(ИмяПоказателя, ПостроительОтчета);
	Исключение
	КонецПопытки;

	УправлениеОтчетами.ПроверитьПорядокПостроителяОтчета(ПостроительОтчета);

    // Вывод в макет
	ПостроительОтчета.Выполнить();

	Диаграмма.Очистить();

	Диаграмма.Обновление = Ложь;

	ПостроительОтчета.Вывести(Диаграмма, ИмяВыводимогоПоказателя);
	
	КоличествоСерий = Диаграмма.КоличествоСерий;
	
	Если КоличествоСерий>8 Тогда
		// Цвета, используемые для серий
		ЦветаСерий = ПолучитьМакет("Макет").ПолучитьОбласть("ЦветаСерий");
		МассивЦветовСерий = Новый Массив;
		Для Сч = 1 По ЦветаСерий.ВысотаТаблицы Цикл
			МассивЦветовСерий.Добавить(ЦветаСерий.Область(Сч, 2).ЦветФона);
		КонецЦикла;
	КонецЕсли;
	
	// Форматирование полей
	ФорматнаяСтрокаСерии = "";
	СтруктураФорматаПолей.Свойство(ПостроительОтчета.ИзмеренияСтроки[0].Имя, ФорматнаяСтрокаСерии);
	
	ЕстьТочки = (ПостроительОтчета.ИзмеренияКолонки.Количество()>0);
	
	Если ЕстьТочки Тогда
		
		ФорматнаяСтрокаТочки = "";
		СтруктураФорматаПолей.Свойство(ПостроительОтчета.ИзмеренияКолонки[0].Имя, ФорматнаяСтрокаТочки);
		
	КонецЕсли; 
	
	Если ПостроительОтчета.ИзмеренияСтроки.Количество()> 0 Тогда
		
		Инд = 0;
		Для каждого Серия Из Диаграмма.Серии Цикл
			
			Серия.Текст = Формат(Серия.Расшифровка[ПостроительОтчета.ИзмеренияСтроки[0].Имя], ФорматнаяСтрокаСерии);
			
			Если Серия.Текст = "" Тогда
				Серия.Текст = "<...>";
			КонецЕсли;
			
			Если КоличествоСерий>8 И НЕ Серия.СводнаяСерия Тогда
				
				// Цвета измерений
				Серия.Цвет = МассивЦветовСерий[ Инд - Цел(Инд/МассивЦветовСерий.Количество())* МассивЦветовСерий.Количество()];
				
			КонецЕсли;

			Инд = Инд+1;
			
		КонецЦикла; 
	КонецЕсли;
	
	КоличествоТочек = 0;
	
	Если ПостроительОтчета.ИзмеренияКолонки.Количество()> 0 Тогда
		Для каждого Точка Из Диаграмма.Точки Цикл
			
			Точка.Текст = Формат(Точка.Расшифровка[ПостроительОтчета.ИзмеренияКолонки[0].Имя], ФорматнаяСтрокаТочки);
			
			КоличествоТочек = КоличествоТочек + 1;
			
		КонецЦикла; 
		
	Иначе
		
		Если Диаграмма.Точки.Количество()=1 Тогда 
			Диаграмма.Точки[0].Текст = мТаблицаПоказатели[НомерПоказателя].ПредставлениеПоля;
		КонецЕсли;
		
	КонецЕсли;
	
	Диаграмма.Обновление = Истина;

КонецПроцедуры // СформироватьОтчет()

// Расшифровывает отчеты, реализуемые при помощи данного
//
// Параметры:
//	Расшифровка           - Структура, значение расшифровки, взятое из табличного документа, и, в случае надобности, дополненное
//	СтандартнаяОбраьотка  - Флаг стандартной обработки расшифровки
//	ЭтотОтчет             - Контекст, из которого происходит вызов. Позволяет определить, как именно расшифровывать.
//
Процедура ОбработкаРасшифровкиСтандартногоОтчета(Расшифровка, СтандартнаяОбработка, ЭтотОтчет) Экспорт
	
	Если ТипЗнч(Расшифровка) = Тип("Структура") Тогда
		СтандартнаяОбработка = Ложь;

		СписокВыбора = Новый СписокЗначений;

		ДоступныеИзмерения = Новый Соответствие;

		Для ДП = 0 По ПостроительОтчета.ДоступныеПоля.Количество() - 1 Цикл
			Поле = ПостроительОтчета.ДоступныеПоля[ДП];
			Если Поле.Измерение Тогда
				ДоступныеИзмерения.Вставить(Поле.Имя, Поле.Представление);
			КонецЕсли;
		КонецЦикла;

		Для УИ = 0 По ПостроительОтчета.ИзмеренияСтроки.Количество() - 1 Цикл
			Измерение = ПостроительОтчета.ИзмеренияСтроки[УИ];
			ДоступныеИзмерения.Удалить(Измерение.Имя);
		КонецЦикла;

		Для УИ = 0 По ПостроительОтчета.ИзмеренияКолонки.Количество() - 1 Цикл
			Измерение = ПостроительОтчета.ИзмеренияКолонки[УИ];
			ДоступныеИзмерения.Удалить(Измерение.Имя);
		КонецЦикла;

		ИмяДобавляемогоИзмерения = "";
		ПредставлениеДобавляемогоИзмерения = "";
		Если ДоступныеИзмерения.Количество() > 0 Тогда
			Для Каждого ДИ ИЗ ДоступныеИзмерения Цикл
				СписокВыбора.Добавить(ДИ.Ключ, ДИ.Значение);
				ИмяДобавляемогоИзмерения = ДИ.Ключ;
				ПредставлениеДобавляемогоИзмерения = ДИ.Значение;
			КонецЦикла;
		КонецЕсли;

		СписокВыбора.СортироватьПоПредставлению();
 

		// Расшифровка по регистратору, если его еще нет
		Если ПостроительОтчета.ДоступныеПоля.Найти("Регистратор")<>Неопределено Тогда

			Если ПостроительОтчета.ВыбранныеПоля.Найти("Регистратор")=Неопределено Тогда

				СписокВыбора.Добавить(0, "По документам движения");

			КонецЕсли; 

		КонецЕсли;

		Если СписокВыбора.Количество()>0 Тогда

			Выбор = СписокВыбора.ВыбратьЭлемент(НСтр("ru='Выберите способ расшифровки';uk='Виберіть спосіб розшифровки'"), СписокВыбора[СписокВыбора.Количество()-1]);

		Иначе

			Выбор = Неопределено;

		КонецЕсли; 

		Если Выбор = Неопределено Тогда
			Возврат;
		КонецЕсли;
		
		Параметры = Новый Соответствие;
		
		Для каждого ЭлементРасш Из Расшифровка Цикл
			Параметры.Вставить(ЭлементРасш.Ключ, ЭлементРасш.Значение);
		КонецЦикла;
		
		Если Выбор.Значение = 0 Тогда
			
			ИмяОтчетаДляРасшифровкиПоДокументам="";
			Расшифровка.Свойство("ИмяОтчетаДляРасшифровкиПоДокументам", ИмяОтчетаДляРасшифровкиПоДокументам);
			
			Если ЗначениеЗаполнено(ИмяОтчетаДляРасшифровкиПоДокументам) Тогда
				Отчет = Отчеты[ИмяОтчетаДляРасшифровкиПоДокументам].Создать();
			Иначе
				Отчет = Отчеты.ОтчетСписокКроссТаблица.Создать();
			КонецЕсли;
			
			Параметры.Вставить("ИмяРегистра", ИмяРегистра);
			Параметры.Вставить("ДатаНач", ДатаНач);
			Параметры.Вставить("ДатаКон", ДатаКон);
			
			ИсходныйОтчет = ЭтотОтчет;
			
			// Это свойство влияет на заполнение
			Параметры.Вставить("ИспользоватьСвойстваИКатегории", ИспользоватьСвойстваИКатегории);
			
			ИмяПоказателя = мТаблицаПоказатели[НомерПоказателя].ИмяПоля;
			
			ТабПоказатели = Показатели.Выгрузить();
			
			Для Каждого СтрокаПоказателя ИЗ ТабПоказатели Цикл
				СтрокаПоказателя.Использование = (СтрокаПоказателя.Имя = ИмяПоказателя);
			КонецЦикла;
			
			Параметры.Вставить("Показатели", ТабПоказатели);
			
			Отчет.Настроить(Параметры);
			
		Иначе
			
			Отчет = Отчеты[ЭтотОтчет.Метаданные().Имя].Создать();
			//Отчет.ОбщийОтчет.мНазваниеОтчета = мНазваниеОтчета;
			
			// Настройка отчета
			
			Параметры.Вставить("ИмяРегистра", ИмяРегистра);
			Параметры.Вставить("ДатаНач", ДатаНач);
			Параметры.Вставить("ДатаКон", ДатаКон);
			
			ИсходныйОтчет = ЭтотОтчет;
			
			// Это свойство влияет на заполнение
			Параметры.Вставить("ИспользоватьСвойстваИКатегории", ИспользоватьСвойстваИКатегории);
			
			Параметры.Вставить("ТипДиаграммыОтчета", ТипДиаграммыОтчета);
			
			Если (Выбор.Значение = "ПериодДень" 
					ИЛИ Выбор.Значение = "ПериодНеделя" 
					ИЛИ Выбор.Значение = "ПериодДекада"
					ИЛИ Выбор.Значение = "ПериодМесяц" 
					ИЛИ Выбор.Значение = "ПериодКвартал" 
					ИЛИ Выбор.Значение = "ПериодГод") Тогда
					
					Если ТипДиаграммыОтчета = ТипДиаграммы.Круговая
						ИЛИ ТипДиаграммыОтчета = ТипДиаграммы.Гистограмма 
						ИЛИ ТипДиаграммыОтчета = ТипДиаграммы.ГистограммаСНакоплением 
						ИЛИ ТипДиаграммыОтчета = ТипДиаграммы.ГистограммаГоризонтальная 
						ИЛИ ТипДиаграммыОтчета = ТипДиаграммы.ГистограммаСНакоплениемГоризонтальная Тогда
						
						Параметры.Вставить("ТипДиаграммыОтчета", ТипДиаграммы.Гистограмма);
						
					ИначеЕсли ТипДиаграммыОтчета = ТипДиаграммы.КруговаяОбъемная
						ИЛИ ТипДиаграммыОтчета = ТипДиаграммы.ГистограммаОбъемная 
						ИЛИ ТипДиаграммыОтчета = ТипДиаграммы.ГистограммаСНакоплениемОбъемная 
						ИЛИ ТипДиаграммыОтчета = ТипДиаграммы.ГистограммаГоризонтальнаяОбъемная 
						ИЛИ ТипДиаграммыОтчета = ТипДиаграммы.ГистограммаСНакоплениемГоризонтальнаяОбъемная
						ИЛИ ТипДиаграммыОтчета = ТипДиаграммы.Изометрическая Тогда
						
						Параметры.Вставить("ТипДиаграммыОтчета", ТипДиаграммы.ГистограммаОбъемная);
						
					Иначе
						Параметры.Вставить("ТипДиаграммыОтчета", ТипДиаграммы.График);
					КонецЕсли;
					
					//Отчет.ПостроительОтчета.ИзмеренияСтроки.Очистить();
					//Отчет.ПостроительОтчета.ИзмеренияСтроки.Добавить(ПостроительОтчета.ИзмеренияСтроки[0].ПутьКДанным);
					//Отчет.ПостроительОтчета.ИзмеренияКолонки.Очистить();
					//Отчет.ПостроительОтчета.ИзмеренияКолонки.Добавить(Выбор.Значение);
			КонецЕсли;
			
			
			Параметры.Вставить("НомерПоказателя", НомерПоказателя);
			Параметры.Вставить("МаксимумСерийКоличество", МаксимумСерийКоличество);
			Параметры.Вставить("МаксимумСерийПроцент", МаксимумСерийПроцент);
			Параметры.Вставить("ВидПодписейККруговойДиаграмме", ВидПодписейККруговойДиаграмме);
			Параметры.Вставить("Свет", Свет);
			Параметры.Вставить("Окантовка", Окантовка);
			Параметры.Вставить("Градиент", Градиент);
			Параметры.Вставить("ОриентацияИзометрическойДиаграммы", ОриентацияИзометрическойДиаграммы);
			Параметры.Вставить("РежимПробеловДиаграммыСОбластями", РежимПробеловДиаграммыСОбластями);
			Параметры.Вставить("БазовоеЗначение", БазовоеЗначение);
			Параметры.Вставить("РаздвижениеСерийКруговойДиаграммы", РаздвижениеСерийКруговойДиаграммы);
			Параметры.Вставить("ВертикальныеМетки", ВертикальныеМетки);
			Параметры.Вставить("ОтображатьЛегенду", ОтображатьЛегенду);
			Параметры.Вставить("ОтображатьЗаголовок", ОтображатьЗаголовок);
			Параметры.Вставить("ОграничениеСерий", ОграничениеСерий);
			
			// Переносимые свойства
			
			// Перенос табличной части
			Параметры.Вставить("Показатели", Показатели.Выгрузить());
			
			Отчет.Настроить(Параметры);
		
		КонецЕсли;
		
		Форма = Отчет.ПолучитьОсновнуюФорму();

		ПостроительОтчета.НастроитьРасшифровку(Отчет.ПолучитьПостроительОтчета(), Расшифровка);

		// Добавим измерения из расшифровываемого отчета
		МассивДобавленныеИзмерения = Новый Массив;

		ТабОтбор = Новый ТаблицаЗначений;
		ТабОтбор.Колонки.Добавить("Имя");
		ТабОтбор.Колонки.Добавить("ВидСравнения");
		ТабОтбор.Колонки.Добавить("Значение");

		Для каждого Элемент Из Отчет.ПолучитьПостроительОтчета().Отбор Цикл

			Если Элемент.Использование Тогда

				НоваяСтрока = ТабОтбор.Добавить();
				НоваяСтрока.Имя = Элемент.Имя;
				НоваяСтрока.ВидСравнения = Элемент.ВидСравнения;
				НоваяСтрока.Значение = Элемент.Значение;

			КонецЕсли;

		КонецЦикла; 

		Для Инд=0 По ПостроительОтчета.ИзмеренияСтроки.Количество()-1 Цикл

			СтруктураПоиска = Новый Структура;
			СтруктураПоиска.Вставить("Имя",ПостроительОтчета.ИзмеренияСтроки[Инд].Имя);

			НайденныеСтрокиОтбора = ТабОтбор.НайтиСтроки(СтруктураПоиска);

			// Измерение не нужно добавлять, если в нем заведомо будет один элемент
			НеДобавлятьИзмерение = Ложь;

			Для каждого НайденныйЭлементОтбора Из НайденныеСтрокиОтбора Цикл

				// Не добавляем измерения по отборам на равенство - в них будет один элемент
				Если НайденныйЭлементОтбора.ВидСравнения = ВидСравнения.Равно Тогда

					НеДобавлятьИзмерение = Истина;
					Прервать;

					// Не добавляем измерения по отборам на вхождение в иерархию одного элемента справочника 
					// или плана видов характеристик - в них будет один элемент
				ИначеЕсли НайденныйЭлементОтбора.ВидСравнения = ВидСравнения.ВСпискеПоИерархии
					ИЛИ НайденныйЭлементОтбора.ВидСравнения = ВидСравнения.ВСписке Тогда

					Если НайденныйЭлементОтбора.Значение.Количество() = 1 Тогда
						ЗначениеОтбора = НайденныйЭлементОтбора.Значение[0].Значение;

						МетаданныеОбъекта = Метаданные.НайтиПоТипу(ТипЗнч(ЗначениеОтбора));

						Если МетаданныеОбъекта<>Неопределено Тогда
							Если Метаданные.Справочники.Найти(МетаданныеОбъекта)<>Неопределено 
								ИЛИ Метаданные.ПланыВидовХарактеристик.Найти(МетаданныеОбъекта)<>Неопределено  Тогда

								Если НЕ ЗначениеОтбора.ЭтоГруппа Тогда

									НеДобавлятьИзмерение = Истина;
									Прервать;

								КонецЕсли; 
							КонецЕсли; 
						КонецЕсли; 

					КонецЕсли;
				КонецЕсли;

			КонецЦикла;

			Если НеДобавлятьИзмерение Тогда

				// Удалим также и предыдущие измерения
				Для каждого ПредыдущееИзмерение Из МассивДобавленныеИзмерения Цикл

					Отчет.ПолучитьПостроительОтчета().ИзмеренияСтроки.Удалить(ПредыдущееИзмерение);

				КонецЦикла;

				Продолжить;

			КонецЕсли;

			// Добавляем новое измерение и запоминаем его в массиве
			МассивДобавленныеИзмерения.Добавить(Отчет.ПолучитьПостроительОтчета().ИзмеренияСтроки.Добавить(ПостроительОтчета.ИзмеренияСтроки[Инд].ПутьКДанным,
			ПостроительОтчета.ИзмеренияСтроки[Инд].Имя,
			ПостроительОтчета.ИзмеренияСтроки[Инд].ТипИзмерения));
		КонецЦикла;

		Для Инд=0 По ПостроительОтчета.ИзмеренияКолонки.Количество()-1 Цикл
			Отчет.ПолучитьПостроительОтчета().ИзмеренияКолонки.Добавить(ПостроительОтчета.ИзмеренияКолонки[Инд].ПутьКДанным,
			ПостроительОтчета.ИзмеренияКолонки[Инд].Имя,
			ПостроительОтчета.ИзмеренияКолонки[Инд].ТипИзмерения)
		КонецЦикла;

//		Форма.Открыть();
		
		// Текущий отчет с детальными записями по документам
		Если Выбор.Значение = 0 Тогда
			Отчет.ПолучитьПостроительОтчета().ИзмеренияКолонки.Очистить();

			Отчет.ПолучитьПостроительОтчета().ВыбранныеПоля.Добавить("Регистратор");
			Форма.ОбновитьОтчет();

		Иначе

			// Текущий отчет с дополнительным измерением

			//Отчет.ПолучитьПостроительОтчета().ИзмеренияСтроки.Очистить();
			Отчет.ПолучитьПостроительОтчета().ИзмеренияСтроки.Добавить(Выбор.Значение, Выбор.Значение);

			Форма.ОбновитьОтчет();
		КонецЕсли;
		Форма.Открыть();
	КонецЕсли;
	
КонецПроцедуры

// Настраивает отчет для параметрического вызова
//
// Параметры
//  СтруктураПараметров  – Структура, Соответсвие – содержит список параметров:
//	ДатаНач,
//	ДатаКон,
//	ИмяРегистра,
Процедура Настроить(СтруктураПараметров, ЗаполняемыйОбъект = Неопределено) Экспорт
	
	Параметры = Новый Соответствие;
	
	Для каждого Элемент Из СтруктураПараметров Цикл
		Параметры.Вставить(Элемент.Ключ, Элемент.Значение);
	КонецЦикла; 

	ДатаНач = Параметры["ДатаНач"];
	ДатаКон = Параметры["ДатаКон"];
	
	// Это свойство влияет на заполнение
	ИспользоватьСвойстваИКатегории    = Параметры["ИспользоватьСвойстваИКатегории"];
	
	ТипДиаграммыОтчета = Параметры["ТипДиаграммыОтчета"];
	НомерПоказателя    = Параметры["НомерПоказателя"];
	МаксимумСерийКоличество = Параметры["МаксимумСерийКоличество"];
	ВидПодписейККруговойДиаграмме = Параметры["ВидПодписейККруговойДиаграмме"];
	МаксимумСерийПроцент = Параметры["МаксимумСерийПроцент"];
	Свет = Параметры["Свет"];
	Окантовка = Параметры["Окантовка"];
	Градиент = Параметры["Градиент"];
	ОриентацияИзометрическойДиаграммы = Параметры["ОриентацияИзометрическойДиаграммы"];
	РежимПробеловДиаграммыСОбластями = Параметры["РежимПробеловДиаграммыСОбластями"];
	БазовоеЗначение = Параметры["БазовоеЗначение"];
	РаздвижениеСерийКруговойДиаграммы = Параметры["РаздвижениеСерийКруговойДиаграммы"];
	ВертикальныеМетки = Параметры["ВертикальныеМетки"];
	ОтображатьЛегенду = Параметры["ОтображатьЛегенду"];
	ОтображатьЗаголовок = Параметры["ОтображатьЗаголовок"];
	ОграничениеСерий = Параметры["ОграничениеСерий"];
	
	ИмяРегистра = Параметры["ИмяРегистра"];
	Если ЗаполняемыйОбъект = Неопределено Тогда
		ЗаполняемыйОбъект = ЭтотОбъект;
	КонецЕсли;
	
	Если Параметры["ЗаполнитьПоУмолчанию"] = Истина Тогда
		
		// Настраиваем по умолчанию
		ЗаполняемыйОбъект.ЗаполнитьНачальныеНастройки();
		
	Иначе
		
		ЗаполняемыйОбъект.ЗаполнитьНачальныеНастройки();
		
		ПостроительОтчета.ИзмеренияСтроки.Очистить();
		ПостроительОтчета.ИзмеренияКолонки.Очистить();
		ПостроительОтчета.ВыбранныеПоля.Очистить();

		Пока ПостроительОтчета.Отбор.Количество()>0 Цикл
			ПостроительОтчета.Отбор.Удалить(0);
		КонецЦикла; 
		
		// Группировки строк
		
		ГруппировкиСтрок = Параметры["ГруппировкиСтрок"];
		Если ТипЗнч(ГруппировкиСтрок) = Тип("Соответствие")
			ИЛИ ТипЗнч(ГруппировкиСтрок) = Тип("Структура") Тогда
			
			ПостроительОтчета.ИзмеренияСтроки.Очистить();
			
			Для каждого Строка Из ГруппировкиСтрок Цикл
				
				ПостроительОтчета.ИзмеренияСтроки.Добавить(Строка.Ключ);
				
			КонецЦикла; 
			
		КонецЕсли;
		
		// Группировки колонок
		
		ГруппировкиКолонок = Параметры["ГруппировкиКолонок"];
		Если ТипЗнч(ГруппировкиКолонок) = Тип("Соответствие")
			ИЛИ ТипЗнч(ГруппировкиКолонок) = Тип("Структура") Тогда
			
			ПостроительОтчета.ИзмеренияКолонки.Очистить();
			
			Для каждого Строка Из ГруппировкиКолонок Цикл
				
				ПостроительОтчета.ИзмеренияКолонки.Добавить(Строка.Ключ);
				
			КонецЦикла; 
			
		КонецЕсли;
		
		// Показатели: флажки использования
		
		ТаблицаПоказатели = Параметры["Показатели"];
		Если ТипЗнч(ТаблицаПоказатели) = Тип("ТаблицаЗначений") 
			И ТаблицаПоказатели.Колонки.Найти("Имя")<>Неопределено
			И ТаблицаПоказатели.Колонки.Найти("Использование")<>Неопределено Тогда
			
			Для Каждого Строка Из Показатели Цикл
				
				НайдСтрока = ТаблицаПоказатели.Найти(Строка.Имя, "Имя");
				Если НайдСтрока<>Неопределено Тогда
					Строка.Использование = НайдСтрока.Использование;
				КонецЕсли;
				
			КонецЦикла; 
			
		КонецЕсли;
		
		
	КонецЕсли;
	
	// Отбор, заданный списком
	
	СтрокиОтбора = Параметры["Отбор"];
	
	Если ТипЗнч(СтрокиОтбора) = Тип("Соответствие")
		ИЛИ ТипЗнч(СтрокиОтбора) = Тип("Структура") Тогда
		
		Пока ПостроительОтчета.Отбор.Количество()>0 Цикл
			ПостроительОтчета.Отбор.Удалить(0);
		КонецЦикла; 

		Для каждого Строка Из СтрокиОтбора Цикл
			
			ЭлементОтбора = Неопределено;
			
			// Установим существующие элементы, добавим новые
			Для Инд = 0 По ПостроительОтчета.Отбор.Количество()-1 Цикл
				
				Если Строка.Ключ = ПостроительОтчета.Отбор[Инд].ПутьКДанным Тогда
					ЭлементОтбора = ПостроительОтчета.Отбор[Инд];
				КонецЕсли;
				
			КонецЦикла; 
			
			Если ЭлементОтбора = Неопределено Тогда
				
				ЭлементОтбора = ПостроительОтчета.Отбор.Добавить(Строка.Ключ);
				
			КонецЕсли; 
			ЭлементОтбора.Установить(Строка.Значение);
			
		КонецЦикла;
	КонецЕсли;
	
КонецПроцедуры

// Читает свойство Построитель отчета
//
// Параметры
//	Нет
//
Функция ПолучитьПостроительОтчета() Экспорт

	Возврат ПостроительОтчета;

КонецФункции // ПолучитьПостроительОтчета()

// Возвращает основную форму отчета
//
// Параметры
//  Нет.
//
// Возвращаемое значение:
//   основная форма отчета
//
Функция ПолучитьОсновнуюФорму() Экспорт

	Возврат ПолучитьФорму();

КонецФункции // ПолучитьОсновнуюФорму()

// Получает диаграмму в печатном виде
//
// Параметры:
//	Нет.
//
Процедура ПолучитьДиаграммуНаПечать(ДокументРезультат) Экспорт
	
	Если ТипЗнч(ДокументРезультат) <> Тип("ТабличныйДокумент") Тогда
		ДокументРезультат = Новый ТабличныйДокумент;
	КонецЕсли;
	
	ДокументРезультат.Очистить();
	ДокументРезультат.Вывести(ПолучитьМакет("Макет").ПолучитьОбласть("ОбластьДиаграммы"));

	ДокументРезультат.Рисунки.Диаграмма.Объект.ТипДиаграммы = ТипДиаграммыОтчета;
	
	Диаграмма = ДокументРезультат.Рисунки.Диаграмма.Объект;
	
	Если ВидПодписейККруговойДиаграмме<>Неопределено Тогда
		Диаграмма.ВидПодписей = ВидПодписейККруговойДиаграмме;
	КонецЕсли;
	
	Если РаздвижениеСерийКруговойДиаграммы<>Неопределено Тогда
		Диаграмма.АвтоРаздвижениеСерий = РаздвижениеСерийКруговойДиаграммы;
	КонецЕсли; 
	
	Диаграмма.Свет = Свет;
	Диаграмма.Окантовка = Окантовка;
	Диаграмма.Градиент = Градиент;
	
	Если ОриентацияИзометрическойДиаграммы <> Неопределено Тогда
		Диаграмма.Ориентация = ОриентацияИзометрическойДиаграммы;
	КонецЕсли;
	
	Если РежимПробеловДиаграммыСОбластями <> Неопределено Тогда
		Диаграмма.РежимПробелов = РежимПробеловДиаграммыСОбластями;
	КонецЕсли;
	
	Если ОграничениеСерий<>Неопределено Тогда
		Диаграмма.МаксимумСерий = ОграничениеСерий;
	КонецЕсли;
	
	Диаграмма.МаксимумСерийКоличество = МаксимумСерийКоличество;
	Диаграмма.МаксимумСерийПроцент = МаксимумСерийПроцент;

	ВыводимыйПоказатель = "";
	Если НомерПоказателя<мТаблицаПоказатели.Количество() Тогда
		ВыводимыйПоказатель = мТаблицаПоказатели[НомерПоказателя].ПредставлениеПоля;
	КонецЕсли;
	
	Диаграмма.ОбластьПостроения.ВертикальныеМетки = ВертикальныеМетки;

	Диаграмма.ОбластьЗаголовка.Текст = мНазваниеОтчета + ": " + ВыводимыйПоказатель;
	
	Диаграмма.БазовоеЗначение = БазовоеЗначение;
	
	Диаграмма.ОтображатьЗаголовок = ОтображатьЗаголовок;
	
	Диаграмма.ОтображатьЛегенду   = ОтображатьЛегенду;
	
	ВыводимыйПоказатель = "";
	Если НомерПоказателя<мТаблицаПоказатели.Количество() Тогда
		ВыводимыйПоказатель = мТаблицаПоказатели[НомерПоказателя].ПредставлениеПоля;
	КонецЕсли;

	ДокументРезультат.Рисунки.Диаграмма.Объект.ОбластьЗаголовка.Текст = мНазваниеОтчета + ": " + ВыводимыйПоказатель;
	
	СформироватьОтчет(ДокументРезультат.Рисунки.Диаграмма.Объект);
	

КонецПроцедуры // ПолучитьДиаграммуНаПечать()

////////////////////////////////////////////////////////////////////////////////
// ОПЕРАТОРЫ ОСНОВНОЙ ПРОГРАММЫ
// 

НП = Новый НастройкаПериода;

мТаблицаПоказатели  = Новый ТаблицаЗначений;


ОписаниеТиповСтрока = ОбщегоНазначения.ПолучитьОписаниеТиповСтроки(100);

МассивБулево = Новый Массив;
МассивБулево.Добавить(Тип("Булево"));
ОписаниеТиповБулево = Новый ОписаниеТипов(МассивБулево);

// Инициализация таблиц всех возможных показателей, группировок,  фильтров
мТаблицаПоказатели.Колонки.Добавить("ИмяПоля", ОписаниеТиповСтрока);
мТаблицаПоказатели.Колонки.Добавить("ПредставлениеПоля", ОписаниеТиповСтрока);
мТаблицаПоказатели.Колонки.Добавить("ФорматнаяСтрока", ОписаниеТиповСтрока);

мМассивШиринКолонок = Новый Массив;

мСтруктураСвязиПоказателейИИзмерений = Новый Структура;

мСоответствиеНазначений = Новый Соответствие;

СтруктураФорматаПолей = Новый Структура;

мНазваниеОтчета = "";

мВыбиратьИмяРегистра = Истина;

ПоказыватьЗаголовок = Истина;

СтруктураФорматаПолей = Новый Структура;
СтруктураФорматаПолей.Вставить("ПериодГод", "ДФ = ""гггг """"г.""""""");
СтруктураФорматаПолей.Вставить("ПериодКвартал", "ДФ = ""к"""" квартал"""" гггг """"г.""""""");
СтруктураФорматаПолей.Вставить("ПериодМесяц", "ДФ = ""ММММ гггг """"г.""""""");
СтруктураФорматаПолей.Вставить("ПериодНеделя","ДФ = """"""Неделя с"""" дд.ММ.гггг """"""");
СтруктураФорматаПолей.Вставить("ПериодДень", "ДФ = дд.ММ.гггг");
СтруктураФорматаПолей.Вставить("ПериодДекада","ДФ = """"""Декада с"""" дд.ММ.гггг """"""");
СтруктураФорматаПолей.Вставить("ПериодПолугодие","ДФ = """"""Полугодие с"""" дд.ММ.гггг """"""");
#КонецЕсли
