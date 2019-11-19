﻿// Процедура вызывается при выборе пункта подменю "Движения документа по регистрам" меню "Перейти".
// командной панели формы. Процедура отрабатывает печать движений документа по регистрам.
//
Процедура ДействияФормыДвиженияДокументаПоРегистрам(Кнопка)

	Если ЭлементыФормы.ДокументСписок.ТекущиеДанные = Неопределено тогда
		Возврат
	КонецЕсли;

	РаботаСДиалогами.НапечататьДвиженияДокумента(ЭлементыФормы.ДокументСписок.ТекущиеДанные.Ссылка);

КонецПроцедуры // ДействияФормыДвиженияДокументаПоРегистрам()
                       
// Процедура вызывается при выборе пункта подменю "Структура подчиненности" меню "Перейти".
Процедура ДействияФормыСтруктураПодчиненностиДокумента(Кнопка)
	
	Если ЭлементыФормы.ДокументСписок.ТекущиеДанные = Неопределено тогда
		Возврат
	КонецЕсли;
	
	РаботаСДиалогами.ПоказатьСтруктуруПодчиненностиДокумента(ЭлементыФормы.ДокументСписок.ТекущиеДанные.Ссылка);
	
КонецПроцедуры

Процедура ДействияФормыФайлы(Кнопка)
	
	Если НЕ ЭлементыФормы.ДокументСписок.ТекущаяСтрока = Неопределено Тогда
		ФормаФайлов = Справочники.ХранилищеДополнительнойИнформации.ПолучитьФорму("ФормаСпискаФайловИИзображений", ЭтаФорма);
		
		ФормаФайлов.Изображения.Отбор.Объект.Использование                               = Истина;
		ФормаФайлов.Изображения.Отбор.Объект.Значение                                    = ЭлементыФормы.ДокументСписок.ТекущаяСтрока.Ссылка;
		ФормаФайлов.ЭлементыФормы.Изображения.НастройкаОтбора.Объект.Доступность         = Ложь;
		ФормаФайлов.ЭлементыФормы.Изображения.Колонки.Объект.Видимость                   = Ложь;

		ФормаФайлов.ДополнительныеФайлы.Отбор.Объект.Использование                       = Истина;
		ФормаФайлов.ДополнительныеФайлы.Отбор.Объект.Значение                            = ЭлементыФормы.ДокументСписок.ТекущаяСтрока.Ссылка;
		ФормаФайлов.ЭлементыФормы.ДополнительныеФайлы.НастройкаОтбора.Объект.Доступность = Ложь;
		ФормаФайлов.ЭлементыФормы.ДополнительныеФайлы.Колонки.Объект.Видимость           = Ложь;

		ОбязательныеОтборы = Новый Структура;
		ОбязательныеОтборы.Вставить("Объект",ЭлементыФормы.ДокументСписок.ТекущаяСтрока.Ссылка);

		ФормаФайлов.ОбязательныеОтборы = ОбязательныеОтборы;
		
		ФормаФайлов.Открыть();
	КонецЕсли;
	
КонецПроцедуры
