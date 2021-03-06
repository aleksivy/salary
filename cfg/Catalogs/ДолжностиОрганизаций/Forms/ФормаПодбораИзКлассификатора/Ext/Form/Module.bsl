////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ

// Обработчик события ПриОткрытии формы.
//
Процедура ПриОткрытии()

	Макет = Справочники.ДолжностиОрганизаций.ПолучитьМакет("КлассификаторПрофессийИДолжностей");

	Макет.Параметры.Расшифровка = Истина; // чтобы работала расшифровка

	ТабличныйДокумент = ЭлементыФормы.ПолеТабличногоДокумента;
	
	ТабличныйДокумент.Очистить();
	ТабличныйДокумент.Вывести(Макет);

	ТабличныйДокумент.ФиксацияСверху      = 3;

	ТабличныйДокумент.ОтображатьЗаголовки = Ложь;
	ТабличныйДокумент.ОтображатьСетку     = Ложь;
	ТабличныйДокумент.ТолькоПросмотр      = Истина;

КонецПроцедуры

// Обработчик события ОбработкаРасшифровки элемента ПолеТабличногоДокумента.
//
Процедура ПолеТабличногоДокументаОбработкаРасшифровки(Элемент, Расшифровка, СтандартнаяОбработка)

	СтандартнаяОбработка = Ложь;

	// Получение значений полей выбранной строки.
	ТабличныйДокумент = ЭлементыФормы.ПолеТабличногоДокумента;
	ТекущаяОбласть    = ТабличныйДокумент.ТекущаяОбласть;

	ОбластьКод          = ТабличныйДокумент.Области.Код;
	ОбластьКодЗКППТР    = ТабличныйДокумент.Области.КодЗКППТР;
	ОбластьНаименование = ТабличныйДокумент.Области.Наименование;
	
	Если ТекущаяОбласть.Низ = ТекущаяОбласть.Верх Тогда

		
		Код          = СокрЛП(ТабличныйДокумент.Область(ТекущаяОбласть.Верх, ОбластьКод.         Лево, ТекущаяОбласть.Низ, ОбластьКод.         Право).Текст);
		КодЗКППТР    = СокрЛП(ТабличныйДокумент.Область(ТекущаяОбласть.Верх, ОбластьКодЗКППТР.         Лево, ТекущаяОбласть.Низ, ОбластьКодЗКППТР.Право).Текст);
		Наименование = СокрЛП(ТабличныйДокумент.Область(ТекущаяОбласть.Верх, ОбластьНаименование.Лево, ТекущаяОбласть.Низ, ОбластьНаименование.Право).Текст);
		// Проверка наличия выбранного элемента.
		Ссылка = Справочники.ДолжностиОрганизаций.НайтиПоНаименованию(Наименование);
		
		Если НЕ Ссылка.Пустая() Тогда
			
			Вопрос = НСтр("ru='В справочнике ""Классификатор профессий и должностей"" уже существует элемент с наименованием ""';uk='У довіднику ""Класифікатор професій і посад"" вже існує елемент з найменуванням ""'") + Наименование + НСтр("ru='""! Открыть существующий?';uk='""! Відкрити існуючий?'");
			Ответ  = Вопрос(Вопрос, РежимДиалогаВопрос.ДаНетОтмена, , КодВозвратаДиалога.Отмена, );
			
			Если      Ответ = КодВозвратаДиалога.Да Тогда
				
				Ссылка.ПолучитьФорму( , ВладелецФормы, ).Открыть();
				Возврат;

			ИначеЕсли Ответ = КодВозвратаДиалога.Отмена Тогда
				Возврат;
			КонецЕсли;
			
		КонецЕсли;

		// Создание нового элемента справочника.

		ФормаНовогоЭлемента = Справочники.ДолжностиОрганизаций.ПолучитьФормуНовогоЭлемента(, ВладелецФормы, );
		ФормаНовогоЭлемента.КодКП = Код;

		ФормаНовогоЭлемента.Наименование = Наименование;
		ФормаНовогоЭлемента.КодЗКППТР = КодЗКППТР;
		ФормаНовогоЭлемента.НаименованиеПоКП = Наименование;
		
		ФормаНовогоЭлемента.УстановитьКатегорию();
		ФормаНовогоЭлемента.Открыть();
		
		
	Иначе
		
		Форма = ПолучитьОбщуюФорму("ФормаПодбораИзКлассификатора", ЭтаФорма);
		Если Форма.Открыта() Тогда
			Форма.СписокВыбора.Очистить();
		Иначе			
			СтруктураКолонок = Новый Структура();
			СтруктураКолонок.Вставить("Код", Новый Структура("Заголовок, Ширина", "Код", 5));
			СтруктураКолонок.Вставить("Наименование", Новый Структура("Заголовок, Ширина", "Наименование"));
			СтруктураКолонок.Вставить("Видимость", Новый Структура("Заголовок, Ширина", ""));	
			Форма.ТипСправочника = "ДолжностиОрганизаций";
			Форма.НастроитьФорму(СтруктураКолонок);
		КонецЕсли;	
		
		СписокВыбора =  Форма.СписокВыбора;		
		
		Для ТекущаяСтрока = ТекущаяОбласть.Верх по ТекущаяОбласть.Низ Цикл
			
			КодЧисловой         = СокрЛП(ТабличныйДокумент.Область(ТекущаяСтрока, ОбластьКод.         Лево, ТекущаяСтрока, ОбластьКод.         Право).Текст);
			НаименованиеПолное  = СокрЛП(ТабличныйДокумент.Область(ТекущаяСтрока, ОбластьНаименование.Лево, ТекущаяСтрока, ОбластьНаименование.Право).Текст);				
			
			ЭтоЧисло = Истина;
			Попытка
				КодКакЧисло = Число(КодЧисловой);
			Исключение
				ЭтоЧисло = Ложь;
			КонецПопытки;
			
			ЕСли ЭтоЧисло Тогда
				СтрокаПодбора = СписокВыбора.Добавить();
				СтрокаПодбора.Код = КодЧисловой;				
				СтрокаПодбора.Наименование = СтрПолучитьСтроку(НаименованиеПолное, 1);
				
				СтрокаПодбора.Видимость = Справочники.ДолжностиОрганизаций.НайтиПоКоду(КодЧисловой).Пустая();
				СтрокаПодбора.Переносить = СтрокаПодбора.Видимость;
			КонецЕсли;
			
		КонецЦикла;
		
		Форма.Открыть();


		
	КонецЕсли;
	

КонецПроцедуры
