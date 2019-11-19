﻿////////////////////////////////////////////////////////////////////////////////
// ПРОЦЕДУРЫ И ФУНКЦИИ ОБЩЕГО НАЗНАЧЕНИЯ

// Устанавливает вид сравнения "ВИехарархии" для отбора по счету. 
//
Процедура УставновитьВидСравненияВИерархии()

	Если Отбор.Счет.Использование Тогда
		Отбор.Счет.ВидСравнения = ВидСравнения.ВИерархии;
	КонецЕсли;

КонецПроцедуры // УставновитьВидСравненияВИерархии()

// Добавляет в запрос условие отбора.
//
Процедура ДобавитьУсловие(ТекстПериода, Отбор, ЭлементОтбора, Запрос, НомерСубконто = "", ТипУсловия = "И")

	Сравнение = ЭлементОтбора.ВидСравнения;
	ИмяОтбора = ЭлементОтбора.Имя;
	
	Если ИмяОтбора = "Субконто1" Тогда
		ИмяОтбора = "Субконто";
		Дт = "Дт" + НомерСубконто;
		Кт = "Кт" + НомерСубконто;
		
	ИначеЕсли ИмяОтбора = "ВидСубконто1" Тогда
		ИмяОтбора = "ВидСубконто";
		Дт = "Дт" + НомерСубконто;
		Кт = "Кт" + НомерСубконто;
		
	Иначе
		Дт = "Дт";
		Кт = "Кт";
	КонецЕсли;
	
	МетаданныеПоляОтбора = Метаданные.РегистрыБухгалтерии.Хозрасчетный.Измерения.Найти(ЭлементОтбора.ПутьКДанным);
	Если МетаданныеПоляОтбора = Неопределено Тогда
		МетаданныеПоляОтбора = Метаданные.РегистрыБухгалтерии.Хозрасчетный.Ресурсы.Найти(ЭлементОтбора.ПутьКДанным);
	КонецЕсли;
	
	Если МетаданныеПоляОтбора = Неопределено Тогда
		МетаданныеПоляОтбора = Метаданные.РегистрыБухгалтерии.Хозрасчетный.Реквизиты.Найти(ЭлементОтбора.ПутьКДанным);
		Если МетаданныеПоляОтбора = Неопределено Тогда
			Балансовый = Не Метаданные.РегистрыБухгалтерии.Хозрасчетный.Корреспонденция;
			
		Иначе
			Балансовый = Истина;
		КонецЕсли;
		
	Иначе
		Балансовый = МетаданныеПоляОтбора.Балансовый;
	КонецЕсли;

	Если Сравнение = ВидСравнения.Равно Тогда
		Если Балансовый Тогда
			ТекстПериода = ТекстПериода + "
			|			"+ТипУсловия+" Хозрасчетный."+ИмяОтбора+" = &"+ИмяОтбора;
			
		Иначе
			ТекстПериода = ТекстПериода + "
			|			"+ТипУсловия+" (Хозрасчетный."+ИмяОтбора+Дт+" = &"+ИмяОтбора+" ИЛИ "+"Хозрасчетный."+ИмяОтбора+Кт+" = &"+ИмяОтбора+")";
		КонецЕсли;
		Запрос.УстановитьПараметр(ИмяОтбора, ЭлементОтбора.Значение);

	ИначеЕсли Сравнение = ВидСравнения.НеРавно Тогда
		Если Балансовый Тогда
			ТекстПериода = ТекстПериода + "
			|			"+ТипУсловия+" Хозрасчетный."+ИмяОтбора+" <> &"+ИмяОтбора;
			
		Иначе
			ТекстПериода = ТекстПериода + "
			|			"+ТипУсловия+" (Хозрасчетный."+ИмяОтбора+Дт+" <> &"+ИмяОтбора+" ИЛИ "+"Хозрасчетный."+ИмяОтбора+Кт+" <> &"+ИмяОтбора+")";
		КонецЕсли;
		
		Запрос.УстановитьПараметр(ИмяОтбора, ЭлементОтбора.Значение);

	ИначеЕсли Сравнение = ВидСравнения.Меньше Тогда
		Если Балансовый Тогда
			ТекстПериода = ТекстПериода + "
			|			"+ТипУсловия+" Хозрасчетный."+ИмяОтбора+" < &"+ИмяОтбора;
			
		Иначе
			ТекстПериода = ТекстПериода + "
			|			"+ТипУсловия+" (Хозрасчетный."+ИмяОтбора+Дт+" < &"+ИмяОтбора+" ИЛИ "+"Хозрасчетный."+ИмяОтбора+Кт+" < &"+ИмяОтбора+")";
		КонецЕсли;
		
		Запрос.УстановитьПараметр(ИмяОтбора, ЭлементОтбора.Значение);

	ИначеЕсли Сравнение = ВидСравнения.МеньшеИлиРавно Тогда
		Если Балансовый Тогда
			ТекстПериода = ТекстПериода + "
			|			"+ТипУсловия+" Хозрасчетный."+ИмяОтбора+" <= &"+ИмяОтбора;
			
		Иначе
			ТекстПериода = ТекстПериода + "
			|			"+ТипУсловия+" (Хозрасчетный."+ИмяОтбора+Дт+" <= &"+ИмяОтбора+" ИЛИ "+"Хозрасчетный."+ИмяОтбора+Кт+" <= &"+ИмяОтбора+")";
		КонецЕсли;

		Запрос.УстановитьПараметр(ИмяОтбора, ЭлементОтбора.Значение);

	ИначеЕсли Сравнение = ВидСравнения.Больше Тогда
		Если Балансовый Тогда
			ТекстПериода = ТекстПериода + "
			|			"+ТипУсловия+" Хозрасчетный."+ИмяОтбора+" > &"+ИмяОтбора;
			
		Иначе
			ТекстПериода = ТекстПериода + "
			|			"+ТипУсловия+" (Хозрасчетный."+ИмяОтбора+Дт+" > &"+ИмяОтбора+" ИЛИ "+"Хозрасчетный."+ИмяОтбора+Кт+" > &"+ИмяОтбора+")";
		КонецЕсли;

		Запрос.УстановитьПараметр(ИмяОтбора, ЭлементОтбора.Значение);

	ИначеЕсли Сравнение = ВидСравнения.БольшеИлиРавно Тогда
		Если Балансовый Тогда
			ТекстПериода = ТекстПериода + "
			|			"+ТипУсловия+" Хозрасчетный."+ИмяОтбора+" >= &"+ИмяОтбора;
			
		Иначе
			ТекстПериода = ТекстПериода + "
			|			"+ТипУсловия+" (Хозрасчетный."+ИмяОтбора+Дт+" >= &"+ИмяОтбора+" ИЛИ "+"Хозрасчетный."+ИмяОтбора+Кт+" >= &"+ИмяОтбора+")";
		КонецЕсли;

		Запрос.УстановитьПараметр(ИмяОтбора, ЭлементОтбора.Значение);

	ИначеЕсли Сравнение = ВидСравнения.Интервал Тогда
		Если Балансовый Тогда
			ТекстПериода = ТекстПериода + "
			|			"+ТипУсловия+" (Хозрасчетный."+ИмяОтбора+" > &Нач"+ИмяОтбора+" И
			|			Хозрасчетный."+ИмяОтбора+" < &Кон"+ИмяОтбора+")";
			
		Иначе
			ТекстПериода = ТекстПериода + "
			|			"+ТипУсловия+" ((Хозрасчетный."+ИмяОтбора+Дт+" > &Нач"+ИмяОтбора+" И "+"Хозрасчетный."+ИмяОтбора+Дт+" < &Кон"+ИмяОтбора+")
			|			ИЛИ (Хозрасчетный."+ИмяОтбора+Кт+" > &Нач"+ИмяОтбора+" И "+"Хозрасчетный."+ИмяОтбора+Кт+" < &Кон"+ИмяОтбора+"))";
		КонецЕсли;
		
		Запрос.УстановитьПараметр("Нач"+ИмяОтбора, ЭлементОтбора.ЗначениеС);
		Запрос.УстановитьПараметр("Кон"+ИмяОтбора, ЭлементОтбора.ЗначениеПо);

	ИначеЕсли Сравнение = ВидСравнения.ИнтервалВключаяГраницы Тогда
		Если Балансовый Тогда
			ТекстПериода = ТекстПериода + "
			|			"+ТипУсловия+" (Хозрасчетный."+ИмяОтбора+" >= &Нач"+ИмяОтбора+" И
			|			Хозрасчетный."+ИмяОтбора+" <= &Кон"+ИмяОтбора+")";
			
		Иначе
			ТекстПериода = ТекстПериода + "
			|			"+ТипУсловия+" ((Хозрасчетный."+ИмяОтбора+Дт+" >= &Нач"+ИмяОтбора+" И "+"Хозрасчетный."+ИмяОтбора+Дт+" <= &Кон"+ИмяОтбора+")
			|			ИЛИ (Хозрасчетный."+ИмяОтбора+Кт+" >= &Нач"+ИмяОтбора+" И "+"Хозрасчетный."+ИмяОтбора+Кт+" <= &Кон"+ИмяОтбора+"))";
		КонецЕсли;

		Запрос.УстановитьПараметр("Нач"+ИмяОтбора, ЭлементОтбора.ЗначениеС);
		Запрос.УстановитьПараметр("Кон"+ИмяОтбора, ЭлементОтбора.ЗначениеПо);

	ИначеЕсли Сравнение = ВидСравнения.ИнтервалВключаяНачало Тогда
		Если Балансовый Тогда
			ТекстПериода = ТекстПериода + "
			|			"+ТипУсловия+" (Хозрасчетный."+ИмяОтбора+" >= &Нач"+ИмяОтбора+" И
			|			Хозрасчетный."+ИмяОтбора+" < &Кон"+ИмяОтбора+")";
			
		Иначе
			ТекстПериода = ТекстПериода + "
			|			"+ТипУсловия+" ((Хозрасчетный."+ИмяОтбора+Дт+" >= &Нач"+ИмяОтбора+" И "+"Хозрасчетный."+ИмяОтбора+Дт+" < &Кон"+ИмяОтбора+")
			|			ИЛИ (Хозрасчетный."+ИмяОтбора+Кт+" >= &Нач"+ИмяОтбора+" И "+"Хозрасчетный."+ИмяОтбора+Кт+" < &Кон"+ИмяОтбора+"))";
		КонецЕсли;

		Запрос.УстановитьПараметр("Нач"+ИмяОтбора, ЭлементОтбора.ЗначениеС);
		Запрос.УстановитьПараметр("Кон"+ИмяОтбора, ЭлементОтбора.ЗначениеПо);

	ИначеЕсли Сравнение = ВидСравнения.ИнтервалВключаяОкончание Тогда
		Если Балансовый Тогда
			ТекстПериода = ТекстПериода + "
			|			"+ТипУсловия+" (Хозрасчетный."+ИмяОтбора+" > &Нач"+ИмяОтбора+" И
			|			Хозрасчетный."+ИмяОтбора+" <= &Кон"+ИмяОтбора+")";
			
		Иначе
			ТекстПериода = ТекстПериода + "
			|			"+ТипУсловия+" ((Хозрасчетный."+ИмяОтбора+Дт+" > &Нач"+ИмяОтбора+" И "+"Хозрасчетный."+ИмяОтбора+Дт+" <= &Кон"+ИмяОтбора+")
			|			ИЛИ (Хозрасчетный."+ИмяОтбора+Кт+" > &Нач"+ИмяОтбора+" И "+"Хозрасчетный."+ИмяОтбора+Кт+" <= &Кон"+ИмяОтбора+"))";
		КонецЕсли;

		Запрос.УстановитьПараметр("Нач"+ИмяОтбора, ЭлементОтбора.ЗначениеС);
		Запрос.УстановитьПараметр("Кон"+ИмяОтбора, ЭлементОтбора.ЗначениеПо);

	ИначеЕсли Сравнение = ВидСравнения.ВСписке Тогда
		Если Балансовый Тогда
			ТекстПериода = ТекстПериода + "
			|			"+ТипУсловия+" Хозрасчетный."+ИмяОтбора+" В (&Список"+ИмяОтбора+")";
			
		Иначе
			ТекстПериода = ТекстПериода + "
			|			"+ТипУсловия+" (Хозрасчетный."+ИмяОтбора+Дт+" В (&Список"+ИмяОтбора+") ИЛИ "+"Хозрасчетный."+ИмяОтбора+Кт+" В (&Список"+ИмяОтбора+"))";
		КонецЕсли;

		Запрос.УстановитьПараметр("Список"+ИмяОтбора, ЭлементОтбора.Значение);

	ИначеЕсли Сравнение = ВидСравнения.НеВСписке Тогда
		Если Балансовый Тогда
			ТекстПериода = ТекстПериода + "
			|			"+ТипУсловия+" Хозрасчетный."+ИмяОтбора+" НЕ В (&Список"+ИмяОтбора+")";
			
		Иначе
			ТекстПериода = ТекстПериода + "
			|			"+ТипУсловия+" (Хозрасчетный."+ИмяОтбора+Дт+" НЕ В (&Список"+ИмяОтбора+") ИЛИ "+"Хозрасчетный."+ИмяОтбора+Кт+" НЕ В (&Список"+ИмяОтбора+"))";
		КонецЕсли;

		Запрос.УстановитьПараметр("Список"+ИмяОтбора, ЭлементОтбора.Значение);

	КонецЕсли;

КонецПроцедуры // ДобавитьУсловие()

////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ ФОРМЫ

// Обработчик события "ПриОткрытии" формы.
//
Процедура ПриОткрытии()

	// Проверка однофирменности
	РаботаСДиалогами.УстановитьОтборПоОрганизации(ЭтаФорма, глЗначениеПеременной("УчетПоВсемОрганизациям"), глЗначениеПеременной("ОсновнаяОрганизация"), "РегистрБухгалтерииСписок");
	ЭлементыФормы.Организация.ТолькоПросмотр = НЕ глЗначениеПеременной("УчетПоВсемОрганизациям");

	ЭлементыФормы.ИспользованиеОтбораОрганизация.Доступность = глЗначениеПеременной("УчетПоВсемОрганизациям");

КонецПроцедуры // ПриОткрытии()

////////////////////////////////////////////////////////////////////////////////
// ДЕЙСТВИЯ КОМАНДНЫХ ПАНЕЛЕЙ ФОРМЫ

// Обработчик нажатия на кнопку "Найти в списке документов".
//
Процедура КоманднаяПанельНайтиВСпискеДокументов(Кнопка)

	Если ЭлементыФормы.РегистрБухгалтерииСписок.ТекущиеДанные = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	Документ = ЭлементыФормы.РегистрБухгалтерииСписок.ТекущиеДанные.Регистратор;

	ФормаСписка = Документы[Документ.Метаданные().Имя].ПолучитьФормуСписка();
	ФормаСписка.ПараметрТекущаяСтрока = Документ;
	ФормаСписка.Открыть();

КонецПроцедуры // КоманднаяПанельНайтиВСпискеДокументов()

// Обработчик нажатия на кнопку "Переключить активность проводок" командной
// панели формы.
Процедура КоманднаяПанельПереключитьАктивность(Кнопка)
	
	Если ЭлементыФормы.РегистрБухгалтерииСписок.ТекущиеДанные = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	Документ = ЭлементыФормы.РегистрБухгалтерииСписок.ТекущиеДанные.Регистратор;

	БухгалтерскийУчет.ПереключитьАктивностьПроводокБУ(Документ);

КонецПроцедуры // КоманднаяПанельПереключитьАктивность()

// Обработчик нажатия на кнопку "Проверка проводок" командной панели формы.
//
Процедура ПроверкаПроводок(Кнопка)

	Запрос       = Новый Запрос();
	ТекстПериода = "";

	Для Каждого ЭлементОтбора из Отбор Цикл

		Если НЕ ЭлементОтбора.Использование Тогда
			Продолжить;
		КонецЕсли;

		Если Найти("Период, Счет, Активность, Регистратор, СчетДт, СчетКт, Организация, Сумма, Содержание, НомерЖурнала", ЭлементОтбора.Имя) > 0 Тогда
			Сообщить(Локализация.СтрШаблон(НСтр("ru='Отбор ""¤1¤"" не учитывается при проверке проводок.';uk='Відбір ""¤1¤"" не враховується при перевірці проводок.'"), ЭлементОтбора.Представление), СтатусСообщения.Информация);
			Продолжить;
		КонецЕсли;

		ДобавитьУсловие(ТекстПериода, Отбор, ЭлементОтбора, Запрос)

	КонецЦикла;

	Если НЕ ПустаяСтрока(ТекстПериода) Тогда
		ТекстПериода = Сред(ТекстПериода, 6);
	КонецЕсли;

	ТекстЗапроса =
	"ВЫБРАТЬ
	|	Хозрасчетный.СчетДт,
	|	Хозрасчетный.СчетКт,
	|	Хозрасчетный.СчетДт.Код КАК КодДт,
	|	Хозрасчетный.СчетКт.Код КАК КодКт,
	|	Хозрасчетный.Содержание КАК Комментарий,
	|	СУММА(1) КАК ВесПроводки
	|ИЗ
	|	РегистрБухгалтерии.Хозрасчетный КАК Хозрасчетный
	|		ЛЕВОЕ СОЕДИНЕНИЕ (ВЫБРАТЬ
	|			Хозрасчетный.СчетДт КАК СчетДт,
	|			Хозрасчетный.СчетКт КАК СчетКт
	|		ИЗ
	|			РегистрБухгалтерии.Хозрасчетный КАК Хозрасчетный
	|				ВНУТРЕННЕЕ СОЕДИНЕНИЕ РегистрСведений.КорректныеКорреспонденцииСчетов КАК КорректныеКорреспонденцииСчетов
	|				ПО (Хозрасчетный.СчетДт = КорректныеКорреспонденцииСчетов.СчетДт 
	|				или Хозрасчетный.СчетДт.Родитель = КорректныеКорреспонденцииСчетов.СчетДт 
	|				или Хозрасчетный.СчетДт.Родитель.Родитель = КорректныеКорреспонденцииСчетов.СчетДт 
	|				или Хозрасчетный.СчетДт.Родитель.Родитель.Родитель = КорректныеКорреспонденцииСчетов.СчетДт
	|				или Хозрасчетный.СчетДт.Родитель.Родитель.Родитель.Родитель = КорректныеКорреспонденцииСчетов.СчетДт) 
	|				И (Хозрасчетный.СчетКт = КорректныеКорреспонденцииСчетов.СчетКт 
	|				или Хозрасчетный.СчетКт.Родитель = КорректныеКорреспонденцииСчетов.СчетКт 
	|				или Хозрасчетный.СчетКт.Родитель.Родитель = КорректныеКорреспонденцииСчетов.СчетКт 
	|				или Хозрасчетный.СчетКт.Родитель.Родитель.Родитель = КорректныеКорреспонденцииСчетов.СчетКт
	|				или Хозрасчетный.СчетКт.Родитель.Родитель.Родитель.Родитель = КорректныеКорреспонденцииСчетов.СчетКт)"
	+ ?(ПустаяСтрока(ТекстПериода) = Ложь, "
	|		ГДЕ", "") + ТекстПериода + "
	|
	|		ОБЪЕДИНИТЬ
	|
	|		ВЫБРАТЬ
	|			Хозрасчетный.СчетДт,
	|			Хозрасчетный.СчетКт
	|		ИЗ
	|			РегистрБухгалтерии.Хозрасчетный КАК Хозрасчетный
	|				ВНУТРЕННЕЕ СОЕДИНЕНИЕ РегистрСведений.КорректныеКорреспонденцииСчетов КАК КорректныеКорреспонденцииСчетов
	|				ПО (Хозрасчетный.СчетДт = КорректныеКорреспонденцииСчетов.СчетДт 
	|				или Хозрасчетный.СчетДт.Родитель = КорректныеКорреспонденцииСчетов.СчетДт 
	|				или Хозрасчетный.СчетДт.Родитель.Родитель = КорректныеКорреспонденцииСчетов.СчетДт 
	|				или Хозрасчетный.СчетДт.Родитель.Родитель.Родитель = КорректныеКорреспонденцииСчетов.СчетДт
	|				или Хозрасчетный.СчетДт.Родитель.Родитель.Родитель.Родитель = КорректныеКорреспонденцииСчетов.СчетДт) 
	|				И (КорректныеКорреспонденцииСчетов.СчетКт = &ПустаяСсылка)"
	+ ?(ПустаяСтрока(ТекстПериода) = Ложь, "
	|		ГДЕ", "") + ТекстПериода + "
	|
	|		ОБЪЕДИНИТЬ
	|
	|		ВЫБРАТЬ
	|			Хозрасчетный.СчетДт,
	|			Хозрасчетный.СчетКт
	|		ИЗ
	|			РегистрБухгалтерии.Хозрасчетный КАК Хозрасчетный
	|				ВНУТРЕННЕЕ СОЕДИНЕНИЕ РегистрСведений.КорректныеКорреспонденцииСчетов КАК КорректныеКорреспонденцииСчетов
	|				ПО (КорректныеКорреспонденцииСчетов.СчетДт = &ПустаяСсылка) 
	|				И (Хозрасчетный.СчетКт = КорректныеКорреспонденцииСчетов.СчетКт 
	|				или Хозрасчетный.СчетКт.Родитель = КорректныеКорреспонденцииСчетов.СчетКт 
	|				или Хозрасчетный.СчетКт.Родитель.Родитель = КорректныеКорреспонденцииСчетов.СчетКт 
	|				или Хозрасчетный.СчетКт.Родитель.Родитель.Родитель = КорректныеКорреспонденцииСчетов.СчетКт
	|				или Хозрасчетный.СчетКт.Родитель.Родитель.Родитель.Родитель = КорректныеКорреспонденцииСчетов.СчетКт)"
	+ ?(ПустаяСтрока(ТекстПериода) = Ложь, "
	|		ГДЕ", "") + ТекстПериода + ") КАК Проверенные
	|		ПО Проверенные.СчетКт = Хозрасчетный.СчетКт И Проверенные.СчетДт = Хозрасчетный.СчетДт
	|ГДЕ
	|	((Проверенные.СчетКт) ЕСТЬ NULL )" + ?(ПустаяСтрока(ТекстПериода) = Ложь, " И", "") + ТекстПериода;

	ТекстЗапроса = ТекстЗапроса + "
	|
	|СГРУППИРОВАТЬ ПО
	|	Хозрасчетный.СчетДт,
	|	Хозрасчетный.СчетКт,
	|	Хозрасчетный.Содержание
	|
	|УПОРЯДОЧИТЬ ПО
	|	КодДт,
	|	КодКт";

	Запрос.Текст = ТекстЗапроса;
	Запрос.УстановитьПараметр("ПустаяСсылка", ПланыСчетов.Хозрасчетный.ПустаяСсылка()); 
	Результат = Запрос.Выполнить();

	Если НЕ Результат.Пустой() Тогда

		Сообщить(НСтр("ru='Обнаружены некорректные корреспонденции.';uk='Виявлено некоректні кореспонденції.'"));

		ФормаСпискаКорреспонденций = РегистрыСведений.КорректныеКорреспонденцииСчетов.ПолучитьФорму("ФормаСпискаКорреспонденций");
		ФормаСпискаКорреспонденций.ТаблицаКорреспонденций = Результат.Выгрузить();
		ФормаСпискаКорреспонденций.Открыть();

	Иначе
		Предупреждение(НСтр("ru='Проверка проводок завершена!';uk='Перевірка проводок завершена!'"));
	КонецЕсли;

КонецПроцедуры


////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ РЕКВИЗИТОВ ФОРМЫ

// Обработчик события "ПриИзменении" флага использования отбора по счету.
//
Процедура ИспользованиеОтбораСчетПриИзменении(Элемент)

	УставновитьВидСравненияВИерархии();

КонецПроцедуры // ИспользованиеОтбораСчетПриИзменении()

// Обработчик события "ПриИзменении" поля ввода "Счет".
//
Процедура ОтборСчетПриИзменении(Элемент)

	Отбор.Счет.Использование = НЕ Элемент.Значение.Пустая();
	УставновитьВидСравненияВИерархии();

КонецПроцедуры // ОтборСчетПриИзменении()

// Обработчик события "ПриИзменении" поля ввода "Организация".
//
Процедура ОтборОрганизацияПриИзменении(Элемент)

	Отбор.Организация.Использование = НЕ Элемент.Значение.Пустая();

КонецПроцедуры // ОтборОрганизацияПриИзменении()

// Обработчик события "ПриИзменении" поля ввода "Регистратор".
//
Процедура ОтборРегистраторПриИзменении(Элемент)
	
	Отбор.Регистратор.Использование = ЗначениеЗаполнено(Элемент.Значение);
	
КонецПроцедуры // РегистраторПриИзменении()

// Обработчик события "Выбор" табличного поля "РегистрБухгалтерииСписок".
// Отрабатывает открытие формы документа "Операция (бухгалтерский и налоговый 
// учет" сразу на закладке "Бухгалтерский учет".
//
Процедура РегистрБухгалтерииСписокВыбор(Элемент, ВыбраннаяСтрока, Колонка, СтандартнаяОбработка)

	//Если ТипЗнч(ВыбраннаяСтрока.Регистратор) = Тип("ДокументСсылка.ОперацияБух") Тогда

	//	СтандартнаяОбработка = Ложь;

	//	ФормаОперации = ВыбраннаяСтрока.Регистратор.ПолучитьОбъект().ПолучитьФорму();
	//	ФормаОперации.ПараметрТекущаяСтрока = ВыбраннаяСтрока.НомерСтроки;
	//	ФормаОперации.ПараметрРегистр       = "Хозрасчетный";
	//	ФормаОперации.Открыть();

	//КонецЕсли;

КонецПроцедуры // РегистрБухгалтерииСписокВыбор()

Процедура РегистрБухгалтерииСписокПриПолученииДанных(Элемент, ОформленияСтрок)
	
	Для Каждого Строка Из ОформленияСтрок Цикл
		//Отображать = ?(Строка.ДанныеСтроки.Регистратор.Метаданные().Реквизиты.Найти("РучнаяКорректировка") = Неопределено, Ложь, Строка.ДанныеСтроки.Регистратор.РучнаяКорректировка);
		//Строка.Ячейки.РучнаяКорректировка.Картинка = БиблиотекаКартинок.РучнаяКорректировка;
		//Строка.Ячейки.РучнаяКорректировка.ОтображатьКартинку = Отображать;
	КонецЦикла
	
КонецПроцедуры
