import time
import os
import fcntl
# Selenium imports
from selenium import webdriver
from selenium.webdriver.support import expected_conditions as EC
from selenium.webdriver.support.ui import WebDriverWait
from selenium.webdriver.chrome.service import Service
from selenium.webdriver.common.action_chains import ActionChains
from selenium.webdriver.common.by import By
from pyvirtualdisplay import Display

class Bot:
    driver = None

    # Required for image to render and xss to trigger
    display = Display(visible=0, size=(800, 600))
    display.start()

    def __init__(self, password:str=''):
        '''
        Initializes python-class that access webpage as admin and reads all messages to automatically trigger XSS
        '''
        chrome_options = self._set_chrome_options()
        service = Service(executable_path=r'/usr/bin/chromedriver')
        self.driver = webdriver.Chrome(service=service, options=chrome_options)

    def _set_chrome_options(self):
        '''
        Sets chrome options for Selenium:
        - headless browser is enabled
        - sandbox is disbaled
        - dev-shm usage is disabled
        - SSL certificate errors are ignored
        '''
        chrome_options = webdriver.ChromeOptions()
        
        options = [
        '--headless',
        '--no-sandbox', '--disable-dev-shm-usage', '--ignore-certificate-errors', 
        '--disable-extensions', '--no-first-run', '--disable-logging',
        '--disable-notifications', '--disable-permissions-api', '--hide-scrollbars',
        '--disable-gpu', '--window-size=800,600', '--disable-xss-auditor'
        ]

        # Setup all options
        for option in options:
            chrome_options.add_argument(option)
        return chrome_options

    def close(self):
        '''
        Release driver resource
        '''
        if self.driver:
            self.driver.close()
            self.driver.quit()
            self.driver = None
        if self.display:
            self.display.stop()

if __name__ == '__main__':  
    print("\033[93mStarting bot\033[0m", flush=True)
    f = open("/flag.txt")
    flag = f.read()
    f.close()

    bot = Bot()
    # Binding Cookie to site
    bot.driver.get("http://localhost/")
    bot.driver.add_cookie({
        "name": "flag",
        "value": flag.strip(),
    })

    running = True
    while running:
        if os.path.exists("/tmp/paths"):
            f = open("/tmp/paths", "r+")
            timeout = 0
            while True:
                try:
                    fcntl.flock(f.fileno(), fcntl.LOCK_EX)
                    break
                except OSError:
                    pass
                if timeout == 5:
                    f.close()
                    exit(-1)
                timeout += 1 
                time.sleep(1)
            paths = f.readlines()
            f.truncate(0)
            fcntl.flock(f.fileno(), fcntl.LOCK_UN)
            f.close()
            
            print("\033[93mProcessing %d entries\033[0m" % len(paths), flush=True)
            for path in paths:
                print("\033[93mNavigate to %s\033[0m" % path, flush=True)
                bot.driver.get(f"http://localhost/{path}")
                time.sleep(2) # Give the bot 2000ms timeout to run the exploit
        time.sleep(5) # You may want to increase this depending on your workload
    bot.close()

