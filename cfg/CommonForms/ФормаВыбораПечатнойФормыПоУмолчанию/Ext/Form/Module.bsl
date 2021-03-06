
Процедура ВыбратьНажатие(Элемент)
	
	ТекущиеДанные = ЭлементыФормы.ТабличноеПолеВыбора.ТекущиеДанные;
	
	Если ТекущиеДанные = Неопределено Тогда
		
		Предупреждение(НСтр("ru='Не выбран макет';uk='Не обраний макет'"));
		
	Иначе
		
		Закрыть(ТекущиеДанные.Значение);
	КонецЕсли;
	
КонецПроцедуры


Процедура ОчиститьНажатие(Элемент)
	
	Закрыть("");
	
КонецПроцедуры

Процедура ТабличноеПолеВыбораПриВыводеСтроки(Элемент, ОформлениеСтроки, ДанныеСтроки)
	
	Если ДанныеСтроки.Пометка Тогда
		ОформлениеСтроки.Шрифт = Новый Шрифт(,,Истина);
		
	КонецЕсли;
	
КонецПроцедуры
