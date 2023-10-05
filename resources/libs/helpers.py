from selenium import webdriver
from webdriver_manager.chrome import ChromeDriverManager
from webdriver_manager.firefox import GeckoDriverManager

def get_driver_path(browser):
    driver = None
    if browser == "chrome":
        driver = webdriver.Chrome()
    else:
        print("Incorrect Browser")
    return driver
