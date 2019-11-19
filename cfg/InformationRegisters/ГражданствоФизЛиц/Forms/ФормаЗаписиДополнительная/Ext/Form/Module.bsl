﻿////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ ФОРМЫ

Процедура ПриОткрытии()
	
	ФизЛицоПриОткрытии                         = ФизЛицо;
	ПериодПриОткрытии   					   = Период;
	НеИмеетПравоНаПенсиюПриОткрытии		       = НеИмеетПравоНаПенсию;
	НеЯвляетсяНалоговымРезидентомПриОткрытии   = НеЯвляетсяНалоговымРезидентом;
	СтранаПриОткрытии 						   = Страна;
	        
	Заголовок = Заголовок + " " + ФизЛицо.Наименование;
	
	Прочитать();
	
	// У записи обязательно должны быть заполнены реквизиты ФизЛицо и Период
	Если ФизЛицо.Пустая() Тогда
	    ФизЛицо = ФизЛицоПриОткрытии;
		Период  = ПериодПриОткрытии;
	КонецЕсли;
	
КонецПроцедуры

Процедура ПриЗаписи(Отказ)
	
	// Если поменяли дату, то тогда новая  запись
	Если ПериодПриОткрытии <> Период Тогда
		
		// Если что-то поменяли тогда запишем 
		Если НеИмеетПравоНаПенсиюПриОткрытии <> НеИмеетПравоНаПенсию ИЛИ
			НеЯвляетсяНалоговымРезидентомПриОткрытии <> НеЯвляетсяНалоговымРезидентом ИЛИ
			СтранаПриОткрытии <> Страна Тогда
		
			МенеджерЗаписи = РегистрыСведений.ГражданствоФизЛиц.СоздатьМенеджерЗаписи();
			МенеджерЗаписи.Период   = ПериодПриОткрытии;
			МенеджерЗаписи.ФизЛицо  = ФизЛицо;
			МенеджерЗаписи.НеИмеетПравоНаПенсию  		   = НеИмеетПравоНаПенсиюПриОткрытии;
			МенеджерЗаписи.НеЯвляетсяНалоговымРезидентом   = НеЯвляетсяНалоговымРезидентомПриОткрытии;
			МенеджерЗаписи.Страна						   = СтранаПриОткрытии;
			
			МенеджерЗаписи.Записать();
			
		КонецЕсли; 
	
	КонецЕсли;
	
КонецПроцедуры

Процедура ПослеЗаписи()
	Оповестить("ОбновитьФорму", Новый Структура("ИмяЭлемента","Гражданство"), ФизЛицо);
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ ЭЛЕМЕНТОВ ФОРМЫ

Процедура КнопкаИсторияНажатие(Элемент)
	
	ФормаРегистра = РегистрыСведений.ГражданствоФизЛиц.ПолучитьФормуСписка();
	ФормаРегистра.РегистрСведенийСписок.Отбор.ФизЛицо.Значение = ФизЛицо;
	ФормаРегистра.РегистрСведенийСписок.Отбор.ФизЛицо.ВидСравнения = ВидСравнения.Равно;
	ФормаРегистра.РегистрСведенийСписок.Отбор.ФизЛицо.Использование = Истина;
	ФормаРегистра.ЭлементыФормы.РегистрСведенийСписок.НачальноеОтображениеСписка = НачальноеОтображениеСписка.Конец;
	
	ФормаРегистра.Открыть();
	
КонецПроцедуры
