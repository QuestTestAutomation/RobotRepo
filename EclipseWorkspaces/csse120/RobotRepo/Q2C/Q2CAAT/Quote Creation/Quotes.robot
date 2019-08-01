*** Settings ***
Resource    ../Resources/Commons/Global Setup.robot
Resource    ../Resources/SFDC POM/Login/Login.robot
Resource    ../Resources/SFDC POM/Common Elements/Details Page.robot
Resource    ../Resources/SFDC POM/SFDC Navigation/Search and Open SFDC Objects.robot
Resource    ../Resources/SFDC POM/Opportunities/Oppties Validations.robot
Resource    ../Resources/SFDC POM/Quotes/Quote Operations.robot
Resource    ../Resources/SFDC POM/Quote Lines/Quote Lines Operations.robot
Resource    ../Resources/SFDC POM/Quote Lines/Quote Lines Validations.robot
Suite Setup      Suite Setup
Test Setup       Login To SFDC sandbox
Test Teardown    Test Teardown

*** Variables ***
${TEST_OPPTY}                Gennady Borodin - Gennady+Borodin+Manual Commercial Account Creation - NAM - License - Oppty-3497115
${TEST_ACCOUNT}              Gennady+Borodin+Manual Commercial Account Creation - NAM
${TEST_CONTACT}              Test ManuallTest
${CHANGE_TO_TEST_ACCOUNT}    Change to This One Account Creation - NAM
${CHANGE_TO_TEST_CONTACT}    Test ChangeTo
${LONG PO NUMBER}            11111222223333344444555556666677777888889999900000  
${NEW_QUOTE_NUMBER}          ${None}
${NEW_QUOTE_ID}              ${None}
${10 mail boxes}             m1@d.com,m2@d.com,m3@d.com,m4@d.com,m5@d.com,m6@d.com,m7@d.com,m8@d.com,m9@d.com,m10@d.com
   

*** Test Cases ***
Manual Quote Creation
    [Documentation]    *Use Case ID:* Q4.1
    ...    
    ...    *JIRA Story:* https://jira.labs.quest.com/browse/ITQTC-2562
    ...    
    ...    *JIRA Story:* https://jira.labs.quest.com/browse/ITQTC-2489
    ...    
    
    [Tags]  C315423
    Open 'Opportunity' with name '${TEST_OPPTY}'
    Check property 'Stage' of Oppty '${TEST_OPPTY}' is NOT LIKE 'Closed Won'
    Check property 'Stage' of Oppty '${TEST_OPPTY}' is NOT LIKE 'Booked'
    Create Quote for Oppty '${TEST_OPPTY}'
    Validate Quote Name for Account '${TEST_ACCOUNT}'
    Check Quote Start Day is Today
    Check Quote Effective Through End Date is to '180' from Start Date
    Quote Property 'Opportunity' should conatin '${TEST_OPPTY}'
    Quote Property 'Account' should conatin '${TEST_ACCOUNT}'
    Quote Property 'Primary Contact' should conatin '${TEST_CONTACT}'
    Quote Property 'Opportunity RTM' should conatin 'Direct'
    Quote Property 'Business Unit' should conatin 'Quest'
    Quote Property 'Owner' should conatin '&{SF_USER}[display_name]'
    Quote Property 'Quote Source' should conatin 'Direct'
    Quote Property 'Status' should conatin 'Draft'
    Quote Property 'Price Book' should conatin 'US PRICE LIST'
    Quote Currency fields should contain 'USD'
    Quote 'Primary' Checkbox is 'Not Checked'
    Quote Property 'Bill To Account' should conatin '${TEST_ACCOUNT}'
    Quote Property 'Bill To Contact' should conatin '${TEST_CONTACT}'
    Quote Property 'Ship To Account' should conatin '${TEST_ACCOUNT}'
    Quote Property 'Ship To Contact' should conatin '${TEST_CONTACT}'
    Quote Property 'Bill To Account' should conatin '${TEST_ACCOUNT}'
    Quote Property 'End User Account' should conatin '${TEST_ACCOUNT}'
    Quote Property 'End User Contact' should conatin '${TEST_CONTACT}'
    Quote Property 'Payment Terms' should conatin 'Net 30'

Payment Method for quote
    [Documentation]        *Use Case ID:* Q4.1.3
    ...    
    ...    *JIRA Story:* https://jira.labs.quest.com/browse/ITQTC-2562
    ...    
    ...    *JIRA Story:* https://jira.labs.quest.com/browse/ITQTC-2489
    ...    
    [Tags]    C315427
    Open 'Opportunity' with name '${TEST_OPPTY}'
    Create Quote for Oppty '${TEST_OPPTY}'
    Quote Property 'Payment Terms' should conatin 'Net 30'
    GoTo Edit Quote screen
    Select value 'Net 90' for property 'Payment Terms' from section 'Bill To'
    Save Quote
    Quote Property 'Payment Terms' should conatin 'Net 90'
    
Associate Ship to Account and Ship to Contact
    [Documentation]        *Use Case ID:* Q4.1.47
    ...    
    ...    *JIRA Story:* https://jira.labs.quest.com/browse/ITQTC-2562
    ...    
    ...    *JIRA Story:* https://jira.labs.quest.com/browse/ITQTC-2489
    ...
    [Tags]    C313803    C313806
    Open 'Opportunity' with name '${TEST_OPPTY}'
    Create Quote for Oppty '${TEST_OPPTY}'
    GoTo Edit Quote screen
    Lookup '${CHANGE_TO_TEST_ACCOUNT}' for 'Ship To Account' from section 'Ship To Information'
    Lookup '${CHANGE_TO_TEST_CONTACT}' for 'Ship To Contact' from section 'Ship To Information'
    Save Quote
    Quote Property 'Ship To Account' should conatin '${CHANGE_TO_TEST_ACCOUNT}'
    Quote Property 'Ship To Contact' should conatin '${CHANGE_TO_TEST_CONTACT}'
    
Associate End User Account and End User Contact
    [Documentation]        *Use Case ID:* Q4.1.45
    ...    
    ...    *JIRA Story:* https://jira.labs.quest.com/browse/ITQTC-2562
    ...    
    ...    *JIRA Story:* https://jira.labs.quest.com/browse/ITQTC-2489
    ...
    [Tags]    C313804    C313801
    Open 'Opportunity' with name '${TEST_OPPTY}'
    Create Quote for Oppty '${TEST_OPPTY}'
    GoTo Edit Quote screen
    Lookup '${CHANGE_TO_TEST_ACCOUNT}' for 'End User Account' from section 'End User Information'
    Lookup '${CHANGE_TO_TEST_CONTACT}' for 'End User Contact' from section 'End User Information'
    Save Quote
    Quote Property 'End User Account' should conatin '${CHANGE_TO_TEST_ACCOUNT}'
    Quote Property 'End User Contact' should conatin '${CHANGE_TO_TEST_CONTACT}'
    
Associate Bill To Account and Bill To Contact
    [Documentation]        *Use Case ID:* Q4.1.46
    ...    
    ...    *JIRA Story:* https://jira.labs.quest.com/browse/ITQTC-2562
    ...    
    ...    *JIRA Story:* https://jira.labs.quest.com/browse/ITQTC-2489
    ...
    [Tags]    C313805
    Open 'Opportunity' with name '${TEST_OPPTY}'
    Create Quote for Oppty '${TEST_OPPTY}'
    GoTo Edit Quote screen
    Lookup '${CHANGE_TO_TEST_ACCOUNT}' for 'Bill To Account' from section 'Bill To'
    Lookup '${CHANGE_TO_TEST_CONTACT}' for 'Bill To Contact' from section 'Bill To'
    Save Quote
    Quote Property 'Bill To Account' should conatin '${CHANGE_TO_TEST_ACCOUNT}'
    Quote Property 'Bill To Contact' should conatin '${CHANGE_TO_TEST_CONTACT}'
    
Quote Totals
    [Documentation]        *Use Case ID:* Q4.1.34
    ...    
    ...    *JIRA Story:* https://jira.labs.quest.com/browse/ITQTC-2562
    ...    
    ...    *JIRA Story:* https://jira.labs.quest.com/browse/ITQTC-2489
    ...
    [Tags]    C313790
    Open 'Opportunity' with name '${TEST_OPPTY}'
    Create Quote for Oppty '${TEST_OPPTY}'
    Add products to Quote by Product Codes	TOD-TOD-PB; TOD-TOD-TB
    Quote Lines Should Contain Product Codes    TOD-TOD-PB; TOD-TOD-TB
    ${tax amount}=    Get Tax Info
    Open Quote Line for 'TOD-TOD-TB'
    'Quote Line' property 'List Total' should conatin 'USD 341.00'
    'Quote Line' property 'Total Discount (%)' should conatin '0.000%'
    'Quote Line' property 'Total Discount (Amt)' should conatin 'USD 0.00'
    'Quote Line' property 'Net Total' should conatin 'USD 341.00'
    'Quote Line' property 'Tax Amount' should conatin 'USD 0.00'

Purchase Order number for quote
    [Documentation]        *Use Case ID:* Q4.1.4
    ...    
    ...    *JIRA Story:* https://jira.labs.quest.com/browse/ITQTC-2562
    ...    
    ...    *JIRA Story:* https://jira.labs.quest.com/browse/ITQTC-2489
    ...    
    [Tags]    C313771
    Open 'Opportunity' with name '${TEST_OPPTY}'
    Create Quote for Oppty '${TEST_OPPTY}'
    GoTo Edit Quote screen
    Enter value '${LONG PO NUMBER}' in 'PO Number' text box
    Save Quote
    GoTo Edit Quote screen
    Scroll 'PO Number' into view
    ${actual PO Number}    Get current value of 'PO Number' text box
    Should Be Equal As Strings    ${actual PO Number}    ${LONG PO NUMBER}    msg=PO Number mismatch

Capture line type for each quote line
    [Documentation]        *Use Case ID:* Q4.1.4
    ...    
    ...    *JIRA Story:* https://jira.labs.quest.com/browse/ITQTC-2562
    ...    
    ...    *JIRA Story:* https://jira.labs.quest.com/browse/ITQTC-2489
    ...    
    [Tags]    C313777
    Open 'Opportunity' with name '${TEST_OPPTY}'
    Create Quote for Oppty '${TEST_OPPTY}'
    Add products to Quote by Product Codes	TOD-TOD-PB; TOD-TOD-TB
    Quote Lines Should Contain Product Codes    TOD-TOD-PB; TOD-TOD-TB
    Open Quote Line for 'TOD-TOD-TB'
    'Quote Line' property 'Line Types' should conatin 'Term License/Maint.'
    

Additional email address addition to quote
    [Documentation]        *Use Case ID:* Q4.1.87
    ...    
    ...    *JIRA Story:* https://jira.labs.quest.com/browse/ITQTC-2562
    ...    
    ...    *JIRA Story:* https://jira.labs.quest.com/browse/ITQTC-2489
    ...    
    [Tags]    C313837
    Open 'Opportunity' with name '${TEST_OPPTY}'
    Create Quote for Oppty '${TEST_OPPTY}'
    GoTo Edit Quote screen
    Enter value '${10 mail boxes}' in 'Additional Email' text box
    Save Quote
    Quote Property 'Additional Email' should conatin '${10 mail boxes}'

Verify Sales rep is able to edit Quantity from configurator screen on quote line
    [Documentation]        *Use Case ID:* Q4.1.15
    [Tags]    C313779
    Open 'Opportunity' with name '${TEST_OPPTY}'
    Create Quote for Oppty '${TEST_OPPTY}'
    Go To Configure Products Page
    Add product to Quote with Quatntity    AAA-WGA-PB    123
    Quote Total Should Be 'USD 1,230.00'
    Save Products
    Quote Line for 'AAA-WGA-PB' Should Contian '123.00' Quantity
    Quote Line for 'AAA-WGA-PB' Should Contian 'USD 1,230.00' Net Total

Maintenance Start Date on Quote Line
    [Documentation]        *Use Case ID:* Q4.1.17
    [Tags]      C313781
    Open 'Opportunity' with name '${TEST_OPPTY}'
    Create Quote for Oppty '${TEST_OPPTY}'
    Add products to Quote by Product Codes	TOD-TOD-TB
    Open Quote Line for 'TOD-TOD-TB'
    Property 'Effective Start Date' of section 'Subscription Information' is NOT EMPTY
    Property 'Effective End Date' of section 'Subscription Information' is NOT EMPTY
    Check Quote Line 'Effective Start Date' is Today
    'Quote Line' property 'Effective End Date' should conatin 'unknown default maint term'
