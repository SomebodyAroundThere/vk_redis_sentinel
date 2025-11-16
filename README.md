# Развертывание кластера Redis при помощи Terraform

1. Создание ресурсов vk-cloud
Для задания были созданы: сеть, роутер, подсеть, 3 инстанса виртуальной машины Ubuntu22.04 (размер диска 10GB , тип диска ceph-ssd).

## 🚀 Быстрый старт

### 1. Клонирование репозитория

```bash
git clone https://github.com/somebodyaroundthere/vk_redis_sentinel.git
cd vk_redis_sentinel
```

### 2. Настройка переменных

измените переменные на те, которые вам нужны в файлах secret.tfvars и variables.tf

### 3. Инициализация и развертывание

```bash
# Инициализация Terraform
terraform init

# Просмотр плана развертывания
terraform plan -var-file="secret.tfvars"

# Развертывание инфраструктуры
terraform apply -var-file="secret.tfvars"
```
### 4. Подключение вм к базе данных

После успешного развертывания выполните на всех трех вм:

```bash
sudo apt update
sudo apt install redis-server redis-sentinel
```
Отредактируйте conf файлы: \
**Master**
**/etc/redis/redis.conf:** \
protected-mode yes \
bind <ip-master> 127.0.0.1 \
requirepass <master-password> \
masterauth <master-password> \
replica-announce-ip ubuntu-surname-ms1.mcs.local \
rename-command FLUSHALL "" \
rename-command FLUSHDB "" \
rename-command CONFIG "" \
rename-command SHUTDOWN "" \
**/etc/redis/sentinel.conf:** \
protected-mode yes \
bind <ip-master> 127.0.0.1 \
sentinel monitor mymaster <ip-master> 6379 1 \
sentinel down-after-milliseconds mymaster 5000 \
sentinel failover-timeout mymaster 10000 \
sentinel parallel-syncs mymaster 1 \
sentinel auth-pass mymaster <master-password> \
requirepass <sentinel-password> \
**Slaves** \
**/etc/redis/redis.conf:** \
bind <ip-slave> 127.0.0.1 \
requirepass <master-password> \
masterauth <master-password> \
replicaof <ip-master> 6379 \
replica-announce-ip ubuntu-surname-me1/gz1.mcs.local \
**/etc/redis/sentinel.conf:** \
protected-mode yes \
bind <ip-slave> 127.0.0.1 \
sentinel monitor mymaster <ip-master> 6379 1 \
sentinel down-after-milliseconds mymaster 5000 \
sentinel failover-timeout mymaster 10000 \
sentinel parallel-syncs mymaster 1 \
sentinel auth-pass mymaster <master-password> \
requirepass <sentinel-password> 

## 📁 Структура проекта

```text
mysql-database-terraform/
├── main.tf                 # Основная конфигурация Terraform
├── variables.tf            # Определение переменных
├── provider.tf             # Настройка провайдера VK Cloud
├── network.tf              # Настройка сети

```
