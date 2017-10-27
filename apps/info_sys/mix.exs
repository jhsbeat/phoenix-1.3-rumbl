defmodule InfoSys.Mixfile do
  use Mix.Project

  def project do
    [
      app: :info_sys,
      version: "0.1.0",
      build_path: "../../_build",
      # 서브 애플리케이션은 모두 같은 config 와 lock 파일에 의존함. 따라서 A 프로젝트에서 B 프로젝트의 config 도 읽을 수 있음. 물론 그러면 안되겠지만...
      config_path: "../../config/config.exs",
      deps_path: "../../deps",
      lockfile: "../../mix.lock",
      elixir: "~> 1.5",
      start_permanent: Mix.env == :prod,
      deps: deps()
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger],
      mod: {InfoSys.Application, []}
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:sweet_xml, ">= 0.0.0"},
      # {:dep_from_hexpm, "~> 0.3.0"},
      # {:dep_from_git, git: "https://github.com/elixir-lang/my_dep.git", tag: "0.1.0"},
      # {:sibling_app_in_umbrella, in_umbrella: true},
    ]
  end
end
