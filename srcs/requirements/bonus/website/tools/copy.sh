#!bin/bash

# if [ ! -f "/var/www/html/index.html" ]; then
    # mv /data/website/* /var/www/html
# fi

# cd /data/website/src

# mkdir -p /static_website
# cp /data/website/src/* /static_website
# cp /static_website/src/index.html /static_website/index.html
cd /
python3 -m http.server