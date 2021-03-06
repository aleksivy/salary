Процедура СправочникСписокВыбор(Элемент, ВыбраннаяСтрока, Колонка, СтандартнаяОбработка)
	
	Если Не ВыбраннаяСтрока.ЭтоГруппа Тогда
		
		ЭтоОбработка = ?(ВыбраннаяСтрока.ВидОбработки = Перечисления.ВидыДополнительныхВнешнихОбработок.Обработка, Истина, Ложь);
		ЭтоОтчет = ?(ВыбраннаяСтрока.ВидОбработки = Перечисления.ВидыДополнительныхВнешнихОбработок.Отчет, Истина, Ложь);
		
		Если НЕ (ЭтоОбработка ИЛИ ЭтоОтчет) Тогда
			Возврат;
		КонецЕсли;
		
		
		//И ВыбраннаяСтрока.ВидОбработки = Перечисления.ВидыДополнительныхВнешнихОбработок.Обработка Тогда
		
		Попытка
			
			ИмяФайла = ПолучитьИмяВременногоФайла();
			ДвоичныеДанные = ВыбраннаяСтрока.ХранилищеВнешнейОбработки.Получить();
			ДвоичныеДанные.Записать(ИмяФайла);
			
			Если ЭтоОбработка Тогда
				
				Форма = ВнешниеОбработки.ПолучитьФорму(ИмяФайла);
				
			Иначе
				
				Форма = ВнешниеОтчеты.ПолучитьФорму(ИмяФайла);
				
			КонецЕсли;
			
			Если Не Форма = Неопределено Тогда
				
				Форма.Открыть();
				
			Иначе
				
				Если ЭтоОбработка Тогда
					ВнешняяОбработка = ВнешниеОбработки.Создать(ИмяФайла);
				Иначе
					ВнешнийОтчет = ВнешниеОтчеты.Создать(ИмяФайла);
					Форма = ВнешнийОтчет.ПолучитьФорму();
					Если Форма <> Неопределено Тогда
						Форма.Открыть();
					КонецЕсли;
				КонецЕсли;
				
			КонецЕсли;
			
			УдалитьФайлы(ИмяФайла);
			
		Исключение
			
			Если ЭтоОбработка Тогда
				
				Предупреждение(НСтр("ru='Выбранный файл не является внешней обработкой."
"Либо, данная обработка не предназначена для"
"запуска в этой конфигурации.';uk='Обраний файл не є зовнішньою обробкою."
"Або, дана обробка не призначена для"
"запуску в цій конфігурації.'"));
			Иначе
				Предупреждение(НСтр("ru='Выбранный файл не является внешним отчетом."
"Либо, данный отчет не предназначена для"
"запуска в этой конфигурации.';uk='Обраний файл не є зовнішнім звітом."
"Або, даний звіт не призначений для"
"запуску в цій конфігурації.'"));
			КонецЕсли;
			
		КонецПопытки;
		
		СтандартнаяОбработка = Ложь;
		
	КонецЕсли;
	
КонецПроцедуры

Процедура ПриОткрытии()
	
	Если Отбор.ВидОбработки.Использование Тогда
		Если КлючУникальности = Перечисления.ВидыДополнительныхВнешнихОбработок.ПечатнаяФорма Тогда
			Заголовок = НСтр("ru='Дополнительные внешние печатные формы';uk='Додаткові зовнішні друковані форми'");
		ИначеЕсли КлючУникальности = Перечисления.ВидыДополнительныхВнешнихОбработок.ЗаполнениеТабличныхЧастей Тогда
			Заголовок = НСтр("ru='Дополнительные внешние обработки по заполнению табличных частей';uk='Додаткові зовнішні обробки по заповненню табличних частин'");
		ИначеЕсли КлючУникальности = Перечисления.ВидыДополнительныхВнешнихОбработок.Обработка Тогда
			Заголовок = НСтр("ru='Дополнительные внешние обработки';uk='Додаткові зовнішні обробки'");
		ИначеЕсли КлючУникальности = Перечисления.ВидыДополнительныхВнешнихОбработок.Отчет Тогда
			Заголовок = НСтр("ru='Дополнительные внешние отчеты';uk='Додаткові зовнішні звіти'");
		КонецЕсли; 
	КонецЕсли; 
	
КонецПроцедуры

Процедура СправочникСписокПередНачаломДобавления(Элемент, Отказ, Копирование, Родитель, ЭтоГруппа)
	
	Если Не ЭтоГруппа И Не Копирование Тогда
		
		Форма = Справочники.ВнешниеОбработки.ПолучитьФормуНовогоЭлемента(,ЭлементыФормы.СправочникСписок);
		
		Если Отбор.ВидОбработки.Использование и Отбор.ВидОбработки.ВидСравнения = ВидСравнения.ВСписке Тогда
			Форма.ЭлементыФормы.ВидОбработки.ДоступныеЗначения = Отбор.ВидОбработки.Значение;
		ИначеЕсли Отбор.ВидОбработки.Использование и Отбор.ВидОбработки.ВидСравнения = ВидСравнения.Равно Тогда
			Форма.ВидОбработки = Отбор.ВидОбработки.Значение;
		КонецЕсли;
		
		Форма.Открыть();
		Отказ = Истина;
		
	КонецЕсли;
	
КонецПроцедуры

Процедура ДействияФормыПраваДоступаПользователейКТекущемуЭлементу(Кнопка)
	
	Если Не ЭлементыФормы.СправочникСписок.ТекущиеДанные = Неопределено Тогда
		НастройкаПравДоступа.РедактироватьПраваДоступа(ЭлементыФормы.СправочникСписок.ТекущиеДанные.Ссылка);
	КонецЕсли;
	
КонецПроцедуры

Процедура ДействияФормыПраваДоступаПользователейКоВсемуСправочнику(Кнопка)
	
	НастройкаПравДоступа.РедактироватьПраваДоступа(Справочники.ВнешниеОбработки.ПустаяСсылка());
	
КонецПроцедуры
