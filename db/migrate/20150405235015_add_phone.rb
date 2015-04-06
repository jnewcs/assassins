class AddPhone < ActiveRecord::Migration
    def change
        add_column :assassins, :phone, :string
        
        Assassin.all.each do |a|
            a.phone = "No Phone Listed"
            a.save(:validate => false)
        end
    end
end
