# Debian 12
# PHP 8.7.3
# Apache 2.4.59
FROM docker.io/library/php@sha256:b3ff205fcc739fc504750dab29d4c30afb2702730d37a1068a16c14f30a7d48f

ARG DEBIAN_FRONTEND=noninteractive

RUN apt-get update && apt-get install -y \
    python3 python3-pip curl unzip wget util-linux \
    fonts-liberation libasound2 libatk-bridge2.0-0 procps \
    libnss3 lsb-release xdg-utils libxss1 libdbus-glib-1-2 \
    libcairo2 libcups2 libgbm1 libgtk-3-0 libpango-1.0-0 \
    libu2f-udev libvulkan1 libxkbcommon-x11-0 xvfb && apt-get clean

RUN CHROME_SETUP=google-chrome.deb && \
    wget -q -O $CHROME_SETUP "https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb" && \
    dpkg -i $CHROME_SETUP && \
    apt-get install -y -f && \
    rm $CHROME_SETUP
RUN CHROMEDRIVER_VERSION=$(google-chrome --version | sed "s/Google Chrome//" | xargs) && wget -q -O chromedriver_linux64.zip https://storage.googleapis.com/chrome-for-testing-public/$CHROMEDRIVER_VERSION/linux64/chromedriver-linux64.zip && \
    unzip chromedriver_linux64.zip && mv chromedriver-linux64/chromedriver /usr/bin/ && \
    chmod +x /usr/bin/chromedriver && \
    rm chromedriver_linux64.zip && rm -r chromedriver-linux64

RUN python3 -m pip install selenium urllib3 python-decouple requests bs4 pyvirtualdisplay
# Copy challenge required files

COPY ./challenge/config/php.ini $PHP_INI_DIR/php.ini
COPY ./challenge/web /var/www/html
COPY ./challenge/bot /bot
COPY ./challenge/flag.txt /flag.txt
COPY ./challenge/entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh
RUN touch /tmp/paths && chmod 777 /tmp/paths
CMD ["/entrypoint.sh"]
