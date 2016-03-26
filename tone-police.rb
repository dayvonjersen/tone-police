require "java"
require "sinatra"
require "json"

$CLASSPATH << "./Synesketch/bin/"
def getEmotion(message)
    e = JavaUtilities.get_proxy_class("synesketch.emotion.Empathyscope")
    es = e.getInstance().feel(message)
    emo = "Uknown"
    case es.getStrongestEmotion().getType()
        when -1
            emo = "Neutral"
        when 0
            emo = "Happiness"
        when 1
            emo = "Sadness"
        when 2
            emo = "Fear"
        when 3
            emo = "Anger"
        when 4
            emo = "Disgust"
        when 5
            emo = "Surprise"
    end
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

get "/test500" do 
    0/0
end

post "/" do 
    @msg = params[:message] || "testing"
    logger.info @msg
    return {"emotion" => getEmotion(@msg)}.to_json
end
