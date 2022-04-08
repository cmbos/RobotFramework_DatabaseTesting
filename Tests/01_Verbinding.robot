*** Settings ***
Library    DatabaseLibrary
Library    Collections


*** Test Cases ***
Verbinding maken
    Connect To Database    dbapiModuleName=psycopg2    dbName=rdw_meetup    dbUsername=postgres
    ...    dbPassword=my_secret    dbHost=localhost    dbPort=5432
    @{data}    Query    SELECT * FROM bestand
    Disconnect From Database

Verbinding maken - externe config file
    Connect To Database    dbConfigFile=Resources/db.cfg
    @{data}    Query    SELECT * FROM bestand    returnAsDict=True
    Log Dictionary    ${data}[0]
    Log    ${data}[0][md5_checksum]
    Disconnect From Database
