
////////////////////////////////////////////////////////////////////////////////
// ПРОЦЕДУРЫ - ОБРАБОТЧИКИ СОБЫТИЙ ФОРМЫ

// Процедура - обработчик события "ПриОткрытии" формы
// проверяет записи в регистре оценок.
Процедура ПриОткрытии()
	
	Запрос = новый Запрос;
	
	Запрос.Текст = ("ВЫБРАТЬ ПЕРВЫЕ 1
	                |	ОценкиКомпетенцийРаботников.Регистратор
	                |ИЗ
	                |	РегистрСведений.ОценкиКомпетенцийРаботников КАК ОценкиКомпетенцийРаботников
	                |
	                |ГДЕ
	                |	ОценкиКомпетенцийРаботников.Компетенция = &Компетенция");
	
	
	Запрос.УстановитьПараметр("Компетенция", Ссылка);
	
	ВыборкаРегистраторов = Запрос.Выполнить().Выбрать();
	
	Если ВыборкаРегистраторов.Следующий() Тогда
		ЭлементыФормы.ШкалаОценок.ТолькоПросмотр = Истина;
		ЭлементыФормы.ШкалаОценок.Подсказка = НСтр("ru='Для изменения шкалы оценок необходимо отменить проведение всех аттестаций работников, содержащих эту компетенцию';uk='Для зміни шкали оцінок необхідно відмінити проведення всіх атестацій працівників, які містять цю компетенцію'");
	КонецЕсли;
	
КонецПроцедуры

// Процедура - обработчик события "ПриЗаписи" формы
// проверяет заполнение основных реквизитов перед записью.
Процедура ПриЗаписи(Отказ)

	ОбщийВес = ОписаниеОценок.Итог("ВесОценки");
	Если  ОбщийВес <> 100 И ОбщийВес > 0 Тогда
		ОтветНаВопрос = Вопрос(НСтр("ru='Сумма ожидаемых долей оценок не равна 100% (равна ';uk='Сума очікуваних часток оцінок не дорівнює 100% (дорівнює '") + ОбщийВес + " %)." + Символы.ПС + НСтр("ru='Сохранить компетенцию?';uk='Зберегти компетенцію?'"), РежимДиалогаВопрос.ОКОтмена, , КодВозвратаДиалога.Отмена);
	    Если ОтветНаВопрос <> КодВозвратаДиалога.ОК Тогда
			Отказ = истина;
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// ПРОЦЕДУРЫ - ДЕЙСТВИЯ КОМАНДНЫХ ПАНЕЛЕЙ ФОРМЫ

// Процедура - обработчик нажатия кнопки "Печать" коммандной панели формы. 
// Выводит на печать систему оценки компетенций.
Процедура ОсновныеДействияФормыПечать(Кнопка)

	Если Модифицированность() Тогда
		Вопрос = НСтр("ru='Перед печатью необходимо записать компетенцию. Записать?';uk='Перед друком необхідно записати компетенції. Записати?'");
		Ответ  = Вопрос(Вопрос, РежимДиалогаВопрос.ОКОтмена);

		Если Ответ = КодВозвратаДиалога.ОК Тогда
			ЗаписатьВФорме();
		Иначе
			Возврат;
		КонецЕсли;
	КонецЕсли;
	
	Печать()
	
КонецПроцедуры // ОсновныеДействияФормыПечать

// Процедура вызывается при нажатии кнопки "Файлы" основной командной 
// панели формы. Процедура обеспечивает сохранение файлов.
// 
Процедура ДействияФормыФайлы(Кнопка)

	Отказ = Ложь;

	Если ЭтоНовый() Тогда
		Вопрос = НСтр("ru='Перед вводом файлов необходимо записать элемент. Записать?';uk='Перед введенням файлів необхідно записати елемент. Записати?'");
		Ответ  = Вопрос(Вопрос, РежимДиалогаВопрос.ОКОтмена);
		Если Ответ = КодВозвратаДиалога.ОК Тогда
			Отказ = Не ЗаписатьВФорме();
		Иначе
			Отказ = Истина;
		КонецЕсли;
	КонецЕсли;

 	Если НЕ Отказ Тогда

		
		СтруктураДляСпискаИзображдений = Новый Структура("ОтборОбъектИспользование, ОтборОбъектЗначение, ДоступностьОтбораОбъекта, ВидимостьКолонкиОбъекта", Истина, Ссылка, Ложь, Ложь);
		СтруктураДляСпискаДополнительныхФайлов = Новый Структура("ОтборОбъектИспользование, ОтборОбъектЗначение, ДоступностьОтбораОбъекта, ВидимостьКолонкиОбъекта", Истина, Ссылка, Ложь, Ложь);
		ОбязательныеОтборы = Новый Структура("Объект", Ссылка);
		
		РаботаСФайлами.ОткрытьФормуСпискаФайловИИзображений(СтруктураДляСпискаИзображдений, СтруктураДляСпискаДополнительныхФайлов, ОбязательныеОтборы, ЭтаФорма);
        	
	КонецЕсли;

КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ РЕКВИЗИТОВ ТАБЛИЧНОЙ ЧАСТИ 

// Процедура - обработчик события "ПриИзменении" поля ввод " ШкалаОценок".  
// Запускает процедуру построения системы оценки.
Процедура ШкалаОценокПриИзменении(Элемент)
	
	СохраненнаяШкала = Ссылка.ШкалаОценок;
	НоваяШкала = Элемент.Значение;
		
	Если СохраненнаяШкала = НоваяШкала Тогда 
		
		// Перечитаем оценки и описания из табличной части.
		// Найдем и удалим все строки таблицы, где незаполнено описание.
		МассивСтрок = ОписаниеОценок.НайтиСтроки(Новый Структура("ОписаниеОценки",""));
		Для каждого СтрокаДляУдаления Из МассивСтрок Цикл
			ОписаниеОценок.Удалить(СтрокаДляУдаления);
		КонецЦикла;
	
		// "Обнулим" оставшиеся строки.
		ТЗ = ОписаниеОценок.Выгрузить();
		ТЗ.ЗаполнитьЗначения(0,"ПриоритетОценки");
		ТЗ.ЗаполнитьЗначения(Справочники.ШкалыОценокКомпетенций.ПустаяСсылка(),"Оценка");
		ОписаниеОценок.Загрузить(ТЗ);

		СохраненнаяТаблица = Ссылка.ОписаниеОценок;

		// Заполним таблицу на экране текущими данными.
		Для Каждого СтрокаСохраненныхОценок из СохраненнаяТаблица Цикл
			НоваяСтрока = ОписаниеОценок.Добавить();
			НоваяСтрока.ВесОценки = СтрокаСохраненныхОценок.ВесОценки;
		    НоваяСтрока.ОписаниеОценки = СтрокаСохраненныхОценок.ОписаниеОценки;
			НоваяСтрока.Оценка = СтрокаСохраненныхОценок.Оценка;
            НоваяСтрока.ПриоритетОценки = СтрокаСохраненныхОценок.ПриоритетОценки;
		КонецЦикла;
		
	Иначе
		
		// Проверить наличие выбранной шкалы оценок.
		Если НЕ ЗначениеЗаполнено(ШкалаОценок) Тогда
			Сообщить (НСтр("ru='Не выбрана шкала оценок! Выберите шкалу оценок.';uk='Не обрана шкала оцінок! Виберіть шкалу оцінок.'"), СтатусСообщения.Важное);
			Возврат;
		КонецЕсли;
		
		ЗаполнитьОценки();
		
	КонецЕсли;
	
КонецПроцедуры



