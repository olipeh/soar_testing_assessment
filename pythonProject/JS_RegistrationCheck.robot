*** Settings ***
Library    SeleniumLibrary
Library    FakerLibrary
Library    String

*** Variables ***
${URL}                       https://juice-shop.herokuapp.com/#/
${REGISTER_BUTTON}           css=#navbarAccount
${LOGIN_NAV_BUTTON}          css=#navbarLoginButton
${NEW_CUSTOMER_BUTTON}       css=a[routerlink="/register"]
${EMAIL_INPUT}               css=input#emailControl
${PASSWORD_INPUT}            css=input#passwordControl
${REPEAT_PASSWORD_INPUT}     css=input#repeatPasswordControl
${SHOW_ADVICE_BUTTON}        css=button#mat-slide-toggle-1
${SECURITY_QUESTION_DROPDOWN}    css=mat-select[name="securityQuestion"]
${SECURITY_QUESTION}         xpath=//mat-option//span[contains(text(), "Your eldest siblings middle name?")]
${SECURITY_ANSWER_INPUT}     css=input#securityAnswerControl
${REGISTER_SUBMIT_BUTTON}    css=button#registerButton
${LOGIN_EMAIL_INPUT}         css=input#email
${LOGIN_PASSWORD_INPUT}      css=input#password
${LOGIN_SUBMIT_BUTTON}       css=button#loginButton
${SUCCESS_MESSAGE}           xpath=//div[contains(text(), "Registration completed successfully.")]

*** Test Cases ***
User Registration and Login with Validation Checks
    [Setup]    Open Browser    ${URL}    chrome
    Maximize Browser Window

    Go to Registration Page and Check Validation
    Fill Registration Form with Self Generated Information
    Show Password Advice and Submit Form
    Assert Successful Registration and Login

    [Teardown]    Close Browser

*** Keywords ***
Go to Registration Page and Check Validation
    Click Element    ${REGISTER_BUTTON}
    Click Element    ${LOGIN_NAV_BUTTON}
    Click Element    ${NEW_CUSTOMER_BUTTON}

    # Click on all fields to trigger validation
    Click Element    ${EMAIL_INPUT}
    Click Element    ${PASSWORD_INPUT}
    Click Element    ${REPEAT_PASSWORD_INPUT}
    Click Element    ${SECURITY_ANSWER_INPUT}

    # Assert validation messages are displayed
    Page Should Contain Element    xpath=//mat-error[contains(text(), "Email is required")]
    Page Should Contain Element    xpath=//mat-error[contains(text(), "Password is required")]
    Page Should Contain Element    xpath=//mat-error[contains(text(), "Please repeat your password")]
    Page Should Contain Element    xpath=//mat-error[contains(text(), "Security answer is required")]

Fill Registration Form with Self Generated Information
    # Generate data for registration
    ${email}=    FakerLibrary.Generate Email
    ${password}=    FakerLibrary.Generate Password
    ${security_answer}=    FakerLibrary.Generate First Name

    # Store data for login use later
    Set Suite Variable    ${email}
    Set Suite Variable    ${password}

    Input Text    ${EMAIL_INPUT}    ${email}
    Input Text    ${PASSWORD_INPUT}    ${password}
    Input Text    ${REPEAT_PASSWORD_INPUT}    ${password}

    Click Element    ${SECURITY_QUESTION_DROPDOWN}
    Click Element    ${SECURITY_QUESTION}
    Input Text    ${SECURITY_ANSWER_INPUT}    ${security_answer}

Show Password Advice and Submit Form
    Click Element    ${SHOW_ADVICE_BUTTON}
    Click Element    ${REGISTER_SUBMIT_BUTTON}

Assert Successful Registration and Login
    # Assert success message appears
