#Если ТолстыйКлиентОбычноеПриложение Тогда

////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ ФОРМЫ

Процедура ПриОткрытии()
	
	Событие = ?(ОбработчикиСобытийЧитаемИзФайлаПравилОбмена, НСтр("ru='выгрузки';uk='вивантаження'"), НСтр("ru='загрузки';uk='завантаження'"));

	ЗаголовокФормы = НСтр("ru='Настройка отладки обработчиков %Событие% данных';uk='Настройка налагодження обробників %Событие% даних'");
	ЗаголовокФормы = СтрЗаменить(ЗаголовокФормы, "%Событие%", Событие);
	
	ЗаголовокКнопки = НСтр("ru='Сформировать модуль отладки %Событие%';uk='Сформувати модуль налагодження %Событие%'");
	ЗаголовокКнопки = СтрЗаменить(ЗаголовокКнопки, "%Событие%", Событие);
	
	Заголовок = ЗаголовокФормы;
	ЭлементыФормы.КнопкаВыгрузитьКодОбработчиков.Заголовок = ЗаголовокКнопки;
	
	УстановитьВидимость();
	
КонецПроцедуры

Процедура ПриЗакрытии()
	
	УдалитьВременныеФайлы(ИмяВременногоФайлаОбработчиковСобытий);
	УдалитьВременныеФайлы(ИмяВременногоФайлаПротоколаОбмена);
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ ЭЛЕМЕНТОВ ШАПКИ ФОРМЫ

Процедура КнопкаГотовоНажатие(Элемент)
	
	Отказ = Ложь;
	
	СтрокаСообщения = "";
	ПроверитьПравильностьВыполненияШаговМастера(Отказ, СтрокаСообщения);
	
	Если Отказ Тогда
		ТекстПредупреждения = НСтр("ru='Не все необходимые шаги выполнены:"
""
"%СтрокаСообщения%';uk='Не всі необхідні кроки виконані:"
""
" %СтрокаСообщения%'");
		ТекстПредупреждения = СтрЗаменить(ТекстПредупреждения, "%СтрокаСообщения%", СтрокаСообщения);
		
		Предупреждение(ТекстПредупреждения);
		Возврат;
	КонецЕсли; 
	
	УстановитьЗначенияРеквизитовОбработки();
	
	Закрыть(Истина);
	
КонецПроцедуры

Процедура ИмяФайлаВнешнейОбработкиОбработчиковСобытийНачалоВыбора(Элемент, СтандартнаяОбработка)
	
	ВыборФайла(Элемент, Истина, "epf");
	
КонецПроцедуры

Процедура КнопкаОткрытьФайлНажатие(Элемент)
	
	ПоказатьОбработчикиСобытийВОкне();

КонецПроцедуры

Процедура ИмяФайлаВнешнейОбработкиОбработчиковСобытийПриИзменении(Элемент)
	
	УстановитьВидимость();
	
КонецПроцедуры

Процедура КнопкаВыгрузитьКодОбработчиковНажатие(Элемент)
	
	//Возможно выгрузку уже совершали ранее...
	Если Не ПустаяСтрока(ИмяВременногоФайлаОбработчиковСобытий) Тогда
		
		Ответ = Вопрос(НСтр("ru='Произвести выгрузку обработчиков повторно (Да) или открыть существующую выгрузку (Нет)?';uk='Зробити вивантаження обробників повторно (Так) або відкрити існуюче вивантаження (Ні)?'"), РежимДиалогаВопрос.ДаНетОтмена,,КодВозвратаДиалога.Нет);
		
		//Открываем имеющийся файл выгрузки
		Если Ответ = КодВозвратаДиалога.Нет Тогда
			
			ПоказатьОбработчикиСобытийВОкне();
			
			Возврат;
			
		ИначеЕсли Ответ = КодВозвратаДиалога.Отмена Тогда
			
			Возврат;
			
		КонецЕсли;
		
	КонецЕсли; 
	
	//Проверка на указание имени файла правил или файла обмена
	Если ОбработчикиСобытийЧитаемИзФайлаПравилОбмена И ПустаяСтрока(ИмяФайлаПравилОбмена) Тогда
		
		Предупреждение(НСтр("ru='Выберите файл правил обмена.';uk='Виберіть файл правил обміну.'"));
		Возврат;
		
	ИначеЕсли НЕ ОбработчикиСобытийЧитаемИзФайлаПравилОбмена И ПустаяСтрока(ИмяФайлаОбмена) Тогда
		
		Предупреждение(НСтр("ru='Выберите файл обмена.';uk='Виберіть файл обміну.'"));
		Возврат;
		
	КонецЕсли;

	Отказ = Ложь;

	УстановитьЗначенияРеквизитовОбработки();

	ВыгрузитьОбработчикиСобытий(Отказ);
	
	Если Не Отказ Тогда
		
		УстановитьВидимость();
		
		ПоказатьОбработчикиСобытийВОкне();
		
	КонецЕсли;
	
КонецПроцедуры

Процедура ПереключательОтладкаАлгоритмов_0ПриИзменении(Элемент)
	
	УстановитьВидимость();
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// СЛУЖЕБНЫЕ ПРОЦЕДУРЫ И ФУНКЦИИ

Процедура УстановитьСтраницуПанелиПодсказки(ИмяПанели, ИндексСтраницы) 
	
	ЭлементыФормы[ИмяПанели].ТекущаяСтраница = ЭлементыФормы[ИмяПанели].Страницы["Подсказка_" + Строка(ИндексСтраницы)];
	
КонецПроцедуры

Процедура ПроверитьПравильностьВыполненияШаговМастера(Отказ, СтрокаСообщения)
	
	Если ПустаяСтрока(ИмяФайлаВнешнейОбработкиОбработчиковСобытий) Тогда
		
		ВывестиСообщениеОбОшибке(Отказ, 4, СтрокаСообщения, НСтр("ru='Укажите имя файла внешней обработки.';uk=""Укажіть ім'я файлу зовнішньої обробки."""));
		
	ИначеЕсли ПустаяСтрока(ИмяВременногоФайлаОбработчиковСобытий) Тогда
		
		ВывестиСообщениеОбОшибке(Отказ, 2, СтрокаСообщения, НСтр("ru='Код обработчиков не выгружен.';uk='Код обробників не вивантажений.'"));
		
	КонецЕсли; 
	
	Если Отказ Тогда
		
		Возврат;
		
	КонецЕсли; 
	
	ФайлВнешнейОбработкиОбработчиковСобытий = Новый Файл(ИмяФайлаВнешнейОбработкиОбработчиковСобытий);
	ВременныйФайлОбработчиковСобытий        = Новый Файл(ИмяВременногоФайлаОбработчиковСобытий);
	
	Если Не ФайлВнешнейОбработкиОбработчиковСобытий.Существует() Тогда
		
		ВывестиСообщениеОбОшибке(Отказ, 4, СтрокаСообщения, НСтр("ru='Указанный файл внешней обработки не существует.';uk='Зазначений файл зовнішньої обробки не існує.'"));
	
	ИначеЕсли Не ВременныйФайлОбработчиковСобытий.Существует() Тогда
		
		ВывестиСообщениеОбОшибке(Отказ, 2, СтрокаСообщения, НСтр("ru='Код обработчиков не выгружен.';uk='Код обробників не вивантажений.'"));
		
	ИначеЕсли ФайлВнешнейОбработкиОбработчиковСобытий.ПолучитьВремяИзменения() 
		   < ВременныйФайлОбработчиковСобытий.ПолучитьВремяИзменения() Тогда
		
		ВывестиСообщениеОбОшибке(Отказ, 4, СтрокаСообщения, НСтр("ru='Файл внешней обработки не обновлен данными из последней выгрузки.';uk='Файл зовнішньої обробки не оновлений даними з останнього вивантаження.'"));
		
	КонецЕсли; 
	
КонецПроцедуры 

Процедура УстановитьВидимость()
	
	//Выделение красным цветом шагов мастера, которые выполнены неправильно
	УстановитьВыделениеРамки("Рамка_Шаг_2", ПустаяСтрока(ИмяВременногоФайлаОбработчиковСобытий));
	УстановитьВыделениеРамки("Рамка_Шаг_4", ПустаяСтрока(ИмяФайлаВнешнейОбработкиОбработчиковСобытий));
	
	ЗаголовокРамки = НСтр("ru='1. Выберите режим отладки кода алгоритмов (%РежимДляСообщения%)';uk='1. Виберіть режим налагодження коду алгоритмів (%РежимДляСообщения%)'");
	РежимДляСообщения = ЭлементыФормы["ПереключательОтладкаАлгоритмов_"+РежимОтладкиАлгоритмов].Заголовок;
	ЗаголовокРамки = СтрЗаменить(ЗаголовокРамки, "%РежимДляСообщения%", РежимДляСообщения);
	
	УстановитьЗаголовокРамки("Рамка_Шаг_1", ЗаголовокРамки);
	УстановитьЗаголовокРамки("Рамка_Шаг_2", НСтр("ru='2. Выгрузите код обработчиков';uk='2. Вивантажте код обробників'"));
	УстановитьЗаголовокРамки("Рамка_Шаг_3", НСтр("ru='3. Пояснения к созданию файла внешней обработки';uk='3. Пояснення до створення файлу зовнішньої обробки'"));
	УстановитьЗаголовокРамки("Рамка_Шаг_4", НСтр("ru='4. Создайте (обновите) файл внешней обработки';uk='4. Створіть (оновіть) файл зовнішньої обробки'"));
	
	ЭлементыФормы.КнопкаОткрытьФайл.Доступность = Не ПустаяСтрока(ИмяВременногоФайлаОбработчиковСобытий);
	
	//Устанавливаем текущие панели с текстом подсказок
	УстановитьСтраницуПанелиПодсказки("ПанельПодсказкиШаг_1", РежимОтладкиАлгоритмов);
	
КонецПроцедуры 

Процедура ВывестиСообщениеОбОшибке(Отказ, НомерШага, СтрокаСообщения, СообщениеОбОшибке) 
	
	//Выделяем рамку красным цветом
	УстановитьВыделениеРамки("Рамка_Шаг_" + НомерШага, Истина);
	
	//Формируем сообщение об ошибке 
	СтрокаСообщения = НСтр("ru='Шаг № %НомерШага%: %СообщениеОбОшибке%';uk='Крок № %НомерШага%: %СообщениеОбОшибке%'");
	СтрокаСообщения = СтрЗаменить(СтрокаСообщения, "%НомерШага%", НомерШага);
	СтрокаСообщения = СтрЗаменить(СтрокаСообщения, "%СообщениеОбОшибке%", СообщениеОбОшибке);
	
	Отказ = Истина;
	
КонецПроцедуры  

Процедура УстановитьЗаголовокРамки(ИмяРамки, Заголовок); 
	
	ЭлементыФормы[ИмяРамки].Заголовок = Заголовок;
	
КонецПроцедуры

Процедура УстановитьВыделениеРамки(ИмяРамки, НадоВыделитьРамку = Ложь) 
	
	РамкаШагаМастера = ЭлементыФормы[ИмяРамки];
	
	Если НадоВыделитьРамку Тогда
		
		РамкаШагаМастера.ЦветРамки = ЦветаСтиля.ЦветОсобогоТекста;
		
	Иначе
		
		РамкаШагаМастера.ЦветРамки = ЦветаСтиля.ЦветРамки;
		
	КонецЕсли;
	
КонецПроцедуры

Процедура ПоказатьОбработчикиСобытийВОкне()
	
	ФормаОбработчиков = ПолучитьФорму("ФормаРедактораТекстовогоДокумента", ЭтаФорма);
	
	ЗаполнитьПолеТекстовогоДокумента(ФормаОбработчиков.ЭлементыФормы, "ПолеОбработчикиСобытий", ИмяВременногоФайлаОбработчиковСобытий);
	ЗаполнитьПолеТекстовогоДокумента(ФормаОбработчиков.ЭлементыФормы, "ПолеОшибкиВыгрузки",     ИмяВременногоФайлаПротоколаОбмена);
	
	ФормаОбработчиков.Открыть();
	
КонецПроцедуры

Процедура ЗаполнитьПолеТекстовогоДокумента(ЭлементыОткрытойФормы, ИмяПоля, ИмяФайла) 
	
	Если Не ПустаяСтрока(ИмяФайла) Тогда
		
		Файл = Новый Файл(ИмяФайла);
		
		Если Файл.Существует() Тогда
			
			//Заполняем данными текстовое поле
			ЭлементыОткрытойФормы[ИмяПоля].Прочитать(ИмяФайла);
			
			//Определяем видимость страницы панели обработчиков
			ТекущаяСтраницаПанелиОбработчиков = ЭлементыОткрытойФормы.ПанельОбработчиков.Страницы["Страница_" + ИмяПоля];
			
			ТекущаяСтраницаПанелиОбработчиков.Видимость = (Файл.Размер() <> 0); 
			
			//Определяем текущую страницу
			Если ТекущаяСтраницаПанелиОбработчиков.Видимость Тогда
				
				ЭлементыОткрытойФормы.ПанельОбработчиков.ТекущаяСтраница = ТекущаяСтраницаПанелиОбработчиков;
			
			КонецЕсли;
			
		КонецЕсли;
		
	КонецЕсли;
	
КонецПроцедуры

// Открывает диалог выбора файла
//
// Параметры:
//  Элемент                - Элемент управления, для которого выбираем файл
//  ПроверятьСуществование - Если Истина, то выбор отменяется если файл не существует
// 
Процедура ВыборФайла(Элемент, ПроверятьСуществование = Ложь, Знач РасширениеПоУмолчанию = "txt")
	
	ДиалогВыбораФайла = Новый ДиалогВыбораФайла(РежимДиалогаВыбораФайла.Открытие);

	Если РасширениеПоУмолчанию = "txt" Тогда
		
		ДиалогВыбораФайла.Фильтр     = НСтр("ru='Файл выгрузки обработчиков событий (*.txt)|*.txt';uk='Файл вивантаження обробників подій (*.txt)|*.txt'");
		ДиалогВыбораФайла.Расширение = "txt";
		
	ИначеЕсли РасширениеПоУмолчанию = "epf" Тогда
		
		ДиалогВыбораФайла.Фильтр     = НСтр("ru='Файл внешней обработки обработчиков событий (*.epf)|*.epf';uk='Файл зовнішньої обробки обробників подій (*.epf)|*.epf'");
		ДиалогВыбораФайла.Расширение = "epf";
			
	КонецЕсли;
	
	ДиалогВыбораФайла.Заголовок                    = НСтр("ru='Выберите файл';uk='Виберіть файл'");
	ДиалогВыбораФайла.ПредварительныйПросмотр      = Ложь;
	ДиалогВыбораФайла.ИндексФильтра                = 0;
	ДиалогВыбораФайла.ПолноеИмяФайла               = Элемент.Значение;
	ДиалогВыбораФайла.ПроверятьСуществованиеФайла  = ПроверятьСуществование;
	
	Если ДиалогВыбораФайла.Выбрать() Тогда
		
		Элемент.Значение = ДиалогВыбораФайла.ПолноеИмяФайла;
		
		Если Элемент = ЭлементыФормы.ИмяФайлаВнешнейОбработкиОбработчиковСобытий Тогда 
			
			ИмяФайлаВнешнейОбработкиОбработчиковСобытийПриИзменении(Элемент)
			
		КонецЕсли;
				
	КонецЕсли;
	
КонецПроцедуры

Процедура УстановитьЗначенияРеквизитовОбработки()
	
	ОбработкаОбъект.ИмяФайлаВнешнейОбработкиОбработчиковСобытий = ИмяФайлаВнешнейОбработкиОбработчиковСобытий;
	ОбработкаОбъект.РежимОтладкиАлгоритмов                      = РежимОтладкиАлгоритмов;
	ОбработкаОбъект.ОбработчикиСобытийЧитаемИзФайлаПравилОбмена = ОбработчикиСобытийЧитаемИзФайлаПравилОбмена;
	
КонецПроцедуры

#КонецЕсли
