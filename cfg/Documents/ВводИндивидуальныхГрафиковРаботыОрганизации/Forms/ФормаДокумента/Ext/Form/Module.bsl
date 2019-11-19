﻿////////////////////////////////////////////////////////////////////////////////
// ПЕРЕМЕННЫЕ МОДУЛЯ

// Хранит последнюю установленную дату документа - для проверки перехода документа в другой период
Перем мТекущаяДатаДокумента;

// Хранит дерево макетов печатных форм
Перем мДеревоМакетов;

// Хранит элемент управления подменю печати
Перем мПодменюПечати;

// Хранит элемент управления кнопку печать по умолчанию
Перем мПечатьПоУмолчанию;

// Хранит дерево кнопок подменю заполнение ТЧ
Перем мКнопкиЗаполненияТЧ;

// Перечисление.СпособВводаДанных.ПоДням необходима для сравнения и присвоения значений переменных
Перем СпособВводаДанныхПоДням;

// Список соответствий 1 - пн, 2 - вт,.... 7 - вс.
Перем ДниНедели;

// Хранит ссылку на головную организацию
Перем мГоловнаяОрганизация;

// Массив ЭУ видимостью которых необходимо управлять в зависимости от учетной политики по персоналу
Перем мМассивЭУ;

// Переменная хранит значение УчетВремени до его изменения в форме.
Перем СтароеЗначениеУчетаВремени;

////////////////////////////////////////////////////////////////////////////////
// ПРОЦЕДУРЫ И ФУНКЦИИ ОБЩЕГО НАЗНАЧЕНИЯ

// Процедура устанавливает подменю "Заполнить" в командных панелях ТЧ документа при необходимости
//
Процедура УстановитьКнопкиПодменюЗаполненияТЧ()
	
	мКнопкиЗаполненияТЧ = УниверсальныеМеханизмы.ПолучитьДеревоКнопокЗаполненияТабличныхЧастей(Ссылка,Новый Действие("НажатиеНаДополнительнуюКнопкуЗаполненияТЧ"));

	СоответствиеТЧ = Новый Соответствие;
	СоответствиеТЧ.Вставить(ЭлементыФормы.ГрафикРаботы,ЭлементыФормы.КоманднаяПанельГрафикРаботы.Кнопки.ПодменюЗаполнить);
	
	УниверсальныеМеханизмы.СформироватьПодменюЗаполненияТЧПоДеревуКнопок(мКнопкиЗаполненияТЧ,СоответствиеТЧ);
	
КонецПроцедуры // УстановитьКнопкиПодменюЗаполненияТЧ()

// Процедура устанавливает подменю "Печать" и кнопку "Печать по умолчанию" при необходимости
//
Процедура УстановитьКнопкиПечати()
	
	ФормированиеПечатныхФорм.СоздатьКнопкиПечати(ЭтотОбъект, ЭтаФорма);	
	
КонецПроцедуры

// Процедура заполняет своднные данные по дням, часам, вечерним и ночным, по результатам с разбивкой по дням.
Процедура ЗаполнитьСводныеДанныеГрафикаРаботы()
	Для Каждого СтрокаГрафикаРаботы Из ГрафикРаботы Цикл
		КоличествоЧасов = 0;
		КоличествоЧасовВечерних = 0;
		КоличествоЧасовНочных = 0;
		КоличествоДней = 0;
		Для ИндексДня = 1 по 31 Цикл
			
			Часов = СтрокаГрафикаРаботы["Часов"+Строка(ИндексДня)];
			ЧасовВечерних = СтрокаГрафикаРаботы["ЧасовВечерних"+Строка(ИндексДня)];
			ЧасовНочных = СтрокаГрафикаРаботы["ЧасовНочных"+Строка(ИндексДня)];
			
			КоличествоЧасов = КоличествоЧасов + Часов;
			КоличествоЧасовВечерних = КоличествоЧасовВечерних + ЧасовВечерних;
			КоличествоЧасовНочных = КоличествоЧасовНочных + ЧасовНочных;
			
			Если (Часов > 0) Или (ЧасовВечерних > 0) Или (ЧасовНочных > 0) Тогда
				КоличествоДней = КоличествоДней + 1;
			КонецЕсли;
			
		КонецЦикла;
		СтрокаГрафикаРаботы.ВсегоДней = КоличествоДней;
		СтрокаГрафикаРаботы.ВсегоЧасов = КоличествоЧасов;
		СтрокаГрафикаРаботы.ВсегоЧасовВечерних = КоличествоЧасовВечерних;
		СтрокаГрафикаРаботы.ВсегоЧасовНочных = КоличествоЧасовНочных;
	КонецЦикла;
КонецПроцедуры // ЗаполнитьСводныеДанныеГрафикаРаботы()

// Процедура надписывает колонки т.п. ГрафикРаботы в зависимости от способа ввода данных
// и количества дней в месяце.
Процедура ОформитьЗаголовкиДнейМесяца()
	
	// Устанавливаем заголовки дней месяца.
	БледноКрасныйЦвет = Новый Цвет(255, 176, 176);
	СерыйЦвет = Новый Цвет(234, 229, 216);
	Если СпособВводаДанных = СпособВводаДанныхПоДням Тогда
		
		Запрос = Новый Запрос;
		Запрос.УстановитьПараметр("НачалоМесяца",НачалоМесяца(ПериодРегистрации));
		Запрос.УстановитьПараметр("КонецМесяца",КонецМесяца(ПериодРегистрации));
		Запрос.Текст = 
		"ВЫБРАТЬ
		|	РегламентированныйПроизводственныйКалендарь.ВидДня,
		|	ДЕНЬНЕДЕЛИ(РегламентированныйПроизводственныйКалендарь.ДатаКалендаря) КАК ДеньНедели
		|ИЗ
		|	РегистрСведений.РегламентированныйПроизводственныйКалендарь КАК РегламентированныйПроизводственныйКалендарь
		|ГДЕ
		|	РегламентированныйПроизводственныйКалендарь.ДатаКалендаря МЕЖДУ &НачалоМесяца И &КонецМесяца
		|
		|УПОРЯДОЧИТЬ ПО
		|	РегламентированныйПроизводственныйКалендарь.ДатаКалендаря";
		
		Результат = Запрос.Выполнить();
		Если Результат.Пустой() Тогда
			ДеньНеделиМесяца = ДеньНедели(НачалоМесяца(ПериодРегистрации));
			Для ДеньМесяца = 1 по День(КонецМесяца(ПериодРегистрации)) Цикл
				
				Колонка = ЭлементыФормы.ГрафикРаботы.Колонки["Часов"+Строка(ДеньМесяца)];
				
				Колонка.ТекстШапки = Строка(ДеньМесяца) + Символы.ПС + ДниНедели[ДеньНеделиМесяца];
				Если ДеньНеделиМесяца = 6 Или ДеньНеделиМесяца = 7 Тогда
					Колонка.ЦветТекстаШапки = ЦветаСтиля.ЦветОсобогоТекста;
					Колонка.ШрифтШапки = ШрифтыСтиля.ШрифтВажнойНадписи;
				Иначе
					Колонка.ЦветТекстаШапки = Новый Цвет();	
					Колонка.ШрифтШапки = Новый Шрифт();
				КонецЕсли;
				
				ДеньНеделиМесяца = (ДеньНеделиМесяца%7)+1;
			КонецЦикла;
		Иначе
			Данные = Результат.Выгрузить();
			ЦветСубботы	           = Новый Цвет(153, 51,   0); // Темно-красный
			ЦветВоскресенья 	   = ЦветаСтиля.ЦветОсобогоТекста; // Красный
			ЦветПредпразничногоДня = Новый Цвет(  0,  0, 186); // Темно-синий
			ЦветПраздничногоДня	   = Новый Цвет(255,  0, 255); // Фиолетовый
			Для ДеньМесяца = 1 по День(КонецМесяца(ПериодРегистрации)) Цикл
				
				Колонка = ЭлементыФормы.ГрафикРаботы.Колонки["Часов"+Строка(ДеньМесяца)];
				
				Колонка.ТекстШапки = Строка(ДеньМесяца) + Символы.ПС + ДниНедели[Данные[ДеньМесяца - 1].ДеньНедели];
				
				ВидДня = Данные[ДеньМесяца - 1].ВидДня;
				Если ВидДня = Перечисления.ВидыДнейПроизводственногоКалендаря.Праздник Тогда
					Колонка.ЦветТекстаШапки = ЦветПраздничногоДня;
					Колонка.ШрифтШапки = ШрифтыСтиля.ШрифтВажнойНадписи;
				ИначеЕсли ВидДня = Перечисления.ВидыДнейПроизводственногоКалендаря.Воскресенье Тогда
					Колонка.ЦветТекстаШапки = ЦветВоскресенья;
					Колонка.ШрифтШапки = ШрифтыСтиля.ШрифтВажнойНадписи;
				ИначеЕсли ВидДня = Перечисления.ВидыДнейПроизводственногоКалендаря.Суббота Тогда
					Колонка.ЦветТекстаШапки = ЦветСубботы;
					Колонка.ШрифтШапки = ШрифтыСтиля.ШрифтВажнойНадписи;
				ИначеЕсли ВидДня = Перечисления.ВидыДнейПроизводственногоКалендаря.Предпраздничный Тогда
					Колонка.ЦветТекстаШапки = ЦветПредпразничногоДня;
					Колонка.ШрифтШапки = Новый Шрифт();
				Иначе
					Колонка.ЦветТекстаШапки = Новый Цвет();	
					Колонка.ШрифтШапки = Новый Шрифт();
				КонецЕсли;
			КонецЦикла;
		КонецЕсли;
		ЭлементыФормы.ГрафикРаботы.ВысотаШапки = 2;
	Иначе
		ЭлементыФормы.ГрафикРаботы.ВысотаШапки = 1;
	КонецЕсли;
	
КонецПроцедуры

// Процедура устанавливает видимость колонок таблицы ГрафикРаботы в зависимости от способа ввода данных
// и количества дней в месяце.
Процедура УстановитьВидимостьколонокТаблицыГрафикРаботы()
	
	ВидимостьКолонокНочныеЧасы = УчетВремени = Перечисления.ВидыУчетаВремени.ПоНочнымЧасам;
	ВидимостьКолонокВечерниеЧасы = ВидимостьКолонокНочныеЧасы ИЛИ (УчетВремени = Перечисления.ВидыУчетаВремени.ПоВечернимЧасам);
	
	ВводимПоДням = СпособВводаДанных = СпособВводаДанныхПоДням;
	
	ЭлементыФормы.ГрафикРаботы.Колонки.ЧасовЗаДень.Видимость 	= ВводимПоДням И ВидимостьКолонокВечерниеЧасы;
	ЭлементыФормы.ГрафикРаботы.Колонки.ИзНихВечерних.Видимость 	= ВводимПоДням И ВидимостьКолонокВечерниеЧасы;
	ЭлементыФормы.ГрафикРаботы.Колонки.ИзНихНочных.Видимость 	= ВводимПоДням И ВидимостьКолонокНочныеЧасы;
	
	ПоследнийДеньМесяца = День(КонецМесяца(ПериодРегистрации));
	Для ДеньМесяца = 1 По 31 Цикл
		
		ВидимостьКолонок = ВводимПоДням И (ДеньМесяца <= ПоследнийДеньМесяца);
		
		// дневные часы
		ЭлементыФормы.ГрафикРаботы.Колонки["Часов"+Строка(ДеньМесяца)].Видимость = ВидимостьКолонок;
		
		// Вечерние часы
		ЭлементыФормы.ГрафикРаботы.Колонки["ЧасовВечерних"+Строка(ДеньМесяца)].Видимость = ВидимостьКолонок И ВидимостьКолонокВечерниеЧасы;
		
		// Ночные часы
		ЭлементыФормы.ГрафикРаботы.Колонки["ЧасовНочных"+Строка(ДеньМесяца)].Видимость = ВидимостьКолонок И ВидимостьКолонокНочныеЧасы;
		
	КонецЦикла;
	//ЭлементыФормы.ГрафикРаботы.Колонки.ВсегоДней.Видимость = Истина;
	//ЭлементыФормы.ГрафикРаботы.Колонки.ВсегоЧасов.Видимость = Истина;
	УстановитьФиксациюСлева();
	
КонецПроцедуры // УстановитьВидимостьколонокТаблицыГрафикРаботы()	

// Процедура устанавливает фиксацию колонок таблицы,
// в зависимости от количества видимых колонок
//
Процедура УстановитьФиксациюСлева()
	
	ВводимПоДням = СпособВводаДанных = СпособВводаДанныхПоДням;
	
	// Установим фиксацию сотрудника с табельным номером если он выводится
	ВидимостьТабельногоНомера = ЭлементыФормы.ГрафикРаботы.Колонки.ТабельныйНомерСтрока.Видимость;
	ВидимостьНадписиПоЧасам = УчетВремени <> Перечисления.ВидыУчетаВремени.ПоЧасам;
	
	Если ВводимПоДням И ВидимостьТабельногоНомера И ВидимостьНадписиПоЧасам Тогда
		ЭлементыФормы.ГрафикРаботы.ФиксацияСлева = 4;
	ИначеЕсли ((НЕ ВводимПоДням) И (НЕ ВидимостьТабельногоНомера)) ИЛИ
		(ВводимПоДням И НЕ ВидимостьТабельногоНомера И НЕ ВидимостьНадписиПоЧасам)Тогда
		ЭлементыФормы.ГрафикРаботы.ФиксацияСлева = 2;
	Иначе
		ЭлементыФормы.ГрафикРаботы.ФиксацияСлева = 3;
	КонецЕсли;
	
КонецПроцедуры

// Процедура устанавливает видимость табельного номера и количество фиксируемых колонок
//
Процедура УстановитьВидимостьТабельногоНомера()
	
	РаботаСДиалогами.УстановитьВидимостьЭУПоУчетнойПолитикеПоПерсоналу(мМассивЭУ,глЗначениеПеременной("глУчетнаяПолитикаПоПерсоналуОрганизации"),Организация);
	УстановитьФиксациюСлева();
	
КонецПроцедуры

// определяем, надо ли вводить вечерние и ночные часы
//
// Параметры
//  нет
//
Процедура ОпределитьПорядокВводаДанных()
	
	ЕстьВечерниеЧасы = Ложь;
	ЕстьНочныеЧасы = Ложь;
	ПоследнийДеньМесяца = День(КонецМесяца(ПериодРегистрации));
	
	Если СпособВводаДанных = СпособВводаДанныхПоДням Тогда
		Для НомерДня = 1 По ПоследнийДеньМесяца Цикл
			ЕстьВечерниеЧасы = ГрафикРаботы.Итог("ЧасовВечерних"+Строка(НомерДня)) > 0;
			ЕстьНочныеЧасы = ГрафикРаботы.Итог("ЧасовНочных"+Строка(НомерДня)) > 0;
			Если ЕстьВечерниеЧасы И ЕстьНочныеЧасы Тогда
				Прервать;
			КонецЕсли;
		КонецЦикла;
	Иначе
		ЕстьВечерниеЧасы = ГрафикРаботы.Итог("ВсегоЧасовВечерних") > 0;
		ЕстьНочныеЧасы = ГрафикРаботы.Итог("ВсегоЧасовНочных") > 0;
	КонецЕсли;
	Если ЕстьНочныеЧасы Тогда
		УчетВремени = Перечисления.ВидыУчетаВремени.ПоНочнымЧасам;
	ИначеЕсли ЕстьВечерниеЧасы Тогда
		УчетВремени = Перечисления.ВидыУчетаВремени.ПоВечернимЧасам;
	Иначе
		УчетВремени = Перечисления.ВидыУчетаВремени.ПоЧасам;
	КонецЕсли;
	
КонецПроцедуры // ОпределитьПорядокВводаДанных()

// Функция просматривает график работы и возвращает Истина если введены ночные или
// вечерние часы	
Функция ЕстьДанныеПоВечернимНочнымЧасам(УчитыватьВечерниеЧасы = Ложь,УчитыватьНочныеЧасы = Ложь)
	
	Если СпособВводаДанных = СпособВводаДанныхПоДням Тогда
		Для Каждого СтрокаГрафикаРаботы Из ГрафикРаботы Цикл
			Для ИндексДня = 1 По 31 Цикл
				Если (УчитыватьВечерниеЧасы И (СтрокаГрафикаРаботы["ЧасовВечерних"+Строка(ИндексДня)]>0)) 
					ИЛИ (УчитыватьНочныеЧасы И (СтрокаГрафикаРаботы["ЧасовНочных"+Строка(ИндексДня)]>0)) Тогда
					Возврат Истина;
				КонецЕсли;
			КонецЦикла;
		КонецЦикла;
	Иначе
		Для Каждого СтрокаГрафикаРаботы Из ГрафикРаботы Цикл
			Если (УчитыватьВечерниеЧасы И (СтрокаГрафикаРаботы.ВсегоЧасовВечерних>0)) 
				ИЛИ (УчитыватьНочныеЧасы И (СтрокаГрафикаРаботы.ВсегоЧасовНочных>0)) Тогда
				Возврат Истина;
			КонецЕсли;
		КонецЦикла;
	КонецЕсли;
	Возврат Ложь;	
	
КонецФункции // ЕстьДанныеПоВечернимНочнымЧасам()

// Процедура устанавливает видимость колонок Вечерние и Ночные часы в Истина,
// если в данных колонках есть ненулевые значения
Процедура УстановкаВидимостиНеобходимыхВечернихИНочныхЧасов()
	Если ГрафикРаботы.Итог("ВсегоЧасовНочных") > 0 
		И УчетВремени <> Перечисления.ВидыУчетаВремени.ПоНочнымЧасам Тогда
		СтароеЗначениеУчетаВремени = УчетВремени;
		УчетВремени = Перечисления.ВидыУчетаВремени.ПоНочнымЧасам;
		ВсегоЧасовПриИзменении(ЭлементыФормы.ВсегоЧасов);
	ИначеЕсли ГрафикРаботы.Итог("ВсегоЧасовВечерних") > 0 
		И УчетВремени = Перечисления.ВидыУчетаВремени.ПоЧасам Тогда
		СтароеЗначениеУчетаВремени = УчетВремени;
		УчетВремени = Перечисления.ВидыУчетаВремени.ПоВечернимЧасам;
		ВсегоЧасовПриИзменении(ЭлементыФормы.ВсегоЧасов);
	КонецЕсли;
	
	
КонецПроцедуры // УстановкаВидимостиНеобходимыхВечернихИНочныхЧасов()

////////////////////////////////////////////////////////////////////////////////
// ПРОЦЕДУРЫ - ОБРАБОТЧИКИ СОБЫТИЙ ФОРМЫ

// Процедура - обработчик события "ПередОткрытием" формы
//
Процедура ПередОткрытием(Отказ, СтандартнаяОбработка)
	
	// Установка кнопок печати
	УстановитьКнопкиПечати();
	
	// Установка кнопок заполнение ТЧ
	УстановитьКнопкиПодменюЗаполненияТЧ();
	
КонецПроцедуры // ПередОткрытием()

// Процедура - обработчик события "ПриОткрытии" формы
Процедура ПриОткрытии()
	
	Если ЭтоНовый() Тогда
		
		ЗаполнениеДокументов.ЗаполнитьШапкуДокумента(ЭтотОбъект);
		
		Если СпособВводаДанных.Пустая() Тогда
			СпособВводаДанных = ВосстановитьЗначение("СпособВводаДанных");
			Если СпособВводаДанных.Пустая() Тогда	
				СпособВводаДанных = СпособВводаДанныхПоДням;
			КонецЕсли;
		КонецЕсли;
		
	Иначе
		ОпределитьПорядокВводаДанных();
		// Установить доступность формы с учетом даты запрета редактирования	
		РаботаСДиалогами.УстановитьДоступностьФормыДляРедактирования(ЭтотОбъект, ЭтаФорма);
	КонецЕсли;
	
	МеханизмНумерацииОбъектов.УстановитьДоступностьПоляВводаНомера(Метаданные(), ЭтаФорма, ЭлементыФормы.ДействияФормы.Кнопки.Действия, ЭлементыФормы.Номер);
	
	УчетВремени = ВосстановитьЗначение("УчетВремени");
	Если Не ЗначениеЗаполнено(УчетВремени) Тогда
		УчетВремени = Перечисления.ВидыУчетаВремени.ПоЧасам;
	КонецЕсли;
	СтароеЗначениеУчетаВремени = УчетВремени;
	
	// Заполним реквизит формы МесяцСтрока.
	МесяцСтрока = РаботаСДиалогами.ДатаКакМесяцПредставление(ПериодРегистрации);
	
	// Вывести в заголовке формы статус документа (новый, не проведен, проведен).
	РаботаСДиалогами.УстановитьЗаголовокФормыДокумента(, ЭтотОбъект, ЭтаФорма);
	
	// Запомнить текущие значения реквизитов формы.
	мТекущаяДатаДокумента = Дата;
	
	// Получим и запомним ссылку на головную организацию
	мГоловнаяОрганизация = ОбщегоНазначения.ГоловнаяОрганизация(Организация);
	
	// Установим видимость реквизитов в зависимости от уч.политики по персоналу организаций
	мМассивЭУ = Новый Массив();
	мМассивЭУ.Добавить(ЭлементыФормы.ГрафикРаботы.Колонки.ТабельныйНомерСтрока);
	УстановитьВидимостьТабельногоНомера();
	
	УстановитьВидимостьколонокТаблицыГрафикРаботы();	
	ОформитьЗаголовкиДнейМесяца();
	
	// Установить активный реквизит.
	//Если Не РаботаСДиалогами.АктивизироватьРеквизитВФорме(ЭтотОбъект, ЭтаФорма) Тогда
	//	ТекущийЭлемент = ЭлементыФормы.ГрафикРаботы
	//КонецЕсли;
	РаботаСДиалогами.АктивизироватьРеквизитВФорме(ЭтотОбъект, ЭтаФорма);
	
КонецПроцедуры

// Процедура - обработчик события "ОбработкаВыбора" формы
Процедура ОбработкаВыбора(ЗначениеВыбора, Источник)
	Если ТипЗнч(ЗначениеВыбора) = Тип("Структура") Тогда
		Команда = "";
		Если ЗначениеВыбора.Свойство("Команда",Команда) И Команда = "ЗаполнитьПостроительЗапроса" Тогда			
			
			Автозаполнение(ЗначениеВыбора.ПостроительЗапроса);
			
			Если ГрафикРаботы.Количество() = 0 Тогда
				ОбщегоНазначения.СообщитьОбОшибке(НСтр("ru='Не обнаружено работников, удовлетворяющих указанным условиям!';uk='Не виявлено працівників, що задовольняють вказаним умовам!'"));
			Иначе 
				УстановкаВидимостиНеобходимыхВечернихИНочныхЧасов();
				ОпределитьПорядокВводаДанных();
				УстановитьВидимостьколонокТаблицыГрафикРаботы();
			КонецЕсли;
			
		КонецЕсли;
	КонецЕсли;
КонецПроцедуры

// Процедура - обработчик события "ПриЗаписи" формы
Процедура ПриЗаписи(Отказ)
	
	СохранитьЗначение("СпособВводаДанных", СпособВводаДанных);
	СохранитьЗначение("УчетВремени", УчетВремени);
	
КонецПроцедуры

// Процедура - обработчик события "ПослеЗаписи" формы
Процедура ПослеЗаписи()
	
	// Установка кнопок печати
	УстановитьКнопкиПечати();
	// Вывести в заголовке формы статус документа (новый, не проведен, проведен).
	РаботаСДиалогами.УстановитьЗаголовокФормыДокумента(, ЭтотОбъект, ЭтаФорма);
	МеханизмНумерацииОбъектов.ОбновитьПодсказкуКодНомерОбъекта(ЭтотОбъект.Метаданные(), ЭлементыФормы.ДействияФормы.Кнопки.Действия, ЭлементыФормы.Номер);
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// ПРОЦЕДУРЫ - ДЕЙСТВИЯ КОМАНДНЫХ ПАНЕЛЕЙ ФОРМЫ

// Процедура вызывается при выборе пункта подменю "Движения документа по регистрам" меню "Перейти".
// командной панели формы. Процедура отрабатывает печать движений документа по регистрам.
//
Процедура ДействияФормыДвиженияДокументаПоРегистрам(Кнопка)
	
	РаботаСДиалогами.НапечататьДвиженияДокумента(Ссылка);
	
КонецПроцедуры // ДействияФормыДвиженияДокументаПоРегистрам()

// Процедура вызова структуры подчиненности документа
//
Процедура ДействияФормыСтруктураПодчиненностиДокумента(Кнопка)
	
	РаботаСДиалогами.ПоказатьСтруктуруПодчиненностиДокумента(Ссылка);
	
КонецПроцедуры // ДействияФормыСтруктураПодчиненностиДокумента()

// Процедура выполняет открытие формы работы со свойствами документа
//
Процедура ДействияФормыДействиеОткрытьСвойства(Кнопка)
	
	РаботаСДиалогами.ОткрытьСвойстваДокумента(ЭтотОбъект, ЭтаФорма);
	
КонецПроцедуры // ДействияФормыДействиеОткрытьСвойства()

// Процедура выполняет открытие формы работы с категориями документа
//
Процедура ДействияФормыДействиеОткрытьКатегории(Кнопка)
	
	РаботаСДиалогами.ОткрытьКатегорииДокумента(ЭтотОбъект, ЭтаФорма);
	
КонецПроцедуры // ДействияФормыДействиеОткрытьКатегории()

// Процедура выполняет  открытие формы регистра ГрафикиРаботыПоВидамВремени
// с отбором по данному документу
Процедура ДействияФормыГрафикиРаботыПоВидамВремени(Кнопка)
	ФормаСписка = РегистрыСведений.ГрафикиРаботыПоВидамВремени.ПолучитьФормуСписка();	
	ФормаСписка.Отбор.Документ.Установить(Ссылка);
	ФормаСписка.Открыть();
КонецПроцедуры // ДействияФормыГрафикиРаботыПоВидамВремени()


// Процедура - обработчик нажатия на любую из дополнительных кнопок по заполнению ТЧ
//
Процедура НажатиеНаДополнительнуюКнопкуЗаполненияТЧ(Кнопка)
	
	УниверсальныеМеханизмы.ОбработатьНажатиеНаДополнительнуюКнопкуЗаполненияТЧ(мКнопкиЗаполненияТЧ.Строки.Найти(Кнопка.Имя,"Имя",Истина),ЭтотОбъект);
	
КонецПроцедуры // НажатиеНаДополнительнуюКнопкуЗаполненияТЧ()

// Процедура - обработчик нажатия на кнопку "Печать по умолчанию"
//
Процедура ОсновныеДействияФормыПечатьПоУмолчанию(Кнопка)
	
	УниверсальныеМеханизмы.ПечатьПоДополнительнойКнопке(мДеревоМакетов, ЭтотОбъект, ЭтаФорма, Кнопка.Текст);
	
КонецПроцедуры // ОсновныеДействияФормыПечатьПоУмолчанию()

// Процедура - обработчик нажатия на кнопку "Печать"
//
Процедура ОсновныеДействияФормыПечать(Кнопка)
	
	УниверсальныеМеханизмы.ПечатьПоДополнительнойКнопке(мДеревоМакетов, ЭтотОбъект, ЭтаФорма, Кнопка.Текст);
	
КонецПроцедуры // ОсновныеДействияФормыПечать()

// Процедура - обработчик нажатия на кнопку "Установить печать по умолчанию"
//
Процедура ОсновныеДействияФормыУстановитьПечатьПоУмолчанию(Кнопка)
	
	Если УниверсальныеМеханизмы.НазначитьКнопкуПечатиПоУмолчанию(мДеревоМакетов, Метаданные().Имя) Тогда
		УстановитьКнопкиПечати();
	КонецЕсли;
	
КонецПроцедуры // ОсновныеДействияФормыУстановитьПечатьПоУмолчанию()

// Процедура - вызывается при нажатии на кнопку "Заполнить" командной панели КоманднаяПанельГрафикРаботы
Процедура КоманднаяПанельГрафикРаботыДействиеЗаполнить(Кнопка)
	
	Если ГрафикРаботы.Количество() > 0 Тогда
		ТекстВопроса = "Перед заполнением табличнaя часть будет очищена. Заполнить?";
		Ответ = Вопрос(ТекстВопроса, РежимДиалогаВопрос.ДаНет, , КодВозвратаДиалога.Да,);
		
		Если Ответ <> КодВозвратаДиалога.Да Тогда
			Возврат;
		КонецЕсли;
		ГрафикРаботы.Очистить();
		
	КонецЕсли;
	
	Автозаполнение();
	
	Если ГрафикРаботы.Количество() = 0 Тогда
		ОбщегоНазначения.СообщитьОбОшибке(НСтр("ru='Не обнаружено работников, по которым еще не вводились данные об индивидуальном графике!';uk='Не виявлено працівників, за якими ще не вводилися дані про індивідуальний графік!'"));
	Иначе 
		УстановкаВидимостиНеобходимыхВечернихИНочныхЧасов();
		ОпределитьПорядокВводаДанных();
		УстановитьВидимостьколонокТаблицыГрафикРаботы();
	КонецЕсли;
	
КонецПроцедуры

// Процедура - вызывается при нажатии на кнопку "Заполнить" командной панели КоманднаяПанельГрафикРаботы
Процедура КоманднаяПанельГрафикРаботыСписокРаботников(Кнопка)
	
	Если ГрафикРаботы.Количество() > 0 Тогда
		ТекстВопроса = "Перед заполнением табличнaя часть будет очищена. Заполнить?";
		Ответ = Вопрос(ТекстВопроса, РежимДиалогаВопрос.ДаНет, , КодВозвратаДиалога.Да,);
		
		Если Ответ <> КодВозвратаДиалога.Да Тогда
			Возврат;
		КонецЕсли;
		ГрафикРаботы.Очистить();
		
	КонецЕсли;
	
	ПроцедурыУправленияПерсоналом.ОткрытьФормуОтбораСпискаРаботников(ЭтаФорма, ПериодРегистрации, "РаботникиОрганизаций", Организация, ПодразделениеОрганизации, Ложь,,,,ПериодРегистрации, Истина);
	
КонецПроцедуры

// Процедура - вызывается при нажатии на кнопку "Подбор" командной панели КоманднаяПанельГрафикРаботы
Процедура КоманднаяПанельГрафикРаботыПодбор(Кнопка)
	
	ПроцедурыУправленияПерсоналом.ОткрытьФормуВыбораСотрудникаОрганизации(ЭлементыФормы.ГрафикРаботы, Ссылка, Ложь, Дата, Организация, 1);
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// ПРОЦЕДУРЫ - ОБРАБОТЧИКИ СОБЫТИЙ РЕКВИЗИТОВ ШАПКИ

// Процедура - обработчик события "ПриИзменении" поля ввода даты документа.
//
Процедура ДатаПриИзменении(Элемент)
	
	РаботаСДиалогами.ПроверитьНомерДокумента(ЭтотОбъект, мТекущаяДатаДокумента);
	МеханизмНумерацииОбъектов.ОбновитьПодсказкуКодНомерОбъекта(ЭтотОбъект.Метаданные(), ЭлементыФормы.ДействияФормы.Кнопки.Действия, ЭлементыФормы.Номер);
	
	мТекущаяДатаДокумента = Дата;
	
КонецПроцедуры // ДатаПриИзменении()

// Процедура - обработчик события "ПриИзменении" поля ввода организации.
//
Процедура ОрганизацияПриИзменении(Элемент)
	
	Если Не ПустаяСтрока(Номер) Тогда
		МеханизмНумерацииОбъектов.СброситьУстановленныйКодНомерОбъекта(ЭтотОбъект, "Номер", ЭлементыФормы.ДействияФормы.Кнопки.Действия, ЭлементыФормы.Номер);
	КонецЕсли;
	
	ЗаполнениеДокументов.ПриИзмененииЗначенияОрганизации(ЭтотОбъект);
	
	// Получим и запомним ссылку на головную организацию
	мГоловнаяОрганизация = ОбщегоНазначения.ГоловнаяОрганизация(Организация);
	
	// Установим видимость реквизитов
	УстановитьВидимостьТабельногоНомера();
	
КонецПроцедуры

// Процедура выполняет алгоритм действий при изменении реквизита СпособВводаДанных
//
// Параметры:
//  Элемент      - элемент формы, который отображает Способ ввода данных.
//
Процедура СпособВводаДанныхПриИзменении(Элемент)
	Если СпособВводаДанных <> СпособВводаДанныхПоДням Тогда
		ЗаполнитьСводныеДанныеГрафикаРаботы();
	КонецЕсли;
	УстановитьВидимостьКолонокТаблицыГрафикРаботы();
	ОформитьЗаголовкиДнейМесяца();
КонецПроцедуры

// Процедура - обработчик события "ПриИзменении" переключателя "ВсегоЧасов".
//
Процедура ВсегоЧасовПриИзменении(Элемент)
	
	// Обнуляем данные о вечерних/ночных часах, если они становятся невидимыми
	УчетВремениРавенПоЧасам = УчетВремени = Перечисления.ВидыУчетаВремени.ПоЧасам;
	СтароеЗначениеУчетаВремениРавноПоНочнымЧасам = СтароеЗначениеУчетаВремени = Перечисления.ВидыУчетаВремени.ПоНочнымЧасам;
	Если УчетВремениРавенПоЧасам ИЛИ СтароеЗначениеУчетаВремениРавноПоНочнымЧасам Тогда
		ВыдаватьЗапросОУдаленииДанных = ЕстьДанныеПоВечернимНочнымЧасам(УчетВремениРавенПоЧасам, СтароеЗначениеУчетаВремениРавноПоНочнымЧасам);
		// перед очисткой данных о вечерних и ночных часах выдаем вопрос
		Если ВыдаватьЗапросОУдаленииДанных Тогда
			ТекстВопроса = НСтр("ru='Будут очищены данные ';uk='Будуть очищені дані '")+
			?(УчетВремениРавенПоЧасам И СтароеЗначениеУчетаВремениРавноПоНочнымЧасам, НСтр("ru='вечерних и ночных';uk='вечірніх і нічних'"),
			?(УчетВремениРавенПоЧасам, "вечерних","ночных")) +НСтр("ru=' часов, продолжить?';uk=' годин, продовжити?'");
			
			Ответ = Вопрос(ТекстВопроса, РежимДиалогаВопрос.ДаНет, , КодВозвратаДиалога.Да,);
			
			Если Ответ <> КодВозвратаДиалога.Да Тогда
				УчетВремени = СтароеЗначениеУчетаВремени;
				Возврат;
			КонецЕсли;
		КонецЕсли;
		
		Если СпособВводаДанных = СпособВводаДанныхПоДням Тогда
			// Очищаем вечернее время
			Если УчетВремениРавенПоЧасам Тогда
				Для Каждого СтрокаГрафикРаботы Из ГрафикРаботы Цикл
					Для ИндексДня = 1 По 31 Цикл
						СтрокаГрафикРаботы["ЧасовВечерних"+Строка(ИндексДня)] = 0;
					КонецЦикла;	
				КонецЦикла;
			КонецЕсли;
			// Очищаем  ночное время
			Если СтароеЗначениеУчетаВремениРавноПоНочнымЧасам Тогда
				Для Каждого СтрокаГрафикРаботы Из ГрафикРаботы Цикл
					Для ИндексДня = 1 По 31 Цикл
						СтрокаГрафикРаботы["ЧасовНочных"+Строка(ИндексДня)] = 0;
					КонецЦикла;	
				КонецЦикла;
			КонецЕсли;
		Иначе
			// Очищаем вечернее время
			Если УчетВремениРавенПоЧасам Тогда
				Для Каждого СтрокаГрафикРаботы Из ГрафикРаботы Цикл
					
					СтрокаГрафикРаботы["ВсегоЧасовВечерних"+Строка(ИндексДня)] = 0;
					
				КонецЦикла;
			КонецЕсли;
			// Очищаем  ночное время
			Если СтароеЗначениеУчетаВремениРавноПоНочнымЧасам Тогда
				Для Каждого СтрокаГрафикРаботы Из ГрафикРаботы Цикл
					СтрокаГрафикРаботы["ВсегоЧасовНочных"+Строка(ИндексДня)] = 0;
				КонецЦикла;
			КонецЕсли;
		КонецЕсли;
	КонецЕсли;		
	
	СтароеЗначениеУчетаВремени = УчетВремени;
	УстановитьВидимостьКолонокТаблицыГрафикРаботы();
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// ПРОЦЕДУРЫ - ОБРАБОТЧИКИ СОБЫТИЙ РЕКВИЗИТА ШАПКИ ПериодРегистрации

// Процедура - обработчик события "ПриИзменении" поля ввода периода регистрации.
//
Процедура ПериодРегистрацииПриИзменении(Элемент)
	РаботаСДиалогами.ДатаКакМесяцПодобратьДатуПоТексту(Элемент.Значение, ПериодРегистрации);
	Элемент.Значение = РаботаСДиалогами.ДатаКакМесяцПредставление(ПериодРегистрации);
	Если СпособВводаДанных = СпособВводаДанныхПоДням Тогда
		УстановитьВидимостьколонокТаблицыГрафикРаботы();
		ОформитьЗаголовкиДнейМесяца();
	КонецЕсли;
КонецПроцедуры

// Процедура - обработчик события "НачалоВыбораИзСписка" поля ввода периода регистрации.
//
Процедура ПериодРегистрацииНачалоВыбораИзСписка(Элемент, СтандартнаяОбработка)
	РаботаСДиалогами.НачалоВыбораИзСпискаПредставленияПериодаРегистрации(Элемент, СтандартнаяОбработка, ПериодРегистрации, ЭтаФорма);
	Если СпособВводаДанных = СпособВводаДанныхПоДням Тогда
		УстановитьВидимостьколонокТаблицыГрафикРаботы();
		ОформитьЗаголовкиДнейМесяца();
	КонецЕсли;
КонецПроцедуры

// Процедура - обработчик события "Очистка" поля ввода периода регистрации.
//
Процедура ПериодРегистрацииОчистка(Элемент, СтандартнаяОбработка)
	СтандартнаяОбработка = Ложь;
КонецПроцедуры

// Процедура - обработчик события "Регулирование" поля ввода периода регистрации.
//
Процедура ПериодРегистрацииРегулирование(Элемент, Направление, СтандартнаяОбработка)
	
	ПериодРегистрации = ДобавитьМесяц(ПериодРегистрации, Направление);
	Элемент.Значение = РаботаСДиалогами.ДатаКакМесяцПредставление(ПериодРегистрации);
	Если СпособВводаДанных = СпособВводаДанныхПоДням Тогда
		УстановитьВидимостьколонокТаблицыГрафикРаботы();
		ОформитьЗаголовкиДнейМесяца();
	КонецЕсли;
КонецПроцедуры

// Процедура - обработчик события "АвтоПодборТекста" поля ввода периода регистрации.
//
Процедура ПериодРегистрацииАвтоПодборТекста(Элемент, Текст, ТекстАвтоПодбора, СтандартнаяОбработка)
	РаботаСДиалогами.ДатаКакМесяцАвтоПодборТекста(Текст, ТекстАвтоПодбора, СтандартнаяОбработка);
КонецПроцедуры

// Процедура - обработчик события "ОкончаниеВводаТекста" поля ввода периода регистрации.
//
Процедура ПериодРегистрацииОкончаниеВводаТекста(Элемент, Текст, Значение, СтандартнаяОбработка)
	РаботаСДиалогами.ДатаКакМесяцОкончаниеВводаТекста(Текст, Значение, СтандартнаяОбработка);
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// ПРОЦЕДУРЫ - ОБРАБОТЧИКИ СОБЫТИЙ ТАБЛИЧНОГО ПОЛЯ ГрафикРаботы

// Процедура - обработчик события "ПриВыводеСтроки" табличной части ГрафикРаботы
Процедура ГрафикРаботыПриВыводеСтроки(Элемент, ОформлениеСтроки, ДанныеСтроки)
	
	Если СпособВводаДанных = СпособВводаДанныхПоДням Тогда 

		ВсегоЧасов = 0; ВсегоЧасовВечерних = 0; ВсегоЧасовНочных = 0; ВсегоДней = 0; 
		Для НомерДня = 1 По 31 Цикл
			ЗначениеДня = 0;  
			ЗначениеЯчейки = ДанныеСтроки["Часов"+Строка(НомерДня)];
			Если ЗначениеЯчейки <> 0 Тогда
				ОформлениеСтроки.Ячейки["Часов"+Строка(НомерДня)].Текст = Строка(ЗначениеЯчейки);
				ВсегоЧасов = ВсегоЧасов + ЗначениеЯчейки;  
				ЗначениеДня = 1;                           
			КонецЕсли;
			ЗначениеЯчейки = ДанныеСтроки["ЧасовВечерних"+Строка(НомерДня)];
			Если ЗначениеЯчейки <> 0 Тогда
				ОформлениеСтроки.Ячейки["ЧасовВечерних"+Строка(НомерДня)].Текст = Строка(ЗначениеЯчейки);
				ВсегоЧасовВечерних = ВсегоЧасовВечерних + ЗначениеЯчейки;  
			КонецЕсли;
			ЗначениеЯчейки = ДанныеСтроки["ЧасовНочных"+Строка(НомерДня)];
			Если ЗначениеЯчейки <> 0 Тогда	
				ОформлениеСтроки.Ячейки["ЧасовНочных"+Строка(НомерДня)].Текст = Строка(ЗначениеЯчейки);
				ВсегоЧасовНочных = ВсегоЧасовНочных + ЗначениеЯчейки;  
			КонецЕсли;
			ВсегоДней = ВсегоДней + ЗначениеДня; 
		КонецЦикла;
		ОформлениеСтроки.Ячейки["ВсегоДней"].Текст = Строка(ВсегоДней);
		ОформлениеСтроки.Ячейки["ВсегоЧасов"].Текст = Строка(ВсегоЧасов);
		ОформлениеСтроки.Ячейки["ВсегоЧасовВечерних"].Текст = Строка(ВсегоЧасовВечерних);
		ОформлениеСтроки.Ячейки["ВсегоЧасовНочных"].Текст = Строка(ВсегоЧасовНочных);
		
	КонецЕсли;
	
КонецПроцедуры

// Процедура - обработчик события "ПриПолученииДанных" 
Процедура ГрафикРаботыПриПолученииДанных(Элемент, ОформленияСтрок)
	
	РаботаСДиалогами.УстановитьЗначенияКолонкиТабельныйНомерСтрока(ЭлементыФормы.ГрафикРаботы, ОформленияСтрок);
	Если СпособВводаДанных = СпособВводаДанныхПоДням 
		И (УчетВремени <> Перечисления.ВидыУчетаВремени.ПоЧасам) Тогда
		Для Каждого ОформлениеСтроки Из ОформленияСтрок Цикл
			ОформлениеСтроки.Ячейки.ЧасовЗаДень.УстановитьТекст(НСтр("ru='Часов за день';uk='Годин за день'"));
			ОформлениеСтроки.Ячейки.ИзНихВечерних.УстановитьТекст(НСтр("ru='Из них вечерних';uk='З них вечірніх'"));
			ОформлениеСтроки.Ячейки.ИзНихНочных.УстановитьТекст(НСтр("ru='Из них ночных';uk='З них нічних'"));
			
		КонецЦикла;
	КонецЕсли;
	
КонецПроцедуры // РаботникиОрганизацииПриПолученииДанных()

// Процедура - обработчик события "ОбработкаВыбора" табличной части ГрафикРаботы
Процедура ГрафикРаботыОбработкаВыбора(Элемент, ВыбранноеЗначение, СтандартнаяОбработка)
	
	Если ТипЗнч(ВыбранноеЗначение) <> Тип("СправочникСсылка.СотрудникиОрганизаций") Тогда
		Возврат;
	КонецЕсли;
	
	// Если выбор произошел в форме подбора и этого физлица в документе пока нет,
	// добавим новую строку в таблицу
	СтруктураПоиска = Новый Структура("Назначение", ВыбранноеЗначение);
	
	Если ГрафикРаботы.НайтиСтроки(СтруктураПоиска).Количество() = 0 Тогда
		Автозаполнение(,ВыбранноеЗначение);
		УстановкаВидимостиНеобходимыхВечернихИНочныхЧасов();
	Иначе
		Предупреждение(НСтр("ru='Данный сотрудник уже введен в табличную часть.';uk='Цей співробітник вже введений в табличну частину.'"));
	КонецЕсли;		
	
	СтандартнаяОбработка = Ложь;
	
КонецПроцедуры


Процедура ГрафикРаботыСотрудникПриИзменении(Элемент)
	
	Если НЕ ЗначениеЗаполнено(ЭлементыФормы.ГрафикРаботы.ТекущаяСтрока.Назначение) Тогда
		ЭлементыФормы.ГрафикРаботы.ТекущаяСтрока.Назначение = Элемент.Значение;
		Автозаполнение(,Элемент.Значение, ЭлементыФормы.ГрафикРаботы.ТекущаяСтрока);
		УстановкаВидимостиНеобходимыхВечернихИНочныхЧасов();
	КонецЕсли;
	
КонецПроцедуры

Процедура ГрафикРаботыСотрудникНачалоВыбора(Элемент, СтандартнаяОбработка)
	
	ПроцедурыУправленияПерсоналом.ОткрытьФормуВыбораСотрудникаОрганизации(Элемент, Ссылка, Истина, Дата, Организация, 1, СтандартнаяОбработка, Элемент.Значение);
	
КонецПроцедуры // НачисленияФизлицоНачалоВыбора()

Процедура ГрафикРаботыСотрудникАвтоПодборТекста(Элемент, Текст, ТекстАвтоПодбора, СтандартнаяОбработка)
	
	ТекстАвтоПодбора = ПроцедурыУправленияПерсоналом.ПодобратьФИОРаботникаКандидата(СтандартнаяОбработка, "РаботникиОрганизации", Текст, Организация);
	
КонецПроцедуры

Процедура ГрафикРаботыСотрудникОкончаниеВводаТекста(Элемент, Текст, Значение, СтандартнаяОбработка)
	
	Значение = ПроцедурыУправленияПерсоналом.ПодобратьСписокРаботниковКандидатов(СтандартнаяОбработка, "РаботникиОрганизации", Текст, Элемент.Значение, Организация);
	
КонецПроцедуры


Процедура ГрафикРаботыНазначениеПриИзменении(Элемент)
	
	Если НЕ ЗначениеЗаполнено(ЭлементыФормы.ГрафикРаботы.ТекущаяСтрока.Сотрудник) Тогда
		ЭлементыФормы.ГрафикРаботы.ТекущаяСтрока.Сотрудник = ?(ЗначениеЗаполнено(Элемент.Значение.ОсновноеНазначение), Элемент.Значение.ОсновноеНазначение, Элемент.Значение);
	КонецЕсли;
	Автозаполнение(,Элемент.Значение, ЭлементыФормы.ГрафикРаботы.ТекущаяСтрока);
	УстановкаВидимостиНеобходимыхВечернихИНочныхЧасов();
	
КонецПроцедуры

Процедура ГрафикРаботыНазначениеНачалоВыбора(Элемент, СтандартнаяОбработка)
	
	ПроцедурыУправленияПерсоналом.ОткрытьФормуВыбораСотрудникаОрганизации(Элемент, Ссылка, Истина, Дата, Организация, 1, СтандартнаяОбработка, Элемент.Значение);
	
КонецПроцедуры // НачисленияФизлицоНачалоВыбора()

Процедура ГрафикРаботыНазначениеАвтоПодборТекста(Элемент, Текст, ТекстАвтоПодбора, СтандартнаяОбработка)
	
	ТекстАвтоПодбора = ПроцедурыУправленияПерсоналом.ПодобратьФИОРаботникаКандидата(СтандартнаяОбработка, "РаботникиОрганизации", Текст, Организация);
	
КонецПроцедуры

Процедура ГрафикРаботыНазначениеОкончаниеВводаТекста(Элемент, Текст, Значение, СтандартнаяОбработка)
	
	Значение = ПроцедурыУправленияПерсоналом.ПодобратьСписокРаботниковКандидатов(СтандартнаяОбработка, "РаботникиОрганизации", Текст, Элемент.Значение, Организация);
	
КонецПроцедуры


// Процедура разрешения/запрещения редактирования номера документа
Процедура ДействияФормыРедактироватьНомер(Кнопка)
	
	МеханизмНумерацииОбъектов.ИзменениеВозможностиРедактированияНомера(ЭтотОбъект.Метаданные(), ЭтаФорма, ЭлементыФормы.ДействияФормы.Кнопки.Действия, ЭлементыФормы.Номер);
			
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// ОПЕРАТОРЫ ОСНОВНОЙ ПРОГРАММЫ

СпособВводаДанныхПоДням = Перечисления.СпособыВводаДанныхОВремени.ПоДням;

ДлинаСуток = 86400;
ПерваяДата = НачалоДня(ОбщегоНазначения.ПолучитьРабочуюДату());
ПерваяДата = ПерваяДата - ДеньНедели(ПерваяДата) * ДлинаСуток;
ДниНедели = Новый Соответствие;
Для ДеньНедели = 1 По 7 Цикл
	ДниНедели.Вставить(ДеньНедели, НРег(Формат(ПерваяДата + ДеньНедели * ДлинаСуток,"ДФ=ддд")));
КонецЦикла;

