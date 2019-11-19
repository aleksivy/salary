﻿////////////////////////////////////////////////////////////////////////////////
// ПРОЦЕДУРЫ И ФУНКЦИИ ОБЩЕГО НАЗНАЧЕНИЯ

// Заполняет диалог по значениям реквизитов отчета
//
// Параметры:
//	Нет.
//
Процедура ЗаполнитьДиалогПоОбъекту()

	// Здесь должно быть расположено заполнение реквизитов формы
	// по реквизитам отчета, если они непосредственно не связаны
	// с реквизитами отчета (если таковые имеются)
	Если мВыбиратьИмяРегистра = Ложь Тогда
		ЭлементыФормы.ПанельРазделУчета.Свертка = РежимСверткиЭлементаУправления.Верх;
		
	Иначе
		ЭлементыФормы.ПанельРазделУчета.Свертка = РежимСверткиЭлементаУправления.Нет;
		
	КонецЕсли; 

	Если мВыбиратьИспользованиеСвойств = Ложь Тогда
		ЭлементыФормы.ПанельИспользоватьСвойства.Свертка = РежимСверткиЭлементаУправления.Верх;
		
	Иначе
		ЭлементыФормы.ПанельИспользоватьСвойства.Свертка = РежимСверткиЭлементаУправления.Нет;
		
	КонецЕсли; 

	Если мРежимВводаПериода = 0 Тогда  // произвольный период
		ЭлементыФормы.НадписьДатаНач.Заголовок = НСтр("ru='Период с:';uk='Період з:'");

		ЭлементыФормы.ДатаНач.Данные = "ДатаНач";
		
		// Элементы управления произвольным периодом
		ЭлементыФормы.ДатаКон.Видимость = Истина;
		ЭлементыФормы.НадписьДатаКон.Видимость = Истина;
		ЭлементыФормы.КнопкаНастройкаПериода.Видимость = Истина;
		
		// Элементы управления периодом
		ЭлементыФормы.Период.Видимость = Ложь;
		ЭлементыФормы.ПлюсПериод.Видимость = Ложь;
		ЭлементыФормы.МинусПериод.Видимость = Ложь;
	
	ИначеЕсли мРежимВводаПериода = 1 Тогда // дата
		ЭлементыФормы.НадписьДатаНач.Заголовок = НСтр("ru='На дату:';uk='На дату:'");

		ЭлементыФормы.ДатаНач.Данные = "ДатаКон";
		
		// Элементы управления произвольным периодом
		ЭлементыФормы.ДатаКон.Видимость = Ложь;
		ЭлементыФормы.НадписьДатаКон.Видимость = Ложь;
		ЭлементыФормы.КнопкаНастройкаПериода.Видимость = Ложь;

		// Элементы управления периодом
		ЭлементыФормы.Период.Видимость = Ложь;
		ЭлементыФормы.ПлюсПериод.Видимость = Ложь;
		ЭлементыФормы.МинусПериод.Видимость = Ложь;
	
	Иначе // периоды Месяц, Квартал, Год
		ЭлементыФормы.НадписьДатаНач.Заголовок = "Период:";

		// Элементы управления датой
		ЭлементыФормы.ДатаНач.Видимость = Ложь;
		
		// Элементы управления произвольным периодом
		ЭлементыФормы.ДатаКон.Видимость = Ложь;
		ЭлементыФормы.НадписьДатаКон.Видимость = Ложь;
		ЭлементыФормы.КнопкаНастройкаПериода.Видимость = Ложь;
		
		// Элементы управления периодом
		ЭлементыФормы.Период.Видимость = Истина;
		ЭлементыФормы.ПлюсПериод.Видимость = Истина;
		ЭлементыФормы.МинусПериод.Видимость = Истина;
		Если мРежимВводаПериода = 2 Тогда // месяц
			ЭлементыФормы.Период.Формат = "ДФ='ММММ гггг ""г.""'";
		ИначеЕсли мРежимВводаПериода = 3 Тогда // квартал
			ЭлементыФормы.Период.Формат = "ДФ='к ""квартал"" гггг ""г.""'";
		ИначеЕсли мРежимВводаПериода = 4 Тогда // год
			ЭлементыФормы.Период.Формат = "ДФ='гггг ""г.""'";
		КонецЕсли;
	
	КонецЕсли; 
	
    ЭлементыФормы.ПанельОтчета.Страницы.ИнтервалыГруппировок.Видимость = ИспользоватьИнтервальныеГруппировки;
	
	ЭлементыФормы.ОтобранныеИнтервалы.ТолькоПросмотр = НЕ ЗначениеЗаполнено(ИнтервальноеПоле);
	
КонецПроцедуры // ЗаполнитьДиалогПоОбъекту()

Процедура ОтобратьИнтервалы()
	
	Если СоответствиеТиповИнтервальныхПолей[ИнтервальноеПоле]=Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	НайдСтр = Интервалы.НайтиСтроки(Новый Структура("ИнтервальноеПоле", ИнтервальноеПоле));
	
	ОписаниеТиповПоляГруппировки = СоответствиеТиповИнтервальныхПолей[ИнтервальноеПоле];
	
	ОтобранныеИнтервалы = Новый ТаблицаЗначений;
	ОтобранныеИнтервалы.Колонки.Добавить("ВГраница", ОписаниеТиповПоляГруппировки);
	ОтобранныеИнтервалы.Колонки.Добавить("Название", ОбщегоНазначения.ПолучитьОписаниеТиповСтроки(100));
	
	ПрошлаяГраница=0;
	Для Каждого Стр Из НайдСтр Цикл
		НоваяСтр=ОтобранныеИнтервалы.Добавить();
		НоваяСтр.Вграница=Стр.ВГраница;
		НоваяСтр.Название=Стр.Название;
	КонецЦикла;
	
	ЭлементыФормы.ОтобранныеИнтервалы.Колонки.ВГраница.ЭлементУправления.ОграничениеТипа = ОписаниеТиповПоляГруппировки;
	
	// Для интервалов используются только простые поля (не составные)
	ТипПоля = ОписаниеТиповПоляГруппировки.Типы()[0];
	
	Если ТипПоля=Тип("Число") Тогда
		ЭлементыФормы.ОтобранныеИнтервалы.Колонки.ВГраница.ЭлементУправления.Формат="ЧЦ="+ОписаниеТиповПоляГруппировки.КвалификаторыЧисла.Разрядность+";ЧДЦ="+ОписаниеТиповПоляГруппировки.КвалификаторыЧисла.РазрядностьДробнойЧасти;
	ИначеЕсли ТипПоля=Тип("Дата") Тогда
		Если ОписаниеТиповПоляГруппировки.КвалификаторыДаты.ЧастиДаты=ЧастиДаты.Дата Тогда
			ЭлементыФормы.ОтобранныеИнтервалы.Колонки.ВГраница.ЭлементУправления.Формат="ДФ=дд.ММММ.гггг";
		ИначеЕсли ОписаниеТиповПоляГруппировки.КвалификаторыДаты.ЧастиДаты=ЧастиДаты.Время Тогда
			ЭлементыФормы.ОтобранныеИнтервалы.Колонки.ВГраница.ЭлементУправления.Формат="ДФ=чч:мм:сс";
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры // ОтобратьИнтервалы()

Процедура ВставитьИнтервалыПоИмени()
	
	// Удалим имеющиеся
	Инд=0;
	Пока Инд<Интервалы.Количество() Цикл
		Если Интервалы[Инд].ИнтервальноеПоле=ИнтервальноеПоле Тогда
			Интервалы.Удалить(Инд);
		Иначе
			Инд=Инд+1;
		КонецЕсли;
	КонецЦикла;
	
	Для Каждого Стр Из ОтобранныеИнтервалы Цикл
		НоваяСтр=Интервалы.Добавить();
		НоваяСтр.Вграница=Стр.ВГраница;
		НоваяСтр.ИнтервальноеПоле=ИнтервальноеПоле;
		НоваяСтр.Название=Стр.Название;
	КонецЦикла;
	
КонецПроцедуры // ВставитьИнтервалыПоИмени()

///////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ ФОРМЫ

// Процедура - обработчик события "Перед открытием" формы отчета.
//
Процедура ПередОткрытием(Отказ, СтандартнаяОбработка)

	Заголовок = мНазваниеОтчета;
	
	// для отображения периода
	Если мРежимВводаПериода = 2 Тогда // месяц
		ЭлементыФормы.Период.Формат = "ДФ='ММММ гггг ""г.""'";
	ИначеЕсли мРежимВводаПериода = 3 Тогда // квартал
		ЭлементыФормы.Период.Формат = "ДФ='к ""квартал"" гггг ""г.""'";
	ИначеЕсли мРежимВводаПериода = 4 Тогда // год
		ЭлементыФормы.Период.Формат = "ДФ='гггг ""г.""'";
	КонецЕсли;
	ДатаНач = ДатаНач;
	
	// Отчет без показателей
	Если Показатели.Количество()=0 Тогда
		
		ЭлементыФормы.Удалить(ЭлементыФормы.СписокПоказателей);
		ЭлементыФормы.Удалить(ЭлементыФормы.РамкаГруппыПоказатели);
		ЭлементыФормы.Удалить(ЭлементыФормы.ВыводитьПоказателиВСтроку);
		ЭлементыФормы.Удалить(ЭлементыФормы.КоманднаяПанельСписокПоказателей);
		ЭлементыФормы.Удалить(ЭлементыФормы.ВыводитьИтогиПоВсемУровням);
		
		ЭлементыФормы.Удалить(ЭлементыФормы.ИзмеренияКолонки);
		ЭлементыФормы.Удалить(ЭлементыФормы.КоманднаяПанельИзмеренияКолонки);
		ЭлементыФормы.Удалить(ЭлементыФормы.КоманднаяПанельСтрокиВКолонки);
		
	КонецЕсли;
	
	Если ИспользоватьИнтервальныеГруппировки Тогда
		ОтобратьИнтервалы();
	КонецЕсли;

КонецПроцедуры // ПередОткрытием()

// Процедура - обработчик события ПриОткрытии формы
//
Процедура ПриОткрытии()
	ЗаполнитьДиалогПоОбъекту();
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// ПРОЦЕДУРЫ - ОБРАБОТЧИКИ НАЖАТИЯ КНОПОК КОМАНДНОЙ ПАНЕЛИ

// Процедура - обработчик нажатия кнопки ОК.
//
Процедура ОсновныеДействияФормыОК(Кнопка)

	ЕстьОшибки = Ложь;
	Для Инд=0 По ПостроительОтчета.ИзмеренияКолонки.Количество()-1  Цикл
	
		Для Инд2=0 По ПостроительОтчета.ИзмеренияСтроки.Количество()-1  Цикл

			Если ПостроительОтчета.ИзмеренияКолонки[Инд].ПутьКДанным = ПостроительОтчета.ИзмеренияСтроки[Инд2].ПутьКДанным Тогда

				Предупреждение(НСтр("ru='Повторяющаяся группировка ';uk='Повторюване групування '") + ПостроительОтчета.ИзмеренияКолонки[Инд].Представление +"."+ Символы.ПС+
				НСтр("ru='Нельзя использовать одинаковые поля группировки в строках и в колонках!';uk='Не можна використовувати однакові поля групування в рядках і в колонках!'"), 30);
				ЕстьОшибки = Истина;
			
			КонецЕсли; 
		КонецЦикла;
	
	КонецЦикла;
	
	Для Каждого СтрокаОтбора Из ПостроительОтчета.Отбор Цикл
		
		Если НЕ ЗначениеЗаполнено(СтрокаОтбора.ПутьКДанным) Тогда
			Предупреждение(НСтр("ru='В отборе не должно быть пустых полей!';uk='У відборі не повинне бути порожніх полів!'"), 30);
			ЕстьОшибки = Истина;
			Прервать;
		КонецЕсли;
		
	КонецЦикла;

	Если Показатели.Количество() > 0 Тогда
		ЕстьПоказатели = Ложь;
		Для Каждого Показатель Из Показатели Цикл
			Если Показатель.Использование Тогда
				ЕстьПоказатели = Истина;
				Прервать;
			КонецЕсли;
		КонецЦикла;
		Если НЕ ЕстьПоказатели Тогда
			Предупреждение(НСтр("ru='Не выбраны показатели!';uk='Не обрані показники!'"), 30);
			ЕстьОшибки = Истина;
		КонецЕсли;
	КонецЕсли;
	
	Если ЕстьОшибки Тогда
		Возврат;
	КонецЕсли;
	
	Если ИспользоватьИнтервальныеГруппировки Тогда
		
		ВставитьИнтервалыПоИмени();
		
		Настройки=ПостроительОтчета.ПолучитьНастройки();
		Если мВыбиратьИмяРегистра Тогда
			ЗаполнитьНачальныеНастройки();
		Иначе
			ВладелецФормы.ЭтотОтчет.ЗаполнитьНачальныеНастройки();
		КонецЕсли;
		ПостроительОтчета.УстановитьНастройки(Настройки);
		
	КонецЕсли;
	
	Закрыть(Истина);
	
КонецПроцедуры // ОсновныеДействияФормыОК()

// закладка Общие

// Процедура - обработчик нажатия кнопки "Установить все" командной панели списка показателей
//
Процедура КоманднаяПанельСписокПоказателейУстановитьВсе(Кнопка)
	
	Для каждого Строка Из  Показатели Цикл
		Строка.Использование = Истина;
	КонецЦикла;
	
КонецПроцедуры

// Процедура - обработчик нажатия кнопки "Снять все" командной панели списка показателей
//
Процедура КоманднаяПанельСписокПоказателейСнятьВсе(Кнопка)
	
	Для каждого Строка Из  Показатели Цикл
		Строка.Использование = Ложь;
	КонецЦикла;
	
КонецПроцедуры

// закладка Группировки

// Процедура - обработчик нажатия кнопки > (перенести в колонки) на панели настройки группировок
// 
Процедура КоманднаяПанельСтрокиВКолонкиПеренестиВКолонки(Кнопка)
	Если ЭлементыФормы.ИзмеренияСтроки.ТекущиеДанные <> Неопределено Тогда
		ПутьКДанным = ЭлементыФормы.ИзмеренияСтроки.ТекущиеДанные.ПутьКДанным;
		ТипИзмерения = ЭлементыФормы.ИзмеренияСтроки.ТекущиеДанные.ТипИзмерения;
		ПостроительОтчета.ИзмеренияСтроки.Удалить(ПостроительОтчета.ИзмеренияСтроки.Найти(ЭлементыФормы.ИзмеренияСтроки.ТекущиеДанные.Имя));
		ПостроительОтчета.ИзмеренияКолонки.Добавить(ПутьКДанным, , ТипИзмерения);
	КонецЕсли;
КонецПроцедуры // КоманднаяПанельСтрокиВКолонкиПеренестиВКолонки()

// Процедура - обработчик нажатия кнопки < (перенести в строки) на панели настройки группировок
// 
Процедура КоманднаяПанельСтрокиВКолонкиПеренестиВСтроки(Кнопка)
	Если ЭлементыФормы.ИзмеренияКолонки.ТекущиеДанные <> Неопределено Тогда
		ПутьКДанным = ЭлементыФормы.ИзмеренияКолонки.ТекущиеДанные.ПутьКДанным;
		ТипИзмерения = ЭлементыФормы.ИзмеренияКолонки.ТекущиеДанные.ТипИзмерения;
		ПостроительОтчета.ИзмеренияКолонки.Удалить(ПостроительОтчета.ИзмеренияКолонки.Найти(ЭлементыФормы.ИзмеренияКолонки.ТекущиеДанные.Имя));
		ПостроительОтчета.ИзмеренияСтроки.Добавить(ПутьКДанным, , ТипИзмерения);
	КонецЕсли;
КонецПроцедуры // КоманднаяПанельСтрокиВКолонкиПеренестиВСтроки()

////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ ЭЛЕМЕНТОВ ДИАЛОГА

// закладка Общие

// Процедура - обработчик нажатия кнопки настройки периода.
//
Процедура КнопкаНастройкаПериодаНажатие(Элемент)
	
	НП = Новый НастройкаПериода;
	НП.УстановитьПериод(ДатаНач, ДатаКон);
	Если НП.Редактировать() Тогда
		ДатаНач = НП.ПолучитьДатуНачала();
		ДатаКон = НП.ПолучитьДатуОкончания();
	КонецЕсли;

КонецПроцедуры // КнопкаНастройкаПериодаНажатие()

// Процедура - обработчик нажатия кнопки "+" периода
//
Процедура ПлюсПериодНажатие(Элемент)
	ДатаНач = КонецМесяца(ДатаНач) + 1;
КонецПроцедуры

Процедура МинусПериодНажатие(Элемент)
	ДатаНач = НачалоМесяца(ДатаНач - 1);
КонецПроцедуры

// Процедура - обработчик изменения раздела учета.
//
Процедура ИмяРегистраПриИзменении(Элемент)

	Заголовок = мНазваниеОтчета;

	Состояние(НСтр("ru='Заполнение по умолчанию';uk='Заповнення по умовчанню'"));
	ЗаполнитьНачальныеНастройки();
	ЗаполнитьДиалогПоОбъекту();
	Оповестить("ИзмененоИмяРегистра",,ЭтаФорма);
	
КонецПроцедуры // ПолеВыбораИмяРегистраПриИзменении()

// Процедура - обработчик изменения флажка "Использовать свойства и категории".
//
Процедура ИспользоватьСвойстваИКатегорииПриИзменении(Элемент)

	// Запоминаем текущую настройку
	Настройки = ПостроительОтчета.ПолучитьНастройки(Истина, Истина, Истина, Истина);
	ТабПоказатели = Показатели.Выгрузить();

	// Перезаполнение объекта (с новым текстом запроса)
	Если мВыбиратьИмяРегистра Тогда
		ЗаполнитьНачальныеНастройки();
	Иначе
		ВладелецФормы.ЭтотОтчет.ЗаполнитьНачальныеНастройки();
	КонецЕсли;

	// Восстанавливаем запомненную настройку
	ПостроительОтчета.УстановитьНастройки(Настройки, Истина, Истина, Истина, Истина);
	
	Для Каждого Показатель Из Показатели Цикл
		НайдСтр = ТабПоказатели.Найти(Показатель.Имя, "Имя");
		Если НайдСтр<>Неопределено Тогда
			Показатель.Использование = НайдСтр.Использование;
		КонецЕсли; 
	КонецЦикла;

	Оповестить("ИзмененТекстЗапроса", , ЭтаФорма);
	
КонецПроцедуры // ИспользоватьСвойстваИКатегорииПриИзменении()

// закладка Отбор

// Процедура - обработчик начала выбора значения отбора
//
Процедура ОтборЗначениеНачалоВыбора(Элемент, СтандартнаяОбработка)

	// Отборы по свойствам и категориям должны быть обработаны специальным образом
	// Они определяются по представлению 
	Если Найти(НРег(ЭлементыФормы.Отбор.ТекущаяСтрока.Представление), "категории") Тогда

		// Ограничение списка категорий
		Назначение = мСоответствиеНазначений.Получить(ЭлементыФормы.Отбор.ТекущаяСтрока.Представление);

		УправлениеОтчетами.ОсуществитьВыборКатегории(Элемент, Назначение, ЭтаФорма, СтандартнаяОбработка);

	ИначеЕсли Найти(НРег(ЭлементыФормы.Отбор.ТекущаяСтрока.Представление), "св-во") Тогда

		Свойство = мСоответствиеНазначений.Получить(ЭлементыФормы.Отбор.ТекущаяСтрока.Представление);

		УправлениеОтчетами.ОсуществитьВыборСвойства(Элемент, Свойство, ЭтаФорма, СтандартнаяОбработка);

	КонецЕсли;
		
КонецПроцедуры // ОтборЗначениеНачалоВыбора()

// Процедура - обработчик перед удалением строки отбора
//
Процедура ОтборПередУдалением(Элемент, Отказ)
	
	Если Не ПустаяСтрока(Элемент.ТекущаяСтрока.Имя) Тогда
		Отказ = Истина;
	КонецЕсли; 
	
КонецПроцедуры // ОтборПередУдалением()

// закладка ИнтервалыГруппировок

Процедура ИнтервальноеПолеПриИзменении(Элемент)
	
	ОтобратьИнтервалы();
	ЭлементыФормы.ОтобранныеИнтервалы.ТолькоПросмотр = НЕ ЗначениеЗаполнено(ИнтервальноеПоле);
	
КонецПроцедуры

Процедура ОтобранныеИнтервалыПослеУдаления(Элемент)
	ОтобранныеИнтервалы.Сортировать("ВГраница");
КонецПроцедуры

Процедура ОтобранныеИнтервалыПриОкончанииРедактирования(Элемент, НоваяСтрока, ОтменаРедактирования)
	ОтобранныеИнтервалы.Сортировать("ВГраница");
КонецПроцедуры

Процедура ОтобранныеИнтервалыВГраницаПриИзменении(Элемент)
	тз=ОтобранныеИнтервалы.Скопировать();
	НоваяСтрока=тз.Добавить();
	НоваяСтрока.ВГраница=Элемент.Значение;
	тз.Свернуть("ВГраница");
	тз.Сортировать("ВГраница");
	Стр=тз.Найти(Элемент.Значение);
	Если Тз.Индекс(Стр)>0 Тогда
		НачЗначение = тз[Тз.Индекс(Стр)-1].Вграница;
	Иначе
		НачЗначение = "";
	КонецЕсли;
	КонЗначение=Элемент.Значение;
	ЭлементыФормы.ОтобранныеИнтервалы.ТекущаяСтрока.Название = "" + НачЗначение + ".." + КонЗначение;
	
	Если Тз.Индекс(Стр)>0 И Тз.Индекс(Стр)<тз.Количество()-1 Тогда
		НачЗначение = Элемент.Значение;
		КонЗначение = тз[Тз.Индекс(Стр)+1].Вграница;
		ОтобранныеИнтервалы.Найти(тз[Тз.Индекс(Стр)+1].Вграница).Название="" + НачЗначение + ".." + КонЗначение
	КонецЕсли;
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////

Если мВыбиратьИмяРегистра <> Ложь Тогда
	
	// Список доступных регистров для универсального отчета
	ЭлементыФормы.ИмяРегистра.СписокВыбора = УправлениеОтчетами.ПолучитьСписокРегистровНакопления();
	
КонецЕсли;

Если ИспользоватьИнтервальныеГруппировки Тогда
	
	Для Инд=0 По ПостроительОтчета.ДоступныеПоля.Количество()-1 Цикл
		Поле=ПостроительОтчета.ДоступныеПоля[Инд];
		Если Поле.Измерение Тогда
			Если Прав(Поле.Имя,2)="ИН" Тогда
				ЭлементыФормы.ИнтервальноеПоле.СписокВыбора.Добавить(Поле.Имя, Поле.Представление);
			КонецЕсли;
		КонецЕсли;
	КонецЦикла;
	
	// Начальная иниц.
	Для Инд=0 По ПостроительОтчета.ИзмеренияСтроки.Количество()-1 Цикл
		Измерение=ПостроительОтчета.ИзмеренияСтроки[Инд];
		
		НайдСтр=ЭлементыФормы.ИнтервальноеПоле.СписокВыбора.НайтиПоЗначению(Измерение.ПутьКДанным);
		Если НЕ НайдСтр=Неопределено Тогда
			ИнтервальноеПоле=НайдСтр.Значение;
			ОтобратьИнтервалы(); 
			Прервать;
		КонецЕсли;
		
	КонецЦикла;
	
КонецЕсли;
