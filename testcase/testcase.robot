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
#4. Put 200
#    pet.Put Update an Existing Pet
9. Get 200 Avaliable
    pet.Get Finds Pets by Status    avaliable
10. Get 200 Pending
    pet.Get Finds Pets by Status    pending
11. Get 200 Sold
    pet.Get Finds Pets by Status    sold
13. Get 200
    pet.Get Finds Pets by ID    1
#14. Get 400
    #pet.Get Finds Pets by ID    dfsa
15. Get 404
    pet.Get Finds Pets by ID    1444