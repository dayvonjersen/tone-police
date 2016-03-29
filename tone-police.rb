require "java"
require "sinatra"
require "json"

$CLASSPATH << "./Synesketch/bin/"

def getEmotion(message)
    e = JavaUtilities.get_proxy_class("synesketch.emotion.Empathyscope")
    es = e.getInstance().feel(message)

    emo = {
        "Neutral" => es.getValence()*-1,
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

    emo = {}
    cnt = 0
    msg.split("\n").each do |m|
        x = getEmotion(m)
        if cnt == 0
            emo = x
        else
            x.each do |key,score|
                emo[key] += score
            end
        end
        cnt += 1
    end
    emo.each do |key, score|
        emo[key] /= cnt
    end

    logger.info cnt
    logger.info emo.to_json
    return emo.to_json
end
