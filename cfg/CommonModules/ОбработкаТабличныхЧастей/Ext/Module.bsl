////////////////////////////////////////////////////////////////////////////////
// ПРОЦЕДУРЫ И ФУНКЦИИ ОБРАБОТКИ ТАБЛИЧНОЙ ЧАСТИ ТОРГОВЫХ ДОКУМЕНТОВ

// Устанавливает запрет на изменение видимости заданных колонок в заданной коллекции колонок 
// табличного поля
//
// Параметры:
//  Колонки          - коллекция колонок табличного поля,
//  СтруктураКолонок - структура, содержащая имена колонок, видимость которых отключить нельзя
//
Процедура УстановитьИзменятьВидимостьКолонокТабЧасти(Колонки, СтруктураКолонок) Экспорт

// устанавливаем стандартные запреты на изменение видимости колонок
Для каждого КолонкаТаблицы из Колонки Цикл
	КолонкаТаблицы.ИзменятьВидимость = НЕ СтруктураКолонок.Свойство(КолонкаТаблицы.Имя);
КонецЦикла;

КонецПроцедуры // УстановитьИзменятьВидимостьКолонокТабЧасти()

// Изменяет видимость колонки табличного поля (напрмер, табличной части документа).
//
// Параметры:
//  Колонка   - колонка табличного поля, 
//  Видимость - булево, устанавливаемый флаг видимости колонки.
//
Процедура УстановитьВидимостьКолонкиТабЧасти(Колонка, Видимость) Экспорт

	Колонка.Видимость = Видимость;

КонецПроцедуры // УстановитьВидимостьКолонкиТабЧасти()
