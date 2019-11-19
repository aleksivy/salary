﻿Процедура Очистить(Кнопка)
	
	Сообщения.Строки.Очистить();
	
	Элементыформы.HTMLДокумент.УстановитьТекст("<HTML><HEAD></HEAD><BODY scroll=no></BODY></HTML>");
	
КонецПроцедуры

Процедура HTMLДокументonclick(Элемент, pEvtObj)
	
	Если (Лев(pEvtObj.srcElement.id, 9) = "openclose") Тогда
		ИдЭлемента = "subitems" + Сред(pEvtObj.srcElement.id, 10, 3);
		ЭлементHTML = Элемент.Документ.getElementById(ИдЭлемента);
		Если ЭлементHTML.className = "none" Тогда
			ЭлементHTML.className = "block";
			pEvtObj.srcElement.src = КартинкаЗакрыть;
			pEvtObj.srcElement.alt = "Свернуть...";
		Иначе
			ЭлементHTML.className = "none";
			pEvtObj.srcElement.src = КартинкаОткрыть;
			pEvtObj.srcElement.alt = "Подробнее...";
		КонецЕсли;
	ИначеЕсли (Лев(pEvtObj.srcElement.id, 7) = "comment") Тогда
		// отработать расшифровку по идетификатору ссылки
		РаскрытьКомментарийРасшифровки(СтрЗаменить(pEvtObj.srcElement.id,"comment",""));	
	КонецЕсли;
	pEvtObj.returnValue = Ложь;
	
КонецПроцедуры


Процедура HTMLДокументonmouseover(Элемент, pEvtObj)
	
	РаботаСДиалогами.ПолеHTMLДокументаOnMouseOver(Элемент, pEvtObj, Истина);
	
КонецПроцедуры

Процедура HTMLДокументonmouseout(Элемент, pEvtObj)
	
	РаботаСДиалогами.ПолеHTMLДокументаOnMouseOut(Элемент, pEvtObj, Истина);
	
КонецПроцедуры
