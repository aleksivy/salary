
// Процедура прописывает заголовок формы 
//
// Параметры:
//  Элемент - элемент формы, который отображает организацию
//  
Процедура ОрганизацияПриИзменении(Элемент)

	Заголовок = НСтр("ru='Дополнительная информация о штатных единицах организации ';uk='Додаткова інформація про штатні одиниці організації '") + Элемент.Значение.Наименование;
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ ФОРМЫ

Процедура ПриОткрытии()

	Если ЗначениеЗаполнено(глЗначениеПеременной("глТекущийПользователь")) Тогда
		Организация = УправлениеПользователями.ПолучитьЗначениеПоУмолчанию(глЗначениеПеременной("глТекущийПользователь"),"ОсновнаяОрганизация");
	КонецЕсли;
	
	Заголовок = НСтр("ru='Дополнительная информация о штатных единицах организации ';uk='Додаткова інформація про штатні одиниці організації '") + Организация;	
		
КонецПроцедуры

Процедура ПриПовторномОткрытии(СтандартнаяОбработка)
	
	Если ЗначениеЗаполнено(глЗначениеПеременной("глТекущийПользователь")) Тогда
		Организация = УправлениеПользователями.ПолучитьЗначениеПоУмолчанию(глЗначениеПеременной("глТекущийПользователь"),"ОсновнаяОрганизация");
	КонецЕсли;
	
	Заголовок = НСтр("ru='Дополнительная информация о штатных единицах организации ';uk='Додаткова інформація про штатні одиниці організації '") + Организация;	
		
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// ПРОЦЕДУРЫ - ОБРАБОТЧИКИ событий табличных полей

// Процедура обеспечивает отбор по подразделению в списке 
// должностей. 
//
// Параметры:
//  Элемент      - элемент формы, который отображает подразделение
//  
Процедура ПодразделенияПриАктивизацииСтроки(Элемент)

	Подразделение = Элемент.ТекущаяСтрока;

	РегистрСведенийСписок.Отбор.ПодразделениеОрганизации.Значение	= Подразделение;
	РегистрСведенийСписок.Отбор.ПодразделениеОрганизации.Использование = Истина;

	Если НЕ ЗначениеЗаполнено(ЭлементыФормы.ШтатныеЕдиницы.ТекущаяСтрока) и ЗначениеЗаполнено(Подразделение) Тогда

        Запрос = Новый Запрос;
		Запрос.УстановитьПараметр("ПодразделениеОрганизации",Подразделение);
		Запрос.Текст = 
		"ВЫБРАТЬ ПЕРВЫЕ 1
		|	СведенияОШтатныхЕдиницахОрганизации.Должность,
		|	СведенияОШтатныхЕдиницахОрганизации.ПодразделениеОрганизации
		|ИЗ
		|	РегистрСведений.СведенияОШтатныхЕдиницахОрганизаций КАК СведенияОШтатныхЕдиницахОрганизации
		|
		|ГДЕ
		|	СведенияОШтатныхЕдиницахОрганизации.ПодразделениеОрганизации = &ПодразделениеОрганизации
		|";
		Выборка = Запрос.Выполнить().Выбрать();
					
		Если Выборка.Следующий() Тогда
			СтруктураОтбора = Новый Структура();
			СтруктураОтбора.Вставить("ПодразделениеОрганизации",Подразделение);
			СтруктураОтбора.Вставить("Должность",Выборка.Должность);
			ЭлементыФормы.ШтатныеЕдиницы.ТекущаяСтрока = РегистрыСведений.СведенияОШтатныхЕдиницахОрганизаций.СоздатьКлючЗаписи(СтруктураОтбора)
		КонецЕсли;
	КонецЕсли;

КонецПроцедуры // ПодразделенияПриАктивизацииСтроки()

// Процедура запрещает ввод штатной единицы при неуказанном подразделении
// информации 
//
// Параметры:
//  Элемент      - элемент формы, который отображает список штатных
//				   единиц.
//  
Процедура ШтатныеЕдиницыПередНачаломДобавления(Элемент, Отказ, Копирование)
	Если НЕ ЗначениеЗаполнено(Элемент.Значение.Отбор.ПодразделениеОрганизации.Значение) тогда
		Предупреждение(НСтр("ru='Не выбрано подразделение!';uk='Не вибраний підрозділ!'"));
		Отказ = Истина;
	КонецЕсли;	
КонецПроцедуры



 

