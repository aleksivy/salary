Перем мФизЛицо; // сохраняем физлицо, данные которого начинали редактировать

Процедура УстановитьДоступность()
	
	ЭлементыФормы.Группа.Доступность = Инвалидность;
	ЭлементыФормы.УдостоверениеСерия.Доступность = Инвалидность;
	ЭлементыФормы.УдостоверениеНомер.Доступность = Инвалидность;
	ЭлементыФормы.УдостоверениеДатаВыдачи.Доступность = Инвалидность;
	
КонецПроцедуры	

////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ ФОРМЫ

Процедура ПриОткрытии()
	
	Заголовок = НСтр("ru='Сведения об инвалидности: ';uk='Відомості про інвалідність: '") + ФизЛицо.Наименование;
	мФизЛицо = ФизЛицо;
КонецПроцедуры

Процедура ПослеЗаписи()
	Оповестить("ОбновитьФорму", Новый Структура("ИмяЭлемента","Инвалидность"), ФизЛицо);
	Если мФизЛицо <> ФизЛицо Тогда
        // оповестим также форму того физлица, данные которого начинали редактировать
		Оповестить("ОбновитьФорму", Новый Структура("ИмяЭлемента","Инвалидность"), мФизЛицо);
		мФизЛицо = ФизЛицо;
	КонецЕсли;
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ ЭЛЕМЕНТОВ ФОРМЫ

Процедура ПериодПриИзменении(Элемент)
	Если Элемент.Значение > РабочаяДата Тогда
		Ответ = Вопрос(НСтр("ru='Вы действительно хотите ввести данные';uk='Ви дійсно хочете ввести дані'") + Символы.ПС + НСтр("ru='об инвалидности физлица на будущую дату?';uk='про інвалідність фізособи на майбутню дату?'"), РежимДиалогаВопрос.ДаНет,,КодВозвратаДиалога.Нет);
		Если Ответ = КодВозвратаДиалога.Нет Тогда
			Элемент.Значение = РабочаяДата
		КонецЕсли;
	КонецЕсли;
КонецПроцедуры

Процедура ФизЛицоПриИзменении(Элемент)
	Заголовок = НСтр("ru='Сведения об инвалидности: ';uk='Відомості про інвалідність: '") + Элемент.Значение.Наименование
КонецПроцедуры

Процедура ИнвалидностьПриИзменении(Элемент)
	
	Если НЕ Инвалидность Тогда
		Группа = Перечисления.ГруппыИнвалидности.ПустаяСсылка();
		УдостоверениеСерия = "";
		УдостоверениеНомер = "";
		УдостоверениеДатаВыдачи = "";
	КонецЕсли;
	
	УстановитьДоступность();
		
КонецПроцедуры




