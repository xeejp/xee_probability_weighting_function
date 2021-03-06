defmodule ProbabilityWeightingFunction.Actions do
  alias ProbabilityWeightingFunction.Participant
  alias ProbabilityWeightingFunction.Host
  alias ProbabilityWeightingFunction.Main

  def change_page(data, page) do
    action = get_action("change page", page)
    format(data, nil, dispatch_to_all(data, action))
  end

  def join(data, id, participant) do
    host = get_action("join", %{id: id, participant: participant})
    action = get_action("joined", Map.size(data.participants))
    format(data, host, dispatch_to_all(data, action))
  end
  
  def update_host_contents(data) do
    host = get_action("update contents", Host.format_contents(data))
    format(data, host)
  end

  def all_reset(data) do
    host = get_action("update contents", Host.format_contents(data))
    action = get_action("reset", Main.new_participant(data))
    format(data, host, dispatch_to_all(data, action))
  end

  def update_question(data, question_text) do
    host = get_action("update", question_text)
    participant = get_action("update", %{money: question_text["money"], add: %{"0" =>question_text["add"], "1" =>question_text["add"], "2" =>question_text["add"], "3" =>question_text["add"], "4" =>question_text["add"], "5" =>question_text["add"]}, unit: question_text["unit"]})
    format(data, host, dispatch_to_all(data, participant))
  end

  def set_question(data,id,question) do
    participant = get_action("set question", question)
    host = get_action("start", %{id: id})
    format(data,host,dispatch_to(id,participant))
  end

  def next(data,id,slideIndex) do
    host = get_action("update_result", %{id: id, add: data.participants[id].add, plus: data.participants[id].plus})
    participant = get_action("change index", %{slideIndex_data: slideIndex , add: data.participants[id].add, plus: data.participants[id].plus})
    format(data, host, dispatch_to(id,participant))
  end

  def finish(data,id) do
    host = get_action("update_result", %{id: id, add: data.participants[id].add, plus: data.participants[id].plus})
    participant = get_action("to_result", %{})
    format(data, host, dispatch_to(id,participant))
  end

  def update_participant_contents(data, id) do
    participant = dispatch_to(id, get_action("update contents", Participant.format_contents(data, id)))
    format(data, nil, participant)
  end

  # Utilities

  defp get_action(type, params) do
    %{
      type: type,
      payload: params
    }
  end

  defp dispatch_to(map \\ %{}, id, action) do
    Map.put(map, id, %{action: action})
  end

  defp dispatch_to_all(%{participants: participants}, action) do
    Enum.reduce(participants, %{}, fn {id, _}, acc -> dispatch_to(acc, id, action) end)
  end

  defp format(data, host, participants \\ nil) do
    result = %{"data" => data}
    unless is_nil(host) do
      result = Map.put(result, "host", %{action: host})
    end
    unless is_nil(participants) do
      result = Map.put(result, "participant", participants)
    end
    {:ok, result}
  end
end
