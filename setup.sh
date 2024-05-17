#!/bin/bash

CRE=$(tput setaf 1)
CYE=$(tput setaf 3)
CGR=$(tput setaf 2)
CBL=$(tput setaf 4)
BLD=$(tput bold)
CNC=$(tput sgr0)

cwd=$(pwd)
font_dir="$HOME/.local/share/fonts"
config_dir="$HOME/.config"
backup_dir="$HOME/.dotfiles_backup"
date=$(date +%Y%m%d-%H%M%S)

title() {
  local text=$1
  printf '\n [%s %s %s]\n\n' "${CYE}" "$text" "${CNC}"
}

#### DONT RUN AS ROOT ####

if [ "$(id -u)" = 0 ]; then
    echo "This script MUST NOT be run as root" 1>&2
    exit 1
fi

#### WELCOME ####

printf '\n %s[%s justicenyaga dotfiles installer %s]\n\n' "${BLD}" "${CGR}" "${CNC}"

printf '%s%sThis script:
  [*] Installs the necessary dependencies
  [*] Creates a backup of your current config files in %s%s%s
  [*] Copies the new config files to your computer.

The script DOES NOT modify any of your system configurations and does not have the potential to break your system. It only copies config files to your HOME directory.

You will be prompted for your root password to install missing dependencies and/or to switch to zsh shell if its not your default.%s\n\n' "${BLD}" "${CRE}" "${CBL}" "$backup_dir" ${CRE} "${CNC}"

print_invalid_input() {
  printf "Invalid input. Please enter 'y' or 'n'\n\n"
}

while true; do
  read -rp "Do you wish to continue? [y/N]: " yn
  case $yn in
    [Yy]* ) break ;;
    [Nn]* ) exit ;;
    * ) print_invalid_input
  esac
done
clear

printf "If you wish to retain your current Neovim configuration, choose 'n'. Otherwise, we'll back up your current config.\n"


while true; do
  read -rp "Do you want to try my nvim config? [y/N]: " try_nvim
  case $try_nvim in
    [Yy]* | [Nn]* ) break ;;
    * ) print_invalid_input
  esac
done

while true; do
  printf "\n"
  read -rp "Do you want to change your default shell to zsh? [y/N]: " change_shell
  case $change_shell in
    [Yy]* | [Nn]* ) break ;;
    * ) print_invalid_input
  esac
done

while true; do
  printf "\n"
  read -rp "Install node-version-manager(nvm)? [y/N]: " i_node
  case $i_node in
    [Yy]* | [Nn]* ) break ;;
    * ) print_invalid_input
  esac
done

while true; do
  printf "\n"
  read -rp "Install golang? [y/N]: " i_golang
  case $i_golang in
    [Yy]* | [Nn]* ) break ;;
    * ) print_invalid_input
  esac
done

while true; do
  printf "\n"
  read -rp "Install Java? [y/N]: " i_java
  case $i_java in
    [Yy]* | [Nn]* ) break ;;
    * ) print_invalid_input
  esac
done

while true; do
  printf "\n"
  read -rp "Install postgres? [y/N]: " i_postgres
  case $i_postgres in
    [Yy]* | [Nn]* ) break ;;
    * ) print_invalid_input
  esac
done

while true; do
  printf "\n"
  read -rp "Install MySQL? [y/N]: " i_mysql
  case $i_mysql in
    [Yy]* | [Nn]* ) break ;;
    * ) print_invalid_input
  esac
done

while true; do
  printf "\n"
  read -rp "Install mariadb? [y/N]: " i_mariadb
  case $i_mariadb in
    [Yy]* | [Nn]* ) break ;;
    * ) print_invalid_input
  esac
done

while true; do
  printf "\n"
  read -rp "Install adb and scrcpy? [y/N]: " i_adb
  case $i_adb in
    [Yy]* | [Nn]* ) break ;;
    * ) print_invalid_input
  esac
done

while true; do
  printf "\n"
  read -rp "Install lxappearance? [y/N]: " i_lxappearance
  case $i_lxappearance in
    [Yy]* | [Nn]* ) break ;;
    * ) print_invalid_input
  esac
done

clear

#### INSTALLING DEPENDENCIES ####

title "Installing dependencies"

dependencies=(
  arandr blueman brightnessctl build-essential cheese cmake cmake-data curl dstat eog fd-find feh file-roller git \
  gnome-screenshot i3 i3-wm i3lock-fancy libasound2-dev libcairo2-dev libcurl4-openssl-dev \
  libfuse2 libjsoncpp-dev libmpdclient-dev libnl-genl-3-dev libpulse-dev libuv1-dev \
  libxcb1-dev libxcb-composite0-dev libxcb-cursor-dev libxcb-ewmh-dev libxcb-image0-dev \
  libxcb-icccm4-dev libxcb-randr0-dev libxcb-util0-dev libxcb-xkb-dev libxcb-xrm-dev \
  light mate-power-manager mercurial mpv net-tools network-manager pavucontrol picom playerctl \
  pkg-config python3 python3-pip python3-sphinx python3-packaging python3-xcbgen python3-venv \
  rar ripgrep rofi ruby-full shotwell thunar tmux unrar unzip vlc wget x11-xserver-utils xautolock xclip xcb-proto xdotool yad zip zsh
)

sudo apt update
sudo apt install -y "${dependencies[@]}"

## Kitty ##

if ! command -v kitty &> /dev/null; then
  printf "%s%s\n\nInstalling kitty...%s\n" "${BLD}" "${CYE}" "${CNC}"
  sleep 1

  curl -L https://sw.kovidgoyal.net/kitty/installer.sh | sh /dev/stdin
  [[ ! -d "$HOME/.local/bin" ]] && mkdir -p "$HOME/.local/bin"
  ln -sf ~/.local/kitty.app/bin/kitty ~/.local/kitty.app/bin/kitten ~/.local/bin/
  [[ ! -d "$HOME/.local/share/applications" ]] && mkdir -p "$HOME/.local/share/applications"
  cp ~/.local/kitty.app/share/applications/kitty.desktop ~/.local/share/applications/
  cp ~/.local/kitty.app/share/applications/kitty-open.desktop ~/.local/share/applications/
  sed -i "s|Icon=kitty|Icon=/home/$USER/.local/kitty.app/share/icons/hicolor/256x256/apps/kitty.png|g" ~/.local/share/applications/kitty*.desktop
  sed -i "s|Exec=kitty|Exec=/home/$USER/.local/kitty.app/bin/kitty|g" ~/.local/share/applications/kitty*.desktop
fi

## Tmux ##

if [[ ! -d "$HOME/.tmux/plugins/tpm" ]]; then
  printf "%s%s\n\nInstalling tmux plugin manager...%s\n" "${BLD}" "${CYE}" "${CNC}"
  sleep 1
  if git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm; then
    printf "%s%s\nTmux plugin manager installed successfully.%s\n" "${BLD}" "${CGR}" "${CNC}"
    sleep 1
  else
    printf "%s%s\nError: Unable to install tmux plugin manager.%s\n" "${BLD}" "${CRE}" "${CNC}"
    sleep 1
  fi
fi

## Polybar ##

install_polybar() {
  printf "%s%s\n\nInstalling latest stable polybar release...%s\n" "${BLD}" "${CYE}" "${CNC}"
  sleep 1

  wget https://github.com/polybar/polybar/releases/download/3.7.1/polybar-3.7.1.tar.gz
  tar -xzf polybar-3.7.1.tar.gz --transform 's/polybar-3.7.1/polybar/'
  mkdir polybar/build
  cd polybar/build
  cmake ..
  make -j$(nproc)
  sudo make install
  cd "$cwd"
}

# skip polybar installation if polybar is already installed and version >= 3.7.0 
if command -v polybar &> /dev/null; then
  required_polybar_version="3.7.0"
  polybar_version=$(polybar --version | head -n 1 | awk '{print $2}')
  if [[ "$polybar_version" < "$required_polybar_version" ]]; then
    sudo apt remove -y polybar
    install_polybar
  fi
else 
  install_polybar
fi

## Neovim ##

install_nvim() {
  curl -LO https://github.com/neovim/neovim/releases/latest/download/nvim-linux64.tar.gz
  sudo tar -C /opt -xzf nvim-linux64.tar.gz --transform 's/nvim-linux64/nvim/'

  if sudo ln -sf /opt/nvim/bin/nvim /usr/bin/nvim; then
    printf "%s%s\n\nLatest stable neovim installed successfully.%s\n" "${BLD}" "${CGR}" "${CNC}"
    sleep 2
  else
    printf "%s%s\n\nFailed to install Neovim. Exiting...%s\n" "${BLD}" "${CRE}" "${CNC}"
    sleep 1
    exit 1
  fi
}

nvim_exists() {
  command -v nvim &> /dev/null
}

nvim_removed() {
  printf "%s%s\n\nRemoved old neovim successfully.%s\n" "${BLD}" "${CGR}" "${CNC}"
}

nvim_remove_failed(){
  printf "%s%s\n\nFailed to remove old neovim. Skipping neovim installation.%s\n" "${BLD}" "${CRE}" "${CNC}"
}

# Ensure neovim is version 0.9 or above
if [[ $try_nvim == [Yy] ]]; then
  required_nvim_version="0.9"
  nvim_version=$(nvim --version | awk '/NVIM/{print $2}' | cut -c 2-)

  # if version is less than required
  if [[ "$nvim_version" < "$required_nvim_version" ]]; then
    if ! nvim_exists; then
      printf "%s%s\n\nNeovim is not installed.\nInstalling the latest stable release...%s\n" "${BLD}" "${CRE}" "${CNC}"
      sleep 1
      install_nvim
    else
      printf "%s%s]\n\nInstalled neovim version ($nvim_version) is less than required version ($required_nvim_version).\nUpgrading to latest stable release...%s\n" "${BLD}" "${CRE}" "${CNC}"
      sleep 1

      # remove nvim if installed using APT
      sudo apt remove -y neovim

      # remove nvim if installed using snap
      [[ nvim_exists && $(snap list | grep "nvim") ]] && sudo snap remove nvim && install_nvim

      # if nvim was not installed via APT or snap
      if nvim_exists; then
        nvim_path=$(command -v nvim)

        # remove nvim if the executable is a symlink or an AppImage
        # AppImages have magic bytes 0x414902
        if [[ -L "$nvim_path" || $(xxd "$nvim_path" | grep -q "4192 02") ]]; then
          if sudo rm -f "$nvim_path" 2>> /dev/null; then
            nvim_removed
            install_nvim
            sleep 1
          else
            nvim_remove_failed
            sleep 1
            try_nvim="n"
          fi
        # nvim directory exists in /opt
        elif [[ -n $(ls /opt | grep "^nvim") ]]; then
          if sudo rm -rf /opt/nvim* 2>> /dev/null; then
            nvim_removed
            install_nvim
            sleep 1
          else
            nvim_remove_failed
            sleep 1
            try_nvim="n"
          fi
        # unable to remove nvim
        else
          nvim_remove_failed
          sleep 1
          try_nvim="n"
        fi
      fi
    fi
  fi
fi

## lxappearance ##

[[ $i_lxappearance == [Yy] ]] && sudo apt install -y lxappearance

## nvm ##

if [[ $i_node == [Yy] ]]; then
  curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.7/install.sh | bash

  export NVM_DIR="$([ -z "${XDG_CONFIG_HOME-}" ] && printf %s "${HOME}/.nvm" || printf %s "${XDG_CONFIG_HOME}/nvm")"
  [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"

  # Install the latest version of node
  nvm install node

  npm install -g yarn neovim tree-sitter
fi

## Python ##

pip install autotiling

[[ $try_nvim == [Yy] ]] && python3 -m pip install -U pynvim

## Installing golang ##

if [[ $i_golang == [Yy] ]]; then
  wget https://go.dev/dl/go1.21.7.linux-amd64.tar.gz
  sudo rm -rf /usr/local/go && sudo tar -C /usr/local -xzf go1.21.7.linux-amd64.tar.gz

  export GOPATH=$HOME/go
  export GOROOT=/usr/local/go
  export PATH=$PATH:$GOPATH/bin:$GOROOT/bin

  go install golang.org/x/tools/gopls@latest
fi

## Java ##

if [[ $i_java == [Yy] ]]; then
  sudo apt install -y openjdk-21-jdk
  wget https://download.eclipse.org/jdtls/snapshots/jdt-language-server-1.31.0-202312211634.tar.gz && sudo tar -C /usr/local -xzf jdt-language-server-1.31.0-202312211634.tar.gz

  [[ ! -d "$HOME/.local/share/nvim" ]] && mkdir -p "$HOME/.local/share/nvim"
  git clone http://github.com/microsoft/java-debug.git "$HOME/.local/share/nvim/java-debug"
  cd "$HOME/.local/share/nvim/java-debug"
  ./mvnw clean install
fi

## Databases ##

if [[ $i_postgres == [Yy] ]]; then
  sudo apt install -y postgresql postgresql-contrib
  sudo systemctl start postgresql
  sudo systemctl enable postgresql
fi

if [[ $i_mysql == [Yy] ]]; then
  sudo apt install -y mysql-server
  sudo systemctl start mysql
  sudo systemctl enable mysql
fi

if [[ $i_mariadb == [Yy] ]]; then
  sudo apt install -y mariadb-server
  sudo systemctl start mariadb
  sudo systemctl enable mariadb
fi

## ADB ##

[[ $i_adb == [Yy] ]] && sudo apt install -y adb scrcpy

## gems ##

sudo gem install neovim colorls

#### PREPARING DIRECTORIES ####

# Verifies if the archieve user-dirs.dirs exists in ~/.config
if [ ! -e "$config_dir/user-dirs.dirs" ]; then
  xdg-user-dirs-updated
fi

#### BACKUP ####

title "Backing up your current configs"

printf "\nBackup files will be stored in %s%s%s%s \n\n" "${BLD}" "${CBL}" "${backup_dir}" "${CNC}"

[ ! -d "$backup_dir" ] && mkdir "$backup_dir"

for folder in i3 kitty picom polybar rofi; do
  if [ -d "$config_dir/$folder" ]; then
    if mv "$config_dir/$folder" "$backup_dir/${folder}_$date" 2>> /dev/null; then
      printf "%s%s%s folder backed up successfully to %s%s/%s_%s%s\n" "${BLD}" "${CGR}" "$folder" "${CBL}" "$backup_dir" "$folder" "$date" "$CNC"
      sleep 1
    else
      printf "%s%sFailed to backup %s folder. See error log for more details.%s\n" "${BLD}" "${CRE}" "$folder" "$CNC"
      sleep 1
    fi
  fi
done

if [[ $try_nvim == [Yy] ]]; then
  # backup nvim config
  if [ -d "$config_dir/nvim" ]; then
    if mv "$config_dir/nvim" "$backup_dir/nvim_$date" 2>> /dev/null; then
      printf "%s%snvim folder backed up successfully to %s%s/nvim_%s%s\n" "${BLD}" "${CGR}" "${CBL}" "$backup_dir" "$date" "$CNC"
      sleep 1
    else
      printf "%s%sFailed to backup nvim folder. See error log for more details.%s\n" "${BLD}" "${CRE}" "$CNC"
      sleep 1
    fi
  fi
fi

if [[ $change_shell == [Yy] ]]; then
  if [ -f "$HOME/.zshrc" ]; then
    if mv "$HOME/.zshrc" "$backup_dir/.zshrc_$date" 2>> /dev/null; then
      printf "%s%s.zshrc file backed up successfully to %s%s/.zshrc_%s%s\n" "${BLD}" "${CGR}" "${CBL}" "$backup_dir" "$date" "$CNC"
      sleep 1
    else
      printf "%s%sFailed to backup .zshrc file. See error log for more details.%s\n" "${BLD}" "${CRE}" "$CNC"
      sleep 1
    fi
  fi

  if [ -f "$HOME/.p10k.zsh" ]; then
    if mv "$HOME/.p10k.zsh" "$backup_dir/.p10k.zsh_$date" 2>> /dev/null; then
      printf "%s%s.p10k.zsh file backed up successfully to %s%s/.p10k.zsh_%s%s\n" "${BLD}" "${CGR}" "${CBL}" "$backup_dir" "$date" "$CNC"
      sleep 1
    else
      printf "%s%sFailed to backup .p10k.zsh file. See error log for more details.%s\n" "${BLD}" "${CRE}" "$CNC"
      sleep 1
    fi
  fi
fi

if [ -f "$HOME/.tmux.conf" ]; then
  if mv "$HOME/.tmux.conf" "$backup_dir/.tmux.conf_$date" 2>> /dev/null; then
    printf "%s%s.tmux.conf file backed up successfully to %s%s/.tmux.conf_%s%s\n\n" "${BLD}" "${CGR}" "${CBL}" "$backup_dir" "$date" "$CNC"
    sleep 1
  else
    printf "%s%sFailed to backup .tmux.conf file. See error log for more details.%s\n" "${BLD}" "${CRE}" "$CNC"
    sleep 1
  fi
fi
sleep 3

#### IINSTALLING FONTS ####

printf "%sInstalling fonts...%s\n" "${CYE}" "${CNC}"
[[ ! -d "$font_dir" ]] && mdkir -p "$font_dir"
cp -rf "$cwd/fonts"/* "$font_dir"
printf "%s%sFonts installed...%s\n\n" "${BLD}" "${CGR}" "${CNC}"

#### COPYING CONFIG FILES ####

title "Installing dotfiles"

printf "%sCopying config files to the respective directories...%s\n\n" "${CYE}" "${CNC}"

[[ ! -d "$config_dir" ]] && mkdir -p "$config_dir"
[[ ! -d "$HOME/.local/bin" ]] && mkdir -p "$HOME/.local/bin"
[[ ! -d "$HOME/.local/share" ]] && mkdir -p "$HOME/.local/share"

for dirs in "$cwd/config"/*; do
  dir_name=$(basename "$dirs")
  # if the dirname is nvim and the try_nvim is not true, continue
  if [[ $dirname == "nvim" && $try_nvim == [Nn] ]]; then
    continue
  fi
  if cp -R "$dirs" "$config_dir"; then
    printf "%s%s%s %sconfig installed succesfully%s\n" "${BLD}" "${CYE}" "${dir_name}" "${CGR}" "${CNC}"
    sleep 1
  else
    printf "%s%s%s %sFailed to install configuration. See error log for more details.%s\n" "${BLD}" "${CRE}" "${dir_name}" "${CRE}" "${CNC}"
    sleep 1
  fi
done

if cp -r "$cwd/home/.tmux.conf" "$HOME/.tmux.conf"; then
  tmux source-file ~/.tmux.conf
  printf "%s%s.tmux.conf %sinstalled successfully%s\n" "${BLD}" "${CYE}" "${CGR}" "${CNC}"
  sleep 1
else
  printf "%s%s.tmux.conf failed to install. See error log for more details.%s\n" "${BLD}" "${CRE}" "${CNC}"
  sleep 1
fi

# copying wallpapers from cwd/wallpapers to pictures
printf "\n%sCopying wallpapers to %s%s directory...%s\n" "${CYE}" "${CBL}" "$HOME/Pictures" "${CNC}"
[[ ! -d "$HOME/Pictures" ]] && mkdir -p "$HOME/Pictures"
if cp -r "$cwd/wallpapers"/* "$HOME/Pictures"; then
  printf "%s%sWallpapers copied successfully.%s\n\n" "${BLD}" "${CGR}" "${CNC}"
  sleep 1
else
  printf "%s%sFailed to copy wallpapers. See error log for more details.%s\n\n" "${BLD}" "${CRE}" "${CNC}"
  sleep 1
fi

#### SHELL ####

if [[ $change_shell == [Yy] ]]; then
  title "Configuration shell"

  printf "%s%s\nInstalling oh-my-zsh...%s\n\n" "${BLD}" "${CYE}" "${CNC}"
  sleep 1 # sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" & wait if sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" & wait; then
  if sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" & wait; then
    printf "%s%s\noh-my-zsh successfully installed.%s\n\n" "${BLD}" "${CGR}" "${CNC}"
    sleep 1

    # powerlevel10k theme
    printf "%s%s\nInstalling powerlevel10k theme...%s\n\n" "${BLD}" "${CYE}" "${CNC}"
    sleep 1
    if git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k; then
      printf "%s%s\npowerlevel10k theme successfully installed.%s\n\n" "${BLD}" "${CGR}" "${CNC}"
      sleep 1
    else
      printf "%s%s\nError: Unable to install powerlevel10k theme.%s\n\n" "${BLD}" "${CRE}" "${CNC}"
      sleep 1
    fi
          
    # zsh-syntax-highlighting 
    printf "%s%s\nInstalling zsh-syntax-highlighting...%s\n\n" "${BLD}" "${CYE}" "${CNC}"
    sleep 1
    if git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting; then
      printf "%s%s\nzsh-syntax-highlighting successfully installed.%s\n\n" "${BLD}" "${CGR}" "${CNC}"
      sleep 1
    else
      printf "%s%s\nError: Unable to install zsh-syntax-highlighting.%s\n\n" "${BLD}" "${CRE}" "${CNC}"
      sleep 1
    fi

    # zsh-autosuggestions
    printf "%s%s\nInstalling zsh-autosuggestions...%s\n\n" "${BLD}" "${CYE}" "${CNC}"
    sleep 1
    if git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions; then
      printf "%s%s\nzsh-autosuggestions successfully installed.%s\n\n" "${BLD}" "${CGR}" "${CNC}"
      sleep 1
    else
      printf "%s%s\nError: Unable to install zsh-autosuggestions.%s\n\n" "${BLD}" "${CRE}" "${CNC}"
      sleep 1
    fi

  else
    printf "%s%s\nError: Unable to install oh-my-zsh...%s\n\n" "${BLD}" "${CRE}" "${CNC}"
  fi

  cp -r "$cwd/home/.zshrc" "$HOME/.zshrc"
  cp -r "$cwd/home/.p10k.zsh" "$HOME/.p10k.zsh"

  ## CHANGING THE DEFAULT SHELL TO ZSH ##
  if [[ $SHELL != "/bin/zsh" ]]; then
    printf "%s%s\nChanging your default shell to zsh. Enter your root password.%s\n" "${BLD}" "${CYE}" "${CNC}"
    sleep 1
    if chsh -s /bin/zsh; then
      printf "%s%s\nDefault shell changed to zsh...%s\n" "${BLD}" "${CGR}" "${CNC}"
      printf "%s%sLog out and log back in to see the changes...%s\n\n" "${BLD}" "${CGR}" "${CNC}"
      else
        printf "%s%s\nError: Unable to change the default shell to zsh...%s\n\n" "${BLD}" "${CRE}" "${CNC}"
      fi
    fi
fi
