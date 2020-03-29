Домашние задания по курсу "Безопасность Linux"
===============================================

ДЗ 4 - docker hardening
-----------------------------------------------

1. Образ

Dockerfile - в директории ./setup-hardening-for-cis-benchmarks/server-app

образ создается на основе образа python:3.8.3-alpine3.11
Далее: 
- создаем пользователя webapp
- создаем директорию app, 
- копируем туда requirements.txt, приложение signal_server.py, скрипт для запуска приложения - entrypoint, 
- устанавливаем владельца всех файлов пользователя webapp
- устанавливаем необходимые пакеты (aiohttp), 
- конфигурируем скрипт HEALTHCHECK
- выставляем наружу порт 8188
- устанавливаем точку входа от пользователя webapp


2. Хост

в vagrantfile поднимаем vm Ubuntu 18.04 из образа ubuntu/bionic64 (nodbuntu, ip 192.168.99.101), сохдаем отдельный диск (sata_u.vdi)
Далее плейбуками ansible (bootstrap.yml)
- (role startup) прописываем репозитории ubuntu 
- (role startup) создаем раздел, файловую систему, монтируем раздел в папку /var/lib/docker
- (role startup) создаем на vm nodebuntu пользователя otus с обычными правами и паролем vic!!vak (на всякий случай)
- (role setup_docker) устанавливаем docker, docker-compose, docker.py, docker-compose.py
- (role docker-tls) конфигурим подключение к сервису докера по TLS (исходник тут: https://github.com/ansible/role-secure-docker-daemon)
- (role setup-hardening-for-cis-benchmarks) загружаем проверочный скрипт docker-bench-security
- (role setup-hardening-for-cis-benchmarks) выполняем действия по харденингу хоста. т.к. хранилище контейнеров (/var/lib/docker) рамещается в отдельной партиции согласно CIS 1.2.1 (см примечание ниже), то остается сконфигурить auditd - устанавливаем и включаем демона, копируем на место файл audit.rules, в котором прописываем логирование попыток доступа к файлам и директориям докера.  
        Примечание:
        CIS banchmark 1.2.1 в скрипте docker-bench-security реализован как анализ вывода команды mountpoint. но если в docker.service прописан флаг --userns-remap, то дефолнтая директория докера - /var/lib/docker/xxxxx.xxxxx и скрипт выдает
        [WARN] 1.2.1 - Ensure a separate partition for containers has been created
        несмотря на то, что директория /var/lib/docker смонтирована в отдельной партиции
- (role setup-hardening-for-cis-benchmarks) выполняем действия по харденингу сервиса докера. Создаем конфигурацию для брокера авторизации twistedlock authz-broker. Создаем безопасную конфигурацию сервиса докера согласно CIS 1 и 2 (см. примечание ниже), включаем плагин authz-broker. Устанавливаем необходимые переменные окружения для плагина авторизации докера и клиента докера. Перезагружаем сервис докера.
        Примечание:
        CIS benchmark 2.6  в скрипте  docker-bench-security реализован как анализ командной строки dockerd или анализ daemon.json. у меня почему-то всегда срабатывает 
        [INFO] 2.6  - Ensure TLS authentication for Docker daemon is configured
        [INFO]      * Docker daemon not listening on TCP

        хотя в командной строке и в docker.service явно прописано -H tcp://192.168.99.101:2376 и при запуске sudo lsof -i :2376 выдает 

        COMMAND  PID USER   FD   TYPE DEVICE SIZE/OFF NODE NAME
        dockerd 7029 root    3u  IPv4 101700      0t0  TCP nodebuntu:2376 (LISTEN)


- (role setup-hardening-for-cis-benchmarks) запускаем контейнер из образа в безопасной конфигурации согласно CIS 4 и 5


