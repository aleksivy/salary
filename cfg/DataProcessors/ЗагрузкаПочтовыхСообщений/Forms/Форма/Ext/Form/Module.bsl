﻿
Процедура ОткрытьФормуПисьма()

	Если ЭлементыФормы.ЭлектронныеПисьма.ТекущиеДанные <> Неопределено Тогда
		
		ДокументПисьмо = ПолучитьДокументОбъект(ЭлементыФормы.ЭлектронныеПисьма.ТекущиеДанные);
		ДокументПисьмо.мРежимБезЗаписи = Истина;
		
		Если ТипЗнч(ДокументПисьмо) <> Тип("ДокументОбъект.ЭлектронноеПисьмо") Тогда
			Возврат;
		КонецЕсли;
		
		ФормаПисьма = ДокументПисьмо.ПолучитьФорму();
		
		Для каждого Вложение Из ЭлементыФормы.ЭлектронныеПисьма.ТекущиеДанные.ПочтовоеСообщение.Вложения Цикл
		
			Если Вложение.Данные = Неопределено Тогда
				Продолжить;
			КонецЕсли;
			
			НоваяСтрока = ФормаПисьма.ВложенияПисьмаТЗ.Добавить();
			НоваяСтрока.ИмяФайла = ПолучитьПреобразованноеИмяФайла(Вложение.Наименование);
			НоваяСтрока.Данные = Новый ХранилищеЗначения(Вложение.Данные, Новый СжатиеДанных());
		
		КонецЦикла;
		
		СписокВыбора = Новый СписокЗначений;
		СписокВыбора.Добавить(УчетнаяЗапись, УчетнаяЗапись);
		ФормаПисьма.ЭлементыФормы.УчетнаяЗапись.СписокВыбора = СписокВыбора;
		
		ФормаПисьма.Открыть();
	
	КонецЕсли; 
	
КонецПроцедуры

Функция ПолучитьПреобразованноеИмяФайла(Знач НаименованиеФайла)

	Если СтрЧислоВхождений(НаименованиеФайла, "\") > 0 Тогда
		
		ПоследняяПозиция = 0;
		Пока СтрЧислоВхождений(НаименованиеФайла, "\") > 0 Цикл
			Позиция = Найти(НаименованиеФайла, "\");
			НаименованиеФайла = Сред(НаименованиеФайла, 1, (Позиция - 1)) + "&" + Сред(НаименованиеФайла, (Позиция + 1));
			ПоследняяПозиция = Позиция;
		КонецЦикла;
		
		Если ПоследняяПозиция > 0 Тогда
			Возврат Сред(НаименованиеФайла, (ПоследняяПозиция + 1));
		КонецЕсли; 
		
	Иначе
		
		Возврат НаименованиеФайла;
		
	КонецЕсли; 

КонецФункции // ()

Процедура КнопкаВыполнитьНажатие(Элемент)
	
	Если НЕ ЗначениеЗаполнено(УчетнаяЗапись) Тогда
		Предупреждение(НСтр("ru='Не указана учетная запись!';uk='Не зазначений обліковий запис!'"));
		Возврат;
	КонецЕсли;
	
	ОтветНаВопрос = Вопрос(НСтр("ru='Зарегистрировать выбранные сообщения?';uk='Зареєструвати обрані повідомлення?'"), РежимДиалогаВопрос.ОКОтмена);
	Если ОтветНаВопрос <> КодВозвратаДиалога.ОК Тогда
		Возврат;
	КонецЕсли; 
	
	ФиксироватьТранзакцию = Истина;
	
	ФормаПрогрессора = ПолучитьОбщуюФорму("ХодВыполненияОбработкиДанных");
	ФормаПрогрессора.НаименованиеОбработкиДанных  = "Загрузка электронных писем из внешнего почтового клиента";
	ФормаПрогрессора.КомментарийЗначения = "Регистрируются почтовые сообщения ...";
	ФормаПрогрессора.Значение = 0;
	ФормаПрогрессора.МаксимальноеЗначение = ЭлектронныеПисьма.Количество();
	ФормаПрогрессора.Открыть();
	
	НачатьТранзакцию();
	
	Для каждого СтрокаТЗ Из ЭлектронныеПисьма Цикл
	
		ФормаПрогрессора.Значение = ФормаПрогрессора.Значение + 1;
		
		Если НЕ СтрокаТЗ.Использование Тогда
			Продолжить;
		КонецЕсли;
		
		ДокументПисьмо = ПолучитьДокументОбъект(СтрокаТЗ);
		
		Попытка
			ДокументПисьмо.Записать();
		Исключение
			ОбщегоНазначения.СообщитьОбОшибке(ОписаниеОшибки(),, (НСтр("ru='Не записано электронное письмо, строка ';uk='Не записаний електронний лист, рядок '") + ФормаПрогрессора.Значение + "!"));
			ФиксироватьТранзакцию = Ложь;
			Прервать;
		КонецПопытки;
		
		Для каждого Вложение Из СтрокаТЗ.ПочтовоеСообщение.Вложения Цикл
		
			Если Вложение.Данные = Неопределено Тогда
				Продолжить;
			КонецЕсли;
			
			НовоеВложение = Справочники.ВложенияЭлектронныхПисем.СоздатьЭлемент();
			НовоеВложение.ИмяФайла  = ПолучитьПреобразованноеИмяФайла(Вложение.Наименование);
			НовоеВложение.Объект    = ДокументПисьмо.Ссылка;
			НовоеВложение.Хранилище = Новый ХранилищеЗначения(Вложение.Данные, Новый СжатиеДанных());
			Попытка
				НовоеВложение.Записать();
			Исключение
				ФиксироватьТранзакцию = Ложь;
				ОбщегоНазначения.СообщитьОбОшибке(ОписаниеОшибки(),, (НСтр("ru='Не записаны вложения электронного письма, строка ';uk='Не записані вкладення електронного листа, рядок '") + ФормаПрогрессора.Значение + "!"));
				Прервать;
			КонецПопытки;
			
		КонецЦикла;
		
	КонецЦикла;
	
	ФормаПрогрессора.Закрыть();
	
	Если ФиксироватьТранзакцию Тогда
		ЗафиксироватьТранзакцию();
		Предупреждение(НСтр("ru='Регистрация электронных писем выполнена успешно!';uk='Реєстрація електронних листів виконана успішно!'"));
	Иначе
		ОтменитьТранзакцию();
		Предупреждение(НСтр("ru='Регистрация электронных писем отменена!';uk='Реєстрація електронних листів скасована!'"));
	КонецЕсли;
	
КонецПроцедуры

Процедура КоманднаяПанельЭлектронныеПисьмаОбновить(Кнопка)
	
	Если НЕ ЗначениеЗаполнено(УчетнаяЗапись) Тогда
		Предупреждение(НСтр("ru='Не указана учетная запись!';uk='Не зазначений обліковий запис!'"));
		Возврат;
	КонецЕсли;
	
	Если ЭлектронныеПисьма.Количество() > 0 Тогда
		ОтветНаВопрос = Вопрос(НСтр("ru='Заполнить таблицу электронными письмами из основного почтового клиента операционной системы?';uk='Заповнити таблицю електронними листами з основного поштового клієнта операційної системи?'"), РежимДиалогаВопрос.ОКОтмена);
		Если ОтветНаВопрос <> КодВозвратаДиалога.ОК  Тогда
			Возврат;
		Иначе
			ЭлектронныеПисьма.Очистить();
		КонецЕсли; 
	КонецЕсли;
	
	Почта = Новый Почта;
	Попытка
		Почта.Подключиться();
	Исключение
		ОбщегоНазначения.СообщитьОбОшибке(ОписаниеОшибки(),, НСтр("ru='Не удалось установить подключение к основной почтовой программе операционной системы.';uk='Не вдалося встановити підключення до основної поштової програми операційної системи.'"));
		Возврат;
	КонецПопытки;
	
	Состояние(НСтр("ru='Выбираются письма из локальной почтовой программы ...';uk='Вибираються листи з локальної поштової програми ...'"));
	
	Попытка
		МассивПисем = Почта.Выбрать(Ложь, Ложь);
	Исключение
		ОбщегоНазначения.СообщитьОбОшибке(НСтр("ru='Не удалось получить почту по причине: ';uk='Не вдалося отримати пошту з причини: '") + ОписаниеОшибки());
		Возврат;
	КонецПопытки;
	
	Если ТипЗнч(МассивПисем) <> Тип("Массив") Тогда
		ОбщегоНазначения.СообщитьОбОшибке(НСтр("ru='Не удалось получить почту. Проверьте настройки программы почтового клиента.';uk='Не вдалося отримати пошту. Перевірте настройки програми поштового клієнта.'"));
		Возврат;
	КонецЕсли; 
	
	ФормаПрогрессора = ПолучитьОбщуюФорму("ХодВыполненияОбработкиДанных");
	ФормаПрогрессора.НаименованиеОбработкиДанных  = "Загрузка электронных писем из внешнего почтового клиента";
	ФормаПрогрессора.Открыть();
	
	ФормаПрогрессора.КомментарийЗначения = "Заполняется таблица писем ...";
	ФормаПрогрессора.Значение = 0;
	ФормаПрогрессора.МаксимальноеЗначение = МассивПисем.Количество();
	
	ЭталонТаблицаПоиска = Новый ТаблицаЗначений;
	ЭталонТаблицаПоиска.Колонки.Добавить("ПредставлениеОбъекта", Новый ОписаниеТипов("Строка"));
	ЭталонТаблицаПоиска.Колонки.Добавить("АдресЭлектроннойПочты", Новый ОписаниеТипов("Строка"));
	
	ЭталонТаблицаКомуТЧ = Новый ТаблицаЗначений;
	ЭталонТаблицаКомуТЧ.Колонки.Добавить("Представление", Новый ОписаниеТипов("Строка"));
	ЭталонТаблицаКомуТЧ.Колонки.Добавить("АдресЭлектроннойПочты", Новый ОписаниеТипов("Строка"));
	
	ЭталонТаблицаКопииТЧ = Новый ТаблицаЗначений;
	ЭталонТаблицаКопииТЧ.Колонки.Добавить("Представление", Новый ОписаниеТипов("Строка"));
	ЭталонТаблицаКопииТЧ.Колонки.Добавить("АдресЭлектроннойПочты", Новый ОписаниеТипов("Строка"));
	
	Для каждого Письмо Из МассивПисем Цикл

		ФормаПрогрессора.Значение   = ФормаПрогрессора.Значение + 1;
		
		СтрокаПисьма = ЭлектронныеПисьма.Добавить();
		СтрокаПисьма.ПочтовоеСообщение = Письмо;
		СтрокаПисьма.ДатаПолучения = Письмо.ДатаПолучения;
		
		СтрокаПисьма.КомуТЧ      = ЭталонТаблицаКомуТЧ.Скопировать();
		СтрокаПисьма.КопииТЧ     = ЭталонТаблицаКопииТЧ.Скопировать();
		
		ТаблицаПоиска = ЭталонТаблицаПоиска.Скопировать();
		СтрокаТаблицыПоиска = ТаблицаПоиска.Добавить();
		СтрокаТаблицыПоиска.АдресЭлектроннойПочты = Строка(Письмо.Отправитель);
		Для каждого Получатель Из Письмо.Получатели Цикл
			СтрокаТаблицыПоиска = ТаблицаПоиска.Добавить();
			СтрокаТаблицыПоиска.АдресЭлектроннойПочты = Получатель.Адрес;
		КонецЦикла;
		Для каждого Получатель Из Письмо.Копии Цикл
			СтрокаТаблицыПоиска = ТаблицаПоиска.Добавить();
			СтрокаТаблицыПоиска.АдресЭлектроннойПочты = Получатель.Адрес;
		КонецЦикла;
		
		РезультатПоиска = УправлениеЭлектроннойПочтой.ПоискВКонтактнойИнформации(ТаблицаПоиска);
		РезультатПоиска.Индексы.Добавить("Представление");
		
		// Заполним отправителя
		СтрокаОтправителя = РезультатПоиска.Найти(Строка(Письмо.Отправитель), "Представление");
		Если СтрокаОтправителя = Неопределено Тогда
			СтрокаПисьма.ОтправительПредставление         = Строка(Письмо.Отправитель);
			СтрокаПисьма.ОтправительИмя                   = Строка(Письмо.Отправитель);
			СтрокаПисьма.ОтправительАдресЭлектроннойПочты = Строка(Письмо.Отправитель);
		Иначе
			Если НЕ ЗначениеЗаполнено(СтрокаОтправителя.ПредставлениеОбъекта) Тогда
				СтрокаПисьма.ОтправительПредставление         = Строка(СтрокаОтправителя.Представление);
				СтрокаПисьма.ОтправительИмя                   = "";
				СтрокаПисьма.ОтправительАдресЭлектроннойПочты = Строка(СтрокаОтправителя.Представление);
			Иначе
				СтрокаПисьма.ОтправительПредставление         = СтрокаОтправителя.ПредставлениеОбъекта + " <" + СтрокаОтправителя.Представление + ">";
				СтрокаПисьма.ОтправительИмя                   = СтрокаОтправителя.ПредставлениеОбъекта;
				СтрокаПисьма.ОтправительАдресЭлектроннойПочты = СтрокаОтправителя.Представление;
			КонецЕсли; 
		КонецЕсли; 
		
		// Заполняем получателей
		Для каждого Получатель Из Письмо.Получатели Цикл
			СтрокаПолучателя = РезультатПоиска.Найти(Получатель.Адрес, "Представление");
			Если СтрокаПолучателя <> Неопределено Тогда
				СтрокаКомуТЧ = СтрокаПисьма.КомуТЧ.Добавить();
				СтрокаКомуТЧ.Представление = СтрокаПолучателя.ПредставлениеОбъекта;
				СтрокаКомуТЧ.АдресЭлектроннойПочты = СтрокаПолучателя.Представление;
				Если НЕ ЗначениеЗаполнено(СтрокаПолучателя.ПредставлениеОбъекта) Тогда
					СтрокаПисьма.Кому = СтрокаПисьма.Кому + ", " + СтрокаПолучателя.Представление;
					СтрокаПисьма.КомуПредставление = СтрокаПисьма.КомуПредставление + ", " + СтрокаПолучателя.Представление;
				Иначе
					СтрокаПисьма.Кому = СтрокаПисьма.Кому + ", " + СтрокаПолучателя.ПредставлениеОбъекта + " <" + СтрокаПолучателя.Представление + ">";
					СтрокаПисьма.КомуПредставление = СтрокаПисьма.КомуПредставление + ", " + СтрокаПолучателя.ПредставлениеОбъекта;
				КонецЕсли; 
			Иначе
				СтрокаКомуТЧ = СтрокаПисьма.КомуТЧ.Добавить();
				СтрокаКомуТЧ.АдресЭлектроннойПочты = Получатель.Адрес;
				СтрокаПисьма.Кому = СтрокаПисьма.Кому + ", " + Получатель.Адрес;
				СтрокаПисьма.КомуПредставление = СтрокаПисьма.КомуПредставление + ", " + Получатель.Адрес;
			КонецЕсли;
		КонецЦикла;
		Если НЕ ПустаяСтрока(СтрокаПисьма.Кому) Тогда
			СтрокаПисьма.Кому = Сред(СтрокаПисьма.Кому, 3);
		КонецЕсли; 
		
		// Заполняем получателей копий
		Для каждого Получатель Из Письмо.Копии Цикл
			СтрокаПолучателя = РезультатПоиска.Найти(Получатель.Адрес, "Представление");
			Если СтрокаПолучателя <> Неопределено Тогда
				СтрокаКопииТЧ = СтрокаПисьма.КопииТЧ.Добавить();
				СтрокаКопииТЧ.Представление = СтрокаПолучателя.ПредставлениеОбъекта;
				СтрокаКопииТЧ.АдресЭлектроннойПочты = СтрокаПолучателя.Представление;
				Если НЕ ЗначениеЗаполнено(СтрокаПолучателя.ПредставлениеОбъекта) Тогда
					СтрокаПисьма.Копии = СтрокаПисьма.Копии + ", " + СтрокаПолучателя.Представление;
					СтрокаПисьма.КопииПредставление = СтрокаПисьма.КопииПредставление + ", " + СтрокаПолучателя.Представление;
				Иначе
					СтрокаПисьма.Копии = СтрокаПисьма.Копии + ", " + СтрокаПолучателя.ПредставлениеОбъекта + " <" + СтрокаПолучателя.Представление + ">";
					СтрокаПисьма.КопииПредставление = СтрокаПисьма.КопииПредставление + ", " + СтрокаПолучателя.ПредставлениеОбъекта;
				КонецЕсли; 
			Иначе
				СтрокаКопииТЧ = СтрокаПисьма.КопииТЧ.Добавить();
				СтрокаКопииТЧ.АдресЭлектроннойПочты = Получатель.Адрес;
				СтрокаПисьма.Копии = СтрокаПисьма.Копии + ", " + Получатель.Адрес;
				СтрокаПисьма.КопииПредставление = СтрокаПисьма.КопииПредставление + ", " + Получатель.Адрес;
			КонецЕсли;
		КонецЦикла;
		Если НЕ ПустаяСтрока(СтрокаПисьма.Копии) Тогда
			СтрокаПисьма.Копии = Сред(СтрокаПисьма.Копии, 3);
		КонецЕсли; 
		
		СтрокаПисьма.Тема = Письмо.Тема;
		СтрокаПисьма.Вложения = (Письмо.Вложения.Количество() > 0);
		
		СтрокаПисьма.ПочтовоеСообщение.Текст = СтрЗаменить(СтрокаПисьма.ПочтовоеСообщение.Текст, Символы.ВК, "");
		
		СтрокаПисьма.Использование = Истина;

	КонецЦикла;
	
	ФормаПрогрессора.Закрыть();
	
	Почта.Отключиться();
	
КонецПроцедуры

Процедура ЭлектронныеПисьмаПриВыводеСтроки(Элемент, ОформлениеСтроки, ДанныеСтроки)
	
	ОформлениеСтроки.Ячейки.Вложения.ОтображатьТекст    = Ложь;
	ОформлениеСтроки.Ячейки.Вложения.ОтображатьКартинку = Истина;
	ОформлениеСтроки.Ячейки.Вложения.ОтображатьФлажок   = Ложь;
	
	ОформлениеСтроки.Ячейки.Вложения.ИндексКартинки = ?(ДанныеСтроки.Вложения, 0, 2);
	
КонецПроцедуры

Процедура ЭлектронныеПисьмаВыбор(Элемент, ВыбраннаяСтрока, Колонка, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	ОткрытьФормуПисьма();
	
КонецПроцедуры

Процедура ЭлектронныеПисьмаПередНачаломИзменения(Элемент, Отказ)
	
	Если Элемент.ТекущаяКолонка.Имя <> "Использование" Тогда
		Отказ = Истина;
		ОткрытьФормуПисьма();
	КонецЕсли; 
	
КонецПроцедуры

Процедура КоманднаяПанельЭлектронныеПисьмаУстановитьФлажки(Кнопка)
	
	Для каждого СтрокаТЗ Из ЭлектронныеПисьма Цикл
		СтрокаТЗ.Использование = Истина;
	КонецЦикла; 
	
КонецПроцедуры

Процедура КоманднаяПанельЭлектронныеПисьмаСнятьФлажки(Кнопка)
	
	Для каждого СтрокаТЗ Из ЭлектронныеПисьма Цикл
		СтрокаТЗ.Использование = Ложь;
	КонецЦикла; 
	
КонецПроцедуры

ЭлектронныеПисьма.Колонки.Добавить("ПочтовоеСообщение");
ЭлектронныеПисьма.Колонки.Добавить("КомуТЧ");
ЭлектронныеПисьма.Колонки.Добавить("КомуПредставление", Новый ОписаниеТипов("Строка"));
ЭлектронныеПисьма.Колонки.Добавить("КопииТЧ");
ЭлектронныеПисьма.Колонки.Добавить("КопииПредставление", Новый ОписаниеТипов("Строка"));

ЭлектронныеПисьма.Колонки.Добавить("ОтправительИмя", Новый ОписаниеТипов("Строка"));
ЭлектронныеПисьма.Колонки.Добавить("ОтправительАдресЭлектроннойПочты", Новый ОписаниеТипов("Строка"));
