
Процедура ОсновныеДействияФормыОК(Кнопка)
	
	Закрыть(Истина);
	
КонецПроцедуры

Процедура УстановитьРедактируемыйТекст(ИсходныйТекст) Экспорт
	
	Если ТипЗнч("ИсходныйТекст") = Тип("Строка") Тогда
		ЭлементыФормы.ПолеТекстовогоДокументаДляРедактирования.УстановитьТекст(ИсходныйТекст);
		
	Иначе
		ЭлементыФормы.ПолеТекстовогоДокументаДляРедактирования.УстановитьТекст("");
		
	КонецЕсли;
		
КонецПроцедуры

Функция ПолучитьРедактируемыйТекст() Экспорт
	
	Возврат ЭлементыФормы.ПолеТекстовогоДокументаДляРедактирования.ПолучитьТекст();
	
КонецФункции



