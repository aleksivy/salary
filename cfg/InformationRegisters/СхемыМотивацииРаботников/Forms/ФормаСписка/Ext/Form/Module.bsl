﻿////////////////////////////////////////////////////////////////////////////////
// ПЕРЕМЕННЫЕ МОДУЛЯ

Перем мСведенияОВидахРасчета;
Перем мПоддерживатьНесколькоСхемМотивации;
Перем мСписокУправленческихВидовРасчетов;
Перем мСписокРегНачислений;

////////////////////////////////////////////////////////////////////////////////
// ОБЩИЕ ПРОЦЕДУРЫ И ФУНКЦИИ

// Устанавливает отбор по типу ПВР
//
Процедура УстановитьОтборСхемыМотивацииПоВидРасчетов()
	

	Если ВидОрганизационнойСтруктурыПредприятия = Перечисления.ВидыОрганизационнойСтруктурыПредприятия.ПоЦентрамОтветственности Тогда
		Если мСписокУправленческихВидовРасчетов = Неопределено Тогда
			мСписокУправленческихВидовРасчетов = Новый СписокЗначений;
			Запрос = Новый Запрос;
			Запрос.Текст =
			"ВЫБРАТЬ
			|	УправленческиеНачисления.Ссылка,
			|	УправленческиеНачисления.Наименование
			|ИЗ
			|	ПланВидовРасчета.УправленческиеНачисления КАК УправленческиеНачисления
			|
			|ОБЪЕДИНИТЬ ВСЕ
			|
			|ВЫБРАТЬ
			|	УправленческиеУдержания.Ссылка,
			|	УправленческиеУдержания.Наименование
			|ИЗ
			|	ПланВидовРасчета.УправленческиеУдержания КАК УправленческиеУдержания";
			Выборка = Запрос.Выполнить().Выбрать();
			Пока Выборка.Следующий() Цикл
			    мСписокУправленческихВидовРасчетов.Добавить(Выборка.Ссылка,Выборка.Наименование)
			КонецЦикла;
		КонецЕсли;
		РегистрСведенийСписок.Отбор.ВидРасчета.Значение	= мСписокУправленческихВидовРасчетов;
				
	Иначе
		Если мСписокРегНачислений = Неопределено Тогда
			мСписокРегНачислений = Новый СписокЗначений;
			Запрос = Новый Запрос;
			Запрос.Текст =
			"ВЫБРАТЬ
			|	ОсновныеНачисленияОрганизаций.Ссылка,
			|	ОсновныеНачисленияОрганизаций.Наименование
			|ИЗ
			|	ПланВидовРасчета.ОсновныеНачисленияОрганизаций КАК ОсновныеНачисленияОрганизаций";
			Выборка = Запрос.Выполнить().Выбрать();
			Пока Выборка.Следующий() Цикл
			    мСписокРегНачислений.Добавить(Выборка.Ссылка,Выборка.Наименование)
			КонецЦикла;
		КонецЕсли;
		РегистрСведенийСписок.Отбор.ВидРасчета.Значение		= мСписокРегНачислений;				
		
	КонецЕсли;

	
КонецПроцедуры //УстановитьОтборСхемыМотивацииПоВидРасчетов

////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ ФОРМЫ

// Процедура - обработчик события "ПередОткрытием" формы
//
Процедура ПередОткрытием(Отказ, СтандартнаяОбработка)
	
	// вид организационной структуры
	ВидОрганизационнойСтруктурыПредприятия = ВосстановитьЗначение("МотивацияПерсоналаВидОрганизационнойСтруктурыПредприятия");	
	Если НЕ ЗначениеЗаполнено(ВидОрганизационнойСтруктурыПредприятия) Тогда
		ВидОрганизационнойСтруктурыПредприятия = Перечисления.ВидыОрганизационнойСтруктурыПредприятия.ПоЦентрамОтветственности;
	КонецЕсли;

КонецПроцедуры //ПередОткрытием

// Процедура - обработчик события "ПриОткрытии" формы
//
Процедура ПриОткрытии()
	
	РегистрСведенийСписок.Отбор.ВидРасчета.Использование	= Истина;
	РегистрСведенийСписок.Отбор.ВидРасчета.ВидСравнения		= ВидСравнения.ВСписке;			
	ВидОрганизационнойСтруктурыПредприятияПриИзменении();
	
КонецПроцедуры //ПриОткрытии

// Процедура - обработчик события "ПередЗакрытием" формы
//
Процедура ПередЗакрытием(Отказ, СтандартнаяОбработка)
	
	СохранитьЗначение("МотивацияПерсоналаВидОрганизационнойСтруктурыПредприятия",ВидОрганизационнойСтруктурыПредприятия);

КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ ЭЛЕМЕНТОВ УПРАВЛЕНИЯ ФОРМЫ

// Устанавливает отборы в зависимости от выбранной организационной структуры 
//
Процедура ВидОрганизационнойСтруктурыПредприятияПриИзменении()
	
	// установим отбор по должности предприятия
	УстановитьОтборСхемыМотивацииПоВидРасчетов();		
	
	Если ВидОрганизационнойСтруктурыПредприятия = Перечисления.ВидыОрганизационнойСтруктурыПредприятия.ПоСтруктуреЮридическихЛиц Тогда
						
		ЭлементыФормы.РегистрСведенийСписок.Колонки.Организация.Видимость = Истина;
		ЭлементыФормы.РегистрСведенийСписок.Колонки.ВидСхемыМотивации.Видимость = Ложь;
	Иначе	
		
		// получим учтенную политику по персоналу в разрезе поддержки нескольких схем мотивации 
		Если мПоддерживатьНесколькоСхемМотивации	= Неопределено Тогда
			глЗначениеПеременной("глУчетнаяПолитикаПоПерсоналу").Свойство("ПоддерживатьНесколькоСхемМотивации",мПоддерживатьНесколькоСхемМотивации);
		КонецЕсли;
		
		// Установим видимость колонок
		ЭлементыФормы.РегистрСведенийСписок.Колонки.ВидСхемыМотивации.Видимость = мПоддерживатьНесколькоСхемМотивации;
		ЭлементыФормы.РегистрСведенийСписок.Колонки.Организация.Видимость = Ложь;							
	КонецЕсли;	

КонецПроцедуры //ВидОрганизационнойСтруктурыПредприятияПриИзменении

////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ ТАБЛИЧНЫХ ПОЛЕЙ ФОРМЫ

// Процедура - обработчик события "ВыводеСтроки" табличного поля
//
Процедура РегистрСведенийСписокПриВыводеСтроки(Элемент, ОформлениеСтроки, ДанныеСтроки)
	
	Если ДанныеСтроки.ВидРасчета = Неопределено 
		Или ДанныеСтроки.ВидРасчета = ПланыВидовРасчета.ОсновныеНачисленияОрганизаций.ПустаяСсылка() Тогда
		
		Для СчПоказателей = 1 По 6 Цикл
			ОформлениеСтроки.Ячейки["НаименованиеПоказатель" + СчПоказателей].Видимость		= Ложь;
			ОформлениеСтроки.Ячейки["Показатель" + СчПоказателей].Видимость					= Ложь;		
			ОформлениеСтроки.Ячейки["Валюта" + СчПоказателей].Видимость						= Ложь;
			ОформлениеСтроки.Ячейки["НаименованиеПоказательТР" + СчПоказателей].Видимость	= Ложь;	
			ОформлениеСтроки.Ячейки["ТарифныйРазряд" +СчПоказателей].Видимость				= Ложь;
		КонецЦикла;

	Иначе
		РаботаСДиалогами.ПриВыводеСтрокиПлановыхНачисленийИУдержаний(Элемент, ОформлениеСтроки, ДанныеСтроки, мСведенияОВидахРасчета);
	КонецЕсли;

КонецПроцедуры //РегистрСведенийСписокПриВыводеСтроки

// Процедура - обработчик события "ПриНачалеРедактирования" табличного поля
//
Процедура РегистрСведенийСписокПриНачалеРедактирования(Элемент, НоваяСтрока, Копирование)
			
	Если НоваяСтрока Тогда
		ДанныеСтроки = Элемент.ТекущиеДанные;
		Если ВидОрганизационнойСтруктурыПредприятия = Перечисления.ВидыОрганизационнойСтруктурыПредприятия.ПоСтруктуреЮридическихЛиц Тогда
			ДанныеСтроки.ВидРасчета			= ПланыВидовРасчета.ОсновныеНачисленияОрганизаций.ПустаяСсылка();
			ДанныеСтроки.Подразделение 		= Справочники.ПодразделенияОрганизаций.ПустаяСсылка();
		Иначе
			ДанныеСтроки.ВидРасчета			= ПланыВидовРасчета.УправленческиеНачисления.ПустаяСсылка();
			ДанныеСтроки.Подразделение 		= Справочники.Подразделения.ПустаяСсылка();
		КонецЕсли;
	КонецЕсли;	
	
КонецПроцедуры


Процедура РегистрСведенийСписокВидРасчетаНачалоВыбора(Элемент, СтандартнаяОбработка)
		
	Если ВидОрганизационнойСтруктурыПредприятия = Перечисления.ВидыОрганизационнойСтруктурыПредприятия.ПоСтруктуреЮридическихЛиц Тогда
		//СписокВР = Новый СписокЗначений;
		//СписокВР.ЗагрузитьЗначения(ПланыВидовРасчета.ОсновныеНачисленияОрганизаций.ОкладПоДням);		
		//ФормаВыбораВидаРасчета = ПланыВидовРасчета.ОсновныеНачисленияОрганизаций.ПолучитьФормуВыбора();
	Иначе
		СтандартнаяОбработка = Ложь;
	
		СписокВР = Новый СписокЗначений;
		СписокВР.Добавить(ПланыВидовРасчета.УправленческиеНачисления.НачисленоПоБухгалтерии);
		СписокВР.Добавить(ПланыВидовРасчета.УправленческиеНачисления.НачисленоПоБухгалтерииСдельно);
		
		ФормаВыбораВидаРасчета = ПланыВидовРасчета.УправленческиеНачисления.ПолучитьФормуВыбора(, ЭтаФорма);
		ФормаВыбораВидаРасчета.Отбор.Ссылка.ВидСравнения = ВидСравнения.НеВСписке;
		ФормаВыбораВидаРасчета.Отбор.Ссылка.Значение = СписокВР;
		ФормаВыбораВидаРасчета.Отбор.Ссылка.Использование = Истина;
		
		ФормаВыбораВидаРасчета.Открыть();	
	КонецЕсли;
	

КонецПроцедуры


////////////////////////////////////////////////////////////////////////////////
// ОПЕРАТОРЫ ОСНОВНОЙ ПРОГРАММЫ

мСведенияОВидахРасчета 	= Новый Соответствие;
