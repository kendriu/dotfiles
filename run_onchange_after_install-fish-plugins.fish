#!/usr/bin/env fish
# fish_plugins hash: {{ include "fish_plugins" | sha256sum }}

echo "fisher plugins list changed. Running update."

fisher update
