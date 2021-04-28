class Image < ApplicationRecord
    validates :link,  :presence => true
    validates :summary, :presence => true,
                    :length => {:maximum => 45 }
end
