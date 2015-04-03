class CreateAdmin < ActiveRecord::Migration
    def change
        a = User.new(:email => 'jnewcs@stanford.edu', :password => ENV["ADMIN"], :password_confirmation => ENV["ADMIN"])
        a.save()
    end
end
