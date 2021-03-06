////////////////////////////////////////////////////////////////////////////////
// СЛУЖЕБНЫЕ ПРОЦЕДУРЫ И ФУНКЦИИ

// Процедура устанавливает текст надписи текста выражения
//
Процедура УстановитьНадписьТекстВыражения()
	Если РежимЗагрузки =1 Тогда
		
		Если ЭлементыФормы.Панель.ТекущаяСтраница.Имя = "ПослеДобавленияСтроки" Тогда
			
			НадписьТекстВыражения =
			"В тексте выражения можно использовать следующие предопределенные параметры:
			|   Объект         - Записываемый объект
			|   ТекущиеДанные  - Содержит данные загружаемой строки табличной части.
			|   ТекстыЯчеек    - массив текстов ячеек строки
			|Встроенные функции, функции общих модулей.";
		Иначе
			
			НадписьТекстВыражения =
			"В тексте выражения можно использовать следующие предопределенные параметры:
			|   Объект         - Записываемый объект
			|   Отказ          - Признак отказа от записи объекта
			|Встроенные функции, функции общих модулей.";
			
		КонецЕсли;
		
	ИначеЕсли РежимЗагрузки =0 Тогда
		
		НадписьТекстВыражения =
		"В тексте выражения можно использовать следующие предопределенные параметры:
		|   Объект         - Записываемый объект
		|   Отказ          - Признак отказа от записи объекта
		|   ТекстыЯчеек    - массив текстов ячеек строки
		|Встроенные функции, функции общих модулей.";
		
	ИначеЕсли РежимЗагрузки =2 Тогда
		НадписьТекстВыражения =
		"В тексте выражения можно использовать следующие предопределенные параметры:
		|   Объект         - Менеджер записи регистра сведений
		|   Отказ          - Признак отказа от записи объекта
		|   ТекстыЯчеек    - массив текстов ячеек строки
		|Встроенные функции, функции общих модулей.";
	КонецЕсли;
	
КонецПроцедуры // ()

////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ ФОРМЫ

// Процедура - обаботчик события "ПриОткрытии" Формы
//
Процедура ПриОткрытии()
	
	Если РежимЗагрузки = 2 Тогда
		ЭлементыФормы.Панель.Страницы.ПередЗаписьюОбъекта.Заголовок = НСтр("ru='Перед записью';uk='Перед записом'");
		ЭлементыФормы.Панель.Страницы.ПриЗаписиОбъекта.Заголовок =    НСтр("ru='При записи';uk='При записі'");
	КонецЕсли;
	
	ЭлементыФормы.Панель.Страницы.ПослеДобавленияСтроки.Видимость = РежимЗагрузки = 1;
	УстановитьНадписьТекстВыражения();
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ ЭЛЕМЕНТОВ УПРАВЛЕНИЯ

// Процедура - обаботчик события, при нажатии на кнопку "ОК" Командной панели "ОсновныеДействияФормы"
//
Процедура ОсновныеДействияФормыОК(Кнопка)
	Закрыть(Истина);
КонецПроцедуры

// Процедура - обаботчик события "ПриСменеСтраницы" в: Панель "Панель"
//
Процедура ПанельПриСменеСтраницы(Элемент, ТекущаяСтраница)
	УстановитьНадписьТекстВыражения();
КонецПроцедуры
