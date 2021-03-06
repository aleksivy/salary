////////////////////////////////////////////////////////////////////////////////
// ЭКСПОРТНЫЕ ПРОЦЕДУРЫ И ФУНКЦИИ

// Процедура заполняет табличное поле списком организаций
//
Процедура Автозаполнение() Экспорт
	
	ВводНаОсновании.Очистить();
	
	Если НЕ ЗначениеЗаполнено(Основание) Тогда
		Возврат;
	КонецЕсли;
	
	Запрос = Новый Запрос;
	
	ОсновнаяОрганизация = УправлениеПользователями.ПолучитьЗначениеПоУмолчанию(глЗначениеПеременной("глТекущийПользователь"), "ОсновнаяОрганизация");
	
	Запрос.УстановитьПараметр("Основание",				Основание);
	Запрос.УстановитьПараметр("ОсновнаяОрганизация",	ОсновнаяОрганизация);
	
	ИмяДокумента = Основание.Метаданные().Имя;
	
	Если ИмяДокумента = "ПриемНаРаботу" Тогда
		Если ОсновнаяОрганизация.Пустая() Тогда
			Запрос.Текст =
			"ВЫБРАТЬ РАЗРЕШЕННЫЕ РАЗЛИЧНЫЕ
			|	ИСТИНА КАК Отметка,
			|	Док.Сотрудник.Организация КАК Организация
			|ИЗ
			|	Документ.ПриемНаРаботу.Работники КАК Док
			|ГДЕ
			|	Док.Ссылка = &Основание";
			
		Иначе
			Запрос.Текст =
			"ВЫБРАТЬ РАЗРЕШЕННЫЕ РАЗЛИЧНЫЕ
			|	ВЫБОР
			|		КОГДА Док.Сотрудник.Организация = &ОсновнаяОрганизация
			|			ТОГДА ИСТИНА
			|		ИНАЧЕ ЛОЖЬ
			|	КОНЕЦ КАК Отметка,
			|	Док.Сотрудник.Организация КАК Организация
			|ИЗ
			|	Документ.ПриемНаРаботу.Работники КАК Док
			|ГДЕ
			|	Док.Ссылка = &Основание";
			
		КонецЕсли;
		
	Иначе
		Если ОсновнаяОрганизация.Пустая() Тогда
			Запрос.Текст =
			"ВЫБРАТЬ РАЗРЕШЕННЫЕ РАЗЛИЧНЫЕ
			|	ИСТИНА КАК Отметка,
			|	РаботникиОрганизаций.Организация
			|ИЗ
			|	РегистрСведений.РаботникиОрганизаций.СрезПоследних(
			|		,
			|		Сотрудник.Физлицо В
			|			(ВЫБРАТЬ РАЗЛИЧНЫЕ
			|				Док.Сотрудник.Физлицо
			|			ИЗ
			|				Документ."+ИмяДокумента+".Работники КАК Док
			|			ГДЕ
			|				Док.Ссылка = &Основание)) КАК РаботникиОрганизаций
			|ГДЕ
			|	РаботникиОрганизаций.ПричинаИзмененияСостояния  <> ЗНАЧЕНИЕ(Перечисление.ПричиныИзмененияСостояния.Увольнение)";
			
		Иначе
			Запрос.Текст =
			"ВЫБРАТЬ РАЗРЕШЕННЫЕ РАЗЛИЧНЫЕ
			|	ВЫБОР
			|		КОГДА РаботникиОрганизаций.Организация = &ОсновнаяОрганизация
			|			ТОГДА ИСТИНА
			|		ИНАЧЕ ЛОЖЬ
			|	КОНЕЦ КАК Отметка,
			|	РаботникиОрганизаций.Организация
			|ИЗ
			|	РегистрСведений.РаботникиОрганизаций.СрезПоследних(
			|		,
			|		Сотрудник.Физлицо В
			|			(ВЫБРАТЬ РАЗЛИЧНЫЕ
			|				Док.Сотрудник.Физлицо
			|			ИЗ
			|				Документ."+ИмяДокумента+".Работники КАК Док
			|			ГДЕ
			|				Док.Ссылка = &Основание)) КАК РаботникиОрганизаций
			|ГДЕ
			|	РаботникиОрганизаций.ПричинаИзмененияСостояния <> ЗНАЧЕНИЕ(Перечисление.ПричиныИзмененияСостояния.Увольнение)";
			
		КонецЕсли;
		
	КонецЕсли;
	
	ВводНаОсновании.Загрузить(Запрос.Выполнить().Выгрузить());
	
КонецПроцедуры // Автозаполнение()

// Функция возвращает имя документа в регл учете в зависимости от 
// документа-основания
//
Функция ПолучитьИмяДокумента() Экспорт
	
	Если ТипЗнч(Основание) = Тип("ДокументСсылка.ПриемНаРаботу") Тогда
		Возврат "ПриемНаРаботуВОрганизацию";
		
	ИначеЕсли ТипЗнч(Основание) = Тип("ДокументСсылка.КадровоеПеремещение") Тогда
		Возврат "КадровоеПеремещениеОрганизаций";
		
	ИначеЕсли ТипЗнч(Основание) = Тип("ДокументСсылка.Увольнение") Тогда
		Возврат "УвольнениеИзОрганизаций";
		
	ИначеЕсли ТипЗнч(Основание) = Тип("ДокументСсылка.ОтсутствиеНаРаботе") Тогда
		Возврат "ОтсутствиеНаРаботеОрганизаций";
		
	ИначеЕсли ТипЗнч(Основание) = Тип("ДокументСсылка.ВозвратНаРаботу") Тогда
		Возврат "ВозвратНаРаботуОрганизаций";
		
	ИначеЕсли ТипЗнч(Основание) = Тип("ДокументСсылка.ПланированиеОтпуска") Тогда
		Возврат "ГрафикОтпусковОрганизаций";
		
	Иначе
		Возврат "";
		
	КонецЕсли;
	
КонецФункции // ПолучитьИмяДокумента()

////////////////////////////////////////////////////////////////////////////////
// ОПЕРАТОРЫ ОСНОВНОЙ ПРОГРАММЫ
