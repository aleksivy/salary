Перем мОбработкаТайпингаВидаКИ;
Перем мТекстТайпингаВидаКИ;
Перем мПоследнееЗначениеЭлементаТайпингаВидаКИ;

Перем мКнопкаРедактироватьКИВДиалоге;

////////////////////////////////////////////////////////////////////////////////
// СЛУЖЕБНЫЕ ПРОЦЕДУРЫ И ФУНКЦИИ

Функция ВыделитьСлово(ИсходнаяСтрока)
	
	Буфер = СокрЛ(ИсходнаяСтрока);
	ПозицияПослПробела = Найти(Буфер, " ");

	Если ПозицияПослПробела = 0 Тогда
		ИсходнаяСтрока = "";
		Возврат Буфер;
	КонецЕсли;
	
	ВыделенноеСлово = СокрЛП(Лев(Буфер, ПозицияПослПробела));
	ИсходнаяСтрока = Сред(ИсходнаяСтрока, ПозицияПослПробела + 1);
	
	Возврат ВыделенноеСлово;
	
КонецФункции

// Процедура считывает данные о ФИО ПБОЮЛа
//
// Параметры: 
//  Нет.
//
// Возвращаемое значение:
//  Нет.
//
Процедура ОбновитьФИО()

	Запрос = Новый Запрос();
	Запрос.УстановитьПараметр("Ссылка",Ссылка);

	Запрос.Текст = "ВЫБРАТЬ
	               |	ФИОФизЛицСрезПоследних.Имя,
	               |	ФИОФизЛицСрезПоследних.Отчество,
	               |	ФИОФизЛицСрезПоследних.Фамилия,
	               |	ФИОФизЛицСрезПоследних.ФизЛицо КАК ФизЛицоФИО
	               |ИЗ
	               |	Справочник.Организации КАК Организации
	               |		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.ФИОФизЛиц.СрезПоследних(, ФизЛицо = &Ссылка) КАК ФИОФизЛицСрезПоследних
	               |		ПО Организации.Ссылка = ФИОФизЛицСрезПоследних.ФизЛицо
	               |
	               |ГДЕ
	               |	Организации.Ссылка = &Ссылка";
	Выборка = Запрос.Выполнить().Выбрать();
	Если Выборка.Следующий() Тогда
		Если Выборка.ФизЛицоФИО <> Неопределено Тогда
			Фамилия = Выборка.Фамилия;
			Имя = Выборка.Имя;
			Отчество = Выборка.Отчество;
		КонецЕсли;
	КонецЕсли;

КонецПроцедуры // ПрочитатьпреобразуемыеДанные

Функция ПолучитьПредставлениеСпособаОтражения(СпособОтражения) Экспорт
	
	Если Не СпособОтражения.Предопределенный Тогда
		
		// для не предопределенных способов отражения возвращаем наименование способа,
		//как пользователь задал его в справочнике
		Возврат СпособОтражения.Наименование+"(Дт" + СпособОтражения.СчетДт + " Кт" + СпособОтражения.СчетКт+")";
		
	Иначе
		
		//для предопределенных способов сформируем представление
		
		ПредставлениеСпособаОтражения = "Дт" + СпособОтражения.СчетДт + " Кт" + СпособОтражения.СчетКт;
		
		Возврат ПредставлениеСпособаОтражения;
		
	КонецЕсли;

КонецФункции

// Процедура получает из регистра сведений текущее отражение в учете
Процедура ПрочитатьОтражениеВУчете() Экспорт

	НадписьОтражениеВБухучете = "";
	
	ПроверятьОтражение = Не ЭтоНовый();
	
	Если ПроверятьОтражение Тогда
		
		Отбор = Новый Структура;
		Отбор.Вставить("Организация", Ссылка);
		
		СрезПоследних   = РегистрыСведений.УчетОсновногоЗаработкаОрганизации.СрезПоследних(ТекущаяДата(), Отбор);
		
		ЕстьОтражение = СрезПоследних.Количество() <> 0;
	Иначе
		ЕстьОтражение = Ложь;
	КонецЕсли;
	
	Если ЕстьОтражение Тогда // зарегистированы данные в регистре
		
		НадписьОтражениеВБухучете = НСтр("ru='С ';uk='З '") + Формат(СрезПоследних[0].Период, "ДЛФ=DD") + НСтр("ru=' зарплата сотрудников отражается как:';uk=' зарплата співробітників відображається як:'") + Символы.ПС;
		//добавим представление способа отражения по умолчанию
		НадписьОтражениеВБухучете = НадписьОтражениеВБухучете + ПолучитьПредставлениеСпособаОтражения(СрезПоследних[0].СпособОтраженияВБухучете) + Символы.ПС;
		
				
		Если ЗначениеЗаполнено(СрезПоследних[0].СпособОтраженияВБухучете) Тогда
			                                                                                 
			НадписьОтражениеВБухучете = НСтр("ru='С ';uk='З '") + Формат(СрезПоследних[0].Период, "ДЛФ=DD") + НСтр("ru=' зарплата сотрудников отражается как:';uk=' зарплата співробітників відображається як:'") + Символы.ПС;
			//добавим представление способа отражения по умолчанию
			НадписьОтражениеВБухучете = НадписьОтражениеВБухучете + ПолучитьПредставлениеСпособаОтражения(СрезПоследних[0].СпособОтраженияВБухучете);
			НадписьОтражениеВБухучете = НадписьОтражениеВБухучете + Символы.ПС;
			
		Иначе // зарегистрирован пустой способ отражения
			
			НадписьОтражениеВБухучете = НСтр("ru='С ';uk='З '") + Формат(СрезПоследних[0].Период, "ДЛФ=DD") + НСтр("ru=' зарплата сотрудников отражается способом по умолчанию:';uk=' зарплата співробітників відображається способом по умовчанню:'") + Символы.ПС;
			//добавим представление способа отражения по умолчанию
			НадписьОтражениеВБухучете = НадписьОтражениеВБухучете + ПолучитьПредставлениеСпособаОтражения(Справочники.СпособыОтраженияЗарплатыВРеглУчете.ОтражениеНачисленийПоУмолчанию) + Символы.ПС;
			
		КонецЕсли;
		
	Иначе 
		
		НадписьОтражениеВБухучете = НСтр("ru='Зарплата сотрудников отражается способом по умолчанию:';uk='Зарплата співробітників відображається способом по умовчанню:'") + Символы.ПС;
		//добавим представление способа отражения по умолчанию
		НадписьОтражениеВБухучете = НадписьОтражениеВБухучете + ПолучитьПредставлениеСпособаОтражения(Справочники.СпособыОтраженияЗарплатыВРеглУчете.ОтражениеНачисленийПоУмолчанию) + Символы.ПС;
		
	КонецЕсли;
	
	ЭлементыФормы.НадписьОтражениеВБухучете.Заголовок = НадписьОтражениеВБухучете;

КонецПроцедуры // ПрочитатьОтражениеВУчете() 


////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ ФОРМЫ

// Обработчик события ПриОткрытии формы.
//
Процедура ПриОткрытии()
	
	
	// Контактная информация
	мКнопкаРедактироватьКИВДиалоге = ЭлементыФормы.КоманднаяПанельКонтактнаяИнформация.Кнопки.РедактироватьВДиалоге;
	
	НажатиеКнопки = ВосстановитьЗначение("РедактироватьКИВДиалоге");
	Если ТипЗнч(НажатиеКнопки) = Тип("Булево") Тогда
		мКнопкаРедактироватьКИВДиалоге.Пометка = НажатиеКнопки;
	КонецЕсли; 
	
	ОбновитьФИО();
	
	// Установка списка выбора головных организаций
	ЭлементыФормы.ГоловнаяОрганизация.СписокВыбора = ПроцедурыУправленияПерсоналом.ПолучитьСписокГоловныхОрганизаций();
	// Исключим редактируемую организацию из списка головных
	НайдЭлемент = ЭлементыФормы.ГоловнаяОрганизация.СписокВыбора.НайтиПоЗначению(Ссылка);
    Если НайдЭлемент <> Неопределено Тогда
		ЭлементыФормы.ГоловнаяОрганизация.СписокВыбора.Удалить(НайдЭлемент);
	КонецЕсли;
	
	ПрочитатьОтражениеВУчете();
	
КонецПроцедуры

// Обработчик события ПриЗакрытии формы.
//
Процедура ПриЗакрытии()
	
	// Контактная информация
	СохранитьЗначение("РедактироватьКИВДиалоге", мКнопкаРедактироватьКИВДиалоге.Пометка);
	
КонецПроцедуры

Процедура ПередОткрытием(Отказ, СтандартнаяОбработка)
	
	Если ЭтоНовый()
	   И ЗначениеЗаполнено(ПараметрОбъектКопирования) Тогда
		УправлениеКонтактнойИнформацией.ПрочитатьКонтактнуюИнформацию(НаборКонтактнойИнформации, ПараметрОбъектКопирования);
		//ПрочитатьПраваДоступаКОбъекту(ПраваДоступаПользователей, ПараметрОбъектКопирования);
	Иначе
		УправлениеКонтактнойИнформацией.ПрочитатьКонтактнуюИнформацию(НаборКонтактнойИнформации, Ссылка);
		//ПрочитатьПраваДоступаКОбъекту(ПраваДоступаПользователей, Ссылка);
	КонецЕсли; 
	
КонецПроцедуры

// Обработчик события ПриЗаписи формы.
//
Процедура ПриЗаписи(Отказ)
	
 	Если ЮрФизЛицо = Перечисления.ЮрФизЛицо.ФизЛицо Тогда
 		РегламентированнаяОтчетность.ЗаписатьДанныеФИОВРегистр(Ссылка, Фамилия, Имя, Отчество);
 	Иначе  // для юрлица очистим записи в рег-ре
 		НаборФИО = РегистрыСведений.ФИОФизЛиц.СоздатьНаборЗаписей();
 		НаборФИО.Отбор.ФизЛицо.Значение = Ссылка;
 		НаборФИО.Отбор.ФизЛицо.Использование = Истина;
 		НаборФИО.Записать();
 	КонецЕсли;

	
	
	УправлениеКонтактнойИнформацией.ЗаписатьКонтактнуюИнформацию(НаборКонтактнойИнформации, Ссылка, Отказ);
	
	//ЗаписатьПраваДоступаКОбъекту(ПраваДоступаПользователей, Ссылка, Отказ);

	
КонецПроцедуры


// Процедура - обработчик пришедшего оповещения.
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)

	Если ИмяСобытия = "ОбновитьФорму" и (Источник = Ссылка или (ТипЗнч(Источник) = Тип("СправочникСсылка.Организации") и Источник.Пустая())) Тогда
		ИмяОбновляемогоЭлемента = Параметр.ИмяЭлемента;

		Если ИмяОбновляемогоЭлемента = "ФИО" Тогда
			ОбновитьФио();
		КонецЕсли;
	ИначеЕсли ИмяСобытия = "ЗаписанаКИ" И ТипЗнч(Параметр) = Тип("Структура") Тогда
		
		// Контактная информация
		Если ЭлементыФормы.КонтактнаяИнформация.ТекущиеДанные <> Неопределено
		   И ЭлементыФормы.КонтактнаяИнформация.ТекущиеДанные.Вид = Параметр.Вид
		   И ЭлементыФормы.КонтактнаяИнформация.ТекущиеДанные.Тип = Параметр.Тип Тогда
		
			УправлениеКонтактнойИнформацией.УстановитьВозможностьРедактированияТекстаКИ(ЭлементыФормы.КонтактнаяИнформация);
		
		КонецЕсли; 
	
	ИначеЕсли ИмяСобытия = "ОбновитьНадписьОтражениеВБухучете" И (Источник = ЭтаФорма) Тогда
		ПрочитатьОтражениеВУчете();
		
	КонецЕсли;
	
КонецПроцедуры


////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ ЭЛЕМЕНТОВ ФОРМЫ

Процедура НадписьОтражениеВБухучетеИзменитьНажатие(Элемент)
	
	Отказ = Ложь;

	Если ЭтоНовый() Тогда
		Вопрос = НСтр("ru='Перед заданием бухучета зарплаты необходимо записать организацию. Записать?';uk='Перед заданням бухобліку зарплати необхідно записати організацію. Записати?'");
		Ответ  = Вопрос(Вопрос, РежимДиалогаВопрос.ОКОтмена);
		Если Ответ = КодВозвратаДиалога.ОК Тогда
			Попытка
				Отказ = Не ЗаписатьВФорме();
			Исключение
				ОбщегоНазначения.СообщитьОбОшибке(НСтр("ru='Не удалось записать элемент!';uk='Не вдалося записати елемент!'"));
				Отказ = Истина;
			КонецПопытки;
		Иначе
			Отказ = Истина;
		КонецЕсли;
	КонецЕсли;

	Если Не Отказ Тогда
		ФормаРегистра = РегистрыСведений.УчетОсновногоЗаработкаОрганизации.ПолучитьФормуСписка("ФормаСпискаОтборПоОрганизации", ЭтаФорма, Элемент);
		ФормаРегистра.РегистрСведенийСписок.Отбор.Организация.Установить(Ссылка);
		ФормаРегистра.ЭлементыФормы.РегистрСведенийСписок.НачальноеОтображениеСписка = НачальноеОтображениеСписка.Конец;
		ФормаРегистра.Заголовок = НСтр("ru='Бухучет зарплаты сотрудников организации ';uk='Бухоблік зарплати співробітників організації '") +СОКРЛП(Наименование);
		ФормаРегистра.Открыть();
	КонецЕсли;
	
КонецПроцедуры

// Обработчик события НачалоВыбора элемента формы ОсновнойБанковскийСчет.
//
Процедура ОсновнойБанковскийСчетНачалоВыбора(Элемент, СтандартнаяОбработка)
	
	СтандартнаяОбработка = РаботаСДиалогами.ЗаписатьНовыйОбъектВФорме(ЭтаФорма);
	
КонецПроцедуры


// Обработчик события НачалоВыбора элемента формы БанковскийСчетДляРасчетовСФСС.
//
Процедура БанковскийСчетДляРасчетовСФССНачалоВыбора(Элемент, СтандартнаяОбработка)
	
	СтандартнаяОбработка = РаботаСДиалогами.ЗаписатьНовыйОбъектВФорме(ЭтаФорма);
	
КонецПроцедуры

Процедура КоманднаяПанельФормыПрава(Кнопка)
	
	Если НЕ РаботаСДиалогами.ЗаписатьНовыйОбъектВФорме(ЭтаФорма) Тогда
		Возврат;
	КонецЕсли;
	
	НастройкаПравДоступа.РедактироватьПраваДоступа(Ссылка);
	
КонецПроцедуры

///////////////////////////////////////////////////////////////////////////////
// ПРОЦЕДУРЫ МЕХАНИЗМА КОНТАКТНОЙ ИНФОРМАЦИИ

// Обработчик события Нажатие элемента формы КоманднаяПанельКонтактнойИнформации.РедактироватьВДиалоге.
//
Процедура КоманднаяПанельКонтактнойИнформацииРедактироватьВДиалоге(Кнопка)
	
	Кнопка.Пометка = НЕ Кнопка.Пометка;
	
КонецПроцедуры

// Обработчик события Нажатие элемента формы КоманднаяПанельКонтактнойИнформации.УстановитьОсновным.
//
Процедура КоманднаяПанельКонтактнаяИнформацияУстановитьОсновным(Кнопка)
	
	УправлениеКонтактнойИнформацией.УстановитьЗаписьОсновной(НаборКонтактнойИнформации, ЭлементыФормы.КонтактнаяИнформация, Кнопка);
	
КонецПроцедуры

// Обработчик события ПриНачалеРедактирования элемента формы КонтактнаяИнформация.
//
Процедура КонтактнаяИнформацияПриНачалеРедактирования(Элемент, НоваяСтрока)
	
	УправлениеКонтактнойИнформацией.КонтактнаяИнформацияПриНачалеРедактированияОбщая(Элемент, НоваяСтрока, мПоследнееЗначениеЭлементаТайпингаВидаКИ);
	
КонецПроцедуры

// Обработчик события НачалоВыбора элемента формы КонтактнаяИнформация.Представление.
//
Процедура КонтактнаяИнформацияПредставлениеНачалоВыбора(Элемент, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	Обработки.РедактированиеКонтактнойИнформации.Создать().РедактироватьЗапись(ЭлементыФормы.КонтактнаяИнформация.ТекущиеДанные,, ЭтаФорма);
	
КонецПроцедуры

// Обработчик события Очистка элемента формы КонтактнаяИнформация,Тип.
//
Процедура КонтактнаяИнформацияТипОчистка(Элемент, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
КонецПроцедуры

// Обработчик события НачалоВыбора элемента формы КонтактнаяИнформация.Вид.
//
Процедура КонтактнаяИнформацияВидНачалоВыбора(Элемент, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	УправлениеКонтактнойИнформацией.ОткрытьФормуВыбораВидаКИ(Истина, Элемент, ЭлементыФормы.КонтактнаяИнформация.ТекущиеДанные.Тип, УправлениеКонтактнойИнформацией.ВидОбъектаКИ(Ссылка));
	
КонецПроцедуры

// Обработчик события ПриИзменении элемента формы КонтактнаяИнформация.Вид.
//
Процедура КонтактнаяИнформацияВидПриИзменении(Элемент)
	
	Если Элемент.Значение = Неопределено Тогда
		Элемент.Значение = Справочники.ВидыКонтактнойИнформации.ПустаяСсылка();
	КонецЕсли; 
	
	мПоследнееЗначениеЭлементаТайпингаВидаКИ = Элемент.Значение;
	
КонецПроцедуры

// Обработчик события АвтоПодборТекста элемента формы КонтактнаяИнформация.Вид.
//
Процедура КонтактнаяИнформацияВидАвтоПодборТекста(Элемент, Текст, ТекстАвтоПодбора, СтандартнаяОбработка)
	
	ПроцедурыПоискаПоСтроке.АвтоПодборТекстаВЭлементеУправления(Элемент, Текст, ТекстАвтоПодбора, СтандартнаяОбработка, Новый Структура("Тип, ВидОбъектаКонтактнойИнформации", ЭлементыФормы.КонтактнаяИнформация.ТекущиеДанные.Тип, УправлениеКонтактнойИнформацией.ВидОбъектаКИ(Ссылка)), Тип("СправочникСсылка.ВидыКонтактнойИнформации"));
	
КонецПроцедуры

// Обработчик события ОкончаниеВводаТекста элемента формы КонтактнаяИнформация.Вид.
//
Процедура КонтактнаяИнформацияВидОкончаниеВводаТекста(Элемент, Текст, Значение, СтандартнаяОбработка)
	
	ПроцедурыПоискаПоСтроке.ОкончаниеВводаТекстаВЭлементеУправления(Элемент, Текст, Значение, СтандартнаяОбработка, Новый Структура("Тип, ВидОбъектаКонтактнойИнформации", ЭлементыФормы.КонтактнаяИнформация.ТекущиеДанные.Тип, УправлениеКонтактнойИнформацией.ВидОбъектаКИ(Ссылка)), ЭтаФорма, Тип("СправочникСсылка.ВидыКонтактнойИнформации"), мОбработкаТайпингаВидаКИ, мТекстТайпингаВидаКИ, мПоследнееЗначениеЭлементаТайпингаВидаКИ);
	
КонецПроцедуры

// Обработчик события ПередОкончаниемРедактирования элемента формы КонтактнаяИнформация.
//
Процедура КонтактнаяИнформацияПередОкончаниемРедактирования(Элемент, НоваяСтрока, ОтменаРедактирования, Отказ)
	
	УправлениеКонтактнойИнформацией.КонтактнаяИнформацияПередОкончаниемРедактированияОбщая(Элемент, НоваяСтрока, ОтменаРедактирования, Отказ, мТекстТайпингаВидаКИ, мОбработкаТайпингаВидаКИ);
	
КонецПроцедуры

// Обработчик события ПриИзменении элемента формы КонтактнаяИнформация.Представление.
//
Процедура КонтактнаяИнформацияПредставлениеПриИзменении(Элемент)
	
	УправлениеКонтактнойИнформацией.КонтактнаяИнформацияПредставлениеПриИзмененииОбщая(Элемент, ЭлементыФормы.КонтактнаяИнформация);
	
КонецПроцедуры

// Обработчик события ПриАктивизацииСтроки элемента формы КонтактнаяИнформация.
//
Процедура КонтактнаяИнформацияПриАктивизацииСтроки(Элемент)
	
	УправлениеКонтактнойИнформацией.КонтактнаяИнформацияПриАктивизацииСтрокиТаблицы(Элемент, ЭлементыФормы.КоманднаяПанельКонтактнаяИнформация.Кнопки.УстановитьОсновным);
	
КонецПроцедуры

// Обработчик события ПриВыводеСтроки элемента формы КонтактнаяИнформация.
//
Процедура КонтактнаяИнформацияПриВыводеСтроки(Элемент, ОформлениеСтроки, ДанныеСтроки)
	
	УправлениеКонтактнойИнформацией.КонтактнаяИнформацияСписокПриВыводеСтроки(Элемент, ОформлениеСтроки, ДанныеСтроки);
	
КонецПроцедуры

// Обработчик события ПередУдалением элемента формы КонтактнаяИнформация.
//
Процедура КонтактнаяИнформацияПередУдалением(Элемент, Отказ)

	УправлениеКонтактнойИнформацией.УдалитьЗаписьКонтактнойИнформации(Элемент, Отказ);
	
КонецПроцедуры

// Обработчик события ПередНачаломДобавления элемента формы КонтактнаяИнформация.
//
Процедура КонтактнаяИнформацияПередНачаломДобавления(Элемент, Отказ, Копирование)
	
	УправлениеКонтактнойИнформацией.КонтактнаяИнформацияПередНачаломДобавленияОбщее(Элемент, Отказ, Копирование, мКнопкаРедактироватьКИВДиалоге, ЭлементыФормы.КонтактнаяИнформация, НаборКонтактнойИнформации, Ложь);
	
КонецПроцедуры

// Обработчик события ПередНачаломИзменения элемента формы КонтактнаяИнформация.
//
Процедура КонтактнаяИнформацияПередНачаломИзменения(Элемент, Отказ)
	
	УправлениеКонтактнойИнформацией.КонтактнаяИнформацияПередНачаломИзмененияОбщее(Элемент, Отказ, мКнопкаРедактироватьКИВДиалоге, Ложь);
	
КонецПроцедуры

// Обработчик события ПриИзменении элемента формы КонтактнаяИнформация.Тип.
//
Процедура КонтактнаяИнформацияТипПриИзменении(Элемент)
	
	УправлениеКонтактнойИнформацией.КонтактнаяИнформацияТипПриИзмененииОбщее(Элемент, ЭлементыФормы.КонтактнаяИнформация);
	
КонецПроцедуры


////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ ЭЛЕМЕНТОВ УПРАВЛЕНИЯ КОМАНДНОЙ ПАНЕЛИ КОНТАКТНОЙ ИНФОРМАЦИИ

// Процедура открывает для редактирования форму списка регистра сведений, хранящего ФИО физлиц
Процедура КнопкаВызоваДанныхФИОНажатие(Элемент)

	Если ЭтоНовый() Тогда
		Ответ = Вопрос(НСтр("ru='Перед переходом к дополнительным данным о физ. лице необходимо записать элемент. Записать?';uk='Перед переходом до додаткових даних про фіз. особу необхідно записати елемент. Записати?'"), РежимДиалогаВопрос.ДаНет);
		Если Ответ = КодВозвратаДиалога.Да Тогда
 			Отказ = Не ЗаписатьВФорме();
 		Иначе
 			Отказ = Истина;
 		КонецЕсли;
		Если Не Отказ Тогда
 			РегламентированнаяОтчетность.ЗаписатьДанныеФИОВРегистр(Ссылка, Фамилия, Имя, Отчество);
		Иначе
			Возврат;
		КонецЕсли;
	КонецЕсли;

	ФормаРегистра = РегистрыСведений.ФИОФизЛиц.ПолучитьФорму("ФормаЗаписи", ЭтаФорма);
	ФормаРегистра.Физлицо  = Ссылка;
		
	ТаблицаРегистра = РегистрыСведений.ФИОФизЛиц.СрезПоследних(, Новый Структура("ФизЛицо",Ссылка));

	Если ТаблицаРегистра.Количество() > 0 Тогда
		
		МЗ = РегистрыСведений.ФИОФизЛиц.СоздатьМенеджерЗаписи();
   		МЗ.Период   = ТаблицаРегистра[0].Период;
		МЗ.ФизЛицо   = Ссылка;
		МЗ.Прочитать();

		ФормаРегистра.РегистрСведенийМенеджерЗаписи = МЗ;
		
	Иначе
		ФормаРегистра.Период = '19000101';
	КонецЕсли;
	
	ФормаРегистра.Открыть();
	
КонецПроцедуры

Процедура НаименованиеПриИзменении(Элемент)
	
	Если ПустаяСтрока(НаименованиеПолное) Тогда
		НаименованиеПолное = Наименование;
	КонецЕсли;
	
	ФИО = Наименование;
	
	Если ПустаяСтрока(Фамилия)
	 ИЛИ ЭтоНовый() Тогда
		Фамилия  = ВыделитьСлово(ФИО);
		Имя      = ВыделитьСлово(ФИО);
		Отчество = ВыделитьСлово(ФИО);
	КонецЕсли;

КонецПроцедуры

Процедура ОбновлениеОтображения()
	
	Если (ЭлементыФормы.ПанельФИО.Свертка = РежимСверткиЭлементаУправления.Нет) <>
		(ЮрФизЛицо = Перечисления.ЮрФизЛицо.ФизЛицо) Тогда
		
		ЭтоФизЛицо = (ЮрФизЛицо = Перечисления.ЮрФизЛицо.ФизЛицо);
		ЭлементыФормы.ПанельФИО.Свертка = ?(ЭтоФизЛицо, РежимСверткиЭлементаУправления.Нет, РежимСверткиЭлементаУправления.Верх);
	КонецЕсли;
	
КонецПроцедуры

// Обработчик события "ПослеЗаписи"
//
Процедура ПослеЗаписи()
	
	ЗаполнениеУчетнойПолитикиПоПерсоналуОрганизации();
	
 	глПодключитьМенеджерЗвит1С(Ложь);
	
КонецПроцедуры

Процедура ДействияФормыФайлы(Кнопка)

	Отказ = Ложь;

	Если ЭтоНовый() Тогда
		Вопрос = НСтр("ru='Перед вводом файлов и изображений необходимо записать элемент. Записать?';uk='Перед введенням файлів і зображень необхідно записати елемент. Записати?'");
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



мОбработкаТайпингаВидаКИ                 = Ложь;
мТекстТайпингаВидаКИ                     = "";
мПоследнееЗначениеЭлементаТайпингаВидаКИ = Неопределено;
