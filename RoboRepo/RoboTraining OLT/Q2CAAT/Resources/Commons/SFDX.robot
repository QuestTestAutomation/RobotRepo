*** Settings ***
Library             OperatingSystem
Library             String
Library             Collections
Resource            Global Setup.robot

*** Variables ***
${sfdx root}    "C:\\Program Files\\Salesforce CLI\\bin\\sfdx"

*** Keywords ***
Execute data query
    [Arguments]    ${query string}
    ${q}    Catenate    ${sfdx root}    force:data:soql:query -q
    ${q}    Catenate    ${q}    ${query string}
    ${q}    Catenate    ${q}    ${SPACE}-r csv
    ${result}=    Run    ${q}
    @{data set}=    Split To Lines    ${result}    1
    [Return]    @{data set}

Select SKUs with Mandatory options form set
    [Arguments]    ${product names} 
    @{list}    Split String    ${product names}    ${SPACE}OR${SPACE}
    ${string}=    Catenate    SEPARATOR=', '    @{list}
    ${string}=    Catenate    SEPARATOR=    '    ${string}    '
    ${q}    Catenate    ${sfdx root}    force:data:soql:query -q
    ${q}    Catenate    ${q}    "SELECT SBQQ__ConfiguredSKU__r.Name FROM SBQQ__ProductFeature__c WHERE SBQQ__ConfiguredSKU__r.Name in (
    ${q}    Catenate    ${q}    ${string}
    ${q}    Catenate    ${q}    ) AND SBQQ__MinOptionCount__c > 0" -r csv
    ${result}=    Run    ${q}
    @{data set}=    Split To Lines    ${result}    1
    [Return]    @{data set}

Get All SKUs for Price Book '${price book}' and Family '${prodcut family}'
    ${q}    Catenate    ${sfdx root}    force:data:soql:query -q
    ${q}    Catenate    ${q}    "SELECT CurrencyIsoCode,Id,IsActive,Name,Pricebook2.name,Product2.Name,Product2.ProductCode,Product2.Family FROM PricebookEntry 
    ${q}    Catenate    ${q}    where IsActive = true AND Product2.IsActive = true AND Pricebook2.IsActive = true AND Product2.Quoteable__c = true
    ${q}    Catenate    ${q}    AND Pricebook2.Name = '${price book}' AND Product2.Family= '${prodcut family}'" -r csv
    ${result}=    Run    ${q}
    Should Not Contain    ${result}    ERROR running force:data:soql:query
    @{data set}=    Split To Lines    ${result}    1
    [Return]    @{data set}
  
Get Product Names of QuoteLines for Quote '${quote name}'
    [Documentation]    Returns 'SBQQ__ProductName__c' fields values. Integer type.
    ${q}    Catenate    ${sfdx root}    force:data:soql:query -q
    ${q}    Catenate    ${q}    "SELECT SBQQ__ProductName__c FROM SBQQ__QuoteLine__c WHERE SBQQ__Quote__r.Name = '${quote name}'" -r csv
    ${result}=    Run    ${q}
    @{data set}=    Split To Lines    ${result}    1
    [Return]    @{data set}

Get Amounts and Quantities 
    [Arguments]    ${product names}
    @{list}    Split String    ${product names}    ${SPACE}OR${SPACE}
    ${string}=    Catenate    SEPARATOR=', '    @{list}
    ${string}=    Catenate    SEPARATOR=    '    ${string}    '
    ${query}      Catenate    ${sfdx root}    force:data:soql:query -q
    ${query}=     Catenate    ${query}    "SELECT Minimum_Purchase_Amount__c,Minimum_Purchase_Quantity__c,Minimum_Purchase_Requirement__c,Name,ProductCode FROM Product2 WHERE Name IN (
    ${query}=     Catenate    ${query}    ${string}    ) AND (Minimum_Purchase_Amount__c != NULL OR Minimum_Purchase_Quantity__c != NULL)" -r csv
    #log    ${query}
    ${result}=    Run         ${query}
    @{data set}=    Split To Lines    ${result}    1
    [Return]    @{data set}

Get Subscription Terms
    [Arguments]    ${product names}    ${special condition}=${EMPTY}
    @{list}    Split String    ${product names}    ${SPACE}OR${SPACE}
    ${string}=    Catenate    SEPARATOR=', '    @{list}
    ${string}=    Catenate    SEPARATOR=    '    ${string}    '
    ${query}      Catenate    ${sfdx root}    force:data:soql:query -q
    ${query}=     Catenate    ${query}    "SELECT Maintenance_Duration__c,SBQQ__SubscriptionTerm__c,ProductCode FROM Product2 WHERE Name IN (
    ${query}=     Catenate    ${query}    ${string} ) ${special condition}" -r csv
    ${result}=    Run         ${query}
    @{data set}=    Split To Lines    ${result}    1
    [Return]    @{data set}

Get Product Business Unit
    [Arguments]    ${product code}
    ${query}    Catenate    ${sfdx root}    force:data:soql:query -q
    ${query}    Catenate    ${query}    "SELECT Product_Business_Unit__c FROM Product2 WHERE ProductCode =    
    ${query}    Catenate    ${query}    '${product code}'
    ${query}    Catenate    ${query}    AND Product_Business_Unit__c != NULL LIMIT 1" -r csv
    ${result}=    Run         ${query}
    @{data set}=    Split To Lines    ${result}    1
    ${val}=     Set Variable If    "${data set}"=="[]"    ${EMPTY}    @{data set}[0]
    [Return]    ${val}
 
 Get Oppty ID by Name
    [Arguments]    ${name}
    ${query}    Catenate    ${sfdx root}    force:data:soql:query -q
    ${query}    Catenate    ${query}    "SELECT Id FROM Opportunity WHERE Name =     
    ${query}    Catenate    ${query}    '${name}'
    ${query}    Catenate    ${query}    LIMIT 1" -r csv
    ${result}=    Run         ${query}
    @{data set}=    Split To Lines    ${result}    1
    [Return]    @{data set}[0]

Get PSO Required status
    [Arguments]    ${product code}    ${is active}=true    ${quotable}=true
    ${query}    Catenate    ${sfdx root}    force:data:soql:query -q
    ${query}    Catenate    ${query}    "SELECT PSO_Required__c FROM Product2 WHERE ProductCode = '${product code}' AND Quoteable__c = ${quotable} AND IsActive = ${is active}
    ${query}    Catenate    ${query}    LIMIT 1" -r csv
    ${result}=    Run         ${query}
    @{data set}=    Split To Lines    ${result}    1
    [Return]    @{data set}[0]

SFDX Login to Org
    [Arguments]    ${path to sfdxurl}    ${user} 
    ${is authorized}    Is SFDX authorized    ${user}    
    #Wait Until Keyword Succeeds    10 times    3 sec    Logout all SFDX orgs
    #${path}    Split Path    ${CURDIR}
    #${path}    Split Path    ${path[0]}
    #${file path}    Catenate    ${path[0]}${/}Resources${/}Files${/}sfdxurl.auth
    Run Keyword If    '${is authorized}' == 'False'   Wait Until Keyword Succeeds    10 times    3 sec    Auth SFDX using stored URL    ${path to sfdxurl}
    #Wait Until Keyword Succeeds    10 times    3 sec    Auth SFDX using stored URL    ${path to sfdxurl}

Is SFDX authorized
    [Arguments]    ${user}
    ${query}     Catenate    ${sfdx root}    force:auth:list
    ${result}    Run         ${query}
    ${check error}    Get count    ${result}    ERROR    
    ${check user}     Get count    ${result}    ${user}
    Return From Keyword If  ${check error} == 1     ${False}       
    Return From Keyword If  ${check user} == 1    ${True}  
    Return From Keyword If  ${check user} == 0    ${False}
    
    
Auth SFDX using stored URL
    [Arguments]    ${file with url}
    ${result}=    Run    ${sfdx root} force:auth:sfdxurl:store --setdefaultusername -f "${file with url}"
    Should Contain    ${result}    Successfully authorized    

Logout all SFDX orgs
     ${result}=    Run    ${sfdx root} force:auth:logout -a -p
     Should Contain Any    ${result}    Successfully logged out of orgs.    ERROR:  No orgs can be found.    unknown error     

SFDX Login with Default Credentials
     ${path}    Split Path    ${CURDIR}
     ${path}    Split Path    ${path[0]}
     ${file path}    Catenate    ${path[0]}${/}Resources${/}Files${/}sfdxurl.auth 
     Wait Until Keyword Succeeds    5 times    3 sec    SFDX Login to Org    ${file path}    ${SF_USER}[email]   

Get Payment Term for Quote '${quote name}'
    [Documentation]    Returns 'SBQQ__ProductName__c' fields values. Integer type.
    ${q}    Catenate    ${sfdx root}    force:data:soql:query -q
    ${q}    Catenate    ${q}    "SELECT SBQQ__PaymentTerms__c FROM SBQQ__Quote__c WHERE Name = '${quote name}'" -r csv
    ${result}=    Run    ${q}
    @{data set}=    Split To Lines    ${result}    1
    [Return]    @{data set}
