// ЗаполнитьОсновныеНачисления
//
Процедура ЗаполнитьОсновныеНачисления() Экспорт
	ОсновныеНачисления.Очистить();
	Для каждого лСтрока Из ПредварительныеНачисления Цикл
		Если НачалоМесяца(лСтрока.ДатаНачала) = НачалоМесяца(лСтрока.ДатаОкончания) Тогда
			// Ничего делать не нужно. Просто скопировать строку
			лНоваяСтрока = ОсновныеНачисления.Добавить();
			ЗаполнитьЗначенияСвойств(лНоваяСтрока, лСтрока);
		Иначе
			лИнтервалВСекундах = (КонецДня(лСтрока.ДатаОкончания) - НачалоДня(лСтрока.ДатаНачала));
			лНачалоПериода = НачалоДня(лСтрока.ДатаНачала);
			лКонецПериода = КонецМесяца(лНачалоПериода);
			лСуммаВсего = лСтрока.Сумма;
			
			лНоваяСтрока = ОсновныеНачисления.Добавить();
			лНоваяСтрока.Сотрудник = лСтрока.Сотрудник;
			лНоваяСтрока.Валюта = лСтрока.Валюта;
			лНоваяСтрока.ДатаНачисления = лСтрока.ДатаНачисления;
			лНоваяСтрока.ДатаНачала = лНачалоПериода;
			лНоваяСтрока.ДатаОкончания = лКонецПериода;
			лСуммаТут = Окр(лСтрока.Сумма * (лКонецПериода - лНачалоПериода) / лИнтервалВСекундах, 2);
			лНоваяСтрока.Сумма = лСуммаТут;
			лСуммаВсего = лСуммаВсего - лСуммаТут;
			Пока лКонецПериода < КонецДня(лСтрока.ДатаОкончания) Цикл
				лНачалоПериода = НачалоДня(КонецМесяца(лНачалоПериода)+1);
				лКонецПериода = Мин(КонецМесяца(лНачалоПериода), КонецДня(лСтрока.ДатаОкончания));
				лНоваяСтрока = ОсновныеНачисления.Добавить();
				лНоваяСтрока.Сотрудник = лСтрока.Сотрудник;
				лНоваяСтрока.Валюта = лСтрока.Валюта;
				лНоваяСтрока.ДатаНачисления = лСтрока.ДатаНачисления;
				лНоваяСтрока.ДатаНачала = лНачалоПериода;
				лНоваяСтрока.ДатаОкончания = лКонецПериода;
				лСуммаТут = Окр(лСтрока.Сумма * (лКонецПериода - лНачалоПериода) / лИнтервалВСекундах, 2);
				лНоваяСтрока.Сумма = лСуммаТут;
				лСуммаВсего = лСуммаВсего - лСуммаТут;
			КонецЦикла;
			Если Не (лСуммаВсего = 0) Тогда
				// Исправим ошибку округления
				ОсновныеНачисления[ ОсновныеНачисления.Количество()-1 ].Сумма = ОсновныеНачисления[ ОсновныеНачисления.Количество()-1 ].Сумма + лСуммаВсего;
			КонецЕсли;
		КонецЕсли;
	КонецЦикла;
КонецПроцедуры // ЗаполнитьОсновныеНачисления

// ОбработкаПроведения
//
Процедура ОбработкаПроведения(Отказ, Режим)
КонецПроцедуры // ОбработкаПроведения()

// ПередЗаписью
//
Процедура ПередЗаписью(Отказ, РежимЗаписи, РежимПроведения)
	
	Если ОбменДанными.Загрузка Тогда Возврат; КонецЕсли;

	КраткийСоставДокумента = ПроцедурыУправленияПерсоналом.ЗаполнитьКраткийСоставДокумента(ОсновныеНачисления);
	
	// Проверим, что заполнено поле Валюта в ТЧ ПредварительныеНачисления
	лГривна = Константы.ВалютаРегламентированногоУчета.Получить();
	Для каждого лСтрока Из ПредварительныеНачисления Цикл
		Если Не ЗначениеЗаполнено(лСтрока.Валюта) Тогда лСтрока.Валюта = лГривна; КонецЕсли;
	КонецЦикла;
	Для каждого лСтрока Из ОсновныеНачисления Цикл
		Если Не ЗначениеЗаполнено(лСтрока.Валюта) Тогда лСтрока.Валюта = лГривна; КонецЕсли;
	КонецЦикла;
	
	Если Не ПредварительныеНачисления.Итог("Сумма") = ОсновныеНачисления.Итог("Сумма") Тогда
		// Нужно перезаполнить ТЧ ОсновныеНачисления по ТЧ ПредварительныеНачисления
		ЗаполнитьОсновныеНачисления();
	КонецЕсли;
КонецПроцедуры // ПередЗаписью()
