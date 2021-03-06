
// Запись перерасчетов
// Процедура предназначена для записи наборов записей рег-ов ЗаполнениеПлановыхНачислений для тех документов, 
// которые затронуты данным набором записей регистра
// Если набор записей ПлановыеНачисленияРаботниковОрганизаций записывается с датами, после которых проводились 
// начисления зарплаты (по тем же физлицам, по которым записываем начисления), то нужно переначислить 
// зарплату (т.е. перезаполнить соответствующие документы Начисление зарплаты)
// 
// Параметры:
//	нет
// Возвращаемое значение:
//	нет
//
Процедура ЗаписьПерерасчетовВРегистрЗаполнениеПлановыхНачислений()
	
	// Проверка нужны ли перерасчеты по док. НачислениеЗарплатыРаботникамОрганизаций	
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("Регистратор", Отбор.Регистратор.Значение);
	
	Запрос.Текст = "
	|ВЫБРАТЬ РАЗРЕШЕННЫЕ РАЗЛИЧНЫЕ
	|	Расчеты.Регистратор КАК ОбъектЗаполнения,
	|	Расчеты.Сотрудник, // если замена, то тут будет сотрудник, который заменял в других случаях основное назначение
	|	Расчеты.ПериодРегистрации,
	|	Расчеты.Организация
	|ИЗ
	|	РегистрСведений.ПлановыеНачисленияРаботниковОрганизаций КАК Начисления
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ РегистрРасчета.ОсновныеНачисленияРаботниковОрганизаций КАК Расчеты
	|			ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.ЗаполнениеПлановыхНачислений КАК Перерасчеты
	|			ПО Расчеты.Регистратор = Перерасчеты.ОбъектЗаполнения
	|				И Расчеты.Сотрудник = Перерасчеты.Сотрудник
	|		ПО Начисления.Период <= Расчеты.ПериодДействияКонец
	|			И Начисления.Сотрудник = Расчеты.Назначение
	|ГДЕ
	|	Начисления.Регистратор = &Регистратор
	|	И Перерасчеты.ОбъектЗаполнения ЕСТЬ NULL 
	|	И Расчеты.Регистратор ССЫЛКА Документ.НачислениеЗарплатыРаботникамОрганизаций
	|
	|ОБЪЕДИНИТЬ ВСЕ
	|ВЫБРАТЬ РАЗЛИЧНЫЕ
	|	Расчеты.Регистратор КАК ОбъектЗаполнения,
	|	Расчеты.Сотрудник, // если замена, то тут будет сотрудник, который заменял в других случаях основное назначение
	|	Расчеты.ПериодРегистрации,
	|	Расчеты.Организация
	|ИЗ
	|	РегистрСведений.ПлановыеНачисленияРаботниковОрганизаций КАК Начисления
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ РегистрРасчета.РасчетСреднегоЗаработка КАК Расчеты
	|			ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.ЗаполнениеПлановыхНачислений КАК Перерасчеты
	|			ПО Расчеты.Регистратор = Перерасчеты.ОбъектЗаполнения
	|				И Расчеты.Сотрудник = Перерасчеты.Сотрудник
	|		ПО Начисления.Период <= Расчеты.БазовыйПериодКонец
	|			И Начисления.Сотрудник = Расчеты.Сотрудник
	|			И Расчеты.ВидРасчета = ЗНАЧЕНИЕ(ПланВидовРасчета.СреднийЗаработок.ПоОкладу)
	|ГДЕ
	|	Начисления.Регистратор = &Регистратор
	|	И Перерасчеты.ОбъектЗаполнения ЕСТЬ NULL 
	|
	|УПОРЯДОЧИТЬ ПО
	|	ОбъектЗаполнения";
	
	Выборка = Запрос.Выполнить().Выбрать();
	ПроведениеРасчетов.ДописатьПерерасчетыВЗаполнениеПлановыхНачислений(Выборка);
	
	
	// Проверка нужны ли перерасчеты по док. ОплатаСверхурочныхЧасов
	// и док. ОплатаПраздничныхИВыходныхДнейОрганизаций
	// если изменился оклад (основное начисление), то надо бы пересчитать праздничные и сверхурочные
	Запрос.Текст = 
	"ВЫБРАТЬ РАЗРЕШЕННЫЕ РАЗЛИЧНЫЕ
	|	Расчеты.Регистратор КАК Регистратор,
	|	Расчеты.Сотрудник,
	|	Расчеты.Назначение,
	|	Расчеты.Организация
	|ИЗ
	|	РегистрСведений.ПлановыеНачисленияРаботниковОрганизаций КАК Начисления
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ РегистрРасчета.ОсновныеНачисленияРаботниковОрганизаций КАК Расчеты
	|			ЛЕВОЕ СОЕДИНЕНИЕ РегистрРасчета.ОсновныеНачисленияРаботниковОрганизаций.ПерерасчетОсновныхНачислений КАК Перерасчеты
	|			ПО Расчеты.Регистратор = Перерасчеты.ОбъектПерерасчета
	|				И Расчеты.Сотрудник = Перерасчеты.Сотрудник
	|				И Расчеты.Назначение = Перерасчеты.Назначение
	|				И (Перерасчеты.ВидРасчета = ЗНАЧЕНИЕ(ПланВидовРасчета.ОсновныеНачисленияОрганизаций.ПустаяСсылка))
	|		ПО Начисления.Период <= Расчеты.ПериодДействияКонец
	|			И Начисления.Сотрудник = Расчеты.Назначение
	|ГДЕ
	|	Начисления.Регистратор = &Регистратор
	|	И Начисления.ВидРасчетаИзмерение = НЕОПРЕДЕЛЕНО
	|	И Перерасчеты.ОбъектПерерасчета ЕСТЬ NULL 
	|	И (Расчеты.Регистратор ССЫЛКА Документ.ОплатаСверхурочныхЧасов
	|			ИЛИ Расчеты.Регистратор ССЫЛКА Документ.ОплатаПраздничныхИВыходныхДнейОрганизаций)
	|
	|УПОРЯДОЧИТЬ ПО
	|	Регистратор";
	
	Выборка = Запрос.Выполнить().Выбрать();
	ПроведениеРасчетов.ДописатьПерерасчетыОсновныхНачислений(Выборка);
	
КонецПроцедуры

Процедура ПередЗаписью(Отказ, Замещение)
	
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	
	Если Замещение Тогда
		// запишем перерасчеты по тем записям, которые сейчас будут замещены
		ЗаписьПерерасчетовВРегистрЗаполнениеПлановыхНачислений();
	КонецЕсли;
	
КонецПроцедуры

Процедура ПриЗаписи(Отказ, Замещение)
	
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	
	// запишем перерасчеты по новым записям
	ЗаписьПерерасчетовВРегистрЗаполнениеПлановыхНачислений();
	
КонецПроцедуры
