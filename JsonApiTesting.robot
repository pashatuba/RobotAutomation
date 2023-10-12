*** Settings ***
Library       OperatingSystem
Library       RequestsLibrary
Library       JSONLibrary
Library       String
Library       Collections
Library       BuiltIn

*** Variables ***
${API_URL}                  https://reqres.in/api/users
${EXPECTED_JSON_FILE}       resources/libs/RestAPI.json

*** Keywords ***
Read JSON Data
    ${file_contents}         Get File  ${EXPECTED_JSON_FILE}
    ${json_data}             Evaluate  json.loads('''${file_contents}''')
    [Return]                 ${json_data}

Send GET Request
    [Arguments]  ${test_data}
    ${relative_url}           Set Variable  ${test_data["TEST_DATA"]["RELATIVE_URL"]}
    ${response_expected_status}  Set Variable  ${test_data["TEST_DATA"]["RESPONSE_EXPECTED_STATUS"]}
    ${response_expected_startwith}  Set Variable  ${test_data["TEST_DATA"]["RESPONSE_EXPECTED_STARTWITH"]}

    ${headers}               Create Dictionary  Content-Type=application/json
    Create Session          api_session  ${API_URL}
    ${response}             Get On Session  api_session
    ...                     ${relative_url}
    ...                     headers=${headers}
    ...                     verify=${False}

    Log  Response Status: ${response.status_code}

    Should Be Equal As Strings  ${response.status_code}  ${response_expected_status}

    ${response_text}        Set Variable  ${response.text}
    ${response_dict}        Evaluate  json.loads('''${response_text}''')

    Dictionary Should Contain Key  ${response_dict}  ${response_expected_startwith}

    [Teardown]               Delete All Sessions

Send POST Request
    [Arguments]  ${test_data}
    ${relative_url}           Set Variable  ${test_data["TEST_DATA"]["RELATIVE_URL"]}
    ${request_body}           Set Variable  ${test_data["TEST_DATA"]["REQUEST_BODY"]}
    ${response_expected_status}  Set Variable  ${test_data["TEST_DATA"]["RESPONSE_EXPECTED_STATUS"]}
    ${response_expected_startwith}  Set Variable  ${test_data["TEST_DATA"]["RESPONSE_EXPECTED_STARTWITH"]}

    ${headers}               Create Dictionary  Content-Type=application/json
    Create Session          api_session  ${API_URL}
    ${response}             Post On Session  api_session
    ...                     ${relative_url}
    ...                     json=${request_body}
    ...                     headers=${headers}
    ...                     verify=${False}

    log  Response Status: ${response.text}

    Should Be Equal As Strings  ${response.status_code}  ${response_expected_status}

    ${response_text}        Set Variable  ${response.text}
    ${response_dict}        Evaluate  json.loads('''${response_text}''')

    Dictionary Should Contain Key  ${response_dict}  ${response_expected_startwith}

    [Teardown]               Delete All Sessions

*** Test Cases ***
Validate API Responses
    ${api_responses}  Read JSON Data
    FOR  ${test_data}  IN  @{api_responses}
        Run Keyword If  '${test_data["TEST_DATA"]["REQUEST_TYPE"]}' == 'GET'
        ...              Send GET Request  ${test_data}
        ...              ELSE IF  '${test_data["TEST_DATA"]["REQUEST_TYPE"]}' == 'POST'
        ...              Send POST Request  ${test_data}
    END
