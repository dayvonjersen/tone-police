require "java"
require "sinatra"
require "json"

$CLASSPATH << "./Synesketch/bin/"

def getEmotion(message)
    e = JavaUtilities.get_proxy_class("synesketch.emotion.Empathyscope")
    es = e.getInstance().feel(message)

    emo = {
        "Neutral" => es.getValence() == -1 ? 1.0 : 0.0,
        "Happiness" => es.getHappinessWeight(),
        "Sadness" => es.getSadnessWeight(),
        "Fear" => es.getFearWeight(),
        "Anger" => es.getAngerWeight(),
        "Disgust" => es.getDisgustWeight(),
        "Surprise" => es.getSurpriseWeight()
    }

    return emo
end

before do
    content_type 'application/json'
end

configure do
    set :show_exceptions, false
end

not_found do
    return {"error" => "not found"}.to_json
end

error do 
    return {"error" => "error!!"}.to_json
end

post "/" do 
    msg = params[:message]

    if msg == ""
        status 400
        return {"error" => "missing \"message\" input parameter."}.to_json
    end

    #logger.info msg
    return getEmotion(msg).to_json
end
