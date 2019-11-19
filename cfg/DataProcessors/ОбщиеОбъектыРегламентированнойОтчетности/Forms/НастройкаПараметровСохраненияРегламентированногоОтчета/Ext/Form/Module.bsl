﻿
// Процедура открывает диалог для выбора каталога сохранения.
// Вызывается по событию НачалоВыбора поля ввода ПутьДляВыгрузки.
Процедура ВыборПутиСохранения()
	
	Длг = Новый ДиалогВыбораФайла(РежимДиалогаВыбораФайла.ВыборКаталога);
	Длг.Заголовок = НСтр("ru='Укажите каталог';uk='Вкажіть каталог'");
	Если Длг.Выбрать() Тогда
		ПутьДляВыгрузки = Длг.Каталог+?(Прав(Длг.Каталог, 1) <> "\", "\", "");
	КонецЕсли;
	
КонецПроцедуры

// Процедура - обработчик события ПриИзменении переключателя СохрНаДискету.
Процедура ИзменениеВариантаВыгрузки(Элемент)

	Если ЭлементыФормы.СохрНаДискету.Значение = 2 Тогда
		ЭлементыФормы.Дискета.Доступность = Ложь;
		ЭлементыФормы.ПутьДляВыгрузки.Доступность = Истина;
	Иначе
		ЭлементыФормы.Дискета.Доступность = Истина;
		ЭлементыФормы.ПутьДляВыгрузки.Доступность = Ложь;
	КонецЕсли;

КонецПроцедуры

// Процедура - обработчик события ПриОткрытии формы.
Процедура ПриОткрытии()
	
	Если СокрЛП(ПутьДляВыгрузки)="" Тогда
		ПутьДляВыгрузки = ВосстановитьЗначение("ПутьДляВыгрузкиРегламентированныхОтчетов");
		Если СокрЛП(ПутьДляВыгрузки) = "" Тогда
			ПутьДляВыгрузки = УправлениеПользователями.ПолучитьЗначениеПоУмолчанию(глЗначениеПеременной("глТекущийПользователь"), "ОсновнойКаталогФайлов");
		КонецЕсли;
	КонецЕсли;
	
	Если (ВРЕГ(ПутьДляВыгрузки) = "A:\") ИЛИ (СокрЛП(ПутьДляВыгрузки) = "") Тогда
		ЭлементыФормы.СохрНаДискету.Значение = 1;
		ЭлементыФормы.Дискета.Значение = ЭлементыФормы.Дискета.СписокВыбора.Получить(0).Значение;
	ИначеЕсли ВРЕГ(ПутьДляВыгрузки) = "B:\" Тогда
		ЭлементыФормы.СохрНаДискету.Значение = 1;
		ЭлементыФормы.Дискета.Значение = ЭлементыФормы.Дискета.СписокВыбора.Получить(1).Значение;
	Иначе
		ЭлементыФормы.СохрНаДискету.Значение = 2;
	КонецЕсли;
	ИзменениеВариантаВыгрузки(Неопределено);
	
КонецПроцедуры

// Процедура - обработчик события ПриНажатии кнопки "Отмена".
Процедура Отменить(Элемент)

	ЭтаФорма.Закрыть(Ложь);

КонецПроцедуры

// Процедура - обработчик события ПриНажатии кнопки "Сохранить".
Процедура Сохранить(Элемент)

	Если ЭлементыФормы.СохрНаДискету.Значение = 1 Тогда
		ПутьДляВыгрузки = ЭлементыФормы.Дискета.Значение;
	КонецЕсли;

	Если Лев(ПутьДляВыгрузки, 2) <> "\\" Тогда

		// Если при указании пути для выгрузки вручную не указан концевой слэш - добавляем его.
		Если Прав(ПутьДляВыгрузки, 1) <> "\" Тогда
			ПутьДляВыгрузки = ПутьДляВыгрузки + "\";
		КонецЕсли;

		Кат = Новый Файл(ПутьДляВыгрузки + "NUL");
		
		Если НЕ Кат.Существует() Тогда

			Текст = НСтр("ru='Нет доступа к каталогу ';uk='Немає доступу до каталогу '") + ПутьДляВыгрузки;

			Если ЭлементыФормы.СохрНаДискету.Значение = 1 Тогда
				Текст = Текст + Символы.ПС + НСтр("ru='Вставьте дискету в дисковод!';uk='Вставте дискету в дисковод!'");
			Иначе
				Текст = Текст + Символы.ПС + НСтр("ru='Проверьте корректность имени каталога выгрузки!';uk=""Перевірте коректність ім'я каталогу вивантаження!""");
			КонецЕсли;

			Сообщить(Текст, СтатусСообщения.Важное);
			Возврат;
			
		КонецЕсли;
			
	КонецЕсли;

	Кат = Новый Файл(ПутьДляВыгрузки);
	Если Кат.Существует() и Кат.ЭтоКаталог() Тогда
		СохранитьЗначение("ПутьДляВыгрузкиРегламентированныхОтчетов", ?(ЭлементыФормы.СохрНаДискету.Значение = 1, ЭлементыФормы.Дискета.Значение, ПутьДляВыгрузки));
		ЭтаФорма.Закрыть(Истина);
	Иначе
		Сообщить(НСтр("ru='Имя каталога задано неверно! Проверьте правильность указания имени каталога!';uk=""Ім'я каталогу задане невірно! Перевірте правильність вказаного ім'я каталогу!"""),СтатусСообщения.Внимание);
	КонецЕсли;

КонецПроцедуры
