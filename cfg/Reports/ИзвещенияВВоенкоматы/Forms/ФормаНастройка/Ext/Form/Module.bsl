////////////////////////////////////////////////////////////////////////////////
// ПРОЦЕДУРЫ И ФУНКЦИИ ОБЩЕГО НАЗНАЧЕНИЯ

// Заполняет диалог по значениям реквизитов отчета
//
// Параметры:
//	Нет.
//
Процедура ЗаполнитьДиалогПоОбъекту()

	// Здесь должно быть расположено заполнение реквизитов формы
	// по реквизитам отчета, если они непосредственно не связаны
	// с реквизитами отчета (если таковые имеются)

КонецПроцедуры // ЗаполнитьДиалогПоОбъекту()

///////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ ФОРМЫ

// Процедура - обработчик события ПриОткрытии формы
//
Процедура ПриОткрытии()
	ЗаполнитьДиалогПоОбъекту();
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ ЭЛЕМЕНТОВ ДИАЛОГА

// Процедура - обработчик нажатия кнопки ОК.
//
Процедура ОсновныеДействияФормыОК(Кнопка)

	ЕстьОшибки = Ложь;
	Для Инд=0 По ПостроительОтчета.ИзмеренияКолонки.Количество()-1  Цикл
	
		Для Инд2=0 По ПостроительОтчета.ИзмеренияСтроки.Количество()-1  Цикл

			Если ПостроительОтчета.ИзмеренияКолонки[Инд].ПутьКДанным = ПостроительОтчета.ИзмеренияСтроки[Инд2].ПутьКДанным Тогда

				Предупреждение(НСтр("ru='Повторяющаяся группировка ';uk='Повторюване групування '") + ПостроительОтчета.ИзмеренияКолонки[Инд].Представление +"."+ Символы.ПС+
				НСтр("ru='Нельзя использовать одинаковые поля группировки в строках и в колонках!';uk='Не можна використовувати однакові поля групування в рядках і в колонках!'"), 30);
				ЕстьОшибки = Истина;
			
			КонецЕсли; 
		КонецЦикла;
	
	КонецЦикла;
	
	Для Каждого СтрокаОтбора Из ПостроительОтчета.Отбор Цикл
		
		Если НЕ ЗначениеЗаполнено(СтрокаОтбора.ПутьКДанным) Тогда
			Предупреждение(НСтр("ru='В отборе не должно быть пустых полей!';uk='У відборі не повинне бути порожніх полів!'"), 30);
			ЕстьОшибки = Истина;
			Прервать;
		КонецЕсли;
		
	КонецЦикла;
		

	Если ЕстьОшибки Тогда
		Возврат;
	КонецЕсли;
	
	Закрыть(Истина);
	
КонецПроцедуры // ОсновныеДействияФормыОК()

// Процедура - обработчик перед удалением строки отбора
//
Процедура ОтборПередУдалением(Элемент, Отказ)
	
	Если Не ПустаяСтрока(Элемент.ТекущаяСтрока.Имя) Тогда
		Отказ = Истина;
	КонецЕсли; 
	
КонецПроцедуры // ОтборПередУдалением()

