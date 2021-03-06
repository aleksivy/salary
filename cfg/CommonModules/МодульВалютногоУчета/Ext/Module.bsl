////////////////////////////////////////////////////////////////////////////////
// ПРОЦЕДУРЫ И ФУНКЦИИ РАБОТЫ С ВАЛЮТАМИ

// Эта функция пересчитывает сумму из валюты ВалютаНач по курсу ПоКурсуНач 
// в валюту ВалютаКон по курсу ПоКурсуКон
//
// Параметры:      
//	Сумма          - сумма, которую следует пересчитать;
//	ВалютаНач      - ссылка на элемент справочника Валют;
//                   определяет валюты из которой надо пересчитвать;
//	ВалютаКон      - ссылка на элемент справочника Валют;
//                   определяет валюты в которую надо пересчитвать;
// 	ПоКурсуНач     - курс из которого надо пересчитать;
// 	ПоКурсуКон     - курс в который надо пересчитать;
// 	ПоКратностьНач - кратность из которого надо пересчитать (по умолчанию = 1);
// 	ПоКратностьКон - кратность в который надо пересчитать  (по умолчанию = 1);
//
// Возвращаемое значение: 
//  Сумма, пересчитанная в другую валюту
//
Функция ПересчитатьИзВалютыВВалюту(Сумма, ВалютаНач, ВалютаКон, ПоКурсуНач, ПоКурсуКон, 
	               ПоКратностьНач = 1, ПоКратностьКон = 1, Погрешность = 0, 
	               СоответствиеПогрешностей = Неопределено, Ключ = Неопределено) Экспорт

	Если (ВалютаНач = ВалютаКон) Тогда

		// Считаем, что пересчет не нужен.
		Возврат Сумма;
	КонецЕсли;

	Если (ПоКурсуНач = ПоКурсуКон) 
	   и (ПоКратностьНач = ПоКратностьКон) Тогда

		// пересчет суммы не требуется
		Возврат Сумма;
	КонецЕсли;

	Если ПоКурсуНач     = 0 
	 или ПоКурсуКон     = 0 
	 или ПоКратностьНач = 0 
	 или ПоКратностьКон = 0 Тогда
		ОбщегоНазначения.СообщитьОбОшибке(НСтр("ru='При пересчете из валюты ''")+ВалютаНач+НСтр("ru='' в валюту ''")+ВалютаКон+НСтр("ru='' обнаружен нулевой курс. Пересчет не произведен!'"));
		Возврат 0;
	КонецЕсли;

	
	НоваяСумма = (Сумма * ПоКурсуНач * ПоКратностьКон) / (ПоКурсуКон * ПоКратностьНач);
	Возврат ОбщегоНазначения.ОкруглитьСУчетомПогрешности(НоваяСумма, 2, Погрешность, СоответствиеПогрешностей, Ключ);

КонецФункции //ПересчитатьИзВалютыВВалюту()

// Возвращает курс валюты на дату
//
// Параметры:
//  Валюта     - Валюта (элемент справочника "Валюты")
//  ДатаКурса  - Дата, на которую следует получить курс
//  ПроверятьКурс - Если Истина и курс или кратность для валюты не установлены (=0), 
//					то им будет присвоено значение 1 (для избежания дальнейших ошибок деления на 0)
//
// Возвращаемое значение: 
//  Структура, содержащая:
//   Курс      - курс валюты
//   Кратность - кратность валюты
//
Функция ПолучитьКурсВалюты(Валюта, ДатаКурса, ПроверятьКурс = Истина) Экспорт	

	
	Если НЕ ЗначениеЗаполнено(Валюта) Тогда
		ОбщегоНазначения.СообщитьСлужебнуюИнформацию("ПолучитьКурсВалюты() - не заполнена валюта"); 
		
		Возврат Новый Структура("Курс, Кратность", 1, 1);
		
	КонецЕсли;

	СтруктураКурсов = РегистрыСведений.КурсыВалют.ПолучитьПоследнее(ДатаКурса, Новый Структура("Валюта", Валюта));
	
	Если СтруктураКурсов.Курс = 0 и ПроверятьКурс Тогда
		
		СтруктураКурсов.Вставить("Курс", 1);
		ОбщегоНазначения.СообщитьОбОшибке(НСтр("ru='По валюте ""';uk='По валюті ""'") + Валюта + НСтр("ru='"" на дату ""';uk='"" на дату ""'") + ДатаКурса + НСтр("ru='"" обнаружен нулевой курс.';uk='"" виявлений нульовий курс.'")
		                 + Символы.ПС + Символы.Таб + НСтр("ru='Временно, для расчетов, присвоено значение 1.';uk='Тимчасово, для розрахунків, присвоєно значення 1.'"));
	
	КонецЕсли;
	
	Если СтруктураКурсов.Кратность = 0 и ПроверятьКурс Тогда
		
		СтруктураКурсов.Вставить("Кратность", 1);
		ОбщегоНазначения.СообщитьОбОшибке(НСтр("ru='По валюте ""';uk='По валюті ""'") + Валюта + НСтр("ru='"" на дату ""';uk='"" на дату ""'") + ДатаКурса + НСтр("ru='"" обнаружена нулевая кратность.';uk='"" виявлена нульова кратність.'")
		                 + Символы.ПС + Символы.Таб + НСтр("ru='Временно, для расчетов, присвоено значение 1.';uk='Тимчасово, для розрахунків, присвоєно значення 1.'"));
	
	КонецЕсли;
		
	Возврат СтруктураКурсов;
	
КонецФункции // ПолучитьКурсВалюты()

// Проверяет наличие установленного курса и кратности валюты на 1 января 1980 года.
// В случае отсутствия устанавливает курс и кратность равными единице.
//
// Параметры:
//  Валюта - ссылка на элемент справочника Валют
//
Процедура ПроверитьКорректностьКурсаНа01_01_1980(Валюта) Экспорт

	ДатаКурса = Дата(1980, 1, 1);
	// Добавляем 3-й параметр = Ложь, чтобы в ПолучитьКурсВалюты не установилась автоматом курс и кратность в 1
	СтруктураКурса = ПолучитьКурсВалюты(Валюта, ДатаКурса, Ложь);

	Если (СтруктураКурса.Курс = 0) Или (СтруктураКурса.Кратность = 0) Тогда

		// установим курс и кратность = 1 на 01.01.1980, чтобы не было ошибок при создании документов

		РегистрКурсыВалют = РегистрыСведений.КурсыВалют.СоздатьМенеджерЗаписи();

		РегистрКурсыВалют.Период    = ДатаКурса;
		РегистрКурсыВалют.Валюта    = Валюта;
		РегистрКурсыВалют.Курс      = 1;
		РегистрКурсыВалют.Кратность = 1;
		РегистрКурсыВалют.Записать();
		
		РегистрКурсыВалют = РегистрыСведений.КурсыВалютДляРасчетовСПерсоналом.СоздатьМенеджерЗаписи();

		РегистрКурсыВалют.Период    = ДатаКурса;
		РегистрКурсыВалют.Валюта    = Валюта;
		РегистрКурсыВалют.Курс      = 1;
		РегистрКурсыВалют.Кратность = 1;
		РегистрКурсыВалют.Записать();

	КонецЕсли;

КонецПроцедуры // ПроверитьКорректностьКурсаНа01_01_1980()

// Функция производит пересчет суммы в валюте упр. учета в валюту регл. учета.
//
Функция ПересчитатьВСуммуРегл(СуммаУпр, ВалютаРегламентированногоУчета, ВалютаУправленческогоУчета, Дата) Экспорт

	ВалютаРегл = ВалютаРегламентированногоУчета;
	ВалютаУпр = ВалютаУправленческогоУчета;

	КурсВал   = ПолучитьКурсВалюты(ВалютаРегл, Дата);
	КурсРегл  = КурсВал.Курс;
	КратРегл  = КурсВал.Кратность;

	КурсВал   = ПолучитьКурсВалюты(ВалютаУпр, Дата);
	КурсУпр   = КурсВал.Курс;
	КратУпр   = КурсВал.Кратность;
	
	Если КурсРегл = 0 Тогда
		ОбщегоНазначения.Сообщение(НСтр("ru='Не задан курс валюты ""';uk='Не заданий курс валюти ""'") + ВалютаУправленческогоУчета + НСтр("ru='"" регламентированного учета!';uk='"" регламентованого обліку!'"), СтатусСообщения.Внимание);
		Возврат 0;
	КонецЕсли;
	
	Если КурсУпр = 0 Тогда
		ОбщегоНазначения.Сообщение(НСтр("ru='Не задан курс валюты ""';uk='Не заданий курс валюти ""'") + ВалютаУправленческогоУчета + НСтр("ru='"" управленческого учета!';uk='"" управлінського обліку!'"), СтатусСообщения.Внимание);
		Возврат 0;
	КонецЕсли;

	СуммаРегл = ПересчитатьИзВалютыВВалюту(СуммаУпр, ВалютаУпр, ВалютаРегл, КурсУпр, КурсРегл, КратУпр, КратРегл);

	Возврат СуммаРегл;

КонецФункции // ПересчитатьВСуммуРегл()

