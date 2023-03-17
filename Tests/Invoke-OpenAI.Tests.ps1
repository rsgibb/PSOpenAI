Describe 'Invoke-OpenAI' {
    Context 'When OPEN_API_KEY environment variable is not set' {
        It 'Throws an exception' {
            $env:OPEN_API_KEY = $null
            { Invoke-OpenAI } | Should Throw 'OPEN_API_KEY environment variable not set!'
        }
    }

    Context 'When OPEN_API_KEY environment variable is set' {
        BeforeAll {
            $env:OPEN_API_KEY = '12345'
        }

        AfterAll {
            $env:OPEN_API_KEY = $null
        }

        Context 'When parameter set is "Chat"' {
            It 'Sends a request to the chat endpoint' {
                $response = Invoke-OpenAI -Messages @{'role'='user';'content'='Hello'} -Temperature 0.5 -MaxTokens 50 -Verbose
                $response | Should Not BeNullOrEmpty
                $response.id | Should Not BeNullOrEmpty
                $response.choices | Should Not BeNullOrEmpty
            }
        }

        Context 'When parameter set is "Completion"' {
            It 'Sends a request to the completion endpoint' {
                $response = Invoke-OpenAI -Prompt 'Hello' -Temperature 0.5 -MaxTokens 50 -Verbose
                $response | Should Not BeNullOrEmpty
                $response.choices | Should Not BeNullOrEmpty
            }
        }
    }
}
