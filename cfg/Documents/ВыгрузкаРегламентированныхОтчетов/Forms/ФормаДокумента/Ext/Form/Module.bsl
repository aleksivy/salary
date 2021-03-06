Перем НеЗаданИМНС;
Перем РежимВызоваЭкспортируемогоМетодаФормы;
Перем ОшибкаВыгрузки;
Перем НеСпрашивать;
Перем ФормаНавигацииПоОшибкам;
Перем ТаблицаСообщений;
Перем СпецОбработка;
Перем текСтрока;


////////////////////////////////////////////////////////////////////////////////
// СЛУЖЕБНЫЕ ПРОЦЕДУРЫ И ФУНКЦИИ

// Процедура устанавливает значение показателей ИдДок в тексте выгрузки. 
//
// Параметры:
//	Текст - ТекстовыйДокумент, хранящий текст, который необходимо изменить.
//	Организация - Организация для получения и установки счетчиков.
//
Процедура ПроставитьИдДок(Организация, СчДок = Неопределено, Отчет, ДатаОтчета)
	
	Если СчДок = Неопределено Тогда
		СчДок = РегламентированнаяОтчетность.ПолучитьСчетчикВыгруженныхДокументов(Организация, Отчет, ДатаОтчета);
	КонецЕсли;
	//Для Сч = 1 По Текст.КоличествоСтрок() Цикл
	//	ТекИнд = Текст.КоличествоСтрок() - Сч + 1;
	//	ТекСтр = Текст.ПолучитьСтроку(ТекИнд);
	//	Если Лев(ТекСтр, 6) = "ИдДок:" Тогда
	//		Текст.ЗаменитьСтроку(ТекИнд, Лев(ТекСтр,СтрДлина(ТекСтр) - 8) + Формат(СчДок, "ЧЦ=8; ЧВН=; ЧГ=0"));
		СчДок = СчДок + 1;
		//КонецЕсли;
	//КонецЦикла;
	РегламентированнаяОтчетность.УстановитьСчетчикВыгруженныхДокументов(Организация, СчДок - 1, отчет, ДатаОтчета);
	
КонецПроцедуры

Функция ДобавитьУзел(СтрокиДерева, XML)
	текСтрока = СтрокиДерева.Добавить();
	текСтрока.Параметр = XML.Имя;
	Возврат текСтрока.Строки;
КонецФункции

Процедура ЧитатьXML(ИмяФайлаЧтение)
	
	// очистим дерево
	Если Очистить = Истина Тогда
		ДеревоXML.Строки.Очистить();
		Очистить = Ложь;
    КонецЕсли;
	XML = Новый ЧтениеXML();
	XML.ОткрытьФайл(ИмяФайлаЧтение);
	
	текСтрока = ДеревоXML.Строки.Добавить();
	текСтрока.Параметр = ИмяФайлаЧтение;
	СтрокиДерева = текСтрока.Строки;
	
	Пока XML.Прочитать() Цикл
		Если XML.ТипУзла = ТипУзлаXML.Текст Тогда 
			// текст элемента, может быть только после начала элемента
			// в ТекСтрока сейчас должен быть узел
			текСтрока.Значение = XML.Значение;
		ИначеЕсли XML.ТипУзла = ТипУзлаXML.НачалоЭлемента Тогда
			СтрокиДерева = ДобавитьУзел(СтрокиДерева, XML);
		ИначеЕсли XML.ТипУзла = ТипУзлаXML.КонецЭлемента Тогда
			// установим родителя
			Если СтрокиДерева.Родитель.Родитель = Неопределено Тогда
				// нет узла верхнего уровня
				СтрокиДерева = СтрокиДерева.Родитель.Строки;
			Иначе
				СтрокиДерева = СтрокиДерева.Родитель.Родитель.Строки;
			КонецЕсли;
		КонецЕсли;

		Пока XML.ПрочитатьАтрибут() Цикл
			текСтрока = СтрокиДерева.Добавить();
			текСтрока.Параметр = XML.Имя;
			текСтрока.Значение = XML.Значение;
		КонецЦикла;

	КонецЦикла;
	XML.Закрыть();
	Дерево = Новый ХранилищеЗначения(ДеревоXML);
КонецПроцедуры

Процедура ЧитатьАрмЗс(ИмяФайлаЧтения)
Перем ФайлЧтения,Ст;	
	Если Очистить = Истина Тогда
		ДеревоXML.Строки.Очистить();
		Очистить = Ложь;
    КонецЕсли;
	ФайлЧтения = Новый ЧтениеТекста(ИмяФайлаЧтения,КодировкаТекста.ANSI	);
	текСтрока = ДеревоXML.Строки.Добавить();
	СтрокиДерева = текСтрока.Строки;
	Читать = Истина;  
	Пока Читать Цикл
	стр = ФайлЧтения.ПрочитатьСтроку(ст);
		Если Не Стр = Неопределено Тогда
			
			ПозицияРазделителя = Найти(стр,"=");
			текСтрока = СтрокиДерева.Добавить();
			текСтрока.Параметр = Сред(Стр,1,ПозицияРазделителя);
			текСтрока.Значение = Сред(стр,ПозицияРазделителя+1, СтрДлина(стр));   
		Иначе 
			Читать = Ложь;
		КонецЕсли;	
		КонецЦикла;	
		ФайлЧтения.Закрыть();	
		
		Дерево = Новый ХранилищеЗначения(ДеревоXML);
		
	КонецПроцедуры


// Процедура управляет видимостью и заголовками страниц панели "ОсновнаяПанель",
// а также выводит в соответствующие поля ввода тексты выгрузки из табличной части Выгрузки.
//
// Параметры:
//	Нет.
//
Процедура УправлениеВидимостьюТЧВыгрузки()
	
	ЭлементыФормы.ОсновнаяПанель.Страницы.ТекстВыгрузки.Видимость = Истина;
	
//	ТекстВыгрузкиВФормате = "";
	
	Для Каждого Стр Из Выгрузки Цикл
		ЭлементыФормы.ОсновнаяПанель.Страницы.ТекстВыгрузки.Видимость = Истина;
		ЭлементыФормы.ОсновнаяПанель.Страницы.ТекстВыгрузки.Заголовок = НСтр("ru='Текст выгрузки. Файл: ';uk='Текст вивантаження. Файл: '") + Стр.ИмяФайла;
	КонецЦикла;
	
	ЭлементыФормы.ОсновныеДействияФормы.Кнопки.Сохранить.Доступность = СуществуетХотяБыОдинТекстВыгрузки();
	
Конецпроцедуры

// Процедура формирует электронные представления выбранных в списке СпДокОсн документов.
//
//Процедура СформироватьТекстыВыгрузки(ПечатаемыеЛисты = Неопределено, ТекстВыгрузки = Неопределено)
Процедура СформироватьТекстыВыгрузки(ПечатаемыеЛисты = Неопределено, ИмяФайла = Неопределено, Формат)
	ФорматОтчета = Формат;
	Если ФормаНавигацииПоОшибкам <> Неопределено Тогда
		Если ФормаНавигацииПоОшибкам.Открыта() Тогда
			ФормаНавигацииПоОшибкам.Закрыть();
		КонецЕсли;
	КонецЕсли;
	
	УжеОткрФорма = Документы.ВыгрузкаРегламентированныхОтчетов.ПолучитьФорму("ФормаНавигацииПоОшибкам");
	Если УжеОткрФорма.Открыта() Тогда
		УжеОткрФорма.Закрыть();
	КонецЕсли;
	
	//проверка на наличие документов-оснований
	Если НЕ РежимВызоваЭкспортируемогоМетодаФормы Тогда
		КоличествоДокументовДляВыгрузки = 0;
		Для Каждого Стр Из СпДокОсн Цикл
			Если Стр.Пометка Тогда
				КоличествоДокументовДляВыгрузки = КоличествоДокументовДляВыгрузки + 1;
			КонецЕсли;
		КонецЦикла;
		
		Если КоличествоДокументовДляВыгрузки = 0 Тогда
			Сообщить(НСтр("ru='Не выбраны документы для выгрузки!';uk='Не обрані документи для вивантаження!'"), СтатусСообщения.Внимание);
			Возврат;
		КонецЕсли;
	КонецЕсли;
	//конец проверки на наличие документов-оснований
	
	
	//очищаем табличную часть, в которой хранятся ранее сформированные выгрузки
	Выгрузки.Очистить();
	
	//заполняем таблицу "документ для выгрузки <-> версия формата выгрузки"
	ВерсииИОтчеты = Новый ТаблицаЗначений;
	ВерсииИОтчеты.Колонки.Добавить("Док");
	ВерсииИОтчеты.Колонки.Добавить("Версия");
	
	СчетчикНевыгруженныхДокументов = 0;
	СчетчикВыгруженныхДокументов = 0;
	
	НомОтч = 0;
	
	ВыгрузкаПрервана = Ложь;
	
	Если ФорматОтчета = "XML" Тогда 
		Попытка
			ЧитатьXML(ИмяФайла);
			СчетчикВыгруженныхДокументов = СчетчикВыгруженныхДокументов + 1;
		Исключение
			
			СчетчикНеВыгруженныхДокументов = СчетчикНеВыгруженныхДокументов + 1;
			
		КонецПопытки;
	ИначеЕсли ФорматОтчета = "АРМЗС" Тогда 
		
		ЧитатьАРМЗС(ИмяФайла);
		СчетчикВыгруженныхДокументов = СчетчикВыгруженныхДокументов + 1;
	КонецЕсли; 
	
	Если (СчетчикВыгруженныхДокументов <> 0) И (СпДокОсн[0].Значение.ИсточникОтчета <> "РеестрНалоговыхНакладных") Тогда
		Отчет = РегламентированнаяОтчетность.ПолучитьРеглОтчетПоУмолчанию(СпДокОсн[0].Значение.ИсточникОтчета);
		ДатаОтчета = СпДокОсн[0].Значение.Ссылка.ДатаНачала;
		ПроставитьИдДок(Организация,,Отчет, ДатаОтчета);	
	КонецЕсли;
	
	Если СчетчикНеВыгруженныхДокументов <> 0 Тогда
		ОтобразитьФормуНавигацииПоОшибкам();
	Иначе
		ЭлементыФормы.ОсновнаяПанель.ТекущаяСтраница = ЭлементыФормы.ОсновнаяПанель.Страницы.ТекстВыгрузки;
	КонецЕсли;
	
	
КонецПроцедуры

// Сохраняет выбанные пользователем тексты выгрузки в файлы.
//
// Параметры:
//	ТолькоСохранениеТекстов - Булево. Если признак не равен Истина, то запись документа после сохранения не производится.
//
Процедура СохранитьТексты(ТолькоСохранениеТекстов = Ложь, Путь = Неопределено, КаталогВызоваДипост = Неопределено, Знач СчетчикФайлов = Неопределено, Знач СчетчикДокументов = Неопределено) Экспорт
		
	ВыгруженХотяБыОдинФайл = Истина;
	БылаОшибкаЗаписи	   = Ложь;
	//Если был выгружен хотя бы один файл и не было ошибок записи - сохраним
	//и проведем документ. Иначе выведем соответствующее сообщение
	Если ВыгруженХотяБыОдинФайл Тогда
		Если БылаОшибкаЗаписи = Истина Тогда
			Если НЕ РежимВызоваЭкспортируемогоМетодаФормы Тогда
				Сообщить(НСтр("ru='В процессе записи отчетов произошла ошибка!';uk='У процесі запису звітів відбулася помилка!'"), СтатусСообщения.Важное);
			КонецЕсли;
		Иначе
			Если НЕ ТолькоСохранениеТекстов Тогда
				ВыполнитьДействияПередЗаписью();
				УстановитьВремя(РежимАвтоВремя.ТекущееИлиПоследним);
				Записать(РежимЗаписиДокумента.Проведение);
			КонецЕсли;
			Если НЕ РежимВызоваЭкспортируемогоМетодаФормы И Путь = Неопределено Тогда
				Сообщить(НСтр("ru='Файлы с отчетами успешно записаны.';uk='Файли зі звітами успішно записані.'"));		
			КонецЕсли;
		КонецЕсли;
		
	КонецЕсли;		
КонецПроцедуры

// Процедура устанавливает заголовок у надписи НадписьПериодСоставленияОтчета.
//
// Параметры:
//	Нет.
//
Процедура ПоказатьПериод()

	СтрПериодОтчета = ПредставлениеПериода(НачалоДня(ПериодС), КонецДня(ПериодПо), "ФП = Истина" );
	ЭлементыФормы.НадписьПериодСоставленияОтчета.Заголовок = СтрПериодОтчета;

КонецПроцедуры // ПоказатьПериод()

// Процедура изменяет период выборки документов и показывает его на форме.
//
// Параметры:
//	Шаг - "сдвиг" от текущего установленного периода, в единицах, заданных
//			в поле "Периодичность".
//
Процедура ИзменитьПериод(Шаг)

	Если НЕ ИзмПараметровОтбора() Тогда
		Возврат;
	КонецЕсли;

	Если ПолеВыбораПериодичность = Перечисления.Периодичность.Квартал Тогда  // ежеквартально
		ПериодПо  = КонецКвартала(ДобавитьМесяц(ПериодПо, Шаг*3));
		ПериодС = НачалоКвартала(ПериодПо);
	ИначеЕсли ПолеВыбораПериодичность = Перечисления.Периодичность.Месяц Тогда  // ежемесячно
		ПериодПо  = КонецМесяца(ДобавитьМесяц(ПериодПо, Шаг)); 
		ПериодС = НачалоМесяца(ПериодПо);
	ИначеЕсли ПолеВыбораПериодичность = Перечисления.Периодичность.Год Тогда  // ежегодно
		ПериодПо  = КонецГода(ДобавитьМесяц(ПериодПо, Шаг*12)); 
		ПериодС = НачалоГода(ПериодПо);
	КонецЕсли;

	ПоказатьПериод();

КонецПроцедуры // ИзменитьПериод()

// Функция проверяет существуют ли тексты выгрузки в табличной части "Выгрузки".
//
// Параметры:
//	Нет.
//
// Возвращаемое значение - Булево, Истина, если хотя бы одни текст выгрузки существует; в противном случае - Ложь.
//
Функция СуществуетХотяБыОдинТекстВыгрузки()
	
	ЕстьТекстВыгрузки = Ложь;
	Для Каждого Стр Из Выгрузки Цикл
		Если НЕ Пустаястрока(Стр.Текст) Тогда
			ЕстьТекстВыгрузки = Истина;
		КонецЕсли;
	Конеццикла;
	Возврат ЕстьТекстВыгрузки;
	
КонецФункции

// Экспортная функция, вызываемая регламентированных отчетов, в которых предумотрена выгрузка.
// Функция формирует тексты выгрузки, сохраняет их в указанную пользователем папку.
// 
// Параметры:
// ДокументыОснования - список значений, содержащий перечень документов-оснований для выгрузки.
// ТекстВыгрузки - переменная, в которую помещается текст выгрузки.
// 
// Возвращает Истина, если выгрузка прошла успешно. В противном случае возвращает Ложь.
//
//Функция СформироватьИЗаписать(ДокументыОснования, ТекстВыгрузки = Неопределено, ПечатаемыеЛисты = Неопределено, ФайлДляСохранения = Неопределено) Экспорт
Функция СформироватьИЗаписать(ДокументыОснования, ИмяФайла = Неопределено, СчетчикДокументовОснований,ПечатаемыеЛисты = Неопределено, ФайлДляСохранения = Неопределено, ФорматРегОтчета) Экспорт
	
	ФорматОтчета = ФорматРегОтчета;
	
	//Реквизиты шапки берем из первого документа, если такой есть
	Если (ДокументыОснования.Количество() = 0) ИЛИ (ДокументыОснования.Получить(0).Значение = Неопределено) Тогда
		//если список документов-оснований пуст - прерываемся
		Возврат Ложь;
	КонецЕсли;
	
	ПервыйДок = ДокументыОснования.Получить(0).Значение;
	РежимВызоваЭкспортируемогоМетодаФормы = Истина;//взводим флаг вызова методов документа из другого объекта
	Дата = РабочаяДата;//устанавливаем даты документа. иначе не даст записать
	
	//инициализируем переменные документа. берем их из первого документа.
	//предполагается что в качестве документов-оснований задаются документы с 
	//одинаковым периодом. Иначе инициализацию ПериодС и ПериодПо следует переписать
	ПериодС = ПервыйДок.ДатаНачала;
	ПериодПо = ПервыйДок.ДатаОкончания;
	Организация = ПервыйДок.Организация;
		
	// устанавливаем префикс номера документа
	Если РегламентированнаяОтчетность.ИДКонфигурации()= "БП" Или РегламентированнаяОтчетность.ИДКонфигурации()= "ЗУП"  Тогда 
		ОбщегоНазначения.УстановитьНомерДокумента(ЭтотОбъект);
	КонецЕсли;
	
	//заполняем табличную часть "Выгрузки" документами-основаниями
	Для Каждого Стр Из ДокументыОснования Цикл
		Если СчетчикДокументовОснований = 1 Тогда 
			СпДокОсн.Добавить(Стр.Значение, , Истина);
		КонецЕсли;
	КонецЦикла;
	
	//формируем текст выгрузки. если во время формирования произошла ошибка - вернем признак ошибки
	СформироватьТекстыВыгрузки(ПечатаемыеЛисты, ИмяФайла,ФорматОтчета);
	Если ОшибкаВыгрузки Тогда
		Возврат Ложь;
	КонецЕсли;
	
	СохранитьТексты();
	Возврат Истина;
	
КонецФункции

// Процедура открывает или активизирует окно навигации по ошибкам.
//
// Параметры:
//	Нет.
//
Процедура ОтобразитьФормуНавигацииПоОшибкам()
	
	Если ТаблицаСообщений.Количество() = 0 Тогда
		НовСтр = ТаблицаСообщений.Добавить();
		НовСтр.Описание = НСтр("ru='Во время формирования произошли ошибки. Процесс прерван!';uk='Під час формування відбулися помилки. Процес перерваний!'");
	Иначе
		Если ФормаНавигацииПоОшибкам = Неопределено Тогда
			ФормаНавигацииПоОшибкам = Документы.ВыгрузкаРегламентированныхОтчетов.ПолучитьФорму("ФормаНавигацииПоОшибкам");
		КонецЕсли;
		ФормаНавигацииПоОшибкам.ВладелецТС = ТаблицаСообщений;
		ФормаНавигацииПоОшибкам.Открыть();
	КонецЕсли;
	
КонецПроцедуры

// Функция отрабатывает изменение одного из параметров отбора документов.
//
Функция ИзмПараметровОтбора() 
	
	Если (СпДокОсн.Количество() = 0) И (НЕ СуществуетХотяБыОдинТекстВыгрузки()) Тогда//пока так
		СпДокОсн.Очистить();
		КодИМНСВПолеВыбора = "";
		Возврат Истина;
	КонецЕсли;
	Если Вопрос(НСтр("ru='При изменении реквизита будут очищены список документов и тексты выгрузок."
"Продолжить?';uk='При зміні реквізиту будуть очищені список документів і тексти вивантажень."
"Продовжити?'"), РежимДиалогаВопрос.ДаНет) <> КодВозвратаДиалога.Да Тогда
		Возврат Ложь;
	Иначе
		СпДокОсн.Очистить();
		КодИМНСВПолеВыбора = "";
		//ЭлементыФормы.КодИМНС.СписокВыбора.Очистить();
		Выгрузки.Очистить();
		УправлениеВидимостьюТЧВыгрузки();
		Возврат Истина;
	КонецЕсли;
	
КонецФункции

// Процедура инициализирует значение КодИМНС документа и заполняет табличную часть Основная.
//
// Параметры:
//	Нет.
//
Процедура ВыполнитьДействияПередЗаписью()
	
	Основная.Очистить();
	Для Каждого Стр из СпДокОсн Цикл
		Если Стр.Пометка Тогда
			НовСтр = Основная.Добавить();
			НовСтр.Основание = Стр.Значение.Ссылка;
			
			ВыгружаемыйОтчет = Стр.Значение.ИсточникОтчета;
		КонецЕсли;
	КонецЦикла;
	
	
КонецПроцедуры

// Процедура открывает текущий отчет из списка выгружаемых.
//
Процедура ВыгружаемыеОтчетыПросмотр()
	
	Если ЭлементыФормы.СпДокОсн.ТекущаяСтрока <> Неопределено Тогда
		ТекДок = ЭлементыФормы.СпДокОсн.ТекущаяСтрока.Значение;
		ТекФорма = ТекДок.ПолучитьФорму(,ЭтаФорма, );
		Если ТекФорма.Открыта() Тогда
			ТекФорма.Активизировать();
		Иначе
			ТекФорма.Открыть();
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры


////////////////////////////////////////////////////////////////////////////////
// ПРОЦЕДУРЫ - ОБРАБОТЧИКИ СОБЫТИЙ ФОРМЫ

//Процедура - обработчик события ПередЗаписью формы.
//
Процедура ПередЗаписью(Отказ, РежимЗаписи, РежимПроведения)
	
	РежимЗаписи = РежимЗаписиДокумента.Проведение;
	ВыполнитьДействияПередЗаписью();
	
КонецПроцедуры

// Процедура - обработчик события ПриОткрытии формы.
//
Процедура ПриОткрытии()
	// Вставить содержимое обработчика.
	Если ЭтоНовый() Тогда
		
		УстановитьВремя(РежимАвтоВремя.ТекущееИлиПоследним);
		ОбщегоНазначения.УстановитьНомерДокумента(ЭтотОбъект);
		ПериодПо  = КонецМесяца(ДобавитьМесяц(КонецКвартала(Дата), -3));
		ПериодС = НачалоМесяца(ПериодПо);

		ПолеВыбораПериодичность = Перечисления.Периодичность.Месяц;
		
	Иначе
		
		Разница = ПериодПо - ПериодС;
		Если Разница <= КонецДня('20050131') - НачалоДня('20050101') Тогда
			ПолеВыбораПериодичность = Перечисления.Периодичность.Месяц;
		ИначеЕсли Разница <= КонецДня('20051231') - НачалоДня('20051001') Тогда
			ПолеВыбораПериодичность = Перечисления.Периодичность.Квартал;
		ИначеЕсли Разница <= КонецДня('20041231') - НачалоДня('20040101') Тогда
			ПолеВыбораПериодичность = Перечисления.Периодичность.Год;
		Иначе
			ПолеВыбораПериодичность = Перечисления.Периодичность.Месяц;
		КонецЕсли;
		
				
	КонецЕсли;
	
	РежимЗаписи = РежимЗаписиДокумента.Проведение;
	
	ДеревоXML = Дерево.Получить();
	
	Для Каждого Стр из Основная Цикл
		СпДокОсн.Добавить(Стр.Основание, РегламентированнаяОтчетность.ПредставлениеДокументаРеглОтч(Стр.Основание), Истина);
	КонецЦикла;

	УправлениеВидимостьюТЧВыгрузки();
	ПоказатьПериод();	
КонецПроцедуры


////////////////////////////////////////////////////////////////////////////////
// ПРОЦЕДУРЫ - ДЕЙСТВИЯ КОМАНДНЫХ ПАНЕЛЕЙ ФОРМЫ

// Процедура - действие кнопки СнятьФлажки командной панели КоманднаяПанельВыгружаемыеОтчеты.
//
Процедура КоманднаяПанельВыгружаемыеОтчетыСнятьФлажки(Кнопка)
	Если СуществуетХотяБыОдинТекстВыгрузки() Тогда
		Если Вопрос(НСтр("ru='При изменении списка документов будут очищены тексты выгрузки."
"Продолжить?';uk='При зміні списку документів будуть очищені тексти вивантаження."
"Продовжити?'"), РежимДиалогаВопрос.ДаНет) <> КодВозвратаДиалога.Да Тогда
			Возврат;
		Иначе
			Выгрузки.Очистить();
			УправлениеВидимостьюТЧВыгрузки();
		КонецЕсли;
	КонецЕсли;
	СпДокОсн.ЗаполнитьПометки(Ложь);
КонецПроцедуры

// Процедура - действие кнопки Вверх командной панели КоманднаяПанельВыгружаемыеОтчеты.
//
Процедура КоманднаяПанельВыгружаемыеОтчетыВверх(Кнопка)
	
	Если Элементыформы.СпДокОсн.ТекущаяСтрока <> Неопределено И СпДокОсн.Индекс(Элементыформы.СпДокОсн.ТекущаяСтрока) <> 0 Тогда
		СпДокОсн.Сдвинуть(Элементыформы.СпДокОсн.ТекущаяСтрока, -1);
	КонецЕсли;
	
КонецПроцедуры

// Процедура - действие кнопки Вниз командной панели КоманднаяПанельВыгружаемыеОтчеты.
//
Процедура КоманднаяПанельВыгружаемыеОтчетыВниз(Кнопка)
	
	Если Элементыформы.СпДокОсн.ТекущаяСтрока <> Неопределено И СпДокОсн.Индекс(Элементыформы.СпДокОсн.ТекущаяСтрока) <> СпДокОсн.Количество() - 1 Тогда
		СпДокОсн.Сдвинуть(Элементыформы.СпДокОсн.ТекущаяСтрока, 1);
	КонецЕсли;
	
КонецПроцедуры

// Процедура - действие кнопки УстановитьФлажки командной панели КоманднаяПанельВыгружаемыеОтчеты.
//
Процедура КоманднаяПанельВыгружаемыеОтчетыУстановитьФлажки(Кнопка)

	Если СуществуетХотяБыОдинТекстВыгрузки() Тогда
		Если Вопрос(НСтр("ru='При изменении списка документов будут очищены тексты выгрузки."
"Продолжить?';uk='При зміні списку документів будуть очищені тексти вивантаження."
"Продовжити?'"), РежимДиалогаВопрос.ДаНет) <> КодВозвратаДиалога.Да Тогда
			Возврат;
		Иначе
			Выгрузки.Очистить();
			УправлениеВидимостьюТЧВыгрузки();
		КонецЕсли;
	КонецЕсли;
	СпДокОсн.ЗаполнитьПометки(Истина);

КонецПроцедуры

// Процедура - действие кнопки Просмотр командной панели КоманднаяПанельВыгружаемыеОтчеты.
//
Процедура КоманднаяПанельВыгружаемыеОтчетыПросмотр(Кнопка)

	ВыгружаемыеОтчетыПросмотр();

КонецПроцедуры

// Процедура - действие кнопки Сохранить командной панели ОсновныеДействияФормы.
// 
Процедура ОсновныеДействияФормыСохранить(Кнопка)
	
	СохранитьТексты();
	
КонецПроцедуры

// Процедура - действие кнопки Заполнить командной панели КоманднаяПанельВыгружаемыеОтчеты.
//
Процедура КнопкаЗаполнитьНажатие(Элемент)
	// Вставить содержимое обработчика.
	
	Если Организация = Справочники.Организации.ПустаяСсылка() Тогда
		Предупреждение(НСтр("ru='Укажите организацию!';uk='Укажіть організацію!'"));
		Возврат;
	КонецЕсли;
	
	Если ПериодС = '00010101' или ПериодПо = '00010101' или ПериодС > ПериодПо Тогда
		Предупреждение(НСтр("ru='Неверно задан период!';uk='Невірно заданий період!'"));
		Возврат;
	КонецЕсли;
	
	Если СуществуетХотяБыОдинТекстВыгрузки() Тогда
		Если Вопрос(НСтр("ru='Тексты выгрузки будут очищены!"
"Продолжить?';uk='Тексти вивантаження будуть очищені!"
"Продовжити?'"), РежимДиалогаВопрос.ДаНет, , КодВозвратаДиалога.Нет, НСтр("ru='Внимание!';uk='Увага!'")) <> КодВозвратаДиалога.Да Тогда
			Возврат;
		КонецЕсли;
	КонецЕсли;
	
	Запрос = Новый Запрос();
	Запрос.Текст = "ВЫБРАТЬ
	               |	РегламентированныйОтчет.Ссылка
	               |ИЗ
	               |	Документ.РегламентированныйОтчет КАК РегламентированныйОтчет
	               |ГДЕ
	               |	РегламентированныйОтчет.ДатаОкончания >= &ДатаНачала
	               |	И РегламентированныйОтчет.ДатаОкончания <= &ДатаОкончания
	               |	И РегламентированныйОтчет.Организация = &Организация
	               |	И НЕ (РегламентированныйОтчет.ИсточникОтчета МЕЖДУ ""РегламентированныйОтчетАлкоПриложение1"" И ""РегламентированныйОтчетАлкоПриложение7"")";

	 //|	РегламентированныйОтчет.Проведен = &Проведен
	 
	Запрос.УстановитьПараметр("ДатаНачала", НачалоДня(ПериодС));
	Запрос.УстановитьПараметр("ДатаОкончания", КонецДня(ПериодПо));
	Запрос.УстановитьПараметр("Организация", Организация);
	
	спДокОсн.Очистить();
	//////ЭлементыФормы.КодИМНС.СписокВыбора.Очистить();
	
	Выборка = Запрос.Выполнить().Выбрать();
	
	Пока Выборка.Следующий() Цикл
		спДокОсн.Добавить(Выборка.Ссылка, РегламентированнаяОтчетность.ПредставлениеДокументаРеглОтч(Выборка.Ссылка), Истина);
	КонецЦикла;
	
	Выгрузки.Очистить();
	УправлениеВидимостьюТЧВыгрузки();
	 
КонецПроцедуры


////////////////////////////////////////////////////////////////////////////////
// ПРОЦЕДУРЫ - ОБРАБОТЧИКИ СОБЫТИЙ ЭЛЕМЕНТОВ ФОРМЫ

// Процедура - обработчик события Нажатие кнопки КнопкаПредыдущийПериод формы.
//
Процедура КнопкаПредыдущийПериодНажатие(Элемент)

	ИзменитьПериод(-1);

КонецПроцедуры // КнопкаПредыдущийПериодНажатие()

// Процедура - обработчик события Нажатие кнопки КнопкаСледующийПериод формы.
//
Процедура КнопкаСледующийПериодНажатие(Элемент)

	ИзменитьПериод(1);

КонецПроцедуры // КнопкаСледующийПериодНажатие()

// Процедура - обработчик события Выбор поля списка СпДокОсн.
//
Процедура СпДокОснВыбор(Элемент, ЭлементСписка)

	ВыгружаемыеОтчетыПросмотр();

КонецПроцедуры

// Процедура - обработчик события ПриИзменении поля ввода Организация.
//
Процедура ОрганизацияПриИзменении(Элемент)
	
	ОбщегоНазначения.УстановитьНомерДокумента(ЭтотОбъект);
	
КонецПроцедуры

// Процедура - обработчик события ОбработкаВыбора поля выбора Периодичность.
//
Процедура ПолеВыбораПериодичностьОбработкаВыбора(Элемент, ВыбранноеЗначение, СтандартнаяОбработка)

	Если ВыбранноеЗначение = ЭлементыФормы.ПолеВыбораПериодичность.Значение Тогда
		Возврат;
	КонецЕсли;

	Если НЕ ИзмПараметровОтбора() Тогда
		СтандартнаяОбработка = Ложь;
		Возврат;
	КонецЕсли;
	
	ПолеВыбораПериодичность = ВыбранноеЗначение;

	Если ПолеВыбораПериодичность = Перечисления.Периодичность.Квартал Тогда  // ежеквартально
		ПериодПо  = КонецКвартала(ПериодПо);
		ПериодС = НачалоКвартала(ПериодПо);
	ИначеЕсли ПолеВыбораПериодичность = Перечисления.Периодичность.Месяц Тогда  // ежеквартально
		ПериодПо  = КонецМесяца(ПериодПо);
		ПериодС = НачалоМесяца(ПериодПо);
	ИначеЕсли ПолеВыбораПериодичность = Перечисления.Периодичность.Год Тогда  // ежегодно
		ПериодПо  = КонецГода(ПериодПо);
		ПериодС = НачалоГода(ПериодПо);
	КонецЕсли;

	мПериодичность = ПолеВыбораПериодичность;

	ПоказатьПериод();

КонецПроцедуры

// Процедура - обработчик события ОбработкаВыбора поля ввода Организация.
//
Процедура ОрганизацияОбработкаВыбора(Элемент, ВыбранноеЗначение, СтандартнаяОбработка)
	
	Если ВыбранноеЗначение = Организация Тогда
		Возврат;
	КонецЕсли;
	
	Если НЕ ИзмПараметровОтбора() Тогда
		СтандартнаяОбработка = Ложь;
		Возврат;
	КонецЕсли;
	
КонецПроцедуры

// Процедура - обработчик события ПриИзмененииФлажка поля списка СпДокОсн.
//
Процедура СпДокОснПриИзмененииФлажка(Элемент)
	// Вставить содержимое обработчика.
	ЕстьТекстВыгрузки = Ложь;
	Для Каждого Стр Из Выгрузки Цикл
		Если НЕ Пустаястрока(Стр.Текст) Тогда
			ЕстьТекстВыгрузки = Истина;
		КонецЕсли;
	Конеццикла;
	Если ЕстьТекстВыгрузки Тогда
		Если Вопрос(НСтр("ru='При изменении списка документов будут очищены тексты выгрузки."
"Продолжить?';uk='При зміні списку документів будуть очищені тексти вивантаження."
"Продовжити?'"), РежимДиалогаВопрос.ДаНет) <> КодВозвратаДиалога.Да Тогда
			Элементыформы.СпДокОсн.ТекущаяСтрока.Пометка = НЕ Элементыформы.СпДокОсн.ТекущаяСтрока.Пометка;
		Иначе
			Выгрузки.Очистить();
			УправлениеВидимостьюТЧВыгрузки();
		КонецЕсли;
	КонецЕсли;
КонецПроцедуры

// Процедура - обработчик события Очистка поля ввода Организация.
//
Процедура ОрганизацияОчистка(Элемент, СтандартнаяОбработка)
	
	Если НЕ ИзмПараметровОтбора() Тогда
		СтандартнаяОбработка = Ложь;
		Возврат;
	КонецЕсли;
	
КонецПроцедуры

Процедура ПолеВыбораПериодичностьОчистка(Элемент, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
КонецПроцедуры


////////////////////////////////////////////////////////////////////////////////
// ОПЕРАТОРЫ ОСНОВНОЙ ПРОГРАММЫ

ЭлементыФормы.ПолеВыбораПериодичность.СписокВыбора.Добавить(Перечисления.Периодичность.Месяц,   НСтр("ru='Месяц';uk='Місяць'"));
ЭлементыФормы.ПолеВыбораПериодичность.СписокВыбора.Добавить(Перечисления.Периодичность.Квартал, НСтр("ru='Квартал';uk='Квартал'"));
ЭлементыФормы.ПолеВыбораПериодичность.СписокВыбора.Добавить(Перечисления.Периодичность.Год, НСтр("ru='Год';uk='Рік'"));
РежимВызоваЭкспортируемогоМетодаФормы = Ложь;
ОшибкаВыгрузки = Ложь;
НеСпрашивать = Ложь;

ТаблицаСообщений = Новый ТаблицаЗначений;
ТаблицаСообщений.Колонки.Добавить("ОтчетДок");
ТаблицаСообщений.Колонки.Добавить("Отчет");
ТаблицаСообщений.Колонки.Добавить("Раздел");
ТаблицаСообщений.Колонки.Добавить("Страница");
ТаблицаСообщений.Колонки.Добавить("Строка");
ТаблицаСообщений.Колонки.Добавить("СтрокаПП");
ТаблицаСообщений.Колонки.Добавить("ИмяЯчейки");
ТаблицаСообщений.Колонки.Добавить("Графа");
ТаблицаСообщений.Колонки.Добавить("Описание");
