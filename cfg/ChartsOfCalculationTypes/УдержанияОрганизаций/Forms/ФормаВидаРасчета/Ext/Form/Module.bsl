﻿////////////////////////////////////////////////////////////////////////////////
// ПЕРЕМЕННЫЕ МОДУЛЯ
// 
Перем мТабличнаяЧасть;

Перем мСписокВозможныхКатегорийРасчета;


////////////////////////////////////////////////////////////////////////////////
// ПРОЦЕДУРЫ И ФУНКЦИИ
// 

Процедура ОткрытьФормуПодбора(ИмяПВР)

	ФормаПодбора = ПланыВидовРасчета[ИмяПВР].ПолучитьФормуВыбора(, ЭтаФорма);
	ФормаПодбора.ЗакрыватьПриВыборе = Ложь;
	ФормаПодбора.Открыть();

КонецПроцедуры

// Управляет доступностью реквизитов формы
Процедура ОпределитьДоступностьРеквизитов()
	
	РасчетИмеетБазовыеНачисления = СпособРасчета = Перечисления.СпособыРасчетаОплатыТруда.Процентом
								Или СпособРасчета = Перечисления.СпособыРасчетаОплатыТруда.ИсполнительныйЛистПроцентом
								Или СпособРасчета = Перечисления.СпособыРасчетаОплатыТруда.ИсполнительныйЛистПроцентомДоПредела
								Или СпособРасчета = Перечисления.СпособыРасчетаОплатыТруда.АлиментыПроцентом
								Или СпособРасчета = Перечисления.СпособыРасчетаОплатыТруда.АлиментыПроцентомДоПредела
								Или СпособРасчета = Перечисления.СпособыРасчетаОплатыТруда.ИсполнителныйЛистСУчетомОграничения
								Или СпособРасчета = Перечисления.СпособыРасчетаОплатыТруда.ПочтовыйСбор
								Или СпособРасчета = Перечисления.СпособыРасчетаОплатыТруда.ИндексацияАлиментов;
								
	Если Не РасчетИмеетБазовыеНачисления Тогда
		Для Каждого СтрокаПоказателей Из Показатели Цикл
			Показатель = СтрокаПоказателей.Показатель;
			Если Показатель = Справочники.ПоказателиСхемМотивации.РасчетнаяБаза 
				ИЛИ Показатель = Справочники.ПоказателиСхемМотивации.РасчетнаяБазаВремяВДнях
				ИЛИ Показатель = Справочники.ПоказателиСхемМотивации.РасчетнаяБазаВремяВЧасах
				ИЛИ Показатель = Справочники.ПоказателиСхемМотивации.РасчетнаяБазаОплаченоДнейЧасов
				Тогда
				РасчетИмеетБазовыеНачисления = Истина;
				Прервать;
			КонецЕсли;
		КонецЦикла;
	КонецЕсли;

	ЭлементыФормы.ПанельСпискиВидовРасчета.Страницы.БазовыеВидыРасчетов.Видимость = РасчетИмеетБазовыеНачисления;
	
КонецПроцедуры

Процедура ОбновитьПредставлениеЭлемента(ИмяОбновляемогоЭлемента)
	
	Если ЗначениеЗаполнено(СпособОтраженияВБухучете) Тогда
		
		РасшифровкаОтражениеВБухучете = РаботаСДиалогами.ПолучитьПредставлениеСпособаОтраженияНачисленияВУчетах(СпособОтраженияВБухучете, Истина);
		
	Иначе
		
		ОписаниеНачисленияТекст = "Не указан способ отражения." + Символы.ПС;
		ОписаниеНастройкиТекст  = "При отражении в учете удержания счета дебета и кредита не будут заполнены.";

		РасшифровкаОтражениеВБухучете = ОписаниеНачисленияТекст + ОписаниеНастройкиТекст;
		
	КонецЕсли;
	
КонецПроцедуры


////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ ФОРМЫ

Процедура ПриОткрытии()
   	// Сформируем кнопку "Подбор" для ТЧ "БазовыеВидыРасчета"
	СтруктураДействий = Новый Структура;
	СтруктураДействий.Вставить("ПодМенюБазовыхВидовРасчета",Новый Действие("КоманднаяПанельБазовыеВидыРасчетаПодборПодМеню"));
	СтруктураДействий.Вставить("КнопкаБазовыхВидовРасчета",Новый Действие("КоманднаяПанельБазовыеВидыРасчетаПодбор"));
	РаботаСДиалогами.СоздатьКнопкуПодбораДляПВР(Ссылка, ЭтаФорма);
	
	Если ЭтоНовый() Тогда
		// Инициализация реквизитов для нового объекта
		Если НЕ ЗначениеЗаполнено(СпособРасчета) Тогда
			СпособРасчета		= Перечисления.СпособыРасчетаОплатыТруда.ФиксированнойСуммой;
		КонецЕсли;
		Если НЕ ЗначениеЗаполнено(КатегорияРасчета) Тогда
			КатегорияРасчета = Перечисления.КатегорииРасчетов.Первичное;
		КонецЕсли;
	КонецЕсли;
	// Доступные способы расчета
	СписокВариантовУдержаний = ПроведениеРасчетов.ПолучитьСписокВариантовУдержанийОрганизации();
	
	// Заполним реквизиты формы, обслуживающие работу переключателей
	ЭтоПервичноеУдержание = КатегорияРасчета = Перечисления.КатегорииРасчетов.Первичное;

	// Установим доступность ЭУ в зависимости от значений реквизиов
	ЭлементыФормы.ОчередностьРасчета.ТолькоПросмотр = ЭтоПервичноеУдержание;
	
	// Для предопределённых элементов запрещено редактирование способа расчета 
	ЭлементыФормы.СпособРасчетаУдержания.ТолькоПросмотр = Предопределенный ИЛИ ПроизвольнаяФормулаРасчета;
	ЭлементыФормы.ПроизвольнаяФормулаРасчета.Доступность = Не Предопределенный;
	ЭлементыФормы.ПроизвольнаяФормулаРасчета1.Доступность = Не Предопределенный;
	ЭлементыФормы.ЗадатьФормулу.Видимость = НЕ Предопределенный И ПроизвольнаяФормулаРасчета;

	// Доступные способы расчета
	ЭлементыФормы.СпособРасчетаУдержания.ДоступныеЗначения  = СписокВариантовУдержаний;
	ЭлементыФормы.СпособРасчетаУдержания.ВысотаСпискаВыбора = СписокВариантовУдержаний.Количество();
	Если СпособРасчета = Перечисления.СпособыРасчетаОплатыТруда.ПроизвольнаяФормула Тогда
		СпособРасчетаУдержания = Перечисления.СпособыРасчетаОплатыТруда.ПустаяСсылка();
		ЭлементыФормы.СпособРасчетаУдержания.ОтметкаНезаполненного = Ложь;
	Иначе
		СпособРасчетаУдержания = СпособРасчета;
	КонецЕсли;
	
	// Установим значение переключателя "ОчередностьНачисления" и список выбора для реквизита "КатегорияРасчета"
	мСписокВозможныхКатегорийРасчета = Новый СписокЗначений;
	мСписокВозможныхКатегорийРасчета.Добавить(Перечисления.КатегорииРасчетов.ЗависимоеПервогоУровня);
	мСписокВозможныхКатегорийРасчета.Добавить(Перечисления.КатегорииРасчетов.ЗависимоеВторогоУровня);
	мСписокВозможныхКатегорийРасчета.Добавить(Перечисления.КатегорииРасчетов.ЗависимоеТретьегоУровня);
	ЭлементыФормы.ОчередностьРасчета.ДоступныеЗначения = мСписокВозможныхКатегорийРасчета;
	Если мСписокВозможныхКатегорийРасчета.НайтиПоЗначению(КатегорияРасчета) = Неопределено Тогда
		ОчередностьРасчета = Перечисления.КатегорииРасчетов.ПустаяСсылка();
		ЭлементыФормы.ОчередностьРасчета.ОтметкаНезаполненного = Ложь;
	Иначе
		ОчередностьРасчета = мСписокВозможныхКатегорийРасчета.НайтиПоЗначению(КатегорияРасчета).Значение;
	КонецЕсли;
	
	Элементыформы.СпособРасчетаПредставление.УстановитьТекст(ПроведениеРасчетов.ВизуализироватьФормулуРасчета(ЭтотОбъект, "HTML"));
	
	// установим видимость панелей в описании формулы расчета
	РаботаСДиалогами.УстановитьОтборыИСверткуПоказателей(ЭлементыФормы, Показатели, ПроизвольнаяФормулаРасчета);
	
	// контекстно-зависимое управление видимостью страниц панелей
	ОпределитьДоступностьРеквизитов();
	
	ОбновитьПредставлениеЭлемента("ЗакладкаУчет");
	
КонецПроцедуры

Процедура ПриЗаписи(Отказ)

	// Проверка правильности настройки вида расчета
	РезультатПроверки = ПроведениеРасчетов.ПроверитьНастройкуВидаРасчета(ЭтотОбъект, Отказ, Ложь);
	Если не Отказ Тогда
		Если не ПустаяСтрока(РезультатПроверки) Тогда
			Ответ = Вопрос(РезультатПроверки + НСтр("ru=' Записать вид расчета?';uk=' Записати вид розрахунку?'"), РежимДиалогаВопрос.ДаНет, , КодВозвратаДиалога.Нет);
			// отказались от записи
			Отказ = Ответ <> КодВозвратаДиалога.Да;
		КонецЕсли;
	КонецЕсли;

	
КонецПроцедуры

Процедура ОбработкаВыбора(ЗначениеВыбора, Источник)
	
	Если мТабличнаяЧасть = "БазовыеВидыРасчета" Тогда
		
		Если БазовыеВидыРасчета.Найти(ЗначениеВыбора,"ВидРасчета") = Неопределено Тогда
			БазовыеВидыРасчета.Добавить().ВидРасчета = ЗначениеВыбора;
		КонецЕсли;
		
	КонецЕсли; 
	
КонецПроцедуры

Процедура ОчередностьРасчетаПриИзменении(Элемент)
	
	КатегорияРасчета = Элемент.Значение;
	
КонецПроцедуры

Процедура ОчередностьРасчетаНачалоВыбора(Элемент, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	ЭлементСписка = ВыбратьИзСписка(мСписокВозможныхКатегорийРасчета,Элемент,мСписокВозможныхКатегорийРасчета.НайтиПоЗначению(Элемент.Значение));
	Если ЭлементСписка <> Неопределено Тогда
		Элемент.Значение = ЭлементСписка.Значение;
		КатегорияРасчета = Элемент.Значение;
	КонецЕсли;

КонецПроцедуры

Процедура ПоказателиПередУдалением(Элемент, Отказ)
	Отказ = Истина;
КонецПроцедуры

Процедура ПоказателиПередНачаломДобавления(Элемент, Отказ, Копирование)
	Отказ = Истина;
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ КОМАНДНОЙ ПАНЕЛИ ТЧ БазовыеВидыРасчета

// Не является ошибкой проверки конфигурации - Обработчик устанавливается динамически методом "Действие"
// в процедуре "СоздатьКнопкуПодбораДляПВР" общего модуля "РаботаСДиалогами"
// 
Процедура КоманднаяПанельБазовыеВидыРасчетаПодборПодМеню(Кнопка)
	
	мТабличнаяЧасть = "БазовыеВидыРасчета";
	ОткрытьФормуПодбора(Кнопка.Имя);
	
КонецПроцедуры

// Не является ошибкой проверки конфигурации - Обработчик устанавливается динамически методом "Действие"
// в процедуре "СоздатьКнопкуПодбораДляПВР" общего модуля "РаботаСДиалогами"
// 
Процедура КоманднаяПанельБазовыеВидыРасчетаПодбор(Кнопка)
	
	мТабличнаяЧасть = "БазовыеВидыРасчета";
	ОткрытьФормуПодбора(Метаданные().Имя);
	
КонецПроцедуры

Процедура СпособОтраженияВБухучетеПриИзменении(Элемент)
	ОбновитьПредставлениеЭлемента("ЗакладкаУчет");
КонецПроцедуры

// Процедура - обработчик события изменения способа расчета
Процедура СпособРасчетаПриИзменении(Элемент)

	СпособРасчета = Элемент.Значение;
	
	ОпределитьДоступностьРеквизитов();
	
	Элементыформы.СпособРасчетаПредставление.УстановитьТекст(ПроведениеРасчетов.ВизуализироватьФормулуРасчета(ЭтотОбъект, "HTML"));
	
КонецПроцедуры

Процедура РегламентированныйСпособРасчетаПриИзменении(Элемент)
	
	ЭлементыФормы.СпособРасчетаУдержания.ТолькоПросмотр = ПроизвольнаяФормулаРасчета;
	ЭлементыФормы.ЗадатьФормулу.Видимость = НЕ Предопределенный И ПроизвольнаяФормулаРасчета;

	Если ПроизвольнаяФормулаРасчета Тогда
		СпособРасчета = Перечисления.СпособыРасчетаОплатыТруда.ПроизвольнаяФормула;
		мБылСпособРасчетаУдержания = СпособРасчетаУдержания; // запомним значение
		СпособРасчетаУдержания = Перечисления.СпособыРасчетаОплатыТруда.ПустаяСсылка();
		ЭлементыФормы.СпособРасчетаУдержания.ОтметкаНезаполненного = Ложь;
	Иначе
		СпособРасчетаУдержания = мБылСпособРасчетаУдержания; // восстановим предыдущее значение
		Если Не ЗначениеЗаполнено(СпособРасчетаУдержания) Тогда
			СпособРасчетаУдержания = Перечисления.СпособыРасчетаОплатыТруда.ФиксированнойСуммой;	
		КонецЕсли;
		СпособРасчета = СпособРасчетаУдержания;
		ЭлементыФормы.СпособРасчетаУдержания.ОтметкаНезаполненного = Не ЗначениеЗаполнено(СпособРасчетаУдержания);
	КонецЕсли;
	
	// установим описание формулы расчета
	Элементыформы.СпособРасчетаПредставление.УстановитьТекст(ПроведениеРасчетов.ВизуализироватьФормулуРасчета(ЭтотОбъект, "HTML"));
	// установим видимость панелей в описании формулы расчета
	РаботаСДиалогами.УстановитьОтборыИСверткуПоказателей(ЭлементыФормы, Показатели, ПроизвольнаяФормулаРасчета);
	
	ОпределитьДоступностьРеквизитов();
	
КонецПроцедуры

Процедура ОчередностьУдержанияПриИзменении(Элемент)
	
	ЭлементыФормы.ОчередностьРасчета.ТолькоПросмотр = ЭтоПервичноеУдержание;
	Если ЭтоПервичноеУдержание Тогда
		КатегорияРасчета = Перечисления.КатегорииРасчетов.Первичное;
		мБылаОчередностьРасчета = ОчередностьРасчета; // запомним значение
		ОчередностьРасчета = Перечисления.КатегорииРасчетов.ПустаяСсылка();
		ЭлементыФормы.ОчередностьРасчета.ОтметкаНезаполненного = Ложь;
	Иначе
		ОчередностьРасчета = мБылаОчередностьРасчета; // восстановим предыдущее значение
		Если Не ЗначениеЗаполнено(ОчередностьРасчета) Тогда
			ОчередностьРасчета = Перечисления.КатегорииРасчетов.ЗависимоеПервогоУровня;	
		КонецЕсли;
		КатегорияРасчета = ОчередностьРасчета;
		ЭлементыФормы.ОчередностьРасчета.ОтметкаНезаполненного = Не ЗначениеЗаполнено(ОчередностьРасчета);
	КонецЕсли;
	
КонецПроцедуры

Процедура ЗадатьФормулуНажатие(Элемент)
		
	РаботаСДиалогами.ОткрытьФормуРедактированияФормулы(ЭтаФорма, Показатели, Наименование, ФормулаРасчета, Ссылка, "ПлановыеУдержанияРаботниковОрганизаций");
	
КонецПроцедуры

Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
		
	Если ИмяСобытия = "ВводФормулыРасчета" и Источник = ЭтаФорма Тогда
		ПроведениеРасчетов.УстановитьПараметрыВидаРасчета(Параметр, ЭтотОбъект, Элементыформы);
		РаботаСДиалогами.УстановитьОтборыИСверткуПоказателей(ЭлементыФормы, Показатели, ПроизвольнаяФормулаРасчета);
		ОпределитьДоступностьРеквизитов();
		
	ИначеЕсли ИмяСобытия = "ПодборОтменаВыбора" Тогда
		СтруктураПоиска = Новый Структура;
		СтруктураПоиска.Вставить("ВидРасчета", Параметр);
		НайденныеСтроки = Источник.НайтиСтроки(СтруктураПоиска);
		
		Для Каждого ТекСтрока Из НайденныеСтроки Цикл
			Источник.Удалить(ТекСтрока);
		КонецЦикла;
		
	КонецЕсли;

КонецПроцедуры


// инициализируем списки выбора
// для СпособРасчета
Если ТипЗнч(ВладелецФормы) = Тип("Форма") Тогда
	
	// Этот элемент создан из формы выбора, у которой предустановлен отбор по способу расчета.
	// В элементе вида расчета создадим точно такой же список выбора.
	
	Если ТипЗнч(ВладелецФормы.Отбор.СпособРасчета.Значение) = Тип("СписокЗначений") Тогда
		ЭлементыФормы.СпособРасчетаУдержания.СписокВыбора = ВладелецФормы.Отбор.СпособРасчета.Значение
	Иначе
		ЭлементыФормы.СпособРасчетаУдержания.СписокВыбора = ПроведениеРасчетов.ПолучитьСписокВариантовУдержанийОрганизации();
	КонецЕсли; 
	
	
Иначе
	
		
КонецЕсли; 



