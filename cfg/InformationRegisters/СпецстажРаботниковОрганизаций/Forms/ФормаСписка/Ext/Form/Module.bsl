
Процедура РегистрСведенийСписокПриВыводеСтроки(Элемент, ОформлениеСтроки, ДанныеСтроки)
	
	Если ЗначениеЗаполнено(ДанныеСтроки.Приказ) Тогда
		ОформлениеСтроки.Ячейки.Приказ.Текст = "№ "+ДанныеСтроки.Приказ.Номер+НСтр("ru=' от ';uk=' від '")+Строка(ДанныеСтроки.Приказ.Дата); 
	КонецЕсли;
	
КонецПроцедуры
