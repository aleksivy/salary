﻿
Процедура ОбработкаВыбора(ЗначениеВыбора, Источник)
	СтандартнаяОбработка = Ложь;
	Параметр =КомпоновщикНастроек.Настройки.ПараметрыДанных.НайтиЗначениеПараметра( ЭлементыФормы.ПараметрыДанных.ТекущаяСтрока.Параметр);
	Если ТипЗнч(Параметр.Значение) =  Тип("СписокЗначений") Тогда
		Параметр.Значение.Добавить(ЗначениеВыбора);
	КонецЕсли;
	
	ДвеЦифры = Строка(Прав(Параметр.Параметр,2));
	Если Лев(ДвеЦифры,1) = "а" Тогда
		НомерКолонки = Число(Прав(ДвеЦифры,1))
	Иначе
		НомерКолонки = Число(ДвеЦифры)
	КонецЕсли;
	ВывестиИнформациюОКолонке(НомерКолонки);

КонецПроцедуры

Процедура ПриОткрытии()
	НачальныйВыводДанныхКолонок();
КонецПроцедуры

Процедура НачальныйВыводДанныхКолонок()
	ЦветФонаСправки		= РаботаСДиалогами.ВернутьШестнадцатиричноеПредставлениеЦвета(РаботаСДиалогами.ВстроеннаяСправка_ЦветФона());
	ЦветСсылкиСправки	= РаботаСДиалогами.ВернутьШестнадцатиричноеПредставлениеЦвета(РаботаСДиалогами.ВстроеннаяСправка_ЦветСсылки());
	
	ТекстНачальноеЗаполнение =
	"<HTML>
	|	<HEAD>
	|		<META http-equiv=Content-Type content=""text/html; charset=utf-8"">" + РаботаСДиалогами.ВстроеннаяСправка_СтилиДокумента() + "
	|	</HEAD>
	|
	|	<BODY aLink="+ЦветСсылкиСправки+" vLink="+ЦветСсылкиСправки+" link="+ЦветСсылкиСправки+" bgColor="+ЦветФонаСправки+" scroll=auto><FONT face=""MS Sans Serif"" size=1>
	|		<IMG src="+РаботаСДиалогами.ПолучитьПутьККартинкеДляHTML(БиблиотекаКартинок.КартинкаВстроеннойСправкиФормы, ЭлементыФормы.ДанныеКолонки)+">
	|			<DIV>Унифицированная форма П49.</DIV>
	|			<DIV>Вы можете просмотреть данные для заполнения каждой из колонок и добавить требуемые виды расчета</DIV>
	|<HR>
	|			<DIV>Нараховано доплат та надбавок за тарифними ставками (посадовими окладами)<A id=Команда href=""1C:ПерейтиККолонке6""> (колонка 6)</A></DIV>
	|<HR>
	|			<DIV>Нараховано доплат та надбавок за роботу в нічний час <A id=Команда href=""1C:ПерейтиККолонке7"">(колонка 7)</A></DIV>
	|<HR>
	|			<DIV>Нараховано доплат та надбавок за роботу в понадурочний час <A id=Команда href=""1C:ПерейтиККолонке8"">(колонка 8)</A></DIV>
	|<HR>
	|			<DIV>Нараховано доплат та надбавок за простой не з вини працівника <A id=Команда href=""1C:ПерейтиККолонке9"">(колонка 9)</A></DIV>
	|<HR>
	|			<DIV>Дані колонки № 10 <A id=Команда href=""1C:ПерейтиККолонке10"">(колонка 10)</A></DIV>
	|<HR>
	|			<DIV>Нараховано премій <A id=Команда href=""1C:ПерейтиККолонке11"">(колонка 11)</A></DIV>
	|<HR>
	|			<DIV>Нараховано премій <A id=Команда href=""1C:ПерейтиККолонке12"">(колонка 12)</A></DIV>
	|<HR>
	|			<DIV>Нараховано премій <A id=Команда href=""1C:ПерейтиККолонке13"">(колонка 13)</A></DIV>
	|<HR>
	|			<DIV>Нараховано доплат та надбавок за чергову відпустку (поточний місяць) <A id=Команда href=""1C:ПерейтиККолонке15"">(колонка 15)</A></DIV>
    |<HR>
	|			<DIV>Нараховано доплат та надбавок за чергову відпустку (наступний місяць)<A id=Команда href=""1C:ПерейтиККолонке16"">(колонка 16)</A></DIV>
	|<HR>
	|			<DIV>Місяць допомоги за тимчасовою непрацездатністю   <A id=Команда href=""1C:ПерейтиККолонке17"">(колонка 17)</A></DIV>
	|<HR>
	|			<DIV>Дні допомоги за тимчасовою непрацездатністю   <A id=Команда href=""1C:ПерейтиККолонке18"">(колонка 18)</A></DIV>
	|<HR>
	|			<DIV>Сума допомоги за тимчасовою непрацездатністю   <A id=Команда href=""1C:ПерейтиККолонке19"">(колонка 19)</A></DIV>
	//|<HR>
	//|			<DIV>Всього нараховано за видаи оплат   <A id=Команда href=""1C:ПерейтиККолонке20"">(колонка 20)</A></DIV>
	|<HR>
	|			<DIV>Виплачено за першу половину місяця (аванс)   <A id=Команда href=""1C:ПерейтиККолонке21"">(колонка 21)</A></DIV>
	|<HR>
	|			<DIV>Прибутковий податок  <A id=Команда href=""1C:ПерейтиККолонке22"">(колонка 22)</A></DIV>
    |<HR>
	|			<DIV>Утримано за виконавчими документами  <A id=Команда href=""1C:ПерейтиККолонке23"">(колонка 23)</A></DIV>
	|<HR>
	|			<DIV>Відраховано у Пенсійний фонд  <A id=Команда href=""1C:ПерейтиККолонке24"">(колонка 24)</A></DIV>
    |<HR>
	|			<DIV>Профспілковий внесок  <A id=Команда href=""1C:ПерейтиККолонке25"">(колонка 25)</A></DIV>
	|<HR>
	|			<DIV>Дані колонки № 26  <A id=Команда href=""1C:ПерейтиККолонке26"">(колонка 26)</A></DIV>
	|<HR>
	|			<DIV>Дані колонки № 27  <A id=Команда href=""1C:ПерейтиККолонке27"">(колонка 27)</A></DIV>
	|<HR>
	|			<DIV>Дані колонки № 28  <A id=Команда href=""1C:ПерейтиККолонке28"">(колонка 28)</A></DIV>
	|<HR>
	|			<DIV>Дані колонки № 29  <A id=Команда href=""1C:ПерейтиККолонке29"">(колонка 29)</A></DIV>


	

	//|<HR>
	//|			<DIV>Сума заробітньої плати<A id=Команда href=""1C:ПерейтиККолонке32"">(колонка 32)</A></DIV>
	|		</DIV>
	|	</FONT></BODY>
	|</HTML>";
	
	ЭлементыФормы.ДанныеКолонки.УстановитьТекст(ТекстНачальноеЗаполнение);

	
КонецПроцедуры

Процедура ВыполнитьКомандуФормы(Команда, Значение) Экспорт
	
	//Номер колонки может быть как двухзначеным, так и однозначным
	ДвеЦифры = Строка(Прав(Команда,2));
	Если Лев(ДвеЦифры,1) = "е" Тогда
		НомерКолонки = Число(Прав(ДвеЦифры,1))
	Иначе
		НомерКолонки = Число(ДвеЦифры)
	КонецЕсли;

	Если Команда = "ПерейтиККолонке" + Строка(НомерКолонки) Тогда
		ВывестиИнформациюОКолонке(НомерКолонки);
	КонецЕсли;
	//
	Если Команда = "ДобавитьККолонке" + Строка(НомерКолонки) Тогда
		ДобавитьДанныеККолонке(НомерКолонки)
	КонецЕсли;
	//
КонецПроцедуры

Процедура ВывестиИнформациюОКолонке(НомерКолонки)
	
	ЦветФонаСправки		= РаботаСДиалогами.ВернутьШестнадцатиричноеПредставлениеЦвета(РаботаСДиалогами.ВстроеннаяСправка_ЦветФона());
	ЦветСсылкиСправки	= РаботаСДиалогами.ВернутьШестнадцатиричноеПредставлениеЦвета(РаботаСДиалогами.ВстроеннаяСправка_ЦветСсылки());

	Параметр = КомпоновщикНастроек.Настройки.ПараметрыДанных.НайтиЗначениеПараметра( Новый ПараметрКомпоновкиДанных("парамКолонка"+НомерКолонки));
	
	Текст  = "
	|<HTML>
	|	<HEAD>
	|		<META http-equiv=Content-Type content=""text/html; charset=utf-8"">" + РаботаСДиалогами.ВстроеннаяСправка_СтилиДокумента() + "
	|	</HEAD>
	|
	|	<BODY aLink="+ЦветСсылкиСправки+" vLink="+ЦветСсылкиСправки+" link="+ЦветСсылкиСправки+" bgColor="+ЦветФонаСправки+" scroll=auto><FONT face=""MS Sans Serif"" size=1>
	|		<IMG src="+РаботаСДиалогами.ПолучитьПутьККартинкеДляHTML(БиблиотекаКартинок.КартинкаВстроеннойСправкиФормы, ЭлементыФормы.ДанныеКолонки)+">			<B><DIV>Унифицированная форма П49.</DIV></B>
	|			<DIV>Данные попадающие в колонку № " + Строка(НомерКолонки) + """</DIV>
	|<HR> ";

	Если Параметр <> Неопределено Тогда	
		Если ТипЗнч(Параметр.Значение) = Тип("СписокЗначений") Тогда
			Для Каждого Элемент из Параметр.Значение Цикл
				ТипПараметра = ТипЗнч(Элемент.Значение);	
				Продолжить;
			КонецЦикла;
		Иначе
			ТипПараметра = ТипЗнч(Параметр.Значение);
		КонецЕсли;
	КонецЕсли;
	
	Текст = Текст + "<DIV> <B>" + Строка(ТипПараметра) + "   </B></DIV>";
   	Текст = Текст + "<DIV>   </DIV>";
	

	Если Параметр <> Неопределено Тогда	
		Если ТипЗнч(Параметр.Значение) = Тип("СписокЗначений") Тогда
			Для Каждого Элемент из Параметр.Значение Цикл
					Текст = Текст + "<DIV> " + Строка(Элемент.Значение) + "   </DIV>";			
			КонецЦикла;
		Иначе
		Текст = Текст + "<DIV> " + Строка(Параметр.Значение) + "   </DIV>";
		КонецЕсли;
		Текст = Текст + "<HR>
		|<DIV><A id=Команда href=""1C:ДобавитьККолонке" + Строка(НомерКолонки) + " ""> Добавить</A></DIV>
		|		</DIV>
		|	</FONT></BODY>
		|</HTML>";
	КонецЕсли;

		
	ЭлементыФормы.ДанныеКолонки.УстановитьТекст(Текст);
	
	//ЭлементыФормы.ПараметрыДанных.ТекущаяСтрока = ЭлементыФормы.ПараметрыДанных.
	
	//ЭлементыФормы.ПараметрыДанных.ТекущиеДанные.Параметр = "парамКолонка" + Строка(НомерКолонки);
	
	
КонецПроцедуры

Процедура ДобавитьДанныеККолонке(НомерКолонки)
	
	Параметр = КомпоновщикНастроек.Настройки.ПараметрыДанных.НайтиЗначениеПараметра( Новый ПараметрКомпоновкиДанных("парамКолонка"+НомерКолонки));
	
	Если Параметр <> Неопределено Тогда	
		Если ТипЗнч(Параметр.Значение) = Тип("СписокЗначений") Тогда
			Для Каждого Элемент из Параметр.Значение Цикл
				ТипПараметра = (ТипЗнч(Элемент.Значение))	;
				Прервать;
			КонецЦикла;
		Иначе
			ТипПараметра = ТипЗнч(Параметр.Значение);
			Если ТипЗнч(ТипПараметра) = Тип("СписокЗначений") Тогда
				Для Каждого Элемент из Параметр.Значение Цикл
					ТипПараметра = (ТипЗнч(Элемент.Значение))	;
					Прервать;
				КонецЦикла;
			КонецЕсли;
		КонецЕсли;
		
		Если ТипПараметра = Тип("ПланВидовРасчетаСсылка.ОсновныеНачисленияОрганизаций") Тогда
			Форма = ПланыВидовРасчета.ОсновныеНачисленияОрганизаций.ПолучитьФормуВыбора(,ЭтаФорма);
		ИначеЕсли ТипПараметра = Тип("ПланВидовРасчетаСсылка.ВзносыВФонды") Тогда
			Форма = ПланыВидовРасчета.ВзносыВФонды.ПолучитьФормуВыбора(,ЭтаФорма);
		ИначеЕсли ТипПараметра = Тип("ПланВидовРасчетаСсылка.УдержанияОрганизаций") Тогда
			Форма = ПланыВидовРасчета.УдержанияОрганизаций.ПолучитьФормуВыбора(,ЭтаФорма);
		ИначеЕсли ТипПараметра = Тип("ПеречислениеСсылка.СпособыРасчетаОплатыТруда") Тогда
			Форма = Перечисления.СпособыРасчетаОплатыТруда.ПолучитьФормуВыбора(,ЭтаФорма);
		ИначеЕсли ТипПараметра = Тип("ПеречислениеСсылка.ХарактерВыплатыЗарплаты") Тогда
			Форма = Перечисления.ХарактерВыплатыЗарплаты.ПолучитьФормуВыбора(,ЭтаФорма);
		ИначеЕсли ТипПараметра = Тип("ПеречислениеСсылка.КодыОперацийВзаиморасчетыСРаботникамиОрганизаций") Тогда
			Форма = Перечисления.ХарактерВыплатыЗарплаты.ПолучитьФормуВыбора(,ЭтаФорма);
		Иначе 
			Возврат;
		КонецЕсли;
		
		Форма.ОткрытьМодально();
		
	КонецЕсли;
	
	СамостоятельнаяНастройка = Истина;

	//ЭлементыФормы.ПараметрыДанных.ТекущаяСтрока.Параметр;



КонецПроцедуры

Процедура ДанныеКолонкиonclick(Элемент, pEvtObj)
	РаботаСДиалогами.ПолеHTMLДокументаOnClick(Элемент, pEvtObj, ЭтаФорма);
КонецПроцедуры

Процедура ДанныеКолонкиonmouseout(Элемент, pEvtObj)
	РаботаСДиалогами.ПолеHTMLДокументаOnMouseOut(Элемент, pEvtObj);
КонецПроцедуры

Процедура ДанныеКолонкиonmouseover(Элемент, pEvtObj)
		РаботаСДиалогами.ПолеHTMLДокументаOnMouseOver(Элемент, pEvtObj);
КонецПроцедуры

Процедура ПараметрыДанныхПриАктивизацииСтроки(Элемент)
	
	//Номер колонки может быть как двухзначеным, так и однозначным
	ДвеЦифры = Строка(Прав(Элемент.ТекущиеДанные.Параметр,2));
	Если Лев(ДвеЦифры,1) = "а" Тогда
		НомерКолонки = Число(Прав(ДвеЦифры,1))
	Иначе
		НомерКолонки = Число(ДвеЦифры)
	КонецЕсли;
	ВывестиИнформациюОКолонке(НомерКолонки);

КонецПроцедуры

Процедура КоманднаяПанельДереваСтруктурыЗаполнениеПоУмолчанию(Кнопка)
	
	ЗаполнитьПараметры(,Истина);
КонецПроцедуры

Процедура ПередЗакрытием(Отказ, СтандартнаяОбработка)
	Если СамостоятельнаяНастройка Тогда
		СохраненныеНастройки = КомпоновщикНастроек.ПолучитьНастройки();
	КонецЕсли;	
КонецПроцедуры

