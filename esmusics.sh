#!/usr/bin/env bash

# This file is part of the microplay-hub
# Designs by Liontek1985
# for RetroPie and offshoot
#
# The RetroPie Project is the legal property of its developers, whose names are
# too numerous to list here. Please refer to the COPYRIGHT.md file distributed with this source.
#
# See the LICENSE.md file at the top-level directory of this distribution and
# at https://raw.githubusercontent.com/RetroPie/RetroPie-Setup/master/LICENSE.md
#
# es-musics v1.2 - 2023-11-22

rp_module_id="es-musics"
rp_module_desc="Music-Sets for Emulationstation"
rp_module_repo="git https://github.com/microplay-hub/es-musics.git master"
rp_module_section="main"
rp_module_flags="noinstclean"

function depends_es-musics() {
    local depends=(cmake)
     getDepends "${depends[@]}"
}


function sources_es-musics() {
    if [[ -d "$md_inst" ]]; then
        git -C "$md_inst" reset --hard  # ensure that no local changes exist
    fi
    gitPullOrClone "$md_inst"
}

function install_es-musics() {

    local esmdir="$datadir"	
    local esmsetup="$scriptdir/scriptmodules/supplementary"

    mkdir "$datadir/musics"
    ln -s "$datadir/musics" "$datadir/music"
    chown -cR pi:pi "$datadir/music"
    chown -cR pi:pi "$datadir/musics"
    chmod 755 "$datadir/music"
    chmod 755 "$datadir/musics"
 
    cd "$md_inst"
	
#	cp -r "esmusics.sh" "$esmsetup/esmusics.sh"
    chown -R $user:$user "$esmdir/musics"	
    chown -R $user:$user "$esmsetup/esmusics.sh"
	chmod 755 "$esmsetup/esmusics.sh"
	chmod 755 "$esmdir/musics"
	rm -r "esmusics.sh"
	
    if [[ ! -f "$configdir/all/$md_id.cfg" ]]; then
        iniConfig "=" '"' "$configdir/all/$md_id.cfg"
        iniSet "ESMCHANGE" "not-installed"		
    fi
    chown $user:$user "$configdir/all/$md_id.cfg"
	chmod 755 "$configdir/all/$md_id.cfg"
	
}


function cleaning_es-musics() {
	local esmdir="$datadir"	
	rm -r "$esmdir/musics/"	
    iniSet "ESMCHANGE" "not-installed"
}


function remove_es-musics() {
	local esmdir="$datadir"
	
	rm -r "$esmdir/musics/"	
	rm -rf "$md_inst"
    rm -r "$configdir/all/$md_id.cfg"	
}

function configesm_es-musics() {
	chown $user:$user "$configdir/all/$md_id.cfg"	
    iniConfig "=" '"' "$configdir/all/$md_id.cfg"	
}

function changestatus_es-musics() {

	local esmdir="$datadir"

    options=(
		M1 "MPCORE Music-Set [choose]"
		XX "[current setting: $esmchange]"
    )
    local cmd=(dialog --backtitle "$__backtitle" --menu "Choose an option." 22 86 16)
    local choice=$("${cmd[@]}" "${options[@]}" 2>&1 >/dev/tty)

    case "$choice" in
        M1)
			rm -r "$esmdir/musics/"
			cd "$md_inst"
 			cp -rf "mpcore/." "$esmdir/musics"
			chown -R $user:$user "$esmdir/musics"
			chmod -R 755 "$esmdir/musics"
			iniSet "ESMCHANGE" "MPCORE"
			printMsgs "dialog" "MPCORE Music-Set installed."
                ;;
    esac
}

function gui_es-musics() {

    local cmd=(dialog --default-item "$default" --backtitle "$__backtitle" --menu "Choose an option" 22 76 16)
	
        iniConfig "=" '"' "$configdir/all/$md_id.cfg"
		
        iniGet "ESMCHANGE"
        local esmchange=${ini_value}
	
    local options=(
    )
        options+=(	
            CA "EmulationStation Music-Set (change me)"
            CZ "Cleaning installed Music-Set"
            XX "[current setting: $esmchange]"
            TEK "### Script by Liontek1985 ###"
        )
		
        local choice=$("${cmd[@]}" "${options[@]}" 2>&1 >/dev/tty)
		
        iniConfig "=" '"' "$configdir/all/$md_id.cfg"
		
        iniGet "ESMCHANGE"
        local esmchange=${ini_value}
		
    if [[ -n "$choice" ]]; then
        case "$choice" in
            CA)
				configesm_es-musics
				changestatus_es-musics
                ;;
            CZ)
				configesm_es-musics
				cleaning_es-musics
                ;;
            XX)
				configesm_es-musics
				changestatus_es-musics
                ;;				
        esac
    fi
}
