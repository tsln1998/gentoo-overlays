sync-all:
    just sync dev-util/asdf-vm
    just sync dev-util/vfox
    just sync dev-util/vfox-bin
    just sync dev-util/pack-cli
    just sync dev-util/pack-cli-bin
    just sync app-admin/chezmoi
    just sync app-admin/chezmoi-bin

sync pkg:
    rsync --delete -a ./{{pkg}}/ ../gentoo-zh/{{pkg}}