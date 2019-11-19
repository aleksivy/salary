﻿////////////////////////////////////////////////////////////////////////////////
// ПРОЦЕДУРЫ И ФУНКЦИИ ОБЩЕГО НАЗНАЧЕНИЯ

// Обновление результата отчета
//
Процедура ОбновитьОтчет() Экспорт
	
	СформироватьОтчет(ЭлементыФормы.ПолеТабличногоДокументаРезультат);
	
КонецПроцедуры // ОбновитьОтчет()

////////////////////////////////////////////////////////////////////////////////
// ПРОЦЕДУРЫ - ОБРАБОТЧИКИ СОБЫТИЙ ФОРМЫ

// Процедура - обработчик события при открытии формы
//
Процедура ПриОткрытии()
	
	мДействиеПолеВводаВидСравненияПриИзменении = Новый Действие("ПолеВводаВидСравненияПриИзменении");
	мДействиеПолеВводаЗначениеПриИзменении = Новый Действие("ПолеВводаЗначениеПриИзменении");
	мДействиеКоманднаяПанельФормыПечать = Новый Действие("КоманднаяПанельФормыПечать");
	мДействиеКоманднаяПанельФормыСправкаФормы = Новый Действие("КоманднаяПанельФормыСправкаФормы");
	мДействиеВстроеннаяСправкаonclick = Новый Действие("ВстроеннаяСправкаonclick");
	мДействиеВстроеннаяСправкаonmouseout = Новый Действие("ВстроеннаяСправкаonmouseout");
	мДействиеВстроеннаяСправкаonmouseover = Новый Действие("ВстроеннаяСправкаonmouseover");
	
	мПутьКПостроителюОтчета = "ОтчетОбъект";
	
	ФормаПриОткрытии(ЭтотОбъект, ЭтотОбъект, ЭтаФорма);

КонецПроцедуры // ПриОткрытии()

// Процедура - обработчик события при закрытии формы
//
Процедура ПриЗакрытии()
	
	ФормаПриЗакрытии(ЭтотОбъект, ЭтотОбъект, ЭтаФорма);
	
КонецПроцедуры // ПриЗакрытии()

////////////////////////////////////////////////////////////////////////////////
// ПРОЦЕДУРЫ - ОБРАБОТЧИКИ НАЖАТИЯ КНОПОК КОМАНДНОЙ ПАНЕЛИ

// Процедура - обработчик нажатия кнопки "Сформировать"
//
Процедура КоманднаяПанельФормыСформировать(Кнопка)
	
	ОбновитьОтчет();
	
КонецПроцедуры // КоманднаяПанельФормыСформировать()

// Процедура - обработчик нажатия кнопки "Настройка"
//
Процедура КоманднаяПанельФормыНастройка(Кнопка)
	
	ФормаНастройка(ЭтотОбъект, ЭтотОбъект, ЭтаФорма, ЭлементыФормы.ПолеТабличногоДокументаРезультат);
	
КонецПроцедуры // КоманднаяПанельФормыНастройка()

// Процедура - обработчик нажатия кнопки "НовыйОтчет"
//
Процедура КоманднаяПанельФормыНовыйОтчет(Кнопка)
	
	ФормаНовыйОтчет(ЭтотОбъект, ЭтотОбъект,, Истина);
	
КонецПроцедуры // КоманднаяПанельФормыНовыйОтчет()

// Процедура - обработчик нажатия кнопки "БыстрыеОтборы"
//
Процедура КоманднаяПанельФормыБыстрыеОтборы(Кнопка)
	
	УправлениеОтображениемЭлементовФормы(ЭтотОбъект, ЭтаФорма, Кнопка.Имя);
	УправлениеПанельюБыстрыеОтборы(ЭтотОбъект, ЭтаФорма);
	
КонецПроцедуры // КоманднаяПанельФормыБыстрыеОтборы()

// Процедура - обработчик нажатия кнопки "ЗаголовокОтчета"
//
Процедура КоманднаяПанельФормыЗаголовокОтчета(Кнопка)
	
	УправлениеОтображениемЭлементовФормы(ЭтотОбъект, ЭтаФорма, Кнопка.Имя);
	УправлениеОтображениемЗаголовка(ЭтотОбъект, ЭлементыФормы.ПолеТабличногоДокументаРезультат);
	
КонецПроцедуры // КоманднаяПанельФормыЗаголовокОтчета()

// Процедура - обработчик нажатия кнопки "ВосстановитьНастройку"
//
Процедура КоманднаяПанельФормыВосстановитьНастройку(Кнопка)
	
	ВосстановитьНастройки(ЭтотОбъект, ЭтотОбъект, ЭтаФорма);
	
КонецПроцедуры // КоманднаяПанельФормыВосстановитьНастройку()

// Процедура - обработчик нажатия кнопки "СохранитьНастройку"
//
Процедура КоманднаяПанельФормыСохранитьНастройку(Кнопка)
	
	СохранитьНастройки(ЭтотОбъект, ЭтотОбъект, ЭтаФорма);
	
КонецПроцедуры // КоманднаяПанельФормыСохранитьНастройку()

// Процедура - обработчик нажатия кнопки "Печать"
//
Процедура КоманднаяПанельФормыПечать(Кнопка)
	
	ФормаПечать(ЭтотОбъект, ЭтотОбъект, ЭтаФорма);
	
КонецПроцедуры // КоманднаяПанельФормыПечать()

// Процедура - обработчик нажатия кнопки "СправкаФормы"
//
Процедура КоманднаяПанельФормыСправкаФормы(Кнопка)
	
	УправлениеОтображениемЭлементовФормы(ЭтотОбъект, ЭтаФорма, Кнопка.Имя);
	УправлениеОтображениемСправкиФормы(ЭтотОбъект, ЭтаФорма);
	
КонецПроцедуры // КоманднаяПанельФормыСправкаФормы()

////////////////////////////////////////////////////////////////////////////////
// ПРОЦЕДУРЫ - ОБРАБОТЧИКИ СОБЫТИЙ ЭЛЕМЕНТОВ ФОРМЫ

// Процедура - обработчик нажатия кнопки "КнопкаНастройкаПериода"
//
Процедура КнопкаНастройкаПериодаНажатие(Элемент)
	
	ФормаНастройкаПериода(ЭтотОбъект);
	
КонецПроцедуры // КнопкаНастройкаПериодаНажатие()

// Процедура - обработчик нажатия кнопки "КнопкаМинусПериод"
//
Процедура КнопкаМинусПериодНажатие(Элемент)
	
	ФормаМинусПериод(ЭтотОбъект);
	
КонецПроцедуры // КнопкаМинусПериодНажатие()

// Процедура - обработчик нажатия кнопки "КнопкаПлюсПериод"
//
Процедура КнопкаПлюсПериодНажатие(Элемент)
	
	ФормаПлюсПериод(ЭтотОбъект);
	
КонецПроцедуры // КнопкаПлюсПериодНажатие()

// Процедура - обработчик события "Обработка расшифровки" поля табличного документа "ПолеТабличногоДокументаРезультат"
//
Процедура ПолеТабличногоДокументаРезультатОбработкаРасшифровки(Элемент, Расшифровка, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	ОбработкаРасшифровкиУниверсальногоОтчета(Расшифровка, ЭтотОбъект);
	
КонецПроцедуры // ПолеТабличногоДокументаРезультатОбработкаРасшифровки()

// Процедура - обработчик события "При изменении" поля ввода "ПолеВводаВидСравнения"
//
Процедура ПолеВводаВидСравненияПриИзменении(Элемент)
	
	ВидСравненияПриИзменении(Элемент, ЭтаФорма);
	
КонецПроцедуры // ПолеВводаВидСравненияПриИзменении()

// Процедура - обработчик события "При изменении" полей ввода "Значение", "ЗначениеС", "ЗначениеПо"
//
Процедура ПолеВводаЗначениеПриИзменении(Элемент)
	
	ЗначениеПриИзменении(Элемент, ЭтаФорма);
	
КонецПроцедуры // ПолеВводаЗначениеПриИзменении()

////////////////////////////////////////////////////////////////////////////////
// ПРОЦЕДУРЫ - ОБРАБОТЧИКИ СОБЫТИЙ СПРАВКИ ФОРМЫ

// Процедура - обработчик события "onclick" поле HTML документа "ВстроеннаяСправка"
//
Процедура ВстроеннаяСправкаonclick(Элемент, pEvtObj)
	
	onclick(ЭтотОбъект, ЭтотОбъект, ЭтаФорма, Элемент, pEvtObj);
	
КонецПроцедуры // ВстроеннаяСправкаonclick()

// Процедура - обработчик события "onmouseout" поле HTML документа "ВстроеннаяСправка"
//
Процедура ВстроеннаяСправкаonmouseout(Элемент, pEvtObj)
	
	onmouseout(ЭтотОбъект, ЭтотОбъект, ЭтаФорма, Элемент, pEvtObj);
	
КонецПроцедуры // ВстроеннаяСправкаonmouseout()

// Процедура - обработчик события "onmouseover" поле HTML документа "ВстроеннаяСправка"
//
Процедура ВстроеннаяСправкаonmouseover(Элемент, pEvtObj)
	
	onmouseover(ЭтотОбъект, ЭтотОбъект, ЭтаФорма, Элемент, pEvtObj);
	
КонецПроцедуры // ВстроеннаяСправкаonmouseover()
