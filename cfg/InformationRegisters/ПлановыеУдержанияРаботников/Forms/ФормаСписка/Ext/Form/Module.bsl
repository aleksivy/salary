﻿
Перем мДлинаСуток;
Перем мСведенияОВидахРасчета;

Процедура РегистрСведенийСписокПриВыводеСтроки(Элемент, ОформлениеСтроки, ДанныеСтроки)
	
	ВидРасчета = ДанныеСтроки.ВидРасчета;

	СведенияОВидеРасчета = РаботаСДиалогами.ПолучитьСведенияОВидеРасчетаСхемыМотивации(мСведенияОВидахРасчета, ВидРасчета);
	ТолькоПросмотрЯчеек = Ложь;
	
	ЕстьПоказатели = Ложь;
	Для СчПоказателей = 1 По 6 Цикл
		
		Если СчПоказателей <= СведенияОВидеРасчета["КоличествоПоказателей"] Тогда
			
			ВидимостьПоказателяИВалюты = Истина;
			Если СведенияОВидеРасчета["Показатель" + СчПоказателей + "НаименованиеВидимость"] Тогда
				ОформлениеСтроки.Ячейки["НаименованиеПоказатель" + СчПоказателей].Видимость = Истина;
				ЕстьПоказатели = Истина;
				ОформлениеСтроки.Ячейки["НаименованиеПоказатель" + СчПоказателей].УстановитьТекст(СведенияОВидеРасчета["Показатель" + СчПоказателей + "Наименование"]);
			Иначе
				ОформлениеСтроки.Ячейки["НаименованиеПоказатель" + СчПоказателей].Видимость = Ложь;
			КонецЕсли;
			Если ВидимостьПоказателяИВалюты Тогда
				ОформлениеСтроки.Ячейки["Показатель" + СчПоказателей].Видимость = СведенияОВидеРасчета["Показатель" + СчПоказателей + "Видимость"];		
				ОформлениеСтроки.Ячейки["Валюта" + СчПоказателей].Видимость = СведенияОВидеРасчета["Валюта" + СчПоказателей + "Видимость"];
			Иначе
				ОформлениеСтроки.Ячейки["Показатель" + СчПоказателей].Видимость = Ложь;		
				ОформлениеСтроки.Ячейки["Валюта" + СчПоказателей].Видимость = Ложь;
			КонецЕсли;
		Иначе
			ОформлениеСтроки.Ячейки["НаименованиеПоказатель" + СчПоказателей].Видимость = Ложь;
			ОформлениеСтроки.Ячейки["Показатель" + СчПоказателей].Видимость = Ложь;		
			ОформлениеСтроки.Ячейки["Валюта" + СчПоказателей].Видимость = Ложь;			
		КонецЕсли;	
	КонецЦикла;
	Если не ЕстьПоказатели Тогда		
		ОформлениеСтроки.Ячейки.НаименованиеПоказатель1.Видимость = Истина;
		ОформлениеСтроки.Ячейки["Показатель1"].Видимость = Истина;		
		ОформлениеСтроки.Ячейки["Валюта1"].Видимость = Истина;		
	КонецЕсли;	
	ОформлениеСтроки.Ячейки.Показатели.Видимость = Ложь;
	
	Если Элемент.Колонки.ПериодЗавершения.Видимость Тогда
		ОформлениеСтроки.Ячейки.ПериодЗавершения.ОтображатьТекст = Истина;
		ОформлениеСтроки.Ячейки.ПериодЗавершения.УстановитьТекст(Формат(ДанныеСтроки.ПериодЗавершения - мДлинаСуток, "ДФ=dd.MM.yyyy"));
	КонецЕсли;

КонецПроцедуры


мДлинаСуток = 86400;
мСведенияОВидахРасчета = Новый Соответствие;

