# PSOpenAI PowerShell Module

PSOpenAI is a PowerShell module that provides a simple interface for interacting with the OpenAI API. It allows you to quickly and easily send requests to the OpenAI chat and completion endpoints, with support for custom models, messages, prompts, temperature, and max tokens.

## Installation

To use the PSOpenAI module, you can clone the latest version from the GitHub repository using the git command. Open a PowerShell console and run the following command:

```powershell
git clone https://github.com/rsgibb/PSOpenAI.git
```

After cloning the repository, you can import the PSOpenAI module using the Import-Module cmdlet:

```powershell
Import-Module "C:\path\to\PSOpenAI"
```

**Note**: This project is very early in development, and things are likely to change, especially regarding the handling of the API key.

## Usage

To use the PSOpenAI module, you must first set your OpenAI API key as an environment variable named OPENAI_API_KEY. You can obtain an API key from the OpenAI website.

```powershell
$env:OPENAI_API_KEY = "YOUR_API_KEY_HERE"
```

Once you have set your API key, you can use the Invoke-OpenAI function to send requests to the OpenAI API. The function has two parameter sets:

* `Chat`: Sends a message to the OpenAI chat endpoint and returns a response with a completion to your message.
* `Completion`: Sends a prompt to the OpenAI completion endpoint and returns a response with a completion to your prompt.

Here is an example of how to use the Invoke-OpenAI function:

```powershell
$messages = @{'role'='user'; 'content'='Hello, how are you doing today?'}
$response = Invoke-OpenAI -Messages $messages -Temperature 0.7 -MaxTokens 100
$response.choices[0].message.content
```
This will send a message to the OpenAI chat endpoint using the default chat model gpt-3.5-turbo, with a temperature of 0.7 and a maximum of 100 tokens, and return a response containing the completion to your message.

For more information on the OpenAI API and its parameters, please refer to the [OpenAI API reference](https://platform.openai.com/docs/api-reference).
