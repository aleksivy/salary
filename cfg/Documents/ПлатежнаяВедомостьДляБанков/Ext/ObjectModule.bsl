
Процедура ОбработкаЗаполнения(ДанныеЗаполнения, СтандартнаяОбработка)
	Если ТипЗнч(ДанныеЗаполнения) = Тип("ДокументСсылка.ЗарплатаКВыплатеОрганизаций") Тогда
		ВидВыплаты = ДанныеЗаполнения.ВидВыплаты;
		Комментарий = ДанныеЗаполнения.Комментарий;
		Организация = ДанныеЗаполнения.Организация;
		ПодразделениеОрганизации = ДанныеЗаполнения.ПодразделениеОрганизации;
		ДокументОснование = ДанныеЗаполнения.Ссылка;
		АвтоЗаполнение = Истина;
		Для Каждого ТекСтрокаРаботникиОрганизации Из ДанныеЗаполнения.РаботникиОрганизации Цикл
			Если Не (ТекСтрокаРаботникиОрганизации.СпособВыплаты = Перечисления.СпособыВыплатыЗарплаты.ЧерезБанк) Тогда Продолжить; КонецЕсли;
			Если (ТекСтрокаРаботникиОрганизации.Банк = Справочники.Контрагенты.ПустаяСсылка()) Тогда Продолжить; КонецЕсли;
			НоваяСтрока = ВыплатаЗаработнойПлаты.Добавить();
			НоваяСтрока.Сотрудник = ТекСтрокаРаботникиОрганизации.Сотрудник;
			НоваяСтрока.Банк = ТекСтрокаРаботникиОрганизации.Банк;
			НоваяСтрока.НомерКарточки = ТекСтрокаРаботникиОрганизации.НомерКарточки;
			НоваяСтрока.Сумма = ТекСтрокаРаботникиОрганизации.Сумма;
		КонецЦикла;
		СуммаДокумента = ВыплатаЗаработнойПлаты.Итог("Сумма");
	ИначеЕсли ТипЗнч(ДанныеЗаполнения) = Тип("ДокументСсылка.ПлатежнаяВедомостьДляБанков") Тогда
		// Заполнение шапки
		Банк = ДанныеЗаполнения.Банк;
		ВидВыплаты = ДанныеЗаполнения.ВидВыплаты;
		Комментарий = ДанныеЗаполнения.Комментарий;
		Организация = ДанныеЗаполнения.Организация;
		ПодразделениеОрганизации = ДанныеЗаполнения.ПодразделениеОрганизации;
		ПапкаДляДБФ = ДанныеЗаполнения.ПапкаДляДБФ;
	КонецЕсли;
	Ответственный = глЗначениеПеременной("глТекущийПользователь");
КонецПроцедуры

Процедура ПередЗаписью(Отказ, РежимЗаписи, РежимПроведения)
	
	Если ОбменДанными.Загрузка Тогда Возврат; КонецЕсли;

	КраткийСоставДокумента = ПроцедурыУправленияПерсоналом.ЗаполнитьКраткийСоставДокумента( ВыплатаЗаработнойПлаты );
	лСумма = ВыплатаЗаработнойПлаты.Итог("Сумма");
	Если Не СуммаДокумента = лСумма Тогда СуммаДокумента = лСумма; КонецЕсли;
	// Проверим банк
	лтзТЧ = ВыплатаЗаработнойПлаты.Выгрузить(, "Банк");
	лтзТЧ.Свернуть("Банк", "");
	Если (лтзТЧ.Количество()=1) Тогда
		Если Не Банк = лтзТЧ[0].Банк Тогда Банк = лтзТЧ[0].Банк; КонецЕсли;
	КонецЕсли;
КонецПроцедуры
