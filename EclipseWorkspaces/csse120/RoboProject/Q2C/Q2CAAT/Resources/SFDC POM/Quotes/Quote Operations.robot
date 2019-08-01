*** Settings ***
Resource    ../../Commons/Global Setup.robot
Resource    ../Opportunities/Oppties Validations.robot
Resource    Quotes Validations.robot
Resource    ../Opportunities/Oppties Validations.robot
Resource    Quote Details Locators.robot
Resource    ../Common Elements/Lookup.robot
Resource    ../Configure Products/Configure Products.robot
Resource    ../Quote Lines/Quote Lines Locators.robot


*** Keywords ***
Create Quote for Oppty '${oppty_name}'
    Current Opportunity is '${oppty_name}'
    Wait Until Page Contains Element    ${create_quote_button}
    Click Element    ${create_quote_button}
    Wait Until Page Contains    CPQ Quote
    #Wait Until Page Contains    ${quote_page_type_locator}
    ${quote_number}=    Get Current Quote Number
    ${quote_id}=        Get Current Quote ID
    Should Not Be Empty    ${quote_number}    msg=Newly created Quote number is undefined
    Set Test Variable    ${NEW_QUOTE_NUMBER}    ${quote_number}
    Set Test Variable    ${NEW_QUOTE_ID}    ${quote_id}
    Set Test Message    \nCreated Quote: ${quote_number}\n    append=yes
    Set Test Message    \nOppty: ${oppty_name}\n    append=yes
    [Teardown]    Visualize keyword result    Create Quote for Oppty '${oppty_name}'

Simplified Quote creation for Oppty '${oppty_name}'
    Current Opportunity is '${oppty_name}'
    Wait Until Page Contains Element    ${create_quote_button}
    Click Element    ${create_quote_button}
    Wait Until Page Contains    CPQ Quote 

Select value '${value}' for property '${property}' from section '${section}' 
    #Current Page is CPQ Quote Details Page
    ${property_locator}=    Locator for value of '${property}' of Quote from section '${section}'
    ${property_locator}=    Catenate    SEPARATOR=    ${property_locator}    //select
    ${t}=    Get Text    ${property_locator}
    log    ${t} 
    Scroll To Element    ${property_locator}
    Select From List    ${property_locator}    ${value}

Enter value '${value}' in '${property}' text box
    ${loc}=    Universal locator for Quote property '${property}' text
    ${loc}=    Catenate    SEPARATOR=    ${loc}    /input
    Input Text    ${loc}	${value}

Get current value of '${property}' text box
    ${loc}=    Universal locator for Quote property '${property}' text
    ${loc}=    Catenate    SEPARATOR=    ${loc}    /input
    ${current value}    Get Element Attribute    ${loc}    value
    [Return]    ${current value} 

Save Quote
    Page Should Contain Element    ${save_button}
    Page Should Contain Element    ${quote_edit_title}    
    Click Element    ${save_button}
    Wait for Page Elements Load
    Element Should Not Be Visible    ${error_mesage}    
    Wait Until Page Contains Element    ${edit_button}

GoTo Edit Quote screen
    Page Should Contain Element    ${quote_page_type_locator}
    Page Should Contain Element    ${edit_button}
    Click Element    ${edit_button} 
    Wait Until Page Contains Element    ${save_button}

Lookup '${value}' for '${property}' from section '${section}'
    ${lookup_loactor}=    Lookup locator for '${property}' of Quote from section '${section}'
    Click Element    ${lookup_loactor}
    Lookup for '${value}'

Go To Configure Products Page
    Page Should Contain Element    ${quote_page_type_locator}    loglevel=NONE  
    Click Element    ${configure_products_button}     

    
Add products to Quote by Product Codes 
    [Arguments]    ${product_codes}
    [Documentation]    
    ...    ``product_codes`` examples
    ...    TOD-TOD-PB, TOD-TOD-PK-3YR
    ...    
    ...    TOD-TOD-PB; TOD-TOD-PK-3YR
    ...    
    Go To Configure Products Page
    Add Products by Codes  ${product_codes}
    Save Products

Add product to Quote with Quatntity
    [Arguments]    ${product code}    ${quantity}
    Go To Configure Products Page
    Add Products by Codes    ${product code}
    Set Product Quantity    ${product code}    ${quantity}
    
Go To New Quote Screen
    Wait Until Page Contains Element    ${new cpq quote button}
    Click Element                       ${new cpq quote button}
    Wait Until Page Contains Element    ${new cpq page title}

Get Tax Info
    Page Should Contain Element    ${quote_page_type_locator}
    Page Should Contain Element    ${get tax info button}
    Click Element    ${get tax info button}
    ${tax alert text}=    Handle Alert    action=ACCEPT
    Should Contain    ${tax alert text}    Success
    ${matches}    Get Regexp Matches    ${tax alert text}    Success.*=(\\d+.\\d+)    1
    [Return]    ${matches[0]}
    
    