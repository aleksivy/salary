// Функция возвращает список значений права, установленных для пользователя.
// Если количество значений меньше количество доступных ролей, то возвращается значение по умолчанию
//
// Параметры:
//  Право               - право, для которого определяются значения
//  ЗначениеПоУмолчанию - значение по умолчанию для передаваемого права (возвращается в случае
//                        отсутствия значений в регистре сведений)
//
// Возвращаемое значение:
//  Список всех значений, установленных наборам прав (ролям), доступных пользователю
//
Функция ПолучитьЗначениеПраваПользователя(Право, ЗначениеПоУмолчанию = Неопределено, Пользователь = Неопределено) Экспорт

	ВозвращаемыеЗначения = Новый Массив;
	СписокНабораПрав = ПолныеПрава.ПолучитьСписокНабораПрав(Пользователь);

	Запрос = Новый Запрос;

	Запрос.УстановитьПараметр("НаборПрав"        , СписокНабораПрав);
	Запрос.УстановитьПараметр("ПравоПользователя", Право);

	Запрос.Текст = 
	"ВЫБРАТЬ
	|	Значение
	|ИЗ
	|	РегистрСведений.ЗначенияПравПользователя КАК РегистрЗначениеПрав
	|
	|ГДЕ
	|	Право = &ПравоПользователя
	| И НаборПрав В(&НаборПрав)
	|
	|";

	Выборка = Запрос.Выполнить().Выбрать();

	Если Выборка.Количество() < СписокНабораПрав.Количество() Тогда
		ВозвращаемыеЗначения.Добавить(ЗначениеПоУмолчанию);
	КонецЕсли;

	Пока Выборка.Следующий() Цикл
		Если ВозвращаемыеЗначения.Найти(Выборка.Значение) = Неопределено Тогда
			ВозвращаемыеЗначения.Добавить(Выборка.Значение);
		КонецЕсли;
	КонецЦикла;

	Возврат ВозвращаемыеЗначения;

КонецФункции // ПолучитьЗначениеПраваПользователя()

// Функция возвращает право печатать непроведенные документы.
//
// Параметры:
//  Проведен     - признак проведен ли документ (если документ не проводной,
//                 то либо параметр опускается, либо равен Истина)
//
// Возвращаемое значение:
//  Истина - если можно печатать, иначе Ложь.
//
Функция РазрешитьПечатьНепроведенныхДокументов(Проведен = Истина) Экспорт

	Если Проведен Тогда
		Возврат Истина;
	КонецЕсли;

	РазрешеноПечатать = ПолучитьЗначениеПраваПользователя(ПланыВидовХарактеристик.ПраваПользователей.ПечатьНепроведенныхДокументов, Ложь);
	Если РазрешеноПечатать.Количество() = 0 Тогда
		Возврат Ложь;
	ИначеЕсли РазрешеноПечатать.Количество() > 1 Тогда
		Возврат Истина;
	Иначе
		Возврат РазрешеноПечатать[0];
	КонецЕсли;

КонецФункции // РазрешитьПечатьНепроведенныхДокументов()

// Функция возвращает признак защищать таблицу от редактирования или нет.
//
// Параметры:
//  нет.
//
// Возвращаемое значение:
//  Истина - если таблицу необходимо защитить от редактирования, иначе Ложь.
//
Функция ЗащитаТаблиц() Экспорт

	РазрешеноРедактирование = ПолучитьЗначениеПраваПользователя(ПланыВидовХарактеристик.ПраваПользователей.РедактированиеТаблиц, Истина);

	Если (РазрешеноРедактирование.Количество() = 0)
	   ИЛИ (РазрешеноРедактирование.Количество() > 1) Тогда
		Возврат Ложь;
	Иначе
		Возврат НЕ РазрешеноРедактирование[0];
	КонецЕсли;

КонецФункции // ЗащитаТаблиц()

 // Функция возвращает право изменять пользователя в календаре пользователя
//
// Параметры:
//  Нет
//
// Возвращаемое значение:
//  Истина - если можно изменять пользователя в календаря пользователя
//
Функция РазрешитьИзменениеПользователяВКалендареПользователя(Пользователь = Неопределено) Экспорт

	Разрешено = ПолучитьЗначениеПраваПользователя(ПланыВидовХарактеристик.ПраваПользователей.ИзменениеПользователяВКалендареПользователя, Ложь, Пользователь);
	Если Разрешено.Количество() = 0 Тогда
		Возврат Ложь;
	ИначеЕсли Разрешено.Количество() > 1 Тогда
		Возврат Истина;
	Иначе
		Возврат Разрешено[0];
	КонецЕсли;

КонецФункции // РазрешитьИзменениеПользователяВКалендареПользователя()

 // Функция возвращает право редактировать КИ в списке
//
// Параметры:
//  Нет
//
// Возвращаемое значение:
//  Истина - если можно редактировать КИ в списке
//
Функция РазрешитьРедактированиеКИвСписке(Пользователь = Неопределено) Экспорт

	Разрешено = ПолучитьЗначениеПраваПользователя(ПланыВидовХарактеристик.ПраваПользователей.РазрешитьРедактированиеКИвСписке, Ложь, Пользователь);
	Если Разрешено.Количество() = 0 Тогда
		Возврат Ложь;
	ИначеЕсли Разрешено.Количество() > 1 Тогда
		Возврат Истина;
	Иначе
		Возврат Разрешено[0];
	КонецЕсли;

КонецФункции // ЗапретитьРедактированиеКИвСписке()

