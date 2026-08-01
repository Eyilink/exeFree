curl -fsSL https://opencode.ai/install | bash

source ~/.zshrc

mkdir -p ~/.config/opencode

echo '// opencode.jsonc
{
  "$schema": "https://opencode.ai/config.json",
  "model": "google/gemini-3.6-flash",
  "autoupdate": true,
  "server": {
    "port": 4096
  }
}' > ~/.config/opencode/opencode.jsonc