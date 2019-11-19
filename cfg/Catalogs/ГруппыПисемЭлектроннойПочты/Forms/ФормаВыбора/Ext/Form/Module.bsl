﻿
Перем мГруппаВходящие;
Перем мГруппаИсходящие;
Перем мГруппаУдаленные;
Перем мГруппаЧерновики;
Перем мГруппаНежелательные;

Процедура ПриОткрытии()
	
	Для каждого ЭлементНастройкиПорядка Из ЭлементыФормы.СправочникСписок.НастройкаПорядка Цикл
		ЭлементНастройкиПорядка.Доступность = Ложь;
	КонецЦикла;
	
	СправочникСписок.Порядок.Установить("Порядок ВОЗР");
	
	Если СправочникСписок.Отбор.Владелец.Использование И ЗначениеЗаполнено(СправочникСписок.Отбор.Владелец.Значение)
	   И ТипЗнч(СправочникСписок.Отбор.Владелец.Значение) = Тип("СправочникСсылка.УчетныеЗаписиЭлектроннойПочты") Тогда
		Если ЗначениеЗаполнено(СправочникСписок.Отбор.Владелец.Значение.ГруппаВходящие) Тогда
			мГруппаВходящие = СправочникСписок.Отбор.Владелец.Значение.ГруппаВходящие;
		КонецЕсли; 
		Если ЗначениеЗаполнено(СправочникСписок.Отбор.Владелец.Значение.ГруппаИсходящие) Тогда
			мГруппаИсходящие = СправочникСписок.Отбор.Владелец.Значение.ГруппаИсходящие;
		КонецЕсли; 
		Если ЗначениеЗаполнено(СправочникСписок.Отбор.Владелец.Значение.ГруппаУдаленные) Тогда
			мГруппаУдаленные = СправочникСписок.Отбор.Владелец.Значение.ГруппаУдаленные;
		КонецЕсли; 
		Если ЗначениеЗаполнено(СправочникСписок.Отбор.Владелец.Значение.ГруппаЧерновики) Тогда
			мГруппаЧерновики = СправочникСписок.Отбор.Владелец.Значение.ГруппаЧерновики;
		КонецЕсли; 
		Если ЗначениеЗаполнено(СправочникСписок.Отбор.Владелец.Значение.ГруппаНежелательные) Тогда
			мГруппаНежелательные = СправочникСписок.Отбор.Владелец.Значение.ГруппаНежелательные;
		КонецЕсли; 
	КонецЕсли;
	
КонецПроцедуры

Процедура СправочникДеревоПриВыводеСтроки(Элемент, ОформлениеСтроки, ДанныеСтроки)
	
	ОформлениеСтроки.Ячейки.Наименование.ОтображатьКартинку = Истина;
	Если ДанныеСтроки = Неопределено Тогда
		ОформлениеСтроки.Ячейки.Наименование.ИндексКартинки = 1;
	Иначе
		Если НЕ ЗначениеЗаполнено(ДанныеСтроки.Владелец) Тогда
			ОформлениеСтроки.Ячейки.Наименование.ИндексКартинки = 1;
		Иначе
			Если мГруппаВходящие = ДанныеСтроки.Ссылка Тогда
				ОформлениеСтроки.Ячейки.Наименование.ИндексКартинки = 3;
			ИначеЕсли мГруппаИсходящие = ДанныеСтроки.Ссылка Тогда
				ОформлениеСтроки.Ячейки.Наименование.ИндексКартинки = 2;
			ИначеЕсли мГруппаУдаленные = ДанныеСтроки.Ссылка Тогда
				ОформлениеСтроки.Ячейки.Наименование.ИндексКартинки = 0;
			ИначеЕсли мГруппаЧерновики = ДанныеСтроки.Ссылка Тогда
				ОформлениеСтроки.Ячейки.Наименование.ИндексКартинки = 5;
			ИначеЕсли мГруппаНежелательные = ДанныеСтроки.Ссылка Тогда
				ОформлениеСтроки.Ячейки.Наименование.ИндексКартинки = 7;
			Иначе
				Если ДанныеСтроки.ПометкаУдаления Тогда
					ОформлениеСтроки.Ячейки.Наименование.ИндексКартинки = 4;
				Иначе
					ОформлениеСтроки.Ячейки.Наименование.ИндексКартинки = 1;
				КонецЕсли; 
			КонецЕсли; 
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

СправочникСписок.Колонки.Добавить("Владелец", Ложь);
СправочникСписок.Колонки.Добавить("Порядок", Ложь);
