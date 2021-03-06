////////////////////////////////////////////////////////////////////////////////
// ПЕРЕМЕННЫЕ МОДУЛЯ
// Хранит дерево макетов печатных форм
Перем мДеревоМакетов;

// Хранит элемент управления подменю печати
Перем мПодменюПечати;

// Хранит элемент управления кнопку печать по умолчанию
Перем мПечатьПоУмолчанию;

Перем мТекущаяДатаДокумента; // Хранит текущую дату документа - для проверки перехода документа в другой период установки номера

// Хранит дерево кнопок подменю заполнение ТЧ
Перем мКнопкиЗаполненияТЧ;

//Хранит значение реквизита За счет ФСС от НС
Перем мПредыдущийВидФлага;

////////////////////////////////////////////////////////////////////////////////
// ОБЩИЕ ПРОЦЕДУРЫ И ФУНКЦИИ

// Процедура устанавливает подменю "Заполнить" в командных панелях ТЧ документа при необходимости
//
Процедура УстановитьКнопкиПодменюЗаполненияТЧ();
	
	мКнопкиЗаполненияТЧ = УниверсальныеМеханизмы.ПолучитьДеревоКнопокЗаполненияТабличныхЧастей(Ссылка,Новый Действие("НажатиеНаДополнительнуюКнопкуЗаполненияТЧ"));
	
	СоответствиеТЧ = Новый Соответствие;
	СоответствиеТЧ.Вставить(ЭлементыФормы.Начисления,ЭлементыФормы.КоманднаяПанель);
	
	УниверсальныеМеханизмы.СформироватьПодменюЗаполненияТЧПоДеревуКнопок(мКнопкиЗаполненияТЧ,СоответствиеТЧ);
	
КонецПроцедуры

// Процедура устанавливает подменю "Печать" и кнопку "Печать по умолчанию" при необходимости
//
Процедура УстановитьКнопкиПечати()
	
	ФормированиеПечатныхФорм.СоздатьКнопкиПечати(ЭтотОбъект, ЭтаФорма);	
	
КонецПроцедуры

Процедура ПроверитьДокументыВведенныеНаОсновании()
	
	ЗапросПоПлатежнымДокументам = Новый Запрос;
	ЗапросПоПлатежнымДокументам.УстановитьПараметр("Заявка", Ссылка);
	
	ТекстЗапроса = 
	"ВЫБРАТЬ
	|	СУММА(ВложенныйЗапрос.Заявка) КАК КоличествоДокументов
	|ИЗ
	|	(ВЫБРАТЬ
	|		КОЛИЧЕСТВО(РАЗЛИЧНЫЕ ПлатежноеПоручениеВходящее.ЗаявлениеРасчет) КАК Заявка
	|	ИЗ Документ.ПлатежноеПоручениеВходящее.Заявки КАК ПлатежноеПоручениеВходящее
	|	ГДЕ		ПлатежноеПоручениеВходящее.ЗаявлениеРасчет = &Заявка 	
	|		И ПлатежноеПоручениеВходящее.Ссылка.Проведен
	|	
	|) КАК ВложенныйЗапрос
	|";
	
	ЗапросПоПлатежнымДокументам.Текст = ТекстЗапроса;
	
	РезультатЗапроса = ЗапросПоПлатежнымДокументам.Выполнить().Выбрать();
	
	Если РезультатЗапроса.Следующий() Тогда
		
		Если РезультатЗапроса.КоличествоДокументов > 0 Тогда
			
			ЭтаФорма.ТолькоПросмотр = Истина;
		
		КонецЕсли; 
		
	КонецЕсли; 
	
КонецПроцедуры

Процедура УстановитьВидимостьСтраниц()
	
	ФормаДо2018 = Дата < Дата(2018,10,1); 
	ЭтаФорма.ЭлементыФормы.ПанельОбщая.Страницы.До2018Года.Видимость = ФормаДо2018;
	ЭтаФорма.ЭлементыФормы.ПанельОбщая.Страницы.С2018Года.Видимость = Не ФормаДо2018;
	ЭтаФорма.ЭлементыФормы.ОсновныеДействияФормы.Кнопки.ВыгрузитьВ.Кнопки["ВыгрузитьВЗвит1С1"].Доступность = Не ФормаДо2018;
	
КонецПроцедуры	

////////////////////////////////////////////////////////////////////////////////
// ПРОЦЕДУРЫ - ОБРАБОТЧИКИ СОБЫТИЙ ФОРМЫ

Процедура ПередОткрытием(Отказ, СтандартнаяОбработка)
	
	// Установка кнопок печати
	УстановитьКнопкиПечати();
	
	// Установка кнопок заполнение ТЧ
	УстановитьКнопкиПодменюЗаполненияТЧ();

	
КонецПроцедуры

Процедура ПриОткрытии()
	
	Если ЭтоНовый() Тогда // проверить объект на то, что он еще не внесен в ИБ
		
		// Заполнить реквизиты значениями по умолчанию.
		ЗаполнениеДокументов.ЗаполнитьШапкуДокумента(ЭтотОбъект);
	Иначе 
		ПроверитьДокументыВведенныеНаОсновании();
		
		// Установить доступность формы с учетом даты запрета редактирования	
		РаботаСДиалогами.УстановитьДоступностьФормыДляРедактирования(ЭтотОбъект, ЭтаФорма);
	КонецЕсли;
	
	МеханизмНумерацииОбъектов.УстановитьДоступностьПоляВводаНомера(Метаданные(), ЭтаФорма, ЭлементыФормы.ДействияФормы.Кнопки.Подменю1,ЭлементыФормы.Номер);


	// Заполним реквизит формы МесяцСтрока.
	МесяцСтрока = РаботаСДиалогами.ДатаКакМесяцПредставление(ПериодРегистрации);
	мПредыдущийВидФлага = ЗаСчетФССОтНС;
	УстановитьВидимостьСтраниц();
	
КонецПроцедуры

Процедура ПослеЗаписи()
   // Установка кнопок печати
	УстановитьКнопкиПечати();

	// Вывести в заголовке формы статус документа (новый, не проведен, проведен).
	РаботаСДиалогами.УстановитьЗаголовокФормыДокумента(, ЭтотОбъект, ЭтаФорма);
	
	МеханизмНумерацииОбъектов.ОбновитьПодсказкуКодНомерОбъекта(ЭтотОбъект.Метаданные(), ЭлементыФормы.ДействияФормы.Кнопки.Подменю, ЭлементыФормы.Номер);

КонецПроцедуры

Процедура ПередЗакрытием(Отказ, СтандартнаяОбработка)
	Если ЭтотОбъект.Модифицированность() Тогда
		РасчитатьИтоговыеСуммы()
	КонецЕсли;	
КонецПроцедуры

Процедура ОсновныеДействияФормыВыгрузитьВЗвит1С(Кнопка)
	
	//Запишем документ
	Если Не РаботаСДиалогами.ПроверитьМодифицированность(ЭтотОбъект,НСтр("ru='Для выгрзки';uk='Для вивантаження'")) Тогда
		Возврат;
	КонецЕсли;
	
	ВыгрузитьВоФРЕДО();
	
КонецПроцедуры
////////////////////////////////////////////////////////////////////////////////
// ПРОЦЕДУРЫ - ДЕЙСТВИЯ КОМАНДНЫХ ПАНЕЛЕЙ ФОРМЫ

// Процедура разрешения/запрещения редактирования номера документа
Процедура ДействияФормыРедактироватьНомер(Кнопка)
	
	МеханизмНумерацииОбъектов.ИзменениеВозможностиРедактированияНомера(ЭтотОбъект.Метаданные(), ЭтаФорма, ЭлементыФормы.ДействияФормы.Кнопки.Подменю, ЭлементыФормы.Номер);
			
КонецПроцедуры


////////////////////////////////////////////////////////////////////////////////
// ПРОЦЕДУРЫ - ОБРАБОТЧИКИ СОБЫТИЙ РЕКВИЗИТОВ ШАПКИ

// Процедура - обработчик события "ПриИзменении" поля ввода даты документа
//
Процедура ДатаПриИзменении(Элемент = Неопределено)
	
	РаботаСДиалогами.ПроверитьНомерДокумента(ЭтотОбъект, мТекущаяДатаДокумента);
	МеханизмНумерацииОбъектов.ОбновитьПодсказкуКодНомерОбъекта(ЭтотОбъект.Метаданные(), ЭлементыФормы.ДействияФормы.Кнопки.Подменю, ЭлементыФормы.Номер);
	
	мТекущаяДатаДокумента = Дата;
	УстановитьВидимостьСтраниц();
	Если Дата >= Дата(2018,10,1) Тогда
		Если ЗначениеЗаполнено(ДокументыПоНачислениям) Тогда
			Если Вопрос(НСтр("ru='Табличная часть Начисления будет очищена';uk='Таблична частина Нарахування буде очищена'"), РежимДиалогаВопрос.ОКОтмена) = КодВозвратаДиалога.Ок Тогда
				ДокументыПоНачислениям.Очистить();
			КонецЕсли;
		КонецЕсли
	Иначе
		Если ЗначениеЗаполнено(Больничные) Или ЗначениеЗаполнено(БольничныеНС) Или ЗначениеЗаполнено(Декретные) Или ЗначениеЗаполнено(ПособияНаПогребение)  Тогда
			Если Вопрос(НСтр("ru='Табличные части будут очищены';uk='Табличні частини будуть очищені'"), РежимДиалогаВопрос.ОКОтмена) = КодВозвратаДиалога.Ок Тогда
				Больничные.Очистить();
				БольничныеНС.Очистить();
				Декретные.Очистить();
				ПособияНаПогребение.Очистить();
			КонецЕсли;
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры // ДатаПриИзменении

// Процедура - обработчик события "ПриИзменении" поля ввода организации.
//
Процедура ОрганизацияПриИзменении(Элемент)
	
    Если Не ПустаяСтрока(Номер) Тогда
		МеханизмНумерацииОбъектов.СброситьУстановленныйКодНомерОбъекта(ЭтотОбъект, "Номер", ЭлементыФормы.ДействияФормы.Кнопки.Подменю, ЭлементыФормы.Номер);
	КонецЕсли;
	
КонецПроцедуры // ОрганизацияПриИзменении()

// Процедура - обработчик события "ПриИзменении" поля ввода периода регистрации.
//
Процедура ПериодРегистрацииПриИзменении(Элемент)
	
	РаботаСДиалогами.ДатаКакМесяцПодобратьДатуПоТексту(Элемент.Значение, ПериодРегистрации);
	Элемент.Значение = РаботаСДиалогами.ДатаКакМесяцПредставление(ПериодРегистрации);
		
КонецПроцедуры

// Процедура - обработчик события "Регулирование" поля ввода периода регистрации.
//
Процедура ПериодРегистрацииРегулирование(Элемент, Направление, СтандартнаяОбработка)
	
	ПериодРегистрации = ДобавитьМесяц(ПериодРегистрации, Направление);
	Элемент.Значение = РаботаСДиалогами.ДатаКакМесяцПредставление(ПериодРегистрации);
	
КонецПроцедуры

// Процедура - обработчик события "Очистка" поля ввода периода регистрации.
//
Процедура ПериодРегистрацииОчистка(Элемент, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
КонецПроцедуры

// Процедура - обработчик события "НачалоВыбораИзСписка" поля ввода периода регистрации.
//
Процедура ПериодРегистрацииНачалоВыбораИзСписка(Элемент, СтандартнаяОбработка)
	
	РаботаСДиалогами.НачалоВыбораИзСпискаПредставленияПериодаРегистрации(Элемент, СтандартнаяОбработка, ПериодРегистрации, ЭтаФорма);
	
КонецПроцедуры

// Процедура - обработчик события "АвтоПодборТекста" поля ввода периода регистрации.
//
Процедура ПериодРегистрацииАвтоПодборТекста(Элемент, Текст, ТекстАвтоПодбора, СтандартнаяОбработка)
	
	РаботаСДиалогами.ДатаКакМесяцАвтоПодборТекста(Текст, ТекстАвтоПодбора, СтандартнаяОбработка);
	
КонецПроцедуры

// Процедура - обработчик события "ОкончаниеВводаТекста" поля ввода периода регистрации.
//
Процедура ПериодРегистрацииОкончаниеВводаТекста(Элемент, Текст, Значение, СтандартнаяОбработка)
	
	РаботаСДиалогами.ДатаКакМесяцОкончаниеВводаТекста(Текст, Значение, СтандартнаяОбработка);
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// ПРОЦЕДУРЫ - ДЕЙСТВИЯ КОМАНДНОЙ ПАНЕЛИ ТАБЛИЧНОГО ПОЛЯ Документы

Процедура КоманднаяПанельЗаполнить(Кнопка)

	АвтозаполнениеДокумента();
	
КонецПроцедуры

Процедура НачисленияДокументПриИзменении(Элемент)
	РасчитатьИтоговыеСуммы();
КонецПроцедуры

Процедура НачисленияПослеУдаления(Элемент)
	РасчитатьИтоговыеСуммы();
КонецПроцедуры


Процедура ДействияФормыДвиженияДокументаПоРегистрам(Кнопка)
	РаботаСДиалогами.НапечататьДвиженияДокумента(Ссылка);
КонецПроцедуры

Процедура НачисленияДокументНачалоВыбора(Элемент, СтандартнаяОбработка)
	//Если Флаг За счет ФСС от НС активный установим тип документа НачисленияПоБольничномуЛисту
	Если ЗаСчетФССОтНС Тогда
		 ОписаниеТипа = Новый ОписаниеТипов("ДокументСсылка.НачислениеПоБольничномуЛисту"); 
		 Элемент.ОграничениеТипа = ОписаниеТипа; 
		 Элемент.Значение = ОписаниеТипа.ПривестиЗначение(); 
		 Элемент.ВыбиратьТип = Ложь;
	 Иначе
	 	ОписаниеТипов = Новый ОписаниеТипов("ДокументСсылка.НачислениеЕдиновременныхПособийЗаСчетФСС,ДокументСсылка.НачислениеПоБольничномуЛисту"); 
	 	Элемент.ОграничениеТипа = ОписаниеТипов;
		Элемент.ВыбиратьТип = Истина;
	КонецЕсли;
	
	Если ТипЗнч(Элемент.Значение) = Тип("ДокументСсылка.НачислениеПоБольничномуЛисту") Тогда
		СтандартнаяОбработка = Ложь;
		
		ФормаВыбора = Документы.НачислениеПоБольничномуЛисту.ПолучитьФормуВыбора(,Элемент,);
		
			
		ФормаВыбора.Отбор.Организация.ВидСравнения  = ВидСравнения.Равно;
		ФормаВыбора.Отбор.Организация.Значение      = Организация;
		ФормаВыбора.Отбор.Организация.Использование = Истина;
		
		ФормаВыбора.Открыть();
		
	ИначеЕсли ТипЗнч(Элемент.Значение) = Тип("ДокументСсылка.НачислениеЕдиновременныхПособийЗаСчетФСС") Тогда
		СтандартнаяОбработка = Ложь;
		
		ФормаВыбора =Документы.НачислениеЕдиновременныхПособийЗаСчетФСС.ПолучитьФормуВыбора(,Элемент,);	               
		
		ФормаВыбора.Отбор.Организация.ВидСравнения  = ВидСравнения.Равно;
		ФормаВыбора.Отбор.Организация.Значение 	 	= Организация;
		ФормаВыбора.Отбор.Организация.Использование = Истина;
		
		ФормаВыбора.Открыть();
	КонецЕсли;
	
КонецПроцедуры

// Процедура - обработчик нажатия на кнопку "Печать по умолчанию"
//
Процедура ОсновныеДействияФормыПечатьПоУмолчанию(Кнопка)
	
	УниверсальныеМеханизмы.ПечатьПоДополнительнойКнопке(мДеревоМакетов, ЭтотОбъект, ЭтаФорма, Кнопка.Текст);
	
КонецПроцедуры // ОсновныеДействияФормыПечатьПоУмолчанию()

// Процедура - обработчик нажатия на кнопку "Печать"
//
Процедура ОсновныеДействияФормыПечать(Кнопка)
	
	УниверсальныеМеханизмы.ПечатьПоДополнительнойКнопке(мДеревоМакетов, ЭтотОбъект, ЭтаФорма, Кнопка.Текст);
	
КонецПроцедуры // ОсновныеДействияФормыПечать()

// Процедура - обработчик нажатия на кнопку "Установить печать по умолчанию"
//
Процедура ОсновныеДействияФормыУстановитьПечатьПоУмолчанию(Кнопка)
	
	Если УниверсальныеМеханизмы.НазначитьКнопкуПечатиПоУмолчанию(мДеревоМакетов, Метаданные().Имя) Тогда
		
		УстановитьКнопкиПечати();
		
	КонецЕсли;
	
КонецПроцедуры // ОсновныеДействияФормыУстановитьПечатьПоУмолчанию()

// Процедура - обработчик нажатия на любую из дополнительных кнопок по заполнению ТЧ
//
Процедура НажатиеНаДополнительнуюКнопкуЗаполненияТЧ(Кнопка)
	
	УниверсальныеМеханизмы.ОбработатьНажатиеНаДополнительнуюКнопкуЗаполненияТЧ(мКнопкиЗаполненияТЧ.Строки.Найти(Кнопка.Имя,"Имя",Истина),ЭтотОбъект);
	
КонецПроцедуры

Процедура НачисленияПриВыводеСтроки(Элемент, ОформлениеСтроки, ДанныеСтроки)
	Если ТипЗнч(ДанныеСтроки.Документ) = Тип("ДокументСсылка.НачислениеПоБольничномуЛисту") Тогда
		ОформлениеСтроки.Ячейки.Сотрудник.УстановитьТекст(ДанныеСтроки.Документ.Сотрудник.Наименование);
	КонецЕсли;
КонецПроцедуры

Процедура ЗаСчетФССОтНСПриИзменении(Элемент)
	Если ЗначениеЗаполнено(ДокументыПоНачислениям) Тогда
	   Если Вопрос(НСтр("ru='Табличная часть будет очищена';uk='Таблична частина буде очищена'"), РежимДиалогаВопрос.ОКОтмена) = КодВозвратаДиалога.Ок Тогда
           ДокументыПоНачислениям.Очистить();
	   Иначе
		   ЗаСчетФССОтНС = мПредыдущийВидФлага;
		   Возврат;
	   КонецЕсли;
   КонецЕсли;
   ПолучитьСтруктуруПечатныхФорм();
КонецПроцедуры

Процедура НачисленияПриОкончанииРедактирования(Элемент, НоваяСтрока, ОтменаРедактирования)
	//Если Флаг За счет ФСС от НС активен проверим правильный ли документ выбран
	Если ЗаСчетФССОтНС Тогда
		ТекущаяСтрока = Элемент.ТекущаяСтрока;
		Если ЗначениеЗаполнено(ТекущаяСтрока.Документ) Тогда
				Статья = ТекущаяСтрока.Документ.ПричинаНетрудоспособности.СтатьяРасчетовСФСС;					
				Если  НЕ Статья = Справочники.СтатьиНалоговыхДеклараций.ФССНесчСлуч_ВремНетрудосп  Тогда
					Сообщить(НСтр("ru='В данном документе должны указываться только больничные за счет ФСС по ВУТ (ФСС от НС).';uk='У даному документі мають зазначатися тільки лікарняні за рахунок ФСС з ТВП (ФСС від НВ).'"));
				КонецЕсли;
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры
////////////////////////////////////////////////////////////////////////////////
// ПРОЦЕДУРЫ - ДЕЙСТВИЯ КОМАНДНЫХ ПАНЕЛЕЙ ТАБЛИЧНОГО ПОЛЕЙ Больничные, БольничныеНС, Декретные, ПособияНаПогребение

Процедура КоманднаяПанельБольничныеЗаполнить(Кнопка)
	АвтозаполнениеТЧ2018(Истина,Ложь,Ложь,Ложь,Ложь)
КонецПроцедуры


Процедура КоманднаяПанельДекретныеЗаполнить(Кнопка)
	АвтозаполнениеТЧ2018(Ложь,Ложь,Истина,Ложь,Ложь)
КонецПроцедуры


Процедура КоманднаяПанельБольничныеНСЗаполнить(Кнопка)
	АвтозаполнениеТЧ2018(Ложь,Истина,Ложь,Ложь,Ложь)
КонецПроцедуры


Процедура КоманднаяПанельПособияНаПогребениеЗаполнить(Кнопка)
	АвтозаполнениеТЧ2018(Ложь,Ложь,Ложь,Истина,Ложь)
КонецПроцедуры


Процедура ДействияФормыКпопкаДействиеЗаполнитьВсе(Кнопка)
	Если Дата >= Дата(2018,10,1) Тогда 
		АвтозаполнениеТЧ2018(Ложь,Ложь,Ложь,Ложь,Истина)
	Иначе
		АвтозаполнениеДокумента();
	КонецЕсли	
КонецПроцедуры


Процедура БольничныеДокументНачалоВыбора(Элемент, СтандартнаяОбработка)
	
	ФормаВыбора = Документы.НачислениеПоБольничномуЛисту.ПолучитьФормуВыбора(,Элемент,);
	ФормаВыбора.НачальноеЗначениеВыбора = Элемент.Значение;
	ФормаВыбора.Отбор.Организация.ВидСравнения  = ВидСравнения.Равно;
	ФормаВыбора.Отбор.Организация.Значение      = Организация;
	ФормаВыбора.Отбор.Организация.Использование = Истина;
	
	Запрос = Новый Запрос;
	Запрос.Текст = "ВЫБРАТЬ
	               |	ПричиныНетрудоспособности.Ссылка КАК ПричинаНетрудоспособности
	               |ИЗ
	               |	Справочник.ПричиныНетрудоспособности КАК ПричиныНетрудоспособности
	               |ГДЕ
	               |	ПричиныНетрудоспособности.СтатьяРасчетовСФСС В (&СтатьиРасчетовСФСС)
				   |	И ПричиныНетрудоспособности.Ссылка <> &БольничныйПоБеременностиИРодам";
	СтатьиРасчетовСФСС = Новый СписокЗначений;
	СтатьиРасчетовСФСС.Добавить(Справочники.СтатьиНалоговыхДеклараций.ФССУтрТрудосп_ВремНетрудосп);
	СтатьиРасчетовСФСС.Добавить(Справочники.СтатьиНалоговыхДеклараций.ФССУтрТрудосп_ВремНетрудоспУход);
	
	Запрос.УстановитьПараметр("СтатьиРасчетовСФСС", СтатьиРасчетовСФСС);
	Запрос.УстановитьПараметр("БольничныйПоБеременностиИРодам", Справочники.ПричиныНетрудоспособности.ПоБеременностиИРодам);
	массивПричинНетрудоспособности = Запрос.Выполнить().Выгрузить().ВыгрузитьКолонку("ПричинаНетрудоспособности");
	
	списокПричинНетрудоспособности = Новый СписокЗначений;
	Для Каждого элементМассива Из массивПричинНетрудоспособности Цикл
		списокПричинНетрудоспособности.Добавить(элементМассива);	
	КонецЦикла;
	
	ФормаВыбора.Отбор.ПричинаНетрудоспособности.ВидСравнения = ВидСравнения.ВСписке;
	ФормаВыбора.Отбор.ПричинаНетрудоспособности.Значение = списокПричинНетрудоспособности;
	ФормаВыбора.Отбор.ПричинаНетрудоспособности.Использование = Истина;
	
	ФормаВыбора.Открыть();
	СтандартнаяОбработка = Ложь;

КонецПроцедуры

Процедура БольничныеПриВыводеСтроки(Элемент, ОформлениеСтроки, ДанныеСтроки)
	
	ОформлениеСтроки.Ячейки.Сотрудник.УстановитьТекст(ДанныеСтроки.Документ.Сотрудник.Наименование);
	
КонецПроцедуры

Процедура ДекретныеДокументНачалоВыбора(Элемент, СтандартнаяОбработка)
	
	ФормаВыбора = Документы.НачислениеПоБольничномуЛисту.ПолучитьФормуВыбора(,Элемент,);
	ФормаВыбора.НачальноеЗначениеВыбора = Элемент.Значение;
	ФормаВыбора.Отбор.Организация.ВидСравнения  = ВидСравнения.Равно;
	ФормаВыбора.Отбор.Организация.Значение      = Организация;
	ФормаВыбора.Отбор.Организация.Использование = Истина;
	
	ФормаВыбора.Отбор.ПричинаНетрудоспособности.ВидСравнения = ВидСравнения.Равно;
	ФормаВыбора.Отбор.ПричинаНетрудоспособности.Значение = Справочники.ПричиныНетрудоспособности.ПоБеременностиИРодам;
	ФормаВыбора.Отбор.ПричинаНетрудоспособности.Использование = Истина;
	ФормаВыбора.Открыть();
	
	СтандартнаяОбработка = Ложь;

КонецПроцедуры

Процедура ДекретныеПриВыводеСтроки(Элемент, ОформлениеСтроки, ДанныеСтроки)
	
	ОформлениеСтроки.Ячейки.Сотрудник.УстановитьТекст(ДанныеСтроки.Документ.Сотрудник.Наименование);

КонецПроцедуры

Процедура БольничныеНСДокументНачалоВыбора(Элемент, СтандартнаяОбработка)
	
	ФормаВыбора = Документы.НачислениеПоБольничномуЛисту.ПолучитьФормуВыбора(,Элемент,);
	ФормаВыбора.НачальноеЗначениеВыбора = Элемент.Значение;
	ФормаВыбора.Отбор.Организация.ВидСравнения  = ВидСравнения.Равно;
	ФормаВыбора.Отбор.Организация.Значение      = Организация;
	ФормаВыбора.Отбор.Организация.Использование = Истина;
	
	Запрос = Новый Запрос;
	Запрос.Текст = "ВЫБРАТЬ
	               |	ПричиныНетрудоспособности.Ссылка КАК ПричинаНетрудоспособности
	               |ИЗ
	               |	Справочник.ПричиныНетрудоспособности КАК ПричиныНетрудоспособности
	               |ГДЕ
	               |	ПричиныНетрудоспособности.СтатьяРасчетовСФСС = &СтатьяРасчетовСФССНС
				   |	И ПричиныНетрудоспособности.Ссылка <> &БольничныйПоБеременностиИРодам";
	СтатьяРасчетовСФССНС = Справочники.СтатьиНалоговыхДеклараций.ФССНесчСлуч_ВремНетрудосп;
	Запрос.УстановитьПараметр("СтатьяРасчетовСФССНС", СтатьяРасчетовСФССНС);
	Запрос.УстановитьПараметр("БольничныйПоБеременностиИРодам", Справочники.ПричиныНетрудоспособности.ПоБеременностиИРодам);
	
	массивПричинНетрудоспособности = Запрос.Выполнить().Выгрузить().ВыгрузитьКолонку("ПричинаНетрудоспособности");
	
	списокПричинНетрудоспособности = Новый СписокЗначений;
	Для Каждого элементМассива Из массивПричинНетрудоспособности Цикл
		списокПричинНетрудоспособности.Добавить(элементМассива);	
	КонецЦикла;
	
	ФормаВыбора.Отбор.ПричинаНетрудоспособности.ВидСравнения = ВидСравнения.ВСписке;
	ФормаВыбора.Отбор.ПричинаНетрудоспособности.Значение = списокПричинНетрудоспособности;
	ФормаВыбора.Отбор.ПричинаНетрудоспособности.Использование = Истина;
	ФормаВыбора.Открыть();
	СтандартнаяОбработка = Ложь;
	
КонецПроцедуры

Процедура БольничныеНСПриВыводеСтроки(Элемент, ОформлениеСтроки, ДанныеСтроки)
	
	ОформлениеСтроки.Ячейки.Сотрудник.УстановитьТекст(ДанныеСтроки.Документ.Сотрудник.Наименование);

КонецПроцедуры

Процедура ПособияНаПогребениеДокументНачалоВыбора(Элемент, СтандартнаяОбработка)
	
	ФормаВыбора = Документы.НачислениеЕдиновременныхПособийЗаСчетФСС.ПолучитьФормуВыбора(,Элемент,);
	ФормаВыбора.НачальноеЗначениеВыбора = Элемент.Значение;
	ФормаВыбора.Отбор.Организация.ВидСравнения  = ВидСравнения.Равно;
	ФормаВыбора.Отбор.Организация.Значение      = Организация;
	ФормаВыбора.Отбор.Организация.Использование = Истина;
	
	ФормаВыбора.Открыть();
	СтандартнаяОбработка = Ложь;
	
КонецПроцедуры

Процедура БольничныеДокументПриИзменении(Элемент)
		
	ТекущаяСтрока = ЭлементыФормы.Больничные.ТекущаяСтрока;
	
	Запрос = Новый Запрос;
	Запрос.Текст = "ВЫБРАТЬ РАЗРЕШЕННЫЕ
	|	СУММА(НачислениеПоБольничномуЛистуНачисления.ОплаченоДнейЧасов) КАК Дни,
	|	СУММА(НачислениеПоБольничномуЛистуНачисления.Результат) КАК Сумма,
	|	НачислениеПоБольничномуЛистуНачисления.Ссылка.Сотрудник КАК Сотрудник
	|ИЗ
	|	Документ.НачислениеПоБольничномуЛисту.Начисления КАК НачислениеПоБольничномуЛистуНачисления
	|ГДЕ
	|	НачислениеПоБольничномуЛистуНачисления.Ссылка = &Ссылка
	|	И НачислениеПоБольничномуЛистуНачисления.ВидРасчета.НачислениеЗаСчетФСС = ИСТИНА
	|
	|СГРУППИРОВАТЬ ПО
	|	НачислениеПоБольничномуЛистуНачисления.Ссылка.Сотрудник";
	Запрос.УстановитьПараметр("Ссылка", Элемент.Значение);
	Выборка = Запрос.Выполнить().Выбрать();
	Если Выборка.Следующий() Тогда
		ТекущаяСтрока.Сотрудник = Выборка.Сотрудник;
		ТекущаяСтрока.Сумма = Выборка.Сумма;
		ТекущаяСтрока.Дни = Выборка.Дни;
	КонецЕсли;	
	РасчитатьИтоговыеСуммы();
КонецПроцедуры

Процедура БольничныеНСДокументПриИзменении(Элемент)
	
	ТекущаяСтрока = ЭлементыФормы.БольничныеНС.ТекущаяСтрока;
	
	Запрос = Новый Запрос;
	Запрос.Текст = "ВЫБРАТЬ РАЗРЕШЕННЫЕ
	|	СУММА(НачислениеПоБольничномуЛистуНачисления.ОплаченоДнейЧасов) КАК Дни,
	|	СУММА(НачислениеПоБольничномуЛистуНачисления.Результат) КАК Сумма,
	|	НачислениеПоБольничномуЛистуНачисления.Ссылка.Сотрудник КАК Сотрудник
	|ИЗ
	|	Документ.НачислениеПоБольничномуЛисту.Начисления КАК НачислениеПоБольничномуЛистуНачисления
	|ГДЕ
	|	НачислениеПоБольничномуЛистуНачисления.Ссылка = &Ссылка
	|	И НачислениеПоБольничномуЛистуНачисления.ВидРасчета.НачислениеЗаСчетФСС = ИСТИНА
	|
	|СГРУППИРОВАТЬ ПО
	|	НачислениеПоБольничномуЛистуНачисления.Ссылка.Сотрудник";
	Запрос.УстановитьПараметр("Ссылка", Элемент.Значение);
	Выборка = Запрос.Выполнить().Выбрать();
	Если Выборка.Следующий() Тогда
		ТекущаяСтрока.Сотрудник = Выборка.Сотрудник;
		ТекущаяСтрока.Сумма = Выборка.Сумма;
		ТекущаяСтрока.Дни = Выборка.Дни;
	КонецЕсли;	
	РасчитатьИтоговыеСуммы();	
КонецПроцедуры

Процедура ДекретныеДокументПриИзменении(Элемент)
		
	ТекущаяСтрока = ЭлементыФормы.Декретные.ТекущаяСтрока;
	
	Запрос = Новый Запрос;
	Запрос.Текст = "ВЫБРАТЬ РАЗРЕШЕННЫЕ
	|	СУММА(НачислениеПоБольничномуЛистуНачисления.ОплаченоДнейЧасов) КАК Дни,
	|	СУММА(НачислениеПоБольничномуЛистуНачисления.Результат) КАК Сумма,
	|	НачислениеПоБольничномуЛистуНачисления.Ссылка.Сотрудник КАК Сотрудник
	|ИЗ
	|	Документ.НачислениеПоБольничномуЛисту.Начисления КАК НачислениеПоБольничномуЛистуНачисления
	|ГДЕ
	|	НачислениеПоБольничномуЛистуНачисления.Ссылка = &Ссылка
	|	И НачислениеПоБольничномуЛистуНачисления.ВидРасчета.НачислениеЗаСчетФСС = ИСТИНА
	|
	|СГРУППИРОВАТЬ ПО
	|	НачислениеПоБольничномуЛистуНачисления.Ссылка.Сотрудник";
	Запрос.УстановитьПараметр("Ссылка", Элемент.Значение);
	Выборка = Запрос.Выполнить().Выбрать();
	Если Выборка.Следующий() Тогда
		ТекущаяСтрока.Сотрудник = Выборка.Сотрудник;
		ТекущаяСтрока.Сумма = Выборка.Сумма;
		ТекущаяСтрока.Дни = Выборка.Дни;
	КонецЕсли;
	РасчитатьИтоговыеСуммы();	
КонецПроцедуры

Процедура ПособияНаПогребениеДокументПриИзменении(Элемент)
	РасчитатьИтоговыеСуммы();
КонецПроцедуры

Процедура ПособияНаПогребениеПослеУдаления(Элемент)
	РасчитатьИтоговыеСуммы()
КонецПроцедуры

Процедура БольничныеПослеУдаления(Элемент)
	РасчитатьИтоговыеСуммы()
КонецПроцедуры

Процедура ДекретныеПослеУдаления(Элемент)
	РасчитатьИтоговыеСуммы()
КонецПроцедуры

Процедура БольничныеНСПослеУдаления(Элемент)
	РасчитатьИтоговыеСуммы()
КонецПроцедуры


