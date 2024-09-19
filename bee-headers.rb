# SPDX-License-Identifier: GPL-2.0-only
class BeeHeaders < Formula
  desc "Byteswap, Elf and Endian Headers"
  homepage "https://github.com/bee-headers/headers"
  url "https://github.com/bee-headers/headers/archive/refs/tags/v0.1.tar.gz"
  sha256 "9c3a5a6bec539305df61edfa4bc30f98009ce97b719baa1b41609742f54cd70e"
  license all_of: ["GPL-2.0-only", "LGPL-2.1-only"]

  def install
    include.install "byteswap.h"
    include.install "elf.h"
    include.install "endian.h"

    (lib/"pkgconfig").mkpath
    (lib/"pkgconfig/bee-headers.pc").write <<~EOS
      prefix=#{prefix}
      exec_prefix=${prefix}
      includedir=${prefix}/include
      libdir=#{prefix}/lib

      Name: bee-headers
      Description: Byteswap, Elf and Endian Headers
      Version: #{version}
      Cflags: -I${includedir}
      Libs: -L${libdir}
    EOS

    (buildpath/"bee-init").write <<~EOS
      #!/bin/bash
      # SPDX-License-Identifier: GPL-2.0-only

      if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
        echo "This script should be sourced, run this instead:"
        echo "source $(brew --prefix)/bin/bee-init"
        exit 1
      fi

      function path_contains() {
        [[ ":$PATH:" == *":$1:"* ]]
      }

      PATHS_TO_ADD=(
        "#{HOMEBREW_PREFIX}/opt/coreutils/libexec/gnubin"
        "#{HOMEBREW_PREFIX}/opt/findutils/libexec/gnubin"
        "#{HOMEBREW_PREFIX}/opt/gawk/libexec/gnubin"
        "#{HOMEBREW_PREFIX}/opt/gnu-sed/libexec/gnubin"
        "#{HOMEBREW_PREFIX}/opt/gnu-tar/libexec/gnubin"
        "#{HOMEBREW_PREFIX}/opt/grep/libexec/gnubin"
        "#{HOMEBREW_PREFIX}/opt/make/libexec/gnubin"
        "#{HOMEBREW_PREFIX}/opt/llvm/bin"
      )

      if [[ -z "$BEE_HEADERS" ]]; then
        for _path in "${PATHS_TO_ADD[@]}"; do
          if ! path_contains "$_path"; then
            export PATH="$_path:$PATH"
          fi
        done

        export HOSTCFLAGS="$(pkg-config --cflags bee-headers) -D_UUID_T -D__GETHOSTUUID_H"
        export BEE_HEADERS=1
      else
        echo "Bee Headers environment is already initialized in this shell."
        echo "Unset BEE_HEADERS to force initialization."
      fi

    EOS

    bin.install "bee-init"
  end

  test do
    system "test", "-f", "#{include}/byteswap.h"
    system "test", "-f", "#{include}/elf.h"
    system "test", "-f", "#{include}/endian.h"
  end
end
