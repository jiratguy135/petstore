*** Settings ***
Library    RequestsLibrary
Library    JSONLibrary

Variables    ../resource/url.yaml
Variables    ../resource/data_pet.yaml

*** Keywords ***
Post Upload an Image
    [Arguments]    ${petId}    ${text}    ${200/415}
    ${URL}    Set Variable    ${api}${petId}${uploadImage}
    Create Session     mysession     ${URL}
    ${Header}     Create Dictionary     accept=application/json
    ${image}    GET FILE FOR STREAMING UPLOAD    ../resource/pet_image_test.png
    ${from-data}    Create Dictionary    additionalMetadata=${text}    file=${image}
    IF    '${200/415}' == '200'
        ${response}    POST ON SESSION    mysession    ${URL}    headers=${Header}    files=${from-data}    expected_status=ok
        Log To Console    ${response}
        #Log To Console    ${response.headers}
        #Log To Console    ${response.json()}
    ELSE IF    '${200/415}' == '415'
        ${response}    POST ON SESSION    mysession    ${URL}    headers=${Header}    expected_status=Unsupported Media Type
        Log To Console    ${response}
        #Log To Console    ${response.headers}
        #Log To Console    ${response.json()}
    END
Post Add a New Pet to The Store
    [Arguments]    ${200/405}
    Create Session    mysession    ${api}
    IF    '${200/405}' == '200'
        ${response}    POST On Session    mysession    ${api}    json=${PETID1}    expected_status=ok
        Log To Console    ${response}
        Log To Console    ${response.json()}
    ELSE IF    '${200/405}' == '405'
        ${response}    POST On Session    mysession    ${api}    json=${PETID2}    expected_status=Method Not Allowed
        Log To Console    ${response}
        Log To Console    ${response.json()}
    END
    
Put Update an Existing Pet
    Create Session    mysession    ${api}
    ${response}    PUT On Session    mysession    ${api}    json=${PETID2}    expected_status=ok
    Log To Console    ${response.json()}
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
    END
    