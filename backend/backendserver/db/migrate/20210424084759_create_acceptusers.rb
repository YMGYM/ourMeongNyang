class CreateAcceptusers < ActiveRecord::Migration[6.1]
	def change
		create_table :acceptusers do |t|
			t.integer :user_id
			t.timestamps
		end
	end
end
