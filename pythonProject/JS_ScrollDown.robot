*** Settings ***
Library       SeleniumLibrary
Library       String

*** Variables ***
${URL}            https://juice-shop.herokuapp.com/#/
${BROWSER}        chrome
${ITEMS_PER_PAGE_SELECTOR}    css=div.mat-paginator-page-size-label
${MAX_ITEMS_OPTION}           xpath=//span[@class='mat-option-text' and normalize-space(text())='48']
${ITEMS_CONTAINER}            xpath=//mat-card
${DISMISS_BUTTON}    xpath=//span[contains(text(), 'Dismiss')]
${COOKIE_DISMISS}   xpath=//a[@aria-label='dismiss cookie message' and contains(@class, 'cc-dismiss')]
${SELECT_ARROW_WRAPPER}    xpath=//div[contains(@class, 'mat-select-arrow-wrapper')]//div[contains(@class, 'mat-select-arrow')]
${PAGINATOR_LABEL}    xpath=//div[@class='mat-paginator-range-label']

*** Test Cases ***
Verify All Items Are Displayed On Homepage
    [Documentation]    This test case verifies that all items are displayed on the homepage.

    Open Browser To Juice Shop
    Scroll Down To Load All Content
    Set Items Per Page To Maximum
    Verify Item Count On Homepage

    Close Browser

*** Keywords ***
Open Browser To Juice Shop
    Open Browser    ${URL}    ${BROWSER}
    Maximize Browser Window
    Wait Until Element Is Visible    ${DISMISS_BUTTON}    timeout=2s
    Click Element    ${DISMISS_BUTTON}

Scroll Down To Load All Content
    Execute JavaScript    window.scrollBy(document.body.scrollHeight, document.body.scrollHeight);
    Sleep    2s

Set Items Per Page To Maximum
    Click Element    ${SELECT_ARROW_WRAPPER}
    Wait Until Element Is Visible    ${MAX_ITEMS_OPTION}
    Click Element    ${MAX_ITEMS_OPTION}
    Wait Until Element Is Visible    ${ITEMS_CONTAINER}

Verify Item Count On Homepage
    ${displayed_items} =    Get Element Count    ${ITEMS_CONTAINER}
    # Get the text of the paginator label element
    ${text}=    Get Text    ${PAGINATOR_LABEL}
    # Split the text by spaces and get the last value
    ${total_items}=    Get Substring    ${text}    -2
    # Log the extracted value
    Log    Total items: ${total_items}
    # Optional: Assert the total number of items
    Should Be Equal As Numbers    ${total_items}    ${displayed_items}