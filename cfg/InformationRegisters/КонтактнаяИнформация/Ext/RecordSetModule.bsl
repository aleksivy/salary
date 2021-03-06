
Процедура ПередЗаписью(Отказ, Замещение)
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;

	Для каждого Запись Из ЭтотОбъект Цикл
		Если НЕ ЗначениеЗаполнено(Запись.Объект) Тогда
			Отказ = Истина;
			СтрокаОтказа = НСтр("ru='Не заполнен объект.';uk=""Не заповнений об'єкт.""");
			Продолжить;
		КонецЕсли; 
		Если Запись.Объект.ЭтоГруппа Тогда
			Отказ = Истина;
			СтрокаОтказа = НСтр("ru='Нельзя использовать в качестве объекта контактной информации - группу.';uk=""Не можна використовувати в якості об'єкта контактної інформації - групу.""");
			Прервать;
		КонецЕсли;
		Если ТипЗнч(Запись.Объект) = Тип("СправочникСсылка.КонтактныеЛица") Тогда
			Запись.УдалитьКонтактноеЛицоДляОграниченияПравДоступа = Запись.Объект;
			Запись.УдалитьКонтрагентДляОграниченияПравДоступа     = Справочники.Контрагенты.ПустаяСсылка();
		ИначеЕсли ТипЗнч(Запись.Объект) = Тип("СправочникСсылка.Контрагенты") Тогда
			Запись.УдалитьКонтрагентДляОграниченияПравДоступа     = Запись.Объект;
			Запись.УдалитьКонтактноеЛицоДляОграниченияПравДоступа = Справочники.КонтактныеЛица.ПустаяСсылка();
		Иначе
			Запись.УдалитьКонтрагентДляОграниченияПравДоступа     = Справочники.Контрагенты.ПустаяСсылка();
			Запись.УдалитьКонтактноеЛицоДляОграниченияПравДоступа = Справочники.КонтактныеЛица.ПустаяСсылка();
		КонецЕсли; 
	КонецЦикла;
	
	Если Отказ Тогда
		Сообщить(СтрокаОтказа);
	КонецЕсли; 
	
КонецПроцедуры
