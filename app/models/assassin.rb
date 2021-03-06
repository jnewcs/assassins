class Assassin < ActiveRecord::Base
    
    def time_left
        # Default time to complete assignment is 24 hours
        (24.0-(Time.new - last_kill)/(60*60)).round(3)    
    end
    
    def self.activeAssassins(total)
        return Assassin.first(total)
    end
    
    def self.findPrevious(id)
        currentID = Assassin.updateID(id)
        all = Assassin.all
        while true
            killed = Assassin.find(currentID).killed.to_i
            if(killed == 0) 
                break
            end
            currentID = Assassin.updateID(currentID)
        end
        return Assassin.find(currentID.to_i)
    end
    
    def self.updateID(id)
        result = 0
        if id.to_i == 1
            result = Assassin.all.length
        else 
            result = id.to_i - 1
        end
        return result.to_i
    end
    
end
