﻿
Процедура КнопкаВыполнитьНажатие(Кнопка)
	
	Если Не ЗначениеЗаполнено(ПлатежнаяВедомостьДляБанков) Тогда 
		Предупреждение ("Не указан документ для выгрузки файлов банка!"); 
		Возврат;
	КонецЕсли;
	Если Не ЗначениеЗаполнено(ПлатежнаяВедомостьДляБанков.ПапкаДляДБФ) Тогда 
		Предупреждение ("Не указана папка для выгрузки файлов банка в документе - " + ПлатежнаяВедомостьДляБанков + "!"); 
		Возврат;
	КонецЕсли;
	Если Не ЗначениеЗаполнено(ПлатежнаяВедомостьДляБанков.ДатаВалютирования) Тогда 
		Предупреждение ("Не указана дата валютирования в документе - " + ПлатежнаяВедомостьДляБанков + "!"); 
		Возврат;
	КонецЕсли;
	Если Не ЗначениеЗаполнено(ПлатежнаяВедомостьДляБанков.ТипПлатежа) Тогда 
		Предупреждение ("Не указана тип платежа в документе - " + ПлатежнаяВедомостьДляБанков + "!"); 
		Возврат;
	КонецЕсли;
	
	ВидВыплаты = ПлатежнаяВедомостьДляБанков.ВидВыплаты;
	Если (ВидВыплаты = Справочники.ВидыВыплат.Депоненты) или (ВидВыплаты = Справочники.ВидыВыплат.Дивиденды) или 
		(ВидВыплаты = Справочники.ВидыВыплат.ЗакрытиеПериода) или (ВидВыплаты = Справочники.ВидыВыплат.НДФЛБезВыплатыЗарплаты) или
		(ВидВыплаты = Справочники.ВидыВыплат.НДФЛКонтрагентам) или (ВидВыплаты = Справочники.ВидыВыплат.ОчереднаяВзносы) или 
		(ВидВыплаты = Справочники.ВидыВыплат.ОчереднаяПогашениеДолговВзносы) Тогда
		Предупреждение ("Для выбранного вида выплаты dbf Файл не формируется!"); 
		Возврат;
	КонецЕсли;
	
	// Формируем ведомость 
	лмасПараметры = Новый Массив;
	
	лТут = Новый Соответствие; лТут.Вставить("DATE_DOC", Формат(ПлатежнаяВедомостьДляБанков.Дата, "ДФ=dd.MM.yyyy")); лмасПараметры.Добавить( лТут );
	лТут = Новый Соответствие; лТут.Вставить("NUM_DOC", СокрЛП(ПлатежнаяВедомостьДляБанков.Номер) ); лмасПараметры.Добавить( лТут );
	лТут = Новый Соответствие; лТут.Вставить("PAYER_BANK_MFO", "351005" ); лмасПараметры.Добавить( лТут );
	лТут = Новый Соответствие; лТут.Вставить("PAYER_ACCOUNT", "UA873510050000026007654802300" ); лмасПараметры.Добавить( лТут );
	
	лНомСтроки = 0;
	Для каждого лСтрока Из ПлатежнаяВедомостьДляБанков.ВыплатаЗаработнойПлаты Цикл
		Если Не СтрДлина(СокрЛП(лСтрока.НомерКарточки)) = 29 Тогда 
			Предупреждение ("В строке - " + лСтрока.НомерСтроки + " документа - " + ПлатежнаяВедомостьДляБанков + " неправильная длина карточного счета!"); 
			Возврат;
		КонецЕсли;
		Если Не ЗначениеЗаполнено(лСтрока.Сотрудник) Тогда 
			Предупреждение ("В строке - " + лСтрока.НомерСтроки + " документа - " + ПлатежнаяВедомостьДляБанков + " не заполнено поле сотрудник!"); 
			Возврат;
		КонецЕсли;
		Если Не ЗначениеЗаполнено(лСтрока.Сотрудник.Физлицо.КодПоДРФО) Тогда 
			Предупреждение ("Для сотрудника - " + лСтрока.Сотрудник.Физлицо + " не заполнен код по ДРФО!"); 
			Возврат;
		КонецЕсли;
		Если лСтрока.Сумма <= 0 Тогда 
			Предупреждение ("В строке - " + лСтрока.НомерСтроки + " документа - " + ПлатежнаяВедомостьДляБанков + " указана неправильная сумма!"); 
			Возврат;
		КонецЕсли;
		лТут = Новый Соответствие; лТут.Вставить("CARD_HOLDERS." + лНомСтроки + ".CARD_NUM", СокрЛП(лСтрока.НомерКарточки) ); лмасПараметры.Добавить( лТут );
		лТут = Новый Соответствие; лТут.Вставить("CARD_HOLDERS." + лНомСтроки + ".CARD_HOLDER", СокрЛП(лСтрока.Сотрудник.Физлицо) ); лмасПараметры.Добавить( лТут );
		лТут = Новый Соответствие; лТут.Вставить("CARD_HOLDERS." + лНомСтроки + ".CARD_HOLDER_INN", СокрЛП(лСтрока.Сотрудник.Физлицо.КодПоДРФО) ); лмасПараметры.Добавить( лТут );
		лТут = Новый Соответствие; лТут.Вставить("CARD_HOLDERS." + лНомСтроки + ".AMOUNT", Формат(лСтрока.Сумма, "ЧДЦ=2; ЧРД=.; ЧГ=0") ); лмасПараметры.Добавить( лТут );
		лНомСтроки = лНомСтроки + 1;
	КонецЦикла;
	
	лТут = Новый Соответствие; лТут.Вставить("ONFLOW_TYPE", СокрЛП(ПлатежнаяВедомостьДляБанков.ТипПлатежа) ); лмасПараметры.Добавить( лТут );
	лТут = Новый Соответствие; лТут.Вставить("AMOUNT", Формат(ПлатежнаяВедомостьДляБанков.ВыплатаЗаработнойПлаты.Итог("Сумма"), "ЧДЦ=2; ЧРД=.; ЧГ=0") ); лмасПараметры.Добавить( лТут );
	лТут = Новый Соответствие; лТут.Вставить("VALUE_DATE", Формат(ПлатежнаяВедомостьДляБанков.ДатаВалютирования, "ДФ=dd.MM.yyyy")); лмасПараметры.Добавить( лТут );
	лТут = Новый Соответствие; лТут.Вставить("BEGIN_MONTH", Месяц(ПлатежнаяВедомостьДляБанков.Дата) ); лмасПараметры.Добавить( лТут );
	лТут = Новый Соответствие; лТут.Вставить("BEGIN_YEAR", Формат(Год(ПлатежнаяВедомостьДляБанков.Дата),"ЧДЦ=0; ЧГ=0") ); лмасПараметры.Добавить( лТут );
	
	лТекст = Новый ТекстовыйДокумент;
	лТекст.ДобавитьСтроку( "Content-Type=doc/pay_sheet" );
	лТекст.ДобавитьСтроку( "" );
	Для каждого лСтрока Из лмасПараметры Цикл
		Для каждого лЭлемент Из лСтрока Цикл
			лТекст.ДобавитьСтроку( лЭлемент.Ключ + "=" + лЭлемент.Значение );
		КонецЦикла;
	КонецЦикла;
	лТекст.Записать( СокрЛП(ПлатежнаяВедомостьДляБанков.ПапкаДляДБФ) + "\vedomost.txt", КодировкаТекста.ANSI );
	
	// Формируем платежное поручение к ведомости
	лмасПараметры = Новый Массив;
	
	лТут = Новый Соответствие; лТут.Вставить("DATE_DOC", Формат(ПлатежнаяВедомостьДляБанков.Дата, "ДФ=dd.MM.yyyy")); лмасПараметры.Добавить( лТут );
	лТут = Новый Соответствие; лТут.Вставить("NUM_DOC", "" ); лмасПараметры.Добавить( лТут );
	лТут = Новый Соответствие; лТут.Вставить("AMOUNT", Формат(ПлатежнаяВедомостьДляБанков.ВыплатаЗаработнойПлаты.Итог("Сумма"), "ЧДЦ=2; ЧРД=.; ЧГ=0") ); лмасПараметры.Добавить( лТут );
	
	лТут = Новый Соответствие; лТут.Вставить("CLN_NAME", "ПІІ ГЛЕНКОР АГРІКАЛЧЕР УКРАЇНА" ); лмасПараметры.Добавить( лТут );
	лТут = Новый Соответствие; лТут.Вставить("CLN_OKPO", "23393195" ); лмасПараметры.Добавить( лТут );
	лТут = Новый Соответствие; лТут.Вставить("CLN_ACCOUNT", "UA873510050000026007654802300" ); лмасПараметры.Добавить( лТут );
	лТут = Новый Соответствие; лТут.Вставить("CLN_BANK_MFO", "351005" ); лмасПараметры.Добавить( лТут );
	
	
	лТут = Новый Соответствие; лТут.Вставить("RCPT_NAME", "АТ ""УКРСИББАНК""" ); лмасПараметры.Добавить( лТут );
	лТут = Новый Соответствие; лТут.Вставить("RCPT_OKPO", "09807750" ); лмасПараметры.Добавить( лТут );
	лТут = Новый Соответствие; лТут.Вставить("RCPT_ACCOUNT", "UA233510050000029242000000110" ); лмасПараметры.Добавить( лТут );
	лТут = Новый Соответствие; лТут.Вставить("RCPT_BANK_MFO", "351005" ); лмасПараметры.Добавить( лТут );
	
	лНазначениеПлатежа = СокрЛП(ПлатежнаяВедомостьДляБанков.ТипПлатежа) + " ПІІ ГЛЕНКОР АГРІКАЛЧЕР УКРАЇНА згiдно вiдомостi N " + СокрЛП(ПлатежнаяВедомостьДляБанков.Номер) + " вiд " + Формат(ПлатежнаяВедомостьДляБанков.Дата, "ДФ=dd.MM.yyyy");
	лТут = Новый Соответствие; лТут.Вставить("PAYMENT_DETAILS", лНазначениеПлатежа ); лмасПараметры.Добавить( лТут );
	
	лТекст = Новый ТекстовыйДокумент;
	лТекст.ДобавитьСтроку( "Content-Type=doc/ua_payment" );
	лТекст.ДобавитьСтроку( "" );
	Для каждого лСтрока Из лмасПараметры Цикл
		Для каждого лЭлемент Из лСтрока Цикл
			лТекст.ДобавитьСтроку( лЭлемент.Ключ + "=" + лЭлемент.Значение );
		КонецЦикла;
	КонецЦикла;
	лТекст.Записать( СокрЛП(ПлатежнаяВедомостьДляБанков.ПапкаДляДБФ) + "\platezh.txt", КодировкаТекста.ANSI );
	
КонецПроцедуры

