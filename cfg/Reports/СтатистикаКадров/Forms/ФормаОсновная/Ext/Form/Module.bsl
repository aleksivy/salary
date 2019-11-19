﻿////////////////////////////////////////////////////////////////////////////////
// ПЕРЕМЕННЫЕ МОДУЛЯ

Перем мПоказыватьЗаголовок Экспорт;
Перем мВысотаЗаголовка Экспорт;
Перем мТаблицаДиаграммы Экспорт;
Перем СтруктураСвязиЭлементовСДанными Экспорт;
Перем мМассивТипов Экспорт;
Перем мНазваниеОтчета Экспорт;

// Формирует текст заголовка
//
// Параметры:
//	Нет.
//
Процедура СформироватьЗаголовокФормы()
	
	Заголовок = УправлениеОтчетами.СформироватьЗаголовокОсновнойФормы(ДатаАктуальности, ДатаАктуальности, мНазваниеОтчета, 1);
	
КонецПроцедуры // СформироватьЗаголовокФормы()

// Возвращает заголовок окна отчета для текущего вида отчета
Функция СформироватьЗаголовокОкна()
	Возврат ВидОтчета + ?(ЗначениеЗаполнено(мНастройка)," (" + мНастройка.Наименование + ")","");
КонецФункции // ЗаголовокОкнаДляВидаОтчета()

// Управляет выводом заголовка
//
// Параметры:
//	Нет.
//
Процедура ВыводЗаголовка()

	// Перезаполнять заголовок можно только у "чистого" отчета
	Если ЭлементыФормы.ДокументРезультат.ВысотаТаблицы = 0 Тогда
		ОбластьЗаголовка = СформироватьЗаголовокОтчета(ЭтотОбъект);
		мВысотаЗаголовка = ОбластьЗаголовка.ВысотаТаблицы;
		ЭлементыФормы.ДокументРезультат.Вывести(ОбластьЗаголовка);
	КонецЕсли;
	Если ЗначениеЗаполнено(мВысотаЗаголовка) Тогда
		ЭлементыФормы.ДокументРезультат.Область("R1:R" + мВысотаЗаголовка).Видимость = мПоказыватьЗаголовок;
	КонецЕсли;
	ОбработатьКнопкуЗаголовок(ЭлементыФормы.КоманднаяПанельФормы, мПоказыватьЗаголовок)
	
КонецПроцедуры // ВыводЗаголовка()

///////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ ФОРМЫ

// Процедура - обработчик события "ПередОткрытием" формы.
//
Процедура ПередОткрытием(Отказ, СтандартнаяОбработка)

	Если ЗначениеЗаполнено(НачальноеЗначениеВыбора) Тогда
		// Вызов формы с загруженной настройкой
		мНастройка = НачальноеЗначениеВыбора;
		ВидОтчета = мНастройка.ВидНастройки;
		РеквизитыПредустановлены = Истина;
		ЗаполнитьНачальныеНастройки(Истина);
	Иначе	
		Если НЕ ЗначениеЗаполнено(ВидОтчета) Тогда
			ВидОтчета = мМассивВидыОтчета[0];
		КонецЕсли; 

		Состояние(НСтр("ru='Заполнение по умолчанию';uk='Заповнення по умовчанню'"));

		ЗаполнитьНачальныеНастройки(?(КлючУникальности <> Неопределено,КлючУникальности,Ложь));
	КонецЕсли;	
	
	мМассивТипов = Новый Массив;
	мМассивТипов.Добавить("Подразделения");
	мМассивТипов.Добавить("Должности");
	мМассивТипов.Добавить("Организации");
	мМассивТипов.Добавить("ПодразделенияОрганизаций");
	мМассивТипов.Добавить("ДолжностиОрганизаций");
	
	ОбработатьПоляБыстрогоОтбораНаФорме(мМассивТипов,ЭлементыФормы,СтруктураСвязиЭлементовСДанными,мТаблицаФильтры);
	УстановитьВидимостьПанелейБыстрогоОтбора(ЭлементыФормы,СтруктураСвязиЭлементовСДанными);
	
	Заголовок = СформироватьЗаголовокОкна();
	мНазваниеОтчета = Заголовок;
	СформироватьЗаголовокФормы();

КонецПроцедуры // ПередОткрытием()

// Процедура - обработчик события "При открытии" формы отчета.
//
Процедура ПриОткрытии()

	Если КлючУникальности = Неопределено Тогда
		мПоказыватьЗаголовок = Истина;
		мВысотаЗаголовка = 0;
		ОбработатьКнопкуЗаголовок(ЭлементыФормы.КоманднаяПанельФормы, мПоказыватьЗаголовок);
	Иначе
		мПоказыватьЗаголовок = ЭлементыФормы.КоманднаяПанельФормы.Кнопки.Заголовок.Пометка;
		мВысотаЗаголовка = СформироватьЗаголовокОтчета(ЭтотОбъект).ВысотаТаблицы;
	КонецЕсли;
	Если НЕ ЗначениеЗаполнено(ДатаАктуальности) Тогда
		ДатаАктуальности = ОбщегоНазначения.ПолучитьРабочуюДату();
	КонецЕсли;
	Если ВыбТипДиаграммы = Неопределено Тогда
		ВыбТипДиаграммы = ТипДиаграммы.Изометрическая;
	КонецЕсли;
	ЭлементыФормы.Диаграмма.ТипДиаграммы = ВыбТипДиаграммы;
	ВариантОтображения = ?(ВариантОтображения.Пустая(), Перечисления.ВариантыОтображенияОтчетов.Таблица, ВариантОтображения);
	УправлениеОтчетами.ПометитьКнопкиОтображения(ЭтотОбъект, ЭтаФорма);
	
	// выставляем заголовок
	ВыводЗаголовка();
	
	ВидСравнения1 = ВидСравнения.Равно;
	ВидСравнения2 = ВидСравнения.Равно;
	ЗаполнитьБыстрыйОтборПоОбъекту(ЭлементыФормы,ЭтотОбъект,СтруктураСвязиЭлементовСДанными);

КонецПроцедуры // ПриОткрытии()

////////////////////////////////////////////////////////////////////////////////
// ПРОЦЕДУРЫ - ДЕЙСТВИЯ КОМАНДНЫХ ПАНЕЛЕЙ ФОРМЫ

// Процедура - обработчик нажатия кнопки "Сформировать"
Процедура КоманднаяПанельФормыВыполнить(Элемент)
	
	ОбновитьОтчет(ЭтотОбъект, ЭтаФорма,, ВариантОтображения);

КонецПроцедуры

// Процедура - обработчик нажатия кнопки "Отбор"
Процедура КоманднаяПанельФормыОтбор(Кнопка)
	
	ЭлементыФормы.КоманднаяПанельФормы.Кнопки.Отбор.Пометка = НЕ ЭлементыФормы.КоманднаяПанельФормы.Кнопки.Отбор.Пометка;
	ЭлементыФормы.КоманднаяПанельФормы.Кнопки.Подменю.Кнопки.Отбор.Пометка = НЕ ЭлементыФормы.КоманднаяПанельФормы.Кнопки.Подменю.Кнопки.Отбор.Пометка;
	
	УстановитьВидимостьПанелейБыстрогоОтбора(ЭлементыФормы,СтруктураСвязиЭлементовСДанными);

КонецПроцедуры

// Процедура - обработчик нажатия кнопки "Настройка"
Процедура КоманднаяПанельФормыНастройка(Кнопка)

	ФормаНастройки = ПолучитьФорму("ФормаНастройкиОтчета", ЭтаФорма);
	ДействияПриИзмененииНастройки(ЭтотОбъект, ЭтаФорма, ФормаНастройки);
	Заголовок = СформироватьЗаголовокОкна();
	СформироватьЗаголовокФормы();

КонецПроцедуры

// Процедура - обработчик нажатия кнопки "Заголовок"
Процедура КоманднаяПанельФормыЗаголовок(Кнопка)

	мПоказыватьЗаголовок = Не мПоказыватьЗаголовок;
	ВыводЗаголовка();

КонецПроцедуры

// Процедура - обработчик нажатия кнопки "Таблица"
//
Процедура КоманднаяПанельФормыОтображениеТаблица(Кнопка)
	
	ВариантОтображения = Перечисления.ВариантыОтображенияОтчетов.Таблица;
	УправлениеОтчетами.ПометитьКнопкиОтображения(ЭтотОбъект, ЭтаФорма);
	ОбновитьОтчет(ЭтотОбъект, ЭтаФорма,, ВариантОтображения);
	
КонецПроцедуры // КоманднаяПанельФормыОтображениеТаблица()

// Процедура - обработчик нажатия кнопки "Диаграмма"
//
Процедура КоманднаяПанельФормыОтображениеДиаграмма(Кнопка)

	ВариантОтображения = Перечисления.ВариантыОтображенияОтчетов.Диаграмма;
	УправлениеОтчетами.ПометитьКнопкиОтображения(ЭтотОбъект, ЭтаФорма);
	ОбновитьОтчет(ЭтотОбъект, ЭтаФорма,, ВариантОтображения);
	
КонецПроцедуры // КоманднаяПанельФормыОтображениеДиаграмма()

// Процедура - обработчик нажатия кнопки "Сводная таблица"
//
Процедура КоманднаяПанельФормыОтображениеСводнаяТаблица(Кнопка)

	ВариантОтображения = Перечисления.ВариантыОтображенияОтчетов.СводнаяТаблица;
	УправлениеОтчетами.ПометитьКнопкиОтображения(ЭтотОбъект, ЭтаФорма);
	ОбновитьОтчет(ЭтотОбъект, ЭтаФорма,, ВариантОтображения);
	
КонецПроцедуры // КоманднаяПанельФормыОтображениеСводнаяТаблица()

// Процедура - обработчик нажатия кнопки "На принтер"
Процедура ДействияФормыНаПринтер(Кнопка)
	
	ЭлементыФормы.ДокументРезультат.Напечатать();

КонецПроцедуры

// Обработчик события элемента КоманднаяПанельФормы.НовыйОтчет.
//
Процедура КоманднаяПанельФормыНовыйОтчет(Кнопка)
	
	Если Строка(ЭтотОбъект) = "ВнешняяОбработкаОбъект." + ЭтотОбъект.Метаданные().Имя Тогда
			
		Предупреждение(НСтр("ru='Данный отчет является внешней обработкой.';uk='Даний звіт є зовнішньою обробкою.'") + Символы.ПС + НСтр("ru='Открытие нового отчета возможно только для объектов конфигурации.';uk=""Відкриття нового звіту можливо тільки для об'єктів конфігурації."""));
		Возврат;
			
	Иначе
			
		НовыйОтчет = Отчеты[ЭтотОбъект.Метаданные().Имя].Создать();
			
	КонецЕсли;
	
	ФормаНовогоОтчета = НовыйОтчет.ПолучитьФорму();
	ФормаНовогоОтчета.Открыть();

КонецПроцедуры // КоманднаяПанельФормыДействиеНовыйОтчет()

////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ ЭЛЕМЕНТОВ ДИАЛОГА

// Процедура - обработчик нажатия кнопки печати диаграммы.
Процедура КнопкаПечатьНажатие(Элемент)

	ПечатьДиаграммы(ЭтаФорма);
	
КонецПроцедуры

// изменяем тип диаграммы и параметры диаграммы
Процедура ВыбТипДиаграммыПриИзменении(Элемент)
	ЭлементыФормы.Диаграмма.ТипДиаграммы = ВыбТипДиаграммы;
    УстановитьДополнительноеОформлениеДиаграммы(ЭлементыФормы.Диаграмма, ВыбТипДиаграммы);
КонецПроцедуры

Процедура ПолеМаксимумСерийПриИзменении(Элемент)
	ЭлементыФормы.Диаграмма.МаксимумСерийКоличество=Элемент.Значение;
КонецПроцедуры

Процедура ПолеМаксимумСерийРегулирование(Элемент, Направление, СтандартнаяОбработка)
	ЭлементыФормы.Диаграмма.МаксимумСерийКоличество=Элемент.Значение;
КонецПроцедуры

// раскрашиваем строку легенды диаграммы
Процедура ТаблицаЛегендыПриВыводеСтроки(Элемент, ОформлениеСтроки, ДанныеСтроки)
    ОформлениеСтроки.Ячейки.Цвет.ЦветФона=ДанныеСтроки.ЦветСерии;
КонецПроцедуры

// Процедура - обработчик изменения данных в поле значения отбора
//
Процедура ОбработатьИзменениеЗначения(Элемент)
	
	ДействияПриИзмененииЗначенияОтбора(Элемент, ЭтотОбъект, ЭтаФорма)
	
КонецПроцедуры // ПолеНастройки1ПриИзменении()

// Процедура - обработчик изменения данных в поле выбора вида сравнения
//
Процедура ВидСравненияПриИзменении(Элемент)

	// Управление полями настройки в зависимости от вида сравнения
	ДействияПриИзмененииВидаСравнения(Элемент, ЭтотОбъект, ЭтаФорма)

КонецПроцедуры // ПолеВидаСравнения1ПриИзменении()

// Процедура - обработчик изменения данных флажка использования отбора
//
Процедура ФлажокНастройкиПриИзменении(Элемент)
	
	ИмяОтбора = "";
	НомерПоля = Прав(Элемент.Имя,1);
	ИмяПоля = "ПолеНастройки" + НомерПоля;
	
	Если СтруктураСвязиЭлементовСДанными.Свойство(ИмяПоля,ИмяОтбора) Тогда
		ОбновитьЗначенияОтбораВОтчете(ИмяОтбора,Элемент.Значение,ЭтаФорма["ВидСравнения" + НомерПоля],ЭтаФорма[ИмяПоля],ОтборыОтчета,мТаблицаФильтры.Найти(ИмяОтбора,"ИмяПоля"));
	КонецЕсли;

КонецПроцедуры

// Процедура - обработчик события "ПриИзменении" поля ввода "ДатаАктуальности".
//
Процедура ПолеВводаДатаАктуальностиПриИзменении(Элемент)
	
	СформироватьЗаголовокФормы();
	
КонецПроцедуры


////////////////////////////////////////////////////////////////////////////////
// ОПЕРАТОРЫ ОСНОВНОЙ ПРОГРАММЫ

// Для диаграмммы
ТаблицаЛегенды.Колонки.Добавить("ЦветСерии");
ТаблицаЛегенды.Колонки.Добавить("ИндексСерии");

СписокТиповДиаграммы = Новый СписокЗначений;
СписокТиповДиаграммы.Добавить(ТипДиаграммы.Круговая, "Круговая");
СписокТиповДиаграммы.Добавить(ТипДиаграммы.КруговаяОбъемная, "Круговая объемная");
СписокТиповДиаграммы.Добавить(ТипДиаграммы.ГистограммаСНакоплением, "Гистограмма с накоплением");
СписокТиповДиаграммы.Добавить(ТипДиаграммы.ГистограммаСНакоплениемОбъемная, "Гистограмма с накоплением объемная");
СписокТиповДиаграммы.Добавить(ТипДиаграммы.График, "График");
СписокТиповДиаграммы.Добавить(ТипДиаграммы.ГрафикПоШагам, "График по шагам");
СписокТиповДиаграммы.Добавить(ТипДиаграммы.ГрафикСОбластями, "График с областями");
СписокТиповДиаграммы.Добавить(ТипДиаграммы.ГрафикСОбластямиИНакоплением, "График с областями и накоплением");
СписокТиповДиаграммы.Добавить(ТипДиаграммы.Гистограмма, "Гистограмма");
СписокТиповДиаграммы.Добавить(ТипДиаграммы.ГистограммаОбъемная, "Гистограмма 3D");
СписокТиповДиаграммы.Добавить(ТипДиаграммы.ГистограммаГоризонтальная, "Гистограмма горизонтальная");
СписокТиповДиаграммы.Добавить(ТипДиаграммы.ГистограммаГоризонтальнаяОбъемная, "Гистограмма горизонтальная 3D");
СписокТиповДиаграммы.Добавить(ТипДиаграммы.Изометрическая, "Изометрическая");
СписокТиповДиаграммы.Добавить(ТипДиаграммы.ИзометрическаяНепрерывная, "Изометрическая непрерывная");
СписокТиповДиаграммы.Добавить(ТипДиаграммы.ИзометрическаяЛента, "Изометрическая лента");
СписокТиповДиаграммы.Добавить(ТипДиаграммы.ИзометрическаяПирамида, "Изометрическая пирамида");
ЭлементыФормы.ВыбТипДиаграммы.СписокВыбора = СписокТиповДиаграммы;

