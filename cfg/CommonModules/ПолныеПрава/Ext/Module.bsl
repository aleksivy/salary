﻿
// Процедура устанавливает параметры сеанса.
// 
Процедура УстановитьПараметрыСеанса() Экспорт
	
	ТекущийПользователь = УправлениеПользователями.ОпределитьТекущегоПользователя();	
	ПараметрыСеанса.ТекущийПользователь = ТекущийПользователь;
	
	УстановитьИзменяемыеПараметрыСеансаПользователя();
	
КонецПроцедуры

Процедура УстановитьГруппыТекущегоПользователя() Экспорт
	
	СоответствиеПоиска = Новый Соответствие;
	
	Запрос = Новый Запрос;
	
	Запрос.Текст = "
	|ВЫБРАТЬ РАЗЛИЧНЫЕ
	|	ГруппыПользователей.Ссылка КАК Ссылка
	|ИЗ
	|	Справочник.ГруппыПользователей КАК ГруппыПользователей
	|ГДЕ
	|	ГруппыПользователей.Ссылка В ИЕРАРХИИ
	|	(
	|	ВЫБРАТЬ
	|		Справочник.ГруппыПользователей.Ссылка
	|	ИЗ
	|		Справочник.ГруппыПользователей
	|	ГДЕ
	|		Справочник.ГруппыПользователей.ПользователиГруппы.Пользователь = &ТекущийПользователь
	|	)
	|";
	
	Запрос.УстановитьПараметр("ТекущийПользователь", ПараметрыСеанса.ТекущийПользователь);
	
	Выборка = Запрос.Выполнить().Выбрать();
	Пока Выборка.Следующий() Цикл
		ТекущаяСсылка = Выборка.Ссылка;
		Пока Истина Цикл
			Если СоответствиеПоиска.Получить(ТекущаяСсылка) = Неопределено Тогда
				СоответствиеПоиска.Вставить(ТекущаяСсылка);
			КонецЕсли;
			Если НЕ ЗначениеЗаполнено(ТекущаяСсылка.Родитель) Тогда
				Прервать;
			Иначе
				ТекущаяСсылка = ТекущаяСсылка.Родитель;
			КонецЕсли; 
		КонецЦикла;
	КонецЦикла; 
	
	Массив = Новый Массив;
	
	Для каждого ЭлементСоответствия Из СоответствиеПоиска Цикл
		Массив.Добавить(ЭлементСоответствия.Ключ);
	КонецЦикла; 
	
	Массив.Добавить(Справочники.ГруппыПользователей.ВсеПользователи);
	Массив.Добавить(ПараметрыСеанса.ТекущийПользователь);
	ПараметрыСеанса.ГруппыТекущегоПользователя = Новый ФиксированныйМассив(Массив);
	
КонецПроцедуры

// Процедура устанавливает параметры сеанса, которые зависят от данных в ИБ.
// 
Процедура УстановитьИзменяемыеПараметрыСеансаПользователя() Экспорт
	
	// Учетная запись почтового клиента для переписки с кандидатами
	ПараметрыСеанса.УчетнаяЗаписьНаборПерсонала = Константы.УчетнаяЗаписьНаборПерсонала.Получить();
	
	УстановитьГруппыТекущегоПользователя();
	
	УстановитьПараметрГраницыЗапретаИзмененияДанных();
	
КонецПроцедуры

// Сохранение в параметре сеанса ГраницыЗапретаИзмененияДанных границ запрета изменений данных
Процедура УстановитьПараметрГраницыЗапретаИзмененияДанных() Экспорт
		
	Если РольДоступна("ПолныеПрава")  И НЕ Константы.ПрименятьДатуЗапретаДляПолныхПрав.Получить() Тогда
		ПараметрыСеанса.ГраницыЗапретаИзмененияДанных = Новый ХранилищеЗначения(Неопределено, Новый СжатиеДанных(0));
		Возврат;
	КонецЕсли;
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	ВЫБОР КОГДА (Границы.Организация) ЕСТЬ NULL  ТОГДА &ПустаяОрганизация ИНАЧЕ Границы.Организация КОНЕЦ КАК Организация,
	|	МИНИМУМ(ВЫБОР КОГДА (Границы.ГраницаЗапретаИзменений) ЕСТЬ NULL  ТОГДА ДАТАВРЕМЯ(1, 1, 1) ИНАЧЕ Границы.ГраницаЗапретаИзменений КОНЕЦ) КАК ГраницаЗапретаИзменений
	|ИЗ
	|	Перечисление.НаборПравПользователей КАК НаборыПрав
	|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.ГраницыЗапретаИзмененияДанных КАК Границы
	|		ПО Границы.Роль = НаборыПрав.Ссылка
	|
    | 
	|ГДЕ
	|	(НаборыПрав.Ссылка В (&СписокДоступныхРолей) И НаборыПрав.Ссылка <> &Пользователь)
    |
	|СГРУППИРОВАТЬ ПО
	|	ВЫБОР КОГДА (Границы.Организация) ЕСТЬ NULL  ТОГДА &ПустаяОрганизация ИНАЧЕ Границы.Организация КОНЕЦ";
	
	Запрос.УстановитьПараметр("СписокДоступныхРолей",	ПолучитьСписокНабораПрав());
	Запрос.УстановитьПараметр("ПустаяОрганизация", 		Справочники.Организации.ПустаяСсылка());
	Запрос.УстановитьПараметр("Пользователь", 			Перечисления.НаборПравПользователей.Пользователь);
	РезультатЗапроса = Запрос.Выполнить();
	Если РезультатЗапроса.Пустой() Тогда
		Соответствие = Неопределено;
	Иначе			
		Соответствие = Новый Соответствие;
		Выборка = РезультатЗапроса.Выбрать();
		Пока Выборка.Следующий() Цикл
			Соответствие[Выборка.Организация] = Выборка.ГраницаЗапретаИзменений;
		КонецЦикла;		
		ЕСли Соответствие.Количество() = 0 Тогда
			Соответствие = Неопределено;
		КонецЕсли;		
	КонецЕсли;
	
	Если Соответствие <> Неопределено Тогда
		СохранятьСоответствие = Ложь;
		Для Каждого КлючИЗначение Из Соответствие Цикл
			ЕСли КлючИЗначение.Значение <> Дата('00010101') Тогда
				СохранятьСоответствие = Истина;
				Прервать;
			КонецЕсли;
		КонецЦикла;
		Если НЕ СохранятьСоответствие Тогда
			Соответствие = Неопределено;
		КонецЕсли;			
	КонецЕсли;
		
	ПараметрыСеанса.ГраницыЗапретаИзмененияДанных = Новый ХранилищеЗначения(Соответствие, Новый СжатиеДанных(0));
	
КонецПроцедуры

// используется базовыми конфигурациями
Функция ПолучитьВсеСоединенияИнформационнойБазы() Экспорт
	
	Соединения = Новый ТаблицаЗначений;
	Соединения.Колонки.Добавить("НомерСоединения");
	Соединения.Колонки.Добавить("ИмяПриложения");
	МассивСоединений = ПолучитьСоединенияИнформационнойБазы();
	Для Каждого Соединение Из МассивСоединений Цикл
		ЗаполнитьЗначенияСвойств(Соединения.Добавить(),Соединение);
	КонецЦикла;		
		
	Возврат Соединения
		
КонецФункции // ПолучитьВсеСоединенияИнформационнойБазы()

////////////////////////////////////////////////////////////////////////////////
// Процедура предназначена для изменения значения некоторых реквизитов электронного письма, доступного только для чтения
// Параметры
//  ЭлектронноеПисьмо – ссыслка на документ ЭлектнонноеПисьмо
//  ЗначенияРеквизитов – структура значений реквизитов, где ключ - имя реквизита,
//						 к изменению доступны только ограниченный перечень реквизитов.
Процедура УстановитьРеквизитЭлектронногоПисьма(ЭлектронноеПисьмо, ЗначенияРеквизитов) Экспорт
	
	РазрешенныеКИзмененениюРеквизиты = Новый Структура;
	РазрешенныеКИзмененениюРеквизиты.Вставить("Ответственный");
	РазрешенныеКИзмененениюРеквизиты.Вставить("НеРассмотрено");
	
	ЭлектронноеПисьмоОбъект = ЭлектронноеПисьмо.ПолучитьОбъект();
	Для Каждого КлючИЗначение ИЗ ЗначенияРеквизитов Цикл
		Если РазрешенныеКИзмененениюРеквизиты.Свойство(КлючИЗначение.Ключ) Тогда
			ЭлектронноеПисьмоОбъект[КлючИЗначение.Ключ] = КлючИЗначение.Значение;
		КонецЕсли;
	КонецЦикла;
	Попытка
		ЭлектронноеПисьмоОбъект.Записать();	
	Исключение
		Ош = ОписаниеОшибки();
	КонецПопытки;
	
КонецПроцедуры
////////////////////////////////////////////////////////////////////////////////

Процедура ЗарегистрироватьПраваДоступаПользователяКОбъекту(СсылкаНового, Родитель, Отказ = Ложь) Экспорт

	Если НЕ Справочники.ТипВсеСсылки().СодержитТип(ТипЗнч(СсылкаНового)) Тогда
		Возврат;
	КонецЕсли;
	
	Если СсылкаНового.ПолучитьОбъект() <> Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	НаборЗаписей = РегистрыСведений.ПраваДоступаПользователейКОбъектам.СоздатьНаборЗаписей();
	НаборЗаписей.Отбор.ОбъектДоступа.Значение      = СсылкаНового;
	НаборЗаписей.Отбор.ОбъектДоступа.Использование = Истина;
	
	НастройкаПравДоступа.ДополнитьНаборПравДоступаУнаследованнымиЗаписями(НаборЗаписей, СсылкаНового, Родитель);
	
	ЗаписатьНаборПрав(НаборЗаписей, Отказ, "Не удалось записать права доступа к объекту!")
	
КонецПроцедуры

Процедура ЗаписатьНаборПрав(НаборПрав, Отказ, ШапкаОшибки)
	
	Попытка
		НаборПрав.Записать();
	Исключение
		ОбщегоНазначения.СообщитьОбОшибке(ОписаниеОшибки(),, ШапкаОшибки);
		Отказ = Истина;
	КонецПопытки;
	
КонецПроцедуры

Процедура ОбновитьПраваДоступаКПрошлымРодителям(Ссылка, ПрошлыйИзмененныйРодительОбъектаДоступа, Отказ) Экспорт
	
	ОбновляемыеОбъекты = Новый Массив;
	ОбновляемыеОбъекты.Добавить(ПрошлыйИзмененныйРодительОбъектаДоступа);
	НастройкаПравДоступа.ПолучитьМассивРодительскихЭлементов(ПрошлыйИзмененныйРодительОбъектаДоступа, ОбновляемыеОбъекты);
		
	Запрос = Новый Запрос;
	Запрос.Текст = 
	"ВЫБРАТЬ РАЗЛИЧНЫЕ
	|	ПраваДоступаПользователейКОбъектам.ОбъектДоступа КАК Ссылка
	|ИЗ
	|	РегистрСведений.ПраваДоступаПользователейКОбъектам КАК ПраваДоступаПользователейКОбъектам
	|ГДЕ
	|	ПраваДоступаПользователейКОбъектам.ОбъектДоступа = ПраваДоступаПользователейКОбъектам.ВладелецПравДоступа И 
	|	ПраваДоступаПользователейКОбъектам.ОбъектДоступа В (&ОбновляемыеОбъекты)";
	
	Запрос.УстановитьПараметр("ОбновляемыеОбъекты", ОбновляемыеОбъекты);	
	
	ОбновляемыеОбъекты = Запрос.Выполнить().Выгрузить().ВыгрузитьКолонку("Ссылка");
	
	Для каждого ОбновляемыйОбъект Из ОбновляемыеОбъекты Цикл
		
		МассивЭлементов = НастройкаПравДоступа.ПолучитьМассивДочернихЭлементов(Ссылка);
		МассивЭлементов.Добавить(Ссылка);
		
		Для Каждого ПодчиненныйЭлемент ИЗ МассивЭлементов Цикл
		
			ПраваДоступаПользователей = РегистрыСведений.ПраваДоступаПользователейКОбъектам.СоздатьНаборЗаписей();
		
			ПраваДоступаПользователей.Отбор.ОбъектДоступа      .Установить(ПодчиненныйЭлемент);
			ПраваДоступаПользователей.Отбор.ВладелецПравДоступа.Установить(ОбновляемыйОбъект);
			
			Попытка
				ПраваДоступаПользователей.Записать();		
			Исключение
				Отказ = Истина;
				ОбщегоНазначения.СообщитьОбОшибке(ОписаниеОшибки() + Символы.ПС+ НСтр("ru=' .Не записаны права доступа к объекту: ';uk="" .Не записані права доступу до об'єкта: """) + Ссылка);
				Возврат;
			КонецПопытки;
		
		КонецЦикла;
			
	КонецЦикла;	
	
КонецПроцедуры

Функция ПолучитьСписокОбновляемыхОбъектовПриПереносеВГруппу(Ссылка, ОбновляемыеОбъекты) Экспорт
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
	"ВЫБРАТЬ РАЗЛИЧНЫЕ
	|	ПраваДоступаПользователейКОбъектам.ОбъектДоступа КАК Ссылка
	|ИЗ
	|	РегистрСведений.ПраваДоступаПользователейКОбъектам КАК ПраваДоступаПользователейКОбъектам
	|ГДЕ
	|	ПраваДоступаПользователейКОбъектам.ОбъектДоступа = ПраваДоступаПользователейКОбъектам.ВладелецПравДоступа и 
	|	(ПраваДоступаПользователейКОбъектам.ОбъектДоступа В (&ОбновляемыеОбъекты)";
	
	Если НастройкаПравДоступа.ПолучитьИмяРеквизитаРодителяОбъектаДоступа(Ссылка) = "Родитель" Тогда
		Запрос.Текст = Запрос.Текст + "
		|			ИЛИ ПраваДоступаПользователейКОбъектам.ОбъектДоступа В ИЕРАРХИИ (&Ссылка))";
		Запрос.УстановитьПараметр("Ссылка", Ссылка);
	Иначе
		Запрос.Текст = Запрос.Текст + ")";
	КонецЕсли; 
	
	Запрос.УстановитьПараметр("ОбновляемыеОбъекты", ОбновляемыеОбъекты);	
	
	
	Возврат Запрос.Выполнить().Выгрузить().ВыгрузитьКолонку("Ссылка");
	
КонецФункции
	
Функция ОбновитьПраваДоступаПользователейПоВладельцуДоступа(Ссылка, ОбновляемыйОбъект = Неопределено) Экспорт
	
	ПраваДоступаПользователей = РегистрыСведений.ПраваДоступаПользователейКОбъектам.СоздатьНаборЗаписей();
	
	ПраваДоступаПользователей.Отбор.ОбъектДоступа      .Установить(Ссылка);
	ПраваДоступаПользователей.Отбор.ВладелецПравДоступа.Установить(Ссылка);
	
	ПраваДоступаПользователей.Прочитать();
	
	ПраваДоступаПользователей.Отбор.ОбъектДоступа.Использование = Ложь;
	
	НастройкаПравДоступа.ДополнитьНаборПравДоступаНаследуемымиЗаписями(ПраваДоступаПользователей, ОбновляемыйОбъект);
		
	Попытка
		ПраваДоступаПользователей.Записать(ОбновляемыйОбъект = Неопределено);
	Исключение
		Возврат Ложь;
	КонецПопытки;
	
	Возврат Истина;
	
КонецФункции // () 

Процедура ЗаписатьПраваДоступаПользователей(ТаблицаНабораПрав, СтруктураОтбора, Отказ = Ложь, ШапкаОшибки = "") Экспорт
	
	НаборПрав   = РегистрыСведений.ПраваДоступаПользователейКОбъектам.СоздатьНаборЗаписей();
	
	Для Каждого ЭлементСтруктуры Из СтруктураОтбора Цикл
		Если Не ЭлементСтруктуры.Ключ = "ВладелецПравДоступа" Тогда
			НаборПрав  .Отбор[ЭлементСтруктуры.Ключ].Использование = Истина;
			НаборПрав  .Отбор[ЭлементСтруктуры.Ключ].Значение      = ЭлементСтруктуры.Значение;
		КонецЕсли;
	КонецЦикла;
	
	// Проверим набор на корректность установленных отборов
	Если НаборПрав.Отбор.ОбъектДоступа.Использование Тогда
		ОтборПоОбъектуДоступа = Истина;
		ОбъектДоступа = НаборПрав.Отбор.ОбъектДоступа.Значение;
		НаборПрав.Отбор.ВладелецПравДоступа.Установить(ОбъектДоступа);
		НаборПрав.Отбор.ОбъектДоступа.Использование = Ложь;
	ИначеЕсли НаборПрав.Отбор.Пользователь.Использование Тогда
		Если НЕ ЗначениеЗаполнено(НаборПрав.Отбор.Пользователь.Значение) Тогда
			Отказ = Истина;
			ОбщегоНазначения.СообщитьОбОшибке(ШапкаОшибки);
			Возврат;
		КонецЕсли;
		
	Иначе
		Отказ = Истина;
		ОбщегоНазначения.СообщитьОбОшибке(ШапкаОшибки);
		Возврат;
	КонецЕсли;
	
	ТаблицаРазличияСтрок   = НаборПрав.Выгрузить();
	ТаблицаРазличияЗаписей = НаборПрав.Выгрузить();
	
	НаборПрав.Прочитать();
	
	ТаблицаСтарогоНабора = НаборПрав.Выгрузить();
	
	ТаблицаНовогоНабора  = НастройкаПравДоступа.ПолучитьТаблицуПравДоступаБезУнаследуемыхЗаписей(ТаблицаНабораПрав);
	
	НаборПрав.Загрузить(ТаблицаНовогоНабора);
	
	// с полными правами можно все делать
	Если Не РольДоступна(Метаданные.Роли.ПолныеПрава) Тогда
	
		ТаблицаСтарогоЭталонногоНабора = НастройкаПравДоступа.ПолучитьТаблицуПравДоступаБезУнаследуемыхЗаписей(ТаблицаСтарогоНабора);
		
		// Начнем собирать изменения, которые были сделаны в текущем
		// наборе, относительно считанного из БД.
		МассивИзмерений = Новый Массив;
		МассивРесурсовИРеквизитов = Новый Массив;
		МетаданныеРегистра = Метаданные.РегистрыСведений.ПраваДоступаПользователейКОбъектам;
		Для каждого Измерение Из МетаданныеРегистра.Измерения Цикл
			МассивИзмерений.Добавить(Измерение.Имя);
		КонецЦикла;
		Для каждого Ресурс Из МетаданныеРегистра.Ресурсы Цикл
			МассивРесурсовИРеквизитов.Добавить(Ресурс.Имя);
		КонецЦикла;
		Для каждого Реквизит Из МетаданныеРегистра.Реквизиты Цикл
			МассивРесурсовИРеквизитов.Добавить(Реквизит.Имя);
		КонецЦикла;
		
		// Проверим удаленные и измененные записи
		Для Каждого СтрокаСтарогоНабора Из ТаблицаСтарогоЭталонногоНабора Цикл
			
			СтруктураПоиска = Новый Структура;
			Для каждого Измерение Из МассивИзмерений Цикл
				СтруктураПоиска.Вставить(Измерение, СтрокаСтарогоНабора[Измерение]);
			КонецЦикла;
			
			НайденныеСтроки = ТаблицаНовогоНабора.НайтиСтроки(СтруктураПоиска);
			Если НайденныеСтроки.Количество() = 0 Тогда
				НоваяСтрокаТаблицы = ТаблицаРазличияЗаписей.Добавить();
				Для каждого Измерение Из МассивИзмерений Цикл
					НоваяСтрокаТаблицы[Измерение] = СтрокаСтарогоНабора[Измерение];
				КонецЦикла; 
			Иначе
				Для каждого СтрокаНовогоНабора Из НайденныеСтроки Цикл
					Для каждого РесурсРеквизит Из МассивРесурсовИРеквизитов Цикл
						Если СтрокаНовогоНабора[РесурсРеквизит] <> СтрокаСтарогоНабора[РесурсРеквизит] Тогда
							НоваяСтрокаТаблицы = ТаблицаРазличияЗаписей.Добавить();
							Для каждого Измерение Из МассивИзмерений Цикл
								НоваяСтрокаТаблицы[Измерение] = СтрокаСтарогоНабора[Измерение];
							КонецЦикла;
							Прервать;
						КонецЕсли;
					КонецЦикла;
				КонецЦикла;
			КонецЕсли;
		
		КонецЦикла;
		
		// Проверим добавленные строки
		Для каждого СтрокаНовогоНабора Из ТаблицаНовогоНабора Цикл
			
			СтруктураПоиска = Новый Структура;
			Для каждого Измерение Из МассивИзмерений Цикл
				СтруктураПоиска.Вставить(Измерение, СтрокаНовогоНабора[Измерение]);
			КонецЦикла;
			
			НайденныеСтроки = ТаблицаСтарогоЭталонногоНабора.НайтиСтроки(СтруктураПоиска);
			Если НайденныеСтроки.Количество() = 0 Тогда
				НоваяСтрокаТаблицы = ТаблицаРазличияЗаписей.Добавить();
				Для каждого Измерение Из МассивИзмерений Цикл
					НоваяСтрокаТаблицы[Измерение] = СтрокаНовогоНабора[Измерение];
				КонецЦикла; 
			КонецЕсли; 
			
		КонецЦикла;
		
		// если ни одна строка прав не помяналась - то ничего делать не нужно
		Если ТаблицаРазличияЗаписей.Количество() Тогда
		
			ТаблицаРазличияЗаписей.Свернуть("ОбъектДоступа, ОбластьДанных");
			
			Запрос = Новый Запрос;
			Запрос.УстановитьПараметр("ГруппыТекущегоПользователя", ПараметрыСеанса.ГруппыТекущегоПользователя);
			Запрос.Текст = "";
			
			ИндексСтроки = 0;

			Для каждого СтрокаТаблицы Из ТаблицаРазличияЗаписей Цикл
				
				Если ИндексСтроки > 0 Тогда
					Запрос.Текст = Запрос.Текст + "
					|
					|ОБЪЕДИНИТЬ
					|" ;
				КонецЕсли; 
				
				Запрос.Текст = Запрос.Текст + "
				|
				|ВЫБРАТЬ
				|	" + ИндексСтроки + " КАК ИндексСтроки,
				|	ПраваДоступаПользователей.ОбъектДоступа КАК ОбъектДоступа
				|ИЗ
				|	РегистрСведений.ПраваДоступаПользователейКОбъектам КАК ПраваДоступаПользователей
				|ГДЕ
				|	ПраваДоступаПользователей.ОбъектДоступа = &ОбъектДоступа" + ИндексСтроки + "
				|	И
				|	ПраваДоступаПользователей.ОбластьДанных = &ОбластьДанных" + ИндексСтроки + "
				|	И
				|	ПраваДоступаПользователей.НастройкаДоступа = ИСТИНА
				|	И
				|	ПраваДоступаПользователей.Пользователь В(&ГруппыТекущегоПользователя)
				|";
				
				Запрос.УстановитьПараметр(("ОбъектДоступа" + ИндексСтроки), СтрокаТаблицы.ОбъектДоступа);
				Запрос.УстановитьПараметр(("ОбластьДанных" + ИндексСтроки), СтрокаТаблицы.ОбластьДанных);
			
				ИндексСтроки = ИндексСтроки + 1;
				
			КонецЦикла;
			
			ЗаписьРазрешена = Истина;
			ТекстЗапрещенияЗаписи = "";
			
			ТаблицаЗапроса = Запрос.Выполнить().Выгрузить();
			Для каждого СтрокаТаблицы Из ТаблицаРазличияЗаписей Цикл
				СтрокаТаблицыЗапроса = ТаблицаЗапроса.Найти(ТаблицаРазличияЗаписей.Индекс(СтрокаТаблицы), "ИндексСтроки");
				Если СтрокаТаблицыЗапроса = Неопределено Тогда
					ЗаписьРазрешена = Ложь;
					ТекстЗапрещенияЗаписи = Символы.ПС + ТекстЗапрещенияЗаписи + "Запрещено редактировать права доступа для объекта """ + Строка(СтрокаТаблицы.ОбъектДоступа) + """ и области данных """ + Строка(СтрокаТаблицы.ОбластьДанных) + """";
				КонецЕсли; 
			КонецЦикла; 

			Если НЕ ЗаписьРазрешена Тогда
				Отказ = Истина;
				ОбщегоНазначения.СообщитьОбОшибке((НСтр("ru='Нарушение прав доступа:';uk='Порушення прав доступу:'") + ТекстЗапрещенияЗаписи),, ШапкаОшибки);
				Возврат;
			КонецЕсли;
		КонецЕсли;
	КонецЕсли;
	
	НастройкаПравДоступа.ДополнитьНаборПравДоступаНаследуемымиЗаписями(НаборПрав);
		
	ЗаписатьНаборПрав(НаборПрав, Отказ, ШапкаОшибки);
	
КонецПроцедуры // () 

// функция по пользователю ИБ определяет есть ли у него Windows авторизация
Функция НаличиеУПользователяWindowsАвторизации(Знач ИмяПользователяИБ) Экспорт
	
	Если ПустаяСтрока(ИмяПользователяИБ) Тогда
		Возврат Ложь;
	КонецЕсли;
	
	// находим пользователя ИБ
	ПользовательИБ = ПользователиИнформационнойБазы.НайтиПоИмени(ИмяПользователяИБ);
	Если ПользовательИБ = Неопределено Тогда
		Возврат Ложь;
	КонецЕсли;
	
	Возврат ПользовательИБ.АутентификацияОС;
	
КонецФункции

Функция Категории_СуществуютСсылки(Категория) Экспорт

	Запрос = Новый Запрос();

	Запрос.Текст = 
	"ВЫБРАТЬ РАЗЛИЧНЫЕ ПЕРВЫЕ 1
	|	РегистрСведений.КатегорииОбъектов.Категория КАК Категория
	|ИЗ
	|	РегистрСведений.КатегорииОбъектов
	|
	|ГДЕ
	|	РегистрСведений.КатегорииОбъектов.Категория = &Категория
	|";

	Запрос.УстановитьПараметр("Категория", Категория);

	Возврат НЕ Запрос.Выполнить().Пустой();

КонецФункции

Функция СвойстваОбъектов_СуществуютСсылки(Свойство) Экспорт

	Запрос = Новый Запрос();

	Запрос.Текст = 
	"ВЫБРАТЬ ПЕРВЫЕ 1
	|	РегистрСведений.ЗначенияСвойствОбъектов.Свойство КАК Свойство
	|ИЗ
	|	РегистрСведений.ЗначенияСвойствОбъектов
	|
	|ГДЕ
	|	РегистрСведений.ЗначенияСвойствОбъектов.Свойство = &Свойство
	|
	|ОБЪЕДИНИТЬ ВСЕ
	|
	|ВЫБРАТЬ ПЕРВЫЕ 1
	|	РегистрСведений.НазначенияСвойствОбъектов.Свойство КАК Свойство
	|ИЗ
	|	РегистрСведений.НазначенияСвойствОбъектов
	|
	|ГДЕ
	|	РегистрСведений.НазначенияСвойствОбъектов.Свойство = &Свойство
	|";

	Запрос.УстановитьПараметр("Свойство", Свойство);

	Возврат НЕ Запрос.Выполнить().Пустой();

КонецФункции

// Функция определяет наличение движения по регистрам для документа
Функция ОпределитьНаличиеДвиженийПоРегистратору(ДокументСсылка) Экспорт
	ТекстЗапроса = "";	
	// для исключения падения для документов, проводящимся более чем по 256 таблицам
	счетчик_таблиц = 0;
	
	МетаданнныеДокумента = ДокументСсылка.Метаданные();
	
	Если МетаданнныеДокумента.Движения.Количество() = 0 Тогда
		Возврат Новый ТаблицаЗначений;
	КонецЕсли;
	
	Для Каждого Движение ИЗ МетаданнныеДокумента.Движения Цикл
		// в запросе получаем имена регистров, по которым есть хотя бы одно движение
		// например,
		// ВЫБРАТЬ Первые 1 «РегистрНакопления.ТоварыНаСкладах»
		// ИЗ РегистрНакопления.ТоварыНаСкладах
		// ГДЕ Регистратор = &Регистратор
		
		// имя регистра приводим к Строка(200), см. ниже
		ТекстЗапроса = ТекстЗапроса + "
		|" + ?(ТекстЗапроса = "", "", "ОБЪЕДИНИТЬ ВСЕ ") + "
		|ВЫБРАТЬ ПЕРВЫЕ 1 ВЫРАЗИТЬ(""" + Движение.ПолноеИмя() 
		+  """ КАК Строка(200)) КАК Имя ИЗ " + Движение.ПолноеИмя() 
		+ " ГДЕ Регистратор = &Регистратор";
		
		// если в запрос попадает более 256 таблиц – разбиваем его на две части
		// (вариант документа с проведением по 512 регистрам считаем нежизненным)
		счетчик_таблиц = счетчик_таблиц + 1;
		Если счетчик_таблиц = 256 Тогда
			Прервать;
		КонецЕсли;
		
	КонецЦикла;
	
	Запрос = Новый Запрос(ТекстЗапроса);
	ЗАпрос.УстановитьПараметр("Регистратор", ДокументСсылка);
	// при выгрузке для колонки «Имя» тип устанавливается по самой длинной строке из запроса
	// при втором проходе по таблице новое имя может не «влезть», по этому сразу в запросе
	// приводится к строка(200)
	ТаблицаЗапроса = Запрос.Выполнить().Выгрузить();
	
	// если количество таблиц не превысило 256 – возвращаем таблицу
	Если счетчик_таблиц = МетаданнныеДокумента.Движения.Количество() Тогда
		Возврат ТаблицаЗапроса;			
	КонецЕсли;
	
	// таблиц больше чем 256, делаем доп. запрос и дополняем строки таблицы.
	
	ТекстЗапроса = "";
	Для Каждого Движение ИЗ МетаданнныеДокумента.Движения Цикл
		
		Если счетчик_таблиц > 0 Тогда
			счетчик_таблиц = счетчик_таблиц - 1;
			Продолжить;
		КонецЕсли;
		
		ТекстЗапроса = ТекстЗапроса + "
		|" + ?(ТекстЗапроса = "", "", "ОБЪЕДИНИТЬ ВСЕ ") + "
		|ВЫБРАТЬ ПЕРВЫЕ 1 """ + Движение.ПолноеИмя() +  """ КАК Имя ИЗ " 
		+ Движение.ПолноеИмя() + " ГДЕ Регистратор = &Регистратор";	
		
		
	КонецЦикла;
	Запрос.Текст = ТекстЗапроса;
	Выборка = Запрос.Выполнить().Выбрать();
	Пока Выборка.Следующий() Цикл
		СтрокаТаблицы = ТаблицаЗапроса.Добавить();
		ЗаполнитьЗначенияСвойств(СтрокаТаблицы, Выборка);
	КонецЦикла;
	
	Возврат ТаблицаЗапроса;
	
КонецФункции

Процедура ЗаписатьНаборЗаписейНаСервере(ИмяРегистра, Регистратор, ТаблицаДвижений = Неопределено) Экспорт	
	
	Набор = РегистрыНакопления[ИмяРегистра].СоздатьНаборЗаписей();
	Набор.Отбор.Регистратор.Установить(Регистратор);
	Если ТаблицаДвижений <> Неопределено Тогда
		Набор.мТаблицаДвижений = ТаблицаДвижений;
		ОбщегоНазначения.ВыполнитьДвижениеПоРегистру(Набор);
	КонецЕсли;
	Набор.Записать();
	
КонецПроцедуры

Процедура ОпределитьФактИспользованияРИБ() Экспорт
	
	Запрос = Новый Запрос;
	Запрос.Текст = "ВЫБРАТЬ
	               |	Полный.Ссылка
	               |ИЗ
	               |	ПланОбмена.Полный КАК Полный
	               |ГДЕ
	               |	Полный.Ссылка <> &ЭтотУзелПолный
				   |
				   |";
				   
	Запрос.УстановитьПараметр("ЭтотУзелПолный", ПланыОбмена.Полный.ЭтотУзел());
	
	ПараметрыСеанса.ИспользованиеРИБ = НЕ Запрос.Выполнить().Пустой();
	
	ПараметрыСеанса.ПрефиксУзлаРаспределеннойИнформационнойБазы = Константы.ПрефиксУзлаРаспределеннойИнформационнойБазы.Получить();
	
КонецПроцедуры

Функция ПолучитьСписокПодчиненныхДокументов(ДокументОснование) Экспорт
		
	Запрос = Новый Запрос;
	ТекстЗапроса = "";
	
	Для Каждого ЭлементСостава ИЗ Метаданные.КритерииОтбора.СтруктураПодчиненности.Состав Цикл
		
		ПутьКДанным = ЭлементСостава.ПолноеИмя();
		СтруктураПутьКДанным = ОбщегоНазначения.РазобратьПутьКОбъектуМетаданных(ПутьКДанным);
		
		ЕСли НЕ ПравоДоступа("Чтение", СтруктураПутьКДанным.Метаданные) Тогда
			Продолжить;
		КонецЕсли;
		
		ИмяОбъекта = СтруктураПутьКДанным.ТипОбъекта + "." + СтруктураПутьКДанным.ВидОбъекта;
		
		ТекущаяСтрокаГДЕ = "ГДЕ " + СтруктураПутьКДанным.ВидОбъекта + "." +СтруктураПутьКДанным.ИмяРеквизита + " = &ЗначениеКритерияОтбора";
			
		ИмяТЧ = Лев(СтруктураПутьКДанным.ИмяРеквизита, Найти(СтруктураПутьКДанным.ИмяРеквизита, ".")-1);
		ИмяРеквизита = Лев(СтруктураПутьКДанным.ИмяРеквизита, Найти(СтруктураПутьКДанным.ИмяРеквизита, ".")-1);
		ТекстЗапроса = ТекстЗапроса + ?(ТекстЗапроса = "", "ВЫБРАТЬ РАЗРЕШЕННЫЕ", "ОБЪЕДИНИТЬ
		|ВЫБРАТЬ") + "
		|" + СтруктураПутьКДанным.ВидОбъекта +".Ссылка ИЗ " + ИмяОбъекта + "." + СтруктураПутьКДанным.ИмяТаблЧасти + " КАК " + СтруктураПутьКДанным.ВидОбъекта + "
		|" + СтрЗаменить(ТекущаяСтрокаГДЕ, "..", ".") + "
		|";
		
	КонецЦикла;
	
	Запрос.Текст = ТекстЗапроса;
	Запрос.УстановитьПараметр("ЗначениеКритерияОтбора", ДокументОснование);
	Возврат Запрос.Выполнить().Выгрузить();
	
КонецФункции

// Функция возвращает список с наборами прав, доступными пользователю.
//
// Параметры:
//  Пользователь - пользователь, для которого определяется список доступных ролей.
//
// Возвращаемое значение:
//  Список значений с доступными ролями пользователя
//
Функция ПолучитьСписокНабораПрав(Пользователь = Неопределено) Экспорт

	НаборДоступныхРолейПользователя = Новый Массив;
	
	МетаданныеНабораПрав = Метаданные.Перечисления.НаборПравПользователей.ЗначенияПеречисления;
	КоличествоНаборовПрав = Перечисления.НаборПравПользователей.Количество();
	
	Если Пользователь = ПараметрыСеанса.ТекущийПользователь ИЛИ Пользователь = Неопределено Тогда // Текущий пользователь
		Для а = 0 По КоличествоНаборовПрав-1 Цикл
			Роль = МетаданныеНабораПрав[а].Имя;
			Если Лев(Роль, 7) = "Удалить" Тогда
				Продолжить;
			КонецЕсли;
			Если РольДоступна(Роль) Тогда
				НаборДоступныхРолейПользователя.Добавить(Перечисления.НаборПравПользователей[а]);
			КонецЕсли;
		КонецЦикла;
		
	Иначе
		ПользовательИБ = ПользователиИнформационнойБазы.НайтиПоИмени(СокрЛП(Пользователь.Код));
		Если ПользовательИБ <> Неопределено Тогда
			Для а = 0 По КоличествоНаборовПрав-1 Цикл
				ИмяПеречисления = МетаданныеНабораПрав[а].Имя;
				Если Лев(ИмяПеречисления, 7) = "Удалить" Тогда
					Продолжить;
				КонецЕсли;
				Роль = Метаданные.Роли[ИмяПеречисления];
				Если ПользовательИБ.Роли.Содержит(Роль) Тогда
					НаборДоступныхРолейПользователя.Добавить(Перечисления.НаборПравПользователей[а]);
				КонецЕсли; 
			КонецЦикла;
		КонецЕсли;
	КонецЕсли; 

	Возврат НаборДоступныхРолейПользователя;

КонецФункции // ПолучитьСписокНабораПрав()

// Процедура осуществляет проверку дублей в справочнике ФизическиеЛица
// Проверка происходит по паспортным данным, ИНН, ПФР и ФИО
//
Процедура ПроверитьДублиФизлиц(Ссылка, ЗаписьПаспортныхДанных = неопределено, ИНН, ДРФО, ФИО) Экспорт	

	
	ЕстьДублиПаспортныхДанных	= Ложь;
	ЕстьДублиИНН				= Ложь;
	ЕстьДублиДРФО				= Ложь;
	
	Если ЗаписьПаспортныхДанных <> Неопределено И (
		 ЗначениеЗаполнено(ЗаписьПаспортныхДанных.ДокументВид) ИЛИ
		 ЗначениеЗаполнено(ЗаписьПаспортныхДанных.ДокументСерия) ИЛИ
		 ЗначениеЗаполнено(ЗаписьПаспортныхДанных.ДокументНомер) ИЛИ
		 ЗначениеЗаполнено(ЗаписьПаспортныхДанных.ДокументДатаВыдачи)) Тогда
		
		ЗапросПоДублям = Новый Запрос;
		
		ЗапросПоДублям.УстановитьПараметр("Ссылка",						Ссылка);
		ЗапросПоДублям.УстановитьПараметр("ДокументВид",				ЗаписьПаспортныхДанных.ДокументВид);
		ЗапросПоДублям.УстановитьПараметр("ДокументСерия",				ЗаписьПаспортныхДанных.ДокументСерия);
		ЗапросПоДублям.УстановитьПараметр("ДокументНомер",				ЗаписьПаспортныхДанных.ДокументНомер);
		ЗапросПоДублям.УстановитьПараметр("ДокументДатаВыдачи",			ЗаписьПаспортныхДанных.ДокументДатаВыдачи);
		
		ЗапросПоДублям.Текст =
		"ВЫБРАТЬ РАЗЛИЧНЫЕ
		|	ПаспортныеДанныеФизЛиц.ФизЛицо
		|ИЗ
		|	РегистрСведений.ПаспортныеДанныеФизЛиц КАК ПаспортныеДанныеФизЛиц
		|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ РегистрСведений.ПаспортныеДанныеФизЛиц КАК ПаспортныеДанныеФизЛиц1
		|		ПО (ПаспортныеДанныеФизЛиц.ДокументВид = &ДокументВид)
		|			И (ПаспортныеДанныеФизЛиц.ДокументСерия = &ДокументСерия)
		|			И (ПаспортныеДанныеФизЛиц.ДокументНомер = &ДокументНомер)
		|			И (ПаспортныеДанныеФизЛиц.ДокументДатаВыдачи = &ДокументДатаВыдачи)
		|ГДЕ
		|	ПаспортныеДанныеФизЛиц.ФизЛицо <> &Ссылка";
		
		ВыборкаЗапроса = ЗапросПоДублям.Выполнить().Выбрать();
		
		Пока ВыборкаЗапроса.Следующий() Цикл
			
			Сообщить(НСтр("ru='Физлицо: ';uk='Фізособа: '") + ВыборкаЗапроса.Физлицо +" имеет такие же паспортные данные как и у "+Строка(Ссылка));
			ЕстьДублиПаспортныхДанных = Истина;
			
		КонецЦикла;
		
	КонецЕсли;
	
	Если ЗначениеЗаполнено(ИНН) Тогда
		ЗапросПоДублям = Новый Запрос;
		
		ЗапросПоДублям.УстановитьПараметр("Ссылка",	Ссылка);
		ЗапросПоДублям.УстановитьПараметр("ИНН",	ИНН);
		
		ЗапросПоДублям.Текст =
		"ВЫБРАТЬ РАЗЛИЧНЫЕ
		|	ФизическиеЛица.Ссылка КАК Физлицо
		|ИЗ
		|	Справочник.ФизическиеЛица КАК ФизическиеЛица
		|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ Справочник.ФизическиеЛица КАК ФизическиеЛица1
		|		ПО (ФизическиеЛица.ИНН = &ИНН)
		|ГДЕ
		|	ФизическиеЛица.Ссылка <> &Ссылка";
		
		ВыборкаЗапроса = ЗапросПоДублям.Выполнить().Выбрать();
		
		Пока ВыборкаЗапроса.Следующий() Цикл
			
			Сообщить(НСтр("ru='Физлицо: ';uk='Фізособа: '") + ВыборкаЗапроса.Физлицо +" имеет такой же ИНН как и у "+Строка(Ссылка));
			ЕстьДублиИНН = Истина;
			
		КонецЦикла;
		
	КонецЕсли;
	
	
	Если ЗначениеЗаполнено(ДРФО) тогда
		
		ТекстЗапроса = 
		"ВЫБРАТЬ РАЗЛИЧНЫЕ
		|	ФизическиеЛица.Ссылка КАК Физлицо
		|ИЗ
		|	Справочник.ФизическиеЛица КАК ФизическиеЛица
		|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ Справочник.ФизическиеЛица КАК ФизическиеЛица1
		|		ПО (ФизическиеЛица.КодПоДРФО = &ДРФО)
		|ГДЕ
		|	ФизическиеЛица.Ссылка <> &Ссылка";
		
		ЗапросПоДублям 	= Новый Запрос(ТекстЗапроса);
		ЗапросПоДублям.УстановитьПараметр("Ссылка", 				Ссылка);
		ЗапросПоДублям.УстановитьПараметр("ДРФО", 					ДРФО);
		РезультатЗапросаПоДублям 	= ЗапросПоДублям.Выполнить();
		ВыборкаЗапроса 				= РезультатЗапросаПоДублям.Выбрать();
		Пока ВыборкаЗапроса.Следующий() Цикл
			Сообщить(НСтр("ru='Физлицо: ';uk='Фізособа: '") + ВыборкаЗапроса.Физлицо +" имеет такой же код ДРФО как и у "+Строка(Ссылка));
			ЕстьДублиДРФО = Истина;
		КонецЦикла;
	КонецЕсли;
	
	Если ЗначениеЗаполнено(ФИО) И
		 НЕ ЕстьДублиИНН И
		 НЕ ЕстьДублиПаспортныхДанных И
		 НЕ ЕстьДублиДРФО Тогда
		 
		ЗапросПоДублям = Новый Запрос;
		
		ЗапросПоДублям.УстановитьПараметр("Ссылка",	Ссылка);
		ЗапросПоДублям.УстановитьПараметр("ФИО",	СтрЗаменить(ФИО, " ", ""));
		
		ЗапросПоДублям.Текст =
		"ВЫБРАТЬ РАЗЛИЧНЫЕ
		|	ФИОФизЛиц.ФизЛицо
		|ИЗ
		|	РегистрСведений.ФИОФизЛиц КАК ФИОФизЛиц
		|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ РегистрСведений.ФИОФизЛиц КАК ФИОФизЛиц1
		|		ПО (ФИОФизЛиц.Фамилия + ФИОФизЛиц.Имя + ФИОФизЛиц.Отчество = &ФИО)
		|ГДЕ
		|	ФИОФизЛиц.ФизЛицо <> &Ссылка";
		
		ВыборкаЗапроса 				= ЗапросПоДублям.Выполнить().Выбрать();
		
		Пока ВыборкаЗапроса.Следующий() Цикл
			
			Сообщить(НСтр("ru='Физлицо с таким ФИО (';uk='Фізособа з таким ПІБ ('") + ВыборкаЗапроса.Физлицо +НСтр("ru=') уже есть в справочнике';uk=') уже є в довіднику'"));
			ЕстьДублиПаспортныхДанных = Истина;
			
		КонецЦикла;
		
	КонецЕсли;
	
КонецПроцедуры

// ПРОЦЕДУРЫ ДЛЯ ЗАПИСИ ТЕКУЩИХ КАДРОВЫХ ДАННЫХ СОТРУДНИКА КОМПАНИИ

Процедура УстановитьРеквизитыИЗаписатьСотрудника(Выборка, Отказ)

	Пока Выборка.Следующий() Цикл
		
		СотрудникОбъект = Выборка.Сотрудник.ПолучитьОбъект();
		
		Если СотрудникОбъект = Неопределено Тогда
			Возврат;
		КонецЕсли;
		
		СотрудникОбъект.ТекущееПодразделениеКомпании	= Выборка.Подразделение;
		СотрудникОбъект.ТекущаяДолжностьКомпании		= Выборка.Должность;
		СотрудникОбъект.ДатаПриемаНаРаботуВКомпанию		= Выборка.ДатаПриемаНаРаботу;
		СотрудникОбъект.ДатаУвольненияИзКомпании		= Выборка.ДатаУвольнения;
		
		Попытка	
			СотрудникОбъект.Заблокировать();
		Исключение
			ОбщегоНазначения.СообщитьОбОшибке(ОбщегоНазначения.ПолучитьПричинуОшибки(ИнформацияОбОшибке()).Описание);
			Отказ = Истина;
			Возврат;
		КонецПопытки;
		СотрудникОбъект.Записать();
		
	КонецЦикла;

КонецПроцедуры

// В процедуре всем сотрудникам, которые есть в документе регистраторе,
// устанавливаются текущие кадровые данные
// Перед записью данных необходимо отобрать данные без учета регистратора
// При записи данных необходимо отбирать данные с учетом регистратора
//
Процедура ЗаписатьТекущиеКадровыеДанныеСотрудника(Отказ, Замещение, БезРегистратора, ОбменДаннымиЗагрузка, Регистратор) Экспорт
	
	Если ОбменДаннымиЗагрузка Тогда
		Возврат;
	КонецЕсли;
	
	Запрос = Новый Запрос;
	Запрос.МенеджерВременныхТаблиц = Новый МенеджерВременныхТаблиц;
	
	Запрос.УстановитьПараметр("Регистратор", Регистратор);
	
	Запрос.Текст =
	"ВЫБРАТЬ РАЗЛИЧНЫЕ
	|	Работники.ФизЛицо КАК Физлицо
	|ПОМЕСТИТЬ ВТФизлица
	|ИЗ
	|	РегистрСведений.Работники КАК Работники
	|ГДЕ
	|	Работники.Регистратор = &Регистратор
	|
	|ИНДЕКСИРОВАТЬ ПО
	|	Физлицо
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	СотрудникиОрганизаций.Ссылка КАК Сотрудник,
	|	СотрудникиОрганизаций.Физлицо КАК Физлицо
	|ПОМЕСТИТЬ ВТСотрудники
	|ИЗ
	|	Справочник.СотрудникиОрганизаций КАК СотрудникиОрганизаций
	|ГДЕ
	|	(НЕ СотрудникиОрганизаций.ВидДоговора В (ЗНАЧЕНИЕ(Перечисление.ВидыДоговоровСФизЛицами.Подряда), ЗНАЧЕНИЕ(Перечисление.ВидыДоговоровСФизЛицами.Авторский)))
	|	И СотрудникиОрганизаций.Физлицо В
	|			(ВЫБРАТЬ
	|				Физлица.Физлицо
	|			ИЗ
	|				ВТФизлица КАК Физлица)
	|
	|ИНДЕКСИРОВАТЬ ПО
	|	Сотрудник,
	|	Физлицо
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	Сотрудники.Сотрудник,
	|	Сотрудники.Сотрудник.Физлицо КАК Физлицо,
	|	РаботникиСрезПоследних.Подразделение КАК Подразделение,
	|	РаботникиСрезПоследних.Должность КАК Должность,
	|	ЕСТЬNULL(РаботникиПрием.Период, ДАТАВРЕМЯ(1, 1, 1)) КАК ДатаПриемаНаРаботу,
	|	ВЫБОР
	|		КОГДА ЕСТЬNULL(РаботникиУвольнение.Период, ДАТАВРЕМЯ(1, 1, 1)) = ДАТАВРЕМЯ(1, 1, 1)
	|			ТОГДА ДАТАВРЕМЯ(1, 1, 1)
	|		ИНАЧЕ ДОБАВИТЬКДАТЕ(РаботникиУвольнение.Период, ДЕНЬ, -1)
	|	КОНЕЦ КАК ДатаУвольнения
	|ИЗ
	|	ВТСотрудники КАК Сотрудники
	|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.Работники.СрезПоследних(
	|				,
	|				Физлицо В
	|						(ВЫБРАТЬ
	|							Физлица.Физлицо
	|						ИЗ
	|							ВТФизлица КАК Физлица)
	|					" + ?(БезРегистратора, "И Регистратор <> &Регистратор", "") + ") КАК РаботникиСрезПоследних
	|		ПО Сотрудники.Физлицо = РаботникиСрезПоследних.ФизЛицо
	|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.Работники КАК РаботникиПрием
	|		ПО Сотрудники.Физлицо = РаботникиПрием.ФизЛицо
	|			И (РаботникиПрием.ПричинаИзмененияСостояния = ЗНАЧЕНИЕ(Перечисление.ПричиныИзмененияСостояния.ПриемНаРаботу))
	|			" + ?(БезРегистратора, "И (РаботникиПрием.Регистратор <> &Регистратор)", "") + "
	|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.Работники КАК РаботникиУвольнение
	|		ПО Сотрудники.Физлицо = РаботникиУвольнение.ФизЛицо
	|			И (РаботникиУвольнение.ПричинаИзмененияСостояния = ЗНАЧЕНИЕ(Перечисление.ПричиныИзмененияСостояния.Увольнение))
	|			" + ?(БезРегистратора, "И (РаботникиУвольнение.Регистратор <> &Регистратор)", "") + "
	|ГДЕ
	|	(Сотрудники.Сотрудник.ТекущееПодразделениеКомпании <> ЕСТЬNULL(РаботникиСрезПоследних.Подразделение, ЗНАЧЕНИЕ(Справочник.Подразделения.ПустаяСсылка))
	|			ИЛИ Сотрудники.Сотрудник.ТекущаяДолжностьКомпании <> ЕСТЬNULL(РаботникиСрезПоследних.Должность, ЗНАЧЕНИЕ(Справочник.ДолжностиОрганизаций.ПустаяСсылка))
	|			ИЛИ Сотрудники.Сотрудник.ДатаПриемаНаРаботуВКомпанию <> ЕСТЬNULL(РаботникиПрием.Период, ДАТАВРЕМЯ(1, 1, 1))
	|			ИЛИ Сотрудники.Сотрудник.ДатаУвольненияИзКомпании <> ЕСТЬNULL(РаботникиУвольнение.Период, ДАТАВРЕМЯ(1, 1, 1)))";
	
	Выборка = Запрос.Выполнить().Выбрать();
	
	УстановитьРеквизитыИЗаписатьСотрудника(Выборка, Отказ);
	
КонецПроцедуры
