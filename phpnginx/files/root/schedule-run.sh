#!/bin/bash

while [ ! -f /var/www/.ldock-installed ];
do
    echo "==> Waiting for Laravel Installation..."
    sleep 3
done

echo "==> Laravel detected! Starting Queue Worker..."
php /var/www/artisan queue:listen
