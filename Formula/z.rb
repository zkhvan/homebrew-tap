class Z < Formula
  desc      "Zhenya's CLI"
  homepage  "https://github.com/zkhvan/z"
  url       "https://github.com/zkhvan/z/archive/refs/tags/v0.1.1.tar.gz"
  sha256    "d7733c30fb3a31e60f39be5784adfaddc3531c22ede0a2ce8caa8e990887a2c9"
  license   "MIT"
  head      "https://github.com/zkhvan/z.git", branch: "main"

  depends_on "go" => :build
  conflicts_with "z", because: "both install z"

  deny_network_access! [:postinstall, :test]

  def install
    z_version = if build.stable?
      version.to_s
    else
      Utils.safe_popen_read("git", "describe", "--tags", "--dirty").chomp
    end

    with_env(
      "VERSION" => z_version,
    ) do
      system "make", "build"
    end

    bin.install "bin/z"
  end

  test do
    assert_match "z", shell_output("#{bin}/z --help")
    assert_match "z version #{version}", shell_output("#{bin}/z version")
  end
end
