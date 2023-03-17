
function Invoke-OpenAI {
    <#
    .SYNOPSIS
    Sends requests to the OpenAI chat and completion endpoints.

    .DESCRIPTION
    Sends a message to the OpenAI chat endpoint or a prompt to the OpenAI completion endpoint, and returns a response with a completion to the message or prompt.

    .PARAMETER Model
    The OpenAI model to use for the request. Defaults to 'davinci' for the completion endpoint, and 'gpt-3.5-turbo' for the chat endpoint.

    .PARAMETER Messages
    The message to send to the OpenAI chat endpoint. This is an array of messages in the format:
    @{
        'role' = 'user'
        'content' = 'hello'
    }

    .PARAMETER Prompt
    The prompt to send to the OpenAI completion endpoint.

    .PARAMETER Temperature
    The temperature to use for the request. Higher temperatures result in more random completions. Defaults to 0.5.

    .PARAMETER MaxTokens
    The maximum number of tokens to generate in the completion. Defaults to 50.

    .EXAMPLE
    $messages = @{'role'='user'; content='Hello, how are you doing today?'}
    $response = Invoke-OpenAI -Messages $messages -Temperature 0.7 -MaxTokens 100
    $response.choices[0].message.content
    Sends a message to the OpenAI chat endpoint using the 'gpt-3.5-turbo' model, with a temperature of 0.7 and a maximum of 100 tokens, and returns a response containing the completion to the message.

    .EXAMPLE
    $response = Invoke-OpenAI -Model 'text-davinci-003' -Prompt 'Once upon a time'
    Sends a prompt to the OpenAI completion endpoint using the 'text-davinci-003' model, and returns a response containing the completion to the prompt.
    
    #>
    [Cmdletbinding()]
    param(
        [Parameter(ParameterSetName = "Chat")]
        [Parameter(ParameterSetName = "Completion")]
        [string]$Model,
        [Parameter(ParameterSetName = "Chat")]
        [hashtable[]]$Messages,
        [Parameter(ParameterSetName = "Completion")]
        [string]$Prompt,
        [Parameter(ParameterSetName = "Chat")]
        [Parameter(ParameterSetName = "Completion")]
        [float]$Temperature,
        [Parameter(ParameterSetName = "Chat")]
        [Parameter(ParameterSetName = "Completion")]
        [int]$MaxTokens
    )

    if (-not $env:OPEN_API_KEY) {
        throw 'OPEN_API_KEY environment variable not set!'
    }

    $baseUrl = "https://api.openai.com/v1"

    $paramMap = @{
        Model = 'model'
        Temperature = 'temperature'
        MaxTokens = 'max_tokens'
    }

    $restParams = @{
        Headers = @{
            "Authorization" = "Bearer $($env:OPEN_API_KEY)"
            "Content-Type" = "application/json"
        }
        Method = "POST"
    }

    $body = @{
        model = $Model
    }

    switch ($PsCmdlet.ParameterSetName) {
        "Chat" {
            $restParams['Uri'] = "${baseUrl}/chat/completions"
            $body['messages'] = $messages
            if (-not $Model) {
                $body['model'] = "gpt-3.5-turbo"
            } else {
                $body['model'] = $Model
            }
        }

        "Completion" {
            $restParams['Uri'] = "${baseUrl}/completions"
            $body['prompt'] = $Prompt
            if (-not $Model) {
                $body['model'] = "text-davinci-003"
            } else {
                $body['model'] = $Model
            }   
        }
    }

    foreach ($param in $paramMap.Keys) {
        if ($PSBoundParameters[$param]) {
            $body[$paramMap[$param]] = $PSBoundParameters[$param] 
        }
    }

    $restParams['Body'] = $body | ConvertTo-Json

    try {
        Invoke-RestMethod @restParams
    } catch [System.Net.Http.HttpRequestException] {
        $_.ErrorDetails.Message | ConvertFrom-Json
    } 

}

