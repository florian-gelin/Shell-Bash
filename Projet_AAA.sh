#!/bin/bash

declare -A count
extensions=("txt" "py" "pdf" "jpg" "html" "css" "js" "png")

get_timestamp() {
    date +"%d/%m/%Y à %H:%M:%S"
}

get_cpu_infos() {
    cores_count=$(nproc)
    cores_freq=$(lscpu | awk -F: '/CPU MHz/ {print $2}' | xargs)
    cores_usage_percentage=$(top -bn1 | grep "Cpu(s)" | awk '{print 100 - $8}')
}

get_memory_infos() {
    total_memory=$(free -m | awk '/Mem:/ {printf "%.2f", $2/1024}')
    used_memory=$(free -m | awk '/Mem:/ {printf "%.2f", $3/1024}')
    memory_usage_percentage=$(free | awk '/Mem:/ {printf "%.1f", $3/$2*100}')
}

get_system_infos() {
    machine_name=$(hostname)
    os_name=$(uname -s)
    os_version=$(uname -r)
    boot_time=$(who -b | awk '{print $3" "$4}')
    uptime=$(uptime -p | sed 's/up //')
    ip_adress=$(hostname -I | awk '{print $1}')
    users=$(who | wc -l)
}

analyze_files() {
    folder="$1"
    total_files=$(find "$folder" -type f 2>/dev/null | wc -l)

    for ext in "${extensions[@]}"; do
        count[$ext]=$(find "$folder" -type f -iname "*.$ext" 2>/dev/null | wc -l)
    done

    if [[ $total_files -eq 0 ]]; then
        percentage_txt=0
        percentage_py=0
        percentage_pdf=0
        percentage_jpg=0
        percentage_html=0
        percentage_css=0
        percentage_js=0
        percentage_png=0
        return
    fi

    percentage_txt=$(awk 'BEGIN {printf "%.2f", ('"${count["txt"]}"'/'"$total_files"')*100}')
    percentage_py=$(awk 'BEGIN {printf "%.2f", ('"${count["py"]}"'/'"$total_files"')*100}')
    percentage_pdf=$(awk 'BEGIN {printf "%.2f", ('"${count["pdf"]}"'/'"$total_files"')*100}')
    percentage_jpg=$(awk 'BEGIN {printf "%.2f", ('"${count["jpg"]}"'/'"$total_files"')*100}')
    percentage_html=$(awk 'BEGIN {printf "%.2f", ('"${count["html"]}"'/'"$total_files"')*100}')
    percentage_css=$(awk 'BEGIN {printf "%.2f", ('"${count["css"]}"'/'"$total_files"')*100}')
    percentage_js=$(awk 'BEGIN {printf "%.2f", ('"${count["js"]}"'/'"$total_files"')*100}')
    percentage_png=$(awk 'BEGIN {printf "%.2f", ('"${count["png"]}"'/'"$total_files"')*100}')
}

get_process_infos() {
    cpu_processus=$(ps -eo pid,comm,%cpu --sort=-%cpu | head -n 10)
    memory_processus=$(ps -eo pid,comm,%mem --sort=-%mem | head -n 10)
    process_1=$(echo "$cpu_processus" | sed -n '2p')
    process_2=$(echo "$cpu_processus" | sed -n '3p')
    process_3=$(echo "$cpu_processus" | sed -n '4p')
}

display_all() {
    clear
    echo "===== MONITORING SYSTEME ====="
    echo "Date : $timestamp"
    echo "Machine : $machine_name"
    echo "OS : $os_name $os_version"
    echo "IP : $ip_adress"
    echo "Utilisateurs connectés : $users"
    echo "Démarré le : $boot_time"
    echo "Uptime : $uptime"
    echo
    echo "===== CPU ====="
    echo "Cœurs : $cores_count"
    echo "Fréquence : $cores_freq MHz"
    echo "Utilisation : $cores_usage_percentage %"
    echo "$process_1"
    echo "$process_2"
    echo "$process_3"
    echo
    echo "===== MEMOIRE ====="
    echo "Utilisée : $used_memory Go"
    echo "Totale : $total_memory Go"
    echo "Pourcentage : $memory_usage_percentage %"
    echo
    echo "===== ANALYSE FICHIERS ====="
    echo "Dossier : $folder"
    echo "Total fichiers : $total_files"
    echo "txt : ${count["txt"]} (${percentage_txt}%)"
    echo "py : ${count["py"]} (${percentage_py}%)"
    echo "pdf : ${count["pdf"]} (${percentage_pdf}%)"
    echo "jpg : ${count["jpg"]} (${percentage_jpg}%)"
    echo "html : ${count["html"]} (${percentage_html}%)"
    echo "css : ${count["css"]} (${percentage_css}%)"
    echo "js : ${count["js"]} (${percentage_js}%)"
    echo "png : ${count["png"]} (${percentage_png}%)"
    echo
    echo "===== PROCESSUS CPU ====="
    echo "$cpu_processus"
    echo
    echo "===== PROCESSUS MEMOIRE ====="
    echo "$memory_processus"
}

main() {
    while true; do
        timestamp=$(get_timestamp)
        get_cpu_infos
        get_memory_infos
        get_system_infos
        folder="$HOME/Documents"
        analyze_files "$folder"
        get_process_infos
        display_all
        sleep 5
    done
}

main
