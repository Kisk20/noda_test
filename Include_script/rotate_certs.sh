#!/bin/bash

# Список поставщиков
providers=(
    "letsencrypt https://acme-v02.api.letsencrypt.org/directory"
    "zerossl https://acme.zerossl.com/v2/DV90"
    "sslforfree https://acme.sslforfree.com/v2/DV90"
    "buypass https://api.buypass.com/acme/directory"
)

# Домен для получения сертификата
domain="turbonoda.rf.gd"

# Директория для хранения сертификатов
cert_dir="/opt/cert/live/$domain"

# Выбор случайного поставщика
random_provider=${providers[$RANDOM % ${#providers[@]}]}
IFS=' ' read -ra provider_info <<< "$random_provider"
provider_name=${provider_info[0]}
provider_url=${provider_info[1]}

echo "Selected provider: $provider_name ($provider_url)"

# Запуск Certbot для получения сертификата
certbot certonly --non-interactive --agree-tos --email kisk20@live.com --server "$provider_url" --nginx -d "$domain"

# Перезагрузка Nginx
if systemctl reload nginx; then
    echo "Nginx reloaded successfully."
else
    echo "Failed to reload Nginx."
fi
