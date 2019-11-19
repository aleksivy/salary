﻿
Процедура Надпись4Нажатие(Элемент)
	ЗапуститьПриложение("http://www.sta.gov.ua");
КонецПроцедуры

Процедура ПриОткрытии()
	Если ФорматОтчета = "XML" Тогда 
				ЭлементыФормы.Надпись2.Заголовок = НСтр("ru='Теперь необходимо, не закрывая обработки, подписать сформированный отчет при помощи программного обеспечения, предоставленного ГНАУ.';
				                                        | uk='Тепер необхідно, не закриваючи обробки, підписати сформований звіт за допомогою програмного забезпечення, наданного ДПІ.'");
				ЭлементыФормы.Надпись3.Заголовок = НСтр("ru='Информацио о программном обеспечении ГНАУ можно найти по адресу:';
				                                        | uk='Інформацію про програмне забезпечення ДПІ можна знайти за адресою:'");
														
				ИначеЕсли ФорматОтчета ="АРМЗС" Тогда                                                         
				 ЭлементыФормы.Надпись2.Заголовок = НСтр("ru='Теперь необходимо, не закрывая обработки, подписать сформированный отчет при помощи программного обеспечения, предоставленного ПФ.'; 
				                                         |uk='Тепер необхідно, не закриваючи обробки, підписати сформований звіт за допомогою програмного забезпечення, наданного ПФ.'");
				 ЭлементыФормы.Надпись3.Заголовок = НСтр("ru='Информацию о программном обеспечении Пенсионного фонда можно найти по адресу:';
				                                        | uk='Інформацію про програмне забезпечення Пенсионного Фонда можна знайти за адресою:'");
                 ЭлементыФормы.Надпись4.Заголовок = НСтр("ru='Недоступно';
				                                        | uk='Нема доступу'");
				КонецЕсли;

		
КонецПроцедуры
