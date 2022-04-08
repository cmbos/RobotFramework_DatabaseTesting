*** Settings ***
Library    DatabaseLibrary
Library    Collections


*** Test Cases ***
Wachten op de juiste status - polling
    Wacht op processtatus    TC-02    functionele controle OK


*** Keywords ***
Verbinding maken met Database
    Connect To Database    dbConfigFile=Resources/db.cfg

Verbinding met database verbreken
    Disconnect From Database

Wacht op processtatus
    [Arguments]    ${bestandsnaam}    ${verwachte_status}
    # Query samenstellen
    ${query}=    Catenate
    ...    SELECT *
    ...    FROM LOGGING
    ...    WHERE opmerking = '${verwachte_status}'
    ...    AND bestand_id IN (
    ...        SELECT id
    ...        FROM bestand
    ...        WHERE bestandsnaam = '${bestandsnaam}'
    ...    )
    # Query uitvoeren
    Verbinding maken met Database
    FOR    ${i}    IN RANGE    5
        Sleep    2s
        ${aantal_records}=    Row Count    selectStatement=${query}
        IF    ${aantal_records} == 1
            Exit For Loop
        END
    END
    
    IF    ${aantal_records} != 1
        Fail    Record niet gevonden
    END
    
    Verbinding met database verbreken
