
// процедура по настройке обмена данными устанавливает параметры
Процедура УстановитьПараметрыОбменаПоНастройке()
	
	ДанныеОбОбмене = "";
	
	НаличиеНастройки = ОпределитьНаличиеНастройки();
	
	Если Не НаличиеНастройки Тогда
		Возврат;
	КонецЕсли;
		
	// настройка имеется
	ОбъектНастройки = НастройкаОбменаДанными.ПолучитьОбъект();
		
	СтрокаОперации = "Выполняемые действия: ";
		
	Если ОбъектНастройки.ПроизводитьПриемСообщений 
		И ОбъектНастройки.ПроизводитьОтправкуСообщений Тогда
			
		СтрокаОперации = СтрокаОперации + "Загрузка и выгрузка данных";
			
	ИначеЕсли ОбъектНастройки.ПроизводитьПриемСообщений Тогда
			
		СтрокаОперации = СтрокаОперации + "Загрузка данных";
			
	ИначеЕсли ОбъектНастройки.ПроизводитьОтправкуСообщений Тогда
			
		СтрокаОперации = СтрокаОперации + "Выгрузка данных";
			
	КонецЕсли;
		
	ДанныеОбОбмене = ДанныеОбОбмене + СтрокаОперации + Символы.ПС;
	
	СтрокаТипаОбмена = "Тип обмена: ";
	
	// в ОбъектНастройки.ТипНастройки от типа обмена устанавливаем нужную настройку
	Если ОбъектНастройки.ТипНастройки = Перечисления.ТипыАвтоматическогоОбменаДанными.ОбменЧерезФайловыйРесурс Тогда
		
		СтрокаТипаОбмена = СтрокаТипаОбмена + " Обмен через файловый ресурс";
		СтрокаПараметровОбмена = "Каталог обмена: " + ?(НЕ ЗначениеЗаполнено(ОбъектНастройки.КаталогОбменаИнформацией), "не задан", ОбъектНастройки.КаталогОбменаИнформацией);
		
	ИначеЕсли ОбъектНастройки.ТипНастройки = Перечисления.ТипыАвтоматическогоОбменаДанными.ОбменЧерезFTPРесурс Тогда
		
		СтрокаТипаОбмена = СтрокаТипаОбмена + " Обмен через FTP ресурс";
		СтрокаПараметровОбмена = "FTP каталог обмена: " + ?(НЕ ЗначениеЗаполнено(ОбъектНастройки.FTPАдресОбмена), "не задан", ОбъектНастройки.FTPАдресОбмена);
		
	ИначеЕсли ОбъектНастройки.ТипНастройки = Перечисления.ТипыАвтоматическогоОбменаДанными.ОбменЧерезПочту Тогда
		
		СтрокаТипаОбмена = СтрокаТипаОбмена + " Обмен через E-Mail";
		СтрокаПараметровОбмена = "Учетная запись приема и отправки сообщений: " + ?(НЕ ЗначениеЗаполнено(ОбъектНастройки.ПочтовыйАдресПолучателя), "не задана", ОбъектНастройки.ПочтовыйАдресПолучателя);
		
	КонецЕсли;
	
	ДанныеОбОбмене = ДанныеОбОбмене + СтрокаТипаОбмена + Символы.ПС;
	ДанныеОбОбмене = ДанныеОбОбмене + СтрокаПараметровОбмена + Символы.ПС + Символы.ПС;
	
	// комментарий к настройке надо вывести
	ДанныеОбОбмене = ДанныеОбОбмене + "Комментарий к настройке обмена: " + ОбъектНастройки.Комментарий + Символы.ПС + Символы.ПС;
	
	ДанныеОПоследнемОбмене = ПеречитатьПараметрыНастройки();
	
	ДанныеОбОбмене = ДанныеОбОбмене + ДанныеОПоследнемОбмене;
	
КонецПроцедуры

//Функция определяет наличие настройки обмена
Функция ОпределитьНаличиеНастройки()
	
	Если НЕ ЗначениеЗаполнено(НастройкаОбменаДанными) Тогда
		Возврат Ложь;
	КонецЕсли;	
			
	ОбъектНастройки = НастройкаОбменаДанными.ПолучитьОбъект();
		
	Если ОбъектНастройки = Неопределено Тогда
		Возврат Ложь;
	Конецесли;
	
	Возврат Истина;
	
КонецФункции

// нажатие на кнопку выполнить
 Процедура ОсновныеДействияФормыВыполнить(Кнопка)
	
	Если НЕ ОпределитьНаличиеНастройки() Тогда
		Предупреждение(НСтр("ru='Не выбрана настройка для проведения обмена данными';uk='Не обрана настройка для проведення обміну даними'"));
		Возврат;
	КонецЕсли;
	
	МассивОбменов = Новый Массив();
	МассивОбменов.Добавить(НастройкаОбменаДанными);

	ПроцедурыОбменаДанными.ПроизвестиСписокОбменовДанными(МассивОбменов, Истина, глЗначениеПеременной("глОбработкаАвтоОбменДанными"), глЗначениеПеременной("глСоответствиеТекстовЭлектронныхПисем"));
		
	УстановитьПараметрыОбменаПоНастройке();
	
КонецПроцедуры

// при открытии формы
Процедура ПриОткрытии()
	
	НастройкаОбменаДанными = ВосстановитьЗначение("ОбщиеФормы.ФормаЗапускаОбменаДанными.НастройкаОбменаДанными");
	
	НаличиеНастройки = ОпределитьНаличиеНастройки();
	
	Если НаличиеНастройки Тогда
		
		УстановитьПараметрыОбменаПоНастройке();
		Возврат;
		
	КонецЕсли;
	
	НастройкаОбменаДанными = Справочники.НастройкиОбменаДанными.ПустаяСсылка();
	
	// сначала ищем первую настройку у которой пользователь помечен как отвественный за обмен
	Запрос = Новый Запрос();
	Запрос.Текст = "ВЫБРАТЬ Разрешенные первые 1
				   |	НастройкиОбменаДанными.Ссылка
				   |ИЗ
				   |	Справочник.НастройкиОбменаДанными КАК НастройкиОбменаДанными
				   | ГДЕ 
				   |	(НастройкиОбменаДанными.Ответственный = &ТекущийПользователь)";
					   
	Запрос.УстановитьПараметр("ТекущийПользователь", ПараметрыСеанса.ТекущийПользователь);			   
		
	Таблица = Запрос.Выполнить().Выгрузить();
		
	Если Таблица.Количество() <> 0 Тогда
			
		НастройкаОбменаДанными = Таблица[0].Ссылка;	
		УстановитьПараметрыОбменаПоНастройке();
		Возврат;
		
	КонецЕсли;
	
	// ищем просто первую попавшуюся настройку
	Запрос = Новый Запрос();
	Запрос.Текст = "ВЫБРАТЬ Разрешенные первые 1
				   |	НастройкиОбменаДанными.Ссылка
				   |ИЗ
				   |	Справочник.НастройкиОбменаДанными КАК НастройкиОбменаДанными
				   |";
					   
	Таблица = Запрос.Выполнить().Выгрузить();
		
	Если Таблица.Количество() <> 0 Тогда
			
		НастройкаОбменаДанными = Таблица[0].Ссылка;
		УстановитьПараметрыОбменаПоНастройке();
		Возврат;
			
	КонецЕсли;

	// в общем ни одна настройка не доступна для выбора
	ПредложитьСоздатьНовуюНастройкуОбмена();
	
КонецПроцедуры

//процедура спрашивает пользователя о необходимости создания новой настройки обмена
Процедура ПредложитьСоздатьНовуюНастройкуОбмена()
	
	// в общем ни одна настройка не доступна для выбора
	ОтветПользователя = Вопрос(НСтр("ru='Нет ни одной настройки обмена данными доступной для выполнения. Хотите создать новую настройку обмена?';uk='Немає жодної настройки обміну даними доступної для виконання. Хочете створити нову настройку обміну?'"),
		РежимДиалогаВопрос.ДаНет, , КодВозвратаДиалога.Да, НСтр("ru='Настройки обмена данными';uk='Настройки обміну даними'"));
		
	Если ОтветПользователя <> КодВозвратаДиалога.Да Тогда
		Возврат;	
	КонецЕсли;
	
	СоздатьИВыбратьНастройкуОбменаДанными();
	
КонецПроцедуры

// процедура создает новую настройку для обмена и помещает ее в поле выбора
Процедура СоздатьИВыбратьНастройкуОбменаДанными()
	
	НоваяНастройкаОбмена = Справочники.НастройкиОбменаДанными.СоздатьЭлемент();
		
	ФормаЭлемента = НоваяНастройкаОбмена.ПолучитьФорму("ФормаЭлемента", ЭтаФорма);
	ФормаЭлемента.ОткрытьМодально();
		
	Если НЕ ЗначениеЗаполнено(НоваяНастройкаОбмена.Ссылка) Тогда
		Возврат;
	Иначе
		НастройкаОбменаДанными = НоваяНастройкаОбмена.Ссылка;
		УстановитьПараметрыОбменаПоНастройке();
	КонецЕсли;
	
КонецПроцедуры


// выбор настроек обмена из списка
Процедура НастройкаОбменаДаннымиНачалоВыбораИзСписка(Элемент, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	// выпадающий список
	Запрос = Новый Запрос();
	Запрос.Текст = "ВЫБРАТЬ Разрешенные
				   |	НастройкиОбменаДанными.Ссылка
				   |ИЗ
				   |	Справочник.НастройкиОбменаДанными КАК НастройкиОбменаДанными
				   |";
				   
	Таблица = Запрос.Выполнить().Выгрузить();
	
	Если Таблица.Количество() = 0 Тогда
		
		ПредложитьСоздатьНовуюНастройкуОбмена();
		
	Иначе	
		
	    // выбираем настройку обмена из списка
		СписокВозврата = Новый СписокЗначений;
		
		Для Каждого СтрокаТаблицы Из Таблица Цикл
			
			СписокВозврата.Добавить(СтрокаТаблицы.Ссылка);
			
		КонецЦикла;
		
		СписокВозврата.СортироватьПоПредставлению();
		
		СписокВозврата.Добавить("Добавить новую настройку обмена");
		
		
		НачальноеЗначение = СписокВозврата.НайтиПоЗначению(Элемент.Значение);
		ВыбранныйЭлемент = ЭтаФорма.ВыбратьИзСписка(СписокВозврата, Элемент, НачальноеЗначение);
		
		// ничего не выбрали
		Если ВыбранныйЭлемент = Неопределено Тогда
			Возврат;
		КонецЕсли;
		
		Если ВыбранныйЭлемент.Значение = "Добавить новую настройку обмена" Тогда 
			
			СоздатьИВыбратьНастройкуОбменаДанными();
			
		Иначе
			
			НастройкаОбменаДанными = ВыбранныйЭлемент.Значение;
			УстановитьПараметрыОбменаПоНастройке();
			
		КонецЕсли;
	
	КонецЕсли;
	
КонецПроцедуры

// нажатие на кнопку настройки обмена данными
Процедура ОсновныеДействияФормыНастройкиОбмена(Кнопка)
	
	ФормаСписка = Справочники.НастройкиОбменаДанными.ПолучитьФормуСписка("ФормаСписка", ЭтаФорма); 
	ФормаСписка.Открыть();
	
КонецПроцедуры

Процедура ОсновныеДействияФормыПрименитьИзмененияВКонфигурации(Кнопка)
	
	Если НЕ ОпределитьНаличиеНастройки() Тогда
		Предупреждение(НСтр("ru='Не выбрана настройка для проведения изменений в конфигурации';uk='Не обрана настройка для проведення змін у конфігурації'"));
		Возврат;
	КонецЕсли;
	
	ТекстПредупреждения = Символы.Таб + НСтр("ru='Рекомендуем пользоваться автоматическим обновлением конфигурации БД, когда"
"достоверно известно, что внесенные в конфигурацию изменения не повлияют на ее работоспособность."
""
"';uk='Рекомендуємо користуватися автоматичним оновленням конфігурації БД, коли"
"достеменно відомо, що внесені в конфігурацію зміни не вплинуть на її працездатність."
""
"'") + Символы.Таб + НСтр("ru='Пользоваться автоматическим обновлением конфигурации БД рекомендуется в том случае, если"
"при обмене данными было получено сообщение об ошибке:"
"""Из главного узла распределенной ИБ получены изменения конфигурации."""
""
"';uk='Користуватися автоматичним оновленням конфігурації БД рекомендується в тому випадку, якщо"
"при обміні даними було отримане повідомлення про помилку:"
"""З головного вузла розподіленої ІБ отримані зміни конфігурації."""
""
"'") + Символы.Таб + НСтр("ru='Во всех остальных случаях не рекомендуется автоматически обновлять конфигурацию БД!"
""
"Обновить конфигурацию БД?';uk='У всіх інших випадках не рекомендується автоматично оновлювати конфігурацію БД!"
""
"Оновити конфігурацію БД?'");
	
	ОтветПользователя = Вопрос(ТекстПредупреждения,  
		РежимДиалогаВопрос.ДаНет, , КодВозвратаДиалога.Нет, НСтр("ru='Изменения конфигурации';uk='Зміни конфігурації'"));
		
	Если ОтветПользователя <> КодВозвратаДиалога.Да Тогда
		// пользователь отказался изменять метаданные	
		Возврат;	
	КонецЕсли;	
	
	// надо для выбранной настройки поставить признак запуска обмена при загрузке данных
	ПроцедурыОбменаДанными.УстановитьНеобходимостьВыполненияОбменаПриПервомЗапускеПрограммы(НастройкаОбменаДанными, Истина);
	
	ПроцедурыОбменаДанными.ПредложитьПерезагрузкуПрограммы(, Истина); 
		
КонецПроцедуры

// Функция перечитывает данные параметорв настройки
Функция ПеречитатьПараметрыНастройки()
	
	ДанныеОПоследнемОбмене = "Информация о последнем обмене:" + Символы.ПС;
	
	Запрос = Новый Запрос();
	Запрос.Текст = "ВЫБРАТЬ
				   |	ПараметрыОбменаДанными.ДатаПоследнейЗагрузки,
				   |	ПараметрыОбменаДанными.ДатаПоследнейВыгрузки,
				   |	ПараметрыОбменаДанными.РезультатПоследнейЗагрузки,
				   |	ПараметрыОбменаДанными.РезультатПоследнейВыгрузки
				   |ИЗ
				   |	РегистрСведений.ПараметрыОбменаДанными КАК ПараметрыОбменаДанными
				   |	ГДЕ (ПараметрыОбменаДанными.НастройкаОбменаДанными = &Ссылка)";
				   
	Запрос.УстановитьПараметр("Ссылка", НастройкаОбменаДанными); 
	
	Выборка = Запрос.Выполнить().Выбрать();
	Если Выборка.Следующий() Тогда
		
		ДатаПоследнейЗагрузки = Выборка.ДатаПоследнейЗагрузки;
		ДатаПоследнейВыгрузки = Выборка.ДатаПоследнейВыгрузки;
		РезультатПоследнейЗагрузки = Выборка.РезультатПоследнейЗагрузки;
		РезультатПоследнейВыгрузки = Выборка.РезультатПоследнейВыгрузки;
			
	Иначе
	
		ДатаПоследнейЗагрузки = Неопределено;
		ДатаПоследнейВыгрузки = Неопределено;
		РезультатПоследнейЗагрузки = Ложь;
		РезультатПоследнейВыгрузки = Ложь;
		
	КонецЕсли;
	
	СтрокаПоследнейЗагрузки = "  Загрузка данных: ";
	СтрокаПоследнейВыгрузки = "  Выгрузка данных: ";
	
	Если НастройкаОбменаДанными.ПроизводитьПриемСообщений Тогда
		Если НЕ ЗначениеЗаполнено(ДатаПоследнейЗагрузки) Тогда
			СтрокаПоследнейЗагрузки = СтрокаПоследнейЗагрузки + "не выполнялась";
		Иначе
			СтрокаПоследнейЗагрузки = СтрокаПоследнейЗагрузки + Строка(ДатаПоследнейЗагрузки);
			Если РезультатПоследнейЗагрузки = Истина Тогда 
				СтрокаПоследнейЗагрузки = СтрокаПоследнейЗагрузки + " (успешно)";
			Иначе
				СтрокаПоследнейЗагрузки = СтрокаПоследнейЗагрузки + " (с ошибками)";
			КонецЕсли;
		КонецЕсли;
	Иначе
		СтрокаПоследнейЗагрузки = СтрокаПоследнейЗагрузки + " не производится";
	КонецЕсли;
	
	Если НастройкаОбменаДанными.ПроизводитьОтправкуСообщений Тогда
		Если НЕ ЗначениеЗаполнено(ДатаПоследнейВыгрузки) Тогда
			СтрокаПоследнейВыгрузки = СтрокаПоследнейВыгрузки + "не выполнялась";
		Иначе
			СтрокаПоследнейВыгрузки = СтрокаПоследнейВыгрузки + Строка(ДатаПоследнейВыгрузки);
			
			Если РезультатПоследнейВыгрузки = Истина Тогда 
				СтрокаПоследнейВыгрузки = СтрокаПоследнейВыгрузки +  " (успешно)";
			Иначе
				СтрокаПоследнейВыгрузки = СтрокаПоследнейВыгрузки + " (с ошибками)";
			КонецЕсли;
		КонецЕсли;
	Иначе
		СтрокаПоследнейВыгрузки = СтрокаПоследнейВыгрузки + " не производится";
	КонецЕсли;
	
	ДанныеОПоследнемОбмене = ДанныеОПоследнемОбмене + СтрокаПоследнейЗагрузки + Символы.ПС;
	ДанныеОПоследнемОбмене = ДанныеОПоследнемОбмене + СтрокаПоследнейВыгрузки;
	
	Возврат ДанныеОПоследнемОбмене;
	
КонецФункции

// при изменении настройки обмена
Процедура НастройкаОбменаДаннымиПриИзменении(Элемент)
	
	УстановитьПараметрыОбменаПоНастройке();
		
КонецПроцедуры

// обновить данные
Процедура КоманднаяПанель1Обновить(Кнопка)
	
	УстановитьПараметрыОбменаПоНастройке();
	
КонецПроцедуры

// при закрытии формы выполнения обмена
Процедура ПриЗакрытии()
	
	СохранитьЗначение("ОбщиеФормы.ФормаЗапускаОбменаДанными.НастройкаОбменаДанными", НастройкаОбменаДанными);
	
КонецПроцедуры

// настройка параметров обновления конфигурации
Процедура КоманднаяПанель1НастройкаПараметровОбновленияКонфигурации(Кнопка)
	
	ОткрытьФормуРедактированияНастройкиФайлаОбновления();
	
КонецПроцедуры

