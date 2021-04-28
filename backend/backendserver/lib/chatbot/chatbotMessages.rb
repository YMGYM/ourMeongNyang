
    require 'json'

    def imgMsg(conversation_id, img)
        {
        	"conversation_id": conversation_id,
			"text": "우리멍냥 자랑 메시지",
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
				  "text": "*다음 사진도 받으시겠습니까?* \n(총 3번의 사진을 받을 수 있습니다.)",
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
                          "action_name": "subscription",
						  "value": "TRUE"
						},
						{
						  "type": "button",
						  "text": "아니오",
						  "style": "danger",
						  "action_type": "submit_action",
                          "action_name": "subscription",
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
				  "text": "*감사합니다.* 🐶",
				  "markdown": true
				}
			]
		}.to_json
    end
