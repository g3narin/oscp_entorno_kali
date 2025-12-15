#!/bin/bash
set -e

# =============================================
#   ZSH + OH-MY-ZSH + PLUGINS + KITTY (KALI)
#   Author: g3narin
# =============================================

# --------- NO ROOT ---------
if [[ $EUID -eq 0 ]]; then
  echo "[!] No ejecutes este script como root"
  exit 1
fi

echo "[+] Actualizando sistema..."
sudo apt update -y

echo "[+] Instalando dependencias base..."
sudo apt install -y \
  zsh \
  git \
  curl \
  wget \
  neovim \
  kitty \
  coreutils \
  bat \
  eza

# --------- ZSH DEFAULT ---------
if [[ "$SHELL" != *zsh ]]; then
  echo "[+] Cambiando shell por defecto a zsh..."
  chsh -s "$(which zsh)"
fi

# --------- OH MY ZSH ---------
if [[ ! -d "$HOME/.oh-my-zsh" ]]; then
  echo "[+] Instalando Oh My Zsh..."
  RUNZSH=no CHSH=no sh -c \
    "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
else
  echo "[✓] Oh My Zsh ya instalado"
fi

ZSH_CUSTOM="${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}"

# --------- PLUGINS ---------
echo "[+] Instalando plugins de ZSH..."

git clone https://github.com/zsh-users/zsh-autosuggestions \
  "$ZSH_CUSTOM/plugins/zsh-autosuggestions" 2>/dev/null || true

git clone https://github.com/zsh-users/zsh-syntax-highlighting \
  "$ZSH_CUSTOM/plugins/zsh-syntax-highlighting" 2>/dev/null || true

# --------- ZSHRC ---------
echo "[+] Configurando .zshrc..."

if ! grep -q "zsh-autosuggestions" ~/.zshrc; then
  sed -i 's/^plugins=(/plugins=(zsh-autosuggestions zsh-syntax-highlighting /' ~/.zshrc
fi

# --------- KITTY ---------
echo "[+] Configurando Kitty..."
mkdir -p ~/.config/kitty

cat <<EOF > ~/.config/kitty/kitty.conf
font_family      JetBrains Mono
font_size        11.5
enable_audio_bell no
confirm_os_window_close 0
background_opacity 0.95
EOF

# --------- DONE ---------
echo
echo "================================="
echo " ✅ Instalación completada"
echo " 👉 Cierra sesión o ejecuta: zsh"
echo "================================="

