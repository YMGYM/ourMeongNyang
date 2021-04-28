namespace :chatbot do
  desc "TODO"
  task send_image: :environment do
  
      require 'net/http'
      uri = URI('https://swm-chatbot-9gsxzg-cydssl.run.goorm.io/chatbot/show')
      res = Net::HTTP.post_form(uri, 'q'=>{})
  end

end
