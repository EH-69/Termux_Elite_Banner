#!/data/data/com.termux/files/usr/bin/bash

# ==============================================================================
#  PROJECT   : EH ELITE TERMINAL HUD
#  DEVELOPER : EH-69
#  REPO      : Termux_Elite_Banner
# ==============================================================================

clear
echo -e "\033[38;5;46m"
cat << "EOF"
  ______ _    _         __   ___  
 |  ____| |  | |       / /  / _ \ 
 | |__  | |__| |____  / /_ | (_) |
 |  __| |  __  |____ | '_ \ \__, |
 | |____| |  | |     | (_) |  / / 
 |______|_|  |_|      \___/  /_/  
EOF
echo -e "\033[1;32m[*] EH Elite Terminal Setup Engine\033[0m"
echo -e "\033[38;5;240m────────────────────────────────────────────────────────────\033[0m"

# সাইলেন্ট ডিপেন্ডেন্সি ও প্যাকেজ মেরামত
dpkg --configure -a >/dev/null 2>&1
pkg update -y >/dev/null 2>&1
pkg install -y ncurses-utils procps tar xz-utils figlet curl wget >/dev/null 2>&1

if ! curl -V >/dev/null 2>&1; then
    pkg reinstall -y curl libcurl libngtcp2 openssl >/dev/null 2>&1
fi

# ইউজার থেকে ব্যানারের নাম ইনপুট
echo -e "\033[1;33m[?] Customization Option:\033[0m"
read -p "Enter Banner Name [Press Enter for default: EH-69]: " USER_BANNER
USER_BANNER=${USER_BANNER:-"EH-69"}

# ব্যাকআপ
[ -f ~/.bashrc ] && cp ~/.bashrc ~/.bashrc.bak_eh69 2>/dev/null

# ৩ডি ফন্ট ডাউনলোড
mkdir -p ~/.figlet_fonts
FONT_URL="https://raw.githubusercontent.com/xero/figlet-fonts/master/ANSI%20Shadow.flf"
curl -fsSL "$FONT_URL" -o ~/.figlet_fonts/ANSI_Shadow.flf 2>/dev/null || \
wget -qO ~/.figlet_fonts/ANSI_Shadow.flf "$FONT_URL" 2>/dev/null

# ble.sh ইনস্টলেশন
mkdir -p ~/.local/share
rm -rf /tmp/ble.tar.xz ~/.local/share/ble-nightly 2>/dev/null
BLE_URL="https://github.com/akinomyoga/ble.sh/releases/download/nightly/ble-nightly.tar.xz"
(curl -k -fsSL "$BLE_URL" -o /tmp/ble.tar.xz 2>/dev/null || wget --no-check-certificate -qO /tmp/ble.tar.xz "$BLE_URL" 2>/dev/null)

if [ -f /tmp/ble.tar.xz ] && [ -s /tmp/ble.tar.xz ]; then
    tar -xJf /tmp/ble.tar.xz -C ~/.local/share/ 2>/dev/null
    rm -rf ~/.local/share/blesh 2>/dev/null
    mv ~/.local/share/ble-nightly ~/.local/share/blesh 2>/dev/null
    rm -f /tmp/ble.tar.xz 2>/dev/null
fi

cat << 'EOF' > ~/.blerc
bleopt highlight_syntax=1
bleopt complete_auto_menu=1
bleopt complete_auto_delay=100
bleopt prompt_ps1_transient=
ble-face -s auto_complete fg=242
ble-face -s command_builtin fg=46,bold
ble-face -s command_alias fg=51,bold
ble-face -s command_function fg=213,bold
ble-face -s command_file fg=84
ble-face -s command_error fg=196,underline
EOF

# পার্ট ১: ইউজারের নাম সংরক্ষণ
cat << EOF > ~/.bashrc
export LANG=C.UTF-8
export LC_ALL=C.UTF-8
MY_NAME="$USER_BANNER"
DEV_NAME="EH-69"
EOF

# পার্ট ২: টার্মিনাল HUD ও র‍্যান্ডম কালার ইঞ্জিন
cat << 'EOF' >> ~/.bashrc
[[ $- == *i* ]] && [ -f "$HOME/.local/share/blesh/ble.sh" ] && source "$HOME/.local/share/blesh/ble.sh" --attach=none

print_banner() {
    # প্রতিবার clear দিলে আলাদা আলাদা নিয়ন কালার থিম জেনারেট হবে
    local THEME=$((RANDOM % 5))
    if [ $THEME -eq 0 ]; then
        # Cyber Sunset
        TOP_C='\033[38;5;208m'; BOT_C='\033[38;5;198m'; BORD_C='\033[38;5;129m'; ACC_C='\033[38;5;51m'
    elif [ $THEME -eq 1 ]; then
        # Matrix Neon Green
        TOP_C='\033[38;5;154m'; BOT_C='\033[38;5;46m';  BORD_C='\033[38;5;34m';  ACC_C='\033[38;5;226m'
    elif [ $THEME -eq 2 ]; then
        # Tokyo Neon Cyan
        TOP_C='\033[38;5;51m';  BOT_C='\033[38;5;39m';  BORD_C='\033[38;5;27m';  ACC_C='\033[38;5;213m'
    elif [ $THEME -eq 3 ]; then
        # Electric Violet & Pink
        TOP_C='\033[38;5;213m'; BOT_C='\033[38;5;141m'; BORD_C='\033[38;5;63m';  ACC_C='\033[38;5;46m'
    else
        # Golden Fire
        TOP_C='\033[38;5;220m'; BOT_C='\033[38;5;202m'; BORD_C='\033[38;5;166m'; ACC_C='\033[38;5;45m'
    fi

    export DYN_THEME_C="$TOP_C"

    local W='\033[1;37m'; local NC='\033[0m'
    local NEON_RED='\033[38;5;196;1m'

    local TERM_COLS=$(tput cols 2>/dev/null || echo 50)
    [ "$TERM_COLS" -lt 44 ] && TERM_COLS=44
    [ "$TERM_COLS" -gt 60 ] && TERM_COLS=54

    echo ""

    # ১ম লাইনে ডাবল দাগ
    printf "${BORD_C}"
    for ((j=0; j<TERM_COLS; j++)); do printf "═"; done
    printf "${NC}\n"

    # ২য় লাইনে সাইবার ডেকোরেশন
    local TOP_MID=" » ---- «•○ ❈ ○•» ---- « "
    local SIDE_LEN=$(( (TERM_COLS - ${#TOP_MID}) / 2 ))
    [ $SIDE_LEN -lt 2 ] && SIDE_LEN=2
    local EQ=""
    for ((j=0; j<SIDE_LEN-2; j++)); do EQ="${EQ}="; done
    printf "${BORD_C}:%s%s%s:${NC}\n" "$EQ" "$TOP_MID" "$EQ"

    # ৩ডি ফন্ট রেন্ডার
    local FONT="$HOME/.figlet_fonts/ANSI_Shadow.flf"
    local ASCII_OUT
    if [ -f "$FONT" ]; then
        ASCII_OUT=$(figlet -f "$FONT" "$MY_NAME" 2>/dev/null)
    else
        ASCII_OUT=$(figlet "$MY_NAME" 2>/dev/null)
    fi

    mapfile -t ASCII_ART <<< "$ASCII_OUT"

    while [ ${#ASCII_ART[@]} -gt 0 ] && [[ -z "${ASCII_ART[-1]// }" ]]; do
        unset 'ASCII_ART[-1]'
    done

    local TOTAL_LINES=${#ASCII_ART[@]}
    local HALF_LINES=$((TOTAL_LINES / 2))

    for (( i=0; i<TOTAL_LINES; i++ )); do
        local line="${ASCII_ART[$i]}"
        local pad=$(( (TERM_COLS - ${#line}) / 2 ))
        [ $pad -lt 0 ] && pad=0
        if [ $i -lt $HALF_LINES ]; then
            printf "%${pad}s${TOP_C}%s${NC}\n" "" "$line"
        else
            printf "%${pad}s${BOT_C}%s${NC}\n" "" "$line"
        fi
    done

    # EH ELITE TERMINAL
    local SUB_TEXT="ﮩ٨ـﮩﮩ٨ـ𝙴𝙷 𝙴𝙻𝙸𝚃𝙴 𝚃𝙴𝚁𝙼𝙸𝙽𝙰𝙻ﮩ٨ـﮩﮩ٨ـ"
    local PAD_SUB=$(( (TERM_COLS - ${#SUB_TEXT}) / 2 ))
    [ $PAD_SUB -lt 0 ] && PAD_SUB=0
    printf "%${PAD_SUB}s${NEON_RED}%s${NC}\n\n" "" "$SUB_TEXT"

    # বক্স অ্যালাইনমেন্ট
    local INNER_WIDTH=$((TERM_COLS - 2))

    draw_line() {
        local left=$1; local fill=$2; local right=$3
        printf "${BORD_C}${left}"
        for ((k=0; k<INNER_WIDTH-2; k++)); do printf "${fill}"; done
        printf "${right}${NC}\n"
    }

    draw_row() {
        local icon="$1"; local label="$2"; local val="$3"
        local content_len=$(( 2 + 1 + 8 + 3 + ${#val} ))
        local spaces=$(( INNER_WIDTH - content_len - 2 ))
        [ $spaces -lt 0 ] && spaces=0

        local pad_str=""
        for ((k=0; k<spaces; k++)); do pad_str="${pad_str} "; done

        printf "${BORD_C}║ %s ${W}%-8s${BORD_C}│ ${W}%s%s${BORD_C}║\n" "$icon" "$label" "$val" "$pad_str"
    }

    local IP_ADDR=$(ip -4 addr show wlan0 2>/dev/null | grep -oP '(?<=inet\s)\d+(\.\d+){3}' | head -n1)
    [ -z "$IP_ADDR" ] && IP_ADDR=$(ip route get 1.1.1.1 2>/dev/null | awk '{print $7}')
    [ -z "$IP_ADDR" ] && IP_ADDR="127.0.0.1"

    local BAT_VAL="100%"
    for p in /sys/class/power_supply/*/capacity; do
        if [ -r "$p" ]; then BAT_VAL="$(cat "$p" 2>/dev/null)%"; break; fi
    done

    local DATE_VAL="$(date '+%d %B %Y  ·  %A')"
    local TIME_VAL="$(date '+%I:%M:%S %p')"
    local STRG_VAL=$(df -h "$HOME" 2>/dev/null | awk 'NR==2 {print $4" free / "$2}')
    local MEM_VAL=$(awk '/MemAvailable/ {avail=int($2/1024)} /MemTotal/ {total=int($2/1024)} END {printf "%dMB / %dMB", avail, total}' /proc/meminfo 2>/dev/null)
    [ -z "$MEM_VAL" ] && MEM_VAL="Active"

    draw_line "╔" "═" "╗"
    draw_row "👤" "AUTHOR" "EH-69 (github.com/EH-69)"
    draw_row "📅" "DATE"   "$DATE_VAL"
    draw_row "⏰" "TIME"   "$TIME_VAL"
    draw_line "╠" "═" "╣"
    draw_row "🌐" "NETWORK" "$IP_ADDR"
    draw_row "🔋" "BATTERY" "$BAT_VAL"
    draw_row "💾" "STORAGE" "$STRG_VAL"
    draw_row "🧠" "MEMORY"  "$MEM_VAL"
    draw_line "╚" "═" "╝"

    # মোটিভেশন টেক্সট
    local TAG_STR="- In zeros and ones - you are the one. -"
    local PAD_TAG=$(( (TERM_COLS - ${#TAG_STR}) / 2 ))
    [ $PAD_TAG -lt 0 ] && PAD_TAG=0
    printf "%${PAD_TAG}s${DYN_THEME_C}%s${NC}\n\n" "" "$TAG_STR"
}

# clear বা cls দিলে স্ক্রিন পরিষ্কার হয়ে প্রতিবার নতুন কালারের ব্যানার আসবে
alias clear='command clear; print_banner'
alias cls='clear'

command clear
print_banner

# ৩-লাইন কানেক্টেড নিয়ন গ্রিন প্রম্পট
build_prompt() {
    local EXIT_CODE=$?

    local C_SIDE="\[\033[38;5;46m\]"       # Neon Green
    local C_BRK="\[\033[38;5;51m\]"        # Cyan
    local C_AT="\[\033[1;37m\]"            # White
    local C_HST="\[\033[38;5;84m\]"        # Terminal Host
    local C_DIR="\[\033[38;5;221m\]"       # Gold Directory
    local RST="\[\033[0m\]"

    local C_USER="\[${DYN_THEME_C:-\033[38;5;213m}\]"

    local ARROWS
    if [ $EXIT_CODE -ne 0 ]; then
        ARROWS="\[\033[1;31m\]❯❯❯"
    else
        ARROWS="\[\033[38;5;201m\]❯\[\033[38;5;129m\]❯\[\033[38;5;51m\]❯"
    fi

    PS1="${C_SIDE}┌──${C_BRK}[${C_USER}${MY_NAME}${C_AT}@${C_HST}Terminal${C_BRK}]${C_SIDE}-${C_BRK}[${C_DIR}\w${C_BRK}]\n"
    PS1+="${C_SIDE}│\n"
    PS1+="${C_SIDE}└───${ARROWS}${RST} "
}

PROMPT_COMMAND=build_prompt

[[ ${BLE_VERSION-} ]] && ble-attach
EOF

# কোনো এরর ছাড়াই সফল ফিনিশিং
source ~/.bashrc 2>/dev/null
echo -e "\033[1;32m[✓] Setup Successful!\033[0m\n"
exit 0
