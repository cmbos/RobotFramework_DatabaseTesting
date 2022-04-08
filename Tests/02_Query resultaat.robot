*** Settings ***
Library    DatabaseLibrary

Test Setup       Verbinding maken met Database
Test Teardown    Verbinding met database verbreken


*** Test Cases ***
Resultaat controleren - aantal records in tabel
    # uitvragen aantal records
    ${aantal_records}=    Row Count    SELECT * FROM bestand
    Should Be Equal As Integers    ${aantal_records}    4
    ...    Verkeerd aantal records in tabel

    # DB keyword - ondersteunt geen custom error message
    Row Count Is Equal To X    SELECT * FROM bestand    4

Resultaat controleren - controleer specifiek record in tabel
    Check If Exists In Database    SELECT * FROM bestand WHERE bestandsnaam = 'TC-02'

Resultaat controleren - inhoudelijke controle
    ${query}=    Set Variable    SELECT * FROM bestand WHERE bestandsnaam = 'TC-02'
    ${query_resultaat}=    Query    selectStatement=${query}    returnAsDict=True
    Should Be Equal As Strings
    ...    ${query_resultaat}[0][md5_checksum]    000df7e1874f0135fa1a2736927aaae0


*** Keywords ***
Verbinding maken met Database
    Connect To Database    dbConfigFile=Resources/db.cfg

Verbinding met database verbreken
    Disconnect From Database
