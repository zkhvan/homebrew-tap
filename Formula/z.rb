class Z < Formula
  desc      "Zhenya's CLI"
  homepage  "https://github.com/zkhvan/z"
  url       "https://github.com/zkhvan/z/archive/refs/tags/v0.1.0.tar.gz"
  sha256    "891cd276903debf879857d631cf73f3b7e796a5f421143d0b8f1b3ec782d6151"
  license   "MIT"

  head      "https://github.com/zkhvan/z.git", branch: "main"

  depends_on "go" => :build

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
