*** Settings ***
Library    RequestsLibrary
Resource    ../keyword/pet.robot
Variables    ../resource/data_pet.yaml
*** Test Cases ***
1. 200
    pet.Post Upload an Image    1    test200    200
2. 415
    pet.Post Upload an Image    2    test415    415
3. 200
    pet.Post Add a New Pet to The Store    200
4. Put 200
    pet.Put Update an Existing Pet