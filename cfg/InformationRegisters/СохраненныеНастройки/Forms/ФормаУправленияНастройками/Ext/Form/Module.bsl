﻿Перем мСтруктураНастройки Экспорт;
Перем мВосстановлениеНастройки Экспорт;
Перем мНаименованиеТекущейНастройки;
Перем мНаименованиеСкопированнойНастройки;

Процедура ПередОткрытием(Отказ, СтандартнаяОбработка)
	
	Если ТипЗнч(мСтруктураНастройки) <> Тип("Структура") Тогда
			
		Предупреждение(НСтр("ru='Не заполнена структура настроек.';uk='Не заповнена структура настройок.'"));
		Отказ = Истина;
		Возврат;
			
	КонецЕсли;
		
	Если мСтруктураНастройки.Свойство("ИмяОбъекта") = Ложь ИЛИ ПустаяСтрока(мСтруктураНастройки.ИмяОбъекта) Тогда
			
		Предупреждение(НСтр("ru='Не заполнено имя объекта в структуре настроек.';uk=""Не заповнене ім'я об'єкта в структурі настройок."""));
		Отказ = Истина;
		Возврат;
			
	КонецЕсли;

КонецПроцедуры // ПередОткрытием()

Процедура ПриОткрытии()
	
	ЗаполнитьНастройки();
	УправлениеОтображениемФормы();

КонецПроцедуры // ПриОткрытии()

Процедура КоманднаяПанельФормыДействиеВыбрать(Кнопка)
		
	Если мВосстановлениеНастройки Тогда
		
		Если ЭлементыФормы.ТабличноеПолеСписокНастроек.ТекущаяСтрока = Неопределено Тогда
				
			Предупреждение(НСтр("ru='Не выбрана восстанавливаемая настройка.';uk='Не обрана відновлювана настройка.'"));
			Возврат;
				
		КонецЕсли;
		
		СтруктураНастройки = Новый Структура;
		СтруктураНастройки.Вставить("Пользователь", ЭлементыФормы.ТабличноеПолеСписокНастроек.ТекущиеДанные.Пользователь);
		СтруктураНастройки.Вставить("ИмяОбъекта", мСтруктураНастройки.ИмяОбъекта);
		СтруктураНастройки.Вставить("НаименованиеНастройки", ЭлементыФормы.ТабличноеПолеСписокНастроек.ТекущиеДанные.НаименованиеНастройки);
		
		Если УниверсальныеМеханизмы.ПолучитьНастройку(СтруктураНастройки) Тогда
			
			Закрыть(СтруктураНастройки);
			
		Иначе
			
			Закрыть();
			
		КонецЕсли;
		
	Иначе
		
		Если ЭлементыФормы.ТабличноеПолеСписокНастроек.ТекущаяСтрока = Неопределено Тогда
				
			Предупреждение(НСтр("ru='Не выбрана сохраняемая настройка.';uk='Не обране настройка, що зберігається.'"));
			Возврат;
				
		КонецЕсли;
		
		СтруктураНастройки = Новый Структура;
		СтруктураНастройки.Вставить("Пользователь", ЭлементыФормы.ТабличноеПолеСписокНастроек.ТекущиеДанные.Пользователь);
		СтруктураНастройки.Вставить("ИмяОбъекта", мСтруктураНастройки.ИмяОбъекта);
		СтруктураНастройки.Вставить("НаименованиеНастройки", ЭлементыФормы.ТабличноеПолеСписокНастроек.ТекущиеДанные.НаименованиеНастройки);
		СтруктураНастройки.Вставить("СохраненнаяНастройка", мСтруктураНастройки.СохраненнаяНастройка);
		СтруктураНастройки.Вставить("ИспользоватьПриОткрытии", ЭлементыФормы.ТабличноеПолеСписокНастроек.ТекущиеДанные.ИспользоватьПриОткрытии);
		СтруктураНастройки.Вставить("СохранятьАвтоматически", ЭлементыФормы.ТабличноеПолеСписокНастроек.ТекущиеДанные.СохранятьАвтоматически);
		
		Если УниверсальныеМеханизмы.СохранитьНастройку(СтруктураНастройки) Тогда
			
			Закрыть(СтруктураНастройки);
			
		Иначе
			
			Закрыть();
			
		КонецЕсли;
		
	КонецЕсли;

КонецПроцедуры // КоманднаяПанельФормыДействиеВыбрать()

Процедура КоманднаяПанельФормыДействиеНастройкиВсехПользователей(Кнопка)
	
	НастройкиВсехПользователей = НЕ НастройкиВсехПользователей;
	ЭлементыФормы.КоманднаяПанельФормы.Кнопки.ДействиеНастройкиВсехПользователей.Пометка = НастройкиВсехПользователей;
	
	ЗаполнитьНастройки();

КонецПроцедуры // КоманднаяПанельФормыДействиеНастройкиВсехПользователей()

Процедура УправлениеОтображениемФормы()
	
	Если мВосстановлениеНастройки = Истина Тогда
		
		Заголовок = НСтр("ru='Восстановление настройки';uk='Відновлення настройки'");
		ЭлементыФормы.КоманднаяПанельФормы.Кнопки.Удалить(ЭлементыФормы.КоманднаяПанельФормы.Кнопки.ДействиеДобавить);
		ЭлементыФормы.КоманднаяПанельФормы.Кнопки.Удалить(ЭлементыФормы.КоманднаяПанельФормы.Кнопки.ДействиеСкопировать);
		ЭлементыФормы.КоманднаяПанельФормы.Кнопки.Удалить(ЭлементыФормы.КоманднаяПанельФормы.Кнопки.ДействиеИзменить);
		ЭлементыФормы.КоманднаяПанельФормы.Кнопки.Удалить(ЭлементыФормы.КоманднаяПанельФормы.Кнопки.ДействиеУдалить);
		ЭлементыФормы.КоманднаяПанельФормы.Кнопки.Удалить(ЭлементыФормы.КоманднаяПанельФормы.Кнопки.ДействиеЗакончитьРедактирование);
		ЭлементыФормы.ТабличноеПолеСписокНастроек.ТолькоПросмотр = Истина;
		ЭлементыФормы.КоманднаяПанельФормы.Кнопки.ДействиеНастройкиВсехПользователей.Пометка = НастройкиВсехПользователей;
		
	Иначе
		
		Заголовок = НСтр("ru='Сохранение настройки';uk='Збереження настройки'");
		ЭлементыФормы.КоманднаяПанельФормы.Кнопки.Удалить(ЭлементыФормы.КоманднаяПанельФормы.Кнопки.ДействиеНастройкиВсехПользователей);
		
	КонецЕсли;
	
КонецПроцедуры // УправлениеОтображениемФормы()

Функция ПолучитьНовоеНаименованиеНастройки(Наименование)
	
	Результат = Наименование;
	
	Индекс = 0;
	
	Пока СписокНастроек.Найти(Результат, "НаименованиеНастройки") <> Неопределено Цикл
		
		Индекс = Индекс + 1;
		Результат = Наименование + " " + Формат(Индекс, "ЧГ=0");
		
	КонецЦикла;
	
	Возврат Результат;
	
КонецФункции // ПолучитьНовоеНаименованиеНастройки()

Процедура ТабличноеПолеСписокНастроекПриПолученииДанных(Элемент, ОформленияСтрок)
	
	Для каждого ОформлениеСтроки из ОформленияСтрок Цикл
		
		Если ОформлениеСтроки.ДанныеСтроки <> Неопределено И ОформлениеСтроки.ДанныеСтроки.ИспользоватьПриОткрытии <> Неопределено Тогда
		
			Если ОформлениеСтроки.ДанныеСтроки.ИспользоватьПриОткрытии Тогда
			
				ОформлениеСтроки.Шрифт = Новый Шрифт(ОформлениеСтроки.Шрифт,,, Истина);
			
			КонецЕсли;
		
		КонецЕсли;
		
	КонецЦикла;

КонецПроцедуры

Процедура ТабличноеПолеСписокНастроекПриНачалеРедактирования(Элемент, НоваяСтрока, Копирование)
	
	Если НоваяСтрока Тогда
		
		Если Копирование Тогда
			
			мНаименованиеСкопированнойНастройки = Элемент.ТекущиеДанные.НаименованиеНастройки;
			Элемент.ТекущиеДанные.НаименованиеНастройки = ПолучитьНовоеНаименованиеНастройки(Элемент.ТекущиеДанные.НаименованиеНастройки);
			Элемент.ТекущиеДанные.ИспользоватьПриОткрытии = Ложь;
			
		Иначе
			
			Элемент.ТекущиеДанные.НаименованиеНастройки = ПолучитьНовоеНаименованиеНастройки("Основная");
			
			Если мСтруктураНастройки.Свойство("Пользователь") = Ложь ИЛИ НЕ ЗначениеЗаполнено(мСтруктураНастройки.Пользователь) Тогда
				
				Элемент.ТекущиеДанные.Пользователь = глЗначениеПеременной("глТекущийПользователь");
					
			Иначе
					
				Элемент.ТекущиеДанные.Пользователь = мСтруктураНастройки.Пользователь;
				
			КонецЕсли;
			
			Элемент.ТекущиеДанные.ИспользоватьПриОткрытии = Ложь;
			Элемент.ТекущиеДанные.СохранятьАвтоматически = Ложь;
			
		КонецЕсли;
		
	Иначе
		
		мНаименованиеТекущейНастройки = Элемент.ТекущиеДанные.НаименованиеНастройки;
		
	КонецЕсли;
	
КонецПроцедуры // ТабличноеПолеСписокНастроекПриНачалеРедактирования()

Процедура ТабличноеПолеСписокНастроекПередОкончаниемРедактирования(Элемент, НоваяСтрока, ОтменаРедактирования, Отказ)
	
	Если ОтменаРедактирования Тогда
		
		Возврат;
		
	КонецЕсли;
	
	Если ПустаяСтрока(Элемент.ТекущиеДанные.НаименованиеНастройки) Тогда
		
		Отказ = Истина;
		Возврат;
		
	КонецЕсли;
	
	Если СписокНастроек.НайтиСтроки(Новый Структура("НаименованиеНастройки", Элемент.ТекущиеДанные.НаименованиеНастройки)).Количество() > 1 Тогда
		
		Предупреждение(НСтр("ru='Настройка с таким наименованием уже существует. Укажите уникальное наименование настройки.';uk='Настройка з таким найменуванням уже існує. Укажіть унікальне найменування настройки.'"));
		Отказ = Истина;
		Возврат;
		
	КонецЕсли;
	
	СтруктураНастройки = Новый Структура;
	СтруктураНастройки.Вставить("Пользователь", Элемент.ТекущиеДанные.Пользователь);
	СтруктураНастройки.Вставить("ИмяОбъекта", мСтруктураНастройки.ИмяОбъекта);
	СтруктураНастройки.Вставить("НаименованиеНастройки", Элемент.ТекущиеДанные.НаименованиеНастройки);
	СтруктураНастройки.Вставить("СохраненнаяНастройка", мСтруктураНастройки.СохраненнаяНастройка);
	СтруктураНастройки.Вставить("ИспользоватьПриОткрытии", Элемент.ТекущиеДанные.ИспользоватьПриОткрытии);
	СтруктураНастройки.Вставить("СохранятьАвтоматически", Элемент.ТекущиеДанные.СохранятьАвтоматически);
	
	Если НоваяСтрока Тогда
		
		СтруктураСкопированнойНастройки = Новый Структура;
		
		СтруктураСкопированнойНастройки.Вставить("Пользователь", Элемент.ТекущиеДанные.Пользователь);
		СтруктураСкопированнойНастройки.Вставить("ИмяОбъекта", мСтруктураНастройки.ИмяОбъекта);
		СтруктураСкопированнойНастройки.Вставить("НаименованиеНастройки", мНаименованиеСкопированнойНастройки);
		
		Если УниверсальныеМеханизмы.ПолучитьНастройку(СтруктураСкопированнойНастройки) Тогда
			
			СтруктураСкопированнойНастройки.НаименованиеНастройки = СтруктураНастройки.НаименованиеНастройки;
			СтруктураСкопированнойНастройки.ИспользоватьПриОткрытии = СтруктураНастройки.ИспользоватьПриОткрытии;
			СтруктураСкопированнойНастройки.СохранятьАвтоматически = СтруктураНастройки.СохранятьАвтоматически;
			
			УниверсальныеМеханизмы.СохранитьНастройку(СтруктураСкопированнойНастройки);
			
		Иначе	
			
			УниверсальныеМеханизмы.СохранитьНастройку(СтруктураНастройки);
			
		КонецЕсли;
		
	Иначе
		
		СтруктураЗаменяемойНастройки = Новый Структура;
		
		СтруктураЗаменяемойНастройки.Вставить("Пользователь", Элемент.ТекущиеДанные.Пользователь);
		СтруктураЗаменяемойНастройки.Вставить("ИмяОбъекта", мСтруктураНастройки.ИмяОбъекта);
		СтруктураЗаменяемойНастройки.Вставить("НаименованиеНастройки", мНаименованиеТекущейНастройки);
		
		Если УниверсальныеМеханизмы.СохранитьНастройку(СтруктураНастройки, СтруктураЗаменяемойНастройки) Тогда
		
			Если мСтруктураНастройки.НаименованиеНастройки = мНаименованиеТекущейНастройки Тогда
				
				мСтруктураНастройки.НаименованиеНастройки = СтруктураНастройки.НаименованиеНастройки;
				
			КонецЕсли;
			
		КонецЕсли;
		
	КонецЕсли;
	
	мНаименованиеТекущейНастройки = Неопределено;
	мНаименованиеСкопированнойНастройки = Неопределено;
	
КонецПроцедуры // ТабличноеПолеСписокНастроекПередОкончаниемРедактирования()

Процедура ТабличноеПолеСписокНастроекПередУдалением(Элемент, Отказ)
	
	Если ЭлементыФормы.ТабличноеПолеСписокНастроек.ТекущаяСтрока = Неопределено Тогда
			
		Предупреждение(НСтр("ru='Не выбрана сохраняемая настройка.';uk='Не обране настройка, що зберігається.'"));
		Возврат;
			
	КонецЕсли;
		
	СтруктураНастройки = Новый Структура;
	СтруктураНастройки.Вставить("Пользователь", ЭлементыФормы.ТабличноеПолеСписокНастроек.ТекущиеДанные.Пользователь);
	СтруктураНастройки.Вставить("ИмяОбъекта", мСтруктураНастройки.ИмяОбъекта);
	СтруктураНастройки.Вставить("НаименованиеНастройки", ЭлементыФормы.ТабличноеПолеСписокНастроек.ТекущиеДанные.НаименованиеНастройки);
	
	Если УниверсальныеМеханизмы.УдалитьНастройку(СтруктураНастройки) Тогда
		
		Если мСтруктураНастройки.НаименованиеНастройки = ЭлементыФормы.ТабличноеПолеСписокНастроек.ТекущиеДанные.НаименованиеНастройки Тогда
			
			мСтруктураНастройки.НаименованиеНастройки = Неопределено;
			
		КонецЕсли;
		
	КонецЕсли;
	
КонецПроцедуры // ТабличноеПолеСписокНастроекПередУдалением()

Процедура ТабличноеПолеСписокНастроекПриИзмененииФлажка(Элемент, Колонка)
	
	Если Колонка.Имя = "ИспользоватьПриОткрытии" Тогда
		
		Если Элемент.ТекущиеДанные.ИспользоватьПриОткрытии Тогда
			
			Для каждого Настройка из СписокНастроек Цикл
				
				Если Настройка.НаименованиеНастройки <> Элемент.ТекущиеДанные.НаименованиеНастройки Тогда
					
					Настройка.ИспользоватьПриОткрытии = Ложь;
					
				КонецЕсли;
				
				Если мСтруктураНастройки.НаименованиеНастройки = Настройка.НаименованиеНастройки Тогда
					
					мСтруктураНастройки.ИспользоватьПриОткрытии = Настройка.ИспользоватьПриОткрытии;
					
				КонецЕсли;
				
			КонецЦикла;
			
		КонецЕсли;
		
	ИначеЕсли Колонка.Имя = "СохранятьАвтоматически" Тогда
		
		Если мСтруктураНастройки.НаименованиеНастройки = Элемент.ТекущиеДанные.НаименованиеНастройки Тогда
					
			мСтруктураНастройки.СохранятьАвтоматически = Элемент.ТекущиеДанные.СохранятьАвтоматически;
					
		КонецЕсли;
		
	КонецЕсли;
	
КонецПроцедуры

Процедура ТабличноеПолеСписокНастроекВыбор(Элемент, ВыбраннаяСтрока, Колонка, СтандартнаяОбработка)
	
	КоманднаяПанельФормыДействиеВыбрать(ЭлементыФормы.КоманднаяПанельФормы.Кнопки.ДействиеВыбрать);
	
КонецПроцедуры // ТабличноеПолеСписокНастроекВыбор()

Процедура ЗаполнитьНастройки()
	
	СтруктураНастройки = Новый Структура;
		
	Если мСтруктураНастройки.Свойство("Пользователь") = Ложь ИЛИ НЕ ЗначениеЗаполнено(мСтруктураНастройки.Пользователь) Тогда
					
		СтруктураНастройки.Вставить("Пользователь", глЗначениеПеременной("глТекущийПользователь"));
					
	Иначе
					
		СтруктураНастройки.Вставить("Пользователь", мСтруктураНастройки.Пользователь);
					
	КонецЕсли;
		
	СтруктураНастройки.Вставить("ИмяОбъекта", мСтруктураНастройки.ИмяОбъекта);
	
	СписокНастроек = УниверсальныеМеханизмы.ПолучитьНастройки(СтруктураНастройки, НастройкиВсехПользователей, мВосстановлениеНастройки, мВосстановлениеНастройки);
	
	НайденнаяСтрока = СписокНастроек.Найти(мСтруктураНастройки.НаименованиеНастройки, "НаименованиеНастройки");
	
	Если НайденнаяСтрока <> Неопределено Тогда
		
		ЭлементыФормы.ТабличноеПолеСписокНастроек.ТекущаяСтрока = НайденнаяСтрока;
		
	КонецЕсли;

КонецПроцедуры // ЗаполнитьНастройки()

мВосстановлениеНастройки = Ложь;
