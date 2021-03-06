////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ ФОРМЫ

Процедура ПриОткрытии()
	
	ИмяОбъекта = Сред(Отбор.НастраиваемыйОбъект.Значение, Найти(Отбор.НастраиваемыйОбъект.Значение, ".") + 1);
	СинонимОбъекта = Метаданные.Отчеты.Найти(ИмяОбъекта).Синоним;
	// Установка заголовка формы.
	Если РежимСохраненияНастройки Тогда
		ЭтаФорма.Заголовок = НСтр("ru='Сохранение настройки для ""';uk='Збереження настройки для ""'") + СинонимОбъекта + """";
	Иначе
		ЭтаФорма.Заголовок = НСтр("ru='Выбор настройки для ""';uk='Вибір настройки для ""'") + СинонимОбъекта + """";
	КонецЕсли;
	
	// Установка отбора по пользователю.
	Отбор.Владелец.Использование = Истина;
	Отбор.Владелец.ВидСравнения  = ВидСравнения.ВСписке;
	//Отбор.Владелец.Значение      = УправлениеПользователями.СписокГруппВключающихПользователя();
	Отбор.Владелец.Значение.Добавить(ПараметрыСеанса.ТекущийПользователь);
	Отбор.Владелец.Значение.Добавить(Справочники.ГруппыПользователей.ВсеПользователи);
	
	Отбор.ПометкаУдаления.Установить(ложь);
	
	// Установка доступности отбора и порядка.
	СохранениеНастроек.УстановитьДоступностьОтбора(ЭлементыФормы.СправочникСписокСохраненныеНастройки, "ЭтоГруппа, НастраиваемыйОбъект, ТипНастройки");
	СохранениеНастроек.УстановитьДоступностьПорядка(ЭлементыФормы.СправочникСписокСохраненныеНастройки);
	
	// Настройка вида списка.
	СохранениеНастроек.НастроитьВидСписка(ЭлементыФормы.СправочникСписокСохраненныеНастройки, глЗначениеПеременной("глТекущийПользователь"));
	ОбновитьВидСписка(ЭлементыФормы.ДействияФормы.Кнопки.ВидСписка.Пометка);
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ СПИСКА

Процедура СправочникСписокСохраненныеНастройкиПриНачалеРедактирования(Элемент, НоваяСтрока)
	
	Если НоваяСтрока Тогда
		
		ТекущиеДанные = ЭлементыФормы.СправочникСписокСохраненныеНастройки.ТекущиеДанные;
		
		ТекущиеДанные.Владелец            = глЗначениеПеременной("глТекущийПользователь");
		ТекущиеДанные.НастраиваемыйОбъект = Отбор.НастраиваемыйОбъект.Значение;
		ТекущиеДанные.ТипНастройки        = Перечисления.ТипыНастроек.НастройкиОтчета;
		
	КонецЕсли;
	
КонецПроцедуры

Процедура СправочникСписокСохраненныеНастройкиВыборЗначения(Элемент, СтандартнаяОбработка, Значение)
	
	Если НЕ ЗначениеЗаполнено(ЭлементыФормы.СправочникСписокСохраненныеНастройки.ТекущаяСтрока)
	 ИЛИ ЭлементыФормы.СправочникСписокСохраненныеНастройки.ТекущаяСтрока.ЭтоГруппа Тогда
		СтандартнаяОбработка = Ложь;
		Возврат;
	КонецЕсли;
	
	Если ТипЗнч(ВладелецФормы) = Тип("Форма") Тогда
		Если ВладелецФормы.Метаданные().Имя = "НавигаторПоСтандартнымОтчетам" Тогда
			ВладелецФормы.ОтчетОбъект.СохраненнаяНастройка = ЭлементыФормы.СправочникСписокСохраненныеНастройки.ТекущаяСтрока;
		Иначе
			
			ВладелецФормы.СохраненнаяНастройка = ЭлементыФормы.СправочникСписокСохраненныеНастройки.ТекущаяСтрока;
		КонецЕсли;	
		Если РежимСохраненияНастройки Тогда
			ВладелецФормы.СохранитьНастройку();
		Иначе
			ВладелецФормы.ПрименитьНастройку();
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

Процедура ДействияФормыВидСписка(Кнопка)

	Кнопка.Пометка = НЕ Кнопка.Пометка;

	ОбновитьВидСписка(Кнопка.Пометка);
	
КонецПроцедуры

Процедура ОбновитьВидСписка(Пометка)

	ЭлементыФормы.СправочникСписокСохраненныеНастройки.Дерево = Пометка;
	ЭлементыФормы.СправочникСписокСохраненныеНастройки.ИерархическийПросмотр = Пометка;

КонецПроцедуры


////////////////////////////////////////////////////////////////////////////////
// РАЗДЕЛ ОСНОВНОЙ ПРОГРАММЫ
