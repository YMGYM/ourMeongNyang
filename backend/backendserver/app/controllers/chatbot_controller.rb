class ChatbotController < ApplicationController
	require 'net/http' 	# http request 를 위해 입력
	require 'json' 		# json 파싱을 위해
	
	@@basic_url = "https://api.kakaowork.com/v1/"
	@@authorization_key = "Bearer " + ENV["API_KEY"]
	
	@@users_list_url = "users.list"
	@@get_users_uri = URI(@@basic_url + @@users_list_url)
	
	@@conversation_open_url = "conversations.open"
	@@conversation_open_uri = URI(@@basic_url + @@conversation_open_url)
	
	@@message_send = "messages.send"
	@@send_message_uri = URI(@@basic_url + @@message_send)
	
	# index : 애플리케이션 첫 call, 모든 유저 가져오기
  	def index
      
		# 1. 사용자 정보 받아오기
		get_users_req = Net::HTTP::Get.new(@@get_users_uri)
		get_users_req[:Authorization] = @@authorization_key
		
		# user_id_list > user_id 들 저장
		user_id_list = []
		JSON.parse(
			Net::HTTP.start(@@get_users_uri.hostname, @@get_users_uri.port, :use_ssl => @@get_users_uri.scheme == 'https') { |http| 
				http.request(get_users_req) 
			}.body
		)["users"].each{ |user| 
			user_id_list.push(user["id"].to_i)
		}
		
		# 2. 각 유저들의 대화방 id 만들기, 리팩토링 완료
		chat_room_ids = make_chat_room_ids(user_id_list, @@conversation_open_uri)

		# 3. 대화방 id 마다 메세지 날리기, 리팩토링 완료
		send_message(chat_room_ids, @@send_message_uri, 'img')

		render :json => {
			'content': "successfully sent to all users",
		}
		
	end	# end of def index

	
	def create 	# 이미지 저장
        gotParams = params.require(:data).permit(:imageURL, :summary)         
		Image.create("link" => gotParams["imageURL"].to_s, "summary" => gotParams["summary"].to_s)  # 객체 생성 및 Create Query  
		
		render :json => {
			'content': "successfully save image",
		}.to_json
	end # end of create

	def show 	# DB에서 수신 수락한 회원 조회, 사진 전송		
		@users = Acceptuser.all
		user_id_list = []
		@users.each do |u|
			user_id_list.push(u["user_id"])
		end
		
		chat_room_ids = make_chat_room_ids(user_id_list, @@conversation_open_uri)
		send_message(chat_room_ids, @@send_message_uri)
		
	end # end of show


	def accept # 이미지 다음 이미지를 받을 유저인지 확인 후 저장
		accept_user = Acceptuser.find_by(user_id: params["react_user_id"].to_i)
		
		if accept_user.present? and !params["receive"]
			accept_user.destroy
		elsif !accept_user.present? and params["receive"]
			Acceptuser.create("user_id" => params["react_user_id"].to_i)
		end
		
        chat_room_ids = make_chat_room_ids([params["react_user_id"].to_i], @@conversation_open_uri)
		send_message(chat_room_ids, @@send_message_uri, "thank")
        
		render :json => {
			'content': "successfully sent to all users",
		}.to_json
        
	end # end of accept
    
    
    # 전체 이미지 전송
    def list
        images = Image.all
        
        if params["startIndex"].to_i > images.length()
            render :json => {
			    'data': "startIndex is bigger than total length",
		    }.to_json
        end
        
        images = images.reverse().slice(params["startIndex"].to_i ... params["endIndex"].to_i)
        
        return_value = []
        
        images.each do |i|
            return_value << {'id' => i.id, 'imageURL' => i.link, 'summary' => i.summary}
        end
            
        render :json => {
			'data': return_value,
		}
    end
    
    
    private
    def make_chat_room_ids(user_id_list, conversation_open_uri)
		
		chat_room_ids = []
		puts user_id_list
		user_id_list.each do |id|
			conversation_open_req = Net::HTTP::Post.new(conversation_open_uri)
			conversation_open_req[:Authorization] = @@authorization_key
			conversation_open_req["Content-type"] = "application/json"
			
			chat_room_ids.push(
				JSON.parse(
					Net::HTTP.start(conversation_open_uri.hostname, conversation_open_uri.port, :use_ssl => conversation_open_uri.scheme == 'https') { |http|
						http.request(conversation_open_req, body={"user_id": id.to_i}.to_json)
				}.body
			)["conversation"]["id"].to_s)
		end
		
		return chat_room_ids
	end # end of make_chat_room_ids
	
	def send_message(chat_room_ids, send_message_uri, msgType)
		
        images = Image.all
        selected_img = images.sample().link
		
		chat_room_ids.each do |id|
			# 각 채팅방 id 마다 메세지 전송
			send_message_req = Net::HTTP::Post.new(send_message_uri)
			send_message_req[:Authorization] = @@authorization_key
			send_message_req["Content-type"] = "application/json"
			
			Net::HTTP.start(send_message_uri.hostname, send_message_uri.port, :use_ssl => send_message_uri.scheme == 'https') { |http|
                if msgType == 'img'
                    http.request(send_message_req, body=imgmsg(id, selected_img))
                else
                    http.request(send_message_req, body=response_msg(id))
                end
			}
		end
	end # end of send_message
    
    def imgmsg(conversation_id, img)
        {
          "conversation_id": conversation_id,
		  "text": "멍냥 사진이 도착했습니다.",
		  "blocks": [
			{
			  "type": "header",
			  "text": "멍냥 사진",
			  "style": "blue"
			},
			{
			  "type": "image_link",
			  "url": img
			},
			{
			  "type": "description",
			  "term": "사연",
			  "content": {
				"type": "text",
				"text": "유기견 주워서 키웠습니다. 아주 이쁩니다.",
				"markdown": true
			  },
			  "accent": true
			},
			{
			  "type": "button",
			  "text": "멍냥 사진 자랑하러 가기",
			  "style": "default",
			  "action_type": "open_system_browser",
			  "value": "https://www.naver.com"
			},
			{
			  "type": "divider"
			},
			{
			  "type": "text",
			  "text": "*다음 사진도 받으시겠습니까?* \n (총 3번의 사진을 받을 수 있습니다.)",
			  "markdown": true
			},
			{
			  "type": "action",
			  "elements": [
				{
				  "type": "button",
				  "text": "네",
				  "style": "primary",
				  "action_type": "submit_action",
				  "action_name": "TRUE",
				  "value": "TRUE"
				},
				{
				  "type": "button",
				  "text": "아니오",
				  "style": "danger",
				  "action_type": "submit_action",
				  "action_name": "FALSE",
				  "value": "FALSE"
				}
			  ]
			}
		  ]
		}.to_json
    end # end of create block-kit
	
	def response_msg(conversation_id)
		{
        	"conversation_id": conversation_id,
			"text": "우리멍냥 응답 메세지",
			"blocks": [
				{
				  "type": "text",
				  "text": "*감사합니다.*🐱 🐶",
				  "markdown": true
				}
			]
		}.to_json	
	end
end
