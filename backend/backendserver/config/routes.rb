Rails.application.routes.draw do
    
    get 'index' => 'chatbot#index'
    # 최초 실행
    post 'chatbot' => 'chatbot#index' # 소마 평가용 url
    
    
    
    # 모달 콜백
    post 'callback' => "chatbot#accept"
    
	# 이미지 저장
    post 'chatbot/create'

	
    # 이미지 표시
    post 'chatbot/show'
    
    # 전체 이미지 전송
    get 'chatbot/list'

    # 모달 보내기
    post 'request' => 'chatbot#closeup'
    
    # 특정 이미지 삭제(for 배포)
    delete 'chatbot/deleteImage' => 'chatbot#deleteImage'
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
