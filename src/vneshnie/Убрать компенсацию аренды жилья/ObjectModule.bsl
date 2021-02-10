﻿Процедура Инициализировать(ДокументОбъект, Имя, Расшифровка) Экспорт
	// Аренда авто
	ВидРасчетУбрать = ПланыВидовРасчета.ОсновныеНачисленияОрганизаций.НайтиПоКоду("00009");
	Если Не СокрЛП(ВидРасчетУбрать.Наименование) = "09. Компенсація за використання особистого транспорту" Тогда
		Сообщить("Не найден вид начислений '09. Компенсація за використання особистого транспорту'! Сообщите администратору!");
		Возврат;
	КонецЕсли;
	Массив = ДокументОбъект.Начисления.НайтиСтроки(Новый Структура("ВидРасчета",ВидРасчетУбрать));
	Для каждого СтрокаНачисления ИЗ Массив Цикл
		ДокументОбъект.Начисления.Удалить(СтрокаНачисления);
	КонецЦикла;
	// Аренда жилья
	ВидРасчетУбрать = ПланыВидовРасчета.ОсновныеНачисленияОрганизаций.НайтиПоКоду("00016");
	лТмп = Серна.ЕстьРеквизитДокумента("Организация", ДокументОбъект.Метаданные());
	Если Не СокрЛП(ВидРасчетУбрать.Наименование) = "16. Компенсація за аренду житла(оподатковується)" Тогда
		Сообщить("Не найден вид начислений '16. Компенсація за аренду житла(оподатковується)'! Сообщите администратору!");
		Возврат;
	КонецЕсли;
	Массив = ДокументОбъект.Начисления.НайтиСтроки(Новый Структура("ВидРасчета",ВидРасчетУбрать));
	Для каждого СтрокаНачисления ИЗ Массив Цикл
		ДокументОбъект.Начисления.Удалить(СтрокаНачисления);
	КонецЦикла;
КонецПроцедуры
