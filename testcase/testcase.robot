*** Settings ***
Library    RequestsLibrary
Resource    ../keyword/pet.robot
Variables    ../resource/data_pet.yaml
*** Test Cases ***
TC_001 Post Upload an Image Successfully Get Status Code 200
    pet.Post Upload an Image    1    test200    200
TC_002 Post Upload an Image Unsupported Media Type Get Status Code 415
    pet.Post Upload an Image    2    test415    415
TC_003 Post Add a New Pet to The Store Successfully Get Status Code 200
    pet.Post Add a New Pet to The Store    200
#TC_004 Post Add a New Pet to The Store Invalid input Get Status Code 400
    #pet.
TC_005 Put Update an Existing Pet Successfully Get Status Code 200
    pet.Put Update an Existing Pet    200
TC_006 Put Update an Existing Pet Invalid ID supplied Get Status Code 400
    pet.Put Update an Existing Pet    400
#TC_007 Put Update an Existing Pet Bad Request Get Status Code 404
    #pet.
#TC_008 Put Update an Existing Pet Validation exception Get Status Code 405
    #pet.Put Update an Existing Pet    405
TC_009 Get Finds Pets by Status Avaliable Successfully Get Status Code 200
    pet.Get Finds Pets by Status    avaliable
TC_010 Get Finds Pets by Status Pending Successfully Get Status Code 200
    pet.Get Finds Pets by Status    pending
TC_011 Get Finds Pets by Status Sold Successfully Get Status Code 200
    pet.Get Finds Pets by Status    sold
#TC_012 Get 400
TC_013 Get Finds Pets by ID Successfully Get Status Code 200
    pet.Get Finds Pets by ID    1
#TC_014 Get Finds Pets by ID Get Status Code 400
    #pet.Get Finds Pets by ID    dfsa
TC_015 Get Finds Pets by ID Get Status Code 404
    pet.Get Finds Pets by ID    1444
TC_016 Post Updates a Pet in the store with from data Successfully Get Status Code 200
    pet.Post Updates a Pet in the store with from data    5    test101    pending
#17.Post Updates a Pet in the store with from data Successfully Get Status Code 405

TC_018 Delete a Pet Successfully Get Status Code 200
    pet.Delete a Pet    1    200
#19. Delete 400

TC_020 Delete a Pet Not Found Get Status Code 404
    pet.Delete a Pet    9999    404