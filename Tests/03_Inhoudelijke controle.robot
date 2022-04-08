*** Settings ***
Library    DatabaseLibrary
Library    Collections


*** Test Cases ***
Contoleren validatiemeldingen
    ${validatiemeldingen}=    Ophalen validatiemeldingen    TC-03
    ${result_string}=    Convert To String    ${validatiemeldingen}
    Should Contain    ${result_string}    kenteken te kort(7)


*** Keywords ***
Verbinding maken met Database
    Connect To Database    dbConfigFile=Resources/db.cfg

Verbinding met database verbreken
    Disconnect From Database

Ophalen validatiemeldingen
    [Arguments]    ${bestandsnaam}
    # Query samenstellen
    ${query}=    Catenate
    ...    SELECT *
    ...    FROM validatiemeldingen
    ...    WHERE bestand_id IN (
    ...        SELECT id
    ...        FROM bestand
    ...        WHERE bestandsnaam = '${bestandsnaam}'
    ...    )
    # Query uitvoeren
    Verbinding maken met Database
    ${resultaat}=    Query    selectStatement=${query}    returnAsDict=True
    Verbinding met database verbreken
    [Return]    ${resultaat}
