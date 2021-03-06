
Процедура ПередОткрытием(Отказ, СтандартнаяОбработка)
		
	ТиповыеОтчеты.НазначитьФормеУникальныйКлючИдентификации(ЭтаФорма);
	ТиповыеОтчеты.ОбновитьФормуТиповогоОтчетаПоКомпоновщику(ОтчетОбъект, ЭтаФорма);
	ТиповыеОтчеты.УправлениеОтображениемЭлементовФормыТиповогоОтчета(ОтчетОбъект, ЭтаФорма);
	
	ЗначениеПериод = КомпоновщикНастроек.Настройки.ПараметрыДанных.НайтиЗначениеПараметра(Новый ПараметрКомпоновкиДанных("Период"));
	
	Если ЗначениеПериод.Значение = '00010101' Тогда
		РД = ОбщегоНазначения.ПолучитьРабочуюДату();
		
		Период = РД;
		
		ЗначениеПериод.Значение      = НачалоМесяца(РД);
		ЗначениеПериод.Использование = Истина;

	КонецЕсли;
	
	Период = ЗначениеПериод.Значение;

	СтрокаПериод = РаботаСДиалогами.ДатаКакМесяцПредставление(Период);

	
	Если Не ЭтоОтработкаРасшифровки 
		И Не СохранениеНастроек.ЗаполнитьНастройкиПриОткрытииОтчета(ОтчетОбъект) Тогда
		ИнициализацияОтчета();
	КонецЕсли;
	

КонецПроцедуры

Процедура ДействияФормыСформировать(Кнопка)
	
	ОбновитьОтчет();
	
КонецПроцедуры

Процедура ОбновитьОтчет() Экспорт
	
	Период = КомпоновщикНастроек.Настройки.ПараметрыДанных.НайтиЗначениеПараметра(Новый ПараметрКомпоновкиДанных("Период")).Значение;

	СформироватьОтчет(ЭтаФорма);
	
КонецПроцедуры

Процедура ДействияФормыЗаголовок(Кнопка)
	
	Кнопка.Пометка = Не Кнопка.Пометка;
	ТиповыеОтчеты.УправлениеОтображениемЭлементовФормыТиповогоОтчета(ОтчетОбъект, ЭтаФорма);
	ТиповыеОтчеты.УправлениеОтображениемЗаголовкаТиповогоОтчета(ОтчетОбъект, ЭтаФорма.ЭлементыФормы.Результат);

КонецПроцедуры

Процедура ДействияФормыПечать(Кнопка)
	
	ТиповыеОтчеты.ПечатьТиповогоОтчета(ЭлементыФормы.Результат);

КонецПроцедуры

Процедура ДействияФормыОткрытьВНовомОкне(Кнопка)
	
	ТиповыеОтчеты.ОткрытьВНовомОкнеТиповойОтчет(ОтчетОбъект, ЭтаФорма);
	
КонецПроцедуры

Процедура ДействияФормыОтбор(Кнопка)
	
	Кнопка.Пометка = Не Кнопка.Пометка;
	ПоказыватьБыстрыйОтбор = Кнопка.Пометка;
	ТиповыеОтчеты.УправлениеОтображениемЭлементовФормыТиповогоОтчета(ОтчетОбъект, ЭтаФорма);
	ТиповыеОтчеты.ОбработкаИзмененияТиповогоОтчетаНаФормеОтчета(ОтчетОбъект, ЭтаФорма);
	
КонецПроцедуры

Процедура ДействияФормыВосстановитьЗначения(Кнопка)
	
	СохранениеНастроек.ВыбратьНастройкуФормы(СохраненнаяНастройка, ЭтаФорма, "ОтчетОбъект." + ОтчетОбъект.Метаданные().Имя, Ложь);
	ТиповыеОтчеты.ОбновитьФормуТиповогоОтчетаПоКомпоновщику(ОтчетОбъект, ЭтаФорма);
	ТиповыеОтчеты.ОбновитьЗаголовокТиповогоОтчета(ОтчетОбъект, ЭтаФорма);
	
КонецПроцедуры

Процедура ДействияФормыСохранитьЗначения(Кнопка)
	
	СохранениеНастроек.ВыбратьНастройкуФормы(СохраненнаяНастройка, ЭтаФорма, "ОтчетОбъект." + ОтчетОбъект.Метаданные().Имя, Истина);
	ТиповыеОтчеты.ОбновитьЗаголовокТиповогоОтчета(ОтчетОбъект, ЭтаФорма);
	
КонецПроцедуры

Процедура ДействияФормыДействие(Кнопка)
	
	ОбновитьОтчет()
	
КонецПроцедуры

Процедура ТабличноеПолеОтборПриОкончанииРедактирования(Элемент, НоваяСтрока, ОтменаРедактирования)
	
	ТиповыеОтчеты.ОбработкаИзмененияТиповогоОтчетаНаФормеОтчета(ОтчетОбъект, ЭтаФорма);
	
КонецПроцедуры

Процедура СтрокаПериодПриИзменении(Элемент)
	
	РаботаСДиалогами.ДатаКакМесяцПодобратьДатуПоТексту(Элемент.Значение, Период);
	
	Элемент.Значение           = РаботаСДиалогами.ДатаКакМесяцПредставление(Период);
	
	ЗначениеПараметра          = КомпоновщикНастроек.Настройки.ПараметрыДанных.НайтиЗначениеПараметра(Новый ПараметрКомпоновкиДанных("Период"));;
	ЗначениеПараметра.Значение = НачалоМесяца(Период);
	ТиповыеОтчеты.ОбработкаИзмененияТиповогоОтчетаНаФормеОтчета(ОтчетОбъект, ЭтаФорма);

КонецПроцедуры

Процедура СтрокаПериодНачалоВыбораИзСписка(Элемент, СтандартнаяОбработка)
	
	РаботаСДиалогами.НачалоВыбораИзСпискаПредставленияПериодаРегистрации(Элемент, СтандартнаяОбработка, Период, ЭтаФорма);
	КомпоновщикНастроек.Настройки.ПараметрыДанных.Элементы.Найти("Период").Значение = НачалоМесяца(Период);
	ТиповыеОтчеты.ОбработкаИзмененияТиповогоОтчетаНаФормеОтчета(ОтчетОбъект, ЭтаФорма);

КонецПроцедуры

Процедура СтрокаПериодОчистка(Элемент, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;

КонецПроцедуры

Процедура СтрокаПериодРегулирование(Элемент, Направление, СтандартнаяОбработка)
	Период    = ДобавитьМесяц(Период, Направление);
	Элемент.Значение = РаботаСДиалогами.ДатаКакМесяцПредставление(Период);
	КомпоновщикНастроек.Настройки.ПараметрыДанных.Элементы.Найти("Период").Значение = НачалоМесяца(Период);
	ТиповыеОтчеты.ОбработкаИзмененияТиповогоОтчетаНаФормеОтчета(ОтчетОбъект, ЭтаФорма);

КонецПроцедуры

Процедура СтрокаПериодАвтоПодборТекста(Элемент, Текст, ТекстАвтоПодбора, СтандартнаяОбработка)
	
	РаботаСДиалогами.ДатаКакМесяцАвтоПодборТекста(Текст, ТекстАвтоПодбора, СтандартнаяОбработка);
	
КонецПроцедуры

Процедура СтрокаПериодОкончаниеВводаТекста(Элемент, Текст, Значение, СтандартнаяОбработка)
	
	РаботаСДиалогами.ДатаКакМесяцОкончаниеВводаТекста(Текст, Значение, СтандартнаяОбработка);

КонецПроцедуры





