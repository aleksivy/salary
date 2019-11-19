﻿////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ ФОРМЫ

// Процедура - обработчик события "ПередОткрытием" формы.
//
Процедура ПередОткрытием(Отказ, СтандартнаяОбработка)
	
	// настройка порядка
	ЭлементыФормы.РегистрСведенийСписок.НастройкаПорядка.Физлицо.Доступность = Истина;
	
КонецПроцедуры

// Процедура - обработчик события "ПриОткрытии" формы
//
Процедура ПриОткрытии()
	
	СтруктураКолонок = Новый Структура();

	// Установить колонки, видимостью которых пользователь управлять не может.
	СтруктураКолонок.Вставить("ФизЛицо");

	// Установить ограничение - изменять видимость колонок для табличной части 
	ОбработкаТабличныхЧастей.УстановитьИзменятьВидимостьКолонокТабЧасти(ЭлементыФормы.РегистрСведенийСписок.Колонки, СтруктураКолонок);
	
КонецПроцедуры
