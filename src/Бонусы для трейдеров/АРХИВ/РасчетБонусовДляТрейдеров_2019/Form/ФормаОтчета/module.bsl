﻿// УстановитьОтбор
//
Процедура УстановитьОтбор(КомпоновщикНастроек, ИмяПараметра, ЗначениеПараметра, ВидСравнения)
	ЭлементОтбора = КомпоновщикНастроек.Настройки.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ЭлементОтбора.ЛевоеЗначение = Новый ПолеКомпоновкиДанных(ИмяПараметра);
	ЭлементОтбора.РежимОтображения = РежимОтображенияЭлементаНастройкиКомпоновкиДанных.Обычный;
	ЭлементОтбора.ПравоеЗначение = ЗначениеПараметра;	
	ЭлементОтбора.ВидСравнения = ВидСравнения;
	ЭлементОтбора.Использование = ЗначениеЗаполнено(ЗначениеПараметра);
КонецПроцедуры

// УстановитьПараметр
//
Процедура УстановитьПараметр(КомпоновщикНастроек, ИмяПараметра, ЗначениеПараметра)
	ПараметрДанныхТекущий = КомпоновщикНастроек.Настройки.ПараметрыДанных.НайтиЗначениеПараметра(Новый ПараметрКомпоновкиДанных(ИмяПараметра));
	ПараметрДанныхТекущий.Значение = ЗначениеПараметра;
	ПараметрДанныхТекущий.Использование = ЗначениеЗаполнено(ЗначениеПараметра);
КонецПроцедуры

Процедура УстановитьПараметрыОтборы()
	КомпоновщикНастроек.ЗагрузитьНастройки(СхемаКомпоновкиДанных.ВариантыНастроек[ЭлементыФормы.СписокВариантов.Значение].Настройки);
	
	УстановитьПараметр(КомпоновщикНастроек, "ГГУ", глЗначениеПеременной("ОрганизацииГленкорАгрикалчерУкраина") );
	
	УстановитьПараметр(КомпоновщикНастроек, "Администрация", глЗначениеПеременной("ПодразделенияАдминистрация") );
	УстановитьПараметр(КомпоновщикНастроек, "Винница", глЗначениеПеременной("ПодразделенияВинница") );
	УстановитьПараметр(КомпоновщикНастроек, "Киев", глЗначениеПеременной("ПодразделенияКиев") );
	УстановитьПараметр(КомпоновщикНастроек, "Одеса", глЗначениеПеременной("ПодразделенияОдеса") );
	УстановитьПараметр(КомпоновщикНастроек, "Харьков", глЗначениеПеременной("ПодразделенияХарьков") );
	УстановитьПараметр(КомпоновщикНастроек, "Чернигов", глЗначениеПеременной("ПодразделенияЧернигов") );
	
	УстановитьПараметр(КомпоновщикНастроек, "FODirector", глЗначениеПеременной("ДолжностиОрганизацийFODirector") );
	УстановитьПараметр(КомпоновщикНастроек, "FOManager", глЗначениеПеременной("ДолжностиОрганизацийFOManager") );
	
	УстановитьПараметр(КомпоновщикНастроек, "Борисов", глЗначениеПеременной("ФизическиеЛицаБорисовОлегОлексійович") );
	УстановитьПараметр(КомпоновщикНастроек, "Вергун", глЗначениеПеременной("ФизическиеЛицаВергунВадимІгорович") );
	УстановитьПараметр(КомпоновщикНастроек, "Галунга", глЗначениеПеременной("ФизическиеЛицаГалунгаЄвгенМиколайович") );
	УстановитьПараметр(КомпоновщикНастроек, "Дроздов", глЗначениеПеременной("ФизическиеЛицаДроздовДмитроВячеславович") );
	УстановитьПараметр(КомпоновщикНастроек, "Емец", глЗначениеПеременной("ФизическиеЛицаЄмецьПетроОлександрович") );
	УстановитьПараметр(КомпоновщикНастроек, "Ерохин", глЗначениеПеременной("ФизическиеЛицаЄрохінРусланГеннадійович") );
	УстановитьПараметр(КомпоновщикНастроек, "Заборовський", глЗначениеПеременной("ФизическиеЛицаЗаборовськийАнатолійВалентинович") );
	УстановитьПараметр(КомпоновщикНастроек, "Кисельов", глЗначениеПеременной("ФизическиеЛицаКисельовОлександрОлександрович") );
	УстановитьПараметр(КомпоновщикНастроек, "Козяренко", глЗначениеПеременной("ФизическиеЛицаКозяренкоОлегЄвгенович") );
	УстановитьПараметр(КомпоновщикНастроек, "Конотоп", глЗначениеПеременной("ФизическиеЛицаКонотопВалерійВолодимирович") );
	УстановитьПараметр(КомпоновщикНастроек, "Сивак", глЗначениеПеременной("ФизическиеЛицаСивакВіталійІванович") );
	УстановитьПараметр(КомпоновщикНастроек, "Корнеев", глЗначениеПеременной("ФизическиеЛицаКорнєєвВалерійІгоревич") );
	УстановитьПараметр(КомпоновщикНастроек, "Крамаренко", глЗначениеПеременной("ФизическиеЛицаКрамаренкоЄвгенСергійович") );
	УстановитьПараметр(КомпоновщикНастроек, "Лабунец", глЗначениеПеременной("ФизическиеЛицаЛабунецьЄвгенСергійович") );
	УстановитьПараметр(КомпоновщикНастроек, "Лациба", глЗначениеПеременной("ФизическиеЛицаЛацибаВалерійВасильович") );
	УстановитьПараметр(КомпоновщикНастроек, "Лебедь", глЗначениеПеременной("ФизическиеЛицаЛебедьРоманЄфремович") );
	УстановитьПараметр(КомпоновщикНастроек, "Матчак", глЗначениеПеременной("ФизическиеЛицаМатчакРоманІгорович") );
	УстановитьПараметр(КомпоновщикНастроек, "Немченко", глЗначениеПеременной("ФизическиеЛицаНемченкоІванАндрійович") );
	УстановитьПараметр(КомпоновщикНастроек, "Поковба", глЗначениеПеременной("ФизическиеЛицаПоковбаМихайлоПетрович") );
	УстановитьПараметр(КомпоновщикНастроек, "Пустовит", глЗначениеПеременной("ФизическиеЛицаПустовітСергійВолодимирович") );
	УстановитьПараметр(КомпоновщикНастроек, "Святишенко", глЗначениеПеременной("ФизическиеЛицаСвятишенкоСергійСергійович") );
	УстановитьПараметр(КомпоновщикНастроек, "Смирнов", глЗначениеПеременной("ФизическиеЛицаСмірновМихайлоВалентинович") );
	УстановитьПараметр(КомпоновщикНастроек, "Тихонюк", глЗначениеПеременной("ФизическиеЛицаТихонюкСергійОлександрович") );
	УстановитьПараметр(КомпоновщикНастроек, "Тлумацький", глЗначениеПеременной("ФизическиеЛицаТлумацькийБогданЗіновійович") );
	УстановитьПараметр(КомпоновщикНастроек, "Устинов", глЗначениеПеременной("ФизическиеЛицаУстиновІгорГеннадійович") );
	УстановитьПараметр(КомпоновщикНастроек, "Чебиряко", глЗначениеПеременной("ФизическиеЛицаЧебірякоСергійЄвгенійович") );
	УстановитьПараметр(КомпоновщикНастроек, "Шишкевич", глЗначениеПеременной("ФизическиеЛицаШишкевичОлександрДмитрович") );
	УстановитьПараметр(КомпоновщикНастроек, "Щербаков", глЗначениеПеременной("ФизическиеЛицаЩербаковРоманВалерійович") );
	УстановитьПараметр(КомпоновщикНастроек, "Юраш", глЗначениеПеременной("ФизическиеЛицаЮрашЮрійІванович") );
	УстановитьПараметр(КомпоновщикНастроек, "Руденко", глЗначениеПеременной("ФизическиеЛицаРуденкоЮліяВалеріївна") );
	УстановитьПараметр(КомпоновщикНастроек, "НоменклатураЗПУ", глЗначениеПеременной("НоменклатураЗПУВартаУніверсал") );
	УстановитьПараметр(КомпоновщикНастроек, "Гнип", глЗначениеПеременной("ФизическиеЛицаГнипАртурТомаш") );
	УстановитьПараметр(КомпоновщикНастроек, "Сивак", глЗначениеПеременной("ФизическиеЛицаСивакВіталійІванович") );
	УстановитьПараметр(КомпоновщикНастроек, "Ковбасюк", глЗначениеПеременной("ФизическиеЛицаКовбасюкСергійВікторович") );
	
	
	УстановитьПараметр(КомпоновщикНастроек, "ДатаОтчета", КонецМесяца( ДатаОтчета ) );
	
КонецПроцедуры

Процедура ПриОткрытии()
	Если Не ЗначениеЗаполнено(ДатаОтчета) Тогда ДатаОтчета = НачалоМесяца( ТекущаяДата() ) - 1; КонецЕсли;
	
	лсзВарианты = Новый СписокЗначений;
	Для каждого лВариант Из СхемаКомпоновкиДанных.ВариантыНастроек Цикл лсзВарианты.Добавить( лВариант.Имя, лВариант.Представление ); КонецЦикла;
	ЭлементыФормы.СписокВариантов.СписокВыбора = лсзВарианты;
	ЭлементыФормы.СписокВариантов.Значение = лсзВарианты.Получить(0).Значение;
	
	УстановитьПараметрыОтборы();
КонецПроцедуры

Процедура ДатаОтчетаПриИзменении(Элемент)
	Если 	  Не ЗначениеЗаполнено(ДатаОтчета) Тогда ДатаОтчета = КонецМесяца( ТекущаяДата() );
	ИначеЕсли Не ДатаОтчета = КонецМесяца( ДатаОтчета ) Тогда ДатаОтчета = КонецМесяца( ДатаОтчета ); 
	КонецЕсли;
	Если ДатаОтчета < '20190731' Тогда ДатаОтчета = КонецМесяца( ТекущаяДата() ); КонецЕсли;
	
	УстановитьПараметрыОтборы();
КонецПроцедуры

Процедура СписокВариантовПриИзменении(Элемент)
	УстановитьПараметрыОтборы();
КонецПроцедуры
