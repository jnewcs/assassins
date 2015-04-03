class AddTime < ActiveRecord::Migration
    def change
        add_column :assassins, :last_kill, :datetime
    end
end
