
Процедура РегистрСведенийСписокПланВидовРасчетаПриИзменении(Элемент)
	
	ТекущиеДанные = ЭлементыФормы.РегистрСведенийСписок.ТекущиеДанные;
	Если ТекущиеДанные = Неопределено Тогда
		Возврат;
	КонецЕсли;
	Если ТекущиеДанные.ПланВидовРасчета = Перечисления.ПланыВидовРасчета.ОсновныеНачисленияОрганизаций Тогда
		Если ТипЗнч(ТекущиеДанные.ВидРасчета) <> Тип("ПланВидовРасчетаСсылка.ОсновныеНачисленияОрганизаций") Тогда
			ТекущиеДанные.ВидРасчета = ПланыВидовРасчета.ОсновныеНачисленияОрганизаций.ПустаяСсылка();
		КонецЕсли;	
	ИначеЕсли ТекущиеДанные.ПланВидовРасчета = Перечисления.ПланыВидовРасчета.УдержанияОрганизаций Тогда
		Если ТипЗнч(ТекущиеДанные.ВидРасчета) <> Тип("ПланВидовРасчетаСсылка.УдержанияОрганизаций") Тогда
			ТекущиеДанные.ВидРасчета = ПланыВидовРасчета.УдержанияОрганизаций.ПустаяСсылка();
		КонецЕсли;
	ИначеЕсли ТекущиеДанные.ПланВидовРасчета = Перечисления.ПланыВидовРасчета.ВзносыВФонды Тогда
		Если ТипЗнч(ТекущиеДанные.ВидРасчета) <> Тип("ПланВидовРасчетаСсылка.ВзносыВФонды") Тогда
			ТекущиеДанные.ВидРасчета = ПланыВидовРасчета.ВзносыВФонды.ПустаяСсылка();
		КонецЕсли;		
	ИначеЕсли ТекущиеДанные.ПланВидовРасчета = Перечисления.ПланыВидовРасчета.СреднийЗаработок Тогда
		Если ТипЗнч(ТекущиеДанные.ВидРасчета) <> Тип("ПланВидовРасчетаСсылка.СреднийЗаработок") Тогда
			ТекущиеДанные.ВидРасчета = ПланыВидовРасчета.СреднийЗаработок.ПустаяСсылка();
		КонецЕсли;		
	КонецЕсли;	
	
КонецПроцедуры


Процедура РегистрСведенийСписокПриНачалеРедактирования(Элемент, НоваяСтрока, Копирование)
	
	ТекущиеДанные = ЭлементыФормы.РегистрСведенийСписок.ТекущиеДанные;
	Если ТекущиеДанные = Неопределено Тогда
		Возврат;
	КонецЕсли;
	Если НЕ ЗначениеЗаполнено(ТекущиеДанные.ПланВидовРасчета) Тогда
		ТекущиеДанные.ПланВидовРасчета = Перечисления.ПланыВидовРасчета.ОсновныеНачисленияОрганизаций;
	КонецЕсли;	
	Если ТекущиеДанные.ПланВидовРасчета = Перечисления.ПланыВидовРасчета.ОсновныеНачисленияОрганизаций Тогда
		Если ТипЗнч(ТекущиеДанные.ВидРасчета) <> Тип("ПланВидовРасчетаСсылка.ОсновныеНачисленияОрганизаций") Тогда
			ТекущиеДанные.ВидРасчета = ПланыВидовРасчета.ОсновныеНачисленияОрганизаций.ПустаяСсылка();
		КонецЕсли;	
	ИначеЕсли ТекущиеДанные.ПланВидовРасчета = Перечисления.ПланыВидовРасчета.УдержанияОрганизаций Тогда
		Если ТипЗнч(ТекущиеДанные.ВидРасчета) <> Тип("ПланВидовРасчетаСсылка.УдержанияОрганизаций") Тогда
			ТекущиеДанные.ВидРасчета = ПланыВидовРасчета.УдержанияОрганизаций.ПустаяСсылка();
		КонецЕсли;
	ИначеЕсли ТекущиеДанные.ПланВидовРасчета = Перечисления.ПланыВидовРасчета.ВзносыВФонды Тогда
		Если ТипЗнч(ТекущиеДанные.ВидРасчета) <> Тип("ПланВидовРасчетаСсылка.ВзносыВФонды") Тогда
			ТекущиеДанные.ВидРасчета = ПланыВидовРасчета.ВзносыВФонды.ПустаяСсылка();
		КонецЕсли;		
	ИначеЕсли ТекущиеДанные.ПланВидовРасчета = Перечисления.ПланыВидовРасчета.СреднийЗаработок Тогда
		Если ТипЗнч(ТекущиеДанные.ВидРасчета) <> Тип("ПланВидовРасчетаСсылка.СреднийЗаработок") Тогда
			ТекущиеДанные.ВидРасчета = ПланыВидовРасчета.СреднийЗаработок.ПустаяСсылка();
		КонецЕсли;		
	КонецЕсли;
	
	
КонецПроцедуры
