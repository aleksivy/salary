﻿
Перем мСтруктураПараметрыДоОткрытияФормы Экспорт;

Перем мСоответствиеОбъектыМетаданных Экспорт;
Перем мСоответствиеРеквизитыФормы Экспорт;

Перем мУчетнаяПолитикаПоПерсоналу Экспорт;
Перем мУчетнаяПолитикаПоРасчетуЗарплаты Экспорт;
Перем мУчетнаяПолитикаПоПерсоналуОрганизаций Экспорт;

Процедура ЗаполнитьСоответствия()
	
	мСтруктураПараметрыДоОткрытияФормы.Вставить("ЕдиныйНумераторКадровыхДокументов", Неопределено);
	мСтруктураПараметрыДоОткрытияФормы.Вставить("ИспользуютсяНачисленияВВалюте", Неопределено);
	мСтруктураПараметрыДоОткрытияФормы.Вставить("ПоддержкаВнутреннегоСовместительства", Неопределено);
	
	Для каждого СтраницаФормы Из ЭлементыФормы.ПанельНастроек.Страницы Цикл
	
		Если СтраницаФормы = ЭлементыФормы.ПанельНастроек.Страницы.КадровыйУчет Тогда
			
			МассивОбъектовМетаданных = Новый Массив;
			МассивОбъектовМетаданных.Добавить(Метаданные.РегистрыСведений.УчетнаяПолитикаПоПерсоналуОрганизаций);
			мСоответствиеОбъектыМетаданных.Вставить(СтраницаФормы, МассивОбъектовМетаданных);
			
			МассивЭУ = Новый Массив;
			МассивЭУ.Добавить(ЭлементыФормы.ПоддержкаВнутреннегоСовместительства);  
			МассивЭУ.Добавить(ЭлементыФормы.ПроверкаШтатногоРасписания);
			МассивЭУ.Добавить(ЭлементыФормы.ЕдиныйНумераторКадровыхДокументов);
			МассивЭУ.Добавить(ЭлементыФормы.РасчетЗарплатыОрганизацииПоОтветственным);
			МассивЭУ.Добавить(ЭлементыФормы.ПоказыватьТабельныеНомераВДокументах);
			МассивЭУ.Добавить(ЭлементыФормы.ИспользуютсяНачисленияВВалюте);
			МассивЭУ.Добавить(ЭлементыФормы.ВестиУчетОстатковОтпусков);
			МассивЭУ.Добавить(ЭлементыФормы.КоличествоДнейПоложенногоОтпуска);
			мСоответствиеРеквизитыФормы.Вставить(СтраницаФормы, МассивЭУ);
	
			
		ИначеЕсли СтраницаФормы = ЭлементыФормы.ПанельНастроек.Страницы.РасчетЗарплаты Тогда
			
			МассивОбъектовМетаданных = Новый Массив;
			МассивОбъектовМетаданных.Добавить(Метаданные.РегистрыСведений.ПараметрыРасчетаЗарплатыОрганизаций);
			мСоответствиеОбъектыМетаданных.Вставить(СтраницаФормы, МассивОбъектовМетаданных);
			
			МассивЭУ = Новый Массив;
			МассивЭУ.Добавить(ЭлементыФормы.КоэффициентВечерних);
			МассивЭУ.Добавить(ЭлементыФормы.КоэффициентНочных);
			МассивЭУ.Добавить(ЭлементыФормы.ОкруглятьДо);
			МассивЭУ.Добавить(ЭлементыФормы.ГруппаВзносов);
			МассивЭУ.Добавить(ЭлементыФормы.ПриУплатеЕСВОкруглятьВБольшуюСторону);
			МассивЭУ.Добавить(ЭлементыФормы.ДатаНачалаРаботы);   
			МассивЭУ.Добавить(ЭлементыФормы.ЕстьПремии);
			МассивЭУ.Добавить(ЭлементыФормы.ЕстьГодоваяПремия);
			МассивЭУ.Добавить(ЭлементыФормы.НеУчитыватьСовместителейДляСредних);
			МассивЭУ.Добавить(ЭлементыФормы.ПрименятьЛьготуНДФЛБазовуюИДетскуюПоПорогуДетской);
			МассивЭУ.Добавить(ЭлементыФормы.ИспользованиеРезерваОтпусков);
			МассивЭУ.Добавить(ЭлементыФормы.ПрименятьКоэффициентЕСВДляАвансов);
			мСоответствиеРеквизитыФормы.Вставить(СтраницаФормы, МассивЭУ);
			
		ИначеЕсли СтраницаФормы = ЭлементыФормы.ПанельНастроек.Страницы.УправленческийУчет Тогда
			
			//право на чтение константы есть, проверим ее значение
		
			МассивОбъектовМетаданных = Новый Массив;   
			МассивОбъектовМетаданных.Добавить(Метаданные.Константы.РежимНабораПерсонала);
			МассивОбъектовМетаданных.Добавить(Метаданные.РегистрыСведений.УчетнаяПолитикаПоПерсоналу);
			мСоответствиеОбъектыМетаданных.Вставить(СтраницаФормы, МассивОбъектовМетаданных);
				
			МассивЭУ = Новый Массив;
			МассивЭУ.Добавить(ЭлементыФормы.РежимНабораПерсонала);	
			МассивЭУ.Добавить(ЭлементыФормы.Переключатель2);
			МассивЭУ.Добавить(ЭлементыФормы.ПоддерживатьНесколькоСхемМотивации);
			МассивЭУ.Добавить(ЭлементыФормы.ПоказыватьТабельныеНомераВДокументахУпр);
			МассивЭУ.Добавить(ЭлементыФормы.РасчетЗарплатыПоОтветственным);
			мСоответствиеРеквизитыФормы.Вставить(СтраницаФормы, МассивЭУ);

			
		Иначе // сюда попадут страницы, которые не будут показаны пользователю
			
			мСоответствиеОбъектыМетаданных.Вставить(СтраницаФормы, Неопределено);
			
			МассивЭУ = Новый Массив;
			мСоответствиеРеквизитыФормы.Вставить(СтраницаФормы, МассивЭУ);
			
		КонецЕсли;	
	
	КонецЦикла;
		
КонецПроцедуры

Процедура ЗаполнитьСтруктурыУчетныхПолитик()

	// заполним структуры значениями учетных политик по умолчанию
	мУчетнаяПолитикаПоПерсоналу.Вставить("РасчетЗарплатыПоОтветственным", Ложь);
	мУчетнаяПолитикаПоПерсоналу.Вставить("ПоказыватьТабельныеНомераВДокументах", Ложь);
	мУчетнаяПолитикаПоПерсоналу.Вставить("ПоддерживатьНесколькоСхемМотивации", Ложь);

	мУчетнаяПолитикаПоПерсоналуОрганизаций.Вставить("ПоддержкаВнутреннегоСовместительства", Ложь);
	мУчетнаяПолитикаПоПерсоналуОрганизаций.Вставить("ПроверкаШтатногоРасписания", Ложь);
	мУчетнаяПолитикаПоПерсоналуОрганизаций.Вставить("ЕдиныйНумераторКадровыхДокументов", Ложь);
	мУчетнаяПолитикаПоПерсоналуОрганизаций.Вставить("РасчетЗарплатыОрганизацииПоОтветственным", Ложь);
	мУчетнаяПолитикаПоПерсоналуОрганизаций.Вставить("ПоказыватьТабельныеНомераВДокументах", Ложь);
	мУчетнаяПолитикаПоПерсоналуОрганизаций.Вставить("ИспользуютсяНачисленияВВалюте", Ложь);
	мУчетнаяПолитикаПоПерсоналуОрганизаций.Вставить("ВестиУчетОстатковОтпусков", Ложь);
	мУчетнаяПолитикаПоПерсоналуОрганизаций.Вставить("КоличествоДнейПоложенногоОтпуска", 24);
	
	мУчетнаяПолитикаПоРасчетуЗарплаты.Вставить("КоэффициентВечерних", 0.20);
	мУчетнаяПолитикаПоРасчетуЗарплаты.Вставить("КоэффициентНочных", 0.20);
	мУчетнаяПолитикаПоРасчетуЗарплаты.Вставить("ОкруглятьДо", 0.01);
	мУчетнаяПолитикаПоРасчетуЗарплаты.Вставить("ГруппаВзносов", Справочники.ГруппыВзносовВФонды.ОсновнойСостав);
	мУчетнаяПолитикаПоРасчетуЗарплаты.Вставить("ПриУплатеЕСВОкруглятьВБольшуюСторону", Ложь);
	мУчетнаяПолитикаПоРасчетуЗарплаты.Вставить("ДатаНачалаРаботы", Дата(1,1,1));
	мУчетнаяПолитикаПоРасчетуЗарплаты.Вставить("ЕстьПремии", Ложь);
	мУчетнаяПолитикаПоРасчетуЗарплаты.Вставить("ЕстьГодоваяПремия", Ложь);
	мУчетнаяПолитикаПоРасчетуЗарплаты.Вставить("НеУчитыватьСовместителейДляСредних", Ложь);
	мУчетнаяПолитикаПоРасчетуЗарплаты.Вставить("ПрименятьЛьготуНДФЛБазовуюИДетскуюПоПорогуДетской", Ложь);
	мУчетнаяПолитикаПоРасчетуЗарплаты.Вставить("НеПрименятьЛьготуНДФЛДляАвансов", Ложь);
	мУчетнаяПолитикаПоРасчетуЗарплаты.Вставить("НеПрименятьЛьготуНДФЛДляБудущихПериодов", Ложь);
    мУчетнаяПолитикаПоРасчетуЗарплаты.Вставить("ИспользованиеРезерваОтпусков", Ложь);
	мУчетнаяПолитикаПоРасчетуЗарплаты.Вставить("ПрименятьКоэффициентЕСВДляАвансов", Ложь);
КонецПроцедуры

Процедура ПолучитьДанныеИЗаполнитьРеквизитыФормы()
	
	// получим данные по Организации
	ПолучитьДанныеПоОрганизации(ЭтаФорма);
	
	// получим данные из УчетнаяПолитикаПоПерсоналу
	ПолучитьДанныеУчетнаяПолитикаПоПерсоналу(ЭтаФорма);
	
КонецПроцедуры

Функция ПроверитьВозможностьИзмененияУчетнойПолитикиПоПерсоналу()

	Если ЭлементыФормы.ПанельНастроек.Страницы.КадровыйУчет.Видимость Тогда
		ТекстСообщенияОбОшибке = "";
		БылЕдиныйНумераторКадровыхДокументов = мСтруктураПараметрыДоОткрытияФормы.ЕдиныйНумераторКадровыхДокументов;
		Если Не БылЕдиныйНумераторКадровыхДокументов и БылЕдиныйНумераторКадровыхДокументов <> ЕдиныйНумераторКадровыхДокументов Тогда
			// проверим возможность включения единого нумератора
			НельзяВключитьЕдиныйНумератор = Не ПроцедурыУправленияПерсоналом.НомераКадровыхДокументовУникальны(Организация);
			Если НельзяВключитьЕдиныйНумератор Тогда
				ТекстСообщенияОбОшибке = НСтр("ru='Включить единый кадровый нумератор невозможно, т.к. существуют неуникальные номера кадровых документах:';uk='Включити єдиний кадровий нумератор неможливо, оскільки існують неунікальні номери кадрових документів:'");
				Возврат ТекстСообщенияОбОшибке;	
			КонецЕсли;	
		КонецЕсли;
		
		БылиНачисленияВВалюте = мСтруктураПараметрыДоОткрытияФормы.ИспользуютсяНачисленияВВалюте;
		Если БылиНачисленияВВалюте И БылиНачисленияВВалюте <> ИспользуютсяНачисленияВВалюте Тогда
			// проверим на необходимость и возможность отключения учета начислений и удержаний в валюте 
			НельзяОтключитьНачисленияВВалюте = Не ПроцедурыУправленияПерсоналом.МожноОтключатьУчетВВалюте(Организация);		
			Если НельзяОтключитьНачисленияВВалюте Тогда
				ТекстСообщенияОбОшибке = НСтр("ru='Отключить использование начислений и удержаний в валюте невозможно, т.к. есть действующие валютные начисления (удержания)!';uk='Відключити використання нарахувань і утримань у валюті неможливо, т. я. є діючі валютні нарахування (утримання)!'");
				Возврат ТекстСообщенияОбОшибке;
			КонецЕсли;
		КонецЕсли;	

		БылоСовместительство = мСтруктураПараметрыДоОткрытияФормы.ПоддержкаВнутреннегоСовместительства;
		Если БылоСовместительство И БылоСовместительство <> ПоддержкаВнутреннегоСовместительства Тогда
			// проверим на необходимость и возможность отключения учета начислений и удержаний в валюте 
			НельзяОтключитьСовместительство = Не ПроцедурыУправленияПерсоналом.МожноОтключатьВнутреннееСовместительство(Организация);		
			Если НельзяОтключитьСовместительство Тогда
				ТекстСообщенияОбОшибке = НСтр("ru='Отключить поддержку внутреннего совместительства невозможно, т.к. некоторые работники заняты на нескольких местах работы!';uk='Відключити підтримку внутрішнього сумісництва неможливо, тому що деякі працівники зайняті на декількох місцях роботи!'");
				Возврат ТекстСообщенияОбОшибке;
			КонецЕсли;
		КонецЕсли;	

		
	КонецЕсли;
	
	Возврат "";

КонецФункции // ПроверитьВозможностьИзмененияУчетнойПолитикиПоПерсоналу()

Функция СохранитьДанные()

	ОбработкаКомментариев = глЗначениеПеременной("глОбработкаСообщений");
	ОбработкаКомментариев.УдалитьСообщения();
	
	// проверим возможность изменения учетной политики по персоналу
	СтрокаСообщенияОбОшибке = ПроверитьВозможностьИзмененияУчетнойПолитикиПоПерсоналу();
	Если ЗначениеЗаполнено(СтрокаСообщенияОбОшибке) Тогда
		ОбработкаКомментариев.ДобавитьСообщение(СтрокаСообщенияОбОшибке, Перечисления.ВидыСообщений.Ошибка);
		ОбработкаКомментариев.ДобавитьСообщение(НСтр("ru='Новые параметры не записаны!';uk='Нові параметри не записані!'"), Перечисления.ВидыСообщений.ВажнаяИнформация);
		ОбработкаКомментариев.ПоказатьСообщения();
		Возврат Ложь;
	КонецЕсли;
	
	НачатьТранзакцию();
	
	ЗаполнитьЗначенияСвойств(мУчетнаяПолитикаПоРасчетуЗарплаты, ЭтаФорма); 
	ЗаполнитьЗначенияСвойств(мУчетнаяПолитикаПоПерсоналуОрганизаций, ЭтаФорма);
	
	Если Не ЗаписатьДанныеПоОрганизации(ЭтаФорма) Тогда
		ОбработкаКомментариев.ПоказатьСообщения();
		Возврат Ложь;
	КонецЕсли;
	
	Если ЭлементыФормы.ПанельНастроек.Страницы.УправленческийУчет.Видимость Тогда
		
		НадоЗаписать = Ложь;
		
		НаборЗаписей = РегистрыСведений.УчетнаяПолитикаПоПерсоналу.СоздатьНаборЗаписей();
		НаборЗаписей.Прочитать();
		Если НаборЗаписей.Количество() = 0 Тогда
			
			НоваяЗапись = НаборЗаписей.Добавить();
			НоваяЗапись.ПоддерживатьНесколькоСхемМотивации 	= ПоддерживатьНесколькоСхемМотивации;
			НоваяЗапись.ПоказыватьТабельныеНомераВДокументах = ПоказыватьТабельныеНомераВДокументахУпр;
			НоваяЗапись.РасчетЗарплатыПоОтветственным 		= РасчетЗарплатыПоОтветственным;
			НадоЗаписать = Истина;
			
		ИначеЕсли НаборЗаписей[0].ПоддерживатьНесколькоСхемМотивации <> ПоддерживатьНесколькоСхемМотивации
			ИЛИ НаборЗаписей[0].ПоказыватьТабельныеНомераВДокументах <> ПоказыватьТабельныеНомераВДокументахУпр
			ИЛИ НаборЗаписей[0].РасчетЗарплатыПоОтветственным <> РасчетЗарплатыПоОтветственным Тогда
			
			НаборЗаписей[0].ПоддерживатьНесколькоСхемМотивации 	 = ПоддерживатьНесколькоСхемМотивации;
			НаборЗаписей[0].ПоказыватьТабельныеНомераВДокументах = ПоказыватьТабельныеНомераВДокументахУпр;
			НаборЗаписей[0].РасчетЗарплатыПоОтветственным 		 = РасчетЗарплатыПоОтветственным;
			НадоЗаписать = Истина;
			
		КонецЕсли;
		
		Если НадоЗаписать Тогда
			Если Не ОбщегоНазначения.ЗаписатьНабор(НаборЗаписей) Тогда
				Возврат Ложь
			КонецЕсли;
			глЗначениеПеременнойУстановить("глУчетнаяПолитикаПоПерсоналу", ЗаполнениеУчетнойПолитикиПоПерсоналу(), ИСТИНА);
		КонецЕсли;
		
		Если РежимНабораПерсонала <> Константы.РежимНабораПерсонала.Получить() Тогда
			Константы.РежимНабораПерсонала.Установить(РежимНабораПерсонала);
		КонецЕсли;	
		
	КонецЕсли;
	
	ЗафиксироватьТранзакцию();
		
	Модифицированность = Ложь;
	ЭлементыФормы.ОсновныеДействияФормы.Кнопки.Применить.Доступность = Ложь;
	
	мСтруктураПараметрыДоОткрытияФормы.ЕдиныйНумераторКадровыхДокументов = ЕдиныйНумераторКадровыхДокументов;
	мСтруктураПараметрыДоОткрытияФормы.ИспользуютсяНачисленияВВалюте = ИспользуютсяНачисленияВВалюте;
	мСтруктураПараметрыДоОткрытияФормы.ПоддержкаВнутреннегоСовместительства = ПоддержкаВнутреннегоСовместительства;
	
	Возврат Истина;

КонецФункции


////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ ЭЛЕМЕНТОВ ФОРМЫ

Процедура ОбработатьИзменениеОрганизации()

	ЗаполнитьСтруктурыУчетныхПолитик();
	ПолучитьДанныеПоОрганизации(ЭтаФорма);
	Модифицированность = Ложь;

КонецПроцедуры

Процедура ОрганизацияПриИзменении(Элемент)
	
	ОбработатьИзменениеОрганизации();
	
КонецПроцедуры

Процедура ОрганизацияОчистка(Элемент, СтандартнаяОбработка)
	СтандартнаяОбработка = Ложь;
КонецПроцедуры


////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ ЭЛЕМЕНТОВ ФОРМЫ СТРАНИЦА КадровыйУчет

Процедура РасчетЗарплатыОрганизацииПоОтветственнымПриИзменении(Элемент)
	
	ЭлементыФормы.НадписьСписокРасчетчиковЗарплаты.Видимость = РасчетЗарплатыОрганизацииПоОтветственным;
	
КонецПроцедуры

Процедура ИспользуютсяНачисленияВВалютеПриИзменении(Элемент)
	
	ЭлементыФормы.НадписьКурсыВалют.Видимость = ИспользуютсяНачисленияВВалюте;
	
КонецПроцедуры

Процедура НадписьСписокРасчетчиковЗарплатыНажатие(Элемент)
	
	ФормаРегистра = РегистрыСведений.РасчетчикиЗарплатыОрганизаций.ПолучитьФормуСписка(, ЭтаФорма, Элемент);
	ФормаРегистра.Открыть();
	
КонецПроцедуры

Процедура НадписьКурсыВалютНажатие(Элемент)
	
	ФормаРегистра = РегистрыСведений.КурсыВалютДляРасчетовСПерсоналом.ПолучитьФормуСписка(, ЭтаФорма, Элемент);
	ФормаРегистра.Открыть();
	
КонецПроцедуры

 ////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ ЭЛЕМЕНТОВ ФОРМЫ СТРАНИЦА УправленческийУчет

Процедура РасчетЗарплатыПоОтветственнымПриИзменении(Элемент)
	
	ЭлементыФормы.НадписьСписокРасчетчиковЗарплатыУпр.Видимость = РасчетЗарплатыПоОтветственным;
	
КонецПроцедуры

Процедура НадписьСписокРасчетчиковЗарплатыУпрНажатие(Элемент)
	
	ФормаРегистра = РегистрыСведений.РасчетчикиЗарплаты.ПолучитьФормуСписка(, ЭтаФорма, Элемент);
	ФормаРегистра.Открыть();
	
КонецПроцедуры


////////////////////////////////////////////////////////////////////////////////
// ПРОЦЕДУРЫ - ОБРАБОТЧИКИ СОБЫТИЙ ФОРМЫ

Процедура ПередОткрытием(Отказ, СтандартнаяОбработка)
	
	ЗаполнитьСтруктурыУчетныхПолитик();
	ЗаполнитьСоответствия();
	ФормаОбработкиПередОткрытием(ЭтаФорма, Отказ);
	
	Если Отказ Тогда
		// все страницы формы недоступны, не открываем форму и сообщаем
		// пользователю о том, что у него нет прав
		Предупреждение(НСтр("ru='Нарушение прав доступа!';uk='Порушення прав доступу!'"));
	КонецЕсли;	
	
КонецПроцедуры

Процедура ПриОткрытии()
	
	ЭлементыФормы.ОсновныеДействияФормы.Кнопки.Применить.Доступность = Ложь;
	
	// получим из ИБ разрешенные данные и заполним форму обработки
	ПолучитьДанныеИЗаполнитьРеквизитыФормы();
	
	// запомним значения параметров до начала их редактирования
	ЗаполнитьЗначенияСвойств(мСтруктураПараметрыДоОткрытияФормы, ЭтаФорма);
		
КонецПроцедуры // ПриОткрытии()

Процедура ОбновлениеОтображения()
	
	ЭлементыФормы.ОсновныеДействияФормы.Кнопки.Применить.Доступность = Модифицированность;
	Если ПрименятьЛьготуНДФЛБазовуюИДетскуюПоПорогуДетской Тогда
		ЭлементыФормы.НадписьНДФЛ.Заголовок = НСтр("ru='Если флаг включен, при расчете НДФЛ базовая льгота применяется одновременно с льготами на детей при условии, что облагаемый доход не превышает порога, установленного п. 169.4.1. НКУ, рассчитанного пропорционально количеству детей';uk='Якщо прапор включений, при розрахунку ПДФО базова пільга застосовується одночасно з пільгами на дітей за умови, що оподатковуваний дохід не перевищує порогу, встановленого п. 169.4.1. ПКУ, розрахованого пропорційно кількості дітей'");
	Иначе
		ЭлементыФормы.НадписьНДФЛ.Заголовок = НСтр("ru='Если флаг не включен, при расчете НДФЛ базовая льгота применяется одновременно с льготами на детей только при условии, что облагаемый доход не превышает порога, установленного п. 169.4.1. НКУ';uk='Якщо прапор не включений, при розрахунку ПДФО базова пільга застосовується одночасно з пільгами на дітей тільки за умови, що оподатковуваний дохід не перевищує порогу, встановленого п. 169.4.1. ПКУ'");
	КонецЕсли;

КонецПроцедуры

Процедура КнопкаВыполнитьНажатие(Кнопка)

	СохранитьДанные();

КонецПроцедуры



////////////////////////////////////////////////////////////////////////////////
// ОПЕРАТОРЫ ОСНОВНОЙ ПРОГРАММЫ
мСоответствиеОбъектыМетаданных = Новый Соответствие();
мСоответствиеРеквизитыФормы    = Новый Соответствие();
мСтруктураПараметрыДоОткрытияФормы = Новый Структура();

мУчетнаяПолитикаПоПерсоналу = Новый Структура();
мУчетнаяПолитикаПоРасчетуЗарплаты = Новый Структура();
мУчетнаяПолитикаПоПерсоналуОрганизаций = Новый Структура();

