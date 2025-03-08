#!/bin/bash

# Ask if you want to create an FQDN or a subdomain
echo "Do you want to create a (1) FQDN or (2) Subdomain?"
read -p "Enter 1 for FQDN or 2 for Subdomain: " DOMAIN_TYPE

# FQDN
if [[ "$DOMAIN_TYPE" == "1" ]]; then
    read -p "Enter the main domain: " DOMAIN
    WEB_ROOT="/var/www/$DOMAIN/public_html"
    CONF_FILE="/etc/apache2/sites-available/$DOMAIN.conf"
    
    sudo mkdir -p "$WEB_ROOT"

    # Make a placeholder index file
    cat <<EOF | sudo tee "$WEB_ROOT/index.html" > /dev/null
<html>
	<head>
	<title>Welcome to $DOMAIN</title>
	</head>
	<body>
	<h1>Success! Virtual host of $DOMAIN is working!</h1>
	</body>
</html>
EOF

    # Create Apache Virtual Host configuration
    cat <<EOF | sudo tee "$CONF_FILE" > /dev/null
<VirtualHost *:80>
        ServerAdmin admin@$DOMAIN
        ServerName $DOMAIN
        ServerAlias www.$DOMAIN
        DocumentRoot $WEB_ROOT
        ErrorLog \${APACHE_LOG_DIR}/error.log
        CustomLog \${APACHE_LOG_DIR}/access.log combined
</VirtualHost>
EOF

    # Enable the site and reload Apache if config is valid
    sudo a2ensite "$DOMAIN"
    sudo apachectl configtest && sudo systemctl reload apache2

    echo "FQDN setup complete for $DOMAIN"

# Subdomain
elif [[ "$DOMAIN_TYPE" == "2" ]]; then
    read -p "Enter the main domain: " MAIN_DOMAIN
    read -p "Enter the subdomain (e.g., blog for blog.example.com): " SUBDOMAIN
    FULL_SUBDOMAIN="$SUBDOMAIN.$MAIN_DOMAIN"
    WEB_ROOT="/var/www/$FULL_SUBDOMAIN/public_html"
    CONF_FILE="/etc/apache2/sites-available/$FULL_SUBDOMAIN.conf"

    sudo mkdir -p "$WEB_ROOT"

    # Make a placeholder index file
    cat <<EOF | sudo tee "$WEB_ROOT/index.html" > /dev/null
<html>
	<head>
	<title>Welcome to $FULL_SUBDOMAIN</title>
	</head>
	<body>
	<h1>Success! Virtual host of $FULL_SUBDOMAIN is working!</h1>
	</body>
</html>
EOF

    # Create Apache Virtual Host configuration
    cat <<EOF | sudo tee "$CONF_FILE" > /dev/null
<VirtualHost *:80>
        ServerAdmin admin@$FULL_SUBDOMAIN
        ServerName $FULL_SUBDOMAIN
        DocumentRoot $WEB_ROOT
        ErrorLog \${APACHE_LOG_DIR}/error.log
        CustomLog \${APACHE_LOG_DIR}/access.log combined
</VirtualHost>
EOF

    # Enable the site and reload Apache if config is valid
    sudo a2ensite "$FULL_SUBDOMAIN"
    sudo apachectl configtest && sudo systemctl reload apache2

    echo "Subdomain setup complete for $FULL_SUBDOMAIN"

# Invalid Selection
else
    echo "Invalid selection. Exiting."
    exit 1
fi
