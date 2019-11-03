﻿Перем мПериод Экспорт; 
Перем мТаблицаДвижений Экспорт;

Процедура ДобавитьДвижение() Экспорт
	
	мТаблицаДвижений.ЗаполнитьЗначения( мПериод, "Период");
	мТаблицаДвижений.ЗаполнитьЗначения( Истина,  "Активность");

	ОбщегоНазначения.ВыполнитьДвижениеПоРегистру(ЭтотОбъект);
	
КонецПроцедуры // ДобавитьДвижение()

Процедура ПередЗаписью(Отказ, Замещение)
		
	НастройкаПравДоступа.ПроверкаПериодаЗаписей(ЭтотОбъект, Отказ);
	
КонецПроцедуры
