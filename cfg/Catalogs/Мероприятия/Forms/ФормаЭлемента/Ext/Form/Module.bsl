﻿Перем мЧас;
Перем мМинута;
Перем мДлинаЧаса;

////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ ФОРМЫ

Процедура ДействияФормыРедактироватьКод(Кнопка)
	МеханизмНумерацииОбъектов.ИзменениеВозможностиРедактированияНомера(ЭтотОбъект.Метаданные(), ЭтаФорма, ЭлементыФормы.ДействияФормы.Кнопки.Подменю, ЭлементыФормы.Код);
КонецПроцедуры

// Процедура вызывается при открытии формы
Процедура ПриОткрытии()
	
	ЭлементыФормы.СоставМероприятия.НастройкаПорядка.ДатаНачала.Доступность = Истина;
	ЭлементыФормы.СоставМероприятия.НастройкаПорядка.ДатаОкончания.Доступность = Истина;
	МеханизмНумерацииОбъектов.ДобавитьВМенюДействияКнопкуРедактированияКода(ЭлементыФормы.ДействияФормы.Кнопки.Подменю);
	МеханизмНумерацииОбъектов.УстановитьДоступностьПоляВводаНомера(Метаданные(), ЭтаФорма, ЭлементыФормы.ДействияФормы.Кнопки.Подменю,ЭлементыФормы.Код);
	
КонецПроцедуры

// Процедура вызывается перед записью элемента.
Процедура ПередЗаписью(Отказ)

	Отказ = НЕ ЗначениеЗаполнено(ДатаНачала) или НЕ ЗначениеЗаполнено(ДатаОкончания);
	Если Отказ Тогда
		Предупреждение(НСтр("ru='Должна быть определена продолжительность мероприятия!';uk='Повинна бути визначена тривалість заходу!'"));
	КонецЕсли;

	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("Мероприятие", Ссылка);
	Запрос.УстановитьПараметр("ДатаНачалаМероприятия", ДатаНачала);
	Запрос.УстановитьПараметр("ДатаОкончанияМероприятия", КонецДня(ДатаОкончания));

	Запрос.Текст = "ВЫБРАТЬ ПЕРВЫЕ 1
	|	СоставМероприятия.Владелец,
	|	СоставМероприятия.ДатаНачала,
	|	СоставМероприятия.ДатаОкончания,
	|	СоставМероприятия.Наименование
	|ИЗ
	|	Справочник.СоставМероприятия КАК СоставМероприятия
	|
	|ГДЕ
	|	(СоставМероприятия.ДатаНачала < &ДатаНачалаМероприятия ИЛИ
	|	СоставМероприятия.ДатаОкончания > &ДатаОкончанияМероприятия) И
	|	СоставМероприятия.Владелец = &Мероприятие";

	Выборка = Запрос.Выполнить().Выбрать();
	Пока Выборка.Следующий() Цикл
		Предупреждение(НСтр("ru='Период проведения составной части ""';uk='Період проведення складової частини ""'") + Выборка.Наименование + НСтр("ru='"" не соответствует периоду проведения мероприятия!';uk='"" не відповідає періоду проведення заходу!'"));
		Отказ = Истина;
	КонецЦикла; 

КонецПроцедуры

// Обработчик события ПослеЗаписи Формы.
//
Процедура ПослеЗаписи()
	МеханизмНумерацииОбъектов.ОбновитьПодсказкуКодНомерОбъекта(ЭтотОбъект.Метаданные(), ЭлементыФормы.ДействияФормы.Кнопки.Подменю, ЭлементыФормы.Код);
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// ПРОЦЕДУРЫ - ДЕЙСТВИЯ КОМАНДНЫХ ПАНЕЛЕЙ ФОРМЫ

Процедура ОсновныеДействияФормыДействиеПечать(Кнопка)
	
	Если ЭтоНовый() или Модифицированность() Тогда
		Вопрос = НСтр("ru='Перед печатью необходимо записать элемент. Записать?';uk='Перед друком необхідно записати елемент. Записати?'");
		Ответ  = Вопрос(Вопрос, РежимДиалогаВопрос.ОКОтмена);
		Если Ответ = КодВозвратаДиалога.ОК Тогда
			ЗаписатьВФорме();
		Иначе
			Возврат;
		КонецЕсли;
	КонецЕсли;
	Печать()
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ ПОЛЯ СПИСКА ПОДЧИНЕННОГО СПРАВОЧНИКА

// проверяем, записано ли мероприятие
// иначе предлагаем записать - с тем, чтобы можно было 
// вводить записи подчиненного справочника
Процедура СоставМероприятияПередНачаломДобавления(Элемент, Отказ, Копирование, Родитель, ЭтоГруппа)
	
	Если ЭтоНовый() Тогда
		Отказ = (Вопрос(НСтр("ru='Информация о мероприятии еще не записана! Записать?';uk='Інформація про захід ще не записана! Записати?'"), РежимДиалогаВопрос.ДаНет,, КодВозвратаДиалога.Да,) <> КодВозвратаДиалога.Да);
		Если Не Отказ Тогда
			Отказ = НЕ ЗначениеЗаполнено(ДатаНачала) или НЕ ЗначениеЗаполнено(ДатаОкончания);
			Если Отказ Тогда
				Предупреждение(НСтр("ru='Должна быть определена продолжительность мероприятия!';uk='Повинна бути визначена тривалість заходу!'"));
			Иначе
				Отказ = Не ЗаписатьВФорме()
			КонецЕсли;
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

// в новой строке заполняем продолжительность части мероприятия
Процедура СоставМероприятияПриНачалеРедактирования(Элемент, НоваяСтрока)
	
	Если НоваяСтрока Тогда
		Если НЕ ЗначениеЗаполнено(Элемент.ТекущиеДанные.ДатаНачала) Тогда
			Элемент.ТекущиеДанные.ДатаНачала = ДатаНачала;
		КонецЕсли;
		Если НЕ ЗначениеЗаполнено(Элемент.ТекущиеДанные.ДатаОкончания) Тогда
			Элемент.ТекущиеДанные.ДатаОкончания = НачалоМинуты(КонецДня(ДатаОкончания));
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

// проверяем соответствие продолжительности части мероприятия периоду проведения мероприятия
Процедура СоставМероприятияПередОкончаниемРедактирования(Элемент, НоваяСтрока, ОтменаРедактирования, Отказ)
	
	Если НЕ ОтменаРедактирования Тогда
		СтрОшибка = ПроверитьДатыНачалаИОконачнияСоставнойЧасти(Элемент.ТекущиеДанные);
		Если НЕ ПустаяСтрока(СтрОшибка) Тогда
			Предупреждение(СтрОшибка);
			Отказ = Истина;
		КонецЕсли; 
	КонецЕсли; 
	
КонецПроцедуры

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
