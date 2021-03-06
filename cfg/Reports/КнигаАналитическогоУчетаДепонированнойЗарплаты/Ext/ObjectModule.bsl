#Если Клиент Тогда
	
Функция ПроверкаПериода()

	ПроверкаПройдена = Истина;

	Если ДатаНач > ДатаКон Тогда

		Предупреждение(НСтр("ru='Неправильно задан период формирования отчета!';uk='Неправильно заданий період формування звіту!'")+Символы.ПС+
		               НСтр("ru='Дата начала больше даты окончания периода.';uk='Дата початку більше дати закінчення періоду.'"));

		ПроверкаПройдена = Ложь;

	ИначеЕсли ДатаНач = '00010101' Тогда

		Предупреждение(НСтр("ru='Не указана дата начала отчета';uk='Не зазначена дата початку звіту'"));

		ПроверкаПройдена = Ложь;

	ИначеЕсли ДатаКон = '00010101' Тогда

		Предупреждение(НСтр("ru='Не указана дата конца отчета';uk='Не зазначена дата кінця звіту'"));

		ПроверкаПройдена=Ложь;

	КонецЕсли;

	Возврат ПроверкаПройдена;

КонецФункции // ПроверкаПериода()

////////////////////////////////////////////////////////////////////////////////
// ЭКСПОРТНЫЕ ПРОЦЕДУРЫ И ФУНКЦИИ

Процедура СформироватьОтчет(ДокументРезультат) Экспорт
	
	Если НЕ ПроверкаПериода() Тогда
		Возврат;
	КонецЕсли;
	
	Если Организация.Пустая() Тогда
		Сообщить(НСтр("ru='Не выбрана организация.';uk='Не обрана організація.'"));
		Возврат;
	КонецЕсли;
	
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("ДатаНач", ДатаНач);
	Запрос.УстановитьПараметр("ДатаКон", ДатаКон);
	Запрос.УстановитьПараметр("Приход", ВидДвиженияНакопления.Приход);
	Запрос.УстановитьПараметр("Расход", ВидДвиженияНакопления.Расход); 
	Запрос.УстановитьПараметр("ПустаяДата", '00010101');
	Запрос.УстановитьПараметр("Организация", Организация);
	Запрос.УстановитьПараметр("ВнутреннееСовместительство", Перечисления.ВидыЗанятостиВОрганизации.ВнутреннееСовместительство);
	Запрос.УстановитьПараметр("Уволен", Перечисления.ПричиныИзмененияСостояния.Увольнение);
	Запрос.УстановитьПараметр("ГоловнаяОрганизация", Организация);
	Запрос.Текст =
	"ВЫБРАТЬ
	|	РаботникиОрганизацийСрезПоследних.Сотрудник.Код КАК ТабельныйНомер,
	|	Депоненты.Физлицо,
	|	ЕСТЬNULL(ФИОФизЛицСрезПоследних.Фамилия + "" "" + ФИОФизЛицСрезПоследних.Имя + "" "" + ФИОФизЛицСрезПоследних.Отчество, Депоненты.Физлицо.Наименование) КАК ФИО,
	|	Депоненты.Ведомость КАК Ведомость,
	|	Депоненты.Ведомость.Номер КАК Номер,
	|	Депоненты.Ведомость.Дата КАК Дата,
	|	ВЫБОР
	|		КОГДА Депоненты.Период < &ДатаНач
	|			ТОГДА &ПустаяДата
	|		ИНАЧЕ НАЧАЛОПЕРИОДА(Депоненты.Период, МЕСЯЦ)
	|	КОНЕЦ КАК Поле,
	|	Депоненты.Период КАК Период,
	|	НАЧАЛОПЕРИОДА(Депоненты.Период, МЕСЯЦ) КАК Месяц,
	|	Депоненты.Остаток КАК НачальныйОстаток,
	|	ВзаиморасчетыСДепонентамиОрганизацийОбороты.Период КАК МесяцВыплаты,
	|	ВзаиморасчетыСДепонентамиОрганизацийОбороты.СуммаРасход КАК СуммаРасход
	|ИЗ
	|	(ВЫБРАТЬ
	|		ВзаиморасчетыСДепонентамиОрганизацийОстатки.Организация КАК Организация,
	|		ВзаиморасчетыСДепонентамиОрганизацийОстатки.Сотрудник.Физлицо КАК Физлицо,
	|		ВзаиморасчетыСДепонентамиОрганизацийОстатки.Ведомость КАК Ведомость,
	|		МИНИМУМ(ВзаиморасчетыСДепонентамиОрганизаций.Период) КАК Период,
	|		ВзаиморасчетыСДепонентамиОрганизацийОстатки.СуммаОстаток КАК Остаток
	|	ИЗ
	|		РегистрНакопления.ВзаиморасчетыСДепонентамиОрганизаций.Остатки(&ДатаНач, Организация = &Организация) КАК ВзаиморасчетыСДепонентамиОрганизацийОстатки
	|			ЛЕВОЕ СОЕДИНЕНИЕ РегистрНакопления.ВзаиморасчетыСДепонентамиОрганизаций КАК ВзаиморасчетыСДепонентамиОрганизаций
	|			ПО ВзаиморасчетыСДепонентамиОрганизацийОстатки.Организация = ВзаиморасчетыСДепонентамиОрганизаций.Организация
	|				И ВзаиморасчетыСДепонентамиОрганизацийОстатки.Сотрудник.Физлицо = ВзаиморасчетыСДепонентамиОрганизаций.Сотрудник.Физлицо
	|				И ВзаиморасчетыСДепонентамиОрганизацийОстатки.Ведомость = ВзаиморасчетыСДепонентамиОрганизаций.Ведомость
	|	ГДЕ
	|		ВзаиморасчетыСДепонентамиОрганизацийОстатки.СуммаОстаток > 0
	|		И ВзаиморасчетыСДепонентамиОрганизаций.ВидДвижения = &Приход
	|		И ВзаиморасчетыСДепонентамиОрганизаций.Сумма > 0
	|	
	|	СГРУППИРОВАТЬ ПО
	|		ВзаиморасчетыСДепонентамиОрганизацийОстатки.Сотрудник.Физлицо,
	|		ВзаиморасчетыСДепонентамиОрганизацийОстатки.Ведомость,
	|		ВзаиморасчетыСДепонентамиОрганизацийОстатки.Организация,
	|		ВзаиморасчетыСДепонентамиОрганизацийОстатки.СуммаОстаток
	|	
	|	ОБЪЕДИНИТЬ
	|	
	|	ВЫБРАТЬ РАЗЛИЧНЫЕ
	|		НовыеДепоненты.Организация,
	|		НовыеДепоненты.Физлицо,
	|		НовыеДепоненты.Ведомость,
	|		НовыеДепоненты.Период,
	|		ВзаиморасчетыСДепонентамиОрганизаций.Сумма
	|	ИЗ
	|		(ВЫБРАТЬ РАЗЛИЧНЫЕ
	|			ВзаиморасчетыСДепонентамиОрганизаций.Организация КАК Организация,
	|			ВзаиморасчетыСДепонентамиОрганизаций.Сотрудник.Физлицо КАК Физлицо,
	|			ВзаиморасчетыСДепонентамиОрганизаций.Ведомость КАК Ведомость,
	|			МИНИМУМ(ВзаиморасчетыСДепонентамиОрганизаций.Период) КАК Период
	|		ИЗ
	|			РегистрНакопления.ВзаиморасчетыСДепонентамиОрганизаций КАК ВзаиморасчетыСДепонентамиОрганизаций
	|		ГДЕ
	|			ВзаиморасчетыСДепонентамиОрганизаций.ВидДвижения = &Приход
	|			И ВзаиморасчетыСДепонентамиОрганизаций.Сумма > 0
	|			И ВзаиморасчетыСДепонентамиОрганизаций.Организация = &Организация
	|			И ВзаиморасчетыСДепонентамиОрганизаций.Период МЕЖДУ &ДатаНач И &ДатаКон
	|		
	|		СГРУППИРОВАТЬ ПО
	|			ВзаиморасчетыСДепонентамиОрганизаций.Сотрудник.Физлицо,
	|			ВзаиморасчетыСДепонентамиОрганизаций.Ведомость,
	|			ВзаиморасчетыСДепонентамиОрганизаций.Организация) КАК НовыеДепоненты
	|			ЛЕВОЕ СОЕДИНЕНИЕ РегистрНакопления.ВзаиморасчетыСДепонентамиОрганизаций КАК ВзаиморасчетыСДепонентамиОрганизаций
	|			ПО НовыеДепоненты.Период = ВзаиморасчетыСДепонентамиОрганизаций.Период
	|				И НовыеДепоненты.Организация = ВзаиморасчетыСДепонентамиОрганизаций.Организация
	|				И НовыеДепоненты.Физлицо = ВзаиморасчетыСДепонентамиОрганизаций.Сотрудник.Физлицо
	|				И НовыеДепоненты.Ведомость = ВзаиморасчетыСДепонентамиОрганизаций.Ведомость) КАК Депоненты
	|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрНакопления.ВзаиморасчетыСДепонентамиОрганизаций.Обороты(&ДатаНач, &ДатаКон, Месяц, Организация = &Организация) КАК ВзаиморасчетыСДепонентамиОрганизацийОбороты
	|		ПО Депоненты.Физлицо = ВзаиморасчетыСДепонентамиОрганизацийОбороты.Сотрудник.Физлицо
	|			И Депоненты.Ведомость = ВзаиморасчетыСДепонентамиОрганизацийОбороты.Ведомость
	|			И Депоненты.Организация = ВзаиморасчетыСДепонентамиОрганизацийОбороты.Организация
	|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.ФИОФизЛиц.СрезПоследних(&ДатаКон, ) КАК ФИОФизЛицСрезПоследних
	|		ПО Депоненты.Физлицо = ФИОФизЛицСрезПоследних.ФизЛицо
	|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.РаботникиОрганизаций.СрезПоследних(
	|		&ДатаКон,
	|		Организация = &ГоловнаяОрганизация
	|		    И (Сотрудник.ВидЗанятости <> &ВнутреннееСовместительство
	|		        ИЛИ Сотрудник.ВидЗанятости ЕСТЬ NULL )) КАК РаботникиОрганизацийСрезПоследних
	|		ПО Депоненты.Физлицо = РаботникиОрганизацийСрезПоследних.Сотрудник.Физлицо
	|			И (РаботникиОрганизацийСрезПоследних.ПричинаИзмененияСостояния <> &Уволен)
	|
	|УПОРЯДОЧИТЬ ПО
	|	Поле,
	|	Период,
	|	ФИО,
	|	Ведомость";
	
	Выборка = Запрос.Выполнить().Выбрать();
	ВсегоСтрокДокумента = Выборка.Количество();
	
	ДокументРезультат.Очистить();
	Макет = ПолучитьМакет("КнигаУчета");
	
	КодЯзыкаПечать = Локализация.ПолучитьЯзыкФормированияПечатныхФорм(УправлениеПользователями.ПолучитьЗначениеПоУмолчанию(глЗначениеПеременной("глТекущийПользователь"), "РежимФормированияПечатныхФорм"));
	Макет.КодЯзыкаМакета = КодЯзыкаПечать;
	
	ОбластьМакетаШапкаДокумента = Макет.ПолучитьОбласть("ШапкаДокумента");
	ОбластьМакетаШапка			= Макет.ПолучитьОбласть("Шапка");
	ОбластьМакетаСтрока 		= Макет.ПолучитьОбласть("Строка");
	ОбластьМакетаОстатокНаНачало = Макет.ПолучитьОбласть("ОстатокНаНачало");
	ОбластьМакетаПодвал 		= Макет.ПолучитьОбласть("Подвал");
	ОбластьМакетаПодвалМесяца	= Макет.ПолучитьОбласть("ПодвалМесяца");
	
	ОбластьМакетаШапкаДокумента.Параметры.Организация = ?(ПустаяСтрока(Организация.НаименованиеПолное),Организация.Наименование,Организация.НаименованиеПолное);
	ОбластьМакетаШапкаДокумента.Параметры.ДатаC = Формат(ДатаНач,"Л="+Локализация.ОпределитьКодЯзыкаДляФормат(КодЯзыкаПечать)+"; ДЛФ=DD");
	ОбластьМакетаШапкаДокумента.Параметры.ДатаПо = Формат(ДатаКон,"Л="+Локализация.ОпределитьКодЯзыкаДляФормат(КодЯзыкаПечать)+"; ДЛФ=DD");
	ДокументРезультат.Вывести(ОбластьМакетаШапкаДокумента);
	ДокументРезультат.Вывести(ОбластьМакетаШапка);
	
	// массив с двумя строками - для разбиения на страницы
    ВыводимыеОбласти = Новый Массив();
	ВыводимыеОбласти.Добавить(ОбластьМакетаСтрока);
	ВыводимыеОбласти.Добавить(ОбластьМакетаПодвалМесяца);
	
	ОстатокНаКонец = 0;
	ОстатокНаНачалоВыведен = Ложь;
	РасходМесяца = Новый Массив;
	Для Сч = 1 По 12 Цикл
		РасходМесяца.Добавить(0)	
	КонецЦикла; 
	
	ВыведеноСтрок = 0;
	Пока Выборка.СледующийПоЗначениюПоля("Поле") Цикл
		
		ПриходМесяца = 0;
		
		Если Выборка.Поле > '00010101' И Не ОстатокНаНачалоВыведен Тогда
			ОбластьМакетаОстатокНаНачало.Параметры.ОстатокНаНачало = ПриходМесяца;
			ДокументРезультат.Вывести(ОбластьМакетаОстатокНаНачало);
		КонецЕсли;
		
		Пока Выборка.СледующийПоЗначениюПоля("Период") Цикл
			Пока Выборка.СледующийПоЗначениюПоля("ФИО") Цикл
				Пока Выборка.СледующийПоЗначениюПоля("Ведомость") Цикл
					ОбластьМакетаСтрока.Параметры.Заполнить(Выборка);
					ОбластьМакетаСтрока.Параметры.Дата = Формат(ОбластьМакетаСтрока.Параметры.Дата,"ДФ=dd.MM.yyyy");
					ПриходМесяца = ПриходМесяца + Выборка.НачальныйОстаток;
					ОстатокНаКонец = ОстатокНаКонец + Выборка.НачальныйОстаток;
					Для СчМес = 1 По 12 Цикл
						ОбластьМакетаСтрока.Параметры["МесяцВыплаты" + СчМес] = 0;						
					КонецЦикла;
					Пока Выборка.Следующий() Цикл // по месяцам выплаты	
						Если ЗначениеЗаполнено(Выборка.МесяцВыплаты) Тогда
							ТекущийМесяцВыплаты = Месяц(Выборка.МесяцВыплаты);
							ОбластьМакетаСтрока.Параметры["МесяцВыплаты" + ТекущийМесяцВыплаты] = Выборка.СуммаРасход;
							РасходМесяца[ТекущийМесяцВыплаты - 1] = РасходМесяца[ТекущийМесяцВыплаты - 1] + Выборка.СуммаРасход;
							ОстатокНаКонец = ОстатокНаКонец - Выборка.СуммаРасход;
						КонецЕсли;
					КонецЦикла;
					// разбиение на страницы
					ВыведеноСтрок = ВыведеноСтрок + 1;
					// Проверим, уместится ли строка на странице или надо открывать новую страницу
					ВывестиПодвалЛиста = Не ФормированиеПечатныхФорм.ПроверитьВыводТабличногоДокумента(ДокументРезультат,ВыводимыеОбласти);
					Если Не ВывестиПодвалЛиста и ВыведеноСтрок = ВсегоСтрокДокумента Тогда
						ВыводимыеОбласти.Добавить(ОбластьМакетаПодвал);
						ВывестиПодвалЛиста = Не ФормированиеПечатныхФорм.ПроверитьВыводТабличногоДокумента(ДокументРезультат,ВыводимыеОбласти);
					КонецЕсли;
					Если ВывестиПодвалЛиста Тогда
						ДокументРезультат.ВывестиГоризонтальныйРазделительСтраниц();
						ДокументРезультат.Вывести(ОбластьМакетаШапка);
					КонецЕсли;
					ДокументРезультат.Вывести(ОбластьМакетаСтрока);
				КонецЦикла;
			КонецЦикла;
		КонецЦикла;
		
		Если Выборка.Поле = '00010101' Тогда
			ОбластьМакетаОстатокНаНачало.Параметры.ОстатокНаНачало = ПриходМесяца;
			ОстатокНаНачалоВыведен = Истина;
			// Проверим, уместится ли строка на странице или надо открывать новую страницу
			ВывестиПодвалЛиста = Не ФормированиеПечатныхФорм.ПроверитьВыводТабличногоДокумента(ДокументРезультат,ОбластьМакетаОстатокНаНачало);
			Если Не ВывестиПодвалЛиста и ВыведеноСтрок = ВсегоСтрокДокумента Тогда
				ВыводимыеОбласти.Очистить();
				ВыводимыеОбласти.Добавить(ОбластьМакетаОстатокНаНачало);
				ВыводимыеОбласти.Добавить(ОбластьМакетаПодвалМесяца);
				ВыводимыеОбласти.Добавить(ОбластьМакетаПодвал);
				ВывестиПодвалЛиста = Не ФормированиеПечатныхФорм.ПроверитьВыводТабличногоДокумента(ДокументРезультат,ВыводимыеОбласти);
			КонецЕсли;
			Если ВывестиПодвалЛиста Тогда
				ДокументРезультат.ВывестиГоризонтальныйРазделительСтраниц();
				ДокументРезультат.Вывести(ОбластьМакетаШапка);
			КонецЕсли;
			ДокументРезультат.Вывести(ОбластьМакетаОстатокНаНачало);
			Если ВыведеноСтрок = ВсегоСтрокДокумента Тогда
			ОбластьМакетаПодвалМесяца.Параметры.НадписьПриходМесяца = НСтр("ru='Итого задепонировано за :';uk='Разом задепоновано за :'",КодЯзыкаПечать);	
			ОбластьМакетаПодвалМесяца.Параметры.НадписьРасходМесяца = НСтр("ru='Итого выплачено (списано) за :';uk='Разом виплачено (списано) за :'",КодЯзыкаПечать);	
				ДокументРезультат.Вывести(ОбластьМакетаПодвалМесяца);
			КонецЕсли;
		Иначе
			ОбластьМакетаПодвалМесяца.Параметры.НадписьПриходМесяца = НСтр("ru='Итого задепонировано за ';uk='Разом задепоновано за '",КодЯзыкаПечать) + Формат(Выборка.Поле,"Л="+Локализация.ОпределитьКодЯзыкаДляФормат(КодЯзыкаПечать)+"; ДФ='ММММ гггг'");	
			ОбластьМакетаПодвалМесяца.Параметры.НадписьРасходМесяца = НСтр("ru='Итого выплачено (списано) за ';uk='Разом виплачено (списано) за '",КодЯзыкаПечать) + Формат(Выборка.Поле,"Л="+Локализация.ОпределитьКодЯзыкаДляФормат(КодЯзыкаПечать)+"; ДФ='ММММ гггг'");	
			ОбластьМакетаПодвалМесяца.Параметры.ПриходМесяца = ПриходМесяца;	
			ОбластьМакетаПодвалМесяца.Параметры.РасходМесяца = РасходМесяца[Месяц(Выборка.Поле) - 1];	
			
			// Проверим, уместится ли строка на странице или надо открывать новую страницу
			ВывестиПодвалЛиста = Не ФормированиеПечатныхФорм.ПроверитьВыводТабличногоДокумента(ДокументРезультат,ОбластьМакетаПодвалМесяца);
			Если Не ВывестиПодвалЛиста и ВыведеноСтрок = ВсегоСтрокДокумента Тогда
				ВыводимыеОбласти.Очистить();
				ВыводимыеОбласти.Добавить(ОбластьМакетаПодвалМесяца);
				ВыводимыеОбласти.Добавить(ОбластьМакетаПодвал);
				ВывестиПодвалЛиста = Не ФормированиеПечатныхФорм.ПроверитьВыводТабличногоДокумента(ДокументРезультат,ВыводимыеОбласти);
			КонецЕсли;
			Если ВывестиПодвалЛиста Тогда
				ДокументРезультат.ВывестиГоризонтальныйРазделительСтраниц();
				ДокументРезультат.Вывести(ОбластьМакетаШапка);
			КонецЕсли;
			ДокументРезультат.Вывести(ОбластьМакетаПодвалМесяца);
			
		КонецЕсли;
		
	КонецЦикла;
	
	// если не было ни одного работника - выводим пустой бланк
    ВыводимыеОбласти = Новый Массив();
	ВыводимыеОбласти.Добавить(ОбластьМакетаСтрока);
	ВыводимыеОбласти.Добавить(ОбластьМакетаПодвалМесяца);
	ВыводимыеОбласти.Добавить(ОбластьМакетаПодвал);
	Для Сч = 1 По ОбластьМакетаСтрока.Параметры.Количество() Цикл
		ОбластьМакетаСтрока.Параметры.Установить(Сч - 1,""); 
	КонецЦикла;
	ОбластьМакетаСтрока.Параметры.ФИО = " " + Символы.ПС + " ";
	Пока ФормированиеПечатныхФорм.ПроверитьВыводТабличногоДокумента(ДокументРезультат,ВыводимыеОбласти) Цикл
		ДокументРезультат.Вывести(ОбластьМакетаСтрока);
	КонецЦикла;
	
	ОбластьМакетаПодвал.Параметры.ОстатокНаКонец = ОстатокНаКонец;
	ДокументРезультат.Вывести(ОбластьМакетаПодвал);
	
	ДокументРезультат.ТолькоПросмотр=Истина;
	
КонецПроцедуры // СформироватьРезультат()

#КонецЕсли
