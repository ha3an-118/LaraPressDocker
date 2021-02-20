#!/bin/bash



function changeWebServerId ()
{
    #  check userId variable is set or not
    if [ -z ${userId}  ]
    then
        userId=1000
    else
        # user id is set
    fi
    usermod -u ${userId} www-data

     #  check groupId variable is set or not
    if [ -z ${groupId}  ]
    then
        groupId=1000
    else
        # group id is set
    fi
    groupmod -g ${groupId} www-data

}

function makeStorageDir ()
{
    baseDir="/var/www/backend"
    mkdir -p {$baseDir}/storage/framework/cache \ 
             {$baseDir}/storage/framework/sessions \
             {$baseDir}/storage/framework/testing \
             {$baseDir}/storage/framework/views \
             {$baseDir}/storage/app/public \
             {$baseDir}/storage/logs
}

function changePermission ()
{
    cd /var/www/backend
    #change file owner:group for webserver 
    chown -R www-data:www-data storage
    chown -R www-data:www-data .env
    chown -R www-data:www-data bootstrap/cache
    chown -R www-data:www-data public
}

function initApplication ()
{
    cd /var/www/backend
    php artisan config:cach

}

function migrateDataBase()
{
    cd /var/www/backend
    php artisan config:cach
    if [[ ${APP_MIGRATION} -eq "true"  ]]
    then
        php artisan migrate:fresh
        php artisan app:init
        php artisan storage:link
        php artisan db:seed
    fi
}

function runWebServer ()
{
    #start phpFpm
    /etc/init.d/php7.4-fpm  start
    #start nginx
    /usr/sbin/nginx -g "daemon off;" 
}


sleep 30
changeWebServerId
runWebServer

