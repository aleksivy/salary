////////////////////////////////////////////////////////////////////////////////
// ПРОЦЕДУРЫ - ДЕЙСТВИЯ КОМАНДНЫХ ПАНЕЛЕЙ ФОРМЫ

Процедура КоманднаяПанельДействиеПечать(Кнопка)
	
    Если ЭлементыФормы.СправочникСписок.ТекущаяСтрока <> Неопределено Тогда
        Если Не ЭлементыФормы.СправочникСписок.ТекущаяСтрока.ЭтоГруппа Тогда
			ЭлементыФормы.СправочникСписок.ТекущаяСтрока.ПолучитьФорму(,,).Печать();
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// ПРОЦЕДУРЫ - ОБРАБОТЧИКИ СОБЫТИЙ ТАБЛИЧНОГО ПОЛЯ

Процедура СписокПриАктивизацииСтроки(Элемент)
	
	ЭлементыФормы.СправочникДерево.ТекущаяСтрока = ЭлементыФормы.СправочникСписок.ТекущийРодитель;
		
КонецПроцедуры


