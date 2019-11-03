﻿////////////////////////////////////////////////////////////////////////////////
// ПЕРЕМЕННЫЕ МОДУЛЯ

Перем мСписокРасчетовПоИсполнительнымЛистам Экспорт;


////////////////////////////////////////////////////////////////////////////////
// ПРОЦЕДУРЫ И ФУНКЦИИ ДЛЯ ОБЕСПЕЧЕНИЯ ПРОВЕДЕНИЯ ДОКУМЕНТА

Функция СформироватьЗапросПоШапке(Режим)

	Запрос = Новый Запрос;

	// Установим параметры запроса
	Запрос.УстановитьПараметр("ДокументСсылка" , Ссылка);
	Запрос.Текст =
	"ВЫБРАТЬ
	|	ВводСведенийОПлановыхУдержанияхРаботниковОрганизаций.Дата,
	|	ВводСведенийОПлановыхУдержанияхРаботниковОрганизаций.Организация,
	|	ВводСведенийОПлановыхУдержанияхРаботниковОрганизаций.Ссылка
	|ИЗ
	|	Документ.ВводСведенийОПлановыхУдержанияхРаботниковОрганизаций КАК ВводСведенийОПлановыхУдержанияхРаботниковОрганизаций
	|ГДЕ
	|	ВводСведенийОПлановыхУдержанияхРаботниковОрганизаций.Ссылка = &ДокументСсылка";

	Возврат Запрос.Выполнить();

КонецФункции // СформироватьЗапросПоШапке()

Функция СформироватьЗапросПоРаботникиОрганизации(Режим)

	Запрос = Новый Запрос;
	
	// Установим параметры запроса
	Запрос.УстановитьПараметр("ДокументСсылка", Ссылка);
	Запрос.УстановитьПараметр("Организация", Организация);
	Запрос.УстановитьПараметр("ИсполнительныйЛист", ПланыВидовРасчета.УдержанияОрганизаций.ИЛФиксированнойСуммой);
	Запрос.УстановитьПараметр("МассивСпоcобовРасчетаНеТребующихВалюты",ПроведениеРасчетов.ПолучитьСписокСпособовРасчетаНеТребующихУказанияВалюты());
	Запрос.УстановитьПараметр("ВалютаРегУчета", Константы.ВалютаРегламентированногоУчета.Получить());
	
	Запрос.УстановитьПараметр("ВсеИсполнительныеЛисты", мСписокРасчетовПоИсполнительнымЛистам);
	
		МенеджерВТ = Новый МенеджерВременныхТаблиц;
	Запрос.МенеджерВременныхТаблиц = МенеджерВТ;	
	
	// получим временную таблицу с показателями начислений
	Запрос.Текст = 
	"ВЫБРАТЬ РАЗЛИЧНЫЕ
	|	Удержания.ВидРасчета				КАК ВидРасчета,
	|	МАКСИМУМ(Показатели.НомерСтроки)			КАК КоличествоПоказателей,
	|	Показатели1.Показатель.Предопределенный		КАК Показатель1Предопределенный,
	|	Показатели1.Показатель.Наименование			КАК Показатель1Наименование,
	|	Показатели1.Показатель.ТипПоказателя		КАК Показатель1ТипПоказателя,
	|	Показатели1.Показатель.ВозможностьИзменения КАК Показатель1ВозможностьИзменения,
	|	Показатели2.Показатель.Предопределенный		КАК Показатель2Предопределенный,
	|	Показатели2.Показатель.Наименование			КАК Показатель2Наименование,
	|	Показатели2.Показатель.ТипПоказателя		КАК Показатель2ТипПоказателя,
	|	Показатели2.Показатель.ВозможностьИзменения КАК Показатель2ВозможностьИзменения,
	|	Показатели3.Показатель.Предопределенный		КАК Показатель3Предопределенный,
	|	Показатели3.Показатель.Наименование			КАК Показатель3Наименование,
	|	Показатели3.Показатель.ТипПоказателя 		КАК Показатель3ТипПоказателя,
	|	Показатели3.Показатель.ВозможностьИзменения КАК Показатель3ВозможностьИзменения,
	|	Показатели4.Показатель.Предопределенный		КАК Показатель4Предопределенный,
	|	Показатели4.Показатель.Наименование 		КАК Показатель4Наименование,
	|	Показатели4.Показатель.ТипПоказателя 		КАК Показатель4ТипПоказателя,
	|	Показатели4.Показатель.ВозможностьИзменения КАК Показатель4ВозможностьИзменения,
	|	Показатели5.Показатель.Предопределенный		КАК Показатель5Предопределенный,
	|	Показатели5.Показатель.Наименование 		КАК Показатель5Наименование,
	|	Показатели5.Показатель.ТипПоказателя 		КАК Показатель5ТипПоказателя,
	|	Показатели5.Показатель.ВозможностьИзменения КАК Показатель5ВозможностьИзменения,
	|	Показатели6.Показатель.Предопределенный		КАК Показатель6Предопределенный,
	|	Показатели6.Показатель.Наименование 		КАК Показатель6Наименование,
	|	Показатели6.Показатель.ТипПоказателя 		КАК Показатель6ТипПоказателя,
	|	Показатели6.Показатель.ВозможностьИзменения КАК Показатель6ВозможностьИзменения,
	|	Показатели1.ЗапрашиватьПриКадровыхПеремещениях КАК Показатель1ЗапрашиватьПриКадровыхПеремещениях,
	|	Показатели2.ЗапрашиватьПриКадровыхПеремещениях КАК Показатель2ЗапрашиватьПриКадровыхПеремещениях,
	|	Показатели3.ЗапрашиватьПриКадровыхПеремещениях КАК Показатель3ЗапрашиватьПриКадровыхПеремещениях,
	|	Показатели4.ЗапрашиватьПриКадровыхПеремещениях КАК Показатель4ЗапрашиватьПриКадровыхПеремещениях,
	|	Показатели5.ЗапрашиватьПриКадровыхПеремещениях КАК Показатель5ЗапрашиватьПриКадровыхПеремещениях,
	|	Показатели6.ЗапрашиватьПриКадровыхПеремещениях КАК Показатель6ЗапрашиватьПриКадровыхПеремещениях
	|ПОМЕСТИТЬ ВТПоказателиУдержаний
	|ИЗ
	|	Документ.ВводСведенийОПлановыхУдержанияхРаботниковОрганизаций.Удержания КАК Удержания
	|		ЛЕВОЕ СОЕДИНЕНИЕ ПланВидовРасчета.УдержанияОрганизаций.Показатели КАК Показатели
	|		ПО Удержания.ВидРасчета = Показатели.Ссылка
	|		ЛЕВОЕ СОЕДИНЕНИЕ ПланВидовРасчета.УдержанияОрганизаций.Показатели КАК Показатели1
	|		ПО Удержания.ВидРасчета = Показатели1.Ссылка
	|			И (Показатели1.НомерСтроки = 1)
	|		ЛЕВОЕ СОЕДИНЕНИЕ ПланВидовРасчета.УдержанияОрганизаций.Показатели КАК Показатели2
	|		ПО Удержания.ВидРасчета = Показатели2.Ссылка
	|			И (Показатели2.НомерСтроки = 2)
	|		ЛЕВОЕ СОЕДИНЕНИЕ ПланВидовРасчета.УдержанияОрганизаций.Показатели КАК Показатели3
	|		ПО Удержания.ВидРасчета = Показатели3.Ссылка
	|			И (Показатели3.НомерСтроки = 3)
	|		ЛЕВОЕ СОЕДИНЕНИЕ ПланВидовРасчета.УдержанияОрганизаций.Показатели КАК Показатели4
	|		ПО Удержания.ВидРасчета = Показатели4.Ссылка
	|			И (Показатели4.НомерСтроки = 4)
	|		ЛЕВОЕ СОЕДИНЕНИЕ ПланВидовРасчета.УдержанияОрганизаций.Показатели КАК Показатели5
	|		ПО Удержания.ВидРасчета = Показатели5.Ссылка
	|			И (Показатели5.НомерСтроки = 5)
	|		ЛЕВОЕ СОЕДИНЕНИЕ ПланВидовРасчета.УдержанияОрганизаций.Показатели КАК Показатели6
	|		ПО Удержания.ВидРасчета = Показатели6.Ссылка
	|			И (Показатели6.НомерСтроки = 6)
	|ГДЕ
	|	Удержания.Ссылка = &ДокументСсылка
	|
	|СГРУППИРОВАТЬ ПО
	|	Удержания.ВидРасчета,
	|	Показатели1.Показатель,
	|	Показатели2.Показатель,
	|	Показатели3.Показатель,
	|	Показатели4.Показатель,
	|	Показатели5.Показатель,
	|	Показатели6.Показатель,
	|	Показатели1.ЗапрашиватьПриКадровыхПеремещениях,
	|	Показатели2.ЗапрашиватьПриКадровыхПеремещениях,
	|	Показатели3.ЗапрашиватьПриКадровыхПеремещениях,
	|	Показатели4.ЗапрашиватьПриКадровыхПеремещениях,
	|	Показатели5.ЗапрашиватьПриКадровыхПеремещениях,
	|	Показатели6.ЗапрашиватьПриКадровыхПеремещениях	
	|
	|ИНДЕКСИРОВАТЬ ПО
	|	ВидРасчета";		

	Запрос.Выполнить();	
	
	ВТПоказателиУдержаний = "ВТПоказателиУдержаний";
	
	
	
	// Описание текста запроса:
	//
	// 1. Выборка "Удержания":
	//		Выборка строк ТЧ Удержания. Проверка наличия строк-дублей.
	// 2. Выборка "СуществующиеДвижения":
	//		Проверяем на наличие существующих конфликтных движений в регистре сведений.
	
	ТекстЗапроса =
	"ВЫБРАТЬ
	|	Удержания.НомерСтроки,
	|	Удержания.Сотрудник,
	|	Удержания.Сотрудник.Наименование,
	|	Удержания.ВидРасчета,
	|	Удержания.ВидРасчета.СпособРасчета КАК СпособРасчета,
	|	Удержания.ВидРасчета.ПроизвольнаяФормулаРасчета КАК ПроизвольнаяФормулаРасчета,
	|	Удержания.Действие,
	|	Удержания.ДатаДействия,
	|	Удержания.ДатаДействияКонец,
	|	Удержания.Показатель1,
	|	Удержания.Показатель2,
	|	Удержания.Показатель3,
	|	Удержания.Показатель4,
	|	Удержания.Показатель5,
	|	Удержания.Показатель6,
	|	Удержания.СпособОтраженияВБухучете,
	|	Удержания.ДокументОснование,
	|	ВЫБОР
	|		КОГДА Удержания.ВидРасчета В (&ВсеИсполнительныеЛисты)
	|				И (НЕ Удержания.ДокументОснование ССЫЛКА Документ.ИсполнительныйЛист)
	|			ТОГДА ЛОЖЬ
	|		ИНАЧЕ ИСТИНА
	|	КОНЕЦ КАК ДокументОснованиеУказанВерно,
	|	ВЫБОР
	|		КОГДА Удержания.ВидРасчета.СпособРасчета В (&МассивСпоcобовРасчетаНеТребующихВалюты)
	|				ИЛИ Удержания.ВидРасчета = &ИсполнительныйЛист
	|			ТОГДА ЛОЖЬ
	|		ИНАЧЕ ИСТИНА
	|	КОНЕЦ КАК ТребуетВалюту,
	|	Удержания.Валюта1,
	|	Удержания.Валюта2,
	|	Удержания.Валюта3,
	|	Удержания.Валюта4,
	|	Удержания.Валюта5,
	|	Удержания.Валюта6,
	|	ЕСТЬNULL(Показатели.КоличествоПоказателей,0) КоличествоПоказателей,
	|	Показатели.Показатель1Предопределенный,
	|	Показатели.Показатель1Наименование,
	|	Показатели.Показатель1ТипПоказателя,
	|	Показатели.Показатель1ВозможностьИзменения,
	|	Показатели.Показатель2Предопределенный,
	|	Показатели.Показатель2Наименование,
	|	Показатели.Показатель2ТипПоказателя,
	|	Показатели.Показатель2ВозможностьИзменения,
	|	Показатели.Показатель3Предопределенный,
	|	Показатели.Показатель3Наименование,
	|	Показатели.Показатель3ТипПоказателя,
	|	Показатели.Показатель3ВозможностьИзменения,		
	|	Показатели.Показатель4Предопределенный,
	|	Показатели.Показатель4Наименование,
	|	Показатели.Показатель4ТипПоказателя,
	|	Показатели.Показатель4ВозможностьИзменения,		
	|	Показатели.Показатель5Предопределенный,
	|	Показатели.Показатель5Наименование,
	|	Показатели.Показатель5ТипПоказателя,
	|	Показатели.Показатель5ВозможностьИзменения,		
	|	Показатели.Показатель6Предопределенный,
	|	Показатели.Показатель6Наименование,
	|	Показатели.Показатель6ТипПоказателя,
	|	Показатели.Показатель6ВозможностьИзменения,	
	|	Удержания.КонфликтныйНомерСтроки,
	|	Показатели.Показатель1ЗапрашиватьПриКадровыхПеремещениях КАК Показатель1ЗапрашиватьПриКадровыхПеремещениях,
	|	Показатели.Показатель2ЗапрашиватьПриКадровыхПеремещениях КАК Показатель2ЗапрашиватьПриКадровыхПеремещениях,
	|	Показатели.Показатель3ЗапрашиватьПриКадровыхПеремещениях КАК Показатель3ЗапрашиватьПриКадровыхПеремещениях,
	|	Показатели.Показатель4ЗапрашиватьПриКадровыхПеремещениях КАК Показатель4ЗапрашиватьПриКадровыхПеремещениях,
	|	Показатели.Показатель5ЗапрашиватьПриКадровыхПеремещениях КАК Показатель5ЗапрашиватьПриКадровыхПеремещениях,
	|	Показатели.Показатель6ЗапрашиватьПриКадровыхПеремещениях КАК Показатель6ЗапрашиватьПриКадровыхПеремещениях

	|ИЗ
	|	(ВЫБРАТЬ
	|		ТЧУдержания.НомерСтроки КАК НомерСтроки,
	|		ТЧУдержания.Сотрудник КАК Сотрудник,
	|		ТЧУдержания.ВидРасчета КАК ВидРасчета,
	|		ТЧУдержания.Действие КАК Действие,
	|		ТЧУдержания.ДатаДействия КАК ДатаДействия,
	|		ТЧУдержания.ДатаДействияКонец КАК ДатаДействияКонец,
	|		ТЧУдержания.Показатель1 КАК Показатель1,
	|		ТЧУдержания.Показатель2 КАК Показатель2,
	|		ТЧУдержания.Показатель3	КАК Показатель3,
	|		ТЧУдержания.Показатель4	КАК Показатель4,
	|		ТЧУдержания.Показатель5	КАК Показатель5,
	|		ТЧУдержания.Показатель6	КАК Показатель6,
	|		ТЧУдержания.СпособОтраженияВБухучете КАК СпособОтраженияВБухучете,
	|		ТЧУдержания.Валюта1 КАК Валюта1,
	|		ТЧУдержания.Валюта2	КАК Валюта2,
	|		ТЧУдержания.Валюта3	КАК Валюта3,
	|		ТЧУдержания.Валюта4	КАК Валюта4,
	|		ТЧУдержания.Валюта5	КАК Валюта5,
	|		ТЧУдержания.Валюта6	КАК Валюта6,
	|		МИНИМУМ(ПовторяющиесяСтроки.НомерСтроки) КАК КонфликтныйНомерСтроки,
	|		ТЧУдержания.ДокументОснование КАК ДокументОснование,
	|		ТЧУдержания.Ссылка КАК Ссылка
	|	ИЗ
	|		Документ.ВводСведенийОПлановыхУдержанияхРаботниковОрганизаций.Удержания КАК ТЧУдержания
	|			ЛЕВОЕ СОЕДИНЕНИЕ Документ.ВводСведенийОПлановыхУдержанияхРаботниковОрганизаций.Удержания КАК ПовторяющиесяСтроки
	|			ПО ТЧУдержания.Ссылка = ПовторяющиесяСтроки.Ссылка
	|				И ТЧУдержания.НомерСтроки < ПовторяющиесяСтроки.НомерСтроки
	|				И ТЧУдержания.ВидРасчета = ПовторяющиесяСтроки.ВидРасчета
	|				И ТЧУдержания.ДатаДействия = ПовторяющиесяСтроки.ДатаДействия
	|				И ТЧУдержания.ДокументОснование = ПовторяющиесяСтроки.ДокументОснование
	|				И ТЧУдержания.Сотрудник = ПовторяющиесяСтроки.Сотрудник
	|	ГДЕ
	|		ТЧУдержания.Ссылка = &ДокументСсылка
	|	
	|	СГРУППИРОВАТЬ ПО
	|		ТЧУдержания.НомерСтроки,
	|		ТЧУдержания.ВидРасчета,
	|		ТЧУдержания.Действие,
	|		ТЧУдержания.ДатаДействия,
	|		ТЧУдержания.ДатаДействияКонец,
	|		ТЧУдержания.Показатель1,
	|		ТЧУдержания.Показатель2,
	|		ТЧУдержания.Показатель3,
	|		ТЧУдержания.Показатель4,
	|		ТЧУдержания.Показатель5,
	|		ТЧУдержания.Показатель6,
	|		ТЧУдержания.СпособОтраженияВБухучете,
	|		ТЧУдержания.Валюта1,
	|		ТЧУдержания.Валюта2,
	|		ТЧУдержания.Валюта3,
	|		ТЧУдержания.Валюта4,
	|		ТЧУдержания.Валюта5,
	|		ТЧУдержания.Валюта6,
	|		ТЧУдержания.ДокументОснование,
	|		ТЧУдержания.Ссылка,
	|		ТЧУдержания.Сотрудник) КАК Удержания
	|	ЛЕВОЕ СОЕДИНЕНИЕ ВТПоказателиУдержаний КАК Показатели
	|	ПО Удержания.ВидРасчета = Показатели.ВидРасчета
	|";
	
	Запрос.Текст = ТекстЗапроса;
	
	Возврат Запрос.Выполнить();

КонецФункции // СформироватьЗапросПоРаботникиОрганизации()


Процедура ПроверитьЗаполнениеШапки(ВыборкаПоШапкеДокумента, Отказ, Заголовок)

	Если НЕ ЗначениеЗаполнено(ВыборкаПоШапкеДокумента.Организация) Тогда
		ОбщегоНазначения.СообщитьОбОшибке(НСтр("ru='Не указана организация, в которой работает работник!';uk='Не зазначена організація, у якій працює працівник!'"), Отказ, Заголовок);
	КонецЕсли;

КонецПроцедуры // ПроверитьЗаполнениеШапки()

Процедура ПроверитьЗаполнениеСтрокиУдержания(ВыборкаПоШапкеДокумента, ВыборкаПоСтрокамДокумента, Отказ, Заголовок)

	СтрокаНачалаСообщенияОбОшибке = НСтр("ru='В строке номер ""';uk='У рядку номер ""'")+ СокрЛП(ВыборкаПоСтрокамДокумента.НомерСтроки) +
									НСтр("ru='"" табл. части ""Удержания"": ';uk='"" табл. частини ""Утримання"": '");
	
	// Сотрудник
	Если НЕ ЗначениеЗаполнено(ВыборкаПоСтрокамДокумента.Сотрудник) Тогда
		ОбщегоНазначения.СообщитьОбОшибке(СтрокаНачалаСообщенияОбОшибке + НСтр("ru='не выбран сотрудник!';uk='не обраний співробітник!'"), Отказ, Заголовок);
	КонецЕсли;

	// Вид расчета
	Если НЕ ЗначениеЗаполнено(ВыборкаПоСтрокамДокумента.ВидРасчета) И ВыборкаПоСтрокамДокумента.Действие <> Перечисления.ВидыДействияСНачислением.НеИзменять Тогда
		ОбщегоНазначения.СообщитьОбОшибке(СтрокаНачалаСообщенияОбОшибке + НСтр("ru='не указано удержание!';uk='не вказано утримання!'"), Отказ, Заголовок);
	КонецЕсли;
	
	// Действие
	Если НЕ ЗначениеЗаполнено(ВыборкаПоСтрокамДокумента.Действие) Тогда
		ОбщегоНазначения.СообщитьОбОшибке(СтрокаНачалаСообщенияОбОшибке + НСтр("ru='не указано действие с удержанием!';uk='не вказана дія з утриманням!'"), Отказ, Заголовок);
	ИначеЕсли ВыборкаПоСтрокамДокумента.Действие <> Перечисления.ВидыДействияСНачислением.НеИзменять Тогда	
	
		// ДатаДействия
		Если НЕ ЗначениеЗаполнено(ВыборкаПоСтрокамДокумента.ДатаДействия) Тогда
			ОбщегоНазначения.СообщитьОбОшибке(СтрокаНачалаСообщенияОбОшибке + НСтр("ru='не указана дата действия удержания!';uk='не вказана дата дії утримання!'"), Отказ, Заголовок);
		КонецЕсли;
		
		// Одинаковые строки
		Если ЗначениеЗаполнено(ВыборкаПоСтрокамДокумента.КонфликтныйНомерСтроки) Тогда
			ОбщегоНазначения.СообщитьОбОшибке(СтрокаНачалаСообщенияОбОшибке  + НСтр("ru='по работнику ';uk='по працівнику '") + ВыборкаПоСтрокамДокумента.СотрудникНаименование + НСтр("ru=' обнаружено повторное назначение того же удержания в строке №';uk=' виявлено повторне призначення того ж утримання в рядку №'") + ВыборкаПоСтрокамДокумента.КонфликтныйНомерСтроки + "!", Отказ, Заголовок);
		КонецЕсли;
			
	// Размер оплаты
		
		
		// Перид действия
		Если ЗначениеЗаполнено(ВыборкаПоСтрокамДокумента.ДатаДействияКонец) И ВыборкаПоСтрокамДокумента.ДатаДействия > ВыборкаПоСтрокамДокумента.ДатаДействияКонец Тогда
			ОбщегоНазначения.СообщитьОбОшибке(СтрокаНачалаСообщенияОбОшибке + НСтр("ru='дата окончания действия не должна быть меньше даты начала!';uk='дата закінчення дії не повинна бути менше дати початку!'"), Отказ, Заголовок);
		КонецЕсли; 
		
	КонецЕсли;
		
КонецПроцедуры // ПроверитьЗаполнениеСтрокиУдержания()


Процедура ДобавитьСтрокуВДвиженияПоРегистрамСведений( ВыборкаПоШапкеДокумента, ВыборкаПоРаботникиОрганизации )
	
	// Если документ нужно проводить по регистру, то для него есть ключ в структуре
	Если ВыборкаПоРаботникиОрганизации.Действие <> Перечисления.ВидыДействияСНачислением.НеИзменять тогда
		
		Движение = Движения["ПлановыеУдержанияРаботниковОрганизаций"].Добавить();
		
		// Свойства
		Движение.Период				= ВыборкаПоРаботникиОрганизации.ДатаДействия;
		
		// Измерения
		Движение.Сотрудник			= ВыборкаПоРаботникиОрганизации.Сотрудник;
		Движение.ВидРасчета			= ВыборкаПоРаботникиОрганизации.ВидРасчета;
		Движение.Организация		= ВыборкаПоШапкеДокумента.Организация;
		Движение.ДокументОснование	= ВыборкаПоРаботникиОрганизации.ДокументОснование;
		
		// Ресурсы
		Движение.СпособОтраженияВБухучете = ВыборкаПоРаботникиОрганизации.СпособОтраженияВБухучете;
		Движение.Действие 	= ВыборкаПоРаботникиОрганизации.Действие;
		Если ВыборкаПоРаботникиОрганизации.Действие <> Перечисления.ВидыДействияСНачислением.Прекратить Тогда
				Для Сч = 1 По 6 Цикл
					Если ВыборкаПоРаботникиОрганизации.ПроизвольнаяФормулаРасчета Тогда
						Если Сч <= ВыборкаПоРаботникиОрганизации.КоличествоПоказателей Тогда
							Если ВыборкаПоРаботникиОрганизации["Показатель" + Сч + "ЗапрашиватьПриКадровыхПеремещениях"] Тогда
								Движение["Показатель"+Сч]			= ВыборкаПоРаботникиОрганизации["Показатель"+Сч];
								Движение["Валюта"+Сч]				= ВыборкаПоРаботникиОрганизации["Валюта"+Сч];
							Иначе
								Движение["Показатель"+Сч]			= 0;
								Движение["Валюта"+Сч]				= Справочники.Валюты.ПустаяСсылка();
							КонецЕсли;
						Иначе
							Движение["Показатель"+Сч]			= 0;
							Движение["Валюта"+Сч]				= Справочники.Валюты.ПустаяСсылка();
						КонецЕсли;
					Иначе
						Движение["Показатель"+Сч]			= ВыборкаПоРаботникиОрганизации["Показатель"+Сч];
						Движение["Валюта"+Сч]				= ВыборкаПоРаботникиОрганизации["Валюта"+Сч];
					КонецЕсли;
				КонецЦикла;
			КонецЕсли;
			
		
		Если ЗначениеЗаполнено(ВыборкаПоРаботникиОрганизации.ДатаДействияКонец) Тогда
			Движение = Движения["ПлановыеУдержанияРаботниковОрганизаций"].Добавить();
			
			// Свойства
			Движение.Период				= КонецДня(ВыборкаПоРаботникиОрганизации.ДатаДействияКонец);
			
			// Измерения
			Движение.Сотрудник			= ВыборкаПоРаботникиОрганизации.Сотрудник;
			Движение.ВидРасчета			= ВыборкаПоРаботникиОрганизации.ВидРасчета;
			Движение.Организация		= ВыборкаПоШапкеДокумента.Организация;
			Движение.ДокументОснование	= ВыборкаПоРаботникиОрганизации.ДокументОснование;
			
			// Ресурсы
			Движение.Действие	= Перечисления.ВидыДействияСНачислением.Прекратить;
			Для Сч = 1 По 6 Цикл
					Если ВыборкаПоРаботникиОрганизации.ПроизвольнаяФормулаРасчета Тогда
						Если Сч <= ВыборкаПоРаботникиОрганизации.КоличествоПоказателей Тогда
								Движение["Показатель"+Сч]			= 0;
								Движение["Валюта"+Сч]				= Справочники.Валюты.ПустаяСсылка();
							КонецЕсли;
					Иначе
						Движение["Показатель"+Сч]			= 0;
						Движение["Валюта"+Сч]				= Справочники.Валюты.ПустаяСсылка();
					КонецЕсли;
					
				КонецЦикла;
			
		КонецЕсли;
		
	КонецЕсли;
 	
КонецПроцедуры // ДобавитьСтрокуВДвиженияПоРегистрамСведений


////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ

Процедура ОбработкаПроведения(Отказ, Режим)

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
 
			// получим реквизиты табличной части
			РезультатЗапросаПоРаботники = СформироватьЗапросПоРаботникиОрганизации(Режим);
			ВыборкаПоРаботникиОрганизации = РезультатЗапросаПоРаботники.Выбрать(ОбходРезультатаЗапроса.ПоГруппировкам);

			Пока ВыборкаПоРаботникиОрганизации.Следующий() Цикл

				// проверим очередную строку табличной части
				ПроверитьЗаполнениеСтрокиУдержания(ВыборкаПоШапкеДокумента, ВыборкаПоРаботникиОрганизации, Отказ, Заголовок);

				Если НЕ Отказ Тогда

					// Заполним записи в наборах записей регистров
					ДобавитьСтрокуВДвиженияПоРегистрамСведений( ВыборкаПоШапкеДокумента, ВыборкаПоРаботникиОрганизации );
					
				КонецЕсли;

			КонецЦикла;
			
		КонецЕсли;
		
	КонецЕсли;

КонецПроцедуры // ОбработкаПроведения()

Процедура ПередЗаписью(Отказ, РежимЗаписи, РежимПроведения)
	
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;

	КраткийСоставДокумента = ПроцедурыУправленияПерсоналом.ЗаполнитьКраткийСоставДокумента(Удержания,, "Сотрудник");
	ПроцедурыУправленияПерсоналом.ЗаполнитьФизЛицоПоТЧ(Удержания);
	
	Если Ссылка.Пустая() Тогда
		СcылкаОбъекта = Документы.ВводСведенийОПлановыхУдержанияхРаботниковОрганизаций.ПолучитьСсылку();
		УстановитьСсылкуНового(СcылкаОбъекта);
		
	Иначе
		СcылкаОбъекта = Ссылка;
		
	КонецЕсли;
	
КонецПроцедуры // ПередЗаписью()

Процедура ОбработкаЗаполнения(Основание)
	
	Если ТипЗнч(Основание) = Тип("ДокументСсылка.ПриемНаРаботуВОрганизацию") Тогда	
		
		//Заполнение шапки
		Организация = Основание.Организация;
		Ответственный = Основание.Ответственный;
		
		//Выбираем всех работников - для них будем вводить плановое удержание
        Запрос = Новый Запрос;
		Запрос.УстановитьПараметр("ДокументСсылка", Основание);
		ТекстЗапроса = "
		|ВЫБРАТЬ
		|	ТЧРаботники.Сотрудник   КАК Сотрудник,
		|	ТЧРаботники.ФизЛицо		КАК ФизЛицо,
		|	ТЧРаботники.Ссылка		КАК Приказ,
		|	ТЧРаботники.ДатаПриема	КАК	ДатаДействия
		|
		|ИЗ	Документ.ПриемНаРаботуВОрганизацию.РаботникиОрганизации КАК ТЧРаботники
		|
		|ГДЕ ТЧРаботники.Ссылка = &ДокументСсылка
		|";
		Запрос.Текст = ТекстЗапроса;
		Выборка =  Запрос.Выполнить().Выбрать();
		
		//Чтобы не делать дополнительную форму будем выбирать удержание из таблицы значений, получаемую путем выполнения запроса
		Запрос = Новый Запрос;
		Запрос.Текст = "
		|ВЫБРАТЬ Ссылка КАК Удержание
		|ИЗ
		|	ПланВидовРасчета.УдержанияОрганизаций
		|ГДЕ
		| НЕ Предопределенный";
		
		ВидРасчета = ПланыВидоврасчета.УдержанияОрганизаций.ПустаяСсылка();
		Выгруженное = Запрос.Выполнить().Выгрузить();
		Если Выгруженное.Количество() > 0 Тогда
			Выбранное = Выгруженное.ВыбратьСтроку(НСтр("ru='Выберите плановое удержание';uk='Виберіть планове утримання'"));
			Если Выбранное <> Неопределено Тогда
				ВидРасчета = Выбранное.Удержание;
			КонецЕсли;
		КонецЕсли;
		
		ВалютаРегл = Константы.ВалютаРегламентированногоУчета.Получить();

		//Заполняем табличную часть Удержание
		Пока Выборка.Следующий() Цикл
			ТекущаяСтрока = Удержания.Добавить();
			ТекущаяСтрока.Сотрудник		= Выборка.Сотрудник;
			ТекущаяСтрока.ФизЛицо		= Выборка.ФизЛицо;
			ТекущаяСтрока.ДатаДействия	= Выборка.ДатаДействия;
			ТекущаяСтрока.Действие		= Перечисления.ВидыДействияСНачислением.Начать;
			ТекущаяСтрока.ВидРасчета	= ВидРасчета;
		КонецЦикла;
	
	КонецЕсли;

КонецПроцедуры

Процедура ПриКопировании(ОбъектКопирования)
	
	ДокументОснование = Неопределено;
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// ОПЕРАТОРЫ ОСНОВНОЙ ПРОГРАММЫ

мСписокРасчетовПоИсполнительнымЛистам = Новый СписокЗначений;
мСписокРасчетовПоИсполнительнымЛистам.Добавить(ПланыВидовРасчета.УдержанияОрганизаций.ИЛПроцентом);
мСписокРасчетовПоИсполнительнымЛистам.Добавить(ПланыВидовРасчета.УдержанияОрганизаций.ИЛПроцентомДоПредела);
мСписокРасчетовПоИсполнительнымЛистам.Добавить(ПланыВидовРасчета.УдержанияОрганизаций.ИЛФиксированнойСуммой);
мСписокРасчетовПоИсполнительнымЛистам.Добавить(ПланыВидовРасчета.УдержанияОрганизаций.ИЛФиксированнойСуммойДоПредела);
мСписокРасчетовПоИсполнительнымЛистам.Добавить(ПланыВидовРасчета.УдержанияОрганизаций.АлиментыПроцентом);
мСписокРасчетовПоИсполнительнымЛистам.Добавить(ПланыВидовРасчета.УдержанияОрганизаций.АлиментыПроцентомДоПредела);
мСписокРасчетовПоИсполнительнымЛистам.Добавить(ПланыВидовРасчета.УдержанияОрганизаций.АлиментыФиксированнойСуммой);
мСписокРасчетовПоИсполнительнымЛистам.Добавить(ПланыВидовРасчета.УдержанияОрганизаций.АлиментыФиксированнойСуммойДоПредела);
мСписокРасчетовПоИсполнительнымЛистам.Добавить(ПланыВидовРасчета.УдержанияОрганизаций.ПочтовыйСбор);
