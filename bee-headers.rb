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
  end

  test do
    system "test", "-f", "#{include}/byteswap.h"
    system "test", "-f", "#{include}/elf.h"
    system "test", "-f", "#{include}/endian.h"
  end
end
