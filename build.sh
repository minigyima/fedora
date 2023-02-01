#!/bin/bash

echo "=====INSTALLING DEPENDENCIES====="
dnf install -y koji fedora-packager git curl pesign rpmdevtools rpm-sign rpm-build

echo "=====IMPORTING KEYS====="
gpg --import /repo/rpm_signing_key
rpm --import /repo/repo/t2linux-fedora.pub
rm -rfv /repo/rpm_signing_key
echo -e "%_signature gpg\n%_gpg_name T2Linux Fedora" > ~/.rpmmacros

echo "=====BUILDING====="
rpmdev-setuptree
/repo/package-scripts/build-kernel.sh
/repo/package-scripts/build-blivet.sh
/repo/package-scripts/build-dist.sh
rpm --addsign /root/rpmbuild/RPMS/x86_64/*.rpm

# Copy artifacts to shared volume
cd "/repo"
mkdir -p ./output
mkdir -p ./output/RPMS
cp -rfv /root/rpmbuild/RPMS/* ./output/RPMS/
