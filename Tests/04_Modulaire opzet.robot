*** Settings ***
Library    DatabaseLibrary
Library    Collections


*** Test Cases ***
Contoleren status bestand
    Controleer laatste status    TC-03    id=${8}  timestamp=2021-03-08 12:41:50  opmerking=technische controle NOK


*** Keywords ***
Verbinding maken met Database
    Connect To Database    dbConfigFile=Resources/db.cfg

Verbinding met database verbreken
    Disconnect From Database

Controleer laatste status
    [Arguments]    ${bestandsnaam}    &{verwachte_status}
    ${status}=    Ophalen laatste status    ${bestandsnaam}
    Dictionary Should Contain Sub Dictionary    ${status}    ${verwachte_status}


Ophalen laatste status
    [Arguments]    ${bestandsnaam}
    # Query samenstellen
    ${query}=    Catenate
    ...    SELECT *
    ...    FROM logging
    ...    WHERE timestamp = (
    ...        SELECT max(timestamp)
    ...        FROM logging
    ...        WHERE bestand_id in (
    ...            SELECT id
    ...            FROM bestand
    ...            WHERE bestandsnaam = '${bestandsnaam}'
    ...    	    )
    ...        GROUP BY bestand_id
    ...    )
    # Query uitvoeren
    Verbinding maken met Database
    ${resultaat}=    Query    selectStatement=${query}    returnAsDict=True
    Verbinding met database verbreken
    [Return]    ${resultaat}[0]