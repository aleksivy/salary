﻿Перем глОбщиеЗначения Экспорт;

Процедура ПриНачалеРаботыСистемы()
	
	Если ИмяПользователя() = "_ТестированиеРолей" Тогда
		Возврат;
	КонецЕсли;	
	
	// Вызов исключения, если не прошла процедура определения пользователя
	УправлениеПользователями.ПользовательОпределен();

КонецПроцедуры

Функция ПолучитьТип(СтрокаОписанияТипа) Экспорт
	Возврат(Тип(СтрокаОписанияТипа));
КонецФункции

Функция глЗначениеПеременной(Имя) Экспорт
	
	Возврат ОбщегоНазначения.ПолучитьЗначениеПеременной(Имя, глОбщиеЗначения);

КонецФункции

// Процедура установки значения экспортных переменных модуля приложения
//
// Параметры
//  Имя - строка, содержит имя переменной целиком
// 	Значение - значение переменной
//
Процедура глЗначениеПеременнойУстановить(Имя, Значение, ОбновлятьВоВсехКэшах = Ложь) Экспорт
	
	ОбщегоНазначения.УстановитьЗначениеПеременной(Имя, глОбщиеЗначения, Значение, ОбновлятьВоВсехКэшах);
	
КонецПроцедуры