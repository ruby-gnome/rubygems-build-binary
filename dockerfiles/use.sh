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
gem_install_options=()
# Gentoo Linux uses --install-dir by default. It's conflicted with
# --user-install.
if gem env | grep -q -- --install-dir; then
  :
else
  gem_install_options+=(--user-install)
fi
group_end

group_begin "Install"
gem install "${gem_install_options[@]}" rubygems-requirements-system
gem install "${gem_install_options[@]}" /host/cairo-*.gem
group_end

group_begin "Test"
ruby -r cairo -e 'p Cairo::VERSION'
group_end
