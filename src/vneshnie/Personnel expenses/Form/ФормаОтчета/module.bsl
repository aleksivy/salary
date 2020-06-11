﻿// УстановитьОтбор
//
Процедура УстановитьОтбор(КомпоновщикНастроек, ИмяПараметра, ЗначениеПараметра)
	ЭлементОтбора = КомпоновщикНастроек.Настройки.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ЭлементОтбора.ЛевоеЗначение = Новый ПолеКомпоновкиДанных(ИмяПараметра);
	ЭлементОтбора.РежимОтображения = РежимОтображенияЭлементаНастройкиКомпоновкиДанных.Обычный;
	Если ЗначениеЗаполнено(ЗначениеПараметра) Тогда
		ЭлементОтбора.Использование = Истина;
		ЭлементОтбора.ПравоеЗначение = ЗначениеПараметра;	
		Попытка
			лЭтоГруппа = ЗначениеПараметра.ЭтоГруппа;
			Если лЭтоГруппа Тогда
				ЭлементОтбора.ВидСравнения = ВидСравненияКомпоновкиДанных.ВИерархии;
			Иначе
				ЭлементОтбора.ВидСравнения = ВидСравненияКомпоновкиДанных.Равно;
			КонецЕсли;
		Исключение
			ЭлементОтбора.ВидСравнения = ВидСравненияКомпоновкиДанных.Равно;
		КонецПопытки;
	Иначе
		ЭлементОтбора.Использование = Ложь;
	КонецЕсли;
КонецПроцедуры

// УстановитьПараметр
//
Процедура УстановитьПараметр(КомпоновщикНастроек, ИмяПараметра, ЗначениеПараметра)
	ПараметрДанныхТекущий = КомпоновщикНастроек.Настройки.ПараметрыДанных.НайтиЗначениеПараметра(Новый ПараметрКомпоновкиДанных(ИмяПараметра));
	ПараметрДанныхТекущий.Значение = ЗначениеПараметра;
	ПараметрДанныхТекущий.Использование = ЗначениеЗаполнено(ЗначениеПараметра);
КонецПроцедуры

Процедура УстановитьПараметрыОтборы()
	ЭлементыФормы.ДействияФормы.Кнопки.ЗаписатьРегистр.Доступность = ?(ЭлементыФормы.СписокВариантов.Значение = "СернаНачисления", Истина, Ложь);
	
    КомпоновщикНастроек.ЗагрузитьНастройки(СхемаКомпоновкиДанных.ВариантыНастроек[ЭлементыФормы.СписокВариантов.Значение].Настройки);
	УстановитьПараметр(КомпоновщикНастроек, "НачалоПериода", НачалоДня(НачалоПериода) );
	УстановитьПараметр(КомпоновщикНастроек, "КонецПериода", КонецДня(КонецПериода) );
КонецПроцедуры

Процедура ПриОткрытии()
	Если Не ЗначениеЗаполнено(НачалоПериода) Тогда НачалоПериода = НачалоМесяца( НачалоМесяца(ТекущаяДата())-1 ); КонецЕсли;
	Если Не ЗначениеЗаполнено(КонецПериода) Тогда КонецПериода = КонецМесяца( НачалоМесяца(ТекущаяДата())-1 ); КонецЕсли;
	
	лсзВарианты = Новый СписокЗначений;
	Для каждого лВариант Из СхемаКомпоновкиДанных.ВариантыНастроек Цикл лсзВарианты.Добавить( лВариант.Имя, лВариант.Представление ); КонецЦикла;
	ЭлементыФормы.СписокВариантов.СписокВыбора = лсзВарианты;
	ЭлементыФормы.СписокВариантов.Значение = лсзВарианты.Получить(0).Значение;
	
	УстановитьПараметрыОтборы();
КонецПроцедуры

Процедура НачалоПериодаПриИзменении(Элемент)
	КонецПериода = КонецМесяца(НачалоПериода);
	УстановитьПараметрыОтборы();
КонецПроцедуры

Процедура КонецПериодаПриИзменении(Элемент)
	УстановитьПараметрыОтборы();
КонецПроцедуры

Процедура СписокВариантовПриИзменении(Элемент)
	УстановитьПараметрыОтборы();
КонецПроцедуры

Процедура ДействияФормыЗаписатьРегистр(Кнопка)
	КомпоновщикМакета = Новый КомпоновщикМакетаКомпоновкиДанных;
	ПроцессорКомпоновкиДанных = Новый ПроцессорКомпоновкиДанных;
	МакетКомпоновкиДанных = КомпоновщикМакета.Выполнить(СхемаКомпоновкиДанных, КомпоновщикНастроек.Настройки, , , Тип("ГенераторМакетаКомпоновкиДанныхДляКоллекцииЗначений"));
	ПроцессорКомпоновкиДанных.Инициализировать(МакетКомпоновкиДанных);
	лТаблицаЗначений = Новый ТаблицаЗначений;
	ПроцессорВывода = Новый ПроцессорВыводаРезультатаКомпоновкиДанныхВКоллекциюЗначений;
	ПроцессорВывода.УстановитьОбъект(лТаблицаЗначений);
	ПроцессорВывода.Вывести(ПроцессорКомпоновкиДанных);
	
	лДата = НачалоМесяца(КонецПериода);
	
	лтзВрем = лТаблицаЗначений.Скопировать( , "ВидРасчета" );
	лтзВрем.Свернуть("ВидРасчета", "");
	Для каждого лЗнач Из лтзВрем Цикл 
		лНаборЗаписей = РегистрыСведений.СернаНачисления.СоздатьНаборЗаписей();
		лНаборЗаписей.Отбор.Период.Использование = Истина;
		лНаборЗаписей.Отбор.Период.ВидСравнения = ВидСравнения.Равно;
		лНаборЗаписей.Отбор.Период.Значение = лДата;
		лНаборЗаписей.Отбор.ВидРасчета.Использование = Истина;
		лНаборЗаписей.Отбор.ВидРасчета.ВидСравнения = ВидСравнения.Равно;
		лНаборЗаписей.Отбор.ВидРасчета.Значение = лЗнач.ВидРасчета;
		лНаборЗаписей.Отбор.ЭтоВыплата.Использование = Истина;
		лНаборЗаписей.Отбор.ЭтоВыплата.ВидСравнения = ВидСравнения.Равно;
		лНаборЗаписей.Отбор.ЭтоВыплата.Значение = Истина;
		лНаборЗаписей.Прочитать();
		лНаборЗаписей.Очистить();
		лНаборЗаписей.Записать();
	КонецЦикла;
	
	лТаблицаЗначений.Колонки.Добавить("Период", Новый ОписаниеТипов("Дата"));
	лТаблицаЗначений.ЗаполнитьЗначения( лДата, "Период");
	лТаблицаЗначений.Колонки.Добавить("ЭтоВыплата", Новый ОписаниеТипов("Булево"));
	лТаблицаЗначений.ЗаполнитьЗначения( Истина, "ЭтоВыплата");
	лНаборЗаписей = РегистрыСведений.СернаНачисления.СоздатьНаборЗаписей();
	лНаборЗаписей.Загрузить( лТаблицаЗначений );
	лНаборЗаписей.Записать( Ложь );
КонецПроцедуры
