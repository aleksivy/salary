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
мТаблицаСоставПоказателей.Колонки.Добавить("ИмяПоляТаблДокумента",    ОписаниеТиповСтрока15);
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

НоваяФорма = мТаблицаФормОтчета.Добавить();
НоваяФорма.ФормаОтчета        = "ФормаОтчета2004Кв1";
НоваяФорма.ОписаниеОтчета     = НСтр("ru='Налоговый расчет сумм дохода и удержанного с них сумм налога по типовой форме 1ДФ, утвержденной Приказом ГНАУ от 29.09.2003  N 451';uk='Податковий розрахунок сум доходу й утриманих з них сум податку за типовою формою 1ДФ, затвердженої Наказом ДПАУ від 29.09.2003  N 451'");
НоваяФорма.ДатаНачалоДействия = '20030929';
НоваяФорма.ДатаКонецДействия  = '20101231';

НоваяФорма = мТаблицаФормОтчета.Добавить();
НоваяФорма.ФормаОтчета        = "ФормаОтчета2011Кв1";
НоваяФорма.ОписаниеОтчета     = НСтр("ru='Налоговый расчет сумм дохода и удержанного с них сумм налога по типовой форме 1ДФ, утвержденной Приказом ГНАУ от 24.12.2010  N 1020';uk='Податковий розрахунок сум доходу й утриманих з них сум податку за типовою формою 1ДФ, затвердженої Наказом ДПАУ від 24.12.2010  N 1020'");
НоваяФорма.ДатаНачалоДействия = '20110101';
НоваяФорма.ДатаКонецДействия  = '20131231';

НоваяФорма = мТаблицаФормОтчета.Добавить();
НоваяФорма.ФормаОтчета        = "ФормаОтчета2014Кв1";
НоваяФорма.ОписаниеОтчета     = НСтр("ru = 'Налоговый расчет сумм дохода и удержанного с них сумм налога по типовой форме 1ДФ, утвержденной Приказом Миндоходов и сборов  от 21.01.2014  N 49'; uk = 'Податковий розрахунок сум доходу й утриманих з них сум податку за типовою формою 1ДФ, затвердженої Наказом Міндоходів та зборів від 21.01.2014  N 49'");
НоваяФорма.ДатаНачалоДействия = '20140101';
НоваяФорма.ДатаКонецДействия  = '20141231';

НоваяФорма = мТаблицаФормОтчета.Добавить();
НоваяФорма.ФормаОтчета        = "ФормаОтчета2015Кв1";
НоваяФорма.ОписаниеОтчета     = НСтр("ru = 'Утвержден Приказом Минфина от 13.01.2015 N 4'; uk = 'Затверджено Наказом Мінфіна від 13.01.2015  N 4'");
НоваяФорма.ДатаНачалоДействия = '20150101';
НоваяФорма.ДатаКонецДействия  = Неопределено;
