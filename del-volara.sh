#!/bin/bash

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

# Eksekusi fungsi
stop_containers_by_keyword
remove_containers_by_keyword
remove_images_by_keyword
cleanup_docker

show_message "✨ Semua proses selesai."