﻿#Если Клиент Тогда
	
////////////////////////////////////////////////////////////////////////////////
// ПРОЦЕДУРЫ И ФУНКЦИИ НАЧАЛЬНОЙ НАСТРОЙКИ ОТЧЕТА

// Процедура установки начальных настроек отчета с использованием текста запроса
//
Процедура УстановитьНачальныеНастройки(ДополнительныеПараметры = Неопределено) Экспорт
	
	// Настройка общих параметров универсального отчета
	
	// Содержит название отчета, которое будет выводиться в шапке.
	// Тип: Строка.
	// Пример:
	// УниверсальныйОтчет.мНазваниеОтчета = "Название отчета";
	УниверсальныйОтчет.мНазваниеОтчета = СокрЛП(ЭтотОбъект.Метаданные().Синоним);
	
	// Содержит признак необходимости отображения надписи и поля выбора раздела учета в форме настройки.
	// Тип: Булево.
	// Значение по умолчанию: Истина.
	// Пример:
	УниверсальныйОтчет.мВыбиратьИмяРегистра = Ложь;
	
	// Содержит имя регистра, по метаданным которого будет выполняться заполнение настроек отчета.
	// Тип: Строка.
	// Пример:
	// УниверсальныйОтчет.ИмяРегистра = "ТоварыНаСкладах";
	
	// Содержит значение используемого режима ввода периода.
	// Тип: Число.
	// Возможные значения: 0 - произвольный период, 1 - на дату, 2 - неделя, 3 - декада, 4 - месяц, 5 - квартал, 6 - полугодие, 7 - год
	// Значение по умолчанию: 0
	// Пример:
	 УниверсальныйОтчет.мРежимВводаПериода = 1;
	
	// Содержит признак необходимости вывода отрицательных значений показателей красным цветом.
	// Тип: Булево.
	// Значение по умолчанию: Ложь.
	// Пример:
	// УниверсальныйОтчет.ОтрицательноеКрасным = Истина;
	
	// Содержит признак необходимости вывода в отчет общих итогов.
	// Тип: Булево.
	// Значение по умолчанию: Ложь.
	// Пример:
	УниверсальныйОтчет.ВыводитьОбщиеИтоги = Ложь;
	
	// Содержит признак необходимости вывода детальных записей в отчет.
	// Тип: Булево.
	// Значение по умолчанию: Ложь.
	// Пример:
	УниверсальныйОтчет.ВыводитьДетальныеЗаписи = Истина;
	
	// Содержит признак необходимости отображения флага использования свойств и категорий в форме настройки.
	// Тип: Булево.
	// Значение по умолчанию: Истина.
	// Пример:
	//УниверсальныйОтчет.мВыбиратьИспользованиеСвойств = Ложь;
	
	// Содержит признак использования свойств и категорий при заполнении настроек отчета.
	// Тип: Булево.
	// Значение по умолчанию: Истина.
	// Пример:
	//УниверсальныйОтчет.ИспользоватьСвойстваИКатегории = Ложь;
	
	// Содержит признак использования простой формы настроек отчета без группировок колонок.
	// Тип: Булево.
	// Значение по умолчанию: Ложь.
	// Пример:
	// УниверсальныйОтчет.мРежимФормыНастройкиБезГруппировокКолонок = Истина;
	УниверсальныйОтчет.мРежимФормыНастройкиБезГруппировокКолонок = Истина;
	УниверсальныйОтчет.ИспользоватьИнтервальныеГруппировки = Истина;
	
	// Дополнительные параметры, переданные из отчета, вызвавшего расшифровку.
	// Информация, передаваемая в переменной ДополнительныеПараметры, может быть использована
	// для реализации специфичных для данного отчета параметрических настроек.
	
	// Описание исходного текста запроса.
	// При написании текста запроса рекомендуется следовать правилам, описанным в следующем шаблоне текста запроса:
	//
	//ВЫБРАТЬ
	//	<ПсевдонимТаблицы.Поле> КАК <ПсевдонимПоля>,
	//	ПРЕДСТАВЛЕНИЕ(<ПсевдонимТаблицы>.<Поле>),
	//	<ПсевдонимТаблицы.Показатель> КАК <ПсевдонимПоказателя>
	//	//ПОЛЯ_СВОЙСТВА
	//	//ПОЛЯ_КАТЕГОРИИ
	//{ВЫБРАТЬ
	//	<ПсевдонимПоля>.*,
	//	<ПсевдонимПоказателя>,
	//	Регистратор,
	//	Период,
	//	ПериодДень,
	//	ПериодНеделя,
	//	ПериодДекада,
	//	ПериодМесяц,
	//	ПериодКвартал,
	//	ПериодПолугодие,
	//	ПериодГод
	//	//ПОЛЯ_СВОЙСТВА
	//	//ПОЛЯ_КАТЕГОРИИ
	//}
	//ИЗ
	//	<Таблица> КАК <ПсевдонимТаблицы>
	//	//СОЕДИНЕНИЯ
	//{ГДЕ
	//	<ПсевдонимТаблицы.Поле>.* КАК <ПсевдонимПоля>,
	//	<ПсевдонимТаблицы.Показатель> КАК <ПсевдонимПоказателя>,
	//	<ПсевдонимТаблицы>.Регистратор КАК Регистратор,
	//	<ПсевдонимТаблицы>.Период КАК Период,
	//	НАЧАЛОПЕРИОДА(<ПсевдонимТаблицы>.Период, ДЕНЬ) КАК ПериодДень,
	//	НАЧАЛОПЕРИОДА(<ПсевдонимТаблицы>.Период, НЕДЕЛЯ) КАК ПериодНеделя,
	//	НАЧАЛОПЕРИОДА(<ПсевдонимТаблицы>.Период, ДЕКАДА) КАК ПериодДекада,
	//	НАЧАЛОПЕРИОДА(<ПсевдонимТаблицы>.Период, МЕСЯЦ) КАК ПериодМесяц,
	//	НАЧАЛОПЕРИОДА(<ПсевдонимТаблицы>.Период, КВАРТАЛ) КАК ПериодКвартал,
	//	НАЧАЛОПЕРИОДА(<ПсевдонимТаблицы>.Период, ПОЛУГОДИЕ) КАК ПериодПолугодие,
	//	НАЧАЛОПЕРИОДА(<ПсевдонимТаблицы>.Период, ГОД) КАК ПериодГод
	//	//ПОЛЯ_СВОЙСТВА
	//	//ПОЛЯ_КАТЕГОРИИ
	//}
	//{УПОРЯДОЧИТЬ ПО
	//	<ПсевдонимПоля>.*,
	//	<ПсевдонимПоказателя>,
	//	Регистратор,
	//	Период,
	//	ПериодДень,
	//	ПериодНеделя,
	//	ПериодДекада,
	//	ПериодМесяц,
	//	ПериодКвартал,
	//	ПериодПолугодие,
	//	ПериодГод
	//	//УПОРЯДОЧИТЬ_СВОЙСТВА
	//	//УПОРЯДОЧИТЬ_КАТЕГОРИИ
	//}
	//ИТОГИ
	//	АГРЕГАТНАЯ_ФУНКЦИЯ(<ПсевдонимПоказателя>)
	//	//ИТОГИ_СВОЙСТВА
	//	//ИТОГИ_КАТЕГОРИИ
	//ПО
	//	ОБЩИЕ
	//{ИТОГИ ПО
	//	<ПсевдонимПоля>.*,
	//	Регистратор,
	//	Период,
	//	ПериодДень,
	//	ПериодНеделя,
	//	ПериодДекада,
	//	ПериодМесяц,
	//	ПериодКвартал,
	//	ПериодПолугодие,
	//	ПериодГод
	//	//ПОЛЯ_СВОЙСТВА
	//	//ПОЛЯ_КАТЕГОРИИ
	//}
	//АВТОУПОРЯДОЧИВАНИЕ
	ТекстЗапроса = 
	"ВЫБРАТЬ РАЗРЕШЕННЫЕ
	|	РаботникиОрганизации.Сотрудник,
	|	ПРЕДСТАВЛЕНИЕ(РаботникиОрганизации.Сотрудник),
	|	РаботникиОрганизации.Сотрудник.ФизЛицо КАК ФизЛицо,
	|	ПРЕДСТАВЛЕНИЕ(РаботникиОрганизации.Сотрудник.ФизЛицо) КАК ФизЛицоПредставление,
	|	ПРЕДСТАВЛЕНИЕ(РаботникиОрганизации.Сотрудник),
	|	РаботникиОрганизации.ПодразделениеОрганизации КАК ПодразделениеОрганизации,
	|   ПРЕДСТАВЛЕНИЕ(РаботникиОрганизации.ПодразделениеОрганизации),
	|	РаботникиОрганизации.ОбособленноеПодразделение КАК ОбособленноеПодразделение,
	|   ПРЕДСТАВЛЕНИЕ(РаботникиОрганизации.ОбособленноеПодразделение),	
	|	РаботникиОрганизации.Должность КАК Должность,
	|   ПРЕДСТАВЛЕНИЕ(РаботникиОрганизации.Должность),	
	|	РаботникиОрганизации.ГрафикРаботы КАК ГрафикРаботы,
	|   ПРЕДСТАВЛЕНИЕ(РаботникиОрганизации.ГрафикРаботы),	
	|	РаботникиОрганизации.ЗанимаемыхСтавок КАК ЗанимаемыхСтавок,
	|	РаботникиОрганизации.Организация КАК Организация, //ГоловнаяОрганизация
	|	ПРЕДСТАВЛЕНИЕ(РаботникиОрганизации.Организация),
	|	РаботникиОрганизации.Сотрудник.Код КАК ТабельныйНомер,
	|	ПриказыОПриеме.Приказ КАК ПриказОПриеме,
	|	ПриказыОПриеме.ДатаПриема КАК ДатаПриема,
	|	ПриказыОПриеме.ВидЗанятости КАК ВидЗанятости,
	|	ВЫБОР
	|			КОГДА РаботникиОрганизации.ПричинаИзмененияСостояния = ЗНАЧЕНИЕ(Перечисление.ПричиныИзмененияСостояния.Увольнение)
	|				ТОГДА ДОБАВИТЬКДАТЕ(РаботникиОрганизации.Период, ДЕНЬ, -1)
	|			ИНАЧЕ ""-""
	|		КОНЕЦ КАК ДатаУвольнения,
	|	ПлановыеНачисленияРаботниковСрез.ВидРасчета КАК ВидРасчета,
	|	ПлановыеНачисленияРаботниковСрез.Валюта1 КАК Валюта,
	|	ЕСТЬNULL(ПлановыеНачисленияРаботниковСрез.Показатель1, 0) КАК Размер,
	|	ВЫБОР
	|			КОГДА РаботникиОрганизации.ПричинаИзмененияСостояния = ЗНАЧЕНИЕ(Перечисление.ПричиныИзмененияСостояния.Увольнение)
	|				ТОГДА &СостояниеУволен
	|			ИНАЧЕ ЕСТЬNULL(ВЫБОР
	|						КОГДА &ДатаАктуальности > СостояниеРаботниковОрганизации.ПериодЗавершения
	|								И СостояниеРаботниковОрганизации.ПериодЗавершения <> ДАТАВРЕМЯ(1, 1, 1, 0, 0, 0)
	|							ТОГДА СостояниеРаботниковОрганизации.СостояниеЗавершения
	|						ИНАЧЕ СостояниеРаботниковОрганизации.Состояние
	|					КОНЕЦ, &СостояниеРаботает)
	|		КОНЕЦ КАК Состояние
	|	//ПОЛЯ_СВОЙСТВА
	|	//ПОЛЯ_КАТЕГОРИИ
	|	//ПОЛЯ_КОНТАКТНАЯИНФОРМАЦИЯ
	|	//ПОЛЯ_ДАННЫЕОФИЗЛИЦЕ
	|	//ПОЛЯ_ИНТЕРВАЛЬНЫЕГРУППИРОВКИФИЗЛИЦ
	|
	|{ВЫБРАТЬ
	|	// данные о работнике организации
	|	Сотрудник,
	|	ФизЛицо,
	|	(РаботникиОрганизации.ПодразделениеОрганизации).* КАК ПодразделениеОрганизации,
	|	(РаботникиОрганизации.ОбособленноеПодразделение).* КАК ОбособленноеПодразделение,
	|	(РаботникиОрганизации.Должность).* КАК Должность,
	|	(РаботникиОрганизации.ГрафикРаботы).* КАК ГрафикРаботы,
	|	Организация.*,
	|	ТабельныйНомер,
	|	РаботникиОрганизации.ЗанимаемыхСтавок КАК ЗанимаемыхСтавок,
	|	ПриказОПриеме,
	|	ДатаПриема,
	|	ВидЗанятости,
	|	ДатаУвольнения,
	|	ВидРасчета,
	|	Валюта,
	|	Размер,
	|	Состояние
	|	//ПСЕВДОНИМЫ_СВОЙСТВА
	|	//ПСЕВДОНИМЫ_КАТЕГОРИИ
	|	//ПОЛЯ_КОНТАКТНАЯИНФОРМАЦИЯ
	|	//ПСЕВДОНИМЫ_ДАННЫЕОФИЗЛИЦЕ
	|	//ПОЛЯ_ИНТЕРВАЛЬНЫЕГРУППИРОВКИФИЗЛИЦ
	|}
	|
	|ИЗ
	|	РегистрСведений.РаботникиОрганизаций.СрезПоследних(&ДатаАктуальности) КАК РаботникиОрганизации
	|		{ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.СостояниеРаботниковОрганизаций.СрезПоследних(&ДатаАктуальности, ) КАК СостояниеРаботниковОрганизации
	|		ПО РаботникиОрганизации.Сотрудник = СостояниеРаботниковОрганизации.Сотрудник}
	|		//СОЕДИНЕНИЯ
	|		//КОНТАКТНАЯИНФОРМАЦИЯ_СОЕДИНЕНИЯ
	|		//ДАННЫЕОФИЗЛИЦЕ_СОЕДИНЕНИЯ
	|		{ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.ПлановыеНачисленияРаботниковОрганизаций.СрезПоследних(&ДатаАктуальности, ВидРасчетаИзмерение = НЕОПРЕДЕЛЕНО) КАК ПлановыеНачисленияРаботниковСрез
	|			ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.РазмерТарифныхСтавок.СрезПоследних(&ДатаАктуальности, ) КАК РазмерТарифныхСтавокСрезПоследних
	|			ПО (ПлановыеНачисленияРаботниковСрез.ТарифныйРазряд1 = РазмерТарифныхСтавокСрезПоследних.ТарифныйРазряд)
	|		ПО РаботникиОрганизации.Сотрудник = ПлановыеНачисленияРаботниковСрез.Сотрудник}
	|		{ЛЕВОЕ СОЕДИНЕНИЕ (ВЫБРАТЬ
	|			ДатыПоследнихДвиженийРаботников.Период КАК ДатаПриема,
	|			ДатыПоследнихДвиженийРаботников.Организация,
	|			ДатыПоследнихДвиженийРаботников.ФизЛицо,
	|			ДатыПоследнихДвиженийРаботников.Сотрудник Как Сотрудник,
	|			ДанныеПоРаботникуПриНазначении.Регистратор КАК Приказ,
	|			ДатыПоследнихДвиженийРаботников.Сотрудник.ВидЗанятости КАК ВидЗанятости
	|		ИЗ
	|			(ВЫБРАТЬ
	|				ТЧРаботникиОрганизации.Организация,
	|				МАКСИМУМ(Работники.Период) КАК Период,
	|				ТЧРаботникиОрганизации.Сотрудник.ФизЛицо КАК ФизЛицо,
	|				ТЧРаботникиОрганизации.Сотрудник КАК Сотрудник
	|			ИЗ
	|				РегистрСведений.РаботникиОрганизаций.СрезПоследних(&ДатаАктуальности,) КАК ТЧРаботникиОрганизации
	|					ВНУТРЕННЕЕ СОЕДИНЕНИЕ РегистрСведений.РаботникиОрганизаций КАК Работники
	|					ПО ТЧРаботникиОрганизации.Сотрудник = Работники.Сотрудник
	|						И Работники.Период <= ТЧРаботникиОрганизации.Период
	|						И (Работники.ПричинаИзмененияСостояния = ЗНАЧЕНИЕ(Перечисление.ПричиныИзмененияСостояния.ПриемНаРаботу))
	|			{ГДЕ
	|				ТЧРаботникиОрганизации.Должность КАК Должность,
	|				ТЧРаботникиОрганизации.ГрафикРаботы КАК ГрафикРаботы,
	|				ТЧРаботникиОрганизации.Сотрудник.Код КАК ТабельныйНомер,
	|				ТЧРаботникиОрганизации.ЗанимаемыхСтавок КАК ЗанимаемыхСтавок,
	|				ТЧРаботникиОрганизации.ОбособленноеПодразделение КАК ОбособленноеПодразделение,
	|				ТЧРаботникиОрганизации.ПодразделениеОрганизации КАК Подразделение}
	|			
	|			СГРУППИРОВАТЬ ПО
	|				ТЧРаботникиОрганизации.Организация,
	|				ТЧРаботникиОрганизации.Сотрудник.ФизЛицо,
	|				ТЧРаботникиОрганизации.Сотрудник) КАК ДатыПоследнихДвиженийРаботников
	|				ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.РаботникиОрганизаций КАК ДанныеПоРаботникуПриНазначении
	|				ПО ДанныеПоРаботникуПриНазначении.Период = ДатыПоследнихДвиженийРаботников.Период
	|					И ДатыПоследнихДвиженийРаботников.Сотрудник = ДанныеПоРаботникуПриНазначении.Сотрудник) КАК ПриказыОПриеме
	|		ПО ПриказыОПриеме.Сотрудник = РаботникиОрганизации.Сотрудник}
	|
	|{ГДЕ
	|	РаботникиОрганизации.Сотрудник КАК Сотрудник,
	|	РаботникиОрганизации.Сотрудник.ФизЛицо КАК ФизЛицо,
	|	(РаботникиОрганизации.ПодразделениеОрганизации).* КАК ПодразделениеОрганизации,
	|	(РаботникиОрганизации.ОбособленноеПодразделение).* КАК ОбособленноеПодразделение,
	|	(РаботникиОрганизации.Должность).* КАК Должность,
	|	(РаботникиОрганизации.ГрафикРаботы).* КАК ГрафикРаботы,
	|	РаботникиОрганизации.Организация.* КАК Организация,
	|	РаботникиОрганизации.Сотрудник.Код КАК ТабельныйНомер,
	|	РаботникиОрганизации.ЗанимаемыхСтавок КАК ЗанимаемыхСтавок,
	|	ПриказыОПриеме.Приказ КАК ПриказОПриеме,
	|	ПриказыОПриеме.ДатаПриема КАК ДатаПриема,
	|	ВЫБОР
	|			КОГДА РаботникиОрганизации.ПричинаИзмененияСостояния = ЗНАЧЕНИЕ(Перечисление.ПричиныИзмененияСостояния.Увольнение)
	|				ТОГДА ДОБАВИТЬКДАТЕ(РаботникиОрганизации.Период, ДЕНЬ, -1)
	|			ИНАЧЕ ""-""
	|		КОНЕЦ КАК ДатаУвольнения,
	|	ПлановыеНачисленияРаботниковСрез.ВидРасчета КАК ВидРасчета,
	|	ПлановыеНачисленияРаботниковСрез.Валюта1 КАК Валюта,
	|	ЕСТЬNULL(ПлановыеНачисленияРаботниковСрез.Показатель1, 0) КАК Размер,
	|	ВЫБОР
	|			КОГДА РаботникиОрганизации.ПричинаИзмененияСостояния = ЗНАЧЕНИЕ(Перечисление.ПричиныИзмененияСостояния.Увольнение)
	|				ТОГДА &СостояниеУволен
	|			ИНАЧЕ ЕСТЬNULL(ВЫБОР
	|						КОГДА &ДатаАктуальности > СостояниеРаботниковОрганизации.ПериодЗавершения
	|								И СостояниеРаботниковОрганизации.ПериодЗавершения <> ДАТАВРЕМЯ(1, 1, 1, 0, 0, 0)
	|							ТОГДА СостояниеРаботниковОрганизации.СостояниеЗавершения
	|						ИНАЧЕ СостояниеРаботниковОрганизации.Состояние
	|					КОНЕЦ, &СостояниеРаботает)
	|		КОНЕЦ КАК Состояние
	|	//УСЛОВИЯ_СВОЙСТВА
	|	//УСЛОВИЯ_КАТЕГОРИИ
	|	//ПОЛЯ_КОНТАКТНАЯИНФОРМАЦИЯ
	|	//ПОЛЯ_ДАННЫЕОФИЗЛИЦЕ
	|}
	|
	|{УПОРЯДОЧИТЬ ПО
	|	Сотрудник.*,
	|	ФизЛицо,
	|	(РаботникиОрганизации.ПодразделениеОрганизации).* КАК ПодразделениеОрганизации,
	|	(РаботникиОрганизации.ОбособленноеПодразделение).* КАК ОбособленноеПодразделение,
	|	(РаботникиОрганизации.Должность).* КАК Должность,
	|	(РаботникиОрганизации.ГрафикРаботы).* КАК ГрафикРаботы,
	|	Организация.*,
	|	РаботникиОрганизации.ЗанимаемыхСтавок КАК ЗанимаемыхСтавок,
	|	ПриказОПриеме,
	|	ДатаПриема,
	|	ВидЗанятости,
	|	ДатаУвольнения,
	|	ВидРасчета,
	|	Валюта,
	|	Размер,
	|	Состояние
	|	//ПСЕВДОНИМЫ_СВОЙСТВА
	|	//ПСЕВДОНИМЫ_КАТЕГОРИИ
	|	//УПОРЯДОЧИТЬ_КОНТАКТНАЯИНФОРМАЦИЯ
	|	//УПОРЯДОЧИТЬ_ДАННЫЕОФИЗЛИЦЕ
	|}
	|
	|ИТОГИ
	|	СУММА(ЗанимаемыхСтавок)
	|	//ИТОГИ_КОНТАКТНАЯИНФОРМАЦИЯ
	|	//ИТОГИ_ДАННЫЕОФИЗЛИЦЕ
	|	//ИТОГИ_СВОЙСТВА
	|	//ИТОГИ_КАТЕГОРИИ
	|ПО
	|	ОБЩИЕ
	|
	|{ИТОГИ ПО
	|	Сотрудник,
	|	ФизЛицо,
	|	ПодразделениеОрганизации.*,
	|	ОбособленноеПодразделение.*,
	|	Должность.*,
	|	ГрафикРаботы.*,
	|	Организация.*,
	|	ЗанимаемыхСтавок,
	|	ПриказОПриеме,
	|	ДатаПриема,
	|	ВидЗанятости,
	|	ДатаУвольнения,
	|	ВидРасчета,
	|	Валюта,
	|	Состояние
	|	//ПСЕВДОНИМЫ_СВОЙСТВА
	|	//ПСЕВДОНИМЫ_КАТЕГОРИИ
	|	//ПОЛЯ_КОНТАКТНАЯИНФОРМАЦИЯ
	|	//ПСЕВДОНИМЫ_ДАННЫЕОФИЗЛИЦЕ
	|	//ИТОГИ_ИНТЕРВАЛЬНЫЕГРУППИРОВКИФИЗЛИЦ
	|}
	|АВТОУПОРЯДОЧИВАНИЕ";

	// Преобразуем текст запроса для получения полной информации о физлице
	УниверсальныйОтчет.ДобавитьКонтактнуюИнформацияДляПоля("РаботникиОрганизации.Сотрудник.ФизЛицо", "ФизЛицо", "Физическое лицо", Перечисления.ВидыОбъектовКонтактнойИнформации.ФизическиеЛица, "Справочник.ФизическиеЛица");
	УниверсальныйОтчет.ДобавитьВТекстЗапросаКонтактнуюИнформацию(ТекстЗапроса);
	УниверсальныйОтчет.ДобавитьДанныеОФизлицеДляПоля("РаботникиОрганизации.Сотрудник.ФизЛицо", "ФизЛицо", "Физическое лицо");
	УниверсальныйОтчет.ДобавитьВТекстЗапросаДанныеОФизлице(ТекстЗапроса);
	УниверсальныйОтчет.ДобавитьВТекстЗапросаИнтервальныеГруппировкиФизлиц(ТекстЗапроса);

	// В универсальном отчете включен флаг использования свойств и категорий.
	Если УниверсальныйОтчет.ИспользоватьСвойстваИКатегории Тогда
		
		// Добавление свойств и категорий поля запроса в таблицу полей.
		// Необходимо вызывать для каждого поля запроса, предоставляющего возможность использования свойств и категорий.
		
		// УниверсальныйОтчет.ДобавитьСвойстваИКатегорииДляПоля(<ПсевдонимТаблицы>.<Поле> , <ПсевдонимПоля>, <Представление>, <Назначение>);
		УниверсальныйОтчет.ДобавитьСвойстваИКатегорииДляПоля("РаботникиОрганизации.Сотрудник.ФизЛицо", "ФизЛицо", "Физическое лицо", ПланыВидовХарактеристик.НазначенияСвойствКатегорийОбъектов.Справочник_ФизическиеЛица);
		УниверсальныйОтчет.ДобавитьСвойстваИКатегорииДляПоля("РаботникиОрганизации.Сотрудник", "Сотрудник", "Работник", ПланыВидовХарактеристик.НазначенияСвойствКатегорийОбъектов.Справочник_СотрудникиОрганизаций);
		УниверсальныйОтчет.ДобавитьСвойстваИКатегорииДляПоля("РаботникиОрганизации.Должность", "Должность", "Должность", ПланыВидовХарактеристик.НазначенияСвойствКатегорийОбъектов.Справочник_ДолжностиОрганизаций);
		
		// Добавление свойств и категорий в исходный текст запроса.
		УниверсальныйОтчет.ДобавитьВТекстЗапросаСвойстваИКатегории(ТекстЗапроса);
		
	КонецЕсли;
		
	// Инициализация текста запроса построителя отчета
	УниверсальныйОтчет.ПостроительОтчета.Текст = ТекстЗапроса;
	
	// Представления полей отчета.
	// Необходимо вызывать для каждого поля запроса.
	// УниверсальныйОтчет.мСтруктураПредставлениеПолей.Вставить(<ИмяПоля>, <ПредставлениеПоля>);
	УниверсальныйОтчет.мСтруктураПредставлениеПолей.Вставить("Сотрудник", "Работник");
	УниверсальныйОтчет.мСтруктураПредставлениеПолей.Вставить("ФизЛицо",   "Физическое лицо");
	УниверсальныйОтчет.мСтруктураПредставлениеПолей.Вставить("ЗанимаемыхСтавок", "Занято ставок");
	УниверсальныйОтчет.мСтруктураПредставлениеПолей.Вставить("ВидЗанятости", "Вид занятости");
	УниверсальныйОтчет.мСтруктураПредставлениеПолей.Вставить("ПодразделениеОрганизации", "Подразделение");
	УниверсальныйОтчет.мСтруктураПредставлениеПолей.Вставить("Организация", "Организация");
	//УниверсальныйОтчет.мСтруктураПредставлениеПолей.Вставить("ОбособленноеПодразделение", "Организация");
	УниверсальныйОтчет.мСтруктураПредставлениеПолей.Вставить("ГрафикРаботы", "График работы");
	УниверсальныйОтчет.мСтруктураПредставлениеПолей.Вставить("ТабельныйНомер", "Табельный номер");
	УниверсальныйОтчет.мСтруктураПредставлениеПолей.Вставить("ВидРасчета", "	");
	УниверсальныйОтчет.мСтруктураПредставлениеПолей.Вставить("ПриказОПриеме", "Приказ о приеме");
	УниверсальныйОтчет.мСтруктураПредставлениеПолей.Вставить("ДатаПриема", "Дата приема");
	УниверсальныйОтчет.мСтруктураПредставлениеПолей.Вставить("ДатаУвольнения", "Дата увольнения");
	УниверсальныйОтчет.мСтруктураПредставлениеПолей.Вставить("Размер", "Тарифная ставка");
	
	УниверсальныйОтчет.мСтруктураФорматаПолей.Вставить("ДатаПриема", "ДФ=dd.MM.yyyy");
	УниверсальныйОтчет.мСтруктураФорматаПолей.Вставить("ДатаУвольнения", "ДФ=dd.MM.yyyy");
	
	// Добавление показателей
	// Необходимо вызывать для каждого добавляемого показателя.
	// УниверсальныйОтчет.ДобавитьПоказатель(<ИмяПоказателя>, <ПредставлениеПоказателя>, <ВключенПоУмолчанию>, <Формат>, <ИмяГруппы>, <ПредставлениеГруппы>);
	
	// Добавление предопределенных группировок строк отчета.
	// Необходимо вызывать для каждой добавляемой группировки строки.
	// УниверсальныйОтчет.ДобавитьИзмерениеСтроки(<ПутьКДанным>);
	УниверсальныйОтчет.ДобавитьИзмерениеСтроки("Организация");
	УниверсальныйОтчет.ДобавитьИзмерениеСтроки("ФизЛицоВоенкомат");
	
	// Добавление предопределенных группировок колонок отчета.
	// Необходимо вызывать для каждой добавляемой группировки колонки.
	// УниверсальныйОтчет.ДобавитьИзмерениеКолонки(<ПутьКДанным>);
	
	// Добавление предопределенных отборов отчета.
	// Необходимо вызывать для каждого добавляемого отбора.
	// УниверсальныйОтчет.ДобавитьОтбор(<ПутьКДанным>);
	УниверсальныйОтчет.ДобавитьОтбор("Организация");
	УниверсальныйОтчет.ДобавитьОтбор("ПодразделениеОрганизации");
	УниверсальныйОтчет.ДобавитьОтбор("Состояние", Истина, ВидСравнения.НеРавно, Перечисления.СостоянияРаботникаОрганизации.НеРаботает, , , Ложь);
	УниверсальныйОтчет.ДобавитьОтбор("ФизЛицоПол", Истина, ВидСравнения.Равно, Перечисления.ПолФизическихЛиц.Мужской);
	УниверсальныйОтчет.ДобавитьОтбор("ФизЛицоВозраст", Истина, ВидСравнения.ИнтервалВключаяГраницы,, 15, 16);
	
	УниверсальныйОтчет.ДобавитьПорядок("Сотрудник.Наименование");
	
	// Установка связи подчиненных и родительских полей
	// УниверсальныйОтчет.УстановитьСвязьПолей(<ПутьКДанным>, <ПутьКДанным>);
	
	// Установка связи полей и измерений
	// УниверсальныйОтчет.УстановитьСвязьПоляИИзмерения(<ИмяПоля>, <ИмяИзмерения>);
	
	// Установка представлений полей
	УниверсальныйОтчет.УстановитьПредставленияПолей(УниверсальныйОтчет.мСтруктураПредставлениеПолей, УниверсальныйОтчет.ПостроительОтчета);
	
	// Установка типов значений свойств в отборах отчета
	УниверсальныйОтчет.УстановитьТипыЗначенийСвойствДляОтбора();
	
	// Заполнение начальных настроек универсального отчета
	УниверсальныйОтчет.УстановитьНачальныеНастройки(Ложь);
	
	// Добавление дополнительных полей
	// Необходимо вызывать для каждого добавляемого дополнительного поля.
	// УниверсальныйОтчет.ДобавитьДополнительноеПоле(<ПутьКДанным>);
	УниверсальныйОтчет.ДобавитьДополнительноеПоле("ТабельныйНомер");
	УниверсальныйОтчет.ДобавитьДополнительноеПоле("Сотрудник");
	
	АдресФакт = "ФизЛицоВидКонтактнойИнформации" + АдресФакт + "Представление";
	ЮрАдресФизЛица = СтрЗаменить(Строка(Справочники.ВидыКонтактнойИнформации.ЮрАдресФизЛица.УникальныйИдентификатор()), "-", "");
	ЮрАдресФизЛица = "ФизЛицоВидКонтактнойИнформации" + ЮрАдресФизЛица + "Представление";
	
	УниверсальныйОтчет.ДобавитьДополнительноеПоле("ФизЛицоОтношениеКВоинскомуУчету");
	УниверсальныйОтчет.ДобавитьДополнительноеПоле("ФизЛицоГодность");
	УниверсальныйОтчет.ДобавитьДополнительноеПоле("ФизЛицоДатаРождения");
	УниверсальныйОтчет.ДобавитьДополнительноеПоле("ФизЛицоДокументВид");
	УниверсальныйОтчет.ДобавитьДополнительноеПоле("ФизЛицоДокументСерия");
	УниверсальныйОтчет.ДобавитьДополнительноеПоле("ФизЛицоДокументНомер");
	УниверсальныйОтчет.ДобавитьДополнительноеПоле("ФизЛицоДокументДатаВыдачи");
	УниверсальныйОтчет.ДобавитьДополнительноеПоле("ФизЛицоДокументКемВыдан");
	УниверсальныйОтчет.ДобавитьДополнительноеПоле("ФизЛицоДокументКодПодразделения");
	УниверсальныйОтчет.ДобавитьДополнительноеПоле(АдресФакт);
	УниверсальныйОтчет.ДобавитьДополнительноеПоле(ЮрАдресФизЛица);
	
	УниверсальныйОтчет.мСтруктураФорматаПолей.Вставить("ДокументДатаВыдачи", "ДЛФ=DD");
	УниверсальныйОтчет.мСтруктураФорматаПолей.Вставить("ДатаРождения", "ДЛФ=DD");
	
КонецПроцедуры // УстановитьНачальныеНастройки()

////////////////////////////////////////////////////////////////////////////////
// ПРОЦЕДУРЫ И ФУНКЦИИ ФОРМИРОВАНИЯ ОТЧЕТА 
	
// Процедура формирования отчета
//
Процедура СформироватьОтчет(ТабличныйДокумент) Экспорт
	
	// Перед формирование отчета можно установить необходимые параметры универсального отчета.
	Если ЗначениеЗаполнено(УниверсальныйОтчет.ДатаКон) Тогда 
		УниверсальныйОтчет.ПостроительОтчета.Параметры.Вставить("ДатаАктуальности", КонецДня(УниверсальныйОтчет.ДатаКон));
		УниверсальныйОтчет.ПостроительОтчета.Параметры.Вставить("ДатаАктуальности_Год", Год(УниверсальныйОтчет.ДатаКон));
		УниверсальныйОтчет.ПостроительОтчета.Параметры.Вставить("ДатаАктуальности_Месяц", Месяц(УниверсальныйОтчет.ДатаКон));
		УниверсальныйОтчет.ПостроительОтчета.Параметры.Вставить("ДатаАктуальности_День", День(УниверсальныйОтчет.ДатаКон));
	Иначе 
		РД = ОбщегоНазначения.ПолучитьРабочуюДату();
		УниверсальныйОтчет.ПостроительОтчета.Параметры.Вставить("ДатаАктуальности", КонецДня(РД));
		УниверсальныйОтчет.ПостроительОтчета.Параметры.Вставить("ДатаАктуальности_Год", Год(РД));
		УниверсальныйОтчет.ПостроительОтчета.Параметры.Вставить("ДатаАктуальности_Месяц", Месяц(РД));
		УниверсальныйОтчет.ПостроительОтчета.Параметры.Вставить("ДатаАктуальности_День", День(РД));
	КонецЕсли;
	УниверсальныйОтчет.ПостроительОтчета.Параметры.Вставить("СостояниеУволен", Перечисления.СостоянияРаботникаОрганизации.НеРаботает);
	УниверсальныйОтчет.ПостроительОтчета.Параметры.Вставить("СостояниеРаботает", Перечисления.СостоянияРаботникаОрганизации.Работает);
	
	УниверсальныйОтчет.СформироватьОтчет(ТабличныйДокумент);

КонецПроцедуры // СформироватьОтчет()

////////////////////////////////////////////////////////////////////////////////
// ПРОЦЕДУРЫ И ФУНКЦИИ ОБЩЕГО НАЗНАЧЕНИЯ

// Процедура обработки расшифровки
//
Процедура ОбработкаРасшифровки(Расшифровка, Объект) Экспорт
	
	// Дополнительные параметры в расшифровывающий отчет можно перередать
	// посредством инициализации переменной "ДополнительныеПараметры".
	
	ДополнительныеПараметры = Неопределено;
	УниверсальныйОтчет.ОбработкаРасшифровкиУниверсальногоОтчета(Расшифровка, Объект, ДополнительныеПараметры);
	
КонецПроцедуры // ОбработкаРасшифровки()

// Формирует структуру для сохранения настроек отчета
//
Процедура СформироватьСтруктуруДляСохраненияНастроек(СтруктураСНастройками) Экспорт
	
	УниверсальныйОтчет.СформироватьСтруктуруДляСохраненияНастроек(СтруктураСНастройками);
	
КонецПроцедуры // СформироватьСтруктуруДляСохраненияНастроек()

// Заполняет настройки отчета из структуры сохраненных настроек
//
Функция ВосстановитьНастройкиИзСтруктуры(СтруктураСНастройками) Экспорт
	
	Возврат УниверсальныйОтчет.ВосстановитьНастройкиИзСтруктуры(СтруктураСНастройками, ЭтотОбъект);
	
КонецФункции // ВосстановитьНастройкиИзСтруктуры()

// Содержит значение используемого режима ввода периода.
// Тип: Число.
// Возможные значения: // (-1) - не выбирать период, 0 - произвольный период, 1 - на дату, 2 - неделя, 3 - декада, 4 - месяц, 5 - квартал, 6 - полугодие, 7 - год
// Значение по умолчанию: 0
// Пример:
// УниверсальныйОтчет.мРежимВводаПериода = 1;
УниверсальныйОтчет.мРежимВводаПериода = 1;

#КонецЕсли
