defmodule Dictionary do
  alias DictSupervisor, as: DS
  alias DictServer, as: DG
  use Application

   @moduledoc """

  Dictionary v.0.0.1. by Papa_Gusserl

  translate/1 to translate from English("en") to Russian("ru") \n
  translate/2 to translate from English("en") to your's own dictionaries( For example: Portugal("pt"), France("fr") ). For more information you can h Dictionary.langs \n
  show/1 to show for you yours dictionaries \n
  add_dictionary/4 to create your own dictionaries \n
  support/1 to connect with author
  """

  @doc """
  this function can create new dictionary. Remember, that it must do be the first function, that you could start. \n
  """
 
  def start(_type, _args) do
    {:ok, sup_pid} = DS.start_link("ru", [], :russian)
    remember!(sup_pid)
    {:ok, sup_pid}
  end

  def add_dictionary(id, base, back, dict) do
    sup_pid = remember?()
    {:ok, worker_pid} = DS.add_child(sup_pid, base, back, id, dict)
    state!(id, dict, worker_pid)
  end

  def translate(word) do
    sup_pid = remember?()
    {_, worker_pid, _, _} = Supervisor.which_children(sup_pid)
      |> Enum.find( fn {x, _, _, _} -> x == DictServer end)
     DG.translate(worker_pid, word, :russian)
  end

  def translate(id, word) do
    {_id, dict, pid} = state?(id)
    IO.puts "#{inspect pid}"
    DG.translate(pid, word, dict)
  end

  def show(dict \\ :russian) do
      DictDatabase.show_all(dict) 
  end

  def support(content) do
    DictEmail.sender(content)
  end

  @doc """
  албанский sq  мальтийский mt  амхарский am  македонский mk \n
  английский  en  маори mi  арабский  ar  маратхи mr \n
  армянский hy  марийский mhr  африкаанс af  монгольский mn \n
  баскский  eu  немецкий  de   башкирский  ba  непальский  ne \n
  белорусский be  норвежский  no   бенгальский bn  панджаби  pa \n
  бирманский  my  папьяменто  pap  болгарский  bg  персидский  fa \n
  боснийский  bs  польский  pl  валлийский  cy  португальский pt \n
  венгерский  hu  румынский ro  вьетнамский vi  русский ru \n
  гаитянский (креольский) ht  себуанский  ceb  галисийский gl  сербский  sr \n
  голландский nl  сингальский si  горномарийский  mrj словацкий sk \n
  греческий el  словенский  sl  грузинский  ka  суахили sw \n
  гуджарати gu  сунданский  su  датский da  таджикский  tg \n
  иврит he  тайский th  идиш  yi  тагальский  tl \n
  индонезийский id  тамильский  ta  ирландский  ga  татарский tt \n
  итальянский it  телугу  te  исландский  is  турецкий  tr \n
  испанский es  удмуртский  udm  казахский kk  узбекский uz\n
  каннада kn  украинский  uk  каталанский ca  урду  ur\n
  киргизский  ky  финский fi  китайский zh  французский fr\n
  корейский ko  хинди hi  коса  xh  хорватский  hr\n
  кхмерский km  чешский cs  лаосский  lo  шведский  sv\n
  латынь  la  шотландский gd  латышский lv  эстонский et\n
  литовский lt  эсперанто eo  люксембургский  lb  яванский  jv\n
  малагасийский mg  японский  ja  малайский ms    
  """
  def langs() do
    IO.puts "Try to write in shell 'h Dictionary.langs'"
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
