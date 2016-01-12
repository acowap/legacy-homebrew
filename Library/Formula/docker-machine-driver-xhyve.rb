require "language/go"

class DockerMachineDriverXhyve < Formula
  desc "Docker Machine driver for xhyve"
  homepage "https://github.com/zchee/docker-machine-driver-xhyve"
  url "https://github.com/zchee/docker-machine-driver-xhyve/archive/v0.2.1.tar.gz"
  sha256 "11ed10c4ea45249e06c9efad0abf1c91b0ec9c4c2a0818ade78f19f41a17794c"

  head "https://github.com/zchee/docker-machine-driver-xhyve.git"

  depends_on :macos => :yosemite
  depends_on "go" => :build
  depends_on "docker-machine"

  def install
    (buildpath/"gopath/src/github.com/zchee/docker-machine-driver-xhyve").install Dir["{*,.git,.gitignore}"]

    ENV["GOPATH"] = "#{buildpath}/gopath"
    ENV["GO15VENDOREXPERIMENT"] = "1"

    cd buildpath/"gopath/src/github.com/zchee/docker-machine-driver-xhyve" do
      if build.head?
        git_hash = `git rev-parse --short HEAD --quiet`.chomp
        git_hash = " HEAD-#{git_hash}"
      end
      system "go", "build", "-o", bin/"docker-machine-driver-xhyve",
      "-ldflags",
      "'-w -s'",
      "-ldflags",
      "-X 'github.com/zchee/docker-machine-driver-xhyve/xhyve.GitCommit=Homebrew#{git_hash}'",
      "./main.go"
    end
  end

  test do
    assert_match "xhyve-memory-size",
    shell_output("#{Formula["docker-machine"].bin}/docker-machine create --driver xhyve -h")
  end
end
