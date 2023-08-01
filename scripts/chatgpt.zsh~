# chatgpt.zsh

# Check if jq is installed
if ! command -v jq &> /dev/null
then
    echo "jq could not be found. Please install jq first."
    return
fi

# Check if curl is installed
if ! command -v curl &> /dev/null
then
    echo "curl could not be found. Please install curl first."
    return
fi

# Function to setup ChatGPT
function chatgpt-setup() {
    echo "Setting up ChatGPT..."
    read -p "Enter your OpenAI API key: " key
    export OPENAI_API_KEY="$key"
    echo "ChatGPT is ready to use. Start a new conversation with 'chatgpt-start', continue the conversation with 'chatgpt-continue <message>', and end the conversation with 'chatgpt-end'."
}

# Function to start a new conversation
function chatgpt-start() {
    echo "Starting a new conversation..."
    local response=$(curl -s -H "Authorization: Bearer $OPENAI_API_KEY" \
        -H "Content-Type: application/json" \
        -d '{"model": "text-davinci-002", "messages": [{"role": "system", "content": "You are a helpful assistant."}]}' \
        "https://api.openai.com/v1/engines/davinci-codex/completions")
    local conversation_id=$(echo $response | jq -r '.id')
    echo "New conversation started. Conversation ID: $conversation_id"
    echo $conversation_id > ~/.chatgpt
}

# Function to continue a conversation
function chatgpt-continue() {
    if [ ! -f ~/.chatgpt ]; then
        echo "No active conversation. Start a new conversation first."
        return
    fi
    local conversation_id=$(cat ~/.chatgpt)
    local message=$1
    echo "Continuing conversation $conversation_id..."
    local response=$(curl -s -H "Authorization: Bearer $OPENAI_API_KEY" \
        -H "Content-Type: application/json" \
        -d "{\"model\": \"text-davinci-002\", \"messages\": [{\"role\": \"system\", \"content\": \"You are a helpful assistant.\"}, {\"role\": \"user\", \"content\": \"$message\"}]}" \
        "https://api.openai.com/v1/engines/davinci-codex/completions")
    local message=$(echo $response | jq -r '.choices[0].message.content')
    echo "Assistant: $message"
}

# Function to end a conversation
function chatgpt-end() {
    if [ ! -f ~/.chatgpt ]; then
        echo "No active conversation."
        return
    fi
    rm ~/.chatgpt
    echo "Conversation ended."
}

# Aliases for convenience
alias chatgpt-s="chatgpt-start"
alias chatgpt-c="chatgpt-continue"
alias chatgpt-e="chatgpt-end"

