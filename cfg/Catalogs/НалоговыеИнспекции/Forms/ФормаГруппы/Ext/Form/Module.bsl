﻿Процедура ПередЗаписью(Отказ)
	Если СтрДлина(СокрЛП(Код)) <> 2 Тогда
		Предупреждение(НСтр("ru='Код региона должен состоять из двух символов!';uk='Код регіону повинен складатися із двох символів!'"));
		Отказ = истина;
	КонецЕсли;
КонецПроцедуры

