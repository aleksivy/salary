﻿////////////////////////////////////////////////////////////////////////////////
// ПЕРЕМЕННЫЕ МОДУЛЯ

Перем мСтараяТиповаяАнкета; // хранит старое значение элемент "Типовая анкета"
Перем мТекущаяДатаДокумента; // Хранит последнюю установленную дату документа - для проверки перехода документа в другой период
Перем ТаблицаВопросовОтветовПоАнкете;

// Хранит дерево кнопок подменю заполнение ТЧ
Перем мКнопкиЗаполненияТЧ;

////////////////////////////////////////////////////////////////////////////////
// ПРОЦЕДУРЫ И ФУНКЦИИ ОБЩЕГО НАЗНАЧЕНИЯ

// Процедура устанавливает подменю "Заполнить" в командных панелях ТЧ документа при необходимости
//
Процедура УстановитьКнопкиПодменюЗаполненияТЧ();
	
	мКнопкиЗаполненияТЧ = УниверсальныеМеханизмы.ПолучитьДеревоКнопокЗаполненияТабличныхЧастей(Ссылка,Новый Действие("НажатиеНаДополнительнуюКнопкуЗаполненияТЧ"));
	
	СоответствиеТЧ = Новый Соответствие;
	СоответствиеТЧ.Вставить(ЭлементыФормы.ВопросыИОтветы,ЭлементыФормы.КоманднаяПанельВопросыИОтветы);
	
	УниверсальныеМеханизмы.СформироватьПодменюЗаполненияТЧПоДеревуКнопок(мКнопкиЗаполненияТЧ,СоответствиеТЧ);
	
КонецПроцедуры

// Процедура - обработчик нажатия на любую из дополнительных кнопок по заполнению ТЧ
//
Процедура НажатиеНаДополнительнуюКнопкуЗаполненияТЧ(Кнопка)
	
	УниверсальныеМеханизмы.ОбработатьНажатиеНаДополнительнуюКнопкуЗаполненияТЧ(мКнопкиЗаполненияТЧ.Строки.Найти(Кнопка.Имя,"Имя",Истина),ЭтотОбъект);
	
КонецПроцедуры


// Управление колонкой "Ответ". В  зависимости от вопроса, поведение колонки "Ответ"
//  будет разным.
//
// Параметры
//  ВыбраннаяСтрока  – Строка табличной части – строка, в которой необходимо ответить 
//                 на вопрос.
//  Отказ		  – Булево – отказ от ввода непосредственно в строке.
//
Процедура ПодоготовитьПолучениеОтвета(ВыбраннаяСтрока, Отказ)
	
	ВопросыКонтактнаяИнформация = Новый СписокЗначений();
	ВопросыКонтактнаяИнформация.Добавить(Перечисления.ТипВопросаАнкеты.Адрес);
	ВопросыКонтактнаяИнформация.Добавить(Перечисления.ТипВопросаАнкеты.АдресЭлектроннойПочты);
	ВопросыКонтактнаяИнформация.Добавить(Перечисления.ТипВопросаАнкеты.ВебСтраница);
	ВопросыКонтактнаяИнформация.Добавить(Перечисления.ТипВопросаАнкеты.Другое);
	//ВопросыКонтактнаяИнформация.Добавить(Перечисления.ТипВопросаАнкеты.МестныйТелефон);
	//ВопросыКонтактнаяИнформация.Добавить(Перечисления.ТипВопросаАнкеты.ПроизвольныйАдрес);
	ВопросыКонтактнаяИнформация.Добавить(Перечисления.ТипВопросаАнкеты.Телефон);
	
	ТипВопроса = ВыбраннаяСтрока.Вопрос.ТипЗначения;
	Если ВопросыКонтактнаяИнформация.НайтиПоЗначению(ВыбраннаяСтрока.Вопрос.ТипВопроса) <> Неопределено Тогда
		
		ФормаРедактированияОтвета = ПолучитьФорму("ФормаВводаОтветовТеста");
		ФормаРедактированияОтвета.Вопрос = ВыбраннаяСтрока.Вопрос;
		ФормаРедактированияОтвета.ОткрытьМодально();
		Отказ = Истина; 
		
		//Если ВыбраннаяСтрока.Вопрос.ТипВидКонтакнойИнформации.Тип = Перечисления.ТипыКонтактнойИнформации.Адрес Тогда
		//	
		//	ФормаРедактированияОтвета = ПолучитьФорму("ФормаВводаОтветаАдрес");
		//	ФормаРедактированияОтвета.ТиповойОтвет = ВыбраннаяСтрока.ТиповойОтвет;
		//	ФормаРедактированияОтвета.ОткрытьМодально();
		//	ВыбраннаяСтрока.ТиповойОтвет = ФормаРедактированияОтвета.ТиповойОтвет;
		//	Отказ = Истина;
		//	
		//ИначеЕсли ВыбраннаяСтрока.Вопрос.ТипВидКонтакнойИнформации.Тип = Перечисления.ТипыКонтактнойИнформации.Телефон Тогда
		//	
		//	ФормаРедактированияОтвета = ПолучитьФорму("ФормаВводаОтветаТелефон");
		//	ФормаРедактированияОтвета.ТиповойОтвет = ВыбраннаяСтрока.ТиповойОтвет;
		//	ФормаРедактированияОтвета.ОткрытьМодально();
		//	ВыбраннаяСтрока.ТиповойОтвет = ФормаРедактированияОтвета.ТиповойОтвет;
		//	Отказ = Истина;
		//	
		//Иначе
		//	
		//	ЭлементыФормы.ВопросыИОтветы.ТекущаяКолонка.ЭлементУправления.КнопкаВыбора  = Ложь;
		//	ЭлементыФормы.ВопросыИОтветы.ТекущаяКолонка.ЭлементУправления.КнопкаОчистки = Ложь;
		//	
		//КонецЕсли;
		
	ИначеЕсли ТипВопроса.СодержитТип(Тип("Булево")) Тогда
		
		Отказ = Истина;  
		
		ПредыдущееЗначение = ВыбраннаяСтрока.ТиповойОтвет;
		Если ТипЗнч(ПредыдущееЗначение) <> Тип("Булево") Тогда
			ПредыдущееЗначение = Ложь;
		КонецЕсли;
		ВыбраннаяСтрока.ТиповойОтвет = НЕ ПредыдущееЗначение;
		
	ИначеЕсли ТипВопроса.СодержитТип(Тип("Строка")) Тогда
		Если ВыбраннаяСтрока.Вопрос.ТипВопроса = Перечисления.ТипВопросаАнкеты.Текст тогда
			ФормаРедактированияОтвета = ПолучитьФорму("ФормаВводаОтветаТекст");
			ФормаРедактированияОтвета.ТиповойОтвет        = ВыбраннаяСтрока.ТиповойОтвет;
			ФормаРедактированияОтвета.ОткрытьМодально();
			ВыбраннаяСтрока.ТиповойОтвет = ФормаРедактированияОтвета.ТиповойОтвет;
			Отказ = Истина;
		Иначе
			ЭлементыФормы.ВопросыИОтветы.ТекущаяКолонка.ЭлементУправления.КнопкаВыбора  = Ложь;
			ЭлементыФормы.ВопросыИОтветы.ТекущаяКолонка.ЭлементУправления.КнопкаОчистки = Ложь;
		КонецЕсли;
	ИначеЕсли ТипВопроса.СодержитТип(Тип("Число")) или ТипВопроса.СодержитТип(Тип("Дата")) Тогда
		
		ЭлементыФормы.ВопросыИОтветы.ТекущаяКолонка.ЭлементУправления.КнопкаВыбора  = Истина;
		ЭлементыФормы.ВопросыИОтветы.ТекущаяКолонка.ЭлементУправления.КнопкаОчистки = Ложь;
		
	ИначеЕсли ТипВопроса.СодержитТип(Тип("СправочникСсылка.ВариантыОтветовОпросов")) Тогда
		
		ФормаРедактированияОтвета = ПолучитьФорму("ФормаВводаОтветовТеста");
		ФормаРедактированияОтвета.Вопрос = ВыбраннаяСтрока.Вопрос;
		ФормаРедактированияОтвета.ОткрытьМодально();
		Отказ = Истина; Возврат;
		
	Иначе
		
		ЭлементыФормы.ВопросыИОтветы.ТекущаяКолонка.ЭлементУправления.КнопкаВыбора  = Истина;
		ЭлементыФормы.ВопросыИОтветы.ТекущаяКолонка.ЭлементУправления.КнопкаОчистки = Истина;
		
	КонецЕсли;                                     
	
КонецПроцедуры

// Функция проверяет пустая строка или нет.
//
// Параметры
//  ВыбСтрока	 – Строка – проверяемая строка.
//                 
//  ПризнакЗапятой  – Булево  
//
// Возвращаемое значение:
//   Строка   – пустая строка.
//
Функция ПроверкаПустойСтроки(ВыбСтрока, ПризнакЗапятой = Истина)
	
	Если ПустаяСтрока(ВыбСтрока) Тогда
		Возврат "";
	Иначе
		Возврат ?(ПризнакЗапятой,",","")+" ";
	КонецЕсли; 
	
КонецФункции // ПроверкаПустойСтроки()

// Функция подготавливает таблицу с вопросами и возможными ответами к ней.
//
// Параметры
//  Анкета  – СправочникСсылка.ТиповыеАнкеты – анкета, по которой собираются
//                  данные.
//
// Возвращаемое значение:
//   ТаблицаЗначений   – таблица с вопросами и возможными ответами.
//
Функция ЗапросПоАнкете(Анкета)
	
	ЗапросКАнкете = Новый Запрос();
	ЗапросКАнкете.УстановитьПараметр("Анкета", Анкета);
	
    ТекстЗапроса = 
	"ВЫБРАТЬ
	|	ТиповыеАнкетыВопросыАнкеты.Вопрос,
	|	ВариантыОтветовОпросов.ТребуетРазвернутыйОтвет,
	|	ВариантыОтветовОпросов.Ссылка КАК Ответ
	|ИЗ
	|	Справочник.ТиповыеАнкеты.ВопросыАнкеты КАК ТиповыеАнкетыВопросыАнкеты
	|		ЛЕВОЕ СОЕДИНЕНИЕ Справочник.ВариантыОтветовОпросов КАК ВариантыОтветовОпросов
	|		ПО ТиповыеАнкетыВопросыАнкеты.Вопрос = ВариантыОтветовОпросов.Владелец
	|
	|ГДЕ
	|	ТиповыеАнкетыВопросыАнкеты.Ссылка = &Анкета";
	
	ЗапросКАнкете.Текст = ТекстЗапроса;

	ТаблицаВопросовОтветовПоАнкете = Новый ТаблицаЗначений;
	ТаблицаВопросовОтветовПоАнкете = ЗапросКАнкете.Выполнить().Выгрузить();
	
	Возврат  ТаблицаВопросовОтветовПоАнкете;
	
КонецФункции // ЗапросПоАнкете()

// Процедура сворачивает панель с таблицами вопросов и ответов
// в случае если текущей пользователь является опрашиваемым лицом
// для возможности ответа на вопросы теста по очереди
Процедура ПроверкаДоступностиТаблицВопросовИОтветов()
	
	Если ЗначениеЗаполнено(ОпрашиваемоеЛицо) И ОпрашиваемоеЛицо = глЗначениеПеременной("глТекущийПользователь").ФизЛицо Тогда
		ЭлементыФормы.ПанельОтветов.Свертка           = РежимСверткиЭлементаУправления.Верх;
		ЭлементыФормы.ОпрашиваемоеЛицо.ТолькоПросмотр = Истина;
	Иначе
		ЭлементыФормы.ПанельОтветов.Свертка = РежимСверткиЭлементаУправления.Нет;
	КонецЕсли;
	
КонецПроцедуры

Процедура АктуализироватьТЧСоставногоОтвета(Элемент, Отказ)
	
	ТекСтрока = ЭлементыФормы.ВопросыИОтветы.ТекущаяСтрока;
	Если ТекСтрока <> Неопределено тогда
		ТекущийТабличныйВопрос 	= ТекСтрока.Вопрос;
		Если Элемент.ТекущаяСтрока <> Неопределено тогда
			Если ТекущийТабличныйВопрос.ТипВопроса = Перечисления.ТипВопросаАнкеты.Табличный тогда
				НомерСтроки				= Элемент.ТекущаяСтрока.НомерСтроки;
			КонецЕсли;
		КонецЕсли;
	Иначе
		Возврат;
	КонецЕсли;
	
	Если ТаблицаСоставногоОтвета.Количество() = 0 тогда
		
		СтруктураПоиска = Новый Структура("ВопросВладелец");
		СтруктураПоиска.Вставить("ВопросВладелец", 		ТекущийТабличныйВопрос); 
		
		СтрокиКУдалению = СоставнойОтвет.НайтиСтроки(СтруктураПоиска);
		Для каждого СтрокаДляУдаления из СтрокиКУдалению Цикл
			СоставнойОтвет.Удалить(СтрокаДляУдаления);
		КонецЦикла;
		
	Иначе
		
		// здесь при редактировании составного ответа удаляем все строки соответствуюшие вопросу владельцу
		// и заново их добавляем
		// для табличного вопроса удаляем все ответы соответствующие данной строке таблицы и заново их добавляем
		// связано с тем, что у табличного вопроса строки фиксированы, а у составного их может быть в общем случае
		// столько, сколько у него вариантов ответа
		
		Если ТекущийТабличныйВопрос.ТипВопроса = Перечисления.ТипВопросаАнкеты.Табличный тогда
			СтруктураПоиска = Новый Структура("НомерСтрокиВТаблице,ВопросВладелец");
			//для табличного вопроса будем искать еще и по номеру строки (это ноер строки в таблице табличного вопроса)
			СтруктураПоиска.Вставить("НомерСтрокиВТаблице", НомерСтроки); 
		Иначе
			СтруктураПоиска = Новый Структура("ВопросВладелец");
		КонецЕсли;
		СтруктураПоиска.Вставить("ВопросВладелец", 		ТекущийТабличныйВопрос); 
		
		СтрокиКУдалению = СоставнойОтвет.НайтиСтроки(СтруктураПоиска);
		Для каждого СтрокаДляУдаления из СтрокиКУдалению Цикл
			СоставнойОтвет.Удалить(СтрокаДляУдаления);
		КонецЦикла;
		
		СтрокаСоставногоВопроса 				= Элемент.ТекущаяСтрока;
		Если ТекущийТабличныйВопрос.ТипВопроса 	= Перечисления.ТипВопросаАнкеты.СправочникСсылка_ВариантыОтветов_Несколько тогда
			Для каждого СтрокаОтвета из ТаблицаСоставногоОтвета Цикл
				НоваяСтрокаОтвета 						= СоставнойОтвет.Добавить();
				НоваяСтрокаОтвета.Вопрос 				= ТекущийТабличныйВопрос;
				НоваяСтрокаОтвета.ВопросВладелец		= ТекущийТабличныйВопрос;
				НоваяСтрокаОтвета.НомерСтрокиВТаблице 	= СтрокаОтвета.НомерСтроки;
				НоваяСтрокаОтвета.ТиповойОтвет 			= СтрокаОтвета.ВариантОтвета;
				НоваяСтрокаОтвета.Ответ		 			= СтрокаОтвета.Ответ;
			КонецЦикла;
		Иначе
			КолонкиСоставногоОтвета = ТекСтрока.Вопрос.КолонкиТаблицы;
			//СтрокаСоставногоВопроса = Элемент.ТекущаяСтрока;
			
			Для каждого КолонкаОтвета из КолонкиСоставногоОтвета Цикл
				НоваяСтрокаОтвета 						= СоставнойОтвет.Добавить();
				НоваяСтрокаОтвета.Вопрос 				= КолонкаОтвета.КолонкаТаблицы;
				НоваяСтрокаОтвета.ВопросВладелец		= ТекущийТабличныйВопрос;
				НоваяСтрокаОтвета.НомерСтрокиВТаблице 	= НомерСтроки;
				НоваяСтрокаОтвета.ТиповойОтвет 			= СтрокаСоставногоВопроса["колонка"+КолонкаОтвета.НомерСтроки];
			КонецЦикла;
		КонецЕсли;
		
	КонецЕсли;
	
КонецПроцедуры

Процедура ОбновитьСписокВопросов()
	
	Если ЭтоНовый() или Модифицированность() Тогда
		Вопрос = НСтр("ru='Необходимо записать документ. Записать?';uk='Необхідно записати документ. Записати?'");
		Ответ  = Вопрос(Вопрос, РежимДиалогаВопрос.ОКОтмена);
		Если Ответ = КодВозвратаДиалога.ОК Тогда
			ЗаписатьВФорме();
		Иначе
			Возврат;
		КонецЕсли;
	КонецЕсли;
	
	ТекстЗапроса = 
	"ВЫБРАТЬ
	|	ВопросыАнкеты.НомерСтроки КАК НомерСтроки,
	|	ВопросыАнкеты.Вопрос КАК Вопрос,
	|	ОпросВопросы.Ответ,
	|	ОпросВопросы.ТиповойОтвет,
	|	NULL КАК НомерСтрокиВТаблице,
	|	NULL КАК КолонкаТаблицы,
	|	ВопросыАнкеты.ТипВопроса КАК ТипВопроса,
	|	NULL КАК НомерСтрокиКолонки
	|ИЗ
	|	(ВЫБРАТЬ
	|		ТиповыеАнкетыВопросыАнкеты.Вопрос КАК Вопрос,
	|		ТиповыеАнкетыВопросыАнкеты.НомерСтроки КАК НомерСтроки,
	|		ТиповыеАнкетыВопросыАнкеты.Вопрос.ТипВопроса КАК ТипВопроса
	|	ИЗ
	|		Справочник.ТиповыеАнкеты.ВопросыАнкеты КАК ТиповыеАнкетыВопросыАнкеты
	|	ГДЕ
	|		ТиповыеАнкетыВопросыАнкеты.Ссылка = &ТиповаяАнкета) КАК ВопросыАнкеты
	|		ЛЕВОЕ СОЕДИНЕНИЕ Документ.Опрос.Вопросы КАК ОпросВопросы
	|		ПО ВопросыАнкеты.Вопрос = ОпросВопросы.Вопрос
	|			И (ОпросВопросы.Ссылка = &ДокументОпрос)
	|
	|ОБЪЕДИНИТЬ ВСЕ
	|
	|ВЫБРАТЬ
	|	ВопросыАнкеты.НомерСтроки,
	|	ВопросыАнкеты.Вопрос,
	|	ОпросСоставнойОтвет.Ответ,
	|	ОпросСоставнойОтвет.ТиповойОтвет,
	|	ОпросСоставнойОтвет.НомерСтрокиВТаблице,
	|	ВопросыДляАнкетированияКолонкиТаблицы.КолонкаТаблицы,
	|	ВопросыАнкеты.ТипВопроса,
	|	ВопросыДляАнкетированияКолонкиТаблицы.НомерСтроки
	|ИЗ
	|	(ВЫБРАТЬ
	|		ТиповыеАнкетыВопросыАнкеты.Вопрос КАК Вопрос,
	|		ТиповыеАнкетыВопросыАнкеты.НомерСтроки КАК НомерСтроки,
	|		ТиповыеАнкетыВопросыАнкеты.Вопрос.ТипВопроса КАК ТипВопроса
	|	ИЗ
	|		Справочник.ТиповыеАнкеты.ВопросыАнкеты КАК ТиповыеАнкетыВопросыАнкеты
	|	ГДЕ
	|		ТиповыеАнкетыВопросыАнкеты.Ссылка = &ТиповаяАнкета) КАК ВопросыАнкеты
	|		ЛЕВОЕ СОЕДИНЕНИЕ Документ.Опрос.СоставнойОтвет КАК ОпросСоставнойОтвет
	|			ВНУТРЕННЕЕ СОЕДИНЕНИЕ (ВЫБРАТЬ
	|				ВопросыДляАнкетированияКолонкиТаблицы.КолонкаТаблицы КАК КолонкаТаблицы,
	|				ВопросыДляАнкетированияКолонкиТаблицы.НомерСтроки КАК НомерСтроки,
	|				ВопросыДляАнкетированияКолонкиТаблицы.Ссылка.КоличествоСтрокТаблицы КАК КоличествоСтрокТаблицы
	|			ИЗ
	|				ПланВидовХарактеристик.ВопросыДляАнкетирования.КолонкиТаблицы КАК ВопросыДляАнкетированияКолонкиТаблицы
	|			ГДЕ
	|				ВопросыДляАнкетированияКолонкиТаблицы.Ссылка В
	|						(ВЫБРАТЬ
	|							ТиповыеАнкетыВопросыАнкеты.Вопрос
	|						ИЗ
	|							Справочник.ТиповыеАнкеты.ВопросыАнкеты КАК ТиповыеАнкетыВопросыАнкеты
	|						ГДЕ
	|							ТиповыеАнкетыВопросыАнкеты.Ссылка = &ТиповаяАнкета)) КАК ВопросыДляАнкетированияКолонкиТаблицы
	|			ПО ОпросСоставнойОтвет.Вопрос = ВопросыДляАнкетированияКолонкиТаблицы.КолонкаТаблицы
	|		ПО ВопросыАнкеты.Вопрос = ОпросСоставнойОтвет.ВопросВладелец
	|			И (ОпросСоставнойОтвет.Ссылка = &ДокументОпрос)
	|ГДЕ
	|	(ВопросыДляАнкетированияКолонкиТаблицы.КоличествоСтрокТаблицы >= ОпросСоставнойОтвет.НомерСтрокиВТаблице
	|				И ОпросСоставнойОтвет.ВопросВладелец.ТипВопроса = &Табличный
	|			ИЛИ ОпросСоставнойОтвет.ВопросВладелец.ТипВопроса = &ВВидеНесколькихОтветов)
	|
	|УПОРЯДОЧИТЬ ПО
	|	НомерСтроки,
	|	НомерСтрокиВТаблице,
	|	НомерСтрокиКолонки
	|ИТОГИ ПО
	|	Вопрос
	|АВТОУПОРЯДОЧИВАНИЕ";
	
	Запрос = Новый Запрос(ТекстЗапроса);
	Запрос.УстановитьПараметр("ДокументОпрос", 			Ссылка);
	Запрос.УстановитьПараметр("ТиповаяАнкета", 			ТиповаяАнкета);
	Запрос.УстановитьПараметр("Табличный", 				Перечисления.ТипВопросаАнкеты.Табличный);
	Запрос.УстановитьПараметр("ВВидеНесколькихОтветов",	Перечисления.ТипВопросаАнкеты.СправочникСсылка_ВариантыОтветов_Несколько);
	РезультатЗапрос = Запрос.Выполнить();
	ВыборкаЗапроса					= РезультатЗапрос.Выбрать(ОбходРезультатаЗапроса.ПоГруппировкам);
	Вопросы.Очистить();
	СоставнойОтвет.Очистить();
	Пока ВыборкаЗапроса.Следующий() Цикл
		Если ВыборкаЗапроса.Вопрос.ТипВопроса = Перечисления.ТипВопросаАнкеты.Табличный ИЛИ ВыборкаЗапроса.Вопрос.ТипВопроса = Перечисления.ТипВопросаАнкеты.СправочникСсылка_ВариантыОтветов_Несколько тогда
			//ТабличныйВопрос = ВыборкаЗапроса.Вопрос;
			НоваяСтрока 		= Вопросы.Добавить();
			НоваяСтрока.Вопрос 	= ВыборкаЗапроса.Вопрос;
			НоваяСтрока.ТиповойОтвет 	= ВыборкаЗапроса.ТиповойОтвет;
			НоваяСтрока.Ответ 			= ВыборкаЗапроса.Ответ;
			ВыборкаЗапросаТабличныйВопрос	= ВыборкаЗапроса.Выбрать();
			Пока ВыборкаЗапросаТабличныйВопрос.Следующий() Цикл
				Если НЕ ЗначениеЗаполнено(ВыборкаЗапросаТабличныйВопрос.КолонкаТаблицы) И (ВыборкаЗапросаТабличныйВопрос.ТипВопроса = Перечисления.ТипВопросаАнкеты.Табличный) тогда
					Продолжить;
				КонецЕСли;
				Если НЕ ЗначениеЗаполнено(ВыборкаЗапросаТабличныйВопрос.ТиповойОтвет) И (ВыборкаЗапросаТабличныйВопрос.Вопрос.ТипВопроса = Перечисления.ТипВопросаАнкеты.СправочникСсылка_ВариантыОтветов_Несколько) тогда
					Продолжить;
				КонецЕсли;
				НоваяСтрока 				= СоставнойОтвет.Добавить();
				Если ВыборкаЗапроса.Вопрос.ТипВопроса = Перечисления.ТипВопросаАнкеты.СправочникСсылка_ВариантыОтветов_Несколько тогда
					НоваяСтрока.Вопрос 			= ВыборкаЗапросаТабличныйВопрос.Вопрос;
				Иначе
					НоваяСтрока.Вопрос 			= ВыборкаЗапросаТабличныйВопрос.КолонкаТаблицы;
				КонецЕСли;
				НоваяСтрока.ВопросВладелец 	= ВыборкаЗапросаТабличныйВопрос.Вопрос;
				Если НЕ ЗначениеЗаполнено(ВыборкаЗапросаТабличныйВопрос.ТиповойОтвет) тогда
					НазначитьТипОтвета(НоваяСтрока);
				Иначе
					НоваяСтрока.ТиповойОтвет 	= ВыборкаЗапросаТабличныйВопрос.ТиповойОтвет;
				КонецЕсли;
				НоваяСтрока.Ответ 			= ВыборкаЗапросаТабличныйВопрос.Ответ;
				НоваяСтрока.НомерСтрокиВТаблице	= ВыборкаЗапросаТабличныйВопрос.НомерСтрокиВТаблице;
			КонецЦикла;
		Иначе
			НоваяСтрока 		= Вопросы.Добавить();
			НоваяСтрока.Вопрос 	= ВыборкаЗапроса.Вопрос;
			ВыборкаЗапросаОтвет	= ВыборкаЗапроса.Выбрать();
			Пока ВыборкаЗапросаОтвет.Следующий() Цикл
				Если НЕ ЗначениеЗаполнено(ВыборкаЗапросаОтвет.ТиповойОтвет) тогда
					НазначитьТипОтвета(НоваяСтрока);
					Продолжить;
				КонецЕсли;
				НоваяСтрока.ТиповойОтвет 	= ВыборкаЗапросаОтвет.ТиповойОтвет;
				НоваяСтрока.Ответ 			= ВыборкаЗапросаОтвет.Ответ;
			КонецЦикла;
		КонецЕсли;
	КонецЦикла;
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// ПРОЦЕДУРЫ - ОБРАБОТЧИКИ СОБЫТИЙ ФОРМЫ

// Процедура - обработчик события "ПередОткрытием" формы.
//
Процедура ПередОткрытием(Отказ, СтандартнаяОбработка)
	
	// Установка кнопок заполнение ТЧ
	УстановитьКнопкиПодменюЗаполненияТЧ();
	
КонецПроцедуры // ПередОткрытием()

// Процедура - обработчик события "ПриОткрытии" формы
//
Процедура ПриОткрытии()
	
	Если ЭтоНовый() Тогда // проверить объект на то, что он еще не внесен в ИБ
		
		// Заполнить реквизиты значениями по умолчанию.
		ЗаполнениеДокументов.ЗаполнитьШапкуДокумента(ЭтотОбъект);
	Иначе 
		// Установить доступность формы с учетом даты запрета редактирования	
		РаботаСДиалогами.УстановитьДоступностьФормыДляРедактирования(ЭтотОбъект, ЭтаФорма);
	КонецЕсли;
	
	// Вывести в заголовке формы статус документа (новый, не проведен, проведен).
	РаботаСДиалогами.УстановитьЗаголовокФормыДокумента(, ЭтотОбъект, ЭтаФорма);
	
	// Запомнить текущие значения реквизитов формы.
	мТекущаяДатаДокумента = Дата;
	мСтараяТиповаяАнкета = ТиповаяАнкета;
	ТаблицаВопросовОтветовПоАнкете = ЗапросПоАнкете(ТиповаяАнкета);
	
	ПроверкаДоступностиТаблицВопросовИОтветов();
	
	// Установить активный реквизит.
	РаботаСДиалогами.АктивизироватьРеквизитВФорме(ЭтотОбъект, ЭтаФорма);
	
	МеханизмНумерацииОбъектов.ДобавитьВМенюДействияКнопкуРедактированияНомера(ЭлементыФормы.ДействияФормы.Кнопки.Подменю);
	МеханизмНумерацииОбъектов.УстановитьДоступностьПоляВводаНомера(Метаданные(), ЭтаФорма, ЭлементыФормы.ДействияФормы.Кнопки.Подменю,ЭлементыФормы.Номер);
	
	// Создать кнопки печати
	ФормированиеПечатныхФорм.СоздатьКнопкиПечати(ЭтотОбъект, ЭтаФорма);
	
КонецПроцедуры // ПриОткрытии()

// Процедура - обработчик события "ПослеЗаписи" формы.
//
Процедура ПослеЗаписи()

	// Вывести в заголовке формы статус документа (новый, не проведен, проведен).
	РаботаСДиалогами.УстановитьЗаголовокФормыДокумента(, ЭтотОбъект, ЭтаФорма);
	МеханизмНумерацииОбъектов.ОбновитьПодсказкуКодНомерОбъекта(ЭтотОбъект.Метаданные(), ЭлементыФормы.ДействияФормы.Кнопки.Подменю, ЭлементыФормы.Номер);
	ПроверитьОбязательноЗаполняемыеОтветы();
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// ПРОЦЕДУРЫ - ДЕЙСТВИЯ КОМАНДНЫХ ПАНЕЛЕЙ ФОРМЫ

Процедура ДействияФормыРедактироватьНомер(Кнопка)
	МеханизмНумерацииОбъектов.ИзменениеВозможностиРедактированияНомера(ЭтотОбъект.Метаданные(), ЭтаФорма, ЭлементыФормы.ДействияФормы.Кнопки.Подменю, ЭлементыФормы.Номер);
КонецПроцедуры
// Процедура вызывается при выборе пункта подменю "Движения документа по регистрам" меню "Перейти".
// командной панели формы. Процедура отрабатывает печать движений документа по регистрам.
//
Процедура ДействияФормыДвиженияДокументаПоРегистрам(Кнопка)

	РаботаСДиалогами.НапечататьДвиженияДокумента(Ссылка);

КонецПроцедуры // ДействияФормыДвиженияДокументаПоРегистрам()

Процедура КоманднаяПанельВопросыИОтветыОбновить(Кнопка)
	
	ОбновитьСписокВопросов();
	
КонецПроцедуры

Процедура ОсновныеДействияФормыЗаполнить(Кнопка)
	
	ФормаРедактированияОтвета = ПолучитьФорму("ФормаВводаОтветовТеста");
	ФормаРедактированияОтвета.ОткрытьМодально();
	
	ВопросыИОтветыПриАктивизацииСтроки(ЭлементыФормы.ВопросыИОтветы);
	
КонецПроцедуры

// Процедура - обработчик нажатия на кнопку "Печать".
// Открывает форму выбора печатных форм объекта.
//
Процедура ОсновныеДействияФормыПечать(Кнопка)
	
	УниверсальныеМеханизмы.ОткрытьФормуВыбораПечатныхФормОбъекта(ЭтотОбъект, ЭтаФорма);
	
КонецПроцедуры // ОсновныеДействияФормыПечать() 

// Процедура - обработчик нажатия на кнопку "Печать по умолчанию"
//
Процедура ОсновныеДействияФормыПечатьПоУмолчанию(Кнопка)

	УниверсальныеМеханизмы.НапечататьДокументПоУмолчанию(ЭтотОбъект);

КонецПроцедуры
 
////////////////////////////////////////////////////////////////////////////////
// ПРОЦЕДУРЫ ОБРАБОТКИ СВОЙСТВ И КАТЕГОРИЙ

// Процедура выполняет открытие формы работы со свойствами документа
//
Процедура ДействияФормыДействиеОткрытьСвойства(Кнопка)

	РаботаСДиалогами.ОткрытьСвойстваДокумента(ЭтотОбъект, ЭтаФорма);

КонецПроцедуры

// Процедура выполняет открытие формы работы с категориями документа
//
Процедура ДействияФормыДействиеОткрытьКатегории(Кнопка)

	РаботаСДиалогами.ОткрытьКатегорииДокумента(ЭтотОбъект, ЭтаФорма);

КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// ПРОЦЕДУРЫ - ОБРАБОТЧИКИ СОБЫТИЙ РЕКВИЗИТОВ ШАПКИ

// Процедура - обработчик события "ПриИзменении" поля ввода даты документа
//
Процедура ДатаПриИзменении(Элемент = Неопределено)
	
	РаботаСДиалогами.ПроверитьНомерДокумента(ДокументОбъект, мТекущаяДатаДокумента);
	МеханизмНумерацииОбъектов.ОбновитьПодсказкуКодНомерОбъекта(ЭтотОбъект.Метаданные(), ЭлементыФормы.ДействияФормы.Кнопки.Подменю, ЭлементыФормы.Номер);
	
	мТекущаяДатаДокумента = Дата;
	
КонецПроцедуры // ДатаПриИзменении

//  Процедура заполняет список вопросов по выбранной пользователем "Типовой анкете"
//
// Параметры:
//  Элемент      - элемент формы, который отображает типовую анкету.
//
Процедура ТиповаяАнкетаПриИзменении(Элемент)
	
	Если ЗначениеЗаполнено(ТиповаяАнкета) тогда
		Если Вопросы.Количество() > 0 тогда
			Если Вопрос(НСтр("ru='Список вопросов и ответов будет очищен и заполнен новыми данными! Продолжить?';uk='Список питань і відповідей буде очищений і заповнений новими даними! Продовжити?'"), РежимДиалогаВопрос.ДаНет,, КодВозвратаДиалога.Нет, ) = КодВозвратаДиалога.Да тогда
				Вопросы.Очистить();
				СоставнойОтвет.Очистить();
			Иначе
				ТиповаяАнкета = мСтараяТиповаяАнкета;
				Возврат;
			КонецЕсли;
		КонецЕсли;
		ЗаполнитьВопросыАнкеты(Элемент.Значение);
		ТаблицаВопросовОтветовПоАнкете = ЗапросПоАнкете(Элемент.Значение);
	КонецЕсли;
	мСтараяТиповаяАнкета = ТиповаяАнкета;
	
КонецПроцедуры

Процедура ОпрашиваемоеЛицоПриИзменении(Элемент)
	
	ПроверкаДоступностиТаблицВопросовИОтветов();
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// ПРОЦЕДУРЫ - ОБРАБОТЧИКИ СОБЫТИЙ ТАБЛИЧНОГО ПОЛЯ ВопросыИОтветы

// Процедура - обработчик события "ПередНачаломИзменения" табличного поля.
Процедура ВопросыИОтветыПередНачаломИзменения(Элемент, Отказ)
	
	Если Элемент.ТекущаяКолонка.Имя = "ТиповойОтвет" Тогда
		ПодоготовитьПолучениеОтвета(Элемент.ТекущаяСтрока, Отказ);
	КонецЕсли;
	
КонецПроцедуры

// Процедура - обработчик события "ПриВыводеСтроки" табличного поля.
// сделаем поле развернутого ответа доступным тогда, когда это требует типовой ответ
//
// Параметры:
//  Элемент      - табличное поле, которое отображает т.ч.
//  
Процедура ВопросыИОтветыПриВыводеСтроки(Элемент, ОформлениеСтроки, ДанныеСтроки)
	
	//Если ЭлементыФормы.ВопросыИОтветы.ТекущиеДанные <> Неопределено тогда
		Если Элемент.Колонки.ТиповойОтвет.Видимость тогда
			Если ДанныеСтроки.Вопрос.ТипВидКонтакнойИнформации.Тип = Перечисления.ТипыКонтактнойИнформации.Адрес тогда
				
				МассивПолей = ОбщегоНазначения.РазложитьСтрокуВМассивПодстрок(ДанныеСтроки.ТиповойОтвет, "¤");
				Если МассивПолей.Количество() > 1 тогда
					Регион  = МассивПолей[1];
				КонецЕсли;
				Если МассивПолей.Количество() > 2 тогда
					Район   = МассивПолей[2];
				КонецЕсли;
				Если МассивПолей.Количество() > 3 тогда
					Город   = МассивПолей[3];
				КонецЕсли;
				Если МассивПолей.Количество() > 4 тогда
					НаселенныйПункт = МассивПолей[4];
				КонецЕсли;
				Если МассивПолей.Количество() > 5 тогда
					Улица   = МассивПолей[5];
				КонецЕсли;
				Если МассивПолей.Количество() > 6 тогда
					Дом     = МассивПолей[6];
				КонецЕсли;
				Если МассивПолей.Количество() > 7 тогда
					Корпус  = МассивПолей[7];
				КонецЕсли;
				Если МассивПолей.Количество() > 8 тогда
					Квартира= МассивПолей[8];
				КонецЕсли;
				Если МассивПолей.Количество() > 0 тогда
					Индекс  = МассивПолей[0];
				КонецЕсли;
				Если МассивПолей.Количество() > 9 тогда
					КомментарийАдреса  = МассивПолей[9];
				КонецЕсли;
				
				Представление = "";
				Если СокрЛП(Индекс) <> "" Тогда
					Представление = Представление + ", " + СокрЛП(Индекс);
				КонецЕсли;
				Если СокрЛП(Регион) <> "" Тогда
					Представление = Представление + ", " + СокрЛП(Регион);
				КонецЕсли;
				Если СокрЛП(Район) <> "" Тогда
					Представление = Представление + ", " + СокрЛП(Район);
				КонецЕсли;
				Если СокрЛП(Город) <> "" Тогда
					Представление = Представление + ", " + СокрЛП(Город);
				КонецЕсли;
				Если СокрЛП(НаселенныйПункт) <> "" Тогда
					Представление = Представление + ", " + СокрЛП(НаселенныйПункт);
				КонецЕсли;
				Если СокрЛП(Улица) <> "" Тогда
					Представление = Представление + ", " + СокрЛП(Улица);
				КонецЕсли;
				Если СокрЛП(Дом) <> "" Тогда
					Представление = Представление + НСтр("ru=', д. ';uk=', б. '") + СокрЛП(Дом);
				КонецЕсли;
				Если СокрЛП(Корпус) <> "" Тогда
					Представление = Представление + НСтр("ru=', корп. ';uk=', корп. '") + СокрЛП(Корпус);
				КонецЕсли;
				Если СокрЛП(Квартира) <> "" Тогда
					Представление = Представление + НСтр("ru=', кв. ';uk=', кв. '") + СокрЛП(Квартира);
				КонецЕсли;
				Если СокрЛП(КомментарийАдреса) <> "" Тогда
					Представление = Представление + ", " + СокрЛП(КомментарийАдреса);
				КонецЕсли;
							
				Если СтрДлина(Представление) > 2 Тогда
					Представление = Сред(Представление, 3);
				КонецЕсли;
				ОформлениеСтроки.Ячейки.ТиповойОтвет.Текст = Представление;
				
				//ОформлениеСтроки.Ячейки.ТиповойОтвет.Текст = СтрЗаменить(ОформлениеСтроки.Ячейки.ТиповойОтвет.Текст, "¤", ", ");
			ИначеЕсли ДанныеСтроки.Вопрос.ТипВидКонтакнойИнформации.Тип = Перечисления.ТипыКонтактнойИнформации.Телефон тогда
				МассивПолей = ОбщегоНазначения.РазложитьСтрокуВМассивПодстрок(ДанныеСтроки.ТиповойОтвет, "¤");
				Если МассивПолей.Количество() > 0 тогда
					Поле1 = МассивПолей[0];
				КонецЕсли;
				Если МассивПолей.Количество() > 1 тогда
					Поле2 = МассивПолей[1];
				КонецЕсли;
				Если МассивПолей.Количество() > 2 тогда
					Поле3 = МассивПолей[2];
				КонецЕсли;
				Если МассивПолей.Количество() > 3 тогда
					Поле4 = МассивПолей[3];
				КонецЕсли;
				Если МассивПолей.Количество() > 4 тогда
					Коммент = МассивПолей[4];
				КонецЕсли;
				Предст = ""+?(Не ПустаяСтрока(Поле1),("+"+Поле1),"");
				Предст = Предст + ?((Не ПустаяСтрока(Поле2)),(ПроверкаПустойСтроки(Предст,Ложь)+"(" + Поле2 + ")"),"");
				Предст = Предст + ?((Не ПустаяСтрока(Поле3)),(ПроверкаПустойСтроки(Предст,ПустаяСтрока(Поле2))+Поле3),"");
				Предст = Предст + ?((Не ПустаяСтрока(Поле4)),(ПроверкаПустойСтроки(Предст)+НСтр("ru='доб. ';uk='дод. '") + Поле4),"");
				Предст = Предст + ?((Не ПустаяСтрока(Коммент)),(ПроверкаПустойСтроки(Предст)+" " + Коммент),"");
				ОформлениеСтроки.Ячейки.ТиповойОтвет.Текст = Предст;
			Иначе
				ОформлениеСтроки.Ячейки.ТиповойОтвет.Текст = ""+Формат(ДанныеСтроки.ТиповойОтвет, "ДФ=dd.MM.yyyy; ДП=; БЛ=Нет; БИ=Да")+ " " + ДанныеСтроки.Ответ;
			КонецЕсли;
		КонецЕсли;
	//КонецЕсли;
	
КонецПроцедуры

Процедура ВопросыИОтветыПриАктивизацииСтроки(Элемент)
	
	ТаблицаСоставногоОтвета.Очистить();
	Если Элемент.ТекущиеДанные = Неопределено тогда
		Возврат;
	КонецЕсли;
	Если Элемент.ТекущиеДанные.Вопрос.ТипВопроса = Перечисления.ТипВопросаАнкеты.Табличный тогда
		ЭлементыФормы.ТабличноеПолеСоставногоОтвета.ИзменятьПорядокСтрок 	= Ложь;
		ЭлементыФормы.ТабличноеПолеСоставногоОтвета.ИзменятьСоставСтрок 	= Ложь;
		
		ТаблицаСоставногоОтвета = Новый ТаблицаЗначений;
		
		ТаблицаСоставногоОтвета.Колонки.Добавить("НомерСтроки", Новый ОписаниеТипов("Число"), "№");
		КолонкиТабличногоВопроса = Элемент.ТекущиеДанные.Вопрос.КолонкиТаблицы;
		Для каждого КолонкаТВ из КолонкиТабличногоВопроса Цикл
			ТаблицаСоставногоОтвета.Колонки.Добавить("колонка"+КолонкаТВ.НомерСтроки, КолонкаТВ.КолонкаТаблицы.ТипЗначения, КолонкаТВ.КолонкаТаблицы.Наименование);
		КонецЦикла;
		ЭлементыФормы.ТабличноеПолеСоставногоОтвета.СоздатьКолонки();
		ПараметрыПоиска = Новый Структура("ВопросВладелец");
		ПараметрыПоиска.ВопросВладелец = Элемент.ТекущиеДанные.Вопрос;
		МассивСтрок = СоставнойОтвет.НайтиСтроки(ПараметрыПоиска);
		СписокНомеровСтрок = Новый СписокЗначений;
		Для каждого ИндексНомераСтроки из МассивСтрок Цикл
			Если СписокНомеровСтрок.НайтиПоЗначению(ИндексНомераСтроки.НомерСтрокиВТаблице) = Неопределено тогда
				СписокНомеровСтрок.Добавить(ИндексНомераСтроки.НомерСтрокиВТаблице);
			КонецЕсли;
		КонецЦикла;
		
		ВсегоСтрок = 0;
		//Если СписокНомеровСтрок.Количество() > 0 тогда
		//	ВсегоСтрок = СписокНомеровСтрок[СписокНомеровСтрок.Количество()-1].Значение;
		//КонецЕсли;
		ВсегоСтрок = Элемент.ТекущиеДанные.Вопрос.КоличествоСтрокТаблицы;
		
		Для ИндексНомераСтроки = 1 по ВсегоСтрок Цикл
			ПараметрыПоиска = Новый Структура("ВопросВладелец, НомерСтрокиВТаблице");
			ПараметрыПоиска.ВопросВладелец = Элемент.ТекущиеДанные.Вопрос;
			ПараметрыПоиска.НомерСтрокиВТаблице = ИндексНомераСтроки;
			ОтветНаТабличныйВопрос = СоставнойОтвет.НайтиСтроки(ПараметрыПоиска);
			СтрокаОтвет = ТаблицаСоставногоОтвета.Добавить();
			СтрокаОтвет.НомерСтроки = ИндексНомераСтроки;
			НомерКолонки = 1; // пропустим номер строки
			Для каждого КолонкаОтвет из ОтветНаТабличныйВопрос Цикл
				СтрокаОтвет[НомерКолонки] = КолонкаОтвет.ТиповойОтвет;
				НомерКолонки = НомерКолонки + 1;
				Если НомерКолонки >= ТаблицаСоставногоОтвета.Колонки.Количество() тогда
					Прервать;
				КонецЕсли;
			КонецЦикла;
		КонецЦикла;
	ИначеЕсли Элемент.ТекущиеДанные.Вопрос.ТипВопроса = Перечисления.ТипВопросаАнкеты.СправочникСсылка_ВариантыОтветов_Несколько тогда
		ЭлементыФормы.ТабличноеПолеСоставногоОтвета.ИзменятьПорядокСтрок 	= Истина;
		ЭлементыФормы.ТабличноеПолеСоставногоОтвета.ИзменятьСоставСтрок 	= Истина;
		
		ТаблицаСоставногоОтвета = Новый ТаблицаЗначений;
		
		ТаблицаСоставногоОтвета.Колонки.Добавить("НомерСтроки", Новый ОписаниеТипов("Число"), "№");
		КолонкиТабличногоВопроса = Элемент.ТекущиеДанные.Вопрос.КолонкиТаблицы;
		ТаблицаСоставногоОтвета.Колонки.Добавить("ВариантОтвета", Элемент.ТекущиеДанные.Вопрос.ТипЗначения, НСтр("ru='Составной ответ';uk='Складова відповідь'"));
		ТаблицаСоставногоОтвета.Колонки.Добавить("Ответ", Новый ОписаниеТипов("Строка"), НСтр("ru='Развернутый ответ';uk='Розгорнута відповідь'"));
		ЭлементыФормы.ТабличноеПолеСоставногоОтвета.СоздатьКолонки();
		ЭлементыФормы.ТабличноеПолеСоставногоОтвета.Колонки.ВариантОтвета.ЭлементУправления.ВыборПоВладельцу = Элемент.ТекущиеДанные.Вопрос;
		ПараметрыПоиска 				= Новый Структура("ВопросВладелец");
		ПараметрыПоиска.ВопросВладелец 	= Элемент.ТекущиеДанные.Вопрос;
		МассивСтрок 					= СоставнойОтвет.НайтиСтроки(ПараметрыПоиска);
		Для каждого ИндексНомераСтроки из МассивСтрок Цикл
			СтрокаОтвет 			 	= ТаблицаСоставногоОтвета.Добавить();
			СтрокаОтвет.НомерСтроки 	= ИндексНомераСтроки.НомерСтрокиВТаблице;
			СтрокаОтвет.ВариантОтвета	= ИндексНомераСтроки.ТиповойОтвет;
			СтрокаОтвет.Ответ			= ИндексНомераСтроки.Ответ;
		КонецЦикла;
	Иначе	
		ЭлементыФормы.ТабличноеПолеСоставногоОтвета.ИзменятьПорядокСтрок 	= Ложь;
		ЭлементыФормы.ТабличноеПолеСоставногоОтвета.ИзменятьСоставСтрок 	= Ложь;
		ЭлементыФормы.ТабличноеПолеСоставногоОтвета.Колонки.Очистить();
	КонецЕсли;
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// ПРОЦЕДУРЫ - ОБРАБОТЧИКИ СОБЫТИЙ РЕКВИЗИТОВ ТАБЛИЧНОГО ПОЛЯ ВопросыИОтветы

// Процедура - обработчик события "Очистка" поля ввода "Вопрос".
Процедура ВопросыИОтветыВопросОчистка(Элемент, СтандартнаяОбработка)
	ЭлементыФормы.ВопросыИОтветы.ТекущиеДанные.ТиповойОтвет = Справочники.ВариантыОтветовОпросов.ПустаяСсылка();
КонецПроцедуры

// Процедура - обработчик события "ПриИзменении" поля ввода "ТиповойОтвет".
// если типовой ответ не требует дополнительных пояснений - очистим развернутый ответ
Процедура ВопросыИОтветыТиповойОтветПриИзменении(Элемент)
	
	Если Не ЭлементыФормы.ВопросыИОтветы.ТекущиеДанные.Вопрос.Предопределенный тогда
		Если ТипЗнч(Элемент.Значение) = Тип("СправочникСсылка.ВариантыОтветовОпросов") тогда
			Если Не Элемент.Значение.ТребуетРазвернутыйОтвет Тогда
				ЭлементыФормы.ВопросыИОтветы.ТекущиеДанные.Ответ = ""
			КонецЕсли;
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

Процедура ВопросыИОтветыТиповойОтветОчистка(Элемент, СтандартнаяОбработка)
	
	ЭлементыФормы.ВопросыИОтветы.ТекущиеДанные.ТиповойОтвет = ОбщегоНазначения.ПустоеЗначениеТипа(ЭлементыФормы.ВопросыИОтветы.ТекущиеДанные.Вопрос.ТипЗначения.Типы()[0]);
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// ПРОЦЕДУРЫ - ОБРАБОТЧИКИ СОБЫТИЙ ТАБЛИЧНОГО ПОЛЯ ТабличноеПолеСоставногоОтвета

Процедура ТабличноеПолеСоставногоОтветаПередОкончаниемРедактирования(Элемент, НоваяСтрока, ОтменаРедактирования, Отказ)
	
	АктуализироватьТЧСоставногоОтвета(Элемент, Отказ);
	Если Элемент.ТекущиеДанные <> Неопределено тогда
		Если ЭлементыФормы.ВопросыИОтветы.ТекущиеДанные.Вопрос.ТипВопроса = Перечисления.ТипВопросаАнкеты.СправочникСсылка_ВариантыОтветов_Несколько Тогда
			Если НЕ Элемент.ТекущиеДанные.ВариантОтвета.ТребуетРазвернутыйОтвет тогда
				Элемент.ТекущиеДанные.Ответ = "";
			КонецЕсли;
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

Процедура ТабличноеПолеСоставногоОтветаПриНачалеРедактирования(Элемент, НоваяСтрока)
	
	Если НоваяСтрока тогда
		Попытка
			Элемент.ТекущиеДанные.НомерСтроки = Элемент.Значение[ТаблицаСоставногоОтвета.Количество()-2].НомерСтроки+1;
		Исключение
			Элемент.ТекущиеДанные.НомерСтроки = 1;
		КонецПопытки;
	КонецЕсли;
	Попытка
		Элемент.Колонки.Ответ.ЭлементУправления.Доступность = Элемент.ТекущиеДанные.ВариантОтвета.ТребуетРазвернутыйОтвет;
		//будет срабатывать только для составных вопросов
	Исключение
	КонецПопытки
	
КонецПроцедуры

Процедура ТабличноеПолеСоставногоОтветаПриАктивизацииСтроки(Элемент)
	
	Если Элемент.ТекущаяСтрока = Неопределено тогда
		Возврат;
	КонецЕсли;
	
	Попытка
		Если Элемент.ТекущаяСтрока.ВариантОтвета.Владелец.ТипВопроса = Перечисления.ТипВопросаАнкеты.СправочникСсылка_ВариантыОтветов_Несколько тогда
			Элемент.Колонки.Ответ.ЭлементУправления.Доступность = Элемент.ТекущаяСтрока.ВариантОтвета.ТребуетРазвернутыйОтвет;
			//будет срабатывать только для составных вопросов
		КонецЕсли;
	Исключение
	КонецПопытки;
	
КонецПроцедуры

Процедура ТабличноеПолеСоставногоОтветаПриАктивизацииКолонки(Элемент)
	
	Если Элемент.ТекущаяСтрока = Неопределено тогда
		Возврат;
	КонецЕсли;
	
	Попытка
		Если Элемент.ТекущаяСтрока.ВариантОтвета.Владелец.ТипВопроса = Перечисления.ТипВопросаАнкеты.СправочникСсылка_ВариантыОтветов_Несколько тогда
			Элемент.Колонки.Ответ.ЭлементУправления.Доступность = Элемент.ТекущаяСтрока.ВариантОтвета.ТребуетРазвернутыйОтвет;
			//будет срабатывать только для составных вопросов
		КонецЕсли;
	Исключение
	КонецПопытки;
	
КонецПроцедуры

Процедура ТабличноеПолеСоставногоОтветаПослеУдаления(Элемент)
	
	АктуализироватьТЧСоставногоОтвета(Элемент, Ложь);
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// ОПЕРАТОРЫ ОСНОВНОЙ ПРОГРАММЫ

