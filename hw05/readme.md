Домашние задания по курсу "Безопасность Linux"
===============================================

ДЗ 5 - SELinux
==============

Vagrantfile
------------

в vagrantfile поднимаем vm из образа centos/7 (nodevictim, ip 192.168.99.101)
Далее плейбуками ansible (bootstrap.yml)
- (role startup) прописываем репозитории epel-release 
- (role startup) устанавливаем необходимые пакеты (для работы с selinux, etc)
- (role startup) создаем на vm nodebuntu пользователя otus с обычными правами и паролем vic!!vak (на всякий случай)
- (role nginx) ставим nginx и конфиги. в конфиге nginx_vhosts.conf прописывам порт <b>8188</b>, 
- (role nginx) стартуем сервис nginx - видим, что он не стартовал.

Задание 1
-----------
Запустить nginx на нестандартном порту тремя способами.

### Исходные условия: 
- Centos 7 с вкюченным SELinux
- nginx настроен на запуск на порту 8188 (см ansible/nodevictim/roles/templates/nginx_vhosts.conf + ansible/nodevictim/bootstrap.yml переменная nginx_port)
- в директорию /var/www/{{ virtual_domain}} помещается файл index.html для использования в проверке работоспособности nginx 
- для выполнения запуска nginx в том или ином режиме используется переменная окружения NGINX_CUSTOM_PORT_SELINUX_MODE, возможные значения:
  selinux_setsebool - для изменения заначения флага selinux (nis_enabled)
  selinux_add_port_to_existing_type - для добавления нестандартного порта к имеющемуся типу (http_port_t)
  selinux_add_module - для создания кастомного модуля 

1. Разрешение запуска nginx на порту 8188, используя  переключатель setsebool. 
   выполняем :

   #vagrant destroy --force && NGINX_CUSTOM_PORT_SELINUX_MODE=selinux_setsebool vagrant up --provision  

   получаем:
   

3. add port

check: semanage port -l | grep http


