
// Процедура вызывается при выборе пункта подменю "Движения документа по регистрам" меню "Перейти".
// командной панели формы. Процедура отрабатывает печать движений документа по регистрам.
//
Процедура ОсновныеДействияФормыНастройка(Кнопка)

	Если ЭлементыФормы.ДокументСписок.ТекущиеДанные = Неопределено тогда

		Возврат

	КонецЕсли;

	Серна.РучнаяКорректировкаОсновнаяФорма(Ложь, ЭлементыФормы.ДокументСписок.ТекущиеДанные.Ссылка,
													  ЭлементыФормы.ДокументСписок.ТекущиеДанные.Ссылка.ПолучитьОбъект());
													  
КонецПроцедуры // ОсновныеДействияФормыНастройка()
