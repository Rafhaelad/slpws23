require 'sinatra'
require 'slim'
require 'sqlite3'
require 'bcrypt'

enable :sessions

get('/') do
    slim(:register)
end

get('/islogin')
    slim(:login)
end

post('/login') do
    username = params[:username] 
    password = params[:password]
    db = SQLite3::Database.new('db/slutprojekt.db')
    db.results_as_hash = true
    result = db.execute("SELECT * FROM users WHERE username = ?",username).first
    pwdigest = result["pwdigest"]
    id = result["id"]

    if BCrypt::Password.new(pwdigest) == password
        session[:id] = id
        redirect('/music')
    else
        "Wrong password!"
        end
    end

    get('/music') do 
        id = session[:id].to_i
        db = SQLite3:: Database.new('db/slutprojekt.db')
        db.results_as_hash = true
        result = db.execute("SELECT * FROM music user_id = ?", id)
        p "Music från result #{result}"
        slim(:"music/index", locals:{music:result})
    end
    



