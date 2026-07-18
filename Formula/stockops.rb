class Stockops < Formula
  desc "8-agent stock-trading team (broker/data/LLM fallback, dashboard, closed-loop learning)"
  homepage "https://github.com/xinFu3576/stockops"
  url "https://github.com/xinFu3576/stockops/releases/download/v0.10.0/stockops-0.10.0.tar.gz"
  sha256 "4df3bb9a903dd045e9ae1a6d4a1a87e73c21b936b4b60fe42696a8b962dc2d44"
  version "0.10.0"
  license "MIT"

  depends_on "python@3.12"

  def install
    libexec.install Dir["stock-agents-team/*"]
    (bin/"stockops").write <<~SH
      #!/bin/bash
      cd "#{libexec}"
      if [ ! -d ".venv" ]; then
        python3 -m venv .venv
        ./.venv/bin/pip install --upgrade pip
        ./.venv/bin/pip install -r requirements.txt
      fi
      exec ./.venv/bin/python manage.py "$@"
    SH
    chmod 0755, bin/"stockops"
  end

  def caveats
    <<~EOS
      首次运行会创建 venv 并装依赖 (~1-2 分钟)。

      常用命令:
        stockops status             # 团队状态
        stockops test               # 跑单测 (9/9)
        stockops verify             # 数据/因子健康检查
        stockops dashboard          # http://127.0.0.1:8765
        stockops daily 2026-07-18   # 一键日跑

      部署到 OpenClaw:
        cd $(brew --prefix)/opt/stockops/libexec
        bash .codex-plugin/install.sh
    EOS
  end

  test do
    assert_match "StockOps", shell_output("#{bin}/stockops status 2>&1", 0)
  end
end
