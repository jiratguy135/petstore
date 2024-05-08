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
