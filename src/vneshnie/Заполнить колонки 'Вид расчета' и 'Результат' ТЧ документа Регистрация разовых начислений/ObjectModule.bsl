﻿Процедура Инициализировать(Объект, ИмяТабличнойЧасти, ТабличноеПоле) Экспорт
	Если Объект.ОсновныеНачисления.Количество() = 0 Тогда Возврат; КонецЕсли;
	лВидРасчетаНадо = Объект.ОсновныеНачисления[0].ВидРасчета;
	лРезультатНадо = Объект.ОсновныеНачисления[0].Результат;
	Если Не ЗначениеЗаполнено(лВидРасчетаНадо) Тогда 
		Сообщить("Не заполнено значение в колонке 'Вид расчета' в первой строке!");
		Возврат; 
	КонецЕсли;
	Для каждого лСтрока Из Объект.ОсновныеНачисления Цикл
		лСтрока.ВидРасчета = лВидРасчетаНадо;
		лСтрока.Результат = лРезультатНадо;
	КонецЦикла;
КонецПроцедуры 

