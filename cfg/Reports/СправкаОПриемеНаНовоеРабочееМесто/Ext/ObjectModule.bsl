﻿Перем СохраненнаяНастройка Экспорт;

#Если Клиент ИЛИ ВнешнееСоединение Тогда
	
// В процедуре можно доработать компоновщик перед выводом в отчет
// Изменения сохранены не будут
Процедура ДоработатьКомпоновщикПередВыводом() Экспорт
	
	ЗначениеПараметра = КомпоновщикНастроек.Настройки.ПараметрыДанных.НайтиЗначениеПараметра(Новый ПараметрКомпоновкиДанных("Период"));
	Если ЗначениеПараметра = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	Если ЗначениеПараметра.Значение = '00010101' Тогда
		ЗначениеПараметра.Значение = КонецДня(ТекущаяДата());
		ЗначениеПараметра.Использование = Истина;
	КонецЕсли;
	
КонецПроцедуры


Процедура СформироватьОтчет(ФормаОтчета) Экспорт
	
	СхемаКомпоновкиДанных = ПолучитьМакет("ОсновнаяСхемаКомпоновкиДанных");
	
	Настройки = КомпоновщикНастроек.Настройки;
	ПараметрыДанных = КомпоновщикНастроек.Настройки.ПараметрыДанных;

	ЗначениеПараметра = КомпоновщикНастроек.Настройки.ПараметрыДанных.НайтиЗначениеПараметра(Новый ПараметрКомпоновкиДанных("ВидСправки"));
	ЗначениеПараметра.Использование = Истина;
	Если ФормаОтчета.ЭлементыФормы.ВидСправки.Значение = НСтр("Для принятых по направлению и имеющих гарантии трудоустройства (порядок 347)") Тогда
		ЗначениеПараметра.Значение = 1
	ИначеЕсли ФормаОтчета.ЭлементыФормы.ВидСправки.Значение = НСтр("Для принятых на новое место работы (порядок 153)") Тогда
		ЗначениеПараметра.Значение = 2
	КонецЕсли;	
			
	КомпоновщикМакета  = Новый КомпоновщикМакетаКомпоновкиДанных;

	МакетКомпоновкиДанных = КомпоновщикМакета.Выполнить(СхемаКомпоновкиДанных, Настройки,,,Тип("ГенераторМакетаКомпоновкиДанныхДляКоллекцииЗначений"));
	
	ПроцессорКомпоновкиДанных = Новый ПроцессорКомпоновкиДанных;
	ПроцессорКомпоновкиДанных.Инициализировать(МакетКомпоновкиДанных,,,Истина);
	
	ДокументРезультат = ФормаОтчета.ЭлементыФормы.Результат;
	ДокументРезультат.Очистить();
	
	ПроцессорВывода = Новый ПроцессорВыводаРезультатаКомпоновкиДанныхВКоллекциюЗначений;
	
	Данные = Новый ДеревоЗначений;
	
	ПроцессорВывода = Новый ПроцессорВыводаРезультатаКомпоновкиДанныхВКоллекциюЗначений;
	
	ПроцессорВывода.УстановитьОбъект(Данные);
	
	Данные = ПроцессорВывода.Вывести(ПроцессорКомпоновкиДанных, Истина);
		
	ВывестиМакет(ДокументРезультат, Данные, ФормаОтчета)
		

КонецПроцедуры	

Процедура ВывестиМакет(ДокументРезультат, Данные, формаОтчета) Экспорт
	
	Макет = ПолучитьМакет("Макет"); 	
	
	ОбластьЗаголовок = Макет.ПолучитьОбласть("Заголовок");

	Если ВидСправки = НСтр("Для принятых на новое место работы (порядок 153)") Тогда
		ОбластьСправка = Макет.ПолучитьОбласть("Справка153")
	Иначе
		ОбластьСправка = Макет.ПолучитьОбласть("Справка457")
	КонецЕсли;
	
	ОбластьПодвал = Макет.ПолучитьОбласть("Подвал");
	ДокументРезультат.Вывести(ОбластьЗаголовок);
	Для Каждого ДанныеСправки Из Данные.Строки Цикл
		
		ОбластьСправка.Параметры.Заполнить(ДанныеСправки);
		ОбластьСправка.Параметры.Организация = ДанныеСправки.Организация.НаименованиеПолное;
		Если ДанныеСправки.Документ <> NULL Тогда
			ОбластьСправка.Параметры.СозданиеНовогоСубъектаХозяйствованияДокумент = ?(ДанныеСправки.СозданиеНовогоСубъектаХозяйствования = "Так", "№ " + Строка(ДанныеСправки.Документ.Номер) + " від " + Формат(ДанныеСправки.Документ.Дата, "ДФ='дд.ММ.гг'"),"");
			ОбластьСправка.Параметры.УвеличениеШтатнойЧисленностиРаботниковДокумент = ?(ДанныеСправки.УвеличениеШтатнойЧисленностиРаботников = "Так", "№ " + Строка(ДанныеСправки.Документ.Номер) + " від " + Формат(ДанныеСправки.Документ.Дата, "ДФ='дд.ММ.гг'"),"");
		КонецЕсли;
		РасчетныйСчет = СокрЛП(ФормаОтчета.ЭлементыФормы.РасчетныйСчет.Значение); 
		Если РасчетныйСчет <> "" Тогда
			ОбластьСправка.Параметры.ОсновнойБанковскийСчет = РасчетныйСчет
		КонецЕсли;	
		ОбластьПодвал.Параметры.Заполнить(ДанныеСправки);
	
		ДокументРезультат.Вывести(ОбластьСправка);
		ДокументРезультат.Вывести(ОбластьПодвал);
		
		ДокументРезультат.ВывестиГоризонтальныйРазделительСтраниц();
	КонецЦикла;
КонецПроцедуры	


#КонецЕсли

#Если Клиент Тогда
	
// Для настройки отчета (расшифровка и др.)
Процедура Настроить(Отбор, КомпоновщикНастроекОсновногоОтчета = Неопределено) Экспорт
	
	ТиповыеОтчеты.НастроитьТиповойОтчет(ЭтотОбъект, Отбор, КомпоновщикНастроекОсновногоОтчета);
	
КонецПроцедуры

Процедура СохранитьНастройку() Экспорт
	
	СтруктураНастроек = ТиповыеОтчеты.ПолучитьСтруктуруПараметровТиповогоОтчета(ЭтотОбъект);
	СохранениеНастроек.СохранитьНастройкуОбъекта(СохраненнаяНастройка, СтруктураНастроек);
	
КонецПроцедуры

// Процедура заполняет параметры отчета по элементу справочника из переменной СохраненнаяНастройка.
Процедура ПрименитьНастройку() Экспорт
	
	Если СохраненнаяНастройка.Пустая() Тогда
		Возврат;
	КонецЕсли;
	 
	СтруктураПараметров = СохраненнаяНастройка.ХранилищеНастроек.Получить();
	ТиповыеОтчеты.ПрименитьСтруктуруПараметровОтчета(ЭтотОбъект, СтруктураПараметров);
	
КонецПроцедуры

Процедура ИнициализацияОтчета() Экспорт
	
	ТиповыеОтчеты.ИнициализацияТиповогоОтчета(ЭтотОбъект);
	
КонецПроцедуры


НастройкаПериода = Новый НастройкаПериода;
#КонецЕсли
