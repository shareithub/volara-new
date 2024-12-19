#!/bin/bash

# ASCII Art
echo -e "\n   _____ __  _____    ____  ______   __________   __  ____  ______ "
echo -e "  / ___// / / /   |  / __ \/ ____/  /  _/_  __/  / / / / / / / __ )"
echo -e "  \__ \/ /_/ / /| | / /_/ / __/     / /  / /    / /_/ / / / / __  |"
echo -e " ___/ / __  / ___ |/ _, _/ /___   _/ /  / /    / __  / /_/ / /_/ / "
echo -e "/____/_/ /_/_/  |_/_/ |_/_____/  /___/ /_/    /_/ /_/\____/_____/  "
echo -e "                                                                    \n"

# Keyword untuk mendeteksi container dan image yang berkaitan
KEYWORD="volara"
SPECIFIC_IMAGE="volara/miner"

# Fungsi untuk menampilkan pesan
show_message() {
    echo -e "\033[1;35m$1\033[0m"
}

# Hentikan container yang mengandung keyword
stop_containers_by_keyword() {
    local containers=$(sudo docker ps --format '{{.Names}}' | grep "$KEYWORD")
    if [[ -n "$containers" ]]; then
        for container in $containers; do
            show_message "🛑 Menghentikan container $container..."
            sudo docker stop $container
        done
    else
        show_message "✅ Tidak ada container dengan keyword '$KEYWORD' yang berjalan."
    fi
}

# Hapus container yang mengandung keyword
remove_containers_by_keyword() {
    local containers=$(sudo docker ps -a --format '{{.Names}}' | grep "$KEYWORD")
    if [[ -n "$containers" ]]; then
        for container in $containers; do
            show_message "🗑️ Menghapus container $container..."
            sudo docker rm $container
        done
    else
        show_message "✅ Tidak ada container dengan keyword '$KEYWORD' yang ditemukan."
    fi
}

# Hapus image Docker yang mengandung keyword
remove_images_by_keyword() {
    local images=$(sudo docker images --format '{{.Repository}}:{{.Tag}}' | grep "$KEYWORD")
    if [[ -n "$images" ]]; then
        for image in $images; do
            show_message "🗑️ Menghapus image $image..."
            sudo docker rmi -f $image
        done
    else
        show_message "✅ Tidak ada image dengan keyword '$KEYWORD' yang ditemukan."
    fi

    # Hapus semua image spesifik tanpa memandang tag
    local specific_images=$(sudo docker images --format '{{.Repository}}:{{.Tag}}' | grep "$SPECIFIC_IMAGE")
    if [[ -n "$specific_images" ]]; then
        for image in $specific_images; do
            show_message "🗑️ Menghapus image spesifik $image..."
            sudo docker rmi -f $image
        done
    else
        show_message "✅ Image spesifik $SPECIFIC_IMAGE tidak ditemukan."
    fi
}

# Bersihkan semua data Docker yang tidak digunakan (opsional)
cleanup_docker() {
    read -p "Apakah Anda ingin membersihkan semua data Docker yang tidak digunakan? (y/n): " CONFIRM
    if [[ "$CONFIRM" == "y" || "$CONFIRM" == "Y" ]]; then
        show_message "🧹 Membersihkan data Docker yang tidak digunakan..."
        sudo docker system prune -a -f
    else
        show_message "❌ Membersihkan data Docker dibatalkan."
    fi
}

# Fungsi untuk menjalankan script dari URL dengan sudo
download_and_run_script() {
    local url="https://raw.githubusercontent.com/shareithub/volara-new/refs/heads/main/del-volara.sh"
    show_message "📥 Mendownload dan menjalankan script dari $url..."
    curl -sSL $url | sudo bash
    show_message "✅ Script dari URL telah dijalankan."
}

# Fungsi untuk menjalankan perintah tambahan setelah penghapusan selesai
run_additional_script() {
    show_message "🚀 Menjalankan script tambahan untuk volara.sh..."
    [ -f "volara.sh" ] && rm volara.sh
    curl -s -o volara.sh https://raw.githubusercontent.com/volaradlp/minercli/refs/heads/main/run_docker.sh
    chmod +x volara.sh
    ./volara.sh
    show_message "✅ Script volara.sh telah dijalankan."
}

# Eksekusi fungsi
stop_containers_by_keyword
remove_containers_by_keyword
remove_images_by_keyword
cleanup_docker
download_and_run_script
run_additional_script

show_message "✨ Semua proses selesai."
