////////////////////////////////////////////////////////////////////////////////
// ПЕРЕМЕННЫЕ МОДУЛЯ

Перем мМножественныйВыбор;
Перем мИсходнаяТаблица;
Перем мОписаниеТиповСтрока;
Перем мОписаниеТиповБулево;

////////////////////////////////////////////////////////////////////////////////
// ПРОЦЕДУРЫ И ФУНКЦИИ ОБЩЕГО НАЗНАЧЕНИЯ

// Процедура передает сделанные настройки в главную форму отчета.
Процедура Выбрать()

	Если мИсходнаяТаблица="СписокГруппировок"  тогда

		ВыбранныеСтроки = Новый ТаблицаЗначений;
		ВыбранныеСтроки.Колонки.Добавить("ИмяГруппировки", 		мОписаниеТиповСтрока);
		ВыбранныеСтроки.Колонки.Добавить("ОписаниеГруппировки", мОписаниеТиповСтрока);
		ВыбранныеСтроки.Колонки.Добавить("ПредставлениеГруппировки", мОписаниеТиповСтрока);

		Если мМножественныйВыбор Тогда
			Для Каждого СтрТабличноеПоле Из ТабличноеПоле Цикл
				Если СтрТабличноеПоле.Пометка Тогда

					НоваяСтрока = ВыбранныеСтроки.Добавить();
					НоваяСтрока.ИмяГруппировки           = СтрТабличноеПоле.ИмяПоля;
					НоваяСтрока.ПредставлениеГруппировки = СтрТабличноеПоле.ПредставлениеПоля;
					НоваяСтрока.ОписаниеГруппировки      = СтрТабличноеПоле.ОписаниеПоля;

				КонецЕсли;

			КонецЦикла;

		Иначе

			Если ЭлементыФормы.ТабличноеПоле.ТекущаяСтрока <> Неопределено Тогда
				СтрТабличноеПоле = ЭлементыФормы.ТабличноеПоле.ТекущиеДанные;

				НоваяСтрока = ВыбранныеСтроки.Добавить();
				НоваяСтрока.ИмяГруппировки           = СтрТабличноеПоле.ИмяПоля;
				НоваяСтрока.ПредставлениеГруппировки = СтрТабличноеПоле.ПредставлениеПоля;
				НоваяСтрока.ОписаниеГруппировки      = СтрТабличноеПоле.ОписаниеПоля;
			КонецЕсли;

		КонецЕсли;

	ИначеЕсли мИсходнаяТаблица="СписокГруппировокСписок" тогда

		ВыбранныеСтроки = Новый ТаблицаЗначений;
		ВыбранныеСтроки.Колонки.Добавить("ИмяГруппировки", 		мОписаниеТиповСтрока);
		ВыбранныеСтроки.Колонки.Добавить("ОписаниеГруппировки", мОписаниеТиповСтрока);
		ВыбранныеСтроки.Колонки.Добавить("ПредставлениеГруппировки", мОписаниеТиповСтрока);
        ВыбранныеСтроки.Колонки.Добавить("Пометка");


		Для Каждого СтрТабличноеПоле Из ТабличноеПоле Цикл
			НоваяСтрока = ВыбранныеСтроки.Добавить();
			НоваяСтрока.ИмяГруппировки           = СтрТабличноеПоле.ИмяПоля;
			НоваяСтрока.ПредставлениеГруппировки = СтрТабличноеПоле.ПредставлениеПоля;
			НоваяСтрока.ОписаниеГруппировки      = СтрТабличноеПоле.ОписаниеПоля;
			НоваяСтрока.Пометка=СтрТабличноеПоле.Пометка;
		КонецЦикла;

	ИначеЕсли мИсходнаяТаблица="СписокПоказатели" Тогда

		ВыбранныеСтроки = Новый ТаблицаЗначений;
		ВыбранныеСтроки.Колонки.Добавить("ИмяПоказателя", 		мОписаниеТиповСтрока);
		ВыбранныеСтроки.Колонки.Добавить("ОписаниеПоказателя", мОписаниеТиповСтрока);
		ВыбранныеСтроки.Колонки.Добавить("ПредставлениеПоказателя", мОписаниеТиповСтрока);
		ВыбранныеСтроки.Колонки.Добавить("ИтоговоеПоле", мОписаниеТиповБулево);

		Если ЭлементыФормы.ТабличноеПоле.ТекущаяСтрока <> Неопределено Тогда

			СтрТабличноеПоле = ЭлементыФормы.ТабличноеПоле.ТекущиеДанные;

			НоваяСтрока = ВыбранныеСтроки.Добавить();
			НоваяСтрока.ИмяПоказателя           	= СтрТабличноеПоле.ИмяПоля;
			НоваяСтрока.ПредставлениеПоказателя  	= СтрТабличноеПоле.ПредставлениеПоля;
			НоваяСтрока.ОписаниеПоказателя      	= СтрТабличноеПоле.ОписаниеПоля;
 			НоваяСтрока.ИтоговоеПоле		      	= СтрТабличноеПоле.ИтоговоеПоле;

		КонецЕсли;

	ИначеЕсли мИсходнаяТаблица="СписокПоказателиСписок" Тогда

		ВыбранныеСтроки = Новый ТаблицаЗначений;
		ВыбранныеСтроки.Колонки.Добавить("ИмяПоказателя", 		мОписаниеТиповСтрока);
		ВыбранныеСтроки.Колонки.Добавить("ОписаниеПоказателя", мОписаниеТиповСтрока);
		ВыбранныеСтроки.Колонки.Добавить("ПредставлениеПоказателя", мОписаниеТиповСтрока);
		ВыбранныеСтроки.Колонки.Добавить("ИтоговоеПоле", мОписаниеТиповБулево);
        ВыбранныеСтроки.Колонки.Добавить("Пометка");


		Для Каждого СтрТабличноеПоле Из ТабличноеПоле Цикл
			НоваяСтрока = ВыбранныеСтроки.Добавить();
			НоваяСтрока.ИмяПоказателя           	= СтрТабличноеПоле.ИмяПоля;
			НоваяСтрока.ПредставлениеПоказателя  	= СтрТабличноеПоле.ПредставлениеПоля;
			НоваяСтрока.ОписаниеПоказателя      	= СтрТабличноеПоле.ОписаниеПоля;
			НоваяСтрока.Пометка						= СтрТабличноеПоле.Пометка;
 			НоваяСтрока.ИтоговоеПоле		      	= СтрТабличноеПоле.ИтоговоеПоле;
		КонецЦикла;

	Иначе
	
		ВыбранныеСтроки = Новый ТаблицаЗначений;
		ВыбранныеСтроки.Колонки.Добавить("ИмяОтбора", 		мОписаниеТиповСтрока);
		ВыбранныеСтроки.Колонки.Добавить("ОписаниеФильтра", мОписаниеТиповСтрока);
		ВыбранныеСтроки.Колонки.Добавить("ПредставлениеОтбора", мОписаниеТиповСтрока);
		ВыбранныеСтроки.Колонки.Добавить("ОписаниеТипов");

		Если ЭлементыФормы.ТабличноеПоле.ТекущаяСтрока <> Неопределено Тогда
			СтрТабличноеПоле = ЭлементыФормы.ТабличноеПоле.ТекущиеДанные;

			НоваяСтрока = ВыбранныеСтроки.Добавить();
			НоваяСтрока.ИмяОтбора           	= СтрТабличноеПоле.ИмяПоля;
			НоваяСтрока.ПредставлениеОтбора  	= СтрТабличноеПоле.ПредставлениеПоля;
			НоваяСтрока.ОписаниеФильтра       	= СтрТабличноеПоле.ОписаниеПоля;
            НоваяСтрока.ОписаниеТипов           = СтрТабличноеПоле.ОписаниеТипов;
			
		КонецЕсли;

	КонецЕсли;

	ОповеститьОВыборе(ВыбранныеСтроки);

КонецПроцедуры // Выбрать()

////////////////////////////////////////////////////////////////////////////////
// ПРОЦЕДУРЫ - ОБРАБОТЧИКИ ДЕЙСТВИЙ ПОЛЬЗОВАТЕЛЯ

// Процедура - обработчик нажатия кнопки "ОК".
Процедура КнопкаВыбратьНажатие(Элемент)

    Выбрать();
	
КонецПроцедуры // КнопкаВыбратьНажатие()

// Процедура устанавливает пометку у всех строк таблицы.
Процедура УстановитьВсеНажатие(Элемент)

	ТабличноеПоле.ЗаполнитьЗначения(Истина,"Пометка");

КонецПроцедуры // УстановитьВсеНажатие()

// Процедура снимает пометку у всех строк таблицы.
Процедура СнятьВсеНажатие(Элемент)

	ТабличноеПоле.ЗаполнитьЗначения(Ложь,"Пометка");

КонецПроцедуры // СнятьВсеНажатие()

////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ ЭЛЕМЕНТОВ ДИАЛОГА

// Процедура - обработчик попытки удаления строки из таблицы.
Процедура ТабличноеПолеПередУдалением(Элемент, Отказ)

	Отказ = Истина;
	
КонецПроцедуры // ТабличноеПолеПередУдалением()

// Процедура - обработчик выбора строки таблицы.
Процедура ТабличноеПолеВыбор(Элемент, ВыбраннаяСтрока, Колонка, СтандартнаяОбработка)

	Если Не мМножественныйВыбор Тогда
		Выбрать();
	КонецЕсли;
	
КонецПроцедуры // ТабличноеПолеВыбор()

// Процедура - обработчик попытки добавления строки в таблицу.
Процедура ТабличноеПолеПередНачаломДобавления(Элемент, Отказ, Копирование)

	Отказ = Истина;
	
КонецПроцедуры // ТабличноеПолеПередНачаломДобавления()

////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ ФОРМЫ

// Процедура - обработчик события "ПриОткрытии" формы
//
Процедура ПриОткрытии()

	СтруктураПараметров = НачальноеЗначениеВыбора;

	мМножественныйВыбор = Истина;
	мИсходнаяТаблица="";
	СтруктураСуществующиеЗначения = Новый Структура;
	СтруктураНеиспользуемыеЗначения = Новый Структура;
	Если ТипЗнч(СтруктураПараметров) = Тип("Структура") Тогда
		СтруктураПараметров.Свойство("МножественныйВыбор", мМножественныйВыбор);
		СтруктураПараметров.Свойство("СтруктураСуществующиеЗначения", СтруктураСуществующиеЗначения);
		СтруктураПараметров.Свойство("СтруктураНеиспользуемыеЗначения", СтруктураНеиспользуемыеЗначения);
		СтруктураПараметров.Свойство("ИсходнаяТаблица", мИсходнаяТаблица);
	КонецЕсли;

	ТаблицаИспользуемыеГруппировки = ТаблицаГруппировки.Скопировать();
	ТаблицаИспользуемыеУсловия     = ТаблицаФильтры.Скопировать();
	ТаблицаИспользуемыеПоказатели  = ТаблицаПоказатели.Скопировать();

	Если мИсходнаяТаблица="СписокГруппировок" тогда

		Заголовок="Группировки отчета";

		Сч = 0;
		Пока Сч < ТаблицаИспользуемыеГруппировки.Количество() Цикл
			Строка = ТаблицаИспользуемыеГруппировки[Сч];
			Если СтруктураНеиспользуемыеЗначения.Свойство(Строка.ИмяПоля) Тогда
				ТаблицаИспользуемыеГруппировки.Удалить(Строка);
			Иначе
				Сч = Сч + 1;
			КонецЕсли;
		КонецЦикла;

		ЭлементыФормы.ТабличноеПоле.Значение = ТаблицаИспользуемыеГруппировки;

		Если мМножественныйВыбор Тогда
            Заголовок="Дополнительные поля отчета";
			
			ЭлементыФормы.ТабличноеПоле.Колонки["ПредставлениеПоля"].ДанныеФлажка = "Пометка";
			ЭлементыФормы.ТабличноеПоле.ТолькоПросмотр=Ложь;
			ЭлементыФормы.УстановитьВсе.Видимость=Истина;
			ЭлементыФормы.СнятьВсе.Видимость	 =Истина;
		Иначе
			ЭлементыФормы.ТабличноеПоле.Колонки["ПредставлениеПоля"].ДанныеФлажка = "";
		КонецЕсли;

		// Расставим пометки
		Если мМножественныйВыбор Тогда
			Для Каждого Строка Из ТабличноеПоле Цикл
				Если СтруктураСуществующиеЗначения.Свойство(Строка.ИмяПоля) Тогда
					Строка.Пометка = Истина;
				Иначе
					Строка.Пометка = Ложь;
				КонецЕсли;
			КонецЦикла;
		Иначе
			// в немножественном выборе передается один текущий элемент
			Для Каждого Элемент Из СтруктураСуществующиеЗначения Цикл
				Нстр = ЭлементыФормы.ТабличноеПоле.Значение.Найти(Элемент.Ключ);
				Если НСтр <> Неопределено Тогда
					ЭлементыФормы.ТабличноеПоле.ТекущаяСтрока = Нстр;
				КонецЕсли; 
				Прервать;
			КонецЦикла;
		КонецЕсли;

    ИначеЕсли мИсходнаяТаблица="СписокГруппировокСписок" тогда

		Заголовок="Группировки отчета";

		СтруктураДополнительныеЗначения = Новый Структура;
		Если ТипЗнч(СтруктураПараметров) = Тип("Структура") Тогда
			СтруктураПараметров.Свойство("СтруктураДополнительныеЗначения", СтруктураДополнительныеЗначения);
		КонецЕсли;

		ЭлементыФормы.ТабличноеПоле.Колонки["ПредставлениеПоля"].ДанныеФлажка = "Пометка";
		ЭлементыФормы.ТабличноеПоле.ТолькоПросмотр=Ложь;
		ЭлементыФормы.УстановитьВсе.Видимость=Истина;
		ЭлементыФормы.СнятьВсе.Видимость	 =Истина;

        // Удаляем группировки, использованные в дополнительных полях. Действия над ними выполняются
		// только вместе с основным полем.

		Сч = 0;
		Пока Сч < ТаблицаИспользуемыеГруппировки.Количество() Цикл
			Строка = ТаблицаИспользуемыеГруппировки[Сч];
			Если СтруктураДополнительныеЗначения.Свойство(Строка.ИмяПоля) Тогда
				ТаблицаИспользуемыеГруппировки.Удалить(Строка);
			Иначе
				Сч = Сч + 1;
			КонецЕсли;
		КонецЦикла;

		ЭлементыФормы.ТабличноеПоле.Значение = ТаблицаИспользуемыеГруппировки;

		// Расставим пометки
		Для Каждого Строка Из ТабличноеПоле Цикл
			Если СтруктураНеиспользуемыеЗначения.Свойство(Строка.ИмяПоля) Тогда
				Строка.Пометка = Истина;
			Иначе
				Строка.Пометка = Ложь;
			КонецЕсли;
		КонецЦикла;

    ИначеЕсли мИсходнаяТаблица="СписокПоказатели" тогда

    Заголовок="Показатели отчета";
		
		Сч = 0;
		Пока Сч < ТаблицаИспользуемыеПоказатели.Количество() Цикл
			Строка = ТаблицаИспользуемыеПоказатели[Сч];
			Если СтруктураНеиспользуемыеЗначения.Свойство(Строка.ИмяПоля) Тогда
				ТаблицаИспользуемыеПоказатели.Удалить(Строка);
			Иначе
				Сч = Сч + 1;
			КонецЕсли;
		КонецЦикла;

		ЭлементыФормы.ТабличноеПоле.Значение = ТаблицаИспользуемыеПоказатели;

	ИначеЕсли мИсходнаяТаблица="СписокПоказателиСписок" тогда

		Заголовок="Показатели отчета";

		ЭлементыФормы.ТабличноеПоле.Колонки["ПредставлениеПоля"].ДанныеФлажка = "Пометка";
		ЭлементыФормы.ТабличноеПоле.ТолькоПросмотр=Ложь;
		ЭлементыФормы.УстановитьВсе.Видимость=Истина;
		ЭлементыФормы.СнятьВсе.Видимость	 =Истина;

        
		ЭлементыФормы.ТабличноеПоле.Значение = ТаблицаИспользуемыеПоказатели;

		// Расставим пометки
		Для Каждого Строка Из ТабличноеПоле Цикл
			Если СтруктураНеиспользуемыеЗначения.Свойство(Строка.ИмяПоля) Тогда
				Строка.Пометка = Истина;
			Иначе
				Строка.Пометка = Ложь;
			КонецЕсли;
		КонецЦикла;

	Иначе

        Заголовок="Отбор данных";
		
		Сч = 0;
		Пока Сч < ТаблицаИспользуемыеУсловия.Количество() Цикл
			Строка = ТаблицаИспользуемыеУсловия[Сч];
			Если СтруктураНеиспользуемыеЗначения.Свойство(Строка.ИмяПоля) Тогда
				ТаблицаИспользуемыеУсловия.Удалить(Строка);
			Иначе
				Сч = Сч + 1;
			КонецЕсли;
		КонецЦикла;

		ЭлементыФормы.ТабличноеПоле.Значение = ТаблицаИспользуемыеУсловия;

	КонецЕсли;

КонецПроцедуры // ПриОткрытии()

////////////////////////////////////////////////////////////////////////////////
// ОПЕРАТОРЫ ОСНОВНОЙ ПРОГРАММЫ

мОписаниеТиповСтрока = ОбщегоНазначения.ПолучитьОписаниеТиповСтроки(500);
МассивБулево = Новый Массив;
МассивБулево.Добавить(Тип("Булево"));
мОписаниеТиповБулево = Новый ОписаниеТипов(МассивБулево);
