﻿
Процедура КнопкаВыполнитьНажатие(Кнопка)
	Если Не РольДоступна("ПолныеПрава") и Не РольДоступна("гауПолныеПраваБезКадров") Тогда Сообщить("Недостаточно прав доступа!"); Возврат; КонецЕсли;
	Если Не ЗначениеЗаполнено(Сотрудник) Тогда Сообщить("Не выбран сотрудник!"); Возврат; КонецЕсли;
	
	Если Не ЗначениеЗаполнено(СсылкаНаОбъект) Тогда 
		лЗапрос = Новый Запрос;
		лЗапрос.Текст =
		"ВЫБРАТЬ
		|	ДокТЧ.Ссылка КАК Ссылка,
		|	ДокТЧ.ДатаДействия
		|ПОМЕСТИТЬ врем
		|ИЗ
		|	Документ.ВводСведенийОПлановыхНачисленияхРаботниковОрганизаций.ОсновныеНачисления КАК ДокТЧ
		|ГДЕ
		|	ДокТЧ.Ссылка.Проведен
		|	И ДокТЧ.ВидРасчета = ЗНАЧЕНИЕ(ПланВидовРасчета.ОсновныеНачисленияОрганизаций.ОкладПоДням)
		|	И (ДокТЧ.Действие = ЗНАЧЕНИЕ(Перечисление.ВидыДействияСНачислением.Начать)
		|			ИЛИ ДокТЧ.Действие = ЗНАЧЕНИЕ(Перечисление.ВидыДействияСНачислением.Изменить))
		|	И ДокТЧ.Сотрудник = &Сотрудник
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	МАКСИМУМ(врем.Ссылка) КАК Ссылка
		|ИЗ
		|	врем КАК врем
		|ГДЕ
		|	врем.ДатаДействия В
		|			(ВЫБРАТЬ
		|				МАКСИМУМ(врем.ДатаДействия) КАК ДатаДействия
		|			ИЗ
		|				врем КАК врем)
		|";
		лЗапрос.УстановитьПараметр("Сотрудник", Сотрудник);
		лВыборка = лЗапрос.Выполнить().Выбрать();
		Если Не лВыборка.Следующий() Тогда
			Сообщить("Не найден документ назначения оклада для сотрудника - " + Сотрудник);
			Возврат;
		Иначе
			Если лВыборка.Ссылка = Null Тогда
				Сообщить("Не найден документ назначения оклада для сотрудника - " + Сотрудник);
				Возврат;
			КонецЕсли;
		КонецЕсли;
		СсылкаНаОбъект = лВыборка.Ссылка;
	КонецЕсли;
	Объект = СсылкаНаОбъект;
	ТабДокумент = Печать( Сотрудник );
	ЭтоДокумент = Истина;
	ТабДокумент.АвтоМасштаб = Истина;
	УниверсальныеМеханизмы.НапечататьДокумент(ТабДокумент, 1, Ложь, ОбщегоНазначения.СформироватьЗаголовокДокумента(Объект.Ссылка), Объект.Ссылка);
КонецПроцедуры
