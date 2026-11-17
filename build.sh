#!/bin/bash
# Gera a ISO do Jukebox. Rode num Debian (PC ou máquina virtual) COM INTERNET:
#   sudo ./build.sh            (usa Debian 13 "trixie")
#   sudo ./build.sh bookworm   (usa Debian 12, se o seu Debian for mais antigo)
set -e
cd "$(dirname "$0")"
if [ "$(id -u)" -ne 0 ]; then echo "Rode com sudo:  sudo ./build.sh"; exit 1; fi
export DIST="${1:-trixie}"
echo ">> Instalando as ferramentas para montar a ISO..."
apt-get update
apt-get install -y --install-recommends live-build debootstrap squashfs-tools xorriso \
  mtools dosfstools syslinux syslinux-utils syslinux-common isolinux \
  grub-pc-bin grub-efi-amd64-bin grub-common
chmod +x auto/* config/hooks/live/*.chroot config/includes.chroot/usr/local/bin/* \
  config/includes.chroot/etc/skel/.xinitrc 2>/dev/null || true
echo ">> Montando a ISO ($DIST). Isso demora (20 a 60 minutos) e baixa 1 a 2 GB..."
lb clean --purge || true
lb config
lb build
ISO="$(ls -1 *.iso 2>/dev/null | head -n1)"
if [ -z "$ISO" ]; then echo "ERRO: a ISO não foi criada. Veja o arquivo build.log"; exit 1; fi
mv "$ISO" jukebox.iso
echo
echo "PRONTO!  Arquivo: $(pwd)/jukebox.iso"
