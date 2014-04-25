class Email

  def send(email)
    Mail.deliver do
      to email[:to]
      from email[:from]
      subject email[:subject]
      body email[:body]
    end
  end

end