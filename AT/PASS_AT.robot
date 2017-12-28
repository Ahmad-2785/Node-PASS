*** Settings ***
Library           OperatingSystem
Library           Selenium2Library

*** Variables ***
${homeworkName}    1234
${fileUploadPath}    ${CURDIR}
${fileDownloadPath}    ~/downloads

*** Test Cases ***
成功新增作業(CMS-TC02)
    [Setup]    teacherLogin
    click element    id=Software Engineering
    click element    id=createHW
    Wait Until Element Is Visible    id=InputhomeworkName    3s
    input text    id=InputhomeworkName    ${homeworkName}
    ${dueDate}=    get value    id=InputDueDateInAddHW
    input text    id=InputhwPercentage    10
    input text    id=InputhwFileExtension    txt
    input text    name=homeworkDescription    test
    click button    id=addHw
    Reload Page
    Wait Until Element Is Visible    id=${homeworkName}    3s
    element text should be    id=${homeworkName}    ${homeworkName}
    element text should be    id=HW${homeworkName}_dueDate    ${dueDate}
    element text should be    id=HW${homeworkName}_percentage    10
    element text should be    id=HW${homeworkName}_fileExtension    txt
    element text should be    id=HW${homeworkName}_homeworkDescription    test
    element text should be    id=HW${homeworkName}_dueDateExtension    No
    [Teardown]    Run Keywords    click element    id=delete_${homeworkName}
    ...    AND    close browser

新增作業內容為空(CMS-TC03)
    [Setup]    teacherLogin
    click element    id=Software Engineering
    click element    id=createHW
    clear element text    id=InputDueDateInAddHW
    click button    id=addHw
    ${testHomeworkName}=    Execute JavaScript    return window.document.getElementById("InputhomeworkName").getAttribute("oninvalid").split("'")[1]
    should be equal    ${testHomeworkName}    This field is required.
    input text    id=InputhomeworkName    ${homeworkName}
    ${testDueDate}=    Execute JavaScript    return window.document.getElementById("InputDueDateInAddHW").getAttribute("oninvalid").split("'")[1]
    should be equal    ${testDueDate}    This date format is wrong.
    [Teardown]    close browser

成功編輯作業(CMS-TC04)
    [Setup]    老師新增作業並關閉
    teacherLogin
    Click Element    id=Software Engineering
    click element    id=edit_${homeworkName}
    input text    name=dueDate    12/13/2018 5:36 PM
    input text    name=homeworkDescription    Description is changed!!!
    click element    id=dueDateExtension
    click button    id=submitInEditHW
    element text should be    id=HW${homeworkName}_dueDate    12/13/2018 5:36 PM
    element text should be    id=HW${homeworkName}_percentage    100%
    element text should be    id=HW${homeworkName}_fileExtension    txt
    element text should be    id=HW${homeworkName}_homeworkDescription    Description is changed!!!
    element text should be    id=HW${homeworkName}_dueDateExtension    No
    [Teardown]    Run Keywords    click element    id=delete_${homeworkName}
    ...    AND    close browser

編輯作業但欄位為空(CMS-TC05)
    [Setup]    老師新增作業並關閉
    teacherLogin
    Click Element    id=Software Engineering
    click element    id=edit_${homeworkName}
    clear element text    name=homeworkName
    clear element text    name=dueDate
    clear element text    name=percentage
    clear element text    name=fileExtension
    clear element text    name=homeworkDescription
    click button    id=submitInEditHW
    ${testHomeworkName}=    Execute JavaScript    return window.document.getElementById("InputhomeworkName").getAttribute("oninvalid").split("'")[1]
    should be equal    ${testHomeworkName}    This field is required.
    input text    name=homeworkName    ${homeworkName}
    ${testDueDate}=    Execute JavaScript    return window.document.getElementById("InputDueDate").getAttribute("oninvalid").split("'")[1]
    should be equal    ${testDueDate}    This date format is wrong.
    [Teardown]    Run Keywords    go back
    ...    AND    click element    id=delete_${homeworkName}
    ...    AND    close browser

成功刪除作業(CMS-TC06)
    [Setup]    老師新增作業並關閉
    teacherLogin
    Click Element    id=Software Engineering
    click element    id=delete_${homeworkName}
    element should not be visible    id=${homeworkName}
    element should not be visible    id=HW${homeworkName}_dueDate
    element should not be visible    id=HW${homeworkName}_percentage
    element should not be visible    id=HW${homeworkName}_fileExtension
    element should not be visible    id=HW${homeworkName}_homeworkDescription
    element should not be visible    id=HW${homeworkName}_dueDateExtension
    [Teardown]    close browser

人工批改作業(CMS-TC07)
    [Setup]    老師新增作業並關閉
    teacherLogin
    Click Element    id=Software Engineering
    Click Element    id=${homeworkName}
    Element Should be Visible    id = 105598005
    Element Should be Visible    id = 105598004
    Element Should be Visible    id = 105598003
    Element Should be Visible    id = 105598002
    Click Element    id = toMark_105598002
    Input Text    id = grade    100
    Click Button    id = markHw_105598002
    ${grade}=    get text    id = grade_105598002
    Should be equal    ${grade}    100
    [Teardown]    run keywords    Close Browser    老師刪除作業並關閉

人工批改作業但數字不為0~100的正整數(CMS-TC08)
    [Setup]    老師新增作業並關閉
    teacherLogin
    Click Element    id=Software Engineering
    Click Element    id=${homeworkName}
    Element Should be Visible    id = 105598005
    Element Should be Visible    id = 105598004
    Element Should be Visible    id = 105598003
    Element Should be Visible    id = 105598002
    Click Element    id = toMark_105598002
    Input Text    id = grade    -50
    Click Button    id = markHw_105598002
    ${grade}=    Execute JavaScript    return window.document.getElementById("grade").getAttribute("oninvalid").split("'")[1]
    should be equal    ${grade}    Grade format is wrong.
    [Teardown]    run keywords    Close Browser    老師刪除作業並關閉

學生下載作業(CMS-TC09)
    [Setup]    run keywords    老師新增作業並關閉    學生準備作業並上傳
    studentLogin
    Click Element    id=enterSoftware Engineering
    Click Element    id=uploadhomework_${homeworkName}
    Click Element    id = download_105598002
    File Should Exist    ${fileDownloadPath}/105598002_${homeworkName}.txt
    [Teardown]    run keywords    Close Browser    刪除上傳的作業    刪除下載的作業    老師刪除作業並關閉

老師/TA下載作業(CMS-TC10)
    [Setup]    run keywords    老師新增作業並關閉    學生準備作業並上傳
    teacherLogin
    Click Element    id=Software Engineering
    Click Element    id=${homeworkName}
    Element Should be Visible    id = 105598005
    Element Should be Visible    id = 105598004
    Element Should be Visible    id = 105598003
    Element Should be Visible    id = 105598002
    Click Element    id = toMark_105598002
    Click Element    id = download_105598002
    File Should Exist    ${fileDownloadPath}/105598002_${homeworkName}.txt
    [Teardown]    run keywords    Close Browser    刪除上傳的作業    刪除下載的作業    老師刪除作業並關閉

學生下載未曾上傳的作業(CMS-TC11)
    [Setup]    老師新增作業並關閉
    studentLogin
    Click Element    id = enterSoftware Engineering
    Click Element    id = uploadhomework_${homeworkName}
    Click Element    id = download_105598002
    ${alert} =    get text    id = danger-alert
    Should be equal    ${alert}    x\nYou did not upload file.
    [Teardown]    run keywords    Close Browser    老師刪除作業並關閉

老師/TA下載學生未曾上傳作業(CMS-TC12)
    [Setup]    老師新增作業並關閉
    teacherLogin
    Click Element    id=Software Engineering
    Click Element    id=${homeworkName}
    Element Should be Visible    id = 105598005
    Element Should be Visible    id = 105598004
    Element Should be Visible    id = 105598003
    Element Should be Visible    id = 105598002
    Click Element    id = toMark_105598002
    Click Element    id = download_105598002
    ${alert} =    get text    id = danger-alert
    Should be equal    ${alert}    x\nDid not upload file.
    [Teardown]    run keywords    Close Browser    老師刪除作業並關閉

上傳作業(CMS-TC13)
    [Setup]    老師新增作業並關閉
    Create File    ${fileUploadPath}/105598002_${homeworkName}.txt    This is a file that robotframework create for test.
    studentLogin
    element text should be    class =jumbotron    105598002 Online Classroom
    Click Element    id=enterSoftware Engineering
    element text should be    class =jumbotron    105598002 Software Engineering Homework Area
    element should contain    id=homeworkState_${homeworkName}    Not Upload
    ${uploadtime}    get text    id=submitTime_${homeworkName}
    Should be equal    ${uploadtime}    ${EMPTY}
    Click Element    id=uploadhomework_${homeworkName}
    element text should be    class =jumbotron    105598002 Software Engineering\n ${homeworkName} Upload Homework Area
    Choose file    id=uploadFile    ${fileUploadPath}/105598002_${homeworkName}.txt
    Click Element    id=oktoUpload
    element text should be    class =jumbotron    105598002 Software Engineering Homework Area
    element text should be    id=homeworkState_${homeworkName}    Upload
    Should Not Be Empty    id=submitTime_${homeworkName}
    [Teardown]    run keywords    Close browser    老師刪除作業並關閉    刪除上傳的作業

課程底下沒有作業(CMS-TC14)
    [Setup]
    studentLogin
    element text should be    class =jumbotron    105598002 Online Classroom
    Click Element    id=enterSoftware Engineering
    element text should be    class =jumbotron    105598002 Software Engineering Homework Area
    Element Should Not Be Visible    id = ${homeworkName}
    [Teardown]    Close browser

上傳檔案為空(CMS-TC15)
    [Setup]    老師新增作業並關閉
    Create File    ${fileUploadPath}/105598002_${homeworkName}.txt
    studentLogin
    element text should be    class =jumbotron    105598002 Online Classroom
    Click Element    id=enterSoftware Engineering
    element text should be    class =jumbotron    105598002 Software Engineering Homework Area
    element should contain    id=homeworkState_${homeworkName}    Not Upload
    ${uploadtime}    get text    id=submitTime_${homeworkName}
    Should be equal    ${uploadtime}    ${EMPTY}
    Click Element    id=uploadhomework_${homeworkName}
    element text should be    class =jumbotron    105598002 Software Engineering\n ${homeworkName} Upload Homework Area
    Click Element    id=oktoUpload
    ${loadFile} =    Execute JavaScript    return window.document.getElementById("upfile").getAttribute('oninvalid').includes("Please choose file.");
    Should be true    ${loadFile}
    [Teardown]    run keywords    Close browser
    ...    AND    Remove File    ${fileUploadPath}/105598002_${homeworkName}.txt
    ...    AND    老師刪除作業並關閉

重複上傳作業(CMS-TC17)
    [Setup]    老師新增作業並關閉
    Create File    ${fileUploadPath}/105598002_${homeworkName}.txt    This is a file that robotframework create for test.
    studentLogin
    element text should be    class =jumbotron    105598002 Online Classroom
    Click Element    id=enterSoftware Engineering
    element text should be    class =jumbotron    105598002 Software Engineering Homework Area
    element should contain    id=homeworkState_${homeworkName}    Not Upload
    ${uploadtime}    get text    id=submitTime_${homeworkName}
    Should be equal    ${uploadtime}    ${EMPTY}
    Click Element    id=uploadhomework_${homeworkName}
    element text should be    class =jumbotron    105598002 Software Engineering\n ${homeworkName} Upload Homework Area
    Choose file    id=uploadFile    ${fileUploadPath}/105598002_${homeworkName}.txt
    Click Element    id=oktoUpload
    element text should be    class =jumbotron    105598002 Software Engineering Homework Area
    element text should be    id=homeworkState_${homeworkName}    Upload
    Should Not Be Empty    id=submitTime_${homeworkName}
    ${handintime_first}    get text    id=submitTime_${homeworkName}
    Click Element    id=uploadhomework_${homeworkName}
    element text should be    class =jumbotron    105598002 Software Engineering\n ${homeworkName} Upload Homework Area
    Choose file    id=uploadFile    ${fileUploadPath}/105598002_${homeworkName}.txt
    Click Element    id=oktoUpload
    element text should be    class =jumbotron    105598002 Software Engineering Homework Area
    element text should be    id=homeworkState_${homeworkName}    Upload
    ${handintime_second}    get text    id=submitTime_${homeworkName}
    should not be equal    ${handintime_first}    ${handintime_second}
    [Teardown]    run keywords    Close browser    老師刪除作業並關閉    刪除上傳的作業

學生不能補教逾期作業
    [Setup]    老師新增逾期作業
    studentLogin
    element text should be    class =jumbotron    105598002 Online Classroom
    Click Element    id=enterSoftware Engineering
    element text should be    class =jumbotron    105598002 Software Engineering Homework Area
    element should contain    id=homeworkState_${homeworkName}    Not Upload
    ${uploadtime}    get text    id=submitTime_${homeworkName}
    Should be equal    ${uploadtime}    ${EMPTY}
    Click Element    id=uploadhomework_${homeworkName}
    element text should be    class =jumbotron    105598002 Software Engineering\n ${homeworkName} Upload Homework Area
    ${alert}    get text    id = danger-alert
    Should be equal    ${alert}    x\nOverdue Submission.
    [Teardown]    run keywords    Close Browser    老師刪除作業並關閉

使用者登入成功(UAMS-TC01)
    [Setup]
    Open Browser    http://localhost:3000/    chrome
    maximize browser window
    click element    id = signin
    Element Should Be Visible    id = Login
    input text    name = studentID    105598001
    input password    name = password    1209
    click button    id = Login
    element Should Be Visible    id = jumbotron
    [Teardown]    close browser

使用者登入失敗(UAMS-TC02)
    [Setup]
    Open Browser    http://localhost:3000/    chrome
    maximize browser window
    set selenium speed    0.5s
    click element    id = signin
    Element Should Be Visible    id = Login
    input text    name = studentID    105598001
    input password    name = password    127
    click button    id = Login
    Wait Until Element Is Visible    id = danger-alert    3s
    Element Text Should Be    id = danger-alert    x\ninvalid account
    [Teardown]    close browser

老師/TA只能使用自身權限所及的功能(UAMS-TC03)
    [Setup]
    Open Browser    http://localhost:3000/    chrome
    maximize browser window
    click element    id = signin
    Element Should Be Visible    id = Login
    input text    name = studentID    105598001
    input password    name = password    1209
    click button    id = Login
    Wait Until Element Is Visible    id = jumbotron    3s
    Element Text Should Be    id = jumbotron    Course
    element Should Be Visible    id \ = \ course
    element Should Be Visible    id = gradesReport
    [Teardown]    close browser

學生只能使用自身權限所及的功能(UAMS-TC04)
    [Setup]
    Open Browser    http://localhost:3000/    chrome
    maximize browser window
    click element    id = signin
    wait until element is visible    id = Login    3s
    input text    name = studentID    105598002
    input password    name = password    1209
    click button    id = Login
    Wait Until Element Is Visible    class = jumbotron    3s
    Element Text Should Be    class = jumbotron    105598002 Online Classroom
    element Should Be Visible    id = onlineClassroom
    [Teardown]    close browser

使用者登出成功(UAMS-TC05)
    [Setup]
    Open Browser    http://localhost:3000/    chrome
    maximize browser window
    click element    id = signin
    Element Should Be Visible    id = Login
    input text    name = studentID    105598001
    input password    name = password    1209
    click button    id = Login
    Wait Until Element Is Visible    id = \ logout    2s
    Element Text Should Be    id = \ logout    Logout
    click element    id = logout
    Element Should Be Visible    id = Login
    [Teardown]    close browser

老師/TA的產生作業成績報表功能(RGS-TC01)
    [Setup]    老師新增作業並關閉
    teacherLogin
    click element    id = gradesReport
    click element    id= ${homeworkName}
    ${selectedHomeworkName}=    Get Text    id= ${homeworkName}
    click element    id = SubmitBtn
    Element Should Be Visible    class = t1
    Element Should Be Visible    id = piechart
    ${reportHomeworkName}=    Get Text    id=${homeworkName} report
    Should Contain    ${reportHomeworkName}    ${selectedHomeworkName}
    [Teardown]    Run Keywords    close browser    老師刪除作業並關閉

老師/TA的產生作業成績報表功能時未選擇作業(RGS-TC02)
    [Setup]    老師新增作業並關閉
    teacherLogin
    click element    id = gradesReport
    click element    id = SubmitBtn
    Wait Until Element Is Visible    id = danger-alert    3s
    Element Text Should Be    id = danger-alert    x\nPlease choose homework.
    [Teardown]    Run Keywords    close browser    老師刪除作業並關閉

*** Keywords ***
teacherLogin
    Open Browser    http://localhost:3000/    chrome
    maximize browser window
    set selenium speed    0.5s
    click element    id=signin
    wait until element is visible    id=Login    3s
    input text    name=studentID    105598001
    input password    name=password    1209
    click button    id=Login

studentLogin
    Open Browser    http://localhost:3000/    chrome
    maximize browser window
    set selenium speed    0.5s
    click element    id=signin
    wait until element is visible    id=Login    3s
    input text    name=studentID    105598002
    input password    name=password    1209
    click button    id=Login

go to login page
    Open Browser    http://localhost:3000/    chrome
    maximize browser window
    set selenium speed    0.5s
    click element    id=signin
    wait until element is visible    id=Login    3s

老師新增作業並關閉
    teacherLogin
    click element    id=Software Engineering
    click element    id=createHW
    Wait Until Element Is Visible    id = lineModalLabel
    input text    id=InputhomeworkName    ${homeworkName}
    input text    id=InputDueDateInAddHW    01/20/2018 0:00 AM
    input text    id=InputhwPercentage    100%
    input text    id=InputhwFileExtension    txt
    input text    name=homeworkDescription    Create Homework.
    click element    id = dueDateExtension
    click button    id=addHw
    close browser

老師刪除作業並關閉
    teacherLogin
    Click Element    id=Software Engineering
    Click element    id = delete_${homeworkName}
    close browser

學生準備作業並上傳
    Create File    ${fileUploadPath}/105598002_${homeworkName}.txt    This is a file that robotframework create for test.
    studentLogin
    Click Element    id=enterSoftware Engineering
    Click Element    id=uploadhomework_${homeworkName}
    Choose file    id=uploadFile    ${fileUploadPath}/105598002_${homeworkName}.txt
    Click Element    id=oktoUpload
    close browser

刪除上傳的作業
    Remove File    ${fileUploadPath}/../homeworkCollection/105598002_${homeworkName}.txt
    Remove File    ${fileUploadPath}/105598002_${homeworkName}.txt

刪除下載的作業
    Remove File    ${fileDownloadPath}/105598002_${homeworkName}.txt

老師新增逾期作業
    teacherLogin
    Click Element    id=Software Engineering
    Click Button    id=createHW
    Input Text    id= InputhomeworkName    ${homeworkName}
    Input Text    id=InputDueDateInAddHW    12/01/2017 0:00 AM
    Input Text    id= InputhwPercentage    100%
    Input Text    id= InputhwFileExtension    txt
    Input Text    id = InputhwHomeworkDescription    過期作業
    Click Button    id = addHw
    close browser
