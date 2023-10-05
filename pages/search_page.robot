*** Settings ***
Documentation   Search Page Variables and Keywords
Resource        imports.robot

*** Variables ***
${search_page}          ${url}
${search_input}         //*[@id='searchbox_input']
${search_button}        //*[@id="searchbox_homepage"]/div/div/button[2]

*** Keywords ***

Open Browser To Search Page
    Open Browser To Page    ${search_page}
