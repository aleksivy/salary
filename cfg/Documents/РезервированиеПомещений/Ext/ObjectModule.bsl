﻿Перем мУдалятьДвижения;



Перем мСтараяДатаНачалаСобытия;

Перем мСтараяДатаОкончанияСобытия;

////////////////////////////////////////////////////////////////////////////////
// ЭКСПОРТНЫЕ ПРОЦЕДУРЫ И ФУНКЦИИ ДОКУМЕНТА

#Если Клиент Тогда

// Процедура осуществляет печать документа. Можно направить печать на 
// экран или принтер, а также распечатать необходмое количество копий.
//
//  Название макета печати передается в качестве параметра,
// по переданному названию находим имя макета в соответствии.
//
// Параметры:
//  НазваниеМакета - строка, название макета.
//
Процедура Печать(ИмяМакета, КоличествоЭкземпляров = 1, НаПринтер = Ложь) Экспорт

	Если НЕ Проведен Тогда
		Предупреждение(НСтр("ru='Документ можно распечатать только после его проведения!';uk='Документ можна роздрукувати тільки після його проведення!'"));
		Возврат;
	КонецЕсли;

	Если Не РаботаСДиалогами.ПроверитьМодифицированность(ЭтотОбъект) Тогда
		Возврат;
	КонецЕсли;

	// Получить экземпляр документа на печать
	Если      ИмяМакета = "Диаграмма" Тогда
		Отчет = Отчеты.ДиаграммаГанта.Создать();
		Отчет.ВидОтчета = НСтр("ru='Планируемая занятость помещений';uk='Планована зайнятість приміщень'");
		Отчет.Периодичность = 0;
		Отчет.ЗаполнитьНачальныеНастройки();
		Если ДатаОкончания - ДатаНачала < 86400 Тогда // меньше суток
			Отчет.ДатаНач = НачалоДня(ДатаНачала);
			Отчет.ДатаКон = КонецДня(ДатаОкончания);
		Иначе
			Отчет.ДатаНач = НачалоНедели(ДатаНачала);
			Отчет.ДатаКон = КонецНедели(ДатаОкончания);
		КонецЕсли;
		Отчет.Печать(Ссылка);
	КонецЕсли;

КонецПроцедуры // Печать

#КонецЕсли

// Возвращает доступные варианты печати документа
//
// Вовращаемое значение:
//  Струткура, каждая строка которой соответствует одному из вариантов печати
//  
Функция ПолучитьСтруктуруПечатныхФорм() Экспорт
	
	Возврат Новый Структура("Диаграмма", НСтр("ru='Диаграмма';uk='Діаграма'"));
	
КонецФункции // ПолучитьСтруктуруПечатныхФорм()

////////////////////////////////////////////////////////////////////////////////
// ПРОЦЕДУРЫ И ФУНКЦИИ ДЛЯ ОБЕСПЕЧЕНИЯ ПРОВЕДЕНИЯ ДОКУМЕНТА

// Формирует запрос по шапке документа
//
// Параметры: 
//  Режим - режим проведения
//
// Возвращаемое значение:
//  Результат запроса
//
Функция СформироватьЗапросПоШапке(Режим)

	Запрос = Новый Запрос;

	// Установим параметры запроса
	Запрос.УстановитьПараметр("ДокументСсылка" , Ссылка);

	Запрос.Текст = "
	|ВЫБРАТЬ 
	|	Занятость,
	|	ДатаНачала,
	|	ДатаОкончания
	|	
	|ИЗ 
	|	Документ.РезервированиеПомещений
	|
	|ГДЕ 
	|	Ссылка = &ДокументСсылка
	|";

	Возврат Запрос.Выполнить();

КонецФункции // СформироватьЗапросПоШапке()

// Формирует запрос по табличной части "СписокПомещений" документа
//
// Параметры: 
//  Режим - режим проведения
//
// Возвращаемое значение:
//  Результат запроса к табличной части документа.
//
Функция СформироватьЗапросПоСписокПомещений(Режим)

	Запрос = Новый Запрос;
	
	// Установим параметры запроса
	Запрос.УстановитьПараметр("ДокументСсылка", Ссылка);
	Запрос.УстановитьПараметр("ДатаНачала", ДатаНачала);
	Запрос.УстановитьПараметр("ДатаОкончания", ДатаОкончания);
	Запрос.УстановитьПараметр("Свободно", Перечисления.Занятость.Свободно);
	
	// Описание текста запроса:
	// 1. Выборка "ПерваяТаблица": 
	//		Выбираются строки документа
	// 2. Выборка "ПланируемаяЗанятостьПомещений": 
	//		Из таблицы среза последних регистра выбираем планируемое состояние для проверки. 
	//      В качестве условия на измерение задается список помещений, упомянутых в документе.
	// 3. Выборка "ВтораяТаблица": 
	//		Среди строк документа ищем строки с пересекающимися периодами отпусков 
	//      для одного работника
	//
	ТекстЗапроса = 
		"ВЫБРАТЬ
		|	ПерваяТаблица.НомерСтроки КАК НомерСтроки,
		|	ПерваяТаблица.Помещение,
		|	ВЫБОР
		|		КОГДА ЕСТЬNULL(ПланируемаяЗанятостьПомещений.Занятость, &Свободно) <> &Свободно
		|				ИЛИ ПланируемаяЗанятостьПомещений.Период >= &ДатаНачала
		|			ТОГДА ""Нельзя""
		|		ИНАЧЕ ""Можно""
		|	КОНЕЦ КАК ПроверяемоеЗначение,
		|	МИНИМУМ(ВтораяТаблица.НомерСтроки) КАК КонфликтнаяСтрока
		|ИЗ
		|	Документ.РезервированиеПомещений.СписокПомещений КАК ПерваяТаблица
		|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.ПланируемаяЗанятостьПомещений.СрезПоследних(
		|		&ДатаОкончания,
		|		Помещение В
		|		    (ВЫБРАТЬ РАЗЛИЧНЫЕ
		|		        РезервированиеПомещенийСписокПомещений.Помещение
		|		    ИЗ
		|		        Документ.РезервированиеПомещений.СписокПомещений КАК РезервированиеПомещенийСписокПомещений
		|		    ГДЕ
		|		        РезервированиеПомещенийСписокПомещений.Ссылка = &ДокументСсылка)) КАК ПланируемаяЗанятостьПомещений
		|		ПО ПерваяТаблица.Помещение = ПланируемаяЗанятостьПомещений.Помещение
		|		ЛЕВОЕ СОЕДИНЕНИЕ Документ.РезервированиеПомещений.СписокПомещений КАК ВтораяТаблица
		|		ПО ПерваяТаблица.Ссылка = ВтораяТаблица.Ссылка
		|			И ПерваяТаблица.Помещение = ВтораяТаблица.Помещение
		|			И ПерваяТаблица.НомерСтроки < ВтораяТаблица.НомерСтроки
		|ГДЕ
		|	ПерваяТаблица.Ссылка = &ДокументСсылка
		|
		|СГРУППИРОВАТЬ ПО
		|	ПерваяТаблица.НомерСтроки,
		|	ПерваяТаблица.Помещение,
		|	ПланируемаяЗанятостьПомещений.Занятость,
		|	ПланируемаяЗанятостьПомещений.Период";
	
	Запрос.Текст = ТекстЗапроса;
	
	Возврат Запрос.Выполнить();

КонецФункции // СформироватьЗапросПоСписокПомещений()

// Проверяет правильность заполнения шапки документа.
// Если какой-то из реквизтов шапки, влияющий на проведение не заполнен или
// заполнен не корректно, то выставляется флаг отказа в проведении.
// Проверка выполняется по выборке из результата запроса по шапке,
// все проверяемые реквизиты должны быть включены в выборку по шапке.
//
// Параметры: 
//  ВыборкаПоШапкеДокумента	- выборка из результата запроса по шапке документа,
//  Отказ 					- флаг отказа в проведении,
//	Заголовок				- Заголовок для сообщений об ошибках проведения.
//
Процедура ПроверитьЗаполнениеШапки(ВыборкаПоШапкеДокумента, Отказ, Заголовок)

	// Занятость
	Если НЕ ЗначениеЗаполнено(ВыборкаПоШапкеДокумента.Занятость) Тогда
		ОбщегоНазначения.СообщитьОбОшибке(НСтр("ru='Не указана занятость помещений!';uk='Не вказана зайнятість приміщень!'"), Отказ, Заголовок);
	КонецЕсли;

	// Дата
	Если НЕ ЗначениеЗаполнено(ВыборкаПоШапкеДокумента.ДатаНачала) Тогда
		ОбщегоНазначения.СообщитьОбОшибке(НСтр("ru='Не задана дата и время резервирования помещений!';uk='Не задана дата і час резервування приміщень!'"), Отказ, Заголовок);
	КонецЕсли;
	
	Если ВыборкаПоШапкеДокумента.ДатаНачала = ВыборкаПоШапкеДокумента.ДатаОкончания или НЕ ЗначениеЗаполнено(ВыборкаПоШапкеДокумента.ДатаОкончания) Тогда
		ОбщегоНазначения.СообщитьОбОшибке(НСтр("ru='Не указана продолжительноть занятости помещений!';uk='Не вказана продолжительноть зайнятості приміщень!'"), Отказ, Заголовок);
	КонецЕсли;

КонецПроцедуры // ПроверитьЗаполнениеШапки()

// Проверяет правильность заполнения реквизитов в строке ТЧ "СписокПомещений" документа.
// Если какой-то из реквизтов, влияющий на проведение не заполнен или
// заполнен не корректно, то выставляется флаг отказа в проведении.
// Проверка выполняется по выборке из результата запроса по строке ТЧ документа,
// все проверяемые реквизиты должны быть включены в выборку.
//
// Параметры: 
//  ВыборкаПоШапкеДокумента		- выборка из результата запроса по шапке документа,
//  ВыборкаПоСтрокамДокумента	- спозиционированная на определеной строке выборка 
//  							  из результата запроса по работникам, 
//  Отказ 						- флаг отказа в проведении,
//	Заголовок					- Заголовок для сообщений об ошибках проведения.
//
Процедура ПроверитьЗаполнениеСтрокиСписокПомещений(ВыборкаПоШапкеДокумента, ВыборкаПоСтрокамДокумента, Отказ, Заголовок)

		СтрокаНачалаСообщенияОбОшибке = НСтр("ru='В строке номер ""';uk='У рядку номер ""'")+ СокрЛП(ВыборкаПоСтрокамДокумента.НомерСтроки) +
										НСтр("ru='"" табл. части ""Список помещений"": ';uk='"" табл. частини ""Список приміщень"": '");
		
		// Помещение
		Если НЕ ЗначениеЗаполнено(ВыборкаПоСтрокамДокумента.Помещение) Тогда
			ОбщегоНазначения.СообщитьОбОшибке(СтрокаНачалаСообщенияОбОшибке + НСтр("ru='не выбрано помещение!';uk='не вибрано приміщення!'"), Отказ, Заголовок);
		КонецЕсли;

		Если ВыборкаПоСтрокамДокумента.КонфликтнаяСтрока <> NULL  Тогда
			СтрокаПродолжениеСообщенияОбОшибке = НСтр("ru=' найдена повторяющаяся строка №';uk=' знайдений рядок, що повторюється №'") + ВыборкаПоСтрокамДокумента.КонфликтнаяСтрока;
			ОбщегоНазначения.СообщитьОбОшибке(СтрокаНачалаСообщенияОбОшибке + СтрокаПродолжениеСообщенияОбОшибке, Отказ, Заголовок);
		КонецЕсли;
		
		// Занятость помещения
		Если ВыборкаПоСтрокамДокумента.ПроверяемоеЗначение <> "Можно" и 
			(ВыборкаПоШапкеДокумента.ДатаОкончания > ВыборкаПоШапкеДокумента.ДатаНачала или НЕ ЗначениеЗаполнено(ВыборкаПоШапкеДокумента.ДатаОкончания)) Тогда
			
			СтрокаПродолжениеСообщенияОбОшибке = НСтр("ru=' помещение ';uk=' приміщення '") + ВыборкаПоСтрокамДокумента.Помещение + НСтр("ru=' на указанный период ранее уже было занято!';uk=' на вказаний період раніше вже було зайнято!'");
			
			ОбщегоНазначения.СообщитьОбОшибке(СтрокаНачалаСообщенияОбОшибке + СтрокаПродолжениеСообщенияОбОшибке, Отказ, Заголовок);
			
		КонецЕсли;
		
КонецПроцедуры // ПроверитьЗаполнениеСтрокиСписокПомещений()

// Создает и заполняет структуру, содержащую имена регистров сведений 
//  по которым надо проводить документ
//
// Параметры: 
//  СтруктураПроведенияПоРегистрамСведений - структура, содержащая имена регистров сведений 
//                                           по которым надо проводить документ
//
// Возвращаемое значение:
//  Нет.
//
Процедура ЗаполнитьСтруктуруПроведенияПоРегистрамСведений(ВыборкаПоШапкеДокумента, СтруктураПроведенияПоРегистрамСведений)

	СтруктураПроведенияПоРегистрамСведений = Новый Структура();
	СтруктураПроведенияПоРегистрамСведений.Вставить("ПланируемаяЗанятостьПомещений");

КонецПроцедуры // ЗаполнитьСтруктуруПроведенияПоРегистрамСведений

// По строке выборки результата запроса по документу формируем движения по регистрам
//
// Параметры: 
//  ВыборкаПоШапкеДокумента                - выборка из результата запроса по шапке документа,
//  СтруктураПроведенияПоРегистрамСведений - структура, содержащая имена регистров 
//                                           сведений по которым надо проводить документ,
//  СтруктураПараметров                    - структура параметров проведения,
//
// Возвращаемое значение:
//  Нет.
//
Процедура ДобавитьСтрокуВДвиженияПоРегистрамСведений(ВыборкаПоШапкеДокумента, ВыборкаПоСписокПомещений, 
		  СтруктураПроведенияПоРегистрамСведений, СтруктураПараметров = "")

	// Если документ нужно проводить по регистру, то для него есть ключ в структуре
	ИмяРегистра = "ПланируемаяЗанятостьПомещений";
	Если СтруктураПроведенияПоРегистрамСведений.Свойство(ИмяРегистра) Тогда

		Движение = Движения[ИмяРегистра].Добавить();

		// Свойства
		Движение.Период                     = ВыборкаПоШапкеДокумента.ДатаНачала;
	

		// Измерения
		Движение.Помещение                  = ВыборкаПоСписокПомещений.Помещение;

		// Ресурсы
		Движение.Занятость					= ВыборкаПоШапкеДокумента.Занятость;

		// Реквизиты
		Движение.ДатаОкончания              = ВыборкаПоШапкеДокумента.ДатаОкончания;
		
        // необходимо сделать еще одно движение
		Движение = Движения[ИмяРегистра].Добавить();
		
		// Свойства
		Движение.Период                     = ВыборкаПоШапкеДокумента.ДатаОкончания - 1;
		
		
		// Измерения
		Движение.Помещение                  = ВыборкаПоСписокПомещений.Помещение;
		
		// Ресурсы
		Движение.Занятость					= Перечисления.Занятость.Свободно;

	КонецЕсли;
КонецПроцедуры // ДобавитьСтрокуВДвиженияПоРегистрамСведений

Процедура ЗапомнитьСтарыеЗначения()
	
	мСтараяДатаНачалаСобытия = ДатаНачала;
	мСтараяДатаОкончанияСобытия = ДатаОкончания;
	
	Запрос = Новый Запрос;
	
	Запрос.УстановитьПараметр("ТекущееСобытие", Ссылка);
	
	Запрос.Текст = "
	|
	|ВЫБРАТЬ
	|	СобытияКалендаряПользователяОбобщенные.Дата КАК ДатаСобытия
	|ИЗ
	|	РегистрСведений.СобытияКалендаряПользователяОбобщенные КАК СобытияКалендаряПользователяОбобщенные
	|
	|ГДЕ
	|	СобытияКалендаряПользователяОбобщенные.Событие = &ТекущееСобытие
	|
	|СГРУППИРОВАТЬ ПО
	|
	|	СобытияКалендаряПользователяОбобщенные.Дата
	|";
	
	ТаблицаЗапроса = Запрос.Выполнить().Выгрузить();
	
	Если ТаблицаЗапроса.Количество() > 0 Тогда
		
		ТаблицаЗапроса.Свернуть("ДатаСобытия");
		ТаблицаЗапроса.Сортировать("ДатаСобытия ВОЗР");
		
		мСтараяДатаНачалаСобытия = ТаблицаЗапроса[0].ДатаСобытия;
		мСтараяДатаОкончанияСобытия = ТаблицаЗапроса[ТаблицаЗапроса.Количество() - 1].ДатаСобытия;
		
	КонецЕсли; 
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ

Процедура ОбработкаПроведения(Отказ, Режим)
	//структура, содержащая имена регистров сведений по которым надо проводить документ
	Перем СтруктураПроведенияПоРегистрамСведений;
	
	
	Если мУдалятьДвижения Тогда
		ОбщегоНазначения.УдалитьДвиженияРегистратора(ЭтотОбъект, Отказ);
	КонецЕсли;

	// Заголовок для сообщений об ошибках проведения.
	Заголовок = ОбщегоНазначения.ПредставлениеДокументаПриПроведении(Ссылка);
	
	// отражение в календаре пользователя занятость помещений
	ЗапомнитьСтарыеЗначения();
	
	УправлениеКонтактами.ОтразитьЗанятостьПомещений(Ссылка,ДатаНачала,ДатаОкончания,мСтараяДатаНачалаСобытия,мСтараяДатаОкончанияСобытия);
	
	РезультатЗапросаПоШапке = СформироватьЗапросПоШапке(Режим);

	// Получим реквизиты шапки из запроса
	ВыборкаПоШапкеДокумента = РезультатЗапросаПоШапке.Выбрать();

	Если ВыборкаПоШапкеДокумента.Следующий() Тогда

		//Надо позвать проверку заполнения реквизитов шапки
		ПроверитьЗаполнениеШапки(ВыборкаПоШапкеДокумента, Отказ, Заголовок);

		// Движения стоит добавлять, если в проведении еще не отказано (отказ =ложь)
		Если НЕ Отказ Тогда

			// Создадим и заполним структуры, содержащие имена регистров, по которым в зависимости от типа учета
			// проводится документ. В дальнейшем будем считать, что если для регистра не создан ключ в структуре,
			// то проводить по нему не надо.
			ЗаполнитьСтруктуруПроведенияПоРегистрамСведений(ВыборкаПоШапкеДокумента, СтруктураПроведенияПоРегистрамСведений);

			// получим реквизиты табличной части
			РезультатЗапросаПоСписокПомещений = СформироватьЗапросПоСписокПомещений(Режим);
			ВыборкаПоСписокПомещений = РезультатЗапросаПоСписокПомещений.Выбрать();

			Пока ВыборкаПоСписокПомещений.Следующий() Цикл 

				// проверим очередную строку табличной части
				ПроверитьЗаполнениеСтрокиСписокПомещений(ВыборкаПоШапкеДокумента, ВыборкаПоСписокПомещений, Отказ, Заголовок);

				Если НЕ Отказ Тогда
					// Заполним записи в наборах записей регистров
					ДобавитьСтрокуВДвиженияПоРегистрамСведений(ВыборкаПоШапкеДокумента, ВыборкаПоСписокПомещений, СтруктураПроведенияПоРегистрамСведений);
				КонецЕсли;
			КонецЦикла;

		КонецЕсли; 

	КонецЕсли;

КонецПроцедуры

Процедура ОбработкаУдаленияПроведения(Отказ)
	
	
	ОбщегоНазначения.УдалитьДвиженияРегистратора(ЭтотОбъект, Отказ);

КонецПроцедуры


Процедура ПередЗаписью(Отказ, РежимЗаписи, РежимПроведения)
	Если ОбменДанными.Загрузка  Тогда
		Возврат;
	КонецЕсли;


	 
	мУдалятьДвижения = НЕ ЭтоНовый();
	
КонецПроцедуры // ПередЗаписью


