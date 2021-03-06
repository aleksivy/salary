Процедура ДействияФормыДействие(Кнопка)
	
	Если ПроверятьСоставКолонок Тогда
		ПроверитьНеучтенныеВидыРасчета();
	КонецЕсли;
	
	//1. 
	СхемаКомпоновкиДанных = ПолучитьМакет("ОсновнаяСхемаКомпоновкиДанных");
	
	ПараметрыДанных = КомпоновщикНастроек.Настройки.ПараметрыДанных;
	
	конПериода =  ПараметрыДанных.НайтиЗначениеПараметра(Новый ПараметрКомпоновкиДанных("конПериода"));
	конПериода.Значение = КонецМесяца(Период);
	конПериода.Использование = Истина;
	
	начПериода =  ПараметрыДанных.НайтиЗначениеПараметра(Новый ПараметрКомпоновкиДанных("начПериода"));
	начПериода.Значение = НачалоМесяца(Период);
	начПериода.Использование = Истина;


	СледующийМесяц = ПараметрыДанных.НайтиЗначениеПараметра(Новый ПараметрКомпоновкиДанных("СледующийМесяц"));
	СледующийМесяц.Значение = КонецМесяца(Период) + 1;
	СледующийМесяц.Использование = Истина;

	
	//2.1
	Настройки = КомпоновщикНастроек.Настройки;
	///КомпоновщикНастроек.Инициализировать(Новый ИсточникДоступныхНастроекКомпоновкиДанных(ОтчетОбъект.СхемаКомпоновкиДанных));
	//ЗаполнитьПараметры(КомпоновщикНастроек.Настройки);
	//ЗаполнитьПараметры();
	
	//ЗначениеКонецПериода  = КомпоновщикНастроек.Настройки.ПараметрыДанных.НайтиЗначениеПараметра(Новый ПараметрКомпоновкиДанных("КонецПериода"));

	
	//2.7
	ПараметрВывода = Настройки.ПараметрыВывода.НайтиЗначениеПараметра(Новый ПараметрКомпоновкиДанных("ВыводитьОтбор"));
	ПараметрВывода.Использование = Истина;
	ПараметрВывода.Значение = ТипВыводаТекстаКомпоновкиДанных.НеВыводить;
	
	ПараметрВывода = Настройки.ПараметрыВывода.НайтиЗначениеПараметра(Новый ПараметрКомпоновкиДанных("ВыводитьПараметрыДанных"));
	ПараметрВывода.Использование = Истина;
	ПараметрВывода.Значение = ТипВыводаТекстаКомпоновкиДанных.НеВыводить;
	
	ПараметрВывода = Настройки.ПараметрыВывода.НайтиЗначениеПараметра(Новый ПараметрКомпоновкиДанных("МакетОформления"));
	ПараметрВывода.Использование = Истина;
	ПараметрВывода.Значение = БиблиотекаМакетовОформленияКомпоновкиДанных.БезОформления.Имя;
	
	//3
	КомпоновщикМакета  = Новый КомпоновщикМакетаКомпоновкиДанных;
	МакетКомпоновки= КомпоновщикМакета.Выполнить(СхемаКомпоновкиДанных, Настройки);
	
	//4
	ПроцессорКомпоновки = Новый ПроцессорКомпоновкиДанных;
	ПроцессорКомпоновки.Инициализировать(МакетКомпоновки);
	
	//5
	ДокументРезультат = ЭлементыФормы.Результат;
	ДокументРезультат.Очистить();
	
	ПроцессорВывода = Новый ПроцессорВыводаРезультатаКомпоновкиДанныхВТабличныйДокумент;
	ПроцессорВывода.УстановитьДокумент(ДокументРезультат);
	
	ПроцессорВывода.НачатьВывод();
	
	Пока Истина цикл
		ЭлементРезультата = ПроцессорКомпоновки.Следующий();
		Если ЭлементРезультата = Неопределено Тогда
			Прервать;
		Иначе
			ПроцессорВывода.ВывестиЭлемент(ЭлементРезультата);
		КонецЕсли;
		ДокументРезультат.ВывестиГоризонтальныйРазделительСтраниц();
	КонецЦикла;
	
	ПроцессорВывода.ЗакончитьВывод();
	
	ДокументРезультат.ОтображатьСетку = Ложь;
	//ДокументРезультат.Защита = Истина;
	ДокументРезультат.Показать();
	
КонецПроцедуры

// Процедура - обработчик нажатия кнопки "Отбор"
//
Процедура ДействияФормыОтбор(Кнопка)
	
	Кнопка.Пометка = Не Кнопка.Пометка;
	ПоказыватьБыстрыйОтбор = Кнопка.Пометка;
	ТиповыеОтчеты.УправлениеОтображениемЭлементовФормыТиповогоОтчета(ОтчетОбъект, ЭтаФорма);
	ТиповыеОтчеты.ОбработкаИзмененияТиповогоОтчетаНаФормеОтчета(ОтчетОбъект, ЭтаФорма);
	
КонецПроцедуры //ДействияФормыОтбор()

// Процедура - обработчик нажатия кнопки "НовыйОтчет"
//
Процедура ДействияФормыОткрытьВНовомОкне(Кнопка)
	
	ТиповыеОтчеты.ОткрытьВНовомОкнеТиповойОтчет(ОтчетОбъект
	, ЭтаФорма);
	
КонецПроцедуры //ДействияФормыОткрытьВНовомОкне()

// Процедура - обработчик нажатия кнопки "Заголовок".
//
Процедура КоманднаяПанельЗаголовок(Кнопка)
	
	Кнопка.Пометка = Не Кнопка.Пометка;
	ТиповыеОтчеты.УправлениеОтображениемЭлементовФормыТиповогоОтчета(ОтчетОбъект, ЭтаФорма);
	ТиповыеОтчеты.УправлениеОтображениемЗаголовкаТиповогоОтчета(ОтчетОбъект, ЭтаФорма.ЭлементыФормы.Результат);
	
КонецПроцедуры //КоманднаяПанельЗаголовок()

Процедура ПериодНачалоВыбораИзСписка(Элемент, СтандартнаяОбработка)
	РаботаСДиалогами.НачалоВыбораИзСпискаПредставленияПериодаРегистрации(Элемент, СтандартнаяОбработка, Период, ЭтаФорма);
КонецПроцедуры

Процедура ПериодОчистка(Элемент, СтандартнаяОбработка)
	СтандартнаяОбработка = Ложь;
КонецПроцедуры

Процедура ПериодРегулирование(Элемент, Направление, СтандартнаяОбработка)
	РаботаСДиалогами.РегулированиеПредставленияПериодаРегистрации(Направление, СтандартнаяОбработка, Период, ПредставлениеПериода);
КонецПроцедуры

Процедура ПриОткрытии()	
	
ЗаполнитьПараметры();
КонецПроцедуры

Процедура ПередЗакрытием(Отказ, СтандартнаяОбработка)
	СохранитьНастройкиПользователя(); //настройки сохраняем самостятельно, для того чтоб нормально сохранялись параметы СКД
КонецПроцедуры

Процедура ПередОткрытием(Отказ, СтандартнаяОбработка)
	ТиповыеОтчеты.НазначитьФормеУникальныйКлючИдентификации(ЭтаФорма);
	ТиповыеОтчеты.УправлениеОтображениемЭлементовФормыТиповогоОтчета(ОтчетОбъект, ЭтаФорма);
	
	ЗначениеПараметраначПериода = КомпоновщикНастроек.Настройки.ПараметрыДанных.НайтиЗначениеПараметра(Новый ПараметрКомпоновкиДанных("начПериода"));	
	ЗначениеПараметраконПериода = КомпоновщикНастроек.Настройки.ПараметрыДанных.НайтиЗначениеПараметра(Новый ПараметрКомпоновкиДанных("конПериода"));	
	Если ЗначениеПараметраначПериода.Значение = '00010101' тогда
		
		РД = ОбщегоНазначения.ПолучитьРабочуюДату();
		
		ЗначениеПараметраначПериода.Значение = НачалоМесяца(РД);
		ЗначениеПараметраконПериода.Значение = КонецМесяца(РД)
		
	КонецЕсли;
	
	Период = ЗначениеПараметраначПериода.Значение;
	
	ПредставлениеПериода= РаботаСДиалогами.ДатаКакМесяцПредставление(Период);


КонецПроцедуры

Процедура ДействияФормыНастройка(Кнопка)
		ФормаНастройки = ПолучитьФорму("ФормаНастройки", ЭтаФорма);
		ФормаНастройки.ОткрытьМодально();
		// Заполним настройки формы
//	ФормаНастройки.ОтчетОбъект = ЭтотОтчет;
	
	// Откроем форму настройки
//	Сформировать = ФормаНастройки.ОткрытьМодально();

КонецПроцедуры

// Процедура - обработчик нажатия кнопки "ВосстановитьЗначения"
//
Процедура ДействияФормыВосстановитьЗначение(Кнопка)
	
	СохранениеНастроек.ВыбратьНастройкуФормы(СохраненнаяНастройка, ЭтаФорма, "ОтчетОбъект." + ОтчетОбъект.Метаданные().Имя, Ложь);
//	ТиповыеОтчеты.ОбновитьФормуТиповогоОтчетаПоКомпоновщику(ОтчетОбъект, ЭтаФорма);
//	ТиповыеОтчеты.ОбновитьЗаголовокТиповогоОтчета(ОтчетОбъект, ЭтаФорма);
   	ПредставлениеПериода= РаботаСДиалогами.ДатаКакМесяцПредставление(Период);

КонецПроцедуры //ДействияФормыВосстановитьЗначения()

// Процедура - обработчик нажатия кнопки "СохранитьЗначения"
//
Процедура ДействияФормыСохранитьЗначение(Кнопка)
	
	СохранениеНастроек.ВыбратьНастройкуФормы(СохраненнаяНастройка, ЭтаФорма, "ОтчетОбъект." + ОтчетОбъект.Метаданные().Имя, Истина);
	ТиповыеОтчеты.ОбновитьЗаголовокТиповогоОтчета(ОтчетОбъект, ЭтаФорма);
	
КонецПроцедуры //ДействияФормыСохранитьЗначения()

// Процедура - обработчик нажатия кнопки "Печать"
//
Процедура ДействияФормыПечать(Кнопка)
	
	ТиповыеОтчеты.ПечатьТиповогоОтчета(ЭлементыФормы.Результат);
	
КонецПроцедуры //ДействияФормыПечать()

Процедура ТабличноеПолеОтборПравоеЗначениеДляКраткогоОтображенияЭлементаНачалоВыбора(Элемент, СтандартнаяОбработка)
	
	ФормированиеПечатныхФорм.ПодставитьОтборОрганизации(Элемент, КомпоновщикНастроек, Новый ПолеКомпоновкиДанных("Организация"), ЭтотОбъект, СтандартнаяОбработка);
	
КонецПроцедуры
