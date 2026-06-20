#!/usr/bin/env bash
set -euo pipefail

install_root="${CODEX_PROFILE_INSTALL_ROOT:-$HOME/.local/share/codex-profile}"
bin_dir="${CODEX_PROFILE_BIN_DIR:-$HOME/.local/bin}"
source_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

mkdir -p "$install_root" "$bin_dir"

copy_item() {
  local src="$1"
  local dst="$2"

  if [[ -d "$src" ]]; then
    mkdir -p "$dst"
    tar -C "$src" -cf - . | tar -C "$dst" -xf -
  elif [[ -f "$src" ]]; then
    cp "$src" "$dst"
  fi
}

copy_item "$source_dir/bin" "$install_root/bin"
copy_item "$source_dir/README.md" "$install_root/README.md"
copy_item "$source_dir/LICENSE" "$install_root/LICENSE"
copy_item "$source_dir/package.json" "$install_root/package.json"

chmod 755 "$install_root/bin/codex-profile" "$install_root/bin/codex-profile-usage"
ln -sfn "$install_root/bin/codex-profile" "$bin_dir/codex-profile"
ln -sfn "$install_root/bin/codex-profile-usage" "$bin_dir/codex-profile-usage"
ln -sfn "$install_root/bin/codex-profile-usage" "$bin_dir/codex-usage"

printf 'Installed codex-profile to %s\n' "$install_root"
printf 'Installed commands in %s\n' "$bin_dir"
