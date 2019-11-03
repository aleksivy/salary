﻿#Если Клиент Тогда

// Функция формирует основной запрос по сбору данных для расчетной ведомости.
//
// Параметры
//
// Возвращаемое значение:
//   РезультатЗапроса   – результат запроса.
//
Функция СформироватьЗапрос()
	
	ОтборРаботника     = (ТипЗнч(СохраненныеНастройки) = Тип("Структура"));
	ОтборОрганизации   = ОтборРаботника;
	ОтборПодразделения = ОтборРаботника;
	
	Если ОтборРаботника Тогда
		
		ОтборОрганизации		  = СохраненныеНастройки.ФлажокНастройкиОрганизация;
		ВидСравненияОрганизации	  = СохраненныеНастройки.ПолеВидаСравненияОрганизация;
		Организация				  = СохраненныеНастройки.ПолеНастройкиОрганизация;
		ОтборПодразделения		  = СохраненныеНастройки.ФлажокНастройкиПодразделение;
		ВидСравненияПодразделения = СохраненныеНастройки.ПолеВидаСравненияПодразделение;
		Подразделение			  = СохраненныеНастройки.ПолеНастройкиПодразделение;
		ОтборРаботника			  = СохраненныеНастройки.ФлажокНастройкиРаботник;
		ВидСравненияРаботника	  = СохраненныеНастройки.ПолеВидаСравненияРаботник;
		Работник				  = СохраненныеНастройки.ПолеНастройкиРаботник;
		
	КонецЕсли;
	
	НачПериода = НачалоМесяца(Период);
	КонПериода = КонецМесяца(Период);
	
	Запрос = Новый Запрос;
	
	Если ОтборОрганизации Тогда
		
		Запрос.УстановитьПараметр("ПарамОрганизация", Организация);
		ВидСравненияОрганизация = УправлениеОтчетами.ПолучитьВидСравненияСтрокой(ВидСравненияОрганизации)
		
	КонецЕсли;  
	
	Если ОтборПодразделения Тогда
		
		Запрос.УстановитьПараметр("ПарамПодразделение", Подразделение);
		ВидСравненияПодразделение = УправлениеОтчетами.ПолучитьВидСравненияСтрокой(ВидСравненияПодразделения)
		
	КонецЕсли;  
	
	Если ОтборРаботника Тогда
		
		Запрос.УстановитьПараметр("ПарамФизЛицо", Работник);
	    ВидСравненияРаботник = УправлениеОтчетами.ПолучитьВидСравненияСтрокой(ВидСравненияРаботника)
		
	Иначе
		//Определение списка работников, попадающих в отчетный период
		
		ЗапросФЗ       = Новый Запрос;
		ЗапросФЗ.УстановитьПараметр("НачПериода",      НачПериода);
		ЗапросФЗ.УстановитьПараметр("КонПериода",      КонПериода);
		ЗапросФЗ.УстановитьПараметр("Увольнение", Перечисления.ПричиныИзмененияСостояния.Увольнение);
		
		МассивВидЗанятости = Новый Массив(2);
		МассивВидЗанятости[0] = Перечисления.ВидыЗанятостиВОрганизации.ОсновноеМестоРаботы;
		МассивВидЗанятости[1] = Перечисления.ВидыЗанятостиВОрганизации.Совместительство;
		ЗапросФЗ.УстановитьПараметр("ПарамОсновнойСотрудник", МассивВидЗанятости);
		
		ЗапросФЗ.УстановитьПараметр("ПарамОрганизация",   Организация);
		ЗапросФЗ.УстановитьПараметр("ПарамПодразделение", Подразделение);
		
		ЗапросФЗ.Текст ="
						|ВЫБРАТЬ РАЗЛИЧНЫЕ РАЗРЕШЕННЫЕ
						|	РаботникиОрганизаций.Сотрудник.ФизЛицо КАК ФизЛицо
		                |ИЗ
		                |	РегистрСведений.РаботникиОрганизаций.СрезПоследних(&КонПериода,
						|	"  + ?(ОтборОрганизации, " Организация " + ВидСравненияОрганизация + " (&ПарамОрганизация)", "") + "
						|		)КАК РаботникиОрганизаций
		                |
		                |ГДЕ РаботникиОрганизаций.ПричинаИзмененияСостояния <> &Увольнение  
						|	" + ?(ОтборПодразделения, " И РаботникиОрганизаций.ПодразделениеОрганизации "	+ ВидСравненияПодразделение + " (&ПарамПодразделение)", "") + "	
		                |
						|ОБЪЕДИНИТЬ
						|ВЫБРАТЬ РАЗЛИЧНЫЕ
						|	РаботникиОрганизаций.Сотрудник.ФизЛицо КАК ФизЛицо
		                |
		                |ИЗ	РегистрСведений.РаботникиОрганизаций КАК РаботникиОрганизаций
		                |
		                |ГДЕ	НАЧАЛОПЕРИОДА( РаботникиОрганизаций.Период, МЕСЯЦ ) = &НачПериода
						|		И РаботникиОрганизаций.ПричинаИзмененияСостояния = &Увольнение
		                |	" + ?(ОтборОрганизации, " И РаботникиОрганизаций.Организация " + ВидСравненияОрганизация + " (&ПарамОрганизация)", "") + "
		                |   " + ?(ОтборПодразделения, " И РаботникиОрганизаций.ПодразделениеОрганизации " + ВидСравненияПодразделение + " (&ПарамПодразделение)", "")+ "	
						|"; 
										
		Запрос.УстановитьПараметр("ПарамФизЛицо", ЗапросФЗ.Выполнить().Выгрузить().ВыгрузитьКолонку("ФизЛицо"));
		ВидСравненияРаботник = "В";
		
	КонецЕсли;
	
	Запрос.УстановитьПараметр("НачПериода",             НачПериода);
	Запрос.УстановитьПараметр("КонПериода",             КонПериода);
	Запрос.УстановитьПараметр("СледующийМесяц",         КонПериода + 1);
	Запрос.УстановитьПараметр("ВидДвиженияПриход",      ВидДвиженияНакопления.Приход);
	СписокСчетаЗарплата = Новый СписокЗначений;
	СписокСчетаЗарплата.Добавить(ПланыСчетов.Хозрасчетный.РасчетыПоЗаработнойПлате);//661
	СписокСчетаЗарплата.Добавить(ПланыСчетов.Хозрасчетный.РасчетыПоДругимВыплатам); //663
	Запрос.УстановитьПараметр("СчетаЗарплата", СписокСчетаЗарплата);
	
	МассивВыплат = Новый Массив(2);
	МассивВыплат[0] = Перечисления.КодыОперацийВзаиморасчетыСРаботникамиОрганизаций.Выплата;
	Запрос.УстановитьПараметр("ПарамВыплаты",      МассивВыплат);
	Запрос.УстановитьПараметр("ПарамАванс",        Перечисления.ХарактерВыплатыЗарплаты.Аванс);
	Запрос.УстановитьПараметр("Расчет",		      Перечисления.ХарактерВыплатыЗарплаты.Зарплата);
	Запрос.УстановитьПараметр("ХарактерНеУказан", Перечисления.ХарактерВыплатыЗарплаты.ПустаяСсылка());
		
	МассивОсновнойСотрудник = Новый Массив(2);
	МассивОсновнойСотрудник[0] = Перечисления.ВидыЗанятостиВОрганизации.ОсновноеМестоРаботы;
	МассивОсновнойСотрудник[1] = Перечисления.ВидыЗанятостиВОрганизации.Совместительство;
	Запрос.УстановитьПараметр("ПарамОсновнойСотрудник", МассивОсновнойСотрудник);
	
	Запрос.УстановитьПараметр("ПарамСпособРасчетаВзносыВФонды", Перечисления.СпособыРасчетаОплатыТруда.Взносы);
	
	// Основные начисления
	ОсновныеНачисления = ПланыВидовРасчета.ОсновныеНачисленияОрганизаций;
	
	МассивНаряды = Новый Массив;
	МассивНаряды.Добавить(ОсновныеНачисления.СдельнаяОплата);
	Запрос.УстановитьПараметр("ПарамНаряды", МассивНаряды);
	
	МассивПочасово = Новый Массив;
	МассивПочасово.Добавить(ОсновныеНачисления.ОкладПоЧасам);
	МассивПочасово.Добавить(ОсновныеНачисления.ТарифЧасовой);
	МассивПочасово.Добавить(ОсновныеНачисления.ОкладПоДням);
	МассивПочасово.Добавить(ОсновныеНачисления.ТарифДневной);
	МассивПочасово.Добавить(ОсновныеНачисления.ОплатаПоСреднему);
	МассивПочасово.Добавить(ОсновныеНачисления.ТарифЧасовой);
	Запрос.УстановитьПараметр("ПарамПочасово", МассивПочасово);
	
	МассивНочь = Новый Массив;
	МассивНочь.Добавить(ОсновныеНачисления.ДоплатаЗаНочныеЧасы);
	МассивНочь.Добавить(ОсновныеНачисления.ДоплатаЗаВечерниеЧасы);
	Запрос.УстановитьПараметр("ПарамНочь", МассивНочь);
	
	МассивСверхурочные = Новый Массив;
	МассивСверхурочные.Добавить(ОсновныеНачисления.ДоплатаЗаПраздничныеИВыходные);
	МассивСверхурочные.Добавить(ОсновныеНачисления.ОплатаСверхурочных);
	Запрос.УстановитьПараметр("ПарамСверхурочные", МассивСверхурочные);
	
	МассивПростои = Новый Массив;
	МассивПростои.Добавить(ОсновныеНачисления.Простой);
	МассивПростои.Добавить(ОсновныеНачисления.ПростойПоСредней);
	МассивПростои.Добавить(ОсновныеНачисления.ПочасовойПростой);
	МассивПростои.Добавить(ОсновныеНачисления.ПочасовойПростойПоСредней);
	Запрос.УстановитьПараметр("ПарамПростои", МассивПростои);
	
	МассивОтпуск = Новый Массив;
	МассивОтпуск.Добавить(ОсновныеНачисления.ОплатаПоСреднемуОтп);
	МассивОтпуск.Добавить(ОсновныеНачисления.ОтпускПоБеременностиИРодам);
	Запрос.УстановитьПараметр("ПарамОтпуск", МассивОтпуск);
	
	МассивБольничный = Новый Массив;
	МассивБольничный.Добавить(ОсновныеНачисления.ОплатаБЛПоТравмеНаПроизводстве);
	МассивБольничный.Добавить(ОсновныеНачисления.ОплатаПоСреднемуБЛ);
	МассивБольничный.Добавить(ОсновныеНачисления.ОплатаПоСреднемуБЛОрганизации);
	Запрос.УстановитьПараметр("ПарамБольничный", МассивБольничный);
	
	// Дополнительные начисления
	ОсновныеНачисления = ПланыВидовРасчета.ОсновныеНачисленияОрганизаций;
	                                           
	МассивПремии = Новый Массив;
	МассивПремии.Добавить(ОсновныеНачисления.Квартальная);
	МассивПремии.Добавить(ОсновныеНачисления.Месячная);
	МассивПремии.Добавить(ОсновныеНачисления.Годовая);
	Запрос.УстановитьПараметр("ПарамПремии", МассивПремии);
	
	МассивКомпенсацияЗаОтпуск = Новый Массив;
	МассивКомпенсацияЗаОтпуск.Добавить(ОсновныеНачисления.КомпенсацияОтпуска);
	Запрос.УстановитьПараметр("ПарамКомпенсацияЗаОтпуск", МассивКомпенсацияЗаОтпуск);
	
	// Удержания
	Удержания = ПланыВидовРасчета.УдержанияОрганизаций;
	
	МассивИсполнительныеЛисты = Новый Массив;
	МассивИсполнительныеЛисты.Добавить(Удержания.АлиментыПроцентом);
	МассивИсполнительныеЛисты.Добавить(Удержания.АлиментыПроцентомДоПредела);
	МассивИсполнительныеЛисты.Добавить(Удержания.АлиментыФиксированнойСуммой);
	МассивИсполнительныеЛисты.Добавить(Удержания.АлиментыФиксированнойСуммойДоПредела);
	МассивИсполнительныеЛисты.Добавить(Удержания.ИЛПроцентом);
	МассивИсполнительныеЛисты.Добавить(Удержания.ИЛПроцентомДоПредела);
	МассивИсполнительныеЛисты.Добавить(Удержания.ИЛФиксированнойСуммой);
	МассивИсполнительныеЛисты.Добавить(Удержания.ИЛФиксированнойСуммойДоПредела);
	Запрос.УстановитьПараметр("ПарамИсполнительныеЛисты", МассивИсполнительныеЛисты);
	
	Запрос.Текст = 
	"ВЫБРАТЬ РАЗРЕШЕННЫЕ
	|	РаботникиОрганизаций.Организация                           КАК Организация,
	|	ВЫРАЗИТЬ(РаботникиОрганизаций.Организация.НаименованиеПолное
	|	                              КАК СТРОКА(1000))            КАК ОрганизацияНаименованиеПолное,
	|	РаботникиОрганизаций.ПодразделениеОрганизации              КАК ПодразделениеОрганизации,
	|	РаботникиОрганизаций.ПодразделениеОрганизации.Наименование КАК ПодразделениеНаименование,
	|	РаботникиОрганизаций.Сотрудник                             КАК Сотрудник,
	|	РаботникиОрганизаций.Сотрудник.ФизЛицо                     КАК ФизЛицо,
	|	РаботникиОрганизаций.Сотрудник.ФизЛицо.Наименование        КАК ФИО,
	|	РаботникиОрганизаций.Сотрудник.Код	                       КАК ТабельныйНомер,
	|	ОсновныеНачисления.ДоплатыНаряды                           КАК ДоплатыНаряды,
	|	ОсновныеНачисления.ДоплатыПочасово                         КАК ДоплатыПочасово,
	|	ОсновныеНачисления.ДоплатыЗаНочь                           КАК ДоплатыЗаНочь,
	|	ОсновныеНачисления.ДоплатыЗаСверхурочные                   КАК ДоплатыЗаСверхурочные,
	|	ОсновныеНачисления.ДоплатыЗаПростои                        КАК ДоплатыЗаПростои,
	|	ОсновныеНачисления.ДоплатыЗаОтпуск                         КАК ДоплатыЗаОтпуск,
	|	ОсновныеНачисления.ДоплатыЗаОтпускСледующий                КАК ДоплатыЗаОтпускСледующий,
	|	ОсновныеНачисления.БольничныйДни                           КАК БольничныйДни,
	|	ОсновныеНачисления.ДоплатыЗаБольничный                     КАК ДоплатыЗаБольничный,
	|	ОсновныеНачисления.ДоплатыВсегоОсновныеНачисления          КАК ДоплатыВсегоОсновныеНачисления,
	|	ОсновныеНачисления.ДоплатыПремии                     КАК ДоплатыПремии,
	|	ОсновныеНачисления.ДоплатыКомпенсацияОтпуска         КАК ДоплатыКомпенсацияОтпуска,
	|	0        КАК ДоплатыВсегоДополнительные,// надо удалить
	|	Взаиморасчеты.УдержаноАванс                                КАК УдержаноАванс,
	|	Взаиморасчеты.УдержаноМежрасчетные                         КАК УдержаноМежрасчетные,
	|	Взаиморасчеты.ВсегоВыплаты                                 КАК ВсегоВыплаты,
	|	ВзаиморасчетыПоНДФЛ.УдержаноНДФЛ                           КАК УдержаноНДФЛ,
	|	ВзаиморасчетыПоНДФЛ.УдержаноНДФЛСледующий                  КАК УдержаноНДФЛСледующий,
	|	ВзаиморасчетыПоНДФЛ.УдержаноВсегоНДФЛ                      КАК УдержаноВсегоНДФЛ,
	|	ВзносыВФонды.УдержаноВсегоФонды                            КАК УдержаноВсегоФонды,
	|	Удержания.УдержаноПоИсполнительнымЛистам                   КАК УдержаноПоИсполнительнымЛистам,
	|	Удержания.УдержаноВсегоУдержания                           КАК УдержаноВсегоУдержания,
	|	ОтветственныеЛицаДиректор.ФизическоеЛицо.Наименование КАК Директор,
	|	ОтветственныеЛицаГлБух.ФизическоеЛицо.Наименование	  КАК ГлБух
	|ИЗ
	|	РегистрСведений.РаботникиОрганизаций.СрезПоследних(&КонПериода,
	|	                Сотрудник.ВидЗанятости В (&ПарамОсновнойСотрудник) И
	|	                Сотрудник.ФизЛицо " + ВидСравненияРаботник + " (&ПарамФизЛицо)"
	                    + ?(ОтборОрганизации, " И Организация " + ВидСравненияОрганизация 
						+ "(&ПарамОрганизация)", "") + ?(ОтборПодразделения, 
						" И ПодразделениеОрганизации " + ВидСравненияПодразделение
						+ " (&ПарамПодразделение)", "") + "
	|					) КАК РаботникиОрганизаций
	|		ЛЕВОЕ СОЕДИНЕНИЕ
	|		(ВЫБРАТЬ
	|			ОсновныеНачисления.Организация КАК Организация,
	|			ОсновныеНачисления.Сотрудник     КАК Сотрудник,
	|			ОсновныеНачисления.Сотрудник.ФизЛицо     КАК ФизЛицо,
	|			СУММА(ВЫБОР 
	|			      	КОГДА ОсновныеНачисления.ВидРасчета В (&ПарамНаряды) 
	|			      		ТОГДА ОсновныеНачисления.Результат 
	|			      	ИНАЧЕ 0 
	|			      КОНЕЦ) КАК ДоплатыНаряды,
	|			СУММА(ВЫБОР 
	|			      	КОГДА ОсновныеНачисления.ВидРасчета В (&ПарамПочасово) 
	|			      		ТОГДА ОсновныеНачисления.Результат 
	|			      	ИНАЧЕ 0 
	|			      КОНЕЦ) КАК ДоплатыПочасово,
	|			СУММА(ВЫБОР 
	|			      	КОГДА ОсновныеНачисления.ВидРасчета В (&ПарамНочь) 
	|			      		ТОГДА ОсновныеНачисления.Результат 
	|			      	ИНАЧЕ 0 
	|			      КОНЕЦ) КАК ДоплатыЗаНочь,
	|			СУММА(ВЫБОР 
	|			      	КОГДА ОсновныеНачисления.ВидРасчета В (&ПарамСверхурочные) 
	|			      		ТОГДА ОсновныеНачисления.Результат 
	|			      	ИНАЧЕ 0 
	|			      КОНЕЦ) КАК ДоплатыЗаСверхурочные,
	|			СУММА(ВЫБОР 
	|			      	КОГДА ОсновныеНачисления.ВидРасчета В (&ПарамПростои) 
	|			      		ТОГДА ОсновныеНачисления.Результат 
	|			      	ИНАЧЕ 0 
	|			      КОНЕЦ) КАК ДоплатыЗаПростои,
	|			СУММА(ВЫБОР 
	|			      	КОГДА ОсновныеНачисления.ВидРасчета В (&ПарамОтпуск) И
	|			      	      ОсновныеНачисления.ПериодДействия = &НачПериода 
	|			      		ТОГДА ОсновныеНачисления.Результат 
	|			      	ИНАЧЕ 0 
	|			      КОНЕЦ) КАК ДоплатыЗаОтпуск,
	|			СУММА(ВЫБОР 
	|			      	КОГДА ОсновныеНачисления.ВидРасчета В (&ПарамОтпуск) И
	|			      	      ОсновныеНачисления.ПериодДействия = &СледующийМесяц 
	|			      		ТОГДА ОсновныеНачисления.Результат 
	|			      	ИНАЧЕ 0 
	|			      КОНЕЦ) КАК ДоплатыЗаОтпускСледующий,
	|			СУММА(ВЫБОР 
	|			      	КОГДА ОсновныеНачисления.ВидРасчета В (&ПарамБольничный) 
	|			      		ТОГДА ОсновныеНачисления.НормаДней 
	|			      	ИНАЧЕ 0 
	|			      КОНЕЦ) КАК БольничныйДни,
	|			СУММА(ВЫБОР 
	|			      	КОГДА ОсновныеНачисления.ВидРасчета В (&ПарамБольничный) 
	|			      		ТОГДА ОсновныеНачисления.Результат 
	|			      	ИНАЧЕ 0 
	|			      КОНЕЦ) КАК ДоплатыЗаБольничный,
	|			СУММА(ВЫБОР 
	|		          	КОГДА ОсновныеНачисления.ВидРасчета В (&ПарамПремии) 
	|		          		ТОГДА ОсновныеНачисления.Результат 
	|		          	ИНАЧЕ 0 
	|		          КОНЕЦ) КАК ДоплатыПремии,
	|			СУММА(ВЫБОР 
	|		          	КОГДА ОсновныеНачисления.ВидРасчета В (&ПарамКомпенсацияЗаОтпуск) 
	|		          	ТОГДА ОсновныеНачисления.Результат 
	|		          	ИНАЧЕ 0 
	|		          КОНЕЦ) КАК ДоплатыКомпенсацияОтпуска,
	|			СУММА(ОсновныеНачисления.Результат) КАК ДоплатыВсегоОсновныеНачисления
	|		ИЗ
	|			РегистрРасчета.ОсновныеНачисленияРаботниковОрганизаций КАК ОсновныеНачисления
	|		
	|		ГДЕ
	|			ОсновныеНачисления.ПериодРегистрации = &НачПериода И
	|			ОсновныеНачисления.ВидРасчета.СчетУчета в (&СчетаЗарплата) И
	|			ОсновныеНачисления.Сотрудник.ФизЛицо " + ВидСравненияРаботник + " (&ПарамФизЛицо)" 
	            + ?(ОтборОрганизации, " И ОсновныеНачисления.Организация "
				+ ВидСравненияОрганизация + " (&ПарамОрганизация)", "") + "
	|		
	|		СГРУППИРОВАТЬ ПО
	|			ОсновныеНачисления.Организация,
	|			ОсновныеНачисления.Сотрудник) КАК ОсновныеНачисления
	|		ПО РаботникиОрганизаций.Сотрудник     = ОсновныеНачисления.Сотрудник И
	|		   РаботникиОрганизаций.Организация = ОсновныеНачисления.Организация
	|		ЛЕВОЕ СОЕДИНЕНИЕ 
	|		(ВЫБРАТЬ
	|			Взаиморасчеты.Организация КАК Организация,
	|			Взаиморасчеты.Сотрудник   КАК Сотрудник,
	|			СУММА(ВЫБОР 
	|		          	КОГДА Взаиморасчеты.ХарактерВыплаты = &ПарамАванс 
	|		          		ТОГДА Взаиморасчеты.СуммаВзаиморасчетов 
	|		          	ИНАЧЕ 0 
	|		          КОНЕЦ) КАК УдержаноАванс,
	|			СУММА(ВЫБОР 
	|		          	КОГДА (Взаиморасчеты.ХарактерВыплаты <> &ПарамАванс
	|                          И Взаиморасчеты.ХарактерВыплаты <> &Расчет
	|                          И Взаиморасчеты.ХарактерВыплаты <> &ХарактерНеУказан)
	|		          		ТОГДА Взаиморасчеты.СуммаВзаиморасчетов 
	|		          	ИНАЧЕ 0 
	|		          КОНЕЦ) КАК УдержаноМежрасчетные,
	|			СУММА(Взаиморасчеты.СуммаВзаиморасчетов) КАК ВсегоВыплаты
	|		ИЗ
	|			РегистрНакопления.ВзаиморасчетыСРаботникамиОрганизаций КАК Взаиморасчеты
	|		
	|		ГДЕ
	|			Взаиморасчеты.Период МЕЖДУ &НачПериода И &КонПериода И
	|			Взаиморасчеты.КодОперации В(&ПарамВыплаты) И
	|			Взаиморасчеты.Сотрудник.ФизЛицо " + ВидСравненияРаботник + " (&ПарамФизЛицо)"
				+ ?(ОтборОрганизации, " И Взаиморасчеты.Организация "
				+ ВидСравненияОрганизация + " (&ПарамОрганизация)", "") + "
	|		                                                     
	|		СГРУППИРОВАТЬ ПО
	|			Взаиморасчеты.Организация,
	|			Взаиморасчеты.Сотрудник) КАК Взаиморасчеты
	|		ПО РаботникиОрганизаций.Сотрудник     = Взаиморасчеты.Сотрудник И
	|		   РаботникиОрганизаций.Организация = Взаиморасчеты.Организация
	|		ЛЕВОЕ СОЕДИНЕНИЕ 
	|		(ВЫБРАТЬ
	|			Удержания.Организация КАК Организация,
	|			Удержания.Сотрудник     КАК Сотрудник,
	|			СУММА(ВЫБОР 
	|		          	КОГДА Удержания.ВидРасчета В (&ПарамИсполнительныеЛисты) 
	|		          		ТОГДА Удержания.Результат 
	|		          	ИНАЧЕ 0
	|		          КОНЕЦ) КАК УдержаноПоИсполнительнымЛистам,
	|			СУММА(Удержания.Результат) КАК УдержаноВсегоУдержания
	|		ИЗ
	|			РегистрРасчета.УдержанияРаботниковОрганизаций КАК Удержания
	|		
	|		ГДЕ
	|			Удержания.ПериодРегистрации            = &НачПериода И
	|			Удержания.Сотрудник.ФизЛицо " + ВидСравненияРаботник + " (&ПарамФизЛицо)"
				+ ?(ОтборОрганизации, " И Удержания.Организация "
				+ ВидСравненияОрганизация + " (&ПарамОрганизация)", "") + "
	|		
	|		СГРУППИРОВАТЬ ПО
	|			Удержания.Организация,
	|			Удержания.Сотрудник) КАК Удержания
	|		ПО РаботникиОрганизаций.Сотрудник     = Удержания.Сотрудник И
	|		   РаботникиОрганизаций.Организация = Удержания.Организация
	|		ЛЕВОЕ СОЕДИНЕНИЕ 
	|		(ВЫБРАТЬ
	|			ВзносыВФонды.Организация КАК Организация,
	|			ВзносыВФонды.Сотрудник     КАК Сотрудник,
	|			СУММА(ВзносыВФонды.Результат) КАК УдержаноВсегоФонды
	|		ИЗ
	|			РегистрРасчета.ВзносыВФонды КАК ВзносыВФонды
	|		
	|		ГДЕ
	|			ВзносыВФонды.ПериодРегистрации        = &НачПериода И
	|			ВзносыВФонды.ВидРасчета.СпособРасчета = &ПарамСпособРасчетаВзносыВФонды И
	|			ВзносыВФонды.Сотрудник.ФизЛицо " + ВидСравненияРаботник + " (&ПарамФизЛицо)"
				+ ?(ОтборОрганизации, " И ВзносыВФонды.Организация "
				+ ВидСравненияОрганизация + " (&ПарамОрганизация)", "") + "
	|		
	|		СГРУППИРОВАТЬ ПО
	|			ВзносыВФонды.Организация,
	|			ВзносыВФонды.Сотрудник) КАК ВзносыВФонды
	|		ПО РаботникиОрганизаций.Сотрудник     = ВзносыВФонды.Сотрудник И
	|		   РаботникиОрганизаций.Организация = ВзносыВФонды.Организация
	|	ЛЕВОЕ СОЕДИНЕНИЕ
	|		РегистрСведений.ОтветственныеЛицаОрганизаций.СрезПоследних(&КонПериода) КАК ОтветственныеЛицаДиректор
	|	ПО
	|		РаботникиОрганизаций.ПодразделениеОрганизации = ОтветственныеЛицаДиректор.СтруктурнаяЕдиница
	|		И ОтветственныеЛицаДиректор.ОтветственноеЛицо = Значение(Перечисление.ОтветственныеЛицаОрганизаций.Руководитель)
	|	ЛЕВОЕ СОЕДИНЕНИЕ
	|		РегистрСведений.ОтветственныеЛицаОрганизаций.СрезПоследних(&КонПериода) КАК ОтветственныеЛицаГлБух
	|	ПО
	|		РаботникиОрганизаций.ПодразделениеОрганизации = ОтветственныеЛицаГлБух.СтруктурнаяЕдиница
	|		И ОтветственныеЛицаГлБух.ОтветственноеЛицо = Значение(Перечисление.ОтветственныеЛицаОрганизаций.ГлавныйБухгалтер)	
	|
	|		ЛЕВОЕ СОЕДИНЕНИЕ 
	|		(ВЫБРАТЬ
	|			ВзаиморасчетыПоНДФЛ.Организация КАК Организация,
	|			ВзаиморасчетыПоНДФЛ.Сотрудник     КАК Сотрудник,
	|			СУММА(ВЫБОР 
	|		          	КОГДА ВзаиморасчетыПоНДФЛ.НалоговыйПериод = &НачПериода 
	|		          		ТОГДА ВзаиморасчетыПоНДФЛ.Налог 
	|		          	ИНАЧЕ 0 
	|		          КОНЕЦ) КАК УдержаноНДФЛ,
	|			СУММА(ВЫБОР 
	|		          	КОГДА ВзаиморасчетыПоНДФЛ.НалоговыйПериод = &СледующийМесяц 
	|		          		ТОГДА ВзаиморасчетыПоНДФЛ.Налог 
	|		          	ИНАЧЕ 0 
	|		          КОНЕЦ) КАК УдержаноНДФЛСледующий,
	|			СУММА(ВзаиморасчетыПоНДФЛ.Налог) КАК УдержаноВсегоНДФЛ
	|		ИЗ
	|			РегистрНакопления.ВзаиморасчетыПоНДФЛ КАК ВзаиморасчетыПоНДФЛ
	|		
	|		ГДЕ
	|			ВзаиморасчетыПоНДФЛ.Период МЕЖДУ &НачПериода И &КонПериода И
	|			ВзаиморасчетыПоНДФЛ.ВидДвижения = &ВидДвиженияПриход И
	|			ВзаиморасчетыПоНДФЛ.ДоходНДФЛ <> ЗНАЧЕНИЕ(Справочник.ВидыДоходовНДФЛ.Код12) И
	|			ВзаиморасчетыПоНДФЛ.Сотрудник.ФизЛицо " + ВидСравненияРаботник + " (&ПарамФизЛицо)"
				+ ?(ОтборОрганизации, " И ВзаиморасчетыПоНДФЛ.Организация "
				+ ВидСравненияОрганизация + " (&ПарамОрганизация)", "") + "
	|		
	|		СГРУППИРОВАТЬ ПО
	|			ВзаиморасчетыПоНДФЛ.Организация,
	|			ВзаиморасчетыПоНДФЛ.Сотрудник) КАК ВзаиморасчетыПоНДФЛ
	|		ПО РаботникиОрганизаций.Сотрудник     = ВзаиморасчетыПоНДФЛ.Сотрудник И
	|		   РаботникиОрганизаций.Организация = ВзаиморасчетыПоНДФЛ.Организация
	|
	|ИТОГИ  СУММА(ДоплатыНаряды), 
	|       СУММА(ДоплатыПочасово),
	|       СУММА(ДоплатыЗаНочь),
	|       СУММА(ДоплатыЗаСверхурочные),
	|       СУММА(ДоплатыЗаПростои), 
	|       СУММА(ДоплатыЗаОтпуск), 
	|       СУММА(ДоплатыЗаОтпускСледующий), 
	|       СУММА(ДоплатыЗаБольничный), 
	|       СУММА(ДоплатыВсегоОсновныеНачисления), 
	|       СУММА(ДоплатыПремии), 
	|       СУММА(ДоплатыКомпенсацияОтпуска), 
	|       СУММА(ДоплатыВсегоДополнительные), 
	|       СУММА(УдержаноАванс), 
	|       СУММА(УдержаноМежрасчетные), 
	|       СУММА(ВсегоВыплаты), 
	|       СУММА(УдержаноНДФЛ), 
	|       СУММА(УдержаноНДФЛСледующий), 
	|       СУММА(УдержаноВсегоНДФЛ), 
	|       СУММА(УдержаноВсегоФонды), 
	|       СУММА(УдержаноПоИсполнительнымЛистам), 
	|       СУММА(УдержаноВсегоУдержания),
	|		МАКСИМУМ(Директор),
	|		МАКСИМУМ(ГлБух)
	|   ПО
	|	Организация,
	|	ПодразделениеОрганизации
	|
	|АВТОУПОРЯДОЧИВАНИЕ";
	
	Возврат Запрос.Выполнить();
	
КонецФункции

// Процедура заполняет параметры области 
// табличного документа по строке выборки.
// Вызывается из процедуры СформироватьОтчет
Процедура ЗаполнитьПараметры(Параметры, Выборка)
	
	
	Параметры.Заполнить(Выборка);
	
	ДоплатыЗаОтпуск           = ОбщегоНазначения.ПреобразоватьВЧисло(Выборка.ДоплатыЗаОтпуск)
	                            + ОбщегоНазначения.ПреобразоватьВЧисло(Выборка.ДоплатыКомпенсацияОтпуска); 
	Параметры.ДоплатыЗаОтпуск = ДоплатыЗаОтпуск;
	ДоплатыВсего              = ОбщегоНазначения.ПреобразоватьВЧисло(Выборка.ДоплатыВсегоОсновныеНачисления)
	                           + ОбщегоНазначения.ПреобразоватьВЧисло(Выборка.ДоплатыВсегоДополнительные);
	Параметры.ДоплатыВсего    = ДоплатыВсего;
	Параметры.ДоплатыДругие   = ДоплатыВсего
	                            - ОбщегоНазначения.ПреобразоватьВЧисло(Выборка.ДоплатыНаряды)
	                            - ОбщегоНазначения.ПреобразоватьВЧисло(Выборка.ДоплатыПочасово)
							    - ОбщегоНазначения.ПреобразоватьВЧисло(Выборка.ДоплатыЗаНочь)
							    - ОбщегоНазначения.ПреобразоватьВЧисло(Выборка.ДоплатыЗаСверхурочные)
							    - ОбщегоНазначения.ПреобразоватьВЧисло(Выборка.ДоплатыЗаПростои)
							    - ДоплатыЗаОтпуск
							    - ОбщегоНазначения.ПреобразоватьВЧисло(Выборка.ДоплатыЗаОтпускСледующий)
							    - ОбщегоНазначения.ПреобразоватьВЧисло(Выборка.ДоплатыЗаБольничный)
							    - ОбщегоНазначения.ПреобразоватьВЧисло(Выборка.ДоплатыПремии);
	УдержаноВсего          	  = ОбщегоНазначения.ПреобразоватьВЧисло(Выборка.ВсегоВыплаты)
	                            + ОбщегоНазначения.ПреобразоватьВЧисло(Выборка.УдержаноВсегоНДФЛ)
							    + ОбщегоНазначения.ПреобразоватьВЧисло(Выборка.УдержаноВсегоФонды)
							    + ОбщегоНазначения.ПреобразоватьВЧисло(Выборка.УдержаноВсегоУдержания);
    Параметры.УдержаноВсего   = УдержаноВсего;
    Параметры.УдержаноДругие  = УдержаноВсего
	                            - ОбщегоНазначения.ПреобразоватьВЧисло(Выборка.УдержаноАванс)
	                            - ОбщегоНазначения.ПреобразоватьВЧисло(Выборка.УдержаноМежрасчетные)
	                            - ОбщегоНазначения.ПреобразоватьВЧисло(Выборка.УдержаноНДФЛ)
	                            - ОбщегоНазначения.ПреобразоватьВЧисло(Выборка.УдержаноНДФЛСледующий)
	                            - ОбщегоНазначения.ПреобразоватьВЧисло(Выборка.УдержаноПоИсполнительнымЛистам);
	Параметры.КВыплате        = ДоплатыВсего - УдержаноВсего;

КонецПроцедуры // ЗаполнитьПараметры()

Процедура СформироватьОтчет(ДокументРезультат, ПоказыватьЗаголовок = Ложь, ВысотаЗаголовка = 0, ТолькоЗаголовок = Ложь) Экспорт
	
	ДокументРезультат.Очистить(); 
	
	Макет 			  	  = ПолучитьМакет("П50");
	ОбластьШапка		  = Макет.ПолучитьОбласть("Шапка");
	ОбластьШапкаТаблицы   = Макет.ПолучитьОбласть("ШапкаТаблицы");
	ОбластьСтрока         = Макет.ПолучитьОбласть("Строка");
	ОбластьПодвал         = Макет.ПолучитьОбласть("Подвал");
	
	ПараметрыШапка  = ОбластьШапка.Параметры;
	ПараметрыСтрока = ОбластьСтрока.Параметры;
	ПараметрыПодвал = ОбластьПодвал.Параметры;
	
	ПараметрыШапка.ПериодОтчета = "за " + Формат(Период, "Л=uk_UA; ДФ='MMMM yyyy'");
	КонМесяца = КонецМесяца(Период);
	
	ОтборРаботника = (ТипЗнч(СохраненныеНастройки) = Тип("Структура"));
	
	Если ОтборРаботника Тогда
		
		ОтборРаботника = СохраненныеНастройки.ФлажокНастройкиРаботник;
		
		Если ОтборРаботника Тогда
			
			ВидСравненияРаботника	          = СохраненныеНастройки.ПолеВидаСравненияРаботник;
			Работник				          = СохраненныеНастройки.ПолеНастройкиРаботник;
			ПараметрыШапка.ОтборПоСотрудникам = "Отбор по сотрудникам: " + ВидСравненияРаботника
			                                    + " - " + Работник; 
			
		КонецЕсли;
		
	КонецЕсли;
	
	РезультатЗапроса = СформироватьЗапрос();
	
	Если РезультатЗапроса.Пустой() Тогда
	
		Сообщить(НСтр("ru='Данные не обнаружены!';uk='Дані не знайдені!'"));
	    Возврат;
		
	КонецЕсли;
	
	ВыборкаПоОрганизациям = РезультатЗапроса.Выбрать(ОбходРезультатаЗапроса.ПоГруппировкам);
	СписокПоказателей     = Новый СписокЗначений;
	СписокПоказателей.Добавить("","ФИОРук");
	СписокПоказателей.Добавить("","ФИОБух");
	СписокПоказателей.Добавить("","КодПоЕДРПОУ");
	
	Пока ВыборкаПоОрганизациям.Следующий() Цикл
		
		ПараметрыШапка.ОрганизацияНаименованиеПолное = СокрП(ВыборкаПоОрганизациям.ОрганизацияНаименованиеПолное);
		
		СведенияОбОрганизации = РегламентированнаяОтчетность.ПолучитьСведенияОбОрганизации(ВыборкаПоОрганизациям.Организация, КонМесяца, СписокПоказателей);
		КодЕДРПОУ             = СведенияОбОрганизации.КодПоЕДРПОУ;
		КодЕДРПОУ             = ФормированиеПечатныхФорм.РазбитьСтрокуНаСимволы(СокрЛП(КодЕДРПОУ), "ЕДРПОУ");
		
		Для каждого Рисунок Из ОбластьШапка.Рисунки Цикл
		
			Цифра = "";
			
			Если КодЕДРПОУ.Свойство(Рисунок.Имя, Цифра) Тогда
				
				Рисунок.Текст = Цифра;
				
			Иначе
				
				Рисунок.Текст = " ";
				
			КонецЕсли;
			
		КонецЦикла;
		
		
		ВыборкаПодразделение = ВыборкаПоОрганизациям.Выбрать(ОбходРезультатаЗапроса.ПоГруппировкам);
		
		Пока ВыборкаПодразделение.Следующий() Цикл
		
			// Разделитель строки для следующего подразделения
			Если ДокументРезультат.ВысотаТаблицы > 0 Тогда
				
				ДокументРезультат.ВывестиГоризонтальныйРазделительСтраниц()
				
			КонецЕсли;
		
			ПараметрыШапка.ПодразделениеНаименование = ВыборкаПодразделение.ПодразделениеНаименование;
			ДокументРезультат.Вывести(ОбластьШапка);
			ДокументРезультат.Вывести(ОбластьШапкаТаблицы);
		    ВыборкаФЛ = ВыборкаПодразделение.Выбрать();
			
			Пока ВыборкаФЛ.Следующий() Цикл
			
				ЗаполнитьПараметры(ПараметрыСтрока, ВыборкаФЛ);
				ПараметрыСтрока.Расшифровка = ВыборкаФЛ.ФизЛицо;
				
				Если Не ДокументРезультат.ПроверитьВывод(ОбластьСтрока) Тогда
					
					ДокументРезультат.ВывестиГоризонтальныйРазделительСтраниц();
					ДокументРезультат.Вывести(ОбластьШапкаТаблицы);
					
				КонецЕсли;
				
				ДокументРезультат.Вывести(ОбластьСтрока);
			
			КонецЦикла;
			
			ЗаполнитьПараметры(ПараметрыПодвал, ВыборкаПодразделение);			
			Если Не ДокументРезультат.ПроверитьВывод(ОбластьПодвал) Тогда
				
				ДокументРезультат.ВывестиГоризонтальныйРазделительСтраниц();
				ДокументРезультат.Вывести(ОбластьШапкаТаблицы);
				
			КонецЕсли;
			
			ДокументРезультат.Вывести(ОбластьПодвал);
		
		КонецЦикла;
		
	КонецЦикла;
	
	ДокументРезультат.ОриентацияСтраницы = ОриентацияСтраницы.Ландшафт;
	ДокументРезультат.ПолеСлева  = 5;
	ДокументРезультат.ПолеСправа = 5;
				
КонецПроцедуры	

#КонецЕсли
