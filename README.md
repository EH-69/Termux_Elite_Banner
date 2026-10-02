<div align="center">
  <h1>🚀 Termux Elite Setup (Dynamic Edition)</h1>
  <p><i>A beautiful, dynamic, and auto-color-changing setup to transform your boring Termux interface.</i></p>
  <img src="https://img.shields.io/badge/Platform-Termux-green?style=flat-square&logo=android" alt="Termux">
  <img src="https://img.shields.io/badge/Script-Bash-gray?style=flat-square&logo=gnu-bash" alt="Bash">
  <br><br>
</div>

## 🖼️ Terminal Preview
*(Colors change automatically every time you clear the screen!)*

<div align="center">
  <img src="preview.GIF" alt="Termux Preview" width="400px" style="border-radius: 10px;">
</div>

<br>

## ✨ Features
- 🎨 **Dynamic Theme Generator:** Switches between 4 stunning dual-tone themes (Pink/Blue, Yellow/Green, Cyan/Blue, White/Neon) every time you type `clear`.
- 📊 **Live System Info:** Date, Time, Local IP, Storage, and RAM values update in real-time.
- 🎯 **Flawless Alignment:** Pure heavy borders (`━`) and flawlessly calculated column spacing.
- ⚡ **Zero Config:** Auto-installs `figlet`, `ncurses-utils`, and custom ANSI Shadow fonts.
- 💻 **Custom Elite Prompt:** Clean `PS1` prompt with a solid red heart (♥) indicator.

## 🛠️ Installation Methods

### Option 1: Auto Install (Single Command) - Recommended
Copy and paste this single command into your Termux app and press Enter:
```bash
bash <(curl -fsSL https://raw.githubusercontent.com/EH-69/Termux_Elite_Banner/refs/heads/main/setup.sh)
```
`(During setup, simply type the name you want to display on the 3D banner!)`

💡 How it works
Once installed, your terminal will always open with this gorgeous banner. Whenever your terminal gets messy, just type:
```bash
clear
```

## 🛠️ Option 2: Manual Installation (Step-by-Step)

If you prefer to set up the repository manually from scratch, follow these steps in your Termux new version app:

### Step 1: Update Packages and Install Git
First, update your package list and install `git` so you can clone the repository:
```bash
pkg update && pkg upgrade -y
```
and install git
```bash
pkg install git -y
```

Step 2: Clone the Repository
Clone your project repository from GitHub to your local Termux storage:
```bash
git clone https://github.com/EM57/Termux_Elite_Banner.git
```
Step 3: Navigate into the Project Folder
Go inside the newly created project directory:
```bash
cd Termux_Elite_Banner
```
Step 4: Give Execution Permission
Make the setup script executable by granting permissions:
```bash
chmod +x setup.sh
```
Step 5: Run the Setup Script
Execute the script to complete the configuration and enter your name when prompted:
```bash
./setup.sh
```
Step 6: Apply Changes
Finally, reload your shell configuration to instantly view your new elite banner:
```bash
source ~/.bashrc
```

`The screen will instantly wipe clean, generate a brand new color theme, and refresh your system info!`

📌 Requirements
Termux App (Ensure it is downloaded from F-Droid, not the Play Store).
Active Internet Connection (Only required during the first setup).


<div align="center">
<sub>Created with ❤️ by <a href="https://github.com/EM57">EM57</a></sub>
</div>
