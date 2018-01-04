defmodule DictServer do
  use GenServer

 ##################
 # API
 ##################

  def start_link([base_lang, backyard_langs]) do
    GenServer.start_link(__MODULE__,  { base_lang , backyard_langs}, [])
  end

  def translate(pid, word, dict) do
        GenServer.cast(pid, {:trans, word, dict})
        GenServer.call(pid, {:trans, word, dict})
  end

  def dictionary(pid, dict) do
      GenServer.call(pid, {:table, dict})
  end
 ##################
 # Callbacks
 ##################

  def init({bl, back}) do
    {:ok, {bl, back}}
  end

  def handle_call({:trans, word, dict}, _from,  { base_lang, backyard_langs} ) do
    trans = DictWorker.trans_of(word, base_lang) 
     DictDatabase.add_in(dict, word, trans)
    {:reply, {"#{word}:#{trans}"}, {base_lang, backyard_langs} }
  end

  def handle_call({:table, dict}, _from, {_base, _back} = state ) do
    {:reply, DictDatabase.show_all(dict), state}
  end

  def handle_cast({:trans, word, dict}, { base_lang , backyard_lang }) do
    backyard_lang
    |> Enum.map( fn lang -> DictWorker.trans_of(word, lang) end)
    |> Enum.map( fn trans ->  DictDatabase.add_in(dict, word, trans) end )
    {:noreply, {base_lang , backyard_lang} }
  end

  end
