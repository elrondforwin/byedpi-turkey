# byedpi-turkey

> [!WARNING]
> ``ubuntu`` branch'ı gelecek Ubuntu güncellemeleri içindir. Şuanda kullanıma hazır değil ve tamamen geliştirme amacıyla var. Bu branch'teki yeni betik Ubuntu'ya uygun şekilde ``DNSCrypt-Proxy``'i konfigüre edip gerekli ayarları NetworkManager'a otomatik olarak uygulanmasını sağlayacak.

Linux için kullanıcı dostu **GoodbyeDPI-Turkey alternatifi**.

Arkaplanda aşağıdaki araçları kullanır:

* [dnscrypt-proxy](https://github.com/DNSCrypt/dnscrypt-proxy)
* [byedpictl](https://github.com/maximilionus/byedpictl)
* [byedpi](https://github.com/hufrea/byedpi)
* [hev-socks5-tunnel](https://github.com/heiher/hev-socks5-tunnel)

---

### 🐧 **Test Edilen Ortamlar**  
| Ortam       | Durum                          |
|-------------|--------------------------------|
| Fedora      | Çalışıyor ✅                   |
| Arch Linux  | Çalışıyor ✅                   |
| Ubuntu      | Çalışmıyor ❌, Destek eklenecek |

### 📡 **Test Edilen ISS'ler**  
| Sağlayıcı    | Durum       |
|--------------|-------------|
| Türk Telekom | Çalışıyor ✅|
| SuperOnline  | Çalışıyor ✅|

---

## ⚠️ Yasal Uyarı

Bu uygulamanın kullanımından doğan her türlü yasal sorumluluk kullanan kişiye aittir. Uygulama yalnızca eğitim ve araştırma amaçları ile yazılmış ve düzenlenmiş olup; bu uygulamayı bu şartlar altında kullanmak ya da kullanmamak kullanıcının kendi seçimidir. Açık kaynak kodlarının paylaşıldığı bu platformdaki düzenlenmiş bu proje, bilgi paylaşımı ve kodlama eğitimi amaçları ile yazılmış ve düzenlenmiştir.

---

## 📌 Notlar

* **Ubuntu/Debian desteği (6 Eylül itibariyle) kaldırılmıştır.**
  Bunun sebebi, `dnscrypt-proxy`’nin apt ile gelen sürümünün Fedora ve Arch'a kıyasla farklı çalışmasıdır.
* Her türlü **Pull Request**’e açığım.

---

## 🚀 Kurulum
GitHub üzerinden repo'yu uygun konuma klonlayın.
```bash
curl -fsSL https://raw.githubusercontent.com/elrondforwin/byedpi-turkey/refs/heads/master/curl.sh | bash
```
Kurulum betiğini çalıştırın.
```bash
cd ~/.local/share/byedpi-turkey && ./kurulum.sh
```

---

## 🗑️ Kaldırma
Daha önce klonlanmış konumdan ``kaldir.sh`` betiğini çalıştırın.
```bash
bash ~/.local/share/byedpi-turkey/kaldir.sh
```

Eğer kaldırma scripti çalışmazsa:

```bash
cd ~/.local/share/byedpi-turkey
sudo ./make.sh remove
```

---

## ❓ Sık Karşılaşılan Sorunlar

| Sorun | Çözüm |
| --- | --- |
| Byedpictl grafik arayüzü açılmıyor. | `zenity` paketini kurun. Örn: `sudo dnf install zenity`. |
| İnternet bağlantısı gidiyor. | `byedpictl` üzerinden yeniden başlatın. Gerekirse `sudo byedpictl tun status` ile durumu kontrol edin. |
| Sistem uyku modundan dönünce tünel bozuluyor. | Uygulama üzerinden yeniden başlatın. |

---

## 🖥️ Komut Satırı Kullanımı

`byedpictl` komutlarının tamamını kullanabilirsiniz:

```bash
byedpictl help
byedpictl tun start
byedpictl tun stop
byedpictl tun restart
byedpictl tun status

byedpictl zenity   # grafik arayüzü açar
```

---

## Katkılar ve İlham

* [Kurulum rehberi](https://www.youtube.com/watch?v=i5RUTG67aoM) – yöntemi öğrenmemi sağladı.
* [GoodbyeDPI-Turkey](https://github.com/cagritaskn/GoodbyeDPI-Turkey) – ilham kaynağı.
* [byedpictl](https://github.com/maximilionus/byedpictl) – orijinal proje.
  
