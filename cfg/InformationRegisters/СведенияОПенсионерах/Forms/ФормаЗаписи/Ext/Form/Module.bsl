Перем мФизЛицо; // сохраняем физлицо, данные которого начинали редактировать

Процедура УстановитьДоступность()
	
	ЭлементыФормы.СвидетельствоСерия.Доступность = Пенсионер;
	ЭлементыФормы.СвидетельствоНомер.Доступность = Пенсионер;
	ЭлементыФормы.СвидетельствоДатаВыдачи.Доступность = Пенсионер;
	
КонецПроцедуры	

////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ ФОРМЫ

Процедура ПриОткрытии()
	
	Заголовок = НСтр("ru='Сведения о пенсионерах: ';uk='Відомості про пенсіонерів: '") + ФизЛицо.Наименование;
	мФизЛицо = ФизЛицо;
КонецПроцедуры

Процедура ПослеЗаписи()
	Оповестить("ОбновитьФорму", Новый Структура("ИмяЭлемента","Пенсионеры"), ФизЛицо);
	Если мФизЛицо <> ФизЛицо Тогда
        // оповестим также форму того физлица, данные которого начинали редактировать
		Оповестить("ОбновитьФорму", Новый Структура("ИмяЭлемента","Пенсионеры"), мФизЛицо);
		мФизЛицо = ФизЛицо;
	КонецЕсли;
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ ЭЛЕМЕНТОВ ФОРМЫ

Процедура ПериодПриИзменении(Элемент)
	Если Элемент.Значение > РабочаяДата Тогда
		Ответ = Вопрос(НСтр("ru='Вы действительно хотите ввести данные';uk='Ви дійсно хочете ввести дані'") + Символы.ПС + НСтр("ru='о пенсионере на будущую дату?';uk='про пенсіонера на майбутню дату?'"), РежимДиалогаВопрос.ДаНет,,КодВозвратаДиалога.Нет);
		Если Ответ = КодВозвратаДиалога.Нет Тогда
			Элемент.Значение = РабочаяДата
		КонецЕсли;
	КонецЕсли;
КонецПроцедуры

Процедура ФизЛицоПриИзменении(Элемент)
	Заголовок = НСтр("ru='Сведения об инвалидности: ';uk='Відомості про інвалідність: '") + Элемент.Значение.Наименование
КонецПроцедуры

Процедура ПенсионерПриИзменении(Элемент)
	
	Если НЕ Пенсионер Тогда
		СвидетельствоСерия = "";
		СвидетельствоНомер = "";
		СвидетельствоДатаВыдачи = "";
	КонецЕсли;
	
	УстановитьДоступность();
		
КонецПроцедуры




