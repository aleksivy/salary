
Перем мВозможностьИзменятьМетаданные Экспорт;
Перем мЗаписыватьДанныеЗаданияПриОК Экспорт;

Процедура ПриОткрытии()
	
	Для Каждого Метаданное из Метаданные.РегламентныеЗадания Цикл
		ЭлементыФормы.МетаданныеВыбор.СписокВыбора.Добавить(Метаданное.Имя, Метаданное.Представление());
	КонецЦикла;
	
	Попытка
		Пользователи = ПользователиИнформационнойБазы.ПолучитьПользователей();
	Исключение
		Сообщить(НСтр("ru='Ошибка при получении списка пользователей информационной базы: ';uk='Помилка при одержанні списку користувачів інформаційної бази: '") + ОписаниеОшибки());
		Пользователи = Неопределено;
	КонецПопытки;
	
	Если Пользователи <> Неопределено Тогда
		
	    Для Каждого Пользователь из Пользователи Цикл
			ЭлементыФормы.ПользователиВыбор.СписокВыбора.Добавить(Пользователь.Имя, Пользователь.ПолноеИмя);
		КонецЦикла;
	
	КонецЕсли;

	Если РегламентноеЗадание <> Неопределено Тогда
		
		МетаданныеВыбор = РегламентноеЗадание.Метаданные.Имя;
		мВозможностьИзменятьМетаданные = Ложь;
		Наименование = РегламентноеЗадание.Наименование;
		Ключ = РегламентноеЗадание.Ключ;
		Использование = РегламентноеЗадание.Использование;
		ПользователиВыбор = РегламентноеЗадание.ИмяПользователя;
		КоличествоПовторовПриАварийномЗавершении = РегламентноеЗадание.КоличествоПовторовПриАварийномЗавершении;
		ИнтервалПовтораПриАварийномЗавершении = РегламентноеЗадание.ИнтервалПовтораПриАварийномЗавершении;
		Расписание = РегламентноеЗадание.Расписание;
		
	Иначе
		
		Расписание = Новый РасписаниеРегламентногоЗадания;
		
	КонецЕсли;
	
	ЭлементыФормы.МетаданныеВыбор.Доступность = мВозможностьИзменятьМетаданные;
	
	ЭлементыФормы.НадписьРассписание.Заголовок = "Выполнять: " + Строка(Расписание);
	
КонецПроцедуры

Процедура РасписаниеНажатие(Элемент)
	
	Диалог = Новый ДиалогРасписанияРегламентногоЗадания(Расписание);
		
	Если Диалог.ОткрытьМодально() Тогда
		Расписание = Диалог.Расписание;
	КонецЕсли;
	
	ЭлементыФормы.НадписьРассписание.Заголовок = "Выполнять: " + Строка(Расписание);
	
КонецПроцедуры

Процедура OK(Кнопка)
	
	Попытка
		
		Если МетаданныеВыбор = Неопределено Тогда
			ВызватьИсключение("Не выбраны метаданные регламентного задания.");
		КонецЕсли;
		
		Если РегламентноеЗадание = Неопределено Тогда
			РегламентноеЗадание = РегламентныеЗадания.СоздатьРегламентноеЗадание(МетаданныеВыбор);
		КонецЕсли;
		
		РегламентноеЗадание.Наименование = Наименование;
		РегламентноеЗадание.Ключ = Ключ;
		РегламентноеЗадание.Использование = Использование;
		РегламентноеЗадание.ИмяПользователя = ПользователиВыбор;
		РегламентноеЗадание.КоличествоПовторовПриАварийномЗавершении = КоличествоПовторовПриАварийномЗавершении;
		РегламентноеЗадание.ИнтервалПовтораПриАварийномЗавершении = ИнтервалПовтораПриАварийномЗавершении;
		РегламентноеЗадание.Расписание = Расписание;
		
		РегламентноеЗадание.Записать();
		
		Закрыть(Истина);
		
	Исключение	
		
		ПоказатьИнформациюОбОшибке(ИнформацияОбОшибке());
		
	КонецПопытки;
	
КонецПроцедуры

мВозможностьИзменятьМетаданные = Истина;
мЗаписыватьДанныеЗаданияПриОК = Истина;
