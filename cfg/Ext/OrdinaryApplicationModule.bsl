Перем глОбщиеЗначения Экспорт;

Перем АдресРесурсовОбозревателя Экспорт; // В переменной содержится значение 
                                         // адреса ресурса данной конфигурации
Перем ФормаОжиданияКурсов;

Перем глМенеджерЗвит1С Экспорт;

// перед началом работы системы
Процедура ПередНачаломРаботыСистемы(Отказ)
	
	Если (НЕ РольДоступна("Пользователь")) И (НЕ РольДоступна("ПолныеПрава")) Тогда
		Предупреждение(НСтр("ru='Вам не назначена роль ""Пользователь"". Запуск конфигурации невозможен.';uk='Вам не призначено роль ""Користувач"". Запуск конфігурації неможливий.'"));
		Отказ = Истина;
		Возврат;
	КонецЕсли;
	
	Отказ = НЕ УправлениеПользователями.ПользовательОпределен();
		
КонецПроцедуры
	
// Процедура осуществляет проверку на необходимость обмена данными с заданным интервалом
Процедура ПроверкаОбменаДанными() Экспорт

	Если глЗначениеПеременной("глОбработкаАвтоОбменДанными") = Неопределено Тогда
		Возврат;
	КонецЕсли;		
	
	ОтключитьОбработчикОжидания("ПроверкаОбменаДанными");
	
	// проводим обмен данными
	глЗначениеПеременной("глОбработкаАвтоОбменДанными").ПровестиОбменДанными(); 
		
	ПодключитьОбработчикОжидания("ПроверкаОбменаДанными", глЗначениеПеременной("глКоличествоСекундОпросаОбмена"));

КонецПроцедуры

// при начале работы системы
Процедура ПриНачалеРаботыСистемы()

	КонтрольВерсииПлатформы.ПроверитьВерсиюПлатформы();  
	ПервыйЗапуск = (Константы.НомерВерсииКонфигурации.Получить()="");

	ЗаголовокСистемы = Константы.ЗаголовокСистемы.Получить();
	Если НЕ Пустаястрока(ЗаголовокСистемы) Тогда
		УстановитьЗаголовокСистемы(ЗаголовокСистемы);
	КонецЕсли;
	
	Если УправлениеПользователями.ПолучитьЗначениеПоУмолчанию(глЗначениеПеременной("глТекущийПользователь"), "ОткрыватьПриЗапускеРабочийСтол") Тогда
		ОбработкаРабочийСтол = ПроцедурыУправленияПерсоналом.ПолучитьОбработкуРабочийСтол(глЗначениеПеременной("глТекущийПользователь"));
		ОбработкаРабочийСтол.ПолучитьФорму().Открыть();
	КонецЕсли;
	
	Если ВосстановитьЗначение("ПроверкаНаличияОбновленияПроверятьПриЗапуске") = Истина Тогда

		Обозреватель = Обработки.Обозреватель.Создать();
		Форма        = Обозреватель.ПолучитьФорму("ПроверкаНаличияОбновления");

		Если Обозреватель.Проверить(Форма.ЭлементыФормы) Тогда            		

			Если ВосстановитьЗначение("ПроверкаНаличияОбновленияПоказПриПоявленииНовойВерсии") = Истина Тогда
				
				ВерсияДистрибутива = ВосстановитьЗначение("ПроверкаНаличияОбновленияПоследняяВерсия");
				
				Если ВерсияДистрибутива <> Форма.ЭлементыФормы.ВерсияДистрибутива.Значение Тогда
					Форма.Открыть();
				КонецЕсли;

			Иначе
				Форма.Открыть();
			КонецЕсли;

		КонецЕсли;

	КонецЕсли;
	
	    
	ЗапретитьОткрытиеНесколькихСеансов = УправлениеПользователями.ПолучитьЗначениеПоУмолчанию(глЗначениеПеременной("глТекущийПользователь"), "ЗапретитьОткрытиеНесколькихСеансов");
	Если ЗапретитьОткрытиеНесколькихСеансов Тогда
		ТекущийНомерСоединения = НомерСоединенияИнформационнойБазы();
		УникальныйИдентификаторПользователя = ПользователиИнформационнойБазы.ТекущийПользователь().УникальныйИдентификатор;
		
		МассивСоединений = ПолучитьСоединенияИнформационнойБазы();
		Для Каждого ТекСоединение Из МассивСоединений Цикл
			Если (ТекСоединение.ИмяПриложения = "1CV8") 
			   И (НЕ ТекСоединение.НомерСоединения = ТекущийНомерСоединения)
			   И (НЕ ТекСоединение.Пользователь = неопределено)
			   И (ТекСоединение.Пользователь.УникальныйИдентификатор = УникальныйИдентификаторПользователя) Тогда
			  
				Предупреждение(НСтр("ru='Пользователем с таким именем уже выполнен вход в систему';uk='Користувач з таким іменем вже виконаний вхід в систему'"));
				ЗавершитьРаботуСистемы(Ложь);
				Возврат;
				
			КонецЕсли;
		КонецЦикла;	
	КонецЕсли;
	
	ОбновлениеИнформационнойБазы.ВыполнитьОбновлениеИнформационнойБазы();
	
	// Выполнить проверку разницы времени с сервером приложения
	Если НЕ ПроверкаРазницыВремениКлиент.ВыполнитьПроверку() Тогда
		Возврат;	
	КонецЕсли;
 	
	Если ОбработатьПараметрыЗапуска(ПараметрЗапуска) Тогда
		Возврат;
	КонецЕсли;
	
	ЗавершениеРаботыПользователей.УстановитьКонтрольРежимаЗавершенияРаботыПользователей();
	
	СформироватьОтчеты();

	ПроверитьПодключениеОбработчикаОжидания(Истина);

	// Проверка заполнения констант валют учетов
	Если НЕ ЗначениеЗаполнено(Константы.ВалютаРегламентированногоУчета.Получить()) Тогда
		ОбщегоНазначения.СообщитьОбОшибке(НСтр("ru='Не заполнена константа валюты регламентированного учета!';uk='Не заповнена константа валюти регламентованого обліку!'"));
	КонецЕсли;
	Если НЕ ЗначениеЗаполнено(Константы.ВалютаУправленческогоУчета.Получить()) Тогда
		ОбщегоНазначения.СообщитьОбОшибке(НСтр("ru='Не заполнена константа валюты управленческого учета!';uk='Не заповнена константа валюти управлінського обліку!'"));
	КонецЕсли;

		
	ЭтоФайловаяИБ = ОпределитьЭтаИнформационнаяБазаФайловая();
		
	Если ЭтоФайловаяИБ Тогда
						
		ПользовательДляВыполненияРеглЗаданий = Константы.ПользовательДляВыполненияРегламентныхЗаданийВФайловомВарианте.Получить();
			
		Если глЗначениеПеременной("глТекущийПользователь") = ПользовательДляВыполненияРеглЗаданий Тогда
				
			// с интервалом секунд вызываем процедуру работы с регламентными заданиями
			ПоддержкаРегламентныхЗаданиеДляФайловойВерсии();
				
			ИнтервалДляОпроса = Константы.ИнтервалДляОпросаРегламентныхЗаданийВФайловомВарианте.Получить();
				
			Если ИнтервалДляОпроса = Неопределено
				ИЛИ ИнтервалДляОпроса = 0 Тогда
					
				ИнтервалДляОпроса = 60;	
					
			КонецЕсли;
				
			ПодключитьОбработчикОжидания("ПоддержкаРегламентныхЗаданиеДляФайловойВерсии", ИнтервалДляОпроса);
				
		КонецЕсли;
			
	КонецЕсли;

	Если глЗначениеПеременной("глОбработкаАвтоОбменДанными") <> Неопределено Тогда
		// подключим обработчик обменов данными
		ПодключитьОбработчикОжидания("ПроверкаОбменаДанными", глЗначениеПеременной("глКоличествоСекундОпросаОбмена"));
	КонецЕсли;
		
	НачатьПроверкуДинамическогоОбновленияИБ();

	Если УправлениеПользователями.ПолучитьЗначениеПоУмолчанию(глЗначениеПеременной("глТекущийПользователь"), "ЗагружатьАктуальныеКурсыВалютПриЗапускеСистемы") Тогда
	
		// Автоматическая загрузка курсов валют
		ЗначениеКонстанты = Константы.НастройкиЗагрузкиКурсовВалют.Получить();
		Настройки 		  = ЗначениеКонстанты.Получить();
		ЗагружатьЕжедневно = Ложь;	
		Если Настройки <> Неопределено Тогда
			Попытка
				ЗагружатьЕжедневно = Настройки.ЗагружатьЕжедневно;
			Исключение
			КонецПопытки;	
		КонецЕсли;
		
		Попытка
			Если ЗагружатьЕжедневно Тогда
				
				ОбработкаЗагрузкаКурсов = Обработки.ЗагрузкаКурсовВалют.Создать();
				Если НЕ ОбработкаЗагрузкаКурсов.КодДоступаАктуален() Тогда
					ФормаОжиданияКурсов = ОбработкаЗагрузкаКурсов.ПолучитьФорму("ФормаОжидания");
					ФормаОжиданияКурсов.Открыть();
					ПодключитьОбработчикОжидания("ОбработчикЗагрузкаКурсов", 20, Истина);
				Иначе
					ОбработкаЗагрузкаКурсов.ЗагрузитьКурсыПоНастройкам();
				КонецЕсли;
			КонецЕсли;
		Исключение
		КонецПопытки;
	
	КонецЕсли; 
	
	ОткрытьЗадачиПользователя = УправлениеПользователями.ПолучитьЗначениеПоУмолчанию(глЗначениеПеременной("глТекущийПользователь"), "ОткрыватьПриЗапускеСписокТекущихЗадачПользователя");
	
	// Открытие дополнительной информации
	Если НЕ ПервыйЗапуск Тогда
		
		Если ОткрытьЗадачиПользователя Тогда
			Задачи.Задачи.ПолучитьФормуСписка().Открыть();
		КонецЕсли;
		
		Если ПравоДоступа("Использование", Метаданные.Обработки.НаборПерсонала)
		   И УправлениеПользователями.ПолучитьЗначениеПоУмолчанию(глЗначениеПеременной("глТекущийПользователь"), "АвтооткрытиеНабораПриЗапускеПрограммы") = Истина Тогда
			Обработки.НаборПерсонала.ПолучитьФорму().Открыть();
		КонецЕсли;
		
		Форма = Обработки.ДополнительнаяИнформация.ПолучитьФорму("ФормаРабочийСтол");
		Форма.Открыть();
	КонецЕсли;
	
	// Форма помощника обновления конфигурации выводится поверх остальных окон.
	Если РольДоступна(Метаданные.Роли.ПолныеПрава) Тогда
		ОбработкаОбновлениеКонфигурации = Обработки.ОбновлениеКонфигурации.Создать();
		ОбработкаОбновлениеКонфигурации.ПроверитьНаличиеОбновлений();
	КонецЕсли;

	глПодключитьМенеджерЗвит1С(Ложь);
	
КонецПроцедуры

Процедура ОбработчикЗагрузкаКурсов() Экспорт
	
	Если НЕ ФормаОжиданияКурсов = Неопределено Тогда
		Если ФормаОжиданияКурсов.Открыта() Тогда
			ФормаОжиданияКурсов.Закрыть();
			ФормаОжиданияКурсов = Неопределено;
			#Если Клиент Тогда
				ЗапуститьПриложение("http://finance.ua/ru/price/~/1c");
			#КонецЕсли	
			ОбработкаЗагрузкаКурсов = Обработки.ЗагрузкаКурсовВалют.Создать();
			ОбработкаЗагрузкаКурсов.ЗагрузитьКурсыПоНастройкам();
		КонецЕсли; 
		ФормаОжиданияКурсов = Неопределено;
	КонецЕсли;
	
КонецПроцедуры

// Обработать параметр запуска программы.
// Реализация функции может быть расширена для обработки новых параметров.
//
// Параметры
//  ПараметрЗапуска  – Строка – параметр запуска, переданный в конфигурацию 
//								с помощью ключа командной строки /C.
//
// Возвращаемое значение:
//   Булево   – Истина, если необходимо прервать выполнение процедуры ПриНачалеРаботыСистемы.
//
Функция ОбработатьПараметрыЗапуска(Знач ПараметрЗапуска)

	// есть ли параметры запуска
	Если ПустаяСтрока(ПараметрЗапуска) Тогда
		Возврат Ложь;
	КонецЕсли;
	
	// Параметр может состоять из частей, разделенных символом ";".
	// Первая часть - главное значение параметра запуска. 
	// Наличие дополнительных частей определяется логикой обработки главного параметра.
	ПараметрыЗапуска = ОбщегоНазначения.РазложитьСтрокуВМассивПодстрок(ПараметрЗапуска,";");
	ЗначениеПараметраЗапуска = Врег(ПараметрыЗапуска[0]);
	
	Результат = УправлениеСоединениямиИБ.ОбработатьПараметрыЗапуска(ЗначениеПараметраЗапуска, ПараметрыЗапуска);
	Возврат Результат;

КонецФункции 

// Процедура осуществляет обработку события "При завершении работы системы".
// Данное событие возникает перед завершением работы в режиме 1С:Предприятие
// после закрытия главного окна.
// В данной процедуре могут быть выполнены действия, необходимые при выходе
// из программы.
// Примечание:
// В данной процедуре не допускаются открытие форм и других окон, не
// поддерживаются выдача сообщений, установка текста в панели состояния,
// а также другие действия, требующие наличия главного окна.
//
// Параметры:
//  Нет.
//
Процедура ПриЗавершенииРаботыСистемы()

	Возврат;
	
КонецПроцедуры // ПриЗавершенииРаботыСистемы()

// Процедура - обработчик внешнего событие, которое возникает при посылке
// внешним приложением сообщения, сформированного в специальном формате.
// Внешнее событие сначала обрабатывается всеми открытыми формами, имеющими
// обработчик этого события, а затем может быть обработано в данной процедуре.
//
// Параметры:
//  Источник - <Строка>
//           - Источник внешнего события.
//
//  Событие  - <Строка>
//           - Наименование события.
//
//  Данные   - <Строка>
//           - Данные для события.
//
Процедура ОбработкаВнешнегоСобытия(Источник, Событие, Данные)

	Если Источник = "Zvit1C" Тогда
		
		// Актуализируем глМенеджерЗвит1С, если был подключен как внешний
		Если Не глПодключитьМенеджерЗвит1С() Тогда
			Возврат;
		КонецЕсли;

		глМенеджерЗвит1С.ОбработкаВнешнегоСобытияЗвит1С(Источник, Событие, Данные);	
		
	КонецЕсли;

КонецПроцедуры // ВнешнееСобытие()

// перед завершением работы системы
Процедура ПередЗавершениемРаботыСистемы(Отказ)
	
	ЗапрашиватьПотверждение = глЗначениеПеременной("глЗапрашиватьПодтверждениеПриЗакрытии") <> Ложь и УправлениеПользователями.ПолучитьЗначениеПоУмолчанию(глЗначениеПеременной("глТекущийПользователь"), "ЗапрашиватьПодтверждениеПриЗакрытии") = Истина;
	
	Если ЗапрашиватьПотверждение Тогда
		Ответ = Вопрос(НСтр("ru='Завершить работу с программой?';uk='Завершити роботу із програмою?'"), РежимДиалогаВопрос.ДаНет);
		Отказ = (Ответ = КодВозвратаДиалога.Нет);
	КонецЕсли;
	
	Если НЕ Отказ Тогда
		
		// отдельно получаем настройки для которых нужно выполнить обмен при выходе из программы
		ПроцедурыОбменаДанными.ВыполнитьОбменПриЗавершенииРаботыПрограммы(глЗначениеПеременной("глОбработкаАвтоОбменДанными"));
			
	КонецЕсли;

	Если Не Отказ И глМенеджерЗвит1С <> Неопределено Тогда
		глМенеджерЗвит1С.ЗавершитьЗвит1С(Отказ);
	КонецЕсли;
	
КонецПроцедуры

// Процедура выполняет запуск отчетов, у которых установлен
// признак "Формировать при входе в систему"
//
Процедура СформироватьОтчеты()

	Возврат;

КонецПроцедуры

// Процедура проверяет и при необходимости подключает обработчик ожидания
// на запуск процедуры ПроверитьНапоминания()
//
// Параметры:
//  Нет.
//
Процедура ПроверитьПодключениеОбработчикаОжидания(ПроверятьДеньРождения = Ложь) Экспорт
	
	ИнтервалПроверкиНапоминанийВСекундах = Константы.ИнтервалПроверкиНапоминанийВСекундах.Получить();
	
	Если глЗначениеПеременной("глТекущийПользователь") <> Неопределено
		 И ТипЗнч(глЗначениеПеременной("глТекущийПользователь")) = Тип("СправочникСсылка.Пользователи")
		 И НЕ глЗначениеПеременной("глТекущийПользователь").Пустая()
		 И УправлениеПользователями.ПолучитьЗначениеПоУмолчанию(глЗначениеПеременной("глТекущийПользователь"), "ИспользоватьНапоминания")
		 И ИнтервалПроверкиНапоминанийВСекундах > 0 Тогда
		 
		ПодключитьОбработчикОжидания("ПроверитьНапоминания", ИнтервалПроверкиНапоминанийВСекундах);

		УправлениеКонтактами.ПроверитьНапоминанияПользователя(глЗначениеПеременной("глТекущийПользователь"), ПроверятьДеньРождения);

	Иначе
		
		ОтключитьОбработчикОжидания("ПроверитьНапоминания");
		
	КонецЕсли; 
	
КонецПроцедуры

// Процедура проверяет Напоминания
//
Процедура ПроверитьНапоминания() Экспорт
	
	УправлениеКонтактами.ПроверитьНапоминанияПользователя(глЗначениеПеременной("глТекущийПользователь"));
	
КонецПроцедуры

// Открывает форму текущего пользователя для изменения его настроек.
//
// Параметры:
//  Нет.
//
Процедура ОткрытьФормуТекущегоПользователя() Экспорт

	Если НЕ ЗначениеЗаполнено(глЗначениеПеременной("глТекущийПользователь")) Тогда
		ОбщегоНазначения.СообщитьОбОшибке(НСтр("ru='Не задан текущий пользователь.';uk='Не заданий поточний користувач.'"));
	Иначе
		Форма = глЗначениеПеременной("глТекущийПользователь").ПолучитьФорму();
		Форма.Открыть();
	КонецЕсли;

КонецПроцедуры // ОткрытьФормуТекущегоПользователя()

// функция вызова формы редактирования настройки файла обновления конфигурации
Процедура ОткрытьФормуРедактированияНастройкиФайлаОбновления() Экспорт
	
	Если НЕ ПравоДоступа("Чтение", Метаданные.Константы.НастройкаФайлаОбновленияКонфигурации) Тогда
		
		Предупреждение(НСтр("ru='Нет прав на чтение данных константы ""Настройка файла обновления конфигурации""';uk='Немає прав на читання даних константи ""Настройка файлу  оновлення конфігурації""'"), 30, НСтр("ru='Настройка файла обновления конфигурации';uk='Настройка файлу оновлення конфігурації'"));		
		Возврат;
		
	КонецЕсли;

	ФормаРедактирования = ПолучитьОбщуюФорму("НастройкаФайлаОбновленияКонфигурации");
	ФормаРедактирования.СтруктураПараметров = ПроцедурыОбменаДанными.ПолучитьНастройкиДляФайлаОбновленияКонфигурации(); 
	ФормаРедактирования.Открыть();
	
КонецПроцедуры

Функция глЗначениеПеременной(Имя) Экспорт
	
	Возврат ОбщегоНазначения.ПолучитьЗначениеПеременной(Имя, глОбщиеЗначения);

КонецФункции

// Процедура установки значения экспортных переменных модуля приложения
//
// Параметры
//  Имя - строка, содержит имя переменной целиком
// 	Значение - значение переменной
//
Процедура глЗначениеПеременнойУстановить(Имя, Значение, ОбновлятьВоВсехКэшах = Ложь) Экспорт
	
	ОбщегоНазначения.УстановитьЗначениеПеременной(Имя, глОбщиеЗначения, Значение, ОбновлятьВоВсехКэшах);
	
КонецПроцедуры

// Открыть форму настройки пользователя
// 
Процедура ОткрытьФормуНастройкиПользователя() Экспорт
	
	ПараметрыСеанса.ТекущийПользователь.ПолучитьФорму().Открыть();
	
КонецПроцедуры  // ОткрытьФормуНастройкиПользователя

// Подключить актуальный менеджер FREDO Звіт
//
Функция глПодключитьМенеджерЗвит1С(ВыводитьСообщенияОбОшибках = Истина) Экспорт
	
	ИсточникОтчета = "РегламентированныйОтчетМенеджерЗвит1С";
	
	Если глМенеджерЗвит1С <> Неопределено Тогда
		
		// Проверим, был ли подключен/переподключен внешний менеджер FREDO Звіт		
		Если РегламентированнаяОтчетность.ВерсияРеглОтчетаАктуальна(ИсточникОтчета) = Истина Тогда
			Возврат Истина;
		КонецЕсли;
		
	Иначе
		ПравоДоступаКОтчету = РегламентированнаяОтчетность.ПравоДоступаКРегламентированномуОтчету(ИсточникОтчета);
		Если ПравоДоступаКОтчету = Ложь ИЛИ ПравоДоступаКОтчету = Неопределено Тогда
			
			Если ВыводитьСообщенияОбОшибках Тогда                                                                                                                            
				Предупреждение(НСтр("ru='Недостаточно прав на использование модуля взаимодействия с ""FREDO Звіт""!';uk='Недостатньо прав на використання модуля взаємодії з ""FREDO Звіт""!'"));
			КонецЕсли;			
			Возврат Ложь;
			
		КонецЕсли;
		
	КонецЕсли;
	
	МенеджерЗвит1С = РегламентированнаяОтчетность.РеглОтчеты(ИсточникОтчета);
	
	Если МенеджерЗвит1С = Неопределено Тогда
		Если ВыводитьСообщенияОбОшибках Тогда
			Сообщить(НСтр("ru='Не удалось получить менеджер ""FREDO Звіт""!';uk='Не вдалося отримати менеджер ""FREDO Звіт""!'"), СтатусСообщения.Важное);
			// Возможно это ошибка для которой детальная информация не должна выводиться
			// выведем ее принудительно
			НайденныйЭлемент = РегламентированнаяОтчетность.ПолучитьРеглОтчетПоУмолчанию(ИсточникОтчета);
			Если НайденныйЭлемент = Справочники.РегламентированныеОтчеты.ПустаяСсылка() Тогда
				Сообщить(НСтр("ru='В справочнике ""Регламентированные отчеты"" не найден менеджер по работе с системой ""FREDO Звіт""';uk='У довіднику ""Регламентовані звіти"" не знайдений менеджер по роботі з системою ""FREDO Звіт""'"));
			КонецЕсли;
			
		КонецЕсли;
		
		Если глМенеджерЗвит1С <> Неопределено Тогда
			
			Если ВыводитьСообщенияОбОшибках Тогда                                                                                                                            
				Сообщить(НСтр("ru='Будет использован уже загруженный менеджер';uk='Буде використаний вже завантажений менеджер'"), СтатусСообщения.Информация);
			КонецЕсли;
			Возврат Истина;
			
		КонецЕсли;
		
		Возврат Ложь;
		
	КонецЕсли;
	
	Если ТипЗнч(МенеджерЗвит1С) = Тип("ОтчетМенеджер.РегламентированныйОтчетМенеджерЗвит1С") Тогда
		МенеджерЗвит1С = МенеджерЗвит1С.Создать();
	КонецЕсли;
	
	Если глМенеджерЗвит1С = Неопределено Тогда
		
		// Обновляем глобальную переменную сразу для поддержки новых конфигураций с старым внешним менеджером FREDO Звіт
		глМенеджерЗвит1С = МенеджерЗвит1С;
		
		Если Не глМенеджерЗвит1С.Инициализация(ВыводитьСообщенияОбОшибках) Тогда		
			глМенеджерЗвит1С = Неопределено;
			Возврат Ложь;	
		КонецЕсли;
		
	Иначе
		Попытка
			
			Если Не МенеджерЗвит1С.Переинициализация(ВыводитьСообщенияОбОшибках, глМенеджерЗвит1С) Тогда		
				Если ВыводитьСообщенияОбОшибках Тогда                                                                                                                            
					Сообщить(НСтр("ru='Будет использован уже загруженный менеджер';uk='Буде використаний вже завантажений менеджер'"), СтатусСообщения.Информация);
				КонецЕсли;
				Возврат Истина;
				
			КонецЕсли;
			
			глМенеджерЗвит1С = МенеджерЗвит1С;
			
		Исключение
			
			// Если остался устаревший менеджер FREDO Звіт. То в нем нет метода Переинициализация(...)
			Если ВыводитьСообщенияОбОшибках Тогда                                                                                                                            
				Сообщить(НСтр("ru='Не удалось переподключить менеджер ""FREDO Звіт"". "
"Необходимо обновить менеджер FREDO Звіт в справочнике ""Регламентированные отчеты""';uk='Не вдалося перепідключити менеджер ""FREDO Звіт"". "
"Необхідно оновити менеджер FREDO Звіт в довіднику ""Регламентовані звіти""'"), СтатусСообщения.Важное);
				Сообщить(НСтр("ru='Будет использован уже загруженный менеджер';uk='Буде використаний вже завантажений менеджер'"), СтатусСообщения.Информация);			
			КонецЕсли;
			Возврат Истина;
			
		КонецПопытки;
		
	КонецЕсли;
		
	Возврат Истина;
	
КонецФункции

//глСоответствиеТекстовЭлектронныхПисем = Новый Соответствие;

Если Найти(ВРег(Метаданные.Имя), "БАЗОВАЯ") > 0 Тогда
	АдресРесурсовОбозревателя = "HRMUkrBase";
Иначе
	АдресРесурсовОбозревателя = "HRMUkr";
КонецЕсли;
