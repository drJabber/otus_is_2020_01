Домашние задания по курсу "Безопасность Linux"
===============================================

ДЗ 2 - polkit, chtoot, pamd, apparmor
-----------------------------------------------

Создаем 2 витруальные машины. 
1. на основе образа Centos/7 (nodevictim, ip 192.168.99.101)
2. на основе образа ubuntu (nodeintruder, ip 192.168.99.102)

Конфиги для vm задаются в файле boxes_config.yml
К vm nodevictim поключается виртуальный диск sata_v.vdi с помощью плагина vagrant-newdisk (необходимо установить) как /dev/sdb
На стадии provivion в файлы /etc/hosts прописываются ip:hostname обеих машин. Используется плагин vagrant-hosts
На стадии provision в каждой плейбуком ansible на vm nodevictim производятся следующие действия:
1. Создание раздела /dev/sdb1 и файловой системы на /dev/sdb 
2. В папку /etc/polkit-1/rules.d копируется [правило политики policykit](https://github.com/drJabber/otus_is_2020_01/blob/master/hw02/ansible/polkit/10-mount-sdb1-for-user-otus.rules), которое позволяет пользователю otus монтировать раздел /dev/sdb1 
3. Создается группа otus и пользователи otus, otus2, otus3 в этой группе с паролем vic!!vak, для пользователей копируются открытые ключи из [папки ansible/ssh](https://github.com/drJabber/otus_is_2020_01/tree/master/hw02/ansible/ssh)
4. Создается ограниченное chroot-окружение [скриптом ansible/chroot/make_chroot.sh](https://github.com/drJabber/otus_is_2020_01/blob/master/hw02/ansible/chroot/make_chroot.sh), в sshd_config прописывается использование chroot-окружения для пользователя otus3
5. Создается pam.d политика, которая запрещает пользователю otus2 вход через ssh. в pam.d в конфиге sshd создается запись, которая строго положительного ответа от модуля pam_time.so, в конфиге time.conf создается запись, которая запрещает пользователю otus2 любые действия 24/7
