﻿Перем ЧислоСтраниц, РазрешитьДалее;
Перем РазрешитьЗакрытиеФормы;    
Перем РесурсОписание, РесурсVerId, РесурсДистрибутива; 
Перем СерверИсточник, АдресРесурсов;
Перем ФайлУстановки, КаталогОбновлений;

////////////////////////////////////////////////////////////////////////////////
// ПРОЦЕДУРЫ И ФУНКЦИИ ОБЩЕГО НАЗНАЧЕНИЯ

// Вспомогательная функция преобразования русских символов в латиницу
Функция Рус_Лат(Имя)
	СтрЛат = "0123456789_ABCDEFGHIJKLMNOPQRSTUVWXYZ______";
	СтрРус = "0123456789_АБЦДЕФГЧИЖКЛМНОПЭРСТЮВЯХУЗЙШЩЬЫЪ";
	ТрансИмя = "";
	Для Н = 1 По СтрДлина(Имя) Цикл
		Если КодСимвола(Сред(Имя,Н,1)) > 1000 Тогда
			ТрансИмя = ТрансИмя + Сред(СтрЛат,Найти(СтрРус,Врег(Сред(Имя,Н,1))),1);
		Иначе
			ТрансИмя = ТрансИмя + Врег(Сред(Имя,Н,1));
		КонецЕсли;
	КонецЦикла;
	Возврат ТрансИмя;
КонецФункции

// Чтение данных по обновлению из файла UpdInfo.txt
// Вычисляются: 
//		номер версии обновления на сервере, 
//		номера версий, с которых производится обновление (раздляются символом ";")
//		дата публикации обновления
//
// Параметры:
//  ИмяФайла - полное имя файла UpdInfo.txt
// 
// Возвращаемое значение:
//  Структура: 
//		Version - версия обновления
//		FromVersions - с каких версий обновляет
//		UpdateDate - дата опубликования
//  Неопределено - если файл не найден или не содержит нужных значений
//
Функция ПараметрыДистрибутива(ИмяФайла)
	Файл = Новый Файл(ИмяФайла);
	Если Файл.Существует() Тогда
		ТД = Новый ТекстовыйДокумент(); 
		ТД.Прочитать(Файл.ПолноеИмя);
		ПарКомпл = Новый Структура();
		Для Н=1 По ТД.КоличествоСтрок() Цикл
			СтрТмп = НРег(СокрЛП(ТД.ПолучитьСтроку(Н)));
			Если Найти(СтрТмп,"fromversions=")>0 Тогда
				СтрТМП = СокрЛП(Сред(СтрТмп,Найти(СтрТмп,"fromversions=")+СтрДлина("fromversions=")));
				СтрТМП = ?(Лев(СтрТМП,1)=";","",";") + СтрТмп + ?(Прав(СтрТМП,1)=";","",";");
				ПарКомпл.Вставить("FromVersions",СтрТМП);
			ИначеЕсли Найти(СтрТмп,"version=")>0 Тогда
				ПарКомпл.Вставить("Version",Сред(СтрТмп,Найти(СтрТмп,"version=")+СтрДлина("version=")));
			ИначеЕсли Найти(СтрТмп,"updatedate=")>0 Тогда
				// формат даты = Дата, 
				СтрТмп = Сред(СтрТмп,Найти(СтрТмп,"updatedate=")+СтрДлина("updatedate="));
				Если СтрДлина(СтрТмп)>8 Тогда
					Если Найти(СтрТмп,".")=5 Тогда
						// дата в формате  ГГГГ.ММ.ДД
						СтрТмп = СтрЗаменить(СтрТмп,".","");
					ИначеЕсли Найти(СтрТмп,".")=3 Тогда
						// дата в формате ДД.ММ.ГГГГ
						СтрТмп = Прав(СтрТмп,4)+Сред(СтрТмп,4,2)+Лев(СтрТмп,2);
					Иначе 
						// дата в формате ГГГГММДД
					КонецЕсли;
				КонецЕсли;
				ПарКомпл.Вставить("UpdateDate",Дата(СтрТмп));
			Иначе
				Возврат "Неверный формат сведений о наличии обновлений";
			КонецЕсли;
		КонецЦикла;
		Возврат ПарКомпл;
	Иначе
		Возврат "Файл описания обновлений не получен";
	КонецЕсли;
КонецФункции

// Процедура ПоказКнопок
//   Проверяется возможность использования кнопки "Далее"
//   Открывается нужная страница мастера
Процедура ПоказКнопок(ТекСтраница)
	ЭлементыФормы.КоманднаяПанель1.Кнопки.Далее.Доступность = РазрешитьДалее;
	ЭлементыФормы.КоманднаяПанель1.Кнопки.Далее.Текст = ?(ТекСтраница=ЧислоСтраниц-1, "Готово", "Далее >");
	ЭлементыФормы.КоманднаяПанель1.Кнопки.Назад.Доступность = ?(ТекСтраница=0, Ложь, ?(ТекСтраница=ЧислоСтраниц-1,Ложь,Истина));
	ЭлементыФормы.Панель1.ТекущаяСтраница = ЭлементыФормы.Панель1.Страницы[ТекСтраница];
КонецПроцедуры

// Возвращает на предыдущую страницу мастера
Процедура Назад(Элемент)
	ТекущаяСтраница = Макс(ТекущаяСтраница-1,0);
	РазрешитьДалее = Истина;
	ПоказКнопок(ТекущаяСтраница);
КонецПроцедуры

// Переход на сл. страницу мастера
Процедура Далее(Элемент)
	Если ТекущаяСтраница=(ЧислоСтраниц-1) Тогда
		ЭтаФорма.Закрыть();
	ИначеЕсли ТекущаяСтраница=0 Тогда
		ЭлементыФормы.Панель2.ТекущаяСтраница = ЭлементыФормы.Панель2.Страницы[Число(Не Проверить())];
	Иначе
		Если ТекущаяСтраница=1 Тогда
			ЭлементыФормы.КоманднаяПанель1.Кнопки.Далее.Доступность = Ложь;
			ЭлементыФормы.КоманднаяПанель1.Кнопки.Назад.Доступность = Ложь;
			ЭлементыФормы.КоманднаяПанель1.Кнопки.Закрыть.Доступность = Ложь;
			Если Не ПолучитьДистрибутив() Тогда
				ТекущаяСтраница = ТекущаяСтраница - 1;
			КонецЕсли;
		КонецЕсли;
		РазрешитьДалее = Ложь;
	КонецЕсли;
	ТекущаяСтраница = Мин(ТекущаяСтраница+1,ЧислоСтраниц-1);
	ПоказКнопок(ТекущаяСтраница);
КонецПроцедуры

// Получение заданного ресурса
//
// Параметры:
//  Ресурс - имя файл-ресурса (возможные значения: UpdInfo.txt; News.hml; UpdSetup.exe)
// Возвращаемое значение:
//  Имя файла полученного ресурса. Тип - Строка. Если не получен - пустая строка
//
Функция Получить(Ресурс)
	Перем HTTP;
	СоздатьКаталог(КаталогОбновлений);
	Попытка
		УдалитьФайлы(КаталогОбновлений,"*.*");
	Исключение
		Сообщить(НСтр("ru='Каталог для получения комплекта ';uk='Каталог для отримання комплекту '")+КаталогОбновлений+НСтр("ru=' занят. Получение невозможно.';uk=' зайнятий. Отримання неможливо.'"));
		Возврат "";
	КонецПопытки;
	ОбработкаПолученияФайлов = Обработки.ПолучениеФайловИзИнтернета.Создать();
	Если ОбработкаПолученияФайлов.ЗапроситьФайлыССервера(СерверИсточник, АдресРесурсов+Ресурс, КаталогОбновлений + "\" + Ресурс, HTTP) <> Истина Тогда
		Сообщить(НСтр("ru='Не удалось получить ресурс ';uk='Не вдалося одержати ресурс '") + Ресурс ); 
		Возврат "";
	КонецЕсли; 
	Файл =  Новый Файл(КаталогОбновлений + "\" + Ресурс);
	Если Файл.ПолучитьТолькоЧтение() Тогда
		Файл.УстановитьТолькоЧтение(Ложь);
	КонецЕсли;
	Возврат КаталогОбновлений + "\" + Ресурс;
КонецФункции

// Получает файл UpdInfo.txt и по номерам версий проверяет наличие обновлений
//
Функция Проверить() Экспорт
	Перем ПараметрВозврата;
	ИмяФайла = Получить(РесурсVerId);
	РазрешитьДалее = Истина;
	ПараметрВозврата = Истина;
	Если НЕ ПустаяСтрока(ИмяФайла) Тогда
		стПараметры = ПараметрыДистрибутива(ИмяФайла);

		Если ТипЗнч(стПараметры)=Тип("Строка") Тогда
			Сообщить(стПараметры);
			ЭлементыФормы.НажатиеДалее.Видимость = Ложь;
			РазрешитьДалее = Ложь;
		Иначе 
			Если стПараметры.Version<>Метаданные.Версия Тогда
				Если Найти(стПараметры.FromVersions,СокрП(Метаданные.Версия)+";")=0 Тогда
					ЭлементыФормы.РезультатПроверки.Значение = "Комплект поставки на вэб-сервере не может быть использован для обновления текущей конфигурации."+Символы.ПС+ 
							"Используйте диск ИТС!";
					ЭлементыФормы.НажатиеДалее.Видимость = Ложь;
					РазрешитьДалее = Ложь;
				Иначе
					ЭлементыФормы.РезультатПроверки.Значение = "На вэб-сервере обнаружен комплект поставки для обновления конфигурации!";
					ЭлементыФормы.НажатиеДалее.Видимость = Истина;
				КонецЕсли;
			Иначе
				ЭлементыФормы.РезультатПроверки.Значение = "Обновление конфигурации не требуется!";
				ЭлементыФормы.НажатиеДалее.Видимость = Ложь;
				РазрешитьДалее = Ложь;
			КонецЕсли; 
			ЭлементыФормы.ВерсияДистрибутива.Значение = стПараметры.Version;
			ЭлементыФормы.СВерсий.Значение = СокрЛП(СтрЗаменить(стПараметры.FromVersions,";","  "));
			ЭлементыФормы.ДатаВерсии.Значение = Формат(стПараметры.UpdateDate,"ДФ=dd.MM.yyyy");
			ДатаПроверки = ТекущаяДата();
			СохранитьЗначение("ИПП8_ДатаПроверки",ДатаПроверки);
			ЭлементыФормы.Надпись4.Видимость = Истина;
			ЭлементыФормы.ТекущаяВерсия.Значение = "Текущая версия: "+Метаданные.Версия+?(ДатаПроверки=Дата("00000000"),"",";   Проверка выполнялась: "+ДатаПроверки) ;
			ПоказКнопок(ТекущаяСтраница);
		КонецЕсли; 
	Иначе
		// Инфо о дистрибутиве не получена (нет соединения / нет обновления / ???)
		РазрешитьДалее = Ложь;
		ЭлементыФормы.НажатиеДалее.Видимость = Ложь;
		ПараметрВозврата = Ложь;
	КонецЕсли;
	Возврат ПараметрВозврата;
КонецФункции

// Открывает описание обновлений
//
Процедура ПоказатьОписание(Элемент)
	ФормаПросмотра = ЭтотОбъект.ПолучитьФорму("ПросмотрHTTP");
	ФормаПросмотра.Ресурс = СерверИсточник+АдресРесурсов+РесурсОписание;
	ФормаПросмотра.Открыть();
КонецПроцедуры

// Запускает установку обновления
//
Процедура ЗапуститьУстановкуОбновления(ИмяФайлаУстановки)
	Файл = Новый Файл(ИмяФайлаУстановки);
	Если Файл.Существует() Тогда
		ЭлементыФормы.Надпись8.Видимость = Истина;
		ЭлементыФормы.КоманднаяПанель1.Кнопки.Далее.Доступность = Ложь;
		ЭлементыФормы.КоманднаяПанель1.Кнопки.Назад.Доступность = Ложь;
		ЭлементыФормы.КоманднаяПанель1.Кнопки.Закрыть.Доступность = Ложь;
		ЭлементыФормы.РезультатУстановкиДистрибутива.Значение = "Выполните действия по установке комплекта поставки обновления.";
		ЗапуститьПриложение(ИмяФайлаУстановки);
	Иначе
		ЭлементыФормы.Надпись8.Видимость = Ложь;
		ЭлементыФормы.РезультатУстановкиДистрибутива.Значение = "";
	КонецЕсли;
КонецПроцедуры

Процедура ПроверкаВозможностиЗавершения()
	Попытка
		УдалитьФайлы(КаталогОбновлений,ФайлУстановки);
		ЭлементыФормы.Надпись8.Значение = "Программа установки завершена";
		ЭлементыФормы.КоманднаяПанель1.Кнопки.Далее.Доступность = Истина; 
		ЭлементыФормы.КоманднаяПанель1.Кнопки.Назад.Доступность = Истина; 
		ЭлементыФормы.КоманднаяПанель1.Кнопки.Закрыть.Доступность = Истина; 
		ЭлементыФормы.РезультатУстановкиДистрибутива.Значение = "Для завершения работы Мастера нажмите кнопку ""Готово""";
		ОтключитьОбработчикОжидания("ПроверкаВозможностиЗавершения");
		РазрешитьЗакрытиеФормы = Истина;
	Исключение
		ЭлементыФормы.КоманднаяПанель1.Кнопки.Далее.Доступность = Ложь; 
		ЭлементыФормы.КоманднаяПанель1.Кнопки.Назад.Доступность = Ложь; 
		ЭлементыФормы.КоманднаяПанель1.Кнопки.Закрыть.Доступность = Ложь; 
		РазрешитьЗакрытиеФормы = Ложь;
	КонецПопытки;
КонецПроцедуры 

// Получает дистрибутив обновления
Функция ПолучитьДистрибутив()
	ИмяФайла = Получить(РесурсДистрибутива);
	Если НЕ ПустаяСтрока(ИмяФайла) Тогда
		ИмяБатФайла = "" + КаталогОбновлений + "\Tmp.bat";
		БатФайл     = Новый ТекстовыйДокумент();
		БатФайл.Очистить();
		БатФайл.ДобавитьСтроку("cd """ + КаталогОбновлений + """");
		БатФайл.ДобавитьСтроку(РесурсДистрибутива);
		БатФайл.Записать(ИмяБатФайла,КодировкаТекста.ANSI);
		КомандаСистемы(""""+ ИмяБатФайла + """");
		ЭлементыФормы.РезультатПолученияДистрибутива.Значение = "Комплект поставки обновления получен";
		ЭлементыФормы.Надпись4.Видимость = Истина;
		ЭлементыФормы.Панель3.ТекущаяСтраница = ЭлементыФормы.Панель3.Страницы[0];
		ЗапуститьУстановкуОбновления(КаталогОбновлений+"\"+ФайлУстановки);
		ПодключитьОбработчикОжидания("ПроверкаВозможностиЗавершения",1);
		Возврат Истина;
	Иначе
		ЭлементыФормы.Панель3.ТекущаяСтраница = ЭлементыФормы.Панель3.Страницы[1];
		Сообщить(НСтр("ru='Комплект поставки обновления не получен';uk='Комплект поставки оновлення не отриманий'"));
		Возврат Ложь;
	КонецЕсли;
КонецФункции 


////////////////////////////////////////////////////////////////////////////////
// ПРОЦЕДУРЫ - ОБРАБОТЧИКИ СОБЫТИЙ ФОРМЫ

Процедура ПриОткрытии()
	ПоказКнопок(ТекущаяСтраница);
	ЭлементыФормы.ТекущаяВерсия.Значение = "Текущая версия: "+Метаданные.Версия+?(ДатаПроверки=Дата("00000000"),"",";   Проверка выполнялась: "+ДатаПроверки) ;
	ЭтаФорма.Заголовок = НСтр("ru='Проверка и установка обновлений';uk='Перевірка і встановлення оновлень'");
КонецПроцедуры

Процедура ПередЗакрытием(Отказ, СтандартнаяОбработка)
	Если РазрешитьЗакрытиеФормы Тогда
		РазрешитьУдаление = Ложь;
		Попытка
			УдалитьФайлы(КаталогОбновлений);
			РазрешитьУдаление = Истина;
			СохранитьЗначение("ИПП8_ПроверятьПриЗапуске",ПроверятьПриЗапуске);
			СохранитьЗначение("ИПП8_ЗапускКонфигуратора",ЗапускКонфигуратора);
			Если ТекущаяСтраница=(ЧислоСтраниц-1) Тогда
				Если ЗапускКонфигуратора Тогда
					ЗапуститьПриложение(КаталогПрограммы()+"\1cv8.exe /CONFIG");
				КонецЕсли;
			КонецЕсли;
		Исключение
			Отказ = Истина;
		КонецПопытки;
	Иначе
		Отказ = Истина;
	КонецЕсли;
КонецПроцедуры


ТекущаяСтраница = 0;

РесурсVerId = "UpdInfo.txt";
РесурсОписание = "NEWS.HTM";
РесурсДистрибутива = "updsetup.exe";
ФайлУстановки = "setup.exe";
СерверИсточник = "http://releases.1c.eu"; 
АдресРесурсов = "/ipp/ITSRepV/V8Update/Configs/"+Рус_Лат(Метаданные.Имя)+"/";
РазрешитьДалее = Истина;
РазрешитьЗакрытиеФормы = Истина;
ЧислоСтраниц = 3;

КаталогОбновлений = КаталогВременныхФайлов() + "tempIPP8";
СоздатьКаталог(КаталогОбновлений);

ЗапускКонфигуратора = ВосстановитьЗначение("ИПП8_ЗапускКонфигуратора");
ПроверятьПриЗапуске = ВосстановитьЗначение("ИПП8_ПроверятьПриЗапуске");
ДатаПроверки = ВосстановитьЗначение("ИПП8_ДатаПроверки");
Если (ДатаПроверки=Неопределено) ИЛИ (ДатаПроверки=Дата("00000000")) Тогда
	ДатаПроверки = Дата("00000000");
	ЭлементыФормы.Надпись4.Видимость = Ложь;
	ЗапускКонфигуратора = Истина;
КонецЕсли;

ЭлементыФормы.РезультатПроверки.Значение = "";

