#!/data/data/com.termux/files/usr/bin/bash

# ==============================================================================
#  PROJECT   : EH ELITE TERMINAL HUD
#  DEVELOPER : EH-69 (https://github.com/EH-69)
#  REPO      : https://github.com/EH-69/EH-Terminal
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
echo -e "\033[1;32m[*] Welcome to EH Elite Terminal Installer by \033[1;36mEH-69\033[0m"
echo -e "\033[38;5;240m────────────────────────────────────────────────────────────\033[0m"

# ১. ইউজার থেকে ব্যানারের নাম ইনপুট নেওয়া (ডিফল্ট: EH-69)
echo -e "\033[1;33m[?] Customization Option:\033[0m"
read -p "Enter Banner Name [Press Enter for default: EH-69]: " USER_BANNER
USER_BANNER=${USER_BANNER:-"EH-69"}

echo -e "\n\033[1;36m[*] Selected Banner Name: \033[1;32m$USER_BANNER\033[0m"
echo -e "\033[1;36m[*] Setting up core packages, fonts & ble.sh...\033[0m"

# ব্যাকআপ
[ -f ~/.bashrc ] && cp ~/.bashrc ~/.bashrc.bak_eh69 2>/dev/null

pkg update -y > /dev/null 2>&1
pkg install -y figlet wget curl tar xz-utils ncurses-utils procps > /dev/null 2>&1

# ৩ডি ফন্ট ডাউনলোড
mkdir -p ~/.figlet_fonts
wget -qO ~/.figlet_fonts/ANSI_Shadow.flf "https://raw.githubusercontent.com/xero/figlet-fonts/master/ANSI%20Shadow.flf" 2>/dev/null

# ble.sh ইনস্টলেশন
mkdir -p ~/.local/share
rm -rf /tmp/ble.tar.xz ~/.local/share/ble-nightly 2>/dev/null
curl -k -fsSL "https://github.com/akinomyoga/ble.sh/releases/download/nightly/ble-nightly.tar.xz" -o /tmp/ble.tar.xz 2>/dev/null || \
wget --no-check-certificate -qO /tmp/ble.tar.xz "https://github.com/akinomyoga/ble.sh/releases/download/nightly/ble-nightly.tar.xz" 2>/dev/null

if [ -f /tmp/ble.tar.xz ] && [ -s /tmp/ble.tar.xz ]; then
    tar -xJf /tmp/ble.tar.xz -C ~/.local/share/ 2>/dev/null
    rm -rf ~/.local/share/blesh 2>/dev/null
    mv ~/.local/share/ble-nightly ~/.local/share/blesh 2>/dev/null
    rm -f /tmp/ble.tar.xz 2>/dev/null
fi

# ble.sh কনফিগারেশন তৈরি
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

# পার্ট ১: ইউজারের পছন্দের নাম .bashrc ফাইলে সেভ করা
cat << EOF > ~/.bashrc
# ==============================================================================
#  EH ELITE TERMINAL CONFIGURATION
#  CREATOR: EH-69 (https://github.com/EH-69)
# ==============================================================================
export LANG=C.UTF-8
export LC_ALL=C.UTF-8

# ইউজার কনফিগার করা ব্যানারের নাম
MY_NAME="$USER_BANNER"
DEV_NAME="EH-69"
EOF

# পার্ট ২: মূল টার্মিনাল ইঞ্জিন অ্যাপেন্ড করা
cat << 'EOF' >> ~/.bashrc
# ble.sh লোড
[[ $- == *i* ]] && [ -f "$HOME/.local/share/blesh/ble.sh" ] && source "$HOME/.local/share/blesh/ble.sh" --attach=none

print_banner() {
    # নিয়ন থিম প্যালেট
    local THEME=$((RANDOM % 4))
    if [ $THEME -eq 0 ]; then
        TOP_C='\033[38;5;208m'; BOT_C='\033[38;5;198m'; BORD_C='\033[38;5;129m'; ACC_C='\033[38;5;51m'
    elif [ $THEME -eq 1 ]; then
        TOP_C='\033[38;5;154m'; BOT_C='\033[38;5;46m';  BORD_C='\033[38;5;34m';  ACC_C='\033[38;5;226m'
    elif [ $THEME -eq 2 ]; then
        TOP_C='\033[38;5;51m';  BOT_C='\033[38;5;39m';  BORD_C='\033[38;5;27m';  ACC_C='\033[38;5;213m'
    else
        TOP_C='\033[38;5;213m'; BOT_C='\033[38;5;141m'; BORD_C='\033[38;5;63m';  ACC_C='\033[38;5;46m'
    fi

    export DYN_THEME_C="$TOP_C"

    local W='\033[1;37m'; local NC='\033[0m'
    local NEON_RED='\033[38;5;196;1m'

    local TERM_COLS=$(tput cols 2>/dev/null || echo 50)
    [ "$TERM_COLS" -lt 44 ] && TERM_COLS=44
    [ "$TERM_COLS" -gt 60 ] && TERM_COLS=54

    echo ""

    # ১. ১ম লাইনে বক্সের মতো ডাবল দাগ
    printf "${BORD_C}"
    for ((j=0; j<TERM_COLS; j++)); do printf "═"; done
    printf "${NC}\n"

    # ২. ২য় লাইনে আগের সাইবার ডিজাইন
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

    # ফন্টের নিচের লুকানো খালি লাইন অটোমেটিক ট্রিম করা
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

    # ৩. ব্যানারের নিচে কোনো ফাঁকা স্পেস ছাড়া EH ELITE TERMINAL
    local SUB_TEXT="ﮩ٨ـﮩﮩ٨ـ𝙴𝙷 𝙴𝙻𝙸𝚃𝙴 𝚃𝙴𝚁𝙼𝙸𝙽𝙰𝙻ﮩ٨ـﮩﮩ٨ـ"
    local PAD_SUB=$(( (TERM_COLS - ${#SUB_TEXT}) / 2 ))
    [ $PAD_SUB -lt 0 ] && PAD_SUB=0
    printf "%${PAD_SUB}s${NEON_RED}%s${NC}\n\n" "" "$SUB_TEXT"

    # ৪. ১০০% পারফেক্ট অ্যালাইনমেন্ট বক্স
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

    # ৫. বক্সের নিচে কোনো ফাঁকা ছাড়া মোটিভেশন টেক্সট
    local TAG_STR="- In zeros and ones - you are the one. -"
    local PAD_TAG=$(( (TERM_COLS - ${#TAG_STR}) / 2 ))
    [ $PAD_TAG -lt 0 ] && PAD_TAG=0
    printf "%${PAD_TAG}s${DYN_THEME_C}%s${NC}\n\n" "" "$TAG_STR"
}

# ক্লিয়ার এলিয়াস
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

    # ইউজারের নাম ডায়নামিক কালারে থাকবে
    local C_USER="\[${DYN_THEME_C:-\033[38;5;213m}\]"

    # এরর ডিটেকশন (ভুল হলে লাল অ্যারো)
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

# ble.sh হুক
[[ ${BLE_VERSION-} ]] && ble-attach
EOF

source ~/.bashrc 2>/dev/null
echo -e "\n\033[1;32m[✔] Installation Successful for $USER_BANNER!\033[0m"
echo -e "\033[1;36mAuthor Credit: EH-69 (https://github.com/EH-69)\033[0m\n"
