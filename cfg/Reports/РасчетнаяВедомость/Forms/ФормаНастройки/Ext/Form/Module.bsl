﻿Перем НеИспользуемыйЦвет;

Процедура ИнициализироватьКомпоновщикНастроек()
	
	КомпоновщикНастроек = Новый КомпоновщикНастроекКомпоновкиДанных;
	КомпоновщикНастроек.Инициализировать(Новый ИсточникДоступныхНастроекКомпоновкиДанных(ОтчетОбъект.СхемаКомпоновкиДанных));
	
	Если ОтчетОбъект.КомпоновщикНастроек.Настройки.Структура.Количество() = 0 Тогда
		ОтчетОбъект.КомпоновщикНастроек.Настройки.Структура.Добавить(Тип("ГруппировкаКомпоновкиДанных"));
	КонецЕсли;
	
	// Настройки компоновщика отчета
	ЭлементОтчета = ОтчетОбъект.КомпоновщикНастроек.Настройки.Структура[0];
	ТипЭлементаОтчета = ТипЗнч(ЭлементОтчета);
	ПредставлениеЭлементаОтчета = ТиповыеОтчеты.ПолучитьПредставлениеПоЭлементуСтруктуры(ЭлементОтчета);
	
	Элемент = КомпоновщикНастроек.Настройки.Структура.Добавить(ТипЭлементаОтчета);
	
	ЭлементыФормы.НастройкиСкрытыеЭлемент.ТекущаяСтрока = Элемент;
	
	// Скопируем настройки в компоновщик из компоновщика отчета
	ТиповыеОтчеты.СкопироватьЭлементы(КомпоновщикНастроек.Настройки.Выбор,         ОтчетОбъект.КомпоновщикНастроек.Настройки.Выбор);
	ТиповыеОтчеты.СкопироватьЭлементы(КомпоновщикНастроек.Настройки.Отбор,         ОтчетОбъект.КомпоновщикНастроек.Настройки.Отбор);
	ТиповыеОтчеты.СкопироватьЭлементы(КомпоновщикНастроек.Настройки.Порядок,       ОтчетОбъект.КомпоновщикНастроек.Настройки.Порядок);
	ТиповыеОтчеты.СкопироватьЭлементы(КомпоновщикНастроек.Настройки.УсловноеОформление, ОтчетОбъект.КомпоновщикНастроек.Настройки.УсловноеОформление, Ложь);
	ТиповыеОтчеты.СкопироватьЭлементы(КомпоновщикНастроек.Настройки.ПользовательскиеПоля, ОтчетОбъект.КомпоновщикНастроек.Настройки.ПользовательскиеПоля);
	ТиповыеОтчеты.ЗаполнитьЭлементы(КомпоновщикНастроек.Настройки.ПараметрыДанных, ОтчетОбъект.КомпоновщикНастроек.Настройки.ПараметрыДанных);
	ТиповыеОтчеты.ЗаполнитьЭлементы(КомпоновщикНастроек.Настройки.ПараметрыВывода, ОтчетОбъект.КомпоновщикНастроек.Настройки.ПараметрыВывода);
	
	Если ТипЭлементаОтчета = Тип("ГруппировкаКомпоновкиДанных") Тогда
		
		ДобавитьПоляГруппировки(ЭлементОтчета, Элемент, "ПоляГруппировки", Истина);
	
	ИначеЕсли ТипЭлементаОтчета = Тип("ТаблицаКомпоновкиДанных") Тогда
		
		ДобавитьПоляГруппировки(ЭлементОтчета, Элемент, "Строки", Истина);
		ДобавитьПоляГруппировки(ЭлементОтчета, Элемент, "Колонки", Ложь);
				
	ИначеЕсли ТипЭлементаОтчета = Тип("ДиаграммаКомпоновкиДанных") Тогда
		
		ДобавитьПоляГруппировки(ЭлементОтчета, Элемент, "Серии", Истина);
		ДобавитьПоляГруппировки(ЭлементОтчета, Элемент, "Точки", Ложь);
		
	КонецЕсли;
	

КонецПроцедуры

Процедура ПередОткрытием(Отказ, СтандартнаяОбработка)
	
	ИнициализироватьКомпоновщикНастроек();
	ОбновитьЭлементыФормы();
	ОбновитьФормуПоКомпоновщику();
	ОбновитьКнопкиКонтекстногоМенюПоказатели(ЭлементыФормы.КоманднаяПанельСтраницаНеТаблицаПоказателиКонтекстноеМеню);
	ОтрицательноеКрасным = ОтчетОбъект.ОтрицательноеКрасным;
	
КонецПроцедуры

Процедура СохранитьИЗакрыть(Формировать = Ложь)
	
	Если ПредставлениеЭлементаОтчета = Перечисления.ПредставленияЭлементовОтчетов.Диаграмма Тогда
		КоличествоРесурсов = 0;
		Для Каждого Элемент Из ТиповыеОтчеты.ПолучитьВыбранныеПоля(КомпоновщикНастроек) Цикл
			Если Элемент.Использование Тогда
				КоличествоРесурсов = КоличествоРесурсов + 1;
			КонецЕсли;
		КонецЦикла;
		Если КоличествоРесурсов <> 1 Тогда
			Вопрос(НСтр("ru='В диаграмме должен присутствовать показатель и только один';uk='У діаграмі повинен бути присутнім показник і тільки один'"), РежимДиалогаВопрос.ОК);
			Возврат;
		КонецЕсли;
	КонецЕсли;
		
	ЗаполнитьКомпоновщикНастроекОтчета();
	ОтчетОбъект.ОтрицательноеКрасным = ОтрицательноеКрасным;
	//Если ТиповыеОтчеты.АналитическийОтчет() Тогда
	//	ОтчетОбъект.Расшифровки.Загрузить(Расшифровки);
	//	ОтчетОбъект.ЦветаДиаграммы = Новый ХранилищеЗначения(ЦветаДиаграммы);
	//	ОтчетОбъект.ОформлениеПоказателей = Новый ХранилищеЗначения(ОформлениеПоказателей);
	//КонецЕсли;
	
	Закрыть(Формировать);
	
КонецПроцедуры

Процедура ОбновитьЭлементыФормы()

	Заголовок = "Настройки отчета """ + ВладелецФормы.Заголовок + """";
	
	ЭлементыФормы.РамкаГруппыПоказателиСтраницаНеТаблица.Заголовок = НСтр("ru='Дополнительные поля';uk='Додаткові поля'");
	
	ЭлементыФормы.НастройкиСкрытыеГруппировкиСтрок.ПодробнаяНастройка   = Истина;
	ЭлементыФормы.НастройкиСкрытыеГруппировкиКолонок.ПодробнаяНастройка = Истина;
	ЭлементыФормы.НастройкиСкрытыеЭлемент.ПодробнаяНастройка            = Истина;
	
	Для каждого ЭлементФормы Из ЭлементыФормы Цикл
		Если Найти(ЭлементФормы.Имя, "НастройкиПользователя") > 0 Тогда
			ЭлементФормы.Видимость = Ложь;
		КонецЕсли;
	КонецЦикла;
	
	ЭлементыФормы.РамкаГруппыГруппировкиСтрокСтраницаНеТаблица.Заголовок       = "Строки";
	ЭлементыФормы.ПанельСтруктураОтчета.ТекущаяСтраница = ЭлементыФормы.ПанельСтруктураОтчета.Страницы.СтраницаНеТаблица;
	ЭлементыФормы.ПанельОтборСортировка.ТекущаяСтраница = ЭлементыФормы.ПанельОтборСортировка.Страницы.СтраницаБезПараметров;
	ЭлементыФормы.ПанельНастройки.Страницы.ОтборИСортировка.Заголовок = НСтр("ru='Отбор и упорядочивание';uk='Відбір і упорядкування'");
	
	Картинка = ТиповыеОтчеты.ПолучитьКартинкуПредставленияЭлементаОтчета(ПредставлениеЭлементаОтчета);
	Если Картинка <> Неопределено Тогда
		КартинкаЗаголовка = Картинка;
	КонецЕсли;
	ЭлементыФормы.ПанельОформление.ТекущаяСтраница = ЭлементыФормы.ПанельОформление.Страницы.Оформление;
	
	УстановитТекущуюСтраницуПанелиПереноса();
	ОбновитьКонтекстноеМенюДоступныхПолей();
	
КонецПроцедуры


Процедура ОбновитьФормуПоКомпоновщику()
	
	ЗначениеПараметра = ОтчетОбъект.КомпоновщикНастроек.Настройки.ПараметрыВывода.НайтиЗначениеПараметра(Новый ПараметрКомпоновкиДанных("TitleOutput"));
	Если ЗначениеПараметра.Значение = ТипВыводаТекстаКомпоновкиДанных.Выводить Тогда
		ЭлементыФормы.ФлажокОтображатьЗаголовок.Значение = Истина;
	Иначе
		ЭлементыФормы.ФлажокОтображатьЗаголовок.Значение = Ложь;
	КонецЕсли;
	
	ЗначениеПараметра = ОтчетОбъект.КомпоновщикНастроек.Настройки.ПараметрыВывода.НайтиЗначениеПараметра(Новый ПараметрКомпоновкиДанных("TitleOutput"));
	Если ЗначениеПараметра.Значение = ТипВыводаТекстаКомпоновкиДанных.Выводить Тогда
		ЭлементыФормы.ФлажокОтображатьЗаголовок.Значение = Истина;
	Иначе
		ЭлементыФормы.ФлажокОтображатьЗаголовок.Значение = Ложь;
	КонецЕсли;

	
	// Параметры периода
	ЗначениеПараметраНачалоПериода = КомпоновщикНастроек.Настройки.ПараметрыДанных.НайтиЗначениеПараметра(Новый ПараметрКомпоновкиДанных("НачалоПериода"));
	ЗначениеПараметраКонецПериода = КомпоновщикНастроек.Настройки.ПараметрыДанных.НайтиЗначениеПараметра(Новый ПараметрКомпоновкиДанных("КонецПериода"));
	ЗначениеПараметраПериод = КомпоновщикНастроек.Настройки.ПараметрыДанных.НайтиЗначениеПараметра(Новый ПараметрКомпоновкиДанных("Период"));
	
	Если ЗначениеПараметраНачалоПериода <> Неопределено 
	   И ЗначениеПараметраКонецПериода <> Неопределено Тогда
		НачалоПериода = ЗначениеПараметраНачалоПериода.Значение;
		КонецПериода = ЗначениеПараметраКонецПериода.Значение;
	КонецЕсли;

КонецПроцедуры

Процедура ДобавитьПоляГруппировки(Элемент, ЭлементПользователя, ТипСтруктуры = "Строки", ПервоеИзмерение = Истина)
	
	// Добавим строки
	Если ТипСтруктуры = "ПоляГруппировки" Тогда
		СтрокиПользователя = ЭлементПользователя;
	Иначе
		// Добавляем фиктивную группировку без полей группировки
		СтрокиПользователя = ЭлементПользователя[ТипСтруктуры].Добавить();
	КонецЕсли;
	
	Если ПервоеИзмерение Тогда
		ЭлементыФормы.НастройкиСкрытыеГруппировкиСтрок.ТекущаяСтрока = СтрокиПользователя;
	Иначе
		ЭлементыФормы.НастройкиСкрытыеГруппировкиКолонок.ТекущаяСтрока = СтрокиПользователя;
	КонецЕсли;
	
	// Есть хотя бы одна строка группировки с хотя бы одним полем группировки
	Если ТипСтруктуры = "ПоляГруппировки" Тогда
		Группировка = Элемент;
		ГруппировкиЕсть = Истина;
	ИначеЕсли ТипСтруктуры <> "ПоляГруппировки"
		    И Элемент[ТипСтруктуры].Количество() > 0 Тогда
	    // Получим первую группировку
		Группировка = Элемент[ТипСтруктуры][0];
		ГруппировкиЕсть = Истина;
	Иначе
		ГруппировкиЕсть = Ложь;
	КонецЕсли;
	
	Пока ГруппировкиЕсть Цикл
		// Если ни одного поля группировки нет, значит в отчете есть детальные записи
		Если Группировка.ПоляГруппировки.Элементы.Количество() = 0 Тогда
			Прервать;
		КонецЕсли;
		// Определяем первое поле в очередной группировке и добавляем в пользовательские поля группировки
		ПолеГруппировки = Группировка.ПоляГруппировки.Элементы[0];
		ПолеГруппировкиПользователя = СтрокиПользователя.ПоляГруппировки.Элементы.Добавить(Тип("ПолеГруппировкиКомпоновкиДанных"));
		ЗаполнитьЗначенияСвойств(ПолеГруппировкиПользователя, ПолеГруппировки);
		Если Группировка.Структура.Количество() = 0 Тогда
			Прервать;
		Иначе
			// Переходим на уровень ниже по группировкам
			Группировка = Группировка.Структура[0];
		КонецЕсли;
	КонецЦикла;
	
КонецПроцедуры

Процедура ДобавитьГруппировки(ЭлементОтчета, Элемент, ТипСтруктуры)
	
	// Добавим в компоновщик настроек строки группировки таблицы
	Если ТипСтруктуры = "ПоляГруппировки" Тогда
		СтрокиЭлемента = Элемент;
		ЭлементОтчета.ПоляГруппировки.Элементы.Очистить();
		ЭлементОтчета.Структура.Очистить();
	Иначе
		СтрокиЭлемента = Элемент[ТипСтруктуры][0];
		ЭлементОтчета[ТипСтруктуры].Очистить();
	КонецЕсли;
	
	Если СтрокиЭлемента.ПоляГруппировки.Элементы.Количество() <> 0 Тогда
		Если ТипСтруктуры = "ПоляГруппировки" Тогда
			НоваяСтрока = ЭлементОтчета;
		Иначе
			НоваяСтрока = ЭлементОтчета[ТипСтруктуры].Добавить();
		КонецЕсли;
	Иначе
		Если ТипСтруктуры = "ПоляГруппировки" Тогда
			НоваяСтрока = ЭлементОтчета;
		Иначе
			НоваяСтрока = ЭлементОтчета[ТипСтруктуры];
		КонецЕсли;
	КонецЕсли;
	
	Если ТипСтруктуры = "ПоляГруппировки" И СтрокиЭлемента.ПоляГруппировки.Элементы.Количество() = 0 Тогда
		НоваяСтрока = ЭлементОтчета.Родитель;
		ЭлементОтчета.Родитель.Структура.Удалить(ЭлементОтчета);
	КонецЕсли;
		
	Для каждого СтрокаГруппировки Из СтрокиЭлемента.ПоляГруппировки.Элементы Цикл
		НовоеПолеГруппировки = НоваяСтрока.ПоляГруппировки.Элементы.Добавить(Тип("ПолеГруппировкиКомпоновкиДанных"));
		ЗаполнитьЗначенияСвойств(НовоеПолеГруппировки, СтрокаГруппировки);
		ТиповыеОтчеты.ДобавитьАвтоВыбранноеПоле(НоваяСтрока);
		ТиповыеОтчеты.ДобавитьАвтоЭлементПорядка(НоваяСтрока);
		Если СтрокиЭлемента.ПоляГруппировки.Элементы.Индекс(СтрокаГруппировки) = СтрокиЭлемента.ПоляГруппировки.Элементы.Количество() - 1 Тогда
			Прервать;
		КонецЕсли;
		Если ТипСтруктуры = "ПоляГруппировки" Тогда
			НоваяСтрока = НоваяСтрока.Структура.Добавить(Тип("ГруппировкаКомпоновкиДанных"));
		Иначе
			НоваяСтрока = НоваяСтрока.Структура.Добавить();
		КонецЕсли;
	КонецЦикла;
КонецПроцедуры
	
Процедура ЗаполнитьКомпоновщикНастроекОтчета(СтарыйТипСтрок = Неопределено, СтарыйТипКолонок = Неопределено, НовыйТипЭлемента = Неопределено)
	
	ОтчетОбъект.КомпоновщикНастроек.Настройки.Структура.Очистить();
	
	// Настройки компоновщика отчета
	Элемент = КомпоновщикНастроек.Настройки.Структура[0];
	ТипЭлемента = ТипЗнч(Элемент);
	
	ЭлементОтчета = ОтчетОбъект.КомпоновщикНастроек.Настройки.Структура.Добавить(ТипЭлемента);
	Если ТипЭлемента = Тип("ДиаграммаКомпоновкиДанных") Тогда
		ТиповыеОтчеты.ДобавитьАвтоВыбранноеПоле(ЭлементОтчета);
	КонецЕсли;
	
	// Скопируем настройки в компоновщик из компоновщика отчета
	ТиповыеОтчеты.СкопироватьЭлементы(ОтчетОбъект.КомпоновщикНастроек.Настройки.Выбор, КомпоновщикНастроек.Настройки.Выбор);
	ТиповыеОтчеты.СкопироватьЭлементы(ОтчетОбъект.КомпоновщикНастроек.Настройки.Отбор, КомпоновщикНастроек.Настройки.Отбор);
	ТиповыеОтчеты.СкопироватьЭлементы(ОтчетОбъект.КомпоновщикНастроек.Настройки.Порядок, КомпоновщикНастроек.Настройки.Порядок);
	ТиповыеОтчеты.СкопироватьЭлементы(ОтчетОбъект.КомпоновщикНастроек.Настройки.УсловноеОформление, КомпоновщикНастроек.Настройки.УсловноеОформление, Ложь);
	ТиповыеОтчеты.СкопироватьЭлементы(ОтчетОбъект.КомпоновщикНастроек.Настройки.ПользовательскиеПоля, КомпоновщикНастроек.Настройки.ПользовательскиеПоля);
	ТиповыеОтчеты.ЗаполнитьЭлементы(ОтчетОбъект.КомпоновщикНастроек.Настройки.ПараметрыДанных, КомпоновщикНастроек.Настройки.ПараметрыДанных);
	ТиповыеОтчеты.ЗаполнитьЭлементы(ОтчетОбъект.КомпоновщикНастроек.Настройки.ПараметрыВывода, КомпоновщикНастроек.Настройки.ПараметрыВывода);
	
	Если ТипЭлемента = Тип("ГруппировкаКомпоновкиДанных") Тогда
		
		ДобавитьГруппировки(ЭлементОтчета, Элемент, "ПоляГруппировки");
		
	ИначеЕсли ТипЭлемента = Тип("ТаблицаКомпоновкиДанных") Тогда
		
		ДобавитьГруппировки(ЭлементОтчета, Элемент, "Строки");
		ДобавитьГруппировки(ЭлементОтчета, Элемент, "Колонки");
				
	ИначеЕсли ТипЭлемента = Тип("ДиаграммаКомпоновкиДанных") Тогда
		
		ДобавитьГруппировки(ЭлементОтчета, Элемент, "Серии");
		ДобавитьГруппировки(ЭлементОтчета, Элемент, "Точки");
		
	КонецЕсли;
	
КонецПроцедуры

Процедура ТабличноеПолеГруппировкиСтраницаТаблицаПроверкаПеретаскивания(Элемент, ПараметрыПеретаскивания, СтандартнаяОбработка, Строка, Колонка)
	
	Если ТипЗнч(ПараметрыПеретаскивания.Значение[0]) = Тип("ДоступноеПолеКомпоновкиДанных")
		И (ПараметрыПеретаскивания.Значение[0].Ресурс 
		ИЛИ ПараметрыПеретаскивания.Значение[0].Родитель <> Неопределено
		И (ПараметрыПеретаскивания.Значение[0].Родитель.Поле = Новый ПолеКомпоновкиДанных("SystemFields")
		ИЛИ ПараметрыПеретаскивания.Значение[0].Родитель.Поле = Новый ПолеКомпоновкиДанных("DataParameters"))) Тогда
		СтандартнаяОбработка = Ложь;
		ПараметрыПеретаскивания.ДопустимыеДействия = ДопустимыеДействияПеретаскивания.НеОбрабатывать;
		ПараметрыПеретаскивания.Действие = ДействиеПеретаскивания.Отмена;
	КонецЕсли;
		
КонецПроцедуры

Процедура ОсновныеДействияФормыОК(Кнопка)
	
	СохранитьИЗакрыть();
	
КонецПроцедуры


Процедура ФлажокОтображатьЗаголовокПриИзменении(Элемент)
	
	Если Элемент.Значение Тогда
		Значение = ТипВыводаТекстаКомпоновкиДанных.Выводить;
	Иначе
		Значение = ТипВыводаТекстаКомпоновкиДанных.НеВыводить;
	КонецЕсли;
	
	КомпоновщикНастроек.Настройки.ПараметрыВывода.НайтиЗначениеПараметра(Новый ПараметрКомпоновкиДанных("TitleOutput")).Значение = Значение;
	
КонецПроцедуры

Процедура ПанельНастройкиПриСменеСтраницы(Элемент, ТекущаяСтраница)
	
	УстановитТекущуюСтраницуПанелиПереноса(ЭлементыФормы.ПанельНастройки.Страницы[ТекущаяСтраница]);
	ОбновитьКонтекстноеМенюДоступныхПолей();
	
КонецПроцедуры

Процедура УстановитТекущуюСтраницуПанелиПереноса(ТекущаяСтраница = Неопределено)
	
	Если ТекущаяСтраница = Неопределено Тогда
		ТекущаяСтраница = ЭлементыФормы.ПанельНастройки.ТекущаяСтраница;
	КонецЕсли;
		
	Если ТекущаяСтраница = ЭлементыФормы.ПанельНастройки.Страницы.СтруктураОтчета Тогда
		КоличествоПолей = 3;
	ИначеЕсли ТекущаяСтраница = ЭлементыФормы.ПанельНастройки.Страницы.ОтборИСортировка Тогда
		КоличествоПолей = 2;
	Иначе
		КоличествоПолей = 0;
	КонецЕсли;
	
	ЭлементыФормы.ПанельПереноса.ТекущаяСтраница = ЭлементыФормы.ПанельПереноса.Страницы["Страница" + КоличествоПолей];
	
КонецПроцедуры

Процедура ПеренестиНажатие(Элемент)
	
	ПеренестиПоле(Элемент.Имя);
	
КонецПроцедуры

Функция ПолучитьТабличноеПолеПоНомеру(НомерТабличногоПоля)
	
	ТекущаяСтраницаНастройки = ЭлементыФормы.ПанельНастройки.ТекущаяСтраница;
	Если ТекущаяСтраницаНастройки = ЭлементыФормы.ПанельНастройки.Страницы.СтруктураОтчета Тогда
			Если НомерТабличногоПоля = 1 Тогда
				ТабличноеПоле = ЭлементыФормы.ТабличноеПолеГруппировкиСтрокСтраницаНеТаблица;
			ИначеЕсли НомерТабличногоПоля = 2 Тогда
				ТабличноеПоле = ЭлементыФормы.ВыбранныеПоляСтраницаНеТаблица;
			ИначеЕсли НомерТабличногоПоля = 3 Тогда
				ТабличноеПоле = ЭлементыФормы.ВыбранныеПоляСтраницаНеТаблица;
			КонецЕсли;
	ИначеЕсли ТекущаяСтраницаНастройки = ЭлементыФормы.ПанельНастройки.Страницы.ОтборИСортировка Тогда
			Если НомерТабличногоПоля = 1 Тогда
				ТабличноеПоле = ЭлементыФормы.ТабличноеПолеОтборСтраницаБезПараметров;
			ИначеЕсли НомерТабличногоПоля = 2 Тогда
				ТабличноеПоле = ЭлементыФормы.ТабличноеПолеСортировкаСтраницаБезПараметров;
			КонецЕсли;
	КонецЕсли;
	
	Возврат ТабличноеПоле;

КонецФункции

Процедура ПеренестиПоле(ИмяКоманды)
	
	Если Лев(ИмяКоманды, 5) = "Влево" Тогда
		Команда = "Удалить";
		НомерТабличногоПоля = Число(Сред(ИмяКоманды, 7,1));
	Иначе
		Команда = "Добавить";
		НомерТабличногоПоля = Число(Сред(ИмяКоманды, 8,1));
	КонецЕсли;
	
	ТабличноеПоле = ПолучитьТабличноеПолеПоНомеру(НомерТабличногоПоля);
	
	
	Если Команда = "Удалить" Тогда
		ТекущиеДанные = ТабличноеПоле.ТекущиеДанные;
		Если ТекущиеДанные <> Неопределено Тогда
			ТабличноеПоле.Значение.Элементы.Удалить(ТекущиеДанные);
		КонецЕсли;
	Иначе
		ТекущиеДанныеДоступныеПоля = ЭлементыФормы.ТабличноеПолеДоступныеПоля.ТекущиеДанные;
		Если ТекущиеДанныеДоступныеПоля = Неопределено 
		 ИЛИ ТекущиеДанныеДоступныеПоля.Папка Тогда
			Возврат;
		КонецЕсли;
		ПолеДобавить = ТекущиеДанныеДоступныеПоля.Поле;
		ТипЭлемента = Неопределено;
		МожноДобавлять = ПолеДоступно(ПолеДобавить, ТабличноеПоле, ТипЭлемента);
		Если МожноДобавлять Тогда
			НовыйЭлемент = ТабличноеПоле.Значение.Элементы.Добавить(ТипЭлемента);
			Если ТипЭлемента = Тип("ЭлементОтбораКомпоновкиДанных") Тогда
				НовыйЭлемент.ЛевоеЗначение = ПолеДобавить;
			Иначе
				НовыйЭлемент.Поле = ПолеДобавить;
			КонецЕсли;
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

Функция ПолеДоступно(Поле, ТабличноеПоле, ТипЭлемента = Неопределено)
	
	Если ТипЗнч(ТабличноеПоле.Значение) = Тип("ПоляГруппировкиКомпоновкиДанных") Тогда
		МожноДобавить = (ТабличноеПоле.Значение.ДоступныеПоляПолейГруппировок.НайтиПоле(Поле) <> Неопределено);
		ТипЭлемента = Тип("ПолеГруппировкиКомпоновкиДанных");
	ИначеЕсли ТипЗнч(ТабличноеПоле.Значение) = Тип("ВыбранныеПоляКомпоновкиДанных") Тогда
		МожноДобавить = (ТабличноеПоле.Значение.ДоступныеПоляВыбора.НайтиПоле(Поле) <> Неопределено);
		ТипЭлемента = Тип("ВыбранноеПолеКомпоновкиДанных");
	ИначеЕсли ТипЗнч(ТабличноеПоле.Значение) = Тип("ПорядокКомпоновкиДанных") Тогда
		МожноДобавить = (ТабличноеПоле.Значение.ДоступныеПоляПорядка.НайтиПоле(Поле) <> Неопределено);
		ТипЭлемента = Тип("ЭлементПорядкаКомпоновкиДанных");
	ИначеЕсли ТипЗнч(ТабличноеПоле.Значение) = Тип("ОтборКомпоновкиДанных") Тогда
		МожноДобавить = (ТабличноеПоле.Значение.ДоступныеПоляОтбора.НайтиПоле(Поле) <> Неопределено);
		ТипЭлемента = Тип("ЭлементОтбораКомпоновкиДанных");
	Иначе
		МожноДобавить = Ложь;
	КонецЕсли;
	
	Возврат МожноДобавить;
		
КонецФункции

Процедура ОсновныеДействияФормыСформировать(Кнопка)
	
	СохранитьИЗакрыть(Истина);
	
КонецПроцедуры

Процедура КоманднаяПанельДоступныеПоляПользовательскиеПоля(Кнопка)
	
	ТиповыеОтчеты.РедактироватьПользовательскиеПоля(КомпоновщикНастроек);
	
КонецПроцедуры

Процедура ДобавитьКнопкуЕслиПолеДоступно(КоличествоТабличныеПолей, НомерТабличногоПоля, ТекстКудаДобавлять, Картинка = Неопределено)
	
	Если Картинка = Неопределено Тогда
		Картинка = БиблиотекаКартинок.ДобавитьЭлементСписка;
	КонецЕсли;
	Кнопки = ЭлементыФормы.КонекстноеМенюДоступныеПоля.Кнопки;
	Действие = Новый Действие("ПеренестиНажатие");
	Если ПолеДоступно(ЭлементыФормы.ТабличноеПолеДоступныеПоля.ТекущиеДанные.Поле, ПолучитьТабличноеПолеПоНомеру(НомерТабличногоПоля)) Тогда
		Кнопка = Кнопки.Добавить("Вправо" + КоличествоТабличныеПолей + НомерТабличногоПоля, ТипКнопкиКоманднойПанели.Действие, "Добавить поле " + ТекстКудаДобавлять, Действие);
		Кнопка.Картинка = Картинка;
	КонецЕсли;
	
КонецПроцедуры

Процедура ТабличноеПолеДоступныеПоляПриАктивизацииСтроки(Элемент)
	
	ОбновитьКонтекстноеМенюДоступныхПолей();
	
КонецПроцедуры

Процедура ОбновитьКонтекстноеМенюДоступныхПолей()
	
	Кнопки = ЭлементыФормы.КонекстноеМенюДоступныеПоля.Кнопки;
	Кнопки.Очистить();
	
	Если ЭлементыФормы.ТабличноеПолеДоступныеПоля.ТекущиеДанные = Неопределено Тогда
		Возврат;
	КонецЕсли;
	Если ЭлементыФормы.ТабличноеПолеДоступныеПоля.ТекущиеДанные.Поле = Новый ПолеКомпоновкиДанных("UserFields") Тогда
		Действие = Новый Действие("КоманднаяПанельДоступныеПоляПользовательскиеПоля");
		Кнопка = Кнопки.Добавить("ПользовательскиеПоля", ТипКнопкиКоманднойПанели.Действие, "Настройка польз. полей", Действие);
		Кнопка.Картинка = БиблиотекаКартинок.ПользовательскиеПоля;
        Кнопка = Кнопки.Добавить("Разделитель", ТипКнопкиКоманднойПанели.Разделитель);
	КонецЕсли;	
 	Если  ЭлементыФормы.ТабличноеПолеДоступныеПоля.ТекущиеДанные.Папка Тогда 
		Возврат;
	КонецЕсли;
	
	Действие = Новый Действие("ПеренестиНажатие");
	ТекстВДополнительныеПоля = "дополнительные поля";
	
	Если ЭлементыФормы.ПанельНастройки.ТекущаяСтраница = ЭлементыФормы.ПанельНастройки.Страницы.СтруктураОтчета Тогда
			ДобавитьКнопкуЕслиПолеДоступно(3, 1, "в строки", БиблиотекаКартинок.НоваяГруппировкаКомпоновкиДанных);
			ДобавитьКнопкуЕслиПолеДоступно(3, 2, "в колонки", БиблиотекаКартинок.НоваяГруппировкаКомпоновкиДанных);
			ДобавитьКнопкуЕслиПолеДоступно(3, 3, ТекстВДополнительныеПоля, БиблиотекаКартинок.ДобавитьЭлементСписка);
	ИначеЕсли ЭлементыФормы.ПанельНастройки.ТекущаяСтраница = ЭлементыФормы.ПанельНастройки.Страницы.ОтборИСортировка Тогда
			ДобавитьКнопкуЕслиПолеДоступно(2, 1, "в отбор", БиблиотекаКартинок.Отбор);
			ДобавитьКнопкуЕслиПолеДоступно(2, 2, "в сортировку", БиблиотекаКартинок.ПорядокКомпоновки);
	КонецЕсли;
	Если ЭлементыФормы.ТабличноеПолеДоступныеПоля.ТекущиеДанные.Родитель <> Неопределено 
	   И ЭлементыФормы.ТабличноеПолеДоступныеПоля.ТекущиеДанные.Родитель.Поле = Новый ПолеКомпоновкиДанных("UserFields") Тогда
		Для Каждого ПользовательскоеПоле Из КомпоновщикНастроек.Настройки.ПользовательскиеПоля.Элементы Цикл
			Если ПользовательскоеПоле.ПутьКДанным = Строка(ЭлементыФормы.ТабличноеПолеДоступныеПоля.ТекущиеДанные.Поле) Тогда
				Прервать;
			КонецЕсли;
		КонецЦикла;
		Если ТиповыеОтчеты.ПолучитьИмяФормыРедактированияПользовательскогоПоля(ПользовательскоеПоле) <> Неопределено Тогда
			Кнопка = Кнопки.Добавить("Разделитель", ТипКнопкиКоманднойПанели.Разделитель);
			Кнопка = Кнопки.Добавить("ПользовательскоеПоле", ТипКнопкиКоманднойПанели.Действие, "Редактировать пользоват. поле ", Новый Действие("РедактироватьПользовательскоеПоле"));
			Кнопка.Картинка = БиблиотекаКартинок.ИзменитьЭлементСписка;
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

Процедура РедактироватьПользовательскоеПоле(Кнопка)

	Для Каждого ПользовательскоеПоле Из КомпоновщикНастроек.Настройки.ПользовательскиеПоля.Элементы Цикл
		Если ПользовательскоеПоле.ПутьКДанным = Строка(ЭлементыФормы.ТабличноеПолеДоступныеПоля.ТекущиеДанные.Поле) Тогда
			Прервать;
		КонецЕсли;
	КонецЦикла;
	ИмяФормы = ТиповыеОтчеты.ПолучитьИмяФормыРедактированияПользовательскогоПоля(ПользовательскоеПоле);
	
	Конструктор = Обработки.КонструкторПользовательскихПолей.Создать();
	Форма = Конструктор.ПолучитьФорму(ИмяФормы, ЭтаФорма);
	Форма.КомпоновщикНастроек = КомпоновщикНастроек;
	Форма.ПользовательскоеПоле = ПользовательскоеПоле;
	Форма.Открыть();

КонецПроцедуры

Процедура РаскраскаНедоступныхПриПолученииДанных(Элемент, ОформленияСтрок)
	
	Для Каждого Оформление Из ОформленияСтрок Цикл
		
		Если Не СтрокаИспользуется(Оформление.ДанныеСтроки) Тогда
			
			Оформление.ЦветТекста = НеИспользуемыйЦвет;
			
		КонецЕсли;
		
	КонецЦикла;
	
КонецПроцедуры

Функция СтрокаИспользуется(Знач Стр)

	Если ТипЗнч(Стр) = Тип("КоллекцияЭлементовСтруктурыДиаграммыКомпоновкиДанных") ИЛИ
		ТипЗнч(Стр) = Тип("КоллекцияЭлементовСтруктурыТаблицыКомпоновкиДанных") Тогда
		
		Возврат Ложь;
		
	КонецЕсли;
	
	Используется = Истина;
			
	Пока Используется И Стр <> Неопределено Цикл
				
		Попытка 
			
			Используется = Стр.Использование;
					
		Исключение
			
		КонецПопытки;
				
		Попытка 
			
			Стр = Стр.Родитель;
			
		Исключение
			
			Прервать;
			
		КонецПопытки;
				
	КонецЦикла;
	
	Возврат Используется;
			
КонецФункции

Процедура УсловноеОформлениеПриВыводеСтроки(Элемент, ОформлениеСтроки, ДанныеСтроки)
	
	Если ДанныеСтроки.Поля.Элементы.Количество() = 0 Тогда
		
		ОформлениеСтроки.Ячейки.ОбластиДляКраткогоОтображенияЭлемента.Текст = НСтр("ru='<Все поля>';uk='<Всі поля>'");
		ОформлениеСтроки.Ячейки.ОбластиДляПодробногоОтображенияЭлемента.Текст = НСтр("ru='<Все поля>';uk='<Всі поля>'");
		
	КонецЕсли;
		
	Если ДанныеСтроки.Отбор.Элементы.Количество() = 0 Тогда
		
		ОформлениеСтроки.Ячейки.ОтборДляКраткогоОтображенияЭлемента.Текст = НСтр("ru='<Без условия>';uk='<Без умови>'");
		ОформлениеСтроки.Ячейки.ОтборДляПодробногоОтображенияЭлемента.Текст = НСтр("ru='<Без условия>';uk='<Без умови>'");
		
	КонецЕсли;
	
	ЦветФона = ДанныеСтроки.Оформление.НайтиЗначениеПараметра(Новый ПараметрКомпоновкиДанных("ЦветФона"));
	Если ЦветФона.Использование Тогда
		
		ОформлениеСтроки.ЦветФона = ЦветФона.Значение;
		
	КонецЕсли;
	
	ЦветТекста = ДанныеСтроки.Оформление.НайтиЗначениеПараметра(Новый ПараметрКомпоновкиДанных("ЦветТекста"));
	Если ЦветТекста.Использование Тогда
		
		ОформлениеСтроки.ЦветТекста = ЦветТекста.Значение;
		
	КонецЕсли;
	
	Шрифт = ДанныеСтроки.Оформление.НайтиЗначениеПараметра(Новый ПараметрКомпоновкиДанных("Шрифт"));
	Если Шрифт.Использование Тогда
		
		ОформлениеСтроки.Шрифт = Шрифт.Значение;
		
	КонецЕсли;
	
	Текст = ДанныеСтроки.Оформление.НайтиЗначениеПараметра(Новый ПараметрКомпоновкиДанных("Текст"));
	Если Текст.Использование Тогда
		
		ОформлениеСтроки.Ячейки.ОформлениеДляКраткогоОтображенияЭлемента.Текст = Текст.Значение;
		ОформлениеСтроки.Ячейки.ОформлениеДляПодробногоОтображенияЭлемента.Текст = Текст.Значение;
		
	КонецЕсли;
	
КонецПроцедуры

Процедура ТабличноеПолеОтборПередНачаломИзменения(Элемент, Отказ)
	
	ТекущаяСтрока = ПолучитьТекущуюСтрокуОтбора();
	Если ТипЗнч(ТекущаяСтрока) = Тип("ОтборКомпоновкиДанных") 
	 ИЛИ ТипЗнч(ТекущаяСтрока) = Тип("ГруппаЭлементовОтбораКомпоновкиДанных")
	 ИЛИ ОбщийОтбор = Неопределено Тогда
		Возврат
	КонецЕсли;
	
	Если ОбщийОтбор[ТекущаяСтрока.ЛевоеЗначение] = Истина Тогда
		Вопрос(НСтр("ru='Поле входит в общий отбор!';uk='Поле входить у загальний відбір!'"), РежимДиалогаВопрос.ОК);
		Отказ = Истина;
	КонецЕсли;
	
КонецПроцедуры

Функция ПолучитьТекущуюСтрокуОтбора()
	
	Если ЭлементыФормы.ПанельОтборСортировка.ТекущаяСтраница = ЭлементыФормы.ПанельОтборСортировка.Страницы.СтраницаБезПараметров Тогда
		ТекущаяСтрока = ЭлементыФормы.ТабличноеПолеОтборСтраницаБезПараметров.ТекущаяСтрока;
	Иначе
		ТекущаяСтрока = ЭлементыФормы.ТабличноеПолеОтборСтраницаПараметры.ТекущаяСтрока;
	КонецЕсли;
	
	Возврат ТекущаяСтрока;
	
КонецФункции

Процедура ТабличноеПолеОтборЛевоеЗначениеПриИзменении(Элемент)
	
	ТекущаяСтрока = ПолучитьТекущуюСтрокуОтбора();
	Если ТипЗнч(ТекущаяСтрока) = Тип("ОтборКомпоновкиДанных") 
	 ИЛИ ТипЗнч(ТекущаяСтрока) = Тип("ГруппаЭлементовОтбораКомпоновкиДанных")
	 ИЛИ ОбщийОтбор = Неопределено Тогда
		Возврат
	КонецЕсли;
	
	Если ОбщийОтбор[ТекущаяСтрока.ЛевоеЗначение] = Истина Тогда
		Вопрос(НСтр("ru='Поле входит в общий отбор!';uk='Поле входить у загальний відбір!'"), РежимДиалогаВопрос.ОК);
		ТекущаяСтрока.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("");
		Отказ = Истина;
	КонецЕсли;
	
КонецПроцедуры

Процедура ТабличноеПолеОтборПередУдалением(Элемент, Отказ)
	
	ТекущаяСтрока = ПолучитьТекущуюСтрокуОтбора();
	Если ТекущаяСтрока = Неопределено 
	 ИЛИ ТипЗнч(ТекущаяСтрока) = Тип("ОтборКомпоновкиДанных") 
	 ИЛИ ТипЗнч(ТекущаяСтрока) = Тип("ГруппаЭлементовОтбораКомпоновкиДанных")
	 ИЛИ ОбщийОтбор = Неопределено Тогда
		Возврат
	КонецЕсли;
		
	Если ОбщийОтбор[ТекущаяСтрока.ЛевоеЗначение] = Истина Тогда
		Вопрос(НСтр("ru='Поле входит в общий отбор!';uk='Поле входить у загальний відбір!'"), РежимДиалогаВопрос.ОК);
		Отказ = Истина;
	КонецЕсли;
	
КонецПроцедуры


Процедура ОбновитьКнопкиКонтекстногоМенюПоказатели(КоманднаяПанель)
	
	Действие  = Новый Действие("ДействиеВключитьВыключитьПапку");
	Для каждого ДоступноеПоле Из КомпоновщикНастроек.Настройки.ДоступныеПоляВыбора.Элементы Цикл
		Если ДоступноеПоле.Папка 
		   И ДоступноеПоле.Поле <> Новый ПолеКомпоновкиДанных("SystemFields")
		   И ДоступноеПоле.Поле <> Новый ПолеКомпоновкиДанных("DataParameters")
		   И ДоступноеПоле.Поле <> Новый ПолеКомпоновкиДанных("UserFields")
		   И ДоступноеПоле.Поле <> Новый ПолеКомпоновкиДанных("Периоды") Тогда
			Кнопка = КоманднаяПанель.Кнопки.Добавить("Включить" + ДоступноеПоле.Поле, ТипКнопкиКоманднойПанели.Действие, "Включить """ + ДоступноеПоле.Заголовок + """", Действие);
			Кнопка.Картинка = БиблиотекаКартинок.УстановитьФлажкиПапка;
			Кнопка = КоманднаяПанель.Кнопки.Добавить("Выключить" + ДоступноеПоле.Поле, ТипКнопкиКоманднойПанели.Действие, "Выключить """ + ДоступноеПоле.Заголовок + """", Действие);
			Кнопка.Картинка = БиблиотекаКартинок.СнятьФлажкиПапка;
		КонецЕсли;
	КонецЦикла;
	
	Кнопка = КоманднаяПанель.Кнопки.Добавить("Разделитель10", ТипКнопкиКоманднойПанели.Разделитель);
	Действие  = Новый Действие("ДействиеУстановитьПоУровню");
	Кнопка = КоманднаяПанель.Кнопки.Добавить("УстановитьПоУровнюГоризонтально", ТипКнопкиКоманднойПанели.Действие, "Установить по уровню ""Горизонтально""", Действие);
	Кнопка = КоманднаяПанель.Кнопки.Добавить("УстановитьПоУровнюВертикально", ТипКнопкиКоманднойПанели.Действие, "Установить по уровню ""Вертикально""", Действие);
	
КонецПроцедуры

Процедура ДействиеВключитьВыключитьПапку(Кнопка)
	
	Если Лев(Кнопка.Имя, 8) = "Включить" Тогда
		Использование = Истина;
		ПутьКДаннымПапки = Сред(Кнопка.Имя, 9);
	ИначеЕсли Лев(Кнопка.Имя, 9) = "Выключить" Тогда
		Использование = Ложь;
		ПутьКДаннымПапки = Сред(Кнопка.Имя, 10);
	КонецЕсли;	
	
	ВыбранныеПоля = ТиповыеОтчеты.ПолучитьВыбранныеПоля(КомпоновщикНастроек);
	Для каждого ВыбранноеПоле Из ВыбранныеПоля Цикл
		Если Лев(Строка(ВыбранноеПоле.Поле), СтрДлина(ПутьКДаннымПапки)) = ПутьКДаннымПапки Тогда
			ВыбранноеПоле.Использование = Использование;
		КонецЕсли;
	КонецЦикла;
			
КонецПроцедуры

Процедура ТабличноеПолеДоступныеПоляПриПолученииДанных(Элемент, ОформленияСтрок)
	
	Для каждого ОформлениеСтроки Из ОформленияСтрок Цикл
		ДанныеСтроки = ОформлениеСтроки.ДанныеСтроки;
		Если ДанныеСтроки.Папка Тогда
			ПапкаСРесурсами = Ложь;
			Для каждого ДоступноеПоле Из ДанныеСтроки.Элементы Цикл
				ПапкаСРесурсами = Истина;
				Если Не ДоступноеПоле.Ресурс Тогда
					ПапкаСРесурсами = Ложь;
					Прервать;
				КонецЕсли;
			КонецЦикла;
			Если ПапкаСРесурсами Тогда
				ОформлениеСтроки.Ячейки.Заголовок.Картинка = БиблиотекаКартинок.ПапкаСРесурсами;
			КонецЕсли;
		КонецЕсли;
	КонецЦикла;
	
КонецПроцедуры


Процедура ДействиеУстановитьПоУровню(Кнопка)
	
	Если Кнопка.Имя = "УстановитьПоУровнюГоризонтально" Тогда
		Расположение = РасположениеПоляКомпоновкиДанных.Горизонтально;
	Иначе
		Расположение = РасположениеПоляКомпоновкиДанных.Вертикально;
	КонецЕсли;
	
	Если ПредставлениеЭлементаОтчета = Перечисления.ПредставленияЭлементовОтчетов.Таблица Тогда
		Элемент = ЭлементыФормы.ВыбранныеПоляСтраницаТаблица;
	Иначе
		Элемент = ЭлементыФормы.ВыбранныеПоляСтраницаНеТаблица;
	КонецЕсли;
	
	ТекущаяСтрока = Элемент.ТекущиеДанные;
	Уровень = ПолучитьУровеньВыбранногоПоля(ТекущаяСтрока);
	
	Для каждого Группа Из ТиповыеОтчеты.ПолучитьВыбранныеПоля(КомпоновщикНастроек, Истина) Цикл
		Если ПолучитьУровеньВыбранногоПоля(Группа) = Уровень Тогда
			Группа.Расположение = Расположение;
		КонецЕсли;
	КонецЦикла;
	
КонецПроцедуры

Функция ПолучитьУровеньВыбранногоПоля(Знач ВыбранноеПоле) Экспорт
	
	Родитель = ВыбранноеПоле;
	Уровень = 0;
	Пока Родитель <> Неопределено Цикл
		Родитель = Родитель.Родитель;
		Уровень = Уровень + 1;
	КонецЦикла;
	
	Возврат Уровень;
	
КонецФункции




НеИспользуемыйЦвет = Новый Цвет(153, 153, 153);
