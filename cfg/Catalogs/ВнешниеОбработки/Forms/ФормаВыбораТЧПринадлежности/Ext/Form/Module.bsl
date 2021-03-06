Процедура ЗаполнитьСписокОбъектов()
    ЕСли УжеВыбранные = Неопределено  Тогда
		УжеВыбранные = Новый Соответствие;
	КонецЕсли;
	
	Для Каждого ТабличнаяЧасть Из СсылкаОбъекта.Метаданные().ТабличныеЧасти Цикл
		Если УжеВыбранные[ТабличнаяЧасть.Имя] = Неопределено Тогда
			СписокТабличныхЧастей.Добавить(ТабличнаяЧасть.Имя, ТабличнаяЧасть.Синоним);
		КонецЕсли;
	КонецЦикла;
КонецПроцедуры

Процедура ПередОткрытием(Отказ, СтандартнаяОбработка)
	ЗаполнитьСписокОбъектов();
КонецПроцедуры

Процедура ОсновныеДействияФормыКнопкаОК(Кнопка)	
	ОповеститьОВыборе(ЭлементыФормы.СписокТабличныхЧастей.ТекущаяСтрока);
КонецПроцедуры

Процедура СписокДокументовВыбор(Элемент, ВыбраннаяСтрока, Колонка, СтандартнаяОбработка)
	ОповеститьОВыборе(ЭлементыФормы.СписокТабличныхЧастей.ТекущаяСтрока);
КонецПроцедуры

Процедура ПриПовторномОткрытии(СтандартнаяОбработка)
	ЗаполнитьСписокОбъектов(); 
КонецПроцедуры

