Процедура ПередЗаписью(Отказ)
   	Если СтрДлина(СокрЛП(Код)) < 4 Тогда
		Предупреждение(НСтр("ru='Код ГНИ должен состоять из четырех символов!';uk='Код ДПІ повинен складатися із чотирьох символів!'"));
		Отказ = истина;
	КонецЕсли;

	Если СтрДлина(СокрЛП(КодАдмРайона)) < 2 Тогда
		Предупреждение(НСтр("ru='Код адм. района должен состоять из двух символов!';uk='Код адм. району повинен складатися із двох символів!'"));
		Отказ = истина;
	КонецЕсли;

	//Заполним реквизит, используемый для поиска элемента
	КодДляПоиска = Код + КодАдмРайона;
КонецПроцедуры

