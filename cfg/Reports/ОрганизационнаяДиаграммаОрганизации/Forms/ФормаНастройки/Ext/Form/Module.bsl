
Процедура КнопкаВыполнитьНажатие(Элемент)
	
	Закрыть("Истина");
	
КонецПроцедуры

Процедура ВидОтчетаПриИзменении(Элемент)
	
	СформироватьСписокПоказателей();

КонецПроцедуры

Процедура КоманднаяПанельПоказателиВыбратьВсе(Кнопка)
	
	Для каждого Строка Из  Показатели Цикл
		Строка.Использование = Истина;
	КонецЦикла;

КонецПроцедуры

Процедура КоманднаяПанельПоказателиСнятьВсе(Кнопка)
	
	Для каждого Строка Из  Показатели Цикл
		Строка.Использование = Ложь;
	КонецЦикла;

КонецПроцедуры




