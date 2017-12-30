#!/bin/bash

#LocalVariable
declare -a installable=("BRO" "PIVX")


function red {
        echo -e "$(tput bold; tput setaf 1)$1$(tput sgr0)"
}

function igreen {
    echo -e "$(tput bold; tput setaf 0; tput setab 2)$1$(tput sgr0)"
}

function ired {
    echo -e "$(tput bold; tput setaf 3; tput setab 1)$1$(tput sgr0)"
}

function green {
    echo -e "$(tput bold; tput setaf 2)$1$(tput sgr0)"
}

function yellow {
    echo -e "$(tput bold; tput setaf 3)$1$(tput sgr0)"
}

function asciiart() {
clear
tput bold; tput setaf 1
cat << "EOF"
  __  __           _____ _______ ______ _____  _   _  ____  _____  ______ 
 |  \/  |   /\    / ____|__   __|  ____|  __ \| \ | |/ __ \|  __ \|  ____|
 | \  / |  /  \  | (___    | |  | |__  | |__) |  \| | |  | | |  | | |__   
 | |\/| | / /\ \  \___ \   | |  |  __| |  _  /| . ` | |  | | |  | |  __|  
 | |  | |/ ____ \ ____) |  | |  | |____| | \ \| |\  | |__| | |__| | |____ 
 |_|  |_/_/__ _\_\_____/__ |_| _|______|_| _\_\_|_\_|\____/|_____/|______|
       / ____/ __ \|  \/  |  \/  |   /\   | \ | |  __ \|  ____|  __ \     
      | |   | |  | | \  / | \  / |  /  \  |  \| | |  | | |__  | |__) |    
      | |   | |  | | |\/| | |\/| | / /\ \ | . ` | |  | |  __| |  _  /     
      | |___| |__| | |  | | |  | |/ ____ \| |\  | |__| | |____| | \ \     
       \_____\____/|_|  |_|_|  |_/_/    \_\_| \_|_____/|______|_|  \_\ 

                                                 @chubja glaxer95@gmail.com

EOF
tput sgr0
}

function menu() {
  asciiart
  show_option
  read_option
}

function one() {
  asciiart
  show_installable
  read_installable  
}

function two() {
  asciiart
  show_selectable
  read_selectable
}

function run() {
  asciiart  
  crypto=$1
  show_runcmd $crypto
  read_runcmd $crypto
}




function cmd_install() {
  crypto=$1
  source ./${crypto}_qtbuild/${crypto}.sh
  
  ${crypto}_install

  read -p " Press [Enter] To Exit ..."

  run ${crypto}
}

function cmd_update() {
  crypto=$1

  pushd ./${crypto}_qtbuild/
    git pull
  popd

  read -p " Press [Enter] To Exit ..."
  
  run ${crypto}  
}


function show_runcmd() {
  crypto=${1^}
  tput bold; tput setaf 3
  echo "                        ---------------------" 
  echo "                              ${crypto}" 
  echo "                        ---------------------"  
  echo
  echo "                        1) Install ${crypto}"
  echo "                        2) Edit Conf"
  echo "                        3) Start ${crypto}"  
  echo "                        4) Kill ${crypto}"  
  echo "                        5) Update ${crypto}"
  echo "                        0) Exit"
  tput sgr0
}

function read_runcmd() {
    crypto=${1,,}
    local choice
    read -p "                        Enter choice [1 2]: " choice
    case $choice in
        0) two;;
        1) cmd_install $crypto;;
        *) echo -e "$(red "             Incorrect option!")" && sleep 1
        cmd $crypto
    esac  
}


function show_selectable() {
  tput bold; tput setaf 3
  for c in "${installable[@]}"
  do
    DIRECTORY=${c,,}_qtbuild
    if [ -d "$DIRECTORY" ]; then
      echo "                        * $c"
    fi
  done
  echo "                        0) Exit"
  tput sgr0  
}

function read_selectable() {
    local choice
    read -p "                        Enter Crypto [BRO..0] : " choice
    case $choice in
      0) menu ;;
    esac
    if [ ! $choice ]; then 
      menu
    else
      run $choice
    fi
}

function install_components() {
  crypto=${1,,}
  gitaddr="https://github.com/MinseokOh/${crypto}_qtbuild.git"
  git clone $gitaddr
  read -p " Press [Enter] To Exit : "

  one
}

#OPTIONS

function show_installable() {
  tput bold; tput setaf 3
  for c in "${installable[@]}"
  do
    DIRECTORY=${c,,}_qtbuild
    if [ ! -d "$DIRECTORY" ]; then
      echo "                        * $c"
    fi
  done
  echo "                        0) Exit"
  tput sgr0
}

function read_installable() {
    local choice
    read -p "                        Enter Crypto [BRO..0] : " choice
    case $choice in
      0) menu ;;
    esac
    if [ ! $choice ]; then 
      menu
    else
      install_components $choice
    fi

}

function show_option() {
  tput bold; tput setaf 3
  echo "                        ---------------------" 
  echo "                               OPTIONS       " 
  echo "                        ---------------------"  
  echo
  echo "                        1) Install Components"
  echo "                        2) Select  Components"
  echo "                        0) Exit"
  tput sgr0
}

function read_option() {
    local choice
    read -p "                        Enter choice [1 2]: " choice
    case $choice in
        1) one ;;
        2) two ;;
        0) exit 0;;
        *) echo -e "$(red "             Incorrect option!")" && sleep 1
    esac
}


menu
