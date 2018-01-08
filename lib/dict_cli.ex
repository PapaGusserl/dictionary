defmodule Dict.CLI do
    def main(args \\ []) do
      args
      |> parse_args
      |> response
      |> IO.puts()
    end

    defp parse_args(args) do
      {opts, word, _ }  =
        args
        |> OptionParser.parse(switches: [t: :boolean])
      {opts, List.to_string(word)}
    end

    defp response({opts, word}) do
      {result} = if opts[:t] do 
       Dictionary.translate(word)
       else
        {word} 
      end
      result
    end
end
