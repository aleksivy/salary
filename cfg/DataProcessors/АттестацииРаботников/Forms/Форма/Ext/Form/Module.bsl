////////////////////////////////////////////////////////////////////////////////
// ПЕРЕМЕННЫЕ МОДУЛЯ

// Диалог настройки периода
Перем мНастройкаПериода;

///////////////////////////////////////////////////////////////////////////////
// ОБРАБОТКА СОБЫТИЙ ФОРМЫ

// Обработчик события "При открытии" основной Формы. 
// Создает таблицу работников
// 
//
Процедура ПриОткрытии()
	
	// Установить настройку периода по умолчанию 
	мНастройкаПериода.ВариантНастройки = ВариантНастройкиПериода.Период; 
	
	НачПериода = НачалоГода(ТекущаяДата());
	КонПериода = КонецГода(ТекущаяДата());
	
	Аттестации.Порядок[0].Направление = НаправлениеСортировки.Убыв;
	
КонецПроцедуры // ПриОткрытии()

// Процедура - обработчик события "ОбработкаВыбора" формы.
//
Процедура ОбработкаВыбора(ЗначениеВыбора, Источник)
	
	Если ТипЗнч(ЗначениеВыбора) = Тип("Структура") Тогда
		Команда = "";
		Если ЗначениеВыбора.Свойство("Команда",Команда) и Команда = "ЗаполнитьСписокРаботников" Тогда
			Работники.Загрузить(ЗначениеВыбора.Данные.Выгрузить())
		КонецЕсли;
	КонецЕсли;

КонецПроцедуры // ОбработкаВыбора()

///////////////////////////////////////////////////////////////////////////////
// ОБРАБОТКА СОБЫТИЙ ЭЛЕМЕНТОВ ФОРМЫ

// Закладка "Работник"

// Обработчик события "ПриАктивизацииСтроки" интерфейсного объекта "Работники".
// Присваивает текущие значения реквизитам обработки.
// Вызывает процедуру ПостроитьСправку().
//
Процедура РаботникиПриАктивизацииСтроки(Элемент)
	
	ПодключитьОбработчикОжидания("ОбработчикОжиданияРаботникиПриАктивизацииСтроки", 0.1, Истина);	 	
	
КонецПроцедуры // РаботникиПриАктивизацииСтроки()

// Процедура - обрабочик ожидания для события ПриАктивизацииСтроки
// табличного поля Работники
//
Процедура ОбработчикОжиданияРаботникиПриАктивизацииСтроки()
	
	ПостроитьСправку(ЭлементыФормы.ПолеСправки, ЭлементыФормы.Работники.ТекущиеДанные);
	
КонецПроцедуры // ОбработчикОжиданияРаботникиПриАктивизацииСтроки

 // Обработчик события "Выбор" интерфейсного объекта "Работники".
//
//
Процедура РаботникиВыбор(Элемент, ВыбраннаяСтрока, Колонка, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	ТекущиеДанные = Элемент.ТекущиеДанные;
	
	Если ТекущиеДанные = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	ТекущиеДанные.Сотрудник.ПолучитьФорму().Открыть();
	
КонецПроцедуры  // РаботникиВыбор()

// Закладка "Анализ оценок"

// Обработчик события "ПриИзменении" интерфейсного объекта "Компетенция".
// Вызывает процедуру СформироватьДиаграмму().
//
Процедура КомпетенцияПриИзменении(Элемент)
	
	СформироватьДиаграмму(ЭлементыФормы.Диаграмма, Компетенция, НачПериода, КонПериода, Должность);

КонецПроцедуры // КомпетенцияПриИзменении()

// Обработчик события "ПриИзменении" интерфейсного объекта "Должность".
// Вызывает процедуру СформироватьДиаграмму().
//
Процедура ДолжностьПриИзменении(Элемент)
		
	СформироватьДиаграмму(ЭлементыФормы.Диаграмма, Компетенция, НачПериода, КонПериода, Должность);
	
КонецПроцедуры // ДолжностьПриИзменении()

////////////////////////////////////////////////////////////////////////////////
// ПРОЦЕДУРЫ - ДЕЙСТВИЯ КОМАНДНЫХ ПАНЕЛЕЙ ФОРМЫ

// закладка "Работники"

// Обработчик события "Действие" элемента панели "ОткрытьФизЛицо" командной панели 
// "КоманднаяПанельРаботников". 
// Открывает форму элемента справочника ФизЛиц. 
//
Процедура КоманднаяПанельРаботникиОткрытьФизЛицо(Кнопка)
	
	ДанныеСтроки = ЭлементыФормы.Работники.ТекущиеДанные;
	
	Если ДанныеСтроки = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	ДанныеСтроки.Сотрудник.ПолучитьФорму().Открыть();
	
КонецПроцедуры // КоманднаяПанельРаботниковОткрытьФизЛицо()

// Обработчик события "Действие" элемента панели "НазначитьАттестацию" командной 
// панели "КоманднаяПанельРаботников". 
// Вызывает процедуру создания документа "Аттестация работника". 
//
Процедура КоманднаяПанельРаботникиНазначитьАттестацию(Кнопка)
	
	ТекущиеДанные = ЭлементыФормы.Работники.ТекущиеДанные;
	
	Если ТекущиеДанные = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	// Создание документа "Аттестация работника"
	Форма = Документы.АттестацияРаботника.ПолучитьФормуНовогоДокумента();
	Форма.Сотрудник	= ТекущиеДанные.Сотрудник;
	Форма.Открыть();
	
КонецПроцедуры // КоманднаяПанельРаботниковНазначитьАттестацию()

Процедура КоманднаяПанельРаботникиЗаполнить(Кнопка)
	
	Если Работники.Количество() > 0 Тогда
		ТекстВопроса = НСтр("ru='Перед заполнением табличная часть будет очищена. Заполнить?';uk='Перед заповненням таблична частина буде очищена. Заповнити?'");
		Ответ = Вопрос(ТекстВопроса, РежимДиалогаВопрос.ДаНет, , КодВозвратаДиалога.Да,);
		
		Если Ответ <> КодВозвратаДиалога.Да Тогда
			Возврат;
		КонецЕсли; 
		Работники.Очистить();
	КонецЕсли;
		
	ПроцедурыУправленияПерсоналом.ОткрытьФормуОтбораСпискаРаботников(ЭтаФорма, ОбщегоНазначения.ПолучитьРабочуюДату(), "Работники", , )
	
КонецПроцедуры // КоманднаяПанельРаботникиЗаполнить()

// Закладка "Анализ оценок"

// Процедура выбора периода регистрации оценок
//
Процедура ВыбПериодНажатие(Элемент)
	
	мНастройкаПериода.УстановитьПериод(НачПериода, ?(КонПериода='0001-01-01', КонПериода, КонецДня(КонПериода)));
	
	Если мНастройкаПериода.Редактировать() Тогда
		НачПериода = мНастройкаПериода.ПолучитьДатуНачала();
		КонПериода = мНастройкаПериода.ПолучитьДатуОкончания();
	КонецЕсли;
	
КонецПроцедуры // ВыбПериодНажатие()

Процедура КоманднаяПанельАнализОценокСформировать(Кнопка)
	
	СформироватьДиаграмму(ЭлементыФормы.Диаграмма, Компетенция, НачПериода, КонПериода, Должность);
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// ОПЕРАТОРЫ ОСНОВНОЙ ПРОГРАММЫ

мНастройкаПериода = Новый НастройкаПериода;
