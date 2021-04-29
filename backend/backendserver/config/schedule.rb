# 하루 두 번 작업 수행
every 1.day, at: ['09:00 am','10:00 am','11:00 am','12:00 pm', '01:00 pm', '02:00 pm','03:00 pm','04:00 pm', '05:00 pm','06:00 pm','07:00 pm','08:00 pm','09:00 pm',] do
    ENV.each { |k, v| env(k, v) } # 환경 세팅
    rake "chatbot:send_image", :environment => "development" # lib/task/chatbot.rake
end

# 디버깅용 1분마다
# every 1.minutes do
#    ENV.each { |k, v| env(k, v) } # 환경 세팅
#    rake "chatbot:send_image", :environment => "development" # lib/task/chatbot.rake
# end