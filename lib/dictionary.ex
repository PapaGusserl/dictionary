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
 
  def start(base_lang \\ "ru", backyard_langs \\ [], dictionary \\ :russian) do
    {:ok, sup_pid} = DS.start_link(base_lang,  backyard_langs, dictionary)
    remember(sup_pid)
    {:ok, sup_pid}
  end

  @doc """
  this fuction can add new dictionary in your app. But there you must to write id for this dictionary. I think you need to write something remembering
  """
  def add_dictionary(sup_pid, id, base, back, dict) do
    {:ok, worker_pid} = DS.add_child(sup_pid, base, back, id, dict)
    worker_pid
  end

  @doc """
  this function could help you to translate your words

  translate(worker_pid, :dictionary, "word")
  translate(:dictionary, "word", supervisors_pid) if you need to translate word with primary settings
  """
  def translate(pid, dict, word) when is_pid(pid) do
    DG.translate(pid, word, dict)
  end

  def translate(dict \\ :russian , word, sup_pid) do
    IO.puts "#{inspect sup_pid}"
    {_, worker_pid, _, _} = Supervisor.which_children(sup_pid)
      |> Enum.find( fn {x, _, _, _} -> x == DictServer end)
     translate(worker_pid, dict, word)
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

  defp remember(sup_pid) do
    :ets.new
  end
end
