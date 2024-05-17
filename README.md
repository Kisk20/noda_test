## В связи с особенностями физического расположения мощностей ВМ в зоне RU* ,использование AKS не представляется возможным либо требует больших временных ,финансовых и прочих трудозатрат.
Для выполнения задачи была развернута Виртуальная Машина на облачной платформе cloud.ru.

## Характеристики ноды
- vCPU: 2
- RAM: 4GB
- HDD: 30GB

## Компоненты
- Кластер Kubernetes с развернутым Nginx Ingress Controller
- Домен третьего уровня для тестового задания: turbonoda.rf.gd
- Установлен Cert-Manager для ротации сертификатов внутри Kubernetes кластера
- Используется Certbot для автоматизации получения и обновления сертификатов
- CRON для ежедневного запуска ротации сертификатов

## Работа с Cert-Manager и Certbot
В директории /opt/ssl_free/ расположены четыре ClusterIssuer:
- buypass-prod.yaml
- letsencrypt-prod.yaml
- sslforfree-prod.yaml
- zerossl-prod.yaml

Cert-Manager автоматически запрашивает и устанавливает SSL/TLS сертификаты для Ingress ресурсов от соответствующих поставщиков, указанных в ClusterIssuer. Certbot, встроенный в Cert-Manager, автоматически управляет процессом ротации сертификатов.

## Ротация сертификатов
Скрипт для ротации сертификатов расположен в директории /usr/local/bin/rotate_certs.sh и выполняет следующие действия:
1. Определяет список поставщиков сертификатов, включая Let's Encrypt, ZeroSSL, SSL For Free и Buypass.
2. Задает домен для получения сертификата (turbonoda.rf.gd) и директорию для хранения сертификатов /opt/cert/live/.
3. Выбирает случайного поставщика из списка и использует его для запроса сертификата с помощью Certbot.
4. Запускает Certbot с заданными параметрами, такими как email-адрес, URL выбранного поставщика и имя домена.
5. После получения сертификата скрипт выполняет перезагрузку Nginx для применения нового сертификата к серверу.

### В crontab автаматизирован запуска данного скрипта ежедневно в 2:00 AM
### Для ручного запуска скрипта выполнить команду /usr/local/bin/rotate_certs.sh
### Из-за географического расположения ВМ, работа скрипта неполноценна и большинство провайдеров сертификатов не работают с зоной RU ,либо требуют регистрации не из зоны RU ,но данное исполнение задания позволяет понять логгику работы по выпуску и ротации сертификатов

## Virtual Machine Setup on cloud.ru for Certificate Management

Due to the constraints of the physical location of the VM resources in the RU* zone, using AKS proves impractical or requires significant time, financial, and other resource investments. Consequently, a Virtual Machine was deployed on the cloud platform cloud.ru to fulfill the task.

### Node Specifications
- vCPU: 2
- RAM: 4GB
- HDD: 30GB

### Components
- Kubernetes Cluster with Nginx Ingress Controller deployed
- Third-level domain for the test task: turbonoda.rf.gd
- Cert-Manager installed for certificate rotation within the Kubernetes cluster
- Certbot used for automated certificate issuance and renewal
- CRON job scheduled for daily certificate rotation

### Cert-Manager and Certbot Workflow
In the directory /opt/ssl_free/, four ClusterIssuers are located:
- buypass-prod.yaml
- letsencrypt-prod.yaml
- sslforfree-prod.yaml
- zerossl-prod.yaml

Cert-Manager automatically requests and installs SSL/TLS certificates for Ingress resources from the specified providers indicated in ClusterIssuers. The integrated Certbot in Cert-Manager manages the certificate rotation process automatically.

### Certificate Rotation
The script for certificate rotation is located in the directory /usr/local/bin/rotate_certs.sh and performs the following actions:
1. Identifies the certificate providers including Let's Encrypt, ZeroSSL, SSL For Free, and Buypass.
2. Specifies the domain for certificate issuance (turbonoda.rf.gd) and the directory to store certificates (/opt/cert/live/).
3. Randomly selects a provider from the list and utilizes Certbot for certificate issuance.
4. Initiates Certbot with specified parameters such as email address, provider's URL, and domain name.
5. Upon certificate issuance, the script reloads Nginx to apply the new certificate to the server.

### Automation:
The script runs daily at 2:00 AM via crontab.
To manually execute the script, run the command /usr/local/bin/rotate_certs.sh.

Due to the VM's geographic location limitations, script operation is suboptimal as most certificate providers do not function in the RU zone or require registration from outside RU, yet this implementation provides insights into the certificate issuance and rotation process logic.
