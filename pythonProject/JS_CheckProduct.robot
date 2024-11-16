*** Settings ***
Library     SeleniumLibrary

*** Variables ***
${URL}               https://juice-shop.herokuapp.com/#/
${PRODUCT_NAME}      Apple Juice
${PRODUCT_NAME_XPATH}    xpath=//div[contains(@class, 'item-name')]
#make sure image are really stored in bucket assets
${PRODUCT_IMAGE_XPATH}    xpath=//img[contains(@src, 'assets/public/images/products/')]
${POPUP_XPATH}       xpath=//mat-dialog-container[contains(@class, 'cdk-dialog-container')]
${REVIEW_XPATH}      xpath=//mat-panel-title[contains(@class, 'mat-expansion-panel-header')]
${DISMISS_BUTTON}    xpath=//span[contains(text(), 'Dismiss')]
${SPAN_ELEMENT}    xpath=//mat-panel-title//span[contains(text(), '(')]


*** Test Cases ***
Open Juice Shop and View Apple Juice Product
    Open Browser    ${URL}    chrome
    Maximize Browser Window
    Wait Until Element Is Visible    ${DISMISS_BUTTON}    timeout=2s
    Click Element    ${DISMISS_BUTTON}

    # Click on the first product

    Click Element    ${PRODUCT_NAME_XPATH}

    # Assert that a popup has appeared
    Wait Until Element Is Visible    ${POPUP_XPATH}
    Log    Popup is visible.

    # Assert that the image of the product exists
    Wait Until Element Is Visible    ${PRODUCT_IMAGE_XPATH}
    Log    Product image is visible.

    # Fetch the text from the element
    ${span_text}=    Get Text    ${SPAN_ELEMENT}

    # Extract the number from the parentheses
     ${number}=    Evaluate    int(${span_text}[1:-1])

    # Log or use the extracted number
    Log    Extracted number: ${number}
    # If reviews are available, expand them
    Run Keyword If    ${number} > 0    Click Element    ${REVIEW_XPATH}
    # Wait for a couple of seconds
    Sleep    2

    # Close the product form (popup)
    Click Element    xpath=//button[contains(@aria-label, 'Close')]

    Close Browser
