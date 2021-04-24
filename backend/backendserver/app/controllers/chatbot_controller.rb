class ChatbotController < ApplicationController
	require 'net/http' 	# http request 를 위해 입력
	require 'json' 		# json 파싱을 위해
	@@basic_url = "https://api.kakaowork.com/v1/"
	@@authorization_key = "Bearer " + ENV["API_KEY"]
	@@users_list_url = "users.list"
	@@conversation_open_url = "conversations.open"
	@@message_send = "messages.send"
	
	# index : 애플리케이션 첫 call, 모든 유저 가져오기
  	def index
      
		# 1. 사용자 정보 받아오기
		get_users_uri = URI(@@basic_url + @@users_list_url)
		get_users_req = Net::HTTP::Get.new(get_users_uri)
		get_users_req[:Authorization] = @@authorization_key
		
		# user_id_list > user_id 들 저장
		user_id_list = []
		JSON.parse(
			Net::HTTP.start(get_users_uri.hostname, get_users_uri.port, :use_ssl => get_users_uri.scheme == 'https') { |http| 
				http.request(get_users_req) 
			}.body
		)["users"].each{ |user| 
			user_id_list.push(user["id"].to_i)
		}
		
		# 2. 각 유저들의 대화방 id 만들기
		conversation_open_uri = URI(@@basic_url + @@conversation_open_url)
		
		chat_room_ids = []
		user_id_list.each do |u|
			# 각 유저마다 보내야 해서 반복문 안에서 선언
			conversation_open_req = Net::HTTP::Post.new(conversation_open_uri)
			conversation_open_req[:Authorization] = @@authorization_key
            conversation_open_req["Content-type"] = "application/json" 
			
			chat_room_ids.push(
				JSON.parse(
					Net::HTTP.start(conversation_open_uri.hostname, conversation_open_uri.port, :use_ssl => conversation_open_uri.scheme == 'https') { |http|
						http.request(conversation_open_req, body={"user_id": u}.to_json)
				}.body
			)["conversation"]["id"].to_s)
		end

		# 3. 대화방 id 마다 메세지 날리기
		send_message_uri = URI(@@basic_url + @@message_send)
		chat_room_ids.each do |cid|
			# 각 채팅방 id 마다 메세지 전송
			send_message_req = Net::HTTP::Post.new(send_message_uri)
			send_message_req[:Authorization] = @@authorization_key
			send_message_req["Content-type"] = "application/json"
			
			Net::HTTP.start(send_message_uri.hostname, send_message_uri.port, :use_ssl => send_message_uri.scheme == 'https') { |http|
				http.request(send_message_req, body={"conversation_id": cid, "text": "자바꼴통 고범석의 루비왕 되는길"}.to_json) 
			}
		end

	# render :json => {
	# 	'content': data,
	# }
      
	end	# end of def index

	def create (params)
		p = JSON.parse(params.body)
		puts p
		Image.create("link" => params["link"].to_s, "summary" => params["summary"].to_s)  # 객체 생성 및 Create Query  

	end

	def show 	# 전체 레코드를 배열로 가져오고 랜덤으로 하나 선택

		Image.all.sample(1)

	end


	def accecptReceive # true면 user id를 DB에 저장

	end
    
    
end
