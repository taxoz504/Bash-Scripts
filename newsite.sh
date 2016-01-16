#To Do
#Edit all under "echo '<VirtualHost *:80>" words with DOMAIN to site url without HTTP
#Fullout the DOMAIN="" 


DOMAIN="edit.me.com"

echo mkaing folder $DOMAIN

sudo mkdir -p /var/www/$DOMAIN/public_html

sleep 1

echo Making index for $DOMAIN

sleep 1

echo '<html>
  <head>
    <title>Welcome</title>
  </head>
  <body>
    <h1>Success! virtual host is working!</h1>
  </body>
</html>' > /var/www/$DOMAIN/public_html/index.html

sleep 1

echo Making .conf for $DOMAIN

sleep 1

#ServerAlias only need www in it if you are using a new domain any sub doamin it has to be the same as ServerName
#
echo '<VirtualHost *:80>
        ServerAdmin admin@DOMAIN
        ServerName DOMAIN
        ServerAlias www.DOMAIN
        DocumentRoot /var/www/newsite.taxoz.dk/public_html
        ErrorLog ${APACHE_LOG_DIR}/error.log
        CustomLog ${APACHE_LOG_DIR}/access.log combined
</VirtualHost>' > /etc/apache2/sites-available/$DOMAIN.conf

sleep 1

echo enabling site

sleep 1

sudo a2ensite $DOMAIN.conf

sleep 1

echo Restarting apache2 server

sleep 1

sudo service apache2 restart