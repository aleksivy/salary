﻿
// Процедура - обработчик события "Нажатие" элемента формы "ОсновныеДействияФормы.Выполнить".
//
Процедура ОсновныеДействияФормыВыполнить(Кнопка)
	
	Если НЕ ЗначениеЗаполнено(СегментнаяГруппа) Тогда
		Возврат;
	КонецЕсли;
	
	СписокКонтрагентов = СегментнаяГруппа.ПолучитьОбъект().ПолучитьСписок();
	Закрыть(СписокКонтрагентов);
	
КонецПроцедуры
