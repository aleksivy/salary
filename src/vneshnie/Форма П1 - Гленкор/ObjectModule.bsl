﻿
// Печать
//
Функция Печать() Экспорт
	
	// Для отладки
	лТест = Серна.ЕстьРеквизитДокумента("Организация", СсылкаНаОбъект.Метаданные());
	
	Объект = СсылкаНаОбъект;
	Организация = СсылкаНаОбъект.Организация;
	Дата = СсылкаНаОбъект.Дата;
	
	ТабДокумент = Новый ТабличныйДокумент;
	ТабДокумент.ИмяПараметровПечати = "ПАРАМЕТРЫ_ПЕЧАТИ_ПриемНаРаботуВОрганизацию_П1_Гленкор";
	
	// получаем данные для печати
	ВыборкаРаботники = СформироватьЗапросДляПечати().Выбрать(ОбходРезультатаЗапроса.ПоГруппировкам);
    СведенияОбОрганизации =УправлениеКонтактнойИнформацией.СведенияОЮрФизЛице(Организация, Дата);
	
	// запоминаем области макета
	Макет = ПолучитьМакет("П1_от_05_12_2008");
	Область = Макет.ПолучитьОбласть("Форма"); 
	
	РеглВалюта = Константы.ВалютаРегламентированногоУчета.Получить();
	
	// Начинаем формировать выходной документ
	Пока ВыборкаРаботники.Следующий() Цикл

		ВложеннаяВыборка = ВыборкаРаботники.Выбрать(); 
		ВложеннаяВыборка.Следующий();
		
		// Каждый приказ на отдельной странице.
		Если ТабДокумент.ВысотаТаблицы > 0 Тогда
			ТабДокумент.ВывестиГоризонтальныйРазделительСтраниц();
		КонецЕсли;
		
		// Данные по работнику.
		Область.Параметры.Заполнить(ВложеннаяВыборка);
		Область.Параметры.ФИОРуководителя = "Балан В.С.";
		Попытка
			Область.Параметры.НомерДок = Число( Прав(ВложеннаяВыборка.НомерДок, 9) );
		Исключение
		    Область.Параметры.НомерДок = Прав(ВложеннаяВыборка.НомерДок, 9);
		КонецПопытки;
		Попытка
			Область.Параметры.ТабельныйНомер = Число( ВложеннаяВыборка.ТабельныйНомер );
		Исключение
		    Область.Параметры.ТабельныйНомер = ВложеннаяВыборка.ТабельныйНомер;
		КонецПопытки;
		
		Оклад = ВложеннаяВыборка.Оклад;
		Если  ВложеннаяВыборка.Валюта <> РеглВалюта Тогда
			Структура = РегистрыСведений.КурсыВалютДляРасчетовСПерсоналом.ПолучитьПоследнее(Дата, Новый Структура("Валюта", ВложеннаяВыборка.Валюта));
			Оклад = МодульВалютногоУчета.ПересчитатьИзВалютыВВалюту(Оклад,ВложеннаяВыборка.Валюта, РеглВалюта,
							Структура.Курс, 1, Структура.Кратность, 1);
		КонецЕсли;	
		
		Гривны = Цел(Оклад);
		Копейки = Цел((Оклад-Гривны)*100);
		
		Гривны = ОбщегоНазначения.РазложитьЧислоВСтроку(Гривны,6);
		Копейки = ОбщегоНазначения.РазложитьЧислоВСтроку(Копейки,2,Истина);
		
		//Для Сч = 1 По 6 Цикл
		//	Область.Параметры["Гривны" + Сч] = Сред(Строка(Гривны), Сч, 1);
		//КонецЦикла;
		//Для Сч = 1 По 2 Цикл
		//	Область.Параметры["Копейки" + Сч] = Сред(Строка(Копейки), Сч, 1);
		//КонецЦикла;
		
		ТабДокумент.Вывести(Область);
	КонецЦикла;

	Возврат ТабДокумент;
	
КонецФункции

// СформироватьЗапросДляПечати
//
Функция СформироватьЗапросДляПечати()

	Ссылка = СсылкаНаОбъект;
	Организация = СсылкаНаОбъект.Организация;
	Дата = СсылкаНаОбъект.Дата;
	
	Запрос = Новый Запрос;

	// Установим параметры запроса
	Запрос.УстановитьПараметр("ДокументСсылка", Ссылка);
	Запрос.УстановитьПараметр("Руководитель",	Перечисления.ОтветственныеЛицаОрганизаций.Руководитель);
    Запрос.УстановитьПараметр("ДатаДокумента",	 Дата);
    Запрос.УстановитьПараметр("РеглВалюта",	 Константы.ВалютаРегламентированногоУчета.Получить());
	Запрос.УстановитьПараметр("ОсновноеМестоРаботы", Перечисления.ВидыЗанятостиВОрганизации.ОсновноеМестоРаботы);
	Запрос.УстановитьПараметр("Дата", СсылкаНаОбъект.Дата);
	Запрос.Текст =
	"ВЫБРАТЬ РАЗРЕШЕННЫЕ
	|	ЕСТЬNULL(ФИОФизЛицСрезПоследних.Фамилия + ВЫБОР
	|			КОГДА ПОДСТРОКА(ФИОФизЛицСрезПоследних.Имя, 1, 1) <> """"
	|				ТОГДА "" "" + ПОДСТРОКА(ФИОФизЛицСрезПоследних.Имя, 1, 1) + "".""
	|			ИНАЧЕ """"
	|		КОНЕЦ + ВЫБОР
	|			КОГДА ПОДСТРОКА(ФИОФизЛицСрезПоследних.Отчество, 1, 1) <> """"
	|				ТОГДА "" "" + ПОДСТРОКА(ФИОФизЛицСрезПоследних.Отчество, 1, 1) + "".""
	|			ИНАЧЕ """"
	|		КОНЕЦ, ОтветственныеЛицаОрганизацийСрезПоследних.ФизическоеЛицо.Наименование) КАК ФИОРуководителя
	|ПОМЕСТИТЬ Руководитель
	|ИЗ
	|	РегистрСведений.ОтветственныеЛицаОрганизаций.СрезПоследних(&Дата, ОтветственноеЛицо = ЗНАЧЕНИЕ(Перечисление.ОтветственныеЛицаОрганизаций.Руководитель)) КАК ОтветственныеЛицаОрганизацийСрезПоследних
	|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.ФИОФизЛиц.СрезПоследних(&Дата, ) КАК ФИОФизЛицСрезПоследних
	|		ПО ОтветственныеЛицаОрганизацийСрезПоследних.ФизическоеЛицо = ФИОФизЛицСрезПоследних.ФизЛицо
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ РАЗРЕШЕННЫЕ
	|	Рег.Сотрудник КАК Сотрудник,
	|	Рег.Показатель1 КАК Оклад,
	|	Рег.Валюта1 КАК Валюта
	|ПОМЕСТИТЬ Оклады
	|ИЗ
	|	РегистрСведений.ПлановыеНачисленияРаботниковОрганизаций.СрезПоследних(
	|			КОНЕЦПЕРИОДА(&Дата, МЕСЯЦ),
	|			Активность
	|				И ВидРасчета = ЗНАЧЕНИЕ(ПланВидовРасчета.ОсновныеНачисленияОрганизаций.ОкладПоДням)) КАК Рег
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ РАЗРЕШЕННЫЕ
	|	Рег.Объект КАК Сотрудник,
	|	ВЫБОР
	|		КОГДА Рег.Значение.Наименование = ""1. Повна матеріальна відповідальність""
	|			ТОГДА ИСТИНА
	|		ИНАЧЕ ЛОЖЬ
	|	КОНЕЦ КАК МатОтветственность
	|ПОМЕСТИТЬ МатОтветств
	|ИЗ
	|	РегистрСведений.ЗначенияСвойствОбъектов КАК Рег
	|ГДЕ
	|	Рег.Свойство.Наименование = ""Материальная ответственность""
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ РАЗРЕШЕННЫЕ
	|	ДокТЧ.Ссылка.Дата КАК ДатаДок,
	|	ДокТЧ.Ссылка.Номер КАК НомерДок,
	|	ДокТЧ.НомерСтроки КАК НомерСтроки,
	|	ДокТЧ.Сотрудник КАК Работник,
	|	ДокТЧ.ДатаПриема КАК ДатаПриема,
	|	ДокТЧ.Сотрудник.Код КАК ТабельныйНомер,
	|	ДокТЧ.ПодразделениеОрганизации КАК Подразделение,
	|	ДокТЧ.Должность КАК Должность,
	|	ВЫБОР
	|		КОГДА ДокТЧ.ДатаУвольнения = ДАТАВРЕМЯ(1, 1, 1)
	|			ТОГДА ИСТИНА
	|		ИНАЧЕ ЛОЖЬ
	|	КОНЕЦ КАК ФлагКонтракт,
	|	ДокТЧ.ДатаУвольнения КАК ДатаОкончания,
	|	ВЫБОР
	|		КОГДА ДокТЧ.ИспытательныйСрок > 0
	|			ТОГДА ИСТИНА
	|		ИНАЧЕ ЛОЖЬ
	|	КОНЕЦ КАК ФлагИспытательныйСрок,
	|	ВЫБОР
	|		КОГДА ДокТЧ.ИспытательныйСрок > 0
	|			ТОГДА ДокТЧ.ДатаПриема
	|		ИНАЧЕ """"
	|	КОНЕЦ КАК ИспытательныйСрокНачало,
	|	ВЫБОР
	|		КОГДА ДокТЧ.ИспытательныйСрок > 0
	|			ТОГДА ДОБАВИТЬКДАТЕ(ДОБАВИТЬКДАТЕ(ДокТЧ.ДатаПриема, МЕСЯЦ, ДокТЧ.ИспытательныйСрок), ДЕНЬ, -1)
	|		ИНАЧЕ """"
	|	КОНЕЦ КАК ИспытательныйСрокКонец,
	|	ВЫБОР
	|		КОГДА ДокТЧ.Сотрудник.ВидЗанятости = ЗНАЧЕНИЕ(Перечисление.ВидыЗанятостиВОрганизации.ОсновноеМестоРаботы)
	|			ТОГДА ИСТИНА
	|		ИНАЧЕ ЛОЖЬ
	|	КОНЕЦ КАК ФлагОсновная,
	|	ВЫБОР
	|		КОГДА ДокТЧ.ГрафикРаботы.ДлительностьРабочейНедели = 40
	|			ТОГДА ИСТИНА
	|		ИНАЧЕ ЛОЖЬ
	|	КОНЕЦ КАК ФлагДлительность,
	|	ВЫБОР
	|		КОГДА ДокТЧ.ЗанимаемыхСтавок < 1
	|			ТОГДА ИСТИНА
	|		ИНАЧЕ ЛОЖЬ
	|	КОНЕЦ КАК ФлагНеполнаяСтавка,
	|	ВЫБОР
	|		КОГДА ДокТЧ.ЗанимаемыхСтавок = 0.25
	|			ТОГДА ИСТИНА
	|		ИНАЧЕ ЛОЖЬ
	|	КОНЕЦ КАК ФлагСтавка025,
	|	ВЫБОР
	|		КОГДА ДокТЧ.ЗанимаемыхСтавок = 0.5
	|			ТОГДА ИСТИНА
	|		ИНАЧЕ ЛОЖЬ
	|	КОНЕЦ КАК ФлагСтавка050,
	|	ВЫБОР
	|		КОГДА ДокТЧ.ЗанимаемыхСтавок = 0.75
	|			ТОГДА ИСТИНА
	|		ИНАЧЕ ЛОЖЬ
	|	КОНЕЦ КАК ФлагСтавка075,
	|	ВЫБОР
	|		КОГДА ДокТЧ.ГрафикРаботы.ДлительностьРабочейНедели = 40
	|			ТОГДА ЛОЖЬ
	|		ИНАЧЕ ИСТИНА
	|	КОНЕЦ КАК ФлагЧасовВНеделю,
	|	ЛОЖЬ КАК ФлагЧасовВДень,
	|	ВЫБОР
	|		КОГДА ДокТЧ.ГрафикРаботы.ДлительностьРабочейНедели = 40
	|			ТОГДА 0
	|		ИНАЧЕ ДокТЧ.ГрафикРаботы.ДлительностьРабочейНедели
	|	КОНЕЦ КАК ЧасовВНеделю,
	|	0 КАК ЧасовВДень,
	|	ВЫБОР
	|		КОГДА МатОтветств.МатОтветственность ЕСТЬ NULL 
	|			ТОГДА ЛОЖЬ
	|		ИНАЧЕ ИСТИНА
	|	КОНЕЦ КАК ФлагМатериальнаяОтветственность,
	|	ВЫБОР
	|		КОГДА МатОтветств.МатОтветственность ЕСТЬ NULL 
	|			ТОГДА """"
	|		КОГДА МатОтветств.МатОтветственность
	|			ТОГДА ""Повна""
	|		ИНАЧЕ ""Неповна""
	|	КОНЕЦ КАК МатериальнаяОтветственность,
	|	ЕСТЬNULL(Оклады.Оклад, 0) КАК Оклад,
	|	ЕСТЬNULL(Оклады.Валюта, ЗНАЧЕНИЕ(Справочник.Валюты.Гривна)) КАК Валюта,
	|	Руководитель.ФИОРуководителя
	|ИЗ
	|	Документ.ПриемНаРаботуВОрганизацию.РаботникиОрганизации КАК ДокТЧ
	|		ЛЕВОЕ СОЕДИНЕНИЕ МатОтветств КАК МатОтветств
	|		ПО ДокТЧ.Сотрудник = МатОтветств.Сотрудник
	|		ЛЕВОЕ СОЕДИНЕНИЕ Оклады КАК Оклады
	|		ПО ДокТЧ.Сотрудник = Оклады.Сотрудник,
	|	Руководитель КАК Руководитель
	|ГДЕ
	|	ДокТЧ.Ссылка = &ДокументСсылка
	|
	|УПОРЯДОЧИТЬ ПО
	|	НомерСтроки
	|ИТОГИ ПО
	|	НомерСтроки";

	Возврат Запрос.Выполнить();

КонецФункции // СформироватьЗапросДляПечати()

// СведенияОВнешнейОбработке
//
Функция СведенияОВнешнейОбработке() Экспорт
	ПараметрыРегистрации = Новый Структура;
	МассивНазначений = Новый Массив;
	МассивНазначений.Добавить("Документ.ПриемНаРаботуВОрганизацию");
	ПараметрыРегистрации.Вставить("Вид", "ПечатнаяФорма");
	//возможны варианты - ЗаполнениеОбъекта, ДополнительныйОтчет, СозданиеСвязанныхОбъектов,
	ПараметрыРегистрации.Вставить("Назначение", МассивНазначений);
	ПараметрыРегистрации.Вставить("Наименование", "Печатная форма приказа о приеме на работу (форма П1 - Гленкор)"); //имя под kt обработка зарегистрирована будет в справочнике внешних обработок
	ПараметрыРегистрации.Вставить("Версия", "1.0");
	ПараметрыРегистрации.Вставить("БезопасныйРежим", ЛОЖЬ);
	ПараметрыРегистрации.Вставить("Информация", "Печатная форма приказа о приеме на работу (форма П1 - Гленкор)");
	//команды
	ТаблицаКоманд = Новый ТаблицаЗначений;
	ТаблицаКоманд.Колонки.Добавить("Представление"); //как будет выглядеть описание печ.формы для пользователя
	ТаблицаКоманд.Колонки.Добавить("Идентификатор"); //имя нашего макета
	ТаблицаКоманд.Колонки.Добавить("Использование"); //ВызовСерверногоМетода
	ТаблицаКоманд.Колонки.Добавить("ПоказыватьОповещение"); //Истина
	ТаблицаКоманд.Колонки.Добавить("Модификатор"); //ПечатьМХL
	НоваяКоманда = ТаблицаКоманд.Добавить();
	НоваяКоманда.Представление = "Печатная форма приказа о приеме на работу (форма П1 - Гленкор)";
	НоваяКоманда.Идентификатор = "ПечатьП1Гленкор"; //Внешняя печатная форма
	НоваяКоманда.Использование = "ВызовКлиентскогоМетода"; //здесь можно прописать использование как серверного так и клиентского, отличие в том, что серверный метод будет обращаться к экспортной процедуре из модуля объекта, клиентский - к экспортной процедуре из модуля формы объекта
	НоваяКоманда.ПоказыватьОповещение = Истина;
	НоваяКоманда.Модификатор = "ПечатьMXL";
	ПараметрыРегистрации.Вставить("Команды", ТаблицаКоманд);
	Возврат ПараметрыРегистрации;
КонецФункции
