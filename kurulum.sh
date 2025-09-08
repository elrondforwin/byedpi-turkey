#!/bin/bash

set -e

iss="diger"
DNS_NONE="/etc/NetworkManager/conf.d/90-dns-none.conf"

paket-yonetici-tanimla() {
if command -v pacman &> /dev/null; then
    paketyonetici="pacman -S"
    distro="arch tabanli"
  fi

if command -v dnf &> /dev/null; then
    paketyonetici="dnf install"
    distro="fedora tabanli"
  fi

if command -v apt &> /dev/null; then
    paketyonetici="apt install"
    if [[ $(grep "^ID_LIKE=" /etc/os-release) == "ubuntu debian" ]]; then
      distro="ubuntu tabanli"
    else
      distro="debian tabanli"
    fi
fi

if ! command -v pacman &> /dev/null && ! command -v dnf &> /dev/null && ! command -v apt &> /dev/null; then
    echo "desteklenen paket yoneticileri arasinda paket yoneticiniz yok"
    echo "desteklenenler:"
    echo "    pacman"
    echo "    dnf"
    echo "    apt"
    exit 1
fi

  echo "Tespit edilen distro tabani ${distro}"
  read -p "Bu dogru mu? (evet/hayir): " distrocevap

  distrocevap=$(echo "$distrocevap" | tr '[:upper:]' '[:lower:]')

  while [[ "$distrocevap" != "evet" && "$distrocevap" != "e" && "$distrocevap" != "hayir" && "$distrocevap" != "h" && "$distrocevap" != "hayır" ]]; do
    echo "Lutfen evet ya da hayir olarak cevaplayin (ya da e/h)."
    echo "Tespit edilen distro tabani ${distro}"
    read -p "Bu dogru mu? (evet/hayir): " distrocevap
    distrocevap=$(echo "$distrocevap" | tr '[:upper:]' '[:lower:]')
  done

  if [[ "$distrocevap" =~ ^(hayir|hayır|h)$ ]]; then
    echo
    echo
    echo "Lütfen manuel olarak dağıtım tabanınızı seçiniz."
    echo
    echo "1 - Arch Tabanlı (Arch, CachyOS, EndeavourOS, Manjaro vs.)"
    echo "2 - Fedora Tabanlı (Fedora, Nobara vs.)"
    echo "3 - Ubuntu Tabanlı (Ubuntu, Mint, Zorin vs.)"
    echo "4 - Debian Tabanlı (Debian vs.)"
    echo

    read -p "Dağıtımınızın hangi taban olduğunu seçiniz (1/2/3/4): " manuelcevap

    while [[ ! "$manuelcevap" =~ ^(1|2|3|4)$ ]]; do
      echo "Lütfen geçerli bir cevap giriniz (1, 2, 3 veya 4)."
      read -p "Dağıtımınızın hangi taban olduğunu seçiniz (1/2/3/4): " manuelcevap
    done

    if [[ "$manuelcevap" == "1" ]]; then
      paketyonetici="pacman -S"
      distro="arch tabanli"
    elif [[ "$manuelcevap" == "2" ]]; then
      paketyonetici="dnf install"
      distro="fedora tabanli"
    elif [[ "$manuelcevap" == "3" ]]; then
      paketyonetici="apt install"
      distro="ubuntu tabanli"
    elif [[ "$manuelcevap" == "4" ]]; then
      paketyonetici="apt install"
      distro="debian tabanli"
    fi

    echo "${distro} seçildi. Paket yükleme komutu: '${paketyonetici}' kullanılacak."
  else
    echo "Dağıtımınız ${distro} olarak belirlendi. Paket yükleme komutu: '${paketyonetici}' kullanılacak."
  fi  
}

ubuntu-check() {
    if [[ "$paketyonetici" == "apt install" ]]; then
        echo "Ubuntu destegi yapilan testler sonucunda kaldirilmistir. Ubuntu icin yeni bir script eklenecektir."
        exit 1
    fi
}

acikla() {
  echo "Bu kurulum sihirbazi dnscrypt-proxy ile beraber byedpictl kuracaktir. Betigi kullanmak tamamen sizin sorumlulugunuzdadir."
  echo
}

# zaten calismadigindan devre disi birakildi.
#
# iss-check() {
#   echo
#   read -p "Internet servis saglayiciniz superonline mi? (evet/hayir): " cevap
#   cevap=$(echo "$cevap" | tr '[:upper:]' '[:lower:]')

#   while [[ "$cevap" != "evet" && "$cevap" != "e" && "$cevap" != "hayir" && "$cevap" != "h" && "$cevap" != "hayır" ]]; do
#     echo "Lutfen evet ya da hayir olarak cevaplayin (ya da e/h)."
#     read -p "Internet servis saglayiciniz superonline mi? (evet/hayir): " cevap
#     cevap=$(echo "$cevap" | tr '[:upper:]' '[:lower:]')
#   done

#   if [[ "$cevap" =~ ^(evet|e)$ ]]; then
#     iss="superonline"
#     echo "kullanici superonline kullaniyor"
#   elif [[ "$cevap" =~ ^(hayir|hayır|h)$ ]]; then
#     iss="diger"
#     echo "kullanici superonline kullanmiyor"
#   fi
# }

dnscrypt-check() {
  while ! command -v dnscrypt-proxy &> /dev/null; do
    echo "Sistemde dnscrypt-proxy tespit edilemedi. Paket yoneticinizle kurulum yapiliyor."
    echo "Lutfen sudo sifresi istenirse girin."
    echo ""
    sudo ${paketyonetici} dnscrypt-proxy
    sleep 2
    echo "dnscrypt-proxy tekrar kontrol ediliyor..."
    if command -v dnscrypt-proxy &> /dev/null; then
      echo "Kontrol basarili. Devam ediliyor."
    else
      echo "Kontrol basarisiz. Tekrar deneniyor..."
    fi
  done

  if command -v dnscrypt-proxy &> /dev/null; then
    echo "dnscrypt-proxy tespit edildi. Devam ediliyor."
  else
    echo "dnscrypt kurulumunda bir sorun var gibi gorunuyor..."
    exit 1
  fi
}

zenity-check() {
  while ! command -v zenity &> /dev/null; do
    echo "Sistemde zenity tespit edilemedi. Paket yoneticinizle kurulum yapiliyor."
    echo "Lutfen sudo sifresi istenirse girin."
    echo ""
    sudo ${paketyonetici} zenity
    if command -v zenity &> /dev/null; then
      echo "Kontrol basarili. Devam ediliyor."
    else
      echo "Kontrol basarisiz. Tekrar deneniyor..."
    fi
  done

  if command -v zenity &> /dev/null; then
    echo "zenity tespit edildi. Devam ediliyor."
  else
    echo "zenity kurulumunda bir sorun var gibi gorunuyor..."
    exit 1
  fi
}

dns-none() {
  echo "networkmanager dns-none ayarlaniyor..."
  echo "Lutfen sudo sifresi istenirse girin."

  echo "Dosya yaziliyor: $DNS_NONE"
  sudo tee "$DNS_NONE" >/dev/null <<'EOF'
[main]
dns=none
EOF
}

resolv-conf() {
  echo "resolv.conf dosyasi guncelleniyor..."
  echo "UYARI: mevcut resolv.conf dosyasinin uzerine yazilacaktir. Orijinal resolv.conf yedekleniyor..."

  sudo cp /etc/resolv.conf /etc/resolv.conf.bak
  sudo cp configs/resolv.conf /etc/resolv.conf
}

dnscrypt-config() {
  echo "dnscrypt-proxy configi kuruluyor..."

  if [[ $distro =~ ^("arch tabanli"|"fedora tabanli")$ ]]; then
    sudo cp configs/dnscrypt-proxy.toml /etc/dnscrypt-proxy/dnscrypt-proxy.toml
  elif [[ $distro =~ ^("ubuntu tabanli")$ ]]; then
    echo "ubuntu icin config kuruluyor..."
    sudo cp configs/dnscrypt-proxy-ubuntu.toml /etc/dnscrypt-proxy/dnscrypt-proxy.toml
  fi

  echo "Servisler baslatiliyor."
  sudo systemctl enable dnscrypt-proxy.service
  sudo systemctl start dnscrypt-proxy.service
}

systemd-service() {
  if [[ $(ps -p 1 -o comm=) == "systemd" ]]; then
      echo "systemd kullaniliyor."
      echo "systemd servisi kuruluyor..."
      sudo cp configs/byedpi-start.service /etc/systemd/system/byedpi-start.service
      sleep 1
      sudo systemctl daemon-reload
      sleep 2
      sudo systemctl enable byedpi-start.service
      sudo systemctl start byedpi-start.service
      echo
      echo "sistemin basinda acilmasini saglayan systemd servisini 'sudo systemctl enable/disable byedpi-start' yazarak kontrol edebilirsiniz"
  else
      echo "systemd kullanilmiyor. servis es geciliyor."
  fi
}

dns-degis() {
  if command -v nmcli &> /dev/null; then
    aktif_ag=$(nmcli -t -f NAME connection show --active | head -n1)
    if [ -z "$aktif_ag" ]; then
        echo "aktif ag bulunamadi..."
    else
    if [[ $distro = "ubuntu tabanli" ]]; then
      nmcli connection modify "$aktif_ag" ipv4.dns "127.0.2.1"
      echo "ubuntu kullandiginiz icin ${aktif_ag} aginin dns'i 127.0.2.1 olarak ayarlandi."
    else
      nmcli connection modify "$aktif_ag" ipv4.dns "127.0.0.1"
      echo "${aktif_ag} aginin dns'i 127.0.0.1 olarak ayarlandi."
    fi
      nmcli connection modify "$aktif_ag" ipv4.ignore-auto-dns yes
      echo "network yeniden baslatiliyor..."
      nmcli connection down "$aktif_ag" 2>/dev/null
      sleep 1
      nmcli connection up "$aktif_ag"
    fi
  else
    echo "networkmanager bulunamadi. dns ayari otomatik olarak yapilamiyor. lutfen manuel bir sekilde dns'inizi 127.0.0.1 olarak ayarlayin."
  fi
}

byedpi-setup() {
  echo "byedpi kurulumuna geciliyor..."

  if [ "$iss" = "superonline" ]; then
    echo "byedpictl superonline kurulum scripti calistiriliyor..."
    sudo bash make-superonline.sh install
  elif [ "$iss" = "diger" ]; then
    echo "byedpictl kurulum scripti calistiriliyor..."
    sudo bash make.sh install
  fi
}

byedpi-aktiflestir() {
  if command -v byedpictl &> /dev/null; then
    echo "byedpictl otomatik olarak baslatiliyor..."
    sudo byedpictl tun start
  else
    echo "byedpictl bulunamadi..."
  fi
}

acikla
paket-yonetici-tanimla
# ubuntu-check
# iss-check
dnscrypt-check
zenity-check
dns-none
resolv-conf
dnscrypt-config
byedpi-setup
dns-degis
systemd-service
byedpi-aktiflestir

echo "ByeDPI kuruldu. Sisteminizden byedpictl uygulamasini acarak ilk seferde aktiflestirebilirsiniz."
if [[ -f /etc/systemd/system/byedpi-start.service ]]; then
  echo "ONEMLI: Sisteminiz yeniden basladiginda byedpictl otomatik olarak aktiflestirilecektir. Bunu devre disi birakmak istiyorsaniz 'sudo systemctl disable byedpi-start' yazin."
fi
