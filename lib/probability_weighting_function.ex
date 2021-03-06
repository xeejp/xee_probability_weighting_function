defmodule ProbabilityWeightingFunction do 
  use XeeThemeScript 
  require Logger 
  alias ProbabilityWeightingFunction.Main 
  alias ProbabilityWeightingFunction.Host 
  alias ProbabilityWeightingFunction.Participant 
  # Callbacks 
  def script_type do 
    :message 
  end 
  def install, do: nil 
  def init do 
    {:ok, %{"data" => Main.init()}} 
  end 
  def wrap_result({:ok, _} = result), do: result 
  def wrap_result(result), do: Main.wrap(result) 
  def join(data, id) do 
    wrap_result(Main.join(data, id)) 
  end 
  # Host router 
  def handle_received(data, %{"action" => action, "params" => params}) do 
    Logger.debug("[PWF] #{action}") 
    result = case {action, params} do 
      {"fetch contents", _} -> Host.fetch_contents(data) 
      {"change page", page} -> Host.change_page(data, page) 
      {"all reset", _}      -> Host.all_reset(data) 
      {"update question", question_text} -> Host.update_question(data, question_text) 
      _ -> {:ok, %{"data" => data}} 
    end 
    wrap_result(result) 
  end 
  # Participant router 
  def handle_received(data, %{"action" => action, "params" => params}, id) do 
    Logger.debug("[PWF] #{action}") 
    result = case {action, params} do 
      {"fetch contents", _} -> Participant.fetch_contents(data, id) 
      {"set question", question} -> Participant.set_question(data,id,question) 
      {"next", add} -> Participant.next(data,id,add) 
      {"finish", _} -> Participant.finish(data, id) 
      _ -> {:ok, %{"data" => data}} 
    end 
    wrap_result(result) 
  end 
end 
