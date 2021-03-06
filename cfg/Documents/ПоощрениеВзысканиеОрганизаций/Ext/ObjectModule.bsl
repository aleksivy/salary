////////////////////////////////////////////////////////////////////////////////
// ВСПОМОГАТЕЛЬНЫЕ ПРОЦЕДУРЫ И ФУНКЦИИ
//
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
	|Выбрать 
	|	Дата, 
	|	Организация,
 	|	ВидПоощренияВзыскания,
	| 	Ссылка 
	|Из 
	|	Документ." + Метаданные().Имя + "
	|Где 
	|	Ссылка = &ДокументСсылка
	|";

	Возврат Запрос.Выполнить();

КонецФункции // СформироватьЗапросПоШапке()

// Формирует запрос по таблице "РаботникиОрганизации" документа
//
// Параметры: 
//  Режим - режим проведения
//
// Возвращаемое значение:
//  Результат запроса. В запросе данные документа дополняются значениями
//  проверяемых параметров из связанного с
//
Функция СформироватьЗапросПоРаботникиОрганизации(ВыборкаПоШапкеДокумента, Режим)

	Запрос = Новый Запрос;
	// Установим параметры запроса
	Запрос.УстановитьПараметр("ДокументСсылка", Ссылка);
	Запрос.УстановитьПараметр("ДатаДокумента", Дата);

	Запрос.Текст = "
	|ВЫБРАТЬ 
	|	Док.Сотрудник,
	|	Док.НомерСтроки									КАК НомерСтроки
	|ИЗ
	|   Документ." + Метаданные().Имя + ".РаботникиОрганизации КАК Док				
	|ГДЕ
	|	Док.Ссылка  =  &ДокументСсылка
	|";


	Возврат Запрос.Выполнить();

КонецФункции // СформироватьЗапросПоРаботникиОрганизации()

// Проверяет правильность заполнения шапки документа.
// Если какой-то из реквизтов шапки, влияющий на проведение не заполнен или
// заполнен не корректно, то выставляется флаг отказа в проведении.
// Проверка выполняется по выборке из результата запроса по шапке,
// все проверяемые реквизиты должны быть включены в выборку по шапке.
//
// Параметры: 
//  ВыборкаПоШапкеДокумента	- выборка из результата запроса по шапке документа,
//  Отказ 					- флаг отказа в проведении.
//
Процедура ПроверитьЗаполнениеШапки(ВыборкаПоШапкеДокумента, Отказ)

	// Организация
	Если НЕ ЗначениеЗаполнено(ВыборкаПоШапкеДокумента.Организация) Тогда
		ОбщегоНазначения.СообщитьОбОшибке(НСтр("ru='Не указана организация!';uk='Не зазначена організація!'"), Отказ);
	КонецЕсли;
	
	// Вид поощрения взыскания
	Если НЕ ЗначениеЗаполнено(ВыборкаПоШапкеДокумента.ВидПоощренияВзыскания) Тогда
		ОбщегоНазначения.СообщитьОбОшибке(НСтр("ru='Не указан вид поощрения (взыскания)!';uk='Не зазначений вид заохочення (стягнення)!'"), Отказ);
	КонецЕсли;

КонецПроцедуры // ПроверитьЗаполнениеШапки()

// Проверяет правильность заполнения реквизитов в строке ТЧ "РаботникиОрганизации" документа.
// Если какой-то из реквизтов, влияющий на проведение не заполнен или
// заполнен не корректно, то выставляется флаг отказа в проведении.
// Проверка выполняется по выборке из результата запроса по строке ТЧ документа,
// все проверяемые реквизиты должны быть включены в выборку.
//
// Параметры: 
//  ВыборкаПоШапкеДокумента		- выборка из результата запроса по шапке документа,
//  ВыборкаПоСтрокамДокумента	- спозиционированная на определеной строке выборка 
//  							  из результата запроса по работникам, 
//  Отказ 						- флаг отказа в проведении.
//
Процедура ПроверитьЗаполнениеСтрокиРаботникаОрганизации(ВыборкаПоШапкеДокумента, ВыборкаПоСтрокамДокумента, Отказ)

	СтрокаНачалаСообщенияОбОшибке = НСтр("ru='В строке номер ""';uk='У рядку номер ""'")+ СокрЛП(ВыборкаПоСтрокамДокумента.НомерСтроки) +
	НСтр("ru='"" табл. части ""Работники организации"": ';uk='"" табл. частини ""Працівники організації"": '");

	// ФизЛицо
	ЕстьФизЛицо = ЗначениеЗаполнено(ВыборкаПоСтрокамДокумента.Сотрудник);
	Если Не ЕстьФизЛицо Тогда
		ОбщегоНазначения.СообщитьОбОшибке(СтрокаНачалаСообщенияОбОшибке + НСтр("ru='не выбран работник!';uk='не обраний працівник!'"), Отказ);
	КонецЕсли;
		
КонецПроцедуры // ПроверитьЗаполнениеСтрокиРаботникаОрганизации()

////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ

Процедура ОбработкаПроведения(Отказ, Режим)
	
	РезультатЗапросаПоШапке = СформироватьЗапросПоШапке(Режим);
    // Получим реквизиты шапки из запроса
	ВыборкаПоШапкеДокумента = РезультатЗапросаПоШапке.Выбрать();

	Если ВыборкаПоШапкеДокумента.Следующий() Тогда

		//Надо позвать проверку заполнения реквизитов шапки
		ПроверитьЗаполнениеШапки(ВыборкаПоШапкеДокумента, Отказ);

		// Движения стоит добавлять, если в проведении еще не отказано (отказ = ложь)
		Если НЕ Отказ Тогда

			РезультатЗапросаПоРаботники = СформироватьЗапросПоРаботникиОрганизации(ВыборкаПоШапкеДокумента, Режим);
			ВыборкаПоРаботникиОрганизации = РезультатЗапросаПоРаботники.Выбрать();

			Пока ВыборкаПоРаботникиОрганизации.Следующий() Цикл 

				// проверим очередную строку табличной части
				ПроверитьЗаполнениеСтрокиРаботникаОрганизации(ВыборкаПоШапкеДокумента, ВыборкаПоРаботникиОрганизации, Отказ);


			КонецЦикла;
			
		КонецЕсли; 

	КонецЕсли;

КонецПроцедуры

Процедура ПередЗаписью(Отказ, РежимЗаписи, РежимПроведения)
	
	КраткийСоставДокумента = ПроцедурыУправленияПерсоналом.ЗаполнитьКраткийСоставДокумента(РаботникиОрганизации);
	ПроцедурыУправленияПерсоналом.ЗаполнитьФизЛицоПоТЧ(РаботникиОрганизации);
	
КонецПроцедуры



