*** Settings ***
Library    SeleniumLibrary
Library    Collections
Library    String
Resource    ../Quotes/Quote Details Locators.robot

*** Variables ***
${add_products_button}           //paper-button[@id="mainButton"][text()="Add Products"]
${save_products_button}          //paper-button[@id="mainButton"][text()="Save"]
${product_selection_title}       //h1//*[text()="Product Selection"]
${search_products_textbox}       //div[@id="searchbar"]//input[@placeholder="Search Products"]
${search_button}                 //div[@id="searchbar"]//paper-button[@id="search"]
${select_all_results_checkbox}   //sb-lookup-layout//sb-table-header[@id="header"]//div[@id="checkboxContainer"]
${spinner_is_hidden}             //sb-page-container[@id="sbPageContainer"]//sf-loading-spinner[@show="true"]//div[@id="mask" and @hidden]
${select_button}                 //paper-button[@id="plSelect"]//*[text() = "Select"]/..
${filter button}                 //paper-button[@id="fb"]
${product filter title}          //sb-i18n[text() = "Product Filter"]
${product filter panel}          //iron-selector//div[@id="drawer"]
${close product filter button}   //iron-selector//div[@id="drawer"]//i[contains(@class, "close")]
${alert dialog title}            //sb-product-alert[@id="productAlertModal"]//div[@id="alert-title"]//*[text()="Alert"]
${continue button in alert}      //paper-button[@id="continue" and contains(@class, "sb-product-alert")]
${quote total value}             //sb-field[@id="quoteTotal"]/descendant::div[text()]

*** Keyword ***
Locator for Product Filter '${filter name}'
    ${loc}    Catenate    SEPARATOR=    //div[text() = "    ${filter name}    "]/..//select
    [Return]    ${loc}
    
Locator for Quantity of '${product code}'
    ${loc}    Catenate   SEPARATOR=    //div[@id="tableContainer"]//div[@id="datatable"]//div[@field="SBQQ__ProductCode__c"]/*[text()="    ${product code}
    ${loc}    Catenate   SEPARATOR=    ${loc}    "]/ancestor-or-self::div[@field="SBQQ__ProductCode__c"]/following-sibling::div[@field="SBQQ__Quantity__c"]
    [Return]    ${loc}


Build Search Query fro Prodcuts by Codes
    [Arguments]    ${codes_string}
    ${query}=    Replace String    ${codes_string}    -    ${EMPTY}
    ${query}=    Replace String    ${query}    ,${SPACE}    ${SPACE}OR${SPACE}
    ${query}=    Replace String    ${query}    ;${SPACE}    ${SPACE}OR${SPACE}
    [Return]     ${query}

Add Products by Codes 
    [Arguments]    ${codes_string}
    Open Product Selection Page
    Close Product Filter Panel If Open
    ${query}=    Build Search Query fro Prodcuts by Codes    ${codes_string}
    Input Text    ${search_products_textbox}    ${query}
    Click Element    ${search_button}
    Wait Until Page Contains Element    ${spinner_is_hidden}
    sleep    1     
    Click Element    ${select_all_results_checkbox}
    Click Element    ${select_button} 
    Wait Until Page Contains Element    ${add_products_button}    error=Page did not returned to 'Add Products' page

Set Product Quantity
    [Arguments]    ${product code}    ${quantity}
    Wait Until Page Contains Element    ${add_products_button}    error=Page does not contain 'Add Products' button
    Wait Until Page Contains Element    ${spinner_is_hidden} 
    ${loc}=    Locator for Quantity of '${product code}'
    Click Element    ${loc}
    Click Element    ${loc}
    Wait Until Page Contains Element    ${loc}//input
    Press Key    ${loc}//input    ${quantity}
    Press Key    ${loc}//input    \\13
    Element Text Should Be    ${loc}/div    ${quantity}
    Wait Until Page Contains Element    ${spinner_is_hidden}

Quote Total Should Be '${expected quote total}'
    Page Should Contain Element    ${quote total value}
    ${actual quote total}    Get Text    ${quote total value}
    ${actual quote total}    Replace String    ${actual quote total}    ${SPACE}${SPACE}    ${SPACE}
    Should Be Equal As Strings    ${actual quote total}    ${expected quote total}        
    

Save Products
    Click Element    ${save_products_button}
    Wait Until Page Contains Element    ${spinner_is_hidden}
    Continue on Alert
    Wait Until Page Contains Element    ${edit_button} 

Open Product Selection Page
    Wait Until Page Contains Element    ${add_products_button}    error=Page does not contain 'Add Products' button    
    Click Element    ${add_products_button} 
    Wait Until Page Contains Element    ${product_selection_title}
    Wait Until Page Contains Element    ${search_products_textbox}    
    Wait Until Page Contains Element    ${spinner_is_hidden} 

Activate Product Filter
    Wait Until Page Contains Element    ${filter button}	error=Page does not contain 'Filter' button
    Click Element    ${filter button}
    Wait Until Page Contains Element    ${product filter title}

Deactivate Product Filter
    Wait Until Page Contains Element    ${product filter title}
    Click Element    ${close product filter button}

Select in Product Filter '${value}' in '${filter}'
    Wait Until Page Contains Element    ${product filter title}
    ${filter locator}    Locator for Product Filter '${filter}'
    Select From List By Label    ${filter locator}    ${value}

Close Product Filter Panel If Open
    ${panel state}=    Get Element Attribute    ${product filter panel}    class
    Run Keyword If    'iron-selected' in '${panel state}'    Deactivate Product Filter

Open Product Filter Panel If Closed
    ${panel state}=    Get Element Attribute    ${product filter panel}    class
    Run Keyword If    'iron-selected' not in '${panel state}'    Activate Product Filter

Continue on Alert
    ${if alert}    Get Element Count    ${alert dialog title}
    Run Keyword If    ${if alert} > 0    Click Element    ${continue button in alert}
    

