﻿

Процедура ПередЗаписью(Отказ)
	
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;	
	
	Если Не ЭтоНовый() Тогда
			
		Если НЕ ПравоДоступа("Администрирование", Метаданные) 
			И (Ссылка.Код <> Код) Тогда
			
			#Если Клиент Тогда
				
				Сообщить(НСтр("ru='Изменение кода существующего элемента справочника ""Пользователи"" запрещено. "
"Изменение кода возможно только при наличии права ""Администрирование""';uk='Зміна коду існуючого елемента довідника ""Користувачі"" заборонена. "
"Зміна коду можлива тільки при наявності права ""Адміністрування""'"), СтатусСообщения.Важное);
			
			#КонецЕсли
			Отказ = Истина;
			
		КонецЕсли;
			
	КонецЕсли;
		
КонецПроцедуры

Процедура ПриКопировании(ОбъектКопирования)
	
	Код = "";
	Наименование = "";
	
КонецПроцедуры
