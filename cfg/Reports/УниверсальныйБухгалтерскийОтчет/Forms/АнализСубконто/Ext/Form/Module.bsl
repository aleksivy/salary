﻿Перем СохраненнаяНастройка Экспорт;
Перем Расшифровки Экспорт;
Перем РежимРасшифровки Экспорт;
Перем Реквизиты Экспорт;

Процедура ОбработкаИзмененияСоставаСубконто(ПолнаяОбработка = Истина) Экспорт
	
	МассивСубконто = Новый Массив;
	
	ИмяПоляПрефикс = "Субконто";
	
	ПараметрыОС      = Новый Структура("ИндексСубконто, ЗаголовокСубконто", 0, "");
	ПараметрыНМА     = Новый Структура("ИндексСубконто, ЗаголовокСубконто", 0, "");
	ПараметрыФизЛица = Новый Структура("ИндексСубконто, ЗаголовокСубконто", 0, "");
	ПараметрыКонтрагентов = Новый Структура("ИндексСубконто, ЗаголовокСубконто", 0, "");
	
	// Изменение представления и наложения ограничения типа значения
	Индекс = 1;
	Для Каждого ВидСубконто Из СписокВидовСубконто Цикл
		Если ЗначениеЗаполнено(ВидСубконто.Значение) Тогда
			МассивСубконто.Добавить(ВидСубконто.Значение);
			Поле = СхемаКД.НаборыДанных.ОсновнойНаборДанных.Поля.Найти(ИмяПоляПрефикс + Индекс);
			Если Поле <> Неопределено Тогда
				Поле.ТипЗначения = ВидСубконто.Значение.ТипЗначения;
				Поле.Заголовок   = Строка(ВидСубконто.Значение);
			КонецЕсли;
			
			Если Поле.ТипЗначения.СодержитТип(Тип("СправочникСсылка.ОсновныеСредства")) Тогда
				ПараметрыОС.ИндексСубконто    = Индекс;
				ПараметрыОС.ЗаголовокСубконто = Поле.Заголовок;
			ИначеЕсли Поле.ТипЗначения.СодержитТип(Тип("СправочникСсылка.НематериальныеАктивы")) Тогда
				ПараметрыНМА.ИндексСубконто    = Индекс;
				ПараметрыНМА.ЗаголовокСубконто = Поле.Заголовок;
			ИначеЕсли Поле.ТипЗначения.СодержитТип(Тип("СправочникСсылка.ФизическиеЛица")) Тогда
				ПараметрыФизЛица.ИндексСубконто    = Индекс;
				ПараметрыФизЛица.ЗаголовокСубконто = Поле.Заголовок;
			ИначеЕсли Поле.ТипЗначения.СодержитТип(Тип("СправочникСсылка.Контрагенты")) Тогда
				ПараметрыКонтрагентов.ИндексСубконто    = Индекс;
				ПараметрыКонтрагентов.ЗаголовокСубконто = Поле.Заголовок;
			КонецЕсли;
			Индекс = Индекс + 1;
		КонецЕсли;
	КонецЦикла;
	
	КН.Инициализировать(Новый ИсточникДоступныхНастроекКомпоновкиДанных(СхемаКД));
	
	
	Если ПолнаяОбработка Тогда
		
		// Управление показателями
		Запрос = Новый Запрос;
		Запрос.Текст = 
		"ВЫБРАТЬ
		|	МАКСИМУМ(ВС1.Ссылка.Валютный) КАК Валютный,
		|	МАКСИМУМ(ВС1.Ссылка.НалоговыйУчет) КАК НалоговыйУчет,
		|	КОЛИЧЕСТВО(РАЗЛИЧНЫЕ ВС1.Ссылка) КАК КоличествоСчетов
		|ИЗ
		|	ПланСчетов.Хозрасчетный.ВидыСубконто КАК ВС1
		|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ ПланСчетов.Хозрасчетный.ВидыСубконто КАК ВС2
		|		ПО ВС1.Ссылка = ВС2.Ссылка
		|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ ПланСчетов.Хозрасчетный.ВидыСубконто КАК ВС3
		|		ПО ВС1.Ссылка = ВС3.Ссылка
		|ГДЕ
		|	ВС1.ВидСубконто = &ВидСубконто1
		|	И ВС2.ВидСубконто = &ВидСубконто2
		|	И ВС3.ВидСубконто = &ВидСубконто3";
		Индекс = 3;
		Пока Индекс <> 0 Цикл
			Если Индекс > МассивСубконто.Количество() Тогда
				Запрос.Текст = СтрЗаменить(Запрос.Текст, "ВС" + Индекс + ".ВидСубконто = &ВидСубконто" + Индекс, "ИСТИНА");	
			КонецЕсли;	
			Индекс = Индекс - 1;
		КонецЦикла;
		Для Индекс = 1 По МассивСубконто.Количество() Цикл
			Запрос.УстановитьПараметр("ВидСубконто" + Индекс, МассивСубконто[Индекс - 1]);
		КонецЦикла;
		ЕстьВалюта               = Ложь;
		ЕстьНалоговыйУчет        = Ложь;
		ЕстьСчета                = Ложь;	
		
		Если СписокВидовСубконто.Количество() = 0 Тогда
			ЕстьВалюта               = Истина;
			ЕстьНалоговыйУчет        = Истина;
			ЕстьСчета                = Истина;
		Иначе
			ВыборкаСчета = Запрос.Выполнить().Выбрать();
			Пока ВыборкаСчета.Следующий() Цикл
				ЕстьВалюта               = ?(ВыборкаСчета.Валютный             = Истина, Истина, Ложь);
				ЕстьНалоговыйУчет        = ?(ВыборкаСчета.НалоговыйУчет        = Истина, Истина, Ложь);
				ЕстьСчета                = ?(ВыборкаСчета.КоличествоСчетов     = 0, Ложь, Истина);  
			КонецЦикла;
		КонецЕсли;
		
		Если ЕстьНалоговыйУчет Тогда
			ДанныеОтчета.ПоказателиОтчета.БУ.Использование = Истина;
			ДанныеОтчета.ПоказателиОтчета.БУ.Значение      = Истина;
			ДанныеОтчета.ПоказателиОтчета.НУ.Использование = Истина;
			ДанныеОтчета.ПоказателиОтчета.НУ.Значение      = Ложь;
			ДанныеОтчета.ПоказателиОтчета.Контроль.Использование = Истина;
			ДанныеОтчета.ПоказателиОтчета.Контроль.Значение      = Ложь;
		Иначе
			ДанныеОтчета.ПоказателиОтчета.БУ.Использование = Истина;
			ДанныеОтчета.ПоказателиОтчета.БУ.Значение      = Истина;
			ДанныеОтчета.ПоказателиОтчета.НУ.Использование = Ложь;
			ДанныеОтчета.ПоказателиОтчета.НУ.Значение      = Ложь;
			ДанныеОтчета.ПоказателиОтчета.Контроль.Использование = Ложь;
			ДанныеОтчета.ПоказателиОтчета.Контроль.Значение      = Ложь;	
		КонецЕсли;
		
		Если ЕстьСчета Тогда
			ДанныеОтчета.ПоказателиОтчета.РазвернутоеСальдо.Использование = Истина;
			ДанныеОтчета.ПоказателиОтчета.РазвернутоеСальдо.Значение      = Ложь;
		Иначе
			ДанныеОтчета.ПоказателиОтчета.БУ.Использование = Ложь;
			ДанныеОтчета.ПоказателиОтчета.БУ.Значение      = Ложь;
			ДанныеОтчета.ПоказателиОтчета.РазвернутоеСальдо.Использование = Ложь;
			ДанныеОтчета.ПоказателиОтчета.РазвернутоеСальдо.Значение      = Ложь;
		КонецЕсли;
		
		Если ЕстьВалюта Тогда
			ДанныеОтчета.ПоказателиОтчета.ВалютнаяСумма.Использование = Истина;
			ДанныеОтчета.ПоказателиОтчета.ВалютнаяСумма.Значение      = Истина;			
		Иначе
			ДанныеОтчета.ПоказателиОтчета.ВалютнаяСумма.Использование = Ложь;
			ДанныеОтчета.ПоказателиОтчета.ВалютнаяСумма.Значение      = Ложь;		
		КонецЕсли;
		
		КоличествоСубконто = МассивСубконто.Количество();
		
		
		// Добавление группировок с соответствии с выбранным счетом	
		ДанныеОтчета.Группировка.Очистить();
		
		Для Индекс = 1 По КоличествоСубконто Цикл
			НоваяСтрока = ДанныеОтчета.Группировка.Добавить();
			Поле = КН.Настройки.ДоступныеПоляОтбора.НайтиПоле(Новый ПолеКомпоновкиДанных(ИмяПоляПрефикс + Индекс));
			НоваяСтрока.Поле           = Поле.Поле;
			НоваяСтрока.Использование  = Истина;
			НоваяСтрока.Представление  = Поле.Заголовок;
			НоваяСтрока.ТипГруппировки = ТипИзмеренияПостроителяОтчета.Элементы;	
		КонецЦикла;
		
		Если ЕстьНалоговыйУчет Тогда
			НоваяСтрока = ДанныеОтчета.Группировка.Добавить();
			НоваяСтрока.Поле           = "НалоговоеНазначение";
			НоваяСтрока.Использование  = Истина;
			НоваяСтрока.Представление  = НСтр("ru='Налоговое назначение';uk='Податкове призначення'");
			НоваяСтрока.ТипГруппировки = Перечисления.ТипДетализацииСтандартныхОтчетов.Элементы;
		КонецЕсли;
		
		// Обработка дополнительных полей
		мЗаполнитьДополнительныеПоляПоУмолчанию(ЭтаФорма);
		
		Если Не РежимРасшифровки Тогда
			// Добавление неактивных отборов по субконто в соответствии с выбранным счетом
			ОтборыДляУдаления = Новый Массив;
			Для Каждого ЭлементОтбора Из КН.Настройки.Отбор.Элементы Цикл
				Если ТипЗнч(ЭлементОтбора) = Тип("ЭлементОтбораКомпоновкиДанных") Тогда 
					Если Найти(ЭлементОтбора.ЛевоеЗначение, "Субконто") > 0 ИЛИ Строка(ЭлементОтбора.ЛевоеЗначение) = "Валюта" 
							ИЛИ (Найти(ЭлементОтбора.ЛевоеЗначение, "НалоговоеНазначение") = 1) Тогда
						ОтборыДляУдаления.Добавить(ЭлементОтбора);
					КонецЕсли;
				КонецЕсли;
			КонецЦикла;
			
			Для Каждого ЭлементОтбора Из ОтборыДляУдаления Цикл
				КН.Настройки.Отбор.Элементы.Удалить(ЭлементОтбора);
			КонецЦикла;
			
			Для Индекс = 1 По МассивСубконто.Количество() Цикл
				Поле = КН.Настройки.ДоступныеПоляОтбора.НайтиПоле(Новый ПолеКомпоновкиДанных(ИмяПоляПрефикс + Индекс));
				мДобавитьОтбор(КН, ИмяПоляПрефикс + Индекс, МассивСубконто[Индекс - 1].ТипЗначения.ПривестиЗначение(Неопределено), , Ложь);	
			КонецЦикла;
			
			Если ЕстьНалоговыйУчет Тогда
				Поле = КН.Настройки.ДоступныеПоляОтбора.НайтиПоле(Новый ПолеКомпоновкиДанных("НалоговоеНазначение"));
				мДобавитьОтбор(КН, "НалоговоеНазначение", Поле.Тип.ПривестиЗначение(Неопределено), , Ложь); 
			КонецЕсли;
		КонецЕсли;
			
	КонецЕсли;
	
КонецПроцедуры

Процедура ЗаполнитьНачальныеНастройки() Экспорт
	
	мЗаполнитьДанныеОтчета(ЭтаФорма);
	
КонецПроцедуры

Процедура СформироватьОтчет(Результат = Неопределено, ДанныеРасшифровки = Неопределено, ВыводВФормуОтчета = Истина, ВнешниеНаборыДанных = Неопределено, ВыводитьПолностью = Истина) Экспорт
	
	Результат.Очистить();
	
	Настройки = КН.ПолучитьНастройки();
	ВыводЗаголовкаОтчета(ЭтаФорма, Результат);
	Если ВыводитьПолностью Тогда
		ДоработатьКомпоновщикПередВыводом(ВнешниеНаборыДанных);
		КН.Восстановить();
		НастройкаКомпоновщикаНастроек = КН.ПолучитьНастройки();
		мВывестиОтчет(ЭтаФорма, НастройкаКомпоновщикаНастроек, Результат, ДанныеРасшифровки, ВыводВФормуОтчета, ВнешниеНаборыДанных);
		КН.ЗагрузитьНастройки(Настройки);
	КонецЕсли; 
	ВыводПодписейОтчета(ЭтаФорма, Результат);
	
	Если ВыводитьПолностью Тогда
		// Выполним дополнительную обработку Результата отчета
		ОбработкаРезультатаОтчета(Результат);
		
		// Сохраним настройки для Истории
		мСохранитьНастройкуДляИстории(ЭтаФорма);
	КонецЕсли;
	
КонецПроцедуры

Процедура ПередВыводомОтчета(МакетКомпоновки) Экспорт
	
	ПоказателиОтчета = ДанныеОтчета.ПоказателиОтчета;	
	
	МакетШапкиОтчета = мПолучитьМакетШапки(МакетКомпоновки);
	Ячейка2 = МакетШапкиОтчета.Макет[0].Ячейки[0];
	Ячейка2.Элементы.Очистить();
	НовыйЭлемент = Ячейка2.Элементы.Добавить(Тип("ПолеОбластиКомпоновкиДанных"));
	
	
	КоличествоГруппировок = ?(ПоСубсчетам, 1, 0);
	СтрокаЗаголовкаГруппировки = "";
	Для Каждого СтрокаТаблицы Из ДанныеОтчета.Группировка Цикл
		Если СтрокаТаблицы.Использование Тогда
			СтрокаЗаголовкаГруппировки = СтрокаЗаголовкаГруппировки + СтрокаТаблицы.Представление + " \ ";
			КоличествоГруппировок = КоличествоГруппировок + 1;
		КонецЕсли;
	КонецЦикла;
	СтрокаЗаголовкаГруппировки = СтрокаЗаголовкаГруппировки + ?(ПоСубсчетам, "Субсчет \ ", "Счет \ ");
	
	СтрокаЗаголовкаГруппировки = Сред(СтрокаЗаголовкаГруппировки, 1, СтрДлина(СтрокаЗаголовкаГруппировки) - 2);
	Если КоличествоГруппировок = 0 Тогда
		СтрокаЗаголовкаГруппировки = "Счет";
	КонецЕсли;
		
	НовыйЭлемент.Значение = СтрокаЗаголовкаГруппировки;
	Ячейка2 = МакетШапкиОтчета.Макет[1].Ячейки[0];
	Ячейка2.Элементы.Очистить();
	мУстановитьПараметр(Ячейка2.Оформление.Элементы, "ОбъединятьПоВертикали", Истина);

	МассивДляУдаления = Новый Массив;
	Для Индекс = 2 По МакетШапкиОтчета.Макет.Количество() - 1 Цикл
		МассивДляУдаления.Добавить(МакетШапкиОтчета.Макет[Индекс]);
	КонецЦикла;
	
	КоличествоПоказателей = 0;
	Для Каждого Показатель Из ПоказателиОтчета Цикл
		КоличествоПоказателей = КоличествоПоказателей + Показатель.Значение.Значение;
	КонецЦикла;
	
	Если КоличествоПоказателей > 1 Тогда
		Ячейка11 = МакетШапкиОтчета.Макет[1].Ячейки[1];
		Ячейка11.Элементы.Очистить();
		мУстановитьПараметр(Ячейка11.Оформление.Элементы, "ОбъединятьПоВертикали", Истина);
	КонецЕсли;
	
	МакетПодвалаОтчета            = мПолучитьМакетПодвала(МакетКомпоновки);
	МакетГруппировкиОрганизация   = мПолучитьМакетГруппировкиПоПолюГруппировки(МакетКомпоновки, "Организация");
	МакетГруппировкиСчет          = мПолучитьМакетГруппировкиПоПолюГруппировки(МакетКомпоновки, "Счет");
	МакетГруппировкиВалюта        = мПолучитьМакетГруппировкиПоПолюГруппировки(МакетКомпоновки, "Валюта");
	
	Для Каждого Элемент Из МассивДляУдаления Цикл
		МакетШапкиОтчета.Макет.Удалить(Элемент);
	КонецЦикла;
	
	Для Каждого Макет Из МакетКомпоновки.Макеты Цикл 
		Если Макет = МакетШапкиОтчета Тогда
		Иначе			
			Индекс = -1;
			МассивПоказателей = Новый Массив;
			МассивПоказателей.Добавить("БУ");
			МассивПоказателей.Добавить("НУ");
			
			Для Каждого ЭлементМассива Из МассивПоказателей Цикл
				Если ПоказателиОтчета[ЭлементМассива].Значение Тогда
					Индекс = Индекс + 1;
				КонецЕсли;
			КонецЦикла;
			Если ПоказателиОтчета.Контроль.Значение Тогда 
				Индекс = Индекс + 1;					
			КонецЕсли;
			
			Если ПоказателиОтчета.ВалютнаяСумма.Значение И КоличествоПоказателей = 1 Тогда 
			
			ИначеЕсли ПоказателиОтчета.ВалютнаяСумма.Значение Тогда
				Индекс = Индекс + 1;				
				Если МакетГруппировкиВалюта.Найти(Макет) <> Неопределено ИЛИ Макет = МакетПодвалаОтчета Тогда
			
				Иначе
					Макет.Макет.Удалить(Макет.Макет[Индекс]);
					Индекс = Индекс - 1;
				КонецЕсли;
			КонецЕсли;
		КонецЕсли;
	КонецЦикла;
	
КонецПроцедуры

Процедура ПередВыводомЭлементаРезультата(МакетКомпоновки, ДанныеРасшифровки, ЭлементРезультата, Отказ = Ложь) Экспорт

	
КонецПроцедуры

// В процедуре можно доработать компоновщик перед выводом в отчет
// Изменения сохранены не будут
Процедура ДоработатьКомпоновщикПередВыводом(ВнешниеНаборыДанных) Экспорт
	
	КН.Настройки.Структура.Очистить();
	КН.Настройки.Выбор.Элементы.Очистить();
	
	мУстановитьПараметр(КН, "Периодичность", Периодичность);
	
	Если ЗначениеЗаполнено(НачалоПериода) Тогда
		мУстановитьПараметр(КН, "НачалоПериода", НачалоДня(НачалоПериода));
	КонецЕсли;
	Если ЗначениеЗаполнено(КонецПериода) Тогда
		мУстановитьПараметр(КН, "КонецПериода", КонецДня(КонецПериода));
		мУстановитьПараметр(КН, "ПараметрПериод", КонецДня(КонецПериода));
	Иначе
		мУстановитьПараметр(КН, "ПараметрПериод", КонецДня(ТекущаяДата()));
	КонецЕсли;
	
	МассивПоказателей = Новый Массив;
	МассивПоказателей.Добавить("БУ");
	МассивПоказателей.Добавить("НУ");

	МассивПоказателей.Добавить("Контроль");
	МассивПоказателей.Добавить("ВалютнаяСумма");

	МассивВидовСубконто = Новый Массив;
	Для Каждого ЭлементСписка Из СписокВидовСубконто Цикл
		Если ЗначениеЗаполнено(ЭлементСписка.Значение) Тогда 
			МассивВидовСубконто.Добавить(ЭлементСписка.Значение);
		КонецЕсли;
	КонецЦикла;
	
	мУстановитьПараметр(КН, "СписокВидовСубконто", МассивВидовСубконто);
	
	ПоказателиОтчета = ДанныеОтчета.ПоказателиОтчета;
	
	КоличествоПоказателей = 0;
	Для Каждого Показатель Из ПоказателиОтчета Цикл
		КоличествоПоказателей = КоличествоПоказателей + Показатель.Значение.Значение;
	КонецЦикла;
	
	Если КоличествоПоказателей > 1 Тогда
		ГруппаПоказатели = КН.Настройки.Выбор.Элементы.Добавить(Тип("ГруппаВыбранныхПолейКомпоновкиДанных"));
		ГруппаПоказатели.Заголовок     = "Показатели";
		ГруппаПоказатели.Использование = Истина;
		ГруппаПоказатели.Расположение  = РасположениеПоляКомпоновкиДанных.Вертикально;
		
		Для Каждого ЭлементМассива Из МассивПоказателей Цикл
			Если ПоказателиОтчета[ЭлементМассива].Значение Тогда 
				мДобавитьВыбранноеПоле(ГруппаПоказатели, "Показатели." + ЭлементМассива);
			КонецЕсли;
		КонецЦикла;	
		
		Если ПоказателиОтчета.РазвернутоеСальдо.Значение Тогда
			Для Каждого ЭлементМассива Из МассивПоказателей Цикл
				Если ПоказателиОтчета[ЭлементМассива].Значение Тогда 
					мДобавитьВыбранноеПоле(ГруппаПоказатели, "Показатели." + ЭлементМассива + "Разв");
				КонецЕсли;
			КонецЦикла;	
		КонецЕсли;
	КонецЕсли;

	
	ГруппаСальдоНаНачало = КН.Настройки.Выбор.Элементы.Добавить(Тип("ГруппаВыбранныхПолейКомпоновкиДанных"));
	ГруппаСальдоНаНачало.Заголовок     = НСтр("ru='Сальдо на начало периода';uk='Сальдо на початок періоду'");
	ГруппаСальдоНаНачало.Использование = Истина;
	ГруппаСальдоНаНачалоДт = ГруппаСальдоНаНачало.Элементы.Добавить(Тип("ГруппаВыбранныхПолейКомпоновкиДанных"));
	ГруппаСальдоНаНачалоДт.Заголовок     = "Дебет";
	ГруппаСальдоНаНачалоДт.Использование = Истина;
	ГруппаСальдоНаНачалоДт.Расположение  = РасположениеПоляКомпоновкиДанных.Вертикально;
	ГруппаСальдоНаНачалоКт = ГруппаСальдоНаНачало.Элементы.Добавить(Тип("ГруппаВыбранныхПолейКомпоновкиДанных"));
	ГруппаСальдоНаНачалоКт.Заголовок     = "Кредит";
	ГруппаСальдоНаНачалоКт.Использование = Истина;
	ГруппаСальдоНаНачалоКт.Расположение  = РасположениеПоляКомпоновкиДанных.Вертикально;
	
	ГруппаОбороты = КН.Настройки.Выбор.Элементы.Добавить(Тип("ГруппаВыбранныхПолейКомпоновкиДанных"));
	ГруппаОбороты.Заголовок     = НСтр("ru='Обороты за период';uk='Обороти за період'");
	ГруппаОбороты.Использование = Истина;
	ГруппаОборотыДт = ГруппаОбороты.Элементы.Добавить(Тип("ГруппаВыбранныхПолейКомпоновкиДанных"));
	ГруппаОборотыДт.Заголовок     = "Дебет";
	ГруппаОборотыДт.Использование = Истина;
	ГруппаОборотыДт.Расположение  = РасположениеПоляКомпоновкиДанных.Вертикально;
	ГруппаОборотыКт = ГруппаОбороты.Элементы.Добавить(Тип("ГруппаВыбранныхПолейКомпоновкиДанных"));
	ГруппаОборотыКт.Заголовок     = "Кредит";
	ГруппаОборотыКт.Использование = Истина;
	ГруппаОборотыКт.Расположение  = РасположениеПоляКомпоновкиДанных.Вертикально;
	
	ГруппаСальдоНаКонец = КН.Настройки.Выбор.Элементы.Добавить(Тип("ГруппаВыбранныхПолейКомпоновкиДанных"));
	ГруппаСальдоНаКонец.Заголовок     = НСтр("ru='Сальдо на конец периода';uk='Сальдо на кінець періоду'");
	ГруппаСальдоНаКонец.Использование = Истина;
	ГруппаСальдоНаКонецДт = ГруппаСальдоНаКонец.Элементы.Добавить(Тип("ГруппаВыбранныхПолейКомпоновкиДанных"));
	ГруппаСальдоНаКонецДт.Заголовок     = "Дебет";
	ГруппаСальдоНаКонецДт.Использование = Истина;
	ГруппаСальдоНаКонецДт.Расположение  = РасположениеПоляКомпоновкиДанных.Вертикально;
	ГруппаСальдоНаКонецКт = ГруппаСальдоНаКонец.Элементы.Добавить(Тип("ГруппаВыбранныхПолейКомпоновкиДанных"));
	ГруппаСальдоНаКонецКт.Заголовок     = "Кредит";
	ГруппаСальдоНаКонецКт.Использование = Истина;
	ГруппаСальдоНаКонецКт.Расположение  = РасположениеПоляКомпоновкиДанных.Вертикально;
	
	
	ВидОстатоков = ?(ПоказателиОтчета.РазвернутоеСальдо.Значение, "Развернутый", "");
	
	Для Каждого ЭлементМассива Из МассивПоказателей Цикл
		Если ПоказателиОтчета[ЭлементМассива].Значение Тогда 
			мДобавитьВыбранноеПоле(ГруппаСальдоНаНачалоДт, "СальдоНаНачалоПериода." + ЭлементМассива + "Начальный" + ВидОстатоков + "ОстатокДт");
			мДобавитьВыбранноеПоле(ГруппаСальдоНаНачалоКт, "СальдоНаНачалоПериода." + ЭлементМассива + "Начальный" + ВидОстатоков + "ОстатокКт");
			мДобавитьВыбранноеПоле(ГруппаОборотыДт,        "ОборотыЗаПериод."       + ЭлементМассива + "ОборотДт");
			мДобавитьВыбранноеПоле(ГруппаОборотыКт,        "ОборотыЗаПериод."       + ЭлементМассива + "ОборотКт");
			мДобавитьВыбранноеПоле(ГруппаСальдоНаКонецДт,  "СальдоНаКонецПериода."  + ЭлементМассива + "Конечный"  + ВидОстатоков + "ОстатокДт");
			мДобавитьВыбранноеПоле(ГруппаСальдоНаКонецКт,  "СальдоНаКонецПериода."  + ЭлементМассива + "Конечный"  + ВидОстатоков + "ОстатокКт");
		КонецЕсли;
	КонецЦикла;
	
	МассивПоказателей = Новый Массив;
	МассивПоказателей.Добавить("ВалютнаяСумма");
	
	Для Каждого ЭлементМассива Из МассивПоказателей Цикл
		Если ПоказателиОтчета[ЭлементМассива].Значение Тогда 
			мДобавитьВыбранноеПоле(ГруппаСальдоНаНачалоДт, "СальдоНаНачалоПериода." + ЭлементМассива + "Начальный" + ВидОстатоков + "ОстатокДт");
			мДобавитьВыбранноеПоле(ГруппаСальдоНаНачалоКт, "СальдоНаНачалоПериода." + ЭлементМассива + "Начальный" + ВидОстатоков + "ОстатокКт");
			мДобавитьВыбранноеПоле(ГруппаОборотыДт,        "ОборотыЗаПериод."       + ЭлементМассива + "ОборотДт");
			мДобавитьВыбранноеПоле(ГруппаОборотыКт,        "ОборотыЗаПериод."       + ЭлементМассива + "ОборотКт");
			мДобавитьВыбранноеПоле(ГруппаСальдоНаКонецДт,  "СальдоНаКонецПериода."  + ЭлементМассива + "Конечный" + ВидОстатоков + "ОстатокДт");
			мДобавитьВыбранноеПоле(ГруппаСальдоНаКонецКт,  "СальдоНаКонецПериода."  + ЭлементМассива + "Конечный" + ВидОстатоков + "ОстатокКт");
		КонецЕсли;
	КонецЦикла;
	
	Для Каждого ПолеГруппировки Из ДанныеОтчета.ДополнительныеПоля Цикл 
		Если ПолеГруппировки.Использование Тогда
			мДобавитьВыбранноеПоле(КН, ПолеГруппировки.Поле);
		КонецЕсли;
	КонецЦикла;

	Для Каждого ПолеГруппировки Из ДанныеОтчета.ДополнительныеПоля Цикл 
		Если ПолеГруппировки.Использование Тогда
			мДобавитьВыбранноеПоле(КН, ПолеГруппировки.Поле);
		КонецЕсли;
	КонецЦикла;
	
	Структура = КН.Настройки.Структура.Добавить(Тип("ГруппировкаКомпоновкиДанных"));
	Первый = Истина;
	Для Каждого ПолеВыбраннойГруппировки Из ДанныеОтчета.Группировка Цикл 
		Если ПолеВыбраннойГруппировки.Использование Тогда
			Если Не Первый Тогда 
				Структура = Структура.Структура.Добавить(Тип("ГруппировкаКомпоновкиДанных"));
			КонецЕсли;
			Первый = Ложь;
			ПолеГруппировки = Структура.ПоляГруппировки.Элементы.Добавить(Тип("ПолеГруппировкиКомпоновкиДанных"));
			ПолеГруппировки.Использование  = Истина;
			ПолеГруппировки.Поле           = Новый ПолеКомпоновкиДанных(ПолеВыбраннойГруппировки.Поле);
			Если ПолеВыбраннойГруппировки.ТипГруппировки = ТипИзмеренияПостроителяОтчета.Иерархия Тогда
				ПолеГруппировки.ТипГруппировки = ТипГруппировкиКомпоновкиДанных.Иерархия;
			ИначеЕсли ПолеВыбраннойГруппировки.ТипГруппировки = ТипИзмеренияПостроителяОтчета.ТолькоИерархия Тогда
				ПолеГруппировки.ТипГруппировки = ТипГруппировкиКомпоновкиДанных.ТолькоИерархия;
			Иначе
				ПолеГруппировки.ТипГруппировки = ТипГруппировкиКомпоновкиДанных.Элементы;
			КонецЕсли;
			Структура.Выбор.Элементы.Добавить(Тип("АвтоВыбранноеПолеКомпоновкиДанных"));
			Структура.Порядок.Элементы.Добавить(Тип("АвтоЭлементПорядкаКомпоновкиДанных"));
		КонецЕсли;
	КонецЦикла;
	Структура = Структура.Структура.Добавить(Тип("ГруппировкаКомпоновкиДанных"));
	ПолеГруппировки = Структура.ПоляГруппировки.Элементы.Добавить(Тип("ПолеГруппировкиКомпоновкиДанных"));
	ПолеГруппировки.Использование  = Истина;
	ПолеГруппировки.Поле           = Новый ПолеКомпоновкиДанных("Счет");
	ПолеГруппировки.ТипГруппировки = ТипГруппировкиКомпоновкиДанных.Иерархия;
	Структура.Выбор.Элементы.Добавить(Тип("АвтоВыбранноеПолеКомпоновкиДанных"));
	Структура.Порядок.Элементы.Добавить(Тип("АвтоЭлементПорядкаКомпоновкиДанных"));  
	
	Если Не ПоСубсчетам Тогда
		ЗначениеОтбора = мДобавитьОтбор(Структура.Отбор, "SystemFields.LevelInGroup", 1);
		ЗначениеОтбора.Применение = ТипПримененияОтбораКомпоновкиДанных.Иерархия;
		мУстановитьПараметрВывода(Структура, "ВыводитьОтбор", ТипВыводаТекстаКомпоновкиДанных.НеВыводить);
	КонецЕсли;
	
	// Период
	мДобавитьГруппировкуПоПериоду(ЭтаФорма, Структура);
	
	Если ДанныеОтчета.ПоказателиОтчета.ВалютнаяСумма.Значение Тогда 
		Структура = Структура.Структура.Добавить(Тип("ГруппировкаКомпоновкиДанных"));
		ПолеГруппировки = Структура.ПоляГруппировки.Элементы.Добавить(Тип("ПолеГруппировкиКомпоновкиДанных"));
		ПолеГруппировки.Использование  = Истина;
		ПолеГруппировки.Поле           = Новый ПолеКомпоновкиДанных("Валюта");
		ПолеГруппировки.ТипГруппировки = ТипГруппировкиКомпоновкиДанных.Иерархия;
		Структура.Выбор.Элементы.Добавить(Тип("АвтоВыбранноеПолеКомпоновкиДанных"));
		Структура.Порядок.Элементы.Добавить(Тип("АвтоЭлементПорядкаКомпоновкиДанных")); 
	КонецЕсли;
	
	мДобавитьОтборДляПоказателяКонтроль(ЭтотОбъект);
	
КонецПроцедуры

Процедура ВыводЗаголовкаОтчета(ФормаОтчета, Результат)
	
	 мВыводЗаголовкаОтчета(ФормаОтчета, Результат);
			
КонецПроцедуры

Процедура ВыводПодписейОтчета(ФормаОтчета, Результат)
	
	мВыводПодписейОтчета(ФормаОтчета, Результат);
			
КонецПроцедуры

Функция ПолучитьТекстЗаголовка(ОрганизацияВНачале = Истина) Экспорт 
	
	ЗаголовокОтчета = "Анализ субконто" + мПолучитьПредставлениеПериода(ЭтаФорма);

	Возврат ЗаголовокОтчета;
	
КонецФункции

Процедура ПолучитьСтруктуруПоказателейОтчета() Экспорт
	
	ПоказателиОтчета = мПолучитьСтруктуруПоказателейОтчета(,, Истина, Истина, Истина);
	ДанныеОтчета.Вставить("ПоказателиОтчета", ПоказателиОтчета);

КонецПроцедуры

Процедура ОбработкаРезультатаОтчета(Результат)
	
	мОбработкаРезультатаОтчета(ЭтаФорма, Результат);

	// Зафиксируем заголовок отчета
	ВысотаЗаголовка = Результат.Области.Заголовок.Низ;
	Результат.ФиксацияСверху = ВысотаЗаголовка + 2;
	
КонецПроцедуры

// Для настройки отчета (расшифровка и др.)
Процедура Настроить() Экспорт
	
	ЗаполнитьНачальныеНастройки();
	ОбработкаИзмененияСоставаСубконто(РежимРасшифровки);
	
КонецПроцедуры

Процедура СохранитьНастройку() Экспорт
	
	мСохранитьНастройку(ЭтаФорма);
	
КонецПроцедуры

// Процедура заполняет параметры отчета по элементу справочника из переменной СохраненнаяНастройка.
Процедура ПрименитьНастройку() Экспорт
	
	Если СохраненнаяНастройка.Пустая() Тогда
		Возврат;
	КонецЕсли;
	 
	СтруктураПараметров = СохраненнаяНастройка.ХранилищеНастроек.Получить();
	Если РежимРасшифровки Тогда
		НастройкиФормы = СтруктураПараметров.НастройкиФормы;
	Иначе
		мПрименитьСтруктуруПараметровОтчета(ЭтаФорма, СтруктураПараметров);
	КонецЕсли;
	
КонецПроцедуры

Процедура ИнициализацияОтчета() Экспорт
	
	Если Не ЗначениеЗаполнено(СохраненнаяНастройка) И Не РежимРасшифровки Тогда
		НачалоПериода = НачалоМесяца(ТекущаяДата());
		КонецПериода  = КонецМесяца(ТекущаяДата());
		Если РегламентированнаяОтчетность.ИДКонфигурации() = "БП" Тогда
			Организация   = глЗначениеПеременной("ОсновнаяОрганизация");
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

// ОБРАБОТЧИКИ ФОРМЫ
Процедура ОбновитьОтчет(ВыводитьПолностью = Истина) Экспорт
	
	Если ВыводитьПолностью Тогда
		Если Не мПроверитьЗаполнениеОбязательныхРеквизитов(ЭтаФорма) Тогда
			Возврат;
		КонецЕсли;
	КонецЕсли;  
	
	Если РежимРасшифровки Тогда
		РежимРасшифровки = Ложь;
	Иначе
		мСохранитьДанныеОтчета(ЭтаФорма);    
	КонецЕсли;
	
	Если НастройкиФормы.ЗакрыватьПанельПриФормированииОтчета И ВыводитьПолностью Тогда
		ЭлементыФормы.ДействияФормыДополнительные.Кнопки.ПанельПользователя.Пометка = Ложь;
		мУправлениеОтображениемПанелиПользователя(ЭтаФорма);
	КонецЕсли;
	
	СформироватьОтчет(ЭтаФорма.ЭлементыФормы.Результат, ДР, Ложь, , ВыводитьПолностью);
	
	мОбновитьКоллекциюКнопокИстории(ЭтаФорма);
	
КонецПроцедуры

Процедура ОбновитьПанельНастроек() Экспорт
	
	мОбновитьПредставлениеПоказателейОтчета(ЭтаФорма);
	Группировка        = ДанныеОтчета.Группировка.Скопировать();
	ДополнительныеПоля = ДанныеОтчета.ДополнительныеПоля.Скопировать();
	
КонецПроцедуры
/////
Процедура ПередОткрытием(Отказ, СтандартнаяОбработка)
	
	мНазначитьФормеУникальныйКлючИдентификации(ЭтаФорма);
	
	Если Не мЗаполнитьНастройкиПриОткрытииОтчета(ЭтаФорма) Тогда
		ИнициализацияОтчета();
	КонецЕсли;
	
КонецПроцедуры

Процедура ПриОткрытии()
	
	Если Не РежимРасшифровки Тогда
		Настроить();
	КонецЕсли;
	
	мВосстановитьНастройкиФормы(ЭтаФорма);
	ОбновитьПанельНастроек();
	мУправлениеОтображениемОбластейОтчета(ЭтаФорма);
	мУправлениеОтображениемПанелиПользователя(ЭтаФорма);
	мЗаполнитьТаблицуЭлементов(ЭтаФорма);
		
	Если Не Организация = глЗначениеПеременной("ОсновнаяОрганизация") Тогда Организация = глЗначениеПеременной("ОсновнаяОрганизация"); КонецЕсли;
КонецПроцедуры

Процедура ОбновлениеОтображения()
	
	Заголовок = ПолучитьТекстЗаголовка(Ложь);
		
КонецПроцедуры
							 
Процедура ПриЗакрытии()
	
	мСохранитьДанныеОтчета(ЭтаФорма);
	мСохранитьНастройкиФормы(ЭтаФорма);
	мСохранитьНастройку(ЭтаФорма);
	
КонецПроцедуры
////////
Процедура ДействияФормыОсновныеСформировать(Кнопка)
	
	ОбновитьОтчет();
	
КонецПроцедуры

Процедура ДействияФормыОсновныеПечать(Кнопка)
	
	ЭлементыФормы.Результат.Напечатать(Ложь);
	
КонецПроцедуры

Процедура ДействияФормыОсновныеСохранитьКак(Кнопка)
	
	ПредставлениеСохраняемогоФайла = ПолучитьТекстЗаголовка(Ложь);
	мСохранитьКопиюРезультатаОтчета(ЭтаФорма, ПредставлениеСохраняемогоФайла);
	
КонецПроцедуры
//
Процедура ДействияФормыДополнительныеПанельПользователя(Кнопка)
	
	Кнопка.Пометка = Не Кнопка.Пометка;
	мУправлениеОтображениемПанелиПользователя(ЭтаФорма);
	
КонецПроцедуры

Процедура ДействияФормыДополнительныеИстория(Кнопка) Экспорт
	
	мДействияФормыДополнительныеИстория(ЭтаФорма, Кнопка);
	
КонецПроцедуры

Процедура ДействияФормыДополнительныеНастройкаПанелиПользователя(Кнопка)
	
	мНастроитьСтраницыПанелиПользователя(ЭтаФорма, Кнопка);
		
КонецПроцедуры

Процедура ДействияФормыДополнительныеВосстановитьЗначения(Кнопка)
	
	мДействияФормыДополнительныеВосстановитьЗначения(ЭтаФорма);
	
КонецПроцедуры

Процедура ДействияФормыДополнительныеСохранитьЗначения(Кнопка)
	
	мДействияФормыДополнительныеСохранитьЗначения(ЭтаФорма);
	
КонецПроцедуры
//
Процедура СписокВидовСубконтоПередНачаломДобавления(Элемент, Отказ, Копирование)
	
	Если СписокВидовСубконто.Количество() >= 3 Тогда 
		Отказ = Истина;
	КонецЕсли;
	
КонецПроцедуры

Процедура СписокВидовСубконтоПриОкончанииРедактирования(Элемент, НоваяСтрока, ОтменаРедактирования)
	
	ОбработкаИзмененияСоставаСубконто();
	ОбновитьПанельНастроек();
	
КонецПроцедуры

Процедура СписокВидовСубконтоПослеУдаления(Элемент)
	
	ОбработкаИзмененияСоставаСубконто();
	ОбновитьПанельНастроек();
	
КонецПроцедуры
//
Процедура ПоказателиОтчетаПриИзмененииФлажка(Элемент, Колонка)
	
	мПоказателиОтчетаПриИзмененииФлажка(ЭтаФорма, Элемент, Колонка);
	
КонецПроцедуры
//
Процедура КоманднаяПанельДополнительныеПоляДобавитьЭлемент(Кнопка)
	
	мДополнительныеПоляДобавитьЭлемент(ЭтаФорма);
	
КонецПроцедуры

Процедура КоманднаяПанельДополнительныеПоляВключитьВсе(Кнопка)
	
	ДополнительныеПоля.ЗаполнитьЗначения(Истина, "Использование");
	
КонецПроцедуры

Процедура КоманднаяПанельДополнительныеПоляВыключитьВсе(Кнопка)
	
	ДополнительныеПоля.ЗаполнитьЗначения(Ложь, "Использование");
	
КонецПроцедуры

Процедура ДополнительныеПоляПередНачаломДобавления(Элемент, Отказ, Копирование)
	
	мДополнительныеПоляДобавитьЭлемент(ЭтаФорма, Отказ);
	
КонецПроцедуры

Процедура ДополнительныеПоляПередНачаломИзменения(Элемент, Отказ)
	
	мДополнительныеПоляПередНачаломИзменения(ЭтаФорма, Элемент, Отказ);
	
КонецПроцедуры
 
Процедура ДополнительныеПоляПриПолученииДанных(Элемент, ОформленияСтрок)
	
	мРаскраскаНедоступныхПриПолученииДанных(Элемент, ОформленияСтрок);
	
КонецПроцедуры
//
Процедура КоманднаяПанельГруппировкаДобавитьЭлемент(Кнопка)
	
	мГруппировкаДобавитьЭлемент(ЭтаФорма);

КонецПроцедуры

Процедура КоманднаяПанельГруппировкаВключитьВсе(Кнопка)
	
	Группировка.ЗаполнитьЗначения(Истина, "Использование");
	
КонецПроцедуры

Процедура КоманднаяПанельГруппировкаВыключитьВсе(Кнопка)
	
	Группировка.ЗаполнитьЗначения(Ложь, "Использование");
	
КонецПроцедуры

Процедура ГруппировкаПередНачаломДобавления(Элемент, Отказ, Копирование)
	
	мГруппировкаДобавитьЭлемент(ЭтаФорма, Отказ);
	
КонецПроцедуры

Процедура ГруппировкаПередНачаломИзменения(Элемент, Отказ)
	
	мГруппировкаПередНачаломИзменения(ЭтаФорма, Элемент, Отказ);
	
КонецПроцедуры
  
Процедура ГруппировкаПриПолученииДанных(Элемент, ОформленияСтрок)
	
	мРаскраскаНедоступныхПриПолученииДанных(Элемент, ОформленияСтрок);
	
КонецПроцедуры
//
Процедура КоманднаяПанельОтборДобавитьЭлемент(Кнопка)
	
	мОтборДобавитьЭлемент(ЭтаФорма);
	
КонецПроцедуры

Процедура КоманднаяПанельОтборДобавитьГруппу(Кнопка)
	
	мОтборДобавитьГруппу(ЭтаФорма, Кнопка);
	
КонецПроцедуры

Процедура ОтборПередНачаломДобавления(Элемент, Отказ, Копирование)
	
	мОтборДобавитьЭлемент(ЭтаФорма, Отказ);
	
КонецПроцедуры

Процедура ОтборПриВыводеСтроки(Элемент, ОформлениеСтроки, ДанныеСтроки)
	
	ОформлениеСтроки.Ячейки.ЛевоеЗначениеДляКраткогоОтображенияЭлемента.ОтображатьКартинку = Ложь;
	
КонецПроцедуры

Процедура ОтборПриПолученииДанных(Элемент, ОформленияСтрок)
	
	мРаскраскаНедоступныхПриПолученииДанных(Элемент, ОформленияСтрок);
	
КонецПроцедуры

Процедура ОтборПриОкончанииРедактирования(Элемент, НоваяСтрока, ОтменаРедактирования)
	
	мОтборПриОкончанииРедактирования(ЭтаФорма, Элемент, НоваяСтрока, ОтменаРедактирования);
	
КонецПроцедуры

Процедура ОтборЛевоеЗначениеДляКраткогоОтображенияЭлементаНачалоВыбора(Элемент, СтандартнаяОбработка)
	
	мОтборНачалоВыбора(ЭтаФорма, Элемент, СтандартнаяОбработка);
	
КонецПроцедуры

Процедура ОтборПравоеЗначениеДляКраткогоОтображенияЭлементаНачалоВыбора(Элемент, СтандартнаяОбработка)
	
	мОтборНачалоВыбора(ЭтаФорма, Элемент, СтандартнаяОбработка);

КонецПроцедуры
//
Процедура КоманднаяПанельСортировкаДобавитьЭлемент(Кнопка)
	
	мДобавитьЭлементСортировки(ЭтаФорма, ЭтаФорма);
	
КонецПроцедуры

Процедура СортировкаПередНачаломДобавления(Элемент, Отказ, Копирование)
	
	мДобавитьЭлементСортировки(ЭтаФорма, Отказ);
	
КонецПроцедуры

Процедура СортировкаПередНачаломИзменения(Элемент, Отказ)
	
	мСортировкаПередНачаломИзменения(ЭтаФорма, Элемент, Отказ);	
	
КонецПроцедуры
 
Процедура СортировкаПриПолученииДанных(Элемент, ОформленияСтрок)
	
	мРаскраскаНедоступныхПриПолученииДанных(Элемент, ОформленияСтрок);
	
КонецПроцедуры
//
Процедура ФлагВыводитьЗаголовокПриИзменении(Элемент)
	
	НастройкиФормы.Вставить("ВыводитьЗаголовок", Элемент.Значение);

КонецПроцедуры

Процедура ФлагВыводитьПодписиПриИзменении(Элемент)
	
	НастройкиФормы.Вставить("ВыводитьПодписи", Элемент.Значение);
		
КонецПроцедуры

Процедура ПолеВыбораОформленияПриИзменении(Элемент)
	
	НастройкиФормы.Вставить("МакетОформления" , ЭлементыФормы.ПолеВыбораОформления.Значение);	
	
КонецПроцедуры

Процедура УсловноеОформлениеПриВыводеСтроки(Элемент, ОформлениеСтроки, ДанныеСтроки)
	
	мУсловноеОформлениеПриВыводеСтроки(ЭтаФорма, Элемент, ОформлениеСтроки, ДанныеСтроки);
	
КонецПроцедуры

Процедура УсловноеОформлениеПриПолученииДанных(Элемент, ОформленияСтрок)
	
	мРаскраскаНедоступныхПриПолученииДанных(Элемент, ОформленияСтрок);
	
КонецПроцедуры
//
Процедура ПолеВводаПериодПриИзменении(Элемент)
	
	ТиповыеОтчеты.ОбновитьПараметрыПериодаПоФорме(КН, ЭтаФорма);
	
КонецПроцедуры

Процедура КнопкаНастройкаПериодаНажатие(Элемент)
	
	ТиповыеОтчеты.НастроитьПериод(НастройкаПериода, НачалоПериода, КонецПериода);
	ТиповыеОтчеты.ОбновитьПараметрыПериодаПоФорме(КН, ЭтаФорма);
	
КонецПроцедуры
////
Процедура РезультатОбработкаРасшифровки(Элемент, Расшифровка, СтандартнаяОбработка)
	
	мОбработкаРасшифровкиСтандартногоОтчета(ЭтаФорма, Расшифровка, СтандартнаяОбработка);
	
КонецПроцедуры

Процедура РезультатПриАктивизацииОбласти(Элемент)
	
	мРезультатПриАктивизацииОбласти(ЭтаФорма, Элемент);
	
КонецПроцедуры

Расшифровки = Новый СписокЗначений;

НастройкаПериода = Новый НастройкаПериода;

РежимРасшифровки = Ложь;

ИдентификаторОбъекта  = "ОтчетОбъект.АнализСубконто";
ПредставлениеОтчета   = "Анализ субконто";

СхемаКД = ПолучитьМакет("АнализСубконто");
КН.Инициализировать(Новый ИсточникДоступныхНастроекКомпоновкиДанных(СхемаКД));
КН.ЗагрузитьНастройки(СхемаКД.НастройкиПоУмолчанию);

ЭлементыФормы.Отбор.Данные              = "КН.Настройки.Отбор";
ЭлементыФормы.Сортировка.Данные         = "КН.Настройки.Порядок";
ЭлементыФормы.УсловноеОформление.Данные = "КН.Настройки.УсловноеОформление";

Реквизиты = Новый Массив;
Реквизиты.Добавить("СписокВидовСубконто");
Реквизиты.Добавить("Организация");
Реквизиты.Добавить("НачалоПериода");
Реквизиты.Добавить("КонецПериода");
Реквизиты.Добавить("ПоСубсчетам");
Реквизиты.Добавить("НастройкиФормы");
Реквизиты.Добавить("ДанныеОтчета");
Реквизиты.Добавить("История");
Реквизиты.Добавить("Периодичность");