﻿////////////////////////////////////////////////////////////////////////////////
// ЭКСПОРТНЫЕ ПРОЦЕДУРЫ И ФУНКЦИИ

#Если Клиент Тогда

// Процедура построения справки на кандидата.
//
// Параметры: 
//  ФизЛицо        - Тип Элемент справочника "ФизическиеЛица"	
//  Подразделение  - Тип Элемент справочника "Подразделения"
//  Должность      - Тип Элемент справочника "Должности"
//
//
Процедура ПостроитьСправку(ТабличныйДокумент, ТекущиеДанные) Экспорт
	
	КодЯзыкаПечати = ЛокализацияПовтИсп.ПолучитьЯзыкФормированияПечатныхФормОтчетов();
	
	ТабличныйДокумент.Очистить();
	
	Если ТекущиеДанные = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	// Вывод шапки
	Макет = ПолучитьМакет("Макет");
	Макет.КодЯзыкаМакета = КодЯзыкаПечати;

	Область = Макет.ПолучитьОбласть("Шапка");
	
	Область.Параметры.Работник		= ТекущиеДанные.Сотрудник;
	
	ТабличныйДокумент.Вывести(Область);
	
	// Данные для списка не оцененых компетенций.
	Запрос = Новый Запрос;
	
	Запрос.УстановитьПараметр("Сотрудник", ТекущиеДанные.Сотрудник);
	
	Запрос.Текст =
	"ВЫБРАТЬ
	|	АттестацияРаботникаСписокКомпетенций.Компетенция КАК Компетенция,
	|	АттестацияРаботникаСписокКомпетенций.Ссылка.Ссылка КАК Документ,
	|	АттестацияРаботникаСписокКомпетенций.Ссылка.Ответственный,
	|	АттестацияРаботникаСписокКомпетенций.Ссылка.Дата
	|ИЗ
	|	Справочник.СотрудникиОрганизаций КАК СотрудникиОрганизаций
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ Документ.АттестацияРаботника.СписокКомпетенций КАК АттестацияРаботникаСписокКомпетенций
	|		ПО СотрудникиОрганизаций.Физлицо = АттестацияРаботникаСписокКомпетенций.Ссылка.Физлицо
	|ГДЕ
	|	(НЕ АттестацияРаботникаСписокКомпетенций.Ссылка.Проведен)
	|	И (НЕ АттестацияРаботникаСписокКомпетенций.Ссылка.ПометкаУдаления)
	|	И СотрудникиОрганизаций.Ссылка = &Сотрудник";
	
	НеоцененныеКомпетенции = Запрос.Выполнить().Выбрать();

	// Вывод не оцененых компетенций.
	
	Область = Макет.ПолучитьОбласть("СтрокаСправки");
	
	Если НеоцененныеКомпетенции.Количество() = 0 Тогда
		Область.Параметры.Компетенция   = НСтр("ru='Нет компетенций';uk='Немає компетенцій'" ,КодЯзыкаПечати);
		Область.Параметры.Ответственный = "--";
		Область.Параметры.Дата          = "--";
		Область.Параметры.Документ      = НСтр("ru='Нет документов';uk='Немає документів'" ,КодЯзыкаПечати);
		ТабличныйДокумент.Вывести(Область);
		
	Иначе
		
		Пока НеоцененныеКомпетенции.Следующий() Цикл
		
			ЗаполнитьЗначенияСвойств(Область.Параметры, НеоцененныеКомпетенции);
			ТабличныйДокумент.Вывести(Область);
			
		КонецЦикла;
		
	КонецЕсли;
	
	// Вывод заголовка для последних оценок компетнций.
	Область = Макет.ПолучитьОбласть("ШапкаДва");
	ТабличныйДокумент.Вывести(Область);
	
	// Данные для списка последних оцененок компетенций.
	
	Запрос.Текст =
	"ВЫБРАТЬ
	|	ОценкиКомпетенцийРаботников.Компетенция,
	|	ОценкиКомпетенцийРаботников.Оценка,
	|	ОценкиКомпетенцийРаботников.Период КАК Дата,
	|	ОценкиКомпетенцийРаботников.Регистратор КАК Документ
	|ИЗ
	|	РегистрСведений.ОценкиКомпетенцийРаботников.СрезПоследних(
	|			,
	|			Физлицо В
	|				(ВЫБРАТЬ
	|					СотрудникиОрганизаций.Физлицо
	|				ИЗ
	|					Справочник.СотрудникиОрганизаций КАК СотрудникиОрганизаций
	|				ГДЕ
	|					СотрудникиОрганизаций.Ссылка = &Сотрудник)) КАК ОценкиКомпетенцийРаботников";
	
	ОцененныеКомпетенции = Запрос.Выполнить().Выбрать();

	// Вывод последних оцененок компетенций
	Область = Макет.ПолучитьОбласть("СтрокаСправкиДва");
	
	Если ОцененныеКомпетенции.Количество() = 0 Тогда
		Область.Параметры.Компетенция	= НСтр("ru='Нет компетенций';uk='Немає компетенцій'" ,КодЯзыкаПечати);
		Область.Параметры.Оценка		= "--";
		Область.Параметры.Дата			= "--";
		Область.Параметры.Документ		= НСтр("ru='Нет документов';uk='Немає документів'" ,КодЯзыкаПечати);
		ТабличныйДокумент.Вывести(Область);
		
	Иначе

		Пока ОцененныеКомпетенции.Следующий() Цикл
			
			ЗаполнитьЗначенияСвойств(Область.Параметры, ОцененныеКомпетенции);
			ТабличныйДокумент.Вывести(Область);
			
		КонецЦикла;
		
	КонецЕсли;
	
КонецПроцедуры // ПостроитьСправку()

// Процедура фрмирует диаграмму "Распределения оценок". 
//
// Параметры
//  Нет  
//  	
Процедура СформироватьДиаграмму(Диаграмма, Компетенция, НачПериода, КонПериода, Должность) Экспорт
	
	Если НЕ ЗначениеЗаполнено(Компетенция) Тогда
		Возврат;
	КонецЕсли;
	
	Запрос = Новый Запрос;
	
	Запрос.УстановитьПараметр("Компетенция",			Компетенция);
	Запрос.УстановитьПараметр("ШкалаОценок",			Компетенция.ШкалаОценок);
	
	Запрос.УстановитьПараметр("НачПериода",				НачПериода);
	Запрос.УстановитьПараметр("КонПериода",				КонПериода);
	
	Запрос.УстановитьПараметр("Должность",				Должность);
	
	Запрос.Текст =
	"ВЫБРАТЬ
	|	Шкала.Представление,
	|	ВЫРАЗИТЬ(Шкала.ВесОценки * ВЫБОР
	|			КОГДА ИтогиОжидания.ВесОценки = 0
	|				ТОГДА 1
	|			ИНАЧЕ ИтогиРезультат.Количество / ИтогиОжидания.ВесОценки
	|		КОНЕЦ КАК ЧИСЛО(3, 0)) КАК Ожидания,
	|	ЕСТЬNULL(Данные.Количество, 0) КАК Результат
	|ИЗ
	|	(ВЫБРАТЬ
	|		СоставОценочныхШкалКомпетенций.Наименование КАК Наименование,
	|		СоставОценочныхШкалКомпетенций.Ссылка КАК Ссылка,
	|		СоставОценочныхШкалКомпетенций.ПриоритетОценки КАК ПриоритетОценки,
	|		СоставОценочныхШкалКомпетенций.Представление КАК Представление,
	|		Веса.ВесОценки КАК ВесОценки
	|	ИЗ
	|		Справочник.СоставОценочныхШкалКомпетенций КАК СоставОценочныхШкалКомпетенций
	|			ЛЕВОЕ СОЕДИНЕНИЕ (ВЫБРАТЬ
	|				КомпетенцииРаботниковОписаниеОценок.Оценка КАК Оценка,
	|				КомпетенцииРаботниковОписаниеОценок.ВесОценки КАК ВесОценки
	|			ИЗ
	|				Справочник.КомпетенцииРаботников.ОписаниеОценок КАК КомпетенцииРаботниковОписаниеОценок
	|			ГДЕ
	|				КомпетенцииРаботниковОписаниеОценок.Ссылка = &Компетенция) КАК Веса
	|			ПО СоставОценочныхШкалКомпетенций.Ссылка = Веса.Оценка
	|	ГДЕ
	|		СоставОценочныхШкалКомпетенций.Владелец = &ШкалаОценок) КАК Шкала
	|		ЛЕВОЕ СОЕДИНЕНИЕ (ВЫБРАТЬ
	|			ОценкиКомпетенцийРаботников.Оценка КАК Оценка,
	|			СУММА(1) КАК Количество
	|		ИЗ
	|			РегистрСведений.ОценкиКомпетенцийРаботников.СрезПоследних(
	|				&КонПериода,
	|				Период МЕЖДУ &НачПериода И &КонПериода
	|				    И Компетенция = &Компетенция) КАК ОценкиКомпетенцийРаботников
	|				ВНУТРЕННЕЕ СОЕДИНЕНИЕ РегистрСведений.Работники.СрезПоследних(&КонПериода, ) КАК Работники
	|				ПО Работники.ФизЛицо = ОценкиКомпетенцийРаботников.ФизЛицо
	|		ГДЕ
	|			Работники.ПричинаИзмененияСостояния <> ЗНАЧЕНИЕ(Перечисление.ПричиныИзмененияСостояния.Увольнение)
	|			//УСЛОВИЕ_ДОЛЖНОСТЬ
	|		
	|		СГРУППИРОВАТЬ ПО
	|			ОценкиКомпетенцийРаботников.Оценка) КАК Данные
	|		ПО Шкала.Ссылка = Данные.Оценка,
	|	(ВЫБРАТЬ
	|		СУММА(1) КАК Количество
	|	ИЗ
	|		РегистрСведений.ОценкиКомпетенцийРаботников.СрезПоследних(
	|			&КонПериода,
	|			Период МЕЖДУ &НачПериода И &КонПериода
	|			    И Компетенция = &Компетенция) КАК ОценкиКомпетенцийРаботников
	|			ВНУТРЕННЕЕ СОЕДИНЕНИЕ РегистрСведений.Работники.СрезПоследних(&КонПериода, ) КАК Работники
	|			ПО Работники.ФизЛицо = ОценкиКомпетенцийРаботников.ФизЛицо
	|	ГДЕ
	|		Работники.ПричинаИзмененияСостояния <> ЗНАЧЕНИЕ(Перечисление.ПричиныИзмененияСостояния.Увольнение)
	|		//УСЛОВИЕ_ДОЛЖНОСТЬ
	|) КАК ИтогиРезультат,
	|	(ВЫБРАТЬ
	|		СУММА(КомпетенцииРаботниковОписаниеОценок.ВесОценки) КАК ВесОценки
	|	ИЗ
	|		Справочник.КомпетенцииРаботников.ОписаниеОценок КАК КомпетенцииРаботниковОписаниеОценок
	|	ГДЕ
	|		КомпетенцииРаботниковОписаниеОценок.Ссылка = &Компетенция) КАК ИтогиОжидания
	|
	|УПОРЯДОЧИТЬ ПО
	|	Шкала.ПриоритетОценки";
	
	Если ЗначениеЗаполнено(Должность) Тогда
		Запрос.Текст = СтрЗаменить(Запрос.Текст, "//УСЛОВИЕ_ДОЛЖНОСТЬ", "И Работники.Должность.Должность = &Должность");
	КонецЕсли;
	
	Диаграмма.СерииВСтроках = Ложь;
	Диаграмма.ОтображатьЗаголовок = Ложь;
	
	Диаграмма.ОбластьЗаголовка.Текст = "Распределение оценок компетенции " + Компетенция.Наименование;
	Диаграмма.ИсточникДанных = Запрос.Выполнить();
	
КонецПроцедуры  // СформироватьДиаграмму()

#КонецЕсли

////////////////////////////////////////////////////////////////////////////////
// ОПЕРАТОРЫ ОСНОВНОЙ ПРОГРАММЫ
