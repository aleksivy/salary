﻿
Функция ПоказатьТаблицуЗначений(ТЗ, Заголовок = "", Модально = Ложь) Экспорт
	
	ФормаТЗ = ПолучитьФорму("Форма");
	Если ФормаТЗ.КлючУникальности = Неопределено Тогда
		ФормаТЗ.КлючУникальности = Новый УникальныйИдентификатор();
	КонецЕсли;
	
	ФормаТЗ.ТаблицаЗначений = ТЗ;
	ФормаТЗ.ЭлементыФормы.ТаблицаЗначений.СоздатьКолонки();
	Если НЕ Модально Тогда
		ФормаТЗ.Открыть();
	Иначе
		ФормаТЗ.ОткрытьМодально();
	КонецЕсли;	
	Если Заголовок <> "" Тогда
		ФормаТЗ.Заголовок = Заголовок;
	КонецЕсли; 
	ФормаТЗ.Активизировать();
	
КонецФункции


Функция ПоказатьДеревоЗначений(ДЗ, Заголовок = "") Экспорт
	
	ФормаДЗ = ПолучитьФорму("ФормаДЗ");
	Если ФормаДЗ.КлючУникальности = Неопределено Тогда
		ФормаДЗ.КлючУникальности = Новый УникальныйИдентификатор();
	КонецЕсли;
	
	ФормаДЗ.ДеревоЗначений = ДЗ;
	ФормаДЗ.ЭлементыФормы.ДеревоЗначений.СоздатьКолонки();
	ФормаДЗ.Открыть();
	Если Заголовок <> "" Тогда
		ФормаДЗ.Заголовок = Заголовок;
	КонецЕсли; 
	ФормаДЗ.Активизировать();
	
КонецФункции
