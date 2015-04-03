class HomeController < ApplicationController
    def index
        assassins = Assassin.all
        if assassins.length == 0
            array = ["Max Drimmer", "Kyle Robinson", "Clare Moffatt", "Thomas Liu", "Hannah Levy", "Anna Thomas", "Anjali", "Regina Nguyen", "Mario Khosla", "Rebecca Triplett", "Tarek Abdelghany", "Jason Randoing", "Katie Schneider", "Derek Phillips", "Kathleen Miller", "Otto Zhen", "Bilaal Rajan",  "Ibrahim Bharmal", "Sarah Radzihovsky", "Blaire Hunter", "Tiffany Kuo", "Kyle D'Souza", "Arturo Rojas", "Katie Keyser", "Joshua Kravitz", "A.J", "Albert Feng", "Elisa Hofmeister", "Rochelle Rouhani", "Richie Hojel", "Matthew Stuart", "Kevin Chavez", "Ali Eicher", "Jack Seaton", "Shawn Fenerin", "James Webb", "Kais Ben Halim", "Alexandra Nguyen-Phuc", "Alex Chanthavong", "Hayley Ritterhern", "Kaylee Johnson", "Lauren Norheim", "Patrick Conaton", "Krista Chew", "Brennan Shacklett", "Gigi Nwagbo", "Neel Ramachandran", "Catherina Xu", "Rishab Mehra", "Konner Robison", "Tyler Dammann", "Brandon Racca", "Sam Premutico", "Jack Herrera", "Souraya Karimi", "Geoff Angus", "Simba", "Julia Doody", "Nathan Petrie"]
            resultHash = {}

            array.each do |member|
                randomNumber = rand(1...99999)
                resultHash[member] = randomNumber
            end
            sorted = resultHash.sort_by{|key, value| value}
            sorted.each do |key, value|
                assassin = Assassin.new()
                assassin.name = key.to_s
                assassin.seed = value.to_i
                assassin.killed = 0
                assassin.last_kill = Time.new
                assassin.save(:validate => false)
            end
        end
        @final = Assassin.activeAssassins(assassins.length.to_i)  
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
end
