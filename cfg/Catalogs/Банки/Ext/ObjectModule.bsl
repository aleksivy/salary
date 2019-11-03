﻿
Процедура ПередЗаписью(Отказ)
	
	Если НЕ ЭтоГруппа И НЕ ОбменДанными.Загрузка Тогда
	
		СтрокаОшибки = НСтр("ru='Элемент справочника ""Банки"" ';uk='Елемент довідника ""Банки"" '") + Наименование + НСтр("ru=' не записан!';uk=' не записаний!'");
		
		Если НЕ ОбщегоНазначения.ТолькоЦифрыВСтроке(КоррСчет,,Ложь) Тогда
			ОбщегоНазначения.СообщитьОбОшибке(НСтр("ru='В составе Корр.счета банка должны быть только цифры.';uk='У складі Корр.рахунку банку повинні бути тільки цифри.'"),, СтрокаОшибки);
			Отказ = Истина;
		КонецЕсли; 
	
		Если НЕ ОбщегоНазначения.ТолькоЦифрыВСтроке(Код,,Ложь) Тогда
			ОбщегоНазначения.СообщитьОбОшибке(НСтр("ru='В составе МФО банка должны быть только цифры.';uk='У складі МФО банку повинні бути тільки цифри.'"),, СтрокаОшибки);
            Отказ = Истина;
		КонецЕсли; 
	
	КонецЕсли; 
	
КонецПроцедуры

