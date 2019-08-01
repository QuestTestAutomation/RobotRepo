*** Settings ***
Resource    ../../Commons/Global Setup.robot
Resource    ../Opportunities/Oppties Validations.robot
Resource    ../Common Elements/Lookup.robot
Resource    ../Configure Products/Configure Products.robot
Resource    ../Quote Lines/Quote Lines Locators.robot


*** Keyword ***

Open Quote Line for '${product code}'
    ${loc}=    Locator of Quote Line link with product code '${product code}'
    Click Element    ${loc}
    Wait Until Page Contains Element    ${quote line page type}  

Open Edit Screen for current Quote Line 
    Wait Until Page Contains Element    ${quote line page type}
    Click Button    ${edit_button}
    Wait Until Element Contains    ${quote line page type}    Quote Line Edit    
    