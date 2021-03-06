Перем мУдалятьДвижения;


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
	|	 
	| 	Ссылка 
	|Из 
	|	Документ." + Метаданные().Имя + "
	|Где 
	|	Ссылка = &ДокументСсылка
	|";

	Возврат Запрос.Выполнить();
    
КонецФункции // СформироватьЗапросПоШапке()

// Формирует запрос по таблице "Штатные единицы" документа
//
// Параметры: 
//  Режим - режим проведения
//
// Возвращаемое значение:
//  Результат запроса
//
Функция СформироватьЗапросПоСхемыМотивации(Режим)
	
	Запрос = Новый Запрос;
	
	// Установим параметры запроса
	Запрос.УстановитьПараметр("ДокументСсылка", Ссылка);

	Запрос.Текст = "ВЫБРАТЬ
	               |	""Начисления"" КАК ТабличнаяЧасть,
	               |	Док.НомерСтроки КАК НомерСтроки,
	               |	Док.Подразделение,
	               |	Док.Подразделение.Наименование,
	               |	Док.Должность.Наименование,
	               |	Док.Должность,
	               |	Док.ВидРасчета,
	               |	Док.ВидРасчета.ЗачетОтработанногоВремени КАК ОсновноеНачисление,
	               |	Док.Показатель1,
	               |	Док.Валюта1,
	               |	Док.Показатель2,
	               |	Док.Валюта2,
	               |	Док.Показатель3,
	               |	Док.Валюта3,
	               |	Док.ВидРасчета.Предопределенный КАК Предопределенный,
	               |	Док.ВидРасчета.Показатель1.Наименование КАК ВидРасчетаПоказатель1Наименование,
	               |	Док.ВидРасчета.Показатель1.ВидПоказателя КАК ВидРасчетаПоказатель1ВидПоказателя,
	               |	Док.ВидРасчета.Показатель1.ВозможностьИзменения КАК ВидРасчетаПоказатель1ВозможностьИзменения,
	               |	Док.ВидРасчета.Показатель2.Наименование КАК ВидРасчетаПоказатель2Наименование,
	               |	Док.ВидРасчета.Показатель2.ВидПоказателя КАК ВидРасчетаПоказатель2ВидПоказателя,
	               |	Док.ВидРасчета.Показатель2.ВозможностьИзменения КАК ВидРасчетаПоказатель2ВозможностьИзменения,
	               |	Док.ВидРасчета.Показатель3.Наименование КАК ВидРасчетаПоказатель3Наименование,
	               |	Док.ВидРасчета.Показатель3.ВидПоказателя КАК ВидРасчетаПоказатель3ВидПоказателя,
	               |	Док.ВидРасчета.Показатель3.ВозможностьИзменения КАК ВидРасчетаПоказатель3ВозможностьИзменения,
	               |	МИНИМУМ(ПоощренияПовторы.НомерСтроки) КАК КонфликтнаяСтрокаНомер
	               |ИЗ
	               |	Документ.ИзменениеСхемМотивацииРаботников.Поощрения КАК Док
	               |		ЛЕВОЕ СОЕДИНЕНИЕ Документ.ИзменениеСхемМотивацииРаботников.Поощрения КАК ПоощренияПовторы
	               |		ПО Док.Подразделение = ПоощренияПовторы.Подразделение
	               |			И Док.Должность = ПоощренияПовторы.Должность
	               |			И Док.НомерСтроки < ПоощренияПовторы.НомерСтроки
	               |			И (Док.ВидРасчета.ЗачетОтработанногоВремени
	               |					И ПоощренияПовторы.ВидРасчета.ЗачетОтработанногоВремени
	               |				ИЛИ Док.ВидРасчета = ПоощренияПовторы.ВидРасчета)
	               |			И Док.Ссылка = ПоощренияПовторы.Ссылка
	               |ГДЕ
	               |	Док.Ссылка = &ДокументСсылка
	               |
	               |СГРУППИРОВАТЬ ПО
	               |	Док.НомерСтроки,
	               |	Док.Подразделение,
	               |	Док.Должность,
	               |	Док.ВидРасчета,
	               |	Док.Показатель1,
	               |	Док.Валюта1,
	               |	Док.Показатель2,
	               |	Док.Валюта2,
	               |	Док.Показатель3,
	               |	Док.Валюта3,
	               |	Док.ВидРасчета.ЗачетОтработанногоВремени,
	               |	Док.ВидРасчета.Предопределенный,
	               |	Док.ВидРасчета.Показатель1.Наименование,
	               |	Док.ВидРасчета.Показатель1.ВидПоказателя,
	               |	Док.ВидРасчета.Показатель1.ВозможностьИзменения,
	               |	Док.ВидРасчета.Показатель2.Наименование,
	               |	Док.ВидРасчета.Показатель2.ВидПоказателя,
	               |	Док.ВидРасчета.Показатель2.ВозможностьИзменения,
	               |	Док.ВидРасчета.Показатель3.Наименование,
	               |	Док.ВидРасчета.Показатель3.ВидПоказателя,
	               |	Док.ВидРасчета.Показатель3.ВозможностьИзменения,
	               |	Док.Подразделение.Наименование,
	               |	Док.Должность.Наименование
	               |
	               |ОБЪЕДИНИТЬ ВСЕ
	               |
	               |ВЫБРАТЬ
	               |	""Взыскания"",
	               |	Док.НомерСтроки,
	               |	Док.Подразделение,
	               |	Док.Подразделение.Наименование,
	               |	Док.Должность.Наименование,
	               |	Док.Должность,
	               |	Док.ВидРасчета,
	               |	NULL,
	               |	Док.Показатель1,
	               |	Док.Валюта1,
	               |	Док.Показатель2,
	               |	Док.Валюта2,
	               |	Док.Показатель3,
	               |	Док.Валюта3,
	               |	Док.ВидРасчета.Предопределенный,
	               |	Док.ВидРасчета.Показатель1.Наименование,
	               |	Док.ВидРасчета.Показатель1.ВидПоказателя,
	               |	Док.ВидРасчета.Показатель1.ВозможностьИзменения,
	               |	Док.ВидРасчета.Показатель2.Наименование,
	               |	Док.ВидРасчета.Показатель2.ВидПоказателя,
	               |	Док.ВидРасчета.Показатель2.ВозможностьИзменения,
	               |	Док.ВидРасчета.Показатель3.Наименование,
	               |	Док.ВидРасчета.Показатель3.ВидПоказателя,
	               |	Док.ВидРасчета.Показатель3.ВозможностьИзменения,
	               |	МИНИМУМ(ВзысканияПовторы.НомерСтроки)
	               |ИЗ
	               |	Документ.ИзменениеСхемМотивацииРаботников.Взыскания КАК Док
	               |		ЛЕВОЕ СОЕДИНЕНИЕ Документ.ИзменениеСхемМотивацииРаботников.Взыскания КАК ВзысканияПовторы
	               |		ПО Док.Подразделение = ВзысканияПовторы.Подразделение
	               |			И Док.Должность = ВзысканияПовторы.Должность
	               |			И Док.ВидРасчета = ВзысканияПовторы.ВидРасчета
	               |			И Док.Ссылка = ВзысканияПовторы.Ссылка
	               |			И Док.НомерСтроки < ВзысканияПовторы.НомерСтроки
	               |ГДЕ
	               |	Док.Ссылка = &ДокументСсылка
	               |
	               |СГРУППИРОВАТЬ ПО
	               |	Док.НомерСтроки,
	               |	Док.Подразделение,
	               |	Док.Должность,
	               |	Док.ВидРасчета,
	               |	Док.Показатель1,
	               |	Док.Валюта1,
	               |	Док.Показатель2,
	               |	Док.Валюта2,
	               |	Док.Показатель3,
	               |	Док.Валюта3,
	               |	Док.ВидРасчета.Предопределенный,
	               |	Док.ВидРасчета.Показатель1.Наименование,
	               |	Док.ВидРасчета.Показатель1.ВидПоказателя,
	               |	Док.ВидРасчета.Показатель1.ВозможностьИзменения,
	               |	Док.ВидРасчета.Показатель2.Наименование,
	               |	Док.ВидРасчета.Показатель2.ВидПоказателя,
	               |	Док.ВидРасчета.Показатель2.ВозможностьИзменения,
	               |	Док.ВидРасчета.Показатель3.Наименование,
	               |	Док.ВидРасчета.Показатель3.ВидПоказателя,
	               |	Док.ВидРасчета.Показатель3.ВозможностьИзменения,
	               |	Док.Подразделение.Наименование,
	               |	Док.Должность.Наименование";
	              
	Возврат Запрос.Выполнить();

КонецФункции // СформироватьЗапросПоСхемыМотивации()

// Проверяет правильность заполнения шапки документа.
// Если какой-то из реквизтов шапки, влияющий на проведение не заполнен или
// заполнен не корректно, то выставляется флаг отказа в проведении.
// Проверка выполняется по выборке из результата запроса по шапке,
// все проверяемые реквизиты должны быть включены в выборку по шапке.
//
// Параметры: 
//  ВыборкаПоШапкеДокумента	- выборка из результата запроса по шапке документа,
//  Отказ 					- флаг отказа в проведении.
//	Заголовок				- Заголовок для сообщений об ошибках проведения
//
Процедура ПроверитьЗаполнениеШапки(ВыборкаПоШапкеДокумента, Отказ, Заголовок)


КонецПроцедуры // ПроверитьЗаполнениеШапки()

// Проверяет правильность заполнения реквизитов в строке ТЧ "Штатные единицы" документа.
// Если какой-то из реквизтов, влияющий на проведение не заполнен или
// заполнен не корректно, то выставляется флаг отказа в проведении.
// Проверка выполняется по выборке из результата запроса по строке ТЧ документа,
// все проверяемые реквизиты должны быть включены в выборку.
//
// Параметры: 
//  ВыборкаПоШапкеДокумента		- выборка из результата запроса по шапке документа,
//  ВыборкаПоСтрокамДокумента	- спозиционированная на определеной строке выборка 
//  							  из результата запроса по строке ТЧ, 
//  Отказ 						- флаг отказа в проведении.
//	Заголовок					- Заголовок для сообщений об ошибках проведения
//
Процедура ПроверитьЗаполнениеСтрокиМотивации(ВыборкаПоШапкеДокумента, ВыборкаПоСтрокамДокумента, Отказ, Заголовок)

	СтрокаНачалаСообщенияОбОшибке = НСтр("ru='В строке номер ""';uk='У рядку номер ""'")+ СокрЛП(ВыборкаПоСтрокамДокумента.НомерСтроки) +
									НСтр("ru='"" табл. части ';uk='"" табл. частини '") + ВыборкаПоСтрокамДокумента.ТабличнаяЧасть + ": ";
	// Подразделение
	Если НЕ ЗначениеЗаполнено(ВыборкаПоСтрокамДокумента.Подразделение) Тогда
		ОбщегоНазначения.СообщитьОбОшибке(СтрокаНачалаСообщенияОбОшибке + НСтр("ru='не выбрано подразделение!';uk='не обраний підрозділ!'"), Отказ, Заголовок);
	КонецЕсли;

	// Должность
	Если НЕ ЗначениеЗаполнено(ВыборкаПоСтрокамДокумента.Должность) Тогда
		ОбщегоНазначения.СообщитьОбОшибке(СтрокаНачалаСообщенияОбОшибке + НСтр("ru='не выбрана должность!';uk='не обрана посада!'"), Отказ, Заголовок);
	КонецЕсли;

	// Валюта
	Если НЕ ЗначениеЗаполнено(ВыборкаПоСтрокамДокумента.ВидРасчета) Тогда
		ОбщегоНазначения.СообщитьОбОшибке(СтрокаНачалаСообщенияОбОшибке + НСтр("ru='не указано ';uk='не вказано '") + ?(ВыборкаПоСтрокамДокумента.ТабличнаяЧасть = "Начисления","начисление!","удержание!"), Отказ, Заголовок);
	Иначе
		
        // Одинаковые строки
 		Если ЗначениеЗаполнено(ВыборкаПоСтрокамДокумента.КонфликтнаяСтрокаНомер) Тогда
			Если ВыборкаПоСтрокамДокумента.ТабличнаяЧасть = "Начисления" И
				ВыборкаПоСтрокамДокумента.ОсновноеНачисление Тогда
 				СтрокаСообщениеОбОшибке = НСтр("ru='основное начисление для строки кадрового плана (';uk='основне нарахування для рядка кадрового плану ('") + ВыборкаПоСтрокамДокумента.ПодразделениеНаименование + ", " + ВыборкаПоСтрокамДокумента.ДолжностьНаименование + НСтр("ru=') следует редактировать в одной строке (см. строку ';uk=') слід редагувати в одному рядку (див. рядок '") + ВыборкаПоСтрокамДокумента.КонфликтнаяСтрокаНомер + ")!"; 
 			Иначе
 				СтрокаСообщениеОбОшибке = НСтр("ru='для строки кадрового плана (';uk='для рядка кадрового плану ('") + ВыборкаПоСтрокамДокумента.ПодразделениеНаименование + ", " + ВыборкаПоСтрокамДокумента.ДолжностьНаименование + НСтр("ru=') не может быть назначено одно и тоже ';uk=' не може бути призначено одне і теж '") + ?(ВыборкаПоСтрокамДокумента.ТабличнаяЧасть = "Начисления","начисление","удержание") + " дважды (см. строку " + ВыборкаПоСтрокамДокумента.КонфликтнаяСтрокаНомер + ")!"; 
 			КонецЕсли;
 			ОбщегоНазначения.СообщитьОбОшибке(СтрокаНачалаСообщенияОбОшибке  + СтрокаСообщениеОбОшибке, Отказ, Заголовок);
		КонецЕсли;
	
	КонецЕсли;

КонецПроцедуры // ПроверитьЗаполнениеСтрокиРабочегоМеста()

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
Процедура ДобавитьСтрокуВСхемуМотивации(ВыборкаПоШапкеДокумента, ВыборкаПоСтрокамДокумента)
	
	Движение = Движения.СхемыМотивацииРаботников.Добавить();
	
	// Измерения
	Движение.Подразделение			= ВыборкаПоСтрокамДокумента.Подразделение;
	Движение.Должность				= ВыборкаПоСтрокамДокумента.Должность;
	Движение.ВидРасчета				= ВыборкаПоСтрокамДокумента.ВидРасчета;
	
	// Ресурсы
	Движение.Показатель1			= ВыборкаПоСтрокамДокумента.Показатель1;
	Движение.Показатель2			= ВыборкаПоСтрокамДокумента.Показатель2;
	Движение.Показатель3			= ВыборкаПоСтрокамДокумента.Показатель3;
	Движение.Валюта1				= ВыборкаПоСтрокамДокумента.Валюта1;
	Движение.Валюта2				= ВыборкаПоСтрокамДокумента.Валюта2;
	Движение.Валюта3				= ВыборкаПоСтрокамДокумента.Валюта3;
		
КонецПроцедуры // ДобавитьСтрокуВСхемуМотивации

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

		// Движения стоит добавлять, если в проведении еще не отказано (отказ = ложь)
		Если НЕ Отказ Тогда

			// В циклах по строкам табличных частей будем добавлять информацию в движения регистров
	        ВыборкаПоСтрокиМотивации = СформироватьЗапросПоСхемыМотивации(Режим).Выбрать();
	        Пока ВыборкаПоСтрокиМотивации.Следующий() Цикл 

				// проверим очередную строку табличной части
				ПроверитьЗаполнениеСтрокиМотивации(ВыборкаПоШапкеДокумента, ВыборкаПоСтрокиМотивации, Отказ, Заголовок);

				// Движения стоит записывать, если в проведении еще не отказано (отказ =ложь)
				Если Не Отказ Тогда
					ДобавитьСтрокуВСхемуМотивации(ВыборкаПоШапкеДокумента, ВыборкаПоСтрокиМотивации);
				КонецЕсли;

			КонецЦикла;
			
		КонецЕсли;
	
	КонецЕсли;
	
КонецПроцедуры


Процедура ПередЗаписью(Отказ, РежимЗаписи, РежимПроведения)
	Если ОбменДанными.Загрузка  Тогда
		Возврат;
	КонецЕсли;


	 
	мУдалятьДвижения = НЕ ЭтоНовый();
	
КонецПроцедуры // ПередЗаписью

Процедура ОбработкаУдаленияПроведения(Отказ)

	
	ОбщегоНазначения.УдалитьДвиженияРегистратора(ЭтотОбъект, Отказ);

КонецПроцедуры // ОбработкаУдаленияПроведения




