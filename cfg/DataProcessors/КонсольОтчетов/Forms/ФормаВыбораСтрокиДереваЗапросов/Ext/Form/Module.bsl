﻿
Процедура ДеревоЗапросовВыбор(Элемент, ВыбраннаяСтрока, Колонка, СтандартнаяОбработка)

	СтандартнаяОбработка = Ложь;

	РодительСтроки = ВыбраннаяСтрока;
	Пока РодительСтроки <> НеОпределено Цикл

		Если РодительСтроки = ТекущаяСтрокаВладельца Тогда
			Предупреждение(НСтр("ru='Нельзя выбирать в качестве копируемой строки саму строку"
"или подчиненные ей строки. Выберите другую строку.';uk='Не можна вибирати в якості рядка, що копіюється, сам рядок"
"або підпорядковані йому рядки. Виберіть інший рядок.'"));
			Возврат;
		КонецЕсли;

		РодительСтроки = РодительСтроки.Родитель;

	КонецЦикла;

	ОповеститьОВыборе(ЭлементыФормы.ДеревоЗапросов.ТекущаяСтрока);

КонецПроцедуры

Процедура КнопкаНаВерхнийУровеньНажатие(Элемент)

	ОповеститьОВыборе(ВладелецФормы.ДеревоЗапросов);

КонецПроцедуры





