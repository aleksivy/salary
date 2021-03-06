//////////////////////////////////////////////////////////////////////////////// 
// ОБРАБОТЧИКИ СОБЫТИЙ ФОРМЫ
// 

Процедура ПриОткрытии()
	
	МакетДокумента = Обработки.ЛегальностьПолученияОбновлений.ПолучитьМакет("УсловияРаспостраненияОбновлений");
	ЭлементыФормы.ПолеHTMLДокумента.УстановитьТекст(МакетДокумента.ПолучитьТекст());
	ТекущийЭлемент = ЭлементыФормы.ПолеHTMLДокумента;
	
	Если ПоказыватьПредупреждениеОПерезапуске Тогда
		ЭлементыФормы.ПереключательНеПодтверждаю.Заголовок = 
			ЭлементыФормы.ПереключательНеПодтверждаю.Заголовок + 
			" " + НСтр("ru='(работа программы будет завершена)';uk='(робота програми буде завершена)'");
		
	КонецЕсли;
	УстановитьСостоянииЭлементов();	
	
КонецПроцедуры

//////////////////////////////////////////////////////////////////////////////// 
// ОБРАБОТЧИКИ СОБЫТИЙ ЭЛЕМЕНТОВ ФОРМЫ
// 

Процедура ОсновныеДействияФормыПродолжить(Кнопка)
	
	Если ПодтверждениеВыбора <> 0 Тогда
		Закрыть(ПодтверждениеВыбора = 1);
	КонецЕсли; 
	
КонецПроцедуры

Процедура ПереключательПодтверждаюПриИзменении(Элемент)
	
	УстановитьСостоянииЭлементов();
	
КонецПроцедуры

Процедура ПереключательНеПодтверждаюПриИзменении(Элемент)
	
	УстановитьСостоянииЭлементов();
	
КонецПроцедуры

Процедура УстановитьСостоянииЭлементов()
	
	ЭлементыФормы.ОсновныеДействияФормы.Кнопки.Продолжить.Доступность = ПодтверждениеВыбора <> 0;
	
КонецПроцедуры
