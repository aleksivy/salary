﻿////////////////////////////////////////////////////////////////////////////////
// ПРОЦЕДУРЫ - ОБРАБОТЧИКИ СОБЫТИЙ ФОРМЫ


Процедура ОбновлениеОтображения()
	
    Если ПараметрОтборПоВладельцу <> Неопределено Тогда
		Заголовок = НСтр("ru='Варианты ответов на вопрос: ';uk='Варіанти відповідей на питання: '") + ПараметрОтборПоВладельцу.Наименование
	Иначе
		Заголовок = НСтр("ru='Варианты ответов опросов';uk='Варіанти відповідей опитувань'") 
	КонецЕсли;	
	
КонецПроцедуры

Процедура ПриОткрытии()
	
Возврат;
КонецПроцедуры


