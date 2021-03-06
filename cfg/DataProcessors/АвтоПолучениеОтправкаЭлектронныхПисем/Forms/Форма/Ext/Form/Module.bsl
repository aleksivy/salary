
Процедура ПроверкаПисем()

	ОтключитьОбработчикОжидания("ПроверкаПисем");
	
	МассивОбработанныхСтрок = Новый Массив;
	
	Для каждого СтрокаТЧ Из УчетныеЗаписиАвтоматическогоТранспортаПисем Цикл
		Если СтрокаТЧ.ВремяПоследнегоПолучения + СтрокаТЧ.ИнтервалОбновления*60 > ТекущаяДата() Тогда
			Продолжить;
		КонецЕсли;
		МассивОбработанныхСтрок.Добавить(СтрокаТЧ);
	КонецЦикла;
	
	Если МассивОбработанныхСтрок.Количество() > 0 Тогда
		Состояние(НСтр("ru='Производится отправка/получение писем ...';uk='Провадиться відправлення/одержання листів ...'"));
		Для каждого СтрокаТЧ Из МассивОбработанныхСтрок Цикл
			МассивУчетныхЗаписей = Новый Массив;
			МассивУчетныхЗаписей.Добавить(СтрокаТЧ.УчетнаяЗапись);
			Если СтрокаТЧ.Действие = Перечисления.ВидыДействийАвтоПолученияОтправкиЭлектронныхПисем.Получение Тогда
				УправлениеЭлектроннойПочтой.ПолучениеОтправкаПисем(глЗначениеПеременной("глСоответствиеТекстовЭлектронныхПисем"), глЗначениеПеременной("глТекущийПользователь"), МассивУчетныхЗаписей,, Ложь, Истина, Ложь);
			ИначеЕсли СтрокаТЧ.Действие = Перечисления.ВидыДействийАвтоПолученияОтправкиЭлектронныхПисем.Отправка Тогда
				УправлениеЭлектроннойПочтой.ПолучениеОтправкаПисем(глЗначениеПеременной("глСоответствиеТекстовЭлектронныхПисем"), глЗначениеПеременной("глТекущийПользователь"), МассивУчетныхЗаписей,, Истина, Ложь, Ложь);
			Иначе
				УправлениеЭлектроннойПочтой.ПолучениеОтправкаПисем(глЗначениеПеременной("глСоответствиеТекстовЭлектронныхПисем"), глЗначениеПеременной("глТекущийПользователь"), МассивУчетныхЗаписей,, Истина, Истина, Ложь);
			КонецЕсли; 
			СтрокаТЧ.ВремяПоследнегоПолучения = ТекущаяДата();
		КонецЦикла; 
		Оповестить("РоботПолученияПисем");
	КонецЕсли; 
	
	Состояние("");
	
	ПодключитьОбработчикОжидания("ПроверкаПисем", 1);

КонецПроцедуры

Процедура КоманднаяПанельФормыОбновить(Кнопка)
	
	ОтключитьОбработчикОжидания("ПроверкаПисем");
	ОбновитьСписок();
	
КонецПроцедуры

Процедура ОбновитьСписок() Экспорт

	ОбновитьСписокУчетныхЗаписей();
	Если УчетныеЗаписиАвтоматическогоТранспортаПисем.Количество() > 0 Тогда
		ПодключитьОбработчикОжидания("ПроверкаПисем", 1);
	КонецЕсли;

КонецПроцедуры

ОбновитьСписок();
