*** Settings ***
Library     RequestsLibrary
Library     Collections
 
 
*** Variables ***
${base_url}         https://reqres.in/api/users
${page_id}          2
${expectedname}     test
${expectedjob}      team leader
 
*** Test Cases ***
 
Quick Get Request Test
    ${response}=    GET      ${base_url}     params=page=${page_id}   expected_status=200
    log    ${response.json()}
    Should Be Equal As Strings    6  ${response.json()}[per_page]
    Should Be Equal As Strings    12  ${response.json()}[total]
    Should Be Equal As Strings    7  ${response.json()}[data][0][id]
 
Quick POST Request Test
    &{req_body}=  Create Dictionary    name=test        job=team leader
    ${response}=     POST        ${base_url}     json=${req_body}    expected_status=201
    log      ${response.json()}
    Dictionary Should Contain Key     ${response.json()}     id
    ${name}=    Get From Dictionary     ${response.json()}    name
    Should Be Equal As Strings    ${expectedname}   ${name}
 
    ${job}=    Get From Dictionary     ${response.json()}    job
    Should Be Equal As Strings    ${expectedjob}    ${job}
