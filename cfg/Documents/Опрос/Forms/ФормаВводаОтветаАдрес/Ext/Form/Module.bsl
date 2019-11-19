﻿////////////////////////////////////////////////////////////////////////////////
// ПРОЦЕДУРЫ - ОБРАБОТЧИКИ СОБЫТИЙ ФОРМЫ

Процедура ПриЗакрытии()
	
	СформироватьТиповойОтвет();
	
КонецПроцедуры

Процедура ПриОткрытии()
	
	МассивПолей = ОбщегоНазначения.РазложитьСтрокуВМассивПодстрок(ТиповойОтвет, "¤");
	Если МассивПолей.Количество() > 1 тогда
		Регион  = МассивПолей[1];
	КонецЕсли;
	Если МассивПолей.Количество() > 2 тогда
		Район   = МассивПолей[2];
	КонецЕсли;
	Если МассивПолей.Количество() > 3 тогда
		Город   = МассивПолей[3];
	КонецЕсли;
	Если МассивПолей.Количество() > 4 тогда
		НаселенныйПункт = МассивПолей[4];
	КонецЕсли;
	Если МассивПолей.Количество() > 5 тогда
		Улица   = МассивПолей[5];
	КонецЕсли;
	Если МассивПолей.Количество() > 6 тогда
		Дом     = МассивПолей[6];
	КонецЕсли;
	Если МассивПолей.Количество() > 7 тогда
		Корпус  = МассивПолей[7];
	КонецЕсли;
	Если МассивПолей.Количество() > 8 тогда
		Квартира= МассивПолей[8];
	КонецЕсли;
	Если МассивПолей.Количество() > 0 тогда
		Индекс  = МассивПолей[0];
	КонецЕсли;
	Если МассивПолей.Количество() > 9 тогда
		Комментарий  = МассивПолей[9];
	КонецЕсли;
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// ПРОЦЕДУРЫ - ДЕЙСТВИЯ КОМАНДНЫХ ПАНЕЛЕЙ ФОРМЫ

Процедура СформироватьТиповойОтвет()
	
	ТиповойОтвет = "";
	ТиповойОтвет = ТиповойОтвет + "¤" + СокрЛП(Индекс);
	ТиповойОтвет = ТиповойОтвет + "¤" + СокрЛП(Регион);
	ТиповойОтвет = ТиповойОтвет + "¤" + СокрЛП(Район);
	ТиповойОтвет = ТиповойОтвет + "¤" + СокрЛП(Город);
	ТиповойОтвет = ТиповойОтвет + "¤" + СокрЛП(НаселенныйПункт);
	ТиповойОтвет = ТиповойОтвет + "¤" + СокрЛП(Улица);
	ТиповойОтвет = ТиповойОтвет + "¤" + СокрЛП(Дом);
	ТиповойОтвет = ТиповойОтвет + "¤" + СокрЛП(Корпус);
	ТиповойОтвет = ТиповойОтвет + "¤" + СокрЛП(Квартира);
	ТиповойОтвет = ТиповойОтвет + "¤" + СокрЛП(Комментарий);
	ТиповойОтвет = Сред(ТиповойОтвет, 2);
	
КонецПроцедуры

// Процедура вызывается при нажатии кнопки ОК.
// 
// Параметры
//  Кнопка - кнопка, по нажатию которой запускается данная процедура.
Процедура ОсновныеДействияФормыОК(Кнопка)
	
	СформироватьТиповойОтвет();	
	ЭтаФорма.Закрыть();
	
КонецПроцедуры

