bin/entrypoint:    git checkout nightlies;
DEVELOPER.md:  docker.io/containercraft/koffer:nightlies
DEVELOPER.md:  docker.io/containercraft/koffer:nightlies
DEVELOPER.md: git checkout nightlies
DEVELOPER.md:sudo podman rmi --force koffer:nightlies
README.md:  docker.io/containercraft/koffer:nightlies
vars/images.yml:    tag: nightlies
templates/pod/cloudctl.yml.j2:    image: quay.io/containercraft/one:nightlies
