
////////////////////////////////////////////////////////////////////////////////
// ПРОЦЕДУРЫ И ФУНКЦИИ ОБЩЕГО НАЗНАЧЕНИЯ

// Процедура определяет строку, выбранную пользователем, формирует
// структуру возврата данных и закрывает форму
//
// Параметры:
//  ВыбраннаяСтрока - выбранная строка табличного поля
// 
Процедура ВыбратьСтрокуИЗакрытьФорму(ВыбраннаяСтрока = Неопределено)

	Если ВыбраннаяСтрока = Неопределено Тогда
		Если ЭлементыФормы.ТаблицаОбъектов.ТекущиеДанные = Неопределено Тогда
			Предупреждение(НСтр("ru='Выберите строку из табличного поля.';uk='Виберіть рядок з табличного поля.'"));
			Возврат;
		КонецЕсли;
		ВыбраннаяСтрока = ЭлементыФормы.ТаблицаОбъектов.ТекущаяСтрока;
	КонецЕсли; 
	
	Если НЕ ЗначениеЗаполнено(ВыбраннаяСтрока.Объект) ИЛИ НЕ ЗначениеЗаполнено(ВыбраннаяСтрока.АдресЭлектроннойПочты) Тогда
		Предупреждение(НСтр("ru='Выберите строку с заполненными объектом и адресом электронной почты.';uk=""Оберіть рядок з заповненим об'єктом та адресою електронної пошти"""));
		Возврат;
	КонецЕсли;
	
	СтруктураВозврата = Новый Структура;
	СтруктураВозврата.Вставить("Объект", ВыбраннаяСтрока.Объект);
	СтруктураВозврата.Вставить("АдресЭлектроннойПочты", ВыбраннаяСтрока.АдресЭлектроннойПочты);
	СтруктураВозврата.Вставить("ПредставлениеОбъекта", ?(НЕ ПустаяСтрока(ВыбраннаяСтрока.ПредставлениеОбъекта), ВыбраннаяСтрока.ПредставлениеОбъекта, ВыбраннаяСтрока.Объект.Наименование));
	
	ЭтаФорма.Закрыть(СтруктураВозврата);

КонецПроцедуры

// Процедура вызывает диалог регистрации нового объекта
//
Процедура ЗарегистрироватьНовыйОбъект()

	ТекстДляПоиска = НераспознанноеИмя;
	
	АдреснаяКнига = Обработки.АдреснаяКнига.Создать();
	АдреснаяКнига.ОткрытаДляВыбора  = Истина;
	АдреснаяКнига.ОткрытиеПриВыборе = Истина;
	СтруктураНовогоОбъекта = АдреснаяКнига.СоздатьНовыйОбъектСАдресомЭлектроннойПочты(НераспознанноеИмя);
	АдреснаяКнига = Неопределено;
	
	Если ТипЗнч(СтруктураНовогоОбъекта) = Тип("Структура") Тогда
		СтруктураНовогоОбъекта.Вставить("ПредставлениеОбъекта", СтруктураНовогоОбъекта.Объект.Наименование);
		ЭтаФорма.Закрыть(СтруктураНовогоОбъекта);
	КонецЕсли; 

КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// ПРОЦЕДУРЫ - ОБРАБОТЧИКИ СОБЫТИЙ КОМАНДНЫХ ПАНЕЛЕЙ ФОРМЫ

// Процедура - обработчик события "Нажатие" элемента формы "ОсновныеДействияФормы.ОК".
//
Процедура ОсновныеДействияФормыОК(Кнопка)
	
	ВыбратьСтрокуИЗакрытьФорму();
	
КонецПроцедуры

// Процедура - обработчик события "Нажатие" элемента формы "КоманднаяПанельТаблицаОбъектов.ПодобратьИзАдреснойКниги".
//
Процедура КоманднаяПанельТаблицаОбъектовПодобратьИзАдреснойКниги(Кнопка)
	
	АдреснаяКнига = Обработки.АдреснаяКнига.Создать();
	ФормаКниги = АдреснаяКнига.ПолучитьФорму("ФормаВыбора");
	ФормаКниги.ЭлементыФормы.ОбщаяПанель.Страницы.ГруппыОбъектов.Видимость = Ложь;
	ОткликФормы = ФормаКниги.ОткрытьМодально();
	
	Если ТипЗнч(ОткликФормы) = Тип("Структура") Тогда
		Если ОткликФормы.Кому.Количество() = 0 Тогда
			ЭтаФорма.Закрыть();
		Иначе
			СтруктураВозврата = Новый Структура;
			СтруктураВозврата.Вставить("Объект", ОткликФормы.Кому[0].Объект);
			СтруктураВозврата.Вставить("АдресЭлектроннойПочты", ОткликФормы.Кому[0].АдресЭлектроннойПочты);
			СтруктураВозврата.Вставить("ПредставлениеОбъекта", ОткликФормы.Кому[0].ПредставлениеОбъекта);
			ЭтаФорма.Закрыть(СтруктураВозврата);
		КонецЕсли; 
	Иначе
		ЭтаФорма.Закрыть();
	КонецЕсли; 
	
КонецПроцедуры

// Процедура - обработчик события "Нажатие" элемента формы "ОсновныеДействияФормы.Удалить".
//
Процедура ОсновныеДействияФормыУдалить(Кнопка)
	
	ЭтаФорма.Закрыть(Ложь);

КонецПроцедуры

// Процедура - обработчик события "Нажатие" элемента формы "КоманднаяПанельТаблицаОбъектов.Добавить".
//
Процедура КоманднаяПанельТаблицаОбъектовДобавить(Кнопка)

	ЗарегистрироватьНовыйОбъект();
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// ПРОЦЕДУРЫ - ОБРАБОТЧИКИ СОБЫТИЙ ЭЛЕМЕНТОВ ФОРМЫ

// Процедура - обработчик события "ПередУдалением" элемента формы "ТаблицаОбъектов".
//
Процедура ТаблицаОбъектовПередУдалением(Элемент, Отказ)
	
	Отказ = Истина;
	
КонецПроцедуры

// Процедура - обработчик события "ПередНачаломИзменения" элемента формы "ТаблицаОбъектов".
//
Процедура ТаблицаОбъектовПередНачаломИзменения(Элемент, Отказ)
	
	Отказ = Истина;
	Если Элемент.ТекущиеДанные <> Неопределено И ЗначениеЗаполнено(Элемент.ТекущиеДанные.Объект) Тогда
		Элемент.ТекущиеДанные.Объект.ПолучитьФорму().Открыть();
	КонецЕсли; 
	
КонецПроцедуры

// Процедура - обработчик события "Выбор" элемента формы "ТаблицаОбъектов".
//
Процедура ТаблицаОбъектовВыбор(Элемент, ВыбраннаяСтрока, Колонка, СтандартнаяОбработка)
	
	ВыбратьСтрокуИЗакрытьФорму(ВыбраннаяСтрока);
	СтандартнаяОбработка = Ложь;
	
КонецПроцедуры

// Процедура - обработчик события "Выбор" элемента формы "ПередНачаломДобавления".
//
Процедура ТаблицаОбъектовПередНачаломДобавления(Элемент, Отказ, Копирование)
	
	Отказ = Истина;
	ЗарегистрироватьНовыйОбъект();
	
КонецПроцедуры

