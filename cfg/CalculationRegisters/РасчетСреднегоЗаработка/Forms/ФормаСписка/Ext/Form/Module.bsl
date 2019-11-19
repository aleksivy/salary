﻿////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ ЭЛЕМЕНТОВ ФОРМЫ

// Обработчик события вывода строки списка регистра
Процедура РегистрРасчетаСписокПриВыводеСтроки(Элемент, ОформлениеСтроки, ДанныеСтроки)
	
	// не показываем некоторые ячейки
	ОформлениеСтроки.Ячейки.КолонкаБазовыйПериод.Видимость = Ложь;
	ОформлениеСтроки.Ячейки.КолонкаОтработано.Видимость = Ложь;
	ОформлениеСтроки.Ячейки.КолонкаНорма.Видимость = Ложь;
	
КонецПроцедуры

