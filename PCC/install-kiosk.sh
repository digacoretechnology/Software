#!/usr/bin/env bash
set -euo pipefail

KIOSK_USER="nurse"
KIOSK_PASS="nurse"
KIOSK_ENV="/etc/kiosk.env"
KIOSK_BIN="/usr/local/bin/kiosk-session.sh"
KIOSK_POLICY_DIR_SYS="/etc/chromium/policies/managed"
KIOSK_POLICY_DIR_SNAP="/var/snap/chromium/common/policies/managed"

require_root() {
  if [[ $EUID -ne 0 ]]; then
    echo "Run as root." >&2
    exit 1
  fi
}

apt_install_base() {
  apt-get update
	DEBIAN_FRONTEND=noninteractive apt-get install -y \
		xserver-xorg xinit openbox x11-xserver-utils \
		xinput x11-xkb-utils \
		fonts-dejavu-core \
		libinput10 xserver-xorg-input-libinput xserver-xorg-input-all \
		dbus-x11 \
		unclutter \
		snapd \
		xserver-xorg-video-all xserver-xorg-video-dummy xserver-xorg-video-vesa xserver-xorg-video-qxl \
		libgl1-mesa-dri mesa-utils \
		linux-firmware wpasupplicant
  systemctl enable --now snapd || true
}

install_chromium_snap() {
  for i in {1..10}; do
    if snap list >/dev/null 2>&1; then break; fi
    sleep 2
  done
  snap install chromium
}

create_user_and_autologin() {
  if ! id "${KIOSK_USER}" >/dev/null 2>&1; then
    useradd -m -s /bin/bash "${KIOSK_USER}"
    echo "${KIOSK_USER}:${KIOSK_PASS}" | chpasswd
  fi
  usermod -aG video,input,plugdev "${KIOSK_USER}" || true

  mkdir -p /etc/systemd/system/getty@tty1.service.d
  cat >/etc/systemd/system/getty@tty1.service.d/override.conf <<EOF
[Service]
ExecStart=
ExecStart=-/sbin/agetty --autologin ${KIOSK_USER} --noclear %I \$TERM
Type=idle
EOF
  systemctl daemon-reload
  systemctl enable getty@tty1.service
}

write_env_defaults() {
  if [[ ! -f "$KIOSK_ENV" ]]; then
    cat >"$KIOSK_ENV" <<'EOF'
# Kiosk settings
KIOSK_URL="https://www.pointclickcare.com/poc/userLogin.xhtml"

# KIOSK_ALLOWLIST="https://pay.example.com/* https://idp.example.org/*"
KIOSK_ALLOWLIST="https://www.pointclickcare.com/* https://pointclickcare.com/*"

KIOSK_FLAGS="--noerrdialogs --disable-session-crashed-bubble --disable-infobars --kiosk --incognito --check-for-update-interval=0 --no-first-run --disable-features=Translate,AutofillServerCommunication --overscroll-history-navigation=0 --test-type"
EOF
  fi
}

kiosk_session_script() {
  cat >"$KIOSK_BIN" <<'EOF'
#!/usr/bin/env bash
set -euo pipefail
source /etc/kiosk.env

xset -dpms
xset s off
xset s noblank

unclutter -idle 1 -root &

# Chromium (snap)
CHROMIUM="/snap/bin/chromium"

exec "$CHROMIUM" $KIOSK_FLAGS "$KIOSK_URL"
EOF
  chmod +x "$KIOSK_BIN"
  chown root:root "$KIOSK_BIN"
}

setup_xinit_for_user() {
  local home_dir
  home_dir="$(getent passwd "${KIOSK_USER}" | cut -d: -f6)"
  mkdir -p "${home_dir}/.config/openbox"

  cat >"${home_dir}/.xinitrc" <<'EOF'
#!/usr/bin/env bash
set -e
openbox-session &
/usr/local/bin/kiosk-session.sh
EOF
  chmod +x "${home_dir}/.xinitrc"

  cat >"${home_dir}/.bash_profile" <<'EOF'
if [[ -z "$DISPLAY" && $(tty) == /dev/tty1 ]]; then
  startx -- -nocursor
  logout
fi
EOF

  chown -R "${KIOSK_USER}:${KIOSK_USER}" "${home_dir}/.xinitrc" "${home_dir}/.bash_profile" "${home_dir}/.config"
}

render_policies() {
  source "$KIOSK_ENV"
  local allow=()
  allow+=("${KIOSK_URL%/}/*")

  if [[ -n "${KIOSK_ALLOWLIST:-}" ]]; then
    local extras=($KIOSK_ALLOWLIST)
    for e in "${extras[@]}"; do
      allow+=("$e")
    done
  fi

  local json_items=""
  for a in "${allow[@]}"; do
    local esc=${a//\"/\\\"}
    json_items+="\"$esc\","
  done
  json_items="${json_items%,}"  # срезаем последнюю запятую

  install -d "${KIOSK_POLICY_DIR_SYS}" "${KIOSK_POLICY_DIR_SNAP}"
  for dir in "${KIOSK_POLICY_DIR_SYS}" "${KIOSK_POLICY_DIR_SNAP}"; do
    cat >"${dir}/kiosk.json" <<EOF
{
  "URLBlocklist": ["*"],
  "URLAllowlist": [ ${json_items} ],

  "DefaultPopupsSetting": 1,

  "RestoreOnStartup": 4,
  "HomepageIsNewTabPage": false,
  "HomepageLocation": "${KIOSK_URL%/}/",
  "ShowHomeButton": false,
  "PasswordManagerEnabled": false,
  "SyncDisabled": true,
  "PrintingEnabled": false,
  "DownloadRestrictions": 3,
  "DeveloperToolsAvailability": 2,
  "IncognitoModeAvailability": 0,
  "AutofillAddressEnabled": false,
  "AutofillCreditCardEnabled": false,
  "TranslateEnabled": false,
  "ExtensionInstallBlocklist": ["*"],
  "ScrollToTextFragmentEnabled": false,
  "BookmarkBarEnabled": false
}
EOF
  done
}

disable_console_blank() {
  if [[ -f /etc/default/grub ]]; then
    sed -i 's/^\(GRUB_CMDLINE_LINUX_DEFAULT="[^"]*\)"/\1 consoleblank=0"/' /etc/default/grub || true
    update-grub || true
  fi
}

main() {
  require_root
  apt_install_base
  install_chromium_snap
  create_user_and_autologin
  write_env_defaults
  kiosk_session_script
  setup_xinit_for_user
  render_policies
  disable_console_blank

  echo "Kiosk installed. Rebooting in 3 seconds..."
  sleep 3
  reboot
}

main "$@"

