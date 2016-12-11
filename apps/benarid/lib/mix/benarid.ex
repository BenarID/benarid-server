defmodule Mix.BenarID do
  # Conveniences for writing Mix.Tasks in BenarID.
  @moduledoc false

  def no_umbrella!(task) do
    if Mix.Project.umbrella? do
      Mix.raise "Cannot run task #{inspect task} from umbrella application"
    end
  end
end
