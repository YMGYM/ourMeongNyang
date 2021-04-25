require 'net/http'
# 5 + 9시 10분에 작업 수행
# every :day, at: '5:10 am' do
#     ...
# end

every 1.minute do
   runner "require 'net/http'"
   runner "uri = URI('https://swm-chatbot-9gsxzg-cydssl.run.goorm.io/chatbot/show')"
   runner "res = Net::HTTP.post_form(uri, 'q'=>{})"
end