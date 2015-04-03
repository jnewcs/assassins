class Assassin < ActiveRecord::Base
    def self.activeAssassins(total)
        return Assassin.first(total)
    end
end
