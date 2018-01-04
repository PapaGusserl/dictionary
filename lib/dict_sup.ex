defmodule DictSupervisor do
  use  Supervisor

   def start_link(base, back, dict) do
     DictDatabase.start_link(dict)
     Supervisor.start_link([
       {DictServer, [base, back] }
    ], strategy: :one_for_one)
     
  end

  def add_child(sup_pid, base, back, id, dict) do
    DictDatabase.start_link(dict)
    spec = %{
            id: id,
            start: {DictServer, :start_link, [[base, back]]},
            restart: :permanent,
            shutdown: :infinity,
            type: :worker
            }
    Supervisor.start_child(sup_pid, spec) 
 end

  #  def delete_child(name) do
    #    {:deleted, name }
    # end

    end
