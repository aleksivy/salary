﻿////////////////////////////////////////////////////////////////////////////////
// ПЕРЕМЕННЫЕ МОДУЛЯ

// хранит вариант выбора страниц
Перем мВариантВыбора Экспорт;


////////////////////////////////////////////////////////////////////////////////
// ПРОЦЕДУРЫ И ФУНКЦИИ ОБЩЕГО НАЗНАЧЕНИЯ

// Процедура формирует выбранное значение - дерево настроек
// показа, вывода на печать и выгрузки отдельных страниц
// отчета, передает в форму, где была инициирована выборка
// и закрывает текущую форму.
Процедура УстановитьСоставСтраницОтчета()

	ДеревоСтраницОтчета = ЭлементыФормы.Дерево.Значение;

	Закрыть(ДеревоСтраницОтчета);

КонецПроцедуры // УстановитьСоставСтраницОтчета()

// Процедура формирует выбранное значение - список выводимых
// на печать листов отчета (дерево значений), передает в форму,
// где была инициирована выборка и закрывает текущую форму.
//
Процедура УстановитьСоставПечатаемыхЛистов()

	мЕстьВыбранные = Ложь;
	ДеревоСтраницОтчета = ЭлементыФормы.Дерево.Значение;

	Для Каждого СтрокаУровня1 Из ДеревоСтраницОтчета.Строки Цикл
		мЕстьВыбранные = СтрокаУровня1.ВыводНаПечать;

		Если СтрокаУровня1.Строки.Количество() > 0 Тогда

			Для Каждого СтрокаУровня2 Из СтрокаУровня1.Строки Цикл

				мЕстьВыбранные = СтрокаУровня2.ВыводНаПечать;

				Если СтрокаУровня2.Строки.Количество() > 0 Тогда

					Для Каждого СтрокаУровня3 Из СтрокаУровня2.Строки Цикл

						мЕстьВыбранные = СтрокаУровня3.ВыводНаПечать;

						Если мЕстьВыбранные Тогда
							Прервать;
						КонецЕсли;

					КонецЦикла;

				КонецЕсли;

				Если мЕстьВыбранные Тогда
					Прервать;
				КонецЕсли;

			КонецЦикла;

		КонецЕсли;

		Если мЕстьВыбранные Тогда
			Прервать;
		КонецЕсли;

	КонецЦикла;

	Если Не мЕстьВыбранные Тогда
		Сообщить(НСтр("ru='Не выбраны листы для печати.';uk='Не обрані аркуші для друку.'"), СтатусСообщения.Внимание);
		Возврат;
	КонецЕсли;

	Закрыть(ДеревоСтраницОтчета);

КонецПроцедуры // УстановитьСоставПечатаемыхЛистов()

// Процедура устанавливает (снимает) метки у всех строк дерева.
//
// Параметры:
//  Пометка - логическое выражение, значение пометки.
//
Процедура УстановитьПометкуСтрокДерева( Пометка, ТекКолонка)

	Если ТекКолонка = "ПоказатьСтраницу" Тогда

		Для Каждого СтрокаУровня1 Из Дерево.Строки Цикл

			СтрокаУровня1[ТекКолонка] = Пометка;

			Если Пометка = 1 Тогда
				// Для составляющих страниц титульного листа 
				// запрещаем варирование показом страницы.
				// Флаг показа определяется только по титульному
				// листу в целом.
				Если СтрокаУровня1.Строки.Количество() > 0 Тогда
					НовПометка = 2;

					Для Каждого СтрокаУровня2 Из СтрокаУровня1.Строки Цикл

						СтрокаУровня2[ТекКолонка] = НовПометка;

						Если СтрокаУровня2.Строки.Количество() = 0 Тогда 
							Продолжить;
						КонецЕсли;

						Для Каждого СтрокаУровня3 Из СтрокаУровня2.Строки Цикл
							СтрокаУровня3[ТекКолонка] = НовПометка;
						КонецЦикла;

					КонецЦикла;

					Продолжить;

				КонецЕсли; 

			ИначеЕсли Пометка = 0 Тогда
				// Предполагаем, что если пользователь отключил 
				// показ какой-либо страницы, то и необходимость
				// вывода этой страницы на печать отпадает
				СтрокаУровня1.ВыводНаПечать = Пометка;

				Для Каждого Строка Из СтрокаУровня1.Строки Цикл
					Строка.ВыводНаПечать = Пометка;
				КонецЦикла;

			КонецЕсли;

			Если СтрокаУровня1.Строки.Количество() = 0 Тогда 
				Продолжить;
			КонецЕсли;

			Для Каждого СтрокаУровня2 Из СтрокаУровня1.Строки Цикл

				СтрокаУровня2[ТекКолонка] = Пометка;

				Если СтрокаУровня2.Строки.Количество() = 0 Тогда 
					Продолжить;
				КонецЕсли;

				Для Каждого СтрокаУровня3 Из СтрокаУровня2.Строки Цикл
					СтрокаУровня3[ТекКолонка] = Пометка;
				КонецЦикла;

			КонецЦикла;
		КонецЦикла;

	ИначеЕсли  ТекКолонка = "ВыгрузитьСтраницу" Тогда

		Для Каждого СтрокаУровня1 Из Дерево.Строки Цикл

			Если СтрокаУровня1[ТекКолонка] = 2 Тогда 

				Если СтрокаУровня1.Строки.Количество() = 0 Тогда
					// страница выгружается всегда
					Продолжить;

				Иначе

					Для Каждого СтрокаУровня2 Из СтрокаУровня1.Строки Цикл

						Если СтрокаУровня2[ТекКолонка] = 2 Тогда

							Если СтрокаУровня2.Строки.Количество() = 0 Тогда 
								// части титульного листа выгружаются всегда
								Продолжить;
							КонецЕсли;

						Иначе

							СтрокаУровня2[ТекКолонка] = Пометка;

							Если СтрокаУровня2.Строки.Количество() = 0 Тогда 
								Продолжить;
							КонецЕсли;

							Для Каждого СтрокаУровня3 Из СтрокаУровня2.Строки Цикл

								Если СтрокаУровня3[ТекКолонка] = 2 Тогда
									Продолжить;
								КонецЕсли;

								СтрокаУровня3[ТекКолонка] = Пометка;

							КонецЦикла;

						КонецЕсли;

					КонецЦикла;

				КонецЕсли; 

				Продолжить;

			КонецЕсли;

			СтрокаУровня1[ТекКолонка] = Пометка;

			Если СтрокаУровня1.Строки.Количество() = 0 Тогда 
				Продолжить;
			КонецЕсли;

			Для Каждого СтрокаУровня2 Из СтрокаУровня1.Строки Цикл

				СтрокаУровня2[ТекКолонка] = Пометка;

				Если СтрокаУровня2.Строки.Количество() = 0 Тогда 
					Продолжить;
				КонецЕсли;

				Для Каждого СтрокаУровня3 Из СтрокаУровня2.Строки Цикл
					СтрокаУровня3[ТекКолонка] = Пометка;
				КонецЦикла;

			КонецЦикла;
		КонецЦикла;

	ИначеЕсли ТекКолонка = "ВыводНаПечать" Тогда

		Для Каждого СтрокаУровня1 Из Дерево.Строки Цикл

			СтрокаУровня1[ТекКолонка] = Пометка;

			Если СтрокаУровня1.Строки.Количество() = 0 Тогда 
				Продолжить;
			КонецЕсли;

			Для Каждого СтрокаУровня2 Из СтрокаУровня1.Строки Цикл

				СтрокаУровня2[ТекКолонка] = Пометка;

				Если СтрокаУровня2.Строки.Количество() = 0 Тогда 
					Продолжить;
				КонецЕсли;

				Для Каждого СтрокаУровня3 Из СтрокаУровня2.Строки Цикл
					СтрокаУровня3[ТекКолонка] = Пометка;
				КонецЦикла;

			КонецЦикла;
		КонецЦикла;

	Иначе

		Предупреждение(НСтр("ru='Для установки или снятия меток по требуемой колонке"
"предварительно активизируйте колонку.';uk='Для встановлення або зняття міток по необхідному стовпчику"
"спочатку активізуйте колонку.'"), 60);

	КонецЕсли;

КонецПроцедуры // УстановитьПометкуСтрокДерева()

////////////////////////////////////////////////////////////////////////////////
// ПРОЦЕДУРЫ - ОБРАБОТЧИКИ СОБЫТИЙ ФОРМЫ

// Процедура - обработчик события "ПриОткрытии" формы.
//
Процедура ПриОткрытии()

	ЭтаФорма.АвтоЗаголовок = Ложь;

	ДеревоСтраницОтчета = НачальноеЗначениеВыбора;

	// Если список одноуровневый, то показывать иерархию не будем
	ЭлементыФормы.Дерево.Колонки["Представление"].ОтображатьИерархию = Ложь;

	Для Каждого Строка Из ДеревоСтраницОтчета.Строки Цикл
		Если Строка.Строки.Количество() > 0 Тогда
			ЭлементыФормы.Дерево.Колонки["Представление"].ОтображатьИерархию = Истина;
			Прервать;
		КонецЕсли;
	КонецЦикла;

	ЭлементыФормы.Дерево.Значение = ДеревоСтраницОтчета;
	ЭлементыФормы.КнопкаУстановитьВсе.Видимость = Истина;
	ЭлементыФормы.КнопкаСнятьВсе.Видимость      = Истина;

	Если мВариантВыбора = "ВыбратьДляПечати" Тогда
		ЭтаФорма.Заголовок = НСтр("ru='Выберите листы для печати';uk='Виберіть аркуші для друку'");

		ЭлементыФормы.Дерево.Колонки.ВыгрузитьСтраницу.Видимость = Ложь;
		ЭлементыФормы.Дерево.Колонки.ПоказатьСтраницу.Видимость  = Ложь;

	ИначеЕсли мВариантВыбора = "ВыбратьДляНастройки" Тогда
		ЭтаФорма.Заголовок = НСтр("ru='Настройка страниц отчета';uk='Настройка сторінок звіту'");

	КонецЕсли;

КонецПроцедуры // ПриОткрытии()

////////////////////////////////////////////////////////////////////////////////
// ПРОЦЕДУРЫ - ДЕЙСТВИЯ КОМАНДНЫХ ПАНЕЛЕЙ ФОРМЫ

// Процедура вызывается при нажатии кнопки "ОК" командной панели формы.
// Отрабатывает выбранное значение.
//
Процедура ОсновныеДействияФормыКнопкаВыбратьНажатие(Кнопка)

	Если мВариантВыбора = "ВыбратьДляПечати" Тогда

		УстановитьСоставПечатаемыхЛистов();

	ИначеЕсли мВариантВыбора = "ВыбратьДляНастройки" Тогда

		УстановитьСоставСтраницОтчета();

	КонецЕсли;

КонецПроцедуры // ОсновныеДействияФормыКнопкаВыбратьНажатие()

///////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ ЭЛЕМЕНТОВ ДИАЛОГА

// Процедура вызывается по нажатию кнопки "УстановитьВсе".
//   Устанавливает пометку у всех строк дерева.
//
Процедура КнопкаУстановитьВсеНажатие(Элемент)

	ТекКолонка = ЭлементыФормы.Дерево.ТекущаяКолонка.Имя;

	УстановитьПометкуСтрокДерева(1, ТекКолонка);

КонецПроцедуры // УстановитьВсеНажатие()

// Процедура вызывается по нажатию кнопки "СнятьВсе".
// Снимает пометку у всех строк дерева.
//
Процедура КнопкаСнятьВсеНажатие(Элемент)

	ТекКолонка = ЭлементыФормы.Дерево.ТекущаяКолонка.Имя;

	УстановитьПометкуСтрокДерева(0, ТекКолонка);

КонецПроцедуры // СнятьВсеНажатие()

// Процедура - обработчик события "ПриИзмененииФлажка" в колонке
// табличного поля.
//   Ставит/снимает пометку у всех подчиненных строк выбранного уровня
// 
Процедура ДеревоПриИзмененииФлажка(Элемент, Колонка)

	НоваяПометка = Элемент.ТекущаяСтрока[Колонка.Имя];

	Если Колонка.Имя = "ПоказатьСтраницу" Тогда
		Если НоваяПометка = 1 Тогда

			// Для составляющих страниц титульного листа 
			// запрещаем варирование показом страницы.
			// Флаг показа определяется только по титульному
			// листу в целом.
			НоваяПометка = 2;

		ИначеЕсли НоваяПометка = 0 Тогда
			// Предполагаем, что если пользователь отключил 
			// показ какой-либо страницы, то и необходимость
			// вывода этой страницы на печать отпадает
			Элемент.ТекущаяСтрока.ВыводНаПечать = НоваяПометка;

			Для Каждого Строка Из Элемент.ТекущаяСтрока.Строки Цикл
				Строка.ВыводНаПечать = НоваяПометка;
			КонецЦикла;

		КонецЕсли;

	ИначеЕсли Колонка.Имя = "ВыводНаПечать" Тогда

		ВерхняяГруппировка = Элемент.ТекущаяСтрока.Родитель;
		Если ВерхняяГруппировка <> Неопределено Тогда
			// Проверяем все вложенные строки на предмет
			// того, установлены или сняты ли везде метки.
			// Если нет, то устанавливаем третье состояние
			// метки строки-родителя 
			НеВсеОтмечены = 0;

			Для каждого СтрокаУровня Из ВерхняяГруппировка.Строки Цикл

				Если СтрокаУровня.ВыводНаПечать <> НоваяПометка Тогда

					НеВсеОтмечены = 1;

					Прервать;
				КонецЕсли; 

			КонецЦикла; 

			Если НеВсеОтмечены = 1 Тогда
				ВерхняяГруппировка.ВыводНаПечать = 2;
			Иначе
				ВерхняяГруппировка.ВыводНаПечать = НоваяПометка;
			КонецЕсли;

		КонецЕсли;

	КонецЕсли;

	Для Каждого Строка Из Элемент.ТекущаяСтрока.Строки Цикл
		Строка[Колонка.Имя] = НоваяПометка;
	КонецЦикла;

КонецПроцедуры // ДеревоПриИзмененииФлажка()

// Процедура - обработчик события "ПередНачаломИзменения" строки табличного поля.
//
Процедура ДеревоПередНачаломИзменения(Элемент, Отказ)

	ТекКолонка  = Элемент.ТекущаяКолонка.Имя;
	ТекЗначение = Элемент.ТекущиеДанные[ТекКолонка];

	Если ТекКолонка = "ВыгрузитьСтраницу" Тогда

		Если ТекЗначение = 2 Тогда
			// Лист является обязательным для выгрузки,
			// поэтому не меняем состояние флажка
			Отказ = Истина;
		КонецЕсли;

	ИначеЕсли ТекКолонка = "ПоказатьСтраницу" Тогда
		// Лист является составной частью титульного листа,
		// поэтому не меняем состояние флажка

		Если ТекЗначение = 2 Тогда

			Отказ = Истина;

		ИначеЕсли ТекЗначение = 0 Тогда
			Если Элемент.ТекущаяСтрока.Родитель <> Неопределено Тогда

				Отказ = Истина;

			КонецЕсли; 
		КонецЕсли;

	КонецЕсли;

КонецПроцедуры // ДеревоПередНачаломИзменения()

// Процедура - обработчик события "ПередНачаломДобавления" строки
// табличного поля.
//
Процедура ДеревоПередНачаломДобавления(Элемент, Отказ, Копирование, Родитель)

	Отказ = Истина;

КонецПроцедуры // ДеревоПередНачаломДобавления()

// Процедура - обработчик события "ПередУдалением" строки табличного поля.
//
Процедура ДеревоПередУдалением(Элемент, Отказ)

	Отказ = Истина;

КонецПроцедуры // ДеревоПередУдалением()


