
Процедура КнопкаВыполнитьНажатие(Кнопка)
	
	ОбработкаКомментариев = глЗначениеПеременной("глОбработкаСообщений");
	ОбработкаКомментариев.УдалитьСообщения();
	
	ПараметрОтбора = Новый Структура();
	ПараметрОтбора.Вставить("Отметка", Истина);
	СписокДокументов = ВзносыФОТ.Выгрузить(ПараметрОтбора,"Документ,Сотрудник");
	СписокДокументов.Сортировать("Документ");
	
	ИндексСтрокиТаблицы = СписокДокументов.Количество();
	ТекущийДокумент = Неопределено;
	Сотрудники = Новый СписокЗначений();
	
	Пока ИндексСтрокиТаблицы > 0 Цикл
		ИндексСтрокиТаблицы = ИндексСтрокиТаблицы - 1;
		
		СтрокаТаблицы = СписокДокументов[ИндексСтрокиТаблицы];
		
		Если СтрокаТаблицы.Документ = ТекущийДокумент Тогда
			Сотрудники.Добавить(СтрокаТаблицы.Сотрудник);
			Если ИндексСтрокиТаблицы <>0 Тогда
				Продолжить;
			Иначе
				ПересчитатьДокумент(ТекущийДокумент, Сотрудники, ОбработкаКомментариев);
				Продолжить;
			КонецЕсли;
		ИначеЕсли ТекущийДокумент <> Неопределено Тогда
			ПересчитатьДокумент(ТекущийДокумент, Сотрудники, ОбработкаКомментариев);
		КонецЕсли;	
		
		ТекущийДокумент = СтрокаТаблицы.Документ;
		Сотрудники.Очистить();
		Сотрудники.Добавить(СтрокаТаблицы.Сотрудник);
		
		Если ИндексСтрокиТаблицы = 0 Тогда
			ПересчитатьДокумент(ТекущийДокумент, Сотрудники, ОбработкаКомментариев);
		КонецЕсли;
		
	КонецЦикла;
	
	СписокДокументов.Очистить();
	Автозаполнение();
	
КонецПроцедуры

Процедура ПересчитатьДокумент(Документ, Сотрудники, ОбработкаКомментариев)
	
	Если Документ <> Неопределено Тогда
		//Попытка пересчета
		ДокументОбъект = Документ.ПолучитьОбъект();
		Попытка
			ДокументОбъект.ПерерассчитатьВзносыФОТ(Сотрудники);
			ОбщегоНазначения.КомментарийРасчета(Строка(ДокументОбъект) + НСтр("ru=' обработан успешно. ';uk=' оброблений успішно. '"), Заголовок, "Открыть", Документ);
		Исключение
				ОбщегоНазначения.КомментарийРасчета("Документ " + Строка(ДокументОбъект) + НСтр("ru=' не может быть перерассчитан!"
"';uk=' не може бути перерозрахований!"
"'") + ОписаниеОшибки(), , "Открыть", Документ,Перечисления.ВидыСообщений.ВажнаяИнформация);
		КонецПопытки;
	КонецЕсли;
	
	ОбработкаКомментариев.ПоказатьСообщения();
	
КонецПроцедуры	

Процедура ЗаполнитьНажатие(Элемент)
	
	ПроверкаЗаполнения();
	Автозаполнение();
	
КонецПроцедуры

Процедура ПриОткрытии()
	Если Не ЗначениеЗаполнено(Организация) Тогда	
		Организация = УправлениеПользователями.ПолучитьЗначениеПоУмолчанию(глЗначениеПеременной("глТекущийПользователь"), "ОсновнаяОрганизация");
	КонецЕсли;
	Если Не ЗначениеЗаполнено(РасчетныйПериод) Тогда	
    	РасчетныйПериод = НачалоМесяца(ТекущаяДата());
	КонецЕсли;
	ЗагрузитьКоэффициент();
	СтрокаПериод = РаботаСДиалогами.ПолучитьПредставлениеПериодаРегистрации(РасчетныйПериод);
КонецПроцедуры

Процедура СтрокаПериодНачалоВыбораИзСписка(Элемент, СтандартнаяОбработка)
	
	РаботаСДиалогами.НачалоВыбораИзСпискаПредставленияПериодаРегистрации(Элемент, СтандартнаяОбработка, РасчетныйПериод, ЭтаФорма);
    ЗагрузитьКоэффициент()
	
КонецПроцедуры

Процедура СтрокаПериодОчистка(Элемент, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;

КонецПроцедуры

Процедура СтрокаПериодРегулирование(Элемент, Направление, СтандартнаяОбработка)
	
	РаботаСДиалогами.РегулированиеПредставленияПериодаРегистрации(Направление, СтандартнаяОбработка, РасчетныйПериод, СтрокаПериод);
    Элемент.Значение = РаботаСДиалогами.ДатаКакМесяцПредставление(РасчетныйПериод);
    ЗагрузитьКоэффициент()
	
КонецПроцедуры

Процедура ОрганизацияПриИзменении(Элемент)
	ЗагрузитьКоэффициент()
КонецПроцедуры

Процедура ЗагрузитьКоэффициент()
	
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("РасчетныйПериод",РасчетныйПериод);
	Запрос.УстановитьПараметр("Организация",Организация);
	
	Запрос.Текст = "ВЫБРАТЬ
	|	КоэффициентыСтавкиВзносовФОТ.КоэффициентСтавки
	|ИЗ
	|	РегистрСведений.КоэффициентыСтавкиВзносовФОТ КАК КоэффициентыСтавкиВзносовФОТ
	|ГДЕ
	|	КоэффициентыСтавкиВзносовФОТ.Организация = &Организация
	|	И КоэффициентыСтавкиВзносовФОТ.МесяцНачисления = &РасчетныйПериод";
	
	Выборка = Запрос.Выполнить().Выбрать();
	
	Если Выборка.Следующий() Тогда
		КоэффициентСтавки = ?(Выборка.КоэффициентСтавки = 0, 1, Выборка.КоэффициентСтавки);
	Иначе
		КоэффициентСтавки = 1;
	КонецЕсли;	
	
КонецПроцедуры	

Процедура ПроверкаЗаполнения()
	
	Отказ = Ложь;
	
	Если НЕ ЗначениеЗаполнено(Организация) Тогда
		Отказ = Истина;
		ОбщегоНазначения.СообщитьОбОшибке(НСтр("ru='Не выбрана организация!';uk='Не обрана організація!'"), Отказ);
		Возврат;
	КонецЕсли;
	Если СтрокаПериод = "" Тогда
		Отказ = Истина;
		ОбщегоНазначения.СообщитьОбОшибке(НСтр("ru='Не выбран расчетный период!';uk='Не обраний розрахунковий період!'"), Отказ);
		Возврат;
	КонецЕсли;
	
КонецПроцедуры
