﻿
Процедура ПриОткрытии()
	
	Если ПроведениеРасчетов.ИспользуетсяЕСВ() Тогда
		СправочникСписок.Отбор.Актуальность.Значение = Истина;
		СправочникСписок.Отбор.Актуальность.ВидСравнения = ВидСравнения.Равно;
		СправочникСписок.Отбор.Актуальность.Использование = Истина;
	КонецЕсли;
	
КонецПроцедуры
