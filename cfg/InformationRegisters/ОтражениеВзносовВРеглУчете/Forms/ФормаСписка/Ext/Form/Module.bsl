﻿
Процедура РегистрСведенийСписокПодразделениеОрганизацииПриИзменении(Элемент)
	ЭлементыФормы.РегистрСведенийСписок.ТекущиеДанные.Организация = ЭлементыФормы.РегистрСведенийСписок.ТекущиеДанные.ПодразделениеОрганизации.Владелец
КонецПроцедуры

Процедура РегистрСведенийСписокОрганизацияПриИзменении(Элемент)
	ТекущиеДанные = ЭлементыФормы.РегистрСведенийСписок.ТекущиеДанные;
	Если ТекущиеДанные.ПодразделениеОрганизации.Владелец <> ТекущиеДанные.Организация Тогда
		 ТекущиеДанные.ПодразделениеОрганизации = Справочники.ПодразделенияОрганизаций.ПустаяСсылка();
	КонецЕсли	 
		
КонецПроцедуры
