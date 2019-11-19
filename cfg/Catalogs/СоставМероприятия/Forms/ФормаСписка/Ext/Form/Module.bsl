﻿Перем мЧас;
Перем мМинута;
Перем мДлинаЧаса;

////////////////////////////////////////////////////////////////////////////////
// ПРОЦЕДУРЫ И ФУНКЦИИ ДЛЯ УПРАВЛЕНИЯ ВНЕШНИМ ВИДОМ ФОРМЫ

// Устанавливает доступность поля списка помещений
//
// Параметры: 
//  ЗначениеТерритории - ссылка на эл. спр. ТерриторииКомпании (явл. владельцем)
//
// Возвращаемое значение:
//  Нет.
//
Процедура УстановитьДоступностьЭлементов(Мероприятие)
	
	ЭлементыФормы.СправочникСписок.ТолькоПросмотр = НЕ ЗначениеЗаполнено(Мероприятие);
    Если НЕ ЗначениеЗаполнено(Мероприятие) Тогда
		Заголовок = НСтр("ru='Состав мероприятия: ';uk='Склад заходу: '") + Мероприятие.Наименование
	Иначе
		Заголовок = НСтр("ru='Состав мероприятий';uk='Склад заходів'") 
	КонецЕсли;	
	
КонецПроцедуры // УстановитьДоступностьЭлементов

Процедура ДействияФормыРедактироватьКод(Кнопка)
	МеханизмНумерацииОбъектов.ИзменениеВозможностиРедактированияНомера(Метаданные.Справочники.СоставМероприятия, ЭлементыФормы.СправочникСписок, ЭлементыФормы.ДействияФормы.Кнопки.Подменю, ЭлементыФормы.СправочникСписок.Колонки.Код);
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ ФОРМЫ

Процедура ПриОткрытии()
	// установим доступность списка помещений
	УстановитьДоступностьЭлементов(Отбор.Владелец.Значение);
	
	МеханизмНумерацииОбъектов.ДобавитьВМенюДействияКнопкуРедактированияКода(ЭлементыФормы.ДействияФормы.Кнопки.Подменю);
	МеханизмНумерацииОбъектов.УстановитьДоступностьПоляВводаНомера(Метаданные.Справочники.СоставМероприятия, ЭлементыФормы.СправочникСписок, ЭлементыФормы.ДействияФормы.Кнопки.Подменю, ЭлементыФормы.СправочникСписок.Колонки.Код);
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// ПРОЦЕДУРЫ - ОБРАБОТЧИКИ СОБЫТИЙ РЕКВИЗИТОВ

Процедура МероприятиеПриИзменении(Элемент)
	// установим доступность состава мероприятия
	УстановитьДоступностьЭлементов(Элемент.Значение);
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ ПОЛЯ СПИСКА СПРАВОЧНИКА

Процедура СоставМероприятияПриНачалеРедактирования(Элемент, НоваяСтрока)
	Если НоваяСтрока Тогда
		Если НЕ ЗначениеЗаполнено(Элемент.ТекущиеДанные.ДатаНачала) Тогда
			Элемент.ТекущиеДанные.ДатаНачала = Элемент.ТекущиеДанные.Владелец.ДатаНачала;
		КонецЕсли;
		Если НЕ ЗначениеЗаполнено(Элемент.ТекущиеДанные.ДатаОкончания) Тогда
			Элемент.ТекущиеДанные.ДатаОкончания = НачалоМинуты(КонецДня(Элемент.ТекущиеДанные.Владелец.ДатаОкончания));
		КонецЕсли;
	КонецЕсли;
КонецПроцедуры

Процедура СоставМероприятияПередОкончаниемРедактирования(Элемент, НоваяСтрока, ОтменаРедактирования, Отказ)
	Если НЕ ОтменаРедактирования Тогда
		ОбъектМероприятие = Элемент.ТекущиеДанные.Владелец.ПолучитьОбъект(); 
		СтрОшибка = ОбъектМероприятие.ПроверитьДатыНачалаИОконачнияСоставнойЧасти(Элемент.ТекущиеДанные);
		Если НЕ ПустаяСтрока(СтрОшибка) Тогда
			Предупреждение(СтрОшибка);
			Отказ = Истина;
		КонецЕсли; 
	КонецЕсли; 
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ РЕКВИЗИТОВ ПОЛЯ СПИСКА СПРАВОЧНИКА

Процедура СоставМероприятияДатаНачалаНачалоВыбора(Элемент, СтандартнаяОбработка)
	
	мЧас = Час(Элемент.Значение);
	мМинута = Минута(Элемент.Значение);
	
КонецПроцедуры

Процедура СоставМероприятияДатаНачалаНачалоВыбораИзСписка(Элемент, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	Если НЕ ЗначениеЗаполнено(Элемент.Значение) Тогда
		Элемент.Значение = РабочаяДата
	КонецЕсли;
	РаботаСДиалогами.ВыбратьВремяДня(ЭтаФорма,Элемент.Значение, Элемент, глЗначениеПеременной("глТекущийПользователь"), Ложь);
	
КонецПроцедуры

Процедура СоставМероприятияДатаНачалаОбработкаВыбора(Элемент, ВыбранноеЗначение, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	Элемент.Значение = НачалоДня(ВыбранноеЗначение) + мЧас * мДлинаЧаса + мМинута*60;
	мЧас = 0;
	мМинута = 0;
	
КонецПроцедуры

Процедура СоставМероприятияДатаОкончанияНачалоВыбора(Элемент, СтандартнаяОбработка)
	
	мЧас = Час(Элемент.Значение);
	мМинута = Минута(Элемент.Значение);
	
КонецПроцедуры

Процедура СоставМероприятияДатаОкончанияНачалоВыбораИзСписка(Элемент, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	Если НЕ ЗначениеЗаполнено(Элемент.Значение) Тогда
		Элемент.Значение = РабочаяДата
	КонецЕсли;
	РаботаСДиалогами.ВыбратьВремяДня(ЭтаФорма,Элемент.Значение, Элемент, глЗначениеПеременной("глТекущийПользователь"), Ложь);
	
КонецПроцедуры

Процедура СоставМероприятияДатаОкончанияОбработкаВыбора(Элемент, ВыбранноеЗначение, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	Элемент.Значение = НачалоДня(ВыбранноеЗначение) + мЧас * мДлинаЧаса + мМинута*60;
	мЧас = 0;
	мМинута = 0;
	
КонецПроцедуры


мДлинаЧаса = 3600;

