class HomeController < ApplicationController
    def index
        @len = Assassin.all.length.to_i
        @all = Assassin.activeAssassins(@len)  
        @numAlive = Assassin.where(:killed => 0).length.to_s
    end
    
    def populate 
        len = Assassin.all.length
        if len == 0
            # Harcoded list of names
            names = ["Max Drimmer", "Kyle Robinson", "Clare Moffatt", "Thomas Liu", "Hannah Levy", "Anna Thomas", "Anjali", "Regina Nguyen", "Mario Khosla", "Rebecca Triplett", "Tarek Abdelghany", "Jason Randoing", "Katie Schneider", "Derek Phillips", "Kathleen Miller", "Otto Zhen", "Bilaal Rajan",  "Ibrahim Bharmal", "Sarah Radzihovsky", "Blaire Hunter", "Tiffany Kuo", "Kyle D'Souza", "Arturo Rojas", "Katie Keyser", "Joshua Kravitz", "A.J", "Albert Feng", "Elisa Hofmeister", "Rochelle Rouhani", "Richie Hojel", "Matthew Stuart", "Kevin Chavez", "Ali Eicher", "Jack Seaton", "Shawn Fenerin", "James Webb", "Kais Ben Halim", "Alexandra Nguyen-Phuc", "Alex Chanthavong", "Hayley Ritterhern", "Kaylee Johnson", "Lauren Norheim", "Patrick Conaton", "Krista Chew", "Brennan Shacklett", "Gigi Nwagbo", "Neel Ramachandran", "Catherina Xu", "Rishab Mehra", "Konner Robison", "Tyler Dammann", "Brandon Racca", "Sam Premutico", "Jack Herrera", "Souraya Karimi", "Geoff Angus", "Simba", "Julia Doody", "Nathan Petrie"]
            
            # Hardcoded list of corresponding numbers. 
            # Example: the phone number of the first name (index = 0) in the names array
            # is the first number (index = 0) in the numbers array
            numbers = ["(972) 415-8553", "(617) 234-9738", "(321) 998-2131", "(972) 415-8553", "(531) 782-7767", "(817) 222-2912", "(972) 415-8553", "(321) 998-2131", "(531) 782-7767", "(972) 415-8553", "(671) 131-2131", "(817) 222-2912", "(972) 415-8553", "(617) 234-9738", "(531) 782-7767", "(617) 234-9738", "(424) 321-3665",  "(981) 122-3343", "(972) 415-8553", "(424) 321-3665", "(817) 222-2912", "(671) 131-2131", "(972) 415-8553", "(424) 321-3665", "(424) 321-3665", "(817) 222-2912", "(321) 998-2131", "(972) 415-8553", "(531) 782-7767", "(671) 131-2131", "(817) 222-2912", "(981) 122-3343", "(424) 321-3665", "(817) 222-2912", "(671) 131-2131", "(424) 321-3665", "(321) 998-2131", "(617) 234-9738", "(321) 998-2131", "(817) 222-2912", "(424) 321-3665", "(617) 234-9738", "(817) 222-2912", "(981) 122-3343", "(617) 234-9738", "(531) 782-7767", "(321) 998-2131", "(617) 234-9738", "(972) 415-8553", "(981) 122-3343", "(424) 321-3665", "(972) 415-8553", "(531) 782-7767", "(671) 131-2131", "(671) 131-1322", "(617) 234-9738", "(531) 782-7767", "(321) 998-2131", "(972) 415-8553"]
            
            resultHash = {}
            numbersHash = {}
            
            index = 0
            names.each do |member|
                randomNumber = rand(1...99999)
                # Links name with random seed
                resultHash[member] = randomNumber
                
                # Links name with phone number
                numbersHash[member] = numbers[index]
                
                index = index + 1
            end
            
            # Sorts array from lowest seed to highest
            sorted = resultHash.sort_by{|key, value| value}
            
            sorted.each do |key, value|
                assassin = Assassin.new()
                assassin.name = key.to_s
                assassin.seed = value.to_i
                assassin.killed = 0
                assassin.last_kill = Time.new
                assassin.phone = numbersHash[key.to_s]
                assassin.save(:validate => false)
            end
        end
        redirect_to :controller => :home, :action => :index
    end
    
    def switch
        query = params[:query].downcase
        assassinID = params[:id]
        previous = Assassin.findPrevious(assassinID)
        assassin = Assassin.find(assassinID)
        result = ""
        if query == "revive"
            assassin.killed = 0
            result = "assassinate"    
        else 
            previous.last_kill = Time.new
            assassin.killed = 1
            result = "revive"
        end
        assassin.last_kill = Time.new
        assassin.save(:validate => false)
        previous.save(:validate => false)
        render :text => result   
    end
    
    def reset_all
        allPlayers = Assassin.all
        allPlayers.each do |player|
            player.last_kill = Time.new
            player.save(:validate => false)
        end
        redirect_to :controller => :home, :action => :index
    end
    
    def add_hours
        allPlayers = Assassin.all
        id = params[:id]
        allPlayers.each do |player|
            player.last_kill =  player.last_kill + id.to_i.hours
            player.save(:validate => false)
        end
        redirect_to :controller => :home, :action => :index
    end
    
    def pre_change_name
        id = params[:id]
        @assassin = Assassin.find(id)
    end
    
    def change_name
        id = params[:id]
        @assassin = Assassin.find(id)
        @assassin.name = params[:assassin][:name]
        @assassin.save(:validate => false)
        redirect_to :controller => :home, :action => :index
    end
    
    def pre_change_phone
        id = params[:id]
        @assassin = Assassin.find(id)
    end
    
    def change_phone
        id = params[:id]
        @assassin = Assassin.find(id)
        @assassin.phone = params[:assassin][:phone]
        @assassin.save(:validate => false)
        redirect_to :controller => :home, :action => :index
    end
    
    def pre_change_time
        id = params[:id]
        @assassin = Assassin.find(id)
    end
    
    def change_time
        id = params[:id]
        @assassin = Assassin.find(id)
        difference = (params[:time].to_f - @assassin.time_left.to_f).round(3)
        final_time = @assassin.last_kill + difference.hours
        @assassin.last_kill = final_time
        @assassin.save(:validate => false)
        redirect_to :controller => :home, :action => :index
    end
end
