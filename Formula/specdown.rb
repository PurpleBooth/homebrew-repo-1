class Specdown < Formula
  desc "Use your markdown documentation as tests"
  homepage "https://github.com/specdown/specdown"
  url "https://github.com/specdown/specdown/archive/v1.1.9.tar.gz"
  sha256 "9eda09f0931946beb553943fe474275c397fad9f743ee63c2396ca4541461a66"

  bottle do
    root_url "https://github.com/specdown/homebrew-repo/releases/download/specdown-1.1.9"
    sha256 cellar: :any_skip_relocation, big_sur:      "5c1a791db0fd74ba843cfe8fca28b14ed76cf10c0aaad4ac6a63327d1db33a98"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "c860efab2da31807a3e74e5732f9eb913fe6b3990bb0f81bd9ee08291e0ff9fc"
  end

  depends_on "rust" => :build

  resource("testdata") do
    url "https://raw.githubusercontent.com/specdown/specdown/v1.1.9/README.md"
    sha256 "a9f658b79fbcb4b13f85cca439cd6e55a2d43a4ad47a05578c28e9c7f88bb8c0"
  end

  def install
    system "cargo", "install", "--locked", "--root", prefix, "--path", "."

    # Install bash completion
    output = Utils.safe_popen_read("#{bin}/specdown", "completion", "bash")
    (bash_completion/"specdown").write output

    # Install zsh completion
    output = Utils.safe_popen_read("#{bin}/specdown", "completion", "zsh")
    (zsh_completion/"_specdown").write output

    # Install fish completion
    output = Utils.safe_popen_read("#{bin}/specdown", "completion", "fish")
    (fish_completion/"specdown.fish").write output
  end

  test do
    system "#{bin}/specdown", "-h"
    system "#{bin}/specdown", "-V"

    resource("testdata").stage do
      assert_match "5 functions run (5 succeeded / 0 failed)", shell_output("#{bin}/specdown run README.md")
    end
  end
end
