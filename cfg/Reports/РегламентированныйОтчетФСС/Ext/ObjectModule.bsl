////////////////////////////////////////////////////////////////////////////////
// ПЕРЕМЕННЫЕ МОДУЛЯ

// Хранит таблицу значений - состав показателей отчета.
Перем мТаблицаСоставПоказателей Экспорт;

// Хранит структуру - состав показателей отчета,
// значение которых автоматически заполняется по учетным данным.
Перем мСтруктураВариантыЗаполнения Экспорт;

// Хранит структуру многостраничных разделов.
Перем мСтруктураМногостраничныхРазделов Экспорт;

// Хранит дерево значений - структуру листов отчета.
Перем мДеревоСтраницОтчета Экспорт;

// Хранит признак выбора печатных листов.
Перем мЕстьВыбранные Экспорт;

// Хранит имя выбранной формы отчета
Перем мВыбраннаяФорма Экспорт;

// Хранит признак скопированной формы.
Перем мСкопированаФорма Экспорт;

// Хранит ссылку на документ, хранящий данные отчета
Перем мСохраненныйДок Экспорт;

// Следующие переменные хранят границы
// периода построения отчета
Перем мДатаНачалаПериодаОтчета Экспорт;
Перем мДатаКонцаПериодаОтчета  Экспорт;

Перем мТаблицаФормОтчета Экспорт;
Перем мПолноеИмяФайлаВнешнейОбработки Экспорт;
Перем мЗаписьЗапрещена                Экспорт;


////////////////////////////////////////////////////////////////////////////////
// ПРОЦЕДУРЫ И ФУНКЦИИ ОБЩЕГО НАЗНАЧЕНИЯ

// Выполняет начальные настройки параметров отчета.
// По данным макета "СоствПоказателей" формирует:
//   - состав показателей отчета;
//   - варианты заполнения показателей отчета;
//   - дерево выводимых на печать листов отчета.
//
Процедура ЗаполнитьНачальныеНастройки(СоставПоказателей = "СоставПоказателей") Экспорт

	МакетСоставаПоказателей = ЭтотОбъект.ПолучитьМакет(СоставПоказателей);

	ОписаниеТиповСтрока15  = ОбщегоНазначения.ПолучитьОписаниеТиповСтроки(15);

	ОписаниеТиповСтрока100 = ОбщегоНазначения.ПолучитьОписаниеТиповСтроки(100);

	ОписаниеТиповЧисло1    = ОбщегоНазначения.ПолучитьОписаниеТиповЧисла(1);

	ОписаниеТиповЧисло15   = ОбщегоНазначения.ПолучитьОписаниеТиповЧисла(15,2);

	Для Инд = 0 По МакетСоставаПоказателей.Области.Количество() - 1 Цикл

		ТекОбласть    = МакетСоставаПоказателей.Области[Инд];
		ИмяСтраницы   = ТекОбласть.Имя;

		// Таблица значений содержит информацию о вариантах заполнения показателя отчета.
		// В колонках таблицы значений отображается следуящая информация:
		//   - имя ячейки (код показателя);
		//   - вариант заполнения ячейки;
		//   - вычисленное по данным ИБ значение ячейки;
		//   - величина автокорректировки значения ячейки;
		//   - примечание к ячейке.
		//
		ТаблицаВариантыЗаполнения = Новый ТаблицаЗначений;
		ТаблицаВариантыЗаполнения.Колонки.Добавить( "КодПоказателя",     ОписаниеТиповСтрока15  );
		ТаблицаВариантыЗаполнения.Колонки.Добавить( "ВариантЗаполнения", ОписаниеТиповЧисло1    );
		ТаблицаВариантыЗаполнения.Колонки.Добавить( "ЗначениеАвто",      ОписаниеТиповЧисло15   );
		ТаблицаВариантыЗаполнения.Колонки.Добавить( "Дельта",            ОписаниеТиповЧисло15   );
		ТаблицаВариантыЗаполнения.Колонки.Добавить( "Комментарий",       ОписаниеТиповСтрока100 );

		Для Ном = ТекОбласть.Верх По ТекОбласть.Низ Цикл
			// перебираем строки макета

			// Код показателя (по составу показателей) определяется по первой колонке макета
			КодПоказателя = СокрП(МакетСоставаПоказателей.Область(Ном, 1).Текст);
			ИмяПоказателя = КодПоказателя;

			Если КодПоказателя = "===" Тогда         // признак конечной строки
				Прервать;
			КонецЕсли;

			Если Лев(КодПоказателя, 2) = "//" Тогда  // пропускаем комментарии
				Продолжить;
			КонецЕсли;

			// код показателя по форме отчете (имя ячейки в полях табличного документа формы)
			КодПоказателяПоФорме = СокрЛП(МакетСоставаПоказателей.Область(Ном, 2).Текст);
			// признак многострочности определяется по третьей колонке макета
			ПризнМногострочность = СокрЛП(МакетСоставаПоказателей.Область(Ном, 3).Текст);
			// по четвертой колонке определяется тип данных реквизита
			ТипДанныхРеквизита   = СокрЛП(МакетСоставаПоказателей.Область(Ном, 4).Текст);
			// по колонке 5 определяется исходное количество строк многострочного раздела
			стрКолСтрокИсходный  = СокрЛП(МакетСоставаПоказателей.Область(Ном, 5).Текст);
			// вариант заполнения ячейки определяется по колонке 6 макета
			стрВариантЗаполнения = СокрЛП(МакетСоставаПоказателей.Область(Ном, 6).Текст);

			чКолСтрокИсходный    = ? (ПустаяСтрока(стрКолСтрокИсходный),  0, Число(стрКолСтрокИсходный));
			чВариантЗаполнения   = ? (ПустаяСтрока(стрВариантЗаполнения), 0, Число(стрВариантЗаполнения));

			// формируем таблицу значений, содержащей состав показателей отчета
			НоваяСтрока = мТаблицаСоставПоказателей.Добавить();
			НоваяСтрока.ИмяПоляТаблДокумента   = ИмяСтраницы;
			НоваяСтрока.КодПоказателяПоСоставу = КодПоказателя;
			НоваяСтрока.КодПоказателяПоФорме   = КодПоказателяПоФорме;
			НоваяСтрока.ПризнМногострочности   = ПризнМногострочность;
			НоваяСтрока.ТипДанныхПоказателя    = ТипДанныхРеквизита;

			Если чВариантЗаполнения <> 0 Тогда
				// Если в колонке 6 задан варианет заполнения показателя, 
				// то его значение может определяться по данным ИБ.
				// Дополняем таблицу значений вариантов заполнения
				НоваяСтрока = ТаблицаВариантыЗаполнения.Добавить();
				НоваяСтрока.КодПоказателя      = ? (Не ПустаяСтрока(КодПоказателяПоФорме), КодПоказателяПоФорме, КодПоказателя);
				НоваяСтрока.ВариантЗаполнения  = чВариантЗаполнения;
			КонецЕсли;

		КонецЦикла;

		Если ТаблицаВариантыЗаполнения.Количество() > 0 Тогда
			// имеются автоматически заполняемые ячейки

			// Для обеспечения возможности назначения разных вариантов заполнения одного и того же показателя
			// на разных страницах, создаем массив, хранящий информацию о вариантах заполнения ячеек по каждой
			// странице многостраничного раздела.
			МассивВариантовЗаполненияСтраниц = Новый Массив;
			МассивВариантовЗаполненияСтраниц.Добавить(ТаблицаВариантыЗаполнения);

			// Создаем структуру, содержащей варианты заполнения показателей отчета.
			//
			// В качестве ключа используется имя страницы основной панели формы, содержащей
			//   табличный документ с автоматически заполняемыми показателями.
			// В качестве значения принимаем Массив из таблицы значений - вариантов заполнения
			//   показателей по каждой странице многостраничного раздела.
			//
			мСтруктураВариантыЗаполнения.Вставить(ИмяСтраницы, МассивВариантовЗаполненияСтраниц);
		Конецесли;

	КонецЦикла;

	//ФормироватьСтруктуруСтраницОтчета();

КонецПроцедуры // ЗаполнитьНачальныеНастройки()


////////////////////////////////////////////////////////////////////////////////
// ОПЕРАТОРЫ ОСНОВНОЙ ПРОГРАММЫ 

ОписаниеТиповСтрока15  = ОбщегоНазначения.ПолучитьОписаниеТиповСтроки(15);

ОписаниеТиповСтрока254 = ОбщегоНазначения.ПолучитьОписаниеТиповСтроки(254);

МассивБулево = Новый Массив;
МассивБулево.Добавить(Тип("Булево"));
ОписаниеТиповБулево    = Новый ОписаниеТипов(МассивБулево);

// Таблица значений хранит состав показателей отчета.
// В колонках таблицы хранятся следующие данные:
//    - имя поля табличного документа;
//    - код показатели по составу показателей;
//    - код показателя по форме (имя области табличного документа);
//    - признак многострочности;
//    - тип данных показателя.
//
мТаблицаСоставПоказателей         = Новый ТаблицаЗначений;
мТаблицаСоставПоказателей.Колонки.Добавить("ИмяПоляТаблДокумента",    ОписаниеТиповСтрока254);
мТаблицаСоставПоказателей.Колонки.Добавить("КодПоказателяПоСоставу",  ОписаниеТиповСтрока15);
мТаблицаСоставПоказателей.Колонки.Добавить("КодПоказателяПоФорме",    ОписаниеТиповСтрока15);
мТаблицаСоставПоказателей.Колонки.Добавить("ПризнМногострочности",    ОписаниеТиповСтрока15);
мТаблицаСоставПоказателей.Колонки.Добавить("ТипДанныхПоказателя",     ОписаниеТиповСтрока15);

// Таблица значений хранит данные дополнительной страницы многостраничных разделов отчета.
// В колонках таблицы хранятся следующие данные:
//    - имя дополнительной страницы (отображается в списке дополнительных страниц);
//    - булево, признак текущей страницы (отображенной в поле табличного документа);
//    - структура, содержащая имена и значения редактируемых ячеек дополнительной страницы.
//
ТаблицаСтраницыРаздела            = Новый ТаблицаЗначений;
ТаблицаСтраницыРаздела.Колонки.Добавить("Представление",              ОписаниеТиповСтрока254, НСтр("ru='Наименование';uk='Найменування'"));
ТаблицаСтраницыРаздела.Колонки.Добавить("АктивнаяСтраница",           ОписаниеТиповБулево);
ТаблицаСтраницыРаздела.Колонки.Добавить("Данные");

мСтруктураВариантыЗаполнения      = Новый Структура;

ОписаниеТиповСтрока = ОбщегоНазначения.ПолучитьОписаниеТиповСтроки(254);

МассивТипов = Новый Массив;
МассивТипов.Добавить(Тип("Дата"));
ОписаниеТиповДата = Новый ОписаниеТипов(МассивТипов, , Новый КвалификаторыДаты(ЧастиДаты.Дата));

мТаблицаФормОтчета = Новый ТаблицаЗначений;
мТаблицаФормОтчета.Колонки.Добавить("ФормаОтчета",        ОписаниеТиповСтрока);
мТаблицаФормОтчета.Колонки.Добавить("ОписаниеОтчета",     ОписаниеТиповСтрока, НСтр("ru='Утверждена';uk='Затверджена'"),  20);
мТаблицаФормОтчета.Колонки.Добавить("ДатаНачалоДействия", ОписаниеТиповДата,   НСтр("ru='Действует с';uk='Діє з'"), 5);
мТаблицаФормОтчета.Колонки.Добавить("ДатаКонецДействия",  ОписаниеТиповДата,   НСтр("ru='         по';uk='         по'"), 5);

//Если (РегламентированнаяОтчетность.ИДКонфигурации() = "УПП") или (РегламентированнаяОтчетность.ИДКонфигурации() = "БП") Тогда
//	НоваяФорма = мТаблицаФормОтчета.Добавить();
//	НоваяФорма.ФормаОтчета        = "ФормаОтчета2005Кв1";
//	НоваяФорма.ОписаниеОтчета     = "Утверждена Постановлением Правления Фонда социального страхования по временной утрате
//	|трудоспособности от  04.03.2004  N 21 в редакции
//	|приказа Правления Фонда от 31.01.2005  N 7-ос";
//	НоваяФорма.ДатаНачалоДействия = '20050101';
//	НоваяФорма.ДатаКонецДействия  = КонецГода('20051231');//ОбщегоНазначения.ПустоеЗначениеТипа(Тип("Дата"));
//КонецЕсли;

НоваяФорма = мТаблицаФормОтчета.Добавить();
НоваяФорма.ФормаОтчета        = "ФормаОтчета2006Кв1";
НоваяФорма.ОписаниеОтчета     = НСтр("ru='Утверждена Постановлением Правления Фонда социального страхования по временной утрате"
"трудоспособности от  04.03.2004  N 21 в редакции"
"приказа Правления Фонда от 03.02.2006  N 22-ос';uk='Затверджена Постановою Правління Фонду соціального страхування по тимчасовій втраті"
"працездатності від  04.03.2004  N 21 у редакції"
"наказу Правління Фонду від 03.02.2006  N 22-ос'");
НоваяФорма.ДатаНачалоДействия = '20060101';
НоваяФорма.ДатаКонецДействия  = КонецГода('20061231');

НоваяФорма = мТаблицаФормОтчета.Добавить();
НоваяФорма.ФормаОтчета        = "ФормаОтчета2007Кв1";
НоваяФорма.ОписаниеОтчета     = НСтр("ru='Утверждена Постановлением Правления Фонда социального страхования по временной утрате"
"трудоспособности от  04.03.2004  N 21 в редакции"
"приказа Правления Фонда от 02.02.2007  N 22-ос';uk='Затверджена Постановою Правління Фонду соціального страхування по тимчасовій втраті"
"працездатності від  04.03.2004  N 21 у редакції"
"наказу Правління Фонду від 02.02.2007  N 22-ос'");
НоваяФорма.ДатаНачалоДействия = '20070101';
НоваяФорма.ДатаКонецДействия  = '20081231';

НоваяФорма = мТаблицаФормОтчета.Добавить();
НоваяФорма.ФормаОтчета        = "ФормаОтчета2009Кв1";
НоваяФорма.ОписаниеОтчета     = НСтр("ru='Утверждена Постановлением Правления Фонда социального страхования по временной утрате"
"трудоспособности от  04.03.2004  N 21 в редакции"
"приказа Правления Фонда от 19.01.2009  N 10-ос';uk='Затверджена Постановою Правління Фонду соціального страхування по тимчасовій втраті"
"працездатності від  04.03.2004  N 21 у редакції"
"наказу Правління Фонду від 19.01.2009  N 10-ос'");
НоваяФорма.ДатаНачалоДействия = '20090101';
НоваяФорма.ДатаКонецДействия  = '20101231';

НоваяФорма = мТаблицаФормОтчета.Добавить();
НоваяФорма.ФормаОтчета        = "ФормаОтчета2011Кв1";
НоваяФорма.ОписаниеОтчета     = НСтр("ru = 'Утверждена Постановлением Правления Фонда социального страхования по временной утрате трудоспособности от  18.01.2011  N 4'; uk = 'Затверджена Постановою Правління Фонду соціального страхування по тимчасовій втраті працездатності від  18.01.2011  N 4'");
НоваяФорма.ДатаНачалоДействия = '20110101';
НоваяФорма.ДатаКонецДействия  = '20111231';


НоваяФорма = мТаблицаФормОтчета.Добавить();
НоваяФорма.ФормаОтчета        = "ФормаОтчета2012Кв1";
НоваяФорма.ОписаниеОтчета     = НСтр("ru = 'Утверждена Постановлением Правления Фонда социального страхования по временной утрате трудоспособности от  16.11.2011  N 56'; uk = 'Затверджена Постановою Правління Фонду соціального страхування по тимчасовій втраті працездатності від  16.11.2011  N 56'");
НоваяФорма.ДатаНачалоДействия = '20120101';
