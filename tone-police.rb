require "java"
require "sinatra"

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

post "/" do 
    @msg = params[:message] || "testing"
    logger.info @msg
    getEmotion(@msg) 
end
