////////////////////////////////////////////////////////////////////////////////
// ПЕРЕМЕННЫЕ МОДУЛЯ

Перем мЗаголовокФормы;

////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ ФОРМЫ

// Если форма открывается из списка документов, процедура заполняет организацию 
// прописывает заголовок формы и выставляет отбор регистру
//
Процедура ПриОткрытии()
	
	мЗаголовокФормы = "Депоненты работников организации ";

	Если ЗначениеЗаполнено(ПараметрОтборПоРегистратору) Тогда
		
        МетаданныеДокумента = ПараметрОтборПоРегистратору.Метаданные();
		
		Если МетаданныеДокумента.Реквизиты.Найти("Организация") <> Неопределено Тогда
            Отбор.Организация.Значение = ПараметрОтборПоРегистратору.Организация;
			
			ЭлементыФормы.Организация.ТолькоПросмотр = Истина
			
		КонецЕсли;

		Отбор.Организация.Использование = Истина;
		
	Иначе
		
		ОрганизацияПоУмолчанию = УправлениеПользователями.ПолучитьЗначениеПоУмолчанию(глЗначениеПеременной("глТекущийПользователь"),"ОсновнаяОрганизация");
		Отбор.Организация.Значение = ОрганизацияПоУмолчанию;

		Отбор.Организация.Использование = Не Отбор.Организация.Значение.Пустая();

	КонецЕсли;
	
КонецПроцедуры

Процедура ПриПовторномОткрытии(СтандартнаяОбработка)

	Если ЗначениеЗаполнено(ПараметрОтборПоРегистратору) Тогда
		
        МетаданныеДокумента = ПараметрОтборПоРегистратору.Метаданные();
		
		Если МетаданныеДокумента.Реквизиты.Найти("Организация") <> Неопределено Тогда
            Отбор.Организация.Значение = ПараметрОтборПоРегистратору.Организация;
			
			ЭлементыФормы.Организация.ТолькоПросмотр = Истина
			
		КонецЕсли;

		Отбор.Организация.Использование = Истина;
		
	Иначе
		
		ОрганизацияПоУмолчанию = УправлениеПользователями.ПолучитьЗначениеПоУмолчанию(глЗначениеПеременной("глТекущийПользователь"),"ОсновнаяОрганизация");
		Отбор.Организация.Значение = ОрганизацияПоУмолчанию;
		
		Отбор.Организация.Использование = Не Отбор.Организация.Значение.Пустая();

	КонецЕсли;
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ ЭЛЕМЕНТОВ УПРАВЛЕНИЯ

// Процедура прописывает заголовок формы 
//
// Параметры:
//  Элемент - элемент формы, который отображает организацию
//  
Процедура ОрганизацияПриИзменении(Элемент)

	Заголовок = мЗаголовокФормы + Элемент.Значение.Наименование;
    Отбор.Организация.Использование = Не Элемент.Значение.Пустая();
	
КонецПроцедуры

