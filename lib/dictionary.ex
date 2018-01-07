defmodule Dictionary do
  alias DictSupervisor, as: DS
  alias DictServer, as: DG
  use Application

   @moduledoc """

  Dictionary v.0.0.1. by Papa_Gusserl

  This is module can:
  1) create any dictionaries(func start/3)
  2) general thing, that you must to know - one lang always be a base, that shows to you immedetly, but backyard langs you can see juxt in data base
  3) you can translate just from English(func translate/3)
  4) you can translate your's words in two and more dictionary's(func add_dictionary/4)
  So, you can do this immnedetly.
  """

  @doc """
  this function can create new dictionary. Remember, that it must do be the first function, that you could start. 
  Example: Dictionary.start("en", ["de", "lt"], :dictionary) -->> pid of supervisor
  """
 
  def start(_type, _args) do
    {:ok, sup_pid} = DS.start_link("ru", [], :russian)
    remember!(sup_pid)
    {:ok, sup_pid}
  end

  @doc """
  this fuction can add new dictionary in your app. But there you must to write id for this dictionary. I think you need to write something remembering
  """
  def add_dictionary(id, base, back, dict) do
    sup_pid = remember?()
    {:ok, worker_pid} = DS.add_child(sup_pid, base, back, id, dict)
    state!(id, dict, worker_pid)
  end

  @doc """
  this function could help you to translate your words

  translate(worker_pid, :dictionary, "word")
  translate("word") if you need to translate word with default 
  """
  def translate(dict \\ :russian , word) when is_atom(dict) do
    sup_pid = remember?()
    {_, worker_pid, _, _} = Supervisor.which_children(sup_pid)
      |> Enum.find( fn {x, _, _, _} -> x == DictServer end)
     DG.translate(worker_pid, word, dict)
  end

  def translate(id, word) do
    {_id, dict, pid} = state?(id)
    DG.translate(pid, word, dict)
  end


  @doc """
  func show/1 showing to you your dictionary
  """
  def show(dict \\ :russian) do
      DictDatabase.show_all(dict) 
  end
  
  #####################
  # Private functions #
  #####################

  defp remember!(sup_pid) do
    Agent.start_link(fn -> sup_pid end, name: Sup)
    Agent.start_link(fn-> [] end, name: Worker)
  end

  defp remember?() do
    Agent.get(Sup, &(&1))
  end

  defp state!(id, dict, pid) do
    Agent.update(Worker, fn list -> [{id, dict, pid} | list ] end)
  end

  def state?(id) do 
    Agent.get(Worker, fn list -> list end)
    |> Enum.find(fn {x, _, _} -> x==id end)
  end
end
