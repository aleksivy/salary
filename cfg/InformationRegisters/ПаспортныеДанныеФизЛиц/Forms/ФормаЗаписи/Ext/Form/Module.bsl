﻿Перем мФизЛицо; // сохраняем физлицо, данные которого начинали редактировать

////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ ФОРМЫ

Процедура ПриОткрытии()
	
	Если ФизЛицо = Неопределено Тогда
         ФизЛицо = Справочники.ФизическиеЛица.ПустаяСсылка();
    Иначе  
         Заголовок = НСтр("ru='Паспортные данные: ';uk='Паспортні дані: '") + ФизЛицо.Наименование;
	КонецЕсли;
	 
КонецПроцедуры

Процедура ПослеЗаписи()
	Оповестить("ОбновитьФорму", Новый Структура("ИмяЭлемента","УдостоверениеЛичности"), ФизЛицо);
	Если мФизЛицо <> ФизЛицо Тогда
        // оповестим также форму того физлица, данные которого начинали редактировать
		Оповестить("ОбновитьФорму", Новый Структура("ИмяЭлемента","УдостоверениеЛичности"), мФизЛицо);
		мФизЛицо = ФизЛицо;
	КонецЕсли;
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ ЭЛЕМЕНТОВ ФОРМЫ

Процедура ПериодПриИзменении(Элемент)
	Если Элемент.Значение > РабочаяДата Тогда
		Ответ = Вопрос(НСтр("ru='Вы действительно хотите ввести данные';uk='Ви дійсно хочете ввести дані'") + Символы.ПС + НСтр("ru='об удостоверении личности физлица на будущую дату?';uk='про посвідчення особи фізособи на майбутню дату?'"), РежимДиалогаВопрос.ДаНет,,КодВозвратаДиалога.Нет);
		Если Ответ = КодВозвратаДиалога.Нет Тогда
			Элемент.Значение = РабочаяДата
		КонецЕсли;
	КонецЕсли;
КонецПроцедуры

Процедура ФизЛицоПриИзменении(Элемент)
	Заголовок = НСтр("ru='Паспортные данные: ';uk='Паспортні дані: '") + Элемент.Значение.Наименование
КонецПроцедуры






