# byedpi-turkey

> [!NOTE]
> Proje hala çalışsa da [Keift Zapret](https://github.com/keift/zapret), [Zapret GTK](https://github.com/Taygun86/zapret-gtk) ve [gecit](https://github.com/boratanrikulu/gecit
) gibi projelerin yanında eksikleri ve bugları olan, üçü arasından en son tercih edilmesi gereken seçenek.


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
| Ubuntu      | Çalışmıyor ❌ |

### 📡 **Test Edilen ISS'ler**  
| Sağlayıcı    | Profil       | Durum |
|--------------|-------------|--------------|
| Türk Telekom | ``varsayilan-profil`` | Çalışıyor ✅
| Türk Telekom | ``turk-telekom`` | Çalışıyor ✅, En sorunsuzu bu
| Türk Telekom | ``varsayilan2`` | Çalışıyor ✅
| SuperOnline  | ``varsayilan-profil`` | Çalışıyor ✅
| SuperOnline  | ``turk-telekom`` | Çalışmıyor  ⚠️
| SuperOnline  | ``varsayilan2`` | Çalışıyor ✅

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
| Kurulum başarılı ancak çalışmıyor. | Bunun birden fazla sebebi olabilir, en yaygın problem NetworkManager kullanılmaması oluyor. Omarchy gibi bazı hazır Arch kurulumlarında NetworkManager yerine ``systemd-networkd`` kullanılıyor, bu durumda elinizle NetworkManager kurup aktifleştirmeniz ya da ``systemd-resolved`` kullanarak DNS'inizi ``127.0.0.1`` olarak ayarlamanız beklenir. Nasıl yapacağınızı bilmiyorsanız issue açarak yardım alabilirsiniz. |

---

## 🖥️ Komut Satırı Kullanımı

`byedpictl` komutlarının tamamını kullanabilirsiniz:

```bash
byedpictl help
byedpictl tun start
byedpictl tun stop
byedpictl tun restart
byedpictl tun change [profil-ismi] # profil değiştirir
byedpictl tun status

byedpictl zenity   # grafik arayüzü açar
```

## Yeni Profil Ekleme

Yeni profiller eklemek için `/etc/byedpictl/profiles/` dizinine `.conf` uzantılı dosyalar ekleyebilirsiniz. Her profil dosyası aşağıdaki formatta olmalıdır:

```bash
CIADPI_DESYNC=(
    "--param1=value1" "--param2=value2" #...
)
```

---

## Katkılar ve İlham

* [Kurulum rehberi](https://www.youtube.com/watch?v=i5RUTG67aoM) – yöntemi öğrenmemi sağladı.
* [GoodbyeDPI-Turkey](https://github.com/cagritaskn/GoodbyeDPI-Turkey) – ilham kaynağı.
* [byedpictl](https://github.com/maximilionus/byedpictl) – orijinal proje.
  
