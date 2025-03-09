#!/bin/bash
clear

# Check if the script is run with sudo
if [[ $EUID -ne 0 ]]; then
    echo "This script has to be ran with sudo"
    exit 1
fi

# Check for system updates
read -p "Do you want to check for system update y/n: " UPDATE_CHECK

if [[ "$UPDATE_CHECK" == "y" ]]; then
	sudo apt update && sudo apt upgrade -y
else
	echo "Skipping update checks"
fi

APP_STATUS=$(systemctl status apache2 | grep active)

if echo "$APP_STATUS" | grep -q "Active: active (running)"; then
	echo "Apache is running"
elif echo "$APP_STATUS" | grep -q "Active: inactive (dead)"; then
	echo "Apache is installed but not running"
	read -p "Do you wish to start y/n: " APP_DOWN
	if [[ "$APP_DOWN" == "y" ]]; then
		echo "Starting apache"
			systemctl start apache2
		else
			echo "Apache will remain down"
	fi
	
else
	clear
	echo "Apache is not installed"
	read -p "Do you want to install Apache? y/n: " APP_INSTALL
	if [[ "$APP_INSTALL" == "y" ]]; then
	echo "Installing"
	sudo apt update && sudo apt upgrade -y && sudo apt install -y apache2
	else
	echo "Exiting script Apache is required"
	exit 1
	fi
fi


# Ask if you want to create an FQDN or a subdomain
clear
echo "Do you want to create a (1) FQDN or (2) Subdomain?"
read -p "Enter 1 for FQDN or 2 for Full Subdomain: " DOMAIN_TYPE

# FQDN
if [[ "$DOMAIN_TYPE" == "1" ]]; then
    read -p "Enter the main domain: " DOMAIN
	read -p "(1) Default (www-data:www-data) or (2) Custom owner/group: " OWNER_GROUP_TYPE
	
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
        ServerName www.$DOMAIN
        ServerAlias $DOMAIN
        DocumentRoot $WEB_ROOT
        ErrorLog \${APACHE_LOG_DIR}/error.log
        CustomLog \${APACHE_LOG_DIR}/access.log combined
</VirtualHost>
EOF

    # Enable the site
    sudo a2ensite "${DOMAIN}.conf"
    # Validate Apache configuration before reloading
    if sudo apachectl configtest; then
        sudo systemctl reload apache2
    else
        echo "Apache configuration test failed. Check your VirtualHost settings."
        exit 1
    fi
	
	if [[ "$OWNER_GROUP_TYPE" == "1" ]]; then
		chown -R www-data:www-data "$WEB_ROOT"
		chmod -R 755 "$WEB_ROOT"
	elif [[ "$OWNER_GROUP_TYPE" == "2" ]]; then
		echo "Please make sure anything regaring the owner and group setup has been pre-configed"
		read -p "Please enter the owner" OWNER_TYPE
		read -p "Please enter the group" GROUP_TYPE
		OWNER_TYPE_LOWER="${OWNER_TYPE,,}"
		GROUP_TYPE_LOWER="${GROUP_TYPE,,}"
		chown -R "$OWNER_TYPE_LOWER":"$GROUP_TYPE_LOWER" "$WEB_ROOT"
		chmod -R 755 "$WEB_ROOT"
		
	else
		echo "Invalid selection. Exiting."
	exit 1
	fi

    echo "FQDN setup complete for $DOMAIN"

# Subdomain
elif [[ "$DOMAIN_TYPE" == "2" ]]; then
    read -p "Enter the subdomain (e.g., blog for blog.example.com): " SUBDOMAIN
	read -p "(1) Default (www-data:www-data) or (2) Custom owner/group: " OWNER_GROUP_TYPE
	
    WEB_ROOT="/var/www/$SUBDOMAIN/public_html"
    CONF_FILE="/etc/apache2/sites-available/$SUBDOMAIN.conf"

    sudo mkdir -p "$WEB_ROOT"

    # Make a placeholder index file
    cat <<EOF | sudo tee "$WEB_ROOT/index.html" > /dev/null
<html>
	<head>
	<title>Welcome to $SUBDOMAIN</title>
	</head>
	<body>
	<h1>Success! Virtual host of $SUBDOMAIN is working!</h1>
	</body>
</html>
EOF

    # Create Apache Virtual Host configuration
    cat <<EOF | sudo tee "$CONF_FILE" > /dev/null
<VirtualHost *:80>
        ServerAdmin admin@$SUBDOMAIN
        ServerName $SUBDOMAIN
        DocumentRoot $WEB_ROOT
        ErrorLog \${APACHE_LOG_DIR}/error.log
        CustomLog \${APACHE_LOG_DIR}/access.log combined
</VirtualHost>
EOF

    # Enable the site
    sudo a2ensite "${SUBDOMAIN}.conf"
    # Validate Apache configuration before reloading
    if sudo apachectl configtest; then
        sudo systemctl reload apache2
    else
        echo "Apache configuration test failed. Check your VirtualHost settings."
        exit 1
    fi
	
		if [[ "$OWNER_GROUP_TYPE" == "1" ]]; then
		chown -R www-data:www-data "$WEB_ROOT"
		chmod -R 755 "$WEB_ROOT"
	elif [[ "$OWNER_GROUP_TYPE" == "2" ]]; then
		echo "Please make sure anything regaring the owner and group setup has been pre-configed"
		read -p "Please enter the owner" OWNER_TYPE
		read -p "Please enter the group" GROUP_TYPE
		OWNER_TYPE_LOWER="${OWNER_TYPE,,}"
		GROUP_TYPE_LOWER="${GROUP_TYPE,,}"
		chown -R "$OWNER_TYPE_LOWER":"$GROUP_TYPE_LOWER" "$WEB_ROOT"
		chmod -R 755 "$WEB_ROOT"
		
	else
		echo "Invalid selection. Exiting."
	exit 1
	fi

    echo "Subdomain setup complete for $SUBDOMAIN"

# Invalid Selection
else
    echo "Invalid selection. Exiting."
    exit 1
fi
