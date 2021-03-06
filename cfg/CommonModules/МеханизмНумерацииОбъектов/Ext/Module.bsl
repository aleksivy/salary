////////////////////////////////////////////////////////////////////////////////
// ПРОЦЕДУРЫ И ФУНКЦИИ МЕХАНИЗМА АВТОНУМЕРАЦИИ

// Процедура изменения доступности "ручного" изменения кода/номера объекта
//
// Параметры
//  МетаданныеОбъекта  - метаданные объекта.
//  ФормаОбъекта      - форма объекта.
//  ПодменюДействия - меню "Действия" командной панели формы. В этот меню должен присутствовать пункт "Редактировать код/номер"
//  ПолеВводаНомера - поле вводе, связанное с кодом/номером объекта
//	ПолеВводаНомераДубль - необязательный параметр, необходим в случаях, когда код/номер одновременно связан с двумя элементами формы
//	КодНомерСтрокой - необязательный параметр, позволяет задать переназначить имя кода/номера при выводе запроса на подтверждение
//
Процедура ИзменениеВозможностиРедактированияНомера(МетаданныеОбъекта, ФормаОбъекта, ПодменюДействия, ПолеВводаНомера, ПолеВводаНомераДубль = Неопределено, ТекстВопроса = "") Экспорт
	
	Кнопка = ПодменюДействия.Кнопки.РедактироватьКодНомер;
	Если НЕ Кнопка.Пометка Тогда
		
		Если ПустаяСтрока(ТекстВопроса) Тогда			
			Если ВРЕГ(ПолеВводаНомера.Данные) = ВРЕГ("Код") Тогда
				ТекстВопроса = НСтр("ru='Код присваивается автоматически при записи элемента, самостоятельное его редактирование может привести к нарушению в нумерации в системе. Вы действительно хотите установить код вручную?';uk='Код надається автоматично при записі елемента, самостійне його редагування може привести до порушення в нумерації в системі. Ви дійсно хочете встановити код вручну?'")
			Иначе
				ТекстВопроса = НСтр("ru='Номер документу присваивается автоматически при записи, самостоятельное его редактирование может привести к нарушению в нумерации в системе. Вы действительно хотите установить номер вручную?';uk='Номер документу надається автоматично під час запису, самостійне його редагування може привести до порушення в нумерації в системі. Ви дійсно хочете встановити номер вручну?'")
			КонецЕсли;
		КонецЕсли;		
		
		Ответ = Вопрос(ТекстВопроса, РежимДиалогаВопрос.ДаНет);
		Если Ответ <> КодВозвратаДиалога.Да Тогда
			Возврат;
		КонецЕсли;				
	КонецЕсли;
	Кнопка.Пометка = Не Кнопка.Пометка;
	ПолеВводаНомера.ТолькоПросмотр = НЕ Кнопка.Пометка;
	ПолеВводаНомера.ПропускатьПриВводе = ПолеВводаНомера.ТолькоПросмотр;	
	ОбновитьПодсказкуКодНомерОбъекта(МетаданныеОбъекта, ПодменюДействия, ПолеВводаНомера);
	
	Если ПолеВводаНомераДубль <> Неопределено Тогда
		ПолеВводаНомераДубль.ТолькоПросмотр = ПолеВводаНомера.ТолькоПросмотр;
		ПолеВводаНомераДубль.ПропускатьПриВводе = ПолеВводаНомераДубль.ТолькоПросмотр;
		ОбновитьПодсказкуКодНомерОбъекта(МетаданныеОбъекта, ПодменюДействия, ПолеВводаНомераДубль);
	КонецЕсли;
	
	
КонецПроцедуры // ИзменениеВозможностиРедактированияНомера()

//	Процедура установки флага ТолькоПросмотр для поля ввода кода/номера в зависимости от стратегии автонумерации объекта
//
// Параметры
//  МетаданныеОбъекта  - метаданные объекта.
//  ФормаОбъекта      - форма объекта.
//  ПодменюДействия - меню "Действия" командной панели формы. В этот меню должен присутствовать пункт "Редактировать код/номер"
//  ПолеВводаНомера - поле вводе, связанное с кодом/номером объекта
//
Процедура УстановитьДоступностьПоляВводаНомера(МетаданныеОбъекта, ФормаОбъекта, ПодменюДействия, ПолеВводаНомера) Экспорт
	
	Если ФормаОбъекта.Автонумерация = АвтонумерацияВФорме.Авто Тогда
		Возврат;
	КонецЕсли;	
	
	СтратегияРедактирования = ПолучитьСтратегиюРедактированияНомераОбъекта(МетаданныеОбъекта);
	
	Если СтратегияРедактирования = Перечисления.СтратегияРедактированияНомеровОбъектов.Доступно Тогда
		Если ПодменюДействия.Кнопки.Найти("РедактироватьКодНомер") <> Неопределено Тогда
			ПодменюДействия.Кнопки.Удалить(ПодменюДействия.Кнопки.РедактироватьКодНомер);
		КонецЕсли;
		ПолеВводаНомера.ТолькоПросмотр = Ложь;		
	КонецЕсли;
	
	ПолеВводаНомера.ПропускатьПриВводе = ПолеВводаНомера.ТолькоПросмотр;		
	УстановитьПодсказкуПоляВводаКодаНомера(ПолеВводаНомера, ПодменюДействия, СтратегияРедактирования);	
		
КонецПроцедуры // УстановитьДоступностьПоляВводаНомера()

//	Возвращает стратегию нумерациии для объекта
//
// Параметры
//	МетаданныеОбъекта - метаданные объекта
//
// Возвращаемое значение 
//  Стратегия нумерациии для объекта
//
Функция ПолучитьСтратегиюРедактированияНомераОбъекта(МетаданныеОбъекта) Экспорт
	КэшСтратегииАвтонумерации = глЗначениеПеременной("КэшСтратегииАвтонумерации");
	СтратегияРедактирования = КэшСтратегииАвтонумерации[МетаданныеОбъекта];
	Если СтратегияРедактирования = Неопределено Тогда
		СтратегияРедактирования = ПолучитьСтратегиюАвтонумерацииДляОбъекта(МетаданныеОбъекта);
		КэшСтратегииАвтонумерации.Вставить(МетаданныеОбъекта, СтратегияРедактирования);
	КонецЕсли;		
	Возврат СтратегияРедактирования;
КонецФункции // ПолучитьСтратегиюРедактированияНомераОбъекта()

//	Процедура установки текста подсказки для поля ввода кода/номера в зависимости от стратегии редактирования
//	и введенного значения
//
// Параметры
//  ПолеВводаНомера - поле вводе, связанное с кодом/номером объекта
//  ПодменюДействия - меню "Действия" командной панели формы. В этот меню должен присутствовать пункт "Редактировать код/номер"
//	СтратегияРедактирования - стратегия автонумерации объекта
//
Процедура УстановитьПодсказкуПоляВводаКодаНомера(ПолеВводаНомера, ПодменюДействия, СтратегияРедактирования)
		
	КодНомерСтрокой = ПолеВводаНомера.Данные;		
	
	Если ТипЗнч(ПолеВводаНомера) = Тип("ПолеВвода") Тогда
		ПолеВвода = ПолеВводаНомера;
	Иначе
		ПолеВвода = ПолеВводаНомера.ЭлементУправления;
	КонецЕсли;	
	
	Если ПустаяСтрока(ПолеВвода.Значение) Тогда
		ПолеВвода.Подсказка =  КодНомерСтрокой + НСтр("ru=' будет присвоен при записи объекта.';uk="" буде привласнений при записі об'єкта.""");
	Иначе
		ПолеВвода.Подсказка =  "";
	КонецЕсли;
	
	Если СтратегияРедактирования = Перечисления.СтратегияРедактированияНомеровОбъектов.НеДоступно Тогда
		Если НЕ ПодменюДействия.Кнопки.Найти("РедактироватьКодНомер") = Неопределено Тогда
			Если НЕ ПодменюДействия.Кнопки.РедактироватьКодНомер.Пометка Тогда
				ПолеВвода.Подсказка =  ПолеВвода.Подсказка + ?(ПустаяСтрока(ПолеВвода.Подсказка), "", " ") 
											 + НСтр("ru='Для возможности редактирования ';uk='Для можливості редагування '") + ?(КодНомерСтрокой = "Номер", "номера", "кода") + НСтр("ru=' используйте подменю ""Действия"".';uk=' використовуйте підменю ""Дії"".'");
			КонецЕсли;
		КонецЕсли;								 
	КонецЕсли;
	
КонецПроцедуры // УстановитьПодсказкуПоляВводаКодаНомера()

//	Возвращает стратегию нумерациии для объекта, сохраненную в соотв. регистре сведений
//
// Параметры
//	МетаданныеОбъекта - метаданные объекта
//
// Возвращаемое значение 
//  Стратегия нумерациии для объекта
//
Функция ПолучитьСтратегиюАвтонумерацииДляОбъекта(МетаданныеОбъекта)
	
	Перем ТипОбъекта;
	
	Если Метаданные.Справочники.Содержит(МетаданныеОбъекта) Тогда
		ТипОбъекта = "Справочники";
	ИначеЕсли Метаданные.Документы.Содержит(МетаданныеОбъекта) Тогда
		ТипОбъекта = "Документы";
	ИначеЕсли Метаданные.ПланыВидовХарактеристик.Содержит(МетаданныеОбъекта) Тогда
		ТипОбъекта = "ПланыВидовХарактеристик";
	Иначе
		Возврат Перечисления.СтратегияРедактированияНомеровОбъектов.НеДоступно;
	КонецЕсли;
	
	Запрос = Новый Запрос;
	Запрос.Текст = "
	|ВЫБРАТЬ
	|	СтратегияРедактированияНомераОбъекта КАК СтратегияРедактированияНомераОбъекта
	|ИЗ 
	|	РегистрСведений.СтратегииРедактированияНомеровОбъектов
	|ГДЕ
	|	ТипОбъекта = &ТипОбъекта
	|	И ВидОбъекта = &ВидОбъекта";
	
	Запрос.УстановитьПараметр("ТипОбъекта", ТипОбъекта);
	Запрос.УстановитьПараметр("ВидОбъекта", МетаданныеОбъекта.Имя);
	Выборка = Запрос.Выполнить().Выбрать();
	
	Если Выборка.Следующий() Тогда
		Возврат Выборка.СтратегияРедактированияНомераОбъекта;
	Иначе
		Возврат Перечисления.СтратегияРедактированияНомеровОбъектов.НеДоступно;
	КонецЕсли;	
	
КонецФункции // ПолучитьСтратегиюАвтонумерацииДляОбъекта()

//	Процедура обновления текста подсказки для поля ввода кода/номера
//
// Параметры
//	МетаданныеОбъекта - метаданные объекта
//  ПолеВводаНомера - поле вводе, связанное с кодом/номером объекта
//  ПодменюДействия - меню "Действия" командной панели формы. В этот меню должен присутствовать пункт "Редактировать код/номер"
//
Процедура ОбновитьПодсказкуКодНомерОбъекта(МетаданныеОбъекта, ПодменюДействия, ПолеВводаНомера) Экспорт
	УстановитьПодсказкуПоляВводаКодаНомера(ПолеВводаНомера, ПодменюДействия, ПолучитьСтратегиюРедактированияНомераОбъекта(МетаданныеОбъекта));
КонецПроцедуры // ОбновитьПодсказкуКодНомерОбъекта()

//	Процедура очистки введенного кода/номера объекта
// Параметры
//  ЭтотОбъект  - объект.
//	КодНомер - имя обрабатываемого реквизита (Код или Номер)
//  ПодменюДействия - меню "Действия" командной панели формы. В этот меню должен присутствовать пункт "Редактировать код/номер"
//  ПолеВводаНомера - поле вводе, связанное с кодом/номером объекта
//
Процедура СброситьУстановленныйКодНомерОбъекта(ЭтотОбъект, КодНомер, ПодменюДействия, ПолеВводаНомера) Экспорт
	ЭтотОбъект[КодНомер] = "";
	ОбновитьПодсказкуКодНомерОбъекта(ЭтотОбъект.Метаданные(), ПодменюДействия, ПолеВводаНомера);
КонецПроцедуры // СброситьУстановленныйКодНомерОбъекта()

Процедура ДобавитьВМенюДействияКнопкуРедактированияНомера(ПодменюДействия) Экспорт
	
	ДобавитьВМенюДействияКнопкуПоТипуОбъекта(ПодменюДействия, "номер");
	
	
КонецПроцедуры

Процедура ДобавитьВМенюДействияКнопкуРедактированияКода(ПодменюДействия) Экспорт
	
	ДобавитьВМенюДействияКнопкуПоТипуОбъекта(ПодменюДействия, "код");
	
КонецПроцедуры

Процедура ДобавитьВМенюДействияКнопкуПоТипуОбъекта(ПодменюДействия, КодНомер)
	
	Обработчик = Новый Действие("ДействияФормыРедактировать" + КодНомер);
	ПодменюДействия.Кнопки.Добавить("РазделительРедактированияКодаНомера", ТипКнопкиКоманднойПанели.Разделитель);
	Кнопка = ПодменюДействия.Кнопки.Добавить("РедактироватьКодНомер", ТипКнопкиКоманднойПанели.Действие, "Редактировать " + КодНомер, Обработчик);
	Кнопка.ИзменяетДанные = Истина;
	
КонецПроцедуры
