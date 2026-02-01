#!/bin/bash -l

set -eu

group_begin() {
  echo "::group::$1"
  set -x
}

group_end() {
  set +x
  echo "::endgroup::"
}

group_begin "Prepare"
rm -rf build
cp -r /host build
cd build
group_end

group_begin "Install"
if gem env | grep -q -- --user-install; then
  # Arch Linux
  rake install
elif gem env | grep -q -- --install-dir; then
  # Gentoo Linux
  rake install
elif sudo which rake; then
  sudo rake install
else
  rake install
fi
group_end

group_begin "Build"
gem fetch cairo
rm -rf source
mkdir -p source
mv cairo-*.gem source/
gem build_binary source/cairo-*.gem
sudo cp cairo-*.gem /host/
group_end
