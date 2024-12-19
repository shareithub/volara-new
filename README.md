Jika anda pengguna testnet. hapus dulu docker testnetnya dengan menggunakan script ini
del-volara.sh


Jika sudah. kalian tinggal menggunakan script dibawah ini untuk menajalan node volara mainnet :
[ -f "volara.sh" ] && rm volara.sh; curl -s -o volara.sh https://raw.githubusercontent.com/volaradlp/minercli/refs/heads/main/run_docker.sh && chmod +x volara.sh && ./volara.sh
