class CreateAssassins < ActiveRecord::Migration
    def change
        create_table :assassins do |t|
            t.string :name
            t.integer :seed
            # Killed value = 0 if still in the game
            # Killed value = 1 if removed from the game
            t.integer :killed
        end
    end
end
