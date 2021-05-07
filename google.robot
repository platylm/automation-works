*** Settings ***
Library    SeleniumLibrary
Test Setup    เปิดเว็บบราวเซอร์ chrome ไปที่ google
Test Teardown    Close Browser

Resource    resource.robot

*** Variables ***
${URL}    https://www.google.com/

*** Test Cases ***
เข้า google และค้นหาคำว่า Dogecoin 
    ค้นหาคำว่า     Dogecoin

เข้า google และค้นหาคำว่า BNB 
    ค้นหาคำว่า     BNB