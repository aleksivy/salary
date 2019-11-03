﻿////////////////////////////////////////////////////////////////////////////////
// ПРОЦЕДУРЫ И ФУНКЦИИ РАБОТЫ С ФАЙЛАМИ
 
// Выделяет из имени файла его расширение (набор символов после последней точки).
//
// Параметры
//  ИмяФайла     – Строка, содержащая имя файла, неважно с именем каталога или без.
//
// Возвращаемое значение:
//   Строка – расширение файла.
//
Функция ПолучитьРасширениеФайла(Знач ИмяФайла) Экспорт
	
	Расширение = ПолучитьЧастьСтрокиОтделеннойСимволом(ИмяФайла, ".");
	Возврат Расширение;
	
КонецФункции

// Выделяет из полного пути к файлу его имя (набор символов после последней \).
//
// Параметры
//  ПутьКФайлу     – Строка, содержащая имя файла, неважно с именем каталога или без.
//
// Возвращаемое значение:
//   Строка – расширение файла.
//
Функция ПолучитьИмяФайлаИзПолногоПути(Знач ПутьКФайлу) Экспорт
	
	ИмяФайла = ПолучитьЧастьСтрокиОтделеннойСимволом(ПутьКФайлу, "\");
	Возврат ИмяФайла;
	
КонецФункции

// функция возвращает часть строки после последнего встреченного символа в строке
Функция ПолучитьЧастьСтрокиОтделеннойСимволом(Знач ИсходнаяСтрока, Знач СимволПоиска)
	
	ПозицияСимвола = СтрДлина(ИсходнаяСтрока);
	Пока ПозицияСимвола >= 1 Цикл
		
		Если Сред(ИсходнаяСтрока, ПозицияСимвола, 1) = СимволПоиска Тогда
						
			Возврат Сред(ИсходнаяСтрока, ПозицияСимвола + 1); 
			
		КонецЕсли;
		
		ПозицияСимвола = ПозицияСимвола - 1;	
	КонецЦикла;

	Возврат "";
  	
КонецФункции


// Составляет полное имя файла из имени каталога и имени файла.
//
// Параметры
//  ИмяКаталога  – Строка, содержащая путь к каталогу файла на диске.
//  ИмяФайла     – Строка, содержащая имя файла, без имени каталога.
//
// Возвращаемое значение:
//   Строка – полное имя файла с учетом каталога.
//
Функция ПолучитьИмяФайла(ИмяКаталога, ИмяФайла) Экспорт

	Если Не ПустаяСтрока(ИмяФайла) Тогда
		
		Возврат ИмяКаталога + ?(Прав(ИмяКаталога, 1) = "\", "", "\") + ИмяФайла;	
		
	Иначе
		
		Возврат ИмяКаталога;
		
	КонецЕсли;

КонецФункции // ПолучитьИмяФайла()

// Процедура полное имя файла разбивает на путь в файлу и имя самого файла
//
// Параметры
//  ПолноеИмяФайла  – Строка, содержащая полное имя файла на диске.
//  ИмяКаталога  – Строка, содержащая путь к каталогу файла на диске.
//  ИмяФайла     – Строка, содержащая имя файла, без имени каталога.
//
Процедура ПолучитьКаталогИИмяФайла(Знач ПолноеИмяФайла, ИмяКаталога, ИмяФайла) Экспорт
	
	// находим последний с конца "\" все что до него - это путь, после - имя
	НомерПозиции = СтрДлина(ПолноеИмяФайла);
	Пока НомерПозиции <> 0 Цикл
		
		Если Сред(ПолноеИмяФайла, НомерПозиции, 1) = "\" Тогда
			
			ИмяКаталога = Сред(ПолноеИмяФайла, 1, НомерПозиции - 1);
			ИмяФайла = Сред(ПолноеИмяФайла, НомерПозиции + 1);
			Возврат;
			
		КонецЕсли;
		
		НомерПозиции = НомерПозиции - 1;
		
	КонецЦикла;
	
	// так и не нашли слешей, значит все- это имя файла
	ИмяФайла = ПолноеИмяФайла;
	ИмяКаталога = "";
	
КонецПроцедуры

// Процедура меняет расширение имени переданного файла (сам файл не меняется, меняется колько строка)
//
// Параметры
//  ИмяФайла  – Строка, содержащая полное имя файла на диске.
//  НовоеРасширениеФайла  – Строка, содержащая новое расширение файла.
//
Процедура УстановитьРасширениеФайла(ИмяФайла, Знач НовоеРасширениеФайла) Экспорт
	
	// к расширению точку добавляем
	Если Сред(НовоеРасширениеФайла, 1, 1) <> "." Тогда
		ЗначениеНовогоРасширения = "." + НовоеРасширениеФайла;	
	Иначе
		ЗначениеНовогоРасширения = НовоеРасширениеФайла;	
	КонецЕсли;
	// если не находим точку в текущем имени файла, то просто приписываем к нему новое расширение с конца
	ПозицияТочки = СтрДлина(ИмяФайла);
	Пока ПозицияТочки >= 1 Цикл
		
		Если Сред(ИмяФайла, ПозицияТочки, 1) = "." Тогда
						
			ИмяФайла = Сред(ИмяФайла, 1, ПозицияТочки - 1) + ЗначениеНовогоРасширения;
			Возврат; 
			
		КонецЕсли;
		
		ПозицияТочки = ПозицияТочки - 1;	
	КонецЦикла;
	
	// не нашли точку в имени файла
	ИмяФайла = ИмяФайла + ЗначениеНовогоРасширения;	
	
КонецПроцедуры

// Функция определяет дату последней модификации существующего файла на диске
// Параметры
//  ИмяФайла  – Строка, содержащая полный путь к файла на диске.
//
// Возвращаемое значение:
//   Дата – Дата последней модификации файла
//
Функция ПолучитьДатуФайла(Знач ИмяФайла) Экспорт
	
	Файл = Новый Файл(ИмяФайла);
	Возврат Файл.ПолучитьВремяИзменения();
	 
КонецФункции

// Формирует строку фильтра для диалога выбора файла с типами файлов.
//
// Параметры
//  Нет.
//
// Возвращаемое значение:
//   Строка – фильтр по типам файлов для диалога выбора файла.
//
Функция ПолучитьФильтрФайлов() 
	Возврат "Все файлы (*.*)|*.*|"
	      + "Документ Microsoft Word (*.doc;*.docx)|*.doc;*.docx|"
	      + "Документ Microsoft Excell (*.xls;*.xlsx)|*.xls;*.xlsx|"
	      + "Документ Microsoft PowerPoint (*.ppt;*.pptx)|*.ppt;*.pptx|"
	      + "Документ Microsoft Visio (*.vsd)|*.vsd|"
	      + "Письмо электронной почты (*.msg)|*.msg|"
	      + "Картинки (*.bmp;*.dib;*.rle;*.jpg;*.jpeg;*.tif;*.gif;*.png;*.ico;*.wmf;*.emf)|*.bmp;*.dib;*.rle;*.jpg;*.jpeg;*.tif;*.gif;*.png;*.ico;*.wmf;*.emf|"
	      + "Текстовый документ (*.txt)|*.txt|"
	      + "Табличный документ (*.mxl)|*.mxl|";

КонецФункции // ПолучитьФильтрФайлов()

// Формирует строку фильтра для диалога выбора картинки с типами файлов.
//
// Параметры
//  Нет.
//
// Возвращаемое значение:
//   Строка – фильтр по типам файлов для диалога выбора картинки.
//
Функция ПолучитьФильтрИзображений() Экспорт

	Возврат "Все картинки (*.bmp;*.dib;*.rle;*.jpg;*.jpeg;*.tif;*.gif;*.png;*.ico;*.wmf;*.emf)|*.bmp;*.dib;*.rle;*.jpg;*.jpeg;*.tif;*.gif;*.png;*.ico;*.wmf;*.emf|" 
	      + "Формат bmp (*.bmp;*.dib;*.rle)|*.bmp;*.dib;*.rle|"
	      + "Формат jpeg (*.jpg;*.jpeg)|*.jpg;*.jpeg|"
	      + "Формат tiff (*.tif)|*.tif|"
	      + "Формат gif (*.gif)|*.gif|"
	      + "Формат png (*.png)|*.png|"
	      + "Формат icon (*.ico)|*.ico|"
	      + "Формат метафайл (*.wmf;*.emf)|*.wmf;*.emf|";

КонецФункции // ПолучитьФильтрИзображений()

// Формирует имя каталога для сохранения/чтения файлов. Для различных типов объектов возможны 
// различные алгоритмы определения каталога.
//
// Параметры
//  ОбъектФайла  – Ссылка на объект данных, для которого прикрепляются файлы.
//
// Возвращаемое значение:
//   Строка – каталог файлов для указанного объекта и пользователя.
//
Функция ПолучитьИмяКаталога() Экспорт

	// Получим рабочий каталог из свойств пользователя.
	РабочийКаталог = УправлениеПользователями.ПолучитьЗначениеПоУмолчанию(ПараметрыСеанса.ТекущийПользователь, "ОсновнойКаталогФайлов");

	// Если рабочий каталог не указан получим каталог временных файлов прогаммы
	Если ПустаяСтрока(РабочийКаталог) Тогда
		РабочийКаталог = КаталогВременныхФайлов();
	КонецЕсли;

	// Так как при различных указаниях рабочего каталога возможно наличие или отсутствие
	// последнего слеша, приведем строку каталога к унифицированному виду - без слеша на конце.
	Если Прав(РабочийКаталог, 1) = "\" Тогда
		РабочийКаталог = Лев(РабочийКаталог, СтрДлина(РабочийКаталог) - 1);
	КонецЕсли;

	Возврат РабочийКаталог;

КонецФункции // ПолучитьИмяКаталога()

// функция возвращает список запрещенных символов в именах файлов
// Возвращаемое значение:
//   Список значений в котором хранится список всех запрещенных символов в именах файлов.
//
Функция ПолучитьСписокЗапрещенныхСимволовВИменахФайлов()
	
	СписокСимволов = Новый СписокЗначений();
	
	СписокСимволов.Добавить("\");
	СписокСимволов.Добавить("/");
	СписокСимволов.Добавить(":");
	СписокСимволов.Добавить("*");
	СписокСимволов.Добавить("&");
	СписокСимволов.Добавить("""");
	СписокСимволов.Добавить("<");
	СписокСимволов.Добавить(">");
	СписокСимволов.Добавить("|");
	
	Возврат СписокСимволов;
	
КонецФункции

// функция формирует имя файла выбрасывая из первоначально предложенного имени все
// запрещенные символы
// Параметры
//  ИмяФайла     – Строка, содержащая имя файла, без каталога.
//
// Возвращаемое значение:
//   Строка – имя файла, которое может быть использовано в файловой системе
//
Функция УдалитьЗапрещенныеСимволыИмени(Знач ИмяФайла) Экспорт

	ИтоговоеИмяФайла = СокрЛП(ИмяФайла);
	
	Если ПустаяСтрока(ИтоговоеИмяФайла) Тогда
		
		Возврат ИтоговоеИмяФайла;
		
	КонецЕсли;
	
	СписокСимволов = ПолучитьСписокЗапрещенныхСимволовВИменахФайлов();
	
	Для Каждого СтрокаЗапретногоСимвола  Из СписокСимволов Цикл
		
		ИтоговоеИмяФайла = СтрЗаменить(ИтоговоеИмяФайла,  СтрокаЗапретногоСимвола.Значение, "");			
		
	КонецЦикла;
	
	Возврат ИтоговоеИмяФайла;

КонецФункции // УдалитьЗапрещенныеСимволыИмени()

// Получает индекс пиктограммы файла из коллекции пиктограмм в зависимости от расширения файла.
//
// Параметры
//  РасширениеФайла – Строка, содержащая расширение файла.
//
// Возвращаемое значение:
//   Число – индекс пиктограммы в коллекции.
//
Функция ПолучитьИндексПиктограммыФайла(РасширениеФайла) Экспорт

	РасширениеФайла = Врег(РасширениеФайла);

	Если Найти(",1CD,CF,CFU,DT,", "," + РасширениеФайла + ",") > 0 Тогда
		Возврат 1;
	ИначеЕсли "MXL" = РасширениеФайла Тогда
		Возврат 2;
	ИначеЕсли "TXT" = РасширениеФайла Тогда
		Возврат 3;
	ИначеЕсли "EPF" = РасширениеФайла Тогда
		Возврат 4;
	ИначеЕсли Найти(",BMP,DIB,RLE,JPG,JPEG,TIF,GIF,PNG,ICO,WMF,EMF,", "," + РасширениеФайла + ",") > 0 Тогда
		Возврат 5;
	ИначеЕсли Найти(",HTM,HTML,MHT,", "," + РасширениеФайла + ",") > 0 Тогда
		Возврат 6;
	ИначеЕсли ("DOC" = РасширениеФайла) ИЛИ ("DOCX" = РасширениеФайла) Тогда   
		Возврат 7;
	ИначеЕсли ("XLS" = РасширениеФайла) ИЛИ ("XLSX" = РасширениеФайла) Тогда
		Возврат 8;
	ИначеЕсли ("PPT" = РасширениеФайла) ИЛИ ("PPTX" = РасширениеФайла) Тогда
		Возврат 9;
	ИначеЕсли "VSD" = РасширениеФайла Тогда
		Возврат 10;
	ИначеЕсли "MPP" = РасширениеФайла Тогда
		Возврат 11;
	ИначеЕсли "MDB" = РасширениеФайла Тогда
		Возврат 12;
	ИначеЕсли "XML" = РасширениеФайла Тогда
		Возврат 13;
	ИначеЕсли "MSG" = РасширениеФайла Тогда
		Возврат 14;
	ИначеЕсли Найти(",RAR,ZIP,ARJ,CAB,", "," + РасширениеФайла + ",") > 0 Тогда
		Возврат 15;
	ИначеЕсли Найти(",EXE,COM,,", "," + РасширениеФайла + ",") > 0 Тогда
		Возврат 16;
	ИначеЕсли "BAT" = РасширениеФайла Тогда
		Возврат 17;
	Иначе
		Возврат 0;
	КонецЕсли;

КонецФункции // ПолучитьИндексПиктограммыФайла()

// Функция определяет, есть ли у объекта элементы в хранилище дополнительной информации
//
// Параметры
//  Объект - СправочникСсылка, ДокументСсылка, объект для которого определяем наличие файлов
//
// Возвращаемое значение:
//   Булево
//
Функция ЕстьДополнительнаяИнформация(Объект, ИмяСправочника = "ХранилищеДополнительнойИнформации") Экспорт

	ЗначениеНайдено = Ложь;
	
	Если ЗначениеЗаполнено(Объект) Тогда
		Запрос = Новый Запрос;
		Запрос.УстановитьПараметр("Объект", Объект);
		Запрос.Текст = "
		|ВЫБРАТЬ РАЗРЕШЕННЫЕ ПЕРВЫЕ 1
		|	ХранилищеДополнительнойИнформации.Ссылка,
		|	ХранилищеДополнительнойИнформации.Объект
		|ИЗ
		|	Справочник." + ИмяСправочника + " КАК ХранилищеДополнительнойИнформации
		|ГДЕ
		|	ХранилищеДополнительнойИнформации.Объект = &Объект
		|";
		ЗначениеНайдено = НЕ Запрос.Выполнить().Пустой();
	КонецЕсли;
	
	Возврат ЗначениеНайдено;
	
КонецФункции

#Если Клиент Тогда
	
// Открывает переданный файл на диске с учетом типа файлов. Файлы, с которыми 
// может работать 1С:Предприятие открываются в 1С:Предприятии. Остальные файлы
// пытаются открыться зарегистрированным для них в системе приложением.
//
// Параметры
//  ИмяКаталога  – Строка, содержащая путь к каталогу файла на диске.
//  ИмяФайла     – Строка, содержащая имя файла, без имени каталога.
//
Процедура ОткрытьФайлДополнительнойИнформации(ИмяКаталога, ИмяФайла) Экспорт

	ПолноеИмяФайла = ПолучитьИмяФайла(ИмяКаталога, ИмяФайла);
	РасширениеФайла = Врег(ПолучитьРасширениеФайла(ИмяФайла));

	Если РасширениеФайла = "MXL" Тогда

		ТабличныйДокумент = Новый ТабличныйДокумент;
		ТабличныйДокумент.Прочитать(ПолноеИмяФайла);
		ТабличныйДокумент.Показать(ИмяФайла, Лев(ИмяФайла, СтрДлина(ИмяФайла) - 4));

	ИначеЕсли РасширениеФайла = "TXT" Тогда

		ТекстовыйДокумент = Новый ТекстовыйДокумент;
		ТекстовыйДокумент.Прочитать(ПолноеИмяФайла);
		ТекстовыйДокумент.Показать(ИмяФайла, Лев(ИмяФайла, СтрДлина(ИмяФайла) - 4));

	ИначеЕсли РасширениеФайла = "EPF" Тогда

		ВнешняяОбработка = ВнешниеОбработки.Создать(ПолноеИмяФайла);
		ВнешняяОбработка.ПолучитьФорму().Открыть();

	Иначе

		ЗапуститьПриложение(ПолноеИмяФайла);

	КонецЕсли;

КонецПроцедуры // ОткрытьФайлДополнительнойИнформации()

// Проверяет наличие каталога на диске и предлагает создать, если каталога не существует.
//
// Параметры
//  ИмяКаталога  – Строка, содержащая путь к каталогу файла на диске.
//
// Возвращаемое значение:
//   Булево – Истина, если каталог существует или создан, Ложь, если каталога нет.
//
Функция ПроверитьСуществованиеКаталога(ИмяКаталога) Экспорт

	КаталогНаДиске = Новый Файл(ИмяКаталога);
	Если КаталогНаДиске.Существует() Тогда
		Возврат Истина;
	Иначе
		Ответ = Вопрос(НСтр("ru='Указанный каталог не существует. Создать каталог?';uk='Вказаний каталог не існує. Створити каталог?'"), РежимДиалогаВопрос.ДаНет);
		Если Ответ = КодВозвратаДиалога.Да Тогда
			
			СоздатьКаталог(ИмяКаталога);
			Возврат Истина;
			
		Иначе
			
			Возврат Ложь;
			
		КонецЕсли;
	КонецЕсли;

КонецФункции // ПроверитьСуществованиеКаталога()
	
// Позволяет пользователю выбрать каталог на диске.
//
// Параметры
//  ИмяКаталога  – Строка, содержащая начальный путь к каталогу на диске.
//	ЗаголовокДиалога - Строка, содержащая заголовок диалога
//
// Возвращаемое значение:
//   Булево – Истина, если каталог выбран, Ложь, если нет.
//
Функция ВыбратьКаталог(ИмяКаталога, Знач ЗаголовокДиалога = "Укажите каталог") Экспорт

	Диалог = Новый ДиалогВыбораФайла(РежимДиалогаВыбораФайла.ВыборКаталога);
	Диалог.Заголовок = ЗаголовокДиалога;
	Диалог.МножественныйВыбор = Ложь;
	Диалог.Каталог = ИмяКаталога;

	Если Диалог.Выбрать() Тогда
		ИмяКаталога = Диалог.Каталог;
		Возврат Истина;
	Иначе
		Возврат Ложь;
	КонецЕсли;

КонецФункции // ВыбатьКаталог()

// Сохраняет файл на диске.
//
// Параметры
//  Хранилище    – ХранилищеЗначения, которое содержит объект типа 
//                 ДвоичныеДанные с файлом для записи на диск.
//  ИмяФайла     – Строка, содержащая полное имя файла.
//  ТолькоЧтение – Булево, признак установки записываемому файлу атрибута ТолькоЧтение.
//  СпособПерезаписи – Строка. Параметр определеляет способ перезаписи существующих
//                 файлов на диске. В зависимости от пришедшего параметра выдается или
//                 не выдается запрос на перезапись файлов. Может устанавливаться в теле
//                 функции, если это необходимо. Принимаемые значения:
//                 "" (пустая строка) - это означает, что диалог еще ни разу не задавался
//                 и при наличии существующего файла будет выдан диалог запроса перезаписи.
//                 ДА - предыдущий файл был перезаписан, но перезапись текущего надо 
//                 запросить снова
//                 НЕТ - предыдущий файл не был перезаписан, но перезапись текущего надо 
//                 запросить снова
//                 ДАДЛЯВСЕХ - предыдущий файл был перезаписан, и все последующие тоже 
//                 надо перезаписывать.
//                 НЕТДЛЯВСЕХ - предыдущий файл не был перезаписан, и все последующие тоже 
//                 не надо перезаписывать.
//
// Возвращаемое значение:
//   Булево – Истина, если каталог выбран, Ложь, если нет.
//
Функция СохранитьФайлНаДиске(Хранилище, ИмяФайла, ТолькоЧтение, СпособПерезаписи, ВопросОПерезаписи = Истина, ИмяСправочника = "ХранилищеДополнительнойИнформации") Экспорт

	Попытка

		ФайлНаДиске = Новый Файл(ИмяФайла);
		КаталогНаДиске = Новый Файл(ФайлНаДиске.Путь);

		Если Не КаталогНаДиске.Существует() Тогда
			СоздатьКаталог(ФайлНаДиске.Путь);
		КонецЕсли;

		Если ФайлНаДиске.Существует() И ВопросОПерезаписи = Истина Тогда

			Если СпособПерезаписи = ""
			 ИЛИ Врег(СпособПерезаписи) = "ДА"
			 ИЛИ Врег(СпособПерезаписи) = "НЕТ" Тогда

				ФормаЗапросаПерезаписиФайлов = Справочники[ИмяСправочника].ПолучитьФорму("ФормаЗапросаПерезаписиФайлов");
				ФормаЗапросаПерезаписиФайлов.ТекстПредупреждения = 
				    НСтр("ru='На локальном диске уже существует файл:"
"';uk='На локальному диску вже існує файл:"
"'") + ИмяФайла + НСтр("ru='"
"Перезаписать имеющийся файл?';uk='"
"Перезаписати існуючий файл?'");
				СпособПерезаписи = ФормаЗапросаПерезаписиФайлов.ОткрытьМодально();

				Если СпособПерезаписи = Неопределено
				 ИЛИ Врег(СпособПерезаписи) = "НЕТ"
				 ИЛИ Врег(СпособПерезаписи) = "НЕТДЛЯВСЕХ" Тогда
					Возврат Ложь;
				КонецЕсли;

			ИначеЕсли Врег(СпособПерезаписи) = "НЕТДЛЯВСЕХ" Тогда

				Возврат Ложь;

			КонецЕсли;

			// Если существующему файлу установлено ТолькоЧтение, отменим эту установку.
			Если ФайлНаДиске.ПолучитьТолькоЧтение() Тогда
				ФайлНаДиске.УстановитьТолькоЧтение(Ложь);
			КонецЕсли;

		КонецЕсли;

		// Остались случаи когда:
		// - пользователь ответил Да или ДаДляВсех в текущем диалоге
		// - способ перезаписи уже пришел со значением ДаДляВсех
		Если ТипЗнч(Хранилище) <> Тип("ДвоичныеДанные") Тогда
			ДвоичныеДанные = Хранилище.Получить();
		Иначе
			ДвоичныеДанные = Хранилище;
		КонецЕсли; 
		ДвоичныеДанные.Записать(ИмяФайла);
		ФайлНаДиске.УстановитьТолькоЧтение(ТолькоЧтение);

	Исключение

		Предупреждение(ОписаниеОшибки());
		Возврат Ложь;

	КонецПопытки;

	Возврат Истина;

КонецФункции // СохранитьФайлНаДиске()

// Проверяет возможность измененния расширения в имени файла. Выдает запрос пользователю
// на смену расширения.
//
// Параметры
//  ТекущееРасширение – Строка, содержащая текущее расширение файла, до изменения.
//  НовоеРасширение – Строка, содержащая новое расширение файла, после изменения.
//
// Возвращаемое значение:
//   Булево – Истина, если пользователь запретил изменение расширения, Ложь, если разрешил.
//
Функция НельзяИзменятьРасширение(ТекущееРасширение, НовоеРасширение) Экспорт

	Если Не ПустаяСтрока(ТекущееРасширение) И Не НовоеРасширение = ТекущееРасширение Тогда

		Ответ = Вопрос(НСтр("ru='Вы действительно хотите измерить расширение';uk='Ви дійсно хочете виміряти розширення'"), РежимДиалогаВопрос.ДаНет);

		Если Ответ = КодВозвратаДиалога.Да Тогда

			Возврат Ложь;

		Иначе

			Возврат Истина;

		КонецЕсли;

	Иначе

		Возврат Ложь;

	КонецЕсли;

КонецФункции // НельзяИзменятьРасширение()

// Создает и устанавливает реквизиты диалога выбора фала.
//
// Параметры
//  МножественныйВыбор – Булево, признак множественного выбора.
//  НачальныйКаталог – Строка, содержащая начальный каталог выбора файла.
//
// Возвращаемое значение:
//   ДиалогВыбораФайлов – созданный диалог.
//
Функция ПолучитьДиалогВыбораФайлов(МножественныйВыбор, НачальныйКаталог = "") Экспорт

	Диалог = Новый ДиалогВыбораФайла(РежимДиалогаВыбораФайла.Открытие);
	Диалог.Каталог = НачальныйКаталог;
	Диалог.Заголовок = НСтр("ru='Выберите файл...';uk='Виберіть файл...'");
	Диалог.Фильтр = ПолучитьФильтрФайлов();
	Диалог.ПредварительныйПросмотр = Истина;
	Диалог.ПроверятьСуществованиеФайла = Истина;
	Диалог.МножественныйВыбор = МножественныйВыбор;

	Возврат Диалог;

КонецФункции // ПолучитьДиалогВыбораФайлов()

// Выбор файлов пользователем на диске и добавление их объекту.
//
// Параметры
//  ОбъектФайла  - Ссылка на объект данных, для которого прикрепляются файлы.
//  ВидДанных    - ПеречислениеСсылка.ВидыДополнительнойИнформацииОбъектов содержащая вид
//                 дополнительной информации объекта.
//
Процедура ДобавитьФайлы(ОбъектФайла, ВидДанных, ИмяСправочника = "ХранилищеДополнительнойИнформации") Экспорт

	Если Не ОбъектФайла = Неопределено И ОбъектФайла.Пустая() Тогда
		Предупреждение(НСтр("ru='Необходимо записать объект, которому принадлежит файл.';uk=""Необхідно записати об'єкт, якому належить файл."""));
		Возврат;
	КонецЕсли;

	Диалог = ПолучитьДиалогВыбораФайлов(Истина);

	Если Не Диалог.Выбрать() Тогда
		Возврат;
	КонецЕсли;

	Для каждого ПолученноеИмяФайла Из Диалог.ВыбранныеФайлы Цикл

		ПолученныйФайл = Новый Файл(ПолученноеИмяФайла);
		Состояние(НСтр("ru='Добавляется файл: ';uk='Додається файл: '") + ПолученныйФайл.Имя);

		НачатьТранзакцию();
		
		Отказ = Ложь;
		
		НовыйФайл = Справочники[ИмяСправочника].СоздатьЭлемент();
		НовыйФайл.Объект = ОбъектФайла;
		НовыйФайл.ИмяФайла = ПолученныйФайл.Имя;
		Если ИмяСправочника = "ХранилищеДополнительнойИнформации" Тогда
			НовыйФайл.ВидДанных = ВидДанных;
		КонецЕсли; 

		Попытка
			НовыйФайл.Хранилище = Новый ХранилищеЗначения(Новый ДвоичныеДанные(ПолученныйФайл.ПолноеИмя), Новый СжатиеДанных());
			НовыйФайл.Записать();
		Исключение
			Предупреждение(НСтр("ru='Файл: ';uk='Файл: '") + ПолученныйФайл.ПолноеИмя + Символы.ПС + ОписаниеОшибки() + Символы.ПС + НСтр("ru='Файл не добавлен.';uk='Файл не доданий.'"));
			Отказ = Истина;
		КонецПопытки;
		
		Если Отказ Тогда
			ОтменитьТранзакцию();
		Иначе
			ЗафиксироватьТранзакцию();
		КонецЕсли; 

	КонецЦикла;

КонецПроцедуры // ДобавитьФайлы()

// Сохранение на диск отмеченных файлов объекта.
//
// Параметры
//  ОбъектФайла  - Ссылка на объект данных, для которого прикрепляются файлы.
//  ВыделенныеСтроки - ВыделенныеСтроки табличного поля со справочником дополнительной
//                 информации.
//
Процедура СохранитьФайлы(ОбъектФайла, ВыделенныеСтроки, ИмяКаталога = Неопределено, ИмяСправочника = "ХранилищеДополнительнойИнформации") Экспорт

	Если ВыделенныеСтроки.Количество() = 0 Тогда
		Возврат;
	КонецЕсли;

	ФормаСохраненияФайлов = Справочники[ИмяСправочника].ПолучитьФорму("ФормаСохраненияФайлов");
	ФормаСохраненияФайлов.ИмяКаталога    = ИмяКаталога;
	ФормаСохраненияФайлов.ТолькоЧтение   = Ложь;

	Если ИмяКаталога = Неопределено Тогда
		ИмяКаталога = ПолучитьИмяКаталога();
		ФормаСохраненияФайлов.ОткрытьКаталог = Истина;
	Иначе
		ФормаСохраненияФайлов.ОткрытьКаталог = Ложь;
	КонецЕсли; 

	СтруктураПараметров = ФормаСохраненияФайлов.ОткрытьМодально();
	
	Если СтруктураПараметров = Неопределено Тогда
		Возврат;
	КонецЕсли;

	Если Не ПроверитьСуществованиеКаталога(СтруктураПараметров.ИмяКаталога) Тогда
		Возврат;
	КонецЕсли;

	СпособПерезаписи = "";

	Для каждого СсылкаФайл из ВыделенныеСтроки Цикл

		Состояние(НСтр("ru='Сохраняется файл: ';uk='Зберігається файл: '") + СсылкаФайл.ИмяФайла);

		ИмяФайла = ПолучитьИмяФайла(СтруктураПараметров.ИмяКаталога, СсылкаФайл.ИмяФайла);
		СохранитьФайлНаДиске(СсылкаФайл.Хранилище, ИмяФайла, СтруктураПараметров.ТолькоЧтение, СпособПерезаписи);

		Если СпособПерезаписи = Неопределено Тогда
			Прервать;
		КонецЕсли; 

	КонецЦикла;

	Если СтруктураПараметров.ОткрытьКаталог Тогда
		ЗапуститьПриложение(СтруктураПараметров.ИмяКаталога);
	КонецЕсли;

КонецПроцедуры // СохранитьФайлы()

// Сохранение на диск отмеченных файлов объекта и их открытие.
//
// Параметры
//  ОбъектФайла  - Ссылка на объект данных, для которого прикрепляются файлы.
//  ВыделенныеСтроки - ВыделенныеСтроки табличного поля со справочником дополнительной
//                 информации.
//
Процедура ОткрытьФайлы(ОбъектФайла, ВыделенныеСтроки = Неопределено, ВопросОПерезаписи = Истина) Экспорт

	Если ВыделенныеСтроки = Неопределено Тогда
		
		Если УправлениеЭлектроннойПочтой.ОткрытьФайлMSG(ОбъектФайла,глЗначениеПеременной("глТекущийПользователь")) Тогда
			Возврат;
		КонецЕсли; 
		
		ИмяКаталога = ПолучитьИмяКаталога();
		ТолькоЧтение = Ложь;

		СпособПерезаписи = "";

		Состояние(НСтр("ru='Сохраняется файл: ';uk='Зберігається файл: '") + ОбъектФайла.ИмяФайла);

		ИмяФайла = ПолучитьИмяФайла(ИмяКаталога, ОбъектФайла.ИмяФайла);
		СохранитьФайлНаДиске(ОбъектФайла.Хранилище, ИмяФайла, Ложь, СпособПерезаписи, ВопросОПерезаписи);

		Если СпособПерезаписи = Неопределено Тогда
			Возврат;
		КонецЕсли;

		ОткрытьФайлДополнительнойИнформации(ИмяКаталога, ОбъектФайла.ИмяФайла);
		
	Иначе
		
		Если ВыделенныеСтроки.Количество() = 0 Тогда
			Возврат;
		КонецЕсли;

		ИмяКаталога = ПолучитьИмяКаталога();
		ТолькоЧтение = Ложь;

		СпособПерезаписи = "";

		Для каждого СсылкаФайл из ВыделенныеСтроки Цикл

			Если УправлениеЭлектроннойПочтой.ОткрытьФайлMSG(СсылкаФайл, глЗначениеПеременной("глТекущийПользователь")) Тогда
				Возврат;
			КонецЕсли; 
			
			Состояние(НСтр("ru='Сохраняется файл: ';uk='Зберігається файл: '") + СсылкаФайл.ИмяФайла);

			ИмяФайла = ПолучитьИмяФайла(ИмяКаталога, СсылкаФайл.ИмяФайла);
			СохранитьФайлНаДиске(?(ТипЗнч(СсылкаФайл) = Тип("СтрокаТаблицыЗначений"), СсылкаФайл.Данные, СсылкаФайл.Хранилище), ИмяФайла, Ложь, СпособПерезаписи, ВопросОПерезаписи);

			Если СпособПерезаписи = Неопределено Тогда
				Прервать;
			КонецЕсли;

			ОткрытьФайлДополнительнойИнформации(ИмяКаталога, СсылкаФайл.ИмяФайла);

		КонецЦикла;
		
	КонецЕсли; 
	
КонецПроцедуры // ОткрытьФайлы()

// Получает картинку файла из библиотеки картинок в зависимости от расширения файла.
//
// Параметры
//  РасширениеФайла – Строка, содержащая расширение файла.
//
// Возвращаемое значение:
//   Картинка.
//
Функция ПолучитьПиктограммуФайла(РасширениеФайла) Экспорт

	РасширениеФайла = Врег(РасширениеФайла);

	Если Найти(",1CD,CF,CFU,DT,", "," + РасширениеФайла + ",") > 0 Тогда
		Возврат БиблиотекаКартинок.ПиктограммаФайла_1С;
	ИначеЕсли "MXL" = РасширениеФайла Тогда
		Возврат БиблиотекаКартинок.ПиктограммаФайла_MXL;
	ИначеЕсли "TXT" = РасширениеФайла Тогда
		Возврат БиблиотекаКартинок.ПиктограммаФайла_TXT;
	ИначеЕсли "EPF" = РасширениеФайла Тогда
		Возврат БиблиотекаКартинок.ПиктограммаФайла_EPF;
	ИначеЕсли Найти(",BMP,DIB,RLE,JPG,JPEG,TIF,GIF,PNG,ICO,WMF,EMF,", "," + РасширениеФайла + ",") > 0 Тогда
		Возврат БиблиотекаКартинок.ПиктограммаФайла_BMP;
	ИначеЕсли Найти(",HTM,HTML,MHT,", "," + РасширениеФайла + ",") > 0 Тогда
		Возврат БиблиотекаКартинок.ПиктограммаФайла_HTML;
	ИначеЕсли Найти(",DOC,DOCX,RTF,", "," + РасширениеФайла + ",") > 0 Тогда  
		Возврат БиблиотекаКартинок.ПиктограммаФайла_Word;
	ИначеЕсли ("XLS" = РасширениеФайла) ИЛИ ("XLSX" = РасширениеФайла) Тогда  
		Возврат БиблиотекаКартинок.ПиктограммаФайла_Excel;
	ИначеЕсли ("PPT" = РасширениеФайла) ИЛИ ("PPTX" = РасширениеФайла) Тогда
		Возврат БиблиотекаКартинок.ПиктограммаФайла_PowerPoint;
	ИначеЕсли "VSD" = РасширениеФайла Тогда
		Возврат БиблиотекаКартинок.ПиктограммаФайла_VSD;
	ИначеЕсли "MPP" = РасширениеФайла Тогда
		Возврат БиблиотекаКартинок.ПиктограммаФайла_MPP;
	ИначеЕсли "MDB" = РасширениеФайла Тогда
		Возврат БиблиотекаКартинок.ПиктограммаФайла_MDB;
	ИначеЕсли "XML" = РасширениеФайла Тогда
		Возврат БиблиотекаКартинок.ПиктограммаФайла_XML;
	ИначеЕсли "MSG" = РасширениеФайла Тогда
		Возврат БиблиотекаКартинок.ПиктограммаФайла_MSG;
	ИначеЕсли Найти(",RAR,ZIP,ARJ,CAB,", "," + РасширениеФайла + ",") > 0 Тогда
		Возврат БиблиотекаКартинок.ПиктограммаФайла_WinRar;
	ИначеЕсли Найти(",EXE,COM,", "," + РасширениеФайла + ",") > 0 Тогда
		Возврат БиблиотекаКартинок.ПиктограммаФайла_EXE;
	ИначеЕсли "BAT" = РасширениеФайла Тогда
		Возврат БиблиотекаКартинок.ПиктограммаФайла_BAT;
	Иначе
		Возврат БиблиотекаКартинок.ПиктограммаФайла_НеОпределен;
	КонецЕсли;

КонецФункции // ПолучитьПиктограммуФайла()

// Изменяет картинку у кнопки открытия формы списка файлов и изображений.
//
// Параметры
//  ОбъектФайла  - Ссылка на объект данных, для которого прикрепляются файлы.
//  КнопкаОткрытияФайлов - Кнопка тулбара, по нажатию которой открывается
//  форма списка файлов и изображений.
//
Процедура ПолучитьКартинкуКнопкиОткрытияФайлов(ОбъектФайла, СписокКнопокОткрытияФайлов) Экспорт

	КартинкаКнопки = ?(ЕстьДополнительнаяИнформация(ОбъектФайла), БиблиотекаКартинок.ТолькоСкрепка, БиблиотекаКартинок.НевидимаяСкрепка);
	Для каждого КнопкаОткрытияФайлов Из СписокКнопокОткрытияФайлов Цикл
		КнопкаОткрытияФайлов.Значение.Отображение = ОтображениеКнопкиКоманднойПанели.НадписьКартинка;
		КнопкаОткрытияФайлов.Значение.Картинка    = КартинкаКнопки;
	КонецЦикла; 

КонецПроцедуры // ПолучитьКартинкуКнопкиОткрытияФайлов()

// Процедура открывает форму файлов и изображений по объекту отбора
//
Процедура ОткрытьФормуСпискаФайловИИзображений(СтруктураДляСпискаИзображений, СтруктураДляСпискаДополнительныхФайлов, ОбязательныеОтборы, ФормаВладелец, ИмяСправочника = "ХранилищеДополнительнойИнформации") Экспорт

	ФормаФайлов = Справочники[ИмяСправочника].ПолучитьФорму("ФормаСпискаФайловИИзображений", ФормаВладелец);
	
	// Изображения
	Если СтруктураДляСпискаИзображений.Свойство("ОтборОбъектИспользование") Тогда
		ФормаФайлов.Изображения.Отбор.Объект.Использование = СтруктураДляСпискаИзображений.ОтборОбъектИспользование;
		ФормаФайлов.Изображения.Отбор.Объект.Значение      = СтруктураДляСпискаИзображений.ОтборОбъектЗначение;
	КонецЕсли;
	Если СтруктураДляСпискаИзображений.Свойство("ДоступностьОтбораОбъекта") Тогда
		ФормаФайлов.ЭлементыФормы.Изображения.НастройкаОтбора.Объект.Доступность = СтруктураДляСпискаИзображений.ДоступностьОтбораОбъекта;
	КонецЕсли; 
	Если СтруктураДляСпискаИзображений.Свойство("ВидимостьКолонкиОбъекта") Тогда
		ФормаФайлов.ЭлементыФормы.Изображения.Колонки.Объект.Видимость = СтруктураДляСпискаИзображений.ВидимостьКолонкиОбъекта;
	КонецЕсли; 

	// Дополнительные файлы
	Если СтруктураДляСпискаДополнительныхФайлов.Свойство("ОтборОбъектИспользование") Тогда
		ФормаФайлов.ДополнительныеФайлы.Отбор.Объект.Использование = СтруктураДляСпискаДополнительныхФайлов.ОтборОбъектИспользование;
		ФормаФайлов.ДополнительныеФайлы.Отбор.Объект.Значение      = СтруктураДляСпискаДополнительныхФайлов.ОтборОбъектЗначение;
	КонецЕсли;
	Если СтруктураДляСпискаДополнительныхФайлов.Свойство("ДоступностьОтбораОбъекта") Тогда
		ФормаФайлов.ЭлементыФормы.ДополнительныеФайлы.НастройкаОтбора.Объект.Доступность = СтруктураДляСпискаДополнительныхФайлов.ДоступностьОтбораОбъекта;
	КонецЕсли; 
	Если СтруктураДляСпискаДополнительныхФайлов.Свойство("ВидимостьКолонкиОбъекта") Тогда
		ФормаФайлов.ЭлементыФормы.ДополнительныеФайлы.Колонки.Объект.Видимость = СтруктураДляСпискаДополнительныхФайлов.ВидимостьКолонкиОбъекта;
	КонецЕсли; 
	
	ФормаФайлов.ОбязательныеОтборы = ОбязательныеОтборы;
	
	Если СтруктураДляСпискаИзображений.Свойство("ОтборОбъектИспользование") И СтруктураДляСпискаИзображений.Свойство("ОтборОбъектИспользование") Тогда
		Если СтруктураДляСпискаИзображений.ОтборОбъектЗначение = СтруктураДляСпискаДополнительныхФайлов.ОтборОбъектЗначение Тогда
			ФормаФайлов.Заголовок = НСтр("ru='Хранилище дополнительной информации (';uk='Сховище додаткової інформації ('") + СокрЛП(Строка(СтруктураДляСпискаИзображений.ОтборОбъектЗначение)) + ")";
		КонецЕсли;
	КонецЕсли; 
	
	ФормаФайлов.Открыть();

КонецПроцедуры

// Открывает форму основного изображения объекта
//
// Параметры
//  ФормаВладелец – Форма – определяет форму владельца открываемой формы
//  ОсновноеИзображение – СправочникСсылка.ХранилищеДополнительнойИнформации – содержит 
//                 ссылку на основное изображение объеата
//
Процедура ОткрытьФормуИзображения(ФормаВладелец, ОсновноеИзображение, ОбъектВладелец) Экспорт

	Если ОсновноеИзображение = Неопределено ИЛИ ОсновноеИзображение.Пустая() Тогда
			
		ДиалогОткрытияФайла = Новый ДиалогВыбораФайла(РежимДиалогаВыбораФайла.Открытие);
		ДиалогОткрытияФайла.Заголовок = НСтр("ru='Выберите файл с изображением';uk='Виберіть файл із зображенням'");
		ДиалогОткрытияФайла.ПолноеИмяФайла = "";
		ДиалогОткрытияФайла.ПредварительныйПросмотр = Истина;
		ДиалогОткрытияФайла.Фильтр = ПолучитьФильтрИзображений();

		Если ДиалогОткрытияФайла.Выбрать() Тогда
			ВыбранноеИзображение = Новый Картинка(ДиалогОткрытияФайла.ПолноеИмяФайла, Ложь);
		Иначе
			Возврат;
		КонецЕсли;
		
		НовыйОбъект = Справочники.ХранилищеДополнительнойИнформации.СоздатьЭлемент();
		НовыйОбъект.ВидДанных = Перечисления.ВидыДополнительнойИнформацииОбъектов.Изображение;
		НовыйОбъект.Хранилище = Новый ХранилищеЗначения(ВыбранноеИзображение, Новый СжатиеДанных);
		НовыйОбъект.Объект = ОбъектВладелец;
		
		ФормаИзображения = НовыйОбъект.ПолучитьФорму("ФормаИзображения");
		
	Иначе
		
		ФормаИзображения = ОсновноеИзображение.ПолучитьФорму("ФормаИзображения");
		
	КонецЕсли;
	
	ФормаИзображения.ВладелецФормы = ФормаВладелец;
	ФормаИзображения.РежимВыбора = Истина;
	ФормаИзображения.ЗакрыватьПриВыборе = Ложь;
	ФормаИзображения.Открыть();
	
КонецПроцедуры // ОткрытьФормуИзображения()

#КонецЕсли



