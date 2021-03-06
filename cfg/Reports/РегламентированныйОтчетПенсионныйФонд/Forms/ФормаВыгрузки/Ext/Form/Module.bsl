
Процедура ПриОткрытии()
	
	
	//Восстановим значение Каталога для выгрузки РегОтчетов
	КаталогДанных = ВосстановитьЗначение("КаталогДанныхОтчетПенсионныйФонд");

КонецПроцедуры

Процедура ПриЗакрытии()
	//Сохраним значение Каталога для выгрузки РегОтчетов
	СохранитьЗначение("КаталогДанныхОтчетПенсионныйФонд",КаталогДанных);

КонецПроцедуры

Процедура ОсновныеДействияФормыВыгрузитьВАРМЗС(Кнопка)
	ВыгрузитьВАРМЗС();
	ЭтаФорма.Закрыть();
КонецПроцедуры

Процедура ВыгрузитьПоТаблице(ТаблицаЗначений)
	Перем ДанныеФормы;
	фОшибка = 0; 
	КодФормы        =  ТаблицаЗначений[0].ИмяВФайле;
	День            = ДополнитьСтрокуСимволами(Строка(День(ДатаПодписи)),"0",2,1);
	Месяц           = ДополнитьСтрокуСимволами(Строка(Месяц(ДатаПодписи)),"0",2,1);
	Год             = Формат(Год(ДатаПодписи),"ЧГ=");
	КодОрганизации  = ДанныеОтчета.ОргКодЕДРПОУ;
	ИмяФайла        = КодОрганизации + Формат (День,"ЧЦ=2;ЧГ=;") + Формат(Месяц, "ЧЦ=2;ЧГ=;") + Год + КодФормы + ".ZDI";
	
	Текст = Новый ЗаписьТекста(КаталогДанных+"\"+ИмяФайла,КодировкаТекста.ANSI);
	Текст.ЗаписатьСтроку("PerType=M" + ПолучитьКодМесяца(МесяцЗаполненияОтчета));
	Текст.ЗаписатьСтроку("Year="+ Год);
	Текст.ЗаписатьСтроку("Encodіng=ANSІ");
	СчетчикТаблиц = 1 ;
	
	Для Нстр = 1 по  ТаблицаЗначений.Количество()-2 Цикл
		ИмяВФайле     = ТаблицаЗначений[Нстр].ИмяВФайле;
		ПредИмяВФайле = ТаблицаЗначений[Нстр-1].ИмяВФайле;
		СледИмяВФайле =ТаблицаЗначений[Нстр+1].ИмяВФайле;
		
		ДанныеОтчета.Свойство(ТаблицаЗначений[Нстр].ИмяВФорме,ДанныеФормы);
		
		Если ТипЗнч(ДанныеФормы) = Тип("Число") Тогда 
			ДанныеФормы = Формат (ДанныеФормы, "ЧГ= ;");
		КонецЕсли;
		
		Если Сред(ИмяВФайле,1,1) ="{"  и Не Сред(ПредИмяВФайле,СтрДлина(ИмяВФайле),1) ="}" Тогда 
			Текст.ЗаписатьСтроку("GROUP " + """" + КодФормы +"." + строка(СчетчикТаблиц)+"""" );
				 Текст.ЗаписатьСтроку("{");
			Если  Сред(ИмяВФайле,(СтрДлина(ИмяВФайле)-1),2) =  "A1" Тогда 			
				 Текст.ЗаписатьСтроку( КодФормы +"." + Сред(ИмяВФайле,2,СтрДлина(ИмяВФайле)-1) + "=" + ДанныеФормы);
				 Если Не ДанныеФормы = "" Тогда
				 	КодМесяца = НомерМесяца(ДанныеФормы);   	 
				 	Текст.ЗаписатьСтроку( КодФормы +"." +Сред(ИмяВФайле,2,СтрДлина(ИмяВФайле)-1) + "1" + "=" + КодМесяца);
				 КонецЕсли;
			 Иначе
		         Текст.ЗаписатьСтроку(КодФормы+"."+ ИмяВФайле + "=" +ДанныеФормы);
			 КонецЕсли;
		ИначеЕсли  Сред(ИмяВФайле,1,1) ="{"  и Сред(ПредИмяВФайле,СтрДлина(ПредИмяВФайле),1) ="}" Тогда 
			Если  Сред(ИмяВФайле,(СтрДлина(ИмяВФайле)-1),2) =  "A1" Тогда 
				 Текст.ЗаписатьСтроку("{");
				 Текст.ЗаписатьСтроку( КодФормы +"." + Сред(ИмяВФайле,2,СтрДлина(ИмяВФайле)-1) + "=" +ДанныеФормы);
				 Если Не ДанныеФормы = "" Тогда
					КодМесяца = НомерМесяца(ДанныеФормы);  
				 	Текст.ЗаписатьСтроку( КодФормы +"." +Сред(ИмяВФайле,2,СтрДлина(ИмяВФайле)-1) +"1" + "=" + КодМесяца);
				 КонецЕсли;
          	Иначе
		         Текст.ЗаписатьСтроку( КодФормы +"." + ИмяВФайле + "=" +ДанныеФормы);
			 КонецЕсли;   
		ИначеЕсли Сред(ИмяВФайле,СтрДлина(ИмяВФайле),1) ="}" И  Сред(СледИмяВФайле,1,1) ="{" Тогда
			Текст.ЗаписатьСтроку( КодФормы +"." + Сред(ИмяВФайле,1,(СтрДлина(ИмяВФайле)-1)) +"="+ ДанныеФормы);
			Текст.ЗаписатьСтроку("}"); 
		ИначеЕсли Сред(ИмяВФайле,СтрДлина(ИмяВФайле),1) ="}" И  НЕ Сред(СледИмяВФайле,1,1) ="{" Тогда
			Текст.ЗаписатьСтроку( КодФормы +"." +Сред(ИмяВФайле,1,(СтрДлина(ИмяВФайле)-1))+ "=" + ДанныеФормы); 
			Текст.ЗаписатьСтроку("}");
			Текст.ЗаписатьСтроку("GROUP " + """"+ КодФормы +"." + строка(СчетчикТаблиц)+ """" + " END");
			СчетчикТаблиц = СчетчикТаблиц + 1;
		Иначе 
			Текст.ЗаписатьСтроку( КодФормы +"." + ТаблицаЗначений[Нстр].ИмяВФайле + "=" +ДанныеФормы);
		КонецЕсли; 
   КонецЦикла; 

	Текст.Закрыть();
    	
	
КонецПроцедуры	

Функция ДополнитьСтрокуСимволами(Стр,Чем,Длина,Режим=1) Экспорт
	Добавить=Длина-СтрДлина(Стр);
	Если Добавить>0  Тогда
		Добавок="";
		Для Сч = 1 По Добавить  Цикл
			Добавок=Добавок+Чем
		КонецЦикла;
		Возврат ?(Режим=1,Добавок+Стр,Стр+Добавок);
	Иначе
		Возврат	Стр;
	КонецЕсли;
КонецФункции

Процедура ВыгрузитьВАРМЗС() 
	
	
	// делаем разбор схем
    ТаблицаЗначений = РазборМакета();
	ВыгрузитьПоТаблице(ТаблицаЗначений);
	
	Сообщить(НСтр("ru='Отчет успешно выгружен!';uk='Звіт успішно вивантажений!';"),СтатусСообщения.Информация);
		 		
   	
КонецПроцедуры	

Функция НомерМесяца(Месяц)
	
	 ВрегМесяц = Врег(Месяц);
 	 Если Не ВрегМесяц = "" Тогда  	 
		Если  ВрегМесяц= "СІЧЕНЬ" Тогда
			номер = 1    ;
			Возврат номер ; 
		ИначеЕсли  ВрегМесяц = "ЛЮТИЙ" Тогда
			номер = 2    ;
			Возврат номер ;
		ИначеЕсли	 ВрегМесяц = "БЕРЕЗЕНЬ" Тогда
			номер = 3    ;
			Возврат номер ;
		ИначеЕсли	ВрегМесяц = "КВІТЕНЬ" Тогда
			номер = 4    ;
			Возврат номер ;
		ИначеЕсли	 ВрегМесяц = "ТРАВЕНЬ" Тогда
			номер = 5    ;
			Возврат номер ;
		ИначеЕсли	 ВрегМесяц = "ЧЕРВЕНЬ" Тогда
			номер = 6    ;
			Возврат номер ;
		ИначеЕсли	 ВрегМесяц = "ЛИПЕНЬ" Тогда
			номер = 7    ;
			Возврат номер ;
		ИначеЕсли	ВрегМесяц = "СЕРПЕНЬ" Тогда
			номер = 8    ;
			Возврат номер ;
		ИначеЕсли	ВрегМесяц = "ВЕРЕСЕНЬ" Тогда
			номер = 9    ;
			Возврат номер ;
		ИначеЕсли	 ВрегМесяц = "ЖОВТЕНЬ" Тогда
			номер = 10    ;
			Возврат номер ;
		ИначеЕсли	 ВрегМесяц = "ЛИСТОПАД" Тогда
			номер = 11    ;
			Возврат номер ;
   		ИначеЕсли	 ВрегМесяц = "ГРУДЕНЬ" Тогда
			номер = 12    ;
			Возврат номер;
		КонецЕсли;
	КонецЕсли;
	
КонецФункции
	
Функция ПолучитьКодМесяца(Месяц)
		Если Месяц = 1 Тогда 
			КодМесяца = "1" ;
			Возврат КодМесяца;
		ИначеЕсли Месяц = 2 Тогда 
			КодМесяца = "2" ;
			Возврат КодМесяца;
		ИначеЕсли Месяц = 3 Тогда 
			КодМесяца = "3" ;
			Возврат КодМесяца;
		ИначеЕсли Месяц = 4 Тогда 
			КодМесяца = "4" ;
			Возврат КодМесяца;
		ИначеЕсли Месяц = 5 Тогда 
			КодМесяца = "5" ;
			Возврат КодМесяца;
		ИначеЕсли Месяц = 6 Тогда 
			КодМесяца = "6" ;
			Возврат КодМесяца;
		ИначеЕсли Месяц = 7 Тогда 
			КодМесяца = "7" ;
			Возврат КодМесяца;
		ИначеЕсли Месяц = 8 Тогда 
			КодМесяца = "8" ;
			Возврат КодМесяца;
		ИначеЕсли Месяц = 9 Тогда 
			КодМесяца = "9" ;
			Возврат КодМесяца;
		ИначеЕсли Месяц = 10 Тогда 
			КодМесяца = "A" ;
			Возврат КодМесяца;
		ИначеЕсли Месяц = 11 Тогда 
			КодМесяца = "B" ;
			Возврат КодМесяца;
		ИначеЕсли Месяц = 12 Тогда 
			КодМесяца = "C" ;
			Возврат КодМесяца;
		Иначе КодМесяца = "";
			Возврат КодМесяца; 
		
	КонецЕсли;	
КонецФункции

Функция РазборМакета ()
	
	ОписаниеТиповСтрока20  = ОбщегоНазначения.ПолучитьОписаниеТиповСтроки(20);
	НужныйМакет = Макет;
	ТаблицаНазванияВФайле = новый ТаблицаЗначений();
	ТаблицаНазванияВФайле.Колонки.Добавить("ИмяВФорме", ОписаниеТиповСтрока20);
	ТаблицаНазванияВФайле.Колонки.Добавить("ИмяВФайле", ОписаниеТиповСтрока20 );
	
	Для Инд = 0 По НужныйМакет.Области.Количество() - 1 Цикл
		ТекОбласть    = НужныйМакет.Области[Инд];
		ИмяСтраницы   = ТекОбласть.Имя;
		
		Для Ном = ТекОбласть.Верх По ТекОбласть.Низ Цикл
			// код показателя по форме отчете (имя ячейки в полях табличного документа формы)
			КодПоказателяПоФорме = СокрЛП(НужныйМакет.Область(Ном, 1).Текст);
			// признак многострочности определяется по третьей колонке макета
			КодПоказателяВФайле  = СокрЛП(НужныйМакет.Область(Ном, 2).Текст);
			НоваяСтрока           =  ТаблицаНазванияВФайле.Добавить();
			НоваяСтрока.ИмяВФорме = КодПоказателяПоФорме;
			НоваяСтрока.ИмяВФайле = КодПоказателяВФайле;
		КонецЦикла;	
	КонецЦикла;
	Возврат ТаблицаНазванияВФайле;
КонецФункции

Процедура КаталогДанныхНачалоВыбора(Элемент, СтандартнаяОбработка)
	   Диалог = Новый ДиалогВыбораФайла(РежимДиалогаВыбораФайла.ВыборКаталога);
	Диалог.Заголовок = НСтр("ru='Выберите каталог сохранения zpi файлов';uk='Виберіть каталог збереження zpi файлів'");

	Если Диалог.Выбрать() Тогда
		КаталогДанных = Диалог.Каталог;
	КонецЕсли;

КонецПроцедуры




