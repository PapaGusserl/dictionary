defmodule DictEmail do
  use Mailgun.Client,
    domain: Application.get_env(:dictionary, :mailgun_domain),
    key:    Application.get_env(:dictionary, :mailgun_key)

  def sender(content) do
    send_email to: "akhtyamov.vlad@outlook.com",
             from: "vlad@papagusserl",
          subject: "Email from Dictionary",
             text: content
  end

end
