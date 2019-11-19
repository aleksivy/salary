﻿////////////////////////////////////////////////////////////////////////////////
// ПРОЦЕДУРЫ - ОБРАБОТЧИКИ СОБЫТИЙ ФОРМЫ

// Процедура - обработчик события "ПередОткрытием" формы
//
Процедура ПередОткрытием(Отказ, СтандартнаяОбработка)
	Попытка
		Отказ = МассивОтветов.Количество() = 0;
		Если Отказ Тогда
			Предупреждение(НСтр("ru='Для вопроса не предусмотрены ответы!';uk='Для питання не передбачені відповіді!'"));
		КонецЕсли;
	Исключение
	    Отказ = Истина
	КонецПопытки;
КонецПроцедуры

// Процедура - обработчик события "ПриОткрытии" формы
//
Процедура ПриОткрытии()
	
	ИндексОтвета = 0;
	Сч = 0;

	ЭлементыФормы.ОсновныеДействияФормы.УстановитьПривязку(ГраницаЭлементаУправления.Низ,   Неопределено, Неопределено);
	ЭлементыФормы.ОсновныеДействияФормы.УстановитьПривязку(ГраницаЭлементаУправления.Верх,  Неопределено, Неопределено);
	
	Если МассивОтветов.Количество() <= 15 Тогда
		
		ВысотаФормы = ЭлементыФормы.Переключатель1.Верх; 
		
		Для каждого СтрокаМассива Из МассивОтветов Цикл
			
			ВысотаФормы = ВысотаФормы + 19 + ?(СтрокаМассива.ТребуетРазвернутыйОтвет,24,3);
			
			Сч = Сч + 1;
			
			Если Сч > 1 Тогда
				
				Переключатель = ЭлементыФормы.Добавить(Тип("Переключатель"), "Переключатель" + Сч, Истина);
				
				ВерхЭУ = ЭлементыФормы["Переключатель" + (Сч-1)].Верх + 19 + ?(ЭлементыФормы.Найти("ПолеВвода" + (Сч-1)) <> Неопределено,24,3); 
				Переключатель.ПорядокОбхода = Сч + 1;
				Переключатель.Верх   = ВерхЭУ;
				Переключатель.Лево   = ЭлементыФормы.Переключатель1.Лево;
				Переключатель.Ширина = ЭлементыФормы.Переключатель1.Ширина;
				Переключатель.Высота = ЭлементыФормы.Переключатель1.Высота;
				Переключатель.ВыбираемоеЗначение = Сч;
				
				// установка привязок
				Переключатель.УстановитьПривязку(ГраницаЭлементаУправления.Низ,   Переключатель, ГраницаЭлементаУправления.Верх);
				Переключатель.УстановитьПривязку(ГраницаЭлементаУправления.Лево, ЭтаФорма.Панель, ГраницаЭлементаУправления.Лево);
				Переключатель.УстановитьПривязку(ГраницаЭлементаУправления.Право, ЭтаФорма.Панель, ГраницаЭлементаУправления.Право);
				
			Иначе
				Переключатель = ЭлементыФормы.Переключатель1; 
			КонецЕсли;
			
			ЭлементыФормы["Переключатель" + Сч].Заголовок = СтрокаМассива.Ответ;
			
			Если СтрокаМассива.ТребуетРазвернутыйОтвет Тогда
				
				ПолеВвода = ЭлементыФормы.Добавить(Тип("ПолеВвода"), "ПолеВвода" + Сч, Истина);
				
				ПолеВвода.Верх   = Переключатель.Верх + Переключатель.Высота;
				ПолеВвода.Лево   = ЭлементыФормы.Переключатель1.Лево;
				ПолеВвода.Ширина = ЭлементыФормы.Переключатель1.Ширина;
				ПолеВвода.Высота = ЭлементыФормы.Переключатель1.Высота;
				
				ПолеВвода.Доступность = Ложь;
				
				// установка привязок
				ПолеВвода.УстановитьПривязку(ГраницаЭлементаУправления.Низ,   ПолеВвода, ГраницаЭлементаУправления.Верх);
				ПолеВвода.УстановитьПривязку(ГраницаЭлементаУправления.Лево, ЭтаФорма.Панель, ГраницаЭлементаУправления.Лево);
				ПолеВвода.УстановитьПривязку(ГраницаЭлементаУправления.Право, ЭтаФорма.Панель, ГраницаЭлементаУправления.Право);
				
			КонецЕсли;
			
			Если СтрокаМассива.Ответ = ТиповойОтвет Тогда
				Переключатель1 = Сч;
				ИндексОтвета = Сч;
				ЭлементыФормы["Переключатель" + Сч].АктивизироватьПоУмолчанию = Истина;
				Если СтрокаМассива.ТребуетРазвернутыйОтвет Тогда
					ПолеВвода.Доступность = Истина;
					ЭлементыФормы["ПолеВвода" + Сч].Значение = РазвернутыйОтвет;
				КонецЕсли; 
			КонецЕсли; 
			
		КонецЦикла;
		
		Если ИндексОтвета = 0 Тогда
			ЭлементыФормы.Переключатель1.АктивизироватьПоУмолчанию = Истина;
		КонецЕсли;
		
		ЭлементыФормы.Удалить(ЭлементыФормы.ПолеВыбора);
		ЭлементыФормы.Удалить(ЭлементыФормы.НадписьРазвернутыйОтвет);
		
	Иначе
		
		ПолеВыбора = ЭлементыФормы.ПолеВыбора;
		Надпись = ЭлементыФормы.НадписьРазвернутыйОтвет;
		ПолеВыбора.Верх = ЭлементыФормы.Переключатель1.Верх + 5;
		Надпись.Верх = ПолеВыбора.Верх + ПолеВыбора.Высота + 5;
		
		Для каждого СтрокаМассива Из МассивОтветов Цикл
			ПолеВыбора.СписокВыбора.Добавить(СтрокаМассива.Ответ);
			Если СтрокаМассива.ТребуетРазвернутыйОтвет Тогда
				Если ЭлементыФормы.Найти("ПолеВвода") = Неопределено Тогда
					
					ПолеВвода = ЭлементыФормы.Добавить(Тип("ПолеВвода"), "ПолеВвода", Истина);
					
					ПолеВвода.Верх   = Надпись.Верх + Надпись.Высота + 5;
					ПолеВвода.Лево   = ЭлементыФормы.Переключатель1.Лево;
					ПолеВвода.Ширина = ЭлементыФормы.Переключатель1.Ширина;
					ПолеВвода.Высота = ЭлементыФормы.Переключатель1.Высота;
					
					ПолеВвода.Доступность = Ложь;
					
					// установка привязок
					ПолеВвода.УстановитьПривязку(ГраницаЭлементаУправления.Низ,   ПолеВвода, ГраницаЭлементаУправления.Верх);
					ПолеВвода.УстановитьПривязку(ГраницаЭлементаУправления.Лево, ЭтаФорма.Панель, ГраницаЭлементаУправления.Лево);
					ПолеВвода.УстановитьПривязку(ГраницаЭлементаУправления.Право, ЭтаФорма.Панель, ГраницаЭлементаУправления.Право);
					
				КонецЕсли;
				Если СтрокаМассива.Ответ = ТиповойОтвет Тогда
					ПолеВвода.Доступность = Истина;
					ЭлементыФормы.ПолеВвода.Значение = РазвернутыйОтвет;
				КонецЕсли; 
			КонецЕсли; 
		КонецЦикла;
		ПолеВыбора.Значение = ТиповойОтвет;
		
		ЭлементыФормы.ПолеВыбора.АктивизироватьПоУмолчанию = Истина;
		ВысотаФормы = ?(ЭлементыФормы.Найти("ПолеВвода") <> Неопределено,ЭлементыФормы.ПолеВвода,ЭлементыФормы.ПолеВыбора).Верх + 19;
		
		ЭлементыФормы.Удалить(ЭлементыФормы.Переключатель1);
		
	КонецЕсли;

	ЭлементыФормы.ОсновныеДействияФормы.УстановитьПривязку(ГраницаЭлементаУправления.Низ,   ЭтаФорма.Панель, ГраницаЭлементаУправления.Низ);
	ЭлементыФормы.ОсновныеДействияФормы.УстановитьПривязку(ГраницаЭлементаУправления.Верх,  ЭтаФорма.Панель, ГраницаЭлементаУправления.Низ);
	Высота = ВысотаФормы + 8 + ЭлементыФормы.ОсновныеДействияФормы.Высота;
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// ПРОЦЕДУРЫ - ДЕЙСТВИЯ КОМАНДНЫХ ПАНЕЛЕЙ ФОРМЫ

// Действия по кнопке "Ок"
Процедура ОсновныеДействияФормыОк(Кнопка)
	
	Если МассивОтветов.Количество() > 15 Тогда
		ТиповойОтвет = ЭлементыФормы.ПолеВыбора.Значение;
		ПолеВвода = ЭлементыФормы.Найти("ПолеВвода");
		Если ПолеВвода <> Неопределено Тогда
			РазвернутыйОтвет = ?(ПолеВвода.Доступность,ПолеВвода.Значение,"")
		КонецЕсли;
	Иначе
		ТиповойОтвет = МассивОтветов[Переключатель1-1].Ответ;
		РазвернутыйОтвет = ?(ЭлементыФормы.Найти("ПолеВвода" + Переключатель1) = Неопределено,"",ЭлементыФормы["ПолеВвода" + Переключатель1].Значение);
	КонецЕсли;
	Закрыть();
	
КонецПроцедуры

// Действия по кнопке "Отмена"
Процедура ОсновныеДействияФормыОтмена(Кнопка)
	
	Закрыть();
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// ПРОЦЕДУРЫ - ОБРАБОТЧИКИ СОБЫТИЙ РЕКВИЗИТОВ ФОРМЫ

Процедура Переключатель1ПриИзменении(Элемент)
	
	ПолеВвода = Тип("ПолеВвода");
	
	Для каждого ЭУ Из ЭлементыФормы Цикл
	    Если Тип(ЭУ) = ПолеВвода Тогда
			ЭУ.Доступность = Число(Сред(ЭУ.Имя,10)) = Переключатель1;
		КонецЕсли;
	КонецЦикла;
	
КонецПроцедуры

Процедура ПолеВыбораПриИзменении(Элемент)
	ПолеВвода = ЭлементыФормы.Найти("ПолеВвода");
	Если ПолеВвода <> Неопределено Тогда
		ПолеВвода.Доступность = Элемент.Значение.ТребуетРазвернутыйОтвет
	КонецЕсли;
КонецПроцедуры



