*** Settings ***
Library    RequestsLibrary
Library    JSONLibrary
Library    SeleniumLibrary


Variables    ../resource/url.yaml
Variables    ../resource/data_pet.yaml

*** Keywords ***
Post Upload an Image
    [Arguments]    ${petId}    ${text}    ${200/415}
    ${api_post_upload}    Set Variable    ${api}${petId}${uploadImage}
    Create Session     mysession     ${api_post_upload}
    ${header}     Create Dictionary     accept=application/json
    ${image}    GET FILE FOR STREAMING UPLOAD    ../resource/pet_image_test.png
    ${from-data}    Create Dictionary    additionalMetadata=${text}    file=${image}
    IF    '${200/415}' == '200'
        ${response}    POST ON SESSION    mysession    ${api_post_upload}    headers=${header}    files=${from-data}    expected_status=ok
        Should Be Equal    '${response.status_code}'    '${200/415}'
        Log    ${response}
        Log    ${response.json()}
    ELSE IF    '${200/415}' == '415'
        ${response}    POST ON SESSION    mysession    ${api_post_upload}    headers=${header}    expected_status=Unsupported Media Type
        Should Be Equal    '${response.status_code}'    '${200/415}'
        Log    ${response}
        Log    ${response.json()}
    END
Post Add a New Pet to The Store
    [Arguments]    ${200/405}
    Create Session    mysession    ${api}
    IF    '${200/405}' == '200'
        ${response}    POST On Session    mysession    ${api}    json=${PETID1}    expected_status=ok
        Should Be Equal    '${response.status_code}'    '${200/405}'
        Log    ${response}
        Log    ${response.json()}
    ELSE IF    '${200/405}' == '405'
        ${response}    POST On Session    mysession    ${api}    json=${PETID2}    expected_status=Method Not Allowed
        Should Be Equal    '${response.status_code}'    '${200/405}'
        Log    ${response}
        Log    ${response.json()}
    END
Put Update an Existing Pet
    [Arguments]    ${200/400/404/405}
    Create Session    mysession    ${api}
    ${header}    Create Dictionary    Content-Type=application/json
    IF    '${200/400/404/405}' == '200'
        ${response}    PUT On Session    mysession    ${api}    headers=${header}    json=${PETID2}    expected_status=ok
        Should Be Equal    '${response.status_code}'    '${200/400/404/405}'
        Log    ${response}
        Log    ${response.json()}
    ELSE IF    '${200/400/404/405}' == '400'
        ${response}    PUT On Session    mysession    ${api}    headers=${header}    data=${PETID400}    expected_status=Bad Request
        Log    ${response}
        Should Be Equal    '${response.status_code}'    '${200/400/404/405}'
        Log    ${response}
        Log    ${response.json()}
    ELSE IF    '${200/400/404/405}' == '404'
        ${response}    PUT On Session    mysession    ${api}    headers=${header}    json=${PETID2}    expected_status=Not Found
        Should Be Equal    '${response.status_code}'    '${200/400/404/405}'
        Log    ${response}
        Log    ${response.json()}
    ELSE IF    '${200/400/404/405}' == '405'
        ${response}    Get On Session    mysession    ${api}    headers=${header}    json=${PETID2}    expected_status=Method Not Allowed
        Should Be Equal    '${response.status_code}'    '${200/400/404/405}'
        Log    ${response}
        Log    ${response.json()}
    END
Get Finds Pets by Status
    [Arguments]    ${status}
    ${api_get_status}    Set Variable   ${api}${bystatus}${status}
    Create Session    mysession    ${api_get_status}
    ${body}    Create Dictionary    status=${status}
    ${response}    GET On Session    mysession    ${api_get_status}    json=${body}    expected_status=ok
    #Log To Console    ${response.json()}
Get Finds Pets by ID
    [Arguments]    ${id}
    ${api_get_id}    Set Variable   ${api}${id}
    ${body}    Create Dictionary    petId=${id}
    Create Session    mysession    ${api_get_id}
    ${response}    GET On Session    mysession    ${api_get_id}    json=${body}    expected_status=any
    IF    '${response.status_code}' == '200'
        Should Be Equal    '${response.status_code}'    '200'
    ELSE IF    '${response.status_code}' == '404'
        Should Be Equal    '${response.status_code}'    '404'
    ELSE IF    '${response.status_code}' == '400'
        Should Be Equal    '${response.status_code} '   '400'
        Log To Console    Error: response status is ${response.status_code}    
    END
Post Updates a Pet in the store with from data
    [Arguments]    ${petId}    ${name}    ${status}
    ${api_post}    Set Variable    ${api}${petId}
    ${body}    Create Dictionary    name=${name}    status=${status}
    Create Session    mysession    ${api_post}
    ${response}    POST On Session    mysession    ${api_post}    data=${body}    expected_status=ok
    Log To Console    ${response.status_code}
Delete a Pet
    [Arguments]    ${petID}    ${status}
    ${api_delete}    Set Variable    ${api}${petId}
    Create Session    mysession    ${api_delete}
    ${response}    DELETE On Session    mysession    ${api_delete}    expected_status=any
    IF    '${response.status_code}' == '200'
        Should Be Equal    '${response.status_code}'    '${status}'
        Log To Console    ${response.json()}
    ELSE IF    '${response.status_code}' == '400'
        Should Be Equal    '${response.status_code}'    '${status}'
        Log To Console    ${response.json()}
    ELSE IF    '${response.status_code}' == '404'
        Should Be Equal    '${response.status_code}'    '${status}'
        Log To Console    Error: response status is ${response.status_code}    
    END