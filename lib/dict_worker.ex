defmodule DictWorker do 
 
  def trans_of(word, to \\ "ru") do
		result = url_for(word, to) |> HTTPoison.get |> parse_response
		case result do 
			{:ok, translation} ->
				"#{to}:#{translation}"
			:error ->
				"#{word} not found!"
		end
	end
	
	defp url_for(word, to) do
		word = URI.encode(word)
    to = URI.encode(to)
    "https://translate.yandex.net/api/v1.5/tr.json/translate?key=#{apikey()}&lang=en-#{to}&text=#{word}"
	end
	
	defp parse_response({:ok, %HTTPoison.Response{body: text, status_code: 200}}) do
		text |> JSON.decode! |> compute_translation
	end
	
	defp parse_response(_) do
		:error
	end
	
	defp compute_translation(json) do
		try do
			translation = (json["text"])
			{:ok, translation}
		rescue
			_ -> :error
		end
	end
	
	defp apikey do
		"trnsl.1.1.20171210T184627Z.bf94f6ba689c9a03.830510e13198c2617ee4a61a49e58da3b5985229"
	end
 
end
