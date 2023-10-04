## Configurando Replicação de banco de dados Master-Master:

1. Instalar os pacotes `pcs` `pacemaker` `corosync` `mysql-client` `mysql-server` `python3-pymysql`

1. No arquivo de configuração do ambiente mysql `/etc/my.cnf` ou `/etc/my.cnf.d/arquivo_personalizado.cnf`

* configure nos dois servidores:
```
 bind_address = 0.0.0.0
```
* para o servidor1 tambem configure: 
```
 server-id = 1
 log-bin = /var/log/mysql/mysql-bin.log
 binlog-ignore-db = information_schema
 binlog-ignore-db = performance_schema
 binlog-ignore-db = sys
```
* para o servidor2 tambem configure:
```
 server-id = 2
 log-bin = /var/log/mysql/mysql-bin.log
 binlog-ignore-db = information_schema
 binlog-ignore-db = performance_schema
 binlog-ignore-db = sys
```
 
* reinicie o serviço do mysql nos dois servidores `systemctl restart mariadb.service`

4. Entre com o comando mysql e crie um usuario para a replicaÃ§Ã£o em ambos servidores:
```
CREATE USER 'replicacao'@'%' IDENTIFIED BY 'zoeiraraiz';
GRANT REPLICATION SLAVE ON *.* TO 'replicacao'@'%';
FLUSH PRIVILEGES;
```
5. Descubra os valores  file and position com o comando em cada servidor:
```
SHOW SLAVE STATUS;
```
6. Execute o comando em cada servidor tendo em vista que o valor de file e position do log sao o do servidor vontrario ao que esta sendo executado o comando:
* no servidor1 execute:
```
CHANGE MASTER TO
  MASTER_HOST = 'ip_do_servidor2',
  MASTER_USER = 'replicacao',
  MASTER_PASSWORD = 'senha',
  MASTER_LOG_FILE = 'log_file_servidor2',
  MASTER_LOG_POS = 0000;
```
* no servidor2 execute:
```
CHANGE MASTER TO
  MASTER_HOST = 'ip_do_servidor1,
  MASTER_USER = 'replicacao',
  MASTER_PASSWORD = 'senha',
  MASTER_LOG_FILE = 'log_file_servidor1',
  MASTER_LOG_POS = 1111;
```
## Configurando Cluster de Alta Disponibilidade:

1. Criar o usuario para o cluster em ambos os servidores com o comando `passwd hacluster`
2. Inicie o serviço do pacemaker:
```
systemctl enable pcsd.service
systemctl start pcsd.service
```
3. Verifique se a comunicação esta funcionando em ambos os servidores 
> (Lembre-se de configurar o `/etc/hosts` para que `servidor1` e `servidor2` sejam resolvidos para seus respectivos ips nas duas maquinas)
```
pcs cluster auth servidor1 servidor2
```
4. Monte o Cluster e inicie-o e o habilite para inicialização automatica
```
pcs cluster setup --name MeuCluster servidor1 servidor2]
pcs cluster start --all
pcs cluster enable --all
sudo pcs resource create myvirtualip ocf:heartbeat:IPaddr2 ip="ip.virtual.do.cluster" cidr_netmask="24" op monitor interval="10s"
```
5. Estabeleça o nó prerencial que o cluster debve escolher para atribuir o ip:
```
sudo pcs constraint location myvirtualip prefers servidor1=INFINITY
```
