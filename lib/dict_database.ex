defmodule DictDatabase do


  #######
  # API #
  #######

  def start_link(table_name) do
    :dets.open_file(table_name, [type: :bag ])
  end

  def add_in(table_name, word, trans) do
    :dets.insert(table_name, {word, trans})    
  end

  def show_all(table_name) do
    #   all_rows = :ets.fun2ms(&(&1))
      :dets.select(table_name, [{:"$1", [], [:"$1"]}])
        |> Enum.map( fn {word, trans} -> word end)
        |> Enum.dedup
        |> Enum.map( fn w -> show_row(table_name, w) end)
        |> Enum.map( fn{w, t} -> IO.puts "#{w}: #{inspect t}" end )
  end

  def show_row(table_name, word) do
      trans =  :dets.lookup(table_name, word)
                     |> merge([])
      {word, trans}
  end

 def change_in({table_name, word}, {old_trans, new_trans}) do
    :dets.delete_object(table_name, {word, old_trans})
    :dets.insert(table_name, {word, new_trans})
  end

  def delete(table_name, word) do
    :dets.delete(table_name, word)
  end
  
  #####################
  # Private Functions #
  #####################

  defp merge([], state) do state end

  defp merge([{word, trans} | tail], state \\ []) do  merge(tail, [ trans | state]) end

 
end
