﻿////////////////////////////////////////////////////////////////////////////////
// ПРОЦЕДУРЫ И ФУНКЦИИ ОБЩЕГО НАЗНАЧЕНИЯ 

// Преобразует значение системного перечисления ВидСравнения в текст для запроса
//
// Параметры
//  СтруктураОтбора		–	<Структура>
//							Структура параметров отбора. Если есть элемент структуры с ключом "ВидСравненияОтбора",
//							значение этого элемента преобразуется в текст для запроса.
//							Необязательный элемент, по умолчанию ВидСравнения.Равно
//
// Возвращаемое значение:
//   <Строка> – текст сравнения для запроса
//
Функция ПолучитьВидСравненияДляЗапроса(СтруктураОтбора) Экспорт 

	Если НЕ СтруктураОтбора.Свойство("ВидСравненияОтбора") Тогда
		Возврат "=";
	ИначеЕсли СтруктураОтбора.ВидСравненияОтбора = ВидСравнения.Равно Тогда
		Возврат "=";
	ИначеЕсли СтруктураОтбора.ВидСравненияОтбора = ВидСравнения.НеРавно Тогда
		Возврат "<>";
	ИначеЕсли СтруктураОтбора.ВидСравненияОтбора = ВидСравнения.ВСписке Тогда
		Возврат "В";
	ИначеЕсли СтруктураОтбора.ВидСравненияОтбора = ВидСравнения.НеВСписке Тогда
		Возврат "НЕ В";
	ИначеЕсли СтруктураОтбора.ВидСравненияОтбора = ВидСравнения.ВИерархии Тогда
		Возврат "В ИЕРАРХИИ";
	ИначеЕсли СтруктураОтбора.ВидСравненияОтбора = ВидСравнения.ВСпискеПоИерархии Тогда
		Возврат "В ИЕРАРХИИ";
	ИначеЕсли СтруктураОтбора.ВидСравненияОтбора = ВидСравнения.НеВСпискеПоИерархии Тогда
		Возврат "НЕ В ИЕРАРХИИ";
	ИначеЕсли СтруктураОтбора.ВидСравненияОтбора = ВидСравнения.НеВИерархии Тогда
		Возврат "НЕ В ИЕРАРХИИ";
	ИначеЕсли СтруктураОтбора.ВидСравненияОтбора = ВидСравнения.Больше Тогда
		Возврат ">";
	ИначеЕсли СтруктураОтбора.ВидСравненияОтбора = ВидСравнения.БольшеИлиРавно Тогда
		Возврат ">=";
	ИначеЕсли СтруктураОтбора.ВидСравненияОтбора = ВидСравнения.Меньше Тогда
		Возврат "<";
	ИначеЕсли СтруктураОтбора.ВидСравненияОтбора = ВидСравнения.МеньшеИлиРавно Тогда
		Возврат "<=";
	Иначе // другие варианты 
		Возврат "=";
	КонецЕсли;

КонецФункции // ПолучитьВидСравненияДляЗапроса()

/////////////////////////////////////////////////////////////////////////////////
// ПРОЦЕДУРЫ И ФУНКЦИИ ДЛЯ ОБСЛУЖИВАНИЯ ВЕДЕНИЯ ВЗАИМОРАСЧЕТОВ ПО ДОКУМЕНТАМ
// РАСЧЕТОВ С КОНТРАГЕНТАМИ

// Процедура формирует структуру с итоговыми данными взаиморасчетов по документу
Функция ПолучитьСтруктуруВзаиморасчетовПоДокументу(ДокументОбъект, СуммаВзаиморасчетовПоДокументу) Экспорт
	
	СтруктураВзаиморасчетов = Новый Структура;
	
	ТаблицаДокументов = ДокументОбъект.ДокументыРасчетовСКонтрагентом.Выгрузить();
	СтруктураВзаиморасчетов.Вставить("ПоДокументуВал", СуммаВзаиморасчетовПоДокументу);
	
	СтруктураВзаиморасчетов.Вставить("ПредоплатаВал", ТаблицаДокументов.Итог("СуммаВзаиморасчетов"));
	
	ОстатокВал = СуммаВзаиморасчетовПоДокументу - СтруктураВзаиморасчетов.ПредоплатаВал;
	СтруктураВзаиморасчетов.Вставить("ОстатокВал", ОстатокВал);
	
	
	Возврат СтруктураВзаиморасчетов;
	
КонецФункции
