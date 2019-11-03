﻿Перем мУдалятьДвижения;


////////////////////////////////////////////////////////////////////////////////
// ЭКСПОРТНЫЕ ПРОЦЕДУРЫ И ФУНКЦИИ ДОКУМЕНТА

// создает и частично заполняет новый документ Событие
//
// Параметры
//  ВидСобытия  – <ПеречисленияСсылка.ВидыСобытий> – вариант документа Событие
//
// Возвращаемое значение:
//   <ДокументОбъект.Событие>  - новый документ Событие
//
Функция ПолучитьДокументСобытие(ВидСобытия) Экспорт
	
	Документ = Документы.Событие.СоздатьДокумент();
		
	Документ.Дата = ТекущаяДата();
	Документ.НачалоСобытия =  Дата;
	Документ.ОкончаниеСобытия = Дата + 600;
	
	Документ.ВидСобытия = ВидСобытия;
	Документ.ТипСобытия = Перечисления.ВходящееИсходящееСобытие.Входящее;
	Документ.Основание = Ссылка;
	Документ.КонтактноеЛицо = ФизЛицо;
	
	Возврат Документ
	
КонецФункции // ПолучитьДокументСобытие()
////////////////////////////////////////////////////////////////////////////////
// ПРОЦЕДУРЫ И ФУНКЦИИ ДЛЯ ОБЕСПЕЧЕНИЯ ПРОВЕДЕНИЯ ДОКУМЕНТА

// Формирует запрос по шапке документа
//
// Параметры: 
//  Режим       - режим проведения
//
// Возвращаемое значение:
//  Результат запроса
//
Функция СформироватьЗапросПоШапке(Режим)
	
	Запрос = Новый Запрос;
	
	// Установим параметры запроса
	Запрос.УстановитьПараметр("ДокументСсылка" , Ссылка);
	
	Запрос.Текст = 
	"ВЫБРАТЬ РАЗРЕШЕННЫЕ
	|	РегистрацияСобеседованияКандидата.Дата,
	|	РегистрацияСобеседованияКандидата.ФизЛицо,
	|	РегистрацияСобеседованияКандидата.РезультатСобеседования,
	|	РегистрацияСобеседованияКандидата.Ответственный,
	|	РегистрацияСобеседованияКандидата.Подразделение,
	|	РегистрацияСобеседованияКандидата.ОсновнойМенеджер,
	|	РегистрацияСобеседованияКандидата.Должность,
	|	РегистрацияСобеседованияКандидата.Ссылка,
	|	Статусы.Статус КАК Статус
	|ИЗ
	|	Документ." + Метаданные().Имя + " КАК РегистрацияСобеседованияКандидата
	|		ЛЕВОЕ СОЕДИНЕНИЕ (ВЫБРАТЬ
	|			КандидатыНаРаботуСрезПоследних.Статус КАК Статус,
	|			КандидатыНаРаботуСрезПоследних.ФизЛицо КАК Кандидат
	|		ИЗ
	|			РегистрСведений.КандидатыНаРаботу.СрезПоследних(
	|				,
	|				ФизЛицо В
	|				    (ВЫБРАТЬ
	|				        Документ.РегистрацияСобеседованияКандидата.ФизЛицо
	|				    ИЗ
	|				        Документ." + Метаданные().Имя + "
	|				    ГДЕ
	|				        Документ.РегистрацияСобеседованияКандидата.Ссылка = &ДокументСсылка)) КАК КандидатыНаРаботуСрезПоследних) КАК Статусы
	|		ПО РегистрацияСобеседованияКандидата.ФизЛицо = Статусы.Кандидат
	|ГДЕ
	|	РегистрацияСобеседованияКандидата.Ссылка = &ДокументСсылка";
	
	Возврат Запрос.Выполнить();
	
КонецФункции // СформироватьЗапросПоШапке()

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
	
	Если НЕ ЗначениеЗаполнено(ВыборкаПоШапкеДокумента.ФизЛицо) Тогда
		ОбщегоНазначения.СообщитьОбОшибке(НСтр("ru='Не выбран кандидат!';uk='Не обраний кандидат!'"), Отказ, Заголовок);	
	КонецЕсли;
	
	Если ВыборкаПоШапкеДокумента.Статус = Перечисления.СостоянияКандидатаНаРаботу.Отклонен Тогда
		ОбщегоНазначения.СообщитьОбОшибке(НСтр("ru='Указан кандидат,по которому принято решение ""Отклонен""!';uk='Вказаний кандидат,по якому прийнято рішення ""Відхилений""!'"), Отказ, Заголовок);	
	КонецЕсли;
	
КонецПроцедуры // ПроверитьЗаполнениеШапки()

// Создает и заполняет структуру, содержащую имена регистров сведений 
//  по которым надо проводить документ
//
// Параметры: 
//  СтруктураПроведенияПоРегистрамСведений - структура, содержащая имена регистров сведений 
//                 по которым надо проводить документ.
//
// Возвращаемое значение:
//  Нет.
//
Процедура ЗаполнитьСтруктуруПроведенияПоРегистрамСведений(ВыборкаПоШапкеДокумента, СтруктураПроведенияПоРегистрамСведений)
	
	СтруктураПроведенияПоРегистрамСведений = Новый Структура();
	СтруктураПроведенияПоРегистрамСведений.Вставить("КандидатыНаРаботу");
	
КонецПроцедуры // ЗаполнитьСтруктуруПроведенияПоРегистрамСведений()

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
Процедура ДобавитьСтрокуВДвиженияПоРегистрамСведений(ВыборкаПоШапкеДокумента, СтруктураПроведенияПоРегистрамСведений)
	
	ИмяРегистра = "КандидатыНаРаботу";
	Если СтруктураПроведенияПоРегистрамСведений.Свойство(ИмяРегистра) Тогда
		
		Движение = Движения[ИмяРегистра].Добавить();
		
		Движение.Период        = Дата;
		
		
		// Измерения
		Движение.ФизЛицо       = ВыборкаПоШапкеДокумента.ФизЛицо;
		
		Если НЕ ЗначениеЗаполнено(ВыборкаПоШапкеДокумента.РезультатСобеседования) Тогда
			// Если не выбран статус - записываем предыдущий статус.
			
			// Ресурсы
			Движение.Статус        = ВыборкаПоШапкеДокумента.Статус;
			
		Иначе	
			// Ресурсы
			Движение.Статус        = ВыборкаПоШапкеДокумента.РезультатСобеседования;
			
		КонецЕсли;
		
		
		// Реквизиты
		Движение.Подразделение    = ВыборкаПоШапкеДокумента.Подразделение;
		Движение.Должность        = ВыборкаПоШапкеДокумента.Должность;
		Движение.ОсновнойМенеджер = ВыборкаПоШапкеДокумента.ОсновнойМенеджер;
		
	КонецЕсли;
	
КонецПроцедуры // ДобавитьСтрокуВДвиженияПоРегистрамСведений()

////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ

Процедура ОбработкаПроведения(Отказ, Режим)
	//структура, содержащая имена регистров сведений по которым надо проводить документ
	Перем СтруктураПроведенияПоРегистрамСведений;
	
	//Документ не используется
	Отказ = Истина;
	Возврат;
	
	Если мУдалятьДвижения Тогда
		ОбщегоНазначения.УдалитьДвиженияРегистратора(ЭтотОбъект, Отказ);
	КонецЕсли;

	// Заголовок для сообщений об ошибках проведения.
	Заголовок = ОбщегоНазначения.ПредставлениеДокументаПриПроведении(Ссылка);	
	
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
			
			// Заполним записи в наборах записей регистров
			ДобавитьСтрокуВДвиженияПоРегистрамСведений(ВыборкаПоШапкеДокумента, СтруктураПроведенияПоРегистрамСведений);
			
		КонецЕсли; 
		
	КонецЕсли;
	
КонецПроцедуры

Процедура ПриУстановкеНовогоНомера(СтандартнаяОбработка, Префикс)
	ОбщегоНазначения.ДобавитьПрефиксУзла(Префикс);
КонецПроцедуры

Процедура ОбработкаЗаполнения(Основание)
	ТипОснования = ТипЗнч(Основание);
	Если ТипОснования = Тип("ДокументСсылка.Событие") Тогда
		ФизЛицо = Основание.КонтактноеЛицо;
		ЭтотОбъект.Основание = Основание;
	КонецЕсли;
КонецПроцедуры

Процедура ПередЗаписью(Отказ, РежимЗаписи, РежимПроведения)
	Если ОбменДанными.Загрузка  Тогда
		Возврат;
	КонецЕсли;


	 
	мУдалятьДвижения = НЕ ЭтоНовый();
	
	Если мУдалятьДвижения Тогда
		ОбщегоНазначения.ОчисткаКоллекцииДвиженийДокумента(ЭтотОбъект);
	КонецЕсли;

КонецПроцедуры // ПередЗаписью

Процедура ОбработкаУдаленияПроведения(Отказ)

	
	ОбщегоНазначения.УдалитьДвиженияРегистратора(ЭтотОбъект, Отказ);

КонецПроцедуры // ОбработкаУдаленияПроведения




