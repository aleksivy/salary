Перем ТекстЗапроса Экспорт;

Функция ПолучитьОператорСравнения(ТипФильтра)
	
		Если    Врег(ТипФильтра) 		= "РАВНО"				ИЛИ Врег(ТипФильтра) = "ДОРІВНЮЄ"
					ИЛИ Врег(ТипФильтра)= "В СПИСКЕ"			ИЛИ Врег(ТипФильтра) = "В СПИСКУ"
					ИЛИ Врег(ТипФильтра)= "В ГРУППЕ ИЗ СПИСКА"	ИЛИ Врег(ТипФильтра) = "В ГРУПІ ЗІ СПИСКУ"
					ИЛИ Врег(ТипФильтра)= "В ГРУППЕ" 			ИЛИ Врег(ТипФильтра) = "В ГРУПІ" Тогда

					ОператорСравнения = " В ";

		ИначеЕсли Врег(ТипФильтра)		  = "НЕ РАВНО"              ИЛИ Врег(ТипФильтра) = "НЕ ДОРІВНЮЄ"
					  ИЛИ Врег(ТипФильтра)= "НЕ В СПИСКЕ"           ИЛИ Врег(ТипФильтра) = "НЕ В СПИСКУ"
					  ИЛИ Врег(ТипФильтра)= "НЕ В ГРУППЕ ИЗ СПИСКА" ИЛИ Врег(ТипФильтра) = "НЕ В ГРУПІ ЗІ СПИСКУ"
					  ИЛИ Врег(ТипФильтра)= "НЕ В ГРУППЕ" 			ИЛИ Врег(ТипФильтра) = "НЕ В ГРУПІ" Тогда
					  
					  ОператорСравнения = " НЕ В ";
					  
		ИначеЕсли Врег(ТипФильтра) = "В СПИСКЕ ПО ИЕРАРХИИ" ИЛИ Врег(ТипФильтра) = "В СПИСКУ ПО ІЄРАРХІЇ" Тогда
			
			ОператорСравнения = " В ИЕРАРХИИ ";
			
		ИначеЕсли Врег(ТипФильтра) = "НЕ В СПИСКЕ ПО ИЕРАРХИИ" ИЛИ Врег(ТипФильтра) = "НЕ В СПИСКУ ПО ІЄРАРХІЇ" Тогда
			
			ОператорСравнения = " НЕ В ИЕРАРХИИ ";

		КонецЕсли;

		
		Возврат ОператорСравнения;
		
КонецФункции
	
Процедура КнопкаВыполнитьНажатие(Элемент)
					
	ТекстЗапроса = "ВЫБРАТЬ РАЗРЕШЕННЫЕ
	               |	ТиповыеАнкетыВопросыАнкеты.Раздел КАК Раздел,
	               |	ТиповыеАнкетыВопросыАнкеты.Раздел.Наименование,
	               |	ТиповыеАнкетыВопросыАнкеты.Вопрос КАК Вопрос,
	               |	ТиповыеАнкетыВопросыАнкеты.Вопрос.ТипВопроса КАК ТипВопроса,
	               |	NULL КАК КолонкаТаблицы,
	               |	NULL КАК ТипКолонки,
	               |	ОпросВопросы.ТиповойОтвет КАК ТиповойОтвет,
	               |	ОпросВопросы.ТиповойОтвет.Код КАК ТиповойОтветКод,
	               |	ВЫБОР КОГДА (ОпросВопросы.ТиповойОтвет) ЕСТЬ NULL  ТОГДА 0 ИНАЧЕ 1 КОНЕЦ КАК Количество,
	               |	ВЫРАЗИТЬ(ОпросВопросы.ТиповойОтвет КАК ЧИСЛО(15, 2)) КАК ТиповойОтветСумма,
	               |	ВЫРАЗИТЬ(ОпросВопросы.ТиповойОтвет КАК ЧИСЛО(15, 2)) КАК ТиповойОтветСреднее,
	               |	ВЫРАЗИТЬ(ОпросВопросы.Ответ КАК СТРОКА(1000))КАК РазвернутыйОтвет,
	               |	ОпросВопросы.Ссылка КАК Опрос,
	               |	ОпросВопросы.Ссылка.ОпрашиваемоеЛицо КАК ОпрашиваемоеЛицо,
	               |	ТиповыеАнкетыВопросыАнкеты.НомерСтроки КАК НомерСтроки,
	               |	ТиповыеАнкетыВопросыАнкеты.Ссылка КАК Анкета
	               |{ВЫБРАТЬ 	               
				   |	ВЫБОР КОГДА (ОпросВопросы.ТиповойОтвет) ЕСТЬ NULL  ТОГДА 0 ИНАЧЕ 1 КОНЕЦ КАК Количество,
	               |	ТиповойОтветСумма,
	               |	ТиповойОтветСреднее,
				   |	РазвернутыйОтвет
	               |}
	               |ИЗ
	               |	Справочник.ТиповыеАнкеты.ВопросыАнкеты КАК ТиповыеАнкетыВопросыАнкеты
	               |		ЛЕВОЕ СОЕДИНЕНИЕ Документ.Опрос.Вопросы КАК ОпросВопросы
	               |		ПО ТиповыеАнкетыВопросыАнкеты.Вопрос = ОпросВопросы.Вопрос И ТиповыеАнкетыВопросыАнкеты.Ссылка = ОпросВопросы.Ссылка.ТиповаяАнкета
	               |
	               |ГДЕ //ВОПРОСУСЛОВИЕ1 И 
				   | НЕ(ОпросВопросы.ТиповойОтвет В (&СписокПустыхЗначений)) И " +
				   ?(ФлажокНастройкиАнкета, "
	               |	ТиповыеАнкетыВопросыАнкеты.Ссылка "+ПолучитьОператорСравнения(ЭлементыФормы.ПолеВидаСравненияАнкета.Значение)+" (&Анкета) И 
	               |	ОпросВопросы.Ссылка.ТиповаяАнкета "+ПолучитьОператорСравнения(ЭлементыФормы.ПолеВидаСравненияАнкета.Значение)+" (&Анкета) И ", "") + 
				   ?(ФлажокНастройкиРаздел, "
				   // с разделом
	               |	ТиповыеАнкетыВопросыАнкеты.Раздел "+ПолучитьОператорСравнения(ЭлементыФормы.ПолеВидаСравненияРаздел.Значение)+" (&Раздел) И 
	               |	ОпросВопросы.Ссылка.ТиповаяАнкета "+ПолучитьОператорСравнения(ЭлементыФормы.ПолеВидаСравненияРаздел.Значение)+" (&Раздел) И ", "") +
				   ?(ФлажокНастройкиОпрос, "
	               |	ОпросВопросы.Ссылка "+ПолучитьОператорСравнения(ЭлементыФормы.ПолеВидаСравненияОпрос.Значение)+" (&Опрос) И ", "");
				   ТекстЗапроса = Лев(ТекстЗапроса, СтрДлина(ТекстЗапроса) - 3);
				   ТекстЗапроса = ТекстЗапроса + "
				   |	
				   |{ГДЕ ТиповыеАнкетыВопросыАнкеты.Раздел, ТиповыеАнкетыВопросыАнкеты.Вопрос, ТиповыеАнкетыВопросыАнкеты.Ссылка, ОпросВопросы.Ссылка}
				   |	
	               |ОБЪЕДИНИТЬ ВСЕ
	               |
	               |ВЫБРАТЬ
	               |	ТиповыеАнкетыВопросыАнкеты.Раздел,
	               |	ТиповыеАнкетыВопросыАнкеты.Раздел.Наименование,
	               |	ОпросСоставнойОтвет.ВопросВладелец,
	               |	ОпросСоставнойОтвет.ВопросВладелец.ТипВопроса,
	               |	ОпросСоставнойОтвет.Вопрос,
	               |	ОпросСоставнойОтвет.Вопрос.ТипВопроса,
	               |	ОпросСоставнойОтвет.ТиповойОтвет,
	               |	ОпросСоставнойОтвет.ТиповойОтвет.Код,
	               |	ВЫБОР КОГДА (ОпросСоставнойОтвет.ТиповойОтвет) ЕСТЬ NULL  ТОГДА 0 ИНАЧЕ 1 КОНЕЦ,
	               |	ВЫРАЗИТЬ(ОпросСоставнойОтвет.ТиповойОтвет КАК ЧИСЛО(15, 2)) КАК ТиповойОтветСумма,
	               |	ВЫРАЗИТЬ(ОпросСоставнойОтвет.ТиповойОтвет КАК ЧИСЛО(15, 2)) КАК ТиповойОтветСреднее,
	               |	ВЫРАЗИТЬ(ОпросСоставнойОтвет.Ответ КАК СТРОКА(1000)) КАК РазвернутыйОтвет,
	               |	ОпросСоставнойОтвет.Ссылка,
	               |	ОпросСоставнойОтвет.Ссылка.ОпрашиваемоеЛицо,
	               |	ТиповыеАнкетыВопросыАнкеты.НомерСтроки,
	               |	ТиповыеАнкетыВопросыАнкеты.Ссылка
	               |{ВЫБРАТЬ 	               
				   |	ВЫБОР КОГДА (ОпросСоставнойОтвет.ТиповойОтвет) ЕСТЬ NULL  ТОГДА 0 ИНАЧЕ 1 КОНЕЦ КАК Количество,
	               |	ТиповойОтветСумма,
	               |	ТиповойОтветСреднее,
				   |	РазвернутыйОтвет
	               |}
	               |ИЗ
	               |	Справочник.ТиповыеАнкеты.ВопросыАнкеты КАК ТиповыеАнкетыВопросыАнкеты
	               |		ЛЕВОЕ СОЕДИНЕНИЕ Документ.Опрос.СоставнойОтвет КАК ОпросСоставнойОтвет
	               |		ПО ТиповыеАнкетыВопросыАнкеты.Вопрос = ОпросСоставнойОтвет.ВопросВладелец И ТиповыеАнкетыВопросыАнкеты.Ссылка = ОпросСоставнойОтвет.Ссылка.ТиповаяАнкета
	               |
	               |ГДЕ //ВОПРОСУСЛОВИЕ2 И 
   				   |НЕ(ОпросСоставнойОтвет.ТиповойОтвет В (&СписокПустыхЗначений)) И "+
				   ?(ФлажокНастройкиАнкета, "
	               |	ТиповыеАнкетыВопросыАнкеты.Ссылка "+ПолучитьОператорСравнения(ЭлементыФормы.ПолеВидаСравненияАнкета.Значение)+" (&Анкета) И ", "") + 
				   ?(ФлажокНастройкиРаздел, "
				   // с разделом
	               |	ТиповыеАнкетыВопросыАнкеты.Раздел "+ПолучитьОператорСравнения(ЭлементыФормы.ПолеВидаСравненияРаздел.Значение)+" (&Раздел) И ", "") +
				   ?(ФлажокНастройкиОпрос, "
	               |	ОпросСоставнойОтвет.Ссылка "+ПолучитьОператорСравнения(ЭлементыФормы.ПолеВидаСравненияРаздел.Значение)+" (&Опрос) И ", "");
				   ТекстЗапроса = Лев(ТекстЗапроса, СтрДлина(ТекстЗапроса) - 3);
				   ТекстЗапроса = ТекстЗапроса + "
				   |	
				   |{ГДЕ ТиповыеАнкетыВопросыАнкеты.Раздел, ТиповыеАнкетыВопросыАнкеты.Вопрос, ТиповыеАнкетыВопросыАнкеты.Ссылка, ОпросСоставнойОтвет.Ссылка}
				   |	
	               |УПОРЯДОЧИТЬ ПО
	               |	НомерСтроки,
				   |	ТиповойОтвет.Код
	               |
	               |ИТОГИ КОЛИЧЕСТВО(Количество), СУММА(ТиповойОтветСумма), СРЕДНЕЕ(ТиповойОтветСреднее) ПО
				   |	Анкета, Раздел,
				   |	Вопрос,
				   |	КолонкаТаблицы,
	               |	ТиповойОтвет,
				   |	ОпрашиваемоеЛицо,
				   |	Опрос
	               |
	               |{ИТОГИ ПО
				   //|	Раздел,
				   //|	Вопрос,
				   //|	КолонкаТаблицы,
	               |	ТиповойОтвет
				   //|	ОпрашиваемоеЛицо,
				   //|	Опрос
	               |}";
				   
	ЗапросОпрос 		= Новый Запрос(ТекстЗапроса);
	СписокТиповВопросов = Новый СписокЗначений;
	СписокТиповВопросов.Добавить(Перечисления.ТипВопросаАнкеты.Число);
	СписокТиповВопросов.Добавить(Перечисления.ТипВопросаАнкеты.Булево);
	
	ЗапросОпрос.УстановитьПараметр("Анкета", 			  ЭлементыФормы.ПолеНастройкиАнкета.Значение);
	ЗапросОпрос.УстановитьПараметр("Раздел",	  	  	  ЭлементыФормы.ПолеНастройкиРаздел.Значение);
	ЗапросОпрос.УстановитьПараметр("Опрос",	  	  	  	  ЭлементыФормы.ПолеНастройкиОпрос.Значение);
	
	ЗапросОпрос.УстановитьПараметр("СписокТиповВопросов", СписокТиповВопросов);
	ЗапросОпрос.УстановитьПараметр("НесколькоОтветов",	  Перечисления.ТипВопросаАнкеты.СправочникСсылка_ВариантыОтветов_Несколько);
	ЗапросОпрос.УстановитьПараметр("ВариантОтвета",	  	  Перечисления.ТипВопросаАнкеты.СправочникСсылка_ВариантыОтветов);
	СписокПустыхЗначений = Новый СписокЗначений;
	
	ТипыПВХ = Метаданные.ПланыВидовХарактеристик.ВопросыДляАнкетирования.Тип.Типы();
	
	Для каждого ТипИзХарактеристики из ТипыПВХ Цикл
		Если ТипИзХарактеристики = Тип("Булево") тогда
			Продолжить;
		КонецЕсли;
		СписокПустыхЗначений.Добавить(ОбщегоНазначения.ПустоеЗначениеТипа(ТипИзХарактеристики));
	КонецЦикла;
	СписокПустыхЗначений.Добавить(Неопределено);
	
	ЗапросОпрос.УстановитьПараметр("СписокПустыхЗначений",СписокПустыхЗначений);
	РезультатЗапроса 	= ЗапросОпрос.Выполнить();
	
	ВыборкаЗапросаАнкета= РезультатЗапроса.Выбрать(ОбходРезультатаЗапроса.ПоГруппировкам);
	МакетДляВывода 		= ПолучитьМакет("Макет");
	
	КодЯзыкаПечать = Локализация.ПолучитьЯзыкФормированияПечатныхФорм(УправлениеПользователями.ПолучитьЗначениеПоУмолчанию(глЗначениеПеременной("глТекущийПользователь"), "РежимФормированияПечатныхФорм"));
	МакетДляВывода.КодЯзыкаМакета = КодЯзыкаПечать;

	ОбластьШапка		= МакетДляВывода.ПолучитьОбласть("Шапка");
	ОбластьВопрос		= МакетДляВывода.ПолучитьОбласть("Вопрос");
	ОбластьОтвет		= МакетДляВывода.ПолучитьОбласть("Ответ");
	ОбластьАнкета		= МакетДляВывода.ПолучитьОбласть("Анкета");
	ОбластьРаздел		= МакетДляВывода.ПолучитьОбласть("Раздел");
	ОбластьОпрашиваемоеЛицо = МакетДляВывода.ПолучитьОбласть("ОпрашиваемоеЛицо");
	ОбластьОпрос		= МакетДляВывода.ПолучитьОбласть("Опрос");
	ТабличныйДокумент	= ЭлементыФормы.ПолеТабличногоДокумента;
	ТабличныйДокумент.Очистить();
	ТабличныйДокумент.Вывести(ОбластьШапка);
	ТабличныйДокумент.НачатьАвтогруппировкуСтрок();
	Пока ВыборкаЗапросаАнкета.Следующий() Цикл
		
		ОбластьАнкета.Параметры["НаименованиеАнкеты"] = ВыборкаЗапросаАнкета.Анкета;
		ТабличныйДокумент.Вывести(ОбластьАнкета, 1);
		ВыборкаЗапроса = ВыборкаЗапросаАнкета.Выбрать(ОбходРезультатаЗапроса.ПоГруппировкам);
		
		Пока ВыборкаЗапроса.Следующий() Цикл
			ОбластьРаздел.Параметры["НаименованиеРаздела"] = ВыборкаЗапроса.РазделНаименование;
			ТабличныйДокумент.Вывести(ОбластьРаздел, 1);
			ВыборкаПоВопросам = ВыборкаЗапроса.Выбрать(ОбходРезультатаЗапроса.ПоГруппировкам);
			Пока ВыборкаПоВопросам.Следующий() Цикл
				
				ОбластьВопрос.Параметры["НаименованиеВопроса"] 	= Строка(ВыборкаПоВопросам.Вопрос);
				ОбластьВопрос.Параметры["Количество"] 	= ВыборкаПоВопросам.Количество;
				ОбластьВопрос.Параметры["Сумма"]		= Формат(ВыборкаПоВопросам.ТиповойОтветСумма, "ЧЦ=15; ЧДЦ=2");
				ОбластьВопрос.Параметры["Среднее"] 		= Формат(ВыборкаПоВопросам.ТиповойОтветСреднее, "ЧЦ=15; ЧДЦ=2");
				ОбластьВопрос.Параметры["Процент"] 				= "";
				ОбластьВопрос.Параметры["ПроцентОтСуммы"] 		= "";
				ОбластьВопрос.Параметры["РасшифровкаВопрос"]	= ВыборкаПоВопросам.Вопрос;
				
				ВыборкаДетальныхЗаписей = ВыборкаПоВопросам.Выбрать(ОбходРезультатаЗапроса.ПоГруппировкам, "");
				СуммаРазвернутыйОтветПоВопросу 	= 0;
				Пока ВыборкаДетальныхЗаписей.Следующий() Цикл
					Попытка
						СуммаРазвернутыйОтветПоВопросу	= СуммаРазвернутыйОтветПоВопросу + Число(ВыборкаДетальныхЗаписей.РазвернутыйОтвет);
					Исключение
					КонецПопытки;
				КонецЦикла;
				ОбластьВопрос.Параметры["СуммаРазвернутыйОтвет"] 		= Формат(СуммаРазвернутыйОтветПоВопросу, "ЧЦ=15; ЧДЦ=2");
				ОбластьВопрос.Параметры["СреднееРазвернутыйОтвет"] 		= Формат(СуммаРазвернутыйОтветПоВопросу/ВыборкаПоВопросам.Количество, "ЧЦ=15; ЧДЦ=2");
				ТабличныйДокумент.Вывести(ОбластьВопрос, 2);
				
				Если ВыборкаПоВопросам.ТипВопроса = Перечисления.ТипВопросаАнкеты.Строка ИЛИ
					ВыборкаПоВопросам.ТипВопроса = Перечисления.ТипВопросаАнкеты.Текст ИЛИ
					ВыборкаПоВопросам.ТипВопроса = Перечисления.ТипВопросаАнкеты.Число ИЛИ
					ВыборкаПоВопросам.ТипВопроса = Перечисления.ТипВопросаАнкеты.Адрес ИЛИ
					ВыборкаПоВопросам.ТипВопроса = Перечисления.ТипВопросаАнкеты.АдресЭлектроннойПочты ИЛИ
					ВыборкаПоВопросам.ТипВопроса = Перечисления.ТипВопросаАнкеты.ВебСтраница ИЛИ
					ВыборкаПоВопросам.ТипВопроса = Перечисления.ТипВопросаАнкеты.Дата ИЛИ
					ВыборкаПоВопросам.ТипВопроса = Перечисления.ТипВопросаАнкеты.Другое ИЛИ
					ВыборкаПоВопросам.ТипВопроса = Перечисления.ТипВопросаАнкеты.Телефон тогда
					ОткрытыйОтвет = Ложь;
				Иначе
					ОткрытыйОтвет = Истина;
				КонецЕсли;
				
				ВыборкаПоВопросамКоличество = ВыборкаПоВопросам.Количество;
				Если НЕ (ВыборкаПоВопросам.ТипВопроса = Перечисления.ТипВопросаАнкеты.Табличный ИЛИ
					ВыборкаПоВопросам.ТипВопроса = Перечисления.ТипВопросаАнкеты.СправочникСсылка_ВариантыОтветов_Несколько) тогда
					// вывод обычных (не табличных) вопросов
					ВыборкаПоОтветам = ВыборкаПоВопросам.Выбрать(ОбходРезультатаЗапроса.ПоГруппировкам, "ТиповойОтвет");
					Пока ВыборкаПоОтветам.Следующий() Цикл
						ОбластьОтвет.Параметры["Ответ"] 		= Формат(ВыборкаПоОтветам.ТиповойОтвет, "БЛ=Нет; БИ=Да");
						ОбластьОтвет.Параметры["Количество"] 	= ВыборкаПоОтветам.Количество;
						ОбластьОтвет.Параметры["Сумма"] 		= Формат(ВыборкаПоОтветам.ТиповойОтветСумма, "ЧЦ=15; ЧДЦ=2");
						ОбластьОтвет.Параметры["Среднее"] 		= Формат(ВыборкаПоОтветам.ТиповойОтветСреднее, "ЧЦ=15; ЧДЦ=2");
						Попытка
							ОбластьОтвет.Параметры["Процент"] 		= Формат(100*ВыборкаПоОтветам.Количество/ВыборкаПоВопросам.Количество, "ЧЦ=15; ЧДЦ=2") + "%";
						Исключение
							ОбластьОтвет.Параметры["Процент"] 		= "";
						КонецПопытки;
						Попытка
							ОбластьОтвет.Параметры["ПроцентОтСуммы"] 		= Формат(100*ВыборкаПоОтветам.ТиповойОтветСумма/ВыборкаПоВопросам.ТиповойОтветСумма, "ЧЦ=15; ЧДЦ=2") + "%";
						Исключение
							ОбластьОтвет.Параметры["ПроцентОтСуммы"] 		= "";
						КонецПопытки;
						
						ВыборкаДетальныхЗаписей = ВыборкаПоОтветам.Выбрать(ОбходРезультатаЗапроса.ПоГруппировкам, "");
						СуммаРазвернутыйОтвет 	= 0;
						Пока ВыборкаДетальныхЗаписей.Следующий() Цикл
							Попытка
								СуммаРазвернутыйОтвет = СуммаРазвернутыйОтвет + Число(ВыборкаДетальныхЗаписей.РазвернутыйОтвет);
							Исключение
							КонецПопытки;
						КонецЦикла;
						
						ОбластьОтвет.Параметры["СуммаРазвернутыйОтвет"] 		= Формат(СуммаРазвернутыйОтвет, "ЧЦ=15; ЧДЦ=2");
						ОбластьОтвет.Параметры["СреднееРазвернутыйОтвет"] 		= Формат(СуммаРазвернутыйОтвет/ВыборкаПоОтветам.Количество, "ЧЦ=15; ЧДЦ=2");
						Если СуммаРазвернутыйОтветПоВопросу <> 0 тогда
							ОбластьОтвет.Параметры["ПроцентРазвернутыйОтвет"] 		= Формат(100*СуммаРазвернутыйОтвет/СуммаРазвернутыйОтветПоВопросу, "ЧЦ=15; ЧДЦ=2") + "%";
						Иначе
							ОбластьОтвет.Параметры["ПроцентРазвернутыйОтвет"] 		= "";
						КонецЕсли;
						ТабличныйДокумент.Вывести(ОбластьОтвет, 3,, ОткрытыйОтвет);
						ВыборкаПоОпрашиваемомуЛицу = ВыборкаПоОтветам.Выбрать(ОбходРезультатаЗапроса.ПоГруппировкам);
						Пока ВыборкаПоОпрашиваемомуЛицу.Следующий() Цикл
							ОбластьОпрашиваемоеЛицо.Параметры["ОпрашиваемоеЛицо"] 				= ВыборкаПоОпрашиваемомуЛицу.ОпрашиваемоеЛицо;
							ОбластьОпрашиваемоеЛицо.Параметры["РасшифровкаОпрашиваемоеЛицо"]	= ВыборкаПоОпрашиваемомуЛицу.ОпрашиваемоеЛицо;
							ТабличныйДокумент.Вывести(ОбластьОпрашиваемоеЛицо, 4,, Ложь);
							ВыборкаОпрос = ВыборкаПоОпрашиваемомуЛицу.Выбрать(ОбходРезультатаЗапроса.ПоГруппировкам);
							Пока ВыборкаОпрос.Следующий() Цикл
								ОбластьОпрос.Параметры["Опрос"]				= ВыборкаОпрос.Опрос;
								ОбластьОпрос.Параметры["РасшифровкаОпрос"]	= ВыборкаОпрос.Опрос;
								
								ВыборкаДетальныхЗаписей = ВыборкаОпрос.Выбрать(ОбходРезультатаЗапроса.ПоГруппировкам, "");
								СуммаРазвернутыйОтвет 	= 0;
								Пока ВыборкаДетальныхЗаписей.Следующий() Цикл
									Попытка
										СуммаРазвернутыйОтвет = СуммаРазвернутыйОтвет + Число(ВыборкаДетальныхЗаписей.РазвернутыйОтвет);
									Исключение
									КонецПопытки;
								КонецЦикла;
								
								ОбластьОпрос.Параметры["СуммаРазвернутыйОтвет"] = СуммаРазвернутыйОтвет;
								ТабличныйДокумент.Вывести(ОбластьОпрос, 5,, Ложь);
							КонецЦикла;
						КонецЦикла;
					КонецЦикла;
				ИначеЕсли ВыборкаПоВопросам.ТипВопроса = Перечисления.ТипВопросаАнкеты.Табличный ИЛИ
					ВыборкаПоВопросам.ТипВопроса = Перечисления.ТипВопросаАнкеты.СправочникСсылка_ВариантыОтветов_Несколько тогда
					// вывод табличного вопроса
					ВыборкаПоКолонкам = ВыборкаПоВопросам.Выбрать(ОбходРезультатаЗапроса.ПоГруппировкам);
					Пока ВыборкаПоКолонкам.Следующий() Цикл
						Если ВыборкаПоВопросам.ТипВопроса <> Перечисления.ТипВопросаАнкеты.СправочникСсылка_ВариантыОтветов_Несколько тогда
							ОбластьВопрос.Параметры["НаименованиеВопроса"] 	= "    "+Строка(ВыборкаПоКолонкам.КолонкаТаблицы);
							ОбластьВопрос.Параметры["Количество"] 	= ВыборкаПоКолонкам.Количество;
							ОбластьВопрос.Параметры["Сумма"]		= Формат(ВыборкаПоКолонкам.ТиповойОтветСумма, "ЧЦ=15; ЧДЦ=2");
							ОбластьВопрос.Параметры["Среднее"] 		= Формат(ВыборкаПоКолонкам.ТиповойОтветСреднее, "ЧЦ=15; ЧДЦ=2");
							Попытка
								ОбластьВопрос.Параметры["ПроцентОтСуммы"] 		= Формат(100*ВыборкаПоКолонкам.ТиповойОтветСумма/ВыборкаПоВопросам.ТиповойОтветСумма, "ЧЦ=15; ЧДЦ=2") + "%";
								ОбластьВопрос.Параметры["Процент"] 				= "";
							Исключение
								ОбластьВопрос.Параметры["Процент"] 			= "";
								ОбластьВопрос.Параметры["ПроцентОтСуммы"] 	= "";
							КонецПопытки;
							
							ВыборкаДетальныхЗаписей = ВыборкаПоКолонкам.Выбрать(ОбходРезультатаЗапроса.ПоГруппировкам, "");
							СуммаРазвернутыйОтветПоКолонке	= 0;
							Пока ВыборкаДетальныхЗаписей.Следующий() Цикл
								Попытка
									СуммаРазвернутыйОтветПоКолонке	= СуммаРазвернутыйОтветПоКолонке + Число(ВыборкаДетальныхЗаписей.РазвернутыйОтвет);
								Исключение
								КонецПопытки;
							КонецЦикла;
							ОбластьВопрос.Параметры["СуммаРазвернутыйОтвет"] 		= Формат(СуммаРазвернутыйОтветПоКолонке, "ЧЦ=15; ЧДЦ=2");
							ОбластьОтвет.Параметры["СреднееРазвернутыйОтвет"] 		= Формат(СуммаРазвернутыйОтветПоКолонке/ВыборкаПоВопросам.Количество, "ЧЦ=15; ЧДЦ=2");
							Если СуммаРазвернутыйОтветПоВопросу <> 0 тогда
								ОбластьОтвет.Параметры["ПроцентРазвернутыйОтвет"] 		= Формат(100*СуммаРазвернутыйОтветПоКолонке/СуммаРазвернутыйОтветПоВопросу, "ЧЦ=15; ЧДЦ=2") + "%";
							Иначе
								ОбластьОтвет.Параметры["ПроцентРазвернутыйОтвет"] 		= "";
							КонецЕсли;
							
							ТабличныйДокумент.Вывести(ОбластьВопрос, 3,, ОткрытыйОтвет);
						КонецЕсли;
						ВыборкаПоОтветам = ВыборкаПоКолонкам.Выбрать(ОбходРезультатаЗапроса.ПоГруппировкам);
						ВыборкаТипКолонки = ВыборкаПоКолонкам.Выбрать(ОбходРезультатаЗапроса.ПоГруппировкам, "");
						ВыборкаТипКолонки.Следующий();
						
						Если ВыборкаТипКолонки.ТипКолонки = Перечисления.ТипВопросаАнкеты.Строка ИЛИ
							ВыборкаТипКолонки.ТипКолонки = Перечисления.ТипВопросаАнкеты.Текст ИЛИ
							ВыборкаТипКолонки.ТипКолонки = Перечисления.ТипВопросаАнкеты.Число ИЛИ
							ВыборкаТипКолонки.ТипКолонки = Перечисления.ТипВопросаАнкеты.Адрес ИЛИ
							ВыборкаТипКолонки.ТипКолонки = Перечисления.ТипВопросаАнкеты.АдресЭлектроннойПочты ИЛИ
							ВыборкаТипКолонки.ТипКолонки = Перечисления.ТипВопросаАнкеты.ВебСтраница ИЛИ
							ВыборкаТипКолонки.ТипКолонки = Перечисления.ТипВопросаАнкеты.Дата ИЛИ
							ВыборкаТипКолонки.ТипКолонки = Перечисления.ТипВопросаАнкеты.Другое ИЛИ
							ВыборкаТипКолонки.ТипКолонки = Перечисления.ТипВопросаАнкеты.Телефон тогда
							ОткрытаяКолонка = Ложь;
						Иначе
							ОткрытаяКолонка = Истина;
						КонецЕсли;
						
						Пока ВыборкаПоОтветам.Следующий() Цикл
							ОбластьОтвет.Параметры["Ответ"] 		= Формат(ВыборкаПоОтветам.ТиповойОтвет, "БЛ=Нет; БИ=Да");
							ОбластьОтвет.Параметры["Количество"] 	= ВыборкаПоОтветам.Количество;
							ОбластьОтвет.Параметры["Сумма"] 		= Формат(ВыборкаПоОтветам.ТиповойОтветСумма, "ЧЦ=15; ЧДЦ=2");
							ОбластьОтвет.Параметры["Среднее"] 		= Формат(ВыборкаПоОтветам.ТиповойОтветСреднее, "ЧЦ=15; ЧДЦ=2");
							Попытка
								ОбластьОтвет.Параметры["Процент"] 		= Формат(100*ВыборкаПоОтветам.Количество/ВыборкаПоКолонкам.Количество, "ЧЦ=15; ЧДЦ=2") + "%";
							Исключение
								ОбластьОтвет.Параметры["Процент"] 		= "";
							КонецПопытки;
							Попытка
								ОбластьОтвет.Параметры["ПроцентОтСуммы"] 		= Формат(100*ВыборкаПоОтветам.ТиповойОтветСумма/ВыборкаПоКолонкам.ТиповойОтветСумма, "ЧЦ=15; ЧДЦ=2") + "%";
							Исключение
								ОбластьОтвет.Параметры["ПроцентОтСуммы"] 		= "";
							КонецПопытки;
							
							ВыборкаДетальныхЗаписей = ВыборкаПоОтветам.Выбрать(ОбходРезультатаЗапроса.ПоГруппировкам, "");
							СуммаРазвернутыйОтвет	= 0;
							Пока ВыборкаДетальныхЗаписей.Следующий() Цикл
								Попытка
									СуммаРазвернутыйОтвет	= СуммаРазвернутыйОтвет + Число(ВыборкаДетальныхЗаписей.РазвернутыйОтвет);
								Исключение
								КонецПопытки;
							КонецЦикла;
							
							ОбластьОтвет.Параметры["СуммаРазвернутыйОтвет"] 		= Формат(СуммаРазвернутыйОтвет, "ЧЦ=15; ЧДЦ=2");
							ОбластьОтвет.Параметры["СреднееРазвернутыйОтвет"] 		= Формат(СуммаРазвернутыйОтвет/ВыборкаПоОтветам.Количество, "ЧЦ=15; ЧДЦ=2");
							Если СуммаРазвернутыйОтветПоВопросу <> 0 тогда
								ОбластьОтвет.Параметры["ПроцентРазвернутыйОтвет"] 		= Формат(100*СуммаРазвернутыйОтвет/СуммаРазвернутыйОтветПоВопросу, "ЧЦ=15; ЧДЦ=2") + "%";
							Иначе
								ОбластьОтвет.Параметры["ПроцентРазвернутыйОтвет"] 		= "";
							КонецЕсли;
							ТабличныйДокумент.Вывести(ОбластьОтвет, 4,, ОткрытаяКолонка);
							ВыборкаПоОпрашиваемомуЛицу = ВыборкаПоОтветам.Выбрать(ОбходРезультатаЗапроса.ПоГруппировкам);
							Пока ВыборкаПоОпрашиваемомуЛицу.Следующий() Цикл
								ОбластьОпрашиваемоеЛицо.Параметры["ОпрашиваемоеЛицо"] 				= ВыборкаПоОпрашиваемомуЛицу.ОпрашиваемоеЛицо;
								ОбластьОпрашиваемоеЛицо.Параметры["РасшифровкаОпрашиваемоеЛицо"]	= ВыборкаПоОпрашиваемомуЛицу.ОпрашиваемоеЛицо;
								ТабличныйДокумент.Вывести(ОбластьОпрашиваемоеЛицо, 5,, Ложь);
								ВыборкаОпрос = ВыборкаПоОпрашиваемомуЛицу.Выбрать(ОбходРезультатаЗапроса.ПоГруппировкам);
								Пока ВыборкаОпрос.Следующий() Цикл
									ОбластьОпрос.Параметры["Опрос"]				= ВыборкаОпрос.Опрос;
									ОбластьОпрос.Параметры["РасшифровкаОпрос"]	= ВыборкаОпрос.Опрос;
									
									ВыборкаДетальныхЗаписей = ВыборкаОпрос.Выбрать(ОбходРезультатаЗапроса.ПоГруппировкам, "");
									СуммаРазвернутыйОтвет 	= 0;
									Пока ВыборкаДетальныхЗаписей.Следующий() Цикл
										Попытка
											СуммаРазвернутыйОтвет = СуммаРазвернутыйОтвет + Число(ВыборкаДетальныхЗаписей.РазвернутыйОтвет);
										Исключение
										КонецПопытки;
									КонецЦикла;
									
									ОбластьОпрос.Параметры["СуммаРазвернутыйОтвет"] = СуммаРазвернутыйОтвет;
									
									ТабличныйДокумент.Вывести(ОбластьОпрос, 6,, Ложь);
								КонецЦикла;
							КонецЦикла;
						КонецЦикла;
					КонецЦикла;
				КонецЕсли;
			КонецЦикла;
		КонецЦикла;
	КонецЦикла;
	ТабличныйДокумент.ЗакончитьАвтогруппировкуСтрок();
	
КонецПроцедуры

Процедура ПолеТабличногоДокументаОбработкаРасшифровки(Элемент, Расшифровка, СтандартнаяОбработка)
	
	Если ТипЗнч(Расшифровка) = Тип("ПланВидовХарактеристикСсылка.ВопросыДляАнкетирования") тогда
		СтандартнаяОбработка 	= Ложь;
		ОтчетОтветНаВопрос 		= Отчеты.ОтветНаВопрос.Создать();
		ФормаРасшифровкиВопроса = ОтчетОтветНаВопрос.ПолучитьФорму("Форма");
		ФормаРасшифровкиВопроса.ЭтотОтчет.ТекстЗапросаОтчета = ТекстЗапроса;
		ФормаРасшифровкиВопроса.ЭтотОтчет.ВариантОтображения = "Диаграмма";
		ФормаРасшифровкиВопроса.ЭлементыФормы.Диаграмма.Видимость 				= Ложь;
		ФормаРасшифровкиВопроса.Открыть();
		
		ФормаРасшифровкиВопроса.ПостроительОтчета.Отбор.Анкета.Использование 	= ФлажокНастройкиАнкета;
		ФормаРасшифровкиВопроса.ПостроительОтчета.Отбор.Анкета.ВидСравнения		= ЭлементыФормы.ПолеВидаСравненияАнкета.Значение;
		ФормаРасшифровкиВопроса.ПостроительОтчета.Отбор.Анкета.Значение 		= ЭлементыФормы.ПолеНастройкиАнкета.Значение;
		
		ФормаРасшифровкиВопроса.ПостроительОтчета.Отбор.Раздел.Использование 	= ФлажокНастройкиРаздел;
		ФормаРасшифровкиВопроса.ПостроительОтчета.Отбор.Раздел.ВидСравнения		= ЭлементыФормы.ПолеВидаСравненияРаздел.Значение;
		ФормаРасшифровкиВопроса.ПостроительОтчета.Отбор.Раздел.Значение 		= ЭлементыФормы.ПолеНастройкиРаздел.Значение;
		
		ФормаРасшифровкиВопроса.ПостроительОтчета.Отбор.Опрос.Использование 	= ФлажокНастройкиОпрос;
		ФормаРасшифровкиВопроса.ПостроительОтчета.Отбор.Опрос.ВидСравнения		= ЭлементыФормы.ПолеВидаСравненияОпрос.Значение;
		ФормаРасшифровкиВопроса.ПостроительОтчета.Отбор.Опрос.Значение 			= ЭлементыФормы.ПолеНастройкиОпрос.Значение;
		
		ФормаРасшифровкиВопроса.ПостроительОтчета.Отбор.Вопрос.Использование 	= Истина;
		ФормаРасшифровкиВопроса.ПостроительОтчета.Отбор.Вопрос.Значение 		= Расшифровка;
		ФормаРасшифровкиВопроса.ОбновитьОтчет();
		ФормаРасшифровкиВопроса.ЭлементыФормы.Диаграмма.Видимость 				= Истина;
		
	КонецЕсли;
	
КонецПроцедуры

Процедура ПолеВидаСравнения1ПриИзменении(Элемент)

	//УправлениеОтчетами.ПолеВидаСравненияПриИзменении(Элемент, ЭлементыФормы);
	ИмяОтбора = Сред(Элемент.Имя, Найти(Элемент.Имя, "ПолеВидаСравнения")+СтрДлина("ПолеВидаСравнения"));
	Если ЭлементыФормы.Найти("ПолеНастройки" + ИмяОтбора) <> НеОпределено Тогда
		ПолеНастройки = ЭлементыФормы["ПолеНастройки"+ИмяОтбора];
		ПолеНастройки.Видимость = Истина;
		Если Элемент.Значение = ВидСравнения.ВСписке
			ИЛИ Элемент.Значение = ВидСравнения.НеВСписке
			ИЛИ Элемент.Значение = ВидСравнения.ВСпискеПоИерархии
			ИЛИ Элемент.Значение = ВидСравнения.НеВСпискеПоИерархии Тогда
			ПолеНастройки.ОграничениеТипа = Новый ОписаниеТипов("СписокЗначений");
			ПолеНастройки.ВыбиратьТип=Ложь;
			Было = ПолеНастройки.Значение;
			ПолеНастройки.Значение = Новый СписокЗначений;
			Если ЗначениеЗаполнено(Было) Тогда
				ПолеНастройки.Значение.Добавить(Было);
			КонецЕсли;
		Иначе
			ПолеНастройки.ОграничениеТипа = Новый ОписаниеТипов(ПолеНастройки.ТипЗначенияСписка);
			Если ПолеНастройки.ТипЗначенияСписка.Типы().Количество() =  1 Тогда
				ПолеНастройки.ВыбиратьТип=Ложь;
				Если НЕ ЗначениеЗаполнено(ПолеНастройки.Значение) ИЛИ ТипЗнч(ПолеНастройки.Значение) =  Тип("СписокЗначений") тогда
					
					Было = Неопределено;
					Если ТипЗнч(ПолеНастройки.Значение) =  Тип("СписокЗначений") Тогда
						Если ПолеНастройки.Значение.Количество() > 0 Тогда
						Было = ПолеНастройки.Значение[0].Значение;
						КонецЕсли;
					КонецЕсли;
					
					Если ЗначениеЗаполнено(Было) Тогда
						ПолеНастройки.Значение=Было;
					Иначе
						
						ПервыйТип = ПолеНастройки.ТипЗначенияСписка.Типы()[0];
						//Если ТипЗнч(ПервыйТип) =  Тип("Строка") Тогда
						//	ПолеНастройки.Значение = "";
						//ИначеЕсли ТипЗнч(ПервыйТип) =  Тип("Число") Тогда
						//	ПолеНастройки.Значение = 0;
						//ИначеЕсли ТипЗнч(ПервыйТип) =  Тип("Дата") Тогда
						//	ПолеНастройки.Значение = '00010101';
						//ИначеЕсли ТипЗнч(ПервыйТип) =  Тип("Булево") Тогда
						//Иначе
						//	ПолеНастройки.Значение = Новый(ПервыйТип);
						//КонецЕсли;
						ПолеНастройки.Значение = ОбщегоНазначения.ПустоеЗначениеТипа(ПервыйТип);
					КонецЕсли;
				КонецЕсли;
			Иначе
				ПолеНастройки.ВыбиратьТип=Истина;
			КонецЕсли;
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры // ПолеВидаСравнения1ПриИзменении()

Процедура ПередСохранениемЗначений(Отказ)
	
	СохраненныеНастройки = Новый Структура;
	
	СохраненныеНастройки.Вставить("ФлажокНастройкиАнкета",		ЭлементыФормы.ФлажокНастройкиАнкета.Значение);
	СохраненныеНастройки.Вставить("ПолеВидаСравненияАнкета",	ЭлементыФормы.ПолеВидаСравненияАнкета.Значение);
	СохраненныеНастройки.Вставить("ПолеНастройкиАнкета",		ЭлементыФормы.ПолеНастройкиАнкета.Значение);
	
	СохраненныеНастройки.Вставить("ФлажокНастройкиРаздел",		ЭлементыФормы.ФлажокНастройкиРаздел.Значение);
	СохраненныеНастройки.Вставить("ПолеВидаСравненияРаздел",	ЭлементыФормы.ПолеВидаСравненияРаздел.Значение);
	СохраненныеНастройки.Вставить("ПолеНастройкиРаздел",		ЭлементыФормы.ПолеНастройкиРаздел.Значение);
	
	СохраненныеНастройки.Вставить("ФлажокНастройкиОпрос",		ЭлементыФормы.ФлажокНастройкиОпрос.Значение);
	СохраненныеНастройки.Вставить("ПолеВидаСравненияОпрос",		ЭлементыФормы.ПолеВидаСравненияОпрос.Значение);
	СохраненныеНастройки.Вставить("ПолеНастройкиОпрос",			ЭлементыФормы.ПолеНастройкиОпрос.Значение);
	
КонецПроцедуры 

Процедура ПослеВосстановленияЗначений()
	
	Если ТипЗнч(СохраненныеНастройки) = Тип("Структура") Тогда

		ЭлементыФормы.ФлажокНастройкиАнкета.Значение	= СохраненныеНастройки.ФлажокНастройкиАнкета;
		ЭлементыФормы.ПолеВидаСравненияАнкета.Значение	= СохраненныеНастройки.ПолеВидаСравненияАнкета;
		ЭлементыФормы.ПолеНастройкиАнкета.Значение		= СохраненныеНастройки.ПолеНастройкиАнкета;
		
		ЭлементыФормы.ФлажокНастройкиРаздел.Значение	= СохраненныеНастройки.ФлажокНастройкиРаздел;
		ЭлементыФормы.ПолеВидаСравненияРаздел.Значение	= СохраненныеНастройки.ПолеВидаСравненияРаздел;
		ЭлементыФормы.ПолеНастройкиРаздел.Значение		= СохраненныеНастройки.ПолеНастройкиРаздел;
		
		ЭлементыФормы.ФлажокНастройкиОпрос.Значение	= СохраненныеНастройки.ФлажокНастройкиОпрос;
		ЭлементыФормы.ПолеВидаСравненияОпрос.Значение	= СохраненныеНастройки.ПолеВидаСравненияОпрос;
		ЭлементыФормы.ПолеНастройкиОпрос.Значение		= СохраненныеНастройки.ПолеНастройкиОпрос;
		
	КонецЕсли; 
	
КонецПроцедуры

// Обработчик события элемента КоманднаяПанельФормы.НовыйОтчет.
//
Процедура КоманднаяПанельФормыНовыйОтчет(Кнопка)
	
	Если Строка(ЭтотОбъект) = "ВнешняяОбработкаОбъект." + ЭтотОбъект.Метаданные().Имя Тогда
			
		Предупреждение(НСтр("ru='Данный отчет является внешней обработкой.';uk='Даний звіт є зовнішньою обробкою.'") + Символы.ПС + НСтр("ru='Открытие нового отчета возможно только для объектов конфигурации.';uk=""Відкриття нового звіту можливо тільки для об'єктів конфігурації."""));
		Возврат;
			
	Иначе
			
		НовыйОтчет = Отчеты[ЭтотОбъект.Метаданные().Имя].Создать();
			
	КонецЕсли;
	
	ФормаНовогоОтчета = НовыйОтчет.ПолучитьФорму();
	ФормаНовогоОтчета.Открыть();

КонецПроцедуры // КоманднаяПанельФормыДействиеНовыйОтчет()

ЭлементыФормы.ПолеВидаСравненияАнкета.СписокВыбора 	= УправлениеОтчетами.ПолучитьСписокВидовСравненияПоТипу(ЭлементыФормы.ПолеНастройкиАнкета.ТипЗначения);
ЭлементыФормы.ПолеВидаСравненияРаздел.СписокВыбора 	= УправлениеОтчетами.ПолучитьСписокВидовСравненияПоТипу(ЭлементыФормы.ПолеНастройкиРаздел.ТипЗначения);
ЭлементыФормы.ПолеВидаСравненияОпрос.СписокВыбора 	= УправлениеОтчетами.ПолучитьСписокВидовСравненияПоТипу(ЭлементыФормы.ПолеНастройкиОпрос.ТипЗначения);
ЭлементыФормы.ПолеВидаСравненияАнкета.Значение = ЭлементыФормы.ПолеВидаСравненияАнкета.СписокВыбора[0].Значение;
ЭлементыФормы.ПолеВидаСравненияРаздел.Значение = ЭлементыФормы.ПолеВидаСравненияРаздел.СписокВыбора[0].Значение;
ЭлементыФормы.ПолеВидаСравненияОпрос.Значение  = ЭлементыФормы.ПолеВидаСравненияОпрос.СписокВыбора[0].Значение;
ПолеВидаСравнения1ПриИзменении(ЭлементыФормы.ПолеВидаСравненияАнкета);
ПолеВидаСравнения1ПриИзменении(ЭлементыФормы.ПолеВидаСравненияРаздел);
ПолеВидаСравнения1ПриИзменении(ЭлементыФормы.ПолеВидаСравненияОпрос);
ЭлементыФормы.ФлажокНастройкиАнкета.Значение = Истина;
