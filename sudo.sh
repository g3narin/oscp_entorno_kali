#!/bin/bash
set -e

# =====================================
#  SUDO NOPASSWD - KALI LINUX
# =====================================

# -------- CONFIG --------
USER_NAME="${SUDO_USER:-$(logname)}"
SUDO_FILE="/etc/sudoers.d/99_${USER_NAME}"

# -------- ROOT CHECK --------
if [[ "$EUID" -ne 0 ]]; then
  echo "[!] Ejecuta con: sudo $0"
  exit 1
fi

# -------- USER CHECK --------
if ! id "$USER_NAME" &>/dev/null; then
  echo "[!] El usuario '$USER_NAME' no existe"
  exit 1
fi

echo "[+] Usuario objetivo: $USER_NAME"
echo "[+] Archivo sudoers: $SUDO_FILE"

# -------- CREATE FILE --------
echo "[+] Creando archivo sudoers..."
touch "$SUDO_FILE"
chown root:root "$SUDO_FILE"
chmod 440 "$SUDO_FILE"

# -------- WRITE CONFIG --------
echo "[+] Escribiendo configuración NOPASSWD..."
cat > "$SUDO_FILE" <<EOF
$USER_NAME ALL=(ALL) NOPASSWD: ALL
EOF

# -------- VALIDATE --------
echo "[+] Verificando sintaxis con visudo..."
if ! visudo -cf "$SUDO_FILE"; then
  echo "[!] ERROR: Sintaxis inválida, eliminando archivo"
  rm -f "$SUDO_FILE"
  exit 1
fi

# -------- DONE --------
echo "[✓] Configuración aplicada correctamente"
echo "[✓] Prueba con: sudo -l"
#!/bin/bash
set -e

# =====================================
#  SUDO NOPASSWD - KALI LINUX
# =====================================

# -------- CONFIG --------
USER_NAME="${SUDO_USER:-$(logname)}"
SUDO_FILE="/etc/sudoers.d/99_${USER_NAME}"

# -------- ROOT CHECK --------
if [[ "$EUID" -ne 0 ]]; then
  echo "[!] Ejecuta con: sudo $0"
  exit 1
fi

# -------- USER CHECK --------
if ! id "$USER_NAME" &>/dev/null; then
  echo "[!] El usuario '$USER_NAME' no existe"
  exit 1
fi

echo "[+] Usuario objetivo: $USER_NAME"
echo "[+] Archivo sudoers: $SUDO_FILE"

# -------- CREATE FILE --------
echo "[+] Creando archivo sudoers..."
touch "$SUDO_FILE"
chown root:root "$SUDO_FILE"
chmod 440 "$SUDO_FILE"

# -------- WRITE CONFIG --------
echo "[+] Escribiendo configuración NOPASSWD..."
cat > "$SUDO_FILE" <<EOF
$USER_NAME ALL=(ALL) NOPASSWD: ALL
EOF

# -------- VALIDATE --------
echo "[+] Verificando sintaxis con visudo..."
if ! visudo -cf "$SUDO_FILE"; then
  echo "[!] ERROR: Sintaxis inválida, eliminando archivo"
  rm -f "$SUDO_FILE"
  exit 1
fi

# -------- DONE --------
echo "[✓] Configuración aplicada correctamente"
echo "[✓] Prueba con: sudo -l"

