defmodule Dict.CLI do
    def main([word]) do
       DictWorker.trans_of(word)
       |> IO.puts
    end
end
