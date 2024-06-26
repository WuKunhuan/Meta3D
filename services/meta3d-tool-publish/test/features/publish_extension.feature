Feature: Publish Extension
    As a Publish Extension
    I want to publish extension
    So that I can use it

    Background: prepare
        Given prepare sandbox

    Scenario: if publisher is not registered, throw error
        Given prepare funcs
        And make publisher not be registered
        When publish extension
        Then should error: "找不到publishser，请在平台上注册该用户"

    Scenario: define window for generateFunc
        Given prepare funcs
        And make generateFunc use window
        When publish extension
        Then should not error

    Scenario: upload file and add to collection
        Given prepare funcs
        When publish extension
        Then should upload generated file
        And should add to collection

    Scenario: handle nullable package json fields
        Given prepare funcs that package json not has displayName, repoLink, description
        When publish extension
        Then should use default value


    # Scenario: update fileID in collection if exist
    #     Given prepare funcs
    #     And publish extension
    #     When publish extension with same protocolName and version but different dist file
    #     Then should upload generated file
    #     And should update fileID in collection

    Scenario: if extension with the same publisher, name, version, protocol name exist, throw error
        Given prepare funcs
        And publish extension
        When publish extension with the same publisher, name, version, protocol name
        Then should error
        And not upload file
