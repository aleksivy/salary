// Заполнить начальными значениями
//
// Параметры
//  Нет
//
Процедура ЗаполнитьОбъектВПустойИБ() Экспорт

	Макет     = ПолучитьМакет("НачальныеЗначения");
	Область   = Макет.ПолучитьОбласть("НачальныеЗначения");
	ВысотаТаб = Область.ВысотаТаблицы;
    ЗаполняемыйСправочник = Справочники.ВидыПоощренийВзысканий;
		
	Для К = 1 По ВысотаТаб Цикл
        СтрокаКод = Область.Область(К, 1).Текст; 
		СтрокаНаименование = Область.Область(К, 2).Текст; 
        НайденнаяСсылка = ЗаполняемыйСправочник.НайтиПоКоду(СтрокаКод);
		Если НайденнаяСсылка = ЗаполняемыйСправочник.ПустаяСсылка() Тогда
			НоваяЗапись = ЗаполняемыйСправочник.СоздатьЭлемент();
			НоваяЗапись.Код = СтрокаКод;
			НоваяЗапись.Наименование = СтрокаНаименование;
			НоваяЗапись.Записать();
		КонецЕсли;	
    КонецЦикла;	

КонецПроцедуры // ЗаполнитьОбъектВПустойИБ()
