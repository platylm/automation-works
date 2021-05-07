*** Settings ***
Library    RequestsLibrary
Suite Setup    Create Session    ${SESSION_NAME}    http://localhost:8000
Suite Teardown    Delete All Sessions

*** Variables ***
${SESSION_NAME}    toy-store
&{ACCEPT}     Accept=application/json
&{CONTENTTYPE}    Content-Type=application/json
&{HEADER}    &{ACCEPT}    &{CONTENTTYPE} 

*** Test Cases ***
ซื้อสินค้า 43 Piece Dinner Set    
    ค้นหาสินค้า     43 Piece dinner Set
    ดูรายละเอียดสินค้า    ${2}    43 Piece dinner Set
    เพิ่มสินค้าลงในตะกร้า
    ยืนยันการชำระเงิน

ซื้อสินค้า Balance Training Bicycle    
    ค้นหาสินค้า     Balance Training Bicycle
    ดูรายละเอียดสินค้า    ${1}    Balance Training Bicycle
    เพิ่มสินค้าลงในตะกร้า
    ยืนยันการชำระเงิน

*** Keywords *** 
ค้นหาสินค้า
    [Arguments]    ${product_name}
    ${product_list}=    GET On Session    ${SESSION_NAME}    /api/v1/product    headers=${HEADER}    expected_status=200

    ${total_product_list}=    Get Length    ${product_list.json()["products"]} 
    Should Be Equal As Integers    ${total_product_list}    2

    Set Test Variable    ${products}    ${productList.json()["products"]}
    FOR    ${index_product}     IN RANGE    ${total_product_list}
        Run Keyword If    '${products[${index_product}]["product_name"]}'=='${product_name}'    Exit For Loop
    END
    Should Be Equal    ${products[${index_product}]["product_name"]}    ${product_name}

ดูรายละเอียดสินค้า
    [Arguments]    ${product_id}    ${product_name}
    ${product_detail}=    GET On Session    ${SESSION_NAME}    /api/v1/product/${product_id}    headers=${HEADER}    expected_status=200

    Should Be Equal    ${product_detail.json()["product_name"]}    ${product_name}

เพิ่มสินค้าลงในตะกร้า
    &{product}=    Create Dictionary    product_id=${2}    quantity=${1}
    @{cart}=    Create List    ${product}
    &{body}=    Create Dictionary
    ...     cart=@{cart}
    ...    	shipping_method=Kerry
	...     shipping_address=405/37 ถ.มหิดล
	...     shipping_sub_district=ท่าศาลา
	...     shipping_district=เมือง
	...     shipping_province=เชียงใหม่
	...     shipping_zip_code=50000
	...     recipient_name=ณัฐญา ชุติบุตร
	...     recipient_phone_number=0970809292

    ${order}=    POST On Session    ${SESSION_NAME}    /api/v1/order    headers=${HEADER}    json=${body}

    Should Be Equal As Integers    ${order.json()["order_id"]}    8004359104
    Should Be Equal As Numbers    ${order.json()["total_price"]}    14.95

ยืนยันการชำระเงิน
    &{body}=    Create Dictionary
    ...    order_id=${8004359104}
    ...    payment_type=credit
    ...    type=visa
    ...    card_number=4719700591590995
    ...    cvv=752
    ...    expired_month=${7}
    ...    expired_year=${20}
    ...    card_name=Karnwat Wongudom
    ...    total_price=${14.95}

    ${confirm}=    POST On Session    ${SESSION_NAME}    /api/v1/confirmPayment    headers=${HEADER}    json=${body}

    Should Be Equal    ${confirm.json()["notify_message"]}    วันเวลาที่ชำระเงิน 1/3/2020 13:30:00 หมายเลขคำสั่งซื้อ 8004359104 คุณสามารถติดตามสินค้าผ่านช่องทาง Kerry หมายเลข 1785261900