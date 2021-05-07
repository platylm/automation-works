*** Keywords ***
เปิดเว็บบราวเซอร์ chrome ไปที่ google
    Open Browser    ${URL}   chrome
    
ค้นหาคำว่า
    [Arguments]    ${keyword}
    Input Text    name=q    ${keyword}
    Set Selenium Speed    1s
    Press Keys    name=btnK    RETURN