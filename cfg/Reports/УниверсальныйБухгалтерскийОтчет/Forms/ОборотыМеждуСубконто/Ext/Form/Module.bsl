Перем СохраненнаяНастройка Экспорт;
Перем Расшифровки Экспорт;
Перем РежимРасшифровки Экспорт;
Перем Реквизиты Экспорт;

Процедура ОбработкаИзмененияСоставаСубконто(ПолнаяОбработка = Истина) Экспорт
	
	МассивСубконто    = Новый Массив;
	МассивКорСубконто = Новый Массив;
	
	ИмяПоляПрефикс    = "Субконто";
	ИмяПоляПрефиксКор = "КорСубконто";
	
	// Изменение представления и наложения ограничения типа значения
	Индекс = 1;
	Для Каждого ВидСубконто Из СписокВидовСубконто Цикл
		Если ЗначениеЗаполнено(ВидСубконто.Значение) Тогда
			МассивСубконто.Добавить(ВидСубконто.Значение);
			Если ВидСубконто.Значение = ПланыВидовХарактеристик.ВидыСубконтоХозрасчетные.Номенклатура Тогда
				Поле = СхемаКД.НаборыДанных[0].Поля.Найти(ИмяПоляПрефикс + "2.Номенклатура");
			Иначе
				Поле = СхемаКД.НаборыДанных[0].Поля.Найти(ИмяПоляПрефикс + Индекс);
			КонецЕсли;
			Если Поле <> Неопределено Тогда
				Поле.ТипЗначения = ВидСубконто.Значение.ТипЗначения;
				Поле.Заголовок   = Строка(ВидСубконто.Значение);
			КонецЕсли;
			Индекс = Индекс + 1;
		КонецЕсли;
	КонецЦикла;
	
	// Изменение представления и наложения ограничения типа значения
	Индекс = 1;
	Для Каждого ВидСубконто Из СписокВидовКорСубконто Цикл
		Если ЗначениеЗаполнено(ВидСубконто.Значение) Тогда
			МассивКорСубконто.Добавить(ВидСубконто.Значение);
			Если ВидСубконто.Значение = ПланыВидовХарактеристик.ВидыСубконтоХозрасчетные.НоменклатурныеГруппы Тогда
				Поле = СхемаКД.НаборыДанных[0].Поля.Найти(ИмяПоляПрефиксКор + "2.Номенклатура");
			Иначе
				Поле = СхемаКД.НаборыДанных[0].Поля.Найти(ИмяПоляПрефиксКор + Индекс);
			КонецЕсли;
			Если Поле <> Неопределено Тогда
				Поле.ТипЗначения = ВидСубконто.Значение.ТипЗначения;
				Поле.Заголовок   = "Кор. " + Строка(ВидСубконто.Значение);
			КонецЕсли;
			Индекс = Индекс + 1;
		КонецЕсли;
	КонецЦикла;
	
	КН.Инициализировать(Новый ИсточникДоступныхНастроекКомпоновкиДанных(СхемаКД));
		
	// Управление показателями
	Запрос = Новый Запрос;
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	МАКСИМУМ(ВС1.Ссылка.НалоговыйУчет) КАК НалоговыйУчет
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
	
	ЕстьНалоговыйУчет        = Ложь;
	
	Если СписокВидовСубконто.Количество() = 0 Тогда
		ЕстьНалоговыйУчет        = Истина;
	Иначе
		ВыборкаСчета = Запрос.Выполнить().Выбрать();
		Пока ВыборкаСчета.Следующий() Цикл
			ЕстьНалоговыйУчет        = ?(ВыборкаСчета.НалоговыйУчет         = Истина, Истина, Ложь);
		КонецЦикла;
	КонецЕсли;
	
	ДанныеОтчета.ПоказателиОтчета.БУ.Использование            = Истина;
	ДанныеОтчета.ПоказателиОтчета.БУ.Значение                 = Истина;
	ДанныеОтчета.ПоказателиОтчета.НУ.Использование            = Истина;
	ДанныеОтчета.ПоказателиОтчета.НУ.Значение                 = Ложь;
	ДанныеОтчета.ПоказателиОтчета.ВалютнаяСумма.Использование = Истина;
	ДанныеОтчета.ПоказателиОтчета.ВалютнаяСумма.Значение      = Ложь;  
	
	КоличествоСубконто = МассивСубконто.Количество();
	
	
	// Добавление группировок с соответствии с выбранным счетом	
	ДанныеОтчета.Группировка.Очистить();
	
	Для Индекс = 1 По КоличествоСубконто Цикл
		НоваяСтрока = ДанныеОтчета.Группировка.Добавить();
		Если МассивСубконто[Индекс-1] = ПланыВидовХарактеристик.ВидыСубконтоХозрасчетные.Номенклатура Тогда
			Поле = КН.Настройки.ДоступныеПоляОтбора.НайтиПоле(Новый ПолеКомпоновкиДанных(ИмяПоляПрефикс + "2.Номенклатура"));
		Иначе
			Поле = КН.Настройки.ДоступныеПоляОтбора.НайтиПоле(Новый ПолеКомпоновкиДанных(ИмяПоляПрефикс + Индекс));
		КонецЕсли;
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
	
	Если Не РежимРасшифровки Тогда
		// Добавление неактивных отборов по субконто в соответствии с выбранным счетом
		ОтборыДляУдаления = Новый Массив;
		Для Каждого ЭлементОтбора Из КН.Настройки.Отбор.Элементы Цикл
			Если ТипЗнч(ЭлементОтбора) = Тип("ЭлементОтбораКомпоновкиДанных") Тогда 
					Если Найти(Строка(ЭлементОтбора.ЛевоеЗначение), "Субконто") = 1 ИЛИ Строка(ЭлементОтбора.ЛевоеЗначение) = "Валюта"
							ИЛИ (Найти(ЭлементОтбора.ЛевоеЗначение, "НалоговоеНазначение") = 1) Тогда
					ОтборыДляУдаления.Добавить(ЭлементОтбора);
				КонецЕсли;
			КонецЕсли;
		КонецЦикла;
		
		Для Каждого ЭлементОтбора Из ОтборыДляУдаления Цикл
			КН.Настройки.Отбор.Элементы.Удалить(ЭлементОтбора);
		КонецЦикла;
		
		Для Индекс = 1 По МассивСубконто.Количество() Цикл
			Если МассивСубконто[Индекс-1] = ПланыВидовХарактеристик.ВидыСубконтоХозрасчетные.Номенклатура Тогда
				Поле = КН.Настройки.ДоступныеПоляОтбора.НайтиПоле(Новый ПолеКомпоновкиДанных(ИмяПоляПрефикс + "2.Номенклатура"));
			Иначе
				Поле = КН.Настройки.ДоступныеПоляОтбора.НайтиПоле(Новый ПолеКомпоновкиДанных(ИмяПоляПрефикс + Индекс));
			КонецЕсли;
			мДобавитьОтбор(КН, ИмяПоляПрефикс + Индекс, МассивСубконто[Индекс - 1].ТипЗначения.ПривестиЗначение(Неопределено), , Ложь);	
		КонецЦикла;
			
		Если ЕстьНалоговыйУчет Тогда
			Поле = КН.Настройки.ДоступныеПоляОтбора.НайтиПоле(Новый ПолеКомпоновкиДанных("НалоговоеНазначение"));
			мДобавитьОтбор(КН, "НалоговоеНазначение", Поле.Тип.ПривестиЗначение(Неопределено), , Ложь); 
		КонецЕсли;
	КонецЕсли;
	
	КоличествоКорСубконто = МассивКорСубконто.Количество();
	
	Для Индекс = 1 По КоличествоКорСубконто Цикл
		НоваяСтрока = ДанныеОтчета.Группировка.Добавить();
		Если МассивКорСубконто[Индекс-1] = ПланыВидовХарактеристик.ВидыСубконтоХозрасчетные.НоменклатурныеГруппы Тогда
			Поле = КН.Настройки.ДоступныеПоляОтбора.НайтиПоле(Новый ПолеКомпоновкиДанных(ИмяПоляПрефиксКор + "2.Номенклатура"));
		Иначе
			Поле = КН.Настройки.ДоступныеПоляОтбора.НайтиПоле(Новый ПолеКомпоновкиДанных(ИмяПоляПрефиксКор + Индекс));
		КонецЕсли;
		НоваяСтрока.Поле           = Поле.Поле;
		НоваяСтрока.Использование  = Истина;
		НоваяСтрока.Представление  = Поле.Заголовок;
		НоваяСтрока.ТипГруппировки = ТипИзмеренияПостроителяОтчета.Элементы;
	КонецЦикла;
	
	Если Не РежимРасшифровки Тогда
		// Добавление неактивных отборов по субконто в соответствии с выбранным счетом
		ОтборыДляУдаления = Новый Массив;
		Для Каждого ЭлементОтбора Из КН.Настройки.Отбор.Элементы Цикл
			Если ТипЗнч(ЭлементОтбора) = Тип("ЭлементОтбораКомпоновкиДанных") Тогда 
					Если Найти(Строка(ЭлементОтбора.ЛевоеЗначение), "КорСубконто") = 1 ИЛИ Строка(ЭлементОтбора.ЛевоеЗначение) = "КорВалюта" 
							ИЛИ (Найти(ЭлементОтбора.ЛевоеЗначение, "НалоговоеНазначениеКор") = 1) Тогда
					ОтборыДляУдаления.Добавить(ЭлементОтбора);
				КонецЕсли;
			КонецЕсли;
		КонецЦикла;
		
		Для Каждого ЭлементОтбора Из ОтборыДляУдаления Цикл
			КН.Настройки.Отбор.Элементы.Удалить(ЭлементОтбора);
		КонецЦикла;
		
		Для Индекс = 1 По МассивКорСубконто.Количество() Цикл
			Если МассивКорСубконто[Индекс-1] = ПланыВидовХарактеристик.ВидыСубконтоХозрасчетные.НоменклатурныеГруппы Тогда
				Поле = КН.Настройки.ДоступныеПоляОтбора.НайтиПоле(Новый ПолеКомпоновкиДанных(ИмяПоляПрефиксКор + "2.Номенклатура"));
			Иначе
				Поле = КН.Настройки.ДоступныеПоляОтбора.НайтиПоле(Новый ПолеКомпоновкиДанных(ИмяПоляПрефиксКор + Индекс));
			КонецЕсли;
			мДобавитьОтбор(КН, ИмяПоляПрефиксКор + Индекс, МассивКорСубконто[Индекс - 1].ТипЗначения.ПривестиЗначение(Неопределено), , Ложь);	
		КонецЦикла;
	КонецЕсли;
	
	// Обработка дополнительных полей
	мЗаполнитьДополнительныеПоляПоУмолчанию(ЭтаФорма);
	
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
	//
	МакетШапкиОтчета = мПолучитьМакетШапки(МакетКомпоновки);
	
	СтрокаЗаголовкаГруппировки = "";
	Для Каждого СтрокаТаблицы Из ДанныеОтчета.Группировка Цикл
		Если СтрокаТаблицы.Использование Тогда
			СтрокаЗаголовкаГруппировки = СтрокаЗаголовкаГруппировки + СтрокаТаблицы.Представление + " \ ";
		КонецЕсли;
	КонецЦикла;
	
	СтрокаЗаголовкаГруппировки = Сред(СтрокаЗаголовкаГруппировки, 1, СтрДлина(СтрокаЗаголовкаГруппировки) - 2);
		
	Ячейка00 = МакетШапкиОтчета.Макет[0].Ячейки[0];
	Ячейка00.Элементы.Очистить();
	НовыйЭлемент = Ячейка00.Элементы.Добавить(Тип("ПолеОбластиКомпоновкиДанных"));
	НовыйЭлемент.Значение = СтрокаЗаголовкаГруппировки;

	//
	КоличествоПоказателей = 0;
	Для Каждого Показатель Из ПоказателиОтчета Цикл
		Если Показатель.Значение.Значение Тогда
			КоличествоПоказателей = КоличествоПоказателей + 1;
		КонецЕсли;
	КонецЦикла;
	
	Если КоличествоПоказателей = 1 Тогда 
		Для Каждого Макет Из МакетКомпоновки.Макеты Цикл
			Для Каждого СтрокаМакета Из Макет.Макет Цикл
				СтрокаМакета.Ячейки.Удалить(СтрокаМакета.Ячейки[2]);	
			КонецЦикла;
		КонецЦикла;
	КонецЕсли;
	
	МакетДетали = мПолучитьМакетГруппировкиПоПолюГруппировки(МакетКомпоновки, "Детали", Истина);
	Если МакетДетали.Количество() = 1 Тогда
		Для Каждого СтрокаМакета Из МакетДетали[0].Макет Цикл
			Для Каждого Ячейка Из СтрокаМакета.Ячейки Цикл
				ЗначениеПараметра = мПолучитьПараметр(Ячейка.Оформление.Элементы, "Расшифровка");
				
				ПараметрРасшифровки = МакетДетали[0].Параметры.Найти(ЗначениеПараметра.Значение);
				Если ТипЗнч(ПараметрРасшифровки) = Тип("ПараметрОбластиРасшифровкаКомпоновкиДанных") Тогда 
					Если ПараметрРасшифровки.ВыраженияПолей.Найти("Счет") = Неопределено Тогда 
						ПараметрСчет = ПараметрРасшифровки.ВыраженияПолей.Добавить();
						ПараметрСчет.Поле      = "Счет";
						ПараметрСчет.Выражение = "ОсновнойНабор.Счет";
					КонецЕсли;
					Если ПараметрРасшифровки.ВыраженияПолей.Найти("КорСчет") = Неопределено Тогда
						ПараметрКорСчет = ПараметрРасшифровки.ВыраженияПолей.Добавить();
						ПараметрКорСчет.Поле      = "КорСчет";
						ПараметрКорСчет.Выражение = "ОсновнойНабор.КорСчет";
					КонецЕсли;
				КонецЕсли;
			КонецЦикла;
		КонецЦикла;
	КонецЕсли;
	
	//
	Для Каждого Макет Из МакетКомпоновки.Макеты Цикл 
		Если МакетДетали.Найти(Макет) = Неопределено И Макет <> МакетШапкиОтчета Тогда
			Если ПоказателиОтчета.ВалютнаяСумма.Значение Тогда 
				Макет.Макет.Удалить(Макет.Макет[КоличествоПоказателей - 1]);
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
	//
	Если ЗначениеЗаполнено(НачалоПериода) Тогда
		мУстановитьПараметр(КН, "НачалоПериода", НачалоДня(НачалоПериода));
	КонецЕсли;
	Если ЗначениеЗаполнено(КонецПериода) Тогда
		мУстановитьПараметр(КН, "КонецПериода", КонецДня(КонецПериода));
	КонецЕсли;
	//
	МассивВидовСубконто = Новый Массив;
	Для Каждого ЭлементСписка Из СписокВидовСубконто Цикл
		Если ЗначениеЗаполнено(ЭлементСписка.Значение) Тогда 
			Если ЭлементСписка.Значение = ПланыВидовХарактеристик.ВидыСубконтоХозрасчетные.НоменклатурныеГруппы Тогда
				МассивВидовСубконто.Добавить(ПланыВидовХарактеристик.ВидыСубконтоХозрасчетные.Договоры);
			Иначе
				МассивВидовСубконто.Добавить(ЭлементСписка.Значение);
			КонецЕсли;
		КонецЕсли;
	КонецЦикла;
	
	МассивВидовКорСубконто = Новый Массив;
	Для Каждого ЭлементСписка Из СписокВидовКорСубконто Цикл
		Если ЗначениеЗаполнено(ЭлементСписка.Значение) Тогда 
			Если ЭлементСписка.Значение = ПланыВидовХарактеристик.ВидыСубконтоХозрасчетные.НоменклатурныеГруппы Тогда
				МассивВидовКорСубконто.Добавить(ПланыВидовХарактеристик.ВидыСубконтоХозрасчетные.Договоры);
			Иначе
				МассивВидовКорСубконто.Добавить(ЭлементСписка.Значение);
			КонецЕсли;
		КонецЕсли;
	КонецЦикла;
	
	Если МассивВидовСубконто.Количество() > 0 Тогда
		мУстановитьПараметр(КН, "СписокВидовСубконто", МассивВидовСубконто);
	КонецЕсли;
	Если МассивВидовКорСубконто.Количество() > 0 Тогда
		мУстановитьПараметр(КН, "СписокВидовКорСубконто", МассивВидовКорСубконто);
	КонецЕсли;
	
	ПоказателиОтчета = ДанныеОтчета.ПоказателиОтчета;
	//
	КоличествоПоказателей = 0;
	КоличествоВидовУчета = 0;
	Для Каждого Показатель Из ПоказателиОтчета Цикл
		Если Показатель.Ключ <> "Развернутое сальдо" Тогда
			КоличествоПоказателей = КоличествоПоказателей + Показатель.Значение.Значение;
			Если Найти(Показатель.Ключ, "Данные") > 0 Тогда
				КоличествоВидовУчета = КоличествоВидовУчета + 1;
			КонецЕсли;
		КонецЕсли;
	КонецЦикла;
		
	МассивПоказателей = Новый Массив;
	МассивПоказателей.Добавить("БУ");
	МассивПоказателей.Добавить("НУ");
	МассивПоказателей.Добавить("ВалютнаяСумма");
		
	ПоказателиОтчета = ДанныеОтчета.ПоказателиОтчета;
	
	КоличествоПоказателей = 0;
	Для Каждого Показатель Из ПоказателиОтчета Цикл
		Если Показатель.Ключ <> "РазвернутоеСальдо" Тогда
			КоличествоПоказателей = КоличествоПоказателей + Показатель.Значение.Значение;
		КонецЕсли;
	КонецЦикла;
	
	// Колонка "показатели"
	ГруппаПоказатели = КН.Настройки.Выбор.Элементы.Добавить(Тип("ГруппаВыбранныхПолейКомпоновкиДанных"));
	ГруппаПоказатели.Использование = Истина;
	ГруппаПоказатели.Расположение  = РасположениеПоляКомпоновкиДанных.Вертикально;
	
	Для Каждого ЭлементМассива Из МассивПоказателей Цикл
		Если ПоказателиОтчета[ЭлементМассива].Значение И ЭлементМассива <> "ВалютнаяСумма" Тогда 
			мДобавитьВыбранноеПоле(ГруппаПоказатели, "Показатели." + ЭлементМассива);
		КонецЕсли;
	КонецЦикла;	
	
	ГруппаДт = КН.Настройки.Выбор.Элементы.Добавить(Тип("ГруппаВыбранныхПолейКомпоновкиДанных"));
	ГруппаДт.Заголовок     = "Дебет";
	ГруппаДт.Использование = Истина;
	ГруппаДт.Расположение  = РасположениеПоляКомпоновкиДанных.Вертикально;
	
	ГруппаКт = КН.Настройки.Выбор.Элементы.Добавить(Тип("ГруппаВыбранныхПолейКомпоновкиДанных"));
	ГруппаКт.Заголовок     = "Кредит";
	ГруппаКт.Использование = Истина;
	ГруппаКт.Расположение  = РасположениеПоляКомпоновкиДанных.Вертикально;
	
	Для Каждого ЭлементМассива Из МассивПоказателей Цикл
		Если ПоказателиОтчета[ЭлементМассива].Значение И ЭлементМассива <> "ВалютнаяСумма" Тогда
			мДобавитьВыбранноеПоле(ГруппаДт, "ОборотыЗаПериод." + ЭлементМассива + "ОборотДт");
			мДобавитьВыбранноеПоле(ГруппаКт, "ОборотыЗаПериод." + ЭлементМассива + "ОборотКт");
		КонецЕсли;
	КонецЦикла;

	//
	Для Каждого ПолеГруппировки Из ДанныеОтчета.ДополнительныеПоля Цикл 
		Если ПолеГруппировки.Использование Тогда
			мДобавитьВыбранноеПоле(КН, ПолеГруппировки.Поле);
		КонецЕсли;
	КонецЦикла;
	//
	Структура = КН.Настройки.Структура.Добавить(Тип("ГруппировкаКомпоновкиДанных"));
	Структура.Имя = "ШапкаОтчета";
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
	Структура.Имя = "Детали";
	//ПолеГруппировки = Структура.ПоляГруппировки.Элементы.Добавить(Тип("ПолеГруппировкиКомпоновкиДанных"));
	//ПолеГруппировки.Использование  = Истина;
	//ПолеГруппировки.Поле           = Новый ПолеКомпоновкиДанных("Счет");
	//ПолеГруппировки = Структура.ПоляГруппировки.Элементы.Добавить(Тип("ПолеГруппировкиКомпоновкиДанных"));
	//ПолеГруппировки.Использование  = Истина;
	//ПолеГруппировки.Поле           = Новый ПолеКомпоновкиДанных("КорСчет");
	мДобавитьВыбранноеПоле(Структура.Выбор,  "Счет");
	мДобавитьВыбранноеПоле(Структура.Выбор,  "КорСчет");
	
	ГруппаПоказатели = Структура.Выбор.Элементы.Добавить(Тип("ГруппаВыбранныхПолейКомпоновкиДанных"));
	ГруппаПоказатели.Заголовок     = "Показатели";
	ГруппаПоказатели.Использование = Истина;
	ГруппаПоказатели.Расположение  = РасположениеПоляКомпоновкиДанных.Вертикально;
	
	// Колонка "показатели"
	Если КоличествоПоказателей > 1 Тогда
		ГруппаПоказатели = Структура.Выбор.Элементы.Добавить(Тип("ГруппаВыбранныхПолейКомпоновкиДанных"));
		ГруппаПоказатели.Использование = Истина;
		ГруппаПоказатели.Расположение  = РасположениеПоляКомпоновкиДанных.Вертикально;
		
		Для Каждого ЭлементМассива Из МассивПоказателей Цикл
			Если ПоказателиОтчета[ЭлементМассива].Значение Тогда 
				мДобавитьВыбранноеПоле(ГруппаПоказатели, "Показатели." + ЭлементМассива);
			КонецЕсли;
		КонецЦикла;	
	КонецЕсли;
	
	ГруппаДт = Структура.Выбор.Элементы.Добавить(Тип("ГруппаВыбранныхПолейКомпоновкиДанных"));
	ГруппаДт.Заголовок     = "Дебет";
	ГруппаДт.Использование = Истина;
	ГруппаДт.Расположение  = РасположениеПоляКомпоновкиДанных.Вертикально;
	
	ГруппаКт = Структура.Выбор.Элементы.Добавить(Тип("ГруппаВыбранныхПолейКомпоновкиДанных"));
	ГруппаКт.Заголовок     = "Кредит";
	ГруппаКт.Использование = Истина;
	ГруппаКт.Расположение  = РасположениеПоляКомпоновкиДанных.Вертикально;
	
	Для Каждого ЭлементМассива Из МассивПоказателей Цикл
		Если ПоказателиОтчета[ЭлементМассива].Значение Тогда
			мДобавитьВыбранноеПоле(ГруппаДт, "ОборотыЗаПериод." + ЭлементМассива + "ОборотДт");
			мДобавитьВыбранноеПоле(ГруппаКт, "ОборотыЗаПериод." + ЭлементМассива + "ОборотКт");
		КонецЕсли;
	КонецЦикла;
	
	Структура.Порядок.Элементы.Добавить(Тип("АвтоЭлементПорядкаКомпоновкиДанных"));  
	
	УсловноеОформление = КН.Настройки.УсловноеОформление.Элементы.Добавить();	
	Поле = УсловноеОформление.Поля.Элементы.Добавить();
	Поле.Поле = Новый ПолеКомпоновкиДанных("ОборотыЗаПериод.НУОборотДт");
	Поле = УсловноеОформление.Поля.Элементы.Добавить();
	Поле.Поле = Новый ПолеКомпоновкиДанных("ОборотыЗаПериод.ПРОборотДт");
	Поле = УсловноеОформление.Поля.Элементы.Добавить();
	Поле.Поле = Новый ПолеКомпоновкиДанных("ОборотыЗаПериод.ВРОборотДт");
	
	мДобавитьОтбор(УсловноеОформление.Отбор, "ЕстьНалоговыйУчет", 0);
	мУстановитьПараметр(УсловноеОформление.Оформление, "МаксимальнаяВысота", 1);
	
	УсловноеОформление = КН.Настройки.УсловноеОформление.Элементы.Добавить();	
	Поле = УсловноеОформление.Поля.Элементы.Добавить();
	Поле.Поле = Новый ПолеКомпоновкиДанных("ОборотыЗаПериод.КоличествоОборотДт");
	
	мУстановитьПараметр(УсловноеОформление.Оформление, "МаксимальнаяВысота", 1);
	
	УсловноеОформление = КН.Настройки.УсловноеОформление.Элементы.Добавить();	
	Поле = УсловноеОформление.Поля.Элементы.Добавить();
	Поле.Поле = Новый ПолеКомпоновкиДанных("ОборотыЗаПериод.ВалютнаяСуммаОборотДт");
	
	мДобавитьОтбор(УсловноеОформление.Отбор, "ЕстьВалюта", 0);
	мУстановитьПараметр(УсловноеОформление.Оформление, "МаксимальнаяВысота", 1);
	
КонецПроцедуры

Процедура ВыводЗаголовкаОтчета(ФормаОтчета, Результат)
	
	 мВыводЗаголовкаОтчета(ФормаОтчета, Результат);
			
КонецПроцедуры

Процедура ВыводПодписейОтчета(ФормаОтчета, Результат)
	
	мВыводПодписейОтчета(ФормаОтчета, Результат);
			
КонецПроцедуры

Функция ПолучитьТекстЗаголовка(ОрганизацияВНачале = Истина) Экспорт 
	
	ЗаголовокОтчета = "Обороты между субконто" + мПолучитьПредставлениеПериода(ЭтаФорма);

	Возврат ЗаголовокОтчета;
	
КонецФункции

Процедура ПолучитьСтруктуруПоказателейОтчета() Экспорт
	
	ПоказателиОтчета = мПолучитьСтруктуруПоказателейОтчета(,, Ложь, Истина, Ложь);
	ДанныеОтчета.Вставить("ПоказателиОтчета", ПоказателиОтчета);

КонецПроцедуры

Процедура ОбработкаРезультатаОтчета(Результат)
	
	мОбработкаРезультатаОтчета(ЭтаФорма, Результат);
	
	Индекс = Результат.ВысотаТаблицы;
	Пока Индекс > 0 Цикл
		ИндексСтроки = "R" + Формат(Индекс,"ЧГ=0");
		Если Результат.Область(ИндексСтроки).ВысотаСтроки = 1 Тогда
			Результат.УдалитьОбласть(Результат.Область(ИндексСтроки), ТипСмещенияТабличногоДокумента.ПоВертикали);
		КонецЕсли;
		Индекс = Индекс - 1;
	КонецЦикла;
	
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
	Группировка = ДанныеОтчета.Группировка.Скопировать();
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
Процедура СписокВидовКорСубконтоПередНачаломДобавления(Элемент, Отказ, Копирование)
	
	Если СписокВидовКорСубконто.Количество() >= 3 Тогда 
		Отказ = Истина;
	КонецЕсли;
	
КонецПроцедуры

Процедура СписокВидовКорСубконтоПриОкончанииРедактирования(Элемент, НоваяСтрока, ОтменаРедактирования)
	
	ОбработкаИзмененияСоставаСубконто();
	ОбновитьПанельНастроек();
	
КонецПроцедуры

Процедура СписокВидовКорСубконтоПослеУдаления(Элемент)
	
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

ИдентификаторОбъекта  = "ОтчетОбъект.ОборотыМеждуСубконто";
ПредставлениеОтчета   = "Обороты между субконто";

СхемаКД = ПолучитьМакет("ОборотыМеждуСубконто");
КН.Инициализировать(Новый ИсточникДоступныхНастроекКомпоновкиДанных(СхемаКД));
КН.ЗагрузитьНастройки(СхемаКД.НастройкиПоУмолчанию);

ЭлементыФормы.Отбор.Данные              = "КН.Настройки.Отбор";
ЭлементыФормы.Сортировка.Данные         = "КН.Настройки.Порядок";
ЭлементыФормы.УсловноеОформление.Данные = "КН.Настройки.УсловноеОформление";

Реквизиты = Новый Массив;
Реквизиты.Добавить("СписокВидовСубконто");
Реквизиты.Добавить("СписокВидовКорСубконто");
Реквизиты.Добавить("Организация");
Реквизиты.Добавить("НачалоПериода");
Реквизиты.Добавить("КонецПериода");
Реквизиты.Добавить("НастройкиФормы");
Реквизиты.Добавить("ДанныеОтчета");
Реквизиты.Добавить("История");