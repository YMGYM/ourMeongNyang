class CreateImages < ActiveRecord::Migration[6.1]
	def change
		create_table :images do |t|
		t.string :link
		t.text :summary
        t.boolean :isSent
		t.timestamps
		end
	end
end
