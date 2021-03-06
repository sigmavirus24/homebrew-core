class Mvtools < Formula
  desc "Filters for motion estimation and compensation"
  homepage "https://github.com/dubhater/vapoursynth-mvtools"
  head "https://github.com/dubhater/vapoursynth-mvtools.git"

  stable do
    url "https://github.com/dubhater/vapoursynth-mvtools/archive/v14.tar.gz"
    sha256 "ecffe1a413a9e0c11af542ff70e7c0ad78ba6e3973d360b27b14f0aac13b5fa1"

    # commit subject: "Depan: fix compilation with clang/libc++"
    # upstream fix for dubhater/vapoursynth-mvtools#27
    patch do
      url "https://github.com/dubhater/vapoursynth-mvtools/commit/28abae24.patch"
      sha256 "0338f6ff94f0bc8f77195e5b08fb8f080c6068e61f2493d600bbd2019afe7a62"
    end
  end

  bottle do
    cellar :any
    sha256 "0f25725affeb1ded389954c2a83f53ee18d6f3259578ec42a8822e25ae439fad" => :el_capitan
    sha256 "e2940a96c64ff3fac2be67ea1a30d669e6a12ba5a9dfd0f90efa59e22afda9dc" => :yosemite
    sha256 "ad22aec093ace4cfdaa2e8fb8febf6748ea8878cd045f94ec205e74f2f269252" => :mavericks
  end

  depends_on "pkg-config" => :build
  depends_on "yasm" => :build
  depends_on "vapoursynth"
  depends_on "fftw"
  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build

  def install
    system "./autogen.sh"
    system "./configure", "--prefix=#{prefix}"
    system "make", "install"
  end

  def caveats
    <<-EOS.undent
      MVTools will not be autoloaded in your VapourSynth scripts. To use it
      use the following code in your scripts:

        core.std.LoadPlugin(path="#{HOMEBREW_PREFIX}/lib/libmvtools.dylib")
    EOS
  end

  test do
    script = <<-PYTHON.undent.split("\n").join(";")
      import vapoursynth as vs
      core = vs.get_core()
      core.std.LoadPlugin(path="#{HOMEBREW_PREFIX}/lib/libmvtools.dylib")
    PYTHON

    system "python3", "-c", script
  end
end
