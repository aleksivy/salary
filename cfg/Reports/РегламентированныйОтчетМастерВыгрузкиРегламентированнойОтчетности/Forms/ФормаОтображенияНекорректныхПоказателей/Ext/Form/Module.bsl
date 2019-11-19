﻿Процедура ДеревоСтрокВыбор(Элемент, ВыбраннаяСтрока, Колонка, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	УстановитьКурсорВОчтете();
	
КонецПроцедуры

Процедура УстановитьКурсорВОчтете()

	ТекСтрока = ЭлементыФормы.ТаблицаСтрок.ТекущаяСтрока;
	Если    ТекСтрока = Неопределено
		ИЛИ НЕ ЗначениеЗаполнено(ТекСтрока.ИмяТабличногоПоля) Тогда
		Возврат;	
	КонецЕсли;
	
	ОповеститьОВыборе(Новый Структура("ИмяПоказателя, ИмяТабличногоПоля", ТекСтрока.ИмяПоказателя, ТекСтрока.ИмяТабличногоПоля));

КонецПроцедуры

Процедура ДеревоСтрокПриАктивизацииСтроки(Элемент)
	
	СтандартнаяОбработка = Ложь;
	УстановитьКурсорВОчтете();
	
КонецПроцедуры

ЗакрыватьПриВыборе = Ложь;