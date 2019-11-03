﻿
////////////////////////////////////////////////////////////////////////////////
// ЭКСПОРТНЫЕ ПРОЦЕДУРЫ И ФУНКЦИИ

#Если Клиент Тогда
	
// Процедура печати компетенции
//
// Параметры
//  нет
//
Функция Печать() Экспорт 

	ТабДокумент = Новый ТабличныйДокумент;
	ТабДокумент.ИмяПараметровПечати = "ПАРАМЕТРЫ_ПЕЧАТИ_Компетенции";
	Макет = ПолучитьМакет("Макет");
	
	// печать производится на языке, указанном в настройках пользователя
	КодЯзыкаПечать = Локализация.ПолучитьЯзыкФормированияПечатныхФорм(УправлениеПользователями.ПолучитьЗначениеПоУмолчанию(глЗначениеПеременной("глТекущийПользователь"), "РежимФормированияПечатныхФорм"));
	Макет.КодЯзыкаМакета = КодЯзыкаПечать;
	
	ОбластьМакета = Макет.ПолучитьОбласть("Шапка");
	ОбластьМакета.Параметры.Компетенция = Наименование;
	ОбластьМакета.Параметры.Описание 	= ОписаниеКомпетенции; 
	ОбластьМакета.Параметры.Шкала       = ШкалаОценок.Наименование;
	ТабДокумент.Вывести(ОбластьМакета);
	ОбластьМакета = Макет.ПолучитьОбласть("Оценка");
	
	Запрос = Новый Запрос(
	"ВЫБРАТЬ
	|	КомпетенцииРаботниковОписаниеОценок.Оценка.Наименование КАК Оценка,
	|	КомпетенцииРаботниковОписаниеОценок.ОписаниеОценки КАК Описание
	|ИЗ
	|	Справочник.КомпетенцииРаботников.ОписаниеОценок КАК КомпетенцииРаботниковОписаниеОценок
	|
	|ГДЕ
	|	КомпетенцииРаботниковОписаниеОценок.Ссылка = &Ссылка И
	|	КомпетенцииРаботниковОписаниеОценок.Оценка <> &ПустаяОценка
	|
	|УПОРЯДОЧИТЬ ПО
	|	КомпетенцииРаботниковОписаниеОценок.НомерСтроки");
	
	Запрос.УстановитьПараметр("Ссылка",Ссылка);
	Запрос.УстановитьПараметр("ПустаяОценка",Справочники.СоставОценочныхШкалКомпетенций.ПустаяСсылка());
	Выборка = Запрос.Выполнить().Выбрать();
	Пока Выборка.Следующий() Цикл
	    ОбластьМакета.Параметры.Заполнить(Выборка);
		ТабДокумент.Вывести(ОбластьМакета);
	КонецЦикла;
	
	УниверсальныеМеханизмы.НапечататьДокумент(ТабДокумент,,, НСтр("ru='Данные по: ';uk='Дані по: '") + Наименование);

КонецФункции // Печать()

#КонецЕсли

// Процедура создает список оценок для ввода к ним описаний.
//
// Параметры: 
//  Нет.
//
// Возвращаемое значение:
//  Нет.
//
Процедура ЗаполнитьОценки() Экспорт
	
	Запрос = Новый Запрос(
	"ВЫБРАТЬ
	|	СоставОценочныхШкалКомпетенций.Ссылка,
	|	СоставОценочныхШкалКомпетенций.ПриоритетОценки КАК ПриоритетОценки
	|ИЗ
	|	Справочник.СоставОценочныхШкалКомпетенций КАК СоставОценочныхШкалКомпетенций
	|
	|ГДЕ
	|	СоставОценочныхШкалКомпетенций.Владелец = &Владелец
	|
	|УПОРЯДОЧИТЬ ПО
	|	ПриоритетОценки УБЫВ");
	
	Запрос.УстановитьПараметр("Владелец",ШкалаОценок);
	Выборка = Запрос.Выполнить().Выбрать();
	Если Выборка.Количество() = 0 Тогда 
		ТекстСообщения = НСтр("ru='В шкале оценок: ""';uk='У шкалі оцінок: ""'")+ ШкалаОценок.Наименование +НСтр("ru='"" не введен список наименований оценок';uk='"" не введений список найменувань оцінок'"); 
		Сообщить (ТекстСообщения);
	    Возврат;
	КонецЕсли;
	
	Если ОписаниеОценок.Количество() > 0 Тогда 
		
		// Перестройка шкалы оценок. 
		// Найдем и удалим все строки таблицы, где не заполнено описание.
		МассивСтрок = ОписаниеОценок.НайтиСтроки(Новый Структура("ОписаниеОценки",""));
		Для каждого СтрокаДляУдаления Из МассивСтрок Цикл
			ОписаниеОценок.Удалить(СтрокаДляУдаления);
		КонецЦикла;
		
		// "Обнулим" оставшиеся строки.
		ТЗ = ОписаниеОценок.Выгрузить();
		ТЗ.ЗаполнитьЗначения(0,"ПриоритетОценки");
		ТЗ.ЗаполнитьЗначения(Справочники.ШкалыОценокКомпетенций.ПустаяСсылка(),"Оценка");
		ОписаниеОценок.Загрузить(ТЗ);
	КонецЕсли;
	
	// Добавляем оценки в список.
	Пока Выборка.Следующий() Цикл
		СтрокаТЧ = ОписаниеОценок.Добавить();
		СтрокаТЧ.Оценка 		 = Выборка.Ссылка;
		СтрокаТЧ.ПриоритетОценки = Выборка.ПриоритетОценки;
	КонецЦикла;
	
КонецПроцедуры // ЗаполнитьОценки

////////////////////////////////////////////////////////////////////////////////
// ПРОЦЕДУРЫ - ОБРАБОТЧИКИ СОБЫТИЙ 

// проверяет заполнение основных реквизитов перед записью
Процедура ПриЗаписи(Отказ)
	
	Если НЕ ОбменДанными.Загрузка Тогда
		
		Если НЕ ЗначениеЗаполнено(Наименование) Тогда 
			ОбщегоНазначения.СообщитьОбОшибке(НСтр("ru='Не введено наименование компетенции!';uk='Не введено найменування компетенції!'"));
			Отказ = Истина;
		КонецЕсли;
		
		Если Не ЭтоГруппа И НЕ ЗначениеЗаполнено(ШкалаОценок) Тогда 
			ОбщегоНазначения.СообщитьОбОшибке(НСтр("ru='Не выбрана шкала оценки!';uk='Не обрана шкала оцінки!'"));
			Отказ = Истина;
		КонецЕсли;
		
	КонецЕсли;
	
КонецПроцедуры // ПередЗаписью

