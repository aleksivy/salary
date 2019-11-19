﻿Перем мФизЛицо; // сохраняем физлицо, данные которого начинали редактировать

// Устанавливает доступность реквизитов, выполняет необходимую очистку 
//		значений в соответствии с логикой заполнения
Процедура УстановитьДоступность()

	Состав = Звание.Состав; // звание могло измениться
	ЭлементыФормы.Состав.Значение = Состав;
	
    Офицер		= (Состав = Перечисления.СоставыВоеннослужащих.МладшиеОфицеры
					или Состав = Перечисления.СоставыВоеннослужащих.СтаршиеОфицеры
					или Состав = Перечисления.СоставыВоеннослужащих.ВысшиеОфицеры);
    Призывник	= (ОтношениеКВоинскойОбязанности = Перечисления.ОтношениеКВоинскойОбязанности.Призывник);
	Состоит 	= не (ОтношениеКВоинскойОбязанности = Перечисления.ОтношениеКВоинскойОбязанности.НеВоеннообязанный
					или ОтношениеКВоинскомуУчету = Перечисления.ОтношениеКВоинскомуУчету.НеСостоит);
	Снят	 	= (ОтношениеКВоинскомуУчету = Перечисления.ОтношениеКВоинскомуУчету.СнятПоВозрасту
					или ОтношениеКВоинскомуУчету = Перечисления.ОтношениеКВоинскомуУчету.СнятПоСостояниюЗдоровья);
    Годен		= Годность = Перечисления.ГодностьКВоеннойСлужбе.Годен;

	ЭлементыФормы.Годность.Доступность
		= Состоит и (не Офицер) и (не Призывник);
	ЭлементыФормы.Звание.Доступность
		= Состоит и (не Призывник);
	ЭлементыФормы.ЗабронированОрганизацией.Доступность
		= Состоит и (не Призывник);
	ЭлементыФормы.НаличиеМобпредписания.Доступность
		= Состоит и (не Призывник);
	ЭлементыФормы.Военкомат.Доступность
		= Состоит;
	ЭлементыФормы.ВоенкоматФМП.Доступность
		= Состоит;
	ЭлементыФормы.ОснованиеНегодности.Доступность
		= Состоит и (((не Офицер) и (не Годен)) или (Офицер и Снят))  и (не Призывник);
	ЭлементыФормы.ВУС.Доступность
		= Состоит и (не Призывник);
	ЭлементыФормы.СпецУчет.Доступность
		= Состоит;
	ЭлементыФормы.Группа.Доступность
		= Состоит и (не Офицер) и (не Призывник);
	ЭлементыФормы.ГруппаДо2016.Доступность
		= Состоит и (не Офицер) и (не Призывник);
	ЭлементыФормы.Категория.Доступность
		= Состоит и (не Призывник);
	ЭлементыФормы.Профиль.Доступность
		= Состоит и Офицер и (не Призывник);
	ЭлементыФормы.ДатаИНомерПриказаОПризыве.Доступность = (ОтношениеКВоинскомуУчету = Перечисления.ОтношениеКВоинскомуУчету.ПризванНаВоинскуюСлужбу
		ИЛИ ОтношениеКВоинскомуУчету = Перечисления.ОтношениеКВоинскомуУчету.СлужбаПоКонтракту);
	ЭлементыФормы.СрокКонтракта.Доступность = (ОтношениеКВоинскомуУчету = Перечисления.ОтношениеКВоинскомуУчету.СлужбаПоКонтракту);
	
	Для каждого Ресурс Из Метаданные.РегистрыСведений.ВоинскийУчет.Ресурсы Цикл

		ИмяРесурса = Ресурс.Имя;

        // очистим неиспользуемые значения
		Если (не ЭлементыФормы[ИмяРесурса].Доступность) Тогда

			Если ТипЗнч(РегистрСведенийМенеджерЗаписи[ИмяРесурса]) = Тип("Булево") Тогда
				Если РегистрСведенийМенеджерЗаписи[ИмяРесурса] Тогда
			
					РегистрСведенийМенеджерЗаписи[ИмяРесурса] = Ложь;

				КонецЕсли;
			ИначеЕсли ЗначениеЗаполнено(РегистрСведенийМенеджерЗаписи[ИмяРесурса]) Тогда
			
				РегистрСведенийМенеджерЗаписи[ИмяРесурса] = NULL;
				
			КонецЕсли; 
		КонецЕсли; 

		// доступность надписей
		Если ТипЗнч(ЭлементыФормы[ИмяРесурса]) = Тип("ПолеВвода") Тогда
		
			ЭлементыФормы["Надпись"+ИмяРесурса].Доступность = ЭлементыФормы[ИмяРесурса].Доступность;
		
		КонецЕсли; 
	
	КонецЦикла;

	

КонецПроцедуры // УстановитьДоступность()


////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ ФОРМЫ

Процедура ПриОткрытии()
	
	Заголовок = НСтр("ru='Воинский учет физ. лица: ';uk='Військовий облік фіз. особи: '") + ФизЛицо.Наименование;
	мФизЛицо = ФизЛицо;
    УстановитьДоступность();
	
КонецПроцедуры

Процедура ПослеЗаписи()
	
	Оповестить("ОбновитьФорму", Новый Структура("ИмяЭлемента","ВоинскийУчет"), ФизЛицо);
	Если мФизЛицо <> ФизЛицо Тогда
        // оповестим также форму того физлица, данные которого начинали редактировать
		Оповестить("ОбновитьФорму", Новый Структура("ИмяЭлемента","ВоинскийУчет"), мФизЛицо);
		мФизЛицо = ФизЛицо;
	КонецЕсли;
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ ЭЛЕМЕНТОВ ФОРМЫ

Процедура ФизЛицоПриИзменении(Элемент)
	Заголовок = НСтр("ru='Воинский учет физ. лица: ';uk='Військовий облік фіз. особи: '") + Элемент.Значение.Наименование;
КонецПроцедуры

Процедура ЗваниеПриИзменении(Элемент)
	Состав = Звание.Состав;
	УстановитьДоступность();
КонецПроцедуры

Процедура ОтношениеКВоинскойОбязанностиПриИзменении(Элемент)
	УстановитьДоступность();
КонецПроцедуры

Процедура ОтношениеКВоинскомуУчетуПриИзменении(Элемент)
	УстановитьДоступность();
КонецПроцедуры

Процедура ГодностьПриИзменении(Элемент)
	УстановитьДоступность();
КонецПроцедуры
