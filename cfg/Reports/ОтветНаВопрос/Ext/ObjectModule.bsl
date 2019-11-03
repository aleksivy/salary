﻿
#Если Клиент Тогда

Перем ТекстЗапросаОтчета Экспорт;

// Составляет список возможных вариантов отображения
//
// Параметры: 
//  Отчет - объект отчета.
//
// Возвращаемое значение:
//  спиок значений.
//
Функция ПолучитьСписокВариантовОтображенияОтчета() Экспорт

	СписокВариантовОтображения = Новый СписокЗначений;
	СписокВариантовОтображения.Добавить(Перечисления.ВариантыОтображенияОтчетов.СводнаяТаблица,"Сводная таблица");
	СписокВариантовОтображения.Добавить(Перечисления.ВариантыОтображенияОтчетов.Диаграмма,"Диаграмма");
	СписокВариантовОтображения.Добавить(Перечисления.ВариантыОтображенияОтчетов.Таблица,"Таблица");
	Возврат СписокВариантовОтображения

КонецФункции // ПолучитьСписокВариантовОтображенияОтчета

////////////////////////////////////////////////////////////////////////////////
// ЭКСПОРТНЫЕ ПРОЦЕДУРЫ И ФУНКЦИИ

// Возвращает основную форму отчета, связанную с данным экземпляром отчета
//
// Параметры
//	Нет
//
Функция ПолучитьОсновнуюФорму() Экспорт
	
	ОснФорма = ПолучитьФорму();
	ОснФорма.ОбщийОтчет = ОбщийОтчет;
	ОснФорма.ЭтотОтчет = ЭтотОбъект;
	Возврат ОснФорма;
	
КонецФункции // ПолучитьОсновнуюФорму()

// Возвращает форму настройки 
//
// Параметры:
//	Нет.
//
// Возвращаемое значение:
//	
//
Функция ПолучитьФормуНастройки() Экспорт
	
	ФормаНастройки = ОбщийОтчет.ПолучитьФорму("ФормаНастройка");
	Возврат ФормаНастройки;
	
КонецФункции // ПолучитьФормуНастройки()

// Читает свойство Построитель отчета
//
// Параметры
//	Нет
//
Функция ПолучитьПостроительОтчета() Экспорт

	Возврат ОбщийОтчет.ПолучитьПостроительОтчета();

КонецФункции // ПолучитьПостроительОтчета()

// Читает свойство Построитель отчета
//
// Параметры
//	Нет
//
Функция ПолучитьПостроительДиаграммы() Экспорт

	Возврат ОтчетДиаграмма.ПолучитьПостроительДиаграммы();

КонецФункции // ПолучитьПостроительОтчета()

// Настраивает отчет по переданной структуре параметров
//
// Параметры:
//	Нет.
//
Процедура Настроить(Параметры) Экспорт

	ОбщийОтчет.Настроить(Параметры, ЭтотОбъект);
	ОтчетДиаграмма.ПостроительОтчета.УстановитьНастройки(ОбщийОтчет.ПостроительОтчета.ПолучитьНастройки());

КонецПроцедуры

// Настраивает отчет по переданной структуре параметров
//
// Параметры:
//	Нет.
//
Процедура НастроитьДиаграмму(Параметры) Экспорт

	ОтчетДиаграмма.Настроить(Параметры, ЭтотОбъект);
	ОбщийОтчет.ПостроительОтчета.УстановитьНастройки(ОтчетДиаграмма.ПостроительОтчета.ПолучитьНастройки());
	
КонецПроцедуры

// Выполняет настройку отчета по умолчанию для заданного вида отчета
//
// Параметры: 
// 
Процедура ЗаполнитьНачальныеНастройки() Экспорт
	
	ОбщийОтчет.ИмяРегистра = "ОтветыНаВопрос";
	ОбщийОтчет.мНазваниеОтчета = "Ответы на вопрос";
	ОтчетДиаграмма.ИмяРегистра = "-";
	ОтчетДиаграмма.мНазваниеОтчета = "Ответы на вопрос";
	
	ОбщийОтчет.мВыбиратьИмяРегистра = Ложь;
	ОбщийОтчет.мВыбиратьИспользованиеСвойств =  Ложь;
	
	ОтчетДиаграмма.мВыбиратьИмяРегистра = Ложь;
	ОтчетДиаграмма.мВыбиратьИспользованиеСвойств =  Ложь;
	
	МассивОтбора = Новый Массив;
	ПостроительОтчета = ОбщийОтчет.ПостроительОтчета;
	
	МассивОтбора = Новый Массив;
	ПостроительОтчета = ОбщийОтчет.ПостроительОтчета;
	
	ТекстЗапроса = СтрЗаменить(ТекстЗапросаОтчета, "//ВОПРОСУСЛОВИЕ1", " ТиповыеАнкетыВопросыАнкеты.Вопрос = ОпросВопросы.Вопрос ");
	ТекстЗапроса = СтрЗаменить(ТекстЗапроса, "//ВОПРОСУСЛОВИЕ2", " ТиповыеАнкетыВопросыАнкеты.Вопрос = ОпросСоставнойОтвет.ВопросВладелец ");
		
	ПостроительОтчета.Текст = ТекстЗапроса;
	ПостроительОтчета.ЗаполнитьНастройки();
	
	// группировки по умолчанию
	ПостроительОтчета.ИзмеренияСтроки.Очистить();
	ПостроительОтчета.ИзмеренияСтроки.Добавить("ТиповойОтвет");
	
	// поля по умолчанию
	ПостроительОтчета.ВыбранныеПоля.Очистить();
	//ПостроительОтчета.ВыбранныеПоля.Добавить("Количество");
	//ПостроительОтчета.ВыбранныеПоля.Добавить("ТиповойОтветСумма");
	
	ОбщийОтчет.ЗаполнитьПоказатели("Количество", 					"Количество",  			Истина, "");
	ОбщийОтчет.ЗаполнитьПоказатели("ТиповойОтветСумма", 			"Сумма",  				Истина, "");
	ОбщийОтчет.ЗаполнитьПоказатели("РазвернутыйОтвет", 				"Ответ",  				Истина, "");
	УправлениеОтчетами.ЗаполнитьПредставленияПолей(Новый Структура, ОбщийОтчет.ПостроительОтчета);
	УправлениеОтчетами.ОчиститьДополнительныеПоляПостроителя(ОбщийОтчет.ПостроительОтчета);
	// копирование настроек построителя
	ОтчетДиаграмма.ПостроительОтчета.Текст 	= ТекстЗапроса;
	ОтчетДиаграмма.ПостроительОтчета.УстановитьНастройки(ПостроительОтчета.ПолучитьНастройки());
	ОтчетДиаграмма.ЗаполнитьПоказатели("Количество", 				"Количество",  			Истина, "");
	ОтчетДиаграмма.ЗаполнитьПоказатели("ТиповойОтветСумма", 		"Сумма",		  	   	Истина, "");
	ОтчетДиаграмма.ЗаполнитьПоказатели("РазвернутыйОтвет", 			"Ответ",  				Истина, "");
	УправлениеОтчетами.ЗаполнитьПредставленияПолей(Новый Структура, ОтчетДиаграмма.ПостроительОтчета);
	УправлениеОтчетами.ОчиститьДополнительныеПоляПостроителя(ОтчетДиаграмма.ПостроительОтчета);
	
	// отборы по умолчанию
	МассивОтбора.Добавить("Анкета");
	МассивОтбора.Добавить("Вопрос");
	МассивОтбора.Добавить("Раздел");
	МассивОтбора.Добавить("Опрос");
	УправлениеОтчетами.ЗаполнитьОтбор(МассивОтбора, ПостроительОтчета);
	
	// параметры отчета
	ОбщийОтчет.ВыводитьИтогиПоВсемУровням 					= Ложь;
	ОбщийОтчет.ВыводитьПоказателиВСтроку 					= Истина;
	ОбщийОтчет.ВыводитьДополнительныеПоляВОтдельнойКолонке 	= Ложь;
	ОбщийОтчет.мРежимВводаПериода 							= 0;
	
	ПустаяСтруктура = Новый Структура;
	
	ОтчетДиаграмма.мРежимВводаПериода 		= 0;
	
КонецПроцедуры

// Выполняет запрос и формирует табличный документ-результат отчета
// в соответствии с настройками, заданными значениями реквизитов отчета.
//
// Параметры:
//	ДокументРезультат - табличный документ, формируемый отчетом,
//
//Процедура СформироватьОтчет(ДокументРезультат, ЕстьОшибки = Ложь) Экспорт
Процедура СформироватьОтчет(ДокументРезультат, ПоказыватьЗаголовок = Ложь, ВысотаЗаголовка = 0, ТолькоЗаголовок = Ложь) Экспорт

	ОбщийОтчет.СформироватьОтчет(ДокументРезультат, ПоказыватьЗаголовок, ВысотаЗаголовка, ТолькоЗаголовок);

КонецПроцедуры

// Выполняет запрос и формирует диаграмму-результат отчета
// в соответствии с настройками, заданными значениями реквизитов отчета.
//
// Параметры:
//	ДокументРезультат - табличный документ, формируемый отчетом,
//	ЕстьОшибки - флаг того, что при формировании произошли ошибки
//
//Процедура СформироватьОтчет(ДокументРезультат, ЕстьОшибки = Ложь) Экспорт
Процедура СформироватьДиаграмму(Диаграмма) Экспорт

	ОтчетДиаграмма.СформироватьОтчет(Диаграмма);

КонецПроцедуры

// Выполняет запрос и формирует табличный документ-результат отчета
// в соответствии с настройками, заданными значениями реквизитов отчета.
//
// Параметры:
//	ДокументРезультат - табличный документ, формируемый отчетом,
//	ЕстьОшибки - флаг того, что при формировании произошли ошибки
//
//Процедура СформироватьОтчет(ДокументРезультат, ЕстьОшибки = Ложь) Экспорт
Процедура СформироватьСводнуюТаблицу(ДокументРезультат) Экспорт

	ПостроительОтчета = ПолучитьПостроительОтчета();
	ПостроительОтчета.Параметры.Вставить("ДатаНач", ОбщийОтчет.ДатаНач);
	Если ОбщийОтчет.ДатаКон <> '00010101000000' Тогда
		Если ОбщийОтчет.мРежимВводаПериода = 1 Тогда
			ПостроительОтчета.Параметры.Вставить("ДатаКон", НачалоДня(ОбщийОтчет.ДатаКон + 60*60*24));
		Иначе
			ПостроительОтчета.Параметры.Вставить("ДатаКон", КонецДня(ОбщийОтчет.ДатаКон ));
		КонецЕсли;
	Иначе
		ПостроительОтчета.Параметры.Вставить("ДатаКон", '00010101000000');
	КонецЕсли;
	
	ПостроительОтчета.Выполнить();
	ДокументРезультат.ИсточникДанных = ПостроительОтчета.Результат;
	ОбновлятьОформлениеСводнойТаблицы = ДокументРезультат.Данные.Количество() = 0 и ДокументРезультат.Строки.Количество() = 0;
	Если ОбновлятьОформлениеСводнойТаблицы Тогда
		Для ИндексПоля = 0 По ДокументРезультат.Поля.Количество() - 1 Цикл
			ПолеТаблицы = ДокументРезультат.Поля[ИндексПоля];
			Если ПолеТаблицы.Ресурс Тогда
				ДокументРезультат.Данные.Добавить(ПолеТаблицы)
			Иначе
				ДокументРезультат.Строки.Добавить(ПолеТаблицы)
			КонецЕсли;
		КонецЦикла;
		ДокументРезультат.Колонки.Добавить(ДокументРезультат.Данные);
	КонецЕсли;
	
КонецПроцедуры

// Процедура обработки расшифровки
//
// Параметры:
//	Нет.
//
Процедура ОбработкаРасшифровки(РасшифровкаСтроки, ПолеТД, ВысотаЗаголовка, СтандартнаяОбработка) Экспорт
	
	// Добавление расшифровки из колонки
	Если ТипЗнч(РасшифровкаСтроки) = Тип("Структура") Тогда
		
		// Расшифровка колонки находится в заголовке колонки
		РасшифровкаКолонки = ПолеТД.Область(ВысотаЗаголовка+2, ПолеТД.ТекущаяОбласть.Лево).Расшифровка;

		Расшифровка = Новый Структура;

		Для каждого Элемент Из РасшифровкаСтроки Цикл
			Расшифровка.Вставить(Элемент.Ключ, Элемент.Значение);
		КонецЦикла;

		Если ТипЗнч(РасшифровкаКолонки) = Тип("Структура") Тогда

			Для каждого Элемент Из РасшифровкаКолонки Цикл
				Расшифровка.Вставить(Элемент.Ключ, Элемент.Значение);
			КонецЦикла;

		КонецЕсли; 

		ОбщийОтчет.ОбработкаРасшифровкиСтандартногоОтчета(Расшифровка, СтандартнаяОбработка, ЭтотОбъект);

	КонецЕсли;
	
КонецПроцедуры // ОбработкаРасшифровки()

// Формирует структуру, в которую складываются настройки
//
Функция СформироватьСтруктуруДляСохраненияНастроек(ПоказыватьЗаголовок) Экспорт
	
	СтруктураНастроек = Новый Структура;
	
	ОбщийОтчет.СформироватьСтруктуруДляСохраненияНастроек(СтруктураНастроек, ПоказыватьЗаголовок);
	СтруктураНастроек.Вставить("ВариантОтображения", ВариантОтображения);
	
	Возврат СтруктураНастроек;
	
КонецФункции

// Заполняет настройки из структуры - кроме состояния панели "Отбор"
//
Процедура ВосстановитьНастройкиИзСтруктуры(СохраненныеНастройки, ПоказыватьЗаголовок, Отчет = Неопределено) Экспорт

	Если Отчет = Неопределено Тогда
		Отчет = ЭтотОбъект;
	КонецЕсли;
	
	ОбщийОтчет.ВосстановитьНастройкиИзСтруктуры(СохраненныеНастройки, ПоказыватьЗаголовок, Отчет);
	Если ТипЗнч(СохраненныеНастройки) = Тип("Структура") Тогда
		СохраненныеНастройки.Свойство("ВариантОтображения", ВариантОтображения);
	КонецЕсли;
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// ОПЕРАТОРЫ ОСНОВНОЙ ПРОГРАММЫ
// 

ВариантОтображения = Перечисления.ВариантыОтображенияОтчетов.Таблица;

#КонецЕсли

