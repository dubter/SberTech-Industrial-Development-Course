# SberTech-Industrial-Development-Course

Автор: Дубенков Родион

**Задача:**
 	
Нужно написать shell файл: 
Который принимает на вход три параметра START|STOP|STATUS. 
START запускает его в фоне и выдает PID процесса, 
STATUS выдает состояние - запущен/нет, 
STOP - останавливает PID
Сам shell мониторит утилизацию дискового пространства, количество свободных inode. Выводит информацию в виде csv файла. Имя файла должно содержать timestamp запуска + дату за которую мониторинг. Предусмотреть создание нового файла при переходе через сутки


**Запуск:**
```
source disk_monitor.sh START
```
