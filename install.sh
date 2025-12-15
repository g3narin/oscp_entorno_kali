#!/bin/bash
set -e

# =============================================
#        DOTFILES INSTALLER (KALI / XFCE)
#        Author: g3narin
# =============================================

# ---------- NO ROOT ----------
if [[ $EUID -eq 0 ]]; then
  echo "[!] No ejecutes este script como root"
  exit 1
fi

BASE_DIR="$(cd "$(dirname "$0")" && pwd)"

echo "[+] Iniciando instalación desde: $BASE_DIR"

# =============================================
# 0. BACKUP ZSHRC (CRÍTICO)
# =============================================
if [[ -f "$HOME/.zshrc" ]]; then
  echo "[+] Respaldando .zshrc existente"
  cp "$HOME/.zshrc" "$HOME/.zshrc.pre-installer"
fi

# =============================================
# 1. LIMPIEZA DE HOME
# =============================================
echo "[+] Limpiando HOME (manteniendo carpetas clave)..."

KEEP_DIRS=("Desktop" "Downloads" "Pictures" "CTF" "OffSec")

for dir in "$HOME"/* "$HOME"/.*; do
  name="$(basename "$dir")"

  [[ "$name" == "." || "$name" == ".." ]] && continue
  [[ " ${KEEP_DIRS[*]} " =~ " $name " ]] && continue
  [[ "$name" == ".config" ]] && continue

  rm -rf "$dir"
done

for d in "${KEEP_DIRS[@]}"; do
  mkdir -p "$HOME/$d"
done

# =============================================
# 2. COPIAR HOME DOTFILES (EXCEPTO .zshrc)
# =============================================
echo "[+] Copiando contenido de home/ → \$HOME"

rsync -a --exclude=".zshrc" "$BASE_DIR/home/" "$HOME/"

# =============================================
# 3. COPIAR CONFIG
# =============================================
echo "[+] Copiando config/ → ~/.config"

mkdir -p "$HOME/.config"
cp -a "$BASE_DIR/config/." "$HOME/.config/"

# =============================================
# 4. LIGHTDM
# =============================================
if [[ -d "$BASE_DIR/lightdm" ]]; then
  echo "[+] Instalando configuración de LightDM..."
  sudo mkdir -p /etc/lightdm
  sudo cp -a "$BASE_DIR/lightdm/." /etc/lightdm/
fi

# =============================================
# 5. PAQUETES BASE
# =============================================
echo "[+] Actualizando sistema..."
sudo apt update -y

echo "[+] Instalando paquetes..."
sudo apt install -y \
  zsh \
  git \
  curl \
  wget \
  neovim \
  kitty \
  bat \
  eza \
  coreutils \
  rsync

# =============================================
# 6. ZSH + OH-MY-ZSH (SEGURO)
# =============================================
if [[ "$SHELL" != *zsh ]]; then
  echo "[+] Cambiando shell por defecto a zsh..."
  chsh -s "$(which zsh)"
fi

if [[ ! -d "$HOME/.oh-my-zsh" ]]; then
  echo "[+] Instalando Oh My Zsh..."
  RUNZSH=no CHSH=no sh -c \
    "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
fi

# =============================================
# 7. RESTAURAR TU .ZSHRC (CLAVE)
# =============================================
if [[ -f "$HOME/.zshrc.pre-installer" ]]; then
  echo "[+] Restaurando .zshrc personalizado"
  mv "$HOME/.zshrc.pre-installer" "$HOME/.zshrc"
fi

# =============================================
# 8. PLUGINS ZSH
# =============================================
ZSH_CUSTOM="$HOME/.oh-my-zsh/custom"

echo "[+] Instalando plugins ZSH..."

git clone https://github.com/zsh-users/zsh-autosuggestions \
  "$ZSH_CUSTOM/plugins/zsh-autosuggestions" 2>/dev/null || true

git clone https://github.com/zsh-users/zsh-syntax-highlighting \
  "$ZSH_CUSTOM/plugins/zsh-syntax-highlighting" 2>/dev/null || true

# =============================================
# 9. PERMISOS
# =============================================
chmod -R u+rwX "$HOME"

# =============================================
# DONE
# =============================================
echo
echo "=============================================="
echo " ✅ Instalación completada correctamente"
echo " 👉 Ejecuta: exec zsh (o cierra sesión)"
echo "=============================================="
