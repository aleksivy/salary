
// СоздатьПочтовыйПрофиль
//
Функция СоздатьПочтовыйПрофиль( АдресСервераSMTP )
	
	Профиль = Новый ИнтернетПочтовыйПрофиль;
	
	Профиль.ИспользоватьSSLPOP3 = Истина;
	Профиль.АдресСервераPOP3 = "10.40.20.119";
	Профиль.ПортPOP3 = 995;
	Профиль.Пользователь = "RES-UA-IEV-ROBOT@anyaccess.net";
	Профиль.Пароль = "GAUR0b1C";
	
	Профиль.ИспользоватьSSLSMTP = Ложь;
	Профиль.АдресСервераSMTP = АдресСервераSMTP;
	Профиль.ПортSMTP = 587;
	Профиль.ПользовательSMTP = "RES-UA-IEV-ROBOT@anyaccess.net";
	Профиль.ПарольSMTP = "GAUR0b1C";   
	Профиль.ТолькоЗащищеннаяАутентификацияSMTP = Ложь;
	Профиль.АутентификацияSMTP = СпособSMTPАутентификации.Login;
	
	Возврат Профиль;
	
КонецФункции // СоздатьПочтовыйПрофиль

Процедура Инициализировать() Экспорт
	
	Если (ДокументНачисления = Неопределено) или (ДокументНачисления = Документы.НачислениеЗарплатыРаботникамОрганизаций.ПустаяСсылка())
		или (ДокументНачисления = Документы.РегистрацияРазовыхНачисленийРаботниковОрганизаций.ПустаяСсылка())Тогда
#Если Клиент Тогда
		Сообщить("Не указан документ начисления!");
#КонецЕсли
		Возврат;
	КонецЕсли;
	// Определим ручные корректировки по данному документу
	лЗапрос = Новый Запрос;
	лЗапрос.УстановитьПараметр("Ссылка", ДокументНачисления);
	лЗапрос.УстановитьПараметр("ДоплатаДоОтпускных", ПланыВидовРасчета.ОсновныеНачисленияОрганизаций.НайтиПоНаименованию("20. Доплата до відпускних"));
	лЗапрос.Текст = 
	"ВЫБРАТЬ
	|	ДокТЧ.Ссылка КАК Документ,
	|	ДокТЧ.Ссылка.Дата КАК Дата,
	|	ДокТЧ.Ссылка.Номер КАК Номер,
	|	ДокТЧ.НомерСтроки КАК НомерСтрокиДокумента,
	|	ДокТЧ.Сотрудник КАК СотрудникСсылка,
	|	ДокТЧ.Сотрудник.NameFamily + "" "" + ДокТЧ.Сотрудник.Name + "" "" + ДокТЧ.Сотрудник.NameSecond КАК Сотрудник,
	|	ДокТЧ.ВидРасчета.Name КАК ВидНачисления,
	|	ДокТЧ.ПодразделениеОрганизации.Name КАК ПодразделениеОрганизации,
	|	ДокТЧ.Должность.Name КАК Должность
	|ИЗ
	|	Документ.НачислениеЗарплатыРаботникамОрганизаций.Начисления КАК ДокТЧ
	|ГДЕ
	|	ДокТЧ.Ссылка.Проведен
	|	И НЕ ДокТЧ.Авторасчет
	|	И ДокТЧ.Ссылка = &Ссылка
	|	И НЕ ДокТЧ.ВидРасчета = ЗНАЧЕНИЕ(ПланВидовРасчета.ОсновныеНачисленияОрганизаций.МедицинскаяСтраховка)
	|	И НЕ ДокТЧ.ВидРасчета = &ДоплатаДоОтпускных
	|
	|ОБЪЕДИНИТЬ ВСЕ
	|
	|ВЫБРАТЬ
	|	ДокТЧ.Ссылка,
	|	ДокТЧ.Ссылка.Дата,
	|	ДокТЧ.Ссылка.Номер,
	|	ДокТЧ.НомерСтроки,
	|	ДокТЧ.Сотрудник,
	|	ДокТЧ.Сотрудник.NameFamily + "" "" + ДокТЧ.Сотрудник.Name + "" "" + ДокТЧ.Сотрудник.NameSecond,
	|	ДокТЧ.ВидРасчета.Name,
	|	ДокТЧ.ПодразделениеОрганизации.Name,
	|	ДокТЧ.Сотрудник.ТекущаяДолжностьОрганизации.Name
	|ИЗ
	|	Документ.РегистрацияРазовыхНачисленийРаботниковОрганизаций.ОсновныеНачисления КАК ДокТЧ
	|ГДЕ
	|	ДокТЧ.Ссылка.Проведен
	|	И НЕ ДокТЧ.Авторасчет
	|	И ДокТЧ.Ссылка = &Ссылка
	|	И НЕ ДокТЧ.ВидРасчета = ЗНАЧЕНИЕ(ПланВидовРасчета.ОсновныеНачисленияОрганизаций.МедицинскаяСтраховка)
	|	И НЕ ДокТЧ.ВидРасчета = &ДоплатаДоОтпускных
	|
	|УПОРЯДОЧИТЬ ПО
	|	ВидНачисления,
	|	Дата,
	|	Документ,
	|	Сотрудник
	|АВТОУПОРЯДОЧИВАНИЕ";
	лВыборка = лЗапрос.Выполнить().Выбрать();
	
	// Определим есть ли ручные корректировки
	Если лВыборка.Количество()=0 Тогда Возврат; КонецЕсли;
	
	лТекстПисьма = "<!DOCTYPE HTML PUBLIC ""-//W3C//DTD HTML 4.01//EN""" + Символы.ПС;
	лТекстПисьма=лТекстПисьма+"""http://www.w3.org/TR/html4/strict.dtd"">"+ Символы.ПС;
	лТекстПисьма=лТекстПисьма+"<html><head> <meta http-equiv=""Content-Type"" content=""text/html; charset=utf-8"">"+Символы.ПС;
	лТекстПисьма=лТекстПисьма+"<title>Employee payroll manual adjustments list</title>"+Символы.ПС;
	лТекстПисьма=лТекстПисьма+"<style type=""text/css""> table {border-collapse: collapse;} th {background: #aaa;text-align: left;}td, th {border: 1px solid #800; padding: 4px;} </style></head><body>"+Символы.ПС;
	лТекстПисьма=лТекстПисьма+"<B>Employee payroll manual adjustments list</B><br>"+Символы.ПС;
	лТекстПисьма=лТекстПисьма+"<br><i>Report created as of "+Формат(ТекущаяДата(),"ДФ=dd.MM.yyyy")+"  </i>"+Символы.ПС;
	
	лТекстПисьма=лТекстПисьма+"<TABLE width=""100%"" cellspacing=""0"" border=""1"">";
	лТекстПисьма=лТекстПисьма+"<tr><TH>Document</TH><TH>Document Date</TH><TH>Document #</TH><TH>Doc Row #</TH><TH>Kind of payroll</TH><TH>Employee</TH><TH>Department</TH><TH>Position</TH></tr>"+Символы.ПС;
		
	Пока лВыборка.Следующий() Цикл 
		лТекстПисьма=лТекстПисьма+"<TR><TD>"+ лВыборка.Документ +"</TD><TD>" + Формат(лВыборка.Дата, "ДФ=dd.MM.yyyy") + "</TD><TD>" + лВыборка.Номер + "</TD><TD>" + лВыборка.НомерСтрокиДокумента +"</TD><TD>"+ лВыборка.ВидНачисления +"</TD><TD>"+ лВыборка.Сотрудник +"</TD><TD>"+ лВыборка.ПодразделениеОрганизации +"</TD><TD>"+ лВыборка.Должность +"</TD></TR>";	
	КонецЦикла;	
		
	лТекстПисьма=лТекстПисьма+"</TABLE>";
	лТекстПисьма = лТекстПисьма+"</BODY></HTML>";
	
	Письмо = Новый ИнтернетПочтовоеСообщение;
	Письмо.Тема = "Employee payroll manual adjustments!";
	
	Письмо.Отправитель = "Robot1C.Kyiv@glencore.com.ua";
	Письмо.ИмяОтправителя = "Robot1C.Kyiv";
	//Письмо.Получатели.Добавить("Aleksandr.Plyushchev@glencore.com.ua");
	Письмо.Получатели.Добавить("aleksandr.moskalchuk@glencore.com.ua");
	Письмо.Копии.Добавить("inna.moskvina@glencore.com.ua");
	Письмо.СлепыеКопии.Добавить("Aleksandr.Plyushchev@glencore.com.ua");
	
	Текст = Письмо.Тексты.Добавить(лТекстПисьма, ТипТекстаПочтовогоСообщения.HTML);
	
	лПочта = Новый ИнтернетПочта;
	
	лСписокАдресСервераSMTP = Новый СписокЗначений;
	//"smtp2.nl.glencore.net";
	лСписокАдресСервераSMTP.Добавить("10.40.99.123","");
	лСписокАдресСервераSMTP.Добавить("10.40.98.120","");
	лСписокАдресСервераSMTP.Добавить("10.40.98.121","");
	лСписокАдресСервераSMTP.Добавить("10.40.99.122","End");
	Для каждого лСтрока Из лСписокАдресСервераSMTP Цикл
		Профиль = СоздатьПочтовыйПрофиль(лСтрока.Значение);
		Попытка
			лПочта.Подключиться(Профиль);
			лПочта.Послать(Письмо);
			лПисьмоОтправлено = Истина;
		Исключение
#Если Клиент Тогда
			Сообщить("Не удалось отправить письмо по ip адресу: """ + Профиль.АдресСервераSMTP + """");   
			Если лСтрока.Представление = "End" Тогда 
				Сообщить(ОписаниеОшибки() + " по ip адресу: """ + Профиль.АдресСервераSMTP + """");   //Выводить только если это последний адрес из списка значений
			КонецЕсли;
#КонецЕсли
			лПисьмоОтправлено = Ложь;
		КонецПопытки;
		
		Если лПисьмоОтправлено Тогда Прервать; КонецЕсли;
	КонецЦикла;
	лПочта.Отключиться();   
	
КонецПроцедуры
