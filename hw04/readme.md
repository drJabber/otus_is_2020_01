





CIS banchmark 1.2.1 в скрипте docker-bench-security реализован как анализ вывода команды mountpoint. но если в docker.service прописан флаг --userns-remap, то дефолнтая директория докера - /var/lib/docker/xxxxx.xxxxx и скрипт выдает
[WARN] 1.2.1 - Ensure a separate partition for containers has been created
несмотря на то, что директория /var/lib/docker смонтирована в отдельной партиции


CIS benchmark 2.6  в скрипте  docker-bench-security реализован как анализ командной строки dockerd или анализ daemon.json. у меня почему-то всегда срабатывает 
[INFO] 2.6  - Ensure TLS authentication for Docker daemon is configured
[INFO]      * Docker daemon not listening on TCP

хотя в командной строке и в docker.service явно прописано -H tcp://192.168.99.101:2376 и при запуске sudo lsof -i :2376 выдает 

COMMAND  PID USER   FD   TYPE DEVICE SIZE/OFF NODE NAME
dockerd 7029 root    3u  IPv4 101700      0t0  TCP nodebuntu:2376 (LISTEN)


создание образа docker: необходимо из директории 
/home/djabber/projects/otus/IS/hw04/ansible/nodebuntu/roles/setup-hardening-for-cis-benchmarks/tasks/server-app
выполнить скрит build.sh



